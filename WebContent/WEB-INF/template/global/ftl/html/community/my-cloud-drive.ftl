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
			'css!<@spring.url "/styles/jquery.magnific-popup/magnific-popup.css"/>',		
			'css!<@spring.url "/styles/jquery.sky-forms/2.0.1/custom-sky-forms.css"/>',
			'css!<@spring.url "/styles/hover-effect/hover-min.css"/>',			
			'css!<@spring.url "/styles/codrops/codrops.dialog.css"/>',		
			'css!<@spring.url "/styles/codrops/codrops.dialog-val.css"/>',			
			'css!<@spring.url "/styles/codrops/codrops.cbp-spmenu.css"/>',		
			'css!<@spring.url "/styles/bootstrap.themes/unify/colors/blue.css"/>',	
			'css!<@spring.url "/styles/bootstrap.common/color-icons.css"/>',	
			'css!<@spring.url "/styles/bootstrap.themes/common/common.ui.inspinia.css"/>',
			'css!<@spring.url "/styles/bootstrap.themes/common/common.ui.buttons.css"/>',	
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
									//common.ui.enable( $("#personalized-buttons button")	);
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
																															
				// SpMenu Tabs								
				createMyDriverTabs();				
				// END SCRIPT 				
			}
		}]);	

		<!-- ============================== -->
		<!-- create my tabs					-->
		<!-- ============================== -->	
		function createMyDriverTabs(){
			var renderTo = $('#myTab');
			renderTo.on( 'show.bs.tab', function (e) {
				//	e.preventDefault();		
				var show_bs_tab = $(e.target);
				if( show_bs_tab.attr('href') == '#my-files' ){					
					createAttachmentListView();
				} else if(show_bs_tab.attr('href') == '#my-photos' ){					
					createPhotoListView();
				}					
			});	
			$('#myTab a:first').tab('show') ;
		}
		
		<!-- ============================== -->
		<!-- create my attachment grid							-->
		<!-- ============================== -->		
		function getMyDriverAttachmentSource(){
			return $("#attachment-source-list input[type=radio][name=attachment-source]:checked").val();			
		}
		function createFileUploadModal(){
			var renderTo = $("#my-file-upload-modal");
			var renderTo2 = $('#attachment-list-view');
			if( !renderTo.data('bs.modal')){	
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
												common.ui.listview(renderTo2).dataSource.read();						
											}
										}
									);
				}			
			}
		}		
				
		function createAttachmentListView(){	
			var renderTo = $('#attachment-list-view');				
			if( !common.ui.exists(renderTo) ){						
				var attachementTotalModle = common.ui.observable({ 
					totalAttachCount : "0",
					totalImageCount : "0",
					totalFileCount : "0"							
				});
				common.ui.bind($("#attachment-list-filter"), attachementTotalModle);
				
				common.ui.listview(renderTo,{				
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
							renderTo.data( "attachPlaceHolder", item );												
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
					common.ui.listview(renderTo).dataSource.read();	
				});	
								
				$("input[name='attachment-list-view-filters']").on("change", function () {
					var attachment_list_view = common.ui.listview(renderTo);
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
				common.ui.pager($("#attachment-list-pager"),{ buttonCount : 5, dataSource : common.ui.listview(renderTo).dataSource });							
				renderTo.on("click", ".file-wrapper button", function(e){
					var index = $(this).closest("[data-uid]").index();
					var data = common.ui.listview(renderTo).dataSource.view();					
					var item = data[index];		
					item.set("index", index);	
					showAttachmentPanel(item);
				});	
				createFileUploadModal();									
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
		<!-- Commentary						-->
		<!-- ============================== -->		
		function createPhotoCommentary(source){
			var renderTo = $("#my-file-commentary");				
			if( !renderTo.data("model") ){		
				//if( !common.ui.exists(renderTo) ){		
				var listview = common.ui.listview($("#my-file-commentary-listview"), {
					dataSource: {
						transport: { 
							read: { url:'<@spring.url "/data/comments/list.json?output=json"/>', type: 'POST' }
						},
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
					},
					template: kendo.template($("#my-file-commentary-listview-template").html()),
					autoBind: false
				});	
						
				var observable =  common.ui.observable({
					image : new common.ui.data.Image(),
					coverPhotoUrl : "",
					hasSource : false,
					commentBody : "",
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
									listview.dataSource.read({objectType: 16, objectId: $this.image.imageId });
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
							listview.dataSource.read({objectType:16, objectId: $this.image.imageId });	
						}	
					}				
				});
				renderTo.data("model", observable);			
				common.ui.bind( renderTo, observable );				
				$('.close[data-commentary-close]').click(function(){	
					if(!$("body").hasClass('modal-open')){
						$("body").css("overflow", "auto");
					}					
					renderTo.hide();
				});				
			}	
			
			if(renderTo.is(":hidden")){
				renderTo.data("model").setSource( source ) ;			
				if(!$("body").hasClass('modal-open')){
					$("body").css("overflow", "hidden");
				}			
				renderTo.show();
			}				
		}		
		<!-- ============================== -->
		<!-- create my photo grid			-->
		<!-- ============================== -->				
		function getMyDriverPhotoSource(){
			return $("#image-source-list input[type=radio][name=image-source]:checked").val();			
		}
		
		function createPhotoUploadModal(){
			var renderTo = $("#my-photo-upload-modal");
			var renderTo2 = $('#photo-list-view');
			if( !renderTo.data('bs.modal')){	
			
				var model = common.ui.observable({
						data : {
							objectType : 2,
							objectId : 0,
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
								this.data.objectType = getMyDriverPhotoSource();
								common.ui.data.image.uploadByUrl( {
									data : this.data ,
									success : function(response){
										var photo_list_view = common.ui.listview(renderTo2);
										photo_list_view.dataSource.read();		
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
								saveUrl:  '<@spring.url "/data/images/update_with_media.json?output=json" />'
							},
							upload: function(e){
								e.data = {objectType:getMyDriverPhotoSource()};
							},
							success : function(e) {	
								var photo_list_view = common.ui.listview(renderTo2);
								photo_list_view.dataSource.read();								
							}		
						});		
					}
			}
		}
		
		function createPhotoListView(){		
			if( $('article.bg-white').is(":hidden")){
				$("article.bg-white").show();
			}			
			var renderTo = $('#photo-list-view');
			if( !common.ui.exists(renderTo) ){
				common.ui.listview(	renderTo, {
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
							//var renderTo = $("#image-viewer");
							var renderTo = $("#my-image-view-modal");	
							if( renderTo.data('bs.modal') && renderTo.is(":visible")){
								var list_view_pager = common.ui.pager( $("#photo-list-pager") );
								var data = this.dataSource.view();				
								if( renderTo.data("model").page > list_view_pager.page() ){
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
				
				renderTo.on("click", ".img-wrapper button", function(e){
					var index = $(this).closest("[data-uid]").index();
					var data = common.ui.listview(renderTo).dataSource.view();					
					var item = data[index];
					item.set("index", index );
					createPhotoViewModal(item);
				});	
				createPhotoUploadModal();
			}			
		}	
		
		
		function createPhotoPostModal( image ){
			var renderTo = $("#my-image-post-modal");		
			renderTo.data("ready", false);
			if( !renderTo.data('bs.modal') ){		
				if( common.ui.defined( $("#my-image-view-modal").data("model") ) ){
					common.ui.bind(renderTo, $("#my-image-view-modal").data("model") );
				}
				var targetImage = $("#my-image-view-modal").data("model").image ;	
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
				}
				if(!common.ui.exists(upload)){
					common.ui.upload( upload, {
						async : {
							saveUrl:  '<@spring.url "/data/images/update_with_media.json?output=json" />'
						},
						localization:{ select : '사진 선택' , dropFilesHere : '새로운 사진파일을 이곳에 끌어 놓으세요.' },	
						upload: function (e) {				
							e.data = { imageId: targetImage.imageId };
						},
						success: function (e) {									
						}
					});												
				}	
				shared.on("change", function(e){
					var newValue = ( this.value == 1 ) ;
					console.log( newValue );
					if( renderTo.data("ready") ){
						if(newValue){
							common.ui.data.image.unshare(targetImage.imageId);	
						}else{
							common.ui.data.image.share(targetImage.imageId);
						}	
					}
				});					
				renderTo.on('show.bs.modal', function(e){		
					common.ui.data.image.streams(targetImage.imageId, function(data){	
						if( data.length > 0 ){
							shared.first().click();
						}else{
							shared.last().click();
						}
						renderTo.data("ready", true);
					});
					common.ui.grid(renderTo.find(".photo-props-grid")).setDataSource( common.ui.data.image.property.datasource(targetImage.imageId) );	
					$("#my-image-view-modal").css("opacity", "0");	
				});
				renderTo.on('hide.bs.modal', function(e){					
					$("#my-image-view-modal").css("opacity", "");	
				});					
				common.ui.bootstrap.enableStackingModal(renderTo);														
			}
			renderTo.modal('show');	
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
							var data = common.ui.listview($('#photo-list-view')).dataSource.view();					
							var item = data[index];				
							item.set("index", index );
							createPhotoViewModal(item);		
						}
					},
					next : function(){
						var $this = this;						
						if( $this.hasNext ){
							var index = $this.image.index + 1;
							var data = common.ui.listview($('#photo-list-view')).dataSource.view();					
							var item = data[index];		
							item.set("index", index );
							createPhotoViewModal(item);					
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
					comment: function(){
						createPhotoCommentary(this.image);
						return false;
					},
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
						console.log(kendo.stringify(image));
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

		-->
		</script>		
		<style scoped="scoped">
		
		
		/** image post modal */
	
			/*
			.interactive-slider-v2 {
				max-height : 220px;
				color : #fff;
				overflow:hidden;
			}		
			
			.interactive-slider-v2 p	{
				color : #fff;
				font-size: 24px;
				font-weight: 200;
				margin-bottom: 0;
			}	
						
			.interactive-slider-v2 h1 , .interactive-slider-v2 p {
				color : #fff;
			}
						
			.btn.btn-flat.btn-lg{
				font-size : 2.5em;
				font-weight:200;
			}
												
			#image-gallery-pager { 
				margin-top: 5px; 
			}
			*/
			
			
			
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
			
			.dialog .btn-flat-icon {
				z-index: 1046;
			}
			
			.dialog .btn-flat-icon.mfp-arrow {
				background-color:transparent!important;
			}
			
			.dialog .btn-flat-icon.left.mfp-arrow {
				left:0px;
				top:55%;
			}

			.dialog .btn-flat-icon.right.mfp-arrow {
				top:55%;
			}			
			
			.dialog .btn-flat-icon.left2 {
				top:auto;
				left:0px;	
				bottom:0px;		
			}
			
			.dialog .btn-flat-icon.right2 {
				top:auto;
				right:0px;	
				bottom:0px;		
			}

			.dialog .btn-flat-icon.pencil {
				top:60px;
				right:0px;
				background-color: transparent;					
			}
			
			.dialog .btn-flat-icon.settings {
				top:0;
				left:0px;
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
			
			.white-popup-block .toolbar {
				position: absolute;
				text-align: right;
				height:50px;
				right:0;
				top:0;
			}
			
			.white-popup-block  .toolbar .btn-flat-icon {
				width : 50px;
				height : 50px;
				top:0;
				right:51px;
				background-color: transparent;
			}
			
			.white-popup-block  .toolbar .btn-flat-icon.paper-plane {
				background-position: -231px -125px;
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
				background: url(/images/common/grey-cross.png) no-repeat center;
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
				<div class="tab-v1 m-t-md" >							
					<ul class="nav nav-tabs" id="myTab">
						<li><a href="#my-photos" tabindex="-1" data-toggle="tab" class="rounded-top m-l-sm">포토</a></li>
						<li><a href="#my-files" tabindex="-1" data-toggle="tab" class="rounded-top">파일</a></li>							
					</ul>					
					<!-- tab-content -->		
					<div class="tab-content">
						<!-- start tab-pane -->
						<div class="tab-pane" id="my-files">
							<#if !action.user.anonymous >	
							<section class="p-sm">	
									<div class="row">
										<div class="col-md-4">
											<h4><i class="fa fa-user"></i> 소유자</h4>
											<div class="btn-group btn-group-sm" data-toggle="buttons" id="attachment-source-list">
												<label class="btn btn-danger rounded-left active">
													<input type="radio" name="attachment-source"  value="2" checked="checked"><i class="fa fa-user"></i> ME
												</label>
												<#if (action.user.companyId > 0) >									
												<label class="btn btn-danger">
													<input type="radio" name="attachment-source"  value="1"><i class="fa fa-building-o"></i> COMPANY
												</label>
												</#if>
												<label class="btn  btn-danger rounded-right">
													<input type="radio" name="attachment-source"  value="30"><i class="fa fa-globe"></i> SITE
												</label>
											</div>												
										</div>
										<div class="col-md-4">
											<h4><i class="fa fa-filter"></i> 필터</h4>
											<div class="btn-group btn-group-sm" data-toggle="buttons" id="attachment-list-filter">
												<label class="btn btn-info  rounded-left active">
													<input type="radio" name="attachment-list-view-filters"  value="all"> 전체 (<span data-bind="text: totalAttachCount"></span>)
												</label>
												<label class="btn btn-info ">
													<input type="radio" name="attachment-list-view-filters"  value="image"><i class="fa fa-filter"></i> 이미지
												</label>
												<label class="btn btn-info  rounded-right">
													<input type="radio" name="attachment-list-view-filters"  value="file"><i class="fa fa-filter"></i> 파일
												</label>	
											</div>								
										</div>
										<div class="col-md-4">
											<button class="btn-link btn-block hvr-pulse-shrink" type="button" data-toggle="modal" data-target="#my-file-upload-modal"><i class="icon-flat icon-svg basic-color-cloud-upload icon-svg-lg"></i></button
										</div>
									</div>	
									<p class="text-muted"><i class="fa fa-info"></i> 파일보기 버튼을 클릭하면 상세 정보 및 수정을 할 수 있습니다.</p>
																	
								<hr class="no-margin-t"/>
								<div id="attachment-list-view" class="file-listview" style="min-height:450px;"></div>	
								<div id="attachment-list-pager" class="file-listview-pager bg-flat-gray p-sm"></div>		
							</section>
							</#if>																								
						</div><!-- end tab-pane -->		
						<!-- start tab-pane -->
						<div class="tab-pane" id="my-photos">			
							<#if !action.user.anonymous >			
							<section class="p-sm">									
									<div class="row" >
										<div class="col-sm-8">
											<h4><i class="fa fa-user"></i> 소유자</h4>
											<div class="btn-group btn-group-sm" data-toggle="buttons" id="image-source-list">
												<label class="btn btn-danger rounded-left active">
													<input type="radio" name="image-source"  value="2" checked="checked"><i class="fa fa-user"></i> ME
												</label>
												<label class="btn btn-danger">
													<input type="radio" name="image-source"  value="30"><i class="fa fa-globe"></i> SITE
												</label>											
												<label class="btn btn-danger rounded-right">
													<input type="radio" name="image-source"  value="1"><i class="fa fa-building-o"></i> COMPANY
												</label>
											</div>		
											<p class="text-muted m-t-sm"><i class="fa fa-info"></i> "이미지 보기"를 클릭하면 상세 정보 및 수정할 수 있습니다. </p>
										</div>
										<div class="col-sm-4">
											<button class="btn-link btn-block hvr-pulse-shrink" type="button" data-toggle="modal" data-target="#my-photo-upload-modal"><i class="icon-flat icon-svg basic-color-add-image icon-svg-lg"></i></button>
										</div>
									</div>														
							</section>
							<hr class="no-margin-t"/>
							<div id="photo-list-view" class="image-listview" style="min-height:450px;">	</div>
							<div id="photo-list-pager" class="image-listview-pager bg-flat-gray p-sm"></div>
							</#if>			
						</div><!-- end tab-pane -->
					</div><!-- end of tab content -->		
				</div>			
			</div><!--/end container-->
			</article>
			<!-- ./END MAIN CONTENT -->	
	 		<!-- START FOOTER -->
			<#include "/html/common/common-homepage-globalfooter.ftl" >		
			<!-- ./END FOOTER -->					
		</div>			
		<!-- Image / File Uplaod Modal -->
		<div id="my-file-upload-modal" role="dialog" class="modal fade" data-backdrop="static" data-effect="zoom">
			<div class="modal-dialog modal-sm">
				<div class="modal-content my-page-view-form">	
					<div class="modal-header">
						<h2><i class="fa fa-cloud-upload  fa-lg"></i> 파일 업로드 </h2>
						<button aria-hidden="true" data-dismiss="modal" class="close" type="button"></button>
					</div>
					<div class="modal-body p-xs">
							<form class="sky-form no-border">
								<fieldset>	
									<div class="text-primary">
										<h5>아래의 <strong>파일 선택</strong> 버튼을 클릭하여 파일을 직접 선택하거나, 아래의 영역에 파일을 끌어서 놓기(Drag & Drop)를 하세요.</h5>
									</div>								
									<input name="uploadAttachment" id="attachment-files" type="file" />												
								</fieldset>	
							</form>
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

		<div id="attachment-viewer" class="dialog" data-feature="dialog" data-dialog-animate="">
			<div class="dialog__overlay"></div>
			<div class="dialog__content">	
				<div class="mfp-container mfp-s-ready mfp-image-holder">
					<span class="btn-flat-icon pencil" data-bind="click: edit"></span>	
					<span class="btn-flat-icon close" data-dialog-close></span>					
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
						<div class="tag-box tag-box-v3 padding-sm no-margin tag-text-space rounded">
							<span class="close" data-bind="click: close"></span>
							<div class="left-col">
								<div class="shadow-wrapper" style="width:150px;height:150px;top:50px;">
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
					
		
		
		<!-- Image View / Post Modal -->
		<div id="my-image-post-modal" role="dialog" class="modal fade" data-backdrop="static" data-effect="zoom">
			<div class="modal-dialog modal-lg">
				<div class="modal-content my-poll-post-form">	
					<div class="modal-header">
						<div class="author">
							<img data-bind="attr:{src:image.imageThumbnailUrl} style="margin-right:10px;">
						</div>
						<span class="hvr-pulse-shrink collapsed" data-modal-settings data-toggle="collapse" data-target="#my-file-modal-settings" area-expanded="false" aria-controls="my-file-modal-settings">
							<i class="icon-flat icon-flat settings"></i>						
						</span>
						<button aria-hidden="true" data-dismiss="modal" class="close" type="button"></button>
					</div>
					<form id="my-file-modal-settings" action="#" class="sky-form modal-settings collapse" data-ready="false">
							<header>
								고급옵션
								<span class="close" style="right:0;" data-toggle="collapse" data-target="#my-file-modal-settings" aria-expanded="true" aria-controls="my-file-modal-settings"></span>
							</header>
							<fieldset>		
								<section>
									<label class="label">이미지 공개 여부</label>
									<div class="inline-group">
										<label class="radio"><input type="radio" name="photo-public-shared" value="0"><i class="rounded-x"></i>공개</label>
										<label class="radio"><input type="radio" name="photo-public-shared" value="1" checked><i class="rounded-x"></i>비공개</label>
									</div>
									<div class="note"><i class="fa fa-info"></i> 공개를 선택하면 <span class="text-danger">누구나 웹을 통하여 볼 수 있도록</span> 공개됩니다.</div>
								</section>													
								<section>
									<label class="label">테그</label>
									<label class="input">
										<i class="icon-append fa fa-tag text-info"></i>
										<input type="text" name="tags" data-bind="value:page.tagsString">
									</label>
									<div class="note"><strong>Note:</strong>공백으로 라벨을 구분하세요</div>
								</section>								
							</fieldset>        					
					</form>
					<form action="#" class="sky-form">
						<fieldset>
								<section>
								<div class="row">
									<div class="col-sm-6">	
										<ul class="list-unstyled text-info">			
											<li class="p-xxs"><strong>파일:</strong> <span data-bind="text:image.name"></span></li>															
											<li class="p-xxs"><strong>크기:</strong> <span data-bind="text:image.formattedSize"></span> bytes</li>
											<li class="p-xxs"><strong>생성일:</strong> <span data-bind="text: image.formattedCreationDate"></span></li>
											<li class="p-xxs"><strong>수정일:</strong> <span data-bind="text: image.formattedModifiedDate"></span></li>
										</ul>									
									</div>								
									<div class="col-sm-6">	
										<div data-bind="{visible:hasSource}" >
											<div class="separator-2"></div>
											<h4>출처</h4>
											<a href="#" class="btn-link" data-bind="attr:{href:image.properties.source }, text:image.properties.source"></a>
										</div>
										<div class="separator-2"></div>										
										<h4>사진 변경</h4>
										<p class="text-primary"><span class="text-danger">사진을 변경하시려면 </span> 사진선택 버튼을 클릭하여 사진을 직접 선택하거나, 사진을 끌어 놓기(Drag&Dorp)를 하세요.</p>								
										<input name="update-photo-file" type="file" class="pull-right" />	
									</div>
								</div>	
							</section>
						</fieldset>
						<fieldset>
							<section>
								<h4>추가 정보</h4>
								<div class="photo-props-grid"></div>											
								<div class="note"><i class="fa fa-info"></i> 수정후 반듯이 저장버튼을 클릭해야 반영됩니다.</div>
							</section>
						</fieldset>						
					</form>					
					<div class="modal-footer">
						<button data-dismiss="modal" class="btn btn-flat btn-outline pull-left rounded" type="button">닫기</button>
						<button class="btn btn-flat btn-info rounded btn-outline" type="button" data-action="create" data-bind="{visible:followUp, click:create}" data-loading-text="<i class='fa fa-spinner fa-spin'></i>">다음</button>
						<button class="btn btn-flat btn-primary rounded" type="button" data-bind="visible:editable, click:update" data-loading-text="<i class='fa fa-spinner fa-spin'></i>">저장 </button>
					</div>					
				</div>c
			</div>			
		</div>
		<div id="my-image-view-modal" role="dialog" class="modal fade" data-backdrop="static" data-effect="zoom">
			<div class="mfp-container mfp-s-ready mfp-image-holder">
				<span class="btn-flat-icon chat" data-bind="click: comment"></span>		
				<span class="btn-flat-icon pencil" data-bind="click: edit"></span>			
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
		
		<!-- START COMMENT SLIDE -->		
		<div id="my-file-commentary" class="modal" style="background: rgba(0,0,0,0.4);">
			<div class="commentary commentary-drawer">
				<span class="btn-flat-icon close" data-commentary-close></span>
				<div class="commentary-content">
					<div class="ibox">
						<div class="ibox-content no-border">
							<div class="page-credits bg-white">
								<div class="credit-item">
									<div class="credit-img user">
										<img data-bind="attr:{src:image.imageThumbnailUrl} style="margin-right:10px;" class="img-cicle">
									</div>
									<div class="credit-name"> <span data-bind="text:image.name ">악당</span>  </div>
									<div class="credit-title"><span data-bind="text:image.formattedSize"></span> bytes </div>
								</div>							
							</div>
							<div class="shadow-wrapper" style="max-width:350px;">
								<div class="box-shadow shadow-effect-2 ">
									<img data-bind="attr:{ src:image.imageUrl }" class="img-responsive"></img>
								</div>	
							</div>
						</div>
					</div>				
				</div>
				
				<div class="ibox-content no-border bg-gray">							
					<div id="my-file-commentary-listview" class="comments"></div>
				</div>				
				
				<div class="commentary-footer">
							<div class="separator-2"></div>
							<div class="sky-form no-border">
									<label class="textarea">
										<textarea rows="4" name="comment" placeholder="댓글" data-bind="value:commentBody"></textarea>
									</label>
									<div class="text-right">
										<button class="btn btn-flat btn-info btn-outline btn-xl rounded" data-bind="click:comment">게시하기</button>
									</div>
							</div>					
				</div>
			</div>	
		</div>
		<!-- END COMMENT SLIDE -->			
		<!-- START RIGHT SLIDE MENU -->
		<section class="cbp-spmenu cbp-spmenu-vertical cbp-spmenu-right"  id="my-cloud-driver-controls-section">
			<header>
				<button type="button" class="btn-close" data-dismiss='spmenu' data-target-object="button[data-target-object-id='personalized-controls-section']">Close</button>
				<h5 class="side-section-title white">My 클라우드 드라이브</h5>	
			</header>	
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
	<!-- ============================== -->
	<!-- commentary template            -->
	<!-- ============================== -->	
	<script id="my-poll-commentary-listview-template" type="text/x-kendo-template">
		<div class="comment" >
			<img class="author-image" src="#=authorPhotoUrl()#" alt="">
			<div class="content">
				<span class="author">#if ( name == null ){# 손님 #}else{# #: name # #}#</span>
				<span class="comment-date">#: formattedCreationDate() #</span>
				<span class="linked-text">
					#: body #
				</span>
			</div>		
		</div>	
	</script>										
		<!-- START TEMPLATE -->									
	<!-- ============================== -->
	<!-- commentary template            -->
	<!-- ============================== -->	
	
	<script id="my-file-commentary-listview-template" type="text/x-kendo-template">
		<div class="comment" >
			<img class="author-image" src="#=authorPhotoUrl()#" alt="">
			<div class="content">
				<span class="author">#if ( name == null ){# 손님 #}else{# #: name # #}#</span>
				<span class="comment-date">#: formattedCreationDate() #</span>
				<span class="linked-text">
					#: body #
				</span>
			</div>		
		</div>	
	</script>	
	<#include "/html/common/common-homepage-templates.ftl" >		
	<#include "/html/common/common-personalized-templates.ftl" >
	<!-- ./END TEMPLATE -->
	</body>    
</html>