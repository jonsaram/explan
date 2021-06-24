// 투자상품 Method 
var _C_IMMOVABLE_METHOD = {
	"getImmovableValue"		: 	function() {
									return makeMoneyStr(this.immovableValue);
								},
	"getFutureListByMonth"	: 	function(targetDate) {
									return CImmovableAPI.getFutureListByMonth(this, targetDate); 
								}								
}
C_IMMOVABLE_GROUP = function(immovableList, targetDate) {
	this.immovableList 			= immovableList;
	this.totalListGroupByType 	= [];
	this.totalObjGroupByType 	= {};

	this.sourceTotal			= 0;
	this.resultTotal			= 0;
	
	this.sourceTotalStr			= "";
	this.resultTotalStr			= "";
	
	if(isValid(immovableList)) {
		var resultTotal 		= this.resultTotal			;
		var sourceTotal			= this.sourceTotal			;
		var totalObjGroupByType	= this.totalObjGroupByType	;
		$.each(immovableList, function() {
			if(in_array(this.state, ["사용안함","매도"])) return true;
			
			var valueList = this.getFutureListByMonth(targetDate);
			resultTotal  += valueList.getValue(targetDate);
			sourceTotal  += eval(this.immovableValue);
			if(totalObjGroupByType[this.immovableType] == undefined) {
				totalObjGroupByType[this.immovableType]  = {
					"source": eval(this.immovableValue),
					"total" 	: eval(valueList.getValue(targetDate))
				};
			} else {
				totalObjGroupByType[this.immovableType]["source"] 	+= eval(this.immovableValue				);
				totalObjGroupByType[this.immovableType]["total"]  		+= eval(valueList.getValue(targetDate)	);
			}
		});
		this.resultTotal = resultTotal;
		this.sourceTotal = sourceTotal;
		this.totalListGroupByType	= mapToList(totalObjGroupByType, ["immovableType"]);
		
		// 금액 가공 (x억 xx만원)
		$.each(this.totalListGroupByType, function() {
			this.sourceStr 	= makeMoneyStr(Math.round(this.source));
			this.totalStr 	= makeMoneyStr(Math.round(this.total));
		});
	}
	this.getSubListGroupByType = function() {
		var returnMap = {
			 totalListGroupByType 	: this.totalListGroupByType
			,sourceTotal			: this.sourceTotal		
			,resultTotal			: this.resultTotal			
			,sourceTotalStr			: makeMoneyStr(Math.round(this.sourceTotal	))
			,resultTotalStr			: makeMoneyStr(Math.round(this.resultTotal	))
		}
		return returnMap;
	}
};
//투자자산 관련 API
var CImmovableAPI = {
	// 월별 추정 자산 리스트
	"getFutureListByMonth" : function(immovableObj, targetDate) {
		var item = immovableObj;
		
		var resultSet 	= {};
		
		if(!isValid(item.startDate)) item.startDate = targetDate;
		
		var tmm 	= getDistanceMonth(item.startDate, targetDate);
		var tyyyy	= Math.floor(tmm / 12);
		var syyyy 	= item.startDate.substring(0, 4);
		var smm 	= item.startDate.substring(4, 6);
		var eyyyy 	= targetDate.substring(0, 4);
		var emm 	= targetDate.substring(4, 6);

		var result = eval(item.immovableValue);
		resultSet[syyyy + smm] = result;
		for(var i=1;i <= tyyyy;i++) {
			result = result * (100 + eval(item.inflationRate)) / 100;
			var key = eval(syyyy) + i;
			resultSet[key + "" + smm] = result;
		}
		resultSet[eyyyy + emm] = result;
		
		resultSet.getValue = function(targetDate) {
			return this[targetDate.substring(0, 6)];
		};
		return resultSet;
	}
};
