<%@ page contentType='text/html;charset=utf-8' errorPage="/vocm/common/VCommonErrorVW.jsp" %>

<%@include  file="/modelo/include/header.jsp" %>

<script>
	$(function() {
		var fileList = _SVC_FILE.getFileList("20141125150013220");
		dwrite(fileList);
	});

	//파일 업로드
	function doFileUpload(docid)
	{
		if(docid == undefined) docid = ""
		var theURL = "/servlet/modelo.common.servlet.MainServlet?pageId=FILEUPLOAD_FORM&docid=" + docid;
		var retVal = window.showModalDialog(theURL, "pop", "dialogWidth:445px;dialogHeight:335px;scroll:no;status:no;resizable:no;toolbar:no;location:no");
		dwrite(retVal);
	}
</script>
Attached Files
<span class="btn_list"><a><span class="ico_del"></span><label onClick="doFileUpload();" title="파일선택">Select</label></a></span>
<span class="btn_list"><a><label onClick="doFileDelete();" title="파일삭제">Delete</label></a></span>
<input type="hidden" id="up_docid" name="req_docid" value="">
<form id="searchFrm">
	<div class="srch_form">
		 <table class="srch_table" id="filelisttable">
			<colgroup>
			<col width="130"/>
			<col width="100%"/>
			</colgroup>
				<tr>
				<th rowspan="1000">Files Attached&nbsp;&nbsp;<input type="checkbox" class="layer_select" id="fileAllClick"></th>
				<td>
				</td>
			</tr>
		</table>
	</div>
</form>

<%@include  file="/modelo/include/footer.jsp" %>