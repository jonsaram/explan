<%@ page language="java" errorPage="/explan/common/error.jsp" pageEncoding="UTF-8" contentType="text/html;charset=utf-8" %>

<%@include  file="/include/header.jsp" %>

<script>
	$(function() {
		cCustomerManage.load();
	});
	
	var cCustomerManage = {
		 gridId	: "gridCustomer"
		,load : function() {
			// 서비스 요청
			var gridInfo = requestService("GET_COMMON", {"sqlId" : "Customer.getCustomerList"});

			var jsonData = gridInfo.data;
			
	  		var orderList = "[!CB],[!RN],[!HD]CUSTOMER_NUM,CUSTOMER_NAME,BIRTHDAY,PHONE_NUM,EMAIL,CREATE_DATE";
	  		
	  		var columnConfig = {};
	  		
	  		var validatorList = {};
	  		
	  		columnConfig["CREATE_DATE"] = { "colType" : "ro"}
	  		columnConfig["BIRTHDAY"] 	= { "colType" : "birth"}
			
	  		// 유효성 Check
	 		validatorList["CUSTOMER_NAME"] = function(cellData){
	 			if(!isValid(cellData,1)) return false;
	 			else return true;
	  		};
	  		
	  		var gridParm = {
				"targetDivId"	: this.gridId,
				"orderList" 	: orderList,
				"gridData"		: jsonData,
				"cellConfig"	: {
					"defaultConfig" : { "align"  : "center", "width" :"*", "colType":"edtxt"},
					"columnConfig" 	: columnConfig
				},
				"validatorList"	: validatorList,
				"dataConfig"	: {"useRownum"		: true},
				"useAutoResize"	: true,
				"useAutoHeight"	: { "margin" : 230 },
				"useBlockCopy"	: true
			}
			var mygrid = explanGrid.makeGrid(gridParm);
		}
		,addRow : function() {
			explanGrid.addRow(this.gridId);
		}
		,delRow	: function() {
			rowIdList = explanGrid.getCheckedRowId(this.gridId, "[!CB]");
			$.each(rowIdList, function() {
				explanGrid.deleteRowById(cCustomerManage.gridId, this);
			});
		}
		,save	: function() {
			var isEmpty = explanGrid.isEmpty(this.gridId);
			if(isEmpty) {
				alert("저장 할 내용이 없습니다.");
				return;
			}
			var changeCheck = explanGrid.isChanged(this.gridId);
			if(!changeCheck) {
				alert("변경 내용이 없습니다.");
				return;
			}
			
			var jsonData 	= explanGrid.getGridToJson(this.gridId, null, "C");

			var resultMap = explanGrid.validCheckAllGrid(this.gridId);
			
			if(!resultMap.valid) {
				alert(resultMap.getMsg());
				return;
			}

			// 삭제 Plan Number List
			var deletedCustomerNumList = explanGrid.getDeletedCols(this.gridId, "CUSTOMER_NUM");
			
			var sendParm = {
				 "deletedCustomerNumList"	: deletedCustomerNumList
				,"customerList" 			: jsonData
			}
			
			var gridInfo = requestService("SAVE_CUSTOMER_LIST", sendParm);

			if(gridInfo.state == "S"){
				alert('저장 되었습니다.');
				
				this.load();
				
				explanGrid.clearChanged(this.gridId);
				
			} else 	{
				alert(gridInfo.msg);
			}
		}
	}
</script>

	<h3>고객 관리</h3>
	<div class="list_wrap">
		<div class="list_head">
			<div class="button" id="btnEdit">
				<span class="btn_list"><a href="javascript:cCustomerManage.addRow();"	>고객추가	</a></span>
				<span class="btn_list"><a href="javascript:cCustomerManage.delRow();"	>고객삭제	</a></span>
				<span class="btn_list"><a href="javascript:cCustomerManage.save();"	>저장		</a></span>
			</div>
		</div>
		<div style="width:100%;height:420px">
			<div id="gridCustomer" style="width:100%;height:100%;"></div>
		</div>
	</div>
	<div class="page_button"><span class="btn_page"><a href="javascript:cCustomerManage.save()">저장</a></span></div>

<%@include  file="/include/footer.jsp" %>
