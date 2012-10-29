Ext.define("Actitime.view.Container", {
    extend: "Ext.Container",
    
    alias: ["widget.app-container"],
    
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