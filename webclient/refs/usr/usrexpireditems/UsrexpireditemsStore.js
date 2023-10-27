Ext.define('LES.usr.usrexpireditems.store.UsrexpireditemsStore', {
    extend: 'LES.usr.usrexpireditems.store.MainStore',
    autoLoad: false,
    pageSize: 15,
    fields: [
		{name: 'area', type: 'string'},
		{name: 'location', type: 'string'},
		{name: 'item_number', type: 'string'},
		{name: 'description', type: 'string'},
		{name: 'load', type: 'string'},
		{name: 'total_quantity', type: 'string'},
		{name: 'box_quantity', type: 'string'},
		{name: 'inv_status', type: 'string'},
		{name: 'days_left', type: 'string'},
		{name: 'expiration_date', type: 'string'} 
	]
});