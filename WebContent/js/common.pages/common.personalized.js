/*var template = kendo.template(
	'<div class="project-content" style="display: none;">'
		'<div class="project-content" style="display: none;">'
	'</div>'	
);
*/
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
	
	if ( common.ui.defined(options.personalizedSection.renderTo )){
		var count = options.personalizedSection.count || 3;
		var size = options.personalizedSection.size || 6;
		preparePersonalizedArea(options.personalizedSection.renderTo, count, size);
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


