<%@ page contentType='text/html;charset=utf-8'%>

<%-- Component Id 설정 --%>
<c:set var="comId" value="templateComponent"/>

<script type="text/javascript">

	$(function() {
	});
	
	_G_FN["${comId}"] = {
		/* 콜백함수 필수 등록 */
		callback 	: undefined,
		init 		: function(sendParm, callback) {
			/* 필수 지정 */
			this.sendParm			= sendParm;
			this.callback = callback;
		}
	}
</script>

<div id="${comId}">
	<h4>Template</h4>
	<div class="list_wrap">
		<div class="list_head">
			<div class="button">
				<span class="btn_list"><a href="javascript:;">buttonA</a></span>
				<span class="btn_list"><a href="javascript:;">buttonB</a></span>
			</div>
		</div>
		<div class="grid_wrap">
			<!-- grid 삽입 -->
 			<div id="gridbox" style="width:100%;height:200px"></div>
 		</div>
	</div>
</div>
