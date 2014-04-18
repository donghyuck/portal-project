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
				 $("#site-info").data("sitePlaceHolder", sitePlaceHolder );
				common.api.callback(  
				{
					url :"${request.contextPath}/secure/get-site.do?output=json", 
					data : { targetSiteId:  sitePlaceHolder.webSiteId },
					success : function(response){
						var site = new common.models.WebSite(response.targetWebSite);
						site.copy( sitePlaceHolder );
						kendo.bind($("#site-info"), sitePlaceHolder );
						$('button.btn-control-group').removeAttr("disabled");						
					},
					requestStart : function(){
						kendo.ui.progress($("#site-info"), true);
					},
					requestEnd : function(){
						kendo.ui.progress($("#site-info"), false);
					}
				}); 
				 
				 common.ui.handleButtonActionEvents(
					$("button.btn-control-group"), 
					{event: 'click', handlers: {
						menu : function(e){
							showWebsiteMenuSetting();								
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
			$("form[name='navbar-form'] input[name='targetSiteId']").val( $("#site-info").data("sitePlaceHolder").webSiteId );
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
								<button type="button" class="btn btn-primary btn-control-group btn-sm" data-action="back" disabled="disabled"  title="이전 페이지로 이동" ><i class="fa fa-angle-left"></i></button>			
							</div>														
							<button type="button" class="btn btn-success btn-control-group btn-sm" data-toggle="button" data-action="pages" disabled="disabled"><i class="fa fa-file"></i> 웹 페이지</button>
						</div>
						<div class="panel-body" style="padding:5px;">														
							<div class="row">
								<div class="col-lg-5 col-xs-12" id="site-info">					
									<div class="page-header page-nounderline-header text-primary">
										<h5 >
											<small><i class="fa fa-info"></i> 미디어 버튼을 클릭하면 사이트 미디어(이미지, 파일 등)을 관리할 수 있습니다.</small>
										</h5>
										<p class="pull-right">											
										</p>
									</div>										
									<table class="table">
											<tbody>						
												<tr class="info">
													<th><small>회사</small></th>								
													<td><span data-bind="text: company.displayName">${action.targetWebSite.company.displayName}</span> 
														<span class="label label-primary"><span data-bind="text: company.name">${action.targetWebSite.company.name}</span></span> 
														<code><span data-bind="text: company.companyId">${action.targetWebSite.company.companyId}</span></code>
													</td>
												</tr>	
												<tr>
													<th><small>사이트</small></th>	
													<td><span data-bind="text: displayName">${action.targetWebSite.displayName} </span> 
														<span class="label label-warning"><span data-bind="text: name">${action.targetWebSite.name}</span></span> 
														<code><span data-bind="text: webSiteId">${action.targetWebSite.webSiteId}</span></code>
														<span class="label label-danger" data-bind="invisible: enabled" style="display:none;"><i class="fa fa-times"></i></span>
													</td>
												</tr>	
												<tr>
													<th><small>보안</small></th>	
													<td>
													<!--
														<span class="label label-info" data-bind="visible: allowAnonymousAccess">공개</span>
														<span class="label label-info" data-bind="invisible: allowAnonymousAccess">비공개</span> -->
														<i class="fa fa-lock fa-lg" data-bind="invisible: allowAnonymousAccess" style="display:none;"></i>
														<i class="fa fa-unlock fa-lg" data-bind="visible: allowAnonymousAccess" style="display:none;"></i>														
													</td>
												</tr>													
												<tr>
													<th><small>메뉴</small></th>	
													<td><span data-bind="text: menu.title">${action.targetWebSite.menu.title} </span> 
														<span class="label label-warning"><span data-bind="text: menu.name">${action.targetWebSite.menu.name}</span></span> 
														<code><span data-bind="text: menu.menuId">${action.targetWebSite.menu.menuId}</span></code>
													</td>
												</tr>													
												<tr>
													<th><small>담당자</small></th>								
													<td>
														<div class="media">
															<a class="pull-left" href="#">
																<img class="media-object" src="${request.contextPath}/download/profile/${action.targetWebSite.user.username}?width=100&height=150" alt="...">
															</a>
															<div class="media-body">
																<h6 class="media-heading"><span data-bind="text: user.name">${action.targetWebSite.user.name}</span>(<span data-bind="text: user.username">${action.targetWebSite.user.username}</span>)</h6>
															</div>
														</div>													
													</td>
												</tr>		
												<tr>
													<th><small>설명</small></th>								
													<td><span data-bind="text: description">${action.targetWebSite.description}</span></td>
												</tr>				
												<tr>
													<th><small>등록일</small></th>
													<td><span data-bind="text: creationDate">${action.targetWebSite.creationDate}</span></td>
												</tr>				
												<tr>
													<th><small>수정일</small></th>
													<td><span data-bind="text: modifiedDate">${action.targetWebSite.modifiedDate}</span></td>
												</tr>							
										 	</tbody>
									</table>
								</div>
								<div class="col-lg-7 col-xs-12 hide" id="company-details">														
									<ul class="nav nav-tabs" id="myTab">
									  <li><a href="#image-mgmt" data-toggle="tab">이미지</a></li>
									  <li><a href="#attachment-mgmt" data-toggle="tab">첨부파일</a></li>
									  <li><a href="#social-mgmt" data-toggle="tab">쇼셜</a></li>
									</ul>
									<div class="tab-content">
										<div class="tab-pane fade " id="image-mgmt">
											<div class="col-sm-12 body-group marginless paddingless">
												<input name="image-upload" id="image-upload" type="file" />
												<div class="blank-top-15"></div>	
												<div id="image-grid"></div>	
											</div>
											<div id="image-details" class="col-sm-12 body-group marginless paddingless hide" style="padding-top:5px;">									
											</div>
										</div>								
										<div class="tab-pane fade" id="attachment-mgmt">
											<div class="col-sm-12 body-group marginless paddingless">
												<input name="attach-upload" id="attach-upload" type="file" />
												<div class="blank-top-15"></div>
												<div id="attach-grid"></div>
											</div>
										</div>
										<div class="tab-pane fade" id="social-mgmt">
											<span class="help-block">
												<small><i class="fa fa-info"></i> 쇼셜연결 버튼을 클릭하여 사이트 쇼셜 계정을 연결하세요. </small>
												<button type="button" class="btn btn-primary btn-control-group btn-sm" data-toggle="button" data-action="connect"> 쇼셜연결</button>
											</span>
											<div id="social-grid"></div>
										</div>								
									</div>								
								</div>
							</div>							
						</div>					
						<div class="panel-body" style="padding:5px;">		
							<div id="website-grid"></div>						
						</div>
						<div class="panel-body" style="padding:5px;"></div>
					</div>	
				</div>
			</div>
		</div>				
		<div id="account-panel" ></div>
    		
		<!-- END MAIN CONTNET -->
		<!-- START FOOTER -->
		<footer>  		
		</footer>
		<!-- END FOOTER -->		
		<#include "/html/common/common-system-templates.ftl" >		
	</body>
</html>