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
						
					}
				});	
				
				createRatingSchemeModal();
			}
		}]);		
		
		function createRatingSchemeModal(){
			var renderTo = $("#rating-scheme-modal");	
			if( !renderTo.data('bs.modal') ){		
				var companySelector = getCompanySelector();			
				var observable =  common.ui.observable({
					visible : false,
					refresh : function(){
						
						console.log("refresh..");
						var $this = this;
						
						$this.ratingSchemeDataSource.read();					
					},
					ratingSchemeDataSource : new kendo.data.DataSource({
						transport: { 
							read: { url:'/secure/data/mgmt/competency/assessment/rating-scheme/list.json?output=json', type:'post' },
							parameterMap: function (options, operation){
								if (operation !== "read") {
									return kendo.stringify(options);
								} 
								return {
									objectType: 1,
									objectId: companySelector.value() 
								};
							}
						},
						schema: {
							model: common.ui.data.competency.RatingScheme
						}					
					})
				});
				/*				
				var grid = common.ui.grid($("#rating-scheme-grid"), {
					dataSource: {
						transport: { 
							read: { url:'/secure/data/mgmt/competency/assessment/rating-scheme/list.json?output=json', type:'post' },
							parameterMap: function (options, operation){
								if (operation !== "read") {
									return kendo.stringify(options);
								} 
								return {
									objectId: 1,
									objectType: companySelector.value() 
								};
							}
						},
						schema: {
						}
					},
					columns: [
						{ title: "이름", field: "name"}
					],
					resizable: true,
					editable : false,
					selectable : "row",
					scrollable: true,
					height: 500,
					change: function(e) {
					 	var selectedCells = this.select();	
					 	if( selectedCells.length == 1){
	                    	var selectedCell = this.dataItem( selectedCells );	  	                    
	                    }   
					},
					dataBound: function(e) {

					}
				});
				*/							
				renderTo.data("model", observable);	
				kendo.bind(renderTo, observable );
			}	
				
			renderTo.data("model").ratingSchemeDataSource.fetch();	
		}
		
		
		function createAssessmentGrid(){
			var companySelector = getCompanySelector();							
		}

		function getClassifiedMajoritySelector(){
			var renderTo = $("#classified-majority-dorpdown-list");
			if( !renderTo.data('kendoDropDownList') ){
				renderTo.kendoDropDownList({
					optionLabel: "대분류",
					autoBind:false,
					dataTextField: 'name',	
					dataValueField: 'codeSetId',
					dataSource: {
						serverFiltering: false,
						transport: {
							read: {
								dataType: 'json',
								url: '/secure/data/mgmt/competency/codeset/list.json?output=json',
								type: 'POST'
							}
						},
						schema: { 
							model : common.ui.data.competency.CodeSet
						}
					}				
				});				
				getClassifiedMiddleSelector();
				getClassifiedMinoritySelector();
			}
			return renderTo.data('kendoDropDownList');
		}


		function getClassifiedMiddleSelector(){
			var renderTo = $("#classified-middle-dorpdown-list");
			if( !renderTo.data('kendoDropDownList') ){
				renderTo.kendoDropDownList({
					cascadeFrom: "classified-majority-dorpdown-list",
					optionLabel: "중분류",
					dataTextField: 'name',	
					dataValueField: 'codeSetId',
					dataSource: {
						serverFiltering:true,
						transport: {
							read: {
								dataType: 'json',
								url: '/secure/data/mgmt/competency/codeset/list.json?output=json',
								type: 'POST'
							},
							parameterMap: function (options, operation){
								return { "codeSetId" :  options.filter.filters[0].value }; 
							}
						},
						schema: { 
							model : common.ui.data.competency.CodeSet
						}
					}				
				});
			}
			return renderTo.data('kendoDropDownList');
		}

		function getClassifiedMinoritySelector(){
			var renderTo = $("#classified-minority-dorpdown-list");
			if( !renderTo.data('kendoDropDownList') ){
				renderTo.kendoDropDownList({
					cascadeFrom: "classified-middle-dorpdown-list",
					optionLabel: "소분류",
					dataTextField: 'name',	
					dataValueField: 'codeSetId',
					dataSource: {
						serverFiltering:true,
						transport: {
							read: {
								dataType: 'json',
								url: '/secure/data/mgmt/competency/codeset/list.json?output=json',
								type: 'POST'
							},
							parameterMap: function (options, operation){
								return { "codeSetId" :  options.filter.filters[0].value }; 
							}
						},
						schema: { 
							model : common.ui.data.competency.CodeSet
						}
					}				
				});
			}
			return renderTo.data('kendoDropDownList');
		}
				
		function getCompanySelector(){
			return common.ui.admin.setup().companySelector($("#company-dropdown-list"));	
		}
		
		function getJobGrid(){
			var renderTo = $("#job-grid");
			return common.ui.grid(renderTo);
		}	
			
		function createJobGrid(){
			var renderTo = $("#job-grid");
			if(! common.ui.exists(renderTo) ){				
				var companySelector = getCompanySelector();						
				common.ui.grid(renderTo, {
					autoBind:false,
					dataSource: {
						transport: { 
							read: { url:'/secure/data/mgmt/competency/job/list.json?output=json', type:'post' },
							parameterMap: function (options, operation){
								if (operation !== "read") {
									return kendo.stringify(options);
								} 
								//console.log( kendo.stringify(options) );
								return {
									companyId: companySelector.value(),
									classifiedMajorityId:getClassifiedMajoritySelector().value(),
									classifiedMiddleId:getClassifiedMiddleSelector().value(),
									classifiedMinorityId:getClassifiedMinoritySelector().value(), 
									startIndex:options.skip, 
									pageSize: options.pageSize 
								};
							}
						},						
						batch: false, 
						pageSize: 15,
						serverPaging: true,
						schema: {
							data: "items",
							total: "totalCount",
							model: common.ui.data.competency.Job
						}
					},
					columns: [
						{ title: "직무", field: "name"}
					],
					toolbar: kendo.template('<div class="p-xs"><button class="btn btn-flat btn-labeled btn-outline btn-danger" data-action="create" data-object-id="0"><span class="btn-label icon fa fa-plus"></span> 직무 추가 </button><button class="btn btn-flat btn-sm btn-outline btn-info pull-right" data-action="refresh" data-loading-text="<i class=\'fa fa-spinner fa-spin\'></i> 조회중 ...\'"> 검색 </button></div>'),
					pageable: { 
						refresh:true, 
						pageSizes:false,  
						buttonCount: 5,
						messages: { display: ' {1} / {2}' }  
					},		
					resizable: true,
					editable : false,					
					selectable : "row",
					scrollable: true,
					height: 500,
					change: function(e) {
					 	var selectedCells = this.select();	
					 	if( selectedCells.length == 1){
	                    	var selectedCell = this.dataItem( selectedCells );	  
	                    	createJobDetails(selectedCell);
	                    }   
					},
					dataBound: function(e) {
					}		
				});		

				renderTo.find("button[data-action=refresh]").click(function(e){
					common.ui.grid(renderTo).dataSource.read();								
				});	
				renderTo.find("button[data-action=create]").click(function(e){		
					getJobGrid().clearSelection();			
					createJobDetails(new common.ui.data.competency.Job());				
				});		
							
			}
		}  
		
				
		function createJobDetails( source ) {
			var renderTo = $("#job-details");
			if( !renderTo.data("model")){		
				var  observable = kendo.observable({
					visible : false,
					editable : false,
					deletable: false,
					updatable : false,					
					job: new common.ui.data.competency.Job(),
					classifiedMajorityDataSource: new kendo.data.DataSource({
						serverFiltering: false,
						transport: {
							read: {
								dataType: 'json',
								url: '/secure/data/mgmt/competency/codeset/list.json?output=json',
								type: 'POST'
							},
							parameterMap: function (options, operation){
								return { "codeSetId" :  1 }; 
							}
						},
						schema: { 
							model : common.ui.data.competency.CodeSet
						},
						error:common.ui.handleAjaxError
					}),	
					classifiedMiddleDataSource: new kendo.data.DataSource({
						serverFiltering: true,
						transport: {
							read: {
								dataType: 'json',
								url: '/secure/data/mgmt/competency/codeset/list.json?output=json',
								type: 'POST'
							},
							parameterMap: function (options, operation){
								return { "codeSetId" :  options.filter.filters[0].value }; 
							}
						},
						schema: { 
							model : common.ui.data.competency.CodeSet
						},
						error:common.ui.handleAjaxError
					}),		
					classifiedMinorityDataSource: new kendo.data.DataSource({
						serverFiltering: true,
						transport: {
							read: {
								dataType: 'json',
								url: '/secure/data/mgmt/competency/codeset/list.json?output=json',
								type: 'POST'
							},
							parameterMap: function (options, operation){
								return { "codeSetId" :  options.filter.filters[0].value }; 
							}
						},
						schema: { 
							model : common.ui.data.competency.CodeSet
						},
						error:common.ui.handleAjaxError
					}),							
					competencyDataSource : new kendo.data.DataSource({ 
						transport: {
							read: {
								dataType: 'json',
								url: '/secure/data/mgmt/competency/job/competencies/list.json?output=json',
								type: 'POST'
							}
						},
						schema: { 
							model : common.ui.data.competency.Competency
						},
						error:common.ui.handleAjaxError
					}), 			
					view : function(e){
						var $this = this;		
						if($this.job.jobId < 1){
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
						renderTo.find("input[name=competency-name]").focus();
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
							'<@spring.url "/secure/data/mgmt/competency/job/update.json?output=json" />' , 
							{
								data : kendo.stringify( $this.job ),
								contentType : "application/json",
								success : function(response){																											
									$this.setSource(new common.ui.data.competency.Job(response));								
									getJobGrid().dataSource.read();
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
						source.copy($this.job);	
						if($this.job.get("jobId") == 0)
						{
							$this.job.set("objectType", 1);
							$this.job.set("objectId", getCompanySelector().value() );
							$this.set("visible", false);
							$this.set("editable", true);
							$this.set("updatable", true);
							$this.set("deletable", false);	
							renderTo.find("input[name=job-name]").focus();
						}else{
							$this.set("visible", true);
							$this.set("editable", false);
							$this.set("updatable", false);
							$this.set("deletable", true);		
							$this.competencyDataSource.read({ jobId: $this.job.get('jobId') });		
							renderTo.find("ul.nav.nav-tabs a:first").tab('show')																		
						}
					}						
				});
				renderTo.data("model", observable );
				kendo.bind(renderTo, observable );	
			}
			if( source ){
				renderTo.data("model").setSource( source );	
				if (!renderTo.is(":visible")) 
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
		    background-color: #f5f5f5;		 
		    min-height: 770px;
		    height:100%;
		    width:100%;
		    position: static;
		    left:0px;		    
		    border-radius: 4px;
		}
		
		#content-wrapper section.layout:after, #content-wrapper section.layout:before{
			clear:both;
			-webkit-box-sizing:border-box;
			-moz-box-sizing:border-box;
			box-sizing:border-box;
			display:table;
		} 
		
		section.left, section.right, section.bottom {
			display:block;
		}
		
		section.left:after, section.right:after, section.left:before, section.right:before,  {
			-webkit-box-sizing:border-box;
			-moz-box-sizing:border-box;
			box-sizing:border-box;		
		}
		
		#content-wrapper section.left {
			width:400px;
			position: absolute;
			height:auto;
			min-height: 100%;			
			border-right: solid 1px #e2e2e2;
		}
		
		.left.fixed {
			position: fixed!important;
			right : 0 ;
			top : 0;
		}
		
		#content-wrapper section.right {
			margin-left:400px;
			height:100%;			
		}
		
		#content-wrapper section.left > .panel, #content-wrapper section.right > .panel{
			border-width:0;
			margin-bottom:0px;
    	}
    	
		#content-wrapper section.bottom{
			padding: 10px 15px;
			background-color: #f5f5f5;
			border-top: 1px solid #ddd;
			border-bottom-right-radius: 3px;
			border-bottom-left-radius: 3px
		}
		
		.essential-element {
			border-top : 0;
			border-top-left-radius:0;
			border-top-right-radius:0;
		}
		
		.no-shadow{
			-webkit-box-shadow: none;
			-moz-box-shadow: none;
			box-shadow: none;
		}
		
		.no-shadow .k-pager-wrap {
			border-bottom-width : 0;
			-webkit-box-shadow: none;
			-moz-box-shadow: none;
			box-shadow: none;
		}

		.no-top-radius {
			border-top : 0;
			border-top-left-radius:0;
			border-top-right-radius:0;
		}
				
		.modal-dialog .close  {
			position: absolute;
			top: 0;
			right: 10px;
			line-height: 50px;
			font-size: 40px;
			display: block;
			width: 50px;
			height: 50px;
			text-align: center;
			background: url(/images/common/grey-cross.png) no-repeat center;
			background-size: 25px;
			content: "";
			display: block;
			opacity: .5;
			z-index: 1047;
		}
		
		label.k-checkbox-label {
			display: inline;
			font-weight: normal;
		}
		
		</style>
	</head>
	<body class="theme-default main-menu-animated">
		<div id="main-wrapper">
			<#include "/html/common/common-system-navigation.ftl" >
			<div id="content-wrapper">
			
				<ul class="breadcrumb breadcrumb-page">
					<#assign selectedMenu = WebSiteUtils.getMenuComponent("SYSTEM_MENU", "MENU_3_4") />
					<li><a href="#">Home</a></li>
					<li><a href="${ selectedMenu.parent.page!"#" }">${selectedMenu.parent.title}</a></li>
					<li class="active"><a href="#">${selectedMenu.title}</a></li>
				</ul>			
				<div class="page-header bg-dark-gray">					
					<h1><#if selectedMenu.isSetIcon() ><i class="fa ${selectedMenu.icon} page-header-icon"></i></#if> ${selectedMenu.title}  <small><i class="fa fa-quote-left"></i> ${selectedMenu.description!""} <i class="fa fa-quote-right"></i></small></h1>
				</div><!-- / .page-header -->	
				
				<div class="row">				
					<div class="col-sm-12">	
						<div class="panel panel-transparent" style="min-height:300px;">
							<div class="panel-heading">
								<input id="company-dropdown-list" />
								<button type="button" class="pull-right btn btn-flat btn-info btn-outline btn-md" data-toggle="modal" data-target="#rating-scheme-modal">
								  척도관리
								</button>
							</div>
							<div class="panel-body padding-sm">
								
							</div>			
						</div>					
					</div>
				</div>	
				
				<section class="layout">
					<section class="left">							
						<div class="panel panel-transparent">
							<!--<div class="panel-heading">
								
							</div>-->
							<div class="panel-body">
								
								<hr/>
							 	<h5 class="text-primary"><strong>직무분류</strong></h5>
								<div class="m-b-xs">
									<input id="classified-majority-dorpdown-list" />
								</div>
								<div class="m-b-xs">
									<input id="classified-middle-dorpdown-list" />
								</div>
								<div class="m-b-xs">
									<input id="classified-minority-dorpdown-list" />
								</div>	
							</div>
							<div id="job-grid" class="no-border no-shadow"></div>
						</div>				
					</section>
					<section class="right">	
						<div id="job-details" class="panel panel-default" style="display:none;">
							<div class="panel-heading">
								<strong><span class="panel-title" data-bind="{text: job.name, visible:visible}"></span></strong>
								<input type="text" class="form-control input-sm" name="job-name" data-bind="{value: job.name, visible:editable}" placeholder="직무" />
							</div>					
							<div class="panel-body">	
										<table class="table table-striped">
											<thead>
												<tr>
													<th>대분류</th>
													<th>중분류</th>
													<th>소분류</th>
												</tr>
											</thead>
											<tbody>
												<tr>
													<td>
														<span data-bind="{ text:job.classification.classifiedMajorityName, visible:visible }" ></span>
														<input id="job-details-classified-majority-dorpdown-list"
															data-option-label="대분류"
															data-role="dropdownlist"
										                  	data-auto-bind="true"
										                   	data-text-field="name"
										                   	data-value-field="codeSetId"
										                   	data-bind="{value: job.classification.classifiedMajorityId, source: classifiedMajorityDataSource , visible:editable}" />														
													</td>
													<td>
														<span data-bind="{text: job.classification.classifiedMiddleName, visible:visible}" ></span>
														<input id="job-details-classified-middle-dorpdown-list" 
															data-option-label="중분류"
															data-role="dropdownlist"
															data-auto-bind="false"
										                   	data-cascade-from="job-details-classified-majority-dorpdown-list"
										                   	data-text-field="name"
										                   	data-value-field="codeSetId"
										                   	data-bind="{value: job.classification.classifiedMiddleId, source: classifiedMiddleDataSource, visible:editable }" />														
													</td>
													<td>
														<span data-bind="{text: job.classification.classifiedMinorityName, visible:visible}" ></span>
														<input 
															data-role="dropdownlist"
															data-option-label="소분류"
															data-auto-bind="false"
										                   	data-cascade-from="job-details-classified-middle-dorpdown-list"
										                   	data-text-field="name"
										                   	data-value-field="codeSetId"
										                   	data-bind="{value: job.classification.classifiedMinorityId, source: classifiedMinorityDataSource, visible:editable }" />														
													</td>
												</tr>
											</tbody>
									</table>	
								<p class="p-sm" data-bind="{text: job.description, visible:visible}"></p>								
								<textarea class="form-control" rows="4"  name="job-description"  data-bind="{value: job.description, visible:editable}" placeholder="직무 정의"></textarea>
								<div class="p-sm text-right">
									<button class="btn btn-primary btn-flat" data-bind="{ visible:visible, click:edit }">변경</button>
									<button class="btn btn-primary btn-flat btn-outline" data-bind="{ visible:updatable, click:saveOrUpdate }" style="display:none;">저장</button>								
									<button class="btn btn-default btn-flat btn-outline" data-bind="{visible:updatable, click:view }" style="display:none;">취소</button>								
									<button class="btn btn-danger btn-flat btn-outline disabled" data-bind="{visible:deletable, click:delete }" style="display:none;">삭제</button>
								</div>
							</div>
							<div class="panel-body">	
								<ul class="nav nav-tabs nav-tabs-xs">
									<li class="m-l-sm"><a href="#job-details-tabs-0" data-toggle="tab" data-action="elements">역량(능력단위)</a></li>
									<li><a href="#job-details-tabs-2" data-toggle="tab" data-action="variable-range">직업</a></li>
									<li><a href="#job-details-tabs-3" data-toggle="tab" data-action="assessment-guide">교과과정</a></li>
									<li><a href="#job-details-tabs-4" data-toggle="tab" data-action="key-competency">자격증</a></li>
								</ul>							
								<div class="tab-content">
									<div role="tabpanel" class="tab-pane fade" id="job-details-tabs-0">
										<div data-role="grid"
									                 date-scrollable="true"
									                 data-auto-bind="false"
									                 data-columns="[
									                 	{ 'field':'name' , 'title':'역량(능력단위)' },
									                    { 'field':'level' , 'title':'직무수준', 'width': 150 },
									                 ]"
									                 data-bind="source: competencyDataSource, visible: deletable"
									                 style="height: 500px"
									                 class="no-top-radius"></div>	
									</div>
									<div role="tabpanel" class="tab-pane fade" id="job-details-tabs-2">
									</div>
									<div role="tabpanel" class="tab-pane fade" id="job-details-tabs-3">
									</div>	
									<div role="tabpanel" class="tab-pane fade" id="job-details-tabs-4">
									</div>																
								</div>	             						                   					
							</div>
						</div>
					</section>
				</section><!-- / .layout -->
			</div> <!-- / #content-wrapper -->
			<div id="main-menu-bg">
			</div>
		</div> <!-- / #main-wrapper -->
		
		<div id="rating-scheme-modal" role="dialog" class="modal fade" data-backdrop="static" data-effect="zoom">
			<div class="modal-dialog modal-lg">
				<div class="modal-content">	
					<div class="modal-header">
						<h3 class="modal-title">척도</h2>
						<button aria-hidden="true" data-dismiss="modal" class="close" type="button"></button>
					</div>
					<div class="modal-body no-padding">
						<div class="row">
							<div class="col-xs-4">
								<div class="p-xxs bg-gray">
									<button class="btn btn-flat btn-labeled btn-outline btn-danger" data-action="create" data-object-id="0"><span class="btn-label icon fa fa-plus"></span>진단척도 추가 </button>
									<button class="btn btn-flat btn-sm btn-outline btn-default pull-right" data-bind="refresh" data-loading-text="<i class=\'fa fa-spinner fa-spin\'></i> 조회중 ...\'"> 새로고침</button>
								</div>
								<div data-role="grid" class="no-border no-shadow"
									                 date-scrollable="true"
									                 data-auto-bind="false"
									                 data-autoBind="false"
									                 data-columns="[
									                 	{ 'field':'name' , 'title':'이름' }
									                 ]"
									                 data-bind="source: ratingSchemeDataSource"
									                 style="height: 600px"></div>
							</div>
							<div class="col-xs-8">sss</div>
						</div>
					</div>
					<div class="modal-footer">
						<button type="button" class="btn btn-default btn-flat btn-outline" data-dismiss="modal">닫기</button>			
					</div>
				</div>
			</div>
		</div>			
		<#include "/html/common/common-system-templates.ftl" >			
	</body>    
</html>