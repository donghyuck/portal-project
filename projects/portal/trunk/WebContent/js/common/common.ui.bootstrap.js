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
		template :  template('<div class="alert #=css# #=animateCss#" #if(title){#<strong>#= title #</strong>#}#role="alert">#=message#</div>'),
	};
	
	
	
	function alert (option){
		options = options || {};	
		var settings = $.extend(true, {}, DEFAULT_ALERT_SETTING, options );
		if( defined(settings.appendTo)){
			settings.appendTo.html(
				settings.template({
					css: settings.css,
					animatedCss : settings.animateCss,
					title: settings.title,
					message : settings.message
				})	
			);  
			if(settings.dismissible){
				settings.appendTo.prepend('<button type="button" class="close" data-dismiss="alert" aria-label="Close"><span aria-hidden="true">&times;</span></button>');
			}
		}
	}
	
	extend(ui , {	
		alert : alert
	});
	
})(jQuery);