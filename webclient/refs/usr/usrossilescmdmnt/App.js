Ext.define('LES.usr.usrossilescmdmnt.App', {
    namespace: 'LES.usr.usrossilescmdmnt',
    extend: 'WM.taskflow.App',

    allowRefresh: true,
	allowExport: true,
    enableRefreshInterval: true,

    mixins: {
        refreshable: 'RP.mixin.Refreshable'
    },

    controllers: ['MainController'],
    views: ['MainView'],
    stores: ['MainStore','UsrossilescmdmntStore'],

    mainView: 'MainView',
    centerTools: [{
        xtype:'tbspacer',
        flex:1
    }, {
		xtype: 'button',
		itemId: 'btnnew',
		text: 'New',
		glyph: RP.Glyphs.Add.value
	}, {
		xtype: 'button',
		itemId: 'btnsave',
		text: 'Save',
		glyph: RP.Glyphs.Save.value
	}, {
		xtype: 'button',
		itemId: 'btndelete',
		text: 'Delete',
		glyph: RP.Glyphs.Delete.value
	},
    {
        xtype: 'button',
        itemId: 'btnclear',
        text: 'Clear',
        glyph: RP.Glyphs.RestoreReset.value
    }, {
        xtype: 'button',
        itemId: 'btnfind',
        text: 'Find',
        glyph: RP.Glyphs.Find.value
    }],
    initComponent: function() {
        this.title = 'OSSI - LES Command Maintenance';
        this.callParent(arguments);
    },

    performRefresh: function() {
        Ext.getBody().mask(RP.getMessage('wm.common.refreshing'));
        this.applet.getController('MainController').performRefresh();
        Ext.getBody().unmask();
    }
});