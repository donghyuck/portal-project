/**
 * COMMON UI CORE
 * dependency : jquery
 */
;(function($, undefined) {
		var common = window.common = window.common || { },
		extend = $.extend,
		each = $.each,
		isArray = $.isArray,
		proxy = $.proxy,
		noop = $.noop,
		math = Math,
		FUNCTION = "function",
		STRING = "string",
		OBJECT = "object",
		UNDEFINED = "undefined";
				
	function guid () {		
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
	
	function random(min, max){
		return Math.floor(Math.random() * (max - min + 1)) + min;
	}

	function valid ( type, value ){
		if( type === "url" ){
			 var urlregex = new RegExp("^(http|https|ftp)\://[a-zA-Z0-9\-\.]+\.[a-zA-Z]{2,3}(:[a-zA-Z0-9]*)?/?([a-zA-Z0-9\-\._\?\,\'/\\\+&amp;%\$#\=~])*$");
			 return urlregex.test(value);
		}else if (type === "email"){
			var expr = /^([\w-\.]+)@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.)|(([\w-]+\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})(\]?)$/;
			return expr.test(email);
		}		
		return false;
	}	
		
	
	extend(common, {	
		ui: common.ui || {},
		random : common.random || random,
		guid : common.guid || guid,
		valid : common.valid || valid
	});
		
})(jQuery);


;(function($, undefined) {
	var ui = common.ui,
	random = common.random,
	isFunction = kendo.isFunction,
	extend = $.extend,
	each = $.each,
	proxy = $.proxy,
	DataSource = kendo.data.DataSource,
	Widget = kendo.ui.Widget, 
	progress = kendo.ui.progress,
	POST = 'POST',	
	JSON = 'json',
	VISIBLE = ":visible",
	DISABLED = "disabled",
	STRING = 'string',
	CLICK = "click",
	CHANGE = "change",	
	OPEN = "open",
	HIDDEN = "hidden",
	CURSOR = "cursor",	
	DEACTIVATE = "deactivate",
	ACTIVATE = "activate",	
	UNDEFINED = "undefined";
	
	function handleAjaxError(xhr) {
		var message = "";		
		
		if( typeof xhr === STRING ){
			message = xhr;			
		} else {		
			if (xhr.status == 0) {
				message = "오프라인 상태입니다.";
			} else if (xhr.status == 404 || xhr.errorThrown == "Not found")  {
				message = "요청하신 페이지를 찾을 수 없습니다.";
			} else if (xhr.status == 500) {
				message = "시스템 내부 오류가 발생하였습니다.";
			} else if (xhr.status == 503) {
				message = "서비스 이용이 지연되고 있습니다. 잠시 후 다시 시도하여 주십시오.";			
			} else if (xhr.status == 403 || xhr.errorThrown == "Forbidden") {
				message =  "접근 권한이 없습니다.";
			} else if (xhr.errorThrown == 'timeout') {
				message = "처리 대기 시간을 초가하였습니다. 잠시 후 다시 시도하여 주십시오.";
			} else if (xhr.errorThrown == 'parsererror') {
				message = "데이터 파싱 중에 오류가 발생하였습니다.";
			} else {
				message = "오류가 발생하였습니다." ;
			}		
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
	
	
	function defined(x) {
		return (typeof x != UNDEFINED);
	};
	
	function slimScroll( renderTo , options ){
		options = options || {};
		renderTo.slimScroll( options );
	}
	
	function visible( selector ){
		return selector.is(":visible");
	}
	
	var DEFAULT_PAGER_SETTING = {
			refresh : true,		
			buttonCount : 9,
			info: false
	};	
	
	function grid(renderTo, options){
		if(!renderTo.data("kendoGrid")){			
			 renderTo.kendoGrid(options);
		}		
		return renderTo.data("kendoGrid");
	}
	
	function listview( renderTo, options){		
		if(!renderTo.data("kendoListView")){			
			 renderTo.kendoListView(options);
		}		
		return renderTo.data("kendoListView");
	}
	
	function pager ( renderTo, options ){		
		if(!renderTo.data("kendoPager")){		
			options = options || {};		
			var settings = extend(true, {}, DEFAULT_PAGER_SETTING , options ); 
			renderTo.kendoPager(settings);
		}		
		return renderTo.data("kendoPager");
	}

	var DEFAULT_UPLOAD_SETTING = {
		multiple : true,
		width: 300,
		showFileList : false,
		localization:{ select : '파일 선택' , dropFilesHere : '업로드할 파일들을 이곳에 끌어 놓으세요.' },
		async: {			
			autoUpload: true
		},
		upload: function (e) {								         
	    	 e.data = {};														    								    	 		    	 
	    }
	};
	
	function upload(renderTo, options){
		if(!renderTo.data("kendoUpload")){		
			options = options || {};		
			var settings = extend(true, {}, DEFAULT_UPLOAD_SETTING , options ); 
			renderTo.kendoUpload(settings);
		}		
		return renderTo.data("kendoUpload");		
	}
	
	var DEFAULT_DATASOURCE_SETTING = {
			transport:{
				read:{
					type :POST,
					dataType : JSON
				} 				
			},
			serverPaging: true,
			error:handleAjaxError,	
			pageSize: 10		
	};
	
	
	function datasource(url, options){		
		options = options || {};		
		var settings = extend(true, {}, DEFAULT_DATASOURCE_SETTING , options ); 
		if( defined(url) ){
			settings.transport.read.url = url;			
		}		
		var dataSource =  DataSource.create(settings);
		return dataSource;
	};

	var DEFAULT_AJAX_SETTING = {
		type : POST,	
		data : {},
		dataType : JSON,
		error:handleAjaxError 		
	};	


	function ajax ( url, options ){
		options = options || {};	
		var settings = extend(true, {}, DEFAULT_AJAX_SETTING , options ); 
		if( defined( url) ){
			settings.url = url;			
		}				
		return $.ajax(settings);		
	};	
	
	function scrollTop(selector , margin ){
		margin = margin || 0; 
		$('html, body').animate({scrollTop: ( selector.offset().top + margin)  }, 1000);
	}

	
	function animate (renderTo, options ){		
		var options = options || {};
		renderTo.kendoStop().kendoAnimate(options);
	}
	
	/**
	 * Setup  
	 *  
	 */
	
	var DEFAULT_SETUP_SETTING = {
		features : {
			culture : true,
			landing : true,
			wallpaper : false,
			lightbox: false,
			spmenu: false,
			morphing: false
		},
		wallpaper : {
			slideshow : true
		},
		jobs: []
	};
	
	function setup (options) {
		options = options || {};
		return new Setup(options);		
	}
	
	var Setup = kendo.Class.extend({		
		init: function(options) {
			var that = this;
			options = that.options = extend(true, {}, DEFAULT_SETUP_SETTING, options);		
			
			if(!defined(that.complete))
				that.complete = false;			
			that._features();
			that._jobs();
			that.complete = true;
		},
		_jobs:function(){			
			var that = this;
			options = that.options,
			jobs = options.jobs;
								
			var initilizer, _i, _len, _ref;
			 _ref = jobs;			 
			 for (_i = 0, _len = jobs.length; _i < _len; _i++) {
				 initilizer = _ref[_i];
				 $.proxy(initilizer, that)();
			}							
		},
		_features: function(){
			var that = this,
			options = that.options,
			features = options.features;
			
			if( features.culture ){
				culture();				
			}
			
			if(features.wallpaper){
				wallpaper(options.wallpaper);
			}
			
			if(features.landing){				
				landing();
			}
			
			if(features.spmenu){				
				spmenu();
			}
			
			if(features.lightbox){				
				lightbox();
			}
			if(features.morphing){				
				$(document).on("click","[data-toggle='morphing']", function(e){
					if( $(this).data("target")){
						$(this).closest(".morphing").toggleClass("open");
					}else{
						
					}
				});
			}			
		} 		
	});
	
	function culture ( locale ){
		if( !defined( locale ) )
			locale = "ko-KR";
		kendo.culture(locale);				
	}	
	
	function landing (element){		
		if( typeof element === UNDEFINED )
			element ='.page-loader' ;
		
		if( $(element).length == 0 ){
			$('body').prepend("<div class='page-loader' ></div>");
		}		
		 $(element).fadeOut('slow');
	}
	
	function wallpaper (options){		
		if(!defined($.backstretch)) {
			return;
		}	
		options = options || {},
		template = options.template || kendo.template("/community/view-streams-photo.do?key=#= externalId#"),
		dataSource = options.dataSource = datasource( "/community/list-streams-photo.do?output=json", {
			pageSize: 15,
			schema: {
				total: "photoCount",
				data: "photos"
			},
			change : function(e){
				var view = this.view(),
				urls = [];
				
				if ( options.slideshow ){
					each(view, function(idx, photo){
						urls.push(template(photo));
					});	
				}else{
					urls.push(template(view[random(0, view.length)]));
				}
				$.backstretch(
						urls,	
						{duration: 6000, fade: 750}	
				);
			}
		}).read();	
			/*
		dataSource.fetch(function(){
			var photos = this.data();
			var urls = [];
			if ( options.slideshow ){
				each(photos, function(idx, photo){
					urls.push(template(photo));
				});	
			}else{
				urls.push(template(photos[random(0, photos.length)]));
			}
			
			$.backstretch(
				urls,	
				{duration: 6000, fade: 750}	
			);
		});		*/
	}	
	
	var DEFAULT_LIGHTBOX_OPTIONS = {
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
		};
	
	function spmenu(options){
				
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
			$("body").css("overflow-y: hidden;");
			$(target).trigger("open");
			$(target).toggleClass("cbp-spmenu-open");
		
		});
		
		$(document).on("click","[data-dismiss='spmenu']", function(e){
			var $this = $(this);
			
			var target  = $this.parent();		
			$("body").css("overflow-y: auto;");
			var toggle = $this.data("toggle-target");
			if(defined(toggle)){
				if($(toggle).is(".active") )
					$(toggle).removeClass("active");
			}
			
			target.trigger("close");
			target.toggleClass("cbp-spmenu-open");
		});
		
	}
	
	function lightbox (){		
		if(!defined($.magnificPopup)) {
			return false;
		}		
		$(document).on("click","[data-ride='lightbox']", function(e){					
			var $this = $(this), config = {};				
			if($this.data("plugin-options")) {
				config = extend({}, DEFAULT_LIGHTBOX_OPTIONS, opts, $this.data("plugin-options"));	
			}else{
				config = DEFAULT_LIGHTBOX_OPTIONS;
			}		
			
			if( $this.data("selector") ){
				config.items = [];
				$.each( $($this.data("selector") ) , function( index , value ){
					var $that = $(value);
					if( $that.data("largesrc") ){
						config.items.push({
							src : $that.data("largesrc")
						});						
					}else{
						if( $that.prop("tagName").toLowerCase() == "img" ){				
							config.items.push({
								src : $that.attr("src")
							});			
						}						
					}
				});
			}else{			
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
			}
			$.magnificPopup.open(config);
		} );	
	}
	
	var DEFAULT_THUMBNAIL_EXPAND_HEIGHT = 500,
		DEFAULT_THUMBNAIL_EXPAND_MARGIN = 10,
		DEFAULT_THUMBNAIL_EXPAND_TEMPLATE = kendo.template(
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
	
	function thumbnailExpanding ( options ){ 
		options = options || {};
		if( defined(options.template) && typeof options.template === STRING )
		{
			options.template = kendo.template(options.template);
		}
		
		var template = options.template || DEFAULT_THUMBNAIL_EXPAND_TEMPLATE,
		previewHeight = options.previewHeight || DEFAULT_THUMBNAIL_EXPAND_HEIGHT,
		marginExpanded  = options.marginExpanded || DEFAULT_THUMBNAIL_EXPAND_MARGIN;
		
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
				$previewEl.css( 'height', 0 );
				$expandedItem.css( 'height', '0px' ).on( kendo.support.transitions.event, onEndFn );
				if( ! kendo.support.transitions.css ) {
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
				$parent.append(options.template(data));	
				$items.css("height", "");
				preview = $parent.children(".og-expander").css("height", previewHeight )
				$parent.css("height", previewHeight + height + marginExpanded );
				preview.css( 'transition', 'height ' + 350 + 'ms ' + 'ease' );
				$parent.css( 'transition', 'height ' + 350 + 'ms ' + 'ease' );				
			}else if ( ( position + height + marginExpanded ) != preview.offset().top ) {
				preview.slideUp(150, function(){
					preview.remove();
					$parent.append(options.template(data));	
					$items.css("height", "");
					preview = $parent.children(".og-expander").css("height", previewHeight );					
					$parent.css("height", previewHeight + height + marginExpanded );
				});				
			}else{
				var $loading = preview.find(".og-loading");
				var $largeImg = preview.find("img");				
				$largeImg.hide();				
				$loading.show();				
				$( '<img/>' ).load( function() {
					var $img = $( this );
					if( $img.attr( 'src' ) === data.src ) {
						$loading.hide();
						$largeImg.attr("src", data.src ).show();
					}
				} ).attr( 'src', data.src );
			}
			scrollTop(preview, -160); 
			
			return false;
		});	
	}	
	
	function status ( selector, status ){
		var element = selector;
		if(defined(status)){
			if( status === 'disable') {
				if( !element.is(":disabled") ){
					if( element.is("label") )
					{
						element.toggleClass("disabled");						
					}else{
						element.prop("disabled", true);
						if( element.is("[data-toggle='button']") ){
							//element.toggleClass("active");
						}
					}
				}
			}else if (status === 'enable' ){
				if( element.is(":disabled") ){
					if( element.is("label") ){						
						element.toggleClass("disabled");						
					}else{
						element.prop("disabled", false);
						if( element.is("[data-toggle='button']") ){
							//element.toggleClass("active");
						}					
					}
				}				
			}
		}
	}
	
	function enable (element){
		status(element, "enable");
	}
	
	function disable (element){
		status(element, "disable");
	}	

	function buttons (selector, options) {
		
		if( typeof selector === "string" ){
			selector = $(selector);	
		}
		
		var clickFn = function(e){			
			var $this = $(this),
			dismiss = $this.data("dismiss"),
			action = $this.data("action"),
			dismiss_target = $this.data("dismiss-target"),
			toggle_target = $this.data("toggle-target");			
			if(defined(action) && defined(options.handlers))
			{
				if (isFunction(options.handlers[action])) {
					var actionFn = options.handlers[action];
					actionFn($.Event("click",  { event: e, target:this } ));
				}
			}			
			if(dismiss === "panel"){
				var target = $(dismiss_target);
				if($this.data("animate")){
					$(dismiss_target).kendoStop().kendoAnimate({
						effects:"slide:down fade:in",
						reverse: true,
						hide : true								
					 });						
				}else{
					$(dismiss_target).hide();	
				}	
			}
			if(toggle_target){
				var target = $(toggle_target);
				if( target.is("[data-toggle='button']") || target.is("button") )
				{
					target.toggleClass("active");
					enable(target);
				}
			}			
		};		
		
		selector.each(function(index) {
			$(this).on("click",clickFn);					
		});
	}
	
	function exists ( element ){
		if( typeof element === "string")
			element = $(element);
		
		return  defined( element.data("role") );
	} 
	
	
	
	extend(ui , {	
		handleAjaxError : common.ui.handleAjaxError || handleAjaxError,
		defined : common.ui.defined || defined,
		visible : common.ui.visible || visible,
		status : common.ui.status || status,
		datasource : common.ui.datasource || datasource,
		ajax : common.ui.ajax || ajax,
		listview : common.ui.listview || listview,
		grid : common.ui.grid || grid,
		pager : common.ui.pager || pager,
		thumbnail : common.ui.thumbnail || { expanding : thumbnailExpanding },
		scroll : common.ui.scroll || {
			slim : slimScroll, 
			top : scrollTop
		},
		enable: common.ui.enable || enable,
		disable: common.ui.disable || disable,
		buttons : common.ui.buttons || buttons,
		animate : common.ui.animate || animate,
		fx : kendo.fx,
		bind : kendo.bind,
		stringify : kendo.stringify,
		template : kendo.template,
		upload : common.ui.upload || upload,
		observable : kendo.observable,
		exists : exists,
		setup : common.ui.setup || setup,
		data : common.ui.data || {},
		connect : common.ui.connect || {}
	});
	
})(jQuery);

/**
 * ButtonGroup
 */
;(function($, undefined) {
	var ui = common.ui,
	defined = common.ui.defined,
	isFunction = kendo.isFunction,
	extend = $.extend,
	proxy = $.proxy,
	DataSource = kendo.data.DataSource,
	Widget = kendo.ui.Widget, 
	progress = kendo.ui.progress,
	POST = 'POST',	
	JSON = 'json',
	VISIBLE = ":visible",
	DISABLED = "disabled",
	STRING = 'string',
	CLICK = "click",
	CHANGE = "change",	
	OPEN = "open",
	HIDDEN = "hidden",
	CURSOR = "cursor",	
	DEACTIVATE = "deactivate",
	ACTIVATE = "activate",	
	UNDEFINED = "undefined";
		
	var ButtonGroup = Widget.extend({
		init : function(element, options) {
			var that = this;
			Widget.fn.init.call(that, element, options);
			element = that.wrapper = that.element;
			options = that.options;
			
			options.enable = options.enable && !element.attr(DISABLED);
			that.enable(options.enable);
			
			that._radio();
			that._button();
			
			kendo.notify(that);
		},
		events : [ CLICK, CHANGE ],
		options : {
			name : "ButtonGroup",
			enable: true
		},
		enable: function(enable) {
			var that = this,
			element = that.element;
			if (defined(enable)) {
				enable = true;
			}
		},
		currentValue : function() {
			var that = this;
			if (that.radio) {
				return that.element.find(".active input[type='radio']").val();
			}
		},
		_button : function(){
			var that = this,
			options = that.options,
			element = that.element;
			var button = element.find("button[type='button']");
			if (button.length > 0) {
				that.button = true;
			} else {
				that.button = false;
			}
			if (that.button) {
				button.on(
					CLICK,
					function(e){
						var $this =  $(this);						
						var target = $this.data("target");
						var action = $this.data("action");
						var animate = $this.data("animate");					
						var toggle_target = $this.data("toggle-target");						
						if($this.hasClass("btn-u")){
							$this.toggleClass("active");
						}
						if(defined(action) && defined(options.handlers))
						{
							if (isFunction(options.handlers[action])) {
								var fn = options.handlers[action];
								fn($.Event("click",  { event: e, target:this } ));
							}
						}
						that.trigger(CLICK, { event: e, target:this } );
					}
				);				
			}
		},
		_radio : function() {
			var that = this,
			element = that.element;
			
			var input = element.find("input[type='radio']");
			if (input.length > 0) {
				that.radio = true;
			} else {
				that.radio = false;
			}			
			if (that.radio) {
				that.value = that.currentValue();
				input.on(CHANGE, function(e) {
					if (that.value != this.value) {
						that.value = this.value;
						that.trigger(CHANGE, {
							value : that.value
						})
					}
				});
			}
			
		}
	});

	
	function buttonGroup ( renderTo, options ){		
		options = options || {};	
		if( defined(renderTo) ){
			if(renderTo.data("kendoButtonGroup")){
				return	renderTo.data("kendoButtonGroup");
			}else{
				return new ButtonGroup(renderTo, options ); 				 
			}
		}
	}	
	
	extend(ui , {	
		buttonGroup : common.ui.buttonGroup || buttonGroup
	});
})(jQuery);

/**
 * Panel
 */
;(function($, undefined) {
	var ui = common.ui,
	guid = common.guid,
	handleAjaxError = ui.handleAjaxError,
	defined = ui.defined,
	isFunction = kendo.isFunction,
	extend = $.extend,
	DataSource = kendo.data.DataSource,
	Widget = kendo.ui.Widget, 
	template = kendo.template,
	each = $.each,
	isPlainObject = $.isPlainObject, 
	placeholderSupported = kendo.support.placeholder, 
	browser = kendo.support.browser, 	
	progress = kendo.ui.progress,
	proxy = $.proxy, 
	POST = 'POST',	
	JSON = 'json',
	VISIBLE = ":visible",
	STRING = 'string',
	CLICK = "click",
	HIDDEN = "hidden",
	CURSOR = "cursor",	
	VISIBLE = ":visible",
	HIDDEN = "hidden",
	CURSOR = "cursor",
	// events
	CHANGE = "change", 
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
	UNDEFINED = "undefined";
	
	var PANEL = ".panel",
	PANEL_HEADING = ".panel-heading",
	PANEL_TITLE = ".panel-title",
	PANEL_BODY = ".panel-body",
	CUSTOM_PANEL_BODY = ".panel-custom-body",
	PANEL_FOOTER = ".panel-footer",
	PANEL_HEADING_BUTTONS = ".panel-heading .k-window-action",	
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
			customBody: template("<div class='panel-custom-body padding-sm bg-slivergray border-b' style='display:none;'></div>"),
			footer: template("<div class='panel-footer'></div>")
		};
	
	function sizingAction(actionId, callback) {
		return function() {
            var that = this,
                wrapper = that.wrapper,
                style = wrapper[0].style,
                options = that.options;

            if (options.isMaximized || options.isMinimized) {
                return;
            }
            wrapper.children(PANEL_HEADING).find(MINIMIZE_MAXIMIZE).parent().hide().eq(0).before(templates.action({ name: "Restore" }));
            callback.call(that);
            return that;
        };		
	}
	
	function extPanel (renderTo, options ){		
		options = options || {};	
		
		var Fn = function( selector, setting){		
			var uid = guid().toLowerCase() ;
			selector.append( "<div id='" + uid+ "'  class='panel panel-default no-padding-hr'></div>");		
			return new Panel( $("#" + uid ), setting); 
		}
		
		if( defined(renderTo) ){
			if( typeof renderTo === "string")
				renderTo = $(renderTo);			
			if( !renderTo.is(".panel") && renderTo.children().length == 0 ){
				return Fn(renderTo, options);				
			}else{
				return new Panel( renderTo, options);
			}
		} else {		
			return Fn($('body'), options);				
		}		
	}
	
	var Panel = Widget.extend({
		init : function(element, options) {
			var that = this, wrapper, content, visibility, display, isVisible = false, 
			suppressActions = options && options.actions && !options.actions.length, id;
			
			Widget.fn.init.call(that, element, options);
			options = that.options;			
			element = that.element;
			content = options.content;			
			
			if (suppressActions) {
				options.actions = [];
			}

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
			wrapper = that.wrapper = element.closest(PANEL);
			if(options.css){
				wrapper.removeClass("default-panel");
				wrapper.addClass(options.css);
			}
			
			if( wrapper.children(PANEL_HEADING).length == 0 ){
				wrapper.append(templates.heading( extend( templates, options )));
			}
			
			if( wrapper.children(CUSTOM_PANEL_BODY).length == 0 ){
				wrapper.append(templates.customBody({}));
			}
			
			if( wrapper.children(PANEL_BODY).length == 0 ){
				wrapper.append(templates.body( {} ) );
			}

			if(wrapper.children(PANEL_FOOTER).length == 0 && options.scrollTop  ){
				wrapper.append(templates.footer( {} ) );
				var footer = wrapper.children(PANEL_FOOTER);
				footer.addClass("text-right");
				footer.append('<button class="btn btn-info btn-sm rounded" type="button" data-action="scrollTop"><i class="fa fa-chevron-circle-up"></i> 맨위로</button>');
				wrapper.find("button[data-action='scrollTop']").click(function(e){
					common.ui.scroll.top(wrapper);			
				});
			}
			
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
			
			wrapper.on("click", "> " + PANEL_HEADING_BUTTONS, proxy(that._panelActionHandler, that));
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
			name : "Panel",
			title: "",
			actions: ["Close"],
			content : null,
			visible: null,
			autoBind: false,
			scrollTop : false,
			animation : {
				open: {},
				close: {}
			},
			refreshContent : true,
			handlers : {},
			deactivateAfterClose : true
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
		show : function(){
			var that = this,
			wrapper = that.wrapper,
			options = that.options,
			showOptions = options.animation.open;
			if( !wrapper.is(VISIBLE) ){
				that._closing = false;
				 options.visible = true;				
				 wrapper.kendoStop().kendoAnimate({
					effects: showOptions.effects || "slide:down fade:in",
					show: true,
					duration: showOptions.duration || 1000
				 });
			}
		},
		_custom: function(systemTriggered){
			var that = this
			wrapper = that.wrapper,
			options = that.options;
			wrapper.children(CUSTOM_PANEL_BODY).slideToggle(200);
			that.trigger(CUSTOM, {target: that});			
		},
		_close: function(systemTriggered) {
			var that = this,
				wrapper = that.wrapper,
				options = that.options,
				deactivateAfterClose = options.deactivateAfterClose,
				showOptions = options.animation.open,
				hideOptions = options.animation.close;			
			if (wrapper.is(VISIBLE) && !that.trigger(CLOSE, { userTriggered: !systemTriggered, target: that })) {
				that._closing = true;
				 options.visible = false;
				 wrapper.kendoStop().kendoAnimate({
					effects: hideOptions.effects || showOptions.effects,
					reverse: hideOptions.reverse === true,
					duration: hideOptions.duration,
					complete : deactivateAfterClose ? proxy(that._deactivate, that) : function(){
						if( wrapper.is(VISIBLE) ){
							wrapper.kendoStop().kendoAnimate({
								effects: hideOptions.effects || "slide:down fade:in",
								reverse: true,
								hide : true								
							 });							
						}
					}
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
				
			if( !wrapper.children(PANEL_BODY).is(VISIBLE) ){
				wrapper.children(PANEL_BODY).slideToggle(200);		
			}			
			if( !wrapper.children(PANEL_FOOTER).is(VISIBLE) ){	
				wrapper.children(PANEL_FOOTER).show();
			}			
			that.options.isMaximized = true;
			
		}),
		minimize: sizingAction("minimize", function() {
			var that = this,
			wrapper = that.wrapper;	
			that.options.isMinimized = true;
			if( wrapper.children(CUSTOM_PANEL_BODY).is(VISIBLE) ){
				wrapper.children(CUSTOM_PANEL_BODY).slideToggle(200);		
			}			
			
			if( wrapper.children(PANEL_BODY).is(VISIBLE) ){	
				wrapper.children(PANEL_BODY).slideToggle(200);		
			}
			if( wrapper.children(PANEL_FOOTER).is(VISIBLE) ){	
				wrapper.children(PANEL_FOOTER).hide();
			}
		}),
		restore: function () {
			var that = this,
			wrapper = that.wrapper,
			options = that.options;
			
			wrapper.find(".panel-heading .k-i-restore").parent().remove().end().end().find(MINIMIZE_MAXIMIZE).parent().show().end().end();
			wrapper.children(PANEL_BODY).slideToggle(200);		
			
			if( !wrapper.children(PANEL_FOOTER).is(VISIBLE) ){	
				wrapper.children(PANEL_FOOTER).show();
			}			
			options.isMaximized = options.isMinimized = false;			
			return that;
		},
		render: function(){
			var that = this,
			wrapper = that.wrapper,
			options = that.options;
			wrapper.children(PANEL_BODY).html(options.content);		
		},	
		refresh: function(){
			var that = this,
			wrapper = that.wrapper,
			options = that.options;
			if( isFunction(options.handlers.refresh) ){
				options.handlers.refresh();				
			}			
			that.trigger(REFRESH, {target: that});			
		},		
		content:function(html, data){
		 	var content = this.wrapper.children(PANEL_BODY);
		 	if (!defined(html)) {
		 		return content.html();		 		
		 	}
		 	content.empty().html(html);
		 	kendo.bind(content, data);
		},
		destroy: function () {
			 Widget.fn.destroy.call(this);
			 this.unbind(undefined);
			 kendo.destroy(this.wrapper);
			 this.wrapper.empty().remove();
			 this.wrapper = this.appendTo = this.element = $();
		}
	});
	extend(ui , {	
		extPanel : common.ui.extPanel || extPanel
	});
	
})(jQuery);

;(function($, undefined) {
	var ui = common.ui,
	kendo = window.kendo, 
	Widget = kendo.ui.Widget,
	extend = $.extend,
	isPlainObject = $.isPlainObject,
	DataSource = kendo.data.DataSource,
	handleAjaxError = common.ui.handleAjaxError ;
	
	var Navigator = Widget.extend({		
		init : function(element, options) {			
			var that = this;
			Widget.fn.init.call(that, element, options);
			options = that.options;
			element = that.element;
			that.refresh();
		},
		options : {
			name : "Navigator"
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
	
	function navigator (options){
		options = options || {};				
		if( typeof options.renderTo === UNDEFINED ){
			options.renderTo = 'teleportation';			
		}				
		if ($("#" +options.renderTo ).length == 0) {
			$('body').append(	'<div id="' +options.renderTo + '" style="display:none;"></div>');
		}		
		if(! common.ui.exists$("#" +options.renderTo ) ){
			new Navigator( $("#" +options.renderTo ), options);
		}		
		return $("#" +options.renderTo ).data('kendoNavigator');
	}
	
	extend(common.ui, {
		navigator : navigator		
	});
	
})(jQuery);

;(function($, undefined) {
	
	var ui = common.ui,
	kendo = window.kendo, 
	Widget = kendo.ui.Widget, 
	isPlainObject = $.isPlainObject, 
	ObservableObject = kendo.data.ObservableObject,
	proxy = $.proxy, 
	extend = $.extend, 
	placeholderSupported = kendo.support.placeholder, 
	browser = kendo.support.browser, 
	isFunction = kendo.isFunction, 
	template = kendo.template,
	UNDEFINED = 'undefined',	
	AUTHENTICATE = "authenticate",
	SHOWN = "shown", 
	EXPAND = "expand",
	COLLAPSE = "collapse",
	ROLE_ADMIN = "ROLE_ADMIN", 
	ROLE_SYSTEM = "ROLE_SYSTEM", 	
	LOGIN_URL = "/login",
	CALLBACK_URL_TEMPLATE = kendo.template("#if ( typeof( externalLoginHost ) == 'string'  ) { #http://#= externalLoginHost ## } #/community/connect-socialnetwork.do?media=#= media #&domainName=#= domain #"), 
	AUTHENTICATE_URL = "/accounts/get-user.do?output=json",	
	guid = common.guid,
	ajax = ui.ajax,
	handleAjaxError = ui.handleAjaxError,
	defined = ui.defined,
	templates = {};
	
	var Accounts = Widget.extend({
		init : function(element, options) {
			var that = this,
			token = that.token = new common.ui.data.User(),
			content,
			id;			
			Widget.fn.init.call(that, element, options);
			options = that.options;			
			element = that.element;			
			content = that.content = options.content;			
			id = element.attr("id");			
			if( options.render ){
				if( defined(that.options.template) ){
					content = that.options.template(token);
				}
				if(options.allowToSignIn && element.is(":hidden")){
					element.show();					
				}
			}
			that.authenticate();
			kendo.notify(that);
		},
		options : {
			name : "ExtAccounts",
			allowToSignIn : false,
			allowToSignUp : false,
			render : true,
			content : "",
			messages : {
				title : "로그인",
				loginFail : "입력한 사용자 이름 또는 비밀번호가 잘못되었습니다.",
				loginError : "잘못된 접근입니다."			
			},
			expand: true
		},
		events : [ AUTHENTICATE, SHOWN, EXPAND, COLLAPSE ],		
		authenticate : function() {
			var that = this;
			ajax( that.options.url || AUTHENTICATE_URL, {
				success : function(response){
						var token = new common.ui.data.User($.extend( response.currentUser, { roles : response.roles }));
						token.set('isSystem', false);
						if (token.hasRole(ROLE_SYSTEM) || token.hasRole(ROLE_ADMIN))
							token.set('isSystem', true);			
						token.copy(that.token);	
						if( that.options.render && defined(that.options.template) ){
							that.content = that.options.template(that.token);
							that.refresh();
						}
						that.trigger(AUTHENTICATE,{ token : that.token });
				}
			});		
		},
		_fireExpendEvent : function (){
			var that = this;
			if($("body").hasClass("aside-menu-in") ){
				that.trigger(EXPAND);
			}else{
				that.trigger(COLLAPSE);
			}
		},
		refresh : function( ){			
			var that = this ,
			options = that.options,
			element = that.element,
			content = that.content ;									
			
			element.html(content);
			
			if( options.expand ){
				var aside= element.find('.navbar-toggle-aside-menu');	
				if( aside.length > 0 ){	
					var target = aside.attr("href");	
					if($(target).length == 0 )
					{
						var template = kendo.template($("#account-sidebar-template").html());
						$("body").append( template(that.token) );
					}						
					$( target + ' button.btn-close:first').click(function(e){
						
						$("body").toggleClass("aside-menu-in");
						that._fireExpendEvent();
					});						
					aside.click(function(e){
						$("body").toggleClass("aside-menu-in");
						that._fireExpendEvent();
						return false;							
					});							
				}
			}			
			that.trigger(SHOWN);
		}
	});
	
	function accounts (render, options){
		if( !render.data("kendoExtAccounts") )
		{
			return new Accounts(render, options);				
		}else{
			return render.data("kendoExtAccounts");
		}				
	}
	
	extend(ui, {
		accounts : common.ui.accounts || accounts		
	});
	
})(jQuery);
