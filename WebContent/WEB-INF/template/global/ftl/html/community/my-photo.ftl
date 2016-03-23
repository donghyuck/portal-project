<#ftl encoding="UTF-8"/>
<html decorator="unify">
<head>
		<#assign page = action.getPage() >				
		<title><>${page.title}</title>
		<#compress>		
		<script type="text/javascript">
		<!--
		var jobs = [];					
		yepnope([{
			load: [
			'css!<@spring.url "/styles/font-awesome/4.3.0/font-awesome.min.css"/>',
			'css!<@spring.url "/styles/bootstrap.themes/unify/1.9.1/headers/header-default.css"/>',		
			'css!<@spring.url "/styles/bootstrap.themes/unify/1.9.1/theme-colors/dark-red.css"/>',	
			'css!<@spring.url "/styles/bootstrap.themes/unify/1.9.1/theme-skins/dark.css"/>',
			'css!<@spring.url "/styles/bootstrap.themes/common/common.ui.inspinia.css"/>',
			'css!<@spring.url "/styles/bootstrap.themes/common/common.ui.buttons.css"/>',
			'css!<@spring.url "/styles/common.ui/common.ui.color-icons.css"/>',
			'css!<@spring.url "/styles/common.ui.pages/personalized.style.css"/>',
						
			'css!<@spring.url "/styles/jquery.magnific-popup/magnific-popup.css"/>',		
			'css!<@spring.url "/styles/jquery.sky-forms/2.0.1/custom-sky-forms.css"/>',
			'css!<@spring.url "/styles/hover-effect/hover-min.css"/>',

			
			'<@spring.url "/js/jquery/1.10.2/jquery.min.js"/>',
			'<@spring.url "/js/jgrowl/jquery.jgrowl.min.js"/>',
			'<@spring.url "/js/jquery.magnific-popup/jquery.magnific-popup.min.js"/>',	
			'<@spring.url "/js/kendo/kendo.web.min.js"/>',
			'<@spring.url "/js/kendo.extension/kendo.ko_KR.js"/>',			
			'<@spring.url "/js/kendo/cultures/kendo.culture.ko-KR.min.js"/>',			
			'<@spring.url "/js/bootstrap/3.3.4/bootstrap.min.js"/>',
			'<@spring.url "/js/common.plugins/jquery.slimscroll.min.js"/>', 		
			'<@spring.url "/js/common.plugins/query.backstretch.min.js"/>', 
			'<@spring.url "/js/common/common.ui.core.js"/>',							
			'<@spring.url "/js/common/common.ui.data.js"/>',
			'<@spring.url "/js/common/common.ui.community.js"/>',
			'<@spring.url "/js/common.pages/common.personalized.js"/>'
			],			
			complete: function() {			
					
				// FEATURES SETUP	
				common.ui.setup({
					features:{
						wallpaper : true,
						lightbox : true,
						accounts : {
							authenticate : function(e){
								e.token.copy(currentUser);
								$('article').show();
								createMyPhotoTabs()
							} 
						}		
					},
					wallpaper : {
						renderTo:$(".interactive-slider-v2")
					},
					jobs:jobs
				});				
				
				// ACCOUNTS LOAD	
				var currentUser = new common.ui.data.User();
				createPhotoListView(currentUser);			
							
							
				// END SCRIPT 				
			}
		}]);	
		
		function createMyPhotoTabs(){
			var renderTo = $('#my-photo-tabs');
			renderTo.on( 'show.bs.tab', function (e) {
				//	e.preventDefault();		
				var show_bs_tab = $(e.target);				
				if( show_bs_tab.data('action') == 'photo'){
					createPhotoListView();
				}else if (show_bs_tab.data('action') == 'album'){
					createAlbumListView();
				}									
			});	
			renderTo.find('a:first').tab('show') ;
		}		
		
		function createPhotoListView( currentUser ){		
			var renderTo = $('#my-photo-listview');
			if( !common.ui.exists(renderTo) ){
				common.ui.listview(	renderTo, {
					dataSource : common.ui.datasource(
						'<@spring.url "/data/me/photo/images/list.json?output=json" />',
						{
							transport : {
								parameterMap :  function (options, operation){
									return { startIndex: options.skip, pageSize: options.pageSize }
								}
							},
							pageSize: 28,
							schema: {
								model: common.ui.data.Image,
								data : "images",
								total : "totalCount"
							}
						}
					),
					selectable: "multiple",//"single",
					change: function(e) {
						var data = this.dataSource.view() ;
					},
					dataBound : function(e){
					},
					navigatable: false,
					template: kendo.template($("#my-photo-listview-template").html())
				});		
				renderTo.removeClass('k-widget');
			}
		}
		
		function createAlbumListView( currentUser ){		
				
		}
		
		-->
		</script>		
		<style scoped="scoped">
		ul.nav-pills > li > a {
			border : 0!important;
			padding : 10px 20px;
			border-radius : 8px;
			font-weight: 200;
    		font-size: 1.1em;
		}
			
		ul.nav-pills > li > a .icon-svg {	
			    display: inline-block!important;
			    border-radius: 50%!important;
			    background-size: 48px 48px;
			    background-position: center center;
			    vertical-align: middle;
			    line-height: 32px;
			    box-shadow: inset 0 0 1px #999, inset 0 0 10px rgba(0,0,0,.2);
			    margin-left: 0px;
			    
    	}
    	
    	ul.nav-pills > li.active > a .icon-svg {     	
		 	-moz-filter: none;
		    -o-filter: none;
		    -webkit-filter: none;
		    filter: none;
		    filter: none;   	
    	}
			
		</style>   	
		</#compress>
	</head>
	<body id="doc" class="bg-white">
		<div class="page-loader"></div>
			<div class="wrapper">
			<!-- START HEADER -->		
			<#include "/html/common/common-homepage-menu.ftl" >		
			<!-- ./END HEADER -->
			
			<!-- START MAIN CONTENT -->
			<#if action.isSetNavigator()  >
			<#assign navigator = action.getNavigator() />					
			<div class="interactive-slider-v2 bg-dark arrow-up">
				<div class="personalized-controls container text-center p-xl">
					<p class="text-quote">${ navigator.description ? replace ("{displayName}" , action.webSite.company.displayName ) }	</p>
					<h1 class="text-xxl"><#if navigator.icon?? ><i class="icon-flat ${navigator.icon}"></i></#if>	${ navigator.title }</h1>					
				</div><!--/end container-->
			</div>
			</#if>	
			<article class="bg-white animated fadeInUp" style="min-height:200px; display:none;">		
				<div class="container content">		
					<ul id="my-photo-tabs" class="nav nav-pills">
					  <li role="presentation"><a href="#photo-tabpanel" aria-controls="photo-tabpanel" role="tab" data-toggle="pill" aria-expanded="false" data-action="photo">
					  	<i class="icon-flat icon-svg icon-svg-sm basic-color-picture grayscale"></i> 사진</a>
					  </li>
					  <li role="presentation"><a href="#album-tabpanel" aria-controls="album-tabpanel" role="tab" data-toggle="pill" aria-expanded="false" data-action="album">
					  	<i class="icon-flat icon-svg icon-svg-sm basic-color-stack-of-photos grayscale"></i> 앨범</a>
					  </li>					  
					  <li role="presentation" class="dropdown pull-right">
					  	<button class="btn-link btn-block hvr-pulse-shrink" type="button" data-action="upload" data-toggle="modal" data-target="#my-photo-upload-modal">
					  		<i class="icon-flat icon-svg basic-color-add-image icon-svg-md"></i>
					  	</button>  
					  </li>
					  
					</ul>
					<div class="tab-content">
						<div role="tabpanel" class="tab-pane fade" id="photo-tabpanel"> 사진 	
							<div id="my-photo-listview" class="no-border image-listview"></div>						
						</div>
						<div role="tabpanel" class="tab-pane fade" id="album-tabpanel">	앨범 
						
						</div>
					</div>
				</div><!--/end container-->
			</article>
			<!-- ./END MAIN CONTENT -->	
	 		<!-- START FOOTER -->
			<#include "/html/common/common-homepage-globalfooter.ftl" >		
			<!-- ./END FOOTER -->					
		</div>			
		
	<!-- START TEMPLATE -->
	<#include "/html/common/common-homepage-templates.ftl" >
	<script type="text/x-kendo-tmpl" id="my-photo-listview-template">
	<div class="col-sm-2 col-xs-4 img-wrapper" style="background-image: url('<@spring.url '/download/image/#= imageId #/#=name#?width=150&height=150'/>');">		
		<span class="" ></span>	
	</div>
	</script>		
	<!-- ./END TEMPLATE -->
	</body>    
</html>