/**
 * COMMON UI MY
 * dependency : jquery
 */
;(function($, undefined) {
	var kendo = window.kendo, 
	ui = kendo.ui, 
	Widget = ui.Widget, 
	extend = $.extend, 
	guid = common.guid, 
	template = kendo.template, 
	ajax = common.ui.ajax, 
	progress = kendo.ui.progress,
	defined = common.ui.defined ;
    
	var DialogSwitcher =  Widget.extend({
		// initialization code goes here
		init: function(element, options) {
			var that = this;
			Widget.fn.init.call(that, element, options);
			options = that.options;
			that.isOpen = false;
			kendo.notify(that);
			that.render();
	    },
	    options: {
	    	name:"DialogSwitcher",
	    	animate : true	
	    },
	    events : [ "open", "opened", "close", "closed" ],
	    render : function() {
	    	var that = this,
			element = that.element,
			options = that.options;
	    	
	    	var ctrlClose  = element.find("[data-dialog-close]");
			ctrlClose.click(function(e){				
				var content = element.children(".dialog-switcher-content");
				content.addClass("animated fadeOutUp");
				content.one( "webkitAnimationEnd oanimationend msAnimationEnd animationend", function(e) {
					content.removeClass("animated fadeOutUp");	
					that.close();	
				});		
			});
	    },
	    close : function(){
			var that = this,
			element = that.element,
			options = that.options;
			if( that.isOpen ){
				var content = element.children(".dialog-switcher-content");
				element.removeClass("dialog-switcher-open");
				that.isOpen = false;				
				that.trigger("closed");
			}			
	    },
	    open : function(){
			var that = this,
			element = that.element,
			options = that.options;			

			if( !that.isOpen )
			{				
				var content = element.children(".dialog-switcher-content");
				content.addClass("animated fadeInDown");
				element.addClass("dialog-switcher-open");
				content.one( "webkitAnimationEnd oanimationend msAnimationEnd animationend", function(e) {
					content.removeClass("animated fadeInDown");	
					that.trigger("opened");
				});
				that.isOpen = true;
				that.trigger("open");				
			}			
	    }	
    });
	
	
	function MasonryLayout( items, renderTo, callback ){
		var uid = guid().toLowerCase() ;	
		var masonry_template = template($('#image-broswer-photo-masonry-template').html());
		var masonry_item_template = template($('#image-broswer-photo-masonry-item-template').html());
		var thumbnail_url_template = template('/download/image/#= imageId #/#= name #?width=150&height=150');		
		var image_url_template = template('/download/image/#= linkId #');
		
		var html = $( masonry_template({ 'uid':uid }) );
		var total = items.length;
		var count = 0;
		kendo.ui.progress(renderTo, true);
		$.each( items, function(index, value){			
			console.log( kendo.stringify (value) );
			var image = value;
			ajax("/data/images/link.json?output=json", {
				data : { imageId : image.imageId },	
				success : function(data) {		
					if(!defined(data.error)){
						image.set("imageUrl",  image_url_template( data ) );		
						image.set("thumbnailUrl",  thumbnail_url_template( data ) );		
					}
					count ++ ;
					if( count === total )
					{			
						var idx = 0;
						$.each( items , function(idx, val){							
							html.append(
								masonry_item_template(val)	
							);							
						});
						
						if(defined(callback)){
							callback(html[0].outerHTML);
						}
						kendo.ui.progress(renderTo, false);
					}	
				}
			});	
		});		
	} 
	
	function CarouselSlide( items, renderTo, callback ){
		var uid = guid().toLowerCase() ;		
		var carousel_template = template($('#image-broswer-photo-carousel-template').html());
		var carousel_inner_template = template($("#image-broswer-photo-carousel-inner-template").html());						
		var carousel_indicators_template = template($("#image-broswer-photo-carousel-indicators-template").html());	
		var thumbnail_url_template = template('/download/image/#= imageId #/#= name #?width=150&height=150');		
		var image_url_template = template('/download/image/#= linkId #');
		var html = $( carousel_template({ 
			'uid':uid ,
			'width':null
		}));
		
		var carousel_inner = html.find(".carousel-inner");						
		var carousel_indicators = html.find(".carousel-indicators");		
		var total = items.length;
		var count = 0;
		
		//console.log( total );
		
		kendo.ui.progress(renderTo, true);
		$.each( items, function(index, value){			
			console.log( kendo.stringify (value) );
			var image = value;
			ajax("/data/images/link.json?output=json", {
				data : { imageId : image.imageId },	
				success : function(data) {		
					if(!defined(data.error)){
						image.set("linkUrl",  image_url_template( data ) );						
					}
					count ++ ;
					if( count === total )
					{
						
						var idx = 0;
						$.each( items , function(idx, val){
							carousel_indicators.append(
									carousel_indicators_template({
										'active': idx === 0,
										'uid':uid, 
										'index':idx,
										thumbnail : true,
										thumbnailUrl : thumbnail_url_template(val)
									})	
								);
							carousel_inner.append(
									carousel_inner_template({ 
										'active': idx === 0,
										'index':idx,
										'uid':uid, 
										url: val.linkUrl,																	
										thumbnail : true
									})		
								);
							idx ++;							
						});
						
						
						if(defined(callback)){
							callback(html[0].outerHTML);
						}
						//alert( html[0].outerHTML );
						kendo.ui.progress(renderTo, false);
					}	
				}
			});	
		});	
	}
	
	extend(common.ui, {	
		CarouselSlide : CarouselSlide,
		MasonryLayout : MasonryLayout,
		DialogSwitcher : DialogSwitcher
	});
	
	
	common.ui.options = common.ui.options || {};
	common.ui.options.messages = extend( common.ui.options.messages, {			
		title : {
			image : "무엇에 대한 사진인가요?",
			text : "무엇에 대한 글인가요?",
			link : "무엇에 대한 웹 페이지인가요?"
		},
		bodyText : {
			quote : "<blockquote><p>인용구</p><footer>출처</footer></blockquote>"			
		}
	});
	
	
	
})(jQuery);




function isCarouselSlideLayout(page){
	if(page.properties.postType && page.properties.imageEffect ){
		if( page.properties.postType === 'photo' && page.properties.imageEffect === 'carousel' ){
			return true;
		}
	}
	return false;	
}

function isMasonryLayout(page){
	//console.log(page.properties);
	if(page.properties.imageEffect ){
		if( page.properties.imageEffect === 'masonry' ){
			return true;
		}
	}
	return false;	
}

function preparePersonalizedArea( element, minCount, colSize ){	
	
	var template = kendo.template("<div id='#= guid #' class='personalized-panels-group col-sm-#= colSize#'></div>");
	
	for ( var  i = 1 ; i < minCount + 1 ; i ++  )
	{
		element.append( 
			template({
				guid: common.guid().toLowerCase(),
				colSize: colSize
			})
		);		
	}		
	element.data("sizePlaceHolder", { oldValue: colSize , newValue : colSize} );		
	$("input[name='personalized-area-col-size']").bind("change", function(e){
		var grid_col_size = element.data("sizePlaceHolder");
		grid_col_size.oldValue = grid_col_size.newValue;
		grid_col_size.newValue = this.value;			
		$(".personalized-panels-group").each(function( index ) {
			var personalized_panels_group = $(this);				
			personalized_panels_group.removeClass("col-sm-" + grid_col_size.oldValue );		
			personalized_panels_group.addClass("col-sm-" + grid_col_size.newValue );		
		});
	});	
}

function preparePage(options){
	options = options || {};
	if( common.ui.defined(options.navbar.parent) && common.ui.defined(options.navbar.current))
		$(".navbar-nav li[data-menu-item='"+options.navbar.parent+"'], .navbar-nav li[data-menu-item='"+options.navbar.current+"']").addClass("active");	
	if(options.personalizedSection){
		if ( common.ui.defined(options.personalizedSection.renderTo )){
			var count = options.personalizedSection.count || 3;
			var size = options.personalizedSection.size || 6;
			preparePersonalizedArea(options.personalizedSection.renderTo, count, size);
		}	
	}
}

function setupPersonalizedSection(){	
	$("section.personalized-section").each(function(index){
		var $section = $( this );		
		var section_heading = $section.children(".personalized-section-heading");
		var section_content = $section.children(".personalized-section-content");

		$section.find(".personalized-section-heading>.open").click(function(e){
			if(section_content.is(":hidden")){
						
				section_content.slideDown("slow", function(){
					$section.toggleClass("open");			
				});					
			}
		});
		
		$section.find(".personalized-section-content>.close").click(function(e){
			if(section_content.is(":visible")){				
				section_content.slideUp("slow", function(){
					$section.toggleClass("open");					
				});				
			}				
		});
	});	
}

function getNextPersonalizedColumn (element){
	var minValue;
	var minItem;
	element.children().each(function(){ 
		$this = $(this);
		var height = $this.outerHeight() ;
		if( height === 1 )
		{
			minItem = $this;
			return false;
		}else{			
			if ( height && (!minItem || height < minValue)) {
				minItem = $this;
				minValue = height;
			}			
		}
	});	
	return minItem;
} 

function getCurrentUser () {
	return common.ui.accounts().token ;
}

var PAGE_STATES = {
	INCOMPLETE : "INCOMPLETE",
	APPROVAL : "APPROVAL",
	PUBLISHED : "PUBLISHED",
	REJECTED : "REJECTED",
	ARCHIVED : "ARCHIVED",
	DELETED : "DELETED"	
}

function areThereSources(object){
	if( common.ui.defined( object.properties.source ) )
		return true;
	else
		return false;	
} 

function updatePageState(page, callback ){	
	common.ui.ajax( '/data/pages/update_state.json?output=json', {
		data : kendo.stringify(page) ,
		contentType : "application/json",
		complete : function(jqXHR, textStatus ){
			var hasError = false;
			if(jqXHR.responseJSON ){
				if( jqXHR.responseJSON.error )
					hasError = true;
			}
			
			console.log(kendo.stringify(jqXHR) );
			if( common.ui.defined( callback )){	
				callback(hasError);
			}									
		}							
	});		
}



function hasPermissions( user, permission ){
	var _hasPermissions = false;
	if( common.ui.accounts().token.userId == user.userId)
	{
		_hasPermissions = true;
	}
	return _hasPermissions;
}

