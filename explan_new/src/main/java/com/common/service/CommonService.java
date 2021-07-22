package com.common.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;
import javax.servlet.http.HttpServletRequest;

import org.springframework.stereotype.Service;

import com.CommonAPI;
import com.common.dao.CommonDao;
import com.insurance.service.InsuranceService;
import com.investment.service.InvestmentService;
import com.util.QueryAPI;

/**
 * This MovieServiceImpl class is an Implementation class to provide movie crud
 * functionality.
 * 
 * @author Sooyeon Park
 */
@Service("CommonService")
public class CommonService extends BaseService {
	
	@Inject
	@Named("CommonDao")
	private CommonDao commonDao;

	@Inject
	@Named("InsuranceService")
	private InsuranceService insuranceService;

	@Inject
	@Named("InvestmentService")
	private InvestmentService investmentService;

	@SuppressWarnings("rawtypes")
	public List<Map> getPageInfoList() throws Exception {
		List<Map> lm = (List<Map>)commonDao.getList("Common.getPageInfoList", null);
		return lm;
	}
	/**
	 * DD 리스트를 가져온다.
	 * @param obj
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings({ "rawtypes"})
	public Map getDDList(Map map) throws Exception {
		
		map = QueryAPI.searchToQuery	(map, "COMMON_TCD");
		
		resultList = (List<Map>)commonDao.getList("Common.getDDList", map);
		resultInfo = makeResult(BaseService.REQUEST_SUCCESS, "", resultList);
		return resultInfo;
	}
	/**
	 * Plan 리스트를 가져온다.
	 * @param obj
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings({ "rawtypes", "unchecked"})
	public Map getPlanList(Map map) throws Exception {
		resultList = (List<Map>)commonDao.getList("Common.getPlanList", map);
		
		if(resultList.size() == 0) {
			//Plan이 없는 경우 플랜을 등록한다.
			String planNum = CommonAPI.makeUniqueID();
			String startDate = CommonAPI.getToday("yyyyMMdd");
			map.put("PLAN_NUM"		, planNum	);
			map.put("VERSION_SEQ"	, "1"		);
			map.put("PLAN_NAME"		, "기본플랜");
			map.put("PLAN_TYPE"		, "기본"	);
			map.put("START_DATE"	, startDate	);
			map.put("PLAN_DATE"		, startDate	);
			
			commonDao.update("Common.savePlanList", map);

			resultList = (List<Map>)commonDao.getList("Common.getPlanList", map);
		}
		
		resultInfo = makeResult(BaseService.REQUEST_SUCCESS, "", resultList);
		return resultInfo;
	}
	@SuppressWarnings({ "unchecked", "rawtypes" })
	public Map savePlanList(Map map, HttpServletRequest request) throws Exception {
		
		List<Map> planList = (List<Map>)map.get("planList");
		
		String customerNum = String.valueOf(map.get("customerNum"));
		
		// 삭제 대상 List
		List deletedPlanNumList = (List)map.get("deletedPlanNumList");
		if(CommonAPI.isValid(deletedPlanNumList)) {
			for (Object delPlanNum : deletedPlanNumList) {
				if(!CommonAPI.isValid(delPlanNum)) continue;
				commonDao.update("Common.deletePlan", delPlanNum);
			}
		}
		for (Map plan : planList) {
			String planNum 		= String.valueOf(plan.get("PLAN_NUM"));
			String basePlanNum	= String.valueOf(plan.get("BASE_PLAN_NUM"));
			String planType	= String.valueOf(plan.get("PLAN_TYPE"));
			
			// 신규
			if("".equals(planNum)){
				// Plan 등록
				planNum = CommonAPI.makeUniqueID();
				plan.put		("PLAN_NUM"				, planNum		);
				plan.put		("CUSTOMER_NUM"			, customerNum	);
				commonDao.update("Common.savePlanList"	, plan			);
				
				// 제안
				if("제안".equals(planType)) {
					// copy
					copyPlanRelationItem(basePlanNum, planNum, request);			
				}
			}
			// 기존
			else {
				if("제안".equals(planType)) {
					// 기존 Plan 삭제
					commonDao.update("Common.deletePlan", planNum);
					
					// 새플랜 등록
					planNum = CommonAPI.makeUniqueID();
					plan.put		("PLAN_NUM"				, planNum		);
					plan.put		("CUSTOMER_NUM"			, customerNum	);
					commonDao.update("Common.savePlanList"	, plan			);

					// copy
					
				}  else {
					// Plan 수정(단순)
					plan.put		("PLAN_NUM"				, planNum		);
					plan.put		("CUSTOMER_NUM"			, customerNum	);
					commonDao.update("Common.savePlanList"	, plan			);
				}
			}
			
			// 신규이거나 제안인 경우
			if("".equals(planNum) || "제안".equals(planType)){
				planNum = CommonAPI.makeUniqueID();
				plan.put("PLAN_NUM", planNum);
			}
			
			// Plan 연계 Data Copy(제안인경우에만 Copy를 진행 한다.)
			if("제안".equals(planType)) {
				
			}
			makeResult(BaseService.REQUEST_SUCCESS, "", null);
		}
		
		return resultInfo;
	}
	@SuppressWarnings({ "rawtypes" })
	public Map getMenuList(Map map) throws Exception {
		resultList = (List<Map>)commonDao.getList("Common.getMenuList", map);

		resultInfo = makeResult(BaseService.REQUEST_SUCCESS, "", resultList);
		
		return resultInfo;
	}
	@SuppressWarnings({ "rawtypes" })
	public Map getCommon(Map map , HttpServletRequest request ) throws Exception {
		
		resultList = getCommonDao(map , request);
		
		resultInfo = makeResult(BaseService.REQUEST_SUCCESS, "", resultList);
		
		return resultInfo;
	}
	@SuppressWarnings("unchecked")
	public List<Map> getCommonDao(Map map , HttpServletRequest request ) throws Exception {
		
		String loginId = CommonAPI.getLoginId(request);
		
		String sqlId	= (String)map.get("sqlId");
		
		map.put("USER_ID", loginId);
		
		resultList = (List<Map>)commonDao.getList(sqlId, map);
		
		return resultList;
	}
	@SuppressWarnings({ "rawtypes", "unchecked" })
	public Map updateCommon(Map map , HttpServletRequest request ) throws Exception {
		
		String loginId = CommonAPI.getLoginId(request);
		
		String sqlId	= (String)map.get("sqlId");
		
		map.put("USER_ID", loginId);
		
		resultList = (List<Map>)commonDao.getList(sqlId, map);
		
		resultInfo = makeResult(BaseService.REQUEST_SUCCESS, "", resultList);
		
		return resultInfo;
	}
	/**
	 * 금융 자산 저장 공통.
	 * @param map
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings({ "unchecked", "rawtypes" })
	public List<Map> saveFinancyList(Map map ) throws Exception {
		
		String keyName				= String.valueOf(map.get("keyName"				));
		String tableName			= String.valueOf(map.get("tableName"			));
		String financyType			= String.valueOf(map.get("financyType"			));
		String financyListName  	= String.valueOf(map.get("financyListName"		));
		String financyDelListName	= String.valueOf(map.get("financyDelListName"	));
		String financySaveQueryId	= String.valueOf(map.get("financySaveQueryId"	));
		
		List<Map> financyList 	= (List<Map>)map.get(financyListName);
		// 삭제 대상 List
		//List deletedInvestmentNumList = (List)map.get("deletedInvestmentNumList");
		List financyDelList = (List)map.get(financyDelListName);
		// 공통 삭제 Method 호출
		deleteCommonTable(financyDelList, tableName, keyName );	
		
		String planNum = String.valueOf(map.get("planNum"));
		
		// 금융자산 저장
		for (Map financy : financyList) {
			String financyNum 	= String.valueOf(financy.get(keyName	));
			if(financyNum == null || "".equals(financyNum) || "null".equals(financyNum)) {
				// 신규
				financyNum = CommonAPI.makeUniqueID();
				financy.put(keyName, financyNum	);
			}
			commonDao.update(financySaveQueryId, financy);
		}
		// Plan 연결
		registFinancyItemList(financyList, planNum, keyName, financyType );
		
		return financyList;
	}
	// 금융자산 List를 Plan과 매칭 시킨다.
	@SuppressWarnings({ "rawtypes", "unchecked" })
	public void registFinancyItemList(List<Map> financyItemList, String planNum, String keyName, String financyType) throws Exception {
		for (Map financyItem : financyItemList) {
			String financyItemNum 	= String.valueOf(financyItem.get(keyName));
			if(!"".equals(financyItemNum)) {
				financyItem.put("PLAN_NUM"		, planNum);
				financyItem.put("FINANCY_NUM"	, financyItemNum);
				financyItem.put("FINANCY_TYPE"	, financyType);
				resultInfo = registFinancyItem(financyItem);
			}
		}
	}
	// 금융자산을 Plan과 매칭 시킨다.
	@SuppressWarnings({ "rawtypes" })
	public Map registFinancyItem(Map financyMap) throws Exception {
		
		commonDao.update("Common.linkInvestmentToPlan"	, financyMap);
		
		resultInfo = makeResult(BaseService.REQUEST_SUCCESS, "", resultList);
		
		return resultInfo;
	}
	
	// Table Item 공통 삭제
	@SuppressWarnings({ "rawtypes", "unchecked" })
	public void deleteCommonTable(List deleteNumList, String tableName, String keyName ) throws Exception {
		String deleteNumListStr = null;
		if(CommonAPI.isValid(deleteNumList)) {
			for (Object delItemNum : deleteNumList) {
				if(!CommonAPI.isValid(delItemNum)) continue;
				if(deleteNumListStr == null)	deleteNumListStr  = 	  delItemNum.toString();
				else							deleteNumListStr += "," + delItemNum.toString();
			}
		}
		deleteNumListStr = QueryAPI.searchToString(deleteNumListStr, keyName);
		if(!"".endsWith(deleteNumListStr)) {
			Map map = new HashMap();
			map.put("deleteNumListStr"	, deleteNumListStr);
			map.put("tableName"			, tableName);
			commonDao.update("Common.deleteCommonTable", map);
		}
	}
	// Plan제한시 기본 등록 자산 Copy
	@SuppressWarnings("rawtypes")
	public void copyPlanRelationItem(String srcPlanNum, String targetPlanNum, HttpServletRequest request) throws Exception {
		// 보험 Copy
		HashMap<String, Object> map = new HashMap<String, Object>();
		map.put("srcPlanNum"	, srcPlanNum	);
		map.put("targetPlanNum"	, targetPlanNum	);
		map.put("planNum"		, srcPlanNum	);
		resultList = (List<Map>)commonDao.getList("Insurance.getInsuranceList", map);
		
		// 기존 보험을 읽어서 새로운 Plan으로 저장
		HashMap<String, Object> newMap = new HashMap<String, Object>();
		newMap.put("insuranceNumList", resultList);
		newMap.put("PLAN_NUM", targetPlanNum);
		insuranceService.copyInsuranceList(newMap, request);		
		
		// 자산 Copy
		investmentService.copyInvestmentList(map, request);
	}
	// 회원 등록
	@SuppressWarnings({ "rawtypes", "unchecked" })
	public void registProcess(Map map) throws Exception {
		String damboGroupNum = CommonAPI.makeUniqueID();
		map.put("GROUP_NUM", damboGroupNum);
		commonDao.update("Common.registProcess"			, map);
		commonDao.update("Common.baseSetDamboGroupInfo"	, map);
		commonDao.update("Common.baseSetDamboGroup"		, map);
	}
}
