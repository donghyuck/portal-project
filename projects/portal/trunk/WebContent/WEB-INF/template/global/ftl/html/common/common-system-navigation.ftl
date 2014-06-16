		<#assign menu = WebSiteUtils.getMenuComponent("SYSTEM_MENU") />			
		<div id="main-navbar" class="navbar navbar-inverse theme-default" role="navigation">
			<!-- Main menu toggle -->
			<button type="button" id="main-menu-toggle"><i class="navbar-icon fa fa-bars icon"></i><span class="hide-menu-text">HIDE MENU</span></button>
			<div class="navbar-inner">
				<!-- Main navbar header -->
				<div class="navbar-header">
					<!-- Logo -->
					<a href="${request.contextPath}/secure/main.do" class="navbar-brand">
					<!--<div><img alt="Pixel Admin" src="로고 이미지"></div>-->
					관리자 콘솔
					</a>
					<!-- Main navbar toggle -->
					<button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target="#main-navbar-collapse">
						<i class="navbar-icon fa fa-bars"></i>
					</button>
				</div> <!-- / .navbar-header -->
				<div id="main-navbar-collapse" class="collapse navbar-collapse main-navbar-collapse">
					<div>
						<ul class="nav navbar-nav">
							<li>
								<a href="#">사용자 홈</a>
							</li>
							<li class="dropdown">
								<a href="#" class="dropdown-toggle" data-toggle="dropdown">Dropdown</a>
								<ul class="dropdown-menu">
									<li><a href="#">First item</a></li>
									<li><a href="#">Second item</a></li>
									<li class="divider"></li>
									<li><a href="#">Third item</a></li>
								</ul>
							</li>
						</ul> <!-- / .navbar-nav -->
						<div class="right clearfix">
							<ul class="nav navbar-nav pull-right right-navbar-nav">
								<li class="nav-icon-btn nav-icon-btn-danger dropdown">
									<a href="#notifications" class="dropdown-toggle" data-toggle="dropdown">
										<span class="label">5</span>
										<i class="nav-icon fa fa-bullhorn"></i>
										<span class="small-screen-text">Notifications</span>
									</a>
									<!-- NOTIFICATIONS -->
									<div class="dropdown-menu widget-notifications no-padding" style="width: 300px">
										<div class="notifications-list" id="main-navbar-notifications">
											<div class="notification">
												<div class="notification-title text-danger">SYSTEM</div>
												<div class="notification-description"><strong>Error 500</strong>: Syntax error in index.php at line <strong>461</strong>.</div>
												<div class="notification-ago">12h ago</div>
												<div class="notification-icon fa fa-hdd-o bg-danger"></div>
											</div> <!-- / .notification -->
										</div> <!-- / .notifications-list -->
										<a href="#" class="notifications-link">MORE NOTIFICATIONS</a>
									</div> <!-- / .dropdown-menu -->
								</li>
								<li class="nav-icon-btn nav-icon-btn-success dropdown">
									<a href="#messages" class="dropdown-toggle" data-toggle="dropdown">
										<span class="label">10</span>
										<i class="nav-icon fa fa-envelope"></i>
										<span class="small-screen-text">Income messages</span>
									</a>
									<!-- MESSAGES -->								
									<!-- Javascript -->
									<script>
										//init.push(function () {
										//	$('#main-navbar-messages').slimScroll({ height: 250 });
										//});
									</script>
									<!-- / Javascript -->
									<div class="dropdown-menu widget-messages-alt no-padding" style="width: 300px;">
										<div class="messages-list" id="main-navbar-messages">
											<div class="message">
												<!--/*<img src="assets/demo/avatars/2.jpg" alt="" class="message-avatar">*/-->
												<a href="#" class="message-subject">Lorem ipsum dolor sit amet.</a>
												<div class="message-description">
													from <a href="#">Robert Jang</a>
													&nbsp;&nbsp;·&nbsp;&nbsp;
													2h ago
												</div>
											</div> <!-- / .message -->
										</div> <!-- / .messages-list -->
										<a href="#" class="messages-link">MORE MESSAGES</a>
									</div> <!-- / .dropdown-menu -->
								</li>
								<!-- /3. $END_NAVBAR_ICON_BUTTONS -->
								<li>
									<form class="navbar-form pull-left">
										<!--<input type="text" class="form-control" placeholder="Search">-->
										<div class="form-group">
										<input type="hidden" id="targetCompany" name="targetCompany" value="${action.targetCompany.companyId}" />
										</div>
									</form>
								</li>
								<li class="dropdown">
									<a href="#" class="dropdown-toggle user-menu" data-toggle="dropdown">
										<img src="/download/profile/system?width=100&height=150" alt/>
										<span>${action.user.name}</span>
									</a>
									<ul class="dropdown-menu">
										<li><a href="#"><span class="label label-warning pull-right">New</span> 프로파일</a></li>
										<li class="divider"></li>
										<li><a href="/logout"><i class="dropdown-icon fa fa-power-off"></i> 로그아웃</a></li>
									</ul>
								</li>
							</ul> <!-- / .navbar-nav -->
						</div> <!-- / .right -->
					</div>
				</div> <!-- / #main-navbar-collapse -->
			</div> <!-- / .navbar-inner -->
		</div> <!-- / #main-navbar -->			
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
						<a href="javascript:void(0);" data-menu-item="${item.name}"><#if item.isSetIcon()><i class="menu-icon fa ${item.icon}"></i> </#if><span class="mm-text">${item.title}</span></a>
						<ul>
							<#list item.components as sub_item >
								<#if sub_item.components?has_content >
								<li class="dropdown-submenu">
									<a href="#" class="dropdown-toggle" data-toggle="dropdown" data-menu-item="${sub_item.name}"><span class="mm-text">${sub_item.title}</span></a>
									<ul class="dropdown-menu">
									<#list sub_item.components as sub_sub_item >
										<li><a href="${sub_sub_item.page}" data-menu-item="${sub_sub_item.name}"> <span class="mm-text">${ sub_sub_item.title }</span></a></li>
									</#list>
									</ul>
								</li>
								<#else>								
									<li><a tabindex="-1" href="${sub_item.page}" data-menu-item="${sub_item.name}"><span class="mm-text">${sub_item.title}</span></a></li>
								</#if>								
							</#list>
						</ul>					
					</li>
					<#else>
					<li>
						<a href="${item.page}" data-menu-item="${item.name}"><#if item.isSetIcon()><i class="menu-icon fa ${item.icon}"></i> </#if><span class="mm-text">${item.title}</span></a>
					</li>
					</#if>
				</#list>						
				</ul> <!-- / .navigation -->
				<div class="menu-content">
					<h6 class="text-light-gray text-semibold text-xs" style="margin:20px 0 10px 0;">목록 자동 숨기기</h6>
					<input type="checkbox" id="list-switcher" data-class="switcher-primary">	
				</div>
			</div> <!-- / #main-menu-inner -->
		</div> <!-- / #main-menu -->
		<!-- /2. $END_MAIN_NAVIGATION -->		