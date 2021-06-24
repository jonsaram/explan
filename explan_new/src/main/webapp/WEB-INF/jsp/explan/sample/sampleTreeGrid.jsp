<%@ page contentType='text/html;charset=utf-8' errorPage="/vocm/common/VCommonErrorVW.jsp" %>

<%@include  file="/modelo/include/header.jsp" %>

<script>
	$(function() {
		loadData();
	});
	function loadData() {
	// 스크립트 작성 부분
		var jsonData = [
		      	    	{"TA" : "AA1","TB" : "BB1","TC" : "CC1"},
		      	    	{"TA" : "AA2","TB" : "BB2","TC" : "CC2"},
		      	    	{"TA" : "AA3","TB" : "BB3","TC" : "CC3"},
		      	    	{"TA" : "AA4","TB" : "BB4","TC" : "CC4"}
		      		];
		
  		var orderList = "TA,TB,TC";
  		
  		// Validation 처리
		var gridParm = {
			"targetDivId"	: "gridbox",
			"orderList" 	: orderList	,
			"gridData"		: jsonData	,
			"cellConfig"	: {
				"defaultConfig" : {
					"width" 		: 200,
					"colType"		: "ed"
				},
				"columnConfig" 	: {
					"TA" 		: {
						"width" 		: 100,	
						"align" 		: "center",
						"colType"		: "tree"
					}
				}
			}
		}
		var mygrid = explanGrid.makeGrid(gridParm);
  		
		mygrid.enableTreeCellEdit(false);
  		
	}
	function addChild() {
		
		var parm = {
			gridId		: "gridbox" , 
			rowIdx      : 0         ,
			isChild 	: "1"			
		}
		
		explanGrid.treeGridAddRow(parm);
	}
	
	function getTreeRow() {
		var dataList = explanGrid.getTreeGridToJson("gridbox");
		dwrite(dataList);
	}
	
</script>
<!-- UI 작성 부분 -->

<!-- list -->
<div class="list_wrap">
	<!-- list_table -->
	1:<div id="gridbox" style="width:1000px;height:500px"></div>
</div>
<div>
	<a href="javascript:addChild()">Add Child</a> &nbsp;&nbsp;&nbsp;
	<a href="javascript:getTreeRow()">getTreeRow</a>
</div>
<%@include  file="/modelo/include/footer.jsp" %>
