<%@ page contentType='text/html;charset=utf-8'
	errorPage="/vocm/common/VCommonErrorVW.jsp"%>

<%@include file="/include/header.jsp"%>

<script>
	$(function() {

	});

	function loadComponent() {

		// Investment List 읽어오기
		var parm = {
			 "planNum" 	: _SESSION["PLAN_NUM"]
			,"planDate" : _SESSION["PLAN_DATE"]
		}
		if(isEmpty(parm.planNum)) {
			alert('플랜을 선택하세요');
			history.back();
		}

		// 현금흐름표 Component 초기화
		_SVC_COM.initComponent("cashflowAnalysisComponent", parm,function() {});

	}
</script>
<!-- UI 작성 부분 -->

<h3>현금흐름표</h3>

<%@include  file="/include/component/customerInfoComponent.jsp" %>

<script>
	$(function() {
		// Component 초기화
		_SVC_COM.initComponent("customerInfoComponent", {}, function(type) {
			if(type == "reload") loadComponent();
		});
	
	});
</script>

<div>
	<!-- 현금 흐름 분석 Component  -->
	<%@include file="/include/component/financy/cashflowAnalysisComponent.jsp"%>
	<!----------------------------->
</div>

<%@include file="/include/footer.jsp"%>
