/**
 * COMMON UI MODELS
 * dependency : jquery
 */
;(function($, undefined) {
	
	var Accumulator = kendo.data.Model.define( {
	    id: "id", // the identifier of the model
	    fields: {
	    	id: {  type: "number", defaultValue: 0 },	    	
	    	name: { type: "string" },
	    	path: { type: "string" },
	        lastValueDate: { type: "date" },
	        formattedLastValueDate : { type: "string" }
	    },
	    copy : function ( target ){
	    	target.id = this.get("id");
	    	target.set("name", this.get("name"));		    	
	    	target.set("path", this.get("path"));
	    	target.set("lastValueDate", this.get("lastValueDate"));
	    	target.set("lastValueDate", this.get("lastValueDate"));	
	    }
	});	
	
	
	extend( common.ui.data, {
		stats : {
			Accumulator: Accumulator	
		}
	} );
	
})(jQuery);