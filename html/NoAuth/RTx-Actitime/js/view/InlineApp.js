Ext.define("Actitime.view.InlineApp",{
    extend: "Ext.panel.Panel",
    alias: ["widget.actitime-inline-app"],
    requires: ["Actitime.view.SingleTask"],
    
    autoScroll: true,
    layout: {
        type: "anchor"
    },
    
    dockedItems: [{
        dock: "top",
        xtype: "toolbar",
        items: [{
            text: "Reload",
            itemId: "tb-reload"
        }, {
            text: "Context",
            menu: [{
                xtype: "menucheckitem",
                text: "Use customer id for tasks",
                itemId: "tb-customer",
                checked: false
            }]
        }]
    }],
    
    bodyStyle: {
        padding: '5px'
    },
    
    minHeight: 100,
    maxHeight: 400,
    
    initComponent: function() {
        
        this.addEvents({
            beforeupdate: true,
            update: true,
        })
        
        this.callParent();
    },
    
    update: function(records) {
        
        if (this.fireEvent("beforeupdate", this) === true) {
        
            this.removeAll(true);
            
            Ext.iterate(records, function(record) {
                this.add({
                    xtype: 'actitime-singletask',
                    task: record
                });
                
            }, this);
            
            this.doLayout();
            
            this.fireEvent("update", this);
        }
    }
});