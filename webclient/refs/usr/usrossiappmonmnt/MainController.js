Ext.define('LES.usr.usrossiappmonmnt.controller.MainController', {
	extend: 'Ext.app.Controller',
	storePrefix: 'LES.usr.usrossiappmonmnt.store.',

    refs: [          
	{
		ref: 'main',
		selector: 'usrossiappmonmnt'
	}, {
		ref: 'usrossiappmonmntGrid',
		selector: '#usrossiappmonmnt-grid'
	}, {
        ref: 'MainGrid',
        selector: '#maingrid'
	}, {
        ref: 'TabGrid',
        selector: '#tabgrid'
	}, {
		ref: 'inputs',
		selector: '#usrossiappmonmnt-inputs'
	}, {
		ref: 'inputs2',
		selector: '#usrossiappmonmnt-inputs2'
	}, {
		ref: 'gridPanel',
		selector: '#gridpanel'
	}, {
		ref: 'btnNew',
		selector: '#btnnew'
	}, {
		ref: 'btnSave',
		selector: '#btnsave'
	}, {
		ref: 'btnClear',
		selector: '#btnclear'
	}, {
		ref: 'btnDelete',
		selector: '#btndelete'
	}, {
		ref: 'btnFind',
		selector: '#btnfind'
	}, {
		ref: 'btnCopy',
		selector: '#btncopy'
	}, {
		ref: 'monid',
		selector: '#mon_id'
	},  {
		ref: 'tabs',
		selector: '#tabs'
	},
	{
		ref: 'tabs',
		selector: '#tabs'
	},
	{
		ref: 'usrossiappmonparmmntGrid',
		selector: '#usrossiappmonparmmnt-grid'
	}],

    init: function() {
        this.application.on({
            activate: this.onActivate,
            deactivate: this.onDeActivate,
            scope: this
        });
		
        this.control({
			
            'usrossiappmonmnt #usrossiappmonmnt-grid': {
                selectionchange: function(grid, selected) {
					if (selected.length > 0) {
						this.controlBtnCopy(true);
						this.controlBtnSave(true);
						this.controlBtnDelete(true);
						this.getInputs().action = 'edit';
					} else {
						this.controlBtnCopy(false);
						this.controlBtnSave(false);
						this.controlBtnDelete(false);
						this.getInputs().action = 'add';
					}
					var form = Ext.getCmp('usrossiappmonmnt-inputs');
					var form2 = Ext.getCmp('usrossiappmonmnt-inputs2');
					if (selected[0]) {
						form.getForm().loadRecord(selected[0]);
						form2.getForm().loadRecord(selected[0]);
			
						Ext.StoreManager.lookup(this.storePrefix + 'UsrossiappmonparmmntStore').load({
						params: {command: 'list ossi app monitor parameters', uc_monitor_id: selected[0].data.uc_monitor_id},
						callback: function(selected, options, success) {
							if (!success) 
								{
								var temp = Ext.StoreManager.lookup(this.storePrefix + 'UsrossiappmonparmmntStore');
								Ext.getCmp('tabgrid').getStore().removeAll();
							
								}
							}				
						});
			
					} 
					else 
					{
						Ext.StoreManager.lookup(this.storePrefix + 'UsrossiappmonparmmntStore').load({
						params: {command: 'publish data'}
						});
						form.getForm().reset();
					}
				}
            },
            '#btnfind': {
                click: this.onFindClick
            },
            '#btnclear': {
                click: this.onClearClick
            },
            '#btnnew': {
                click: this.onAddClick
            },
            '#btnsave': {
                click: this.onSaveClick
            },
            '#btncopy': {
                click: this.onCopyClick
            },
            '#btndelete': {
                click: this.onDeleteClick
            },
			'#btnokadd': {
                click: this.savemonparm
            },
			
			'#usrossiappmonparmmnt button[action=usrossiappmonparmmnta]': {
				click: this.usrossiappmonparmmntaUSROSSIAPPMONPARMMNT
			},
			'#usrossiappmonparmmnt button[action=usrossiappmonparmmntc]': {
				click: this.usrossiappmonparmmntcUSROSSIAPPMONPARMMNT
			},
			'#usrossiappmonparmmnt button[action=usrossiappmonparmmntr]': {
				click: this.usrossiappmonparmmntrUSROSSIAPPMONPARMMNT
			}
        });

        this.callParent(arguments);
    },

    onActivate: function() {
        this.controlBtnSave(false);
		this.controlBtnDelete(false);
		this.controlBtnSave(false);
		this.controlBtnCopy(false);
		this.controlGridPanel(false);

    },

    onDeActivate: function() {},

    performRefresh: function() {
      
    },

    onAddClick: function() {
		
		
		Ext.getCmp('mon_id').setValue('');
        Ext.getCmp('mon_id').setReadOnly(false);
		Ext.getCmp('mondes').setValue('');
        Ext.getCmp('mondes').setReadOnly(false);
		Ext.getCmp('msrtseq').setValue('');
        Ext.getCmp('msrtseq').setReadOnly(false);
		Ext.getCmp('msinlstrun').setValue('');
        Ext.getCmp('msinlstrun').setReadOnly(false);
		
		Ext.getCmp('chccmd').setReadOnly(false);
		Ext.getCmp('chccmd').setValue('');
		Ext.getCmp('fixcmd').setReadOnly(false);
		Ext.getCmp('fixcmd').setValue('');
		
		Ext.getCmp('fail_flg').setValue(false);
		Ext.getCmp('dlytrn_flg').setValue(false);
		Ext.getCmp('ena_flg').setValue(false);
				
		this.controlBtnSave(true);
		
    },

    onFindClick: function() {
        
		var queryString = {};
		
		queryString.command = 'list ossi app monitors';
			
		if(Ext.getCmp('chccmd').getValue()!==null && Ext.getCmp('chccmd').getValue()!==""){
		queryString.uc_check_cmd = Ext.getCmp('chccmd').getValue();
		}
		if(Ext.getCmp('fixcmd').getValue()!==null && Ext.getCmp('fixcmd').getValue()!==""){
		queryString.uc_fix_cmd = Ext.getCmp('mondes').getValue();
		}
			
		
		if(Ext.getCmp('mon_id').getValue()!==null && Ext.getCmp('mon_id').getValue()!==""){
		queryString.uc_monitor_id = Ext.getCmp('mon_id').getValue();
		}
		if(Ext.getCmp('mondes').getValue()!==null && Ext.getCmp('mondes').getValue()!==""){
		queryString.uc_monitor_descr = Ext.getCmp('mondes').getValue();
		}
		if(Ext.getCmp('msrtseq').getValue()!==null && Ext.getCmp('msrtseq').getValue()!==""){
		queryString.uc_mon_srtseq = Ext.getCmp('msrtseq').getValue();
		}
		if(Ext.getCmp('msinlstrun').getValue()!==null && Ext.getCmp('msinlstrun').getValue()!==""){
		queryString.uc_time_since_last_run = Ext.getCmp('msinlstrun').getValue();
		}
		if(Ext.getCmp('ena_flg').getValue()!==Ext.getCmp('fail_flg').getValue() && Ext.getCmp('ena_flg').getValue()!==Ext.getCmp('dlytrn_flg').getValue()){
			queryString.ena_flg = Ext.getCmp('ena_flg').getValue();

		}
		var store = Ext.StoreManager.lookup('LES.usr.usrossiappmonmnt.store.UsrossiappmonmntStore');
		store.load({
			scope: this,
			params: queryString,
			callback: function() {
				this.getInputs().action = 'edit';
				if (store.getCount() > 0) {
					this.getGridPanel().expand(true);
				} else {
					this.onClearClick();
				}
			}
		});
	
		Ext.getCmp('mon_id').setDisabled(true);
		Ext.getCmp('mpaddbtn').setDisabled(false);
		Ext.getCmp('mpchgbtn').setDisabled(false);
		Ext.getCmp('mpdelbtn').setDisabled(false);
    },

    onClearClick: function() {
        var storesList = Ext.data.StoreManager.getRange();
		Ext.Array.each(storesList, function(store, index) {
			if (Ext.String.startsWith(store.storeId, 'LES', true) && !Ext.String.endsWith(store.storeId, 'MainStore', true)) {
				store.load({
					params: {command: 'publish data'}
				});
			}
		});

		if (this.getInputs()) {
			var inputFields = this.getInputs().items.getRange();
			Ext.Array.each(inputFields, function(input, index) {
				if (!input.disabled) {
					console.log(input);
				}
			});
		}
		
		
		Ext.getCmp('chccmd').setValue('');
		Ext.getCmp('fixcmd').setValue('');
		Ext.getCmp('ena_flg').setValue(false);
		Ext.getCmp('fail_flg').setValue(false);
		Ext.getCmp('dlytrn_flg').setValue(false);
		
		Ext.getCmp('mon_id').setDisabled(false);
		
		Ext.getCmp('mon_id').setValue('');
		Ext.getCmp('mondes').setValue('');
		Ext.getCmp('msrtseq').setValue('');
		Ext.getCmp('msinlstrun').setValue('');
		Ext.getCmp('mpaddbtn').setDisabled(true);
		Ext.getCmp('mpchgbtn').setDisabled(true);
		Ext.getCmp('mpdelbtn').setDisabled(true);

		if (this.getTabs()) {
			this.getTabs().setActiveTab(0);
		}

		this.getGridPanel().collapse(true);
		this.getGridPanel().focus();
		this.controlBtnSave(false);
		this.controlBtnDelete(false);
		this.controlBtnFind(true);
		this.controlBtnNew(true);

		this.getInputs().action = 'edit';
		
    },

    onDeleteClick: function () {
                    var prams = {};

                    if (Ext.getCmp('maingrid').getSelectionModel().hasSelection()) {
						
						var uc_monitor_id= Ext.getCmp('mon_id').getValue(),
						uc_monitor_descr= Ext.getCmp('mondes').getValue(),
						ena_flg= Ext.getCmp('ena_flg').getValue(),
						uc_check_cmd= Ext.getCmp('chccmd').getValue(),
						uc_fix_cmd= Ext.getCmp('fixcmd').getValue(),
						uc_raise_ems_alert_on_fail_flg= Ext.getCmp('fail_flg').getValue(),
						uc_log_mon_dlytrn_flg= Ext.getCmp('dlytrn_flg').getValue(),
						uc_mon_srtseq= Ext.getCmp('msrtseq').getValue(),
						uc_time_since_last_run= Ext.getCmp('msinlstrun').getValue();
						
						console.log('uc_monitor_id');console.log(Ext.getCmp('mon_id').getValue());
						console.log('uc_monitor_descr');console.log(Ext.getCmp('mondes').getValue());
						console.log('ena_flg');console.log(Ext.getCmp('ena_flg').getValue());
						console.log('uc_check_cmd');console.log(Ext.getCmp('chccmd').getValue());
						console.log('uc_fix_cmd');console.log(Ext.getCmp('fixcmd').getValue());
						console.log('uc_raise_ems_alert_on_fail_flg');console.log(Ext.getCmp('fail_flg').getValue());
						console.log('uc_log_mon_dlytrn_flg');console.log(Ext.getCmp('dlytrn_flg').getValue());
						console.log('uc_mon_srtseq');console.log(Ext.getCmp('msrtseq').getValue());
						console.log('uc_time_since_last_run');console.log(Ext.getCmp('msinlstrun').getValue());
					
						prams.uc_monitor_id=uc_monitor_id;
						prams.uc_monitor_descr=uc_monitor_descr;
						prams.ena_flg=ena_flg;
						prams.uc_check_cmd=uc_check_cmd;
						prams.uc_fix_cmd=uc_fix_cmd;
						prams.uc_raise_ems_alert_on_fail_flg=uc_raise_ems_alert_on_fail_flg;
						prams.uc_log_mon_dlytrn_flg=uc_log_mon_dlytrn_flg;
						prams.uc_mon_srtseq=uc_mon_srtseq;
						prams.uc_time_since_last_run=uc_time_since_last_run;
						
					    prams.command = 'remove ossi app monitor';

                        Ext.Ajax.request({
                            url: RP.buildDataServiceUrl('wm', 'jmigrator/process/deletedata'),
                            jsonData: prams,
                            method: 'POST',
                            scope: this,
                            callback: function (request, success, response) {

                                if (success) {
                                    if (Ext.getCmp('maingrid').getStore().getCount() == 1) {
										Ext.getCmp('maingrid').getStore().removeAll();
                                        
                                    } else {
										
										var  gridstore;
                                        gridstore = Ext.StoreManager.lookup('LES.usr.usrossiappmonmnt.store.UsrossiappmonmntStore');
                                        gridstore.reload();
                                       
                                    }

                                } else {
                                    Ext.MessageBox.show({
                                        title: RP.getMessage('wm.common.error'),
                                        closable: true,
                                        msg: response.getResponseHeader('REFS-Message') ?
                                            response.getResponseHeader('REFS-Message') : RP.getMessage('wm.common.error'),
                                        buttons: Ext.Msg.OK
                                    });
                                }
                            }
                        });
                 

				 } else {
                        Ext.MessageBox.show({
                            title: RP.getMessage('wm.common.error'),
                            closable: true,
                            msg: 'Please select a row to delete',
                            buttons: Ext.Msg.OK
                        });
                    }
					Ext.getCmp('mon_id').setValue('');
					Ext.getCmp('mondes').setValue('');
					Ext.getCmp('msrtseq').setValue('');
					Ext.getCmp('msinlstrun').setValue('');
					Ext.getCmp('chccmd').setValue('');
					Ext.getCmp('fixcmd').setValue('');

                },

    onCopyClick: function() {
        
    },

    onSaveClick: function() {
		
                    var prams = {};
					var uc_monitor_id= Ext.getCmp('mon_id').getValue(),
						uc_monitor_descr= Ext.getCmp('mondes').getValue(),
						ena_flg= Ext.getCmp('ena_flg').getValue(),
						uc_check_cmd= Ext.getCmp('chccmd').getValue(),
						uc_fix_cmd= Ext.getCmp('fixcmd').getValue(),
						uc_raise_ems_alert_on_fail_flg= Ext.getCmp('fail_flg').getValue(),
						uc_log_mon_dlytrn_flg= Ext.getCmp('dlytrn_flg').getValue(),
						uc_mon_srtseq= Ext.getCmp('msrtseq').getValue(),
						uc_time_since_last_run= Ext.getCmp('msinlstrun').getValue();
										
						prams.uc_monitor_id=uc_monitor_id;
						prams.uc_monitor_descr=uc_monitor_descr;
						prams.ena_flg=ena_flg;
						prams.uc_check_cmd=uc_check_cmd;
						prams.uc_fix_cmd=uc_fix_cmd;
						prams.uc_raise_ems_alert_on_fail_flg=uc_raise_ems_alert_on_fail_flg;
						prams.uc_log_mon_dlytrn_flg=uc_log_mon_dlytrn_flg;
						prams.uc_mon_srtseq=uc_mon_srtseq;
						prams.uc_time_since_last_run=uc_time_since_last_run;	

                    if (Ext.getCmp('maingrid').getSelectionModel().hasSelection()) {
						prams.command = 'change ossi app monitor';
					} else {
                        prams.command = 'create ossi app monitor';
                    }
              
                    Ext.Ajax.request({
                        url: RP.buildDataServiceUrl('wm', 'jmigrator/process/createdata'),
                        jsonData: prams,
                        method: 'POST',
                        scope: this,
                        
						callback: function (request, success, response) {
                          
						  if (success) {
                                var gridstore;
                                var queryString = {};
								queryString.command = 'list ossi app monitors';
								
								queryString.uc_monitor_id = Ext.getCmp('mon_id').getValue();
								
								console.log(queryString);
		
								var store = Ext.StoreManager.lookup('LES.usr.usrossiappmonmnt.store.UsrossiappmonmntStore');
								store.load({
									scope: this,
									params: queryString,
									callback: function() {
										this.getInputs().action = 'edit';
										if (store.getCount() > 0) {
											this.getGridPanel().expand(true);
										} else {
											this.onClearClick();
										}
									}
								});
								Ext.Msg.alert('Success', 'Action Success Performed');
								
                            } else {
                                Ext.MessageBox.show({
                                    title: RP.getMessage('wm.common.error'),
                                    closable: true,
                                    msg: response.getResponseHeader('REFS-Message') ?
                                        response.getResponseHeader('REFS-Message') : RP.getMessage('wm.common.error'),
                                    buttons: Ext.Msg.OK
                                });
                            }
                        }
                    
					});
            },

    makeServerRequest: function(url, type, data, operation) {
        Ext.getBody().mask('Processing...');
        Ext.Ajax.request({
            url: RP.buildDataServiceUrl('wm', url),
            jsonData: data,
            method: type,
            scope: this,
            callback: function(request, success, response) {
                Ext.getBody().unmask();
                if (success) {
                    Ext.Msg.show({
                        title: RP.getMessage('wm.common.success'),
                        msg: 'Operation successful.',
                        buttons: Ext.Msg.OK,
                        scope: this,
                        fn: function(button) {
                            if (operation === 'create') {
                                this.getInputs().action = 'edit';
                                this.controlBtnNew(true);
                                this.controlBtnSave(false);
                                this.onFindClick();
                            } else if (operation === 'update') {
                                this.getInputs().action = 'edit';
                                this.controlBtnDelete(false);
                                this.controlBtnSave(false);
                                this.onFindClick();
                            } else if (operation === 'delete') {
                                this.getInputs().action = 'edit';
                                this.onClearClick();
                            } else {
                                this.onClearClick();
                            }
                        },
                        closable: false
                    });
                } else {
                    Ext.Msg.alert(RP.getMessage('wm.common.error'), 'Error occured while processing.');
                }
            }
        });
    },

    controlBtnNew: function(boolValue) {
        if (this.getBtnNew()) {
            if (boolValue) {
                this.getBtnNew().enable(true);
            } else {
                this.getBtnNew().disable(true);
            }
        }
    },

    controlBtnDelete: function(boolValue) {
        if (this.getBtnDelete()) {
            if (boolValue) {
                this.getBtnDelete().enable(true);
            } else {
                this.getBtnDelete().disable(true);
            }
        }
    },

    controlBtnSave: function(boolValue) {
        if (this.getBtnSave()) {
            if (boolValue) {
                this.getBtnSave().enable(true);
            } else {
                this.getBtnSave().disable(true);
            }
        }
    },

    controlBtnCopy: function(boolValue) {
        if (this.getBtnCopy()) {
            if (boolValue) {
                this.getBtnCopy().enable(true);
             } else {
                this.getBtnCopy().disable(true);
            }
        }
    },

    controlBtnFind: function(boolValue) {
        if (this.getBtnFind()) {
            if (boolValue) {
                this.getBtnFind().enable(true);
            } else {
                this.getBtnFind().disable(true);
            }
        }
    },
    controlGridPanel: function(boolValue) {
        if (this.getGridPanel()) {
            if (boolValue) {
                this.getGridPanel().expand(true);
            } else {
                this.getGridPanel().collapse(true);
            }
        }
    },
	usrossiappmonparmmntaUSROSSIAPPMONPARMMNT: function() {
		
		
			if (this.getUsrossiappmonparmmntGrid()) {
				var grid = this.getUsrossiappmonparmmntGrid().getSelectionModel();
				var actionForm = new Ext.window.Window({
				model: true,
				width: 750,
				height: 600,
				closable: true,
				draggable: true,
				resizable: false,
				closeAction: 'destroy',
				buttonAlign: 'center',
				autoScroll: true,
				maximizable: true,
				layout: { type: 'vbox', align: 'stretch' },
				title: RP.getMessage('les.ossi.misc.USR_OSSI_APP_MON_PARM_MNT'),
				items: [
				
						{
						xtype: 'textfield',
						allowBlank: true,
						readOnly: true,
						fieldLabel: RP.getMessage('les.ossi.misc.uc_monitor_id'),
						margin: '2px 8px 4px 0',
						id:'popmonid',
						itemId: 'uc_monitor_id',
						name: 'uc_monitor_id'
						},
						{
						xtype: 'textfield',
						allowBlank: true,
						readOnly: false,
						fieldLabel: RP.getMessage('les.ossi.misc.uc_monitor_param_id'),
						margin: '0 8px 4px 0',
						id:'monparid',
						itemId: 'uc_monitor_param_id',
						name: 'uc_monitor_param_id'
						},						
						{
						xtype: 'textfield',
						allowBlank: true,
						readOnly: false,
						fieldLabel: RP.getMessage('les.ossi.misc.uc_monitor_param_val_str'),
						margin: '0 8px 4px 0',
						id:'monparvalstr',
						itemId: 'uc_monitor_param_val_str',
						name: 'uc_monitor_param_val_str'
						},
						{
						xtype: 'textfield',
						allowBlank: true,
						readOnly: false,
						fieldLabel: RP.getMessage('les.ossi.misc.uc_monitor_param_val_num1'),
						margin: '0 8px 4px 0',
						id:'monparvaln1',
						itemId: 'uc_monitor_param_val_num1',
						name: 'uc_monitor_param_val_num1'
						},
						{
						xtype: 'textfield',
						allowBlank: true,
						readOnly: false,
						fieldLabel: RP.getMessage('les.ossi.misc.uc_monitor_param_val_num2'),
						margin: '0 8px 4px 0',
						id:'monparvaln2',
						itemId: 'uc_monitor_param_val_num2',
						name: 'uc_monitor_param_val_num2'
						},
						{
						xtype: 'textfield',
						allowBlank: true,
						readOnly: false,
						fieldLabel: RP.getMessage('les.ossi.misc.uc_monitor_param_val_flt1'),
						margin: '0 8px 4px 0',
						id:'monparvalflt1',
						itemId: 'uc_monitor_param_val_flt1',
						name: 'uc_monitor_param_val_flt1'
						},	
						{
						xtype: 'textfield',
						allowBlank: true,
						readOnly: false,
						fieldLabel: RP.getMessage('les.ossi.misc.uc_monitor_param_val_flt2'),
						margin: '0 8px 4px 0',
						id:'monparvalflt2',
						itemId: 'uc_monitor_param_val_flt2',
						name: 'uc_monitor_param_val_flt2'
						}
				
				],
				dockedItems: [
				{
					xtype: 'toolbar',
					dock: 'bottom',
					layout: { pack: 'center' },
					items: [{
						xtype: 'button',
						text: 'OK',
						id:'btnokadd',
						scale: 'medium',
						width: 90,
						action: 'usrossijoblogdspdtlOK',
						priority: Ext.button.Button.priority.HIGH,
						listeners: {
							scope: this,
							click : function(){
								var prams = {};
								var uc_monitor_id= Ext.getCmp('popmonid').getValue(),
									uc_monitor_param_id= Ext.getCmp('monparid').getValue(),
									uc_monitor_param_val_str= Ext.getCmp('monparvalstr').getValue(),
									uc_monitor_param_val_num1= Ext.getCmp('monparvaln1').getValue(),
									uc_monitor_param_val_num2= Ext.getCmp('monparvaln2').getValue(),
									uc_monitor_param_val_flt1= Ext.getCmp('monparvalflt1').getValue(),
									uc_monitor_param_val_flt2= Ext.getCmp('monparvalflt2').getValue();
								
									console.log('uc_monitor_id');console.log(Ext.getCmp('popmonid').getValue());
									console.log('uc_monitor_param_id');console.log(Ext.getCmp('monparid').getValue());
									console.log('uc_monitor_param_val_str');console.log(Ext.getCmp('monparvalstr').getValue());
									console.log('uc_monitor_param_val_num1');console.log(Ext.getCmp('monparvaln1').getValue());
									console.log('uc_monitor_param_val_num2');console.log(Ext.getCmp('monparvaln2').getValue());
									console.log('uc_monitor_param_val_flt1');console.log(Ext.getCmp('monparvalflt1').getValue());
									console.log('uc_monitor_param_val_flt2');console.log(Ext.getCmp('monparvalflt2').getValue());
									
									prams.uc_monitor_id=uc_monitor_id;
									prams.uc_monitor_param_id=uc_monitor_param_id;
									prams.uc_monitor_param_val_str=uc_monitor_param_val_str;
									prams.uc_monitor_param_val_num1=uc_monitor_param_val_num1;
									prams.uc_monitor_param_val_num2=uc_monitor_param_val_num2;
									prams.uc_monitor_param_val_flt1=uc_monitor_param_val_flt1;
									prams.uc_monitor_param_val_flt2=uc_monitor_param_val_flt2;
									
									console.log('Grid Count : ');
									console.log(Ext.getCmp('tabgrid').getStore().getCount());
									console.log('Grid proper : ');
									console.log(Ext.getCmp('tabgrid'));
									 
									if (Ext.getCmp('tabgrid').getStore().getCount() > 0) {
									for (var i = 0; i < Ext.getCmp('tabgrid').getStore().getCount(); i++) {
										var rec = Ext.getCmp('tabgrid').getStore().getAt(i);
										prams.srtseq = rec.get('srtseq');
										prams.srtseq++;
										console.log(prams.srtseq);
									}
									} else {
										prams.srtseq = Ext.getCmp('tabgrid').getStore().getCount() + 1;
										console.log(prams.srtseq);
									}
								
									console.log(prams);
				  
							    
								prams.command = 'create ossi app monitor parameter';
																
								console.log(prams);
																
								Ext.Ajax.request({
									url: RP.buildDataServiceUrl('wm', 'jmigrator/process/createdata'),
									jsonData: prams,
									method: 'POST',
									scope: this,
									
									callback: function (request, success, response) {
										console.log(success);
										if (success) {
											var gridstore;
											console.log(this.storePrefix + 'UsrossiappmonparmmntStore');
											console.log('LES.usr.usrossiappmonmnt.store.UsrossiappmonparmmntStore');

											gridstore = Ext.StoreManager.lookup('LES.usr.usrossiappmonmnt.store.UsrossiappmonparmmntStore');
											console.log(gridstore);
											gridstore.reload();
											Ext.getCmp('monparid').setValue('');
											Ext.getCmp('monparvalstr').setValue('');
											Ext.getCmp('monparvaln1').setValue('');
											Ext.getCmp('monparvaln2').setValue('');
											Ext.getCmp('monparvalflt1').setValue('');
											Ext.getCmp('monparvalflt2').setValue('');
										} else {
											Ext.MessageBox.show({
												title: RP.getMessage('wm.common.error'),
												closable: true,
												msg: response.getResponseHeader('REFS-Message') ?
													response.getResponseHeader('REFS-Message') : RP.getMessage('wm.common.error'),
												buttons: Ext.Msg.OK
											});
										}
									}
								});
						}
									}
									}, {
										xtype: 'button',
										text: 'Cancel',
										scale: 'medium',
										width: 90,
										priority: Ext.button.Button.priority.LOW,
										handler: function() {
											actionForm.close();
										}
								}]
							}
							]
						});

			var monid=Ext.getCmp('mon_id').getValue();
			
			Ext.getCmp('popmonid').setValue(monid);
			
			actionForm.show();
		}
	},
	
	usrossiappmonparmmntcUSROSSIAPPMONPARMMNT: function() {
		
			var grid = this.getUsrossiappmonparmmntGrid().getSelectionModel();
			var setmonid='',
				setsrtseq='',
				setmonparid='',
				setmonparvalstr='',
				setmonparvaln1='',
				setmonparvaln2='',
				setmonparvalflt1='',
				setmonparvalflt2='';
				
			if (grid.getSelection().length > 0) {
				
				var data1=Ext.Object.getKeys(grid.getSelection()[0].data);
				var data3=grid.getSelection()[0].get('uc_monitor_id');
				
				setmonid= grid.getSelection()[0].get('uc_monitor_id');
				setsrtseq= grid.getSelection()[0].get('srtseq');
				setmonparid= grid.getSelection()[0].get('uc_monitor_param_id');
				setmonparvalstr= grid.getSelection()[0].get('uc_monitor_param_val_str');
				setmonparvaln1= grid.getSelection()[0].get('uc_monitor_param_val_num1');
				setmonparvaln2= grid.getSelection()[0].get('uc_monitor_param_val_num2');
				setmonparvalflt1= grid.getSelection()[0].get('uc_monitor_param_val_flt1');
				setmonparvalflt2= grid.getSelection()[0].get('uc_monitor_param_val_flt2');
			
			}
			else
			{
				console.log('nodata');
			}
			var actionForm = new Ext.window.Window({
				
				model: true,
				width: 750,
				height: 600,
				closable: true,
				draggable: true,
				resizable: false,
				closeAction: 'destroy',
				buttonAlign: 'center',
				autoScroll: true,
				maximizable: true,
				layout: { type: 'vbox', align: 'stretch' },
				title: RP.getMessage('les.ossi.misc.USR_OSSI_APP_MON_PARM_MNT'),
				items: [
				
						{
						xtype: 'textfield',
						allowBlank: true,
						readOnly: true,
						fieldLabel: RP.getMessage('les.ossi.misc.uc_monitor_id'),
						margin: '2px 8px 4px 0',
						id:'popmonid',
						itemId: 'uc_monitor_id',
						name: 'uc_monitor_id'
						},
						{
						xtype: 'textfield',
						allowBlank: true,
						readOnly: false,
						fieldLabel: RP.getMessage('les.ossi.misc.uc_monitor_param_id'),
						margin: '0 8px 4px 0',
						id:'monparid',
						itemId: 'uc_monitor_param_id',
						name: 'uc_monitor_param_id'
						},						
						{
						xtype: 'textfield',
						allowBlank: true,
						readOnly: false,
						fieldLabel: RP.getMessage('les.ossi.misc.uc_monitor_param_val_str'),
						margin: '0 8px 4px 0',
						id:'monparvalstr',
						itemId: 'uc_monitor_param_val_str',
						name: 'uc_monitor_param_val_str'
						},
						{
						xtype: 'textfield',
						allowBlank: true,
						readOnly: false,
						fieldLabel: RP.getMessage('les.ossi.misc.uc_monitor_param_val_num1'),
						margin: '0 8px 4px 0',
						id:'monparvaln1',
						itemId: 'uc_monitor_param_val_num1',
						name: 'uc_monitor_param_val_num1'
						},
						{
						xtype: 'textfield',
						allowBlank: true,
						readOnly: false,
						fieldLabel: RP.getMessage('les.ossi.misc.uc_monitor_param_val_num2'),
						margin: '0 8px 4px 0',
						id:'monparvaln2',
						itemId: 'uc_monitor_param_val_num2',
						name: 'uc_monitor_param_val_num2'
						},
						{
						xtype: 'textfield',
						allowBlank: true,
						readOnly: false,
						fieldLabel: RP.getMessage('les.ossi.misc.uc_monitor_param_val_flt1'),
						margin: '0 8px 4px 0',
						id:'monparvalflt1',
						itemId: 'uc_monitor_param_val_flt1',
						name: 'uc_monitor_param_val_flt1'
						},	
						{
						xtype: 'textfield',
						allowBlank: true,
						readOnly: false,
						fieldLabel: RP.getMessage('les.ossi.misc.uc_monitor_param_val_flt2'),
						margin: '0 8px 4px 0',
						id:'monparvalflt2',
						itemId: 'uc_monitor_param_val_flt2',
						name: 'uc_monitor_param_val_flt2'
						}
				
				],
				dockedItems: [
				{
					xtype: 'toolbar',
					dock: 'bottom',
					layout: { pack: 'center' },
					items: [{
						xtype: 'button',
						text: 'OK',
						id:'btnokadd',
						scale: 'medium',
						width: 90,
						action: 'usrossijoblogdspdtlOK',
						priority: Ext.button.Button.priority.HIGH,
						listeners: {
							scope: this,
							click : function(){
								var prams = {};
								var uc_monitor_id= Ext.getCmp('popmonid').getValue(),
									uc_monitor_param_id= Ext.getCmp('monparid').getValue(),
									uc_monitor_param_val_str= Ext.getCmp('monparvalstr').getValue(),
									uc_monitor_param_val_num1= Ext.getCmp('monparvaln1').getValue(),
									uc_monitor_param_val_num2= Ext.getCmp('monparvaln2').getValue(),
									uc_monitor_param_val_flt1= Ext.getCmp('monparvalflt1').getValue(),
									uc_monitor_param_val_flt2= Ext.getCmp('monparvalflt2').getValue();
									
								
									console.log('uc_monitor_id');console.log(Ext.getCmp('popmonid').getValue());
									console.log('uc_monitor_param_id');console.log(Ext.getCmp('monparid').getValue());
									console.log('uc_monitor_param_val_str');console.log(Ext.getCmp('monparvalstr').getValue());
									console.log('uc_monitor_param_val_num1');console.log(Ext.getCmp('monparvaln1').getValue());
									console.log('uc_monitor_param_val_num2');console.log(Ext.getCmp('monparvaln2').getValue());
									console.log('uc_monitor_param_val_flt1');console.log(Ext.getCmp('monparvalflt1').getValue());
									console.log('uc_monitor_param_val_flt2');console.log(Ext.getCmp('monparvalflt2').getValue());
									
									prams.uc_monitor_id=uc_monitor_id;
									prams.uc_monitor_param_id=uc_monitor_param_id;
									prams.uc_monitor_param_val_str=uc_monitor_param_val_str;
									prams.uc_monitor_param_val_num1=uc_monitor_param_val_num1;
									prams.uc_monitor_param_val_num2=uc_monitor_param_val_num2;
									prams.uc_monitor_param_val_flt1=uc_monitor_param_val_flt1;
									prams.uc_monitor_param_val_flt2=uc_monitor_param_val_flt2;
									
									console.log('Grid Count : ');
									console.log(Ext.getCmp('tabgrid').getStore().getCount());
									console.log('Grid proper : ');
									console.log(Ext.getCmp('tabgrid'));
								
									
									if(grid.getSelection().length===0){
									
										 if (Ext.getCmp('tabgrid').getStore().getCount() > 0) {
											for (var i = 0; i < Ext.getCmp('tabgrid').getStore().getCount(); i++) {
												var rec = Ext.getCmp('tabgrid').getStore().getAt(i);
												prams.srtseq = rec.get('srtseq');
												prams.srtseq++;
												console.log(prams.srtseq);
											}
										 } else {
												prams.srtseq = Ext.getCmp('tabgrid').getStore().getCount() + 1;
												console.log(prams.srtseq);
										 }
									
									}else{
									 console.log('update request');
									 prams.srtseq=setsrtseq;
									}
					
									console.log(prams);
				   
							    if (Ext.getCmp('tabgrid').getSelectionModel().hasSelection()) {
									prams.command = 'change ossi app monitor parameter';
								} else {
									prams.command = 'create ossi app monitor parameter';
								}
								
								console.log(prams);
																
								Ext.Ajax.request({
									url: RP.buildDataServiceUrl('wm', 'jmigrator/process/createdata'),
									jsonData: prams,
									method: 'POST',
									scope: this,
									
									callback: function (request, success, response) {
										console.log(success);
										if (success) {
											var gridstore;
											
											console.log(this.storePrefix + 'UsrossiappmonparmmntStore');
											console.log('LES.usr.usrossiappmonmnt.store.UsrossiappmonparmmntStore');

											gridstore = Ext.StoreManager.lookup('LES.usr.usrossiappmonmnt.store.UsrossiappmonparmmntStore');
											console.log(gridstore);
											gridstore.reload();

											Ext.getCmp('monparid').setValue('');
											Ext.getCmp('monparvalstr').setValue('');
											Ext.getCmp('monparvaln1').setValue('');
											Ext.getCmp('monparvaln2').setValue('');
											Ext.getCmp('monparvalflt1').setValue('');
											Ext.getCmp('monparvalflt2').setValue('');
										} else {
											Ext.MessageBox.show({
												title: RP.getMessage('wm.common.error'),
												closable: true,
												msg: response.getResponseHeader('REFS-Message') ?
													response.getResponseHeader('REFS-Message') : RP.getMessage('wm.common.error'),
												buttons: Ext.Msg.OK
											});
										}
									}
								});
						}
									}
									}, {
										xtype: 'button',
										text: 'Cancel',
										scale: 'medium',
										width: 90,

										priority: Ext.button.Button.priority.LOW,
										handler: function() {
											actionForm.close();
										}
								}]
							}
							]
						});

			var monid=Ext.getCmp('mon_id').getValue();
			Ext.getCmp('popmonid').setValue(monid);
			Ext.getCmp('monparid').setValue(setmonparid);
			Ext.getCmp('monparvalstr').setValue(setmonparvalstr);
			Ext.getCmp('monparvaln1').setValue(setmonparvaln1);
			Ext.getCmp('monparvaln2').setValue(setmonparvaln2);
			Ext.getCmp('monparvalflt1').setValue(setmonparvalflt1);
			Ext.getCmp('monparvalflt2').setValue(setmonparvalflt2);
			actionForm.show();
	},

	usrossiappmonparmmntrUSROSSIAPPMONPARMMNT: function () {
			
			var prams = {};
			var grid,gridrow;
			
                    if (Ext.getCmp('tabgrid').getSelectionModel().hasSelection()) {
                       
					   grid = this.getUsrossiappmonparmmntGrid().getSelectionModel();
						gridrow=grid.getSelection()[0];
					   
						var uc_monitor_id= gridrow.get('uc_monitor_id'),
						srtseq= gridrow.get('srtseq'),
						uc_monitor_param_id= gridrow.get('uc_monitor_param_id'),
						uc_monitor_param_val_str= gridrow.get('uc_monitor_param_val_str'),
						uc_monitor_param_val_num1= gridrow.get('uc_monitor_param_val_num1'),
						uc_monitor_param_val_num2= gridrow.get('uc_monitor_param_val_num2'),
						uc_monitor_param_val_flt1= gridrow.get('uc_monitor_param_val_flt1'),
						uc_monitor_param_val_flt2= gridrow.get('uc_monitor_param_val_flt2');
						
						console.log('uc_monitor_id');console.log(uc_monitor_id);
						console.log('srtseq');console.log(srtseq);
						console.log('uc_monitor_param_id');console.log(uc_monitor_param_id);
						console.log('uc_monitor_param_val_str');console.log(uc_monitor_param_val_str);
						console.log('uc_monitor_param_val_num1');console.log(uc_monitor_param_val_num1);
						console.log('uc_monitor_param_val_num2');console.log(uc_monitor_param_val_num2);
						console.log('uc_monitor_param_val_flt1');console.log(uc_monitor_param_val_flt1);
						console.log('uc_monitor_param_val_flt2');console.log(uc_monitor_param_val_flt2);
						prams.uc_monitor_id=uc_monitor_id;
						prams.srtseq=srtseq;
						
					    prams.command = 'remove ossi app monitor parameter';
						Ext.Msg.show({
							title:'Are you sure  you want to delete ?',
							message: 'Are you sure  you want to delete ?',
							buttons: Ext.Msg.YESNOCANCEL,
							icon: Ext.Msg.QUESTION,
							fn: function(btn) {
								if (btn === 'yes') {
									console.log('Yes pressed');
									
									 Ext.Ajax.request({
										url: RP.buildDataServiceUrl('wm', 'jmigrator/process/deletedata'),
										jsonData: prams,
										method: 'POST',
										scope: this,
										
										callback: function (request, success, response) {

											if (success) {
												if (Ext.getCmp('tabgrid').getStore().getCount() == 1) {
													var  gridstore;
													gridstore = Ext.StoreManager.lookup('LES.usr.usrossiappmonmnt.store.UsrossiappmonparmmntStore');
													gridstore.reload();
												} else {
													var  gridstore2;
													gridstore2 = Ext.StoreManager.lookup('LES.usr.usrossiappmonmnt.store.UsrossiappmonparmmntStore');
													gridstore2.reload();
												}

											} else {
												Ext.MessageBox.show({
													title: RP.getMessage('wm.common.error'),
													closable: true,
													msg: response.getResponseHeader('REFS-Message') ?
														response.getResponseHeader('REFS-Message') : RP.getMessage('wm.common.error'),
													buttons: Ext.Msg.OK
												});
											}
										}
										
									});
									
									
								} else if (btn === 'no') {
									console.log('No pressed');
								} else {
									console.log('Cancel pressed');
								}
							}
						});
	
						
                    } else {
                        Ext.MessageBox.show({
                            title: RP.getMessage('wm.common.error'),
                            closable: true,
                            msg: 'Please select a row to delete',
                            buttons: Ext.Msg.OK
                        });
                    }
		
	}
	


	});

