Ext.define("Actitime.view.InlineApp",{
    extend: "Ext.panel.Panel",
    alias: ["widget.actitime-inline-app"],
    
    autoScroll: true,
    layout: {
        type: "anchor"
    },
    
    dockedItems: [{
        dock: "top",
        xtype: "toolbar",
        items: [{
            text: 'Reload',
            itemid: 'tb-reload'
        }]
    }],
    
    update: function(records) {
        this.removeAll(true);
        
        Ext.iterate(records, function(record) {
            var p = Ext.create("Ext.panel.Panel", {
                title: record.get("taskname"),
                html: "<h1>TEST<h1><br />lalala",
                height: 80
            });
            
            this.add(p);
            
        }, this);
        
        this.doLayout();
    }
});