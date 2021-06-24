<%@ page contentType='text/html;charset=utf-8'%>

<%-- 
	-- Popup 호출 하는 방법 예제
	
	_SVC_POPUP.setConfig("popupIdIed", sendParm, function(returnData) {
		alert(returnData);
	});
	_SVC_POPUP.show("popupIdIed");

 --%>

<%-- Popup Id 설정 --%>
<% String popupIdIed = "inputEndDatePopup"; %>

<script type="text/javascript">

	$(function() {
		_SVC_POPUP.initPopup("<%=popupIdIed%>");
	});
	
	_G_FN["<%=popupIdIed%>"] = {
		cellData	: undefined,
		/* 콜백함수 필수 등록 */
		callback 	: undefined,
		init 		: function(sendParm, callback) {
			/* 필수 지정 */
			this.callback = callback;
			
			/* Module 초기화 */
			alert('module 초기화');
			
			
		},
		open 	: function (gridId, rowId, columnId, cellData) {
			this.cellData = cellData;
			var sendParm = {
				gridId 		: gridId,
				rowId 		: rowId,
				columnId 	: columnId
			};
			_SVC_POPUP.setConfig("<%=popupIdIed%>", sendParm, function(returnData) {
				mygrid.userFunction.callback["inputEndDatePopup"](gridId, rowId, columnId, returnData);
			});
			_SVC_POPUP.show("<%=popupIdIed%>");
		},
		close : function(retParm) {
			this.callback(retParm);
			_SVC_POPUP.hide("<%=popupIdIed%>");
		}
	}
	
	function close() {
		var retParm = "12345";
		_G_FN["<%=popupIdIed%>"].close(retParm);
	}
</script>

<div class="layer_pop_wrap" id="<%=popupIdIed%>">
	<div class="layer_pop" style="width:500px" id="<%=popupIdIed%>_layer_pop">
		<div class="tit_layer">Weight Update</div>
		<div class="contents" id="<%=popupIdIed%>_contents">
			<div class="list_wrap">
				<div class="grid_wrap">
					<!-- grid 삽입 -->
					<table class="list_table">
					<colgroup>
					<col width="33%">
					<col width="33%">
					<col>
					</colgroup>
					<thead>
					<tr>
					<th>Item</th>
					<th>Previous Value</th>
					<th>Fixed Value</th>
					</tr>
					</thead>
					<tbody>
					<tr>
					<td class="tc">Gross Weight</td>
					<td class="tr">15kg</td>
					<td class="tr">18kg</td>
					</tr>
					</tbody>
					</table>
					<!-- //grid 삽입 -->
				</div>
			</div>
		</div>
		<div class="pop_button">
			<span class="btn_page"><a href="javascript:close()">Close</a></span>
		</div>
	</div>
</div>
