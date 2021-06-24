// Loan Json Data의 관련
var _C_LOAN_METHOD = {
	"thisClass"				: undefined,
	"getClass"				: 	function() {
		return this.thisClass;
	}, 
	"getStartDate"			: 	function() {
									return getDateFormat(this.startDate);
								},
	"getPaybackType"		: 	function() {
									return _LOAN_TYPE_MAP[this.paybackType]; 
								},
	"getLoanTotal"			: 	function() {
									return makeMoneyStr(this.loanTotal); 
								},
	"getPaybackEachMonth"	: 	function() {
									return this.paybackEachMonth; 
								},
	"getTotalInterest"		: 	function() {
									return addComma(this.getClass().getTotalInterest(this.scale)); 
								},
	"getRestLoan"			: 	function(targetDate) {
									var restLoan = this.getClass().getLoanStateItemTargetDate(targetDate);
									return restLoan;
								},
	// interface 병합시 실행되는 function
	"loadDataInit"			: 	function() {
									this.thisClass = new CLASS_LOAN(this);
								}
}


var CLASS_LOAN_STATE = function() {
	this.principal 			= 0;		// 현재 남은 원금
	this.paybackPrincipal 	= 0;		// 상환원금
	this.interest			= 0;		// 이자
	this.getPaybackPrincipal 	= function() {
		var result = this.paybackPrincipal;
		if(result < 1) result = 0;
		return fn_fix(result, 1);
	};
	this.getPaybackInterest 	= function() {
		var result = this.interest;
		if(result < 1) result = 0;
		return fn_fix(result, 1);
	};
	this.getPaybackTotal 	= function() {
		var result = this.interest + this.paybackPrincipal;
		if(result < 1) result = 0;
		return fn_fix(result, 1);
	};
	this.getPrincipal 	= function() {
		if(this.principal < 1) this.principal = 0;
		return fn_fix(this.principal, 1);
	};
};
var CLASS_LOAN = function(parmObj) {
	this.loanTotal 		= 0;
	this.scale 			= 1;
	this.loanRate		= 0;    
	this.kuchiTerm		= 0;    
	this.paybackTerm	= 0;    
	this.paybackType	= "";	// 'A' 만기 일시 상환, 'B' 원리금균등, 'C' 원금균등, 'D' 원리금균등 일부 상환
	this.paybackEachMonth	= 0;	// paybackType Type이 'D'인 경우에만 유효함.(매월 상환할 금액 지정)
	this.startDate		= "";
				
	this.loanStateList 	= [];
	this.totalInterest 	= 0;
	this.finalLoan		= 0;
	this.errorType		= "";
	// 부채 분석 Core
	this.analysisLoan = function(parmObj) {
		this.scale				= parmObj.scale == undefined ? 1 : parmObj.scale;
		this.loanTotal 			= parmObj.loanTotal * this.scale;
		this.loanRate			= parmObj.loanRate / 100;
		this.kuchiTerm			= isValid(parmObj.kuchiTerm		) ? parmObj.kuchiTerm 	: 0;
		this.paybackTerm		= isValid(parmObj.paybackTerm	) ? parmObj.paybackTerm : 0;
		this.totalTerm			= Number(this.kuchiTerm) + Number(this.paybackTerm);
		this.paybackType		= parmObj.getPaybackType();
		this.paybackEachMonth	= parmObj.paybackEachMonth  ;
		this.startDate			= parmObj.startDate	;
		this.loanStateList 		= [];
		this.totalInterest 		= 0;
		this.finalLoan			= 0;

		if(this.paybackType == "D" && (!isValid(this.paybackEachMonth) || this.paybackEachMonth < 1) ) {
			this.errorType = "paybackEachMonth";
			return;
		}
		// 일시 상환 방식인 경우, 상환 기간을 거치기간과 합친다.
		if(this.paybackType == "A") {
			this.kuchiTerm = eval(this.kuchiTerm) + eval(this.paybackTerm);
			this.paybackTerm = 0;
		}
		var loan_rest = this.loanTotal;
		for ( var ii = 0; ii < this.kuchiTerm; ii++ ) {
			var ol_loanState = new CLASS_LOAN_STATE();
			var interest = loan_rest * this.loanRate / 12;
			ol_loanState.principal 			= loan_rest;
			ol_loanState.paybackPrincipal 	= 0;
			ol_loanState.interest 			= interest;
			this.loanStateList.push(ol_loanState);
			this.totalInterest += ol_loanState.interest;
		}
		if( this.paybackTerm > 0 )
		{
			if(this.paybackType == "B" || this.paybackType == "D") {
				var paybackTotal = 0;;
				if		(this.paybackType == "B") paybackTotal = this.loanTotal * this.loanRate / 12 * Math.pow( (1+this.loanRate / 12), this.paybackTerm ) / ( Math.pow( (1+this.loanRate / 12), this.paybackTerm ) - 1);
				else if(this.paybackType == "D") paybackTotal = this.paybackEachMonth;

				var interest = loan_rest * this.loanRate / 12;
				if(paybackTotal < interest) {
					this.errorType = "paybackEachMonth_error";
					return;
				}
										
				for ( var ii = 0; ii < this.paybackTerm; ii++ ) {
					var ol_loanState = new CLASS_LOAN_STATE();
					var interest = loan_rest * this.loanRate / 12;
					ol_loanState.paybackPrincipal 	= paybackTotal - interest;
					ol_loanState.interest 			= interest;
					loan_rest = loan_rest - ol_loanState.paybackPrincipal;
					ol_loanState.principal 			= loan_rest;
					if(loan_rest < 1) loan_rest = 0;
					this.loanStateList.push(ol_loanState);
					this.totalInterest += ol_loanState.interest;
				}
			} else if(this.paybackType == "C") {
				var paybackPrincipal = loan_rest / this.paybackTerm;
				for ( var ii = 0; ii < this.paybackTerm; ii++ ) {
					var ol_loanState = new CLASS_LOAN_STATE();
					var interest = loan_rest * this.loanRate / 12;
					ol_loanState.paybackPrincipal 	= paybackPrincipal;
					ol_loanState.interest 			= interest;
					loan_rest = loan_rest - paybackPrincipal;
					if(loan_rest < 1) loan_rest = 0;
					ol_loanState.principal 			= loan_rest;
					this.loanStateList.push(ol_loanState);
					this.totalInterest += ol_loanState.interest;
				}
			}
		}
		this.finalLoan = loan_rest;
	};
	// 부채 Item 가져오기
	this.getLoanStateItem = function(idx) {
		if(this.loanStateList.length < idx || idx < 1) return {};
		return this.loanStateList[idx - 1];
	};
	// 부채 이자
	this.getTotalInterest = function(scale) {
		if(scale == undefined) scale = this.scale;
		if(scale == undefined) scale = 1;
		return Math.round(this.totalInterest * scale);
	};
	// 부채 특정 날짜 LoanState Item
	this.getLoanStateItemTargetDate = function(targetDate) {
		if(targetDate == undefined) return;
		targetDate = targetDate.replaceAll("-", "");
		
		var month = getDistanceMonth(this.startDate, targetDate);

		if(month < 0) month = 0;
		return this.getLoanStateItem(month);
	};
	// 특정 날짜의 상환금(이자)
	this.getPayBackTargetDate = function(targetDate) {
		var loanStateItem = this.getLoanStateItemTargetDate(targetDate);
		return loanStateItem.getPaybackTotal();
	};
	// 특정 날짜의 남은 원금
	this.getRestLoanTargetDate = function(targetDate) {
		var loanStateItem = this.getLoanStateItemTargetDate(targetDate);
		return loanStateItem.getPrincipal();
	};
	if(isValid(parmObj)) return this.analysisLoan(parmObj);
};


var C_LOAN_GROUP = function(al_loanList) {
	this.loanList 	= [];	// 리스트 Type CLASS_LOAN
	// ol_loan_obj Type은 Class 형태여야함.
	this.addLoan	= function (ol_loanItem) {
		var cl_loanItem = new CLASS_LOAN(ol_loanItem);
		this.loanList.push(cl_loanItem);
	};
	this.addLoanGroup = function(al_loanList) {
		var clss = this;
		clss.loanList = [];
		$.each(al_loanList, function() {
			if(in_array(this.state, ["사용안함", "상환"])) return true;
			clss.loanList.push(this);
		});
	};
	/**
	 * 특정 loan item 가져오기
	 * return type : CLASS_LOAN 
	 */
	this.getLoanItem = function(idx) {
		return this.loanList[idx];
	};
	/**
	 * 특정 날자의 '원금 + 이자'에 대한 전체 부채 합(누적치는 아님)   
	 */
	this.getpaybackTotalEachMonth = function(targetDate) {
		var result = 0;
		if(isValid(targetDate)) {
			for ( var idx = 0; idx < al_loanList.length; idx++) {
				result += eval(this.loanList[idx].getClass().getPayBackTargetDate(targetDate));
			}
		} else {
			for ( var idx = 0; idx < al_loanList.length; idx++) {
				result += eval(this.loanList[idx].getPaybackEachMonth());
			}
		}
		return result;
	};
	this.getSumRestLoan = function(targetDate) {
		var sum = 0;

		$.each(this.loanList, function() {
			sum += this.getClass().getTotalInterest(10000);
		});
		
		return sum;
	};
	// 특정 날짜의 부채 상태를 반환한다.
	this.getLoanInfo = function(targetDate) {
		var resultLoanList 			= [];
		var principalTotal 			= 0;
		var paybackTotal 			= 0;
		var paybackPrincipalTotal 	= 0;
		var paybackInterestTotal 	= 0;
		
		$.each(this.loanList, function() {
			var loan 		= this;
			var loanState 	= loan.getClass().getLoanStateItemTargetDate(targetDate);
			var loanItem = {
				 loanType 			: loan.loanType
				,restLoan			: loanState.getPrincipal()
				,payback			: loanState.getPaybackTotal()
				,paybackPrincipal	: loanState.getPaybackPrincipal()
				,paybackInterest	: loanState.getPaybackInterest()
				,restLoanStr		: makeMoneyStr(loanState.getPrincipal())
				,paybackStr			: makeMoneyStr(loanState.getPaybackTotal())
			};
			resultLoanList.push(loanItem);
			principalTotal 			+= Number(loanItem.restLoan			);
			paybackPrincipalTotal 	+= Number(loanItem.paybackPrincipal	);
			paybackInterestTotal	+= Number(loanItem.paybackInterest	);
			paybackTotal 			+= Number(loanItem.payback			);
		});
		var result = {
			 loanList 					: resultLoanList
			,principalTotal				: principalTotal
			,paybackTotal				: paybackTotal
			,paybackPrincipalTotal		: paybackPrincipalTotal
			,paybackInterestTotal		: paybackInterestTotal
			,principalTotalStr			: makeMoneyStr(fn_fix(principalTotal	, 1))
			,paybackTotalStr			: makeMoneyStr(fn_fix(paybackTotal		, 1))
			,paybackPrincipalTotalStr	: addComma(fn_fix(paybackPrincipalTotal	, 1))
			,paybackInterestTotalStr	: addComma(fn_fix(paybackInterestTotal	, 1))
		}
		return result;
	}
	
	
	// 초기 세팅
	if(isValid(al_loanList)) this.addLoanGroup(al_loanList);
};
