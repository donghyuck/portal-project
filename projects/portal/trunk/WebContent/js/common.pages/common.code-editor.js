<!-- ============================== -->
<!-- Utils for editor									       -->
<!-- ============================== -->						
function createEditor( renderToString, bodyEditor, options ){
	options = options || {};		
	if( !common.ui.defined(options.modal)  ){
		options.modal = true;
	}	
	if(!bodyEditor.data("kendoEditor") ){			
		var imageBroswer = createEditorImageBroswer( renderToString + "-imagebroswer", bodyEditor);				
		var linkPopup = createEditorLinkPopup(renderToString + "-linkpopup", bodyEditor);	
		var htmlEditor = createCodeEditor(renderToString + "-code-editor", bodyEditor, options );							
		var htmlEditorTools = [
			'bold', 
			'italic', 
			'insertUnorderedList', 
			'insertOrderedList',
			{	
				name: "createLink",
				exec: function(e){
					linkPopup.show();
					return false;
				}
			},
			'unlink', 
			{	
				name: "insertImage",
				exec: function(e){
					imageBroswer.show();
					return false;
				}
			}
		];		
				
		if( options.modal ){
			htmlEditorTools.push({
				name: 'viewHtml',
				exec: function(e){
					htmlEditor.open();
					return false;
				}
			});
		}		
		bodyEditor.kendoEditor({
			tools :htmlEditorTools,
			stylesheets: DEFAULT_HTML_EDITOR_STYLESHEETS
		});
	}			
}

var DEFAULT_HTML_EDITOR_STYLESHEETS = [
 	"/styles/fonts/nanumgothic.css",
	"/styles/bootstrap/3.3.4/bootstrap.min.css",
	"/styles/fonts/nanumgothic.css",
	"/styles/common.themes/unify/style.css",
	"/styles/common/common.ui.css"
];


var DEFAULT_ACE_EDITOR_SETTING = {
	modal : true,
	mode : "ace/mode/xml",
	theme : "ace/theme/xcode",
	useWrapMode : true		
};

function createCodeEditor( renderToString, editor, options ) {		
	options = options || {};		
	var settings = $.extend(true, {}, DEFAULT_ACE_EDITOR_SETTING , options ); 
	if( settings.modal ){		
		if( $("#"+ renderToString).length == 0 ){
			$("body").append('<div id="'+ renderToString +'"></div>');	
		}
		var renderTo = $("#"+ renderToString);	
		
		if( !renderTo.data('kendoExtModalWindow') ){				
			renderTo.extModalWindow({
				title : "HTML",
				backdrop : 'static',
				template : $("#code-editor-modal-template").html(),
				refresh : function(e){
					var editor = ace.edit("modal-htmleditor");
					editor.getSession().setMode(settings.mode);
					editor.getSession().setUseWrapMode(settings.useWrapMode);
				},
				open: function (e){
					ace.edit("modal-htmleditor").setValue(editor.data('kendoEditor').value());
				}					
			});				
			renderTo.find('button.custom-update').click(function () {
				var btn = $(this)			
				editor.data("kendoEditor").value( ace.edit("modal-htmleditor").getValue() );
				renderTo.data('kendoExtModalWindow').close();
			});			
		}	
		return renderTo.data('kendoExtModalWindow');			
	}else{	
		if( $("#"+ renderToString).length == 0 ){
			if( common.ui.defined( settings.appendTo)  ){
				settings.appendTo.append('<div id="'+ renderToString +'"></div>');					
			}else{				
				editor.parent().append('<div id="'+ renderToString +'"></div>');					
			}
		}
		
		var _editor = ace.edit(renderToString);
		_editor.setTheme(settings.theme);
		_editor.getSession().setMode(settings.mode);
		_editor.getSession().setUseWrapMode(settings.useWrapMode);		
		
		var controllerClass = kendo.Class.extend({			
			ace : null,
			editor : null,
			init: function(ace, editor) {
				this.editor = editor;
				this.ace = ace;
			},
			open : function(){		
				this.ace.setValue( this.editor.data("kendoEditor").value() )
			},
			close : function(){
				this.editor.data("kendoEditor").value( this.ace.getValue() );
			}				
		});
		
		var controller = new controllerClass(_editor, editor);

		if( common.ui.defined(settings.tab)){
			settings.tab.find('a[data-toggle="tab"]').on('shown.bs.tab', function(e){
				e.target ; // newly activated tab
				e.relatedTarget ; // previous active tab
				switch($(e.target).data("action-target")){
				case "editor" :
					controller.close();
					break;
				case "ace" :
					controller.open();
					break;				
				}				
			});			
		}
		
		return controller;
	}	
}
		
function createEditorImageBroswer(renderToString, editor ){			
	if( $("#"+ renderToString).length == 0 ){
		$('body').append('<div id="'+ renderToString +'"></div>');
	}					
	var renderTo = $("#"+ renderToString);	
	if(!renderTo.data("kendoExtImageBrowser")){
		var imageBrowser = renderTo.extImageBrowser({
			template : $("#image-broswer-template").html(),
			apply : function(e){						
				editor.data("kendoEditor").exec("inserthtml", { value : e.html } );
				imageBrowser.close();
			}				
		});
	}
	return renderTo.data("kendoExtImageBrowser");
}

function createEditorLinkPopup(renderToString, editor){		
	if( $("#"+ renderToString).length == 0 ){
		$('body').append('<div id="'+ renderToString +'"></div>');
	}				
	var renderTo = $("#"+ renderToString);		
	if(!renderTo.data("kendoExtEditorPopup") ){		
		var hyperLinkPopup = renderTo.extEditorPopup({
			type : 'createLink',
			title : "하이퍼링크 삽입",
			template : $("#link-popup-template").html(),
			apply : function(e){						
				editor.data("kendoEditor").exec("inserthtml", { value : e.html } );
				hyperLinkPopup.close();
			}
		});
	}
	return renderTo.data("kendoExtEditorPopup");
}	