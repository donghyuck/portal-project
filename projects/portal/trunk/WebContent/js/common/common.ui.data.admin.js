/**
 * COMMON UI MODELS
 * dependency : jquery
 */
;(function($, undefined) {
	var extend = $.extend;
	
	var Accumulator = kendo.data.Model.define( {
	    id: "id", // the identifier of the model
	    fields: {
	    	id: {  type: "number", defaultValue: 0 },	    	
	    	name: { type: "string" },
	    	path: { type: "string" },
	        lastValueDate: { type: "date" },
	        numberOfValues : { type: "number", defaultValue: 0 }
	    },
		formattedLastValueDate : function(){
	    	return kendo.toString(this.get("lastValueDate"), "g");
	    },	    
	    copy : function ( target ){
	    	target.id = this.get("id");
	    	target.set("name", this.get("name"));		    	
	    	target.set("path", this.get("path"));
	    	target.set("lastValueDate", this.get("lastValueDate"));
	    	target.set("numberOfValues", this.get("numberOfValues"));	
	    }
	});	
	
	var Database = kendo.data.Model.define( {
	    fields: {
	    	databaseName: { type: "string",  editable: false },
	    	databaseVersion:  { type: "string", editable: false },
	    	driverName : { type: "string", editable: false},
	    	driverVersion: {type: "string", editable: false},
	    	isolationLevel: {type: "string", editable: false}
	    }
	});
	
	extend( common.ui.data, {
		stats : {
			Accumulator: Accumulator,
			Database : Database
		}
	} );
	
})(jQuery);