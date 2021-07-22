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
			$("body").hide();
			alert('고객을 선택 해주세요.');
			$("body").show();
			history.back();
		}
		// 자산 기본 분석 Component 초기화
		_SVC_COM.initComponent("financyAnalysisComponent", parm,function() {});

	}
</script>
<!-- UI 작성 부분 -->

<h3>재무상태표</h3>

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
	<!-- 자산 기본 분석 Component  -->
	<%@include file="/include/component/financy/financyAnalysisComponent.jsp"%>
	<!----------------------------->
</div>

<%@include file="/include/footer.jsp"%>
