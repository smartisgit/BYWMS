Ext.define('LES.usr.usrexpireditems.view.MainView', {
    extend: 'Ext.panel.Panel',
    alias: 'widget.usrexpireditems',
    itemId: 'usrexpireditems',

    storePrefix: 'LES.usr.usrexpireditems.store.',

    initComponent: function() {
        var store = Ext.StoreManager.lookup(this.storePrefix + 'UsrexpireditemsStore');

        Ext.apply(this, {
            autoScroll: true,
            layout: 'fit',
            requires: ['Ext.resizer.Splitter', 'Ext.tab.*', 'Ext.grid.*', 'Ext.data.*'],
            items: [{
                xtype: 'panel',
                minWidth: 850,
                minHeight: 470,
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
			itemId: 'usrexpireditems-grid',
			viewConfig: {
                deferEmptyText: false,
                emptyText: '<center><font size="4">' +
                    'To find and maintain data, enter an identifier.' +
                    '</font></center>'
            },
			store: store,
			plugins:[{
							ptype: 'rpExportableGrid',
							exportFormats: [
								new RP.data.model.Format({ format: 'pdf', display: 'PDF' }),
								new RP.data.model.Format({ format: 'csv', display: 'CSV' })
							]
			}],
			pagingConfig: true,
			sortableColumns: true,
			selModel: Ext.create('Ext.selection.CheckboxModel', {mode: 'MULTI'}),
			height: 350,
			filterController: Ext.create('RPUX.FilterController', {
				backend: 'wm',
				filterType: 'LES',
				entityStore: Ext.StoreManager.lookup(this.storePrefix + 'UsrexpireditemsStore'),
				localFilter: [
					'area',
					'location',
					'item_number',
					'description',
					'load',
					'total_quantity',
					'box_quantity',
					'inv_status',
					'days_left',
					'expiration_date'
				]
			}),
			columns: [
			{
				header: RP.getMessage('les.ossi.misc.area'),
				dataIndex: 'area'
			},
			{
				header: RP.getMessage('les.ossi.misc.location'),
				dataIndex: 'location'
			},
			{
				header: RP.getMessage('les.ossi.misc.item_number'),
				dataIndex: 'item_number'
			},
			{
				header: RP.getMessage('les.ossi.misc.description'),
				dataIndex: 'description'
			},
			{
				header: RP.getMessage('les.ossi.misc.load'),
				dataIndex: 'load'
			},
			{
				header: RP.getMessage('les.ossi.misc.total_quantity'),
				dataIndex: 'total_quantity'
			},
			{
				header: RP.getMessage('les.ossi.misc.box_quantity'),
				dataIndex: 'box_quantity'
			},
			{
				header: RP.getMessage('les.ossi.misc.inv_status'),
				dataIndex: 'inv_status'
			},
			{
				header: RP.getMessage('les.ossi.misc.days_left'),
				dataIndex: 'days_left'
			},
			{
				header: RP.getMessage('les.ossi.misc.expiration_date'),
				dataIndex: 'expiration_date'
			}],
			listeners: {
				selectionchange: this.gridSelectionChange,
				scope: this
			}

        };
    },
	
    createButtonBar: function() {
        return null;
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
				id: 'usrexpireditems-inputs',
				itemId: 'usrexpireditems-inputs',
				defaults: { flex: 1, padding: '5px', columnWidth: 0.18},
				items: [
				{
					xtype: 'textfield',
					allowBlank: false,
					readOnly: false,
					fieldLabel: RP.getMessage('les.ossi.misc.diff_date')+':',
					labelWidth: 150,
					labelAlign:	'right',
					margin: '0 8px 4px 0',
					id:'diff_date',
					itemId: 'diff_date',
					name: 'diff_date'
				}
				]
			}]
		});
		return tabs;

    },
    gridSelectionChange: function(selModel, record) {
        var form = Ext.getCmp('usrexpireditems-inputs');
		if (record[0]) {
			form.getForm().loadRecord(record[0]);
		} else {
			form.getForm().reset();
		}

    }

});