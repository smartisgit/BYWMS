Ext.define('LES.usr.usrossilescmdmnt.view.MainView', {
    extend: 'Ext.panel.Panel',
    alias: 'widget.usrossilescmdmnt',
    itemId: 'usrossilescmdmnt',

    storePrefix: 'LES.usr.usrossilescmdmnt.store.',

    initComponent: function() {
        var store = Ext.StoreManager.lookup(this.storePrefix + 'UsrossilescmdmntStore');

        Ext.apply(this, {
            layout: 'fit',
            requires: ['Ext.resizer.Splitter', 'Ext.tab.*', 'Ext.grid.*', 'Ext.data.*'],
            items: [{
                xtype: 'panel',
				autoScroll: true,
                items: [{
                    xtype: 'panel',
                    collapsible: true,
                    title: 'LES Commands',
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
			itemId: 'usrossilescmdmnt-grid',
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
			height: 250,
			filterController: Ext.create('RPUX.FilterController', {
				backend: 'wm',
				filterType: 'LES',
				entityStore: Ext.StoreManager.lookup(this.storePrefix + 'UsrossilescmdmntStore'),
				localFilter: [
					'les_cmd_id',
					'cust_lvl',
					'syntax',
					'moddte',
					'mod_usr_id',
					'grp_nam'
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
				header: RP.getMessage('les.ossi.misc.les_cmd_id'),
				dataIndex: 'les_cmd_id',
				autoSizeColumn: true,
				minWidth: 200
			},
			{
				header: RP.getMessage('les.ossi.misc.cust_lvl'),
				dataIndex: 'cust_lvl',
				autoSizeColumn: true,
				minWidth: 100
			},
			{
				header: RP.getMessage('les.ossi.misc.syntax'),
				dataIndex: 'syntax',
				autoSizeColumn: true,
				minWidth: 300
			},
			{
				header: RP.getMessage('les.ossi.misc.moddte'),
				dataIndex: 'moddte',
				renderer: WM.util.Renderers.dateTimeRenderer
			},
			{
				header: RP.getMessage('les.ossi.misc.mod_usr_id'),
				dataIndex: 'mod_usr_id',
				autoSizeColumn: true,
				minWidth: 200
			},
			{
				header: RP.getMessage('les.ossi.misc.grp_nam'),
				dataIndex: 'grp_nam',
				autoSizeColumn: true,
				minWidth: 200
			}]

        };
    },

    createButtonBar: function() {
        return null;
    },

    createTabs: function() {
        var tabs = Ext.create('Ext.panel.Panel', {
			margin: '10px 0px 0px 0px',			
			items: [
			{
				xtype: 'form',
				layout: 'vbox',
				autoScroll: true,
				id: 'usrossilescmdmnt-inputs',
				itemId: 'usrossilescmdmnt-inputs',
				items: [
				{
					xtype: 'textfield',
					allowBlank: true,
					readOnly: false,
					labelAlign: 'left',
					width: 600,
					labelWidth: 160,
					fieldLabel: RP.getMessage('les.ossi.misc.les_cmd_id'),
					margin: '0 8px 4px 0',
					itemId: 'les_cmd_id',
					maxLength: 50,
					name: 'les_cmd_id'
				},
				{
					xtype: 'textfield',
					allowBlank: true,
					readOnly: false,
					labelAlign: 'left',
					width: 350,
					labelWidth: 160,
					fieldLabel: RP.getMessage('les.ossi.misc.cust_lvl'),
					margin: '0 8px 4px 0',
					itemId: 'cust_lvl',
					name: 'cust_lvl'
				},
				{
					xtype: 'textarea',
					allowBlank: true,
					autoScroll: true,
					readOnly: false,
					labelAlign: 'left',
					labelWidth: 160,
					fieldLabel: RP.getMessage('les.ossi.misc.syntax'),
					margin: '0 8px 4px 0',
					height: 380,
					width: '100%',
					itemId: 'syntax',
					name: 'syntax'
				}
				]
			}]
		});
		return tabs;
    }
});