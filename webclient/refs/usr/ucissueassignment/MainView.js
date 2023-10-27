Ext.define('LES.usr.ucissueassignment.view.MainView', {
    extend: 'Ext.panel.Panel',
    alias: 'widget.ucissueassignment',
    itemId: 'ucissueassignment',

    storePrefix: 'LES.usr.ucissueassignment.store.',

    initComponent: function() {
        var store = Ext.StoreManager.lookup(this.storePrefix + 'UcissueassignmentStore');

        Ext.apply(this, {
            autoScroll: true,
            layout: 'fit',
            requires: ['Ext.resizer.Splitter', 'Ext.tab.*', 'Ext.grid.*', 'Ext.data.*'],
            items: [{
                xtype: 'panel',
                minWidth: 850,
                minHeight: 820,
                items: [{
                    xtype: 'panel',
                    collapsible: true,
                    title: 'Grid',
                    itemId: 'gridpanel',
                    items: [
                        this.createGrid(store)
                    ]
                },
                this.createTabs()
                ]
            }],
            bbar: this.createButtonBar()
        });

        this.callParent(arguments);
    },

    createGrid: function(store) {
        return {
            xtype: 'rpuxFilterableGrid',
			itemId: 'ucissueassignment-grid',
			viewConfig: {
                deferEmptyText: false,
                emptyText: '<center><font size="4">' +
                    'To find and maintain an order, enter an order number.' +
                    '</font></center>'
            },
			store: store,
			pagingConfig: true,
			sortableColumns: true,
			selModel: Ext.create('Ext.selection.CheckboxModel', {mode: 'SINGLE'}),
			height: 350,
			filterController: Ext.create('RPUX.FilterController', {
				backend: 'wm',
				filterType: 'LES',
				entityStore: Ext.StoreManager.lookup(this.storePrefix + 'UcissueassignmentStore'),
				localFilter: [
					'uc_ossi_issue_assign_seq',
					'uc_ossi_issue_id',
					'uc_ossi_user_id',
					'uc_ossi_stat_cd',
					'uc_ossi_issue_descr'
				]
			}),
			columns: [
			{
				header: RP.getMessage('les.ossi.misc.uc_ossi_issue_assign_seq'),
				dataIndex: 'uc_ossi_issue_assign_seq'
			},
			{
				header: RP.getMessage('les.ossi.misc.uc_ossi_issue_id'),
				dataIndex: 'uc_ossi_issue_id'
			},
			{
				header: RP.getMessage('les.ossi.misc.uc_ossi_user_id'),
				dataIndex: 'uc_ossi_user_id'
			},
			{
				header: RP.getMessage('les.ossi.misc.uc_ossi_stat_cd'),
				dataIndex: 'uc_ossi_stat_cd'
			},
			{
				header: RP.getMessage('les.ossi.misc.uc_ossi_issue_descr'),
				dataIndex: 'uc_ossi_issue_descr'
			}],
			listeners: {
				selectionchange: this.gridSelectionChange,
				scope: this
			}

        };
    },

    createButtonBar: function() {
        return [
		{
			xtype: 'button',
			action: 'ucissueassignmentcomplete',
			cls: 'bottom-tool-bar-save-button',
			text: RP.getMessage('les.ossi.misc.UC-ISSUE_ASSIGNMENT-COMPLETE'),
			height: 25,
			minWidth: 70,
			disabled: false,
			priority: Ext.button.Button.priority.HIGH
		},
		{
			xtype: 'button',
			action: 'ucissueassignmentcreatetriggers',
			cls: 'bottom-tool-bar-save-button',
			text: RP.getMessage('les.ossi.misc.UC-ISSUE_ASSIGNMENT-CREATE_TRIGGERS'),
			height: 25,
			minWidth: 70,
			disabled: false,
			priority: Ext.button.Button.priority.HIGH
		},
		{
			xtype: 'button',
			action: 'ucissueassignmentportalmsg',
			cls: 'bottom-tool-bar-save-button',
			text: RP.getMessage('les.ossi.misc.UC-ISSUE_ASSIGNMENT-PORTALMSG'),
			height: 25,
			minWidth: 70,
			disabled: false,
			priority: Ext.button.Button.priority.HIGH
		}
		];
    },

    createTabs: function() {
        var tabs = Ext.create('Ext.tab.Panel', {
			plain: true,
			cls: 'nav nav-tabs',
			tabBar: {
				defaults: {
					flex: 1
				}
			},
			margin: '10px 0px 0px 0px',
			items: [
			{
				title: 'General',
				xtype: 'form',
				layout: 'column',
				id: 'ucissueassignment-inputs',
				defaults: { flex: 1, padding: '5px', columnWidth: 0.18},
				items: [
				{
					xtype: 'textfield',
					allowBlank: true,
					readOnly: false,
					fieldLabel: RP.getMessage('les.ossi.misc.uc_ossi_user_id'),
					margin: '0 8px 4px 0',
					itemId: 'uc_ossi_user_id',
					name: 'uc_ossi_user_id'
				},
				{
					xtype: 'textfield',
					allowBlank: true,
					readOnly: false,
					fieldLabel: RP.getMessage('les.ossi.misc.uc_ossi_issue_id'),
					margin: '0 8px 4px 0',
					itemId: 'uc_ossi_issue_id',
					name: 'uc_ossi_issue_id'
				},
				{
					xtype: 'combo',
					store: Ext.create('Ext.data.Store', {
						fields: ['codval', 'lngdsc'],
						autoLoad: true,
						proxy: {
							type: 'rpuxRest',
							url: RP.buildDataServiceUrl('wm', 'jmigrator/process/listdata'),
							reader: { type: 'json', root: 'data' },
							actionMethods: { read: 'POST' },
							paramsAsJson: true
						},
						listeners: {
							beforeload: function(store, operations) {
								operations.params = {command: 'list code descriptions where colnam = "uc_ossi_stat_cd"'};
							}
						}
					}),
					fieldLabel: RP.getMessage('les.ossi.misc.uc_ossi_stat_cd'),
					allowBlank: true,
					readOnly: false,
					queryMode: 'local',
					editable: false,
					displayField: 'lngdsc',
					valueField: 'codval',
					margin: '0 8px 4px 0',
					itemId: 'uc_ossi_stat_cd',
					name: 'uc_ossi_stat_cd'
				},
				{
					xtype: 'textfield',
					allowBlank: true,
					readOnly: false,
					fieldLabel: RP.getMessage('les.ossi.misc.uc_ossi_issue_descr'),
					margin: '0 8px 4px 0',
					itemId: 'uc_ossi_issue_descr',
					name: 'uc_ossi_issue_descr'
				}
				]
			},
			{
				title: RP.getMessage('les.ossi.misc.UC-ISSUE_ASSIGNMENT-TABLES'),
				xtype: 'panel',
				autoScroll: true,
				layout: 'fit',
				height: 325,
				itemId: 'ucissueassignmenttables',
				items: [{
					xtype: 'container',
					items: [
					{
						xtype: 'rpuxFilterableGrid',
						itemId: 'ucissueassignmenttables-grid',
						sortableColumns: true,
						store: Ext.StoreManager.lookup(this.storePrefix + 'UcissueassignmenttablesStore'),
						selModel: Ext.create('Ext.selection.CheckboxModel', {mode: 'SINGLE'}),
					filterController: Ext.create('RPUX.FilterController', {
				backend: 'wm',
				filterType: 'LES',
				entityStore: Ext.StoreManager.lookup(this.storePrefix + 'UcissueassignmenttablesStore'),
				localFilter: [
					'uc_ossi_obj_name',
					'uc_ossi_obj_pk_col',
					'uc_ossi_obj_pk_data',
					'uc_ossi_obj_key_col',
					'uc_ossi_obj_key_data',
					'uc_ossi_action',
					'uc_ossi_issue_obj_log_seq',
					'uc_ossi_fil_cre_dt',
					'uc_ossi_commit_dt',
					'uc_ossi_revision',
					'uc_ossi_issue_assign_seq'
				]
			}),
						columns: [
						{
							header: RP.getMessage('les.ossi.misc.uc_ossi_obj_name'),
							dataIndex: 'uc_ossi_obj_name'
						},
						{
							header: RP.getMessage('les.ossi.misc.uc_ossi_obj_pk_col'),
							dataIndex: 'uc_ossi_obj_pk_col'
						},
						{
							header: RP.getMessage('les.ossi.misc.uc_ossi_obj_pk_data'),
							dataIndex: 'uc_ossi_obj_pk_data'
						},
						{
							header: RP.getMessage('les.ossi.misc.uc_ossi_obj_key_col'),
							dataIndex: 'uc_ossi_obj_key_col'
						},
						{
							header: RP.getMessage('les.ossi.misc.uc_ossi_obj_key_data'),
							dataIndex: 'uc_ossi_obj_key_data'
						},
						{
							header: RP.getMessage('les.ossi.misc.uc_ossi_action'),
							dataIndex: 'uc_ossi_action'
						},
						{
							header: RP.getMessage('les.ossi.misc.uc_ossi_issue_obj_log_seq'),
							dataIndex: 'uc_ossi_issue_obj_log_seq'
						},
						{
							header: RP.getMessage('les.ossi.misc.uc_ossi_fil_cre_dt'),
							dataIndex: 'uc_ossi_fil_cre_dt'
						},
						{
							header: RP.getMessage('les.ossi.misc.uc_ossi_commit_dt'),
							dataIndex: 'uc_ossi_commit_dt'
						},
						{
							header: RP.getMessage('les.ossi.misc.uc_ossi_revision'),
							dataIndex: 'uc_ossi_revision'
						},
						{
							header: RP.getMessage('les.ossi.misc.uc_ossi_issue_assign_seq'),
							dataIndex: 'uc_ossi_issue_assign_seq'
						}
						]
					}
					]
				}],
				bbar: [
				'->',
				{
					xtype: 'button',
					action: 'ucissueassignmentreassignlog',
					cls: 'bottom-tool-bar-save-button',
					text: RP.getMessage('les.ossi.misc.UC-ISSUE_ASSIGNMENT-REASSIGN_LOG'),
					height: 25,
					minWidth: 70,
					disabled: false,
					priority: Ext.button.Button.priority.MEDIUM
				},
				{
					xtype: 'button',
					action: 'ucissueassignmentremovedata',
					cls: 'bottom-tool-bar-save-button',
					text: RP.getMessage('les.ossi.misc.UC-ISSUE_ASSIGNMENT-REMOVE_DATA'),
					height: 25,
					minWidth: 70,
					disabled: false,
					priority: Ext.button.Button.priority.MEDIUM
				},
				{
					xtype: 'button',
					action: 'ucissueassignmentremovelog',
					cls: 'bottom-tool-bar-save-button',
					text: RP.getMessage('les.ossi.misc.UC-ISSUE_ASSIGNMENT-REMOVE_LOG'),
					height: 25,
					minWidth: 70,
					disabled: false,
					priority: Ext.button.Button.priority.MEDIUM
				}
				]
			},
			{
				title: RP.getMessage('les.ossi.misc.UC-ISSUE_ASSIGNMENT-SEAMLES'),
				xtype: 'panel',
				autoScroll: true,
				layout: 'fit',
				height: 325,
				itemId: 'ucissueassignmentseamles',
				items: [{
					xtype: 'container',
					items: [
					{
						xtype: 'rpuxFilterableGrid',
						itemId: 'ucissueassignmentseamles-grid',
						sortableColumns: true,
						store: Ext.StoreManager.lookup(this.storePrefix + 'UcissueassignmentseamlesStore'),
						selModel: Ext.create('Ext.selection.CheckboxModel', {mode: 'SINGLE'}),
					filterController: Ext.create('RPUX.FilterController', {
				backend: 'wm',
				filterType: 'LES',
				entityStore: Ext.StoreManager.lookup(this.storePrefix + 'UcissueassignmentseamlesStore'),
				localFilter: [
					'uc_ossi_obj_grp',
					'uc_ossi_obj_key_col',
					'uc_ossi_obj_key_data',
					'rtnum1',
					'uc_ossi_upd_dt',
					'uc_ossi_fil_cre_dt',
					'uc_ossi_commit_dt',
					'uc_ossi_revision',
					'uc_ossi_issue_assign_seq'
				]
			}),
						columns: [
						{
							header: RP.getMessage('les.ossi.misc.uc_ossi_obj_grp'),
							dataIndex: 'uc_ossi_obj_grp'
						},
						{
							header: RP.getMessage('les.ossi.misc.uc_ossi_obj_key_col'),
							dataIndex: 'uc_ossi_obj_key_col'
						},
						{
							header: RP.getMessage('les.ossi.misc.uc_ossi_obj_key_data'),
							dataIndex: 'uc_ossi_obj_key_data'
						},
						{
							header: RP.getMessage('les.ossi.misc.rtnum1'),
							dataIndex: 'rtnum1'
						},
						{
							header: RP.getMessage('les.ossi.misc.uc_ossi_upd_dt'),
							dataIndex: 'uc_ossi_upd_dt'
						},
						{
							header: RP.getMessage('les.ossi.misc.uc_ossi_fil_cre_dt'),
							dataIndex: 'uc_ossi_fil_cre_dt'
						},
						{
							header: RP.getMessage('les.ossi.misc.uc_ossi_commit_dt'),
							dataIndex: 'uc_ossi_commit_dt'
						},
						{
							header: RP.getMessage('les.ossi.misc.uc_ossi_revision'),
							dataIndex: 'uc_ossi_revision'
						},
						{
							header: RP.getMessage('les.ossi.misc.uc_ossi_issue_assign_seq'),
							dataIndex: 'uc_ossi_issue_assign_seq'
						}
						]
					}
					]
				}],
				bbar: null
			},
			{
				title: RP.getMessage('les.ossi.misc.UC-ISSUE_ASSIGNMENT-FILES'),
				xtype: 'panel',
				autoScroll: true,
				layout: 'fit',
				height: 325,
				itemId: 'ucissueassignmentfiles',
				items: [{
					xtype: 'container',
					items: [
					{
						xtype: 'rpuxFilterableGrid',
						itemId: 'ucissueassignmentfiles-grid',
						sortableColumns: true,
						store: Ext.StoreManager.lookup(this.storePrefix + 'UcissueassignmentfilesStore'),
						selModel: Ext.create('Ext.selection.CheckboxModel', {mode: 'SINGLE'}),
					filterController: Ext.create('RPUX.FilterController', {
				backend: 'wm',
				filterType: 'LES',
				entityStore: Ext.StoreManager.lookup(this.storePrefix + 'UcissueassignmentfilesStore'),
				localFilter: [
					'uc_ossi_obj_name',
					'uc_ossi_obj_pk_data',
					'uc_ossi_action',
					'uc_ossi_issue_obj_log_seq',
					'uc_ossi_fil_cre_dt',
					'uc_ossi_commit_dt',
					'uc_ossi_revision',
					'uc_ossi_issue_assign_seq'
				]
			}),
						columns: [
						{
							header: RP.getMessage('les.ossi.misc.uc_ossi_obj_name'),
							dataIndex: 'uc_ossi_obj_name'
						},
						{
							header: RP.getMessage('les.ossi.misc.uc_ossi_obj_pk_data'),
							dataIndex: 'uc_ossi_obj_pk_data'
						},
						{
							header: RP.getMessage('les.ossi.misc.uc_ossi_action'),
							dataIndex: 'uc_ossi_action'
						},
						{
							header: RP.getMessage('les.ossi.misc.uc_ossi_issue_obj_log_seq'),
							dataIndex: 'uc_ossi_issue_obj_log_seq'
						},
						{
							header: RP.getMessage('les.ossi.misc.uc_ossi_fil_cre_dt'),
							dataIndex: 'uc_ossi_fil_cre_dt'
						},
						{
							header: RP.getMessage('les.ossi.misc.uc_ossi_commit_dt'),
							dataIndex: 'uc_ossi_commit_dt'
						},
						{
							header: RP.getMessage('les.ossi.misc.uc_ossi_revision'),
							dataIndex: 'uc_ossi_revision'
						},
						{
							header: RP.getMessage('les.ossi.misc.uc_ossi_issue_assign_seq'),
							dataIndex: 'uc_ossi_issue_assign_seq'
						}
						]
					}
					]
				}],
				bbar: [
				'->',
				{
					xtype: 'button',
					action: 'ucissueassignmentreassignlog',
					cls: 'bottom-tool-bar-save-button',
					text: RP.getMessage('les.ossi.misc.UC-ISSUE_ASSIGNMENT-REASSIGN_LOG'),
					height: 25,
					minWidth: 70,
					disabled: false,
					priority: Ext.button.Button.priority.MEDIUM
				},
				{
					xtype: 'button',
					action: 'ucissueassignmentremovelog',
					cls: 'bottom-tool-bar-save-button',
					text: RP.getMessage('les.ossi.misc.UC-ISSUE_ASSIGNMENT-REMOVE_LOG'),
					height: 25,
					minWidth: 70,
					disabled: false,
					priority: Ext.button.Button.priority.MEDIUM
				}
				]
			}]
		});
		return tabs;

    },

    gridSelectionChange: function(selModel, record) {
        var form = Ext.getCmp('ucissueassignment-inputs');
		if (record[0]) {
			form.getForm().loadRecord(record[0]);
			Ext.StoreManager.lookup(this.storePrefix + 'UcissueassignmenttablesStore').load({
				params: {command: 'list usr affected objects for issue', uc_ossi_issue_assign_seq: record[0].data.uc_ossi_issue_assign_seq}
			});
			Ext.StoreManager.lookup(this.storePrefix + 'UcissueassignmentseamlesStore').load({
				params: {command: 'list usr affected seamles objects for issue', uc_ossi_issue_assign_seq: record[0].data.uc_ossi_issue_assign_seq}
			});
			Ext.StoreManager.lookup(this.storePrefix + 'UcissueassignmentfilesStore').load({
				params: {command: 'list usr affected files for issue', uc_ossi_issue_assign_seq: record[0].data.uc_ossi_issue_assign_seq}
			});
		} else {
			form.getForm().reset();
			Ext.StoreManager.lookup(this.storePrefix + 'UcissueassignmenttablesStore').load({
				params: {command: 'publish data'}
			});
			Ext.StoreManager.lookup(this.storePrefix + 'UcissueassignmentseamlesStore').load({
				params: {command: 'publish data'}
			});
			Ext.StoreManager.lookup(this.storePrefix + 'UcissueassignmentfilesStore').load({
				params: {command: 'publish data'}
			});
		}

    }
});