/**
 * 보험 관련 서비스
 */ 
var _SVC_INSURANCE = {
	makeInsuranceGroup : function (planNum, cInsuranceCompareGroup) {
		// 서비스 요청
		var resultInfo = requestService("GET_INSURANCE_LIST", {"planNum" : planNum});
		var jsonData = {};
		resultInfo.data;

		// 비교 대상이 있을 경우
		if(cInsuranceCompareGroup != undefined) {
			$.each(cInsuranceCompareGroup.insuranceOrgList, function() {
				if(this.STATE == "신규편입") {
//					var item = {
//						 "INSURED_INFO"			: ""
//						,"INSURED_NUM_LIST"		: ""
//						,"STATE"				: ""
//						,"COMPANY_NAME"			: ""
//						,"CONTRACTOR"			: ""
//						,"GUARANTEE_TERM_TYPE"	: ""
//						,"PAY_TERM_TYPE"		: ""
//						,"START_DATE"			: ""
//						,"PAY_TERM"				: ""
//						,"INSURANCE_TYPE"		: ""
//						,"PAY_EACH_MONTH"		: ""
//						,"PLAN_NUM"				: ""
//						,"INSURANCE_NUM"		: ""
//						,"GUARANTEE_TERM"		: ""
//						,"DEL_YN"				: ""
//						,"TITLE"				: ""
//						,"mainInsured"			: ""
//					}
					var item = this;
					item.PAY_EACH_MONTH = 0;
					item.DUMMY			= "Y"
					resultInfo.data.push(item);
				}
			});
		}
		// Insurance Group 생성
		var cInsuranceGroup = new C_INSURANCE_GROUP(resultInfo.data);
		
		cInsuranceGroup.loadAllDamboList();
		return cInsuranceGroup;
	}	
};

/**
 * 보험 담보 관련 서비스
 */ 
var _SVC_DAMBO = {
	 baseDamboList 	: []
	,baseDamboMap 	: {}
	,chartDamboList : []
	,chartDamboMap 	: {}
	,damboOrder		: undefined
	,fullDamboMap	: undefined
	// 전체 담보 관련 정보를 로드한다.
	,getFullDamboMap : function(refreshFlag) {
		if(refreshFlag) this.damboOrder = undefined;
		if(this.damboOrder == undefined) {
			var resultInfo 	= requestService("GET_COMMON", {"sqlId" : "Insurance.getDamboList"});
			var jsonData 	= resultInfo.data;
			
			// 보험 정보를 가공한다.
			$.each(jsonData, function() {
				this.CATEGORY_NAME_STR = this.CATEGORY_NAME;
			});

			/* 전체 Dambo에 대한 전역변수 설정 */
			// Dambo Order 설정
			this.damboOrder 	= jsonData;
			// Dambo Map 설정
			this.fullDamboMap 	= arrayToMap(jsonData, "DAMBO_NUM");
		}
		var returnParm = {
			"damboOrder" 	: this.damboOrder,
			"fullDamboMap"	: this.fullDamboMap
		}
		return returnParm;
	}
	// type이 "init"인경우 무조건 갱신
	// 그 외에는 1회만 Load한다.
	,getBaseDamboList : function(type) {
		if(type == "init" || this.baseDamboList.length == 0) 
		{
			// 기본 담보를 Load한다.
			var resultInfo = requestService("GET_COMMON", {"sqlId" : "Insurance.getBaseDamboList"});
			_SVC_DAMBO.baseDamboList = [];
			$.each(resultInfo.data, function() {
				_SVC_DAMBO.baseDamboList.push(this);
				_SVC_DAMBO.baseDamboMap[this.DAMBO_NUM] = this;
			});
		}
		return this.baseDamboList;
	}
	// type이 "init"인경우 무조건 갱신
	// 그 외에는 1회만 Load한다.
	,getChartDamboList : function(type) {
		if(type == "init" || _SVC_DAMBO.chartDamboList.length == 0 ) {
			// Chart 담보를 Load한다.
			var resultInfo = requestService("GET_COMMON", {"sqlId" : "Insurance.getChartDamboList"});
			_SVC_DAMBO.chartDamboList = [];
			$.each(resultInfo.data, function() {
				_SVC_DAMBO.chartDamboList.push(this);
				_SVC_DAMBO.chartDamboMap[this.DAMBO_NUM] = this;
			});
		}
		return this.chartDamboList;
	}
	// 보험 담보 금액 parse
	,parseInsuranceMoney : function(insuranceMoney) {
		var moneyMap = {};
		var imoney = insuranceMoney;
		var imArray =  imoney.split(",");
		$.each(imArray, function() {
			 var itemArray 		= this.split("/");
			 var term 			= itemArray[0];
			 var itemMoneyArray = itemArray[1].split("~");
			 if(moneyMap[term] == undefined) moneyMap[term] = new C_DAMBO_MONEY();
			 moneyMap[term]["minInsuranceMoney"] = itemMoneyArray[0]; 
			 moneyMap[term]["maxInsuranceMoney"] = itemMoneyArray[0];
			 if		(itemMoneyArray[1] != undefined) 											moneyMap[term]["maxInsuranceMoney"] = itemMoneyArray[1];
			 
			 if		(moneyMap["minimumInsuranceMoney"] == undefined) 							moneyMap["minimumInsuranceMoney"] = moneyMap[term]["minInsuranceMoney"];
			 else if(moneyMap["minimumInsuranceMoney"] > moneyMap[term]["minInsuranceMoney"]) 	moneyMap["minimumInsuranceMoney"] = moneyMap[term]["minInsuranceMoney"];
			 if		(moneyMap["maximumInsuranceMoney"] == undefined) 							moneyMap["maximumInsuranceMoney"] = moneyMap[term]["maxInsuranceMoney"];
			 else if(moneyMap["maximumInsuranceMoney"] < moneyMap[term]["maxInsuranceMoney"]) 	moneyMap["maximumInsuranceMoney"] = moneyMap[term]["maxInsuranceMoney"];
		});
		return moneyMap;
	}
	,setDamboGroupToSelectBox : function(targetId, header) {
		var resultInfo = requestService("GET_DAMBO_GROUP_INFO_LIST", {});
		var damboGroupInfoList = resultInfo.data;

		var damboGroupInfoMap = arrayToMap(damboGroupInfoList, "GROUP_NUM", "GROUP_NAME");
		
		fn_addJsonToSelectBox(targetId, header, true);
		fn_addJsonToSelectBox(targetId, damboGroupInfoMap);
		
	}
};

/**
 * 담보 금액 Class
 */
var C_DAMBO_MONEY = function(minInsuranceMoney, maxInsuranceMoney) {
	this.minInsuranceMoney = minInsuranceMoney;
	this.maxInsuranceMoney = maxInsuranceMoney;
	if(this.minInsuranceMoney == undefined) this.minInsuranceMoney = 0;
	if(this.maxInsuranceMoney == undefined) this.maxInsuranceMoney = 0;
	
	this.add = function(damboMoney2) {
		if(damboMoney2 == undefined) return;
		if(isNumber(damboMoney2.minInsuranceMoney)) this.minInsuranceMoney += Number(damboMoney2.minInsuranceMoney);
		if(isNumber(damboMoney2.maxInsuranceMoney)) this.maxInsuranceMoney += Number(damboMoney2.maxInsuranceMoney);
	};
	this.getMoneyRange = function() {
		var returnStr = "";
		if(this.minInsuranceMoney == this.maxInsuranceMoney) 	returnStr = addComma(this.minInsuranceMoney) + "만원";
		else													returnStr = addComma(this.minInsuranceMoney) + "만원" + "~" + addComma(this.maxInsuranceMoney) + "만원";
		return returnStr;
	};
	this.isValid = function() {
		if(this.minInsuranceMoney == 0 && this.minInsuranceMoney == 0) 	return false;
		else															return true;
	};
}

/**
 * 보험 담보 관련 Class
 */ 
var C_INSURANCE_DAMBO = function(insuranceDamboItem, parentInsurance) {
	// 담보 Member 변수 Setting
	$.extend(this, insuranceDamboItem);
	this.parentInsurance 	= parentInsurance;
	this.TERM_MONEY_MAP 	= {};
	this.cDamboMoney 		= new C_DAMBO_MONEY();
	var thisObj 			= this;
	$.each(insuranceDamboItem, function() {
		thisObj.TERM_MONEY_MAP 	= _SVC_DAMBO.parseInsuranceMoney(thisObj.INSURANCE_MONEY);
		thisObj.cDamboMoney.minInsuranceMoney = thisObj.TERM_MONEY_MAP.minimumInsuranceMoney; 
		thisObj.cDamboMoney.maxInsuranceMoney = thisObj.TERM_MONEY_MAP.maximumInsuranceMoney; 
	});
}

/**
 * 보험 관련 Class
 */ 
var C_INSURANCE = function(insuranceItem) {

	// 보험 Member 변수 Setting
	$.extend(this, insuranceItem);

	this.insuredList 	= [];	// 피보험자 리스트
	this.insuredMap 	= {};	// 피보험자 Map

	// 납입횟수/남은횟수 처리
	var startMonth 	= this.START_DATE;
	//var endMonth 	= getToday();
	var endMonth 	= _SESSION["PLAN_DATE"];
	this.BIRTH_YEAR	= this.INSURED_INFO.split(",")[0].split("/")[1];	// BIRTH_YEAR		: 주피보험자 생년
	this.PAY_TERM_YEAR = this.PAY_TERM;									// PAY_TERM_YEAR	: 납입기간(년납으로 환산)
	// 세납을 년납으로 변환
	var targetYear = this.START_DATE.replaceAll("-", "").substring(0,4);
	if(this.PAY_TERM_TYPE == "세납") this.PAY_TERM_YEAR = Number(this.BIRTH_YEAR) + Number(this.PAY_TERM) - Number(targetYear);
	this.PAY_COUNT_TOTAL= this.PAY_TERM_YEAR * 12;						// PAY_COUNT_TOTAL	: 총 납입 횟수
	this.PAY_COUNT 		= getDistanceMonth(startMonth, endMonth) + 1;	// PAY_COUNT 		: 납입 횟수
	this.REST_COUNT		= this.PAY_COUNT_TOTAL 	- this.PAY_COUNT;		// REST_COUNT		: 남은 납입 횟수
	this.NOW_TOTAL_PAY	= this.PAY_COUNT 		* this.PAY_EACH_MONTH;	// NOW_TOTAL_PAY	: 기납입 보험료
	this.REST_TOTAL_PAY	= this.REST_COUNT 		* this.PAY_EACH_MONTH;	// REST_TOTAL_PAY	: 납입 예정 보험료
	this.TOTAL_PAY		= this.PAY_COUNT_TOTAL 	* this.PAY_EACH_MONTH;	// TOTAL_PAY		: 총 보험료
	
	// 해지 인경우 임의 처리
	if(this.STATE == "해지") {
		this.PAY_EACH_MONTH		= 0;
		this.REST_TOTAL_PAY 	= 0;
		this.TOTAL_PAY			= this.NOW_TOTAL_PAY;
	}
	
	// 피보험자 정보 처리
	var iArray 	= this.INSURED_INFO.split(",");
	var inArray	= this.INSURED_NUM_LIST.split(",");
	var thisObj = this;
	$.each(iArray, function(idx) {
		var infoArray = iArray[idx].split("/");
		thisObj.insuredMap[infoArray[0]] = {
			"NAME" 			: infoArray[0],
			"BIRTH" 		: infoArray[1], 
			"INSURED_NUM"	: inArray[idx]
		}
		thisObj.insuredList.push(thisObj.insuredMap[infoArray[0]]);
	});
	
	// 피보험자별 담보 리스트
	this.insuredMapToInsuranceDamboList	= {};
	this.insuredMapToInsuranceDamboMap 	= {};
	
	// 
	// Method
	//

	// EachMonth 표시 Method
	this.getPayEachMonth = function() {
		return addComma(this.PAY_EACH_MONTH);
	};
	// 현재까지 납입한 보험료
	this.getNowTotalPay = function(type) {
		var val = this.NOW_TOTAL_PAY;
		if(type=="만원") val = Math.round(val /1000) / 10; 
		return addComma(val); 
	};
	// 납입 예정 보험료
	this.getRestTotalPay = function(type) {
		var val = this.REST_TOTAL_PAY;
		if(type=="만원") val = Math.round(val /1000) / 10; 
		return addComma(val); 
	};
	// 총 납입 보험료
	this.getTotalPay = function(type) {
		var val = this.TOTAL_PAY;
		if(type=="만원") val = Math.round(val /1000) / 10; 
		return addComma(val); 
	};
	// 피보험자 명수
	this.getCountInsured = function() {
		return this.insuredList.length;
	};
	// 종피보험자 이름
	this.getSubInsuredName = function() {
		var returnStr = "";
		$.each(this.insuredList, function(idx) {
			if(idx == 0) return true;
			if(idx == 1) 	returnStr = this.NAME;
			else			returnStr += "<br/>" + this.NAME;
		});
		return returnStr;
	};
	this.loadDamboList = function() {
		var thisObj = this;
		// 기본 담보를 Load한다.
		var resultInfo = requestService("GET_INSURANCE_DAMBO_LIST", { "INSURANCE_NUM" : this.INSURANCE_NUM});
		$.each(resultInfo.data, function() {
			var insuredName = this.INSURED_NAME;
			var cInsuranceDambo = new C_INSURANCE_DAMBO(this);
			if(thisObj.insuredMapToInsuranceDamboList[insuredName] 	== undefined) thisObj.insuredMapToInsuranceDamboList[insuredName] 	= []; 
			if(thisObj.insuredMapToInsuranceDamboMap[insuredName]	== undefined) thisObj.insuredMapToInsuranceDamboMap[insuredName] 	= {};
			thisObj.insuredMapToInsuranceDamboList[insuredName].push(cInsuranceDambo);
			thisObj.insuredMapToInsuranceDamboMap [insuredName][this.DAMBO_NUM] = cInsuranceDambo;
		});
	};
	this.getBackColor = function() {
		if(this.STATE == "해지") 	return "#F0F0F8";
		else						return "";
	}
}; 

/**
 * 보험 그룹 Class
 */
var C_INSURANCE_GROUP = function(insuranceList) {
	// 보험 목록 원본
	this.insuranceOrgList 	= [];
	// 보험 목록
	this.insuranceList 	= [];
	// INSURANCE_NUM(Key)을 Key로 구성된 보험 목록 Map
	this.insuranceMap	= {};
	// 화면에 보여주기위한 보험 리스트(총합 등 계산처리됨)
	this.gridList		= [];
	// 화면에 보여주기위한 전체총합
	this.allTotal		= {};
	// 피보험자별 전체 보험 담보 기간 리스트
	this.allTermListOfInsuredNameMap = {};
	// 기본 담보 계산 결과 Map
	this.baseResultMap	= {};
	// 나이별 담보 계산 결과 Map
	this.termResultMap	= {};
	// 초기화 
	this.init = function(insuranceList) {
		$.each(insuranceList, function() {
			if(this.STATE == "사용안함") return true;
			this.mainInsured = this.INSURED_INFO.split("/")[0];
		});
		insuranceList = insuranceList.orderBy("mainInsured");
		
		var iList = [];
		$.each(insuranceList, function() {
			var cInsurance = new C_INSURANCE(this);
			iList.push(cInsurance);
		});
		this.insuranceList = iList;
		this.insuranceMap = arrayToMap(this.insuranceList, "INSURANCE_NUM");
		
		var listArray 	= [];
		var listMap		= undefined;
		var preInsured	= "";
		var allTotal	= {
			"PAY_EACH_MONTH" 	: 0,
			"NOW_TOTAL_PAY" 	: 0,
			"REST_TOTAL_PAY" 	: 0,
			"TOTAL_PAY" 		: 0,
			"getSumPayEachMonth"	: function() {
				return addComma(this.PAY_EACH_MONTH); 
			},
			"getSumNowTotalPay"		: function(type) {
				var val = this.NOW_TOTAL_PAY;
				if(type=="만원") val = Math.round(val /1000) / 10; 
				return addComma(val); 
			},
			"getSumRestTotalPay"	: function(type) {
				var val = this.REST_TOTAL_PAY;
				if(type=="만원") val = Math.round(val /1000) / 10; 
				return addComma(val); 
			},
			"getSumTotalPay"		: function(type) {
				var val = this.TOTAL_PAY;
				if(type=="만원") val = Math.round(val /1000) / 10; 
				return addComma(val); 
			}
		};
		$.each(this.insuranceList, function(idx) {
			/** 기본 가공 */
			// 주피보험 기준 처리
			this.mainInsured = this.INSURED_INFO.split("/")[0];
			// 총계 처리
			allTotal.PAY_EACH_MONTH += Number(this.PAY_EACH_MONTH	);
			allTotal.NOW_TOTAL_PAY 	+= Number(this.NOW_TOTAL_PAY	);
			allTotal.REST_TOTAL_PAY += Number(this.REST_TOTAL_PAY	);
			allTotal.TOTAL_PAY 		+= Number(this.TOTAL_PAY		);
			
			if(preInsured != this.mainInsured) {
				if(idx > 0) {
					//피보험자가 변경 된 경우 이전 피보험자 리스트에 등록
					listArray.push(listMap);
				}
				preInsured = this.mainInsured;
				listMap = {
					"list" 	: [],
					"total"	: {
						"mainInsured"	 	: preInsured,
						"PAY_EACH_MONTH" 	: 0,
						"NOW_TOTAL_PAY" 	: 0,
						"REST_TOTAL_PAY" 	: 0,
						"TOTAL_PAY" 		: 0,
						"getSumPayEachMonth"	: function() {
							return addComma(this.PAY_EACH_MONTH); 
						},
						"getSumNowTotalPay"		: function(type) {
							var val = this.NOW_TOTAL_PAY;
							if(type=="만원") val = Math.round(val /1000) / 10; 
							return addComma(val); 
						},
						"getSumRestTotalPay"	: function(type) {
							var val = this.REST_TOTAL_PAY;
							if(type=="만원") val = Math.round(val /1000) / 10; 
							return addComma(val); 
						},
						"getSumTotalPay"		: function(type) {
							var val = this.TOTAL_PAY;
							if(type=="만원") val = Math.round(val /1000) / 10; 
							return addComma(val); 
						}
					}
				}
			}
			listMap.list.push(this);
			listMap.total.PAY_EACH_MONTH 	+= Number(this.PAY_EACH_MONTH);
			listMap.total.NOW_TOTAL_PAY 	+= Number(this.NOW_TOTAL_PAY);
			listMap.total.REST_TOTAL_PAY 	+= Number(this.REST_TOTAL_PAY);
			listMap.total.TOTAL_PAY 		+= Number(this.TOTAL_PAY);
		});
		listArray.push(listMap);
		this.gridList = listArray;
		this.allTotal = allTotal;
	};
	// 보험 항목 가져오기
	this.getInsurance = function(insuranceNum) {
		return this.insuranceMap[insuranceNum];
	};
	// 보험중에 종피보험자가 하나라도 있는지 여부
	this.isExistSubInsured = function() {
		var flag = false;
		$.each(this.insuranceList, function() {
			if(this.getCountInsured() > 1) {
				flag = true;
				return false;
			}
		});
		return flag;
	};
	// 전체 피보험자 리스트
	this.getAllInsuredNameMap = function() {
		var tmap 	= {};
		var map 	= {};
		var list	= [];
		$.each(this.insuranceList, function() {
			$.each(this.insuredList, function(idx) {
				tmap[this.NAME] = this.NAME;
			});
		});
		var idx = 0;
		$.each(tmap, function(key, val) {
			map[idx++ + ""] = val;
		});
		$.each(map, function(key, value) {
			list.push(value);
		});
		return {list : list, map : map};
	};
	// 피보험자 대상 보험 목록
	this.getInsuranceListByInsured = function(insuredName) {
		var returnInsuranceList = [];
		$.each(this.insuranceList, function() {
			if(this.insuredMap[insuredName] != undefined) {
				this.INSURED_NUM = this.insuredMap[insuredName].INSURED_NUM;
				var is = fn_copyObject(this);
				is.targetInsured = insuredName;
				if(is.mainInsured != insuredName) is.PAY_EACH_MONTH = 0;
				returnInsuranceList.push(is);
			}
		});
		return returnInsuranceList;
	};
	// 담보를 Load한다.
	this.loadAllDamboList = function() {
		$.each(this.insuranceList, function() {
			if(in_array(this.STATE, ["사용안함","해지"])) return true;
			this.loadDamboList();
		});
		
		// 담보 전체 보장기간 처리
		var thisObj = this;
		var allTermMapOfInsuredName = {};
		$.each(thisObj.insuranceList, function(idx) {
			$.each(this.insuredMapToInsuranceDamboList, function(insuredName, list) {
				if(allTermMapOfInsuredName[insuredName] == undefined) allTermMapOfInsuredName[insuredName] = {};
				$.each(list, function() {
					if(this.TERM_MONEY_MAP == undefined) return true;
					$.each(this.TERM_MONEY_MAP, function(term, obj) {
						if(typeof obj == "object") allTermMapOfInsuredName[insuredName][term] = "Y";
					});
				});
			});
		});
		var allTermListOfInsuredNameMap = {};
		$.each(allTermMapOfInsuredName, function(insuredName, obj) {
			if(allTermListOfInsuredNameMap[insuredName] == undefined) allTermListOfInsuredNameMap[insuredName] = [];
			$.each(obj, function(term, tmp) {
				allTermListOfInsuredNameMap[insuredName].push(term);
			});
		});
		this.allTermListOfInsuredNameMap = allTermListOfInsuredNameMap;
	};
	
	this.termListOfInsuredName = function(insuredName) {
		var list = this.allTermListOfInsuredNameMap[insuredName];
		if(list == undefined) 	return [];
		else					return list;
	};
	// 피보험자의 등록 담보 그룹을 만든다.
	this.makeBaseDamboAnalysisMap = function(parm) {
		var insuredName 	= parm.insuredName;
		var damboGroupType 	= parm.damboGroupType;
		
		// return value
		var returnBaseResultMap = {};

		var insuranceGroup = this;
		// 이미 작성된 Map이 있으면 Map을 세팅한다.
		if(insuranceGroup.baseResultMap[insuredName] != undefined) {
			returnBaseResultMap = insuranceGroup.baseResultMap[insuredName];
		} else {
			// 전체 담보 관련 기본 정보 로드
			var parm = _SVC_DAMBO.getFullDamboMap(true);
			var fullDamboMap = parm.fullDamboMap;
			
			var resultMap 	= {
				 "companyNameList" 		: []
				,"insuranceDamboMap"	: {}
				,"insuranceDamboList"	: []
			}; 
			var insuranceList = insuranceGroup.getInsuranceListByInsured(insuredName);
			$.each(insuranceList, function() {
				var insuranceDamboList 	= this.insuredMapToInsuranceDamboList[insuredName];
				var companyName	= this.COMPANY_NAME;
				resultMap.companyNameList.push({ "COMPANY_NAME" : companyName });
				if(insuranceDamboList == undefined) return true;
				$.each(insuranceDamboList, function() {
					var damboNum = this.DAMBO_NUM;
					// 전체 담보 정보에서 기본 담보 정보를 세팅한다.
					if(resultMap.insuranceDamboMap[damboNum] == undefined) resultMap.insuranceDamboMap[damboNum] = fullDamboMap[damboNum]; 
					resultMap.insuranceDamboMap[damboNum][companyName] 	= this.cDamboMoney.getMoneyRange();
					if(resultMap.insuranceDamboMap[damboNum]["cInsuranceDamboList"] == undefined) resultMap.insuranceDamboMap[damboNum]["cInsuranceDamboList"] = [];
					resultMap.insuranceDamboMap[damboNum]["cInsuranceDamboList"].push(this);
				});
			});
			$.each(resultMap.insuranceDamboMap, function(damboNum, obj) {
				var cDamboMoneyTmp = new C_DAMBO_MONEY();
				if(obj.cInsuranceDamboList != undefined) {
					$.each(obj.cInsuranceDamboList, function() {
						cDamboMoneyTmp.add(this.cDamboMoney);
					});
					this["cDamboMoneyTotal"] = cDamboMoneyTmp;
				}
				resultMap.insuranceDamboList.push(this);
			});
			insuranceGroup.baseResultMap[insuredName] = resultMap;
			returnBaseResultMap = resultMap;
		}
		return this._getDamboListByType(returnBaseResultMap, damboGroupType);
	};
	// 보장 기간별 담보 분석
	this.makeDamboMoneyAnalysisMap =  function(parm, compInsuranceGroup) {
		var insuredName 	= parm.insuredName;
		var damboGroupType 	= parm.damboGroupType;

		// return value
		var returnBaseResultMap = {};

		var insuranceGroup = this;

		// 이미 작성된 Map이 있으면 Map을 리턴한다.
		if(insuranceGroup.termResultMap[insuredName] != undefined) {
			returnBaseResultMap = insuranceGroup.termResultMap[insuredName];
		} else {
			// 전체 담보 관련 기본 정보 로드
			var parm = _SVC_DAMBO.getFullDamboMap(true);
			var fullDamboMap = parm.fullDamboMap;
			
			var resultList 	= []; 
			var resultMap 	= {
				 "termList"				: []
				,"insuranceDamboMap"	: {}
				,"insuranceDamboList"	: []
			}; 
			var insuranceList 	= insuranceGroup.getInsuranceListByInsured(insuredName);
			var termList		= insuranceGroup.termListOfInsuredName(insuredName);
			// 비교 그룹이 있을경우 Term을 Merge한다.
			if(isValid(compInsuranceGroup)) {
				var comTermList = compInsuranceGroup.termListOfInsuredName(insuredName);
				termList = fn_mergeArray(termList, comTermList);
				termList = termList.unique();
				termList = termList.sort(function(a,b){return a-b});
			}
			
			var termMap = {};
			$.each(insuranceList, function() {
				var insuranceDamboList 	= this.insuredMapToInsuranceDamboList[insuredName];
				if(!isValid(insuranceDamboList)) return true;
				$.each(insuranceDamboList, function() {
					var damboNum = this.DAMBO_NUM;
					// 전체 담보 정보에서 기본 담보 정보를 세팅한다.
					if(resultMap.insuranceDamboMap[damboNum] == undefined) resultMap.insuranceDamboMap[damboNum] = fullDamboMap[damboNum];
					var targetTermMap = this.TERM_MONEY_MAP;
					var preMoneyMap = new C_DAMBO_MONEY();
					for(var ii=termList.length - 1; ii >= 0; ii--) {
						var term = termList[ii];
						if(targetTermMap[term] == undefined) {
							if(resultMap.insuranceDamboMap[damboNum][term] == undefined) resultMap.insuranceDamboMap[damboNum][term] = new C_DAMBO_MONEY();
							resultMap.insuranceDamboMap[damboNum][term].add(preMoneyMap);
						} else {
							if(resultMap.insuranceDamboMap[damboNum][term] == undefined) resultMap.insuranceDamboMap[damboNum][term] = new C_DAMBO_MONEY();
							resultMap.insuranceDamboMap[damboNum][term].add(targetTermMap[term]);
							preMoneyMap = targetTermMap[term];
						} 
					}
				});
			});
			$.each(resultMap.insuranceDamboMap, function(key, obj) {
				resultMap.insuranceDamboList.push(obj);
			});
			$.each(termList, function() {
				var item = { "TERM" : this};
				resultMap.termList.push(item);
			});
			if(resultMap.termList.length == 0) resultMap.termList = { "TERM" : "100" };
			insuranceGroup.termResultMap[insuredName] = resultMap;
			returnBaseResultMap = resultMap;
		}
		return this._getDamboListByType(returnBaseResultMap, damboGroupType);
	};
	this._getDamboListByType = function(returnBaseResultMap, damboGroupType) {
		// Base Group Type에 따른 기본 담보 Setting
		if(!isValid(damboGroupType) || damboGroupType == "REGISTED_DAMBO") {
			return returnBaseResultMap;
		} else {
			var finalMap = fn_copyObject(returnBaseResultMap);
			
			finalMap.insuranceDamboList = [];
			
			var bdl = _SVC_DAMBO.getBaseDamboList('init');
			$.each(bdl, function() {
				if(finalMap.insuranceDamboMap[this.DAMBO_NUM] == undefined) finalMap.insuranceDamboMap[this.DAMBO_NUM] = this;
			});

			// Base dambo Setting
			if (damboGroupType 	== "BASE_DAMBO") {
				var tmpMap = {}
				$.each(bdl, function() {
					if(finalMap.insuranceDamboMap[this.DAMBO_NUM] == undefined) 	tmpMap[this.DAMBO_NUM] = this;
					else 															tmpMap[this.DAMBO_NUM] = finalMap.insuranceDamboMap[this.DAMBO_NUM];
				});
				finalMap.insuranceDamboMap = tmpMap;
			} else {
				$.each(bdl, function() {
					if(finalMap.insuranceDamboMap[this.DAMBO_NUM] == undefined) finalMap.insuranceDamboMap[this.DAMBO_NUM] = this;
				});
			}
			$.each(finalMap.insuranceDamboMap, function(damboNum, obj) {
				finalMap.insuranceDamboList.push(obj);
			});
			return finalMap;
		}
	}
	// 초기화 실행
	this.insuranceOrgList = insuranceList;
	// 초기화 실행
	this.init(insuranceList);
};


/**
 * 보험 그룹 비교Class
 */
var C_INSURANCE_COMPARE = function(insuranceGroupBase, insuranceGroup) {
	this.insuranceGroupBase		= insuranceGroupBase;
	this.insuranceGroup			= insuranceGroup;
	this.insuranceCompareList	= [];
}
