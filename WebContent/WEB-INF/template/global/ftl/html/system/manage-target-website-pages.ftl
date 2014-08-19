<#ftl encoding="UTF-8"/>
<html decorator="secure">
	<head>
		<title>시스템 정보</title>
<#compress>	
		<link  rel="stylesheet" type="text/css"  href="${request.contextPath}/styles/common.admin/pixel/pixel.admin.style.css" />		
		<script type="text/javascript"> 
		yepnope([{
			load: [ 
			'css!${request.contextPath}/styles/font-awesome/4.1.0/font-awesome.min.css',
			'css!${request.contextPath}/styles/common.plugins/animate.css',
			'css!${request.contextPath}/styles/common.admin/pixel/pixel.admin.widgets.css',			
			'css!${request.contextPath}/styles/common.admin/pixel/pixel.admin.rtl.css',
			'css!${request.contextPath}/styles/common.admin/pixel/pixel.admin.themes.css',
			'css!${request.contextPath}/styles/common.admin/pixel/pixel.admin.pages.css',	
			'css!${request.contextPath}/styles/perfect-scrollbar/perfect-scrollbar-0.4.9.min.css',
			'${request.contextPath}/js/jquery/1.10.2/jquery.min.js',			
			'${request.contextPath}/js/kendo/kendo.web.min.js',
			'${request.contextPath}/js/kendo.extension/kendo.ko_KR.js',
			'${request.contextPath}/js/kendo/cultures/kendo.culture.ko-KR.min.js',			
			'${request.contextPath}/js/jgrowl/jquery.jgrowl.min.js',						
			'${request.contextPath}/js/bootstrap/3.0.3/bootstrap.min.js',						
			'${request.contextPath}/js/common.plugins/fastclick.js', 
			'${request.contextPath}/js/common.plugins/jquery.slimscroll.min.js', 
			'${request.contextPath}/js/perfect-scrollbar/perfect-scrollbar-0.4.9.min.js', 			
			'${request.contextPath}/js/common.admin/pixel.admin.min.js',			
			'${request.contextPath}/js/common/common.models.js',       	    
			'${request.contextPath}/js/common/common.api.js',
			'${request.contextPath}/js/common/common.ui.js',
			'${request.contextPath}/js/common/common.ui.admin.js',			
			'${request.contextPath}/js/ace/ace.js'
			],        	      	   
			complete: function() {               
				
				// 1-1.  한글 지원을 위한 로케일 설정
				common.api.culture();
				// 1-2.  페이지 렌딩
				common.ui.landing();				
				// 1-3.  관리자  로딩
				var currentUser = new User();		
					
				common.ui.admin.setup({
					menu : {toggleClass : "mmc"},
					authenticate: function(e){
						e.token.copy(currentUser);
					}
				});		
																		
				// 3.MENU LOAD 
				var companyPlaceHolder = new Company({ companyId: ${action.user.companyId} });
				
												 
				 // 4. PAGE MAIN		
				 var sitePlaceHolder = new common.models.WebSite( {webSiteId: ${ action.targetWebSite.webSiteId}} );
				 $("#website-info").data("sitePlaceHolder", sitePlaceHolder );
				 
				common.api.callback(  
				{
					url :"${request.contextPath}/secure/get-site.do?output=json", 
					data : { targetSiteId:  sitePlaceHolder.webSiteId },
					success : function(response){
						var site = new common.models.WebSite(response.targetWebSite);
						site.copy( sitePlaceHolder );
						kendo.bind($("#website-info"), sitePlaceHolder );
						$('button.btn-control-group').removeAttr("disabled");	
						emptyPageEditorSource();
						preparePageEditor();												
					}
				}); 
												
				common.ui.handleButtonActionEvents(
					$("button.btn-control-group"), 
					{event: 'click', handlers: {
						'page-create' : function(e){
							$("#page-list-panel").hide();
							emptyPageEditorSource();
							showPageEditor();							
						},			
						'page-editor-close' : function(e){
							//kendo.fx($("#page-editor-panel")).expand("vertical").duration(200).reverse();								
							//kendo.fx($("#page-list-panel")).expand("vertical").duration(200).play();				
							$('#page-editor-panel').hide();	
							common.ui.animate_v3($('#page-list-panel'), 'fadeInDown').show() ;					
						},
						back : function(e){
							goWebsite();					
						}																  						 
					}}
				);		
				
				common.ui.handleButtonActionEvents(
					$("button.btn-page-control-group"), 
					{event: 'click', handlers: {
						'page-publish' : function(e){
							var editor = $('#webpage-editor').data("model");							
							editor.page.set('pageState', 'PUBLISHED');
							editor.doSave(e);	
							$("#website-page-grid").data('kendoGrid').refresh();
						},										
						'page-delete' : function(e){
							var editor = $('#webpage-editor').data("model");					
							$("#website-page-grid").data('kendoGrid').refresh();
						},															  						 
					}}
				);
				createPageGrid();
			}
		}]);
			

		function goWebsite (){					
			common.api.teleportation().teleport({
				action : '${request.contextPath}/secure/view-site.do',
				targetSiteId : $("#website-info").data("sitePlaceHolder").webSiteId
			});						
		}
				
		function goPage (page){		
			$("form[name='openpage-form'] input[name='name']").val( page.name );
			$("form[name='openpage-form']").submit();			
		}
		
		function doPageEdit(){
			//kendo.fx($("#page-list-panel")).expand("vertical").duration(200).reverse();
			$("#page-list-panel").hide();
			showPageEditor();							
		}		
		
		function doPageDelete(){
			var grid = $("#website-page-grid").data("kendoGrid");
			var selectedCells = grid.select();d
			var selectedCell = grid.dataItem( selectedCells ); 		
			alert("delete") ;
		}
		
		function openPage(){
			var page = selectedPage();
			goPage( page );
		}		
		
		function selectedPage(){
			var grid = $("#website-page-grid").data('kendoGrid');
			var selectedCells = grid.select();
			var selectedCell = grid.dataItem( selectedCells );   
			return selectedCell;
		}
				
		function createPageGrid(){
			if(!$("#website-page-grid").data('kendoGrid') ){
			
				var sitePlaceHolder = $("#website-info").data("sitePlaceHolder");
				
				$("#website-page-grid").kendoGrid({
                    dataSource: {
                    	serverFiltering: false,
                        transport: { 
                            read: { url:'${request.contextPath}/secure/list-website-page.do?output=json', type: 'POST' },
	                        parameterMap: function (options, type){
	                            return { startIndex: options.skip, pageSize: options.pageSize,  targetSiteId: sitePlaceHolder.webSiteId }
	                        }
                        },
                        schema: {
                            total: "targetPageCount",
                            data: "targetPages",
                            model: common.models.Page
                        },
                        error:handleKendoAjaxError,
                        batch: false,
                        pageSize: 15,
                        serverPaging: false,
                        serverFiltering: false,
                        serverSorting: false
                    },
                    columns: [
                        { field: "pageId", title: "ID", width:50,  filterable: false, sortable: false , headerAttributes: { "class": "table-header-cell", style: "text-align: center" }}, 
                        { field: "name", title: "이름", width: 100, headerAttributes: { "class": "table-header-cell", style: "text-align: center"}}, 
                        { field: "title", title: "제목", width: 350 , headerAttributes: { "class": "table-header-cell", style: "text-align: center" }, template: $('#webpage-title-template').html() }, 
                        { field: "versionId", title: "버전", width: 80, headerAttributes: { "class": "table-header-cell", style: "text-align: center" } },
                        { field: "pageState", title: "상태", width: 120, headerAttributes: { "class": "table-header-cell", style: "text-align: center" }, template: '#if ( pageState === "PUBLISHED" ) { #<span class="label label-success">#: pageState #</span>#}else{# <span class="label label-danger">#: pageState #</span> #}#'},
                        { field: "user.username", title: "작성자", width: 100, headerAttributes: { "class": "table-header-cell", style: "text-align: center" } },
                        { field: "creationDate",  title: "생성일", width: 120,  format:"{0:yyyy.MM.dd}", headerAttributes: { "class": "table-header-cell", style: "text-align: center" } },
                        { field: "modifiedDate", title: "수정일", width: 120,  format:"{0:yyyy.MM.dd}", headerAttributes: { "class": "table-header-cell", style: "text-align: center" } } ],         
                    filterable: true,
                    sortable: true,
                    resizable: true,
                    pageable: { refresh:true, pageSizes:false,  messages: { display: ' {1} / {2}' }  },
                    selectable: 'row',
                    height: '100%',
                    change: function(e) {                    
                        var selectedCells = this.select();                 
  						if( selectedCells.length > 0){ 
							var selectedCell = this.dataItem( selectedCells ); 
							setPageEditorSource(selectedCell);
							if( selectedCell.pageId > 0 ){
								if( selectedCell.pageState === 'PUBLISHED' )
									$('button.btn-page-control-group[data-action="page-delete"]').removeAttr("disabled");
								else
									$('button.btn-page-control-group').removeAttr("disabled");
							}
 						} 						
					},
					dataBound: function(e){		
						$("button.btn-page-control-group").attr("disabled", "disabled");
					}
				}).data('kendoGrid');
			}
		}		
		
		function showPageEditor(){		
			preparePageEditor();
			$("button.btn-editor-control-group[data-action='page-editor-save']").attr('disabled', 'disabled');			
			common.ui.animate_v3($('#page-editor-panel'), 'slideInRight').show() ;
		}
		
		function preparePageEditor(){
			var renderToString = "webpage-editor";
			createEditor(renderToString);
		}
				
		function emptyPageEditorSource(){
			var newPage = new common.models.Page();
			newPage.objectId = $("#website-info").data("sitePlaceHolder").webSiteId ;
			setPageEditorSource(newPage);
		}

		function setPageEditorSource(source){
			var renderToString = "webpage-editor";				
			var renderTo = $("#"+ renderToString );						
			if( !renderTo.data("pagePlaceHolder") ){
				renderTo.data("pagePlaceHolder", new common.models.Page() );
				kendo.bind(renderTo, renderTo.data("pagePlaceHolder"));
			}		
			source.copy(renderTo.data("pagePlaceHolder"));
		}
		
		function getPageEditorSource () {
			var renderToString = "webpage-editor";	
			var renderTo = $("#"+ renderToString );	
			return renderTo.data("pagePlaceHolder");
		}
		
		function createEditor( renderToString ){				
			var renderTo = $("#"+ renderToString);		
			var pagePlaceHolder = renderTo.data("pagePlaceHolder");									
			var bodyEditor =  $("#"+ renderToString +"-body" );
			if(!bodyEditor.data("kendoEditor") ){			
				var pageEditorModel = kendo.observable({
					page : pagePlaceHolder,
					properties : new kendo.data.DataSource({
						transport: { 
							read: { url:'${request.contextPath}/secure/list-website-page-property.do?output=json', type:'post' },
							create: { url:'${request.contextPath}/secure/update-website-page-property.do?output=json', type:'post' },
							update: { url:'${request.contextPath}/secure/update-website-page-property.do?output=json', type:'post'  },
							destroy: { url:'${request.contextPath}/secure/delete-website-page-property.do?output=json', type:'post' },
					 		parameterMap: function (options, operation){			
						 		if (operation !== "read" && options.models) {
						 			return { targetPageId: getPageEditorSource().pageId, items: kendo.stringify(options.models)};
								} 
								return { targetPageId: getPageEditorSource().pageId }
							}
						},	
						batch: true, 
						schema: {
							data: "targetPageProperty",
							model: Property
						},
						error : common.api.handleKendoAjaxError
					}),					
					isVisible: true,
					isNew : true,
					isPublished : false,
					updateRequired : false,
					onPublish: function(e){					
						this.page.set('pageState', 'PUBLISHED');
						this.doSave(e);
					},
					value : function( value ){
						if( typeof value === 'undefined' ){
							return this.page.bodyText ;
						}else{
							this.page.set('bodyText' , value);
						}
					},
					showProps: function(e){
						if( this.page.pageId > 0 ){
							this.properties.read();				
						}							
						renderTo.find('.custom-props' ).toggleClass('hide');
					},	
					openPage: function(e){
						goPage(this.page);
					},										
					doSave : function (e) {						
						var btn = $(e.target);
						btn.button('loading');
						common.api.callback(  
						{
							url :"${request.contextPath}/secure/update-website-page.do?output=json", 
							data : { targetSiteId:  this.page.objectId, item: kendo.stringify(this.page) },
							success : function(response){
								common.ui.notification({title:"페이지 저장", message: "페이지 가 정상적으로 저장되었습니다.", type: "success" });
								var pageToUse = new common.models.Page(response.targetPage);																
								pageToUse.copy( pagePlaceHolder );
								$("#website-page-grid").data('kendoGrid').dataSource.read();
							},
							fail: function(){								
								common.ui.notification({title:"페이지 저장 오류", message: "시스템 운영자에게 문의하여 주십시오." });
								var newPage = new common.models.Page();
								newPage.copy(pagePlaceHolder);
							},
							requestStart : function(){
								kendo.ui.progress(renderTo, true);
							},
							requestEnd : function(){
								kendo.ui.progress(renderTo, false);
							},
							always : function(e){
								btn.button('reset');
							}							
						});
					}
				});				
				pageEditorModel.bind("change", function(e){
					// alert( e.field ) ;				
					if( e.field.match('^page.')){ 						
						if( this.page.title.length > 0 && this.page.bodyText.length  > 0 )					
							pageEditorModel.set("updateRequired", true);
					}	
				});								
				kendo.bind(renderTo, pageEditorModel );
				renderTo.data("model", pageEditorModel );										
				var imageBroswer = createPageImageBroswer( renderToString + "-imagebroswer", bodyEditor, pageEditorModel);				
				var linkPopup = createPageLinkPopup(renderToString + "-linkpopup", bodyEditor);	
				var htmlEditor = createCodeEditor(renderToString + "-html-editor", bodyEditor, pageEditorModel);									
				bodyEditor.kendoEditor({
						tools : [
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
							},
							{
								name: 'viewHtml',
								exec: function(e){
									htmlEditor.open();
									return false;
								}								
							}
							
						],
						stylesheets: [
							"${request.contextPath}/styles/bootstrap/3.1.0/bootstrap.min.css",
							"${request.contextPath}/styles/common/common.ui.css"
						]
				});
			}
			
			if( pagePlaceHolder.pageState === 'pagePlaceHolder' ){
				renderTo.data("model").set("isPublished", true );				
			}			
		
			renderTo.data("model").set("isPublished", (pagePlaceHolder.pageState ==='PUBLISHED') ? true : false );			
			renderTo.data("model").set("isNew", (pagePlaceHolder.pageId > 0) ? false : true );		
			renderTo.data("model").set("updateRequired", false);		
		}	
		
		function createCodeEditor( renderToString, editor, pageEditorModel ) {		
			if( $("#"+ renderToString).length == 0 ){
				$('body').append('<div id="'+ renderToString +'"></div>');
			}							
			var renderTo = $("#"+ renderToString);		
			if( !renderTo.data('kendoExtModalWindow') ){						
				renderTo.extModalWindow({
					title : "HTML",
					backdrop : 'static',
					template : $("#code-editor-modal-template").html(),
					refresh : function(e){
						var editor = ace.edit("htmleditor");
						editor.getSession().setMode("ace/mode/xml");
						editor.getSession().setUseWrapMode(true);						
					},
					open: function (e){
						//ace.edit("htmleditor").setValue(editor.data('kendoEditor').value());
						ace.edit("htmleditor").setValue(pageEditorModel.value());
					}					
				});					
				renderTo.find('button.custom-update').click(function () {
					var btn = $(this)			
					var newValue = ace.edit("htmleditor").getValue();
					var oldValue = pageEditorModel.value(); // editor.data("kendoEditor").value();
					// editor.data("kendoEditor").value(newValue);
					if( newValue.length != oldValue.length ){
						pageEditorModel.value( newValue ) ;
					}
					ace.edit("htmleditor").setValue("");
					renderTo.data('kendoExtModalWindow').close();
				});
			}
			return renderTo.data('kendoExtModalWindow');			
		}
				
		function createPageImageBroswer(renderToString, editor, pageEditorModel ){			
			if( $("#"+ renderToString).length == 0 ){
				$('body').append('<div id="'+ renderToString +'"></div>');
			}					
			var renderTo = $("#"+ renderToString);	
			if(!renderTo.data("kendoExtImageBrowser")){
				var imageBrowser = renderTo.extImageBrowser({
					data : pageEditorModel.page,
					template : $("#image-broswer-template").html(),
					apply : function(e){						
						editor.data("kendoEditor").exec("inserthtml", { value : e.html } );
						imageBrowser.close();
					}				
				});
			}
			return renderTo.data("kendoExtImageBrowser");
		}
		
		function createPageLinkPopup(renderToString, editor){		
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
			
		</script>
		<style type="text/css" media="screen">

		.k-grid-content{
			height:540px;
		}			
		
		table.k-editor{
			height : 500px;
		}
		
						
		</style>		
		</#compress>		
	</head>
	<body class="theme-default main-menu-animated">
		<div id="main-wrapper">
			<#include "/html/common/common-system-navigation.ftl" >	
			<div id="content-wrapper">
				<#assign selectedMenu = WebSiteUtils.getMenuComponent("SYSTEM_MENU", "MENU_2_4") />
				<ul class="breadcrumb breadcrumb-page">
					<!--<div class="breadcrumb-label text-light-gray">You are here: </div>-->
					<li><a href="#">Home</a></li>
					<li><a href="${ selectedMenu.parent.page!"#" }">${selectedMenu.parent.title}</a></li>
					<li class="active"><a href="#">${selectedMenu.title}</a></li>
				</ul>
				<div class="page-header bg-dark-gray">		
					<div class="row">
						<h1 class="col-xs-12 col-sm-6 text-center text-left-sm"><#if selectedMenu.isSetIcon() ><i class="fa ${selectedMenu.icon} page-header-icon"></i></#if> ${selectedMenu.title}
							<p><small><i class="fa fa-quote-left"></i> ${selectedMenu.description} <i class="fa fa-quote-right"></i></small></p>
						</h1>						
					</div>				
				</div><!-- / .page-header -->
				<!-- details-row -->
				<div class="row">	
					<div class="col-lg-12">
						<div  id="page-list-panel" class="panel panel-default" style="min-height:300px;">
							<div class="panel-heading">
								<span class="panel-title"><button type="button" class="btn-link btn-control-group" data-action="back"><i class="fa fa fa-level-up fa-lg"></i></button><small class="text-danger">( 웹 페이지는 게시 상태에서 보여집니다.)</small></span>
								<!--
								<div class="btn-group">
									<button type="button" class="btn btn-info btn-control-group btn-sm" data-action="group"><i class="fa fa-users"></i> 그룹관리</button>
									<button type="button" class="btn btn-info btn-control-group btn-sm" data-action="user"><i class="fa fa-user"></i> 사용자관리</button>
								</div>			
								<div class="btn-group">
									<button type="button" class="btn btn-primary btn-control-group btn-sm" data-action="back" disabled="disabled"  title="사이트 상세로 이동" ><i class="fa fa-level-up"></i></button>			
								</div>
								-->							
								<div class="panel-heading-controls">
									
									<button class="btn btn-danger btn-labeled btn-control-group" data-action="page-create" disabled="disabled"><span class="btn-label icon fa fa-plus"></span> 새 페이지 만들기 </button>
									<div class="btn-group">
										<!--<button type="button" class="btn btn-danger btn-control-group" data-action="page-create" disabled="disabled"><i class="fa fa-file"></i> 새 페이지</button>-->
										<button type="button" class="btn btn-info btn-page-control-group" data-action="page-publish" disabled="disabled" data-loading-text='<i class="fa fa-spinner fa-spin"></i>'><i class="fa fa-external-link"></i> 게시</button>
										<button type="button" class="btn btn-info btn-page-control-group" data-action="page-delete" disabled="disabled" data-loading-text='<i class="fa fa-spinner fa-spin"' ><i class="fa fa-trash-o"></i> 삭제</button>
									</div>
								</div>																
						</div>
						<div class="table">
							<div id="website-page-grid" class="no-border"></div>																		
						</div>					
					</div>
					<div  id="page-editor-panel" class="panel panel-default" style="min-height:300px; display:none;">	
						<div class="panel-heading">
							<span class="panel-title"><small><i class="fa fa-info"></i> 웹 페이지는 게시 상태에서 보여집니다.</small></span>
							<button type="button" class="close btn-control-group" data-action="page-editor-close">&times;  <small style="font-size: 15px;vertical-align: top;line-height:  1.5;">닫기</small></button>
						</div>
						<div  class="panel-body padding-sm form-horizontal">	
							<div  id="webpage-editor" class="container">
								<div class="row">
									<div class="col-lg-12">
											<div class="pull-right">
												<div class="btn-group">
													<button type="button" class="btn btn-primary btn-flat" data-bind="click: onPublish, disabled: isPublished"  data-loading-text='<i class="fa fa-spinner fa-spin"></i>' >게시</button>
													<button type="button" class="btn btn-primary btn-flat" data-action="page-editor-save" data-bind="click: doSave, enabled: updateRequired" data-loading-text='<i class="fa fa-spinner fa-spin"></i>'>저장</button>
													<button type="button" class="btn btn-primary btn-flat" data-toggle="button"  data-bind="click: showProps, disabled: isNew, invisible:isNew ">프로퍼티</button>
													<button type="button" class="btn btn-primary btn-flat" data-bind="click: openPage, disabled: isNew" >미리보기</button>
												</div>												
											</div>												
									</div>
								</div>
								<div class="row">
									<div class="form-group no-margin-hr">
										<label class="control-label">페이지 제목 </label> <small class="text-danger">필수 입력항목입니다.</small>
										<input type="text" class="form-control" placeholder="페이지 제목" data-bind="value: page.title">
									</div>						
								</div>
								<div class="row">
									<div class="col-md-6">
										<div class="row">
											<div class="form-group no-margin-hr">
												<p><span class="label label-danger">버전</span> <code data-bind="text: page.versionId">0</code> <small class="text-muted">버전 값을 자동생성됩니다.</small></p>
											</div>										
											<div class="form-group no-margin-hr">
												<label class="control-label">템플릿 </label> <small class="text-muted">페이지에 적용할 템플릿 파일 경로를 입력하세요</small>
												<input type="text" class="form-control" placeholder="템플릿 파일" value="/html/community/page.ftl">	
												<p class="help-block"></p>
											</div>
											<div class="form-group no-margin-hr">
												<label class="control-label">페이지 요약 </label> <small class="text-muted">페이지를 간략하게 설명하세요.</small>
												<textarea class="form-control" rows="3" data-bind="value: page.summary" placeholder="페이지 요약"></textarea>
											</div>
										</div>	
									</div>
									<div class="col-md-6 custom-props hide" style="margin-bottom: 10px;">
										<h4>									 
											<small class="text-primary"><i class="fa fa-info"></i> 프로퍼티는 변경 후 저장버튼을 클릭하면 반영됩니다.</small>
										</h4>
										<div data-role="grid"
													date-scrollable="false"
													data-editable="true"
													data-autoBind="false"
													data-toolbar="[ { 'name': 'create', 'text': '추가' }, { 'name': 'save', 'text': '저장' }, { 'name': 'cancel', 'text': '취소' } ]"
													data-columns="[
														{ 'title': '이름',  'field': 'name', 'width': 200 },
														{ 'title': '값', 'field': 'value' },
														{ 'command' :  { 'name' : 'destroy' , 'text' : '삭제' },  'title' : '&nbsp;', 'width' : 100 }
													]"
													data-bind="source: properties, visible: isVisible"
										style="height: 300px"></div>							
									</div>									
								</div>		
								<div class="row">
									<textarea id="webpage-editor-body" rows="5" cols="30" data-bind="value: page.bodyText" placeholder="페이지 본문"></textarea>
								</div>	
							</div>			
						</div>
					</div>	
				</div>
			</div>
							
				
				<!-- ./details-row -->			
			</div> <!-- / #content-wrapper -->
			<div id="main-menu-bg"></div>
		</div> <!-- / #main-wrapper -->				
			
		<!-- START MAIN CONTNET -->
		

		<div id="website-info" ></div>  
		<div id="account-panel" ></div>    		
		<!-- END MAIN CONTNET -->
		<!-- START FOOTER -->
		<footer>  		
		</footer>
		<!-- END FOOTER -->
		<script id="webpage-title-template" type="text/x-kendo-template">
			#= title #
			<div class="btn-group btn-group-xs pull-right">
				<a href="\\#" onclick="doPageEdit(); return false;" class="btn btn-info btn-sm">편집</a>
				<a href="\\#" onclick="openPage(); return false;" class="btn btn-info btn-sm">미리보기</a>
			</div>	
		</script>				
		<script id="webpage-name-template" type="text/x-kendo-template">
			<span class="label label-primary label-lightweight">#= name #</span>
			<div class="btn-group btn-group-xs">
				<a href="\\#" onclick="doPageEdit(); return false;" class="btn btn-info btn-sm">편집</a>
				<a href="\\#" onclick="openPage(); return false;" class="btn btn-info btn-sm">미리보기</a>
			</div>	
			<!--
			<div class="btn-group">
			  <button type="button" class="btn btn-info btn-sm dropdown-toggle" data-toggle="dropdown">
			    #= name # <span class="caret"></span>
			  </button>
			  <ul class="dropdown-menu" role="menu">
			    <li><a href="\\#" onclick="doPageEdit(); return false;">편집</a></li>
			    <li><a href="\\#" onclick="openPage(); return false;">보기</a></li>
			    <li><a href="\\#" onclick="doPageDelete(); return false;">삭제</a></li>
			  </ul>
			</div>
			-->
		</script>			
		<#include "/html/common/common-system-templates.ftl" >		
		<#include "/html/common/common-editor-templates.ftl" >	
	</body>
</html>