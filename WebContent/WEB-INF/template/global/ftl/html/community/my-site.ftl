<#ftl encoding="UTF-8"/>
<html decorator="unify">
<head>
		<#assign page = action.getPage() >
		<title><>${page.title}</title>
		<#compress>		
		<script type="text/javascript">
		<!--
		var jobs = [];					
		yepnope([{
			load: [
			'css!<@spring.url "/styles/font-awesome/4.3.0/font-awesome.min.css"/>',
			'css!<@spring.url "/styles/bootstrap.themes/unify/1.9.1/headers/header-default.css"/>',		
			'css!<@spring.url "/styles/bootstrap.themes/unify/1.9.1/theme-colors/dark-red.css"/>',	
			'css!<@spring.url "/styles/bootstrap.themes/unify/1.9.1/theme-skins/dark.css"/>',

			'css!<@spring.url "/styles/bootstrap.themes/common/common.ui.inspinia.css"/>',
			'css!<@spring.url "/styles/bootstrap.themes/common/common.ui.buttons.css"/>',

			'css!<@spring.url "/styles/common.ui/common.ui.color-icons.css"/>',			
			'css!<@spring.url "/styles/common/common.flat-icons.css"/>',	
			'css!<@spring.url "/styles/common.pages/common.personalized.css"/>',
						
			'css!<@spring.url "/styles/jquery.magnific-popup/magnific-popup.css"/>',		
			'css!<@spring.url "/styles/jquery.sky-forms/2.0.1/custom-sky-forms.css"/>',
			'css!<@spring.url "/styles/hover-effect/hover-min.css"/>',		
				
			'css!<@spring.url "/styles/codrops/codrops.dialog.css"/>',		
			'css!<@spring.url "/styles/codrops/codrops.dialog-val.css"/>',			
			'css!<@spring.url "/styles/codrops/codrops.cbp-spmenu.css"/>',		
			
			'<@spring.url "/js/jquery/1.10.2/jquery.min.js"/>',
			'<@spring.url "/js/jgrowl/jquery.jgrowl.min.js"/>',
			'<@spring.url "/js/jquery.magnific-popup/jquery.magnific-popup.min.js"/>',	
			
			'<@spring.url "/js/kendo/kendo.web.min.js"/>',
			'<@spring.url "/js/kendo.extension/kendo.ko_KR.js"/>',			
			'<@spring.url "/js/kendo/cultures/kendo.culture.ko-KR.min.js"/>',	

			'<@spring.url "/js/bootstrap/3.3.4/bootstrap.min.js"/>',
			'<@spring.url "/js/common.plugins/jquery.slimscroll.min.js"/>', 		
			'<@spring.url "/js/common.plugins/query.backstretch.min.js"/>', 

			'<@spring.url "/js/common/common.ui.core.js"/>',							
			'<@spring.url "/js/common/common.ui.data.js"/>',
			'<@spring.url "/js/common/common.ui.data.admin.js"/>',
			'<@spring.url "/js/common/common.ui.community.js"/>',
			'<@spring.url "/js/common.pages/common.personalized.js"/>',
			
			'<@spring.url "/js/ace/ace.js"/>',
			'<@spring.url "/js/common.pages/common.code-editor.js"/>'			
			],			
			complete: function() {		
				
				common.ui.setup({
					features:{
						wallpaper : false,
						accounts : {
							authenticate : function(e){
								e.token.copy(currentUser);
								getSiteListView().dataSource.read();
								/*
								alert( currentUser.hasRole('ROLE_ADMIN') || currentUser.hasRole('ROLE_SYSTEM') );
								if( !currentUser.anonymous ){		
									$("#announce-selector label.btn").last().removeClass("disabled");									 
								}
								
								common.ui.data.permissions({
									data : {
										objectType : 30,
										objectId: ${ action.webSite.webSiteId },
										permission : 'WEBSITE_ADMIN'
									},
									success : function(data){
										console.log( common.ui.stringify( data ) );
									}
								});
								*/
							} 
						}						
					},
					wallpaper : {
						renderTo:$(".breadcrumbs-v3")
					},	
					jobs:jobs
				});		
						
				// ACCOUNTS LOAD			
				var currentUser = new common.ui.data.User();
				createSiteListView();
				
				
				/*	
				$(".navbar-nav li[data-menu-item='MENU_PERSONALIZED'], .navbar-nav li[data-menu-item='MENU_PERSONALIZED_1']").addClass("active");
				*/
				/**
				common.ui.buttonGroup($("#personalized-buttons"), {
					handlers :{
						"open-menu-editor" : function(e){
							openMenuEditor();
						},
						"open-template-editor" : function(e){
							openTemplateEditor();
						}
					}
				});
						
				$(".wrapper>.container.content:first .nav-tabs a[data-toggle=tab]").on('show.bs.tab', function (e) {
					e.target // newly activated tab
					e.relatedTarget // previous active tab					
					var renderTo = $(e.target);					
					if( renderTo.attr('href') == '#website-page' ){			
						createPageSection();
					}else if ( renderTo.attr('href') == "#website-notice"){
						createNoticeSection();	
					}							
				});
				
				$(".wrapper>.container.content:first .nav-tabs a[data-toggle=tab]:first").tab('show');
				**/		
				// END SCRIPT 				
			}
		}]);	
		
		<!-- ============================== -->
		<!-- WEB SITE LISTVIEW				-->
		<!-- ============================== -->		
		function getSiteListView(){
			var renderTo = $("#my-site-listview");
			if(! common.ui.exists(renderTo) ){
				createSiteListView();
			}
			return common.ui.listview(renderTo);
		}
		
		function createSiteListView(){
			var renderTo = $("#my-site-listview");
			if(! common.ui.exists(renderTo) ){
				common.ui.listview(renderTo, {
					autoBind:false,
					dataSource: {
						transport: { 
							read: { url:'<@spring.url "/secure/data/mgmt/website/list.json?output=json "/>', type:'post' }
						},						
						batch: false, 
						pageSize: 15,
						schema: {
							data: "items",
							total: "totalCount",
							model: common.ui.data.WebSite
						}
					},
					template: kendo.template($("#my-site-listview-template").html()),
					selectable: "row",
					dataBound:function(){
						renderTo.removeClass("k-widget");     
					},
					change : function (){
						var data = this.dataSource.view() ;
						var index = this.select().index();
						var item = data[index];	
	                  	createSiteDetails( item );			
					}
				});					           
			}	
		}		
		<!-- ============================== -->
		<!-- WEB SITE DETAILS				-->
		<!-- ============================== -->
		function createSiteDetails(source){
			var renderTo = $("#my-site-details");			
			if(!renderTo.data("model")){
				console.log("create data");
				var observable =  common.ui.observable({
					site : new common.ui.data.WebSite(),
					setSource : function(source){
						source.copy(this.site);
						renderTo.find(".nav-tabs a[data-toggle=tab]:first").tab('show');
					}	
				});	
				renderTo.data("model", observable);					
				renderTo.find(".nav-tabs a[data-toggle=tab]").on('show.bs.tab', function (e) {
					e.target // newly activated tab
					e.relatedTarget // previous active tab		
					switch ($(e.target).attr('href'))
					{
						case '#my-site-page' :
						createWebPageGrid();
						break;
						case '#my-site-announce' :
						break;						
					}	
					return;				
				});											
			}			
			renderTo.data("model").setSource( source );			
			if (!renderTo.is(":visible")) 
				renderTo.fadeIn(); 		
		} 
		
		function getSelectedSite(){
			var renderTo = $("#my-site-details");
			return renderTo.data("model").get('site');
		} 
				   	

		function createPageGrid(site){
			
		}
				
		function createWebPageGrid(){
			var renderTo = $("#my-site-web-page-grid");	
			if(! common.ui.exists(renderTo) ){			
				common.ui.grid(renderTo, {
					autoBind : false,
					dataSource: {
						transport: { 
							read: { url:'<@spring.url "/secure/data/mgmt/website/pages/list.json?output=json" />', type:'get' }
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
						{ title: "", width:80, template: '<button type="button" class="btn btn-xs btn-labeled btn-primary rounded btn-selectable" data-action="edit" data-object-id="#= webPageId #"><span class="btn-label icon fa fa-pencil"></span> 변경</button>'}
					],
					toolbar: kendo.template('<div class="p-xs"><button class="btn btn-flat btn-labeled btn-outline btn-danger rounded" data-action="create" data-object-id="0"><span class="btn-label icon fa fa-plus"></span> 페이지 추가 </button></div>'),
					pageable: { refresh:true, pageSizes:false,  messages: { display: ' {1} / {2}' }  },	
					resizable: true,
					editable : false,
					selectable : "row",
					scrollable: true,
					change: function(e) {
					},
					dataBound: function(e) {
					}	
				});	
				renderTo.on("click","[data-action=edit],[data-action=create]", function(e){	
					var $this = $(this);	
					var objectId = $this.data("object-id");		
					var newWebPage ;	
									
					if( objectId > 0){
						newWebPage = common.ui.grid(renderTo).dataSource.get(objectId);
					}else{
						newWebPage = new common.ui.data.WebPage();
						newWebPage.set("webSiteId", getSelectedSite().webSiteId);
						newWebPage.set("properties", {});
					}	
					
					renderTo.fadeOut(function(e){ 
						createWebPageEditor( newWebPage );
					});					
					
				});		
			}
			common.ui.grid(renderTo).dataSource.read( {siteId: getSelectedSite().webSiteId} );
		}
		
		function createWebPageEditor( source ){
			var renderTo = $("#my-site-web-page-view");
			if(!renderTo.data("model")){
				console.log("create data");
				var observable =  common.ui.observable({
					page : new common.ui.data.WebPage(),
					setSource : function(source){
						source.copy(this.page);						
					},
					close:function(){
						renderTo.fadeOut(function(e){ 
							$("#my-site-web-page-grid").fadeIn();
						});
					}	
				});	
				renderTo.data("model", observable);		
				common.ui.bind( renderTo, observable );
			}
			
			renderTo.data("model").setSource( source );	
			if (!renderTo.is(":visible")) 
				renderTo.fadeIn(); 	
		}
									
		<!-- ============================== -->
		<!-- MENU							-->
		<!-- ============================== -->
		function openMenuEditor(){
			var renderTo = $("#my-site-menu-editor");
			if( ! common.ui.exists(renderTo) ){
				var observable =  common.ui.observable({
					website : new common.ui.data.WebSite(),
					updateMenuData : function(e){			
						var $this = this;
						var btn = $(e.target);						
						btn.button('loading');						
						$this.website.menu.menuData = ace.edit("menueditor").getValue();
						common.ui.ajax(
							'<@spring.url "/secure/data/menu/update.json?output=json" />' , 
							{
								data : kendo.stringify( $this.website.menu ),
								contentType : "application/json",
								success : function(response){},
								fail: function(){								
									common.ui.notification({
										hide:function(e){
											btn.button('reset');
										}
									}).show(
										{	title:"공지 저장 오류", message: "시스템 운영자에게 문의하여 주십시오."	},
										"error"
									);	
								},
								requestStart : function(){
									kendo.ui.progress(renderTo, true);
								},
								requestEnd : function(){
									kendo.ui.progress(renderTo, false);
								},
								complete : function(e){
									$this.refresh();
									btn.button('reset');
								}
							}
						);												
					},
					useWrapMode : false,
					useWrap : function(e){
						ace.edit("menueditor").getSession().setUseWrapMode(this.useWrapMode);
					},
					refresh : function(){
						var $this = this;
						common.ui.ajax(
							'<@spring.url "/secure/data/website/get.json?output=json" />' , 
							{
								data : {
									refresh : true,
								},
								success : function(response){					
									var website = new common.ui.data.WebSite(response);
									website.copy($this.website);
								}
							}
						);						
					}
				});				
				var editor = ace.edit("menueditor");		
				editor.setTheme("ace/theme/monokai");
				editor.getSession().setMode("ace/mode/xml");	
				observable.bind("change", function(e){		
					var sender = e.sender ;
					if( e.field.match('^website.menu')){
					 	editor.setValue( sender.website.menu.menuData );	
					}
				});	
				common.ui.dialog( renderTo , {
					data : observable,
					"open":function(e){		
						$("body").css("overflow-y", "hidden");						
						renderTo.find(".dialog__content").css("overflow-y", "auto");					
					},
					"close":function(e){			
						renderTo.find(".dialog__content").css("overflow-y", "hidden");					
						$("body").css("overflow-y", "auto");		
					}
				});
				common.ui.bind(renderTo, observable );	
				observable.refresh();			
			}			
			var dialogFx = common.ui.dialog( renderTo );		
			if( !dialogFx.isOpen ){							
				dialogFx.open();
			}			
		}				
		<!-- ============================== -->
		<!-- TEMPLATE												-->
		<!-- ============================== -->		
		function openTemplateEditor(){
			var renderTo = $("#my-site-template-editor");
			if( ! common.ui.exists(renderTo) ){
				var observable =  common.ui.observable({
					file : new common.ui.data.FileInfo(),
					content : "",
					visible : false,
					supportCustomized : false,
					supportUpdate : false,
					supportSvn : true,
					openFileUpdateModal : function(){
						alert("준비중입니다");
						return false;
					},
					openFileCopyModal : function(e){
						alert("준비중입니다");
						return false;
					},
					useWrapMode : false,
					useWrap : function(e){
						ace.edit("templateeditor").getSession().setUseWrapMode(this.useWrapMode);
					},					
					setFile : function( fileToUse ) {	
						$this = this;
						$this.file.path = fileToUse.get("path");
						$this.file.set("customized", fileToUse.get("customized") );
						$this.file.set("absolutePath", fileToUse.get("absolutePath") );
						$this.file.set("name", fileToUse.get("name"));
						$this.file.set("size", fileToUse.get("size") );
						$this.file.set("directory", fileToUse.get("directory"));
						$this.file.set("lastModifiedDate", fileToUse.get("lastModifiedDate") );						
						if( !$this.file.customized && !$this.file.directory ) {
							$this.set("supportCustomized", true); 
						}else{
							$this.set("supportCustomized", false); 
						}				    	
						if( $this.file.path.indexOf( ".svn" ) != -1 ) {
							$this.set("supportSvn", false); 
						}else{
							$this.set("supportSvn", true); 
						}						
						if(!$this.file.directory){
							common.ui.ajax(
							'<@spring.url "/secure/data/template/get.json?output=json" />' , 
							{
								data : { path:  $this.file.path , customized: $this.file.customized },
								success : function(response){
									ace.edit("templateeditor").setValue( response.fileContent );	
								}
							}); 
				    	}
				    	$this.set("visible", true);		    					    			
					}, 
					createCustomizedTemplate : function(e){
						e.preventDefault();						
						$this = $(e.target);
						$this.button("loading");
						var input1 =  $("#file-copy-modal-input-sites").val();
						var input2 =  $("#file-copy-modal-input-target").val();						
						if( input1.length == 0 || input2.length == 0 ){
							if( !$("#file-copy-modal .tab-content").hasClass("has-error") ){
								$("#file-copy-modal .tab-content").addClass("has-error");
							}	
						}else{
							if( $("#file-copy-modal .tab-content").hasClass("has-error") ){
								$("#file-copy-modal .tab-content").removeClass("has-error");
							}						
						}						
						$this.button("reset");																		
						return false;
					}
				});				
				
				var editor = ace.edit("templateeditor");		
				editor.getSession().setMode("ace/mode/ftl");
				editor.getSession().setUseWrapMode(true);	
								
				common.ui.dialog( renderTo , {
					data : observable,
					"open":function(e){		
						$("body").css("overflow-y", "hidden");						
						renderTo.find(".dialog__content").css("overflow-y", "auto");					
					},
					"close":function(e){			
						renderTo.find(".dialog__content").css("overflow-y", "hidden");					
						$("body").css("overflow-y", "auto");		
					}
				});				
				$('#template-tree-tabs').on( 'show.bs.tab', function (e) {		
					var target = $(e.target);
					switch( target.attr('href') ){
						case "#template-tree-view" :
							createTemplateTree($("#template-tree-view"), false);
							break;
						case  '#custom-template-tree-view' :
							createTemplateTree($("#custom-template-tree-view"), true);
							break;
					}					
				});												
				common.ui.bind(renderTo, observable );		
			}			
			var dialogFx = common.ui.dialog( renderTo );		
			if( !dialogFx.isOpen ){	
				$('#template-tree-tabs a:first').tab('show');						
				dialogFx.open();
			}			
		}
				
		function createTemplateTree(renderTo, customized){
			if( !renderTo.data('kendoTreeView') ){					
				renderTo.kendoTreeView({
					dataSource: {
						transport: { 
							read: { url: '<@spring.url "/secure/data/template/list.json?output=json"/>' , type: 'POST' },
							parameterMap: function ( options, operation){			
								options.customized = customized;
								return options ;
							}
						},
						schema: {		
							model: {
								id : "path",
								hasChildren: "directory"
							}
						},
						filter:[
							{field: "name", operator : "neq", value:".svn" }
						],
						error: common.ui.handleAjaxError					
					},
					template: kendo.template($("#treeview-template").html()),
					dataTextField: "name",
					change: function(e) {
						var file = getSelectedTemplateFile(renderTo);
						createTemplateEditor(file);
					}
				});
			}
		}
		
		function getSelectedTemplateFile( renderTo ){			
			var tree = renderTo.data('kendoTreeView');			
			var selectedCells = tree.select();			
			var selectedCell = tree.dataItem( selectedCells );   
			return selectedCell ;
		}		
				
		function createTemplateEditor(file){
			var renderTo = $("#my-site-template-editor");
			var dialogFx = common.ui.dialog( renderTo );		
			dialogFx.data().setFile(file);	
		}
		

		<!-- ============================== -->
		<!-- Page														-->
		<!-- ============================== -->
		
		function getMyPageSource(){
			return $("#page-source-list input[type=radio][name=page-source]:checked").val();			
		}
				
		function createPageSection(){
			var renderTo = $("#my-page-grid");
			common.ui.grid( renderTo, {
				dataSource: {
					serverFiltering: false,
					transport: { 
						read: { url:'/data/pages/list.json?output=json', type: 'POST' },
						parameterMap: function (options, type){
							return { startIndex: options.skip, pageSize: options.pageSize,  objectType: getMyPageSource() }
						}
					},
					schema: {
						total: "totalCount",
						data: "pages",
						model: common.ui.data.Page
					},
					error:common.ui.handleAjaxError,
					batch: false,
					pageSize: 15,
					serverPaging: true,
					serverFiltering: false,
					serverSorting: false
				},
				columns: [
					{ field: "pageId", title: "ID", width:50,  filterable: false, sortable: false , headerAttributes: { "class": "table-header-cell", style: "text-align: center" }}, 
					{ field: "name", title: "이름", width: 100, headerAttributes: { "class": "table-header-cell", style: "text-align: center"}}, 
					{ field: "title", title: "제목", width: 350 , headerAttributes: { "class": "table-header-cell", style: "text-align: center" }, template: $('#webpage-title-template').html() }, 
					{ field: "versionId", title: "버전", width: 80, headerAttributes: { "class": "table-header-cell", style: "text-align: center" } },
					{ field: "pageState", title: "상태", width: 120, headerAttributes: { "class": "table-header-cell", style: "text-align: center" }, template: '#if ( pageState === "PUBLISHED" ) { #<span class="label label-success">#: pageState #</span>#}else{# <span class="label label-danger">#: pageState #</span> #}#'},
					{ field: "user.username", title: "작성자", width: 100, headerAttributes: { "class": "table-header-cell", style: "text-align: center" }, template:'#if ( user.nameVisible ) {# #: user.name # #} else{ # #: user.username # #}#' },
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
 					} 						
				},
				dataBound: function(e){		
					$("button.btn-page-control-group").attr("disabled", "disabled");
				}			
			} );		
				
			$("#page-source-list input[type=radio][name=page-source]").on("change", function () {
					common.ui.grid(renderTo).dataSource.read();	
			});				
			
			$("button[data-action=page-create]").click(function(e){
				createNewPage();
			});
			
			$("#my-page-view span.back").click(function(e){
				$("#my-page-view").fadeOut(function(e){
					$("#my-page-list").fadeIn();
				});			
			});
		}

		function createNewPage(){
			var page = new common.ui.data.Page();
			page.objectType = getMyPageSource();
			page.bodyContent = { bodyText: "" };
			createPageEditor(page);
			$("#my-page-list").fadeOut(function(e){
				$("#my-page-view").fadeIn();
			});
		}
		
		function doPageEdit(){
			var renderTo = $("#my-page-grid");
			var grid = common.ui.grid( renderTo );
			var selectedCells = grid.select();
			if( selectedCells.length > 0){ 
				var selectedCell = grid.dataItem( selectedCells ); 
				createPageEditor(selectedCell);
			}
			$("#my-page-list").fadeOut(function(e){
				$("#my-page-view").fadeIn();
			});
		}
		
		function getPageEditorSource(){
			var renderTo = $("#my-page-view");
			return renderTo.data("model");		
		}

		function createPageEditor(source){
			var renderTo = $("#my-page-view");
			$("#sky-form label.state-error").removeClass("state-error");
			
			if( !renderTo.data("model")){
				var model =  common.ui.observable({ 
					page : new common.ui.data.Page(),
					stateSource : [
						{name: "" , value: "INCOMPLETE"},
						{name: "승인" , value: "APPROVAL"},
						{name: "게시" , value: "PUBLISHED"},
						{name: "거절" , value: "REJECTED"},
						{name: "보관" , value: "ARCHIVED"},
						{name: "삭제" , value: "DELETED"}
					],
					properties : new kendo.data.DataSource({
						transport: { 
							read: { url:'/data/pages/properties/list.json?output=json', type:'post' },
							create: { url:'/data/pages/properties/update.json?output=json', type:'post' },
							update: { url:'/data/pages/properties/update.json?output=json', type:'post'  },
							destroy: { url:'/data/pages/properties/delete.json?output=json', type:'post' },
					 		parameterMap: function (options, operation){			
						 		if (operation !== "read" && options.models) {
						 			return { pageId: model.page.pageId, items: kendo.stringify(options.models)};
								} 
								return { pageId: model.page.pageId }
							}
						},	
						batch: true, 
						schema: {
							model: common.ui.data.Property
						},
						error:common.ui.handleAjaxError
					}),
					isVisible : true,
					close:function(e){
						$("#my-page-view span.back").click();
						common.ui.scroll.top($(".personalized-section").first());
					},
					update : function(e){
						var $this = this, 
						btn = $(e.target);						
						btn.button('loading');
						
						if( $this.page.title.length == 0 ){
							if(!$("label[for=title]").hasClass("state-error"))
								$("label[for=title]").addClass("state-error");							
							common.ui.notification({
								hide:function(e){
									btn.button('reset');
								}
							}).show(
								{	title:"입력 오류", message: "제목을 입력하세요."	},
								"error"
							);
							return false;
						}						
						else{
							if($("label[for=title]").hasClass("state-error"))
								$("label[for=title]").removeClass("state-error");
						}
												
						if($this.page.summary.length == 0 ){
							if(!$("label[for=summary]").hasClass("state-error"))
								$("label[for=summary]").addClass("state-error");
							common.ui.notification({
								hide:function(e){
									btn.button('reset');
								}
							}).show(
								{	title:"입력 오류", message: "페이지 요약 정보를 입력하세요."	},
								"error"
							);	
							return false;	
						}
						else{
							if($("label[for=summary]").hasClass("state-error"))
								$("label[for=summary]").removeClass("state-error");
						}
						common.ui.ajax(
							'<@spring.url "/data/pages/update.json?output=json"/>',
							{
								data : kendo.stringify($this.page) ,
								contentType : "application/json",
								success : function(response){
									common.ui.notification({title:"페이지 저장", message: "페이지 가 정상적으로 저장되었습니다.", type: "success" });
									$("#my-page-grid").data('kendoGrid').dataSource.read();
									$this.close();									
								},
								fail: function(){								
									common.ui.notification({title:"페이지 저장 오류", message: "시스템 운영자에게 문의하여 주십시오." });
								},
								requestStart : function(){
									kendo.ui.progress(renderTo, true);
								},
								requestEnd : function(){
									kendo.ui.progress(renderTo, false);
								},
								complete : function(e){
									btn.button('reset');
								}							
						});												
						return false;
					}
				});				
				source.copy( model.page );
				renderTo.data("model", model);
				kendo.bind(renderTo, model );				
				var bodyEditor =  $("#page-editor-body" );
				createEditor( "page-editor" , bodyEditor, { modal : false , appendTo: $("#my-page-editor-code"), tab: $("#my-page-editor-tabs"), useWrapMode : true } );				
			}else{
				source.copy( renderTo.data("model").page );				
				if(renderTo.data("model").page.pageId > 0 )
					renderTo.data("model").properties.read();
			}				
			if(renderTo.data("model").page.pageId > 0) {
				renderTo.data("model").set("isAllowToFileAndProps", true);
			} else {
				renderTo.data("model").set("isAllowToFileAndProps", false);
			}							
		}
		
		<!-- ============================== -->
		<!-- Notice														-->
		<!-- ============================== -->
		function createNoticeSection(){			
			var renderTo = $("#my-notice-grid");
			if( !common.ui.exists(renderTo)){
				var now = new Date();			
				var model = new common.ui.observable({ 
					notice : new common.ui.data.Announce(),
					visible : false,
					edit : function(e){
						e.stopPropagation();
						//common.ui.scroll.top($("website-notice"));
						createNoticeEditorSection(this.notice);	
					},
					create : function(e){
						var empty = new common.ui.data.Announce()
						createNoticeEditorSection(empty);
					},
					startDate : new Date(now.getFullYear(), now.getMonth(), 1),
					endDate : now,
					startDateChange: function(e) {
						var $this = this;
						var sDatePicker = $("#noticeStartDatePicker").data("kendoDatePicker");
						var eDatePicker = $("#noticeEndDatePicker").data("kendoDatePicker");						
						if( $this.startDate ){
							eDatePicker.min($this.startDate);
						} else if ($this.endDate) {
							sDatePicker.max( $this.endDate );
						} else {
							$this.endDate = new Date(now.getFullYear(), now.getMonth(), now.getDay());
							sDatePicker.max( $this.endDate );
							eDatePicker.min( $this.endDate );
						}
					},
					endDateChange:function(e){
						var $this = this;
						var sDatePicker = $("#noticeStartDatePicker").data("kendoDatePicker");
						var eDatePicker = $("#noticeEndDatePicker").data("kendoDatePicker");		
						if( $this.endDate ){
							sDatePicker.max($this.endDate);
						}else if ($this.startDate){
							eDatePicker.min($this.startDate);
						}else{
							$this.endDate = new Date(now.getFullYear(), now.getMonth(), now.getDay());
							sDatePicker.max( $this.endDate );
							eDatePicker.min( $this.endDate );							
						}
					},
					refresh : function(e){
						common.ui.grid(renderTo).dataSource.read();					
					}	
				});
				common.ui.bind($("#my-notice-list, #my-notice-view"), model );	
				var noticeSourceList = common.ui.buttonGroup(
					$("#notice-source-list"),
					{
						change: function(e){						
							common.ui.grid(renderTo).dataSource.read({objectType:e.value});
						}
					}
				);
				common.ui.grid( renderTo, {
					dataSource: {
						serverFiltering: false,
						transport: { 
							read: { url:'<@spring.url "/data/announce/list.json"/>', type: 'POST' },
							parameterMap: function (options, type){
								return {objectType: common.ui.defined(options.objectType) ? options.objectType :noticeSourceList.value , startDate: model.startDate.toJSON(), endDate: model.endDate.toJSON() }						
							}
						},					
						schema: {
							total: "totalCount",
							data: "announces",
							model: common.ui.data.Announce
						},
						batch: false,
						pageSize: 15,
						serverPaging: false,
						serverFiltering: false,
						serverSorting: false
					},
					columns: [
						{ field: "announceId", title: "ID", width:50,  filterable: false, sortable: false , headerAttributes: { "class": "table-header-cell", style: "text-align: center" }}, 
						{ field: "subject", title: "제목", width: 350, headerAttributes: { "class": "table-header-cell", style: "text-align: center"}},					
						{ field: "subject", title: "소스", width: 80, headerAttributes: { "class": "table-header-cell", style: "text-align: center"},	template: '# if (objectType == 30) { # <span class="badge badge-blue">웹사이트</span>	# }else{ # <span class="badge badge-red">회사</span># } #	' },					
						{ field: "user.username", title: "작성자", width: 100, headerAttributes: { "class": "table-header-cell", style: "text-align: center" }, template:'<img width="25" height="25" class="img-circle no-margin" src="#: authorPhotoUrl() #" style="margin-right:10px;"> #if ( user.nameVisible ) {# #: user.name # #} else{ # #: user.username # #}#' },
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
							selectedCell.copy( model.notice );
							if( $("#my-notice-edit").is(":visible") ){
								$("#my-notice-edit").fadeOut(function(){
									$("#my-notice-view").fadeIn();		
								});
							}
							model.set("visible", true);														
	 					} 						
					},
					dataBound: function(e){		
						//$("button.btn-page-control-group").attr("disabled", "disabled");
						model.set("visible", false);							
						
					}			
				} );	
			}		
		}
		
		function createNoticeEditorSection(source){
			var renderTo = $("#my-notice-edit");		
			if( !renderTo.data("model")){
				var model =  common.ui.observable({ 
					notice : new common.ui.data.Announce(),
					new: true,
					visible : true,
					update : function(e){						
						var $this = this, 
						btn = $(e.target);						
						btn.button('loading');
						
						if( $this.notice.subject.length == 0 || $this.notice.body.length == 0 ){
							common.ui.notification({
								hide:function(e){
									btn.button('reset');
								}
							}).show(
								{	title:"공지 입력 오류", message: "제목 또는 본문을 입력하세요."	},
								"error"
							);
							return ;
						}
						if( $this.notice.startDate >= $this.notice.endDate  ){
							common.ui.notification({
								hide:function(e){
									btn.button('reset');
								}
							}).show(
								{	title:"공지 기간 입력 오류", message: "시작일자가 종료일자보다 이후일 수 없습니다."	},
								"error"
							);							
							return ;
						}
						common.ui.ajax(
							'<@spring.url "/data/announce/update.json"/>',
							{
								data : kendo.stringify( $this.notice ),
								contentType : "application/json",
								success : function(response){									
									common.ui.grid($("#my-notice-grid")).dataSource.read();
									$this.close();
								},
								fail: function(){								
									common.ui.notification({
										hide:function(e){
											btn.button('reset');
										}
									}).show(
										{	title:"공지 저장 오류", message: "시스템 운영자에게 문의하여 주십시오."	},
										"error"
									);	
								},
								requestStart : function(){
									kendo.ui.progress(renderTo, true);
								},
								requestEnd : function(){
									kendo.ui.progress(renderTo, false);
								},
								complete : function(e){
									btn.button('reset');
								}
							});	
					},
					close : function(e){
						renderTo.fadeOut("slow", function(e){
							$("#my-notice-view").fadeIn();
						});
					},	
				});	
				kendo.bind( renderTo, model);
				renderTo.data("model", model);	
				var bodyEditor =  $("#notice-editor-body" );
				createEditor( "notice-editor" , bodyEditor, { modal : false , appendTo: $("#my-notice-editor-code"), tab: $("#my-notice-editor-tabs"), useWrapMode : true } );
			}	
			
			if( source ){
				source.copy( renderTo.data("model").notice );				
				if( source.announceId === 0 ){
					renderTo.data("model").set("notice.objectType", common.ui.buttonGroup($("#notice-source-list")).value); 
					renderTo.data("model").set("new", false); 
				}else{
					renderTo.data("model").set("new", false); 					
				} 
			}
			
			$("#my-notice-view").fadeOut( "slow", function(e){
				renderTo.fadeIn();
			} );
		}		

		-->
		</script>		
		<style scoped="scoped">			
		
		.forum-item.k-state-selected {
			background-color: #fff;
			color:#333;
		}
		
		.forum-item.k-state-selected .forum-item-title {
		    color: #1ab394;
		}
		
		.forum-img {
		    float: left;
		    width: 40px;
		    margin-right: 10px;
		    text-align: center;
		}
		
		.k-grid-content .k-state-selected {
		    color: #fff;
		    background-color: #428bca;
		    border-color: #428bca;		
    	}
		
		.k-grid .k-selectable td > .btn-selectable, .k-grid .k-selectable tr[aria-selected="false"] > td .btn-selectable, .k-grid .k-selectable td > a.btn-selectable, .k-grid .k-selectable tr[aria-selected="false"] > td a.btn-selectable{
			cursor: not-allowed;
			pointer-events: none;
			opacity: 0;
			filter: alpha(opacity=65);
			-webkit-box-shadow: none;
			box-shadow: none;
		}			
		
		.k-grid  .k-selectable tr[aria-selected="true"] > td > .btn-selectable , .k-grid .k-selectable tr[aria-selected="true"] > td  a.btn-selectable {
			cursor: pointer;
			pointer-events: auto;
			opacity: 1;
			filter: none;
			-webkit-box-shadow: none;
			box-shadow: none;
		}		
		
		
		
		
		
		.dialog__content {
			width : 100%;
			max-width: none;				
			background: #fff;
			padding: 4em;
			top: 0;
			left: 0;
			position: absolute;
			height: 100%!important;
			text-align: inherit;
		}

		.dialog .ace_editor {
			display : none;
		}
				
		.dialog.dialog--open .ace_editor {
			display : block;
		}
					
		.acc-v1	.panel-default {
			border-color: #bbb;
		}
		
		#my-page-view {
			position: relative;
		}
						
		.k-grid tr > td  .btn-group {
			-webkit-animation-duration: 1s;
			animation-duration: 1s;
			-webkit-animation-fill-mode: both;
			animation-fill-mode: both;		
			cursor: not-allowed;
			pointer-events: none;			
			opacity: 0;
			visibility: hidden;						
		}

		.k-grid tr[aria-selected=true] > td  .btn-group {
			opacity: 1;
			visibility: visible;
			cursor: pointer;
			pointer-events: auto;				
			-webkit-animation-name: fadeInRight;
			animation-name: fadeInRight;	
		}
		
		.k-grid tr[aria-selected=false] > td  .btn-group {
			opacity: 1;
			visibility: visible;
			cursor: pointer;
			pointer-events: auto;				
			-webkit-animation-name: fadeOutRight;
			animation-name: fadeOutRight;	
		}
		
		.btn[disabled]{
			cursor: not-allowed;
			pointer-events: auto;		
		} 
		
		#my-page 	span.back,  #my-notice-edit 	span.back {
			top:inherit;
			left:inherit;
		}
		
		#my-page-view .k-editor, #my-site-notice .k-editor {
			border:0px;
		}
		
		.sky-form fieldset {
			background: #fff;
		}
		
		
		#my-notice-grid .k-grid-content {
			height:530px;
		}
		
		
		.ace_editor{
			min-height: 500px;			
		}
		
		#my-notice-listview.k-listview .k-state-selected
		{
			background : #F5F5F5;
			color: #585f69;
		}	
		.breadcrumbs-v3 p {
		  color: #fff;
		  font-size: 24px;
		  font-weight: 200;
		  margin-bottom: 0;
		}			
		
		</style>   	
		</#compress>
	</head>
	<body id="doc" class="bg-white">
		<div class="page-loader"></div>
		<div class="wrapper">
			<!-- START HEADER -->		
			<#include "/html/common/common-homepage-menu.ftl" >		
			<!-- ./END HEADER -->
			<!-- START MAIN CONTENT -->
			<#if action.isSetNavigator()  >
			<#assign navigator = action.getNavigator() />		
			<div class="breadcrumbs-v3 img-v1  bg-dark arrow-up">
				<div class="personalized-controls container text-center p-xl">
					<p class="text-quote">${ navigator.description ? replace ("{displayName}" , action.webSite.company.displayName ) }	</p>
					<h1 class="text-xxl"><#if navigator.icon?? ><i class="icon-flat ${navigator.icon}"></i></#if>	${ navigator.title }</h1>					
				</div><!--/end container-->
			</div>
			</#if>	
			<div class="container content" style="min-height:450px;">		
				<div id="my-site-listview" class="margin-bottom-30 no-border" style="min-height:100px;"></div>	
				<div id="my-site-details" style="display:none;">
					<div class="tab-v1">
						<ul class="nav nav-tabs">
							<li><a href="#my-site-page" data-toggle="tab" class="m-l-sm rounded-top">웹 페이지</a></li>
							<li><a href="#my-site-announce" data-toggle="tab" class="rounded-top">공지 & 이벤트</a></li>
						</ul>
						<div class="tab-content">
							<div class="tab-pane fade" id="my-site-page">
								<h4><small class="text-muted">웹 페이지을 쉽고 빠르게 생성하고 수정할 수 있습니다.</small></h4>		
								<div id="my-site-web-page-grid" class="no-border"></div>	
								<div id="my-site-web-page-view" style="display:none;">
									<div class="ibox product-detail">
										<span class="back" style="position:relative;" data-bind="click:close"></span>
					                    <div class="ibox-content">
					
					
					<form action="#" class="sky-form">
						<header></header>

						<fieldset>						
							<section>
								<label class="label">파일명</label>
								<label class="input">
									<input type="text" class="form-control" id="input-page-name" data-bind="value:page.name" placeholder="파일명">
								</label>
							</section>
							<div class="row">
								<section class="col col-6">
									<label class="input">
										<input type="text" class="form-control" id="input-page-contentType" data-bind="value:page.contentType">
									</label>
									<div class="note">콘텐츠 타입을 입력하세요. 예) text/html;charset=UTF-8</div>
								</section>
								<section class="col col-6">
									<label class="input">
										<input type="text" class="form-control" id="input-page-locale" data-bind="value: page.locale">
									</label>
									<div class="note">로케일 코드 값을 입력하세요. 예) en, ko_KR.</div>
								</section>
							</div>									
						</fieldset>

						<fieldset>
							<section>
								<label class="label">Select</label>
								<label class="select">
									<select>
										<option value="0">Choose name</option>
										<option value="1">Alexandra</option>
										<option value="2">Alice</option>
										<option value="3">Anastasia</option>
										<option value="4">Avelina</option>
									</select>
									<i></i>
								</label>
							</section>

							<section>
								<label class="label">Multiple select</label>
								<label class="select select-multiple">
									<select multiple="">
										<option value="1">Alexandra</option>
										<option value="2">Alice</option>
										<option value="3">Anastasia</option>
										<option value="4">Avelina</option>
										<option value="5">Basilia</option>
										<option value="6">Beatrice</option>
										<option value="7">Cassandra</option>
										<option value="8">Clemencia</option>
										<option value="9">Desiderata</option>
									</select>
								</label>
								<div class="note"><strong>Note:</strong> hold down the ctrl/cmd button to select multiple options.</div>
							</section>
						</fieldset>

						<fieldset>
							<section>
								<label class="label">Textarea</label>
								<label class="textarea">
									<textarea rows="3"></textarea>
								</label>
								<div class="note"><strong>Note:</strong> height of the textarea depends on the rows attribute.</div>
							</section>

							<section>
								<label class="label">Textarea resizable</label>
								<label class="textarea textarea-resizable">
									<textarea rows="3"></textarea>
								</label>
							</section>

							<section>
								<label class="label">Textarea expandable</label>
								<label class="textarea textarea-expandable">
									<textarea rows="3"></textarea>
								</label>
								<div class="note"><strong>Note:</strong> expands on focus.</div>
							</section>
						</fieldset>

						<fieldset>
							<section>
								<label class="label">Columned radios</label>
								<div class="row">
									<div class="col col-4">
										<label class="radio"><input type="radio" name="radio" checked=""><i class="rounded-x"></i>Alexandra</label>
										<label class="radio"><input type="radio" name="radio"><i class="rounded-x"></i>Alice</label>
										<label class="radio"><input type="radio" name="radio"><i class="rounded-x"></i>Anastasia</label>
									</div>
									<div class="col col-4">
										<label class="radio"><input type="radio" name="radio"><i class="rounded-x"></i>Avelina</label>
										<label class="radio"><input type="radio" name="radio"><i class="rounded-x"></i>Basilia</label>
										<label class="radio"><input type="radio" name="radio"><i class="rounded-x"></i>Beatrice</label>
									</div>
									<div class="col col-4">
										<label class="radio"><input type="radio" name="radio"><i class="rounded-x"></i>Cassandra</label>
										<label class="radio"><input type="radio" name="radio"><i class="rounded-x"></i>Clemencia</label>
										<label class="radio"><input type="radio" name="radio"><i class="rounded-x"></i>Desiderata</label>
									</div>
								</div>
							</section>

							<section>
								<label class="label">Inline radios</label>
								<div class="inline-group">
									<label class="radio"><input type="radio" name="radio-inline" checked=""><i class="rounded-x"></i>Alexandra</label>
									<label class="radio"><input type="radio" name="radio-inline"><i class="rounded-x"></i>Alice</label>
									<label class="radio"><input type="radio" name="radio-inline"><i class="rounded-x"></i>Anastasia</label>
									<label class="radio"><input type="radio" name="radio-inline"><i class="rounded-x"></i>Avelina</label>
									<label class="radio"><input type="radio" name="radio-inline"><i class="rounded-x"></i>Beatrice</label>
								</div>
							</section>
						</fieldset>

						<fieldset>
							<section>
								<label class="label">Columned checkboxes</label>
								<div class="row">
									<div class="col col-4">
										<label class="checkbox"><input type="checkbox" name="checkbox" checked=""><i></i>Alexandra</label>
										<label class="checkbox"><input type="checkbox" name="checkbox"><i></i>Alice</label>
										<label class="checkbox"><input type="checkbox" name="checkbox"><i></i>Anastasia</label>
									</div>
									<div class="col col-4">
										<label class="checkbox"><input type="checkbox" name="checkbox"><i></i>Avelina</label>
										<label class="checkbox"><input type="checkbox" name="checkbox"><i></i>Basilia</label>
										<label class="checkbox"><input type="checkbox" name="checkbox"><i></i>Beatrice</label>
									</div>
									<div class="col col-4">
										<label class="checkbox"><input type="checkbox" name="checkbox"><i></i>Cassandra</label>
										<label class="checkbox"><input type="checkbox" name="checkbox"><i></i>Clemencia</label>
										<label class="checkbox"><input type="checkbox" name="checkbox"><i></i>Desiderata</label>
									</div>
								</div>
							</section>

							<section>
								<label class="label">Inline checkboxes</label>
								<div class="inline-group">
									<label class="checkbox"><input type="checkbox" name="checkbox-inline" checked=""><i></i>Alexandra</label>
									<label class="checkbox"><input type="checkbox" name="checkbox-inline"><i></i>Alice</label>
									<label class="checkbox"><input type="checkbox" name="checkbox-inline"><i></i>Anastasia</label>
									<label class="checkbox"><input type="checkbox" name="checkbox-inline"><i></i>Avelina</label>
									<label class="checkbox"><input type="checkbox" name="checkbox-inline"><i></i>Beatrice</label>
								</div>
							</section>
						</fieldset>

						<fieldset>
							<div class="row">
								<section class="col col-5">
									<label class="label">Toggles based on radios</label>
									<label class="toggle"><input type="radio" name="radio-toggle" checked=""><i class="no-rounded"></i>Alexandra</label>
									<label class="toggle"><input type="radio" name="radio-toggle"><i class="no-rounded"></i>Anastasia</label>
									<label class="toggle"><input type="radio" name="radio-toggle"><i class="no-rounded"></i>Avelina</label>
								</section>

								<div class="col col-2"></div>

								<section class="col col-5">
									<label class="label">Toggles based on checkboxes</label>
									<label class="toggle"><input type="checkbox" name="checkbox-toggle" checked=""><i class="no-rounded"></i>Cassandra</label>
									<label class="toggle"><input type="checkbox" name="checkbox-toggle"><i class="no-rounded"></i>Clemencia</label>
									<label class="toggle"><input type="checkbox" name="checkbox-toggle"><i class="no-rounded"></i>Desiderata</label>
								</section>
							</div>
						</fieldset>

						<fieldset>
							<div class="row">
								<section class="col col-5">
									<label class="label">Toggles based on radios</label>
									<label class="toggle"><input type="radio" name="radio-toggle-1" checked=""><i></i>JavaScript</label>
									<label class="toggle"><input type="radio" name="radio-toggle-1"><i></i>CSS3/HTML5</label>
									<label class="toggle"><input type="radio" name="radio-toggle-1"><i></i>Bootstrap</label>
								</section>

								<div class="col col-2"></div>

								<section class="col col-5">
									<label class="label">Toggles based on checkboxes</label>
									<label class="toggle"><input type="checkbox" name="checkbox-toggle-1" checked=""><i></i>Canada</label>
									<label class="toggle"><input type="checkbox" name="checkbox-toggle-1"><i></i>USA</label>
									<label class="toggle"><input type="checkbox" name="checkbox-toggle-1"><i></i>Russia</label>
								</section>
							</div>
						</fieldset>

						<fieldset>
							<section>
								<label class="label">Ratings with different icons</label>
								<div class="rating">
									<input type="radio" name="stars-rating" id="stars-rating-5">
									<label for="stars-rating-5"><i class="fa fa-star"></i></label>
									<input type="radio" name="stars-rating" id="stars-rating-4">
									<label for="stars-rating-4"><i class="fa fa-star"></i></label>
									<input type="radio" name="stars-rating" id="stars-rating-3">
									<label for="stars-rating-3"><i class="fa fa-star"></i></label>
									<input type="radio" name="stars-rating" id="stars-rating-2">
									<label for="stars-rating-2"><i class="fa fa-star"></i></label>
									<input type="radio" name="stars-rating" id="stars-rating-1">
									<label for="stars-rating-1"><i class="fa fa-star"></i></label>
									Stars
								</div>

								<div class="rating">
									<input type="radio" name="trophies-rating" id="trophies-rating-7">
									<label for="trophies-rating-7"><i class="fa fa-trophy"></i></label>
									<input type="radio" name="trophies-rating" id="trophies-rating-6">
									<label for="trophies-rating-6"><i class="fa fa-trophy"></i></label>
									<input type="radio" name="trophies-rating" id="trophies-rating-5">
									<label for="trophies-rating-5"><i class="fa fa-trophy"></i></label>
									<input type="radio" name="trophies-rating" id="trophies-rating-4">
									<label for="trophies-rating-4"><i class="fa fa-trophy"></i></label>
									<input type="radio" name="trophies-rating" id="trophies-rating-3">
									<label for="trophies-rating-3"><i class="fa fa-trophy"></i></label>
									<input type="radio" name="trophies-rating" id="trophies-rating-2">
									<label for="trophies-rating-2"><i class="fa fa-trophy"></i></label>
									<input type="radio" name="trophies-rating" id="trophies-rating-1">
									<label for="trophies-rating-1"><i class="fa fa-trophy"></i></label>
									Trophies
								</div>

								<div class="rating">
									<input type="radio" name="asterisks-rating" id="asterisks-rating-10">
									<label for="asterisks-rating-10"><i class="fa fa-asterisk"></i></label>
									<input type="radio" name="asterisks-rating" id="asterisks-rating-9">
									<label for="asterisks-rating-9"><i class="fa fa-asterisk"></i></label>
									<input type="radio" name="asterisks-rating" id="asterisks-rating-8">
									<label for="asterisks-rating-8"><i class="fa fa-asterisk"></i></label>
									<input type="radio" name="asterisks-rating" id="asterisks-rating-7">
									<label for="asterisks-rating-7"><i class="fa fa-asterisk"></i></label>
									<input type="radio" name="asterisks-rating" id="asterisks-rating-6">
									<label for="asterisks-rating-6"><i class="fa fa-asterisk"></i></label>
									<input type="radio" name="asterisks-rating" id="asterisks-rating-5">
									<label for="asterisks-rating-5"><i class="fa fa-asterisk"></i></label>
									<input type="radio" name="asterisks-rating" id="asterisks-rating-4">
									<label for="asterisks-rating-4"><i class="fa fa-asterisk"></i></label>
									<input type="radio" name="asterisks-rating" id="asterisks-rating-3">
									<label for="asterisks-rating-3"><i class="fa fa-asterisk"></i></label>
									<input type="radio" name="asterisks-rating" id="asterisks-rating-2">
									<label for="asterisks-rating-2"><i class="fa fa-asterisk"></i></label>
									<input type="radio" name="asterisks-rating" id="asterisks-rating-1">
									<label for="asterisks-rating-1"><i class="fa fa-asterisk"></i></label>
									Asterisks
								</div>
								<div class="note"><strong>Note:</strong> you can use more than 350 icons for rating <a target="_blank" href="http://fortawesome.github.io/Font-Awesome">http://fortawesome.github.io/Font-Awesome</a></div>
							</section>
						</fieldset>

						<footer>
							<button type="submit" class="btn-u">Submit</button>
							<button type="button" class="btn-u btn-u-default" onclick="window.history.back();">Back</button>
						</footer>
					</form>
							

										<div class="row">
											<div class="col-sm-12">
												<div class="form-group no-margin-hr">
													<label class="control-label" for="input-page-name">파일</label>
													<input type="text" class="form-control" id="input-page-name" data-bind="value:page.name">
													<p class="help-block small">중복되지 않는 파일명을 입력하세요.</p>
												</div>
											</div>
										</div>
										<div class="row">	
											<div class="col-sm-6">
												<div class="form-group no-margin-hr">
													<label class="control-label" for="input-page-contentType">콘텐츠 타입</label>
													<input type="text" class="form-control" id="input-page-contentType" data-bind="value:page.contentType">
													<p class="help-block small">콘텐츠 타입을 입력하세요.</p>												
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
											<div class="col-sm-8">
												<div class="form-group no-margin-hr">
													<label class="control-label" for="input-page-template">콘텐츠 템플릿</label>
													<input type="text" class="form-control" id="input-page-template" data-bind="value: page.template">				
													<p class="help-block small">템플릿 경로를 입력하거나 템플릿 선택을 클릭하여 선택하세요 </p>
													<div class="p-xs">														
														<input type="checkbox" id="input-page-customized" class="k-checkbox" data-bind="checked: page.customized">
														<label class="k-checkbox-label text-normal" for="input-page-customized">커스텀 템플릿 사용</label>													
													</div>																	
												</div>																								
											</div>
											<div class="col-sm-4">
												<button class="btn btn-flat btn-sm" type="button" ><i class="fa fa-file-code-o"></i> 템플릿 선택</button>
											</div>
										</div>
										<div class="row">
											<div class="col-sm-12">
												<div class="form-group no-margin-hr">
													<label class="control-label" for="input-page-displayName">타이틀</label>
													<input type="text" class="form-control" id="input-page-displayName" data-bind="value:page.displayName">
													<p class="help-block small">페이지 타이틀을 입력하세요.</p>
												</div>
											</div>
										</div>
										<div class="row">	
											<div class="col-sm-12">
												<div class="form-group no-margin-hr">			
													<label class="control-label" for="input-page-description">요약</label>
													<input type="text" class="form-control" id="input-page-description" data-bind="value: page.description">
													<p class="help-block small">간략하게 페이지를 기술하세요.</p>																					
												</div>
											</div>
										</div>												

										
                            

			<div class="row">
                <div class="col-lg-6 m-b-md">
                    <div class="tabs-container">
                        <ul class="nav nav-tabs">
                            <li class="active"><a data-toggle="tab" href="#tab-1" aria-expanded="true"> This is tab</a></li>
                            <li class=""><a data-toggle="tab" href="#tab-2" aria-expanded="false">This is second tab</a></li>
                        </ul>
                        <div class="tab-content no-padding-t">
                            <div id="tab-1" class="tab-pane active">
                                <div class="panel-body">
                                    <strong>Lorem ipsum dolor sit amet, consectetuer adipiscing</strong>

                                    <p>A wonderful serenity has taken possession of my entire soul, like these sweet mornings of spring which I enjoy with my whole heart. I am alone, and feel the charm of
                                        existence in this spot, which was created for the bliss of souls like mine.</p>

                                    <p>I am so happy, my dear friend, so absorbed in the exquisite sense of mere tranquil existence, that I neglect my talents. I should be incapable of drawing a single stroke at
                                        the present moment; and yet I feel that I never was a greater artist than now. When.</p>
                                </div>
                            </div>
                            <div id="tab-2" class="tab-pane">
                                <div class="panel-body">
                                    <strong>Donec quam felis</strong>

                                    <p>Thousand unknown plants are noticed by me: when I hear the buzz of the little world among the stalks, and grow familiar with the countless indescribable forms of the insects
                                        and flies, then I feel the presence of the Almighty, who formed us in his own image, and the breath </p>

                                    <p>I am alone, and feel the charm of existence in this spot, which was created for the bliss of souls like mine. I am so happy, my dear friend, so absorbed in the exquisite
                                        sense of mere tranquil existence, that I neglect my talents. I should be incapable of drawing a single stroke at the present moment; and yet.</p>
                                </div>
                            </div>
                        </div>


                    </div>
                </div>
                <div class="col-lg-6 m-b-md">
                    <div class="tabs-container">
                        <ul class="nav nav-tabs">
                            <li class=""><a data-toggle="tab" href="#tab-3" aria-expanded="false"> <i class="fa fa-laptop"></i></a></li>
                            <li class=""><a data-toggle="tab" href="#tab-4" aria-expanded="false"><i class="fa fa-desktop"></i></a></li>
                            <li class="active"><a data-toggle="tab" href="#tab-5" aria-expanded="true"><i class="fa fa-database"></i></a></li>
                        </ul>
                        <div class="tab-content">
                            <div id="tab-3" class="tab-pane">
                                <div class="panel-body">
                                    <strong>Lorem ipsum dolor sit amet, consectetuer adipiscing</strong>

                                    <p>A wonderful serenity has taken possession of my entire soul, like these sweet mornings of spring which I enjoy with my whole heart. I am alone, and feel the charm of
                                        existence in this spot, which was created for the bliss of souls like mine.</p>

                                    <p>I am so happy, my dear friend, so absorbed in the exquisite sense of mere tranquil existence, that I neglect my talents. I should be incapable of drawing a single stroke at
                                        the present moment; and yet I feel that I never was a greater artist than now. When.</p>
                                </div>
                            </div>
                            <div id="tab-4" class="tab-pane">
                                <div class="panel-body">
                                    <strong>Donec quam felis</strong>

                                    <p>Thousand unknown plants are noticed by me: when I hear the buzz of the little world among the stalks, and grow familiar with the countless indescribable forms of the insects
                                        and flies, then I feel the presence of the Almighty, who formed us in his own image, and the breath </p>

                                    <p>I am alone, and feel the charm of existence in this spot, which was created for the bliss of souls like mine. I am so happy, my dear friend, so absorbed in the exquisite
                                        sense of mere tranquil existence, that I neglect my talents. I should be incapable of drawing a single stroke at the present moment; and yet.</p>
                                </div>
                            </div>
                            <div id="tab-5" class="tab-pane active">
                                <div class="panel-body">
                                    <strong>Donec quam felis</strong>

                                    <p>Thousand unknown plants are noticed by me: when I hear the buzz of the little world among the stalks, and grow familiar with the countless indescribable forms of the insects
                                        and flies, then I feel the presence of the Almighty, who formed us in his own image, and the breath </p>

                                    <p>I am alone, and feel the charm of existence in this spot, which was created for the bliss of souls like mine. I am so happy, my dear friend, so absorbed in the exquisite
                                        sense of mere tranquil existence, that I neglect my talents. I should be incapable of drawing a single stroke at the present moment; and yet.</p>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            							
							
							
							<div class="row">
                                <div class="col-md-5">
                                    <div class="product-images slick-initialized slick-slider" role="toolbar"><button type="button" data-role="none" class="slick-prev slick-arrow" aria-label="Previous" role="button" style="display: block;">Previous</button>

                                        <div aria-live="polite" class="slick-list draggable"><div class="slick-track" role="listbox" style="opacity: 1; width: 1645px; transform: translate3d(-329px, 0px, 0px);"><div class="slick-slide slick-cloned" data-slick-index="-1" aria-hidden="true" tabindex="-1" style="width: 329px;">
                                            <div class="image-imitation">
                                                [IMAGE 3]
                                            </div>
                                        </div><div class="slick-slide slick-current slick-active" data-slick-index="0" aria-hidden="false" tabindex="0" role="option" aria-describedby="slick-slide00" style="width: 329px;">
                                            <div class="image-imitation">
                                                [IMAGE 1]
                                            </div>
                                        </div><div class="slick-slide" data-slick-index="1" aria-hidden="true" tabindex="-1" role="option" aria-describedby="slick-slide01" style="width: 329px;">
                                            <div class="image-imitation">
                                                [IMAGE 2]
                                            </div>
                                        </div><div class="slick-slide" data-slick-index="2" aria-hidden="true" tabindex="-1" role="option" aria-describedby="slick-slide02" style="width: 329px;">
                                            <div class="image-imitation">
                                                [IMAGE 3]
                                            </div>
                                        </div><div class="slick-slide slick-cloned" data-slick-index="3" aria-hidden="true" tabindex="-1" style="width: 329px;">
                                            <div class="image-imitation">
                                                [IMAGE 1]
                                            </div>
                                        </div></div></div>
                                        
                                        


                                    <button type="button" data-role="none" class="slick-next slick-arrow" aria-label="Next" role="button" style="display: block;">Next</button><ul class="slick-dots" style="display: block;" role="tablist"><li class="slick-active" aria-hidden="false" role="presentation" aria-selected="true" aria-controls="navigation00" id="slick-slide00"><button type="button" data-role="none" role="button" aria-required="false" tabindex="0">1</button></li><li aria-hidden="true" role="presentation" aria-selected="false" aria-controls="navigation01" id="slick-slide01"><button type="button" data-role="none" role="button" aria-required="false" tabindex="0">2</button></li><li aria-hidden="true" role="presentation" aria-selected="false" aria-controls="navigation02" id="slick-slide02"><button type="button" data-role="none" role="button" aria-required="false" tabindex="0">3</button></li></ul></div>

                                </div>
                                <div class="col-md-7">

                                    <h2 class="font-bold m-b-xs">
                                        Desktop publishing software
                                    </h2>
                                    <small>Many desktop publishing packages and web page editors now.</small>
                                    <div class="m-t-md">
                                        <h2 class="product-main-price">$406,602 <small class="text-muted">Exclude Tax</small> </h2>
                                    </div>
                                    <hr>

                                    <h4>Product description</h4>

                                    <div class="small text-muted">
                                        It is a long established fact that a reader will be distracted by the readable
                                        content of a page when looking at its layout. The point of using Lorem Ipsum is

                                        <br>
                                        <br>
                                        There are many variations of passages of Lorem Ipsum available, but the majority
                                        have suffered alteration in some form, by injected humour, or randomised words
                                        which don't look even slightly believable.
                                    </div>
                                    <dl class="small m-t-md">
                                        <dt>Description lists</dt>
                                        <dd>A description list is perfect for defining terms.</dd>
                                        <dt>Euismod</dt>
                                        <dd>Vestibulum id ligula porta felis euismod semper eget lacinia odio sem nec elit.</dd>
                                        <dd>Donec id elit non mi porta gravida at eget metus.</dd>
                                        <dt>Malesuada porta</dt>
                                        <dd>Etiam porta sem malesuada magna mollis euismod.</dd>
                                    </dl>
                                    <hr>

                                    <div>
                                        <div class="btn-group">
                                            <button class="btn btn-primary btn-sm"><i class="fa fa-cart-plus"></i> Add to cart</button>
                                            <button class="btn btn-white btn-sm"><i class="fa fa-star"></i> Add to wishlist </button>
                                            <button class="btn btn-white btn-sm"><i class="fa fa-envelope"></i> Contact with author </button>
                                        </div>
                                    </div>



                                </div>
                            </div>

                        </div>
                        <div class="ibox-footer">
                            <span class="pull-right">
                                Full stock - <i class="fa fa-clock-o"></i> 14.04.2016 10:04 pm
                            </span>
                            The generated Lorem Ipsum is therefore always free
                        </div>
                    </div>
                    
                    
                    
								</div>
							</div><!-- /.tab-pane -->	
							<div class="tab-pane fade" id="my-site-announce">
								<h4><small class="text-muted">공지 &amp; 이벤트을 작성하고 수정할 수 있습니다. </small></h4>
							</div><!-- /.tab-pane -->
						</div><!-- /.tab-content -->
					</div><!-- /.tab-v1 -->						
				</div>	
			</div><!-- /.container -->								
			<!-- ./END MAIN CONTENT -->				
	 		<!-- START FOOTER -->
			<#include "/html/common/common-homepage-globalfooter.ftl" >		
			<!-- ./END FOOTER -->				
		</div>	
		
		<div id="my-site-menu-editor" class="dialog" data-feature="dialog" data-dialog-animate="">
			<div class="dialog__overlay"></div>
			<div class="dialog__content">			
				<span class="btn-flat close" data-dialog-close></span>						
				<div class="container">
					<div class="row">
						<div class="col-sm-12">
									<div class="sky-form">
										<header><span data-bind="text:website.menu.title"></span>( <span data-bind="text:website.menu.name"></span>)</header>
										<fieldset class="padding-sm">
											<div class="row">
												<div class="col-md-9"></div>
												<div class="col-md-3"><label class="toggle"><input type="checkbox" name="checkbox-toggle" data-bind="checked: useWrapMode, events: { change:useWrap }"><i class="rounded-4x"></i>줄바꿈 설정/해지</label></div>
											</div>
										</fieldset>
										<div id="menueditor"></div>
										<footer class="text-right">
											<button class="btn-u action-update" data-loading-text="<i class='fa fa-spinner fa-spin'></i>" data-bind="click:updateMenuData" > 저장 </button>
											<button class="btn-u btn-u-default btn-u-small action-refresh" data-bind="click:refresh"> 새로고침 </button>										
										</footer>
									</div>	
						</div>
					</div>					
				</div>				
			</div>
		</div>		
		<div id="my-site-template-editor" class="dialog" data-feature="dialog" data-dialog-animate="">
			<div class="dialog__overlay"></div>
			<div class="dialog__content">			
				<span class="btn-flat close" data-dialog-close></span>		
				<div class="container">
					<div class="row">
						<div class="col-sm-4">
							<div class="sky-form">
								<header>템플릿</header>						
								<fieldset class="padding-sm">
									<div class="tab-v1 p-xxs">								
										<ul class="nav nav-tabs" id="template-tree-tabs">
											<li><a href="#template-tree-view" data-toggle="tab">기본</a></li>
											<li><a href="#custom-template-tree-view" data-toggle="tab">사용자 정의</a></li>
										</ul>	
										<div class="tab-content" style="min-height:300px;">
											<div class="tab-pane fade" id="template-tree-view"></div>
											<div class="tab-pane fade" id="custom-template-tree-view"></div>
										</div>
									</div>										
								</fieldset>
							</div>									
						</div><!-- ./col-sm-4 -->						
						<div class="col-sm-8">
							<div class="sky-form animated fadeIn" data-bind="visible: visible" style="display:none;">
								<fieldset>	
									<section>
										<div class="headline">
											<h3 class="padding-sm-hr"><i class="fa fa-folder-o" data-bind="visible:file.directory"></i><i class="fa fa-file-text-o" data-bind="invisible:file.directory"></i> <span data-bind="text:file.name"></span></h3>
											<div class="pull-right text-muted">
												<span data-bind="text:file.formattedSize"></span> bytes &nbsp;&nbsp;<span data-bind="text:file.formattedLastModifiedDate">&nbsp;</span>
											</div>
										</div>
									</section>								
									<div class="row">
										<section class="col-md-6">
											<label class="toggle"><input type="checkbox" name="checkbox-toggle" data-bind="checked: useWrapMode, events: { change:useWrap }"><i class="rounded-4x"></i>줄바꿈 설정/해지</label>
										</section>
										<section class="col-md-6 text-right">
											<button class="btn btn-success btn-sm" data-bind="visible: supportSvn, click:openFileUpdateModal" style="display:none;" ><i class="fa fa-long-arrow-down"></i> 업데이트</button>
											<button class="btn btn-danger btn-sm" data-bind="visible: supportCustomized, click:openFileCopyModal" style="display:none;"><i class="fa fa-code"></i> 사용자 정의 템플릿 만들기</button>
										</section>
									</div>																		
								</fieldset>	
								<div id="templateeditor" class="panel-body bordered no-border-hr no-border-b" data-bind="invisible: file.directory" style="display:none;"></div>											
							</div>
						</div><!-- ./col-sm-8 -->									
					</div>					
				</div>				
			</div>		
		</div>
												
	<!-- START TEMPLATE -->			
    <script type="text/x-kendo-template" id="my-site-listview-template">
	<div class="forum-item">
    	<div class="row">
        	<div class="col-md-9">
                <div class="forum-img">
                    <img src="<@spring.url "/download/logo/site/#= name #"/>" class="img-responsive" alt="">
                </div>
               <!-- <a href="forum_post.html" class="forum-item-title">#: displayName #</a>-->
                <h4 class="forum-item-title">#: displayName #</h4>
                <div class="forum-sub-title">#: description #</div>
            </div>
            <div class="col-md-1 forum-info">
            	<span class="views-number">0</span>
            	<div><small>Views</small></div>
            </div>
            <div class="col-md-1 forum-info">
            	<span class="views-number">0</span>
                <div>
                   	<small>Topics</small>
                </div>
           	</div>
       		<div class="col-md-1 forum-info">
       			<span class="views-number">0</span>
           		<div>
            		<small>Posts</small>
        		</div>
        	</div>
        </div><!-- /.row -->
	</div><!-- /.forum-item -->
                               
    <!--
	<div class="row my-website team-v7">
		<div class="col-sm-2 ">
			<img src="<@spring.url "/download/logo/site/#= name #"/>" class="img-responsive hover-effect" alt="">
		</div>	
		<div class="col-sm-10 team-v7-in">		
			<h3>#: displayName #</h3>
			<ul class="list-inline">
				<li><i class="fa fa-globe color-green"></i> #: url #</li>
			</ul>
			<p>#: description #</p>			
		</div>
	</div>
	-->
    </script>
    		
	<script id="webpage-title-template" type="text/x-kendo-template">
		#: title #</span>
		<div class="btn-group btn-group-xs pull-right">
			<a href="\\#" onclick="doPageEdit(); return false;" class="btn btn-info btn-sm">편집</a>
			<a href="\\#" onclick="doPageDelete(); return false;" class="btn btn-info btn-sm">삭제</a>
			<a href="\\#" onclick="doPagePreview(); return false;" class="btn btn-info btn-sm">미리보기</a>
		</div>	
	</script>
	
	<script id="treeview-template" type="text/kendo-ui-template">
	#if(item.directory){#<i class="fa fa-folder-open-o"></i> # }else{# <i class="fa fa-file-code-o"></i> #}#
		#: item.name # 
		# if (!item.items) { #
		<a class='delete-link' href='\#'></a> 
		# } #
	</script>	
	<#include "/html/common/common-homepage-templates.ftl" >		
	<#include "/html/common/common-personalized-templates.ftl" >
	<#include "/html/common/common-editor-templates.ftl" >	
	<!-- ./END TEMPLATE -->
	</body>    
</html>