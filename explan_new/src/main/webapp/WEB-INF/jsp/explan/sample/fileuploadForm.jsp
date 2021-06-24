<%@ page import= 	'java.io.*,
					 java.util.*, 
					 java.text.*,
					 javax.servlet.http.*,
					 modelo.util.*'
%>

<%@include  file="/modelo/include/headerBaseSet.jsp" %>

<%
	String docid          = CommonAPI.defaultString((String)request.getAttribute("docid"),"");
%>

<script type="text/javascript">
	function OnLoading()
	{
		var theURL = "http://<%=domainUrl%>/servlet/modelo.common.servlet.MainServlet?pageId=FILEUPLOAD_PROCESS&docid=<%=docid%>";
		var FileUploadMonitor = document.getElementById("FileUploadMonitor");
		FileUploadMonitor.UploadURL = theURL;
		FileUploadMonitor.CodePage = 65001;
		FileUploadMonitor.CheckAutoCloseWindow = true;
		//FileUploadMonitor.EnableAddFolderButton  = false; //폴더추가
	
	}
	function fn_OnFileMonitorError(nCode, sMsg, sDetailMsg)
	{
		if(20000106 == nCode)
		{
			var arr = sMsg.split("\"");
	
			alert(" Duplicate file. Try again. Path :"+arr[1]);
	
		}else if(30000123 == nCode){
			 var arr = sMsg.split("\"");
	
			alert(" Check. Http Protocol :"+arr[1]);
	
		}else{
			alert(" DEXTUploadException  :"+sMsg);
		}
	}
	
	function fn_doClose() {
		window.returnValue="<%=docid%>";
		self.close();
	}
</script>



<!-- Dext upload ActiveX에서 사용하는 Script -->

<script type="text/javascript" for="FileUploadMonitor" event="OnCreationComplete()">
	OnLoading();
</script>

<script  type="text/javascript" LANGUAGE="javascript" for="FileUploadMonitor" Event="OnChangedStatus()">  ;
	var FileItem = document.getElementById("FileUploadMonitor");
	var FileSize = 0;
	for (i = 1; i < FileItem.Count + 1 ; i++) {
		FileSize = FileSize + FileItem.Item(i).Size;
		if(FileSize>(9*1024*1024))
		{
			alert("The size limit of 9MByte has been exceeded.");
			document.getElementById("FileUploadMonitor").DeleteSelectedFile(i);
		}
	}
</script>


<script  type="text/javascript" LANGUAGE="javascript" FOR="FileUploadMonitor" Event="OnError(nCode, sMsg, sDetailMsg)">
	fn_OnFileMonitorError(nCode, sMsg, sDetailMsg);
</script>


<script  type="text/javascript" LANGUAGE="javascript" for="FileUploadMonitor" Event="OnTransferCancel()">
	alert( "전송이 취소되었습니다.");
</script>

<script  type="text/javascript" LANGUAGE="javascript" for="FileUploadMonitor" Event="OnTransferComplete()">
	//alert( "전송을 완료했습니다.");
</script>


<script  type="text/javascript" LANGUAGE="javascript" for="FileUploadMonitor" Event="OnCloseWIndow()">
	//alert("창을 닫습니다.");
	fn_doClose();
</script>

<script type="text/javascript">

	var strScripts ='';
	
	strScripts += '<OBJECT id="FileUploadMonitor" height="335" width="445" ';
	strScripts += '		codeBase="/cabs/dextupload/DEXTUploadX.cab#version=3,2,10,0" ';
	strScripts += '		classid="CLSID:96A93E40-E5F8-497A-B029-8D8156DE09C5" VIEWASTEXT> ';
	strScripts += '			<PARAM NAME="Filter" VALUE="';
	
	strScripts += '*.7z;*.a00;*.a01;*.ai;*.alz;*.asf;*.avi;*.bkg;*.bmp;';
	strScripts += '*.cfg;*.cgm;*.cgm;*.csv;*.dms;*.doc;*.docx;';
	strScripts += '*.eml;*.eps;*.fsc;*.gif;*.gul;*.hwp;';
	strScripts += '*.icn;*.java;*.jpg;*.jt;*.mgr;*.mht;*.mpg;*.pdf;*.plt;';
	strScripts += '*.png;*.pps;*.ppt;*.pptx;*.rar;*.rqv;*.rtf;*.shs;*.sql;';
	strScripts += '*.tif;*.txt;*.wmv;*.xls;*.xlsx;*.zip;';
	
	strScripts += '">';
	
	
	strScripts += '</OBJECT> ';
	
	document.write(strScripts);
	
</script>

<%@include  file="/modelo/include/footerBaseSet.jsp" %>