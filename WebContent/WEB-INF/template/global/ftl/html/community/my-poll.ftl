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
			'css!<@spring.url "/styles/bootstrap.common/color-icons.css"/>',	
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
				createMyPollListView();
				// END SCRIPT 				
			}
		}]);			

		<!-- ============================== -->
		<!-- Utils			 				-->
		<!-- ============================== -->			
		function getMyPollOwnerId(){
			return $("#my-poll-source-list input[type=radio][name=radio-inline]:checked").val();			
		}
		
		function getMyPollState(){
			var pollStateVal = $("input[name='poll-list-view-filters']:checked").val();
			if( common.ui.defined(pollStateVal))
				return pollStateVal;	
			else
				return "ALL";
					
		}			
		<!-- ============================== -->
		<!-- Poll ListView					-->
		<!-- ============================== -->		
		function createMyPollListView( ){					
			var renderTo = $("#my-poll-listview");
			if( !common.ui.exists( renderTo )){	
				common.ui.listview( renderTo, {
					dataSource: {
						transport: { 
							read: { url:'<@spring.url "/data/polls/list.json?output=json"/>', type: 'POST' },
							parameterMap: function (options, type){
								//alert( kendo.stringify( options ) );
								return { startIndex: options.skip, pageSize: options.pageSize,  objectType: getMyPollOwnerId(), status : getMyPollState() }
							}
						},
						requestStart: function(e){				
						},
						schema: {
							total: "totalCount",
							data: "items",
							model: common.ui.data.Poll
						},
						selectable: false,
						serverFiltering: true,
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

				$("#my-poll-source-list input[type=radio][name=radio-inline]").on("change", function () {						
					common.ui.listview(renderTo).dataSource.read();	
				});	

				$("input[name='poll-list-view-filters']").on("change", function () {
					var pageState = this.value;
					if( pageState == 'ALL' ){
						common.ui.listview(renderTo).dataSource.filter({}); 
					}else{
						common.ui.listview(renderTo).dataSource.filter({ field: "pageState", operator: "eq", value: pageState}); 
					}
				});	
								
				$("#my-poll-listview").on( "click", "a[data-action=edit], button[data-action=edit]",  function(e){		
					$this = $(this);		
					var objectId = $this.data("object-id");	
					var item = common.ui.listview(renderTo).dataSource.get(objectId);
					createPollPostModal(item);
				});		
				$("#my-poll-listview").on( "click", "a[data-action=view], button[data-action=view]",  function(e){		
					$this = $(this);		
					var objectId = $this.data("object-id");	
					var item = common.ui.listview(renderTo).dataSource.get(objectId);
					createPollViewModal(item);
				});		
				$("#my-poll-listview").on( "click", "a[data-action=comment], button[data-action=comment]",  function(e){		
					$this = $(this);		
					var objectId = $this.data("object-id");	
					var item = common.ui.listview(renderTo).dataSource.get(objectId);
					createPollCommentary(item);
				});						
				// event for new page
				$("button[data-action=create][data-object-type=40], a[data-action=create][data-object-type=40]").click(function(e){
					var poll = new common.ui.data.Poll();				
					createPollPostModal(poll);
				});		
			}	
		}

		function createPollViewModal(source){	
			var renderTo = $("#my-poll-view-modal");	
			if( !renderTo.data('bs.modal') )	
			{
				var observable =  common.ui.observable({
					poll : new common.ui.data.Poll(),
					voteCount : 0,
					pollOptionStats:[], 
					vote : function(e){
						var $this = this,
						btn = $(e.target);
						var inputEl = $(".my-poll-view-form ul input[name=my-poll-option]:checked");
						if( common.ui.defined(inputEl) ){						
							var myVote = new common.ui.data.Vote({ pollId : $this.poll.pollId, optionId : inputEl.val() });		
							common.ui.ajax( '<@spring.url "/data/polls/vote_allowed.json?output=json"/>', {
								data : common.ui.stringify(myVote),
								contentType : "application/json",
								success : function(response){ 
									if( response.success ){
										btn.button('loading');		
										common.ui.ajax( '<@spring.url "/data/polls/vote.json?output=json"/>', {
											data : common.ui.stringify(myVote),
											contentType : "application/json",
											complete : function(e){ 
												btn.button('reset');
											}							
										});		
									}else{
										alert("이미 참여 하였거나 대상자가 아닙니다.");
									}
								}							
							});
						}	
						return false;
					},
					setSource: function(poll){
						var that = this;
						poll.copy(that.poll);													
					}
				});				
				renderTo.on('shown.bs.modal', function(e){		
					
				});				
				kendo.bind(renderTo, observable );
				renderTo.data("model", observable);	
			}			
			if( source.get("pollId") > 0 ){
				console.log("now get remote data.");				
				var targetEle = $('.poll[data-object-id=' + source.get("pollId") + ']');					
				kendo.ui.progress(targetEle, true);					
				common.ui.ajax( '<@spring.url "/data/polls/stats/get.json?output=json"/>', {
					data : { pollId : source.get("pollId") },
					success: function(response){ 
						renderTo.data("model").setSource(new common.ui.data.Poll(response.poll));
						renderTo.data("model").set("voteCount", response.voteCount);
						renderTo.data("model").set("pollOptionStats", response.pollOptionStats );
						renderTo.modal('show');	
					},
					complete: function(e){
						kendo.ui.progress(targetEle, false);	
					}	
				} );				
			}
		}	
				
		function createPollPostModal(source){
			var renderTo = $("#my-poll-post-modal");	
			if( !renderTo.data('bs.modal') )
			{
				var observable =  common.ui.observable({ 
					poll : new common.ui.data.Poll(),
					editable : false,
					followUp : false,
					visible : true,
					authorPhotoUrl : "/images/common/no-avatar.png",
					create : function(e){
						var $this = this, 
						btn = $(e.target);
						var completeFn = function(){
							console.log('execute create ...');									
							btn.button('reset');
						};
						btn.button('loading');
						if( $this.poll.objectType === 0 )
							$this.poll.objectType = getMyPollOwnerId();						
						$this.saveOrUpdate(completeFn);					
					},
					update : function(e){
						var $this = this, 
						btn = $(e.target);
						var completeFn = function(){
							console.log('execute update ...');									
							btn.button('reset');
						};
						btn.button('loading');
						$this.saveOrUpdate(completeFn);
					},
					saveOrUpdate : function(callback){
						var $this = this;
						common.ui.ajax( '<@spring.url "/data/polls/update.json?output=json"/>', {
							data : kendo.stringify($this.poll) ,
							contentType : "application/json",
							success : function(response){
								$this.setSource( new common.ui.data.Poll(response) );						
							},
							complete : function(e){
								if( callback )
									callback();
							}							
						});					
					},
					setSource : function( source ){
						source.copy( this.poll );	
						var listview = $("#my-poll-options-grid");	
						if( this.poll.pollId > 0 ){
							this.set('editable', true);
							this.set('followUp', false);
							this.set("authorPhotoUrl", this.poll.authorPhotoUrl() );
							
							if (!common.ui.exists(listview)) {								
								common.ui.grid(listview, {
									dataSource : new kendo.data.DataSource({ 
										data: observable.poll.options,
										batch: true,
										schema:{
											model: common.ui.data.PollOption
										}
									}),			
									toolbar: kendo.template('<div class="p-xs"><div class="btn-group"><a href="\\#"class="btn btn-primary btn-flat btn-outline k-grid-add">추가</a><a href="\\#"class="btn btn-primary btn-flat btn-outline k-grid-save-changes">저장</a><a href="\\#"class="btn btn-primary  btn-flat btn-outline k-grid-cancel-changes">취소</a></div><button class="btn btn-info rounded btn-flat btn-outline m-l-sm pull-right" data-action="refresh">새로고침</button></div>'), 
									columns:[
										{width: 100,field: 'optionIndex', title: "인덱스", format: "{0:n0}"},
										{field: 'optionText',title: "내용"},
										{ command: { name: "destroy", template:'<a href="\\#" class="btn btn-sm btn-labeled btn-danger rounded k-grid-delete"><span class="btn-label icon fa fa-trash"></span> 삭제</a>' },  title: "&nbsp;", width: 80 }				
									],
									editable: true
								});
								listview.find("button[data-action=refresh]").click(function(e){
									common.ui.grid(listview).dataSource.read();
									return false;
								});
							}
							
							common.ui.grid(listview).setDataSource(common.ui.data.poll.options.datasource(this.poll));
							
						}else{
							this.set('editable', false);
							this.set('followUp', true);
							this.set("authorPhotoUrl", common.ui.accounts().token.photoUrl);	
							this.poll.endDate.setMonth(this.poll.startDate.getMonth()+1); 
							this.poll.expireDate.setMonth(this.poll.endDate.getMonth()+1); 
						}						
						
					}
				});								
				renderTo.data("model", observable);				
				kendo.bind(renderTo, observable );
			}
			renderTo.data("model").setSource(source);
			renderTo.modal('show');	
		}
		
		<!-- ============================== -->
		<!-- Commentary						-->
		<!-- ============================== -->			
		function createPollCommentary(source){
			var renderTo = $("#my-poll-commentary");	
			
			if( !common.ui.exists(renderTo) ){
				var listview = common.ui.listview($("#my-poll-commentary-listview"), {
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
					template: kendo.template($("#my-poll-commentary-listview-template").html()),
					autoBind: false
				});	
				
				var observable =  common.ui.observable({
					poll : new common.ui.data.Poll(),
					authorPhotoUrl : "/images/common/no-avatar.png",
					coverPhotoUrl : "",
					commentBody : "",
					comment : function(e){
						var $this = this;
						btn = $(e.target);						
						btn.button('loading');							
						var myComment = new common.ui.data.Comment({objectType:40, objectId:$this.poll.pollId, body:$this.get("commentBody")}); 	
						common.ui.ajax(
							'<@spring.url "/data/comments/update.json?output=json"/>',
							{
								data : kendo.stringify(myComment) ,
								contentType : "application/json",
								success : function(response){
									listview.dataSource.read({objectType: 40, objectId: $this.poll.pollId });
									$(".poll a[data-action=comment][data-object-id="+ $this.poll.pollId +"] span.comment-page-count").html( response.count  );
								},
								complete : function(e){
									$this.set("commentBody", "");
									btn.button('reset');
								}							
						});	
						return false;						
					},
					setSource : function(poll){
						var $this = this;
						if( typeof page == 'number'){							
							var title = $(".item [data-action=view][data-object-id=" + page + "]").text();
							var summary = $(".item[data-object-id=" + page + "]  .page-meta .page-description").text();
							var coverImgEle = $(".item[data-object-id=" + page + "] .cover img");
							var pageCreditHtml = $(".item[data-object-id="+page+"] .page-credits").html();							
							if( coverImgEle.length == 1 ){
								$this.set("coverPhotoUrl", coverImgEle.attr("src"));
							}else{
								$this.set( "coverPhotoUrl", ONE_PIXEL_IMG_SRC_DATA);
							}							
							$this.set("pageId", page );
							$this.set("pageCreditHtml", pageCreditHtml);
							$this.set("title", title);
							$this.set("summary", summary);
							$this.set("commentBody", "");
							listview.dataSource.read({objectType:40, objectId: page });
						}else{					
							poll.copy(this.poll);
							this.set("authorPhotoUrl", this.poll.authorPhotoUrl() );
							$this.set("commentBody", "");
							listview.dataSource.read({objectType:40, objectId: poll.pollId });	
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
					<a href="<@spring.url "/display/0/my-home.html"/>"><span class="btn-flat home t-0-r-2"></span></a>
					<a href="<@spring.url "/display/0/my-driver.html"/>"><span class="btn-flat folder t-0-r-1"></span></a>					
					<span class="btn-flat settings"></span>
					</div><!--/end container-->
			</div>
			</#if>
			<div class="footer-buttons-wrapper">
				<div class="footer-buttons">
					<button class="btn-link hvr-pulse-shrink" data-action="create" data-object-type="40"><i class="icon-flat microphone"></i></button>
					<button class="btn-link hvr-pulse-shrink"><i class="icon-flat icon-flat help"></i></button>
				</div>
			</div>			
			
			<!-- START MAIN CONTENT -->
			<div class="bg-white">
			<div class="container content">			
				<div class="sky-form my-page-form">
					<fieldset class="rounded-top no-border">
						<div class="row">
							<div class="col col-md-6">
								<section>
									<label class="label"><i class="fa fa-lock"></i> 소유자</label>
									<div id="my-poll-source-list" class="inline-group">
										<label class="radio"><input type="radio" name="radio-inline" value="2"  checked=""><i class="rounded-x"></i> Me</label>										
										<label class="radio"><input type="radio" name="radio-inline" value="1" ><i class="rounded-x"></i>  ${action.webSite.company.displayName}</label>
										<label class="radio"><input type="radio" name="radio-inline" value="30" ><i class="rounded-x"></i>  ${action.webSite.displayName}</label>
									</div>
								</section>							
							</div>
							<div class="col col-md-6">
								<section>
									<label class="label"><i class="fa fa-filter"></i> 상태 필터</label>							
									<div class="btn-group btn-group-sm" data-toggle="buttons" id="poll-list-filter">
										<label class="btn btn-success  rounded-left">
										<input type="radio" name="poll-list-view-filters"  value="ALL"> 전체 </span>)
										</label>
										<label class="btn btn-success active">
											<input type="radio" name="poll-list-view-filters"  value="ACTIVE"><i class="fa fa-filter"></i> ACTIVE
										</label>
										<label class="btn btn-success rounded-right">
											<input type="radio" name="poll-list-view-filters"  value="LIVE"><i class="fa fa-filter"></i> LIVE
										</label>
									</div>
								</section>															
							</div>
						</div>	
					</fieldset>
				</div>				
				<article class="my-page-wrapper">
					<div id="my-poll-listview"></div>
					<div id="my-poll-pager"></div>
				</article>
			</div>
			</div>
			<!-- ./END MAIN CONTENT -->		 		
	 		<!-- START FOOTER -->
			<#include "/html/common/common-homepage-globalfooter.ftl" >		
			<!-- ./END FOOTER -->					
		</div>			


		<!-- START COMMENT SLIDE -->		
		<div id="my-poll-commentary" class="modal" style="background: rgba(0,0,0,0.4);">
			<div class="commentary commentary-drawer">
				<span class="btn-flat-icon close" data-commentary-close></span>
				<div class="commentary-content">
					<div class="ibox">
						<div class="ibox-content no-border">
							<div class="page-credits bg-white">
								<div class="credit-item">
									<div class="credit-img user">
										<img data-bind="attr:{src:authorPhotoUrl}" class="img-responsive img-circle">
									</div>
									<div class="credit-name"> <span data-bind="visible:poll.user.nameVisible, text:poll.user.name ">악당</span><code data-bind="text:poll.user.username"></code> </div>
									<div class="credit-title"></div>
								</div>							
							</div>
							<div class="shadow-wrapper" style="max-width:350px;">
								<div class="box-shadow shadow-effect-2 ">
									<img data-bind="attr:{ src:coverPhotoUrl }" class="img-responsive"></img>
								</div>	
							</div>
							<h6 class="text-navy">설문기간 : <span data-bind="{ text: poll.startDate }" data-format="yyyy.MM.dd"></span> ~ <span data-bind="{ text: poll.endDate }" data-format="yyyy.MM.dd" ></span></h6>
							<h2 data-bind="text:poll.name" class="headline"></h2>
							<p data-bind="text:poll.description"></p>
						</div>
					</div>				
				</div>
				<div class="ibox-content no-border bg-gray">							
					<div id="my-poll-commentary-listview" class="comments"></div>
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
					
		<!-- Poll Edit Modal -->
		<div id="my-poll-post-modal" role="dialog" class="modal fade" data-backdrop="static">
			<div class="modal-dialog modal-lg">
				<div class="modal-content my-poll-post-form">	
					<div class="modal-header">
						<div class="author">
							<img data-bind="attr:{src:authorPhotoUrl}" style="margin-right:10px;">
						</div>
						<span class="hvr-pulse-shrink collapsed" data-modal-settings data-toggle="collapse" data-target="#my-poll-modal-settings" area-expanded="false" aria-controls="my-poll-modal-settings">
							<i class="icon-flat icon-flat settings"></i>						
						</span>
						<button aria-hidden="true" data-dismiss="modal" class="close" type="button"></button>
					</div>
					<form id="my-poll-modal-settings" action="#" class="sky-form modal-settings collapse">
							<header>
								고급옵션
								<span class="close" style="right:0;" data-toggle="collapse" data-target="#my-poll-modal-settings" aria-expanded="true" aria-controls="my-poll-modal-settings"></span>
							</header>
							<fieldset>                  
								<section>
								<div class="separator-2"></div>
								<label class="label">시작일</label>
								<input id="start" style="width: 200px" value="10/10/2011" data-role="datepicker"  data-bind="value: poll.startDate" />
								<p class="note">시작일은 종료일 이후일 수 없습니다.</p>
								</section>
								<section>			
								<label class="label">종료일</label>							
								<input id="end" style="width: 200px" value="10/10/2012" data-role="datepicker" data-bind="value: poll.endDate"/>
								<p class="note">종료일은 시작일 이전일 수 없습니다.</p>
								</section>										
								<section>			
								<label class="label">만료일</label>
								<input id="start" style="width: 200px" value="10/10/2011" data-role="datepicker" data-bind="value: poll.expireDate" />
								<p class="note">만료일은 설문종료 이후 설문 결과를 보여줄 마지막 일자를 의미합니다</p>
								</section>
								<div class="hr-line-dashed"></div>
								<section>
									<label class="toggle"><input type="checkbox" name="checkbox-toggle" data-bind="checked:poll.anonymousVoteAllowed"><i class="rounded-4x"></i>방문자 설문 허용</label>
									<label class="toggle"><input type="checkbox" name="checkbox-toggle" data-bind="checked:poll.userVoteAllowed"><i class="rounded-4x"></i>회원 설문 허용</label>
									<label class="toggle"><input type="checkbox" name="checkbox-toggle" data-bind="checked:poll.multipleSelectAllowed"><i class="rounded-4x"></i>보기중 하나이상 선택 가능</label>
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
								<p class="text-right text-danger small" data-bind="visible:editable">마지막 업데이트 일자 : <span data-bind="{ text: poll.formattedModifiedDate }"></span></p>
								<label class="input" for="title">
									<i class="icon-append fa fa-asterisk"></i>
									<input type="text" name="title" placeholder="무엇에 대한 설문인가요 ?" data-bind="value:poll.name, events:{keypress: keypress}">
								</label>
							</section>	
							<section>
								<label class="textarea textarea-expandable">
									<textarea rows="3" name="description" placeholder="설문 설명" data-bind="value:poll.description"></textarea>
								</label>
							</section>		
							<section>
								설문은 <span class="text-danger" data-format="yyyy.MM.dd" data-bind="text: poll.startDate"></span>부터 <span class="text-danger" data-format="yyyy.MM.dd" data-bind="text: poll.endDate"></span>까지 진행되며 결과는 <span class="text-danger" data-format="yyyy.MM.dd" data-bind="text: poll.expireDate"></span> 까지 볼수 있습니다. 
								이러한 설정은 <button type="button" class="btn btn-success btn-flat btn-sm rounded-2x" data-modal-settings data-toggle="collapse" data-target="#my-poll-modal-settings" area-expanded="false" aria-controls="my-poll-modal-settings" aria-expanded="false"><i class="fa fa-cog"></i> 고급옵션</button> 버튼을 클릭하여 변경할 수 있습니다.
							</section>					
						</fieldset>		
						<fieldset data-bind="visible:editable">
							<div class="my-poll-options" >		
								<label class="label">옵션</label>					
								<div id="my-poll-options-grid"></div>
							</div>								
						</fieldset>							
					</form>					
					<div class="modal-body">
						
					</div>
					<div class="modal-footer">
						<button data-dismiss="modal" class="btn btn-flat btn-outline pull-left rounded" type="button">닫기</button>
						<button class="btn btn-flat btn-info rounded btn-outline" type="button" data-action="create" data-bind="{visible:followUp, click:create}" data-loading-text="<i class='fa fa-spinner fa-spin'></i>">다음</button>
						<button class="btn btn-flat btn-primary rounded" type="button" data-bind="visible:editable, click:update" data-loading-text="<i class='fa fa-spinner fa-spin'></i>">저장 </button>
					</div>					
				</div>c
			</div>		
		</div>
		
		<div id="my-poll-view-modal" role="dialog" class="modal fade" data-backdrop="static" data-effect="zoom">
			<div class="modal-dialog modal-lg modal-flat">
				<div class="modal-content my-poll-view-form">	
					<div class="modal-header">
						<h2 data-bind="{text: poll.name}"></h2>
						<button aria-hidden="true" data-dismiss="modal" class="close" type="button"></button>
					</div>
					<article>
						<div class="p-sm bg-gray">
							<div class="author">
							    <img width="30" height="30" class="img-circle pull-left" data-bind="attr:{src:poll.authorPhotoUrl}" src="/images/common/no-avatar.png" style="margin-right:10px;">
								<ul class="list-inline">
									<li><span>By</span> <span data-bind="{ text: poll.user.name, visible: poll.user.nameVisible }"></span><code data-bind="{ text: poll.user.username }"></code></li>
									<li>|</li>
									<li>총 참여자 :<span data-bind="{ text: poll.voteCount }"></span> </li>
									<li>|</li>																								
									<li>기간 : <span data-bind="{ text: poll.startDate }" data-format="yyyy.MM.dd"></span> ~ <span data-bind="{ text: poll.endDate }" data-format="yyyy.MM.dd" ></span></li>
									<li>|</li>
									<li><span>댓글:</span> <span data-bind="{ text: poll.commentCount }"></span></li>
								</ul>  
							</div>
							<div class="separator-2"></div>
						    <p class="text-muted m-l-xl" data-bind="text:poll.description"></p>
	                    </div>
					</article>
					<div class="modal-body">
						<ul class="poll-option-list">
						<div data-role="listview"
							class="no-border"
               			  	data-template="my-poll-option-template"
                 			data-bind="source: pollOptionStats"
                 			style=""></div>
                 		</ul>	
					</div>
					<div class="modal-footer">
						<button class="btn btn-lg btn-outline btn-flat rounded" data-bind="click:vote">참여</button>					
					</div>	
				</div>
			</div>
		</div>	
		
	<!-- START TEMPLATE -->				

	<script id="my-poll-listview-template" type="text/x-kendo-template">
	<div class="ibox poll float-e-margins" data-object-id="#=pollId#">
		<div class="ibox-title">
			<h5>#: name #</h5>
			<span class="label label-info">#: status #</span>
		</div>
		<div class="ibox-content">
			<div class="row">
				<div class="col-sm-6">
					<span class="text-navy"> #: kendo.toString( startDate, "m") # ~ #: kendo.toString( endDate, "m") #</span>
					#if(description!=null){#<p class="text-muted m-b-xs"><small>#: description #</small></p>#}#	
					<div class="page-meta no-margin-hr">					
						<p class="page-tags"><i class="fa fa-tags"></i> 만화</p>
						<ul class="list-inline page-tools">			
							<li><i class="fa fa-users"> </i> <span class="poll-vote-count text-danger">#: voteCount #</span></li>
							<li>|</li>
							<li><a href="\\#" data-action="comment" data-object-id="#: pollId#"><i class="fa fa-comments-o"></i> <span class="comment-page-count">#: commentCount #</span></a></li>	
						</ul>
					</div>
					<span class="pull-right">
						<button class="btn btn-info btn-flat btn-outline rounded btn-sm" data-action="view" data-object-id="#= pollId#"> 참여하기 / 상세보기</button>						
						#if( hasPermissions(user, "EDIT") ){#
						<button class="btn btn-info btn-flat btn-outline rounded btn-sm" data-action="edit" data-object-id="#= pollId#"> 편집</button>
						# } #
					</span>						
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
			</div>
		</div>	
	</div>
	</script>	
	
	<script id="my-poll-option-template" type="text/x-kendo-template">
	<li class="poll-option">

		<div class="col-xs-6">
			<img class="poll-option-image" src="<@spring.url "/images/common/no-image2.jpg"/>" alt="">
			<div class="radio radio-danger">
	        	<input type="radio" name="my-poll-option" id="poll-#=pollOption.pollId#-option-#=pollOption.optionId#" value="#= pollOption.optionId #">
	            <label for="poll-#=pollOption.pollId#-option-#=pollOption.optionId#">#: pollOption.optionText#</label>
	        </div>
		</div>

		<div class="col-xs-5">
			<div class="progress progress-u progress-sm rounded-2x">
				<div class="progress-bar progress-bar-orange" role="progressbar" aria-valuenow="#: voteCount #" aria-valuemin="0" aria-valuemax="#: totalVoteCount#" style="width: #=votePercentString#%">
					<span class="sr-only">#: votePercentString#%</span>
				</div>
				<span class="text-muted progress-label">#: voteCount # 명</span>
			</div>
		</div>
		                    
	</li>
	</script>	
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
																					
	<#include "/html/common/common-homepage-templates.ftl" >		
	<#include "/html/common/common-personalized-templates.ftl" >
	<#include "/html/common/common-editor-templates.ftl" >	
	<!-- ./END TEMPLATE -->
	</body>    
</html>