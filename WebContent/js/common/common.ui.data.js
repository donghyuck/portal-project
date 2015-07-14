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
		        imageUrl: { type: "string", editable: true },
		        imageThumbnailUrl: { type: "string", editable: true },
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
		    	target.set("imageUrl", imageUrl( target ));
		    	target.set("imageThumbnailUrl", imageUrl( target, 150, 150 ));
		    }
		});


	function imageUrl ( image , width , height ){	
		if( image.imageId > 0 ){
			var _photoUrl = "/download/image/" + image.imageId + "/" + image.name ;	
			if( typeof width === "number" && typeof height === "number" ){
				_photoUrl = _photoUrl + "?width=" + width + "&height=" + height ;
			}
			return _photoUrl ;
		}
		return "/images/common/no-image2.jpg";
	}

	function attachmentImageUrl ( attachment , thumbnail ){	
		if( attachment.attachmentId > 0 && ( attachment.isPdf() || attachment.isImage() )){
			var _photoUrl = "/download/file/" + attachment.attachmentId + "/" + attachment.name ;	
			if( thumbnail ){
				_photoUrl = _photoUrl + "?thumbnail=true" ;
			}
			return _photoUrl ;
		}
		return "/images/common/no-image2.jpg";
	}
	
	common.ui.data.Attachment = kendo.data.Model.define( {
		    id: "attachmentId", // the identifier of the model
		    fields: {
		    	attachmentId: { type: "number", editable: false, defaultValue: 0  },   
		    	objectType: { type: "number", editable: true, defaultValue: 0  },    	
		    	objectId: { type: "number", editable: true, defaultValue: 0  },    	
		    	name: { type: "string", editable: true , validation: { required: true }},
		        contentType: { type: "string", editable: true },
		        size: { type: "number", defaultValue : 0,  editable: true },
		        downloadCount: { type: "number", editable: true },
		        imageUrl: { type: "string", editable: true },
		        thumbnailImageUrl: { type: "string", editable: true },
		        modifiedDate: { type: "date"},
		        creationDate: { type: "date" }        
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
		    isPdf: function(){		    	
		    	if(this.get("contentType") === "application/pdf" )	
		    		return true;
		    	else 
		    		return false;
		    },
		    isImage : function(){		    	
		    	if(this.get("contentType").match("^image") )	
		    		return true;
		    	else 
		    		return false;		    	
		    },
		    copy : function ( target ){
		    	target.attachmentId = this.get("attachmentId");
		    	target.set("objectType" , this.get("objectType"));
		    	target.set("objectId" ,this.get("objectId"));
		    	target.set("name", this.get("name"));
		    	target.set("contentType", this.get("contentType"));
		    	target.set("size", this.get("size"));
		    	if( typeof this.get("properties") === 'object' )
		    		target.set("properties", this.get("properties") );	    	
		    	target.set("creationDate", this.get("creationDate"));
		    	target.set("modifiedDate", this.get("modifiedDate"));
		    	target.set("downloadCount", this.get("downloadCount"));
		    	target.set("imageUrl", attachmentImageUrl( target, false ));
		    	target.set("imageThumbnailUrl", attachmentImageUrl( target, true ));
		    }		    
		});
		
	common.ui.data.Company = kendo.data.Model.define( {
		    id: "companyId", // the identifier of the model
		    fields: {
		    	companyId: { type: "number", editable: false, defaultValue: 0  },    	
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
		    	target.companyId = this.get("companyId");
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
	
	var ANONYMOUS_PHOTO_URL = "/images/common/anonymous.png" ;	
	
	function photoUrl ( user , width , height ){		
		if( !common.ui.defined( user ))
		{
			return ANONYMOUS_PHOTO_URL 
		}
		if( typeof user.username === 'string'){
			var _photoUrl = "/download/profile/" + user.username;	
			if( typeof width === "number" && typeof height === "number" ){
				_photoUrl = _photoUrl + "?width=" + width + "&height=" + height ;
			}
			return _photoUrl ;
		}
		return ANONYMOUS_PHOTO_URL ;
	}
	
	common.ui.data.User = kendo.data.Model.define( {
		    id: "userId", // the identifier of the model
		    fields: {
		    	companyId: {  type: "number", defaultValue: 0 },
		    	userId: { type: "number", editable: false, defaultValue: 0  },
		        username: { type: "string", defaultValue: "anonymous" },
		        name: { type: "string" },
		        email: { type: "string" },
		        password: { type: "string" },
		        creationDate: { type: "date" },
		        modifiedDate: { type: "date" },
		        lastLoggedIn: { type: "date" },
		        lastProfileUpdate : { type: "date" },                                    
		        enabled : {type: "boolean" },
		        nameVisible : {type: "boolean" },	        
		        emailVisible: {type: "boolean" },
		        formattedLastLoggedIn : { type: "string" },
		        formattedLastProfileUpdate : { type: "string" },
		        isSystem: { type:"boolean", defaultValue: false },
		        anonymous : { type:"boolean",  defaultValue: true},
		        photoUrl : { type: "string" , defaultValue: "/images/common/anonymous.png" },
		        roles: {}
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
		    	target.set("photoUrl", photoUrl(this, 150, 150));	
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

	common.ui.data.Group = kendo.data.Model.define({
		id : "groupId", // the identifier of the model
		fields : {
			companyId : { type : "number", defaultValue : 0 },
			groupId : { type : "number", editable : false, defaultValue : 0
			},
			name : {
				type : "string",
				editable : true,
				validation : {
					required : true
				}
			},
			displayName : {
				type : "string"				
			},
			description : {
				type : "string",
				editable : true
			},
			modifiedDate : {
				type : "date"
			},
			creationDate : {
				type : "date"
			},
			memberCount : {
				type : "number",
				editable : true,
				defaultValue : 0
			},
			adminCount : {
				type : "number",
				editable : true,
				defaultValue : 0
			}
		},
		copy : function ( target ){
			target.groupId = this.get("groupId");
			target.set("companyId", this.get("companyId"));
			target.set("displayName", this.get("displayName"));
			target.set("name", this.get("name"));
			target.set("description", this.get("description"));
			target.set("creationDate", this.get("creationDate"));
			target.set("modifiedDate", this.get("modifiedDate"));	    	
			if( typeof this.get("company") === 'object' )
				target.set("company", this.get("company"));	
			if( typeof this.get("properties") === 'object' )
				target.set("properties", this.get("properties"));	 
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
		    	roleId: { type: "number", defaultValue: 0 , editable: false },
		        name: { type: "string", validation: { required: true }},
		        description: { type: "string"},
		        mask: { type: "number", defaultValue: 0  },
		        modifiedDate: { type: "date"},
		        creationDate: { type: "date" }
		    }
		});		

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
			formattedCreationDate : function(){
		    	return kendo.toString(this.get("creationDate"), "g");
		    },
		    formattedModifiedDate : function(){
		    	return kendo.toString(this.get("modifiedDate"), "g");
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
			modifiedDate: { type: "date" , editable: true },
			creationDate: { type: "date" , editable: true } 			
		},
		formattedCreationDate : function(){
	    	return kendo.toString(this.get("creationDate"), "g");
	    },
	    formattedModifiedDate : function(){
	    	return kendo.toString(this.get("modifiedDate"), "g");
	    },		
	    copy: function ( target ){
	    	target.webSiteId = this.get("webSiteId");
	    	target.set("name",this.get("name") );
	    	target.set("description",this.get("description") );
	    	target.set("displayName", this.get("displayName"));
	    	target.set("url",this.get("url") );
	    	target.set("enabled", this.get("enabled"));
	    	target.set("allowAnonymousAccess", this.get("allowAnonymousAccess"));
	    	target.set("modifiedDate", this.get("modifiedDate"));
	    	target.set("creationDate", this.get("creationDate")) ;
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
	
})(jQuery);

;(function($, undefined) {
		
	var ajax = common.ui.ajax,	
	DataSource = kendo.data.DataSource,
	handleAjaxError = common.ui.handleAjaxError,
	extend = $.extend;
	function user (options){	
		options = options || {};
		ajax( options.url || '/data/accounts/get.json?output=json', {
			success : function(response){
				var user = new common.ui.data.User ();			
				if( response.error ){ 		
					if( typeof options.fail === 'function'  )
						options.fail(response) ;
				} else {				
					user = new common.ui.data.User (response.user);	
				}
				if( typeof options.success === 'function'  )
					options.success (user);
			}, 
			done: function () {
				if( kendo.isFunction( options.always ))
					options.always( ) ;					
			}
		});
	}
	
	function uploadMyImageByUrl (options){
		options = options || {};
		ajax(
			options.url || '/data/images/upload_by_url.json?output=json', 
			{
				data: kendo.stringify(options.data),
				contentType : "application/json",
				success : function(response){
					if( response.error ){ 												
						if( kendo.isFunction (options.fail) )
							options.fail(response) ;
					} else {					
						if( kendo.isFunction(options.success) )
							options.success(response) ;					
					}
				},
			}
		).always( function () {
			if( kendo.isFunction( options.always ))
				options.always( ) ;					
		});	
	}

	
	function attachmentPorpertyDataSource(fileId){
		return DataSource.create({		
			transport: { 
				read: { url:"/data/files/properties/list.json?output=json", type:'GET' },
				create: { url:"/data/files/properties/update.json?output=json" + "&fileId=" + fileId, type:'POST' ,contentType : "application/json" },
				update: { url:"/data/files/properties/update.json?output=json" + "&fileId=" + fileId, type:'POST'  ,contentType : "application/json"},
				destroy: { url:"/data/files/properties/delete.json?output=json" +  "&fileId=" + fileId, type:'POST' ,contentType : "application/json"},
		 		parameterMap: function (options, operation){			
					if (operation !== "read" && options.models) {
						return kendo.stringify(options.models);
					} 
					return { fileId: fileId }
				}
			},						
			batch: true, 
			schema: {
				model: common.ui.data.Property
			},
			error:handleAjaxError
		});
	}
	
	function imagePorpertyDataSource(imageId){
		return DataSource.create({		
			transport: { 
				read: { url:"/data/images/properties/list.json?output=json", type:'GET' },
				create: { url:"/data/images/properties/update.json?output=json" + "&imageId=" + imageId, type:'POST' ,contentType : "application/json" },
				update: { url:"/data/images/properties/update.json?output=json" + "&imageId=" + imageId, type:'POST'  ,contentType : "application/json"},
				destroy: { url:"/data/images/properties/delete.json?output=json" +  "&imageId=" + imageId, type:'POST' ,contentType : "application/json"},
		 		parameterMap: function (options, operation){			
					if (operation !== "read" && options.models) {
						return kendo.stringify(options.models);
					} 
					return { imageId: imageId }
				}
			},						
			batch: true, 
			schema: {
				model: common.ui.data.Property
			},
			error:handleAjaxError
		});
	}	
	
	
	var DEFAULT_PROPERTY_DATASOURCE_CFG = {
		transport: { 			
		},
		batch: true, 
		schema: {
			model: common.ui.data.Property
		},
		error : handleAjaxError
	};
	
	function createPorpertyDataSource (options){
		options = options || {};		
		var settings = extend(true, {}, DEFAULT_PROPERTY_DATASOURCE_CFG , options ); 
		return DataSource.create(settings);		
	}
		
	extend( common.ui.data, {
		user : user ,
		image : {
			uploadByUrl : uploadMyImageByUrl ,
			property : { datasource: imagePorpertyDataSource }
		},
		attachment : {
			property : { datasource: attachmentPorpertyDataSource }			
		},
		properties : {		
			datasource: createPorpertyDataSource
		}
	} );
	
})(jQuery);