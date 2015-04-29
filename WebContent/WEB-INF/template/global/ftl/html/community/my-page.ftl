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
			'css!<@spring.url "/styles/common.pages/common.personalized.css"/>',			
			'css!<@spring.url "/styles/codrops/codrops.cbp-spmenu.css"/>',
			'css!<@spring.url "/styles/codrops/codrops.morphing.css"/>',	
			'css!<@spring.url "/styles/codrops/codrops.page-transitions.css"/>',						
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
		function getMyPageSource(){
			return $("#my-page-source-list input[type=radio][name=radio-inline]:checked").val();			
		}
	
		function masonry(){

			$(".grid-boxes").imagesLoaded( function(e){		
		
				var renderTo = $(".grid-boxes");			
				var gutter = 30;
				var min_width = 300;			
				var box_width = (((renderTo.width() - 2*gutter)/3) | 0); 
						if (box_width < min_width) {
							box_width = (((renderTo.width() - gutter)/2) | 0);
						}
						if (box_width < min_width) {
							box_width = renderTo.width();
						}
						renderTo.find('.grid-boxes-in').width(box_width);
									
			
//			


				renderTo.masonry({
					itemSelector : ".grid-boxes-in",
					isFitWidth : true,
					gutterWidth: gutter,
					columnWidth : box_width,
/*					
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
					},
*/					
					animate: true,
					animationOptions: {
						duration: 700,
						queue: true
					}			
				
				});
	
			});	
		}
	
		function createMyPageListView(){
		
			var renderTo = $("#my-page-listview");
			/*
			var template =kendo.template($("#my-page-listview-template").html());
			var dataSource = new kendo.data.DataSource({
						serverFiltering: false,
						transport: { 
							read: { url:'<@spring.url "/data/pages/list.json?output=json"/>', type: 'POST' },
							parameterMap: function (options, type){
								return { startIndex: options.skip, pageSize: options.pageSize,  objectType: getMyPageSource() }
							}
						},
						schema: {
							total: "totalCount",
							data: "pages",
							model: common.ui.data.Page
						},
						error:common.ui.handleAjaxError,
						batch: false,
						pageSize: 15,
						serverPaging: true,
						serverFiltering: false,
						serverSorting: false,
						change: function() {
							renderTo.html(kendo.render(template, this.view()));		
						
						}
			});
			
			
			
				$("#my-page-source-list input[type=radio][name=radio-inline]").on("change", function () {
					dataSource.read();	
				});	
			*/
			
			if( !common.ui.exists( renderTo ) ){
				common.ui.listview( renderTo, {
					dataSource: {
						serverFiltering: false,
						transport: { 
							read: { url:'<@spring.url "/data/pages/list.json?output=json"/>', type: 'POST' },
							parameterMap: function (options, type){
								return { startIndex: options.skip, pageSize: options.pageSize,  objectType: getMyPageSource() }
							}
						},
						schema: {
							total: "totalCount",
							data: "pages",
							model: common.ui.data.Page
						},
						error:common.ui.handleAjaxError,
						batch: false,
						pageSize: 15,
						serverPaging: true,
						serverFiltering: false,
						serverSorting: false
					},
					template: kendo.template($("#my-page-listview-template").html()),
					dataBound: function(e){
						
					}
				});		
				renderTo.removeClass("k-widget k-listview");				
				common.ui.pager($("#my-page-pager"), {
					dataSource: common.ui.listview(renderTo).dataSource
				});		
				$("#my-page-source-list input[type=radio][name=radio-inline]").on("change", function () {
					common.ui.listview(renderTo).dataSource.read();	
				});					
			}
			
			if( $("article.bg-white").is(":hidden") ){
				$("article.bg-white").show();
			} 		
			
			
		}
		
		
				
		function createPageSection(){
			var renderTo = $("#my-page-grid");
			common.ui.grid( renderTo, {
				dataSource: {
					serverFiltering: false,
					transport: { 
						read: { url:'/data/pages/list.json?output=json', type: 'POST' },
						parameterMap: function (options, type){
							return { startIndex: options.skip, pageSize: options.pageSize,  objectType: getMyPageSource() }
						}
					},
					schema: {
						total: "totalCount",
						data: "pages",
						model: common.ui.data.Page
					},
					error:common.ui.handleAjaxError,
					batch: false,
					pageSize: 15,
					serverPaging: true,
					serverFiltering: false,
					serverSorting: false
				},
				columns: [
					{ field: "pageId", title: "ID", width:50,  filterable: false, sortable: false , headerAttributes: { "class": "table-header-cell", style: "text-align: center" }}, 
					{ field: "name", title: "이름", width: 100, headerAttributes: { "class": "table-header-cell", style: "text-align: center"}}, 
					{ field: "title", title: "제목", width: 350 , headerAttributes: { "class": "table-header-cell", style: "text-align: center" }, template: $('#webpage-title-template').html() }, 
					{ field: "versionId", title: "버전", width: 80, headerAttributes: { "class": "table-header-cell", style: "text-align: center" } },
					{ field: "pageState", title: "상태", width: 120, headerAttributes: { "class": "table-header-cell", style: "text-align: center" }, template: '#if ( pageState === "PUBLISHED" ) { #<span class="label label-success">#: pageState #</span>#}else{# <span class="label label-danger">#: pageState #</span> #}#'},
					{ field: "user.username", title: "작성자", width: 100, headerAttributes: { "class": "table-header-cell", style: "text-align: center" }, template:'#if ( user.nameVisible ) {# #: user.name # #} else{ # #: user.username # #}#' },
					{ field: "creationDate",  title: "생성일", width: 120,  format:"{0:yyyy.MM.dd}", headerAttributes: { "class": "table-header-cell", style: "text-align: center" } },
					{ field: "modifiedDate", title: "수정일", width: 120,  format:"{0:yyyy.MM.dd}", headerAttributes: { "class": "table-header-cell", style: "text-align: center" } } ],
				filterable: true,
				sortable: true,
				resizable: true,
				pageable: { refresh:true, pageSizes:false,  messages: { display: ' {1} / {2}' }  },
				selectable: 'row',
				height: '100%',
				change: function(e) {                    
					var selectedCells = this.select();                 
					if( selectedCells.length > 0){ 
						var selectedCell = this.dataItem( selectedCells ); 
 					} 						
				},
				dataBound: function(e){		
					$("button.btn-page-control-group").attr("disabled", "disabled");
				}			
			} );		
			
			$("#page-source-list input[type=radio][name=page-source]").on("change", function () {
					common.ui.grid(renderTo).dataSource.read();	
			});				
			
			$("button[data-action=page-create]").click(function(e){
				createNewPage();
			});
			
			$("#my-page-view span.back").click(function(e){
				$("#my-page").removeClass("in");
				$("#my-page").one( "webkitAnimationEnd oanimationend msAnimationEnd animationend", function(e) {
					$("#my-page").removeClass("compose out");
				});	
				$("#my-page").addClass("out");
			});
		}

		function createNewPage(){
			var page = new common.ui.data.Page();
			page.objectType = getMyPageSource();
			page.bodyContent = { bodyText: "" };
			createPageEditor(page);
			$("#my-page").addClass("compose in");	
		}
		
		function doPageEdit(){
			var renderTo = $("#my-page-grid");
			var grid = common.ui.grid( renderTo );
			var selectedCells = grid.select();
			if( selectedCells.length > 0){ 
				var selectedCell = grid.dataItem( selectedCells ); 
				createPageEditor(selectedCell);
			}
			$("#my-page").addClass("compose in");	
		}
		
		function getPageEditorSource(){
			var renderTo = $("#my-page-view");
			return renderTo.data("model");		
		}

		function createPageEditor(source){
			var renderTo = $("#my-page-view");
			$("#sky-form label.state-error").removeClass("state-error");
			
			if( !renderTo.data("model")){
				var model =  common.ui.observable({ 
					page : new common.ui.data.Page(),
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
						 			return { pageId: model.page.pageId, items: kendo.stringify(options.models)};
								} 
								return { pageId: model.page.pageId }
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
						$("#my-page-view span.back").click();
						common.ui.scroll.top($(".personalized-section").first());
					},
					update : function(e){
						var $this = this, 
						btn = $(e.target);						
						btn.button('loading');
						
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
									$("#my-page-grid").data('kendoGrid').dataSource.read();
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
					}
				});				
				source.copy( model.page );
				renderTo.data("model", model);
				kendo.bind(renderTo, model );				
				var bodyEditor =  $("#page-editor-body" );
				createEditor( "page-editor" , bodyEditor, { modal : false , appendTo: $("#my-page-editor-code"), tab: $("#my-page-editor-tabs"), useWrapMode : true } );
				
			}else{
				source.copy( renderTo.data("model").page );				
				if(renderTo.data("model").page.pageId > 0 )
					renderTo.data("model").properties.read();
			}	
			
			if(renderTo.data("model").page.pageId > 0) {
				renderTo.data("model").set("isAllowToFileAndProps", true);
			} else {
				renderTo.data("model").set("isAllowToFileAndProps", false);
			}							
		}
		
		
		
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
			
		#my-page .master  {
			opacity: 1;
			visibility: visible;		
			height:auto;					
		} 

		#my-page .details  {
			opacity: 0;
			visibility: hidden;		
			height:0px;		
		} 

		#my-page.compose .master  {
			opacity: 1;
			visibility: visible;				
		} 

		#my-page.compose .details  {
			opacity: 1;
			visibility: visible;		
		
		} 

		#my-page.compose.in .master  {
			opacity: 0;
			visibility: hidden;		
			height:0px;				
			-webkit-animation-name: fadeOut;
			animation-name: fadeOut;							
		} 

		#my-page.compose.in .details  {
			opacity: 1;
			visibility: visible;		
			height:auto;		
			-webkit-animation-name: fadeIn;
			animation-name: fadeIn;				
		} 
				
		#my-page.compose.out .master  {		
			opacity: 1;
			visibility: visible;			
			height:auto;	
			-webkit-animation-name: fadeIn;
			animation-name: fadeIn;				
		}

		#my-page.compose.out .details  {
			opacity: 0;
			visibility: hidden;		
			-webkit-animation-name: fadeOut;
			animation-name: fadeOut;				
			height:0px;				
		}
		
		.acc-v1	.panel-default {
			border-color: #bbb;
		}
						
		.k-grid tr > td  .btn-group {
			-webkit-animation-duration: 1s;
			animation-duration: 1s;
			-webkit-animation-fill-mode: both;
			animation-fill-mode: both;		
			cursor: not-allowed;
			pointer-events: none;			
			opacity: 0;
			visibility: hidden;						
		}

		.k-grid tr[aria-selected=true] > td  .btn-group {
			opacity: 1;
			visibility: visible;
			cursor: pointer;
			pointer-events: auto;				
			-webkit-animation-name: fadeInRight;
			animation-name: fadeInRight;	
		}
		
		.k-grid tr[aria-selected=false] > td  .btn-group {
			opacity: 1;
			visibility: visible;
			cursor: pointer;
			pointer-events: auto;				
			-webkit-animation-name: fadeOutRight;
			animation-name: fadeOutRight;	
		}
		
		.btn[disabled]{
			cursor: not-allowed;
			pointer-events: auto;		
		} 
		
		#my-page 	span.back {
			top:inherit;
			left:inherit;
		}
		
		#my-page .k-editor {
			border:0px;
		}
		
		.sky-form fieldset {
			background: #fff;
		}
		
		.ace_editor{
			min-height: 500px;			
		}		
		
		
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

/*Quote Block*/
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
						<section>
							<label class="label"> 소유자</label>
							<div id="my-page-source-list" class="inline-group">
								<label class="radio"><input type="radio" name="radio-inline" value="2"  checked=""><i class="rounded-x"></i> Me</label>
								<label class="radio"><input type="radio" name="radio-inline" value="30" ><i class="rounded-x"></i>  ${action.webSite.displayName}</label>
								<label class="radio"><input type="radio" name="radio-inline" value="1" ><i class="rounded-x"></i>  ${action.webSite.company.displayName}</label>
							</div>
						</section>
					</fieldset>
					<footer>
						<button type="button" class="btn btn-danger"><span class="btn-label icon fa fa-plus"></span> 새 페이지 만들기 </button>
						<button type="button" class="btn btn-primary" disabled="disabled" data-loading-text="<i class=&quot;fa fa-spinner fa-spin&quot;></i>"><i class="fa fa-external-link"></i> 게시</button>
					</footer>
				</div>
				
				<article class="bg-white animated fadeInUp m-t-md" style="min-height:200px; display:none;">								
					<div class="blog_masonry_3col">					
						<div id="my-page-listview" class="grid-boxes"></div>
					</div>
					<div id="my-page-pager" class="no-border"></div>
				</article>					
			</div>		
			<section class="personalized-section bg-transparent no-margin-b open" >
				<!--
				<div class="personalized-section-heading">
					<div class="container">
						<div class="personalized-section-title">
							<i class="icon-flat pencil"></i>
							<h3>MY 페이지 <span style="height:2.6em;"> 생각나는 내용을 적어보고, 수업 내용과 모임 메모를 기록하고, 웹 콘텐츠를 캡처하여 붙이고, 할 일 목록을 만들고,<br> 아이디어를 구상하고 스케치할 수 있습니다. <i class="fa fa-long-arrow-right"></i></span></h3>
							<div class="personalized-section-heading-controls">
								<div id="personalized-buttons" class="btn-group">
									<button type="button" class="btn-u btn-u-blue rounded-left" data-toggle="button" data-action="show-notification-panel" data-target="#my-notification-panel"><i class="fa fa-bell-o"></i> <span class="hidden-xs">알림</span> </button>
									<button type="button" class="btn-u btn-u-blue rounded-right" data-toggle="button" data-action="show-memo-panel"  data-target="#my-memo-panel" aria-pressed="false"><i class="fa fa-file-text-o"></i> <span class="hidden-xs">메모</span></button>
								</div>														
							</div>		
						</div>
					</div>				
				</div>
				-->
				
				<div class="personalized-section-content animated arrow-up">	
					<div class="container content" style="min-height:450px;">
						<div class="row">
							<div id="my-page">
								<div id="my-page-list" class="master animated">
									<!--
									<div class="btn-toolbar p-xxs">
									
										<div class="btn-group btn-group-sm" data-toggle="buttons" id="page-source-list">
											<label class="btn btn-info rounded active">
												<input type="radio" name="page-source" value="2" checked="checked"><i class="fa fa-user"></i> ME
											</label>
											<label class="btn btn-sm btn-danger">
												<input type="radio" name="page-source" value="30"><i class="fa fa-globe"></i> SITE
											</label>											
											<label class="btn btn-sm btn-danger rounded-right">
												<input type="radio" name="page-source" value="1"><i class="fa fa-building-o"></i> COMPANY
											</label>
										</div>
										<button type="button" class="btn btn-sm btn-danger" data-action="page-create"><span class="btn-label icon fa fa-plus"></span> 새 페이지 만들기 </button>
										<button type="button" class="btn btn-primary btn-sm" data-action="page-publish" disabled="disabled" data-loading-text="<i class=&quot;fa fa-spinner fa-spin&quot;></i>"><i class="fa fa-external-link"></i> 게시</button>
									</div>
									-->
									<div id="my-page-grid"></div>
								</div><!-- /.my-page-list -->
								<div id="my-page-view" class="details animated">								
									<span class="back"></span>
									<form action="" id="sky-form" class="sky-form" novalidate="novalidate">
										<header class="text-right"><span class="badge badge-dark rounded" data-bind="text:page.pageState"></span></header>
										<fieldset>											
											<section>
												<label for="title" class="input">
													<input type="text" name="title" placeholder="제목" data-bind="value: page.title">
												</label>
											</section>										
											<div class="row">
												<div class="col col-6">
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
												<div class="col col-6">
													<div class="panel-group acc-v1" id="accordion-1" data-bind="visible: isAllowToFileAndProps">
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
																	<div id="page-property-grid"></div>
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
																		data-bind="source: properties, visible: isVisible"
																		style="border:0px;"></div>	
																</div>
															</div>
														</div>
														<div class="panel panel-default">
															<div class="panel-heading">
																<h4 class="panel-title">
																	<a class="accordion-toggle collapsed" data-toggle="collapse" data-parent="#accordion-1" href="#collapse-Two">
																	<i class="fa fa-floppy-o"></i> 파일
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
													</div>													
												</div>
											</div>
										</fieldset>
											<section class="no-margin p-sm">													
												<div class="tab-v1">
													<div role="tabpanel">
														<!-- Nav tabs -->													
														<ul class="nav nav-tabs" role="tablist" id="my-page-editor-tabs">
															<li role="presentation" class="active"><a href="#my-page-editor-ui" aria-controls="my-page-editor-ui" data-action-target="editor"  role="tab" data-toggle="tab">글쓰기</a></li>
															<li role="presentation"><a href="#my-page-editor-code" aria-controls="my-page-editor-code" data-action-target="ace" role="tab" data-toggle="tab">코드</a></li>
														</ul>												
														<!-- Tab panes -->
														<div class="tab-content no-padding">
															<div role="tabpanel" class="tab-pane active" id="my-page-editor-ui">
																<textarea id="page-editor-body" class="no-border" data-bind='value:page.bodyContent.bodyText' style="height:500px;"></textarea>
															</div>
															<div role="tabpanel" class="tab-pane" id="my-page-editor-code"></div>
														</div>
													</div>
												</div>																							
											</section>											
								
										<footer class="text-right">
											<button type="button" class="btn-u" data-bind="events:{click:update}" data-loading-text="<i class='fa fa-spinner fa-spin'></i>">저장</button>
											<button type="button" class="btn-u btn-u-default btn-u-small" data-bind="events{click:close}">취소</button>	
										</footer>
									</form><!-- /.form >	
								</div><!-- /.my-page-view -->
							</div><!-- /.my-page -->
						</div><!-- /.row -->
					</div><!-- /.container -->
				</div>				
			</section><!-- /.section -->
			<!-- ./END MAIN CONTENT -->	
	 		
	 		<!-- START FOOTER -->
			<#include "/html/common/common-homepage-globalfooter.ftl" >		
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
	<script id="my-page-listview-template" type="text/x-kendo-template">
	<!--<div class="grid-boxes-in col-md-4 col-sm-6 col-xs-12">-->
	<div class="grid-boxes-in">
		#if( bodyContent.imageCount > 0 ){#
		<img class="img-responsive" src="#=bodyContent.firstImageSrc#" alt="">
		#}#

	

		
		<div class="grid-boxes-caption">
			<h2><a href="\\#">#:title#</a></h2>
				<ul class="list-inline grid-boxes-news">
                        <li><span>By</span> <a href="\\#">#if (user.nameVisible){ # #:user.name#  #}# <code>#:user.username#</code></a></li>
                        <li>|</li>
                        <li><i class="fa fa-clock-o"></i> #:formattedCreationDate() #</li>
                        <li>|</li>
                        <li><a href="\\#"><i class="fa fa-comments-o"></i> 0</a></li>
                    </ul>                    
			<p>#: summary #</p>
				<div class="navbar-btn">
					<div class="btn-group">				
						<button class="btn btn-info btn-flat btn-outline rounded-left" data-action="refresh"> 편집</button>
						<button class="btn btn-info btn-flat btn-outline" data-action="refresh">미리보기</button>
					</div>
					<button class="btn btn-danger btn-flat btn-outline rounded-right" data-action="refresh">삭제</button>
				</div>			
		</div>

	</div>
	</script>
 	<script id="my-page-listview-template2" type="text/x-kendo-template">
		
	<div class="row margin-bottom-20">
		<div class="col-sm-4 sm-margin-bottom-20">
			<div class="thumbnail-kenburn overflow-hidden" style="width:250px; height:150px;">
			#if( bodyContent.imageCount > 0 ){#
				<img class="img-responsive" src="#=bodyContent.firstImageSrc#" alt="">
			#}else{#
				<img class="img-responsive" src="http://htmlstream.com/preview/unify-v1.7/assets/img/main/img12.jpg" alt="">
			#}#
			</div>
		</div>
		<div class="col-sm-8 news-v3">
			<div class="news-v3-in-sm no-padding">
				#if ( pageState === "PUBLISHED" ) { #<span class="label label-success">#: pageState #</span>#}else{# <span class="label label-danger">#: pageState #</span> #}#
				<ul class="list-inline posted-info">
					<li><img width="30" height="30" class="img-circle" src="#: authorPhotoUrl()#" style="margin-right:5px; margin-left:10px">
							#if (user.nameVisible){ # #:user.name#  #}# <code>#:user.username#</code></li>
					<li><i class="fa fa-tags"></i> <a href="\\#">Design</a></li>
					<li><i class="fa fa-calendar"></i> #:formattedCreationDate() #</li>
				</ul>
				<h2><a href="\\#">#: title #</a></h2>
				<p>#: summary #</p>
				<div class="navbar-btn">
					<div class="btn-group">				
						<button class="btn btn-info btn-flat btn-outline rounded-left" data-action="refresh"> 편집</button>
						<button class="btn btn-info btn-flat btn-outline" data-action="refresh">미리보기</button>
					</div>
					<button class="btn btn-danger btn-flat btn-outline rounded-right" data-action="refresh">삭제</button>
				</div>
				
			</div>
		</div>
		<div class="clearfix margin-bottom-10"><hr class="m-b-sm"></div>
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