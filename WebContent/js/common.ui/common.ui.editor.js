/**
 * Editor Extensions.
 * 
 * Copyright 2016 podosoftware.
 */

(function($, undefined) {
	var ui = common.ui,
	kendo = window.kendo, 
	Widget = kendo.ui.Widget, 
	isPlainObject = $.isPlainObject, 
	proxy = $.proxy, 
	extend = $.extend, 
	isArray = $.isArray,
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
	PROGRESS = "progress",
	UNDEFINED = 'undefined',
	POST = 'POST', 
	JSON = 'json',
	MODAL = '.modal',
	MODAL_HEADER = '.modal-header',
	MODAL_TITLE = '.modal-title',
	MODAL_BODY = '.modal-body',
	DataSource = kendo.data.DataSource,
	progress = kendo.ui.progress,
	isLocalUrl = kendo.isLocalUrl;	
	
	var DEFAULT_DATASOURCE_SETTING = {
			transport:{
				read:{
					type :POST,
					dataType : JSON
				}
			},
			schema: {
			    data: function(response) {
			     return [response];
			    }
			},
			serverPaging: false
	};
	
	var DEFAULT_ACE_EDITOR_SETTING = {
			mode : "ace/mode/xml",
			theme : "ace/theme/xcode",
			useWrapMode : false
		};	
	
	
	var AceEditor = Widget.extend({
		init : function(element, options) {
			
			var that = this, wrapper, content, id;
			
			options = isArray(options) ? { dataSource: options } : options;
			
			Widget.fn.init.call(that, element, options);
			
			options = that.options;
			element = that.element;
            content = options.content;
            wrapper = that.wrapper = element.children(MODAL);
            
            that.appendTo = $(options.appendTo);            
            if (!wrapper[0]) {           	
            	that._createModal(element, options);  	
            }            
            that._ace();
            that._dataSource();
			kendo.notify(that);
		},
		events : [ 
		    ERROR, 
		    CHANGE, 
		    CLICK, 
		    OPEN, 
		    REFRESH, 
		    APPLY,
		    CLOSE ],
		options : {
			name : "AceEditor",		
			modal: true,
			title : "HTML",
			content: null,
			appendTo: "body",
			value : null,
			transport : {},
			editable : false,
			uid : kendo.guid()
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
			editor = that.editor ;
			if (value === undefined) {
                return editor.getValue();
            }else{
            	editor.setValue(value);
            }
		},
		_ace : function(){
			var that = this,
			options = that.options;			
			var settings = extend(true, {}, DEFAULT_ACE_EDITOR_SETTING , options ); 				
			that.editor = ace.edit(settings.uid);	
			that.editor.setTheme(settings.theme );
			that.editor.getSession().setMode(settings.mode) ;
			that.editor.getSession().setUseWrapMode(settings.useWrapMode);
		},
		_modals : function() {
			var that = this;
			return that.element.children(MODAL);
		},
		_progress:function(toggle){
			var element = this.element;
			kendo.ui.progress(element.find(MODAL), toggle);
		},
        _error: function() {
            this._progress(false);
        },
        _requestStart: function() {
            this._progress(true);
        },
		_dataSource: function() {
			 var that = this,
             options = that.options,
             dataSource = options.dataSource;
			 
			 dataSource = isArray(dataSource) ? { data: dataSource } : extend(true, {}, DEFAULT_DATASOURCE_SETTING , dataSource );
			 console.log(kendo.stringify(dataSource));
			 if (that.dataSource && that._refreshHandler) {
				 
			 }else{
				 that._progressHandler = proxy(that._requestStart, that);
	             that._errorHandler = proxy(that._error, that);	             
			 }
			 that.dataSource = DataSource.create(dataSource)
			 .bind(CHANGE, function(){
				 var data = this.view(),
				 item = data[0];
				 if( item.fileContent){
					 that.editor.setValue(item.fileContent);
				 }
				 that._progress(false);
			 })
             .bind(PROGRESS, that._progressHandler)
             .bind(ERROR, that._errorHandler);		
		},
		_createModal : function() {
			var contentHtml = this.element,
            options = this.options,
            that = this,
            wrapper;		
			
			wrapper = $(templates.modal(options));	
			
			contentHtml.append(wrapper);		
			
			if( contentHtml.find('[name=enabled-switcher]').length > 0){
				var changeCheckbox = contentHtml.find('[name=enabled-switcher]')[0];
				var switchery = new Switchery(changeCheckbox, {size:'small'});
				changeCheckbox.onchange = function(){
					that.editor.getSession().setUseWrapMode(changeCheckbox.checked);
				}				
			}
			that.element.find('.modal button[data-action=update]').click(function(e){
				if( options.editable && that.dataSource ){
					var data = that.dataSource.view(),
					item = data[0];
					item.fileContent = that.editor.getValue() ;
					console.log( kendo.stringify(item));
				}
				that.trigger(APPLY, {});
				that.close();		
			});	
			
			that.element.find(MODAL).on('show.bs.modal', function(e) {
				that.trigger(OPEN, {});
			});
			that.element.find(MODAL).on('hide.bs.modal', function(e) {
				that.trigger(CLOSE, {});
			});	
		}
	});
	
	templates = {
		modal : kendo.template(
				"<div class='modal fade' tabindex='-1' role='dialog' aria-hidden='true'>"
				  + "<div class='modal-dialog modal-lg'>"
				  + "<div class='modal-content'>"
				  + "<div class='modal-header'>"
			  	  + "<div class='modal-tools'>"
			  	  + "<input type='checkbox' name='enabled-switcher'data-class='switcher-primary' role='switcher'>"
			  	  + "</div>"			  	  
			  	  + "<button type='button' class='close' data-dismiss='modal' aria-hidden='true'></button>"			  	  
				  + "<h5 class='modal-title'>#= title #</h5>"
				  + "</div>"
				  + "<div id='#=uid#' class='modal-body'></div>"
				  + "<div class='modal-footer'>"
				  + "<button type='button' class='btn btn-default rounded' data-dismiss='modal' aria-hidden='true'>닫기</button>"	
				  + "#if(editable){ #"
				  + "<button type='button' class='btn btn-primary rounded' data-action='update'>확인</button>"	
				  + "#}#"
				  + "</div>"
				  + "</div><!-- /.modal-content -->"
				  + "</div><!-- /.modal-dialog -->"
				  + "</div><!-- /.modal -->"),
		modal2 : kendo.template(
				"<div class='modal fade' tabindex='-1' role='dialog' aria-hidden='true'>"
				  + "<div class='modal-dialog modal-lg'>"
				  + "<div class='modal-content'>"
				  + "<div class='modal-header'>"
			  	  + "<div class='modal-tools'>"
			  	  + "</div>"			  	  
			  	  + "<button type='button' class='close' data-dismiss='modal' aria-hidden='true'></button>"			  	  
				  + "<h5 class='modal-title'>#= title #</h5>"
				  + "</div>"
				  + "<div class='modal-body'>"
				  + "<div class='tab-v1'>"
				  + "<ul class='nav nav-tabs' role='tablist'>"
				  + "  <li role='presentation'><a href='\\##= uid #-tab1' aria-controls='#= uid #-tab1' role='tab' data-toggle='tab' class='rounded-top'> 업로드 </a></li>"
				  + "  <li role='presentation'><a href='\\##= uid #-tab2' aria-controls='#= uid #-tab2' role='tab' data-toggle='tab' class='rounded-top'> MY 드라이버 </a></li>"
				  + "  <li role='presentation'><a href='\\##= uid #-tab3' aria-controls='#= uid #-tab3' role='tab' data-toggle='tab' class='rounded-top'> URL 에서 선택</a></li>"
				  + "</ul>"
				  + "<div class='tab-content'>"
				  + "  <div role='tabpanel' class='tab-pane' id='#= uid #-tab1'>...</div>"
				  + "  <div role='tabpanel' class='tab-pane' id='#= uid #-tab2'>...</div>"
				  + "  <div role='tabpanel' class='tab-pane' id='#= uid #-tab3'>"
				  + "   <h5 ><i class='fa fa-link'></i><strong>URL</strong>&nbsp;<small>이미지 URL 경로를 입력하세요.</small></h5>"
				  + "	<div class='form-group'>"
				  + "		<input type='url' class='custom-img-url form-control' placeholder='URL 입력'>"
				  + "	</div>"
				  + " 	<img class='custom-img-preview img-responsive' />"
				  + "  </div>"
				  + "</div>"
				  +"</div>"
				  +"</div>"
				  + "<div class='modal-footer'>"
				  + "<button type='button' class='btn btn-primary rounded' data-action='apply'>선택한 이미지 추가</button>"	
				  + "<button type='button' class='btn btn-default rounded' data-dismiss='modal' aria-hidden='true'>취소</button>"	
				  + "</div>"
				  + "</div><!-- /.modal-content -->"
				  + "</div><!-- /.modal-dialog -->"
				  + "</div><!-- /.modal -->"
		)
	};


	var ImageBroswer = Widget.extend({
		init : function(element, options) {
			var that = this;
            options = options || {};			
            Widget.fn.init.call(that, element, options);
            
            that.element.addClass("imagebrowser");
            
            that._dataSource();
            that.refresh();
		},
		options: {
            name: "ExtImageBrowser",
            title : "Image Browser",
            modal: true,
            uid : guid(),
            transport: {},
            fileTypes: "*.png,*.gif,*.jpg,*.jpeg"
        },
        events: [ERROR, CHANGE, APPLY],
        refresh: function() {
            var that = this;
            that._modal();
            
            
        },
        _dataSource: function(){
        	
        	
        	
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
				that.element.find( MODAL_BODY +' ul.nav-tabs a').first().click();
				that.element.children(MODAL).modal('show');
			}			
		},
		close : function() {
			var that = this,
			options = this.options;
			if(options.modal){
				that.element.children(MODAL).modal('hide');
			}
		},
		_tabs : function(){
			var that = this;
		},
		_modals : function() {
			var that = this;
			return that.element.children(MODAL);
		},
		_modal : function() {
        	var that = this,
        	options = this.options,
        	template = kendo.template(templates.modal2);       
        	that.modal = $(template(that.options))
        	.appendTo(that.element)
        	.find('input[type=url].custom-img-url').on( 'change', function() {
				var url = $(this);
				//var img = $('#' + options.uid + '-tab3').children('img');
				console.log('img changed');
				var img = that.element.find('img.custom-img-preview');
				if (url.val().length > 0) {
					img.attr('src', url.val()).load(
						function() {	
						
						}).error(function(){
														
						});
				}
				
        	});	
        },
        _dataSource: function() {
        	
        	
        	
        }
	});
	
	
	function imagebroswer( renderTo, options ){	
		if( renderTo.length > 0 && !common.ui.exists(renderTo) ){
			return new ImageBroswer(renderTo, options);	
		}	
		return renderTo.data("kendoExtImageBrowser");
	}
	
	function aceeditor( renderTo, options ){	
		if( renderTo.length > 0 && !common.ui.exists(renderTo) ){
			return new AceEditor(renderTo, options);	
		}	
		return renderTo.data("kendoAceEditor");
	}
	
	extend(common.ui, {
		editor : {
			ace : aceeditor,
			imagebroswer : imagebroswer
		}		
	});
	
	
})(jQuery);
