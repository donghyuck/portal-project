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
							<li><a href="<@spring.url '/accounts/login?ver=1'/>">로그인</a></li>   
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
							<a class="navbar-brand" href="/">
								<img id="logo-header" src="<@spring.url '/download/logo/company/${action.webSite.company.name}'/>" height="42" class="img-circle" alt="Logo">
							</a>
						</div>	
						<div class="collapse navbar-collapse navbar-responsive-collapse ">
							<ul class="nav navbar-nav navbar-left">
				<#list webSiteMenu.components as item >
					<#if WebSiteUtils.isUserAccessAllowed(item) >
						<#if  item.components?has_content >
							<#if item.layout?? && item.layout == "mega-menu">			
								<li class="dropdown mega-menu-fullwidth" data-menu-item="${item.name}">
									<a href="javascript:void(0);" class="dropdown-toggle" data-toggle="dropdown" ><#if item.icon?? ><i class="fa ${item.icon} fa-lg"></i></#if> ${item.title}</a>
									<ul class="dropdown-menu">
										<li>
											<div class="mega-menu-content">
												<div class="container">
													<div class="row">													
														<div class="col-md-3 col-sm-12 col-xs-12 md-margin-bottom-30">
                                                    		<h3 class="mega-menu-heading">Pellentes que nec diam lectus</h3>
                                                    		<#if item.description ??>
                                                    		<p>${item.description}</p>
                                                    		</#if>
                                                    		<#if item.module ?? && item.module == "my-cloud">
                                                    		<img src="<@spring.url '/images/common/cloud_swiss_army_knife_nobg.png'/>" class="img-responsive"/>
                                                    		<button type="button" class="btn-u btn-u-dark">Read More</button>
                                                    		</#if>
                                                		</div>
														<#list item.components as sub_item>
															<#if sub_item.components?has_content >
															<div class="col-md-3 col-sm-12 col-xs-12 md-margin-bottom-30 no-border">
															1
															</div>		
															<#else>
															<div class="col-md-3 col-sm-4 col-xs-4 md-margin-bottom-30 no-border">
																<h3 class="mega-menu-heading">${ sub_item.title }</h3>	
																<#if sub_item.description ??>
																<p>${sub_item.description}</p>
																</#if>		
																<a href="${sub_item.page}"><#if sub_item.icon?? ><i class="${sub_item.icon}"></i></#if></a>																														
															</div>		
															</#if>
														</#list>
													</div>
												
												</div>
											</div>
										</li>	
									</ul>
								</li>
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
				</#list>		
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