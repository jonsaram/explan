<%@ page contentType='text/html;charset=utf-8'%>

<%-- 
	담보 그룹 관리
 --%>

<%-- Popup Id 설정 --%>
<% String popupIdDgmp = "damboGroupManagePopup"; %>

<script type="text/javascript">

	$(function() {
		_SVC_POPUP.initPopup("<%=popupIdDgmp%>");
	});
	
	_G_FN["<%=popupIdDgmp%>"] = {
		/* 콜백함수 필수 등록 */
		callback 					: undefined,
		fullDamboOrder				: undefined,
		fullDamboMap				: undefined,
		summaryDamboMap				: {},
		delayLevel					: 0,
		init 						: function(sendParm, callback) {
			/* 필수 지정 */
			this.callback = callback;
			
			this.fullDamboOrder	= sendParm.fullDamboOrder;
			this.fullDamboMap 	= sendParm.fullDamboMap;
			
			if(!isValid(this.fullDamboOrder)) this.setDamboCommonInfo();
			
			// 담보 그룹 정보 Selectbox Setting
			this.loadDamboGroupInfoSelectbox();
			// 전체 담보 Load
			this.loadAllDambo();
			// 선택 담보 Load
			this.loadSummaryDambo();
		},
		loadDamboGroupInfoSelectbox : function() {
			// Dambo Group Info List 가져오기
			var resultInfo = requestService("GET_DAMBO_GROUP_INFO_LIST", {});
			
			var damboGroupInfoList = resultInfo.data;
			
			var damboGroupInfoMap = arrayToMap(damboGroupInfoList, "GROUP_NUM", "GROUP_NAME");
			
			fn_addJsonToSelectBox("<%=popupIdDgmp%>_selectDamboGroup", {"" : "선택"}, true);
			fn_addJsonToSelectBox("<%=popupIdDgmp%>_selectDamboGroup", damboGroupInfoMap);
		},
		loadAllDambo 				: function() {
			var orderList = "[!CB],[!RN],CATEGORY_NAME,DAMBO_NAME,[!HD]DAMBO_NUM";
	 		var addHeaderList = [
	  			["#master_checkbox"	,"No."		,"CATEGORY_NAME","DAMBO_NAME"	,"DAMBO_NUM"],
	 			["#rspan"			,"#rspan"	,"#text_filter"	,"#text_filter"	,"DAMBO_NUM"]
       		];
			
			var columnConfig = {}
	  		var gridParm = {
				"targetDivId"	: "<%=popupIdDgmp%>_gridboxDambo",
				"orderList" 	: orderList,
     			"addHeaderList" : addHeaderList	,
				"gridData"		: this.fullDamboOrder,
				"cellConfig"	: {
					"defaultConfig" : { "align"  : "left", "width" :"200", "colType":"ro"},
					"columnConfig" 	: columnConfig
				},
				"dataConfig"	: {"useRownum" : true, "mergePos" : 2},
				"useAutoResize"	: true
			}
			var mygrid = explanGrid.makeGrid(gridParm);
			
			// Checkbox 상태를 변경 할 경우 처리.
			mygrid.attachEvent("onCheckBox", _G_FN["<%=popupIdDgmp%>"].onCheckBoxProcess);
			
			// Summary와 Rowid 연결
			var gridDataList = explanGrid.getGridToJson("<%=popupIdDgmp%>_gridboxDambo");
			$.each(gridDataList, function() {
				var damboNum 	= this.DAMBO_NUM;
				var rowId		= this._ROWID;
				_G_FN["<%=popupIdDgmp%>"].fullDamboMap[damboNum]._ROWID = rowId;
			});
		},
		onCheckBoxProcess : function(rowId, colIdx, check) {
			// 담보 그룹이 선택 되어 있을때만 처리한다.
			var groupNum = fn_getSelectBox("<%=popupIdDgmp%>_selectDamboGroup");
			if(!isValid(groupNum)) {
				if(_G_VAL["<%=popupIdDgmp%>_delayFlag"] == undefined) {
					alert('담보 그룹을 선택 하세요.');
					_G_VAL["<%=popupIdDgmp%>_delayFlag"] = "check";
					setTimeout(function() {
						_G_VAL["<%=popupIdDgmp%>_delayFlag"] = undefined;
					}, 5000);
				}
				return;
			}
			var rowData = explanGrid.getRowData("<%=popupIdDgmp%>_gridboxDambo", rowId);
			if(check)	_G_FN["<%=popupIdDgmp%>"].summaryDamboMap[rowData.DAMBO_NUM] = rowData;
			else		_G_FN["<%=popupIdDgmp%>"].summaryDamboMap[rowData.DAMBO_NUM] = undefined;
			if(_G_FN["<%=popupIdDgmp%>"].delayLevel > 0) {
				_G_FN["<%=popupIdDgmp%>"].delayLevel = 2;
				return;
			}
			_G_FN["<%=popupIdDgmp%>"].delayLevel = 1;
			_G_FN["<%=popupIdDgmp%>"].resetDamboSummary();
			setTimeout(function() {
				if(_G_FN["<%=popupIdDgmp%>"].delayLevel == 2) _G_FN["<%=popupIdDgmp%>"].resetDamboSummary();
				_G_FN["<%=popupIdDgmp%>"].delayLevel = 0;
			}, 500);
		},
		loadSummaryDambo 			: function(rowList) {
			if(rowList == undefined) rowList = []
			var orderList = "[!CB],[!RN],CATEGORY_NAME,DAMBO_NAME,PIVOT_VALUE,[!HD]DAMBO_NUM";
			
			var itemType = {
				 "orderList"	: orderList
				,"numberList" 	: ["PIVOT_VALUE"]
				,"emptyList"	: ["PIVOT_VALUE"] // 빈값이 가능한 항목 설정
			};
	  		var configInfo = explanGrid.makeConfigInfo(itemType);

	  		var columnConfig 	= configInfo.columnConfig;

	  		var gridParm = {
				"targetDivId"	: "<%=popupIdDgmp%>_gridboxDamboSummary",
				"orderList" 	: orderList,
				"gridData"		: rowList,
				"cellConfig"	: {
					"defaultConfig" : { "align"  : "left", "width" :"150", "colType":"ro"},
					"columnConfig" 	: columnConfig
				},
				"dataConfig"	: {"useRownum" : true, "mergePos" : 2},
				"useAutoResize"	: true,
				"useBlockCopy"	: true
			}
			var mygrid = explanGrid.makeGrid(gridParm);
		},
		resetDamboSummary 			: function() {
			var selectedList = mapToArrayByOrder(_G_FN["<%=popupIdDgmp%>"].summaryDamboMap, _G_FN["<%=popupIdDgmp%>"].fullDamboOrder, "DAMBO_NUM");
			var summaryRowDataList = [];
 			$.each(selectedList, function() {
				var damboNum = this.DAMBO_NUM;
				var addItem = _G_FN["<%=popupIdDgmp%>"].fullDamboMap[damboNum];
				addItem.PIVOT_VALUE = this.PIVOT_VALUE;
				summaryRowDataList.push(addItem);
			});
 			this.loadSummaryDambo(summaryRowDataList);
		},
		resetDamboCheck				:function() {
			explanGrid.checkAll("<%=popupIdDgmp%>_gridboxDambo", false);
			$.each(_G_FN["<%=popupIdDgmp%>"].summaryDamboMap, function(key, obj) {
				var gridboxDamboRowId = _G_FN["<%=popupIdDgmp%>"].fullDamboMap[key]._ROWID;
				explanGrid.setChecked("<%=popupIdDgmp%>_gridboxDambo", gridboxDamboRowId, "[!CB]", true);
			});
		},
		damboGroupInfoManagePopup 	: function() {
			_SVC_POPUP.setConfig("damboGroupInfoManagePopup", {}, function(returnData) {
				_G_FN["<%=popupIdDgmp%>"].loadDamboGroupInfoSelectbox();
			});
			_SVC_POPUP.show("damboGroupInfoManagePopup");
		},
		changeDamboGroup			: function(value) {
			// Dambo Group List 가져오기
			var resultInfo = requestService("GET_COMMON", { "sqlId" : "Insurance.getDamboGroupList", "GROUP_NUM" : value });
			var jsonData = resultInfo.data;
			_G_FN["<%=popupIdDgmp%>"].summaryDamboMap = arrayToMap(jsonData, "DAMBO_NUM");
			this.resetDamboSummary();
			this.resetDamboCheck();
		},
		// 선택 담보 제외
		deleteDamboSummaryRow		: function() {
			rowIdList = explanGrid.getCheckedRowId("<%=popupIdDgmp%>_gridboxDamboSummary", "[!CB]");
			if(rowIdList.length == 0) {
				alert("선택된 항목이 없습니다.");
				return;
			}
			$.each(rowIdList, function() {
				var rowData = explanGrid.getRowData("<%=popupIdDgmp%>_gridboxDamboSummary", this);
				var gridboxDamboRowId = _G_FN["<%=popupIdDgmp%>"].fullDamboMap[rowData.DAMBO_NUM]._ROWID;
				explanGrid.setChecked("<%=popupIdDgmp%>_gridboxDambo", gridboxDamboRowId, "[!CB]", false);
				_G_FN["<%=popupIdDgmp%>"].summaryDamboMap[rowData.DAMBO_NUM] = undefined;
			});
			this.resetDamboSummary();
		},
		goSave : function() {
			setTimeout(function() {
				var jsonData 	= explanGrid.getGridToJson("<%=popupIdDgmp%>_gridboxDamboSummary");
				
				var groupNum = fn_getSelectBox("<%=popupIdDgmp%>_selectDamboGroup");
				
				if(!isValid(groupNum)) {
					alert('담보 그룹을 선택 하세요.');
					return;
				}
				
				var sendParm = {
					 "damboGroupList" 		: jsonData,
					 "GROUP_NUM"			: groupNum
				}
				var resultInfo = requestService("SAVE_DAMBO_GROUP_LIST", sendParm);
				
				if(resultInfo.state == "S"){
					alert('저장 되었습니다.');
				} else 	{
					alert(resultInfo.msg);
				}
			}, 300);
		},
		close 						: function(retParm) {
			this.callback(retParm);
			_SVC_POPUP.hide("<%=popupIdDgmp%>");
		},
		setDamboCommonInfo			: function() {
			// 전체 담보 정보를 읽는다.
			var parm = _SVC_DAMBO.getFullDamboMap();
			// Dambo Order 설정
			this.fullDamboOrder	= parm.damboOrder;
			// Dambo Map 설정
			this.fullDamboMap 	= parm.fullDamboMap;
		}
	}
</script>

<div class="layer_pop_wrap" style="visibility:hidden" id="<%=popupIdDgmp%>">
	<div class="layer_pop" style="width:1100px">
		<div class="tit_layer">담보 그룹 관리</div>
		<div class="contents">
			<div class="table_wrap" style="margin-bottom:10px">
				<table class="list_table">
					<colgroup>
						<col width="200">
						<col width="*">
					</colgroup>
					<tbody>
						<tr>
							<th>담보 그룹 선택</th>
							<td>
								<div class="button" id="btnEdit">
									<select id="<%=popupIdDgmp%>_selectDamboGroup" name="<%=popupIdDgmp%>_selectDamboGroup" onChange="_G_FN['<%=popupIdDgmp%>'].changeDamboGroup(this.value);"></select>
									<span class="btn_list"><a href="javascript:_G_FN['<%=popupIdDgmp%>'].damboGroupInfoManagePopup();">담보그룹 정보관리</a></span>
								</div>
							</td>
						</tr>
					</tbody>
				</table>
			</div>
			<div class="div_wrap">
				<div class="div_left">
					<h4>담보 선택</h4>
					<div class="list_wrap">
						<div style="width:100%;height:400px">
							<div id="<%=popupIdDgmp%>_gridboxDambo" style="width:100%;height:100%"></div>
						</div>
					</div>
				</div>
				<div class="div_right">
					<div class="list_wrap">
						<div class="list_head">
							<h4>담보 선택 요약</h4>
							<div class="setting">
								<span class="btn_list"><a href="javascript:_G_FN['<%=popupIdDgmp%>'].deleteDamboSummaryRow();">선택담보제외</a></span>
							</div>
						</div>
						<div style="width:100%;height:400px">
							<div id="<%=popupIdDgmp%>_gridboxDamboSummary" style="width:100%;height:100%"></div>
						</div>
					</div>
				</div>
			</div>
		</div>
		<div class="pop_button">
			<span class="btn_page"><a href="#Close" onClick="_G_FN['<%=popupIdDgmp%>'].goSave()">저장</a></span>
			<span class="btn_page"><a href="#Close" onClick="_G_FN['<%=popupIdDgmp%>'].close()">닫기</a></span>
		</div>
	</div>
</div>

<!-- Dambo Group Info Manage Popup -->
<%@include  file="/include/popup/damboGroupInfoManagePopup.jsp" %>
