Ext.define("Actitime.model.Provider", {
    extend: "Ext.data.Model",
    
    requires: [
        "Actitime.model.Task"
    ],
    
    fields: [{
        name: "project",
        type: "string" 
    }, {
        name: "sum",
        type: "int"
    }, {
        name: "budget",
        type: "int"
    }, {
        name: "variance",
        type: "int"
    }, {
        name: "task",
        type: "string"
    }, {
        name: "taskid",
        type: "string"
    }, {
        name: "taskname",
        type: "string"
    }, {
        name: "active_budget",
        type: "int",
        mapping: "active.budget"
    }, {
        name: "active_sum",
        type: "int",
        mapping: "active.sum"
    }, {
        name: "active_variance",
        type: "int",
        mapping: "active.variance"
    }, {
        name: "active_labels",
        type: "string",
        mapping: "active.labels"
    }, {
        name: "inactive_budget",
        type: "int",
        mapping: "inactive.budget"
    }, {
        name: "inactive_sum",
        type: "int",
        mapping: "inactive.sum"
    }, {
        name: "inactive_variance",
        type: "int",
        mapping: "inactive.variance"
    }, {
        name: "inactive_labels",
        type: "string",
        mapping: "inactive.labels"
    }],
    
    associations: [{
        type: "hasMany",
        model: "Actitime.model.Task",
        name: "tasks"
    }],
    
    proxy: {
        type: "ajax",
        url: "<% RT->Config->Get("WebURL") %>RTx/Actitime/Provider.html",
        reader: {
            type: "json",
            root: "tasks"
        }
    }
});
