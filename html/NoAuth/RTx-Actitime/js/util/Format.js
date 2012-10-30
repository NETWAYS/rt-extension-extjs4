Ext.define("Actitime.util.Format", {
    singleton: true,
    
    required: ["Ext.util.Format"],
    
    unit: "day",
    
    showUnit: true,
    
    units: {
        day: "d",
        hour: "h"
    },
    
    workHours: 8,
    
    setWorkHours: function(wh) {
        this.workHours = wh;
    },
    
    getWorkHours: function() {
        return this.workHours;
    },
    
    setUnit: function(unit) {
        if (Ext.isEmpty(this.units[unit])) {
            Ext.Error.raise("Unnit not found: " + unit);
        }
        
        this.unit = unit;
    },
    
    showUnitInFormat: function() {
        this.showUnit = true;
    },
    
    hideUnitInFormat: function() {
        this.showUnit = false;
    },
    
    getUnit: function() {
        return this.unit;
    },
    
    getReadableUnit: function() {
        return this.units[this.unit];
    },
    
    roundFunction: function(value) {
        return Ext.util.Format.round(value, 2);
    },
    
    calcValue: function(value) {
        if (this.getUnit() === "hour") {
            value = value / 60;
        } else if (this.getUnit() === "day") {
            value = value / 60 / this.getWorkHours();
        }
        
        return this.roundFunction(value);
    },
    
    actuals: function(actuals) {
        actuals = Actitime.util.Format.calcValue(actuals);
        
        if (Actitime.util.Format.showUnit === true) {
            actuals += Actitime.util.Format.getReadableUnit();
        }
        
        return actuals;
    }
})