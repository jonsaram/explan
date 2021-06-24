// 전역 변수
// System에서 사용하는 모든 전역 변수는 이 변수에서 관리된다.
// 주로 Page 이동시 전달되는 Parameter를 담는데 사용한다.
var _G_VAL = {};

// 캐쉬를 전역으로 사용
_G_VAL["CACHE"] = {};

// 전역 함수 Template
var _T_FN = {};
//전역 함수
var _G_FN = {};
// SESSION 변수
var _SESSION = {};
//DD LIST MAP
var _DD_MAP = {};
//DD CODE MAP
var _DD_CODE_MAP = {};

// 초기 Page가 Loading이 끝났는지 Check
var _PAGE_LOAD_CHECK = false;

// AJAX 요청 Service 구조
var _SERVICE_PARM = {
	 "serviceName" 	: ""
	,"sendParam"		: {}
};

// AJAX 요청 PARAMETER 구조
var _AJAX_REQUEST_TEMPLATE = {
	 "serviceList" 	: []
	,"put"			: function(serviceName, parm) {
		this.serviceList[this.serviceList.length] = makeServiceParm(serviceName, parm); 
	}
}

// word management 사용시( word.js에 정의 )
var _COMMON_WORD_MAP 	= {};

var _WORD_LIST_MAP 		= {};

// Grid Data 없음 메시지
var _NO_DATA_STR = "Data Not Found!";

//VALID 처리 결과 TEMPLATE
var _VALID_RESULT_TEMPLATE = {
	 "valid" 	: true
	,"header"	: ""
	,"position"	: []
	,"msg"		: ""
	,"getMsg"	: function() {
		var returnVal = "";
		var r = eval(this.position[0] + 1);
		var c = getViewTitle(this.position[1]);
		returnVal = r + "번째 열의 '" + c + "'항목을 확인하세요."; 
		if(isValid(this.msg)) {
			returnVal += "\n\n" + this.msg;
		}
		return returnVal;
	}
}

var _LOAN_TYPE_MAP = {
	 "만기일시상환" 	: "A"
	,"원리금균등상환" 	: "B"
	,"원금균등상환" 	: "C"
	,"자유상환" 		: "D"
}

var _COLOR_CODE = {
	 "계" 		: "#CCCCF0"
	,"총합" 	: "#F0F0F0"
	,"저축성" 	: "#00BB00"	
}