Ext.define("Actitime.model.Task", {
    extend: "Ext.data.Model",
    
    requires: ["Actitime.model.People"],
    
    fields: [{
        name: "project",
        type: "string"
    }, {
        name: "budget",
        type: "int"
    }, {
        name: "customer",
        type: "string"
    }, {
        name: "deadline",
        type: "string"
    }, {
        name: "task",
        type: "string"
    }, {
        name: "taskid",
        type: "int"
    }, {
        name: "sum",
        type: "int",
        mapping: "sum"
    }],
    
    associations: [{
        type: "hasMany",
        model: "Actitime.model.People",
        name: "peoples",
        associationKey: "people"
    }],
    
    belongsTo: "Provider"
});