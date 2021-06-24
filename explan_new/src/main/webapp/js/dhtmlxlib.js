/**
 * 그리드 제어 UTIL
 */

var _HEADER_TITLE_MAP = {};

var STATIC_BACK_COLOR = "#EFEFEF";

// 사용자 정의 함수 
// dhtmlXGridObject 객체에서 자신의 Id를 Set, Get 하는 함수 정의
dhtmlXGridObject.prototype.gridid 					= "";
dhtmlXGridObject.prototype.getGridId 				= function() 		{ 	return this.gridid; 	};
dhtmlXGridObject.prototype.setGridId 				= function(gridId) {	this.gridid = gridId;	};
dhtmlXGridObject.prototype.userFunction 			= {};
dhtmlXGridObject.prototype.userFunction.callback 	= {};
dhtmlXGridObject.prototype.userFunction.changeFn 	= {};
dhtmlXGridObject.prototype.userFunction.afterPopup 	= {};
dhtmlXGridObject.prototype.session					= {};
dhtmlXGridObject.prototype.deletedListMap			= {};
dhtmlXGridObject.prototype.isChanged				= false;
dhtmlXGridObject.prototype.changedCellList			= {};
dhtmlXGridObject.prototype.changedPreCellList		= {};
dhtmlXGridObject.prototype.putChangedCell			= function(rowId, colId, nValue) {
	if(this.changedCellList[rowId] == undefined) 		this.changedCellList[rowId] = {};
	if(this.changedPreCellList[rowId] == undefined) 	this.changedPreCellList[rowId] = {};
	this.changedPreCellList[rowId][colId] = this.changedCellList[rowId][colId];
	this.changedCellList[rowId][colId] = nValue;
	this.isChanged = true;
}
dhtmlXGridObject.prototype.deleteChangedRow			= function(rowId) {
	this.changedCellList[rowId] 	= undefined;
	this.changedPreCellList[rowId] 	= undefined;
	this.isChanged = true;
}
dhtmlXGridObject.prototype.clearChangedCell			= function() {
	this.changedCellList = {};
	this.changedPreCellList = {};
	this.isChanged = false;
}

dhtmlXGridObject.prototype.getChangedRowIds			= function() {
	if(!isValid(this.changedCellList,1)) return [];
	var resultList = [];
	$.each(this.changedCellList, function(key, value) {
		if(value != undefined) resultList.push(key);
	});
	return resultList.join();
}

dhtmlXGridObject.prototype.changedCellTypeList		= {};
dhtmlXGridObject.prototype.addCellType				= function(rowId,colId, colType) {
	var key = rowId + colId;
	this.changedCellTypeList[key] = colType;
}

//이강희 추가 Prototype 재정의
dhtmlXGridObject.prototype._in_header_master_checkbox=function(h,g,l){
	h.innerHTML=l[0]+"<input type='checkbox' />"+l[1];
	var a=this;
	h.getElementsByTagName("input")[0].onclick=function(m){
		a._build_m_order();
		var c=a._m_order?a._m_order[g]:g;
		var n=this.checked?1:0;
		a.forEachRowA(function(q){
			var o=this.cells(q,c);
			if(o.getAttribute("disabled") != true ){
				if(o.isCheckbox()){
					o.setValue(n);
					o.cell.wasChanged=true
				}
			}
        this.callEvent("onEditCell",[1,q,c,n]);
        this.callEvent("onCheckbox",[q,c,n])});
		(m||event).cancelBubble=true
	}
};

dhtmlXGridObject.prototype.getCellType			= function(rowId,colId) {
	var key = rowId + colId;
	var colType = this.changedCellTypeList[key];
	if(colType == undefined) {
		var colIdx = this.getColIndexById(colId);
		colType = this.getColType(colIdx);
	}
	return colType;
}
dhtmlXGridObject.prototype.setValidatorList	= function(validatorList) {
	this.userFunction.validatorList = validatorList;
}
dhtmlXGridObject.prototype.validateCell = function(rowId, colIdx) {
	if(explanGrid._PAUSE_VALID != undefined) return true;
	var colId = this.getColumnId(colIdx);
	var colType = this.getCellType(rowId, colId);
	if(colType == undefined) colType = this.getColType(colIdx);
	if(!in_array(colType,["ro", "roe","ednro"])) {
		if(colType == "static" || this.cells(rowId, colIdx).isDisabled()) {
			this.setCellTextStyle(rowId,colIdx,"background-color:" + STATIC_BACK_COLOR);
			return true;
		}
	}
	if(this.userFunction.validatorList == undefined) return true;
	if(typeof this.userFunction.validatorList[colId] == "function") {
		var gridId = this.getGridId();
		var colIdx = this.getColIndexById(colId);
		var val = this.cells(rowId,colIdx).getValue();
		var check = this.userFunction.validatorList[colId](val, gridId, rowId, colId);
		if(check) {
			if(typeof this.userFunction.onValidationError == "function") this.userFunction.onValidationCorrect(rowId, colIdx, val);
		} else {
			if(typeof this.userFunction.onValidationCorrect == "function") this.userFunction.onValidationError(rowId, colIdx, val);
		}
		return check;
	} 
	return true;
}

dhtmlXGridObject.prototype.setValidErrMsg = function(rowId, colId, errmsg) {
	if(!isValid(this.session["validErrMsg"])) this.session["validErrMsg"] = {};
	var key = rowId + colId;
	this.session["validErrMsg"][key] = errmsg;
}
dhtmlXGridObject.prototype.getValidErrMsg = function(rowId, colId) {
	if(!isValid(this.session["validErrMsg"])) this.session["validErrMsg"] = {};
	var key = rowId + colId;
	return this.session["validErrMsg"][key];
}

// Grid Controller
var explanGrid={
	// Grid List
	_GRID 		  		: {},
	_FN_EVENT	  		: {},
	_FN_PAGE_CALLBACK	: {},
	_PAUSE_EVENT		: {},
	_PAUSE_VALID		: undefined,
		
	dhtmlxGridKey :function(obj){
		var rCount=obj.getColumnsNum();
		
		var resultStringKey="";
		
		for (var i=0; i<rCount; i++) {
			resultStringKey+=obj.getColumnId(i);
			
			if (i != rCount-1){
				resultStringKey+=",";
			}
		}

		return resultStringKey;		
	},
	commonAlert : function(msg, obj){    
		
		var option;
		
		if(typeof obj !== 'undefined' && typeof obj === 'function' ) {
			option={title:'Alert', text:msg, ok:"Confirm", callback : obj};
		}else{
			option={title:'Alert', ok:"OK", text:msg};
		}
		
		dhtmlx.alert(option);
	},
	commonConfirm : function(name, obj){    
		
		var option;
		
		if(typeof obj !== 'undefined' && typeof obj === 'function' ) {
			option={title:'Confirm', text:name, ok:'Yes', cancel:'No', callback : obj};
		}else{
			option={title:'Confirm', text:name, ok:'Yes', cancel:'No'};
		}
		
		dhtmlx.confirm(option);
		
	},
	
	// 위성열 20140521
	// key value list 형태의 json array를 dhtmlx grid에서 사용하는 json 형태로 변환
	// ex) 
	// Parameter :
	// columnData 	=> "ITEM1,ITEM2" 또는 ["ITEM1", "ITEM2"]  
	// jsonArray 	=> [
	//			{ "ITEM1" : "v10" , "ITEM2" : "v20" },
	//			{ "ITEM1" : "v11" , "ITEM2" : "v21" },
	//		 ]
	//
	// 반환되는 값 :
	// returnJson =>
	//			{
	//			  "rows": [
	//			    {
	//			      "id": 0,
	//			      "data": [
	//			        "v10",
	//			        "v20",
	//			      ]
	//			    },
	//			    {
	//			      "id": 1,
	//			      "data": [
	//			        "v11",
	//			        "v21",
	//			      ]
	//			    }
	//			  ]
	//			}
	// 기타 :
	// Column명이 '_ROWNUM'인 경우 해당 row index가 값으로 Setting된다.(차후 Row가 추가 삭제 되도 변경 되지 않음.)
	// 최초 Load 된 Data와의 연결을 유지하기 위함.
	jsonToGridArray : function (parm) {
		var columnData 		= parm.columnData	;
		var mergePos   		= parm.mergePos		;
		var endMergePos		= parm.endMergePos	;
		var jsonArray  		= parm.jsonArray	;
		// _ROWNUM 사용 여부
		var useRownum		= parm.useRownum;
		if(useRownum) columnData = columnData + ",_ROWNUM";
		if(isValid(mergePos)) jsonArray = explanGrid.mergeGridData(jsonArray, columnData, mergePos, endMergePos);

		if(typeof columnData == "string") {
			columnData = columnData.split(",");
		}
		var returnJson = { "rows" : [] };
		if(!isValid(jsonArray,1)) return returnJson;
		$.each(jsonArray, function(num) {
			var idx = num;
			returnJson.rows[idx] = {id : idx + 1, data : []};
			var item = this;
			$.each(columnData, function(cidx){
				var cname 	= this.trim();
				var cheader	= cname.substring(0, 5);
				var oname 	= cname.removeRangeChar("[!", "]");
				var mapValue = item[oname];
				if(!isValid(mapValue)) mapValue = "";			
				if		(cname	== "_ROWNUM"	)	returnJson.rows[idx].data[cidx] = idx;
				else if	(cheader== "[!HD]"		) 	returnJson.rows[idx].data[cidx] = item[oname];
				else if	(cheader== "[!VW]"		) 	{
					var val = item[this];
					if(val == undefined) val = item[oname];
					returnJson.rows[idx].data[cidx] = val;
				}
				else returnJson.rows[idx].data[cidx] = mapValue;
				
			});
		});
		return returnJson;
	},
	// 위성열 20170228
	// GRID Cell Merge 처리
	mergeGrid : function(gridId, mergeColName) {
		var gridInfo 		= this.getGrid(gridId);
		var mygrid 			= gridInfo.grid;
		var gridData 		= gridInfo.gridParm.gridData;
		var targetColIdx	= mygrid.getColIndexById(mergeColName)
		var mergeArray	= [];

		var pivot 	= 0;
		var addIdx 	= 1;
		var preItem	= "";
		$.each(gridData, function(idx) {
			var curItem = this[mergeColName];
			if(idx == 0) {
				preItem = curItem;
			} else if(preItem == curItem) {
				addIdx++;
			} else {
				if(addIdx > 1) mergeArray.push({rowIdx:pivot,length:addIdx});
				preItem = curItem;
				pivot 	= idx;
				addIdx	= 1;
			}
		});
		if(addIdx > 1) mergeArray.push({rowIdx:pivot,length:addIdx});

		$.each(mergeArray, function() {
			var rowId = mygrid.getRowId(this.rowIdx);
			mygrid.setRowspan(rowId, targetColIdx, this.length);
		});
	},
	// 위성열 20140801
	// GRID ROWSPAN처리
	mergeGridData : function(resultData, columnData, mergePos, endMergePos) {
		var coList = typeof columnData == "string" ? columnData.split(",") : columnData;
		if(endMergePos == undefined) endMergePos = mergePos + 1;
		if(coList.length > mergePos) coList = coList.slice(mergePos, endMergePos);
		var preKey = [];
		var returnList = [];
		$.each(resultData, function(idx) {
			var item = fn_copyObject(this);
			$.each(coList, function(idx) {
				if(preKey[idx] == item[this]) {
					item[this] = "&nbsp;";
				} else {
					for(var ii=idx; ii < coList.length;ii++) {
						preKey[ii] = item[coList[ii]];	
					}
					return false;
				}
			});
			returnList.push(item);
		});
		return returnList;
	},
	// Grid 설정및 그리기
	makeGrid : function(gridParm) {
		if(!_PAGE_LOAD_CHECK) {
			setTimeout(function() {
				var mygrid = explanGrid.makeGrid(gridParm);
				if(typeof gridParm.callback == "function") gridParm.callback(mygrid);
			}, 500);
		} else {
			if(gridParm.dataConfig 				== undefined) gridParm.dataConfig = {};
			if(gridParm.dataConfig.useRownum 	== undefined) gridParm.dataConfig.useRownum = false;
			
			
			
			var mygrid = this.preMakeGrid(gridParm);
			mygrid = this.initMakeGrid(gridParm, mygrid);
			
			// callback이 있으면 실행 시킴
			if(typeof gridParm.callback == "function") gridParm.callback(mygrid);
			
			return mygrid;
		}
	},
	// grid init 전까지 설정
	preMakeGrid : function(gridParm , objGrid) {
		// 생성할 Grid ID(DOM 아이디와 동일하게 사용)
		var targetDivId 	= gridParm.targetDivId	;
		
		// DOM 초기화
		_SVC_DHTMLX.renewGridBox(targetDivId);
		
		// 이전 Grid 초기화
		this._FN_EVENT[targetDivId]	= undefined;
		this._GRID[targetDivId]		= undefined;
		
		this._FN_PAGE_CALLBACK[targetDivId]	= gridParm.pageCallBackFn;
		
		this._FN_EVENT[targetDivId]	= undefined;
		
		// use auto resize
		var useAutoResize	= gridParm.useAutoResize;
		if(useAutoResize) _SVC_DHTMLX.registAutoResize(targetDivId);
		
		// 컬럼 순서
		var orderList  		= gridParm.orderList 	;
		var orderArray 		= orderList.split(",") 	;
		
		if(gridParm.dataConfig 				== undefined) gridParm.dataConfig = {};
		if(gridParm.dataConfig.useRownum 	== undefined) gridParm.dataConfig.useRownum = false;
		var useRownum = gridParm.dataConfig.useRownum;

		// 멀티헤더 추가 헤더 정보
		var addHeaderList  	= gridParm.addHeaderList;
		
		// Header Title Map
		var headerToolTipMap = gridParm.headerToolTipMap;
		
		// Grid에 사용할 JSON Data
		var gridData  		= gridParm.gridData  	;
		// Header 설정 기본 설정
		var cellConfig	= gridParm.cellConfig		;
		
		// Block Copy를 사용할지 여부
		var useBlockCopy	= gridParm.useBlockCopy	;
		
		// Validation에 사용할 함수리스트
		var validatorList	= gridParm.validatorList;
		
		// Grid Height 지정
		var gridHeight		= gridParm.gridHeight	;
		
		// 세로 펼치기
		var useAutoHeight	= gridParm.useAutoHeight;
		
		// 사용자 정의 Word Overload
		var wordList		= gridParm.wordList;
		
		// 필수값 표시
		var showRequired	= gridParm.showRequired;
		
		/**************************************************************************************
		*  Sub Grid 관련 속성
		**************************************************************************************/
		var subGridConfig = gridParm.subGridConfig;
		
		/**************************************************************************************
		*  헤더 속성 설정이 없는경우 Defalut 설정
		**************************************************************************************/
		if(cellConfig 		== undefined) cellConfig 	= {};
		// 헤더 기본 설정이 없는경우 세팅
		var defaultConfig = cellConfig.defaultConfig;
		if(defaultConfig 		== undefined) defaultConfig	= {};
		// 헤더 기본 설정 중 필수 설정이 없는 경우 세팅
		if(defaultConfig.colType 	== undefined) defaultConfig.colType 	= "ro"	;  
		if(defaultConfig.align 		== undefined) defaultConfig.align 		= "left";  

		// Column 세부 설정(필요한 경우만 세팅)
		var columnConfig	= cellConfig.columnConfig == undefined ? {} : cellConfig.columnConfig;
		//// ROWNUM 기본설정
		$.each(orderArray, function() {
			if(this.substring(0,5) == "[!RN]") columnConfig[this] = {"width":40, "align":"center", "colType" : "cntr"};
		});
		//// addHeaderList 정보가 없는경우 Header 기본 세팅 
		if(addHeaderList == undefined) {
			// [!CB]에 대한 checkbox처리
			var oList = orderList.replaceAll("[!CB]", "#master_checkbox");
			addHeaderList = [oList.split(",")];
		}
		if(columnConfig["[!CB]"] == undefined) columnConfig["[!CB]"] = {"width":35, "align":"center", "colType" : "ch"};
		/**************************************************************************************/
		
		var headerList = orderList.split(",");
		var index = 0;
		var config = {
			align 			: "",
			colType			: "",
			ids 			: "",
			width			: "",
			sortType		: "",
		};
		$.each(headerList, function(idx) {
			var headerName = this;
			
			var width 		= defaultConfig.width	;
			var colType 	= defaultConfig.colType ;
			var align 		= defaultConfig.align	;
			var sortType 	= defaultConfig.sortType;

			/**************************************************************************************
			*  컬럼 세부 설정이 있는 경우 별도 세팅
			**************************************************************************************/

			var colConfig = columnConfig[headerName];

			if(colConfig != undefined) {
				if(isValid(colConfig.width		))  width 	= colConfig.width	;
				if(isValid(colConfig.colType	)) colType 	= colConfig.colType	;
				if(isValid(colConfig.align		)) align 	= colConfig.align	;
				if(isValid(colConfig.sortType	)) sortType = colConfig.sortType;
				if(width == "auto") width = "";
			}

			/*************************************************************************************/
			if(!isValid(width,1)) 	width = "150";  //default
			if(!isValid(colType)) 	colType = "";
			if(!isValid(align)) 	align 	= "";
			config.ids			 += "," + orderArray[idx];
			config.width		 += "," + width;
			config.colType		 += "," + colType;
			config.align 		 += "," + align;
			
			if ( sortType != undefined){
				config.sortType 	 += "," + sortType;
			}
			else{
				config.sortType 	 += ",na";
			}

			index = idx;
		});
		if(index > 0) {
			config.align 			= config.align		.substring(1);	
			config.colType	        = config.colType	.substring(1);  
			config.ids		        = config.ids  		.substring(1);  
			config.width	        = config.width 		.substring(1);  
			config.sortType	        = config.sortType 	.substring(1);
		}
		// ROWNUM사용하는경우
		if(useRownum) {
			config.align 			+= ",left";
			config.colType	        += ",ro";
			config.ids		        += ",_ROWNUM";
			config.width	        += ",0"; 
			config.sortType	        += ",na";
		}
		
		var mygrid ;
		
		if ( objGrid != undefined ) {
			mygrid = objGrid;
		}
		else {
			mygrid = new dhtmlXGridObject({
				parent 			: targetDivId,
				skin 			: 'dhx_skyblue',
				hover 			: 'hover',
				editable 		: true,
				autowidth 		: true,
				autoheight 		: true,
				multiselect 	: false,
				withoutheader 	: false,
			    image_path 		: '/explan/js/dhtmlx/codebase/imgs/'
			});
		}
		// 기본 Grid설정 값 초기화.
		mygrid.gridid 					= "";
		mygrid.userFunction 			= {};
		mygrid.userFunction.callback 	= {};
		mygrid.userFunction.changeFn 	= {};
		mygrid.userFunction.afterPopup 	= {};
		mygrid.session					= {};
		mygrid.isChanged				= false;
		mygrid.changedCellList			= {};
		mygrid.changedPreCellList		= {};
		mygrid.changedCellTypeList		= {};
		
		// gridId를 세팅한다.(차후 Cell Type 처리시 자신의 Grid Id를 읽을때 사용한다.) 		
		mygrid.setGridId(targetDivId);
		// gridHeight 높이를 지정한다.
		if(gridHeight != undefined) mygrid.height = gridHeight;

		// Grid Header Setting
		var headerTitleMap = _SVC_COM.getWordListMap();
		if(isValid(gridParm.wordList)) {
			$.each(gridParm.wordList, function(key, value) {
				headerTitleMap[key] = value;
			});
		}
		$.each(addHeaderList, function(index) {
			
			// Word Management 처리
			//----------------------------------------------------------------------------------------------
			var item = this;
			$.each(item, function(idx) {
				item[idx]  = item[idx].removeRangeChar("[!", "]");
				
				// Header Tooltip 구성
				var title = "";
				if(headerToolTipMap != undefined && headerToolTipMap[item[idx]] != undefined) title = "title='" + headerToolTipMap[item[idx]] + "'"; 

				var headerStr = headerTitleMap[item[idx]];
				// Word Map에서 Mapping처리한다.
				// 메타 문자를 제거한다.
				item[idx]  = (headerStr == undefined ? item[idx] : headerStr);
				item[idx] = item[idx].replace(/(\r\n|\n|\r)/g,"<br />");//줄바꿈 이강희
				if(gridParm.useAdjust) item[idx] = item[idx].replaceAll(" ", " ");
				item[idx] = item[idx].trim();
				var cConfig = columnConfig[orderArray[idx]];
				var comboCheck = false;
				
				// 필수 항목 표시 처리
				var pstr = "";
				if(showRequired) {
					if(item[idx] != '' && isValid(cConfig) && !cConfig.allowEmpty) pstr = "<span style=color:red>* </span>";
				} 
				
				if(addHeaderList.length == (index + 1) && cConfig != undefined && cConfig.colType == "combo") comboCheck = true;
				if(item[idx].substring(0, 1) != "#") {
					if(!comboCheck)  {
						item[idx] = "<center "+title+">" + pstr + item[idx] + "&nbsp;&nbsp;</center>";
					}
					else {
						item[idx] = "<center "+title+">" + pstr + item[idx] + "&nbsp;&nbsp;</center>";
					}
				}
			});
			//----------------------------------------------------------------------------------------------
			if(useRownum) item[item.length] = "";
			if(index == 0) 	mygrid.setHeader	(fn_jsonClone(item));
			else 			mygrid.attachHeader	(fn_jsonClone(item));
		});
		
		mygrid.enableAlterCss("evenGrid", "unevenGrid");
	    mygrid.setStyle("", "border-bottom:1px solid #dcdcdc;border-right:1px solid #dcdcdc","", "");
		mygrid.setColAlign	(config.align);
		mygrid.setColTypes	(config.colType); //ro:readonly, ed:edit, ch:checkbox, dhxCalendarA : calendar 읽고 쓰기, dhxCalendar, edncl : 숫자값만(Edit가능), ednro : 숫자값만 Read only
		mygrid.setColumnIds	(config.ids);
		mygrid.setInitWidths(config.width);	
		mygrid.setColSorting(config.sortType);
		mygrid.enableEditEvents(false, true, false);
		mygrid.setDateFormat("%Y-%m-%d");
		
		// Grid Data를 전역으로 관리하기 위해 등록한다.
		this._GRID[targetDivId] = {
			"grid" 		: mygrid	,
			"orderList"	: orderList	,
			"gridParm"	: gridParm	,
			"gridData"	: gridData
		}

		// number, mnum format 처리
		$.each(config.colType.split(","), function(idx) {
			if(this == "edncl" || this == "ednro") {
				var fix;
				if(columnConfig[orderArray[idx]] != undefined) fix = columnConfig[orderArray[idx]].fix;
				var tailStr = "";
				if(fix != undefined) {
					for ( var ii = 0; ii < fix; ii++) tailStr += "0";
					if(tailStr != "") tailStr = "." + tailStr;
				}
				mygrid.setNumberFormat("0,000" + tailStr,idx);
			}
		});
		
		// validator 처리
		if(isValid(validatorList)) {
			var validators = "";
			// 읽기 전용 Column은 솎아낸다.
			mygrid.setValidatorList(validatorList)

			explanGrid.attachEvent(targetDivId, "onValidationError",function(rowId,colIdx,value){
				var gridId 		= mygrid.getGridId();
		    	var colId 		= explanGrid.getColId(gridId, colIdx);
				var cellType 	= mygrid.getCellType(rowId,colId);
				if(in_array(cellType, ["roe","static"])) {
					mygrid.setCellTextStyle(rowId,colIdx,"background-color:"+STATIC_BACK_COLOR+";");
					return;
				}
				var strMessage = "Error at cell,value must not be empty";
				var isNoData = explanGrid.getGrid(targetDivId).isNoData;
				if(isNoData) 	mygrid.setCellTextStyle(rowId,colIdx,"background-color:;");
				else			mygrid.setCellTextStyle(rowId,colIdx,"background-color:#FAD9D9;");					
				mygrid.cells(rowId , colIdx).setAttribute("invalid" , false);
				return false;
			});
			explanGrid.attachEvent(targetDivId, "onValidationCorrect",function(rowId,colIdx,value){
				var gridId 		= mygrid.getGridId();
		    	var colId 		= explanGrid.getColId(gridId, colIdx);
				var cellType 	= mygrid.getCellType(rowId,colId);
				var color = ";";
				if(in_array(cellType, ["static","roe"])) color = STATIC_BACK_COLOR + ";";
				mygrid.setCellTextStyle(rowId,colIdx,"background-color:" + color);
				mygrid.cells(rowId , colIdx).setAttribute("invalid" , true);
				return true;
			});
			
			config.validators = validators;
		}
		
		// ROWNUM사용하는경우
		if(useRownum) mygrid.setColumnHidden(mygrid.getColIndexById("_ROWNUM"), true);
		
		//
		// Block Copy 관련 키처리
		//
		mygrid.attachEvent("onKeyPress",function(code,ctrl,shift) {
			// Block Copy 처리
			if(useBlockCopy) {
				if(code==67&&ctrl){
					if (!mygrid._selectionArea) {
						explanGrid.selectedRowCopy(targetDivId, "key");
						return true;
					}
					mygrid.setCSVDelimiter("\t");
					mygrid.copyBlockToClipboard();
				}
				else if(code==86&&ctrl){
					explanGrid.pasteFromClipboard(mygrid);
				}
				else if(code == 46) {
					if(mygrid.session["lastEditStage"] != 1) explanGrid.deleteSelectedCellData(targetDivId);
				}
			} else {
				if(code==67&&ctrl) explanGrid.selectedRowCopy(targetDivId, "key");
			}
			if(code==90) {
				if(ctrl && shift) {
					//explanGrid.redo(targetDivId);
				} else if(ctrl) {
					//explanGrid.undo(targetDivId);
				}
			}
			return true;
		});
		gridParm.config = config;

		return mygrid;
	},
	// grid init 포함 그 이후 설정
	initMakeGrid : function(gridParm, mygrid) {
		// 생성할 Grid ID(DOM 아이디와 동일하게 사용)
		var targetDivId 	= gridParm.targetDivId	;
		
		/**************************************************************************************
		*  헤더 속성 설정이 없는경우 Defalut 설정
		**************************************************************************************/
		var cellConfig	= gridParm.cellConfig		;
		if(cellConfig 		== undefined) cellConfig 	= {};
		// 헤더 기본 설정이 없는경우 세팅
		var defaultConfig = cellConfig.defaultConfig;
		if(defaultConfig 		== undefined) defaultConfig	= {};

		// Column 세부 설정(필요한 경우만 세팅)
		var columnConfig	= cellConfig.columnConfig == undefined ? {} : cellConfig.columnConfig;
		
		// use auto resize
		var useAutoResize	= gridParm.useAutoResize;
		
		// 컬럼 순서
		var orderList  		= gridParm.orderList 	;
		var orderArray 		= orderList.split(",") 	;
		// Split 위치
		var splitName   	= gridParm.splitName  	;
		// Grid에 사용할 JSON Data
		var gridData  		= gridParm.gridData  	;
		
		var useRownum 		= gridParm.dataConfig.useRownum;

		// Block Copy를 사용할지 여부
		var useBlockCopy	= gridParm.useBlockCopy	;
		
		// Total Cnt 지정 ID
		var totalCntId		= gridParm.totalCntId	;
		
		// Grid 비활성화
		var gridDisabled = gridParm.gridDisabled;

		// 세로 펼치기
		var useAutoHeight	= gridParm.useAutoHeight;
		
		// Paste 할때 Row 자동 증가 설정
		var pasteAutoExtend	= gridParm.pasteAutoExtend;
		
		// row cell merge column name
		var mergeColName	= gridParm.mergeColName;
		
		//Select Cell Back Color 변경
		mygrid.setStyle("","","background-color:#adb8f5!important","border-top:1px solid #fb7e93;border-bottom:1px solid #fb7e93;");
		
		mygrid.init();
		
		// Commbo 항목 설정
		if(cellConfig.columnConfig != undefined) {
	  		// Combo항목 설정
	  		$.each(cellConfig.columnConfig, function(key, obj) {
	  			if(obj.colType != "combo") return true;
	  			var colIdx = mygrid.getColIndexById(key);
	  			var comboObj = mygrid.getColumnCombo(colIdx);
	  			var newKey = key;
	  			if(isValid(obj.subId)) newKey += obj.subId;  
	  			var optionMap = _DD_MAP[newKey];
	  			if(optionMap == undefined) return true;
	  			$.each(optionMap, function(key, value) {
	  				comboObj.addOption(key,value);    
	  			});
	  		});
		}

		//사양서 적기 위해서 Label 복사 지원 Create By 이강희
		mygrid.entBox.onselectstart = function(){ return true; };
		//mygrid.entBox.onselectstart=function(e){(e||event),cancelBubble=true;return true;};
		
		if(splitName != undefined) this.splitAt(mygrid, splitName, 1);
		
		//페이징
		if(useAutoHeight != undefined && mergeColName == undefined) mygrid.enableSmartRendering(true , 100);

		//mygrid.enablePreRendering(50);
		//mygrid.setAwaitedRowHeight(20);
		if(splitName != undefined){
			mygrid.setAwaitedRowHeight(29);  //Split
		}
		else{
			mygrid.setAwaitedRowHeight(28);  //Non-Split
		}
		
//			mygrid.enableSmartRendering(true);
//			mygrid.enablePreRendering(100);
		//mygrid.enableDistributedParsing(true,20,150); 		
		
		if(Object.prototype.toString.call(gridData)  == '[object Array]') {
			// 리스트 Array Grid Data로 변환하여 사용하는경우
			gridParm.dataConfig.columnData 	= orderList;
			gridParm.dataConfig.jsonArray 	= gridData;
			var result = explanGrid.jsonToGridArray(gridParm.dataConfig);
			mygrid.parse(result,"json");
			
		} else {
		// 직접 Grid Data를 사용하는경우
			mygrid.parse(gridData,"json");
		}
		
		// Column Header가 '[!HD]'인 항목 Hidden 처리한다.
		var viewOrderList = "";
		$.each(orderArray, function() {
			var cheader = this.substring(0, 5);
			if(cheader== "[!HD]") mygrid.setColumnHidden(mygrid.getColIndexById(this), true);
			else {
				if(viewOrderList == "") viewOrderList  = 		this;
				else					viewOrderList += "," + 	this;
			}
		});
		// Grid Data를 전역으로 관리하기 위해 등록한다.
		this._GRID[targetDivId].isNoData 		= false;
		this._GRID[targetDivId].viewOrderList 	= viewOrderList;
		
		// Grid의 RowId를 저장한다.
		var rowIdList = explanGrid.getGridToJson(targetDivId, ["_ROWID"]);
		this._GRID[targetDivId].loadRowIdList 	= rowIdList;
		this._GRID[targetDivId].loadRowIdMap 	= arrayToMap(rowIdList, "_ROWID");
		
		// Block Copy 사용하는경우.
		if(useBlockCopy) mygrid.enableBlockSelection();
		
		// Total Cnt 지정 Id가 있으면 Total Cnt 표시
		if(totalCntId != undefined) $("#" + totalCntId).html(addComma(mygrid.getRowsNum()));
		
		// 열이 없는 경우 No Data 표시
		if (mygrid.getRowsNum()==0 && splitName == undefined){
			this.setNotFound(targetDivId, _NO_DATA_STR);
		}
		mygrid.enableUndoRedo();

		// 생성할때 창 Size에 맞춘다.
		if(useAutoResize) _SVC_DHTMLX.gridResize(targetDivId);
		if(gridParm.useAutoResize) $(window).trigger("resize");

		if(gridParm.useAdjust) this.adjustCellWidth(targetDivId);

		/**************************************************************************************
		*  Grid에 Session 등록 
		**************************************************************************************/
		var session			= gridParm.session;
		if(session != undefined) mygrid.session = session;
		
		// Paste Auto Extend 설정값 세션에 저장
		mygrid.session.pasteAutoExtend = pasteAutoExtend;
		
		/**************************************************************************************
		*  On Change Event 처리 
		**************************************************************************************/
		var gridId = targetDivId;
		// change evnet 처리
		var cellChangeFunc = function(rowId, colId, nValue) {
			if(colId.removeRangeChar("[!", "]") == "") return;
			mygrid.putChangedCell(rowId, colId, nValue);
		}
		mygrid.attachEvent("onEditCell", function(stage,rId,cInd,nValue,oValue){
			mygrid.session["lastEditStage"] = stage;
			if(nValue != undefined) nValue = (nValue + "").replaceAll("&nbsp;", " ").trim();
			if(oValue != undefined) oValue = (oValue + "").replaceAll("&nbsp;", " ").trim();
	    	var colId = explanGrid.getColId(gridId, cInd);
			if(colId != "[!CB]") mygrid.session["cellEditState"] = stage;
			var coltype = mygrid.getColType(cInd);
			if ( coltype == "edncl") $(".dhx_combo_edit").select();

			if(stage != 2 || nValue == oValue) return true;

			var rowData 	= explanGrid.getRowData(gridId, rId);
			if(isValid(rowData,1)) {
				if(typeof mygrid.userFunction.changeFn[gridId] == "function") mygrid.userFunction.changeFn[gridId](gridId, rId,colId ,nValue, "EC", rowData);
			}
			mygrid.session["org_" + rId + colId] = undefined;
			
			explanGrid.validCheckRowColumn(gridId, rId, colId);
			
			return true;
		});			
		mygrid.attachEvent("onCellChanged", function(rId,cInd,nValue){

			var colId = explanGrid.getColId(gridId, cInd);
	    	cellChangeFunc(rId, colId, nValue);
			
			// Grid에서 Combo Scroll따라가는 현상 임시 해결 방안
			//$(".layer_pop_wrap .layer_pop .contents").css("overflow-y", "auto");
			
			if(nValue != undefined) nValue = (nValue + "").replaceAll("&nbsp;", " ").trim();
			
			// Event 일시 정지 인경우 Onchange Event 실행 하지 않음.
			if(explanGrid._PAUSE_EVENT[gridId] != undefined && explanGrid._PAUSE_EVENT[gridId]["ONCHANGE"] == "Y") return true;

			// Cell을 Access 했어도 값 변경이 없으면 onChange Event를 실행 하지 않는다.
			var oData = explanGrid.getPreCellData(gridId, rId, colId);
			if(oData == undefined) {
				var orgRowData	= explanGrid.getOrgDataByRowId(gridId, rId);
				if(orgRowData == undefined) orgRowData = {};
				oData = orgRowData[colId];
				if(oData == null) oData = "";
			}

			if(nValue != undefined && oData == nValue) return true;
			
			rowData = explanGrid.getRowData(gridId, rId);
			
			if(isValid(rowData,1)) {
				if(typeof mygrid.userFunction.changeFn[gridId] == "function") mygrid.userFunction.changeFn[gridId](gridId, rId,colId ,nValue, "CC", rowData);
			}
			
			explanGrid.validCheckRowColumn(gridId, rId, colId);
			
			return true;
		});
		
		/**************************************************************************************
		*  On Click Event 처리 
		**************************************************************************************/
		mygrid.attachEvent("onRowSelect", function(rId,cInd){
	    	var colId 	= explanGrid.getColId(gridId, cInd);
			var rowData	= explanGrid.getRowData(gridId, rId);
			if(typeof mygrid.userFunction.onClick == "function") mygrid.userFunction.onClick(gridId,rId,colId,rowData);
			return true;
		});
		
		
		// Grid의 width 자동 조절 기능의 버그를 수정하기위한 처리
		//if($("#"+gridId+"_hiddenHeader").length > 0) $("#"+gridId+"_hiddenHeader").parent().parent().parent().hide();

		/*******************************************************************************************************
		 * 이벤트 filter관련 추가 
		 ********************************************************************************************************/
		//행추가 삭제시 ROW갯수 업데이트
		
		if ( gridParm.paging != true){
			mygrid.attachEvent("onGridReconstructed", function(grid_obj){
			    // your code here
				
				var gridInfo = explanGrid.getGrid(gridId);
				
				// Total Cnt 지정 ID
				var totalCntId		= gridInfo.gridParm.totalCntId	; 
				// Total Cnt 지정 Id가 있으면 Total Cnt 표시
				if(totalCntId != undefined)
				{
					var cnt = mygrid.getRowsNum();
					$("#" + totalCntId).html(addComma(mygrid.getRowsNum()));
				}
				
			});
		}else {
			
			//페이징 부분
			var cnt = gridParm.totalcount;
			if(totalCntId != undefined)
			{
				$("#" + totalCntId).html(addComma(cnt));
			}	
			
			this.setPageBox(gridId);
			
		}
		
		//Filter 관련 업데이트
		mygrid.attachEvent("onFilterEnd", function(elements){
			
			var gridInfo = explanGrid.getGrid(gridId);
			
			// Total Cnt 지정 ID
			var totalCntId		= gridInfo.gridParm.totalCntId	; 
			// Total Cnt 지정 Id가 있으면 Total Cnt 표시
			if(totalCntId != undefined)
			{
				var cnt = mygrid.getRowsNum();
				$("#" + totalCntId).html(addComma(mygrid.getRowsNum()));
			}
		});
		
		//if(useAutoHeight != undefined) mygrid.enableAutoHeight(true);
		
		// 세로축 같은 이름으로 된 Cell을 병합한다.
		if(isValid(mergeColName)) explanGrid.mergeGrid(gridId, mergeColName);
			
		// 그리드를 비활성화 한다.
		if(gridDisabled) {
			mygrid.attachEvent("onBeforeSelect", function(){
			    return false;
			});
		}

		return mygrid;
	},
	adjustCellWidth : function(gridId, colId) {
		var gridInfo = this.getGrid(gridId);
		var mygrid 			= gridInfo.grid;
		var orderArray 		= gridInfo.orderList.split(",");
		if(gridInfo.gridParm.cellConfig 				== undefined) gridInfo.gridParm.cellConfig 				= {}
		if(gridInfo.gridParm.cellConfig.defaultConfig 	== undefined) gridInfo.gridParm.cellConfig.defaultConfig 	= {};
		if(gridInfo.gridParm.cellConfig.columnConfig	== undefined) gridInfo.gridParm.cellConfig.columnConfig 	= {};
		var defaultConfig 	= gridInfo.gridParm.cellConfig.defaultConfig;
		var columnConfig	= gridInfo.gridParm.cellConfig.columnConfig;
		// Column 자동 조정
		if(	defaultConfig.width	== undefined ) {
			if(colId == undefined) {
				$.each(orderArray, function() {
					var columnName = this;
					if(columnConfig[columnName] 		== undefined) columnConfig[columnName] = {};
					if(columnConfig[columnName].width 	== undefined) {
						var cIdx = mygrid.getColIndexById(columnName);
						mygrid.adjustColumnSize(cIdx);
					}  
				});
			} else {
				var columnName = colId;
				if(columnConfig[columnName] 		== undefined) columnConfig[columnName] = {};
				if(columnConfig[columnName].width 	== undefined) {
					var cIdx = mygrid.getColIndexById(columnName);
					mygrid.adjustColumnSize(cIdx);
				}  
			}
		} else {
			if(colId == undefined) {
				$.each(orderArray, function() {
					var columnName = this;
					if(columnConfig[columnName] 		== undefined) columnConfig[columnName] = {};
					if(columnConfig[columnName].width 	== "auto") {
						var cIdx = mygrid.getColIndexById(columnName);
						mygrid.adjustColumnSize(cIdx);
					}  
				});
			} else {
				var columnName = colId;
				if(columnConfig[columnName] 		== undefined) columnConfig[columnName] = {};
				if(columnConfig[columnName].width 	== "auto") {
					var cIdx = mygrid.getColIndexById(columnName);
					mygrid.adjustColumnSize(cIdx);
				}  
				
			}
		}
	},
	// Data 일괄 로드
	loadData : function(gridId, gridData) {
		var mygrid 		= this._GRID[gridId].grid;
		var gridParm	= this._GRID[gridId].gridParm;
		var orderList	= this._GRID[gridId].orderList;
		if(!isValid(gridData)) gridData = [{}];
		this._GRID[gridId].gridData = gridData;
		this._GRID[gridId].isNoData = false;
				
		var dataConfig = {
			columnData	: orderList,
			jsonArray 	: gridData
		};

		mygrid.clearAll();
		
		mygrid.setColTypes	(gridParm.config.colType);
		
		if(Object.prototype.toString.call(gridData)  == '[object Array]') {
			// 리스트 Array Grid Data로 변환하여 사용하는경우
			gridParm.dataConfig.columnData 	= orderList;
			gridParm.dataConfig.jsonArray 	= gridData;
			var result = explanGrid.jsonToGridArray(gridParm.dataConfig);
			mygrid.parse(result,"json");
		} else {
		// 직접 Grid Data를 사용하는경우
			mygrid.parse(gridData,"json");
		}
		
		// Total Cnt 지정 ID
		var totalCntId		= gridParm.totalCntId	; 
		// Total Cnt 지정 Id가 있으면 Total Cnt 표시
		if(totalCntId != undefined)
		{
			var cnt = mygrid.getRowsNum();
			$("#" + totalCntId).html(addComma(mygrid.getRowsNum()));
		}
		
		// 열이 없는 경우 No Data 표시
		if (mygrid.getRowsNum()==0){
			this.setNotFound(gridId, _NO_DATA_STR);
		}
		
		mygrid.clearChangedCell();
	},
	deleteAll : function(gridId) {
		var mygrid 	= this._GRID[gridId].grid;
		var rowIds 	= mygrid.getAllRowIds();
		var rowIdList = rowIds.split(",");
		$.each(rowIdList, function() {
			explanGrid.deleteRowById(gridId, this);
		})
	},
	// Data 일괄 Add row
	addRowList : function(gridId, gridData, direct) {
		var mygrid 		= this._GRID[gridId].grid;
		var orderList	= this._GRID[gridId].orderList;
		if(direct == undefined) direct = "asc";
		
		this._GRID[gridId].gridData = gridData;
		$.each(gridData, function() {
			var rowId;
			if(direct == "asc")	rowId = explanGrid.addRow(gridId, 0);
			else				rowId = explanGrid.addRow(gridId);
			explanGrid.setRow(gridId, rowId, this);
		});
		this._GRID[gridId].isNoData = false;
	},
	// Data 일괄 Add row
	addTreeRowList : function(gridId, gridData, direct) {
		var mygrid 		= this._GRID[gridId].grid;
		var orderList	= this._GRID[gridId].orderList;
		
		if(direct == undefined) direct = "asc";
		
		this._GRID[gridId].gridData = gridData;
		$.each(gridData, function() {
			
			var rowId;
			if ( this.PRIMARY_PLANT_YN == "Y"){	 //Origin Plant
				if(direct == "asc")	rowId = explanGrid.addRow(gridId, 0);
				else				rowId = explanGrid.addRow(gridId);
			}else {
				var parm = {
						gridId		: gridId 	, 
						rowIdx      : 0         			,
						isChild 	: "1"			
				}
				
				rowId = explanGrid.treeGridAddRow(parm);
			}
			explanGrid.setRow(gridId, rowId, this);
		});
		this._GRID[gridId].isNoData = false;
		
		//리셋카운터
		mygrid.expandAll();
		var colIdx = mygrid.getColIndexById("[!RN]");
		if(colIdx == undefined) return;
		mygrid.resetCounter(colIdx);
	},
	// 사용중인 Grid를 반환한다.
	getGrid : function(gridId) {
		return this._GRID[gridId]; 
	},
	// Grid가 비었는지 여부
	isEmpty : function (gridId) {
		var cnt = this.getGridRowCount(gridId);
		return cnt == 0 || this._GRID[gridId].isNoData;
	},
	/**
	 * Grid Data를 json형태로 반환한다.
	 * parameter 
	 * gridId : 대상 Grid Id
	 * rownum 	   : 값이 있는 경우 해당 Row Data만
	 * 				 값이 없는 경우 전체 Row Data
	 * filterArray : Data값중 UI에서만 사용되는 특정 태그를 삭제한다.
	 *               ex) [["<a", "</a>"],["<span", "</span>"]] => a tag, span Tag 내용을 삭제한다. 
	 */
	getGridToJsonByRowId : function(gridId, rowId, colIdList) {
		var mygrid = this._GRID[gridId].grid;
		var item = {};
		if(colIdList == undefined) {
	        for(var cellIndex = 0; cellIndex < mygrid.getColumnsNum(); cellIndex++){
	        	var val;
	        	try{
	            	val = mygrid.cells(rowId,cellIndex).getValue();
	        	} catch(e) {
	        		return null;
	        	}
	        	var colId = mygrid.getColumnId(cellIndex);
				// Header Tag가 '[!VW]'인경우 Data로 사용하지 않는다.
				var cheader = colId.substring(0, 5);
	        	if(cheader != "[!VW]") {
		        	if(colId != undefined) colId = colId.removeRangeChar("[!", "]")
		        	if(!isValid(colId,1)) continue; 
		        	item[colId] = val;
	        	}
	        }
		} else {
			$.each(colIdList, function() {
				var colId 	= this;
				var val 	= explanGrid.getValueById(gridId, rowId, colId);
				item[colId] = (val + "").replaceAll("&nbsp;", " ").trim();
			});
		}
        item._ROWID = rowId;
        return item;
	},
	// getGridToJsonByRowId 함수와 동일하게 쓰임.
	getRowData	: function(gridId, rowId, colList) {
		return this.getGridToJsonByRowId(gridId, rowId, colList);
	},
	getValueById : function(gridId, rowId, colId) {
		var mygrid = this._GRID[gridId].grid;
		var cellIndex = mygrid.getColIndexById(colId);
		if(cellIndex == undefined) cellIndex = mygrid.getColIndexById("[!HD]" + colId);
		if(cellIndex == undefined) return;
		var val = mygrid.cells(rowId,cellIndex).getValue();
		return val;
	},
	// returnType = undefined : 전체 읽음
	// returnType = "C" : 변경된것만 읽음
	getGridToJson : function(gridId, colIdList, returnType) {
		if(!isValid(this._GRID[gridId])) return null;
		var mygrid 		= this._GRID[gridId].grid;
		var orderList	= this._GRID[gridId].orderList.split(",");
		
		if(explanGrid.isEmpty(gridId)) return [];
		
		// 전체 Row Setting
	    var result = [];
		var rowIds = "";
		if(returnType == "C") 	rowIds = mygrid.getChangedRowIds();
		else					rowIds = mygrid.getAllRowIds();
		if(rowIds == "") return result;
		var rowIdList = rowIds.split(",");
		$.each(rowIdList, function() {
			var item = {};
			var rowId = this;
			if(!isValid(colIdList) || colIdList.length == 0) {
		        for(var cellIndex = 0; cellIndex < mygrid.getColumnsNum(); cellIndex++){
					if(orderList[cellIndex] == "[!CB]" || orderList[cellIndex] == "[!RN]") continue;
		        	var val = mygrid.cells(rowId,cellIndex).getValue();
		        	var colId = mygrid.getColumnId(cellIndex);
					// Header Tag가 '[!VW]'인경우 Data로 사용하지 않는다.
					var cheader = colId.substring(0, 5);
					//이강희
		        	if(cheader != "[!VW]") {
			        	if(colId != undefined) colId = colId.removeRangeChar("[!", "]");
			        	if ( val != undefined){
			        		if(colId != "") item[colId] = (val + "").replaceAll("&nbsp;", " ").trim();
			        	}
			        	else {
			        		val = "";
			        	}
		        	}
		        }
			} else {
				$.each(colIdList, function() {
					var colId 	= this;
					var val 	= explanGrid.getValueById(gridId, rowId, colId);
					item[colId] = (val + "").replaceAll("&nbsp;", " ").trim();
				});
			}
	        item["_ROWID"] = rowId;
	        result[result.length] = item;
	    });
		return result;
		//필터 초기화
		//mygrid.filterByAll();
	},
	// 화면에 보이는 Data만 가져온다.
	getGridViewData : function(gridId) {
		var gridInfo 	= this.getGrid(gridId);
		var mygrid 		= gridInfo.grid;
		
		// 전체 Row Setting
	    var result = [];
		var rowIds = mygrid.getAllRowIds();
		if(rowIds == "") return result;
		var rowIdList 	= rowIds.split(",");
		var colList		= gridInfo.viewOrderList.split(",");
		for (var rowIndex=0; rowIndex<rowIdList.length; rowIndex++) {
			var item = {};
			var rowId = rowIdList[rowIndex];
			$.each(colList, function() {
				var colId = this + "";
				var oname = colId.removeRangeChar("[!", "]");
				var colIdx = mygrid.getColIndexById(colId);
	        	var val = mygrid.cells(rowId,colIdx).getValue();
	        	item[oname] = val;
			});
	        result.push(item);
	    }
		return result;
	}, 
	// 변경된 Row Data만 가져온다. 
	getGridToJsonOnlyChange : function(gridId) {
		var mygrid = this._GRID[gridId].grid;
		var chageRowIds	= mygrid.getChangedRows();
		var targetRowIdArray = chageRowIds.split(",");
		var dataList = [];
		$.each(targetRowIdArray, function() {
			var rowData = explanGrid.getRowData(gridId, this);
			if(isValid(rowData)) dataList.push(rowData);
		});
		return dataList;
	},
	// 변경된 RowId를 가져온다. 
	getChangedRowId : function(gridId) {
		var gridInfo 	= this.getGrid(gridId);
		var mygrid = gridInfo.grid;
		if(gridInfo.isNoData) return;
		var result = mygrid.getChangedRows();
		if(result == "") return [];
		else return result.split(",");
	},
	getTreeGridToJson : function(gridId) {
		if(!isValid(this._GRID[gridId])) return null;
		var mygrid 		= this._GRID[gridId].grid;
		var config		= this._GRID[gridId].gridParm.config;
		if(config.colType.indexOf("tree") < 0) alert ('tree 구조가 아닙니다.');
		else {
			// tree 전체 Data를 가져온다.
			var rowIds = mygrid.getAllRowIds();
			var rowIdList = rowIds.split(",");
			// 결과 List
			var result = [];
			$.each(rowIdList, function() {
				var level = mygrid.getLevel(this);
				if(level > 0) return true;
				result = explanGrid.getTreeGridSubData(gridId, this, result);
			});
			return result;
		}
	},
	// 특정 RowId에 대한 SubItem에 대한 Data를 가져온다.
	getTreeGridSubData : function(gridId, rowId, result) {
		
		if(rowId == undefined) return result;

		var mygrid 		= this._GRID[gridId].grid;
		
		if(result == undefined) result = [];
		var idx = result.length;
		result[idx] 		= explanGrid.getGridToJsonByRowId(gridId, rowId);
		result[idx]["_PID"] = mygrid.getParentId(rowId);
		
		var subItemIds = mygrid.getSubItems(rowId);
		if(subItemIds == "") return result;
		else {
			var subItemList = subItemIds.split(",");
			$.each(subItemList, function() {
				result = explanGrid.getTreeGridSubData(gridId, this, result);
			});
			return result;
		}
	},
	// subItem에 대해 Parent row data를 가져온다.
	getTreeGridParentData : function(gridId, rowId) {
		var mygrid 	= this._GRID[gridId].grid;
		var pid		= mygrid.getParentId(rowId);
		if(isValid(pid,1)) 	return this.getRowData(gridId, pid);
		else				return {};
	},
	// Mysql에서는 Number Type의 항목에 빈값이면 NULL로 변환 해주어야 한다.
	// DB에서는 ${COLUMN}으로 사용해야함.
	generateJsonToDbType : function(gridId, jsonData) {
		var gridInfo 		= this.getGrid(gridId);
		var columnConfig	= gridInfo.gridParm.cellConfig.columnConfig;
		$.each(columnConfig, function(key, obj) {
			if(!isValid(obj)) return true;
			var colType = obj["colType"];
			if(in_array(colType, ["edncl","ednfl","mnum","termed"])) {
				$.each(jsonData, function(idx) {
					if(!isValid(jsonData[idx][key])) jsonData[idx][key] = 'NULL';
				});
			}
		});
		return jsonData;
	},
	/**
	 * Grid의 Row Id에 해당하는 원본 Row Data를 리턴한다.
	 */
	getOrgDataByRowId : function(gridId, rowId) {
		var gridInfo 	= this.getGrid(gridId);
		if(!gridInfo.gridParm.dataConfig.useRownum) {
			//alert("Grid 설정시 'dataConfig.useRownum'을 true로 세팅해주세요.")
			return;
		}
		var rowData = explanGrid.getGridToJsonByRowId(gridId, rowId, ["_ROWNUM"]);
		
		return gridInfo.gridData[rowData._ROWNUM];
	},
	// grid Data가 없는 경우
	setNotFound:function(gridId, msg){
		var mygrid 		= this._GRID[gridId].grid;
		var gridParm 	= this._GRID[gridId].gridParm;
		
		if(gridParm != undefined) {
			var ctype = gridParm.config.colType.split(",")[0];
			if(ctype=="ch") {
				var newColType = gridParm.config.colType.replace("ch", "ro");
				mygrid.setColTypes(newColType);
			}
			else if(ctype=="cntr") {
				var newColType = gridParm.config.colType.replace("cntr", "ro");
				mygrid.setColTypes(newColType);
			}
		}
		var resultMsg="";
		var newRowId = getUniqueId();
		var colNum=mygrid.getColumnsNum();
		mygrid.addRow(newRowId,""); 	
		mygrid.enableCollSpan(true);
		mygrid.setColspan(newRowId,0,colNum);
		
		if (msg !== undefined){
			resultMsg=msg;
		}else{
			resultMsg="No Data Found";
		}
		mygrid.cells(newRowId, 0).setValue(resultMsg);
		
		var align = "center";
		if(gridParm.noDataAlign != undefined) align = gridParm.noDataAlign;
		mygrid.setCellTextStyle(newRowId,0,"text-align:" + align);
		
		this._GRID[gridId].isNoData = true;
	},
	// Grid를 Split 할 경우
	splitAt : function(mygrid, colUmnName , inc){
		if(colUmnName == undefined) return;
		
		var colidx = mygrid.getColIndexById(colUmnName)
		if(inc != undefined) {
			colidx = colidx + inc;
		}
		mygrid.splitAt(colidx);
	},
	// 높이 자동설정
	setGridHeight : function (mygrid) { 
        h = $(window).height();
        h -= Math.round($('.grid_wrap').position().top);
        h -= 50;
        $('.grid_wrap').height(h);
        
        mygrid.setSizes();
       
	},   
	// return : rowId
	addRow : function(gridId, rowIdx) {
		var gridInfo = this.getGrid(gridId);
		var mygrid = gridInfo.grid;
		
		var config = gridInfo.gridParm.config;
		if(mygrid.getRowsNum()>0) {
			if(gridInfo.isNoData) {
				this.deleteRow(gridId, 0);
				mygrid.setColTypes(gridInfo.gridParm.config.colType);
				gridInfo.isNoData = false;
			}
		}
		// CheckBox 처리
		var colTypeList	= config.colType.split(",");
		var colTypeStr	= "";	
		$.each(colTypeList, function(idx) {
			var tkn = "";
			if(this == "ch") 	tkn = "0";
			if(idx == 0) 		colTypeStr = tkn;
			else				colTypeStr += "," + tkn;
		});
		var newRowId = getUniqueId();
		if(rowIdx == undefined) {
			mygrid.addRow(newRowId,colTypeStr);
		} else {
			mygrid.addRow(newRowId,colTypeStr,rowIdx);
		}
		mygrid.setSelectedRow(newRowId);
		
		// 초기값 설정
		try {
			var columnConfig = gridInfo.gridParm.cellConfig.columnConfig;
			$.each(columnConfig, function(key, obj) {
				if(obj.colType == "combo") {
					var subId = "";
					if(isValid(obj.subId)) subId = obj.subId;
					var firstValue = "";
					$.each(_DD_MAP[key + subId], function(k,v) { firstValue = k; return false; });
					explanGrid.setValueById(gridId, newRowId, key, firstValue);
				}
			});
		} catch(e) {}
		return newRowId;
	},
	addRowPlus : function(gridId, cnt) {
		
		if(!isNumber(cnt)) return;
		if(cnt < 1) return;
		
		var gridInfo = this.getGrid(gridId);
		var mygrid = gridInfo.grid;
		
		var config = gridInfo.gridParm.config;
		if(mygrid.getRowsNum()>0) {
			if(gridInfo.isNoData) {
				this.deleteRow(gridId, 0);
				mygrid.setColTypes(gridInfo.gridParm.config.colType);
				gridInfo.isNoData = false;
			}
		}
		// CheckBox 처리
		var colTypeList	= config.colType.split(",");
		var colTypeStr	= "";	
		$.each(colTypeList, function(idx) {
			var tkn = "";
			if(this == "ch") 	tkn = "0";
			if(idx == 0) 		colTypeStr = tkn;
			else				colTypeStr += "," + tkn;
		});
		var newRowIdList = [];
		var lastRowId = "";
		for(i=0;i< cnt ; i++) {
			var newRowId = getUniqueId();
			mygrid.addRow(newRowId,colTypeStr);
			newRowIdList.push(newRowId);
			lastRowId = newRowId;
		}
		mygrid.setSelectedRow(lastRowId);
		return newRowIdList;
	},
	preInsertRow 	: function(gridId, rowId) {
		var gridInfo = this.getGrid(gridId);
		var mygrid = gridInfo.grid;
		var rowIdx = mygrid.getRowIndex(rowId);
		return this.addRow(gridId, rowIdx);
	},
	afterInsertRow	: function(gridId, rowId) {
		var gridInfo = this.getGrid(gridId);
		var mygrid = gridInfo.grid;
		var rowIdx = mygrid.getRowIndex(rowId);
		return this.addRow(gridId, (rowIdx + 1));
	},
	treeGridAddRow 	: function(parm) {
		
		var gridId 		= parm.gridId;
		var newRowId 	= parm.newRowId;
		var parentRowId	= parm.parentRowId;
		var rowIdx 		= parm.rowIdx;
		var isChild 	= parm.isChild;
		
		var gridInfo = this.getGrid(gridId);
		var mygrid = gridInfo.grid;
		
		var config = gridInfo.gridParm.config;
		
		if(mygrid.getRowsNum()>0) {
			if(gridInfo.isNoData) {
				this.deleteRow(gridId, 0);
				mygrid.setColTypes(gridInfo.gridParm.config.colType);
				gridInfo.isNoData = false;
			}
		}
		
		// CheckBox 처리
		var colTypeList	= config.colType.split(",");
		var colTypeStr	= "";	
		$.each(colTypeList, function(idx) {
			var tkn = "";
			if(this == "ch") 	tkn 		 = 		 "0";
			if(idx == 0) 		colTypeStr 	 = 		 tkn;
			else				colTypeStr 	+= "," + tkn;
		});
		
		if(newRowId == undefined) newRowId = getUniqueId();
		
		if ( isChild == "0"){
			mygrid.addRow(newRowId,colTypeStr,rowIdx);
		}
		else 
		{
			if(parentRowId == undefined) parentRowId=mygrid.getSelectedRowId();
			
			mygrid.addRow(newRowId,colTypeStr,rowIdx,parentRowId);
		}
		
		
		if ( isChild == "0")
		{
			mygrid.setSelectedRow(newRowId);
		}
		mygrid.expandAll();
		return newRowId;
	},
	// Delete Row
	// Row Number로 삭제함.
	deleteRow : function(gridId, rowIdx) {
		var gridInfo = this.getGrid(gridId);
		var mygrid = gridInfo.grid
		var rowId = mygrid.getRowId(rowIdx);
		if(rowId == undefined) return;
		this.deleteRowById(gridId, rowId)
	},
	// Row Id 로 삭제함.
	deleteRowById : function(gridId, rowId) {
		var gridInfo = this.getGrid(gridId);
		var mygrid = gridInfo.grid
		
		// 최초 로딩된 List에서 삭제된 Data라면 삭제 리스트에 저장
		loadRowIdMap = gridInfo.loadRowIdMap;
		if(isValid(loadRowIdMap[rowId],1)) mygrid.deletedListMap[rowId] = this.getRowData(gridId, rowId);
		
		mygrid.deleteChangedRow(rowId);
		
		// Grid에서 삭제
		mygrid.deleteRow(rowId);

		// Row Num이 있다면 Refresh
		colIdx = mygrid.getColIndexById("[!RN]");
		if(colIdx == undefined) colIdx = mygrid.getColIndexById("[!RN]No");
		if(colIdx == undefined) colIdx = mygrid.getColIndexById("[!RN]No.");
		if(colIdx == undefined) colIdx = mygrid.getColIndexById("[!RN]Num");
		if(colIdx == undefined) return;
		mygrid.resetCounter(colIdx);
	},
	getRowId : function(gridId, rowIdx) {
		var gridInfo = this.getGrid(gridId);
		var mygrid = gridInfo.grid
		var rid = mygrid.getRowId(rowIdx);
		return rid;
	},
	getColId : function(gridId, colIdx) {
		var gridInfo = this.getGrid(gridId);
		var mygrid = gridInfo.grid
		var colId = mygrid.getColumnId(colIdx);
		return colId;
	},
	getColType : function(gridId, colId) {
		var gridInfo = this.getGrid(gridId);
		var mygrid = gridInfo.grid
		var colIdx = mygrid.getColIndexById(colId);
		var colType = mygrid.getColType(colIdx);
		return colType;
	},
	/**
	 * Grid의 특정 위치에 값을 세팅
	 * parameter 
	 * gridId : 대상 Grid Id
	 * rowIdx : Row 위치 Idx
	 * col	  : col은 위치 또는 idx ( 자동으로 실행됨 )
	 */
	setValue : function(gridId, rowIdx, col, val) {
		var gridInfo = this.getGrid(gridId);
		var mygrid = gridInfo.grid;
		var rowId = mygrid.getRowId(rowIdx);
		return this.setValueById(gridId, rowId, col, val);
	},
	/**
	 * Grid의 특정 위치에 값을 세팅
	 * parameter 
	 * gridId : 대상 Grid Id
	 * rowIdx : Row Id
	 * col	  : col은 위치 또는 idx ( 자동으로 실행됨 )
	 */
	setValueById : function(gridId, rowId, col, val) {
		if(!isValid(gridId)	) return null;
		if(!isValid(rowId)	) return null;
		if(!isValid(col)	) return null;
		var gridInfo = this.getGrid(gridId);
		var mygrid = gridInfo.grid;
		var colIdx;
		if(!isNumber(col)) {
			colIdx = mygrid.getColIndexById(col);
			if(colIdx == undefined) colIdx = mygrid.getColIndexById("[!HD]" + col); 
			if(colIdx == undefined) return;
			col = colIdx;
		}
/*		try {
			mygrid.cells(rowId, col).setValue(val);
		} catch(e) {
			alert(e.message)
		}
*/
		mygrid.cells(rowId, col).setValue(val);
	},
	setRow : function(gridId, rowId, rowData, exceptColList) {
		var gridInfo = this.getGrid(gridId);
		var mygrid = gridInfo.grid;
		var orderArray = gridInfo.orderList.split(",");
		$.each(orderArray, function() {
			var rname 	= this;
			var val;
			if(rowData[rname] != undefined) val = rowData[rname];
			else {
				var oname 	= this.removeRangeChar("[!", "]");
				if(exceptColList != undefined && in_array(oname, exceptColList)) return true;
				val			= rowData[oname];
			}
			if(val == undefined) return true;
			var colIdx = mygrid.getColIndexById(rname);
			if(colIdx == undefined) return true;
			explanGrid.setValueById(gridId, rowId, colIdx, val);
		});
	},
	// 지정된 컬럼을 모두 세팅한다.
	setAllColumn : function(gridId, colId, val) {
		var gridInfo = this.getGrid(gridId);
		var mygrid = gridInfo.grid;
		var rowIds = mygrid.getAllRowIds();
		var rowIdList = rowIds.split(",");
		$.each(rowIdList, function() {
			var rowId = this;
			explanGrid.setValueById(gridId, rowId, colId, val);
		});		
	},
	// Check Box 가 있는경우 Check 된 모든 RowId 리턴
	getCheckedRowId : function(gridId, col) {
		if(col == undefined) col = "[!CB]";
		var gridInfo = this.getGrid(gridId);
		var mygrid = gridInfo.grid;
		
		if(this.isEmpty(gridId)) return [];

		if(!isNumber(col)) {
			col = mygrid.getColIndexById(col);
			if(col == undefined) return [];
		}
		var rowIdList = [];
		for (var rowIndex=0; rowIndex<mygrid.getRowsNum(); rowIndex++) {
			var ch = mygrid.cells2(rowIndex, col).getValue();
			if(ch == 1) {
				rowIdList[rowIdList.length] = mygrid.getRowId(rowIndex);
			}
	    }
		return rowIdList;
	},
	getCheckedRowData : function(gridId, col) {
		if(col == undefined) col = "[!CB]";
		var rowIdList = this.getCheckedRowId(gridId, col);
		var rowDataList = [];
		$.each(rowIdList, function() {
			rowDataList.push(explanGrid.getRowData(gridId, this));
		});
		return rowDataList;
	},
	// 현재 선택된 Row의 Id 및 Row Data를 리턴
	getSelectRow : function(gridId) {
		var gridInfo = this.getGrid(gridId);
		var mygrid = gridInfo.grid;
		var rowId = mygrid.getSelectedRowId();
		var rowData = this.getGridToJsonByRowId(gridId, rowId);
		if(!isValid(rowData)) return undefined;
		rowData["rowId"] = rowId;
		return rowData;
	},
	// 전체 Grid의 Valid를 Check한다.
	validCheckAllGrid : function(gridId, type) {
		var gridInfo = this.getGrid(gridId);
		if(gridInfo == undefined) return false;
		var mygrid = gridInfo.grid;
		var returnMap;
		for (var rowIndex=0; rowIndex<mygrid.getRowsNum(); rowIndex++) {
        	var rowId = mygrid.getRowId(rowIndex);
        	var result = this.validCheckAllRow(gridId, rowId, type);
        	if(!result.valid && returnMap == undefined) returnMap = result;
	    }
		if(returnMap == undefined) returnMap = {valid : true};
		return returnMap;
	},
	// 전체 Grid의 Valid를 Check한다.
	validCheckAllRow : function(gridId, rowId, type) {
		var gridInfo = this.getGrid(gridId);
		var mygrid = gridInfo.grid;

		var returnMap = fn_copyObject(_VALID_RESULT_TEMPLATE); 
		
		var validList = {};
		if(type == "all") {
			$.each(gridInfo.orderList.split(","), function() {
				var item = this;
				item = item.removeRangeChar("[!", "]");
				if(item == "") return true;
				validList[item] = "Y";
			});
		}
		else validList = mygrid.changedCellList[rowId];
		
		if(validList == undefined) return {valid : true};
		
		var returnValue = true;
		$.each(validList, function(key, value) {
			var colId = key;
    		if ( explanGrid.validCheckRowColumn(gridId, rowId , colId) == false) {
        		returnMap.valid = false;
        		if(returnMap.position.length == 0) {
            		var pos = [];
            		var rowIndex = mygrid.getRowIndex(rowId);
            		pos.push(rowIndex);
            		pos.push(colId);
        			returnMap.position 		= pos;
        			
        			returnMap.msg = mygrid.getValidErrMsg(rowId, colId);
        			
        			return false;
        		}
    		}
		});
		return returnMap;
	},
	// 특정 Column의 Valid를 Check한다.
	validCheckAllColumn : function(gridId, colIdList) {
		var gridInfo = this.getGrid(gridId);
		var mygrid = gridInfo.grid;
		
		var returnMap = fn_copyObject(_VALID_RESULT_TEMPLATE); 
			
		$.each(colIdList, function() {
			var colId = this;
			for (var rowIndex=0; rowIndex<mygrid.getRowsNum(); rowIndex++) {
	        	var rowId = mygrid.getRowId(rowIndex);
	        	if ( explanGrid.validCheckRowColumn(gridId, rowId , colId) == false) {
	        		returnMap.valid = false;
	        	}
		    }
		});
		return returnMap;
	},
	validCheckRowColumn : function(gridId, rowId, colId) {
		
		if(explanGrid._PAUSE_VALID != undefined) return true;
		
		var gridInfo = this.getGrid(gridId);
		var mygrid = gridInfo.grid;
		
		var colIdx = mygrid.getColIndexById(colId);
		
		if(colIdx == undefined ) return true;
		
		var cellType 	= mygrid.getCellType(rowId,colId);
		
		if(cellType == "static") return true;
		
		var returnValue = true;

		if( mygrid.isColumnHidden(colIdx)) return true;
		
		if( mygrid.validateCell(rowId , colIdx) == false) returnValue = false;

   		return returnValue;
	},
	setRowspan 	: function(gridId, colId, startIdx, length) {
		var gridInfo 	= this.getGrid(gridId);
		var mygrid 		= gridInfo.grid;
		var rowId		= mygrid.getRowId(startIdx);
		var colIdx		= mygrid.getColIndexById(colId);
		
		mygrid.setRowspan(rowId, colIdx, length);
	},
	setFocus	: function(gridId, rowIdx) {
		var gridInfo = this.getGrid(gridId);
		var mygrid = gridInfo.grid;
		var rowId = mygrid.getRowId(rowIdx);
		mygrid.setSelectedRow(rowId);
	},
	setFocusById: function(gridId, rowId) {
		var gridInfo = this.getGrid(gridId);
		var mygrid = gridInfo.grid;
		mygrid.setSelectedRow(rowId);
	},
	// Cell 단위로 Coltype을 설정한다.
	setCellType : function(gridId, rowId, colId, type) {
		var gridInfo = this.getGrid(gridId);
		var mygrid = gridInfo.grid;
		var colIdx = mygrid.getColIndexById(colId);
		if(colIdx == undefined) return;
		mygrid.setCellExcellType(rowId,colIdx,type);
		mygrid.addCellType(rowId,colId,type);
		if(explanGrid._PAUSE_VALID != undefined) return true;
		if(!in_array(type, ["ro", "tree"])) mygrid.validateCell(rowId , colIdx);
	},
	// Row 단위로 Coltype을 설정한다.
	setRowType : function(gridId, rowId, type) {
		var gridInfo = this.getGrid(gridId);
		var mygrid 	= gridInfo.grid;
		var colList = gridInfo.viewOrderList.split(",");
		$.each(colList, function() {
			if(in_array(this, ["[!CB]", "[!RN]"])) return true;
			explanGrid.setCellType(gridId, rowId, this, type);
		});
	},	
	// Column 단위로 Coltype을 설정한다.
	setColType : function(gridId, colId, type) {
		var gridInfo = this.getGrid(gridId);
		var mygrid 	= gridInfo.grid;
		var rowIds = mygrid.getAllRowIds();
		$.each(rowIds.split(","), function() {
			explanGrid.setCellType(gridId, this, colId, type);
		});
	},
	// Celltype을 가져오기
	getCellType : function(gridId, rowId, colId) {
		var gridInfo 	= this.getGrid(gridId);
		var mygrid 		= gridInfo.grid;
		return mygrid.getCellType(rowId, colId);
	},
	// (tree)grid API를 직접 실행
	exec	: function(gridId, methodName, p1, p2, p3, p4) {
		var gridInfo = this.getGrid(gridId);
		var mygrid = gridInfo.grid;
		return mygrid[methodName](p1, p2, p3, p4);
	},
	itemGeneration	: function (itemTypeList, ddListMap, workTcd) {
		
		var columnConfig = {};
		
 		// 항목 중 Number 형에 대하여 Setting 및 Validation 항목 설정
 		var validatorList = {};
 		// Commbo Type Item List 초기화
 		var comboItemList = [];
 		
 		if( ddListMap != undefined) {
 	 		var cListMap = {};
 	 		$.each(ddListMap, function(key, list) {
 	 			var cList = [];
 	 			$.each(list, function(idx) {
 	 				cList.push(list[idx].DD_CODE);
 	 			});
 	 			cListMap[key] = cList;
 	 		});
 	 		ddListMap = cListMap;
 		} else ddListMap = []
 		$.each(itemTypeList, function() {
 			var itemType = this;
 			// 수정인 경우 수정 불가 항목 Static 처리
 			if(workTcd != "NEW") {
 				if(itemType.MODIFY_YN == "N") itemType.CONTROL_TYPE = "STATIC";
 			}
 			
 			columnConfig[itemType.ITEM_CODE] = {};

 			// DATA TYPE이 NUMBER인경우 기본 설정
			if		(in_array(itemType.DATA_TYPE,["NUMBER","INTEGER"])		) 	columnConfig[itemType.ITEM_CODE] = {"align" : "right"};
 			// DATA TYPE이 DATE인경우 기본 설정
			else if(itemType.DATA_TYPE == "DATE"					 		) 	columnConfig[itemType.ITEM_CODE] = {"align" : "center"};

				// CONTROL_TYPE 이 EDIT 인경우
 			if(itemType.CONTROL_TYPE == "EDIT") {
	 			// DATA TYPE이 NUMBER인경우 기본 설정
 				if		(in_array(itemType.DATA_TYPE,["NUMBER","INTEGER"])	) 	columnConfig[itemType.ITEM_CODE].colType = "edncl";
	 			// DATA TYPE이 DATE인경우 기본 설정
 				else if(itemType.DATA_TYPE == "DATE"						) 	columnConfig[itemType.ITEM_CODE].colType = "dhxCalendar";
	 			// DATA TYPE이 VARCHAR2인경우 기본 설정
 				else															columnConfig[itemType.ITEM_CODE].colType = "edtxt";
 			}
	 		// CONTROL_TYPE이 STATIC 인경우는 자동입력이기때문에 colType은 'static'		 			
 			else if(itemType.CONTROL_TYPE 	== "STATIC") {
 				columnConfig[itemType.ITEM_CODE].colType = "static";		
 			}
	 		// CONTROL_TYPE이 COMBO 인경우는 사용자 정의 Commbo Type을 사용한다.	
 			else if(itemType.CONTROL_TYPE 	== "COMBO") {
 				if(columnConfig[itemType.ITEM_CODE] == undefined) columnConfig[itemType.ITEM_CODE] = {};
 				columnConfig[itemType.ITEM_CODE].colType = "combo";
 				// Combo Type Item 리스트에 등록한다.(뒤에 Option setting에서 이용)
 				comboItemList.push(itemType.ITEM_CODE);
 			}
	 		// CONTROL_TYPE이 SEARCH 인경우는 검색 Popup 기능을 넣는다.	
 			else if(itemType.CONTROL_TYPE 	== "SEARCH") {
 				// Seach 단일 항목인경우
 				//var colType = "searchSingle";
 				
 				// 일반 Search
 				var colType = "search";
 				if(itemType.MULTI_INPUT_YN == "Y") colType = "multiSearch";
	 			columnConfig[itemType.ITEM_CODE].colType = colType;
 			}
 			
 			// number format 처리
 			if(in_array(itemType.DATA_TYPE,["NUMBER","INTEGER"]) && isNumber(itemType.DECIMAL_PLACES)) {
 				var fix = eval(itemType.DECIMAL_PLACES);
 				if(fix > 0) {
 					columnConfig[itemType.ITEM_CODE].fix = fix;
 				}
 			}

 			/**
 			 *	유효성 관련 처리
 			 */
			// COMBO 관련 유효성 Check
 			if(in_array(itemType.CONTROL_TYPE, ["COMBO", "SEARCH"])) {
 		   		validatorList[itemType.ITEM_CODE] = function(cellData){
 		   			var dataList = [cellData];
 		   			if(itemType.MULTI_INPUT_YN == "Y") dataList = cellData.replaceAll("+", ",").split(",");
		   			var retVal = true;
		   			$.each(dataList, function() {
		   				var item = this;
		   				if(!in_array(item, ddListMap[itemType.ITEM_CODE] ) ) retVal = false;
		   			});
		   			return retVal;
 		  		};
 			}
 			else if(itemType.DATA_TYPE == "NUMBER") {
 				validatorList[itemType.ITEM_CODE] = function(cellData){
 					if(isNumber(cellData)) 	return true;
 					else 					return false;
 		  		};
 			}
 			else if(itemType.CONTROL_TYPE != "STATIC") {
 		   		validatorList[itemType.ITEM_CODE] = function(cellData){
 		   			var len = getByte(cellData + "");
 		   			if	 	(len == 0 || len > itemType.DATA_LENGTH) 	return false;  	// invalid
 		   			else												return true;		// valid
 		  		};
 			}
 		});
 		var returnParm = {
			columnConfig : columnConfig,	
			validatorList : validatorList,	
			comboItemList : comboItemList	
 		}
 		return returnParm;
	},
	// ITEM 설정 읽기 전용 인경우
	itemGenerationReadOnly	: function(itemTypeList) {
		var columnConfig = {};
		$.each(itemTypeList, function() {
 			var itemType = this;
 			columnConfig[itemType.ITEM_CODE] = {};
 			// DATA TYPE이 NUMBER인경우 기본 설정
			if		(in_array(itemType.DATA_TYPE,["NUMBER","INTEGER"])) 	{
				columnConfig[itemType.ITEM_CODE] = {"align" : "right", "colType" : "ednro"};
	 			// number format 처리
	 			if(isNumber(itemType.DECIMAL_PLACES)) {
	 				var fix = eval(itemType.DECIMAL_PLACES);
	 				if(fix > 0) {
	 					columnConfig[itemType.ITEM_CODE].fix = fix;
	 				}
	 			}
			} else {
				columnConfig[itemType.ITEM_CODE] = {"colType" : "ro"};
			}
 		});
 		return columnConfig;
	},
	// Evnet 처리
	attachEvent : function(gridId, eventName, func) {
		// 일지 중지 Event는 스킵한다.
		if(this._FN_EVENT[gridId] == undefined) this._FN_EVENT[gridId] = {};
		eventName = eventName.toUpperCase();
		this._FN_EVENT[gridId][eventName] = func;
		if(eventName == "ONCHANGE") {
			var gridInfo 	= this.getGrid(gridId);
			var mygrid		= gridInfo.grid;
			if(typeof func == "function") mygrid.userFunction.changeFn[gridId] = func;
		} else if(eventName == "ONAFTERPOPUP") {
			var gridInfo 	= this.getGrid(gridId);
			gridInfo.grid.userFunction.afterPopup[gridId] = func;
		} else if(eventName == "ONVALIDATIONERROR") {
			var gridInfo 	= this.getGrid(gridId);
			gridInfo.grid.userFunction.onValidationError = func;
		} else if(eventName == "ONVALIDATIONCORRECT") {
			var gridInfo 	= this.getGrid(gridId);
			gridInfo.grid.userFunction.onValidationCorrect = func;
		} else if(eventName == "ONCLICK") {
			var gridInfo 	= this.getGrid(gridId);
			gridInfo.grid.userFunction.onClick = func;
		} else if(eventName == "ONSTARTPASTE") {
			var gridInfo 	= this.getGrid(gridId);
			gridInfo.grid.userFunction.onStartPaste = func;
		} else if(eventName == "ONENDPASTE") {
			var gridInfo 	= this.getGrid(gridId);
			gridInfo.grid.userFunction.onEndPaste = func;
		}
	},
	pauseEvent : function(gridId, eventName) {
		eventName = eventName.toUpperCase();
		if(this._PAUSE_EVENT[gridId] == undefined) this._PAUSE_EVENT[gridId] = {};
		this._PAUSE_EVENT[gridId][eventName] = "Y";
		var ecntkey = eventName+ "_cnt";
		if(this._PAUSE_EVENT[gridId][ecntkey] == undefined) 	this._PAUSE_EVENT[gridId][ecntkey] = 1;
		else													this._PAUSE_EVENT[gridId][ecntkey]++
	},
	releaseEvent : function(gridId, eventName) {
		eventName = eventName.toUpperCase();
		if(this._PAUSE_EVENT[gridId] == undefined) return;
		var ecntkey = eventName+ "_cnt";
		if(this._PAUSE_EVENT[gridId][ecntkey] == 1 ) {
			this._PAUSE_EVENT[gridId][eventName] = undefined;
			this._PAUSE_EVENT[gridId][ecntkey] = undefined
		} else {
			this._PAUSE_EVENT[gridId][ecntkey]--;
		}
	},
	pauseValid : function() {
		if(this._PAUSE_VALID == undefined) this._PAUSE_VALID = 0;
		this._PAUSE_VALID++;
	},
	releaseValid : function(gridId, eventName) {
		if(this._PAUSE_VALID == 1) this._PAUSE_VALID = undefined;
		else						this._PAUSE_VALID--;
	},
	//그리드 중복 체크
	/*
	 * 파라미터 
	 *   gridId : 그리드 div id
	 *   colName : 비교 대상 컬럼
	 *   nValue : 비교대상 값
	 *   noninclueRow : 제외 되는 행
	 *   displayCol : 사용자에게 보여줄 행
	 */
	checkCodeValue : function ( gridId , colName , nValue , noninclueRow ){
		
		var strRowId = "";
		
		var mygrid = this._GRID[gridId].grid;

		var rowIds = mygrid.getAllRowIds();
		
		var rowIdList = rowIds.split(",");
		var cellIndex = mygrid.getColIndexById(colName);
		
		var chk_count = 0;
		
		for (var rowIndex=0; rowIndex<rowIdList.length; rowIndex++) {
			var item = {};
			var rowId = rowIdList[rowIndex];
	        var val = mygrid.cells(rowId,cellIndex).getValue() + "";
	        
	        var Message = nValue + " 코드는 Templete에서 존재 합니다.\n\r 기존코드를 사용하여 주세요.";
	        
	        if ( val == nValue)
		    {
	        	if ( noninclueRow != undefined ){    // 특정행 제외 아닌 경우
	        		chk_count = chk_count + 1;
	        		//dhtmlx.message(Message);
	        		alert(Message);
	        		strRowId = strRowId + ",";
	        		
	        	}
	        	else if ( rowIndex != noninclueRow ){  // 특정행 제외
	        		chk_count = chk_count + 1;
	        		//dhtmlx.message(Message);
	        		alert(Message);
	        		strRowId = strRowId + ",";
	        	}
		    }
	    }
		
		return strRowId;

	},
	// grid row 개수
	getGridRowCount : function(gridId) {
		var gridInfo = this.getGrid(gridId);
		var mygrid = gridInfo.grid;
		var rowIds = mygrid.getAllRowIds();
		var count = 0;
		if(rowIds != "") count = rowIds.split(",").length;
		return count;
	},
	onSetSizes	: function(gridId) {
		var gridInfo = this.getGrid(gridId);
		var mygrid = gridInfo.grid;
		mygrid.setSizes();

//		mygrid.setSizesSuper();
//		var gridId = mygrid.getGridId();
//		if		(mygrid.height == undefined	) _SVC_DHTMLX.gridResize(gridId);
//		else if	(mygrid.height == "none"		) return;
//		else if(mygrid.height 	!= undefined	) $("#" + gridId).css("height" ,mygrid.height);
	},
	refreshAllGrid : function() {
		var fn = function() {
			$.each(explanGrid._GRID, function(gridId, gridInfo) {
				var mygrid = gridInfo.grid;
				var splitName = gridInfo.gridParm.splitName;
				if(splitName == undefined) {
					$("#" + gridId).css("width", "100%");
					mygrid.setSizes();
				}
				else {
					$("#" + gridId + " .xhdr").css("width", "100%");
					$("#" + gridId + " .objbox").css("width", "100%");
					mygrid.setSizes();
				}
			});
		};
		setTimeout(fn, 500);
		setTimeout(fn, 1000);
	},
	// Grid변경 여부
	isChanged : function(gridId) {
		var gridInfo = this.getGrid(gridId);
		var mygrid = gridInfo.grid;
		return mygrid.isChanged;
	},
	setChanged : function(gridId) {
		var gridInfo = this.getGrid(gridId);
		var mygrid = gridInfo.grid;
		mygrid.isChanged = true;
	},
	// 그리드 변경여부 Check 초기화
	clearChanged : function(gridId) {
		var gridInfo = this.getGrid(gridId);
		if(gridInfo == undefined) return;
		var mygrid = gridInfo.grid;
		mygrid.clearChangedCell();
	},
	// Exceldownload
	excelDownload : function(parm) {
		var gridId 		= parm.gridId;
		var headerList	= parm.headerList;
		var fileName	= parm.fileName;
		
		var gridInfo = this.getGrid(gridId);
		var dataList = this.getGridViewData(gridId);
		if(headerList 	== undefined) headerList 	= gridInfo.viewOrderList;
		if(fileName 	== undefined) fileName 	= 'excelDownload';
		var headerListArray 	= headerList.split(",");
		var headerTitleList = "";
		excelDownloadForJson(dataList, headerListArray, fileName);
	},
	makeExcelInfo : function(gridId) {
		var gridInfo 		= this.getGrid(gridId);
		var dataList 		= this.getGridViewData(gridId);
		var viewOrderArray 	= gridInfo.viewOrderList.split(",");
		var viewOrderList	= "";
		$.each(viewOrderArray, function() {
			var iname 	= this;
			var iname 	= iname.removeRangeChar("[!", "]");
			if(iname.substring(0,1) == "#") return true;
			if(!isValid(iname,1)) return true;
			if(viewOrderList == "")	viewOrderList  = 	 iname;
			else					viewOrderList += ","+iname;
		});
		return {dataList : dataList, viewOrderList : viewOrderList}
	},
	selectedRowCopy : function(gridId, type) {
		var gridInfo = this.getGrid(gridId);
		var mygrid = gridInfo.grid;
		var rowDataList = [];
		// Data가 없으면...
		if(gridInfo.isNoData) return;

		var rowIdList = this.getCheckedRowId(gridId, "[!CB]");
		if(type == "key" || rowIdList == undefined) rowIdList = [];
		if(rowIdList.length == 0) {
			if(type != "key") {
				alert('체크 박스를 1개 선택해 주세요.');
				return;
			}
			var rowId 	= mygrid.getSelectedRowId();
			var colIdx	= mygrid.getSelectedCellIndex();
			var val		= mygrid.cells(rowId,colIdx).getValue(); 
			window.clipboardData.setData('text', val + "");
			return "noselect";
		} else if(rowIdList.length > 1) { 
			alert('체크 박스를 1개 선택해 주세요.');
			return;
		}
		var viewOrderList = gridInfo.viewOrderList;
		if(viewOrderList == undefined) {
			alert('복사 할 수 없습니다.');
			return;
		}
		var clipText = "";
		$.each(rowIdList, function() {
			var rowData = explanGrid.getRowData(gridId, this);
			var clipRowText = ""
			var startCheck = false;
			$.each(viewOrderList.split(","), function() {
				var item = this;
				var oname 	= item.removeRangeChar("[!", "]");
				if(!isValid(oname,1)) return true;
				var data = rowData[oname];
				if(data == undefined && !startCheck) data = "\t";
				if(!startCheck) clipRowText = 			data;
				else			clipRowText += "\t" + 	data;
				startCheck = true;
			});
			if(clipText == "") 	clipText  = 			clipRowText;
			else				clipText += "\r\n" +	clipRowText;
		});
		window.clipboardData.setData('text', clipText);
		alert('선택된 행이 클립 보드에 복사 되었습니다.');
	},
	deleteSelectedCellData	: function(gridId) {
		var gridInfo = this.getGrid(gridId);
		var mygrid = gridInfo.grid;
		var rowId 	= mygrid.getSelectedRowId();
		var colIdx	= mygrid.getSelectedCellIndex();
		
		var colType = mygrid.getColType(colIdx);
		if(in_array(colType, ["ro", "static", "combo", "search2"]) || mygrid.cells(rowId, colIdx).isDisabled()) return;
		mygrid.cells(rowId, colIdx).setValue("");
	},
	validationCell	: function(gridId, rowId, colId) {
		if(explanGrid._PAUSE_VALID != undefined) return true;
		var gridInfo = this.getGrid(gridId);
		var mygrid = gridInfo.grid;
		var colIdx = mygrid.getColIndexById(colId);
		return mygrid.validateCell(rowId , colIdx);	   			
	},
	selectedRowPaste : function(gridId, exceptColList) {
		var gridInfo = this.getGrid(gridId);
		var mygrid = gridInfo.grid;
		var rowIdList = this.getCheckedRowId(gridId, "[!CB]");
		if(rowIdList.length == 0) {
			alert('체크 박스를 1개 선택해 주세요.');
			return;
		} else if(rowIdList.length > 1) {
			alert('체크 박스를 1개 선택해 주세요.');
			return;
		}
		var rowId = rowIdList[0];
		explanGrid.setFocusById(gridId, rowId);
		this.pasteFromClipboard(mygrid, exceptColList, true);
		return rowId;
	},
	pasteFromClipboard : function(mygrid, exceptColList, firstCheck) {
		if(mygrid.session["cellEditState"] == 1) return;
		var gridId			= mygrid.getGridId();
		var gridInfo		= this.getGrid(gridId);
		var viewOrderList	= gridInfo.viewOrderList;
		if(viewOrderList == undefined) return;
		var viewOrderArray = viewOrderList.split(",")
		var colIdx			= mygrid.getSelectedCellIndex();
		if(firstCheck) {
			var startColId = "";
			$.each(viewOrderArray, function(idx) {
				var item = this;
				if(in_array(item.substring(0,5), ["[!CB]","[!RN]"])) return true;
				startColId = viewOrderArray[idx];
				return false;
			})
			var idx = mygrid.getColIndexById(startColId);
			if(isValid(idx)) colIdx = idx;
		}
		var sColId			= mygrid.getColumnId(colIdx);
		var sRowId 			= mygrid.getSelectedRowId();
		var sRowIdx			= mygrid.getRowIndex(sRowId);
		var clipData 		= window.clipboardData.getData('text');
		
		var viewColIdx		= 0;
		$.each(viewOrderArray, function(idx) {
			if(sColId == this) {
				viewColIdx = idx;
				return false;
			}
		});
		if(clipData != undefined && clipData.length > 1000) progressBarShow("pasteClipboard");
		setTimeout(function() {
			_MSG_DISABLED = "Y";
			if(isValid(clipData,1)) {
				var rowList = clipData.replaceAll("\r", "").split("\n");
				// 복사 붙이기시 Start Paste Event 처리
				if(typeof mygrid.userFunction.onStartPaste == "function") {
					mygrid.userFunction.onStartPaste(gridId);
				}
				$.each(rowList, function(rIdx) {
					var rowVal = this;
					if(!isValid(rowVal.trim(),1)) return true;
					var colList = rowVal.split("\t");
					var rowId = mygrid.getRowId(sRowIdx + rIdx);
					if(rowId == undefined) {
						if(mygrid.session.pasteAutoExtend) rowId = explanGrid.addRow(mygrid.getGridId());
						else return false;
					}
					$.each(colList, function(cIdx) {
						var colVal = this + "";
						var colId = viewOrderArray[viewColIdx + cIdx];
						if(colId == undefined) return false;
						// Paste가 되지 않도록 할 목록 세팅
						//if(in_array(colId , ["MATERIAL_TYPE"])) return true;
						var rColIdx = mygrid.getColIndexById(colId);
						
						var colType = mygrid.getCellType(rowId, colId);
						if(colType == undefined) colType = mygrid.getColType(rColIdx);
						if(in_array(colType, ["ro", "static", "tree", "search2"]) || mygrid.cells(rowId, rColIdx).isDisabled()) return true;
						if(exceptColList != undefined && in_array(colId, exceptColList)) return true;

						mygrid.cells(rowId, rColIdx).setValue(colVal);
					});
				});
				// 복사 붙이기시 End Paste Event 처리
				if(typeof mygrid.userFunction.onEndPaste == "function") mygrid.userFunction.onEndPaste(gridId);
			}
			_MSG_DISABLED = undefined;
			progressBarHide("pasteClipboard");
		}, 100);
		
	},
	getColIndexById : function(gridId, colId) {
		var gridInfo	= this.getGrid(gridId);
		var mygrid 		= gridInfo.grid;
		return mygrid.getColIndexById(colId);
	},
	// Cell의 Diabled설정을 한다.
	// 참고) colId를 생략하거나 null이면 Row 전체를 Disabled한다.
	setDisabled : function(gridId, rowIdx, colId, bool) {
		if(!isValid(bool)) bool = true;
		var gridInfo	= this.getGrid(gridId);
		var mygrid 		= gridInfo.grid;
		var rowId		= mygrid.getRowId(rowIdx);
		explanGrid.setDisabledById(gridId, rowId, colId, bool);
	},
	isDisabled : function(gridId, rowId, colId) {
		var gridInfo	= this.getGrid(gridId);
		var mygrid 		= gridInfo.grid;
		var colIdx 		= mygrid.getColIndexById(colId);
		var bool 		= mygrid.cells(rowId, colIdx).isDisabled();
		if(bool === undefined) bool = false;
		return bool;	
	},
	// Cell의 Diabled설정을 한다.
	// 참고) colId를 생략하거나 null이면 Row 전체를 Disabled한다.
	setDisabledById : function(gridId, rowId, colId, bool) {
		if(!isValid(bool)) bool = true;
		var gridInfo	= this.getGrid(gridId);
		var mygrid 		= gridInfo.grid;
		var orderArr;
		if(!isValid(colId))	orderArr = gridInfo.viewOrderList.split(",");
		else 				orderArr = [colId];
		$.each(orderArr, function() {
			var colId = this;
			var colIdx 		= mygrid.getColIndexById(colId);
			mygrid.cells(rowId,colIdx).setDisabled(bool);
			mygrid.cells(rowId,colIdx).setAttribute("disabled" , bool);
			if(bool)	mygrid.setCellTextStyle(rowId,colIdx,"background-color:"+STATIC_BACK_COLOR+";");
			else		mygrid.setCellTextStyle(rowId,colIdx,"background-color:;");
		});
	},
	// CheckBox의 상태를 설정한다.
	setChecked : function(gridId, rowId, colId, bool) {
		if(colId == undefined) colId = "[!CB]";
		var gridInfo	= this.getGrid(gridId);
		var mygrid 		= gridInfo.grid;
		var colIdx 		= mygrid.getColIndexById(colId);
		mygrid.cells(rowId,colIdx).setChecked(bool);
	},
	// Check All에 대한 설정을 한다.
	checkAll : function(gridId, bool) {
		var gridInfo = this.getGrid(gridId);
		var mygrid = gridInfo.grid;
		mygrid.checkAll(bool);
	},
	// 컬럼을 Check 설정 한다.
	setCheckedRows : function(gridId, colId, bool) {
		var gridInfo = this.getGrid(gridId);
		var mygrid = gridInfo.grid;
		var colIdx = mygrid.getColIndexById(colId);
		mygrid.setCheckedRows(colIdx, bool);
	},
	//그리드 페이징 
	setPageBox : function(gridId,Pagecontainer , totalSize , currentPage){
		
		var gridParm	= this._GRID[gridId].gridParm;
		var Pagecontainer = gridParm.pagebox;
		var totalSize = gridParm.totalcount; 
		var currentPage = gridParm.currentpage;
		var rowsPerPage = gridParm.rowsPerPage;
		// 변수로 그리드아이디, 총 데이터 수, 현재 페이지를 받는다
		if(currentPage==""){
			var currentPage = 1;
		}
		// 한 페이지에 보여줄 페이지 수 (ex:1 2 3 4 5)
		var pageCount = 10;
		// 그리드 데이터 전체의 페이지 수
		var totalPage = Math.ceil(totalSize/rowsPerPage);
		// 전체 페이지 수를 한화면에 보여줄 페이지로 나눈다.
		var totalPageList = Math.ceil(totalPage/pageCount);
		// 페이지 리스트가 몇번째 리스트인지
		var pageList=Math.ceil(currentPage/pageCount);
		
		//alert("currentPage="+currentPage+"/ totalPage="+totalSize);
		//alert("pageCount="+pageCount+"/ pageList="+pageList);
		
		// 페이지 리스트가 1보다 작으면 1로 초기화
		if(pageList<1) pageList=1;
		// 페이지 리스트가 총 페이지 리스트보다 커지면 총 페이지 리스트로 설정
		if(pageList>totalPageList) pageList = totalPageList;
		// 시작 페이지
		var startPageList=((pageList-1)*pageCount)+1;
		// 끝 페이지
		var endPageList=startPageList+pageCount-1;
		
		//alert("startPageList="+startPageList+"/ endPageList="+endPageList);
		
		// 시작 페이지와 끝페이지가 1보다 작으면 1로 설정
		// 끝 페이지가 마지막 페이지보다 클 경우 마지막 페이지값으로 설정
		if(startPageList<1) startPageList=1;
		if(endPageList>totalPage) endPageList=totalPage;
		if(endPageList<1) endPageList=1;
		
		// 페이징 DIV에 넣어줄 태그 생성변수 
		var pageInner="";
		
		
		var lastPageNum		= Math.floor((totalSize-1)/rowsPerPage) + 1;
		
		//이전페이지 계산
		var previewPageNum = parseInt(currentPage , 10) - pageCount;
		
		if ( previewPageNum <= 0 ){
			previewPageNum = 1;
		}
		
		//다음 페이지 계산
		var nextPageNum = parseInt(currentPage , 10) + pageCount;
		
		if ( nextPageNum > lastPageNum ) {
			nextPageNum = lastPageNum;
		}
		
		// 페이지 리스트가 1이나 0일 경우 (링크 빼고 흐린 이미지로 변경)
		if(pageList<2){
			
			pageInner+="<span class='first'></span>";
			pageInner+="<span class='prev'></span>";
			
		}
		// 이전 페이지 리스트가 있을 경우 (링크넣고 뚜렷한 이미지로 변경)
		if(pageList>1){
			
			pageInner+="<a class='first' href='javascript:explanGrid.goPage(\"" + gridId + "\",1);' title='첫페이지'></a>";
			pageInner+="<a class='prev' href='javascript:explanGrid.goPage(\"" + gridId + "\"," + previewPageNum + ");' title='이전페이지'></a>";
			
		}
		// 페이지 숫자를 찍으며 태그생성 (현재페이지는 강조태그) 
		for(var i=startPageList; i<=endPageList; i++){
			if(i==currentPage){
				pageInner = pageInner +"<strong>"+(i)+"</strong>";
			}else{
				pageInner = pageInner +"<a href='javascript:explanGrid.goPage(\"" + gridId + "\","+ i +");'>"+ i +"</a>";
			}
			
		}
		//alert("총페이지 갯수"+totalPageList);
		//alert("현재페이지리스트 번호"+pageList);
		
		// 다음 페이지 리스트가 있을 경우
		if(totalPageList>pageList){
			
			pageInner+="<a class='next' href='javascript:explanGrid.goPage(\"" + gridId + "\"," + nextPageNum + ");' title='다음페이지'></a>";
			pageInner+="<a class='final' href='javascript:explanGrid.goPage(\"" + gridId + "\"," + lastPageNum + ");' title='마지막페이지'></a>";
		}
		// 현재 페이지리스트가 마지막 페이지 리스트일 경우
		if(totalPageList==pageList){
			
			pageInner+="<span class='next'></span>";
			pageInner+="<span class='final'></span>";
		}   
		//alert(pageInner);
		// 페이징할 DIV태그에 우선 내용을 비우고 페이징 태그삽입
		$("#" + Pagecontainer).html("");
		$("#" + Pagecontainer).append(pageInner);
		
	},
	goPage : function(gridId , p_num){
		if(typeof explanGrid._FN_PAGE_CALLBACK[gridId] == "function") explanGrid._FN_PAGE_CALLBACK[gridId](p_num);
	},
	callEvent : function (eventName, gridId, colId) {
		var gridInfo	= this.getGrid(gridId);
		var mygrid 		= gridInfo.grid;
		if(eventName == "onChange") {
			var rowIds = mygrid.getAllRowIds();
			var rowIdList = rowIds.split(",");
			$.each(rowIdList, function() {
				var rowId = this;
				explanGrid.triggerGridOnChange(gridId, rowId, colId);
			});
		}
	},
	triggerGridOnChange : function(gridId, rowId, colId) {
		// Event 일시 정지 인경우 Onchange Event 실행 하지 않음.
		if(explanGrid._PAUSE_EVENT[gridId] != undefined && explanGrid._PAUSE_EVENT[gridId]["ONCHANGE"] == "Y") return true;
		var gridInfo	= this.getGrid(gridId);
		var mygrid 		= gridInfo.grid;
		var rowData 	= explanGrid.getRowData(gridId, rowId);
		var nValue		= rowData[colId];
		mygrid.userFunction.changeFn[gridId](gridId, rowId,colId ,nValue, "CC", rowData);		
	},
	triggerAllRowOnChange : function(gridId, colId) {
		// Event 일시 정지 인경우 Onchange Event 실행 하지 않음.
		if(explanGrid._PAUSE_EVENT[gridId] != undefined && explanGrid._PAUSE_EVENT[gridId]["ONCHANGE"] == "Y") return true;
		var gridInfo	= this.getGrid(gridId);
		var mygrid 		= gridInfo.grid;
		var rowIds 		= mygrid.getAllRowIds();
		var rowIdList = rowIds.split(",");
		$.each(rowIdList, function() {
			var rowId = this;
			var rowData 	= explanGrid.getRowData(gridId, rowId);
			var nValue		= rowData[colId];
			mygrid.userFunction.changeFn[gridId](gridId, rowId,colId ,nValue, "CC", rowData);		
		})
	},
	gridColorClear : function(gridId, rowId) {
		var gridInfo	= this.getGrid(gridId);
		var mygrid 		= gridInfo.grid;
		if(rowId == undefined) {
			var rowIds = mygrid.getAllRowIds();
			if(rowIds == "") return result;
			var rowIdList = rowIds.split(",");
			for (var rowIndex=0; rowIndex<rowIdList.length; rowIndex++) {
				var item = {};
				var rowId = rowIdList[rowIndex];
		        for(var cellIndex = 0; cellIndex < mygrid.getColumnsNum(); cellIndex++){
		        	var colId = explanGrid.getColId(gridId, cellIndex);
		        	if(colId == "MODEL_CODE") continue;
		        	var colId = explanGrid.getColId(gridId, cellIndex);
		        	var cellType = explanGrid.getCellType(gridId, rowId, colId);
		        	if(cellType == "static") continue;
		        	mygrid.setCellTextStyle(rowId, cellIndex,"background-color:;");	        	
		        }
			}
		} else {
	        for(var cellIndex = 0; cellIndex < mygrid.getColumnsNum(); cellIndex++){
	        	var colId = explanGrid.getColId(gridId, cellIndex);
	        	if(colId == "MODEL_CODE") continue;
	        	var cellType = explanGrid.getCellType(gridId, rowId, colId);
	        	if(cellType == "static") continue;
	        	mygrid.setCellTextStyle(rowId, cellIndex,"background-color:;");	        	
	        }
		}
	},
	getPreCellData : function(gridId, rowId, colId) {
		var gridInfo	= this.getGrid(gridId);
		var mygrid 		= gridInfo.grid;
		if(mygrid.changedPreCellList[rowId] == undefined) return;
		return mygrid.changedPreCellList[rowId][colId];
	},
	getGridRowCnt : function(gridId) {
		var gridInfo = this.getGrid(gridId);
		var mygrid = gridInfo.grid;
		var rowIds = mygrid.getAllRowIds();
		if(!isValid(rowIds,1)) return 0;
		var rowIdList = rowIds.split(",");
		return rowIdList.length;
	},
	getDeletedCols : function(gridId, colId) {
		var gridInfo = this.getGrid(gridId);
		var mygrid = gridInfo.grid;
		var resultList = [];
		$.each(mygrid.deletedListMap, function(rowId, data) {
			resultList.push(data[colId]);
		});
		return resultList;
	},
	makeConfigInfo : function(itemType, type) {
		if(type == undefined) type = "edit";
		
		var returnMap = {
			columnConfig 	: {},
			validatorList	: {}
		};
		if(type == "edit") {
			
			// 항목 Type 설정
			var ddItemListStr = "";
			if(itemType.comboList !== undefined) {
				$.each(itemType.comboList, function() {
					if(Object.prototype.toString.call(this)  == '[object String]') {
						returnMap.columnConfig[this] = { "colType" : "combo"}
						ddItemListStr += "," + this;
					} else {
						returnMap.columnConfig[this.id] = { "colType" : "combo", "subId" : this.subId}
						ddItemListStr += "," + this.id;
					}
				});
			}
			if(itemType.searchList !== undefined) {
				$.each(itemType.searchList, function() {
					returnMap.columnConfig[this] = { "colType" : "search"}
					ddItemListStr += "," + this;
				});
			}
			if(itemType.searchList2 !== undefined) {
				$.each(itemType.searchList2, function() {
					if(typeof this != "object" || this.length != 2) {
						alert('itemType의 searchList2 설정값이 잘못 되었습니다.');
						return false;
					}
					returnMap.columnConfig[this[0]] = { "colType" : "search2"}
					ddItemListStr += "," + this;
					
					// Data 보관함에 설정값 넣음.
					_SVC_COM.putCubbyhole(this[0], this);
				});
			}
			if(itemType.searchSingleList !== undefined) {
				$.each(itemType.searchSingleList, function() {
					returnMap.columnConfig[this] = { "colType" : "searchSingle"}
					ddItemListStr += "," + this;
				});
			}
			if(itemType.numberList !== undefined) {
				$.each(itemType.numberList, function() {
					returnMap.columnConfig[this] = { "colType" : "edncl", "align" : "right"};
				});
			}
			if(itemType.floatList !== undefined) {
				$.each(itemType.floatList, function() {
					returnMap.columnConfig[this] = { "colType" : "ednfl", "align" : "right"};
				});
			}
			if(itemType.mnumList !== undefined) {
				$.each(itemType.mnumList, function() {
					returnMap.columnConfig[this] = { "colType" : "mnum", "align" : "right"};
				});
			}
			
			// 항목들 DD값 설정
			ddItemListStr = ddItemListStr.substring(1);
			
			if(isValid(ddItemListStr)) {
				// 항목들 읽기
				var ddList = _SVC_COM.getDDList(ddItemListStr);
				var ddListMap = fn_groupingArray(ddList, "COMMON_TCD");
				$.each(ddListMap, function(key, list) {
					if(_DD_MAP[key] == undefined) _DD_MAP[key] = {};
					$.each(list, function() {
						_DD_MAP[key][this.COMMON_CODE] = this.COMMON_NAME;
						if(isValid(this["SUB_ID"])) {
							var newKey = key + this["SUB_ID"];
							if(_DD_MAP[newKey] == undefined) _DD_MAP[newKey] = {};
							_DD_MAP[newKey][this.COMMON_CODE] = this.COMMON_NAME;
						}
					});
				});
			}
			
			// 전체 항목에 대해 Valid 처리
			var orderList = itemType.orderList;
			if(itemType.emptyList == undefined) itemType.emptyList = [];
			orderArray = orderList.split(",");
			// Not Empty valid 처리
			$.each(orderArray, function() {
				var itemName = this;
				if(itemName == itemName.removeRangeChar("[!", "]")) {
					if(!in_array(itemName, itemType.emptyList)){
						returnMap.validatorList[itemName] = function(cellData, gridId, rowId, colId) {
							var gridInfo 		= explanGrid.getGrid(gridId);
							var mygrid 			= gridInfo.grid;
							var columnConfig 	= gridInfo.gridParm.cellConfig.columnConfig;
							if(isValid(cellData,1))	{
								// 제한 길이 Check
								var maxlength = columnConfig[colId]["maxlength"];
								if(isValid(maxlength)) {
									var len = getByte(cellData);
									if(Number(maxlength) < len) {
										var msg = "입력 내용을 너무 깁니다.\n\n영문,숫자는 " + maxlength + "글자, 한글은 " + (maxlength / 2) + "글자 이내로 작성해 주세요";
										mygrid.setValidErrMsg(rowId, colId, msg);
										return false;
									}
								}
								return true;
							}
							else {
								mygrid.setValidErrMsg(rowId, colId, "필수 입력 항목 입니다.");
								return false;
							}
						}
					} else {
						returnMap.validatorList[itemName] = function(cellData, gridId, rowId, colId) {
							var gridInfo 		= explanGrid.getGrid(gridId);
							var mygrid 			= gridInfo.grid;
							var columnConfig 	= gridInfo.gridParm.cellConfig.columnConfig;
							if(isValid(cellData,1))	{
								// 제한 길이 Check
								var maxlength = columnConfig[colId]["maxlength"];
								if(isValid(maxlength)) {
									var len = getByte(cellData);
									if(Number(maxlength) < len) {
										var msg = "입력 내용을 너무 깁니다.\n\n영문,숫자는 " + maxlength + "글자, 한글은 " + Math.floor(maxlength / 2) + "글자 이내로 작성해 주세요";
										mygrid.setValidErrMsg(rowId, colId, msg);
										return false;
									}
								}
								return true;
							}
							else {
								return true;
							}
						}
					}
				}
			});
			
			// 항목들 유효 Function 설정
			var ddItemList = ddItemListStr.split(","); 
			$.each(ddItemList, function() {
				var itemName = this;
				
				// 기본 Validation을 사용하는 경우 DD값 Valiation을 생략한다.
				if(in_array(itemName, itemType.baseValidation)) return true;
				
				returnMap.validatorList[itemName] = function(cellData, gridId, rowId, colId) {
					var gridInfo 		= explanGrid.getGrid(gridId);
					var mygrid 			= gridInfo.grid;
					var columnConfig 	= gridInfo.gridParm.cellConfig.columnConfig;
					var subId 			= "";
					if(isValid(columnConfig[colId].subId)) subId = columnConfig[colId].subId;
					if(isValid(_DD_MAP[itemName + subId][cellData],1)) {
						return true;
					} else {
						var msg = "허용되지 않는 값입니다.";
						mygrid.setValidErrMsg(rowId, colId, msg);
						return false;
					}
				}
			});
			
			// mnumlist에 대해서 Valid 설정
			if(itemType.mnumList !== undefined) {
				$.each(itemType.mnumList, function() {
					var fn = returnMap.validatorList[this];
					returnMap.validatorList[this] = function(cellData, gridId, rowId, colId) {
						var result = fn(cellData, gridId, rowId, colId);
						if(!result) return false;
						if(!isValid(cellData)) return true;
						if(!isNumber(makeUnMoneyStr(cellData))) {
							var gridInfo 		= explanGrid.getGrid(gridId);
							var mygrid 			= gridInfo.grid;
							var msg = "허용되지 않는 값입니다.";
							mygrid.setValidErrMsg(rowId, colId, msg);
							return false;
						}
						return result;
					}
				});
			}
		} else {
			$.each(itemType.numberList, function() {
				returnMap.columnConfig[this] = { "colType" : "ednro", "align" : "right"};
			});
		}
		
		// config에 Setting이 없어도 기본 세팅을 한다.
		// 전체 항목에 대해 Valid 처리
		var orderList = itemType.orderList;
		var orderArray = orderList.split(",");
		// Not Empty valid 처리
		$.each(orderArray, function() {
			var itemName = this;
			if(itemName == itemName.removeRangeChar("[!", "]") && !isValid(returnMap.columnConfig[this])) returnMap.columnConfig[this] = {};
			
			// 빈값허용처리
			if(in_array(itemName, itemType.emptyList)) {
				returnMap.columnConfig[this]["allowEmpty"] = true;
			}
			
		});
		return returnMap;
	},
	// Cell Edit중 바로 Save등 Grid내용을 읽는 Function이 실행되는 경우 현재 Edit중인 Cell을 읽지 못하는 오류 방지
	execAfterEdit : function(gridId, fn) {
		var gridInfo = this.getGrid(gridId);
		var mygrid = gridInfo.grid;
		var cnt = 0;
		var vfn = function(){};
		var vfn = function() {
			setTimeout(function() {
				if(mygrid.session["cellEditState"] != undefined && mygrid.session["cellEditState"] != 2 && cnt++ < 10) vfn();
				else fn();
			}, 200)
		};
		vfn();
	},
	// 해당 Cell의 Color를 설정한다.
	setBackgroundColorAtCell : function(gridId, rowId, colId, colorCode) {
		var gridInfo = this.getGrid(gridId);
		var mygrid = gridInfo.grid;
		var colIdx = mygrid.getColIndexById(colId);
		var orderArr;
		if(!isValid(colId))	orderArr = gridInfo.viewOrderList.split(",");
		else 				orderArr = [colId];
		$.each(orderArr, function() {
			var colIdx 	= mygrid.getColIndexById(this);
			mygrid.setCellTextStyle(rowId,colIdx,"background-color:"+colorCode+";");
		});
	}
};


/**
 * DHTMLX 별도 설정 영역
 */
//dthmlx에서 숫자 Type(edncl) 정의 - Edit 가능
function eXcell_edncl(cell){
	this.base = eXcell_edn;
	this.base(cell)
    if (cell){                
        this.cell 	= cell;
        this.grid 	= this.cell.parentNode.grid;
    }
	this.setValue = function(val){
		val = val + "";
		if(!val || val.toString()._dhx_trim()=="") {
			this.setCValue("",val);  
		} else if(!isNumber(val)) {
			this.setCValue("",val);
		} else {
			this.setCValue(this.grid._aplNF(val,this.cell._cellIndex),val);
		}
	}
    this.getValue=function(){
    	var retVal = $(this.cell).html();
    	if(!isValid(retVal)) retVal = ""; 
    	if( retVal != undefined) retVal = retVal.replaceAll(",", "");
    	return retVal;
    }
}
eXcell_edncl.prototype = new eXcell_edn;

//dthmlx에서 숫자 Type(edncl) 정의 - Edit 가능
function eXcell_ednfl(cell){
	this.base = eXcell_edn;
	this.base(cell)
    if (cell){                
        this.cell 	= cell;
        this.grid 	= this.cell.parentNode.grid;
    }
	this.setValue = function(val){
		val = val + "";
		if(!val || val.toString()._dhx_trim()=="") {
			this.setCValue("",val);  
		} else if(!isNumber(val)) {
			this.setCValue("",val);
		} else {
			this.setCValue(val,val);
		}
	}
    this.getValue=function(){
    	var retVal = $(this.cell).html();
    	if(!isValid(retVal)) retVal = ""; 
    	if( retVal != undefined) retVal = retVal.replaceAll(",", "");
    	return retVal;
    }
}
eXcell_ednfl.prototype = new eXcell_edn;

//dthmlx에서 숫자 Type(ednro) 정의 - Edit 불가능
function eXcell_ednro(cell){
	this.base = eXcell_edn;
	this.base(cell)
    if (cell){                
        this.cell 	= cell;
    }
	this.isDisabled=function(){
		return true;
	}
	this.edit = function(){
		return false;
	}
	this.detach = function(){
		return false;
	}
	this.setValue = function(val){
		val = val + "";
		if(!val || val.toString()._dhx_trim()=="") {
			this.setCValue("",val);  
		} else if(!isNumber(val)) {
			this.setCValue("",val);
		} else {
			this.setCValue(val,val);
		}
	}
    this.getValue=function(){
    	var retVal = $(this.cell).html();
    	if(!isValid(retVal)) retVal = ""; 
    	if( retVal != undefined) retVal = retVal.replaceAll(",", "");
    	return retVal;
    }
}
eXcell_ednro.prototype = new eXcell_edn;

//dhtmlx에서 날짜 Type Edit 가능
function eXcell_date(cell){
    if (cell){                
        this.cell 	= cell;
        this.grid 	= this.cell.parentNode.grid;
        eXcell_ed.call(this);
    }
	this.setValue = function(val){
		val = val.replaceAll("-", "");
		if(val.length == 8) val = getDateFormat(val, 8, "-");
		
		if(val != "" && !fgb_checkDate(val)) {
			_SVC_COM.toastPopup('날짜 형식이 맞지 않습니다.<br/><br/>입력 가능한 형식은 다음과 같습니다.<br/><br/>20160202<br/>2016-01-02');
			val = "";
		}
		this.setCValue(val,val);
	}
    this.getValue=function(){
    	var retVal = $(this.cell).html().replaceAll("-", "");
    	return retVal;
    }
}
eXcell_date.prototype = new eXcell;


//Grid 검색창 Cell Type 정의
function eXcell_search(cell){ 
    if (cell){                
        this.cell 	= cell;
        this.grid 	= this.cell.parentNode.grid;
        eXcell_ed.call(this);
    }
    this.setValue=function(val){
    	var gridId=this.grid.getGridId();
    	var grid	= this.grid;	
    	var rowId=this.cell.parentNode.idd;
    	var columnId	= this.grid.getColumnId(this.cell.cellIndex);
    	var functionStr = "_G_FN.selectSearchPopup.open('"+gridId+"', '"+rowId+"', '"+columnId+"')";
    	var insertStr = _SVC_DHTMLX.getSearchButtonToDhtmlx(val, functionStr);
    	// Search Popup Callback 등록 => selectSearchPopup 에서 리턴하는 값을 처리한다.
    	this.grid.userFunction.callback["search"] = function(gridId, rowId, columnId, code, name) {
    		explanGrid.setValueById(gridId, rowId, columnId, code);
    		if( typeof grid.userFunction.afterPopup[gridId] == "function") {
    			var parm = {
    				popupName 	: "search",
    				gridId		: gridId,
    				rowId		: rowId,
    				columnId	: columnId,
    				code		: code,
    				name		: name
    			}
    			grid.userFunction.afterPopup[gridId](parm); 
    		}
    	}
		this.setCValue(insertStr,val);  
    }
    this.getValue=function(){
    	var retVal = $(this.cell.firstChild.firstChild).html().replace("&nbsp;", "");
    	return retVal;
    }
}
eXcell_search.prototype = new eXcell; 

function eXcell_search2(cell){ 
    if (cell){                
        this.cell 	= cell;
        this.grid 	= this.cell.parentNode.grid;
    }
    this.setValue=function(val){
    	var gridId		=this.grid.getGridId();
    	var grid		= this.grid;	
    	var rowId		=this.cell.parentNode.idd;
    	var columnId	= this.grid.getColumnId(this.cell.cellIndex);
    	
    	var functionStr	= "";

    	// Cell이 Disabled인 경우 검색 버튼을 숨긴다.
    	var bool 		= explanGrid.isDisabled(gridId, rowId, columnId);
    	if(bool === false) {
    		functionStr = "_G_FN.selectSearchPopup2.open('"+gridId+"', '"+rowId+"', '"+columnId+"')";
    	}
    	var insertStr 	= _SVC_DHTMLX.getSearchButtonToDhtmlx(val, functionStr);

    	// Search Popup Callback 등록 => selectSearchPopup2 에서 리턴하는 값을 처리한다.
    	this.grid.userFunction.callback["search2"] = function(gridId, rowId, columnId, code, name) {
    		var config = _SVC_COM.getCubbyhole(columnId);
    		if( typeof grid.userFunction.afterPopup[gridId] == "function") {
    			var parm = {
    				 popupName 	: "search2"
    				,gridId		: gridId
    				,rowId		: rowId
    				,columnId	: columnId
    				,code		: code
    				,name		: name
    				,config		: config
    			}
    			var result = grid.userFunction.afterPopup[gridId](parm);
    			if(result !== false) {
            		explanGrid.setValueById(gridId, rowId, config[0], name);
            		explanGrid.setValueById(gridId, rowId, config[1], code);
    			}
    		} else {
        		explanGrid.setValueById(gridId, rowId, config[0], name);
        		explanGrid.setValueById(gridId, rowId, config[1], code);
    		}
    	}
		this.setCValue(insertStr,val);  
    }
    this.getValue=function(){
    	var retVal = $(this.cell.firstChild.firstChild).html().replace("&nbsp;", "");
    	return retVal;
    }
}
eXcell_search2.prototype = new eXcell; 


//Grid 검색창 Cell Type 정의
function eXcell_searchSingle(cell){ 
    if (cell){                
        this.cell 	= cell;
        this.grid 	= this.cell.parentNode.grid;
        eXcell_ed.call(this);
    }
    this.setValue=function(val){
    	var gridId=this.grid.getGridId();
    	var grid	= this.grid;	
    	var rowId=this.cell.parentNode.idd;
    	var columnId	= this.grid.getColumnId(this.cell.cellIndex);
    	var functionStr = "_G_FN.selectSearchSinglePopup.open('"+gridId+"', '"+rowId+"', '"+columnId+"')";
    	var insertStr = _SVC_DHTMLX.getSearchButtonToDhtmlx(val, functionStr);
    	// Search Popup Callback 등록 => selectSearchPopup 에서 리턴하는 값을 처리한다.
    	this.grid.userFunction.callback["searchSingle"] = function(gridId, rowId, columnId, code) {
    		explanGrid.setValueById(gridId, rowId, columnId, code);
    		if( typeof grid.userFunction.afterPopup[gridId] == "function") {
    			var parm = {
    				popupName 	: "searchSingle",
    				gridId		: gridId,
    				rowId		: rowId,
    				columnId	: columnId,
    				code		: code
    			}
    			grid.userFunction.afterPopup[gridId](parm); 
    		}
    	}
		this.setCValue(insertStr,val);  
    }
    this.getValue=function(){
    	var retVal = $(this.cell.firstChild.firstChild).html().replace("&nbsp;", "");
    	return retVal;
    }
}
eXcell_searchSingle.prototype = new eXcell; 



//Grid 검색창 Cell Type 정의
function eXcell_static(cell){ 
    if (cell){                
        this.cell 	= cell;
        this.grid 	= this.cell.parentNode.grid;
    }
    this.setValue=function(val){
    	var gridId 	= this.grid.getGridId();
    	var grid	= this.grid;	
    	var rowId	=this.cell.parentNode.idd;
    	var columnId	= this.grid.getColumnId(this.cell.cellIndex);
    	grid.setCellTextStyle(rowId,this.cell.cellIndex,"background-color:"+STATIC_BACK_COLOR+";");
    	
		if(!isNumber(val)) {
			this.setCValue(val,val);
		} else {
			val = val + "";
			this.setCValue(val,val);
		}
    }
    this.getValue=function(){
    	var retVal = $(this.cell).html();
    	if(!isValid(retVal)) retVal = ""; 
    	return retVal;
    }
}
eXcell_static.prototype = new eXcell_ro; 

//Grid 검색창 Cell Type 정의
function eXcell_returned(cell){ 
    if (cell){                
        this.cell 	= cell;
        this.grid 	= this.cell.parentNode.grid;
        eXcell_edtxt.call(this);
    }
    this.setValue=function(val){
    	var gridId 	= this.grid.getGridId();
    	var grid	= this.grid;	
    	var rowId	=this.cell.parentNode.idd;
    	var columnId	= this.grid.getColumnId(this.cell.cellIndex);
    	grid.setCellTextStyle(rowId,this.cell.cellIndex,"background-color:;");
		this.setCValue(val,val);  
    }
    this.getValue=function(){
    	var retVal = $(this.cell).html();
    	return retVal;
    }
}
eXcell_returned.prototype = new eXcell; 

// Block Copy가 가능한 ro
function eXcell_roe(cell){ 
    if (cell){                
        this.cell 	= cell;
        this.grid 	= this.cell.parentNode.grid;
    }
    this.setValue=function(val){
    	var gridId 	= this.grid.getGridId();
    	var grid	= this.grid;	
    	var rowId	=this.cell.parentNode.idd;
    	grid.setCellTextStyle(rowId,this.cell.cellIndex,"background-color:" + STATIC_BACK_COLOR + ";");
		this.setCValue(val,val);  
    }
    this.getValue=function(){
    	var retVal = $(this.cell).html();
    	return retVal;
    }
}
eXcell_roe.prototype = new eXcell; 

//dhtmlx에서 날짜 Type Edit 가능
function eXcell_birth(cell){
    if (cell){                
        this.cell 	= cell;
        this.grid 	= this.cell.parentNode.grid;
        eXcell_ed.call(this);
    }
	this.setValue = function(val){
		if(!isValid(val)) val = "";
		if(val.length == 8 ) val = getDateFormat(val, 8, "-");
		this.setCValue(val,val);
	}
    this.getValue=function(){
    	var retVal = $(this.cell).html();
    	if(isValid(retVal)) retVal = retVal.replaceAll("-", "");
    	return retVal;
    }
}
eXcell_birth.prototype = new eXcell;

//피보험자 표현식
function eXcell_insuredro(cell){ 
    if (cell){                
        this.cell 	= cell;
        this.grid 	= this.cell.parentNode.grid;
        eXcell_ro.call(this);
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
		this.setCValue(val,val);  
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
eXcell_insuredro.prototype = new eXcell; 

//가입기간 표현식
function eXcell_termed(cell){ 
    if (cell){                
        this.cell 	= cell;
        this.grid 	= this.cell.parentNode.grid;
        eXcell_ed.call(this);
    }
    this.setValue=function(val){
    	if(isValid(val)) {
    		if(isNumber(val)) {
    			var obj = changeMonthToYearMonth(val);
    			if(obj.yyyy > 0) 	obj.yyyy = obj.yyyy + "년";
    			else				obj.yyyy = "";
    			if(obj.mm > 0) 		obj.mm = obj.mm + "개월";
    			else				obj.mm = "";
    			val = obj.yyyy + obj.mm;
    		} else {
    			
    			var month = changeMonthFromYearMonth(val)
    			if(month > 0) {
    				var obj = changeMonthToYearMonth(month);
        			if(obj.yyyy > 0) 	obj.yyyy = obj.yyyy + "년";
        			else				obj.yyyy = "";
        			if(obj.mm > 0) 		obj.mm = obj.mm + "개월";
        			else				obj.mm = "";
        			val = obj.yyyy + obj.mm;
        		}
        		else {
        			_SVC_COM.toastPopup('입력 형식이 맞지 않습니다.개월을 숫자 형식으로 입력 하세요.');
        			val = "";
        		}
    		}
    	}
		this.setCValue(val,val);  
    }
    this.getValue=function(){
    	var retVal = $(this.cell).html().replaceAll("&nbsp;", "");
    	var month = changeMonthFromYearMonth(retVal)
    	if(month < 0) month = "";
    	return month;
    }
}
eXcell_termed.prototype = new eXcell; 

//Grid 검색창 Cell Type 정의
//만원 단위 표현식
function eXcell_mnum(cell){ 
    if (cell){                
        this.cell 	= cell;
        this.grid 	= this.cell.parentNode.grid;
        eXcell_ed.call(this);
    }
    this.setValue=function(val){
    	if(isValid(val)) {
    		if(isNumber(val)) 	val = makeMoneyStr(val);
    		else 				val = makeMoneyStr(makeUnMoneyStr(val));
    	}
		this.setCValue(val,val);  
    }
    this.getValue=function(){
		var retVal = $(this.cell).html();
		return makeUnMoneyStr(retVal);
    }
}
eXcell_mnum.prototype = new eXcell; 


