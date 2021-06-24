<%@ page contentType='text/html;charset=utf-8'%>

<%-- Component Id 설정 --%>
<c:set var="comId" value="insuranceDamboAnalysisComponent"/>

<script type="text/javascript">
	
	_SVC_COM.loadJsFile("/explan/amcharts/amcharts.js" 		);
	_SVC_COM.loadJsFile("/explan/amcharts/radar.js" 		);
	_SVC_COM.loadJsFile("/explan/amcharts/serial.js" 		);
	_SVC_COM.loadJsFile("/explan/amcharts/themes/light.js" 	);

	_SVC_COM.loadJsFile("/explan/js/class/C_INSURANCE_GROUP.js");

	_G_FN["${comId}"] = {
		/* 콜백함수 필수 등록 */
		callback 		: undefined,
		/* Component Title 필수 등록 */
		title			: "보험 담보 분석",
		/* Parameter */
		sendParm		: undefined,
		cInsuranceGroup	: undefined,
		init 		: function(sendParm, callback) {
			/* 필수 지정 */
			this.sendParm			= sendParm;
			this.callback 			= callback;
			this.cInsuranceGroup	= sendParm.cInsuranceGroup;
		},
		loadDambo : function(parm) {
			$("#${comId}").empty();
			this.loadBaseDamboAnalysis(parm);
			this.loadTermDamboAnalysis(parm);
			this.loadChartAnalysis(parm);
			mergeTableTBodyRowspan("${comId}");
			mergeTableTBodyColspan("${comId}");
		},
		// 화면 Load
		loadBaseDamboAnalysis : function(parm) {
			var insuredName 	= parm.insuredName;
			var damboGroupType 	= parm.damboGroupType;
			var insuredIdx		= parm.insuredIdx;
			
			var insuranceDamboGroup = this.cInsuranceGroup.makeBaseDamboAnalysisMap(parm);
			insuranceDamboGroup.insuredIdx = insuredIdx;
			insuranceDamboGroup.insuredName = insuredName;
			var renderHtml = $("#${comId}BaseAnalysis_template").render(insuranceDamboGroup);
			$("#${comId}").append(renderHtml);
		},
		loadTermDamboAnalysis : function(parm) {
			var insuredName 	= parm.insuredName;
			var damboGroupType 	= parm.damboGroupType;
			var insuredIdx		= parm.insuredIdx;

			var damboMoneyResultMap = this.cInsuranceGroup.makeDamboMoneyAnalysisMap(parm);
			damboMoneyResultMap.insuredIdx 	= insuredIdx;
			damboMoneyResultMap.insuredName = insuredName;
			var renderHtml = $("#${comId}TermAnalysis_template").render(damboMoneyResultMap);
			$("#${comId}").append(renderHtml);
		},
		loadChartAnalysis	: function(parm) {
			
			var chartDamboList = _SVC_DAMBO.getChartDamboList();
			
			var baseDamboAnalysisMap = this.cInsuranceGroup.makeBaseDamboAnalysisMap(parm);
			
 			var radarChartData 		= [];
 			
 			var barChartDataList	= [];  // 한 Line에 5개씩 처리하기 위함.
 			var barChartData 		= [];
 			
 			var damboMap = _SVC_DAMBO.getFullDamboMap().fullDamboMap;
 			
			$.each(chartDamboList, function(idx) {
				var damboNum 			= this.DAMBO_NUM	;
				var primaryDamboName	= this.DAMBO_NAME	;
				var pivotValue			= this.PIVOT_VALUE	;
				if(!isValid(pivotValue) || pivotValue < 1) {
					return true;
				}
				var damboRate = 0;
				var obj = baseDamboAnalysisMap.insuranceDamboMap[damboNum];
				
				// radar chart 설정
				if(obj != undefined && obj.cDamboMoneyTotal != undefined) {
					 damboRate			= Math.round(obj.cDamboMoneyTotal.maxInsuranceMoney / Number(pivotValue) * 100);
				} 
				var addItem = {
	   	            "primaryDamboName"	: primaryDamboName,
	   	            "damboRate"			: damboRate
				}
				radarChartData.push(addItem);
				
				// bar chart 설정
				if(obj == undefined || obj.cDamboMoneyTotal == undefined) 	cGuarantee = 0;
				else														cGuarantee = obj.cDamboMoneyTotal.maxInsuranceMoney;

				var barAddItem = {
	   	             "damboNum"			: damboNum
	   	            ,"primaryDamboName"	: primaryDamboName
	   	            ,"pivotValue"		: pivotValue
	   	            ,"cGuarantee"		: cGuarantee
				}
				barChartData.push(barAddItem);
				
				if(idx % 4 == 3) {
					barChartDataList.push({barChartData : barChartData});
					barChartData = [];
				}
			});
			var restArr = [];
			if(barChartData.length > 0) {
				for (var i = 0; i < 4; i++) {
					if(isValid(barChartData[i]))	restArr.push(barChartData[i]);
					else							restArr.push({a:1});
				}
			}
			barChartDataList.push({barChartData : restArr});
			var rdParm = {
				 barChartDataList 	: barChartDataList
				,insuredIdx			: parm.insuredIdx
				,barHeight			: "140px"
			}
			var renderHtml 	= $("#${comId}ChartAnalysis_template").render(rdParm);

			$("#${comId}").append(renderHtml);

			// radar chart 그리기
			this.loadRadarChartByDambo	(radarChartData		, "radarChartByDamboDiv" 	+ parm.insuredIdx, parm.insuredIdx);
			// bar chart 그리기
			this.loadBarChartByDambo	(barChartDataList	, "barChartByDamboDiv" 		+ parm.insuredIdx, parm.insuredIdx);
		},
		loadRadarChartByDambo : function(radarChartData, targetDiv, insuredIdx) {
  		    var chartConfig = {
	  			 type				: "radar"
				,theme				: "light"
		    	,categoryField 		: "primaryDamboName"
		    	,startDuration 		: 2
				,dataProvider 		: radarChartData          
		    	,valueAxes			: [
		    	    { 
				    	 axisTitleOffset: 5  	
				    	,minimum 		: 0	  	
						,axisAlpha 		: 0.15 
				    	,maximum 		: 100 	
			    	}
		    	]
		    	,graphs				: [
		    		{
					     bullet			: "round"	
			    		,lineThickness	: 1
			    		,fillAlphas		: 0.05
		    			,valueField 	: "damboRate"
		    		}
		    	]
  		  		,colors 			: ["#FF6600", "#0D8ECF"],
		    };
		    
 			var chart = AmCharts.makeChart( targetDiv, chartConfig);
		},
		loadBarChartByDambo : function(barChartDataList, targetDiv, insuredIdx) {
			$.each(barChartDataList, function(fidx) {
				$.each(this.barChartData, function(sidx) {
					var chartConfig = {
					    "theme"			: "light",
					    "type"			: "serial",
						"startDuration"	: 0,
					    "dataProvider"	: [
					    {
					        "dambo"					: "",					// 표준금액
					        "guarantee"				: this.pivotValue,
					        "color"					: "#DD0F00"
					    }, 
					    {
					        "dambo"					: "",					// 현재금액
					        "guarantee"				: this.cGuarantee,
					        "color"					: "#2266FF"
					    }],
					    "valueAxes": [{
					      	"minimum" 	: 0
					    }],
					    "graphs": [{            	
					        "fillColorsField"		: "color",
					        "fillAlphas"			: 1,
					        "lineAlpha"				: 0.1,
					        "type"					: "column",
					        "valueField"			: "guarantee",
					        "labelText"				: "[[value]]"
					    }],
					    "depth3D"		: 20,
						"angle"			: 30,
					    "chartCursor"	: {
					        "categoryBalloonEnabled": false,
					        "cursorAlpha"			: 0,
					        "zoomable"				: false
					    },
					    "categoryField"	: "dambo",
					    "categoryAxis"	: {
					        "gridPosition"			: "start"
					    }
					}
					if(fidx == 0 && sidx == 0) {
						chartConfig["legend"] = {
					    	"data" : [{title: "표준금액", color: "#DD0F00"},{title: "현재금액", color: "#2266FF"}],
							"divId" : "${comId}legendCommonDiv_template"
						}
						$("#${comId}legendCommonDiv_template").remove();
						$("body").append("<div id=${comId}legendCommonDiv_template style='visibility:hidden'></div>");
					}
					
					var chart = AmCharts.makeChart( targetDiv + this.damboNum, chartConfig);
					
					if(fidx == 0 && sidx == 0) {
						var t = $("#${comId}legendCommonDiv_template").html();
						$("#${comId}legendCommonDiv" + insuredIdx).html(t);
						chart.addListener("init", function(){
							var t = $("#${comId}legendCommonDiv_template").html();
							$("#${comId}legendCommonDiv" + insuredIdx).html(t);
						});
					}
				});
			});
		},
		// 담보 그룹 관리 POPUP
/* 		damboGroupManagePopup : function () {
			// 전체 담보 정보를 읽는다.
			var parm = _SVC_DAMBO.getFullDamboMap(true);

			_SVC_POPUP.setConfig("damboGroupManagePopup", {"fullDamboOrder" : parm.DAMBO_ORDER, "fullDamboMap" : parm.DAMBO_MAP}, function(returnData) {
			});
			_SVC_POPUP.show("damboGroupManagePopup");
		},
 */		
 		loadDamboAnalysisForReport : function(pageParm) {
			
			// 복수의 피보험자에 대해 처리
 			var parm = {
				 "damboGroupType"	: pageParm.damboGroupType
			};
 			$("#${comId}").empty();
			$.each(pageParm.insuredNameList, function(insuredIdx) {
				parm.insuredName = this;
				parm.insuredIdx = insuredIdx;
				$("#${comId}").append("<div name=pageBlock option=subTitle>피보험자 : " + this + "</div>");
				_G_FN["${comId}"].loadBaseDamboAnalysis(parm);
				_G_FN["${comId}"].loadTermDamboAnalysis(parm);
				_G_FN["${comId}"].loadChartAnalysis(parm);
			});
		} 
	}
</script>


<script>
	$(function() {
	});
</script>


<div id="${comId}">
</div>
<script type="text/x-jsrender" id="${comId}BaseAnalysis_template">
	<div name="pageBlock">
		<h4>기본 담보 분석</h4>
		<div class="list_wrap">
			<div class="table_wrap">
				<table class="list_table">
					<colgroup>
						<col width="150">
						<col width="200">
						{{for companyNameList}}
						<col width="*">
						{{/for}}
						<col>
					</colgroup>
					<thead>
						<tr>
							<th colspan="2">담보명</th>
						    {{for companyNameList}}
							<th>{{:COMPANY_NAME}}</th>
							{{/for}}
							<th>종합</th>
						</tr>
					</thead>
					<tbody mergerow="Y" mergeparm="1">
					{{if insuranceDamboList && insuranceDamboList.length}}
					    {{for insuranceDamboList ~companyNameList=companyNameList ~insuranceDamboMap=insuranceDamboMap}}
						<tr>
							<td>{{:CATEGORY_NAME}}</td>
							<td>{{:DAMBO_NAME}}</td>
						    {{for ~companyNameList ~damboNum=DAMBO_NUM }}
							<td>{{:~insuranceDamboMap[~damboNum][COMPANY_NAME]}}</td>
							{{/for}}
							{{if cDamboMoneyTotal != undefined}}
							<td>{{:cDamboMoneyTotal.getMoneyRange()}}</td>
							{{else}}
							<td>&nbsp;</td>
							{{/if}}
						</tr>
						{{/for}}
					{{else}}
						<tr>
							<td class="ctr" colspan="{{:companyNameList.length + 3}}">설정된 담보가 없습니다.</td>
						</tr>
					{{/if}}
					</tbody>
				</table>
			</div>
		</div>
	</div>
</script>

<script type="text/x-jsrender" id="${comId}TermAnalysis_template" >
	<div name="pageBlock">
		<h4>기간별 담보 분석</h4>
		<div class="list_wrap report_tw">
			<div class="table_wrap">
				<table class="list_table report_lt" id="${comId}TermAnalysis{{:insuredIdx}}">
					<colgroup>
						<col width="150">
						<col width="200">
						<col>
						<col>
					</colgroup>
					<thead>
						<tr>
							<th colspan="2">담보명</th>
						    {{for termList}}
							{{if TERM > 0}}
							<th style="text-align:right">~{{:TERM}}세</th>
							{{else}}
							<th>&nbsp;</th>
							{{/if}}
							{{/for}}
						</tr>
					</thead>
					<tbody mergerow="Y" mergeparm="1" mergecol="Y">
					{{if insuranceDamboList && insuranceDamboList.length}}
					    {{for insuranceDamboList ~termList=termList ~insuranceDamboMap=insuranceDamboMap}}
						<tr>
							<td>{{:CATEGORY_NAME}}</td>
							<td>{{:DAMBO_NAME}}</td>
						    {{for ~termList ~damboNum=DAMBO_NUM }}
							{{if ~insuranceDamboMap[~damboNum][TERM] != undefined && ~insuranceDamboMap[~damboNum][TERM].isValid()}}
							<td class="ctr">{{:~insuranceDamboMap[~damboNum][TERM].getMoneyRange()}}</td>
							{{else}}
							<td>&nbsp;</td>
							{{/if}}
							{{/for}}
						</tr>
						{{/for}}
					{{/if}}	
					</tbody>
				</table>
			</div>
		</div>
	</div>
</script>	

<%-- 
		<div class="list_wrap">
			<div class="list_head">
				<div class="button" id="btnEdit">
					<span class="btn_list"><a href="javascript:_G_FN['${comId}'].damboGroupManagePopup();">담보그룹관리</a></span>
				</div>
			</div>
		</div>
 --%>


<script type="text/x-jsrender" id="${comId}ChartAnalysis_template" >
	<div name="pageBlock">
		<div class="div_wrap" style="height:400px">
			<div class="div_right">
				<h4>필수 담보 보장 분포도</h4>
				<div class="chart_wrap" style="width:400px; height:360px">
					<br/><br/>
					<div id="radarChartByDamboDiv{{:insuredIdx}}" style="width:99%;height:300px"></div>
				</div>
			</div>
			<div class="div_right">
				<h4>필수 담보 분석 차트 </h4>
				
				<div class="chart_wrap" style="width:620px; height:360px">
					<div id="${comId}legendCommonDiv{{:insuredIdx}}"></div>
					<table width="100%" style="margin-top:15px">
						<colgroup>
							<col width="100%">
						</colgroup>
						<tbody>
						    {{for barChartDataList ~insuredIdx=insuredIdx ~barHeight=barHeight}}
							<tr>
								<td>
									<table style="width:100%;height:100%">
										<tr style="height:{{:~barHeight}}">
									    {{for barChartData ~insuredIdx=~insuredIdx}}
											<td style="width:150px; height:{{:~barHeight}};"><div id="barChartByDamboDiv{{:~insuredIdx}}{{:damboNum}}" style="width:99%px; height:99%;"></div></td>
										{{/for}}
										</tr>	
										<tr style="height:20px">
									    {{for barChartData}}
											<td style="width:150px;text-align:center">{{:primaryDamboName}}</div></td>
										{{/for}}
										</tr>	
									</table>
								</td>
							</tr>
							{{/for}}
						</tbody>
					</table>
				</div>
			</div>
		</div> 		
	</div> 		
</script>

<!-- Add Dambo Popup -->
<%@include  file="/include/popup/damboGroupManagePopup.jsp" %>
