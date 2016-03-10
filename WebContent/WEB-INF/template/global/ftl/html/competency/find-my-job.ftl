<#ftl encoding="UTF-8"/>
<html decorator="unify">
	<head>
		<#assign page = action.getPage() >		
		<title>${page.title}</title>
		<#compress>		
		<script type="text/javascript">
		<!--
		var jobs = [];	
				
		yepnope([{
			load: [
			'css!<@spring.url "/styles/font-awesome/4.3.0/font-awesome.min.css"/>',
			'css!<@spring.url "/styles/bootstrap.themes/unify/1.9.1/headers/header-v6.css"/>',	
			'css!<@spring.url "/styles/bootstrap.themes/unify/1.9.1/theme-colors/default.css"/>',	
			'css!<@spring.url "/styles/bootstrap.themes/unify/1.9.1/theme-skins/dark.css"/>',
			'css!<@spring.url "/styles/bootstrap.themes/unify/1.9.1/pages/profile.min.css"/>',
			'css!<@spring.url "/styles/bootstrap.themes/unify/1.9.1/pages/page_job.css"/>',
			'css!<@spring.url "/styles/jquery.sliding-panel/jquery.sliding-panel.css"/>',	
			'css!<@spring.url "/styles/common.ui/common.ui.color-icons.css"/>',	
			'css!<@spring.url "/styles/common.ui.pages/assessment.style.css"/>',
			'css!<@spring.url "/styles/common.plugins/animate.min.css"/>',				
			'css!<@spring.url "/styles/bootstrap.themes/common/common.ui.buttons.css"/>',
			'css!<@spring.url "/styles/bootstrap.themes/common/common.ui.inspinia.css"/>',		
			'css!<@spring.url "/styles/jquery.sky-forms/2.0.1/custom-sky-forms.css"/>',			
			'css!<@spring.url "/styles/hover-effect/hover-min.css"/>',
			
			'<@spring.url "/js/jquery/1.10.2/jquery.min.js"/>',
			'<@spring.url "/js/jgrowl/jquery.jgrowl.min.js"/>',
			'<@spring.url "/js/jquery.sliding-panel/jquery.sliding-panel.js"/>',
			'<@spring.url "/js/kendo/kendo.web.min.js"/>',
			'<@spring.url "/js/kendo.extension/kendo.ko_KR.js"/>',			
			'<@spring.url "/js/kendo/cultures/kendo.culture.ko-KR.min.js"/>',		
			'<@spring.url "/js/bootstrap/3.3.4/bootstrap.min.js"/>',
			'<@spring.url "/js/common.plugins/query.backstretch.min.js"/>',
			'<@spring.url "/js/jquery.masonry/masonry.pkgd.min.js"/>',		
			'<@spring.url "/js/imagesloaded/imagesloaded.pkgd.min.js"/>',	
			'<@spring.url "/js/wow/wow.min.js"/>', , 
			'<@spring.url "/js/common/common.ui.core.js"/>',							
			'<@spring.url "/js/common/common.ui.data.js"/>',
			'<@spring.url "/js/common/common.ui.data.competency.js"/>',
			'<@spring.url "/js/common/common.ui.community.js"/>'],
			complete: function() {		
				
				common.ui.setup({
					features:{
						wow:true,
						wallpaper : true,
						accounts : {
							render : false,
							authenticate : function(e){
								e.token.copy(currentUser);
								currentUser.set('visible',true);								
							} 
						}						
					},
					wallpaper : {
						renderTo:$(".promo-bg-img-v2")
					},	
					jobs:jobs
				});	
				handleHeader();				
				// ACCOUNTS LOAD			
				var currentUser = new common.ui.data.User();	
				kendo.bind( $(".accounts-user-profile"), currentUser);	
				getClassifiedMajoritySelector();		
				createJobListView();
				// END SCRIPT 				
			}
		}]);	
		function getCurrentUser () {
			return common.ui.accounts().token ;
		}
		
		function getClassifiedMajoritySelector(){
			var renderTo = $("#classified-majority");
			if( !renderTo.data('kendoDropDownList') ){
				renderTo.kendoDropDownList({
					cascadeFrom: "classify-type-dorpdown-list",
					optionLabel: "1. 관심있는 직업분야는 무엇인가요?",
					dataTextField: 'name',	
					dataValueField: 'codeSetId',		
					height: 500,			 
					template: '<i class="icon-flat icon-svg icon-svg-sm basic-color-open-folder"></i>' +
                              '<span class="k-state-default">#: data.name #</span>',					 
					dataSource: {
						serverFiltering: true,
						transport: {
							read: {
								dataType: 'json',
								url: '/data/me/competency/job/category/list.json?output=json',
								type: 'POST'
							},
							parameterMap: function (options, operation){
								return { "codeSetId" :  1 }; 
							}
						},
						schema: { 
							model : common.ui.data.competency.CodeSet
						}
					}				
				});				
				getClassifiedMiddleSelector();
				getClassifiedMinoritySelector();
			}
			return renderTo.data('kendoDropDownList');
		}

		function getClassifiedMiddleSelector(){
			var renderTo = $("#classified-middle");
			if( !renderTo.data('kendoDropDownList') ){
				renderTo.kendoDropDownList({
					cascadeFrom: "classified-majority",
					optionLabel: "2. 좀더 관심있는 분야는 무엇인가요?",
					dataTextField: 'name',	
					dataValueField: 'codeSetId',
					height: 500,
					template: '<i class="icon-flat icon-svg icon-svg-sm basic-color-open-folder"></i>' +
                              '<span class="k-state-default">#: data.name #</span>',						
					dataSource: {
						serverFiltering:true,
						transport: {
							read: {
								dataType: 'json',
								url: '/data/me/competency/job/category/list.json?output=json',
								type: 'POST'
							},
							parameterMap: function (options, operation){
								return { "codeSetId" :  options.filter.filters[0].value }; 
							}
						},
						schema: { 
							model : common.ui.data.competency.CodeSet
						}
					}				
				});
			}
			return renderTo.data('kendoDropDownList');
		}
		function getClassifiedMinoritySelector(){
		
			var renderTo = $("#classified-minority");			
			if( !renderTo.data('kendoDropDownList') ){
				renderTo.kendoDropDownList({
					cascadeFrom: "classified-middle",
					optionLabel: "3. 조금더 자세하게 알려주세요.",
					dataTextField: 'name',	
					dataValueField: 'codeSetId',
					height: 500,
					dataSource: {
						serverFiltering:true,
						transport: {
							read: {
								dataType: 'json',
								url: '/data/me/competency/job/category/list.json?output=json',
								type: 'POST'
							},
							parameterMap: function (options, operation){
								return { "codeSetId" :  options.filter.filters[0].value }; 
							}
						},
						schema: { 
							model : common.ui.data.competency.CodeSet
						}
					}				
				});
			}
			return renderTo.data('kendoDropDownList');
		}			
		
		function createJobListView(){
			var renderTo = $("#job-listview");
			if( !renderTo.data('masonry')){			
				renderTo.masonry({	
					columnWidth: '.item',
					//gutter: 10,
					itemSelector: '.item',
					isResizable:true,
					transitionDuration: 0
				});
			}	
			
			if(! common.ui.exists(renderTo) ){		
				var masonry = renderTo.data('masonry');				
				common.ui.listview(renderTo, {
					autoBind:false,
					dataSource: {
						transport: { 
							read: { url:'/data/me/competency/job/list.json?output=json', type:'post' },
							parameterMap: function (options, operation){
								if (operation !== "read") {
									return kendo.stringify(options);
								} 
								return {
									classifiedMajorityId:getClassifiedMajoritySelector().value(),
									classifiedMiddleId:getClassifiedMiddleSelector().value(),
									classifiedMinorityId:getClassifiedMinoritySelector().value(),						
									startIndex:options.skip, 
									pageSize: options.pageSize 
								};
							}
						},						
						batch: false, 
						pageSize: 15,
						serverPaging: true,
						schema: {
							data: "items",
							total: "totalCount",
							model: common.ui.data.competency.Competency
						}
					},
					dataBound: function(){		
						var elem = 	this.element.children();	
						elem.imagesLoaded(function(){
							console.log("image loaded...");
							masonry.appended(elem);
							masonry.layout();
						});               		           	
                	},
					template: kendo.template($("#job-template").html())
				});
				renderTo.removeClass("k-widget k-listview");
				$(".job-search-btn").click(function(e){
					console.log("searching...");
					common.ui.listview(renderTo).dataSource.read();
				});
			}
		}	
					
		// Fixed Header
		function handleHeader() {
			jQuery(window).scroll(function() {
			  if (jQuery(window).scrollTop() > 100) {
				jQuery('.header-fixed .header-sticky').addClass('header-fixed-shrink');
			  } else {
				jQuery('.header-fixed .header-sticky').removeClass('header-fixed-shrink');
			  }
			});
		}
						
		-->
		</script>		
		<style scoped="scoped">	
				
		/** Breadcrumbs */
		.promo-bg-img-v2 {
			background: url( ${page.getProperty( "breadcrumbs.imageUrl", "")}) no-repeat;
			background-size: cover;
			background-position: center center;			
		}		 
		.promo-bg-fixed p {
			color:#f5f5f5;
		}
		
		.arrow-up:after {
			border-bottom: 20px solid #f5f5f5;
		}
		
		.job-search-btn {
			background: transparent;
		    border: 0;
		    height: 45px;
		    padding: 0;
		    margin: 0;
		 /*   margin-top: -15px;*/
		}
		.job-search-btn > i.icon-svg{
			width:90px;
			height:90px;
		}
		
		
		.easy-block-v1{
			padding-left : 5px;
			padding-right : 5px;
			background-color:#fff;
			-webkit-box-shadow: 0 1px 2px 0 rgba(0,0,0,0.22);
	    	box-shadow: 0 1px 2px 0 rgba(0,0,0,0.22);
	    	border-radius: 6px!important;
		}
		/* kendo listbox styling */
		span[role=listbox].k-dropdown {
			background:transparent;
		}
		
		.k-dropdown > .k-dropdown-wrap.k-state-default, .k-dropdown > .k-dropdown-wrap.k-state-disabled
		{
			border-radius : 2px;
		}
		
		ul.k-list > li.k-item:hover 
		{
			border: solid 1px #fc756f;
			background: #fc756f;
			color: #fff;	
		}               
		
		.k-dropdown .k-state-hover .k-input, .k-dropdown .k-state-hover .k-select {
			color: #787878!important;
		}
		
		ul.k-list > li.k-item.k-state-selected{
			border: solid 1px #fc756f;
			background: #fc756f;
			color: #fff;
		}

		
		.k-dropdown-wrap.k-state-hover, .k-dropdown-wrap.k-state-focused {
			color: #fc756f!important;
			background: #fff!important;					
		} 
		
		
		.k-list-optionlabel {
			color: #787878!important;
			background : #f5f5f5!important;
			border: 1px solid #fff!important;
			font-size:.8em;
		}		
		.k-list-optionlabel.k-state-hover{
			color: #787878;
			background : #f5f5f5!important;
			border: 1px solid #fff;		
		}
	    
	  	ul.k-list > li.k-item > i.icon-flat
	    {
		    display: inline-block!important;
		    border-radius: 50%!important;
		    background-size: 48px 48px;
		    background-position: center center;
		    vertical-align: middle;
		    line-height: 32px;
		    box-shadow: inset 0 0 1px #999, inset 0 0 10px rgba(0,0,0,.2);
		    margin-right: 3px;	    
	    }
		 
		
		</style>   	
		</#compress>
	</head>
	<body class="header-fixed sliding-panel-ini sliding-panel-flag-right">
		<div class="page-loader"></div>
		<div class="wrapper">
			<#include "/html/competency/common-header-v6.ftl" >			
			<!-- Promo Block -->
			<#if action.isSetNavigator()  >
			<#assign navigator = action.getNavigator() />				
			<div class="promo-bg-img-v2 job-img fullheight promo-bg-fixed bg-dark" style="height:350px;">
				<div class="container valign__middle text-center">
					<div class="margin-bottom-100"></div>	
					<div class="wow fadeIn" data-wow-delay=".3s" data-wow-duration="1.5s" style="visibility: hidden;">
						<span class="promo-text-v2 color-light margin-bottom-10" >
							<#if navigator.icon?? ><i class="icon-flat ${navigator.icon}"></i></#if> ${ navigator.title }
						</span>
						<p class="text-quote"> ${ navigator.description ? replace ("{displayName}" , action.webSite.company.displayName ) }	</p>
					</div>	
				</div>
				<div class="job-img-inputs">
					<div class="container">
						<div class="row">
							<div class="col-sm-11 md-margin-bottom-10" >
								<div class="row">
								
									<div class="col-sm-4 md-margin-bottom-10">
										<input id="classified-majority" style="font-size: 1.4em; color: #bcbcbc; width:100%"/>
									</div>
									<div class="col-sm-4 md-margin-bottom-10">
										<input id="classified-middle" style="font-size: 1.4em; color: #bcbcbc; width:100%"/>
									</div>
									<div class="col-sm-4 md-margin-bottom-10">
										<input id="classified-minority" style="font-size: 1.4em; color: #bcbcbc; width:100%"/>
									</div>
																	
								</div>
							</div>
							<div class="col-sm-1 text-right" >
								<button class="job-search-btn hvr-pulse-shrink"><i class="icon-flat icon-svg icon-svg-md basic-color-search"></i></button>
							</div>
						</div>
					</div>
				</div>								
			</div>
			</#if>				
			<!-- ./END HEADER -->			
			<div class="full-w-block">
				<div class="container">
					<div class="row">
						<div class="col-md-4 col-sm-4">
							<div class="info-blocks">
								<i class="fa fa-bell-o icon-info-blocks"></i>
								<div class="info-blocks-in">
									<h3>직무</h3>
									<p>한국표준직업분류, 한국표준산업분류등을 참고 대분류(24) > 중분류(80) > 소분류(238) 순으로 구성된 전체 887개 직무</p>
								</div>
							</div>
						</div>
	
						<div class="col-md-4 col-sm-4">
							<div class="info-blocks">
								<i class="fa fa-laptop icon-info-blocks"></i>
								<div class="info-blocks-in">
									<h3>역량진단</h3>
									<p>채크리스트를 통한 자가직무역량진단 도구</p>
								</div>
							</div>
						</div>
	
						<div class="col-md-4 col-sm-4">
							<div class="info-blocks">
								<i class="fa fa-bullhorn icon-info-blocks"></i>
								<div class="info-blocks-in">
									<h3>진단결과리포트</h3>
									<p>선택한 직무가 요구하는 여러 지식과 기술들을 개발하기 위한 여러가지 방법을 제공</p>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>			
			<!-- START MAIN CONTENT -->
			<div class="container content-md">
				<div class="row high-rated margin-bottom-20" >
					
					<div id="job-listview" class="no-border">
					
					</div>
					
				</div>
			</div>
			<div class="container content-md">
		        <div class="headline"><h2>Job Categories</h2></div>
		        <div class="row job-content margin-bottom-40">
				<div class="col-md-3 col-sm-3 md-margin-bottom-40">
					<h3 class="heading-md"><strong>Accounting &amp; Finance</strong></h3>
					<ul class="list-unstyled categories">
						<li><a href="#">Accounting</a> <small class="hex">(342 jobs)</small></li>
						<li><a href="#">Admin &amp; Clerical</a> <small class="hex">(143 jobs)</small></li>
						<li><a href="#">Banking &amp; Finance</a> <small class="hex">(66 jobs)</small></li>
						<li><a href="#">Contract &amp; Freelance</a> <small class="hex">(12 jobs)</small></li>
						<li><a href="#">Business Development</a> <small class="hex">(212 jobs)</small></li>
					</ul>
				</div>
				<div class="col-md-3 col-sm-3 md-margin-bottom-40">
					<h3 class="heading-md"><strong>Medicla &amp; Health</strong></h3>
					<ul class="list-unstyled categories">
						<li><a href="#">Nurse</a> <small class="hex">(546 jobs)</small></li>
						<li><a href="#">Health Care</a> <small class="hex">(82 jobs)</small></li>
						<li><a href="#">General Labor</a> <small class="hex">(11 jobs)</small></li>
						<li><a href="#">Pharmaceutical</a> <small class="hex">(109 jobs)</small></li>
						<li><a href="#">Human Resources</a> <small class="hex">(401 jobs)</small></li>
					</ul>
				</div>
				<div class="col-md-3 col-sm-3 md-margin-bottom-40">
					<h3 class="heading-md"><strong>Web Development</strong></h3>
					<ul class="list-unstyled categories">
						<li><a href="#">Ecommerce</a> <small class="hex">(958 jobs)</small></li>
						<li><a href="#">Web Design</a> <small class="hex">(576 jobs)</small></li>
						<li><a href="#">Web Programming</a> <small class="hex">(543 jobs)</small></li>
						<li><a href="#">Other - Web Development</a> <small class="hex">(67 jobs)</small></li>
						<li><a href="#">Website Project Management</a> <small class="hex">(45 jobs)</small></li>
					</ul>
				</div>
				<div class="col-md-3 col-sm-3">
					<h3 class="heading-md"><strong>Sales &amp; Marketing</strong></h3>
					<ul class="list-unstyled categories">
						<li><a href="#">Advertising</a> <small class="hex">(123 jobs)</small></li>
						<li><a href="#">Email Marketing</a> <small class="hex">(544 jobs)</small></li>
						<li><a href="#">Telemarketing &amp; Telesales</a> <small class="hex">(564 jobs)</small></li>
						<li><a href="#">Market Research &amp; Surveys</a> <small class="hex">(345 jobs)</small></li>
						<li><a href="#">SEM - Search Engine Marketing</a> <small class="hex">(32 jobs)</small></li>
					</ul>
				</div>
			</div>
		    </div>

			<!-- ./END MAIN CONTENT -->	
	 		
	 		<!-- START FOOTER -->
	
			<!-- ./END FOOTER -->					
		</div>				

		<#include "/html/competency/common-sliding-panel.ftl" >		
		<script type="text/x-kendo-tmpl" id="job-template">		
		<div class="item col-md-3 col-sm-6 margin-bottom-10 md-margin-bottom-20" style="display:none;" data-object-id="#=jobId#"  >
					<div class="easy-block-v1 #if(jobLevels.length == 0){ # grayscale #}#" >
						
						<div class="easy-block-v1-badge rgba-default">#:classification.classifiedMinorityName #</div>
						#if( classification.classifiedMajorityId == 202 ){#
						<img src="<@spring.url "/images/common/icons/business/color/ConstructionWorker.svg" />">
						#}else if( classification.classifiedMajorityId == 107 ){#
						<img src="<@spring.url "/images/common/icons/clothing/color/VeganClothing.svg" />">
						#}else{# 
						<img src="<@spring.url "/images/common/icons/business/office/Worker.svg" />">
						#}#
						<div class="overflow-h">
							<h3>#: name #</h3>			
							#: classification.classifiedMajorityId #			
							<div class="star-vote pull-right">
								<ul class="list-inline">
									<li><i class="color-green fa fa-star"></i></li>
									<li><i class="color-green fa fa-star"></i></li>
									<li><i class="color-green fa fa-star"></i></li>
									<li><i class="color-green fa fa-star-half-o"></i></li>
									<li><i class="color-green fa fa-star-o"></i></li>
								</ul>
							</div>
						</div>
						#if( description != null ){# 
						<p class=padding-xs-vr text-muted">#: description #</p>
						#}#						
						#if( jobLevels.length > 0 ){ #						
						<table class="table" style="font-size:.9em;">
							<thead>
								<tr>
									<th>직급</th>
									<th class="hidden-sm text-center">경력</th>
								</tr>
							</thead>
							<tbody>
								# for (var i = 0; i < jobLevels.length ; i++) { #	
								<tr>
									<td> #: jobLevels[i].name #</td>
									<td class="hidden-sm text-center" >#: jobLevels[i].minWorkExperienceYear # ~ #: jobLevels[i].maxWorkExperienceYear #</td>
								</tr>
								# } #
							</tbody>
						</table>
						<a class="btn-u btn-u-sm" href="\\#">더 알아보기 </a>
						# } #						
					</div>
		</div>		
		</script>
	</body>    
</html>
