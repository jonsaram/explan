<%@ page contentType='text/html;charset=utf-8'%>

		<!-- Grid Search Type Popup -->
		<%@include  file="/include/popup/selectSearchPopup.jsp" %>
		<!-- Grid Search Type Popup -->
		<%@include  file="/include/popup/selectSearchSinglePopup.jsp" %>
		</div>
		<!-- contents -->
		<br/>
		<br/>
	</div>
	<!-- //container -->
</div>
<!-- Progress Bar -->
<div id="loading" style="display:none;z-index:99999">
		<div id=loading_image><img src='../img/loading1.gif' /></div>                                                                                                                  
</div>

<!-- //footer -->
<form id="hiddenNewWindow" name="hiddenNewWindow" method="post">
<input type=hidden id="pageId" name="pageId" />
<input type=hidden id="parm" name="parm" />
</form>


<script type="text/javascript">
	$(function() {
		// Page Load 완료 처리
		_PAGE_LOAD_CHECK = true;
	});
</script>

</body>
</html>
