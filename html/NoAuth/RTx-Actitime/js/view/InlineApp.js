Ext.define("Actitime.view.InlineApp",{
    extend: "Ext.panel.Panel",
    alias: ["widget.actitime-inline-app"],
    layout: "fit",
    
    dockedItems: [{
        dock: "top",
        xtype: "toolbar",
        items: [{
            text: 'test'
        }]
    }]
});