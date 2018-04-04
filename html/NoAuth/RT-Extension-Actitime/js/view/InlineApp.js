Ext.define("Actitime.view.InlineApp",{
    extend: "Ext.panel.Panel",
    alias: ["widget.actitime-inline-app"],
    requires: ["Actitime.view.SingleTask"],
    
    autoScroll: true,
    border: false,
    layout: {
        type: "anchor"
    },
    
    bodyStyle: {
        padding: '5px'
    },
    
    initComponent: function() {
        
        this.addEvents({
            beforeupdate: true,
            update: true,
        })
        
        this.callParent();
    },
    
    update: function(records) {
        
        if (this.fireEvent("beforeupdate", this) === true) {
        
            this.removeAll(true);
            
            if (records === null) {
                var content = "<div class=\"actitime-spacer\"></div>"
                    + "<div class=\"actitime-h1\">"
                    + "Error. Could not load data!</div>";
                
                this.callParent([content]);
            } else if (records.length <= 0) {
                var content = "<div class=\"actitime-spacer\"></div>"
                    + "<div class=\"actitime-h1\">"
                    + "No time information for this ticket</div>";
                
                this.callParent([content]);
            } else {
                
                this.callParent([""]);
                
                Ext.iterate(records, function(record) {
                    this.add({
                        xtype: 'actitime-singletask',
                        task: record
                    });
                    
                }, this);
            
            }
            this.doLayout();
            
            this.fireEvent("update", this);
        }
    }
});