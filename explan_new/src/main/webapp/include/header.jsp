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
<script type="text/javascript"							src="${ctx}/js/common/function_ajax.js"			></script>
<script type="text/javascript"							src="${ctx}/js/common/function_common.js"		></script>
<script type="text/javascript"							src="${ctx}/js/common/project_common.js"		></script>
<script type="text/javascript"							src="${ctx}/js/common/service.js"				></script>
<script type="text/javascript"							src="${ctx}/js/common/word.js"					></script>

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
<body>
<c:set var="pageId" value="${pageId}"/>
<c:set var="loginId" value="${loginId}"/>
<script type="text/javascript">
	var PAGE_ID = '${pageId}';
	// 세션 읽기
	_SESSION = loadSessionData("_SESSION");
	if(!isValid(_SESSION,1)) _SESSION = {};
	$(function() {
		if(PAGE_ID == "") PAGE_ID = "CUSTOMER_LIST";
		// 공통 설정
		var resultInfo = requestService("GET_MENU_LIST", {}, "R");
		var mainMenuMap 		= {};
		var currentMainMenu 	= "";
		$.each(resultInfo.data, function() {
			if(mainMenuMap[this.MAIN_MENU_ID] == undefined) {
				mainMenuMap[this.MAIN_MENU_ID] = {};
				mainMenuMap[this.MAIN_MENU_ID].subMenuList = [];
			}
			mainMenuMap[this.MAIN_MENU_ID].MAIN_MENU_NAME = this.MAIN_MENU_NAME;
			mainMenuMap[this.MAIN_MENU_ID].subMenuList.push(this);
			
			if(this.PAGE_ID == PAGE_ID) {
				mainMenuMap[this.MAIN_MENU_ID].cls = "class=ing";
				currentMainMenu = this.MAIN_MENU_ID;
				this.cls=" current";
			}
		});
		
		var mainMenuList = [];
		
		$.each(mainMenuMap, function(key, obj) {
			obj.PAGE_ID = obj.subMenuList[0].PAGE_ID;
			mainMenuList.push(obj);
		});
		var htmlStr = $("#commonTopMenu_template").render({list : mainMenuList});
		$("#commonTopMenu").html(htmlStr);

		htmlStr = $("#LNB_template").render(mainMenuMap[currentMainMenu]);
		$("#LNB").html(htmlStr);
	});
	
	function openConfig() {
		_SVC_POPUP.setConfig("configPopup", {}, function(returnData) {
		});
		_SVC_POPUP.show("configPopup");
		
	}
</script>
<div id="wrap">
	<!-- gnb -->
	<header id="gnb">
		<h1><a href="#">EXPLAN</a></h1>
		<!-- dropdown_menu -->
		<div class="vertical">
			<ul class="dropdown" id="commonTopMenu">
			</ul>
			<script type="text/x-jsrender" id="commonTopMenu_template" >
				{{for list}}
				<li {{:cls}}>
					<a href="javascript:movePage('{{:PAGE_ID}}', {})" {{:cls}}>{{:MAIN_MENU_NAME}}</a>
					<ul>
						{{for subMenuList}}
						<li><a href="javascript:movePage('{{:PAGE_ID}}', {})">{{:SUB_MENU_NAME}}</a></li>
						{{/for}}
					</ul>
				</li>
				{{/for}}
				<li>
					<a href="javascript:openConfig();">설정</a>
				</li>
			</script>
		</div>
		<!-- //dropdown_menu -->
		<!-- function -->
		<div class="function">
			<a href="/explan/mainFrame.do">HOME</a> | <a href="#">OFF</a>
		</div>
		<!-- //function -->
		<div class="logInfo">
			홍길동 <span class="line">|</span> 사용만료일 : 2016-05-05
		</div>
	</header>
	<!-- //gnb -->
	<!-- container -->
	<div id="container">
		<!-- side_control -->
		<div class="snb_collapsed">
			<div class="nav_col" style="display:block"><a href="#">Hide Side</a></div>
			<div class="nav_exp"><a href="#">Show Side</a></div>
		</div>
		<!-- //side_control -->
		<!-- side -->
		<div id="LNB">
		</div>
		<script type="text/x-jsrender" id="LNB_template" >
			<h2>{{:MAIN_MENU_NAME}}</h2>
			<ul class="lnbTree">
				{{for subMenuList}}
				<li><a href="javascript:movePage('{{:PAGE_ID}}', {})" class="head{{:cls}}">{{:SUB_MENU_NAME}}</a></li>
				{{/for}}
			</ul>
		</script>
		<!-- //side -->
		<!-- contents -->
		<div id="contents">
