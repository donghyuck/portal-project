/**
 * COMMON ADMIN UI DEFINE
 */
/**
 *  extNavbar widget
 *  
 *  top navigation bar
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
	UNDEFINED = 'undefined',
	CHANGE = "change",
	CLICK = "click",
	SELECT = "select",
	POST = 'POST',
	JSON = 'json',		
	handleKendoAjaxError = common.api.handleKendoAjaxError ;	
    common.ui.extNavbar = Widget.extend({
		init: function(element, options) {			
			var that = this;
			Widget.fn.init.call(that, element, options);			
			options = that.options;			
			if( typeof options.data === UNDEFINED ){
				options.data = {};
			}
			if( typeof options.items === UNDEFINED ){
				options.items = [];
			}
			that.refresh();
		},
		options : {
			name: "ExtNavbar"
		},
		events : [ SELECT ],
		go : function ( action ){
			var that = this ;
			that.element.find("form[role='navigation']").attr("action", action ).submit();	
		},
		refresh: function () {			
			var that = this ;
			var options = that.options;
			var template = that._navbarTemplate();
			that.element.html(template( options.data ));				
			if( $.isArray( options.items ) ){
				$.each( options.items, function ( i, item ){
					if ( typeof item ==='object'){
						 if (item.name === 'companySelector' ){				
							 if( typeof item.enabled === UNDEFINED){
									item.enabled = false;								
							}							
							if( typeof item.dataTextField === UNDEFINED){
								item.dataTextField = "displayName";
							}							
							if( typeof item.dataValueField === UNDEFINED){
								item.dataValueField = "companyId";					
							}							
							if( typeof item.dataSource === UNDEFINED){
									item.dataSource = {
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
									}
							}
							
							var companySelector = $( item.selector ).extDropDownList(item);
						 }						
					}
				});				
			}
		},
		_navbarTemplate : function (){
			var that = this ;			
			if( typeof that.options.template === UNDEFINED){
				return kendo.template( "<div class='navbar navbar-inverse navbar-fixed-top' role='navigation'></div>" );		
			}else 	if( typeof that.options.template === 'object'){
				return that.options.template ;			
			}
			else if( typeof that.options.template === 'string'){
				return kendo.template( that.options.template );
			}
		}
	});
	
	$.fn.extend( { 
		extNavbar : function ( options ) {
			return new common.ui.extNavbar ( this , options );		
		}
	});	
})(jQuery);

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
    MENU_DATA_URL = '/secure/get-website-menu-component.do?output=json',
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
			if( options.remote )
				that._dataSource();
		},
		items : function () {
			var that = this ;
			return that.options.items;
		},
		options : {
			name: "ExtTopNavBar",	
			autoBind: true,
			menu : null,
			remote : false,
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
							data: "targetWebSiteMenuComponent.components"
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
		go : function ( action ){
			var that = this ;
			that.element.find("form[role='navigation']").attr("action", action ).submit();	
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
						that.go(item.action );
					}
				}
			});			
			if( $.isArray( options.items ) ){
				$.each( options.items, function ( i, item ){
					if( typeof item ==='string'){
						
					}else if ( typeof item ==='object'){
						if( item.name === 'getMenuItem' ){
							item.handler( that._getMenuItem( item.menu )	);					
						}else if (item.name === 'companySelector' ){							
							if( typeof item.enabled === UNDEFINED){
								item.enabled = false;								
							}							
							if( typeof item.dataTextField === UNDEFINED){
								item.dataTextField = "displayName";
							}							
							if( typeof item.dataValueField === UNDEFINED){
								item.dataValueField = "companyId";					
							}							
							if( typeof item.dataSource === UNDEFINED){
								item.dataSource = {
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
								}
							}
							var companySelector = $( item.selector ).extDropDownList(item);
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