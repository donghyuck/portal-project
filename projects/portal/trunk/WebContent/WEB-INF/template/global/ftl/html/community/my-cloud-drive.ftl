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
			'css!${request.contextPath}/styles/jquery.magnific-popup/magnific-popup.css',						
			'css!${request.contextPath}/styles/codrops/codrops.grid.min.css',
			'css!${request.contextPath}/styles/codrops/codrops.cbp-spmenu.css',					
			'css!${request.contextPath}/styles/bootstrap.themes/unify/colors/blue.css',	
			'css!${request.contextPath}/styles/common.pages/common.personalized.css',
				
			'${request.contextPath}/js/jquery/1.10.2/jquery.min.js',
			'${request.contextPath}/js/jgrowl/jquery.jgrowl.min.js',
			'${request.contextPath}/js/jquery.magnific-popup/jquery.magnific-popup.min.js',	
			'${request.contextPath}/js/kendo/kendo.web.min.js',
			'${request.contextPath}/js/kendo.extension/kendo.ko_KR.js',			
			'${request.contextPath}/js/kendo/cultures/kendo.culture.ko-KR.min.js',			
			'${request.contextPath}/js/bootstrap/3.2.0/bootstrap.min.js',
			'${request.contextPath}/js/common.plugins/jquery.slimscroll.min.js', 		
			'${request.contextPath}/js/common.plugins/query.backstretch.min.js', 					
			'${request.contextPath}/js/pdfobject/pdfobject.js',	
			'${request.contextPath}/js/common/common.ui.core.js',							
			'${request.contextPath}/js/common/common.ui.data.js',
			'${request.contextPath}/js/common/common.ui.community.js',
			'${request.contextPath}/js/common.pages/common.personalized.js'
			],			
			complete: function() {			
					
				// FEATURES SETUP	
				common.ui.setup({
					features:{
						wallpaper : true,
						lightbox : true,
						spmenu : true,
						accounts : {
							authenticate : function(e){
								e.token.copy(currentUser);
								if( !currentUser.anonymous ){		
									common.ui.enable( $("#personalized-buttons button")	);					 
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

				// menu active setting	
				$(".navbar-nav li[data-menu-item='MENU_PERSONALIZED'], .navbar-nav li[data-menu-item='MENU_PERSONALIZED_2']").addClass("active");
				
				// personalized grid setting																																					
				preparePersonalizedArea($("#personalized-area"), 3, 6 );
				
				// personalized buttons setting							
				common.ui.buttonGroup($("#personalized-buttons"), {
					handlers :{
						"show-gallery-section" : function(e){
							common.ui.disable($(e.target));
							createGallerySection();
						}
					}				
				});	
																															
				// SpMenu Tabs								
				$('#myTab').on( 'show.bs.tab', function (e) {
					//e.preventDefault();		
					var show_bs_tab = $(e.target);
					if( show_bs_tab.attr('href') == '#my-files' ){					
						createAttachmentListView();
					} else if(show_bs_tab.attr('href') == '#my-photo-stream' ){					
						createPhotoListView();
					}					
				});
				
				// SpMenu Tabs select first				
				$("#personalized-controls-section").on("open", function(e){
					$('#myTab a:first').tab('show') ;
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
					'${request.contextPath}/data/images/list.json?output=json',
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
							data : "images",
							total : "totalCount"
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
		<!-- ============================== -->
		<!-- create my attachment grid							-->
		<!-- ============================== -->		
		function createAttachmentListView(){					
			if( !common.ui.exists($('#attachment-list-view')) ){
				var attachementTotalModle = common.ui.observable({ 
					totalAttachCount : "0",
					totalImageCount : "0",
					totalFileCount : "0"							
				});					
			}		
			if( !common.ui.exists($('#attachment-list-view')) ){						
				var attachementTotalModle = common.ui.observable({ 
					totalAttachCount : "0",
					totalImageCount : "0",
					totalFileCount : "0"							
				});
				common.ui.bind($("#attachment-list-filter"), attachementTotalModle);
				common.ui.listview(
					$("#attachment-list-view"),
					{				
						dataSource : common.ui.datasource(
							"${request.contextPath}/data/files/list.json?output=json", 
							{
								transport:{
									destroy: { url:"${request.contextPath}/community/delete-my-attachment.do?output=json", type:"POST" }, 
									parameterMap: function (options, operation){
										if (operation != "read" && options) {										                        								                       	 	
											return { attachmentId :options.attachmentId };									                            	
										}else{
											 return { startIndex: options.skip, pageSize: options.pageSize }
										}
									}
								},
								pageSize: 12,
								schema: {
									model: common.ui.data.Attachment,
									data : "files",
									total : "totalCount"
								},
								sort: { field: "attachmentId", dir: "desc" },
								filter :  { field: "contentType", operator: "neq", value: "" }							
							}
						),
						selectable: false,				
						change: function(e) {									
							var data = this.dataSource.view() ;
							var item = data[this.select().index()];		
							$("#attachment-list-view").data( "attachPlaceHolder", item );												
						},		
						navigatable: false,
						template: kendo.template($("#attachment-list-view-template").html()),			
						dataBound: function(e) {
							//var attachment_list_view = common.ui.$('#attachment-list-view').data('kendoListView');
							var filter =  this.dataSource.filter().filters[0].value;
							var totalCount = this.dataSource.total();
							if( filter == "image" ) 
							{
								attachementTotalModle.set("totalImageCount", totalCount);
							} else if ( filter == "application" ) {
								attachementTotalModle.set("totalFileCount", totalCount);
							} else {
								attachementTotalModle.set("totalAttachCount", totalCount);
							}
						}											
				});				
				$("#attachment-list-view").on("mouseenter",  ".file-wrapper", function(e) {
					common.ui.fx($(e.currentTarget).find(".file-description")).expand("vertical").stop().play();
				}).on("mouseleave", ".file-wrapper", function(e) {
					common.ui.fx($(e.currentTarget).find(".file-description")).expand("vertical").stop().reverse();
				});	
				$("input[name='attachment-list-view-filters']").on("change", function () {
					var attachment_list_view = common.ui.listview($("#attachment-list-view"));
					switch(this.value){
							case "all" :
								attachment_list_view.dataSource.filter(  { field: "contentType", operator: "neq", value: "" } ) ; 
								break;
							case "image" :
								attachment_list_view.dataSource.filter( { field: "contentType", operator: "startswith", value: "image" }) ; 
								break;
							case "file" :
								attachment_list_view.dataSource.filter( { field: "contentType", operator: "startswith", value: "application" }) ; 
								break;
					}
				});				
				common.ui.pager($("#pager"),{ buttonCount : 5, dataSource : common.ui.listview($("#attachment-list-view")).dataSource });			
				
				$("#attachment-list-view").on("click", ".file-wrapper button", function(e){
					var index = $(this).closest("[data-uid]").index();
					var data = common.ui.listview($('#attachment-list-view')).dataSource.view();					
					var item = data[index];			
					showAttachmentPanel(item);
					$(this).addClass("disabled");
				});
								
				common.ui.buttons(
					$("#my-files button.btn-control-group"),
					{
						handlers : {
							upload : function(e){
								if( !common.ui.exists($('#attachment-files')) ){
									common.ui.upload(
										$("#attachment-files"),
										{
											multiple : false,
											async : {
												saveUrl:  '${request.contextPath}/community/save-my-attachments.do?output=json',
											},
											success : function(e) {								    
												if( e.response.targetAttachment ){
													e.response.targetAttachment.attachmentId;
													common.ui.listview($("#attachment-list-view")).refresh();
												}				
											}
										}
									);
								}								
								$("#my-files .panel-upload").slideToggle(200);			
							},
							'upload-close' : function(e){
								$("#my-files .panel-upload").slideToggle(200);			
							}	
						}
					}
				);				
			}		
		}				
		
		function showAttachmentPanel(attachment){				
			var appendTo = getNextPersonalizedColumn($("#personalized-area"));
			var panel = common.ui.extPanel(
			appendTo,
			{ 
				title: '<i class="fa fa-file-o"></i> ' + attachment.name  , 
				actions:["Custom", "Minimize", "Close"],
				data: attachment,
				css : "panel-danger",
				custom: function(e){					
					alert("준비중입니다.");
				},
				open: function(e){
					var data = e.target.data(),
					uid = e.target.element.attr("id"),
					embed = uid + "-fileview"; 
					if( data.contentType === "application/pdf" ){	
						e.target.element.find(".panel-body").html("<div id='"+ embed + "' style='height:500px;'></div>"); 				
						var myPdf = new PDFObject({ url: "${request.contextPath}/download/file/" + data.attachmentId + "/" + data.name, pdfOpenParams: { navpanes: 1, statusbar: 0, view: "FitV" } }).embed(embed);
					}				
				}
			});
			panel.show();		
		}
		<!-- ============================== -->
		<!-- create my photo grid									-->
		<!-- ============================== -->				
		function createPhotoListView(){
			if( !common.ui.exists($('#photo-list-view')) ){
				common.ui.listview(
					$('#photo-list-view'),
					{
						dataSource : common.ui.datasource(
							'${request.contextPath}/data/images/list.json?output=json',
							{
								transport : {
									parameterMap :  function (options, operation){
										if (operation != "read" && options) {										                        								                       	 	
											return { imageId :options.imageId };									                            	
										}else{
											 return { startIndex: options.skip, pageSize: options.pageSize }
										}
									}
								},
								pageSize: 12,
								schema: {
									model: common.ui.data.Image,
									data : "images",
									total : "totalCount"
								}
							}
						),
						selectable: false,
						change: function(e) {
							var data = this.dataSource.view() ;
							var current_index = this.select().index();
							var total_index = this.dataSource.view().length -1 ;
							var list_view_pager = $("#photo-list-pager").data("kendoPager");	
							var item = data[current_index];								
							//$("#photo-list-view").data( "photoPlaceHolder", item );														
							//displayPhotoPanel( ) ;	
						},
						navigatable: false,
						template: kendo.template($("#photo-list-view-template").html())
					}
				);			
				
				$("#photo-list-view").on("mouseenter",  ".img-wrapper", function(e) {
					common.ui.fx($(e.currentTarget).find(".img-description")).expand("vertical").stop().play();
				}).on("mouseleave", ".img-wrapper", function(e) {
					common.ui.fx($(e.currentTarget).find(".img-description")).expand("vertical").stop().reverse();
				});					
					
				common.ui.pager( $("#photo-list-pager"), { buttonCount : 9, dataSource : common.ui.listview($('#photo-list-view')).dataSource });				

				$("#photo-list-view").on("click", ".img-wrapper button", function(e){
					var index = $(this).closest("[data-uid]").index();
					var data = common.ui.listview($('#photo-list-view')).dataSource.view();					
					var item = data[index];			
					showPhotoPanel(item);
				});					
									
				common.ui.buttons($("#my-photo-stream button.btn-control-group[data-action]"), {
					handlers : {
						"upload" : function(e){				
							if( !common.ui.exists($("#photo-files")) ){
								common.ui.upload($("#photo-files"),{
									async: {
										saveUrl:  '${request.contextPath}/community/update-my-image.do?output=json'
									},
									success : function(e) {	
										var photo_list_view = common.ui.listview($('#photo-list-view'));
										photo_list_view.dataSource.read();								
									}		
								});		
								var model = common.ui.observable({
									data : {
										sourceUrl : null, 
										imageUrl : null
									},
									reset: function(e){
										this.data.sourceUrl = null;
										this.data.imageUrl = null;
									},
									upload: function(e) {
										e.preventDefault();	
										var hasError = false;	
										$('#my-photo-stream form div.form-group.has-error').removeClass("has-error");								
										if( this.data.sourceUrl == null || this.data.sourceUrl.length == 0 || !common.valid("url", this.data.sourceUrl) ){
											$('#my-photo-stream form div.form-group').eq(0).addClass("has-error");			
											hasError = true;					
										}else{
											if( $('#my-photo-stream form div.form-group').eq(0).hasClass("has-error") ){
												$('#my-photo-stream form div.form-group').eq(0).removeClass("has-error");
											}											
										}																				
										if( this.data.imageUrl == null || this.data.imageUrl.length == 0 || !common.valid("url", this.data.imageUrl)  ){
											$('#my-photo-stream form div.form-group').eq(1).addClass("has-error");
											hasError = true;		
										}else{
											if( $('#my-photo-stream form div.form-group').eq(1).hasClass("has-error") ){
												$('#my-photo-stream form div.form-group').eq(1).removeClass("has-error");
											}											
										}				
										if( !hasError ){
											var btn = $(e.target);
											btn.button('loading');			
											common.ui.data.image.upload( {
												data : this.data ,
												success : function(response){
													var photo_list_view = common.ui.listview($('#photo-list-view'));
													photo_list_view.dataSource.read();		
												},
												always : function(){
													btn.button('reset');
													$('#my-photo-stream form')[0].reset();
													model.reset();
												}
											});		
										}				
										return false;
									}
								});
								kendo.bind($("#my-photo-stream form"), model);							
							}											
							$('#my-photo-stream form div.form-group.has-error').removeClass("has-error");
							$("#my-photo-stream .panel-upload").slideToggle(200);	
						},
						"upload-close" : function(e){
							$("#my-photo-stream .panel-upload").slideToggle(200);		
						}	
					}
				});
			}			
		}	
		function showPhotoPanel(image){				
			var appendTo = getNextPersonalizedColumn($("#personalized-area"));
			var panel = common.ui.extPanel(
			appendTo,
			{ 
				title: '<i class="fa fa-picture-o"></i> ' + image.name  , 
				actions:["Custom", "Minimize", "Close"],
				data: image,
				template : common.ui.template($("#photo-view-template").html()),
				css : "panel-primary",
				custom: function(e){
					var $this = e.target; 
					var body = $this.element.children(".panel-custom-body");
					if( body.children().length === 0 ){						
						body.html($("#photo-editor-modal-template").html());						
						var publicStream = body.find("input[name='photo-public-shared']");
						var upload = body.find("input[name='update-photo-file']");
						var grid = body.find(".photo-props-grid");		
						common.ui.upload( upload, {
							async : {
								saveUrl:  '${request.contextPath}/community/update-my-image.do?output=json',
							},
							localization:{ select : '사진 선택' , dropFilesHere : '새로운 사진파일을 이곳에 끌어 놓으세요.' },	
							upload: function (e) {				
								e.data = { imageId: $this.data().imageId };
							},
							success: function (e) {							
							}
						} );

						common.ui.grid(grid, {
							dataSource : common.ui.data.image.property.datasource($this.data().imageId),
							columns: [
								{ title: "속성", field: "name" },
								{ title: "값",   field: "value" },
								{ command:  { name: "destroy", text:"삭제" },  title: "&nbsp;", width: 100 }
							],
							pageable: false,
							resizable: true,
							editable : true,
							scrollable: true,
							autoBind: true,
							toolbar: [
								{ name: "create", text: "추가" },
								{ name: "save", text: "저장" },
								{ name: "cancel", text: "취소" }
							],				     
							change: function(e) {
								this.refresh();
							}
						});		
																							
						common.ui.data.image.streams($this.data().imageId, function(data){
							if( data.length > 0 )
								publicStream.first().click();
							else
								publicStream.last().click();	
						});						
					}
				},
				open: function(e){
					//var data = e.target.data(),
					//uid = e.target.element.attr("id"),
					//embed = uid + "-fileview"; 
					//if( data.contentType === "application/pdf" ){	
					//	e.target.element.find(".panel-body").html("<div id='"+ embed + "' style='height:500px;'></div>"); 				
					//	var myPdf = new PDFObject({ url: "${request.contextPath}/download/file/" + data.attachmentId + "/" + data.name, pdfOpenParams: { navpanes: 1, statusbar: 0, view: "FitV" } }).embed(embed);
					//}	
								
				}
			});
			panel.show();		
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
				<div class="navbar navbar-default no-margin-b no-border" role="navigation">	
					<div class="container">
						<ul class="nav navbar-nav">
							<#list WebSiteUtils.getMenuComponent(webSiteMenu, "MENU_PERSONALIZED").components as item >
							<li data-menu-item="${item.name}"><a href="${item.page}">${item.title}<span class="sr-only">(current)</span></a></li>
							</#list>	
						</ul>																		
						<ul class="nav navbar-nav navbar-right">
							<li class="padding-xs-hr no-padding-r">
								<div id="personalized-buttons" class="btn-group navbar-btn rounded-bottom">
									<button type="button" class="btn-u btn-u-dark-blue rounded-left" 	data-toggle="button" data-action="show-gallery-section" disabled><i class="fa fa-picture-o"></i> <span class="hidden-xs">My 포토</span></button>
									<button type="button" class="btn-u btn-u-dark-blue rounded-right" data-toggle="spmenu" data-target="#personalized-controls-section" disabled><i class="fa fa-cloud-upload fa-lg"></i> <span class="hidden-xs">My 드라이브</span></button>
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
					</div>	
				</div><!-- ./navbar-personalized -->			
			</div>
			
			<div id="main-content" class="container-fluid padding-sm" style="min-height:300px;">
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
				<button type="button" class="btn-close" data-dismiss='spmenu' data-toggle-target="#personalized-buttons button[data-toggle='spmenu']">Close</button>
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
								<div class="panel panel-primary panel-upload no-margin-b border-2x" style="display:none;">
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
								<div class="panel-body bg-slivergray border-b">
									<p class="text-muted"><small><i class="fa fa-info"></i> 파일을 선택하면 아래의 마이페이지 영역에 선택한 파일이 보여집니다.</small></p>
									<#if !action.user.anonymous >		
									<p class="pull-right">				
										<button type="button" class="btn btn-info btn-lg btn-control-group rounded" data-toggle="button" data-action="upload"><i class="fa fa-cloud-upload"></i> 파일업로드</button>	
									</p>	
									</#if>																										
									<div class="btn-group" data-toggle="buttons" id="attachment-list-filter">
										<label class="btn btn-sm btn-warning rounded-left active">
											<input type="radio" name="attachment-list-view-filters"  value="all"> 전체 (<span data-bind="text: totalAttachCount"></span>)
										</label>
										<label class="btn btn-sm btn-warning">
											<input type="radio" name="attachment-list-view-filters"  value="image"><i class="fa fa-filter"></i> 이미지
										</label>
										<label class="btn btn-sm btn-warning rounded-right">
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
							<div class="panel panel-primary panel-upload no-margin-b border-2x" style="display:none;">
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
								<div class="panel-body bg-slivergray border-b">
									<p class="text-muted"><small><i class="fa fa-info"></i> 사진을 선택하면 아래의 마이페이지 영역에 선택한 사진이 보여집니다.</small></p>
									<#if !action.user.anonymous >		
									<p class="pull-right">				
										<button type="button" class="btn btn-info btn-lg btn-control-group rounded" data-toggle="button" data-action="upload"><i class="fa fa-cloud-upload"></i> &nbsp; 사진업로드</button>																		
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
		<a href="\\#" class="zoomer" data-largesrc="${request.contextPath}/download/image/#= imageId #/#= name #" data-title="#=name#" data-description="#=name#" data-ride="expanding" data-target-gallery="\\#image-gallery-grid" >
			<span class="overlay-zoom">
				<img src="${request.contextPath}/download/image/#= imageId #/#= name #?width=150&height=150&imageId=#= imageId#" class="img-responsive animated zoomIn" />
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