<%@ page contentType='text/html;charset=utf-8'%>

<%-- Component Id 설정 --%>
<c:set var="comId" value="selectInsuredComponent"/>

<script type="text/javascript">

	$(function() {
	});
	
	_G_FN["${comId}"] = {
		/* 콜백함수 필수 등록 */
		callback 						: undefined,
		/* Parameter */
		sendParm						: undefined,
		cInsuranceGroup					: undefined,
		cInsuranceGroupBase				: undefined,
		onChangeCallBackFn		: function(){},
		init 		: function(sendParm, callback) {
			/* 필수 지정 */
			this.sendParm				= sendParm;
			this.callback 				= callback;
			this.cInsuranceGroup		= sendParm.cInsuranceGroup;
			this.cInsuranceGroupBase	= sendParm.cInsuranceGroupBase;
			this.onChangeCallBackFn		= sendParm.onChangeCallBackFn;
			
			$("#${comId}SelectBox").empty();
			
			this.setInsuredToSelectBox();
		},
		setInsuredToSelectBox : function() {
			var insuredNameMap 		= this.cInsuranceGroup.getAllInsuredNameMap();
			
			var newMap = {};
			$.each(insuredNameMap.list, function() {
				newMap[this] = "Y";
			});
			if(isValid(this.cInsuranceGroupBase)) {
				var insuredNameMapBase 	= this.cInsuranceGroupBase.getAllInsuredNameMap();
				$.each(insuredNameMapBase.list, function() {
					newMap[this] = "Y";
				});
			}
			var imap = {};
			var idx = 0;
			$.each(newMap, function(key, value) {
				imap["" + idx++] = key;
			});
			fn_addJsonToSelectBox("${comId}SelectBox", imap);
			$("#${comId}SelectBox").trigger("change");	
		},
		changeSelectBox			: function() {
			var insuredInfo 	= this.getCurrentInsuredInfo();
			var damboGroupType 	= this.getCurrentDamboGroupType();
			
			// 담보 분석 피보험자 변경시 현재 피보험자 정보 전역으로 저장
			_G_VAL["insuredInfo"] = {
				 "insuredName" 		: insuredInfo.insuredName
				,"insuredIdx"		: insuredInfo.insuredIdx
				,"damboGroupType"	: damboGroupType
			}
			_G_FN["${comId}"].onChangeCallBackFn(insuredInfo, damboGroupType);
		},
		getCurrentInsuredInfo : function() {
			var insuredIdx	= fn_getSelectBox		("${comId}SelectBox");
			var insuredName	= fn_getTextSelectBox	("${comId}SelectBox");
			return {insuredIdx : insuredIdx, insuredName : insuredName};
		},
		getCurrentDamboGroupType : function() {
			return fn_getSelectBox("${comId}DamboGroupType");
		}
	}
</script>

<div id="${comId}">
	<h4>피보험자 선택</h4>
	<div class="form_wrap">
		<table class="form_table">
			<colgroup>
				<col width="150">
				<col width="35%">
				<col width="150">
				<col width="35%">
			</colgroup>
			<tbody>
				<tr>
					<th class="ctr">피보험자 선택</th>
					<td>
						<select id="${comId}SelectBox" name="${comId}SelectBox" 			onChange="_G_FN['${comId}'].changeSelectBox();"></select>
					</td>
					<th class="ctr">담보그룹 선택</th>
					<td>
						<select id="${comId}DamboGroupType" name="${comId}DamboGroupType" 	onChange="_G_FN['${comId}'].changeSelectBox();">
							<option value="REGISTED_DAMBO"	>가입담보그룹</option>
							<option value="BASE_DAMBO"		>기본담보그룹</option>
							<option value="ALL"				>가입담보그룹 + 기본담보그룹</option>
						</select>
					</td>
				</tr>
			</tbody>
		</table>
	</div>
</div>
