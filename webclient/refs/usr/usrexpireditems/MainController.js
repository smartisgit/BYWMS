Ext.define('LES.usr.usrexpireditems.controller.MainController', {
    extend: 'Ext.app.Controller',

    refs: [          
	{
		ref: 'main',
		selector: 'usrexpireditems'
	}, {
		ref: 'usrexpireditemsGrid',
		selector: '#usrexpireditems-grid'
	}, {
		ref: 'inputs',
		selector: '#usrexpireditems-inputs'
	}, {
		ref: 'gridPanel',
		selector: '#gridpanel'
	}, {
		ref: 'btnFind',
		selector: '#btnfind'
	}, {
		ref: 'btnClear',
		selector: '#btnclear'
	}, 
	{
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
			
            '#btnfind': {
                click: this.onFindClick
            },
            '#btnclear': {
                click: this.onClearClick
            }
			
        });

        this.callParent(arguments);
    },

    onActivate: function() {
       this.controlGridPanel(false);
    },

    onDeActivate: function() {},

    performRefresh: function() {
        //this.getStore('').load();
    },
	
    onFindClick: function() {
        var queryString = {};
		
		var diff_date = Ext.getCmp('diff_date').getValue();
		
		if(diff_date!== "" && diff_date!== null){
		
			if (this.getInputs()) {
				var inputFields = this.getInputs().items.getRange();
				queryString.command = 'list usr expiration report';
				Ext.Array.each(inputFields, function(input, index) {
					if (input.getValue() !== "" && input.getValue() !== null) {
						queryString[input.getName()] = input.getValue();
					}
				});
			}

			var store = Ext.StoreManager.lookup('LES.usr.usrexpireditems.store.UsrexpireditemsStore');
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
		}else{
			Ext.MessageBox.show({
				title: RP.getMessage('wm.common.error'),
				closable: true,
				msg: 'Days of Expire Required',
				buttons: Ext.Msg.OK
            });
		}
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
		this.controlBtnFind(true);
		this.getInputs().action = 'edit';

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
                                this.onFindClick();
                            } else if (operation === 'update') {
                                this.getInputs().action = 'edit';
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