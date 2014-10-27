<#ftl encoding="UTF-8"/>
<html decorator="homepage">
<head>
		<title><#if action.webSite ?? >${action.webSite.displayName }<#else>::</#if></title>
		<#compress>		
		<script type="text/javascript">
		<!--
		var jobs = [];	
				
		yepnope([{
			load: [
			'css!${request.contextPath}/styles/font-awesome/4.2.0/font-awesome.min.css',
			'css!${request.contextPath}/styles/common.themes/unify/themes/blue.css',			
			'css!${request.contextPath}/styles/common.pages/common.onepage.css',			
			'css!${request.contextPath}/styles/common.themes/unify/pages/profile.min.css',			
			'css!${request.contextPath}/styles/jquery.magnific-popup/magnific-popup.css',		
			'css!${request.contextPath}/styles/common.pages/common.personalized.css',
			'css!${request.contextPath}/styles/codrops/codrops.cbp-spmenu.css',		
			
						
			'${request.contextPath}/js/jquery/1.10.2/jquery.min.js',
			'${request.contextPath}/js/jgrowl/jquery.jgrowl.min.js',
			'${request.contextPath}/js/jquery.magnific-popup/jquery.magnific-popup.min.js',	
			'${request.contextPath}/js/jquery.easing/jquery.easing.1.3.js',		
			'${request.contextPath}/js/jquery.bxslider/jquery.bxslider.min.js',
			'${request.contextPath}/js/kendo/kendo.web.min.js',
			'${request.contextPath}/js/kendo.extension/kendo.ko_KR.js',			
			'${request.contextPath}/js/kendo/cultures/kendo.culture.ko-KR.min.js',			
			'${request.contextPath}/js/bootstrap/3.1.0/bootstrap.min.js',
			'${request.contextPath}/js/common.plugins/jquery.slimscroll.min.js', 		
			'${request.contextPath}/js/common.plugins/query.backstretch.min.js', 		
			
			'css!${request.contextPath}/js/codrops/codrops.grid.js',
				
			'${request.contextPath}/js/pdfobject/pdfobject.js',			
			'${request.contextPath}/js/common/common.ui.core.js',	
						
			'${request.contextPath}/js/common/common.models.js',
			'${request.contextPath}/js/common/common.api.js',
			'${request.contextPath}/js/common/common.ui.js',
			'${request.contextPath}/js/common.pages/common.personalized.js'
			],			
			complete: function() {		
				common.ui.setup({
					features:{
						backstretch : true,
						lightbox : true,
						spmenu : true
					},
					worklist:jobs
				});				
				// ACCOUNTS LOAD	
				var currentUser = new User();			
				$("#account-navbar").extAccounts({
					externalLoginHost: "${ServletUtils.getLocalHostAddr()}",	
					<#if action.isAllowedSignIn() ||  !action.user.anonymous  >
					template : kendo.template($("#account-template").html()),
					</#if>
					authenticate : function( e ){
						e.token.copy(currentUser);

					},				
					shown : function(e){
						if( !currentUser.anonymous ){
							common.ui.buttonEnabled( $('button[data-toggle="spmenu"]')	);
							common.ui.buttonEnabled( $('button[data-action="show-gallery-section"]') );
						}					
					}
				});	
				
				
				$(".navbar-nav li[data-menu-item='MENU_PERSONALIZED']").addClass("active");
				
				// personalized grid setting																																					
				preparePersonalizedArea($("#personalized-area"), 3, 6 );
				createAnnouncePanel();								
				// END SCRIPT 				
			}
		}]);	
		<!-- ============================== -->
		<!-- Announce										   -->
		<!-- ============================== -->
		function createAnnouncePanel(){
		
			var renderTo = $("#my-announce-panel");
			var listRenderTo = $("#my-announce-panel .panel-body.panel-body-list");
			var viewRenderTo = $("#my-announce-panel .panel-body.panel-body-view");
			var announce = new Announce ();
			kendo.bind(viewRenderTo, announce);			
			common.ui.listview(
				listRenderTo,
				{
					dataSource : common.ui.datasource(
						'${request.contextPath}/community/list-announce.do?output=json',
						{
							transport : {
								parameterMap: function(options, operation) {
									if( typeof options.objectType === "undefined"  ){
										return {objectType: 30 };	
									}else{			
										return options;		
									} 
								}
							},
							schema: {
								data : "targetAnnounces",
								model : Announce,
								total : "totalAnnounceCount"
							}							 
						}
					),
					template: kendo.template($("#announce-listview-item-template").html()),
					selectable: "single" ,
					change: function(e){						
						var selectedCells = this.select();
						var selectedCell = this.dataItem( selectedCells );	
						selectedCell.copy( announce );
						if(!common.ui.visible(viewRenderTo)){
							viewRenderTo.slideDown();
						}
					}
				}
			);
			common.ui.slimScroll(listRenderTo, {height: 320});
		}


		-->
		</script>		
		<style scoped="scoped">
			
			#image-gallery-pager { 
				margin-top: 5px; 
			}
			
			#my-announce-panel .color-two.k-state-selected{
				border-left: 2px solid #e74c3c;
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
				<div class="navbar navbar-personalized navbar-inverse padding-xs" role="navigation"  style="top:-4px;">		
					<ul class="nav navbar-nav pull-right">
						<li class="padding-xs-hr no-padding-r">
							<button type="button" class="btn-u btn-u-dark-blue navbar-btn rounded" data-toggle="button" data-action="show-notice-panel">공지 & 이벤트 </button>
						</li>
						<li class="padding-xs-hr no-padding-r">
						<button type="button" class="btn-u btn-u-dark-blue navbar-btn rounded" data-toggle="button" data-action="show-gallery-section" disabled>My 이미지 갤러리 </button>
						</li>
						<li class="padding-xs-hr no-padding-r">
							<button type="button" class="btn-u btn-u-blue navbar-btn rounded" data-toggle="spmenu" data-target="#personalized-controls-section" disabled><i class="fa fa-cloud-upload fa-lg"></i> <span class="hidden-xs">My 클라우드 저장소</span></button>
						</li>							
						<li class="hidden-xs"><p class="navbar-text">레이아웃</p> </li>
						<li class="hidden-xs">
							<div class="btn-group navbar-btn" data-toggle="buttons">
								<label class="btn btn-info">
									<input type="radio" name="personalized-area-col-size" value="12"><i class="fa fa-square"></i>
								</label>
								<label class="btn btn-info active">
							 		<input type="radio" name="personalized-area-col-size" value="6"> <i class="fa fa-th-large"></i>
								</label>
								<label class="btn btn-info">
									<input type="radio" name="personalized-area-col-size" value="4"> <i class="fa fa-th"></i>
								</label>
							</div>
						</li>
					</ul>
				</div><!-- ./navbar-personalized -->			
			</div>
			<div id="main-content" class="container-fluid content profile" style="min-height:300px;">	
				<div class="row">
					<div class="col-md-3 md-margin-bottom-40">
					
					</div>
					<div class="col-md-9">
						<div class="profile-body rounded padding-sm">
							<div class="row margin-bottom-20">
								<!--Announce Post-->
								<div class="col-sm-6">
									<div id="my-announce-panel" class="panel panel-profile no-bg">
										<div class="panel-heading overflow-h">
											<h2 class="panel-title heading-sm pull-left"><i class="fa fa-bell-o"></i>공지 & 이벤트</h2>
											<a href="#"><i class="fa fa-cog pull-right"></i></a>
										</div>
										<div class="panel-body panel-body-cfg" style="display:none;"></div>
										<div class="panel-body panel-body-view " style="display:none; padding:5px;">
											<div class="panel panel-default no-padding no-margin-b">
												<div class="panel-heading">
													<h4 data-bind="html:subject"></h4>
													<small class="text-muted"><span class="label label-info label-lightweight">게시 기간</span> <span data-bind="text:formattedStartDate"></span> ~ <span data-bind="text:formattedEndDate"></span></small>					
												</div>
												<div class="panel-body padding-sm" data-bind="html:body"></div>	
											</div>								
										</div>
										<div class="panel-body contentHolder no-border panel-body-list"></div>
									</div>
								</div><!--End Announce Post-->

                        <!--Profile Event-->
                        <div class="col-sm-6 md-margin-bottom-20">
                            <div class="panel panel-profile no-bg">
                                <div class="panel-heading overflow-h">
                                    <h2 class="panel-title heading-sm pull-left"><i class="fa fa-pencil-square-o"></i> 메모</h2>
                                    <a href="#"><i class="fa fa-cog pull-right"></i></a>
                                </div>
                                <div id="scrollbar2" class="panel-body contentHolder ps-container">
                                    <div class="profile-event">
                                        <div class="date-formats">
                                            <span>25</span>
                                            <small>05, 2014</small>
                                        </div>
                                        <div class="overflow-h">
                                            <h3 class="heading-xs"><a href="#">GitHub seminars in Japan.</a></h3>
                                            <p>Lorem Ipsum is simply dummy text of the printing and typesetting industry printing.</p>
                                        </div>    
                                    </div>
                                    <div class="profile-event">
                                        <div class="date-formats">
                                            <span>31</span>
                                            <small>06, 2014</small>
                                        </div>
                                        <div class="overflow-h">
                                            <h3 class="heading-xs"><a href="#">Bootstrap Update</a></h3>
                                            <p>Lorem Ipsum is simply dummy text of the printing and typesetting industry printing.</p>
                                        </div>    
                                    </div>
                                    <div class="profile-event">
                                        <div class="date-formats">
                                            <span>07</span>
                                            <small>08, 2014</small>
                                        </div>
                                        <div class="overflow-h">
                                            <h3 class="heading-xs"><a href="#">Apple Conference</a></h3>
                                            <p>Lorem Ipsum is simply dummy text of the printing and typesetting industry printing.</p>
                                        </div>    
                                    </div>
                                    <div class="profile-event">
                                        <div class="date-formats">
                                            <span>22</span>
                                            <small>10, 2014</small>
                                        </div>
                                        <div class="overflow-h">
                                            <h3 class="heading-xs"><a href="#">Backend Meeting</a></h3>
                                            <p>Lorem Ipsum is simply dummy text of the printing and typesetting industry printing.</p>
                                        </div>    
                                    </div>
                                    <div class="profile-event">
                                        <div class="date-formats">
                                            <span>14</span>
                                            <small>11, 2014</small>
                                        </div>
                                        <div class="overflow-h">
                                            <h3 class="heading-xs"><a href="#">Google Conference</a></h3>
                                            <p>Lorem Ipsum is simply dummy text of the printing and typesetting industry printing.</p>
                                        </div>    
                                    </div>
                                    <div class="profile-event">
                                        <div class="date-formats">
                                            <span>05</span>
                                            <small>12, 2014</small>
                                        </div>
                                        <div class="overflow-h">
                                            <h3 class="heading-xs"><a href="#">FontAwesome Update</a></h3>
                                            <p>Lorem Ipsum is simply dummy text of the printing and typesetting industry printing.</p>
                                        </div>    
                                    </div>
                                <div class="ps-scrollbar-x-rail" style="width: 389px; display: none; left: 0px; bottom: 2px;"><div class="ps-scrollbar-x" style="left: 0px; width: 0px;"></div></div><div class="ps-scrollbar-y-rail" style="top: 0px; height: 320px; display: inherit; right: 2px;"><div class="ps-scrollbar-y" style="top: 0px; height: 178px;"></div></div></div>    
                            </div>
                        </div>
                        <!--End Profile Event-->
                    </div>
                    </div>	

						
					</div>
				</div>

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

	<script type="text/x-kendo-template" id="image-gallery-grid-template">	
	<li>
		<a href="\\#" data-largesrc="${request.contextPath}/community/download-my-image.do?imageId=#= imageId#" data-title="#=name#" data-description="#=name#" data-ride="expanding" data-target-gallery="\\#image-gallery-grid" >
			<img src="${request.contextPath}/community/download-my-image.do?width=150&height=150&imageId=#= imageId#" class="animated zoomIn" />
		</a>	
	</li>			
	</script>
	
	<script type="text/x-kendo-template" id="image-gallery-template">	
	<div id="image-gallery" class="one-page  no-padding-t no-border" style="display:none;">
		<div class="one-page-inner one-grey">
			<div class="container">	
				<button type="button" class="btn-close btn-close-grey" data-dismiss="section" data-target="#image-gallery" data-animate="slideUp"  data-switch-target="button[data-action='show-gallery-section']" ><span class="sr-only">Close</span></button>
				<h5 class="side-section-title">MY 이미지 갤러리</h5>
				<div class="row">
					<div class="col-xs-12">
						<div class="bg-light no-padding">
							<ul id="image-gallery-grid" class="og-grid no-padding"></ul>
							<div id="image-gallery-slider" class="superbox"></div>
							<div id="image-gallery-pager" class="k-pager-wrap no-border-hr no-border-b"></div>	
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
	
	<script type="text/x-kendo-template" id="announce-listview-item-template">	
			<div class="profile-post bg-light">
				<span class="profile-post-numb">
					<img width="30" height="30" class="img-circle" src="/download/profile/#= user.username #?width=150&amp;height=150">
				</span>	
				<div class="profile-post-in">
					<h3 class="heading-xs">						
						# if (objectType == 30) { #
						<span class="label label-info">공지</span></span>
						# }else{ #
						<span class="label label-danger">알림</span></span>
						# } #		
						<span class="btn-link" >#: subject #</span>
						<p>작성자 : # if (user.nameVisible) { # #: user.name # # } else { # #:user.username # # } #</p>
					</h3>
					<p>게시 기간 :  #: formattedStartDate() # ~  #: formattedEndDate() #</p>
				</div>
			</div>
	</script>										
	<#include "/html/common/common-homepage-templates.ftl" >		
	<#include "/html/common/common-personalized-templates.ftl" >
	<!-- ./END TEMPLATE -->
	</body>    
</html>