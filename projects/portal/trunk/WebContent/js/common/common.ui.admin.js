/**
 * COMMON ADMIN UI DEFINE
 */
(function($, undefined) {
	var common = window.common = window.common || {};
	common.ui =  common.ui || {},
	common.ui.admin = common.ui.admin || {};
	
	var kendo = window.kendo,
	Widget = kendo.ui.Widget,
	Class = kendo.Class,
	stringify = kendo.stringify,
	isFunction = kendo.isFunction,
	UNDEFINED = 'undefined',
	POST = 'POST',
	OBJECT_TYPE = 30 ,
	ACCOUNT_RENDER_ID = "account-panel",
	COMPANY_SELECTOR_RENDER_ID = "targetCompany",
	JSON = 'json';
		
	common.ui.admin.Setup = kendo.Class.extend({		
		init : function (options){			
			var that = this;
			options = options || {};				
			that.options = options;
			that._pixelAdmin = window.PixelAdmin;			
			that.refresh();
		},		
		_doAuthenticate : function(){		
			var that = this;
			var renderTo = ACCOUNT_RENDER_ID;				
			if ($("#" +renderTo ).length == 0) {
				$('body').append(	'<div id="' + renderTo + '" style="display:none;"></div>');
			}
			$("#" +renderTo ).kendoAccounts({
				visible : false,
				authenticate : function( e ){
					if( isFunction( that.options.authenticate ) )
						that.options.authenticate(e);
				}
			});
		},
		_createCompanySelector : function(){	
			var that = this;
			var renderTo = COMPANY_SELECTOR_RENDER_ID;				
			that.companySelector = $('#' + renderTo).kendoDropDownList({
				dataTextField: 'displayName',	
				dataValueField: 'companyId',
				dataSource: {
					transport: {
						read: {
							dataType: JSON,
							url: '/secure/list-company.do?output=json',
							type: POST
						}
					},
					schema: { 
						data: "companies",
						model : Company
					}
				},
				change : function (e){			
					alert(2);
					if( isFunction( that.options.companyChanged ) )
						that.options.companyChanged( this.dataSource.get(this.value) );
				},
				dataBound : function(e){
					alert( kendo.stringify(this.dataSource.get(this.value));			
					//alert(this.value());
				}
			}).data('kendoDropDownList');			
		},
		_createMenuContent : function (){		
			var that = this;
			$.each( $('input[role="switcher"]'), function( index, element ){
				$(element).switcher();						
				$(element).change(function(){
					if( isFunction( that.options.switcherChanged ) ){
						that.options.switcherChanged( $(this).attr("name"), $(this).is(":checked") );						
					}
				});
			} );
		},
		isSwitcherEnabled:function(name){
			return $('input[role="switcher"][name="' + name + '"]').is(":checked") ;			
		}, 
		refresh: function(){			
			var that = this;
			$('.menu-content-profile .close').click(function () {
				var $p = $(this).parents('.menu-content');
				$p.addClass('fadeOut');
				setTimeout(function () {
					$p.css({ height: $p.outerHeight(), overflow: 'hidden' }).animate({'padding-top': 0, height: $('#main-navbar').outerHeight()}, 500, function () {
						$p.remove();
					});
				}, 300);
				return false;
			});
			that._createCompanySelector();			
			that._createMenuContent();
			that._doAuthenticate();
			that._pixelAdmin.start([]);	
		}
	});	
	
})(jQuery);


common.ui.admin.setup = function (options){	
	options = options || {};
	if( $("#main-wrapper").text().length > 0 ){	
		if( $("#main-wrapper").data("admin-setup") ){
			return $("#main-wrapper").data("admin-setup");		
		}else{			
			var setup = new common.ui.admin.Setup(options);	
			 $("#main-wrapper").data("admin-setup", setup );
			 return setup;
		}
	}else{
		return new common.ui.admin.Setup(options);	
	}		
}
	