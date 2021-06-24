/**
 * 파일 관련 서비스
 */ 
var _SVC_FILE = {
	// 파일 리스트 가져오기
	getFileList : function(docid) {
		var resultData = requestService("GET_FILE_LIST", {"DOCID" : docid});
		return resultData;
	},
	// 파일 정리 한다. 등록 대기중이거나 삭제 대기중인 파일을 모두 삭제 처리한다.
	refreshFileList : function(docid) {
		if(docid == undefined) return;
		requestService("REFRESH_FILE_LIST", {"DOCID" : docid});
	}
};

/**
 * 공통 서비스
 */
var _SVC_COM = {
	// DD 리스트 가져오기
	TCD_CACHE 		: {},
	LOAD_JS_FILE 	: {},
	getDDList : function(commonTcd) {
		if(this.TCD_CACHE[commonTcd] == undefined) {
			// Sync 형 Service
			var resultData = requestService("GET_DD_LIST", {"COMMON_TCD" : commonTcd});
			
			this.TCD_CACHE[commonTcd] = resultData.data;
		}
		return this.TCD_CACHE[commonTcd];
	},
	setSelectBox : function(resultData, targetId, headerObject) {
		
		var selectMap = {}

		if(headerObject != undefined) selectMap = headerObject;
		
		$.each(resultData, function() {
			var key 	= this.COMMON_CODE;
			var value 	= this.COMMON_NAME_EN;
			selectMap[key] = value;
		});
		fn_addJsonToSelectBox(targetId, selectMap, true);
	},
	initComponent : function(comId, sendParm, callback) {
		if(_T_FN[comId] == undefined) _T_FN[comId] = fn_copyObject(_G_FN[comId]);
		_G_FN[comId] = fn_copyObject(_T_FN[comId]);
		_G_FN[comId].init(sendParm, callback);
	},
	// 각 Component의 이름을 구한다.
	getComponentTitle : function(componentId) {
		var comp = _G_FN[componentId];
		if(typeof comp == "object") return comp.title;
		else return null;
	},
	toastPopup : function(str) {
		_SVC_POPUP.setConfig("toastPopup", {msg : str}, function(returnData) {
		});
		_SVC_POPUP.show("toastPopup");
	},
	getCurrentTabIndex : function() {
		var tabIdx = -1;
		$(".tab_cont").each(function(idx) {
			if($(this).css("display") == "block") tabIdx = idx;
		});
		return tabIdx;
	},
	// word.js에 있는 내용을 기준으로 최종 사용할 word를 로드한다.
	// 동일한 word id가 있는 경우 가장 나중 것이 적용된다.
	getWordListMap : function(groupIdList) {
		if(!isValid(groupIdList)) {
			return fn_copyObject(_COMMON_WORD_MAP);
		} else {
			var wordListMap = fn_copyObject(_COMMON_WORD_MAP);
			$.each(groupIdList, function() {
				wordListMap = $.extend(wordListMap, _WORD_LIST_MAP[this]);
			})
			return wordListMap;
		}
	},
	extendMethod : function(jsonObj, cInvestmentMethod){
		var cls = $.extend(jsonObj, cInvestmentMethod);
		if(typeof cls.loadDataInit == "function") cls.loadDataInit();
		return cls;
	},
	extendMethodToList : function(jsonList, cInvestmentMethod){
		var resultList = [];
		$.each(jsonList, function() {
			resultList.push(_SVC_COM.extendMethod(this, cInvestmentMethod));
		});
		return resultList;
	},
	// script lib의 중복 방지
	// 각 컴포넌트에서 필요한 js file을 include할때 타 컴포넌트에서 사용하는 동일한 js file include 방지 
	loadJsFile : function(path, callback) {
		if(_SVC_COM["LOAD_JS_FILE"] == undefined) _SVC_COM["LOAD_JS_FILE"] = {};
		// 기존에 로드 된적이 있는 File이면 생략한다.
		if(_SVC_COM["LOAD_JS_FILE"][path] == undefined) {
			var parm = {
				 targetUrl	: path
				,contentType: "text"
			}
			var jsFile = ajaxRequest(parm);
			document.write("<script type='text/javascript'>" + jsFile + "</" + "script>");
			_SVC_COM["LOAD_JS_FILE"][path] = "loaded";
		}
		if(callback != undefined) callback();
	},
	getPlanInfo : function(planNum) {
		// Loan List 읽어오기
		var parm = {
			 "sqlId" : "Common.getPlanInfo"
			,"planNum" : planNum
		}
		var gridInfo 	= requestService("GET_COMMON", parm);
		
		var returnObj = {}
		
		if(gridInfo.state == "S") returnObj = gridInfo.data[0];
		
		return returnObj;
	},
	// Data 보관함에 저장한다.
	putCubbyhole : function(key, obj) {
		if(!isValid(_G_VAL["CUBBYHOLE"])) _G_VAL["CUBBYHOLE"] = {};
		_G_VAL["CUBBYHOLE"][key] = obj;
		
	},
	// Data 보관함에서 꺼낸다.
	getCubbyhole : function(key, obj) {
		if(!isValid(_G_VAL["CUBBYHOLE"])) _G_VAL["CUBBYHOLE"] = {};
		return _G_VAL["CUBBYHOLE"][key]
	}
};

var _SVC_EVENT = {
	// Tab클릭시 실행 되는 Event를 등록한다.
	addTabClickEvent : function(onClickTabFunctionList) {
		$(".tab ul li").each(function(idx) {
			$(this).click(function() {
				// Tab Function List가 없는 경우 아무것도 실행 하지 않고 끝냄.
				if(!isValid(onClickTabFunctionList		)) return false;
				// 현재 Tab Function 이 유효하지 않은경우 Skipp
				if(!isValid(onClickTabFunctionList[idx]	)) return true;
				onClickTabFunctionList[idx]();
			});
		});
	}
}

//Layer Popup관련
var _SVC_POPUP = {
	// Popup 호출시 기본 HTML 저장 
	_HTML_TEMPLATE 	: {},
	_ON_POPUP_ID	: {},
	show : function(popupId) {
		this.showExec(popupId);
		explanGrid.refreshAllGrid();
	},
	showExec : function(popupId) {
		$("#" + popupId).css("visibility", "");
		var $layer 		= $("#" + popupId + ' .layer_pop').eq(0);
		var $contents 	= $("#" + popupId + ' .layer_pop .contents').eq(0);
		var width 	= $(window).width() 	- 50;
		var height 	= $(window).height() 	- 50;
		var max_width = 1200;
		var max_height = 700;
		var lwidth 	= $layer.width();
		var lheight	= $layer.height();
		var gid = popupId + "POPUP_BASE_INFO";
		if(_G_VAL[gid] == undefined) _G_VAL[gid] = {};
		if(_G_VAL[gid][popupId] == undefined) {
			_G_VAL[gid][popupId] = {};
			_G_VAL[gid][popupId].width 	= $layer.width(); 
			_G_VAL[gid][popupId].height = $layer.height(); 
		} else {
			var lwidth 	= _G_VAL[gid][popupId].width;
			var lheight	= _G_VAL[gid][popupId].height;
		}
		
		if(lwidth  < width	) width 	= lwidth;
		if(lheight < height	) height 	= lheight;
		
		if(width 	> max_width		) width 	= max_width;
		if(height 	> max_height	) height 	= max_height;
		
		var cwidth 	= width - 32;
		var cheight	= height- 87;
		$layer.css({'width':width,'height':height});
		$contents.css({'width':cwidth,'height':cheight});
		var left = ( ($(window).width() - $layer.width()) / 2 );
		var top = ( ($(window).height() - $layer.height()) / 2 );
		$layer.css({'left':left,'top':top});
		this._ON_POPUP_ID[popupId] = "N";
	},
	showFullScreen : function(popupId) {
		this.showFullScreenExec(popupId);
		explanGrid.refreshAllGrid();
	},
	showFullScreenExec : function(popupId) {
		$("#" + popupId).css("visibility", "");
		var $layer 		= $("#" + popupId + ' .layer_pop').eq(0);
		var $contents 	= $("#" + popupId + ' .layer_pop .contents').eq(0);
		var width 	= $(window).width() 	- 50;
		var height 	= $(window).height() 	- 50;
		var cwidth 	= width - 32;
		var cheight	= height- 90;
		$layer.css({'width':width,'height':height});
		$contents.css({'width':cwidth,'height':cheight});
		var left = ( ($(window).width() - $layer.width()) / 2 );
		var top = ( ($(window).height() - $layer.height()) / 2 );
		$layer.css({'left':left,'top':top});
		this._ON_POPUP_ID[popupId] = "F";
		
	},
	hide : function(popupId) {
		$("#" + popupId).css("visibility", "hidden");
		this._ON_POPUP_ID[popupId] = undefined;
	},
	initPopup : function(popupId) {
		this.hide(popupId);
	},
	setConfig : function(popupId, sendParm, callback) {
		if(popupId == undefined) {
			alert("popup id가 없습니다.");
			return;
		}
		if(this._HTML_TEMPLATE[popupId] == undefined) 	this._HTML_TEMPLATE[popupId] = $("#" + popupId).html();
		else											$("#" + popupId).html(this._HTML_TEMPLATE[popupId]);
		_G_FN[popupId].init(sendParm, callback);
	},
	popupResizeAll : function() {
		$.each(this._ON_POPUP_ID, function(popupId, value) {
			if		(value == "N") _SVC_POPUP.showExec(popupId);
			else if	(value == "F") _SVC_POPUP.showFullScreenExec(popupId);
		});
	},
	runtimeOpenPopup : function(popupId) {
		if($("#" + popupId).length == 0) {
			// 기존에 Popup Component가 로딩되어있지 않은경우 동적으로 로딩한다.
			var url = "/explan/include/popup/"+popupId+".jsp";
			appendUrlContent(url);
			// 화면에 로딩 되는 시간이 있어 바로 Show를 할 수 없어 로딩 될때까지 기다렸다가 Show함.
			var showFn = function() {
				setTimeout(function() {
					if($("#" + popupId).length > 0) {
						_SVC_POPUP.setConfig(popupId, {}, function(returnData) {});
						_SVC_POPUP.show(popupId);
					}
					else showFn();
				}, 200);
			}
			showFn();
		} else {
			_SVC_POPUP.setConfig(popupId, {}, function(returnData) {});
			_SVC_POPUP.show(popupId);
		}
	}
}

var _SVC_DHTMLX = {
	_GRID_ID_LIST : {},
	getSearchButtonToDhtmlx : function(insertStr, functionStr, btnClass) {
		if(btnClass == undefined) btnClass = "btn_search";
		if(isNumber(insertStr)) insertStr += "";
		if		(!isValid(insertStr)) insertStr = "&nbsp;";
		else if	(!isValid(insertStr.trim()) || insertStr.trim().length == 0) insertStr = "&nbsp;";
		return "<div class='form_wrap_ico'><span>" + insertStr + "</span><span class='btn_ico "+btnClass+"'><a href=\"javascript:" + functionStr + "\" title='Search'>Search</a></span></div>";
	},
	renewGridBox : function(gridId) {
		var gridTemplateId = gridId + "_tmp";
		if(_G_VAL[gridTemplateId] == undefined) {
			var fullHtml = $("#" +gridId).clone().wrapAll("<div/>").parent().html();
			_G_VAL[gridTemplateId] = fullHtml;
		} else {
			var fullHtml = _G_VAL[gridTemplateId];
			$("#" + gridId).wrapAll("<div/>");
			$("#" + gridId).attr("id", "__imsi_removeId");
			$("#__imsi_removeId").parent().append(fullHtml);
			$("#__imsi_removeId").remove();
			$("#" + gridId).unwrap();
		}
	},
	registAutoResize : function(gridId) {
		this._GRID_ID_LIST[gridId] = "Y";
	},
	// 창이 Resize될때 실행 된다.
	gridResizeAll : function() {
		$.each(this._GRID_ID_LIST, function(key, value) {
			_SVC_DHTMLX.gridResize(key);
		});
	},
	gridResize	: function(gridId) {
		var window_height = $(window).height();
		
		var gridInfo = explanGrid.getGrid(gridId);
		var sendParm = gridInfo.gridParm;
		var useAutoHeight = sendParm.useAutoHeight;
		if(useAutoHeight == undefined ) return;
		var ht = eval(window_height) - eval(useAutoHeight.margin);
		if(ht < 100) ht = 200;
		var setHeight = ht; 
		
		setHeight = setHeight + "px";
		
		$("#" + gridId).parent().css("height", setHeight);
		
	}
}

// AM Chart 관련 처리
var _SVC_CHART = {
	 includeFileMap	: {}
	,chartInfoList	: []
	,registChart	: function(chartParm) {
		this.chartInfoList.push(chartParm);
	 }
	,generate		: function() {
		$.each(_SVC_CHART.chartInfoList,function() {
			var chartData 	= this.chartData;
			var ready		= this.ready;
			AmCharts.ready(function(){
				ready(chartData);
			});
		});
	 }
}
/*
var chartParm = {
	 includeFileList 	: ["radar.js"]
   	,chartData 			: []
	,ready 				: function () {}
}
*/


// window resize event 처리
$(window).bind("resize", function() {
	_SVC_DHTMLX.gridResizeAll();
	_SVC_POPUP.popupResizeAll();
});