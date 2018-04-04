Ext.define("Actitime.view.DetailButton", {
    extend: "Ext.button.Button",
    alias: ["widget.task-detail"],
    requires: [
        "Actitime.util.ActualWindow",
        "Actitime.util.Format",
        "Actitime.util.Config"
    ],
    statics: {
        wnd: null
    },
    initComponent: function() {
        
        this.wnd = Actitime.util.ActualWindow;
        
        this.text = Ext.String.format(
            "<b>{0}</b>: {1}",
            this.task.get("task"),
            Actitime.util.Format.actuals(this.task.get("sum"))
        );
        
        this.on("click", this.onShowActuals, this);
        
        this.callParent();
        
    },
    
    onShowActuals: function() {
        this.wnd.alignTo(this.getEl(), 'tr?');
        this.wnd.update(this.task);
        this.wnd.show();
    }
});