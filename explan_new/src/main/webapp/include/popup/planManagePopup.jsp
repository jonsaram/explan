<%@ page contentType='text/html;charset=utf-8'%>

<%-- 
	-- Popup 호출 하는 방법 예제
	
	_SVC_POPUP.setConfig("popupIdPmp", sendParm, function(returnData) {
		alert(returnData);
	});
	_SVC_POPUP.show("popupIdPmp");

 --%>

<%-- Popup Id 설정 --%>
<c:set var="popupIdPmp" value="planManagePopup"/>
<script type="text/javascript">

	$(function() {
		_SVC_POPUP.initPopup("${popupIdPmp}");
	});
	
	_G_FN["${popupIdPmp}"] = {
		CUSTOMER_NUM	: undefined,
		/* 콜백함수 필수 등록 */
		callback 	: undefined,
		init 		: function(sendParm, callback) {
			/* 필수 지정 */
			this.callback = callback;

			if(sendParm != undefined) this.CUSTOMER_NUM = sendParm.CUSTOMER_NUM
			
			/* Module 초기화 */
			this.loadData();
			
			
		},
		loadData : function() {
			var resultData = requestService("GET_PLAN_LIST", {"CUSTOMER_NUM" : this.CUSTOMER_NUM});

			var jsonData = resultData.data;
			
			// _DD_MAP 에 BASE_PLAN_NAME 으로 기본 플랜 Setting.
			_DD_MAP["BASE_PLAN_NAME"] = {};
			
			$.each(jsonData, function() {
				if(this.PLAN_TYPE == "기본") _DD_MAP["BASE_PLAN_NAME"][this.PLAN_NUM] = this.PLAN_NAME
			});
	  		var orderList = "[!CB],[!RN],[!HD]PLAN_NUM,PLAN_NAME,START_DATE,CREATE_DATE,PLAN_TYPE,BASE_PLAN_NAME,[!HD]BASE_PLAN_NUM,[!HD]COPY_FLAG";
	  		
			var itemType = {
				 "orderList"	: orderList
				,"comboList" 	: ["PLAN_TYPE"]
				,"searchList2"	: [["BASE_PLAN_NAME", "BASE_PLAN_NUM"]]
			};
	  		
			var configInfo = explanGrid.makeConfigInfo(itemType);
	  		
	  		var columnConfig 	= configInfo.columnConfig;

	  		var validatorList 	= configInfo.validatorList;
	  		
			validatorList["BASE_PLAN_NAME"] = function(cellData, gridId, rowId, colId) {
				var rowData = explanGrid.getRowData(gridId, rowId);
				if(rowData["PLAN_TYPE"] == "제안" && !isValid(cellData)) 	return false;
				else 														return true;
			}			

			columnConfig["CREATE_DATE"] = { "colType" : "ro"}
	  		columnConfig["START_DATE"] 	= { "colType" : "birth"}
			
	  		var gridParm = {
				"targetDivId"	: "${popupIdPmp}_gridbox"
				,"orderList" 	: orderList
				,"gridData"		: jsonData
				,"cellConfig"	: { 
					 "defaultConfig": { "align"  : "center", "width" :"*", "colType":"edtxt"}
					,"columnConfig" : columnConfig
				}
				,"validatorList": validatorList
				,"wordList"		: _SVC_COM.getWordListMap(["CUSTOMER"])
				,"dataConfig"	: {"useRownum"		: true}
				,"useBlockCopy"	: true
			}
			var mygrid = explanGrid.makeGrid(gridParm);
 			
	  		// 기본 플랜은 삭제 불가
	  		explanGrid.setDisabled("${popupIdPmp}_gridbox", 0, "[!CB]", true);
	  		
	  		// Event 등록
	  		explanGrid.attachEvent("${popupIdPmp}_gridbox", "onChange"		, _G_FN["${popupIdPmp}"].onChangeProcess);
	  		
	  		explanGrid.attachEvent("${popupIdPmp}_gridbox", "onAfterPopup"	, _G_FN["${popupIdPmp}"].onAfterPopupProcess);
	  		
	  		//explanGrid.triggerAllRowOnChange("${popupIdPmp}_gridbox", "PLAN_TYPE");
	  		// init BASE_PLAN
			var rowIds 		= mygrid.getAllRowIds();
			var rowIdList 	= rowIds.split(",");
			var gridId		= "${popupIdPmp}_gridbox";
			var firstRowId	= -1;
			$.each(rowIdList, function() {
				// 첫번째 rowId 저장
				if(firstRowId == -1) firstRowId = this;
				var rowId 		= this;
				var rowData 	= explanGrid.getRowData(gridId, rowId);
				var nValue		= rowData["PLAN_TYPE"];
				var bool 		= true;
				if	(nValue == "기본") {
					explanGrid.setDisabledById	(gridId, rowId, "BASE_PLAN_NAME", true	);
					explanGrid.setValueById		(gridId, rowId, "BASE_PLAN_NAME", ""	);
					explanGrid.setValueById		(gridId, rowId, "BASE_PLAN_NUM"	, ""	);
				} else {
					//explanGrid.setDisabledById	(gridId, rowId, "START_DATE"	, true	);
					explanGrid.setDisabledById	(gridId, rowId, "BASE_PLAN_NAME", false);
				}
			});
			
	  		// 기본 plan type은 변경 불가 설정
			explanGrid.setDisabledById	(gridId, firstRowId, "PLAN_TYPE", true	);
	  		
			explanGrid.clearChanged("${popupIdPmp}_gridbox");
		},
		onChangeProcess : function(gridId, rowId, colId, val, ctype, rowData){
			
			if 	(colId == "PLAN_NAME" && ctype == "CC") {
				var planNameList = explanGrid.getGridToJson(gridId, ["PLAN_NAME"]);
				var cList = {};
				var duple = false;
				$.each(planNameList, function() {
					if(!isValid(this.PLAN_NAME,1)) return true;
					if(cList[this.PLAN_NAME] == undefined) cList[this.PLAN_NAME] = "Y";
					else {
						duple = true;
						return false;
					}
				});
				if(duple) {
					alert('동일한 플랜이름이 있습니다.');
					explanGrid.pauseEvent("${popupIdPmp}_gridbox", "onChange");
					explanGrid.setValueById(gridId, rowId, "PLAN_NAME", "");
					explanGrid.releaseEvent("${popupIdPmp}_gridbox", "onChange");
				}
			} else if 	(colId == "PLAN_TYPE" && ctype == "CC") {
				var bool = true;
				if	(val == "기본") bool = true;
				else				bool = false;
				explanGrid.setDisabledById	(gridId, rowId, "BASE_PLAN_NAME", bool);
				explanGrid.pauseEvent  		("${popupIdPmp}_gridbox"	, "onChange");
				explanGrid.setValueById		(gridId, rowId, "BASE_PLAN_NAME"	, "");
				explanGrid.setValueById		(gridId, rowId, "BASE_PLAN_NUM"	, "");
				explanGrid.releaseEvent		("${popupIdPmp}_gridbox"	, "onChange");
				
				var orgRowData = explanGrid.getOrgDataByRowId(gridId, rowId);
			}
		},
		onAfterPopupProcess : function(parm) {
			if(parm.columnId == "BASE_PLAN_NAME") {
				var val = explanGrid.getValueById(parm.gridId, parm.rowId, "PLAN_NUM");
				if(parm.code == val) {
					alert('동일한 플랜을 기본 플랜으로 선택 할 수 없습니다.');
					return false;
				}
				return true;
			}
			return false;
		},
		openAddPlanPopup : function() {
			_SVC_POPUP.setConfig("addPlanPopup", {}, function(returnData) {
				
			});
			_SVC_POPUP.show("addPlanPopup");
		},
		addRow : function() {
			var rowId = explanGrid.addRow("${popupIdPmp}_gridbox");
			explanGrid.setValueById("${popupIdPmp}_gridbox", rowId, "CREATE_DATE", "자동입력");
		},
		delRow : function() {
			rowIdList = explanGrid.getCheckedRowId("${popupIdPmp}_gridbox", "[!CB]");
			$.each(rowIdList, function() {
				explanGrid.deleteRowById("${popupIdPmp}_gridbox", this);
			});
		},
		goSave : function() {
			var isEmpty = explanGrid.isEmpty("${popupIdPmp}_gridbox");
			if(isEmpty) {
				alert("저장 할 내용이 없습니다.");
				return;
			}
			var changeCheck = explanGrid.isChanged("${popupIdPmp}_gridbox");
			if(!changeCheck) {
				alert("변경 내용이 없습니다.");
				return;
			}
			
			var jsonData 	= explanGrid.getGridToJson("${popupIdPmp}_gridbox", null, "C");
			
			// 삭제 Plan Number List
			var deletedPlanNumList = explanGrid.getDeletedCols("${popupIdPmp}_gridbox", "PLAN_NUM");
			
			var resultMap = explanGrid.validCheckAllGrid("${popupIdPmp}_gridbox");
			
			if(!resultMap.valid) {
				alert(resultMap.getMsg());
				return;
			}
			// 제안 Plan의 기본플랜 중 제안 Type으로 설정 된 항목을 Check
			var jsonFullData 	= explanGrid.getGridToJson("${popupIdPmp}_gridbox", null);
			var typeMap = arrayToMap(jsonFullData, "PLAN_NUM", "PLAN_TYPE");
			var errorFlag = false;
			$.each(jsonFullData, function() {
				if(this.PLAN_TYPE == "제안" && typeMap[this["BASE_PLAN_NUM"]] != "기본") errorFlag = true;
			});
			// 제안 Plan의 기본플랜으로 제안 플랜을 설정한 경우 Error
			if(errorFlag) {
				alert('제안Type Plan의 기본플랜으로 기본Type Plan을 선택 해야 합니다.');
				return;
			}
			
			var sendParm = {
				"customerNum"		: this.CUSTOMER_NUM		,
				"deletedPlanNumList": deletedPlanNumList	,
				"planList" 			: jsonData
			}
 			var resultInfo = requestService("SAVE_PLAN_LIST", sendParm);

			if(resultInfo.state == "S"){
				alert('저장 되었습니다.');
				
				explanGrid.clearChanged("${popupIdPmp}_gridbox");
				
				this.callback();
				
			} else 	{
				alert(resultInfo.msg);
			}
		},
		close : function(retParm) {
			_SVC_POPUP.hide("${popupIdPmp}");
		}
	}
</script>

<div class="layer_pop_wrap" id="${popupIdPmp}"  style="visibility:hidden">
	<div class="layer_pop" style="width:800px" id="${popupIdPmp}_layer_pop">
		<div class="tit_layer">플랜 관리</div>
		<div class="contents" id="${popupIdPmp}_contents">
			<div class="list_head">
				<div class="button" id="btnEdit">
					<span class="btn_list"><a href="javascript:_G_FN['${popupIdPmp}'].addRow();">새플랜추가</a></span>
					<span class="btn_list"><a href="javascript:_G_FN['${popupIdPmp}'].delRow();">플랜삭제</a></span>
					<span class="btn_list"><a href="javascript:_G_FN['${popupIdPmp}'].goSave();">저장</a></span>
				</div>
			</div>
			<div class="list_wrap" style="width:100%;height:300px">
				<div id="${popupIdPmp}_gridbox" style="width:100%;height:100%;"></div>
			</div>
		</div>
		<div class="pop_button">
			<span class="btn_page"><a href="javascript:_G_FN['${popupIdPmp}'].close()">Close</a></span>
		</div>
	</div>
</div>

<!-- Dambo Group Info Manage Popup -->
<%@include  file="/include/popup/addPlanPopup.jsp" %>
