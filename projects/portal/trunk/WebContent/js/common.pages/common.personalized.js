function preparePersonalizedArea( element, minCount, colSize ){
	
	var template = kendo.template("<div id='#= guid #' class='personalized-panels-group col-sm-#= colSize#'></div>");
	for ( var  i = 1 ; i < minCount + 1 ; i ++  )
	{
		element.append( 
			template({
				guid: common.api.guid().toLowerCase(),
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


function getNextPersonalizedColumn (element){
	var minValue;
	var minItem;
	element.children().each(function(){ 
		$this = $(this);
		var height = $this.outerHeight() ;
		if( height === 1 )
		{
			return $this;
		}else{			
			if ( height && (!minItem || height < minValue)) {
				minItem = this;
				minValue = height;
			}			
		}
	});	
} 
