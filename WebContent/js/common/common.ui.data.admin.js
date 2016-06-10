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
	

	var WebPage =  kendo.data.Model.define({
		id : "webPageId",
		fields: { 
			webPageId: { type:"number", defaultValue:0 },	
			webSiteId: { type:"number", defaultValue:0 },	
			name: { type: "string", defaultValue:"" },
			displayName: { type:"string", defaultValue:"." },
			contentType: { type:"string", defaultValue:"text/html;charset=UTF-8" },
			description: { type:"string" },
			template: { type:"string" },
			locale: { type:"string" },
			enabled : { type:"boolean", defaultValue:false, editable:true },
			properties : { type: "object", editable: true, defaultValue:[]},  
			creationDate: { type:"date"},
			modifiedDate: { type:"date"}
		},
	    formattedCreationDate: function(){
	    	return kendo.toString(this.get("creationDate"), "g");
	    },
	    formattedModifiedDate : function(){
	    	return kendo.toString(this.get("modifiedDate"), "g");
	    },	    
	    copy: function ( target ){
	    	target.webPageId = this.get("webPageId");
	    	target.set("webSiteId",this.get("webSiteId") );
	    	target.set("name",this.get("name") );
	    	target.set("displayName",this.get("displayName") );
	    	target.set("contentType",this.get("contentType") );
	    	target.set("description",this.get("description") );
	    	target.set("template",this.get("template") );
	    	target.set("locale",this.get("locale") );
	    	target.set("enabled", this.get("enabled"));
	    	target.set("creationDate",this.get("creationDate") );
	    	target.set("modifiedDate",this.get("modifiedDate") );
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
		parentId: "parentCodeSetId",
		expanded: true,
	    fields: {
	    	codeSetId: { type: "number"},
	    	parentCodeSetId : { field:"parentCodeSetId", nullable:true },
	    	objectType : { type: "number"},
	    	objectId : { type: "number"},
	    	description:  { type: "string" },
	    	name : { type: "string" },	        
	    	modifiedDate: { type: "date"},
	        creationDate: { type: "date" },
	    	enabled : {type: "boolean" }
	    }
	    
	});

	extend( common.ui.data, {
		CodeSet : CodeSet,
		EditableCompany : EditableCompany,
		WebPage : WebPage,
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
