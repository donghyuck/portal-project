<#ftl encoding="UTF-8"/>
<html decorator="secure">
<head>
		<title>관리자 메인</title>		
		<link  rel="stylesheet" type="text/css"  href="<@spring.url "/styles/common.admin/pixel/pixel.admin.style.css"/>" />
		<#compress>		
		<script type="text/javascript">
		<!--		
		yepnope([{
			load: [
			'css!<@spring.url "/styles/font-awesome/4.3.0/font-awesome.min.css" />',
			'css!<@spring.url "/styles/font-icons/themify-icons.css"/>',
			'css!<@spring.url "/styles/common.plugins/animate.css" />',
			'css!<@spring.url "/styles/jquery.jgrowl/jquery.jgrowl.min.css" />',			
			'css!<@spring.url "/styles/common.admin/pixel/pixel.admin.widgets.css" />',			
			'css!<@spring.url "/styles/common.admin/pixel/pixel.admin.rtl.css" />',
			'css!<@spring.url "/styles/common.admin/pixel/pixel.admin.themes.css" />',
			'css!<@spring.url "/styles/common.admin/pixel/pixel.admin.pages.css" />',				
			'<@spring.url "/js/jquery/1.10.2/jquery.min.js" />',
			'<@spring.url "/js/kendo/kendo.web.min.js" />',
			'<@spring.url "/js/kendo.extension/kendo.ko_KR.js" />',
			'<@spring.url "/js/kendo/cultures/kendo.culture.ko-KR.min.js" />',
			'<@spring.url "/js/jquery.jgrowl/jquery.jgrowl.min.js" />',			
			'<@spring.url "/js/bootstrap/3.3.4/bootstrap.min.js" />',			
			'<@spring.url "/js/common.plugins/fastclick.js" />', 
			'<@spring.url "/js/common.plugins/jquery.slimscroll.min.js" />', 
			'<@spring.url "/js/common.admin/pixel.admin.min.js" />',
			'<@spring.url "/js/common/common.ui.core.js" />',							
			'<@spring.url "/js/common/common.ui.data.js" />',
			'<@spring.url "/js/common/common.ui.community.js" />',
			'<@spring.url "/js/common/common.ui.admin.js" />',
			'<@spring.url "/js/ace/ace.js"/>'		
			],
			complete: function() {
				var currentUser = new common.ui.data.User();
				var targetCompany = new common.ui.data.Company();	
				
				common.ui.admin.setup({					 
					authenticate : function(e){
						e.token.copy(currentUser);
						createPageList();
					},
					change: function(e){
						e.data.copy(targetCompany);
					}
				});	
									
				// END SCRIPT
			}
		}]);		
		
		function createPageList(){
			var renderTo = $("#site-page-list");
			renderTo.find(".nav-tabs").on( 'show.bs.tab', function (e) {		
				var show_bs_tab = $(e.target);
				switch( show_bs_tab.data("action") ){
						case "pages1" :
							createMappedPageGrid(renderTo.find(".pages"));
							break;
						case "pages2" :
							createPageGrid(renderTo.find(".pages"));
							break;	
				}	
			});			
			renderTo.find(".nav-tabs a:first").tab('show');		
		}
		
		function createPageGrid(renderTo){
			
		}
		
		function createMappedPageGrid(renderTo){
			if(! common.ui.exists(renderTo) ){
				common.ui.grid(renderTo, {
					dataSource: {
						transport: { 
							read: { url:'/secure/data/mgmt/website/pages/list.json?output=json', type:'get' },
							parameterMap: function (options, type){
								return { siteId: 1 }
							}
						},						
						batch: false, 
						pageSize: 15,
						schema: {
							data: "items",
							total: "totalCount",
							model: common.ui.data.WebPage
						}
					},
					columns: [
						{ title: "페이지", field: "name"},
						{ title: "", width:80, template: '<button type="button" class="btn btn-xs btn-labeled btn-info  btn-selectable" data-action="update" data-object-id="#= webPageId #"><span class="btn-label icon fa fa-pencil"></span> 변경</button>'}
					],
					toolbar: kendo.template('<div class="p-xs"><button class="btn btn-flat btn-labeled btn-outline btn-danger" data-action="create" data-object-id="0"><span class="btn-label icon fa fa-plus"></span> 페이지 추가 </button><button class="btn btn-flat btn-sm btn-outline btn-info pull-right" data-action="refresh" >새로고침</button></div>'),
					pageable: { refresh:true, pageSizes:false,  messages: { display: ' {1} / {2}' }  },	
					resizable: true,
					editable : false,
					selectable : "row",
					scrollable: true,
					height: 500,
					change: function(e) {
					},
					dataBound: function(e) {
					}	
				});		
				renderTo.find("button[data-action=refresh]").click(function(e){
					common.ui.grid(renderTo).dataSource.read();								
				});		
				$(document).on("click","[data-action=update],[data-action=create]", function(e){		
					var $this = $(this);		
					if( common.ui.defined($this.data("object-id")) ){
						var objectId = $this.data("object-id");						
						if( objectId > 0 ){
							openEditor(common.ui.grid(renderTo).dataSource.get(objectId));
						}else{
							openEditor(new common.ui.data.WebSite())
						}
					}
				});						
			}
		}
		
		function openEditor(source){			
			var renderTo = $("#site-page-editor");
			if( !renderTo.data("model")){									
				var  observable = kendo.observable({
					page : new common.ui.data.WebPage(),
					fileContent : "",
					customized : false,
					editable : false,
					enabled : false,
					cfg: function(e){
						var $this = this;
						var btn = $(e.target);	
						var action = btn.data("action");
						switch( action ){
							case "menu" :
							createMenuSelectModal($this);
							break;
							case "template" :
							createTemplateSelectModal($this);
							break;
							case "locale" :							
							break;												
						}		
					},				
					setSource : function(source){
						source.copy(this.page);			
						if( this.page.webPageId > 0 ){
							this.set("editable", true);
						}else{
							this.set("editable", false);		
							this.page.set("template", "");						
						}		
						this.set("fileContent", "");
						this.set("enabled", true);			
					}
				});								
				renderTo.data("model", observable );
				kendo.bind(renderTo, observable );				
				createEditorTabs(renderTo, observable);
			}			
			renderTo.data("model").setSource( source );			
			renderTo.find("ul.nav.nav-tabs a:first").tab('show');		
			if (!renderTo.is(":visible")) 
				renderTo.fadeIn();	 						
		}	

		function createMenuSelectModal(observable){
			var renderToString= "#my-menu-select-modal";
			if( $(renderToString).length === 0 ){			
				$("#main-wrapper").append( kendo.template($('#my-menu-select-modal-template').html()) );				
				var renderTo = $(renderToString);
				var rendetTo2 = renderTo.find(".menu-tree");
				renderTo.modal({
					backdrop: 'static',
					show : false
				});			
				createMenuTree(rendetTo2, observable);				
				//kendo.bind( renderTo, observable );				
						
				renderTo.find("[data-action=select]").click(function(e){			
					var item = getSelectedTreeItem(rendetTo2);
					if(  item.progenitor  ){
						alert("메뉴 아이템을 선택하여 주십시오.");
						return;
					}else{
						observable.page.set("template", item.name) ;
					}				
					renderTo.modal('hide');				
				});
			}
			$(renderToString).find(".menu-tree").data("kendoTreeView").select($());
			$(renderToString).modal('show');	
		}
				
		function createMenuTree(renderTo, observable){		
			if( !common.ui.exists(renderTo) ){					
				renderTo.kendoTreeView({
					dataSource: new kendo.data.HierarchicalDataSource({						
						transport: {
							read: {
								url : '<@spring.url "/secure/data/mgmt/website/navigator/items/list.json?output=json"/>',
								dataType: "json"
							},
							parameterMap: function (options, type){
								options.siteId = 1;
								if( options.name )
								{
									var item = renderTo.data("kendoTreeView").dataSource.get( options.name );
									return {siteId:1, menu:item.menu, item:item.name, progenitor: item.progenitor  };
								}else{
									return {siteId:1};
								}
							}
						},
						schema: {		
							model: {
								id: "name",
								hasChildren: "child"
							}
						}
					}),
					template: kendo.template($("#menu-treeview-template").html()),
					/*dataUrlField: "page", */
					dataTextField: "name",
					change: function(e) {				
					}
				});				
			}
		}					
				
		
		function createTemplateSelectModal(observable){
			var renderToString= "#my-template-select-modal";
			if( $(renderToString).length === 0 ){			
				$("#main-wrapper").append( kendo.template($('#my-template-select-modal-template').html()) );				
				var renderTo = $(renderToString);
				var rendetTo2 = renderTo.find(".template-tree");
				renderTo.modal({
					backdrop: 'static',
					show : false
				});			
				
				//kendo.bind( renderTo, observable );				
				createTemplateTree(rendetTo2, observable);				
				renderTo.find("[data-action=select]").click(function(e){
					var item = getSelectedTreeItem(rendetTo2) ;
					if( item.directory ){
						alert("파일을 선택하여 주십시오.");
						return;
					}else{
						observable.page.set("template", item.path) ;
					}		
					renderTo.modal('hide');				
				});
			}
			$(renderToString).find(".template-tree").data("kendoTreeView").select($());
			$(renderToString).modal('show');	
		}
	
		function getSelectedTreeItem( renderTo ){			
			var tree = renderTo.data('kendoTreeView');			
			var selectedCells = tree.select();			
			var selectedCell = tree.dataItem( selectedCells );   
			return selectedCell ;
		}
				
		function createTemplateTree(renderTo, observable){		
			if( !common.ui.exists(renderTo) ){					
				renderTo.kendoTreeView({
					dataSource: new kendo.data.HierarchicalDataSource({						
						transport: {
							read: {
								url : '<@spring.url "/secure/data/mgmt/template/list.json?output=json"/>',
								dataType: "json"
							}
						},
						schema: {		
							model: {
								id: "path",
								hasChildren: "directory"
							}
						},
						filter: { field: "path", operator: "doesnotcontain", value: ".svn" }	
					}),
					template: kendo.template($("#treeview-template").html()),
					dataTextField: "name",
					change: function(e) {				
					}
				});				
			}
		}	
				
		

		function createEditorTabs(renderTo, data){
			renderTo.find(".nav-tabs").on( 'show.bs.tab', function (e) {		
				var show_bs_tab = $(e.target);
				switch( show_bs_tab.data("action") ){
					case "properties" :
					createPagePropertiesGrid(renderTo.find(".properties"), data.page);
					break;
					case "template" :
					createTemplateEditor($("#htmleditor"), data);
					break;					
				}	
			});
		}	
		
		function createTemplateEditor(renderTo, data){
			if( renderTo.contents().length == 0 ){
				var editor = ace.edit(renderTo.attr("id"));		
				editor.getSession().setMode("ace/mode/ftl");
				editor.getSession().setUseWrapMode(true);	
				
				var switcher = renderTo.parent().find("input[name='warp-switcher']");			
				var preview = renderTo.parent().find("button[data-action='preview']");				
				

				
				preview.click(function(e){
					if($("#preview-window").data("kendoWindow")){
						$("#preview-window").data("kendoWindow").distory();
					}
					$("#preview-window").kendoWindow({
						position : {
							top: 50, left: 50
						},
						iframe: true,
						width: "700px",
						height: "80%",
						title: data.page.title ,
						content: "/display/0/" +data.page.name
					});
				}) 
					
				if( switcher.length > 0 ){
					$(switcher).switcher();
					$(switcher).change(function(){
						editor.getSession().setUseWrapMode($(this).is(":checked"));
					});		
				}									
			}			
			if( !data.get("fileContent") && data.page.template  ){
				common.ui.ajax(
				"<@spring.url "/secure/data/mgmt/template/get.json?output=json" />" , 
				{
					data : { path:  common.endsWith( data.page.template, ".ftl") ? data.page.template :  data.page.template + ".ftl" , customized: data.customized },
					success : function(response){
						data.set("fileContent", response.fileContent )
						ace.edit(renderTo.attr("id")).setValue( data.get("fileContent") );			
					}
				}); 				
			}
		}
		
		
		function createPagePropertiesDataSource(data){
			return common.ui.data.properties.datasource({
				transport: { 
					read: { url:'<@spring.url "/secure/data/mgmt/website/page/properties/list.json?output=json&pageId="/>' + data.webPageId, type:'post' },
					create: { url:'<@spring.url "/secure/data/mgmt/website/page/properties/update.json?output=json&pageId="/>' + data.webPageId , type:'post', contentType : "application/json" },
					update: { url:'<@spring.url "/secure/data/mgmt/website/page/properties/update.json?output=json&pageId="/>' + data.webPageId, type:'post', contentType : "application/json"  },
					destroy: { url:'<@spring.url "/secure/data/mgmt/website/page/properties/delete.json?output=json&pageId="/>' + data.webPageId, type:'post', contentType : "application/json" },
					parameterMap: function (options, operation){			
						if (operation !== "read" && options.models) {
							return kendo.stringify(options.models);
						}
					}
				}		
			});		
		}		
		
		function createPagePropertiesGrid(renderTo, data){
			if( ! renderTo.data("kendoGrid") ){
				renderTo.kendoGrid({
					columns: [
						{ title: "속성", field: "name", width: 250 },
						{ title: "값",   field: "value" },
						{ command:  { name: "destroy", template:'<a href="\\#" class="btn btn-xs btn-labeled btn-danger k-grid-delete"><span class="btn-label icon fa fa-trash"></span> 삭제</a>' },  title: "&nbsp;", width: 80 }
					],
					editable : true,
					scrollable: false,
					filterable: true,
					sortable: true,
					height: 400,
					toolbar: kendo.template('<div class="p-xs"><div class="btn-group"><a href="\\#"class="btn btn-primary btn-sm btn-flat btn-outline k-grid-add">추가</a><a href="\\#"class="btn btn-primary btn-sm btn-flat btn-outline k-grid-save-changes">저장</a><a href="\\#"class="btn btn-primary btn-sm btn-flat btn-outline k-grid-cancel-changes">취소</a></div><button class="btn btn-info btn-sm btn-flat btn-outline m-l-sm pull-right" data-action="refresh">새로고침</button></div>'),    
					change: function(e) {
					}
				});		
				renderTo.find("[data-action='refresh']").click( function(e){
					common.ui.grid(renderTo).dataSource.read();
				});	
			}
						
			if( common.ui.defined(renderTo.data("object-id"))){
				if( renderTo.data("object-id") == 0 || data.webPageId != renderTo.data("object-id") ){
					renderTo.data("object-id", data.webPageId );
					common.ui.grid(renderTo).setDataSource(createPagePropertiesDataSource(data));
				}
			}else{
				renderTo.data("object-id", data.webPageId );
				common.ui.grid(renderTo).setDataSource(createPagePropertiesDataSource(data));
			}
		}						
		
		
				
		
		function createEditorModeSwitcher(renderTo, editor ){
			var switcher = renderTo.find("input[name='warp-switcher']");				
			if( switcher.length > 0 ){
				$(switcher).switcher();
				$(switcher).change(function(){
					editor.getSession().setUseWrapMode($(this).is(":checked"));
				});		
			}		
		}
		
		function createSiteDetailsTabs(renderTo, data){
			renderTo.find(".nav-tabs").on( 'show.bs.tab', function (e) {		
				var show_bs_tab = $(e.target);
				switch( show_bs_tab.data("action") ){
					case "properties" :
					createSitePropertiesGrid(renderTo.find(".properties"), data.site );
					break;
					case "logo" :
					createSiteLogoGrid(renderTo.find(".logos"), renderTo.find("[name=logo-file]"), data.site );
					break;	
				}	
			});
		}				

		function createSiteLogoGrid(renderTo, renderTo2,  data){
			if( !common.ui.exists(renderTo2)){
				renderTo2.kendoUpload({
					multiple : false,
					width: 300,
				 	showFileList : false,
					localization:{ select : '파일 선택' , dropFilesHere : '업로드할 파일을 이곳에 끌어 놓으세요.' },
					async: {
						saveUrl:  '<@spring.url "/secure/data/mgmt/logo/upload.json?output=json"/>',							   
						autoUpload: true
					},
					upload: function (e) {								         
						e.data = {
							objectType : 30,
							objectId: data.webSiteId
						};														    								    	 		    	 
					},
					success : function(e) {								    
						if( e.response.success ){
							common.ui.grid(renderTo).dataSource.read();
						}
					}
				});								
			}						
			if( ! common.ui.exists(renderTo)){	
				common.ui.grid(renderTo,{
					dataSource: {
						type: "json",
						transport: { 
							read: { url:'<@spring.url "/secure/data/mgmt/logo/list.json?output=json"/>', type: 'POST' },
							parameterMap: function (options, type){
								return { objectType: 30, objectId: getEditorSource().site.webSiteId }
							}
						},
						schema: {
							data: "items",
							total: "totalCount",
							model : common.ui.data.Logo
						},
						batch: false
					},
					toolbar: kendo.template('<div class="p-xs pull-right"><button class="btn btn-info btn-sm btn-flat btn-outline m-l-sm" data-action="refresh">새로고침</button></div>'),    
					filterable: true,
					sortable: true,
					scrollable: true,
					selectable: false,
					columns:[
							{ title: "&nbsp;",  width:150, filterable: false, sortable: false, template:'<div class="text-center"><img alt="" class="img-thumbnail" src="<@spring.url "/secure/download/logo/#= logoId #?width=120&height=120" />"></div>' },
							{ field: "filename", title: "파일", template:'#:filename# <small><span class="label label-info">#: imageContentType #</span></small> #if( !primary ){ # <button class="btn btn-flat btn-xs btn-labeled btn-danger" data-action="primary" data-object-id="#= logoId#"><span class="btn-label icon fa fa-check-square"></span>선택</button> #}#' },
							{ field: "imageSize", title: "파일크기",  width: 150 , format: "{0:##,### bytes}" }
						],
					dataBound:function(e){
						renderTo.find("[data-action=primary]").click(function(e){
							var logoId = $(this).data("object-id");
							common.ui.ajax(
								"<@spring.url "/secure/data/mgmt/logo/set_primary.json"/>",
								{
									type : 'POST',
									url : '/data/streams/photos/delete.json?output=json' ,
									data: { logoId : logoId },
									success : function(response){
										renderTo.data("kendoGrid").dataSource.read();		
									},
									complete: function(){
										kendo.ui.progress(renderTo, false);
									}
							});		
						});
					}						
				});	
				renderTo.find("[data-action='refresh']").click( function(e){
					common.ui.grid(renderTo).dataSource.read();
				});
				
			}	
			renderTo.data("kendoGrid").dataSource.fetch();		
		}
								

										
		-->
		</script> 		 
		<style>
		#htmleditor {
			min-height:577px;
		}
		#site-page-editor {
			min-height:650px;
			background-color: #fff;
		}
		.layout-block {
			background: #8e8e93;
			 margin: 0 0 20px 0;
			border-top: 1px solid #8e8e93;				
		}
		.layout-block .left {
		  display: block;
		  width: 400px;
		  border-right: 1px solid #8e8e93;
		  padding: 15px;
		  float: left;
		  position: relative;
		  height: auto;
		}

		.layout-block .left .header {
		  text-align: center;
		  color: #aaa;
		  display: block;
		  text-transform: uppercase;
		  font-size: 11px;
		  font-weight: 600;
		  margin: -15px -15px 0 -15px;
		}
		
		.layout-block .right {
		  overflow: hidden;
		  float: none;
		  min-height:600px;
		}

		.layout-block .header, .layout-block .right > div {
		  padding: 15px;
		}

		.multi-pane-layout {
			display: -webkit-box;
			display: -webkit-flex;
			display: -ms-flexbox;
			display: flex
			width: 100%; 
			position:relative
		}
		
		.multi-pane-layout > aside {
			-webkit-box-flex:  0 0 400px;
			-webkit-flex:  0 0 400px;
			-ms-flex:  0 0 400px;
			flex: 0 0 400px
			display:block;					
			padding-right:10px;
		}	
		
		
		.multi-pane-layout > section.pane {
			-webkit-box-flex: 1;
			-webkit-flex: 1 1 auto;
			-ms-flex: 1 1 auto;
			flex: 1 1 auto;
			display:block;		
		}	
		
		@media (min-width: 768px) {

		}
		
		.k-checkbox-label {
		  font-weight: 100;
		  color: #737373;		
		}			
		
		</style>
		</#compress>		
	</head>
	<body class="theme-default main-menu-animated">
		<div id="main-wrapper">
			<#include "/html/common/common-system-navigation.ftl" >	
			<div id="content-wrapper">
				<ul class="breadcrumb breadcrumb-page">
					<#assign selectedMenu = WebSiteUtils.getMenuComponent("SYSTEM_MENU", "MENU_2_5_3") />
					<li><a href="#">Home</a></li>
					<li><a href="${ selectedMenu.parent.page!"#" }">${selectedMenu.parent.title}</a></li>
					<li class="active"><a href="#">${selectedMenu.title}</a></li>
				</ul>			
				<div class="page-header bg-dark-gray">					
					<h1><#if selectedMenu.isSetIcon() ><i class="fa ${selectedMenu.icon} page-header-icon"></i></#if> ${selectedMenu.title}  <small><i class="fa fa-quote-left"></i> ${selectedMenu.description!""} <i class="fa fa-quote-right"></i></small></h1>
				</div><!-- / .page-header -->	
				
				
				<div id="site-page-list" class="layout-block clearfix no-grid-gutter-h" style="margin-top:-26px;margin-bottom: 26px;">				
					<div class="left">
						<span class="header">웹 페이지</span>						
							<div class="panel panel colourable">		
								<div class="panel-heading">
									<span class="panel-title"><i class="fa fa-bars"></i></span>
									<ul class="nav nav-tabs nav-tabs-xs">
										<li class=""><a href="#my-pages-tabs-0" data-toggle="tab" data-action="pages1">웹 페이지 매핑</a></li>
										<!--	<li class=""><a href="#my-pages-tabs-1" data-toggle="tab" data-action="pages2">페이지</a></li>-->
									</ul>	
								</div>
								<div class="pages no-border"></div>	
							</div>						
													
					</div>					
					<div class="right">
						<div  id="site-page-editor"  data-bind="visible:enabled" style="display:none;">
							<div class="panel panel-transparent">
								<div class="panel-heading">
									<span class="panel-title"><i class="panel-title-icon fa fa-file text-danger"></i> <span data-bind="text:page.name"></span></span>
									<ul class="nav nav-tabs nav-tabs-simple">		
										<li><a href="#bs-tabdrop-pill1" data-toggle="tab" data-action="basic">기본정보</a></li>	
										<li><a href="#bs-tabdrop-pill2" data-toggle="tab" data-action="template">템플릿</a></li>
										<li><a href="#bs-tabdrop-pill3" data-toggle="tab" data-action="properties">속성</a></li>								
									</ul>																	
								</div>

								<div class="tab-content m-t-lg">
									<div class="tab-pane" id="bs-tabdrop-pill1">
										<div class="row">
											<div class="col-sm-6">
												<div class="form-group no-margin-hr">
													<label class="control-label" for="input-page-name">파일</label>
													<input type="text" class="form-control" id="input-page-name" data-bind="value:page.name">
													<p class="help-block small">중복되지 않는 파일명을 입력하세요.</p>
												</div>
											</div>
											<div class="col-sm-6">
												<div class="form-group no-margin-hr">
													<label class="control-label" for="input-page-contentType">콘텐츠 타입</label>
													<input type="text" class="form-control" id="input-page-contentType" data-bind="value:page.contentType">
													<p class="help-block small">콘텐츠 타입을 입력하세요.</p>												
												</div>
											</div>
										</div>
										<div class="row">
											<div class="col-sm-6">
												<div class="form-group no-margin-hr">
													<label class="control-label" for="input-page-displayName">타이틀</label>
													<input type="text" class="form-control" id="input-page-displayName" data-bind="value:page.displayName">
													<p class="help-block small">페이지 타이틀을 입력하세요.</p>
												</div>
											</div>
											<div class="col-sm-6">
												<div class="form-group no-margin-hr">			
													<label class="control-label" for="input-page-description">요약</label>
													<input type="text" class="form-control" id="input-page-description" data-bind="value: page.description">
													<p class="help-block small">간략하게 페이지를 기술하세요.</p>																					
												</div>
											</div>
										</div>												
										<div class="row">
											<div class="col-sm-6">
												<div class="form-group no-margin-hr">
													<label class="control-label" for="input-page-template">콘텐츠 템플릿</label>
													<input type="text" class="form-control" id="input-page-template" data-bind="value: page.template">				
													<p class="help-block small">템플릿 경로를 입력하거나 템플릿 선택을 클릭하여 선택하세요 </p>										
													<div class="p-xs">														
														<input type="checkbox" id="input-page-customized" class="k-checkbox" data-bind="checked: page.customized">
														<label class="k-checkbox-label small" for="input-page-customized">커스텀 템플릿 여부</label>													
													</div>																				
												</div>																								
											</div>
											<div class="col-sm-6">
												<div class="form-group no-margin-hr">		
													<label class="control-label" for="input-page-locale">국가</label>
													<input type="text" class="form-control" id="input-page-locale" data-bind="value: page.locale">
													<p class="help-block small">로케일 코드 값을 입력하세요 예)en, ko_KR </p>																						
												</div>
											</div>
										</div>														
										<div class="row">
											<div class="col-sm-6">
												<div class="switcher switcher-primary checked">
													<input type="checkbox" data-class="switcher-primary" checked="checked">
													<div class="switcher-toggler"></div>
													<div class="switcher-inner">
													<div class="switcher-state-on">ON</div>
													<div class="switcher-state-off">OFF</div>
													</div>
												</div>
												
												<div class="form-group no-margin-hr">
												
													<input type="checkbox" id="input-page-enabled" class="k-checkbox" data-bind="checked: page.enabled">
													<label class="k-checkbox-label" for="input-page-enabled">사용 여부</label>												
												</div>
											</div>
											<div class="col-sm-6">
												<div class="form-group no-margin-hr">		
												</div>
											</div>
										</div>				
										
																	
										<button class="btn btn-primary" type="button" data-toggle="collapse" data-target="#collapse1" aria-expanded="false" aria-controls="collapse1">ww</button>
										<div class="collapse" id="collapse1">
											<div class="well">
											...
											</div>
										</div>
										<div class="row">
											<div class="col-sm-6">
												<ul class="list-unstyled margin-bottom-30">
													<li class="p-xxs small"><strong>생성일:</strong> <span data-bind="text: page.formattedCreationDate"></span></li>
													<li class="p-xxs small"><strong>수정일:</strong> <span data-bind="text: page.formattedModifiedDate"></span></li>
												</ul>
											</div>
											<div class="col-sm-6">
													<p class="text-right">
														<div class="btn-group btn-sm">
														<button class="btn btn-flat btn-sm" type="button" data-bind="click: cfg" data-action="template"><i class="fa fa-file-code-o"></i> 템플릿 선택</button>
														<button class="btn btn-flat btn-sm" type="button" data-bind="click: cfg" data-action="menu"><i class="fa fa-bars"></i> 메뉴 설정</button>
														<button class="btn btn-flat btn-sm" type="button" data-bind="click: cfg" data-action="locale"><i class="fa fa-flag"></i> 국가 선택</button>
														</div>
													</p>												
											</div>
										</div>										
									</div>
									<div class="tab-pane" id="bs-tabdrop-pill2">
										<span data-bind="text:page.template"></span> <button class="btn btn-sm btn-success btn-flat pull-right" data-action="preview">미리보기</button>
										<h6 class="text-light-gray text-semibold">줄바꿈 설정/해지</h6>
										<input type="checkbox" name="warp-switcher" data-class="switcher-info" role="switcher" >
										<div id="htmleditor"></div>
									</div>
									<div class="tab-pane" id="bs-tabdrop-pill3">
										<div class="properties no-border" data-object-id="0"></div>
									</div>

								</div>
									<div class="panel-footer">
										<button class="btn btn-flat btn-primary" data-bind="events:{click:update}" data-loading-text="<i class='fa fa-spinner fa-spin'></i>">저장</button>
									</div>
						</div>
					</div>
				</div>						
			</div> <!-- / #content-wrapper -->
			<div id="main-menu-bg">
			</div>
		</div> <!-- / #main-wrapper -->
		<div id="preview-window"></div>
		<script id="my-menu-select-modal-template" type="text/kendo-ui-template">
		<div id="my-menu-select-modal" class="modal fade" tabindex="-1" role="dialog" aria-labelledby=".modal-title" aria-hidden="true">
			<div class="modal-dialog">	
				<div class="modal-content">
					<div class="modal-header">
						<button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
						<h4 class="modal-title">메뉴 선택</h4>
					</div>					
					<div class="modal-body">
						<div class="menu-tree"></div>
					</div>
					<div class="modal-footer">					
						<button type="button" class="btn btn-primary btn-flat btn-sm" data-action="select" data-loading-text='<i class="fa fa-spinner fa-spin"></i>'>선택</button>					
						<button type="button" class="btn btn-default btn-flat btn-sm" data-dismiss="modal">닫기</button>
					</div>					
				</div>
			</div>
		</div>
        </script>			
		<script id="my-template-select-modal-template" type="text/kendo-ui-template">
		<div id="my-template-select-modal" class="modal fade" tabindex="-1" role="dialog" aria-labelledby=".modal-title" aria-hidden="true">
			<div class="modal-dialog">	
				<div class="modal-content">
					<div class="modal-header">
						<button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
						<h4 class="modal-title">템플릿 선택</h4>
					</div>					
					<div class="modal-body">
						<div class="template-tree"></div>
					</div>
					<div class="modal-footer">					
						<button type="button" class="btn btn-primary btn-flat btn-sm" data-action="select" data-loading-text='<i class="fa fa-spinner fa-spin"></i>'>선택</button>					
						<button type="button" class="btn btn-default btn-flat btn-sm" data-dismiss="modal">닫기</button>
					</div>					
				</div>
			</div>
		</div>
		</script>	
		<script id="menu-treeview-template" type="text/kendo-ui-template">
			#if(item.progenitor){#
			<i class="fa fa-bars"></i>	 #: item.title # <span class="text-muted">#:item.name#</span>		
			 #}else{# 
			<i class="fa fa-file-text-o"></i> #: item.title # <span class="text-muted">#:item.name#</span>	
			 #}#	
		</script>
		<script id="treeview-template" type="text/kendo-ui-template">
			#if(item.directory){#<i class="fa fa-folder-open-o"></i> # }else{# <i class="fa fa-file-code-o"></i> #}#
			#: item.name # 	
			# if (!item.items) { #
			<a class='delete-link' href='\#'></a> 
			# } #
		</script>	        								
		<#include "/html/common/common-system-templates.ftl" >			
	</body>    
</html>