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
			'css!<@spring.url "/styles/common.ui.plugins/switchery.min.css"/>',		
				
			'css!<@spring.url "/styles/common/common.flat-icons.css"/>',	
			'css!<@spring.url "/styles/common.pages/common.personalized.css"/>',
						
			'css!<@spring.url "/styles/jquery.magnific-popup/magnific-popup.css"/>',		
			'css!<@spring.url "/styles/jquery.toastr/2.1.1/toastr.min.css"/>',
			'css!<@spring.url "/styles/jquery.sky-forms/2.0.1/custom-sky-forms.css"/>',
			'css!<@spring.url "/styles/hover-effect/hover-min.css"/>',		
				
			'css!<@spring.url "/styles/codrops/codrops.dialog.css"/>',		
			'css!<@spring.url "/styles/codrops/codrops.dialog-val.css"/>',			
			'css!<@spring.url "/styles/codrops/codrops.cbp-spmenu.css"/>',		
			
			'<@spring.url "/js/jquery/1.10.2/jquery.min.js"/>',
			'<@spring.url "/js/jgrowl/jquery.jgrowl.min.js"/>',
			'<@spring.url "/js/jquery.toastr/2.1.1/toastr.min.js"/>',
			'<@spring.url "/js/jquery.magnific-popup/jquery.magnific-popup.min.js"/>',	
			
			'<@spring.url "/js/kendo/kendo.web.min.js"/>',
			'<@spring.url "/js/kendo.extension/kendo.ko_KR.js"/>',			
			'<@spring.url "/js/kendo/cultures/kendo.culture.ko-KR.min.js"/>',	

			'<@spring.url "/js/bootstrap/3.3.5/bootstrap.min.js"/>',
			
			'<@spring.url "/js/common.ui.plugins/jquery.slimscroll.min.js"/>', 		
			'<@spring.url "/js/common.ui.plugins/jquery.backstretch.min.js"/>', 
			'<@spring.url "/js/common.ui.plugins/switchery.min.js"/>', 

			'<@spring.url "/js/common/common.ui.core.js"/>',							
			'<@spring.url "/js/common/common.ui.data.js"/>',
			'<@spring.url "/js/common/common.ui.data.admin.js"/>',
			'<@spring.url "/js/common/common.ui.community.js"/>',
			'<@spring.url "/js/common.pages/common.personalized.js"/>',
			
			'<@spring.url "/js/ace/ace.js"/>',
			'<@spring.url "/js/common.ui/common.ui.editor.js"/>',
			'<@spring.url "/js/common.pages/common.code-editor.js"/>'			
			],			
			complete: function() {		
				<#if RequestParameters['id']?? >
				var	webSiteId = ${ TextUtils.parseLong( RequestParameters['siteId'] ) } ;
				</#if>				
				common.ui.setup({
					features:{
						wallpaper : false,
						accounts : {
							authenticate : function(e){
								e.token.copy(currentUser);
								getSiteListView().dataSource.read();
																
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
						},
						error:common.ui.handleAjaxError
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
						case '#my-site-announcement' :
						createAnnouncementGrid();
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

		<!-- ============================== -->
		<!-- WEB PAGE						-->
		<!-- ============================== -->				   	
		function createWebPageGrid(){
			var renderTo = $("#my-site-web-page-grid");	
			if(! common.ui.exists(renderTo) ){			
				var grid = common.ui.grid(renderTo, {
					autoBind : true,
					height: '100%',
					dataSource: {
						transport: { 
							read: { url:'<@spring.url "/secure/data/mgmt/website/page/list.json?output=json" />', type:'POST', contentType : 'application/json' },
							parameterMap: function (options, type){
								options.objectId = getSelectedSite().webSiteId ;
								return common.ui.stringify( options );
							}
						},						
						batch: false, 
						pageSize: 15,
						serverPaging: true,
						serverFiltering: true,
						schema: {
							data: "items",
							total: "totalCount",
							model: common.ui.data.WebPage
						}
					},
					filterable: false,
					columns: [{ title: "페이지", field: "name"},
						{ title: "상태", width:40, headerAttributes:{ style:"text-align:center"}, attributes:{ class:"text-center" } , template: '#if(enabled){# <i class="fa fa-toggle-on text-primary" aria-hidden="true"></i> #}else{# <i class="fa fa-toggle-off" aria-hidden="true"></i> #}#' },
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
						var $this = this;
						if( $("#my-site-page .search-block-v2 input").val().length > 0 ){
							common.ui.notification().show({ title:null, message:  $this.dataSource.total() + "건이 조회되었습니다."	},"success");	
						}
					}	
				});	

				// searching 				
				$("#my-site-web-page-list.search-block-v2 input").change(function(e){
					var $this = $(this);					
					console.log($this.val());	
					if( $this.val().langth == 0 ){
						common.ui.grid(renderTo).dataSource.filter([]);
					}else{
						common.ui.grid(renderTo).dataSource.filter({ field: "name", operator: "contains", value: $this.val() }) ; 
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
						newWebPage.set("properties", []);
					}					
					$('#my-site-web-page-list').fadeOut(function(e){ 
						createWebPageEditor( newWebPage );
					});	
				});		
			}
		}
		<!-- ============================== -->
		<!-- WEB PAGE EDITOR				-->
		<!-- ============================== -->		
		function createWebPageEditor( source ){
			var renderTo = $("#my-site-web-page-view");
			if(!renderTo.data("model")){
				var switcheryRenderTo = renderTo.find("input[name='enabled-switcher']")[0];
				var switchery = new Switchery(switcheryRenderTo);
				var collapseOptions = $('#my-site-web-page-view-options') ;
				
				var observable =  common.ui.observable({
					page: new common.ui.data.WebPage(),
					fileContent : "",
					editable:false,
					propertyDataSource :new kendo.data.DataSource({
						batch: true,
						data : [],
						schema: {
                            model: common.ui.data.Property
                        }
					}),
					onChange : function(){ 
						var $this = this;
						console.log($this.page.enabled);
					},
					setSource : function(source){
						var $that = this;
						source.copy($that.page);	
						$that.set("editable", $that.page.webPageId > 0 ? true : false );	
											
						$that.propertyDataSource.read();				
						$that.propertyDataSource.data($that.page.properties);	
											
						collapseOptions.collapse('hide')
						
						if( !$that.editable ){
							$that.page.set("template", "");				
						}						
						$that.set("fileContent", "");
						switchery.setPosition();
					},
					openMenuFinder: function(e){
						createMenuFinderModal(this);					
					},
					openTemplateFinder: function(e){
						createTemplateFinderModal();					
					},
					openTemplateEditor:function(e){
						createTemplateEditor(this);		
					},
					closeTemplateEditor:function(e){
						createTemplateEditor(this);		
					},
					openInBroswer:function(e){
						var $that = this;
						if($("#preview-window").data("kendoWindow")){
							$("#preview-window").data("kendoWindow").destroy();
							$("body").append('<div id="preview-window"/>');
						}
						$("#preview-window").kendoWindow({
							position : {
								top: 50, right: 50
							},
							iframe: true,
							width: "80%",
							height: "80%",
							title: $that.page.title ,
							content: "<@spring.url '/display/'/>" + $that.page.name
						});
					},
					close:function(){
						renderTo.fadeOut(function(e){ 
							$("#my-site-web-page-list").fadeIn();
						});
					},
					saveOrUpdate : function(e){ 
						var $this = this;
						console.log( kendo.stringify( $this.page ) );
						common.ui.ajax(
							'<@spring.url "/secure/data/mgmt/website/page/update.json?output=json" />' , 
							{
								data : common.ui.stringify( $this.page ),
								contentType : "application/json",
								success : function(response){
									common.ui.notification().show({ title:null, message: "웹 페이지가 저장되었습니다."	},"success");	
									
								},
								fail: function(){								
									common.ui.notification().show({	title:null, message: "웹 페이지 저장중 오류가 발생되었습니다. 시스템 운영자에게 문의하여 주십시오."	},"warning");	
								},
								requestStart : function(){
									kendo.ui.progress(renderTo, true);
								},
								requestEnd : function(){
									kendo.ui.progress(renderTo, false);
								},
								complete : function(e){
									common.ui.grid( $('#my-site-web-page-grid') ).dataSource.read( 
										{ siteId: getSelectedSite().webSiteId } 
									);														
									$this.close();
								}
							}
						);	
						return false;					
					}	
				});	
				renderTo.data("model", observable);		
				common.ui.bind( renderTo, observable );
				
				collapseOptions.on('shown.bs.collapse', function () {
					$('#my-site-web-page-view-options-btn').text("고급설정 숨기기 .. ");
				});
				collapseOptions.on('hidden.bs.collapse', function () {
					$('#my-site-web-page-view-options-btn').text("고급설정 보기 .. ");
				});				
			}
			
			renderTo.data("model").setSource( source );	
			if (!renderTo.is(":visible")) 
				renderTo.fadeIn(); 	
		}

		<!-- ============================== -->
		<!-- TEMPLATE, MENU FINDER MODAL    -->
		<!-- ============================== -->
		function createTemplateFinderModal(){		
			var renderTo= $("#my-template-finder-modal");
			var treeRenderTo = renderTo.find(".template-tree");
			if( !common.ui.exists( treeRenderTo ) ){				
				var treeview = treeRenderTo.kendoTreeView({
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
				}).data('kendoTreeView');	
				renderTo.find("[data-action=select]").click(function(e){
					var selectedCells = treeview.select();			
					var selectedCell = treeview.dataItem( selectedCells );
					if( selectedCell.directory ){
						alert("파일을 선택하여 주십시오.");
						return;
					}else{
						$("#my-site-web-page-view").data('model').page.set("template", selectedCell.path) ;
					}		
					renderTo.modal('hide');				
				});				
			}			
			treeRenderTo.data("kendoTreeView").select($());
			renderTo.modal('show');	
		}


		function createMenuFinderModal(observable){		
			var renderTo= $("#my-menu-finder-modal");
			var treeRenderTo = renderTo.find(".menu-tree");
			if( !common.ui.exists( treeRenderTo ) ){				
				var treeview = treeRenderTo.kendoTreeView({
					dataSource: new kendo.data.HierarchicalDataSource({						
						transport: {
							read: {
								url : '<@spring.url "/secure/data/mgmt/website/navigator/items/list.json?output=json"/>',
								dataType: "json"
							},
							parameterMap: function (options, type){
								options.siteId = getSelectedSite().webSiteId ;
								if( options.name )
								{
									var item = treeview.dataSource.get( options.name );
									return {siteId: options.siteId, menu:item.menu, item:item.name, progenitor: item.progenitor  };
								}else{
									return {siteId: options.siteId};
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
					template: kendo.template($("#treeview-template").html()),
					dataTextField: "name",
					change: function(e) {				
					}
				}).data('kendoTreeView');	
				renderTo.find("[data-action=select]").click(function(e){
					var selectedCells = treeview.select();			
					var selectedCell = treeview.dataItem( selectedCells );
					if(  selectedCell.progenitor  ){
						alert("메뉴 아이템을 선택하여 주십시오.");
						return;
					}else{						
						observable.page.properties["page.menu.name"] = item.menu ;
						observable.page.properties["navigator.selected.name"] = item.name ;
					}		
					renderTo.modal('hide');				
				});				
			}			
			treeRenderTo.data("kendoTreeView").select($());
			renderTo.modal('show');	
		}

		<!-- ============================== -->
		<!-- TEMPLATE EDITOR		        -->
		<!-- ============================== -->		
		function createTemplateEditor(source){	
			var renderTo = 	$('#ftl-code-editor');
			if(!common.ui.exists(renderTo)){
				console.log("creating ftl code editor");
				common.ui.editor.ace( $('#template-code-editor') , {
					'mode' : "ace/mode/ftl",
					'change' : function(e){
						editor.value( ace.value() );
				    }
				});				
			}
			var ace = common.ui.editor.ace( $('#template-code-editor') );
			ace.title(source.page.template||"");			
			ace.value( source.get("fileContent")  );
			if( !source.get("fileContent") && source.page.template  ){
				common.ui.ajax(
				"<@spring.url "/secure/data/mgmt/template/get.json?output=json" />" , 
				{
					data : { path:  common.endsWith( source.page.template, ".ftl") ? source.page.template :  source.page.template + ".ftl" , customized: source.customized },
					success : function(response){
						source.set("fileContent", response.fileContent )
						ace.value( source.get("fileContent")  );	
					}
				}); 				
			}				
			ace.show();		
		}		

		
		function createTemplateSourceEditor(renderTo, data){
			if( renderTo.contents().length == 0 ){			
				var editor = ace.edit(renderTo.attr("id"));		
				editor.getSession().setMode("ace/mode/ftl");
				editor.getSession().setUseWrapMode(true);		
				
				ace.edit(renderTo.attr("id")).setValue( data.get("fileContent") );								
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
		}		
		
		<!-- ============================== -->
		<!-- Announcement					-->
		<!-- ============================== -->
		function createAnnouncementGrid(){
			var renderTo = $("#my-site-announcement-grid");
			if( !common.ui.exists(renderTo)){
				var now = new Date();
				var observable = new common.ui.observable({ 				
					announce : new common.ui.data.Announce(),
					startDate : new Date(now.getFullYear(), now.getMonth(), 1),
					endDate : now,
					startChange : function(e){
						var $that = this;
						$("#announcement-start-date").data("kendoDatePicker").max($that.endDate);
						$("#announcement-end-date").data("kendoDatePicker").min($that.startDate);	
						common.ui.grid( renderTo ).dataSource.read();					
					},
					selectedTarget : 'all',
					endChange:function(e){
						var $that = this;
						$("#announcement-start-date").data("kendoDatePicker").max($that.endDate);
						$("#announcement-end-date").data("kendoDatePicker").min($that.startDate);							
						common.ui.grid( renderTo ).dataSource.read();
					}					
				});	
							
				var grid = common.ui.grid( renderTo, {
					dataSource: {
						transport: { 
							read: { url:'<@spring.url "/secure/data/mgmt/site/announce/list.json"/>', type: 'POST', contentType : 'application/json'  },
							parameterMap: function (options, type){
								options.objectId = getSelectedSite().webSiteId ;
								options.data = { 'target': observable.selectedTarget };
								return common.ui.stringify( options );
							}
						},					
						schema: {
							total: "totalCount",
							data: "items",
							model: common.ui.data.Announce
						},
						batch: false,
						pageSize: 15,
						serverPaging: false,
						serverFiltering: false,
						serverSorting: false
					},
					toolbar: kendo.template('<div class="p-xs"><button class="btn btn-flat btn-labeled btn-outline btn-danger rounded" data-action="create" data-object-id="0"><span class="btn-label icon fa fa-plus"></span> 공지 추가 </button></div>'),
					columns: [
						{ field: "announceId", title: "ID", width:50,  filterable: false, sortable: false , headerAttributes: { "class": "table-header-cell", style: "text-align: center" }}, 
						{ field: "subject", title: "제목", width: 350, headerAttributes: { "class": "table-header-cell", style: "text-align: center"}},					
						{ field: "user.username", title: "작성자", width: 100, headerAttributes: { "class": "table-header-cell", style: "text-align: center" }, template:'<img width="25" height="25" class="img-circle no-margin" src="#: authorPhotoUrl() #" style="margin-right:10px;"> #if ( user.nameVisible ) {# #: user.name # #} else{ # #: user.username # #}#' },
						{ field: "startDate",  title: "시작일", width: 120,  format:"{0:yyyy.MM.dd HH:mm}", headerAttributes: { "class": "table-header-cell", style: "text-align: center" } },
						{ field: "endDate", title: "종료일", width: 120,  format:"{0:yyyy.MM.dd HH:mm}", headerAttributes: { "class": "table-header-cell", style: "text-align: center" } }, 
						{ title: "", width:80, template: '<button type="button" class="btn btn-xs btn-labeled btn-primary rounded btn-selectable" data-action="edit" data-object-id="#= announceId #"><span class="btn-label icon fa fa-pencil"></span> 변경</button>' }	
						
					],
					filterable: true,
					sortable: true,
					resizable: true,
					pageable: { refresh:true, pageSizes:false,  messages: { display: ' {1} / {2}' }  },
					selectable: 'row',
					height: '100%',
					change: function(e) {                    
										
					},
					dataBound: function(e){		
						
					}			
				} );					
				
				common.ui.bind($("#my-site-announcement-list"), observable );
				
				renderTo.on("click","[data-action=edit],[data-action=create]", function(e){	
					var $this = $(this);	
					var objectId = $this.data("object-id");		
					var newAnnounce ;
					if( objectId > 0){
						newAnnounce = common.ui.grid(renderTo).dataSource.get(objectId);
					}else{
						newAnnounce = new common.ui.data.Announce();
						newAnnounce.set("objectType", 30);
						newAnnounce.set("objectId", getSelectedSite().webSiteId);
						newAnnounce.set("properties", []);
					}					
					$('#my-site-announcement-list').fadeOut(function(e){ 
						createAnnouncementEditor( newAnnounce );
					});	
				});		
										
			}
		}
				
		function createAnnouncementEditor( source ){
			var renderTo = $("#my-site-announcement-view");
			var collapseOptions = $('#my-site-announcement-view-options');
			if(!renderTo.data("model")){
				var observable =  common.ui.observable({ 
					announce : new common.ui.data.Announce(),
					editable:false,
					propertyDataSource :new kendo.data.DataSource({
						batch: true,
						data : [],
						schema: {
                            model: common.ui.data.Property
                        }
					}),
					setSource : function(source){
						var $that = this;
						source.copy($that.announce);	
						$that.set("editable", $that.announce.announceId > 0 ? true : false );						
						$that.propertyDataSource.read();				
						$that.propertyDataSource.data($that.announce.properties);			
						collapseOptions.collapse('hide');	
					},
					saveOrUpdate: function(e){
						e.preventDefault();				
						var $this = this;
						
						/**
						if( $this.announce.subject.length == 0 || $this.announce.body.length == 0 ){
							common.ui.notification().show({	title:"공지 입력 오류", message: "제목 또는 본문을 입력하세요."	},"error");
							return false;	
						}
						if( $this.announce.startDate >= $this.announce.endDate  ){
							common.ui.notification().show({	title:"공지 기간 입력 오류", message: "시작일자가 종료일자보다 이후일 수 없습니다."	}, "error");		
							return false;
						}	
						common.ui.ajax(
							'<@spring.url "/secure/data/mgmt/site/announce/update.json"/>',
							{
								data : kendo.stringify( $this.announce ),
								contentType : "application/json",
								success : function(response){										
									common.ui.grid( $('#my-site-announcement-grid') ).dataSource.read();									
									$this.close();
								},
								fail: function(){								
									common.ui.notification().show({	title:"공지 저장 오류", message: "시스템 운영자에게 문의하여 주십시오."	},"error");	
								},
								requestStart : function(){
									kendo.ui.progress(renderTo, true);
								},
								requestEnd : function(){
									kendo.ui.progress(renderTo, false);
								}
						});	
						**/													
					},
					close:function(){
						renderTo.fadeOut(function(e){ 
							$('#my-site-announcement-list').fadeIn();
						});
					}
				});	
				
				
				renderTo.data("model", observable);		
				common.ui.bind( renderTo, observable );		
				
				
				var validator = renderTo.find("form").kendoValidator({
					errorTemplate: "<p class='text-danger text-normal'>#=message#</p>"
				}).data('kendoValidator');		
						
				var editor = $('#announcement-html-editor');	
				editor.kendoEditor({
					tools : [
					'bold', 
					'italic', 
					"underline",
		            "strikethrough",
		            
		            "justifyLeft",
		            "justifyCenter",
		            "justifyRight",
		            "justifyFull",
		            
					'insertUnorderedList', 
					'insertOrderedList',
					
					"createTable",
		            "addColumnLeft",
		            "addColumnRight",
		            "addRowAbove",
		            "addRowBelow",
		            "deleteRow",
		            "deleteColumn",
		            "foreColor",
		            "backColor",
		            {	
						name: "viewHtml",
						exec: function(e){
							var editor = $(this).data("kendoEditor");
							var ace = common.ui.editor.ace( $('#announcement-code-editor') , {
								'change' : function(e){
									editor.value( ace.value() );
								}
							});
							//ace.title("");
							ace.value( editor.value() );
							ace.show();
							return false;
						}
					}
					]
				});
						
				collapseOptions.on('shown.bs.collapse', function () {
					$('#my-site-announcement-view-options-btn').text("고급설정 숨기기 .. ");
				});
				collapseOptions.on('hidden.bs.collapse', function () {
					$('#my-site-announcement-view-options-btn').text("고급설정 보기 .. ");
				});	
			}
			renderTo.data("model").setSource( source );	
			if (!renderTo.is(":visible")) 
				renderTo.fadeIn(); 				
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
		    color: #787878;
		    background-color: #e5e5e5;
		    /* border-color: #34aadc; */	
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
		
		.k-grid .k-filtercell .k-button-icon {
			padding-bottom: 3px;
		}
		
		.k-treeview .k-state-selected
		{
			background : #F5F5F5;
			color: #585f69;
		}	
				
		
		.page-detail, .page-editor {
			position:relative;
		}
		
		.page-detail .icon-svg-btn, .page-editor .icon-svg-btn {
		    position: absolute;
		    top: 0;
		    right: 0;		
		}
		
		.ace_editor{
			min-height: 500px;			
		}
					
		.page-editor > .page-editor-title {
		    position: absolute;
		    top: 0;
		    left: 65px;
		    font-size: 1.2em;
		    line-height: 50px;		
		}					
		
		table.k-editor{
		    border-right: 0;
		    border-left: 0;
		    border-bottom: 0;		
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
							<li><a href="#my-site-announcement" data-toggle="tab" class="rounded-top">공지 & 이벤트</a></li>
						</ul>
						<div class="tab-content">
							<div class="tab-pane fade" id="my-site-page">
								<h4><small class="text-muted">웹 페이지을 쉽고 빠르게 생성하고 수정할 수 있습니다.</small></h4>								
								<div id="my-site-web-page-list" class="search-block-v2">
									<div class="container">
										<div class="col-md-6 col-md-offset-3">
											<!--<h2>웹페이지를 검색합니다.</h2>-->
											<div class="input-group input-group-lg">
												<input type="text" class="form-control" placeholder="이름으로 웹 페이지를 검색합니다.">
												<span class="input-group-btn">
													<button type="button" class="btn btn-lg"><i class="fa fa-search"></i></button>
												</span>
											</div>
										</div>
									</div>
									<div id="my-site-web-page-grid" class="no-border m-t-md"></div>
								</div>									
								<div id="my-site-web-page-view" style="display:none;">
									<div class="ibox page-editor" style="display:none;">
										<span class="x-close" style="position:relative;" data-bind="click:closeTemplateEditor"></span>
										<i class="icon-svg-btn no-padding icon-svg icon-svg-md basic-color-open-in-broswer" data-bind="click:openInBroswer" ></i>
										<div class="page-editor-title" ><span data-bind="text: page.template"></span></div>
										<div class="ibox-content no-padding">														
										 	<div id="template-source-editor"></div>										 
										 </div>
									</div>
									<div class="ibox page-detail">
										<span class="back" style="position:relative;" data-bind="click:close"></span>										
					                    <div class="ibox-content no-padding">					
											<!-- sky-form -->	
											<form action="#" class="sky-form">
												<fieldset class="bg-gray">						
													<section>
														<h2 class="label">파일명</h2>
														<label class="input">
															<input type="text" class="form-control" id="input-page-name" data-bind="value:page.name" placeholder="파일명을 입력하여 주세요.">
														</label>
													</section>
													<div class="row">
														<section class="col col-6">
															<h2 class="label">콘텐츠 타입</h2>
															<label class="input">
																<input type="text" class="form-control" id="input-page-contentType" data-bind="value:page.contentType">
															</label>
															<div class="note">콘텐츠 타입을 입력하세요. 예) text/html;charset=UTF-8</div>
														</section>
														<section class="col col-6">
															<h2 class="label">로케일</h2>
															<label class="input">																
																<input type="text" class="form-control" data-bind="value: page.locale">
															</label>
															
															<div class="note">로케일 코드 값을 입력하세요. 예) en, ko_KR.</div>
														</section>
													</div>		
													<div class="row">														
														<section class="col col-6">
															<h2 class="label">템플릿									
																<button type="button" class="btn btn-xs btn-labeled btn-primary rounded pull-right" data-bind="click:openTemplateEditor" >
																	<span class="btn-label icon fa fa-code"></span> 템플릿 소스 보기
																</button>									
															</h2>																
															<label class="input">
																<i class="icon-append fa fa-search" data-bind="click:openTemplateFinder"></i>
																<input type="text" placeholder="템플릿 파일을 검색합니다." data-bind="value: page.template">
															</label>
															<label class="checkbox"><input type="checkbox" name="checkbox-inline" data-bind="checked: page.customized" ><i></i>사용자정의 템플릿 사용</label>							
														</section>
														<section class="col col-6">
															
														</section>
													</div>								
												</fieldset>
												<fieldset>
													<section>
														<h2 class="label">타이틀</h2>
														<label class="input">
															<input type="text" class="form-control" data-bind="value:page.displayName" >
														</label>
													</section>						
													<section>
														<h2 class="label">페이지 요약</h2>
														<label class="textarea">
															<textarea rows="3" data-bind="value: page.description"></textarea>
														</label>
														<div class="note">간략하게 페이지를 기술하세요.</div>
													</section>
													<div class="row">
														<section class="col-sm-6">														
															<h2 class="label">페이지 사용 여부 (<span data-bind="text:page.enabled"></span>)</h2>
															<input type="checkbox" name="enabled-switcher" 
																data-class="switcher-primary" role="switcher" 
																data-bind="checked:page.enabled, events:{change:onChange}" >														
														</section>
													</div>
												</fieldset>		
												<fieldset class="bg-gray">	
													<div class="collapse" id="my-site-web-page-view-options">
													<section>
														  <h2 class="label">매뉴설정</h2>	
														  <div class="note m-b-md">검색 버튼을 클릭하여 관련 메뉴를 선택하여 주세요.</div>
														  <button type="button" class="btn btn-xs btn-labeled btn-primary rounded" data-bind="click:openMenuFinder" >
														  	<span class="btn-label icon fa fa-search"></span> 메뉴 검색 
														  </button>	
													</section>
													<section>	  													  
														  <h2 class="label">속성</h2>
														  <div class="note m-b-md">고급 사용자가 아니면 직접 수정하지 마세요.</div>
														  <div data-role="grid"
															class=""
														    data-scrollable="true"
														    data-editable="true"
														    data-toolbar="['create', 'cancel']"
														    data-columns="[{ 'field': 'name', 'width': 270 , 'title':'이름'},{ 'field': 'value', 'title':'값' },{ 'command': ['destroy'], 'title': '&nbsp;', 'width': '200px' }]"
														    data-bind="source:propertyDataSource, visible:editable"
														    style="min-height:300px"></div>																								
													</section>	
													</div>
													<a id="my-site-web-page-view-options-btn" class="btn btn-outline rounded" 
														role="button" 
														data-toggle="collapse" 
														href="#my-site-web-page-view-options" 
														aria-expanded="false" aria-controls="my-site-web-page-view-options"> 고급설정 보기 .. </a>
													<div class="text-right note padding-sm">													
														마지막 수정일 : <span data-bind="text:page.formattedModifiedDate"></span>
													</div>							
												</fieldset>												
												<footer class="text-right">
													<button type="submit" class="btn btn-flat btn-primary rounded" data-bind="click:saveOrUpdate">저 장</button>
													<button type="button" class="btn btn-flat btn-default btn-outline rounded" data-bind="click:close">취 소</button>
												</footer>
											</form>
											<!-- /.sky-form -->
				                        </div>
				                        
				                        <div class="ibox-footer">
				                            <span class="pull-right">
				                            </span>
				                        </div>
				                    </div>
								</div>
							</div><!-- /.tab-pane -->								
							<div class="tab-pane fade" id="my-site-announcement">
								<h4><small class="text-muted">공지 &amp; 이벤트을 작성하고 수정할 수 있습니다. </small></h4>								
								<div id="my-site-announcement-list" class="search-block-v2">
									
									<div class="btn-group btn-group-sm" data-toggle="buttons">
										<label class="btn btn-danger rounded-left active">
											<input type="radio" name="announce-source"  value="all" data-bind="checked: selectedTarget" ><i class="fa fa-user"></i> 전체
										</label>
										<label class="btn  btn-danger rounded-right">
											<input type="radio" name="announce-source"  value="active" data-bind="checked: selectedTarget" ><i class="fa fa-globe"></i> 진행중
										</label>
									</div>		
											
									<div id="my-site-announcement-grid" class="no-border m-t-md"></div>
								</div>	
								<div id="my-site-announcement-view" style="display:none;">
									<div class="ibox announcement-detail">
										<span class="back" style="position:relative;" data-bind="click:close"></span>
										<div class="ibox-content no-padding">					
											<!-- sky-form -->	
											<form class="sky-form">
												<fieldset class="bg-gray">
													<section>
														<h2 class="label">제목</h2>
														<label class="input">
															<input type="text" class="form-control" data-bind="value:announce.subject" 
																placeholder="제목" 
																required validationMessage="제목을 입력하세요." >
														</label>
													</section>		
													<section>
														<label class="label">공지 기간</label>
														<input data-role="datetimepicker" data-bind="value:announce.startDate" data-type="date" required="required" > ~ <input data-role="datetimepicker" data-bind="value:announce.endDate" data-type="date" data-greaterdate-field="announce.startDate" data-greaterdate-msg='종료일은 반듯이 시작일 이후이여야 합니다.' >
														<div class="note"><i class="fa fa-info"></i> 지정된 기간 동안만 이벤트 및 공지가 보여집니다.</div>
													</section>													
												</fieldset>		
																																		
														<textarea id="announcement-html-editor" 
									                      data-bind="value:announce.body"
									                      style="height: 400px;" >
									                      </textarea>
												
												<fieldset class="bg-gray">	
													<div class="collapse" id="my-site-announcement-view-options">
													<section>	  													  
														  <h2 class="label">속성</h2>
														  <div class="note m-b-md">고급 사용자가 아니면 직접 수정하지 마세요.</div>
														  <div data-role="grid"
															class=""
														    data-scrollable="true"
														    data-editable="true"
														    data-toolbar="['create', 'cancel']"
														    data-columns="[{ 'field': 'name', 'width': 270 , 'title':'이름'},{ 'field': 'value', 'title':'값' },{ 'command': ['destroy'], 'title': '&nbsp;', 'width': '200px' }]"
														    data-bind="source:propertyDataSource, visible:editable"
														    style="min-height:300px"></div>
														    																						
													</section>	
													</div>
													<a id="my-site-announcement-view-options-btn" class="btn btn-outline rounded" 
														role="button" 
														data-toggle="collapse" 
														href="#my-site-announcement-view-options" 
														aria-expanded="false" aria-controls="my-site-announcement-view-options"> 고급설정 보기 .. </a>
													<div class="text-right note padding-sm">													
														마지막 수정일 : <span data-bind="text: announce.formattedModifiedDate"></span>
													</div>							
												</fieldset>												
												<footer class="text-right">
													<button type="submit" class="btn btn-flat btn-primary rounded" data-bind="click:saveOrUpdate">저 장</button>
													<button type="button" class="btn btn-flat btn-default btn-outline rounded" data-bind="click:close">취 소</button>
												</footer>
											</form>
											<!-- /.sky-form -->
				                        </div>
				                        
				                        <div class="ibox-footer">
				                            <span class="pull-right">
				                            </span>
				                        </div>
				                    </div>
								</div>
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
		
		<div id="preview-window"></div>
		<div id="announcement-code-editor"></div>
		<div id="template-code-editor"></div>
		<div id="my-template-finder-modal" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="my-template-finder-modal-label">
			<div class="modal-dialog"  role="document">
				<div class="modal-content">
					<div class="modal-header">
						<button type="button" class="close" data-dismiss="modal" aria-hidden="true"></button>
						<h4 class="modal-title" id="my-template-finder-modal-label" >템플릿 파일을 선택합니다.</h4>
					</div>					
					<div class="modal-body">
						<div class="template-tree"></div>
					</div>
					<div class="modal-footer">					
						<button type="button" class="btn btn-primary btn-flat rounded" data-action="select" data-loading-text='<i class="fa fa-spinner fa-spin"></i>'> 선택</button>					
						<button type="button" class="btn btn-default btn-flat rounded" data-dismiss="modal">닫기</button>
					</div>					
				</div>
			</div>	
		</div>
		
		<div id="my-menu-finder-modal" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="my-menu-finder-modal-label">
			<div class="modal-dialog"  role="document">
				<div class="modal-content">
					<div class="modal-header">
						<button type="button" class="close" data-dismiss="modal" aria-hidden="true"></button>
						<h4 class="modal-title" id="my-menu-finder-modal-label" >메뉴를 선택합니다.</h4>
					</div>					
					<div class="modal-body">
						<div class="menu-tree"></div>
					</div>
					<div class="modal-footer">					
						<button type="button" class="btn btn-primary btn-flat rounded" data-action="select" data-loading-text='<i class="fa fa-spinner fa-spin"></i>'> 선택</button>					
						<button type="button" class="btn btn-default btn-flat rounded" data-dismiss="modal">닫기</button>
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
    </script>
    		
	<script id="webpage-title-template" type="text/x-kendo-template">
		#: title #</span>
		<div class="btn-group btn-group-xs pull-right">
			<a href="\\#" onclick="doPageEdit(); return false;" class="btn btn-info btn-sm">편집</a>
			<a href="\\#" onclick="doPageDelete(); return false;" class="btn btn-info btn-sm">삭제</a>
			<a href="\\#" onclick="doPagePreview(); return false;" class="btn btn-info btn-sm">미리보기</a>
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
					<button type="button" class="btn btn-primary btn-flat btn-sm rounded" data-action="select" data-loading-text='<i class="fa fa-spinner fa-spin"></i>'>선택</button>					
					<button type="button" class="btn btn-default btn-flat btn-sm rounded" data-dismiss="modal">닫기</button>
				</div>					
			</div>
		</div>
	</div>
	</script>	
			
	<script id="treeview-template" type="text/kendo-ui-template">
	#if(item.directory){#
		<i class="fa fa-folder-open-o"></i> 
	# }else{# 
		#if ( item.menu ) {#
		<i class="fa fa-bars" aria-hidden="true"></i>
		#}else{#
		<i class="fa fa-file-code-o"></i> 
		#}#		
	#}#
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
</html>fade