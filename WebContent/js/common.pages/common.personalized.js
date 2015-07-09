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
	
	function CarouselSlide( items, options ){
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
		
		console.log( total );
		kendo.ui.progress($('#my-page-post-modal'), true);
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
						kendo.ui.progress($('body'), false);						
					}	
				}
			});
			
			/**
			ajax("/data/images/link.json?output=json", {
				data : { imageId : image.imageId },	
				success : function(data) {						
					if(!defined(data.error)){			
						console.log( kendo.stringify(data) );
						console.log( thumbnail_url_template(image) );
						carousel_indicators.append(
							carousel_indicators_template({
								'active': count === 0,
								'uid':uid, 
								'index':count,
								thumbnail : true,
								thumbnailUrl : thumbnail_url_template(image)
							})	
						);
						carousel_inner.append(
							carousel_inner_template({ 
								'active': count === 0,
								'index':count,
								'uid':uid, 
								url: image_url_template( data ),																	
								thumbnail : true
							})		
						);
						count ++ ;		
						if(count == total) {
							//that.trigger(APPLY, { 'html' : html[0].outerHTML });									
						}
					}
				}					
			});
			*/		
		});	
		
		alert( html[0].outerHTML);
	}
	
	extend(common.ui, {	
		CarouselSlide : CarouselSlide,
		DialogSwitcher : DialogSwitcher
	});
	
})(jQuery);



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

function updatePageState(page, callback ){	
	common.ui.ajax( '/data/pages/update_state.json?output=json', {
		data : kendo.stringify(page) ,
		contentType : "application/json",
		complete : function(e){
			if( common.ui.defined( callback )){	
				callback();
			}									
		}							
	});		
}


