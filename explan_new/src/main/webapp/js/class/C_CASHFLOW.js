// 관련 Class Include
_SVC_COM.loadJsFile("/explan/js/class/C_INVESTMENT_GROUP.js");
_SVC_COM.loadJsFile("/explan/js/class/C_LOAN_GROUP.js"		);


// Cash Flow 관련 Class
var C_CASHFLOW = function(parmObj) {
	
	var pthis = this;

	var planInfo = _SVC_COM.getPlanInfo(parmObj.planNum);
	
	this.planNum 			= parmObj.planNum;
	this.planDate 			= planInfo.START_DATE;
	this.incomeList			= [];
	this.incomeMap			= {};
	this.consumeList		= [];
	this.consumeMap			= {};
	this.restTotal			= 0;
	this.incomeTotal 		= 0;
	this.consumeTotal 		= 0;
	this.insuranceTotal		= 0;
	
	this.consumeGubunList = [
		 { type : "CF", title : "고정지출"					,total : 0}
		,{ type : "CV", title : "변동지출"					,total : 0}
		,{ type : "CY", title : "월 평균연지출(연지출/12)"	,total : 0}
	];
	this.consumeGubunMap = {};
	
	// 저축성 지출 / 소비성지출 지출 
	this.consumeTypeMap = {};
	this.consumeTypeMap["저축성지출"] 	= 0;
	this.consumeTypeMap["소비성지출"] 	= 0;
	this.consumeTypeMap["잉여자금"] 	= 0;
	
	// 부채
	this.cashflowMap 	= {};
	
	// Cashflow List 읽어오기
	var parm = {
		 "sqlId" 	: "Investment.getCashflowList"
		,"planNum" 	: this.planNum
	}
	var gridInfo 		= requestService("GET_COMMON", parm);
		
	var cashflowList 	= gridInfo.data;
		
	$.each(cashflowList, function() {
		var key 			= this.ITEM_TYPE + this.ITEM_NAME;
		pthis.cashflowMap[key] 	= this.ITEM_VALUE;
	});

	// 저축 투자금액 Setting
	// Investment List 읽어오기
	var parm = {
		 "sqlId" 	: "Investment.getInvestmentList"
		,"planNum" 	: this.planNum
	}
	var gridInfo 			= requestService("GET_COMMON", parm);
	var jsonData 			= fn_changeKeyNamingJsonList(gridInfo.data);
	var jsonData 			= _SVC_COM.extendMethodToList(jsonData, _C_INVESTMENT_METHOD);
	var cInvestmentGroup	= new C_INVESTMENT_GROUP(jsonData, this.planDate);
	var investmentInfo 		= cInvestmentGroup.getSumGroupTitleInfo();
	
	this.cashflowMap["CF저축/투자"]= investmentInfo.regularTotal;
	this.consumeTypeMap["저축성지출"] += Number(investmentInfo.regularTotal);

	// 부채 상환금액 Setting
	// Loan List 읽어오기
	var parm = {
		 "sqlId" 	: "Investment.getLoanList"
		,"planNum" 	: this.planNum
	}
	var gridInfo 	= requestService("GET_COMMON", parm);
	var jsonData 	= fn_changeKeyNamingJsonList(gridInfo.data);
	var jsonData 	= _SVC_COM.extendMethodToList(jsonData, _C_LOAN_METHOD);
	var cLoanGroup 	= new C_LOAN_GROUP(jsonData);
	var loanInfo 	= cLoanGroup.getLoanInfo(this.planDate);
	
	this.cashflowMap["CF대출상환금"] 	 	 = loanInfo.paybackTotal;

	this.consumeTypeMap["저축성지출"] 	+= Number(loanInfo.paybackPrincipalTotal);
	
	
	// 보험 금액 읽어오기
	var cInsuranceGroup = _SVC_INSURANCE.makeInsuranceGroup(this.planNum);
	this.cashflowMap["CF보험료"] = fn_fix(cInsuranceGroup.allTotal.PAY_EACH_MONTH/10000, 1);
	
	this.insuranceTotal		= cInsuranceGroup.allTotal.PAY_EACH_MONTH;

	this.incomeList = [
  		 {ITEM_NAME : "근로소득", ITEM_VALUE : "", ITEM_TYPE : "IL"}
  		,{ITEM_NAME : "사업소득", ITEM_VALUE : "", ITEM_TYPE : "IL"}
  		,{ITEM_NAME : "임대소득", ITEM_VALUE : "", ITEM_TYPE : "IL"}
  		,{ITEM_NAME : "연금소득", ITEM_VALUE : "", ITEM_TYPE : "IL"}
  		,{ITEM_NAME : "금융소득", ITEM_VALUE : "", ITEM_TYPE : "IL"}
  		,{ITEM_NAME : "기타소득", ITEM_VALUE : "", ITEM_TYPE : "IL"}
  	];

  	$.each(this.incomeList, function(idx) {
 		var key = this.ITEM_TYPE + this.ITEM_NAME;
 		this.ITEM_VALUE = pthis.cashflowMap[key];
  		if(!isValid(this.ITEM_VALUE)) return true;
  		this.itemValueStr	 = addComma(this.ITEM_VALUE);
  		pthis.incomeTotal 	+= Number(this.ITEM_VALUE);
  	});
  	
  	this.consumeList = [
         {ITEM_NAME : "저축/투자"						,ITEM_VALUE : "" ,ITEM_TYPE : "CF" ,ITEM_GUBUN : "고정지출"	, readonly : "YH", "fontColor" 		: _COLOR_CODE["저축성"]}
        ,{ITEM_NAME : "대출상환금"		                ,ITEM_VALUE : "" ,ITEM_TYPE : "CF" ,ITEM_GUBUN : "고정지출"	, readonly : "Y" , "partFontColor" 	: _COLOR_CODE["저축성"], "paybackPrincipalTotalStr" : loanInfo.paybackPrincipalTotalStr, "paybackInterestTotalStr" : loanInfo.paybackInterestTotalStr}
        ,{ITEM_NAME : "보험료"                          ,ITEM_VALUE : "" ,ITEM_TYPE : "CF" ,ITEM_GUBUN : "고정지출"	, readonly : "Y"}
        ,{ITEM_NAME : "공과금"                          ,ITEM_VALUE : "" ,ITEM_TYPE : "CF" ,ITEM_GUBUN : "고정지출"}
        ,{ITEM_NAME : "관리비"                          ,ITEM_VALUE : "" ,ITEM_TYPE : "CF" ,ITEM_GUBUN : "고정지출"}
        ,{ITEM_NAME : "월세"                            ,ITEM_VALUE : "" ,ITEM_TYPE : "CF" ,ITEM_GUBUN : "고정지출"}
        ,{ITEM_NAME : "기타"                            ,ITEM_VALUE : "" ,ITEM_TYPE : "CF" ,ITEM_GUBUN : "고정지출"}
        ,{ITEM_NAME : "계"                              ,ITEM_VALUE : "" ,ITEM_TYPE : "CF" ,ITEM_GUBUN : "고정지출"	, readonly : "Y", sumType : "A"}
        ,{ITEM_NAME : "생활/가전비"                     ,ITEM_VALUE : "" ,ITEM_TYPE : "CV" ,ITEM_GUBUN : "변동지출"}
        ,{ITEM_NAME : "식비/외식비/접대비"              ,ITEM_VALUE : "" ,ITEM_TYPE : "CV" ,ITEM_GUBUN : "변동지출"}
        ,{ITEM_NAME : "교통/통신비"                     ,ITEM_VALUE : "" ,ITEM_TYPE : "CV" ,ITEM_GUBUN : "변동지출"}
        ,{ITEM_NAME : "문화/교육비"                     ,ITEM_VALUE : "" ,ITEM_TYPE : "CV" ,ITEM_GUBUN : "변동지출"}
        ,{ITEM_NAME : "경조사비"                        ,ITEM_VALUE : "" ,ITEM_TYPE : "CV" ,ITEM_GUBUN : "변동지출"}
        ,{ITEM_NAME : "세금(수도/전기/가스 등)"   		,ITEM_VALUE : "" ,ITEM_TYPE : "CV" ,ITEM_GUBUN : "변동지출"}
        ,{ITEM_NAME : "기타"                            ,ITEM_VALUE : "" ,ITEM_TYPE : "CV" ,ITEM_GUBUN : "변동지출"}
        ,{ITEM_NAME : "계"                              ,ITEM_VALUE : "" ,ITEM_TYPE : "CV" ,ITEM_GUBUN : "변동지출"	, readonly : "Y", sumType : "A"}
        ,{ITEM_NAME : "세금(재산세/자동차세 등)"        ,ITEM_VALUE : "" ,ITEM_TYPE : "CY" ,ITEM_GUBUN : "연지출"}
        ,{ITEM_NAME : "휴가비"                          ,ITEM_VALUE : "" ,ITEM_TYPE : "CY" ,ITEM_GUBUN : "연지출"}
        ,{ITEM_NAME : "명절(추석/설 등) 비용"           ,ITEM_VALUE : "" ,ITEM_TYPE : "CY" ,ITEM_GUBUN : "연지출"}
        ,{ITEM_NAME : "기타(의류,신발 등)"              ,ITEM_VALUE : "" ,ITEM_TYPE : "CY" ,ITEM_GUBUN : "연지출"}
        ,{ITEM_NAME : "총합"			                ,ITEM_VALUE : "" ,ITEM_TYPE : "CY" ,ITEM_GUBUN : "연지출"	, readonly : "Y", sumType : "B"}
        ,{ITEM_NAME : "월평균연지출(연지출/12)"         ,ITEM_VALUE : "" ,ITEM_TYPE : "CY" ,ITEM_GUBUN : "연지출"	, readonly : "Y", sumType : "C"}
  	];
  	var midTotal = 0;
  	
  	var totalIdx = 0;
  	
  	var tmpGubunList = this.consumeGubunList;
  	$.each(this.consumeList, function(idx) {
  		var key = this.ITEM_TYPE + this.ITEM_NAME;
  		this.ITEM_VALUE	 = pthis.cashflowMap[key];
  		
		if(isValid(this.sumType)) {
			// 고정지출, 변동지출, 년단위 지출에 대해 따로 저장
			if		  (this.sumType == "A") {
				this.ITEM_VALUE 	= midTotal;
				tmpGubunList[totalIdx++].total = midTotal;
				pthis.consumeTotal += midTotal;
				midTotal = 0;
				this.style = "color:#BB0000;background:" + _COLOR_CODE["계"];
			} else if(this.sumType == "B") {
				this.ITEM_VALUE 	= midTotal;
				this.style = "color:#0000BB;background:" + _COLOR_CODE["총합"];
			} else if(this.sumType == "C") {
				midTotal = fn_fix(midTotal / 12);
				tmpGubunList[totalIdx++].total = midTotal;
				this.ITEM_VALUE 	= midTotal;
				pthis.consumeTotal += midTotal;
				this.style = "color:#BB0000;background:" + _COLOR_CODE["계"];
			}
		} else {
	  		if(!isValid(this.ITEM_VALUE)) return true;
			midTotal 	 += Number(this["ITEM_VALUE"]);
		}
  		this.itemValueStr = addComma(this.ITEM_VALUE);
  	});
  	// ITEM GUBUN 별 백분율 구하기
  	$.each(this.consumeGubunList, function() {
  		this.rate = fn_fix(this.total / pthis.consumeTotal * 100, 1) + "%";
  	});
  	this.consumeGubunMap = arrayToMap(this.consumeGubunList, "type");
  	
  	// 백분율 Setting
  	$.each(this.consumeList, function(idx) {
  		this.rate = pthis.consumeGubunMap[this.ITEM_TYPE].rate;
  	});

  	var restTotal = fn_fix(Number(this.incomeTotal) - Number(this.consumeTotal), 1);
  	
  	this.consumeTypeMap["저축성지출"] 	= fn_fix(this.consumeTypeMap["저축성지출"], 1);
  	this.consumeTypeMap["소비성지출"] 	= fn_fix(this.consumeTotal - this.consumeTypeMap["저축성지출"], 1);
  	this.consumeTypeMap["잉여자금"] 	= fn_fix(restTotal, 1);

  	// 잉여자금 Settimg
  	this.restTotal = restTotal;
  	
  	this.getIncomeTotal = function() {
  		return makeMoneyStr(this.incomeTotal);
  	};
  	this.getConsumeTotal = function() {
  		return makeMoneyStr(this.consumeTotal);
  	};
  	this.getRestTotal = function() {
  		return makeMoneyStr(this.restTotal);
  	};
};




