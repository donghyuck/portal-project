			<!-- START MENU -->	
			<#if action.user.anonymous >
			<script type="text/javascript">
			<!--
			function signinCallbackResult( media, onetime, success ){
			
			}		
			-->
			</script>
			</#if>		
			<#if action.webSite ?? >
			<#assign webSite = webSite />				
			<#assign webSiteMenu = action.getWebSiteMenu("USER_MENU") />
			<div class="header header-transparent">
				<div class="topbar">
					<div class="container">
						<!-- Topbar Navigation -->
						<ul class="loginbar pull-right">
							<li>
								<i class="fa fa-globe"></i>
								<a>언어</a>
								<ul class="lenguages">
									<li class="active">
										<a href="#">한국어 <i class="fa fa-check"></i></a> 
									</li>
								</ul>
							</li>
							<li class="topbar-devider"></li>   
							<li><a href="##\">도움말</a></li>  
						</ul>
						<!-- End Topbar Navigation -->
					</div>
				</div>
				<nav class="navbar navbar-default" role="navigation">
					<div class="container">
						<!-- Brand and toggle get grouped for better mobile display -->
						<div class="navbar-header">	`
							<button type="button" class="navbar-toggle" data-toggle="collapse" data-target=".navbar-responsive-collapse">								
								<span class="sr-only">${webSite.description} toggle navigation</span>
								<span class="fa fa-bars"></span>
							</button>
							<a href="#" class="navbar-toggle-account btn-link no-padding no-margin">
							<img src="/download/profile/andang?width=100&amp;height=150" height="34">
							<!--<i class="fa fa-user fa-2x"></i>-->							
							</a>							
							<a class="navbar-brand" href="/main.do">
								<img id="logo-header" src="/download/logo/company/${action.webSite.company.name}" height="42" class="img-circle" alt="Logo">
							</a>
						</div>												
						<!-- Collect the nav links, forms, and other content for toggling -->
						<div class="collapse navbar-collapse navbar-responsive-collapse ">
							<ul id="account-navbar" class="nav navbar-nav navbar-right hidden-xs"></ul>
							<!-- /account -->
							<ul class="nav navbar-nav">
								<#list webSiteMenu.components as item >
								<#if WebSiteUtils.isUserAccessAllowed(request, item) >
								<#if  item.components?has_content >
									<li class="dropdown">
										<a href="javascript:void(0);" class="dropdown-toggle" data-toggle="dropdown"><#if item.icon?? ><i class="fa fa-${item.icon}"></i></#if> ${item.title}</a>
										<ul class="dropdown-menu">
										<#list item.components as sub_item >
											<#if sub_item.components?has_content >
												<li class="dropdown-submenu">
													<a href="#" class="dropdown-toggle" data-toggle="dropdown"><#if sub_item.icon?? ><i class="fa fa-${sub_item.icon}"></i></#if> ${sub_item.title}</a>
													<ul class="dropdown-menu">
														<#list sub_item.components as sub_sub_item >
														<li><a href="${sub_item.page}">${ sub_sub_item.title }</a></li>
														</#list>
													</ul>
												</li>
											<#else>								
												<li><a href="${sub_item.page}"><#if sub_item.icon?? ><i class="fa fa-${sub_item.icon}"></i></#if> ${sub_item.title}</a></li>
											</#if>								
										</#list>
										</ul>
									</li>
								<#else>
									<li>
										<a href="${item.page}"><#if item.icon?? ><i class="fa fa-${item.icon}"></i></#if> ${item.title}</a>
									</li>
								</#if>
								</#if>		
								</#list>
							</ul>				
						</div>						
					</div>
				</nav>
			</div>
			</#if>		
			<!-- END MENU -->		
			<!-- START My profile Modal -->
			<div class="modal fade" id="myProfileModal" tabindex="-1" role="dialog" aria-labelledby="myProfileModalLabel" aria-hidden="true">
			  <div class="modal-dialog modal-lg">
			    <div class="modal-content" style="min-height:600px;">
			      <div class="modal-header">
			        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
			        <h4 class="modal-title" id="myProfileModalLabel">내정보</h4>
			      </div>
			      <div class="modal-footer">
			      </div>
			    </div><!-- /.modal-content -->
			  </div><!-- /.modal-dialog -->
			</div><!-- /.modal -->					