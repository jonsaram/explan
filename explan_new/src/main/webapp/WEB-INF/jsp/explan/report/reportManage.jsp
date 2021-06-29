<%@ page contentType='text/html;charset=utf-8' errorPage="/vocm/common/VCommonErrorVW.jsp" %>

<%@include  file="/include/header.jsp" %>

<script type="text/javascript">
	
	_SVC_COM.loadJsFile("/explan/js/class/C_INSURANCE_GROUP.js");

	$(function() {
		// Component 초기화
		_SVC_COM.initComponent("customerInfoComponent", {}, function(type) {
			CReportCommon.arrangeInsuredList();
		});
		
		CReportCommon.arrangeInsuredList();
	});
	
	var CReportCommon = {
		// 피보험자 Arrange
		arrangeInsuredList : function() {
			var cInsuranceGroup = _SVC_INSURANCE.makeInsuranceGroup(_SESSION["PLAN_NUM"]);
			var insruredMap = cInsuranceGroup.getAllInsuredNameMap();
			var insuredList = [];
			$.each(insruredMap.list, function() {
				var obj = {"insuredName" : this};
				insuredList.push(obj);
			});
			$("#insuredList").html($("#insuredList_template").render({list : insuredList}));
			
		}
			
	}
	
	var CReportManage = {
		printReport : function() {
			
			var insuredList = [];
			$("#theForm input[name='insuredName']:checked").each(function() {
				insuredList.push(this.value);
			});
			var targetReportMap = {};
			$("#theForm input[isTarget]:checked").each(function() {
				var id = $(this).attr("id");
				targetReportMap[id] = "Y";
			});
			
			var damboGroupType = fn_getRadio("damboGroupType");
			
			var coverCheck = $("#reportCover").prop("checked") + "";
			var orderCheck = $("#reportOrder").prop("checked") + "";
			
			var parm = {
				 insuredNameList	: insuredList
				,damboGroupType 	: damboGroupType
				,coverCheck			: coverCheck 
				,orderCheck         : orderCheck
				,targetReportMap	: targetReportMap
			}
			windowOpenPage("REPORT_PRINT_PAGE", parm);
		}
	}
	
	
	
	
	
</script>
<!-- UI 작성 부분 -->
<form id="theForm">
	<h3>통합 보고서</h3>
	<%@include  file="/include/component/customerInfoComponent.jsp" %>
	<br/>
	<div>
		<h4>보고서 설정</h4>
		<div class="list_wrap">
			<div class="table_wrap">
				<table class="list_table">
					<colgroup>
						<col width="150">
						<col width="35%">
						<col width="150">
						<col width="35%">
					</colgroup>
					<tbody>
						<tr>
							<th>피보험자 선택</th>
							<td id="insuredList">
							</td>
							<script type="text/x-jsrender" id="insuredList_template">
								{{for list}}
									{{if #index > 0 }},{{/if}}
									<input type="checkbox" name="insuredName" class="checkboxpos" value="{{:insuredName}}" checked> {{:insuredName}}
								{{/for}}
							</script>
							<th>담보그룹 선택</th>
							<td>
								<input type="radio" name="damboGroupType" id="damboGroupType1" class="checkboxpos" value="REGISTED_DAMBO" checked	> 가입담보그룹<br/> 
								<input type="radio" name="damboGroupType" id="damboGroupType2" class="checkboxpos" value="BASE_DAMBO"				> 기본담보그룹<br/> 
								<input type="radio" name="damboGroupType" id="damboGroupType3" class="checkboxpos" value="ALL"				 		> 기본담보그룹+가입담보그룹 
							</td>
						</tr>
					</tbody>
				</table>
			</div>
		</div>	
		<h4>보고서 선택</h4>
		<div style="margin:5px">
			표지 : <input type="checkbox" id="reportCover" name="reportCover">&nbsp;&nbsp;&nbsp;&nbsp;
			차례 : <input type="checkbox" id="reportOrder" name="reportOrder">
		</div>
		<div class="list_wrap">
			<div class="table_wrap">
				<table class="list_table">
					<colgroup>
						<col width="40">
						<col width="30%">
						<col width="40">
						<col width="30%">
						<col width="40">
						<col width="30%">
					</colgroup>
					<thead>
						<tr>
							<th><input type="checkbox" id="#"></th>
							<th>재무 분석 보고서</th>
							<th><input type="checkbox" id="#"></th>
							<th>보험 분석 보고서</th>
							<th><input type="checkbox" id="#"></th>
							<th>재무 목표 분석 보고서</th>
						</tr>
					</thead>
					<tbody>
						<tr>
							<td class="tc"><input type="checkbox" id="financySummaryComponent" isTarget/></td>
							<td >재무 상태 요약</td>
							<td class="tc"><input type="checkbox" id="insuranceBaseAnalysisComponent" isTarget/></td>
							<td >보험 기본 분석</td>
							<td class="tc"><input type="checkbox" id="#"></td>
							<td >재무 목표 분석</td>
						</tr>
						<tr>
							<td class="tc"><input type="checkbox" id="financyAnalysisComponent" isTarget/></td>
							<td >재무 상태표</td>
							<td class="tc"><input type="checkbox" id="insuranceDamboAnalysisComponent" isTarget/></td>
							<td >보험 담보 분석</td>
							<td class="tc">&nbsp;</td>
							<td >&nbsp;</td>
						</tr>
						<tr>
							<td class="tc"><input type="checkbox" id="cashflowAnalysisComponent" isTarget/></td>
							<td >현금 흐름표</td>
							<td class="tc"><input type="checkbox" id="insuranceCompareComponent" isTarget/></td>
							<td >보험 기본 비교</td>
							<td class="tc">&nbsp;</td>
							<td >&nbsp;</td>
						</tr>
						<tr>
							<td class="tc">&nbsp;</td>
							<td >&nbsp;</td>
							<td class="tc"><input type="checkbox" id="insuranceDamboBaseCompareComponent" isTarget/></td>
							<td >보험 담보 비교</td>
							<td class="tc">&nbsp;</td>
							<td >&nbsp;</td>
						</tr>
					</tbody>
				</table>
			</div>
		</div>	
	</div>
	<div class="page_button"><span class="btn_page"><a href="javascript:CReportManage.printReport()">보고서 출력</a></span></div>
</form>	
<%@include  file="/include/footer.jsp" %>
