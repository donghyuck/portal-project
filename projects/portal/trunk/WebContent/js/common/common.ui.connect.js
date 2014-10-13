/**
 * COMMUNITY UI 
 * dependency : common.ui.core, common.ui.kendo
 */
;(function($, undefined) {
	var ui = common.ui, 	
	handleAjaxError = ui.handleAjaxError,
	extend = $.extend,	
	Widget = kendo.ui.Widget, 
	DataSource = kendo.data.DataSource,
	proxy = $.proxy, 
	
	isFunction = kendo.isFunction,
	OBJECT = 'object',
	STRING = 'string',
	GET = 'GET',
	OPEN = 'open', 
	UNDEFINED = 'undefined',
	CHANGE = "change";
	ui.connect = ui.connect || {};
	ui.connect.SocialConnect= kendo.data.Model.define({
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

	ui.connect.colSize = function(data){
		if( data.length == 1 ){
			return 12;
		}else if ( data.length == 2 ){
			return 6;			
		}else if ( data.length == 3 ){
			return 4 ;			
		}else{
			return 3 ;				
		} 
	}
	
	ui.connect.profile = function( options ){
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
	
	
	ui.connect.listview = function (renderTo, connect, options ){
		if(!renderTo.data("kendoListView")){
			var _data = {
				parameterMap : function(options, operation) {
					return {};
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
							type : GET,
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
				template:_data.template
			});	
			if( isFunction(options.change)){
				listview.bind("change", options.change);
			}
		}
		return renderTo.data("kendoListView");
	} 
		
	ui.connect.newConnectListDataSource = function(handlers){
		var handlers = handlers || {};
		var dataSource =  DataSource.create({
			transport: {
				read: {
					type :GET,
					dataType : JSON, 
					url : '/connect/list.json'
				} 
			},
			pageSize: 10,
			error:handleAjaxError,				
			schema: {
				data : "connections",
				model : ui.connect.SocialConnect
			}				
		});
		if( isFunction(handlers.dataBound) ){
			dataSource.bind("dataBound", handlers.dataBound );
		}
		if( isFunction(handlers.change) ){
			dataSource.bind(CHANGE, handlers.change );
		}
		return dataSource;
	}
	
})(jQuery);