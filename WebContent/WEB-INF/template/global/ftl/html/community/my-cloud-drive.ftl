<#ftl encoding="UTF-8"/>
<html decorator="unify">
<head>
		<title><#if action.webSite ?? >${action.webSite.displayName }<#else>::</#if></title>
		<#compress>		
		<script type="text/javascript">
		<!--
		var jobs = [];					
		yepnope([{
			load: [
			'css!${request.contextPath}/styles/font-awesome/4.2.0/font-awesome.min.css',
			'css!${request.contextPath}/styles/jquery.bxslider/jquery.bxslider.css',
			'css!${request.contextPath}/styles/jquery.flexslider/flexslider.css',
			'css!${request.contextPath}/styles/jquery.magnific-popup/magnific-popup.css',						
			/*'css!${request.contextPath}/styles/codrops/codrops.grid.min.css',*/
			'css!${request.contextPath}/styles/codrops/codrops.cbp-spmenu.css',					
			'css!${request.contextPath}/styles/common.themes/unify/themes/blue.css',			
			'css!${request.contextPath}/styles/common.pages/common.onepage.css',
			'css!${request.contextPath}/styles/common.pages/common.personalized.css',
				
			'${request.contextPath}/js/jquery/1.10.2/jquery.min.js',
			'${request.contextPath}/js/jgrowl/jquery.jgrowl.min.js',
			'${request.contextPath}/js/jquery.magnific-popup/jquery.magnific-popup.min.js',	
			'${request.contextPath}/js/jquery.easing/jquery.easing.1.3.js',		
			'${request.contextPath}/js/jquery.bxslider/jquery.bxslider.min.js',
			'${request.contextPath}/js/kendo/kendo.web.min.js',
			'${request.contextPath}/js/kendo.extension/kendo.ko_KR.js',			
			'${request.contextPath}/js/kendo/cultures/kendo.culture.ko-KR.min.js',			
			'${request.contextPath}/js/bootstrap/3.2.0/bootstrap.min.js',
			'${request.contextPath}/js/common.plugins/jquery.slimscroll.min.js', 		
			'${request.contextPath}/js/common.plugins/query.backstretch.min.js', 					
		/*	'css!${request.contextPath}/js/codrops/codrops.grid.js',				*/
			'${request.contextPath}/js/pdfobject/pdfobject.js',	
			'${request.contextPath}/js/common/common.ui.core.js',							
			'${request.contextPath}/js/common/common.ui.data.js',
			'${request.contextPath}/js/common/common.ui.community.js',
			'${request.contextPath}/js/common.pages/common.personalized.js'
			],			
			complete: function() {		
			
				common.ui.setup({
					features:{
						wallpaper : true,
						lightbox : true,
						spmenu : true
					},
					wallpaper : {
						slideshow : false
					},
					jobs:jobs
				});				
				// ACCOUNTS LOAD	
				var currentUser = new common.ui.data.User();			
				common.ui.accounts($("#account-navbar"), {
					template : kendo.template($("#account-navbar-template").html()),
					allowToSignIn : <#if action.user.anonymous >false<#else>true</#if>,
					authenticate : function( e ){
						e.token.copy(currentUser);
						if( !currentUser.anonymous ){		
							common.ui.enable( $('button[data-toggle="spmenu"]')	);
							common.ui.enable( $('button[data-action="show-gallery-section"]') );							
						}
					}
				});	

				$(".navbar-nav li[data-menu-item='MENU_PERSONALIZED']").addClass("active");
				
				// personalized grid setting																																					
				preparePersonalizedArea($("#personalized-area"), 3, 6 );
												
				// photo panel showing				
				//createPhotoListView();								
																			
				// 4. Right Tabs								
				$('#myTab').on( 'show.bs.tab', function (e) {
					//e.preventDefault();		
					var show_bs_tab = $(e.target);
					if( show_bs_tab.attr('href') == '#my-files' ){					
						//createAttachmentListView();
					} else if(show_bs_tab.attr('href') == '#my-photo-stream' ){					
						//createPhotoListView();
					}					
				});
				$('#myTab a:first').tab('show') ;

				common.ui.buttonGroup($("#personalized-buttons"), {
					handlers :{
						"show-gallery-section" : function(e){
							common.ui.disable($(e.target));
							createGallerySection();
						}
					}				
				});							
				// END SCRIPT 				
			}
		}]);	
		<!-- ============================== -->
		<!-- display image gallery                                  -->
		<!-- ============================== -->
		function createGallerySection(){
			var renderTo = "image-gallery";			
			if( $( "#" +renderTo).length == 0 ){			
				$(".wrapper .breadcrumbs").after( $("#image-gallery-template").html() );	
				var galleryDataSource = common.ui.datasource(
					'${request.contextPath}/community/list-my-image.do?output=json',
					{
						transport:{
							parameterMap: function (options, operation){
								if (operation != "read" && options) {										                        								                       	 	
									return { imageId :options.imageId };									                            	
								}else{
									 return { startIndex: options.skip, pageSize: options.pageSize }
								}
							}						
						},
						pageSize: 30,
						schema: {
							model: common.ui.data.Image,
							data : "targetImages",
							total : "totalTargetImageCount"
						},
						change : function(){
							$( "#image-gallery-grid" ).html(
								kendo.render( kendo.template($("#image-gallery-grid-template").html()), this.view() )
							);	
						}
					}
				);
				common.ui.thumbnail.expanding({ template: $("#image-gallery-expanding-template").html() });			
				common.ui.pager($("#image-gallery-pager"), {dataSource: galleryDataSource});
				common.ui.buttons("#image-gallery button[data-dismiss='panel'][data-dismiss-target]");				
				galleryDataSource.read();	
			}
			if( $( "#" +renderTo).is(":hidden") ){
				common.ui.animate(
					$( "#" +renderTo),
					{
					effects: "slide:down fade:in",
					show: true,
					duration: 1000
				 });
			} 			
		}
					
		-->
		</script>		
		<style scoped="scoped">
			
			#image-gallery-pager { 
				margin-top: 5px; 
			}
		
		</style>   	
		</#compress>
	</head>
	<body id="doc" class="bg-dark">
		<div class="page-loader"></div>
		<div class="wrapper">
			<!-- START HEADER -->		
			<#include "/html/common/common-homepage-menu.ftl" >		
			<!-- ./END HEADER -->
			<!-- START MAIN CONTENT -->
			<div class="breadcrumbs breadcrumbs-personalized">
				<div class="navbar navbar-personalized navbar-inverse padding-xs pull-right" role="navigation" style="top:-4px;">									
					<ul class="nav navbar-nav">
						<li class="padding-xs-hr no-padding-r">
							<div id="personalized-buttons" class="btn-group navbar-btn rounded-bottom">
								<button type="button" class="btn-u btn-u-dark-blue rounded-left" 
									data-toggle="button" 
									data-action="show-gallery-section"><i class="fa fa-picture-o"></i> <span class="hidden-xs">My 포토</span></button>
								<button type="button" class="btn-u btn-u-dark-blue rounded-right" 
									data-toggle="spmenu" 
									data-target="#personalized-controls-section" disabled><i class="fa fa-cloud-upload fa-lg"></i> <span class="hidden-xs">My 드라이브</span></button>
							</div>
						</li>							
						<li class="hidden-xs"><p class="navbar-text">레이아웃</p> </li>
						<li class="hidden-xs">
							<div class="btn-group navbar-btn" data-toggle="buttons">
								<label class="btn btn-info rounded-left">
									<input type="radio" name="personalized-area-col-size" value="12"><i class="fa fa-square"></i>
								</label>
								<label class="btn btn-info active">
							 		<input type="radio" name="personalized-area-col-size" value="6"> <i class="fa fa-th-large"></i>
								</label>
								<label class="btn btn-info rounded-right">
									<input type="radio" name="personalized-area-col-size" value="4"> <i class="fa fa-th"></i>
								</label>
							</div>
						</li>
					</ul>				
				</div><!-- ./navbar-personalized -->			
			</div>
			
			<div id="main-content" class="container-fluid" style="min-height:300px;">
				<div id="personalized-area" class="row"></div>
			</div>		
			<!-- ./END MAIN CONTENT -->	
	 		<!-- START FOOTER -->
			<#include "/html/common/common-homepage-footer.ftl" >		
			<!-- ./END FOOTER -->					
		</div>				
			<!-- START RIGHT SLIDE MENU -->
			<section class="cbp-spmenu cbp-spmenu-vertical cbp-spmenu-right"  id="personalized-controls-section">		
				<!-- tab-v1 -->
				<button type="button" class="btn-close" data-dismiss='spmenu' >Close</button>
				<div class="tab-v1" >			
					<h5 class="side-section-title white">My 클라우드 저장소</h5>			
					<ul class="nav nav-tabs" id="myTab" style="padding-left:5px;">
						<#if !action.user.anonymous >	
						<li><a href="#my-photo-stream" tabindex="-1" data-toggle="tab">포토</a></li>
						<li><a href="#my-files" tabindex="-1" data-toggle="tab">파일</a></li>							
						</#if>						
					</ul>		
					<!-- tab-content -->		
					<div class="tab-content" style="background-color : #FFFFFF; padding:5px;">
						<!-- start attachement tab-pane -->
						<div class="tab-pane" id="my-files">
								<div class="panel panel-default panel-upload no-margin-b no-border-b" style="display:none;">
								<div class="panel-heading">
									<strong><i class="fa fa-cloud-upload  fa-lg"></i> 파일 업로드</strong> <button type="button" class="close btn-control-group" data-action="upload-close">&times;</button>
								</div>						
									<div class="panel-body">													
										<#if !action.user.anonymous >			
											<div class="page-header text-primary">
												<h5><i class="fa fa-upload"></i>&nbsp;<strong>파일 업로드</strong>&nbsp;<small>아래의 <strong>파일 선택</strong> 버튼을 클릭하여 파일을 직접 선택하거나, 아래의 영역에 파일을 끌어서 놓기(Drag & Drop)를 하세요.</small></h5>
											</div>								
											<input name="uploadAttachment" id="attachment-files" type="file" />												
										</#if>								
									</div>
								</div>
							<div class="panel panel-default">
								<div class="panel-body">
									<p class="text-muted"><small><i class="fa fa-info"></i> 파일을 선택하면 아래의 마이페이지 영역에 선택한 파일이 보여집니다.</small></p>
									<#if !action.user.anonymous >		
									<p class="pull-right">				
										<button type="button" class="btn btn-info btn-lg btn-control-group" data-toggle="button" data-action="upload"><i class="fa fa-cloud-upload"></i> 파일업로드</button>	
									</p>	
									</#if>																										
									<div class="btn-group" data-toggle="buttons" id="attachment-list-filter">
										<label class="btn btn-sm btn-warning active">
											<input type="radio" name="attachment-list-view-filters"  value="all"> 전체 (<span data-bind="text: totalAttachCount"></span>)
										</label>
										<label class="btn btn-sm btn-warning">
											<input type="radio" name="attachment-list-view-filters"  value="image"><i class="fa fa-filter"></i> 이미지
										</label>
										<label class="btn btn-sm btn-warning">
											<input type="radio" name="attachment-list-view-filters"  value="file"><i class="fa fa-filter"></i> 파일
										</label>	
									</div>												
								</div>
								<div class="panel-body sm-padding" style="min-height:450px;">
									<div id="attachment-list-view" class="file-listview"></div>
								</div>	
								<div class="panel-footer no-padding">
										<div id="pager" class="file-listview-pager k-pager-wrap"></div>
								</div>
							</div>																				
						</div><!-- end attachements  tab-pane -->		
						<!-- start photos  tab-pane -->
						<div class="tab-pane" id="my-photo-stream">									
												<div class="panel panel-default panel-upload no-margin-b no-border-b" style="display:none;">
							<div class="panel-heading">
								<strong><i class="fa fa-cloud-upload  fa-lg"></i> 사진 업로드</strong> <button type="button" class="close btn-control-group" data-action="upload-close">&times;</button>
							</div>												
													<div class="panel-body">
														<#if !action.user.anonymous >			
														<div class="page-header text-primary">
															<h5><i class="fa fa-upload"></i>&nbsp;<strong>사진 업로드</strong>&nbsp;<small>아래의 <strong>사진 선택</strong> 버튼을 클릭하여 사진을 직접 선택하거나, 아래의 영역에 사진를 끌어서 놓기(Drag & Drop)를 하세요.</small></h5>
														</div>
														<div id="my-photo-upload">	
															<input name="uploadPhotos" id="photo-files" type="file" />					
														</div>
														<div class="blank-top-5" ></div>
														<div class="page-header text-primary">
															<h5><i class="fa fa-upload"></i>&nbsp;<strong>URL 사진 업로드</strong>&nbsp;<small>사진이 존재하는 URL 을 직접 입력하여 주세요.</small></h5>
														</div>						
														<form name="photo-url-upload-form" class="form-horizontal" role="form">
															<div class="form-group">
																<label class="col-sm-2 control-label"><small>출처</small></label>
																<div class="col-sm-10">
																	<input type="url" class="form-control" placeholder="URL"  data-bind="value: data.sourceUrl">
																	<span class="help-block"><small>사진 이미지 출처 URL 을 입력하세요.</small></span>
																</div>
															</div>
															<div class="form-group">
																<label class="col-sm-2 control-label"><small>사진</small></label>
																<div class="col-sm-10">
																	<input type="url" class="form-control" placeholder="URL"  data-bind="value: data.imageUrl">
																	<span class="help-block"><small>사진 이미지 경로가 있는 URL 을 입력하세요.</small></span>
																</div>
															</div>														
															<div class="form-group">
																<div class="col-sm-offset-2 col-sm-10">
																	<button type="submit" class="btn btn-primary btn-sm btn-control-group" data-bind="events: { click: upload }" data-loading-text='<i class="fa fa-spinner fa-spin"></i>'><i class="fa fa-cloud-upload"></i> &nbsp; URL 사진 업로드</button>
																</div>
															</div>
														</form>
														</#if>
													</div>
												</div>	

							<div class="panel panel-default">			
								<div class="panel-body">
									<p class="text-muted"><small><i class="fa fa-info"></i> 사진을 선택하면 아래의 마이페이지 영역에 선택한 사진이 보여집니다.</small></p>
									<#if !action.user.anonymous >		
									<p class="pull-right">				
										<button type="button" class="btn btn-info btn-lg btn-control-group" data-toggle="button" data-action="upload"><i class="fa fa-cloud-upload"></i> &nbsp; 사진업로드</button>																		
									</p>	
									</#if>											
								</div>
								<div class="panel-body sm-padding" style="min-height:450px;">
									<div id="photo-list-view" class="image-listview" ></div>
								</div>	
								<div class="panel-footer no-padding">
									<div id="photo-list-pager" class="image-listview-pager k-pager-wrap"></div>
								</div>
							</div>	
						</div><!-- end photos  tab-pane -->
					</div><!-- end of tab content -->
				</div>	
			</section>	
			<div class="cbp-spmenu-overlay"></div>			
			<!-- ./END RIGHT SLIDE MENU -->
							
		<!-- START TEMPLATE -->									
	<!-- ============================== -->
	<!-- gallery template                                        -->
	<!-- ============================== -->
	<script type="text/x-kendo-template" id="image-gallery-thumbnail-template">
	<li class="item"><a href="\\#" class=""><img src="${request.contextPath}/community/download-my-image.do?width=150&height=150&imageId=#= imageId#" alt="" /></a></li>
	</script>
		
	<script type="text/x-kendo-template" id="image-gallery-item-template">	
	<div class="superbox-list" data-ride="gallery" >
		<img src="${request.contextPath}/community/download-my-image.do?width=150&height=150&imageId=#= imageId#" data-img="${request.contextPath}/community/download-my-image.do?imageId=#= imageId#" alt="" title="#: name #" class="superbox-img superbox-img-thumbnail animated zoomIn">
	</div>			
	</script>

	<script type="text/x-kendo-template" id="image-gallery-expanding-template">	
	<div class="og-expander animated slideDown">
		<div class="og-expander-inner">
			<span class="og-close"></span> 
			<div class="og-fullimg">
				<div class="og-loading" style="display: none;"></div>
				<img src="#= src #" style="display: inline;" class="lightbox" data-ride="lightbox">
			</div>
			<div class="og-details">
				<h5>#: title #</h5>
				<p>
				<button data-ride="lightbox" data-selector="a[data-largesrc]" class="btn-u btn-u-orange"><i class="fa fa-bolt"></i> 슬라이드 쇼</button>
				</p>
				
			</div>
		</div>
	</div>
	</script>
	
	<script type="text/x-kendo-template" id="image-gallery-grid-template">	
	<li>
		<a href="\\#" class="zoomer" data-largesrc="${request.contextPath}/community/download-my-image.do?imageId=#= imageId#" data-title="#=name#" data-description="#=name#" data-ride="expanding" data-target-gallery="\\#image-gallery-grid" >
			<span class="overlay-zoom">
				<img src="${request.contextPath}/community/download-my-image.do?width=150&height=150&imageId=#= imageId#" class="img-responsive animated zoomIn" />
				<span class="zoom-icon"></span>
			</span>
		</a>	
	</li>			
	</script>
	
	<script type="text/x-kendo-template" id="image-gallery-template">	
	<div id="image-gallery" class="one-page  no-padding-t no-border" style="display:none;">
		<div class="one-page-inner no-padding-t">
			<div class="container">
				<div class="row">
					<div class="col-xs-12 padding-sm">					
						<div class="panel panel-default rounded">
							<div class="panel-heading">						
							<button type="button" class="btn-close btn-close-grey btn-xs" data-dismiss="panel" data-dismiss-target="#image-gallery" data-animate="slideUp"  data-toggle-target="button[data-action='show-gallery-section']" ><span class="sr-only">Close</span></button>
							<h3 class="panel-title"><i class="fa fa-picture-o"></i> MY 포토(업로드 및 수정)</h3>
							</div>
							<div class="panel-body padding-sm no-padding-hr no-padding-t" style="min-height:300px;">
								<ul id="image-gallery-grid" class="og-grid no-padding"></ul>
								<div id="image-gallery-slider" class="superbox"></div>
							</div>
							<div class="panel-footer no-padding"><div id="image-gallery-pager" class="k-pager-wrap no-border no-margin-t "></div></div>
						</div>						
					</div>	
				</div>			
			</div>
		</div>	
	</div>
	</script>
	<!-- ============================== -->
	<!-- notice template                                        -->
	<!-- ============================== -->
	<script type="text/x-kendo-template" id="notice-options-template">	
	<div class="popover bottom">
		<div class="arrow"></div>
		<h3 class="popover-title">이벤트 소스 설정			
			<button type="button" class="close"><span aria-hidden="true">&times;</span><span class="sr-only">Close</span></button>
		</h3>
		<div class="popover-content">
			<h5 ><small><i class="fa fa-info"></i>공지 & 이벤트 소스를 변경할수 있습니다.</small></h5>	
			<div class="btn-group btn-group-sm" data-toggle="buttons">
				<label class="btn btn-success <#if action.user.anonymous >active</#if>">
					<input type="radio" class="js-switch" name="notice-selected-target" value="30" >사이트
				</label>
				<label class="btn btn-success <#if !action.user.anonymous >active</#if>">
					<input type="radio" class="js-switch" name="notice-selected-target" value="1">My 회사
				</label>
			</div>
		</div>
	</div>
	</script>
	
	<script type="text/x-kendo-template" id="notice-viewer-template">	
	<div class="panel panel-default no-border no-margin-b padding-sm" data-bind="visible: visible">
		<div class="panel-heading" style="background-color: \\#fff; ">
			<h4 class="panel-title" data-bind="html:announce.subject"></h4>
		</div>
		<div class="panel-body padding-sm">
			<ul class="list-unstyled text-muted">
				<li><span class="label label-primary label-lightweight">게시 기간</span> <span data-bind="text: announce.formattedStartDate"></span> ~ <span data-bind="text: announce.formattedEndDate"></span></li>
				<li><span class="label label-default label-lightweight">생성일</span> <span data-bind="text: announce.formattedCreationDate"></span></li>
				<li><span class="label label-default label-lightweight">수정일</span> <span data-bind="text: announce.formattedModifiedDate"></span></li>
			</ul>	
		<div class="media">
			<a class="pull-left" href="\\#">
				<img data-bind="attr:{ src: profilePhotoUrl }" width="30" height="30" class="img-rounded">
			</a>
			<div class="media-body">
				<h5 class="media-heading">																	
					<p><span data-bind="visible:announce.user.nameVisible, text: announce.user.name"></span> <code data-bind="text: announce.user.username"></code></p>
					<p data-bind="visible:announce.user.emailVisible, text: announce.user.email"></p>
				</h5>		
			</div>		
		</div>	
		<hr class="devider no-margin-t">
			<div data-bind="html: announce.body " />		
		</div>
	</div>
	<div class="notice-grid no-border-hr no-border-b" style="min-height: 300px"></div>
	</script>		
	<#include "/html/common/common-homepage-templates.ftl" >		
	<#include "/html/common/common-personalized-templates.ftl" >
	<!-- ./END TEMPLATE -->
	</body>    
</html>