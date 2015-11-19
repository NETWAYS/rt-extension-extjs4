Ext.require([
	'Ext.form.ComboBox',
	'Ext.form.field.Hidden',
	'Ext.Container'
]);

Ext.application({
    name: 'RTx-DBCustomField',
    launch: function() {
% while(my($name, $c) = each(%{ $sources })) {
    		<&.createModel, config => $c, name => $name&>
    		<&.createStore, config => $c, name => $name&>
% }
    }
});

Ext.define('dbcf', {
    singleton: true,
    createCombo: function(o) {
    	
		var ele = Ext.get(o.id);
		if (ele) {
			
			var hidden = Ext.create('Ext.form.field.Hidden', {
				name: o.fieldName,
				value: null
			});
			
			var outputConfig = Ext.apply({
				html: 'OUTPUT',
				height: 20,
				bodyStyle: 'padding: 2px',
				width: 400
			}, o.returnFieldConfig || {});
			
			if (o.returnFieldTpl) {
				outputConfig.tpl = new Ext.XTemplate(o.returnFieldTpl);
			}
			
			if (Ext.isEmpty(o.value)) {
				outputConfig.hidden = true;
			}
			
			var output = Ext.create('Ext.Panel', outputConfig);
			
			var selectHandler = function(mixed) {
				if ("data" in mixed) {
					hidden.setValue(mixed.getId());
					output.update(mixed.data);
				} else {
					hidden.setValue(mixed.id);
					output.update(mixed);
				}
				
				if (output.isHidden()) {
					output.show();
				}
			}
			
			var comboConfig = Ext.apply({
				store: o.sourceName,
				labelWidth: 0,
				queryMode : 'remote',
				displayField : 'shortname',
				valueField : 'globalid',
				triggerAction: 'all',
				minChars: 3,
				width: 400,
				name: 'dbcf-' + o.sourceName,
				listeners: {
					select:  function(combo, records, oOpts) {
						var record = records.shift();
						selectHandler(record);
					}
				}
				
			}, o.fieldConfig || {});;
			
			if (o.fieldTpl) {
				comboConfig.listConfig = {
						itemTpl: new Ext.XTemplate(o.fieldTpl)
				};
			}
			
			var combo = Ext.create('Ext.form.ComboBox', comboConfig);
			
			// Ticket data for provider substitution
			if (Ext.isEmpty(o.objectType) === false && Ext.isEmpty(o.objectId) === false) {
				combo.getStore().on('beforeload', function(myStore, myOperation, myEOpts) {
					myOperation.params.objectType = o.objectType;
					myOperation.params.objectId = o.objectId;
				});
			}
		
			var container = Ext.create('Ext.Container', {
				id : o.sourceName + '-container',
				items : [combo, output, hidden],
				renderTo: ele,
				listeners: {
					afterrender: function() {
						if (Ext.isObject(o.value)) {
							selectHandler(o.value);
						}
					}
				}
			});
			
			container.render
			
			container.doLayout();
		}
    }
});

<%init>
unless ($session{'CurrentUser'}->Id) {
	return;
}

my $sources = RTx::DBCustomField->new()->getQueries();

$r->content_type('application/x-javascript');
</%init>
<%once>
	use JSON::XS;
</%once>
<%def .createModel>
	Ext.define('dbcf.model.<%$name%>', {
		extend: 'Ext.data.Model',
		fields: <%encode_json($fields) | n%>
	});
<%init>
	my $fields = ();
	if ($config->{'fields'}) {
		for my $key(keys(%{ $config->{'fields'} })) {
			push @{$fields}, { 
				name => $key, 
				type => 'string'
			};
		}
		
		if ($config->{'field_id'}) {
			push @{$fields}, { 
				name => 'id', 
				type => $config->{'field_id_type'} || 'int'
			};
		}
	}
</%init>
<%args>
	$config => {}
	$name => undef
</%args>
</%def>
<%def .createStore>
	Ext.create('Ext.data.Store', <%encode_json($store) | n%>);
<%init>
	my $store = {
		storeId => "$name",
		model => "dbcf.model.$name",
		proxy => {
			type => 'ajax',
			url => RT->Config->Get('WebURL'). "/RTx/DBCustomField/Provider.html?source=$name",
			reader => {
				type => 'json',
				root => 'result'
			}
		}
	};
</%init>
<%args>
$config => {}
$name => undef
</%args>
</%def>
