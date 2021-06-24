<%@ page contentType='text/html;charset=utf-8' errorPage="/vocm/common/VCommonErrorVW.jsp" %>

<%@include  file="/modelo/include/header.jsp" %>
<table width="100%">
	<tr>
		<td width="500px" valign="top">
			<div id="gridbox" style="width: 500px; height:270px; background-color:white;overflow:hidden"></div>
		</td>
	</tr>
</table>
<br>
<script>

// 두번째 그리드 설정

	var jsonData = [
	  	{"TA" : "AA1","TB" : "BB1","TC" : "1"},
	  	{"TA" : "AA2","TB" : "BB2","TC" : "CC2"},
	  	{"TA" : "AA2","TB" : "BB2","TC" : "CC2"},
	  	{"TA" : "AA2","TB" : "BB2","TC" : "CC2"},
	  	{"TA" : "AA2","TB" : "BB2","TC" : "CC2"}
	];
	var orderList = "TA,TB,TC";

	mygrid = new dhtmlXGridObject('gridbox');
	mygrid.setImagePath("/js/modelo/dhtmlx/codebase/imgs/");
	mygrid.setHeader("Sales,Book,Title");
	mygrid.setInitWidths("50,150,120")
	mygrid.setColAlign("right,left,left")
	mygrid.setColTypes("ed,ed,ro");
	mygrid.enableAlterCss("even", "uneven");
	mygrid.init();

	var dataConfig = {
		"columnData" 	: orderList,
		"jsonArray" 	: jsonData
	}
	var result = explanGrid.jsonToGridArray(dataConfig);
/*	
 	var result {
		  "rows": [
		    {
		      "id": 1,
		      "data": [
		        "AA1",
		        "BB1",
		        "1"
		      ]
		    },
		    {
		      "id": 2,
		      "data": [
		        "AA2",
		        "BB2",
		        "CC2"
		      ]
		    },
		    {
		      "id": 3,
		      "data": [
		        "AA2",
		        "BB2",
		        "CC2"
		      ]
		    },
		    {
		      "id": 4,
		      "data": [
		        "AA2",
		        "BB2",
		        "CC2"
		      ]
		    },
		    {
		      "id": 5,
		      "data": [
		        "AA2",
		        "BB2",
		        "CC2"
		      ]
		    }
		  ]
		}
 */	
	mygrid.parse(result, "json");

	mygrid.setSkin("dhx_skyblue")

	</script>
	
	
<%@include  file="/modelo/include/footer.jsp" %>
