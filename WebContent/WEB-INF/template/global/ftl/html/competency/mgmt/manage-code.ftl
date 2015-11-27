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
			'<@spring.url "/js/kendo.extension/kendo.ko_KR.js"/>',
			'<@spring.url "/js/kendo/cultures/kendo.culture.ko-KR.min.js" />',
			'<@spring.url "/js/jquery.jgrowl/jquery.jgrowl.min.js" />',			
			'<@spring.url "/js/bootstrap/3.2.0/bootstrap.min.js" />',			
			'<@spring.url "/js/common.plugins/fastclick.js" />', 
			'<@spring.url "/js/common.plugins/jquery.slimscroll.min.js" />', 
			'<@spring.url "/js/common.admin/pixel.admin.min.js" />',
			'<@spring.url "/js/common/common.ui.core.js" />',							
			'<@spring.url "/js/common/common.ui.data.js" />',
			'<@spring.url "/js/common/common.ui.data.admin.js" />',
			'<@spring.url "/js/common/common.ui.data.competency.js" />',
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
						//e.data.copy(targetCompany);
						
						getCodeSetTreeList().dataSource.read();
					}
				});	
				createCodeSetTreeList();	
				createImportFileUpload();								
				// END SCRIPT
			}
		}]);		

		function getCompanySelector(){
			return common.ui.admin.setup().companySelector($("#company-dropdown-list"));	
		}
		
		function getCodeSetTreeList(){
			var renderTo = $("#codeset-treelist");
			return common.ui.treelist(renderTo);
		}
		
		function createCodeSetTreeList(){
			var renderTo = $("#codeset-treelist");			
			if( !renderTo.data('kendoTreeList') ){		
				var companySelector = getCompanySelector();		
				renderTo.kendoTreeList({
					height:"591",
					autoBind:false,
					dataSource: {
						transport: { 
							read: { url:'<@spring.url "/secure/data/mgmt/competency/codeset/list.json?output=json" />', type: 'POST'},
							parameterMap: function (options, operation){
								if (operation !== "read") {
									if( operation == "create" ){
										options.objectType = 1 ;
										options.objectId = getCompanySelector().value();
									}
									return kendo.stringify(options);
								} 
								return {companyId: getCompanySelector().value() };
							}
						},
						schema: {
							model:{
								id:'codeSetId',
								expanded: true,
								parentId: 'parentCodeSetId',
							    fields: {
							    	codeSetId: { type: "number"},
							    	parentCodeSetId : { field:"parentCodeSetId", nullable:true },
							    	objectType : { type: "number"},
							    	objectId : { type: "number"},
							    	description:  { type: "string" },
							    	name : { type: "string" },	        
							    	modifiedDate: { type: "date"},
							        creationDate: { type: "date" },
							    	enabled : {type: "boolean" }
							    }	
							}
						},				
						error: common.ui.handleAjaxError					
					},
					toolbar: kendo.template('<div class="p-xs"><button class="btn btn-flat btn-labeled btn-outline btn-danger" data-action="create" data-object-id="0"><span class="btn-label icon fa fa-plus"></span> 코드그룹 추가 </button><button class="btn btn-flat btn-outline btn-info pull-right" data-action="refresh" data-loading-text="<i class=\'fa fa-spinner fa-spin\'></i> 조회중 ...\'">새로고침</button></div>'),
					columns : [
						{field:'name', title:"이름"}	
					],
					selectable: true,
					change: function(e) {						
						var selectedRows = this.select();
						var dataItem = this.dataItem(selectedRows[0]);
						createCodeSetPanel( dataItem );
					}
				});							
				renderTo.find("button[data-action=create]").click(function(e){
					var codeset = new common.ui.data.competency.CodeSet();
					var selectedRows = getCodeSetTreeList().select();
					if( selectedRows.length > 0 ){
						var dataItem = getCodeSetTreeList().dataItem(selectedRows[0]);
						codeset.set("parentCodeSetId", dataItem.parentCodeSetId);
					} 
					createCodeSetPanel(codeset);
				});	
				renderTo.find("button[data-action=refresh]").click(function(e){
					getCodeSetTreeList().dataSource.read();
				});					
			}
		}
		
		
		function createImportFileUpload(){
			var renderTo = $("#import-excel-file");
			if( !common.ui.exists(renderTo)){
				renderTo.kendoUpload({
					multiple : false,
					width: 300,
				 	showFileList : false,
					localization:{ select : '파일 선택' , dropFilesHere : '업로드할 파일을 이곳에 끌어 놓으세요.' },
					async: {
						saveUrl:  '<@spring.url "/secure/data/mgmt/competency/codeset/import.json?output=json"/>',							   
						autoUpload: true
					},
					upload: function (e) {								         
						e.data = {
							codeSetId :  $("#import-top-codeset-id").val(),
							skipRowCount: $("#import-skip-row-count").val()
						};														    								    	 		    	 
					},
					success : function(e) {								    
					}
				});								
			}			
		}	

		function createCodeSetPanel(source){
			var renderTo = $("#codeset-details");
			if( !renderTo.data('model') ){
				var observable =  common.ui.observable({
					visible : false,
					editable : false,
					deletable: false,
					updatable : false,						
					codeset : new common.ui.data.competency.CodeSet(),
					view : function(e){
						var $this = this;		
						if($this.codeset.codeSetId < 1){
							renderTo.hide();	
						}
						$this.set("visible", true);
						$this.set("editable", false);
						$this.set("updatable", false);
						return false;
					},
					edit : function(e){
						var $this = this;					
						$this.set("visible", false);
						$this.set("editable", true);
						$this.set("updatable", true);
						renderTo.find("input[name=codeset-name]").focus();
						return false;
					},
					delete : function(e){
						var $this = this;
						return false;
					},
					saveOrUpdate : function(e){
						var $this = this;
						var btn = $(e.target);	
						common.ui.progress(renderTo, true);
						common.ui.ajax(
							'<@spring.url "/secure/data/mgmt/competency/codeset/update.json?output=json" />' , 
							{
								data : kendo.stringify( $this.codeset ),
								contentType : "application/json",
								success : function(response){																	
									$this.setSource(new common.ui.data.competency.CodeSet(response));				
									getCodeSetTreeList().dataSource.read();
								},
								complete : function(e){
									common.ui.progress(renderTo, false);
								}
							}
						);						
						return false;
					},	
					setSource : function(source){
						var $this = this;
						source.copy($this.codeset);				  
				    	if($this.codeset.get("codeSetId") == 0)
				    	{
				    		$this.codeset.set("objectType", 1);
							$this.codeset.set("objectId", getCompanySelector().value() );
							$this.set("visible", false);
							$this.set("editable", true);
							$this.set("updatable", true);
							$this.set("deletable", false);								
				    		renderTo.find("input[name=codeset-name]").focus();
				    	}else{
							$this.set("visible", true);
							$this.set("editable", false);
							$this.set("updatable", false);
							$this.set("deletable", true);				
						}
					}				
				});				
				renderTo.data("model", observable);			
				common.ui.bind( renderTo, observable );	
			}			
			
			
			if( source ){
				
				if( source instanceof common.ui.data.competency.CodeSet ){
					renderTo.data("model").setSource( source ) ;	
				}else{
					var newSource = new common.ui.data.competency.CodeSet(source) ;
					renderTo.data("model").setSource( newSource ) ;	
				}				
			}
			if(renderTo.is(":hidden")){				
				renderTo.show();
			}	
		}

		</script> 		 
		<style>
		#xmleditor.panel-body{
			min-height:577px;
		}	
		
		.k-treeview {
			min-height:338px;
		}
				
		#content-wrapper section.layout {
		    border: 1px solid #e2e2e2;
		    background-color: #f6f6f6;		 
		    min-height: 663px;
		    height:100%;
		    width:100%;
		    position: relative;
		    border-radius: 4px;
		}
		
		#content-wrapper section.left {
			height:100%;
			float: left;
			border-right: solid 1px #e2e2e2;
			position: relative;
			width:500px;
		}
		#content-wrapper section.right {
			/*margin-left:400px; */
			height:100%;
			overflow:hidden;
			position:relative;
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
					<#assign selectedMenu = WebSiteUtils.getMenuComponent("SYSTEM_MENU", "MENU_3_1") />
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
							<div class="panel-body"><input id="company-dropdown-list" /></div>
							<div id="codeset-treelist" class="no-border" />
						</div>
					</section>									
					<section class="right">
						<form>
							<div id="codeset-details" class="panel panel-default no-border no-margin-b" style="display:none;">
								<div class="panel-heading">
									<span class="panel-title" data-bind="{text:codeset.name, visible:visible}"></span>
									<input type="text" class="form-control input-sm" name="codeset-name" data-bind="{value:codeset.name, visible:editable }" placeholder="이름" />
								</div>
								<div class="panel-body no-padding-b">	
									<div class="m-b-sm">
										<span  data-bind="{text: codeset.code, visible:visible}"></span>
										<input type="text" class="form-control input-sm" name="codeset-code" data-bind="{value:codeset.code, visible:editable }" placeholder="코드 값" />
									</div>				
									<div class="m-b-sm">				
										<span data-bind="{text: codeset.description, visible:visible}"></span>
										<textarea class="form-control" rows="4"  name="codeset-description"  data-bind="{value: codeset.description, visible:editable}" placeholder="설명"></textarea>
									</div>
									<div class="p-sm text-right">

									</div>									
								</div>
								 <div class="panel-footer">								 
										<button class="btn btn-primary btn-flat" data-bind="{ visible:visible, click:edit }">변경</button>
										<button class="btn btn-primary btn-flat btn-outline" data-bind="{ visible:updatable, click:saveOrUpdate }" style="display:none;">저장</button>								
										<button class="btn btn-default btn-flat btn-outline" data-bind="{visible:updatable, click:view }" style="display:none;">취소</button>								
										<button class="btn btn-danger btn-flat btn-outline disabled" data-bind="{visible:deletable, click:delete }" style="display:none;">삭제</button>	
								 </div>
							</div>
						</form>
						<hr class="no-margin"/>
						<div class="panel panel-transparent">
							<div class="panel-heading">
								<h5 class="panel-title">엑셀 업로드</h5>
							</div>
							<div class="panel-body">	
								<table class="table table-striped">
									<thead>
										<tr>
											<th width="30%">CODESET ID</th>
											<th width="35%">SHEET INDEX</th>
											<th >ROW 건너뛰기</th>
										</tr>
									</thead>
									<tbody>
										<tr>
											<td><input id="import-top-codeset-id" type="number" min="1" class="form-control input-sm" placeholder="최상위 CODESET ID" value="1" /></td>
											<td><input id="import-top-sheet-index" type="number" min="0" class="form-control input-sm" placeholder="SHEET INDEX" value="0" /></td>
											<td><input id="import-skip-row-count" type="number" min="0" class="form-control input-sm" placeholder="ROW 건너뛰기" value="0" /></td>
										</tr>
									</tbody>
								</table>																						
								<input id="import-excel-file" name="import-excel-file" type="file">
							</div>
						</div>						
					</section>
				</section>
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
