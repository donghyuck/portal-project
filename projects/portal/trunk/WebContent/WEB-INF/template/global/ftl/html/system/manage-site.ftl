<#ftl encoding="UTF-8"/>
<html decorator="secure">
	<head>
		<title>웹사이트관리</title>
<#compress>		
		<link  rel="stylesheet" type="text/css"  href="${request.contextPath}/styles/common.admin/pixel/pixel.admin.style.css" />
		
		<script type="text/javascript"> 
		yepnope([{
			load: [ 
			'css!${request.contextPath}/styles/font-awesome/4.1.0/font-awesome.min.css',			
			'css!${request.contextPath}/styles/common.plugins/animate.css',
			'css!${request.contextPath}/styles/common.admin/pixel/pixel.admin.widgets.css',			
			'css!${request.contextPath}/styles/common.admin/pixel/pixel.admin.rtl.css',
			'css!${request.contextPath}/styles/common.admin/pixel/pixel.admin.themes.css',
			'css!${request.contextPath}/styles/common.admin/pixel/pixel.admin.pages.css',				
			'css!${request.contextPath}/styles/common/common.ui.ibox.css',			
			'css!${request.contextPath}/styles/perfect-scrollbar/perfect-scrollbar-0.4.9.min.css',
			'${request.contextPath}/js/jquery/1.10.2/jquery.min.js',			
			'${request.contextPath}/js/kendo/kendo.web.min.js',
			'${request.contextPath}/js/kendo.extension/kendo.ko_KR.js',
			'${request.contextPath}/js/kendo/cultures/kendo.culture.ko-KR.min.js',			
			'${request.contextPath}/js/jgrowl/jquery.jgrowl.min.js',						
			'${request.contextPath}/js/bootstrap/3.0.3/bootstrap.min.js',	
			'${request.contextPath}/js/common.plugins/fastclick.js', 
			'${request.contextPath}/js/common.plugins/jquery.slimscroll.min.js', 
			'${request.contextPath}/js/perfect-scrollbar/perfect-scrollbar-0.4.9.min.js', 			
			'${request.contextPath}/js/common.admin/pixel.admin.min.js',			
			'${request.contextPath}/js/common/common.models.js',       	    
			'${request.contextPath}/js/common/common.api.js',
			'${request.contextPath}/js/common/common.ui.js',
			'${request.contextPath}/js/common/common.ui.admin.js',			
			'${request.contextPath}/js/ace/ace.js'
			],        	   
			complete: function() {               
				// 1-1.  한글 지원을 위한 로케일 설정
				common.api.culture();
				// 1-2.  페이지 렌딩
				common.ui.landing();				
				// 1-3.  관리자  로딩
				var currentUser = new User();	
				
				var detailsModel = kendo.observable({
					company : new Company(),
					isEnabled : false,
					properties : new kendo.data.DataSource({
						transport: { 
							read: { url:'${request.contextPath}/secure/get-company-property.do?output=json', type:'post' },
							create: { url:'${request.contextPath}/secure/update-company-property.do?output=json', type:'post' },
							update: { url:'${request.contextPath}/secure/update-company-property.do?output=json', type:'post'  },
							destroy: { url:'${request.contextPath}/secure/delete-company-property.do?output=json', type:'post' },
					 		parameterMap: function (options, operation){			
						 		if (operation !== "read" && options.models) {
						 			return { companyId: getSelectedCompany().companyId, items: kendo.stringify(options.models)};
								} 
								return { companyId: getSelectedCompany().companyId }
							}
						},	
						batch: true, 
						schema: {
							data: "targetCompanyProperty",
							model: Property
						},
						error : common.api.handleKendoAjaxError
					}),
					toggleOptionPanel:function(e){					
						var action = $(e.target).attr('data-action');
						if( action === 'update-company' ){
							openCompanyUpdateModal(); 
						}
					},
					onSave : function(e){						
						var btn = $(e.target);
						btn.button('loading');
						$.ajax({
							type : 'POST',
							url : '${request.contextPath}/secure/update-company.do?output=json',
							data: { companyId : this.get('company').companyId, item : kendo.stringify( this.get('company') ) },
							success : function(response){
								window.location.reload( true );
							},
							complete: function(jqXHR, textStatus ){					
								btn.button('reset');
							},
							error:common.api.handleKendoAjaxError,
							dataType : "json"
						});						
						return false;
					},
					teleport : function(e){
						var action = $(e.target).attr('data-action');
						if(action === 'go-group'){
							common.api.teleportation().teleport({
								action : '${request.contextPath}/secure/main-group.do',
								companyId : this.get('company').companyId
							});							
						}else if (action === 'go-user'){
							common.api.teleportation().teleport({
								action : '${request.contextPath}/secure/main-user.do',
								companyId : this.get('company').companyId
							});								
						}
					}										
				});	
				
				detailsModel.bind("change", function(e){		
					if( e.field.match('^company.name')){ 						
						var sender = e.sender ;
						if( sender.company.companyId > 0 ){
							var dt = new Date();
							this.set("logoUrl", "/download/logo/company/" + sender.company.name + "?" + dt.getTime() );
							this.set("formattedCreationDate", kendo.format("{0:yyyy.MM.dd}",  sender.company.creationDate ));      
							this.set("formattedModifiedDate", kendo.format("{0:yyyy.MM.dd}",  sender.company.modifiedDate ));
						}						
					}	
				});
				
				$("#company-details").data("model", detailsModel );				
				common.ui.admin.setup({
					authenticate: function(e){
						e.token.copy(currentUser);
					},
					companyChanged: function(item){
						item.copy(detailsModel.company);
						detailsModel.isEnabled = true;
						kendo.bind($("#company-details"), detailsModel );				
						$("#website-grid").data("kendoGrid").dataSource.read(); 
					}
				});	 
				createSiteGrid();	
			}	
		}]);
				
		function getSelectedCompany(){
			var setup = common.ui.admin.setup();
			return setup.companySelector.dataItem(setup.companySelector.select());
		}
		
		function createSiteGrid(){	
			if( ! $("#website-grid").data("kendoGrid") ){	
				$('#website-grid').kendoGrid({
								dataSource: {
									type: 'json',
									transport: {
										read: { url:'${request.contextPath}/secure/list-site.do?output=json', type: 'POST' },
										parameterMap: function (options, operation){
											if (operation != "read" && options) {										                        								                       	 	
												return { targetCompanyId: getSelectedCompany().companyId , item: kendo.stringify(options)};									                            	
											}else{
												return { targetCompanyId: getSelectedCompany().companyId }
											}
										} 
									},
									pageSize: 15,
									schema: {
										total: "targetWebSiteCount",
										data: "targetWebSites",
										model : common.models.WebSite
									},
									error: common.api.handleKendoAjaxError
								},
								/* toolbar: [ { name: "create", text: "웹 사이트 추가" } ],      */
								columns:[
									{ field: "webSiteId", title: "ID",  width: 50, filterable: false, sortable: false},
									{ field: "name", title: "키", width: 200, template: '<button type="button" class="btn btn-warning btn-xs" onclick="goSite(this); return false;">#: name #</a>'},									
									{ field: "displayName", title: "이름",  width: 100 },
									{ field: "description", title: "설명",  width: 200 },
									{ field: "url", title: "URL",  width: 150 },
									{ field: "enabled", title: "사용여부",  width: 100 },
									{ field: "allowAnonymousAccess", title: "공개여부",  width: 100 },
									{ field: "creationDate", title: "생성일", width: 120, format: "{0:yyyy/MM/dd}" },
									{ field: "modifiedDate", title: "수정일", width: 120, format: "{0:yyyy/MM/dd}" },
								/*	{ command: [ {name: "destroy", text: "삭제" }, {name:"edit",  text: { edit: "수정", update: "저장", cancel: "취소"}  }  ], title: "&nbsp;", width: 180  }	*/
								], 
								editable: "inline",
								batch: false,
								filterable: true,
								sortable: true,
								pageable: { refresh:true, pageSizes:false,  messages: { display: ' {1} / {2}' }  },
								selectable: 'row',
								autoBind: false,
								dataBound: function(e) {
								
								},
								change: function(e) {          
									var selectedCells = this.select();
									if( selectedCells.length > 0 ){
										var selectedCell = this.dataItem( selectedCells );	
									}
								}				
				});
			}			
		}
		
		function getSelectedSite(){			
			var renderTo = $("#website-grid");
			var grid = renderTo.data('kendoGrid');			
			var selectedCells = grid.select();			
			if( selectedCells.length == 0){
				return new common.models.WebSite();
			}else{			
				var selectedCell = grid.dataItem( selectedCells );   
				return selectedCell;
			}
		}		
		
		function goSite (){					
			common.api.teleportation().teleport({
				action : '${request.contextPath}/secure/view-site.do',
				targetSiteId : getSelectedSite().webSiteId
			});						
		}
		

		
		
		</script>
		<style>					
		
		.k-grid-content{
			min-height:200px;
		}		
		</style>
</#compress>		
	</head>
	<body>
	<body class="theme-default main-menu-animated">
		<div id="main-wrapper">
			<#include "/html/common/common-system-navigation.ftl" >	
			<div id="content-wrapper">
				<#assign selectedMenu = WebSiteUtils.getMenuComponent("SYSTEM_MENU", "MENU_2_4") />
				<ul class="breadcrumb breadcrumb-page">
					<!--<div class="breadcrumb-label text-light-gray">You are here: </div>-->
					<li><a href="#">Home</a></li>
					<li><a href="${ selectedMenu.parent.page!"#" }">${selectedMenu.parent.title}</a></li>
					<li class="active"><a href="#">${selectedMenu.title}</a></li>
				</ul>
				<div class="page-header bg-dark-gray">		
					<div class="row">
						<h1 class="col-xs-12 col-sm-6 text-center text-left-sm"><#if selectedMenu.isSetIcon() ><i class="fa ${selectedMenu.icon} page-header-icon"></i></#if> ${selectedMenu.title}
							<p><small><i class="fa fa-quote-left"></i> ${selectedMenu.description} <i class="fa fa-quote-right"></i></small></p>
						</h1>						
					</div>				
				</div><!-- / .page-header -->
				<!-- details-row -->
				<div id="company-details" class="page-details">			
				
					<div class="row">		
							<div class="col-sm-12">
								<div class="panel panel-default" style="min-height:300px;" >
									<div class="panel-heading">
										<span class="panel-title"><i class="fa fa-align-justify"></i> <span data-bind="text:company.displayName"></span><code data-bind="text: company.companyId"></code> 웹사이트 목록</span>
									</div>
									<div class="panel-body">
										<div class="note note-info">
											<h4 class="note-title"><small><i class="fa fa-info"></i> 키 컬럼의 버튼을 클릭하면 해당하는 사이트를 관리할 수 있습니다.</small></h4>
										</div>	
									</div>
									<div id="website-grid" class="no-border-hr"></div>
									<div class="panel-footer no-padding-vr">								
									</div>
								</div>	
							</div>				
						</div><!-- / .col-sm-12 -->						
					</div><!-- / .row -->
					
									
					
					<div class="details-row no-margin-t">					
						<div class="left-col">
							<div class="details-block no-margin-t">
								<div class="details-photo">
									<img data-bind="attr: { src: logoUrl }" alt="" src="${request.contextPath}/images/common/loader/loading-transparent-bg.gif">
								</div>
								<br>
								<button type="button" class="btn btn-success btn-flat btn-control-group" data-action="update-company" data-toggle="button" data-bind="enabled: isEnabled, click:toggleOptionPanel" ><i class="fa fa-pencil"></i> 회사 정보변경</button>
											
							</div>				
							<div class="panel panel-transparent">
								<div class="panel-heading">
									<span class="panel-title" data-bind="text:company.description"></span>									
								</div>
								<table class="table">
									<tbody>						
										<tr>
											<th class="text-center">회사</th>								
											<td><span data-bind="text: company.displayName"></span><code><span data-bind="text: company.companyId"></span></code></td>
										</tr>	
										<tr>
											<th class="text-center">도메인</th>								
											<td><span data-bind="text: company.domainName"></span></td>
										</tr>	
										<tr>
											<th class="text-center">생성일</th>								
											<td><span data-bind="text:formattedModifiedDate"></span></td>
										</tr>	
										<tr>
											<th class="text-center">수정일</th>								
											<td><span data-bind="text:formattedModifiedDate"></span></td>
										</tr>																								
									</tbody>
								</table>
							</div>
						</div>
						<div class="right-col">
							<hr class="details-content-hr no-grid-gutter-h"/>						
							<div class="details-content">											
									<!-- company-tabs -->	
									<div class="panel colourable">
										<div class="panel-heading">
											<span class="panel-title"><span class="label label-primary" data-bind="text: company.name"></span></span>
											<ul id="company-tabs" class="nav nav-tabs nav-tabs-xs">
												<li><a href="#company-tabs-props" data-toggle="tab">프로퍼티</a></li>
												<li><a href="#company-tabs-images" data-toggle="tab">이미지</a></li>
												<li><a href="#company-tabs-files" data-toggle="tab">파일</a></li>
												<li><a href="#company-tabs-timeline" data-toggle="tab">타임라인</a></li>
											</ul>	
										</div> <!-- / .panel-heading -->		
										<div class="tab-content">								
											<div class="tab-pane fade" id="company-tabs-props">
												<div data-role="grid"
													class="no-border-hr no-border-t"
													date-scrollable="false"
													data-editable="true"
													data-toolbar="[ { 'name': 'create', 'text': '추가' }, { 'name': 'save', 'text': '저장' }, { 'name': 'cancel', 'text': '취소' } ]"
													data-columns="[
														{ 'title': '이름',  'field': 'name', 'width': 200 },
														{ 'title': '값', 'field': 'value' },
														{ 'command' :  { 'name' : 'destroy' , 'text' : '삭제' },  'title' : '&nbsp;', 'width' : 100 }
													]"
													data-bind="source: properties, visible: isEnabled"
													style="height: 300px"></div>																				
													
											</div>
											<div class="tab-pane fade" id="company-tabs-images" >
												<div class="row no-margin-hr" style="background:#f5f5f5;" >
													<div class="col-md-4"><input name="image-upload" id="image-upload" type="file" /></div>
													<div class="col-md-8 no-padding-hr" style="border-left : solid 1px #ccc;" ><div id="image-details" class="hide animated padding-sm fadeInRight"></div></div>
												</div>
												<div id="image-grid" class="no-border-hr no-border-b"></div>		
											</div>
											<div class="tab-pane fade" id="company-tabs-files">
												<div class="panel panel-transparent no-margin-b">
													<div class="panel-body">
														<input name="attach-upload" id="attach-upload" type="file" />
													</div>												
												</div>
												<div id="attach-grid" class="no-border-hr no-border-b"></div>
											</div>
											<div class="tab-pane fade" id="company-tabs-timeline">											
											</div>																																								
										</div>	
										<div class="panel-footer no-padding-vr"></div>	
									</div>
								<!-- / .website-tabs -->			
								<a href="#" class="header-2">웹 사이트</a>	
										<h4>
											<small><i class="fa fa-info"></i> 키 컬럼의 버튼을 클릭하면 해당하는 사이트를 관리할 수 있습니다.</small>
										</h4>	
								<div class="row">				
									<div class="col-sm-12 ">			
										<div id="website-grid" ></div>
									</div>
								</div>		
							</div><!-- / .details-content -->
						</div><!-- / .right-col -->
					</div><!-- / .details-row -->	
	
				</div>
			</div> <!-- / #content-wrapper -->
			<div id="main-menu-bg">
			</div>
		</div> <!-- / #main-wrapper -->  
		<!-- Modal -->
		<div id="social-detail-window" style="display:none;"></div>
		<div class="modal fade" id="myModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
			<div class="modal-dialog">
				<div class="modal-content">
					<div class="modal-header">
						<button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
							<h4 class="modal-title">Modal title</h4>
					</div>
					<div class="modal-body">
					</div>
				<div class="modal-footer">
				<button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
				<button type="button" class="btn btn-primary">Save changes</button>
			</div>
	      </div><!-- /.modal-content -->
	    </div><!-- /.modal-dialog -->
	  </div><!-- /.modal -->
  		
		<!-- END MAIN CONTNET -->
		<!-- START FOOTER -->
		<footer>  		
		</footer>
		<!-- END FOOTER -->

		<script type="text/x-kendo-template" id="company-update-modal-template">
		<div class="modal fade" id="company-update-modal" tabindex="-1" role="dialog" aria-labelledby=".modal-title" aria-hidden="true">
			<div class="modal-dialog animated slideDown">
				<div class="modal-content">
					<div class="modal-header">
						<button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
						<h4 class="modal-title">회사 정보 변경</h4>
					</div>
					<div class="modal-body no-padding">
						<div class=" form-horizontal padding-sm" >
							<div class="row form-group">
								<label class="col-sm-4 control-label">이름:</label>
								<div class="col-sm-8">
									<input type="text" name="name" class="form-control" data-bind="value:company.displayName">
								</div>
							</div>
							<div class="row form-group">
								<label class="col-sm-4 control-label">설명:</label>
								<div class="col-sm-8">
									<input type="text" name="name" class="form-control" data-bind="value:company.description">
								</div>
							</div>																
							<div class="row form-group">
								<label class="col-sm-4 control-label">도메인:</label>
								<div class="col-sm-8">
									<input type="text" class="form-control" data-bind="value:company.domainName">
								</div>
							</div>	
							<h5><small><i class="fa fa-info"></i> <strong>파일 선택</strong> 버튼을 클릭하여 로고 이미지를 직접 선택하거나, 이미지파일을 끌어서 놓기(Drag & Drop)를 하세요.</small></h5>
							<input name="logo-file" id="logo-file" type="file" />	
							<div id="logo-grid"></div>							
						</div>
					</div>																		
					<div class="modal-footer">					
						<button type="button" class="btn btn-primary btn-flat" data-bind="click: onSave, enabled: isEnabled" data-loading-text='<i class="fa fa-spinner fa-spin"></i>'>저장</button>					
						<button type="button" class="btn btn-default btn-flat" data-dismiss="modal">닫기</button>
					</div>
				</div>
			</div>
		</div>				
		</script>
				
		<script id="image-details-template" type="text/x-kendo-template">				
		
					<div class="row">
						<div class="col-sm-3">
							<p><span class="label label-info" data-bind="text: contentType"></span></p>
							<img data-bind="attr:{src: imgUrl}" src="${request.contextPath}/images/common/loader/loading-transparent-bg.gif" class="img-responsive img-thumbnail " />						
						</div>
						<div class="col-sm-9">	
							<div class="panel-group" id="company-tabs-image-accordion">
								<div class="panel">
									<div class="panel-heading ">
										<a class="accordion-toggle" data-toggle="collapse" data-parent="#company-tabs-image-accordion" href="\\#company-tabs-image-accordion-collapse1">
											<i class="fa fa-info"></i> 속성
										</a>
									</div> <!-- / .panel-heading -->
									<div id="company-tabs-image-accordion-collapse1" class="panel-collapse collapse in" style="height: auto;">
										<div class="panel-body no-padding">									
											<div id="image-prop-grid" class="no-border-hr no-border-b"></div>						
										</div> <!-- / .panel-body -->
									</div> <!-- / .collapse -->
								</div> <!-- / .panel -->
	
								<div class="panel">
									<div class="panel-heading">
										<a class="accordion-toggle collapsed" data-toggle="collapse" data-parent="#company-tabs-image-accordion" href="\\#company-tabs-image-accordion-collapse2">
											<i class="fa fa-share"></i>  공유
										</a>
									</div> <!-- / .panel-heading -->
									<div id="company-tabs-image-accordion-collapse2" class="panel-collapse collapse" style="height: 0px;">
										<div class="panel-body">
											<h5><small>모두에게 공개를 선택하면 누구나 웹을 통하여 볼 수 있도록 공개됩니다.</small></h5>	

											<div class="btn-group" data-toggle="buttons">
												<label class="btn btn-primary">
												<input type="radio" name="image-public-shared" value="1">모두에게 공개
												</label>
												<label class="btn btn-primary active">
												<input type="radio" name="image-public-shared" value="0"> 비공개
												</label>
											</div>
											
										</div> <!-- / .panel-body -->
									</div> <!-- / .collapse -->
								</div> <!-- / .panel -->
	
								<div class="panel">
									<div class="panel-heading">
										<a class="accordion-toggle collapsed" data-toggle="collapse" data-parent="#company-tabs-image-accordion" href="\\#company-tabs-image-accordion-collapse3">
											<i class="fa fa-upload"></i> 이미지 업로드
										</a>
									</div> <!-- / .panel-heading -->
									<div id="company-tabs-image-accordion-collapse3" class="panel-collapse collapse" style="height: 0px;">
										<div class="panel-body">
											<h5><small>사진을 변경하려면 마우스로 사진을 끌어 놓거나 사진 선택을 클릭하세요.</small></h5>
											<input name="update-image-file" type="file" id="update-image-file" class="pull-right" />
										</div> <!-- / .panel-body -->
									</div> <!-- / .collapse -->
								</div> <!-- / .panel -->
							</div>
						</div>				
					</div>											
									
		</script>
		<script id="social-details-template" type="text/x-kendo-template">				
				#if ( typeof (twitterProfile)  == "object" ){ #
				<div class="media">
					<a class="pull-left" href="\\#"><img class="media-object" src="#=twitterProfile.profileImageUrl#" alt="프로파일 이미지" class="img-rounded"></a>
					<div class="media-body">
						<h4 class="media-heading">#=twitterProfile.screenName# (#=twitterProfile.name#)</h4>
						#=twitterProfile.description#</br>
						</br>
						트위터 URL : #=twitterProfile.profileUrl#</br>
						표준시간대: #=twitterProfile.timeZone#</br>	
						웹 사이트: #=twitterProfile.url#</br>	
						언어: #=twitterProfile.language#</br>	
						위치: #=twitterProfile.location#</br>	
					</div>			
				</div>
				</br>
				<ul class="list-group">
					<li class="list-group-item">
					<span class="badge">#=twitterProfile.statusesCount#</span>
					트윗
					</li>
					<li class="list-group-item">
					<span class="badge">#=twitterProfile.friendsCount#</span>
					팔로잉
					</li>
					<li class="list-group-item">
					<span class="badge">#=twitterProfile.followersCount#</span>
					팔로워
					</li>		
				</ul>			
				# } else if ( typeof (facebookProfile)  == "object" ) { #
				<div class="media">
					<a class="pull-left" href="\\#"><img class="media-object" src="http://graph.facebook.com/#=facebookProfile.id#/picture" alt="프로파일 이미지" class="img-rounded"></a>
					<div class="media-body">
						<h4 class="media-heading">#=facebookProfile.name# (#=facebookProfile.firstName#, #=facebookProfile.lastName#)</h4>
						</br>
						URL : #=facebookProfile.link#</br>
						로케일 : #=facebookProfile.locale#</br>
						위치 : #=facebookProfile.location.name#</br>
					</div>		
				</div>
								
				# } else if ( typeof (error)  == "object" ) { #
				<div class="alert alert-danger">
					#=socialAccount.serviceProviderName# 쇼셜계정에 접근할 수 없습니다. <BR/>
					연결하기 버튼을 클릭하여	<BR/>
					다시 연결하여 주십시오.	<BR/>					
					<img src="${request.contextPath}/images/common/twitter-bird-dark-bgs.png" alt="Twitter Logo" class="img-rounded">					
				</div>
				<input id="connect-social-id" type="hidden" value="#=socialAccount.socialAccountId #" />
				<div style="margin-top:-50px;">
				<button id="connect-social-btn" type="button" class="btn btn-primary btn-block">#=socialAccount.serviceProviderName#  연결하기</button>
				</div>
				# } else { #	
					# if ( socialAccount.serviceProviderName == "facebook" ) { #
					<img src="${request.contextPath}/images/common/FB-f-Logo__blue_512.png" alt="Facebook Logo" class="img-rounded">	
					# } else{ #
					<img src="${request.contextPath}/images/common/twitter-bird-light-bgs.png" alt="Twitter Logo" class="img-rounded">	
					# } #	
				# } #					
		</script>
		<#include "/html/common/common-system-templates.ftl" >		
	</body>
</html>