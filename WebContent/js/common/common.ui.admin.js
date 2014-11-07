/**
 * COMMON ADMIN UI DEFINE
 */
(function($, undefined) {
	var common = window.common = window.common || {};
	common.ui =  common.ui || {},
	common.ui.admin = common.ui.admin || {};
	
	var kendo = window.kendo,
	ajax = common.ui.ajax,
	Widget = kendo.ui.Widget,
	Class = kendo.Class,
	extend = $.extend,
	stringify = kendo.stringify,
	isFunction = kendo.isFunction,
	UNDEFINED = 'undefined',
	POST = 'POST',
	CLICK = 'click',
	CHANGE = 'change',
	AUTHENTICATE = 'authenticate',
	COMPLETE = 'complete',
	AUTHENTICATE_URL = "/accounts/get-user.do?output=json",	
	ROLE_ADMIN = "ROLE_ADMIN", 
	ROLE_SYSTEM = "ROLE_SYSTEM", 	
	OBJECT_TYPE = 30 ,
	ACCOUNT_RENDER_ID = "account-panel",
	JSON = 'json';
	
	
	
	var Setup = Widget.extend({		
		init : function(element, options) {
			var that = this;
			Widget.fn.init.call(that, element, options);
			options = that.options;
			that.complete();
			kendo.notify(that);
		},
		options : {
			name : "Setup",
		},
		events : [ CLICK, CHANGE, AUTHENTICATE, COMPLETE ],
		complete : function(){
			var that = this,
			options = that.options, 			
			cfg = { features : {}, jobs : [] };
			
			cfg.features = options.features || {} ;
			cfg.jobs =  options.jobs || [] ;			
			common.ui.setup(cfg);		
			
			that.authenticate();
			that.companySelector();
			
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
			
			that._pixelAdmin = window.PixelAdmin;
			that._pixelAdmin.start([]);	
			
		
		},
		authenticate : function() {
			var that = this;
			ajax( that.options.authenticateUrl || AUTHENTICATE_URL, {
				success : function(response){
					var token = new common.ui.data.User($.extend( response.currentUser, { roles : response.roles }));
					token.set('isSystem', false);
					if (token.hasRole(ROLE_SYSTEM) || token.hasRole(ROLE_ADMIN))
						token.set('isSystem', true);			
					token.copy(that.token);	
					that.trigger(AUTHENTICATE,{ token : that.token });
				}
			});		
		},
		companySelector : function(){	
			var that = this,
			renderTo = $("#targetCompany");		
			if(!renderTo.data("kendoDropDownList")){
				renderTo.kendoDropDownList({
					dataTextField: 'displayName',	
					dataValueField: 'companyId',
					dataSource: {
						serverFiltering: false,
						transport: {
							read: {
								dataType: JSON,
								url: '/secure/list-company.do?output=json',
								type: POST
							}
						},
						schema: { 
							data: "companies",
							model : common.ui.data.Company
						}
					},
					change : function (e){
						var item = this.dataSource.get(this.value());					
						that.trigger(CHANGE, { "fieldName" : "company", target:item } );
					},
					dataBound : function(e){
						var item = this.dataSource.get(this.value());		
						that.trigger(CHANGE, { "fieldName" : "company", target:item } );
					}
				});		
			}
			return renderTo.data("kendoDropDownList");
		}	
	});
	
	function setup (options){	
		options = options || {};
		//if( $("#main-wrapper").text().length > 0 ){	
			if(!$("#main-wrapper").data("kendoSetup") ){
				new Setup($("#main-wrapper"), options);	
			}
			return $("#main-wrapper").data("kendoSetup");
		//}else{
		//	return Setup($("#main-wrapper"), options);	
		//}		
	}	
	
	extend(common.ui.admin, {
		setup : setup
		
	} );
	/*
	common.ui.admin.Setup = kendo.Class.extend({		
		init : function (options){			
			var that = this;
			options = options || {};
			options = that.options = extend(true, {}, that.options, options);
			that._pixelAdmin = window.PixelAdmin;			
			that.refresh();
		},		
		options : {			
			features : {
				culture : true,
				landing : true,
				backstretch : false,
				lightbox: false,
				spmenu: false,
				morphing: false
			},
			worklist: []
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
			common.ui.accounts($("#" +renderTo ), {
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
					serverFiltering: false,
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
					if( isFunction( that.options.companyChanged ) )
						that.options.companyChanged( this.dataSource.get(this.value()) );
				},
				dataBound : function(e){
					if( isFunction( that.options.companyChanged ) )
						that.options.companyChanged( this.dataSource.get(this.value()) );
				}
			}).data('kendoDropDownList');			
		},
		_createSwitcher : function (){		
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
		_initWorklist: function(){
			var that = this;
			var worklist = that.options.worklist;			
			if (worklist == null) {
				worklist = [];
			}			
			var initilizer, _i, _len, _ref;
			 _ref = worklist;			 
			 for (_i = 0, _len = worklist.length; _i < _len; _i++) {
				 initilizer = _ref[_i];
				 $.proxy(initilizer, that)();
			}				
		},
		_initFeatures: function(){
			var that = this;
			var features = that.options.features;
			var worklist = that.options.worklist;
			
			if( features.culture ){
				common.api.culture();				
			}
			
			if(features.backstretch){
				common.ui.backstretch();
			}
			
			if( features.morphing ){
				$.each( $(".morph-button"), function( index,  item){
					var $this = $(item);
					var btn = new codrops.ui.MorphingButton($this);					
				});
			}
			
			if(features.landing){				
				common.ui.landing();
			}
			
			if(features.spmenu){				
				$(document).on("click","[data-toggle='spmenu']", function(e){
					var $this = $(this);					
					var target ;
					if( $this.prop("tagName").toLowerCase() == "a" ){			
						target  = $this.attr("href");	
					}else{
						if($this.data("target")){
							target = $this.data("target")
						}
					}
					$("body").toggleClass("modal-open");
					$(target).toggleClass("cbp-spmenu-open");
				});
				$(document).on("click","[data-dismiss='spmenu']", function(e){
					var $this = $(this);
					var target  = $this.parent();		
					$("body").toggleClass("modal-open");
					target.toggleClass("cbp-spmenu-open");
				});
			}
			
			if(features.lightbox){				
				common.ui.lightbox();	
			}	
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
			that._initFeatures();
		
			that._createCompanySelector();			
			that._createSwitcher();
			that._doAuthenticate();
			that._pixelAdmin.start([]);	
			that._initWorklist();
			
		}
	});	
	*/
	
})(jQuery);

common.ui.admin.switcherEnabled = function(name) {
	return $('input[role="switcher"][name="' + name + '"]').is(":checked") ;	
}


	