<%@ page contentType='text/html;charset=utf-8' errorPage="/vocm/common/VCommonErrorVW.jsp" %>

<%@include  file="/modelo/include/header.jsp" %>

<script type="text/javascript">
	$(function() {
		var jsonData = {
			"pnt"	: "parent",
			"list" : [
		      	{"TA" : "AA1","TB" : "BB1","TC" : "CC1"},
		    	{"TA" : "AA2","TB" : "BB2","TC" : "CC2"},
		    	{"TA" : "AA3","TB" : "BB3","TC" : "CC3"},
		    	{"TA" : "AA4","TB" : "BB4","TC" : "CC4"},
		    	{"TA" : "AA5","TB" : "BB5","TC" : "CC5"}
			] 	
		};
		
		var renderResult = $("#jsTest_template").render(jsonData);
		
		$("#jsTest").html(renderResult);
		
	});
	
	
	
	
</script>

<h3>jsrender test</h3>

<div class="list_wrap">
	<div class="list_head">
		<div class="button">
			<span class="btn_list"><a href="#">Attach</a></span>
			<span class="btn_list"><a href="#">Delete</a></span>
		</div>
		<span class="totalCount">[Size: 5,000KB/10M]</span>
	</div>
	<div class="grid_wrap">


		<!-- Data List -->
		<div id="jsTest"></div>
		<!-- Data List -->


	</div>
</div>
				

<script type="text/x-jsrender" id="jsTest_template">
	<table class="list_table">
		<colgroup>
			<col width="100">
			<col width="100">
			<col width="100">
		</colgroup>
		<thead>
			<tr>
				<th>TA{{:pnt}}</th>
				<th>TB</th>
				<th>TC</th>
			</tr>
		</thead>
		<tbody>

		{{if list && list.length}}
			{{for list ~pnt=pnt}}

			<tr>
				<td>{{>~pnt}} - {{:TA}}</td>
				<td class="tr">{{:TB}}</td>
				<td class="tc">{{:TC}}</td>
			</tr>


			{{/for}}
		{{/if}}


		</tbody>
	</table>
</script>

<%@include  file="/modelo/include/footer.jsp" %>
