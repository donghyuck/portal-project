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
				<#assign webSite = action.webSite />				
				<#assign webSiteMenu = action.getWebSiteMenu("USER_MENU") />
			<div class="header">
				<div class="topbar">
					<div class="container">
						<!-- Topbar Navigation -->
						<ul id="u-navbar" class="loginbar pull-right">
							<li class="languagesSelector">
								<i class="fa fa-globe"></i>
								<a>언어</a>
								<ul class="languages">
									<li class="active">
										<a href="#">한국어 <i class="fa fa-check"></i></a> 
									</li>
								</ul>
							</li>
							<li class="topbar-devider"></li>   
							<li><a href="page_faq.html">도움말</a></li>  
							<li>
							<a href="#" data-feature-name="u-accounts" class="u-accounts" style="display:none;">
								<span class="u-accounts-photo" style="background-image: url( '<@spring.url "/images/common/anonymous.png"/>' );"></span>
								<span class="u-accounts-name"></span>
							</a>			
							</li>
							<#if action.user.anonymous >
							<li class="topbar-devider"></li>   
							<li><a href="<@spring.url '/accounts/login.do?ver=1'/>">로그인</a></li>   
							<li class="topbar-devider"></li>   
							<li><a href="<@spring.url '/accounts/login.do?ver=1'/>">회원가입</a></li>   
							</#if>
						</ul>
						<!-- End Topbar Navigation -->
					</div>
				</div>
				<nav class="navbar navbar-default mega-menu" role="navigation">
					<div class="container">
						<!-- Brand and toggle get grouped for better mobile display -->
						<div class="navbar-header">
							<button type="button" class="navbar-toggle" data-toggle="collapse" data-target=".navbar-responsive-collapse">								
								<span class="sr-only">${webSite.description} toggle navigation</span>
								<span class="fa fa-bars"></span>
							</button>
							<!--
							<a href="#" class="navbar-toggle-account visible-xs no-padding no-border">
								<#if action.user.anonymous > 
									<img src="<@spring.url '/images/common/anonymous.png'/>" height="34"/>	
								<#else> 
									<img src="<@spring.url '/download/profile/${action.user.username}?width=100&height=150'/>" class="rounded-top" height="34">
								</#if>		
							</a>				
							-->			
							<a class="navbar-brand" href="/main.do">
								<img id="logo-header" src="<@spring.url '/download/logo/company/${action.webSite.company.name}'/>" height="42" class="img-circle" alt="Logo">
							</a>
						</div>										
								
						<!-- Collect the nav links, forms, and other content for toggling -->
						<div class="collapse navbar-collapse navbar-responsive-collapse ">
							<!--<ul id="account-navbar" class="nav navbar-nav navbar-right hidden-xs" style="display:none;"></ul>-->
							<!-- /account -->
							<ul class="nav navbar-nav navbar-left">
				<#list webSiteMenu.components as item >
					<#if WebSiteUtils.isUserAccessAllowed(item) >
						<#if  item.components?has_content >
							<#if item.layout??>
								<#if item.layout == "pills" >									
								<li data-menu-item="${item.name}">
									<a href="${item.page}"><#if item.icon?? ><i class="fa ${item.icon}"></i></#if> ${item.title}</a>
								</li>						
								<#elseif item.layout == "mega-menu">
								<li class="dropdown mega-menu-fullwidth" data-menu-item="${item.name}">
									<a href="javascript:void(0);" class="dropdown-toggle" data-toggle="dropdown" ><#if item.icon?? ><i class="fa ${item.icon} fa-lg"></i></#if> ${item.title}</a>
									<ul class="dropdown-menu">
										<li>
											<div class="mega-menu-content disable-icons">
												<div class="container">
													<div class="row equal-height">													
														<#list item.components as sub_item>														
														<div class="col-md-3 equal-height-in">
															<ul class="list-unstyled equal-height-list">
															
															<!--
																<#if sub_item.components?has_content >	
																<li><h3><#if sub_item.icon?? ><i class="fa fa-${sub_item.icon}"></i></#if> ${sub_item.title}</h3></li>
																<#list sub_item.components as sub_sub_item >
																<li data-menu-item="${sub_sub_item.name}"><a href="${sub_sub_item.page}">${ sub_sub_item.title }</a></li>																
																</#list>
																<#else>
																<li data-menu-item="${sub_item.name}">
																	<a href="${sub_item.page}"><#if sub_item.icon?? ><i class="fa fa-${sub_item.icon}"></i></#if> ${ sub_item.title }</a>																	
																</li>
																<#if sub_item.description ??>
																<li>	
																	<h3>
																	<small>
																	${sub_item.description}
																	</small>
																	</h3>	
																</li>		
																</#if>
																</#if>
															-->
															
																
															</ul>
														</div>														
														</#list>
														
																											
													</div>
												</div>
											</div>
										</li>	
									</ul>
								</li>
								</#if>
							<#else>
								<li class="dropdown" data-menu-item="${item.name}">
									<a href="javascript:void(0);" class="dropdown-toggle" data-toggle="dropdown" ><#if item.icon?? ><i class="fa ${item.icon} fa-lg"></i></#if> ${item.title}</a>
									<ul class="dropdown-menu">
									<#list item.components as sub_item >											
										<#if sub_item.components?has_content >												
										<li class="dropdown-submenu" data-menu-item="${sub_item.name}">
											<a href="#" class="dropdown-toggle" data-toggle="dropdown"><#if sub_item.icon?? ><i class="fa ${sub_item.icon}"></i></#if> ${sub_item.title}</a>
												<ul class="dropdown-menu">
													<#list sub_item.components as sub_sub_item >
													<li data-menu-item="${sub_sub_item.name}"><a href="${sub_item.page}">${ sub_sub_item.title }</a></li>
													</#list>
												</ul>
											</li>
										<#else>								
											<li><a href="${sub_item.page}"><#if sub_item.icon?? ><i class="fa ${sub_item.icon}"></i></#if> ${sub_item.title}</a></li>
										</#if>								
									</#list>
									</ul>
								</li>											
							</#if>
							<!-- ./item.layout -->									
						<#else>
							<li>
								<a href="${item.page}"><#if item.icon?? ><i class="fa ${item.icon}"></i></#if> ${item.title}</a>
							</li>								
						</#if>
					</#if>		
				</#list>			<!--
								<li>
									<a href="#" data-feature-name="u-accounts" class="u-accounts" style="display:none;">
										<span style="padding-right: 5px;"><i class="fa fa-caret-left"></i></span>					
										<span class="u-accounts-photo" style="background-image: url( '<@spring.url "/images/common/anonymous.png"/>' );"></span>
										<span class="u-accounts-name"></span>
										<i class="setting fa fa-outdent"></i>
									</a>
								</li>-->
							</ul>				
						</div>						
					</div>
				</nav><!-- /.topbar -->
				<!--<span class="v-header-shadow"></span>-->
			</div><!-- /.header -->
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