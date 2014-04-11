<#ftl encoding="UTF-8"/>
<html decorator="secure">
    <head>
        <title>시스템 정보</title>
<#compress>        
        <script type="text/javascript">                
        
        yepnope([{
            load: [ 
            'css!${request.contextPath}/styles/font-awesome/4.0.3/font-awesome.min.css',
			'${request.contextPath}/js/jquery/1.10.2/jquery.min.js',
			'${request.contextPath}/js/jgrowl/jquery.jgrowl.min.js',					
       	    '${request.contextPath}/js/kendo/kendo.web.min.js',
       	    '${request.contextPath}/js/kendo/kendo.dataviz.min.js',
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
				var selectedCompany = new Company();		
				
				var accounts = $("#account-panel").kendoAccounts({
					visible : false,
					authenticate : function( e ){
						currentUser = e.token;						
					}
				});
					
								
				// 3.MENU LOAD
				var currentPageName = "MENU_1_5";
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
		
				// 4. PAGE MAIN		
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
								         { title: "속성", field: "name" },
								         { title: "값",   field: "value" }
								     ],
									pageable: false,
									resizable: true,
									editable : false,
									scrollable: true,
									height: 200,	     
									change: function(e) {}
							});			
							$("#setup-props-grid").attr('style','');	    				
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
				});
			}	
		}]);
		</script>
		<style>						
		</style>
</#compress>		
	</head>
	<body>
		<!-- START HEADER -->
		<section id="navbar"></section>
		<!-- END HEADER -->
		<!-- START MAIN CONTNET -->
		<div class="container-fluid">		
			<!-- page header start -->
			<div class="row">			
				<div class="page-header">
					<h1><span data-bind="text: title"></span>     <small><i class="fa fa-quote-left"></i>&nbsp;<span data-bind="text: description"></span>&nbsp;<i class="fa fa-quote-right"></i></small></h1>
				</div>			
			</div><!-- page header end -->	
			<!-- memory status start -->
			<div class="row">	
				<div class="col-sm-3">
					<div class="panel panel-primary">
						<div class="panel-heading">Heap 메모리</div>
						<div class="panel-body">
							<div id="mem-gen-gauge"></div>
						</div>						
						<div class="panel-footer">
							<table class="table table-striped memory-details">
							 	<thead>
							 		<tr>
            							<th>Total Memory</th>
            							<th>Used Memory</th>
            						</tr>	
							 	</thead>
							 	<tbody>
							 		<tr>
										<td><span data-bind="text: maxHeap.megabytes"></span>MB</td>
										<td><span data-bind="text: usedHeap.megabytes"></span>MB</td>
							 		</tr>
							 	</tbody>
							</table>
						</div>
					</div>
				</div>
				<div class="col-sm-3">
					<div class="panel panel-primary">
						<div class="panel-heading">PermGen 메모리</div>
						<div class="panel-body">
							<div id="perm-gen-gauge"></div>						
						</div>
						<div class="panel-footer">
							<table class="table table-striped memory-details">
							 	<thead>
							 		<tr>
            							<th>Total Memory</th>
            							<th>Used Memory</th>
            						</tr>	
							 	</thead>
							 	<tbody>
							 		<tr>
										<td><span data-bind="text: maxPermGen.megabytes"></span>MB</td>	
										<td><span data-bind="text: usedPermGen.megabytes"></span>MB</td>
							 		</tr>
							 	</tbody>
							</table>
						</div>
					</div>
				</div>				
			</div><!-- memory status end -->
			<!-- system info start -->
			<div class="row">			
				<div class="col-lg-12">				
					<ul class="nav nav-tabs" id="myTab" style="min-width:700px;">
						<li class="active"><a href="#license-info"><i class="fa fa-certificate"></i> 라이센스 정보</a></li>
						<li><a href="#setup-info"><i class="fa fa-cog"></i> 셋업 프로퍼티 정보</a></li>
						<li><a href="#system-info"><i class="fa fa-info"></i> 시스템 환경 정보</a></li>
						<li><a href="#database-info"><i class="fa fa-hdd-o"></i> 데이터베이스 정보</a></li>
					</ul>
					<!-- tab contents start -->
					<div class="tab-content">
						<div class="tab-pane active" id="license-info">
									<div class="big-box">
										<div class="panel">
											<table class="table table-striped .table-hover license-details">
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
									</div>
						</div>
						<div class="tab-pane" id="setup-info">
									<div class="big-box">
										<div class="panel">
											<div id="setup-props-grid" ></div>
										</div>
									</div>		
						</div>
						<div class="tab-pane" id="system-info">
									<div class="big-box">
										<div class="panel">
										<table class="table table-striped .table-hover system-details">
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
									</div>	
						</div>
						<div class="tab-pane" id="database-info">
									<div class="big-box">
										<div class="panel">
										<div id="database-info-grid" ></div>
										</div>
									</div>
								</div>
						</div>		
					</div><!-- tab contents end -->
				</div>					
			</div><!-- system info start -->
		</div>				
		<div id="account-panel"></div>		
		<!-- END MAIN CONTNET -->
		<!-- START FOOTER -->
		<footer>  		
		</footer>
		<!-- END FOOTER -->
		<#include "/html/common/common-system-templates.ftl" >			
	</body>
</html>