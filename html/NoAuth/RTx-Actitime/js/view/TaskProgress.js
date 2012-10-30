Ext.define("Actitime.view.TaskProgress", {
    extend: "Ext.Container",
    alias: ["widget.task-progress"],
    border: true,
    
    defaults: {
        border: false
    },
    
    layout: {
        type: "hbox",
        align: "stretch"
    },
    budget: 0,
    sum: 0,
    
    initComponent: function() {
        
        this.progressBar = Ext.create("Ext.ProgressBar", {
            itemId: "progressbar",
            value: 0,
            text: "",
            border: true,
            flex: 12
        });
        
        this.items = [this.progressBar, {
            html: "",
            flex: 1,
            itemId: "progress-icon",
            tpl: new Ext.XTemplate("<div class=\"actitime-icon {icon}\"></div>"),
            bodyStyle: {
                margin: '0px 0px 0px 10px'
            },
            width: 150
        }];
        
        this.on("afterrender", this.initQuickTip, this, { single : true });
        
        this.callParent();
    },
    
    initQuickTip: function() {
        this.tip = Ext.create("Ext.tip.ToolTip", {
            target: this.getComponent("progress-icon").getEl(), 
            tpl: new Ext.XTemplate([
                "<div class=\"actitime-h2\">{header}</div>",
                "<div>{content}</div>"
            ])
        });
    },
    
    setBudget: function(budget) {
        this.budget = budget;
    },
    
    getBudget: function() {
        return this.budget;
    },
    
    setSum: function(sum) {
        this.sum = sum;
    },
    
    getSum: function() {
        return this.sum;
    },
    
    getPercentValue: function(asInt) {
        var val = 0;
        
        if (this.budgetConfigured() === true) {
            val = this.getSum() / this.getBudget();
        }
        
        if (asInt) {
            return val*100;
        }
        
        return val;
    },
    
    budgetConfigured: function() {
        if (this.getBudget() === 0) {
            return false;
        }
        
        return true;
    },
    
    budgetIsThreshold: function(percent) {
        var p = this.getPercentValue(true);
        if (p>percent) {
            return true;
        }
        
        return false;
    },
    
    budgetIsWarning: function() {
        return this.budgetIsThreshold(80);
    },
    
    budgetIsCritical: function() {
        return this.budgetIsThreshold(90);
    },
    
    budgetFailed: function() {
        return this.budgetIsThreshold(100);
    },
    
    updateIcon: function() {
        var iconFrame = this.getComponent("progress-icon");
        var icon = "";
        
        if (this.budgetConfigured() === false) {
            icon = "actitime-icon-budget-unconfigured";
        } else if (this.budgetFailed() ===true) {
            icon = "actitime-icon-budget-failed";
        } else if (this.budgetIsCritical() === true) {
            icon = "actitime-icon-budget-critical";
        } else if (this.budgetIsWarning() === true) {
            icon = "actitime-icon-budget-warning";
        } else {
            icon = "actitime-icon-budget-ok";
        }
        
        iconFrame.update({icon: icon});
    },
    
    updateQuickTip: function() {
        
        var header = null;
        var text = null;
        
        if (this.budgetConfigured() === false) {
            header = "Unconfigured";
            text = "Please configure an estimation for this task!";
        } else if (this.budgetFailed() ===true) {
            header = "Failed!";
            text = "Current budget exhausted!";
        } else if (this.budgetIsCritical() === true) {
            header = "Critical";
            text = "Current budget is in state critical!";
        } else if (this.budgetIsWarning() === true) {
            header = "Warning";
            text = "Current budget is in state warning!";
        } else {
            header = "Everything's on track";
            text = "Current budget have a green light!";
        }
        
        this.on("afterrender", function() {
            this.tip.update({
                header: header,
                content: text
            });
        }, this, {single: true});
    },
    
    updateProgressbar: function() {
        var value = this.getPercentValue();
        var ptextval = Ext.util.Format.round(value*100, 2);
        var text = Ext.String.format("{0} %", ptextval);
        this.progressBar.updateProgress(value, text);
    },
    
    update: function(record) {
        this.setSum(record.get("sum"));
        this.setBudget(record.get("budget"));
        this.updateProgressbar();
        this.updateIcon();
        this.updateQuickTip();
    }
})