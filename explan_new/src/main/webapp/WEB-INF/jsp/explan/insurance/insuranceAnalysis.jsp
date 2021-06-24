<%@ page language="java" errorPage="/explan/common/error.jsp" pageEncoding="UTF-8" contentType="text/html;charset=utf-8" %>

<%@include  file="/include/header.jsp" %>

<script type="text/javascript">
	
	_SVC_COM.loadJsFile("/explan/js/class/C_INSURANCE_GROUP.js");

	$(function() {
		// 고객 정보 Component 초기화
		_SVC_COM.initComponent("customerInfoComponent", {}, function(type) {
			if(type == "reload") loadComponent();
		});
	});
	
	function loadComponent() {
		// planNum에 해당하는 모든 보험Group정보
		var cInsuranceGroup = _SVC_INSURANCE.makeInsuranceGroup(_SESSION["PLAN_NUM"]);

		//
		// Component 초기화
		// 
		
		// 보험 기본 분석 Component 초기화
		_SVC_COM.initComponent("insuranceBaseAnalysisComponent", {"cInsuranceGroup" : cInsuranceGroup}, function() {});
		
		// 보험 담보 분석 Component 초기화
		_SVC_COM.initComponent("insuranceDamboAnalysisComponent", {"cInsuranceGroup" : cInsuranceGroup}, function() {});
		
		// 피보험자 선택 Component 초기화
		var parm = {
			"cInsuranceGroup" 			: cInsuranceGroup,
			"onChangeCallBackFn"		: function(insuredInfo, damboGroupType) {
				if(_G_VAL["tabIdx"] == 1) $("#tab2").show();
				_G_FN["insuranceDamboAnalysisComponent"].loadDambo(_G_VAL["insuredInfo"]);
				setTimeout(function() {
					if(_G_VAL["tabIdx"] == 1) $("#tab2").hide();	
				}, 500);
			}	
		}
		_SVC_COM.initComponent("selectInsuredComponent", parm, function() {});
		
	}
	_G_VAL["tabIdx"] = 1;
	function goTab(idx) {
		_G_VAL["tabIdx"] = idx;
	}
</script>

	<h3>보험 분석</h3>
	
	<%@include  file="/include/component/customerInfoComponent.jsp" %>
	
	<!-- tab -->
	<div class="tab">
		<ul>
			<li class="first on"><a href="javascript:goTab(1)">보험 기본 분석</a></li>
			<li><a href="javascript:goTab(2)">보험 담보 분석</a></li>
		</ul>
	</div>
	<!-- //tab -->
	<div id="tab1" class="tab_cont">
		
		<!-- 보험 기본 분석 Component  -->
		<%@include  file="/include/component/insurance/insuranceBaseAnalysisComponent.jsp" %>
		<!----------------------------->
		
	</div>
	
	<!-- 보험 담보 분석 -->
	<div id="tab2" class="tab_cont" style="display:none">
	
		<!-- 피보험자 선택 Component  -->
		<%@include  file="/include/component/insurance/selectInsuredComponent.jsp" %>
		<!----------------------------->
		
		
		<!-- 보험 담보 분석 Component  -->
		<%@include  file="/include/component/insurance/insuranceDamboAnalysisComponent.jsp" %>
		<!----------------------------->

	</div>

<%@include  file="/include/footer.jsp" %>
