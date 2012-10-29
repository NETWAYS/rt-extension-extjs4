Ext.define("Actitime.view.DetailButton", {
    extend: "Ext.button.Split",
    alias: ["widget.task-detail"],
    initComponent: function() {
        
        this.text = Ext.String.format(
            "<b>{0}</b>: {1}",
            this.task.get("task"),
            this.task.get("sum")
        );
        
        this.menu = Ext.create("Ext.menu.Menu", {
            items: [{
                text: "Show actuals",
                handler: this.onShowActuals,
                scope: this
            }, {
                text: "Show actitime",
                handler: this.onShowActitime,
                scope: this
            }]
        });
        
        this.callParent();
        
    },
    
    onShowActuals: function() {
        
    },
    
    onShowActitime: function() {
        
    }
});