function preparePersonalizedArea( element, min, colSize ){
	var template = kendo.template("<div id='#= guid #' class='personalized-panels-group col-sm-#= colSize#'></div>");
	for ( var  i = 1 ; i <= colSize ; i ++  )
	{
		element.append( 
			template({
				guid: common.api.guid().toLowerCase(),
				colSize: colSize
			})
		);		
	}	
	element.data("sizePlaceHolder", { oldValue: colSize , newValue : colSize} );	
}