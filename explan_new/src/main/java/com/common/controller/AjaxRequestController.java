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
package com.common.controller;
import java.util.HashMap;

import javax.inject.Inject;
import javax.inject.Named;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.sf.json.JSONObject;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import com.CommonAPI;
import com.common.service.AjaxRequestService;
import com.common.service.BaseService;

/**
 * This MovieController class is a Controller class to provide movie crud and
 * genre list functionality.
 * 
 * @author Sooyeon Park
 */
@Controller("AjaxRequestController")
public class AjaxRequestController {

	@Inject
	@Named("AjaxRequestService")
	private AjaxRequestService ajaxRequestService;

	@RequestMapping("ajaxRequest.do")
	public String ajaxRequest(
		HttpServletRequest 	request		, 
		HttpServletResponse response	
	) throws Exception {
		try
		{
			String serviceName = request.getParameter("__serviceName");
			JSONObject jsonResponse = null;
			if(serviceName != null && !"".equals(serviceName)) {
				
				// Form 형태로 Ajax가 호출된경우(주로 일반 HTML)
				jsonResponse = ajaxRequestService.getSeviceResponseByForm(serviceName, request);
				
			} else {
				
				// Json 형태로 Ajax가 호출된경우 (주로 Grid Data)
				String jsonString = request.getParameter("jsonData");
				if(jsonString == null) {
					// Error 처리
					return null;
				}
				jsonResponse = ajaxRequestService.getSeviceResponse(jsonString, request);
			}
	    	CommonAPI.printWriteOut(response, jsonResponse.toString());
		} catch(Exception e) {
			e.printStackTrace();
			HashMap<String, Object> map = new HashMap<String, Object>();
			map.put("state"	, BaseService.REQUEST_FAIL);
			map.put("msg"	, "System error");
			map.put("data"	, null);
			JSONObject jsonResult	= new JSONObject();
			jsonResult.put("ALL", map);
			CommonAPI.printWriteOut(response, jsonResult.toString());
		}
		return null;
	}
}
