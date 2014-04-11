<#ftl encoding="UTF-8"/>
<html decorator="secure">
    <head>
        <title>그룹 관리</title>
<#compress>        
        <script type="text/javascript">
        <!--
        yepnope([{
            load: [ 	       
			'css!${request.contextPath}/styles/font-awesome/4.0.3/font-awesome.min.css',			
			'${request.contextPath}/js/jquery/1.10.2/jquery.min.js',
       	    '${request.contextPath}/js/kendo/kendo.web.min.js',
			'${request.contextPath}/js/jgrowl/jquery.jgrowl.min.js',      	    
			'${request.contextPath}/js/kendo.extension/kendo.ko_KR.js',			 
			'${request.contextPath}/js/kendo/cultures/kendo.culture.ko-KR.min.js', 
			'${request.contextPath}/js/bootstrap/3.0.3/bootstrap.min.js',       	    
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
				var selectedCompany = new Company({companyId:${action.targetCompany.companyId}});			
								
				// 3.MENU LOAD
			
				var currentPageName = "MENU_1_3";
				var topBar = $("#navbar").extTopNavBar({ 
					menu:"SYSTEM_MENU",
					template : kendo.template($("#topnavbar-template").html() ),
					items: [
						{ 
							name:"companySelector", 	selector: "#companyDropDownList", value: ${action.targetCompany.companyId},
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
		
				// 4. CONTENT MAIN		
				$("button.btn-control-group ").each(function (index) {					
					var btn_control = $(this);
					var btn_control_action = btn_control.attr("data-action");
					if (btn_control_action == "user"){
						btn_control.click( function(e){			
							$("form[name='fm1'] input").val(selectedCompany.companyId);		
							$("form[name='fm1']").attr("action", "main-user.do" ).submit(); 
						} );						
					}else if (btn_control_action == "layout"){
						btn_control.click(function (e) {										
							$(".body-group").each(function( index ) {
								var panel_body = $(this);
								var is_detail_body = false;
								if (panel_body.attr("id") == "group-details"){
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
				// 1. GROUP GRID			        
			        var selectedGroup = new Group();		      
			        var group_grid = $("#group-grid").kendoGrid({
	                    dataSource: {	
	                        transport: { 
	                            read: { url:'${request.contextPath}/secure/list-group.do?output=json', type: 'POST' },
	                            create: { url:'${request.contextPath}/secure/create-group.do?output=json', type:'POST' },             
	                            update: { url:'${request.contextPath}/secure/update-group.do?output=json', type:'POST' },
		                        parameterMap: function (options, operation){	          
		                            if (operation != "read" && options) {
		                                return { companyId: selectedCompany.companyId, item: kendo.stringify(options)};
		                            }else{
		                                return { startIndex: options.skip, pageSize: options.pageSize , companyId: selectedCompany.companyId }
		                            }
		                        }                  
	                        },
	                        schema: {
	                            total: "totalGroupCount",
	                            data: "groups",
	                            model : Group
	                        },
	                        pageSize: 15,
	                        serverPaging: true,
	                        serverFiltering: false,
	                        serverSorting: false,                        
	                        error: handleKendoAjaxError
	                    },
	                    columns: [
	                        { field: "groupId", title: "ID", width:40,  filterable: false, sortable: false }, 
	                        { field: "name",    title: "KEY",  filterable: true, sortable: true,  width: 100 }, 
	                        { field: "displayName",    title: "이름",  filterable: true, sortable: true,  width: 100 }, 
	                        { field: "description", title: "설명", width: 200, filterable: false, sortable: false },
	                        { command:  [ {name:"edit",  text: { edit: "수정", update: "저장", cancel: "취소"}  }  ], title: "&nbsp;" }], 
	                    filterable: true,
	                    editable: "inline",
	                    selectable: 'row',
	                    height: '100%',
	                    batch: false,
	                    toolbar: [ { name: "create", text: "그룹추가" } ],                    
	                    pageable: { refresh:true, pageSizes:false,  messages: { display: ' {1} / {2}' }  },                    
	                    change: function(e) {	                       
	                        var selectedCells = this.select();	                       
	                        if( selectedCells.length == 1){
	                             var selectedCell = this.dataItem( selectedCells );	                             
	                             if( selectedCell.groupId > 0 && selectedCell.groupId != selectedGroup.groupId ){       
	                                 selectedGroup.groupId = selectedCell.groupId;
	                                 selectedGroup.name = selectedCell.name;
	                                 selectedGroup.displayName = selectedCell.displayName;
	                                 selectedGroup.description = selectedCell.description;
	                                 selectedGroup.modifiedDate = selectedCell.modifiedDate;
	                                 selectedGroup.creationDate = selectedCell.creationDate;
	                                 selectedGroup.formattedCreationDate  =  kendo.format("{0:yyyy.MM.dd}",  selectedCell.creationDate );      
	                                 selectedGroup.formattedModifiedDate =  kendo.format("{0:yyyy.MM.dd}",  selectedCell.modifiedDate );         	                                 
	                                 selectedGroup.company = selectedCompany;
	                                 	                                 
	                                 // SHOW GROUP DETAILS ======================================	                                 	                                 
	                                 $('#group-details').show().html(kendo.template($('#group-details-template').html()));	                                 
	                                 kendo.bind($(".details"), selectedGroup );
										
									// 2. GROUP TABS
									if( ! $('#group-prop-grid').data("kendoGrid") ){					                      			
										$('#group-prop-grid').kendoGrid({
													dataSource: {
														transport: { 
															read: { url:'${request.contextPath}/secure/get-group-property.do?output=json', type:'post' },
															create: { url:'${request.contextPath}/secure/update-group-property.do?output=json', type:'post' },
															update: { url:'${request.contextPath}/secure/update-group-property.do?output=json', type:'post'  },
															destroy: { url:'${request.contextPath}/secure/delete-group-property.do?output=json', type:'post' },
													 		parameterMap: function (options, operation){			
														 		if (operation !== "read" && options.models) {
														 			return { groupId: selectedGroup.groupId, items: kendo.stringify(options.models)};
																} 
																return { groupId: selectedGroup.groupId }
															}
														},						
														batch: true, 
														schema: {
															data: "targetGroupProperty",
															model: Property
														},
														error:handleKendoAjaxError
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
													height: 300,
													toolbar: [
														{ name: "create", text: "추가" },
														{ name: "save", text: "저장" },
														{ name: "cancel", text: "취소" }
													],				     
													change: function(e) {
													}
										});
									}		
									// Start of Tabs											
									$('#myTab a').click(function (e) {
										e.preventDefault(); 
										if( $(this).attr('href') == '#props' ){	
										}else if( $(this).attr('href') == '#members' ){	
											// start members
											if(!$('#company-group-grid').data('kendoGrid') ){
												$('#company-group-grid').kendoGrid({
													dataSource: {
														type: "json",
														transport: {
															read: { url:'${request.contextPath}/secure/list-group-user.do?output=json', type:'post' },			
															destroy: { url:'${request.contextPath}/secure/remove-group-members.do?output=json', type:'post' },
															parameterMap: function (options, operation){												                  
																if (operation !== "read" && options.models) {
																	return { groupId: selectedGroup.groupId, items: kendo.stringify(options.models)};
																} 
																return { groupId: selectedGroup.groupId,  startIndex: options.skip, pageSize: options.pageSize  }		
															}                        
														},
														schema: {
															total: "totalGroupUserCount",
															data: "groupUsers",
															model: User
														},
														error:handleKendoAjaxError,
														autoSync: true,
														batch: true,
														serverPaging: true,
														serverSorting: false,
														serverFiltering: false,
														pageSize:10
													},
													scrollable: true,				    
													sortable: true,
													height: 350,
													resizable: true,
													editable: {
														update: false,
														destroy: true,
														confirmation: "선택하신 사용자를 그룹에서 	삭제하겠습니까?"	
													},
													pageable: { refresh:true, pageSizes:false,  messages: { display: ' {1} / {2}' }  },
													toolbar: [
														{ name: "search", text: "멤버 검색", imageClass:"k-icon k-i-search" , className: "searchCustomClass" },
														{ name: "cancel", text: "취소"}
													],				      
													columns: [
									                    { field: "userId", title: "ID", width:50,  filterable: false, sortable: false}, 
									                    { field: "username", title: "아이디", width: 80 }, 
									                    { field: "name", title: "이름", width: 80 }, 
									                    { field: "email", title: "메일", width: 80  },
									                    { command:  { name: "destroy", text:"삭제" },  title: "&nbsp;", width: 100 }	
									                ],
									                dataBound:function(e){   
									                	var group_memeber_grid = this; //$('#group-member-grid').data('kendoGrid'); 
									                    selectedGroup.memberCount = group_memeber_grid.dataSource.total() ;
									                	kendo.bind($(".tabstrip"), selectedGroup );
									                	
													}                                                            
												});
												// End of tabs
												// start of member searching
												$('#company-group-grid').find(".searchCustomClass").click(function(){
													if( !$("#search-window").data("kendoWindow") ){		
														$("#search-window").kendoWindow({
															resizable : false,
															title:  selectedGroup.company.name + " 도메인 사용자 검색",
															modal: true,
															visible: false
										    			});
										    		}
										    		
										    		if(!$("#search-result").data('kendoGrid')) {
										    			$("#search-result").kendoGrid({
															dataSource: {
																type: "json",
																transport: {
																	read: { url:'${request.contextPath}/secure/find-user.do?output=json', type:'post' },
																	parameterMap: function (options, operation){							                
																		if (operation !== "read" && options.models) {
																 			return { nameOrEmail: search_text, items: kendo.stringify(options.models) , companyId: selectedGroup.company.companyId };
																		} 
													                    return { nameOrEmail:options.search_text,  startIndex: options.skip, pageSize: options.pageSize , companyId: selectedGroup.company.companyId };
																	}                        
																},
																schema: {
													                   total: "foundUserCount",
													                   data: "foundUsers",
													                   model: User
													           },
													           serverPaging: false,
													           serverSorting: false,
													           serverFiltering: false,
													           pageSize:10,
													           error: handleKendoAjaxError                             
													        },
													    	scrollable: true,
													       	sortable: true,
													       	height: 280,		       			      
													        columns: [
													           { field: "select", title: "&nbsp;", template: '<input type=\'checkbox\' />', sortable: false, width: 32},	
													           { field: "userId", title: "ID", width:25,  filterable: false, sortable: false }, 
													           { field: "username", title: "아이디", width: 100 }, 
													           { field: "name", title: "이름", width: 50 }, 
													           { field: "email", title: "메일", width: 100 },
													       	],
															autoBind: true,
															dataBound: function() {
			            										var grid = this;
			            										//handle checkbox change
			            										grid.table.find("tr").find("td:first input").change(function(e) {  
			            											var checkbox = $(this);
			            											var selected = grid.table.find("tr").find("td:first input:checked").closest("tr");
			            										}); 
			            									}                                                     
													    });										    		
										    		}
													$("#search-window").closest(".k-window").css({
														top: 70,
														left: 15,
													});	 
													$("#search-window").data("kendoWindow").open();								    	
													$("#search-text").focus();								    	
												});	        							
												// end of  member searching				
											}																			
										}else if( $(this).attr('href') == '#roles' ){	
										
											if( ! $('#group-role-select').data("kendoMultiSelect") ){					                      			
				                      			var selectedRoleDataSource = new kendo.data.DataSource({
													transport: {
										            	read: { 
										            		url:'${request.contextPath}/secure/get-group-roles.do?output=json', 
										            		dataType: "json", 
										            		type:'POST',
										            		data: { groupId: selectedGroup.groupId }
												        }  
												    },
												    schema: {
									                	data: "groupRoles",
									                    model: Role
									                },
									                error:handleKendoAjaxError,
									                change: function(e) {                
						                        		var multiSelect = $("#group-role-select").data("kendoMultiSelect");
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
												$('#group-role-select').kendoMultiSelect({
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
						                        		var multiSelect = $("#group-role-select").data("kendoMultiSelect");			                        		
						                        		var list = new Array();			                        		                  		
						                        		$.each(multiSelect.value(), function(index, row){  
						                        			var item =  multiSelect.dataSource.get(row);
						                        			list.push(item);			                        			
						                        		});						                        		
						                        		multiSelect.readonly();			                        		
							 							$.ajax({
												            dataType : "json",
															type : 'POST',
															url : "${request.contextPath}/secure/update-group-roles.do?output=json",
															data : { groupId:selectedGroup.groupId, items: kendo.stringify( list ) },
															success : function( response ){		
																// need refresh ..			
																// alert( kendo.stringify( response ) );							    
															},
															error:handleKendoAjaxError
														});												
														multiSelect.readonly(false);
						                        	}
									            });
											}											
										}
									});

																					
								}
							}else{
								selectedGroupId = 0 ;	                            
							}
						},					
						dataBound: function(e){   
						    var selectedCells = this.select();				
						    if(selectedCells.length == 0 )
						    {
						    	selectedGroup = new Group({});
						    	kendo.bind($(".details"), selectedGroup );		
								$("#group-details").hide(); 	 			    	
						    }   
						}					
	                });  	
	                
	                // 3-3 CLOSE SEARCH WINDOW
	                $("#close-search-window-btn").click( function() {	
	                	$("#search-window").data("kendoWindow").close();
	                	var user_search_grid = $('#search-result').data('kendoGrid') ;	        	                	        	
	                	$("#search-text").val("");
	                	if( user_search_grid.dataSource.total() > 0 ){	                		
	                		user_search_grid.dataSource.read({ search_text: "" });	
	                	}  
	                } );
	                
					// 4 SEARCHING  BUTTON             				
					$("#search-user-btn").click(function(){	
						var search_text = $("#search-text").val();
						var user_search_grid = $('#search-result').data('kendoGrid') ;
						user_search_grid.dataSource.read({ search_text: search_text });						
					});
											
					// 5. 	ADD MEMBERS BUTTON				
					$("#add-member-btn").click( function(){									    
					        var user_search_grid = $('#search-result').data('kendoGrid') ;			
					        var group_memeber_grid = $('#group-member-grid').data('kendoGrid');      
					        
					        var selected = user_search_grid.table.find("tr").find("td:first input:checked").closest("tr");
					        var selectedUsers = [];						        
					        $.each(  selected, function(index, row){        
					            var selectedItem = user_search_grid.dataItem(row);	
								var selectedUser = new User({
										userId: selectedItem.userId ,
									    username: selectedItem.username,
									    name: selectedItem.name, 
									    email: selectedItem.email
					            });	
					            selectedUsers.push( selectedUser )
					        } );	
					        
					        if( selectedUsers.length > 0 ){
								$.ajax({
						            dataType : "json",
									type : 'POST',
									url : "${request.contextPath}/secure/add-group-members.do?output=json",
									data : { groupId:selectedGroup.groupId, items: kendo.stringify( selectedUsers ) },
									success : function( response ){								    
										$.each(  selected, function(index, row){      
								        	user_search_grid.removeRow(row);
								        });	
										group_memeber_grid.dataSource.read();
									},
									error:handleKendoAjaxError
								});						        
					        }else{
					        	alert('선택된 사용자가 없습니다.');
					        }
	                });
	                
	                $("#update-role-btn").click(function(){	
	                
	                }); 
				//});
            }
        }]);        		
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
				<div class="col-12 col-lg-12">					
					<div class="page-header">
						<h1><span data-bind="text: title"></span>     <small><i class="fa fa-quote-left"></i>&nbsp;<span data-bind="text: description"></span>&nbsp;<i class="fa fa-quote-right"></i></small></h1>
					</div>			
				</div>		
			</div>
			<div class="row">		
				<div class="col-sm-12">
					<div class="panel panel-default" style="min-height:300px;" >
						<div class="panel-heading selected-company-info" style="padding:5px;">
							<div class="btn-group">
								<button type="button" class="btn btn-success btn-control-group" data-action="user"><i class="fa fa-user"></i>&nbsp;<span data-bind="text: displayName"></span>&nbsp;사용자관리</button>
								<button type="button" class="btn btn-default btn-control-group btn-columns-expend" data-action="layout"><i class="fa fa-columns"></i></button>
							</div>
						</div>
						<div class="panel-body" style="padding:5px;">
							<div class="row marginless paddingless">
								<div class="col-sm-12 body-group marginless paddingless"><div id="group-grid"></div></div>
								<div id="group-details" class="col-sm-12 body-group marginless paddingless" style="display:none; padding-top:5px;"></div>
							</div>
						</div>
					
					</div>				
				</div>			
			</div>				
		</div>		

		<div id="search-window" style="display:none;" class="clearfix gray">		
			<div class="container layout">					
				<div class="row">
					<div class="col-12 col-xs-12">
						<div class="alert alert-danger">
						검색 결과 목록에서 추가를 원하는 사용자을 선택 후 "멤버추가" 버튼을 클릭하여 멤버를 그룹에 추가합니다. 사용자 선택은 체크박스를 체크하면 됩니다.
						</div>
					</div>
				</div>
				<div class="row">
					<div class="col-8 col-xs-8"><input type="text" id="search-text"  class="form-control" placeholder="검색할 사용자 이름 또는 메일 주소"/></div>
					<div class="col-4 col-xs-4"><button class="btn btn-default" id="search-user-btn"><i class="fa fa-search"></i> 사용자 검색</button></div>
				</div>				
				<div class="row blank-top-5">
					<div class="col-12 col-xs-12">
						<div id="search-result"></div>
					</div>
				</div>
				<div class="row blank-top-5">
					<div class="col-10 col-xs-10">
						<div class="btn-group">
							<button class="btn btn-default" id="add-member-btn"><i class="fa fa-plus"></i>&nbsp;선택된 사용자 멤버로 추가하기</button>
						<!--<a class="btn btn-default" id="close-search-window-btn"><span class="k-icon k-i-close"></span>닫기</a>-->
						</div>
					</div>
				</div>				
			</div>
		</div>			
		<form name="fm1" method="POST" accept-charset="utf-8" class="details">
			<input type="hidden" name="companyId" value="0" />
		</form>		
		<!-- END MAIN CONTNET -->
		<div id="account-panel"></div>			
		<script type="text/x-kendo-template" id="group-details-template">					
			<div class="panel panel-primary marginless details" >
				<div class="panel-heading" >
					<span data-bind="text: displayName"></span>
					<button type="button" class="close" aria-hidden="true">&times;</button></div>
					<div class="panel-body" style="padding:5px;">
					<ul id="myTab" class="nav nav-tabs">
						<li class="active"><a href="\\#props" data-toggle="tab">프로퍼티</a></li>
						<li><a href="\\#members" data-toggle="tab">멤버</a></li>
						<li><a href="\\#roles" data-toggle="tab">롤</a></li>
					</ul>			
					<div class="tab-content">
						<div class="tab-pane active" id="props">
							<div class="blank-top-5"></div>
							<div class="alert alert-danger margin-buttom-5">
								<button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
								프로퍼티는 수정 후 저장 버튼을 클릭하여야 최종 반영됩니다.
							</div>						
							<div id="group-prop-grid" class="props"></div>
						</div>
						<div class="tab-pane" id="members">
							<div class="blank-top-5" ></div>	
							<div class="alert alert-danger margin-buttom-5">
								<button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
								그룹관리는  그룹관리를 사용하여 관리 하실수 있습니다.	     
							</div>						
							<div id="company-group-grid"  class="members"></div>					
						</div>
						<div class="tab-pane" id="roles">
							<div class="blank-top-5" ></div>	
							<div class="alert alert-danger margin-buttom-5">
								<button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
								그룹에서 부여된 롤은 멤버들에게 상속됩니다. 아래의 선택 박스에서 롤을 선택하여 주세요.
							</div>							
							<div id="group-role-select"></div>
						</div>
					</div>
				</div>
			</div>		
		<!--
				<div class="tabstrip">
					<ul>
						<li>프로퍼티</li>
						<li class="k-state-active">멤버</li>
						<li>롤</li>
					</ul>
					<div>
						<div id="group-prop-grid" class="props"></div>
						<div class="blank-top-15"></div>
						<div class="alert alert-danger">
							<button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
							프로퍼티는 저장 버튼을 클릭하여야 최종 반영됩니다.
						</div>	
					</div> 	
					<div>
						<div id="group-member-grid"  class="members"></div>
						<div class="blank-top-15"></div>
						<div class="alert alert-info">멤버수:<span data-bind="text:memberCount">0</span> 명</div>
					</div>
					<div>
						<div class="blank-top-15"></div>
						<div class="alert alert-info">그룹에서 부여된 롤은 멤버들에게 상속됩니다. 아래의 선택 박스에서 롤을 선택하여 주세요.</div>	
						<div class="roles big-box">
							
						</div>	
					</div>
				</div>
		-->		
		</script>		        
		<!-- 공용 템플릿 -->
		<#include "/html/common/common-system-templates.ftl" >					
	<!-- END MAIN CONTENT  -->	  
    </body>
</html>