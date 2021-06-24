<%@ page contentType='text/html;charset=utf-8'%>

<%-- Component Id 설정 --%>
<c:set var="comId" value="insuranceDamboBaseCompareComponent"/>

<script type="text/javascript">

	_SVC_COM.loadJsFile("/explan/amcharts/amcharts.js" 		);
	_SVC_COM.loadJsFile("/explan/amcharts/radar.js" 		);
	_SVC_COM.loadJsFile("/explan/amcharts/serial.js" 		);
	_SVC_COM.loadJsFile("/explan/amcharts/themes/light.js" 	);

	_SVC_COM.loadJsFile("/explan/js/class/C_INSURANCE_GROUP.js");
	
	$(function() {
	});
	
	_G_FN["${comId}"] = {
		/* 콜백함수 필수 등록 */
		 callback 			: undefined
		/* Component Title 필수 등록 */
		,title			: "보험 담보 비교"
		,cInsuranceGroup	: undefined
		,cInsuranceGroupBase: undefined
		,init 				: function(sendParm, callback) {
			
			if(!isValid(_SESSION["BASE_PLAN_NUM"])) return;
			
			/* 필수 지정 */
			this.sendParm 				= sendParm;
			this.callback 				= callback;
			this.cInsuranceGroupBase	= sendParm.cInsuranceGroupBase;
			this.cInsuranceGroup		= sendParm.cInsuranceGroup;
		 }
		 // 화면 Load
		,loadDambo : function(parm) {
			$("#${comId}").empty();
			this.loadBaseDamboCompareAnalysis(parm);
			this.loadTermDamboCompareAnalysis(parm);
			mergeTableTBodyRowspan("${comId}");
			mergeTableTBodyColspan("${comId}");
			this.loadChartAnalysis(parm);
		 }
		,loadBaseDamboCompareAnalysis : function(parm) {
			var insuredName 	= parm.insuredName;
			var damboGroupType 	= parm.damboGroupType;
			var insuredIdx		= parm.insuredIdx;

			var insuranceDamboGroup 	= this.cInsuranceGroup		.makeBaseDamboAnalysisMap(parm);
			var insuranceDamboGroupBase	= this.cInsuranceGroupBase	.makeBaseDamboAnalysisMap(parm);
			var resultMap = {};
			$.each(insuranceDamboGroup.insuranceDamboList, function() {
				resultMap[this.DAMBO_NUM] = this;
				resultMap[this.DAMBO_NUM].cDamboMoneyTotalBase 		= new C_DAMBO_MONEY();
			}); 
			$.each(insuranceDamboGroupBase.insuranceDamboList, function() {
				if(isValid(resultMap[this.DAMBO_NUM])) {
					resultMap[this.DAMBO_NUM].cDamboMoneyTotalBase 	= this.cDamboMoneyTotal;
				} else {
					resultMap[this.DAMBO_NUM] = this;
					resultMap[this.DAMBO_NUM].cDamboMoneyTotalBase 	= this.cDamboMoneyTotal;
					resultMap[this.DAMBO_NUM].cDamboMoneyTotal		= new C_DAMBO_MONEY();
				}
			});
			insuranceDamboGroup.insuredIdx = insuredIdx;
			insuranceDamboGroup.insuredName = insuredName;
			var resultList 		= [];
			var resultListDivde	= [];

			$.each(resultMap, function(){resultList.push(this)});
			
			resultList = resultList.orderBy("CATEGORY_NUM");

			var cnt = resultList.length;
			var halfcnt = Math.ceil(resultList.length / 2);
			if( cnt > 5 ) {
				var sndIdx = 0; 
				$.each(resultList, function(idx) {
					if(idx < halfcnt) {
						resultListDivde.push(this);
					} else {
						resultListDivde[sndIdx].CATEGORY_NAME2 			= this.CATEGORY_NAME		;
						resultListDivde[sndIdx].DAMBO_NAME2 			= this.DAMBO_NAME			;
						resultListDivde[sndIdx].cDamboMoneyTotalBase2 	= this.cDamboMoneyTotalBase	;	
						resultListDivde[sndIdx].cDamboMoneyTotal2		= this.cDamboMoneyTotal		;
						sndIdx++;
					}
				});
			} else {
				resultListDivde = resultList;
			}
			var renderHtml = $("#${comId}BaseAnalysis_template").render({damboList : resultListDivde});
			
			$("#${comId}").append(renderHtml);

		 }
		,loadTermDamboCompareAnalysis : function(parm) {
			var insuredName 	= parm.insuredName;
			var damboGroupType 	= parm.damboGroupType;
			var insuredIdx		= parm.insuredIdx;

			var damboMoneyResultMap 	= this.cInsuranceGroup		.makeDamboMoneyAnalysisMap(parm, this.cInsuranceGroupBase);
			var baseDamboMoneyResultMap	= this.cInsuranceGroupBase	.makeDamboMoneyAnalysisMap(parm, this.cInsuranceGroup);
			damboMoneyResultMap.insuredIdx 	= insuredIdx;
			damboMoneyResultMap.insuredName = insuredName;
			
			var allDamboMap = {};
			$.each(baseDamboMoneyResultMap.insuranceDamboList, function() {
				allDamboMap[this.DAMBO_NUM] = {
					 CATEGORY_NAME 	: this.CATEGORY_NAME	
					,DAMBO_NUM 		: this.DAMBO_NUM	
					,DAMBO_NAME 	: this.DAMBO_NAME	
				}
			});
			$.each(damboMoneyResultMap.insuranceDamboList, function() {
				allDamboMap[this.DAMBO_NUM] = {
					 CATEGORY_NAME 	: this.CATEGORY_NAME	
					,DAMBO_NUM 		: this.DAMBO_NUM	
					,DAMBO_NAME 	: this.DAMBO_NAME	
				}
			});
			var allDamboList 	= mapToList(allDamboMap, ["DAMBO_NUM"]);
			allDamboList 		= allDamboList.orderBy("DAMBO_NUM");

			var termParm = {
				 termList 				: damboMoneyResultMap.termList
				,allDamboList			: allDamboList
				,insuranceDamboMap		: damboMoneyResultMap.insuranceDamboMap
				,baseInsuranceDamboMap	: baseDamboMoneyResultMap.insuranceDamboMap
			}
			
			//allDamboMap = allDamboMap.orderBy("DAMBO_NUM");
			
			//dwrite(allDamboMap);

			//var termParm = damboMoneyResultMap;
			//termParm.insuranceDamboList = damboList;	
			
			var renderHtml = $("#${comId}TermAnalysis_template").render(termParm);
			$("#${comId}").append(renderHtml);
		 }
		,loadChartAnalysis	: function(parm) {
			
			var chartDamboList = _SVC_DAMBO.getChartDamboList();
			
			var chartDamboAnalysisMap 		= this.cInsuranceGroup		.makeBaseDamboAnalysisMap(parm);
			var baseChartDamboAnalysisMap 	= this.cInsuranceGroupBase	.makeBaseDamboAnalysisMap(parm);
			
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
				var obj = chartDamboAnalysisMap.insuranceDamboMap[damboNum];
				
				// radar chart 설정
				if(obj != undefined && obj.cDamboMoneyTotal != undefined) {
					 damboRate			= Math.round(obj.cDamboMoneyTotal.maxInsuranceMoney / Number(pivotValue) * 100);
				} 
				var baseDamboRate = 0;
				var baseObj = baseChartDamboAnalysisMap.insuranceDamboMap[damboNum];
				
				// radar chart 설정
				if(baseObj != undefined && baseObj.cDamboMoneyTotal != undefined) {
					baseDamboRate		= Math.round(baseObj.cDamboMoneyTotal.maxInsuranceMoney / Number(pivotValue) * 100);
				} 
				var addItem = {
	   	             "primaryDamboName"		: primaryDamboName
	   	            ,"damboRate"			: damboRate
	   	            ,"baseDamboRate"		: baseDamboRate
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
			this.loadRadarChartByDambo	(radarChartData		, "${comId}radarChartByDamboDiv" 	+ parm.insuredIdx, parm.insuredIdx);
			// bar chart 그리기
			this.loadBarChartByDambo	(barChartDataList	, "${comId}barChartByDamboDiv" 		+ parm.insuredIdx, parm.insuredIdx);
		},
		loadRadarChartByDambo : function(radarChartData, targetDiv, insuredIdx) {
  		    var chartConfig = {
	  			 type				: "radar"
				,theme				: "light"
		    	,categoryField 		: "primaryDamboName"
		    	,startDuration 		: 0.5
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
			    		,fillAlphas		: 0.20
		    			,valueField 	: "baseDamboRate"
		    		 }
		    		,{
					     bullet			: "round"	
			    		,lineThickness	: 1
			    		,fillAlphas		: 0.20
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
		 } 		
 		,loadDamboCompareForReport : function(pageParm) {
			// 복수의 피보험자에 대해 처리
 			var parm = {
				 "damboGroupType"	: pageParm.damboGroupType
			};
 			$("#${comId}").empty();
			$.each(pageParm.insuredNameList, function(insuredIdx) {
				parm.insuredName = this;
				parm.insuredIdx = insuredIdx;
				$("#${comId}").append("<div name=pageBlock option=subTitle>피보험자 : " + this + "</div>");
				_G_FN["${comId}"].loadBaseDamboCompareAnalysis(parm);
				_G_FN["${comId}"].loadTermDamboCompareAnalysis(parm);
				_G_FN["${comId}"].loadChartAnalysis(parm);
			});
		 }
	}

	// jsrender 사용자 정의 함수
	$.views.converters({
		 // DateFormat  
		getMoneyRange : function(cDamboMoney) {
			if(isValid(cDamboMoney)) {
				var money = cDamboMoney.getMoneyRange();
				if(money == "0만원") money = "";
				return money;
			} else {
				return "";
			}
		}	
	});
	
</script>

<div id="${comId}">
</div>
<script type="text/x-jsrender" id="${comId}BaseAnalysis_template" >
	<div name="pageBlock">
		<h4>기본 담보 비교</h4>
		<div class="list_wrap">
			<div class="table_wrap">
			<table class="list_table" dobuleLine="3">
				<colgroup >
					<col width="8%"> 
		 			<col width="18%">
					<col width="12%">
					<col width="12%">
					<col width="1px" class="del_topbottomline">
					<col width="8%"> 
		 			<col width="18%">
					<col width="12%">
					<col width="12%"> 
				</colgroup>
				<thead>
					<tr>
						<th colspan="2">담보명</th>
						<th>기존보험총합</th>
						<th class="add_rightline">제안보험총합</th>
						<td class="del_topbottomline"></td>
						<th colspan="2">담보명</th>
						<th>기존보험총합</th>
						<th>제안보험총합</th>
					</tr>
				</thead>
				<tbody mergerow="Y" mergeparm="1,6">
			    {{for damboList}}
					<tr>
						<th class="ctr">{{:CATEGORY_NAME}}</th>
						<th class="ctr">{{:DAMBO_NAME}}</th>
						<td class="ctr">{{getMoneyRange:cDamboMoneyTotalBase}}</td>
						<td class="ctr" class="add_rightline">{{getMoneyRange:cDamboMoneyTotal}}</td>
						<td class="del_topbottomline"></td>
						<th class="ctr">{{:CATEGORY_NAME2}}</th>
						<th class="ctr">{{:DAMBO_NAME2}}</th>
						<td class="ctr">{{getMoneyRange:cDamboMoneyTotalBase2}}</td>
						<td class="ctr">{{getMoneyRange:cDamboMoneyTotal2}}</td>
					</tr>
				{{/for}}
				</tbody>
			</table>
			</div>
		</div>
	</div>
</script>

<script type="text/x-jsrender" id="${comId}TermAnalysis_template" >
	<div name="pageBlock">
		<h4>기간별 담보 비교</h4>
		<div class="list_wrap report_tw">
			<div class="table_wrap add_line">
				<table class="list_table report_lt" id="${comId}TermAnalysis{{:insuredIdx}}">
					<colgroup>
						<col width="150">
						<col width="200">
						<col width="50">
						<col>
						<col>
					</colgroup>
					<thead>
						<tr>
							<th colspan="3">담보명</th>
						    {{for termList}}
							{{if TERM > 0}}
							<th style="text-align:right">~{{:TERM}}세</th>
							{{else}}
							<th>&nbsp;</th>
							{{/if}}
							{{/for}}
						</tr>
					</thead>
					<tbody mergerow="Y" mergeparm="1,2" mergecol="Y">
					{{if allDamboList && allDamboList.length}}
					    {{for allDamboList ~termList=termList ~insuranceDamboMap=insuranceDamboMap ~baseInsuranceDamboMap=baseInsuranceDamboMap}}
						<tr class="small_line">
							<td class="add_topline" style="font-size:12px">{{:CATEGORY_NAME}}</td>
							<td class="add_topline" style="font-size:12px">{{:DAMBO_NAME}}</td>
							<td class="add_topline ctr">기존</td>
						    {{for ~termList ~damboNum=DAMBO_NUM }}
							{{if 
									~baseInsuranceDamboMap[~damboNum] 		!= null
								&&	~baseInsuranceDamboMap[~damboNum] 		!= undefined
								&&	~baseInsuranceDamboMap[~damboNum][TERM]	!= null
								&&	~baseInsuranceDamboMap[~damboNum][TERM]	!= undefined
								&&	~baseInsuranceDamboMap[~damboNum][TERM].isValid()
							}}
							<td class="add_topline ctr">{{:~baseInsuranceDamboMap[~damboNum][TERM].getMoneyRange()}}</td>
							{{else}}
							<td class="add_topline">&nbsp;</td>
							{{/if}}
							{{/for}}
						</tr>
						<tr class="small_line">
							<td class="add_bottomline" style="font-size:12px">{{:CATEGORY_NAME}}</td>
							<td class="add_bottomline" style="font-size:12px">{{:DAMBO_NAME}}</td>
							<td class="add_bottomline ctr">제안</td>
						    {{for ~termList ~damboNum=DAMBO_NUM }}
							{{if 
									~insuranceDamboMap[~damboNum] 		!= null
								&&	~insuranceDamboMap[~damboNum] 		!= undefined
								&&	~insuranceDamboMap[~damboNum][TERM]	!= null
								&&	~insuranceDamboMap[~damboNum][TERM]	!= undefined
								&&	~insuranceDamboMap[~damboNum][TERM].isValid()
							}}
							<td class="add_bottomline ctr">{{:~insuranceDamboMap[~damboNum][TERM].getMoneyRange()}}</td>
							{{else}}
							<td class="add_bottomline">&nbsp;</td>
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


<script type="text/x-jsrender" id="${comId}ChartAnalysis_template" >
	<div name="pageBlock">
		<div class="div_wrap" style="height:400px">
			<div class="div_right">
				<h4>필수 담보 보장 분포도</h4>
				<div class="chart_wrap" style="width:400px; height:360px">
					<br/><br/>
					<div id="${comId}radarChartByDamboDiv{{:insuredIdx}}" style="width:99%;height:300px"></div>
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
											<td style="width:150px; height:{{:~barHeight}};"><div id="${comId}barChartByDamboDiv{{:~insuredIdx}}{{:damboNum}}" style="width:99%px; height:99%;"></div></td>
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

	