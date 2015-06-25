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
			'css!<@spring.url "/styles/bootstrap.themes/common/common.ui.buttons.css"/>',		
			'css!<@spring.url "/styles/bootstrap.themes/common/common.ui.inspinia.css"/>',
			'css!<@spring.url "/styles/bootstrap.themes/common/awesome-bootstrap-checkbox.css"/>',
			'css!<@spring.url "/styles/hover-effect/hover-min.css"/>',
			'css!<@spring.url "/styles/codrops/codrops.dialog.css"/>',		
			'css!<@spring.url "/styles/codrops/codrops.dialog-sally.css"/>',					
			'css!<@spring.url "/styles/common/common.flat-icons.css"/>',		
			'css!<@spring.url "/styles/common.pages/common.personalized.css"/>',	
			'<@spring.url "/js/jquery/1.10.2/jquery.min.js"/>',
			'<@spring.url "/js/jgrowl/jquery.jgrowl.min.js"/>',			
			'<@spring.url "/js/jquery.masonry/masonry.pkgd.min.js"/>',		
			'<@spring.url "/js/imagesloaded/imagesloaded.pkgd.min.js"/>',		
			'<@spring.url "/js/kendo/kendo.web.min.js"/>',
			'<@spring.url "/js/kendo.extension/kendo.ko_KR.js"/>',			
			'<@spring.url "/js/kendo/cultures/kendo.culture.ko-KR.min.js"/>',		
			'<@spring.url "/js/bootstrap/3.3.5/bootstrap.min.js"/>',			
			'<@spring.url "/js/common.plugins/jquery.slimscroll.min.js"/>', 		
			'<@spring.url "/js/common.plugins/query.backstretch.min.js"/>',			
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
						morphing : false,
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
				createMyPollListView();
				//createPageSection();
				// END SCRIPT 				
			}
		}]);			


		<!-- ============================== -->
		<!-- Pool														-->
		<!-- ============================== -->		
		function createMyPollListView( ){					
			var renderTo = $("#my-poll-listview");
			if( !common.ui.exists( renderTo )){	
				common.ui.listview( renderTo, {
					dataSource: {
						transport: { 
							read: { url:'<@spring.url "/data/polls/list.json?output=json"/>', type: 'POST' }/*,
							parameterMap: function (options, type){
								return { startIndex: options.skip, pageSize: options.pageSize,  objectType: getMyPageOwnerId() }
							}*/
						},
						requestStart: function(e){				
						},
						schema: {
							total: "totalCount",
							data: "items",
							model: common.ui.data.Poll
						},
						selectable: false,
						pageSize: 15					
					},
					template: kendo.template($("#my-poll-listview-template").html()),
					dataBound: function(e){		
						var elem = 	this.element.children();	
					},
					change: function(e){						
						//var selectedCells = this.select();
						//var selectedCell = this.dataItem( selectedCells );	
					}
				});		
				renderTo.removeClass('k-widget');

				$("#my-poll-listview").on( "click", "a[data-action=edit], button[data-action=edit]",  function(e){		
					$this = $(this);		
					var objectId = $this.data("object-id");	
					var item = common.ui.listview(renderTo).dataSource.get(objectId);
					openMyPollModal(item);
				});								
				createMyPollModal();				
			}	
		}
		
		function createMyPollModal(){
			var renderTo = $("#my-poll-modal");
			
			if( !renderTo.data("model") ){				
				var observable =  common.ui.observable({ 
					poll : new common.ui.data.Poll(),
					setSource : function( source ){
						source.copy( this.poll ) ;									
						common.ui.grid($("#my-poll-options-listview")).dataSource.read();
						common.ui.grid($("#my-poll-options-listview")).dataSource.data( this.poll.options );						
					}
				});								
				renderTo.data("model", observable);				
				kendo.bind(renderTo, observable );
				
				$("button[data-action=create][data-object-type=40], a[data-action=create][data-object-type=40]").click(function(e){
					openMyPollModal(new common.ui.data.Poll());
				});
				
				common.ui.grid($("#my-poll-options-listview"), {
					dataSource : new kendo.data.DataSource({ 
						data: observable.poll.options ,
						schema:{
							model:{ id: "optionId",
								fields:{
									optionId : {editable: true, editable : true, defaultValue : 0},
									optionText : {editable: true, editable : true, nullable:false }								
								}
							}
						}
					}),			
					toolbar: [{ name: "create", text:"추가"}],
					columns:[{
						width: 80,
						field: 'optionId',
						title: "ID"},{
						field: 'optionText',
						title: "내용"},
						{ command: [{ name : "edit" , text : {edit:"수정", update:"저장", cancel:"최소" }  }, {name:"destroy", text: "삭제" }], title: "&nbsp;", width: "250px" }				
					],
					editable: "inline"
				});
				
				
				$("#sortable-my-poll-options").kendoSortable({
					filter : ".sortable",
					hint:function(element) {
						return element.clone().addClass("hint");
					},
					placeholder:function(element) {
						return element.clone().addClass("placeholder").text("drop here");
					},
					cursor: "url('<@spring.url "/images/common/sortable/grabbing.cur"/>'), default",
						cursorOffset: {
							top: -10,
							left: -230
					},
					ignore: "input"
				});
				

									
			}
			
				
		}
		
		function openMyPollModal( poll ){
			var renderTo = $("#my-poll-modal");
			if( renderTo.data("model") ){	
				poll.options = [];
				poll.options.push( { optionId: 1 , optionText : "가지고 있다"} );		
				poll.options.push( { optionId: 2 , optionText : "없다"} );		
						
				renderTo.data("model").setSource( poll );			
			}
			renderTo.modal('show');
		}
		
		
		<!-- ============================== -->
		<!-- Page														-->
		<!-- ============================== -->		
		function getMyPageOwnerId(){
			return $("#my-page-source-list input[type=radio][name=radio-inline]:checked").val();			
		}
	
		function createMyPageListView(){		
			var renderTo = $("#my-page-listview");
			if( !renderTo.data('masonry')){			
				renderTo.masonry({	
					columnWidth: '.item',
					itemSelector: '.item',
					isAnimated: true,
					isResizable:true
				});
			}	
							
			if( !common.ui.exists( renderTo ) ){		
				var msnry = renderTo.data('masonry');	
				common.ui.listview( renderTo, {
					dataSource: {
						transport: { 
							read: { url:'<@spring.url "/data/pages/list.json?output=json"/>', type: 'POST' },
							parameterMap: function (options, type){
								return { startIndex: options.skip, pageSize: options.pageSize,  objectType: getMyPageOwnerId() }
							}
						},
						requestStart: function(e){				
						},
						schema: {
							total: "totalCount",
							data: "pages",
							model: common.ui.data.Page
						},
						selectable: false,
						error:common.ui.handleAjaxError,
						batch: false,
						pageSize: 15,
						serverPaging: true,
						serverFiltering: false,
						serverSorting: false,
						filter: {
							field: "pageState", operator: "eq", value: "PUBLISHED"
						}
					},
					template: kendo.template($("#my-page-listview-template").html()),
					dataBound: function(e){		
						var elem = 	this.element.children();	
						elem.imagesLoaded(function(){
							msnry.appended(elem);
							msnry.layout();
						});
						
					},
					change: function(e){						
						var selectedCells = this.select();
						var selectedCell = this.dataItem( selectedCells );	
					}
				});		
				renderTo.removeClass("k-widget k-listview");				
				
				common.ui.pager($("#my-page-pager"), {
					dataSource: common.ui.listview(renderTo).dataSource,
					pageSizes: [15, 25, 50, 100]
				});	
				
				$("#my-page-listview").on( "click", "a[data-action], button[data-action]",  function(e){				
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
				
				$("input[name='page-list-view-filters']").on("change", function () {
					var pageState = this.value;
					if( pageState == 'ALL' ){
						common.ui.listview(renderTo).dataSource.filter({}); 
					}else{
						common.ui.listview(renderTo).dataSource.filter({ field: "pageState", operator: "eq", value: pageState}); 
					}
				});				
				
				// event for new page
				$("button[data-action=create][data-object-type=31], a[data-action=create][data-object-type=31]").click(function(e){
					var page = new common.ui.data.Page();
					page.set("objectType", getMyPageOwnerId());					
					createMyPageViewer(page, true);
				});
				
				
			}			
			//if( $("article.my-page-wrapper").is(":hidden") ){
			//	$("article.my-page-wrapper").show();
			//} 			
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
					pageSource : "",
					pageSourceUrl : "",
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
						
						//var source_title = $("#my-page-options input[name=source]").val();
						//var source_link = $("#my-page-options input[name=url]").val();
						
						if( $this.pageSource.length > 0 ){
							$this.page.properties.source = $this.pageSource;
						} 
						if( $this.pageSourceUrl.length > 0 ){
							$this.page.properties.url = $this.pageSourceUrl;
						}
						
						if( $this.page.tagsString.length > 0 ){
							$this.page.properties.tagsString = $this.page.tagsString;
						} 
						
						common.ui.ajax(
							'<@spring.url "/data/pages/update.json?output=json"/>',
							{
								data : kendo.stringify($this.page) ,
								contentType : "application/json",
								success : function(response){
									if( response.pageId ){
										$("#my-page-options").collapse('hide');
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
						
						if( $this.pageSource.length > 0 ){
							$this.page.properties.source = $this.pageSource;
						} 
						if( $this.pageSourceUrl.length > 0 ){
							$this.page.properties.url = $this.pageSourceUrl;
						}
						$this.page.properties.tagsString = $this.page.tagsString;
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
					appendTo: $("#my-page-editor-tabs-code-body"), 
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
		#my-page-editor-tabs-html .k-editor {
			border : 0;
		}
		
		.page-editor-options {
			position : absolute;
			top: 182px;
			right: 55px;
		}
		
		.ace_editor{
			min-height: 500px;			
		}		
		
		
		.my-page-wrapper {
			min-height:200px;
		}
		
		.my-page-form {
			border: 0;
			margin-bottom: 10px;
		}
		
		.my-page-form fieldset {
			background-color: #fafafa;
			border-bottom: 1px dashed #e4e4e4;
			border-top-left-radius: 8px!important;
			border-top-right-radius: 8px!important;				
		}
		
		#my-page-pager {
			border:0;
			border-top:1px dashed #e4e4e4;
			padding : 10px;
			background-color : #fafafa;
			border-bottom-left-radius: 8px!important;
			border-bottom-right-radius: 8px!important;						
		}
		#my-page-viewer .k-grid-content {
			min-height: 150px;		
		}
		#my-page-listview {
			min-height : 300px;
		}
		#my-page-listview .ibox {
			border-radius: 0 0 6px 6px!important;
			overflow: hidden;	
			//border: 1px solid #e7eaec;
		}
		
		#my-page-listview .ibox .ibox-content {
			//background-color: #fafafa!important;
		}
		
		.my-poll-options
		{
			width: 100%;		
		}
		
		.my-poll-options ul {
			padding: 0;
			margin: 0;
		}

		li.sortable {
			list-style-type: none;
			padding: 6px 8px;
			margin: 0;
			border : 1px solid #fff;
			color: #666;
			font-size: 1.1em;
			cursor: url('<@spring.url "/images/common/sortable/grabbing.cur"/>'), default;
		}
		li.sortable:last-child {
			//border-bottom: 0;
			//border-radius: 0 0 4px 4px;
		}		
		li.sortable:hover {
			background-color: #34aadc;
			//border : 1px dashed #5ac8fa;
			border-radius: 4px!important;
			color : #fff;
		}		
		li.placeholder {
			border : 1px dashed #007aff;
			border-radius: 4px!important;
			background-color: #34aadc;
			color: #fff;
			text-align: right;
		}		
		li.hint {
			display: block;
			width: 300px;
			background-color: #007aff;
			border : 1px solid #fff;
			border-radius: 4px!important;			
			color: #fff;
		}
		li.hint:after {
                    content: "";
                    display: block;
                    width: 0;
                    height: 0;
                    border-top: 6px solid transparent;
                    border-bottom: 6px solid transparent;
                    border-left: 6px solid #007aff;
                    position: absolute;
                    left: 300px;
				top: 10px;
		}

		li.hint:last-child {
			border-radius: 4px;
		}	

		li.sortable span {
			display: block;
			float: right;
			color: #666;
		}
		
		li.hint span {
			display : none!important;
			color: #fff;
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
			<div class="breadcrumbs-v3 img-v1 arrow-up bg-section no-border">
				<div class="personalized-controls container text-center p-xl">
					<p class="text-quote"> ${ navigator.description ? replace ("{displayName}" , action.webSite.company.displayName ) }	</p>
					<h1 class="text-xxl"><#if navigator.icon?? ><i class="icon-flat ${navigator.icon}"></i></#if> ${ navigator.title }</h1>					
					<a href="<@spring.url "/display/0/my-home.html"/>"><span class="btn-flat home t-0-r-2"></span></a>
					<a href="<@spring.url "/display/0/my-driver.html"/>"><span class="btn-flat folder t-0-r-1"></span></a>					
					<span class="btn-flat settings"></span>
					</div><!--/end container-->
			</div>
			</#if>
			<div class="footer-buttons-wrapper">
				<div class="footer-buttons">
					<div class="dropup">
					<button class="btn-link hvr-pulse-shrink" type="button" id="dropdown-menu1" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false" ><i class="icon-flat icon-flat pencil"></i></button>
					<ul class="dropdown-menu" aria-labelledby="dropdown-menu1">
						<li><a href="#" data-action="create" data-object-type="31">페이지 만들기</a></li>
						<li><a href="#" data-action="create" data-object-type="40">설문 만들기</a></li>
						<li><a href="#">이벤트 & 공지 만들기</a></li>
						<li class="disabled"><a href="#">장소 공유하기</a></li>
						<li class="disabled"><a href="#">북마크 만들기 </a></li>
					</ul>					
					</div>
					<button class="btn-link hvr-pulse-shrink"><i class="icon-flat icon-flat help"></i></button>
				</div>
			</div>			
			
			<!-- START MAIN CONTENT -->
			<div class="bg-section">
			<div class="container content">			
				<div class="sky-form my-page-form">
					<fieldset>
						<div class="row">
							<div class="col col-md-6">
								<section>
									<label class="label"> 소유자</label>
									<div id="my-page-source-list" class="inline-group">
										<label class="radio"><input type="radio" name="radio-inline" value="2"  checked=""><i class="rounded-x"></i> Me</label>										
										<label class="radio"><input type="radio" name="radio-inline" value="1" ><i class="rounded-x"></i>  ${action.webSite.company.displayName}</label>
										<label class="radio"><input type="radio" name="radio-inline" value="30" ><i class="rounded-x"></i>  ${action.webSite.displayName}</label>
									</div>
								</section>							
							</div>
							<div class="col col-md-6">
								<section>
									<label class="label"> 상태 필터</label>							
									<div class="btn-group btn-group-sm" data-toggle="buttons" id="attachment-list-filter">
										<label class="btn btn-success  rounded-left">
										<input type="radio" name="page-list-view-filters"  value="ALL"> 전체 </span>)
										</label>
										<label class="btn btn-success active">
											<input type="radio" name="page-list-view-filters"  value="PUBLISHED"><i class="fa fa-filter"></i> PUBLISHED
										</label><!--
													<label class="btn btn-success">
														<input type="radio" name="page-list-view-filters"  value="ARCHIVED"><i class="fa fa-filter"></i> ARCHIVED
													</label>	-->
										<label class="btn btn-success">
											<input type="radio" name="page-list-view-filters"  value="INCOMPLETE"><i class="fa fa-filter"></i> INCOMPLETE
										</label>													
										<label class="btn btn-success rounded-right">
											<input type="radio" name="page-list-view-filters"  value="DELETED"><i class="fa fa-filter"></i> DELETED
										</label>	
									</div>
								</section>															
							</div><!--
							<div class="col col-md-3 text-right">
									<button type="button" class="btn btn-danger btn-lg btn-outline btn-flat" data-action="create"><span class="btn-label icon fa fa-plus"></span> 새 페이지 만들기 </button>
							</div>-->
						</div>	
					</fieldset>
				</div>				
				<article class="my-page-wrapper">
					<div id="my-page-listview" class="row"></div>
					<div id="my-page-pager"></div>
				</article>
			</div>
			</div>
			<div class="bg-white">
				<div class="container content" >					
					<div class="row">	
						<div class="col-sm-6">
							<h4><i class="icon-flat mega-phone m-b-n-sm"></i> <small class="text-muted">공지 &amp; 이벤트을 작성하고 수정할 수 있습니다. </small></h4>		
						</div>	
						<div class="col-sm-6">
							<h4><i class="icon-flat paper-plane m-b-n-sm"></i> <small class="text-muted">설문을 쉽고 빠르게 생성하고 수정할 수 있습니다.</small></h4>		
							<div class="p-md">
                                        
                                        
                                        
                                        
                                        
                                        
                                        <p>설문 상태</p>
                                        <div class="radio radio-info radio-inline">
                                            <input type="radio" id="my-poll-listview-state-all" value="option1" name="my-poll-listview-state" checked="">
                                            <label for="my-poll-listview-state-all">전체</label>
                                        </div>
                                        <div class="radio radio-inline">
                                            <input type="radio" id="my-poll-listview-state-active" value="option2" name="my-poll-listview-state">
                                            <label for="my-poll-listview-state-active"> Active </label>
                                        </div>
                                        <div class="radio radio-inline">
                                            <input type="radio" id="my-poll-listview-state-live" value="option2" name="my-poll-listview-state">
                                            <label for="my-poll-listview-state-live"> Live </label>
                                        </div>                                        
                                    </div>
                                    
							<div id="my-poll-listview" class="ibox-content inspinia-timeline"></div>
						</div>								
					</div>				
				</div>
			</div>		
			
			<!-- ./END MAIN CONTENT -->		 		
	 		<!-- START FOOTER -->
			<#include "/html/common/common-homepage-globalfooter.ftl" >		
			<!-- ./END FOOTER -->					
		</div>			
			
		<!-- Modal -->
		<div class="modal fade" id="my-poll-modal" tabindex="-1" role="dialog" aria-labelledby="my-poll-modal">
			<div class="modal-dialog" role="document">
				<div class="ibox float-e-margins">
					<div class="ibox-title">
						<span class="text-primary"><i class="fa fa-info"></i> 설문 </span>
						<!--<span class="close" data-dialog-close="" data-dismiss="modal" aria-label="Close"></span>-->
						<span class="hvr-pulse-shrink" data-modal-settings data-toggle="collapse" data-target="#my-poll-modal-settings" area-expanded="false" aria-controls="my-poll-modal-settings"><i class="icon-flat icon-flat settings"></i></span>
					</div>
					<div class="ibox-content no-padding">
						<!-- options forms -->
						<form id="my-poll-modal-settings" action="#" class="sky-form modal-settings collapse" aria-expanded="false">
							<header>
								옵션
								<span class="btn-up btn-up-gray btn-md"></span>
							</header>
							<fieldset>                  
								<section>
								<div class="separator-2"></div>
								<label class="label">시작일</label>
								<input id="start" style="width: 200px" value="10/10/2011" data-role="datepicker"  data-bind="value: poll.startDate" />
								<p class="note">시작일은 종료일 이후일 수 없습니다.</p>
								</section>
								<div class="hr-line-dashed"></div>
								<section>			
								<label class="label">종료일</label>							
								<input id="end" style="width: 200px" value="10/10/2012" data-role="datepicker" data-bind="value: poll.endDate"/>
								<p class="note">종료일은 시작일 이전일 수 없습니다.</p>
								</section>			
								<div class="hr-line-dashed"></div>
								<section>			
								<label class="label">만료일</label>
								<input id="start" style="width: 200px" value="10/10/2011" data-role="datepicker" data-bind="value: poll.expireDate" />
								<p class="note">만료일은 설문종료 이후 설문 결과를 보여줄 마지막 일자를 의미합니다</p>
								</section>
							</fieldset>                               
						</form>
						<!-- /.options forms -->													
						<form action="#" class="sky-form no-border">
							<fieldset>    
								<section>
									<label class="input">
										<input type="text" name="name" placeholder="질문 제목" data-bind="value:poll.name">
									</label>
								</section>
								<section>
									<label class="textarea textarea-expandable">
										<textarea rows="3" name="description" placeholder="도움말 텍스트" data-bind="value:poll.description"></textarea>
									</label>
								</section>
							</fieldset>
							<fieldset>
								<div class="my-poll-options" >		
									<label class="label">옵션</label>					
									<div id="my-poll-options-listview"></div>
									
									
									<ul id="sortable-my-poll-options">
										<li class="sortable" object-id="0">
											아이폰을 사용하고 있습니다. <span><button type="button" class="btn btn-flat btn-danger btn-xs">삭제</button></span>
										</li>
										<li class="sortable">
											아이폰을 사용하지 않습니다.<span><button type="button" class="btn btn-flat btn-danger btn-xs">삭제</button></span>
										</li>
									</ul>	
								</div>
								<hr/>								
								<section>
									<label class="input">
										<input type="text">
									</label>
									<button type="button" class="btn btn-info btn-flat btn-outline btn-sm"><i class="fa fa-plus"></i> 옵션 추가</button>
								</section>
							</fieldset>			
							<footer>
								<button type="submit" class="btn-u">완료</button>
							</footer>						
						</form>
					</div>
				</div>
			</div>
		</div>		
		<div id="my-page-viewer" class="dialog dialog-full bg-glass" data-feature="dialog" data-dialog-animate="">
			<div class="dialog__overlay"></div>
			<div class="dialog__content">
				<div class="container">
					<div class="row">
						<div class="col-sm-12">						
							<div class="ibox float-e-margins">
			                    <div class="ibox-title">
			                    	<span class="text-danger" data-bind="invisible:advencedSetting"><i class="fa fa-info"></i> 페이지 제목을 입력하세요</span>
			                        <span data-bind="{text: page.title, invisible:editable }"></span>&nbsp;
									<span class="hvr-pulse-shrink" data-dialog-settings data-export="pdf" style="right:110px;" data-bind="{invisible:editable, click:exportPdf}" data-loading-text="<i class='fa fa-spinner fa-spin'></i>" ><i class="icon-flat icon-flat disk"></i></span> 
									<span class="hvr-pulse-shrink collapsed" data-dialog-settings style="right:65px;" data-toggle="collapse" data-target="#my-page-dialog-settings" area-expanded="false" aria-controls="my-page-dialog-settings"><i class="icon-flat icon-flat settings"></i></span> 
									<span class="close" data-dialog-close></span>					
								</div>
								<form id="my-page-dialog-settings" action="#" class="sky-form dialog-settings collapse" aria-expanded="false">
									<header>
										옵션
										<span class="close" style="right:0;" data-toggle="collapse" data-target="#my-page-dialog-settings" aria-expanded="false" aria-controls="my-page-dialog-settings"></span>
									</header>
									<fieldset>                  
										<section>
											<div class="separator-2"></div>
											<label class="label">요약</label>	
											<label class="textarea textarea-expandable">
												<textarea rows="4"  name="summary" placeholder="요약" data-bind="value: page.summary"></textarea>
											</label>
										</section>
										<section>
											<label class="label">테그</label>
											<label class="input">
												<i class="icon-append fa fa-tag"></i>
												<input type="text" name="tags" data-bind="value:page.tagsString">
											</label>
											<div class="note"><strong>Note:</strong>공백으로 라벨을 구분하세요</div>
										</section>
										<section>
											<label class="label">출처</label>
											<label class="input">
												<input type="text" name="source" placeholder="출처" data-bind="value: pageSource"/>
											</label>
											<label class="input">
												<i class="icon-append fa fa-globe"></i>
												<input type="text" name="url" placeholder="URL" data-bind="value: pageSourceUrl"></label>
											</label>			
											<div class="note"><strong>Note:</strong> 저작권자의 출처 정보를 입력하세요</div></section>																		
										</section>			
									</fieldset>
									<fieldset data-bind="visible:advencedSetting">									
										<section>
											<label class="label">파일</label>
											<label class="input">
												<i class="icon-prepend fa fa-file-text-o"></i>
												<input type="text" name="name" placeholder="파일 이름" data-bind="value: page.name">
											</label>
											<label class="input">
												<i class="icon-prepend fa fa-file-code-o"></i>
												<input type="text" name="template" placeholder="템플릿">
											</label>
											<div class="note"><strong>Note:</strong>파일이름과 템플릿을 정보를 설정합니다.</div>
										</section>
										
										<section>
											<div class="panel-group acc-v1" id="accordion-1" data-bind="visible:advencedSetting">
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
														</div><!-- ./acc-v1 -->					                        
										</section>					                        
									</fieldset>		
								</form>
								<!-- view article -->
			                    <article data-bind="{invisible:editable}" >
									<div class="ibox-content ibox-heading">
										<div class="author margin-bottom-20">
											<img width="30" height="30" class="img-circle pull-left" data-bind="attr:{src:page.authorPhotoUrl}" src="/images/common/no-avatar.png" style="margin-right:10px;">
											<ul class="list-inline grid-boxes-news">
												<li><span>By</span> <span data-bind="{ text: page.user.name, visible: page.user.nameVisible }"></span><code data-bind="{ text: page.user.username }"></code></li>
												<li>|</li>
												<li><span>버전:</span> <span data-bind="{ text: page.versionId }"></span></li>
												<li>|</li>
												<li><span>조회수:</span> <span data-bind="{ text: page.viewCount }"></span></li>
												<li>|</li>
												<li><span>댓글:</span> <span data-bind="{ text: page.commentCount }"></span></li>
												<li>|</li>																								
												<li><i class="fa fa-clock-o"></i> <span data-bind="{ text: page.formattedCreationDate }"></span></li>
												<li><i class="fa fa-clock-o"></i> <span data-bind="{ text: page.formattedModifiedDate }"></span></li>
												
											</ul>  
										</div>
										<div class="tag-box tag-box-v4 no-margin-b">                    
                    						<p data-bind="text:page.summary"></p>
                    					</div>
                                	</div>
                                	<div data-bind="{html:page.bodyContent.bodyText}" class="ibox-content atricle"></div>
			                    </article>
								<!-- /.view article -->
								<!-- edit form -->
								<div class="sky-form bg-white" data-bind="visible:editable" class="no-border-hr">
									<fieldset>
										<section>
										<label for="title" class="input">
											<input type="text" name="title" placeholder="제목" data-bind="value: page.title">
										</label>
										</section>							
									</fieldset>
									<fieldset data-bind="visible:advencedSetting" class="no-border padding-sm">											
												<div class="tab-v1">
													<div role="tabpanel">
														<!-- Nav tabs -->													
														<ul class="nav nav-tabs" role="tablist" id="my-page-editor-tabs">
															<li role="presentation" class="m-l-sm active"><a href="#my-page-editor-tabs-html" aria-controls="my-page-editor-tabs-html" data-action-target="editor"  role="tab" data-toggle="tab">글쓰기</a></li>
															<li role="presentation"><a href="#my-page-editor-tabs-code" aria-controls="my-page-editor-tabs-code" data-action-target="ace" role="tab" data-toggle="tab">코드</a></li>
														</ul>												
														<!-- Tab panes -->
														<div class="tab-content no-padding">
															<div role="tabpanel" class="tab-pane active" id="my-page-editor-tabs-html">
																<textarea id="my-page-editor" class="no-border" data-bind='value:page.bodyContent.bodyText' style="height:500px;"></textarea>
															</div>
															<div role="tabpanel" class="tab-pane" id="my-page-editor-tabs-code">
																<div class="page-editor-options"><label class="toggle"><input type="checkbox" name="checkbox-toggle" data-bind="checked: useWrapMode, events: { change: useWrap }"><i class="rounded-4x"></i>줄바꿈 설정/해지</label></div>
																<div id="my-page-editor-tabs-code-body"></div>
															</div>
														</div>
													</div>
												</div>		
										</fieldset>	
										<footer class="text-right">
											<button class="btn btn-default btn-flat  btn-md rounded" type="button" data-dialog-close >닫기</button>
											<button type="button" class="btn btn-success btn-flat btn-md rounded" data-bind="{events:{click:create}, invisible:advencedSetting}" data-loading-text="<i class='fa fa-spinner fa-spin'></i>"><i class="fa fa-angle-right"></i> 다음</button> 				
											<button type="button" class="btn btn-info btn-flat btn-md rounded" data-bind="{events:{click:update}, visible:advencedSetting}" data-loading-text="<i class='fa fa-spinner fa-spin'></i>">저장</button> 				
										</footer>															
								</div>
								<!-- /.edit form -->
							</div>
						</div>
					</div>					
				</div>				
			</div>
		</div>	
	<!-- START TEMPLATE -->				
	<script id="my-page-listview-template" type="text/x-kendo-template">
	<div class="col-md-3 col-sm-4  item" style="display:none;" data-object-id="#=pageId#">
	<div class="ibox float-e-margins">
		<div class="ibox-title cover">
		#if( bodyContent.imageCount > 0 ){#
		<div class="cover" ><img class="img-responsive #if(pageState ===  'DELETED' ){# grayscale #}#" src="#=bodyContent.firstImageSrc#" alt=""></div>
		#}#
		#if ( pageState === "PUBLISHED" ) { #<span class="label label-success">#: pageState #</span>#}else if( pageState === "DELETED" ) {# <span class="label label-default">#: pageState #</span> #}else{# <span class="label label-danger">#: pageState #</span> #}#
		</div>
		<div class="ibox-content ibox-title">			
			#if( pageState !=  'DELETED' ){#<h2><a href="\\#" data-action="view" data-object-id="#=pageId#">#:title#</a></h2>#}else{#
			<h2 class="text-muted">#:title#</a></h2>
			#}#
			<ul class="list-inline">
				<li>#if (user.nameVisible){ # #:user.name#  #}# <code>#:user.username#</code></li>
				<li>|</li>
				<li>#: kendo.toString( modifiedDate , "D") #</li>
				<li>|</li>
				<li><i class="fa fa-eye"></i> #: viewCount#</li>
				<li>|</li>
				<li><i class="fa fa-comment-o"></i> #: commentCount#</li>				
			</ul>        
			#if ( tagsString.length > 0 ){#            
			<p><i class="fa fa-tags"></i> #: tagsString #</p>
			#}#
			<p>#: summary #</p>
			# if( getCurrentUser().userId === user.userId ) { # 	
				<div class="text-right">
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
	</div>
	</div>
	</script>	
	<script id="my-poll-listview-template" type="text/x-kendo-template">
	<div class="timeline-item">
		<div class="row">
			<div class="col-xs-3 date">
				<i class="fa fa-bar-chart"></i>
				<span class="text-navy"> #: kendo.toString( creationDate, "m") #</span>
				<br>
				<span class="text-danger">#: kendo.toString( expireDate , "m") #</span>
			</div>
			<div class="col-xs-7 content no-top-border">
					<p class="m-b-xs"><strong>#: name #</strong></p>
					<p class="text-muted m-b-xs"><small>#: description #</small></p>
					<button class="btn btn-info btn-flat btn-outline rounded btn-sm" data-action="edit" data-object-id="#= pollId#"> 편집</button>
			</div>
		</div>
	</div>
	
	<!--	<div class="ibox">
			<div class="ibox-title">
				<span class="label label-primary pull-right">NEW</span>
				<h5><i class="fa fa-bar-chart"></i> #: name #</h5>
			</div>
			<div class="ibox-content">
				<p class="text-muted"><small>#: description #</small></p>
				<div class="team-members">
					<a href="\\#"><img alt="member" class="img-circle" src="img/a1.jpg"></a>
                                <a href="\\#"><img alt="member" class="img-circle" src="img/a2.jpg"></a>
                                <a href="\\#"><img alt="member" class="img-circle" src="img/a3.jpg"></a>
                                <a href="\\#"><img alt="member" class="img-circle" src="img/a5.jpg"></a>
                                <a href="\\#"><img alt="member" class="img-circle" src="img/a6.jpg"></a>
				</div>
				<h3 class="heading-xs">결과<span class="pull-right">88%</span></h3>
				<div class="progress progress-u progress-xs">
					<div class="progress-bar progress-bar-blue" role="progressbar" aria-valuenow="88" aria-valuemin="0" aria-valuemax="100" style="width: 88%">
					</div>
				</div>
				
				<ul class="list-unstyled margin-bottom-30">
					<li><strong>시작일:</strong> #: kendo.toString( startDate , "D") #</li>
                	<li><strong>종료일:</strong>#: kendo.toString( endDate , "D") #</li>
                	<li><strong>만료일:</strong> #: kendo.toString( expireDate , "D") #</li>
                </ul>
                <button class="btn btn-info btn-flat btn-outline rounded btn-sm" data-action="edit" data-object-id="#= pollId#"> 편집</button>
			</div>
		</div>-->
	</script>	
	<script id="my-poll-option-template" type="text/x-kendo-template">
	<div class="k-widget">
		#:optionText#
		<div class="edit-buttons">
                <a class="k-button k-edit-button" href="\\#"><span class="k-icon k-edit"></span></a>
                <a class="k-button k-delete-button" href="\\#"><span class="k-icon k-delete"></span></a>
            </div>
	</div>
	</script>	
	<script id="my-poll-option-edit-template" type="text/x-kendo-template">
	</script>	
	
																				
	<#include "/html/common/common-homepage-templates.ftl" >		
	<#include "/html/common/common-personalized-templates.ftl" >
	<#include "/html/common/common-editor-templates.ftl" >	
	<!-- ./END TEMPLATE -->
	</body>    
</html>