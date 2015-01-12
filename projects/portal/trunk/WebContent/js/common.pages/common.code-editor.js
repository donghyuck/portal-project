<!-- ============================== -->
<!-- Utils for editor									       -->
<!-- ============================== -->						
function createEditor( renderToString, bodyEditor, options ){
	options =  options || {};
	
	if(!bodyEditor.data("kendoEditor") ){			
		var imageBroswer = createEditorImageBroswer( renderToString + "-imagebroswer", bodyEditor);				
		var linkPopup = createEditorLinkPopup(renderToString + "-linkpopup", bodyEditor);	
		var htmlEditor = createCodeEditor(renderToString + "-code-editor", bodyEditor, options );							
		
		
		bodyEditor.kendoEditor({
				tools : [ 'bold', 'italic', 'insertUnorderedList', 'insertOrderedList',
					{	
						name: "createLink",
						exec: function(e){
							linkPopup.show();
							return false;
						}},
					'unlink', 
					{	
						name: "insertImage",
						exec: function(e){
							imageBroswer.show();
							return false;
						}},
					{
						name: 'viewHtml',
						exec: function(e){
							htmlEditor.open();
							return false;
						}}							
				],
				stylesheets: [
					"/styles/fonts/nanumgothic.css",
					"/styles/bootstrap/3.1.1/bootstrap.min.css",
					"/styles/fonts/nanumgothic.css",
					"/styles/common.themes/unify/style.css",
					"/styles/common/common.ui.css"
				]
		});
	}			
}

var DEFAULT_ACE_EDITOR_SETTING = {
	modal : true,
	mode : "ace/mode/xml",
	useWrapMode : true		
}

function createCodeEditor( renderToString, editor, options ) {		
	options = options || {};		
	var settings = $.extend(true, {}, DEFAULT_ACE_EDITOR_SETTING , options ); 
	alert( kendo.stringify(settings));
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
					var editor = ace.edit("htmleditor");
					editor.getSession().setMode(settings.mode);
					editor.getSession().setUseWrapMode(settings.useWrapMode);
				},
				open: function (e){
					ace.edit("htmleditor").setValue(editor.data('kendoEditor').value());
				}					
			});				
			renderTo.find('button.custom-update').click(function () {
				var btn = $(this)			
				editor.data("kendoEditor").value( ace.edit("htmleditor").getValue() );
				renderTo.data('kendoExtModalWindow').close();
			});			
		}	
		return renderTo.data('kendoExtModalWindow');			
	}else{	
		if( $("#"+ renderToString).length == 0 ){
			editor.parent().append('<div id="'+ renderToString +'"></div>');	
		}	
		var _editor = ace.edit(renderToString);
		_editor.getSession().setMode(settings.mode);
		_editor.getSession().setUseWrapMode(settings.useWrapMode);
		
		var p = new kendo.Class.extend({
			open : function(){
				this.editor.data("kendoEditor").value( _editor.edit("htmleditor").getValue() );				
			}			
		});
		
		return new p();
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