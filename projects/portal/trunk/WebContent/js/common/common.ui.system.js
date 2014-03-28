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
		_dataSource : function () {
			var that = this ;
			var options = that.options;
			if( options.dataSource === 'object' ){
				that.dataSource = DataSource.create(options.dataSource);
			}else{
				if( options.menu === 'string' ){
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
			alert( that.dataSource );
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
					that.trigger( 'click.menu', { data: item }); 
				}
			});				
		},				
		render: function ( options ) {
			var that = this;
			that.dataSource.fetch(function(){
			var items = that.dataSource.data();
			content.append( options.template( items ) );					
				content.find('.nav a').click(function( e ){
					if( $(e.target).is('[action]') ){
						var selected = $(e.target);
						var item = { title: $.trim(selected.text()), action: selected.attr("action") , description: selected.attr("description") || "" };
						if( options.select != null )
							options.select( item );
						else
							that.select( item );
					}					
				});
			});
		}
	});
	
	$.fn.extend( { 
		extTopNavBar : function ( options ) {
			return new common.ui.extTopNavBar ( this , options );		
		}
	});	
})(jQuery);