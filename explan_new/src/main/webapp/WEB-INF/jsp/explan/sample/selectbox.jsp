<%@ page contentType='text/html;charset=utf-8' errorPage="/vocm/common/VCommonErrorVW.jsp" %>

<%@include  file="/modelo/include/header.jsp" %>

<script>
	// 스크립트 작성 부분
	
	$(function() {
		
 		var optionList = {
			"OPT1" : "옵션1",	
			"OPT2" : "옵션2",	
			"OPT3" : "옵션3"	
		}
		fn_addJsonToSelectBox("sbox", optionList);
		
		_SVC_COM.setSelectBoxProductGroup("pglist");
		
		$("#pglist").change(function() {
			_SVC_COM.setSelectBoxProduct("plist", this.value);
		});
 
		_SVC_COM.setSelectBoxByCodeBook("ITEM_CATEGORY_CD", "codeBook");
	});
	
	
</script>

<!-- UI 작성 부분 -->

<div>
	<select id="sbox" name="sbox"></select>
	<br/><br/><br/>
	<select id="pglist" name="pglist"></select>
	<br/><br/><br/>
	<select id="plist" name="plist"></select>
	<br/><br/><br/>
	<select id="codeBook" name="codeBook"></select>
</div>

<%@include  file="/modelo/include/footer.jsp" %>
