/**
 * COMMON UI DEFINE
 */
(function($, undefined) {
	var Widget = kendo.ui.Widget;
	var ui = window.ui = window.ui || {};
	var UNDEFINED = 'undefined',
	STRING = 'string';
	
	/** Utility */
	ui.util = {};	
	ui.util.prettyDate = function(time){
		var date = new Date((time || "").replace(/-/g,"/").replace(/[TZ]/g," ")),
			diff = (((new Date()).getTime() - date.getTime()) / 1000),
			day_diff = Math.floor(diff / 86400);
				
		if ( isNaN(day_diff) || day_diff < 0 || day_diff >= 31 )
			return;
				
		return day_diff == 0 && (
				diff < 60 && "just now" ||
				diff < 120 && "1 minute ago" ||
				diff < 3600 && Math.floor( diff / 60 ) + " minutes ago" ||
				diff < 7200 && "1 hour ago" ||
				diff < 86400 && Math.floor( diff / 3600 ) + " hours ago") ||
			day_diff == 1 && "Yesterday" ||
			day_diff < 7 && day_diff + " days ago" ||
			day_diff < 31 && Math.ceil( day_diff / 7 ) + " weeks ago";
	};
		
})(jQuery);	


/**
 *  extPanel widget
 */
(function($, undefined) {
	var Widget = kendo.ui.Widget, DataSource = kendo.data.DataSource, ui = window.ui = window.ui || {};
	var proxy = $.proxy, OPEN = 'open', CHANGE = "change" , observable = new kendo.data.ObservableObject( { title : "&nbsp;"} );
	
	ui.extPanel = Widget.extend({
		init: function(element, options) {			
			var that = this;		 
			Widget.fn.init.call(that, element, options);			
			options = that.options;							
			that.refresh();		
			kendo.notify(that);			
		},
		events : [
			CHANGE,
			OPEN
		],
		options : {
			name: "extPanel",
			title : null,
			template: null,
			data : {},
			refresh : false ,
			commands : []
		},
		hide: function (){
			var that = this ;
			that.element.hide();			
		},
		data: function(value) {
			var that = this;
	            if (value !== undefined) {
	            	that.options.data = value ;
	            	if( that.options.refresh )
	            		that.refresh();
	            	that.trigger( CHANGE, {data: that.options.data }); 
	            } else {
	                return that.options.data;
	            }
	    },
		refresh: function () {
			var that = this ;
			that.render();
			if( that.options.afterChange )
				that.options.afterChange( that.options.data );
		},
		show: function (){
			var that = this ;
			$(that.element).show();			
		},
		render: function () {				
			var that = this ;			
        	if( that.options.template ){       
        		$(that.element).html( that.options.template(that.data()) );
        		kendo.bind($(that.element), that.data());        		
        		//observable.set("title", that.data().name );
        		//kendo.bind($(that.element), observable );
        	}        	
        	$(that.element).find(".panel-header-actions a.k-link").each(function( index ){        		 
        		$(this).click(function (e) {
        			e.preventDefault();
        			var header_action = $(this);
        			if( header_action.text() == "Minimize" ){        				
        				var header_action_icon = header_action.find('span');
						if( header_action_icon.hasClass("k-i-minimize") ){
							header_action_icon.removeClass("k-i-minimize");
							header_action_icon.addClass("k-i-maximize");
							$(that.element).find(".panel-body, .panel-footer").addClass("hide");
						}else{
							header_action_icon.removeClass("k-i-maximize");
							header_action_icon.addClass("k-i-minimize");							
							$(that.element).find(".panel:first > .panel-body:last, .panel-footer").removeClass("hide");
						}						
        			}else if ( header_action.text() == "Close"){
        				that.destroy();
        			}else if ( header_action.text() == "Refresh"){	
        			
        			// custom
        			}else if ( header_action.text() == "Custom" ){        				
        				var _body = $(that.element).find(".panel-body:first");
        				if( _body.hasClass('hide') ){
        					_body.removeClass('hide');        					
        					that.trigger( OPEN, { element: (that.element).find(".panel-body:first")});
        				}else{
        					_body.addClass('hide');        					
        				}
        			}			
        		});
        	});        	
        	// custom 
        	$(that.element).find(".panel-body:first button.close").click(function(e){
        		e.preventDefault();	
        		$(that.element).find(".panel-body:first").addClass("hide");
        	});	        	
        	
        	$.each( that.options.commands, function(index, value){
        		$(value.selector).click(value.handler);
        	});        	
		},
		body: function(){
			var that = this;
			return $(that.element).find(".panel:first > .panel-body:last");
		},
        destroy: function() {
        	var that = this;
            Widget.fn.destroy.call(that);
            $(that.element).remove();
            //.off(NS);
            //open = false;
        },
	});
	
	$.fn.extend( { 
		extPanel : function ( options ) {
			return new ui.extPanel ( this , options );		
		}
	});	
})(jQuery);

/**
 *  extDropDownList widget
 */
(function($, undefined) {
	var Widget = kendo.ui.Widget, DataSource = kendo.data.DataSource, ui = window.ui = window.ui || {};
	ui.extDropDownList = Widget.extend({
		init: function(element, options) {
			var that = this;
			Widget.fn.init.call(that, element, options);
			options = that.options;		
			if( options.renderTo == null ){
				options.renderTo = element;
			}	
			if( options.value != null )
				that.value = options.value;			
			that.render(options);
		},
		events : {			
		},
		value: 0,
		dataSource : null,
		options : {
			name: "dropDownList",	
			dataSource: null,
			template : null,
			enabled : true,
		},
		_change: function (){
			var that = this;
		//	alert( '>>' + that.value );
			if( that.options.change != null )
				that.options.change( that.dataSource.get( that.value) );
		},
		render: function ( options ) {				
			var contentId = this.element.attr('id') + 'list';			
			var content = options.renderTo ;
			var that = this;
			
			that.dataSource = DataSource.create(options.dataSource);		
			that.dataSource.fetch(function(){
				var items = that.dataSource.data();
				var html = '<select id="' + contentId + '"role="navigation" class="form-control"'; 
				if( ! options.enabled )
					html = html + 'disabled >';
				else
					html = html + '>';
				
				$.each( items, function (index, value) {
					html = html + '<option ';
					if( that.value == value[options.dataValueField] )
						html = html + ' selected ';					
					html = html + ' value="'+ value[options.dataValueField]  +'" ' + '>'+ value[options.dataTextField] +'</option>' ;					
				});
				html = html + '</select>' ;
				content.append(html);
				that._change();
				
				$( "#" + contentId  ).change(function() {
					that.value = $( "#" + contentId  ).val() ;
					that._change();
				});
				
				if( options.doAfter != null){
					options.doAfter(that);
				}
 			});
		}
	});

	$.fn.extend( { 
		extDropDownList : function ( options ) {
			return new ui.extDropDownList ( this , options );		
		}
	});
	
})(jQuery);



/**
 * extNavBar widget
 */
(function($, undefined) {
	var Widget = kendo.ui.Widget, DataSource = kendo.data.DataSource, ui = window.ui = window.ui || {};
	ui.extTopBar = Widget.extend({
		init: function(element, options) {			
			var that = this;
			Widget.fn.init.call(that, element, options);			
			options = that.options;					
			if( options.renderTo == null ){
				options.renderTo = element;
			}
			that.items = new Array();
			that.render(options);				
		},
		events : {			
		},
		dataSource : null,
		items : null,
		options : {
			name: "topBar",	
			renderTo: null,
			menuName : null,
			dataSource: null,
			template : null,
			select : null,
		},
		render: function ( options ) {			
			var content = options.renderTo ;
			if( options.dataSource == null  && options.menuName != null ){
				this.dataSource = DataSource.create({
					transport: {
						read: {
							url: "/secure/get-company-menu-component.do?output=json",
							dataType: "json",
							data: {
								menuName: options.menuName
							}
						}
					},
					schema: {
						data: "targetCompanyMenuComponent.components"
					}
				});
			}else{
				this.dataSource = DataSource.create(options.dataSource);
			}			
			var that = this;
			that.dataSource.fetch(function(){
			var items = that.dataSource.data();
			content.append( options.template( items ) );					
				content.find('.nav a').click(function( e ){
					if( $(e.target).is('[action]') ){
						var selected = $(e.target);
						var item = { title: $.trim(selected.text()), action: selected.attr("action") , description: selected.attr("description") || "" };
						if( options.select != null )
							options.select( item );
						else
							that.select( item );
					}					
				});						
				if( $.isArray( options.items ) ){
					//alert ("array");
				}else if( (typeof options.items == "object") && (options.items !== null) ){
					if( options.items.type == 'dropDownList' ){
						var subItem = options.items;
						var subObject = $('#' + subItem.id ).extDropDownList(subItem);
						that.items.push( subObject );
					}
				}				
				if( options.doAfter != null ){
					options.doAfter(that);    					
				}
			});
		},
		select : function( item ){
			var content = this.options.renderTo ;			
			content.find("form[role='navigation']").attr("action", item.action ).submit();	
		},
		getMenuItem : function( name ){
			var items = this.dataSource.data();
			var menuItem = null;
			$.each( items, function ( i, item ){
				if(item.components.length > 0 )
				{	
					$.each( item.components, function ( j, item2 ){
						if( name == item2.name ){
							menuItem = item2;
							return;
						}
					});
				}else{
					if( name == item.name ){
						menuItem = item;
						return;						
					}
				}
			});
			return menuItem;
		},
		item : function (id){
			return $('#' + id ).data("extDropDownList");			
		}
	});
	$.fn.extend( { 
		extTopBar : function ( options ) {
			return new ui.extTopBar ( this , options );		
		}
	});
	
})(jQuery);


/**
 *  kendoTopBar widget
 */
(function($, undefined) {
	var Widget = kendo.ui.Widget, DataSource = kendo.data.DataSource, ui = window.ui = window.ui || {};
	var sliding = false;	
	var $body = $('body');	
	ui.kendoTopBar = Widget.extend({
		init: function(element, options) {
			var that = this;
			Widget.fn.init.call(that, element, options);
			options = that.options;		
			that.render(options);			
			element.click($.proxy( that._open, this ));				
		},
		events : {
			
		},
		options : {
			name: "topBar",	
			renderTo: null,
			dataSource: null,
			template : null
		},
		render: function ( options ) {			
			var content = options.renderTo ;
			var dataSource = DataSource.create(options.dataSource);	
			var that = this;
			dataSource.fetch(function(){
				var items = dataSource.data();
				content.append( options.template( items ) );	
				content.find('ul').first().kendoMenu({
 					orientation :  "vertical", // "horizontal",
 					select: function(e){	
 						if( $(e.item).is('[action]') ){
 							var selected = $(e.item);
 							options.select( { title: $.trim(selected.text()), action: selected.attr("action") , description: selected.attr("description") || "" } ); 							
 							setTimeout( function(){ that._open(); }, 300);
 						}
					}
 				});	
				if( options.doAfter != null ){
					options.doAfter(content);
				}	
			});
		},
		// Function that controls opening of the pageslide
		_open: function (e){
			var content = this.options.renderTo ;
			 var slide = kendo.fx(content).slideIn("right");
			 if( sliding ){
				 slide.reverse();
				 sliding = false;
			}else{	 
				 slide.play();
				 sliding = true;
			}
			e.preventDefault();
		}
	});
	$.fn.extend( { 
		kendoTopBar : function ( options ) {
			return new ui.kendoTopBar ( this , options );		
		}
	});	
})(jQuery);

/**
 *  Extended Accounts widget
 */
(function($, undefined) {	
	var Widget = kendo.ui.Widget, ui = window.ui = window.ui || {};
	var proxy = $.proxy,
	template = kendo.template,
	stringify = kendo.stringify,
	isFunction = kendo.isFunction,	
	AUTHENTICATE_URL = "/accounts/get-user.do?output=json",
	AUTHENTICATE = "authenticate", 
	LOGIN_URL = "/login", 
	//PHOTO_URL = "/download/view-image.do?width=100&height=150",
	CALLBACK_URL_TEMPLATE = kendo.template("#if ( typeof( connectorHostname ) == 'string'  ) { #http://#= connectorHostname ## } #/community/connect-socialnetwork.do?media=#= media #&domainName=#= domain #"),
	ERROR = "error",
	SHOWN = "shown",
	UPDATE = "update",
	ROLE_ADMIN = "ROLE_ADMIN",
	ROLE_SYSTEM = "ROLE_SYSTEM",
    NS = ".kendoAccounts",
	open = false,
	DISABLED = "disabled";	
	ui.kendoAccounts = Widget.extend( {		
		init: function(element, options) {	
			var that = this;			
			Widget.fn.init.call(that, element, options);
			options = that.options;
			element = that.element;			
			if (options.doAuthenticate) {
				that.authenticate();
			}
			kendo.notify(that);
		},	
		options : {	
			name : "Accounts",
			photoUrl : null,
			doAuthenticate: true,			
			visible: true,
			ajax : { url : AUTHENTICATE_URL },
			template : null,
			dropdown : true,
			connectorHostname : null ,
		},
		events : [
			AUTHENTICATE,
			ERROR,
			UPDATE,
			SHOWN
		],
        authenticate: function(){
        	var that = this ;
         	$.ajax({
    			type : 'POST',
    			url : that.options.ajax.url,
    			success : function(response){
    				user = new User ( $.extend(response.currentUser, { roles: response.roles } ));
    				user.set( 'isSystem', false);
    				
    				if(user.hasRole(ROLE_SYSTEM))
    					user.set( 'isSystem', true);
    				if(user.hasRole(ROLE_ADMIN))
    					user.set( 'isSystem', true);
    				
   					$(that.element).data("currentUser", user );
   					that.token = user ;    				
    				that.trigger( AUTHENTICATE, {token: user}); 
    				if(that.options.visible){
    					that.render();
    				}    				
					if( that.token.anonymous ){
						$(that.element).find(".custom-external-login-groups button").each(function( index ) {
								var external_login_button = $(this);
								external_login_button.click(function (e){										
									var target_media = external_login_button.attr("data-target");
									var target_url = CALLBACK_URL_TEMPLATE({connectorHostname: that.options.connectorHostname, media: target_media, domain: document.domain });
									window.open( 
									target_url,
									'popUpWindow', 
									'height=500, width=600, left=10, top=10, resizable=yes, scrollbars=yes, toolbar=yes, menubar=no, location=no, directories=no, status=yes');
								});								
						});	
					}    				    				
    				if( isFunction(that.options.afterAuthenticate) ){    					   					
    					that.options.afterAuthenticate();
    				}
    			},
    			error: that.options.ajax.error || handleKendoAjaxError,
    			dataType : "json"
    		});	 
        },
        login :  function (url, options){	    
    		if (typeof url === "object") {
    	        options = url;
    	        url = undefined;
    	    }	    
    	    // Force options to be an object
    	    options = options || {};		    
    	    $.ajax({
    			type : 'POST',
    			url : options.url || LOGIN_URL ,
    			data: options.data || {},
    			success : function(response){
    				if( response.error ){ 												
    					options.fail(response) ;
    				} else {
    					options.success(response) ;
    				}
    			},
    			error:options.error || handleKendoAjaxError,
    			dataType : "json"
    		});	
    	},
        render : function(){
        	var that = this, element, content;
        	/*if( that.options.photoUrl != null ){
        		that.token.photoUrl = that.options.photoUrl ;
        	}else{
        		that.token.photoUrl = null;
        	}        	        	
        	if( that.token.properties.imageId ){
        		that.token.photoUrl = PHOTO_URL + '&imageId=' + that.token.properties.imageId ;	
        	}
        	*/
        	if( that.options.template ){
        		that.element.html( that.options.template( that.token ) );        		
        	}        	
        	if( that.options.dropdown ){
	        	$(that.element).on('click.fndtn.dropdown', '[data-dropdown]', function (e) {        		
	                e.preventDefault();
	                e.stopPropagation();
	                that.toggle($(this));
	            });
	        	$('[data-dropdown-content]').on('click.fndtn.dropdown', function (e) {
	                e.stopPropagation();
	            });
        	}        	
        	that.trigger(SHOWN); 
        },
        toggle : function(target) {        	
        	var dropdown = $('#' + target.data('dropdown'));	        	
        	if( target.hasClass("dropped")){
        		target.removeClass("dropped");
        		dropdown.css("display", "none");
        		open = false;
        	}else{
        		target.addClass("dropped");
        		dropdown.css("display", "block");
        		open = true;
        	}        	
        },
        destroy: function() {
        	var that = this;
            Widget.fn.destroy.call(that);
            that.element.off(NS);
            open = false;
        },
        token : new User({})
	});
	
	$.fn.extend( { 
		kendoAccounts : function ( options ) {
			return new ui.kendoAccounts ( this , options );		
		}
	});	
})(jQuery);


/**
 * extSlideshow widget
 */

/**
 * extOverlay widget
 */
(function($, undefined) {
	var kendo = window.kendo,
	Widget = kendo.ui.Widget,
	proxy = $.proxy,
	ui = window.ui = window.ui || {};
 
	ui.extOverlay = Widget.extend({
		init: function(element, options) {			
			var that = this;			
			Widget.fn.init.call(that, element, options);
			
            element = that.wrapper = that.element;
            options = that.options;
            
			options.transitions = Modernizr.csstransitions ;
			var transEndEventNames = {
					'WebkitTransition': 'webkitTransitionEnd',
					'MozTransition': 'transitionend',
					'OTransition': 'oTransitionEnd',
					'msTransition': 'MSTransitionEnd',
					'transition': 'transitionend'
			};			
			options.transEndEventName = transEndEventNames[ Modernizr.prefixed( 'transition' ) ] ;			
			
			$(element).find('button.overlay-close').on('click', function (e) {
    			e.preventDefault();
				that.toggleOverlay();
			});			
		},
		options : {
			name : "Overlay"
		},
		toggleOverlay : function () {
			var that = this;
			var overlay = $(that.element);
			
			var options = that.options ;			
			
			if( overlay.hasClass( 'hide') ){
				overlay.removeClass( 'hide')
			}
			
			if( overlay.hasClass( 'open') ){
				overlay.removeClass( 'open' );
				
				if( $('body').hasClass('modal-open') )
					$('body').removeClass('modal-open') 
					
				overlay.addClass( 'close' );
				
				var onEndTransitionFn = function( ev ) {
					
					if( options.transitions ) {								
						if( ev.originalEvent.propertyName !== 'visibility' ) 
							return;						
						overlay.off( options.transEndEventName, onEndTransitionFn );					
					}
					overlay.removeClass( 'close' );
				};
				
				if( options.transitions ) {					
					overlay.on( options.transEndEventName, onEndTransitionFn );
				}
				else {
					onEndTransitionFn();
				}				
			}else if( !overlay.hasClass( 'close' ) ) {
				if( !$('body').hasClass('modal-open') )
					$('body').addClass('modal-open') 				
				overlay.addClass( 'open' );
			}
		}
	});

	$.fn.extend( { 
		extOverlay : function ( options ) {			
			return new ui.extOverlay ( this , options );		
		}
	});	

})(jQuery);


/**
 * 
 * common.ui package define.
 * 
 * 
 * 
 */
(function($, undefined) {
	var common = window.common = window.common || {};
	common.ui =  common.ui || {};	
	var kendo = window.kendo,
	Widget = kendo.ui.Widget,
	stringify = kendo.stringify,
	UNDEFINED = 'undefined',	
	proxy = $.proxy,	
	isFunction = kendo.isFunction;
			
	common.ui.handleActionEvents = function ( selector, options ){		
		options = options || {};		
		if( options.custom === UNDEFINED )
			 options.custom = false;		
		if ( typeof selector === 'string' )
			selector = $(selector);				
		
		if ( typeof options.handlers === UNDEFINED ){
			if(typeof options.event === 'string'  && isFunction(options.handler) ){
				if(typeof options.selector === UNDEFINED ){
					selector.on(options.event, options.handler);
				}else{
					selector.find(options.selector).on(options.event, options.handler);
				}			
			}
		}else if (options.handlers instanceof Array) {
			$.each(options.handlers, function(index, data){
				selector.find(data.selector).on(data.event, data.handler);
			});
		}
	};
	
	common.ui.handleButtonActionEvents = function ( selector, options ){		
		options = options || {};	
		if ( typeof selector === 'string' )
			selector = $(selector);		
		
		selector.each(function (index) {	
			var btn_control = $(this);
			var data_action = btn_control.attr("data-action");
			if ( typeof options.handlers === 'object' ){
				if( isFunction(options.handlers[data_action])){
					btn_control.bind( options.event , 	options.handlers[data_action]	);
				}
			}
		});				
	};
		
	common.ui.notification = function (options){
		var renderToString = "my-notifications";
		if( $("#"+ renderToString).length == 0 ){
			$('body').append('<span id="'+ renderToString +'" style="display:none;"></span>');
		}
		
		if( !$("#"+ renderToString).data("kendoNotification") ){
			$("#"+ renderToString).kendoNotification({
	            position: {
	                pinned: true,
	                top: 30,
	                right: 30
	            },
	            autoHideAfter: 0,
	            stacking: "down",
	            templates: [{
	                type: "info",
	                template: ""
	            }, {
	                type: "error",
	                template: '<div class="notification-error"><img src="/images/common/notification/error-icon.png" /><h3>#= title #</h3><p>#= message #</p></div>'
	            }, {
	                type: "success",
	                template: '<div class="notification-success"><img src="/images/common/notification/success-icon.png" /><h3>#= title #</h3><p>#= message #</p></div>'
	            }]	            
	        });
		}
		$("#" + renderToString).data("kendoNotification").show({
			title : "Wrong Password",
			message : "Please enter your password again."
		}, "error");
	};
	
})(jQuery);	
/**
 * extSlideshow widget
 */
(function($, undefined) {
	var kendo = window.kendo,
	Widget = kendo.ui.Widget,
	proxy = $.proxy,	
	ui = window.ui = window.ui || {};
 
	ui.extSlideshow = Widget.extend({
		init: function(element, options) {			
			var that = this;			
			Widget.fn.init.call(that, element, options);			
			that.wrapper = that.element;
			options = that.options,	
			slideshow = $(that.element);
			
			options.items = slideshow.find('li');		
			options.itemsCount = options.items.length;

			slideshow.imagesLoaded(function(){
				if( Modernizr.backgroundsize ) {
					options.items.each( function(){
						 var item = $( this );
						 item.css( 'background-image', 'url(' + item.find( 'img' ).attr( 'src' ) + ')' );						
					} );					
				}else {
					slideshow.find( 'img' ).show();					
				}
				options.items.eq( options.current  ).css( 'opacity', 1 );
				that._initEvents();
				that._start();
			});
		},
		options : {
			name : "Slideshow",
			current : 0,
			slideshowtime: 0,
			slideshowActive : true,
			interval : 6000,
			items : [],
			itemsCount : 0
		},
		_navigate : function( direction ) {
			// current item
			var that = this;
			var options = that.options ;				
			var oldItem = options.items.eq( options.current );			
			if( direction === 'next' ) {
				options.current = options.current < options.itemsCount - 1 ? ++options.current : 0;
			}
			else if( direction === 'prev' ) {
				options.current = options.current > 0 ? --options.current : options.itemsCount - 1;
			}
			// new item
			var newItem = options.items.eq( options.current  );
			// show / hide items
			oldItem.css( 'opacity', 0 );
			newItem.css( 'opacity', 1 );
		},
		_start : function () {
			var that = this;
			var options = that.options ;				
			options.slideshowActive = true;
			clearTimeout( options.slideshowtime );
			options.slideshowtime = setTimeout( function() {
				that._navigate( 'next' );
				that._start();
			}, options.interval );
		},
		_stop : function () {
			var that = this;
			var options = that.options ;				
			options.slideshowActive = false;
			clearTimeout( options.slideshowtime );
		},
		_initEvents : function () {
			var that = this;
			var options = that.options ;			
			var navigation =  options.navigation;

			if( typeof navigation ===  'object'){
				navigation.find('span.cbp-bipause').on( 'click', function(){
					var control = $( this );
					if( control.hasClass( 'cbp-biplay' ) ) {
						control.removeClass( 'cbp-biplay' ).addClass( 'cbp-bipause' );
						that._start();
					}
					else {
						control.removeClass( 'cbp-bipause' ).addClass( 'cbp-biplay' );
						that._stop();
					}
				});
				
				var prev = navigation.find('span.cbp-biprev').on('click', function(){
					that._navigate( 'prev' ); 
					if( options.slideshowActive ) { 
						that._start();
					} 
				});
				
				var next = navigation.find('span.cbp-binext').on('click', function(){
					that._navigate( 'next' ); 
					if( options.slideshowActive ) { 
						that._start();
					}
				});
			}
		}
	});

	$.fn.extend( { 
		extSlideshow : function ( options ) {			
			return new ui.extSlideshow ( this , options );		
		}
	});	

})(jQuery);

/**
 *  extModalWindow widget
 */
(function($, undefined) {
	var common = window.common = window.common || {};
	common.ui =  common.ui || {};
    var kendo = window.kendo,
    Widget = kendo.ui.Widget,
    isPlainObject = $.isPlainObject,
    proxy = $.proxy,
    extend = $.extend,
    placeholderSupported = kendo.support.placeholder,
    browser = kendo.support.browser,
    isFunction = kendo.isFunction,
    trimSlashesRegExp = /(^\/|\/$)/g,
    CHANGE = "change",
    ERROR = "error",
    REFRESH = "refresh",
    OPEN = "open",
    CLOSE = "close",
    CLICK = "click",
	UNDEFINED = 'undefined',
	POST = 'POST',
	JSON = 'json',
	handleKendoAjaxError = common.api.handleKendoAjaxError ;
    
    common.ui.extModalWindow = Widget.extend({
		init: function( element, options) {			
			var that = this;		 
			Widget.fn.init.call(that, element, options);			
			options = that.options;
			that.refresh();		
		},
		events: [ERROR, CHANGE, CLICK, OPEN, REFRESH, CLOSE],
		options : {
			name: "ExtModalWindow",
		},
		open: function() {
			var that = this ;			
			
			if( typeof that.options.backdrop === 'string' )
			{
				that._modal().modal({
					backdrop : that.options.backdrop,
					show : true
				});
			}
			else{	
				that._modal().modal('show');
			}
		},
		close: function () {
			var that = this ;
			that._modal().modal('hide');
		},
		refresh: function () {
			var that = this ;
			that._createDialog();			
		},		
		destroy: function() {
			var that = this;
			Widget.fn.destroy.call(that);			
			$(that.element).remove();
		},
		_modal : function () {
			var that = this ;
			return  that.element.children('.modal');
		},
		_changeState : function ( enabled ) {
			var that = this ;
			if ( enabled ){
				that.element.find('.modal-footer .btn.custom-update').removeAttr('disabled');	
			}else{
				that.element.find('.modal-footer .btn.custom-update').attr('disabled', 'disabled');	
			}
		},
		_createDialog : function () {			
			var that = this ;
			var template = that._dialogTemplate();							
			that.element.html(template({ 
				title : that.options.title || ""
			}));				
			if( typeof  that.options.data === 'object' ){			
				kendo.bind( that._modal(), that.options.data );
				if ( that.options.data instanceof kendo.data.ObservableObject ) {
					that.options.data.bind( "change", function(e){
						that.trigger(CHANGE, { field : e.field , element: that._modal()[0], data : that.options.data });						
					} );					
				}					
			}			
			that._modal().css('z-index', '2000');				
			that.element.find('.modal').on('show.bs.modal' , function(e){
				that.trigger(OPEN, { element: that._modal()[0] });
			});		
			that.element.find('.modal').on('hide.bs.modal' , function(e){
				that.trigger(CLOSE, { element: that._modal()[0] });
			});		
			
			that.trigger(REFRESH, { element: that._modal()[0] });
		},
		_dialogTemplate : function (){
			var that = this ;			
			if( typeof that.options.template === UNDEFINED){
				return kendo.template( 
						"<div class='modal editor-popup fade' tabindex='-1' role='dialog' aria-hidden='true'>" +	
						"<div class='modal-dialog modal-lg'>" +	
						"<div class='modal-content'>" + 
						"<div class='modal-header'>" +				
						"<button type='button' class='close' data-dismiss='modal' aria-hidden='true'>&times;</button>" +
						"<h5 class='modal-title'>#= title #</h5>" + 
						"</div>" + 
						"<div class='modal-body'>" +				
						"</div>" + 
						"<div class='modal-footer'>" +							
						"</div>" + 				
						"</div><!-- /.modal-content -->" +
						"</div><!-- /.modal-dialog -->" +
						"</div><!-- /.modal -->"
					);		
			}else 	if( typeof that.options.template === 'object'){
				return that.options.template ;			
			}
			else if( typeof that.options.template === 'string'){
				return kendo.template( that.options.template );
			}
		}
	});
	
	$.fn.extend( { 
		extModalWindow : function ( options ) {
			return new common.ui.extModalWindow ( this , options );		
		}
	});	
})(jQuery);


/**
 *  extEditorPopup widget
 */
(function($, undefined) {
	var common = window.common = window.common || {};
	common.ui =  common.ui || {};
    var kendo = window.kendo,
    Widget = kendo.ui.Widget,
    isPlainObject = $.isPlainObject,
    proxy = $.proxy,
    extend = $.extend,
    placeholderSupported = kendo.support.placeholder,
    browser = kendo.support.browser,
    isFunction = kendo.isFunction,
    trimSlashesRegExp = /(^\/|\/$)/g,
    CHANGE = "change",
    APPLY = "apply",
    ERROR = "error",
    CLICK = "click",
	UNDEFINED = 'undefined',
	POST = 'POST',
	JSON = 'json',		
	LINK_VALUE_TEMPLATE = kendo.template( '<a href="#: linkUrl #" title="#: linkTitle #" #if (linkTarget) { # target="_blank"  # }#>#= linkTitle #</a>' ),
	handleKendoAjaxError = common.api.handleKendoAjaxError ;
	
    common.ui.extEditorPopup = Widget.extend({
		init: function(element, options) {			
			var that = this;		 
			Widget.fn.init.call(that, element, options);			
			options = that.options;		
			that.refresh();		
		},
		events: [ERROR, CHANGE, APPLY],
		options : {
			name: "ExtEditorPopup",
			transport:{		
				
			} 
		},
		show: function() {
			var that = this ;			
			that._modal().modal('show');
		},
		close: function () {
			var that = this ;
			that._modal().modal('hide');
		},
		refresh: function () {
			var that = this ;
			that._createDialog();
		},		
		destroy: function() {
			var that = this;
			Widget.fn.destroy.call(that);			
			$(that.element).remove();
		},
		data: function() {
			var that = this ;
			return that._data;
		},
		_modal : function () {
			var that = this ;
			return  that.element.children('.modal');
		},
		_changeState : function ( enabled ) {
			var that = this ;
			if ( enabled ){
				that.element.find('.modal-footer .btn.custom-update').removeAttr('disabled');			
			}else{
				that.element.find('.modal-footer .btn.custom-update').attr('disabled', 'disabled');			
			}			
		},			
		_createDialog : function () {			
			var that = this ;
			var template = that._dialogTemplate();				
			
			that.element.html(template({ 
				title : that.options.title || "", 
				type : that.options.type 
			}));				
			if( that.options.type == 'createLink' ){
				that._data = kendo.observable({ 
					linkUrl : "",
					linkTitle : "",
					linkTarget : false					
				});	
				that._data.bind("change", function(e){
					if( e.field == 'linkUrl' ){
						if( that._data.get( e.field ).length > 0)
							that._changeState(true);
						else 
							that._changeState(false);
					}					
				});				
			}
			kendo.bind( that.element, that._data );			
			
			that.element.children( '.modal').css('z-index', '2000');			
			that.element.find('.modal').on('show.bs.modal' , function(e){
				if( that.options.type == 'createLink' ){
					that.element.find('input').val('');
					that.element.find('input[type="checkbox"]').removeAttr('checked');
				}
				that._changeState(false);
			});				
			
			that.element.find('.modal-footer .btn.custom-update').click( function() {
				that.trigger(APPLY, { html: LINK_VALUE_TEMPLATE (that._data) } );				
			} );
		},
		_dialogTemplate : function (){
			var that = this ;			
			if( typeof that.options.template === UNDEFINED){
				return kendo.template( 
						"<div class='modal editor-popup fade' tabindex='-1' role='dialog' aria-hidden='true'>" +	
						"<div class='modal-dialog modal-sm'>" +	
						"<div class='modal-content'>" + 
						"<div class='modal-header'>" +				
						"<button type='button' class='close' data-dismiss='modal' aria-hidden='true'>&times;</button>" +
						"<h5 class='modal-title'>#= title #</h5>" + 
						"</div>" + 
						"<div class='modal-body'>" +				
						"</div>" + 
						"<div class='modal-footer'>" +							
						"</div>" + 				
						"</div><!-- /.modal-content -->" +
						"</div><!-- /.modal-dialog -->" +
						"</div><!-- /.modal -->"
					);		
			}else 	if( typeof that.options.template === 'object'){
				return that.options.template ;			
			}
			else if( typeof that.options.template === 'string'){
				return kendo.template( that.options.template );
			}
		}
	});
	
	$.fn.extend( { 
		extEditorPopup : function ( options ) {
			return new common.ui.extEditorPopup ( this , options );		
		}
	});	
})(jQuery);


(function($, undefined) {
	var common = window.common = window.common || {};
	common.ui =  common.ui || {};
    var kendo = window.kendo,
    Widget = kendo.ui.Widget,
    isPlainObject = $.isPlainObject,
    proxy = $.proxy,
    extend = $.extend,
    placeholderSupported = kendo.support.placeholder,
    browser = kendo.support.browser,
    isFunction = kendo.isFunction,
    trimSlashesRegExp = /(^\/|\/$)/g,
    CHANGE = "change",
    APPLY = "apply",
    ERROR = "error",
    CLICK = "click",
    MODAL_TITIL_ID = "title_guid",
	TAB_PANE_URL_ID = "url_guid" ,
	TAB_PANE_UPLOAD_ID = "upload_guid" ,
    TAB_PANE_MY_ID = "my_guid" ,
    TAB_PANE_WEBSITE_ID = "website_guid" ,
    TAB_PANE_DOMAIN_ID = "domain_guid" ,
	UNDEFINED = 'undefined',
	POST = 'POST',
	JSON = 'json',		
	VALUE_TEMPLATE = kendo.template( '<img src="#: url #" class="img-responsive"/>' ),
	SELECTED_IMAGE_TEMPLAGE = kendo.template(
		'<div class="panel-body custom-selected-image">' + 	
			'<div class="media">' +
				'<a class="pull-left" href="\\#">' +
					'<img class="media-object" src="/community/download-my-domain-image.do?imageId=#=imageId#&width=150&height=150" alt="#=name#">' +
				'</a>' +
				'<div class="media-body">' +
					'<h5 class="media-heading"><span class="label label-warning">#= contentType #</span> #=name#</h5>' +
						'<small><p class="text-muted">생성일: #= kendo.toString( creationDate, "yyyy.MM.dd hh:mm tt" )#</p>'+
						'<p class="text-muted">수정일: #= kendo.toString( modifiedDate, "yyyy.MM.dd hh:mm tt" )#</p>'+		
						'<p class="text-muted">크기: #= kendo.toString( size, "\\#\\#,\\#" ) #</p>'+								
						'<p class="text-danger">이미지를 사용하시면 이미지 링크를 통하여 누구나 볼수 있게 됩니다.</p></small>' +
				'</div>' +
			'</div>'	+
		'</div>'		
	),
	URL_TEMPLATE = kendo.template( '/download/image/#= key #' ),
	handleKendoAjaxError = common.api.handleKendoAjaxError ;
	
    common.ui.extImageBrowser = Widget.extend({
		init: function(element, options) {			
			var that = this;		 
			Widget.fn.init.call(that, element, options);			
			options = that.options;		
			options.guid = {
				title_guid:common.api.guid().toLowerCase(),
				url_guid:common.api.guid().toLowerCase(),
				upload_guid:common.api.guid().toLowerCase(),
				my_guid:common.api.guid().toLowerCase(),
				domain_guid:common.api.guid().toLowerCase(),
				website_guid:common.api.guid().toLowerCase()
			};			
			that.refresh();		
		},
		events: [ERROR, CHANGE, APPLY],
		options : {
			name: "ExtImageBrowser",
			transport:{				
			} 
		},
		show: function() {
			var that = this ;
			that._modal().modal('show');
			that.element.find('.modal-body ul.nav a:first').tab('show');
		},
		close: function () {
			var that = this ;
			that._modal().modal('hide');
		},
		refresh: function () {
			var that = this ;
			that._createDialog();
		},		
		destroy: function() {
			var that = this;
			Widget.fn.destroy.call(that);			
			$(that.element).remove();
		},
		_getImageLink : function ( image , callback ){
			common.api.getImagelink({
				imageId : image.imageId ,
				success : function( data ) {
					callback( data );
				}					
			});
		},			
		_modal : function () {
			var that = this ;
			return  that.element.children('.modal');
		},
		_createDialog : function () {			
			var that = this ;
			var template = that._dialogTemplate();			
			that.element.html(template(that.options.guid));					
			that.element.children( '.modal').css('z-index', '2000');
			that.element.find( '.modal-body a[data-toggle="tab"]' ).on('shown.bs.tab', function (e) {
				e.target // activated tab
				e.relatedTarget // previous tab
				that._changeState(false);					
				var tab_pane_id = $( e.target ).attr('href');				
				var tab_pane = $(tab_pane_id );					
				switch(tab_pane_id){
				case "#" + that.options.guid[TAB_PANE_DOMAIN_ID] :
					// domain images
					var my_list_view = tab_pane.find('.panel-body div');				
					var my_list_pager = tab_pane.find('.panel-footer div');		
					
					
					if(!my_list_view.data('kendoListView') ){
						my_list_view.kendoListView({ 
							dataSource: {
								type: 'json',
								transport: {
									read: { url:'/community/list-my-domain-image.do?output=json', type: 'POST' },
									parameterMap: function (options, operation){
										if (operation != "read" && options) {										                        								                       	 	
											return { };									                            	
										}else{
											 return { startIndex: options.skip, pageSize: options.pageSize }
										}
									}
								},			
								pageSize: 12,
								error:handleKendoAjaxError,
								schema: {
									model: Image,
									data : "targetImages",
									total : "totalTargetImageCount"
								},
								serverPaging: true
							},
							selectable: "single",									
							change: function(e) {											
								tab_pane.find('.panel-body.custom-selected-image').remove();
								var data = this.dataSource.view() ;								
								var current_index = this.select().index();
								if( current_index >= 0 ){									
									var item = data[current_index];				
									var imageId = item.imageId;								
									if( imageId > 0 ){									
										that._getImageLink( item , function ( data ) {
											if( typeof data.imageLink ===  'object' ){
												my_list_view.data("linkId" , data.imageLink.linkId );
												that._changeState(true);		
												
												var t = kendo.template(
													'<div class="panel-body custom-selected-image">' + 
													'<p><img src="/community/download-my-domain-image.do?imageId=#=imageId#&width=150&height=150" class="img-rounded" ></p>' +
													'<p class="text-danger">이미지를 사용하시면 이미지 링크를 통하여 누구나 볼수 있게 됩니다.</p></div>');
												
												tab_pane.find('.panel').prepend(
														SELECTED_IMAGE_TEMPLAGE( item )	
												);											
											}										
										});									
									}																				
								}
							},
							navigatable: false,
							template: kendo.template($("#photo-list-view-template").html()),								
							dataBound: function(e) {
								tab_pane.find('.panel-body.custom-selected-image').remove();
								that._changeState(false);
							}
						});							
						my_list_view.on("mouseenter",  ".img-wrapper", function(e) {
							kendo.fx($(e.currentTarget).find(".img-description")).expand("vertical").stop().play();
						}).on("mouseleave", ".img-wrapper", function(e) {
							kendo.fx($(e.currentTarget).find(".img-description")).expand("vertical").stop().reverse();
						});	
						my_list_pager.kendoPager({
							refresh : true,
							buttonCount : 5,
							dataSource : my_list_view.data('kendoListView').dataSource
						});						
					}else{
						my_list_view.data('kendoListView').clearSelection();
					}
					break;
				case "#" + that.options.guid[TAB_PANE_WEBSITE_ID] :
					// website images
					var my_list_view = tab_pane.find('.panel-body div');				
					var my_list_pager = tab_pane.find('.panel-footer div');		
					if(!my_list_view.data('kendoListView') ){
						my_list_view.kendoListView({ 
							dataSource: {
								type: 'json',
								transport: {
									read: { url:'/community/list-my-website-image.do?output=json', type: 'POST' },
									parameterMap: function (options, operation){
										if (operation != "read" && options) {										                        								                       	 	
											return { };									                            	
										}else{
											 return { startIndex: options.skip, pageSize: options.pageSize }
										}
									}
								},			
								pageSize: 12,
								error:handleKendoAjaxError,
								schema: {
									model: Image,
									data : "targetImages",
									total : "totalTargetImageCount"
								},
								serverPaging: true
							},
							selectable: "single",									
							change: function(e) {											
								tab_pane.find('.panel-body.custom-selected-image').remove();
								var data = this.dataSource.view() ;
								var current_index = this.select().index();
								if( current_index >= 0 ){			
									var item = data[current_index];							
									var imageId = item.imageId;								
									if( imageId > 0 ){									
										that._getImageLink( item , function ( data ) {
											if( typeof data.imageLink ===  'object' ){
												my_list_view.data("linkId" , data.imageLink.linkId );
												that._changeState(true);											
												var t = kendo.template(
													'<div class="panel-body custom-selected-image">' + 
													'<p><img src="/community/download-my-domain-image.do?imageId=#=imageId#&width=150&height=150" class="img-rounded" ></p>' +
													'<p class="text-danger">이미지를 사용하시면 이미지 링크를 통하여 누구나 볼수 있게 됩니다.</p></div>');
												
												tab_pane.find('.panel').prepend(
														SELECTED_IMAGE_TEMPLAGE( item )	
												);											
											}										
										});									
									}
								}
							},
							navigatable: false,
							template: kendo.template($("#photo-list-view-template").html()),								
							dataBound: function(e) {
								tab_pane.find('.panel-body.custom-selected-image').remove();
								that._changeState(false);
							}
						});							
						my_list_view.on("mouseenter",  ".img-wrapper", function(e) {
							kendo.fx($(e.currentTarget).find(".img-description")).expand("vertical").stop().play();
						}).on("mouseleave", ".img-wrapper", function(e) {
							kendo.fx($(e.currentTarget).find(".img-description")).expand("vertical").stop().reverse();
						});	
						my_list_pager.kendoPager({
							refresh : true,
							buttonCount : 5,
							dataSource : my_list_view.data('kendoListView').dataSource
						});						
					}else{
						my_list_view.data('kendoListView').clearSelection();
					}
					break;					
				case "#" + that.options.guid[TAB_PANE_MY_ID] :					
					var my_list_view = tab_pane.find('.panel-body div');				
					var my_list_pager = tab_pane.find('.panel-footer div');		
					if(!my_list_view.data('kendoListView') ){
						my_list_view.kendoListView({ 
							dataSource: {
								type: 'json',
								transport: {
									read: { url:'/community/list-my-image.do?output=json', type: 'POST' },
									parameterMap: function (options, operation){
										if (operation != "read" && options) {										                        								                       	 	
											return { };									                            	
										}else{
											 return { startIndex: options.skip, pageSize: options.pageSize }
										}
									}
								},			
								pageSize: 12,
								error:handleKendoAjaxError,
								schema: {
									model: Image,
									data : "targetImages",
									total : "totalTargetImageCount"
								},
								serverPaging: true
							},
							selectable: "single",									
							change: function(e) {											
								tab_pane.find('.panel-body.custom-selected-image').remove();
								var data = this.dataSource.view() ;
								var current_index = this.select().index();
								if( current_index >= 0 ){		
									var item = data[current_index];							
									var imageId = item.imageId;								
									if( imageId > 0 ){									
										that._getImageLink( item , function ( data ) {
											if( typeof data.imageLink ===  'object' ){
												my_list_view.data("linkId" , data.imageLink.linkId );
												that._changeState(true);		
												
												var t = kendo.template(
													'<div class="panel-body custom-selected-image">' + 
													'<p><img src="/community/download-my-image.do?imageId=#=imageId#&width=150&height=150" class="img-rounded" ></p>' +
													'<p class="text-danger">이미지를 사용하시면 이미지 링크를 통하여 누구나 볼수 있게 됩니다.</p></div>');
												
												tab_pane.find('.panel').prepend(
														SELECTED_IMAGE_TEMPLAGE( item )	
												);											
											}										
										});									
									}
								}
							},
							navigatable: false,
							template: kendo.template($("#photo-list-view-template").html()),								
							dataBound: function(e) {
								tab_pane.find('.panel-body.custom-selected-image').remove();
								that._changeState(false);
							}
						});							
						my_list_view.on("mouseenter",  ".img-wrapper", function(e) {
							kendo.fx($(e.currentTarget).find(".img-description")).expand("vertical").stop().play();
						}).on("mouseleave", ".img-wrapper", function(e) {
							kendo.fx($(e.currentTarget).find(".img-description")).expand("vertical").stop().reverse();
						});	
						my_list_pager.kendoPager({
							refresh : true,
							buttonCount : 5,
							dataSource : my_list_view.data('kendoListView').dataSource
						});						
					}else{
						my_list_view.data('kendoListView').clearSelection();
					}
					break;
				case "#" + that.options.guid[TAB_PANE_URL_ID] :
					var form_input = that.element.find('.modal-body input[name="custom-selected-url"]');
					var selected_img =  $("#" + that.options.guid[TAB_PANE_URL_ID] ).children('img');	
					form_input.val("");					
					if(form_input.parent().hasClass('has-error') )
						form_input.parent().removeClass('has-error');		
					if(form_input.parent().hasClass('has-success') )
						form_input.parent().removeClass('has-success');							
					if(! selected_img.hasClass('hide') )
						selected_img.addClass('hide');							
					break;
				}
			});			
			
			that.element.find('.modal-body input[name="custom-selected-url"]').on('change', function () {				
				var form_input = $(this);				
				var selected_img =   $("#" + that.options.guid[TAB_PANE_URL_ID] ).children('img');	
				if( form_input.val().length == 0 ) {
					if(! selected_img.hasClass('hide') )
						selected_img.addClass('hide');								
					if(form_input.parent().hasClass('has-error') )
						form_input.parent().removeClass('has-error');		
					if(form_input.parent().hasClass('has-success') )
						form_input.parent().removeClass('has-success');							
					that._changeState(false);
				}else{								
					selected_img.attr('src', form_input.val()).load(function(){
						if(form_input.parent().hasClass('has-error') )
							form_input.parent().removeClass('has-error');					
						form_input.parent().addClass('has-success');
						selected_img.removeClass('hide');		
						that._changeState(true);						
					}).error(function(){					
						if( ! selected_img.hasClass('hide') )
							selected_img.addClass('hide');						
						if(form_input.parent().hasClass('has-success') )
							form_input.parent().removeClass('has-success');					
						form_input.parent().addClass('has-error');		
						that._changeState(false);
					});					
				}	
			});
			
			that.element.find('.modal-footer .btn.custom-insert-img').on('click', function () {				
				var tab_pane = that._activePane();			
				var selected_url ;
				switch( tab_pane.attr('id') ){
					case that.options.guid[TAB_PANE_URL_ID] :					
						selected_url = that.element.find('.modal-body input[name="custom-selected-url"]').val();					
						break;
					case that.options.guid[TAB_PANE_DOMAIN_ID] :
						var my_list_view = tab_pane.find('.panel-body div');
						var linkId = my_list_view.data("linkId");
						selected_url = URL_TEMPLATE({ key : linkId });
						my_list_view.data("linkId", null );						
						break;
					case that.options.guid[TAB_PANE_WEBSITE_ID] :
						var my_list_view = tab_pane.find('.panel-body div');
						var linkId = my_list_view.data("linkId");
						selected_url = URL_TEMPLATE({ key : linkId });
						my_list_view.data("linkId", null );						
						break;						
					case that.options.guid[TAB_PANE_MY_ID] :		
						var my_list_view = tab_pane.find('.panel-body div');
						var linkId = my_list_view.data("linkId");
						selected_url = URL_TEMPLATE({ key : linkId });
						my_list_view.data("linkId", null );
					break;	
				}								
				that.trigger(APPLY, { html: VALUE_TEMPLATE({ url : selected_url })} );
			});
		},
		_activePane : function () {
			var that = this ;
			return that.element.find( '.tab-content > .tab-pane.active' ) ;
		},
		_changeState : function ( enabled ) {
			var that = this ;
			if ( enabled ){
				that.element.find('.modal-footer .btn.custom-insert-img').removeAttr('disabled');			
			}else{
				that.element.find('.modal-footer .btn.custom-insert-img').attr('disabled', 'disabled');			
			}			
		},		
		_dialogTemplate : function (){
			var that = this ;			
			if( typeof that.options.template === UNDEFINED){
				return kendo.template( 
						"<div class='modal fade' tabindex='-1' role='dialog' aria-labelledby=#:id# aria-hidden='true'>" +	
						"<div class='modal-dialog modal-lg'>" +	
						"<div class='modal-content'>" + 
						"<div class='modal-header'>" +				
						"<button type='button' class='close' data-dismiss='modal' aria-hidden='true'>&times;</button>" +
						"<h5 class='modal-title' id=#: id #>이미지 삽입</h5>" + 
						"</div>" + 
						"<div class='modal-body'>" +				
						"</div>" + 
						"<div class='modal-footer'>" +				
						"</div>" + 				
						"</div><!-- /.modal-content -->" +
						"</div><!-- /.modal-dialog -->" +
						"</div><!-- /.modal -->"
					);		
			}else 	if( typeof that.options.template === 'object'){
				return that.options.template ;			
			}
			else if( typeof that.options.template === 'string'){
				return kendo.template( that.options.template );
			}
		}
	});
	
	$.fn.extend( { 
		extImageBrowser : function ( options ) {
			return new common.ui.extImageBrowser ( this , options );		
		}
	});	
})(jQuery);

/**
 *  FullscreenSlideshow widget
 */
(function($, undefined) {
	var common = window.common = window.common || {};
	common.ui =  common.ui || {};
    var kendo = window.kendo,
    Widget = kendo.ui.Widget,
    isPlainObject = $.isPlainObject,
    proxy = $.proxy,
    extend = $.extend,
    placeholderSupported = kendo.support.placeholder,
    browser = kendo.support.browser,
    isFunction = kendo.isFunction,
    CHANGE = "change",
	UNDEFINED = 'undefined',
	TEMPLATE = kendo.template( 
		'<ul id="cbp-bislideshow" class="cbp-bislideshow"></ul>' +
		'<div id="cbp-bicontrols" class="cbp-bicontrols">' +
		'<span class="fa cbp-biprev"></span>' +
		'<span class="fa cbp-bipause"></span>' +
		'<span class="fa cbp-binext"></span>' +
		'</div>' +
		'</div>'
	),
	ITEM_TEMPLATE = kendo.template( '<li><img src="/community/view-streams-photo.do?key=#= externalId#" alt="이미지"/></li>' ),
	handleKendoAjaxError = common.api.handleKendoAjaxError ;
	
    common.ui.extFullscreenSlideshow = Widget.extend({
		init: function(element, options) {			
			var that = this;		 
			Widget.fn.init.call(that, element, options);			
			options = that.options;
			that._dataSource();
			that.element.html(TEMPLATE);			
			that._initEvents();
		},
		options : {
			name: "ExtFullscreenSlideshow",
			autoBind : true,
			interval : 6000,
			slideshowtime: 0
		},
		_initEvents : function () {
			var that = this;
			var options = that.options ;			
			var controls = that.element.children('.cbp-bicontrols');			
			if( controls.length > 0 ){
				controls.find('span.cbp-bipause').on( 'click', function(){
					var control = $( this );
					if( control.hasClass( 'cbp-biplay' ) ) {
						control.removeClass( 'cbp-biplay' ).addClass( 'cbp-bipause' );
						that._start();
					}
					else {
						control.removeClass( 'cbp-bipause' ).addClass( 'cbp-biplay' );
						that._stop();
					}
				});				
				var prev = controls.find('span.cbp-biprev').on('click', function(){
					that._navigate( 'prev' ); 
					if( that.active ) { 
						that._start();
					} 
				});
				
				var next = controls.find('span.cbp-binext').on('click', function(){
					that._navigate( 'next' ); 
					if( that.active ) { 
						that._start();
					}
				});
			}	
		},
		_dataSource: function() {
			var that = this ;
			// returns the datasource OR creates one if using array or configuration object
			if( typeof that.options.dataSource === 'object')
				that.dataSource = kendo.data.DataSource.create(that.options.dataSource);
			else 
				that.dataSource = common.api.streams.dataSource ;			
			that.dataSource.bind(CHANGE, function() {
				that.refresh();
			});					
			if (that.options.autoBind) {    
				that.dataSource.fetch();
			}
		},
		current: 0,
		active: false,
		refresh: function () {
			var that = this ;
			var view = that.dataSource.view();			
			var slideshow = that.element.children('.cbp-bislideshow');
			slideshow.html( kendo.render(ITEM_TEMPLATE, view ) );					
			that.items = slideshow.find('li');			
			slideshow.imagesLoaded(
				function(){
					if( Modernizr.backgroundsize ) {
						that.items.each( function(){
							 var item = $( this );
							 item.css( 'background-image', 'url(' + item.find( 'img' ).attr( 'src' ) + ')' );						
						} );	
					}else{
						slideshow.find( 'img' ).show();
					}
					that.items.eq( that.current  ).css( 'opacity', 1 );
				}
			);
		},		
		_navigate : function( direction ) {
			// current item
			var that = this;	
			var oldItem = that.items.eq( that.current );			
			if( direction === 'next' ) {
				that.current = that.current < that.items.length - 1 ? ++that.current : 0;
			}
			else if( direction === 'prev' ) {
				that.current = that.current > 0 ? --that.current : that.items.length - 1;
			}
			// new item
			var newItem = that.items.eq( that.current  );
			// show / hide items
			oldItem.css( 'opacity', 0 );
			newItem.css( 'opacity', 1 );
		},
		_start : function () {
			var that = this;
			var options = that.options ;				
			that.active = true;
			clearTimeout( options.slideshowtime );
			options.slideshowtime = setTimeout( function() {
				that._navigate( 'next' );
				that._start();
			}, options.interval );
		},
		_stop : function () {
			var that = this;
			var options = that.options ;				
			that.active = false;
			clearTimeout( options.slideshowtime );
		},
		destroy: function() {
			var that = this;
			Widget.fn.destroy.call(that);			
			$(that.element).remove();
		}	
	});
	
	$.fn.extend( { 
		extFullscreenSlideshow : function ( options ) {
			return new common.ui.extFullscreenSlideshow ( this , options );		
		}
	});	
})(jQuery);


/**
 *  ExtMediaStreams widget
 */
(function($, undefined) {
	var common = window.common = window.common || {};
	common.ui =  common.ui || {};
    var kendo = window.kendo,
    Widget = kendo.ui.Widget,
    DataSource = kendo.data.DataSource,
    isPlainObject = $.isPlainObject,
    proxy = $.proxy,
    extend = $.extend,
    placeholderSupported = kendo.support.placeholder,
    browser = kendo.support.browser,
    isFunction = kendo.isFunction,
	POST = 'POST',
	JSON = 'json',
    CHANGE = "change",
	UNDEFINED = 'undefined',
	MEDIA_FACEBOOK = "facebook",
	MEDIA_TWITTER = "twitter",
	MEDIA_TUMBLR = "tumblr",
	RENDERED
	handleKendoAjaxError = common.api.handleKendoAjaxError ;
	
    common.ui.extMediaStreamView = Widget.extend({
		init: function(element, options) {			
			var that = this;		 
			Widget.fn.init.call(that, element, options);			
			options = that.options;
			that._dataSource();
		},
		options : {
			name: "ExtMediaStreamView",
			autoBind : true
		},
		id : function () {
			var that = this ;
			var options = that.options ;		
			if( typeof  options.id === UNDEFINED)
				return 0 ;
			else 
				return options.id;
		},
		events : [
		   CHANGE       
		],
		_dataSource: function() {
			var that = this ;
			var options = that.options ;			
			if( typeof that.options.dataSource === 'object'){
				that.dataSource = kendo.data.DataSource.create(that.options.dataSource);
			}else{
				if( typeof options.media === 'string' ){
					var _data = {
						parameterMap	:  function( options,  operation) {
							return {};
						}
					};
					switch(options.media){
						case MEDIA_FACEBOOK :
							_data.url = "/community/get-facebook-homefeed.do?output=json";
							_data.data = "homeFeed";
							_data.template = kendo.template($("#facebook-homefeed-template").html());
							break;
						case MEDIA_TWITTER :
							_data.url = "/community/get-twitter-hometimeline.do?output=json";
							_data.data = "homeTimeline" ;
							_data.template = kendo.template($("#twitter-timeline-template").html());
							break;
						case MEDIA_TUMBLR :
							_data.url = "/community/get-tumblr-dashboard.do?output=json";
							_data.data = "dashboardPosts";
							_data.template = kendo.template($("#tumblr-dashboard-template").html());
							break;
					}
					
					if( typeof options.template === UNDEFINED )
						options.template = _data.template ;
						
					that.dataSource = DataSource.create({
						type: JSON,
						transport: {
							read: {
								type : POST,
								url : _data.url
							},
							parameterMap: _data.parameterMap
						},
						error:handleKendoAjaxError,
						schema: {
							data : _data.data
						},
						requestStart: function() {
							kendo.ui.progress(that.element, true);
						},
						requestEnd: function() {
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
		refresh: function () {
			var that = this ;
			var options = that.options ;			
			var view = that.dataSource.view();			
			that.element.html( kendo.render( options.template, view ) );
			that.trigger(CHANGE); 
		},		
		destroy: function() {
			var that = this;
			Widget.fn.destroy.call(that);			
			$(that.element).remove();
		}	
	});
	
	$.fn.extend( { 
		extMediaStreamView : function ( options ) {
			return new common.ui.extMediaStreamView ( this , options );		
		}
	});	
})(jQuery);
	
/**
 *  Alert widget
 */
(function($, undefined) {
	var common = window.common = window.common || {};
	common.ui =  common.ui || {};
    var kendo = window.kendo,
    Widget = kendo.ui.Widget,
    DataSource = kendo.data.DataSource,
    isPlainObject = $.isPlainObject,
    proxy = $.proxy,
    extend = $.extend,
    placeholderSupported = kendo.support.placeholder,
    browser = kendo.support.browser,
    isFunction = kendo.isFunction,
	POST = 'POST',
	JSON = 'json',
    CHANGE = "change",
    STRING = "string",
	UNDEFINED = 'undefined';
	handleKendoAjaxError = common.api.handleKendoAjaxError ;
	
    common.ui.extAlert = Widget.extend({		
    	init: function(element, options) {			
    		
    			var that = this;
    			Widget.fn.init.call(that, element, options);
    			
    			this.options = that.options;    			
    			if( typeof options.template === UNDEFINED )
    				that.template = kendo.template('<div data-alert class="alert alert-danger">#=message#<a href="\\#" class="close">&times;</a></div>');
    			else if ( typeof options.template === STRING )
    				that.template = kendo.template(options.template);	
    			else if ( isFunction( options.template ) )
    				that.template = options.template;
    			
    			if( typeof options.data === UNDEFINED )
    				options.data = {};    			    			
    			
    			that.element.html( that.template( options.data ) );
    			
    			if( typeof options.data.id === STRING )
    			{	
    				var _alert = $('#' +  options.data.id ).find('.alert');    				
    				_alert.bind('closed.bs.alert', function (e) {
    					e.preventDefault();    					
						if( isFunction(options.close))
							options.close();					
    				});    				
    			}
			
    			that.element.find("[data-alert] a.close").click(
    				function(e){   
    					e.preventDefault();
    					alert('hello');
    					that.element.find("[data-alert]").fadeOut(300, function(){
    						that.element.find("[data-alert]").remove();
    						if( isFunction(options.close))
    							options.close();
    					});				
    				}										
    			);
    			 kendo.notify(that);
    		},
    		options : {
    			name: "ExtAlert"
    		}		
    	}); 	
    	
    	$.fn.extend( { 
    		extAlert : function ( options ) {
    			return new common.ui.extAlert ( this , options );		
    		}
   	});
})(jQuery);
