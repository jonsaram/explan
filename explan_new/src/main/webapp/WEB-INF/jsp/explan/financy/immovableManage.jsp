<%@ page contentType='text/html;charset=utf-8' errorPage="/vocm/common/VCommonErrorVW.jsp" %>

<%@include  file="/include/header.jsp" %>

<script>
	$(function() {
	});

	var cImmovableManage = {
		 load : function() {
			// Immovable List 읽어오기
			var parm = {
				 "sqlId" 	: "Investment.getImmovableList"
				,"planNum" 	: _SESSION["PLAN_NUM"]
			}

			var gridInfo = requestService("GET_COMMON", parm);

			var jsonData = gridInfo.data;

	  		var orderList = "[!CB],[!RN],[!HD]IMMOVABLE_NUM,IMMOVABLE_TYPE,IMMOVABLE_NAME,START_DATE,IMMOVABLE_VALUE,INFLATION_RATE,LOCATION,COMMENT,STATE";

			var stateSubId = 2;
			if(_SESSION["PLAN_TYPE"] == "제안") stateSubId = 4;

			var itemType = {
				 "orderList"	: orderList
				,"numberList" 	: ["IMMOVABLE_VALUE"	]
				,"floatList" 	: ["INFLATION_RATE"		]
				,"comboList" 	: ["IMMOVABLE_TYPE",{id:"STATE","subId":stateSubId}]
				,"emptyList"	: ["LOCATION", "COMMENT"]
			};

			var configInfo 		= explanGrid.makeConfigInfo(itemType);
	  		var columnConfig 	= configInfo.columnConfig;
	  		var validatorList 	= configInfo.validatorList;
	  		
			// 상태값 폭
	  		columnConfig["STATE"			]["width"]	= "80";
	  		
	  		// 추가 Column 속성 처리
	  		columnConfig["START_DATE"	 ]["colType"	]	= "date";
	  		
	  		columnConfig["IMMOVABLE_NAME"]["width"		]	= "150";
	  		columnConfig["IMMOVABLE_NAME"]["maxlength"	]	= "50";
	  		
	  		columnConfig["COMMENT"		 ]["width"		]	= "150";
	  		columnConfig["COMMENT"		 ]["maxlength"	]	= "2000";
//	  		columnConfig["COLUMN_NAME"]["ATTR"]	= "xxx";

	  		// Header Tooltip
// 	  		var headerToolTipMap = {
//	  			 "COLUMN_NAME" 	: "Header Tooltip 내용"
//	  		}

	  		// 추가 검증 처리
//	  		validatorList["COLUMN_NAME"] = function(cellData, gridId, rowId, colId) {
//	  			return false;
//	  		}

	  		var gridParm = {
				"targetDivId"	: "${pageId}_gridbox"
				,"orderList" 	: orderList
				,"gridData"		: jsonData
				,"cellConfig"	: {
					 "defaultConfig"	: { "align"  : "center", "width" :"150", "colType":"edtxt"}
					,"columnConfig" 	: columnConfig
				}
				,"validatorList": validatorList
				,"dataConfig"	: {"useRownum"	: true}
				,"useAutoResize": true
				,"useAutoHeight": { "margin" 	: 380 }
				,"useBlockCopy"	: true
				,"showRequired" : true						// 필수값 표시
				,"wordList"		: {"START_DATE"	: "취득일"}

				// 추가 옵션
				//// Header Tooltip
//				,"headerToolTipMap"	: headerToolTipMap

				//// Header 명을 다르게 쓸경우
//				,"wordList"			: {"COLUMN_NAME" : "xxx", ...}
			}
			var mygrid = explanGrid.makeGrid(gridParm);
		}
		,addRow : function() {
			if(!isValid(_SESSION["PLAN_NUM"])) {
				alert('고객을 선택 하세요.');
				return;
			}
			explanGrid.addRow("${pageId}_gridbox");
		}
		,delRow	: function() {
			rowIdList = explanGrid.getCheckedRowId("${pageId}_gridbox", "[!CB]");
			$.each(rowIdList, function() {
				explanGrid.deleteRowById("${pageId}_gridbox", this);
			});
		}
		,goSave	: function() {
			if(!isValid(_SESSION["PLAN_NUM"])) {
				alert('고객을 선택 하세요.');
				return;
			}

			var isEmpty = explanGrid.isEmpty("${pageId}_gridbox");
	
			// 삭제 Investment Number List
			var immovableDelList = explanGrid.getDeletedCols("${pageId}_gridbox", "IMMOVABLE_NUM");
	
			if(immovableDelList.length > 0) isEmpty = false;
	
			if(isEmpty) {
				alert("저장 할 내용이 없습니다.");
				return;
			}

			var changeCheck = explanGrid.isChanged("${pageId}_gridbox");
			if(!changeCheck) {
				alert("변경 내용이 없습니다.");
				return;
			}

			var jsonData 	= explanGrid.getGridToJson("${pageId}_gridbox", null, "C");

			var resultMap 	= explanGrid.validCheckAllGrid("${pageId}_gridbox");

			if(!resultMap.valid) {
				alert(resultMap.getMsg());
				return;
			}

			// 삭제 Plan Number List
			var immovableDelList = explanGrid.getDeletedCols("${pageId}_gridbox", "IMMOVABLE_NUM");

			var sendParm = {
				 "planNum"			: _SESSION["PLAN_NUM"]
				,"immovableDelList"	: immovableDelList
				,"immovableList" 	: jsonData
			}

			var gridInfo = requestService("SAVE_IMMOVABLE_LIST", sendParm);

			if(gridInfo.state == "S"){
				alert('저장 되었습니다.');

				this.load();

				explanGrid.clearChanged("${pageId}_gridbox");

			} else 	{
				alert(gridInfo.msg);
			}
		}
		// 선택 예/적금 가져오기
		,importImmovable : function(subId) {
			if(isEmpty(_SESSION["PLAN_NUM"])) {
				alert('고객을 선택하세요.');
				return;
			}
			_SVC_POPUP.setConfig("importImmovablePopup", {}, function(returnData) {
				if(returnData == 'S') {
					cImmovableManage.load();
				}
			});
			_SVC_POPUP.show("importImmovablePopup");
		}
	}
</script>
<!-- UI 작성 부분 -->

<h3>부동산 관리</h3>

<%@include  file="/include/component/customerInfoComponent.jsp" %>
<script>
	// Component 초기화
	_SVC_COM.initComponent("customerInfoComponent", {}, function(type) {
		if(type == "reload") cImmovableManage.load();
	});
</script>

<br/>
<div>
	<div class="list_wrap" style="min-width:800px">
		<div class="list_head">
			<div class="button" id="btnEdit">
				<span class="btn_list"><a href="javascript:cImmovableManage.addRow();">부동산추가</a></span>
				<span class="btn_list"><a href="javascript:cImmovableManage.delRow();">부동산삭제</a></span>
				<span class="btn_list"><a href="javascript:cImmovableManage.goSave();">저장</a></span>
				<span class="btn_list"><a href="javascript:cImmovableManage.load()  ;">새로고침</a></span>
			</div>
			<div class="setting">
				<span class="btn_list"><a href="javascript:cImmovableManage.importImmovable();">부동산 가져오기</a></span>
			</div>
		</div>
		<div style="width:100%;height:400px">
			<div id="${pageId}_gridbox" style="width:100%;height:100%;"></div>
		</div>
</div>

<div class="page_button"><span class="btn_page"><a href="javascript:cImmovableManage.goSave()">저장</a></span></div>

<!-- Add Investment Popup -->
<%@include  file="/include/popup/importImmovablePopup.jsp" %>

<%@include  file="/include/footer.jsp" %>