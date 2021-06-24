<%@ page language="java" errorPage="/explan/common/error.jsp" pageEncoding="UTF-8" contentType="text/html;charset=utf-8" %>

<%@include  file="/include/header.jsp" %>

<script>
	$(function() {
		var gridInfo = _SVC_COM.getDDList("TEST");
		
		// 서비스 요청
		var gridInfo = requestService("GET_COMMON", {"sqlId" : "Customer.getCustomerList"});
		
		var jsonData = gridInfo.data;
		
  		var orderList = "[!RN],[!HD]CUSTOMER_NUM,CUSTOMER_NAME,BIRTHDAY,PHONE_NUM,EMAIL,CREATE_DATE";
  		
  		var columnConfig = {};
  		
  		var validatorList = {};
  		
  		columnConfig["CREATE_DATE"] 	= { "colType" : "ro"}
		
  		// 유효성 Check
 		validatorList["CUSTOMER_NAME"] = function(cellData){
 			if(!isValid(cellData,1)) return false;
 			else return true;
  		};
  		
  		var gridParm = {
			"targetDivId"	: "gridbox",
			"orderList" 	: orderList,
			"gridData"		: jsonData,
			"cellConfig"	: {
				"defaultConfig" : { "align"  : "center", "width" :"*", "colType":"edtxt"},
				"columnConfig" 	: columnConfig
			},
			"validatorList"	: validatorList,
			"useBlockCopy"	: true
		}
		var mygrid = explanGrid.makeGrid(gridParm);
	});
	
	function addRow() {
		explanGrid.addRow("gridbox");
	}
	
	function goSave() {
		var isEmpty = explanGrid.isEmpty("gridbox");
		if(isEmpty) {
			alert("저장 할 내용이 없습니다.");
			return;
		}
		var changeCheck = explanGrid.isChanged("gridbox");
		if(!changeCheck) {
			alert("변경 내용이 없습니다.");
			return;
		}
		
		var jsonData 	= explanGrid.getGridToJson("gridbox");

		if(jsonData == undefined || jsonData.length == 0) {
			alert('저장 할 항목이 없습니다.');
			return;
		}
		
		var resultMap = explanGrid.validCheckAllGrid("gridbox");
		
		if(!resultMap.valid) {
			alert(resultMap.getMsg());
			return;
		}
		
		var sendParm = {
			"customerList" : jsonData
		}
		var gridInfo = requestService("SAVE_CUSTOMER_LIST", sendParm);
	}
	
</script>

	<h3>고객 관리</h3>
	
	<!-- tab -->
	<div class="tab">
		<ul>
			<li class="first on"><a href="#">고객 리스트</a></li>
			<li><a href="#">고객 등록</a></li>
		</ul>
	</div>
	<!-- //tab -->

	<div class="tab_cont">
		<h4>고객 리스트</h4>
		<div class="list_head">
			<div class="button" id="btnEdit">
				<span class="btn_list"><a href="javascript:addRow();">한줄 추가</a></span>
				<span class="btn_list"><a href="javascript:goSave();">저장</a></span>
			</div>
		</div>
		<div class="list_wrap" style="width:100%;height:420px">
			<div id="gridbox" style="width:100%;height:100%;"></div>
		</div>
		<div class="page_button"><span class="btn_page"><a href="javascript:goSave()">저장</a></span></div>
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
