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

			'css!<@spring.url "/styles/bootstrap.themes/common/common.ui.inspinia.css"/>',
					
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
						getAssessmentSchemeGrid().dataSource.read();
					}
				});					
				createAssessmentSchemeGrid();
			}
		}]);		
		
		function getAssessmentSchemeGrid(){
			var renderTo = $("#assessment-scheme-grid");
			return common.ui.grid(renderTo);
		}
		
		function createAssessmentSchemeGrid(){
			var renderTo = $("#assessment-scheme-grid");
			if(! common.ui.exists(renderTo) ){				
				var companySelector = getCompanySelector();						
				common.ui.grid(renderTo, {
					autoBind:false,
					dataSource: {
						transport: { 
							read: { url:'/secure/data/mgmt/competency/assessment-scheme/list.json?output=json', type:'post' },
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
							model: common.ui.data.competency.AssessmentScheme
						}
					},
					columns: [
						{ title: "역량진단체계", field: "name"}
					],
					toolbar: kendo.template('<div class="p-xs"><button class="btn btn-flat btn-labeled btn-outline btn-danger" data-action="create" data-object-id="0"><span class="btn-label icon fa fa-plus"></span> 역량진단체계 추가 </button><button class="btn btn-flat btn-outline btn-info pull-right" data-action="refresh" data-loading-text="<i class=\'fa fa-spinner fa-spin\'></i> 조회중 ...\'"> 새로고침 </button></div>'),
					resizable: true,
					editable : false,					
					selectable : "row",
					scrollable: true,
					height: 400,
					change: function(e) {
					 	var selectedCells = this.select();	
					 	if( selectedCells.length == 1){
	                    	var selectedCell = this.dataItem( selectedCells );	 
	                    	createAssessmentSchemeDetails(selectedCell);
	                    }   
					},
					dataBound: function(e) {
					}		
				});		

				renderTo.find("button[data-action=refresh]").click(function(e){
					common.ui.grid(renderTo).dataSource.read();								
				});	
				renderTo.find("button[data-action=create]").click(function(e){	
					createAssessmentSchemeDetails(new common.ui.data.competency.AssessmentScheme());			
				});		
							
			}					
		}
		
		function createAssessmentSchemeDetails(source){
			var renderTo = $("#assessment-scheme-details");
			if( !renderTo.data("model")){		
				var switcher = $('#multiple-apply-allowed-switcher').switcher({theme: 'square'});
				var observable =  common.ui.observable({
					visible : false,
					editable : false,
					deletable: false,
					updatable : false,				
					selectedRatingScheme : null,		
					assessmentScheme: new common.ui.data.competency.AssessmentScheme(),
					create : function(e){
						console.log("create..");
						var $this = this;
						$this.setSource(new common.ui.data.competency.AssessmentScheme());
						return false;
					},					
					view : function(e){
						var $this = this;		
						if($this.assessmentScheme.assessmentSchemeId < 1){
							$("#rating-scheme-details").hide();	
						}
						$this.set("visible", true);
						$this.set("editable", false);
						$this.set("updatable", false);
					},
					edit : function(e){
						var $this = this;
						$this.set("visible", false);
						$this.set("editable", true);
						$this.set("updatable", true);
						
						//$("#rating-scheme-dorpdown-list").data("kendoDorpDownList").readonly();
						
						return false;
					},
					ratingSchemeDataSource: new kendo.data.DataSource({
						serverFiltering: false,
						transport: {
							read: {
								dataType: 'json',
								url: '/secure/data/mgmt/competency/assessment/rating-scheme/list.json?output=json',
								type: 'POST'
							},
							parameterMap: function (options, operation){
								return { objectType:1, objectId:getCompanySelector().value() }; 
							}
						},
						schema: { 
							model : common.ui.data.competency.RatingScheme
						},
						error:common.ui.handleAjaxError
					}),	
					onRatingSchemeChange: function(e){			
						var $this = this;				
						console.log($this.selectedRatingScheme);
					},
					saveOrUpdate : function(e){
						var $this = this;						
						var btn = $(e.target);	
						if($this.assessmentScheme.get("ratingScheme"))
						{
							$this.assessmentScheme.ratingScheme.set('ratingSchemeId',$this.selectedRatingScheme );							
						}
						console.log(common.ui.stringify($this.assessmentScheme ));
						common.ui.progress(renderTo, true);
						common.ui.ajax(
							'<@spring.url "/secure/data/mgmt/competency/assessment-scheme/update.json?output=json" />' , 
							{
								data : kendo.stringify( $this.assessmentScheme ),
								contentType : "application/json",
								success : function(response){																	
									$this.setSource(new common.ui.data.competency.AssessmentScheme(response));	
									getAssessmentSchemeGrid().dataSource.read();
								},
								complete : function(e){
									common.ui.progress(renderTo, false);
								}
							}
						);								
						return false;
					},
					propertyDataSource :new kendo.data.DataSource({
						batch: true,
						data : [],
						schema: {
                            model: common.ui.data.Property
                        }
					}),
					setSource: function(source){
						var $this = this;
						source.copy($this.assessmentScheme);	
						$this.propertyDataSource.read();				
						$this.propertyDataSource.data($this.assessmentScheme.properties);	
						if($this.assessmentScheme.get("assessmentSchemeId") == 0)
						{
							$this.assessmentScheme.set("objectType", 1);
							$this.assessmentScheme.set("objectId", getCompanySelector().value() );
							$this.set("visible", false);
							$this.set("editable", true);
							$this.set("updatable", true);
							$this.set("deletable", false);
						}else{
							$this.set("visible", true);
							$this.set("editable", false);
							$this.set("updatable", false);
							$this.set("deletable", true);						
						}						
						
						if($this.assessmentScheme.multipleApplyAllowed) 
							$('#multiple-apply-allowed-switcher').switcher('on');
						else
							$('#multiple-apply-allowed-switcher').switcher('off');
								
						renderTo.find("ul.nav.nav-tabs a:first").tab('show');
					}
				});	
				
				renderTo.data("model", observable);	
				kendo.bind(renderTo, observable );	
			}			
			if( source ){
				renderTo.data("model").setSource( source );	
				if (!renderTo.is(":visible")) 
					renderTo.show();		
			}
		}
						
		function getCompanySelector(){
			return common.ui.admin.setup().companySelector($("#company-dropdown-list"));	
		}
				
		</script> 		 
		<style>
		#content-wrapper .layout {
		    border: 1px solid #e2e2e2;
		    background-color: #f5f5f5;		 
		    min-height: 770px;
		    height:100%;
		    position: static;	    
		    border-radius: 4px;
		}
		
		.layout .left{
			display:block;
			height: 100%;			
			border-right: solid 1px #e2e2e2;			
		}
		
		.no-shadow{
			-webkit-box-shadow: none;
			-moz-box-shadow: none;
			box-shadow: none;
		}
		
		input.k-checkbox+label {
		    font-weight: 100;
		    color: #555;
		    line-height: .875em;
    	}
			
		</style>
	</head>
	<body class="theme-default main-menu-animated">
		<div id="main-wrapper">
			<#include "/html/common/common-system-navigation.ftl" >
			<div id="content-wrapper">
			
				<ul class="breadcrumb breadcrumb-page">
					<#assign selectedMenu = WebSiteUtils.getMenuComponent("SYSTEM_MENU", "MENU_3_3_2") />
					<li><a href="#">Home</a></li>
					<li><a href="${ selectedMenu.parent.page!"#" }">${selectedMenu.parent.title}</a></li>
					<li class="active"><a href="#">${selectedMenu.title}</a></li>
				</ul>			
				<div class="page-header bg-dark-gray">					
					<h1><#if selectedMenu.isSetIcon() ><i class="fa ${selectedMenu.icon} page-header-icon"></i></#if> ${selectedMenu.title}  <small><i class="fa fa-quote-left"></i> ${selectedMenu.description!""} <i class="fa fa-quote-right"></i></small></h1>
				</div><!-- / .page-header -->	
				
				<div class="row animated fadeInRight">
	                <div class="col-md-4"> 
	                	<input id="company-dropdown-list" />
	                	<hr/>
						<div class="panel panel-default">
							<!--
							<div class="panel-heading">
								
							</div>
							-->	
							<div id="assessment-scheme-grid" class="no-border no-shadow"></div>	
						</div>
	                </div><!-- /.com-md-4 -->            
                	<div class="col-md-8">
                		<div id="assessment-scheme-details" class="panel animated fadeInRight" data-bind="attr: { data-editable: editable }" style="display:none;">
                			<!--<div class="panel-heading">
                    			
							</div>-->
							<div class="panel-body">
								<div class="form-horizontal">			
									<div class="row">
										<div class="col-sm-12">
											<div class="form-group no-margin-hr">	
												<span  data-bind="{text: assessmentScheme.name, visible:visible}"></span>
												<input type="text" class="form-control input-md" name="rating-scheme-name" data-bind="{value: assessmentScheme.name, visible:editable }" placeholder="이름" />
											</div>
											<div class="form-group no-margin-hr">				
												<span data-bind="{text: assessmentScheme.description, visible:visible}"></span>
												<textarea class="form-control" rows="4"  name="rating-scheme-description"  data-bind="{value: assessmentScheme.description, visible:editable}" placeholder="설명"></textarea>
											</div>
											<div class="no-margin-hr">											
												<table class="table">							
													<tbody>
														<tr>
															<td class="text-muted">진단척도</td>
															<td>
															<span data-bind="visible:visible, text:assessmentScheme.ratingScheme.name"></span>
															<input id="rating-scheme-dorpdown-list"
															data-option-label="선택"
															data-role="dropdownlist"
										                  	data-auto-bind="true"
										                  	data-value-primitive="true"
										                   	data-text-field="name"
										                   	data-value-field="ratingSchemeId"
										                   	data-bind="value:selectedRatingScheme, source: ratingSchemeDataSource, visible:editable,events:{change: onRatingSchemeChange}" />
															</td>
														</tr>
														<tr>
															<td class="text-muted">중복진단허용</td>
															<td>
															<input id="multiple-apply-allowed-switcher" type="checkbox" data-class="switcher-primary" data-bind="checked:assessmentScheme.multipleApplyAllowed, visible:editable">
															</td>
														</tr>
													</tbody>
												</table>            	
											</div>
										</div>
									</div>			
									<div class="row">
										<div class="col-sm-12">
											<ul id="rating-scheme-details-tabs" class="nav nav-tabs nav-tabs-xs">
												<li class="m-l-sm">
													<a href="#rating-scheme-details-tabs-1" data-toggle="tab">척도값</a>
												</li>
												<li class="">
													<a href="#rating-scheme-details-tabs-2" data-toggle="tab">속성</a>
												</li>
											</ul>
											<div class="tab-content no-padding">
												<div class="tab-pane fade" id="rating-scheme-details-tabs-1">												
													
													        
												</div> <!-- / .tab-pane -->
												<div class="tab-pane fade active in" id="rating-scheme-details-tabs-2">		
													<table class="table table-striped" data-bind="visible:visible">
														<thead>
															<tr>
																<th width="270">이름</th>
																<th>값</th>
															</tr>
														</thead>
														<tbody  class="no-border"
																data-role="listview"
												                data-template="property-view-template"
												                data-bind="source:propertyDataSource"
												                style="height: 200px; overflow: auto">
												            
												        </tbody>
													</table>																											
													<div data-role="grid"
														class="no-border"
													    data-scrollable="false"
													    data-editable="true"
													    data-toolbar="['create', 'cancel']"
													    data-columns="[{ 'field': 'name', 'width': 270 , 'title':'이름'},{ 'field': 'value', 'title':'값' },{ 'command': ['edit', 'destroy'], 'title': '&nbsp;', 'width': '200px' }]"
													    data-bind="source:propertyDataSource, visible:editable"
													    style="height: 300px"></div>
												</div> <!-- / .tab-pane -->							
											</div> <!-- / .tab-content -->
										</div><!-- / .col-sm-12 -->
									</div><!-- / .row -->	
                    			</div>
                    		</div>    
                    		<div class="panel-footer">
	 								<button class="btn btn-primary btn-flat" data-bind="{ visible:visible, click:edit }">변경</button>
									<button class="btn btn-primary btn-flat btn-outline" data-bind="{ visible:updatable, click:saveOrUpdate }" style="display:none;">저장</button>								
									<button class="btn btn-default btn-flat btn-outline" data-bind="{visible:updatable, click:view }" style="display:none;">취소</button>								
									<button class="btn btn-danger btn-flat btn-outline disabled" data-bind="{visible:deletable, click:delete }" style="display:none;">삭제</button>	                   		
                    		</div>
                		</div><!-- /.panel -->  
                	</div><!-- /.com-md-8 --> 
           		</div><!-- /.row --> 	
			</div> <!-- / #content-wrapper -->
			<div id="main-menu-bg">
			</div>
		</div> <!-- / #main-wrapper -->
			
		<script type="text/x-kendo-tmpl" id="rating-level-view-template">
		<tr>
			<td>#: score #</td>
			<td>#: title #</td>
		</tr>		
		</script>
		<script type="text/x-kendo-tmpl" id="property-view-template">
		<tr>
			<td>#: name #</td>
			<td>#: value #</td>
		</tr>	
		</script>											
		<#include "/html/common/common-system-templates.ftl" >			
	</body>    
</html>
