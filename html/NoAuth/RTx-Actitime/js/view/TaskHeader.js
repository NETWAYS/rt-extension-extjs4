Ext.define("Actitime.view.TaskHeader", {
    extend: "Ext.panel.Panel",
    alias: ["widget.task-header"],
    requires: ["Actitime.view.DetailButton"],
    
    layout: {
        type: "hbox",
        pack: "stretch",
        align: "left"
    },
    
    defaults: {
        margin: '2px 5px 0px 5px'
    },
    
    initComponent: function() {
        this.callParent();
    },
    
    update: function(record) {
        
        this.removeAll(true);
        
        this.add({
            xtype: "component",
            html: Ext.String.format(
                "<h2 style=\"line-height: 22px;\">{0}:</h2>",
                record.get("taskname")
            )
        });
        
        record.tasks().each(function(item) {
            this.add({
                xtype: "task-detail",
                task: item
            });
        }, this);
        
        this.add({
            xtype: "component",
            html: Ext.String.format(
                "<h2 style=\"line-height: 22px;\">Estimation: {0}</h2>",
                record.get("budget")
            )
        });
    }
})