<%@ page language="java" errorPage="/explan/common/error.jsp" pageEncoding="UTF-8" contentType="text/html;charset=utf-8" %>

<%@include  file="/include/header.jsp" %>

<script>
	// 필요 Class 로드
	_SVC_COM.loadJsFile("/explan/js/class/C_CASHFLOW.js"		);
	_SVC_COM.loadJsFile("/explan/js/class/C_INSURANCE_GROUP.js"	);

	var cCashflowManage = {
		 load : function() {
			
			 // Cash Flow Class를 생성한다.
			var cCashflow = new C_CASHFLOW({planNum : _SESSION["PLAN_NUM"]});

			this.loadIncome(cCashflow);
			
 			this.loadConsume(cCashflow);
 			
			explanGrid.clearChanged("${pageId}_gridboxIncome" );
			explanGrid.clearChanged("${pageId}_gridboxConsume");
		}
		,loadIncome : function(cCashflow) {
	  		var orderList = "[!RN],[!HD]ITEM_TYPE,ITEM_NAME,ITEM_VALUE";

			var itemType = {
				 "orderList"	: orderList
 				,"mnumList" 	: ["ITEM_VALUE"]
				,"emptyList"	: ["ITEM_VALUE"]
			};

			var configInfo 		= explanGrid.makeConfigInfo(itemType);
	  		var columnConfig 	= configInfo.columnConfig;
	  		var validatorList 	= configInfo.validatorList;
	  		
	  		// 추가 Column 속성 처리
	  		columnConfig["ITEM_NAME"]["colType"]	= "ro";

	  		var addHeaderList = [["","","수입 내역(단위/만원)","#cspan"]];
	  		
	  		var gridParm = {
				 "targetDivId"		: "${pageId}_gridboxIncome"
				,"orderList" 		: orderList
				,"addHeaderList" 	: addHeaderList
				,"gridData"			: cCashflow.incomeList
				,"cellConfig"		: {
					 "defaultConfig"	: { "align"  : "left", "width" :"200", "colType":"edtxt"}
					,"columnConfig" 	: columnConfig
				}
				,"validatorList"	: validatorList
				,"dataConfig"		: {"useRownum"		: true}
				,"useBlockCopy"		: true
				,"useAutoResize"	: true
				,"useAutoHeight"	: { "margin" : 380 }
				// 추가 옵션
				//// Header Tooltip
//				,"headerToolTipMap"	: headerToolTipMap

				//// Header 명을 다르게 쓸경우
//				,"wordList"			: {"COLUMN_NAME" : "xxx", ...}
				,"callback"			: function (mygrid) {
					var gridId = "${pageId}_gridboxIncome";
					explanGrid.attachEvent	(gridId, "onChange"		, cCashflowManage.onChangeProcess);
				}
			}
			var mygrid = explanGrid.makeGrid(gridParm);

		}
		,loadConsume : function(cCashflow) {

			var orderList = "[!RN],[!HD]ITEM_TYPE,ITEM_GUBUN,ITEM_NAME,ITEM_VALUE,[!HD]sumType";

			var itemType = {
				 "orderList"	: orderList
 				,"mnumList" 	: ["ITEM_VALUE"]
				,"emptyList"	: ["ITEM_VALUE"]
			};

			var configInfo 		= explanGrid.makeConfigInfo(itemType);
	  		var columnConfig 	= configInfo.columnConfig;
	  		var validatorList 	= configInfo.validatorList;
	  		
	  		// 추가 Column 속성 처리
	  		columnConfig["ITEM_NAME"]["colType"]	= "ro";

	 		var addHeaderList = [["","","지출 구분","지출 내역(단위/만원)","#cspan",""]];

	 		var gridParm = {
				 "targetDivId"		: "${pageId}_gridboxConsume"
				,"orderList" 		: orderList
				,"addHeaderList" 	: addHeaderList
				,"gridData"			: cCashflow.consumeList
				,"cellConfig"		: {
					 "defaultConfig"	: { "align"  : "left", "width" :"150", "colType":"edtxt"}
					,"columnConfig" 	: columnConfig
				}
				,"validatorList"	: validatorList
				,"dataConfig"		: {"useRownum"		: true}
				,"mergeColName"		: "ITEM_GUBUN"
				,"useBlockCopy"		: true
				,"useAutoResize"	: true
				,"useAutoHeight"	: { "margin" : 380 }
				// 추가 옵션
				//// Header Tooltip
//				,"headerToolTipMap"	: headerToolTipMap

				//// Header 명을 다르게 쓸경우
//				,"wordList"			: {"COLUMN_NAME" : "xxx", ...}
				,"callback"			: function (mygrid) {
					var gridId = "${pageId}_gridboxConsume";
					var tRowId;
					var rowId;
					$.each(cCashflow.consumeList, function(idx) {
						rowId = explanGrid.getRowId(gridId, idx);
						if(this.readonly == "YH") {
					  		explanGrid.setDisabled			(gridId, idx, "[!RN]");
					  		explanGrid.setDisabled			(gridId, idx, "ITEM_NAME");
					  		explanGrid.setDisabled			(gridId, idx, "ITEM_VALUE");
						} else if(this.readonly == "Y") {
							explanGrid.setDisabled			(gridId, idx);		
						}
						if(this.ITEM_NAME == "계") {
							explanGrid.setBackgroundColorAtCell(gridId, rowId, null, _COLOR_CODE["계"]);
						} else if(this.ITEM_NAME == "총합") {
							explanGrid.setBackgroundColorAtCell(gridId, tRowId, null, _COLOR_CODE["총합"]);
						} 
					});
					explanGrid.setBackgroundColorAtCell(gridId, rowId, null, _COLOR_CODE["계"]);
					
			  		explanGrid.attachEvent			(gridId, "onChange"		, cCashflowManage.onChangeProcess);
		 			explanGrid.triggerGridOnChange	(gridId, 3, "ITEM_VALUE");
					explanGrid.clearChanged			(gridId);
				}
			}
			var mygrid = explanGrid.makeGrid(gridParm);
		}
		,goSave	: function() {
			if(!isValid(_SESSION["PLAN_NUM"])) {
				alert('플랜을 선택 하세요.');
				return;
			}
			
			var incomeTotal = $("#${pageId}_totalIncomeStr").html();
			if(incomeTotal == "0만원") {
				alert("수입 내역을 입력 하세요.");
				return;
			}
			var changeCheck1 = explanGrid.isChanged("${pageId}_gridboxIncome");
			var changeCheck2 = explanGrid.isChanged("${pageId}_gridboxConsume");
			if(!changeCheck1 && !changeCheck2) {
				alert("변경 내용이 없습니다.");
				return;
			}

			var resultMap = explanGrid.validCheckAllGrid("${pageId}_gridboxIncome");
			if(!resultMap.valid) {
				alert(resultMap.getMsg());
				return;
			}
			var resultMap2 = explanGrid.validCheckAllGrid("${pageId}_gridboxConsume");
			if(!resultMap2.valid) {
				alert(resultMap2.getMsg());
				return;
			}
	
			var incomeData 		= explanGrid.getGridToJson("${pageId}_gridboxIncome"	, null, "C");
			var consumeData		= explanGrid.getGridToJson("${pageId}_gridboxConsume"	, null, "C");
			
			var cashflowList 	= incomeData;
			$.each(consumeData, function(idx) {
				//if(in_array(this.ITEM_NAME, ["",""]))
				if(!isValid(this.sumType)) cashflowList.push(this);
			});

			var sendParm = {
				 "planNum"			: _SESSION["PLAN_NUM"]
				,"cashflowList"		: explanGrid.generateJsonToDbType("${pageId}_gridboxConsume", cashflowList)
			}
			var gridInfo = requestService("SAVE_CASHFLOW_LIST", sendParm);
	
			if(gridInfo.state == "S"){
				alert('저장 되었습니다.');
				
				cCashflowManage.load();
			} else 	{
				alert(gridInfo.msg);
			}
		}
		,onChangeProcess : function(gridId, rowId, colId, val, ctype, rowData) {
			if(ctype == "CC") {
				var incomeTotal	= 0;
				var consumeTotal= 0;
				var restTotal	= 0;
				var gridInfo	= explanGrid.getGrid("${pageId}_gridboxIncome");
				var mygrid 		= gridInfo.grid;
				var rowIds 		= mygrid.getAllRowIds().split(",");
				$.each(rowIds, function() {
					var v = 0;
					if(gridId == "${pageId}_gridboxIncome" && rowId == this) 	v = rowData[colId];
					else 														v = explanGrid.getValueById("${pageId}_gridboxIncome", this, "ITEM_VALUE");
					incomeTotal += Number(v);
				});
				var gridInfo2	= explanGrid.getGrid("${pageId}_gridboxConsume");
				var mygrid2		= gridInfo2.grid;
				var rowIds2		= mygrid2.getAllRowIds().split(",");
				var midTotal		= 0;
				var midTotalDiv12	= 0;
				
				$.each(rowIds2, function(idx) {
					var thisRow = explanGrid.getRowData("${pageId}_gridboxConsume", this);
					
					if(gridId == "${pageId}_gridboxConsume" && rowId == this) 	thisRow[colId] = rowData[colId];
					
					if(isValid(thisRow.sumType)) {
						if(thisRow.sumType == "A") {
							explanGrid.pauseEvent	("${pageId}_gridboxConsume"	, "onChange");
							explanGrid.setValueById("${pageId}_gridboxConsume"	, this, "ITEM_VALUE", midTotal);
							explanGrid.releaseEvent	("${pageId}_gridboxConsume"	, "onChange");
							consumeTotal += midTotal;
							midTotal = 0;
						} else if(thisRow.sumType == "B") {
							explanGrid.pauseEvent	("${pageId}_gridboxConsume"	, "onChange");
							explanGrid.setValueById("${pageId}_gridboxConsume"	, this, "ITEM_VALUE", midTotal);
							explanGrid.releaseEvent	("${pageId}_gridboxConsume"	, "onChange");
						} else if(thisRow.sumType == "C") {
							midTotal = fn_fix(midTotal / 12);
							explanGrid.pauseEvent	("${pageId}_gridboxConsume"	, "onChange");
							explanGrid.setValueById("${pageId}_gridboxConsume"	, this, "ITEM_VALUE", midTotal);
							explanGrid.releaseEvent	("${pageId}_gridboxConsume"	, "onChange");
							consumeTotal += midTotal;
						}
					} else {
						midTotal 	 += Number(thisRow["ITEM_VALUE"]);
					}
				});
				restTotal = fn_fix(incomeTotal - consumeTotal, 1);

				$("#${pageId}_totalIncomeStr"	).html(makeMoneyStr(incomeTotal));
				//$("#${pageId}_totalConsumeStr"	).html(makeMoneyStr(consumeTotal));
				$("#${pageId}_totalConsumeStr"	).html(makeMoneyStr(consumeTotal));
				// 잉여자금 Setting
				$("#${pageId}_restTotalStr"		).html(makeMoneyStr(restTotal));
			}
		}
	}
</script>

<h3>현금흐름관리</h3>

<%@include  file="/include/component/customerInfoComponent.jsp" %>

<script>
	// Component 초기화
	_SVC_COM.initComponent("customerInfoComponent", {}, function(type) {
		if(type == "reload") cCashflowManage.load();
	});
</script>

<div class="div_wrap" style="margin-top:20px">
	<div class="div_left">
		<h4>수입</h4>
		<div class="list_wrap">
			<div style="width:100%;height:400px">
				<div id="${pageId}_gridboxIncome" style="width:100%;height:100%"></div>
			</div>
		</div>
	</div>
	<div class="div_right">
		<h4>지출</h4>
		<div class="list_wrap">
			<div style="width:100%;height:400px">
				<div id="${pageId}_gridboxConsume" style="width:100%;height:100%"></div>
			</div>
		</div>
	</div>
</div>
<div>
	<table border="0" cellpadding="1" cellspacing="0" style="width:100%;margin-bottom:10px;">
		<tr>
			<td width="50%">
				<table border="0" cellpadding="0" cellspacing="0" style="width:100%;min-width:470px" class="table_total1">
					<tr>
						<td width="250" class="td_total ctr">총수입</td>
						<td width="150" class="td_total ctr"><span id="${pageId}_totalIncomeStr">0</span></td>
						<td width="*" class="td_total ctr">&nbsp;</td>
					</tr>
				</table>
			</td>
			<td width="50%">
				<table border="0" cellpadding="0" cellspacing="0" style="width:100%;min-width:470px" class="table_total1">
					<tr>
						<td width="250" class="td_total rgt">총지출</td>
						<td width="150" class="td_total ctr"><span id="${pageId}_totalConsumeStr">0</span></td>
						<td width="*" class="td_total ctr">&nbsp;</td>
					</tr>
				</table>
			</td>
		</tr>
	</table>
	<table border="0" cellpadding="1" cellspacing="0" style="width:100%;margin-bottom:10px;">
		<tr>
			<td width="50%">
				<table border="0" cellpadding="0" cellspacing="0" style="width:100%;min-width:470px" class="table_total2">
					<tr>
						<td width="100%" class="td_total ctr">&nbsp;</td>
					</tr>
				</table>
			</td>
			<td width="50%">
				<table border="0" cellpadding="0" cellspacing="0" style="width:100%;min-width:470px" class="table_total2">
					<tr>
						<td width="250" class="td_total rgt">잉여자산(총수입 - 총지출)</td>
						<td width="150" class="td_total ctr"><span id="${pageId}_restTotalStr">0</span></td>
						<td width="*" class="td_total ctr">&nbsp;</td>
					</tr>
				</table>
			</td>
		</tr>
	</table>
</div>

<div class="page_button"><span class="btn_page"><a href="javascript:cCashflowManage.goSave()">저장</a></span></div>

<%@include  file="/include/footer.jsp" %>
