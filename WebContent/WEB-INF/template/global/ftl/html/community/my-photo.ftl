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
			'css!<@spring.url "/styles/common.ui.plugins/animate.min.css"/>',	
			'css!<@spring.url "/styles/common.ui.plugins/switchery.min.css"/>',			
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
			'<@spring.url "/js/common.ui.plugins/jquery.slimscroll.min.js"/>', 		
			'<@spring.url "/js/common.ui.plugins/jquery.backstretch.min.js"/>', 
			'<@spring.url "/js/common.ui.plugins/switchery.min.js"/>', 
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
				common.ui.bootstrap.enableModalStack();								
				// END SCRIPT 				
			}
		}]);	
		
		function createMyPhotoTabs(){
			var renderTo = $('#my-photo-tabs');
			renderTo.on( 'show.bs.tab', function (e) {
				//	e.preventDefault();		
				var show_bs_tab = $(e.target);	
				console.log(">>" + show_bs_tab );			
				if( show_bs_tab.data('action') == 'view-photo'){
					createPhotoListView();
				}else if (show_bs_tab.data('action') == 'view-album'){
					createAlbumListView();
				}else if (show_bs_tab.data('action') == 'view-album'){
					createPhotoUploadModal();
				}									
			});	
			renderTo.find('a:first').tab('show') ;			
		}		
		
		
		
		function getPhotoListView(){
			return common.ui.listview(renderTo);
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
							var renderTo = $("#my-image-view-modal");	
							if( renderTo.data('bs.modal') && renderTo.is(":visible")){
								var listview_pager = common.ui.pager( $("#my-photo-listview-pager") );
								var data = this.dataSource.view();				
								if( renderTo.data("model").page > listview_pager.page() ){
									var item = data[renderTo.data("model").pageSize - 1];
									item.set("index", renderTo.data("model").pageSize -1 );
									createPhotoViewModal(item);
								}else{
									var item = data[0];
									item.set("index", 0 );
									createPhotoViewModal(item);
								}
							}					
					},
					navigatable: false,
					template: kendo.template($("#my-photo-listview-template").html())
				});		
				
				common.ui.pager( $("#my-photo-listview-pager"), { refresh:false, buttonCount : 9, pageSizes: [30, 60, 90, "전체"] , dataSource : listview.dataSource });				
				renderTo.removeClass('k-widget');			
				renderTo.on("click", ".image-bg", function(e){				
					var index = $(this).closest("[data-uid]").index();
					var data = common.ui.listview(renderTo).dataSource.view();					
					var item = data[index];
					item.set("index", index );
					createPhotoViewModal(item);
				});				
			}
		}

		function createPhotoUploadModal(){
			var renderTo = $("#my-photo-upload-modal");
			if( !renderTo.data('bs.modal')){
				var model = common.ui.observable({
						data : {
							sourceUrl : '', 
							imageUrl : ''
						},
						reset: function(e){
							this.data.sourceUrl = '';
							this.data.imageUrl = '';							
							renderTo.find(".sky-form input").val('');							
						},	
						upload: function(e) {
							$this = this;
							e.preventDefault();	
							var hasError = false;											
							renderTo.find('.sky-form .input.state-error').removeClass("state-error");								
							if( this.data.sourceUrl == null || this.data.sourceUrl.length == 0 || !common.valid("url", this.data.sourceUrl) ){
								renderTo.find('.sky-form .input').eq(0).addClass("state-error");			
								hasError = true;					
							}else{
								if( renderTo.find('.sky-form .input').eq(0).hasClass("state-error") ){
									renderTo.find('.sky-form .input').eq(0).removeClass("state-error");
								}											
							}					
							if( this.data.imageUrl == null || this.data.imageUrl.length == 0 || !common.valid("url", this.data.imageUrl)  ){
								renderTo.find('.sky-form .input').eq(1).addClass("state-error");
								hasError = true;		
							}else{
								if( renderTo.find('.sky-form .input').eq(1).hasClass("state-error") ){
									renderTo.find('.sky-form .input').eq(1).removeClass("state-error");
								}											
							}				
							if( !hasError ){
								var btn = $(e.target);
								btn.button('loading');			
								this.data.objectType = 2;
								common.ui.data.image.uploadByUrl( {
									data : this.data ,
									success : function(response){
										getPhotoListView().dataSource.read();		
									},
									always : function(){
										btn.button('reset');										
										$this.reset();
									}
								});		
							}				
						}										
					});		
					kendo.bind(renderTo, model);	
					if( !common.ui.exists($("#photo-files")) ){
						common.ui.upload($("#photo-files"),{
							async: {
								saveUrl:  '<@spring.url "/data/me/photo/images/update_with_media.json?output=json" />'
							},
							success : function(e) {	
								getPhotoListView().dataSource.read();								
							}		
						});		
					}
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
					share: function(){
						createPhotoShareModal(this.image);
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
				common.ui.bind(renderTo, observable );				
				renderTo.data("model", observable);	
			}			
			renderTo.data("model").setImage(image);
			renderTo.modal('show');				
		}			
		
		
		function createPhotoShareModal(image){
			var renderTo = $("#my-photo-share-modal");		
			if( !renderTo.data('bs.modal') ){				
				var switchery = new Switchery(renderTo.find('.js-switch')[0]);
				var observable =  common.ui.observable({
					image : new common.ui.data.Image(),
					isShared : false,
					editable : false,
					onChange : function(){
						var $this = this;		
						console.log( "update:" + $this.editable +  ", value=" + $this.isShared);
						if( $this.editable ){
							if($this.isShared){
								common.ui.data.image.unshare($this.image.imageId);	
							}else{
								common.ui.data.image.share($this.image.imageId);
							}
						}
					},
					setImage: function(image){
						var $this = this;			
						image.copy($this.image);
						$this.set('editable', false);
						switchery.disable();
						
						common.ui.data.image.streams($this.image.imageId, function(data){	
							var isShared = false;							
							if( data.length > 0 ){
								isShared = true;
							}							
							switchery.enable();
							if( isShared != $this.isShared ){
								renderTo.find('.js-switch')[0].click();
							}
							$this.set('editable', true);						
						});
					}
				});	
				common.ui.bind(renderTo, observable );
				renderTo.data("model", observable);	
			}
			renderTo.data("model").setImage(image);
			renderTo.modal('show');	
		}		
		
		<!-- ============================== -->
		<!-- Commentary						-->
		<!-- ============================== -->		
		function createPhotoCommentary(source){
			var renderTo = $("#my-photo-commentary");				
			if( !renderTo.data("model") ){		
				var observable =  common.ui.observable({
					image : new common.ui.data.Image(),
					coverPhotoUrl : "",
					hasSource : false,
					commentBody : "",
					dataSource : common.ui.datasource( '<@spring.url "/data/comments/list.json?output=json"/>',{
						schema: {
							total: "totalCount",
							data: "comments",
							model: common.ui.data.Comment
						},
						selectable: false,
						batch: false,
						serverPaging: false,
						serverFiltering: false,
						serverSorting: false					
					}),
					comment : function(e){
						var $this = this;
						btn = $(e.target);						
						btn.button('loading');							
						var myComment = new common.ui.data.Comment({objectType:16, objectId:$this.image.imageId, body:$this.get("commentBody")}); 	
						common.ui.ajax(
							'<@spring.url "/data/comments/update.json?output=json"/>',
							{
								data : kendo.stringify(myComment) ,
								contentType : "application/json",
								success : function(response){
									$this.dataSource.read({objectType: 16, objectId: $this.image.imageId });
									//$(".poll a[data-action=comment][data-object-id="+ $this.image.imageId +"] span.comment-page-count").html( response.count  );
								},
								complete : function(e){
									$this.set("commentBody", "");
									btn.button('reset');
								}							
						});	
						return false;						
					},
					setSource : function(source){
						var $this = this;
						if( source instanceof common.ui.data.Image ){
							console.log("it's image.");
							source.copy($this.image);
							$this.set("hasSource",areThereSources($this.image) );
							$this.dataSource.read({objectType:16, objectId: $this.image.imageId });	
						}	
					}				
				});
				renderTo.data("model", observable);			
				common.ui.bind( renderTo, observable );		
					
				$('.close[data-commentary-close]').click(function(){	
					renderTo.modal('hide');
				});
			}	
			
			if(renderTo.is(":hidden")){
				renderTo.data("model").setSource( source ) ;			
				renderTo.modal('show');
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
			<article class="bg-white animated fadeIn" style="min-height:200px; display:none;">		
				<div class="container content">		
					<ul id="my-photo-tabs" class="nav nav-pills">
					  <li role="presentation"><a href="#photo-tabpanel" aria-controls="photo-tabpanel" role="tab" data-toggle="pill" aria-expanded="false" data-action="view-photo">
					  	<i class="icon-flat icon-svg icon-svg-sm basic-color-picture grayscale"></i> 사진</a>
					  </li>
					  <li role="presentation"><a href="#album-tabpanel" aria-controls="album-tabpanel" role="tab" data-toggle="pill" aria-expanded="false" data-action="view-album">
					  	<i class="icon-flat icon-svg icon-svg-sm basic-color-stack-of-photos grayscale"></i> 앨범</a>
					  </li>					  
					  <li role="presentation" class="dropdown pull-right">
					  	<button class="btn-link btn-block hvr-pulse-shrink" type="button" data-action="upload-photo" data-toggle="modal" data-target="#my-photo-upload-modal">
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
										
				<span class="close" aria-hidden="true" data-dismiss="modal" ></span>		
					
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
		<div id="my-photo-commentary" class="modal fade" style="background: rgba(0,0,0,0.4);" data-effect="slide">
			<div class="commentary commentary-drawer">			
				<button aria-hidden="true" data-dismiss="modal" class="close" type="button"></button>				
				<div class="commentary-content">
					<h3></h3>
					<div class="sky-form no-border">
						<label class="textarea">
							<textarea rows="4" name="comment" placeholder="저작권 등 다른 사람의 권리를 침해하거나 명예를 훼손하는 게시물은 이용약관 및 관련 법률에 의해 제재를 받을 수 있습니다. 건전한 토론문화와 양질의 댓글 문화를 위해, 타인에게 불쾌감을 주는 욕설 또는 특정 계층/민족, 종교 등을 비하하는 단어들은 표시가 제한됩니다." data-bind="value:commentBody"></textarea>
						</label>
						<div class="text-right">
							<button class="btn btn-flat btn-info btn-outline btn-xl rounded" data-bind="click:comment">게시하기</button>
						</div>
					</div>	
					<div class="comments"
						 data-role="listview"
		                 data-auto-bind="false"
		                 data-template="my-photo-commentary-listview-template"
		                 data-bind="source: dataSource"></div>								
				</div>
			</div>	
		</div>

		<div id="my-photo-share-modal" role="dialog" class="modal fade" data-backdrop="static" data-effect="zoom">
			<div class="modal-dialog modal-sm">
				<div class="modal-content">	
					<div class="modal-header">
						공유
						<button aria-hidden="true" data-dismiss="modal" class="close" type="button"></button>
					</div>		
					<div class="modal-body">
						<div class="row">
						  	<div class="col-xs-6">
						  		<h6 class="text-primary">모두에게 공유합니다</h6>
						 	</div>
						  	<div class="col-xs-6 text-right">
						  		<input type="checkbox" class="js-switch" data-bind="checked:isShared, events:{change:onChange}"/>	
							</div>  
						</div>			
					</div>		
				</div>
			</div>	
		</div>

		<div id="my-photo-upload-modal" role="dialog" class="modal fade" data-backdrop="static" data-effect="zoom">
			<div class="modal-dialog modal-lg">
				<div class="modal-content my-page-view-form">	
					<div class="modal-header">
						<h2><i class="fa fa-cloud-upload  fa-lg"></i> 사진 업로드 </h2>
						<button aria-hidden="true" data-dismiss="modal" class="close" type="button"></button>
					</div>
					<div class="modal-body p-xs">
							<form class="sky-form no-border">
								<fieldset>
									<div class="row">
										<div class="col-sm-6">
											<h4><i class="fa fa-upload"></i> 업로드 </h4> 
											<p>아래의 사진 선택 버튼을 클릭하여 사진을 직접 선택하거나, 아래의 영역에 사진를 끌어서 놓기(Drag & Drop)를 하세요.</p>
											<div id="my-photo-upload">	
												<input name="uploadPhotos" id="photo-files" type="file" />					
											</div>
										</div>
										<div class="col-sm-6">
											<h4><i class="fa fa-upload"></i> URL 업로드 </h4> 
											<p>사진이 존재하는 URL 을 직접 입력하여 주세요.</p>
											<label class="label">출처</label>
											<label class="input"><i class="icon-append fa fa-globe"></i> <input type="url" name="url" placeholder="출처 URL"  data-bind="value: data.sourceUrl"></label>
											<span class="help-block"><small>사진 이미지 출처 URL 을 입력하세요.</small></span>
											
											<label class="label">사진</label>
											<label class="input"><i class="icon-append fa fa-globe"></i> <input type="url" name="url2" placeholder="사진 URL"  data-bind="value: data.imageUrl"></label>
											<span class="help-block"><small>사진 이미지 경로가 있는 URL 을 입력하세요.</small></span>
											<section class="text-right">
											<button type="submit" class="btn btn-info btn-flat btn-outline rounded" data-bind="events: { click: upload }" data-loading-text='<i class="fa fa-spinner fa-spin"></i>'><i class="fa fa-cloud-upload"></i> &nbsp; URL 사진 업로드</button>
											</section>
										</div>
									</div>
								</fieldset>	
							</form>
					</div>
				</div>
			</div>
		</div>
										
	<!-- START TEMPLATE -->
	<#include "/html/common/common-homepage-templates.ftl" >
	<script id="my-photo-commentary-listview-template" type="text/x-kendo-template">
		<div class="comment" >
			<img class="author-image" src="#=authorPhotoUrl()#" alt="">
			<div class="content text-xs">
				<h6>
				<span class="author">#if ( name == null ){# 손님 #}else{# #: name # #}#</span>
				<span class="comment-date">#: formattedCreationDate() #</span>
				</h6>
				<span class="linked-text">
					#: body #
				</span>
			</div>		
		</div>	
	</script>	
	<script type="text/x-kendo-tmpl" id="my-photo-listview-template">
	<div class="col-sm-2 col-xs-4 image-bg" style="background-image: url('<@spring.url '/download/image/#= imageId #/#=name#?width=150&height=150'/>')" >		
		<!--<span class="image-select"></span>
		<i class="image-view icon-flat icon-svg icon-svg-sm basic-color-stack-of-photos"></i>-->
	</div>
	</script>		
	<!-- ./END TEMPLATE -->
	</body>    
</html>