(function($, undefined) {
	
	var extend = $.extend;
	
	var Competency = kendo.data.Model.define( {
	    id: "competencyId", // the identifier of the model
	    fields: {
	    	competencyId: { type: "number", editable: true, defaultValue: 0  },    	
	    	objectType: { type: "number", editable: true, defaultValue: 0  },   
	    	objectId: { type: "number", editable: true, defaultValue: 0  },   
	        name: { type: "string", editable: true },
	        level: { type: "number", editable: true, defaultValue: 0  },   
	        description: { type: "string", editable: true },
	    },	    
	    copy : function ( target ){
	    	target.set("competencyId", this.get("competencyId"));
	    	target.set("objectType", this.get("objectType"));
	    	target.set("objectId", this.get("objectId"));
	    	target.set("name", this.get("name"));
	    	target.set("description", this.get("description"));
	    	target.set("level", this.get("level"));
	    	if( typeof this.get("properties") === 'object' )
	    		target.set("properties", this.get("properties"));
	    	else
	    		target.set("properties", {});
	    }    
	});

	var Job = kendo.data.Model.define( {
	    id: "jobId", // the identifier of the model
	    fields: {
	    	jobId: { type: "number", editable: true, defaultValue: 0  },    	
	    	objectType: { type: "number", editable: true, defaultValue: 0  },   
	    	objectId: { type: "number", editable: true, defaultValue: 0  },   
	        name: { type: "string", editable: true },
	        description: { type: "string", editable: true },
	    	modifiedDate: { type: "date"},
	        creationDate: { type: "date" }	        
	    },	    
	    copy : function ( target ){
	    	target.set("jobId", this.get("jobId"));
	    	target.set("objectType", this.get("objectType"));
	    	target.set("objectId", this.get("objectId"));
	    	target.set("name", this.get("name"));
	    	target.set("description", this.get("description"));
	    	
	    	if( typeof this.get("classification") === 'object' ){
	    		target.set("classification", this.get("classification"));
	    	}else{
	    		target.set("classification", {
	    			classifiedMajorityId:null,
	    			classifiedMiddleId:null,
	    			classifiedMinorityId:null
	    		} );
	    	}
	    	
	    	if( typeof this.get("properties") === 'object' )
	    		target.set("properties", this.get("properties"));
	    	else
	    		target.set("properties", {});
	    }    
	});
	
	
	var EssentialElement = kendo.data.Model.define( {
	    id: "essentialElementId", // the identifier of the model
	    fields: {
	    	essentialElementId: { type: "number", editable: true, defaultValue: 0  },    	
	    	competencyId: { type: "number", editable: true, defaultValue: 0  },   
	    	level: { type: "number", editable: true, defaultValue: 0  },   
	        name: { type: "string", editable: true }
	    },	    
	    copy : function ( target ){
	    	target.set("essentialElementId", this.get("essentialElementId"));
	    	target.set("competencyId", this.get("competencyId"));
	    	target.set("level", this.get("level"));
	    	target.set("name", this.get("name"));
	    	if( typeof this.get("properties") === 'object' )
	    		target.set("properties", this.get("properties"));
	    	else
	    		target.set("properties", {});
	    }    
	});	
	
	var CodeSet = kendo.data.Model.define( {
	    id: "codeSetId", // the identifier of the model
	    parentId : "parentCodeSetId",
	    fields: {
	    	codeSetId: { type: "number"},
	    	parentCodeSetId : { field:"parentCodeSetId", nullable:true },
	    	objectType : { type: "number"},
	    	objectId : { type: "number"},
	    	description:  { type: "string" },
	    	name : { type: "string" },	        
	    	code : { type: "string" },	        
	    	modifiedDate: { type: "date"},
	        creationDate: { type: "date" },
	    	enabled : {type: "boolean" }
	    },    
	    copy : function ( target ){
	    	target.set("codeSetId", this.get("codeSetId"));
	    	target.set("parentCodeSetId", this.get("parentCodeSetId"));
	    	target.set("objectType", this.get("objectType"));
	    	target.set("objectId", this.get("objectId"));
	    	target.set("name", this.get("name"));
	    	target.set("description", this.get("description"));
	    	target.set("code", this.get("code"));
	    	target.set("modifiedDate", this.get("modifiedDate"));
	    	target.set("creationDate", this.get("creationDate"));
	    	target.set("enabled", this.get("enabled"));
	    	
	    }    
	});
	
	extend( common.ui.data, {
		competency:{
			Job : Job,
			CodeSet : CodeSet,
			Competency : Competency,
			EssentialElement : EssentialElement
		}  
	} );
	
})(jQuery);
