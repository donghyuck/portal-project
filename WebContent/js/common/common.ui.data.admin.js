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
	
	
	extend( common.ui.data, {
		stats : {
			Accumulator: Accumulator	
		}
	} );
	
})(jQuery);