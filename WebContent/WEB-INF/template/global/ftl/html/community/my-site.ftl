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

			'css!<@spring.url "/styles/common.ui.plugins/switchery.min.css"/>',		
			'css!<@spring.url "/styles/common.ui/common.ui.color-icons.css"/>',			
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
					columns: [{ title: "페이지", field: "name", template : ' #:name # #if(enabled){# <i class="fa fa-toggle-on text-green" aria-hidden="true"></i> #}else{# <i class="fa fa-toggle-off" aria-hidden="true"></i> #}#'},
						{ title: "상태", width:40, headerAttributes:{ style:"text-align:center"}, attributes:{ class:"text-center" } , template: '#if(enabled){# <i class="fa fa-toggle-on text-green" aria-hidden="true"></i> #}else{# <i class="fa fa-toggle-off" aria-hidden="true"></i> #}#' },
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
						newWebPage.set("properties", {});
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
			var renderTo = $("#my-site-web-page-view");			
			if( renderTo.find(".page-editor").is(":visible") ){
				renderTo.find(".page-editor").fadeOut( function(e){			
					renderTo.find(".page-detail").fadeIn();
				});				
			}else{			
				createTemplateSourceEditor($("#template-source-editor"), source);
				renderTo.find(".page-detail").fadeOut( function(e){			
					renderTo.find(".page-editor").fadeIn();
				});				
			}	
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
		<!-- Page							-->
		<!-- ============================== -->
		
		<!-- ============================== -->
		<!-- Notice							-->
		<!-- ============================== -->
		function createAnnouncementGrid(){
			var renderTo = $("#my-site-announcement-grid");
			if( !common.ui.exists(renderTo)){
				var now = new Date();
				var observable = new common.ui.observable({ 
					announce : new common.ui.data.Announce(),
					startDate : new Date(now.getFullYear(), now.getMonth(), 1),
					endDate : now					
				});				
				var grid = common.ui.grid( renderTo, {
					dataSource: {
						transport: { 
							read: { url:'<@spring.url "/secure/data/mgmt/website/announce/list.json"/>', type: 'POST', contentType : 'application/json'  },
							parameterMap: function (options, type){
								options.objectId = getSelectedSite().webSiteId ;
								options.startDate = observable.startDate.toJSON();
								options.endDate = observable.endDate.toJSON();
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
						serverPaging: true,
						serverFiltering: true,
						serverSorting: true
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
										
					},
					dataBound: function(e){		
						
					}			
				} );					
				common.ui.bind($("#my-site-announcement-list"), observable );				
			}
		}
		
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
									<div id="my-site-web-page-grid" class="no-border"></div>
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
										<i class="icon-svg-btn no-padding icon-svg icon-svg-md basic-color-source-code" data-bind="click:openTemplateEditor" ></i>
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
															<h2 class="label">로케일
																<button type="button" class="btn btn-xs btn-labeled btn-success rounded pull-right disabled"><span class="btn-label icon fa fa fa-search"></span> 검색</button>
															</h2>
															<label class="input">
																<input type="text" class="form-control" id="input-page-locale" data-bind="value: page.locale">
															</label>
															<div class="note">로케일 코드 값을 입력하세요. 예) en, ko_KR.</div>
														</section>
													</div>		
													<div class="row">														
														<section class="col col-6">
															<h2 class="label">템플릿									
																<button type="button" class="btn btn-xs btn-labeled btn-success rounded pull-right" data-bind="click:openTemplateFinder" ><span class="btn-label icon fa fa-search"></span> 검색</button>									
															</h2>	
															<label class="input">
																<input type="text" class="form-control" id="input-page-template" data-bind="value: page.template">	
															</label>
															<label class="checkbox"><input type="checkbox" name="checkbox-inline" data-bind="checked: page.customized" ><i></i>사용자정의 템플릿 사용</label>							
														</section>
														<section class="col col-6"></section>
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
													<section>
														<h2 class="label">페이지 사용 여부</h2>
														<input type="checkbox" name="enabled-switcher" 
															data-class="switcher-primary" role="switcher" 
															data-bind="checked:page.enabled, events:{change:onChange}" >														
													</section>	
												</fieldset>		
												<fieldset>	
													<div class="collapse" id="my-site-web-page-view-options">
													<section>
														  <h2 class="label">매뉴설정</h2>	
														  <div class="note m-b-md">검색 버튼을 클릭하여 관련 메뉴를 선택하여 주세요.</div>
														  <button type="button" class="btn btn-xs btn-labeled btn-success rounded" data-bind="click:openMenuFinder" ><span class="btn-label icon fa fa-search"></span> 검색</button>	
													</section>
													<section>	  													  
														  <h2 class="label">속성</h2>
														  <div class="note m-b-md">고급 사용자가 아니면 직접 수정하지 마세요.</div>
														  <div data-role="grid"
															class="no-border"
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
													<button type="submit" class="btn btn-flat btn-primary" data-bind="click:saveOrUpdate">저 장</button>
													<button type="button" class="btn btn-flat btn-default btn-outline" data-bind="click:close">취 소</button>
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
									<div class="container">
										
										<div class="col-md-6 col-md-offset-3">
										<input data-role="datepicker" data-bind="value: startDate"/>		
									<input data-role="datepicker" data-bind="value: endDate"/>	
									
											<div class="input-group input-group-lg">
												<input type="text" class="form-control" placeholder="이름으로 웹 페이지를 검색합니다.">
												<span class="input-group-btn">
													<button type="button" class="btn btn-lg"><i class="fa fa-search"></i></button>
												</span>
											</div>
										</div>
									</div>
									<div id="my-site-announcement-grid" class="no-border"></div>
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
		<div id="preview-window"/>
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
						<button type="button" class="btn btn-primary btn-flat" data-action="select" data-loading-text='<i class="fa fa-spinner fa-spin"></i>'> 선택</button>					
						<button type="button" class="btn btn-default btn-flat" data-dismiss="modal">닫기</button>
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
						<button type="button" class="btn btn-primary btn-flat" data-action="select" data-loading-text='<i class="fa fa-spinner fa-spin"></i>'> 선택</button>					
						<button type="button" class="btn btn-default btn-flat" data-dismiss="modal">닫기</button>
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
					<button type="button" class="btn btn-primary btn-flat btn-sm" data-action="select" data-loading-text='<i class="fa fa-spinner fa-spin"></i>'>선택</button>					
					<button type="button" class="btn btn-default btn-flat btn-sm" data-dismiss="modal">닫기</button>
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