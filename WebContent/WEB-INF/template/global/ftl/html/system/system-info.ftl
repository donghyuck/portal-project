<#ftl encoding="UTF-8"/>
<html decorator="secure">
<head>
		<title>관리자 메인</title>		
		<link  rel="stylesheet" type="text/css"  href="${request.contextPath}/styles/common.admin/pixel/pixel.admin.style.css" />
		<script type="text/javascript">
		<!--		
		yepnope([{
			load: [
			'css!${request.contextPath}/styles/font-awesome/4.1.0/font-awesome.min.css',
			'css!${request.contextPath}/styles/common.plugins/animate.css',
			'css!${request.contextPath}/styles/common.admin/pixel/pixel.admin.widgets.css',			
			'css!${request.contextPath}/styles/common.admin/pixel/pixel.admin.rtl.css',
			'css!${request.contextPath}/styles/common.admin/pixel/pixel.admin.themes.css',
			'css!${request.contextPath}/styles/common.admin/pixel/pixel.admin.pages.css',	
			
			'${request.contextPath}/js/jquery/1.10.2/jquery.min.js',
			'${request.contextPath}/js/kendo/kendo.web.min.js',
			'${request.contextPath}/js/kendo/kendo.dataviz.min.js',
			'${request.contextPath}/js/kendo.extension/kendo.ko_KR.js',
			'${request.contextPath}/js/kendo/cultures/kendo.culture.ko-KR.min.js',
			'${request.contextPath}/js/jgrowl/jquery.jgrowl.min.js',			
			'${request.contextPath}/js/bootstrap/3.0.3/bootstrap.min.js',			
			'${request.contextPath}/js/common.plugins/fastclick.js', 
			'${request.contextPath}/js/common.plugins/jquery.slimscroll.min.js', 
			'${request.contextPath}/js/common.admin/pixel.admin.min.js',
			
			'${request.contextPath}/js/common/common.models.js',       	    
			'${request.contextPath}/js/common/common.api.js',
			'${request.contextPath}/js/common/common.ui.js',
			'${request.contextPath}/js/common/common.ui.admin.js'
			],
			complete: function() {
				// 1-1.  한글 지원을 위한 로케일 설정
				common.api.culture();
				// 1-2.  페이지 렌딩
				common.ui.landing();				
				// 1-3.  관리자  로딩
				var currentUser = new User();
				var targetCompany = new Company();	
				common.ui.admin.setup({
					authenticate : function(e){
						e.token.copy(currentUser);
					},
					companyChanged: function(item){
						item.copy(targetCompany);
					}
				});		
				
				
				var dataSource = new kendo.data.DataSource({
					transport: {
						read: {
							url: '${request.contextPath}/secure/view-system-memory.do?output=json', // the remove service url
							type:'POST',
							dataType : 'json'
						}
					},
					error:handleKendoAjaxError,
					schema: { 
						data: function(response){
							return [ response ] ; 
						}
                    },
					change: function( e 	) { // subscribe to the CHANGE event of the data source
						var data = this.data()[0];						
						kendo.bind($(".memory-details"), data.memoryInfo );						
						if( ! $("#mem-gen-gauge").data("kendoRadialGauge") ){
							$("#mem-gen-gauge").kendoRadialGauge({
								theme: "white",
								pointer: {
									value: data.memoryInfo.usedHeap.megabytes,
									color: "#ea7001"									
								},
								scale: {
									majorUnit: 100,
									minorUnit: 10,
									startAngle: -30,
                            		endAngle: 210,
									max: data.memoryInfo.maxHeap.megabytes,
									ranges: [
										{
		                                    from:  ( data.memoryInfo.maxHeap.megabytes -  ( ( data.memoryInfo.maxHeap.megabytes / 10 ) * 2 ) ) ,
		                                    to:  ( data.memoryInfo.maxHeap.megabytes -  data.memoryInfo.maxHeap.megabytes / 10 ) ,
		                                    color: "#ff7a00"
		                                }, {
		                                    from: ( data.memoryInfo.maxHeap.megabytes -  data.memoryInfo.maxHeap.megabytes / 10 ) ,
		                                    to: data.memoryInfo.maxHeap.megabytes,
		                                    color: "#c20000"
		                                }
	                            	]			
								}
							});						
						}else{
							$("#mem-gen-gauge").data("kendoRadialGauge").value( data.memoryInfo.usedHeap.megabytes );
						}	
											
						if( ! $("#perm-gen-gauge").data("kendoRadialGauge") ){	
							$("#perm-gen-gauge").kendoRadialGauge({
								theme: "white",
								pointer: {
									value: data.memoryInfo.usedPermGen.megabytes,
									color: "#ea7001"		
								},
								scale: {
									majorUnit: 50,
									minorUnit: 10,
									startAngle: -30,
                            		endAngle: 210,
									max: data.memoryInfo.maxPermGen.megabytes,
									ranges: [
										{
		                                    from:  ( data.memoryInfo.maxPermGen.megabytes -  ( ( data.memoryInfo.maxPermGen.megabytes / 10 ) * 2 ) ) ,
		                                    to:  ( data.memoryInfo.maxPermGen.megabytes -  data.memoryInfo.maxPermGen.megabytes / 10 ) ,
		                                    color: "#ff7a00"
		                                }, {
		                                    from: ( data.memoryInfo.maxPermGen.megabytes -  data.memoryInfo.maxPermGen.megabytes / 10 ) ,
		                                    to: data.memoryInfo.maxPermGen.megabytes,
		                                    color: "#c20000"
		                                }
	                            	]								
								}
							});		
						}else{
							$("#perm-gen-gauge").data("kendoRadialGauge").value( data.memoryInfo.usedPermGen.megabytes );
						}	
					}
				});
				
				dataSource.read();		
								
				var timer = setInterval(function () {
					dataSource.read();
					//clearInterval(timer);
					}, 6000);		
									
				$.ajax({
					type : 'POST',
					url : '${request.contextPath}/secure/view-system-details.do?output=json',
					success : function( response ){
						var data = response ;	
						kendo.bind($(".system-details"), data.systemInfo );			
						kendo.bind($(".license-details"), data.licenseInfo );					
					},
					error:handleKendoAjaxError,
					dataType : "json"
				});	

				$('#myTab a').click(function (e) {
					e.preventDefault();
					if(  $(this).attr('href') == '#setup-info' ){
						if(!$("#setup-props-grid").data("kendoGrid")){
							$('#setup-props-grid').kendoGrid({
								     dataSource: {
										transport: { 
											read: { url:'${request.contextPath}/secure/view-system-setup-props.do?output=json', type:'post' }									
										 },
										 schema: {
					                            data: "setupApplicationProperties",
					                            model: Property
					                     },
					                     error:handleKendoAjaxError
								     },
								     columns: [
								         { title: "속성", field: "name", locked: true, width:400 },
								         { title: "값",   field: "value",  width:500 }
								     ],
									pageable: false,
									resizable: true,
									editable : false,
									scrollable: true,
									height: 300,
									change: function(e) {}
							});			
							//$("#setup-props-grid").attr('style','');	    				
						}
					}else if(  $(this).attr('href') == '#database-info' ){
						if(! $("#database-info-grid").data("kendoGrid")){
								$('#database-info-grid').kendoGrid({
									dataSource: {
										transport: { 
											read: { url:'${request.contextPath}/secure/view-system-databases.do?output=json', type:'post' }
										},						
										batch: false, 
										schema: {
										data: "databaseInfos",
											model: DatabaseInfo
										},
										error:handleKendoAjaxError
									},
									columns: [
										{ title: "데이터베이스", field: "databaseVersion"},
										{ title: "JDBC 드라이버", field: "driverName + ' ' + driverVersion" },
										{ title: "ISOLATION", field: "isolationLevel", width:90 },
									],
									pageable: false,
									resizable: true,
									editable : false,
									scrollable: true,
									height: 200,
									change: function(e) {
									}
								});									
						}					
					}
					$(this).tab('show');
					
					$('#system-info .panel-body').perfectScrollbar();
					
				});													
									
				// END SCRIPT
			}
		}]);
		-->
		</script> 		 
		<style>
		
		</style>
	</head>
	<body class="theme-default main-menu-animated">
		<div id="main-wrapper">
			<#include "/html/common/common-system-navigation.ftl" >	
			<div id="content-wrapper">
				<ul class="breadcrumb breadcrumb-page">
					<#assign selectedMenu = WebSiteUtils.getMenuComponent("SYSTEM_MENU", "MENU_1_5") />
					<li><a href="#">Home</a></li>
					<li><a href="${ selectedMenu.parent.page!"#" }">${selectedMenu.parent.title}</a></li>
					<li class="active"><a href="#">${selectedMenu.title}</a></li>
				</ul>			
				<div class="page-header bg-dark-gray">					
					<h1><#if selectedMenu.isSetIcon() ><i class="fa ${selectedMenu.icon} page-header-icon"></i></#if> ${selectedMenu.title}  <small><i class="fa fa-quote-left"></i> ${selectedMenu.description!""} <i class="fa fa-quote-right"></i></small></h1>
				</div><!-- / .page-header -->				
				<div class="row">				
					<div class="col-xs-3">
						<div class="stat-panel text-center">
							<div class="stat-row">						
								<div class="stat-cell bg-dark-gray padding-sm text-xs text-semibold">
									<i class="fa fa-tachometer"></i> Heap 메모리
								</div>
							</div><!-- /.stat-row -->
							<div class="stat-row">								
								<div class="stat-cell bordered no-border-t no-padding-hr" style="padding: 0 0 0 0;">								
									<div id="mem-gen-gauge" style="display: inline-block !important;"></div>									
								</div>							
							</div> <!-- /.stat-row -->						
							<div class="stat-row memory-details">
								<div class="stat-counters bg-primary bordered no-border-t text-center">
									<div class="stat-cell col-xs-6 padding-sm no-padding-hr">
										<!-- Big text -->
										<span class="text-bg"><strong><span data-bind="text: maxHeap.megabytes"></span>MB</strong></span><br>
										<!-- Extra small text -->
										<span class="text-xs">Total Memory</span>
									</div>
									<div class="stat-cell col-xs-6 padding-sm no-padding-hr">
										<!-- Big text -->
										<span class="text-bg"><strong><span data-bind="text: usedHeap.megabytes"></span>MB</strong></span><br>
										<!-- Extra small text -->
										<span class="text-xs">Used Memory</span>
									</div>
								</div> <!-- /.stat-counters -->
							</div>						
						</div> <!-- /.stat-panel -->
					</div>					
					<div class="col-xs-3">
						<div class="stat-panel text-center">
							<div class="stat-row">
								<!-- Dark gray background, small padding, extra small text, semibold text -->
								<div class="stat-cell bg-dark-gray padding-sm text-xs text-semibold">
									<i class="fa fa-tachometer"></i> PermGen 메모리
								</div>
							</div> <!-- /.stat-row -->
							<div class="stat-row">
								<!-- Bordered, without top border, without horizontal padding -->
								<div class="stat-cell bordered no-border-t no-padding-hr" style="padding: 0 0 0 0;">	
									<div id="perm-gen-gauge" style="display: inline-block !important;"></div>
								</div>							
							</div> <!-- /.stat-row -->
							<div class="stat-row memory-details">
								<div class="stat-counters bg-warning bordered no-border-t text-center">
									<div class="stat-cell col-xs-6 padding-sm no-padding-hr">
										<!-- Big text -->
										<span class="text-bg"><strong><span data-bind="text: maxPermGen.megabytes"></span>MB</strong></span><br>
										<!-- Extra small text -->
										<span class="text-xs">Total Memory</span>
									</div>
									<div class="stat-cell col-xs-6 padding-sm no-padding-hr">
										<!-- Big text -->
										<span class="text-bg"><strong><span data-bind="text: usedPermGen.megabytes"></span>MB</strong></span><br>
										<!-- Extra small text -->
										<span class="text-xs">Used Memory</span>
									</div>
								</div> <!-- /.stat-counters -->
							</div>													
						</div> <!-- /.stat-panel -->
					</div>									
				</div><!-- memory status end -->
				<div class="row">			
					<a href="#" class="header-2">시스템 정보</a>
					<div class="col-lg-12">	
						<div class="panel colourable">
							<div class="panel-heading">
								<span class="panel-title"><i class="fa fa-info"></i></span>
								<ul class="nav nav-tabs nav-tabs-xs" id="myTab">
									<li class="active">
										<a href="#license-info" data-toggle="tab">라이센스 정보</a>
									</li>
									<li>
										<a href="#setup-info" data-toggle="tab">셋업 프로퍼티 정보</a>
									</li>
									<li>
										<a href="#system-info" data-toggle="tab">시스템 환경 정보</a>
									</li>
									<li>
										<a href="#database-info" data-toggle="tab">데이터베이스 정보</a>
									</li>							
								</ul> <!-- / .nav -->
							</div> <!-- / .panel-heading -->					
							<div class="tab-content">
								<div class="tab-pane active" id="license-info">

													<table class="table table-hover license-details">
														<tbody>
															<tr>
																<th>발급 ID</th>
																<td><span data-bind="text: licenseId"></span></td>
															</tr>								
															<tr>
																<th>제품</th>
																<td><span data-bind="text: name"></span></td>
															</tr>			
															<tr>
																<th>버전</th>
																<td><span data-bind="text: version.versionString"></span></td>
															</tr>				
															<tr>
																<th>에디션</th>
																<td><span class="label label-info"><span data-bind="text: edition"></span></span></td>
															</tr>																
															<tr>
																<th>타입</th>
																<td><span class="label label-danger"><span data-bind="text: type"></span></span></td>
															</tr>																	
															<tr>
																<th>발급일</th>
																<td><span data-bind="text: creationDate"></span></td>
															</tr>	
															<tr>
																<th>발급대상</th>
																<td><span data-bind="text: client.company"></span>(<span data-bind="text: client.name"></span>)</td>
															</tr>	
													 	</tbody>
													</table>
		
								</div>
								<div class="tab-pane" id="setup-info">
									<div class="panel-body no-padding">
										<div id="setup-props-grid" class="no-border" ></div>
									</div>		
								</div>
								<div class="tab-pane" id="system-info">
												<table class="table table-hover system-details">
													<tbody>
														<tr>
															<th>운영시스템</th>
															<td><span data-bind="text: operatingSystem"></span></td>
														</tr>
														<tr>
															<th>시스템 언어</th>
															<td><span data-bind="text: systemLanguage"></span></td>
														</tr>						
														<tr>
															<th>표준 시간대</th>
															<td><span data-bind="text: systemTimezone"></span></td>
														</tr>																			
														<tr>
															<th>시스템 날짜</th>
															<td><span data-bind="text: date"></span></td>
														</tr>
														<tr>
															<th>시스템 시간</th>
															<td><span data-bind="text: time"></span></td>
														</tr>							
														<tr>
															<th>임시 디렉터리</th>
															<td><span data-bind="text: tempDirectory"></span></td>
														</tr>									
														<tr>
															<th>파일 시스템 인코딩</th>
															<td><span data-bind="text: fileSystemEncoding"></span></td>
														</tr>
														<tr>
															<th>작업 디렉터리</th>
															<td><span data-bind="text: workingDirectory"></span></td>
														</tr>										
														<tr>
															<th>자바 실행환경</th>
															<td><span data-bind="text: javaRuntime"></span></td>
														</tr>			
														<tr>
															<th width="150">자바 벤더</th>
															<td><span data-bind="text: javaVendor"></span></td>
														</tr>		
														<tr>
															<th>자바 버전</th>
															<td><span data-bind="text: javaVersion"></span></td>
														</tr>			
														<tr>
															<th>가상머신</th>
															<td><span data-bind="text: javaVm"></span></td>
														</tr>	
														<tr>
															<th>가상머신 벤더</th>
															<td><span data-bind="text: jvmVendor"></span></td>
														</tr>
														<tr>
															<th>가상머신 버전</th>
															<td><span data-bind="text: jvmVersion"></span></td>
														</tr>																				
														<tr>
															<th>가상머신 구현 버전</th>
															<td><span data-bind="text: jvmImplementationVersion"></span></td>
														</tr>											
														<tr>
															<th>가상머신 옵션</th>
															<td><span data-bind="text: jvmInputArguments"></span></td>
														</tr>											
													</tbody>
												</table>	

								</div>
								<div class="tab-pane" id="database-info">
									<div class="panel-body no-padding">
										<div id="database-info-grid" class="no-border"></div>
									</div>
								</div>		
							</div><!-- tab contents end -->
						</div>
					</div>
				</div>	
			</div> <!-- / #content-wrapper -->
			<div id="main-menu-bg">
			</div>
		</div> <!-- / #main-wrapper -->
		<#include "/html/common/common-system-templates.ftl" >			
	</body>    
</html>