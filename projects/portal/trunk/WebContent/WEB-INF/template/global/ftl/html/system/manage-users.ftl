<#ftl encoding="UTF-8"/>
<html decorator="secure">
    <head>
	<#compress>
        <title>사용자 관리</title>
        <link  rel="stylesheet" type="text/css"  href="${request.contextPath}/styles/common.admin/pixel/pixel.admin.style.css" />
        <script type="text/javascript">                
        yepnope([{
            load: [ 
			'css!${request.contextPath}/styles/font-awesome/4.2.0/font-awesome.min.css',
			'css!${request.contextPath}/styles/common.plugins/animate.css',
			'css!${request.contextPath}/styles/jquery.jgrowl/jquery.jgrowl.min.css',
			'css!${request.contextPath}/styles/common.admin/pixel/pixel.admin.widgets.css',			
			'css!${request.contextPath}/styles/common.admin/pixel/pixel.admin.rtl.css',
			'css!${request.contextPath}/styles/common.admin/pixel/pixel.admin.themes.css',
			'css!${request.contextPath}/styles/common.admin/pixel/pixel.admin.pages.css',	
			
			'${request.contextPath}/js/jquery/1.10.2/jquery.min.js',
			'${request.contextPath}/js/kendo/kendo.web.min.js',
			'${request.contextPath}/js/kendo.extension/kendo.ko_KR.js',
			'${request.contextPath}/js/kendo/cultures/kendo.culture.ko-KR.min.js',
			'${request.contextPath}/js/jquery.jgrowl/jquery.jgrowl.min.js',			
			'${request.contextPath}/js/bootstrap/3.0.3/bootstrap.min.js',			
			'${request.contextPath}/js/common.plugins/fastclick.js', 
			'${request.contextPath}/js/common.plugins/jquery.slimscroll.min.js', 
			'${request.contextPath}/js/common.admin/pixel.admin.min.js',
			
			'${request.contextPath}/js/common/common.models.js',       	    
			'${request.contextPath}/js/common/common.api.js',
			'${request.contextPath}/js/common/common.ui.js',
			'${request.contextPath}/js/common/common.ui.admin.js'],        	   
            complete: function() {       

				// 1-1.  한글 지원을 위한 로케일 설정
				common.api.culture();
				// 1-2.  페이지 렌딩
				common.ui.landing();				
				// 1-3.  관리자  로딩
				var currentUser = new User();
				
				var targetCompany = kendo.observable({
					company : new Company(),
					isEnabled : false,
					addUser : function(e){
						alert("준비중입니다.") ;
					}
				});	
				
				targetCompany.bind(
					"change",  function(e){
						if( e.field.match('^company.name')){ 						
							var sender = e.sender ;
							if( sender.company.companyId > 0 ){
								var dt = new Date();
								this.set("logoUrl", "/download/logo/company/" + sender.company.name + "?" + dt.getTime() );
								this.set("formattedCreationDate", kendo.format("{0:yyyy.MM.dd}",  sender.company.creationDate ));      
								this.set("formattedModifiedDate", kendo.format("{0:yyyy.MM.dd}",  sender.company.modifiedDate ));
							}
						}
					}
				);
				
				kendo.bind($("#user-list-panel"), targetCompany );					
				common.ui.admin.setup({
					authenticate: function(e){
						e.token.copy(currentUser);
					},
					companyChanged: function(item){
						item.copy(targetCompany.company);
						$("#user-grid").data("kendoGrid").dataSource.read();
					},
					switcherChanged: function( name , value ){						
					}
				});
				
				
				
				// 1. USER GRID 		        
				var user_grid = $("#user-grid").kendoGrid({
                    dataSource: {
                    	serverFiltering: true,
                        transport: { 
                            read: { url:'${request.contextPath}/secure/list-user.do?output=json', type: 'POST' },
	                        parameterMap: function (options, type){
	                            return { startIndex: options.skip, pageSize: options.pageSize,  companyId: targetCompany.company.companyId }
	                        }
                        },
                        schema: {
                            total: "totalUserCount",
                            data: "users",
                            model: User
                        },
                        error:handleKendoAjaxError,
                        batch: false,
                        pageSize: 15,
                        serverPaging: true,
                        serverFiltering: false,
                        serverSorting: false
                    },
                    columns: [
                  
                        { field: "userId", title: "ID", width:50,  filterable: false, sortable: false , headerAttributes: { "class": "table-header-cell", style: "text-align: center" }, locked: true, lockable: false}, 
                        { field: "username", title: "아이디", width: 150, headerAttributes: { "class": "table-header-cell", style: "text-align: center"}, locked: true, template:'#:username # <button type="button" class="btn btn-xs btn-success pull-right" onclick="javascript:showUserDetails(this); return false;">상세보기</button>'  }, 
                        { field: "name", title: "이름", width: 150 , headerAttributes: { "class": "table-header-cell", style: "text-align: center" }}, 
                        { field: "email", title: "메일", width: 200, headerAttributes: { "class": "table-header-cell", style: "text-align: center" } },
                        { field: "enabled", title: "사용여부", width: 120, headerAttributes: { "class": "table-header-cell", style: "text-align: center" } },
                        { field: "creationDate",  title: "생성일", width: 120,  format:"{0:yyyy.MM.dd}", headerAttributes: { "class": "table-header-cell", style: "text-align: center" } },
                        { field: "modifiedDate", title: "수정일", width: 120,  format:"{0:yyyy.MM.dd}", headerAttributes: { "class": "table-header-cell", style: "text-align: center" } } ],         
                    filterable: true,
                    sortable: true,
                    resizable: true,
                    pageable: { refresh:true, pageSizes:false,  messages: { display: ' {1} / {2}' }  },
                    selectable: 'row',
                    height: '100%',
                    autoBind: false,
                    change: function(e) {                    
                        var selectedCells = this.select();                 
  						if( selectedCells.length > 0){
 						}
					},
					dataBound: function(e){		
						 var selectedCells = this.select();
						 if(selectedCells.length == 0 ){
						 	$("#user-details").hide();
						 }
					}
				}).data('kendoGrid');
			}	
		}]);

		function getSelectedUser(){
			var renderTo = $("#user-grid");
			var grid = renderTo.data('kendoGrid');
			var selectedCells = grid.select();
			var selectedCell = grid.dataItem( selectedCells );   
			return selectedCell;
		}
		function getUserDetailsModel () {
			var renderTo = $('#user-details');
			var model = renderTo.data("model");
			return model;
		}	
		/**
		* Show user detailis
		*/
		function showUserDetails(){		
			var renderTo = $('#user-details');					
			if( $('#user-details').text().trim().length	== 0 ){
				renderTo.html(kendo.template($('#user-details-template').html()));					

				var detailsModel = kendo.observable({
					user : new User(),
					isVisible : false,
					isChanged : false,
					isChangable : false,
					scrollDown:function(e){	
						$('html,body').animate({scrollTop: renderTo.offset().top - 55 }, 300);
					},
					scrollTop:function(e){					
						$('html,body').animate({ scrollTop:  0 }, 300);
					},
					addToMember(e){
						
					},
					updateProfile:function(e){
						var btn = $(e.target);
						btn.button('loading');
						return false;
					}
				});			
					
				detailsModel.bind("change", function(e){		
					var sender = e.sender ;
					if( e.field.match('^user.username') ){						
						if( sender.user.userId > 0 ){
							this.set("profileImageUrl", common.api.user.photoUrl( sender.user, 150, 200 ) );
							this.set("isVisible", true );
							this.set("isChanged", false);
							this.set("isChangable", false);
							if( $('#myTab li:first.active').length == 0 ){ 
								$('#myTab a:first').tab('show') ;
							}else{
								createUserPropsPane($("#user-props-grid"));
							}							
						}
					} else if(this.isChangable) {
						if( e.field.match('^user.name') || e.field.match('^user.email') || e.field.match('^user.nameVisible') || e.field.match('^user.emailVisible') || e.field.match('^user.enabled')){
							this.set("isChanged", true);
						}
					}
				});
				
				if(!$("#files").data("kendoUpload")){
					$("#files").kendoUpload({
					 	multiple : false,
					 	showFileList : false,
					    localization:{ select : '사진변경' , dropFilesHere : '업로드할 이미지를 이곳에 끌어 놓으세요.' },
					    async: {
						    saveUrl:  '${request.contextPath}/secure/save-user-image.do?output=json',							   
						    autoUpload: true
						},
						upload: function (e) {		
							var selectedUser = detailsModel.user;						         
						    var imageId = -1;
							if( selectedUser.properties.imageId ){
								imageId = selectedUser.properties.imageId
							}
							e.data = { userId: selectedUser.userId , imageId:imageId  };																    								    	 		    	 
						},
						success : function(e) {								    
							detailsModel.set( 'profileImageUrl', common.api.user.photoUrl( selectedUser, 150, 200 ) );
						}					   
					});			
				}					
												
				$('#myTab').on( 'show.bs.tab', function (e) {
					var show_bs_tab = $(e.target);
					if(show_bs_tab.attr('href') == '#props' ) {
						createUserPropsPane($("#user-props-grid"));
					}else if(show_bs_tab.attr('href') == '#groups' ) {
						createUserGroupsPane($("#user-group-grid"));
					}else if(show_bs_tab.attr('href') == '#roles' ) {
						createUserRolesPane();
					}
				});
				
				renderTo.data("model", detailsModel );	
				kendo.bind(renderTo, detailsModel );	
			}						
			getSelectedUser().copy( renderTo.data("model").user );
			renderTo.data("model").set("isChangable", true );
			if(renderTo.is(':hidden')){
				renderTo.fadeIn("slow");
			}
		}
		
		function createUserRolesPane(renderTo){
			if( !$('#group-role-selected').data('kendoMultiSelect') ){
				$('#group-role-selected').kendoMultiSelect({
				                                    placeholder: "NONE",
									                dataTextField: "name",
									                dataValueField: "roleId",
									                dataSource: {
									                    transport: {
									                        read: {
							                                    url: '${request.contextPath}/secure/get-user-group-roles.do?output=json',
																dataType: "json",
																type: "POST",
																data: { userId: getUserDetailsModel().user.userId }
									                        }
									                    },
									                    schema: { 
						                            		data: "userGroupRoles",
						                            		model: Role
						                        		}
									                },
						                        	error:handleKendoAjaxError,
						                        	dataBound: function(e) {
						                        		var multiSelect = $("#group-role-selected").data("kendoMultiSelect");
						                        		var selectedRoleIDs = "";
						                        		$.each(  multiSelect.dataSource.data(), function(index, row){  
						                        			if( selectedRoleIDs == "" ){
						                        			    selectedRoleIDs =  selectedRoleIDs + row.roleId ;
						                        			}else{
						                        				selectedRoleIDs = selectedRoleIDs + "," + row.roleId;
						                        			}
						                        		} );			                        		
						                        		multiSelect.value( selectedRoleIDs.split( "," ) );
						                        		multiSelect.readonly();		
						                        	}
				});	
			}									    
			// SELECT USER ROLES
			if( !$('#user-role-select').data('kendoMultiSelect') ){											
				var selectedRoleDataSource = new kendo.data.DataSource({
													transport: {
										            	read: { 
										            		url:'${request.contextPath}/secure/get-user-roles.do?output=json', 
										            		dataType: "json", 
										            		type:'POST',
										            		data: { userId: getUserDetailsModel().user.userId }
												        }  
												    },
												    schema: {
									                	data: "userRoles",
									                    model: Role
									                },
									                error:handleKendoAjaxError,
									                change: function(e) {                
						                        		var multiSelect = $("#user-role-select").data("kendoMultiSelect");
						                        		var selectedRoleIDs = "";			                        		
						                        		$.each(  selectedRoleDataSource.data(), function(index, row){  
						                        			if( selectedRoleIDs == "" ){
						                        			    selectedRoleIDs =  selectedRoleIDs + row.roleId ;
						                        			}else{
						                        				selectedRoleIDs = selectedRoleIDs + "," + row.roleId;
						                        			}
						                        		} );			                        		
						                        		multiSelect.value( selectedRoleIDs.split( "," ) );	 
									                }	                               
				                               	});
				$('#user-role-select').kendoMultiSelect({
					placeholder: "롤 선택",
					dataTextField: "name",
					dataValueField: "roleId",
					dataSource: {
						transport: {
							read: {
								url: '${request.contextPath}/secure/list-role.do?output=json',
								dataType: "json",
								type: "POST"
							}
						},
						schema: { 
							data: "roles",
							model: Role
						}
					},
					error:handleKendoAjaxError,
					dataBound: function(e) {
						selectedRoleDataSource.read();   	
					},			                        	
					change: function(e){
						var multiSelect = $("#user-role-select").data("kendoMultiSelect");			                        		
						var list = new Array();			                        		                  		
						$.each(multiSelect.value(), function(index, row){  
							var item =  multiSelect.dataSource.get(row);
							list.push(item);			                        			
						});			                        		
						multiSelect.readonly();						                        		
						$.ajax({
							dataType : "json",
							type : 'POST',
							url : "${request.contextPath}/secure/update-user-roles.do?output=json",
							data : { userId: getUserDetailsModel().user.userId, items: kendo.stringify( list ) },
							success : function( response ){		
								// need refresh ..
							},
							error:handleKendoAjaxError
						});												
						multiSelect.readonly(false);
					}
				});
			}			
		}
		
		function createUserPropsPane(renderTo){
			if( ! renderTo.data("kendoGrid") ){
				renderTo.kendoGrid({
					dataSource: {
						transport: { 
											read: { url:'${request.contextPath}/secure/get-user-property.do?output=json', type:'post' },
										    create: { url:'${request.contextPath}/secure/update-user-property.do?output=json', type:'post' },
										    update: { url:'${request.contextPath}/secure/update-user-property.do?output=json', type:'post'  },
										    destroy: { url:'${request.contextPath}/secure/delete-user-property.do?output=json', type:'post' },
										 	parameterMap: function (options, operation){
										 		var selectedUser = getUserDetailsModel().user;
									 			if (operation !== "read" && options.models) {
					                          		return { userId: selectedUser.userId, items: kendo.stringify(options.models)};
					                        	} 
							                	return { userId: selectedUser.userId }
							             	}
						},						
										batch: true, 
										schema: {
						                	data: "targetUserProperty",
						                	model: Property
						            	},
						            	error:handleKendoAjaxError
									},
									columns: [
									    { title: "이름", field: "name" , width: 200,  locked:true},
									    { title: "값",   field: "value", width: 200, },
										{ command:  { name: "destroy", text:"삭제" },  title: "&nbsp;", width: 100 }
									],
									autoBind: true, 
									pageable: false,
									scrollable: true,
									height: 200,
							        editable: {
										update: true,
							            destroy: true,
							            confirmation: "선택하신 프로퍼티를 삭제하겠습니까?"	
							        },
									toolbar: [
								      { name: "create", text: "추가" },
					                  { name: "save", text: "저장" },
					                  { name: "cancel", text: "취소" }
									],				     
									change: function(e) {  
					}
				});						
			}			
			renderTo.data("kendoGrid").dataSource.read();
		}
		
		function createUserGroupsPane(renderTo){
			if(!$("#user-company-combo").data("kendoComboBox") ){
				var company_combo = $("#user-company-combo").kendoComboBox({
					autoBind: false,
					placeholder: "회사 선택",
					dataTextField: "displayName",
					dataValueField: "companyId",
					dataSource: common.ui.admin.setup().companySelector.dataSource
				});
				var selectedUser = getUserDetailsModel().user;
				$("#user-company-combo").data("kendoComboBox").value( 
					selectedUser.company.companyId
				);
				$("#user-company-combo").data("kendoComboBox").readonly();
			}
			if( !$("#user-group-combo").data("kendoComboBox") ){
				$("#user-group-combo").kendoComboBox({
												autoBind: false,
												placeholder: "그룹 선택",
						                        dataTextField: "displayName",
						                        dataValueField: "groupId",
						                        cascadeFrom: "company-combo",			                       
											    dataSource:  {
													type: "json",
												 	serverFiltering: true,
													transport: {
														read: { url:'${request.contextPath}/secure/list-company-group.do?output=json', type:'post' },
														parameterMap: function (options, operation){											 	
														 	return { companyId:  options.filter.filters[0].value };
														}
													},
													schema: {
														data: "companyGroups",
														model: Group
													},
													error:handleKendoAjaxError
												}
				});											
			}
												
			if( ! renderTo.data("kendoGrid") ){	
				renderTo.kendoGrid({
					dataSource: {
						type: "json",
						transport: {
							read: { url:'${request.contextPath}/secure/list-user-groups.do?output=json', type:'post' },
							destroy: { url:'${request.contextPath}/secure/remove-group-members.do?output=json', type:'post' },
							parameterMap: function (options, operation){
								var selectedUser = getUserDetailsModel().user;
								if (operation !== "read" && options.models) {
									return { userId: selectedUser.userId, items: kendo.stringify(options.models)};
								}
								return { userId: selectedUser.userId };
							}
						},
						schema: {
							data: "userGroups",
							model: Group
						},
						error:handleKendoAjaxError
					},
					scrollable: true,
					height: '100%',
					editable: false,
					columns: [
						{ field: "groupId", title: "ID", width:40,  filterable: false, sortable: false }, 
						{ field: "displayName",    title: "그룹",   filterable: true, sortable: true,  width: 100 },
						{ command:  { text: "삭제", click : function(e){									                       		
							if( confirm("정말로 삭제하시겠습니까?") ){
								var selectedGroup = this.dataItem($(e.currentTarget).closest("tr"));									                       		
									$.ajax({
										type : 'POST',
										url : "/secure/remove-group-members.do?output=json",
										data : { groupId:selectedGroup.groupId, items: '[' + kendo.stringify( selectedUser ) + ']'  },
										success : function( response ){									
										$('#user-group-grid').data('kendoGrid').dataSource.read();
										$('#group-role-selected').data("kendoMultiSelect").dataSource.read();
									},
									error:handleKendoAjaxError,
									dataType : "json"
								});								                       		
							}
						}},  title: "&nbsp;", width: 100 }	
					],
					dataBound:function(e){										                
					}
				});
			}
		}
		
		</script>
		<style>			
		.k-grid-content{
			height:300px;
		}		
		
		#user-details .dropdown-menu {
			top: 190px;
			left: 50px; 
			padding : 20px;
			min-width:300px;
		}
		#change-password-window .container {
			width:500px;
		}		
		</style>
		</#compress>
    </head>
	<body class="theme-default main-menu-animated page-profile">
		<div id="main-wrapper">
			<#include "/html/common/common-system-navigation.ftl" >	
			<div id="content-wrapper">
				<ul class="breadcrumb breadcrumb-page">
					<#assign selectedMenu = WebSiteUtils.getMenuComponent("SYSTEM_MENU", "MENU_2_2") />
					<li><a href="#">Home</a></li>
					<li><a href="${ selectedMenu.parent.page!"#" }">${selectedMenu.parent.title}</a></li>
					<li class="active"><a href="#">${selectedMenu.title}</a></li>
				</ul>			
				<div class="page-header bg-dark-gray">					
					<h1><#if selectedMenu.isSetIcon() ><i class="fa ${selectedMenu.icon} page-header-icon"></i></#if> ${selectedMenu.title}  <small><i class="fa fa-quote-left"></i> ${selectedMenu.description!""} <i class="fa fa-quote-right"></i></small></h1>
				</div><!-- / .page-header -->	
				<div id="company-details" class="page-details">
					<div class="row">		
						<div class="col-sm-12">
							<!-- user grid panel -->		
							<div id="user-list-panel" class="panel panel-default" style="min-height:300px;" >
								<div class="panel-heading">
									<span class="panel-title"><i class="fa fa-align-justify"></i> <span data-bind="text:company.displayName"></span> 사용자 목록</span>
									<div class="panel-heading-controls">											
										<span class="panel-heading-text text-light-gray text-xs" style="font-size:11px;font-weight:600;margin-top:3px;">목록항상보기&nbsp;&nbsp;</span>
										<div class="switcher switcher-primary checked"><input type="checkbox" data-class="switcher-sm" id="panel-switcher" checked="checked"><div class="switcher-toggler"></div><div class="switcher-inner"><div class="switcher-state-on">ON</div><div class="switcher-state-off">OFF</div></div></div>
									</div>
								</div>
								<div class="panel-body padding-sm">
									<div class="note note-info no-margin-b">
										<h4 class="note-title"><small><i class="fa fa-info"></i> 그룹을 사용하면 더욱 쉽게 권한을 관리할 수 있습니다.</small></h4>
										<button class="btn btn-danger btn-labeled" data-bind="click:addUser"><span class="btn-label icon fa fa-plus"></span> 사용자 추가 </button>
									</div>	
								</div>
								<div id="user-grid"  class="no-border-hr"></div>
								<div class="panel-footer no-padding-vr"></div>
							</div>	
							<!-- ./user grid panel -->
							<!-- user details panel -->
							<div id="user-details" style="display:none;" class="details"></div>
							<!-- ./user details panel -->
						</div><!-- / .col-sm-12 -->
					</div><!-- / .row -->	
				</div>				
			</div> <!-- / #content-wrapper -->
			<div id="main-menu-bg">
			</div>
		</div> <!-- / #main-wrapper -->

		<div class="container-fluid">	
			<div class="row">		
				<div class="col-sm-12">
					<div class="panel panel-default" style="min-height:300px;" >
						<div class="panel-heading selected-company-info" style="padding:5px;">						
							<div class="btn-group">
							<#if request.isUserInRole('ROLE_SYSTEM' )>
								<button type="button" class="btn btn-info btn-sm  btn-control-group" data-action="company"><i class="fa fa-building-o"></i>  회사관리</button>				
							</#if>				
								<button type="button" class="btn btn-info btn-sm  btn-control-group" data-action="site"><i class="fa fa-sitemap"></i>  웹사이트 관리</button>
								<button type="button" class="btn btn-info btn-sm  btn-control-group" data-action="group"><i class="fa fa-users"></i>  그룹관리</button>
							</div>
						<#if request.isUserInRole('ROLE_ADMIN' ) || request.isUserInRole('ROLE_SYSTEM' )>
							<button type="button" class="btn btn-info btn-sm  btn-control-group" data-action="addUser"><i class="fa fa-plus"></i>  사용자 추가</button>
						</#if>
						</div>
						<div class="panel-body" style="padding:5px;">
							
							<div id="file-preview-panel" class="custom-panels-group"></div>
						</div>	
						<div class="panel-body" style="padding:5px;">
							
						</div>					
					</div>				
				</div>			
			</div>							
			<form name="fm1" method="POST" accept-charset="utf-8">
				<input type="hidden" name="companyId"  value="${action.targetCompany.companyId}" />
			</form>	
		</div>		
		
		
		<div id="change-password-window" style="display:none;">
		<div class="container layout">	
			<div class="row">
				<div class="col-12 col-xs-12">
					<p>
					    	6~16자의 영문 대소문자, 숫자, 특수문자를 조합하여
							사용하실 수 있습니다.
							생년월일, 전화번호 등 개인정보와 관련된 숫자,
							연속된 숫자와 같이 쉬운 비밀번호는 다른 사람이 쉽게
							알아낼 수 있으니 사용을 자제해 주세요.
							이전에 사용했던 비밀번호나 타 사이트와는 다른 비밀번호를
							사용하고, 비밀번호는 주기적으로 변경해주세요.
							<div class="alert alert-danger">비밀번호에 특수문자를 추가하여 사용하시면
							기억하기도 쉽고, 비밀번호 안전도가 높아져 도용의 위험이
							줄어듭니다.	
							</div>    	
					</p>	
				</div>
			</div>
			<div class="row">
				<div class="col-12 col-xs-12">									
					<form class="form-horizontal">
						<div class="form-group">
							<label class="col-lg-5 control-label" for="password2">새 비밀번호</label>
							<div class="col-lg-7">
								<input type="password" id="password2" name="password2" class="form-control" placeholder="비밀번호" required validationMessage="비밀번호를 입력하여 주세요." />
							</div>
						</div>	
						<div class="form-group">
							<label class="col-lg-5 control-label" for="password3">새 비밀번호 확인</label>
							<div class="col-lg-7">
								<input type="password" id="password3" name="password3" class="form-control"  placeholder="비밀번호 확인" required validationMessage="비밀번호를 입력하여 주세요." />
							</div>
						</div>		
						<div class="form-group">	
							<div class="col-lg-4"></div>
							<div class="col-lg-8">
								<div class="btn-group">
									<button id="do-change-password-btn" class="btn btn-primary">확인</button>
									<button class="btn btn-default" type="reset">다시입력</button></div>
								</div>
							</div>
						</div>
					</form>
				</div>
			</div>	
		</div>
		</div>
				
		<script id="download-window-template" type="text/x-kendo-template">				
			#if (contentType.match("^image") ) {#
				<img src="${request.contextPath}/secure/view-attachment.do?attachmentId=#= attachmentId #" class="img-responsive" alt="#= name #" />
			# } else { #
			
			# } #  
			<div class="blank-top-5"></div>		
			<table class="table table-bordered blank-top-5">
			  <thead>
			    <tr>
			      <th>이름</th>
			      <th>유형</th>
			      <th>크기(bytes)</th>
			      <th>&nbsp;</th>
			    </tr>
			  </thead>
			  <tbody>
			    <tr>
			      <td  width="300">#= name #</td>
			      <td  width="150">#= contentType #</td>
			      <td  width="200">#= size #</td>
			      <td  width="150"><a class="btn btn-default" href="${request.contextPath}/secure/download-attachment.do?attachmentId=#= attachmentId #" ><i class="fa fa-download"></i> 다운로드</a></td>
			    </tr>
			  </tbody>
			</table>				
		</script>			
		
		<!--  User Detetails Template -->
		<script type="text/x-kendo-template" id="user-details-template">			
		<div class="panel panel-default" >
			<div class="panel-heading" >
				<i class="fa fa-male"></i>&nbsp;<span data-bind="text: user.username"></span>
				<button type="button" class="close" aria-hidden="true">&times;</button>
				<div class="panel-heading-controls" style="padding-right: 25px;">						
					<span class="panel-heading-text text-light-gray text-xs" style="font-size:11px;font-weight:600;margin-top:3px;">목록으로 이동&nbsp;&nbsp;</span>
					<button type="button" class="btn btn-rounded btn-outline btn-info" data-bind="click:scrollTop"><i class="fa fa-angle-double-up fa-lg"></i></button>						
				</div>
			</div>	
			<!-- ./panel-heading -->			
			<!-- panel-body -->			
			<div class="panel-body">			
				<div class="row">
					<div class="col-lg-6 col-xs-12">
						<!--  start basic info -->	
						<div class="profile-row no-margin-t">						
							<div class="left-col">	
								<div class="profile-block no-margin-t">
									<div class="panel profile-photo">
										<a class="pull-left dropdown-toggle" href="\\#" data-toggle="dropdown">
											<img id="user-photo" src="${request.contextPath}/images/common/no-avatar.png" border="0" data-bind="attr:{ src: profileImageUrl }" />			
										</a>
										<ul class="dropdown-menu">
											<li role="presentation" class="dropdown-header">마우스로 사진을 끌어 놓으세요.</li>
											<li><input name="uploadImage" id="files" type="file" class="pull-right" /></li>
										</ul>			
									</div><!-- ./profile-photo -->
								</div><!-- ./profile-block -->
							</div><!-- ./left-col -->						
							<div class="right-col">	
								<div class="profile-content">
									<table class="table">
										<tbody>
											<tr>
												<th class="col-lg-3 col-sm-4">아이디</th>
												<td><input type="text" class="form-control" placeholder="아이디" disabled data-bind="value:user.username"/></td>
											</tr> 
											<tr>
												<th class="col-lg-3 col-sm-4">이름</th>
												<td><input type="text" class="form-control" placeholder="이름" data-bind="value:user.name"/></td>
											</tr> 
											<tr>
												<th class="col-lg-3 col-sm-4">메일</th>
												<td><input type="email" class="form-control" placeholder="메일주소" data-bind="value:user.email"/></td>
											</tr> 
											<tr>
												<th class="col-lg-3 col-sm-4">옵션</th>
												<td>
													<div class="checkbox">
														<label>
															<input type="checkbox" name="nameVisible"  data-bind="checked: user.nameVisible" />	이름공개
														</label>
													</div>		
													<div class="checkbox">
														<label>
															<input type="checkbox"  name="emailVisible"  data-bind="checked: user.emailVisible" />	메일공개
														</label>
													</div>	
													<div class="checkbox">
														<label>
															<input type="checkbox"  name="enabled"  data-bind="checked: user.enabled" />계정사용여부
														</label>
													</div>										
												</td>
											</tr> 																		
											<tr>
												<th class="col-lg-3 col-sm-4"><small>마지막 프로파일 수정일</small></th>
												<td><small><span data-bind="text: user.lastProfileUpdate" data-format="{yyyy.MM.dd }"></span></small></td>
											</tr>  
											<tr>
												<th class="col-lg-3 col-sm-4"><small>마지막 로그인 일자</small></th>
												<td><small><span data-bind="text: user.lastLoggedIn" data-format="yyyy.MM.dd HH:mm:ss"></span></small></td>
											</tr>  
										</tbody>
									</table>								
								</div><!-- ./profile-content -->
							</div><!-- ./right-col -->		
						</div><!-- ./profile-row -->	
						<div class="btn-group pull-right">
							<button disabled class="btn btn-primary btn-flat" disabled data-bind="enabled:isChanged, click: updateProfile" data-loading-text='<i class="fa fa-spinner fa-spin"></i>' >정보 변경</button>
							<#if request.isUserInRole('ROLE_SYSTEM' )>
							<button id="change-password-btn" class="btn btn-primary">비밀번호변경</button>					
							</#if>
						</div>						
					</div><!-- ./col-md-6 -->	
					<div class="col-lg-6 col-xs-12">
						<ul id="myTab" class="nav nav-tabs nav-tabs-xs">
							<li><a href="\\#props" data-toggle="tab">프로퍼티</a></li>
							<li><a href="\\#groups" data-toggle="tab">그룹</a></li>
							<li><a href="\\#roles" data-toggle="tab">롤</a></li>
						</ul>								
						<div class="tab-content padding-sm no-padding-hr">
							<div class="tab-pane fade" id="props">
								<span class="help-block"><i class="fa fa-info"></i>  프로퍼티는 수정 후 저장 버튼을 클릭하여야 최종 반영됩니다.</span>
								<div id="user-props-grid"></div>									
							</div>
							<div class="tab-pane fade" id="groups">																	
								<div class="form-horizontal">
									<span class="help-block"><i class="fa fa-info"></i> 멤버로 추가하려면 리스트 박스에서 그룹을 선택후 "그룹 멤버로 추가" 버튼을 클릭하세요.</span>			
									<div class="row">
										<div class="col-sm-6">
											<div class="form-group no-margin-hr">
												<h6 class="text-light-gray text-semibold text-xs" style="margin:20px 0 10px 0;">회사</h6>
												<input id="user-company-combo" style="width: 100%" />
											</div>										
										</div>
										<div class="col-sm-6">
											<div class="form-group no-margin-hr">
												<h6 class="text-light-gray text-semibold text-xs" style="margin:20px 0 10px 0;">그룹</h6>
												<input id="user-group-combo" style="width: 100%" />
											</div>											
										</div>										
									</div>
									<div class="row">
										<div class="col-sm-12">																											
											<div id="user-group-grid" class="groups"></div>	
											<div class="pull-right padding-sm"><button class="btn btn-sm btn-danger btn-labeled" data-bind="click:addToMember" data-loading-text='<i class="fa fa-spinner fa-spin"></i>' ><span class="btn-label icon fa fa-plus"></span> 맴버로 추가 </button></div>
										</div>										
									</div>
								</div><!-- ./form-horizontal -->							
							</div><!-- ./tab-pane -->							
								<div class="tab-pane fade" id="roles">
									<div class="row">
										<div class="col-sm-12">
											<span class="help-block"><i class="fa fa-info"></i> 다음은 맴버로 가입된 그룹으로 부터 상속된 롤입니다. 그룹에서 상속된 롤은 그룹 관리에서 변경할 수 있습니다.</span>
											<div id="group-role-selected"></div>
										</div>
									</div>	
									<div class="row">
										<div class="col-sm-12">
											<span class="help-block"><i class="fa fa-info"></i> 다음은 사용자에게 직접 부여된 롤입니다. 그룹에서 부여된 롤을 제외한 롤들만 아래의 선택박스에서 사용자에게 부여 또는 제거하세요.</span>
											<div id="user-role-select"></div> 
										</div>
									</div>	
								</div>			
							</div>
						<!-- end additional info -->
						</div>
					</div>
				</div>
				<!-- panel-body -->			
				<div class="panel-footer no-padding-vr">								
				</div>
			</div>			
		</div>
		</script>			
		<!-- 공용 템플릿 -->		
		<#include "/html/common/common-system-templates.ftl" >	
		<!-- END MAIN CONTENT  -->
    </body>
</html>