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
	extend = $.extend,
	stringify = kendo.stringify,
	isFunction = kendo.isFunction,
	UNDEFINED = 'undefined',
	POST = 'POST',
	OBJECT_TYPE = 30 ,
	ACCOUNT_RENDER_ID = "account-panel",
	COMPANY_SELECTOR_RENDER_ID = "targetCompany",
	JSON = 'json';
		
	
	common.ui.admin.FileInfo =  kendo.data.Model.define({
		id : "path",
		fields: { 
			absolutePath: { type: "string", defaultValue: "" },
			name: { type: "string", defaultValue: "." },
			path: { type: "string", editable: false, defaultValue: "." },
			size: { type: "number", defaultValue: 0 },
			directory: { type: "boolean", defaultValue: false },
	        lastModifiedDate: { type: "date"}
		},
	    copy: function ( target ){
	    	target.path = this.get("path");
	    	target.set("absolutePath",this.get("absolutePath") );
	    	target.set("name", this.get("name"));
	    	target.set("size",this.get("size") );
	    	target.set("directory", this.get("directory"));
	    	target.set("lastModifiedDate",this.get("lastModifiedDate") );
	    }
	});
	
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
	
})(jQuery);

common.ui.admin.switcherEnabled = function(name) {
	return $('input[role="switcher"][name="' + name + '"]').is(":checked") ;	
}

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
	