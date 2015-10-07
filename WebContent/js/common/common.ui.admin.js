/**
 * COMMON ADMIN UI DEFINE
 */

	common.ui.data.DatabaseInfo = kendo.data.Model.define( {
	    fields: {
	    	databaseName: { type: "string",  editable: false },
	    	databaseVersion:  { type: "string", editable: false },
	    	driverName : { type: "string", editable: false},
	    	driverVersion: {type: "string", editable: false},
	    	isolationLevel: {type: "string", editable: false}
	    }
	});
	
	common.ui.data.WebPage =  kendo.data.Model.define({
		id : "webPageId",
		fields: { 
			webPageId: { type: "number", defaultValue: 0 },	
			webSiteId: { type: "number", defaultValue: 0 },	
			name: { type: "string", defaultValue: "" },
			displayName: { type: "string", defaultValue: "." },
			contentType: { type: "string", defaultValue: "text/html;charset=UTF-8" },
			description: { type: "string" },
			template: { type: "string" },
			locale: { type: "string" },
			enabled : { type: "boolean", defaultValue: false },
			creationDate: { type: "date"},
			modifiedDate: { type: "date"}
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
	
	common.ui.data.FileInfo =  kendo.data.Model.define({
		id : "path",
		hasChildren: "directory",
		fields: { 
			absolutePath: { type: "string", defaultValue: "" },
			name: { type: "string", defaultValue: "." },
			path: { type: "string", defaultValue: "." },
			size: { type: "number", defaultValue: 0 },
			directory: { type: "boolean", defaultValue: false },
			customized : { type: "boolean", defaultValue: false },
	        lastModifiedDate: { type: "date"}
		},
	    formattedLastModifiedDate : function(){
	    	return kendo.toString(this.get("lastModifiedDate"), "g");
	    },		
	    formattedSize : function(){
	    	return kendo.toString(this.get("size"), "##,#");
	    },
	    copy: function ( target ){
	    	target.path = this.get("path");
	    	target.set("customized",this.get("customized") );
	    	target.set("absolutePath",this.get("absolutePath") );
	    	target.set("name", this.get("name"));
	    	target.set("size",this.get("size") );
	    	target.set("directory", this.get("directory"));
	    	target.set("lastModifiedDate",this.get("lastModifiedDate") );
	    }
	});
	
(function($, undefined) {
	var common = window.common = window.common || {};
	common.ui =  common.ui || {},
	common.ui.admin = common.ui.admin || {};
	
	var kendo = window.kendo,
	ajax = common.ui.ajax,
	Widget = kendo.ui.Widget,
	Class = kendo.Class,
	extend = $.extend,
	stringify = kendo.stringify,
	isFunction = kendo.isFunction,
	UNDEFINED = 'undefined',
	POST = 'POST',
	CLICK = 'click',
	CHANGE = 'change',
	AUTHENTICATE = 'authenticate',
	COMPLETE = 'complete',
	AUTHENTICATE_URL =  "/data/accounts/get.json?output=json";
	ROLE_ADMIN = "ROLE_ADMIN", 
	ROLE_SYSTEM = "ROLE_SYSTEM", 	
	OBJECT_TYPE = 30 ,
	ACCOUNT_RENDER_ID = "account-panel",
	JSON = 'json';
	
	
	function culture ( locale ){
		if( !common.ui.defined( locale ) )
			locale = "ko-KR";
		kendo.culture(locale);				
	}	
	
	
	var Setup = Widget.extend({		
		init : function(element, options) {
			var that = this;
			that.data = new kendo.data.ObservableObject();
			Widget.fn.init.call(that, element, options);
			options = that.options;
			that.complete();
			kendo.notify(that);
		},
		options : {
			name : "Setup",
		},
		events : [ CLICK, CHANGE, AUTHENTICATE, COMPLETE ],
		complete : function(){
			var that = this,
			options = that.options, 			
			cfg = { features : {}, jobs : [] };			
			cfg.features = options.features || {} ;
			cfg.jobs =  options.jobs || [] ;			
			common.ui.setup(cfg);					
			that.authenticate();
			//that.companySelector();
			culture();			
			$('.menu-content-profile .close').click(function () {
				var $p = $(this).parents('.menu-content');
				$p.addClass('fadeOut');
				setTimeout(function () {
					$p.css({ height: $p.outerHeight(), overflow: 'hidden' }).animate({'padding-top': 0, height: $('#main-navbar').outerHeight()}, 500, function () {
						$p.remove();
					});
				}, 300);
				return false;
			});			
			that._pixelAdmin = window.PixelAdmin;
			that._pixelAdmin.start([]);	
		},
		authenticate : function() {
			var that = this;
			ajax( that.options.authenticateUrl || AUTHENTICATE_URL, {
				success : function(response){
					var token = new common.ui.data.User($.extend( response.user, { roles : response.roles }));
					token.set('isSystem', false);
					if (token.hasRole(ROLE_SYSTEM) || token.hasRole(ROLE_ADMIN))
						token.set('isSystem', true);			
					
					if( that.token ){
						token.copy(that.token);	
					}else{
						that.token = token ;
					}
					that.trigger(AUTHENTICATE,{ token : that.token });
				}
			});		
		},
		companySelector : function(renderTo){	
			var that = this, renderTo = renderTo || $("#targetCompany");		
			if(!renderTo.data("kendoDropDownList")){
				renderTo.kendoDropDownList({
					dataTextField: 'displayName',	
					dataValueField: 'companyId',
					dataSource: {
						serverFiltering: false,
						transport: {
							read: {
								dataType: JSON,
								url: '/secure/data/mgmt/company/list.json?output=json',
								type: POST
							}
						},
						schema: { 
							data: "items",
							model : common.ui.data.Company
						}
					},
					change : function (e){
						var item = this.dataSource.get(this.value());					
						that.trigger(CHANGE, { "fieldName" : "company", data:item } );
					},
					dataBound : function(e){
						var item = this.dataSource.get(this.value());			
						that.trigger(CHANGE, { "fieldName" : "company", data:item } );
					}
				});		
			}
			return renderTo.data("kendoDropDownList");
		}	
	});
	
	function setup (options){	
		options = options || {};
		if(!$("#main-wrapper").data("kendoSetup") ){
			new Setup($("#main-wrapper"), options);	
		}
		return $("#main-wrapper").data("kendoSetup");
	}	
	
	function bytesToSize(bytes, precision) {
		var kilobyte = 1024;
		var megabyte = kilobyte * 1024;
		var gigabyte = megabyte * 1024;
		var terabyte = gigabyte * 1024;
		if ((bytes >= 0) && (bytes < kilobyte)) {
			return bytes + ' B';
		} else if ((bytes >= kilobyte) && (bytes < megabyte)) {
			return (bytes / kilobyte).toFixed(precision) + ' KB';
		} else if ((bytes >= megabyte) && (bytes < gigabyte)) {
			return (bytes / megabyte).toFixed(precision) + ' MB';
		} else if ((bytes >= gigabyte) && (bytes < terabyte)) {
			return (bytes / gigabyte).toFixed(precision) + ' GB';
		} else if (bytes >= terabyte) {
			return (bytes / terabyte).toFixed(precision) + ' TB';
		} else {
			return bytes + ' B';
		}
	}	

	function permissions ( options ){
		var data = {
			objectType : options.objectType || 0,
			objectId : options.objectId || 0,
			perms : options.perms || []	
		};
		ajax(options.url || '/secure/data/mgmt/permissions/list.json?output=json', 
			{
				data: stringify(data),
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
			}).always( function () {
				if( kendo.isFunction( options.always ))
					options.always( ) ;					
		});
	}
	
	var PERMISSION_GROUP_SET = {
		SYSTEM:["USER_ADMINISTRATION", "GROUP_ADMINISTRATION", "SYSTEM_ADMINISTRATION", "HOSTED_ADMINISTRATION"], 			
		WEB_ADMIN:["WEBSITE_ADMIN", "MODERATOR"],		
		WEB_CONTENT:["READ_DOCUMENT", "CREATE_DOCUMENT", "CREATE_COMMENT", "CREATE_IMAGE", "CREATE_FILE", "CREATE_POLL", "VOTE_IN_POLL", "CREATE_ANNOUNCEMENT" ]
	}
	
	function getPermissionGroup(name){
		return PERMISSION_GROUP_SET[name];
	}
	
	extend(common.ui.admin, {
		setup : setup,
		bytesToSize : bytesToSize,
		permissions : {
			list : permissions,
			group : getPermissionGroup
		}
	} );
		
})(jQuery);

common.ui.admin.switcherEnabled = function(name) {
	return $('input[role="switcher"][name="' + name + '"]').is(":checked") ;	
}


	