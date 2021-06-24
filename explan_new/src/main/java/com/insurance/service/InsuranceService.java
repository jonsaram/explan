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
package com.insurance.service;

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
import com.util.QueryAPI;

/**
 * This MovieServiceImpl class is an Implementation class to provide movie crud
 * functionality.
 * 
 * @author Sooyeon Park
 */
@Service("InsuranceService")
@Transactional(rollbackFor = { Exception.class }, propagation = Propagation.REQUIRED)
public class InsuranceService extends BaseService{
	
	@Inject
	@Named("CommonDao")
	private CommonDao commonDao;

	@Inject
	@Named("CommonService")
	private CommonService commonService;
	
	@SuppressWarnings({ "rawtypes", "unchecked" })
	public Map getCategoryList(Map map) throws Exception {
		resultList = (List<Map>)commonDao.getList("Insurance.getCategoryList", map);
		
		resultInfo = makeResult(BaseService.REQUEST_SUCCESS, "", resultList);
		
		return resultInfo;
	}
	@SuppressWarnings({ "rawtypes", "unchecked" })
	public Map getInsuranceList(Map map) throws Exception {
		resultList = (List<Map>)commonDao.getList("Insurance.getInsuranceList", map);
		
		resultInfo = makeResult(BaseService.REQUEST_SUCCESS, "", resultList);
		
		return resultInfo;
	}
	@SuppressWarnings({ "unchecked", "rawtypes" })
	public Map saveInsuranceList(Map map , HttpServletRequest request ) throws Exception {
		
		String keyName				= "INSURANCE_NUM"			;
		String tableName			= "T_FIN_INSURANCE"		;
		String financyType			= "M"						;
		String financyName			= "insurance"				;
		String financySaveQueryId	= "Insurance.saveInsurance";
		
		map.put("keyName"			, keyName					);
		map.put("tableName"			, tableName					);
		map.put("financyType"		, financyType				);
		map.put("financyListName"	, financyName + "List"		);
		map.put("financyDelListName", financyName + "DelList"	);
		map.put("financySaveQueryId", financySaveQueryId		);
		
		List<Map> insuranceList = commonService.saveFinancyList(map);
		
		for (Map insurance : insuranceList) {
			String insuranceNum = String.valueOf(insurance.get("INSURANCE_NUM"));

			// 피보험자 삭제
			commonDao.update("Insurance.deleteInsured"		, insurance);

			String insuredInfo 		= String.valueOf(insurance.get("INSURED_INFO"));
			if(insuredInfo != null) {
				String [] insuredArry = insuredInfo.split(",");
				int ii = 1;
				for (String insuredItem : insuredArry) {
					Map insuredMap = new HashMap();
					String [] insuredItemArry = insuredItem.split("/");
					insuredMap.put("INSURANCE_NUM"		, insuranceNum);
					insuredMap.put("INSURED_NUM"		, ii++);
					insuredMap.put("INSURED_NAME"		, insuredItemArry[0]);
					insuredMap.put("INSURED_BIRTH_YEAR"	, insuredItemArry[1]);
					
					commonDao.update("Insurance.saveInsured", insuredMap);
				}
			}
		}
		
		resultInfo = makeResult(BaseService.REQUEST_SUCCESS, "", null);
		
		return resultInfo;
	}
	@SuppressWarnings({ "unchecked", "rawtypes" })
	public Map saveInsuranceDamboList(Map map , HttpServletRequest request ) throws Exception {

		String insuranceNum 	= String.valueOf(map.get("INSURANCE_NUM"));
		String insuredNum 		= String.valueOf(map.get("INSURED_NUM"));
		List<Map> damboInfoList = (List<Map>)map.get("damboInfoList");
		
		// 기존 담보값 삭제
		commonDao.update("Insurance.deleteInsuranceDambo", map);
		for (Map damboInfoMap : damboInfoList) {
			String insuranceDamboNum = CommonAPI.makeUniqueID();
			damboInfoMap.put("INSURANCE_DAMBO_NUM"	, insuranceDamboNum	);
			damboInfoMap.put("INSURANCE_NUM"		, insuranceNum		);
			damboInfoMap.put("INSURED_NUM"			, insuredNum		);
			commonDao.update("Insurance.saveInsuranceDambo", damboInfoMap);
		}
		return resultInfo;
	}
	@SuppressWarnings({ "rawtypes" })
	public Map getInsuranceDamboList(Map map) throws Exception {
		resultList = (List<Map>)commonDao.getList("Insurance.getInsuranceDamboList", map);
		
		resultInfo = makeResult(BaseService.REQUEST_SUCCESS, "", resultList);
		
		return resultInfo;
	}
	@SuppressWarnings({ "unchecked", "rawtypes" })
	public Map saveUserDamboList(Map map , HttpServletRequest request ) throws Exception {
		String loginId = CommonAPI.getLoginId(request);
		List<Map> userDamboList = (List<Map>)map.get("userDamboList");
		map = QueryAPI.searchToQuery(map, "deleteDamboList", "DAMBO_NUM");
		// 기존 사용자 담보 삭제
		commonDao.update("Insurance.deleteUserDamboList", map);
		
		for (Map userDamboMap : userDamboList) {
			String damboNum 	= String.valueOf(userDamboMap.get("DAMBO_NUM"));
			if(!CommonAPI.isValid(damboNum)) {
				damboNum = CommonAPI.makeUniqueID();
				userDamboMap.put("DAMBO_NUM", damboNum	);
			}
			userDamboMap.put("USER_ID", loginId	);
			commonDao.update("Insurance.saveUserDamboList", userDamboMap);
		}
		resultInfo = makeResult(BaseService.REQUEST_SUCCESS, "", null);
		return resultInfo;
	}
	/**
	 * 담보 그룹의 담보 리스트를 저장한다.
	 * @param map
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings({ "unchecked", "rawtypes" })
	public Map saveDamboGroupList(Map map , HttpServletRequest request ) throws Exception {
		String loginId = CommonAPI.getLoginId(request);
		
		map.put("userId", loginId	);
		String groupNum	 		= String.valueOf(map.get("GROUP_NUM"	));
		List<Map> damboGroupList = (List<Map>)map.get("damboGroupList"	);
		
		// 기존 담보 리스트 삭제
		commonDao.update("Insurance.deleteDamboGroupList", map);
		for (Map damboGroupMap : damboGroupList) {
			String pivotValue = String.valueOf(damboGroupMap.get("PIVOT_VALUE"	));
			damboGroupMap.put("USER_ID"		, loginId	);
			damboGroupMap.put("GROUP_NUM"	, groupNum	);
			damboGroupMap.put("PIVOT_VALUE"	, pivotValue);
			commonDao.update("Insurance.saveDamboGroupList", damboGroupMap);
		}
		resultInfo = makeResult(BaseService.REQUEST_SUCCESS, "", null);
		return resultInfo;
	}
	/**
	 * 담보 그룹의 정보(그룹명)을 가져온다.
	 * @param map
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings({ "rawtypes" })
	public Map getDamboGroupInfoList(Map map) throws Exception {
		resultList = (List<Map>)commonDao.getList("Insurance.getDamboGroupInfoList", map);
		
		resultInfo = makeResult(BaseService.REQUEST_SUCCESS, "", resultList);
		
		return resultInfo;
	}
	/**
	 * 담보 그룹의 정보(그룹명)을 저장한다.
	 * @param map
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings({ "unchecked", "rawtypes" })
	public Map saveDamboGroupInfoList(Map map , HttpServletRequest request ) throws Exception {

		String loginId = CommonAPI.getLoginId(request);

		List<Map> damboGroupInfoList = (List<Map>)map.get("damboGroupInfoList");
		
		map = QueryAPI.searchToQuery(map, "deleteDamboGroupInfoList", "GROUP_NUM");
		
		// 기존 사용자 담보 삭제
		commonDao.update("Insurance.deleteDamboGroupInfoList", map);
		
		for (Map damboGroupInfoMap : damboGroupInfoList) {
			String groupNum 	= String.valueOf(damboGroupInfoMap.get("GROUP_NUM")		);
			String baseCheck 	= String.valueOf(damboGroupInfoMap.get("BASE_CHECK")	);
			String chartCheck 	= String.valueOf(damboGroupInfoMap.get("CHART_CHECK")	);
			if(!CommonAPI.isValid(groupNum)) {
				groupNum = CommonAPI.makeUniqueID();
				damboGroupInfoMap.put("GROUP_NUM"	, groupNum	);
				damboGroupInfoMap.put("BASE_CHECK"	, baseCheck	);
				damboGroupInfoMap.put("CHART_CHECK"	, chartCheck);
			}
			damboGroupInfoMap.put("USER_ID", loginId	);
			commonDao.update("Insurance.saveDamboGroupInfoList", damboGroupInfoMap);
		}
		resultInfo = makeResult(BaseService.REQUEST_SUCCESS, "", null);
		return resultInfo;
	}
	/**
	 * 선택한 보험을 현재 플랜으로 Import(Copy)한다.
	 * @param map
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings({ "unchecked", "rawtypes" })
	public Map copyInsuranceList(Map map , HttpServletRequest request ) throws Exception {

		String planNum = String.valueOf(map.get("PLAN_NUM"));
		List<Map> insuranceNumList = (List<Map>)map.get("insuranceNumList");
		
		for (Map insuranceNumMap : insuranceNumList) {
			
			String newInsuranceNum	= CommonAPI.makeUniqueID();
			
			insuranceNumMap.put("PLAN_NUM"			, planNum			);
			insuranceNumMap.put("newInsuranceNum"	, newInsuranceNum	);
			
			commonDao.update("Insurance.copyInsurance", insuranceNumMap);

			commonDao.update("Insurance.copyInsured", insuranceNumMap);

			commonDao.update("Insurance.copyDambo", insuranceNumMap);
			
			insuranceNumMap.put("FINANCY_NUM"	, newInsuranceNum);
			insuranceNumMap.put("FINANCY_TYPE"	, "I");
			
			resultInfo = commonService.registFinancyItem(insuranceNumMap);
		}
		resultInfo = makeResult(BaseService.REQUEST_SUCCESS, "", null);
		return resultInfo;
	}
}
