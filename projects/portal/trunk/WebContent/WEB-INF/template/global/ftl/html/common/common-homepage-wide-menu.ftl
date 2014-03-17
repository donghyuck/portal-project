		<#if action.getMenuComponent("USER_MENU") ?? >
		<#assign menu = action.getMenuComponent("USER_MENU") />
			<div class="container">
					<#if action.user.company ?? >
					<div class="navbar-header">
						<button type="button" class="navbar-toggle" data-toggle="collapse" data-target=".navbar-collapse">
							<span class="icon-bar"></span>
							<span class="icon-bar"></span>
							<span class="icon-bar"></span>
						</button>					
						<a class="navbar-brand" href="/main.do">${action.user.company.displayName }</a>
					</div>
					</#if>		
					<div class="navbar-collapse collapse">										
					<ul class="nav navbar-nav">
						<#list menu.components as item >
						<#if  item.components?has_content >
							<li class="dropdown">
								<a href="#" class="dropdown-toggle" data-toggle="dropdown">${item.title}<b class="caret"></b></a>
								<ul class="dropdown-menu">
								<#list item.components as sub_item >
									<#if sub_item.components?has_content >
										<li class="dropdown-submenu">
											<a href="#" class="dropdown-toggle" data-toggle="dropdown">${sub_item.title}</a>
											<ul class="dropdown-menu">
												<#list sub_item.components as sub_sub_item >
												<li><a href="${sub_item.page}">${ sub_sub_item.title }</a></li>
												</#list>
											</ul>
										</li>
									<#else>								
										<li><a href="${sub_item.page}">${sub_item.title}</a></li>
									</#if>								
								</#list>
								</ul>
							</li>
						<#else>
							<li>
								<a href="#">${item.title}</a>
							</li>
						</#if>
						</#list>
					</ul>				
					<ul class="nav navbar-nav navbar-right">
						<li>
							<div id="account-panel"></div> 
						</li>
						<li>
							<p class="navbar-text"></p>
						</li>
					</ul>
					</div><!--/.nav-collapse -->
			</#if>		
			</div>