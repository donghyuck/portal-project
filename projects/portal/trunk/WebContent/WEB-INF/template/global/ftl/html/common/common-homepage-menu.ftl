		<!-- START MENU -->	
		<#if action.user.anonymous >
		<script type="text/javascript">
		<!--
		function signinCallbackResult( media, onetime, success ){
		
		}		
		-->
		</script>
		</#if>		
		<#if action.getMenuComponent("USER_MENU") ?? >
		<#assign menu = action.getMenuComponent("USER_MENU") />			
				<nav class="navbar navbar-inverse navbar-fixed-top" role="navigation">
					<div class="container">
						<#if action.user.company ?? >
						<div class="navbar-header">					
							<button type="button" class="navbar-toggle" data-toggle="collapse" data-target="#navbar-ex1-collapse">
								<span class="sr-only">Toggle navigation</span>
								<span class="icon-bar"></span>
								<span class="icon-bar"></span>
								<span class="icon-bar"></span>
							</button>					
							<a class="navbar-brand" href="/main.do">&nbsp;&nbsp;${action.user.company.displayName }</a>
						</div>			
						</#if>												
						<div class="navbar-collapse collapse" id="navbar-ex1-collapse">
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
							<ul id="account-navbar" class="nav navbar-nav navbar-right"></ul>						
						</div>						
					</div>
				</nav>
			</#if>		
			<!-- END MENU -->		
			<!-- START My profile Modal -->
			<div class="modal fade" id="myModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
			</div><!-- /.modal -->					