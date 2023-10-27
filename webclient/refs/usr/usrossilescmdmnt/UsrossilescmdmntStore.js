Ext.define('LES.usr.usrossilescmdmnt.store.UsrossilescmdmntStore', {
    extend: 'LES.usr.usrossilescmdmnt.store.MainStore',
    autoLoad: false,
    pageSize: 15,
    fields: [
		{name: 'les_cmd_id', type: 'string'},
		{name: 'cust_lvl', type: 'string'},
		{name: 'syntax', type: 'string'},
		{name: 'moddte', type: 'date'},
		{name: 'mod_usr_id', type: 'string'},
		{name: 'grp_nam', type: 'string'}
	]
});