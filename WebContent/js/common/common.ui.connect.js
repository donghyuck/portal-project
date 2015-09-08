/**
 * COMMUNITY UI CONNECT
 * dependency : common.ui.core, common.ui.kendo
 */
;(function($, undefined) {
		
	common.ui.connect.SocialConnect= kendo.data.Model.define({
		id : "socialConnectId",
		fields: { 
			socialConnectId: { type: "number", editable: false, defaultValue: 0 },
			objectType: { type: "number", editable: true, defaultValue: 0 },
			objectId: { type: "number", editable: true, defaultValue: 0 },						
			providerId: { type: "string", editable: true },
			providerUserId: { type: "string", editable: true },
			displayName: { type: "string", editable: true },
			imageUrl: { type: "string", editable: true },
			profileUrl: { type: "string", editable: true },
	        modifiedDate: { type: "date"},
	        creationDate: { type: "date" } 			
		},
		formattedCreationDate : function(){
	    	return kendo.toString(this.get("creationDate"), "g");
	    },
	    formattedModifiedDate : function(){
	    	return kendo.toString(this.get("modifiedDate"), "g");
	    },
	    copy: function ( target ){
	    	target.socialConnectId = this.get("socialConnectId");
	    	target.set("objectType",this.get("objectType") );
	    	target.set("objectId", this.get("objectId"));
	    	target.set("providerId",this.get("providerId") );
	    	target.set("providerUserId", this.get("providerUserId"));
	    	target.set("displayName", this.get("displayName"));
	    	target.set("imageUrl", this.get("imageUrl"));
	    	target.set("profileUrl", this.get("profileUrl"));
	    	target.set("modifiedDate",this.get("modifiedDate") );
	    	target.set("creationDate", this.get("creationDate") );
	    	if( typeof this.get("properties") === 'object' )
	    		target.set("properties", this.get("properties") );
	    }
	});
})(jQuery);

;(function($, undefined) {
		var ui = common.ui, 	
		handleAjaxError = ui.handleAjaxError,
		defined = ui.defined,
		ajax = ui.ajax,
		extend = $.extend,	
		Widget = kendo.ui.Widget, 
		DataSource = kendo.data.DataSource,
		proxy = $.proxy, 	
		isFunction = kendo.isFunction,
		OBJECT = 'object',
		STRING = 'string',
		GET = 'GET',
		POST = 'POST',
		OPEN = 'open', 
		UNDEFINED = 'undefined',
		CHANGE = "change";
		
	function row (current, totalSize){
		if( current == 0 )
			return true;
		else if( totalSize >= 3 && ( current == 1 || current == 4 || current == 5 || current == 7) )
			return true ;		
		return false;
	}

	function columns (current, totalSize){
		if( totalSize == 1 )
			return 12;
		else if ( totalSize == 2)
			return 6;
		else if ( totalSize == 3 ){
			if( current == 0 ){
				return 12;
			}else{
				return 6;
			}
		}else if (totalSize > 3 && totalSize < 6){
			if( current == 0 ){
				return 12;
			}else if ( current > 0 && current < 4 ){
				return 4;				
			}else{
				return 12;
			}				
		}else if ( totalSize == 6 ){
			if( current == 0 ){
				return 12;
			}else if ( current > 0 && current < 4 ){
				return 4;				
			}else{
				return 6;
			}
		}else{
			if( current == 0 ){
				return 12;
			}else if ( current > 0 && current < 4 ){
				return 4;				
			}else if (current > 3 && current < 6 ){
				return 6;
			}else if ( current == 7 ){
				return 12;
			}else{
				return 4;
			}			
		}		
		return false;
	}
		
	function userProfile ( providerId, userId, callback, error ){
		var options = options || {};		
		switch (providerId){
			case "facebook":
				options.url = "/connect/facebook/user/lookup.json";
				break;			
		}		
		$.ajax({
			type : POST,
			url : options.url,
			data : { userId : userId },
			success : function(response){
				if( !defined(response.error) ){
					if( isFunction( callback ) ){	
						callback( response );
					}
				}				
			},
			error: handleAjaxError ,
			dataType : JSON
		});
	}
	
	function profile ( options ){	
		$.ajax({
			type : POST,
			url : options.url,
			data: options.data || {},
			success : function(response){
				if( typeof response.error === UNDEFINED ){ 		
					if( isFunction( options.success ) ){						
						options.success(response) ;
					}
				} else {									
					if( isFunction( options.fail ) ){
						options.fail(response) ;
					}
				}
			},
			beforeSend : function () {
				if( isFunction( options.beforeSend ) ){
					options.beforeSend() ;
				}
			},
			complete : function () {
				if( isFunction( options.complete ) ){
					options.complete() ;
				}
			},
			error:options.error || handleAjaxError ,
			dataType : JSON
		});	
	}
	
	
	function listview (renderTo, connect, options ){
		if(!renderTo.data("kendoListView")){			
			var _data = {
				parameterMap : function(options, operation) {
					return options;
				}
			};
			switch (connect.providerId){
			case "facebook":
				_data.url = "/connect/facebook/homefeed.json";
				_data.template = kendo.template($("#facebook-homefeed-template").html());
				break;
			case "twitter":
				_data.url = "/connect/twitter/home_timeline.json";
				_data.template = kendo.template($("#twitter-timeline-template").html());
				break;
			case "tumblr":
				_data.url = "/connect/tumblr/dashboard.json";
				_data.template = kendo.template($("#tumblr-dashboard-template").html());
				_data.data = "posts";
				break;
			}
			var listview = renderTo.kendoListView({
				dataSource: DataSource.create({
					type : JSON,
					transport : {
						read : {
							type : POST,
							url : _data.url || ""
						},
						parameterMap : _data.parameterMap
					},
					schema:{
						data : _data.data						
					},
					error : handleAjaxError,
					requestStart : function() {
						kendo.ui.progress(renderTo, true);
					},
					requestEnd : function() {
						kendo.ui.progress(renderTo, false);
					}
				}),
				autoBind: true,
				template:_data.template
			});	
		}
		return renderTo.data("kendoListView");
	} 
		
	function signin (options){		
		options = options || {};		
		if(!defined(options.success)){
			options.success = function(response){
				if( typeof response.error === UNDEFINED ){ 		
					if( isFunction( options.success ) ){						
						options.success(response) ;
					}
				} else {									
					if( isFunction( options.fail ) ){
						options.fail(response) ;
					}
				}
			}
		}
		ajax(
			options.url || "/connect/signin.json",	
			options
		);
		/*
		$.ajax({
			type : POST,
			url : options.url || "/connect/signin.json",
			data: options.data || {},
			success : function(response){
				if( typeof response.error === UNDEFINED ){ 		
					if( isFunction( options.success ) ){						
						options.success(response) ;
					}
				} else {									
					if( isFunction( options.fail ) ){
						options.fail(response) ;
					}
				}
			},
			complete : function () {
				if( isFunction( options.complete ) ){
					options.complete() ;
				}
			},
			error:options.error || handleAjaxError ,
			dataType : JSON
		});		
		*/		
	}
	
	function status( options ){
		options = options || {};		
		jQuery.ajax({
			type : POST,
			url : options.url || "/connect/list.json",
			data: options.data || {},
			success : function(response){
				if( typeof response.error === UNDEFINED ){ 		
					if( isFunction( options.success ) ){						
						options.success(response) ;
					}
				} else {									
					if( isFunction( options.fail ) ){
						options.fail(response) ;
					}
				}
			},
			error:options.error || handleAjaxError ,
			dataType : JSON
		});		
	}
	
	function newConnectListDataSource (options){		
		options = options || {};
		options.schema = {
			data : "connections",	
			model : common.ui.connect.SocialConnect
		};
		return common.ui.datasource('/connect/list.json', options);		
	}	
	
	function getAuthorizeUrl(provider){
		return "/connect/" + provider + "/authorize"
	}
	
	function getConnectedProfile(options){
		options = options || {};		
		if(!defined(options.success)){
			options.success = function(response){
				if( typeof response.error === UNDEFINED ){ 		
					if( isFunction( options.success ) ){						
						options.success(response) ;
					}
				} else {									
					if( isFunction( options.fail ) ){
						options.fail(response) ;
					}
				}
			}
		}
		ajax(
			options.url || "/connect/lookup.json",	
			options
		);	
	}
	
	$.extend(ui.connect , {
		row : common.ui.connect.row || row,
		columns : common.ui.connect.columns || columns,		
		listview : common.ui.connect.listview || listview,
		signin : common.ui.connect.signin || signin,
		status : common.ui.connect.status || status,
		connectedProfile : getConnectedProfile,
		authorizeUrl : common.ui.connect.authorizeUrl || getAuthorizeUrl,
		user : {
			lookup : common.ui.connect.userProfile || userProfile,
			profile : common.ui.connect.profile || profile,
		},
		list : {
			datasource : newConnectListDataSource
		}
	});
	
})(jQuery);