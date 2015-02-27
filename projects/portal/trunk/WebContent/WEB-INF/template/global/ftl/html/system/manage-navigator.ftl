<#ftl encoding="UTF-8"/>
<html decorator="secure">
<head>
		<title>관리자 메인</title>		
		<link  rel="stylesheet" type="text/css"  href="<@spring.url "/styles/common.admin/pixel/pixel.admin.style.css"/>" />
		<script type="text/javascript">
		<!--		
		yepnope([{
			load: [
			'css!<@spring.url "/styles/font-awesome/4.2.0/font-awesome.min.css" />',
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
					},
					change: function(e){
						e.data.copy(targetCompany);
					}
				});	
				
				
				$('#navigator-tabs').on( 'show.bs.tab', function (e) {		
					var show_bs_tab = $(e.target);
					switch( show_bs_tab.attr('href') ){
						case "#navigator-menu-view" :
							createMenuGrid();
							break;
					}	
				});
				
				$('#navigator-tabs a:first').tab('show');		
				// END SCRIPT
			}
		}]);		
		
		function createMenuGrid(){
			var renderTo = $("#navigator-menu-grid");
			if(! common.ui.exists(renderTo) ){
				common.ui.grid(renderTo, {
					dataSource: {
						transport: { 
							read: { url:'/secure/data/mgmt/navigator/list.json?output=json', type:'post' }
						},						
						batch: false, 
						pageSize: 15,
						schema: {
							data: "items",
							total: "totalCount",
							model: common.ui.data.Menu
						}
					},
					columns: [
						{ title: "Menu", field: "name"},
						{ title: "", width:80, template: '<button type="button" class="btn btn-xs btn-labeled btn-info" data-action="update" data-object-id="#=menuId#"><span class="btn-label icon fa fa-pencil"></span> 변경</button>'}
					],
					toolbar: kendo.template('<div class="p-xs"><button class="btn btn-flat btn-labeled btn-outline btn-sm btn-danger" data-action="create" data-object-id="0"><span class="btn-label icon fa fa-plus"></span> 메뉴 추가 </button><button class="btn btn-flat btn-sm btn-outline btn-info pull-right" data-action="refresh" data-loading-text="<i class=\'fa fa-spinner fa-spin\'></i> 조회중 ...\'"><span class="btn-label icon fa fa-bolt"></span> 새로고침</button></div>'),
					pageable: { refresh:true, pageSizes:false,  messages: { display: ' {1} / {2}' }  },		
					resizable: true,
					editable : false,
					selectable : "row",
					scrollable: true,
					height: 600,
					change: function(e) {
					},
					dataBound: function(e) {
						if ($("#navigator-menu-details").is(":visible")) 
							$("#navigator-menu-details").fadeOut();	 						
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
							openEditor(new common.ui.data.Menu())
						}
					}
				});			
			}	
		}
		
		function openEditor(source){
			var renderTo = $("#navigator-menu-details");			
			if( !renderTo.data("model")){									
				var  observable = kendo.observable({
					menu : new common.ui.data.Menu(),
					setSource : function(source){
						source.copy(this.menu);
						ace.edit("xml-editor").setValue(this.menu.menuData);
					},
					update: function(e){
						var $this = this;
						var btn = $(e.target);		
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
									//$this.refresh();
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
				
				var switcher = renderTo.find("input[name='warp-switcher']");				
				if( switcher.length > 0 ){
					$(switcher).switcher();
					$(switcher).change(function(){
						editor.getSession().setUseWrapMode($(this).is(":checked"));
					});		
				}					
				renderTo.find("ul.nav.nav-tabs a:first").tab('show');		
			}
			
			renderTo.data("model").setSource( source );
			
			if (!renderTo.is(":visible")) 
				renderTo.fadeIn();	 
			
		}				
						
										
		-->
		</script> 		 
		<style>
		
		#xml-editor	 {
			height:550px;
			width:100%;
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
		
		#navigator-menu-grid.k-grid {
			height:600px;
		}
		
		.tab-pane label {
			height:20px;
		}
	
		#navigator-menu-grid .k-grid .k-selectable td > .btn, .k-grid .k-selectable tr[aria-selected="false"] > td .btn, .k-grid .k-selectable td > a.btn, .k-grid .k-selectable tr[aria-selected="false"] > td a.btn{
			opacity: 0!important;
		}	
			
		</style>
	</head>
	<body class="theme-default main-menu-animated">
		<div id="main-wrapper">
			<#include "/html/common/common-system-navigation.ftl" >	
			<div id="content-wrapper">
				<ul class="breadcrumb breadcrumb-page">
					<#assign selectedMenu = WebSiteUtils.getMenuComponent("SYSTEM_MENU", "MENU_1_3_5") />
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
								<ul class="nav nav-tabs nav-tabs-xs" id="navigator-tabs" role="tablist">
									<li>
										<a href="#navigator-menu-view" data-toggle="tab">MENU</a>
									</li>
								</ul> <!-- / .nav -->
							</div> <!-- / .panel-heading -->												
							<div class="tab-content">
								<div class="tab-pane fade" id="navigator-menu-view">
									<div id="navigator-menu-grid" class="no-border-hr"></div>
								</div><!-- ./tab-pane -->
							</div><!-- /.tab-content -->
						</div>		
					</div>
					
					<div class="list-and-detail-contanier p-xs">									
						<div id="navigator-menu-details" class="panel colourable" style="display:none;">						
							<div class="panel-body">
								<ul class="nav nav-tabs nav-tabs-simple" style="height:36px;">		
									<li><a href="#bs-tabdrop-pill1" data-toggle="tab">기본정보</a></li>	
									<li><a href="#bs-tabdrop-pill2" data-toggle="tab">XML</a></li>
									<li><a href="#bs-tabdrop-pill3" data-toggle="tab">추가정보</a></li>								
								</ul>
								<div class="tab-content m-t-lg">
									<div class="tab-pane" id="bs-tabdrop-pill1">
										<div class="m-b-sm">
											<label class="control-label" for="input-menu-name">코드</label>
											<input type="text" class="form-control input-sm" id="input-menu-name" data-bind="value:menu.name">
											<p class="help-block">중복되지 않는 코드 값을 입력하세요. 예) [회사 이름]_[웹사이트 이름]_MENU</p>
										</div>
										<div class="m-b-sm">
											<label class="control-label" for="input-menu-title">이름</label>
											<input type="text" class="form-control input-sm" id="input-menu-title" data-bind="value:menu.title">
											<p class="help-block">이름을 입력하세요.</p>
										</div>	
										<div class="m-b-sm">
											<label class="control-label" for="input-menu-location">위치</label>
											<input type="text" class="form-control imput-sm" id="input-menu-location" data-bind="value:menu.location">
											<p class="help-block">메뉴 위치정보를 입력하세요.</p>
										</div>	
										<div class="checkbox" style="margin: 0;">
											<label>
												<input type="checkbox" value="" class="px" data-bind="checked: menu.enabled">
												<span class="lbl">사용 여부</span>
											</label>
										</div>			
										<hr/>							
														<ul class="list-unstyled margin-bottom-30">
															
															<li class="p-xxs"><strong>생성일:</strong> <span data-bind="text: menu.creationDate"></span></li>
															<li class="p-xxs"><strong>수정일:</strong> <span data-bind="text: menu.modifiedDate"></span></li>
															
														</ul>
										
									</div>
									<div class="tab-pane active" id="bs-tabdrop-pill2">
										<h6 class="text-light-gray text-semibold">줄바꿈 설정/해지</h6>
										<input type="checkbox" name="warp-switcher" data-class="switcher-info" role="switcher" >									
										<div id="xml-editor"></div>	
									</div>
									<div class="tab-pane" id="bs-tabdrop-pill3">
										<p>Howdy, I'm in Section 3.</p>
									</div>
								</div>

							</div>
							<!--
							
							-->
							<div class="panel-footer text-right">
								<button class="btn btn-flat btn-primary" data-bind="events:{click:update}" data-loading-text="<i class='fa fa-spinner fa-spin'></i>">저장</button>
							</div>
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