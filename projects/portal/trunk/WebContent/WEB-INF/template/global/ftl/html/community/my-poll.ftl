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
				//createMyPageListView();	
				createMyPollListView();
				//createPageSection();
				//createPageCompose();
				// END SCRIPT 				
			}
		}]);			

		<!-- ============================== -->
		<!-- Page ListView  				-->
		<!-- ============================== -->			
		function getMyPollOwnerId(){
			return $("#my-page-source-list input[type=radio][name=radio-inline]:checked").val();			
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
								return { startIndex: options.skip, pageSize: options.pageSize,  objectType: getMyPollOwnerId() }
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
				
				$("#my-poll-listview").on( "click", "a[data-action=vote], button[data-action=vote]",  function(e){		
					$this = $(this);		
					var objectId = $this.data("object-id");	
					var inputEl = $("ul[data-object-id="+objectId+"] input[name=option]:checked");
					if( common.ui.defined(inputEl) ){
						
						common.ui.ajax( '<@spring.url "/data/polls/vote.json?output=json"/>', {
							type: 'POST',
							dataType : "json",
							data : { pollId: objectId , optionId : inputEl.val() } ,
							contentType : "application/json",
							success : function(response){ }							
						});
										
						//alert("vote..." + inputEl.val() );
					}
					
				});	
														
				// event for new page
				$("button[data-action=create][data-object-type=40], a[data-action=create][data-object-type=40]").click(function(e){
					var poll = new common.ui.data.Poll();
					//poll.set("objectType", getMyPageOwnerId());					
					createPollPostModal(poll);
				});		
			}	
		}
		
		function createPollPostModal(source){
			var renderTo = $("#my-poll-view-modal");	
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
					<fieldset class="rounded-top">
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
			
		<!-- Poll Edit Modal -->
		<div id="my-poll-view-modal" role="dialog" class="modal fade" data-backdrop="static">
			<div class="modal-dialog modal-lg">
				<div class="modal-content my-page-post-form">	
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
						<button class="btn btn-flat btn-primary rounded" type="button" data-bind="enabled:editable, click:update" data-loading-text="<i class='fa fa-spinner fa-spin'></i>">저장 </button>
					</div>					
				</div>c
			</div>		
		</div>
		
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

	<script id="my-poll-listview-template" type="text/x-kendo-template">
	<div class="ibox poll float-e-margins">
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
							<li><a href="\\#" data-action="comment" data-object-id="#: pollId#"><i class="fa fa-comments-o"></i> <span class="comment-page-count">1</span></a></li>	
						</ul>
					</div>
					<span class="pull-right">
						<button class="btn btn-info btn-flat btn-outline rounded btn-sm" data-action="edit" data-object-id="#= pollId#"> 편집</button>
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

				<div class="col-sm-6">
					#if ( optionCount > 0  ) { #
					<ul class="poll-option-list" data-object-id="#= pollId#">
					# for (var i = 0; i < optionCount ; i++) { #	
					# var option = options[i] ; #	
						<li class="poll-option">
							<img class="poll-option-image" src="<@spring.url "/images/common/no-image2.jpg"/>" alt="">
							<div class="radio radio-danger" style="margin-left: 40px;">
                                <input type="radio" name="option" id="option-#=option.optionId#" value="#= option.optionId #">
                                <label for="option-#=option.optionId#">#: option.optionText#</label>
                            </div>
						</li>
					#}#
					</ul>
					#}#
				</div>
			</div>

		</div>	
		<div class="ibox-footer text-right">
			<button class="btn btn-lg btn-outline btn-flat btn-rounded" data-action="vote" data-object-id="#= pollId#"  >참여</button>
		</div>
	</div>
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