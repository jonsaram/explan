<%@ page contentType='text/html;charset=utf-8'%>

<%-- 
	-- Popup 호출 하는 방법 예제
	
	_SVC_POPUP.setConfig("popupId", sendParm, function(returnData) {
		alert(returnData);
	});
	_SVC_POPUP.show("popupId");

 --%>

<%-- Popup Id 설정 --%>
<c:set var="popupId" value="toastPopup"/>

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
			//$("#${popupId}_msg").html(sendParm.msg);
			var renderHtml = $("#${popupId}_template").render(sendParm);
			$("#${popupId}").html(renderHtml);
			
			/* Module 초기화 */
			setTimeout(function() {
				//_G_FN["${popupId}"].close();
			},3000);
		},
		close : function(retParm) {
			this.callback(retParm);
			_SVC_POPUP.hide("${popupId}");
		}
	}
</script>

<div class="layer_pop_wrap" id="${popupId}">
</div>
<script type="text/x-jsrender" id="${popupId}_template">
	<div class="layer_pop" style="width:300px" id="${popupId}_layer_pop">
		<div class="tit_layer">오류</div>
		<div id="${popupId}_contents" style="text-align:left;padding:10px">
			<b><span>{{:msg}}</span></b>
		</div>
		<div><a href="javascript:_G_FN['${popupId}'].close()">ccc</a></div>
	</div>
</script>



