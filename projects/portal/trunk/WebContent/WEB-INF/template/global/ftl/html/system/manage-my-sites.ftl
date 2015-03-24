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
			'css!<@spring.url "/styles/font-awesome/4.2.0/font-awesome.min.css" />',
			'css!<@spring.url "/styles/common.plugins/animate.css" />',
			'css!<@spring.url "/styles/codrops/codrops.split-layout.css" />',
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
			'<@spring.url "/js/bootstrap/3.3.1/bootstrap.min.js" />',			
			'<@spring.url "/js/common.plugins/fastclick.js" />', 
			'<@spring.url "/js/common.plugins/jquery.slimscroll.min.js" />', 
			'<@spring.url "/js/common.admin/pixel.admin.min.js" />',
			'<@spring.url "/js/common/common.ui.core.js" />',							
			'<@spring.url "/js/common/common.ui.data.js" />',
			'<@spring.url "/js/common/common.ui.community.js" />',
			'<@spring.url "/js/common/common.ui.admin.js" />',	
			'<@spring.url "/js/ace/ace.js" />'			
			],
			complete: function() {
				var currentUser = new common.ui.data.User();
				var targetCompany = new common.ui.data.Company();	
				
				common.ui.admin.setup({					 
					authenticate : function(e){
						e.token.copy(currentUser);
						createMenuGrid();
					},
					change: function(e){
						e.data.copy(targetCompany);
					}
				});	
									
				// END SCRIPT
			}
		}]);		
		
		function createMenuGrid(){
			var renderTo = $("#company-site-grid");
			if(! common.ui.exists(renderTo) ){
				common.ui.grid(renderTo, {
					dataSource: {
						transport: { 
							read: { url:'/secure/data/mgmt/website/list.json?output=json', type:'post' }
						},						
						batch: false, 
						pageSize: 15,
						schema: {
							data: "items",
							total: "totalCount",
							model: common.ui.data.WebSite
						}
					},
					columns: [
						{ title: "사이트", field: "displayName"},
						{ title: "", width:80, template: '<button type="button" class="btn btn-xs btn-labeled btn-info  btn-selectable" data-action="update" data-object-id="#= webSiteId #"><span class="btn-label icon fa fa-pencil"></span> 변경</button>'}
					],
					toolbar: kendo.template('<div class="p-xs"><button class="btn btn-flat btn-labeled btn-outline btn-sm btn-danger" data-action="create" data-object-id="0"><span class="btn-label icon fa fa-plus"></span> 사이트 추가 </button><button class="btn btn-flat btn-sm btn-outline btn-info pull-right" data-action="refresh" >새로고침</button></div>'),
					/*pageable: { refresh:true, pageSizes:false,  messages: { display: ' {1} / {2}' }  },*/		
					resizable: true,
					editable : false,
					selectable : "row",
					scrollable: false,
					height: 300,
					change: function(e) {
					},
					dataBound: function(e) {
						if ($("#company-site-details").is(":visible")) 
							$("#company-site-details").fadeOut();			
					}
				});
				renderTo.find("button[data-action=refresh]").click(function(e){
					common.ui.grid(renderTo).dataSource.read();								
				});	
				$(document).on("click","[data-action=update],[data-action=create]", function(e){		
					var $this = $(this);		
					if( common.ui.defined($this.data("object-id")) ){
						//common.ui.grid(renderTo).clearSelection();
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
			var renderTo = $("#company-site-details");
			
			if( !renderTo.data("model")){									
				var  observable = kendo.observable({
					site : new common.ui.data.WebSite(),
					setSource : function(source){
						source.copy(this.site);
						ace.edit("xml-editor").setValue(this.site.menu.menuData);
						
						
					},
					update: function(e){
						var $this = this;
						var btn = $(e.target);		
						btn.button('loading');						
						$this.menu.menuData = ace.edit("xml-editor").getValue();						
						common.ui.ajax(
							'<@spring.url "/secure/data/mgmt/navigator/update.json?output=json" />' , 
							{
								data : kendo.stringify( $this.menu ),
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
									common.ui.grid(renderTo).dataSource.read();									
									btn.button('reset');
								}
							}
						);	
					}
				});	
												
				renderTo.data("model", observable );
				kendo.bind(renderTo, observable );					
				var editor = ace.edit("xml-editor");		
				editor.getSession().setMode("ace/mode/xml");
				editor.getSession().setUseWrapMode(false);				
				createEditorModeSwitcher(renderTo, editor );
				createSiteDetailsTabs(renderTo, observable);
			}			
			renderTo.data("model").setSource( source );			
			if (!renderTo.is(":visible")) 
				renderTo.fadeIn();	 			
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
					//createUserGroupGrid(detailRow.find(".groups"), data);
					break;	
				}	
			});		
			renderTo.find("ul.nav.nav-tabs a:first").tab('show');			
		}				
						
		function createSitePropertiesGrid(renderTo, data){
			if( ! renderTo.data("kendoGrid") ){
				renderTo.kendoGrid({
					dataSource: {
						transport: { 
							read: { url:'<@spring.url "/secure/data/mgmt/website/properties/list.json?output=json&siteId="/>' + data.webSiteId, type:'post' },
							create: { url:'<@spring.url "/secure/data/mgmt/website/properties/update.json?output=json&siteId="/>' + data.webSiteId , type:'post', contentType : "application/json" },
							update: { url:'<@spring.url "/secure/data/mgmt/website/properties/update.json?output=json&siteId="/>' + data.webSiteId, type:'post', contentType : "application/json"  },
							destroy: { url:'<@spring.url "/secure/data/mgmt/website/properties/delete.json?output=json&siteId="/>' + data.webSiteId, type:'post', contentType : "application/json" },
							parameterMap: function (options, operation){			
								if (operation !== "read" && options.models) {
									return kendo.stringify(options.models);
								}
							}
						},						
						batch: true, 
						schema: {
							model: common.ui.data.Property
						},
						error:common.ui.handleAjaxError
					},
					columns: [
						{ title: "속성", field: "name", width: 250 },
						{ title: "값",   field: "value" },
						{ command:  { name: "destroy", template:'<a href="\\#" class="btn btn-xs btn-labeled btn-danger k-grid-delete"><span class="btn-label icon fa fa-trash"></span> 삭제</a>' },  title: "&nbsp;", width: 80 }
					],
					editable : true,
					scrollable: true,
					filterable: true,
					sortable: true,
					height: 500,
					toolbar: kendo.template('<div class="p-xs"><div class="btn-group"><a href="\\#"class="btn btn-primary btn-sm btn-flat btn-outline k-grid-add">추가</a><a href="\\#"class="btn btn-primary btn-sm btn-flat btn-outline k-grid-save-changes">저장</a><a href="\\#"class="btn btn-primary btn-sm btn-flat btn-outline k-grid-cancel-changes">취소</a></div><button class="btn btn-info btn-sm btn-flat btn-outline m-l-sm pull-right" data-action="refresh">새로고침</button></div>'),    
					change: function(e) {
					}
				});		
				renderTo.find("[data-action='refresh']").click( function(e){
					common.ui.grid(renderTo).dataSource.read();
				});	
			}
		}						
										
		-->
		</script> 		 
		<style>
		
		#xml-editor	 {
			height:550px;
			width:100%;
			border: solid 2px #666;
		}	

		.list-and-detail{
			margin: -18px -18px 18px -18px;
			font-size:13px;
		
		}
		
		.list-and-detail .list-and-detail-nav {
			border-color: #e2e2e2;
			background: #f6f6f6;
			border: 0 solid;
		}
		
		.list-and-detail .list-and-detail-nav, .list-and-detail .list-and-detail-contanier {
			float:none;
		}
		@media (min-width: 992px) {
			.list-and-detail .list-and-detail-nav {
				width: 400px;
				border-bottom: 0;
				position: relative;
				height: auto;
				border-right-width: 1px;		
				border-color: #e2e2e2;
				float: left;
			}

			.list-and-detail .list-and-detail-contanier {
				margin-left: 400px;
			}
		}
		
				
		
		.panel-body ul.nav.nav-tabs {
			height: 36px;
			right: 20px;
			position: absolute;
		}
		
		.panel-body .tab-content {
			border-top: 2px solid #e4e4e4;
			margin-top: 34px;
			padding-top: 20px;
		}
		
		#company-site-grid.k-grid {
			height:600px;
		}
		
		.tab-pane label {
			height:20px;
		}
		
		.properties .k-grid-toolbar {
			height:47px;
		}
		</style>
		</#compress>		
	</head>
	<body class="theme-default main-menu-animated">
		<div id="main-wrapper">
			<#include "/html/common/common-system-navigation.ftl" >	
			<div id="content-wrapper">
				<ul class="breadcrumb breadcrumb-page">
					<#assign selectedMenu = WebSiteUtils.getMenuComponent("SYSTEM_MENU", "MENU_2_4") />
					<li><a href="#">Home</a></li>
					<li><a href="${ selectedMenu.parent.page!"#" }">${selectedMenu.parent.title}</a></li>
					<li class="active"><a href="#">${selectedMenu.title}</a></li>
				</ul>			
				<div class="page-header bg-dark-gray">					
					<h1><#if selectedMenu.isSetIcon() ><i class="fa ${selectedMenu.icon} page-header-icon"></i></#if> ${selectedMenu.title}  <small><i class="fa fa-quote-left"></i> ${selectedMenu.description!""} <i class="fa fa-quote-right"></i></small></h1>
				</div><!-- / .page-header -->	
				
				<div class="list-and-detail">
					<div class="list-and-detail-nav p-xs">
						<div class="panel colourable">
							<div class="panel-heading">
								<span class="panel-title"><i class="fa fa-bars"></i></span>
							</div> <!-- / .panel-heading -->												
							<div id="company-site-grid" class="no-border"></div>
						</div>		
					</div>
					
					<div class="list-and-detail-contanier p-xs">									
						<div id="company-site-details" class="panel colourable" style="display:none;">	
							<div class="panel-heading">
								<span class="panel-title">&nbsp</span>
									<ul class="nav nav-tabs nav-tabs-xs">
										<li class=""><a href="#my-site-tabs-0" data-toggle="tab" data-action="company">기본정보</a></li>
										<li class=""><a href="#my-site-tabs-1" data-toggle="tab" data-action="logos">메뉴</a></li>
										<li class=""><a href="#my-site-tabs-2" data-toggle="tab" data-action="properties">속성</a></li>
									</ul>	
								</div>
							<div class="tab-content">
								<div class="tab-pane fade" id="my-site-tabs-0">
									<div class="form-group">
											<label class="control-label" for="input-site-name">코드</label>
											<input type="text" class="form-control input-sm" id="input-site-name" data-bind="value: site.name">
											<p class="help-block">중복되지 않는 코드 값을 입력하세요. 예) [회사 키]_[웹사이트 키]</p>
									</div>
										<div class="m-b-sm">
											<label class="control-label" for="input-site-title">이름</label>
											<input type="text" class="form-control input-sm" id="input-site-title" data-bind="value: site.displayName">
											<p class="help-block">사이트 이름을 입력하세요.</p>
										</div>	
										<div class="m-b-sm">
											<label class="control-label" for="input-site-url">도메인</label>
											<input type="text" class="form-control input-sm" id="input-site-url" data-bind="value: site.url">
											<p class="help-block">사이트 URL 을 입력하세요. 예) 192.168.0.1, www.demo.com</p>
										</div>											
										<div class="m-b-sm">
											<label class="control-label" for="input-site-description">설명</label>
											<input type="text" class="form-control imput-sm" id="input-site-description" data-bind="value: site.description">
											<p class="help-block">사이트에 대한 간략한 설명을 입력하세요.</p>
										</div>	
										<div class="p-sm">
												<input type="checkbox"id="checkbox-site-enabled"  class="k-checkbox" data-bind="checked: site.enabled">
												<label for="checkbox-site-enabled" class="k-checkbox-label">사용 여부</label>
										</div>			
										<hr/>							
										<ul class="list-unstyled margin-bottom-30">															
											<li class="p-xxs"><strong>생성일:</strong> <span data-bind="text: site.formattedCreationDate"></span></li>
											<li class="p-xxs"><strong>수정일:</strong> <span data-bind="text: site.formattedModifiedDate"></span></li>															
										</ul>
										<button class="btn btn-flat btn-outline btn-info pull-right" data-bind="events:{click:update}" data-loading-text="<i class='fa fa-spinner fa-spin'></i>">저장</button>	
																		
								</div>	
								<div class="tab-pane fade" id="my-site-tabs-1">
									<div class="p-xs">
										<h6 class="text-light-gray text-semibold">줄바꿈 설정/해지</h6>
										<input type="checkbox" name="warp-switcher" data-class="switcher-info" role="switcher" >									
										<div id="xml-editor"></div>	
									</div>									
								</div>	
								<div class="tab-pane fade" id="my-site-tabs-2">
									<div class="properties"></div>
								</div>																				
							</div>																				

							<!--
							
							
							<div class="panel-footer text-right">
								
							</div>-->
						</div>
					
					</div>
					
				</div><!-- / #list-and-detail -->	
			</div> <!-- / #content-wrapper -->
			<div id="main-menu-bg">
			</div>
		</div> <!-- / #main-wrapper -->
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