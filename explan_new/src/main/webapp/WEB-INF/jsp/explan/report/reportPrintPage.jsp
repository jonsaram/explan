<%@ page language="java" errorPage="/explan/common/error.jsp" pageEncoding="UTF-8" contentType="text/html;charset=utf-8" %>

<%@include  file="/include/headerBaseSet.jsp" %>

<!-- 
	보고서 내용 구성 방법
	각 Component의 HTML결과물을 기준으로 보고서를 구성한다.
-->

<script>
	$(function() {
		
		// 담보 분석 피보험자 변경시 처리
		var pageParm = opener.getPageParam(true, PAGE_ID);
		
		var cInsuranceGroup 		= _SVC_INSURANCE.makeInsuranceGroup(_SESSION["PLAN_NUM"]);
		
		var cInsuranceGroupBase 	= _SVC_INSURANCE.makeInsuranceGroup(_SESSION["BASE_PLAN_NUM"], cInsuranceGroup);
		
		var sendParm				= {cInsuranceGroup : cInsuranceGroup, cInsuranceGroupBase : cInsuranceGroupBase};

		var componentList = [];
		
		//
		// Component 초기화
		// 
		
		// Investment List 읽어오기
		var parm = {
			 "planNum" 	: _SESSION["PLAN_NUM"]
			,"planDate" : _SESSION["PLAN_DATE"]
		}
		
 		// 재부분석요약 Component 초기화
		_SVC_COM.initComponent("financySummaryComponent", parm,function() {});
		// 재무상태표 Component 초기화
		_SVC_COM.initComponent("financyAnalysisComponent", parm,function() {});
 		// 현금흐름표 Component 초기화
		_SVC_COM.initComponent("cashflowAnalysisComponent", parm,function() {});
		// 보험 기본 분석 Component 초기화
		_SVC_COM.initComponent("insuranceBaseAnalysisComponent", {"cInsuranceGroup" : cInsuranceGroup}, function() {});
		// 보험 담보 분석 Component 초기화
		_SVC_COM.initComponent("insuranceDamboAnalysisComponent", {"cInsuranceGroup" : cInsuranceGroup}, function() {});

		// 보험 기본 비교 Component 초기화
		_SVC_COM.initComponent("insuranceCompareComponent", sendParm, function() {});
		// 보험 담보 비교 Component 초기화
		_SVC_COM.initComponent("insuranceDamboBaseCompareComponent", sendParm, function() {});

		var targetReportMap = pageParm.targetReportMap;
		
		if(targetReportMap["financySummaryComponent"			] == "Y") {
	 		// 재부분석요약 보고서 추가
			componentList.push("financySummaryComponent");
		}
		if(targetReportMap["financyAnalysisComponent"			] == "Y") {
			// 재무상태표 보고서 추가
			componentList.push("financyAnalysisComponent");
		}
		if(targetReportMap["cashflowAnalysisComponent"			] == "Y") {
	 		// 현금흐름표 보고서 추가
			componentList.push("cashflowAnalysisComponent");
		}
		if(targetReportMap["insuranceBaseAnalysisComponent"		] == "Y") {
			// 보험 기본 분석 보고서 추가
			componentList.push("insuranceBaseAnalysisComponent");
		}
		if(targetReportMap["insuranceDamboAnalysisComponent"	] == "Y") {
			// 보험 담보 분석 보고서 추가
			componentList.push("insuranceDamboAnalysisComponent");
			// 보고서 용으로 담보 분석 Report를 처리
		 	_G_FN["insuranceDamboAnalysisComponent"].loadDamboAnalysisForReport(pageParm);	
		}
		if(targetReportMap["insuranceCompareComponent"			] == "Y") {
			// 보험 기본 비교 보고서 추가
			componentList.push("insuranceCompareComponent");
		}
		if(targetReportMap["insuranceDamboBaseCompareComponent"	] == "Y") {
			// 보험 담보 비교 보고서 추가
			componentList.push("insuranceDamboBaseCompareComponent");
			// 보고서 용으로 담보 비교 Report를 처리
		 	_G_FN["insuranceDamboBaseCompareComponent"].loadDamboCompareForReport(pageParm);	
		}

		var allHtml = $("#reportAllDom").html();
		
		allHtml = allHtml.removeRangeChar("<script", "/script>");
		
		$("#reportAllDom").html(allHtml);
		
	    $("#reportAllDom").show();
		
		// Report를 생성한다.
//		cReport.makeReport(componentList, true, true);
		cReport.makeReport(componentList, pageParm);
		
		// table merge처리
	    mergeTableTBodyRowspan("reportAllDom");
		mergeTableTBodyColspan("reportAllDom");
		
	});


	//cReport 보고서이며 Paragraph의 집합이다.
	var cReport = {
		// 한페이지의 높이를 설정한다.
		 criterionHeight 	: 600
		,cParagraphList 	: []
		// Page 분석
		,makeParagrapList : function(componentList) {
			$.each(componentList, function() {

				var componentId 	= this;
				var componentObj	= $("#reportAllDom #"+componentId)
				var componentHeight	= $(componentObj).css("height").replaceAll("px", "");
				var onePageBlock	= $(componentObj).attr("onePageBlock");
				var title = _SVC_COM.getComponentTitle(componentId);
				
				var cParagraph = new CParagraph(title);
				
				// Component가 한페이지로 구성되어 있거나   ==> onePageBlock == "Y" 
				// Component가 한페이지 높이보다 작은경우 한페이지에 표시
				if(onePageBlock == "Y" || cReport.criterionHeight > componentHeight) {
					// Component가 한페이지 높이 미만인경우.
					var cBlock 		= new CBlock();
					cBlock.html 	= $(componentObj).html();
					cBlock.height	= componentHeight;
					cParagraph.cBlockList.push(cBlock);
					$(componentObj).remove();
				} else {
					// Component가 한페이지 높이 이상인경우. pageBlock단위로 Page처리
					$(componentObj).find("div[name=pageBlock]").each(function() {
						// 옵션처리
						var option = $(this).attr("option");
						if(isValid(option)) {
							var subTitle = $(this).html();
							if(option = "subTitle") {
								cParagraph.makePageHtmlList();
								cReport.cParagraphList.push(cParagraph);
								cParagraph = new CParagraph(title, subTitle);
							}
							//옵션처리 후 다음 pageBlock으로 진행한다.
							return true;
						}
						var pageBlockHeight	= $(this).css("height").replaceAll("px", "");
						if(cReport.criterionHeight > pageBlockHeight) {
							var html 		= $(this).html();
							var pageCut		= $(this).attr("pageCut");
							var cBlock 	= new CBlock(html, pageBlockHeight, pageCut)
							cParagraph.cBlockList.push(cBlock);
							$(this).remove();
						} else {
							var pageHtml 		= $(this).html();
							var blockBodyHeight = $(this).find("tbody").css("height").replaceAll("px", "");
							var pageBaseHeight 	= pageBlockHeight - blockBodyHeight;
							// Header, Footer를 높이를 계산한 새 Page Height 기준
							var newCriterionHeight = cReport.criterionHeight - pageBaseHeight;
	
							// Header, Footer 구하기
							var domObj = $("<div></div>").html(pageHtml);
							$(domObj).find("tbody").html("--divide--");
							var hfHtml 	= $(domObj).html();
							var divHtml	= hfHtml.split("--divide--");
							var header 	= divHtml[0];
							var footer 	= divHtml[1];
							
							var pageHtml 		= "";
							var compareHeight 	= 0;
							$(this).find("tbody tr").each(function() {
								var trHeight = $(this).css("height").replaceAll("px", "");
								compareHeight += Number(trHeight);
								if(newCriterionHeight > compareHeight) {
									pageHtml += $(this).getOuterHtml();
								} else {
									pageHtml = header + pageHtml + footer;
									var cBlock 	= new CBlock(pageHtml, compareHeight - Number(trHeight) + pageBaseHeight);
									cParagraph.cBlockList.push(cBlock);
									pageHtml 		= $(this).getOuterHtml();
									compareHeight 	= Number(trHeight);
								}
							});
							if(pageHtml != "") {
								pageHtml = header + pageHtml + footer;
								var cBlock 	= new CBlock(pageHtml, compareHeight + pageBaseHeight, pageCut);
								cParagraph.cBlockList.push(cBlock);
							}
							$(this).remove();
						} 
					});
				}
				cParagraph.makePageHtmlList();
				cReport.cParagraphList.push(cParagraph);
			});
		}
		,getTotalPageNum : function() {
			var cnt = 0;
			$.each(this.cParagraphList, function() {
				cnt += this.getTotalPageNum();
			});
			return cnt;
		}
		// Report를 구성한다.
		,makeReport : function(componentList, pageParm) {
			
			// Page를 분석하여 ParagraphList를 생성한다.
			// 생성된 ParagraphList는 cReport.cParagraphList에 담긴다.
			cReport.makeParagrapList(componentList);
			
			$("#reportAllDom").empty();
			
			// 표지 여부			
			if(pageParm.coverCheck == "true") {
				var reportCoverHtml = $("#reportCover_template").render();
				$("#reportAllDom").append(reportCoverHtml);
			}
			// Index 만들기
			var indexInfoList 	= [];
			var startPageNum	= 1;
			var idx = 1;
			$.each(cReport.cParagraphList, function() {
				var paragraph = this;
				var title = "";
				var index = "";
				if(isValid(paragraph.subTitle)) {
					title = "&nbsp;&nbsp;&nbsp; - " + paragraph.subTitle;
					index = ""
				} else {
					title = paragraph.title;
					index = idx + ". ";
					idx++;
				}
				var indexInfo = {
					 idx			: index
					,title 			: title
					,startPageNum	: startPageNum
				};
				indexInfoList.push(indexInfo);

				startPageNum += paragraph.getTotalPageNum();
			});
			var indexParm = {
				 logo : ""
				,indexInfoList : indexInfoList
			}
			
			
			// Index Page 여부
			if(pageParm.orderCheck == "true") {
				// Index Page 구성
				var reportIndexHtml = $("#reportIndex_template").render(indexParm);
				$("#reportAllDom").append(reportIndexHtml);
			}

			var totalPageNum = this.getTotalPageNum();
			
			// Page 설정
			var pageNum = 1;

			$.each(cReport.cParagraphList, function() {
				var paragraph = this;
				// 생성된 ParagraphList를 최종 Report를 구성한다.
				var pageTitle = paragraph.title;
				if(isValid(paragraph.subTitle)) pageTitle += "(" +  paragraph.subTitle + ")";
				var parm = {
					 criterionHeight 	: cReport.criterionHeight
					,pageTitle			: pageTitle
				}
				
				$.each(this.pageHtmlList, function() {
					var pageParm = {
						 totalPageNum 	: totalPageNum
						,pageNum		: pageNum++
					}
					// Header는 Paragraph 단위로 작성
					var reportPageHeader = $("#reportPageHeader_template").render(parm);
					// Footer는 Page 단위로 작성
					var reportPageFooter = $("#reportPageFooter_template").render(pageParm);

					var body = reportPageHeader + this + reportPageFooter;
					
					$("#reportAllDom").append(body);
				});
			});
		}
	}
	
	//CParagraph는 주제단위 또는 제목 단위이다.
	//Paragraph는 1개의 Page또는 1개이상의 Page로 구성되며
	//Paragraph의 마지막 Page는 여백이 존재하더라도 page를 넘기도록 한다.
	var CParagraph = function(title, subTitle) {
		this.title 				= title;
		this.subTitle 			= subTitle;
		this.cBlockList 		= [];
		this.pageHtmlList		= [];
		this.currentInsured		= "";
		this.makePageHtmlList 	= function() {
			var sumBlockHeight 	= 0;
			var sumPageHtml		= "";
			var pageHtmlList	= [];
			$.each(this.cBlockList, function() {
				var compareBlockHeight = sumBlockHeight + Number(this.height);
				var checkPagecut = this.pageCut;
				if(sumBlockHeight == 0) checkPagecut = "N";
				if(cReport.criterionHeight > compareBlockHeight && checkPagecut != "Y") {
					sumPageHtml 	+= this.html;
					sumBlockHeight	 = compareBlockHeight;
				} else {
					if(isValid(sumPageHtml)) pageHtmlList.push(sumPageHtml);
					sumPageHtml 	= this.html;
					sumBlockHeight 	= Number(this.height);
				}
			});
			if(this.cBlockList.length != 0) {
				pageHtmlList.push(sumPageHtml);
			}
			this.pageHtmlList = pageHtmlList;
		}
		this.getPageSize = function() {
			return this.pageHtmlList.length;
		}
		this.getTotalPageNum = function() {
			return this.pageHtmlList.length;
		}
	};
	
	
	// CBlock은 한번에 표시되는 단위이다. Block는 Page에 걸쳐서 표시되지 못하며 
	// Block의 일부가 다음페이지로 넘어갈 경우 Block 전체가 다음페이지에 표시된다.
	// Page를 임의로 구분할경우 다음과 같이 사용한다.
	// <div name=pageBlock pageCut=Y> xxxx </div>
	var CBlock = function(html, height, pageCut) {
		this.html 		= html;
		this.height 	= height;
		if(!isValid(pageCut)) pageCut = "N";
		// Page 강제 구분 
		this.pageCut 	= pageCut;
	};
	
</script>


<script type="text/x-jsrender" id="reportCover_template" >
	<div class="container">
		<div class="main_img">
			<div class="main_ci">
				<p>ADVISORY REPORT</p>
				<span>FINANCIAL STRATEGY & ANALYSIS</span>
			</div>
			<div class="main_tit">양은정님의 재무보고서</div>
		</div>
		<div class="main_info">
			<dl>
				<dt>재무설계사 <span class="main_info_name">위성열</span></dt>
				<dd><span>Tell</span> 070-8242-9976</dd>
				<dd><span>E-mail</span> jonsaram74@naver.com</dd>
				<dd><span>분석기준일</span> 2016년 12월 22일</dd>
			</dl>
		</div>
	</div>
	<div class="page"></div>
</script>

<script type="text/x-jsrender" id="reportIndex_template" >
	<div class="container">
		<div class="index_wrap">
		<div class="index_info">
			<ol>
				{{for indexInfoList}}
				<li><span class="page_name">{{:idx}} {{:title}}</span> <span class="page_no">{{:startPageNum}}</span></li>
				{{/for}}
			</ol>
		</div>
		<div class="index_bottom"><span class="index_ci"><img src="/explan/img/report/ci.png" height="34" border="0" alt=""></span></div>
		</div>
	</div>
	<div class="page"></div>
</script>



<script type="text/x-jsrender" id="reportPageHeader_template" >
  <div class="container">
     <div class="work_wrap">
	    <div class="work_tit"><span>{{:pageTitle}}</span></div>
	    <div class="work_space">
			<div style="width:100%;height:{{:criterionHeight}}px;margin-top:-15px">
</script>

<script type="text/x-jsrender" id="reportPageFooter_template" >
			</div>
		</div>
		<div class="work_foot">
		   <span class="work_ci"><img src="/explan/img/report/ci.png" height="28" border="0" alt=""></span>
		   <span class="work_tx">위성열 재무설계사 (Tel. 070-8242-9976)</span>
		   <span class="work_pg">{{:pageNum}} / {{:totalPageNum}}</span>
		</div>
	 </div>
  </div>
  <div class="page"></div>
</script>

<div id="reportAllDom" style="display:none">

<!-- UI 작성 부분 -->

<!-- 재무상태요약 Component  -->
<%@include file="/include/component/financy/financySummaryComponent.jsp"%>
<!----------------------------->

<!-- 재무상태표 Component  -->
<%@include file="/include/component/financy/financyAnalysisComponent.jsp"%>
<!----------------------------->

<!-- 현금흐름표 Component  -->
<%@include file="/include/component/financy/cashflowAnalysisComponent.jsp"%>
<!----------------------------->

<!-- 보험 기본 분석 Component  -->
<%@include  file="/include/component/insurance/insuranceBaseAnalysisComponent.jsp" %>
<!----------------------------->

<!-- 보험 담보 분석 Component  -->
<%@include  file="/include/component/insurance/insuranceDamboAnalysisComponent.jsp" %>
<!----------------------------->

<!-- 보험 기본 비교 Component  -->
<%@include  file="/include/component/insurance/insuranceCompareComponent.jsp" %>
<!----------------------------->

<!-- 보험 담보 비교 Component  -->
<%@include  file="/include/component/insurance/insuranceDamboBaseCompareComponent.jsp" %>
<!----------------------------->



</div>

<%@include  file="/include/footerBaseSet.jsp" %>
