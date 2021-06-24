<%@ page contentType='text/html;charset=utf-8'%>

<%-- Popup Id 설정 --%>
<% String popupIdSsp = "selectSearchPopup"; %>

<script type="text/javascript">
	
	$(function() {
		_SVC_POPUP.initPopup("<%=popupIdSsp%>");
	});
	_G_FN["<%=popupIdSsp%>"] = {
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
					var item = { "COMMON_CODE" : code, "COMMON_NAME" : name};
					gridData.push(item);
				});
			}

			var orderList = "[!RN],COMMON_CODE,COMMON_NAME";
			
	 		var addHeaderList = [
   	   			["No."		,"COMMON_CODE"	,"COMMON_NAME"	],
   	   			["#rspan"	,"#text_filter"	,"#text_filter"	]
   			];
	 		
	 		var columnConfig = {};
	 		columnConfig["COMMON_CODE" 		] = {"sortType":"str"};	 		
	 		columnConfig["COMMON_NAME" 		] = {"sortType":"str"};	 		
			
	 		var gridParm = {
				"targetDivId"	: "<%=popupIdSsp%>_gridbox",
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
				var item = explanGrid.getRowData("<%=popupIdSsp%>_gridbox", rId);
				var callback = _G_FN["<%=popupIdSsp%>"].callback;
				if(callback == undefined) 	alert('callback 지정이 필요합니다.');
				else						callback(item);
				_SVC_POPUP.hide("<%=popupIdSsp%>");
			});
		},
		close 	: function() {
			this.callback();
			_SVC_POPUP.hide("<%=popupIdSsp%>");
		},
		open 	: function (gridId, rowId, columnId) {
			var sendParm = {
				gridId : gridId,
				columnId : columnId
			};
			_SVC_POPUP.setConfig("selectSearchPopup", sendParm, function(returnData) {
				if(returnData == undefined) return;
				var mygrid = explanGrid.getGrid(gridId).grid;
				mygrid.userFunction.callback["search"](gridId, rowId, columnId, returnData.COMMON_CODE, returnData.COMMON_NAME);
			});
			_SVC_POPUP.show("selectSearchPopup");
		}		
	}

</script>

<div class="layer_pop_wrap" style="visibility:hidden" id="<%=popupIdSsp%>">
	<div class="layer_pop" style="width:800px">
		<div class="tit_layer">항목 선택</div>
		<div class="contents">
			<div class="list_wrap">
				<div id="<%=popupIdSsp%>_gridbox" style="width:100%;height:400px"></div>				
			</div>
		</div>
		<div class="pop_button">
			<span class="btn_page"><a href="#Close" onClick="_G_FN['<%=popupIdSsp%>'].close()">Close</a></span>
		</div>
	</div>
</div>
