Ext.define("Actitime.model.People", {
    extend: "Ext.data.Model",
    
    fields: [{
        name: "actuals",
        type: "int"
    }, {
        name: "name",
        type: "string"
    }, {
        name: "userid",
        type: "int"
    }],
    
    belongsTo: "Task"
});