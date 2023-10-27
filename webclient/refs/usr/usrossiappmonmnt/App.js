Ext.define('LES.usr.usrossiappmonmnt.App', {
    namespace: 'LES.usr.usrossiappmonmnt',
    extend: 'WM.taskflow.App',

    allowRefresh: true,
    enableRefreshInterval: true,
	allowExport: true,

    mixins: {
        refreshable: 'RP.mixin.Refreshable'
    },

    controllers: ['MainController'],
    views: ['MainView'],
    stores: ['MainStore','UsrossiappmonmntStore','UsrossiappmonparmmntStore'],

    mainView: 'MainView',
    centerTools: [{
        xtype:'tbspacer',
        flex:1
    },
	{
		xtype: 'button',
		itemId: 'btnnew',
		id:'newbtn',
		text: 'New',
		glyph: RP.Glyphs.Add.value
	},
	{
		xtype: 'button',
        itemId: 'btnsave',
        id: 'savebtn',
		text: 'Save',
		glyph: RP.Glyphs.Save.value
	},
	{
		xtype: 'button',
        itemId: 'btndelete',
        id: 'deletebtn',
		text: 'Delete',
		glyph: RP.Glyphs.Delete.value
	},
    {
        xtype: 'button',
        itemId: 'btnclear',
        text: 'Clear',
        glyph: RP.Glyphs.RestoreReset.value
    },
	{
        xtype: 'button',
        itemId: 'btnfind',
        text: 'Find',
        glyph: RP.Glyphs.Find.value
    }],
    initComponent: function() {
        this.title = 'OSSI - Application Monitor Maintenance';
        this.callParent(arguments);
    },

    performRefresh: function() {
        Ext.getBody().mask(RP.getMessage('wm.common.refreshing'));
        this.applet.getController('MainController').performRefresh();
        Ext.getBody().unmask();
    }
});