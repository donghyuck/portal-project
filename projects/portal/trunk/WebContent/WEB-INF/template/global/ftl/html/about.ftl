<#ftl encoding="UTF-8"/>
<html decorator="homepage">
<head>
		<title>기업소개</title>
		<script type="text/javascript">
		<!--
		yepnope([{
			load: [
			'css!${request.contextPath}/styles/font-awesome/4.0.3/font-awesome.min.css',
			'css!${request.contextPath}/styles/common/common.timeline.css',
			'${request.contextPath}/js/jquery/1.10.2/jquery.min.js',
			'${request.contextPath}/js/jgrowl/jquery.jgrowl.min.js',
			'${request.contextPath}/js/kendo/kendo.web.min.js',
			'${request.contextPath}/js/kendo.extension/kendo.ko_KR.js',			
			'${request.contextPath}/js/kendo/cultures/kendo.culture.ko-KR.min.js',		
			'${request.contextPath}/js/bootstrap/3.1.0/bootstrap.min.js',
			'${request.contextPath}/js/common/common.models.js',			
			'${request.contextPath}/js/common/common.api.js',
			'${request.contextPath}/js/common/common.ui.js'],
			complete: function() {
			
				// 1.  한글 지원을 위한 로케일 설정
				kendo.culture("ko-KR");
				      
				// START SCRIPT	

				// ACCOUNTS LOAD	
				var currentUser = new User();			
				$("#account-navbar").extAccounts({
					externalLoginHost: "${ServletUtils.getLocalHostAddr()}",	
					<#if CompanyUtils.isallowedSignIn(action.company) ||  !action.user.anonymous  || action.view! == "personalized" >
					template : kendo.template($("#account-template").html()),
					</#if>
					authenticate : function( e ){
						e.token.copy(currentUser);
					}				
				});	
				
				
				// Start : Company Social Content 
				<#list action.connectedCompanySocialNetworks  as item >				
				<#assign stream_name = item.serviceProviderName + "_streams_" + item.socialAccountId  />	
				<#assign panel_element_id = "#" + item.serviceProviderName + "-panel-" + item.socialAccountId  />	
											
				var ${stream_name} = new MediaStreams(${ item.socialAccountId}, "${item.serviceProviderName}" );							
				<#if  item.serviceProviderName == "twitter" >
				${stream_name}.setTemplate ( kendo.template($("#twitter-timeline-template").html()) );				
				<#elseif  item.serviceProviderName == "facebook" >
				${stream_name}.setTemplate( kendo.template($("#facebook-homefeed-template").html()) );
				</#if>
				${stream_name}.createDataSource({ 
					transport : {
						parameterMap : function ( options,  operation) {
							return { objectType : 1 };
						} 
					}
				});
							
				${stream_name}.dataSource.read();
				
				$( "${panel_element_id} .panel-header-actions a").each(function( index ) {
					var header_action = $(this);
					header_action.click(function (e){
						e.preventDefault();		
						var header_action_icon = header_action.find('span');
						if (header_action.text() == "Minimize" || header_action.text() == "Maximize"){
							$("${panel_element_id} .panel-body").toggleClass("hide");				
							if( header_action_icon.hasClass("k-i-maximize") ){
								header_action_icon.removeClass("k-i-maximize");
								header_action_icon.addClass("k-i-minimize");
							}else{
								header_action_icon.removeClass("k-i-minimize");
								header_action_icon.addClass("k-i-maximize");
							}
						} else if (header_action.text() == "Refresh"){								
							${stream_name}.dataSource.read();							
						} 
					});								
				});				
				</#list>	
				<#if !action.user.anonymous >							
				</#if>	
				// END SCRIPT            
			}
		}]);	
		-->
		</script>		
		<style scoped="scoped">
		blockquote p {
			font-size: 15px;
		}

		.k-grid table tr.k-state-selected{
			background: #428bca;
			color: #ffffff; 
		}
		
		#announce-view .popover {
			position : relative;
			max-width : 500px;
		}
		.cbp_tmtimeline > li .cbp_tmicon { 
			position : relative;
		}
					
						
		</style>   	
	</head>
	<body class="color0">
		<!-- START HEADER -->
		<#include "/html/common/common-homepage-menu.ftl" >	
		<#assign current_menu = action.getWebSiteMenu("USER_MENU", "MENU_1_1") />
		<header class="cloud">
			<div class="container">
				<div class="col-lg-12">	
					<h1>${ current_menu.title }</h1>
					<h4><i class="fa fa-quote-left"></i>&nbsp; ${action.webSite.company.displayName}를 소개합니다.&nbsp;<i class="fa fa-quote-right"></i></h4>
				</div>
			</div>
		</header>				
		<!-- END HEADER -->					
		<!-- START MAIN CONTENT -->	
		<div class="container layout">	
			<div class="row">
				<div class="col-lg-3 visible-lg">
					<!-- start side menu -->		
					<div class="list-group">
					<#list current_menu.parent.components as item >
						<#if item.name ==  current_menu.name >
						<a href="${item.page}" class="list-group-item active">${ item.title } </a>
						<#else>
						<a href="${item.page}" class="list-group-item">${ item.title } </a>
						</#if>						
					</#list>										
					</div>	
					<!-- end side menu -->					
				</div>
				<div class="col-lg-9">
					<div class="row">
						<div class="col-sm-12">					
							<ul class="nav nav-tabs">
								<li class="active"><a href="#company-history" data-toggle="tab">회사연역</a></li>
								<li><a href="#company-media" data-toggle="tab">쇼셜미디어</a></li>
							</ul>
							<!-- Tab panes -->
							<div class="tab-content">
								<div class="tab-pane active" id="company-history">
									<div class="blank-top-5"></div>
									<div class="panel panel-default panel-flat">
										<!--<div class="panel-heading">회사 연혁</div>-->
										<div class="panel-body scrollable" style="max-height:400px;">
											<ul class="cbp_tmtimeline">
												<li>
													<time class="cbp_tmtime" datetime="2013-04-10 18:30"><span>4/10/13</span> <span>18:30</span></time>
													<div class="cbp_tmicon cbp_tmicon-phone"></div>
													<div class="cbp_tmlabel">
														<h2>Ricebean black-eyed pea</h2>
														<p>Winter purslane courgette pumpkin quandong komatsuna fennel green bean cucumber watercress. Pea sprouts wattle seed rutabaga okra yarrow cress avocado grape radish bush tomato ricebean black-eyed pea maize eggplant. Cabbage lentil cucumber chickpea sorrel gram garbanzo plantain lotus root bok choy squash cress potato summer purslane salsify fennel horseradish dulse. Winter purslane garbanzo artichoke broccoli lentil corn okra silver beet celery quandong. Plantain salad beetroot bunya nuts black-eyed pea collard greens radish water spinach gourd chicory prairie turnip avocado sierra leone bologi.</p>
													</div>
												</li>
												<li>
													<time class="cbp_tmtime" datetime="2013-04-11T12:04"><span>4/11/13</span> <span>12:04</span></time>
													<div class="cbp_tmicon cbp_tmicon-screen"></div>
													<div class="cbp_tmlabel">
														<h2>Greens radish arugula</h2>
														<p>Caulie dandelion maize lentil collard greens radish arugula sweet pepper water spinach kombu courgette lettuce. Celery coriander bitterleaf epazote radicchio shallot winter purslane collard greens spring onion squash lentil. Artichoke salad bamboo shoot black-eyed pea brussels sprout garlic kohlrabi.</p>
													</div>
												</li>
												<li>
													<time class="cbp_tmtime" datetime="2013-04-13 05:36"><span>4/13/13</span> <span>05:36</span></time>
													<div class="cbp_tmicon cbp_tmicon-mail"></div>
													<div class="cbp_tmlabel">
														<h2>Sprout garlic kohlrabi</h2>
														<p>Parsnip lotus root celery yarrow seakale tomato collard greens tigernut epazote ricebean melon tomatillo soybean chicory broccoli beet greens peanut salad. Lotus root burdock bell pepper chickweed shallot groundnut pea sprouts welsh onion wattle seed pea salsify turnip scallion peanut arugula bamboo shoot onion swiss chard. Avocado tomato peanut soko amaranth grape fennel chickweed mung bean soybean endive squash beet greens carrot chicory green bean. Tigernut dandelion sea lettuce garlic daikon courgette celery maize parsley komatsuna black-eyed pea bell pepper aubergine cauliflower zucchini. Quandong pea chickweed tomatillo quandong cauliflower spinach water spinach.</p>
													</div>
												</li>
												<li>
													<time class="cbp_tmtime" datetime="2013-04-15 13:15"><span>4/15/13</span> <span>13:15</span></time>
													<div class="cbp_tmicon cbp_tmicon-phone"></div>
													<div class="cbp_tmlabel">
														<h2>Watercress ricebean</h2>
														<p>Peanut gourd nori welsh onion rock melon mustard j챠cama. Desert raisin amaranth kombu aubergine kale seakale brussels sprout pea. Black-eyed pea celtuce bamboo shoot salad kohlrabi leek squash prairie turnip catsear rock melon chard taro broccoli turnip greens. Fennel quandong potato watercress ricebean swiss chard garbanzo. Endive daikon brussels sprout lotus root silver beet epazote melon shallot.</p>
													</div>
												</li>
												<li>
													<time class="cbp_tmtime" datetime="2013-04-16 21:30"><span>4/16/13</span> <span>21:30</span></time>
													<div class="cbp_tmicon cbp_tmicon-earth"></div>
													<div class="cbp_tmlabel">
														<h2>Courgette daikon</h2>
														<p>Parsley amaranth tigernut silver beet maize fennel spinach. Ricebean black-eyed pea maize scallion green bean spinach cabbage j챠cama bell pepper carrot onion corn plantain garbanzo. Sierra leone bologi komatsuna celery peanut swiss chard silver beet squash dandelion maize chicory burdock tatsoi dulse radish wakame beetroot.</p>
													</div>
												</li>
												<li>
													<time class="cbp_tmtime" datetime="2013-04-17 12:11"><span>4/17/13</span> <span>12:11</span></time>
													<div class="cbp_tmicon cbp_tmicon-screen"></div>
													<div class="cbp_tmlabel">
														<h2>Greens radish arugula</h2>
														<p>Caulie dandelion maize lentil collard greens radish arugula sweet pepper water spinach kombu courgette lettuce. Celery coriander bitterleaf epazote radicchio shallot winter purslane collard greens spring onion squash lentil. Artichoke salad bamboo shoot black-eyed pea brussels sprout garlic kohlrabi.</p>
													</div>
												</li>
												<li>
													<time class="cbp_tmtime" datetime="2013-04-18 09:56"><span>4/18/13</span> <span>09:56</span></time>
													<div class="cbp_tmicon cbp_tmicon-phone"></div>
													<div class="cbp_tmlabel">
														<h2>Sprout garlic kohlrabi</h2>
														<p>Parsnip lotus root celery yarrow seakale tomato collard greens tigernut epazote ricebean melon tomatillo soybean chicory broccoli beet greens peanut salad. Lotus root burdock bell pepper chickweed shallot groundnut pea sprouts welsh onion wattle seed pea salsify turnip scallion peanut arugula bamboo shoot onion swiss chard. Avocado tomato peanut soko amaranth grape fennel chickweed mung bean soybean endive squash beet greens carrot chicory green bean. Tigernut dandelion sea lettuce garlic daikon courgette celery maize parsley komatsuna black-eyed pea bell pepper aubergine cauliflower zucchini. Quandong pea chickweed tomatillo quandong cauliflower spinach water spinach.</p>
													</div>
												</li>
											</ul>							
										</div>
									</div>
								</div>
								<div class="tab-pane" id="company-media">
									<div id="social-media-area" class="row">
										<#list action.connectedCompanySocialNetworks  as item >	
										<div class="col-sm-6">						
											<div class="blank-top-5"></div>
											<div id="${item.serviceProviderName}-panel-${item.socialAccountId}" class="panel panel-default panel-flat">
												<div class="panel-heading">
													<i class="fa fa-${item.serviceProviderName}"></i>&nbsp;${item.serviceProviderName}
													<div class="k-window-actions panel-header-actions">
														<a role="button" href="#" class="k-window-action k-link"><span role="presentation" class="k-icon k-i-refresh">Refresh</span></a>
														<a role="button" href="#" class="k-window-action k-link"><span role="presentation" class="k-icon k-i-minimize">Minimize</span></a>
														<a role="button" href="#" class="k-window-action k-link hide"><span role="presentation" class="k-icon k-i-maximize">Maximize</span></a>
														<a role="button" href="#" class="k-window-action k-link hide"><span role="presentation" class="k-icon k-i-close">Close</span></a>
													</div>
												</div>		
												<div class="panel-body scrollable" style="min-height:200px; max-height:500px;">
													<ul class="media-list">
														<div id="${item.serviceProviderName}-streams-${item.socialAccountId}">&nbsp;</div>
													</ul>
												</div>							
											</div>										
										</div>
										</#list>												
									</div>
								</div>
							</div>
						</div>
					</div>					
				</div>				
			</div>
		</div>			
		
		
		<div class="overlay overlay-hugeinc hide">
			<button type="button" class="overlay-close">Close</button>
			<nav>
				<ul>
					<li><a href="#">Home</a></li>
					<li><a href="#">About</a></li>
					<li><a href="#">Work</a></li>
					<li><a href="#">Clients</a></li>
					<li><a href="#">Contact</a></li>
				</ul>
			</nav>
		</div>

								 
		<!-- END MAIN CONTENT -->	
 		<!-- START FOOTER -->
		<#include "/html/common/common-homepage-footer.ftl" >		
		<!-- END FOOTER -->	
		<!-- START TEMPLATE -->
		<#include "/html/common/common-homepage-templates.ftl" >		
		<!-- END TEMPLATE -->
	</body>    
</html>