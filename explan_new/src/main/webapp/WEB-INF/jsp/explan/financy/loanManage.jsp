
<%@ page contentType='text/html;charset=utf-8' errorPage="/vocm/common/VCommonErrorVW.jsp" %>

<%@include  file="/include/header.jsp" %>

<script>
	$(function() {

	});

	var cLoanManage = {
		 load : function() {
			// Loan List 읽어오기
			var parm = {
				 "sqlId" 	: "Investment.getLoanList"
				,"planNum" 	: _SESSION["PLAN_NUM"]
			}

			var gridInfo = requestService("GET_COMMON", parm);

			var jsonData = gridInfo.data;

	  		var orderList = "[!CB],[!RN],[!HD]LOAN_NUM,LOAN_TYPE,LOAN_COMPANY,LOAN_TOTAL,LOAN_RATE,START_DATE,KUCHI_TERM,PAYBACK_TERM,PAYBACK_TYPE,PAYBACK_EACH_MONTH,COMMENT,STATE";

			var stateSubId = 2;
			if(_SESSION["PLAN_TYPE"] == "제안") stateSubId = 5;

			var itemType = {
				 "orderList"		: orderList
				,"comboList"		: ["LOAN_TYPE","PAYBACK_TYPE",{id:"STATE","subId":stateSubId}]
				,"numberList" 		: ["PAYBACK_EACH_MONTH"]
				,"floatList" 		: ["LOAN_RATE"]
				,"mnumList"			: ["LOAN_TOTAL"]
				,"emptyList"		: ["KUCHI_TERM","PAYBACK_TERM"]
				,"baseValidation"	: ["LOAN_TYPE"]		// 기본 Valid만 Check한다.(Commbo 이외의 값도 허용하기 위함)
			};

			var configInfo 		= explanGrid.makeConfigInfo(itemType);
	  		var columnConfig 	= configInfo.columnConfig;
	  		var validatorList 	= configInfo.validatorList;

			// 상태값 폭
	  		columnConfig["STATE"		]["width"		]	= "80";
	  		
	  		// 추가 Column 속성 처리
	  		columnConfig["LOAN_TYPE"	]["maxlength"	]	= "30";
	  		
	  		columnConfig["START_DATE"	]["colType"		]	= "date";
	  		columnConfig["KUCHI_TERM"	]["colType"		]	= "termed";
	  		columnConfig["PAYBACK_TERM"	]["colType"		]	= "termed";
	  		
	  		
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
					"defaultConfig" 	: { "align"  : "center", "width" :"120", "colType":"edtxt"}
					,"columnConfig" 	: columnConfig
				}
				,"validatorList": validatorList
				,"dataConfig"	: {"useRownum"		: true}
				,"useAutoResize": true
				,"useAutoHeight": { "margin" : 380 }
				,"useBlockCopy"	: true
				,"useAdjust"	: true

				// 추가 옵션
				//// Header Tooltip
//				,"headerToolTipMap"	: headerToolTipMap

				//// Header 명을 다르게 쓸경우
//				,"wordList"			: {"COLUMN_NAME" : "xxx", ...}

				//// Cell Change Event가 있는경우
				,"callback"		: function (mygrid) {
			  		explanGrid.attachEvent			("${pageId}_gridbox", "onChange" , cLoanManage.onChangeProcess);
				}
			}
			var mygrid = explanGrid.makeGrid(gridParm);
		}
		,addRow : function() {
			if(!isValid(_SESSION["PLAN_NUM"])) {
				alert('플랜을 선택 하세요.');
				return;
			}
			explanGrid.addRow("${pageId}_gridbox");
		}
		,delRow	: function() {
			var gridInfo 		= explanGrid.getGrid("${pageId}_gridbox");
			var mygrid 			= gridInfo.grid;
			rowIdList = explanGrid.getCheckedRowId("${pageId}_gridbox", "[!CB]");
			$.each(rowIdList, function() {
				explanGrid.deleteRowById("${pageId}_gridbox", this);
			});
		}
		,goSave	: function() {
			if(!isValid(_SESSION["PLAN_NUM"])) {
				alert('플랜을 선택 하세요.');
				return;
			}

			var isEmpty = explanGrid.isEmpty("${pageId}_gridbox");

			// 삭제 Loan Number List
			var loanDelList = explanGrid.getDeletedCols("${pageId}_gridbox", "LOAN_NUM");

			if(loanDelList.length > 0) isEmpty = false;

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
			var loanDelList = explanGrid.getDeletedCols("${pageId}_gridbox", "LOAN_NUM");

			var sendParm = {
				 "planNum"		: _SESSION["PLAN_NUM"]
				,"loanDelList"	: loanDelList
				,"loanList" 	: explanGrid.generateJsonToDbType("${pageId}_gridbox", jsonData)
			}

			var gridInfo = requestService("SAVE_LOAN_LIST", sendParm);

			if(gridInfo.state == "S"){
				alert('저장 되었습니다.');

				this.load();

				explanGrid.clearChanged("${pageId}_gridbox");

			} else 	{
				alert(gridInfo.msg);
			}
		}
		// Grid Cell이 변경 되었을때 처리
		,onChangeProcess : function(gridId, rowId, colId, val, ctype, rowData) {
			if(ctype == "CC") {
				if(colId == "LOAN_TYPE") {
					if(val == '직접입력') {
						explanGrid.execAfterEdit(gridId, function() {
							var gridInfo = explanGrid.getGrid(gridId);
							var mygrid = gridInfo.grid;
							var colIdx = mygrid.getColIndexById(colId);
							explanGrid.setValueById(gridId, rowId, colId, "");
							mygrid.editCell();
						})
					}
				}
				if(in_array(colId,["LOAN_TOTAL","LOAN_RATE","START_DATE","KUCHI_TERM","PAYBACK_TERM","PAYBACK_TYPE"])) {
					var rdata = fn_copyObject(rowData);
					rdata[colId] = val;
					var source 		= Number(rdata.LOAN_TOTAL) * 10000;
					var rate 		= Number(rdata.LOAN_RATE);
					var guchiTerm 	= Number(rdata.KUCHI_TERM);
					var term 		= Number(rdata.PAYBACK_TERM);
					var loanType 	= _LOAN_TYPE_MAP[rdata.PAYBACK_TYPE];
					var startDate	= rdata.START_DATE;
					var whatPast	= getDistanceMonth(startDate, _SESSION["PLAN_DATE"]);
					
					var resultArr = loanReturn(source, rate, guchiTerm, term, whatPast, loanType);

					explanGrid.setValueById(gridId, rowId, "PAYBACK_EACH_MONTH", Math.round(resultArr[0]*10)/10);
				}
			}
		}
	}
	
</script>
<!-- UI 작성 부분 -->

<h3>부채 관리</h3>

<%@include  file="/include/component/customerInfoComponent.jsp" %>
<script>
	// Component 초기화
	_SVC_COM.initComponent("customerInfoComponent", {}, function(type) {
		if(type == "reload") cLoanManage.load();
	});
</script>

<br/>
<div>
	<div class="list_wrap" style="min-width:800px">
		<div class="list_head">
			<div class="button" id="btnEdit">
				<span class="btn_list"><a href="javascript:cLoanManage.addRow();">부채추가</a></span>
				<span class="btn_list"><a href="javascript:cLoanManage.delRow();">부채삭제</a></span>
				<span class="btn_list"><a href="javascript:cLoanManage.goSave();">저장</a></span>
				<span class="btn_list"><a href="javascript:cLoanManage.load()  ;">새로고침</a></span>
			</div>
		</div>
		<div style="width:100%;height:400px">
			<div id="${pageId}_gridbox" style="width:100%;height:100%;"></div>
		</div>
</div>

<div class="page_button"><span class="btn_page"><a href="javascript:cLoanManage.goSave()">저장</a></span></div>

<%@include  file="/include/footer.jsp" %>

