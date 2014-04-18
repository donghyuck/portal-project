<#ftl encoding="UTF-8"/>
<html decorator="secure">
	<head>
		<title>시스템 정보</title>
<#compress>		
		<script type="text/javascript"> 
		yepnope([{
			load: [ 
			'css!${request.contextPath}/styles/font-awesome/4.0.3/font-awesome.min.css',
			'${request.contextPath}/js/jquery/1.10.2/jquery.min.js',
			'${request.contextPath}/js/bootstrap/3.0.3/bootstrap.min.js',
			'${request.contextPath}/js/jgrowl/jquery.jgrowl.min.js',
			'${request.contextPath}/js/kendo/kendo.web.min.js',
			'${request.contextPath}/js/kendo.extension/kendo.ko_KR.js',			 
			'${request.contextPath}/js/kendo/cultures/kendo.culture.ko-KR.min.js', 
			'${request.contextPath}/js/common/common.models.js',
			'${request.contextPath}/js/common/common.api.js',
			'${request.contextPath}/js/common/common.ui.js',
			'${request.contextPath}/js/common/common.ui.system.js',
			'${request.contextPath}/js/ace/ace.js',],        	   
			complete: function() {               
				
				// 1.  한글 지원을 위한 로케일 설정
				kendo.culture("ko-KR");
										
				// 2. ACCOUNTS LOAD		
				var currentUser = new User();
				var accounts = $("#account-panel").kendoAccounts({
					visible : false,
					authenticate : function( e ){
						currentUser = e.token.copy(currentUser);							
					}
				});			
														
				// 3.MENU LOAD 
				var companyPlaceHolder = new Company({ companyId: ${action.user.companyId} });
				
				$("#navbar").data("companyPlaceHolder", companyPlaceHolder);				
				var topBar = $("#navbar").extNavbar({
					template : $("#top-navbar-template").html(),
					items : [{ 
						name:"companySelector", 
						selector: "#companyDropDownList", 
						value: ${action.user.companyId}, 
						change : function (data){
							data.copy(companyPlaceHolder);
							kendo.bind($("#company-info"), companyPlaceHolder );
						}	
					}]
				});
												 
				 // 4. PAGE MAIN		
				 var sitePlaceHolder = new common.models.WebSite( {webSiteId: ${ action.targetWebSite.webSiteId}} );
				 $("#website-info").data("sitePlaceHolder", sitePlaceHolder );
				common.api.callback(  
				{
					url :"${request.contextPath}/secure/get-site.do?output=json", 
					data : { targetSiteId:  sitePlaceHolder.webSiteId },
					success : function(response){
						var site = new common.models.WebSite(response.targetWebSite);
						site.copy( sitePlaceHolder );
						kendo.bind($("#website-info"), sitePlaceHolder );
						$('button.btn-control-group').removeAttr("disabled");						
					}
				}); 
				 
				 common.ui.handleButtonActionEvents(
					$("button.btn-control-group"), 
					{event: 'click', handlers: {
						'page-create' : function(e){
							alert( "hello" );							
						},
						setting : function(e){
							showWebsiteSetting();					
						},						
						group : function(e){
							topBar.go('main-group.do');				
						}, 	
						user : function(e){
							topBar.go('main-user.do');			
						}, 							
						details : function(e){
							showWebsiteDetails();
						},
						connect : function(e){
							alert("social modal");	 					
						},
						back : function(e){
							goWebsite();					
						}																  						 
					}}
				);
			}	
		}]);
			
		function goWebsite (){					
			$("form[name='navbar-form'] input[name='targetSiteId']").val( $("#website-info").data("sitePlaceHolder").webSiteId );
			$("#navbar").data("kendoExtNavbar").go("view-site.do");							
		}
		
		</script>
		<style type="text/css" media="screen">

		.k-grid-content{
			height:200px;
		}			
		#xmleditor { 
			position: absolute;
			top: 0;
			right: 0;
			bottom: 0;
			left: 0;
		}
		</style>		
</#compress>		
	</head>
	<body>
		<!-- START HEADER -->
		<section id="navbar"></section>
		<!-- END HEADER -->
		<!-- START MAIN CONTNET -->
		
		<div class="container-fluid">		
			<div class="row">			
				<div class="page-header">
					<#assign selectedMenuItem = action.getWebSiteMenu("SYSTEM_MENU", "MENU_1_2") />
					<h1>${selectedMenuItem.title}     <small><i class="fa fa-quote-left"></i>&nbsp;${selectedMenuItem.description}&nbsp;<i class="fa fa-quote-right"></i></small></h1>
				</div>				
			</div>	
			<div class="row">	
				<div class="col-lg-12">
					<div class="panel panel-default" style="min-height:300px;">
						<div class="panel-heading" style="padding:5px;">
							<div class="btn-group">
								<button type="button" class="btn btn-info btn-control-group btn-sm" data-action="group"><i class="fa fa-users"></i> 그룹관리</button>
								<button type="button" class="btn btn-info btn-control-group btn-sm" data-action="user"><i class="fa fa-user"></i> 사용자관리</button>
							</div>			
							<div class="btn-group">
								<button type="button" class="btn btn-primary btn-control-group btn-sm" data-action="back" disabled="disabled"  title="이전 페이지로 이동" ><i class="fa fa-level-up"></i></button>			
							</div>														
						</div>
						<div class="panel-body" style="padding:5px;">
							<div class="page-header page-nounderline-header text-primary">
									<h5 >
										<small><i class="fa fa-info"></i> 웹 페이지는 게시 상태에서 보여집니다.</small>
									</h5>
									<div class="pull-right"><div class="btn-group">
										<button type="button" class="btn btn-primary btn-control-group btn-sm" data-toggle="button" data-action="page-create" disabled="disabled"><i class="fa fa-file"></i> 새 페이지</button>
										<button type="button" class="btn btn-primary btn-control-group btn-sm" data-toggle="button" data-action="page-publish" disabled="disabled"><i class="fa fa-external-link"></i> 게시</button>
										<button type="button" class="btn btn-primary btn-control-group btn-sm" data-toggle="button" data-action="page-delete" disabled="disabled"><i class="fa fa-trash-o"></i> 삭제</button></div>
									</div>
							</div>								
						</div>					
						<div class="panel-body" style="padding:5px;">	
						
										
						</div>
						<div class="panel-body" style="padding:5px;">
						</div>
					</div>	
				</div>
			</div>
		</div>				
		<div id="website-info" ></div>  
		<div id="account-panel" ></div>    		
		<!-- END MAIN CONTNET -->
		<!-- START FOOTER -->
		<footer>  		
		</footer>
		<!-- END FOOTER -->		
		<#include "/html/common/common-system-templates.ftl" >		
	</body>
</html>