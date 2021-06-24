<%@ page contentType='text/html;charset=utf-8'%>

<%-- Component Id 설정 --%>
<c:set var="comId" value="financyAnalysisComponent"/>

<script type="text/javascript">

	_SVC_COM.loadJsFile("/explan/js/class/C_FINANCY_ANALYSIS.js");
	_SVC_COM.loadJsFile("/explan/amcharts/amcharts.js" 			);
	_SVC_COM.loadJsFile("/explan/amcharts/serial.js" 			);
	_SVC_COM.loadJsFile("/explan/amcharts/pie.js" 						);
	_SVC_COM.loadJsFile("/explan/amcharts/themes/light.js" 		);

	$(function() {
	});
	
	_G_FN["${comId}"] = {
		/* 콜백함수 필수 등록 */
		 callback 		: undefined
		,title			: "재무상태표"
		/* Parameter */
		,totalSum		: 0
		,orgTotalSum	: 0
		,totalSumStr	: ""
		,orgTotalSumStr	: ""
		,init 		: function(sendParm, callback) {
			/* 필수 지정 */
			this.sendParm 		= sendParm;
			this.callback 		= callback;
			
			// Financy Analysis Class를 생성한다.
			var cFinancyAnalysis = new C_FINANCY_ANALYSIS({planNum : sendParm.planNum});
			
			var investmentGroupByInfo = cFinancyAnalysis.getInvestmentGroupByInfo();
			
			var renderHtml 		= $("#${comId}Ivst_template").render(investmentGroupByInfo);
			
			$("#${comId}Ivst").html(renderHtml);
			
			var loanInfo		= cFinancyAnalysis.getLoanInfo();
			var renderHtml		= $("#${comId}Loan_template").render(loanInfo);
			$("#${comId}Loan").html(renderHtml);
			
			var immovableInfo	= cFinancyAnalysis.getImmovableInfo();
 			var renderHtml 		= $("#${comId}Immv_template").render(immovableInfo);
 			$("#${comId}Immv").html(renderHtml);
			
			$("#${comId}_totalSumStr"	).html(cFinancyAnalysis.totalSumStr		);
			$("#${comId}_orgTotalSumStr").html(cFinancyAnalysis.orgTotalSumStr	);
			
			this.loadChartLeftSide	(cFinancyAnalysis);
			this.loadChartRightSide	(cFinancyAnalysis);
		}
		,loadChartLeftSide : function(cFinancyAnalysis) {

			var chartData = {};
			var chartInfo 		= cFinancyAnalysis.getChartData();
			
			$.each(chartInfo, function(key, obj) {
				chartData[key] = [];
				$.each(obj, function(key2, obj2) {
					var item = {
						 "title" : key2
						,"cval"	: obj2.cval
					};
					chartData[key].push(item);
				});
			});
			var chartConfig = {
			    "type"				: "pie",
			    "theme"				: "light",
			    "innerRadius"		: "30%",
			    "gradientRatio"		: [-0.4, -0.4, -0.4, -0.4, -0.4, -0.4, 0, 0.1, 0.2, 0.1, 0, -0.2, -0.5],
			    "dataProvider"		: chartData["금융자산"],
			    "valueField"		: "cval",
			    "titleField"		: "title",
			    "percentPrecision" 	: 1,
			    "pieX"				: 135,
			    "pieY"				: 90,
			    "radius" 			: 50,
			    "labelRadius" 		: 5 
			}	
			
			chartConfig.dataProvider = chartData["금융자산"];
			var chart = AmCharts.makeChart( "${comId}_chartdiv1", chartConfig);
			
			chartConfig.dataProvider = chartData["부동산자산"];
			var chart = AmCharts.makeChart( "${comId}_chartdiv2", chartConfig);
		}
		,loadChartRightSide : function(cFinancyAnalysis) {
			
			var baseChartConfig = {
			     "theme"			: "light"
			    ,"type"				: "serial"
			    ,"valueAxes"		: [{
			        "position"			: "left"
			     }]
			    ,"graphs"			: [{
			        "fillColorsField"	: "color"
			        ,"fillAlphas"		: 1
			        ,"lineAlpha"		: 0.1
			        ,"type"				: "column"
			        ,"valueField"		: "value"
			        ,"labelText"		: "[[value]]만원"
			        ,"labelPosition"	: "top"
			    }]
			    ,"depth3D"			: 20
				,"angle"			: 30
			    ,"categoryField"	: "type"
			    ,"categoryAxis"		: {
			         "gridPosition"		: "start"
			    }
			}
			var chartConfig = fn_copyFullObject(baseChartConfig);
			var val = {};
			val["금융자산"	] = fn_fix(cFinancyAnalysis.investmentGroupByInfo.resultTotal	, 0);
			val["부동산자산"] = fn_fix(cFinancyAnalysis.immovableInfo.resultTotal			, 0);
			val["총자산"	] = fn_fix(val["금융자산"]) + Number(val["부동산자산"]			, 0); 	
			val["총부채"	] = fn_fix(cFinancyAnalysis.loanInfo.principalTotal				, 0);
			val["순자산"	] = val["총자산"] - val["총부채"]						 	
			
			chartConfig.dataProvider = [
		    	 {
			         "type"		: "금융자산"
			        ,"value"	: val["금융자산"]
			        ,"color"	: "#4040FF"
			     } 
			    ,{
			         "type"		: "부동산자산"
			        ,"value"	: val["부동산자산"]
			        ,"color"	: "#DF2020"
			     } 
			 ]
			var chart = AmCharts.makeChart( "${comId}_chartdiv3", chartConfig);
			
			var chartConfig2 = fn_copyFullObject(baseChartConfig);
			chartConfig2.dataProvider = [
		    	 {
					 "type"		: "총자산"
					,"value"	: val["총자산"]
					,"color"	: "#4040FF"
			      } 
		    	 ,{
					 "type"		: "총부채"
					,"value"	: val["총부채"]
					,"color"	: "#DF2020"
			      }
		    	 ,{
					 "type"		: "순자산"
					,"value"	: val["순자산"]
					,"color"	: "#20DF20"
				  } 
			]
			var chart = AmCharts.makeChart( "${comId}_chartdiv4", chartConfig2);	
		}
	}
</script>


<div id="${comId}" style="margin-top:20px" onePageBlock="Y">
	<div name="pageBlock">
		<div class="list_wrap">
			<table style="width:100%">
				<colgroup>
					<col width="50%">
					<col width="50%">
				</colgroup>
				<tbody>
					<tr>
						<td style="padding:3px;vertical-align:top">
							<h4>금융 자산</h4>
							<div class="list_wrap">
								<div class="table_wrap" valign="top">
									<table class="list_table half_table" id="${comId}Ivst">
									</table>
									<script type="text/x-jsrender" id="${comId}Ivst_template" >
										<colgroup>
											<col width="33%">
											<col width="34%">
											<col width="33%">
										</colgroup>
										<tbody class="tbody_line2">
											<tr>
												<th>금융자산종류</th>
												<th>투자(저축) 원금</th>
												<th>추정 금액</th>
											</tr>
											{{for groupList}}
											<tr>
												<td class="ctr">{{:investmentType}}</td>
												<td class="ctr">{{:sourceStr}}</td>
												<td class="ctr">{{:totalStr}}</td>
											</tr>
											{{/for}}
											<tr class="totaldeco">
												<td class="ctr">총 계</td>
												<td class="ctr">{{:sourceTotalStr}}</td>
												<td class="ctr">{{:resultTotalStr}}</td>
											</tr>
										</tbody>
									</script>
								</div>
							</div>
						</td>
						<td style="padding:3px;vertical-align:top">
							<h4>부채</h4>
							<div class="list_wrap">
								<div class="table_wrap">
									<table class="list_table half_table" id="${comId}Loan">
									</table>
									<script type="text/x-jsrender" id="${comId}Loan_template" >
										<colgroup>
											<col width="50%">
											<col width="50%">
										</colgroup>
										<tbody class="tbody_line2">
											<tr>
												<th>부채종류</th>
												<th>부채금액</th>
											</tr>
											{{for loanList}}
											<tr>
												<td class="ctr">{{:loanType}}</td>
												<td class="ctr">{{:restLoanStr}}</td>
											</tr>
											{{/for}}
											<tr class="totaldeco">
												<td class="ctr">총 계</td>
												<td class="ctr">{{:principalTotalStr}}</td>
											</tr>
										</tbody>
									</script>
								</div>
							</div>
						</td>
					</tr>
				</tbody>
			</table>
		</div>	
		<div class="list_wrap" style="margin-top:-25px">
			<table style="width:100%">
				<colgroup>
					<col width="50%">
					<col width="50%">
				</colgroup>
				<tbody>
					<tr>
						<td style="padding:3px;vertical-align:top">
							<h4>부동산 자산</h4>
							<div class="list_wrap">
								<div class="table_wrap" valign="top">
									<table class="list_table half_table" id="${comId}Immv">
									</table>
									<script type="text/x-jsrender" id="${comId}Immv_template" >
										<colgroup>
											<col width="33%">
											<col width="34%">
											<col width="33%">
										</colgroup>
										<tbody class="tbody_line2">
											<tr>
												<th>부동산 종류</th>
												<th>취득 금액</th>
												<th>추정 금액</th>
											</tr>
											{{for totalListGroupByType}}
											<tr>
												<td class="ctr">{{:immovableType}}</td>
												<td class="ctr">{{:sourceStr}}</td>
												<td class="ctr">{{:totalStr}}</td>
											</tr>
											{{/for}}
											<tr class="totaldeco">
												<td class="ctr">총 계</td>
												<td class="ctr">{{:sourceTotalStr}}</td>
												<td class="ctr">{{:resultTotalStr}}</td>
											</tr>
										</tbody>
									</script>
								</div>
							</div>
						</td>
						<td style="padding:3px;vertical-align:top">&nbsp;</td>
					</tr>
				</tbody>
			</table>
			<table border="0" cellpadding="1" cellspacing="0" style="width:100%;margin-top:-10px">
				<tr>
					<td width="50%">
						<table border="0" cellpadding="0" cellspacing="0" style="width:100%" class="table_total">
							<tr>
								<td width="67%" class="td_total ctr" colspan=2>총자산</td>
								<td width="33%" class="td_total"><span id="${comId}_totalSumStr"></span></td>
							</tr>
						</table>
					</td>
					<td width="50%">
						<table border="0" cellpadding="0" cellspacing="0" style="width:100%" class="table_total">
							<tr>
								<td width="50%" class="td_total ctr">순자산(총자산 - 부채)</td>
								<td width="50%" class="td_total"><span id="${comId}_orgTotalSumStr"></span></td>
							</tr>
						</table>
					</td>
				</tr>
			</table>
		</div>	
		<div class="div_wrap" style="width:100%;margin-top:-5px">
			<div class="div_left">
				<div class="div_wrap" style="width:100%">
					<div class="div_left">
						<div style="margin-top:3px">
							<h4>금융자산구성 Chart</h4>
							<div class="chart_wrap" style="width:100%; height:180px">
								<div id="${comId}_chartdiv1" style="width:98%; height:180px"></div>
							</div>
						</div>
					</div>
					<div class="div_right">
						<div style="margin-top:3px">
							<h4>부동산자산구성 Chart</h4>
							<div class="chart_wrap" style="width:100%; height:180px">
								<div id="${comId}_chartdiv2" style="width:98%; height:180px"></div>
							</div>
						</div>
					</div>
				</div>
			</div>
			<div class="div_right">
				<div class="div_wrap" style="width:100%">
					<div class="div_left">
						<div style="margin-top:3px">
							<h4>자산Type별비율 Chart</h4>
							<div class="chart_wrap" style="width:100%; height:180px">
								<div id="${comId}_chartdiv3" style="width:98%; height:180px"></div>
							</div>
						</div>
					</div>
					<div class="div_right">
						<div style="margin-top:3px">
							<h4>자산대비부채비율 Chart</h4>
							<div class="chart_wrap" style="width:100%; height:180px">
								<div id="${comId}_chartdiv4" style="width:98%; height:180px"></div>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
</div>

