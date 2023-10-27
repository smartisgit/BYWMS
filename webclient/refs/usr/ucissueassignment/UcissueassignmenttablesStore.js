Ext.define('LES.usr.ucissueassignment.store.UcissueassignmenttablesStore', {
    extend: 'LES.usr.ucissueassignment.store.MainStore',
    autoLoad: false,
    pageSize: 15,
    fields: [
		{name: 'uc_ossi_obj_name', type: 'string'},
		{name: 'uc_ossi_obj_pk_col', type: 'string'},
		{name: 'uc_ossi_obj_pk_data', type: 'string'},
		{name: 'uc_ossi_obj_key_col', type: 'string'},
		{name: 'uc_ossi_obj_key_data', type: 'string'},
		{name: 'uc_ossi_action', type: 'string'},
		{name: 'uc_ossi_issue_obj_log_seq', type: 'string'},
		{name: 'uc_ossi_fil_cre_dt', type: 'string'},
		{name: 'uc_ossi_commit_dt', type: 'string'},
		{name: 'uc_ossi_revision', type: 'string'},
		{name: 'uc_ossi_issue_assign_seq', type: 'string'}
	]
});