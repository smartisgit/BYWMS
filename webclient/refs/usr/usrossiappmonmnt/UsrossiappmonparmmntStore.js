Ext.define('LES.usr.usrossiappmonmnt.store.UsrossiappmonparmmntStore', {
    extend: 'LES.usr.usrossiappmonmnt.store.MainStore',
    autoLoad: false,
    pageSize: 15,
    fields: [
		{name: 'uc_monitor_id', type: 'string'},
		{name: 'srtseq', type: 'string'},
		{name: 'uc_monitor_param_id', type: 'string'},
		{name: 'uc_monitor_param_val_str', type: 'string'},
		{name: 'uc_monitor_param_val_num1', type: 'string'},
		{name: 'uc_monitor_param_val_num2', type: 'string'},
		{name: 'uc_monitor_param_val_flt1', type: 'string'},
		{name: 'uc_monitor_param_val_flt2', type: 'string'}
	]
});