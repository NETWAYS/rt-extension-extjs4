
Ext.application({
    name: 'Actitime',
    autoCreateViewport: false,
    
    paths: { 'Actitime': '<% RT->Config->Get("WebBaseURL") %>/NoAuth/RTx-Actitime/js' },
    
    requires: [
        "Actitime.view.Container"
    ],
    
    views: ["InlineApp"],
    stores: ["Times"],
    
    launch: function() {
        
        var id = "actitime-application-container";
        
        var el = Ext.get(id);
        
        if (el) {
            
            var store = this.getTimesStore();
            store.load();
            
            var container = Ext.create("Actitime.view.Container", {
                renderTo: el,
                height: 400
            });
            
            container.doLayout();
        }
    }
});