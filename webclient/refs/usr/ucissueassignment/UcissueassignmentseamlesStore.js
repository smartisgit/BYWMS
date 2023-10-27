Ext.define('LES.usr.ucissueassignment.store.UcissueassignmentseamlesStore', {
    extend: 'LES.usr.ucissueassignment.store.MainStore',
    autoLoad: false,
    pageSize: 15,
    fields: [
		{name: 'uc_ossi_obj_grp', type: 'string'},
		{name: 'uc_ossi_obj_key_col', type: 'string'},
		{name: 'uc_ossi_obj_key_data', type: 'string'},
		{name: 'rtnum1', type: 'string'},
		{name: 'uc_ossi_upd_dt', type: 'string'},
		{name: 'uc_ossi_fil_cre_dt', type: 'string'},
		{name: 'uc_ossi_commit_dt', type: 'string'},
		{name: 'uc_ossi_revision', type: 'string'},
		{name: 'uc_ossi_issue_assign_seq', type: 'string'}
	]
});