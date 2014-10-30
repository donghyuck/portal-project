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
		    	companyId: {  type: "number", defaultValue: 1 },
		    	company: common.ui.data.Company,
		    	userId: { type: "number", editable: true, defaultValue: -1  },
		        username: { type: "string", editable: true },
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
		    	return '/download/profile/' +  this.get("username") + "?width=150&height=150";	    	
		    },    
		    hasRole : function ( role ) {
		    	if( typeof( this.roles ) != "undefined" && $.inArray( role, this.roles ) >= 0 )
					return true
				else 
					return false;    	
		    },
		    copy : function ( target ){
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