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
			'css!<@spring.url "/styles/font-icons/atlassian-icons.css"/>',
			'css!<@spring.url "/styles/bootstrap.themes/unify/colors/blue.css"/>',		
			'css!<@spring.url "/styles/bootstrap.themes/unify/pages/feature_timeline-v2.css"/>',		
			'css!<@spring.url "/styles/bootstrap.themes/common/common.ui.buttons.css"/>',		
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
				createAnnounceGrid();
				<#if !action.user.anonymous >				
				
				</#if>	
				// END SCRIPT	
			}
		}]);	
		
		function createAnnounceGrid(){
			var renderTo =$("#announce-grid");
			if( !common.ui.exists( renderTo ) ){
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
					toolbar: kendo.template('<div class="p-xs text-right"><small class="m-r-xl"><i class="fa fa-info"></i> 게시 기간이 지난 내용들은 목록에서 보여지지 않습니다.</small><button class="btn btn-info btn-sm btn-flat btn-outline m-l-sm" data-action="refresh">새로고침</button></div>'),
					rowTemplate: kendo.template($("#announce-row-template").html()),
					sortable: true,
					pageable: false,
					selectable: "single" ,
					height:400,
					change: function(e){						
						var selectedCells = this.select();
						var selectedCell = this.dataItem( selectedCells );	
						var index = this.items().index( selectedCells );
						
						//alert( index + "/" +  this.items().length );
						//	$("#announce-grid").data( "announcePlaceHolder", selectedCell );
						displayAnnouncement(selectedCell);
					}
				});
				renderTo.find("[data-action='refresh']").click( function(e){
					common.ui.grid(renderTo).dataSource.read();
				});			
			}		
		}
		
		function displayAnnouncement (data) {		
		
			var renderTo = $("#announce-view-panel");
			if(renderTo.contents().length == 0){				
				renderTo = renderTo.html( $('#announce-view-panel-template').html() );
				var observable = common.ui.observable({
					announce: new common.ui.data.Announce(),
					setAnnounce: function(announce){
						$this = this;
						announce.copy( $this.announce );					
					},
					close:function(e){
						renderTo.slideUp();
					}
				});
				common.ui.bind(renderTo, observable );
				renderTo.data("model", observable );
				renderTo.find(".close-sm").click(function (e) {
					renderTo.slideUp();
				});	
				
			}
			renderTo.data("model").setAnnounce( data );
			renderTo.slideDown();			
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
		
		.detail-pane {
			position:relative;
			overflow: hidden,
			z-index:2;
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
						<div id="announce-grid"></div>												
					</div>	
					<div class="col-lg-3 visible-lg">	
						<div class="headline"><h4> 덧글 </h4></div>  
	                	<p class="margin-bottom-25"><small>내용 무...</small></p>					
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
				<td><span class="label label-red">공지</span>&nbsp;#: subject #	 </td>
				<td class="text-center"><i class="fa fa-calendar"></i> #: kendo.toString(creationDate, "yyyy.MM.dd") #</td>
			</tr>
		</script>						
		<script id="alert-message-template" type="text/x-kendo-tmpl">
			<div class="alert alert-warning">새로운 공지 & 이벤트가 없습니다.</div>
		</script>	
		<script type="text/x-kendo-tmpl" id="announce-view-panel-template">		
			<div class="panel bordered">
				<div class="panel-heading rounded-top">
					<span class="close-sm"></span>
					<h2 data-bind="html:announce.subject"></h2>					
					<ul class="list-unstyled m-r-xl">
						<li ><i class="fa fa-calendar"></i> <span class="label label-light">게시 기간</span> <span class="text-muted" data-bind="text:announce.formattedStartDate"></span> ~ <span class="text-muted" data-bind="text:announce.formattedEndDate"></span></li>
						<hr>	
						<li><i class="fa fa-calendar"></i> <span class="label label-light">생성일</span> <span class="text-muted" data-bind="text: announce.formattedCreationDate"></span></li>
						<hr>	
						<li><i class="fa fa-calendar"></i> <span class="label label-light">수정일</span> <span class="text-muted" data-bind="text: announce.formattedModifiedDate"></span></li>
						<hr>	
						<li class="text-muted">
							<img width="30" height="30" class="img-circle pull-left" data-bind="attr:{src: announce.authorPhotoUrl}" src="/images/common/no-avatar.png" style="margin-right:10px;">
							<ul class="list-unstyled text-muted">
								<li><span data-bind="visible:announce.user.nameVisible, text: announce.user.name"></span><code data-bind="text: announce.user.username"></code></li>
								<li><span data-bind="visible:announce.user.emailVisible, text: announce.user.email"></span></li>
							</ul>																
						</li>	
					</ul>											
				</div>
				<div class="panel-body padding-sm" data-bind="html:announce.body"></div>	
				<div class="panel-footer text-right">
					<div class="btn-group">
						<button class="btn btn-info btn-flat btn-outline btn-sm"><i class="fa fa-angle-left"></i>  이전</button>
						<button class="btn btn-info btn-flat btn-outline btn-sm" >다음  <i class="fa fa-angle-right"></i></button>
					</div>
					<button class="btn btn-defautl btn-sm btn-flat btn-outline"  data-bind="click:close"><i class="aui-icon aui-iconfont-close-dialog"></i>  닫기</button>
				</div>	
			</div>
		</script>					
		<#include "/html/common/common-homepage-templates.ftl" >		
		<!-- END TEMPLATE -->
	</body>    
</html>