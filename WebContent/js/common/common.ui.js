/**
 * COMMON UI
 */
(function($, undefined) {
	
	var Widget = kendo.ui.Widget;
	var ui = window.ui = window.ui || {};
	var UNDEFINED = 'undefined', STRING = 'string';

	/** Utility */

	ui.util = {};
	ui.util.prettyDate = function(time) {
		var date = new Date((time || "").replace(/-/g, "/").replace(/[TZ]/g,
				" ")), diff = (((new Date()).getTime() - date.getTime()) / 1000), day_diff = Math
				.floor(diff / 86400);

		if (isNaN(day_diff) || day_diff < 0 || day_diff >= 31)
			return;

		return day_diff == 0
				&& (diff < 60 && "just now" || diff < 120 && "1 minute ago"
						|| diff < 3600 && Math.floor(diff / 60)
						+ " minutes ago" || diff < 7200 && "1 hour ago" || diff < 86400
						&& Math.floor(diff / 3600) + " hours ago")
				|| day_diff == 1 && "Yesterday" || day_diff < 7 && day_diff
				+ " days ago" || day_diff < 31 && Math.ceil(day_diff / 7)
				+ " weeks ago";
	};

})(jQuery);


/**
 * common.ui package define.
 */
(function($, undefined) {
	var common = window.common = window.common || {};
	common.ui = common.ui || {};
	var kendo = window.kendo, 
	Widget = kendo.ui.Widget, 
	each = $.each,
	support = kendo.support,
	browser = support.browser,
	transitions = support.transitions,
	stringify = kendo.stringify, 
	UNDEFINED = 'undefined', 
	proxy = $.proxy, 
	extend = $.extend,
	isFunction = kendo.isFunction,
	DEFAULT_LIGHTBOX_OPTIONS = {
		items:[] ,	
		type:'image',	
		mainClass: 	'mfp-no-margins mfp-with-zoom',
		image: {
			verticalFit: 	true
		},
		gallery: {
			enabled: true,
			navigateByImgClick: true
		}	
	},
	DEFAULT_BXSLIDER_OPTIONS = {
		minSlides: 3,
		maxSlides :	3,
		slideWidth : "100%",
		slideMargin : 	10,
		adaptiveHeight: true
	}
	;

	function defined(x) {
		return (typeof x != UNDEFINED);
	}
		
	common.ui.landing = function (element){		
		if( typeof element === UNDEFINED )
			element ='.page-loader' ;
		
		if( $(element).length == 0 ){
			$('body').prepend("<div class='page-loader' ></div>");
		}		
		 $(element).fadeOut('slow');
	}
	
	common.ui.slider = function( element ){		
		if(!isFunction($.fn.bxSlider)) {
			return false;
		}
		
		if(!defined(element)) {
			element = $(".bxslider");
		}
		
		var options =DEFAULT_BXSLIDER_OPTIONS;		
		if(element.data("plugin-options")) {
			extend(options, eval( "({" +  element.data("plugin-options") + "})" ) );
		}		
		element.bxSlider(options);		
	}
	
	common.ui.backstretch = function (options){				
		if(!defined($.backstretch)) {
			return false;
		}		
		options = options || {} ;
		
		var dataSource = dataSource = common.api.streams.dataSource;
		var template = options.template || kendo.template("/community/view-streams-photo.do?key=#= externalId#")  ;
				
		dataSource.fetch(function(){
			var photos = this.data();
			var urls = [];
			each(photos, function(idx, photo){
				urls.push(template(photo));
			});					
			$.backstretch(
				urls,	
				{duration: 6000, fade: 750}	
			);
		});
	}
	
	common.ui.thumbnailexpanding =  function(){
		var previewHeight = 500,
		marginExpanded = 10,
		template = kendo.template(
			'<div class="og-expander animated slideDown">' +
			'<div class="og-expander-inner">' + 
			'<span class="og-close"></span>' + 
			'<div class="og-fullimg">' +
			'<div class="og-loading" style="display: none;"></div>'+
			'<img src="#= src #" style="display: inline;" class="animated fadeIn" ></div>' + 
			'<div class="og-details">' + 
			'<h3></h3>' + 
			'<p></p>' + 
			'<a href="\\#">Visit website</a>' +
			'</div>' +
			'</div>' +
			'</div>'
		); 
		
		$(document).on("click", "span.og-close", function(e){
			var self = $(this),
			$gallery = self.closest(".og-grid"),
			$items = $gallery.children("li"),
			$previewEl = $gallery.find(".og-expander"),
			$expandedItem = $gallery.children("li.og-expanded");
			onEndFn = function(){
				if( kendo.support.transitions ){
					$(this).off( kendo.support.transitions.event );				
				}
				$items.removeClass( 'og-expanded' );
				$previewEl.remove();
			};
			setTimeout( $.proxy( function() {
				//if( typeof this.$largeImg !== 'undefined' ) {
				//	this.$largeImg.fadeOut( 'fast' );
				//}
				$previewEl.css( 'height', 0 );
				// the current expanded item (might be different from this.$item)
				//var $expandedItem = $items.eq( this.expandedIdx );
				$expandedItem.css( 'height', $expandedItem.data( 'height' ) ).on( kendo.support.transitions.event, onEndFn );

				if( ! kendo.transitions.support.css ) {
					onEndFn.call();
				}
			}, this ), 25);	
		});		
		
		
		$(document).on("click","[data-ride='expanding']", function(e){		
			var $this = $(this);
			var $gallery = $( $this.data("target-gallery") );
			var $items = $gallery.children("li");
			var $parent = $this.parent();			
			
			var data = {
				src : $this.data("largesrc") ,	
				title : $this.data("title"),
				description : $this.data("description")
			};
			
			
			$gallery.children("li.og-expanded").removeClass("og-expanded");
			$parent.addClass( 'og-expanded' );						
						
			var height = $this.height();
			var position = $parent.offset().top;
			
			var preview = $gallery.find(".og-expander");
			if(preview.length === 0){
				$parent.append(template(data));	
				$items.css("height", "");
				preview = $parent.children(".og-expander").css("height", previewHeight )
				$parent.css("height", previewHeight + height + marginExpanded );
				preview.css( 'transition', 'height ' + 350 + 'ms ' + 'ease' );
				$parent.css( 'transition', 'height ' + 350 + 'ms ' + 'ease' );				
			}else if ( ( position + height + marginExpanded ) != preview.offset().top ) {
				preview.slideUp(150, function(){
					preview.remove();
					$parent.append(template(data));	
					$items.css("height", "");
					preview = $parent.children(".og-expander").css("height", previewHeight );					
					$parent.css("height", previewHeight + height + marginExpanded );
				});				
			}else{
				var $loading = preview.find(".og-loading");
				var $largeImg = preview.find("img");				
				$largeImg.hide();				$loading.show();				
				$( '<img/>' ).load( function() {
					var $img = $( this );
					if( $img.attr( 'src' ) === data.src ) {
						$loading.hide();
						$largeImg.attr("src", data.src ).show();
					}
				} ).attr( 'src', data.src );
			}			
			return false;
		});
	}
	
	common.ui.superbox = function(){
		var template = kendo.template(
			'<div class="superbox-show">' +
			'<img src="" class="superbox-current-img">' +
			'<div class="superbox-close" data-dismiss="superbox"><span class="sr-only">Close</span></div>'+
			'</div>'
		); 
		
		var superbox      = $('<div class="superbox-show"></div>');
		var superboximg   = $('<img src="" class="superbox-current-img">');
		var superboxclose = $('<div class="superbox-close" data-dismiss="superbox"><span class="sr-only">Close</span></div>');		
		
		superbox.append(superboximg).append(superboxclose);
		
		
		$(document).on("click","[data-ride='gallery'].superbox-list", function(e){			
			var $this = $(this);
			$this.parent().children(".superbox-list.active").removeClass("active");
			var current = $this.find('img.superbox-img');
			var src = current.data("img");
			superboximg.attr('src', src);
			$this.addClass("active");			
			if ($this.next().hasClass('superbox-show')) {		
				var visible = $this.next().is(":visible");
				$('.superbox-current-img').animate({opacity: (visible?0:1) }, 200, function() {
					superbox.slideToggle({ 
						complete : function(){
							if( visible ){
								$this.removeClass("active");
							}
						}
					});	
				});
			} else {
				superbox.insertAfter(this).css('display', 'block');
			}			
			$('html, body').animate({
				scrollTop:superbox.position().top - current.width()
			}, 'medium');			
		});
		
		$(document).on("click","[data-dismiss='superbox'].superbox-close", function(e){			
			var $this = $(this);					
			$('.superbox-current-img').animate({opacity: 0}, 200, function() {
				$this.parent().slideUp({
					complete : function(){
						$this.parent().parent().children(".superbox-list.active").removeClass("active");
					}
				});				
			});			
		});
	}
	
	common.ui.lightbox = function(){
		if(!defined($.magnificPopup)) {
			return false;
		}
		$(document).on("click","[data-ride='lightbox']", function(e){					
			var $this = $(this), config = {};				
			if($this.data("plugin-options")) {
				config = jQuery.extend({}, DEFAULT_LIGHTBOX_OPTIONS, opts, $this.data("plugin-options"));	
			}else{
				config = DEFAULT_LIGHTBOX_OPTIONS;
			}						
			if( $this.prop("tagName").toLowerCase() == "img" ){				
				config.items = {
					src : $this.attr("src")
				}				
			}else{
				if( $this.children("img").length > 0  ){
					config.items = [];
					$.each( $this.children("img"), function( index,  item){
						config.items.push({
							src : $(item).attr("src")
						});
					});	
				}
			}
			
			$.magnificPopup.open(config);
		} );	
	}
	
	common.ui.PageSetup = kendo.Class.extend({		
		options : {			
			features : {
				culture : true,
				landing : true,
				backstretch : false,
				lightbox: false,
				spmenu: false,
				morphing: false
			},
			worklist: []
		},
		init: function( options) {
			var that = this;
			options = that.options = extend(true, {}, that.options, options);			
			that._initFeatures();
			that._initWorklist();
		}, 
		_initWorklist: function(){
			var that = this;
			var worklist = that.options.worklist;
			
			if (worklist == null) {
				worklist = [];
			}			
			var initilizer, _i, _len, _ref;
			 _ref = worklist;			 
			 for (_i = 0, _len = worklist.length; _i < _len; _i++) {
				 initilizer = _ref[_i];
				 $.proxy(initilizer, that)();
			}				
		},
		_initFeatures: function(){
			var that = this;
			var features = that.options.features;
			var worklist = that.options.worklist;
			
			if( features.culture ){
				common.api.culture();				
			}
			
			if(features.backstretch){
				common.ui.backstretch();
			}
			
			if( features.morphing ){
				$.each( $(".morph-button"), function( index,  item){
					var $this = $(item);
					var btn = new codrops.ui.MorphingButton($this);					
				});
			}
			
			if(features.landing){				
				common.ui.landing();
			}
			
			if(features.spmenu){				
				$(document).on("click","[data-toggle='spmenu']", function(e){
					var $this = $(this);					
					var target ;
					if( $this.prop("tagName").toLowerCase() == "a" ){			
						target  = $this.attr("href");	
					}else{
						if($this.data("target")){
							target = $this.data("target")
						}
					}
					$("body").toggleClass("modal-open");
					$(target).toggleClass("cbp-spmenu-open");
				});
				$(document).on("click","[data-dismiss='spmenu']", function(e){
					var $this = $(this);
					var target  = $this.parent();		
					$("body").toggleClass("modal-open");
					target.toggleClass("cbp-spmenu-open");
				});
			}
			
			if(features.lightbox){				
				common.ui.lightbox();	
			}	
		} 
	})
		
	common.ui.setup = function (options){
		options = options || {};
		var setup = new common.ui.PageSetup(options);
	}
	
	common.ui.hasAttribute = function(input, name) {
		if (input.length)  {
			return input[0].attributes[name] != null;
		}
		return false;
	};
	
	common.ui.switchClass = function( element, remove, add, speed, easing, callback ) {		
		$.effects.animateClass.call( element, {
			add: add,
			remove: remove
		}, speed, easing, callback );		
	}
	
	common.ui.animate = function (renderTo, animate, always){	
		var oldCss = renderTo.attr('class');	
		renderTo.addClass(animate + ' animated' ).one('webkitAnimationEnd mozAnimationEnd MSAnimationEnd oanimationend animationend', function(){			
			if( animate.indexOf("Out") > -1){
				$(this).hide().removeClass(animate + ' animated');
			}else{
				$(this).removeClass(animate + ' animated');
			}
			if(isFunction(always))
				always();			
		});
		return renderTo;		
	}	
	
	common.ui.animate_v2 = function (renderTo, animate, always){	
		var oldCss = renderTo.attr('class');	
		renderTo.addClass(animate + ' animated' ).one('webkitAnimationEnd mozAnimationEnd MSAnimationEnd oanimationend animationend', function(){
			$(this).removeClass();
			$(this).addClass(oldCss);	
			if(isFunction(always))
				always();
		});
		return renderTo;		
	}	

	common.ui.animate_v3 = function (renderTo, animate, always){	
		var oldCss = renderTo.attr('class');	
		renderTo.addClass(animate + ' animated' ).one('webkitAnimationEnd mozAnimationEnd MSAnimationEnd oanimationend animationend', function(){			
			if( animate.indexOf("Out") > -1){
				$(this).hide().removeClass(animate + ' animated');
			}else{
				$(this).show().removeClass(animate + ' animated');
			}
			if(isFunction(always))
				always();			
		});
		return renderTo;		
	}	
	
	common.ui.animateFade= function (renderTo, mode, always){		
		var oldCls = renderTo.attr("class");
		if( $.support.transition ){
			if( oldCls.indexOf("fade") > -1 ){
				renderTo.addClass( mode );
			}else{
				renderTo.addClass('fade ' + mode );
			}			
			 renderTo.one($.support.transition.end, function(){
				if( mode === 'out')
					renderTo.hide();
				else
					renderTo.show();
					
				if( oldCls.indexOf("fade") > -1 ){
					renderTo.removeClass( mode );
				}else{
					renderTo.removeClass('fade ' + mode );
				}					
				if(isFunction(always))
					always();			
			 }).emulateTransitionEnd(150) ;
		}else{
			if( mode === 'out')
				renderTo.hide();
			else
				renderTo.show();
			
			if(isFunction(always))
				always();			
		}
		return renderTo;		
	}
	
	common.ui.animateFadeOut = function (renderTo, always){		  
		common.ui.animateFade(renderTo, 'out', always);
	}
	
	common.ui.animateFadeIn = function (renderTo, always){		  
		common.ui.animateFade(renderTo, 'in', always);
	}	
	
	common.ui.initializeOwlCarousel = function (){
		// Owl Slider v1
		jQuery(document).ready(function() {
			var owl = $(".owl-slider");
			owl.owlCarousel({
				itemsDesktop : [1000,5], // 5 items between 1000px and 901px
				itemsDesktopSmall : [900,4], // 4 items betweem 900px and 601px
				itemsTablet: [600,3], // 3 items between 600 and 0;
				itemsMobile : [479,2] // 2 itemsMobile disabled - inherit from  itemsTablet option
			});
	
			// Custom Navigation Events
			$(".next-v1").click(function(){
				owl.trigger('owl.next');
			})
			$(".prev-v1").click(function(){
				owl.trigger('owl.prev');
			})
		});
		// Owl Slider v2
		jQuery(document).ready(function() {
			var owl = $(".owl-slider-v2");
				owl.owlCarousel({
					itemsDesktop : [1000,5], // 5 items between 1000px and 901px
					temsDesktopSmall : [900,4], // 4 items betweem 900px and 601px
					itemsTablet: [600,3], // 3 items between 600 and 0;
					itemsMobile : [479,2], // 2 itemsMobile disabled - inherit from  itemsTablet option
					slideSpeed: 1000
			 });		
		    // Custom Navigation Events
		    $(".next-v2").click(function(){
		        owl.trigger('owl.next');
		    })
		    $(".prev-v2").click(function(){
		        owl.trigger('owl.prev');
		    })
		});
		
		// Owl Slider v3
		jQuery(document).ready(function() {
	        var owl = $(".owl-slider-v3");
	            owl.owlCarousel({
	            	items : 9,
	            	autoPlay : 5000,
					itemsDesktop : [1000,5], // 5 items between 1000px and 901px
					itemsDesktopSmall : [900,4], // betweem 900px and 601px
					itemsTablet: [600,3], // 2 items between 600 and 0
					itemsMobile : [300,2] // 2 itemsMobile disabled - inherit from itemsTablet option
	            });
		});

		// Owl Slider v4
		jQuery(document).ready(function() {
	        var owl = $(".owl-slider-v4");
	            owl.owlCarousel({
	                items:3,
	                itemsDesktop : [1000,3], // 3 items between 1000px and 901px
	                itemsTablet: [600,2], // 2 items between 600 and 0;
	                itemsMobile : [479,1] // 1 itemsMobile disabled - inherit from itemsTablet option
	            });
		});
	};
	
	common.ui.handleActionEvents = function(selector, options) {
		options = options || {};
		if (options.custom === UNDEFINED)
			options.custom = false;
		if (typeof selector === 'string')
			selector = $(selector);

		if (typeof options.handlers === UNDEFINED) {
			if (typeof options.event === 'string'
					&& isFunction(options.handler)) {
				if (typeof options.selector === UNDEFINED) {
					selector.on(options.event, options.handler);
				} else {
					selector.find(options.selector).on(options.event, options.handler);
				}
			}
		} else if (options.handlers instanceof Array) {
			$.each(options.handlers, function(index, data) {
				selector.find(data.selector).on(data.event, data.handler);
			});
		}
	};

	common.ui.handleButtonActionEvents = function(selector, options) {
		options = options || {};
		if (typeof selector === 'string')
			selector = $(selector);

		selector.each(function(index) {
			var btn_control = $(this);
			var data_action = btn_control.attr("data-action");
			if (typeof options.handlers === 'object') {
				if (isFunction(options.handlers[data_action])) {
					btn_control.bind(options.event,
						options.handlers[data_action]);
				}
			}
		});
	};

	/*
	common.ui.on(selector, handlers ){
		if (typeof selector === 'string')
			selector = $(selector);				
		if( defined(handlers)){
			if (options.handlers instanceof Array){
				
				
			}else{
								
			}
		}		
	}
	*/

	common.ui.notification = function(options) {
		var renderToString = "my-notifications";
		if ($("#" + renderToString).length == 0) {
			$('body').append(	'<span id="' + renderToString + '" style="display:none;"></span>');
		}
		
		if (!$("#" + renderToString).data("kendoNotification")) {
			$("#" + renderToString)	.kendoNotification({
				position : {	pinned : true, top : 10, right : 10 },
				autoHideAfter : 2000,
				stacking : "down",
				templates : [{
					type : "mail",
					template : '<div class="notification-mail"><img src="/images/common/notification/error-info.png" /><h3>#= title #</h3><p><small>#= message #</small></p></div>'
				},
				{
					type : "error",
					template : '<div class="notification-error rounded"><img src="/images/common/notification/error-icon.png" /><h3>#= title #</h3><p>#= message #</p></div>'
				},
				{
					type : "success",
					template : '<div class="notification-success"><img src="/images/common/notification/success-icon.png" /><h3>#= title #</h3><p><small>#= message #</small></p></div>'
				} ]
			});
		}
		
		if( isFunction(options.hide) ){
			$("#" + renderToString).data("kendoNotification").bind("hide", options.hide );			
		}
		
		$("#" + renderToString).data("kendoNotification").show({
			title : options.title,
			autoHideAfter: options.autoHideAfter || 5000,
			message : options.message,
		}, options.type || "error");
	};
})(jQuery);



/**
 * extAccounts widget
 */
(function($, undefined) {
	var common = window.common = window.common || {};
	common.ui = common.ui || {};
	var kendo = window.kendo, 
	Widget = kendo.ui.Widget, 
	isPlainObject = $.isPlainObject, 
	proxy = $.proxy, 
	extend = $.extend, 
	placeholderSupported = kendo.support.placeholder, 
	browser = kendo.support.browser, 
	isFunction = kendo.isFunction, 
	UNDEFINED = 'undefined',	
	AUTHENTICATE = "authenticate",
	SHOWN = "shown", 
	ROLE_ADMIN = "ROLE_ADMIN", 
	ROLE_SYSTEM = "ROLE_SYSTEM", 	
	LOGIN_URL = "/login",
	CALLBACK_URL_TEMPLATE = kendo.template("#if ( typeof( externalLoginHost ) == 'string'  ) { #http://#= externalLoginHost ## } #/community/connect-socialnetwork.do?media=#= media #&domainName=#= domain #"), 
	AUTHENTICATE_URL = "/accounts/get-user.do?output=json",	
	handleKendoAjaxError = common.api.handleKendoAjaxError;	
	common.ui.ExtAccounts = Widget.extend({
		init : function(element, options) {
			var that = this;
			Widget.fn.init.call(that, element, options);
			options = that.options;
			that.token = new User();		
			that.authenticate();
		},
		options : {
			name : "ExtAccounts",
			messages : {
				title : "로그인",
				loginFail : "입력한 사용자 이름 또는 비밀번호가 잘못되었습니다.",
				loginError : "잘못된 접근입니다."			
			}
		},
		events : [ AUTHENTICATE, SHOWN ],
		refresh : function( ){
			var that = this;	
			var renderTo = $(that.element);			
			if( that.options.template){
				
				renderTo.html(that.options.template(that.token));
								
				if (that.token.anonymous) {	
					renderTo.find(	"button.btn-external-login-control-group").click( function (e){
						var target_media = $(this)	.attr("data-target");
						var target_url = CALLBACK_URL_TEMPLATE({
							externalLoginHost : that.options.externalLoginHost || document.domain ,
							media : target_media,
							domain : document.domain
						});
						window.open(target_url, 'popUpWindow', 'height=500, width=600, left=10, top=10, resizable=yes, scrollbars=yes, toolbar=yes, menubar=no, location=no, directories=no, status=yes');
					});
					
					var login_form =  renderTo.find('form[name="login-form"]') ;	
					var login_status = renderTo.find('.login-form-message');
					
					if( login_form.length > 0 ){
						var validator = login_form.kendoValidator({validateOnBlur:false}).data("kendoValidator");
						renderTo.find('button.btn-internal-login-control-group').click(function(e){							
							var login_button = $(this);							
							if( validator.validate() ){
								login_button.button('loading');
								login_status.html("");
								that._login({
									data: login_form.serialize(),
									success : function( response ) {
										location.reload();										
										//var refererUrl = "/main.do";
										//if( response.item.referer ){
										//	refererUrl = response.item.referer;
										//}
										//$("form[name='login-form']")[0].reset();    
										//$("form[name='login-form']").attr("action", refererUrl ).submit();						
									},
									fail : function( response ) {  										
										login_form.find('input[name="password"]').val("").focus();	
										common.ui.notification({ title:that.options.messages.title, message: that.options.messages.loginFail , type: "error" });
										/*
										login_status.extAlert({
											data : { message: that.options.messages.loginFail },
											close : function(e){
												login_form.find('input[name="password"]').focus();										
											}
										}); 										
										*/
									},		
									error : function( thrownError ) {
										login_form[0].reset();
										login_status.extAlert({ data : { message: that.options.messages.loginError } }); 									
									},
									always : function(){
										login_button.button('reset');
									}
								});
							}	
						});
					}
				
				}else{					
					// aside menu event...
					var aside= renderTo.find('.navbar-toggle-aside-menu');					
					if( aside.length > 0 ){						
						var target = aside.attr("href");						
						if($(target).length == 0 )
						{
							var template = kendo.template($("#account-sidebar-template").html());
							$("body").append(  template(that.token) );
							/*$(".header > .navbar:first").append( template(that.token) );*/
							
						}						
						$( target + ' button.btn-close:first').click(function(e){
							$("body").toggleClass("aside-menu-in");
						});						
						aside.click(function(e){
							$("body").toggleClass("aside-menu-in");
							return false;							
						});					
					}					
					if( $('.navbar-header .navbar-toggle-account').length > 0 ){
						$('.navbar-header .navbar-toggle-account').click(function(e){
							$("body").toggleClass("aside-menu-in");
							return false;							
						});
					}					
				}
				that.trigger(SHOWN);
			}	
		},
		_login : function(options) {
			// Force options to be an object
			options = options || {};
			$.ajax({
				type : 'POST',
				url : options.url || LOGIN_URL,
				data : options.data || {},
				success : function(response) {
					if (response.error) {
						if( isFunction(options.fail) )
							options.fail(response);
					} else {
						if(isFunction(options.success))
							options.success(response);
					}
				},
				error : options.error || handleKendoAjaxError,
				dataType : "json"
			}).always( function () {
				if( isFunction( options.always ))
					options.always( ) ;					
			});
		},	
		authenticate : function() {
			var that = this;
			$.ajax({
				type : 'POST',
				url : that.options.url || AUTHENTICATE_URL,
				success : function(response) {
					var token = new User($.extend( response.currentUser, { roles : response.roles }));
					token.set('isSystem', false);
					if (token.hasRole(ROLE_SYSTEM) || token.hasRole(ROLE_ADMIN))
						token.set('isSystem', true);					
					token.copy(that.token);					
					that.trigger(AUTHENTICATE,{ token : that.token });		
					that.refresh();
				},
				error : that.options.error || handleKendoAjaxError,
				dataType : "json"
			});			
		}
	});
	
	$.fn.extend({
		extAccounts : function(options) {
			return new common.ui.ExtAccounts(this, options);
		}
	});
})(jQuery);


/**
 * 
 * Extended Accounts widget
 */
(function($, undefined) {
	var Widget = kendo.ui.Widget, ui = window.ui = window.ui || {};
	var proxy = $.proxy, template = kendo.template, stringify = kendo.stringify, isFunction = kendo.isFunction, AUTHENTICATE_URL = "/accounts/get-user.do?output=json", AUTHENTICATE = "authenticate", LOGIN_URL = "/login",
	CALLBACK_URL_TEMPLATE = kendo.template("#if ( typeof( connectorHostname ) == 'string'  ) { #http://#= connectorHostname ## } #/community/connect-socialnetwork.do?media=#= media #&domainName=#= domain #"), 
	ERROR = "error", 
	SHOWN = "shown", 
	UPDATE = "update", 
	ROLE_ADMIN = "ROLE_ADMIN", 
	ROLE_SYSTEM = "ROLE_SYSTEM", 
	NS = ".kendoAccounts", 
	open = false, 
	DISABLED = "disabled";
	
	ui.kendoAccounts = Widget.extend({
				init : function(element, options) {
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
					doAuthenticate : true,
					visible : true,
					ajax : {
						url : AUTHENTICATE_URL
					},
					template : null,
					dropdown : true,
					connectorHostname : null,
				},
				events : [ AUTHENTICATE, ERROR, UPDATE, SHOWN ],
				authenticate : function() {
					var that = this;
					$.ajax({
						type : 'POST',
						url : that.options.ajax.url,
						success : function(response) {
							user = new User($.extend(response.currentUser, {
								roles : response.roles
							}));
							user.set('isSystem', false);
									if (user.hasRole(ROLE_SYSTEM))
										user.set('isSystem', true);
									if (user.hasRole(ROLE_ADMIN))
										user.set('isSystem', true);

									$(that.element).data("currentUser", user);
									that.token = user;
									that.trigger(AUTHENTICATE, {
										token : user
									});
									if (that.options.visible) {
										that.render();
									}
									if (that.token.anonymous) {
										$(that.element).find(".custom-external-login-groups button").each(
											function(index) {
												var external_login_button = $(this);
												external_login_button.click(function(e) {
													var target_media = external_login_button.attr("data-target");
													var target_url = CALLBACK_URL_TEMPLATE({
														connectorHostname : that.options.connectorHostname,
														media : target_media,
														domain : document.domain
													});
													window.open(
																						target_url,
																						'popUpWindow',
																						'height=500, width=600, left=10, top=10, resizable=yes, scrollbars=yes, toolbar=yes, menubar=no, location=no, directories=no, status=yes');
													});
											});
									}
									if (isFunction(that.options.afterAuthenticate)) {
										that.options.afterAuthenticate();
									}
								},
								error : that.options.ajax.error
										|| handleKendoAjaxError,
								dataType : "json"
							});
				},
				login : function(url, options) {
					if (typeof url === "object") {
						options = url;
						url = undefined;
					}
					// Force options to be an object
					options = options || {};
					$.ajax({
						type : 'POST',
						url : options.url || LOGIN_URL,
						data : options.data || {},
						success : function(response) {
							if (response.error) {
								options.fail(response);
							} else {
								options.success(response);
							}
						},
						error : options.error || handleKendoAjaxError,
						dataType : "json"
					});
				},
				render : function() {
					var that = this, element, content;
					if (that.options.template) {
						that.element.html(that.options.template(that.token));
					}
					if (that.options.dropdown) {
						$(that.element).on('click.fndtn.dropdown',
								'[data-dropdown]', function(e) {
									e.preventDefault();
									e.stopPropagation();
									that.toggle($(this));
								});
						$('[data-dropdown-content]').on('click.fndtn.dropdown',
								function(e) {
									e.stopPropagation();
								});
					}
					that.trigger(SHOWN);
				},
				toggle : function(target) {
					var dropdown = $('#' + target.data('dropdown'));
					if (target.hasClass("dropped")) {
						target.removeClass("dropped");
						dropdown.css("display", "none");
						open = false;
					} else {
						target.addClass("dropped");
						dropdown.css("display", "block");
						open = true;
					}
				},
				destroy : function() {
					var that = this;
					Widget.fn.destroy.call(that);
					that.element.off(NS);
					open = false;
				},
				token : new User({})
			});

	$.fn.extend({
		kendoAccounts : function(options) {
			return new ui.kendoAccounts(this, options);
		}
	});
})(jQuery);

/**
 * extSlideshow widget
 */
(function($, undefined) {
	var kendo = window.kendo, Widget = kendo.ui.Widget, proxy = $.proxy, ui = window.ui = window.ui
			|| {};

	ui.extSlideshow = Widget
			.extend({
				init : function(element, options) {
					var that = this;
					Widget.fn.init.call(that, element, options);
					that.wrapper = that.element;
					options = that.options, slideshow = $(that.element);

					options.items = slideshow.find('li');
					options.itemsCount = options.items.length;

					slideshow.imagesLoaded(function() {
						if (Modernizr.backgroundsize) {
							options.items.each(function() {
								var item = $(this);
								item.css('background-image', 'url('
										+ item.find('img').attr('src') + ')');
							});
						} else {
							slideshow.find('img').show();
						}
						options.items.eq(options.current).css('opacity', 1);
						that._initEvents();
						that._start();
					});
				},
				options : {
					name : "Slideshow",
					current : 0,
					slideshowtime : 0,
					slideshowActive : true,
					interval : 6000,
					items : [],
					itemsCount : 0
				},
				_navigate : function(direction) {
					// current item
					var that = this;
					var options = that.options;
					var oldItem = options.items.eq(options.current);
					if (direction === 'next') {
						options.current = options.current < options.itemsCount - 1 ? ++options.current
								: 0;
					} else if (direction === 'prev') {
						options.current = options.current > 0 ? --options.current
								: options.itemsCount - 1;
					}
					// new item
					var newItem = options.items.eq(options.current);
					// show / hide items
					oldItem.css('opacity', 0);
					newItem.css('opacity', 1);
				},
				_start : function() {
					var that = this;
					var options = that.options;
					options.slideshowActive = true;
					clearTimeout(options.slideshowtime);
					options.slideshowtime = setTimeout(function() {
						that._navigate('next');
						that._start();
					}, options.interval);
				},
				_stop : function() {
					var that = this;
					var options = that.options;
					options.slideshowActive = false;
					clearTimeout(options.slideshowtime);
				},
				_initEvents : function() {
					var that = this;
					var options = that.options;
					var navigation = options.navigation;

					if (typeof navigation === 'object') {
						navigation.find('span.cbp-bipause').on(
								'click',
								function() {
									var control = $(this);
									if (control.hasClass('cbp-biplay')) {
										control.removeClass('cbp-biplay')
												.addClass('cbp-bipause');
										that._start();
									} else {
										control.removeClass('cbp-bipause')
												.addClass('cbp-biplay');
										that._stop();
									}
								});

						var prev = navigation.find('span.cbp-biprev').on(
								'click', function() {
									that._navigate('prev');
									if (options.slideshowActive) {
										that._start();
									}
								});

						var next = navigation.find('span.cbp-binext').on(
								'click', function() {
									that._navigate('next');
									if (options.slideshowActive) {
										that._start();
									}
								});
					}
				}
			});

	$.fn.extend({
		extSlideshow : function(options) {
			return new ui.extSlideshow(this, options);
		}
	});

})(jQuery);

/**
 * extModalWindow widget
 */
(function($, undefined) {
	var common = window.common = window.common || {};
	common.ui = common.ui || {};
	var kendo = window.kendo, Widget = kendo.ui.Widget, 
	isPlainObject = $.isPlainObject, proxy = $.proxy, extend = $.extend, placeholderSupported = kendo.support.placeholder, browser = kendo.support.browser, isFunction = kendo.isFunction, 
	trimSlashesRegExp = /(^\/|\/$)/g, CHANGE = "change", ERROR = "error", REFRESH = "refresh", OPEN = "open", CLOSE = "close", CLICK = "click", 
	UNDEFINED = 'undefined', POST = 'POST', 
	JSON = 'json', 
	handleKendoAjaxError = common.api.handleKendoAjaxError;

	common.ui.extModalWindow = Widget.extend({
				init : function(element, options) {
					var that = this;
					Widget.fn.init.call(that, element, options);
					options = that.options;
					that.refresh();
				},
				events : [ ERROR, CHANGE, CLICK, OPEN, REFRESH, CLOSE ],
				options : {
					name : "ExtModalWindow",
				},
				open : function() {
					var that = this;
					if (typeof that.options.backdrop === 'string') {
						that._modal().modal({
							backdrop : that.options.backdrop,
							show : true
						});
					} else {
						that._modal().modal('show');
					}
				},
				close : function() {
					var that = this;
					that._modal().modal('hide');
				},
				refresh : function() {
					var that = this;
					that._createDialog();
				},
				destroy : function() {
					var that = this;
					Widget.fn.destroy.call(that);
					$(that.element).remove();
				},
				data : function( data ){
					var that = this;
					if( typeof data === UNDEFINED ){
						return that.options.data;
					}else{						
						that.options.data = data;
					}
				},				
				_modal : function() {
					var that = this;
					return that.element.children('.modal');
				},
				_changeState : function(enabled) {
					var that = this;
					if (enabled) {
						that.element.find('.modal-footer .btn.custom-update').removeAttr('disabled');
					} else {
						that.element.find('.modal-footer .btn.custom-update').attr('disabled', 'disabled');
					}
				},
				_createDialog : function() {
					var that = this;
					var template = that._dialogTemplate();
					that.element.html(template({
						title : that.options.title || ""
					}));
					if (typeof that.options.data === 'object') {
						kendo.bind(that._modal(), that.options.data);
						if (that.options.data instanceof kendo.data.ObservableObject) {
							that.options.data.bind("change", function(e) {
								that.trigger(CHANGE, {
									field : e.field,
									element : that._modal()[0],
									data : that.options.data
								});
							});
						}
					}
					that._modal().css('z-index', '2000');
					that.element.find('.modal').on('show.bs.modal', function(e) {
						that.trigger(OPEN, {
							element : that._modal()[0],
							target: that
						});
					});
					that.element.find('.modal').on('hide.bs.modal', function(e) {
						that.trigger(CLOSE, {
							element : that._modal()[0]
						});
					});

					that.trigger(REFRESH, {
						element : that._modal()[0]
					});
				},
				_dialogTemplate : function() {
					var that = this;
					
					if (typeof that.options.template === UNDEFINED) {
						return kendo
								.template("<div class='modal editor-popup fade' tabindex='-1' role='dialog' aria-hidden='true'>"
										+ "<div class='modal-dialog modal-lg'>"
										+ "<div class='modal-content'>"
										+ "<div class='modal-header'>"
										+ "<button type='button' class='close' data-dismiss='modal' aria-hidden='true'>&times;</button>"
										+ "<h5 class='modal-title'>#= title #</h5>"
										+ "</div>"
										+ "<div class='modal-body'>"
										+ "</div>"
										+ "<div class='modal-footer'>"
										+ "</div>"
										+ "</div><!-- /.modal-content -->"
										+ "</div><!-- /.modal-dialog -->"
										+ "</div><!-- /.modal -->");
					} else if (isFunction( that.options.template )) {
						return that.options.template;
					} else if (typeof that.options.template === 'string') {
						return kendo.template(that.options.template);
					}
				}
			});

	common.ui.modal = function (options){
		options = options || {};	
		if( typeof options.renderTo === "string" ){
			if( $("#"+options.renderTo).length === 0 ){
				$('body').append("<section id='"+ options.renderTo  +"'></section>");
			}
			if( !$("#"+options.renderTo).data("kendoExtModalWindow") ){
				return new common.ui.extModalWindow($("#"+options.renderTo), options);
			}else{
				return $("#"+options.renderTo).data("kendoExtModalWindow");
			}
		}
	} 
	
	$.fn.extend({
		extModalWindow : function(options) {
			return new common.ui.extModalWindow(this, options);
		}
	});
})(jQuery);

/**
 * extEditorPopup widget
 */
(function($, undefined) {
	var common = window.common = window.common || {};
	common.ui = common.ui || {};
	var kendo = window.kendo, Widget = kendo.ui.Widget, isPlainObject = $.isPlainObject, proxy = $.proxy, extend = $.extend, placeholderSupported = kendo.support.placeholder, browser = kendo.support.browser, isFunction = kendo.isFunction, trimSlashesRegExp = /(^\/|\/$)/g, CHANGE = "change", APPLY = "apply", ERROR = "error", CLICK = "click", UNDEFINED = 'undefined', POST = 'POST', JSON = 'json', LINK_VALUE_TEMPLATE = kendo
			.template('<a href="#: linkUrl #" title="#: linkTitle #" #if (linkTarget) { # target="_blank"  # }#>#= linkTitle #</a>'), handleKendoAjaxError = common.api.handleKendoAjaxError;

	common.ui.extEditorPopup = Widget
			.extend({
				init : function(element, options) {
					var that = this;
					Widget.fn.init.call(that, element, options);
					options = that.options;
					that.refresh();
				},
				events : [ ERROR, CHANGE, APPLY ],
				options : {
					name : "ExtEditorPopup",
					transport : {

					}
				},
				show : function() {
					var that = this;
					that._modal().modal('show');
				},
				close : function() {
					var that = this;
					that._modal().modal('hide');
				},
				refresh : function() {
					var that = this;
					that._createDialog();
				},
				destroy : function() {
					var that = this;
					Widget.fn.destroy.call(that);
					$(that.element).remove();
				},
				data : function() {
					var that = this;
					return that._data;
				},
				_modal : function() {
					var that = this;
					return that.element.children('.modal');
				},
				_changeState : function(enabled) {
					var that = this;
					if (enabled) {
						that.element.find('.modal-footer .btn.custom-update').removeAttr('disabled');
					} else {
						that.element.find('.modal-footer .btn.custom-update').attr('disabled', 'disabled');
					}
				},
				_createDialog : function() {
					var that = this;
					var template = that._dialogTemplate();

					that.element.html(template({
						title : that.options.title || "",
						type : that.options.type
					}));
					if (that.options.type == 'createLink') {
						that._data = kendo.observable({
							linkUrl : "",
							linkTitle : "",
							linkTarget : false
						});
						that._data.bind("change", function(e) {
							if (e.field == 'linkUrl') {
								if (that._data.get(e.field).length > 0)
									that._changeState(true);
								else
									that._changeState(false);
							}
						});
					}
					kendo.bind(that.element, that._data);

					that.element.children('.modal').css('z-index', '2000');
					that.element.find('.modal').on(
							'show.bs.modal',
							function(e) {
								if (that.options.type == 'createLink') {
									that.element.find('input').val('');
									that.element.find('input[type="checkbox"]')
											.removeAttr('checked');
								}
								that._changeState(false);
							});

					that.element.find('.modal-footer .btn.custom-update').click(function() {
								that.trigger(APPLY, {
									html : LINK_VALUE_TEMPLATE(that._data)
								});
							});
				},
				_dialogTemplate : function() {
					var that = this;
					if (typeof that.options.template === UNDEFINED) {
						return kendo.template("<div class='modal editor-popup fade' tabindex='-1' role='dialog' aria-hidden='true'>"
										+ "<div class='modal-dialog modal-sm'>"
										+ "<div class='modal-content'>"
										+ "<div class='modal-header'>"
										+ "<button type='button' class='close' data-dismiss='modal' aria-hidden='true'>&times;</button>"
										+ "<h5 class='modal-title'>#= title #</h5>"
										+ "</div>"
										+ "<div class='modal-body'>"
										+ "</div>"
										+ "<div class='modal-footer'>"
										+ "</div>"
										+ "</div><!-- /.modal-content -->"
										+ "</div><!-- /.modal-dialog -->"
										+ "</div><!-- /.modal -->");
					} else if (typeof that.options.template === 'object') {
						return that.options.template;
					} else if (typeof that.options.template === 'string') {
						return kendo.template(that.options.template);
					}
				}
			});

	$.fn.extend({
		extEditorPopup : function(options) {
			return new common.ui.extEditorPopup(this, options);
		}
	});
})(jQuery);

(function($, undefined) {
	var common = window.common = window.common || {};
	common.ui = common.ui || {};
	var kendo = window.kendo, 
		Widget = kendo.ui.Widget, 
		isPlainObject = $.isPlainObject, 
		proxy = $.proxy, 
		extend = $.extend, 
		template = kendo.template,
		placeholderSupported = kendo.support.placeholder, 
		browser = kendo.support.browser, 
		isFunction = kendo.isFunction, 
		trimSlashesRegExp = /(^\/|\/$)/g, 
		CHANGE = "change", 
		APPLY = "apply", 
		ERROR = "error", 
		CLICK = "click", 
		MODAL_TITIL_ID = "title_guid", TAB_PANE_URL_ID = "url_guid", TAB_PANE_UPLOAD_ID = "upload_guid", TAB_PANE_MY_ID = "my_guid", TAB_PANE_WEBSITE_ID = "website_guid", TAB_PANE_DOMAIN_ID = "domain_guid", 
		UNDEFINED = 'undefined',
		POST = 'POST', 
		JSON = 'json', 
		templates = {
			selected : template(
				'<div class="row">' +
				'<div class="col-xs-4">'+
				'<img src="/community/download-my-domain-image.do?imageId=#=imageId#&width=150&height=150" alt="#=name#" class="img-responsive">' +
				'</div>' +
				'<div class="col-xs-8">' +						
				'<h5><span class="label label-warning label-lightweight">#: contentType #</span> #:name# <small>(#: formattedSize() #)</small></h5>' +
				'<ul class="list-unstyled">' +
				'<li><i class="fa fa-user color-green"></i></li>' +
				'<li><i class="fa fa-calendar color-green"></i> #: formattedCreationDate() #</li>' +
				'<li><i class="fa fa-calendar color-green"></i> #: formattedModifiedDate() #</li>' +
				'<li><i class="fa fa-tags color-green"></i></li>' +
				'</ul>' +
				'</div>' +
				'</div>'					
			),
			image : template('<img src="#: url #" class="img-responsive"/>'),
			url : template('/download/image/#= linkId #'),
			download : template('/download/image/#=imageId#/#=name#')
		},
		handleKendoAjaxError = common.api.handleKendoAjaxError;
		common.ui.extImageBrowser = Widget.extend({
			init : function(element, options) {
				var that = this;
				Widget.fn.init.call(that, element, options);
				options = that.options;
				options.guid = {
					title_guid : common.api.guid().toLowerCase(),
					url_guid : common.api.guid().toLowerCase(),
					upload_guid : common.api.guid().toLowerCase(),
					my_guid : common.api.guid().toLowerCase(),
					domain_guid : common.api.guid().toLowerCase(),
					website_guid : common.api.guid().toLowerCase()
				};
				that.refresh();
			},
			events : [ ERROR, CHANGE, APPLY ],
			options : {
				name : "ExtImageBrowser",
				transport : {}
			},
			show : function() {
				var that = this;
				that._modal().modal('show');
				that.element.find('.modal-body ul.nav a:first').tab('show');
			},
			close : function() {
				var that = this;
				that._modal().modal('hide');
			},
			refresh : function() {
				var that = this;
				that._createDialog();
			},
			destroy : function() {
				var that = this;
				Widget.fn.destroy.call(that);
				$(that.element).remove();
			},
			_getImageLink : function(image, callback) {
				common.api.getImagelink({
					imageId : image.imageId,
					success : function(data) {
						callback(data);
					}
				});
			},
			_modal : function() {
				var that = this;
				return that.element.children('.modal');
			},
			_objectId : function(){
				var that = this;
				if( typeof that.options.data === 'object' ){	
					if( that.options.data instanceof common.models.Page ){
						return that.options.data.pageId ;
					}
				}
				return 0;
			},
			_createDialog : function() {
				var that = this;
				var template = that._dialogTemplate();
				that.element.html(template(that.options.guid));				
				that.element.children('.modal').css('z-index', '2000');
				that.element.find('.modal-body a[data-toggle="tab"]').on('shown.bs.tab', function(e) {
					e.target // activated tab
					e.relatedTarget // previous tab
					that._changeState(false);
					var tab_pane_id = $(e.target).attr('href');
					var tab_pane = $(tab_pane_id);
					var my_selected = $(tab_pane_id + "-selected");
					var my_list_view = $(tab_pane_id + "-list-view");
					var my_list_pager = $(tab_pane_id + "-list-pager");						
					switch (tab_pane_id) {
						case "#" + that.options.guid[TAB_PANE_UPLOAD_ID]:					
							if(that._objectId() > 0){							
								// list view 
								if (!my_list_view.data('kendoListView')) {
									my_list_view.kendoListView({
										dataSource : {
											type : 'json',
											transport : {
												read : {
													url : '/community/list-my-page-image.do?output=json',
													type : 'POST'
												},
												parameterMap : function(options, operation) {
													if (operation != "read" && options) {
														return {
															pageId : options.pageId || that._objectId()
														};
													} else {
														return {
															startIndex : options.skip,
															pageSize : options.pageSize,
															pageId : options.pageId || that._objectId()
														}
													}
												}
											},
											pageSize : 12,
											error : handleKendoAjaxError,
											schema : {
												model : Image,
												data : "targetImages",
												total : "totalTargetImageCount"
											},
											serverPaging : true
										},
										selectable : "single",
										change : function(e) {
											tab_pane.find(	'.panel-body.custom-selected-image').remove();
											var data = this.dataSource.view();
											var current_index = this.select().index();
											if (current_index >= 0) {
												var item = data[current_index];
												var imageId = item.imageId;
												if (imageId > 0) {
													that._changeState(true);
													tab_pane.find('.panel').prepend(templates.selected(item));													
												}
											}
										},
										navigatable : false,
										template : kendo.template($("#photo-list-view-template").html()),
										dataBound : function(e) {
											tab_pane.find('.panel-body.custom-selected-image').remove();
											that._changeState(false);
										}
									});
									my_list_view.on("mouseenter",".img-wrapper", function(e) {
										kendo.fx($(e.currentTarget).find(".img-description")).expand("vertical").stop().play();
									}).on("mouseleave", ".img-wrapper", function(e) {
										kendo.fx($(e.currentTarget).find(".img-description")).expand("vertical").stop().reverse();
									});
									my_list_pager.kendoPager({
										refresh : true,
										buttonCount : 5,
										dataSource : my_list_view.data('kendoListView').dataSource
									});
								}								
								my_list_view.data('kendoListView').dataSource.read({pageId: that._objectId() });								
							}else{
								
							}							
							break;
						case "#" + that.options.guid[TAB_PANE_DOMAIN_ID]:
							// domain images
							if (!my_list_view.data('kendoListView')) {
												my_list_view.kendoListView({
															dataSource : {
																type : 'json',
																transport : {
																	read : {
																		url : '/community/list-my-domain-image.do?output=json',
																		type : 'POST'
																	},
																	parameterMap : function(
																			options,
																			operation) {
																		if (operation != "read" && options) {
																			return {};
																		} else {
																			return {
																				startIndex : options.skip,
																				pageSize : options.pageSize
																			}
																		}
																	}
																},
																pageSize : 12,
																error : handleKendoAjaxError,
																schema : {
																	model : Image,
																	data : "targetImages",
																	total : "totalTargetImageCount"
																},
																serverPaging : true
															},
															selectable : "single",
															change : function(e) {
																var data = this.dataSource.view();
																var current_index = this.select().index();
																if (current_index >= 0) {
																	var item = data[current_index];
																	var imageId = item.imageId;
																	if (imageId > 0) {
																		that._getImageLink(item,
																			function(data) {
																				if (typeof data.imageLink === 'object') {
																					my_list_view.data("linkId",data.imageLink.linkId);
																					that._changeState(true);
																					my_selected.html(templates.selected(item));
																				}
																		});
																	}
																}
															},
															navigatable : false,
															template : kendo.template($("#photo-list-view-template").html()),
															dataBound : function(e) {
																my_selected.html('');
																that._changeState(false);
															}
														});
												my_list_view.on(
																"mouseenter",
																".img-wrapper",
																function(e) {
																	kendo.fx($(e.currentTarget).find(".img-description")).expand("vertical").stop().play();
																})
														.on(
																"mouseleave",
																".img-wrapper",
																function(e) {
																	kendo.fx($(e.currentTarget).find(".img-description")).expand("vertical").stop().reverse();
																});
												my_list_pager
														.kendoPager({
															refresh : true,
															buttonCount : 5,
															dataSource : my_list_view
																	.data('kendoListView').dataSource
														});
											} else {
												my_list_view.data(
														'kendoListView')
														.clearSelection();
							}
							break;
						case "#" + that.options.guid[TAB_PANE_WEBSITE_ID]:
							// website images
							if (!my_list_view.data('kendoListView')) {
								my_list_view.kendoListView({
									dataSource : {
										type : 'json',
										transport : {
											read : {
												url : '/community/list-my-website-image.do?output=json',
												type : 'POST'
											},
											parameterMap : function(options, operation) {
												if (operation != "read" && options) {
													return {};
												} else {
													return {
														startIndex : options.skip,
														pageSize : options.pageSize
													}
												}
											}
										},
										pageSize : 12,
										error : handleKendoAjaxError,
										schema : {
											model : Image,
											data : "targetImages",
											total : "totalTargetImageCount"
										},
										serverPaging : true
									},
									selectable : "single",
									change : function(e) {
										var data = this.dataSource.view();
										var current_index = this.select().index();
										if (current_index >= 0) {
											var item = data[current_index];
											var imageId = item.imageId;
											if (imageId > 0) {
												that._getImageLink(item, function(data) {
													if (typeof data.imageLink === 'object') {
														my_list_view.data("linkId", data.imageLink.linkId);
														that._changeState(true);
														my_selected.html(templates.selected(item));
													}
												});
											}
										}
									},
									navigatable : false,
									template : kendo.template($("#photo-list-view-template").html()),
									dataBound : function(e) {
										my_selected.html("");
										that._changeState(false);
									}
								});
								my_list_view.on("mouseenter",".img-wrapper", function(e) {
									kendo.fx($(e.currentTarget).find(".img-description")).expand("vertical").stop().play();
								}).on("mouseleave", ".img-wrapper",function(e) {
									kendo.fx($(e.currentTarget).find(".img-description")).expand("vertical").stop().reverse();
								});												
								my_list_pager.kendoPager({
									refresh : true,
									buttonCount : 5,
									dataSource : my_list_view.data('kendoListView').dataSource
								});
							} else {
								my_list_view.data('kendoListView').clearSelection();
							}
							break;
						case "#"+ that.options.guid[TAB_PANE_MY_ID]:
							if (!my_list_view.data('kendoListView')) {
								my_list_view.kendoListView({
									dataSource : {
										type : 'json',
										transport : {
											read : {
												url : '/community/list-my-image.do?output=json',
												type : 'POST'
											},
											parameterMap : function(options,operation) {
												if (operation != "read"&& options) {
													return {};
												} else {
													return {
														startIndex : options.skip,
														pageSize : options.pageSize
													}
												}
											}
										},
										pageSize : 12,
										error : handleKendoAjaxError,
										schema : {
											model : Image,
											data : "targetImages",
											total : "totalTargetImageCount"
										},
										serverPaging : true
									},
									selectable : "single",
									change : function(e) {
										var data = this.dataSource.view();
										var current_index = this.select().index();
										if (current_index >= 0) {
											var item = data[current_index];
											var imageId = item.imageId;
											if (imageId > 0) {
												that._getImageLink(item,function(data) {
												if (typeof data.imageLink === 'object') {
													my_list_view.data("linkId",data.imageLink.linkId);
													that._changeState(true);
													my_selected.html(templates.selected(item));
												}
											});
										}
									}
								},
								navigatable : false,
									template : kendo.template($("#photo-list-view-template").html()),
									dataBound : function(e) {
										my_selected.html("");
										that._changeState(false);
									}
								});
								my_list_view.on("mouseenter",".img-wrapper",function(e) {
									kendo.fx($(e.currentTarget).find(".img-description")).expand("vertical").stop().play();
								}).on("mouseleave",".img-wrapper",function(e) {
									kendo.fx($(e.currentTarget).find(".img-description")).expand("vertical").stop().reverse();
								});
								my_list_pager.kendoPager({
									refresh : true,
									buttonCount : 5,
									dataSource : my_list_view.data('kendoListView').dataSource
								});
							} else {
								my_list_view.data('kendoListView').clearSelection();
							}
							break;
						case "#" + that.options.guid[TAB_PANE_URL_ID]:
											var form_input = that.element.find('.modal-body input[name="custom-selected-url"]');
											var selected_img = $("#" + that.options.guid[TAB_PANE_URL_ID]).children('img');
											form_input.val("");
											if (form_input.parent().hasClass('has-error'))
												form_input.parent().removeClass('has-error');
											if (form_input.parent().hasClass('has-success'))
												form_input.parent().removeClass('has-success');
											if (!selected_img.hasClass('hide'))
												selected_img.addClass('hide');
											break;
										}
				}); //end of tabs
				
				// handle select image url 
				that.element.find('.modal-body input[name="custom-selected-url"]').on(
									'change',
									function() {
										var form_input = $(this);
										var selected_img = $("#"+ that.options.guid[TAB_PANE_URL_ID]).children('img');
										if (form_input.val().length == 0) {
											if (!selected_img.hasClass('hide'))
												selected_img.addClass('hide');
											if (form_input.parent().hasClass('has-error'))
												form_input.parent().removeClass('has-error');
											if (form_input.parent().hasClass('has-success'))
												form_input.parent().removeClass('has-success');
											that._changeState(false);
										} else {
											selected_img.attr('src',form_input.val()).load(
															function() {
																if (form_input.parent().hasClass('has-error'))
																	form_input.parent().removeClass('has-error');
																form_input.parent().addClass('has-success');
																selected_img.removeClass('hide');
																that._changeState(true);
															}).error(
															function() {
																if (!selected_img.hasClass('hide'))
																	selected_img.addClass('hide');
																if (form_input.parent().hasClass('has-success'))
																	form_input.parent().removeClass('has-success');
																form_input.parent().addClass('has-error');
																that._changeState(false);
															});
										}
				});

				// handle insert 		
				that.element.find('.modal-footer .btn.custom-insert-img').on('click', function() {						
					var tab_pane = that._activePane();
					var tab_pane_id	= tab_pane.attr('id');
					var selected_url = '';					
					switch (tab_pane_id) {
						case that.options.guid[TAB_PANE_URL_ID]:
							selected_url = that.element.find('.modal-body input[name="custom-selected-url"]').val();							
						break;
						default:					
							var active_list_view = $( "#" + tab_pane_id + "-list-view").data('kendoListView');
							var data = active_list_view.dataSource.view();						
							$.each( active_list_view.select(), function(index, item){
								var image = data[$(item).index()];
								// website (public) 
								if( image.objectType === 30 )
								{
									selected_url =  templates.download(image);									
								}else{
									that._getImageLink(image, function(data) {
										if (typeof data.imageLink === 'object') {
											selected_url = templates.url(data.imageLink);
										}
									});								
								}
							});								
					}
					if( selected_url.length > 0){
						that.trigger(APPLY, {
							html : templates.image({
								url : selected_url
							})
						});
					}
				});	
			},
			_activePane : function() {
				var that = this;
				return that.element.find('.tab-content > .tab-pane.active');
			},
			_changeState : function(enabled) {
				var that = this;
				if (enabled) {
					that.element.find(
							'.modal-footer .btn.custom-insert-img')
							.removeAttr('disabled');
				} else {
					that.element.find(
							'.modal-footer .btn.custom-insert-img').attr(
							'disabled', 'disabled');
				}
			},
			_dialogTemplate : function() {
				var that = this;
				if (typeof that.options.template === UNDEFINED) {
					return kendo.template(
						"<div class='modal fade' tabindex='-1' role='dialog' aria-labelledby=#:id# aria-hidden='true'>"	+ 
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
						"</div><!-- /.modal -->");
				} else if (typeof that.options.template === 'object') {
					return that.options.template;
				} else if (typeof that.options.template === 'string') {
					return kendo.template(that.options.template);
				}
			}
	});

	$.fn.extend({
		extImageBrowser : function(options) {
			return new common.ui.extImageBrowser(this, options);
		}
	});
})(jQuery);

/**
 * FullscreenSlideshow widget
 */
(function($, undefined) {
	var common = window.common = window.common || {};
	common.ui = common.ui || {};
	var kendo = window.kendo, Widget = kendo.ui.Widget, isPlainObject = $.isPlainObject, proxy = $.proxy, extend = $.extend, placeholderSupported = kendo.support.placeholder, browser = kendo.support.browser, isFunction = kendo.isFunction, CHANGE = "change", UNDEFINED = 'undefined', TEMPLATE = kendo
			.template('<ul id="cbp-bislideshow" class="cbp-bislideshow"></ul>'
					+ '<div id="cbp-bicontrols" class="cbp-bicontrols">'
					+ '<span class="fa cbp-biprev"></span>'
					+ '<span class="fa cbp-bipause"></span>'
					+ '<span class="fa cbp-binext"></span>' + '</div>'
					+ '</div>'), ITEM_TEMPLATE = kendo
			.template('<li><img src="/community/view-streams-photo.do?key=#= externalId#" alt="이미지"/></li>'), handleKendoAjaxError = common.api.handleKendoAjaxError;

	common.ui.extFullscreenSlideshow = Widget
			.extend({
				init : function(element, options) {
					var that = this;
					Widget.fn.init.call(that, element, options);
					options = that.options;
					that._dataSource();
					that.element.html(TEMPLATE);
					that._initEvents();
				},
				options : {
					name : "ExtFullscreenSlideshow",
					autoBind : true,
					interval : 6000,
					slideshowtime : 0
				},
				_initEvents : function() {
					var that = this;
					var options = that.options;
					var controls = that.element.children('.cbp-bicontrols');
					if (controls.length > 0) {
						controls.find('span.cbp-bipause').on(
								'click',
								function() {
									var control = $(this);
									if (control.hasClass('cbp-biplay')) {
										control.removeClass('cbp-biplay')
												.addClass('cbp-bipause');
										that._start();
									} else {
										control.removeClass('cbp-bipause')
												.addClass('cbp-biplay');
										that._stop();
									}
								});
						var prev = controls.find('span.cbp-biprev').on('click',
								function() {
									that._navigate('prev');
									if (that.active) {
										that._start();
									}
								});

						var next = controls.find('span.cbp-binext').on('click',
								function() {
									that._navigate('next');
									if (that.active) {
										that._start();
									}
								});
					}
				},
				_dataSource : function() {
					var that = this;
					// returns the datasource OR creates one if using array or
					// configuration object
					if (typeof that.options.dataSource === 'object')
						that.dataSource = kendo.data.DataSource
								.create(that.options.dataSource);
					else
						that.dataSource = common.api.streams.dataSource;
					that.dataSource.bind(CHANGE, function() {
						that.refresh();
					});
					if (that.options.autoBind) {
						that.dataSource.fetch();
					}
				},
				current : 0,
				active : false,
				refresh : function() {
					var that = this;
					var view = that.dataSource.view();
					var slideshow = that.element.children('.cbp-bislideshow');
					slideshow.html(kendo.render(ITEM_TEMPLATE, view));
					that.items = slideshow.find('li');
					slideshow.imagesLoaded(function() {
						if (Modernizr.backgroundsize) {
							that.items.each(function() {
								var item = $(this);
								item.css('background-image', 'url('
										+ item.find('img').attr('src') + ')');
							});
						} else {
							slideshow.find('img').show();
						}
						that.items.eq(that.current).css('opacity', 1);
					});
				},
				_navigate : function(direction) {
					// current item
					var that = this;
					var oldItem = that.items.eq(that.current);
					if (direction === 'next') {
						that.current = that.current < that.items.length - 1 ? ++that.current
								: 0;
					} else if (direction === 'prev') {
						that.current = that.current > 0 ? --that.current
								: that.items.length - 1;
					}
					// new item
					var newItem = that.items.eq(that.current);
					// show / hide items
					oldItem.css('opacity', 0);
					newItem.css('opacity', 1);
				},
				_start : function() {
					var that = this;
					var options = that.options;
					that.active = true;
					clearTimeout(options.slideshowtime);
					options.slideshowtime = setTimeout(function() {
						that._navigate('next');
						that._start();
					}, options.interval);
				},
				_stop : function() {
					var that = this;
					var options = that.options;
					that.active = false;
					clearTimeout(options.slideshowtime);
				},
				destroy : function() {
					var that = this;
					Widget.fn.destroy.call(that);
					$(that.element).remove();
				}
			});

	$.fn.extend({
		extFullscreenSlideshow : function(options) {
			return new common.ui.extFullscreenSlideshow(this, options);
		}
	});
})(jQuery);

/**
 * ExtMediaStreams widget
 */
(function($, undefined) {
	var common = window.common = window.common || {};
	common.ui = common.ui || {};
	var kendo = window.kendo, Widget = kendo.ui.Widget, DataSource = kendo.data.DataSource, isPlainObject = $.isPlainObject, proxy = $.proxy, extend = $.extend, placeholderSupported = kendo.support.placeholder, browser = kendo.support.browser, isFunction = kendo.isFunction, POST = 'POST', JSON = 'json', CHANGE = "change", UNDEFINED = 'undefined', MEDIA_FACEBOOK = "facebook", MEDIA_TWITTER = "twitter", MEDIA_TUMBLR = "tumblr", RENDERED
	handleKendoAjaxError = common.api.handleKendoAjaxError;

	common.ui.extMediaStreamView = Widget
			.extend({
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
					if (typeof that.options.dataSource === 'object') {
						that.dataSource = kendo.data.DataSource.create(that.options.dataSource);
					} else {
						if (typeof options.media === 'string') {
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
			return new common.ui.extMediaStreamView(this, options);
		}
	});
})(jQuery);

/**
 * Alert widget
 */
(function($, undefined) {
	var common = window.common = window.common || {};
	common.ui = common.ui || {};
	var kendo = window.kendo, 
	Widget = kendo.ui.Widget, 
	DataSource = kendo.data.DataSource, 
	template = kendo.template,
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
	TEMPLATE = template('<div data-alert class="alert alert-danger animated fadeInDown">#=message#<button type="button" class="close" data-dismiss="alert" aria-hidden="true">×</button></div>'),
	handleKendoAjaxError = common.api.handleKendoAjaxError;
	
	common.ui.alert = function ( options ){		
		options = options || {};	
		if( defined(options.renderTo)){
			 return new common.ui.ExtAlert( $(options.renderTo), options); 
		}else 	if( defined( options.appendTo) ){		
			var guid = common.api.guid().toLowerCase() ;
			$(options.appendTo).append( "<div id='" + guid+ "'></div>");		
			return new common.ui.ExtAlert( $("#" + guid ), options); 
		}		
	}
	
	function defined(x) {
		return (typeof x != UNDEFINED);
	}
	
	common.ui.ExtAlert = Widget.extend({
				init : function(element, options) {
					var that = this;
					Widget.fn.init.call(that, element, options);
					this.options = that.options;					
					that.refresh();	
					kendo.notify(that);
				},
				options : {
					name : "ExtAlert",
					data : {}
				},
				refresh: function(){
					var that = this, options = that.options;
					if (typeof options.template === UNDEFINED)
						that.template = TEMPLATE ;
					else if (typeof options.template === STRING)
						that.template = template(options.template);
					else if (isFunction(options.template))
						that.template = options.template;

					if (typeof options.data === UNDEFINED)
						options.data = {};
					that.element.html(that.template(options.data));
					
				}
			});
	$.fn.extend({
		extAlert : function(options) {
			return new common.ui.ExtAlert(this, options);
		}
	});
})(jQuery);



/**
 * ExtButton Widget
 */
(function ($, undefined) {
	var common = window.common = window.common || {};
	common.ui = common.ui || {};
	var kendo = window.kendo, 
	Widget = kendo.ui.Widget, 
	isFunction = kendo.isFunction,
	proxy = $.proxy,
	keys = kendo.keys,
	UNDEFINED = 'undefined',	
	CLICK = "click",
	CHANGE = "change",
	RADIO = "radio",
	DISABLED = "disabled";

	
	function defined(x) {
		return (typeof x != UNDEFINED);
	}

	common.ui.buttonEnabled = function(element){
		if( element.is(":disabled") ){
			element.prop("disabled", false);
			if( element.is("[data-toggle='button']") ){
				element.toggleClass("active");
			}
		}	
	}
	
	common.ui.buttonDisabled = function(element){
		if( !element.is(":disabled") ){
			element.prop("disabled", true);
			if( element.is("[data-toggle='button']") ){
				element.toggleClass("active");
			}
		}	
	}
	
	common.ui.button = function (options){
		if( defined(options.renderTo) ){
			var renderTo = options.renderTo ;
			if( typeof renderTo === "string" ){	
				renderTo = $(options.renderTo);
			}
			
			if( renderTo.data("dismiss") && renderTo.data("target")  )
			{
				renderTo.click(function(e){
					$this =  $(this);
					var target = $this.data("target");
					if( $(target).length > 0 ){
						if($this.data("animate")){
							$(target).slideUp();
						}else{
							$(target).hide();
						}						
					}		
					var switch_target = $this.data("switch-target");
					if( $(switch_target).length > 0 && $(switch_target).prop("tagName").toLowerCase() == "button"){		
						common.ui.buttonEnabled($(switch_target));
					}
				});				
			}
			if( isFunction(options.click)){
				renderTo.click( options.click );
			}
			return renderTo;
		}
	}
	
	common.ui.buttons = function ( options ){		
		options = options || {};	
		if( defined(options.renderTo) ){
			if($(options.renderTo).data("kendoExtRadioButtons")){
				return	$(options.renderTo).data("kendoExtRadioButtons");
			}else{
				if( options.type === RADIO){
					return new common.ui.ExtRadioButtons( $(options.renderTo), options ); 				
				}	 
			}
		}
	}
	

	
	common.ui.ExtRadioButtons = Widget.extend({
		init: function(element, options) {
			var that = this;
			Widget.fn.init.call(that, element, options);
			element = that.wrapper = that.element;
			options = that.options;
			that._radio();
			kendo.notify(that);
		},
        events: [
            CLICK,
            CHANGE
        ],
        options: {
        	name:"ExtRadioButtons",
        	enable:true
        },
        _value: function(){
        	var that = this;
        	if(that.radio){
        		return that.element.find(".active input[type='radio']").val();
        	}
        },
        _radio: function(){
        	var that = this;
        	var input = that.element.find("input[type='radio']");
        	if(input.length > 0){
        		that.radio = true ;
        	}else{
        		that.radio = false ;
        	}
        	
        	if(that.radio){
        		that.value = that._value();
        		input.on(CHANGE, function(e){
        			if( that.value != this.value ){
        				that.value = this.value ;
        				that.trigger( CHANGE, { value: that.value } )
        			}
        		} );        		
        	}
        }        
	});
	
})(jQuery);
/**
 * extPanel widget
 */
(function($, undefined) {
	var common = window.common = window.common || {};
	common.ui = common.ui || {};
	var kendo = window.kendo, 
		Widget = kendo.ui.Widget, 
		DataSource = kendo.data.DataSource, 
		isPlainObject = $.isPlainObject, 
		proxy = $.proxy, 
		extend = $.extend, 
		each = $.each,
		template = kendo.template,
		templates,
		placeholderSupported = kendo.support.placeholder, 
		browser = kendo.support.browser, 
		isFunction = kendo.isFunction, 
		BODY = "body",
		// classNames
		EXT_PANEL = ".panel",
		EXT_PANEL_HEADING = ".panel-heading",
		EXT_PANEL_TITLE = ".panel-title",
		EXT_PANEL_BODY = ".panel-body",
		EXT_PANEL_HEADING_BUTTONS = ".panel-heading .k-window-action",
		// constants
		POST = 'POST', 
		JSON = 'json', 
		VISIBLE = ":visible",
		HIDDEN = "hidden",
		CURSOR = "cursor",
		// events
		CHANGE = "change", 
		UNDEFINED = 'undefined',	
		OPEN = "open",
		DEACTIVATE = "deactivate",
		ACTIVATE = "activate",
		CLOSE = "close",
		REFRESH = "refresh",
		CUSTOM = "custom",
		ERROR = "error",
		DRAGSTART = "dragstart",
        DRAGEND = "dragend",		
		REFRESHICON = ".k-window-titlebar .k-i-refresh",
		MINIMIZE_MAXIMIZE = ".k-window-actions .k-i-minimize,.k-window-actions .k-i-maximize",
		// error handler
		handleKendoAjaxError = common.api.handleKendoAjaxError;	
	
	function defined(x) {
		return (typeof x != UNDEFINED);
	}
	
	function sizingAction(actionId, callback) {
		return function() {
            var that = this,
                wrapper = that.wrapper,
                style = wrapper[0].style,
                options = that.options;

            if (options.isMaximized || options.isMinimized) {
                return;
            }
            wrapper.children(EXT_PANEL_HEADING).find(MINIMIZE_MAXIMIZE).parent().hide().eq(0).before(templates.action({ name: "Restore" }));
            callback.call(that);
            return that;
        };		
	}
	
	common.ui.panel = function ( options ){		
		options = options || {};	
		if( defined(options.renderTo)){
			 return new common.ui.ExtPanel( $(options.renderTo), options); 
		}else 	if( defined(options.appendTo) ){		
			var guid = common.api.guid().toLowerCase() ;
			$(options.appendTo).append( "<div id='" + guid+ "'  class='panel panel-default no-padding-hr'></div>");		
			$("#" + guid ).fadeIn("slow");			
			return new common.ui.ExtPanel( $("#" + guid ), options); 
		}		
	}
	
	common.ui.ExtPanel = Widget.extend({
		init : function(element, options) {
			var that = this,
			wrapper,
			content,
			visibility, display,
			isVisible = false,
			suppressActions = options && options.actions && !options.actions.length,
			id;			
			Widget.fn.init.call(that, element, options);
			options = that.options;			
			element = that.element;
			content = options.content;			
			if (suppressActions) {
				options.actions = [];
			}
			
			that.appendTo = $(options.appendTo);
			
			if (!defined(options.visible) || options.visible === null) {
				options.visible = element.is(VISIBLE);
			}
			if (element.is(VISIBLE)) {
				isVisible = true;				
			} else {
				visibility = element.css("visibility");
				display = element.css("display");
				element.css({ visibility: HIDDEN, display: "" });
				element.css({ visibility: visibility, display: display });
			}			
			if (!defined(options.visible) || options.visible === null) {
				options.visible = element.is(VISIBLE);				
			}
			
			wrapper = that.wrapper = element.closest(EXT_PANEL);
			wrapper.append(templates.heading( extend( templates, options )));
			wrapper.append(templates.body( {} ) );
			
			if (content) {
				that.render();			
			}
			
			if( defined(options.template)){
				if (!defined(options.data) ){
					options.data = {};
				}
				options.content = options.template(options.data); 
				that.render();			
			}

			 if( options.autoBind )
				kendo.bind(element, options.data );
			 
			id = element.attr("id");			
			wrapper.on("click", "> " + EXT_PANEL_HEADING_BUTTONS, proxy(that._panelActionHandler, that));
			 if (options.visible) {
				 that.trigger(OPEN, {target: that});
				 that.trigger(ACTIVATE);
			 }
			kendo.notify(that);
		},
		events:[
			OPEN,
			CLOSE,
			REFRESH,
			DRAGSTART,
			DRAGEND,
			CUSTOM,
			ERROR
		],		
		options : {
			name : "ExtPanel",
			title: "",
			actions: ["Close"],
			content : null,
			visible: null,
			appendTo: BODY,
			autoBind: false,
			animation : {
				open: {},
				close: {}
			},
			refreshContent : true,
			handlers : {}
		},
		data : function( data ){
			var that = this;
			if( defined(data)){
				that.options.data = data;
			}else{
				return that.options.data;
			}
		},
		_animations: function() {
			var options = this.options;
			if (options.animation === false) {
				 options.animation = { open: { effects: {} }, close: { hide: true, effects: {} } };				
			}
		},
		_closable: function() {
			return $.inArray("close", $.map(this.options.actions, function(x) { return x.toLowerCase(); })) > -1;
		},
		_panelActionHandler: function(e){
			if (this._closing) {
                return;
            }
			 var icon = $(e.target).closest(".k-window-action").find(".k-icon");
			 var action = this._actionForIcon(icon);
			 if (action) {
				 e.preventDefault();
				 this[action]();
				 return false;
			 }			 
		},
		_actionForIcon: function(icon) {
			var iconClass = /\bk-i-\w+\b/.exec(icon[0].className)[0];
			return {
	                "k-i-close": "_close",
	                "k-i-maximize": "maximize",
	                "k-i-minimize": "minimize",
	                "k-i-restore": "restore",
	                "k-i-refresh": "refresh",
	                "k-i-custom": "_custom"
			}[iconClass];
		},				
		
		_custom: function(systemTriggered){
			var that = this;
			that.trigger(CUSTOM, {target: that});
		},
		_close: function(systemTriggered) {
			var that = this,
				wrapper = that.wrapper,
				options = that.options,
				showOptions = options.animation.open,
				hideOptions = options.animation.close;
			
			if (wrapper.is(VISIBLE) && !that.trigger(CLOSE, { userTriggered: !systemTriggered, target: that })) {
				that._closing = true;
				 options.visible = false;
				 wrapper.kendoStop().kendoAnimate({
					effects: hideOptions.effects || showOptions.effects,
					reverse: hideOptions.reverse === true,
					duration: hideOptions.duration,
					complete: proxy(this._deactivate, this)
				 });
			}			
		},
		toggleMaximization: function () {
            if (this._closing) {
                return this;
            }
            return this[this.options.isMaximized ? "restore" : "maximize"]();
        },		
		_deactivate: function() {
			this.wrapper.hide().css("opacity","");
			this.trigger(DEACTIVATE);			
			this.destroy();
        },
		title : function (text){
			var that = this,
				wrapper = that.wrapper,
				options = that.options;
		},
		maximize: sizingAction("maximize", function() {
			var that = this,
            wrapper = that.wrapper;
			if( !wrapper.children(EXT_PANEL_BODY).is(VISIBLE) ){
				//wrapper.children(EXT_PANEL_BODY).show();				
				wrapper.children(EXT_PANEL_BODY).slideToggle(200);		
			}			
			that.options.isMaximized = true;
			
		}),
		minimize: sizingAction("minimize", function() {
			var that = this,
				wrapper = that.wrapper;			//that.element.hide();
			that.options.isMinimized = true;
			if( wrapper.children(EXT_PANEL_BODY).is(VISIBLE) ){
				//wrapper.children(EXT_PANEL_BODY).hide();				
				wrapper.children(EXT_PANEL_BODY).slideToggle(200);		
			}
		}),
		restore: function () {
			var that = this;
			var options = that.options;
			that.wrapper.find(".panel-heading .k-i-restore").parent().remove().end().end().find(MINIMIZE_MAXIMIZE).parent().show().end().end();
			
			//that.wrapper.children(EXT_PANEL_BODY).show();			
			that.wrapper.children(EXT_PANEL_BODY).slideToggle(200);		
			options.isMaximized = options.isMinimized = false;			
			return that;
		},
		render: function(){
			var that = this,
			wrapper = that.wrapper,
			options = that.options;
			wrapper.children(EXT_PANEL_BODY).html(options.content);		
		},	
		refresh: function(){
			var that = this,
			wrapper = that.wrapper,
			options = that.options;
			wrapper.children(EXT_PANEL_BODY).html(options.content);
			
			if( isFunction(options.handlers.refresh) ){
				options.handlers.refresh();				
			}			
			that.trigger(REFRESH, {target: that});			
		},		
		content:function(html, data){
		 	var content = this.wrapper.children(EXT_PANEL_BODY);
		 	if (!defined(html)) {
		 		return content.html();		 		
		 	}
		 	content.empty().html(html);
		 	kendo.bind(content, data);
		},
		destroy: function () {
			//this.wrapper.find(".k-resize-handle,.k-window-titlebar").off(NS);
			 Widget.fn.destroy.call(this);
			 this.unbind(undefined);
			 kendo.destroy(this.wrapper);
			 this.wrapper.empty().remove();
			 this.wrapper = this.appendTo = this.element = $();
		}
	});
	
	templates = {
		wrapper: template("<div class='panel panel-default' />"),	
		action: template(
	            "<a role='button' href='\\#' class='k-window-action k-link'>" +
	                "<span role='presentation' class='k-icon k-i-#= name.toLowerCase() #'>#= name #</span>" +
	            "</a>"
	        ),
		heading: template(
			"<div class='panel-heading'>" +
			"<h3 class='panel-title'>#= title #</h3>" +
			"<div class='k-window-actions panel-header-controls'>" +
			"<div class='k-window-actions'>" +
            "# for (var i = 0; i < actions.length; i++) { #" +
                "#= action({ name: actions[i] }) #" +
            "# } #" +
            "</div>" +			
			"</div>"	 +
			"</div>"	
		) ,
		body: template("<div class='panel-body'><div class='panel-body-loading'></div></div>"),
		footer: template("<div class='panel-footer'></div>")
	};
	
})(jQuery);

(function($, undefined) {
	var Widget = kendo.ui.Widget, DataSource = kendo.data.DataSource, ui = window.ui = window.ui
			|| {};
	var proxy = $.proxy, OPEN = 'open', CHANGE = "change", observable = new kendo.data.ObservableObject(
			{
				title : "&nbsp;"
			});

	ui.extPanel = Widget
			.extend({
				init : function(element, options) {
					var that = this;
					Widget.fn.init.call(that, element, options);
					options = that.options;
					that.refresh();
					kendo.notify(that);
				},
				events : [ CHANGE, OPEN ],
				options : {
					name : "extPanel",
					title : null,
					template : null,
					data : {},
					refresh : false,
					commands : []
				},
				hide : function() {
					var that = this;
					that.element.hide();
				},
				data : function(value) {
					var that = this;
					if (value !== undefined) {
						that.options.data = value;
						if (that.options.refresh)
							that.refresh();
						that.trigger(CHANGE, {
							data : that.options.data
						});
					} else {
						return that.options.data;
					}
				},
				refresh : function() {
					var that = this;
					that.render();
					if (that.options.afterChange)
						that.options.afterChange(that.options.data);
				},
				show : function() {
					var that = this;
					$(that.element).show();
				},
				render : function() {
					var that = this;
					if (that.options.template) {
						$(that.element)
								.html(that.options.template(that.data()));
						kendo.bind($(that.element), that.data());
						// observable.set("title", that.data().name );
						// kendo.bind($(that.element), observable );
					}
					$(that.element)
							.find(".panel-header-controls a.k-link")
							.each(
									function(index) {
										$(this)
												.click(
														function(e) {
															e.preventDefault();
															var header_action = $(this);
															if (header_action
																	.text() == "Minimize") {
																var header_action_icon = header_action
																		.find('span');
																if (header_action_icon
																		.hasClass("k-i-minimize")) {
																	header_action_icon
																			.removeClass("k-i-minimize");
																	header_action_icon
																			.addClass("k-i-maximize");
																	$(
																			that.element)
																			.find(
																					".panel-body, .panel-footer")
																			.addClass(
																					"hide");
																} else {
																	header_action_icon
																			.removeClass("k-i-maximize");
																	header_action_icon
																			.addClass("k-i-minimize");
																	$(
																			that.element)
																			.find(
																					".panel:first > .panel-body:last, .panel-footer")
																			.removeClass(
																					"hide");
																}
															} else if (header_action
																	.text() == "Close") {
																that.destroy();
															} else if (header_action
																	.text() == "Refresh") {

																// custom
															} else if (header_action
																	.text() == "Custom") {
																var _body = $(
																		that.element)
																		.find(
																				".panel-body:first");
																if (_body
																		.hasClass('hide')) {
																	_body
																			.removeClass('hide');
																	that
																			.trigger(
																					OPEN,
																					{
																						element : (that.element)
																								.find(".panel-body:first")
																					});
																} else {
																	_body
																			.addClass('hide');
																}
															}
														});
									});
					// custom
					$(that.element).find(".panel-body:first button.close")
							.click(
									function(e) {
										e.preventDefault();
										$(that.element).find(
												".panel-body:first").addClass(
												"hide");
									});

					$.each(that.options.commands, function(index, value) {
						$(value.selector).click(value.handler);
					});
				},
				body : function() {
					var that = this;
					return $(that.element).find(
							".panel:first > .panel-body:last");
				},
				destroy : function() {
					var that = this;
					Widget.fn.destroy.call(that);
					$(that.element).remove();
					// .off(NS);
					// open = false;
				},
			});

	$.fn.extend({
		extPanel : function(options) {
			return new ui.extPanel(this, options);
		}
	});
})(jQuery);

/**
 * extDropDownList widget
 */
(function($, undefined) {
	var Widget = kendo.ui.Widget, DataSource = kendo.data.DataSource, ui = window.ui = window.ui
			|| {};
	ui.extDropDownList = Widget.extend({
		init : function(element, options) {
			var that = this;
			Widget.fn.init.call(that, element, options);
			options = that.options;
			if (options.renderTo == null) {
				options.renderTo = element;
			}
			if (options.value != null)
				that.value = options.value;
			that.render(options);
		},
		events : {},
		value : 0,
		dataSource : null,
		options : {
			name : "dropDownList",
			dataSource : null,
			template : null,
			enabled : true,
		},
		_change : function() {
			var that = this;
			// alert( '>>' + that.value );
			if (that.options.change != null)
				that.options.change(that.dataSource.get(that.value));
		},
		render : function(options) {
			var contentId = this.element.attr('id') + 'list';
			var content = options.renderTo;
			var that = this;

			that.dataSource = DataSource.create(options.dataSource);
			that.dataSource.fetch(function() {
				var items = that.dataSource.data();
				var html = '<select id="' + contentId
						+ '"role="navigation" class="form-control"';
				if (!options.enabled)
					html = html + 'disabled >';
				else
					html = html + '>';

				$.each(items, function(index, value) {
					html = html + '<option ';
					if (that.value == value[options.dataValueField])
						html = html + ' selected ';
					html = html + ' value="' + value[options.dataValueField]
							+ '" ' + '>' + value[options.dataTextField]
							+ '</option>';
				});
				html = html + '</select>';
				content.append(html);
				that._change();

				$("#" + contentId).change(function() {
					that.value = $("#" + contentId).val();
					that._change();
				});

				if (options.doAfter != null) {
					options.doAfter(that);
				}
			});
		}
	});

	$.fn.extend({
		extDropDownList : function(options) {
			return new ui.extDropDownList(this, options);
		}
	});

})(jQuery);

/**
 * extNavBar widget
 */
(function($, undefined) {
	var Widget = kendo.ui.Widget, DataSource = kendo.data.DataSource, ui = window.ui = window.ui
			|| {};
	ui.extTopBar = Widget
			.extend({
				init : function(element, options) {
					var that = this;
					Widget.fn.init.call(that, element, options);
					options = that.options;
					if (options.renderTo == null) {
						options.renderTo = element;
					}
					that.items = new Array();
					that.render(options);
				},
				events : {},
				dataSource : null,
				items : null,
				options : {
					name : "topBar",
					renderTo : null,
					menuName : null,
					dataSource : null,
					template : null,
					select : null,
				},
				render : function(options) {
					var content = options.renderTo;
					if (options.dataSource == null && options.menuName != null) {
						this.dataSource = DataSource
								.create({
									transport : {
										read : {
											url : "/secure/get-company-menu-component.do?output=json",
											dataType : "json",
											data : {
												menuName : options.menuName
											}
										}
									},
									schema : {
										data : "targetCompanyMenuComponent.components"
									}
								});
					} else {
						this.dataSource = DataSource.create(options.dataSource);
					}
					var that = this;
					that.dataSource.fetch(function() {
						var items = that.dataSource.data();
						content.append(options.template(items));
						content.find('.nav a').click(
								function(e) {
									if ($(e.target).is('[action]')) {
										var selected = $(e.target);
										var item = {
											title : $.trim(selected.text()),
											action : selected.attr("action"),
											description : selected
													.attr("description")
													|| ""
										};
										if (options.select != null)
											options.select(item);
										else
											that.select(item);
									}
								});
						if ($.isArray(options.items)) {
							// alert ("array");
						} else if ((typeof options.items == "object")
								&& (options.items !== null)) {
							if (options.items.type == 'dropDownList') {
								var subItem = options.items;
								var subObject = $('#' + subItem.id)
										.extDropDownList(subItem);
								that.items.push(subObject);
							}
						}
						if (options.doAfter != null) {
							options.doAfter(that);
						}
					});
				},
				select : function(item) {
					var content = this.options.renderTo;
					content.find("form[role='navigation']").attr("action",
							item.action).submit();
				},
				getMenuItem : function(name) {
					var items = this.dataSource.data();
					var menuItem = null;
					$.each(items, function(i, item) {
						if (item.components.length > 0) {
							$.each(item.components, function(j, item2) {
								if (name == item2.name) {
									menuItem = item2;
									return;
								}
							});
						} else {
							if (name == item.name) {
								menuItem = item;
								return;
							}
						}
					});
					return menuItem;
				},
				item : function(id) {
					return $('#' + id).data("extDropDownList");
				}
			});
	$.fn.extend({
		extTopBar : function(options) {
			return new ui.extTopBar(this, options);
		}
	});

})(jQuery);

/**
 * kendoTopBar widget
 */
(function($, undefined) {
	var Widget = kendo.ui.Widget, DataSource = kendo.data.DataSource, ui = window.ui = window.ui
			|| {};
	var sliding = false;
	var $body = $('body');
	ui.kendoTopBar = Widget.extend({
		init : function(element, options) {
			var that = this;
			Widget.fn.init.call(that, element, options);
			options = that.options;
			that.render(options);
			element.click($.proxy(that._open, this));
		},
		events : {

		},
		options : {
			name : "topBar",
			renderTo : null,
			dataSource : null,
			template : null
		},
		render : function(options) {
			var content = options.renderTo;
			var dataSource = DataSource.create(options.dataSource);
			var that = this;
			dataSource.fetch(function() {
				var items = dataSource.data();
				content.append(options.template(items));
				content.find('ul').first().kendoMenu(
						{
							orientation : "vertical", // "horizontal",
							select : function(e) {
								if ($(e.item).is('[action]')) {
									var selected = $(e.item);
									options.select({
										title : $.trim(selected.text()),
										action : selected.attr("action"),
										description : selected
												.attr("description")
												|| ""
									});
									setTimeout(function() {
										that._open();
									}, 300);
								}
							}
						});
				if (options.doAfter != null) {
					options.doAfter(content);
				}
			});
		},
		// Function that controls opening of the pageslide
		_open : function(e) {
			var content = this.options.renderTo;
			var slide = kendo.fx(content).slideIn("right");
			if (sliding) {
				slide.reverse();
				sliding = false;
			} else {
				slide.play();
				sliding = true;
			}
			e.preventDefault();
		}
	});
	$.fn.extend({
		kendoTopBar : function(options) {
			return new ui.kendoTopBar(this, options);
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
	var kendo = window.kendo, Widget = kendo.ui.Widget, proxy = $.proxy, ui = window.ui = window.ui
			|| {};

	ui.extOverlay = Widget.extend({
		init : function(element, options) {
			var that = this;
			Widget.fn.init.call(that, element, options);
			element = that.wrapper = that.element;
			options = that.options;
			options.transitions = Modernizr.csstransitions;
			var transEndEventNames = {
				'WebkitTransition' : 'webkitTransitionEnd',
				'MozTransition' : 'transitionend',
				'OTransition' : 'oTransitionEnd',
				'msTransition' : 'MSTransitionEnd',
				'transition' : 'transitionend'
			};
			options.transEndEventName = transEndEventNames[Modernizr
					.prefixed('transition')];
			$(element).find('button.overlay-close').on('click', function(e) {
				e.preventDefault();
				that.toggleOverlay();
			});
		},
		options : {
			name : "Overlay"
		},
		toggleOverlay : function() {
			var that = this;
			var overlay = $(that.element);
			var options = that.options;
			if (overlay.hasClass('hide')) {
				overlay.removeClass('hide')
			}
			if (overlay.hasClass('open')) {
				overlay.removeClass('open');
				if ($('body').hasClass('modal-open'))
					$('body').removeClass('modal-open')
				overlay.addClass('close');
				var onEndTransitionFn = function(ev) {
					if (options.transitions) {
						if (ev.originalEvent.propertyName !== 'visibility')
							return;
						overlay.off(options.transEndEventName, onEndTransitionFn);
					}
					overlay.removeClass('close');
				};
				if (options.transitions) {
					overlay.on(options.transEndEventName, onEndTransitionFn);
				} else {
					onEndTransitionFn();
				}
			} else if (!overlay.hasClass('close')) {
				if (!$('body').hasClass('modal-open'))
					$('body').addClass('modal-open')
				overlay.addClass('open');
			}
		}
	});
	$.fn.extend({
		extOverlay : function(options) {
			return new ui.extOverlay(this, options);
		}
	});
})(jQuery);

