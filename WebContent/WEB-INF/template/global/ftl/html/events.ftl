<#ftl encoding="UTF-8"/>
<html decorator="unify">
	<head>
		<#assign page = action.getPage() >
		<title>${page.title}</title>
		<script type="text/javascript">
		<!--
		
		var jobs = [];	
		
		yepnope([{
			load: [
			'css!<@spring.url "/styles/font-awesome/4.3.0/font-awesome.min.css"/>',
			'css!<@spring.url "/styles/bootstrap.themes/unify/colors/blue.css"/>',		
			'css!<@spring.url "/styles/bootstrap.themes/unify/pages/feature_timeline-v2.css"/>',		
			'css!<@spring.url "/styles/common/common.flat-icons.css"/>',		
			'<@spring.url "/js/jquery/1.10.2/jquery.min.js"/>',
			'<@spring.url "/js/jgrowl/jquery.jgrowl.min.js"/>',
			'<@spring.url "/js/kendo/kendo.web.min.js"/>',
			'<@spring.url "/js/kendo.extension/kendo.ko_KR.js"/>',			
			'<@spring.url "/js/kendo/cultures/kendo.culture.ko-KR.min.js"/>',		
			'<@spring.url "/js/bootstrap/3.2.0/bootstrap.min.js"/>',
			'<@spring.url "/js/common/common.ui.core.js"/>',							
			'<@spring.url "/js/common/common.ui.data.js"/>',
			'<@spring.url "/js/common/common.ui.community.js"/>'],
			complete: function() {			
				common.ui.setup({
					features:{
						wallpaper : false,
						lightbox : true,
						spmenu : false,
						morphing : false,
						accounts : {
							authenticate : function(e){
								e.token.copy(currentUser);
								if( !currentUser.anonymous ){		
															 
								}
							} 
						}						
					},
					jobs:jobs
				});	

				// ACCOUNTS LOAD	
				var currentUser = new common.ui.data.User();			
				common.ui.grid(	$("#announce-grid"), {
					dataSource : common.ui.datasource(
						'<@spring.url "/data/announce/list.json"/>',
						{
							pageSize: 15,
							schema: {
								data : "announces",
								model : common.ui.data.Announce,
								total : "totalCount"
							}
						}
					),
					columns: [
						{field: "subject", title: "제목", sortable : false },
						{field: "creationDate", title: "게시일", width: "120px", format: "{0:yyyy.MM.dd}"}
					],					
					rowTemplate: kendo.template($("#announce-row-template").html()),
					sortable: true,
					pageable: false,
					selectable: "single" ,
					height:400,
					change: function(e){						
						var selectedCells = this.select();
						var selectedCell = this.dataItem( selectedCells );	
						$("#announce-grid").data( "announcePlaceHolder", selectedCell );
						displayAnnouncement();
					}
				});
				<#if !action.user.anonymous >				
				
				</#if>	
				// END SCRIPT	
			}
		}]);	
		
		function displayAnnouncement () {		
			var announcePlaceHolder = $("#announce-grid").data( "announcePlaceHolder" );			
			var template = kendo.template($('#announce-view-panel-template').html());		
			$("#announce-view-panel").html( template(announcePlaceHolder) );
			kendo.bind($("#announce-view-panel"), announcePlaceHolder );
			$("#announce-view-panel").slideDown();
			$("#announce-view-panel").find(".close-sm").click(function (e) {
				$("#announce-view-panel").slideUp();
			});			
		}				
		-->
		</script>		
		<style scoped="scoped">
		
		blockquote p {
			font-size: 15px;
		}

		#announce-view-panel .k-grid-header .k-header {
			text-align: center;
		}
		
		#announce-view-panel .close-sm {
			top:10px;
		}
		
		#announce-view-panel hr {
			margin: 5px 0 4px;
		}
		#announce-grid.k-grid .k-state-selected {
			background: #F5F5F5;
			color: #585f69;
		}
									
		</style>   	
	</head>
	<body>
		<div class="page-loader"></div>	
		<!-- START HEADER -->
		
		<div class="wrapper">
			<!-- START HEADER -->
			<#include "/html/common/common-homepage-menu.ftl" >	
			<#if action.isSetNavigator()  >
				<#assign navigator = action.getNavigator() />			
				<header  class="cloud <#if navigator.parent.css??>${navigator.parent.css}</#if>">					
				<script>
					jobs.push(function () {
						$(".navbar-nav li[data-menu-item='${navigator.parent.name}']").addClass("active");
					});
				</script>			
				<div class="breadcrumbs arrow-up">
					<div class="container">
						<div class="row">
							<h2 class="pull-left">${ navigator.title }
							<small class="page-summary">
									${ navigator.description ? replace ("{displayName}" , action.webSite.company.displayName ) }								
							</small>	
							</h2>
						</div>
					</div>
				</div>	
			</header>	
			</#if>				
			<!-- END HEADER -->			
			<!-- START MAIN CONTENT -->	
			<div class="container content">			
				<div class="row">		
					<div class="col-lg-9" style="min-height: 500px;">			
						<div id="announce-view-panel" style="display:none;"></div>
						<h5><small><i class="fa fa-info"></i> 게시 기간이 지난 내용들은 목록에서 보여지지 않습니다.</small></h5>
						<div id="announce-grid"></div>												
					</div>	
					<div class="col-lg-3 visible-lg">	
						<div class="headline"><h4> 내용 </h4></div>  
	                	<p class="margin-bottom-25"><small>내용</small></p>					
					</div>												
				</div>
			</div>							 			
			<!-- END MAIN CONTENT -->	
 			<!-- START FOOTER -->
			<#include "/html/common/common-homepage-globalfooter.ftl" >		
			<!-- END FOOTER -->	
		</div>		
		<!-- START TEMPLATE -->
		<script id="announce-row-template" type="text/x-kendo-tmpl">
			<tr data-uid="#: uid #">
				<td><span class="label label-success">공지</span>&nbsp;#: subject #	 </td>
				<td class="text-center">#: kendo.toString(creationDate, "yyyy.MM.dd") #</td>
			</tr>
		</script>						
		<script id="alert-message-template" type="text/x-kendo-tmpl">
			<div class="alert alert-warning">새로운 공지 & 이벤트가 없습니다.</div>
		</script>	
		<script type="text/x-kendo-tmpl" id="announce-view-panel-template">		
			<div class="panel panel-default no-border">
				<div class="panel-heading rounded-top">
					<span class="close-sm"></span>
					<h2 data-bind="html:subject"></h2>					
					<ul class="list-unstyled">
						<li ><i class="fa fa-calendar"></i> <span class="label label-light">게시 기간</span> <span class="text-muted" data-bind="text:formattedStartDate"></span> ~ <span class="text-muted" data-bind="text:formattedEndDate"></span></li>
						<hr>	
						<li><i class="fa fa-calendar"></i> <span class="label label-light">생성일</span> <span class="text-muted" data-bind="text: formattedCreationDate"></span></li>
						<hr>	
						<li><i class="fa fa-calendar"></i> <span class="label label-light">수정일</span> <span class="text-muted" data-bind="text: formattedModifiedDate"></span></li>
						<hr>	
						<li class="text-muted">
							<img width="30" height="30" class="img-circle pull-left" data-bind="attr:{src:authorPhotoUrl}" src="/images/common/no-avatar.png" style="margin-right:10px;">
							<ul class="list-unstyled text-muted">
								<li><span data-bind="visible:user.nameVisible, text: user.name"></span><code data-bind="text: user.username"></code></li>
								<li><span data-bind="visible:user.emailVisible, text: user.email"></span></li>
							</ul>																
						</li>	
					</ul>											
				</div>
				<div class="panel-body padding-sm" data-bind="html:body"></div>	
			</div>
		</script>					
		<#include "/html/common/common-homepage-templates.ftl" >		
		<!-- END TEMPLATE -->
	</body>    
</html>