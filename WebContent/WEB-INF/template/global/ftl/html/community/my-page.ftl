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
				
			'css!<@spring.url "/styles/bootstrap.themes/unify/colors/blue.css"/>',
			'css!<@spring.url "/styles/jquery.magnific-popup/magnific-popup.css"/>',
				
			'css!<@spring.url "/styles/bootstrap.themes/common/common.ui.inspinia.css"/>',
			'css!<@spring.url "/styles/bootstrap.themes/common/common.ui.buttons.css"/>',	
			'css!<@spring.url "/styles/bootstrap.themes/common/awesome-bootstrap-checkbox.css"/>',
			'css!<@spring.url "/styles/jquery.sky-forms/2.0.1/custom-sky-forms.css"/>',
			
			'css!<@spring.url "/styles/hover-effect/hover-min.css"/>',
			'css!<@spring.url "/styles/codrops/codrops.dialog.css"/>',		
			'css!<@spring.url "/styles/codrops/codrops.dialog-sally.css"/>',					
			'css!<@spring.url "/styles/common/common.flat-icons.css"/>',		
			'css!<@spring.url "/styles/common.pages/common.personalized.css"/>',	
			
			'<@spring.url "/js/jquery/1.10.2/jquery.min.js"/>',
			'<@spring.url "/js/jgrowl/jquery.jgrowl.min.js"/>',			
			'<@spring.url "/js/jquery.masonry/masonry.pkgd.min.js"/>',		
			'<@spring.url "/js/imagesloaded/imagesloaded.pkgd.min.js"/>',	
			'<@spring.url "/js/jquery.magnific-popup/jquery.magnific-popup.min.js"/>',		
			'<@spring.url "/js/kendo/kendo.web.min.js"/>',		
			'<@spring.url "/js/kendo.extension/kendo.ko_KR.js"/>',			
			'<@spring.url "/js/kendo/cultures/kendo.culture.ko-KR.min.js"/>',		
			'<@spring.url "/js/bootstrap/3.3.5/bootstrap.min.js"/>',			
			'<@spring.url "/js/common.plugins/jquery.slimscroll.min.js"/>', 		
			'<@spring.url "/js/common.plugins/query.backstretch.min.js"/>',	
			'<@spring.url "/js/common.plugins/switchery.min.js"/>',			
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
				//$(".navbar-nav li[data-menu-item='MENU_PERSONALIZED'], .navbar-nav li[data-menu-item='MENU_PERSONALIZED']").addClass("active");		
				createMyPageListView();	
				createMyPollListView();
				//createPageSection();
				createPageCompose();
				// END SCRIPT 				
			}
		}]);			

		<!-- ============================== -->
		<!-- Page Post Modal				-->
		<!-- ============================== -->		
		
		function createPageCompose(){
			$("button[data-action=post], a[data-action=post]").click(function(e){
				createPagePostDialog();
				return false;
			});		
		}
						
		function createPagePostDialog(){
			var renderTo = $("#my-post-type-switcher");					
			if( !common.ui.exists(renderTo)){
				var switcher = new common.ui.DialogSwitcher( renderTo, {} );  
				$("button[data-post-type]").click(function(e){
					var $this = $(this);
					var postType = $this.data("post-type");
					var page = new common.ui.data.Page();
					page.set("objectType", getMyPageOwnerId());
					createPagePostModal(page, postType);					
				});
			}			
			renderTo.data('kendoDialogSwitcher').open();
		}
		
		function createPagePostModal( page, postType ){
			var renderTo = $("#my-page-post-modal");
			if( !renderTo.data('bs.modal')){			
				var editorTo =  $("#my-page-post-editor" );
				var observable =  common.ui.observable({
					page : new common.ui.data.Page(),
					postType: "text",
					text:true,
					photo:false,
					link:false,
					quote:false,
					authorPhotoUrl : "/images/common/no-avatar.png",
					adultContent : false,
					pageSource : "",
					pageSourceUrl : "",
					imageSourceUrl : "",
					imageDataUrl: "",
					imageEffect: "carousel",
					imageSort: "name",
					imageSortDir: "asc",
					imageLayoutChanged : false,
					editable : false,
					followUp : false,
					visible : true,
					useWrapMode : false,
					useWrap : function(e){
						var $this = this;
						if( $this.get('editable') )
							ace.edit("my-page-code-editor").getSession().setUseWrapMode($this.useWrapMode);
					},
					keypress : function(e){
						var $this = this, 
						input = $(e.target);
						if( $this.page.pageId === 0 && e.keyCode === 13 )  {
							e.preventDefault();
							renderTo.find("button[data-action=create]").click();
						}
					},
					stateSource : [
						{name: "" , value: "INCOMPLETE"},
						{name: "승인" , value: "APPROVAL"},
						{name: "게시" , value: "PUBLISHED"},
						{name: "거절" , value: "REJECTED"},
						{name: "보관" , value: "ARCHIVED"},
						{name: "삭제" , value: "DELETED"}
					],
					validate : function (){
						var $this = this, hasError = false;		
						renderTo.find("form label[for]").removeClass("state-error");					
						renderTo.find("form em[for]").remove();					
						if( $this.page.title.length === 0 )  
						{
							var template = kendo.template('<em for="#:name#" class="invalid">#: msg#</em>');
							renderTo.find("form label[for=title]").addClass("state-error").parent().append(
								template( { name: "title" ,msg: "주제를 입력하여 주세요."} )
							);
							hasError = true;							
						}
						return !hasError;
					},
					create : function(e){
						var $this = this, 
						btn = $(e.target);	
						if( $this.validate() ){
							btn.button('loading');
							$this.page.bodyContent.bodyText = "";
							$this._setProperties();
							$this._save(function(){
								btn.button('reset');
							});
						}
						return false;
					},
					update : function(e){
						var $this = this, 
						btn = $(e.target);
						$this._setProperties();	
						if( $this.validate() ){			
							console.log('imageLayoutChanged:' + $this.get('imageLayoutChanged') );		
							var completeFn = function(){
									console.log('execute complate ...');									
									btn.button('reset');
									common.ui.listview($("#my-page-listview")).dataSource.read();
									renderTo.modal("hide");
								};	
							if( $this.photo ){
								var listview =  renderTo.find(".image-listview");			
								if( $this.get('imageLayoutChanged')){
									if(isCarouselSlideLayout($this.page)){
										common.ui.CarouselSlide( common.ui.listview( listview ).dataSource.view(), renderTo.find('.modal-dialog'), function(html){
											$this.page.bodyContent.bodyText = html;								
											btn.button('loading');			
											$this._save(completeFn);														
										});										
									}else if (isMasonryLayout($this.page)) {
										common.ui.MasonryLayout( common.ui.listview( listview ).dataSource.view(), renderTo.find('.modal-dialog'), function(html){
											$this.page.bodyContent.bodyText = html;								
											btn.button('loading');			
											$this._save(completeFn);														
										});	
									}														
								}else{
									btn.button('loading');			
									$this._save(completeFn);								
								}
							}else if ($this.text){
								if( editorTo.data('kendoEditor') ){
									$this.page.bodyContent.bodyText = editorTo.data('kendoEditor').value();		
								}	
								btn.button('loading');											
								$this._save(completeFn);
							}else{
								btn.button('loading');											
								$this._save(completeFn);						
							}
						}			
						return false;
					},	
					_setProperties : function(){
						var $this = this;						
						if($this.postType.length > 0){
							$this.page.properties.postType = $this.postType;	
						}
						if($this.page.name.length === 0 && $this.page.title.length > 0 ){
							$this.page.name = $this.page.title;	
						}					
						if( $this.pageSource != null && $this.pageSource.length > 0 ){
							$this.page.properties.source = $this.pageSource;
						} 
						if( $this.pageSourceUrl !=null && $this.pageSourceUrl.length > 0 ){
							$this.page.properties.url = $this.pageSourceUrl;
						}							
						if( $this.page.tagsString != null && $this.page.tagsString.length > 0 ){
							$this.page.properties.tagsString = $this.page.tagsString;
						}				
						if( $this.postType === 'photo' ){						
							$this.page.properties.imageEffect = $this.imageEffect;
							$this.page.properties.imageSort = $this.imageSort;
							$this.page.properties.imageSortDir = $this.imageSortDir;
						}
						if( $this.adultContent ){
							$this.page.properties.adultContent = $this.adultContent ;
						}
					},
					_save : function( callback ){		
						var $this = this;		
						console.log("remote save.");	
						common.ui.ajax( '<@spring.url "/data/pages/update.json?output=json"/>', {
							data : kendo.stringify($this.page) ,
							contentType : "application/json",
							success : function(response){
								if( response.pageId ){
									if( $this.postType === 'photo'){
										if(!$this.get('imageLayoutChanged') && $this.page.pageId == 0){
											$this.set('imageLayoutChanged', true);				
											$this.setSource( new common.ui.data.Page(response) );
										}
									}else if ($this.postType === 'text'){
										if( $this.page.pageId == 0 ){
											$this.setSource( new common.ui.data.Page(response) );
										}
									}else{																
										common.ui.listview($("#my-page-listview")).dataSource.read();
										renderTo.modal('hide');
									}		
								}						
							},
							complete : function(e){
								if( callback )
									callback();
							}							
						});	
					}, 
					setPostType : function(postType){
						var that = this;
						if(postType){
							that.set('postType', postType);	
						}else{
							that.set('postType', "text");
						}				
						that.set("photo", false);
						that.set("text", false);
						that.set("link", false);	
						that.set("quote", false);	
						that.set("followUp", false );						
						if( that.page.pageId > 0 ){
							that.set('editable', true);
							if( that.postType === "photo"){
								that.set("photo", true);
							}else if ( that.postType === "link") {
								that.set("link", true);
							}else if ( that.postType === "quote") {
								that.set("quote", true);
							}else{
								that.set("text", true);	
							}
						}else{
							that.set('editable', false);							
							if ( that.postType === "link") {
								that.set("link", true);
							}else if ( that.postType === "photo") {
								that.set("followUp", true );
							}else if ( that.postType === "quote") {
								that.set("quote", true);
								that.set('editable', true);			
							}else{
								that.set("text", false);	
								that.set("followUp", true );
							}
						}
					},
					setSource: function(page, postType){
						var that = this;
						page.copy(that.page);											
						that.setPostType(that.page.properties.postType||postType); 						
						if( $("#my-page-imagebroswer").data("kendoExtImageBrowser") ) {
							$("#my-page-imagebroswer").data("kendoExtImageBrowser").objectId( that.page.pageId );
						}						
						if(that.page.pageId > 0 ){
							that.set("authorPhotoUrl", that.page.authorPhotoUrl() );							
						}else{
							that.set("authorPhotoUrl", common.ui.accounts().token.photoUrl);							
						}						
						that.set('imageLayoutChanged', false);						
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
						that.set('adultContent', that.page.adultContent());
						console.log("adult content check:" + that.adultContent );										
						if( that.page.properties.imageEffect ){
							that.set('imageEffect', that.page.properties.imageEffect );
						}
						if( that.page.properties.imageSort ){
							that.set('imageSort' , that.page.properties.imageSort );
						}	
						if( that.page.properties.imageSortDir ){
							that.set('imageSortDir' , that.page.properties.imageSortDir );
						}									
						if( that.photo && that.page.pageId > 0 ){						
							if( that.imageSort === null ){	
								that.set("imageSort", "name");
							}	
							if( that.imageSortDir === null ){
								that.set("imageSortDir", "desc");
							}
							var upload = renderTo.find("input[name='photo'][type=file]");		
							var listview =  renderTo.find(".image-listview");								
							if (!common.ui.exists(listview)) {
									common.ui.listview( listview, {
										dataSource : {
											type : 'json',
											transport : {
												read : {
													url : '<@spring.url "/data/images/list.json?output=json"/>',
													type : 'POST'
												},
												parameterMap : function(options, operation) {
													return {
														startIndex : options.skip,
														pageSize : options.pageSize,
														objectType : 31,
														objectId : that.page.pageId
													}
												}
											},
											pageSize : 100,
											error : common.ui.handleAjaxError,
											schema : {
												model : common.ui.data.Image,
												data : "images",
												total : "totalCount"
											},
											//serverSorting : false,
											//sort: {	field: "name", dir:"desc" },
											serverPaging : false,
											change: function(e){
												//console.log("sorting");
												//this.sort({field: that.imageSort, dir: that.imageSortDir});
											}
										},
										autoBind:false,
										selectable : "multiple",
										change : function(e) {	
											var data = this.dataSource.view();	
											 var selectedCells = this.select();	    
											if( selectedCells.length > 0 ){											
												$.each(selectedCells, function( index, value ){
													var idx = $(value).index();
													var item = data[idx];
													//addImageTo(my_selected, item);
												});
												//that._changeState(my_insert_btn, true);					
											}
										},
										navigatable : false,
										template : kendo.template($("#image-broswer-photo-list-view-template").html()),
										dataBound : function(e) {
											console.log("loading from remote");
											//this.refresh();
											//this.dataSource.sort({field: that.imageSort, dir: that.imageSortDir});
											//that.set('imageLayoutChanged', false);
										}
									});
									common.ui.scroll.slim(listview,{height:'300px'});									
									listview.on("mouseenter",".img-wrapper", function(e) {
										kendo.fx($(e.currentTarget).find(".img-description")).expand("vertical").stop().play();
									}).on("mouseleave", ".img-wrapper", function(e) {
										kendo.fx($(e.currentTarget).find(".img-description")).expand("vertical").stop().reverse();
									});									
									renderTo.find("input[type=radio][name=image-sorting], input[type=radio][name=image-sorting-dir]").on("change", function () {						
										common.ui.listview(listview).dataSource.sort({field: that.imageSort, dir: that.imageSortDir});
										that.set('imageLayoutChanged', true);
									});	
									renderTo.find("input[type=radio][name=image-effect]").on("change", function () {
										that.set('imageLayoutChanged', true);
									});									
							}	
							if(!common.ui.exists(upload)){
								common.ui.upload( upload, {
									async : {
										saveUrl:  '<@spring.url "/data/images/update_with_media.json?output=json" />'
									},
									localization:{ select : '사진 선택' , dropFilesHere : '새로운 사진파일을 이곳에 끌어 놓으세요.' },	
									upload: function (e) {				
										e.data = { objectType: 31 , objectId: that.page.pageId };
									},								
									success: function (e) {									
										that.set('imageLayoutChanged', true);			
										common.ui.listview(listview).dataSource.read();
									}
								});
							}								
							common.ui.listview(listview).dataSource.read().then(function(){
								console.log('sorting' + that.imageSort + ", " + that.imageSortDir );
								that.set('imageLayoutChanged', false);
								common.ui.listview(listview).dataSource.sort({field: that.imageSort, dir: that.imageSortDir});
							});							
						}	

						// page properties ... 
						var $grid = $("#my-post-modal-settings .page-props-grid");
						if(that.page.pageId > 0 & !common.ui.exists($grid)){
								common.ui.grid($grid, {				
									//dataSource : common.ui.data.page.properties.datasource(that.page),					
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
												
					},
					uploadImageByUrl: function(e){
						var $this = this, 
						btn = $(e.target);						
						e.preventDefault();	
						var hasError = false;
						if( $this.imageDataUrl == null || $this.imageDataUrl.length == 0 || !common.valid("url", $this.imageDataUrl) ){
							renderTo.find('.upload-by-url .input').eq(1).addClass("state-error");	
							hasError = true;					
						}else{
							renderTo.find('.upload-by-url .input').eq(1).removeClass("state-error");
						}							
						if( !hasError ){
							btn.button('loading');			
							common.ui.data.image.uploadByUrl( {
								data : { objectType : 31, objectId: $this.page.pageId, sourceUrl : $this.imageSourceUrl,  imageUrl : $this.imageDataUrl},
								success : function(response){
									var listview =  renderTo.find(".image-listview");	
									$this.set('imageLayoutChanged', true);				
									common.ui.listview(listview).dataSource.read();	
									$this.set("imageSourceUrl", "");
									$this.set("imageDataUrl", "");
								},
								always : function(){
									btn.button('reset');
								}
							});						
						}
						return false;						
					}
				});		
										
				renderTo.on('show.bs.modal', function(e){		
					var msg = common.ui.options.messages.title.text ;
					if( renderTo.data("model").postType === "photo" ){
						msg = common.ui.options.messages.title.photo;
					}else if (renderTo.data("model").postType === "link") {
						msg = common.ui.options.messages.title.link;					
					}
					renderTo.find("form input[name=title]").attr('placeholder', msg );
				});			
				
				renderTo.on('hide.bs.modal', function(e){					
					renderTo.find("form label[for]").removeClass("state-error");					
					renderTo.find("form em[for]").remove();	
					$('#my-post-modal-settings').collapse('hide');					
				});			
				
				$('#my-post-modal-settings').on('hidden.bs.collapse', function(e){
					$('#my-post-modal-settings-props').collapse('hide');
				});
				
				$('#my-post-modal-settings-props').on('show.bs.collapse', function(e){
					common.ui.grid($("#my-post-modal-settings .page-props-grid")).setDataSource(
						common.ui.data.page.properties.datasource(observable.page)
					);
				});
				
				common.ui.bootstrap.enableStackingModal(renderTo, {'shown.bs.modal': function(e){			
					var switcher = $("#my-post-type-switcher").data('kendoDialogSwitcher');
					if(switcher && switcher.isOpen){
						switcher.close();
					}
				} } );		
				
				createEditor( "my-page" , editorTo, { 
					modal : false , 
					appendTo: $("#my-page-post-editor-code-body"), 
					tab: $("#my-page-post-tabs"), 
					pageSize : 15,
					objectType : 31,
					useWrapMode : observable.useWrapMode 
				});				
				
				kendo.bind(renderTo, observable);
				renderTo.data("model", observable );
			}		
				
			if( page.get("pageId") > 0 && !common.ui.defined( page.bodyContent.bodyText) ){
				console.log("now get remote data.");
				var targetEle = $('.item[data-object-id=' + page.get("pageId") + ']');					
				kendo.ui.progress(targetEle, true);	
				common.ui.ajax( '<@spring.url "/data/pages/get.json?output=json"/>', {
					data : { pageId : page.get("pageId") },
					success: function(response){ 
						renderTo.data("model").setSource(new common.ui.data.Page(response), postType);
						renderTo.modal('show');	
					},
					complete: function(e){
						kendo.ui.progress(targetEle, false);	
					}	
				} );
			}else{
				renderTo.data("model").setSource(page, postType);
				renderTo.modal('show');			
			}
		}		
		<!-- ============================== -->
		<!-- Pool							-->
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
					save : function(e){
						alert( kendo.stringify(this.poll) );					
					},
					setSource : function( source ){
						source.copy( this.poll );
						common.ui.grid($("#my-poll-options-grid")).dataSource.data( this.poll.options );						
					}
				});								
				renderTo.data("model", observable);				
				kendo.bind(renderTo, observable );
				
				$("button[data-action=create][data-object-type=40], a[data-action=create][data-object-type=40]").click(function(e){
					openMyPollModal(new common.ui.data.Poll());
				});
				
				var grid = common.ui.grid($("#my-poll-options-grid"), {
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
						width: 50,
						field: 'optionId',
						title: "ID"},{
						field: 'optionText',
						title: "내용"},
						{ command: [{ name : "edit" , text : {edit:"변경", update:"확인", cancel:"최소" }  }, {name:"destroy", text: "삭제" }], title: "&nbsp;", width: "250px" }				
					],
					editable: "inline"
				});
				grid.table.kendoSortable({
					filter: ">tbody >tr",
					hint: $.noop,
					cursor: "move",
					placeholder: function(element) {
						return element.clone().addClass("k-state-hover").css("opacity", 0.65);
					},
					container: "#my-poll-options-grid tbody",
					change: function(e) {
						var skip = grid.dataSource.skip(),
						oldIndex = e.oldIndex + skip,
						newIndex = e.newIndex + skip,
						data = grid.dataSource.data(),
						dataItem = grid.dataSource.getByUid(e.item.data("uid"));
						grid.dataSource.remove(dataItem);
						grid.dataSource.insert(newIndex, dataItem);
					}
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
		<!-- Page ListView  				-->
		<!-- ============================== -->			
		function getMyPageOwnerId(){
			return $("#my-page-source-list input[type=radio][name=radio-inline]:checked").val();			
		}
		
		function getMyPageState(){
			var pageStateVal = $("input[name='page-list-view-filters']:checked").val();
			if( common.ui.defined(pageStateVal))
				return pageStateVal;	
			else
				return "PUBLISHED";
					
		}
		
		function createMyPageListView(){		
			var renderTo = $("#my-page-listview");
			if( !renderTo.data('masonry')){			
				renderTo.masonry({	
					columnWidth: '.item',
					//gutter: 10,
					itemSelector: '.item',
					isResizable:true,
					transitionDuration: 0
				});
			}								
			if( !common.ui.exists( renderTo ) ){
				var masonry = renderTo.data('masonry');					
				common.ui.listview( renderTo, {
					dataSource: {
						transport: { 
							read: { url:'<@spring.url "/data/pages/list.json?output=json"/>', type: 'POST' },
							parameterMap: function (options, type){
								return { startIndex: options.skip, pageSize: options.pageSize,  objectType: getMyPageOwnerId() , full:false, state:  getMyPageState()}
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
						serverFiltering: true,
						serverPaging: true,
						filter: {
							field: "pageState", operator: "eq", value: "PUBLISHED"
						}
					},
					template: kendo.template($("#my-page-listview-template").html()),
					dataBound: function(e){		
						var elem = 	this.element.children();	
						elem.imagesLoaded(function(){
							console.log("image loaded..."):
							masonry.appended(elem);
							masonry.layout();
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
						createPageViewModal(item);
						break;		
						case 'edit':						
						createPagePostModal(item);
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
				updatePageState( page , function(hasError){
					if( common.ui.defined( target )){	
						target.button('reset');	
					}
					console.log("hasError:"+hasError);
					if( !hasError )
						common.ui.listview( $("#my-page-listview") ).dataSource.read();									
				});				
			}else{
				alert("게시할 수 없습니다.");	
			}
			return false;					
		}  
		<!-- ============================== -->
		<!-- Page View Modal				-->
		<!-- ============================== -->								
		function createPageViewModal(source){	
			var renderTo = $("#my-page-view-modal");	
			if( !renderTo.data('bs.modal') )
			{
				var observable =  common.ui.observable({
					page : new common.ui.data.Page(),
					pageSource : "",
					pageSourceUrl : "",
					editable : false,
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
					setSource: function(page){
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
					console.log("masonry layout :" + isMasonryLayout( renderTo.data("model").page ) );
					if(	isMasonryLayout(renderTo.data("model").page) ){
						console.log('masonry layout creating...');
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
			if( source.get("pageId") > 0 && !common.ui.defined( source.bodyContent.bodyText) ){
				console.log("now get remote data.");
				var targetEle = $('.item[data-object-id=' + source.get("pageId") + ']');					
				kendo.ui.progress(targetEle, true);	
				common.ui.ajax( '<@spring.url "/data/pages/get.json?output=json"/>', {
					data : { pageId : source.get("pageId") },
					success: function(response){ 
						renderTo.data("model").setSource(new common.ui.data.Page(response));
						renderTo.modal('show');	
					},
					complete: function(e){
						kendo.ui.progress(targetEle, false);	
					}	
				} );
			}
		}		
					
					
					
					
						
		function createMyPageViewer2(source){	
			var renderTo = $("#my-page-viewer");			
			if( ! common.ui.exists(renderTo) ){
				var observable =  common.ui.observable({
					page : new common.ui.data.Page(),
					pageSource : "",
					pageSourceUrl : "",
					editable : false,
					close:function(e){
					    common.ui.dialog( renderTo ).close();
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
				renderTo.data("model", observable);	
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
						$("body").css("overflow-y", "auto");		
					}
				});	
			}
			var dialogFx = common.ui.dialog( renderTo );	
			if( !dialogFx.isOpen ){				
				console.log("now get remote data.");
				var targetEle = $('.item[data-object-id=' + source.get("pageId") + ']');					
				kendo.ui.progress(targetEle, true);	
				common.ui.ajax( '<@spring.url "/data/pages/get.json?output=json"/>', {
					data : { pageId : source.get("pageId") },
					success: function(response){ 
						renderTo.data("model").setPage(new common.ui.data.Page(response));			
						dialogFx.open();
					},
					complete: function(e){
						kendo.ui.progress(targetEle, false);	
					}	
				} );				
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
			top: 10px;
			right: 10px;
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
			//background-color: #fafafa;
			border-bottom: 1px dashed #e4e4e4;
			background-color:#f3f3f3!important;
			//border-top-left-radius: 8px!important;
			//border-top-right-radius: 8px!important;				
		}
		
		#my-page-pager {
			border:0;
			border-top:1px dashed #e4e4e4;
			padding : 10px;
			background-color:#f3f3f3!important;
			//background-color : #fafafa;
			//border-bottom-left-radius: 8px!important;
			//border-bottom-right-radius: 8px!important;						
		}
		#my-page-viewer .k-grid-content {
			min-height: 150px;		
		}
		#my-page-listview {
			min-height : 280px;
		}
		#my-page-listview .ibox {
			border-radius: 0 0 6px 6px!important;
			overflow: hidden;	
			//border: 1px solid #e7eaec;
		}
		#my-page-listview .item {
			//width:265px;
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

		.k-grid tbody tr {
			 cursor: move;
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
						<li><a href="#" data-action="post" data-object-type="31">만들기</a></li>
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
										<!--<label class="radio"><input type="radio" name="radio-inline" value="30" ><i class="rounded-x"></i>  ${action.webSite.displayName}</label> -->
									</div>
								</section>							
							</div>
							<div class="col col-md-6">
								<section>
									<label class="label"> 상태 필터</label>							
									<div class="btn-group btn-group-sm" data-toggle="buttons" id="attachment-list-filter">
										<label class="btn btn-success  rounded-left">
										<input type="radio" name="page-list-view-filters"  value="NONE"> 전체 </span>)
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
			
		<!-- Page Edit Modal -->
		
		<div id="my-page-post-modal" role="dialog" class="modal fade" data-backdrop="static">
			<div class="modal-dialog modal-lg">
				<div class="modal-content my-page-post-form">
					<div class="modal-header">
						<div class="author">
							<img data-bind="attr:{src:authorPhotoUrl}" style="margin-right:10px;">
						</div>
						<span class="hvr-pulse-shrink collapsed" data-modal-settings data-toggle="collapse" data-target="#my-post-modal-settings" area-expanded="false" aria-controls="my-post-modal-settings"><i class="icon-flat icon-flat settings"></i></span>
						<button aria-hidden="true" data-dismiss="modal" class="close" type="button"></button>
					</div>
					<form id="my-post-modal-settings" action="#" class="sky-form modal-settings collapse">
						<header>
							고급옵션
							<span class="close" style="right:0;" data-toggle="collapse" data-target="#my-post-modal-settings" aria-expanded="false" aria-controls="my-post-modal-settings"></span>
						</header>
						<fieldset>                  
							<section>
								<div class="separator-2"></div>
								<label class="label">파일</label>	
								<label class="input">
									<input type="text" name="name" placeholder="파일 이름을 입력하세요." data-bind="value: page.name">
								</label>
							</section>										
							<section>
								<label class="label">요약</label>	
								<label class="textarea textarea-expandable">
									<textarea rows="4" name="summary" placeholder="조금 더 자세하게 알려 주세요" data-bind="value: page.summary"></textarea>
								</label>
							</section>
							<section>
								<label class="label">테그</label>
								<label class="input">
									<i class="icon-append fa fa-tag text-info"></i>
									<input type="text" name="tags" data-bind="value:page.tagsString">
								</label>
								<div class="note"><strong>Note:</strong>공백으로 라벨을 구분하세요</div>
							</section>
							<section>
								<label class="label">출처</label>
								<label class="input">
									<input type="text" name="source" placeholder="출처 이름을 입력하세요." data-bind="value: pageSource">
								</label>
								<label class="input">
									<i class="icon-append fa fa-globe text-info"></i>
									<input type="text" name="url" placeholder="출처 URL를 입력하세요." data-bind="value: pageSourceUrl">
								</label>		
								<div class="note"><strong>Note:</strong> 저작권자의 출처 정보를 입력하세요</div>	
							</section>	
							<section>
                           		<label class="label">성인 콘텐츠</label>
                           		<div class="inline-group">
                               		<label class="checkbox text-danger"><input type="checkbox" name="page-post-checkbox-adultContent" data-bind="checked:adultContent" value="true" >
                               			<i></i>
                               			<span class="text-danger small">19세 미만의 청소년에게 부적절한 내용</span>
                               		</label>   
                            	</div>
                            	<div class="note">체크한 경우 방문자에게 경고 메시지가 표시됩니다.</div>	
                        	</section>							
						</fieldset>
						<fieldset data-bind="visible:editable">
							<section class="text-right">
								<button class="btn btn-flat btn-labeled btn-primary btn-sm rounded" type="button" data-toggle="collapse" data-target="#my-post-modal-settings-props" aria-expanded="false" aria-controls="my-post-modal-settings-props">
									<span class="btn-label icon fa fa-table"></span> 속성 
								</button>
							</section>				  
							<div class="collapse" id="my-post-modal-settings-props" aria-expanded="true">
								<div class="separator-2"></div>
							  	<div class="page-props-grid"/>
							</div>
						</fieldset>
												
					</form>
					<form action="#" class="sky-form">
						<fieldset>
							<section>
								<!--<label class="label">주제 <span data-bind="text:postType"></span></label>-->
								<p class="text-right text-danger small" data-bind="visible:editable">마지막 업데이트 일자 : <span data-bind="{ text: page.formattedModifiedDate }"></span></p>
								<label class="input" for="title">
									<i class="icon-append fa fa-asterisk"></i>
									<input type="text" name="title" placeholder="무엇에 대한 사진인가요?" data-bind="value:page.title, events:{keypress: keypress}">
								</label>
							</section>
							<section data-bind="visible:quote">
								<div class="quote" data-role="editor" data-tools="['bold', 'italic', 'underline', 'formatting', 'cleanFormatting', 'createLink', 'unlink']" data-bind="value:page.bodyContent.bodyText" >
								</div>
							</section>
							<section data-bind="visible:text">
								<!-- Nav tabs -->																	
								<ul class="nav nav-pills" role="tablist" id="my-page-post-tabs">
									<li role="presentation" class="m-l-sm active"><a href="#my-page-post-tabs-html" aria-controls="my-page-post-tabs-html" data-action-target="editor"  role="tab" data-toggle="tab">글쓰기</a></li>
									<li role="presentation"><a href="#my-page-post-tabs-code" aria-controls="my-page-post-tabs-code" data-action-target="ace" role="tab" data-toggle="tab">코드</a></li>
								</ul>	
								<!-- Tab panes -->
								<div class="tab-content no-padding">
									<div role="tabpanel" class="tab-pane active" id="my-page-post-tabs-html">
										<textarea id="my-page-post-editor" class="no-border" data-bind='value:page.bodyContent.bodyText' style="height:500px;"></textarea>
									</div>
									<div role="tabpanel" class="tab-pane" id="my-page-post-tabs-code">
										<div class="page-editor-options">
											<label class="toggle">
												<input type="checkbox" name="checkbox-toggle" data-bind="checked: useWrapMode, events: { change: useWrap }"><i class="rounded-4x"></i>줄바꿈 설정/해지</label>
										</div>
										<div id="my-page-post-editor-code-body" class="m-t-xs"></div>
									</div>
								</div>							
							</section> 
							<!-- photo -->
							<section data-bind="visible:photo">
								<div class="row">
									<div class="col-sm-6">										
										<div class="image-listview"></div>
									</div>
									<div class="col-sm-6 upload-by-url">	
										<div class="separator-2"></div>
										<p class="text-primary">사진선택 버튼을 클릭하여 사진을 직접 선택하거나, 사진을 끌어 놓기(Drag&Dorp)를 하세요.</p>								
										<input type="file" name="photo" />
										<div class="m-t-lg">
											<div class="separator-2"></div>
											<p class="text-primary">출처와 URL을 입력하세요.</p>
											<label class="input"><i class="icon-append fa fa-globe"></i>
											<input type="url" name="imageSourcUrl" placeholder="출처 URL" data-bind="value:imageSourceUrl"/>
											</label>
											<label class="input"><i class="icon-append fa fa-globe"></i>
											<input type="url" name="imageDataUrl" placeholder="이미지 URL" data-bind="value:imageDataUrl"/>
											</label>
			
											<button class="btn btn-flat btn-labeled btn-warning btn-sm rounded" type="button" data-bind="events:{click: uploadImageByUrl }" data-loading-text="<i class='fa fa-spinner fa-spin'></i>">
												<span class="btn-label icon fa fa-upload"></span> 업로드 
											</button>
								<!--
											<button type="button" class="btn btn-warning btn-flat rounded" data-bind="events:{click: uploadImageByUrl }" data-loading-text="<i class='fa fa-spinner fa-spin'></i>" >업로드</button>											
								-->
										</div>
									</div>
								</div>
								<div class="image-layout m-t-md">
									<div class="row">
										<div class="col-sm-6">
									    	<label class="label">Effect</label>
					                        <div class="inline-group">	
					                            <label class="radio"><input type="radio" name="image-effect" value="masonry" data-bind="checked: imageEffect" ><i class="rounded-x"></i>Mansory</label>
					                            <label class="radio"><input type="radio" name="image-effect" value="carousel" data-bind="checked: imageEffect"><i class="rounded-x"></i>Carousel Slide</label>
					                        </div>									
										</div>										
										<div class="col-sm-6">
										    <label class="label">정렬 </label>
										    <div class="row">
										    	<div class="col-xs-6">
											    	<div class="inline-group">	
						                                <label class="radio"><input type="radio" name="image-sorting" value="name" data-bind="checked: imageSort" ><i class="rounded-x"></i>이름</label>
						                                <label class="radio"><input type="radio" name="image-sorting" value="creationDate" data-bind="checked: imageSort" ><i class="rounded-x"></i>날짜 </label>
						                            </div>	
										    	</div>
										    	<div class="col-xs-6">
											    	<div class="btn-group btn-group-sm pull-right" data-toggle="buttons">
						                             	<label class="btn btn-default btn-flat btn-outline rounded-left">
						                            		<input type="radio" name="image-sorting-dir" value="asc" data-bind="checked: imageSortDir" />
						                            		ASC
						                            	</label>
						                            	<label class="btn btn-default btn-flat btn-outline rounded-right">
						                            		<input type="radio" name="image-sorting-dir" value="desc" data-bind="checked: imageSortDir"/>
						                            		DESC
						                            	</label>
						                            </div>	
										    	</div>
										    </div>				
										</div>
									</div>
								</div>	
							</section>
							<!-- /.photo -->
						</fieldset>
					</form>
					<div class="modal-footer">
						<button data-dismiss="modal" class="btn btn-flat btn-outline pull-left rounded" type="button">닫기</button>
						<button class="btn btn-flat btn-info rounded btn-outline" type="button" data-action="create" data-bind="{visible:followUp, click:create}" data-loading-text="<i class='fa fa-spinner fa-spin'></i>">다음</button>
						<button class="btn btn-flat btn-primary rounded" type="button" data-bind="enabled:editable, click:update" data-loading-text="<i class='fa fa-spinner fa-spin'></i>">저장 </button>
					</div>
				</div>								
			</div>	
		</div>	
		
		<div id="my-page-view-modal" role="dialog" class="modal fade" data-backdrop="static" data-effect="zoom">
			<div class="modal-dialog modal-lg">
				<div class="modal-content my-page-view-form">	
					<div class="modal-header">
						<h2 data-bind="{text: page.title}"></h2>
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
						<div data-bind="{html:page.bodyContent.bodyText}" class="atricle"></div>
					</div>
				</div>
			</div>
		</div>	

		<div id="my-page-viewer" class="dialog dialog-full bg-glass" data-feature="dialog" data-dialog-animate="">
			<div class="dialog__overlay"></div>
			<div class="dialog__content">
			
				<div class="modal-dialog modal-lg ">
					<div class="modal-content my-page-view-form">			
						<div class="modal-header">
							<h2 data-bind="{text: page.title}"></h2>
							<span class="hvr-pulse-shrink collapsed" data-modal-settings data-toggle="collapse" data-target="#my-post-modal-settings" area-expanded="false" aria-controls="my-post-modal-settings"><i class="icon-flat icon-flat settings"></i></span>
							<button aria-hidden="true" data-dialog-close class="close" type="button"></button>
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
							<div data-bind="{html:page.bodyContent.bodyText}" class="atricle"></div>
						</div>				
					</div>
				</div>	
				
			</div>
	</div>	
						
		<div id="my-post-type-switcher" class="dialog-switcher" >		
			<div class="dialog-switcher-content">
				<div class="container">
					<span class="close close-white" data-dialog-close  aria-label="Close"></span>
					<div class="row ">
					
						<div class="col-md-3 col-sm-4 col-xs-6 content-boxes-v6 color-flat-sky">
							<button class="btn-link hvr-pulse-shrink" type="button" data-post-type="text">
								<i class="rounded-x fa fa-font fa-3x"></i>
							</button>
							<p>생각나는 것을 기록하고, 공유하세요.</p>
						</div>			
						<div class="col-md-3 col-sm-4 col-xs-6 content-boxes-v6 color-flat-lime">
							<button class="btn-link hvr-pulse-shrink" type="button" data-post-type="quote">
								<i class="rounded-x fa fa-quote-left fa-3x"></i>
							</button>
							<p>읽으면 힘이되는 좋을 글들을 공유하세요.</p>
						</div>							
						<div class="col-md-3 col-sm-4 col-xs-6 content-boxes-v6 color-flat-red">
							<button class="btn-link hvr-pulse-shrink" type="button" data-post-type="photo">
								<i class="rounded-x fa fa-camera-retro fa-3x"></i>
							</button>
							<p>사진을 저장하고, 공유하세요.</p>
						</div>			
						<div class="col-md-3 col-sm-4 col-xs-6 content-boxes-v6 color-flat-green\">
							<button class="btn-link hvr-pulse-shrink" type="button" data-post-type="link">
								<i class="rounded-x fa fa-link fa-3x"></i>
							</button>
							<p>관심있는 웹 페이지를 저장하고, 공유하세요.</p>
						</div>
					</div>
				</div>
			</div>		
		</div>
		
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
								<span class="close" style="right:0;" data-toggle="collapse" data-target="#my-poll-modal-settings" aria-expanded="true" aria-controls="my-poll-modal-settings"></span>
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
									<div id="my-poll-options-grid"></div>
								</div>								
							</fieldset>			
							<footer>
								<button type="button" class="btn-u" data-bind="click:save">완료</button>
							</footer>						
						</form>
					</div>
				</div>
			</div>
		</div>		
		

	<!-- START TEMPLATE -->				
	<script id="my-page-listview-template" type="text/x-kendo-template">
	<div class="item col-sm-3" style="display:none;" data-object-id="#=pageId#">
	<div class="ibox summary float-e-margins">
		<div class="ibox-title cover">
		# if (bodyContent.imageCount > 0){ #
		<img class="img-responsive #if(pageState ===  'DELETED' ){# grayscale #}#" src="#=bodyContent.firstImageSrc#" alt="">
		#}#
		# if (adultContent()){ #
			<span class="label label-danger rounded-3x" style="left: 0;right: inherit;">19+</span>
		# } #
		#if ( pageState === "PUBLISHED" ) { #
			<span class="label label-success">#: pageState #</span>
		#}else if( pageState === "DELETED" ) {# 
			<span class="label label-default">#: pageState #</span> 
		#}else{# 
			<span class="label label-danger">#: pageState #</span> 
		#}#
			<div class="hover-mask"></div>
		</div>
		<div class="ibox-content">			
			#if( pageState !=  'DELETED' ){#<h2><a href="\\#" data-action="view" data-object-id="#=pageId#">#:title#</a></h2>#}else{#
			<h2 class="text-muted">#:title#</a></h2>
			#}#
			<div class="page-meta no-margin-hr">
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
			<p class="page-tags" ><i class="fa fa-tags"></i> #: tagsString #</p>
			#}#
			#if (summary!= null) {#
			<p class="page-description">#: summary #</p>
			#}#
			</div>
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
				<span class="label label-success">#: status #</span>
			</div>
			<div class="col-xs-7 content no-top-border">
					<p class="m-b-xs"><strong>#: name #</strong></p>
					#if(description!=null){#<p class="text-muted m-b-xs"><small>#: description #</small></p>#}#
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