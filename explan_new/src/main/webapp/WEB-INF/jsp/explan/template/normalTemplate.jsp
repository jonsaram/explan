<%@ page language="java" errorPage="/explan/common/error.jsp" pageEncoding="UTF-8" contentType="text/html;charset=utf-8" %>

<%@include  file="/include/header.jsp" %>

<script>
	var cTemplateManage = {
		 load : function() {
			// Template List 읽어오기
			var parm = {
				 "sqlId" 	: "Investment.getImmovableList"
				,"planNum" 	: _SESSION["PLAN_NUM"]
			}

			var gridInfo = requestService("GET_COMMON", parm);

			var jsonData = gridInfo.data;

	  		var orderList = "[!CB],[!RN],[!HD]IMMOVABLE_NUM,IMMOVABLE_TYPE,IMMOVABLE_NAME,START_DATE,IMMOVABLE_VALUE,INFLATION_RATE,LOCATION,COMMENT";

			var itemType = {
				 "orderList"	: orderList
/* 				,"numberList" 	: ["IMMOVABLE_VALUE"	]
				,"floatList" 	: ["INFLATION_RATE"		]
				,"comboList" 	: ["IMMOVABLE_TYPE"		]
				,"emptyList"	: ["LOCATION", "COMMENT"]
 */			};

			var configInfo 		= explanGrid.makeConfigInfo(itemType);
	  		var columnConfig 	= configInfo.columnConfig;
	  		var validatorList 	= configInfo.validatorList;
	  		
	  		// 추가 Column 속성 처리
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
				,"dataConfig"	: {"useRownum"		: true}
				,"useAutoResize": true
				,"useAutoHeight": { "margin" : 380 }
				,"useBlockCopy"	: true
				,"showRequired" : true						// 필수값 표시
				// 추가 옵션
				//// Header Tooltip
//				,"headerToolTipMap"	: headerToolTipMap

				//// Header 명을 다르게 쓸경우
//				,"wordList"			: {"COLUMN_NAME" : "xxx", ...}
//				,"callback"			: function (mygrid) {
//			  		explanGrid.attachEvent			("${pageId}_gridbox", "onChange"		, cInvestmentManage.onChangeProcess);
//				}
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
	}
</script>

<h3>Title</h3>

<%@include  file="/include/component/customerInfoComponent.jsp" %>

<script>
	// Component 초기화
	_SVC_COM.initComponent("customerInfoComponent", {}, function(type) {
		if(type == "reload") cTemplateManage.load();
	});
</script>

<br/>
<div>
	<div class="list_wrap" style="min-width:800px">
		<div class="list_head">
			<div class="button" id="btnEdit">
				<span class="btn_list"><a href="javascript:cTemplateManage.addRow();">추가</a></span>
				<span class="btn_list"><a href="javascript:cTemplateManage.delRow();">삭제</a></span>
				<span class="btn_list"><a href="javascript:cTemplateManage.goSave();">저장</a></span>
				<span class="btn_list"><a href="javascript:cTemplateManage.load()  ;">새로고침</a></span>
			</div>
		</div>
		<div style="width:100%;height:400px">
			<div id="${pageId}_gridbox" style="width:100%;height:100%;"></div>
		</div>
</div>

<div class="page_button"><span class="btn_page"><a href="javascript:cTemplateManage.goSave()">저장</a></span></div>

<%@include  file="/include/footer.jsp" %>
