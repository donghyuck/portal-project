/**
 * COMMON UI MY
 * dependency : jquery
 */
;(function($, undefined) {
	var kendo = window.kendo, ui = kendo.ui, Widget = ui.Widget, extend = $.extend ;
    
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
				that.close();				
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
				element.addClass("dialog-switcher-open");
				var content = element.children(".dialog-switcher-content");
				content.one( "webkitAnimationEnd oanimationend msAnimationEnd animationend", function(e) {
					that.trigger("opened");
				});
				that.isOpen = true;
				that.trigger("open");				
			}			
	    }	
    });
	
	
	extend(common.ui, {	
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


