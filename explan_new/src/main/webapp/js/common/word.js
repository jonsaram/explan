// 공통 Word
_COMMON_WORD_MAP = {
     START_DATE		: "가입일"
};

// 고객 관련
_WORD_LIST_MAP["CUSTOMER"] = {
	 CUSTOMER_NAME 		: "고객명"	    
	,BIRTHDAY 			: "생년월일"    
	,PHONE_NUM 			: "폰번호"	    
	,EMAIL 				: "이메일"	    
	,CREATE_DATE 		: "등록일"	    
	,PLAN_NAME 			: "플랜 이름"	
	,START_DATE 		: "플랜 기준일"	
	,CREATE_DATE 		: "등록일"	    
};

// 보험관련                         
_WORD_LIST_MAP["INSURANCE"] = {
	 INSURANCE_TYPE  	: "보험 종류"   
	,COMPANY_NAME    	: "보험사명"    
	,TITLE           	: "상품명"      
	,CONTRACTOR      	: "계약자"      
	,INSURED_NAME  		: "피보험자"    
	,INSURED_INFO  		: "피보험자(년생)"
	,INSURED_BIRTH_YEAR : "생년"        
	,INSURED_TYPE		: "주/종"       
	,PAY_EACH_MONTH  	: "월납입액"    
	,GUARANTEE_TERM  	: "보장기간"    
	,GUARANTEE_INFO  	: "보장기간"    
	,GUARANTEE_TERM_TYPE: "만기 Type"  
	,PAY_TERM        	: "납입기간"    
	,PAY_INFO        	: "납입기간"    
	,PAY_TERM_TYPE		: "납입 Type"   
	,COMMENT         	: "전문가 진단평가"
		                                
	// 보험 담보 관련                   
	,CATEGORY_NAME		: "담보 분류"   
	,DAMBO_NAME			: "담보명"      
	,INSURANCE_MONEY	: "보장금액"    
	,PIVOT_VALUE		: "Chart 기준값"
	,GROUP_NAME			: "담보그룹명"
	,BASE_CHECK			: "기본담보Check"
	,CHART_CHECK		: "Chart기준Check"
};

// 자산 관련
_WORD_LIST_MAP["INVESTMENT"] = {
	// 자산 공통
	 COMMENT          	: "비고"       
	
	// 금융자산 관련
	,INVESTMENT_NUM   	: "자산ID"                 
	,INVESTMENT_TYPE  	: "금융자산종류"                 
	,INVESTMENT_TITLE 	: "상품명"                 
	,END_TERM         	: "가입기간(만기)"                 
	,INTEREST_RATE    	: "이자율/예상수익률"                 
	,INTEREST_TYPE    	: "이자적용방식"                 
	,TAX              	: "과세Type"                 
	,TERM             	: "납입기간"                 
	,REGULAR_MONEY    	: "월납입액(원)"                 
	,BASE_MONEY       	: "거치금액(원)"                 
	,FEE				: "선취수수료(사업비)"	
	,NORMAL_FEE       	: "운영보수(%/년)"
	,SAVE_PLAN			: "추가 납입 계획"
	// 부동산 관련
	,IMMOVABLE_TYPE   	: "자산분류"
	,IMMOVABLE_NAME   	: "자산종류"
	,IMMOVABLE_VALUE  	: "현재가치/시세(만원)"
	,INFLATION_RATE   	: "자산가치 증가율(%)"
	,LOCATION         	: "위치(주소)"
	,START_DATE			: "취득일"
	// 부채 관련
	,LOAN_TYPE			: "부채종류"
	,LOAN_COMPANY		: "금융기관명"
	,LOAN_TOTAL		    : "대출금(총액)"
	,LOAN_RATE			: "상환금리(%)"
	,START_DATE		    : "대출시작일"
	,KUCHI_TERM		    : "거치기간"
	,PAYBACK_TERM		: "상환기간"
	,PAYBACK_TYPE		: "부채상환방식"
	,PAYBACK_EACH_MONTH : "월상환액(월이자)"
};	


// 전체 내용을 공통으로 합친다.
// 차후 _SVC_COM.getWordListMap([...]) 함수를 이용하여 원하는 word map을 반영하여 사용함.
{
	var wlist = {};
	$.each(_WORD_LIST_MAP, function(key, obj) {
		wlist = $.extend(wlist, obj);	
	});
	_COMMON_WORD_MAP = $.extend(wlist, _COMMON_WORD_MAP); 
}


