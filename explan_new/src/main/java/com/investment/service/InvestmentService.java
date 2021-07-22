/*
* Copyright 2008-2012 the original author or authors.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package com.investment.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;
import javax.servlet.http.HttpServletRequest;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.CommonAPI;
import com.common.dao.CommonDao;
import com.common.service.BaseService;
import com.common.service.CommonService;

/**
 * This MovieServiceImpl class is an Implementation class to provide movie crud
 * functionality.
 * 
 * @author Sooyeon Park
 */
@Service("InvestmentService")
@Transactional(rollbackFor = { Exception.class }, propagation = Propagation.REQUIRED)
public class InvestmentService extends BaseService{
	
	@Inject
	@Named("CommonDao")
	private CommonDao commonDao;

	@Inject
	@Named("CommonService")
	private CommonService commonService;
	
	@SuppressWarnings({ "unchecked", "rawtypes" })
	public Map saveInvestmentList(Map map , HttpServletRequest request ) throws Exception {
		String keyName				= "INVESTMENT_NUM"			;
		String tableName			= "T_FIN_INVESTMENT"		;
		String financyType			= "V"						;
		String financyName			= "investment"				;
		String financySaveQueryId	= "Investment.saveInvestment";
		
		map.put("keyName"			, keyName					);
		map.put("tableName"			, tableName					);
		map.put("financyType"		, financyType				);
		map.put("financyListName"	, financyName + "List"		);
		map.put("financyDelListName", financyName + "DelList"	);
		map.put("financySaveQueryId", financySaveQueryId		);
		
		List<Map> investmentList = commonService.saveFinancyList(map);
		
		//
		// 추가 저장 처리
		//
		for (Map investment : investmentList) {
			// 부Data 처리
			String investmentType 	= String.valueOf(investment.get("INVESTMENT_TYPE"	));
			if(
				"펀드".equals(investmentType) || 
				"보험".equals(investmentType) 
			) {
				commonDao.update("Investment.saveInvestmentSubdata", investment);
			}
		}

		resultInfo = makeResult(BaseService.REQUEST_SUCCESS, "", null);
		
		return resultInfo;
	}
	@SuppressWarnings({ "unchecked", "rawtypes" })
	public Map saveImmovableList(Map map , HttpServletRequest request ) throws Exception {
		String keyName				= "IMMOVABLE_NUM"			;
		String tableName			= "T_FIN_IMMOVABLE"			;
		String financyType			= "M"						;
		String financyName			= "immovable"				;
		String financySaveQueryId	= "Investment.saveImmovable";
		
		map.put("keyName"			, keyName					);
		map.put("tableName"			, tableName					);
		map.put("financyType"		, financyType				);
		map.put("financyListName"	, financyName + "List"		);
		map.put("financyDelListName", financyName + "DelList"	);
		map.put("financySaveQueryId", financySaveQueryId		);
		
		commonService.saveFinancyList(map);
		
		resultInfo = makeResult(BaseService.REQUEST_SUCCESS, "", null);
		
		return resultInfo;
	}

	@SuppressWarnings({ "unchecked", "rawtypes" })
	public Map saveLoanList(Map map , HttpServletRequest request ) throws Exception {
		String keyName				= "LOAN_NUM";
		String tableName			= "T_FIN_LOAN";
		String financyType			= "L";
		String financyName			= "loan";
		String financySaveQueryId	= "Investment.saveLoan";

		map.put("keyName"			, keyName					);
		map.put("tableName"			, tableName					);
		map.put("financyType"		, financyType				);
		map.put("financyListName"	, financyName + "List"		);
		map.put("financyDelListName", financyName + "DelList"	);
		map.put("financySaveQueryId", financySaveQueryId		);

		commonService.saveFinancyList(map);

		resultInfo = makeResult(BaseService.REQUEST_SUCCESS, "", null);

		return resultInfo;
	}

	@SuppressWarnings({ "unchecked", "rawtypes" })
	public Map saveCashflowList(Map map , HttpServletRequest request ) throws Exception {
		List<Map> 	cashflowList 	= (List<Map>)map.get("cashflowList");
		String 		planNum 		= String.valueOf(map.get("planNum"));

		for (Map cashflow : cashflowList) {
			cashflow.put("PLAN_NUM", planNum);
			commonDao.update("Investment.saveCashflow", cashflow);
		}
		resultInfo = makeResult(BaseService.REQUEST_SUCCESS, "", null);
		return resultInfo;
	}
	
	@SuppressWarnings({ "rawtypes", "unchecked" })
	public Map copyInvestmentList(Map map, HttpServletRequest request) throws Exception {
		
		String srcPlanNum 		= String.valueOf(map.get("srcPlanNum"	));
		String targetPlanNum 	= String.valueOf(map.get("targetPlanNum"));
		
		// 투자자산 리스트를 읽어 온다.
		map.put("planNum"		, srcPlanNum	);
		map.put("targetPlanNum"	, targetPlanNum	);
		map.put("exceptKey"	, "Y");
		Map copyInfoMap = new HashMap();
		copyInfoMap.put("planNum"		, targetPlanNum	);
		
		//
		// 금융자산 Copy
		//
		map.put("sqlId"		, "getInvestmentList");
		List<Map> financyList = commonService.getCommonDao(map, request);
		copyInfoMap.put("investmentList", financyList);
		resultInfo = saveInvestmentList(copyInfoMap, request);
		
		//
		// 부동산자산 Copy
		//
		map.put("sqlId"		, "getImmovableList");
		financyList = commonService.getCommonDao(map, request);
		copyInfoMap.put("immovableList" , financyList);
		resultInfo = saveImmovableList(copyInfoMap, request);
		
		//
		// 부채 Copy
		//
		map.put("sqlId", "getLoanList");
		financyList = commonService.getCommonDao(map, request);
		copyInfoMap.put("loanList", financyList);
		resultInfo = saveLoanList(copyInfoMap, request);

		// Cashflow copy
		commonDao.update("Investment.copyCashflow", map);

		return resultInfo;
	}
	
	/**
	 * 선택한 금융상품 현재 플랜으로 Import(Copy)한다.
	 * @param map
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings({ "unchecked", "rawtypes" })
	public Map copySelectInvestment(Map map , HttpServletRequest request ) throws Exception {

		String planNum = String.valueOf(map.get("PLAN_NUM"));
		List<Map> investmentNumList = (List<Map>)map.get("investmentNumList");
		String subId = (Integer)map.get("subId") + "";
		
		for (Map investmentNumMap : investmentNumList) {
			
			String newInvestmentNum	= CommonAPI.makeUniqueID();
			
			investmentNumMap.put("PLAN_NUM"			, planNum			);
			investmentNumMap.put("newInvestmentNum"	, newInvestmentNum	);
			
			commonDao.update("Investment.copyInvestment", investmentNumMap);
			
			if(!subId.equals("1")) {
				commonDao.update("Investment.copyInvestmentSubdata", investmentNumMap);
			}

			investmentNumMap.put("FINANCY_NUM"	, newInvestmentNum);
			investmentNumMap.put("FINANCY_TYPE"	, "V");
			
			resultInfo = commonService.registFinancyItem(investmentNumMap);
		}
		resultInfo = makeResult(BaseService.REQUEST_SUCCESS, "", null);
		return resultInfo;
	}
	/**
	 * 선택한 부동산을 현재 플랜으로 Import(Copy)한다.
	 * @param map
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings({ "unchecked", "rawtypes" })
	public Map copySelectImmovable(Map map , HttpServletRequest request ) throws Exception {

		String planNum = String.valueOf(map.get("PLAN_NUM"));
		List<Map> immovableNumList = (List<Map>)map.get("immovableNumList");
		String subId = (Integer)map.get("subId") + "";
		
		for (Map immovableNumMap : immovableNumList) {
			
			String newImmovableNum	= CommonAPI.makeUniqueID();
			
			immovableNumMap.put("PLAN_NUM"			, planNum			);
			immovableNumMap.put("newImmovableNum"	, newImmovableNum	);
			
			commonDao.update("Investment.copyImmovable", immovableNumMap);
			
			immovableNumMap.put("FINANCY_NUM"	, newImmovableNum);
			immovableNumMap.put("FINANCY_TYPE"	, "M");
			
			resultInfo = commonService.registFinancyItem(immovableNumMap);
		}
		resultInfo = makeResult(BaseService.REQUEST_SUCCESS, "", null);
		return resultInfo;
	}
	
	/**
	 * 선택한 부채를 현재 플랜으로 Import(Copy)한다.
	 * @param map
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings({ "unchecked", "rawtypes" })
	public Map copySelectLoan(Map map , HttpServletRequest request ) throws Exception {

		String planNum = String.valueOf(map.get("PLAN_NUM"));
		List<Map> loanNumList = (List<Map>)map.get("loanNumList");
		String subId = (Integer)map.get("subId") + "";
		
		for (Map loanNumMap : loanNumList) {
			
			String newLoanNum	= CommonAPI.makeUniqueID();
			
			loanNumMap.put("PLAN_NUM"			, planNum		);
			loanNumMap.put("newLoanNum"			, newLoanNum	);
			
			commonDao.update("Investment.copyLoan", loanNumMap);
			
			loanNumMap.put("FINANCY_NUM"	, newLoanNum);
			loanNumMap.put("FINANCY_TYPE"	, "L");
			
			resultInfo = commonService.registFinancyItem(loanNumMap);
		}
		resultInfo = makeResult(BaseService.REQUEST_SUCCESS, "", null);
		return resultInfo;
	}
	
}
