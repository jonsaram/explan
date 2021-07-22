<%@ page contentType='text/html;charset=utf-8' errorPage="/vocm/common/VCommonErrorVW.jsp" %>

<%@include  file="/include/header.jsp" %>

<script>
	
	$(function() {
		// 고객 정보 Component 초기화
		_SVC_COM.initComponent("customerInfoComponent", {}, function(type) {
			if(type == "reload") loadComponent();
		});
	});
	function loadComponent() {
		if(!isValid(_SESSION["BASE_PLAN_NUM"])) {
			alert('Plan Type이 제안인경우에만 보험 비교가 가능합니다.');
			return;
		}

		var cInsuranceGroup 		= _SVC_INSURANCE.makeInsuranceGroup(_SESSION["PLAN_NUM"]);

		var cInsuranceGroupBase 	= _SVC_INSURANCE.makeInsuranceGroup(_SESSION["BASE_PLAN_NUM"], cInsuranceGroup);

		var sendParm				= {cInsuranceGroup : cInsuranceGroup, cInsuranceGroupBase : cInsuranceGroupBase};
		
		// 보험 기본 분석 Component 초기화
		_SVC_COM.initComponent("insuranceCompareComponent"			, sendParm, function() {});
		
		// 보험 기본 분석 Component 초기화
		_SVC_COM.initComponent("insuranceDamboBaseCompareComponent"	, sendParm, function() {});
		
		// 피보험자 선택 Component 초기화
		var parm = {
			"cInsuranceGroup" 			: cInsuranceGroup,
			"cInsuranceGroupBase" 		: cInsuranceGroupBase,
			"onChangeCallBackFn"		: function(insuredInfo, damboGroupType) {
				_G_FN["insuranceDamboBaseCompareComponent"].loadDambo(_G_VAL["insuredInfo"]);
			}	
		}
		_SVC_COM.initComponent("selectInsuredComponent", parm, function() {});
	}
	_G_VAL["tabIdx"] = 1;
	function goTab(idx) {
		_G_VAL["tabIdx"] = idx;
	}
	
</script>
<!-- UI 작성 부분 -->

	<h3>보험 비교 분석</h3>

	<!-- 고객 리스트(선택) -->
	<%@include  file="/include/component/customerInfoComponent.jsp" %>

	<!-- tab -->
	<div class="tab">
		<ul>
			<li class="first on"><a href="javascript:goTab(1)"	>보험 기본 비교	</a></li>
			<li><a href="javascript:goTab(2)"					>보험 담보 비교	</a></li>
		</ul>
	</div>
	<!-- //tab -->
	<div id="tab1" class="tab_cont">
		
		<!-- 보험 기본 비교 Component  -->
		<%@include  file="/include/component/insurance/insuranceCompareComponent.jsp" %>
		
	</div>
	<!-- 담보 기본 비교 -->
	<div id="tab2" class="tab_cont" style="display:none">

		<!-- 피보험자 선택 Component  -->
		<%@include  file="/include/component/insurance/selectInsuredComponent.jsp" %>
		<!----------------------------->

		<!-- 보험 기간별비교 Component  -->
		<%@include  file="/include/component/insurance/insuranceDamboBaseCompareComponent.jsp" %>
	</div>

<%@include  file="/include/footer.jsp" %>