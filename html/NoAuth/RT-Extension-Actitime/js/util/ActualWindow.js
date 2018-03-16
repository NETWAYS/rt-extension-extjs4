Ext.define("Actitime.util.ActualWindow", {
    extend: "Ext.window.Window",
    requires: [
        "Actitime.model.People",
        "Ext.grid.*",
        "Actitime.util.Format"
    ],
    singleton: true,
    renderTo: Ext.getBody(),
    layout: "fit",
    autoScroll: true,
    width: 450,
    height: 400,
    closeAction: "hide",
    title: "Actuals",
    
    dockedItems: [{
        xtype: "toolbar",
        dock: "bottom",
        items: ["->", {
            xtype: "button",
            text: "Close",
            iconCls: "actitime-icon-close",
            handler: function(b, e) {
                var win = b.findParentByType("window");
                win.hide();
            }
        }]
    }],
    
    initComponent: function() {
        
        this.store = Ext.create("Ext.data.Store", {
            autoLoad: false,
            model: "People",
            proxy: {
                type: "memory",
                reader: {
                    type: "json"
                }
            },
            sorters: [{
                property: "name",
                direction: "ASC"
            }]
        });
        
        this.items = [{
            xtype: "grid",
            layout: "fit",
            border: false,
            store: this.store,
            forceFit: true,
            columns: [{
                text: "Name",
                dataIndex: "name",
                flex: 4
            }, {
                text: "Actuals",
                dataIndex: "actuals",
                flex: 1,
                renderer: Actitime.util.Format.actuals
            }]
        }]
        
        this.callParent();
    },
    
    update: function(record) {
        var title = record.get("project") + ": " + record.get("task");
        this.setTitle(title);
        this.store.loadRecords(record.peoples().data.items);
    }
})