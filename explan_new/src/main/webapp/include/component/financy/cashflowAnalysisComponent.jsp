<%@ page contentType='text/html;charset=utf-8'%>

<%-- Component Id 설정 --%>
<c:set var="comId" value="cashflowAnalysisComponent"/>

<script type="text/javascript">

	_SVC_COM.loadJsFile("/explan/js/class/C_CASHFLOW.js"				);
	_SVC_COM.loadJsFile("/explan/js/class/C_INSURANCE_GROUP.js"			);
	_SVC_COM.loadJsFile("/explan/amcharts/amcharts.js" 					);
	_SVC_COM.loadJsFile("/explan/amcharts/pie.js" 						);
	_SVC_COM.loadJsFile("/explan/amcharts/themes/light.js" 				);

	$(function() {
	});
	
	_G_FN["${comId}"] = {
		/* 콜백함수 필수 등록 */
		 callback 		: undefined
		,title			: "현금흐름표"
		/* Parameter */
		,init 		: function(sendParm, callback) {
			/* 필수 지정 */
			this.sendParm 		= sendParm;
			this.callback 		= callback;
			
			this.loadCashflow(sendParm);
		}
		// 화면 Load
		,loadCashflow : function(sendParm) {
			
			// Cash Flow Class를 생성한다.
			var cCashflow = new C_CASHFLOW({planNum : sendParm.planNum});

			var renderHtml 			= $("#${comId}Income_template").render(cCashflow);
			$("#${comId}Income").html(renderHtml);
			
			var renderHtml 			= $("#${comId}Consume_template").render(cCashflow);
			$("#${comId}Consume").html(renderHtml);
			
			var renderHtml 			= $("#${comId}Total_template").render(cCashflow);
			$("#${comId}Total").html(renderHtml);
			
			mergeTableTD("${comId}Consume", {startIdx:4});	
			mergeTableTD("${comId}Consume", {startIdx:1});	
			
			this.loadChartAnalysis(cCashflow);
			this.loadChartAnalysis2(cCashflow);
		}
		// Display Pie Chart
		,loadChartAnalysis : function(cCashflow) {
			var chartData = [];
			$.each(cCashflow.consumeGubunList, function() {
				chartData.push(fn_copyObject(this));
			});
			chartData[2].title = "월평균연지출";

			var chartConfig = {
			    "type": "pie",
			    "theme": "light",
			    "innerRadius": "30%",
			    "gradientRatio": [-0.4, -0.4, -0.4, -0.4, -0.4, -0.4, 0, 0.1, 0.2, 0.1, 0, -0.2, -0.5],
			    "legend":{
			       	"position":"absolute",
			        "top":160,
			        "left":20,
			        "maxColumns":1,
			        "autoMargins":false,
			        "valueText":"[[total]]만원",
			        "valueWidth":70
			    },			    
			    "dataProvider": chartData,
			    "valueField": "total",
			    "titleField": "title",
			    "percentPrecision" : 1,
			    "pieY"		: 80,
			    "radius" 	: 50,
			    "labelRadius" : 5 
			}	
			var chart = AmCharts.makeChart( "${comId}_chartdiv", chartConfig);
		}
		,loadChartAnalysis2 : function(cCashflow) {
			var chartData = mapToArray(cCashflow.consumeTypeMap, "title", "total");
			var chartConfig = {
			    "type": "pie",
			    "theme": "light",
			    "innerRadius": "30%",
			    "gradientRatio": [-0.4, -0.4, -0.4, -0.4, -0.4, -0.4, 0, 0.1, 0.2, 0.1, 0, -0.2, -0.5],
			    "legend":{
			       	"position":"absolute",
			        "top":160,
			        "left":20,
			        "maxColumns":1,
			        "autoMargins":false,
			        "valueText":"[[total]]만원",
			        "valueWidth":70
			    },			    
			    "dataProvider": chartData,
			    "valueField": "total",
			    "titleField": "title",
			    "percentPrecision" : 1,
			    "pieY"		: 80,
			    "radius" 	: 50,
			    "startAngle": 60,
			    "labelRadius" : 5 
			}	
			var chart = AmCharts.makeChart( "${comId}_chartdiv2", chartConfig);
		}
	}
</script>


<div id="${comId}" style="margin-top:20px" onePageBlock="Y">
	<div class="div_wrap" name="pageBlock">
		<div class="div_left">
			<div>
				<div class="list_wrap">
					<table style="width:100%">
						<colgroup>
							<col width="50%">
							<col width="50%">
						</colgroup>
						<tbody>
							<tr>
								<td style="padding:3px;vertical-align:top">
									<h4>수입(단위:만원)</h4>
									<div class="list_wrap">
										<div class="table_wrap">
											<table class="list_table" id="${comId}Income" style="min-width:350px">
											</table>
											<script type="text/x-jsrender" id="${comId}Income_template" >
												<colgroup>
													<col width="50%">
													<col width="50%">
												</colgroup>
												<tr>
													<th>소득종류</th>
													<th>소득금액</th>
												</tr>
												{{for incomeList}}
												<tr>
													<td class="ctr">{{:ITEM_NAME}}</td>
													<td class="rgt">{{:itemValueStr}}</td>
												</tr>
												{{/for}}
											</script>
										</div>
									</div>
								</td>
								<td style="padding:3px;vertical-align:top">
									<h4>지출(단위:만원)</h4>
									<div class="list_wrap">
										<div class="table_wrap" valign="top">
											<table class="list_table half_table" id="${comId}Consume" style="min-width:350px">
											</table>
											<script type="text/x-jsrender" id="${comId}Consume_template" >
												<colgroup>
													<col width="20%">
													<col width="43%">
													<col width="17%">
													<col width="15%">
												</colgroup>
												<tbody class="tbody_line">
													<tr>
														<th>지출구분</th>
														<th>지출종류</th>
														<th>지출액</th>
														<th>백분율</th>
													</tr>
													{{for consumeList}}
													<tr style="{{:style}}">
														<td class="ctr">{{:ITEM_GUBUN}}</td>
														{{if ITEM_NAME == "대출상환금"}}
														<td class="lft" style="margin:0 0 0 0;padding:0 0 0 0;">
															<table width="100%" cellpadding="0" cellspacing="0">
																<tr>
																	<td rowspan=2 style="border-left:0px;border-bottom:0px;">{{:ITEM_NAME}}</td>
																	<td>원금</td>
																	<td style="border-right:0px;color:{{:partFontColor}};">{{:paybackPrincipalTotalStr}}</td>
																</tr>
																<tr>
																	<td style="border-bottom:0px;">이자</td>
																	<td style="border-bottom:0px;border-right:0px;">{{:paybackInterestTotalStr}}</td>
																</tr>
															</table>
														</td>
														{{else}}
														<td class="lft">{{:ITEM_NAME}}</td>
														{{/if}}
														<td class="rgt"><span style="color:{{:fontColor}};">{{:itemValueStr}}</td>
														<td class="ctr"><!--{{:ITEM_TYPE}}-->{{:rate}}</td>
													</tr>
													{{/for}}
												</tbody>
											</script>
										</div>
									</div>
								</td>
							</tr>
						</tbody>
					</table>
					<div id="${comId}Total" style="width:100%;margin-top:-10px;">
					</div>
					<script type="text/x-jsrender" id="${comId}Total_template" >
						<table border="0" cellpadding="1" cellspacing="0" style="width:100%;margin-bottom:10px;">
							<tr>
								<td width="50%">
									<table border="0" cellpadding="0" cellspacing="0" style="width:100%;" class="table_total1">
										<tr>
											<td class="td_total ctr">총수입</td>
											<td class="td_total ctr">{{:getIncomeTotal()}}</td>
										</tr>
									</table>
								</td>
								<td width="50%">
									<table border="0" cellpadding="0" cellspacing="0" style="width:100%;" class="table_total1">
										<tr>
											<td class="td_total rgt">총지출</td>
											<td class="td_total ctr">{{:getConsumeTotal()}}</td>
										</tr>
									</table>
								</td>
							</tr>
						</table>
						<table border="0" cellpadding="1" cellspacing="0" style="width:100%;margin-bottom:10px;">
							<tr>
								<td width="10%">
									<table border="0" cellpadding="0" cellspacing="0" class="table_total2">
										<tr>
											<td class="td_total rgt"></td>
											<td class="td_total ctr"></td>
										</tr>
									</table>
								</td>
								<td width="90%">
									<table border="0" cellpadding="0" cellspacing="0" class="table_total2">
										<tr>
											<td class="td_total rgt">잉여자산(총수입 - 총지출)</td>
											<td class="td_total ctr">{{:getRestTotal()}}</td>
										</tr>
									</table>
								</td>
							</tr>
						</table>
					</script>
				</div>
			</div>
		</div>
		<div class="div_right" style="margin-left:-15px">
			<div style="margin-top:3px">
				<h4>지출 분석 Chart</h4>
				<div class="chart_wrap" style="width:320px; height:260px">
					<div id="${comId}_chartdiv" style="width:320px; height:260px"></div>
				</div>
			</div>
			<div style="margin-top:23px">
				<h4>저축(투자)성 지출 분석 Chart</h4>
				<div class="chart_wrap" style="width:320px; height:260px">
					<div id="${comId}_chartdiv2" style="width:320px; height:260px"></div>
				</div>
			</div>
		</div>
	</div>
</div>
