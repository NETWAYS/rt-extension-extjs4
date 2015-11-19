Ext.define("Actitime.store.Times", {
    extend: "Ext.data.Store",
    requires: ["Actitime.model.Provider"],
    model: "Actitime.model.Provider",
    autoLoad: false,
    remoteFilter: true
});