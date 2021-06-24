// 관련 Class Include
_SVC_COM.loadJsFile("/explan/js/class/C_INVESTMENT_GROUP.js");
_SVC_COM.loadJsFile("/explan/js/class/C_IMMOVABLE_GROUP.js"	);
_SVC_COM.loadJsFile("/explan/js/class/C_LOAN_GROUP.js"		);

// Cash Flow 관련 Class
var C_FINANCY_ANALYSIS = function(parmObj) {

	var planInfo = _SVC_COM.getPlanInfo(parmObj.planNum);
	
	this.planNum 		= parmObj.planNum;
	this.planDate 		= planInfo.START_DATE;
	
	this.investmentGroupByInfo 	= {};
	this.loanInfo 				= {};
	this.immovableInfo			= {};

	this.totalSum				= 0;
	this.orgTotalSum			= 0;
	this.init = function(planInfo) {
		/* investment Group by 해서 정보 만들기 */	

		// Investment List 읽어오기
		var parm = {
			 "sqlId" : "Investment.getInvestmentList"
			,"planNum" : parmObj.planNum
		}
		var gridInfo 			= requestService("GET_COMMON", parm);
		var jsonData 			= fn_changeKeyNamingJsonList(gridInfo.data);
		var jsonData 			= _SVC_COM.extendMethodToList(jsonData, _C_INVESTMENT_METHOD);
		var cInvestmentGroup	= new C_INVESTMENT_GROUP(jsonData, this.planDate);

		// 소수점 1자리까지 표현하는것으로 Setting.			
		cInvestmentGroup.setScale(10);
		
		this.investmentGroupByInfo 		= cInvestmentGroup.getSumGroupTitleInfo();
		
		// this.resultIvst = investmentGroupByInfo.resultTotal // 금융자산총액
		
		/* // investment Group by 해서 정보 만들기 */
		

		/* Loan List */	

		// Loan List 읽어오기
		var parm = {
			 "sqlId" : "Investment.getLoanList"
			,"planNum" : this.planNum
		}
		var gridInfo 	= requestService("GET_COMMON", parm);
		var jsonData 	= fn_changeKeyNamingJsonList(gridInfo.data);
		var jsonData 	= _SVC_COM.extendMethodToList(jsonData, _C_LOAN_METHOD);
		var cLoanGroup 	= new C_LOAN_GROUP(jsonData);
		this.loanInfo	= cLoanGroup.getLoanInfo(this.planDate);

		/* // Loan List */	
		
		/* Immovable List */
		
		// Immovable List 읽어오기
		var parm = {
			 "sqlId" 	: "Investment.getImmovableList"
			,"planNum" 	: this.planNum
		}

		var gridInfo 		= requestService("GET_COMMON", parm);
		var jsonData 		= fn_changeKeyNamingJsonList(gridInfo.data);
		var jsonData 		= _SVC_COM.extendMethodToList(jsonData, _C_IMMOVABLE_METHOD);
		var cImmovableGroup	= new C_IMMOVABLE_GROUP(jsonData, this.planDate);
		this.immovableInfo	= cImmovableGroup.getSubListGroupByType();
		
		/* // Immovable List */

		// 총계 처리
		this.totalSum		= Number(this.investmentGroupByInfo.resultTotal) + Number(this.immovableInfo.resultTotal);
		this.orgTotalSum	= this.totalSum - Number(this.loanInfo.principalTotal);
		this.totalSumStr	= makeMoneyStr(Math.round(this.totalSum		));
		this.orgTotalSumStr	= makeMoneyStr(Math.round(this.orgTotalSum	));
	}
	// 초기화 시작
	this.init();
	
	this.getInvestmentGroupByInfo = function() {
		return this.investmentGroupByInfo; 
	}
	this.getLoanInfo = function() {
		return this.loanInfo; 
	}
	this.getImmovableInfo = function() {
		return this.immovableInfo; 
	}
	this.getChartData = function() {
		var financyChartInfo 	= {};
		var investmentChartInfo	= {};
		var immovableChartInfo 	= {};
		
		// 금융자산 Chart Data 생성
		var groupList 	= this.investmentGroupByInfo.groupList		;
		var sumTotal 	= this.investmentGroupByInfo.resultTotal	;
		$.each(groupList, function() {
			var key = "";
			if		(in_array(this.investmentType, ["적금", "예금"	])) key = "적금/예금";
			else if	(in_array(this.investmentType, ["주식", "펀드"	])) key = "주식/펀드";
			else if	(in_array(this.investmentType, ["보험"			])) key = "보험";
			else if	(in_array(this.investmentType, ["기타"			])) key = "기타";
			if(!isValid(investmentChartInfo[key])) investmentChartInfo[key] = {cval:0,rate:0};
			investmentChartInfo[key].cval += Number(this.total);
		});
		var sumRate = 0;
		$.each(investmentChartInfo, function(key, obj) {
			investmentChartInfo[key].rate = fn_fix(investmentChartInfo[key].cval / sumTotal * 100, 1);
			sumRate += Number(investmentChartInfo[key].rate);
		});
		
		// 0.1 오차 보정
		if(fn_fix(sumRate, 1) == 99.9) {
			$.each(investmentChartInfo, function(key, obj) {
				if(investmentChartInfo[key].rate > 0) {
					investmentChartInfo[key].rate = fn_fix(investmentChartInfo[key].rate + 0.1, 1);
					return false;
				}
			});
		}
		financyChartInfo["금융자산"] = investmentChartInfo;
		
		//
		// 부동산 자산 ChartData 생성
		//
		var totalListGroupByType 	= this.immovableInfo.totalListGroupByType	;
		sumTotal 					= this.immovableInfo.resultTotal			;
		$.each(totalListGroupByType, function() {
			var key = this.immovableType;
			if(!isValid(immovableChartInfo[key])) immovableChartInfo[key] = {cval:0,rate:0};
			immovableChartInfo[this.immovableType].cval += Number(this.total);
		});
		sumRate = 0;
		$.each(immovableChartInfo, function(key, obj) {
			immovableChartInfo[key].rate = fn_fix(immovableChartInfo[key].cval / sumTotal * 100, 1);
			sumRate += Number(immovableChartInfo[key].rate);
			immovableChartInfo[key].cval = fn_fix(immovableChartInfo[key].cval, 1);
		});
		// 0.1 오차 보정
		if(fn_fix(sumRate, 1) == 99.9) {
			$.each(immovableChartInfo, function(key, obj) {
				if(immovableChartInfo[key].rate > 0) {
					immovableChartInfo[key].rate = fn_fix(immovableChartInfo[key].rate + 0.1, 1);
					return false;
				}
			});
		}
		financyChartInfo["부동산자산"] = immovableChartInfo;
		
		return financyChartInfo;
	}
};




