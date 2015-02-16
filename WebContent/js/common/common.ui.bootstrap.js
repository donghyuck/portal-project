/**
 * COMMON UI BOOTSTRAP
 * dependency : jquery
 */
;(function($, undefined) {
	var ui = common.ui,
	random = common.random,
	guid = common.guid,
	extend = $.extend,
	each = $.each,
	proxy = $.proxy,
	template = kendo.template,
	defined = common.ui.defined,
	handleAjaxError = common.ui.handleAjaxError,
	DEFAULT_ALERT_SETTING = {
		dismissible : false,	
		appendTo : $("body"),
		css : "alert-danger",
		animateCss : "fade in",
		title: null,
		template :  template('<div class="alert #=css# #=animateCss#" #if(title){#<strong>#= title #</strong>#}#role="alert">#=message#</div>'),
	};
	
	
	function bootstarpAlert (options){
		options = options || {};	
		var settings = $.extend(true, {}, DEFAULT_ALERT_SETTING, options );
		var appendTo = settings.appendTo;
			
		if( defined(appendTo)){
			if( appendTo.html().length > 0 ){
				appendTo.html("");
			}
			appendTo.append(
				settings.template({
					css: settings.css,
					animateCss : settings.animateCss,
					title: settings.title,
					message : settings.message
				})	
			);  
			if(settings.dismissible){
				appendTo.find(".alert").prepend('<button type="button" class="close" data-dismiss="alert" aria-label="Close"><span aria-hidden="true">&times;</span></button>');
			}
		}
	}
	
	extend(ui , {	
		alert : bootstarpAlert
	});
	
})(jQuery);