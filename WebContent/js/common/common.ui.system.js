/**
 * COMMON ADMIN UI DEFINE
 */
/**
 *  extImageBrowser widget
 */
(function($, undefined) {
	var common = window.common = window.common || {};
	common.ui =  common.ui || {};

    var kendo = window.kendo,
    Widget = kendo.ui.Widget,
    isPlainObject = $.isPlainObject,
    proxy = $.proxy,
    extend = $.extend,
    placeholderSupported = kendo.support.placeholder,
    DataSource = kendo.data.DataSource,
    browser = kendo.support.browser,
    isFunction = kendo.isFunction,
    MENU_DATA_URL = '/secure/get-company-menu-component.do?output=json',
	UNDEFINED = 'undefined',
	CHANGE = "change",
	CLICK = "click",
	SELECT = "select",
	POST = 'POST',
	JSON = 'json',		
	handleKendoAjaxError = common.api.handleKendoAjaxError ;	
    common.ui.extTopNavBar = Widget.extend({
		init: function(element, options) {			
			var that = this;
			Widget.fn.init.call(that, element, options);			
			options = that.options;					
			that._dataSource();
		},
		options : {
			name: "extTopNavBar",	
			autoBind: true,
			menu : null,
			template : null
		},
		events : [ SELECT ],
		_getMenuItem : function( name ){
			var that = this ;
			var items = this.dataSource.data();
			var menuItem = null;
			$.each( items, function ( i, item ){
				if(item.components.length > 0 )
				{	
					$.each( item.components, function ( j, item2 ){
						if( name == item2.name ){
							menuItem = item2;
							return;
						}
					});
				}else{
					if( name == item.name ){
						menuItem = item;
						return;						
					}
				}
			});
			return menuItem;
		},		
		_dataSource : function () {
			var that = this ;
			var options = that.options;
			if( typeof options.dataSource === 'object' ){
				that.dataSource = DataSource.create(options.dataSource);
			}else{
				if( typeof options.menu === 'string' ){
					that.dataSource = DataSource.create({
						transport: {
							read: {
								url: MENU_DATA_URL,
								dataType: JSON,
								data: {
									menuName: options.menu
								}
							}
						},
						schema: {
							data: "targetCompanyMenuComponent.components"
						}
					});
				} 
			}
			that.dataSource.bind(CHANGE, function() {
				that.refresh();
			});			
			
			if( options.autoBind ){
				that.dataSource.fetch();
			}
		},		
		refresh: function () {
			var that = this ;
			var options = that.options;
			var view = that.dataSource.view();		
			that.element.html(
				options.template( view )
			);						
			that.element.find('.nav a').on( CLICK, function( e ){
				if( $(e.target).is('[action]') ){
					var selected = $(e.target);
					var item = { title: $.trim(selected.text()), action: selected.attr("action") , description: selected.attr("description") || "" };					
					that.trigger(SELECT, { data: item }); 					
					if( !isFunction(options.select) ){
						that.element.find("form[role='navigation']").attr("action", item.action ).submit();	
					}
				}
			});			
			if( $.isArray( options.items ) ){
				$.each( options.items, function ( i, item ){
					if( typeof item ==='string'){
						
					}else if ( typeof item ==='object'){
						if( item.name === 'getMenuItem' ){
							item.handler( that._getMenuItem( item.menu )	);					
						}
					}
				});
			}
		}
	});
	
	$.fn.extend( { 
		extTopNavBar : function ( options ) {
			return new common.ui.extTopNavBar ( this , options );		
		}
	});	
})(jQuery);