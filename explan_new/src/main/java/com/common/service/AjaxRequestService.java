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
package com.common.service;

import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;
import javax.servlet.http.HttpServletRequest;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import org.springframework.stereotype.Service;

import com.CommonAPI;
import com.customer.service.CustomerService;
import com.insurance.service.InsuranceService;
import com.investment.service.InvestmentService;
import com.sample.service.SampleService;
import com.util.JsonUtil;

/**
 * This MovieServiceImpl class is an Implementation class to provide movie crud
 * functionality.
 * 
 * @author Sooyeon Park
 */
@Service("AjaxRequestService")
public class AjaxRequestService {
	
	@Inject
	@Named("SampleService")
	private SampleService sampleService;

	@Inject
	@Named("CustomerService")
	private CustomerService customerService;

	@Inject
	@Named("InsuranceService")
	private InsuranceService insuranceService;

	@Inject
	@Named("InvestmentService")
	private InvestmentService investmentService;

	@Inject
	@Named("CommonService")
	private CommonService commonService;

	/**
	 * 요청된 Ajax 서비스 결과 취합.
	 * @param jsonString
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings({ "rawtypes", "unchecked" })
	public JSONObject getSeviceResponse(String jsonString, HttpServletRequest request) throws Exception {
		
		JSONObject jsonObject 	= JsonUtil.unmarshallingJson(jsonString, JSONObject.class);
		
		JSONArray serviceList	= (JSONArray)jsonObject.get("serviceList");
		
		JSONObject jsonResult	= new JSONObject();
		for (Object object : serviceList) {
			Map<String, Object> map = (Map<String, Object>)object;
			String serviceName 		= (String)map.get("serviceName");
			try {
				JSONObject sendParam	= (JSONObject)map.get("sendParam");
				Map sendParamMap		= JsonUtil.unmarshallingJson(sendParam.toString(), Map.class);
				Map resultMap			= requestService(serviceName, sendParamMap, request);
				if(resultMap == null) {
					resultMap = BaseService.makeResult(BaseService.REQUEST_FAIL, "No Service!", null);
				}
				jsonResult.put(serviceName, resultMap);
			} catch (Exception e) {
				e.printStackTrace();
				Map resultInfo = BaseService.makeResult(BaseService.REQUEST_FAIL, "System Error!", null);
				jsonResult.put(serviceName, resultInfo);
			}
		}
		return jsonResult;
	}
	public JSONObject getSeviceResponseByForm(String serviceName, HttpServletRequest request) throws Exception {
		return null;
	}
	/**
	 * 실제 Ajax 요청 처리 실행
	 * 새로운 Service 등록시 이곳에서 한다.
	 * @param serviceName
	 * @param sendParam
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings({ "unchecked", "rawtypes" })
	public Map requestService(String serviceName, Map sendParam, HttpServletRequest request) throws Exception {
		// 기본 로그인 정보를 담는다.
		String loginId = CommonAPI.getLoginId(request);
		sendParam.put("USER_ID", loginId);
		
		Map returnData = null;
		/**
		 * SAMPLE
		 */
		if		("GET_LIST_SAMPLE"			.equals(serviceName)) returnData = sampleService.getSample					(sendParam, request);
		/**
		 * Common Service
		 */
		// DD 리스트
		else if	("GET_DD_LIST"				.equals(serviceName)) returnData = commonService.getDDList					(sendParam);
		else if	("GET_PLAN_LIST"			.equals(serviceName)) returnData = commonService.getPlanList				(sendParam);
		else if	("GET_MENU_LIST"			.equals(serviceName)) returnData = commonService.getMenuList				(sendParam);
		else if	("SAVE_PLAN_LIST"			.equals(serviceName)) returnData = commonService.savePlanList				(sendParam, request);
		else if("GET_COMMON"				.equals(serviceName)) returnData = commonService.getCommon					(sendParam, request);
		else if("UPDATE_COMMON"				.equals(serviceName)) returnData = commonService.updateCommon				(sendParam, request);
		/**
		 * CUSTOMER
		 */
		else if	("SAVE_CUSTOMER_LIST"		.equals(serviceName)) returnData = customerService.saveCustomerList			(sendParam, request);
		/**
		 * INSURANCE
		 */
		else if	("GET_CATEGORY_LIST"		.equals(serviceName)) returnData = insuranceService.getCategoryList			(sendParam);
		else if	("GET_INSURANCE_LIST"		.equals(serviceName)) returnData = insuranceService.getInsuranceList		(sendParam);
		else if	("SAVE_INSURANCE_LIST"		.equals(serviceName)) returnData = insuranceService.saveInsuranceList		(sendParam, request);
		else if	("SAVE_INSURANCE_DAMBO_LIST".equals(serviceName)) returnData = insuranceService.saveInsuranceDamboList	(sendParam, request);
		else if	("GET_INSURANCE_DAMBO_LIST"	.equals(serviceName)) returnData = insuranceService.getInsuranceDamboList	(sendParam);
		else if	("SAVE_USER_DAMBO_LIST"		.equals(serviceName)) returnData = insuranceService.saveUserDamboList		(sendParam, request);
		else if	("SAVE_DAMBO_GROUP_LIST"	.equals(serviceName)) returnData = insuranceService.saveDamboGroupList		(sendParam, request);
		else if	("GET_DAMBO_GROUP_INFO_LIST".equals(serviceName)) returnData = insuranceService.getDamboGroupInfoList	(sendParam);
		else if	("SAVE_DAMBO_GROUP_INFO_LIST".equals(serviceName))returnData = insuranceService.saveDamboGroupInfoList	(sendParam, request);
		else if	("COPY_INSURANCE_LIST"		.equals(serviceName)) returnData = insuranceService.copyInsuranceList		(sendParam, request);
		/**
		 * INVESTMENT
		 */
		else if	("SAVE_INVESTMENT_LIST"		.equals(serviceName)) returnData = investmentService.saveInvestmentList		(sendParam, request);
		else if	("SAVE_IMMOVABLE_LIST"		.equals(serviceName)) returnData = investmentService.saveImmovableList		(sendParam, request);
		else if	("SAVE_LOAN_LIST"			.equals(serviceName)) returnData = investmentService.saveLoanList			(sendParam, request);
		else if	("SAVE_CASHFLOW_LIST"		.equals(serviceName)) returnData = investmentService.saveCashflowList		(sendParam, request);
		else if	("COPY_INVESTMENT_LIST"		.equals(serviceName)) returnData = investmentService.copySelectInvestment	(sendParam, request);
		else if	("COPY_IMMOVABLE_LIST"		.equals(serviceName)) returnData = investmentService.copySelectImmovable	(sendParam, request);
		else if	("COPY_LOAN_LIST"			.equals(serviceName)) returnData = investmentService.copySelectLoan	(sendParam, request);
		return returnData;
	}
}
