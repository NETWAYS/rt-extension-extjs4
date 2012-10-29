Ext.define("Actitime.view.SingleTask", {
    extend: "Ext.panel.Panel",
    alias: ["widget.actitime-singletask"],
    requires: [
        "Actitime.view.TaskHeader",
        "Actitime.view.TaskProgrss",
    ],
    border: false,
    
    layout: {
        type: "vbox",
        align: "stretch"
    },
    
    defaults: {
        border: false
    },
    
    initComponent: function() {
        
        this.items = [{
            xtype: "task-header",
            itemId: "task-header",
            flex: 1
        }, {
            xtype: "task-progress",
            itemId: "task-progress",
            flex: 2,
        }]
        
        this.callParent();
        
        if (this.task) {
            this.update(this.task);
        }
    },
    
    update: function(record) {
        var header = this.getComponent("task-header");
        header.update(record);
    }
});