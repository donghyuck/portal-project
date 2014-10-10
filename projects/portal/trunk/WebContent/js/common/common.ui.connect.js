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
			error:handleKendoAjaxError,				
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
	
	ui.connect.ExtMediaStreamView = Widget.extend({
		init : function(element, options) {
			var that = this;
			Widget.fn.init.call(that, element, options);
			options = that.options;
			that._dataSource();
		},
		options : {
			name : "ExtMediaStreamView",
			autoBind : true
		},
		id : function() {
			var that = this;
			var options = that.options;
			if (typeof options.id === UNDEFINED)
				return 0;
			else
				return options.id;
		},
		events : [ CHANGE ],
		_dataSource : function() {
			var that = this;
			var options = that.options;
			if (typeof that.options.dataSource === OBJECT ) {
				that.dataSource = kendo.data.DataSource.create(that.options.dataSource);
			} else {
				if (typeof options.media === STRING) {
					var _data = {
						parameterMap : function(options, operation) {
							return {};
						}
					};
					switch (options.media) {
					case MEDIA_FACEBOOK:
						_data.url = "/community/get-facebook-homefeed.do?output=json";
						_data.data = "homeFeed";
						_data.template = kendo.template($("#facebook-homefeed-template").html());
						break;
					case MEDIA_TWITTER:
						_data.url = "/community/get-twitter-hometimeline.do?output=json";
						_data.data = "homeTimeline";
						_data.template = kendo.template($("#twitter-timeline-template").html());
						break;
					case MEDIA_TUMBLR:
						_data.url = "/community/get-tumblr-dashboard.do?output=json";
						_data.data = "dashboardPosts";
						_data.template = kendo.template($("#tumblr-dashboard-template").html());
						break;
					}
					if (typeof options.template === UNDEFINED)
						options.template = _data.template;
					that.dataSource = DataSource.create({
						type : JSON,
						transport : {
							read : {
								type : POST,
								url : _data.url
							},
							parameterMap : _data.parameterMap
						},
						error : handleKendoAjaxError,
						schema : {
							data : _data.data
						},
						requestStart : function() {
							kendo.ui.progress(that.element, true);
						},
						requestEnd : function() {
							kendo.ui.progress(that.element, false);
						}
					});
				}
			}
			that.dataSource.bind(CHANGE, function() {
				that.refresh();
			});
			if (that.options.autoBind) {
				that.dataSource.fetch();
			}
		},
		refresh : function() {
			var that = this;
			var options = that.options;
			var view = that.dataSource.view();
			that.element.html(kendo.render(options.template, view));					
			that.trigger(CHANGE);					
		},
		destroy : function() {
			var that = this;
			Widget.fn.destroy.call(that);
			$(that.element).remove();
		}
	});

	$.fn.extend({
		extMediaStreamView : function(options) {
			return new common.ui.connect.ExtMediaStreamView(this, options);
		}
	});	
		
})(jQuery);