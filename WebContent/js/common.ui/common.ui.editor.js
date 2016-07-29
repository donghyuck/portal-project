/**
 * Editor 
 */

(function($, undefined) {
	var ui = common.ui,
	kendo = window.kendo, 
	Widget = kendo.ui.Widget, 
	isPlainObject = $.isPlainObject, 
	proxy = $.proxy, 
	extend = $.extend, 
	placeholderSupported = kendo.support.placeholder, 
	browser = kendo.support.browser, 
	isFunction = kendo.isFunction,
	guid = common.guid,
	template = kendo.template,
	BODY = "body",
	THEME = "ace/theme/xcode",
    templates,
	trimSlashesRegExp = /(^\/|\/$)/g, 
	CHANGE = "change", 
	APPLY = "apply", 
	ERROR = "error", 
	OPEN = "open", 
	REFRESH = "refresh",
	CLICK = "click", 
	CLOSE = "close",
	UNDEFINED = 'undefined',
	POST = 'POST', 
	JSON = 'json',
	MODAL_HEADER = '.modal-header',
	MODAL_TITLE = '.modal-title',
	isLocalUrl = kendo.isLocalUrl;	
	
	var DEFAULT_ACE_EDITOR_SETTING = {
			mode : "ace/mode/xml",
			theme : "ace/theme/xcode",
			useWrapMode : true		
		};
	
	
	var AceEditor = Widget.extend({
		init : function(element, options) {
			var that = this,
			wrapper,
			content,
			id;
			
			Widget.fn.init.call(that, element, options);
			options = that.options;
			element = that.element;
			content = options.content;
			
			that.appendTo = $(options.appendTo);
			that._editor = null;
			 if( element.html().length == 0 && options.modal){
				 that._createModal(element, options);
			 }			
		},
		events : [ 
		    ERROR, 
		    CHANGE, 
		    CLICK, 
		    OPEN, 
		    REFRESH, 
		    CLOSE ],
		options : {
			name : "AceEditor",		
			modal: true,
			title : "HTML",
			content: null,
			appendTo: "body",
			value : null,
			uid : guid()
		},
		title : function(title){
			var that = this,
			options = this.options;			
			if (title === undefined) {
                return options.title;
            }else{		
            		options.title = title;
    				if(options.modal){
    					if(that.element.find(MODAL_TITLE).is(':hidden')){
    						that.element.find(MODAL_TITLE).show();    						
    					}
    					that.element.find(MODAL_TITLE).html(title);
    				}
            	
            }
		},
		show : function() {
			var that = this,
			options = this.options;
			if(options.modal){
				that._modals().modal('show');
			}			
		},
		close : function() {
			var that = this,
			options = this.options;
			if(options.modal){
				that.value("");
				that._modals().modal('hide');
			}
		},
		refresh : function() {
			var that = this,
            initOptions = that.options,
            element = $(that.element);
			that.trigger(REFRESH);
		},
		destroy : function() {
			var that = this;
			Widget.fn.destroy.call(that);
		},
		value: function(value) {
			var that = this,
			editor = that._ace() ;
			if (value === undefined) {
                return editor.getValue();
            }else{
            	editor.setValue(value);
            }
		},
		_ace : function(){
			var that = this,
			options = that.options,
			editor = that._editor;
			if( editor === null){
				var settings = $.extend(true, {}, DEFAULT_ACE_EDITOR_SETTING , options ); 
				editor = ace.edit(settings.uid);	
				editor.setTheme(settings.theme );
				editor.getSession().setMode(settings.mode) ;
				editor.getSession().setUseWrapMode(settings.useWrapMode);
			}		
			return editor;
		},
		_modals : function() {
			var that = this;
			return that.element.children('.modal');
		},
		_createModal : function() {
			var contentHtml = this.element,
            options = this.options,
            that = this,
            wrapper;		
			wrapper = $(templates.modal(options));			
			contentHtml.append(wrapper);		
			
			that.element.find('.modal button[data-action=update]').click(function(e){
				that.trigger(CHANGE);
				that.close();		
			});			
			that.element.find('.modal').on('hide.bs.modal', function(e) {
				that.trigger(CLOSE);
			});	
		}
	});
	
	templates = {
		modal : kendo.template(
				"<div class='modal fade' tabindex='-1' role='dialog' aria-hidden='true'>"
				  + "<div class='modal-dialog modal-lg'>"
				  + "<div class='modal-content'>"
				  + "<div class='modal-header'>"
			  	  + "<button type='button' class='close' data-dismiss='modal' aria-hidden='true'></button>"
				  + "<h5 class='modal-title'>#= title #</h5>"
				  + "</div>"
				  + "<div id='#=uid#' class='modal-body'></div>"
				  + "<div class='modal-footer'>"
				  + "<button type='button' class='btn btn-primary rounded' data-action='update'>확인</button>"	
				  + "<button type='button' class='btn btn-default rounded' data-dismiss='modal' aria-hidden='true'>취소</button>"	
				  + "</div>"
				  + "</div><!-- /.modal-content -->"
				  + "</div><!-- /.modal-dialog -->"
				  + "</div><!-- /.modal -->")
	};

	
	function aceeditor( renderTo, options ){	
		if( renderTo.length > 0 && !common.ui.exists(renderTo) ){
			return new AceEditor(renderTo, options);	
		}	
		return renderTo.data("kendoAceEditor");
	}
	
	
	
	
	extend(common.ui, {
		editor : {
			ace : aceeditor
		}		
	});
	
	
})(jQuery);
