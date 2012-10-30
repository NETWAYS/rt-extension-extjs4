Ext.define("Actitime.view.DetailButton", {
    extend: "Ext.button.Split",
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
        
        this.menu = Ext.create("Ext.menu.Menu", {
            items: [{
                text: "Show actuals",
                handler: this.onShowActuals,
                scope: this,
                iconCls: "actitime-icon-user"
            }, {
                text: "Show actitime",
                handler: this.onShowActitime,
                scope: this,
                iconCls: "actitime-icon-bookmark"
            }]
        });
        
        this.on("click", this.onShowActuals, this);
        
        this.callParent();
        
    },
    
    onShowActuals: function() {
        this.wnd.alignTo(this.getEl(), 'tr?');
        this.wnd.update(this.task);
        this.wnd.show();
    },
    
    onShowActitime: function() {
        var config = Actitime.util.Config;
        var taskid = this.task.get("taskid");
        var url = "{0}/tasks/task_details.do?taskId={1}";
        var st = this.statics();
        
        url = Ext.String.format(url, config.get("actitimeurl"), taskid);
        
        if (!st.wnd) {
            st.wnd = window.open();
        } else if (st.wnd.closed === true) {
            st.wnd = window.open();
        }
        
        st.wnd.location = url;
        st.wnd.focus();
        
    }
});