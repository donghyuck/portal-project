/**
 * COMMON UI MODELS
 * dependency : jquery
 */
;(function($, undefined) {
	var extend = $.extend;
	
	
	var EditableCompany = kendo.data.Model.define( {
	    id: "companyId", // the identifier of the model
	    fields: {
	    	companyId: { type: "number", editable: true, defaultValue: 0  },    	
	        name: { type: "string", editable: true , validation: { required: true }},
	        displayName: { type: "string", editable: true },
	        domainName: { type: "string", editable: true },
	        description: { type: "string", editable: true },
	        modifiedDate: { type: "date"},
	        creationDate: { type: "date" }
	        /*,
	        memberCount: { type: "number", editable: true, defaultValue: 0  },
	        adminCount: { type: "number", editable: true, defaultValue: 0  }*/
	    },
	    
	    copy : function ( target ){
	    	target.set("companyId", this.get("companyId"));
	    	target.set("name", this.get("name"));
	    	target.set("displayName", this.get("displayName"));
	    	target.set("domainName", this.get("domainName"));
	    	target.set("description", this.get("description"));
	    	target.set("modifiedDate", this.get("modifiedDate"));
	    	target.set("creationDate", this.get("creationDate"));
	    	/*target.set("memberCount", this.get("memberCount"));
	    	target.set("adminCount", this.get("adminCount"));		*/
	    	if( typeof this.get("properties") === 'object' )
	    		target.set("properties", this.get("properties"));
	    }    
	});
	
	
	
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
	
	/**
	 * 
	 */
	var CodeSet = kendo.data.Model.define( {
		id: "codeSetId",
		parentIdField: "parentCodeSetId",
	    fields: {
	    	codeSetId: { type: "number"},
	    	parentCodeSetId : { type: "number"},
	    	objectType : { type: "number"},
	    	objectId : { type: "number"},
	    	description:  { type: "string" },
	    	name : { type: "string" },	        
	    	modifiedDate: { type: "date"},
	        creationDate: { type: "date" },
	    	enabled : {type: "boolean" }
	    },
	    expanded: true
	});

	extend( common.ui.data, {
		CodeSet : CodeSet,
		EditableCompany : EditableCompany,
		stats : {
			Accumulator: Accumulator,
			Database : Database			
		},
		admin:{
			model : {
				
			},
			dataSource : {
				
			},
			
		}  
	} );
	
})(jQuery);
