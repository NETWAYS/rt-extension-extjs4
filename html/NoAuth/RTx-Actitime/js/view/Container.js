Ext.define("Actitime.view.Container", {
    extend: "Ext.panel.Panel",
    
    alias: ["widget.app-container"],
    
    requires: [
        "Actitime.view.InlineApp"
    ],
    
    layout: "fit",
    height: 300,
    
    border: true,
    
    dockedItems: [{
        dock: "top",
        xtype: "toolbar",
        items: [{
            text: "Reload",
            itemId: "tb-reload",
            iconCls: "actitime-icon-refresh"
        }, {
            text: "Context",
            iconCls: "actitime-icon-customers",
            menu: [{
                xtype: "menucheckitem",
                text: "Show all customer tasks",
                itemId: "tb-customer",
                checked: false
            }]
        }, {
            text: "Units",
            itemId: "tb-units",
            iconCls: "actitime-icon-settings",
            menu: [{
                xtype: "menucheckitem",
                text: "Hours",
                group: "units",
                itemId: "hour"
            }, {
                xtype: "menucheckitem",
                text: "Workdays",
                group: "units",
                itemId: "day",
                checked: true
            }]
        }]
    }],
    
    initComponent: function() {
        this.items = [{
            xtype: "actitime-inline-app"
        }];
        
        this.callParent();
    }
});