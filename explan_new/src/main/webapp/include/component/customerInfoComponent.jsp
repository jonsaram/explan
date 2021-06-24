<%@ page contentType='text/html;charset=utf-8'%>

<%-- Component Id 설정 --%>
<c:set var="comId" value="customerInfoComponent"/>

<script type="text/javascript">

	$(function() {
	});
	
	_G_FN["${comId}"] = {
		//기본 변수
		planInfoMap : {},
		/* 콜백함수 필수 등록 */
		callback 	: undefined,
		init 		: function(sendParm, callback) {
			/* 필수 지정 */
			this.callback = callback;
			if(!isValid(sendParm,1)) sendParm = {};
			
			// 서비스 요청
			var gridInfo = requestService("GET_COMMON", {"sqlId" : "Customer.getCustomerList"}, "C");

			var jsonData = gridInfo.data;
			
			var selectMap = arrayToMap(jsonData, "CUSTOMER_NUM", "CUSTOMER_NAME"); 
			
			/* Module 초기화 */
			fn_addJsonToSelectBox("${comId}_customerList", {"" : "선택"}, true);
			fn_addJsonToSelectBox("${comId}_customerList", selectMap);
			
			var customerMap = arrayToMap(jsonData, "CUSTOMER_NUM"); 
			$("#${comId}_customerList").change(function() {
				var customerInfo = customerMap[this.value];
				if(customerInfo == undefined) {
					$("#${comId}_customerInfo #BIRTHDAY").html("");
					$("#${comId}_customerInfo #PHONE_NUM").html("");
					// 고객 Session 삭제
					setCommonSession("CUSTOMER_NUM", "");
					_G_FN["${comId}"].setPlanList("empty");
				} else {
					$("#${comId}_customerInfo #BIRTHDAY").html(getDateFormat(customerInfo.BIRTHDAY, 8, "-"));
					$("#${comId}_customerInfo #PHONE_NUM").html(customerInfo.PHONE_NUM);
					// 현재 선택된 고객 Session에 저장
					setCommonSession("CUSTOMER_NUM"	, customerInfo.CUSTOMER_NUM);
					setCommonSession("BIRTHDAY"		, customerInfo.BIRTHDAY);
					_G_FN["${comId}"].setPlanList(customerInfo.CUSTOMER_NUM);
				}
				var callback = _G_FN["${comId}"].callback;
				if(typeof callback == "function") callback("reload");
			});
			
			// 기존에 선택된 고객 선택 처리
			var customerNum = _SESSION["CUSTOMER_NUM"];
			if(isValid(customerNum)) fn_setSelectBox("${comId}_customerList", customerNum);
			$("#${comId}_customerList").trigger("change");
		},
		getSelectedCustomerNum : function() {
			return _SESSION["CUSTOMER_NUM"];
		},
		setPlanList : function (customerNum) {
			if(customerNum == "empty") {
				$("#${comId}_planList").empty();
				setCommonSession("PLAN_NUM", "");
				setCommonSession("PLAN_DATE", "");
				setCommonSession("PLAN_TYPE", "");
			} else {
				var resultData = requestService("GET_PLAN_LIST", {"CUSTOMER_NUM" : customerNum});
				var planMap = {};
				this.planInfoMap = arrayToMap(resultData.data, "PLAN_NUM");
				var firstPlanNum = undefined; 
				var bePlan = false;
				$.each(resultData.data, function() {
					var planNum = this.PLAN_NUM;
					var startDate = getDateFormat(this.START_DATE, 8);
					var planInfo = this.PLAN_NAME + " ("+startDate+")";
					planMap[planNum] = planInfo;
					this.startDate = startDate;
					// 선택 플랜 정보가 있는지 확인
					if(_SESSION["PLAN_NUM"] == planNum) bePlan = true;
					if(firstPlanNum == undefined) firstPlanNum = planNum;
				});
				if(!bePlan) _SESSION["PLAN_NUM"] = undefined;
				
				fn_addJsonToSelectBox("${comId}_planList", planMap, true);
				
				if(_SESSION["PLAN_NUM"] == undefined) {
					setCommonSession("PLAN_NUM", firstPlanNum);
					if(isValid(firstPlanNum)) {
						setCommonSession("PLAN_DATE"	, this.planInfoMap[firstPlanNum]["START_DATE"]);
						setCommonSession("PLAN_TYPE"	, this.planInfoMap[firstPlanNum]["PLAN_TYPE"]);
						setCommonSession("BASE_PLAN_NUM", this.planInfoMap[firstPlanNum]["BASE_PLAN_NUM"]);
					}
				} else {
					fn_setSelectBox("${comId}_planList", _SESSION["PLAN_NUM"]);
				}
				this.setPlanDateHeader();
			}
		},
		openPlanManage : function() {
			if(!isValid(this.getSelectedCustomerNum(),1)) {
				alert('고객을 선택해주세요.');
				return;
			}
			_SVC_POPUP.setConfig("planManagePopup", {"CUSTOMER_NUM" : this.getSelectedCustomerNum()}, function(returnData) {
				var customerNum = fn_getSelectBox("${comId}_customerList");
				_G_FN["${comId}"].setPlanList(customerNum);
			});
			_SVC_POPUP.show("planManagePopup");
		},
		changePlan : function(planNum) {
			setCommonSession("PLAN_NUM"		, planNum);
			setCommonSession("PLAN_DATE"	, this.planInfoMap[planNum]["START_DATE"]);
			setCommonSession("PLAN_TYPE"	, this.planInfoMap[planNum]["PLAN_TYPE"]);
			setCommonSession("BASE_PLAN_NUM", this.planInfoMap[planNum]["BASE_PLAN_NUM"]);
			
			this.setPlanDateHeader();
			var callback = _G_FN["${comId}"].callback;
			if(typeof callback == "function") callback("reload");
		},
		setPlanDateHeader : function() {
			var planInfo = this.planInfoMap[_SESSION["PLAN_NUM"]];
			$("#${comId}_planDate").html(getDateFormat(planInfo.START_DATE) + "(" + planInfo.PLAN_NAME +  ")");
		}
	}
</script>

<div>
	<h4>Plan 기준일 : <span id="${comId}_planDate"></span></h4>
	<div class="grid_wrap" id="${comId}">
		<table class="list_table">
			<tbody>
			<colgroup>
				<col width="100">
				<col width="120">
				<col width="150">
				<col width="100">
				<col width="100">
				<col width="150">
				<col width="70">
			</colgroup>
			<tr>
				<th>고객명</th>
				<th>생년월일</th>
				<th>연락처</th>
				<th>고객상세정보</th>
				<th>문자메시지</th>
				<th>플랜선택</th>
				<th>플랜관리</th>
			</tr>
			<tr id="${comId}_customerInfo">
				<td class="ctr"><select class="select" id="${comId}_customerList" name="${comId}_customerList"></select></td>
				<td class="ctr" id="BIRTHDAY"></td>
				<td class="ctr" id="PHONE_NUM"></td>
				<td class="ctr"><span class="btn_list_sm"><a href="javascript:;">보기</a></span></td>
				<td class="ctr"><span class="btn_list_sm"><a href="javascript:;">SMS보내기</a></span></td>
				<td class="ctr"><select class="select" id="${comId}_planList" name="${comId}_planList" onChange="_G_FN['${comId}'].changePlan(this.value)"></select></td>
				<td class="ctr"><span class="btn_list_sm"><a href="javascript:_G_FN['${comId}'].openPlanManage();">관리</a></span></td>
			</tr>
			</tbody>
		</table>
	</div>
</div>

<%@include  file="/include/popup/planManagePopup.jsp" %>
