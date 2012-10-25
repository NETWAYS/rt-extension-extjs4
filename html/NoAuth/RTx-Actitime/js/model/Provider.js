Ext.define("Actitime.model.Provider", {
    extend: "Ext.data.Model",
    
    fields: [
        { name: "project", type: "string" },
        { name: "sum", type: "int" },
        { name: "task", type: "string" },
        { name: "taskid", type: "string" }
    ],
    
    proxy: {
        type: "ajax",
        url: '<% RT->Config->Get("WebBaseURL") %>/RTx/Actitime/Provider.html?ticketid=149592',
        reader: {
            type: "json",
            root: "tasks"
        }
    }
});