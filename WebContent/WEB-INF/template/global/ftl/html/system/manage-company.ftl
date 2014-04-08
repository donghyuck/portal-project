<#ftl encoding="UTF-8"/>
<html decorator="secure">
<head>
		<title>회사 관리</title>
<#compress>		
		<script type="text/javascript">
		<!--
		yepnope([{
			load: [
			'css!${request.contextPath}/styles/font-awesome/4.0.3/font-awesome.min.css',	
			'css!${request.contextPath}/styles/codedrop/codedrop.overlay.css',			
			'${request.contextPath}/js/jquery/1.10.2/jquery.min.js',
       	    '${request.contextPath}/js/kendo/kendo.web.min.js',
			'${request.contextPath}/js/jgrowl/jquery.jgrowl.min.js',      	    
			'${request.contextPath}/js/kendo.extension/kendo.ko_KR.js',			 
			'${request.contextPath}/js/kendo/cultures/kendo.culture.ko-KR.min.js', 
			'${request.contextPath}/js/bootstrap/3.0.3/bootstrap.min.js',       	    
       	    '${request.contextPath}/js/common/common.modernizr.custom.js',
       	    '${request.contextPath}/js/common/common.models.js',       	    
			'${request.contextPath}/js/common/common.api.js',
       	    '${request.contextPath}/js/common/common.ui.js',
			'${request.contextPath}/js/common/common.ui.system.js'],        	   
			complete: function() {      
				// 1.  한글 지원을 위한 로케일 설정
				kendo.culture("ko-KR");
										
				// 2. ACCOUNTS LOAD		
				var currentUser = new User({});
				var accounts = $("#account-panel").kendoAccounts({
					visible : false,
					authenticate : function( e ){
						currentUser = e.token;						
					}
				});
										
				var currentCompany = new Company();							
				var selectedCompany = new Company();	
										
				// 3.MENU LOAD
				var currentPageName = "MENU_1_1";
				var topBar = $("#navbar").extTopNavBar({ 
					menu:"SYSTEM_MENU",
					template : kendo.template($("#topnavbar-template").html() ),
					items: [
						{ 
							name:"companySelector", 	selector: "#companyDropDownList", value: ${action.user.companyId},
							change : function(data){
								$("#navbar").data("companyPlaceHolder", data) ;
								kendo.bind($("#site-info"), data );
							}
						},
						{	name:"getMenuItem", menu: currentPageName, handler : function( data ){ 
								kendo.bind($(".page-header"), data );   
							} 
						}
					]
				});
				 
				 // 4. MAIN CONTENT		
				$("button.btn-control-group ").each(function (index) {					
					var btn_control = $(this);
					var btn_control_action = btn_control.attr("data-action");
					
					if( btn_control_action == "menu" ) 
					{
						btn_control.click( function(e){			
							showMenuWindow();
						});						
					}else if (btn_control_action == "role"){
						btn_control.click( function(e){			
							showRoleWindow();							
						} );
					}else if (btn_control_action == "group"){
						btn_control.click( function(e){
							$("form[name='fm1'] input").val(selectedCompany.companyId);
							$("form[name='fm1']").attr("action", "main-group.do" ).submit(); 
						} );
					}else if (btn_control_action == "user"){
						btn_control.click( function(e){			
							$("form[name='fm1'] input").val(selectedCompany.companyId);		
							$("form[name='fm1']").attr("action", "main-user.do" ).submit(); 
						} );
					}else if (btn_control_action == "layout"){
						btn_control.click(function (e) {										
							$(".body-group").each(function( index ) {
								var panel_body = $(this);
								var is_detail_body = false;
								if (panel_body.attr("id") == "company-details"){
									is_detail_body = true;
								}else{
									is_detail_body = false;
								}								
								if( panel_body.hasClass("col-sm-6" )){
									panel_body.removeClass("col-sm-6");
									panel_body.addClass("col-sm-12");	
									if( is_detail_body ){
										panel_body.css('padding', '5px 0 0 0');
									}													
								}else{
									panel_body.removeClass("col-sm-12");
									panel_body.addClass("col-sm-6");		
									if( is_detail_body ){
										panel_body.css('padding', '0 0 0 5px');
									}				
								}
							});
						});
					}	
				});
				
				var company_grid = $("#company-grid").kendoGrid({
					dataSource: {	
						transport: { 
							read: { url:'${request.contextPath}/secure/list-company.do?output=json', type: 'POST' },
							create: { url:'${request.contextPath}/secure/create-company.do?output=json', type:'POST' },             
							update: { url:'${request.contextPath}/secure/update-company.do?output=json', type:'POST' },
							parameterMap: function (options, operation){	          
								if (operation != "read" && options) {
									return { companyId: options.companyId, item: kendo.stringify(options)};
								}else{
									return { startIndex: options.skip, pageSize: options.pageSize }
								}
							}
						},
						schema: {
							total: "totalCompanyCount",
							data: "companies",
							model : Company
						},
						pageSize: 15,
						serverPaging: true,
						serverFiltering: false,
						serverSorting: false,                        
						error: common.api.handleKendoAjaxError
					},
					columns: [
						{ field: "companyId", title: "ID", width:40,  filterable: false, sortable: false }, 
						{ field: "name",    title: "KEY",  filterable: true, sortable: true,  width: 80 }, 
						{ field: "displayName",   title: "이름",  filterable: true, sortable: true,  width: 100 }, 
						{ field: "domainName",   title: "도메인",  filterable: true, sortable: false,  width: 100 }, 
						{ field: "description", title: "설명", width: 200, filterable: false, sortable: false },
						{ command: [ {name:"edit",  text: { edit: "수정", update: "저장", cancel: "취소"}  }  ], title: "&nbsp;", width: 180  }], 
					filterable: true,
					editable: "inline",
					selectable: 'row',
					height: '100%',
					batch: false,
					toolbar: [ { name: "create", text: "회사 추가" } ],                    
					pageable: { refresh:true, pageSizes:false,  messages: { display: ' {1} / {2}' }  },					
					change: function(e) {
						// 1-1 SELECTED EVENT  
						var selectedCells = this.select();
						if( selectedCells.length > 0){
							// 1-1-1 선택된 로의 Company 정보로 selectedCompany 객체를 설정한다.
							var selectedCell = this.dataItem( selectedCells );	     
							if( selectedCell.companyId > 0 && selectedCell.companyId != selectedCompany.companyId ){
								selectedCompany.companyId = selectedCell.companyId;
								selectedCompany.name = selectedCell.name;
								selectedCompany.displayName = selectedCell.displayName;
								selectedCompany.domainName = selectedCell.domainName;
								selectedCompany.description = selectedCell.description;
								selectedCompany.modifiedDate = selectedCell.modifiedDate;
								selectedCompany.creationDate = selectedCell.creationDate;	                                 
								selectedCompany.formattedCreationDate  =  kendo.format("{0:yyyy.MM.dd}",  selectedCell.creationDate );      
								selectedCompany.formattedModifiedDate =  kendo.format("{0:yyyy.MM.dd}",  selectedCell.modifiedDate );    
								
								// 1-1-2 템플릿을 이용한 상세 정보 출력	
								$('#company-details').show().html(kendo.template($('#company-details-template').html()));	
								kendo.bind( $('#company-details'), selectedCompany );						

								if( ! $('#company-prop-grid').data("kendoGrid") ){													
												$('#company-prop-grid').kendoGrid({
													dataSource: {
														transport: { 
															read: { url:'${request.contextPath}/secure/get-company-property.do?output=json', type:'post' },
															create: { url:'${request.contextPath}/secure/update-company-property.do?output=json', type:'post' },
															update: { url:'${request.contextPath}/secure/update-company-property.do?output=json', type:'post'  },
															destroy: { url:'${request.contextPath}/secure/delete-company-property.do?output=json', type:'post' },
													 		parameterMap: function (options, operation){			
														 		if (operation !== "read" && options.models) {
														 			return { companyId: selectedCompany.companyId, items: kendo.stringify(options.models)};
																} 
																return { companyId: selectedCompany.companyId }
															}
														},						
														batch: true, 
														schema: {
															data: "targetCompanyProperty",
															model: Property
														},
														error:common.api.handleKendoAjaxError
													},
													columns: [
														{ title: "속성", field: "name" },
														{ title: "값",   field: "value" },
														{ command:  { name: "destroy", text:"삭제" },  title: "&nbsp;", width: 100 }
													],
													pageable: false,
													resizable: true,
													editable : true,
													scrollable: true,
													//height: 350,
													toolbar: [
														{ name: "create", text: "추가" },
														{ name: "save", text: "저장" },
														{ name: "cancel", text: "취소" }
													],				     
													change: function(e) {
													}
												});		
								}
																		
								$('#myTab a').click(function (e) {
									e.preventDefault(); 
									 if( $(this).attr('href') == '#props' ){	 									 
									 }else if( $(this).attr('href') == '#groups' ){		
										if( ! $('#company-group-grid').data("kendoGrid") ){	
											$('#company-group-grid').kendoGrid({
						   							dataSource: {
														type: "json",
														transport: {
															read: { url:'${request.contextPath}/secure/list-company-group.do?output=json', type:'post' },
															destroy: { url:'${request.contextPath}/secure/remove-group-members.do?output=json', type:'post' },
															parameterMap: function (options, operation){
																if (operation !== "read" && options.models) {
												 	    			return { companyId: selectedCompany.companyId, items: kendo.stringify(options.models)};
										            			}
											            		return { companyId: selectedCompany.companyId }
												   			}
														},
														schema: {
															data: "companyGroups",
															model: Group
														},
														error:common.api.handleKendoAjaxError
													},
													//height: 350,
													scrollable: true,
													editable: false,
													columns: [
														{ field: "groupId", title: "ID", width:40,  filterable: false, sortable: false }, 
														{ field: "name",    title: "KEY",  filterable: true, sortable: true,  width: 100 },
														{ field: "displayName",    title: "그룹",  filterable: true, sortable: true,  width: 100 },
														{ field: "description",    title: "설명",  filterable: false,  sortable: false },
														{ field:"memberCount", title: "멤버", filterable: false,  sortable: false, width:50 }
													],
													dataBound:function(e){},
													toolbar: [{ name: "create-groups", text: "디폴트 그룹 생성하기", imageClass:"k-icon k-i-folder-add" , className: "createGroupsCustomClass" }]
											});		
										}								 
									 }else if( $(this).attr('href') == '#users' ){						
										if( ! $('#company-user-grid').data("kendoGrid") ){	
											$('#company-user-grid').kendoGrid({
								   				dataSource: {
													type: "json",
													transport: { 
														read: { url:'${request.contextPath}/secure/list-user.do?output=json', type: 'POST' },
														parameterMap: function (options, type){
															return { startIndex: options.skip, pageSize: options.pageSize,  companyId: selectedCompany.companyId }
														}
													},
													schema: {
														total: "totalUserCount",
														data: "users",
														model: User
													},
													error:common.api.handleKendoAjaxError,
													batch: false,
													pageSize: 10,
													serverPaging: true,
													serverFiltering: false,
													serverSorting: false 
												},
												//height: 350,
												filterable: true,
												sortable: true,
												scrollable: true,
												pageable: { refresh:true, pageSizes:false,  messages: { display: ' {1} / {2}' }  },
												selectable: "multiple, row",
												columns: [
													{ field: "userId", title: "ID", width:50,  filterable: false, sortable: false }, 
													{ field: "username", title: "아이디", width: 100 }, 
													{ field: "name", title: "이름", width: 100 }, 
													{ field: "email", title: "메일" },
													{ field: "creationDate", title: "생성일", filterable: false,  width: 100, format: "{0:yyyy/MM/dd}" } ],         
												dataBound:function(e){  },
												toolbar: [{ name: "create-groups", text: "선택 사용자 소속 변경하기", imageClass:"k-icon k-i-folder-up" , className: "changeUserCompanyCustomClass" }]
											});												
										}
									 }
									$(this).tab('show')
								});
							}	
						}
					},
					dataBound: function(e){   
						// 1-2 Company 데이터를 새로 읽어드리면 기존 선택된 정보들과 상세 화면을 클리어 한다. 
						var selectedCells = this.select();				
						if(selectedCells.length == 0 )
						{
							selectedCompany = new Company({});		    
							kendo.bind($(".tabular"), selectedCompany );
							$("#menu").hide(); 	
							$("#company-details").hide(); 	 		
						}   
					}	                    
				}); //.css("border", 0);
				
				// MENU WINDOW
				$('#menu-grid').data("menuPlaceHolder", new Menu() )	;
				           	                	                
				// END SCRIPT
			}
		}]);
				
		function showMenuWindow(){		
			if(! $("#menu-grid").data("kendoGrid")){				
				$('#menu-grid').kendoGrid({
					dataSource: {
						transport: { 
							read: { url:'${request.contextPath}/secure/list-menu.do?output=json', type:'post' }
						},
						batch: false, 
						schema: {
							total: "totalMenuCount",
							data: "targetMenus",
							model: Menu
						},
						pageSize: 15,
						serverPaging: true,
						serverFiltering: false,
						serverSorting: false,  
						error:common.api.handleKendoAjaxError
					},
					columns: [
						{ title: "ID", field: "menuId",  width:40 },
						{ title: "이름", field: "name", width:100 }
					],
					pageable: { refresh:true, pageSizes:false,  messages: { display: ' {1} / {2}' }  },					
					resizable: true,
					editable : false,
					selectable : "row",
					scrollable: true,
					height: 400,
					width : 600,
					toolbar : [{ text: "메뉴 추가", className: "newMenuCustomClass"}] ,
					change: function(e) {
						var selectedCells = this.select();
						if( selectedCells.length == 1){ 
							var selectedCell = this.dataItem( selectedCells );     							
							var selectedMenu = $('#menu-grid').data("menuPlaceHolder");                 
							selectedMenu.menuId = selectedCell.menuId;
							selectedMenu.name = selectedCell.name;
							selectedMenu.title = selectedCell.title;
							selectedMenu.enabled = selectedCell.enabled;
							selectedMenu.description = selectedCell.description;
							selectedMenu.properties = selectedCell.properties;
							selectedMenu.menuData = selectedCell.menuData;
							selectedMenu.modifiedDate = selectedCell.modifiedDate;
							selectedMenu.creationDate = selectedCell.creationDate;	     
							   
							kendo.bind($(".menu-details"), selectedMenu );
							$(".menu-details").show();								 							 	
						}
					},
					dataBound: function(e){
						kendo.bind($(".menu-details"), {} );      	
						$(".menu-details").hide();
					}
				});	 						

 							$('#update-menu-btn').bind('click' , function(){
 								var selectedMenu = $('#menu-grid').data("menuPlaceHolder");
 								if( selectedMenu.menuId > 0){
									$.ajax({
										type : 'POST',
										url : "${request.contextPath}/secure/update-menu.do?output=json",
										data : { menuId:selectedMenu.menuId, item: kendo.stringify( selectedMenu ) },
										success : function( response ){									
										    $('#menu-grid').data('kendoGrid').dataSource.read();	
										},
										error: common.api.handleKendoAjaxError,
										dataType : "json"
									});	
								}else{
									$.ajax({
										type : 'POST',
										url : "${request.contextPath}/secure/create-menu.do?output=json",
										data : { menuId:selectedMenu.menuId, item: kendo.stringify( selectedMenu ) },
										success : function( response ){									
										    $('#menu-grid').data('kendoGrid').dataSource.read();	
										},
										error: common.api.handleKendoAjaxError,
										dataType : "json"
									});											
								}
							});							
							
	
				$(".newMenuCustomClass").click( function (e){
					$(".menu-details").show();
					$("#menu-grid").data("kendoGrid").clearSelection();
					$('#menu-grid').data("menuPlaceHolder", new Menu() );
					    
					kendo.bind($(".menu-details"), $('#menu-grid').data("menuPlaceHolder") );      
				});
						
				if(! $("#menu-window").data("kendoWindow")){       
					// WINDOW 생성
					$(".menu-details").hide();
					$("#menu-window").kendoWindow({								
						actions:  [ "Minimize", "Maximize", "Close"],
						resizable: true,
						modal: true,
						visible: false,
						title: '메뉴'
					});
				}			 		                   								
			}						
			var menuWindow = $("#menu-window").data("kendoWindow");
			$("#menu-window").closest(".k-window").css({
				top: 70,
				left: 15,
				width: 800
			});		
			//menuWindow.maximize();
			menuWindow.open();	
		}
		
		function showRoleWindow() {
			if(! $("#perms-window").data("kendoWindow")){								
					// WINDOW 생성
					$("#perms-window").kendoWindow({							
							minHeight : 300,
							maxHeight : 500,
							minWidth :  200,
							maxWidth :  700,
							modal: false,
							visible: false,
							title: '권한 정보',
							actions : [
								"Pin", "Close"
							]
						});
					}					
					if( ! $('#role-grid').data("kendoGrid")){
						// ROLE GRID 생성
						$('#role-grid').kendoGrid({
							dataSource: {
								transport: { 
									read: { url:'${request.contextPath}/secure/list-role.do?output=json', type:'post' }
								},						
								batch: false, 
								schema: {
									data: "roles",
									model: Role
								},
								error:common.api.handleKendoAjaxError
							},
							columns: [
								{ title: "ID", field: "roleId",  width:40 },
								{ title: "롤", field: "name" },
								{ title: "설명",   field: "description" }
							],
							pageable: false,
							resizable: true,
							editable : false,
							scrollable: true,
							height: 300,
							change: function(e) {
							}
						});								
			}					
			var permsWindow = $("#perms-window").data("kendoWindow");
			$("#perms-window").closest(".k-window").css({
				top: 70,
				left: 15,
				width: 800
			});	
			permsWindow.open();
		}
				 
		-->
		</script> 		 
		<style>
		.k-grid-content{
			height:300px;
		}	
	
		</style>
</#compress>		
	</head>
	<body>
		<!-- START HEADER -->
		<section id="navbar"></section>
		<!-- END HEADER -->
		<!-- START MAIN CONTNET -->
		<div class="container-fluid">		
			<div class="row">			
				<div class="page-header">
					<h1><span data-bind="text: title"></span>     <small><i class="fa fa-quote-left"></i>&nbsp;<span data-bind="text: description"></span>&nbsp;<i class="fa fa-quote-right"></i></small></h1>
				</div>			
			</div>	
			<div class="row">		
				<div class="col-sm-12">
					<div class="panel panel-default" style="min-height:300px;">
						<div class="panel-heading" style="padding:5px;">
							<div class="btn-group">
								<button type="button" class="btn btn-info btn-control-group" data-action="menu"><i class="fa fa-sitemap"></i> 메뉴</button>
								<button type="button" class="btn btn-info btn-control-group" data-action="role"><i class="fa fa-lock"></i> 권한 & 롤</button>
							</div>
							<div class="btn-group">
								<button type="button" class="btn btn-success btn-control-group" data-action="group"><i class="fa fa-users"></i> 그룹관리</button>
								<button type="button" class="btn btn-success btn-control-group" data-action="user"><i class="fa fa-user"></i> 사용자관리</button>
							</div>
							<button type="button" class="btn btn-default btn-control-group btn-columns-expend" data-action="layout"><i class="fa fa-columns"></i></button>					
						</div>
						<div class="panel-body" style="padding:5px;">
							<div class="row marginless paddingless">
								<div class="col-sm-12 body-group marginless paddingless">
									<div id="company-grid"></div>
								</div>
								<div id="company-details" class="col-sm-12 body-group marginless paddingless" style="display:none; padding-top:5px;"></div>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
				
		<div id="account-panel"></div>				
		<!-- END MAIN CONTENT -->
		<div id="perms-window" style="display:none;" class="clearfix">
			<div class="alert alert-info margin-buttom-5">
				<button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
				그룹 또는 사용자에게 부여 가능한 전체 롤(ROLE)은 다음과 같습니다.
			</div>					
			<div id="role-grid">	</div>            	
		</div>		

		<div id="menu-window" style="display:none;" class="gray">
			<div class="container-fluid layout">
				<div class="row">
					<div class="col-xs-4 marginless paddingless">
						<div id="menu-grid"></div>
					</div>
					<div class="col-xs-8 marginless paddingless" style="padding-left:5px;">
						<div class="panel panel-default menu-details marginless" style="dispaly:none">
							<div class="panel-body">
								<form class="form-horizontal">
									<div class="form-group">
										<label class="col-lg-2 control-label" for="input-menu-name">이름</label>
										<div class="col-lg-10">
											<input type="text" class="form-control" placeholder="이름" data-bind="value:name" id="input-menu-name"/>
										</div>
									</div>					
									<div class="form-group">
										<label class="col-lg-2 control-label" for="input-menu-title">타이틀</label>
										<div class="col-lg-10">
											<input type="text" class="form-control" placeholder="타이틀" data-bind="value:title" id="input-menu-title"/>
										</div>
									</div>				
									<div class="form-group">
										<label class="col-lg-2 control-label" >옵션</label>
										<div class="col-lg-10">
											<div class="checkbox">
												<label>
													<input type="checkbox"  name="enabled"  data-bind="checked: enabled" /> 사용여부
												</label>
											</div>
										</div>							
									</div>				
									<div class="form-group">
										<label class="col-lg-2 control-label" for="input-menu-description">설명</label>
										<div class="col-lg-10">
											<input type="text" class="form-control" placeholder="설명" data-bind="value:description" id="input-menu-description"/>
										</div>
									</div>			
									<div class="form-group">
										<label class="col-lg-2 control-label" for="input-menu-xmldata">XML &nbsp<br/><span class="label label-danger">Important</span></label>
										<div class="col-lg-10">
											<textarea  data-bind="value: menuData" rows="10" id="input-menu-xmldata" class="form-control"></textarea>
										</div>
									</div>									
								</form>
							</div>
							<div class="panel-footer">
								<button id="update-menu-btn" class="btn btn-primary"><i class="fa fa-check"></i> 저장</button>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
			
		<!-- START FOOTER -->
		<!-- END FOOTER -->		
		<form name="fm1" method="POST" accept-charset="utf-8" class="details">
			<input type="hidden" name="companyId" value="0" />
		</form>		
							
		<script type="text/x-kendo-template" id="company-details-template">			
			<div class="panel panel-primary marginless" >
			<!--
				<div class="panel-heading" >
					<span data-bind="text: displayName"></span>
					<button type="button" class="close" aria-hidden="true">&times;</button></div>
			-->
					<div class="panel-body" style="padding:5px;">
					<ul id="myTab" class="nav nav-tabs">
						<li class="active"><a href="\\#props" data-toggle="tab">프로퍼티</a></li>
						<li><a href="\\#groups" data-toggle="tab">그룹</a></li>
						<li><a href="\\#users" data-toggle="tab">사용자</a></li>
					</ul>			
					<div class="tab-content">
						<div class="tab-pane active" id="props">
							<div class="blank-top-5"></div>
							<div class="alert alert-danger margin-buttom-5">
								<button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
								프로퍼티는 수정 후 저장 버튼을 클릭하여야 최종 반영됩니다.
							</div>						
							<div id="company-prop-grid" class="props"></div>
						</div>
						<div class="tab-pane" id="groups">
							<div class="blank-top-5" ></div>	
							<div class="alert alert-danger margin-buttom-5">
								<button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
								그룹관리는  그룹관리를 사용하여 관리 하실수 있습니다.	     
							</div>						
							<div id="company-group-grid"  class="groups"></div>					
						</div>
						<div class="tab-pane" id="users">
							<div class="blank-top-5" ></div>	
							<div class="alert alert-danger margin-buttom-5">
								<button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
								사용자관리는 사용자관리를 사용하여 관리 하실수 있습니다.	     
							</div>							
							<div id="company-user-grid"  class="users"></div>
						</div>
					</div>
				</div>
			</div>
		</script>			
		<!-- 공용 템플릿 -->
		<#include "/html/common/common-secure-templates.ftl" >		        	
		<#include "/html/common/common-system-templates.ftl" >			
	</body>    
</html>