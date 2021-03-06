
;(function($, undefined) {
	var common = window.common = window.common || {};
	common.api =  common.api || {};
	var kendo = window.kendo,
	stringify = kendo.stringify,
	UNDEFINED = 'undefined',
	LOCALE = 'ko-KR',
	isFunction = kendo.isFunction;
	
	common.api.culture = function ( ){
		kendo.culture(culture);				
	}	
	
	common.api.culture = function ( culture ){
		if( typeof culture === UNDEFINED )
			culture = LOCALE;
		kendo.culture(culture);				
	}
	
	common.api.callback = function ( options){
		options = options || {};	
	    $.ajax({
			type : 'POST',
			url : options.url,
			data: options.data || {},
			success : function(response){
				if( response.error ){ 				
					if( isFunction (options.fail) )
						options.fail(response) ;
				} else {				
					if( isFunction (options.success) )
						options.success(response) ;					
				}
			},
			beforeSend : function( xhr ) {
				if( isFunction( options.requestStart ))
					options.requestStart( ) ;					
			},
			complete : function( xhr ) {
				if( isFunction( options.requestEnd ))
					options.requestEnd( ) ;						
			},
			complete : function( xhr ) {
				if( isFunction( options.requestEnd ))
					options.requestEnd( ) ;						
			},			
			error: options.error || common.api.handleKendoAjaxError,
			dataType : "json"
		}).always( function () {
			if( isFunction( options.always ))
				options.always( ) ;					
		});
	}
		
	common.api.getTargetCompany =  function (url, options){
		if (typeof url === "object") {
	        options = url;
	        url = undefined;
	    }
	    // Force options to be an object
	    options = options || {};		    
	    $.ajax({
			type : 'POST',
			url : options.url || '/secure/get-company.do?output=json' ,
			data: options.data || {},
			success : function(response){
				if( response.error ){ 												
					options.fail(response) ;
				} else {					
					var company = new Company (response.targetCompany);	
					options.success(company) ;					
				}
			},
			error:options.error || common.api.handleKendoAjaxError,
			dataType : "json"
		});	
	};				
	
	
	common.api.isValidUrl = function (url){
		  var urlregex = new RegExp("^(http|https|ftp)\://[a-zA-Z0-9\-\.]+\.[a-zA-Z]{2,3}(:[a-zA-Z0-9]*)?/?([a-zA-Z0-9\-\._\?\,\'/\\\+&amp;%\$#\=~])*$");
		  return urlregex.test(url);
		}
	
	common.api.isValidEmail = function (email){
		var expr = /^([\w-\.]+)@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.)|(([\w-]+\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})(\]?)$/;
        return expr.test(email);
	};
	
	common.api.getUser = function (options){	
		options = options || {};
		$.ajax({
			type : 'POST',
			url : options.url || '/accounts/get-user.do?output=json' ,
			success : function(response){
				var user = new User ();			
				if( response.error ){ 		
					if( typeof options.fail === 'function'  )
						options.fail(response) ;
				} else {				
					user = new User (response.currentUser);	
				}
				if( typeof options.success === 'function'  )
					options.success (user);
			},
			error:options.error || common.api.handleKendoAjaxError,
			dataType : "json"
		});			
	}
	
	common.api.getEngageSocailProfile = function ( options ){		
		options = options || {};
		$.ajax({
			type : 'POST',
			url : options.url || '/community/facebook-callback.do?output=json',
			data: { onetime : options.onetime },
			success : function(response){
				if( response.error ){ 												
					options.fail(response) ;
				} else {					
					options.success(response) ;					
				}
			},
			error:options.error || common.api.handleKendoAjaxError,
			dataType : "json"
		});	
	};
	
	common.api.property = function( properties, name, defaultValue ){		
		if( typeof properties[name] === UNDEFINED )
		{	
			return defaultValue;
		}
		else {
			if( typeof properties[name] === 'string' ){
				if(  properties[name] === 'true')
					return true;
				else
					return false;				
			}else{
				return properties[name];
			}			
		}
			
	}

	common.api.truncate = function(title, size){
		size = size || 50;
		return $.trim(title).substring(0, size).split(" ").slice(0, -1).join(" ") + "...";	
	}
		
	common.api.guid = function()
	{
		var result, i, j;
		result = '';
		for(j=0; j<32; j++)
		{
		if( j == 8 || j == 12|| j == 16|| j == 20)
		result = result + '-';
		i = Math.floor(Math.random()*16).toString(16).toUpperCase();
		result = result + i;
		}
		return result
	}
	
	/**
	 * handlePanelHeaderActions : Panel Header Action Utils
	 */
	common.api.handlePanelHeaderActions = function ( selector, options ){		
		options = options || {};		
		if( options.custom === UNDEFINED )
			 options.custom = false;		
		if ( typeof selector === 'string' )
			selector = $(selector);		
		if( options.custom ){
			var custom_panel_body = selector.find(".panel-body:first");			
			custom_panel_body.find("button.close").click(function(e){
				custom_panel_body.addClass("hide");			
			});			
			custom_panel_body.find("input[name='options-scrollable']").on("change", function () {
				var last_panel_body = selector.children('.panel-body:last');
				if(  this.value == 0 ){
					last_panel_body.css("max-height", "");
					last_panel_body.removeClass('scrollable');
				}else if (this.value == 1 ) {
					last_panel_body.css("max-height", "450px");
					last_panel_body.addClass('scrollable');
				}		
			});					
		}				
		selector.find('.panel-header-actions a.k-link').each(function( index ){
			var panel_header_action = $(this);						
			panel_header_action.click( function (e) {						
				
				if( panel_header_action.text() == "Minimize" ){        				
    				var panel_header_action_icon = panel_header_action.find('span');
					if( panel_header_action_icon.hasClass("k-i-minimize") ){
						panel_header_action_icon.removeClass("k-i-minimize");
						panel_header_action_icon.addClass("k-i-maximize");
						if( selector.hasClass('panel') ){
							selector.children('.panel-body:last, .panel-footer').addClass("hide");
						}else{
							selector.find('.panel:first').children('.panel-body, .panel-footer').addClass("hide");
						}					
					}else{
						panel_header_action_icon.removeClass("k-i-maximize");
						panel_header_action_icon.addClass("k-i-minimize");	
						if( selector.hasClass('panel') ){
							selector.children('.panel-body:last, .panel-footer').removeClass("hide");
						}else{
							selector.find('.panel:first').children('.panel-body, .panel-footer').removeClass("hide");
						}	
					}						
    			}else if ( panel_header_action.text() == "Close"){
    				if( isFunction(options.close) ){
    					options.close();
    				}else{
    					if( selector.hasClass('panel') )
    						selector.parent().remove();
    					else
    						selector.remove();
    				}
    			}else if ( panel_header_action.text() == "Refresh"){	    			
    				if( isFunction(options.refresh) ){
    					options.refresh();
    				}else{
    					
    				}
    			} else if ( panel_header_action.text() == "Custom"  &&  options.custom ){        				
    				var panel_body = selector.children(".panel-body:first");
    				if( panel_body.hasClass('hide') ){
    					panel_body.removeClass('hide');
    				}else{
    					panel_body.addClass('hide');
    				}
    			}
			} );
		});
	};
	
	common.api.handleNavbarActions = function ( selector, options ){
		options = options || {};		
		if( options.custom === UNDEFINED )
			 options.custom = false;			
		if ( typeof selector === 'string' )
			selector = $(selector);		
		if ( typeof options.handlers === UNDEFINED )
			options.handlers = [];		
		$.each(options.handlers, function(index, data){
			selector.find(data.selector).on(data.event, data.handler);
		});		
		selector.find('.navbar-nav  .btn-link, navbar-nav btn.navbar-btn').each(function( index ){
			var navbar_btn_link = $(this);
			if( isFunction( options.onClick ) ){
				navbar_btn_link.click( options.onClick );
			}
		});	
	}
	
	common.api.pager = function (item, current_index, total_index, current_page, total_page) {		
		if( current_index < 0 )
			current_index = 0;		
		item.index = current_index ;
		item.page = current_page;
		item.previous = ( current_index > 0 || current_page > 1 ) ;
		item.next = true ;			
		if( (total_index - current_index) == 0 && (total_page - current_page) == 0 )
			item.next = false;		
		return item;
	};
	
	common.api.uploadMyImageByUrl = function (options){
		options = options || {};
		$.ajax({
			type : 'POST',
			url : options.url || '/community/upload-my-image-by-url.do?output=json' ,
			data: { item: kendo.stringify(options.data)} ,
			success : function(response){
				if( response.error ){ 												
					if( isFunction (options.fail) )
						options.fail(response) ;
				} else {					
					if( isFunction(options.success) )
						options.success(response) ;					
				}
			},
			complete : function () {
				if( isFunction( options.always ))
					options.always( ) ;					
			},
			error:options.error || common.api.handleKendoAjaxError,
			dataType : "json"
		});
	}

	common.api.getImagelink = function (options){
		options = options || {};
		$.ajax({
			type : 'POST',
			url : options.url || '/community/get-image-link.do?output=json' ,
			data: { imageId : options.imageId },
			success : function(response){
				if( response.error ){ 												
					if( isFunction (options.fail) )
						options.fail(response) ;
				} else {					
					if( isFunction(options.success) )
						options.success(response) ;					
				}
			},
			error:options.error || common.api.handleKendoAjaxError,
			dataType : "json"
		});	
	}

	common.api.removeImageLink = function (options){
		options = options || {};
		$.ajax({
			type : 'POST',
			url : options.url || '/community/delete-image-link?output=json' ,
			data: { imageId : options.imageId },
			success : function(response){
				if( response.error ){ 												
					if( isFunction (options.fail) )
						options.fail(response) ;
				} else {					
					if( isFunction(options.success) )
						options.success(response) ;					
				}
			},
			error:options.error || common.api.handleKendoAjaxError,
			dataType : "json"
		});	
	}	
	
	common.api.bytesToSize = function (bytes, precision)
	{  
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

	
	common.api.handleKendoAjaxError = function (xhr) {
		var message = "";
		if (xhr.status == 0) {
			message = "오프라인 상태입니다.";
		} else if (xhr.status == 404 || xhr.errorThrown == "Not found")  {
			message = "요청하신 페이지를 찾을 수 없습니다.";
		} else if (xhr.status == 500) {
			message = "시스템 내부 오류가 발생하였습니다.";
		} else if (xhr.status == 503) {
			message = "서비스 이용이 지연되고 있습니다. 잠시 후 다시 시도하여 주십시오.";			
		} else if (xhr.status == 403 || xhr.errorThrown == "Forbidden") {
			message =  "접근 권한이 없습니다."; // "Access to the specified resource has // been forbidden.";
		} else if (xhr.errorThrown == 'timeout') {
			message = "처리 대기 시간을 초가하였습니다. 잠시 후 다시 시도하여 주십시오.";
		} else if (xhr.errorThrown == 'parsererror') {
			message = "데이터 파싱 중에 오류가 발생하였습니다.";
		} else {
			message = "오류가 발생하였습니다." ;
		}
		$.jGrowl(message, {
			sticky : false,
			life : 1000,
			animateOpen : {
				height : "show"
			},
			animateClose : {
				height : "hide"
			}
		});
	};
	
})(jQuery);

/**
 * User 
 *  - signin
 *  - signup
 *  - logout  
 */

;(function($, undefined) {
	var common = window.common = window.common || {} ;
	common.api.user = common.api.user || {} ;
	var kendo = window.kendo,
	handleKendoAjaxError = common.api.handleKendoAjaxError ;
	stringify = kendo.stringify,
	isFunction = kendo.isFunction,
	UNDEFINED = 'undefined',
	NUMBER = 'number',
	POST = 'POST',
	ANONYMOUS_PHOTO_URL = '/images/common/anonymous.png',
	JSON = 'json';		
	common.api.user.photoUrl = function ( user , width , height ){		
		if( typeof user === UNDEFINED)
		{
			return ANONYMOUS_PHOTO_URL 
		}	
		
		if( typeof user.username === 'string'){
			var _photoUrl = '/download/profile/' + user.username;	
			if( typeof width === NUMBER && typeof height === NUMBER ){
				_photoUrl = _photoUrl + '?width=' + width + '&height=' + height ;
			}
			return _photoUrl ;
		}
		return ANONYMOUS_PHOTO_URL ;
	} 
	
	common.api.user.signin = function ( options ){		
		options = options || {};
		$.ajax({
			type : 'POST',
			url : options.url || '/accounts/external-signin.do?output=json' ,
			data: { onetime : options.onetime },
			success : function(response){
				if( typeof response.error === UNDEFINED ){ 		
					if( isFunction(options.success) )
						options.success(new User(response)) ;						
				}else{
					if( isFunction(options.fail) )
						options.fail(response) ;								
				}
			},
			error:options.error || handleKendoAjaxError,
			dataType : "json"
		});	
	};	
	common.api.user.logout = function (options){
		options = options || {};
		$.ajax({
			type : 'GET',
			url : options.url || "/logout?output=json",
			success : function(response){
				if( options.success ){
					options.success(response);
				}
			},
			error:handleKendoAjaxError												
		});			
	}	
	common.api.user.signup = function ( options ){		
		options = options || {};		
		if( typeof options.external === UNDEFINED ){
			options.external = false;
		}		
		if( options.external )	{
			$.ajax({
				type : 'POST',
				url : options.url || '/accounts/external-signup.do?output=json' ,
				data: { item : options.data },
				success : function(response){
					if( typeof response.error === UNDEFINED ){ 		
						if( isFunction(options.success) )
							options.success(response) ;						
					}else{
						if( isFunction(options.fail) )
							options.fail(response) ;								
					}
				},
				error:options.error || handleKendoAjaxError,
				dataType : "json"
			});				
		}else{
			$.ajax({
				type : 'POST',
				url : options.url || '/accounts/create-user.do?output=json' ,
				data: { item : options.data },
				success : function(response){
					if( typeof response.error === UNDEFINED ){ 		
						if( isFunction(options.success) )
							options.success(response) ;						
					}else{
						if( isFunction(options.fail) )
							options.fail(response) ;								
					}
				},
				error:options.error || handleKendoAjaxError,
				dataType : "json"
			});				
		}
	};		
})(jQuery);	

/**
 * Community  
 */
;(function($, undefined) {
	var common = window.common = window.common || {} ;
	common.api = common.api || {} ;
	var kendo = window.kendo,
	Widget = kendo.ui.Widget, 
	isPlainObject = $.isPlainObject,
	DataSource = kendo.data.DataSource,
	handleKendoAjaxError = common.api.handleKendoAjaxError ,
	stringify = kendo.stringify,
	isFunction = kendo.isFunction,
	UNDEFINED = 'undefined',
	POST = 'POST',
	OBJECT_TYPE = 30 ,
	JSON = 'json';

	common.api.Forum = kendo.Class.extend({		
		init : function (options){
			options = options || {};			
			var that = this;
			that.options = options;
			if( typeof that.options.pageSize === UNDEFINED ){
				that.options.pageSize = 3;
			}				
		},
		dataSource : function (options){			
			var that = this;
			if( typeof that._dataSource ===  UNDEFINED){
				options = options || {};
				if( typeof options.transport === UNDEFINED){
					options.transport = {
						read: { type : POST, dataType:JSON, url : '/community/list-forum-topics.do?output=json' },
						parameterMap : function(options, operation) {
							if (operation != "read" && options.models) {
								return {models: kendo.stringify(options.models)};
							}else{
								return {forumId: that.options.forumId }
							}
						}
					}
				}
				if( typeof options.error === UNDEFINED ){
					options.error = handleKendoAjaxError;
				}
				if( typeof options.pageSize === UNDEFINED ){
					options.pageSize = that.options.pageSize;
				}			
				if( typeof options.schema === UNDEFINED ){
					options.schema = {
						total: "targetTopicCount",
						data : "targetTopics",
						model : common.models.ForumTopic						
					}
				}				
				that._dataSource = new DataSource(options);
			}		
			return that._dataSource;
		}	
	});
	
	common.api.teleportation = function(options){
		options = options || {};				
		if( typeof options.renderTo === UNDEFINED ){
			options.renderTo = 'teleportation';			
		}				
		if ($("#" +options.renderTo ).length == 0) {
			$('body').append(	'<div id="' +options.renderTo + '" style="display:none;"></div>');
		}		
		if(! $("#" +options.renderTo ).data('kendoExtNavigator') ){
			$("#" +options.renderTo ).extNavigator(options);
		}		
		return $("#" +options.renderTo ).data('kendoExtNavigator');
	}
	
	common.api.Navigator = Widget.extend({		
		init : function(element, options) {			
			var that = this;
			Widget.fn.init.call(that, element, options);
			options = that.options;
			element = that.element;
			that.refresh();
		},
		options : {
			name : "ExtNavigator"
		},
		refresh : function(){
			var that = this;
			var rendorTo = that.element;
			rendorTo.html(
				'<form name="teleportation-form" method="POST" accept-charset="utf-8">' +
				'<input type="hidden" name="output" value="html" />' +		
				'</form>'						
			);
		},
		teleport : function(params){			
			var that = this;			
			var template = kendo.template('<input type="hidden" name="#=name #" value="#=value #"/>');
			var form = that.element.find('form');
			if( typeof params === UNDEFINED ){
				params = params || {};				
			}									
			
			form.find('input[name!="output"]').remove();	
			
			if(isPlainObject(params)){
				$.each( params , function(propertyName, valueOfProperty ){
					if(propertyName === 'action'){
						form.attr('action', valueOfProperty );
					}else{	
						if( that.element.find('input[name="'+ propertyName + '"]').length === 0  ){			
							var html = template({name:propertyName , value:valueOfProperty });											
							form.append(html);							
						}else{							
							that.element.find('input[name="'+ propertyName + '"]').val(valueOfProperty);
						}
					}
				});
			}
			
			form.submit();
		}
	});
	
	$.fn.extend({
		extNavigator : function(options) {
			return new common.api.Navigator(this, options);
		}
	});
	
	
	common.api.Announcement = kendo.Class.extend({		
		init : function (options){
			options = options || {};			
			var that = this;
			that.options = options;
			if( typeof that.options.pageSize === UNDEFINED ){
				that.options.pageSize = 3;
			}				
		},
		dataSource : function (options){			
			var that = this;
			if( typeof that._dataSource ===  UNDEFINED){
				options = options || {};
				if( typeof options.transport === UNDEFINED){
					options.transport = {
						read: { type : POST, dataType:JSON, url : '/community/list-announce.do?output=json' },
						parameterMap : function(options, operation) {
							if (operation != "read" && options.models) {
								return {models: kendo.stringify(options.models)};
							}else{
								return {objectType: OBJECT_TYPE }
							}
						}
					}
				}
				if( typeof options.error === UNDEFINED ){
					options.error = handleKendoAjaxError;
				}
				if( typeof options.pageSize === UNDEFINED ){
					options.pageSize = that.options.pageSize;
				}			
				if( typeof options.schema === UNDEFINED ){
					options.schema = {
						data : "targetAnnounces",
						model : Announce						
					}
				}				
				that._dataSource = new DataSource(options);
			}		
			return that._dataSource;
		}	
	});
	
})(jQuery);


/**
 * Streams  
 */
;(function($, undefined) {
	var common = window.common = window.common || {} ;
	common.api.streams = common.api.streams || {} ;
	
	var kendo = window.kendo,
		handleKendoAjaxError = common.api.handleKendoAjaxError ;
		stringify = kendo.stringify,
		Photo = common.models.Photo,
		isFunction = kendo.isFunction,
		UNDEFINED = 'undefined',
		POST = 'POST',
		JSON = 'json',
		CALLBACK_URL_TEMPLATE = kendo.template("/community/#= media #-callback.do?output=json");

		common.api.streams.add = function (options){
			options = options || {};
			$.ajax({
				type : 'POST',
				url : options.url || '/community/add-streams-photo.do?output=json' ,
				data: { imageId : options.imageId },
				success : function(response){
					if( response.error ){ 												
						if( isFunction (options.fail) )
							options.fail(response) ;
					} else {					
						if( isFunction(options.success) )
							options.success(response) ;					
					}
				},
				error:options.error || handleKendoAjaxError,
				dataType : "json"
			});	
		}

		common.api.streams.remove = function (options){
			options = options || {};
			$.ajax({
				type : 'POST',
				url : options.url || '/community/remove-streams-photo.do?output=json' ,
				data: { imageId : options.imageId },
				success : function(response){
					if( response.error ){ 												
						if( isFunction (options.fail) )
							options.fail(response) ;
					} else {					
						if( isFunction(options.success) )
							options.success(response) ;					
					}
				},
				error:options.error || handleKendoAjaxError,
				dataType : "json"
			});	
		}	
		
		
		
		common.api.streams.dataSource = new kendo.data.DataSource({		
			serverPaging: true,
			pageSize: 15,
			transport: { 
				read: {
					url : '/community/list-streams-photo.do?output=json',
					type: 'POST',
					dataType: 'json'
				},
	            parameterMap: function (options, type){
	                return { startIndex: options.skip, pageSize: options.pageSize }
	            }
			},
	        schema: {
	            total: "photoCount",
	            data: "photos",
	            model: Photo
	        },
	        error: handleKendoAjaxError,
		});

		common.api.streams.details = function ( options ){		
			options = options || {};
			$.ajax({
				type : 'POST',
				url : options.url || '/community/get-streams-photo.do?output=json' ,
				data: { imageId : options.imageId },
				success : function(response){
					if( response.error ){ 												
						if( isFunction (options.fail) )
							options.fail(response) ;
					} else {					
						if( isFunction(options.success) )
							options.success(response) ;					
					}
				},
				error:options.error || handleKendoAjaxError,
				dataType : "json"
			});	
		};		
		

})(jQuery);

/**
 * Social  
 */
;(function($, undefined) {
	var common = window.common = window.common || {} ;
	common.api.social = common.api.social || {} ;
	
	var kendo = window.kendo,
		DataSource = kendo.data.DataSource,
		handleKendoAjaxError = common.api.handleKendoAjaxError ;
		stringify = kendo.stringify,
		isFunction = kendo.isFunction,
		UNDEFINED = 'undefined',
		CHANGE = "change",
		OPEN = "open",
		POST = 'POST',
		JSON = 'json',
		PROFILE_URL_TEMPLATE = kendo.template("/community/get-#= media #-profile.do?output=json"),
		CALLBACK_URL_TEMPLATE = kendo.template("/community/#= media #-callback.do?output=json");		
		
	common.api.social.dataSource = function (options){		
		if( typeof options.autoBind === UNDEFINED )
			options.autoBind = true;		
		
		if( typeof options.type === UNDEFINED )
			options.type = 'list';
		
		var dataSource = null;			
		
		if( typeof options.dataSource === 'object'){
			dataSource = DataSource.create(options.dataSource);
		}else{
			if( options.type === 'all' ){
				dataSource = DataSource.create({
					transport: {
						read: {
							type :POST,
							dataType : JSON, 
							url : '/community/list-socialnetwork.do?output=json'
						},
						parameterMap: function(options, operation) {
							if (operation != "read" && options.models) {
								return {models: kendo.stringify(options.models)};
							}
						} 
					},
					pageSize: 10,
					error:handleKendoAjaxError,				
					schema: {
						data : "socialNetworks",
						model : SocialNetwork
					}				
				});						
			}else 	if( options.type === 'list' ){
				dataSource = DataSource.create({
					transport: {
						read: {
							type :POST,
							dataType : JSON, 
							url : '/community/list-my-socialnetwork.do?output=json'
						} 
					},
					pageSize: 10,
					error:handleKendoAjaxError,				
					schema: {
						data : "connectedSocialNetworks",
						model : SocialNetwork
					}				
				});		
			}		
		}		
		if( isFunction(options.change) ){
			dataSource.bind(CHANGE, options.change );
		}		
		if (options.autoBind) {    
			dataSource.fetch();
		}		
		
		return dataSource;
	}			
	
	common.api.social.update = function ( options ){		
		options = options || {};	
		if( typeof options.url === UNDEFINED){
			options.url = '/community/update-socialnetwork.do?output=json';
		}
		$.ajax({
			type : POST,
			url : options.url,
			data: options.data,
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
			error:options.error || handleKendoAjaxError ,
			dataType : JSON
		});			
	}
		
	common.api.social.profile = function ( options ){				
		options = options || {};	
		if( typeof options.onetime === UNDEFINED  ){
			// connected profile access
			if( typeof options.url === UNDEFINED && typeof options.media == 'string' ){
				options.url = PROFILE_URL_TEMPLATE ({media : options.media});
			}				
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
				error:options.error || handleKendoAjaxError ,
				dataType : JSON
			});	
			
		}else{
			// onetime profile access			
			if( typeof options.url === UNDEFINED && typeof options.media == 'string' ){
				options.url = CALLBACK_URL_TEMPLATE ({media : options.media});
			}					
			$.ajax({
				type : POST,
				url : options.url,
				data: { onetime : options.onetime },
				success : function(response){
					//alert( ">" + (typeof response.error === UNDEFINED) );
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
				error:options.error || handleKendoAjaxError ,
				dataType : JSON
			});				
		}			
	};	
})(jQuery);