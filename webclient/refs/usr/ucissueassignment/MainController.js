Ext.define('LES.usr.ucissueassignment.controller.MainController', {
    extend: 'Ext.app.Controller',

    refs: [          
	{
		ref: 'main',
		selector: 'ucissueassignment'
	},
	{
		ref: 'ucissueassignmentGrid',
		selector: '#ucissueassignment-grid',
		autoQualify: false
	},
	{
		ref: 'inputs',
		selector: '#ucissueassignment-inputs'
	},
	{
		ref: 'gridPanel',
		selector: '#gridpanel'
	},	{
		ref: 'btnNew',
		selector: '#btnnew'
	},	{
		ref: 'btnSave',
		selector: '#btnsave'
	},	{
		ref: 'btnClear',
		selector: '#btnclear'
	},	{
		ref: 'btnDelete',
		selector: '#btndelete'
	},	{
		ref: 'btnFind',
		selector: '#btnfind'
	},
	{
		ref: 'tabs',
		selector: '#tabs'
	},
	{
		ref: 'ucissueassignmenttablesGrid',
		selector: '#ucissueassignmenttables-grid'
	},
	{
		ref: 'ucissueassignmentseamlesGrid',
		selector: '#ucissueassignmentseamles-grid'
	},
	{
		ref: 'ucissueassignmentfilesGrid',
		selector: '#ucissueassignmentfiles-grid'
	}],

    init: function() {
        this.application.on({
            activate: this.onActivate,
            deactivate: this.onDeActivate,
            scope: this
        });

        this.control({
            'ucissueassignment #ucissueassignment-grid': {
				selectionchange: function(selModel, records) {
					if (records.length > 0) {
						this.getInputs().action = 'edit';
					} else {
						this.getInputs().action = 'add';
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
            'ucissueassignment button[action=ucissueassignmentcomplete]': {
				click: this.ucissueassignmentcomplete
			},
			'ucissueassignment button[action=ucissueassignmentcreatetriggers]': {
				click: this.ucissueassignmentcreatetriggers
			},
			'ucissueassignment button[action=ucissueassignmentportalmsg]': {
				click: this.ucissueassignmentportalmsg
			},
			'#ucissueassignmenttables button[action=ucissueassignmentreassignlog]': {
				click: this.ucissueassignmentreassignlogUCISSUEASSIGNMENTTABLES
			},
			'#ucissueassignmenttables button[action=ucissueassignmentremovedata]': {
				click: this.ucissueassignmentremovedataUCISSUEASSIGNMENTTABLES
			},
			'#ucissueassignmenttables button[action=ucissueassignmentremovelog]': {
				click: this.ucissueassignmentremovelogUCISSUEASSIGNMENTTABLES
			},
			'#ucissueassignmentfiles button[action=ucissueassignmentreassignlog]': {
				click: this.ucissueassignmentreassignlogUCISSUEASSIGNMENTFILES
			},
			'#ucissueassignmentfiles button[action=ucissueassignmentremovelog]': {
				click: this.ucissueassignmentremovelogUCISSUEASSIGNMENTFILES
			}
        });

        this.callParent(arguments);
    },

    onActivate: function() {
        if (this.getBtnSave()) {
			this.getBtnSave().disable(true);
		}

		if (this.getBtnDelete()) {
			this.getBtnDelete().disable(true);
		}

		this.onFindClick();

    },

    onDeActivate: function() {},

    performRefresh: function() {
        this.getStore('MainStore').load();
    },

    onAddClick: function() {
        if (this.getInputs()) {
			this.getInputs().items.each(function(field, index) {
				if (!field.disabled && !field.readOnly) {
					field.focus();
					return false;
				}
			});
			this.controlBtnDelete(false);
			this.controlBtnFind(false);
			this.controlBtnNew(false);
			this.controlBtnSave(true);
		}

    },

    onFindClick: function() {
		
        var queryString = {};
		
		if (this.getInputs()) {
			var inputFields = this.getInputs().items.getRange();
			queryString.command = 'get usr issue for user';
			queryString.ddaQual = "uc_ossi_stat_cd != 'C'";
			Ext.Array.each(inputFields, function(input, index) {
				if (!input.disabled && !input.readOnly && input.getValue() !== "" && input.getValue() !== null) {
					queryString[input.getName()] = input.getValue();
				}
			});
		}

		var store = Ext.StoreManager.lookup('LES.usr.ucissueassignment.store.UcissueassignmentStore');
		store.load({
			scope: this,
			params: queryString,
			callback: function() {
				if (store.getCount() > 0) {
					this.getGridPanel().expand(true);
					this.controlBtnDelete(true);
					this.controlBtnSave(true);
				}
				else {
					Ext.Msg.show({
						title: 'Info',
						msg: 'No Data Found',
						buttons: Ext.Msg.OK
					});
				}
			}
		});

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
					input.reset();
				}
			});
		}

		if (this.getTabs()) {
			this.getTabs().setActiveTab(0);
		}

		this.getGridPanel().collapse(true);
		this.getGridPanel().focus();
		this.controlBtnSave(false);
		this.controlBtnDelete(false);
		this.controlBtnFind(true);
		this.controlBtnNew(true);

    },

    onDeleteClick: function() {
        var selection = this.getUcissueassignmentGrid().getSelectionModel().getSelection();

		if (selection.length > 0) {
			var values = selection[0].data;
			values.command = 'remove usr issue';
			Ext.Msg.show({
				title: RP.getMessage('wm.common.confirmDeleteTitle'),
				msg: 'Are you sure you want to delete this record?',
				buttons: Ext.Msg.OKCANCEL,
				scope: this,
				fn: function(button) {
					if (button === 'ok') {
						this.makeServerRequest('jmigrator/process/deletedata', 'POST', values, true, true);
					}
				}
			});

		}
		this.getInputs().action = 'edit';
    },

    onCopyClick: function() {
        
    },

    onSaveClick: function() {
        var gridColumns = this.getUcissueassignmentGrid().columns;
		var selection = this.getUcissueassignmentGrid().getSelectionModel().getSelection();
		var inputFields = this.getInputs().items.keys;
		var values = this.getInputs().getValues();

		if (this.getInputs().action === 'edit') {
			Ext.getBody().mask('Processing...');
			values.command = 'change usr issue';

			Ext.Array.each(gridColumns, function(column, index) {
				if (!Ext.Array.contains(inputFields, column.dataIndex)) {
					values[column.dataIndex] = selection[0].get(column.dataIndex);
				}
			});
			this.makeServerRequest('jmigrator/process/updatedata', 'PUT', values, false, true);
		} else {
			values.command = 'assign usr issue to user';
			this.makeServerRequest('ossi-migrator/createdata', 'POST', values, false, true);
		}
    },

    makeServerRequest: function(url, type, data, clearInputs, doFind) {
        Ext.getBody().mask('Processing...');
        Ext.Ajax.request({
            url: RP.buildDataServiceUrl('wm', url),
            jsonData: data,
            method: type,
            scope: this,
            callback: function(request, success, response) {
                Ext.getBody().unmask();
                if (success) {
					Ext.Msg.alert(RP.getMessage('wm.common.success'), 'Operation successful.');
										
                    if (clearInputs) {
                        this.onClearClick();
                    }
                    if (doFind) {
                        this.onFindClick();
                    }
                } else {
                    Ext.Msg.alert(RP.getMessage('wm.common.error'), 'Error occured while processing.');                }
            }
        });
    },

    controlBtnNew: function(boolValue) {
		var selection = this.getUcissueassignmentGrid().getSelectionModel();
		selection.deselectAll();
		if (this.getInputs()) {
			var inputFields = this.getInputs().items.getRange();
			Ext.Array.each(inputFields, function(input, index) {
				if (!input.disabled) {
					input.reset();
				}
			});
		}

		if (this.getTabs()) {
			this.getTabs().setActiveTab(0);
		}
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

    ucissueassignmentcomplete: function() {
		if (this.getUcissueassignmentGrid()) {
			var childGrid = this.getUcissueassignmentGrid().getSelectionModel();
			if (childGrid.getSelection().length === 0) {
				return;
			}
			var actionForm = new Ext.window.Window({
				model: true,
				width: 550,
				closable: true,
				draggable: true,
				resizable: false,
				closeAction: 'destroy',
				strainHeader: false,
				buttonAlign: 'center',
				maxHeight: 1000,
				itemId: 'ucissueassignmentcomplete',
				title: RP.getMessage('les.ossi.misc.ucissueassignmentcomplete'),
				layout: { type: 'fit' },
				items: [{
					xtype: 'form',
					margin: '8px',
					layout: { type: 'table', columns: 2 },
					bodyStyle: { border: 'none' },
					itemId: 'ucissueassignmentcomplete-form',
					defaults: {width: 230},
					items: [
				{
					xtype: 'rpToggle',
					fieldLabel: RP.getMessage('les.ossi.misc.do_commit'),
					margin: '0 16px 8px 16px',
					itemId: 'do_commit',
					name: 'do_commit',
					onText: RP.getMessage('wm.common.yes'),
					offText: RP.getMessage('wm.common.no'),
					checkedValue: 1,
					uncheckedValue: 0,
					allowBlank: true,
					readOnly: false
				},
				{
					xtype: 'textfield',
					allowBlank: true,
					readOnly: false,
					fieldLabel: RP.getMessage('les.ossi.misc.username'),
					margin: '0 16px 8px 16px',
					itemId: 'username',
					name: 'username'
				},
				{
					xtype: 'textfield',
					inputType: 'password',
					fieldLabel: RP.getMessage('les.ossi.misc.password'),
					margin: '0 16px 8px 16px',
					itemId: 'password',
					name: 'password',
					allowBlank: true,
					readOnly: false
				},
				{
					xtype: 'textfield',
					allowBlank: true,
					readOnly: false,
					fieldLabel: RP.getMessage('les.ossi.misc.comment'),
					margin: '0 16px 8px 16px',
					itemId: 'comment',
					name: 'comment'
				},
				{
					xtype: 'rpToggle',
					fieldLabel: RP.getMessage('les.ossi.misc.create_rollout'),
					margin: '0 16px 8px 16px',
					itemId: 'create_rollout',
					name: 'create_rollout',
					onText: RP.getMessage('wm.common.yes'),
					offText: RP.getMessage('wm.common.no'),
					checkedValue: 1,
					uncheckedValue: 0,
					allowBlank: true,
					readOnly: false
				}
					],
					buttonAlign: 'center',
					buttons: [{
						text: 'OK',
						scale: 'medium',
						action: 'ucissueassignmentcompleteOK',
						priority: Ext.button.Button.priority.HIGH,
						listeners: {
							scope: this,
							click: function(button) {								
								var values = actionForm.down('form').getForm().getValues();
								var keys = Ext.Object.getKeys(childGrid.getSelection()[0].data);

								values.command = 'complete usr issue';
								if (Ext.Array.contains(keys, 'uc_ossi_issue_assign_seq')) {
									values.uc_ossi_issue_assign_seq = childGrid.getSelection()[0].get('uc_ossi_issue_assign_seq');
								}


								this.makeServerRequest('ossi-migrator/updatedata', 'PUT', values);
								actionForm.close();

								this.getMain().gridSelectionChange(childGrid, childGrid.getSelection());
							}
						}
					}, {
						text: 'Cancel',
						scale: 'medium',
						action: 'ucissueassignmentcompleteCancel',
						priority: Ext.button.Button.priority.LOW,
						handler: function() {
							actionForm.close();
						}
					}]
				}]
			});
			actionForm.show();
		}

	},
	ucissueassignmentcreatetriggers: function() {
		if (this.getUcissueassignmentGrid()) {
			var childGrid = this.getUcissueassignmentGrid().getSelectionModel();
			if (childGrid.getSelection().length === 0) {
				return;
			}
			var actionForm = new Ext.window.Window({
				model: true,
				width: 550,
				closable: true,
				draggable: true,
				resizable: false,
				closeAction: 'destroy',
				strainHeader: false,
				buttonAlign: 'center',
				maxHeight: 1000,
				itemId: 'ucissueassignmentcreatetriggers',
				title: RP.getMessage('les.ossi.misc.ucissueassignmentcreatetriggers'),
				layout: { type: 'fit' },
				items: [{
					xtype: 'form',
					margin: '8px',
					layout: { type: 'table', columns: 2 },
					bodyStyle: { border: 'none' },
					itemId: 'ucissueassignmentcreatetriggers-form',
					defaults: {width: 230},
					items: [
				{
					xtype: 'textfield',
					allowBlank: true,
					readOnly: false,
					fieldLabel: RP.getMessage('les.ossi.misc.uc_ossi_obj_grp'),
					margin: '0 16px 8px 16px',
					itemId: 'uc_ossi_obj_grp',
					name: 'uc_ossi_obj_grp'
				},
				{
					xtype: 'textfield',
					allowBlank: true,
					readOnly: false,
					fieldLabel: RP.getMessage('les.ossi.misc.uc_ossi_obj_name'),
					margin: '0 16px 8px 16px',
					itemId: 'uc_ossi_obj_name',
					name: 'uc_ossi_obj_name'
				},
				{
					xtype: 'textfield',
					allowBlank: true,
					readOnly: false,
					fieldLabel: RP.getMessage('les.ossi.misc.cmdlvl'),
					margin: '0 16px 8px 16px',
					itemId: 'cmdlvl',
					name: 'cmdlvl'
				},
				{
					xtype: 'textfield',
					allowBlank: true,
					readOnly: false,
					fieldLabel: RP.getMessage('les.ossi.misc.create_cmd'),
					margin: '0 16px 8px 16px',
					itemId: 'create_cmd',
					name: 'create_cmd'
				},
				{
					xtype: 'textfield',
					allowBlank: true,
					readOnly: false,
					fieldLabel: RP.getMessage('les.ossi.misc.change_cmd'),
					margin: '0 16px 8px 16px',
					itemId: 'change_cmd',
					name: 'change_cmd'
				},
				{
					xtype: 'textfield',
					allowBlank: true,
					readOnly: false,
					fieldLabel: RP.getMessage('les.ossi.misc.remove_cmd'),
					margin: '0 16px 8px 16px',
					itemId: 'remove_cmd',
					name: 'remove_cmd'
				}
					],
					buttonAlign: 'center',
					buttons: [{
						text: 'OK',
						scale: 'medium',
						action: 'ucissueassignmentcreatetriggersOK',
						priority: Ext.button.Button.priority.HIGH,
						listeners: {
							scope: this,
							click: function(button) {
								var values = actionForm.down('form').getForm().getValues();

								values.command = 'generate usr issue triggers';

								this.makeServerRequest('jmigrator/process/updatedata', 'PUT', values);
								actionForm.close();

								this.getMain().gridSelectionChange(childGrid, childGrid.getSelection());
							}
						}
					}, {
						text: 'Cancel',
						scale: 'medium',
						action: 'ucissueassignmentcreatetriggersCancel',
						priority: Ext.button.Button.priority.LOW,
						handler: function() {
							actionForm.close();
						}
					}]
				}]
			});
			actionForm.show();
		}

	},
	ucissueassignmentportalmsg: function() {
		
		if (this.getUcissueassignmentGrid()) {
			var childGrid = this.getUcissueassignmentGrid().getSelectionModel();
			if (childGrid.getSelection().length === 0) {
				return;
			}
			var actionForm = new Ext.window.Window({
				model: true,
				width: 550,
				closable: true,
				draggable: true,
				resizable: false,
				closeAction: 'destroy',
				strainHeader: false,
				buttonAlign: 'center',
				maxHeight: 1000,
				itemId: 'ucissueassignmentportalmsg',
				title: RP.getMessage('les.ossi.misc.ucissueassignmentportalmsg'),
				layout: { type: 'fit' },
				items: [{
					xtype: 'form',
					margin: '8px',
					layout: { type: 'table', columns: 2 },
					bodyStyle: { border: 'none' },
					itemId: 'ucissueassignmentportalmsg-form',
					defaults: {width: 230},
					items: [
						{
							xtype: 'label',
							allowBlank: true,
							readOnly: false,
							text: RP.getMessage('les.ossi.misc.uc_ossi_issue_label'),
							itemId: 'uc_ossi_issue_label',
							name: 'uc_ossi_issue_label'
						}				
				],
					buttonAlign: 'center',
					buttons: [{
						text: 'OK',
						scale: 'medium',
						action: 'ucissueassignmentcreatetriggersOK',
						priority: Ext.button.Button.priority.HIGH,
						listeners: {
							scope: this,
							click: function(button) {
								var values = actionForm.down('form').getForm().getValues();

								values.command = 'load ossi mls cat to refs';

								this.makeServerRequest('jmigrator/process/updatedata', 'PUT', values);
								actionForm.close();

								this.getMain().gridSelectionChange(childGrid, childGrid.getSelection());
							}
						}
					}, {
						text: 'Cancel',
						scale: 'medium',
						action: 'ucissueassignmentcreatetriggersCancel',
						priority: Ext.button.Button.priority.LOW,
						handler: function() {
							actionForm.close();
						}
					}]
				}]
			});
		
			actionForm.show();
		}

	},
	
	ucissueassignmentreassignlogUCISSUEASSIGNMENTTABLES: function() {
		if (this.getUcissueassignmenttablesGrid()) {
			var childGrid = this.getUcissueassignmenttablesGrid().getSelectionModel();
			if (childGrid.getSelection().length === 0) {
				return;
			}
			var actionForm = new Ext.window.Window({
				model: true,
				width: 550,
				closable: true,
				draggable: true,
				resizable: false,
				closeAction: 'destroy',
				strainHeader: false,
				buttonAlign: 'center',
				maxHeight: 1000,
				itemId: 'ucissueassignmentreassignlog',
				title: RP.getMessage('les.ossi.misc.ucissueassignmentreassignlog'),
				layout: { type: 'fit' },
				items: [{
					xtype: 'form',
					margin: '8px',
					layout: { type: 'table', columns: 2 },
					bodyStyle: { border: 'none' },
					itemId: 'ucissueassignmentreassignlog-form',
					defaults: {width: 230},
					items: [
				{
					xtype: 'textfield',
					allowBlank: true,
					readOnly: false,
					fieldLabel: RP.getMessage('les.ossi.misc.uc_ossi_new_issue_assign_seq'),
					margin: '0 16px 8px 16px',
					itemId: 'uc_ossi_new_issue_assign_seq',
					name: 'uc_ossi_new_issue_assign_seq'
				}
					],
					buttonAlign: 'center',
					buttons: [{
						text: 'OK',
						scale: 'medium',
						action: 'ucissueassignmentreassignlogOK',
						priority: Ext.button.Button.priority.HIGH,
						listeners: {
							scope: this,
							click: function(button) {
								var values = actionForm.down('form').getForm().getValues();
								var keys = Ext.Object.getKeys(childGrid.getSelection()[0].data);

								values.command = 'reassign usr obj log';
								if (Ext.Array.contains(keys, 'uc_ossi_issue_assign_seq')) {
									values.uc_ossi_issue_assign_seq = childGrid.getSelection()[0].get('uc_ossi_issue_assign_seq');
								}

								if (Ext.Array.contains(keys, 'uc_ossi_issue_obj_log_seq')) {
									values.uc_ossi_issue_obj_log_seq = childGrid.getSelection()[0].get('uc_ossi_issue_obj_log_seq');
								}

								if (Ext.Array.contains(keys, 'uc_ossi_new_issue_assign_seq')) {
									values.uc_ossi_new_issue_assign_seq = childGrid.getSelection()[0].get('uc_ossi_new_issue_assign_seq');
								}


								this.makeServerRequest('jmigrator/process/updatedata', 'PUT', values);
								actionForm.close();

								this.getMain().gridSelectionChange(childGrid, childGrid.getSelection());
							}
						}
					}, {
						text: 'Cancel',
						scale: 'medium',
						action: 'ucissueassignmentreassignlogCancel',
						priority: Ext.button.Button.priority.LOW,
						handler: function() {
							actionForm.close();
						}
					}]
				}]
			});
			actionForm.show();
		}

	},
	ucissueassignmentremovedataUCISSUEASSIGNMENTTABLES: function() {
		if (this.getUcissueassignmenttablesGrid()) {
			var childGrid = this.getUcissueassignmenttablesGrid().getSelectionModel();

			if (childGrid.getSelection().length === 0) {
				return;
			}
			var values = childGrid.getSelection()[0].data;

			values.command = 'remove usr data and log';
			this.makeServerRequest('jmigrator/process/updatedata', 'PUT', values);

			this.getMain().gridSelectionChange(childGrid, childGrid.getSelection());
		}

	},
	ucissueassignmentremovelogUCISSUEASSIGNMENTTABLES: function() {
		if (this.getUcissueassignmenttablesGrid()) {
			var childGrid = this.getUcissueassignmenttablesGrid().getSelectionModel();

			if (childGrid.getSelection().length === 0) {
				return;
			}
			var values = childGrid.getSelection()[0].data;

			values.command = 'remove usr obj log';
			this.makeServerRequest('jmigrator/process/updatedata', 'PUT', values);

			this.getMain().gridSelectionChange(childGrid, childGrid.getSelection());
		}

	},
	ucissueassignmentreassignlogUCISSUEASSIGNMENTFILES: function() {
		if (this.getUcissueassignmentfilesGrid()) {
			var childGrid = this.getUcissueassignmentfilesGrid().getSelectionModel();
			if (childGrid.getSelection().length === 0) {
				return;
			}
			var actionForm = new Ext.window.Window({
				model: true,
				width: 550,
				closable: true,
				draggable: true,
				resizable: false,
				closeAction: 'destroy',
				strainHeader: false,
				buttonAlign: 'center',
				maxHeight: 1000,
				itemId: 'ucissueassignmentreassignlog',
				title: RP.getMessage('les.ossi.misc.ucissueassignmentreassignlog'),
				layout: { type: 'fit' },
				items: [{
					xtype: 'form',
					margin: '8px',
					layout: { type: 'table', columns: 2 },
					bodyStyle: { border: 'none' },
					itemId: 'ucissueassignmentreassignlog-form',
					defaults: {width: 230},
					items: [
				{
					xtype: 'textfield',
					allowBlank: true,
					readOnly: false,
					fieldLabel: RP.getMessage('les.ossi.misc.uc_ossi_new_issue_assign_seq'),
					margin: '0 16px 8px 16px',
					itemId: 'uc_ossi_new_issue_assign_seq',
					name: 'uc_ossi_new_issue_assign_seq'
				}
					],
					buttonAlign: 'center',
					buttons: [{
						text: 'OK',
						scale: 'medium',
						action: 'ucissueassignmentreassignlogOK',
						priority: Ext.button.Button.priority.HIGH,
						listeners: {
							scope: this,
							click: function(button) {
								var values = actionForm.down('form').getForm().getValues();
								var keys = Ext.Object.getKeys(childGrid.getSelection()[0].data);
								
								values.command = 'reassign usr obj log';
								if (Ext.Array.contains(keys, 'uc_ossi_issue_assign_seq')) {
									values.uc_ossi_issue_assign_seq = childGrid.getSelection()[0].get('uc_ossi_issue_assign_seq');
								}

								if (Ext.Array.contains(keys, 'uc_ossi_issue_obj_log_seq')) {
									values.uc_ossi_issue_obj_log_seq = childGrid.getSelection()[0].get('uc_ossi_issue_obj_log_seq');
								}

								if (Ext.Array.contains(keys, 'uc_ossi_new_issue_assign_seq')) {
									values.uc_ossi_new_issue_assign_seq = childGrid.getSelection()[0].get('uc_ossi_new_issue_assign_seq');
								}


								this.makeServerRequest('ossi-migrator/updatedata', 'PUT', values);
								actionForm.close();

								this.getMain().gridSelectionChange(childGrid, childGrid.getSelection());
							}
						}
					}, {
						text: 'Cancel',
						scale: 'medium',
						action: 'ucissueassignmentreassignlogCancel',
						priority: Ext.button.Button.priority.LOW,
						handler: function() {
							actionForm.close();
						}
					}]
				}]
			});
			actionForm.show();
		}

	},
	ucissueassignmentremovelogUCISSUEASSIGNMENTFILES: function() {
		if (this.getUcissueassignmentfilesGrid()) {
			var childGrid = this.getUcissueassignmentfilesGrid().getSelectionModel();

			if (childGrid.getSelection().length === 0) {
				return;
			}
			var values = childGrid.getSelection()[0].data;

			values.command = 'remove usr obj log';
			this.makeServerRequest('jmigrator/process/updatedata', 'PUT', values);

			this.getMain().gridSelectionChange(childGrid, childGrid.getSelection());
		}

	}

});