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
	extend(common, {	
		ui: common.ui || {},
		guid : common.guid || guid
	});
		
})(jQuery);
// 
;(function($, undefined) {
	var ui = common.ui,
	isFunction = kendo.isFunction,
	extend = $.extend,
	DataSource = kendo.data.DataSource,
	progress = kendo.ui.progress,
	POST = 'POST',	
	JSON = 'json',
	STRING = 'string',
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
	
	function status ( selector, status ){
		var element = selector;
		if(defined(status)){
			if( status === 'disable') {
				if( !element.is(":disabled") ){
					element.prop("disabled", true);
					if( element.is("[data-toggle='button']") ){
						element.toggleClass("active");
					}
				}
			}else if (status === 'enable' ){
				if( element.is(":disabled") ){
					element.prop("disabled", false);
					if( element.is("[data-toggle='button']") ){
						element.toggleClass("active");
					}
				}				
			}
		}
	}
	
	function slimScroll( renderTo , options ){
		options = options || {};
		/*if(defined($.slimScroll)) {
			renderTo.slimScroll( options );
		}else{
			
			
		}*/
		renderTo.slimScroll( options );
	}
	
	function visible( selector ){
		return selector.is(":visible");
	}
	
	function listview( renderTo, options ){		
		if(!renderTo.data("kendoListView")){			
			 renderTo.kendoListView(options);
		}		
		return renderTo.data("kendoListView");
	}
	/**
	 * url 
	 * options 
	 */
	var DEFAULT_DATASOURCE_SETTING = {
			transport:{
				read:{
					type :POST,
					dataType : JSON
				} 				
			},
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
		$.ajax(settings);		
	};
	
	extend(ui , {	
		handleAjaxError : common.ui.handleAjaxError || handleAjaxError,
		defined : common.ui.defined || defined,
		visible : common.ui.visible || visible,
		status : common.ui.status || status,
		datasource : common.ui.datasource || datasource,
		ajax : common.ui.ajax || ajax,
		listview : common.ui.listview || listview,
		slimScroll : common.ui.slimScroll || slimScroll
	});	
	
	
})(jQuery);