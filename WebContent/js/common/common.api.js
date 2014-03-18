
;(function($, undefined) {
	var common = window.common = window.common || {};
	common.api =  common.api || {};
	
	common.api.getTargetCompany =  function (url, options){
		if (typeof url === "object") {
	        options = url;
	        url = undefined;
	    }	    
	    // Force options to be an object
	    options = options || {};		    
	    $.ajax({
			type : 'POST',
			url : options.url || '/secure/get-company.do?output=json' ,
			data: options.data || {},
			success : function(response){
				if( response.error ){ 												
					options.fail(response) ;
				} else {					
					var company = new Company (response.targetCompany);	
					options.success(company) ;					
				}
			},
			error:options.error || handleKendoAjaxError,
			dataType : "json"
		});	
	};				
	
	common.api.isValidEmail = function (email){
		var expr = /^([\w-\.]+)@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.)|(([\w-]+\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})(\]?)$/;
        return expr.test(email);
	};
	
	common.api.getUser = function (options){	
		options = options || {};
		$.ajax({
			type : 'POST',
			url : options.url || '/accounts/get-user.do?output=json' ,
			success : function(response){
				var user = new User ();			
				if( response.error ){ 		
					if( typeof options.fail === 'function'  )
						options.fail(response) ;
				} else {				
					user = new User (response.currentUser);	
				}
				if( typeof options.success === 'function'  )
					options.success (user);
			},
			error:options.error || handleKendoAjaxError,
			dataType : "json"
		});			
	}
	
	common.api.getEngageSocailProfile = function ( options ){		
		options = options || {};
		$.ajax({
			type : 'POST',
			url : options.url || '/community/facebook-callback.do?output=json',
			data: { onetime : options.onetime },
			success : function(response){
				if( response.error ){ 												
					options.fail(response) ;
				} else {					
					options.success(response) ;					
				}
			},
			error:options.error || handleKendoAjaxError,
			dataType : "json"
		});	
	};
	
	common.api.signin = function ( options ){		
		options = options || {};
		$.ajax({
			type : 'POST',
			url : options.url ,
			data: { onetime : options.onetime },
			success : function(response){
				if( response.error ){ 												
					options.fail(response) ;
				} else {					
					options.success( new User(response.account)) ;					
				}
			},
			error:options.error || handleKendoAjaxError,
			dataType : "json"
		});	
	};

	common.api.signup = function ( options ){		
		options = options || {};
		$.ajax({
			type : 'POST',
			url : options.url || '/accounts/signup-external.do?output=json' ,
			data: { item : options.data },
			success : function(response){
				if( response.error ){ 												
					options.fail(response) ;
				} else {					
					options.success(response) ;					
				}
			},
			error:options.error || handleKendoAjaxError,
			dataType : "json"
		});	
	};

	common.api.guid = function()
	{
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

	common.api.pager = function (item, current_index, total_index, current_page, total_page) {		
		if( current_index < 0 )
			current_index = 0;		
		item.index = current_index ;
		item.page = current_page;
		item.previous = ( current_index > 0 || current_page > 1 ) ;
		item.next = true ;			
		if( (total_index - current_index) == 0 && (total_page - current_page) == 0 )
			item.next = false;		
		return item;
	}
	
	common.api.handleKendoAjaxError = function (xhr) {
		var message = "";
		if (xhr.status == 0) {
			message = "오프라인 상태입니다.";
		} else if (xhr.status == 404) {
			message = "요청하신 페이지를 찾을 수 없습니다.";
		} else if (xhr.status == 500) {
			message = "시스템 내부 오류가 발생하였습니다.";
		} else if (xhr.status == 403 || xhr.errorThrown == "Forbidden") {
			message =  "접근 권한이 없습니다."; // "Access to the specified resource has
										// been forbidden.";
		} else if (xhr.errorThrown == 'timeout') {
			message = "처리 대기 시간을 초가하였습니다. 잠시 후 다시 시도하여 주십시오.";
		} else if (xhr.errorThrown == 'parsererror') {
			message = "데이터 파싱 중에 오류가 발생하였습니다.";
		} else {
			message = "오류가 발생하였습니다." ;
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
	
})(jQuery);


/**
 * User  
 */

;(function($, undefined) {
	var common = window.common = window.common || {} ;
	common.api.user = common.api.user || {} ;
	var kendo = window.kendo,
	handleKendoAjaxError = common.api.handleKendoAjaxError ;
	stringify = kendo.stringify,
	isFunction = kendo.isFunction,
	UNDEFINED = 'undefined',
	POST = 'POST',
	JSON = 'json';	
	common.api.user.signin = function ( options ){		
		options = options || {};
		$.ajax({
			type : 'POST',
			url : options.url || '/accounts/external-signin.do?output=json' ,
			data: { onetime : options.onetime },
			success : function(response){
				if( typeof response.error === UNDEFINED ){ 		
					if( isFunction(options.success) )
						options.success(new User(response)) ;						
				}else{
					if( isFunction(options.fail) )
						options.fail(response) ;								
				}
			},
			error:options.error || handleKendoAjaxError,
			dataType : "json"
		});	
	};
	
	common.api.user.logout = function (options){
		options = options || {};
		$.ajax({
			type : 'GET',
			url : options.url || "/logout?output=json",
			success : function(response){
				if( options.success ){
					options.success(response);
				}
			},
			error:handleKendoAjaxError												
		});			
	}	
	common.api.user.signup = function ( options ){		
		options = options || {};		
		if( typeof options.external === UNDEFINED ){
			options.external = false;
		}		
		if( options.external )	{
			$.ajax({
				type : 'POST',
				url : options.url || '/accounts/external-signup.do?output=json' ,
				data: { item : options.data },
				success : function(response){
					if( typeof response.error === UNDEFINED ){ 		
						if( isFunction(options.success) )
							options.success(response) ;						
					}else{
						if( isFunction(options.fail) )
							options.fail(response) ;								
					}
				},
				error:options.error || handleKendoAjaxError,
				dataType : "json"
			});				
		}else{
			$.ajax({
				type : 'POST',
				url : options.url || '/accounts/create-user.do?output=json' ,
				data: { item : options.data },
				success : function(response){
					if( typeof response.error === UNDEFINED ){ 		
						if( isFunction(options.success) )
							options.success(response) ;						
					}else{
						if( isFunction(options.fail) )
							options.fail(response) ;								
					}
				},
				error:options.error || handleKendoAjaxError,
				dataType : "json"
			});				
		}
	};	
	
})(jQuery);	

/**
 * Streams  
 */
;(function($, undefined) {
	var common = window.common = window.common || {} ;
	common.api.streams = common.api.streams || {} ;
	
	var kendo = window.kendo,
		handleKendoAjaxError = common.api.handleKendoAjaxError ;
		stringify = kendo.stringify,
		Photo = common.models.Photo,
		isFunction = kendo.isFunction,
		UNDEFINED = 'undefined',
		POST = 'POST',
		JSON = 'json',
		CALLBACK_URL_TEMPLATE = kendo.template("/community/#= media #-callback.do?output=json");

		common.api.streams.add = function (options){
			options = options || {};
			$.ajax({
				type : 'POST',
				url : options.url || '/community/add-streams-photo.do?output=json' ,
				data: { imageId : options.imageId },
				success : function(response){
					if( response.error ){ 												
						if( isFunction (options.fail) )
							options.fail(response) ;
					} else {					
						if( isFunction(options.success) )
							options.success(response) ;					
					}
				},
				error:options.error || handleKendoAjaxError,
				dataType : "json"
			});	
		}

		common.api.streams.remove = function (options){
			options = options || {};
			$.ajax({
				type : 'POST',
				url : options.url || '/community/remove-streams-photo.do?output=json' ,
				data: { imageId : options.imageId },
				success : function(response){
					if( response.error ){ 												
						if( isFunction (options.fail) )
							options.fail(response) ;
					} else {					
						if( isFunction(options.success) )
							options.success(response) ;					
					}
				},
				error:options.error || handleKendoAjaxError,
				dataType : "json"
			});	
		}	
		
		common.api.streams.dataSource = new kendo.data.DataSource({		
			serverPaging: true,
			pageSize: 15,
			transport: { 
				read: {
					url : '/community/list-streams-photo.do?output=json',
					type: 'POST',
					dataType: 'json'
				},
	            parameterMap: function (options, type){
	                return { startIndex: options.skip, pageSize: options.pageSize }
	            }
			},
	        schema: {
	            total: "photoCount",
	            data: "photos",
	            model: Photo
	        },
	        error: handleKendoAjaxError,
		});

		common.api.streams.details = function ( options ){		
			options = options || {};
			$.ajax({
				type : 'POST',
				url : options.url || '/community/get-streams-photo.do?output=json' ,
				data: { imageId : options.imageId },
				success : function(response){
					if( response.error ){ 												
						if( isFunction (options.fail) )
							options.fail(response) ;
					} else {					
						if( isFunction(options.success) )
							options.success(response) ;					
					}
				},
				error:options.error || handleKendoAjaxError,
				dataType : "json"
			});	
		};		
		

})(jQuery);

/**
 * Social  
 */
;(function($, undefined) {
	var common = window.common = window.common || {} ;
	common.api.social = common.api.social || {} ;
	
	var kendo = window.kendo,
		handleKendoAjaxError = common.api.handleKendoAjaxError ;
		stringify = kendo.stringify,
		isFunction = kendo.isFunction,
		UNDEFINED = 'undefined',
		POST = 'POST',
		JSON = 'json',
		CALLBACK_URL_TEMPLATE = kendo.template("/community/#= media #-callback.do?output=json");
	
	common.api.social.update = function ( options ){		
		options = options || {};	
		if( typeof options.url === UNDEFINED){
			options.url = '/community/update-socialnetwork.do?output=json';
		}
		$.ajax({
			type : POST,
			url : options.url,
			data: options.data,
			success : function(response){
				if( typeof response.error === UNDEFINED ){ 		
					if( isFunction( options.success ) ){						
						options.success(response) ;
					}
				} else {									
					if( isFunction( options.fail ) ){
						options.fail(response) ;
					}
				}
			},
			error:options.error || handleKendoAjaxError ,
			dataType : JSON
		});			
	}
		
	common.api.social.getProfile = function ( options ){				
		options = options || {};		
		if( typeof options.url === UNDEFINED && typeof options.media == 'string' ){
			options.url = CALLBACK_URL_TEMPLATE ({media : options.media});
		}	
		$.ajax({
			type : POST,
			url : options.url,
			data: { onetime : options.onetime },
			success : function(response){
				//alert( ">" + (typeof response.error === UNDEFINED) );
				if( typeof response.error === UNDEFINED ){ 		
					if( isFunction( options.success ) ){						
						options.success(response) ;
					}
				} else {									
					if( isFunction( options.fail ) ){
						options.fail(response) ;
					}
				}
			},
			error:options.error || handleKendoAjaxError ,
			dataType : JSON
		});	
	};	
})(jQuery);