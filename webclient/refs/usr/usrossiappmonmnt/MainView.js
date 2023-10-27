Ext.define('LES.usr.usrossiappmonmnt.view.MainView', {
    extend: 'Ext.panel.Panel',
    alias: 'widget.usrossiappmonmnt',
    itemId: 'usrossiappmonmnt',

    storePrefix: 'LES.usr.usrossiappmonmnt.store.',

    initComponent: function() {
        var store = Ext.StoreManager.lookup(this.storePrefix + 'UsrossiappmonmntStore');

        Ext.apply(this, {
            autoScroll: true,
            layout: 'fit',
            requires: ['Ext.resizer.Splitter', 'Ext.tab.*', 'Ext.grid.*', 'Ext.data.*'],
            items: [{
                xtype: 'panel',
                minWidth: 850,
                minHeight: 1200,
				autoHeight: true,
				autoScroll: true,
                items: [{
                    xtype: 'panel',
                    collapsible: true,
                    title: 'Grid',
                    itemId: 'gridpanel',
                    items: [
                        this.createGrid(store)
                    ]
                },
				this.createpanel(),
				this.createTabs()
                ]
            }],
			bbar:null
        });

        this.callParent(arguments);
    },

    createGrid: function(store) {
        return {
            xtype: 'rpuxFilterableGrid',
			id:'maingrid',
			itemId: 'usrossiappmonmnt-grid',
			viewConfig: {
                deferEmptyText: false,
                emptyText: '<center><font size="4">' +
                    'To find and maintain data, enter an identifier.' +
                    '</font></center>'
            },
			store: store,
			pagingConfig: true,
			sortableColumns: true,
			selModel: Ext.create('Ext.selection.CheckboxModel', {mode: 'SINGLE'}),
			height: 300,
			filterController: Ext.create('RPUX.FilterController', {
				backend: 'wm',
				filterType: 'LES',
				entityStore: Ext.StoreManager.lookup(this.storePrefix + 'UsrossiappmonmntStore'),
				localFilter: [
					'uc_monitor_id',
					'uc_monitor_descr',
					'ena_flg',
					'uc_check_cmd',
					'uc_fix_cmd',
					'uc_raise_ems_alert_on_fail_flg',
					'uc_log_mon_dlytrn_flg',
					'uc_mon_srtseq',
					'uc_time_since_last_run',
					'ins_dt',
					'last_upd_dt',
					'ins_user_id',
					'last_upd_user_id'
				]
			}),
			plugins:[{
				ptype: 'rpExportableGrid',
				exportFormats: [
					new RP.data.model.Format({ format: 'pdf', display: 'PDF' }),
					new RP.data.model.Format({ format: 'csv', display: 'CSV' })
				]
			}],
			columns: [
			{
				header: RP.getMessage('les.ossi.misc.uc_monitor_id'),
				dataIndex: 'uc_monitor_id'
			},
			{
				header: RP.getMessage('les.ossi.misc.uc_monitor_descr'),
				dataIndex: 'uc_monitor_descr'
			},		
			{
				header: RP.getMessage('les.ossi.misc.ena_flg'),
				dataIndex: 'ena_flg',
				renderer: WM.util.Renderers.checkMarkRenderer
			},
			{
				header: RP.getMessage('les.ossi.misc.uc_check_cmd'),
				dataIndex: 'uc_check_cmd'
			},
			{
				header: RP.getMessage('les.ossi.misc.uc_fix_cmd'),
				dataIndex: 'uc_fix_cmd'
			},
			{
				header: RP.getMessage('les.ossi.misc.uc_raise_ems_alert_on_fail_flg'),
				dataIndex: 'uc_raise_ems_alert_on_fail_flg'
			},
			{
				header: RP.getMessage('les.ossi.misc.uc_log_mon_dlytrn_flg'),
				dataIndex: 'uc_log_mon_dlytrn_flg'
			},
			{
				header: RP.getMessage('les.ossi.misc.uc_mon_srtseq'),
				dataIndex: 'uc_mon_srtseq'
			},
			{
				header: RP.getMessage('les.ossi.misc.uc_time_since_last_run'),
				dataIndex: 'uc_time_since_last_run'
			},
			{
				header: RP.getMessage('les.ossi.misc.ins_dt'),
				dataIndex: 'ins_dt',
				renderer: WM.util.Renderers.dateTimeRenderer
			},
			{
				header: RP.getMessage('les.ossi.misc.last_upd_dt'),
				dataIndex: 'last_upd_dt',
				renderer: WM.util.Renderers.dateTimeRenderer
			},
			{
				header: RP.getMessage('les.ossi.misc.ins_user_id'),
				dataIndex: 'ins_user_id'
			},
			{
				header: RP.getMessage('les.ossi.misc.last_upd_user_id'),
				dataIndex: 'last_upd_user_id'
			}
			]
        };
    },
	
	createpanel: function() { 
		var pan=Ext.create('Ext.panel.Panel', {
			items: [{
				xtype: 'form',
				layout: 'vbox',
				width:'800',
				id: 'usrossiappmonmnt-inputs2',
				itemId: 'usrossiappmonmnt-inputs2',
				defaults: { flex: 1, padding: '5px', columnWidth: 3.18},
				items: [
				{
					xtype: 'panel',
					items: [
					{
						xtype: 'panel',
						layout:'hbox',
						header: false,
						width:800,
						items: [{
									xtype: 'textfield',
									allowBlank: false,
									readOnly: false,
									width: 650,
									id:'mon_id',
									fieldLabel: RP.getMessage('les.ossi.misc.uc_monitor_id')+" : ",
									labelAlign: 'right',
									labelWidth: 170,
									itemId: 'uc_monitor_id',
									name: 'uc_monitor_id'
								}]
					},
					{
						xtype: 'panel',
						layout:'hbox',
						header: false,
						width:800,
								items: [{
									xtype: 'textarea',
									fieldLabel: RP.getMessage('les.ossi.misc.uc_monitor_descr')+" : ",
									labelAlign: 'right',
									labelWidth: 170,
									id: 'mondes',
									itemId: 'uc_monitor_descr',
									name: 'uc_monitor_descr',
									allowBlank: true,
									readOnly: false,
									resizable: true,
									resizeHandles: 'se',
									width: 780,								
									height: 70
									
								}],
								fbar: [{
									xtype: 'panel',
									layout: {
										type: 'hbox',
										align: 'bottom',
										border: false,
										pack: 'end'
									},
									items: [{
										xtype: 'button',
										glyph: RP.Glyphs.Edit.value,
										listeners: {
											click: function () {
												Ext.create('Ext.window.Window', {
													title: RP.getMessage('les.ossi.misc.uc_monitor_descr'),
													height: 400,
													width: 500,
													layout: 'auto',
													closeAction: 'destroy',
													items: [{
														xtype: 'textarea',
														margins: '10px 0px 0px 0px',
														id: 'mondestext',
														value: Ext.getCmp('mondes').getValue(),
														allowBlank: false,
														width: 500,
														height: 400,
														listeners: {
															change: function () {
																if (this.getValue().length > 0) {

																	Ext.getCmp('atsubmit').setDisabled(false);
																} else {
																	Ext.getCmp('atsubmit').setDisabled(true);
																}
															}
														}
													}],
													buttons: [{
														text: 'Submit',
														disabled: true,
														id: 'atsubmit',
														listeners: {
															click: function () {

																Ext.getCmp('mondes').setValue(Ext.getCmp('mondestext').getValue());
																this.up('window').close();
															}
														}
													}, {
														text: 'Cancel',
														margins: '5px 0px 0px 0px',
														listeners: {
															click: function () {
																this.up('window').close();
															}
														}
													}],
													listeners: {
														show: function(){
															Ext.getCmp('mondestext').focus();
														}
													}
												}).show();
											}
										}
									}]
								}]
					
					},
					{
						xtype: 'textfield',
						allowBlank: true,
						id:'msrtseq',
						readOnly: false,
						fieldLabel: RP.getMessage('les.ossi.misc.uc_mon_srtseq')+" : ",
						labelAlign: 'right',
						labelWidth: 170,
						margin: '0 8px 4px 0',
						itemId: 'uc_mon_srtseq',
						name: 'uc_mon_srtseq'
					},
					{
						xtype: 'textfield',
						id:'msinlstrun',
						allowBlank: true,
						readOnly: false,
						fieldLabel: RP.getMessage('les.ossi.misc.uc_time_since_last_run')+" : ",
						labelAlign: 'right',
						labelWidth: 170,
						margin: '0 8px 4px 0',
						itemId: 'uc_time_since_last_run',
						name: 'uc_time_since_last_run'
					}
					]
				}
			]
			}]
		});
	return pan;
	},
	
    createTabs: function() {
        var tabs = Ext.create('Ext.tab.Panel', {
			plain: true,
			autoScroll: true,
			minheight: 800,
			minWidth:  200,
			frame: true,
			defaults: {
			  autoHeight: true,
			  layout: 'fit'
			},
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
				minheight: 800,
				minWidth:  200,
				autoScroll: true,
				id: 'usrossiappmonmnt-inputs',
				itemId: 'usrossiappmonmnt-inputs',
				defaults: { flex: 1, padding: '5px'},
				items: [
				{
					xtype: 'panel',
					minWidth:'200',
					layout: 'column',
					items: [
					
							{
								xtype: 'checkbox',
								id:'ena_flg',
								fieldLabel: RP.getMessage('les.ossi.misc.ena_flg'),
								labelAlign: 'right',
								labelWidth: 150,
								margin: '0 8px 4px 0',
								itemId: 'ena_flg',
								name: 'ena_flg',
								allowBlank: false,
								readOnly: false
							},
							{
								xtype: 'checkbox',
								id:'fail_flg',
								fieldLabel: RP.getMessage('les.ossi.misc.uc_raise_ems_alert_on_fail_flg'),
								labelAlign: 'right',
								labelWidth: 200,
								margin: '0 8px 4px 0',
								itemId: 'uc_raise_ems_alert_on_fail_flg',
								name: 'uc_raise_ems_alert_on_fail_flg',
								allowBlank: false,
								readOnly: false
							},
							{
								xtype: 'checkbox',
								id:'dlytrn_flg',
								fieldLabel: RP.getMessage('les.ossi.misc.uc_log_mon_dlytrn_flg'),
								labelAlign: 'right',
								labelWidth: 150,
								margin: '0 8px 4px 0',
								itemId: 'uc_log_mon_dlytrn_flg',
								name: 'uc_log_mon_dlytrn_flg',
								allowBlank: false,
								readOnly: false
							}				
								
					]
				},
				{
					xtype: 'panel',
					minWidth:'200',
					defaults: {
					  autoHeight: true
					},
					layout: 'hbox',
					items: [
					
						{

						xtype: 'panel',
						layout:'hbox',
						width:750,

								items: [{
									xtype: 'textarea',
									fieldLabel: RP.getMessage('les.ossi.misc.uc_check_cmd')+" : ",
									labelAlign: 'right',
									labelWidth: 160,
									id: 'chccmd',
									itemId: 'uc_check_cmd',
									name: 'uc_check_cmd',
									allowBlank: true,
									readOnly: false,
									resizable: true,
									resizeHandles: 'se',
									width: 730,								
									height: 550
									
								}],
								fbar: [{
									xtype: 'panel',
									layout: {
										type: 'hbox',
										align: 'bottom',
										border: false,
										pack: 'end'
									},
									items: [{
										xtype: 'button',
										glyph: RP.Glyphs.Edit.value,
										listeners: {
											click: function () {
												Ext.create('Ext.window.Window', {
													title: RP.getMessage('les.ossi.misc.uc_check_cmd'),
													height: 400,
													width: 500,
													layout: 'auto',
													closeAction: 'destroy',
													items: [{
														xtype: 'textarea',
														margins: '10px 0px 0px 0px',
														id: 'chccmdtext',
														value: Ext.getCmp('chccmd').getValue(),
														allowBlank: false,
														width: 500,
														height: 400,
														listeners: {
															change: function () {
																if (this.getValue().length > 0) {

																	Ext.getCmp('cmdtstsub').setDisabled(false);
																} else {
																	Ext.getCmp('cmdtstsub').setDisabled(true);
																}
															}
														}
													}],
													buttons: [{
														text: 'Submit',
														disabled: true,
														id: 'cmdtstsub',
														listeners: {
															click: function () {

																Ext.getCmp('chccmd').setValue(Ext.getCmp('chccmdtext').getValue());
																this.up('window').close();
															}
														}
													}, {
														text: 'Cancel',
														margins: '5px 0px 0px 0px',
														listeners: {
															click: function () {
																this.up('window').close();
															}
														}
													}],
													listeners: {
														show: function(){
															Ext.getCmp('chccmdtext').focus();
														}
													}
												}).show();
											}
										}
									}]
								}]
						
					},	
					{

						xtype: 'panel',
						layout:'column',
						header: false,
						width:750,

								items: [{
									xtype: 'textarea',
									fieldLabel: RP.getMessage('les.ossi.misc.uc_fix_cmd')+" : ",
									labelAlign: 'right',
									labelWidth: 100,
									id: 'fixcmd',
									itemId: 'uc_fix_cmd',
									name: 'uc_fix_cmd',
									allowBlank: true,
									readOnly: false,
									resizable: true,
									resizeHandles: 'se',
									width: 730,	
									height: 550
									
								}],
								fbar: [{
									xtype: 'panel',
									layout: {
										type: 'hbox',
										align: 'bottom',
										border: false,
										pack: 'end'
									},
									items: [{
										xtype: 'button',
										glyph: RP.Glyphs.Edit.value,
										listeners: {
											click: function () {
												Ext.create('Ext.window.Window', {
													title: RP.getMessage('les.ossi.misc.uc_fix_cmd'),
													height: 400,
													width: 500,
													layout: 'auto',
													closeAction: 'destroy',
													items: [{
														xtype: 'textarea',
														margins: '10px 0px 0px 0px',
														id: 'fixcmdtext',
														value: Ext.getCmp('fixcmd').getValue(),
														allowBlank: false,
														width: 500,
														height: 400,
														listeners: {
															change: function () {
																if (this.getValue().length > 0) {

																	Ext.getCmp('fixtstsub').setDisabled(false);
																} else {
																	Ext.getCmp('fixtstsub').setDisabled(true);
																}
															}
														}
													}],
													buttons: [{
														text: 'Submit',
														disabled: true,
														id: 'fixtstsub',
														listeners: {
															click: function () {

																Ext.getCmp('fixcmd').setValue(Ext.getCmp('fixcmdtext').getValue());
																this.up('window').close();
															}
														}
													}, {
														text: 'Cancel',
														margins: '5px 0px 0px 0px',
														listeners: {
															click: function () {
																this.up('window').close();
															}
														}
													}],
													listeners: {
														show: function(){
															Ext.getCmp('fixcmdtext').focus();
														}
													}
												}).show();
											}
										}
									}]
								}]
						
				}
				
					]
				}
				]
			},
			{
				title: RP.getMessage('les.ossi.misc.USR_OSSI_APP_MON_PARM_MNT'),
				xtype: 'panel',
				height: 600,
				itemId: 'usrossiappmonparmmnt',
				items:[{
					xtype: 'panel',
					autoScroll: true,
					containerScroll: true,
					overflowY: 'scroll',
				items: [{
					
					
					items: [
					{
						xtype: 'rpuxFilterableGrid',
						itemId: 'usrossiappmonparmmnt-grid',
						sortableColumns: true,
						id:'tabgrid',
						height: 300,
						viewConfig: {
							deferEmptyText: false,
							emptyText: '<center><font size="4">' +
								'To find and maintain data, enter an identifier.' +
								'</font></center>'
						},
						pagingConfig: true,
						store: Ext.StoreManager.lookup(this.storePrefix + 'UsrossiappmonparmmntStore'),
						selModel: Ext.create('Ext.selection.CheckboxModel', {mode: 'SINGLE'}),
						filterController: Ext.create('RPUX.FilterController', {
							backend: 'wm',
							filterType: 'LES',
							entityStore: Ext.StoreManager.lookup(this.storePrefix + 'UsrossiappmonparmmntStore'),
							localFilter: [
								'uc_monitor_id',
								'srtseq',
								'uc_monitor_param_id',
								'uc_monitor_param_val_str',
								'uc_monitor_param_val_num1',
								'uc_monitor_param_val_num2',
								'uc_monitor_param_val_flt1',
								'uc_monitor_param_val_flt2'
							]
						}),
						columns: [
						{
							header: RP.getMessage('les.ossi.misc.uc_monitor_id'),
							dataIndex: 'uc_monitor_id'
						},
						{
							header: RP.getMessage('les.ossi.misc.srtseq'),
							dataIndex: 'srtseq'
						},
						{
							header: RP.getMessage('les.ossi.misc.uc_monitor_param_id'),
							dataIndex: 'uc_monitor_param_id'
						},
						{
							header: RP.getMessage('les.ossi.misc.uc_monitor_param_val_str'),
							dataIndex: 'uc_monitor_param_val_str'
						},
						{
							header: RP.getMessage('les.ossi.misc.uc_monitor_param_val_num1'),
							dataIndex: 'uc_monitor_param_val_num1'
						},
						{
							header: RP.getMessage('les.ossi.misc.uc_monitor_param_val_num2'),
							dataIndex: 'uc_monitor_param_val_num2'
						},
						{
							header: RP.getMessage('les.ossi.misc.uc_monitor_param_val_flt1'),
							dataIndex: 'uc_monitor_param_val_flt1'
						},
						{
							header: RP.getMessage('les.ossi.misc.uc_monitor_param_val_flt2'),
							dataIndex: 'uc_monitor_param_val_flt2'
						}
						]
					}
					]
				}]
				
				}],
				bbar: [
				'->',
				{
					xtype: 'button',
					action: 'usrossiappmonparmmnta',
					id:'mpaddbtn',
					cls: 'bottom-tool-bar-save-button',
					text: RP.getMessage('les.ossi.misc.USR_OSSI_APP_MON_PARM_MNT-A'),
					height: 25,
					minWidth: 70,
					disabled: true,
					priority: Ext.button.Button.priority.MEDIUM
				},
				{
					xtype: 'button',
					action: 'usrossiappmonparmmntc',
					id:'mpchgbtn',
					cls: 'bottom-tool-bar-save-button',
					text: RP.getMessage('les.ossi.misc.USR_OSSI_APP_MON_PARM_MNT-C'),
					height: 25,
					minWidth: 70,
					disabled: true,
					priority: Ext.button.Button.priority.MEDIUM
				},
				{
					xtype: 'button',
					action: 'usrossiappmonparmmntr',
					id:'mpdelbtn',
					cls: 'bottom-tool-bar-save-button',
					text: RP.getMessage('les.ossi.misc.USR_OSSI_APP_MON_PARM_MNT-R'),
					height: 25,
					minWidth: 70,
					disabled: true,
					priority: Ext.button.Button.priority.MEDIUM
				}
				]
			
			}]
		});
		return tabs;

    }
});