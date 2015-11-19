
Ext.application({
    name: 'Actitime',
    autoCreateViewport: false,
    
    paths: { 'Actitime': '<% RT->Config->Get("WebURL") %>NoAuth/RTx-Actitime/js' },
    
    requires: [
        "Actitime.view.Container",
        "Actitime.util.Format",
        "Actitime.util.Config"
    ],
    
    views: ["InlineApp"],
    stores: ["Times"],
    models: ["Provider", "Task", "People"],
    controllers: ["Main"],
    
    launch: function() {
        
        var id = "actitime-application-container";
        
        var el = Ext.get(id);
        
        if (el) {
            
            this.initConfiguration(el);
            
            var container = Ext.create("Actitime.view.Container", {
                renderTo: el,
                maxHeight: 400
            });
            
            container.doLayout();
        }
        
        Ext.XTemplate.addMember("actuals", Actitime.util.Format.actuals);
        
        Ext.QuickTips.init();
    },
    
    initConfiguration: function(el) {
        var attributes = {
            "ticketid": null,
            "customerid": null,
            "actitimeurl": null
        };
        
        var elements = el.select("div");
        
        elements.each(function(config) {
            Ext.iterate(attributes, function(key, val) {
                var attr = config.getAttribute("actitime:" + key);
                if (attr) {
                    attributes[key] = attr;
                }
            });
            config.destroy();
        });
        
        // For later use
        var configuration = Actitime.util.Config;
        configuration.addAll(attributes);
        
        // Make the controller ready
        var controller = this.getController("Main");
        controller.setTicketId(attributes.ticketid);
        controller.setCustomerId(attributes.customerid);
    }
});
