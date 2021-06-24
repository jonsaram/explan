<%@ page contentType='text/html;charset=utf-8' errorPage="/vocm/common/VCommonErrorVW.jsp" %>

<%@include  file="/include/header.jsp" %>

<script type="text/javascript">

	$(function() {
		loadData();
	});

	function loadData() {
		
		// 그리드 설정
//		var jsonData = [];
		var jsonData = [
   	    	{"TA" : "AA1","TB" : "BB1","TC" : "CC1", "TD" : "DD1"},
   	    	{"TA" : "AA2","TB" : "BB2","TC" : "CC2", "TD" : "DD1"},
   	    	{"TA" : "AA2","TB" : "BB2","TC" : "CC2", "TD" : "DD1"},
   	    	{"TA" : "AA2","TB" : "BB2","TC" : "CC2", "TD" : "DD1"},
   	    	{"TA" : "AA2","TB" : "BB2","TC" : "CC2", "TD" : "DD1"}
   		];
		
  		var orderList = "TA,TB,TC,TD,TE,TF,TG";
  		
 		var columnConfig = {
			"TE" 		: {"colType":"ch","width":80},
			"TF" 		: {"colType":"ch","width":80},
			"TG" 		: {"colType":"ch","width":80}
		};

 		var gridParm = {
			"targetDivId"	: "gridbox",
			"orderList" 	: orderList,
			"gridData"		: jsonData,
			"cellConfig"	: {
				"defaultConfig" : {
					"width" 		: 150,
					"colType"		: "ed"
				},
				"columnConfig" 	: columnConfig
			},
			"callback" : function(mygrid) {
		  		mygrid.setRowspan("1", 1, 1);
			}
		}
		var mygrid = explanGrid.makeGrid(gridParm);

	}
	
</script>
<!-- //list -->
<div class="list_wrap">
	<!-- list_table -->
	<div id="gridbox" style="width:1000px;height:500px"></div>
</div>

<%@include  file="/include/footer.jsp" %>
