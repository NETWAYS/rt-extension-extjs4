Ext.define("Actitime.controller.Main", {
    extend: "Ext.app.Controller",
    
    refs: [{
        selector: 'container',
        ref: 'container'
    }, {
        selector: 'actitime-inline-app',
        ref: 'panel'
    }],
    
    stores: ["Times"],
    models: ["Provider", "Task", "People"],
    controllers: ["Actitime.controller.Main"],
    
    ticketid: null,
    customerid: null,
    type: 'ticket',
    
    init: function() {
        
        this.control({
            'actitime-inline-app': {
                beforerender: this.containerBeforeRender,
                afterrender: this.containerAfterRender
            },
            
            'actitime-inline-app > toolbar > button[itemid=tb-reload]': {
                click: this.toolbarReload
            }
        });
        
        this.getTimesStore().on("load", this.renderView, this);
    },
    
    onLaunch: function() {
        this.reloadView();
    },
    
    setTicketId: function(ticketid) {
        this.ticketid = ticketid;
    },
    
    getTicketId: function() {
        return this.ticketid;
    },
    
    setCustomerId: function(customerid) {
        this.customerid = customerid;
    },
    
    getCustomerId: function() {
        return this.customerid;
    },
    
    setType: function(type) {
        this.type = type;
    },
    
    getType: function() {
        return this.type;
    },
    
    reloadView: function() {
        
        this.setType('ticket');
        this.setTicketId(138612);
        
        var type = this.getType();
        var store = this.getTimesStore();
        
        store.clearFilter(true);
        
        if (type === "ticket") {
            store.filter("ticketid", this.getTicketId());
        } else if (type === "customer") {
            store.filter("customerid", this.getCustomerId());
        } else {
            Ext.Error.raise("Not a valid view type: "+ type);
        }
    },
    
    renderView: function(store, records) {
        this.getPanel().update(records);
    },
    
    containerBeforeRender: function() {
        console.log("Container: Creating");
    },
    
    containerAfterRender: function() {
        console.log("Container: Ready to use");
    },
    
    toolbarReload: function() {
        this.reloadView();
    }
});