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
			'css!<@spring.url "/styles/jquery.sky-forms/2.0.1/custom-sky-forms.css"/>',	
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
				
				setupPersonalizedSection();			
				createPageSection();
				// END SCRIPT 				
			}
		}]);			

		<!-- ============================== -->
		<!-- Page														-->
		<!-- ============================== -->
		function getMyPageSource(){
			return $("#page-source-list input[type=radio][name=page-source]:checked").val();			
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
						/*
						setPageEditorSource(selectedCell);
						if( selectedCell.pageId > 0 ){
							if( selectedCell.pageState === 'PUBLISHED' )
								$('button.btn-page-control-group[data-action="page-delete"]').removeAttr("disabled");
							else
								$('button.btn-page-control-group').removeAttr("disabled");
						}
						*/
 					} 						
				},
				dataBound: function(e){		
					$("button.btn-page-control-group").attr("disabled", "disabled");
				}			
			} );		
			
			$("#page-source-list input[type=radio][name=page-source]").on("change", function () {
					common.ui.grid(renderTo).dataSource.read();	
			});				
			
			$("#my-page-view span.back").click(function(e){
				
				$("#my-page").one( "webkitAnimationEnd oanimationend msAnimationEnd animationend", function(e) {
					$("#my-page").removeClass("compose out");
				});	
				$("#my-page").addClass("out");	
				//$("#my-page").toggleClass("compose");						
			});
		}
		
		
		function doPageEdit(){		
			$("#my-page").toggleClass("compose");			
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
			-webkit-animation-name: zoomOut;
			animation-name: zoomOut;
			height:0px;			
		} 

		#my-page.compose .details  {
			-webkit-animation-name: fadeInUp;
			animation-name: fadeInUp;		
			opacity: 1;
			visibility: visible;		
			height:auto;		
		} 
		
		#my-page.compose.out .master  {
			-webkit-animation-name: zoomIn;
			animation-name: zoomIn;		
			opacity: 1;
			visibility: visible;
			height:auto;						
		}

		#my-page.compose.out .details  {
			opacity: 0;
			visibility: hidden;		
			height:0px;				
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
			<section class="personalized-section bg-transparent no-margin-b open" >
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
				<div class="personalized-section-content animated arrow-up">	
					<div class="container" style="min-height:150px;">
						<div class="row p-sm">
							<div id="my-page">
								<div id="my-page-list" class="master animated">
									<div class="p-xxs">
										<div class="btn-group" data-toggle="buttons" id="page-source-list">
											<label class="btn btn-sm btn-danger rounded-left active">
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
									<div id="my-page-grid"></div>
								</div><!-- /.my-page-list -->
								<div id="my-page-view" class="details animated bg-dark">
									<span class="back"></span>
									
									
									<form action="" id="sky-form" class="sky-form" novalidate="novalidate">
                    <header>&nbsp;</header>
                    
                    <fieldset>
                        <section>
                            <label for="file" class="input">
                                <input type="text" name="address" placeholder="제목">
                            </label>
                        </section>
                        
                        <section>
                            <label class="textarea">
                                <textarea rows="3" name="info" placeholder="요약"></textarea>
                            </label>
                        </section>
                    </fieldset>
                                        
                    <fieldset>                  
                        <div class="row">
                            <section class="col col-6">
                                <label class="input">
                                    <i class="icon-prepend fa fa-user"></i>
                                    <input type="text" name="fname" placeholder="템플릿 경로">
                                </label>
                            </section>
                            <section class="col col-6">
                                <label class="input">
                                    <i class="icon-prepend fa fa-user"></i>
                                    <input type="text" name="lname" placeholder="Last name">
                                </label>
                            </section>
                        </div>
                        
                        <div class="row">
                            <section class="col col-6">
                                <label class="input">
                                    <i class="icon-prepend fa fa-envelope"></i>
                                    <input type="email" name="email" placeholder="E-mail">
                                </label>
                            </section>
                            <section class="col col-6">
                                <label class="input">
                                    <i class="icon-prepend fa fa-phone"></i>
                                    <input type="tel" name="phone" placeholder="Phone">
                                </label>
                            </section>
                        </div>
                    </fieldset>
                    

                    
                    <fieldset>
                        <section>
                            <div class="inline-group">
                                <label class="radio"><input type="radio" name="radio-inline" checked=""><i class="rounded-x"></i>Visa</label>
                                <label class="radio"><input type="radio" name="radio-inline"><i class="rounded-x"></i>MasterCard</label>
                                <label class="radio"><input type="radio" name="radio-inline"><i class="rounded-x"></i>PayPal</label>
                            </div>
                        </section>                  
                        
                        <section>
                            <label class="input">
                                <input type="text" name="name" placeholder="Name on card">
                            </label>
                        </section>
                        
                        <div class="row">
                            <section class="col col-10">
                                <label class="input">
                                    <input type="text" name="card" id="card" placeholder="Card number">
                                </label>
                            </section>
                            <section class="col col-2">
                                <label class="input">
                                    <input type="text" name="cvv" id="cvv" placeholder="CVV2">
                                </label>
                            </section>
                        </div>
                        
                        <div class="row">
                            <label class="label col col-4">Expiration date</label>
                            <section class="col col-5">
                                <label class="select">
                                    <select name="month">
                                        <option value="0" selected="" disabled="">Month</option>
                                        <option value="1">January</option>
                                        <option value="1">February</option>
                                        <option value="3">March</option>
                                        <option value="4">April</option>
                                        <option value="5">May</option>
                                        <option value="6">June</option>
                                        <option value="7">July</option>
                                        <option value="8">August</option>
                                        <option value="9">September</option>
                                        <option value="10">October</option>
                                        <option value="11">November</option>
                                        <option value="12">December</option>
                                    </select>
                                    <i></i>
                                </label>
                            </section>
                            <section class="col col-3">
                                <label class="input">
                                    <input type="text" name="year" id="year" placeholder="Year">
                                </label>
                            </section>
                        </div>
                    </fieldset>
                    
                    <footer>
                        <button type="submit" class="btn-u">Continue</button>
                    </footer>
                </form>
										
							
								
								
								
								
								</div><!-- /.my-page-view -->
							</div><!-- /.my-page -->
						</div><!-- /.row -->
					</div><!-- /.container -->
				</div>				
			</section><!-- /.section -->
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
	<script id="webpage-title-template" type="text/x-kendo-template">
		#: name #</span>
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