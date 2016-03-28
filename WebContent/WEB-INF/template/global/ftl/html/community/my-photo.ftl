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
				var listview = common.ui.listview(renderTo, {
					dataSource : common.ui.datasource(
						'<@spring.url "/data/me/photo/images/list.json?output=json" />',
						{
							transport : {
								parameterMap :  function (options, operation){
									return { startIndex: options.skip, pageSize: options.pageSize }
								}
							},
							pageSize: 30,
							schema: {
								model: common.ui.data.Image,
								data : "images",
								total : "totalCount"
							}
						}
					),
					selectable: false,//"multiple",//"single",
					change: function(e) {
						var data = this.dataSource.view() ;
						
					},
					dataBound : function(e){
					},
					navigatable: false,
					template: kendo.template($("#my-photo-listview-template").html())
				});		
				
				common.ui.pager( $("#my-photo-listview-pager"), { refresh:false, buttonCount : 9, pageSizes: [30, 60, 90, "전체"] , dataSource : listview.dataSource });				
				renderTo.removeClass('k-widget');			
				/*
				renderTo.on("click", ".image-view", function(e){		
					//e.stopPropagation();
					e.preventDefault() ;
				});
				*/
				renderTo.on("click", ".image-bg", function(e){				
					var index = $(this).closest("[data-uid]").index();
					var data = common.ui.listview(renderTo).dataSource.view();					
					var item = data[index];
					item.set("index", index );
					console.log( item ) ;
					createPhotoViewModal(item);
				});				
			}
		}
		

		function createPhotoViewModal(image){		
			var renderTo = $("#my-image-view-modal");	
			if( !renderTo.data('bs.modal') ){		
				//var photoListView = 	
				var observable =  common.ui.observable({ 
					image : new common.ui.data.Image(),
					resize : function(){
						var $img = renderTo.find("img.mfp-img");
						var $window = $(window);
						$img.css("max-height", $window.height() - 10 );	
						$img.css("max-width", $window.height() - 10 );					
					},
					page:0,
					pageSize:0,
					hasPreviousPage: false,
					hasNextPage: false,
					hasPrevious: false,
					hasNext: false,
					hasSource : false,
					previous : function(){
						var $this = this;
						if( $this.hasPrevious ){
							var index = $this.image.index - 1;
							var data = common.ui.listview($('#my-photo-listview')).dataSource.view();					
							var item = data[index];				
							item.set("index", index );
							createPhotoViewModal(item);		
						}
					},
					next : function(){
						var $this = this;						
						if( $this.hasNext ){
							var index = $this.image.index + 1;
							var data = common.ui.listview($('#my-photo-listview')).dataSource.view();					
							var item = data[index];		
							item.set("index", index );
							createPhotoViewModal(item);					
						}
					},
					previousPage : function(){
						var $this = this;
						if( $this.hasPreviousPage ){							
							var pager = common.ui.pager( $("#my-photo-listview-pager") );
							pager.page($this.page -1);
						}
					},
					nextPage : function(){
						var $this = this;						
						if( $this.hasNextPage ){
							var pager = common.ui.pager( $("#my-photo-listview-pager") );
							pager.page($this.page +1);			
						}
					},					
					setPagination: function(){
						var $this = this;
						var pageSize = common.ui.listview($('#my-photo-listview')).dataSource.view().length;	
						var pager = common.ui.pager( $("#my-photo-listview-pager") );
						var page = pager.page();
						var totalPages = pager.totalPages();		
						if( this.image.index > 0 && (this.image.index - 1) >= 0 )
							$this.set("hasPrevious", true); 
						else 
							$this.set("hasPrevious", false); 							
						if( ($this.image.index + 1 )< pageSize && (pageSize - this.image.index ) > 0 )
							$this.set("hasNext", true); 
						else 
							$this.set("hasNext", false); 	
						$this.set("hasPreviousPage", page > 1 );				
						$this.set("hasNextPage", totalPages > page  );		
						$this.set("page", page );			
						$this.set("pageSize", pageSize );																	
					},
					comment: function(){
						createPhotoCommentary(this.image);
						return false;
					},
					editable : false,
					edit: function(){
						var $this = this;
						createPhotoPostModal($this.image);
					},
					close: function(){
						var $this = this;						
						renderTo.find(".white-popup-block").fadeOut();
						$('body').css('overflow', 'auto');				
					},
					setImage: function(image){
						var $this = this;			
						$this.resize();
						image.copy($this.image);
						$this.set("hasSource",areThereSources($this.image) );
						$this.setPagination();
						var $loading = renderTo.find(".mfp-preloader");
						var $largeImg = renderTo.find(".mfp-content");		
						$largeImg.hide();				
						$loading.show();							
						$("<img/>" ).load( function() {
							var $img = $(this);							
							if( $img.attr( 'src' ) === $this.image.imageUrl ) {		
								$loading.hide();
								$largeImg.fadeIn("slow");		
							}
						}).attr( 'src', $this.image.imageUrl );
					}
				});
				observable.resize();				
				$(window).resize(function(){
					observable.resize();
				});				
				common.ui.bootstrap.enableStackingModal(renderTo);
				common.ui.bind(renderTo, observable );				
				renderTo.data("model", observable);	
			}			
			renderTo.data("model").setImage(image);
			renderTo.modal('show');				
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
			
		.mfp-container{
			background:#222;
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
					  <li role="presentation" class="dropdown pull-right">
					  	<button class="btn-link btn-block hvr-pulse-shrink" type="button" data-action="create-album" data-toggle="modal" data-target="#my-album-create-modal">
					  		<i class="icon-flat icon-svg basic-color-stack-of-photos icon-svg-md"></i>
					  	</button>  
					  </li>					  
					</ul>
					<div class="tab-content">
						<div role="tabpanel" class="tab-pane fade" id="photo-tabpanel"> 	
							<div id="my-photo-listview" class="no-border no-gutter image-listview-v2"></div>			
							<div id="my-photo-listview-pager" class="image-listview-pager text-muted p-sm"></div>			
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
		<div id="my-image-view-modal" role="dialog" class="modal fade" data-backdrop="static" data-effect="zoom">
			<div class="mfp-container mfp-s-ready mfp-image-holder">
				<span class="btn-flat-svg edit" data-bind="click: edit"></span>	
				<span class="btn-flat-svg share" data-bind="click: share"></span>		
				<span class="btn-flat-svg comment" data-bind="click: comment"></span>	
					
				<span class="btn-flat-icon left2" data-bind="visible: hasPreviousPage, click: previousPage"></span>		
				<span class="btn-flat-icon right2" data-bind="visible: hasNextPage, click: nextPage"></span>								
				<span class="btn-flat-icon close" aria-hidden="true" data-dismiss="modal" ></span>		
					<div class="mfp-content">	
						<div class="mfp-figure">
							<figure>
								<img class="mfp-img" style="display: block;" data-bind="attr:{src:image.imageUrl}, click: next">
								<figcaption>
									<div class="mfp-bottom-bar">
										<div class="mfp-title" data-bind="text: image.name"></div>
										<div class="mfp-counter"><span data-bind="text:image.index"></span>/<span data-bind="text:pageSize"></span></div>
									</div>
								</figcaption>
							</figure>
						</div>
					</div>	
					<div class="mfp-preloader" style="display: none;"></div>
					<button title="Previous (Left arrow key)" type="button" class="btn-flat-icon left mfp-arrow mfp-prevent-close" data-bind="visible: hasPrevious, click: previous"></button>
					<button title="Next (Right arrow key)" type="button" class="btn-flat-icon right mfp-arrow  mfp-prevent-close" data-bind="visible: hasNext, click: next"></button>		
			</div>
		</div>
				
	<!-- START TEMPLATE -->
	<#include "/html/common/common-homepage-templates.ftl" >
	<script type="text/x-kendo-tmpl" id="my-photo-listview-template">
	<div class="col-sm-2 col-xs-4 image-bg" style="background-image: url('<@spring.url '/download/image/#= imageId #/#=name#?width=150&height=150'/>')" >		
		<!--<span class="image-select"></span>
		<i class="image-view icon-flat icon-svg icon-svg-sm basic-color-stack-of-photos"></i>-->
	</div>
	</script>		
	<!-- ./END TEMPLATE -->
	</body>    
</html>