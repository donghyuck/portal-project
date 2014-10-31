/**
 * COMMON UI MODELS
 * dependency : jquery
 */
;(function($, undefined) {
	
	common.ui.data.Image = kendo.data.Model.define( {
		    id: "imageId", // the identifier of the model
		    fields: {
		    	imageId: { type: "number", editable: false, defaultValue: 0  },   
		    	objectType: { type: "number", editable: true, defaultValue:0  },    	
		    	objectId: { type: "number", editable: true, defaultValue:0  },    	
		    	name: { type: "string", editable: true , validation: { required: true }},
		        contentType: { type: "string", editable: true },
		        size: { type: "number", defaultValue : 0,  editable: true },
		        shared : { type: "boolean", defaultValue : false,  editable: true },
		        modifiedDate: { type: "date"},
		        creationDate: { type: "date" },
		        index : {type: "number", defaultValue : 0 }
		    },
			formattedSize : function(){
				return kendo.toString(this.get("size"), "##,###");
			},
			formattedCreationDate : function(){
		    	return kendo.toString(this.get("creationDate"), "g");
		    },
		    formattedModifiedDate : function(){
		    	return kendo.toString(this.get("modifiedDate"), "g");
		    },
		    copy : function ( target ){
		    	target.imageId = this.get("imageId");
		    	target.set("objectType" , this.get("objectType"));
		    	target.set("objectId" ,this.get("objectId"));
		    	target.set("name", this.get("name"));
		    	target.set("contentType", this.get("contentType"));
		    	target.set("size", this.get("size"));
		    	target.set("shared", this.get("shared"));
		    	if( typeof this.get("properties") === 'object' )
		    		target.set("properties", this.get("properties") );	    	
		    	target.set("creationDate", this.get("creationDate"));
		    	target.set("modifiedDate", this.get("modifiedDate"));
		    	target.set("index", this.get("index"));
		    }
		});

	common.ui.data.Attachment = kendo.data.Model.define( {
		    id: "attachmentId", // the identifier of the model
		    fields: {
		    	attachmentId: { type: "number", editable: false, defaultValue: -1  },   
		    	objectType: { type: "number", editable: false, defaultValue: -1  },    	
		    	objectId: { type: "number", editable: false, defaultValue: -1  },    	
		    	name: { type: "string", editable: true , validation: { required: true }},
		        contentType: { type: "string", editable: false },
		        downloadCount: { type: "number", editable: false },
		        modifiedDate: { type: "date"},
		        creationDate: { type: "date" }        
		    }
		});
		
	common.ui.data.Company = kendo.data.Model.define( {
		    id: "companyId", // the identifier of the model
		    fields: {
		    	companyId: { type: "number", editable: false, defaultValue: -1  },    	
		        name: { type: "string", editable: true , validation: { required: true }},
		        displayName: { type: "string", editable: true },
		        domainName: { type: "string", editable: true },
		        description: { type: "string", editable: true },
		        modifiedDate: { type: "date"},
		        creationDate: { type: "date" },
		        memberCount: { type: "number", editable: true, defaultValue: 0  },
		        adminCount: { type: "number", editable: true, defaultValue: 0  }
		    },
		    copy : function ( target ){
		    	target.companyId = this.get("companyId");
		    	target.set("name", this.get("name"));
		    	target.set("displayName", this.get("displayName"));
		    	target.set("domainName", this.get("domainName"));
		    	target.set("description", this.get("description"));
		    	target.set("modifiedDate", this.get("modifiedDate"));
		    	target.set("creationDate", this.get("creationDate"));
		    	target.set("memberCount", this.get("memberCount"));
		    	target.set("adminCount", this.get("adminCount"));		
		    	if( typeof this.get("properties") === 'object' )
		    		target.set("properties", this.get("properties"));
		    }    
		});


	common.ui.data.User = kendo.data.Model.define( {
		    id: "userId", // the identifier of the model
		    fields: {
		    	companyId: {  type: "number", defaultValue: 0 },
		    	company: common.ui.data.Company,
		    	userId: { type: "number", editable: true, defaultValue: 0  },
		        username: { type: "string", editable: true, defaultValue: "anonymous" },
		        name: { type: "string", editable: true },
		        email: { type: "string" , editable: true },
		        password: { type: "string" , editable: true },
		        creationDate: { type: "date" },
		        modifiedDate: { type: "date" },
		        lastLoggedIn: { type: "date" },
		        lastProfileUpdate : { type: "date" },                                    
		        enabled : {type: "boolean" },
		        nameVisible : {type: "boolean" },	        
		        emailVisible: {type: "boolean" },
		        formattedLastLoggedIn : { type: "string" },
		        formattedLastProfileUpdate : { type: "string" },
		        isSystem: { type:"boolean", defaultVlaue: false },
		        anonymous : { type:"boolean", defaultVlaue: true },
		        roles: {}
		    },
		    photoUrl : function (){
		    	if( this.get("anonymous") )
		    		return "/images/common/anonymous.png";		    	
		    	return '/download/profile/' +   this.get("username") + "?width=150&height=150";	    	
		    },    
		    hasRole : function ( role ) {
		    	if( typeof( this.roles ) != "undefined" && $.inArray( role, this.roles ) >= 0 )
					return true
				else 
					return false;    	
		    },
		    copy : function ( target ){
		    	alert( kendoui.stringify( target ) );
		    	target.userId = this.get("userId");
		    	target.set("username", this.get("username"));
		    	target.set("name", this.get("name"));
		    	target.set("email", this.get("email"));
		    	target.set("creationDate", this.get("creationDate"));
		    	target.set("lastLoggedIn", this.get("lastLoggedIn"));
		    	target.set("lastProfileUpdate", this.get("lastProfileUpdate"));
		    	target.set("enabled", this.get("enabled"));
		    	target.set("nameVisible", this.get("nameVisible"));
		    	target.set("emailVisible", this.get("emailVisible"));
		    	target.set("anonymous", this.get("anonymous"));
		    	target.set("company", this.get("company"));		
		    	target.set("isSystem", this.get("isSystem"));
		    	if( typeof this.get("roles") === 'object' )
		    		target.set("roles", this.get("roles") );	
		    	if( typeof this.get("properties") === 'object' )
		    		target.set("properties", this.get("properties"));	    	
		    }
		});

	common.ui.data.Group = kendo.data.Model.define( {
		    id: "groupId", // the identifier of the model
		    fields: {
		    	companyId: { type: "number", defaultValue: 1 },
		    	company: common.ui.data.Company,
		        groupId: { type: "number", editable: false, defaultValue: -1  },
		        name: { type: "string", editable: true, validation: { required: true }},
		        description: { type: "string", editable: true },
		        modifiedDate: { type: "date"},
		        creationDate: { type: "date" },
		        memberCount: { type: "number", editable: true, defaultValue: 0  },
		        adminCount: { type: "number", editable: true, defaultValue: 0  }       
		    }
		});

	common.ui.data.Property = kendo.data.Model.define( {
		    id: "name", // the identifier of the model
		    fields: {
		    	name: { type: "string",  editable: true },
		    	value:  { type: "string", editable: true }     
		    }
		});

	common.ui.data.Role = kendo.data.Model.define( {
		    id: "roleId", // the identifier of the model
		    fields: {
		    	roleId: { type: "number", editable: false, defaultValue: -1  },
		        name: { type: "string", editable: true, validation: { required: true }},
		        description: { type: "string", editable: true },
		        modifiedDate: { type: "date"},
		        creationDate: { type: "date" }
		    }
		})		

	common.ui.data.Template = kendo.data.Model.define( {
	    id: "templateId", // the identifier of the model
	    fields: {
	    	templateId: { type: "number", editable: false, defaultValue: -1  },    	
	    	objectType: { type: "number", editable: false, defaultValue: -1  },    	
	    	objectId: { type: "number", editable: false, defaultValue: -1  },    	
	    	title: { type: "string", editable: true , validation: { required: true }},
	    	templateType: { type: "string", editable: true },
	    	location : { type: "string", editable: true },
	    	body: { type: "string", editable: true },
	    	modifiedDate: { type: "date"},
	    	creationDate: { type: "date" } 
	    }
	});

	common.ui.data.DatabaseInfo = kendo.data.Model.define( {
	    fields: {
	    	databaseName: { type: "string",  editable: false },
	    	databaseVersion:  { type: "string", editable: false },
	    	driverName : { type: "string", editable: false},
	    	driverVersion: {type: "string", editable: false},
	    	isolationLevel: {type: "string", editable: false}
	    }
	});

	common.ui.data.Menu = kendo.data.Model.define( {
		  	id: "menuId", // the identifier of the model
		    fields: {
		    	menuId: { type: "number", editable: false, defaultValue: -1  }, 
		    	name: { type: "string", editable: true , defaultValue : ""  },
		        title: { type: "string", editable: true , defaultValue : "" },
		        enabled : {type: "boolean", defaultValue : true},
		        location: { type: "string", editable: true ,defaultValue : ""  },
		        properties :{ type: "object", editable: true ,defaultValue : {}  },
		        menuData : { type: "string", editable: true, defaultValue : "" },
		        modifiedDate: { type: "date"},
		        creationDate: { type: "date" }
		    },
			copy : function ( target ){
				target.menuId = this.get("menuId");
				target.set("name", this.get("name"));
				target.set("title", this.get("title"));
				target.set("enabled", this.get("enabled"));
				target.set("location", this.get("location"));
				target.set("properties", this.get("properties"));
				target.set("menuData", this.get("menuData"));
				target.set("modifiedDate", this.get("modifiedDate"));
				target.set("creationDate", this.get("creationDate"));
			}
	});
	

	common.ui.data.Logo =  kendo.data.Model.define({
		id : "logoId",
		fields: { 
			objectType: { type: "number", editable: false, defaultValue: 0 },
			objectId : { type: "number", editable: false, defaultValue: 0},
			primary: { type: "boolean", editable: false, defaultValue: false },
			filename : { type: "string", editable: true},
			imageSize : { type: "number", editable: true, defaultValue: 0},
			imageContentType : { type: "string", editable: true},
			modifiedDate: { type: "date"},
			creationDate: { type: "date" }
		},
		formattedImageSize : function(){
			return kendo.toString(this.get("imageSize"), "##,###");
		},
		formattedCreationDate : function(){
	    	return kendo.toString(this.get("creationDate"), "g");
	    },
	    formattedModifiedDate : function(){
	    	return kendo.toString(this.get("modifiedDate"), "g");
	    }
	});
	
	common.ui.data.WebSite =  kendo.data.Model.define({
		id : "webSiteId",
		fields: { 
			webSiteId: { type: "number", editable: false , defaultValue: 0},
			name : { type: "string", editable: true},
			description : { type: "string", editable: true},
			displayName : { type: "string", editable: true},
			url : { type: "string", editable: true},
			enabled: { type: "boolean", editable: true , defaultValue: false},
			allowAnonymousAccess: { type: "boolean", editable: true, defaultValue: false },
	        modifiedDate: { type: "date", editable: false },
	        creationDate: { type: "date", editable: false } 			
		},
	    copy: function ( target ){
	    	target.webSiteId = this.get("webSiteId");
	    	target.set("name",this.get("name") );
	    	target.set("description",this.get("description") );
	    	target.set("displayName", this.get("displayName"));
	    	target.set("url",this.get("url") );
	    	target.set("enabled", this.get("enabled"));
	    	target.set("allowAnonymousAccess", this.get("allowAnonymousAccess"));
	    	target.modifiedDate = this.get("modifiedDate");
	    	target.creationDate = this.get("creationDate") ;
	    	if( typeof this.get("menu") === 'object' )
	    		target.set("menu", this.get("menu") );    		    	
	    	if( typeof this.get("user") === 'object' )
	    		target.set("user", this.get("user") );    	
	    	if( typeof this.get("company") === 'object' )
	    		target.set("company", this.get("company") );    	
	    	if( typeof this.get("properties") === 'object' )
	    		target.set("properties", this.get("properties") );
	    }
	});		
	
	common.ui.data.CacheStats =  kendo.data.Model.define({
		id : "cacheName",
		fields: { 
			cacheName : { type: "string", editable: true},
			statisticsAccuracy : { type: "number", editable: false, defaultValue: 0 },
			cacheHits : { type: "number", editable: false, defaultValue: 0 },
			onDiskHits : { type: "number", editable: false, defaultValue: 0 },
			offHeapHits : { type: "number", editable: false, defaultValue: 0 },
			inMemoryHits : { type: "number", editable: false, defaultValue: 0 },
			misses : { type: "number", editable: false, defaultValue: 0 },
			onDiskMisses : { type: "number", editable: false, defaultValue: 0 },
			offHeapMisses : { type: "number", editable: false, defaultValue: 0 },
			inMemoryMisses : { type: "number", editable: false, defaultValue: 0 },
			size : { type: "number", editable: false, defaultValue: 0 },
			memoryStoreSize : { type: "number", editable: false, defaultValue: 0 },
			offHeapStoreSize : { type: "number", editable: false, defaultValue: 0 },
			diskStoreSize : { type: "number", editable: false, defaultValue: 0 },
			averageGetTime : { type: "number", editable: false, defaultValue: 0 },
			evictionCount : { type: "number", editable: false, defaultValue: 0 },
			searchesPerSecond : { type: "number", editable: false, defaultValue: 0 },
			averageSearchTime : { type: "number", editable: false, defaultValue: 0 },
			writerQueueLength : { type: "number", editable: false, defaultValue: 0 }			
		}
	});	
		
	var ajax = common.ui.ajax,
	extend = $.extend;
	function user (options){	
		options = options || {};
		ajax( options.url || '/accounts/get-user.do?output=json', {
			success : function(response){
				var user = new common.ui.data.User ();			
				if( response.error ){ 		
					if( typeof options.fail === 'function'  )
						options.fail(response) ;
				} else {				
					user = new common.ui.data.User (response.currentUser);	
				}
				if( typeof options.success === 'function'  )
					options.success (user);
			} 
		});		
	}
	
	extend( common.ui.data, {
		user : user
	} )
})(jQuery);