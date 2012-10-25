Ext.define("Actitime.view.Container", {
    extend: "Ext.Container",
    
    requires: [
        "Actitime.view.InlineApp"
    ],
    
    layout: "fit",
    
    initComponent: function() {
        this.items = [{
            xtype: "actitime-inline-app"
        }];
        
        this.callParent();
    }
});