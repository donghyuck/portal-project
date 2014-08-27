<#ftl encoding="UTF-8"/>
<html decorator="homepage">
<head>
		<title>기업소개</title>
		<script type="text/javascript">
		<!--
		
		var jobs = [];	
		
		yepnope([{
			load: [
			'css!${request.contextPath}/styles/font-awesome/4.1.0/font-awesome.min.css',
			'css!${request.contextPath}/styles/common.themes/unify/themes/blue.css',		
			'${request.contextPath}/js/jquery/1.10.2/jquery.min.js',
			'${request.contextPath}/js/jgrowl/jquery.jgrowl.min.js',
			'${request.contextPath}/js/kendo/kendo.web.min.js',
			'${request.contextPath}/js/kendo.extension/kendo.ko_KR.js',			
			'${request.contextPath}/js/kendo/cultures/kendo.culture.ko-KR.min.js',		
			'${request.contextPath}/js/bootstrap/3.1.0/bootstrap.min.js',
			'${request.contextPath}/js/common/common.models.js',
			'${request.contextPath}/js/common/common.api.js',			
			'${request.contextPath}/js/common/common.ui.js',
			'${request.contextPath}/js/jquery.extension/modernizr.custom.js',
			'${request.contextPath}/js/jquery.extension/classie.js',
			],
			complete: function() {
			
				common.ui.setup({
					features:{
						backstretch : false
					},
					worklist:jobs
				});	

				// ACCOUNTS LOAD	
				var currentUser = new User();			
				$("#account-navbar").extAccounts({
					externalLoginHost: "${ServletUtils.getLocalHostAddr()}",	
					<#if action.isAllowedSignIn() ||  !action.user.anonymous  >
					template : kendo.template($("#account-template").html()),
					</#if>
					authenticate : function( e ){
						e.token.copy(currentUser);
					}				
				});		

				// 1. Announces 				
				//$("#announce-grid").data( "announcePlaceHolder", new Announce () );					
				$("#announce-grid").kendoGrid({
					dataSource: new kendo.data.DataSource({
						transport: {
							read: {
								type : 'POST',
								dataType : "json", 
								url : '${request.contextPath}/community/list-announce.do?output=json'
							},
							parameterMap: function(options, operation) {
								if (operation != "read" && options.models) {
									return {models: kendo.stringify(options.models)};
								}else{
									return {objectType:30}
								}
							},
						},
						pageSize: 15,
						error:common.api.handleKendoAjaxError,				
						schema: {
							data : "targetAnnounces",
							model : Announce
						}
					}),	
					columns: [
						{field: "subject", title: "제목", sortable : false },
						{field: "creationDate", title: "게시일", width: "120px", format: "{0:yyyy.MM.dd}"}
					],
					sortable: true,
					pageable: false,
					selectable: "single",
					rowTemplate: kendo.template($("#announce-row-template").html()),
					height: 430,
					change: function(e) { 
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

		#announce-list-section .k-grid-header .k-header {
			text-align: center;
		}
							
		</style>   	
	</head>
	<body>
		<div class="page-loader"></div>	
		<!-- START HEADER -->
		
		<div class="wrapper">
		<!-- START HEADER -->
		<#include "/html/common/common-homepage-menu.ftl" >	
		<#assign hasWebSitePage = action.hasWebSitePage("pages.events.pageId") />
		<#assign menuName = action.targetPage.getProperty("page.menu.name", "USER_MENU") />
		<#assign menuItemName = action.targetPage.getProperty("navigator.selected.name", "MENU_1_3") />
		<#assign current_menu = action.getWebSiteMenu(menuName, menuItemName) />				
		<header  class="cloud <#if current_menu.parent.css??>${current_menu.parent.css}</#if>">
			<header  class="cloud <#if current_menu.parent.css??>${current_menu.parent.css}</#if>">			
				<div class="breadcrumbs">
			        <div class="container">
			            <h1 class="pull-left">${ current_menu.title }
			            	<small>
			            		<i class="fa fa-quote-left"></i>&nbsp;${ current_menu.description ? replace ("{displayName}" , action.webSite.company.displayName ) }&nbsp;<i class="fa fa-quote-right"></i>
			            	</small>
			            </h1>
			            <ul class="pull-right breadcrumb">
					        <li><a href="main.do"><i class="fa fa-home fa-lg"></i></a></li>
					        <li><a href="">${current_menu.parent.title}</a></li>
					    	<li class="active">${current_menu.title}</li>
			            </ul>
			        </div>
			    </div>		
			</header>
		<!-- END HEADER -->			
		<!-- START MAIN CONTENT -->	
		<div class="container content">			
			<div class="row">
				<div class="col-lg-3 visible-lg">		
					<!-- start side menu -->		
					<div class="headline"><h4> ${current_menu.parent.title} </h4></div>  
	               	<p class="margin-bottom-25"><small>${current_menu.parent.description!" " }</small></p>							
					<div class="list-group">
					<#list current_menu.parent.components as item >
						<#if item.name ==  current_menu.name >
						<a href="${item.page}" class="list-group-item active">${ item.title } </a>
						<#else>
						<a href="${item.page}" class="list-group-item">${ item.title } </a>
						</#if>						
					</#list>										
					</div>	
					<!-- end side menu -->				
				</div>
				<div class="col-lg-9" style="min-height: 500px;">			
					<div id="announce-view-panel" style="display:none;"></div>
					<h5><small><i class="fa fa-info"></i> 게시 기간이 지난 내용들은 목록에서 보여지지 않습니다.</small></h5>
					<div id="announce-grid"></div>												
				</div>				
			</div>
		</div>									 			
		<!-- END MAIN CONTENT -->	

 		<!-- START FOOTER -->
		<#include "/html/common/common-homepage-footer.ftl" >		
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
					
					<!-- 
					<button type="button" class="btn-close btn-close-grey"><span class="sr-only">Close</span></button>
					-->
					<span class="close-sm"></span>
					<h4 data-bind="html:subject"></h4>
					<small class="text-muted"><span class="label label-info label-lightweight">게시 기간</span> #: formattedStartDate() # ~  #: formattedEndDate() #</small>					
				</div>
				<div class="panel-body padding-sm" data-bind="html:body"></div>	
			</div>
		</script>
					
		<#include "/html/common/common-homepage-templates.ftl" >		
		<!-- END TEMPLATE -->
	</body>    
</html>