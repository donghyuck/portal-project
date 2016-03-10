			<!--=== Header v6 ===-->
			<div class="header-v6 header-sticky">
				<!-- Navbar -->
				<div class="navbar mega-menu" role="navigation">
					<div class="container">
						<div class="menu-container">
							<!--
							<button type="button" class="navbar-toggle sliding-panel__btn">
								<span class="sr-only">Toggle navigation</span>
								<span class="icon-bar"></span>
								<span class="icon-bar"></span>
								<span class="icon-bar"></span>
							</button>
							-->
							<button type="button" class="navbar-toggle" data-toggle="collapse" data-target=".navbar-responsive-collapse">
								<span class="sr-only">Toggle navigation</span>
								<span class="icon-bar"></span>
								<span class="icon-bar"></span>
								<span class="icon-bar"></span>
							</button>
							<!-- Navbar Brand -->
							<div class="navbar-brand">
								<a href="/">
								<!--
									<img class="default-logo" src="<@spring.url '/download/logo/company/${action.webSite.company.name}'/>" alt="Logo">
									<img class="shrink-logo" src="<@spring.url '/download/logo/company/${action.webSite.company.name}'/>" alt="Logo">
								-->	
									<img class="default-logo" src="<@spring.url '/download/logo/company/podosoftware'/>" alt="Logo">
									<img class="shrink-logo" src="<@spring.url '/download/logo/company/podosoftware'/>" alt="Logo">
								</a>
							</div>
							<!-- ENd Navbar Brand -->
							<!-- Header Inner Right -->
							<div class="header-inner-right accounts-user-profile">
								<ul class="menu-icons-list">
									<li class="menu-icons">
										<a href="/accounts/login.html?url=/display/competency/my-assessment.html" class="btn-link user-menu" data-bind="visible:anonymous" style="display:none" >
										<img src="/images/common/icons/basic/ios9/Key.svg"><span class="label label-success rounded">로그인</span>
										</a>	
										<a href="#" data-bind="invisible:anonymous" class="btn-link user-menu" style="display:none" role="button" data-toggle="popover" data-trigger="focus" data-html="true" data-placement="bottom" 
											data-content="<a href='<@spring.url "/accounts/logout.html?url=${springMacroRequestContext.getRequestUri()}"/>' class='btn btn-xs btn-danger btn-flat rounded'>로그아웃</a>">
											<img class="rounded" src="/images/common/anonymous.png" width="42" height="42" data-bind="attr:{src:photoUrl}" alt="" />
										</a>
									</li>
								</ul>						
							</div>
							<!-- End Header Inner Right -->
						</div>
						<!-- Collect the nav links, forms, and other content for toggling -->					
						<#if action.webSite ?? >
						<#assign selected_menu = action.getNavigator() />	
						<#assign pageMenu = action.getWebSiteMenu("ONEPAGE_COMPETENCY_MENU") />	
						<div class="collapse navbar-collapse navbar-responsive-collapse">
							<div class="menu-container">
								<ul class="nav navbar-nav pull-left">	
							<#list pageMenu.components as item >
							<#if WebSiteUtils.isUserAccessAllowed(item) >
								<li class="<#if (selected_menu.name == item.name)>active</#if>" ><a href="${item.page}">${item.title}</a></li>	
							</#if>
							</#list>							
								</ul>	
 								<!--
								<div class="right clearfix">
									<ul class="nav navbar-nav pull-right right-navbar-nav">								
										<li class="dropdown">
											<a href="<@spring.url "/accounts/login.html?url=${springMacroRequestContext.getRequestUri()}"/>" class="btn-link user-menu">
												<img src="<@spring.url "/images/common/icons/basic/ios9/Key.svg"/>">
												<span>로그인</span>
											</a>
											<ul class="dropdown-menu">
												<li><a href="#"><span class="label label-warning pull-right">New</span> 프로파일</a></li>
												<li class="divider"></li>
												<li>
													<a href="<@spring.url "/accounts/logout.html?url=${ springMacroRequestContext.getRequestUri()}" />">
													로그아웃</a>
												</li>
											</ul>
										</li>
									</ul>
								</div>	
								-->
							</div>							
						</div>		
						</#if>						
					</div>
				</div>
				<!-- End Navbar -->		
			</div><!--=== End Header v6 ===--> 