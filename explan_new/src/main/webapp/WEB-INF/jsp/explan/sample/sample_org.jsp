<%@ page contentType='text/html;charset=utf-8' errorPage="/vocm/common/VCommonErrorVW.jsp" %>

<%@include  file="/include/header.jsp" %>

<script type="text/javascript">
	var _HEADER_TITLE_MAP = {
		"ROW_NUM"				: ""							,
		"APPROVAL_TYPE_DESC"    : "Approval Type"				,
		"MVT_CODE"              : "MVT / Model / Review Code"	,
		"APPROVAL_STATUS_DESC"  : "Approval Status"				,
		"PROPOSER_DESC"         : "Proposed By"					,
		"CREATE_DATETIME"       : "Created On"
	};

	$(function() {
		loadData();
		var a =getPageParam();
	});

	function loadData() {
		/**
		 * 서비스 2가지 이상을 동시 요청하는 경우
		 */
		// 서비스 요청 정보 생성
/* 		var requestParm = makeRequestParm("GET_LIST_SAMPLE", {"abc" : 111});
		requestParm.put("GET_LIST_SAMPLE2", {"abc" : 111});
		// Sync 형 Service
		var resultData 	= requestServiceMulti(requestParm);
		var gridInfo 	= resultData["GET_LIST_SAMPLE"];	
		var gridInfo2 	= resultData["GET_LIST_SAMPLE2"];	
 */		
		//////////////////////////////////////////////////////////////////////////
		
		// 서비스 1개만 요청
		var gridInfo = requestService("GET_LIST_SAMPLE", {"abc" : 111});
 
		var gridData = gridInfo.data;
		
		// Data 가공.
/* 		$.each(gridData, function(idx) {
			this.APPROVAL_STATUS_DESC = _APPROVAL_DESC_CODE[this.APPROVAL_STATUS];
			this.PROPOSER_DESC = this.PROPOSER_NAME + "(" + this.PROPOSER_POSITION + ")";
			this.ROW_NUM = idx + 1;
		});
 */		
 		var orderList = "DOCID,DOCURL,ORIGIN_DOCNAME,DOCSIZE";
		
		var gridParm = {
			"targetDivId"	: "gridbox"	,
			"orderList" 	: orderList	,
			"splitPos"		: 0			,
			"cellConfig"	: {
				"defaultConfig" : {
					"width" 		: 200,
					"colType"		: "ed"
				},
				"columnConfig" 	: {
					"DOCID" 		: {
						"width" 		: 100,	
						"align" 		: "center",
						"colType"		: "clist"
					}
				}
			},
 			"gridData"		: gridData	,
			"dataConfig"	: {}		
		}
		
		var mygrid = explanGrid.makeGrid(gridParm);
		
		mygrid.attachEvent("onSelectStateChanged", selectGridRow); 
		
		// 두번째 그리드 설정
//		var jsonData = [];
		var jsonData = [
		      	    	{"TA" : "AA1","TB" : 0,"TC" : "CC1"},
		      	    	{"TA" : "AA2","TB" : "BB2","TC" : "CC2"},
		      	    	{"TA" : "AA2","TB" : "BB2","TC" : "CC2"},
		      	    	{"TA" : "AA2","TB" : "BB2","TC" : "CC2"},
		      	    	{"TA" : "AA2","TB" : "BB2","TC" : "CC2"}
		      		];
		
  		var orderList = "TA,TB,TC";
  		
  		// Validation 처리
  		var vfName = "TA";
  		var validatorList = {};
   		validatorList["TA"] = function(a){
  			return a.length <= 4;
  		};
		var gridParm = {
			"targetDivId"	: "gridbox2",
			"orderList" 	: orderList	,
			"gridData"		: jsonData	,
			"cellConfig"	: {
				"defaultConfig" : {
					"width" 		: 200,
					"colType"		: "ed"
				},
				"columnConfig" 	: {
					"TA" 		: {
						"colType"		: "co"
					},
					"TC" 		: {
						"colType"		: "button"
					}
				}
			},
			"useBlockCopy"	: true,
			"validatorList"	: validatorList
		}
		var mygrid2 = explanGrid.makeGrid(gridParm);
		
		mygrid2.attachEvent("onSelectStateChanged", selectGridRow2); 
		
		var combo1 = mygrid2.getCombo("TA");
		combo1.put(0,"zero");
		
		
	}
	
	function addRow() {
		explanGrid.addRow("gridbox2", 0);
	}
	function delRow() {
		explanGrid.deleteRow("gridbox2", 0);
	}
	function undo() {
		explanGrid.undo("gridbox2");
	}
	function redo() {
		explanGrid.validCheckAllGrid("gridbox2");
		//explanGrid.redo("gridbox2");
	}
	
	
	function selectGridRow(rId, cInd) {
		//alert(rId + ":" + "첫번째 Grid");
	}
	function selectGridRow2(rId, cInd) {
		//alert(rId + ":" + "두번째 Grid");
		
		showGridData();
	}
	function showGridData() {
		var gridList = explanGrid.getGridToJson("gridbox");
		dwrite(gridList)
	}
	
	
	function goSaveTest() {
		
		var saveList = [
			{
				"T1" : 1,
				"T2" : 2,
				"T3" : 3,
			},
			{
				"T1" : 4,
				"T2" : 5,
				"T3" : 6,
			}
		]
		
		var sendParm = {
			"saveList"		: saveList
		}
		
		var result = requestService("SAVE_SAMPLE_LIST", sendParm);
		
		dwrite(result);
	}
	
	function submitTest() {
		var result = requestServiceByForm("FORM_TEST", "frm", function(result){
			dwrite(result);	
		});
		
	}
	
	//버튼 사용자 정의
	function eXcell_button(cell){ //the eXcell name is defined here
	    if (cell){                //the default pattern, just copy it
	        this.cell = cell;
	        this.grid = this.cell.parentNode.grid;
	        eXcell_ed.call(this); //uses methods of the "ed" type
	    }
	    this.setValue=function(val){
	        this.setCValue("[" + val + "]",val);  
	    }
	    this.getValue=function(){
	        return $(this.cell).html(); // get button label
	    }
	}
	eXcell_button.prototype = new eXcell; // nests all other methods from the base class
	
	
	function etcTest() {
		var r = explanGrid.getGridToJson("gridbox2");
		dalert(r);
	}
	
</script>

<a href="javascript:etcTest();">etcTest</a><br/><br/>
<a href="javascript:goSaveTest();">SaveTest</a><br/><br/>
<a href="javascript:submitTest();">submitTest</a><br/><br/>



<!-- POPUP SAMPLE 시작-->
<!-- POPUP SAMPLE 시작 -->
<!-- POPUP SAMPLE 시작 -->

<script>
	// Popup Sample
	function openPopup() {
		var parm = "123456789";
		
		_G_FN["templatePopup"].init(parm, function(returnData) {
			alert(returnData);
		});
		
		_SVC_POPUP.show("templatePopup");
		
	}
</script>

<a href="javascript:openPopup();">Popup Sample</a><br/><br/>

<!-- Template Popup Include-->
<%@include file="/include/popup/templatePopup.jsp" %>


<!-- POPUP SAMPLE 끝-->
<!-- POPUP SAMPLE 끝 -->
<!-- POPUP SAMPLE 끝 -->



<!-- list -->
<div class="list_wrap">
	<!-- list_table -->
	1:<div id="gridbox" style="width:1000px;height:500px"></div>
</div>
<!-- //list -->
<div class="list_wrap">
	<!-- list_table -->
	2:<div id="gridbox2" style="width:1000px;height:500px"></div>
</div>

<form id="frm">
	<input type=hidden name="aaa" value="가나다"/>
	<input type=hidden name="aaa" value="abc"/>
	<input type=hidden name="bbb" value="3"/>
</form>

<a href="javascript:addRow();">추가</a>
<a href="javascript:delRow();">삭제</a>
<a href="javascript:undo();">undo</a>
<a href="javascript:redo();">redo</a><br/><br/>

<%@include  file="/include/footer.jsp" %>
