<#ftl encoding="UTF-8"/>
<html decorator="unify">
<head>
		<#assign pageMenuName = "USER_MENU" />
		<#assign pageMenuItemName = "MENU_PERSONALIZED_2" />
		<#assign webSiteMenu = action.getWebSiteMenu(pageMenuName) />
		<#assign navigator = WebSiteUtils.getMenuComponent(webSiteMenu, pageMenuItemName) />		
						
		<title><#if action.webSite ?? >${action.webSite.displayName }<#else>::</#if></title>
		<#compress>		
		<script type="text/javascript">
		<!--
		var jobs = [];					
		yepnope([{
			load: [
			'css!<@spring.url "/styles/font-awesome/4.3.0/font-awesome.min.css"/>',
			'css!<@spring.url "/styles/jquery.magnific-popup/magnific-popup.css"/>',		
			'css!<@spring.url "/styles/jquery.sky-forms/2.0.1/custom-sky-forms.css"/>',
			'css!<@spring.url "/styles/codrops/codrops.dialog.css"/>',		
			'css!<@spring.url "/styles/codrops/codrops.dialog-val.css"/>',			
			'css!<@spring.url "/styles/codrops/codrops.cbp-spmenu.css"/>',		
			'css!<@spring.url "/styles/bootstrap.themes/unify/colors/blue.css"/>',	
			'css!<@spring.url "/styles/common.pages/common.personalized.css"/>',
			'css!<@spring.url "/styles/common/common.flat-icons.css"/>',			
			'<@spring.url "/js/jquery/1.10.2/jquery.min.js"/>',
			'<@spring.url "/js/jgrowl/jquery.jgrowl.min.js"/>',
			'<@spring.url "/js/jquery.magnific-popup/jquery.magnific-popup.min.js"/>',	
			'<@spring.url "/js/kendo/kendo.web.min.js"/>',
			'<@spring.url "/js/kendo.extension/kendo.ko_KR.js"/>',			
			'<@spring.url "/js/kendo/cultures/kendo.culture.ko-KR.min.js"/>',			
			'<@spring.url "/js/bootstrap/3.3.4/bootstrap.min.js"/>',
			'<@spring.url "/js/common.plugins/jquery.slimscroll.min.js"/>', 		
			'<@spring.url "/js/common.plugins/query.backstretch.min.js"/>', 					
			'<@spring.url "/js/pdfobject/pdfobject.js"/>',	
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
						renderTo:$(".interactive-slider-v2")
					},
					jobs:jobs
				});				
				// ACCOUNTS LOAD	
				var currentUser = new common.ui.data.User();			

				// menu active setting	
				preparePage({
					navbar : { parent: "MENU_PERSONALIZED", current: "MENU_PERSONALIZED_2"	}
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
				$('#myTab a:first').tab('show') ;
				
				// END SCRIPT 				
			}
		}]);	
		<!-- ============================== -->
		<!-- create my attachment grid							-->
		<!-- ============================== -->		
		function getMyDriverAttachmentSource(){
			return $("#attachment-source-list input[type=radio][name=attachment-source]:checked").val();			
		}
				
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
											return { objectType: getMyDriverAttachmentSource() , imageId :options.attachmentId };									                            	
										}else{
											 return { objectType: getMyDriverAttachmentSource(), startIndex: options.skip, pageSize: options.pageSize }
										}
									}
								},
								pageSize: 28,
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
				
				$("#attachment-source-list input[type=radio][name=attachment-source]").on("change", function () {
					common.ui.listview($('#attachment-list-view')).dataSource.read();	
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
					item.set("index", index);	
					showAttachmentPanel(item);
				});								
				common.ui.buttons(
					$("#my-files [data-action]"),
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
											upload: function(e){
												e.data = {objectType: getMyDriverAttachmentSource()};
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
			var renderTo = $("#attachment-viewer");						
			if( ! common.ui.exists(renderTo) ){		
				var observable =  common.ui.observable({ 
					attachment : new common.ui.data.Attachment(),
					hasSource : false,
					isPdf : false,
					isImage : false,
					resize : function(){
						var $this = this;	
						var $window = $(window);
						if( $this.attachment.isPdf() ){
							var $iframe = renderTo.find(".mfp-content .mfp-iframe-scaler");
							if( $iframe.length == 1 ){
								$iframe.css("height", $window.height() - 20 );	
								$iframe.css("width", $window.width() - 20 );		
							}	
						}
						
						if( $this.attachment.isImage()){
							var $img = renderTo.find("img.mfp-img");
							if($img.length == 1 ){
								$img.css("max-height", $window.height() - 10 );	
								$img.css("max-width", $window.height() - 10 );	
							}														
						}							
					},
					edit : function(){
						var $this = this;		
						var grid = renderTo.find(".attachment-props-grid");	
						var upload = renderTo.find("input[name='update-attachment-file']");		
						if(!common.ui.exists(grid)){
							common.ui.grid(grid, {
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
						}
						if(!common.ui.exists(upload)){
							common.ui.upload( upload, {
								async : {
									saveUrl:  '<@spring.url "/data/files/upload.json?output=json" />'
								},
								localization:{ select : '사진 선택' , dropFilesHere : '새로운 사진파일을 이곳에 끌어 놓으세요.' },	
								upload: function (e) {				
									e.data = { objectType:$this.attachment.objectType , fileId: $this.attachment.attachmentId };
								},								
								success: function (e) {									
								}
							});							
							renderTo.find(".sky-form").slimScroll({
								height: "500px"
							});	
						}													
						common.ui.grid(grid).setDataSource(
							common.ui.data.properties.datasource({
									transport: { 
										read: { url:"/data/files/properties/list.json?output=json", type:'GET' },
										create: { url:"/data/files/properties/update.json?output=json" + "&fileId=" + $this.attachment.attachmentId, type:'POST' ,contentType : "application/json" },
										update: { url:"/data/files/properties/update.json?output=json" + "&fileId=" + $this.attachment.attachmentId, type:'POST'  ,contentType : "application/json"},
										destroy: { url:"/data/files/properties/delete.json?output=json" +  "&fileId=" + $this.attachment.attachmentId, type:'POST' ,contentType : "application/json"},
								 		parameterMap: function (options, operation){			
											if (operation !== "read" && options.models) {
												return kendo.stringify(options.models);
											} 
											return { fileId: $this.attachment.attachmentId }
										}
									}
							})
						);
						renderTo.find(".white-popup-block").fadeIn();	
					},
					close: function(){
						var $this = this;						
						renderTo.find(".white-popup-block").fadeOut();
					},
					setAttachment: function(attachment){
						var $this = this;
						attachment.copy($this.attachment);							
						$this.resize();						
						if( common.ui.defined( $this.attachment.properties.source ) )
							$this.set("hasSource", true);
						else
							$this.set("hasSource", false);	
							
						if( $this.attachment.isImage() ){
							var $loading = renderTo.find(".mfp-preloader");
							var $largeImg = renderTo.find(".mfp-content");		
							$largeImg.hide();				
							$loading.show();							
							$("<img/>" ).load( function() {
								var $img = $(this);							
								if( $img.attr( 'src' ) === $this.attachment.imageUrl ) {		
									$loading.hide();
									$largeImg.fadeIn("slow");		
								}
							}).attr( 'src', $this.attachment.imageUrl );							
						}	
					}
				});
				observable.resize();				
				$(window).resize(function(){
					observable.resize();
				});		
				common.ui.dialog( renderTo , {
					data : observable,
					"open":function(e){	
						var $this = this;		
						var $attachment = $this.data().attachment;						
						if( $attachment.get("contentType") === "application/pdf" ){	
							var myPdf = new PDFObject({ url:  "<@spring.url "/download/file/" />" + $attachment.attachmentId + "/" + $attachment.name, pdfOpenParams: { navpanes: 1, statusbar: 0, view: "FitV" } }).embed("attachment-content-pdf");
						}				
					},
					"close":function(e){					
					}
				});				
				common.ui.bind(renderTo, observable );				
			
			}			
			var dialogFx = common.ui.dialog( renderTo );		
			dialogFx.data().setAttachment(attachment);			
			if( !dialogFx.isOpen ){							
				dialogFx.open();
			}
		}
				
		function showAttachmentPanel2(attachment){				
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
								pageSize: 28,
								schema: {
									model: common.ui.data.Image,
									data : "images",
									total : "totalCount"
								}
							}
						),
						selectable: false,//"single",
						change: function(e) {
							var data = this.dataSource.view() ;
							var current_index = this.select().index();
							var total_index = this.dataSource.view().length -1 ;
							var list_view_pager =  common.ui.pager( $("#photo-list-pager") );		
							var item = data[current_index];								
						},
						dataBound : function(e){
							var renderTo = $("#image-viewer");
							if(common.ui.exists(renderTo) && common.ui.dialog(renderTo).isOpen ){
								var list_view_pager = common.ui.pager( $("#photo-list-pager") );
								var dialogFx = common.ui.dialog(renderTo);
								var data = common.ui.listview($('#photo-list-view')).dataSource.view();								
								if( dialogFx.data().page > list_view_pager.page() ){
									var item = data[dialogFx.data().pageSize - 1];
									item.set("index", dialogFx.data().pageSize -1 );
									showPhotoPanel(item);
								} else {
									var item = data[0];
									item.set("index", 0 );
									showPhotoPanel(item);
								}
							}
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
				common.ui.pager( $("#photo-list-pager"), { buttonCount : 9, pageSizes: true, dataSource : common.ui.listview($('#photo-list-view')).dataSource });				
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
					previousPage : function(){
						var $this = this;
						if( $this.hasPreviousPage ){							
							var pager = common.ui.pager( $("#photo-list-pager") );
							pager.page($this.page -1);
						}
					},
					nextPage : function(){
						var $this = this;						
						if( $this.hasNextPage ){
							var pager = common.ui.pager( $("#photo-list-pager") );
							pager.page($this.page +1);			
						}
					},					
					setPagination: function(){
						var $this = this;
						var pageSize = common.ui.listview($('#photo-list-view')).dataSource.view().length;	
						var pager = common.ui.pager( $("#photo-list-pager") );
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
					edit: function(){
						var $this = this;		
						var grid = renderTo.find(".photo-props-grid");	
						var upload = renderTo.find("input[name='update-photo-file']");
						var shared = renderTo.find("input[name='photo-public-shared']");						
						if(!common.ui.exists(grid)){
							common.ui.grid(grid, {
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
							renderTo.find(".sky-form").slimScroll({
								height: "500px"
							});							
						}
						
						if(!common.ui.exists(upload)){
							common.ui.upload( upload, {
								async : {
									saveUrl:  '<@spring.url "/data/images/update_with_media.json?output=json" />'
								},
								localization:{ select : '사진 선택' , dropFilesHere : '새로운 사진파일을 이곳에 끌어 놓으세요.' },	
								upload: function (e) {				
									e.data = { imageId: $this.image.imageId };
								},
								success: function (e) {									
								}
							});												
						}												
						common.ui.data.image.streams($this.image.imageId, function(data){
							if( data.length > 0 )
								shared.first().click();
							else
								shared.last().click();
							
							shared.on("change", function(e){
								var newValue = ( this.value == 1 ) ;
								if(newValue){
									common.ui.data.image.unshare($this.image.imageId);	
								}else{
									common.ui.data.image.share($this.image.imageId);
								}
							});		
						});																			
						common.ui.grid(grid).setDataSource( common.ui.data.image.property.datasource($this.image.imageId) );												
						renderTo.find(".white-popup-block").fadeIn();	
					},
					close: function(){
						var $this = this;						
						renderTo.find(".white-popup-block").fadeOut();
					},
					setImage: function(image){
						var $this = this;						
						$this.resize();
						image.copy($this.image);	
						
						if( common.ui.defined( image.properties.source ) )
							$this.set("hasSource", true);
						else
							$this.set("hasSource", false);	
						
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
					
		-->
		</script>		
		<style scoped="scoped">
			
			.interactive-slider-v2 {
				max-height : 220px;
				color : #fff;
				overflow:hidden;
			}		
			.interactive-slider-v2 h1 , .interactive-slider-v2 p {
				color : #fff;
			}
												
			#image-gallery-pager { 
				margin-top: 5px; 
			}
			
			.panel-upload {
				margin-top : 5px!important;
				margin-bottom : 5px!important;
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
			
			.dialog .btn-flat {
				z-index: 1046;
			}
			
			.dialog .btn-flat.mfp-arrow {
				background-color:transparent!important;
			}
			
			.dialog .btn-flat.left.mfp-arrow {
				left:0px;
				top:55%;
			}

			.dialog .btn-flat.right.mfp-arrow {
				top:55%;
			}			
			
			.dialog .btn-flat.left2 {
				top:auto;
				left:0px;	
				bottom:0px;		
			}
			
			.dialog .btn-flat.right2 {
				top:auto;
				right:0px;	
				bottom:0px;		
			}

			.dialog .btn-flat.pencil {
				top:60px;
				right:0px;
				background-color: transparent;				
			}			
						
			.dialog .mfp-preloader {
				top: 0;
				margin-top: 0;
			}
			.dialog .mfp-figure{
				box-shadow: none;
				background: none;
			}
						
			.white-popup-block{
				background: rgba(48, 48, 48, 0.9);
				padding: 20px 30px;
				text-align: left;
				width: 100%;
				height: 100%;
				position: fixed;
				top: 0;
				left: 0;				
				z-index:1047;
				overflow-y: auto;
			}
			
			.white-popup-block .close {
				position: absolute;
				top: 0;
				right: 0;
				line-height: 50px;
				font-size: 40px;
				display: block;
				width: 50px;
				height: 50px;
				text-align: center;
				background: url(/images/common/grey-cross.png) no-repeat center rgba(0, 0, 0, 0.8);
				background-size: 25px;
				content: "";
				display: block;
				opacity: .5;
				z-index:1047;
			}
			
			.white-popup-block .close:hover {
				opacity: 1;
			}
			
			
			.white-popup-block .k-grid-content {
				min-height: 100px;
			}
			@media (min-width: 768px) and (max-width: 991px) {
				width : 20%;
			}						
			
			@media ( min-width :992px) {				
				.image-listview .img-wrapper, .file-listview .file-wrapper {
					width : 14.28%;
				}	
			}	

			@media ( min-width :768px) {				
				.white-popup-block .left-col {
					float: left;
					width: 220px;
				}
				.white-popup-block .right-col {
					overflow: hidden;
					padding-left: 20px;
				}
			}
			
			.personalized-section {
				margin-bottom:0!important;
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
			<div class="interactive-slider-v2 bg-dark arrow-up">
				<div class="personalized-controls container text-center p-xl">
					<p class="text-quote">${ navigator.description ? replace ("{displayName}" , action.webSite.company.displayName ) }	</p>
					<h1 class="text-xxl"><#if navigator.icon?? ><i class="icon-flat ${navigator.icon}"></i></#if>	${ navigator.title }</h1>					
					<span class="btn-flat settings" data-feature-name="spmenu" data-toggle="spmenu" data-target-object-id="personalized-controls-section"></span>
					</div><!--/end container-->
			</div>
			<div class="container content">		
				<div class="tab-v1 m-t-md" >							
					<ul class="nav nav-tabs" id="myTab">
						<#if !action.user.anonymous >	
						<li><a href="#my-photo-stream" tabindex="-1" data-toggle="tab" class="rounded-top m-l-sm">포토</a></li>
						<li><a href="#my-files" tabindex="-1" data-toggle="tab" class="rounded-top">파일</a></li>							
						</#if>						
					</ul>					
				</div>

					<!-- tab-content -->		
					<div class="tab-content">
						<!-- start tab-pane -->
						<div class="tab-pane" id="my-files">
							
							<section class="sky-form panel-upload" style="position:relative; display:none;">
								<header>
									<i class="fa fa-cloud-upload  fa-lg"></i> 파일 업로드 
									<span class="close-sm" data-action="upload-close"></span>										
								</header>
								<fieldset>
									<#if !action.user.anonymous >			
									<div class="page-header text-primary">
										<h5><small>아래의 <strong>파일 선택</strong> 버튼을 클릭하여 파일을 직접 선택하거나, 아래의 영역에 파일을 끌어서 놓기(Drag & Drop)를 하세요.</small></h5>
									</div>								
									<input name="uploadAttachment" id="attachment-files" type="file" />												
									</#if>	
								</fieldset>			
							</section>						

							<div class="tag-box tag-box-v3 form-page">
								<div class="headline"><h3>Standard Form Controls</h3></div>
								<div class="row">
									<div class="col-md-6">
										<h4>소유자</h4>
										<div class="btn-group" data-toggle="buttons" id="attachment-source-list">
											<label class="btn btn-sm btn-danger rounded-left active">
												<input type="radio" name="attachment-source"  value="2" checked="checked"><i class="fa fa-user"></i> ME
											</label>
											<label class="btn btn-sm btn-danger">
												<input type="radio" name="attachment-source"  value="30"><i class="fa fa-globe"></i> SITE
											</label>											
											<label class="btn btn-sm btn-danger rounded-right">
												<input type="radio" name="attachment-source"  value="1"><i class="fa fa-building-o"></i> COMPANY
											</label>
										</div>												
									</div>
									<div class="col-md-6">
										<h4>필터</h4>
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
										<p class="pull-right">				
											<button type="button" class="btn btn-info btn-lg btn-control-group rounded" data-toggle="button" data-action="upload"><i class="fa fa-cloud-upload"></i> 파일업로드</button>	
										</p>										
									</div>
								</div>
							</div>		
							<div class="panel panel-default">
								<div class="panel-body bg-slivergray">
									<p class="text-muted"><small><i class="fa fa-info"></i> 파일보기 버튼을 클릭하면 상세 정보 및 수정을 할 수 있습니다.</small></p>
									<#if !action.user.anonymous >		
								
										
									</#if>																										
											
								</div>
								<div class="panel-body sm-padding" style="min-height:450px;">
									
								</div>	
								<div class="panel-footer no-padding">
										
								</div>
								
							</div>
							<div id="attachment-list-view" class="file-listview"></div>		
							<div id="pager" class="file-listview-pager k-pager-wrap"></div>																		
						</div><!-- end tab-pane -->		
						<!-- start tab-pane -->
						<div class="tab-pane" id="my-photo-stream">									
							<div class="panel panel-primary panel-upload  m-b-sm  border-2x" style="display:none;">
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
								<p class="text-muted"><small><i class="fa fa-info"></i> "이미지 보기"를 클릭하면 상세 정보 및 수정할 수 있습니다. </small></p>
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
					</div><!-- end tab-pane -->
				</div><!-- end of tab content -->		
				
			</div><!--/end container-->
			
				<!--		
			<section class="personalized-section bg-transparent open" >
			
				<div class="personalized-section-heading">
					<div class="container">
						<div class="personalized-section-title">
							<i class="icon-flat folder"></i>
							<h3 >MY 드라이브 <span class="hidden-xs">PC는 문론 스마트폰, 태블릿에서도 이미지와 파일을 쉽게 정	리하고 관리하세요.. <i class="fa fa-long-arrow-right"></i></span></h3>
							<div class="personalized-section-heading-controls">
								<i class="icon-flat settings"></i>
								<div id="personalized-buttons" class="btn-group">
									<button type="button" class="btn-u btn-u-blue rounded-right" data-feature-name="spmenu" data-toggle="spmenu" data-target-object-id="personalized-controls-section" disabled><span class="hidden-xs">My 드라이브</span></button>
								</div>					
							</div>		
						</div>
					</div>				
				</div>
				<div class="personalized-section-content animated arrow-up">
					<div class="container content" style="min-height:450px;">		
	
				<div class="tab-v1 m-t-md" >							
					<ul class="nav nav-tabs" id="myTab">
						<#if !action.user.anonymous >	
						<li><a href="#my-photo-stream" tabindex="-1" data-toggle="tab" class="rounded-top m-l-sm">포토</a></li>
						<li><a href="#my-files" tabindex="-1" data-toggle="tab" class="rounded-top">파일</a></li>							
						</#if>						
					</ul>		
	
					</div>
				</div>			
			</section>		
-->
			<!-- ./END MAIN CONTENT -->	
	 		<!-- START FOOTER -->
			<#include "/html/common/common-homepage-globalfooter.ftl" >		
			<!-- ./END FOOTER -->					
		</div>			

		<div id="attachment-viewer" class="dialog" data-feature="dialog" data-dialog-animate="">
			<div class="dialog__overlay"></div>
			<div class="dialog__content">	
				<div class="mfp-container mfp-s-ready mfp-image-holder">
					<span class="btn-flat pencil" data-bind="click: edit"></span>	
					<span class="btn-flat close" data-dialog-close></span>					
					<div class="mfp-content">
						<div id="attachment-content-pdf" class="mfp-iframe-scaler no-padding" data-bind="visible:attachment.isPdf"></div>
						<div class="mfp-figure" data-bind="visible:attachment.isImage">
							<figure>
								<img class="mfp-img" style="display: block;" data-bind="attr:{src:attachment.imageUrl}">
								<figcaption>
									<div class="mfp-bottom-bar">
										<div class="mfp-title" data-bind="text: attachment.name"></div>
										<div class="mfp-counter" data-bind="text: attachment.formattedModifiedDate"></div>
									</div>
								</figcaption>
							</figure>
						</div>												
					</div>
					<div class="mfp-preloader" style="display: none;"></div>
					<div class="white-popup-block" style="display:none">							
						<div class="tag-box tag-box-v3 tag-text-space margin-bottom-40 rounded">
							<span class="close" data-bind="click: close"></span>
							<div class="left-col">
								<div class="shadow-wrapper" style="width:150px;height:150px;">
									<div class="box-shadow shadow-effect-2 " >
										<img class="img-responsive" data-bind="attr:{src: attachment.imageThumbnailUrl}">
									</div>	
								</div>
								<hr class="m-sm"/>										
								<ul class="list-unstyled margin-bottom-30">																		
									<li class="p-xxs"><span data-bind="text: attachment.contentType" class="label rounded label-dark-blue"></span></li>
									<li class="p-xxs"><strong>크기:</strong> <span data-bind="text: attachment.formattedSize"></span> bytes</li>
									<li class="p-xxs"><strong>생성일:</strong> <span data-bind="text: attachment.formattedCreationDate"></span></li>
									<li class="p-xxs"><strong>수정일:</strong> <span data-bind="text: attachment.formattedModifiedDate"></span></li>
								</ul>											
								<div class="headline headline-md"><h4>태그</h4></div>
								<ul class="list-unstyled blog-tags margin-bottom-30">
									<li><a href="#"><i class="fa fa-tags"></i> 성인</a></li>
									<li><a href="#"><i class="fa fa-tags"></i> 여자</a></li>
								</ul>			
							</div><!-- ./left-col -->
							<div class="right-col">					
								<div class="row">
									<div class="col-sm-12">
										<section class="sky-form">
											<header data-bind="text: attachment.name"></header>
										<fieldset data-bind="visible:hasSource">
											<section>
												<label class="label">출처</label>
												<a href="#" class="btn btn-link" data-bind="attr:{href:attachment.properties.source }, text:attachment.properties.source"></a>
											</section>
										</fieldset>												
											<fieldset>
												<section>											
													<label class="label">파일 변경</label>
													<input name="update-attachment-file" type="file" class="pull-right" />	
													<div class="note"><i class="fa fa-info"></i> 파일을 변경하려면 마우스로 사진을 끌어 놓거나 파일 선택을 클릭하세요.</div>
												</section>
											</fieldset>
											<fieldset>
												<section>
												<label class="label">추가 정보</label>
												<div class="attachment-props-grid"></div>											
												<div class="note"><i class="fa fa-info"></i> 수정후 반듯이 저장버튼을 클릭해야 반영됩니다.</div>
												</section>
											</fieldset>				
										</section>	
									</div><!-- ./col-sm-12	-->
								</div><!-- ./row		-->	
							</div><!-- ./right-col	-->								
						</div><!-- ./ tag-box -->
					</div><!-- ./white-popup-block		-->					
				</div><!-- ./mfp-container -->
			</div>
		</div>	
					
		<div id="image-viewer" class="dialog" data-feature="dialog" data-dialog-animate="">
			<div class="dialog__overlay"></div>
			<div class="dialog__content">							
				<div class="mfp-container mfp-s-ready mfp-image-holder">
					<span class="btn-flat pencil" data-bind="click: edit"></span>			
					<span class="btn-flat left2" data-bind="visible: hasPreviousPage, click: previousPage"></span>		
					<span class="btn-flat right2" data-bind="visible: hasNextPage, click: nextPage"></span>								
					<span class="btn-flat close" data-dialog-close></span>					
					<div class="white-popup-block" style="display:none">							
						<div class="container">
							<div class="row">
								<div class="tag-box tag-box-v3 tag-text-space margin-bottom-40 rounded">
								<span class="close" data-bind="click: close"></span>
								<div class="left-col">
									<div class="shadow-wrapper" style="width:150px;height:150px;">
										<div class="box-shadow shadow-effect-2 " >
											<img class="img-responsive" data-bind="attr:{src:image.imageThumbnailUrl}">
										</div>	
									</div>
									<hr class="m-sm"/>										
									<ul class="list-unstyled margin-bottom-30">																		
										<li class="p-xxs"><strong>크기:</strong> <span data-bind="text:image.formattedSize"></span> bytes</li>
										<li class="p-xxs"><strong>생성일:</strong> <span data-bind="text: image.formattedCreationDate"></span></li>
										<li class="p-xxs"><strong>수정일:</strong> <span data-bind="text: image.formattedModifiedDate"></span></li>
									</ul>
											
									<div class="headline headline-md"><h4>태그</h4></div>
									<ul class="list-unstyled blog-tags margin-bottom-30">
										<li><a href="#"><i class="fa fa-tags"></i> 성인</a></li>
										<li><a href="#"><i class="fa fa-tags"></i> 여자</a></li>
									</ul>			
								</div>
								<div class="right-col">									
									<section class="sky-form">
										<header data-bind="text: image.name"></header>
										<fieldset data-bind="visible:hasSource">
											<section>
												<label class="label">출처</label>
												<a href="#" class="btn btn-link" data-bind="attr:{href:image.properties.source }, text:image.properties.source"></a>
											</section>
										</fieldset>											
										<fieldset>
											<section>											
												<label class="label">이미지 변경</label>
												<input name="update-photo-file" type="file" class="pull-right" />	
												<div class="note"><i class="fa fa-info"></i> 사진을 변경하려면 마우스로 사진을 끌어 놓거나 사진 선택을 클릭하세요.</div>
											</section>
										</fieldset>
										<fieldset>
											<section>
												<label class="label">이미지 공개 여부</label>
												<div class="inline-group">
													<label class="radio"><input type="radio" name="photo-public-shared" value="0"><i class="rounded-x"></i>공개</label>
													<label class="radio"><input type="radio" name="photo-public-shared" value="1" checked><i class="rounded-x"></i>비공개</label>
												</div>
												<div class="note"><i class="fa fa-info"></i> 공개를 선택하면 누구나 웹을 통하여 볼 수 있도록 공개됩니다.</div>
											</section>
										</fieldset>
										<fieldset>
											<section>
											<label class="label">추가 정보</label>
											<div class="photo-props-grid"></div>											
											<div class="note"><i class="fa fa-info"></i> 수정후 반듯이 저장버튼을 클릭해야 반영됩니다.</div>
											</section>
										</fieldset>										
									</section>	
								</div><!-- ./right-col	-->
								</div>
							</div><!-- ./row	-->
						</div><!-- ./container		-->	
					</div><!-- ./white-popup-block		-->
					<div class="mfp-content">	
						<div class="mfp-figure">
							<figure>
								<img class="mfp-img" style="display: block;" data-bind="attr:{src:image.imageUrl}, click: next">
								<figcaption>
									<div class="mfp-bottom-bar">
										<div class="mfp-title" data-bind="text: image.name"></div>
										<div class="mfp-counter"><span data-bind="text:image.index +1"></span>/<span data-bind="text:pageSize"></span></div>
									</div>
								</figcaption>
							</figure>
						</div>
					</div>	
					<div class="mfp-preloader" style="display: none;"></div>
					<button title="Previous (Left arrow key)" type="button" class="btn-flat left mfp-arrow mfp-prevent-close" data-bind="visible: hasPrevious, click: previous"></button>
					<button title="Next (Right arrow key)" type="button" class="btn-flat right mfp-arrow  mfp-prevent-close" data-bind="visible: hasNext, click: next"></button>					
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

			</div>	
		</section>	
		<div class="cbp-spmenu-overlay"></div>			
		<!-- ./END RIGHT SLIDE MENU -->							
		<!-- START TEMPLATE -->									

	<#include "/html/common/common-homepage-templates.ftl" >		
	<#include "/html/common/common-personalized-templates.ftl" >
	<!-- ./END TEMPLATE -->
	</body>    
</html>