Ext.define('LES.usr.ucissueassignment.store.MainStore', {
    extend: 'Ext.data.Store',
    storeId: 'mainStore',
    proxy: {
        type: 'rpuxRest',
        api: {
            read: RP.buildDataServiceUrl('wm', 'jmigrator/process/listdata'),
            create: RP.buildDataServiceUrl('wm', 'jmigrator/process/createdata'),
            update: RP.buildDataServiceUrl('wm', 'jmigrator/process/updatedata'),
            destroy: RP.buildDataServiceUrl('wm', 'jmigrator/process/deletedata')
        },
        reader: {
            type: 'json',
            root: 'data',
            totalProperty: 'totalCount'
        },
        actionMethods: {
            create  : 'POST',
            read    : 'POST',
            update  : 'PUT',
            destroy : 'DELETE'
        },
        paramsAsJson: true,
        listeners: {
            exception: function(proxy, response, options) {
                var mocaStatus = response.status;
                if (mocaStatus === 404) {
                    //Ext.Msg.alert(RP.getMessage('wm.common.error'), 'No record(s) found.');
                }
            }
        }
    }
});