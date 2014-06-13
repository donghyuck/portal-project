		<!-- start of personalized menu -->
		<nav class="personalized-navbar navbar" role="navigation">
			<div class="container">
				<ul class="nav navbar-nav navbar-left">				
					<p class="navbar-text hidden-xs">&nbsp;</p>	
					<p class="navbar-text hidden-xs text-primary"><small>위젯 레이아웃</small></p>	
					<li class="navbar-btn hidden-xs">
						<div class="btn-group navbar-btn" data-toggle="buttons">
							<label class="btn btn-info">
								<input type="radio" name="personalized-area-col-size" value="12"><i class="fa fa-square"></i>
							</label>
							<label class="btn btn-info active">
						 		<input type="radio" name="personalized-area-col-size"  value="6"> <i class="fa fa-th-large"></i>
							</label>
							<#if "${action.view}" != 'manage'  >
							<label class="btn btn-info">
								<input type="radio" name="personalized-area-col-size"  value="4"> <i class="fa fa-th"></i>
							</label>
							</#if>
						</div>
					</li>
				</ul>
				<ul class="nav navbar-nav navbar-right">		
					<p class="navbar-text hidden-xs">&nbsp;</p>
					<li class="dropdown">
						<a href="#" class="dropdown-toggle" data-toggle="dropdown">My <i class="fa fa-angle-down"></i></a>
						<ul class="dropdown-menu">
							<li><a href="${request.contextPath}/main.do?view=personalized">My 페이지</a></li>
							<li><a href="${request.contextPath}/main.do?view=streams">My 스트림</a></li>
							<#if request.isUserInRole("ROLE_ADMIN") || request.isUserInRole("ROLE_SITE_ADMIN") >
							<li class="divider"></li>
							<li><a href="${request.contextPath}/main.do?view=manage-company">My 회사</a></li>
							<li><a href="${request.contextPath}/main.do?view=manage-website">My 웹사이트</a></li>
							<li><a href="${request.contextPath}/main.do?view=manage-forum">My 게시판</a></li>
							</#if>								
						</ul>
					</li>
					<#if "${action.view}" == "manage"  >					
					<li><a href="#" class="btn btn-link btn-control-group" data-action="open-spmenu"><i class="fa fa-briefcase fa-lg"></i></a></li>
					<#elseif "${action.view}"== "streams">	
					<li><a href="#" class="btn btn-link btn-control-group" data-action="open-spmenu"><i class="fa fa-cog fa-lg"></i></a></li>
					<#else>	
					<li><a href="#" class="btn btn-link btn-control-group" data-action="open-spmenu"><i class="fa fa-cloud fa-lg"></i></a></li>			
					</#if>					
					<li><a href="#" class="btn btn-link btn-control-group" data-action="hide"><i class="fa fa-angle-double-up fa-lg"></i></a></li>
					<p class="navbar-text hidden-xs">&nbsp;</p>
				</ul>
			</div>
		</nav>
		<!-- end of personalized menu -->