<%@ page contentType='text/html;charset=utf-8' errorPage="/vocm/common/VCommonErrorVW.jsp" %>

<%@include  file="/include/header.jsp" %>

<script>
	// 중복 Word항목에 대해 Local 정의
	// 예적금
	var _WORD_LIST_TYPE = [];
	_WORD_LIST_TYPE[1] = {
		 "INTEREST_RATE"	: "이자율(%)"
		,"END_TERM"			: "예치기간"
	};
	// 주식,펀드
	_WORD_LIST_TYPE[2] = {
		 "INTEREST_RATE"	: "예상수익률(%)"
	};
	// 보험,기타
	_WORD_LIST_TYPE[3] = {
		 "INTEREST_RATE"	: "예상수익률(%)"
	};
	
	var _TAB_IDX = 0;
	
	$(function() {
		// Tab Event를 등록 한다.
		var onClickTabFunctionList = [
			 cInvestmentManage.changeTab0
			,cInvestmentManage.changeTab1
			,cInvestmentManage.changeTab2
			,cInvestmentManage.changeTab3
		];
		_SVC_EVENT.addTabClickEvent(onClickTabFunctionList);
		
		// 목록 Grid에 대해서 Onchange Event를 막는다.
		explanGrid.pauseEvent("${pageId}_gridboxType0"	, "onChange");
		
		cInvestmentManage.changeTab0();
	});
	
	var cInvestmentManage = {
		load : function() {
			// 현재 보여지는 Tab Idx를 가져온다.
			debugger;
			var tabIdx = _SVC_COM.getCurrentTabIndex();
			var subId  = 1;
			
			var orderList;
			
			// 탭이 선택이 되지 않은 경우 종료
			if(tabIdx == -1) return;
			
			// 전체 목록
			if(tabIdx == 0) {
				subId = null;
				orderList = "[!RN],[!HD]INVESTMENT_NUM,INVESTMENT_TYPE,INVESTMENT_TITLE,START_DATE,TERM,REGULAR_MONEY,END_TERM,BASE_MONEY";
			}
			// 예적금
			if(tabIdx == 1) {
				subId = 1;
				orderList = "[!CB],[!RN],[!HD]INVESTMENT_NUM,INVESTMENT_TYPE,INVESTMENT_TITLE,START_DATE,TERM,REGULAR_MONEY,END_TERM,BASE_MONEY,INTEREST_RATE,INTEREST_TYPE,TAX";
			}
			 // 주식, 펀드
			else if(tabIdx == 2) {
				subId = 2;
				orderList = "[!CB],[!RN],[!HD]INVESTMENT_NUM,INVESTMENT_TYPE,INVESTMENT_TITLE,START_DATE,TERM,REGULAR_MONEY,END_TERM,BASE_MONEY,INTEREST_RATE,NORMAL_FEE,[!HD]INTEREST_TYPE";
			}
			 // 보험, 기타
			else if(tabIdx == 3) {
				subId = 3;
				orderList = "[!CB],[!RN],[!HD]INVESTMENT_NUM,INVESTMENT_TYPE,INVESTMENT_TITLE,START_DATE,TERM,REGULAR_MONEY,END_TERM,BASE_MONEY,INTEREST_RATE,NORMAL_FEE,FEE,[!HD]INTEREST_TYPE,[!HD]PRE_FEE,[!HD]AFTER_PRE_FEE,[!HD]PRE_FEE2";
			}
			
			// 상태 Column추가
			orderList += ",STATE";
			
			var stateSubId = 2;
			if(_SESSION["PLAN_TYPE"] == "제안") {
				stateSubId = 3;
				if(tabIdx == 3) stateSubId = 1;
			}

			// Investment List 읽어오기
			var parm = {
				 "sqlId" 	: "Investment.getInvestmentList"	
				,"planNum" 	: _SESSION["PLAN_NUM"]
				,"subId"	: subId
			}

			var gridInfo = requestService("GET_COMMON", parm);

			var jsonData = gridInfo.data;
			
			var itemType = {
				 "orderList"	: orderList
				,"comboList"	: ["TAX","INTEREST_TYPE",{id:"INVESTMENT_TYPE","subId":subId},{id:"STATE","subId":stateSubId}]
				,"numberList" 	: ["BASE_MONEY","REGULAR_MONEY","TERM"]
				,"floatList" 	: ["INTEREST_RATE","NORMAL_FEE"]
				,"emptyList" 	: ["NORMAL_FEE","FEE"]
			};
			
	  		// 주식,펀드,보험,기타 일때만 처리
	  		if(tabIdx != 1) {
	  			itemType["emptyList"].push("TERM");
	  			itemType["emptyList"].push("REGULAR_MONEY");
	  		}
			
			var configInfo 		= explanGrid.makeConfigInfo(itemType);
	  		var columnConfig 	= configInfo.columnConfig;
	  		var validatorList 	= configInfo.validatorList;
	  		
	  		columnConfig["START_DATE"] 	["colType"]	= "date";
	  		columnConfig["END_TERM"] 	["colType"]	= "termed";
	  		columnConfig["TERM"] 		["colType"]	= "termed";

	  		// 컬럼 폭 조정
	  		columnConfig["INVESTMENT_TITLE"	]["width"]	= "230";
	  		columnConfig["TAX"				]["width"]	= "100";
	  		columnConfig["STATE"			]["width"]	= "80";
			
	  		// 예적금 일때 처리
	  		if(tabIdx == 1) {
		  		columnConfig["INTEREST_RATE"]["width"]	= "100";
	  			columnConfig["END_TERM"		]["width"]	= "80";
	  		}
	  		// 주식,펀드 일때만 처리
	  		if(tabIdx == 2) {
	  		}

	  		// 보험,기타 일때만 처리
	  		if(tabIdx == 3) {
		  		columnConfig["FEE"] 	 ["colType"]	= "fee";

		  		columnConfig["FEE"]		 ["width"]	= "140";
	  		}

	  		// Header Tooltip
	  		var headerToolTipMap = {
		  		 "INVESTMENT_TYPE"	: "더블클릭하여 선택"
			  	,"INVESTMENT_TITLE"	: "더블클릭하여 입력"
	  			,"START_DATE" 		: "8자리 년월일 ex) 20210612"	
	  			,"TERM" 			: "* 00개월 또는 00년00개월\n* 숫자만 입력 할 경우 개월단위로 간주.\n\nex1) 18개월,   ex2) 2년,   ex3) 36"	
	  			,"END_TERM" 		: "* 00개월 또는 00년00개월\n* 숫자만 입력 할 경우 개월단위로 간주.\n\nex1) 18개월,   ex2) 2년,   ex3) 36"
	  			,"INTEREST_RATE"	: "연이율 또는 연평균 예상 수익률을 숫자로 입력"
	  			,"NORMAL_FEE"		: "연 운영보수를 숫자로 입력"
	  			,"FEE"				: "ex) 7/10/3 => 이렇게 입력하면 \n     선취 7%, 10년 납입 후 3% 라는 의미"
	  			,"STATE"			: "더블클릭하여 상태변경"
	  		}
	  		
	  		var gridParm = {
				 "targetDivId"		: "${pageId}_gridboxType" + _TAB_IDX
				,"orderList" 		: orderList
				,"gridData"			: jsonData
				,"cellConfig"		: {
					 "defaultConfig" 	: { "align"  : "center", "width" :"120", "colType":"edtxt"}
					,"columnConfig" 	: columnConfig
				}
				,"validatorList"	: validatorList
				,"dataConfig"		: {"useRownum"	: true	}
				,"useAutoResize"	: true
				,"useAutoHeight"	: {"margin" 	: 380 	}
				,"useBlockCopy"		: true
				,"wordList"			: _WORD_LIST_TYPE[subId]
				,"headerToolTipMap"	: headerToolTipMap
				,"callback"			: function (mygrid) {
			  		explanGrid.attachEvent			("${pageId}_gridboxType" + _TAB_IDX, "onChange"		, cInvestmentManage.onChangeProcess);
			  		explanGrid.triggerAllRowOnChange("${pageId}_gridboxType" + _TAB_IDX, "INVESTMENT_TYPE");
				}
				
			}
	  		
	  		// 전체 목록 보기 인 경우 Grid 비활성화 한다. 
	  		if(tabIdx == 0) {
	  			gridParm["gridDisabled"	] = true;
	  			// Cell병합
	  			gridParm["dataConfig"	] = {"useRownum" : true, "mergePos" : 2};
	  		} else {
	  			// 등록/수정/삭제 인경우에 필수값 표시
	  			gridParm["showRequired"	] = true;
	  		}
	  		
			var mygrid = explanGrid.makeGrid(gridParm);
		}
		,addRow : function() {
			if(!isValid(_SESSION["PLAN_NUM"])) {
				alert('고객을 선택 하세요.');
				return;
			}
			var rowId = explanGrid.addRow("${pageId}_gridboxType" + _TAB_IDX);
			
			// 예적금이 아닌경우 금리 Type을 월복리로 통일
			if(_TAB_IDX > 1) {
				explanGrid.setValueById	("${pageId}_gridboxType" + _TAB_IDX, rowId, "INTEREST_TYPE", "월복리");	
			}
			if(_SESSION["PLAN_TYPE"] == "제안") {
				explanGrid.setValueById	("${pageId}_gridboxType" + _TAB_IDX, rowId, "STATE", "신규편입");
			}

		}
		,delRow : function() {
			rowIdList = explanGrid.getCheckedRowId("${pageId}_gridboxType" + _TAB_IDX, "[!CB]");
			$.each(rowIdList, function() {
				explanGrid.deleteRowById("${pageId}_gridboxType" + _TAB_IDX, this);
			});
		}
		,goSave : function() {
			if(!isValid(_SESSION["PLAN_NUM"])) {
				alert('고객을 선택 하세요.');
				return;
			}

			var isEmpty = explanGrid.isEmpty("${pageId}_gridboxType" + _TAB_IDX);
	
			// 삭제 Investment Number List
			var investmentDelList = explanGrid.getDeletedCols("${pageId}_gridboxType" + _TAB_IDX, "INVESTMENT_NUM");
	
			if(investmentDelList.length > 0) isEmpty = false;
	
			if(isEmpty) {
				alert("저장 할 내용이 없습니다.");
				return;
			}
			var changeCheck = explanGrid.isChanged("${pageId}_gridboxType" + _TAB_IDX);
			if(!changeCheck) {
				alert("변경 내용이 없습니다.");
				return;
			}
			
			var jsonData 	= explanGrid.getGridToJson("${pageId}_gridboxType" + _TAB_IDX, null, "C");
	
			var resultMap = explanGrid.validCheckAllGrid("${pageId}_gridboxType" + _TAB_IDX);
			
			if(!resultMap.valid) {
				alert(resultMap.getMsg());
				return;
			}
	
			var sendParm = {
				 "planNum"				: _SESSION["PLAN_NUM"]
				,"investmentDelList"	: investmentDelList
				,"investmentList"		: jsonData
			}
			
			var gridInfo = requestService("SAVE_INVESTMENT_LIST", sendParm);
	
			if(gridInfo.state == "S"){
				alert('저장 되었습니다.');
				
				cInvestmentManage.load();
				
				explanGrid.clearChanged("${pageId}_gridboxType" + _TAB_IDX);
				
			} else 	{
				alert(gridInfo.msg);
			}
		}
		,changeTab0 : function() {
			_TAB_IDX = 0;
			cInvestmentManage.load();
		}
		,changeTab1 : function() {
			_TAB_IDX = 1;
			cInvestmentManage.load();
		}
		,changeTab2 : function() {
			_TAB_IDX = 2;
			cInvestmentManage.load();
		}
		,changeTab3 : function() {
			_TAB_IDX = 3;
			cInvestmentManage.load();
		}
		// Grid Cell이 변경 되었을때 처리
		,onChangeProcess : function(gridId, rowId, colId, val, ctype, rowData) {
			if(ctype == "CC") {
				if(colId == "INVESTMENT_TYPE") {
					if(val == '적금') {
						explanGrid.setDisabledById	(gridId, rowId, "BASE_MONEY", true	);
						explanGrid.setValueById		(gridId, rowId, "BASE_MONEY", ""	);
						explanGrid.setDisabledById	(gridId, rowId, "END_TERM"	, true	);
					} else {
						explanGrid.setDisabledById	(gridId, rowId, "BASE_MONEY", false);
						explanGrid.setDisabledById	(gridId, rowId, "END_TERM"	, false	);
					}
					if(val == '예금') {
						explanGrid.setDisabledById	(gridId, rowId, "REGULAR_MONEY"	, true	);
						explanGrid.setValueById		(gridId, rowId, "REGULAR_MONEY"	, ""	);
						explanGrid.setDisabledById	(gridId, rowId, "TERM"			, true	);
					} else {
						explanGrid.setDisabledById	(gridId, rowId, "REGULAR_MONEY"	, false);
						explanGrid.setDisabledById	(gridId, rowId, "TERM"			, false);
					}
					if(val == "펀드") {
						explanGrid.setDisabledById	(gridId, rowId, "NORMAL_FEE"	, false	);
					} else if( val == "주식" ){
						explanGrid.setDisabledById	(gridId, rowId, "NORMAL_FEE"	, true	);
						explanGrid.setValueById		(gridId, rowId, "NORMAL_FEE"	, ""	);
					}
				}
				if(colId == "FEE") {
					if(isNumber(val)) {
						explanGrid.setValueById	(gridId, rowId, "PRE_FEE"		, val	);
						explanGrid.setValueById	(gridId, rowId, "AFTER_PRE_FEE"	, ""	);
						explanGrid.setValueById	(gridId, rowId, "PRE_FEE2"		, ""	);
					} else {
						var valList = val.split("/");
						explanGrid.setValueById	(gridId, rowId, "PRE_FEE"		, valList[0]	);
						explanGrid.setValueById	(gridId, rowId, "AFTER_PRE_FEE"	, valList[1]	);
						explanGrid.setValueById	(gridId, rowId, "PRE_FEE2"		, valList[2]	);
					}
				}
			}
		 }
		// 선택 예/적금 가져오기
		,importInvestment : function(subId) {
			if(isEmpty(_SESSION["PLAN_NUM"])) {
				alert('고객을 선택하세요.');
				return;
			}
			_SVC_POPUP.setConfig("importInvestmentPopup", {subId : subId}, function(returnData) {
				if(returnData == 'S') {
					cInvestmentManage.load();
				}
			});
			_SVC_POPUP.show("importInvestmentPopup");
		}
	}
	
	//Grid 검색창 Cell Type 정의
	//보험 수수료 표현식
	function eXcell_fee(cell){ 
	    if (cell){                
	        this.cell 	= cell;
	        this.grid 	= this.cell.parentNode.grid;
	        eXcell_ed.call(this);
	    }
	    this.setValue=function(val){
	    	var realData = val;
	    	if(isValid(val)) {
	    		val = val.replaceAll("%", "");
	    		if(isNumber(val)) {
	    			realData = val;
	    			var tval  = "<span style=display:none>"+val+"</span>"; 
	    			val = tval + val + "%";
	    		} else {
	    			var valList = val.split("/");
	    			if(valList.length == 3 && isNumber(valList[0]) &&  isNumber(valList[1]) &&  isNumber(valList[2]) ) {

		    			realData = valList[0]+"/"+valList[1]+"/"+valList[2];

	    				val  = "<span style=display:none>"+realData+"</span>";
		    			val += "선취 " + valList[0] + "%, ";
		    			val += valList[1] + "년 후 ";
		    			val += valList[2] + "%";
		    			
	    			} else {
	    				_SVC_COM.toastPopup('입력 형식이 맞지 않습니다.');
	    				val 		= "";
		    			realData 	= "";
	    			}
	    		}
	    	}
			this.setCValue(val,realData);  
	    }
	    this.getValue=function(){
			var retVal = $(this.cell).children().eq(0).html();
 			if(!isValid(retVal)) retVal = "";
			return retVal;
	    }
	}
	eXcell_fee.prototype = new eXcell; 

	
</script>
<!-- UI 작성 부분 -->

<h3>금융 자산 관리</h3>

<%@include  file="/include/component/customerInfoComponent.jsp" %>
<script>
	// Component 초기화
	_SVC_COM.initComponent("customerInfoComponent", {}, function(type) {
		if(type == "reload") cInvestmentManage.load();
	});
</script>

<!-- tab -->
<div class="tab">
	<ul>
		<li class="first on">	<a>금융자산 목록			</a></li>
		<li					>	<a>예금,적금 등록/수정/삭제	</a></li>
		<li					>	<a>주식,펀드 등록/수정/삭제	</a></li>
		<li					>	<a>보험,기타 등록/수정/삭제	</a></li>
	</ul>
</div>
<!-- //tab -->


<div id="#" class="tab_cont">
	<div class="list_wrap" style="min-width:800px">
		<div style="width:100%;height:400px">
			<div id="${pageId}_gridboxType0" style="width:100%;height:100%;"></div>
		</div>
	</div>
</div>
<div id="#" class="tab_cont" style="display:none">
	<div class="list_wrap" style="min-width:800px">
		<div class="list_head">
			<div class="button" id="btnEdit">
				<span class="btn_list"><a href="javascript:cInvestmentManage.addRow();">추가</a></span>
				<span class="btn_list"><a href="javascript:cInvestmentManage.delRow();">삭제</a></span>
				<span class="btn_list"><a href="javascript:cInvestmentManage.goSave();">저장</a></span>
				<span class="btn_list"><a href="javascript:cInvestmentManage.load()  ;">새로고침</a></span>
			</div>
			<div class="setting">
				<span class="btn_list"><a href="javascript:cInvestmentManage.importInvestment(1);">예금/적금 가져오기</a></span>
			</div>
		</div>
		<div style="width:100%;height:400px">
			<div id="${pageId}_gridboxType1" style="width:100%;height:100%;"></div>
		</div>
		
	</div>
</div>
<div id="#" class="tab_cont" style="display:none">
	<div class="list_wrap" style="min-width:800px">
		<div class="list_head">
			<div class="button" id="btnEdit">
				<span class="btn_list"><a href="javascript:cInvestmentManage.addRow();">추가</a></span>
				<span class="btn_list"><a href="javascript:cInvestmentManage.delRow();">삭제</a></span>
				<span class="btn_list"><a href="javascript:cInvestmentManage.goSave();">저장</a></span>
				<span class="btn_list"><a href="javascript:cInvestmentManage.load()  ;">새로고침</a></span>
			</div>
			<div class="setting">
				<span class="btn_list"><a href="javascript:cInvestmentManage.importInvestment(2);">주식/펀드 가져오기</a></span>
			</div>
		</div>
		<div style="width:100%;height:400px">
			<div id="${pageId}_gridboxType2" style="width:100%;height:100%;"></div>
		</div>
	</div>
</div>
<div id="#" class="tab_cont" style="display:none">
	<div class="list_wrap" style="min-width:800px">
		<div class="list_head">
			<div class="button" id="btnEdit">
				<span class="btn_list"><a href="javascript:cInvestmentManage.addRow();">추가</a></span>
				<span class="btn_list"><a href="javascript:cInvestmentManage.delRow();">삭제</a></span>
				<span class="btn_list"><a href="javascript:cInvestmentManage.goSave();">저장</a></span>
				<span class="btn_list"><a href="javascript:cInvestmentManage.load()  ;">새로고침</a></span>
			</div>
			<div class="setting">
				<span class="btn_list"><a href="javascript:cInvestmentManage.importInvestment(3);">보험/기타 가져오기</a></span>
			</div>
		</div>
		<div style="width:100%;height:400px">
			<div id="${pageId}_gridboxType3" style="width:100%;height:100%;"></div>
		</div>
	</div>
</div>
<div class="page_button"><span class="btn_page"><a href="javascript:cInvestmentManage.goSave()">저장</a></span></div>

<!-- Add Investment Popup -->
<%@include  file="/include/popup/importInvestmentPopup.jsp" %>

<%@include  file="/include/footer.jsp" %>
