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
			'css!<@spring.url "/styles/font-awesome/4.2.0/font-awesome.min.css"/>',
			'css!<@spring.url "/styles/bootstrap.themes/unify/colors/blue.css"/>',
			'css!<@spring.url "/styles/bootstrap.themes/unify/skins/dark.css"/>',
			'css!<@spring.url "/styles/jquery.magnific-popup/magnific-popup.css"/>',
			'css!<@spring.url "/styles/common/common.flat-icons.css"/>',		
			'css!<@spring.url "/styles/common.pages/common.personalized.css"/>',
			'css!<@spring.url "/styles/codrops/codrops.cbp-spmenu.css"/>',
			'css!<@spring.url "/styles/codrops/codrops.morphing.css"/>',			
			'<@spring.url "/js/jquery/1.10.2/jquery.min.js"/>',
			'<@spring.url "/js/jgrowl/jquery.jgrowl.min.js"/>',
			'<@spring.url "/js/jquery.magnific-popup/jquery.magnific-popup.min.js"/>',	
			'<@spring.url "/js/jquery.easing/jquery.easing.1.3.js"/>',		
			'<@spring.url "/js/jquery.bxslider/jquery.bxslider.min.js"/>',
			'<@spring.url "/js/kendo/kendo.web.min.js"/>',
			'<@spring.url "/js/kendo.extension/kendo.ko_KR.js"/>',			
			'<@spring.url "/js/kendo/cultures/kendo.culture.ko-KR.min.js"/>',			
			'<@spring.url "/js/bootstrap/3.3.0/bootstrap.min.js"/>',
			'<@spring.url "/js/common.plugins/jquery.slimscroll.min.js"/>', 		
			'<@spring.url "/js/common.plugins/query.backstretch.min.js"/>', 					
			'<@spring.url "/js/pdfobject/pdfobject.js"/>',			
			'<@spring.url "/js/common/common.ui.core.js"/>',							
			'<@spring.url "/js/common/common.ui.data.js"/>',
			'<@spring.url "/js/common/common.ui.community.js"/>',
			'<@spring.url "/js/common.pages/common.personalized.js"/>',
			'<@spring.url "/js/ace/ace.js"/>',
			'<@spring.url "/js/common.pages/common.code-editor.js"/>'
			],			
			complete: function() {		
				
				common.ui.setup({
					features:{
						wallpaper : true,
						lightbox : true,
						spmenu : false,
						morphing : true,
						accounts : {
							authenticate : function(e){
								e.token.copy(currentUser);
								if( !currentUser.anonymous ){		
									$("#announce-selector label.btn").last().removeClass("disabled");									 
								}
							} 
						}						
					},
					wallpaper : {
						slideshow : false
					},
					jobs:jobs
				});				
				// ACCOUNTS LOAD			
				var currentUser = new common.ui.data.User();			
				$(".navbar-nav li[data-menu-item='MENU_PERSONALIZED'], .navbar-nav li[data-menu-item='MENU_PERSONALIZED_1']").addClass("active");		
				// personalized grid setting				
				preparePersonalizedArea($("#personalized-area"), 3, 6 );				
				common.ui.buttonGroup($("#personalized-buttons"), {
					handlers :{
						"show-notification-panel" : function(e){
							common.ui.disable($(e.target));
							createNotificationPanel();
						},
						"show-memo-panel" : function(e){
							common.ui.disable($(e.target));
							createMemoPanel();
						}
					}
				});
				
				createAnnounceSection();				
				$(".morphing").bind("open.morphing", function(e){
					common.ui.scroll.top($("#my-announce-section").parent());
					createAnnounceEditorSection(common.ui.data.EMPTY_ANNOUNCE);					
				});					
				setupPersonalizedSection();			
				// END SCRIPT 				
			}
		}]);			
		<!-- ============================== -->
		<!-- Memo													   -->
		<!-- ============================== -->
		function createMemoPanel(){
			var renderTo = $("#my-memo-panel");
			if(!renderTo.data("kendoPanel")){
				new common.ui.extPanel( renderTo, { 
					content : "새로운 메모가 없습니다." ,
					deactivateAfterClose : false,
					close:function(e){
						$("#personalized-buttons button[data-target='#my-memo-panel']").toggleClass("active");
						common.ui.enable($("#personalized-buttons button[data-target='#my-memo-panel']"));
					}
				});
			}
			renderTo.data("kendoPanel").show();
		}
		<!-- ============================== -->
		<!-- Notify														-->
		<!-- ============================== -->
		function createNotificationPanel(){
			var renderTo = $("#my-notification-panel");
			if(!renderTo.data("kendoPanel")){
				new common.ui.extPanel( renderTo, { 
					content : "새로운 메시지가 없습니다." ,
					deactivateAfterClose : false,
					close:function(e){
						$("#personalized-buttons button[data-target='#my-notification-panel']").toggleClass("active");
						common.ui.enable($("#personalized-buttons button[data-target='#my-notification-panel']"));
					}
				});
			}
			renderTo.data("kendoPanel").show();
		}
		<!-- ============================== -->
		<!-- Announce												-->
		<!-- ============================== -->
		function createAnnounceSection(){
			
			var renderTo = $("#my-announce-section");
			var listRenderTo = $("#my-announce-section .my-announce-list");
			var viewRenderTo = $("#my-announce-section .my-announce-view");			
			var model =  common.ui.observable({ 
				announce : new common.ui.data.Announce(),
				editable : false,
				visible : false,
				new : function(e){
					e.stopPropagation();
					common.ui.scroll.top(renderTo.parent());
					$(".morphing").toggleClass("open");					
				},
				edit : function(e){
					e.stopPropagation();
					common.ui.scroll.top(renderTo.parent());
					createAnnounceEditorSection(this.announce);
					$(".morphing").toggleClass("open");					
				}
			});			
			model.bind("change", function(e){				
				if( e.field == "announce.user" ){ 				
					if( getCurrentUser().userId == this.get(e.field).userId )
						this.set("editable", true);
				}
			});
			var announceSelector = common.ui.buttonGroup(
				$("#announce-selector"),
				{
					change: function(e){						
						listRenderTo.data("kendoListView").dataSource.read({objectType:e.value});
					}
				}
			);				
			kendo.bind(viewRenderTo, model );
			common.ui.listview(	listRenderTo, {
					dataSource : common.ui.datasource(
						'<@spring.url "/data/announce/list.json"/>',
						{
							transport : {
								parameterMap: function(options, operation) {
									if( typeof options.objectType === "undefined"  ){
										return {objectType: announceSelector.value };	
									}else{			
										return options;		
									} 
								}
							},
							schema: {
								data : "announces",
								model : common.ui.data.Announce,
								total : "totalCount"
							}
						}
					),
					template: kendo.template($("#announce-listview-item-template").html()),
					selectable: "single" ,
					dataBound: function(e){
						model.set("visible", false);
					},
					change: function(e){						
						var selectedCells = this.select();
						var selectedCell = this.dataItem( selectedCells );	
						selectedCell.copy( model.announce );			
						model.set("visible", false);			
						if(!common.ui.visible(viewRenderTo)){
							viewRenderTo.slideDown();
						}						
						common.ui.scroll.top(viewRenderTo, -20);
					}
				}
			);
			common.ui.pager($("#my-announce-list-pager"), {dataSource: listRenderTo.data("kendoListView").dataSource });			
			//common.ui.scroll.slim(listRenderTo, { height: 320 });
			//common.ui.animate( renderTo, {	effects: "slide:down fade:in", show: true, duration: 1000 	} );			
		}
		
		function createAnnounceEditorSection(source){			
			var renderTo = $(".morphing");		
			if( !renderTo.data("model")){
				var model =  common.ui.observable({ 
					announce : new common.ui.data.Announce(),
					new: true,
					changed : false,
					update : function(e){
						var $this = this, 
						btn = $(e.target);						
						btn.button('loading');
						if( $this.announce.subject.length == 0 || $this.announce.body.length == 0 ){
							common.ui.notification({
								hide:function(e){
									btn.button('reset');
								}
							}).show(
								{	title:"공지 입력 오류", message: "제목 또는 본문을 입력하세요."	},
								"error"
							);
							return ;
						}
						if( $this.announce.startDate >= $this.announce.endDate  ){
							common.ui.notification({
								hide:function(e){
									btn.button('reset');
								}
							}).show(
								{	title:"공지 기간 입력 오류", message: "시작일자가 종료일자보다 이후일 수 없습니다."	},
								"error"
							);							
							return ;
						}
						common.ui.ajax(
							'<@spring.url "/data/announce/update.json"/>',
							{
								data : kendo.stringify( $this.announce ),
								contentType : "application/json",
								success : function(response){									
									var listRenderTo = $("#my-announce-section .my-announce-list");
									common.ui.listview(listRenderTo).dataSource.read();
									$this.close();
								},
								fail: function(){								
									common.ui.notification({
										hide:function(e){
											btn.button('reset');
										}
									}).show(
										{	title:"공지 저장 오류", message: "시스템 운영자에게 문의하여 주십시오."	},
										"error"
									);	
								},
								requestStart : function(){
									kendo.ui.progress(renderTo, true);
								},
								requestEnd : function(){
									kendo.ui.progress(renderTo, false);
								},
								complete : function(e){
									btn.button('reset');
								}
							});					
					},
					close : function(e){		
						$(".morphing ").toggleClass("open");			
					}
				});				
				var announceSelector = common.ui.buttonGroup($("#edit-announce-selector"), {
					change: function(e){							
						if( e.value != model.get("announce.objectType") ){				
							model.set("announce.objectType", e.value );
						}
					}
				});				
				model.bind("change", function(e){	
					if( e.field == "announce.objectType" && this.get(e.field) != announceSelector.value ){ 		
						announceSelector.select(this.get(e.field));
					}
				});				
				kendo.bind( renderTo, model);
				renderTo.data("model", model);
				var bodyEditor =  $("#announce-editor-body" );
				createEditor( "announce-editor" , bodyEditor );				
			}
			if( source ){
				source.copy( renderTo.data("model").announce );
				renderTo.data("model").set("announce.objectType", common.ui.buttonGroup($("#announce-selector")).value); 
				if( source.announceId === 0 ){
					renderTo.data("model").set("new", false); 
				}else{
					renderTo.data("model").set("new", false); 					
				} 
			}		
			renderTo.data("model").set("changed", false);
		}
		-->
		</script>		
		<style scoped="scoped">			
			#image-gallery-pager { 
				margin-top: 5px; 
			}			
			#my-announce-section .k-listview .k-state-selected
			{
				background : #F5F5F5;
				color: #585f69;
			}
			#my-announce-section .k-listview .k-state-selected .media-heading strong{
				font-weight:bold;
				text-decoration: underline;				
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
			<section class="personalized-section bg-transparent open" >
				<div class="personalized-section-heading">
					<span class="open animated"></span>
					<div class="container">
						<div class="personalized-section-title">
							<i class="icon-flat home"></i>
							<h3>MY 홈 <span>알림 메시지와 오늘을 할일을 확인하세요. <i class="fa fa-long-arrow-right"></i></span></h3>
							<div class="personalized-section-heading-controls">
								<div id="personalized-buttons" class="btn-group">
									<button type="button" class="btn-u btn-u-blue rounded-left" data-toggle="button" data-action="show-notification-panel" data-target="#my-notification-panel"><i class="fa fa-bell-o"></i> <span class="hidden-xs">알림</span> </button>
									<button type="button" class="btn-u btn-u-blue rounded-right" data-toggle="button" data-action="show-memo-panel"  data-target="#my-memo-panel" aria-pressed="false"><i class="fa fa-file-text-o"></i> <span class="hidden-xs">메모</span></button>
								</div>														
							</div>		
						</div>
					</div>				
				</div>
				<div class="personalized-section-content animated arrow-up">
					<span class="close animated"></span>
					<div class="container" style="min-height:150px;">
						<div class="row p-sm">
							<div class="col-md-3">						
								<div id="my-notification-panel" class="panel panel-danger rounded border-2x" style="display:none;">
									<div class="panel-heading">
										<h3 class="panel-title"><i class="fa fa-bell-o"></i>알림</h3>
										<div class="k-window-actions panel-header-controls"><div class="k-window-actions"><a role="button" href="#" class="k-window-action k-link"><span role="presentation" class="k-icon k-i-custom">Custom</span></a><a role="button" href="#" class="k-window-action k-link"><span role="presentation" class="k-icon k-i-minimize">Minimize</span></a><a role="button" href="#" class="k-window-action k-link"><span role="presentation" class="k-icon k-i-refresh">Refresh</span></a><a role="button" href="#" class="k-window-action k-link"><span role="presentation" class="k-icon k-i-close">Close</span></a></div></div></div>
									<div class="panel-body"></div>
								</div><!-- /.panel -->			
							</div><!-- /.col-md-3 -->
							<div class="col-md-3">				
								<div id="my-memo-panel" class="panel panel-primary rounded border-2x" style="display:none">
									<div class="panel-heading">
										<h3 class="panel-title"><i class="fa fa-file-text-o"></i> 메모</h3>
										<div class="k-window-actions panel-header-controls"><div class="k-window-actions"><a role="button" href="#" class="k-window-action k-link"><span role="presentation" class="k-icon k-i-custom">Custom</span></a><a role="button" href="#" class="k-window-action k-link"><span role="presentation" class="k-icon k-i-minimize">Minimize</span></a><a role="button" href="#" class="k-window-action k-link"><span role="presentation" class="k-icon k-i-refresh">Refresh</span></a><a role="button" href="#" class="k-window-action k-link"><span role="presentation" class="k-icon k-i-close">Close</span></a></div></div></div>
									<div class="panel-body"></div>
								</div><!-- /.panel -->																
							</div><!-- /.col-md-3 -->
						</div><!-- /.row -->
					</div>
				</div>				
			</section><!-- /.section -->

			<section class="personalized-section bg-grid open" >
				<div class="personalized-section-content animated" style="display:block;">
					<div class="container-fluid p-xs">
						<div class="row m-b-xs">
							<div class="col-sm-12">
								<div class="pull-right">
									<div class="btn-group navbar-btn no-margin" data-toggle="buttons">
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
								</div>	
							</div>
						</div>
						<div id="personalized-area" class="row"></div>
					</div>													
				</div>				
			</section><!-- /.section -->
						
			<section class="personalized-section bg-transparent open" >
							<#if !action.user.anonymous >
								<div class="morphing" >								
									<button class="btn-u btn-u-red animated" type="button" data-toggle="morphing" data-action="morphing"><i class="fa fa-plus lg"></i> <span class="hidden-xs"> 새로운 공지 & 이벤트</span></button>									
									<div class="morphing-content">
										<button type="button" class="btn-close btn-close-grey btn-xs" data-action="morphing"><span class="sr-only">Close</span></button>
										<div class="personalized-session-heading  bg-dark">
											<div class="container">
												<div class="personalized-session-title">
													<i class="icon-flat mega-phone"></i>
													<h4>공지 &amp; 이벤트 <span>공지 &amp; 이벤트 소스를 선택하세요. <i class="fa fa-long-arrow-right"></i></span></h4>
													<div class="personalized-session-heading-controls">
														<div id="edit-announce-selector" class="btn-group pull-right m-r-xl" data-toggle="buttons" data-role="buttongroup">
															<label class="btn btn-success btn-sm active rounded-left">
																<input type="radio" name="notice-target" value="30"><i class="fa fa-globe"></i> 사이트
															</label>
															<label class="btn btn-success btn-sm rounded-right">
																<input type="radio" name="notice-target" value="1"><i class="fa fa-building-o"></i> 회사
															</label>
														</div>														
													</div>		
												</div>
											</div>
										</div>
										<div class="personalized-session-content">
										
											<div class="container">
												<div class="row">
													<div class="col-sm-12 p-sm">													
														<h5 data-bind="visible: new">
															<small><span class="label label-danger">NEW</span> 모든 항목을 입력하여 주세요.</small>
														</h5>
														<div class="panel panel-default ">
															<div class="panel-heading padding-xxs-hr rounded-top" style="background-color: \\#fff; ">
																<h4 class="panel-title"><input type="text" placeholder="제목을 입력하세요." data-bind="value: announce.subject"  class="form-control" placeholder="제목" /></h4>		
															</div>			
															<div class="panel-body p-xxs">									
																<div  class="form">
																	<div class="form-group">
																		<label class="control-label">공지 기간</label>
																		<div class="col-sm-12" >
																			<input data-role="datetimepicker" data-bind="value:announce.startDate"> ~ <input data-role="datetimepicker" data-bind="value:announce.endDate">
																			<span class="help-block">지정된 기간 동안만 이벤트 및 공지가 보여집니다.</span>
																		</div>
																	</div>
																	<label class="control-label">본문</label>
																	<textarea id="announce-editor-body" class="no-border" data-bind='value:announce.body' style="height:500px;"></textarea>
																</div>						
															</div>				
														</div>										
														<div class="text-right">
															<button type="button" class="btn-u btn-u-blue btn-u-small" data-bind="events:{click:update}" data-loading-text="<i class='fa fa-spinner fa-spin'></i>">저장</button> <button type="button" class="btn-u btn-u-default btn-u-small" data-bind="events{click:close}">취소</button>
														</div>	
													</div>
												</div>
											</div>
										
										</div>
									</div>														
								</div>								
							</#if>
										
				<div class="personalized-section-heading">
					<span class="open animated"></span>
					<div class="container">
						<div class="personalized-section-title">
							<i class="icon-flat mega-phone"></i>
							<h4> 공지 &amp; 이벤트 <span>공지 &amp; 이벤트 소스를 선택하세요. <i class="fa fa-long-arrow-right"></i></span></h4>
							<div class="personalized-section-heading-controls">
								<div id="announce-selector" class="btn-group" data-toggle="buttons" data-role="buttongroup">
									<label class="btn btn-info btn-sm active rounded-left">
										<input type="radio" name="notice-target" value="30"><i class="fa fa-globe"></i> 사이트
									</label>
									<label class="btn btn-info btn-sm rounded-right disabled">
										<input type="radio" name="notice-target" value="1"><i class="fa fa-building-o"></i> 회사
									</label>
								</div>
							</div>		
						</div>
					</div>
				</div>
				<div id="my-announce-section" class="personalized-section-content animated arrow-up">
					<span class="close animated"></span>
					<div class="container">
						<div class="row">
							<div class="col-sm-6 p-sm">
								<div class="my-announce-list"></div>
								<div id="my-announce-list-pager"> </div>
							</div>
								<div class="col-sm-6 p-sm">
									<div class="panel panel-default no-border no-margin-b my-announce-view animated fadeIn"  style="display:none;"  data-bind="visible: visible">
										<div class="panel-heading">
											<h4 data-bind="html:announce.subject"></h4>
											<div class="panel-header-controls" data-bind="visible:editable">
												<button class="btn btn-primary btn-sm rounded" type="button" data-bind="click:edit"><i class="fa fa-pencil"></i>  편집</button>
											</div>
											<ul class="list-unstyled">
												<li class="text-muted"><span class="label label-info label-lightweight">게시 기간</span> <span data-bind="text:announce.formattedStartDate"></span> ~ <span data-bind="text:announce.formattedEndDate"></span></li>
												<hr>	
												<li class="text-muted"><span class="label label-primary label-lightweight">생성일</span> <span data-bind="text: announce.formattedCreationDate"></span></li>
												<hr>	
												<li class="text-muted"><span class="label label-primary label-lightweight">수정일</span> <span data-bind="text: announce.formattedModifiedDate"></span></li>
												<hr>	
												<li class="text-muted">
													<img width="30" height="30" class="img-circle pull-left" data-bind="attr:{src:announce.authorPhotoUrl}" src="/images/common/no-avatar.png" style="margin-right:10px;">
													<ul class="list-unstyled text-muted">
														<li><span data-bind="visible:announce.user.nameVisible, text: announce.user.name"></span><code data-bind="text: announce.user.username"></code></li>
														<li><span data-bind="visible:announce.user.emailVisible, text: announce.user.email"></span></li>
													</ul>																
												</li>	
												<hr>	
											</ul>	
										</div><!-- /.panel-heading -->
									<div class="panel-body padding-sm" data-bind="html:announce.body"></div>
								</div><!-- /.panel -->								
							</div>						
						</div>								
					</div>
				</div>
			</section>


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
	<li class="item"><a href="\\#" class=""><img src="<@spring.url "/community/download-my-image.do?width=150&height=150&imageId=#= imageId#"/>" alt="" /></a></li>
	</script>
		
	<script type="text/x-kendo-template" id="image-gallery-item-template">	
	<div class="superbox-list" data-ride="gallery" >
		<img src="<@spring.url '/community/download-my-image.do?width=150&height=150&imageId=#= imageId#'/>" data-img="<@spring.url "/community/download-my-image.do?imageId=#= imageId#"/>" alt="" title="#: name #" class="superbox-img superbox-img-thumbnail animated zoomIn">
	</div>			
	</script>

	<script type="text/x-kendo-template" id="image-gallery-grid-template">	
	<li>
		<a href="\\#" data-largesrc="<@spring.url "/community/download-my-image.do?imageId=#= imageId#"/>" data-title="#=name#" data-description="#=name#"/>" data-ride="expanding" data-target-gallery="\\#image-gallery-grid" >
			<img src="<@spring.url '/community/download-my-image.do?width=150&height=150&imageId=#= imageId#'/>" class="animated zoomIn" />
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
	<div class="media media-v2 padding-sm no-margin-t">
		<a class="pull-left" href="\\#"><img width="30" height="30" class="img-circle" src="/download/profile/#= user.username #?width=150&amp;height=150"></a>
		<div class="media-body">
			<h5 class="media-heading">
				# if (objectType == 30) { #
					<span class="label label-info">공지</span></span>
				# }else{ #
					<span class="label label-danger">알림</span></span>
				# } #				
				<strong>#: subject #</strong> 
			</h5>
			<div class="name-location">		
				작성자 : # if (user.nameVisible) { # #: user.name # # } else { # #:user.username # # } #</p>				
			</div>
		</div>
	</div>
	</script>										
	<#include "/html/common/common-homepage-templates.ftl" >		
	<#include "/html/common/common-personalized-templates.ftl" >
	<#include "/html/common/common-editor-templates.ftl" >	
	<!-- ./END TEMPLATE -->
	</body>    
</html>