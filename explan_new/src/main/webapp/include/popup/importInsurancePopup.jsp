<%@ page contentType='text/html;charset=utf-8'%>

<%-- 
	보험 가져오기
 --%>
<%-- Popup Id 설정 --%>
<c:set var="popupIdImpIns" value="importInsurancePopup"/>

<script type="text/javascript">

	$(function() {
		_SVC_POPUP.initPopup("${popupIdImpIns}");
	});
	
	_G_FN["${popupIdImpIns}"] = {
		/* 콜백함수 필수 등록 */
		callback 	: undefined,
		customerMap	: {},
		init 		: function(sendParm, callback) {
			/* 필수 지정 */
			this.callback = callback;
			
			// 서비스 요청
			var gridInfo = requestService("GET_COMMON", {"sqlId" : "Customer.getCommonCustomerList"}, "C");

			var jsonData = gridInfo.data;
			
			var selectMap = arrayToMap(jsonData, "CUSTOMER_NUM", "CUSTOMER_NAME"); 
			
			/* Module 초기화 */
			fn_addJsonToSelectBox("${popupIdImpIns}_customerList", {"" : "선택"}, true);
			fn_addJsonToSelectBox("${popupIdImpIns}_customerList", selectMap);
			
			_G_FN["${popupIdImpIns}"].customerMap = arrayToMap(jsonData, "CUSTOMER_NUM");
			
			_G_FN["${popupIdImpIns}"].setPlanList();
		},
		// 고객명이 변경 되었을경우 Plan load
		changeCustomer 	: function(customerNum) {
			_G_FN["${popupIdImpIns}"].setPlanList(customerNum);
		},
		setPlanList : function (customerNum) {
			if(customerNum == "empty" || !isValid(customerNum)) {
				fn_addJsonToSelectBox("${popupIdImpIns}_planList", {"" : "선택"}, true);
			} else {
				var resultData = requestService("GET_PLAN_LIST", {"CUSTOMER_NUM" : customerNum});
				var planMap = {};
				this.planInfoMap = arrayToMap(resultData.data, "PLAN_NUM");
				var firstPlanNum = undefined; 
				$.each(resultData.data, function() {
					var planNum = this.PLAN_NUM;
					var startDate = getDateFormat(this.START_DATE, 8);
					var planInfo = this.PLAN_NAME + " ("+startDate+")";
					planMap[planNum] = planInfo;
					this.startDate = startDate;
					if(firstPlanNum == undefined) firstPlanNum = planNum;
				});
				fn_addJsonToSelectBox("${popupIdImpIns}_planList", planMap, true);
			}
			_G_FN["${popupIdImpIns}"].loadInsuranceList();
		},
		changePlan : function() {
			_G_FN["${popupIdImpIns}"].loadInsuranceList();
		},
		loadInsuranceList : function() {
			
			var selectedPlanNum = fn_getSelectBox("${popupIdImpIns}_planList");
			
			// 서비스 요청
			var parm = {
				 "sqlId" 	: "Insurance.getInsuranceList"	
				,"planNum" 	: selectedPlanNum
			}
			var resultInfo = requestService("GET_COMMON", parm);

			var jsonData = resultInfo.data;
			
			var orderList = "[!CB],[!RN]No.,[!HD]INSURANCE_NUM,INSURANCE_TYPE,COMPANY_NAME,TITLE,CONTRACTOR,INSURED_INFO,PAY_EACH_MONTH,START_DATE,GUARANTEE_TERM,GUARANTEE_TERM_TYPE,PAY_TERM,PAY_TERM_TYPE";
			
			var itemType = {
				 "orderList"	: orderList
				,"numberList" 	: ["GUARANTEE_TERM","PAY_TERM","PAY_EACH_MONTH"]
			};
			
	  		var configInfo = explanGrid.makeConfigInfo(itemType, "ro");

	  		var columnConfig 	= configInfo.columnConfig;
	  		
	  		var validatorList 	= configInfo.validatorList;
	  		
	  		columnConfig["GUARANTEE_TERM"		]["width"] = "80";
	  		columnConfig["PAY_TERM"				]["width"] = "80";
	  		columnConfig["PAY_TERM_TYPE"		] = { "width"  : "70" };
	  		columnConfig["GUARANTEE_TERM_TYPE"	] = { "width"  : "70" };
	  		columnConfig["INSURED_INFO"			] = { "colType" : "insuredro", "width" : "150", "align" : "left"}
	  		
	  		var gridParm = {
				"targetDivId"	: "${popupIdImpIns}_gridbox",
				"orderList" 	: orderList,
				"gridData"		: jsonData,
				"cellConfig"	: {
					"defaultConfig" : { "align"  : "center", "width" :"*", "colType":"ro"},
					"columnConfig" 	: columnConfig
				},
				"validatorList"	: validatorList,
				"dataConfig"	: {"useRownum"		: true},
				"useAutoResize"	: true,
				"useAutoHeight"	: { "margin" : 340 },
				"useBlockCopy"	: true,
				"wordList"		: { "START_DATE" : "가입일"}	// 기본 word.js에 등록되어 있는 항목과 중복이지만 이름이 다른경우 별도 지정
			}
			var mygrid = explanGrid.makeGrid(gridParm);
		},
		// 선택보험 가져오기
		importSelected : function() {
			var rowIdList = explanGrid.getCheckedRowId("${popupIdImpIns}_gridbox", "[!CB]");
			if(rowIdList.length == 0) {
				alert("선택된 항목이 없습니다.");
				return;
			}
			// 대상 Insurance Num 을 가져온다.
			var insuranceNumList = [];
			
			$.each(rowIdList, function() {
				var rowData = explanGrid.getRowData("${popupIdImpIns}_gridbox", this, ["INSURANCE_NUM"]);
				insuranceNumList.push(rowData);
			});
			var parm = {
				 "PLAN_NUM" 		: _SESSION["PLAN_NUM"]
				,"insuranceNumList"	: insuranceNumList
			}
			
			var resultInfo = requestService("COPY_INSURANCE_LIST", parm);
			
			if(resultInfo.state == "S"){
				alert('가져오기가 완료 되었습니다.');
				_G_FN['${popupIdImpIns}'].close('S');
			} else 	{
				alert(resultInfo.msg);
			}
		},
		close : function(retParm) {
			this.callback(retParm);
			_SVC_POPUP.hide("${popupIdImpIns}");
		}
	}
</script>

<div class="layer_pop_wrap" id="${popupIdImpIns}">
	<div class="layer_pop" style="width:1100px" id="${popupIdImpIns}_layer_pop">
		<div class="tit_layer">보험 가져 오기</div>
		<div class="contents" id="${popupIdImpIns}_contents">
			<div class="table_wrap" style="margin-bottom:10px">
				<table class="list_table">
					<colgroup>
						<col width="150">
						<col width="400">
						<col width="150">
						<col width="400">
					</colgroup>
					<tbody>
						<tr>
							<th>고객 선택</th>
							<td>
								<div class="button" id="btnEdit">
									<select id="${popupIdImpIns}_customerList" name="${popupIdImpIns}_customerList" onChange="_G_FN['${popupIdImpIns}'].changeCustomer(this.value);"></select>
								</div>
							</td>
							<th>Plan 선택</th>
							<td>
								<div class="button" id="btnEdit">
									<select id="${popupIdImpIns}_planList" name="${popupIdImpIns}_planList" onChange="_G_FN['${popupIdImpIns}'].changePlan()"></select>
								</div>
							</td>
						</tr>
					</tbody>
				</table>
			</div>
			<div class="list_wrap">
				<div class="list_head">
					<div class="button" id="btnEdit">
						<span class="btn_list"><a href="javascript:_G_FN['${popupIdImpIns}'].importSelected();">선택보험 가져오기</a></span>
					</div>
				</div>
				<div style="width:100%;height:200px">
					<div id="${popupIdImpIns}_gridbox" style="width:100%;height:100%"></div>				
				</div>
			</div>
			
		</div>
		<div class="pop_button">
			<span class="btn_page"><a href="javascript:_G_FN['${popupIdImpIns}'].close()">Close</a></span>
		</div>
	</div>
</div>
