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
			'css!<@spring.url "/styles/jquery.magnific-popup/magnific-popup.css"/>',						
			'css!<@spring.url "/styles/codrops/codrops.grid.min.css"/>',
			'css!<@spring.url "/styles/codrops/codrops.cbp-spmenu.css"/>',		
			'css!<@spring.url "/styles/codrops/codrops.dialog.css"/>',		
			'css!<@spring.url "/styles/codrops/codrops.dialog-val.css"/>',			
			'css!<@spring.url "/styles/codrops/codrops.page-loading-effects.css"/>',					
			'css!<@spring.url "/styles/bootstrap.themes/unify/colors/blue.css"/>',	
			'css!<@spring.url "/styles/common.pages/common.personalized.css"/>',
			'css!<@spring.url "/styles/common/common.flat-icons.css"/>',			
			'<@spring.url "/js/jquery/1.10.2/jquery.min.js"/>',
			'<@spring.url "/js/jgrowl/jquery.jgrowl.min.js"/>',
			'<@spring.url "/js/jquery.magnific-popup/jquery.magnific-popup.min.js"/>',	
			'<@spring.url "/js/kendo/kendo.web.min.js"/>',
			'<@spring.url "/js/kendo.extension/kendo.ko_KR.js"/>',			
			'<@spring.url "/js/kendo/cultures/kendo.culture.ko-KR.min.js"/>',			
			'<@spring.url "/js/bootstrap/3.2.0/bootstrap.min.js"/>',
			'<@spring.url "/js/common.plugins/jquery.slimscroll.min.js"/>', 		
			'<@spring.url "/js/common.plugins/query.backstretch.min.js"/>', 					
			'<@spring.url "/js/pdfobject/pdfobject.js"/>',	
			'<@spring.url "/js/snap.svg/snap.svg-min.js"/>',		
			'<@spring.url "/js/codrops/codrops.svg-loader.js"/>',		
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
				
				//setupPersonalizedSection();				
				// END SCRIPT 				
			}
		}]);	
		<!-- ============================== -->
		<!-- display image gallery                                  -->
		<!-- ============================== -->
		function createGallerySection(){
			var renderTo = "image-gallery";			
			
			var $section = $('.wrapper .personalized-section').first();		
			var section_heading = $section.children(".personalized-section-heading");
			var section_content = $section.children(".personalized-section-content");
		
			if( $( "#" +renderTo).length == 0 ){			
				section_content.append($("#image-gallery-template").html());
				var galleryDataSource = common.ui.datasource(
					'<@spring.url "/data/images/list.json?output=json" />',
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
				//common.ui.buttons("#image-gallery button[data-dismiss='panel'][data-dismiss-target]");							
				$section.find(".personalized-section-content>.close").click(function(e){ 
					var $this = $(this);
					$section.toggleClass("open");
					section_content.slideUp("slow", function(){
						var target = $("[data-action='show-gallery-section']");
						target.toggleClass("active");					
						common.ui.enable(target);
					});	
				});						
				galleryDataSource.read();	
			}
			if( section_content.is(":hidden") ){
				$section.toggleClass("open");
				section_content.slideDown("slow");				
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
							'<@spring.url "/data/files/list.json?output=json" />', 
							{
								transport:{
									destroy: { url: '<@spring.url "/community/delete-my-attachment.do?output=json" />', type:"POST" }, 
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
												saveUrl:  '<@spring.url "/data/files/upload.json?output=json" />',
											},
											success : function(e) {								    
												common.ui.listview($("#attachment-list-view")).dataSource.read();						
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
						var myPdf = new PDFObject({ url:  "<@spring.url "/download/file/" />" + data.attachmentId + "/" + data.name, pdfOpenParams: { navpanes: 1, statusbar: 0, view: "FitV" } }).embed(embed);
					}else if( data.contentType.match("^image")){ // === "application/pdf" ){				
						var template = kendo.template('<div class="box-shadow shadow-effect-2 rounded"><img class="img-responsive rounded img-bordered" src="<@spring.url "/download/file/#= attachmentId#/#= name#" />" alt=""></div>');
						e.target.element.find(".panel-body").html(template(data));
					}
				}
			});
			panel.show();		
		}
		<!-- ============================== -->
		<!-- create my photo grid									-->
		<!-- ============================== -->				
		function getMyDriverPhotoSource(){
			return $("#image-source-list input[type=radio][name=image-source]:checked").val();			
		}
		
		function createPhotoListView(){
			if( !common.ui.exists($('#photo-list-view')) ){
				common.ui.listview(
					$('#photo-list-view'),
					{
						dataSource : common.ui.datasource(
							'<@spring.url "/data/images/list.json?output=json" />',
							{
								transport : {
									parameterMap :  function (options, operation){
										if (operation != "read" && options) {										                        								                       	 	
											return { objectType:getMyDriverPhotoSource() , imageId :options.imageId };									                            	
										}else{
											 return { objectType:getMyDriverPhotoSource(), startIndex: options.skip, pageSize: options.pageSize }
										}
									}
								},
								pageSize: 24,
								schema: {
									model: common.ui.data.Image,
									data : "images",
									total : "totalCount"
								}
							}
						),
						selectable: "single",
						change: function(e) {
							var data = this.dataSource.view() ;
							var current_index = this.select().index();
							var total_index = this.dataSource.view().length -1 ;
							var list_view_pager = $("#photo-list-pager").data("kendoPager");	
							var item = data[current_index];								
						},
						navigatable: false,
						template: kendo.template($("#photo-list-view-template").html())
					}
				);			
				
				$("#image-source-list input[type=radio][name=image-source]").on("change", function () {
					common.ui.listview($('#photo-list-view')).dataSource.read();	
				});
				
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
					item.set("index", index );
					showPhotoPanel(item);
				});									
				
				common.ui.buttons($("#my-photo-stream button.btn-control-group[data-action]"), {
					handlers : {
						"upload" : function(e){				
							if( !common.ui.exists($("#photo-files")) ){
								common.ui.upload($("#photo-files"),{
									async: {
										saveUrl:  '<@spring.url "/data/images/update_with_media.json?output=json" />'
									},
									upload: function(e){
										e.data = {objectType:getMyDriverPhotoSource()};
									},
									success : function(e) {	
										var photo_list_view = common.ui.listview($('#photo-list-view'));
										photo_list_view.dataSource.read();								
									}		
								});		
								var model = common.ui.observable({
									data : {
										objectType : 2,
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
											this.data.objectType = getMyDriverPhotoSource();
											common.ui.data.image.uploadByUrl( {
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
			var renderTo = $("#image-viewer");			
			
			if( ! common.ui.exists(renderTo) ){			
				var $window = $(window);
				var observable =  common.ui.observable({ 
					image : new common.ui.data.Image(),
					resize : function(){
						renderTo.find("img.mfp-img").css("max-height", $window.height());					
					},
					hasPrevious: false,
					hasNext: false,
					previous : function(){
						var $this = this;
						if( $this.hasPrevious ){
							var index = $this.image.index - 1;
							var data = common.ui.listview($('#photo-list-view')).dataSource.view();					
							var item = data[index];				
							item.set("index", index );
							showPhotoPanel(item);		
						}
					},
					next : function(){
						var $this = this;						
						if( $this.hasNext ){
							var index = $this.image.index + 1;
							var data = common.ui.listview($('#photo-list-view')).dataSource.view();					
							var item = data[index];		
							item.set("index", index );
							showPhotoPanel(item);					
						}
					},
					setHasPrevious: function(){
						var $this = this;
						if( this.image.index > 0 && (this.image.index - 1) >= 0 )
							$this.set("hasPrevious", true); 
						else 
							$this.set("hasPrevious", false); 
					}, 
					setHasNext: function(){
						var $this = this;
						var size = common.ui.listview($('#photo-list-view')).dataSource.view().length;						
						if( ($this.image.index + 1 )< size && (size - this.image.index ) > 0 )
							$this.set("hasNext", true); 
						else 
							$this.set("hasNext", false); 
					}, 
					setImage: function(image){
						var $this = this;						
						image.copy($this.image);				
						
						$this.setHasPrevious();
						$this.setHasNext();
														
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
				$window.resize(function(){
					observable.resize();
				});		
				common.ui.dialog( renderTo , {
					data : observable,
					"open":function(e){								
					},
					"close":function(e){					
					}
				});				
				common.ui.bind(renderTo, observable );					
			}			
			var dialogFx = common.ui.dialog( renderTo );		
			dialogFx.data().setImage(image);			
			if( !dialogFx.isOpen ){							
				dialogFx.open();
			}
		}
		
		
				
		function showPhotoPanel2(image){				
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
						var streams = body.find("input[name='photo-public-shared']");
						var upload = body.find("input[name='update-photo-file']");
						var grid = body.find(".photo-props-grid");		
						common.ui.upload( upload, {
							async : {
								saveUrl:  '<@spring.url "/data/images/update_with_media.json?output=json" />'
							},
							localization:{ select : '사진 선택' , dropFilesHere : '새로운 사진파일을 이곳에 끌어 놓으세요.' },	
							upload: function (e) {				
								e.data = { imageId: $this.data().imageId };
							},
							success: function (e) {							
							}
						});
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
						
						//$this.data().set("shared", false );
						var Fn = function(){
							streams.on("change", function(e){
								var newValue = ( this.value == 1 ) ;
								if(newValue){
									common.ui.data.image.unshare($this.data().imageId);	
								}else{
									common.ui.data.image.share($this.data().imageId);
								}
							});						
						}			
						common.ui.data.image.streams($this.data().imageId, function(data){
							if( data.length > 0 )
								streams.first().click();
							else
								streams.last().click();	
							Fn();	
						});			
						
							
					}
				},
				open: function(e){
					//var data = e.target.data(),
					//uid = e.target.element.attr("id"),
					//embed = uid + "-fileview"; 								
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
			
			.dialog__content {
				width : 100%;
				max-width: none;				
				background: transparent;
				padding: 4em;
				top: 0;
				left: 0;
				position: absolute;
				height: 100%!important;
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
			<section class="personalized-section bg-transparent" >
				<div class="personalized-section-heading">
					<div class="container">
						<div class="personalized-section-title">
							<i class="icon-flat folder"></i>
							<h3>MY 드라이브 <span>PC는 문론 스마트폰, 태블릿에서도 이미지와 파일을 쉽게 정	리하고 관리하세요.. <i class="fa fa-long-arrow-right"></i></span></h3>
							<div class="personalized-section-heading-controls">
								<div id="personalized-buttons" class="btn-group">
									<button type="button" class="btn-u btn-u-blue rounded-left" 	data-toggle="button" data-action="show-gallery-section" disabled><i class="fa fa-picture-o"></i> <span class="hidden-xs">My 포토 탐색기</span></button>
									<button type="button" class="btn-u btn-u-blue rounded-right" data-feature-name="spmenu" data-toggle="spmenu" data-target-object-id="personalized-controls-section" disabled><i class="fa fa-cloud-upload fa-lg"></i> <span class="hidden-xs">My 드라이브</span></button>
								</div>					
							</div>		
						</div>
					</div>				
				</div>
				<div class="personalized-section-content animated arrow-up">
					<span class="close animated"></span>
				</div>			
			</section>		

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
			<!-- ./END MAIN CONTENT -->	
	 		<!-- START FOOTER -->
			<#include "/html/common/common-homepage-footer.ftl" >		
			<!-- ./END FOOTER -->					
		</div>			
		
		<div id="image-viewer" class="dialog" data-feature="dialog" data-dialog-animate="">
			<div class="dialog__overlay"></div>
			<div class="dialog__content">							
				<div class="mfp-container mfp-s-ready mfp-image-holder">
					<span class="btn-flat trash" data-dialog-trash></span>		
					<span class="btn-flat pencil grayscale" data-dialog-edit></span>				
					<span class="btn-flat close" data-dialog-close></span>					
					<div class="mfp-content">						
						<div class="mfp-figure">
							<figure>
								<img class="mfp-img" style="display: block;" data-bind="attr:{src:image.imageUrl}">
								<figcaption>
									<div class="mfp-bottom-bar">
										<div class="mfp-title" data-bind="text: image.name"></div>
										<div class="mfp-counter">sss</div>
									</div>
								</figcaption>
							</figure>
						</div>
					</div>	
					<div class="mfp-preloader" style="display: none;">
					</div>
					<button title="Previous (Left arrow key)" type="button" class="mfp-arrow mfp-arrow-left mfp-prevent-close" data-bind="visible: hasPrevious, click: previous"></button>
					<button title="Next (Right arrow key)" type="button" class="mfp-arrow mfp-arrow-right mfp-prevent-close" data-bind="visible: hasNext, click: next"></button>					
				</div>
			</div>
		</div>
		
		<!-- START RIGHT SLIDE MENU -->
		<section class="cbp-spmenu cbp-spmenu-vertical cbp-spmenu-right"  id="personalized-controls-section">
				<button type="button" class="btn-close" data-dismiss='spmenu' data-target-object="button[data-target-object-id='personalized-controls-section']">Close</button>
				<h5 class="side-section-title white">My 클라우드 저장소</h5>	
				<!-- details -->
				<div style="
				    position: absolute;
				    display: none;
				    background: #FDFAFA;
				    top: 80px;
				    min-height: 700%;
				    z-index: 1000;
				    width: 100%;
				">									
				</div>
				<!-- tab-v1 -->
				<div class="tab-v1 m-t-md" >							
					<ul class="nav nav-tabs" id="myTab">
						<#if !action.user.anonymous >	
						<li><a href="#my-photo-stream" tabindex="-1" data-toggle="tab">포토</a></li>
						<li><a href="#my-files" tabindex="-1" data-toggle="tab">파일</a></li>							
						</#if>						
					</ul>		
					<!-- tab-content -->		
					<div class="tab-content">
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
							<div class="panel panel-default no-margin-b">
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

							<div class="panel panel-default no-margin-b">			
								<div class="panel-body bg-slivergray border-b">
								<p class="text-muted"><small><i class="fa fa-info"></i> 사진을 선택하면 아래의 마이페이지 영역에 선택한 사진이 보여집니다.</small></p>
								<#if !action.user.anonymous >		
								<p class="pull-right">				
									<button type="button" class="btn btn-info btn-lg btn-control-group rounded" data-toggle="button" data-action="upload"><i class="fa fa-cloud-upload"></i> &nbsp; 사진업로드</button>																		
								</p>										
								<div class="btn-group" data-toggle="buttons" id="image-source-list">
									<label class="btn btn-sm btn-danger rounded-left active">
										<input type="radio" name="image-source"  value="2" checked="checked"><i class="fa fa-user"></i> ME
									</label>
									<label class="btn btn-sm btn-danger">
										<input type="radio" name="image-source"  value="30"><i class="fa fa-globe"></i> SITE
									</label>											
									<label class="btn btn-sm btn-danger rounded-right">
										<input type="radio" name="image-source"  value="1"><i class="fa fa-building-o"></i> COMPANY
									</label>
								</div>																			
								</#if>											
							</div>
							<div class="panel-body p-xxs">
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
	<li class="item"><a href="\\#" class=""><img src="<@spring.url "/community/download-my-image.do?width=150&height=150&imageId=#= imageId#" />" alt="" /></a></li>
	</script>
		
	<script type="text/x-kendo-template" id="image-gallery-item-template">	
	<div class="superbox-list" data-ride="gallery" >
		<img src="<@spring.url "/community/download-my-image.do?width=150&height=150&imageId=#= imageId#" />" data-img="<@spring.url "/community/download-my-image.do?imageId=#= imageId#"/>" alt="" title="#: name #" class="superbox-img superbox-img-thumbnail animated zoomIn">
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
		<a href="\\#" class="zoomer" data-largesrc="<@spring.url "/download/image/#= imageId #/#= name #"/>" data-title="#=name#" data-description="#=name#" data-ride="expanding" data-target-gallery="\\#image-gallery-grid" >
			<span class="overlay-zoom">
				<img src="<@spring.url "/download/image/#= imageId #/#= name #?width=150&height=150&imageId=#= imageId#" />" class="img-responsive animated zoomIn" />
				<span class="zoom-icon"></span>
			</span>
		</a>	
	</li>			
	</script>
	
	<script type="text/x-kendo-template" id="image-gallery-template">	
	<div id="image-gallery" >
		<ul id="image-gallery-grid" class="og-grid"></ul>
		<div class="container">
			<div class="row">
				<div class="col-md-offset-4 col-sm-6 col-xs-12  padding-sm">
					<div id="image-gallery-pager" class="k-pager-wrap no-border"></div>
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