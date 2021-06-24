package com.common.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;

public class BaseService
{
	public static final String REQUEST_SUCCESS 	= "S";
	public static final String REQUEST_FAIL 		= "F";

	protected Map 			resultInfo = null;
	protected List<Map>	resultList = null;

	protected Logger logger = Logger.getLogger(this.getClass());
	
	/**
	 * 서비스 결과 리턴
	 * @param state
	 * @param retMsg
	 * @param returnData
	 * @return
	 */
	public static Map makeResult(String state, String retMsg, Object returnData) {
		HashMap<String, Object> map = new HashMap<String, Object>();
		map.put("state"	, state);
		map.put("msg"	, retMsg);
		map.put("data"	, returnData);
		return map;
	}

}
