Ext.define("Actitime.view.SingleTask", {
    extend: "Ext.panel.Panel",
    alias: ["widget.actitime-singletask"],
    requires: [
        "Actitime.view.TaskHeader",
        "Actitime.view.TaskProgress",
    ],
    
    layout: {
        type: "vbox",
        align: "stretch"
    },
    
    defaults: {
        border: false
    },
    
    border: false,
    
    initComponent: function() {
        
        this.taskProgress = Ext.create("Actitime.view.TaskProgress",{
            itemId: "task-progress"
        });
        
        this.items = [{
            xtype: "task-header",
            itemId: "task-header"
        }, {
            layout: "fit",
            bodyPadding: 5,
            items: [this.taskProgress]
        }]
        
        this.callParent();
        
        if (this.task) {
            this.update(this.task);
        }
    },
    
    update: function(record) {
        this.getComponent("task-header").update(record);
        this.taskProgress.update(record);
    }
});