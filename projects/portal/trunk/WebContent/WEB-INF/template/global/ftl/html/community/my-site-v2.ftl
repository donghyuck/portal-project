<#ftl encoding="UTF-8"/>
<html decorator="unify">
<head>
		<title><#if action.webSite ?? >${action.webSite.displayName }<#else>::</#if></title>
		<#compress>		
		<script type="text/javascript">
		<!--
		var jobs = [];	
				
		yepnope([{
			load: [
			'css!<@spring.url "/styles/font-awesome/4.2.0/font-awesome.min.css"/>',
			'css!<@spring.url "/styles/jquery.sky-forms/2.0.1/custom-sky-forms.css"/>',	
			'css!<@spring.url "/styles/bootstrap.themes/unify/colors/blue.css"/>',
			'css!<@spring.url "/styles/bootstrap.themes/unify/skins/dark.css"/>',
			'css!<@spring.url "/styles/jquery.magnific-popup/magnific-popup.css"/>',
			'css!<@spring.url "/styles/common/common.flat-icons.css"/>',		
			'css!<@spring.url "/styles/common.pages/common.personalized.css"/>',
			'css!<@spring.url "/styles/codrops/codrops.cbp-spmenu.css"/>',
			'css!<@spring.url "/styles/codrops/codrops.morphing.css"/>',	
			'css!<@spring.url "/styles/codrops/codrops.page-transitions.css"/>',			
			'<@spring.url "/js/jquery/1.10.2/jquery.min.js"/>',
			'<@spring.url "/js/jgrowl/jquery.jgrowl.min.js"/>',
			'<@spring.url "/js/jquery.magnific-popup/jquery.magnific-popup.min.js"/>',	
			'<@spring.url "/js/jquery.easing/jquery.easing.1.3.js"/>',		
			'<@spring.url "/js/jquery.bxslider/jquery.bxslider.min.js"/>',
			'<@spring.url "/js/kendo/kendo.web.min.js"/>',
			'<@spring.url "/js/kendo.extension/kendo.ko_KR.js"/>',			
			'<@spring.url "/js/kendo/cultures/kendo.culture.ko-KR.min.js"/>',			
			'<@spring.url "/js/bootstrap/3.3.0/bootstrap.min.js"/>',
			'<@spring.url "/js/common.plugins/jquery.slimscroll.min.js"/>', 		
			'<@spring.url "/js/common.plugins/query.backstretch.min.js"/>', 					
			'<@spring.url "/js/pdfobject/pdfobject.js"/>',			
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
						wallpaper : true,
						lightbox : true,
						spmenu : false,
						morphing : true,
						accounts : {
							authenticate : function(e){
								e.token.copy(currentUser);
								if( !currentUser.anonymous ){		
									$("#announce-selector label.btn").last().removeClass("disabled");									 
								}
							} 
						}						
					},
					wallpaper : {
						slideshow : false
					},
					jobs:jobs
				});				
				// ACCOUNTS LOAD			
				var currentUser = new common.ui.data.User();			
				$(".navbar-nav li[data-menu-item='MENU_PERSONALIZED'], .navbar-nav li[data-menu-item='MENU_PERSONALIZED_1']").addClass("active");		
				
				setupPersonalizedSection();
				createWebsiteSection();		
						
				$("input[type=radio][name=my-site-action]").on("change", function () {
					var $this = $(this);
					var target = $this.attr("aria-controls");
					if( !$("#" + target ).data("feature-on") ){
						switch( target ){
							case "my-page" :
								createPageSection();
								break;
							case "my-site-notice":
								createNoticeSection();				
							break;
							case "my-site-template":
								createTemplateSection();
								$('#template-tree a:first').tab('show');
							break;	
						}
						$("#" + target ).data("feature-on", true );
					} 			
			
					$(".personalized-section-content .container > div:visible").fadeOut( function(e){
						$("#" + target ).fadeIn();
					});	

					if( $(".personalized-section-content .container > div:visible").length == 0 ){
						$("#" + target ).fadeIn();					
					}		
				});
				// END SCRIPT 				
			}
		}]);			
		<!-- ============================== -->
		<!-- MENU														-->
		<!-- ============================== -->
		function createWebsiteSection(){				
			var model = kendo.observable({
				website : new common.ui.data.WebSite(),
				updateMenuData : function(e){			
					var $this = this;
					var btn = $(e.target);						
					btn.button('loading');			
					
					$this.website.menu.menuData = ace.edit("xmleditor").getValue();
						common.ui.ajax(
							'<@spring.url "/secure/data/menu/update.json?output=json" />' , 
							{
								data : kendo.stringify( $this.website.menu ),
								contentType : "application/json",
								success : function(response){									
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
									kendo.ui.progress($("#my-site-menu"), true);
								},
								requestEnd : function(){
									kendo.ui.progress($("#my-site-menu"), false);
								},
								complete : function(e){
									$this.refresh();
									btn.button('reset');
								}
							});	
											
				},
				menuDataUpdated : false,
				useWrapMode : false,
				useWrap : function(e){
					ace.edit("xmleditor").getSession().setUseWrapMode(this.useWrapMode);
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
								var site = new common.ui.data.WebSite(response);
								site.copy($this.website);
								$this.menuDataUpdated = false;
							}
						}
					);						
				}
			});	
								
			var editor = ace.edit("xmleditor");			
			editor.setTheme("ace/theme/monokai");
			editor.getSession().setMode("ace/mode/xml");					
			editor.getSession().on("change", function(e){
				model.set("menuDataUpdated", true);
			});			
			model.bind("change", function(e){		
				var sender = e.sender ;
				if( e.field.match('^website.menu')){
				 	editor.setValue( sender.website.menu.menuData );	
				}
			});								
			common.ui.bind($(".website-details"), model);			
			model.refresh();			
		}
		
		<!-- ============================== -->
		<!-- TEMPLATE												-->
		<!-- ============================== -->		
		function createTemplateSection(){
			$('#template-tree').on( 'show.bs.tab', function (e) {		
				var show_bs_tab = $(e.target);
				switch( show_bs_tab.attr('href') ){
					case "#template-tree-view" :
						createTemplateTree($("#template-tree-view"), false);
						break;
					case  '#custom-template-tree-view' :
						createTemplateTree($("#custom-template-tree-view"), true);
						break;
				}					
			});
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
			var renderTo = $('#template-editor');			
			if(!renderTo.data("model")){					
				var model = kendo.observable({
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
					setFile : function( fileToUse ) {
	
						this.file.path = fileToUse.get("path");
						this.file.set("customized", fileToUse.get("customized") );
						this.file.set("absolutePath", fileToUse.get("absolutePath") );
						this.file.set("name", fileToUse.get("name"));
						this.file.set("size", fileToUse.get("size") );
						this.file.set("directory", fileToUse.get("directory"));
						this.file.set("lastModifiedDate", fileToUse.get("lastModifiedDate") );
						
						if( !this.file.customized && !this.file.directory ) 
						{
							this.set("supportCustomized", true); 
						}else{
							this.set("supportCustomized", false); 
						}				    	
						if( this.file.path.indexOf( ".svn" ) != -1 ) {
							this.set("supportSvn", false); 
						}else{
							this.set("supportSvn", true); 
						}
						
						if(!this.file.directory){
							common.ui.ajax(
							'<@spring.url "/secure/data/template/get.json?output=json" />' , 
							{
								data : { path:  this.file.path , customized: this.file.customized },
								success : function(response){
									ace.edit("htmleditor").setValue( response.fileContent );	
								}
							}); 
				    	}
				    	this.set("visible", true);		    					    			
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
				model.setFile(file);
				kendo.bind(renderTo, model );	
				renderTo.data("model", model );	
				var editor = ace.edit("htmleditor");		
				editor.getSession().setMode("ace/mode/ftl");
				editor.getSession().setUseWrapMode(true);	
			}else{
				renderTo.data("model").setFile(file);
			}		
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
				createEditor( "page-editor" , bodyEditor );			
				//createEditor( "page-editor" , bodyEditor, { modal : false , appendTo: $("#my-page-editor-code"), tab: $("#my-page-editor-tabs"), useWrapMode : true } );
				
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
						common.ui.scroll.top($("#my-site-notice").parent());
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
						{ field: "subject", title: "소스", width: 80, headerAttributes: { "class": "table-header-cell", style: "text-align: center"},	template: '# if (objectType == 30) { # <span class="label label-info">웹사이트</span>	# }else{ # <span class="label label-danger">회사</span># } #	' },					
						{ field: "user.username", title: "작성자", width: 100, headerAttributes: { "class": "table-header-cell", style: "text-align: center" }, template:'<img width="25" height="25" class="img-circle" src="#: authorPhotoUrl() #" style="margin-right:10px;"> #if ( user.nameVisible ) {# #: user.name # #} else{ # #: user.username # #}#' },
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

		function createAnnounceEditorSection(source){			
			var renderTo = $(".morphing");		
			if( !renderTo.data("model")){
				var model =  common.ui.observable({ 
					announce : new common.ui.data.Announce(),
					new: true,
					changed : false,
					update : function(e){
						var $this = this, 
						btn = $(e.target);						
						btn.button('loading');
						if( $this.announce.subject.length == 0 || $this.announce.body.length == 0 ){
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
						if( $this.announce.startDate >= $this.announce.endDate  ){
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
								data : kendo.stringify( $this.announce ),
								contentType : "application/json",
								success : function(response){									
									var listRenderTo = $("#my-announce-section .my-announce-list");
									common.ui.listview($("#my-notice-grid")).dataSource.read();
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
						$(".morphing ").toggleClass("open");			
					}
				});				
				var announceSelector = common.ui.buttonGroup($("#edit-announce-selector"), {
					change: function(e){							
						if( e.value != model.get("announce.objectType") ){				
							model.set("announce.objectType", e.value );
						}
					}
				});				
				model.bind("change", function(e){	
					if( e.field == "announce.objectType" && this.get(e.field) != announceSelector.value ){ 		
						announceSelector.select(this.get(e.field));
					}
				});				
				kendo.bind( renderTo, model);
				renderTo.data("model", model);
				var bodyEditor =  $("#announce-editor-body" );
				createEditor( "announce-editor" , bodyEditor, { modal : false , theme: "ace/theme/monokai" } );				
			}
			if( source ){
				source.copy( renderTo.data("model").announce );
				renderTo.data("model").set("announce.objectType", common.ui.buttonGroup($("#announce-selector")).value); 
				if( source.announceId === 0 ){
					renderTo.data("model").set("new", false); 
				}else{
					renderTo.data("model").set("new", false); 					
				} 
			}		
			renderTo.data("model").set("changed", false);
		}
				
		function createAnnounceSection(){
			
			var renderTo = $("#my-announce-section");
			var listRenderTo = $("#my-announce-section .my-announce-list");
			var viewRenderTo = $("#my-announce-section .my-announce-view");			
			var model =  common.ui.observable({ 
				announce : new common.ui.data.Announce(),
				editable : false,
				visible : false,
				new : function(e){
					e.stopPropagation();
					common.ui.scroll.top(renderTo.parent());
					$(".morphing").toggleClass("open");					
				},
				edit : function(e){
					e.stopPropagation();
					common.ui.scroll.top(renderTo.parent());
					createAnnounceEditorSection(this.announce);
					$(".morphing").toggleClass("open");					
				}
			});			
			model.bind("change", function(e){				
				if( e.field == "announce.user" ){ 				
					if( getCurrentUser().userId == this.get(e.field).userId )
						this.set("editable", true);
				}
			});
			var announceSelector = common.ui.buttonGroup(
				$("#announce-selector"),
				{
					change: function(e){						
						listRenderTo.data("kendoListView").dataSource.read({objectType:e.value});
					}
				}
			);				
			kendo.bind(viewRenderTo, model );
			common.ui.listview(	listRenderTo, {
					dataSource : common.ui.datasource(
						'<@spring.url "/data/announce/list.json"/>',
						{
							transport : {
								parameterMap: function(options, operation) {
									if( typeof options.objectType === "undefined"  ){
										return {objectType: announceSelector.value };	
									}else{			
										return options;		
									} 
								}
							},
							schema: {
								data : "announces",
								model : common.ui.data.Announce,
								total : "totalCount"
							}
						}
					),
					template: kendo.template($("#announce-listview-item-template").html()),
					selectable: "single" ,
					dataBound: function(e){
						model.set("visible", false);
					},
					change: function(e){						
						var selectedCells = this.select();
						var selectedCell = this.dataItem( selectedCells );	
						selectedCell.copy( model.announce );			
						model.set("visible", false);			
						if(!common.ui.visible(viewRenderTo)){
							viewRenderTo.slideDown();
						}						
						common.ui.scroll.top(viewRenderTo, -20);
					}
				}
			);
			common.ui.pager($("#my-announce-list-pager"), {dataSource: listRenderTo.data("kendoListView").dataSource });			
		}
		

		

		-->
		</script>		
		<style scoped="scoped">			
		
		.acc-v1	.panel-default {
			border-color: #bbb;
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
		
		#my-page 	span.back, #my-notice-edit 	span.back {
			top:inherit;
			left:inherit;
		}
		
		#my-page .k-editor, #my-site-notice .k-editor {
			border:0px;
		}
		
		.sky-form fieldset {
			background: #fff;
		}
		
		
		#my-notice-grid .k-grid-content {
			height:530px;
		}
		
		
		#xmleditor.ace_editor, #htmleditor.ace_editor , #my-notice-edit  .ace_editor{
			min-height: 500px;			
		}
		
		#my-notice-listview.k-listview .k-state-selected
		{
			background : #F5F5F5;
			color: #585f69;
		}		
		</style>   	
		</#compress>
	</head>
	<body id="doc" class="bg-dark">
		<div class="page-loader"></div>
		<div class="wrapper">
			<!-- START HEADER -->		
			<#include "/html/common/common-homepage-menu.ftl" >		
			<!-- ./END HEADER -->
			<!-- START MAIN CONTENT -->
			<section class="personalized-section bg-transparent no-margin-b open" >
				<div class="personalized-section-heading">
					<div class="container">
						<div class="personalized-section-title">
							<i class="icon-flat  settings2"></i>
							<h3>MY 사이트 <span style="height:2.6em;" class="hidden-xs"> 웹사이트의 메뉴, 페이지, 이미지들을 쉽고 빠르게 생성하고 수정할 수 있습니다. <i class="fa fa-long-arrow-right"></i></span></h3>
							<div class="personalized-section-heading-controls">		
								<div class="btn-group" data-toggle="buttons">
									<label class="btn btn-sm btn-primary rounded-left">
										<input type="radio" name="my-site-action" aria-controls="my-site-menu"><i class="fa fa-sitemap"></i> 메뉴
									</label>
									<label class="btn btn-sm btn-primary">
										<input type="radio" name="my-site-action" aria-controls="my-site-template"><i class="fa fa-file-code-o"></i> 템플릿
									</label>	
									<label class="btn btn-sm btn-primary">
										<input type="radio" name="my-site-action" aria-controls="my-site-notice"><i class="fa fa-bullhorn"></i> 공지 및 이벤트
									</label>											
									<label class="btn btn-sm btn-primary rounded-right">
										<input type="radio" name="my-site-action" aria-controls="my-page"><i class="fa fa-file-o"></i> 페이지
									</label>
								</div>
							</div>
						</div>
					</div>				
				</div>
				<div class="personalized-section-content animated arrow-up">	
					<div class="container content" style="min-height:450px;">											
						<div id="my-site-menu" class="bg-slivergray rounded-2x website-details" style="display:none;">
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
										<div id="xmleditor"></div>
										<footer class="text-right">
											<button class="btn-u action-update" data-loading-text="<i class='fa fa-spinner fa-spin'></i>" data-bind="click:updateMenuData" > 저장 </button>
											<button class="btn-u btn-u-default btn-u-small action-refresh" data-bind="click:refresh"> 새로고침 </button>										
										</footer>
									</div>
								</div>
							</div>
						</div>					
							
						<div id="my-site-template" style="display:none;">
							<div class="row">
								<div class="col-sm-4">
									<div class="headline"><h2><i class="icon-flat folder m-b-n-sm"></i> 템플릿</h2></div>
									<div class="sky-form">
										<fieldset class="padding-sm">
											<div class="tab-v1 p-xxs">								
												<ul class="nav nav-tabs" id="template-tree">
													<li><a href="#template-tree-view" data-toggle="tab">디폴트</a></li>
													<li><a href="#custom-template-tree-view" data-toggle="tab">커스텀</a></li>
												</ul>	
												<div class="tab-content">
													<div class="tab-pane fade" id="template-tree-view"></div>
													<div class="tab-pane fade" id="custom-template-tree-view"></div>
												</div>
											</div>										
										</fieldset>
									</div>									
								</div>
								<div class="col-sm-8">								
									<div id="template-editor" class="panel panel-default animated fadeIn" data-bind="visible: visible" style="display:none;">
										<div class="panel-body padding-sm bg-slivergray">
											<span class="label label-warning">PATH</span>&nbsp;&nbsp;&nbsp;<span data-bind="text:file.path"></span>
											<div class="pull-right text-muted">
												<span data-bind="text:file.formattedSize"></span> bytes &nbsp;&nbsp;<span data-bind="text:file.formattedLastModifiedDate">&nbsp;</span>
											</div>
										</div>	
										<div class="panel-body padding-sm">	
											<div class="pull-right">
												<button class="btn btn-success btn-sm" data-bind="visible: supportSvn, click:openFileUpdateModal" style="display:none;" ><i class="fa fa-long-arrow-down"></i> 업데이트</button>
												<button class="btn btn-danger btn-sm" data-bind="visible: supportCustomized, click:openFileCopyModal" style="display:none;"><i class="fa fa-code"></i> 커스텀 템플릿 만들기</button>
											</div>												
										</div>
										<div id="htmleditor" class="panel-body bordered no-border-hr" data-bind="invisible: file.directory" style="display:none;"></div>
										<div class="panel-footer no-padding-vr"></div>
									</div>	
								</div>
							</div>	
						</div>
						<div id="my-site-notice" style="display:none;">
							<div class="row">
								<div id="my-notice-list" class="col-sm-4">		
									<div class="headline"><h2><i class="icon-flat mega-phone m-b-n-sm"></i> 공지 & 이벤트</h2></div>
									<div class="sky-form">
										<fieldset class="padding-sm">
											<p class="help-block"><i class="fa fa-info"></i> 소스와 검색 기간을 선택하세요.</p>	
											<div class="row">
												<section class="col-sm-12">
													<label class="label">소스</label>
													<div id="notice-source-list" class="btn-group" data-toggle="buttons">
														<label class="btn btn-info btn-sm active rounded-left">
															<input type="radio" name="notice-target" value="30"><i class="fa fa-globe"></i> 사이트
														</label>
														<label class="btn btn-info btn-sm rounded-right">
															<input type="radio" name="notice-target" value="1"><i class="fa fa-building-o"></i> 회사
														</label>
													</div>												
												</section>
											</div>											
											<div class="row">											
												<section class="col-lg-6">
													<label for="noticeStartDatePicker" class="label">시작일시</label>
													<input id="noticeStartDatePicker" data-role="datepicker" data-bind="value: startDate, events: { change: startDateChange }" />											
												</section>
												<section class="col-lg-6">
													<label for="noticeEndDatePicker" class="label">종료일시</label>
													<input id="noticeEndDatePicker"  data-role="datepicker" data-bind="value: endDate,  events: { change: endDateChange }" />													
												</section>
											</div>		
											<div class="row">
												<section class="col-sm-12 text-right">
													<button type="button" class="btn btn-sm btn-danger" data-bind="click:create"><span class="btn-label icon fa fa-plus"></span> 새로운 공지 & 이벤트</button>
													<button class="btn btn-primary btn-sm " data-bind="click:refresh"><i class="fa fa-search"></i> 검색 </button>												
												</section>
											</div>																				
										</fieldset>
										<div id="my-notice-grid" class="no-border-hr no-border-b"></div>					
									</div>																				
								</div>
								<div id="my-notice-view" class="col-sm-8">
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
								</div>
								<div id="my-notice-edit" class="col-sm-8" style="display:none;">
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
												<span class="help-block">지정된 기간 동안만 이벤트 및 공지가 보여집니다.</span>
											</section>		
											<div class="row">
												<div class="col col-6">
																							
												</div>
												<div class="col col-6">
												</div>												
											</div>		
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
									</div>																			
								</div>													
							</div><!-- /.row -->
						</div><!-- /. my-site-notice -->	
						<div id="my-page"  style="display:none;">
							<div class="row">
								<div id="my-page-list">
									<div class="p-xxs">
										<div class="btn-group" data-toggle="buttons" id="page-source-list">
											<label class="btn btn-sm btn-danger rounded-left active">
												<input type="radio" name="page-source" value="2" checked="checked"><i class="fa fa-user"></i> ME
											</label>
											<label class="btn btn-sm btn-danger">
												<input type="radio" name="page-source" value="30"><i class="fa fa-globe"></i> SITE
											</label>											
											<label class="btn btn-sm btn-danger rounded-right">
												<input type="radio" name="page-source" value="1"><i class="fa fa-building-o"></i> COMPANY
											</label>
										</div>
										<button type="button" class="btn btn-sm btn-danger" data-action="page-create"><span class="btn-label icon fa fa-plus"></span> 새 페이지 만들기 </button>
										<button type="button" class="btn btn-primary btn-sm" data-action="page-publish" disabled="disabled" data-loading-text="<i class=&quot;fa fa-spinner fa-spin&quot;></i>"><i class="fa fa-external-link"></i> 게시</button>
									</div>
									<div id="my-page-grid"></div>
								</div><!-- /.my-page-list -->
								<div id="my-page-view" style="display:none;">	
									<span class="hidden-lg  m-t-sm" ></span>				
									<span class="back"></span>
									<form action="" class="sky-form" novalidate="novalidate">
										<header>&nbsp;</header>
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
													<section>
														<span class="label label-light" data-bind="text:page.pageState"></span>
													</section>
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
										<section class="no-margin">	
											<textarea id="page-editor-body" class="no-border" data-bind='value:page.bodyContent.bodyText' style="height:500px;"></textarea>
										</section>											
										<footer class="text-right">
											<button type="button" class="btn-u" data-bind="events:{click:update}" data-loading-text="<i class='fa fa-spinner fa-spin'></i>">저장</button>
											<button type="button" class="btn-u btn-u-default btn-u-small" data-bind="events{click:close}">취소</button>	
										</footer>
									</form><!-- /.form >	
								</div><!-- /.my-page-view -->
							</div><!-- /.my-page -->
						</div><!-- /.row -->
					</div><!-- /.container -->
				</div>				
			</section><!-- /.section -->
			<!-- ./END MAIN CONTENT -->	
	 		
	 		<!-- START FOOTER -->
			<#include "/html/common/common-homepage-footer.ftl" >		
			<!-- ./END FOOTER -->					
		</div>				
			<!-- START RIGHT SLIDE MENU -->
			<section class="cbp-spmenu cbp-spmenu-vertical cbp-spmenu-right"  id="personalized-controls-section">
				<h5 class="side-section-title white">My 클라우드 저장소</h5>		
				<button type="button" class="btn-close" data-dismiss='spmenu' >Close</button>
				<!-- tab-v1 -->
				<div class="tab-v1 m-t-md" >						
					<ul class="nav nav-tabs" id="myTab" style="padding-left:5px;">
						<#if !action.user.anonymous >	
						<li><a href="#my-photo-stream" tabindex="-1" data-toggle="tab">포토</a></li>
						<li><a href="#my-files" tabindex="-1" data-toggle="tab">파일</a></li>							
						</#if>						
					</ul>		
					<!-- tab-content -->		
					<div class="tab-content" style="background-color : #FFFFFF; padding:5px;">
						<!-- start attachement tab-pane -->
						<div class="tab-pane" id="my-files">
								<div class="panel panel-default panel-upload no-margin-b no-border-b" style="display:none;">
								<div class="panel-heading">
									<strong><i class="fa fa-cloud-upload  fa-lg"></i> 파일 업로드</strong> <button type="button" class="close btn-control-group" data-action="upload-close">&times;</button>
								</div>						
									<div class="panel-body">													
										<#if !action.user.anonymous >			
											<div class="page-header text-primary">
												<h5><i class="fa fa-upload"></i>&nbsp;<strong>파일 업로드</strong>&nbsp;<small>아래의 <strong>파일 선택</strong> 버튼을 클릭하여 파일을 직접 선택하거나, 아래의 영역에 파일을 끌어서 놓기(Drag & Drop)를 하세요.</small></h5>
											</div>								
											<input name="uploadAttachment" id="attachment-files" type="file" />												
										</#if>								
									</div>
								</div>
							<div class="panel panel-default">
								<div class="panel-body">
									<p class="text-muted"><small><i class="fa fa-info"></i> 파일을 선택하면 아래의 마이페이지 영역에 선택한 파일이 보여집니다.</small></p>
									<#if !action.user.anonymous >		
									<p class="pull-right">				
										<button type="button" class="btn btn-info btn-lg btn-control-group" data-toggle="button" data-action="upload"><i class="fa fa-cloud-upload"></i> 파일업로드</button>	
									</p>	
									</#if>																										
									<div class="btn-group" data-toggle="buttons" id="attachment-list-filter">
										<label class="btn btn-sm btn-warning active">
											<input type="radio" name="attachment-list-view-filters"  value="all"> 전체 (<span data-bind="text: totalAttachCount"></span>)
										</label>
										<label class="btn btn-sm btn-warning">
											<input type="radio" name="attachment-list-view-filters"  value="image"><i class="fa fa-filter"></i> 이미지
										</label>
										<label class="btn btn-sm btn-warning">
											<input type="radio" name="attachment-list-view-filters"  value="file"><i class="fa fa-filter"></i> 파일
										</label>	
									</div>												
								</div>
								<div class="panel-body sm-padding" style="min-height:450px;">
									<div id="attachment-list-view" class="file-listview"></div>
								</div>	
								<div class="panel-footer no-padding">
										<div id="pager" class="file-listview-pager k-pager-wrap"></div>
								</div>
							</div>																				
						</div><!-- end attachements  tab-pane -->		
						<!-- start photos  tab-pane -->
						<div class="tab-pane" id="my-photo-stream">									
												<div class="panel panel-default panel-upload no-margin-b no-border-b" style="display:none;">
							<div class="panel-heading">
								<strong><i class="fa fa-cloud-upload  fa-lg"></i> 사진 업로드</strong> <button type="button" class="close btn-control-group" data-action="upload-close">&times;</button>
							</div>												
													<div class="panel-body">
														<#if !action.user.anonymous >			
														<div class="page-header text-primary">
															<h5><i class="fa fa-upload"></i>&nbsp;<strong>사진 업로드</strong>&nbsp;<small>아래의 <strong>사진 선택</strong> 버튼을 클릭하여 사진을 직접 선택하거나, 아래의 영역에 사진를 끌어서 놓기(Drag & Drop)를 하세요.</small></h5>
														</div>
														<div id="my-photo-upload">	
															<input name="uploadPhotos" id="photo-files" type="file" />					
														</div>
														<div class="blank-top-5" ></div>
														<div class="page-header text-primary">
															<h5><i class="fa fa-upload"></i>&nbsp;<strong>URL 사진 업로드</strong>&nbsp;<small>사진이 존재하는 URL 을 직접 입력하여 주세요.</small></h5>
														</div>						
														<form name="photo-url-upload-form" class="form-horizontal" role="form">
															<div class="form-group">
																<label class="col-sm-2 control-label"><small>출처</small></label>
																<div class="col-sm-10">
																	<input type="url" class="form-control" placeholder="URL"  data-bind="value: data.sourceUrl">
																	<span class="help-block"><small>사진 이미지 출처 URL 을 입력하세요.</small></span>
																</div>
															</div>
															<div class="form-group">
																<label class="col-sm-2 control-label"><small>사진</small></label>
																<div class="col-sm-10">
																	<input type="url" class="form-control" placeholder="URL"  data-bind="value: data.imageUrl">
																	<span class="help-block"><small>사진 이미지 경로가 있는 URL 을 입력하세요.</small></span>
																</div>
															</div>														
															<div class="form-group">
																<div class="col-sm-offset-2 col-sm-10">
																	<button type="submit" class="btn btn-primary btn-sm btn-control-group" data-bind="events: { click: upload }" data-loading-text='<i class="fa fa-spinner fa-spin"></i>'><i class="fa fa-cloud-upload"></i> &nbsp; URL 사진 업로드</button>
																</div>
															</div>
														</form>
														</#if>
													</div>
												</div>	

							<div class="panel panel-default">			
								<div class="panel-body">
									<p class="text-muted"><small><i class="fa fa-info"></i> 사진을 선택하면 아래의 마이페이지 영역에 선택한 사진이 보여집니다.</small></p>
									<#if !action.user.anonymous >		
									<p class="pull-right">				
										<button type="button" class="btn btn-info btn-lg btn-control-group" data-toggle="button" data-action="upload"><i class="fa fa-cloud-upload"></i> &nbsp; 사진업로드</button>																		
									</p>	
									</#if>											
								</div>
								<div class="panel-body sm-padding" style="min-height:450px;">
									<div id="photo-list-view" class="image-listview" ></div>
								</div>	
								<div class="panel-footer no-padding">
									<div id="photo-list-pager" class="image-listview-pager k-pager-wrap"></div>
								</div>
							</div>	
						</div><!-- end photos  tab-pane -->
					</div><!-- end of tab content -->
				</div>	
			</section>	
			<div class="cbp-spmenu-overlay"></div>			
			<!-- ./END RIGHT SLIDE MENU -->
							
	<!-- START TEMPLATE -->				
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
	<script type="text/x-kendo-template" id="notice-listview-item-template">	
	<div class="media media-v2 padding-sm no-margin-t">
		<a class="pull-left" href="\\#"><img width="30" height="30" class="img-circle" src="/download/profile/#= user.username #?width=150&amp;height=150"></a>
		<div class="media-body">
			<h5 class="media-heading">
				# if (objectType == 30) { #
					<span class="label label-info">공지</span></span>
				# }else{ #
					<span class="label label-danger">알림</span></span>
				# } #				
				<strong>#: subject #</strong> 
			</h5>
			<div class="name-location">		
				작성자 : # if (user.nameVisible) { # #: user.name # # } else { # #:user.username # # } #</p>				
			</div>
		</div>
	</div>
	</script>																									
	<#include "/html/common/common-homepage-templates.ftl" >		
	<#include "/html/common/common-personalized-templates.ftl" >
	<#include "/html/common/common-editor-templates.ftl" >	
	<!-- ./END TEMPLATE -->
	</body>    
</html>