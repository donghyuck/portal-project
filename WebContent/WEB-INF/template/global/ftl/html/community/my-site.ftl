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
						console.log(2);
						break;						
					}					
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
						{ title: "", width:80, template: '<button type="button" class="btn btn-xs btn-labeled btn-primary rounded btn-selectable" data-action="update" data-object-id="#= webPageId #"><span class="btn-label icon fa fa-pencil"></span> 변경</button>'}
					],
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
			}
			common.ui.grid(renderTo).dataSource.read( {siteId: getSelectedSite().webSiteId} );
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
			opacity: 0;
		}			
		
		.k-grid  .k-selectable tr[aria-selected="true"] > td > .btn-selectable , .k-grid .k-selectable tr[aria-selected="true"] > td  a.btn-selectable {
			opacity: 1;
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
								<div id="my-site-web-page-grid" />
							</div>	
							<div class="tab-pane fade" id="my-site-announce">
								<h4><small class="text-muted">공지 &amp; 이벤트을 작성하고 수정할 수 있습니다. </small></h4>
							</div>								
						</div>
					</div>						
				</div>								
				
				
						<div class="tab-v1">
							<ul class="nav nav-tabs">
								<li><a href="#website-page" data-toggle="tab" class="m-l-sm rounded-top">웹 페이지</a></li>
								<li><a href="#website-notice" data-toggle="tab" class="rounded-top">공지 & 이벤트</a></li>
								<li><a href="#website-poll" data-toggle="tab" class="rounded-top">설문</a></li>
								<li><a href="#website-timeline" data-toggle="tab" class="rounded-top">타임라인</a></li>
							</ul>
							<div class="tab-content">
								<div class="tab-pane fade" id="website-page">
									<h4><small class="text-muted">웹 페이지을 쉽고 빠르게 생성하고 수정할 수 있습니다.</small></h4>									
									<div id="my-page-list" class="p-xxs">
										<div class="btn-toolbar p-xxs">
											<div class="btn-group btn-group-md" data-toggle="buttons" id="page-source-list">
												<!--<label class="btn  btn-danger rounded-left ">
													<input type="radio" name="page-source" value="2"><i class="fa fa-user"></i> ME
												</label>-->
												<label class="btn btn-info btn-flat rounded  active">
													<input type="radio" name="page-source" value="30" checked="checked"><i class="fa fa-globe"></i> SITE
												</label>									
												<!--		
												<label class="btn btn-info rounded-right">
													<input type="radio" name="page-source" value="1"><i class="fa fa-building-o"></i> COMPANY
												</label>
												-->
											</div>
											<button type="button" class="btn btn-md btn-flat btn-danger rounded" data-action="page-create"><span class="btn-label icon fa fa-plus"></span> 새 페이지 만들기 </button>
											<button type="button" class="btn btn-primary btn-md btn-flat rounded" data-action="page-publish" disabled="disabled" data-loading-text="<i class=&quot;fa fa-spinner fa-spin&quot;></i>"><i class="fa fa-external-link"></i> 게시</button>
										</div>
										<div id="my-page-grid"></div>
									</div><!-- /.my-page-list -->
									
									<div id="my-page-view" style="display:none;">	
										<span class="hidden-lg  m-t-sm" ></span>				
										<span class="back"></span>
										<form action="" class="sky-form" novalidate="novalidate">
											<header class="text-right"><span class="badge badge-dark rounded" data-bind="text:page.pageState"></span></header>
											<fieldset>											
												<section>
													<label for="title" class="input">
														<input type="text" name="title" placeholder="제목" data-bind="value: page.title">
													</label>
												</section>										
												<div class="row">
													<div class="col col-6">
														<section>
															<label class="input">
																<i class="icon-prepend fa fa-file-text-o"></i>
																<input type="text" name="name" placeholder="파일" data-bind="value: page.name">
															</label>
														</section>
																										
														<section>
															<label class="input">
																<i class="icon-prepend fa fa-file-code-o"></i>
																<input type="text" name="template" placeholder="템플릿">
															</label>
														</section>
														
														<section>
															<label for="summary" class="textarea">
																<textarea rows="3" name="summary" placeholder="요약" data-bind="value: page.summary"></textarea>
															</label>
														</section>
													</div>
													<div class="col col-6">
														<div class="panel-group acc-v1" id="accordion-1" data-bind="visible: isAllowToFileAndProps">
															<div class="panel panel-default">
																<div class="panel-heading">
																	<h4 class="panel-title">
																		<a class="accordion-toggle collapsed" data-toggle="collapse" data-parent="#accordion-1" href="#collapse-One">
																		<i class="fa fa-cog"></i> 속성
																		</a>
																	</h4>
																</div>
																<div id="collapse-One" class="panel-collapse collapse" style="height: 0px;">
																	<div class="panel-body no-padding">
																		<div id="page-property-grid"></div>
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
																			style="border:0px;"></div>	
																	</div>
																</div>
															</div>
															<div class="panel panel-default">
																<div class="panel-heading">
																	<h4 class="panel-title">
																		<a class="accordion-toggle collapsed" data-toggle="collapse" data-parent="#accordion-1" href="#collapse-Two">
																		<i class="fa fa-floppy-o"></i> 파일
																		</a>
																	</h4>
																</div>
																<div id="collapse-Two" class="panel-collapse collapse" style="height: 0px;">
																	<div class="panel-body">
																	서비스 준비중 입니다.	
																	</div>
																</div>
															</div>					
															<div class="panel panel-default">
																<div class="panel-heading">
																	<h4 class="panel-title">
																		<a class="accordion-toggle collapsed" data-toggle="collapse" data-parent="#accordion-1" href="#collapse-Three">
																		<i class="fa fa-history"></i> 버전
																		</a>
																	</h4>
																</div>
																<div id="collapse-Three" class="panel-collapse collapse" style="height: 0px;">
																	<div class="panel-body">
																		<section>									
																			<label class="label">현재 버전</label>					
																			<label class="input state-disabled">
																				<input type="text" name="versionId" placeholder="버전" data-bind="value: page.versionId" readonly >
																			</label>
																		</section>
																	</div>
																</div>
															</div>																												
														</div>													
													</div>
												</div>
											</fieldset>
											<section class="no-margin p-sm">													
												<div class="tab-v1">
													<div role="tabpanel">
														<!-- Nav tabs -->													
														<ul class="nav nav-tabs" role="tablist" id="my-page-editor-tabs">
															<li role="presentation" class="active"><a href="#my-page-editor-ui" aria-controls="my-page-editor-ui" data-action-target="editor"  role="tab" data-toggle="tab">글쓰기</a></li>
															<li role="presentation"><a href="#my-page-editor-code" aria-controls="my-page-editor-code" data-action-target="ace" role="tab" data-toggle="tab">코드</a></li>
														</ul>												
														<!-- Tab panes -->
														<div class="tab-content no-padding">
															<div role="tabpanel" class="tab-pane active" id="my-page-editor-ui">
																<textarea id="page-editor-body" class="no-border" data-bind='value:page.bodyContent.bodyText' style="height:500px;"></textarea>
															</div>
															<div role="tabpanel" class="tab-pane" id="my-page-editor-code"></div>
														</div>
													</div>
												</div>																							
											</section>											
											<footer class="text-right">
												<button type="button" class="btn-u" data-bind="events:{click:update}" data-loading-text="<i class='fa fa-spinner fa-spin'></i>">저장</button>
												<button type="button" class="btn-u btn-u-default btn-u-small" data-bind="events{click:close}">취소</button>	
											</footer>
										</form><!-- /.form -->	
									</div><!-- /.my-page-view -->															
								</div>
								
								<div class="tab-pane fade" id="website-notice">
									<h4><small class="text-muted">공지 &amp; 이벤트을 작성하고 수정할 수 있습니다. </small></h4>
									<div id="my-notice-list" class="m-b-sm">
										<div class="sky-form">
											<fieldset class="padding-sm">
												<section class="col-sm-4">
													<label class="label">소스</label>
													<div id="notice-source-list" class="btn-group btn-group-sm" data-toggle="buttons">
														<label class="btn btn-info active rounded-left">
															<input type="radio" name="notice-target" value="30"><i class="fa fa-globe"></i> 사이트
														</label>
														<label class="btn btn-info rounded-right">
															<input type="radio" name="notice-target" value="1"><i class="fa fa-building-o"></i> 회사
														</label>
													</div>																								
												</section>
												<div class="col-sm-8">
													<div class="note"><i class="fa fa-info"></i> 공지기간이 지정한 시작일과 종료일에 포함되는 공지&이벤트들을 검색합니다.</div>
													<div class="row">
														<div class="col-sm-6">
															<label for="noticeStartDatePicker" class="label">시작일시</label>
															<input id="noticeStartDatePicker" data-role="datepicker" data-bind="value: startDate, events: { change: startDateChange }" style="height:auto;" />											
														</div>
														<div class="col-sm-6">
															<label for="noticeEndDatePicker" class="label">종료일시</label>
															<input id="noticeEndDatePicker"  data-role="datepicker" data-bind="value: endDate,  events: { change: endDateChange }" style="height:auto;" />																											
														</div>																
													</div>
														
												</div>																																																	
											</fieldset>	
											<footer class="text-right">
												<button type="button" class="btn btn-md btn-danger btn-flat" data-bind="click:create"><span class="btn-label icon fa fa-plus"></span> 새로운 공지 & 이벤트</button>
												<button class="btn btn-primary btn-md btn-flat " data-bind="click:refresh"><i class="fa fa-search"></i> 검색 </button>											
											</footer>														
										</div><!-- /.sky-form -->										
									</div><!-- /#my-notice-list -->											
									<div class="row">											
										<div class="col-sm-4">
											<div id="my-notice-grid"></div>
										</div>
										<div class="col-sm-8">
											<div id="my-notice-view">
												<span class="hidden-lg  m-t-sm" ></span>		
												<div class="sky-form" style="display:none;"  data-bind="visible: visible" class="animated fadeIn">
													<header data-bind="html:notice.subject"></header>
													<fieldset>
														<ul class="list-unstyled margin-bottom-30">
															<li class="p-xxs"><strong>게시 기간:</strong> <span data-bind="text:notice.formattedStartDate"></span> ~ <span data-bind="text:notice.formattedEndDate"></span></li>
															<li class="p-xxs"><strong>생성일:</strong> <span data-bind="text: notice.formattedCreationDate"></span></li>
															<li class="p-xxs"><strong>수정일:</strong> <span data-bind="text: notice.formattedModifiedDate"></span></li>
															<li class="p-xxs">
																<img width="30" height="30" class="img-circle pull-left" data-bind="attr:{src:notice.authorPhotoUrl}" src="/images/common/no-avatar.png" style="margin-right:10px;">
																<ul class="list-unstyled text-muted">
																	<li><span data-bind="visible: notice.user.nameVisible, text: notice.user.name"></span><code data-bind="text: notice.user.username"></code></li>
																	<li><span data-bind="visible: notice.user.emailVisible, text: notice.user.email"></span></li>
																</ul>															
															</li>
														</ul>
														<div class="text-right">
															<button type="button" class="btn-u" data-bind="events:{click:edit}">편집</button>
														</div>													
													</fieldset>
													<fieldset>
														<section  data-bind="html:notice.body"></section>
													</fieldset>												
												</div>												
											</div><!-- ./my-notice-view -->
											
											<div id="my-notice-edit" style="display:none;">
												<span class="hidden-lg  m-t-sm" ></span>		
												<span class="back" data-bind="events{click:close}"></span>
												<div class="sky-form" >
													<header>&nbsp;</header> 
													<fieldset class="padding-sm">
															<section>
																<label class="label">제목</label>
																<label for="title" class="input">
																	<input type="text" name="title" placeholder="제목" data-bind="value: notice.subject" >
																</label>
															</section>		
															<section class="no-margin">
																<label class="label">공지 기간</label>
																<input data-role="datetimepicker" data-bind="value:notice.startDate"> ~ <input data-role="datetimepicker" data-bind="value:notice.endDate">
																<div class="note"><i class="fa fa-info"></i> 지정된 기간 동안만 이벤트 및 공지가 보여집니다.</div>
															</section>			
													</fieldset>
													<section class="no-margin p-sm">	
															<div class="tab-v1">
																<div role="tabpanel">
																	<!-- Nav tabs -->													
																	<ul class="nav nav-tabs" role="tablist" id="my-notice-editor-tabs">
																		<li role="presentation" class="active"><a href="#my-notice-editor-ui" aria-controls="my-notice-editor-ui" data-action-target="editor"  role="tab" data-toggle="tab">글쓰기</a></li>
																		<li role="presentation"><a href="#my-notice-editor-code" aria-controls="my-notice-editor-code" data-action-target="ace" role="tab" data-toggle="tab">코드</a></li>
																	</ul>												
																	<!-- Tab panes -->
																	<div class="tab-content no-padding">
																		<div role="tabpanel" class="tab-pane active" id="my-notice-editor-ui">
																			<textarea id="notice-editor-body" class="no-border" data-bind='value:notice.body' style="height:500px;"></textarea>
																		</div>
																		<div role="tabpanel" class="tab-pane" id="my-notice-editor-code"></div>
																	</div>
																</div>
															</div>
													</section>											
													<footer class="text-right">
														<button type="button" class="btn-u btn-u-blue btn-u-small" data-bind="events:{click:update}" data-loading-text="<i class='fa fa-spinner fa-spin'></i>">저장</button> 
														<button type="button" class="btn-u btn-u-default btn-u-small" data-bind="events{click:close}">취소</button>
													</footer>										
												</div><!-- /.sky-form -->													
											</div><!-- ./my-notice-edit -->
										</div><!-- /.col-sm-8 -->										
									</div><!-- /.row -->									
								</div><!-- /. my-site-notice -->	
								<div class="tab-pane fade" id="website-poll">
									<h4><small class="text-muted">간단하게 설문을 작성하고 배포 할 수 있습니다. </small></h4>
								</div>
								
								<div class="tab-pane fade" id="website-timeline">
									<h4><small class="text-muted">웹 사이트의 타임라인을 관리합니다. </small></h4>
								</div>
					</div>
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