<#ftl encoding="UTF-8"/>
<html decorator="secure">
<head>
		<title>관리자 메인</title>		
		<link  rel="stylesheet" type="text/css"  href="${request.contextPath}/styles/common.admin/pixel/pixel.admin.style.css" />
		<script type="text/javascript">
		<!--		
		yepnope([{
			load: [
			'css!${request.contextPath}/styles/font-awesome/4.1.0/font-awesome.min.css',
			'css!${request.contextPath}/styles/common.plugins/animate.css',
			'css!${request.contextPath}/styles/jquery.jgrowl/jquery.jgrowl.min.css',
			'css!${request.contextPath}/styles/common.admin/pixel/pixel.admin.widgets.css',			
			'css!${request.contextPath}/styles/common.admin/pixel/pixel.admin.rtl.css',
			'css!${request.contextPath}/styles/common.admin/pixel/pixel.admin.themes.css',
			'css!${request.contextPath}/styles/common.admin/pixel/pixel.admin.pages.css',	
			
			'${request.contextPath}/js/jquery/1.10.2/jquery.min.js',
			'${request.contextPath}/js/kendo/kendo.web.min.js',
			'${request.contextPath}/js/kendo.extension/kendo.ko_KR.js',
			'${request.contextPath}/js/kendo/cultures/kendo.culture.ko-KR.min.js',
			'${request.contextPath}/js/jquery.jgrowl/jquery.jgrowl.min.js',			
			'${request.contextPath}/js/bootstrap/3.0.3/bootstrap.min.js',			
			'${request.contextPath}/js/common.plugins/fastclick.js', 
			'${request.contextPath}/js/common.plugins/jquery.slimscroll.min.js', 
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
				var targetCompany = new Company();	
				common.ui.admin.setup({
					authenticate : function(e){
						e.token.copy(currentUser);
					},
					companyChanged: function(item){
						item.copy(targetCompany);
					}
				});					
				
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
				// END SCRIPT
			}
		}]);		
		
		function createPathFinder(){		
			if( !$("#template-tree-view").data('kendoTreeView') ){		
				var finderDataSource = new kendo.data.HierarchicalDataSource({
					transport: { 
						read: { url:'${request.contextPath}/secure/list-template-files.do?output=json', type: 'POST' }
					},
					schema: {
						data: "targetFiles",					
						model: {
							id: "path",
							hasChildren: "directory"
						}
					},
					error: common.api.handleKendoAjaxError
				});			
				
				$("#template-tree-view").kendoTreeView({
					dataSource: {
						transport: { 
							read: { url:'${request.contextPath}/secure/list-template-files.do?output=json', type: 'POST' }
						},
						schema: {
							data: "targetFiles",					
							model: {
								id: "path",
								hasChildren: "directory"
							}
						},
						error: common.api.handleKendoAjaxError					
					},
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
					dataSource: {
						transport: { 
							read: { url:'${request.contextPath}/secure/list-template-files.do?output=json', type: 'POST' },
							parameterMap: function (options, operation){			
								options.customized = true;
								return options ;
							}							
						},
						schema: {
							data: "targetFiles",					
							model: {
								id: "path",
								hasChildren: "directory"
							}
						},
						error: common.api.handleKendoAjaxError					
					},
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
					file : new common.models.FileInfo(),
					content : "",
					supportCustomized : false,
					supportUpdate : false,
					supportSvn : true,
					openFileUpdateModal : function(){
						alert("준비중입니다");
						return false;
					},
					openFileCopyModal : function(){
						showFileCopyModal();
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
				common.api.callback(  
				{
					url :"${request.contextPath}/secure/view-template-content.do?output=json", 
					data : { path:  filePlaceHolder.path , customized: filePlaceHolder.customized },
					success : function(response){
						//renderTo.data("model").set("content", response.targetFileContent );					
						ace.edit("htmleditor").setValue( response.targetFileContent );	
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
									read: { type : "post", dataType:"json", url : '${request.contextPath}/secure/list-company.do?output=json' },	
								},
								schema: {
									total: "totalCompanyCount",
									data: "companies",
									model : Company
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
									read: { type : "post", dataType:"json", url : '${request.contextPath}/secure/list-site.do?output=json' },	
									parameterMap: function (options, operation){
									
										alert(kendo.stringify(options));
										return { "targetCompanyId" :  options.filter.filters[0].value }; 
									}									
								},
								schema: {
									total: "targetWebSiteCount",
									data: "targetWebSites",
									model : common.models.WebSite
								}
							}						
						}).data("kendoDropDownList");										
					}
				});
			}						
			renderTo.modal('show');
		}
		
							
		-->
		</script> 		 
		<style>
		#htmleditor.panel-body{
			min-height:500px;
		}
		#template-details .table > thead > tr > th {
			vertical-align: bottom;
			border-bottom: none;
		}
		#template-details .table > tbody > tr  {
			border-bottom: 1px solid #ddd;
		}		
		</style>
	</head>
	<body class="theme-default main-menu-animated">
		<div id="main-wrapper">
			<#include "/html/common/common-system-navigation.ftl" >	
			<div id="content-wrapper">
				<ul class="breadcrumb breadcrumb-page">
					<#assign selectedMenu = WebSiteUtils.getMenuComponent("SYSTEM_MENU", "MENU_1_3") />
					<li><a href="#">Home</a></li>
					<li><a href="${ selectedMenu.parent.page!"#" }">${selectedMenu.parent.title}</a></li>
					<li class="active"><a href="#">${selectedMenu.title}</a></li>
				</ul>			
				<div class="page-header bg-dark-gray">					
					<h1><#if selectedMenu.isSetIcon() ><i class="fa ${selectedMenu.icon} page-header-icon"></i></#if> ${selectedMenu.title}  <small><i class="fa fa-quote-left"></i> ${selectedMenu.description!""} <i class="fa fa-quote-right"></i></small></h1>
				</div><!-- / .page-header -->				
				<div class="row">			
					<div class="col-sm-4">
						<div class="panel colourable">
							<div class="panel-heading">
								<span class="panel-title">템플릿</span>
								<ul class="nav nav-tabs nav-tabs-xs" role="tablist" id="template-tabs">
									<li>
										<a href="#template-tree-view" role="tab" data-toggle="tab">기본</a>
									</li>
									<li>
										<a href="#custom-template-tree-view" role="tab" data-toggle="tab">커스텀</a>
									</li>
								</ul>			
							</div> <!-- / .panel-heading -->
							<div class="panel-body">
								<div class="tab-content">
									 <div class="tab-pane fade" id="template-tree-view"></div>
									 <div class="tab-pane fade" id="custom-template-tree-view"></div>
								</div>
							</div>
						</div>															
					</div>
					<div class="col-sm-8">				
						<div id="template-details" class="panel panel-primary">
							<div class="panel-heading">
								<span data-bind="text:file.name">&nbsp;</span>
								<div class="panel-heading-controls">
									<button class="btn btn-success  btn-xs" data-bind="visible: supportSvn, click:openFileUpdateModal" style="display:none;" ><i class="fa fa-long-arrow-down"></i> 업데이트</button>
									<button class="btn btn-danger  btn-xs" data-bind="visible: supportCustomized, click:openFileCopyModal" style="display:none;"><i class="fa fa-code"></i> 커스텀 템플릿 생성</button>
								</div>
							</div>			
							<div class="panel-body padding-sm">
							
								<span class="label label-warning">PATH</span>&nbsp;&nbsp;&nbsp;<span data-bind="text:file.path"></span>
								<div class="pull-right text-muted">
									<span data-bind="text:file.formattedSize"></span> bytes &nbsp;&nbsp;<span data-bind="text:file.formattedLastModifiedDate">&nbsp;</span>
								</div>
									
							</div>
							<div id="htmleditor" class="panel-body bordered no-border-hr" data-bind="invisible: file.directory" style="display:none;"></div>
							<div class="panel-footer no-padding-vr"></div>
						</div>					
					</div></!-- /.col-sm-12 -->
				</div><!-- /.row -->	
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
						<div class="alert alert-info alert-dark">
							<button type="button" class="close" data-dismiss="alert">×</button>
							<strong>주의!!</strong> 대상 위치에 커스텀 템플릿 파일이 존재하는 경우 덮어 쓰기 됩니다.
						</div>						
						<div class="form-group">
							<label class="control-label text-light-gray" for="file-copy-modal-input-source">소스</label>
							<input type="text" class="form-control" id="file-copy-modal-input-source" disabled data-bind="value: file.path">
						</div>
						<hr>					
						<div class="row">
							<div class="col-sm-6">
								<div class="form-group no-margin-hr">
									<label class="control-label text-light-gray" for="file-copy-modal-input-companies">회사</label>
									<input id="file-copy-modal-input-companies" />
								</div>
							</div>
							<div class="col-sm-6">
								<div class="form-group no-margin-hr">
									<label class="control-label text-light-gray" for="file-copy-modal-input-sites">사이트</label>
									<input id="file-copy-modal-input-sites" />		
								</div>
							</div>					
						</div>
						<p class="text-muted"><small><i class="fa fa-info"></i> 커스텀 템플릿을 생성할 회사의 웹 사이트를 선택하여 주세요 </small></p>
						
					</div>
					<div class="modal-footer">
						<button type="button" class="btn btn-default btn-flat" data-dismiss="modal">닫기</button>
						<button type="button" class="btn btn-primary">생성</button>
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