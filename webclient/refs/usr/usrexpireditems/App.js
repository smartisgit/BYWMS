Ext.define('LES.usr.usrexpireditems.App', {
    namespace: 'LES.usr.usrexpireditems',
    extend: 'WM.taskflow.App',

    allowRefresh: true,
	allowExport: true,
    enableRefreshInterval: true,

    mixins: {
        refreshable: 'RP.mixin.Refreshable'
    },

    controllers: ['MainController'],
    views: ['MainView'],
    stores: ['MainStore','UsrexpireditemsStore'],

    mainView: 'MainView',
    centerTools: [{
        xtype:'tbspacer',
        flex:1
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
        this.title = 'Items Expiration Display';
        this.callParent(arguments);
    },

    performRefresh: function() {
        Ext.getBody().mask(RP.getMessage('wm.common.refreshing'));
        this.applet.getController('MainController').performRefresh();
        Ext.getBody().unmask();
    }
});