<#ftl encoding="UTF-8"/>
<html decorator="secure">
<head>
		<title>관리자 메인</title>		
		<link  rel="stylesheet" type="text/css"  href="<@spring.url "/styles/common.admin/pixel/pixel.admin.style.css"/>" />
		<script type="text/javascript">
		<!--		
		yepnope([{
			load: [
			'css!<@spring.url "/styles/font-awesome/4.2.0/font-awesome.min.css" />',
			'css!<@spring.url "/styles/common.plugins/animate.css" />',
			'css!<@spring.url "/styles/jquery.jgrowl/jquery.jgrowl.min.css" />',
			'css!<@spring.url "/styles/common.admin/pixel/pixel.admin.widgets.css" />',			
			'css!<@spring.url "/styles/common.admin/pixel/pixel.admin.rtl.css" />',
			'css!<@spring.url "/styles/common.admin/pixel/pixel.admin.themes.css" />',
			'css!<@spring.url "/styles/common.admin/pixel/pixel.admin.pages.css" />',				
			'<@spring.url "/js/jquery/1.10.2/jquery.min.js" />',
			'<@spring.url "/js/kendo/kendo.web.min.js" />',
			'<@spring.url "/js/kendo.extension/kendo.ko_KR.js" />',
			'<@spring.url "/js/kendo/cultures/kendo.culture.ko-KR.min.js" />',
			'<@spring.url "/js/jquery.jgrowl/jquery.jgrowl.min.js" />',			
			'<@spring.url "/js/bootstrap/3.3.5/bootstrap.min.js" />',			
			'<@spring.url "/js/common.plugins/fastclick.js" />', 
			'<@spring.url "/js/common.plugins/jquery.slimscroll.min.js" />', 
			'<@spring.url "/js/common.admin/pixel.admin.min.js" />',
			'<@spring.url "/js/common/common.ui.core.js" />',							
			'<@spring.url "/js/common/common.ui.data.js" />',
			'<@spring.url "/js/common/common.ui.community.js" />',
			'<@spring.url "/js/common/common.ui.admin.js" />',	
			'<@spring.url "/js/ace/ace.js" />'	
			],
			complete: function() {
				var currentUser = new common.ui.data.User();
				var targetCompany = new common.ui.data.Company();	
				common.ui.admin.setup({					 
					authenticate : function(e){
						e.token.copy(currentUser);
					},
					change: function(e){
						e.data.copy(targetCompany);
					}
				});		
				createSecurityTabPanels();
				// END SCRIPT
			}
		}]);
		
		function createSecurityTabPanels(){		
			$('#myTab').on( 'show.bs.tab', function (e) {				
				var target = $(e.target);
				if( target.data("action") ){
					switch( target.data("action") ){
						case "role" :
						createSelectBox();
						createRoleGrid();
						break;
					}	
				}			
			});
			$('#myTab a:first').tab('show');			
			
			
			$("#selected-user").kendoAutoComplete({
				placeholder:"ID 또는 메일주소를 입력하세요.",
                dataTextField: "username",
                filter: "contains",
                minLength: 3,
                headerTemplate: '<div class="dropdown-header k-widget k-header">' +
                                '<span>Photo</span>' +
                                '<span>Contact info</span>' +
                            '</div>',
                template: '<div class="user-profile">' +
                		  '<span class="k-state-default" style="background-image: url(\'/download/profile/#= username #?width=150&amp;height=150\')"></span>' +
                          '<span class="k-state-default"><h3>#: username #</h3><p>#: email #</p></span>' +
                          '</div>',
                dataSource: {
                    serverFiltering: true,
                    transport: {
                    	read:{
                        	type : "post", 
                            dataType:"json", 
                            url : '<@spring.url "/secure/data/mgmt/company/users/find.json?output=json"/>'
                        },
                        parameterMap: function (options, operation){
                        	if (common.ui.defined(options.filter)) {
								return { companyId: $("#perms-company-list").val(), nameOrEmail: options.filter.filters[0].value };
							}else{
								return { companyId: $("#perms-company-list").val() };
							}
						}
                    },
                    schema: {
						total: "totalCount",
						data: "items",
						model : common.ui.data.Company
					}
                }
             });
                    				
		}
		
		function createSelectBox(){		
			if( !$("#perms-company-list").data("kendoDropDownList") ){
				var companies = $("#perms-company-list").kendoDropDownList({
							optionLabel: "회사를 선택하세요...",
							dataTextField: "displayName",
							dataValueField: "companyId",
							dataSource : {
								transport : {
									read: { 
										type : "post", 
										dataType:"json", 
										url : '<@spring.url "/secure/data/mgmt/company/list.json?output=json"/>'
									}	
								},
								schema: {
									total: "totalCount",
									data: "items",
									model : common.ui.data.Company
								}
							}
				});	
			}
			if( !$("#perms-site-list").data("kendoDropDownList") ){			
				var websites = $("#perms-site-list").kendoDropDownList({
							autoBind: false,
							cascadeFrom: "perms-company-list",
							optionLabel: "웹 사이트를 선택하세요.",
							dataTextField: "displayName",
							dataValueField: "webSiteId",							
							dataSource : {
								serverFiltering: true,
								transport : {
									read: { type : "post", dataType:"json", url : '<@spring.url "/secure/data/mgmt/website/list.json?output=json"/>' },	
									parameterMap: function (options, operation){
										return { "company" :  options.filter.filters[0].value }; 
									}									
								},
								schema: {
									total: "totalCount",
									data: "items",
									model : common.ui.data.WebSite
								}
							},
							change:function(){
								if( this.value() > 0 ){
									//createPermissionListView(30, this.value(), getSelectedPermissionGroup);
								}
							}						
				}).data("kendoDropDownList");		
		
				$('#perms-30-listview').on("click","[data-action='update'], [data-action='cancle'], [data-action='create']", function(e){
					var $this = $(this);	
					var action = $this.data('action');
					var target = $($this.data("target"));
					console.log( action + " " + target.length ) ;
					target.each(function(index){
						var $that = $(this);
						console.log( index + " " + $that.data('name') + " " + $that.is(":checked") );						
					});						
				});		
				
				$('button[data-action=search]').click(function(e){
					var companyList = $("#perms-company-list").data("kendoDropDownList");
					if(companyList.value() > 0 && websites.value() > 0) {
						createPermissionListView(30, websites.value(), getSelectedPermissionGroup());
					}
					else if(companyList.value() > 0 && !(websites.value() > 0)) {
						console.log("company perms.");
						createPermissionListView(1, companyList.value(), getSelectedPermissionGroup());
					}else if (!(companyList.value() > 0) && !(websites.value() > 0)){
						createPermissionListView(14, -1, getSelectedPermissionGroup());
					}
				});								
			}	
		}
		
		function createPermissionListView(objectType, objectId, permissionGroup){
			common.ui.admin.permissions.list({
				objectType : objectType ,
				objectId : objectId,
				perms: permissionGroup,
				success:function(data){
					var renderTo = $('#perms-30-listview');
					var template = kendo.template( $("#perms-30-listview-template").html() );
					var data = $.extend( data , {
						ADDITIVE_MODE : isAdditivePermissionMode(), 
						PERM_GROUP_DEF: permissionGroup  
					} );
					renderTo.html( template(data) );
				}
			});			
		}
		
		function getSelectedPermissionGroup(){			
			var name = $('input[name=perms-group]:checked').val();
			return common.ui.admin.permissions.group(name);
		}
		
		function isAdditivePermissionMode(){
			if($("input[name=perms-options]:checked").val() == 1 )
				return true;
			else 
				return false;	
		} 
				
		function createRoleGrid(){
			var renderTo = $("#security-role-grid");
			if(! common.ui.exists(renderTo) ){
				common.ui.grid(renderTo, {
					dataSource: {
						transport: { 
							read: { url:'<@spring.url "/secure/data/mgmt/role/list.json?output=json"/>', type:'post' }
						},						
						batch: false, 
						pageSize: 15,
						schema: {
							data: "items",
							total: "totalCount",
							model: common.ui.data.Role
						}
					},
					columns: [
						{ title: "ID", field: "roleId",  width:40 },
						{ title: "이름", field: "name" },
						{ title: "설명",   field: "description" },
						{ command: [{ 
							name: "edit",
								className: "btn btn-xs btn-info",
								template : '<a href="\\#" class="btn btn-xs btn-labeled btn-info k-grid-edit btn-selectable"><span class="btn-label icon fa fa-pencil"></span> 변경</a>',
								text: { edit: "변경", update: "저장", cancel: "취소"}
							}
							], 
							title: "&nbsp;", 
							width: 180  
						}
					],
					toolbar: kendo.template('<div class="p-xs"><button class="btn btn-flat btn-labeled btn-outline btn-md btn-danger" data-action="create" data-object-id="0" data-loading-text="<i class=\'fa fa-spinner fa-spin\'></i> 조회중 ...\'"><span class="btn-label icon fa fa-plus"></span> 롤 추가 </button></div>'),
					pageable: { refresh:true, pageSizes:false,  messages: { display: ' {1} / {2}' }  },		
					resizable: true,
					editable : 'inline',
					selectable : "row",
					scrollable: true,
					height: 500,
					change: function(e) {
					}	
				});
				renderTo.find("button[data-action=create]").click(function(e){
					common.ui.grid(renderTo).addRow();
					common.ui.grid(renderTo).select("tr:eq(1)");
				});	
			}					
		}
		
		-->
		</script> 		 
		<style>

			.stat-cell .k-grid {
				border-top: 1px solid #e4e4e4;
				border-left: 1px solid #e4e4e4;
				border-top-width: 0 !important;
				border-right-width: 0 !important;
				border-bottom-width: 0 !important;				
			}
			.tab-pane .k-grid{
				min-height: 300px;
			} 
			
			.user-profile {
				padding-left: 5px;
                border-left: 0;
			}
			
			.user-profile > span {
				-webkit-box-sizing: border-box;
                -moz-box-sizing: border-box;
                box-sizing: border-box;
                display: inline-block;
                vertical-align: top;
                margin: 20px 10px 10px 5px;
			}

			.user-profile > span:first-child {
                -moz-box-shadow: inset 0 0 30px rgba(0,0,0,.3);
                -webkit-box-shadow: inset 0 0 30px rgba(0,0,0,.3);
                box-shadow: inset 0 0 30px rgba(0,0,0,.3);
                margin: 10px;
                width: 50px;
                height: 50px;
                border-radius: 50%;
                background-size: 100%;
                background-repeat: no-repeat;
            }

            .user-profile h3 {
                font-size: 1.2em;
                font-weight: normal;
                margin: 0 0 1px 0;
                padding: 0;
            }

            .user-profile p {
                margin: 0;
                padding: 0;
                font-size: .8em;
            }
                
                			
		</style>
	</head>
	<body class="theme-default main-menu-animated">
		<div id="main-wrapper">
			<#include "/html/common/common-system-navigation.ftl" >	
			<div id="content-wrapper">
				<ul class="breadcrumb breadcrumb-page">
					<#assign selectedMenu = WebSiteUtils.getMenuComponent("SYSTEM_MENU", "MENU_1_5_1") />
					<li><a href="#">Home</a></li>
					<li><a href="${ selectedMenu.parent.page!"#" }">${selectedMenu.parent.title}</a></li>
					<li class="active"><a href="#">${selectedMenu.title}</a></li>
				</ul>			
				<div class="page-header bg-dark-gray">					
					<h1><#if selectedMenu.isSetIcon() ><i class="fa ${selectedMenu.icon} page-header-icon"></i></#if> ${selectedMenu.title}  <small><i class="fa fa-quote-left"></i> ${selectedMenu.description!""} <i class="fa fa-quote-right"></i></small></h1>
				</div><!-- / .page-header -->				
					
				<div class="row">			
					<div class="col-lg-12">	
						<div class="panel colourable">
							<div class="panel-heading">
								<span class="panel-title"><i class="fa fa-info"></i></span>
								<ul class="nav nav-tabs nav-tabs-xs" id="myTab">
									<li>
										<a href="#bs-tabdrop-tab1" data-toggle="tab" data-action="role">웹 사이트 권한</a>
									</li>			
								</ul> <!-- / .nav -->
							</div> <!-- / .panel-heading -->					
							<div class="tab-content">
								<div class="tab-pane p-sm" id="bs-tabdrop-tab1">	

						<div class="form-group">
							<label class="col-sm-2 control-label">회  사</label>
							<div class="col-sm-10">
								<input id="perms-company-list" />
							</div> <!-- / .col-sm-10 -->
						</div>
						<div class="form-group">
							<label class="col-sm-2 control-label">사이트</label>
							<div class="col-sm-10">
								<input id="perms-site-list" />	
							</div> <!-- / .col-sm-10 -->
						</div>
						<div class="form-group">
							<label class="col-sm-2 control-label">권한 그룹</label>
							<div class="col-sm-10">
								<div class="radio">
									<label>
										<input type="radio" name="perms-group" value="WEB_ADMIN" class="px" checked="">
										<span class="lbl">관리자 권한</span>
									</label>
								</div> <!-- / .radio -->
								<div class="radio">
									<label>
										<input type="radio" name="perms-group" value="WEB_CONTENT" class="px">
										<span class="lbl">콘텐츠 권한</span>
									</label>
								</div> <!-- / .radio -->
								<div class="radio">
									<label>
										<input type="radio" name="perms-group" value="SYSTEM" class="px">
										<span class="lbl">시스템 권한</span>
									</label>
								</div> <!-- / .radio -->								
							</div> <!-- / .col-sm-10 -->
						</div>
						<div class="form-group">
							<label class="col-sm-2 control-label">권한 유형</label>
							<div class="col-sm-10">
								<div class="radio">
									<label>
										<input type="radio" name="perms-options" value="1" class="px" checked="">
										<span class="lbl">ADDITIVE</span>
									</label>
								</div> <!-- / .radio -->
								<div class="radio">
									<label>
										<input type="radio" name="perms-options" value="2" class="px">
										<span class="lbl">NEGATIVE</span>
									</label>
								</div> <!-- / .radio -->
							</div> <!-- / .col-sm-10 -->
						</div>						
						<div class="form-group" style="margin-bottom: 0;">
							<div class="col-sm-offset-2 col-sm-10">
								<button type="button" class="btn btn-primary btn-flat btn-outline" data-action="search">조회</button>
							</div>
						</div>								
											 
			 <input id="selected-user" style="width: 100%;" />
			 
			 <input id="selected-group" style="width: 100%;" />																								
									<div id="perms-30-listview" class="p-sm table-responsive"></div>																					
								</div>								
							</div><!-- tab contents end -->
						</div><!-- /.panel -->
					</div>
				</div>	
			</div> <!-- / #content-wrapper -->
			<div id="main-menu-bg">
			</div>
		</div> <!-- / #main-wrapper -->							
		<script id="perms-30-listview-template" type="text/x-kendo-template">
			<table class="table" width="100%">
				<thead>
				<tr>
					<th colspan="2" width="15%">&nbsp;</th>
					# for (var i = 0 ; i < PERM_GROUP_DEF.length; i++ ) { #
						<th class="text-center small" width="#= 70/PERM_GROUP_DEF.length #%"><span class="label">#: PERM_GROUP_DEF[i]#</span></th>
					# } #
					<th width="15%">&nbsp;</th>
				</tr>
				<tr class="active">
					<td colspan="#= PERM_GROUP_DEF.length + 2 #">User Types</td>
					<td>&nbsp;</td>
				</tr>				
				</thead>
				<tbody>
				
				<tr>
					<td colspan="2">Anonymous</td>
					# for(  var i = 0 ; i < anonymous.length ; i++) {
						var u_id = common.guid(); 
					#
					<td class="text-center">
						<input type="checkbox" class="k-checkbox" #if( anonymous[i].additive ){ #checked="checked" # } # id="#=u_id#"
							data-name="#= anonymous[i].name #" data-type="ADDITIVE" data-object-type="anonymous" >
         				<label class="k-checkbox-label" for="#=u_id#">&nbsp;</label>	
					</td>
					# } #
					<td>
						<div class="btn-group">
							<a href="\\#" class="btn btn-info btn-xs btn-flat btn-outline" data-action="update" data-target="[data-object-type=anonymous]">저장</a>
							<a href="\\#" class="btn btn-info btn-xs btn-flat btn-outline" data-action="cancle" data-target="[data-object-type=anonymous]">취소</a>
						</div>						
					</td>				
				</tr>
				
				<tr>
					<td colspan="2">Member</td>
					# for(  var i = 0 ; i < member.length ; i++) {
						var u_id = common.guid(); 
					#
					<td class="text-center">
						<input type="checkbox" class="k-checkbox" #if( member[i].additive ){ #checked="checked" # } # id="#= u_id #"
							data-name="#= member[i].name #" data-type="ADDITIVE" data-object-type="member">
         				<label class="k-checkbox-label" for="#= u_id #">&nbsp;</label>				
					</td>
					# } #
					<td>
						<div class="btn-group">
							<a href="\\#" class="btn btn-info btn-xs btn-flat btn-outline" data-action="update" data-target="[data-object-type=member]">저장</a>
							<a href="\\#" class="btn btn-info btn-xs btn-flat btn-outline" data-action="cancle" data-target="[data-object-type=member]">취소</a>
						</div>						
					</td>				
				</tr>		
				<tr class="active">
					<td colspan="#= PERM_GROUP_DEF.length + 3 #">User</td>
					<td>&nbsp;</td>
				</tr>
				#if(users.length == 0){#
				<tr>
					<td colspan="#= PERM_GROUP_DEF.length + 2 #" class="text-center text-info">정의된 사용자 권한 없음.</td>
				</tr>					
				#}#
				# for(  var i = 0 ; i < users.length ; i++) { #				
				<tr>
					<td colspan="2">
					<img width="25" height="25" class="img-circle no-margin" src="/download/profile/#= users[i].user #?width=150&amp;height=150" style="margin-right:10px;"> #: users[i].user.username #
					</td>
					# for(  var j = 0 ; j < PERM_GROUP_DEF.length ; j++) {
						var u_id = common.guid(); 
					#	
					# if(users[i].perms[PERM_GROUP_DEF[j]]) { #
					<td class="text-center">
						<input type="checkbox" class="k-checkbox" #if( users[i].perms[PERM_GROUP_DEF[j]].additive ){ #checked="checked" # } # id="#= u_id #"
							data-name="#= PERM_GROUP_DEF[j] #" data-type="ADDITIVE" data-object-type="users" data-object-id="#= users[i].user.userId #" >
         				<label class="k-checkbox-label" for="#= u_id #">&nbsp;</label>				
					</td>
					# } else { #
					<td class="text-center">
						<input type="checkbox" class="k-checkbox" id="#= u_id #"
							data-name="#= PERM_GROUP_DEF[j] #" data-type="ADDITIVE" data-object-type="users" data-object-id="#= users[i].user.userId #" >
         				<label class="k-checkbox-label" for="#= u_id #">&nbsp;</label>	
					</td>
					# } #
					#}#
					<td>
						<div class="btn-group">
							<a href="\\#" class="btn btn-info btn-xs btn-flat btn-outline" data-action="update">저장</a>
						</div>						
					</td>				
				</tr>
				#}#
				
				<tr class="active">
					<td colspan="#= PERM_GROUP_DEF.length + 3 #">Group</td>
					<td>&nbsp;</td>
				</tr>
				#if(groups.length == 0){#
				<tr>
					<td colspan="#= PERM_GROUP_DEF.length + 2 #" class="text-center text-info">정의된 그룹 권한 없음.</td>
				</tr>					
				#}#
				# for(  var i = 0 ; i < groups.length ; i++) {#				
				<tr>
					<td colspan="2">&nbsp;</td>
					<td class="text-center">
						<input name="perms-user-#=i#" type="checkbox" class="k-radio" id="perms-group-#=i#-additive">
         				<label class="k-checkbox-label" for="perms-user-#=i#-additive">&nbsp;</label>	
					</td>
					<td>
						<div class="btn-group">
							<a href="\\#" class="btn btn-info btn-xs btn-flat btn-outline" data-action="update">저장</a>
						</div>						
					</td>				
				</tr>
				#}#
								
				</tbody>
			</table>
		</script>					
		<#include "/html/common/common-system-templates.ftl" >			
	</body>    
</html>