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
							<div class="header-inner-right">
						
							</div>
							<!-- End Header Inner Right -->
						</div>
						<!-- Collect the nav links, forms, and other content for toggling -->
						<#if action.webSite ?? >
							<#assign current_menu = action.getNavigator() />		
						<div class="collapse navbar-collapse navbar-responsive-collapse">
							<div class="menu-container">
								<ul class="nav navbar-nav">						
							<#assign pageMenu = action.getWebSiteMenu("ONEPAGE_COMPETENCY_MENU") />	
							<#list pageMenu.components as item >
							<#if WebSiteUtils.isUserAccessAllowed(item) >
								<li><a href="${item.page}">${item.title}</a></li>	
							</#if>
							</#list>							
								</ul>
							</div>
						</div>		
						</#if>
						
					</div>
				</div>
				<!-- End Navbar -->		
			</div><!--=== End Header v6 ===--> 