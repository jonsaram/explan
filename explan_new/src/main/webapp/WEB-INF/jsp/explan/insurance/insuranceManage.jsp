<%@ page contentType='text/html;charset=utf-8' errorPage="/vocm/common/VCommonErrorVW.jsp" %>

<%@include  file="/include/header.jsp" %>

<script type="text/javascript">
	
	_SVC_COM.loadJsFile("/explan/js/class/C_INSURANCE_GROUP.js");

	$(function() {
		// Page 로딩시 처리
	});
	_TAB_IDX = 1;
	var cInsuranceCommon = {
		// 보험 선택 리스트
		 INS_LIST 			: {}
		// 피보험자 리스트
		,INSURED_LIST 		: {}
		// 보험/피보험자 관련 Map
		,INS_INFO_MAP		: {}
		// 전체 담보 리스트
		,DAMBO_ORDER		: []
		,DAMBO_MAP			: []
		// 입력 담보 요약
		,DAMBO_SUMMARY_MAP 	: {}
		
		
		,changeTab1 : function () {
			_TAB_IDX = 1;
			cInsuranceManage.load();		
		}	
		,changeTab2 : function () {
			_TAB_IDX = 2;
			cDamboManage.init();		
		}	
		// 담보 추가 POPUP
		,addDamboPopup : function () {
			_SVC_POPUP.setConfig("addDamboPopup", {}, function(returnData) {
				if(returnData.changeCheck) cDamboManage.init(true);
			});
			_SVC_POPUP.show("addDamboPopup");
		}
		// 담보 그룹 관리 POPUP
		,damboGroupManagePopup : function () {
			_SVC_POPUP.setConfig("damboGroupManagePopup", {"fullDamboOrder" : cInsuranceCommon.DAMBO_ORDER, "fullDamboMap" : cInsuranceCommon.DAMBO_MAP}, function(returnData) {
			});
			_SVC_POPUP.show("damboGroupManagePopup");
		}
	}
	
	var cInsuranceManage = {
		load : function() {
			// 서비스 요청
			var parm = {
				 "sqlId" 	: "Insurance.getInsuranceList"	
				,"planNum" 	: _SESSION["PLAN_NUM"]
			}
			var resultInfo = requestService("GET_COMMON", parm);

			var jsonData = resultInfo.data;
			
			var orderList = "[!CB],[!RN],[!HD]INSURANCE_NUM,INSURANCE_TYPE,COMPANY_NAME,TITLE,CONTRACTOR,INSURED_INFO,PAY_EACH_MONTH,START_DATE,GUARANTEE_TERM,GUARANTEE_TERM_TYPE,PAY_TERM,PAY_TERM_TYPE,STATE";
			
			var stateSubId = 2;
			if(_SESSION["PLAN_TYPE"] == "제안") stateSubId = 1;

			var itemType = {
				 "orderList"	: orderList
				,"comboList" 	: ["INSURANCE_TYPE","GUARANTEE_TERM_TYPE","PAY_TERM_TYPE",{id:"STATE","subId":stateSubId}]
				,"numberList" 	: ["GUARANTEE_TERM","PAY_TERM","PAY_EACH_MONTH"]
			};
			
	  		var configInfo = explanGrid.makeConfigInfo(itemType);

	  		var columnConfig 	= configInfo.columnConfig;
	  		
	  		var validatorList 	= configInfo.validatorList;
	  		
	  		columnConfig["GUARANTEE_TERM"		]["width"] 	= "80";
	  		columnConfig["PAY_TERM"				]["width"] 	= "80";
	  		columnConfig["GUARANTEE_TERM_TYPE"	]["width"] 	= "70";
	  		columnConfig["PAY_TERM_TYPE"		]["width"] 	= "70";
	  		columnConfig["STATE"				]["width"]	= "80";
	  		columnConfig["START_DATE"			]			= { "colType" : "date"	}
	  		columnConfig["CREATE_DATE"			]			= { "colType" : "ro"	}
	  		columnConfig["INSURED_INFO"			]			= { "colType" : "insured", "width" : "150", "align" : "left"}
	  		
	  		var gridParm = {
				"targetDivId"	: "${pageId}_gridbox",
				"orderList" 	: orderList,
				"gridData"		: jsonData,
				"cellConfig"	: {
					"defaultConfig" : { "align"  : "center", "width" :"*", "colType":"edtxt"},
					"columnConfig" 	: columnConfig
				},
				"validatorList"	: validatorList,
				"dataConfig"	: {"useRownum"		: true},
				"showRequired"	: true,
				"useAutoResize"	: true,
				"useAutoHeight"	: { "margin" : 340 },
				"useBlockCopy"	: true,
				"wordList"		: { "START_DATE" : "가입일"}
			}
			var mygrid = explanGrid.makeGrid(gridParm);
			
			// Search Popup 후처리 등록
			/* 		explanGrid.attachEvent("${pageId}_gridbox", "onAfterPopup", function(parm) {
						dalert(parm);
					});
			 */
			
		}
		,addRow : function() {
			if(!isValid(_SESSION["PLAN_NUM"])) {
				alert('플랜을 선택 하세요.');
				return;
			}
			explanGrid.addRow("${pageId}_gridbox");
		}
		,delRow : function() {
			rowIdList = explanGrid.getCheckedRowId("${pageId}_gridbox", "[!CB]");
			if(!isValid(rowIdList) || rowIdList.length == 0) {
				alert('항목을 선택하세요');
				return;
			}
			$.each(rowIdList, function() {
				explanGrid.deleteRowById("${pageId}_gridbox", this);
			});
		}
		,importInsurance : function() {
			_SVC_POPUP.setConfig("importInsurancePopup", {}, function(returnData) {
			});
			_SVC_POPUP.show("importInsurancePopup");
		}
		,goSave : function() {
			if(!isValid(_SESSION["PLAN_NUM"])) {
				alert('플랜을 선택 하세요.');
				return;
			}
			var isEmpty = explanGrid.isEmpty("${pageId}_gridbox");
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
			var deletedInsuranceNumList = explanGrid.getDeletedCols("${pageId}_gridbox", "INSURANCE_NUM");
			
			var sendParm = {
				 "planNum"					: _SESSION["PLAN_NUM"]
				,"deletedInsuranceNumList"	: deletedInsuranceNumList	
				,"insuranceList" 			: jsonData					
			}

			var resultInfo = requestService("SAVE_INSURANCE_LIST", sendParm);

			if(resultInfo.state == "S"){
				alert('저장 되었습니다.');
				
				explanGrid.clearChanged("${pageId}_gridbox");
				
			} else 	{
				alert(resultInfo.msg);
			}
		}
	} 
	// 보험선택/피보험자 선택
	var cSelectInsured = {
		setSelectInsurance : function() {
			var resultInfo = requestService("GET_INSURANCE_LIST", {"planNum" : _SESSION["PLAN_NUM"]});
			
			var jsonData = resultInfo.data;
			
			$.each(resultInfo.data, function() {
				cInsuranceCommon.INS_LIST[this.INSURANCE_NUM] = this.COMPANY_NAME + " / " + this.TITLE;
				
				// 피보험자 리스트 설정
				var insuredInfoList = this.INSURED_INFO.split(",");
				var insuredInsuredNumList = this.INSURED_NUM_LIST.split(",");
				for (var ii = 0; ii < insuredInfoList.length; ii++) {
					if(cInsuranceCommon.INSURED_LIST[this.INSURANCE_NUM] == undefined) cInsuranceCommon.INSURED_LIST[this.INSURANCE_NUM] = {};
					cInsuranceCommon.INSURED_LIST[this.INSURANCE_NUM][insuredInsuredNumList[ii]] = insuredInfoList[ii];
				}
				cInsuranceCommon.INS_INFO_MAP[this.INSURANCE_NUM] = this;
			});
			
			fn_addJsonToSelectBox("selectInsurance", cInsuranceCommon.INS_LIST, true);
		}
		,setSelectInsured 	: function(insuranceNum) {
			fn_addJsonToSelectBox("selectInsured", cInsuranceCommon.INSURED_LIST[insuranceNum], true);
			this.changeInsured();
		}
		,changeInsured 		: function() {
			// 담보 입력 항목 정보 Setting
			cDamboManage.loadDamboList();
			// 담보 요약 항목 정보 Setting
			cDamboSummary.loadDamboListSummary();
			// 담보 요약 정보 좌측 Setting
			cDamboManage.refreshDamboList();
		}
	}
	
	//
	// 담보 관련 처리 
	//
	
	var cDamboManage = {
		// 담보 관리 초기화
		init : function(refreshFlag) {
			cInsuranceCommon.INS_LIST 			= {}
			cInsuranceCommon.INSURED_LIST 		= {}
			cInsuranceCommon.INS_INFO_MAP		= {}
			cInsuranceCommon.DAMBO_ORDER		= [];
			cInsuranceCommon.DAMBO_MAP			= {};
			cInsuranceCommon.DAMBO_SUMMARY_MAP 	= {};
		
			// 보험 선택 설정
			cSelectInsured.setSelectInsurance();
			// Dambo 공통 정보 Setting
			cDamboManage.setDamboCommonInfo(refreshFlag);
			// 담보 그룹 Select Box 설정
			cDamboManage.loadDamboGroupInfoList();
			
			$("#selectInsurance").trigger("change");
		}
		// 담보 공통 정보 Setting
		,setDamboCommonInfo : function(refreshFlag) {
			// 전체 담보 정보를 읽는다.
			var parm = _SVC_DAMBO.getFullDamboMap(refreshFlag);
			// Dambo Order 설정
			cInsuranceCommon.DAMBO_ORDER 	= parm.damboOrder;
			// Dambo Map 설정
			cInsuranceCommon.DAMBO_MAP  	= parm.fullDamboMap;
		}
		// 담보 그룹 Setting
		,loadDamboGroupInfoList : function() {
			// Dambo Group List SelectBox에 Setting
			_SVC_DAMBO.setDamboGroupToSelectBox("selectDamboGroup", {"" : "전체"});
		}
		// 현재 선택된 담보 그룹으로 담보입력 Grid를 Setting한다.
		,loadDamboList 			: function() {
			
			explanGrid.pauseEvent("${pageId}_gridboxDambo"	, "onChange");
			
			var groupNum = fn_getSelectBox("selectDamboGroup");
			
			var baseDamboList = [];
			if(groupNum == "") {
				baseDamboList = fn_jsonClone(cInsuranceCommon.DAMBO_ORDER);
			} else {
				var resultInfo = requestService("GET_COMMON", { "sqlId" : "Insurance.getDamboGroupList", "GROUP_NUM" : groupNum });
				
				baseDamboList = resultInfo.data;
			}
			var selectDamboList = [];
			$.each(baseDamboList, function() {
				var damboNum = this.DAMBO_NUM;
				selectDamboList.push(cInsuranceCommon.DAMBO_MAP[damboNum]);
			});
			
			var orderList = "[!RN]No,CATEGORY_NAME_STR,DAMBO_NAME,INSURANCE_MONEY,[!HD]DAMBO_NUM,[!HD]CATEGORY_NAME";
			
			var itemType = {
				"orderList"		: orderList,
				"emptyList"		: ["INSURANCE_MONEY"] // 빈값이 가능한 항목 설정
			};

	  		var configInfo = explanGrid.makeConfigInfo(itemType);
	  		
			var columnConfig 	= configInfo.columnConfig;
	  		columnConfig["INSURANCE_MONEY"] = { "colType" : "inputDambo", "align" : "left"}
	  		columnConfig["CATEGORY_NAME"] 	= { "width"   : "100"}

	 		var addHeaderList = [
	   			["No."		,"CATEGORY_NAME","DAMBO_NAME"	, "INSURANCE_MONEY"	,"DAMBO_NUM"	,"CATEGORY_NAME"	],
	  			["#rspan"	,"#text_filter"	,"#text_filter"	, "#text_filter"	,"DAMBO_NUM"	,"CATEGORY_NAME"	]
	   		];
	  		
	  		var gridParm = {
				 "targetDivId"		: "${pageId}_gridboxDambo"
				,"orderList" 		: orderList
				,"addHeaderList"	: addHeaderList
				,"gridData"			: selectDamboList
				,"cellConfig"		: {
					 "defaultConfig" 	: { "align"  : "left", "width" :"170", "colType":"ro"}
					,"columnConfig" 	: columnConfig
				}
				,"dataConfig"		: {"useRownum" : true}
				//,"mergeColName"		: "CATEGORY_NAME_STR"
				,"useAutoResize"	: true
				,"useAutoHeight"	: { "margin" : 230 }
				,"useBlockCopy"		: true
				,"callback"			: function () {
			  		explanGrid.attachEvent("${pageId}_gridboxDambo", "onChange", cDamboManage.damboOnChangeProcess);
				}
			}
	  		
			var mygrid = explanGrid.makeGrid(gridParm);
	  		
			var rowList = explanGrid.getGridToJson("${pageId}_gridboxDambo");
			
			$.each(cInsuranceCommon.DAMBO_MAP, function(key, obj) {
				obj._ROWID = undefined;
			});
			$.each(rowList, function() {
				cInsuranceCommon.DAMBO_MAP[this.DAMBO_NUM]._ROWID = this._ROWID;
			});
	  		
			explanGrid.releaseEvent("${pageId}_gridboxDambo"	, "onChange");
	  		
		}
		// 현재 Dambo Summary Dambo정보로 보장금액을 Setting한다.
		,refreshDamboList : function() {
			explanGrid.pauseEvent("${pageId}_gridboxDambo"	, "onChange");			
 			$.each(cInsuranceCommon.DAMBO_MAP, function(key, obj) {
				var rowId 	= obj._ROWID;
				if(!isValid(rowId)) return true;
				var rowData = cInsuranceCommon.DAMBO_SUMMARY_MAP[key];
				if(isValid(cInsuranceCommon.DAMBO_SUMMARY_MAP[key])) {
					explanGrid.setValueById("${pageId}_gridboxDambo", rowId, "INSURANCE_MONEY", rowData.INSURANCE_MONEY);
				} else {
					explanGrid.setValueById("${pageId}_gridboxDambo", rowId, "INSURANCE_MONEY", "");
				} 
			});
 			explanGrid.releaseEvent("${pageId}_gridboxDambo", "onChange");
		}
		// 담보 그룹이 변경 됬을 경우
		,changeDamboGroup 			: function() {
			// 담보 입력 항목 정보 Setting
			cDamboManage.loadDamboList();
			cDamboManage.refreshDamboList();
		}
		// 담보 Cell 변경시 처리
		,damboOnChangeProcess : function (gridId, rowId, colId, val, ctype, rowData) {
			if(ctype == "CC") {
				if(colId == "INSURANCE_MONEY") {
					if(isValid(rowData.INSURANCE_MONEY)) {
						cInsuranceCommon.DAMBO_SUMMARY_MAP	[rowData.DAMBO_NUM] = rowData;
					} else {
						cInsuranceCommon.DAMBO_SUMMARY_MAP[rowData.DAMBO_NUM] = undefined;
					}
					cDamboSummary.setGridboxDamboSummaryProcess();
					cDamboManage.refreshDamboList();
				}
			}
		}
	}

	// '${pageId}_gridboxDambo' Grid에서 Dambo Cell 변경 될때 처리
	function onStartPasteProcess(gridId) {
		//explanGrid.pauseEvent("${pageId}_gridboxDambo"	, "onChange");
	}
	function onEndPasteProcess(gridId) {
		//explanGrid.releaseEvent("${pageId}_gridboxDambo", "onChange");
	}
	
	var cDamboSummary = {
		initDamboSummary : function() {
			cDamboSummary.loadDamboListSummary();
		}
		// 담보 Summary Cell 변경시 처리
		,damboSummaryOnChangeProcess : function(gridId, rowId, colId, val, ctype, rowData) {
			if(ctype == "CC") {
				if(colId == "INSURANCE_MONEY") {
					cInsuranceCommon.DAMBO_SUMMARY_MAP[rowData.DAMBO_NUM] = rowData;
					cDamboManage.refreshDamboList();
				}
			}
		}
		// 입력 담보 Summary 세팅
		,loadDamboListSummary : function () {
			var damboSummaryList = [];
	
			// 서비스 요청
			var insuranceNum 	= fn_getSelectBox("selectInsurance");
			var insuredNum 		= fn_getSelectBox("selectInsured");
			var sendParm = {
				"INSURANCE_NUM" : insuranceNum,	
				"INSURED_NUM" 	: insuredNum	
			}
			var resultInfo = requestService("GET_INSURANCE_DAMBO_LIST", sendParm);
			
			var jsonData = resultInfo.data;
			cInsuranceCommon.DAMBO_SUMMARY_MAP = arrayToMap(jsonData, "DAMBO_NUM");
			
			cDamboSummary.setGridboxDamboSummaryProcess();
			
			cDamboManage.refreshDamboList();
		}
		// 입력 담보 Summary Grid 세팅
		,setGridboxDamboSummaryProcess : function () {
			var damboSummaryList = [];
			$.each(cInsuranceCommon.DAMBO_ORDER, function() {
				var item = cInsuranceCommon.DAMBO_SUMMARY_MAP[this.DAMBO_NUM];
				if(!isValid(item)) return true;
				this.INSURANCE_MONEY = item.INSURANCE_MONEY
				damboSummaryList.push(this);
			});

			var orderList = "[!CB],[!RN],[!HD]DAMBO_NUM,CATEGORY_NAME,DAMBO_NAME,INSURANCE_MONEY";
			
			var itemType = {
				 "orderList"		: orderList
				,"emptyList"		: ["CATEGORY_NAME"] // 빈값이 가능한 항목 설정
			};

	  		var configInfo = explanGrid.makeConfigInfo(itemType);
	  		
			var columnConfig 	= configInfo.columnConfig;
			
	  		columnConfig["INSURANCE_MONEY"] = { "colType" : "inputDambo", "align" : "left"}
	  		columnConfig["CATEGORY_NAME"] 	= { "width"   : "100"}
			
	  		var validatorList 	= configInfo.validatorList;

	  		var gridParm = {
				 "targetDivId"		: "${pageId}_gridboxDamboSummary"
				,"orderList" 		: orderList
				,"gridData"			: damboSummaryList
				,"cellConfig"		: {
					 "defaultConfig" 	: { "align"  : "left", "width" :"170", "colType":"ro"}
					,"columnConfig" 	: columnConfig
				}
				,"validatorList"	: validatorList
				,"dataConfig"		: {"useRownum" : true}
				,"mergeColName"		: "CATEGORY_NAME"
				,"useAutoResize"	: true
				,"useAutoHeight"	: { "margin" : 230 }
				,"useBlockCopy"		: true
				,"callback"			: function() {
					explanGrid.attachEvent("${pageId}_gridboxDamboSummary", "onChange"		, cDamboSummary.damboSummaryOnChangeProcess);
				}
			}
			var mygrid = explanGrid.makeGrid(gridParm);
		}
		// 담보 Summary 항목 삭제
		,deleteDamboSummaryRow : function () {
			rowIdList = explanGrid.getCheckedRowId("${pageId}_gridboxDamboSummary", "[!CB]");
			if(rowIdList.length == 0) {
				alert("선택된 항목이 없습니다.");
				return;
			}
			$.each(rowIdList, function() {
				var damboNum = explanGrid.getValueById("${pageId}_gridboxDamboSummary", this, "DAMBO_NUM");
				cInsuranceCommon.DAMBO_SUMMARY_MAP[damboNum] = undefined;
				cInsuranceCommon.DAMBO_MAP[damboNum].INSURANCE_MONEY = "";
			});
			cDamboManage.refreshDamboList();
			this.setGridboxDamboSummaryProcess();
		}
		// 담보 저장
		,goSaveDambo : function () {

			var resultMap 	= explanGrid.validCheckAllGrid("${pageId}_gridboxDamboSummary");
			
			if(!resultMap.valid) {
				alert(resultMap.getMsg());
				return;
			}
			
			var saveList = [];

			var jsonData 	= explanGrid.getGridToJson("${pageId}_gridboxDamboSummary");
			
			$.each(jsonData, function() {
				if(isValid(this.INSURANCE_MONEY)) saveList.push(this);
			});
			
			var insuranceNum 	= fn_getSelectBox("selectInsurance");
			var insuredNum 		= fn_getSelectBox("selectInsured");

			var sendParm = {
					"INSURANCE_NUM"	: insuranceNum,	
					"INSURED_NUM" 	: insuredNum,	
					"damboInfoList" : saveList	
			}
			var resultInfo = requestService("SAVE_INSURANCE_DAMBO_LIST", sendParm);

			if(resultInfo.state == "S"){
				alert('저장 되었습니다.');
				
				explanGrid.clearChanged("${pageId}_gridboxDambo");
				
			} else 	{
				alert(resultInfo.msg);
			}
		}
	}
	
	//Grid 검색창 Cell Type 정의
	function eXcell_insured(cell){ 
	    if (cell){                
	        this.cell 	= cell;
	        this.grid 	= this.cell.parentNode.grid;
	        eXcell_ed.call(this);
	    }
	    this.setValue=function(val){
	    	if(isValid(val)) {
	    		var itemList = val.split(",");
	    		var cellValue = ""; 
				var type = "";
	    		$.each(itemList, function(idx) {
	    			if(idx == 0) 	type = "(주피)";
	    			else			type = "(종피)";
	    			cellValue += "<br/>" + type + this;
	    		});
	    		if(cellValue != "") cellValue = cellValue.substring(5);
	    		val = cellValue;
	    	}
	    	var gridId=this.grid.getGridId();
	    	var grid	= this.grid;	
	    	var rowId=this.cell.parentNode.idd;
	    	var columnId		= this.grid.getColumnId(this.cell.cellIndex);
	    	var functionStr = "_G_FN.modifyInsuredPopup.open('"+gridId+"', '"+rowId+"', '"+columnId+"')";
	    	var insertStr = _SVC_DHTMLX.getSearchButtonToDhtmlx(val, functionStr, "btn_set");
	    	// Search Popup Callback 등록 => modifyInsuredPopup 에서 리턴하는 값을 처리한다.
	    	if(this.grid.userFunction.callback["insured"] == undefined) {
		    	this.grid.userFunction.callback["insured"] = function(gridId, rowId, columnId, returnData) {
		    		explanGrid.setValueById(gridId, rowId, columnId, returnData);
		    	}
	    	}
			this.setCValue(insertStr,val);  
	    }
	    this.getValue=function(){
	    	var retVal = $(this.cell.firstChild.firstChild).html().replaceAll("&nbsp;", "");
	    	retVal = retVal.replaceAll("(주피)", "");
	    	retVal = retVal.replaceAll("(종피)", "");
	    	retVal = retVal.replaceAll("<br>", ",");
	    	retVal = retVal.replaceAll("<br/>", ",");
	    	return retVal;
	    }
	}
	eXcell_insured.prototype = new eXcell; 
	
	//Grid 검색창 Cell Type 정의
	function eXcell_inputDambo(cell){ 
	    if (cell){                
	        this.cell 	= cell;
	        this.grid 	= this.cell.parentNode.grid;
	        eXcell_ed.call(this);
	    }
	    this.setValue=function(val){
	    	oVal = val;
	    	val = val.replaceAll(" "	, "");
	    	val = val.replaceAll("세"	, "");
	    	val = val.replaceAll("만원"	, "");

	    	var insuranceNum 	= fn_getSelectBox("selectInsurance");
	    	var guaranteeTerm 	= cInsuranceCommon.INS_INFO_MAP[insuranceNum].GUARANTEE_TERM;	    	
	    	
	    	if(isValid(val)) {
	    		var itemList 	= val.split(",");
	    		var cellValue 	= ""; 
	    		var validFlag 	= true;
	    		
	    		// 단일 금액 입력인 경우 현재 선택된 보장기간을 붙여서 진행한다.
 	    		if(itemList.length == 1 && itemList[0].indexOf("/") < 0) {
	    			itemList[0] = guaranteeTerm + "/" + itemList[0];
	    		}
	    		
	    		$.each(itemList, function(idx) {
	    			
	    			var itemArry = this.split("/");
    				
	    			if(itemArry.length != 2		) {
	    				validFlag = false;
	    				return false;
	    			}
    				if(!isNumber(itemArry[0])	) {
    					validFlag = false;
    					return false;
    				}
    				var objArry = itemArry[1].split("~");
    				
    				if(objArry.length > 2		) {
    					validFlag = false;
    					return false;
    				}
    				$.each(objArry, function() {
	    				if (!isNumber(this)) {
	    					validFlag = false;	
	    					return false;
	    				}
	    			});
    				if(!validFlag) return false;
    				
	    			var item = this;
	    			item = item.replaceAll("/","세/");
	    			item = item.replaceAll("~","만원~") + "만원";
	    			
	    			cellValue += "<br/>" + item;
	    		});
    			if(!validFlag) {
    				setTimeout(function() {
    					alert("입력값'" + oVal + "'은 형식에 맞지 않습니다.\n\n입력 가능한 형식은 다음과 같습니다.\n\n2000\n1000~2000\n100/2000\n100/1000~2000\n60/1000~2000,100/2000~4000\n100세/2000만원\n100세/1000만원~2000만원\n60세/1000만원~2000만원,100세/2000만원~4000만원");
    				}, 100);
    				cellValue = "";
    			}
	    		if(cellValue != "") cellValue = cellValue.substring(5);
	    		val = cellValue;
	    	}
	    	
	    	var gridId=this.grid.getGridId();
	    	var grid	= this.grid;	
	    	var rowId=this.cell.parentNode.idd;
	    	var columnId	= this.grid.getColumnId(this.cell.cellIndex);
	    	
	    	// 현재 보장기간을 구한다.
	    	var functionStr 	= "_G_FN.inputDamboPopup.open('"+gridId+"', '"+rowId+"', '"+columnId+"', '"+guaranteeTerm+"')";
	    	var insertStr 		= _SVC_DHTMLX.getSearchButtonToDhtmlx(val, functionStr, "btn_set");
	    	// Search Popup Callback 등록 => modifyInsuredPopup 에서 리턴하는 값을 처리한다.
	    	if(this.grid.userFunction.callback["inputDambo"] == undefined) {
		    	this.grid.userFunction.callback["inputDambo"] = function(gridId, rowId, columnId, returnData) {
		    		explanGrid.setValueById(gridId, rowId, columnId, returnData);
		    	}
	    	}
			this.setCValue(insertStr,val);  
	    }
	    this.getValue=function(){
	    	var retVal = $(this.cell.firstChild.firstChild).html().replaceAll("&nbsp;", "");
	    	retVal = retVal.replaceAll("<br>", ",");
	    	retVal = retVal.replaceAll("세", "");
	    	retVal = retVal.replaceAll("만원", "");
	    	return retVal;
	    }
	}
	eXcell_inputDambo.prototype = new eXcell; 
	
</script>
<!-- UI 작성 부분 -->

<h3>보험 관리</h3>

<%@include  file="/include/component/customerInfoComponent.jsp" %>
<script>
	// Component 초기화
	_SVC_COM.initComponent("customerInfoComponent", {}, function(type) {
		if(type == "reload") {
			if(_TAB_IDX == 1) 	cInsuranceManage.load();
			else				cDamboManage.init();	
			
		}
	});
</script>

<!-- tab -->
<div class="tab">
	<ul>
		<li class="first on">	<a href="javascript:;" onClick="cInsuranceCommon.changeTab1();">보험 등록/수정/삭제</a></li>
		<li>					<a href="javascript:;" onClick="cInsuranceCommon.changeTab2();">보험 담보 설정</a></li>
	</ul>
</div>
<!-- //tab -->
<div id="#" class="tab_cont">
	<div class="list_wrap">
		<div class="list_head">
			<div class="button" id="btnEdit">
				<span class="btn_list"><a href="javascript:cInsuranceManage.addRow();">보험추가</a></span>
				<span class="btn_list"><a href="javascript:cInsuranceManage.delRow();">보험삭제</a></span>
				<span class="btn_list"><a href="javascript:cInsuranceManage.goSave();">저장</a></span>
			</div>
			<div class="setting">
				<span class="btn_list"><a href="javascript:cInsuranceManage.importInsurance();">보험가져오기</a></span>
			</div>
		</div>
		<div style="width:100%;height:400px">
			<div id="${pageId}_gridbox" style="width:100%;height:100%"></div>
		</div>
	</div>
</div>
<div class="tab_cont" style="display:none">
	<h4>보험/피보험자 선택</h4>
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
					<th>보험 선택</th>
					<td>
						<select id="selectInsurance" name="selectInsurance" class="full" onChange="cSelectInsured.setSelectInsured(this.value);"></select>
					</td>
					<th>피보험자 선택</th>
					<td>
						<select id="selectInsured" name="selectInsured" class="full" onChange="cSelectInsured.changeInsured();"></select>
					</td>
				</tr>
			</tbody>
		</table>
	</div>

	<div class="div_wrap">
		<div class="div_left">
			<h4>담보 입력</h4>
			<div class="list_wrap">
				<div class="list_head">
					<div class="button" id="btnEdit">
						<span class="btn_list"><a href="javascript:cInsuranceCommon.addDamboPopup();">사용자 등록 담보 관리</a></span>
						<span class="btn_list"><a href="javascript:cInsuranceCommon.damboGroupManagePopup();">담보그룹관리</a></span>
					</div>
					<div class="setting">
						<span style="margin-top:3px">담보 그룹 : </span><select id="selectDamboGroup" name="selectDamboGroup" onChange="cDamboManage.changeDamboGroup();"></select>
						<span class="btn_ico btn_excel"><a title="Excel Download" class="excel" href="#">Excel Download</a></span>
					</div>
				</div>
				<div style="width:100%;height:400px">
					<div id="${pageId}_gridboxDambo" style="width:100%;height:100%"></div>
				</div>
			</div>
		</div>
		<div class="div_right">
			<h4>담보 입력 요약</h4>
			<div class="list_wrap">
				<div class="list_head">
					<div class="button" id="btnEdit">
						<span class="btn_list"><a href="javascript:cDamboSummary.deleteDamboSummaryRow();">항목삭제</a></span>
						<span class="btn_list"><a href="javascript:cDamboSummary.initDamboSummary();">항목초기화</a></span>
					</div>
				</div>
				<div style="width:100%;height:400px">
					<div id="${pageId}_gridboxDamboSummary" style="width:100%;height:100%"></div>
				</div>
			</div>
		</div>
	</div>
	<div class="page_button"><span class="btn_page"><a href="javascript:cDamboSummary.goSaveDambo()">저장</a></span></div>

</div>
<!-- Grid Search Type Popup -->
<%@include  file="/include/popup/modifyInsuredPopup.jsp" %>

<!-- Input Dambo Popup -->
<%@include  file="/include/popup/inputDamboPopup.jsp" %>

<!-- Add Dambo Popup -->
<%@include  file="/include/popup/addDamboPopup.jsp" %>

<!-- Add Dambo Popup -->
<%@include  file="/include/popup/damboGroupManagePopup.jsp" %>

<!-- Add Dambo Popup -->
<%@include  file="/include/popup/importInsurancePopup.jsp" %>

<%@include  file="/include/footer.jsp" %>
