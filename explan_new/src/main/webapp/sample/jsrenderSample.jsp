<%@ page language="java" errorPage="/sample/common/error.jsp" pageEncoding="UTF-8" contentType="text/html;charset=utf-8" %>
<%@include  file="/include/headerBaseSet.jsp" %>

<script>
	$(function() {
		var parm = {
			"lineupList": [{
				"planApprovalDate": "11",
				"launchApprovalDate": "22",
				"targetMarket0": "33",
				"targetMarket1": "44",
				"targetMarket2": "55",
				"targetMarket3": "66",
				"targetMarket4": "77",
				"targetMarket5": "88",
				"targetMarket6": "99",
				"confirmDateChange": ""
			}, 
			{
				"planApprovalDate": "111",
				"launchApprovalDate": "222",
				"targetMarket0": "333",
				"targetMarket1": "444",
				"targetMarket2": "555",
				"targetMarket3": "666",
				"targetMarket4": "777",
				"targetMarket5": "888",
				"targetMarket6": "999",
			}],
			"ddList": [{
				"ddCode": "MAS_TARGET_MARKET",
				"ddValue": "SS",
				"nameKo": "대내",
				"nameEn": "Samsung",
				"nameZh": "Samsung",
				"sortOrder": 1,
				"name": "대내"
			}, 
			{
				"ddCode": "MAS_TARGET_MARKET",
				"ddValue": "KR",
				"nameKo": "한국",
				"nameEn": "Korea",
				"nameZh": "Korea",
				"sortOrder": 2,
				"name": "한국"
			}, 
			{
				"ddCode": "MAS_TARGET_MARKET",
				"ddValue": "US",
				"nameKo": "미주",
				"nameEn": "America",
				"nameZh": "America",
				"sortOrder": 3,
				"name": "미주"
			}, 
			{
				"ddCode": "MAS_TARGET_MARKET",
				"ddValue": "EU",
				"nameKo": "구주",
				"nameEn": "Europe",
				"nameZh": "Europe",
				"sortOrder": 4,
				"name": "구주"
			}, 
			{
				"ddCode": "MAS_TARGET_MARKET",
				"ddValue": "EMEA",
				"nameKo": "EMEA",
				"nameEn": "EMEA",
				"nameZh": "EMEA",
				"sortOrder": 5,
				"name": "EMEA"
			}, 
			{
				"ddCode": "MAS_TARGET_MARKET",
				"ddValue": "CH",
				"nameKo": "중국",
				"nameEn": "China",
				"nameZh": "China",
				"sortOrder": 6,
				"name": "중국"
			}, 
			{
				"ddCode": "MAS_TARGET_MARKET",
				"ddValue": "AP",
				"nameKo": "AP",
				"nameEn": "Asia/Pacific",
				"nameZh": "Asia/Pacific",
				"sortOrder": 7,
				"name": "AP"
			}]
		}
		var htmlStr = $("#resultTableBody_template").render(parm);
		$("#resultTableBody").html(htmlStr);
		
	});
</script>
<table style="border:1px solid #9bbad7;">
	<tbody id="resultTableBody">
	</tbody>
	<script type="text/x-jsrender" id="resultTableBody_template">
		{{for lineupList ~ddList=ddList ~lineupList=lineupList}}
		<tr>
			<td class="tC text_ellipsis">{{:planApprovalDate}}								</td>
			<td class="tC text_ellipsis">{{:launchApprovalDate}}							</td>
			{{for ~ddList ~lineupList=~lineupList ~index=#index}}
				<td class="tC text_ellipsis">
				{{:nameKo}}/{{:~lineupList[~index]["targetMarket" + (sortOrder-1)]}}
				</td>
			{{/for}}
		</tr>
		{{/for}}	
	</script>
</table>
		
<%@include  file="/include/headerBaseSet.jsp" %>
