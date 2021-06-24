<%@ page contentType='text/html;charset=utf-8'%>

<%-- Popup Id 설정 --%>
<% String popupIdMip = "modifyInsuredPopup"; %>

<script type="text/javascript">
	
	$(function() {
		_SVC_POPUP.initPopup("<%=popupIdMip%>");
	});
	_G_FN["<%=popupIdMip%>"] = {
		/* 콜백함수 필수 등록 */
		callback 	: undefined,
		init 		: function(sendParm, callback) {
			/* 필수 지정 */
			this.callback = callback;
			
			var gridId 		= sendParm.gridId;
			var pRowId		= sendParm.rowId;
			var pColumnId	= sendParm.columnId;
			
			var orderList = "[!CB],[!RN],INSURED_TYPE,INSURED_NAME,INSURED_BIRTH_YEAR";
			
			var itemType = {
				"orderList"			: orderList,
				"searchSingleList" 	: ["INSURED_BIRTH_YEAR"]
			};
			
			_DD_MAP["INSURED_BIRTH_YEAR"] = {};
			var today = getToday(4);
			for(var ii = "1940"; ii <= today; ii++ ) _DD_MAP["INSURED_BIRTH_YEAR"][(ii + "")] = (ii + "");
			
	  		var configInfo = explanGrid.makeConfigInfo(itemType);

	  		var columnConfig 	= configInfo.columnConfig;
	  		
	  		var validatorList 	= configInfo.validatorList;
			
			var gridData = [];
			
			columnConfig["INSURED_TYPE"] = { "colType" : "ro" };
			
			validatorList["INSURED_NAME"] = function(cellData) {
				if(isValid(cellData,1))	return true;
				else					return false;
			}
			
	 		var gridParm = {
				"targetDivId"	: "<%=popupIdMip%>_gridbox",
				"orderList" 	: orderList		,
	 			"gridData"		: gridData		,
				"cellConfig"	: {
					"defaultConfig" : {
						"width" 		: "*",
						"align" 		: "center",
						"colType" 		: "edtxt"
					},
					"columnConfig" 	: columnConfig
				},
	 			"validatorList"	: validatorList,
	 			"useBlockCopy"	: true
			}
			var mygrid = explanGrid.makeGrid(gridParm);
	 		
	 		var rowId = _G_FN["<%=popupIdMip%>"].addRow();
	 		
	 		explanGrid.setDisabledById("<%=popupIdMip%>_gridbox", rowId, "[!CB]", true);
	 		
	 		// 초기값 세팅
			var cellData = explanGrid.getValueById(gridId, pRowId, pColumnId);
	 		
			if(isValid(cellData,1)) {
				var dataList = cellData.split(",");
				$.each(dataList, function(idx) {
					if(idx > 0) {
						rowId = _G_FN["<%=popupIdMip%>"].addRow();
					}
					var itemList = this.split("/");
					var valueMap = {
						"INSURED_NAME" 		: itemList[0],
						"INSURED_BIRTH_YEAR": itemList[1]
					}
					explanGrid.setRow("<%=popupIdMip%>_gridbox", rowId, valueMap);
				});
			}
		},
		close 	: function() {
			this.callback();
			_SVC_POPUP.hide("<%=popupIdMip%>");
		},
		open 	: function (gridId, rowId, columnId) {
			var sendParm = {
				gridId 		: gridId,
				rowId 		: rowId,
				columnId 	: columnId
			};
			_SVC_POPUP.setConfig("<%=popupIdMip%>", sendParm, function(returnData) {
				if(returnData == undefined) return;
				var mygrid = explanGrid.getGrid(gridId).grid;
				mygrid.userFunction.callback["insured"](gridId, rowId, columnId, returnData);
			});
			_SVC_POPUP.show("<%=popupIdMip%>");
		},
		addRow : function() {
			var empty = explanGrid.isEmpty("<%=popupIdMip%>_gridbox");
			var rowId = explanGrid.addRow("<%=popupIdMip%>_gridbox");
			var itype 			= "종피보험자";
			if(empty) itype 	= "주피보험자";
			explanGrid.setValueById("<%=popupIdMip%>_gridbox", rowId, "INSURED_TYPE"			, itype);

			var firstValue = getToday(4);
			explanGrid.setValueById("<%=popupIdMip%>_gridbox", rowId, "INSURED_BIRTH_YEAR"	, firstValue);
			
			return rowId;
		},
		delRow : function() {
			rowIdList = explanGrid.getCheckedRowId("<%=popupIdMip%>_gridbox", "[!CB]");
			$.each(rowIdList, function() {
				explanGrid.deleteRowById("<%=popupIdMip%>_gridbox", this);
			});
		},
		apply : function() {
			var resultMap 	= explanGrid.validCheckAllGrid("<%=popupIdMip%>_gridbox");
			
			if(!resultMap.valid) {
				alert(resultMap.getMsg());
				return;
			}
			
			var gridData = explanGrid.getGridToJson("<%=popupIdMip%>_gridbox");
			
			var returnData = "";
			$.each(gridData, function() {
				returnData += "," + this.INSURED_NAME + "/" + this.INSURED_BIRTH_YEAR;
			});
			if(returnData != "") returnData = returnData.substring(1);
			this.callback(returnData);
			_SVC_POPUP.hide("<%=popupIdMip%>");
		}
	}

</script>

<div class="layer_pop_wrap" style="visibility:hidden" id="<%=popupIdMip%>">
	<div class="layer_pop" style="width:400px">
		<div class="tit_layer">피보험자 추가/삭제</div>
		<div class="contents">
			<div class="list_wrap">
				<div class="list_head">
					<div class="button" id="btnEdit">
						<span class="btn_list"><a href="javascript:var tmp = _G_FN['<%=popupIdMip%>'].addRow();">피보험자 추가</a></span>
						<span class="btn_list"><a href="javascript:_G_FN['<%=popupIdMip%>'].delRow();">피보험자 삭제</a></span>
					</div>
				</div>
				<div style="width:100%;height:200px">
					<div id="<%=popupIdMip%>_gridbox" style="width:100%;height:100%"></div>				
				</div>
			</div>
		</div>
		<div class="pop_button">
			<span class="btn_page"><a href="#Close" onClick="_G_FN['<%=popupIdMip%>'].apply()">적용</a></span>
			<span class="btn_page"><a href="#Close" onClick="_G_FN['<%=popupIdMip%>'].close()">닫기</a></span>
		</div>
	</div>
</div>
