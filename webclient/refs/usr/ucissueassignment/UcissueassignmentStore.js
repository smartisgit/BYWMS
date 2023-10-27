Ext.define('LES.usr.ucissueassignment.store.UcissueassignmentStore', {
    extend: 'LES.usr.ucissueassignment.store.MainStore',
	autoLoad: false,
	storeId: 'UcissueassignmentStore',
	pageSize: 15,
    fields: [
		'uc_ossi_issue_assign_seq',
		'uc_ossi_issue_id',
		'uc_ossi_user_id',
		'uc_ossi_stat_cd',
		'uc_ossi_issue_descr'
	]
});