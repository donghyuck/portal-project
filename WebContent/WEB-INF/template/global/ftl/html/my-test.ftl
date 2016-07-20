<#ftl encoding="UTF-8"/>
<html decorator="unify">
<head>
		<#assign page = action.getPage() >
		<title><>${page.title}</title>
		<#compress>		
		<script type="text/javascript">
		var jobs = [];					
		yepnope([{
			load: [
			'css!<@spring.url "/styles/font-awesome/4.3.0/font-awesome.min.css"/>',
			'css!<@spring.url "/styles/bootstrap.themes/unify/1.9.1/headers/header-default.css"/>',		
			'css!<@spring.url "/styles/bootstrap.themes/unify/1.9.1/theme-colors/dark-red.css"/>',	
			'css!<@spring.url "/styles/bootstrap.themes/unify/1.9.1/theme-skins/dark.css"/>',
			'css!<@spring.url "/styles/bootstrap.themes/common/common.ui.inspinia.css"/>',
			'css!<@spring.url "/styles/bootstrap.themes/common/common.ui.buttons.css"/>',

			
			'<@spring.url "/js/jquery/1.10.2/jquery.min.js"/>',
			'<@spring.url "/js/jgrowl/jquery.jgrowl.min.js"/>',
			'<@spring.url "/js/kendo/kendo.web.min.js"/>',
			'<@spring.url "/js/kendo.extension/kendo.ko_KR.js"/>',			
			'<@spring.url "/js/kendo/cultures/kendo.culture.ko-KR.min.js"/>',	
			'<@spring.url "/js/bootstrap/3.3.5/bootstrap.min.js"/>',
			
			'<@spring.url "/js/common/common.ui.core.js"/>',							
			'<@spring.url "/js/common/common.ui.data.js"/>'
					
			],			
			complete: function() {		
								
				common.ui.setup({
					features:{
						wallpaper : false,
						accounts : {
							authenticate : function(e){
								e.token.copy(currentUser);
								console.log( common.ui.stringify(currentUser ));
								
							} 
						}						
					},
					wallpaper : {
						renderTo:$(".breadcrumbs-v3")
					},	
					jobs:jobs
				});	
				var currentUser = new common.ui.data.User();
				console.log( common.ui.stringify(currentUser));
				
				
				common.ui.ajax(
							'<@spring.url "/data/podo/hello.json?output=json" />' , 
							{
								contentType : "application/json",
								success : function(response){
									common.ui.notification().show({ title:null, message: response.text	},"success");
								},
								fail: function(){								
									common.ui.notification().show({	title:null, message: "웹 페이지 저장중 오류가 발생되었습니다. 시스템 운영자에게 문의하여 주십시오."	},"warning");	
								},
								requestStart : function(){
									kendo.ui.progress($('body'), true);
								},
								requestEnd : function(){
									kendo.ui.progress($('body'), false);
								},
								complete : function(e){
									
								}
							}
						);	
				
				
 					var grid = $("#grid").kendoGrid({
                        dataSource: {
                            type: "POST",
                            transport: {
                                read: {
                                	url: "<@spring.url "/data/podo/list/find.json?output=json" />",
                                	type:'POST', 
                                	contentType : 'application/json'
                                },
                                update: {
                                	url: "<@spring.url "/data/podo/list/update.json?output=json" />",
                                	type:'POST', 
                                	contentType : 'application/json'
                                },  
                                create: {
                                	url: "<@spring.url "/data/podo/list/create.json?output=json" />",
                                	type: 'POST',
                                	contentType: 'application/json'                             		
                                },
                                parameterMap: function (options, type){								
									return common.ui.stringify( options );
								}
                            },
                            schema: {
                                model: {
                                    id:'id',
                                    fields: {
                                        id: { type: "number", editable:false, defaultValue:0 },
                                        name: { type: "string" },
                                        phone: { type: "string" },
                                        position: { type: "string" },
                                        gender: { type: "string" }
                                    }
                                },
                                data: "items",
                                total: "totalCount"
                            },
                            serverPaging:true,
                            serverFiltering: true,
                            pageSize: 8
                        },
                        autoBind:true,
                        height: 309,
                        filterable: true,
                        sortable: true,
                        pageable: {
                       		pageSize: 8,
    						refresh: true
                        },
                        toolbar: ["create"],
                        columns:[
                        	{ title: "MemberID", field: "id" },
                        	{ title: "Name", field: "name" },
                        	{ title: "Phone", field: "phone" },
                        	{ title: "Position", field: "position" },
                        	{ title: "Gender", field: "gender" },
                        	{ title: "Edit", command: [{ name: "edit", text: "변경" }] }
                        ],
                        editable: "popup",
                        dataBound: function(e) {
						var $this = this;
						if( $("#memberlist.search-block-v2 input").val().length > 0 ){
							common.ui.notification().show({ title:null, message:  $this.dataSource.total() + "건이 조회되었습니다."	},"success");	
						}
					}	
                    });
                    
			
				//	$("#grid").data('kendoGrid').dataSource.read();
					
				/*
					$("#memberlist.search-block-v2 input").change(function(e){
					var $this = $(this);					
					console.log($this.val());	
					if( $this.val().langth == 0 ){
						$("#grid").data('kendoGrid').dataSource.filter([]);
					}else{
						$("#grid").data('kendoGrid').dataSource.filter({ field: "name", operator: "contains", value: $this.val() }) ; 
					}
				});
				*/
				   
				$("#btn_search").click(function() {
					var search = $("#memberlist.search-block-v2 input").val();
					//alert(search);
					
					$("#grid").data('kendoGrid').dataSource.read({search : search});
				
				});   
				   	
			}
		}]);		
		
		</script>
		
		</#compress>
	</head>
	<body id="doc" class="bg-white">
		<!--<div class="page-loader"></div>-->
		<div class="wrapper">
			<!-- START HEADER -->		
			<#include "/html/common/common-homepage-menu.ftl" >		
			<!-- ./END HEADER -->
			<!-- START MAIN CONTENT -->
			<#if action.isSetNavigator()  >
			<#assign navigator = action.getNavigator() />		
			<div class="breadcrumbs-v3 img-v1  bg-dark arrow-up">
				<div class="personalized-controls container text-center p-xl">
					<p class="text-quote">${ navigator.description ? replace ("{displayName}" , action.webSite.company.displayName ) }	</p>
					<h1 class="text-xxl"><#if navigator.icon?? ><i class="icon-flat ${navigator.icon}"></i></#if>	${ navigator.title }</h1>					
				</div><!--/end container-->
			</div>
			</#if>	
			<div class="container content" style="min-height:450px;">	
			<h3>PODO MEMBER LIST</h3>
			<div id="memberlist" class="search-block-v2">
				<div class="container">
					<div class="col-md-3 col-md-offset-9">
						<div class="input-group input-group-sm">
							<input type="text" class="form-control" placeholder="찾는 회원의 이름을 입력하세요."/>
							<span class="input-group-btn"><button type="button" id="btn_search" class="btn btn-sm"><i class="fa fa-search"></i></button></span>
						</div>
					</div>
				</div>
			</div>
			<div id="example">
				<div id="grid"></div>
            </div>
       	</div>
	</div><!-- /.container -->								
	<!-- ./END MAIN CONTENT -->				
	<!-- START FOOTER -->
	<#include "/html/common/common-homepage-globalfooter.ftl" >
<!-- ./END FOOTER -->				
</div>									
<!-- START TEMPLATE -->			
   
	<#include "/html/common/common-homepage-templates.ftl" >
	<!-- ./END TEMPLATE -->
	</body>    
</html>fade