		<!-- START MENU -->	
		<#assign menu = WebSiteUtils.getMenuComponent("SYSTEM_MENU") />			
		<div id="main-menu" role="navigation">
			<div id="main-menu-inner">
				<div class="menu-content menu-content-profile top">
					<div>
						<div class="text-bg"><span class="text-slim">Welcome,</span> <span class="text-semibold">${action.user.name}</span></div>
						<img src="/download/profile/${action.user.username}?width=100&height=150" alt="" class="">
						<div class="btn-group">
							<a href="#" class="btn btn-xs btn-primary btn-outline dark"><i class="fa fa-envelope"></i></a>
							<a href="#" class="btn btn-xs btn-primary btn-outline dark"><i class="fa fa-user"></i></a>
							<a href="#" class="btn btn-xs btn-primary btn-outline dark"><i class="fa fa-cog"></i></a>
							<a href="#" class="btn btn-xs btn-danger btn-outline dark"><i class="fa fa-power-off"></i></a>
						</div>
						<a href="#" class="close">&times;</a>
					</div>
				</div>
		
			<ul class="navigation">		
			<#list menu.components as item >
				<#if  item.components?has_content >
				<li class="mm-dropdown">
					<a href="javascript:void(0);"><#if item.isSetIcon()><i class="menu-icon fa ${item.icon}"></i> </#if><span class="mm-text">${item.title}</span></a>
					<ul>
						<#list item.components as sub_item >
							<#if sub_item.components?has_content >
							<li class="dropdown-submenu">
								<a href="#" class="dropdown-toggle" data-toggle="dropdown"><span class="mm-text">${sub_item.title}</span></a>
								<ul class="dropdown-menu">
								<#list sub_item.components as sub_sub_item >
									<li><a href="${sub_item.page}"> <span class="mm-text">${ sub_sub_item.title }</span></a></li>
								</#list>
								</ul>
							</li>
							<#else>								
								<li><a tabindex="-1" href="${sub_item.page}"><span class="mm-text">${sub_item.title}</span></a></li>
							</#if>								
						</#list>
					</ul>					
				</li>
				<#else>
				<li>
					<a href="${item.page}"><#if item.isSetIcon()><i class="menu-icon fa ${item.icon}"></i> </#if><span class="mm-text">${item.title}</span></a>
				</li>
				</#if>
			</#list>
<li class="mm-dropdown">
					<a href="#"><i class="menu-icon fa fa-desktop"></i><span class="mm-text">UI elements</span></a>
					<ul>
						<li>
							<a tabindex="-1" href="ui-buttons.html"><span class="mm-text">Buttons</span></a>
						</li>
						<li>
							<a tabindex="-1" href="ui-typography.html"><span class="mm-text">Typography</span></a>
						</li>
						<li>
							<a tabindex="-1" href="ui-tabs.html"><span class="mm-text">Tabs &amp; Accordions</span></a>
						</li>
						<li>
							<a tabindex="-1" href="ui-modals.html"><span class="mm-text">Modals</span></a>
						</li>
						<li>
							<a tabindex="-1" href="ui-alerts.html"><span class="mm-text">Alerts &amp; Tooltips</span></a>
						</li>
						<li>
							<a tabindex="-1" href="ui-components.html"><span class="mm-text">Components</span></a>
						</li>
						<li>
							<a tabindex="-1" href="ui-panels.html"><span class="mm-text">Panels</span></a>
						</li>
						<li>
							<a tabindex="-1" href="ui-jqueryui.html"><span class="mm-text">jQuery UI</span></a>
						</li>
						<li>
							<a tabindex="-1" href="ui-icons.html"><span class="mm-text">Icons</span></a>
						</li>
						<li>
							<a tabindex="-1" href="ui-utility-classes.html"><span class="mm-text">Utility classes</span></a>
						</li>
					</ul>
				</li>
			
			</ul> <!-- / .navigation -->
			<div class="menu-content">
				<a href="pages-invoice.html" class="btn btn-primary btn-block btn-outline dark">Create Invoice</a>
			</div>
		</div> <!-- / #main-menu-inner -->
	</div> <!-- / #main-menu -->

			
			<#if action.user.anonymous >
			</#if>		