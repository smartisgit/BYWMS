#include <moca.h>

#include <stdio.h>
#include <string.h>

#include <mocaerr.h>
#include <srvlib.h>
#include <sqllib.h>

/*#include <varerr.h> */
#include <usrossierr.h>


typedef struct
{
   char*          moca_cmd;
   RETURN_STRUCT* rp;
   long           stat;
} uc_cache_moca_cmd_res_typ;

typedef struct uc_cache_catg_struct
{
   char               cache_catg [100];
   MISCACHE*          moca_res_cache;
   struct uc_cache_catg_struct *next;
} uc_cache_catg_typ;

/**/
static long                  initialized = 0;
static uc_cache_catg_typ*    cache_catg_list = NULL;

char*            trace_tag = "***ossiExecuteMOCAAndCache***:";

/* 
 * Support Functions 
 */
static void result_cache_cleanup ( void )
{
   uc_cache_catg_typ* ptr;
   uc_cache_catg_typ* next = NULL;

   misTrc ( T_FLOW, "%s:result_cache_cleanup called", trace_tag );

   for ( ptr = cache_catg_list; ptr != NULL; ptr = next )
   {
      next = ptr->next;

      misTrc ( T_FLOW,"%s:---About to free catg %s, cache ptr %p, next %p",  trace_tag, 
               ptr->cache_catg, ptr->moca_res_cache, ptr->next );
      if ( ptr->moca_res_cache )
      {
         misCacheFree ( ptr->moca_res_cache );
         ptr->moca_res_cache = NULL;
      }

      free ( ptr );
   }
   cache_catg_list = NULL;
   initialized = 0;

   misTrc ( T_FLOW, "%s:result_cache_cleanup finished", trace_tag );
}

static void cache_node_free ( void* payload )
{
   uc_cache_moca_cmd_res_typ* node  = (uc_cache_moca_cmd_res_typ*) payload;

   misTrc ( T_FLOW, "%s:...free called for payload %p", trace_tag, payload );
   if ( node != NULL )
   {
      if ( node->moca_cmd )
      {
         misTrc ( T_FLOW, "%s:...--->moca_cmd was %s",  trace_tag, node->moca_cmd );
         free ( node->moca_cmd );
         node->moca_cmd = NULL;
      }
 
      if ( node->rp )
      {
         misTrc ( T_FLOW, "%s:...--->rp was %p",  trace_tag, node->rp );
         srvFreeMemory(SRVRET_STRUCT, node->rp );
         node->rp = NULL;
      }
   }
   return;
}

static uc_cache_catg_typ* find_cache_catg_node ( char* cache_catg, uc_cache_catg_typ** o_prev )
{
   uc_cache_catg_typ* ret = NULL;
   uc_cache_catg_typ* ptr;
   uc_cache_catg_typ* prev = NULL;


   misTrc ( T_FLOW, "%s:find_cache_catg_node Entered %s", trace_tag, cache_catg ? cache_catg : "(null)");
   for ( ptr = cache_catg_list; ptr != NULL; ptr = ptr->next )
   {
      prev = ptr;
      if ( cache_catg && misCiStrcmp ( ptr->cache_catg, cache_catg ) == 0 )
      {
         ret = ptr;
         break;
      }
   }

   if ( o_prev )
      *o_prev = prev;

   misTrc ( T_FLOW, "%s:find_cache_catg_node Returned %p for %s.  prev was %p ll was %p", trace_tag, ret, cache_catg?cache_catg:"(null)", prev, cache_catg_list);
   return ret;
}


static uc_cache_catg_typ* append_cache_catg_node ( char* cache_catg, int siz )
{
   uc_cache_catg_typ* node = NULL;
   /*uc_cache_catg_typ* ptr = NULL; */
   uc_cache_catg_typ* prev = NULL;

   /*if ( siz == 0 )
      siz = 100; */
 
   if ( (node = calloc ( 1, sizeof (uc_cache_catg_typ))) != NULL )
   {
      strcpy ( node->cache_catg, cache_catg );
      node->moca_res_cache = misCacheInit ( siz, cache_node_free );
      if ( cache_catg_list == NULL )
      {
         misTrc ( T_FLOW, "%s:append_cache_catg_node -->first catg, set global list", trace_tag );
         cache_catg_list = node;
      }
      else
      {
         /* find the tail */
         find_cache_catg_node ( NULL, &prev );
         misTrc ( T_FLOW, "%s:append_cache_catg_node -->add after last %p", trace_tag, prev );
         prev->next = node;
      }
      misTrc ( T_FLOW, "%s:append_cache_catg_node  %s added after %p", trace_tag, cache_catg, prev );
   }
   return node;
}

LIBEXPORT 
RETURN_STRUCT* ossiExecuteMOCAAndCacheFree ( void )
{
   result_cache_cleanup ();
   return  srvResults(eOK,NULL);
}

LIBEXPORT 
RETURN_STRUCT* ossiExecuteMOCAAndCache ( char* cache_catg, char* moca_cmd, long* i_inline, char* cache_key )
{
   RETURN_STRUCT*       ret_rp = NULL;
   long                 stat = eOK;
   mocaDataRes*         res = NULL;
   char*                my_cache_key = NULL;
   uc_cache_catg_typ*   cache_catg_node;
   uc_cache_moca_cmd_res_typ*  cache_key_node = NULL;
   char* cache_size;
   long  cache_size_int = 0;
   /**/
   

   /**/

   /* If cache_key is provided, look by that */
   if ( cache_key && strlen(cache_key) > 0 )
      misDynStrcpy ( &my_cache_key, cache_key );
   else
      misDynStrcpy ( &my_cache_key, moca_cmd );


   if ( !initialized )
   {
      initialized = 1;
      osAtexit ( result_cache_cleanup );
   }

   if ( (cache_catg_node = find_cache_catg_node ( cache_catg, NULL )) == NULL )
   {
      cache_size = osGetVar ( "UC_OSSI_CACHE_SIZE" );
      if ( cache_size && atoi(cache_size) > 0 )
         cache_size_int = atoi(cache_size);

      if ( (cache_catg_node = append_cache_catg_node ( cache_catg, cache_size_int )) == NULL )
      {
         stat = eNO_MEMORY;
         goto end_of_function;
      }
   }

   /*
    * Now find our key in the cache 
    */
   if ( (cache_key_node = misCacheGet ( cache_catg_node->moca_res_cache, my_cache_key )) != NULL )
   {
      /* found in cache */
      misTrc ( T_FLOW, "%s:   found in cache: %s, node %p, RETURN_STRUCT %p, stat %d", trace_tag, my_cache_key, cache_key_node,
               cache_key_node->rp, cache_key_node->stat );

      res = srvGetResults ( cache_key_node->rp );
      srvConcatenateResults ( &ret_rp, res );
      srvSetReturnStatus ( ret_rp, cache_key_node->stat );
   }
   else
   {
      /* not found in cache */
      misTrc ( T_FLOW, "%s:   Not found in cache: %s", trace_tag, my_cache_key );
      if ( (cache_key_node = calloc ( 1, sizeof(uc_cache_catg_typ))) == NULL )
      {
         stat = eNO_MEMORY;
         goto end_of_function;
      }
      if ( misDynStrcpy ( &(cache_key_node->moca_cmd),  moca_cmd ) == NULL )
      {
         stat = eNO_MEMORY;
         goto end_of_function;
      }

      if ( i_inline && *i_inline == 1 )
         stat = srvInitiateInline ( moca_cmd, &ret_rp );
      else
         stat = srvInitiateCommand ( moca_cmd, &ret_rp );

      res = srvGetResults ( ret_rp );
      srvConcatenateResults ( &(cache_key_node->rp), res );
      cache_key_node->stat = stat;

      if ( (stat  = misCachePut ( cache_catg_node->moca_res_cache, my_cache_key, (void*) cache_key_node )) != eOK )
         goto end_of_function;
      
      misTrc ( T_FLOW, "%s:   Added to cache: %s - data ptr %p, return_struct %p stat %d", trace_tag, my_cache_key, cache_key_node,
               cache_key_node->rp, cache_key_node->stat );
   } /* not found in cache */

   
end_of_function:
   if ( my_cache_key != NULL )
      free ( my_cache_key );

   return ret_rp;
}
