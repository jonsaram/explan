<%@ page contentType='text/html;charset=utf-8'%>

		<!-- Grid Search Type Popup -->
		<%@include  file="/include/popup/selectSearchPopup.jsp" %>
		<!-- Grid Search Type Popup -->
		<%@include  file="/include/popup/selectSearchPopup2.jsp" %>
		<!-- Grid Search Type Popup -->
		<%@include  file="/include/popup/selectSearchSinglePopup.jsp" %>
		<!-- Grid Config Popup -->
		<%@include  file="/include/popup/configPopup.jsp" %>
		<!-- Toast Popup -->
		<%@include  file="/include/popup/toastPopup.jsp" %>
		</div>
		<!-- contents -->
		<br/>
		<br/>
	</div>
	<!-- //container -->
	<!-- footer -->
	<footer>
		<p>&copy; Explan 
		<span class="link"><a href="javascript:openPolicies()" class="red">Privacy Policy</a></span>
		</p>
	</footer>
	<!-- //footer -->
</div>
<!-- Progress Bar -->
<div id="loading" style="display:none;z-index:99999">
		<div id=loading_image><img src='../img/loading1.gif' /></div>                                                                                                                  
</div>

<!-- //footer -->
<div id="hiddenForm">
</div>
<script type="text/x-jsrender" id="hiddenForm_template" >
	<form id="hiddenNewWindow" name="hiddenNewWindow" method="post">
		<input type=hidden id="pageId" name="pageId" />
		<input type=hidden id="parm" name="parm" />
	</form>
</script>


<script type="text/javascript">

	initHiddenForm();
	
	$(".layer_pop_wrap").hide();
	
	$(function() {
		$(".layer_pop_wrap").show();
		
		// 도움말 처리
		
		$("[title]").each(function() {
			var title = $(this).attr("title");
			if(isValid(_DD_MAP["helpArray"][title])) $(this).attr("title", _DD_MAP["helpArray"][title]);
		});
	});
	

	$(function() {
		// Page Load 완료 처리
		_PAGE_LOAD_CHECK = true;
	});
</script>

</body>
</html>
