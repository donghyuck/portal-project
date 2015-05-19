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

	function endsWith(source, suffix){
		return source.indexOf(suffix, source.length - suffix.length) !== -1;		
	}	
			
	function bytesToSize(bytes) {
		var sizes = ['Bytes', 'KB', 'MB', 'GB', 'TB'];
		    if (bytes == 0) return 'n/a';
		    var i = parseInt(Math.floor(Math.log(bytes) / Math.log(1024)));
		    if (i == 0) return bytes + ' ' + sizes[i]; 
		    return (bytes / Math.pow(1024, i)).toFixed(1) + ' ' + sizes[i];
	}
		
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

	function redirect (target, values, method){
		method = (method && method.toUpperCase() == 'GET') ? 'GET' : 'POST';
		
		if (!values)
		{
			var obj = $.parse_url(target);
			target = obj.url;
			values = obj.params;
		}
					
		var form = $('<form>').attr({
			method: method,
			action: target
		});
		
		for(var i in values)
		{
			$('<input>').attr({
				type: 'hidden',
				name: i,
				value: values[i]
			}).appendTo(form);

		}
		
		$('body').append(form);
		form.submit();		
	}
	
	function parseUrl ( url ){
		if (url.indexOf('?') == -1)
			return { url: url, params: {} }			
		var parts = url.split('?'),
			url = parts[0],
			query_string = parts[1],
			elems = query_string.split('&'),
			obj = {};
		
		for(var i in elems)
		{
			var pair = elems[i].split('=');
			obj[pair[0]] = pair[1];
		}
		return {url: url, params: obj};	
	}
			
	extend(common, {	
		ui: common.ui || {},
		random : common.random || random,
		guid : common.guid || guid,
		valid : common.valid || valid,
		bytesToSize : common.bytesToSize || bytesToSize,
		redirect : common.redirect || redirect,
		endsWith : common.endsWith || endsWith
	});
		
})(jQuery);


;(function($, undefined) {
	var ui = common.ui,
	random = common.random,
	isFunction = kendo.isFunction,
	guid = common.guid,
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
	UNDEFINED = "undefined",
	ERROR_MESSAGES = {
		'Forbidden' : "접근 권한이 없습니다.",	
		'timeout': "처리 대기 시간을 초가하였습니다. 잠시 후 다시 시도하여 주십시오.",
		'parsererror' : "데이터 파싱 중에 오류가 발생하였습니다."
	},
	STATUS_ERROR_MESSAGES = {
		'0' : "오프라인 상태입니다.",
		'404' : "요청하신 웹 페이지를 찾을 수 없습니다.",
		'405' : "웹 사이트에서 페이지를 표시할 수 없습니다.",
		'406' : "이 웹 페이지 형식을 읽을 수 없습니다.",
		'408' : "서버에서 웹 페이지를 표시하는 데 시간이 너무 오래 걸리거나 같은 페이지를 요청하는 사용자가 너무 많습니다. 나중에 다시 시도하여 주십시오.",
		'409' : "서버에서 웹 페이지를 표시하는 데 시간이 너무 오래 걸리거나 같은 페이지를 요청하는 사용자가 너무 많습니다. 나중에 다시 시도하여 주십시오.",
		'500' : "오류가 발생하였습니다.",
		'503' : "서비스 이용이 지연되고 있습니다. 잠시 후 다시 시도하여 주십시오.",
		'403' : "접근 권한이 없습니다. 권한이 필요한 경우 관리자에게 문의하십시오."			
	};
	
	function handleAjaxError(xhr) {		
		var message = "";		
		if( typeof xhr === STRING ){
			message = xhr;			
		} else {	
			var $xhr = xhr;
			if(  $xhr.xhr ){
				$xhr = $xhr.xhr;			
			}						
			if ($xhr.status == 0 || $xhr.status == 404 || $xhr.status == 503 || $xhr.status == 403 ) {				
				message = STATUS_ERROR_MESSAGES[$xhr.status];		
			} else if ($xhr.status == 500){				
				if( $xhr.responseJSON )
					message = $xhr.responseJSON.error.message;
				else	
					message = STATUS_ERROR_MESSAGES[$xhr.status];					
			} else if ( $xhr.errorThrown == "Forbidden" || $xhr.errorThrown == 'timeout' || $xhr.errorThrown == 'parsererror') {
				message = ERROR_MESSAGES[$xhr.errorThrown];						
			} else {				
				message = STATUS_ERROR_MESSAGES[500];	
			}	
			
		}
		
		$.jGrowl(message, {
			sticky : false,
			life : 3000,
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
		options = options || {};		
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
	
	function animate_v2 (renderTo, effect, done){		
		var options = options || {};		
		if( !renderTo.hasClass('animated')){
			renderTo.addClass('animated');			
		}		
		renderTo.addClass(effect).one(
			'webkitAnimationEnd mozAnimationEnd MSAnimationEnd oanimationend animationend',	
			function (e) {
				renderTo.removeClass('animated' + ' ' + effect  );
				if(isFunction(done))
					done();
			}
		);		
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
			morphing: false,
			dialog:false
		},
		wallpaper : {
			slideshow : true,
			fade : 0,
			duration : 5000
		},
		jobs: []
	};
	
	function setup (options) {
		options = options || {};
		return new Setup(options);		
	}
	
	function dialog (renderTo, options) {
		options = options || {};
		if(common.ui.exists(renderTo))
			return renderTo.data("kendoDialogFx");
		else
			return new DialogFx(renderTo, options);		
	}	
	
	var DialogFx = Widget.extend({
		init : function(element, options) {
			var that = this;
			Widget.fn.init.call(that, element, options);
			element = that.element;
			options = that.options;
			that.isOpen = false;
			kendo.notify(that);
			that.render();
		},
		options : {
			name : "DialogFx"
		},
		events : [ "open", "opened", "close", "closed" ],
		render : function() {
			var that = this,
			element = that.element,
			options = that.options;	
			
			
			var ctrlClose  = element.find("[data-dialog-close]");
			ctrlClose.click(function(e){
				that.close();				
			});
			
			if( options.autoBind  ){
				kendo.bind( element , that.options.data );				
			}
			
		},
		data : function( data ){
			var that = this;
			if( defined(data)){
				that.options.data = data;
			}else{
				return that.options.data;
			}
		},		
		close : function(){
			var that = this,
			element = that.element,
			options = that.options;		
			if( that.isOpen ){
				element.removeClass("dialog--open");
				element.addClass("dialog--close");
				that.isOpen = false;				
				that.trigger("close");
				
				var content = element.children(".dialog__content");
				content.one( "webkitAnimationEnd oanimationend msAnimationEnd animationend", function(e) {
					element.removeClass("dialog--close");			
					that.trigger("closed");
				});				

			}
		},
		open : function(){
			var that = this,
			element = that.element,
			options = that.options;			
		
			if( !that.isOpen )
			{
				element.addClass("dialog--open");
				var content = element.children(".dialog__content");
				content.one( "webkitAnimationEnd oanimationend msAnimationEnd animationend", function(e) {
					that.trigger("opened");
				});
				that.isOpen = true;
				that.trigger("open");				
			}
		}
	});		
	
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
			if(features.landing){				
				landing();
			}
			if(defined(features.accounts)){
				common.ui.accounts(features.accounts);				
			}			
			if(features.wallpaper){
				backstretch(options.wallpaper);
			}
			if(features.spmenu){				
				spmenu();
			}
			
			if(features.lightbox){				
				lightbox();
			}
			if(features.morphing){				
				$(document).on("click","[data-toggle='morphing'], [data-action='morphing']", function(e){
					var target ,
					$this = $(this);					
					if( $this.data("target")){
						target = $($this.data("target"));
					}else{
						target = $(this).closest(".morphing");
					}
					target.trigger(e = $.Event('open.morphing'))
					target.toggleClass("open");
				});
			}		
			if(features.dialog){
				$(document).on("click", "[data-feature=dialog]", function(e){
					var target ,
					$this = $(this);
					
					
					
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
	
	function backstretch( options ){
		var options = options || {}, 
		template = options.template || kendo.template("/download/streams/photo/#= externalId#"),
		pageSize = options.pageSize || 10 ,
		maxPages = options.maxPages || 5;
		renderTo = $("body");
		
		if( defined( options.renderTo) ){
			renderTo = options.renderTo ;
		}		
		
		if( !defined( renderTo.data('backstretch') ) ){			
			//renderTo.backstretch( [], { duration: options.duration || 6000, fade: options.fade || 750});			
			var dataSource = options.dataSource || datasource( "/data/streams/photos/list_with_random.json?output=json", {
				pageSize: pageSize,
				schema: {
					total: "totalCount",
					data: "photos"
				},
				change : function(e){			
					var $this = this;
					var startIndex = 0 ;
					var page = $this.page();
					var pageSize = $this.pageSize();
					var totalPages = $this.totalPages();			
					if( defined( renderTo.data('backstretch') ) && page > 1 ){
						each($this.view(), function(idx, photo){
						renderTo.data('backstretch').images.push(template(photo));
						});							
					}					
					if( (page < maxPages && totalPages - page)  > 0 ){
						$this.page( page + 1 );
						$this.read();						
					}
				}
			}).fetch(function(){
				var data = this.data(), images = [];
				each(data, function(idx, photo){
					images.push(template(photo));	
				}); 
				renderTo.backstretch( images, { duration: options.duration || 6000, fade: options.fade || 750});	
			});
		}
	} 
	
	function wallpaper (options){		
		if(!defined($.backstretch)) {
			return;
		}	
		options = options || {},
		template = options.template || kendo.template("/download/streams/photo/#= externalId#"),
		dataSource = options.dataSource || datasource( "/data/streams/photos/list_with_random.json?output=json", {
			pageSize: 15,
			schema: {
				total: "totalCount",
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
		
		
		
		$(document).on("click","[data-feature-name='spmenu']", function(e){
			var $this = $(this) , target_object ;
			if( $this.prop("tagName").toLowerCase() == "a" ){			
				target_object  = $($this.attr("href"));	
			}else{
				if($this.data("target-object-id")){
					target_object = $("#" + $this.data("target-object-id"));
				}
			}
			$("body").css("overflow-y" , "hidden");
			target_object.trigger("open");
			target_object.toggleClass("cbp-spmenu-open");	
		});
		
		$(document).on("click","[data-dismiss='spmenu']", function(e){
			
			var $this = $(this);			
			var target  = $this.closest(".cbp-spmenu");
			
			$("body").css("overflow-y" , "auto");			
			if($this.data("target-object-id")){
				var target = $($this.data("target-object"));
				if(target.is(".active") )
					targetremoveClass("active");
			}
			target.trigger("close");
			target.toggleClass("cbp-spmenu-open");
		});
	}
	
	function lightbox (){		
		
		if(!defined($.magnificPopup)) {
			return false;
		}		
		
		$(window).on('load', function () {
			$('[data-ride="owl-carousel"]').each(function () {
				var $carousel = $(this);
				
				alert( $carousel.html() );
			});
		});
		
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

	var DEFAULT_NOTIFICATION_SETTING = {
		autoHideAfter : 5000,
		position : {	pinned : true, top : 10, right : 10 },	
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
	};
	
	function notification (options) {
		options = options || {};
		var uid = guid();
		var renderToString = "#" + uid ;
		if ($(renderToString).length == 0) {
			$('body').append(	'<span id="' + uid + '" style="display:none;"></span>');
		}
		var settings = extend(true, {}, DEFAULT_NOTIFICATION_SETTING , options ); 
		var renderTo = $(renderToString) ;
		if (!renderTo.data("kendoNotification")) {
			renderTo	.kendoNotification(settings);
		}
		return renderTo.data("kendoNotification");
	};
	
	function error ( e ){
				
		handleAjaxError(e.xhr);
	}

	extend(ui , {	
		handleAjaxError : common.ui.handleAjaxError || handleAjaxError,
		error : error,
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
		dialog : common.ui.dialog || dialog,
		enable: common.ui.enable || enable,
		disable: common.ui.disable || disable,
		buttons : common.ui.buttons || buttons,
		animate : common.ui.animate || animate,
		animate_v2 : common.ui.animate_v2 || animate_v2,
		fx : kendo.fx,
		bind : kendo.bind,
		stringify : kendo.stringify,
		template : kendo.template,
		upload : common.ui.upload || upload,
		observable : kendo.observable,
		exists : exists,
		setup : common.ui.setup || setup,
		backstretch : common.ui.backstretch || backstretch,
		data : common.ui.data || {},
		notification : common.ui.notification || notification,
		connect : common.ui.connect || {}
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
	guid = common.guid,
	ajax = ui.ajax,
	handleAjaxError = ui.handleAjaxError,
	defined = ui.defined,
	AUTHENTICATE = "authenticate",
	SHOWN = "shown", 
	EXPAND = "expand",
	COLLAPSE = "collapse",
	AUTHENTICATE_URL = "/data/accounts/get.json?output=json",
	ROLE_ADMIN = "ROLE_ADMIN", 
	ROLE_SYSTEM = "ROLE_SYSTEM", 		
	templates = {
		photoCss : template("url( '/download/profile/#= username #?width=150&height=150' )")
	};
	
	function accounts( options ){		
		var options = options || {},
		applyTo = options.applyTo || $("#u-navbar"),
		renderTo = applyTo.find("[data-feature-name='u-accounts']") ;
		if( renderTo.length == 1  ){
			// html  exist 			
		}else{
			// html not exist. 
			// append			
		}
		
		if( !renderTo.data("kendoUserAssistanceBar") )
		{
			return new UserAssistanceBar(renderTo, options);				
		}else{
			return renderTo.data("kendoUserAssistanceBar");
		}				
	}	
	
	var UserAssistanceBar = Widget.extend({
		init : function(element, options) {
			var that = this,
			token = that.token = new common.ui.data.User();
			Widget.fn.init.call(that, element, options);
			element = that.wrapper = that.element;
			options = that.options;
			that.authenticate();
			kendo.notify(that);
		},
		options : {
			name : "UserAssistanceBar",
			allowToSignIn : false,
			allowToSignUp : false,
		},
		events : [ AUTHENTICATE, SHOWN, EXPAND, COLLAPSE ],
		authenticate : function() {
			var that = this;
			ajax( that.options.url || AUTHENTICATE_URL , {
				success : function(response){
						var token = new common.ui.data.User(extend( response.user, { roles : response.roles }));
						token.set('isSystem', false);
						if (token.hasRole(ROLE_SYSTEM) || token.hasRole(ROLE_ADMIN))
							token.set('isSystem', true);			
						token.copy(that.token);	
						that.refresh();
						that.trigger(AUTHENTICATE,{ token : that.token });
				}
			});
		},
		_toggle : function (){
			var that = this;			
			$("body").toggleClass("aside-menu-in");
			
			if($("body").hasClass("aside-menu-in") ){
				that.trigger(EXPAND);
			}else{
				that.trigger(COLLAPSE);
			}
		},
		refresh : function (){
			var that = this,
			token = that.token,
			element = that.element;		
			if( token.anonymous ){
				if ( element.is(":visible") )
					element.hide();
			}else{
				element.children(".u-accounts-name").html( token.get("name") );
				element.children(".u-accounts-photo").css("background-image", templates.photoCss(token) );
				if( $("#" + token.uid ).length === 0 ){	
					var template = kendo.template($("#account-sidebar-template").html());					
					$("body").append( template( token) );										
					$( "#" + token.uid  + ' button.btn-close:first').click(function(e){						
						that._toggle();
						return false;
					});							
					element.click(function(e){						
						that._toggle();
						return false;
					});
				}				
			}
			if ( !token.anonymous &&  element.is(":hidden") )
				element.show();
			
			that.trigger(SHOWN);
		}
	});
	
	extend(ui, {
		accounts : common.ui.accounts || accounts		
	});
	
})(jQuery);
/**
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
**/

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
		select: function( value ){
			var that = this;
			if (that.radio) {
				if( value != that.value ){
					that.element.find("input[type='radio'][value='"+ value +"']"	).click();			
				}						 
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
			}
			
			wrapper.find("button[data-action='scrollTop']").click(function(e){
				common.ui.scroll.top(wrapper);			
			});
			
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

/**
 * Image Broswer for kendoui editor;
 */
(function($, undefined) {
	var kendo = window.kendo, 
		Widget = kendo.ui.Widget, 
		isPlainObject = $.isPlainObject, 
		ui = common.ui,
		defined = common.ui.defined,
		ajax = common.ui.ajax,
		guid = common.guid,
		proxy = $.proxy, 
		extend = $.extend, 
		template = kendo.template,
		placeholderSupported = kendo.support.placeholder, 
		browser = kendo.support.browser, 
		isFunction = kendo.isFunction, 
		handleAjaxError = ui.handleAjaxError,
		trimSlashesRegExp = /(^\/|\/$)/g, 
		USER_OBJECT_TYPE = 2 ,
		COMPANY_OBJECT_TYPE = 1,
		WEBSITE_OPBJECT_TYPE = 30,
		PAGE_OPBJECT_TYPE = 31,
		CHANGE = "change", 
		APPLY = "apply", 
		ERROR = "error", 
		CLICK = "click", 
		UNDEFINED = 'undefined',
		POST = 'POST', 
		JSON = 'json', 
		templates = {
			selected : template(
				'<div class="img-wrapper"><img src="/download/image/#= imageId #/#= name #?width=150&height=150" alt="#=name#" class="img-responsive animated slideInUp" data-id="#=imageId#"></div>'
			),
			carousel : template(
				'<div id="#= uid #" class="carousel slide" data-ride="carousel">'	
					
				+ '<div class="carousel-inner" role="listbox">'	
				+ '</div>'	
				+ '</div>'	
			),
			image : template('<img src="#: url #" class="#= css #" #if(lightbox){# data-ride="lightbox" #}# #if(gallery){# data-gallery #}#  #if(uid){# data-uid="#=uid#" #}#  />'),
			linkUrl : template('/download/image/#= linkId #'),
			download : template('/download/image/#=imageId#/#=name#')
		},
		handleAjaxError = common.ui.handleAjaxError;
	
	function createImagePanel(element, objectType, objectId, changeState, changeStateEl, options){
		var my_selected = element.find(".image-selected");
		var my_list_view =  element.find(".image-listview");
		var my_list_pager =  element.find(".image-pager");
		var my_page_size = options.pageSize || 13;
		if( !common.ui.exists(my_list_view)){
			var listview = my_list_view.kendoListView({
				dataSource : {
					type :JSON,
					transport : {
						read : {
							url : '/data/images/list.json?output=json',
							type : POST
						},
						parameterMap : function(	options, operation) {
							if (operation != "read" && options) {
								return {};
							} else {
								return {
									objectType: objectType,	
									objectId: objectId || 0,	
									startIndex : options.skip,
									pageSize : options.pageSize
								}
							}
						}
					},
					pageSize : my_page_size,
					error : handleAjaxError,
					schema : {
						model : common.ui.data.Image,
						data : "images",
						total : "totalCount"
					},
					serverPaging : true					
				},
				selectable : "multiple",
				change : function(e) {
					var that = this;
					var data = this.dataSource.view();	
					var selectedCells = this.select();	    
					if( selectedCells.length > 0 ){											
						$.each(selectedCells, function( index, value ){
							var idx = $(value).index();
							var item = data[idx];
							addImageTo(my_selected, item);
						});
						changeState(changeStateEl, true);		
					}
				},
				navigatable : false,
				template : kendo.template($("#image-broswer-photo-list-view-template").html()),
				dataBound : function(e) {
					if(isFunction(changeState))
						changeState(changeStateEl, false);
				}				
			});			
			my_list_view.on("mouseenter", ".img-wrapper", function(e) {
				kendo.fx($(e.currentTarget).find(".img-description")).expand("vertical").stop().play();
			}).on(	"mouseleave", ".img-wrapper",function(e) {
				kendo.fx($(e.currentTarget).find(".img-description")).expand("vertical").stop().reverse();
			});			
			my_list_pager.kendoPager({refresh : true, buttonCount : 5, 	dataSource : my_list_view.data('kendoListView').dataSource });		
		}else{
			my_list_view.data('kendoListView').clearSelection();			
			if(isFunction(changeState))
				changeState(changeStateEl, false);
		}			
	}
	
	function refreshListViewDataSource ( el ){
		if( el.find('.k-listview').length > 0 ){				
			if( common.ui.exists( el.find('.k-listview') ) ){
				common.ui.listview( el.find('.k-listview') ).dataSource.read();
			}
		}
	}
	
	function addImageTo( el, image ){
		if( el.find( "[data-id=" + image.imageId + "]").length === 0 ){
			el.append(templates.selected(image));	
			el.find( "[data-id=" + image.imageId + "]").click( function(e){
				var $this = $(this);
				$this.removeClass("slideInUp");
				common.ui.animate_v2($this, "rollOut" , function(){
					$this.parent().remove();
				});				
			});
		}	
	}
	
		var ExtImageBrowser = Widget.extend({
			init : function(element, options) {
				var that = this;
				Widget.fn.init.call(that, element, options);
				options = that.options;	
				options.guid = [guid().toLowerCase(), guid().toLowerCase(), guid().toLowerCase(),guid().toLowerCase(),guid().toLowerCase(),guid().toLowerCase()];				
				that.refresh();
			},
			events : [ ERROR, CHANGE, APPLY ],
			options : {
				name : "ExtImageBrowser",
				title: null,
				transport : {},
				pageSize : 12,
				objectId : 0,
				objectType : 0
			},
			show : function() {				
				var that = this;								
				if(that.objectId() > 0 ){
					that.element.find('.modal-body ul.nav a:first').show();
				}else{
					that.element.find('.modal-body ul.nav a:first').hide();
				}	
				that.element.find(".image-selected").html("");				
				that.element.find(".modal-body ul.nav a").filter(function(){ 
					if( that.objectId() > 0 ){
						refreshListViewDataSource($("#"+ that.options.guid[0]));
						return $(this).attr("href") === ("#"+ that.options.guid[0]) ;	
					}else{
						refreshListViewDataSource($("#"+ that.options.guid[1]));
						return $(this).attr("href") === ("#"+ that.options.guid[1]) ;	
					}
				}).tab('show');
				
				$("#" + that.options.guid[5]).collapse('hide');
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
			objectType: function(objectType){
				var that = this;
				if( typeof objectType === 'number' ){
					that.options.objectType = objectType ;
				}else{
					return that.options.objectType;
				}				
			},
			objectId : function( objectId) {
				var that = this;
				if( typeof objectId === 'number' ){
					that.options.objectId = objectId ;
				}else{
					return that.options.objectId;
				}	
			},
			_getImageLink : function(image, callback) {
				ajax("/data/images/link.json?output=json", {
					data : { imageId : image.imageId },	
					success : function(data) {						
						callback(data);
					}					
				});
			},
			_modal : function() {
				var that = this;
				return that.element.children('.modal');
			},
			_createDialog : function() {
				var that = this;
				var template = that._dialogTemplate();			
				that.element.html(template( that.options ));
				that.element.children('.modal').css('z-index', '2000');				
				var my_insert_btn = that.element.find(	'.modal-footer .btn.custom-insert-img');
				var my_insert_options = $("#" + that.options.guid[5]);
				var my_insert_options_up = $("#" + that.options.guid[5] +" .btn-up");	
				
				// tabs events
				that.element.find('.modal-body a[data-toggle="tab"]').on('shown.bs.tab', function(e) {					
					e.target // activated tab
					e.relatedTarget // previous tab					
					var tab_pane_id = $(e.target).attr('href');
					var tab_pane = $(tab_pane_id);								
					var my_selected = tab_pane.find(".image-selected");
					var my_list_view =  tab_pane.find(".image-listview");
					var my_list_pager =  tab_pane.find(".image-pager");			
					that._changeState(my_insert_btn, false);					
					switch (tab_pane_id) {
						case "#" + that.options.guid[0]:					
							if( that.objectId() > 0 && that.objectType() > 0){			
								if (!my_list_view.data('kendoListView')) {
									my_list_view.kendoListView({
										dataSource : {
											type : 'json',
											transport : {
												read : {
													url : '/data/images/list.json?output=json',
													type : 'POST'
												},
												parameterMap : function(options, operation) {
													return {
														startIndex : options.skip,
														pageSize : options.pageSize,
														objectType : that.objectType(),
														objectId : that.objectId()
													}
												}
											},
											pageSize : that.options.pageSize,
											error : handleAjaxError,
											schema : {
												model : common.ui.data.Image,
												data : "images",
												total : "totalCount"
											},
											serverPaging : true
										},
										selectable : "multiple",
										change : function(e) {	
											var data = this.dataSource.view();	
											 var selectedCells = this.select();	    
											if( selectedCells.length > 0 ){											
												$.each(selectedCells, function( index, value ){
													var idx = $(value).index();
													var item = data[idx];
													addImageTo(my_selected, item);
												});
												that._changeState(my_insert_btn, true);					
											}
										},
										navigatable : false,
										template : kendo.template($("#image-broswer-photo-list-view-template").html()),
										dataBound : function(e) {
											my_selected.html("");
											that._changeState(my_insert_btn, false);
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
								
								my_list_view.data('kendoListView').dataSource.read();	
								
								var my_file_upload = tab_pane.find("input[type=file]");		
								
								if( !common.ui.exists(my_file_upload) ){
									common.ui.upload(my_file_upload,{
										async: {
											saveUrl:  '/data/images/update_with_media.json?output=json'
										},
										upload: function(e){
											e.data = {
												objectType: that.objectType(),
												objectId: that.objectId()
											};
										},
										error : handleAjaxError,
										success : function(e) {	
											my_list_view.data('kendoListView').dataSource.read();	
										}		
									});		
								}	
							}					
							break;
						case "#" + that.options.guid[1]:
							createImagePanel(tab_pane, USER_OBJECT_TYPE, 0 , that._changeState, my_insert_btn, that.options );
							break;
						case "#" + that.options.guid[2]:
							createImagePanel(tab_pane, WEBSITE_OPBJECT_TYPE, 0 , that._changeState, my_insert_btn, that.options);
							break;
						case "#"+ that.options.guid[3]:
							createImagePanel(tab_pane, COMPANY_OBJECT_TYPE, 0 , that._changeState, my_insert_btn, that.options);
							break;
						case "#" + that.options.guid[4]:
							var form_input = that.element.find('.modal-body input[name="custom-selected-url"]');
							var selected_img = $("#" + that.options.guid[4]).children('img');
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
					that.element.find('.modal-body input[name="custom-selected-url"]').on( 'change',
					function() {
						var form_input = $(this);
						var selected_img = $("#"+ that.options.guid[4]).children('img');
						if (form_input.val().length == 0) {
							if (!selected_img.hasClass('hide'))
								selected_img.addClass('hide');
								if (form_input.parent().hasClass('has-error'))
									form_input.parent().removeClass('has-error');
								if (form_input.parent().hasClass('has-success'))
									form_input.parent().removeClass('has-success');
								that._changeState(my_insert_btn, false);
							} else {
								selected_img.attr('src',form_input.val()).load(
									function() {
										if (form_input.parent().hasClass('has-error'))
											form_input.parent().removeClass('has-error');
										form_input.parent().addClass('has-success');
										selected_img.removeClass('hide');
										that._changeState(my_insert_btn, true);
									}).error(
										function() {
											if (!selected_img.hasClass('hide'))
												selected_img.addClass('hide');
											if (form_input.parent().hasClass('has-success'))
												form_input.parent().removeClass('has-success');
											form_input.parent().addClass('has-error');
											that._changeState(my_insert_btn, false);
								});
							}		
					});
					
					// handle insert 		
					my_insert_btn.on('click', function() {						
					var active_pane = that._activePane();
					var active_pane_id	= active_pane.attr('id');			
					switch (active_pane_id) {
						case that.options.guid[4]:
							var selected_url = that.element.find('.modal-body input[name="custom-selected-url"]').val();
							if( selected_url.length > 0){
								that.trigger(APPLY, { html : templates.image({ url : selected_url }) });
								that._changeState(my_insert_btn, false);
							}
						break;
						default:			
							var active_list_view =  active_pane.find(".image-listview");
							var active_datasource = active_list_view.data('kendoListView').dataSource;		
							var active_my_selected = active_pane.find(".image-selected");
							
							var custom_effect = $("[name=image-radio-effect]:checked").val();							
							var lightbox_enabled = false;
							var carousel_enabled = false;
							if( custom_effect === "lightbox" ){
								lightbox_enabled = true;
							}else if( custom_effect === 'carousel') {
								carousel_enabled = true;
							}							
							
							var thumbnail_enabled = my_insert_options.find("input[name=image-checkbox-thumbnail]").is(":checked");
							var gallery_enabled = my_insert_options.find("input[name=image-checkbox-gallery]").is(":checked");							
							
							var uid = guid().toLowerCase() ;	
							
							if( carousel_enabled ){
								var carousel_template = kendo.template($('#image-broswer-photo-carousel-template').html());
								var carousel_inner_template = kendo.template($("#image-broswer-photo-carousel-inner-template").html());						
								var carousel_indicators_template = kendo.template($("#image-broswer-photo-carousel-indicators-template").html());									
								var html = $( carousel_template({ 'uid': uid }));
								var carousel_inner = html.find(".carousel-inner");						
								var carousel_indicators = html.find(".carousel-indicators");								
								var total = active_my_selected.find("img").length;
								$.each( active_my_selected.find("img"), function( index, value){
									var objectEl = $(value);
									var objectId = objectEl.data("id");
									var image = active_datasource.get(objectId);
									that._getImageLink(image, function(data){
										if(!defined(data.error)){
											carousel_inner.append(
												carousel_inner_template({ 
													url: templates.linkUrl( data ),													
													thumbnail : thumbnail_enabled,
												})		
											);
											carousel_indicators.append(
												carousel_indicators_template({
													'uid':uid, 
													'index':index,
													thumbnaiUrll : objectEl.attr('src')
												})	
											);
											if( index === total -1  )
											{
												html.find('.carousel-indicators>li').first().addClass('active');
												html.find('.carousel-inner>.item').first().addClass('active');
												
												
												that.trigger(APPLY, { 'html' : html[0].outerHTML });
											}
										}
									});									
								});	
							}else{
								$.each( active_my_selected.find("img"), function( index, value){
									var objectEl = $(value);
									var objectId = objectEl.data("id");
									var image = active_datasource.get(objectId);
									that._getImageLink(image, function(data){
										if(!defined(data.error)){
											that.trigger(APPLY, { 
												html : templates.image({ 
													url: templates.linkUrl( data ),
													thumbnail : thumbnail_enabled,
													lightbox : lightbox_enabled,
													gallery : gallery_enabled,
													gallerySelector : uid,
													thumbnaiUrll : objectEl.attr('src'),
													css : "img-responsive" 
												})
											});										
										}
									})
								});									
							}
					}
				});	

					my_insert_options_up.click(function(e){
						my_insert_options.collapse('hide');
					});
					my_insert_options.on('show.bs.collapse', function () {
					});
					
					my_insert_options.on('hide.bs.collapse', function () {
					});
					
			},
			_activePane : function() {
				var that = this;
				return that.element.find('.tab-content > .tab-pane.active');
			},
			_changeState : function(changeStateEl, enabled) {
				var that = this;				
				if(!defined(changeStateEl)){
					changeStateEl = that.element.find(	'.modal-footer .btn.custom-insert-img');					
				}
				if (enabled) {
					changeStateEl.removeAttr('disabled');
				} else {
					changeStateEl.attr('disabled', 'disabled');
				}
			},
			_dialogTemplate : function() {
				var that = this;
				if (typeof that.options.template === UNDEFINED) {
					return kendo.template(
						"<div class='modal fade'>"	+ 
						"<div class='modal-dialog modal-lg'>" + 
						"<div class='modal-content'>" + 
						"<div class='modal-header'>" + 
						"<button type='button' class='close' data-dismiss='modal' aria-hidden='true'>&times;</button>" + 
						"<h5 class='modal-title'>#if( title ){# #: title # #} else { # 이미지 삽입 #}#</h5>" + 
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
			return new ExtImageBrowser(this, options);
		}
	});
})(jQuery);
(function($, undefined) {
	var kendo = window.kendo, Widget = kendo.ui.Widget, 
	isPlainObject = $.isPlainObject, proxy = $.proxy, extend = $.extend, placeholderSupported = kendo.support.placeholder, browser = kendo.support.browser, isFunction = kendo.isFunction, 
	trimSlashesRegExp = /(^\/|\/$)/g, CHANGE = "change", ERROR = "error", REFRESH = "refresh", OPEN = "open", CLOSE = "close", CLICK = "click", 
	UNDEFINED = 'undefined', POST = 'POST', 
	JSON = 'json', 
	handleAjaxError = common.ui.handleAjaxError;

	var ExtModalWindow = Widget.extend({
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

	function modal (options){
		options = options || {};	
		if( typeof options.renderTo === "string" ){
			if( $("#"+options.renderTo).length === 0 ){
				$('body').append("<section id='"+ options.renderTo  +"'></section>");
			}
			if( !$("#"+options.renderTo).data("kendoExtModalWindow") ){
				return new ExtModalWindow($("#"+options.renderTo), options);
			}else{
				return $("#"+options.renderTo).data("kendoExtModalWindow");
			}
		}
	} 
	
	$.fn.extend( common.ui, {
		"modal" : modal		
	});
	
	$.fn.extend({
		extModalWindow : function(options) {
			return new ExtModalWindow(this, options);
		}
	});
})(jQuery);

/**
 * extEditorPopup widget
 */
(function($, undefined) {
	var kendo = window.kendo, 
	Widget = kendo.ui.Widget, 
	isPlainObject = $.isPlainObject, 
	proxy = $.proxy, 
	extend = $.extend, 
	placeholderSupported = kendo.support.placeholder, 
	browser = kendo.support.browser, 
	isFunction = kendo.isFunction, 
	trimSlashesRegExp = /(^\/|\/$)/g, 
	CHANGE = "change", APPLY = "apply", ERROR = "error", CLICK = "click", UNDEFINED = 'undefined', POST = 'POST', JSON = 'json', 
	LINK_VALUE_TEMPLATE = kendo.template('<a href="#: linkUrl #" title="#: linkTitle #" #if (linkTarget) { # target="_blank"  # }#>#= linkTitle #</a>'), handleAjaxError = common.ui.handleAjaxError;

	var ExtEditorPopup = Widget
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
			return new ExtEditorPopup(this, options);
		}
	});
})(jQuery);