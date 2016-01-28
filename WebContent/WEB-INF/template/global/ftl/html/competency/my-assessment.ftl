<#ftl encoding="UTF-8"/>
<html decorator="unify">
	<head>
		<#assign page = action.getPage() >		
		<title>${page.title}</title>
		<#compress>		
		<script type="text/javascript">
		<!--
		var jobs = [];	
				
		yepnope([{
			load: [
			'css!<@spring.url "/styles/font-awesome/4.3.0/font-awesome.min.css"/>',
			'css!<@spring.url "/styles/bootstrap.themes/unify/colors/blue.css"/>',	
			'css!<@spring.url "/styles/bootstrap.common/color-icons.css"/>',	
			'css!<@spring.url "/styles/common.pages/common.personalized.css"/>',
			'css!<@spring.url "/styles/jquery.magnific-popup/magnific-popup.css"/>',	
			'css!<@spring.url "/styles/common/common.flat-icons.css"/>',	
			'css!<@spring.url "/styles/hover-effect/hover-min.css"/>',
			'css!<@spring.url "/styles/bootstrap.themes/common/common.ui.inspinia.css"/>',
			'css!<@spring.url "/styles/bootstrap.themes/common/common.ui.buttons.css"/>',	
			'<@spring.url "/js/jquery/1.10.2/jquery.min.js"/>',
			'<@spring.url "/js/jgrowl/jquery.jgrowl.min.js"/>',
			'<@spring.url "/js/kendo/kendo.web.min.js"/>',
			'<@spring.url "/js/kendo.extension/kendo.ko_KR.js"/>',			
			'<@spring.url "/js/kendo/cultures/kendo.culture.ko-KR.min.js"/>',			
			'<@spring.url "/js/bootstrap/3.3.4/bootstrap.min.js"/>',
			'<@spring.url "/js/common.plugins/jquery.slimscroll.min.js"/>', 	
			'<@spring.url "/js/common.plugins/switchery.min.js"/>',	
			'<@spring.url "/js/common.plugins/query.backstretch.min.js"/>', 		
			'<@spring.url "/js/jquery.magnific-popup/jquery.magnific-popup.min.js"/>',	
			'<@spring.url "/js/common/common.ui.core.js"/>',							
			'<@spring.url "/js/common/common.ui.data.js"/>',
			'<@spring.url "/js/common/common.ui.data.competency.js"/>',
			'<@spring.url "/js/common/common.ui.connect.js"/>',
			'<@spring.url "/js/common/common.ui.community.js"/>',
			'<@spring.url "/js/common.pages/common.personalized.js"/>'
			],			
			complete: function() {		
				
				common.ui.setup({
					features:{
						wallpaper : true,
						lightbox : true,
						spmenu : false,
						morphing : false,
						accounts : {
							authenticate : function(e){
								e.token.copy(currentUser);
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
				createMyAssessmentListView();
				// END SCRIPT 				
			}
		}]);			

		function createMyAssessmentListView(){
			var renderTo = $('#my-assessment-listview');	
			if( ! common.ui.exists(renderTo) ){
				var dataSource = common.ui.datasource( '<@spring.url "/data/me/competency/assessment/list.json?output=json"/>',{
					schema:{
						model: common.ui.data.competency.Assessment
					}
				});
				common.ui.listview(renderTo,{
              	  	dataSource: dataSource,
                	template: kendo.template($("#my-assessment-listview-template").html())
        	    });
        	    
        	    $(document).on("click","[data-action='apply']", function(e){						
					var btn = $(this) ;
					var objectId = btn.data('object-id');
					var item = dataSource.get(objectId);
					console.log( common.ui.stringify(item) );
					createApplyAssessmentModal(item);
					
				});
			}
		}
		
		function createApplyAssessmentModal(source){
			var renderTo = $("#apply-assessment-modal");	
			if( !renderTo.data('bs.modal') ){				
				var observable =  common.ui.observable({
					assessment : new common.ui.data.competency.Assessment(),
					jobDataSource : new kendo.data.DataSource({
						transport: { 
							read: { url:'<@spring.url "/data/me/competency/assessment/job/list.json?output=json'"/>, type:'post' },
							parameterMap: function (options, operation){
								if (operation !== "read") {
									return kendo.stringify(options);
								} 
								return {
									assessmentId: observable.assessment.assessmentId
								};
							}
						},			
						schema: {
							model: common.ui.data.competency.Job
						}
					}),
					setSource: function(source){
						var $this = this;
						source.copy($this.assessment);
						$this.jobDataSource.read();
					}
				});		
				renderTo.data("model", observable);	
				kendo.bind(renderTo, observable );		
			}
			if( source ){
				renderTo.data("model").setSource( source );		
			}
			renderTo.modal('show');
		}

		-->
		</script>		
		<style scoped="scoped">			
		/** Breadcrumbs */
		.breadcrumbs-v3 {
			position:relative;
		}

		.breadcrumbs-v3 p	{
			color : #fff;
			font-size: 24px;
			font-weight: 200;
			margin-bottom: 0;
		}	
		
		.breadcrumbs-v3.img-v1 {
			background: url( ${page.getProperty( "breadcrumbs.imageUrl", "")}) no-repeat;
			background-size: cover;
			background-position: center center;			
		}		
		
		
		
		#apply-assessment-modal .modal-content{
		    border-radius: 6px !important;
		}
		
		.team-v1 li:hover>.team-img:after {
			background: #fff;
		}
		.team-v1 li>.team-img {
		    min-height: 10px;
		}
		.team-v1 li>.team-img ul{
			text-align:right;
		} 
		
		.k-listview tr > td{
			vertical-align: middle;
		}
		
		</style>   	
		</#compress>
	</head>
	<body id="doc" class="bg-white">
		<div class="page-loader"></div>
		<div class="wrapper">
			<!-- START HEADER -->		
			<#include "/html/common/common-homepage-menu.ftl" >		
			<#if action.isSetNavigator()  >
			<#assign navigator = action.getNavigator() />		
			<div class="breadcrumbs-v3 img-v1 arrow-up no-border">
				<div class="personalized-controls container text-center p-xl">
					<p class="text-quote"> ${ navigator.description ? replace ("{displayName}" , action.webSite.company.displayName ) }	</p>
					<h1 class="text-xxl"><#if navigator.icon?? ><i class="icon-flat ${navigator.icon}"></i></#if> ${ navigator.title }</h1>					
					<a href="<@spring.url "/display/0/my-home.html"/>"><span class="btn-flat home t-0-r-2"></span></a>
					<a href="<@spring.url "/display/0/my-driver.html"/>"><span class="btn-flat folder t-0-r-1"></span></a>					
					<span class="btn-flat settings"></span>
					</div><!--/end container-->
			</div>
			</#if>
			<div class="footer-buttons-wrapper">
				<div class="footer-buttons">
					<button class="btn-link hvr-pulse-shrink" data-action="create" data-object-type="40"><i class="icon-flat microphone"></i></button>
					<button class="btn-link hvr-pulse-shrink"><i class="icon-flat icon-flat help"></i></button>
				</div>
			</div>				
			<!-- ./END HEADER -->			
			<!-- START MAIN CONTENT -->
			<div class="container content-md">
		        <ul class="list-unstyled row portfolio-box team-v1 no-border" id="my-assessment-listview">
		        </ul>
		    </div>
			<!-- ./END MAIN CONTENT -->	
	 		
	 		<!-- START FOOTER -->
			<#include "/html/common/common-homepage-globalfooter.ftl" >		
			<!-- ./END FOOTER -->					
		</div>				


		<!-- START MODAL -->		
		
	<div id="apply-assessment-modal" role="dialog" class="modal fade" data-backdrop="static" data-effect="zoom">
			<div class="modal-dialog modal-md modal-flat">
				<div class="modal-content">	
					<div class="modal-header">
						<h3 class="modal-title"><span data-bind="text:assessment.name"/> </h2>
						<button aria-hidden="true" data-dismiss="modal" class="close" type="button"></button>
					</div>
					<div class="modal-body">
						<div data-role="grid"
			                 data-editable="false"
			                 data-selectable="row"
			                 data-columns="[
			                                 { 'field': 'name', 'width': 270 , template: ' #:name#' },
			                                 { 'field': 'description' },
			                              ]"
			                 data-bind="source: jobDataSource"
			                 style="height: 300px"></div>
			                 
						<table class="table">
		                    <thead>
		                        <tr>
		                            <th>#</th>
		                            <th>First Name</th>
		                            <th class="hidden-sm">Last Name</th>
		                            <th>직무</th>
		                        </tr>
		                    </thead>
		                    <tbody>
							<div data-role="listview"
								data-selectable="row"
								data-auto-bind="false"	
			                 	data-template="my-assessment-job-template"
			                 	data-bind="source: jobDataSource"
			                	style="height: 300px; overflow: auto"></div>
			                </tbody>		                    
		                </table>
                
			                 



					</div>
					<div class="modal-footer">
						<button type="button" class="btn btn-primary btn-flat btn-outline rounded" data-bind="click:saveOrUpdate" >확인</button>		
						<button type="button" class="btn btn-default btn-flat btn-outline rounded" data-dismiss="modal">닫기</button>			
					</div>
				</div>
			</div>	
		</div>					

		
		<!-- END MODAL -->	
		
		
							
		<!-- START TEMPLATE -->									
		<script type="text/x-kendo-template" id="my-assessment-job-template">
		                        <tr>
		                            <td>1</td>
		                            <td>Mark</td>
		                            <td class="hidden-sm">Otto</td>
		                            <td><i class="icon-flat icon-svg icon-svg-md business-color-work"></i> #: name # </td>
		                            <td><span class="label label-warning">Expiring</span></td>
		                        </tr>			
		</script>
		<script type="text/x-kendo-template" id="my-assessment-listview-template">
		<li class="col-sm-6 col-md-4">
        	<div class="team-img">
        		<ul class="text-right">
                	<li><button class="btn btn-flat btn-primary btn-outline  rounded" data-action="apply" data-object-id="#:assessmentId#">참여하기</a></li>             
                	<li><a href="\\#" class="btn btn-flat btn-success btn-outline  rounded" data-object-id="#:assessmentId#">결과보기</a></li>                        
                </ul>   	
       		</div>
            <h3>#:name#</h3>
            <h4>#: formattedStartDate() # ~ #: formattedEndDate() #</h4>
            <p>#:description#</p>            
            <table class="table">
            	<thead>
                	<tr>
                    	<th>대분류</th>
                        <th>중분류</th>
                        <th>소분류</th>
                        <th>직무</th>
                    </tr>
                </thead>
                <tbody>
 				# for (var i = 0; i < jobSelections.length ; i++) { #	
	            # var jb = jobSelections[i] ; #	
	                <tr>
                    	<td>#if(jb.classifiedMajorityId > 0){# #:jb.classifiedMajorityName# #}#</td>
                    	<td>#if(jb.classifiedMiddleId > 0){# #:jb.classifiedMiddleName# #}#</td>
                    	<td>#if(jb.classifiedMiddleId > 0){# #:jb.classifiedMiddleName# #}#</td>
                    	<td>#if(jb.jobId > 0){# #:jb.jobName# #}#</td>
                   	</tr>
                # } #                
             	</tbody>
             </table>
        </li>	
	    </script>
	    
		<#include "/html/common/common-homepage-templates.ftl" >		
		<#include "/html/common/common-personalized-templates.ftl" >
		<#include "/html/common/common-editor-templates.ftl" >	
		<!-- ./END TEMPLATE -->
	</body>    
</html>