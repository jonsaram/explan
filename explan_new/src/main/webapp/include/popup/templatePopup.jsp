<%@ page contentType='text/html;charset=utf-8'%>

<%-- 
	-- Popup 호출 하는 방법 예제
	
	_SVC_POPUP.setConfig("popupId", sendParm, function(returnData) {
		alert(returnData);
	});
	_SVC_POPUP.show("popupId");

 --%>

<%-- Popup Id 설정 --%>
<c:set var="popupId" value="templatePopup"/>

<script type="text/javascript">

	$(function() {
		_SVC_POPUP.initPopup("${popupId}");
	});
	
	_G_FN["${popupId}"] = {
		/* 콜백함수 필수 등록 */
		callback 	: undefined,
		init 		: function(sendParm, callback) {
			/* 필수 지정 */
			this.callback = callback;
			
			/* Module 초기화 */
			alert('module 초기화');
			
			
		},
		close : function(retParm) {
			this.callback(retParm);
			_SVC_POPUP.hide("${popupId}");
		}
	}
</script>

<div class="layer_pop_wrap" id="${popupId}">
	<div class="layer_pop" style="width:500px" id="${popupId}_layer_pop">
		<div class="tit_layer"></div>
		<div class="contents" id="${popupId}_contents">
			<div class="list_wrap">
				<div class="grid_wrap">
					<!-- grid 삽입 -- >
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
			<span class="btn_page"><a href="javascript:_G_FN['${popupId}'].close()">Close</a></span>
		</div>
	</div>
</div>
