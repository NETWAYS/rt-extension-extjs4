Ext.define("Actitime.controller.Main", {
    extend: "Ext.app.Controller",
    
    refs: [{
        selector: 'app-container',
        ref: 'container'
    }, {
        selector: 'actitime-inline-app',
        ref: 'panel'
    }],
    
    requires: ["Actitime.util.Format"],
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
            
            'container > toolbar > button[itemId=tb-reload]': {
                click: this.toolbarReload
            },
            
            'container > toolbar > button > menucheckitem[itemId=tb-customer]': {
                checkchange: this.toolbarCustomerChange
            },
            
            'container > toolbar > button[itemId=tb-units] > menucheckitem': {
                checkchange: this.toolbarUnitChange
            }
        });
        
        this.getTimesStore().on("load", this.renderView, this);
    },
    
    onLaunch: function() {
        
        if (!this.getTicketId() && !this.getCustomerId()) {
            Ext.Error.raise("Need a ticketid and customerid");
        }
        
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
    
    createMask: function() {
        this.loadingMask = new Ext.LoadMask(this.getContainer(), {
            msg: "Loading tasks, please wait . . ."
        });
        
        this.loadingMask.show();
        
        return true;
    },
    
    
    hideMask: function() {
        if (this.loadingMask) {
            this.loadingMask.hide();
            this.loadingMask.destroy();
            this.loadingMask = null;
        }
    },
    
    reloadView: function() {

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
        
        this.getPanel().removeAll(true);
        
        this.getPanel().hide();
        
        this.createMask();

        this.getPanel().on("update", function() {
            this.hideMask();
        }, this, { single: true});
        
        var task = new Ext.util.DelayedTask(function() {
            this.getPanel().update(records);
            this.getPanel().doLayout();
            this.getPanel().show();
        }, this);
        
        task.delay(200);
    },
    
    containerBeforeRender: function() {
        // console.log("Container: Creating");
    },
    
    containerAfterRender: function() {
        // console.log("Container: Ready to use");
    },
    
    toolbarReload: function() {
        this.reloadView();
    },
    
    toolbarCustomerChange: function(box, value) {
        if (value === true) {
            this.setType("customer");
        } else {
            this.setType("ticket");
        }
        
        this.reloadView();
    },
    
    toolbarUnitChange: function(item, checked) {
        if (checked) {
            Actitime.util.Format.setUnit(item.itemId);
            this.reloadView();
        }
    }
});