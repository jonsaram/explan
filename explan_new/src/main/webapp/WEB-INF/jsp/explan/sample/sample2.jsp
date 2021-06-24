<%@ page contentType='text/html;charset=utf-8' errorPage="/vocm/common/VCommonErrorVW.jsp" %>

<%@include  file="/include/header.jsp" %>

<script>
	// 스크립트 작성 부분
	$(function() {
		// 서비스 1개만 요청
		var gridInfo = requestService("GET_LIST_SAMPLE", {"abc" : 111});
		dalert(gridInfo);
	});
</script>
<!-- UI 작성 부분 -->

템플릿 입니다.

<%@include  file="/include/footer.jsp" %>
