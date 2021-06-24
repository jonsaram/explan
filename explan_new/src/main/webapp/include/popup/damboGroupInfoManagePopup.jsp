<%@ page contentType='text/html;charset=utf-8'%>

<%-- 
	-- Popup 호출 하는 방법 예제
	
	_SVC_POPUP.setConfig("popupIdDgim", sendParm, function(returnData) {
		alert(returnData);
	});
	_SVC_POPUP.show("popupIdDgim");

 --%>

<%-- Popup Id 설정 --%>
<% String popupIdDgim = "damboGroupInfoManagePopup"; %>

<script type="text/javascript">

	$(function() {
		_SVC_POPUP.initPopup("<%=popupIdDgim%>");
	});
	
	_G_FN["<%=popupIdDgim%>"] = {
		/* 콜백함수 필수 등록 */
		callback 		: undefined	,
		deleteDamboGroupInfoList	: []		,
		init 		: function(sendParm, callback) {
			/* 필수 지정 */
			this.callback = callback;
			this.loadDamboGroupInfo();
		},
		loadDamboGroupInfo : function() {
			// Dambo Group Info List 가져오기
			var resultInfo = requestService("GET_DAMBO_GROUP_INFO_LIST", {});
			
			var damboGroupInfoList = resultInfo.data;
			
			var orderList = "[!CB],[!RN],GROUP_NAME,BASE_CHECK,CHART_CHECK,[!HD]GROUP_NUM";
			
			var columnConfig = {};
			
			columnConfig["BASE_CHECK"] 	= { "align"  : "center", "colType" : "ch" };
			columnConfig["CHART_CHECK"] = { "align"  : "center", "colType" : "ch" };
			
	  		var gridParm = {
				"targetDivId"		: "<%=popupIdDgim%>_gridbox"	,
				"orderList" 		: orderList				,
				"gridData"			: damboGroupInfoList	,
				"cellConfig"		: {
					"defaultConfig" 	: { "align"  : "left", "width" :"*", "colType":"edtxt"},
					"columnConfig" 		: columnConfig
				},
				"dataConfig"		: {"useRownum" : true},
				"useBlockCopy"		: true,
				"useAutoResize"		: true,
				"pasteAutoExtend"	: true,				// 복사 붙여 넣기 할때 붙여넣는 항목이 더 많을경우, 자동으로 Row수를 늘려서 맞춤.
				"callback"			: function() {
					explanGrid.attachEvent("<%=popupIdDgim%>_gridbox", "onChange"		, _G_FN["<%=popupIdDgim%>"].onChangeProcess);
				}
			}
			var mygrid = explanGrid.makeGrid(gridParm);
	  		
	  		if(damboGroupInfoList.length == 0) this.addRow();
	  		
		},
		// OnChange Event 처리
 		onChangeProcess : function (gridId, rowId, colId, val, ctype, rowData) {
			if(ctype == "CC") {
				if(colId == "BASE_CHECK" || colId == "CHART_CHECK") {
					explanGrid.pauseEvent("<%=popupIdDgim%>_gridbox"	, "onChange");
					explanGrid.setCheckedRows(gridId, colId, 0);
					explanGrid.setValueById(gridId, rowId, colId, 1);
					explanGrid.releaseEvent("<%=popupIdDgim%>_gridbox"	, "onChange");
				}
			}
		},
 		addRow : function() {
			explanGrid.pauseEvent("<%=popupIdDgim%>_gridbox"	, "onChange");
			var empty = explanGrid.isEmpty("<%=popupIdDgim%>_gridbox");
			var rowId = explanGrid.addRow("<%=popupIdDgim%>_gridbox");
			explanGrid.releaseEvent("<%=popupIdDgim%>_gridbox"	, "onChange");
		},
		delRow : function() {
			var rowIdList = explanGrid.getCheckedRowId("<%=popupIdDgim%>_gridbox", "[!CB]");
			if(rowIdList.length == 0 ) {
				alert('삭제 대상을 선택 하세요.');
				return;
			}
			if(confirm('그룹을 삭제하면 삭제되는 그룹과 담보의 연계 정보도 삭제 됩니다.')) {
				$.each(rowIdList, function() {
					var groupNum = explanGrid.getValueById("<%=popupIdDgim%>_gridbox", this, "GROUP_NUM");
					if(isValid(groupNum)) {
						_G_FN["<%=popupIdDgim%>"].deleteDamboGroupInfoList.push(groupNum);
					}
					explanGrid.deleteRowById("<%=popupIdDgim%>_gridbox", this);
				});
			}
		},
		goSave : function() {
			setTimeout(function() {
				var jsonData 	= explanGrid.getGridToJson("<%=popupIdDgim%>_gridbox", null, "C");
				var sendParm = {
					 "damboGroupInfoList" 		: jsonData
					,"deleteDamboGroupInfoList"	: _G_FN["<%=popupIdDgim%>"].deleteDamboGroupInfoList.join()
				}
				var resultInfo = requestService("SAVE_DAMBO_GROUP_INFO_LIST", sendParm);

				if(resultInfo.state == "S"){
					alert('저장 되었습니다.');
					explanGrid.clearChanged("${pageId}_gridbox");
					// 저장관련 값 초기화
					explanGrid.clearChanged();
					_G_FN["<%=popupIdDgim%>"].deleteDamboGroupInfoList = [];
				} else 	{
					alert(resultInfo.msg);
				}
			}, 300);
		},
		close : function(retParm) {
			this.callback(retParm);
			_SVC_POPUP.hide("<%=popupIdDgim%>");
		}
	}
	function close() {
		var retParm = {};
		_G_FN["<%=popupIdDgim%>"].close(retParm);
	}
</script>

<div class="layer_pop_wrap" style="visibility:hidden" id="<%=popupIdDgim%>">
	<div class="layer_pop" style="width:400px">
		<div class="tit_layer">담보그룹 정보관리</div>
		<div class="contents">
			<div class="list_wrap">
				<div class="list_head">
					<div class="button" id="btnEdit">
						<span class="btn_list"><a href="javascript:var tmp = _G_FN['<%=popupIdDgim%>'].addRow();">그룹 추가</a></span>
						<span class="btn_list"><a href="javascript:_G_FN['<%=popupIdDgim%>'].delRow();">그룹 삭제</a></span>
					</div>
				</div>
				<div style="width:100%;height:200px">
					<div id="<%=popupIdDgim%>_gridbox" style="width:100%;height:100%"></div>				
				</div>
			</div>
		</div>
		<div class="pop_button">
			<span class="btn_page"><a href="#Close" onClick="_G_FN['<%=popupIdDgim%>'].goSave()">저장</a></span>
			<span class="btn_page"><a href="#Close" onClick="_G_FN['<%=popupIdDgim%>'].close()">닫기</a></span>
		</div>
	</div>
</div>
