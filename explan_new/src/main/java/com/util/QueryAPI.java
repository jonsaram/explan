package com.util;

import java.util.Map;

import com.CommonAPI;


public class QueryAPI {

	/**
	 * multi box 쿼리 가공
	 * itemName이 하나인 경우 'LIKE' 검색
	 * itemName이 다수인 경우 'IN' 검색
	 * @return
	 */
	@SuppressWarnings("rawtypes")
	public static Map multiBoxToQuery(Map targetMap, String itemName) {
		return multiBoxToQuery(targetMap, itemName, itemName);
	}
	@SuppressWarnings({ "unchecked", "rawtypes" })
	public static Map multiBoxToQuery(Map targetMap, String itemName, String renameItem) {
		String itemQuery = (String)targetMap.get(itemName);
		if(CommonAPI.isValid(itemQuery)) {
			itemQuery = itemQuery.replaceAll("'", "");
			int splitCnt = itemQuery.split(",").length;
			if(splitCnt == 1) {
				String finalQuery = "AND " + renameItem + " LIKE '%" + itemQuery + "%'";
				targetMap.put(itemName, finalQuery);
			} else if(splitCnt > 1) {
				String finalQuery = "AND " + renameItem + " IN (" + CommonAPI.wrapToQuotes(itemQuery) + ")";
				targetMap.put(itemName, finalQuery);
			}
		}
		return targetMap;
	}
	@SuppressWarnings({ "rawtypes" })
	public static Map searchToQuery(Map targetMap, String itemName) {
		return searchToQuery(targetMap, itemName, itemName);
	}
	@SuppressWarnings({ "unchecked", "rawtypes" })
	public static Map searchToQuery(Map targetMap, String itemName, String renameItem) {
		String itemQuery = (String)targetMap.get(itemName);
		if(CommonAPI.isValid(itemQuery)) {
			itemQuery = itemQuery.replaceAll("'", "");
			int splitCnt = itemQuery.split(",").length;
			if(splitCnt == 1) {
				String finalQuery = "AND " + renameItem + " = '" + itemQuery + "'";
				targetMap.put(itemName, finalQuery);
			} else if(splitCnt > 1) {
				String finalQuery = "AND " + renameItem + " IN (" + CommonAPI.wrapToQuotes(itemQuery) + ")";
				targetMap.put(itemName, finalQuery);
			}
		}
		return targetMap;
	}
	@SuppressWarnings({ "unchecked", "rawtypes" })
	public static String searchToString(String itemQuery, String renameItem) {
		String finalQuery = "";
		if(CommonAPI.isValid(itemQuery)) {
			itemQuery = itemQuery.replaceAll("'", "");
			int splitCnt = itemQuery.split(",").length;
			if(splitCnt == 1) {
				finalQuery = "AND " + renameItem + " = '" + itemQuery + "'";
			} else if(splitCnt > 1) {
				finalQuery = "AND " + renameItem + " IN (" + CommonAPI.wrapToQuotes(itemQuery) + ")";
			}
		}
		return finalQuery;
	}
	
	/**
	 * 날짜 관련 처리
	 * 
	 * ex)
	 * map["startDate"] => '2014-11-01' (20141101 도 사용가능)
	 * map["endDate"] 	=> '2014-12-01' (20141201 도 사용가능)
	 * 
	 * 인경우 다음을 실행
	 * 
	 * map = QueryAPI.dateRangeQuery(map, "startDate", "endDate", "INIT_DTTM");
	 * 
	 * => 결과 map["INIT_DTTM"] => "AND INIT_DTTM BETWEEN TO_DATE('2014-11-01') AND TO_DATE('2014-12-01')"
	 * 
	 * - startDate만 있는경우
	 * "AND INIT_DTTM >= TO_DATE('2014-11-01')"
	 * 
	 * - endDate만 있는경우
	 * "AND INIT_DTTM <= TO_DATE('2014-12-01')"
	 * 
	 * @param targetMap
	 * @param startDateName
	 * @param endDateName
	 * @param dbColumn
	 * @return
	 */
	public static Map dateRangeQuery(Map targetMap, String startDateName, String endDateName, String dbColumn) {
		return dateRangeQuery(targetMap, startDateName, endDateName, dbColumn, dbColumn);
	}
	@SuppressWarnings("unchecked")
	public static Map dateRangeQuery(Map targetMap, String startDateName, String endDateName, String dbColumn, String renameColumn) {
		
		String startDate 	= (String)targetMap.get(startDateName);
		String endDate 		= (String)targetMap.get(endDateName);
		
		if(CommonAPI.isValid(startDate)) startDate 	= startDate.replaceAll("'", "");
		if(CommonAPI.isValid(endDate)) endDate 	= endDate.replaceAll("'", "");
		
		if(startDate != null && startDate.length() == 8) {
			startDate = startDate.replaceAll("-", "");
			String yy = startDate.substring(0, 4);
			String mm = startDate.substring(4, 6);
			String dd = startDate.substring(6, 8);
			startDate = yy + "-" + mm + "-" + dd; 
		}
		if(endDate != null && endDate.length() == 8) {
			endDate 	= endDate.replaceAll("-", "");
			String yy 	= endDate.substring(0, 4);
			String mm 	= endDate.substring(4, 6);
			String dd 	= endDate.substring(6, 8);
			endDate = yy + "-" + mm + "-" + dd; 
		}
		
		String makeStr		= "";
		if(CommonAPI.isValid(startDate) && CommonAPI.isValid(endDate)) {
			// 시작 날짜 끝날짜 모두 있는경우
			makeStr = "AND " + renameColumn + " BETWEEN TO_DATE('"+startDate+"') AND TO_DATE('"+endDate+" 23:59:59', 'YYYY-MM-DD HH24:MI:SS')";
			targetMap.put(dbColumn, makeStr);
		} else if(CommonAPI.isValid(startDate)) {
			// 시작 날짜만 있는 경우
			makeStr = "AND " + renameColumn + " >= TO_DATE('"+startDate+"', 'YYYY-MM-DD') ";
			targetMap.put(dbColumn, makeStr);
		} else if(CommonAPI.isValid(endDate)) {
			// 끝 날짜만 있는 경우
			makeStr = "AND " + renameColumn + " <= TO_DATE('"+endDate+" 23:59:59', 'YYYY-MM-DD HH24:MI:SS') ";
			targetMap.put(dbColumn, makeStr);
		} 
		return targetMap;
	}
}
