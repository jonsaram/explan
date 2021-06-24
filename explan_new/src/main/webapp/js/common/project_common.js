	// Service 여러개 동시 호출
	function requestServiceMulti(jsonParam, callback) {
		if(Object.prototype.toString.call(jsonParam) == "[object Object]") {
			var parm = {
				 targetUrl	: "/explan/ajaxRequest.do"
				,jsonData 	: jsonParam
				,callback 	: callback
			}
			var resultData = ajaxRequest(parm);	
			return resultData;
		} else {
			alert('jsonParam이 Object형이 아닙니다.');
			return null;
		}
	}
	
	// Service 1개만 호출하는 경우
	// type : 	undefined => 서버에서 읽음 캐쉬삭제.
	// 		  	"C" => 서버에서 읽고 cache에 저장.
	//			"R" => 캐쉬에서 읽고, 캐쉬가 없을경우 "C"와 동일하게 동작.
	function requestService(serviceName, parm, type) {
		if(parm == undefined) parm = {};
		if(type == "R") {
			if(_G_VAL["CACHE"][serviceName] != undefined) return _G_VAL["CACHE"][serviceName];
			else type = "C";
		}
		// 서비스 요청 정보 생성
		var requestParm = makeRequestParm(serviceName, parm);
		// Sync 형 Service
		var result = requestServiceMulti(requestParm);
		
		if(!isValid(result[serviceName],1)) {
			alert('System Error!!');
			return null;
		}
		
		// type 이 C인경우 캐쉬에 저장
		if(type == "C") _G_VAL["CACHE"][serviceName] = result[serviceName];
		else			_G_VAL["CACHE"][serviceName] = undefined;
		
		return result[serviceName];
	}
	// 
	function requestServiceByForm(serviceName, formName, callback) {
		
		if($("#" + formName).length == 0) return null;
		
		if($("#__serviceName").length == 0)	$("#" + formName).append("<input type=hidden id=__serviceName name=__serviceName value='"+serviceName+"'/>");
		
		$("#" + formName).attr("action", "/explan/ajaxRequest.do");
		
		return ajaxSubmit(formName, callback);	
		
	}
	
	
	
	// Service 호출 전에 Service 요청 Parameter 객체 생성.
	function makeRequestParm(serviceName, parm) {
		if(parm == undefined) parm = {};
		var result = fn_jsonClone(_AJAX_REQUEST_TEMPLATE);
		result.put = _AJAX_REQUEST_TEMPLATE.put;
		result.put(serviceName, parm);
		return result;
	}
	
	// Service를 추가 Parameter
	// config.js 에 정의 되어있는 _AJAX_REQUEST_TEMPLATE.put 에서 호출
	function makeServiceParm(serviceName, parm) {
		var serviceParm = fn_jsonClone(_SERVICE_PARM);
		serviceParm.serviceName = serviceName;
		serviceParm.sendParam 	= parm;
		return serviceParm;
	}
	
	// 전역 스토리지에 정보 저장
	function saveSessionData(sessionId, sessionData)
	{
		if(	Object.prototype.toString.call(sessionData) == '[object Object]' || 
			Object.prototype.toString.call(sessionData) == '[object Array]'  )
		{
			sessionData = JSON.stringify(sessionData)
		}
		if(window.sessionStorage) 	sessionStorage.setItem(sessionId, sessionData);
		else						setCookie(sessionId, sessionData);
	}
	// 전역 스토리지에서 정보 읽기
	function loadSessionData(sessionId, valid)
	{
		var result;
		if(window.sessionStorage) 	result = sessionStorage.getItem(sessionId);
		else						result = getCookie(sessionId);

		if(valid == true) window.deleteSessionData(sessionId);
		try {
			var retObj = JSON.parse(result);
			return retObj;
		} catch (e) {
			return result;
		}
	}
	function deleteSessionData(sessionId)
	{
		if(this.sessionValid) 	sessionStorage.removeItem(sessionId);
		else					setCookie(sessionId, "");
	}
	// 공통 세션 등록
	function setCommonSession(id, value) {
		_SESSION = loadSessionData("_SESSION");
		if(!isValid(_SESSION,1)) _SESSION = {};
		_SESSION[id] = value;
		saveSessionData("_SESSION", _SESSION);
	}
	// Page 호출
	function movePage(pageId, parm, targetId) {
		if(parm != undefined) {
			saveSessionData(pageId, parm);
		}
		initHiddenForm();
		document.hiddenNewWindow.action 		= "/explan/movePage.do";
		document.hiddenNewWindow.pageId.value 	= pageId;
		if(targetId != undefined) document.hiddenNewWindow.target 		= targetId;
		document.hiddenNewWindow.submit();
	}
	// Open Page
	function windowOpenPage(pageId, parm) {
		window.open("about:blank", pageId, "width=1120,height=800,scrollbars=yes");
		movePage(pageId, parm, pageId);
	}
	// Page 정보 가져오기
	function getPageParam(delectCheck, targetId) {
		var pageId = PAGE_ID;
		if(targetId != undefined) pageId = targetId;
		if(delectCheck == undefined) delectCheck = true;
		var parm = loadSessionData(pageId, delectCheck);
		if(parm == undefined || parm == null) 	parm = _G_VAL[pageId];
		else									_G_VAL[pageId] = parm;
		return parm;
	}

	//파일 업로드
	function showFileUpload(docid, defaultFileSize)
	{
		if(docid 			== undefined) docid 			= "";
		if(defaultFileSize 	== undefined) defaultFileSize 	= "0";
		
		saveSessionData("FILEUPLOAD_FORM", defaultFileSize);
		
		var theURL = "/servlet/modelo.common.servlet.MainServlet?pageId=FILEUPLOAD_FORM&docid=" + docid;
		var retVal = window.showModalDialog(theURL, "pop", "dialogWidth:445px;dialogHeight:335px;scroll:no;status:no;resizable:no;toolbar:no;location:no");
		return retVal;
	}
	
	/**
	 * 날짜 검색 관련 함수
	 */
	
	function resetDate() {
		$("#startDate").val("");	
		$("#endDate").val("");	
	}
	function resetSearch() {
		fn_setSelectBox("productGroupList", "");
		$("#productGroupList").trigger("change");
		initSearchDate();
		_COMPONENT.clearMultiInputBox("PROJECT_CODE");
		_COMPONENT.clearMultiInputBox("PROJECT_NAME");
	}
	function initSearchDate() {
		myCalendar = new dhtmlXCalendarObject(["startDate","endDate"]);		
		
		var startDate 	= getAddMonth(getToday(), -3).toDateStr();
		var endDate 	= getToday(8, "-");
		$("#startDate").val(startDate);
		$("#endDate").val(endDate);
	}

	function getViewTitle(colId) {
		var tit = _SVC_COM.getWordListMap()[colId];
		if(tit == undefined) 	return colId;
		else					return tit;
		
	}

	function progressBarExec(id, fn) {
		progressBarShow(id);
		setTimeout(function() {
			fn();
			progressBarHide(id);
		}, 200);
	}

	//Lading Image
	var progressDiabled = false;
	function progressBarShow(forceCode)
	{
		if(_G_VAL["pbarCheck"] == undefined && forceCode != undefined) _G_VAL["pbarCheck"] = {forceCode : forceCode} 

		var obj = $("#contents").offset();
		
		//$("#loading").css("left" , obj.left);
		
		var window_height = $(window).height();
		var window_with = $(window).width();
		
		var m_top = window_height / 2;
		var m_left = window_with / 2;
	
		$("#loading_image").css("top" , m_top)
		$("#loading_image").css("left" , m_left)
		
		if(!progressDiabled) $("#loading").show();
	}
	
	function progressBarHide(forceCode)
	{
		if(_G_VAL["pbarCheck"] == undefined || _G_VAL["pbarCheck"].forceCode == forceCode || forceCode == "FORCE") {
			$("#loading").hide();
			_G_VAL["pbarCheck"] = undefined;
		} 
	}
	
	function execDelay(fn, delayTime) {
		if(_G_VAL["delayCheck"] != undefined) {
			_G_VAL["delayCheck"] = 2;
			return;
		}
		_G_VAL["delayCheck"] = 1;
		fn();
		setTimeout(function() {
			if(_G_VAL["delayCheck"] == 2) fn();
			_G_VAL["delayCheck"] = undefined;
		},delayTime);
	}

	// url의 내용을 Target Id에 Load한다.
	function appendUrlContent(url, targetId) {
		if(!isValid(targetId)) targetId = "contents";
		$.get(url, {}, function(data) {
			$("#" + targetId).append(data);
		});
	} 

	// 초기값 설정
	function getInitValue(targetVar, initValue) {
		if(!isValid(targetVar)) return initValue;
		else					return Number(targetVar);
	}

	
	// 부채 상환액 계산
	// source : 원단위
	// rate : 월 이율
	// term : 개월수 
	// whatPast : 개월수
	function loanReturn(source, rate, guchiTerm, term, whatPast, loanType)
	{
		rate = rate / 100 / 12;
		var interest = 0;
		var interestTotal = 0;
		var orgSource = source;
		var returnSource = 0;
		var result = new Array();
		result[0] = 0;
		result[1] = 0;
		result[2] = 0;
		result[3] = source;
		result[4] = 0;
		result[5] = 0;
		result[6] = 0;
		result[7] = source;
		var prePayBack = 0;
		
		if (loanType == "D")
		{
			loanType = "A";
			term = guchiTerm + term;
			guchiTerm = 0;

		}

		if( (term == 0 || term == "") && loanType != "A" ) return result;

		if(whatPast < 0 ) whatPast = 0;
		if(guchiTerm == "") guchiTerm = 0;
		
		if(guchiTerm > whatPast || loanType == "A")
		{
			result[0] = source * rate;
			result[1] = result[0] * term;
			result[3] = source;
			result[4] = result[0] * whatPast;
			result[5] = result[0];
		} 
		prePayBack = source * rate * guchiTerm;
	 	whatPast = whatPast - guchiTerm;
		if (loanType == "B")
		{
			var returnSourceInterest = 0;
			if( (Math.pow((1+rate), term) - 1) > 0 ) returnSourceInterest = source * rate * Math.pow((1+rate), term) / (Math.pow((1+rate), term) - 1);
			else returnSourceInterest = source / ( term - guchiTerm);
			for(i=0;i<term ;i++)
			{
				interest = orgSource * rate;
				interestTotal += interest;
				returnSource = returnSourceInterest - interest;
				orgSource = orgSource - returnSource;
				if(i == (whatPast - 1))
				{
					result[2] = source - orgSource; 	// 지금까지 낸 원금
					result[3] = orgSource;				// 남은 금액
					result[4] = interestTotal + prePayBack;			// 지금까지 낸 이자
					result[5] = orgSource * rate;		// 현재 이자
				}
					
			}
			if(whatPast >= 0) result[0] = returnSourceInterest;	// 원리금 균등상환 1회 상환금
			result[1] = interestTotal + prePayBack;			// 총 이자
		}
		else if (loanType == "C")
		{
			returnSource = source / term;
			result[5] = orgSource * rate; 		// 현재 이자
			
			for(i=0;i<term ;i++)
			{
				
				interest = orgSource * rate;
				interestTotal += interest;
				orgSource = orgSource - returnSource;
				if(i == (whatPast - 1))
				{
					result[2] = source - orgSource; 	// 지금까지 낸 원금
					result[3] = orgSource;				// 남은 금액
					result[4] = interestTotal + prePayBack;			// 지금까지 낸 이자
					result[5] = orgSource * rate; 		// 현재 이자
				}
					
			}
			if(term != 0 && whatPast >= 0) result[0] = source / term + eval(result[5]);	// 원금 균등상환 현재 1회 상환금
			result[1] = interestTotal + prePayBack;			// 총 이자
		}
		result[6] = result[0] - result[5];

		if (result[0] + "" == "NaN") result[0] = 0;
		if (result[1] + "" == "NaN") result[1] = 0;
		if (result[2] + "" == "NaN") result[2] = 0;
		if (result[3] + "" == "NaN") result[3] = 0;
		if (result[4] + "" == "NaN") result[4] = 0;
		if (result[5] + "" == "NaN") result[5] = 0;

		return result;
	}

	function initHiddenForm() {
		$("#hiddenForm").empty();
		var renderHtml = $("#hiddenForm_template").render();
		$("#hiddenForm").html(renderHtml);
	}
	
	function addRowClass(docId, className, addClassLine) {
		$("#" + docId + " table").each(function() {
			if(isNumber(addClassLine)) {
				$(this).find("tr").each(function() {
					var pos = 0;
					$(this).find("td,th").each(function() {
						var colspan = $(this).attr("colspan");
						if(isNumber(colspan))	pos = pos + Number(colspan);
						else					pos++;
						if(addClassLine == pos) {
							$(this).addClass(className);
							return false;
						}
					});
				});
			}
		});
	}
	
	// jsrender 사용자 정의 함수
	$.views.converters({
		 // DateFormat 
		dt : function(value) {return getDateFormat(value, 8);}								//YYYY-MM-dd HH:mm:ss
	});
	