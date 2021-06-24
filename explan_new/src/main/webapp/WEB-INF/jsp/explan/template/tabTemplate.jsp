<%@ page language="java" errorPage="/explan/common/error.jsp" pageEncoding="UTF-8" contentType="text/html;charset=utf-8" %>

<%@include  file="/include/header.jsp" %>

<script>
	$(function() {
		// 서비스 요청
		var resultInfo = requestService("GET_COMMON", {"sqlId" : "Customer.getCustomerList"});
		dalert(resultInfo);
	});
	
</script>

	<h3>Main Title</h3>
	
	<!-- tab -->
	<div class="tab">
		<ul>
			<li class="first on"><a href="#">Specification</a></li>
			<li><a href="#">Related Project</a></li>
		</ul>
	</div>
	<!-- //tab -->

	<div class="tab_cont">
		<h4>Tab 1</h4>
		<div class="form_wrap">
			<table class="list_table">
				<colgroup>
					<col width="40">
					<col width="130">
					<col width="130">
					<col>
				</colgroup>
				<thead>
					<tr>
						<th>No.</th>
						<th>Step</th>
						<th>Role</th>
						<th>Name</th>
					</tr>
				</thead>
				<tbody>
					<tr>
						<td class="tc">2</td>
						<td>Review 1</td>
						<td>MKT PM</td>
						<td>&nbsp;</td>
					</tr>
					<tr>
						<td class="tc">2</td>
						<td>Review 1</td>
						<td>MKT PM</td>
						<td>&nbsp;</td>
					</tr>
				</tbody>
			</table>

	</div>
	</div>

	<div id="#" class="tab_cont" style="display:none">
		<h4>Tab2</h4>
		<div class="form_wrap">
		</div>
		
		<h4>Tab2 Sub</h4>
		<div class="list_wrap" style="width:100%;height:300px">
		</div>
	</div>


<%@include  file="/include/footer.jsp" %>
