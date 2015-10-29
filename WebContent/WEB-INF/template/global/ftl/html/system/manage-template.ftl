<#ftl encoding="UTF-8"/>
<html decorator="secure">
<head>
		<title>관리자 메인</title>		
		<link  rel="stylesheet" type="text/css"	href="<@spring.url "/styles/common.admin/pixel/pixel.admin.style.css"/>" />
		<script type="text/javascript">
		<!--		
		yepnope([{
			load: [
			'css!<@spring.url "/styles/font-awesome/4.2.0/font-awesome.min.css"/>',
			'css!<@spring.url "/styles/common.plugins/animate.css"/>',
			'css!<@spring.url "/styles/jquery.jgrowl/jquery.jgrowl.min.css"/>',
			'css!<@spring.url "/styles/common.admin/pixel/pixel.admin.widgets.css"/>',			
			'css!<@spring.url "/styles/common.admin/pixel/pixel.admin.rtl.css"/>',
			'css!<@spring.url "/styles/common.admin/pixel/pixel.admin.themes.css"/>',
			'css!<@spring.url "/styles/common.admin/pixel/pixel.admin.pages.css"/>',				
			'<@spring.url "/js/jquery/1.10.2/jquery.min.js"/>',
			'<@spring.url "/js/kendo/kendo.web.min.js"/>',
			'<@spring.url "/js/kendo.extension/kendo.ko_KR.js"/>',
			'<@spring.url "/js/kendo/cultures/kendo.culture.ko-KR.min.js"/>',
			'<@spring.url "/js/jquery.jgrowl/jquery.jgrowl.min.js"/>',			
			'<@spring.url "/js/bootstrap/3.3.1/bootstrap.min.js"/>',			
			'<@spring.url "/js/common.plugins/fastclick.js"/>', 
			'<@spring.url "/js/common.plugins/jquery.slimscroll.min.js"/>', 
			'<@spring.url "/js/common.admin/pixel.admin.min.js"/>',
			'<@spring.url "/js/common/common.ui.core.js"/>',							
			'<@spring.url "/js/common/common.ui.data.js"/>',
			'<@spring.url "/js/common/common.ui.community.js"/>',
			'<@spring.url "/js/common/common.ui.admin.js"/>',	
			'<@spring.url "/js/ace/ace.js"/>'			
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
				createTemplateTab();
				// END SCRIPT
			}
		}]);		
		
		
		function createTemplateTab(){
			$('#template-tabs').on( 'show.bs.tab', function (e) {		
				var show_bs_tab = $(e.target);
				switch( show_bs_tab.attr('href') ){
					case "#template-tree-view" :
						createPathFinder();
						break;
					case  '#custom-template-tree-view' :
						createCustomPathFinder();
						break;
				}	
			});
			$('#template-tabs a:first').tab('show');				
		}
		
		function createPathFinder(){		
			if( !$("#template-tree-view").data('kendoTreeView') ){					
				$("#template-tree-view").kendoTreeView({
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
						}	
					}),
					template: kendo.template($("#treeview-template").html()),
					dataTextField: "name",
					change: function(e) {
						var filePlaceHolder = getSelectedTemplateFile($("#template-tree-view"));
						showTemplateDetails(filePlaceHolder);
					}
				});
			}
		}		

		function createCustomPathFinder(){		
			if( !$("#custom-template-tree-view").data('kendoTreeView') ){			
				$("#custom-template-tree-view").kendoTreeView({
					dataSource:  new kendo.data.HierarchicalDataSource({						
						transport: {
							read: {
								url : '<@spring.url "/secure/data/mgmt/template/list.json?output=json"/>',
								dataType: "json"
							},
							parameterMap: function (options, operation){			
								options.customized = true;
								return options ;
							}	
						},
						schema: {		
							model: {
								id: "path",
								hasChildren: "directory"
							}
						}
					}),				
					template: kendo.template($("#treeview-template").html()),
					dataTextField: "name",
					change: function(e) {
						var filePlaceHolder = getSelectedTemplateFile($("#custom-template-tree-view"));
						showTemplateDetails(filePlaceHolder);
					}
				});
			}
		}		
		
		function showTemplateDetails (filePlaceHolder){							
			var renderTo = $('#template-details');			
			if(!renderTo.data("model")){					
				var detailsModel = kendo.observable({
					file : new common.ui.data.FileInfo(),
					content : "",
					supportCustomized : false,
					supportUpdate : false,
					supportSvn : true,
					openFileUpdateModal : function(){
						alert("준비중입니다");
						return false;
					},
					openFileCopyModal : function(e){
						showFileCopyModal();
						return false;
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
				kendo.bind(renderTo, detailsModel );	
				renderTo.data("model", detailsModel );		
				var editor = ace.edit("htmleditor");		
				editor.getSession().setMode("ace/mode/ftl");
				editor.getSession().setUseWrapMode(true);					
			}
						
			renderTo.data("model").file.set("path", filePlaceHolder.path); 
			renderTo.data("model").file.set("customized", filePlaceHolder.customized); 
	    	renderTo.data("model").file.set("absolutePath", filePlaceHolder.absolutePath );
	    	renderTo.data("model").file.set("name", filePlaceHolder.name );
	    	renderTo.data("model").file.set("size", filePlaceHolder.size );
	    	renderTo.data("model").file.set("directory", filePlaceHolder.directory );
	    	renderTo.data("model").file.set("lastModifiedDate", filePlaceHolder.lastModifiedDate );		    	
	    	if( !filePlaceHolder.customized && !filePlaceHolder.directory ) 
	    	{
	    		renderTo.data("model").set("supportCustomized", true); 
	    	}else{
	    		renderTo.data("model").set("supportCustomized", false); 
	    	}
	    	
	    	if( filePlaceHolder.path.indexOf( ".svn" ) != -1 ) {
	    		renderTo.data("model").set("supportSvn", false); 
	    	}else{
	    		renderTo.data("model").set("supportSvn", true); 
	    	}  
	    	if(!filePlaceHolder.directory){
				common.ui.ajax(
				"<@spring.url "/secure/data/mgmt/template/get.json?output=json" />" , 
				{
					data : { path:  filePlaceHolder.path , customized: filePlaceHolder.customized },
					success : function(response){
						ace.edit("htmleditor").setValue( response.fileContent );	
					}
				}); 
	    	}
	    	
	    	if(!renderTo.is("visible")){
	    		renderTo.slideDown();
	    	}	    		
		}				
		
		function getSelectedTemplateFile( renderTo ){			
			var tree = renderTo.data('kendoTreeView');			
			var selectedCells = tree.select();			
			var selectedCell = tree.dataItem( selectedCells );   
			return selectedCell ;
		}
				
		function showFileCopyModal(){		
			var renderToString = "file-copy-modal";
			var renderTo = $( '#' + renderToString );
			if( renderTo.length === 0 ){	
				$("#main-wrapper").append( kendo.template($('#file-copy-modal-template').html()) );	
				renderTo = $('#' + renderToString );
				kendo.bind(renderTo, $('#template-details').data("model") );					
				renderTo.modal({
					backdrop: 'static'
				});					
				renderTo.on('show.bs.modal', function(e){	
					if( !$("#file-copy-modal-input-companies").data("kendoDropDownList") ){
						var companies = $("#file-copy-modal-input-companies").kendoDropDownList({
							optionLabel: "회사를 선택하세요...",
							dataTextField: "displayName",
							dataValueField: "companyId",
							dataSource : {
								transport : {
									read: { 
										type : "post", 
										dataType:"json", 
										url : '<@spring.url "/secure/data/mgmt/company/list.json?output=json"/>'
									}	
								},
								schema: {
									total: "totalCount",
									data: "companies",
									model : common.ui.data.Company
								}
							}
						});							
						var websites = $("#file-copy-modal-input-sites").kendoDropDownList({
							autoBind: false,
							cascadeFrom: "file-copy-modal-input-companies",
							optionLabel: "웹 사이트를 선택하세요.",
							dataTextField: "displayName",
							dataValueField: "webSiteId",							
							dataSource : {
								serverFiltering: true,
								transport : {
									read: { type : "post", dataType:"json", url : '<@spring.url "/secure/data/mgmt/website/list.json?output=json"/>' },	
									parameterMap: function (options, operation){
										return { "company" :  options.filter.filters[0].value }; 
									}									
								},
								schema: {
									total: "totalCount",
									data: "items",
									model : common.ui.data.WebSite
								}
							}						
						}).data("kendoDropDownList");										
					}					
					if( $("#file-copy-modal .tab-content").hasClass("has-error") ){
						$("#file-copy-modal .tab-content").removeClass("has-error");
					}
				});
				
				
			}						
			renderTo.modal('show');
		}
		
							
		-->
		</script> 		 
		<style>
		#htmleditor.panel-body{
			min-height:577px;
		}
		
		.k-treeview {
			min-height:338px;
		}
				
		#content-wrapper section.layout {
		    border: 1px solid #e2e2e2;
		    background-color: #f6f6f6;
		    min-height: 400px;
		    height: 100%;
		    position: relative;
		    border-radius: 4px;
		}
		
		#content-wrapper section.left {
			height:auto;
			min-height:100%; 
			/*border-right: solid 1px #e2e2e2; */
			position:absolute;
			width:400px;
		}
		#content-wrapper section.right {
			margin-left:401px; 
			min-height:100%;
			height:auto;
		}
		#content-wrapper section.left > .panel, #content-wrapper section.right > .panel{
			border-width:0;
			margin-bottom:0px;
    	}
    				
		</style>
	</head>
	<body class="theme-default main-menu-animated">
		<div id="main-wrapper">
			<#include "/html/common/common-system-navigation.ftl" >	
			<div id="content-wrapper">				
				<ul class="breadcrumb breadcrumb-page">
					<#assign selectedMenu = WebSiteUtils.getMenuComponent("SYSTEM_MENU", "MENU_1_3_2") />
					<li><a href="#">Home</a></li>
					<li><a href="${ selectedMenu.parent.page!"#" }">${selectedMenu.parent.title}</a></li>
					<li class="active"><a href="#">${selectedMenu.title}</a></li>
				</ul>			
				<div class="page-header bg-dark-gray">					
					<h1><#if selectedMenu.isSetIcon() ><i class="fa ${selectedMenu.icon} page-header-icon"></i></#if> ${selectedMenu.title}  <small><i class="fa fa-quote-left"></i> ${selectedMenu.description!""} <i class="fa fa-quote-right"></i></small></h1>
				</div><!-- / .page-header -->	
				<section class="layout">	
				<section class="left">
						<div class="panel panel-transparent">
							<div class="panel-heading">
								<span class="panel-title">템플릿</span>
								<ul class="nav nav-tabs nav-tabs-xs"  id="template-tabs">
									<li>
										<a href="#template-tree-view" role="tab" data-toggle="tab">기본</a>
									</li>
									<li>
										<a href="#custom-template-tree-view" role="tab" data-toggle="tab">커스텀</a>
									</li>
								</ul>			
							</div> <!-- / .panel-heading -->
							<div class="panel-body padding-sm bg-gray ">
								<div class="tab-content">
									<div class="tab-pane fade" id="template-tree-view"></div>
									<div class="tab-pane fade" id="custom-template-tree-view"></div>
								</div>	
							</div>
						</div>				
				</section>
					
				<section class="right">				
						<div id="template-details" class="panel" style="display:none;">
							<div class="panel-heading">
								<span data-bind="text:file.name">&nbsp;</span>
								<div class="panel-heading-controls">
									<button class="btn btn-success  btn-xs" data-bind="visible: supportSvn, click:openFileUpdateModal" style="display:none;" ><i class="fa fa-long-arrow-down"></i> 업데이트</button>
									<button class="btn btn-danger  btn-xs" data-bind="visible: supportCustomized, click:openFileCopyModal" style="display:none;"><i class="fa fa-code"></i> 커스텀 템플릿 만들기</button>
								</div>
							</div>			
							<div class="panel-body padding-sm" style="height: 43px;">							
								<span class="label label-warning">PATH</span>&nbsp;&nbsp;&nbsp;<span data-bind="text:file.path"></span>
								<div class="pull-right text-muted">
									<span data-bind="text:file.formattedSize"></span> bytes &nbsp;&nbsp;<span data-bind="text:file.formattedLastModifiedDate">&nbsp;</span>
								</div>									
							</div>
							<div id="htmleditor" class="panel-body bordered no-border-hr" data-bind="invisible: file.directory" style="display:none;"></div>
						</div>	
				</section>	
				</section>						
			</div> <!-- / #content-wrapper -->
			<div id="main-menu-bg">
			</div>
		</div> <!-- / #main-wrapper -->
		
		<script type="text/x-kendo-template" id="file-copy-modal-template">
		<div class="modal fade" id="file-copy-modal" tabindex="-1" role="dialog" aria-labelledby=".modal-title" aria-hidden="true">
			<div class="modal-dialog animated slideDown">
				<div class="modal-content">
					<div class="modal-header">
						<button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
						<h4 class="modal-title">커스텀 템플릿 파일 생성</h4>
					</div>
					<div class="modal-body">
						<p class="text-primary"><i class="fa fa-info"></i> 대상 위치에 커스텀 템플릿 파일이 존재하는 경우 덮어 쓰기 됩니다. 주의하여 주세요.</p>		
						<div class="form-group">
							<label class="control-label text-muted" for="file-copy-modal-input-source">소스</label>
							<input type="text" class="form-control" id="file-copy-modal-input-source" disabled data-bind="value: file.path">
						</div>
						<hr>				
						<ul class="nav nav-tabs nav-tabs-xs">
							<li class="active"><a href="\\#file-copy-modal-tabdrop-1" data-toggle="tab">웹사이트 선택</a></li>
							<li class=""><a href="\\#file-copy-modal-tabdrop-2" data-toggle="tab">직접 입력</a></li>							
						</ul>			
						<div class="tab-content has-error">
							<div class="tab-pane active" id="file-copy-modal-tabdrop-1">
								<div class="row">
									<div class="col-sm-6">
										<div class="form-group no-margin-hr">
											<label class="control-label" for="file-copy-modal-input-companies">회사</label>
											&nbsp;&nbsp;<input id="file-copy-modal-input-companies" />
										</div>
									</div>
									<div class="col-sm-6">
										<div class="form-group no-margin-hr">
											<label class="control-label" for="file-copy-modal-input-sites">사이트</label>
											&nbsp;&nbsp;<input id="file-copy-modal-input-sites" />		
										</div>
									</div>					
								</div>						
							</div>
							<div class="tab-pane" id="file-copy-modal-tabdrop-2">
								<div class="form-group">
									<label class="control-label" for="file-copy-modal-input-target">대상</label>
									<input type="text" class="form-control" id="file-copy-modal-input-target">
								</div>
							</div>
							<p class="help-block"><i class="fa fa-exclamation-triangle"></i> 커스텀 템플릿을 생성할 회사의 웹 사이트를 선택하거나, 직접 경로를 입력하여 주세요</p>
						</div>
					</div>
					<div class="modal-footer">
						<button type="button" class="btn btn-default btn-flat" data-dismiss="modal">닫기</button>
						<button type="button" class="btn btn-primary" data-bind="click:createCustomizedTemplate"  data-loading-text="<i class='fa fa-spinner fa-spin'></i>">  커스텀 템플릿 생성</button>
					</div>
				</div>
			</div>
		</div>				
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