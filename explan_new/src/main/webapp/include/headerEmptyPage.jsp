<%@ page contentType='text/html;charset=utf-8'%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://www.anyframejava.org/tags" prefix="anyframe" %>

<c:set var="ctx" value="${pageContext.request.contextPath}"/>

<!DOCTYPE html>
<html>
<head>

<meta charset="utf-8" />
<meta http-equiv="X-UA-Compatible" content="IE=Edge">
<title>explan</title>
<link rel="stylesheet" 									href="${ctx}/css/style.css" 					/>
<link rel="stylesheet" type="text/css" media="screen" 	href="${ctx}/css/jquery-ui-1.10.1.custom.css" 	/>
<link rel="stylesheet" type="text/css" 					href="${ctx}/js/dhtmlx/codebase/dhtmlx.css" 	/>
<script type="text/javascript" 							src="${ctx}/js/jquery-1.9.0.min.js"            	></script>
<script type="text/javascript" 							src="${ctx}/js/jquery-ui-1.10.1.custom.min.js"	></script>
<script type="text/javascript" 							src="${ctx}/js/json2.js"						></script>
<script type="text/javascript"							src="${ctx}/js/dhtmlx/codebase/dhtmlx.js"		></script>
<script type="text/javascript"							src="${ctx}/js/jsrender.js"						></script>
<script type="text/javascript"							src="${ctx}/js/dhtmlxlib.js"					></script>
<script type="text/javascript"							src="${ctx}/js/style.js"						></script>

<script type="text/javascript"							src="${ctx}/js/common/config.js"				></script>
<script type="text/javascript"							src="${ctx}/js/common/word.js"					></script>
<script type="text/javascript"							src="${ctx}/js/common/function_ajax.js"			></script>
<script type="text/javascript"							src="${ctx}/js/common/function_common.js"		></script>
<script type="text/javascript"							src="${ctx}/js/common/project_common.js"		></script>
<script type="text/javascript"							src="${ctx}/js/common/service.js"				></script>

<%-- amChart 중복Include 방지--%>
<script type="text/javascript"							src="/explan/amcharts/amcharts.js"				></script>
<script type="text/javascript"							src="/explan/amcharts/radar.js"				></script>

<c:set var="ctx" value="${pageContext.request.contextPath}"/>


<style>
	.dhtmlxGrid_selection {
		-moz-opacity: 0.5;
		filter: alpha(opacity = 50);
		background-color:#83abeb;
		opacity:0.5;
	}
</style>

</head>
<body class="emptyPage">
<c:set var="pageId" value="${pageId}"/>
<c:set var="loginId" value="${loginId}"/>
<script type="text/javascript">
	var PAGE_ID = '${pageId}';
	// 세션 읽기
	_SESSION = loadSessionData("_SESSION");
	if(!isValid(_SESSION,1)) _SESSION = {};
	$(function() {
		if(PAGE_ID == "") PAGE_ID = "CUSTOMER_LIST";
	});
</script>
<div id="wrap">
	<!-- container -->
	<div id="container">
		<!-- contents -->
		<div id="contents">
