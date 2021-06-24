<%@ page language="java" errorPage="/explan/common/error.jsp" pageEncoding="UTF-8" contentType="text/html;charset=utf-8" %>

<%@include  file="/include/header.jsp" %>

<script>
	$(function() {
		// 서비스 요청
		var resultInfo = requestService("GET_COMMON", {"sqlId" : "Customer.getCustomerList"});
		dalert(resultInfo);
	});
	
</script>
<!-- UI 작성 부분 -->

빈 템플릿 입니다.

<%@include  file="/include/footer.jsp" %>
