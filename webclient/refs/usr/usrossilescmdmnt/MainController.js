Ext.define('LES.usr.usrossilescmdmnt.controller.MainController', {
    extend: 'Ext.app.Controller',

    refs: [          
	{
		ref: 'main',
		selector: 'usrossilescmdmnt'
	}, {
		ref: 'usrossilescmdmntGrid',
		selector: '#usrossilescmdmnt-grid',
		autoQualify: false
	}, {
		ref: 'inputs',
		selector: '#usrossilescmdmnt-inputs'
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
	},  {
		ref: 'tabs',
		selector: '#tabs'
	}],

    init: function() {
        this.application.on({
            activate: this.onActivate,
            deactivate: this.onDeActivate,
            scope: this
        });

        this.control({
            'usrossilescmdmnt #usrossilescmdmnt-grid': {
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
                    var form = Ext.getCmp('usrossilescmdmnt-inputs');
                        if (selected[0]) 
                        {
			                form.getForm().loadRecord(selected[0]);
                        } 
                            else
                        {
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
                click: function(){
                    this.onClearClick();
                    this.onAddClick();
                }
            },
            '#btnsave': {
                click: this.onSaveClick
            },
            '#btncopy': {
                click: this.onCopyClick
            },
            '#btndelete': {
                click: this.onDeleteClick
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
			queryString.command = 'list les command';
			Ext.Array.each(inputFields, function(input, index) {
				if (input.getValue() !== "" && input.getValue() !== null) {
					queryString[input.getName()] = input.getValue();
				}
			});
		}

		var store = Ext.StoreManager.lookup('LES.usr.usrossilescmdmnt.store.UsrossilescmdmntStore');
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
		var selection = this.getUsrossilescmdmntGrid().getSelectionModel().getSelection();

		if (selection.length > 0) {
			var values = selection[0].data;
			values.command = 'remove les command';
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
		var gridColumns = this.getUsrossilescmdmntGrid().columns;
		var selection = this.getUsrossilescmdmntGrid().getSelectionModel().getSelection();
		var inputFields = this.getInputs().items.keys;
        var values = this.getInputs().getValues();
        console.log(values);

		if (this.getInputs().action === 'edit') {
			Ext.getBody().mask('Processing...');
			values.command = 'change les command';

			Ext.Array.each(gridColumns, function(column, index) {
				if (!Ext.Array.contains(inputFields, column.dataIndex)) {
					values[column.dataIndex] = selection[0].get(column.dataIndex);
				}
			});
			this.makeServerRequest('jmigrator/process/updatedata', 'PUT', values, false, true);
		} else {
			values.command = 'create les command';
			this.makeServerRequest('jmigrator/process/createdata', 'POST', values, false, true);
		}
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
    }
});