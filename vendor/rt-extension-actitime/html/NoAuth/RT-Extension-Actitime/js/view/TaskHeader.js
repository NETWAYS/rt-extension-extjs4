Ext.define("Actitime.view.TaskHeader", {
    extend: "Ext.panel.Panel",
    alias: ["widget.task-header"],
    requires: ["Actitime.view.DetailButton"],
    
    layout: {
        type: "vbox",
        pack: "stretch",
        align: "left",
        defaultMargins: {
            top: 2
        }
    },
    
    defaults: {
        border: false
    },
    
    initComponent: function() {
        
        this.items = [{
            xtype: "panel",
            itemId: "header-top",
            style: {
                margin: '0 0 5px 0'
            },
            tpl: new Ext.XTemplate([
                '<div class="actitime-header">{taskname}</div>',
                '<div class="actitime-header-sub">gone: ',
                '{active_sum:this.actuals}, estimated: {active_budget:this.actuals}, ',
                'variance: {active_variance:this.actuals}</div>',
            ])
        }, {
            xtype: "panel",
            itemId: "header-bottom",
            layout: {
                type: "hbox",
                defaultMargins: {
                    right: 3
                }
            }
        }];
        
        this.callParent();
    },
    
    update: function(record) {
        this.getComponent("header-top").update(record.getData());
        
        var bottom = this.getComponent("header-bottom");
        bottom.removeAll(true);
        record.tasks().each(function(item) {
            bottom.add({
                xtype: "task-detail",
                task: item
            });
        }, this);
    }
})