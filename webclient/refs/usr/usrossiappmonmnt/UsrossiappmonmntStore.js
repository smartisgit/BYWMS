Ext.define('LES.usr.usrossiappmonmnt.store.UsrossiappmonmntStore', {
    extend: 'LES.usr.usrossiappmonmnt.store.MainStore',
    autoLoad: false,
    pageSize: 15,
    fields: [
		{name: 'uc_monitor_id', type: 'string'},
		{name: 'uc_monitor_descr', type: 'string'},
		{name: 'ena_flg', type: 'boolean'},
		{name: 'uc_check_cmd', type: 'string'},
		{name: 'uc_fix_cmd', type: 'string'},
		{name: 'uc_raise_ems_alert_on_fail_flg', type: 'string'},
		{name: 'uc_log_mon_dlytrn_flg', type: 'string'},
		{name: 'uc_mon_srtseq', type: 'string'},
		{name: 'uc_time_since_last_run', type: 'string'},
		{name: 'ins_dt', type: 'date'},
		{name: 'last_upd_dt', type: 'date'},
		{name: 'ins_user_id', type: 'string'},
		{name: 'last_upd_user_id', type: 'string'}
	]
});