
// 투자상품 Method 
var _C_INVESTMENT_METHOD = {
	"getInvestmentTitle"	: 	function() {
									return this.investmentType;
								},
	"getRegularMoney"		: 	function() {
									return addComma(this.regularMoney);
								},
	"getBaseMoney"			: 	function() {
									return addComma(this.baseMoney);
								},
	"getStartDate"			: 	function() {
									return getDateFormat(this.startDate);
								},
	"getEndDate"			: 	function() {
									var endDate = getDateFormat(this.endDate);
									if( endDate == null) endDate = "";
									return endDate;
								},
	"getTerm"				: 	function() {
									return changeMonthToYearMonthStr(this.term); 
								},
	"getFutureListByMonth"	: 	function(targetDate) {
									return CInvestmentAPI.getFutureListByMonth(this, targetDate); 
								}
}


//투자 상품 그룹
var C_INVESTMENT_GROUP = function(investmentList, targetDate) {
	// 현재 재무 상태표 (금융자산 Template)
	this.stateListGroupByTitle 		= {};
	this.stateListGroupByTitleList 	= [];
	this.sourceTotal 				= 0;
	this.resultTotal 				= 0;
	this.regularTotal				= 0;
	this.flexTotal					= 0;
	this.scale						= 1;
	this.baseInvestmentList 		= investmentList;
	this.investmentList 			= [];
	
	var validList = [];

	$.each(investmentList, function() {
		if(!in_array(this.state, ["사용안함", "해지"])) {
			validList.push(this);
		}
	});
	this.investmentList	= validList;

	if(isValid(validList)) {
		// 현재 재무 상태표 (금융자산 Template) 처리
		var slgt 	= this.stateListGroupByTitle;
		var sourceTotal 	= 0;
		var resultTotal 	= 0;
		var regularTotal 	= 0;
		var flexTotal		= 0;

		$.each(validList, function() {
			// End Date 처리
			if(isValid(this.endTerm)) {
				this.endDate = getAddMonth(this.startDate, this.endTerm);
			} else {
				this.endDate = getAddMonth(this.startDate, this.term);
			}
			
			if(!isValid(slgt[this.investmentType])) {
				slgt[this.investmentType] = {
					"investmentType" 	: this.investmentType,
					"source" 			: 0,
					"total"				: 0
				};
			}
			var resultSet = this.getFutureListByMonth(targetDate);
			slgt[this.investmentType].source 				+= resultSet.sourceVal;
			sourceTotal										+= resultSet.sourceVal;
			slgt[this.investmentType].total 				+= resultSet.resultVal;
			resultTotal										+= resultSet.resultVal;
			slgt[this.investmentType].investmentTypeName 	 = this.investmentType;
			
			// 정기 투자금 합계
			regularTotal += Number(this.regularMoney);
			
			// 유동 자산 처리
			if(in_array(this.investmentType, ["예금", "적금"])) flexTotal += resultTotal;
			
		});

		this.sourceTotal 	= sourceTotal;
		this.resultTotal 	= resultTotal;
		this.regularTotal 	= regularTotal;
		this.flexTotal 		= flexTotal;
		this.stateListGroupByTitle = slgt;

		var slgtl 	= this.stateListGroupByTitleList;
		$.each(slgt, function(key, value) {
			var idx = slgtl.length;
			slgtl[idx] = value;
			slgtl[idx].investmentTypeName = slgtl[idx].investmentType;
		});
		
		this.stateListGroupByTitleList = slgtl;
	};
	this.getSumGroupTitleInfo = function() {
		var slgbtl 				= this.stateListGroupByTitleList;
		
		var cv1 = 10000 / this.scale;
		var cv2 = this.scale;
		
		$.each(slgbtl, function() {
			this.sourceStr 	= makeMoneyStr	(Math.round(this.source	/ cv1) / cv2);
			this.totalStr	= makeMoneyStr	(Math.round(this.total	/ cv1) / cv2);
			this.source 	= addComma		(Math.round(this.source	/ cv1) / cv2);
			this.total 		= addComma		(Math.round(this.total 	/ cv1) / cv2);
		});
		var sourceTotal 	= addComma(Math.round(this.sourceTotal 	/ cv1) / cv2);
		var resultTotal 	= addComma(Math.round(this.resultTotal 	/ cv1) / cv2);
		var flexTotal 		= addComma(Math.round(this.flexTotal 	/ cv1) / cv2);
		var regularTotal 	= addComma(Math.round(this.regularTotal	/ cv1) / cv2);
		
		var returnObj = {
			 groupList 		: slgbtl
			,sourceTotal 	: sourceTotal
			,resultTotal 	: resultTotal
			,regularTotal 	: regularTotal
			,flexTotal 		: flexTotal
			,sourceTotalStr	: makeMoneyStr(sourceTotal)
			,resultTotalStr	: makeMoneyStr(resultTotal)
		}
		return returnObj;
	};
	this.setScale = function(val) {
		if(val < 1) val = 1;
		this.scale = val;
	}
};
// 투자자산 관련 API
var CInvestmentAPI = {
	// 결과 Set Template
	"resultSet" : function() {
		// 중간 계산
		this.dataMap 		= {};
		// 만기 적립금
		this.resultVal 		= {};
	},
	// 월별 추정 자산 리스트
	"getFutureListByMonth" : function(investmentObj, targetDate) 		{
		
		var parmObj = investmentObj;
		
		if(!isValid(parmObj.term) ||  parmObj.term == 0 ) {
			parmObj.term = parmObj.endTerm
		}
		parmObj.endDate = targetDate;
		var resultSet = {};

		if		(parmObj.interestType == "단리"		) resultSet = this.calInvestmentSimpleOfMonth(parmObj);
		else if(parmObj.interestType == "연복리"	) resultSet = this.calInvestmentCompoundOfYear(parmObj);
		else if(parmObj.interestType == "월복리"	) resultSet = this.calInvestmentCompoundOfMonth(parmObj);

		return resultSet;
	},
	// 단리 계산
	"calInvestmentSimpleOfMonth" : function (parmObj) {
		var baseMoney   	= getInitValue(parmObj.baseMoney	, 0);
		var regularMoney 	= getInitValue(parmObj.regularMoney	, 0);
		var startDate      	= parmObj.startDate   ;
		var endDate        	= parmObj.endDate     ;
		var term        	= getInitValue(parmObj.term			, 0);
		var rate           	= getInitValue(parmObj.interestRate	, 0);

		if(!isValid(startDate)) return null; 
		if(!isValid(endDate)) return null; 
		
		var payEndDate		= endDate;
		if(term > 0 ) payEndDate = getAddMonth(startDate, term);
		
		var targetCount 	= term;
		var targetMonth 	= getDistanceMonth(startDate, endDate);

		// 결과 Set
		var resultSet = new this.resultSet();
		resultSet.startDate 	= startDate	;
		resultSet.payEndDate 	= payEndDate;
		resultSet.endDate 		= endDate	;
		
		var interest = 0;
		source = 0;

		var yyyymm = startDate.substring(0, 6);
		resultSet.dataMap[yyyymm] = baseMoney;

		for(var i=0;i< targetMonth;i++)
		{
			if (i < targetCount) source += Number(regularMoney);
			interest += (baseMoney + source) * this.getTransRate(rate);
			yyyymm = getAddMonth(startDate, i + 1, 6);
			resultSet.dataMap[yyyymm] = baseMoney + source + interest;
		}
		resultSet.dataMap[endDate.substring(0, 6)] = baseMoney + source + interest;
		resultSet.sourceVal 	= baseMoney + source;
		resultSet.interestVal 	= interest;
		resultSet.resultVal 	= baseMoney + source + interest;
		
		return resultSet;
	},
	// 연복리
	"calInvestmentCompoundOfYear" : function(parmObj) {
		var baseMoney   	= getInitValue(parmObj.baseMoney	, 0);
		var regularMoney 	= getInitValue(parmObj.regularMoney	, 0);
		var startDate      	= parmObj.startDate   ;
		var endDate        	= parmObj.endDate     ;
		var term        	= getInitValue(parmObj.term			, 0);
		var rate           	= getInitValue(parmObj.interestRate	, 0);
		
		if(!isValid(startDate)) return null; 
		if(!isValid(endDate)) return null; 
		
		var payEndDate		= endDate;
		if(term > 0 ) payEndDate = getAddMonth(startDate, term);

		var targetCount 	= getDistanceMonth(startDate, payEndDate);
		var targetMonth 	= getDistanceMonth(startDate, endDate);
		
		// 결과 Set
		var resultSet = new this.resultSet();
		resultSet.startDate 	= startDate	;
		resultSet.payEndDate 	= payEndDate;
		resultSet.endDate 		= endDate	;
		
		var interest = 0;
		source = 0;
		var yearIntrest = 0;

		var yyyymm = startDate.substring(0, 6);
		resultSet.dataMap[yyyymm] = baseMoney;

		for(var i=0;i< targetMonth;i++)
		{
			if (i < targetCount) source += regularMoney;
			interest += (baseMoney + source + yearIntrest) * this.getTransRate(rate);
			yyyymm = getAddMonth(startDate, i + 1, 6);
			resultSet.dataMap[yyyymm] = (baseMoney + source) + interest;
			if( (i != 0) && ((i + 1) % 12) == 0 ) {
				yearIntrest = interest;
			}
		}
		resultSet.dataMap[endDate.substring(0, 6)] = baseMoney + source + interest;
		resultSet.sourceVal 	= baseMoney + source;
		resultSet.interestVal 	= interest;
		resultSet.resultVal 	= baseMoney + source + interest;
		
		return resultSet;
	},
	// 월 복리
	"calInvestmentCompoundOfMonth" : function (parmObj)
	{
		var baseMoney   	= getInitValue(parmObj.baseMoney	, 0);
		var regularMoney 	= getInitValue(parmObj.regularMoney	, 0);		
		var startDate    	= parmObj.startDate   					;
		var endDate      	= parmObj.endDate     					;
		var term        	= getInitValue(parmObj.term			, 0);
		var preFee 			= getInitValue(parmObj.preFee		, 0);		// 선취
		var afterPreFee		= getInitValue(parmObj.afterPreFee	, 0);		// 년후
		var preFee2			= getInitValue(parmObj.preFee2		, 0);		// 년후선취
		var normalFee 		= getInitValue(parmObj.normalFee	, 0);		// 1년 운영
		var rate         	= getInitValue(parmObj.interestRate	, 0);		
		
		if(!isValid(startDate)) return null; 
		if(!isValid(endDate)) return null; 

		var payEndDate		= endDate;
		
		if(term > 0 ) payEndDate = getAddMonth(startDate, term);

		var targetMonth   	= getDistanceMonth(startDate, endDate);

		var monthPreFee 	= afterPreFee * 12;
		// 결과 Set
		var resultSet = new this.resultSet();
		resultSet.startDate 	= startDate	;
		resultSet.payEndDate 	= payEndDate;
		resultSet.endDate 		= endDate	;

		var investmentSource 	= baseMoney;
		var orgSource			= baseMoney;
		var interest			= 0;

		var applyRate = this.getTransRate(rate - normalFee);
		
		var yyyymm = startDate.substring(0, 6);
		resultSet.dataMap[yyyymm] = investmentSource;
		
		for(var i=0;i< targetMonth;i++)
		{
			if (monthPreFee > 0 && monthPreFee < (i + 1)) preFee = preFee2;
			if(term > i){
				investmentSource += (regularMoney - (regularMoney * (preFee / 100)));
				orgSource		 += regularMoney;
			}
			interest += investmentSource * applyRate;

			var yyyymm = getAddMonth(startDate, i + 1, 6);
			resultSet.dataMap[yyyymm] = investmentSource + interest;
		}
		resultSet.resultVal 		= investmentSource + interest;
		resultSet.sourceVal 		= orgSource;
		resultSet.interestVal 		= interest;
		resultSet.investmentSource 	= investmentSource;
		return resultSet;
	},
	// 연 이율을 월 복리 이율로 환산하기
	"getTransRate" : function (rate, type) {
		if(type == undefined) type = 1;
		if(type == 1) {
			return rate / 100 / 12;
		} else if(type == 2){
			rate /= 100;
			return Math.pow((rate + 1), 1/12) - 1;
		} else return rate / 100 / 12;
	},
	// 미래가치구하기
	"getFutureValue" : function (needMoneyBase, inflation, term, scale)
	{
		if(scale < 1) scale = 1;
		
		result = Math.round(needMoneyBase * Math.pow( (1 + inflation), term) / scale) * scale;
		
		return result;	
	}
};
//var parmObj = {
////	baseMoney 		: 1000000,
//	regularMoney	: 100000,
//	startDate   	: "20010101",
//	term	     	: "12",
//	endDate     	: "20030101",
//	interestRate   	: 1,
//	preFee			: 10
//};
//$(function() {
////	debug(CInvestmentAPI.calInvestmentSimpleOfMonth(parmObj)); // 단리
////	debug(CInvestmentAPI.calInvestmentCompoundOfYear(parmObj));	// 연복리
//	debug(CInvestmentAPI.calInvestmentCompoundOfMonth(parmObj)); // 월복리
//});
