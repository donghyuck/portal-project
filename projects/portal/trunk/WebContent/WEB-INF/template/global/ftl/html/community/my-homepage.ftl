<#ftl encoding="UTF-8"/>
<html decorator="unify">
<head>
		<#assign page = action.getPage() >		
		<title>${page.title}</title>
		<#compress>		
		<script type="text/javascript">
		<!--
		var jobs = [];	
				
		yepnope([{
			load: [
			'css!<@spring.url "/styles/font-awesome/4.3.0/font-awesome.min.css"/>',
			'css!<@spring.url "/styles/jquery.sky-forms/2.0.1/custom-sky-forms.css"/>',	
			'css!<@spring.url "/styles/bootstrap.themes/unify/colors/blue.css"/>',
			'css!<@spring.url "/styles/jquery.magnific-popup/magnific-popup.css"/>',
			'css!<@spring.url "/styles/common/common.flat-icons.css"/>',		
			'css!<@spring.url "/styles/bootstrap.themes/common/common.ui.buttons.css"/>',		
			'css!<@spring.url "/styles/bootstrap.themes/common/common.ui.inspinia.css"/>',									
			'css!<@spring.url "/styles/codrops/codrops.dialog.css"/>',		
			'css!<@spring.url "/styles/codrops/codrops.dialog-sandra.css"/>',					
			'css!<@spring.url "/styles/common.pages/common.personalized.css"/>',	
			
			'<@spring.url "/js/jquery/1.10.2/jquery.min.js"/>',
			'<@spring.url "/js/jgrowl/jquery.jgrowl.min.js"/>',			
			'<@spring.url "/js/jquery.easing/jquery.easing.1.3.js"/>',		
			'<@spring.url "/js/jquery.bxslider/jquery.bxslider.min.js"/>',
			'<@spring.url "/js/jquery.magnific-popup/jquery.magnific-popup.js"/>',		
			'<@spring.url "/js/jquery.masonry/masonry.pkgd.min.js"/>',		
			'<@spring.url "/js/imagesloaded/imagesloaded.pkgd.min.js"/>',		
			'<@spring.url "/js/kendo/kendo.web.min.js"/>',
			'<@spring.url "/js/kendo.extension/kendo.ko_KR.js"/>',			
			'<@spring.url "/js/kendo/cultures/kendo.culture.ko-KR.min.js"/>',		
			'<@spring.url "/js/bootstrap/3.3.4/bootstrap.min.js"/>',			
			'<@spring.url "/js/common.plugins/jquery.slimscroll.min.js"/>', 		
			'<@spring.url "/js/common.plugins/query.backstretch.min.js"/>',			
			'<@spring.url "/js/common/common.ui.core.js"/>',							
			'<@spring.url "/js/common/common.ui.data.js"/>',
			'<@spring.url "/js/common/common.ui.community.js"/>',
			'<@spring.url "/js/common.pages/common.personalized.js"/>',
			'<@spring.url "/js/pdfobject/pdfobject.js"/>',			
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
							} 
						}						
					},
					wallpaper : {
						renderTo:$(".breadcrumbs-v3")
					},
					jobs:jobs
				});				
				// ACCOUNTS LOAD			
				var currentUser = new common.ui.data.User();			
				$(".navbar-nav li[data-menu-item='MENU_PERSONALIZED'], .navbar-nav li[data-menu-item='MENU_PERSONALIZED_1']").addClass("active");			
				// END SCRIPT 
				createMyPageListView();
			}
		}]);			

		function getMyPageOwnerId(){
			return 2;
		}
		
		function createMyAnnouncement(renderTo, msnry){
			
			var elem = $($('#announce-listview-template').html());
			var template = kendo.template($('#announce-listview-item-template').html());			
			common.ui.datasource(	'<@spring.url "/data/announce/list.json"/>',	{
				schema: {
					data : "announces",
					model : common.ui.data.Announce,
						total : "totalCount"
					},
				pageSize: 5											
			}).fetch(function(){
				var data = this.data();
				elem.find('ul').html( kendo.render(template, this.view()) );
				/*				
				$.each( data , function( index , item ){
					var elem = $(template( item ));			
					renderTo.prepend(elem);
					msnry.prepended( elem );
				});
				*/
				
				renderTo.prepend(elem);
				msnry.prepended( elem );				
				
				msnry.layout();
			});
		}		
		
		var ONE_PIXEL_IMG_SRC_DATA = "data:image/gif;base64,R0lGODlhAQABAIAAAAAAAP///yH5BAEAAAAALAAAAAABAAEAAAIBRAA7";
		
		function createMyPageCommentary(pageId){			
			var renderTo = $("#my-page-commentary");			
			if( !renderTo.data("model") ){				
				var listview = common.ui.listview($("#my-page-commentary-listview"), {
					dataSource: {
						transport: { 
							read: { url:'<@spring.url "/data/pages/comments/list.json?output=json"/>', type: 'POST' }
						},
						requestStart: function(e){	
									
						},
						schema: {
							total: "totalCount",
							data: "comments",
							model: common.ui.data.Comment
						},
						selectable: false,
						error:common.ui.handleAjaxError,
						batch: false,
						pageSize: 15,
						serverPaging: false,
						serverFiltering: false,
						serverSorting: false
					},
					template: kendo.template($("#my-page-commentary-listview-template").html()),
					autoBind: false,
					dataBound: function(e){		
						var elem = 	this.element.children();				
					},
					change: function(e){						
						var selectedCells = this.select();
						var selectedCell = this.dataItem( selectedCells );	
					}
				});
				
				var observable =  common.ui.observable({
					pageId : 0,
					coverPhotoUrl : ONE_PIXEL_IMG_SRC_DATA,
					pageCreditHtml : "",
					commentBody : "",
					comment : function(e){
						var $this = this;
						btn = $(e.target);						
						btn.button('loading');								
						common.ui.ajax(
							'<@spring.url "/data/pages/comment.json?output=json"/>',
							{
								data : {
									objectType: 31,
									objectId : $this.get("pageId"),
									text : $this.get("commentBody")
								},
								success : function(response){
								
									listview.dataSource.read({pageId: $this.pageId });
~									$('.item[data-object-id=' + $this.pageId  + '] .comment-page-count').html( response.count  );
									
								},
								complete : function(e){
									$this.set("commentBody", "");
									btn.button('reset');
								}							
						});	
						return false;						
					},
					setPage : function(source){
						var $this = this;
						if( typeof source == 'number'){							
							var title = $(".item [data-action=view][data-object-id=" + source + "]").text();
							var summary = $(".item[data-object-id=" + source + "]  .page-meta .page-description").text();
							var coverImgEle = $(".item[data-object-id=" + source + "] .cover img");
							var pageCreditHtml = $(".item[data-object-id="+source+"] .page-credits").html();							
							if( coverImgEle.length == 1 ){
								$this.set("coverPhotoUrl", coverImgEle.attr("src"));
							}else{
								$this.set( "coverPhotoUrl", ONE_PIXEL_IMG_SRC_DATA);
							}							
							$this.set("pageId", source );
							$this.set("pageCreditHtml", pageCreditHtml);
							$this.set("title", title);
							$this.set("summary", summary);
							$this.set("commentBody", "");
							listview.dataSource.read({pageId: source });
						}					
					}
				});
				renderTo.data("model", observable);			
				common.ui.bind( renderTo, observable );				
				$('.close[data-commentary-close]').click(function(){					
					renderTo.hide();
				});
			}			
			if(renderTo.is(":hidden")){
				renderTo.data("model").setPage( pageId ) ;
				$("body").css("overflow", "hidden");
				renderTo.show();
			}			
		}
		
		function createMyPageListView(){		
			var renderTo = $('#my-page-listview');			
			if( !renderTo.data('masonry')){			
				renderTo.masonry({	
					columnWidth: '.item',
					itemSelector: '.item',
					isAnimated: true
				});
				
				var msnry = renderTo.data('masonry');				
				createMyAnnouncement(renderTo, msnry);		
										
				var dataSource = new kendo.data.DataSource({				
						transport: { 
							read: { url:'<@spring.url "/data/pages/published/list.json?output=json"/>', type: 'POST' },
							parameterMap: function (options, type){
								return { startIndex: options.skip, pageSize: options.pageSize,  objectType: getMyPageOwnerId() }
							}
						},
						schema: {
							total: "totalCount",
							data: "pages",
							model: common.ui.data.Page
						},						
						error:common.ui.handleAjaxError,
						batch: false,						
						pageSize: 8,
						selectable: false, 
						serverPaging: true,
						serverFiltering: false,
						serverSorting: false,
						change: function(e) {
							var data = this.data();
							var $btn = $( "button[data-action=more]");
							var template = kendo.template($('#my-page-listview-item-template').html());		
							var elem = $(kendo.render(template, data));							
							elem.imagesLoaded(function(){
								renderTo.append( elem );		
								msnry.appended( elem );
								msnry.layout();
							});	
							$btn.button('reset')						
							if( this.page() < this.totalPages() ){
								$btn.show();
							}else{
								$btn.hide();
							}
						}				
				});
				
				dataSource.fetch();
				$( "button[data-action=more]").click(function(){
					var $btn = $(this).button('loading')
					var page = dataSource.page();
					var pageSize = dataSource.pageSize();
					var totalPages = dataSource.totalPages();
					if( page < totalPages ){
						dataSource.page( page + 1 );						
					}
				});		
				renderTo.on( "click", "a[data-action], button[data-action]",  function(e){				
					$this = $(this);
					var action = $this.data("action");
					var objectId = $this.data("object-id");					
					var item = dataSource.get(objectId);		
					if( action == 'view' ){
						createMyPageViewModal(objectId);
						//createMyPageViewer(objectId);					
					}else
					if( action == 'comment' ){
						createMyPageCommentary(objectId);					
					}
					return false;					
				});	
			}
		}
		
		function createMyPageViewModal(source){
			var renderTo = $("#my-page-view-modal");	
			if( !renderTo.data('bs.modal') ){
				var observable =  common.ui.observable({
					page : new common.ui.data.Page(),
					pageSource : "",
					pageSourceUrl : "",
					setPage: function(page){
						var that = this;
						page.copy(that.page);						
						if( that.page.properties.source ){
							that.set('pageSource', that.page.properties.source);
						}else{
							that.set('pageSource', "");
						} 
						if( that.page.properties.url ){
							that.set('pageSourceUrl', that.page.properties.url);
						}else{
							that.set('pageSourceUrl', "");
						}								
					}
				});
				
				
				renderTo.on('shown.bs.modal', function(e){		
					if(	isMasonryLayout(observable.page) ){
						console.log('masonry layout.');
						var masonryEl = renderTo.find("[data-image-layout=masonry]");
						kendo.ui.progress(renderTo, true);
						masonryEl.imagesLoaded( function(){
						  	masonryEl.masonry({
						    	itemSelector : '.item'
						  	});
						  	kendo.ui.progress(renderTo, false);
						  	masonryEl.css('visibility', 'visible');
						});
					}
				});
								
				kendo.bind(renderTo, observable );
				renderTo.data("model", observable);	
			}
			
			if( typeof source == 'number' ){					
				var targetEle = $('.item[data-object-id=' + source + ']');					
				kendo.ui.progress(targetEle, true);	
				common.ui.ajax( 
					'<@spring.url "/data/pages/get.json?output=json"/>', {
						data : { pageId : source , count: 1 },
						success: function(response){ 
							renderTo.data("model").setPage( new common.ui.data.Page(response) );
							kendo.ui.progress(targetEle, false);	
							renderTo.modal('show');	
						}	
				} );
			}else if ( typeof source == 'object' ){
				renderTo.data("model").setPage(source);
				renderTo.modal('show');	
			}
		}
		
		function createMyPageViewer(source, isEditable){
			var isEditable = isEditable || false;		
			var renderTo = $("#my-page-viewer");			
			if( ! common.ui.exists(renderTo) ){
				var observable =  common.ui.observable({
					page : new common.ui.data.Page(),
					editable : false,
					advencedSetting : false,
					useWrapMode : false,
					shwoTags : false,
					useWrap : function(e){
						var $this = this;
						if( $this.get('editable') )
							ace.edit("my-page-code-editor").getSession().setUseWrapMode($this.useWrapMode);
					},
					stateSource : [
						{name: "" , value: "INCOMPLETE"},
						{name: "승인" , value: "APPROVAL"},
						{name: "게시" , value: "PUBLISHED"},
						{name: "거절" , value: "REJECTED"},
						{name: "보관" , value: "ARCHIVED"},
						{name: "삭제" , value: "DELETED"}
					],
					properties : new kendo.data.DataSource({
						transport: { 
							read: { url:'/data/pages/properties/list.json?output=json', type:'post' },
							create: { url:'/data/pages/properties/update.json?output=json', type:'post' },
							update: { url:'/data/pages/properties/update.json?output=json', type:'post'  },
							destroy: { url:'/data/pages/properties/delete.json?output=json', type:'post' },
					 		parameterMap: function (options, operation){			
						 		if (operation !== "read" && options.models) {
						 			return { pageId: observable.page.pageId, items: kendo.stringify(options.models)};
								} 
								return { pageId: observable.page.pageId }
							}
						},	
						batch: true, 
						schema: {
							model: common.ui.data.Property
						},
						error:common.ui.handleAjaxError
					}),
					isVisible : true,
					close:function(e){
						 common.ui.dialog( renderTo ).close();
						 return false;
					},	
					validate : function (){
						var $this = this;
						if( $this.page.title.length == 0 ){
							if(!$("label[for=title]").hasClass("state-error"))
								$("label[for=title]").addClass("state-error");							
							common.ui.notification({
								hide:function(e){
									btn.button('reset');
								}
							}).show(
								{	title:"입력 오류", message: "제목을 입력하세요."	},
								"error"
							);
							return false;
						}						
						else{
							if($("label[for=title]").hasClass("state-error"))
								$("label[for=title]").removeClass("state-error");
								
							if( $this.page.pageId === 0 ) {
								if( $this.page.name.length === 0 ){
									$this.page.set("name" , $this.page.title) ;
								}
								if( $this.page.summary.length === 0 ){
									$this.page.set("summary" , $this.page.title) ;
								}									
								if( $this.page.bodyContent.bodyText.length === 0 ){
									$this.page.bodyContent.bodyText = "  ";
								}							
							} 	
						}								
						if($this.page.name.length === 0 ){
							if(!$("label[for=name]").hasClass("state-error"))
								$("label[for=name]").addClass("state-error");
							common.ui.notification({
								hide:function(e){
									btn.button('reset');
								}
							}).show(
								{	title:"입력 오류", message: "파일이름을 입력하세요."	},
								"error"
							);	
							return false;	
						}
						else{
							if($("label[for=name]").hasClass("state-error"))
								$("label[for=name]").removeClass("state-error");
						}																		
						if($this.page.summary.length == 0 ){
							if(!$("label[for=summary]").hasClass("state-error"))
								$("label[for=summary]").addClass("state-error");
							common.ui.notification({
								hide:function(e){
									btn.button('reset');
								}
							}).show(
								{	title:"입력 오류", message: "페이지 요약 정보를 입력하세요."	},
								"error"
							);	
							return false;	
						}
						else{
							if($("label[for=summary]").hasClass("state-error"))
								$("label[for=summary]").removeClass("state-error");
						}									
					},
					create : function(e){
						var $this = this, 
						btn = $(e.target);						
						btn.button('loading');					
						$this.page.bodyContent.bodyText = $('#my-page-editor').data('kendoEditor').value();					
						$this.validate();
						common.ui.ajax(
							'<@spring.url "/data/pages/update.json?output=json"/>',
							{
								data : kendo.stringify($this.page) ,
								contentType : "application/json",
								success : function(response){
									if( response.pageId ){
										$this.set( "editable" , true ) ;	
										$this.setPage( new common.ui.data.Page(response) );
									}						
								},
								complete : function(e){
									btn.button('reset');
								}							
						});												
						return false;
					},
					update : function(e){
						var $this = this, 
						btn = $(e.target);						
						btn.button('loading');						
						$this.page.bodyContent.bodyText = $('#my-page-editor').data('kendoEditor').value();
						$this.validate();						
						common.ui.ajax(
							'<@spring.url "/data/pages/update.json?output=json"/>',
							{
								data : kendo.stringify($this.page) ,
								contentType : "application/json",
								success : function(response){
									common.ui.notification({title:"페이지 저장", message: "페이지 가 정상적으로 저장되었습니다.", type: "success" });
									common.ui.listview( $("#my-page-listview") ).dataSource.read();
									$this.close();									
								},
								fail: function(){								
									common.ui.notification({title:"페이지 저장 오류", message: "시스템 운영자에게 문의하여 주십시오." });
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
						return false;
					},	
					exportPdf: function(e){
						var $this = this, 
						btn = $(e.target);						
						btn.button('loading');	
						if( $this.page.pageId  > 0 ) {
							kendo.drawing.drawDOM(renderTo.find("article")).then(function(group) {
								return kendo.drawing.exportPDF(group, {
								paperSize: "auto",
								subject : $this.page.title ,
								creator : $this.page.user.name,
								title : $this.page.title,
								margin: { left: "1cm", top: "1cm", right: "1cm", bottom: "1cm" }
								});
							}).done(function(data) {
								kendo.saveAs({
								dataURI: data,
								fileName:  $this.page.name + ".pdf",
								proxyURL: "/downlaod/export"
								});
								btn.button('reset');
							});
						}
						return false;
					},								
					setPage: function(page){
						var that = this;
						page.copy(that.page);						
						if( $("#my-page-imagebroswer").data("kendoExtImageBrowser") ) {
							$("#my-page-imagebroswer").data("kendoExtImageBrowser").objectId( that.page.pageId );
						}
						if( that.page.pageId  > 0 ) {
							that.set("advencedSetting", true);
							that.properties.read();
						} else {
							that.set("advencedSetting", false);
						}	
						if( that.page.tagsString.length > 0 )
							that.set("shwoTags", true);
						else 
							that.set("shwoTags", false);	
					}
				});		
				
				renderTo.data("model", observable);		
				var content = renderTo.find(".sky-form");					
				common.ui.dialog( renderTo , {
					data : observable,
					autoBind: true,
					"open":function(e){		
						$("body").css("overflow-y", "hidden");
						renderTo.find(".dialog__content").css("overflow-y", "auto");
					},
					"opened" : function(e){		
						// update main listview
						$('.item[data-object-id=' + this.data().page.pageId + '] .view-page-count').html( this.data().page.viewCount  );
					},
					"close":function(e){			
						renderTo.find(".dialog__content").css("overflow-y", "hidden");
						//$("body").css("overflow-x", "hidden");					
						$("body").css("overflow-y", "auto");		
					}
				});		
				var bodyEditor =  $("#my-page-editor" );
				createEditor( "my-page" , bodyEditor, { 
					modal : false , 
					appendTo: $("#my-page-editor-code-panel"), 
					tab: $("#my-page-editor-tabs"), 
					pageSize : 15,
					objectType : 31,
					useWrapMode : observable.useWrapMode 
				});	
			}										
			var dialogFx = common.ui.dialog( renderTo );	
			if( !dialogFx.isOpen ){
				if( typeof source == 'number' ){					
					var targetEle = $('.item[data-object-id=' + source + ']');					
					kendo.ui.progress(targetEle, true);	
					common.ui.ajax( 
					'<@spring.url "/data/pages/get.json?output=json"/>', {
						data : { pageId : source , count: 1 },
						success: function(response){ 
							renderTo.data("model").setPage( new common.ui.data.Page(response) );
							renderTo.data("model").set( "editable" , isEditable) ;	
							kendo.ui.progress(targetEle, false);	
							dialogFx.open();
						}	
					} );
				}else if ( typeof source == 'object' ){
					renderTo.data("model").setPage(source);
					renderTo.data("model").set( "editable" , isEditable) ;	
					dialogFx.open();
				}
			}				
		}
		
		-->
		</script>		
		<style scoped="scoped">			
		/** Breadcrumbs */
		.breadcrumbs-v3 {
			position:relative;
		}

		.breadcrumbs-v3 p	{
			color : #fff;
			font-size: 24px;
			font-weight: 200;
			margin-bottom: 0;
		}	
		
		.breadcrumbs-v3.img-v1 {
			background: url( ${page.getProperty( "breadcrumbs.imageUrl", "")}) no-repeat;
			background-size: cover;
			background-position: center center;			
		}
					
		#my-page-listview {
			min-height:300px;
			margin-bottom:50px;
		}			
		
		/* iBox */
		.ibox.follow .ibox-title {
			  border-color: #007aff;
		}

		.ibox.events .ibox-title {
			  border-color: #ff2d55;
		}

		.ibox.events ul li {
			padding: 8px 0;
			border-top: 1px solid #353535;
		}
		
		.ibox.events ul li:first-child {
			padding-top: 0;
			border-top: none;
		}
		
		.ibox.events ul li a {
			color: #8e8e93;
		}
		
		.ibox.events ul small {
			color: #999;
			display: block;
		}
		
		</style>   	
		</#compress>
	</head>
	<body id="doc" class="bg-white">
		<div class="page-loader"></div>
		<div class="wrapper">
			<!-- START HEADER -->		
			<#include "/html/common/common-homepage-menu.ftl" >		
			<!-- END HEADER -->	
			<!-- START MAIN CONTENT -->
			<#if action.isSetNavigator()  >
			<#assign navigator = action.getNavigator() />		
			<div class="breadcrumbs-v3 img-v1 arrow-up no-border">
				<div class="personalized-controls container text-center p-xl">
					<p class="text-quote"> ${ navigator.description ? replace ("{displayName}" , action.webSite.company.displayName ) }	</p>
					<h1 class="text-xxl"><#if navigator.icon?? ><i class="icon-flat ${navigator.icon}"></i></#if> ${ navigator.title }</h1>					
					<a href="<@spring.url "/display/0/my-page.html"/>"><span class="btn-flat pencle t-0-r-2"></span></a>
					<a href="<@spring.url "/display/0/my-driver.html"/>"><span class="btn-flat folder t-0-r-1"></span></a>
					<span class="btn-flat settings"></span>
					</div><!--/end container-->
			</div>
			</#if>	
			<!-- START MAIN CONTENT -->
			<div class="container content">		
				<div class="row">
					<div id="my-page-listview" ></div>
				</div>
				<div class="row">
					<div class="col-sm-4 col-sm-offset-4">
						<button type="button" class="btn btn-default btn-lg btn-outline rounded btn-flat btn-block" data-action="more" data-loading-text='<i class="fa fa-spinner fa-spin"></i>'><span class="btn-label icon fa fa-angle-down" style="
						    padding-right: 30px; display:none;"></span>더보기</button>					
					</div>
				</div>
			</div>	
			<!-- ./END MAIN CONTENT -->	
	 		<!-- START FOOTER -->
			<#include "/html/common/common-homepage-globalfooter.ftl" >		
			<!-- ./END FOOTER -->					
		</div>	
		
		<div id="my-page-view-modal" role="dialog" class="modal fade bg-white" data-backdrop="static" data-effect="zoom">
			<div class="modal-dialog modal-lg modal-flat ">
				<div class="modal-content">	
					<div class="modal-header">
						<span data-bind="{text: page.title}"></span>
						<button aria-hidden="true" data-dismiss="modal" class="close" type="button"></button>
					</div>
					<article>
							<div class="p-sm bg-gray">
								<div class="author">
									<img width="30" height="30" class="img-circle pull-left" data-bind="attr:{src:page.authorPhotoUrl}" src="/images/common/no-avatar.png" style="margin-right:10px;">
									<ul class="list-inline">
										<li><span>By</span> <span data-bind="{ text: page.user.name, visible: page.user.nameVisible }"></span><code data-bind="{ text: page.user.username }"></code></li>
										<li>|</li>
										<li><span>버전:</span> <span data-bind="{ text: page.versionId }"></span></li>
										<li>|</li>
										<li><span>조회수:</span> <span data-bind="{ text: page.viewCount }"></span></li>
										<li>|</li>
										<li><span>댓글:</span> <span data-bind="{ text: page.commentCount }"></span></li>
										<li>|</li>																								
										<li>작성일: <span data-bind="{ text: page.formattedCreationDate }"></span></li>
										<li>수정일: <span data-bind="{ text: page.formattedModifiedDate }"></span></li>
									</ul>  
								</div>
								<div class="separator-2"></div>
								<p class="text-muted" data-bind="text:page.summary"></p>
	                        </div>
	                  </article>  
					<div class="modal-body">
						<div data-bind="{html:page.bodyContent.bodyText}" ></div>
					</div>
				</div>
			</div>	
		</div>
		
		<div id="my-page-viewer" class="dialog dialog-full bg-glass" data-feature="dialog" data-dialog-animate="">
			<div class="dialog__overlay bg-white"></div>
			<div class="dialog__content">
				<div class="container">
					<div class="row">
						<div class="col-sm-12">						
							<article class="ibox float-e-margins">
			                    <div class="ibox-title">
			                    	<span class="text-danger" data-bind="invisible:advencedSetting"><i class="fa fa-info"></i> 페이지 제목을 입력하세요</span>
			                        <span data-bind="{text: page.title, invisible:editable }"></span>&nbsp;
									<div class="ibox-tools m-r-lg hidden-xs" data-bind="invisible:editable">
										<button type="button" class="btn btn-deafult btn-flat btn-outline btn-sm rounded" data-bind="click:exportPdf" data-loading-text="<i class='fa fa-spinner fa-spin'></i>"><i class="fa fa-file-pdf-o"></i> PDF</button>
									</div>
			                        <span class="close" data-dialog-close></span>					
			                    </div>
			                    <section data-bind="{invisible:editable}">
									<div class="ibox-content ibox-heading">
										<div class="author margin-bottom-20">
											<img width="30" height="30" class="img-circle pull-left" data-bind="attr:{src:page.authorPhotoUrl}" src="/images/common/no-avatar.png" style="margin-right:10px;">
											<ul class="list-inline grid-boxes-news">
												<li><span data-bind="{ text: page.user.name, visible: page.user.nameVisible }"></span><code data-bind="{ text: page.user.username }"></code></li>
												<li>|</li>
												<li>버전: <code data-bind="{ text: page.versionId }"></code></li>
												<li>|</li>
												<li>조회수: <span data-bind="{ text: page.viewCount }"></span></li>
												<li>|</li>
												<li><i class="fa fa-comments-o"></i> (<span data-bind="{ text: page.commentCount }"></span>)</li>
												<li>|</li>
												<li data-bind="visible:shwoTags"><i class="fa fa-tags"></i> <span data-bind="text:page.tagsString"></span></li>
												<li>|</li>
												<li>생성일: <span data-bind="{ text: page.formattedCreationDate }"></span></li>
												<li>최종수정: <span data-bind="{ text: page.formattedModifiedDate }"></span></li>
												
											</ul>  
										</div>
										<div class="summary tag-box tag-box-v4 no-margin-b">                    
                    						<p data-bind="html:page.summary"></p>
                    					</div>
                                	</div>
                                	<div data-bind="{html:page.bodyContent.bodyText}" class="ibox-content"></div>
			                    </section><!-- /.section-->
								<div class="sky-form" data-bind="visible:editable" class="no-border-hr">
									<fieldset>
										<label for="title" class="input">
											<input type="text" name="title" placeholder="제목" data-bind="value: page.title">
										</label>
										<div class="text-right">
											<button class="btn btn-default btn-flat btn-outline  rounded" type="button" data-toggle="collapse" data-target="#my-page-options" aria-expanded="false" aria-controls="my-page-options"><i class="fa fa-angle-down"></i> 고급옵션</button>
											<button type="button" class="btn btn-info btn-flat btn-outline  rounded" data-bind="{events:{click:update}, visible:advencedSetting}" data-loading-text="<i class='fa fa-spinner fa-spin'></i>">저장</button>
										</div>											
									</fieldset>	
									<section class="no-margin-b collapse" id="my-page-options"> 
									<fieldset>
											<div class="row">
												<div class="col-md-6">
													<section>
															<label for="summary" class="textarea">
																<textarea rows="3" name="summary" placeholder="요약" data-bind="value: page.summary"></textarea>
															</label>
													</section>												
													<section>
														<label class="input">
																<i class="icon-prepend fa fa-file-text-o"></i>
																<input type="text" name="name" placeholder="파일" data-bind="value: page.name">
															</label>
													</section>																										
													<section>
														<label class="input">
															<i class="icon-prepend fa fa-file-code-o"></i>
															<input type="text" name="template" placeholder="템플릿">
														</label>
													</section>														
													</div>
												<div class="col-md-6">
														<div class="panel-group acc-v1" id="accordion-1" data-bind="visible:advencedSetting">
															<div class="panel panel-default">
																<div class="panel-heading">
																	<h4 class="panel-title">
																		<a class="accordion-toggle collapsed" data-toggle="collapse" data-parent="#accordion-1" href="#collapse-One">
																		<i class="fa fa-cog"></i> 속성
																		</a>
																	</h4>
																</div>
																<div id="collapse-One" class="panel-collapse collapse" style="height: 0px;">
																	<div class="panel-body no-padding">
																		<div data-role="grid"
																			date-scrollable="false"
																			data-editable="true"
																			data-autoBind="false"
																			data-toolbar="[ { 'name': 'create', 'text': '추가' }, { 'name': 'save', 'text': '저장' }, { 'name': 'cancel', 'text': '취소' } ]"
																			data-columns="[
																				{ 'title': '이름',  'field': 'name', 'width': 200 },
																				{ 'title': '값', 'field': 'value' },
																				{ 'command' :  { 'name' : 'destroy' , 'text' : '삭제' },  'title' : '&nbsp;', 'width' : 100 }
																			]"
																			data-bind="source: properties"
																			style="border:0px;"></div>	
																	</div>
																</div>
															</div>
															<div class="panel panel-default">
																<div class="panel-heading">
																	<h4 class="panel-title">
																		<a class="accordion-toggle collapsed" data-toggle="collapse" data-parent="#accordion-1" href="#collapse-Two">
																		<i class="fa fa-floppy-o"></i> 첨부파일
																		</a>
																	</h4>
																</div>
																<div id="collapse-Two" class="panel-collapse collapse" style="height: 0px;">
																	<div class="panel-body">
																	서비스 준비중 입니다.	
																	</div>
																</div>
															</div>					
															<div class="panel panel-default">
																<div class="panel-heading">
																	<h4 class="panel-title">
																		<a class="accordion-toggle collapsed" data-toggle="collapse" data-parent="#accordion-1" href="#collapse-Three">
																		<i class="fa fa-history"></i> 버전
																		</a>
																	</h4>
																</div>
																<div id="collapse-Three" class="panel-collapse collapse" style="height: 0px;">
																	<div class="panel-body">
																		<section>									
																			<label class="label">현재 버전</label>					
																			<label class="input state-disabled">
																				<input type="text" name="versionId" placeholder="버전" data-bind="value: page.versionId" readonly >
																			</label>
																		</section>
																	</div>
																</div>
															</div>																												
														</div><!-- ./acc-v1 -->
												</div><!-- /.col-6-->				
											</div><!-- /.row-->										
									</fieldset>										
									</section>		
									<fieldset class="bg-white" data-bind="visible:advencedSetting">			
											<div class="row">
												<div class="col-md-9"></div>
												<div class="col-md-3"><label class="toggle"><input type="checkbox" name="checkbox-toggle" data-bind="checked: useWrapMode, events: { change: useWrap }"><i class="rounded-4x"></i>줄바꿈 설정/해지</label></div>
											</div>												
												<div class="tab-v1">
													<div role="tabpanel">
														<!-- Nav tabs -->													
														<ul class="nav nav-tabs" role="tablist" id="my-page-editor-tabs">
															<li role="presentation" class="m-l-sm active"><a href="#my-page-editor-panel" aria-controls="my-page-editor-panel" data-action-target="editor"  role="tab" data-toggle="tab">글쓰기</a></li>
															<li role="presentation"><a href="#my-page-editor-code-panel" aria-controls="my-page-editor-code-panel" data-action-target="ace" role="tab" data-toggle="tab">코드</a></li>
														</ul>												
														<!-- Tab panes -->
														<div class="tab-content no-padding">
															<div role="tabpanel" class="tab-pane active" id="my-page-editor-panel">
																<textarea id="my-page-editor" class="no-border" data-bind='value:page.bodyContent.bodyText' style="height:500px;"></textarea>
															</div>
															<div role="tabpanel" class="tab-pane" id="my-page-editor-code-panel"></div>
														</div>
													</div>
												</div>		
										</fieldset>	
										<footer class="text-right">
											<button type="button" class="btn btn-success btn-flat btn-lg rounded" data-bind="{events:{click:create}, invisible:advencedSetting}" data-loading-text="<i class='fa fa-spinner fa-spin'></i>"><i class="fa fa-angle-right"></i> 다음</button> 				
											<button type="button" class="btn btn-info btn-flat btn-lg rounded" data-bind="{events:{click:update}, visible:advencedSetting}" data-loading-text="<i class='fa fa-spinner fa-spin'></i>">저장</button> 				
										</footer>															
								</div>
			                </article>
						</div>
					</div>					
				</div>				
			</div>
		</div>	
		
		
		<!-- START COMMENT SLIDE -->		
		<div id="my-page-commentary" class="modal" style="background: rgba(0,0,0,0.4);">
			<div class="commentary commentary-drawer">
				<span class="btn-flat-icon close" data-commentary-close></span>
				<div class="commentary-content">
					<div class="ibox">
						<div class="ibox-content no-border">
							<div class="page-credits bg-white" data-bind="{html:pageCreditHtml}" ></div>
							<img data-bind="attr:{ src:coverPhotoUrl }" class="img-responsive"></img>
							<h2 data-bind="text:title" class="headline"></h2>
							<p data-bind="text:summary"></p>
						</div>
						<div class="ibox-content no-border bg-gray">
							<div class="separator-2"></div>
							<div class="sky-form no-border">
									<label class="textarea">
										<textarea rows="4" name="comment" placeholder="댓글" data-bind="value:commentBody"></textarea>
									</label>
									<div class="text-right">
										<button class="btn btn-flat btn-info btn-outline btn-xl" data-bind="click:comment">게시하기</button>
									</div>
							</div>									
							<div id="my-page-commentary-listview" class="comments">
							</div>
						</div>
					</div>				
				</div>
			</div>	
		</div>
		<!-- END COMMENT SLIDE -->	
			
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
	<!-- ============================== -->
	<!-- announce / events template                       -->
	<!-- ============================== -->	
	<script type="text/x-kendo-template" id="announce-listview-template">	
	<div class="col-md-3 col-sm-4  item">
		<div class="ibox float-e-margins events">
			<div class="ibox-title bg-gray">
				<i class="icon-flat mega-phone m-b-n-sm"></i>
			</div>
			<div class="ibox-content bg-gray">
				<ul class="list-unstyled m-l-sm"></ul>
			</div>
		</div>
	</div>	
	</script>	
	<script type="text/x-kendo-template" id="announce-listview-item-template">	
	<li>
		<a href="javascript:common.redirect('<@spring.url "/display/0/events.html" />', { announceId :#= announceId # }, 'get' );"><i class="fa fa-angle-right"></i> #:subject# </a>
		<small>#: formattedModifiedDate() #</small>
	</li>
	</script>	
	<!-- ============================== -->
	<!-- commentary template                                        -->
	<!-- ============================== -->	
	<script id="my-page-commentary-listview-template" type="text/x-kendo-template">
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
	<!-- ============================== -->
	<!-- page template                                        -->
	<!-- ============================== -->	
	<script id="my-page-listview-item-template" type="text/x-kendo-template">
	<div class="col-md-3 col-sm-4  item" data-object-id="#=pageId#">
		<div class="ibox summary float-e-margins #if( getCurrentUser().userId != user.userId ) { # follow#}#">
			<div class="ibox-title cover">
			#if( bodyContent.imageCount > 0 ){#
			<img class="img-responsive #if(pageState ===  'DELETED' ){# grayscale #}#" src="#=bodyContent.firstImageSrc#" alt="">
			#}#
			#if ( pageState === "PUBLISHED" ) { #<span class="label label-success">#: kendo.toString( modifiedDate , "D")# # }else if( pageState === "DELETED" ) {# <span class="label label-default">#: pageState #</span> #}else{# <span class="label label-danger">#: pageState #</span> #}#
				<div class="hover-mask"></div>
			</div>			
			<div class="ibox-content">
				#if( pageState !=  'DELETED' ){#<h2><a href="\\#" data-action="view" data-object-id="#=pageId#">#:title#</a></h2>#}else{#
					<h2 class="text-muted">#:title#</a></h2>
				#}#
					<div class="page-meta no-margin-hr">
					#if ( tagsString.length > 0 ){#
						<p class="page-tags" ><i class="fa fa-tags"></i> #: tagsString #</p>
					#}#
					#if ( summary != null && summary.length > 0 ){#
						<p class="page-description">#: summary #</p>
					#}#
						<ul class="list-inline page-tools">			
								<li><i class="fa fa-eye"> </i> <span class="view-page-count">#: viewCount #</span></li>
								<li>|</li>
								<li><a href="\\#" data-action="comment" data-object-id="#=pageId#"><i class="fa fa-comments-o"></i> <span class="comment-page-count">#: commentCount #</span></a></li>	
						</ul>										

					</div>					
				
			# if( getCurrentUser().userId === user.userId ) { # 	
				<div class="text-right hidden">
					<div class="btn-group">				
						#if( pageState !=  'DELETED' ){#
						<button class="btn btn-info btn-flat btn-outline rounded-left btn-sm" data-action="edit" data-object-id="#=pageId#"> 편집</button>
						#}#
						#if( pageState === 'PUBLISHED' ){#
						<button class="btn btn-info btn-flat btn-outline btn-sm" data-action="share" data-object-id="#=pageId#" data-loading-text="<i class='fa fa-spinner fa-spin'></i>"> 공유</button>		
						#}else{#
							#if( pageState != 'DELETED'){# 
							<button class="btn btn-info btn-flat btn-outline btn-sm" data-action="publish" data-object-id="#=pageId#" data-loading-text="<i class='fa fa-spinner fa-spin'></i>"> 게시</button>
							#}#						
						#}#
					</div>				
					#if( pageState ===  'DELETED' ){#						
					<button class="btn btn-default btn-flat btn-outline rounded btn-sm" data-action="restore" data-object-id="#=pageId#" data-loading-text="<i class='fa fa-spinner fa-spin'></i>">임시저장 이동</button>		
					#}else{#
					<button class="btn btn-danger btn-flat btn-outline rounded-right btn-sm" data-action="delete" data-object-id="#=pageId#" data-loading-text="<i class='fa fa-spinner fa-spin'></i>">삭제</button>		
					#}#			
				</div>	
			#}#	
			</div>
			
			<div class="page-credits">
				<div class="credit-item">
					<div class="credit-img user">
						<img src="#= authorPhotoUrl() #" class="img-responsive img-circle" />
					</div>
					<div class="credit-name">#if( user.nameVisible ){ # #: user.name # <code>#:user.username#</code> </div># } else { # #: user.username #</div> # } #
					<div class="credit-title"></div>
				</div>
			</div>		
			
		</div>
	</div><!--/.item  -->	
	</script>										
	<#include "/html/common/common-homepage-templates.ftl" >		
	<#include "/html/common/common-personalized-templates.ftl" >
	<#include "/html/common/common-editor-templates.ftl" >	
	<!-- ./END TEMPLATE -->
	</body>    
</html>