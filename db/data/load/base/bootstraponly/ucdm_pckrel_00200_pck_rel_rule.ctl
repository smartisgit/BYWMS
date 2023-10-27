publish data 
where table = 'pck_rel_rule'
and uc_inhibit_version_control = '1'
and wrktyp = '@wrktyp@'
and thresh_flg = '@thresh_flg@'
and dst_mov_zone_id = '@dst_mov_zone_id@'
and action = '@action@'
and group_arg = '@group_arg@'
and oprcod = '@oprcod@'
and baspri = '@baspri@'
and base_pri_offset = '@base_pri_offset@'
and default_flg = '@default_flg@'
and ins_dt = '@ins_dt@'
and last_upd_dt = '@last_upd_dt@'
and ins_user_id = '@ins_user_id@'
and last_upd_user_id = '@last_upd_user_id@'
and pck_mthd_nam = '@pck_mthd_nam@'
and mov_zone_cod = '@mov_zone_cod@'
and wh_id = '@wh_id@'
|
{
    if ( @wh_id = 'WMD1' )
        [
        select wh_id
        from wh
        order by 1
        ]
    |
    [
    select mov_zone_id
    from mov_zone
    where mov_zone_cod = @mov_zone_cod
    and wh_id = @wh_id
    ]
    catch(-1403, 510)
    |
    [
    select pck_mthd_id 
    from UCDM_PCKREL_00200_PCK_REL_RULE 
    where 1=1 
    and pck_mthd_nam = @pck_mthd_nam
    and wh_id = @wh_id
    and wrktyp = @wrktyp
    and oprcod = @oprcod
    ] 
    catch(-1403, 510)
    |
    if ( @? != 0 )
    {    
        [
        select pck_mthd_id 
        from UCDM_PCKREL_00100_PCK_MTHD 
        where 1=1 
        and pck_mthd_nam = @pck_mthd_nam
        and wh_id = @wh_id
        ]
        catch(-1403, 510)
        |
        create pick release rule where uc_called_from_mload = '1' catch(802)
    }
    else
    {
        change pick release rule where uc_called_from_mload = '1' catch(802)
    }
}
