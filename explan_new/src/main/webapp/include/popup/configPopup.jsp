<%@ page contentType='text/html;charset=utf-8'%>

<%-- 
	-- Popup 호출 하는 방법 예제
	
	_SVC_POPUP.setConfig("popupIdCp", sendParm, function(returnData) {
		alert(returnData);
	});
	_SVC_POPUP.show("popupIdCp");

 --%>

<%-- Popup Id 설정 --%>
<% String popupIdCp = "configPopup"; %>

<script type="text/javascript">

	$(function() {
		_SVC_POPUP.initPopup("<%=popupIdCp%>");
	});
	
	_G_FN["<%=popupIdCp%>"] = {
		/* 콜백함수 필수 등록 */
		callback 	: undefined,
		init 		: function(sendParm, callback) {
			/* 필수 지정 */
			this.callback = callback;
		},
		openPopup	: function(popupId) {
			_SVC_POPUP.runtimeOpenPopup(popupId);
		},
		close : function(retParm) {
			this.callback(retParm);
			_SVC_POPUP.hide("<%=popupIdCp%>");
		}
	}
	
	function test() {
		alert();
	}
	
</script>

<div class="layer_pop_wrap" id="<%=popupIdCp%>" style="z-index:102">
	<div class="layer_pop" style="width:1000px" id="<%=popupIdCp%>_layer_pop">
		<div class="tit_layer">설정</div>
		<div class="contents" id="<%=popupIdCp%>_contents">
			<div class=col4Section>
				<div class="fLBox1 lft">
					<h4>보험 설정</h4>
					<ul>
						<li style="padding-bottom:10px"><a href="javascript:_G_FN['<%=popupIdCp%>'].openPopup('damboGroupManagePopup');">1. 보험 담보 그룹 관리</a></li>
						<li><a href="javascript:">2. 사용자 등록 담보 관리</a></li>
					</ul>
				</div>
				<div class="fLBox2 lft">
					<h4>보험 설정</h4>
					1. 보험 담보 설정
				</div>
				<div class="fLBox3 lft">
					<h4>보험 설정</h4>
					1. 보험 담보 설정
				</div>
			</div>
		</div>
		<div class="pop_button">
			<span class="btn_page"><a href="javascript:_G_FN['<%=popupIdCp%>'].close()">Close</a></span>
		</div>
	</div>
</div>
