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
			'css!<@spring.url "/styles/font-icons/themify-icons.css"/>',
			'css!<@spring.url "/styles/jquery.sky-forms/2.0.1/custom-sky-forms.css"/>',	
			'css!<@spring.url "/styles/bootstrap.themes/unify/colors/blue.css"/>',
			'css!<@spring.url "/styles/jquery.magnific-popup/magnific-popup.css"/>',
			'css!<@spring.url "/styles/common/common.flat-icons.css"/>',		
			'css!<@spring.url "/styles/bootstrap.themes/common/common.ui.buttons.css"/>',		
			'css!<@spring.url "/styles/bootstrap.themes/common/common.ui.inspinia.css"/>',									
			'css!<@spring.url "/styles/codrops/codrops.cbp-spmenu.css"/>',
			'css!<@spring.url "/styles/codrops/codrops.morphing.css"/>',	
			'css!<@spring.url "/styles/codrops/codrops.dialog.css"/>',		
			'css!<@spring.url "/styles/codrops/codrops.dialog-sally.css"/>',					
			'css!<@spring.url "/styles/common.pages/common.personalized.css"/>',	
			'<@spring.url "/js/jquery/1.10.2/jquery.min.js"/>',
			'<@spring.url "/js/jgrowl/jquery.jgrowl.min.js"/>',			
			'<@spring.url "/js/jquery.easing/jquery.easing.1.3.js"/>',		
			'<@spring.url "/js/jquery.bxslider/jquery.bxslider.min.js"/>',
			'<@spring.url "/js/jquery.magnific-popup/jquery.magnific-popup.min.js"/>',		
			'<@spring.url "/js/jquery.masonry/jquery.masonry.min.js"/>',		
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
								if( !currentUser.anonymous ){		
 
								}
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
				//$(".navbar-nav li[data-menu-item='MENU_PERSONALIZED'], .navbar-nav li[data-menu-item='MENU_PERSONALIZED_1']").addClass("active");		
				createMyPageListView();	
				//createPageSection();
				// END SCRIPT 				
			}
		}]);			

		<!-- ============================== -->
		<!-- Page														-->
		<!-- ============================== -->		
		function getMyPageOwnerId(){
			return $("#my-page-source-list input[type=radio][name=radio-inline]:checked").val();			
		}
	
		function masonry(){		
			$(".grid-boxes").imagesLoaded( function(e){				
				var renderTo = $(".grid-boxes");			
				var gutter = 30;
				var min_width = 298;			
				renderTo.masonry({
					itemSelector : ".grid-boxes-in",
					gutterWidth: gutter,					
					isAnimated : true,
					isFitWidth : true,
					ransitionDuration : 100,
					columnWidth: function(containerWidth){		
						var box_width = (((containerWidth - 2*gutter)/3) | 0); 
						if (box_width < min_width) {
							box_width = (((containerWidth - gutter)/2) | 0);
						}
						if (box_width < min_width) {
							box_width = containerWidth;
						}
						renderTo.find('.grid-boxes-in').width(box_width);
						return box_width;
					}	
				});	
			});	
		}
	
		function createMyPageListView(){		
			var renderTo = $("#my-page-listview");
			if( !common.ui.exists( renderTo ) ){
				common.ui.listview( renderTo, {
					dataSource: {
						serverFiltering: false,
						transport: { 
							read: { url:'<@spring.url "/data/pages/list.json?output=json"/>', type: 'POST' },
							parameterMap: function (options, type){
								return { startIndex: options.skip, pageSize: options.pageSize,  objectType: getMyPageOwnerId() }
							}
						},
						requestStart: function(e){
							if( $(".grid-boxes").data('masonry') ){
								$(".grid-boxes").masonry('remove', $('.grid-boxes .grid-boxes-in'));
								$(".grid-boxes").masonry('destroy');
							}						
						},
						schema: {
							total: "totalCount",
							data: "pages",
							model: common.ui.data.Page
						},
						selectable: 'single', 
						error:common.ui.handleAjaxError,
						batch: false,
						pageSize: 15,
						serverPaging: true,
						serverFiltering: false,
						serverSorting: false
					},
					template: kendo.template($("#my-page-listview-template").html()),
					dataBound: function(e){					
						masonry();
					},
					change: function(e){						
						var selectedCells = this.select();
						var selectedCell = this.dataItem( selectedCells );	
						alert( kendo.stringify( selectedCell ) );
					}
				});		
				renderTo.removeClass("k-widget k-listview");					
				common.ui.pager($("#my-page-pager"), {
					dataSource: common.ui.listview(renderTo).dataSource,
					pageSizes: [15, 25, 50]
				});		
				$(".grid-boxes").on( "click", "a[data-action], button[data-action]",  function(e){				
					$this = $(this);
					var action = $this.data("action");
					var objectId = $this.data("object-id");						
					var item = common.ui.listview(renderTo).dataSource.get(objectId);
					switch( action ){
						case 'view':						
						createMyPageViewer(item);
						break;		
						case 'edit':						
						createMyPageViewer( item , true );	
						break;	
						case 'delete':
						deletePage(item, $this );					
						break;	
						case 'share':
						alert( action );													
						break;	
						case 'publish':
						publishPage( item, $this );		
						break;				
						case 'restore':
						restorePage(item, $this);
						break;																										
					}	
					return false;
				});
				
				$("#my-page-source-list input[type=radio][name=radio-inline]").on("change", function () {						
					common.ui.listview(renderTo).dataSource.read();	
				});					
				
				// event for new page
				$("button[data-action=create]").click(function(e){
					var page = new common.ui.data.Page();
					page.set("objectType", getMyPageOwnerId());					
					createMyPageViewer(page, true);
				});
				
			}			
			if( $("article.bg-white").is(":hidden") ){
				$("article.bg-white").show();
			} 			
		}

		function restorePage(page, target ){
			if( page.pageState === PAGE_STATES.DELETED ){
				if( common.ui.defined( target )){	
					target.button('loading');	
				}
				page.pageState = PAGE_STATES.INCOMPLETE;
				updatePageState( page , function(){
					if( common.ui.defined( target )){	
						target.button('reset');	
					}
					common.ui.listview( $("#my-page-listview") ).dataSource.read();									
				});		
			}else{
				alert("삭제된 페이지가 아닙니다.");	
			}
			return false;					
		}  
		
		function deletePage(page, target ){
			if( page.pageState != PAGE_STATES.DELETED ){
				if( common.ui.defined( target )){	
					target.button('loading');	
				}
				page.pageState = PAGE_STATES.DELETED;
				updatePageState( page , function(){
					if( common.ui.defined( target )){	
						target.button('reset');	
					}
					common.ui.listview( $("#my-page-listview") ).dataSource.read();									
				});		
			}else{
				alert("삭제할 수 없습니다.");	
			}
			return false;					
		}  

		function publishPage(page, target ){
			if( page.pageState === PAGE_STATES.INCOMPLETE ||  page.pageState === PAGE_STATES.APPROVAL || page.pageState === PAGE_STATES.ARCHIVED ){
				if( common.ui.defined( target )){	
					target.button('loading');	
				}
				page.pageState = PAGE_STATES.PUBLISHED;
				updatePageState( page , function(){
					if( common.ui.defined( target )){	
						target.button('reset');	
					}
					common.ui.listview( $("#my-page-listview") ).dataSource.read();									
				});				
			}else{
				alert("게시할 수 없습니다.");	
			}
			return false;					
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
					update : function(e){
						var $this = this, 
						btn = $(e.target);						
						btn.button('loading');						
						$this.page.bodyContent.bodyText = $('#my-page-editor').data('kendoEditor').value();						
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
						}						
						if($this.page.name.length == 0 ){
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
					}
				});		
				
				renderTo.data("model", observable);		
				var content = renderTo.find(".sky-form");					
				common.ui.dialog( renderTo , {
					data : observable,
					autoBind: true,
					"open":function(e){		
						$("body").css("overflow-y", "hidden");
					},
					"opened" : function(e){		
						renderTo.find(".dialog__content").css("overflow-y", "auto");
					},
					"close":function(e){			
						renderTo.find(".dialog__content").css("overflow-y", "hidden");
						$("body").css("overflow-x", "hidden");					
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
				renderTo.data("model").set( "editable" , isEditable) ;	
				renderTo.data("model").setPage(source);					
				dialogFx.open();
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
						
		/** Page Editor **/		
		#my-page-editor-panel .k-editor {
			border : 0;
		}
		
		.ace_editor{
			min-height: 500px;			
		}		
		
		#my-page-viewer .k-grid-content {
			min-height: 150px;		
		}
		/** Masonry Grid **/			

		.blog_masonry_3col {
			padding-bottom: 60px;
		}
		
		.blog_masonry_3col .grid-boxes-in {
			padding: 0;
			margin-bottom: 30px;
			border: solid 1px #eee;
		}
		
		.blog_masonry_3col .grid-boxes-caption {
			padding: 15px;
		}
		
		.blog_masonry_3col h3 {
			font-size: 20px; 
			font-weight: 200;
			line-height: 28px;
		}
		
		.blog_masonry_3col h3 a {
			color: #555;
		}
		
		.blog_masonry_3col h3 a:hover {
			color: #72c02c;
		}
		
		.blog_masonry_3col h3 a:hover {
			color: #72c02c;
		}
		
		.blog_masonry_3col ul.grid-boxes-news {
			margin-bottom: 15px;
		}
		
		.blog_masonry_3col ul.grid-boxes-news li {
			font-size: 12px;
		}
		
		.blog_masonry_3col ul.grid-boxes-news li,
		.blog_masonry_3col ul.grid-boxes-news li a {
			color: #777;
		}
		
		.blog_masonry_3col ul.grid-boxes-news li a:hover {
			color: #72c02c;
		}
				
		.grid-boxes {
			visibility: hidden;
			min-height:300px;
		}
		
		.grid-boxes-in.masonry-brick {
			visibility: visible;
		}
		
		
		.acc-v1	.panel-default {
			border-color: #bbb;
		}
		
		/*Quote Block*/
		/*
		.grid-boxes-caption.grid-boxes-quote {
			padding: 30px;
			background: #333;
			text-align: center;
		}
		
		.grid-boxes-quote p {
			position: relative;
		}
		
		.grid-boxes-quote p:after {
		    content: " \" ";
			margin-left: 10px;
		    position: absolute;
		    font-family: Tahoma;
		}
		
		.grid-boxes-quote p:before {
		    content: " \" ";
			margin-left: -15px;
		    position: absolute;
		    font-family: Tahoma;
		}
		
		.grid-boxes-quote p,
		.grid-boxes-quote p a,
		.grid-boxes-quote span {
			color: #fff;
			font-size: 20px;
			font-weight: 200;
			font-family: "Open Sans";
			text-transform: uppercase;
		}	
		
		.grid-boxes-quote span {
			font-size: 12px;
		}
		*/
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
					<span class="btn-flat settings"></span>
					</div><!--/end container-->
			</div>
			</#if>	
			<!-- START MAIN CONTENT -->
			<div class="container content">			
				<div class="sky-form">
					<fieldset>
						<div class="row">
							<div class="col col-6">
								<section>
									<label class="label"> 소유자</label>
									<div id="my-page-source-list" class="inline-group">
										<label class="radio"><input type="radio" name="radio-inline" value="2"  checked=""><i class="rounded-x"></i> Me</label>
										<label class="radio"><input type="radio" name="radio-inline" value="30" ><i class="rounded-x"></i>  ${action.webSite.displayName}</label>
										<label class="radio"><input type="radio" name="radio-inline" value="1" ><i class="rounded-x"></i>  ${action.webSite.company.displayName}</label>
									</div>
								</section>							
							</div>
							<div class="col col-6 text-right">
								<button type="button" class="btn btn-danger btn-lg btn-outline btn-flat" data-action="create"><span class="btn-label icon fa fa-plus"></span> 새 페이지 만들기 </button>
							</div>
						</div>	
					</fieldset>
				</div>				
				<article class="bg-white animated fadeInUp m-t-md" style="min-height:200px; display:none;">								
					<div class="blog_masonry_3col">					
						<div id="my-page-listview" class="grid-boxes"></div>
					</div>
					<div id="my-page-pager" class="bg-flat-gray p-sm"></div>
				</article>					
			</div>		
			<!-- ./END MAIN CONTENT -->		 		
	 		<!-- START FOOTER -->
			<#include "/html/common/common-homepage-globalfooter.ftl" >		
			<!-- ./END FOOTER -->					
		</div>				
		
		<div id="my-page-viewer" class="dialog dialog-full bg-glass" data-feature="dialog" data-dialog-animate="">
			<div class="dialog__overlay"></div>
			<div class="dialog__content">
			
			
				<div class="container">
					<div class="row">
						<div class="col-sm-12">
<div class="ibox float-e-margins">
                    <div class="ibox-title">
                        <h5>All icons <small class="m-l-sm">All icons in collection - <a target="_blank" href="http://fortawesome.github.io/Font-Awesome/icons/">Font Awesome</a> </small></h5>
                        <div class="ibox-tools">
                            <a class="collapse-link">
                                <i class="fa fa-chevron-up"></i>
                            </a>
                            <a class="dropdown-toggle" data-toggle="dropdown" href="#">
                                <i class="fa fa-wrench"></i>
                            </a>
                            <ul class="dropdown-menu dropdown-user">
                                <li><a href="#">Config option 1</a>
                                </li>
                                <li><a href="#">Config option 2</a>
                                </li>
                            </ul>
                            <a class="close-link">
                                <i class="fa fa-times"></i>
                            </a>
                        </div>
                    </div>
                    <div class="ibox-content icons-box">



                    <div>
                        <h3> New Icons in 4.3.0 </h3>
                        <div class="infont col-md-3 col-sm-4"><a href=""><i class="fa fa-angellist"></i> fa-angellist</a></div>
                        <div class="infont col-md-3 col-sm-4"><a href="../icon/area-chart"><i class="fa fa-area-chart"></i> fa-area-chart</a></div>
                        <div class="infont col-md-3 col-sm-4"><a href=""><i class="fa fa-at"></i> fa-at</a></div>
                        <div class="infont col-md-3 col-sm-4"><a href=""><i class="fa fa-bell-slash"></i> fa-bell-slash</a></div>
                        <div class="infont col-md-3 col-sm-4"><a href=""><i class="fa fa-bell-slash-o"></i> fa-bell-slash-o</a></div>
                        <div class="infont col-md-3 col-sm-4"><a href=""><i class="fa fa-bicycle"></i> fa-bicycle</a></div>
                        <div class="infont col-md-3 col-sm-4"><a href=""><i class="fa fa-binoculars"></i> fa-binoculars</a></div>
                        <div class="infont col-md-3 col-sm-4"><a href=""><i class="fa fa-birthday-cake"></i> fa-birthday-cake</a></div>
                        <div class="infont col-md-3 col-sm-4"><a href=""><i class="fa fa-bus"></i> fa-bus</a></div>
                        <div class="infont col-md-3 col-sm-4"><a href=""><i class="fa fa-calculator"></i> fa-calculator</a></div>
                        <div class="infont col-md-3 col-sm-4"><a href=""><i class="fa fa-cc"></i> fa-cc</a></div>
                        <div class="infont col-md-3 col-sm-4"><a href=""><i class="fa fa-cc-amex"></i> fa-cc-amex</a></div>
                        <div class="infont col-md-3 col-sm-4"><a href=""><i class="fa fa-cc-discover"></i> fa-cc-discover</a></div>
                        <div class="infont col-md-3 col-sm-4"><a href=""><i class="fa fa-cc-mastercard"></i> fa-cc-mastercard</a></div>
                        <div class="infont col-md-3 col-sm-4"><a href=""><i class="fa fa-cc-paypal"></i> fa-cc-paypal</a></div>
                        <div class="infont col-md-3 col-sm-4"><a href=""><i class="fa fa-cc-stripe"></i> fa-cc-stripe</a></div>
                        <div class="infont col-md-3 col-sm-4"><a href=""><i class="fa fa-cc-visa"></i> fa-cc-visa</a></div>
                        <div class="infont col-md-3 col-sm-4"><a href=""><i class="fa fa-copyright"></i> fa-copyright</a></div>
                        <div class="infont col-md-3 col-sm-4"><a href=""><i class="fa fa-eyedropper"></i> fa-eyedropper</a></div>
                        <div class="infont col-md-3 col-sm-4"><a href=""><i class="fa fa-futbol-o"></i> fa-futbol-o</a></div>
                        <div class="infont col-md-3 col-sm-4"><a href=""><i class="fa fa-google-wallet"></i> fa-google-wallet</a></div>
                        <div class="infont col-md-3 col-sm-4"><a href=""><i class="fa fa-ils"></i> fa-ils</a></div>
                        <div class="infont col-md-3 col-sm-4"><a href=""><i class="fa fa-ioxhost"></i> fa-ioxhost</a></div>
                        <div class="infont col-md-3 col-sm-4"><a href=""><i class="fa fa-lastfm"></i> fa-lastfm</a></div>
                        <div class="infont col-md-3 col-sm-4"><a href=""><i class="fa fa-lastfm-square"></i> fa-lastfm-square</a></div>
                        <div class="infont col-md-3 col-sm-4"><a href=""><i class="fa fa-line-chart"></i> fa-line-chart</a></div>
                        <div class="infont col-md-3 col-sm-4"><a href=""><i class="fa fa-meanpath"></i> fa-meanpath</a></div>
                        <div class="infont col-md-3 col-sm-4"><a href=""><i class="fa fa-newspaper-o"></i> fa-newspaper-o</a></div>
                        <div class="infont col-md-3 col-sm-4"><a href=""><i class="fa fa-paint-brush"></i> fa-paint-brush</a></div>
                        <div class="infont col-md-3 col-sm-4"><a href=""><i class="fa fa-paypal"></i> fa-paypal</a></div>
                        <div class="infont col-md-3 col-sm-4"><a href=""><i class="fa fa-pie-chart"></i> fa-pie-chart</a></div>
                        <div class="infont col-md-3 col-sm-4"><a href=""><i class="fa fa-plug"></i> fa-plug</a></div>
                        <div class="infont col-md-3 col-sm-4"><a href=""><i class="fa fa-shekel"></i> fa-shekel <span class="text-muted">(alias)</span></a></div>
                        <div class="infont col-md-3 col-sm-4"><a href=""><i class="fa fa-sheqel"></i> fa-sheqel <span class="text-muted">(alias)</span></a></div>
                        <div class="infont col-md-3 col-sm-4"><a href=""><i class="fa fa-slideshare"></i> fa-slideshare</a></div>
                        <div class="infont col-md-3 col-sm-4"><a href=""><i class="fa fa-soccer-ball-o"></i> fa-soccer-ball-o <span class="text-muted">(alias)</span></a></div>
                        <div class="infont col-md-3 col-sm-4"><a href=""><i class="fa fa-toggle-off"></i> fa-toggle-off</a></div>
                        <div class="infont col-md-3 col-sm-4"><a href=""><i class="fa fa-toggle-on"></i> fa-toggle-on</a></div>
                        <div class="infont col-md-3 col-sm-4"><a href=""><i class="fa fa-trash"></i> fa-trash</a></div>
                        <div class="infont col-md-3 col-sm-4"><a href=""><i class="fa fa-tty"></i> fa-tty</a></div>
                        <div class="infont col-md-3 col-sm-4"><a href=""><i class="fa fa-twitch"></i> fa-twitch</a></div>
                        <div class="infont col-md-3 col-sm-4"><a href=""><i class="fa fa-wifi"></i> fa-wifi</a></div>
                        <div class="infont col-md-3 col-sm-4"><a href=""><i class="fa fa-yelp"></i> fa-yelp</a></div>

                        <div class="clearfix"></div>
                    </div>

                    <div>
                    <h3> New Icons in 4.1.0 </h3>

                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-rub"></i> fa-rub</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-ruble"></i> fa-ruble <span class="text-muted">(alias)</span></a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-rouble"></i> fa-rouble <span class="text-muted">(alias)</span></a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-pagelines"></i> fa-pagelines</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-stack-exchange"></i> fa-stack-exchange</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-arrow-circle-o-right"></i> fa-arrow-circle-o-right</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-arrow-circle-o-left"></i> fa-arrow-circle-o-left</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-caret-square-o-left"></i> fa-caret-square-o-left</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-toggle-left"></i> fa-toggle-left <span class="text-muted">(alias)</span></a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-dot-circle-o"></i> fa-dot-circle-o</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-wheelchair"></i> fa-wheelchair</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-vimeo-square"></i> fa-vimeo-square</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-try"></i> fa-try</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-turkish-lira"></i> fa-turkish-lira <span class="text-muted">(alias)</span></a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-plus-square-o"></i> fa-plus-square-o</a></div>


                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-automobile"></i> fa-automobile <span class="text-muted">(alias)</span></a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-bank"></i> fa-bank <span class="text-muted">(alias)</span></a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-behance"></i> fa-behance</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-behance-square"></i> fa-behance-square</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-bomb"></i> fa-bomb</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-building"></i> fa-building</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-cab"></i> fa-cab <span class="text-muted">(alias)</span></a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-car"></i> fa-car</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-child"></i> fa-child</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-circle-o-notch"></i> fa-circle-o-notch</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-circle-thin"></i> fa-circle-thin</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-codepen"></i> fa-codepen</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-cube"></i> fa-cube</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-cubes"></i> fa-cubes</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-database"></i> fa-database</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-delicious"></i> fa-delicious</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-deviantart"></i> fa-deviantart</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-digg"></i> fa-digg</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-drupal"></i> fa-drupal</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-empire"></i> fa-empire</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-envelope-square"></i> fa-envelope-square</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-fax"></i> fa-fax</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-file-archive-o"></i> fa-file-archive-o</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-file-audio-o"></i> fa-file-audio-o</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-file-code-o"></i> fa-file-code-o</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-file-excel-o"></i> fa-file-excel-o</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-file-image-o"></i> fa-file-image-o</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-file-movie-o"></i> fa-file-movie-o <span class="text-muted">(alias)</span></a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-file-pdf-o"></i> fa-file-pdf-o</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-file-photo-o"></i> fa-file-photo-o <span class="text-muted">(alias)</span></a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-file-picture-o"></i> fa-file-picture-o <span class="text-muted">(alias)</span></a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-file-powerpoint-o"></i> fa-file-powerpoint-o</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-file-sound-o"></i> fa-file-sound-o <span class="text-muted">(alias)</span></a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-file-video-o"></i> fa-file-video-o</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-file-word-o"></i> fa-file-word-o</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-file-zip-o"></i> fa-file-zip-o <span class="text-muted">(alias)</span></a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-ge"></i> fa-ge <span class="text-muted">(alias)</span></a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-git"></i> fa-git</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-git-square"></i> fa-git-square</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-google"></i> fa-google</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-graduation-cap"></i> fa-graduation-cap</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-hacker-news"></i> fa-hacker-news</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-header"></i> fa-header</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-history"></i> fa-history</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-institution"></i> fa-institution <span class="text-muted">(alias)</span></a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-joomla"></i> fa-joomla</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-jsfiddle"></i> fa-jsfiddle</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-language"></i> fa-language</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-life-bouy"></i> fa-life-bouy <span class="text-muted">(alias)</span></a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-life-ring"></i> fa-life-ring</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-life-saver"></i> fa-life-saver <span class="text-muted">(alias)</span></a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-mortar-board"></i> fa-mortar-board <span class="text-muted">(alias)</span></a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-openid"></i> fa-openid</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-paper-plane"></i> fa-paper-plane</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-paper-plane-o"></i> fa-paper-plane-o</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-paragraph"></i> fa-paragraph</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-paw"></i> fa-paw</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-pied-piper"></i> fa-pied-piper</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-pied-piper-alt"></i> fa-pied-piper-alt</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-pied-piper-square"></i> fa-pied-piper-square <span class="text-muted">(alias)</span></a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-qq"></i> fa-qq</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-ra"></i> fa-ra <span class="text-muted">(alias)</span></a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-rebel"></i> fa-rebel</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-recycle"></i> fa-recycle</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-reddit"></i> fa-reddit</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-reddit-square"></i> fa-reddit-square</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-send"></i> fa-send <span class="text-muted">(alias)</span></a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-send-o"></i> fa-send-o <span class="text-muted">(alias)</span></a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-share-alt"></i> fa-share-alt</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-share-alt-square"></i> fa-share-alt-square</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-slack"></i> fa-slack</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-sliders"></i> fa-sliders</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-soundcloud"></i> fa-soundcloud</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-space-shuttle"></i> fa-space-shuttle</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-spoon"></i> fa-spoon</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-spotify"></i> fa-spotify</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-steam"></i> fa-steam</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-steam-square"></i> fa-steam-square</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-stumbleupon"></i> fa-stumbleupon</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-stumbleupon-circle"></i> fa-stumbleupon-circle</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-support"></i> fa-support <span class="text-muted">(alias)</span></a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-taxi"></i> fa-taxi</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-tencent-weibo"></i> fa-tencent-weibo</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-tree"></i> fa-tree</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-university"></i> fa-university</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-vine"></i> fa-vine</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-wechat"></i> fa-wechat <span class="text-muted">(alias)</span></a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-weixin"></i> fa-weixin</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-wordpress"></i> fa-wordpress</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-yahoo"></i> fa-yahoo</a></div>

                    <div class="clearfix"></div>
                    </div>
                    <div>
                    <h3>Web Application Icons</h3>

                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-adjust"></i> fa-adjust</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-anchor"></i> fa-anchor</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-archive"></i> fa-archive</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-arrows"></i> fa-arrows</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-arrows-h"></i> fa-arrows-h</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-arrows-v"></i> fa-arrows-v</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-asterisk"></i> fa-asterisk</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-ban"></i> fa-ban</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-bar-chart-o"></i> fa-bar-chart-o</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-barcode"></i> fa-barcode</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-bars"></i> fa-bars</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-beer"></i> fa-beer</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-bell"></i> fa-bell</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-bell-o"></i> fa-bell-o</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-bolt"></i> fa-bolt</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-book"></i> fa-book</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-bookmark"></i> fa-bookmark</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-bookmark-o"></i> fa-bookmark-o</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-briefcase"></i> fa-briefcase</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-bug"></i> fa-bug</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-building-o"></i> fa-building-o</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-bullhorn"></i> fa-bullhorn</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-bullseye"></i> fa-bullseye</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-calendar"></i> fa-calendar</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-calendar-o"></i> fa-calendar-o</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-camera"></i> fa-camera</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-camera-retro"></i> fa-camera-retro</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-caret-square-o-down"></i> fa-caret-square-o-down</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-caret-square-o-left"></i> fa-caret-square-o-left</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-caret-square-o-right"></i> fa-caret-square-o-right</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-caret-square-o-up"></i> fa-caret-square-o-up</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-certificate"></i> fa-certificate</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-check"></i> fa-check</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-check-circle"></i> fa-check-circle</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-check-circle-o"></i> fa-check-circle-o</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-check-square"></i> fa-check-square</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-check-square-o"></i> fa-check-square-o</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-circle"></i> fa-circle</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-circle-o"></i> fa-circle-o</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-clock-o"></i> fa-clock-o</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-cloud"></i> fa-cloud</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-cloud-download"></i> fa-cloud-download</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-cloud-upload"></i> fa-cloud-upload</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-code"></i> fa-code</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-code-fork"></i> fa-code-fork</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-coffee"></i> fa-coffee</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-cog"></i> fa-cog</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-cogs"></i> fa-cogs</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-comment"></i> fa-comment</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-comment-o"></i> fa-comment-o</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-comments"></i> fa-comments</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-comments-o"></i> fa-comments-o</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-compass"></i> fa-compass</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-credit-card"></i> fa-credit-card</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-crop"></i> fa-crop</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-crosshairs"></i> fa-crosshairs</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-cutlery"></i> fa-cutlery</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-dashboard"></i> fa-dashboard <span class="text-muted">(alias)</span></a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-desktop"></i> fa-desktop</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-dot-circle-o"></i> fa-dot-circle-o</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-download"></i> fa-download</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-edit"></i> fa-edit <span class="text-muted">(alias)</span></a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-ellipsis-h"></i> fa-ellipsis-h</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-ellipsis-v"></i> fa-ellipsis-v</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-envelope"></i> fa-envelope</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-envelope-o"></i> fa-envelope-o</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-eraser"></i> fa-eraser</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-exchange"></i> fa-exchange</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-exclamation"></i> fa-exclamation</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-exclamation-circle"></i> fa-exclamation-circle</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-exclamation-triangle"></i> fa-exclamation-triangle</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-external-link"></i> fa-external-link</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-external-link-square"></i> fa-external-link-square</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-eye"></i> fa-eye</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-eye-slash"></i> fa-eye-slash</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-female"></i> fa-female</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-fighter-jet"></i> fa-fighter-jet</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-film"></i> fa-film</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-filter"></i> fa-filter</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-fire"></i> fa-fire</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-fire-extinguisher"></i> fa-fire-extinguisher</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-flag"></i> fa-flag</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-flag-checkered"></i> fa-flag-checkered</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-flag-o"></i> fa-flag-o</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-flash"></i> fa-flash <span class="text-muted">(alias)</span></a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-flask"></i> fa-flask</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-folder"></i> fa-folder</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-folder-o"></i> fa-folder-o</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-folder-open"></i> fa-folder-open</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-folder-open-o"></i> fa-folder-open-o</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-frown-o"></i> fa-frown-o</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-gamepad"></i> fa-gamepad</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-gavel"></i> fa-gavel</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-gear"></i> fa-gear <span class="text-muted">(alias)</span></a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-gears"></i> fa-gears <span class="text-muted">(alias)</span></a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-gift"></i> fa-gift</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-glass"></i> fa-glass</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-globe"></i> fa-globe</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-group"></i> fa-group <span class="text-muted">(alias)</span></a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-hdd-o"></i> fa-hdd-o</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-headphones"></i> fa-headphones</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-heart"></i> fa-heart</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-heart-o"></i> fa-heart-o</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-home"></i> fa-home</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-inbox"></i> fa-inbox</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-info"></i> fa-info</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-info-circle"></i> fa-info-circle</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-key"></i> fa-key</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-keyboard-o"></i> fa-keyboard-o</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-laptop"></i> fa-laptop</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-leaf"></i> fa-leaf</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-legal"></i> fa-legal <span class="text-muted">(alias)</span></a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-lemon-o"></i> fa-lemon-o</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-level-down"></i> fa-level-down</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-level-up"></i> fa-level-up</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-lightbulb-o"></i> fa-lightbulb-o</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-location-arrow"></i> fa-location-arrow</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-lock"></i> fa-lock</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-magic"></i> fa-magic</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-magnet"></i> fa-magnet</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-mail-forward"></i> fa-mail-forward <span class="text-muted">(alias)</span></a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-mail-reply"></i> fa-mail-reply <span class="text-muted">(alias)</span></a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-mail-reply-all"></i> fa-mail-reply-all</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-male"></i> fa-male</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-map-marker"></i> fa-map-marker</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-meh-o"></i> fa-meh-o</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-microphone"></i> fa-microphone</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-microphone-slash"></i> fa-microphone-slash</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-minus"></i> fa-minus</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-minus-circle"></i> fa-minus-circle</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-minus-square"></i> fa-minus-square</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-minus-square-o"></i> fa-minus-square-o</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-mobile"></i> fa-mobile</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-mobile-phone"></i> fa-mobile-phone <span class="text-muted">(alias)</span></a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-money"></i> fa-money</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-moon-o"></i> fa-moon-o</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-music"></i> fa-music</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-pencil"></i> fa-pencil</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-pencil-square"></i> fa-pencil-square</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-pencil-square-o"></i> fa-pencil-square-o</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-phone"></i> fa-phone</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-phone-square"></i> fa-phone-square</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-picture-o"></i> fa-picture-o</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-plane"></i> fa-plane</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-plus"></i> fa-plus</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-plus-circle"></i> fa-plus-circle</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-plus-square"></i> fa-plus-square</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-plus-square-o"></i> fa-plus-square-o</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-power-off"></i> fa-power-off</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-print"></i> fa-print</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-puzzle-piece"></i> fa-puzzle-piece</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-qrcode"></i> fa-qrcode</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-question"></i> fa-question</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-question-circle"></i> fa-question-circle</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-quote-left"></i> fa-quote-left</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-quote-right"></i> fa-quote-right</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-random"></i> fa-random</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-refresh"></i> fa-refresh</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-reply"></i> fa-reply</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-reply-all"></i> fa-reply-all</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-retweet"></i> fa-retweet</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-road"></i> fa-road</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-rocket"></i> fa-rocket</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-rss"></i> fa-rss</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-rss-square"></i> fa-rss-square</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-search"></i> fa-search</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-search-minus"></i> fa-search-minus</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-search-plus"></i> fa-search-plus</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-share"></i> fa-share</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-share-square"></i> fa-share-square</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-share-square-o"></i> fa-share-square-o</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-shield"></i> fa-shield</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-shopping-cart"></i> fa-shopping-cart</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-sign-in"></i> fa-sign-in</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-sign-out"></i> fa-sign-out</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-signal"></i> fa-signal</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-sitemap"></i> fa-sitemap</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-smile-o"></i> fa-smile-o</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-sort"></i> fa-sort</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-sort-alpha-asc"></i> fa-sort-alpha-asc</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-sort-alpha-desc"></i> fa-sort-alpha-desc</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-sort-amount-asc"></i> fa-sort-amount-asc</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-sort-amount-desc"></i> fa-sort-amount-desc</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-sort-asc"></i> fa-sort-asc</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-sort-desc"></i> fa-sort-desc</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-sort-down"></i> fa-sort-down <span class="text-muted">(alias)</span></a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-sort-numeric-asc"></i> fa-sort-numeric-asc</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-sort-numeric-desc"></i> fa-sort-numeric-desc</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-sort-up"></i> fa-sort-up <span class="text-muted">(alias)</span></a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-spinner"></i> fa-spinner</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-square"></i> fa-square</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-square-o"></i> fa-square-o</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-star"></i> fa-star</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-star-half"></i> fa-star-half</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-star-half-empty"></i> fa-star-half-empty <span class="text-muted">(alias)</span></a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-star-half-full"></i> fa-star-half-full <span class="text-muted">(alias)</span></a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-star-half-o"></i> fa-star-half-o</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-star-o"></i> fa-star-o</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-subscript"></i> fa-subscript</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-suitcase"></i> fa-suitcase</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-sun-o"></i> fa-sun-o</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-superscript"></i> fa-superscript</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-tablet"></i> fa-tablet</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-tachometer"></i> fa-tachometer</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-tag"></i> fa-tag</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-tags"></i> fa-tags</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-tasks"></i> fa-tasks</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-terminal"></i> fa-terminal</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-thumb-tack"></i> fa-thumb-tack</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-thumbs-down"></i> fa-thumbs-down</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-thumbs-o-down"></i> fa-thumbs-o-down</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-thumbs-o-up"></i> fa-thumbs-o-up</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-thumbs-up"></i> fa-thumbs-up</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-ticket"></i> fa-ticket</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-times"></i> fa-times</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-times-circle"></i> fa-times-circle</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-times-circle-o"></i> fa-times-circle-o</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-tint"></i> fa-tint</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-toggle-down"></i> fa-toggle-down <span class="text-muted">(alias)</span></a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-toggle-left"></i> fa-toggle-left <span class="text-muted">(alias)</span></a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-toggle-right"></i> fa-toggle-right <span class="text-muted">(alias)</span></a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-toggle-up"></i> fa-toggle-up <span class="text-muted">(alias)</span></a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-trash-o"></i> fa-trash-o</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-trophy"></i> fa-trophy</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-truck"></i> fa-truck</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-umbrella"></i> fa-umbrella</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-unlock"></i> fa-unlock</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-unlock-alt"></i> fa-unlock-alt</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-unsorted"></i> fa-unsorted <span class="text-muted">(alias)</span></a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-upload"></i> fa-upload</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-user"></i> fa-user</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-users"></i> fa-users</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-video-camera"></i> fa-video-camera</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-volume-down"></i> fa-volume-down</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-volume-off"></i> fa-volume-off</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-volume-up"></i> fa-volume-up</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-warning"></i> fa-warning <span class="text-muted">(alias)</span></a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-wheelchair"></i> fa-wheelchair</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-wrench"></i> fa-wrench</a></div>
                    <div class="clearfix"></div>
                    </div>
                    <div>
                    <h3>Form Control Icons</h3>

                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-check-square"></i> fa-check-square</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-check-square-o"></i> fa-check-square-o</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-circle"></i> fa-circle</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-circle-o"></i> fa-circle-o</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-dot-circle-o"></i> fa-dot-circle-o</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-minus-square"></i> fa-minus-square</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-minus-square-o"></i> fa-minus-square-o</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-plus-square"></i> fa-plus-square</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-plus-square-o"></i> fa-plus-square-o</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-square"></i> fa-square</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-square-o"></i> fa-square-o</a></div>
                        <div class="clearfix"></div>
                    </div>
                    <div>
                    <h3>Currency Icons</h3>

                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-bitcoin"></i> fa-bitcoin <span class="text-muted">(alias)</span></a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-btc"></i> fa-btc</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-cny"></i> fa-cny <span class="text-muted">(alias)</span></a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-dollar"></i> fa-dollar <span class="text-muted">(alias)</span></a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-eur"></i> fa-eur</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-euro"></i> fa-euro <span class="text-muted">(alias)</span></a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-gbp"></i> fa-gbp</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-inr"></i> fa-inr</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-jpy"></i> fa-jpy</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-krw"></i> fa-krw</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-money"></i> fa-money</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-rmb"></i> fa-rmb <span class="text-muted">(alias)</span></a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-rouble"></i> fa-rouble <span class="text-muted">(alias)</span></a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-rub"></i> fa-rub</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-ruble"></i> fa-ruble <span class="text-muted">(alias)</span></a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-rupee"></i> fa-rupee <span class="text-muted">(alias)</span></a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-try"></i> fa-try</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-turkish-lira"></i> fa-turkish-lira <span class="text-muted">(alias)</span></a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-usd"></i> fa-usd</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-won"></i> fa-won <span class="text-muted">(alias)</span></a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-yen"></i> fa-yen <span class="text-muted">(alias)</span></a></div>
                        <div class="clearfix"></div>
                    </div>
                    <div>
                    <h3>Text Editor Icons</h3>

                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-align-center"></i> fa-align-center</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-align-justify"></i> fa-align-justify</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-align-left"></i> fa-align-left</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-align-right"></i> fa-align-right</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-bold"></i> fa-bold</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-chain"></i> fa-chain <span class="text-muted">(alias)</span></a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-chain-broken"></i> fa-chain-broken</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-clipboard"></i> fa-clipboard</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-columns"></i> fa-columns</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-copy"></i> fa-copy <span class="text-muted">(alias)</span></a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-cut"></i> fa-cut <span class="text-muted">(alias)</span></a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-dedent"></i> fa-dedent <span class="text-muted">(alias)</span></a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-eraser"></i> fa-eraser</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-file"></i> fa-file</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-file-o"></i> fa-file-o</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-file-text"></i> fa-file-text</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-file-text-o"></i> fa-file-text-o</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-files-o"></i> fa-files-o</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-floppy-o"></i> fa-floppy-o</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-font"></i> fa-font</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-indent"></i> fa-indent</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-italic"></i> fa-italic</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-link"></i> fa-link</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-list"></i> fa-list</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-list-alt"></i> fa-list-alt</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-list-ol"></i> fa-list-ol</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-list-ul"></i> fa-list-ul</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-outdent"></i> fa-outdent</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-paperclip"></i> fa-paperclip</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-paste"></i> fa-paste <span class="text-muted">(alias)</span></a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-repeat"></i> fa-repeat</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-rotate-left"></i> fa-rotate-left <span class="text-muted">(alias)</span></a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-rotate-right"></i> fa-rotate-right <span class="text-muted">(alias)</span></a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-save"></i> fa-save <span class="text-muted">(alias)</span></a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-scissors"></i> fa-scissors</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-strikethrough"></i> fa-strikethrough</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-table"></i> fa-table</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-text-height"></i> fa-text-height</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-text-width"></i> fa-text-width</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-th"></i> fa-th</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="index.html"><i class="fa fa-th-large"></i> fa-th-large</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-th-list"></i> fa-th-list</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-underline"></i> fa-underline</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-undo"></i> fa-undo</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-unlink"></i> fa-unlink <span class="text-muted">(alias)</span></a></div>
                        <div class="clearfix"></div>
                    </div>
                    <div>
                    <h3>Directional Icons</h3>

                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-angle-double-down"></i> fa-angle-double-down</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-angle-double-left"></i> fa-angle-double-left</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-angle-double-right"></i> fa-angle-double-right</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-angle-double-up"></i> fa-angle-double-up</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-angle-down"></i> fa-angle-down</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-angle-left"></i> fa-angle-left</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-angle-right"></i> fa-angle-right</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-angle-up"></i> fa-angle-up</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-arrow-circle-down"></i> fa-arrow-circle-down</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-arrow-circle-left"></i> fa-arrow-circle-left</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-arrow-circle-o-down"></i> fa-arrow-circle-o-down</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-arrow-circle-o-left"></i> fa-arrow-circle-o-left</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-arrow-circle-o-right"></i> fa-arrow-circle-o-right</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-arrow-circle-o-up"></i> fa-arrow-circle-o-up</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-arrow-circle-right"></i> fa-arrow-circle-right</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-arrow-circle-up"></i> fa-arrow-circle-up</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-arrow-down"></i> fa-arrow-down</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-arrow-left"></i> fa-arrow-left</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-arrow-right"></i> fa-arrow-right</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-arrow-up"></i> fa-arrow-up</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-arrows"></i> fa-arrows</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-arrows-alt"></i> fa-arrows-alt</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-arrows-h"></i> fa-arrows-h</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-arrows-v"></i> fa-arrows-v</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-caret-down"></i> fa-caret-down</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-caret-left"></i> fa-caret-left</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-caret-right"></i> fa-caret-right</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-caret-square-o-down"></i> fa-caret-square-o-down</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-caret-square-o-left"></i> fa-caret-square-o-left</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-caret-square-o-right"></i> fa-caret-square-o-right</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-caret-square-o-up"></i> fa-caret-square-o-up</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-caret-up"></i> fa-caret-up</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-chevron-circle-down"></i> fa-chevron-circle-down</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-chevron-circle-left"></i> fa-chevron-circle-left</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-chevron-circle-right"></i> fa-chevron-circle-right</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-chevron-circle-up"></i> fa-chevron-circle-up</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-chevron-down"></i> fa-chevron-down</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-chevron-left"></i> fa-chevron-left</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-chevron-right"></i> fa-chevron-right</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-chevron-up"></i> fa-chevron-up</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-hand-o-down"></i> fa-hand-o-down</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-hand-o-left"></i> fa-hand-o-left</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-hand-o-right"></i> fa-hand-o-right</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-hand-o-up"></i> fa-hand-o-up</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-long-arrow-down"></i> fa-long-arrow-down</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-long-arrow-left"></i> fa-long-arrow-left</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-long-arrow-right"></i> fa-long-arrow-right</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-long-arrow-up"></i> fa-long-arrow-up</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-toggle-down"></i> fa-toggle-down <span class="text-muted">(alias)</span></a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-toggle-left"></i> fa-toggle-left <span class="text-muted">(alias)</span></a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-toggle-right"></i> fa-toggle-right <span class="text-muted">(alias)</span></a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-toggle-up"></i> fa-toggle-up <span class="text-muted">(alias)</span></a></div>
                        <div class="clearfix"></div>
                    </div>
                    <div>
                    <h3>Video Player Icons</h3>

                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-arrows-alt"></i> fa-arrows-alt</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-backward"></i> fa-backward</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-compress"></i> fa-compress</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-eject"></i> fa-eject</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-expand"></i> fa-expand</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-fast-backward"></i> fa-fast-backward</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-fast-forward"></i> fa-fast-forward</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-forward"></i> fa-forward</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-pause"></i> fa-pause</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-play"></i> fa-play</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-play-circle"></i> fa-play-circle</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-play-circle-o"></i> fa-play-circle-o</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-step-backward"></i> fa-step-backward</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-step-forward"></i> fa-step-forward</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-stop"></i> fa-stop</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-youtube-play"></i> fa-youtube-play</a></div>
                        <div class="clearfix"></div>
                    </div>
                    <div>
                    <h3>Brand Icons</h3>

                    <div class="alert alert-success">
                        <ul class="margin-bottom-none padding-left-lg">
                            <li>All brand icons are trademarks of their respective owners.</li>
                            <li>The use of these trademarks does not indicate endorsement of the trademark holder by Font Awesome, nor vice versa.</li>
                        </ul>
                    </div>

                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-adn"></i> fa-adn</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-android"></i> fa-android</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-apple"></i> fa-apple</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-bitbucket"></i> fa-bitbucket</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-bitbucket-square"></i> fa-bitbucket-square</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-bitcoin"></i> fa-bitcoin <span class="text-muted">(alias)</span></a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-btc"></i> fa-btc</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-css3"></i> fa-css3</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-dribbble"></i> fa-dribbble</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-dropbox"></i> fa-dropbox</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-facebook"></i> fa-facebook</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-facebook-square"></i> fa-facebook-square</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-flickr"></i> fa-flickr</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-foursquare"></i> fa-foursquare</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-github"></i> fa-github</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-github-alt"></i> fa-github-alt</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-github-square"></i> fa-github-square</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-gittip"></i> fa-gittip</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-google-plus"></i> fa-google-plus</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-google-plus-square"></i> fa-google-plus-square</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-html5"></i> fa-html5</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-instagram"></i> fa-instagram</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-linkedin"></i> fa-linkedin</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-linkedin-square"></i> fa-linkedin-square</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-linux"></i> fa-linux</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-maxcdn"></i> fa-maxcdn</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-pagelines"></i> fa-pagelines</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-pinterest"></i> fa-pinterest</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-pinterest-square"></i> fa-pinterest-square</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-renren"></i> fa-renren</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-skype"></i> fa-skype</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-stack-exchange"></i> fa-stack-exchange</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-stack-overflow"></i> fa-stack-overflow</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-trello"></i> fa-trello</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-tumblr"></i> fa-tumblr</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-tumblr-square"></i> fa-tumblr-square</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-twitter"></i> fa-twitter</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-twitter-square"></i> fa-twitter-square</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-vimeo-square"></i> fa-vimeo-square</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-vk"></i> fa-vk</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-weibo"></i> fa-weibo</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-windows"></i> fa-windows</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-xing"></i> fa-xing</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-xing-square"></i> fa-xing-square</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-youtube"></i> fa-youtube</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-youtube-play"></i> fa-youtube-play</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-youtube-square"></i> fa-youtube-square</a></div>
                        <div class="clearfix"></div>
                    </div>
                    <div>
                    <h3>Medical Icons</h3>

                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-ambulance"></i> fa-ambulance</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-h-square"></i> fa-h-square</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-hospital-o"></i> fa-hospital-o</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-medkit"></i> fa-medkit</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-plus-square"></i> fa-plus-square</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-stethoscope"></i> fa-stethoscope</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-user-md"></i> fa-user-md</a></div>
                    <div class="infont col-md-3 col-sm-4"><a href="#"><i class="fa fa-wheelchair"></i> fa-wheelchair</a></div>
                        <div class="clearfix"></div>
                    </div>
                    </div>
                </div>
                
                			
			
									<div class="sky-form bg-white rounded">
										<header>
											<span data-bind="{text: page.title}"></span>( <span data-bind="text: page.name"></span>)
											<span class="btn-flat settings2" data-dialog-options data-bind="visible:editable"></span>
											<span class="close" data-dialog-close></span>						
										</header>										
										<article data-bind="{html:page.bodyContent.bodyText, invisible:editable}" class="p-md bg-white text-md"></article>
										<div data-bind="visible:editable">
										<fieldset class="bg-gray padding-sm">										
											<section>
												<label for="title" class="input">
													<input type="text" name="title" placeholder="제목" data-bind="value: page.title">
												</label>
											</section>	
											<div class="row">
												<div class="col-md-6">
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
														<section>
															<label for="summary" class="textarea">
																<textarea rows="3" name="summary" placeholder="요약" data-bind="value: page.summary"></textarea>
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
										<fieldset>			
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
											<button type="button" class="btn-u btn-u-blue btn-u-small" data-bind="events:{click:update}" data-loading-text="<i class='fa fa-spinner fa-spin'></i>">저장</button> 
											<button class="btn-u btn-u-default btn-u-small action-refresh" data-bind="click:refresh"> 새로고침 </button>					
										</footer>
										</div> 
									</div>	
						</div>
					</div>					
				</div>				
			</div>
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
	<script id="my-page-listview-template" type="text/x-kendo-template">
	<!--<div class="grid-boxes-in col-md-4 col-sm-6 col-xs-12">-->
	<div class="grid-boxes-in">
		#if( bodyContent.imageCount > 0 ){#
		<img class="img-responsive #if(pageState ===  'DELETED' ){# grayscale #}#" src="#=bodyContent.firstImageSrc#" alt="">
		#}#
		<div class="grid-boxes-caption">
			#if ( pageState === "PUBLISHED" ) { #<span class="label label-success">#: pageState #</span>#}else if( pageState === "DELETED" ) {# <span class="label label-default">#: pageState #</span> #}else{# <span class="label label-danger">#: pageState #</span> #}#
			#if( pageState !=  'DELETED' ){#<h2><a href="\\#" data-action="view" data-object-id="#=pageId#">#:title#</a></h2>#}else{#
			<h2 class="text-muted">#:title#</a></h2>
			#}#
			<ul class="list-inline grid-boxes-news">
				<li><span>By</span> #if (user.nameVisible){ # #:user.name#  #}# <code>#:user.username#</code></li>
				<li>|</li>
				<li><i class="fa fa-clock-o"></i> #:formattedCreationDate() #</li>
			</ul>                    
			<p>#: summary #</p>
				<div class="navbar-btn">
					<div class="btn-group">				
						#if( pageState !=  'DELETED' ){#
						<button class="btn btn-info btn-flat btn-outline rounded-left" data-action="edit" data-object-id="#=pageId#"> 편집</button>
						#}#
						#if( pageState === 'PUBLISHED' ){#
						<button class="btn btn-info btn-flat btn-outline" data-action="share" data-object-id="#=pageId#" data-loading-text="<i class='fa fa-spinner fa-spin'></i>"> 공유</button>		
						#}else{#
							#if( pageState != 'DELETED'){# 
							<button class="btn btn-info btn-flat btn-outline" data-action="publish" data-object-id="#=pageId#" data-loading-text="<i class='fa fa-spinner fa-spin'></i>"> 게시</button>
							#}#						
						#}#
					</div>				
					#if( pageState ===  'DELETED' ){#						
					<button class="btn btn-default btn-flat btn-outline rounded" data-action="restore" data-object-id="#=pageId#" data-loading-text="<i class='fa fa-spinner fa-spin'></i>">임시저장 이동</button>		
					#}else{#
					<button class="btn btn-danger btn-flat btn-outline rounded-right" data-action="delete" data-object-id="#=pageId#" data-loading-text="<i class='fa fa-spinner fa-spin'></i>">삭제</button>		
					#}#			
				</div>			
		</div>
	</div>
	</script>
	<script id="webpage-title-template" type="text/x-kendo-template">
		#: title #</span>
		<div class="btn-group btn-group-xs pull-right">
			<a href="\\#" onclick="doPageEdit(); return false;" class="btn btn-info btn-sm">편집</a>
			<a href="\\#" onclick="doPageDelete(); return false;" class="btn btn-info btn-sm">삭제</a>
			<a href="\\#" onclick="doPagePreview(); return false;" class="btn btn-info btn-sm">미리보기</a>
		</div>	
	</script>																				
	<#include "/html/common/common-homepage-templates.ftl" >		
	<#include "/html/common/common-personalized-templates.ftl" >
	<#include "/html/common/common-editor-templates.ftl" >	
	<!-- ./END TEMPLATE -->
	</body>    
</html>