Ext.define("Actitime.view.TaskProgrss", {
    extend: "Ext.Container",
    alias: ["widget.task-progress"],
    border: false,
    height: 22,
    
    defaults: {
        border: false
    },
    
    layout: {
        type: "hbox",
        align: "stretch"
    },
    
    initComponent: function() {
        this.items = [{
            xtype: "progressbar",
            itemId: "progrssbar",
            value: 1,
            text: "100%",
            flex: 10
        }, {
            html: "TEST2",
            flex: 1,
            bodyStyle: {
                margin: '0px 0px 0px 10px'
            },
            width: 150
        }]

        this.callParent();
    },
    
    update: function(record) {
        
    }
})