/**
 * COMMON ADMIN UI DEFINE
 */
/**
 *  extImageBrowser widget
 */
(function($, undefined) {
	var common = window.common = window.common || {}, common.ui = common.ui || {} , common.ui.system = common.ui.system || {} ;

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
	
    ui.extTopNavBar = Widget.extend({
		init: function(element, options) {			
			var that = this;
			Widget.fn.init.call(that, element, options);			
			options = that.options;					
			
			that._dataSource();
/*			
			if( options.renderTo == null ){
				options.renderTo = element;
			}
			that.items = new Array();
			that.render(options);			*/	
		},
		options : {
			name: "extTopNavBar",	
			autoBind: true,
			menu : null,
			template : null,
			select : null,
		},
		_dataSource : function () {
			var that = this ;
			var options = that.options;
			if( options.dataSource === 'object' ){}
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
			
			that.element.find('.nav a').click(function( e ){
				if( $(e.target).is('[action]') ){
					var selected = $(e.target);
					var item = { title: $.trim(selected.text()), action: selected.attr("action") , description: selected.attr("description") || "" };
					that.trigger( CHANGE, { data: item }); 
					
					if( options.select != null )
						options.select( item );
					else
						that.select( item );
				}
			});
				
				
			slideshow.html( kendo.render(ITEM_TEMPLATE, view ) );					
			that.items = slideshow.find('li');			
			slideshow.imagesLoaded(
				function(){
					if( Modernizr.backgroundsize ) {
						that.items.each( function(){
							 var item = $( this );
							 item.css( 'background-image', 'url(' + item.find( 'img' ).attr( 'src' ) + ')' );						
						} );	
					}else{
						slideshow.find( 'img' ).show();
					}
					that.items.eq( that.current  ).css( 'opacity', 1 );
				}
			);
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
				if( $.isArray( options.items ) ){
					//alert ("array");
				}else if( (typeof options.items == "object") && (options.items !== null) ){
					if( options.items.type == 'dropDownList' ){
						var subItem = options.items;
						var subObject = $('#' + subItem.id ).extDropDownList(subItem);
						that.items.push( subObject );
					}
				}				
				if( options.doAfter != null ){
					options.doAfter(that);    					
				}
			});
		},
		select : function( item ){
			var content = this.options.renderTo ;			
			content.find("form[role='navigation']").attr("action", item.action ).submit();	
		},
		getMenuItem : function( name ){
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
		item : function (id){
			return $('#' + id ).data("extDropDownList");			
		}
	});
	
	$.fn.extend( { 
		extImageBrowser : function ( options ) {
			return new common.ui.extImageBrowser ( this , options );		
		}
	});	
})(jQuery);