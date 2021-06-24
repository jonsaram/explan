<%@ page contentType='text/html;charset=utf-8'%>

<%-- Popup Id 설정 --%>
<% String popupIdSssp = "selectSearchSinglePopup"; %>

<script type="text/javascript">
	
	$(function() {
		_SVC_POPUP.initPopup("<%=popupIdSssp%>");
	});
	_G_FN["<%=popupIdSssp%>"] = {
		/* 콜백함수 필수 등록 */
		callback 	: undefined,
		init 		: function(sendParm, callback) {
			/* 필수 지정 */
			this.callback = callback;
			
			var gridId 		= sendParm.gridId;
			var columnId	= sendParm.columnId;
			
			var gridData = [];
			
			if(_DD_MAP[columnId] == undefined) {
				gridData = _SVC_COM.getDDList(columnId);
			}
			else {
				$.each(_DD_MAP[columnId], function(code, name) {
					var item = { "COMMON_CODE" : code};
					gridData.push(item);
				});
			}

			var orderList = "[!RN],COMMON_CODE";
			
	 		var addHeaderList = [
   	   			["No."		,_SVC_COM.getWordListMap()[columnId]	],
   	   			["#rspan"	,"#text_filter"	]
   			];
	 		
	 		var columnConfig = {};
	 		columnConfig["COMMON_CODE" 		] = {"sortType":"str"};	 		
			
	 		var gridParm = {
				"targetDivId"	: "<%=popupIdSssp%>_gridbox",
				"gridHeight"	: "400px"		,
				"orderList" 	: orderList		,
				"addHeaderList"	: addHeaderList	,
	 			"gridData"		: gridData		,
				"cellConfig"	: {
					"defaultConfig" : {
						"width" 		: "*"
					},
					"columnConfig" 	: columnConfig
				}
			}
			var mygrid = explanGrid.makeGrid(gridParm);
			
			// 선택된 값 처리
			mygrid.attachEvent("onSelectStateChanged", function (rId, cInd) {
				var item = explanGrid.getRowData("<%=popupIdSssp%>_gridbox", rId);
				var callback = _G_FN["<%=popupIdSssp%>"].callback;
				if(callback == undefined) 	alert('callback 지정이 필요합니다.');
				else						callback(item);
				_SVC_POPUP.hide("<%=popupIdSssp%>");
			});
		},
		close 	: function() {
			this.callback();
			_SVC_POPUP.hide("<%=popupIdSssp%>");
		},
		open 	: function (gridId, rowId, columnId) {
			var sendParm = {
				gridId : gridId,
				columnId : columnId
			};
			_SVC_POPUP.setConfig("<%=popupIdSssp%>", sendParm, function(returnData) {
				if(returnData == undefined) return;
				var mygrid = explanGrid.getGrid(gridId).grid;
				mygrid.userFunction.callback["searchSingle"](gridId, rowId, columnId, returnData.COMMON_CODE);
			});
			_SVC_POPUP.show("<%=popupIdSssp%>");
		}		
	}

</script>

<div class="layer_pop_wrap" style="visibility:hidden" id="<%=popupIdSssp%>">
	<div class="layer_pop" style="width:400px">
		<div class="tit_layer">항목 선택</div>
		<div class="contents">
			<div class="list_wrap" style="width:100%;height:300px">
				<div id="<%=popupIdSssp%>_gridbox" style="width:100%;height:100%"></div>				
			</div>
		</div>
		<div class="pop_button">
			<span class="btn_page"><a href="#Close" onClick="_G_FN['<%=popupIdSssp%>'].close()">Close</a></span>
		</div>
	</div>
</div>
