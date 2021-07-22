<%@ page language="java" errorPage="/explan/common/error.jsp" pageEncoding="UTF-8" contentType="text/html;charset=utf-8" %>

<%@include  file="/include/header.jsp" %>

<!-- 
	<h3>Title</h3>

	Sample List<br/><br/>

	<table width="100%" border="1">
		<tr>
			<td width="25%"><a
				href="javascript:movePage('SAMPLE', {}, '_blank')">sample</a><br />
				<br /> <a href="javascript:movePage('SAMPLE_LIST', {}, '_blank')">sample2</a><br />
				<br /> <a
					href="javascript:movePage('SAMPLE_MULTIHEADER', {}, '_blank')">Multi
						Header</a><br />
				<br /> <a href="javascript:movePage('SAMPLE_TREEGRID', {}, '_blank')">sample
						treegrid</a><br />
				<br /> <a href="javascript:movePage('FILEUPLOAD', {}, '_blank')">File
						Upload</a><br />
				<br /> <a
					href="/servlet/modelo.common.servlet.MainServlet?pageId=FILEDOWNLOAD&docurl=201411261056444031">File
						download</a><br />
				<br /> <a href="javascript:movePage('SELECTBOX', {}, '_blank')">selectbox</a><br />
				<br /> <a href="javascript:movePage('JSRENDER', {}, '_blank')">jsrender
						test</a><br />
				<br />
			</td>
			<td width="25%">
				<a href="javascript:movePage('CUSTOMER_LIST', {}, '_blank')">Customer List</a><br /><br />
				<a href="javascript:movePage('INVESTMENT_MANAGE', {}, '_blank')">Investment Manage</a><br /><br />
				<a href="javascript:movePage('INSURANCE_MANAGE', {}, '_blank')">Insurance Manage</a><br /><br />
				<a href="javascript:movePage('INSURANCE_ANALYSIS', {}, '_blank')">Insurance Analisys</a><br /><br />
				<a href="javascript:movePage('REPORT_MANAGE', {}, '_blank')">Report Manage</a><br /><br />
			</td width="25%">
			<td width="25%">
				<a href="javascript:movePage('NORMAL_TEMPLATE', {}, '_blank')">normal template</a><br /><br />
				<a href="javascript:movePage('TAB_TEMPLATE', {}, '_blank')">tab template</a><br /><br />
				<a href="javascript:movePage('BLANK_TEMPLATE', {}, '_blank')">blank template</a>
			</td>
			<td width="25%">&nbsp;</td>
		</tr>
	</table>
	<br/><br/>
	DHTMLX 관련<br/><br/>
	<a href="javascript:movePage('SAMPLE_DHTMLX', {}, '_blank')" 	>기본 DHTMLX</a><br/><br/>
 -->			
 	<script>
 		$(function() {
 	 		movePage('CUSTOMER_LIST', {});
 		});
 	</script>

<%@include  file="/include/footer.jsp" %>