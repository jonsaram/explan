<%@ page contentType='text/html;charset=utf-8'%>

<%-- 
	-- Popup 호출 하는 방법 예제
	
	_SVC_POPUP.setConfig("popupIdIdp", sendParm, function(returnData) {
		alert(returnData);
	});
	_SVC_POPUP.show("popupIdIdp");

 --%>

<%-- Popup Id 설정 --%>
<% String popupIdIdp = "inputDamboPopup"; %>

<script type="text/javascript">

	$(function() {
		_SVC_POPUP.initPopup("<%=popupIdIdp%>");
	});
	
	_G_FN["<%=popupIdIdp%>"] = {
		/* 콜백함수 필수 등록 */
		callback 		: undefined,
		guaranteeTerm	: undefined,
		init 		: function(sendParm, callback) {
			/* 필수 지정 */
			this.callback = callback;
			
			var gridId 		= sendParm.gridId;
			var pRowId		= sendParm.rowId;
			var pColumnId	= sendParm.columnId;
			
			var orderList = "[!CB],[!RN],GUARANTEE_TERM,INSURANCE_MONEY";
			
			var itemType = {
				"orderList"			: orderList
			};
			
	  		var configInfo = explanGrid.makeConfigInfo(itemType);

	  		var columnConfig 	= configInfo.columnConfig;
	  		
	  		columnConfig["GUARANTEE_TERM"] 	= { "colType" : "guarantee","align" : "center"};
	  		columnConfig["INSURANCE_MONEY"] = { "colType" : "insuranceMoney"};
	  		
	  		var validatorList 	= configInfo.validatorList;
			
			var gridData = [];
			
	 		var gridParm = {
				"targetDivId"	: "<%=popupIdIdp%>_gridbox",
				"orderList" 	: orderList		,
	 			"gridData"		: gridData		,
				"cellConfig"	: {
					"defaultConfig" : {
						"width" 		: "*",
						"align" 		: "left",
						"colType" 		: "edtxt"
					},
					"columnConfig" 	: columnConfig
				},
	 			"validatorList"	: validatorList,
	 			"useBlockCopy"	: true
			}
			var mygrid = explanGrid.makeGrid(gridParm);
	 		
	 		var rowId = _G_FN["<%=popupIdIdp%>"].addRow();
	 		
	 		explanGrid.setDisabledById("<%=popupIdIdp%>_gridbox", rowId, "[!CB]", true);
	 		
	 		// 초기값 세팅
			var cellData = explanGrid.getValueById(gridId, pRowId, pColumnId);
	 		
			if(isValid(cellData,1)) {
				var dataList = cellData.split(",");
				$.each(dataList, function(idx) {
					if(idx > 0) {
						rowId = _G_FN["<%=popupIdIdp%>"].addRow();
					}
					var itemList = this.split("/");
					var valueMap = {
						"GUARANTEE_TERM" : itemList[0],
						"INSURANCE_MONEY" : itemList[1]
					}
					explanGrid.setRow("<%=popupIdIdp%>_gridbox", rowId, valueMap);
				});
			}
		},
		open 	: function (gridId, rowId, columnId, guaranteeTerm) {
			this.guaranteeTerm = guaranteeTerm;
			var sendParm = {
				gridId 		: gridId,
				rowId 		: rowId,
				columnId 	: columnId
			};
			_SVC_POPUP.setConfig("<%=popupIdIdp%>", sendParm, function(returnData) {
				if(returnData == undefined) return;
				var mygrid = explanGrid.getGrid(gridId).grid;
				mygrid.userFunction.callback["inputDambo"](gridId, rowId, columnId, returnData);
			});
			_SVC_POPUP.show("<%=popupIdIdp%>");
		},
		addRow : function() {
			var empty = explanGrid.isEmpty("<%=popupIdIdp%>_gridbox");
			var rowId = explanGrid.addRow("<%=popupIdIdp%>_gridbox");
			explanGrid.setRow("<%=popupIdIdp%>_gridbox", rowId, {"GUARANTEE_TERM" : this.guaranteeTerm});
			return rowId;
		},
		delRow : function() {
			rowIdList = explanGrid.getCheckedRowId("<%=popupIdIdp%>_gridbox", "[!CB]");
			$.each(rowIdList, function() {
				explanGrid.deleteRowById("<%=popupIdIdp%>_gridbox", this);
			});
		},
		apply : function() {
			setTimeout(function() {
				var resultMap 	= explanGrid.validCheckAllGrid("<%=popupIdIdp%>_gridbox");
				
				if(!resultMap.valid) {
					alert(resultMap.getMsg());
					return;
				}
				
				var gridData = explanGrid.getGridToJson("<%=popupIdIdp%>_gridbox");
				
				var returnData = "";
				$.each(gridData, function() {
					returnData += "," + this.GUARANTEE_TERM + "/" + this.INSURANCE_MONEY;
				});
				if(returnData != "") returnData = returnData.substring(1);
				_G_FN["<%=popupIdIdp%>"].callback(returnData);
				_SVC_POPUP.hide("<%=popupIdIdp%>");
			}, 100);
		},
		close : function(retParm) {
			this.callback(retParm);
			_SVC_POPUP.hide("<%=popupIdIdp%>");
		}
	}
	
	function close() {
		var retParm = "12345";
		_G_FN["<%=popupIdIdp%>"].close(retParm);
	}
	
	//Guarantee Cell Type 정의
	function eXcell_guarantee(cell){ 
	    if (cell){                
	        this.cell 	= cell;
	        this.grid 	= this.cell.parentNode.grid;
	    }
	    this.setValue=function(val){
	    	var gridId 		= this.grid.getGridId();
	    	var grid		= this.grid;	
	    	var rowId		= this.cell.parentNode.idd;
	    	var columnId	= this.grid.getColumnId(this.cell.cellIndex);
	    	val = val.replaceAll("세", "");
	    	if(isValid(val,1)) val = val + "세";
			this.setCValue(val,val);  
	    }
	    this.getValue=function(){
	    	var retVal = $(this.cell).html();
	    	return retVal.replaceAll("세", "");
	    }
	}
	eXcell_guarantee.prototype = new eXcell_edn; 	

	//insuranceMoney Cell Type 정의
	function eXcell_insuranceMoney(cell){ 
	    if (cell){                
	        this.cell 	= cell;
	        this.grid 	= this.cell.parentNode.grid;
	    }
	    this.setValue=function(val){
	    	val = val.replaceAll("만원", "");
	    	if(isNumber(val)) val = Number(val);
	    	val = val + "";
	    	var gridId 		= this.grid.getGridId();
	    	var grid		= this.grid;	
	    	var rowId		= this.cell.parentNode.idd;
	    	var columnId	= this.grid.getColumnId(this.cell.cellIndex);
	    	if(isValid(val,1)) val = val.replaceAll("~","만원~") + "만원";
			this.setCValue(val,val);  
	    }
	    this.getValue=function(){
	    	var retVal = $(this.cell).html();
	    	return retVal.replaceAll("만원", "");
	    }
	}
	eXcell_insuranceMoney.prototype = new eXcell_edn; 	
</script>

<div class="layer_pop_wrap" style="visibility:hidden" id="<%=popupIdIdp%>">
	<div class="layer_pop" style="width:400px">
		<div class="tit_layer">기간 별 보장 금액 추가/삭제</div>
		<div class="contents">
			<div class="list_wrap">
				<div class="list_head">
					<div class="button" id="btnEdit">
						<span class="btn_list"><a href="javascript:var tmp = _G_FN['<%=popupIdIdp%>'].addRow();">항목 추가</a></span>
						<span class="btn_list"><a href="javascript:_G_FN['<%=popupIdIdp%>'].delRow();">항목 삭제</a></span>
					</div>
				</div>
				<div style="width:100%;height:200px">
					<div id="<%=popupIdIdp%>_gridbox" style="width:100%;height:100%"></div>				
				</div>
			</div>
		</div>
		<div class="pop_button">
			<span class="btn_page"><a href="#Close" onClick="_G_FN['<%=popupIdIdp%>'].apply()">적용</a></span>
			<span class="btn_page"><a href="#Close" onClick="_G_FN['<%=popupIdIdp%>'].close()">닫기</a></span>
		</div>
	</div>
</div>
