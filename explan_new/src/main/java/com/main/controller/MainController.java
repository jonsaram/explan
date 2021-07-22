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
package com.main.controller;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import com.CommonAPI;
import com.common.service.CommonService;

/**
 * This MovieController class is a Controller class to provide movie crud and
 * genre list functionality.
 * 
 * @author Sooyeon Park
 */
@Controller("MainController")
public class MainController {

	@Inject
	@Named("CommonService")
	private CommonService commonService;

	/**
	 * 공통 사용 변수 선언
	 */
	private static List<Map> pageMap = null;
	
	private void makePageInfo() {
		// Page ID 세팅
		try {
			pageMap = commonService.getPageInfoList();
		} catch(Exception e) {
			e.printStackTrace();
		}
	}
	@RequestMapping("login.do")
	public String login(HttpServletRequest 	request, HttpServletResponse response) throws Exception {
		return "explan/login";
	}
	@RequestMapping("join.do")
	public String join(HttpServletRequest 	request, HttpServletResponse response) throws Exception {
		return "explan/join";
	}
	@RequestMapping(value = "loginProcess.do", method = RequestMethod.POST)
	public String loginProcess(HttpServletRequest 	request, HttpServletResponse response) throws Exception {
		String loginId = request.getParameter("loginId");
		String loginPw = request.getParameter("loginPw");
		
		CommonAPI.setLoginId(request, loginId);
		
		return "explan/loginSuccess";
	}
	@RequestMapping(value = "registProcess.do", method = RequestMethod.POST)
	public String registProcess(HttpServletRequest 	request, HttpServletResponse response) throws Exception {
		String USER_ID 	= request.getParameter("USER_ID"	);
		String USER_PW 	= request.getParameter("USER_PW"	);
		String USER_NAME= request.getParameter("USER_NAME"	);
		String HP 		= request.getParameter("HP"			);
		String EMAIL 	= request.getParameter("EMAIL"		);
		
		HashMap<String,String> userInfo = new HashMap<String,String>();
		
		userInfo.put("USER_ID"	, USER_ID 	);
		userInfo.put("USER_NAME", USER_NAME );
		userInfo.put("USER_PW"	, USER_PW 	);
		userInfo.put("HP"		, HP 		);
		userInfo.put("EMAIL"	, EMAIL 	);
		
		commonService.registProcess(userInfo);
		
		return "explan/login";
	}
	@RequestMapping("mainFrame.do")
	public String mainFrame(HttpServletRequest 	request, HttpServletResponse response) throws Exception {
		makePageInfo();
		return "explan/mainFrame";
    	//CommonAPI.printWriteOut(response, "test");
	}
	@RequestMapping("movePage.do")
	public String movePage(HttpServletRequest request,HttpServletResponse response,Model model) throws Exception {
		// Page ID 세팅
		try {
			String loginId = CommonAPI.getLoginId(request);
			
			String pageId = request.getParameter("pageId");
			model.addAttribute("pageId", pageId);
			model.addAttribute("loginId", loginId);
			// JSP 에 전달할 Parameter를 Setting
			setRequestParameter(pageId, request, response);
			
			// PAGE ID에 해당하는 JSP로 이동
			return getJspPagePath(pageId, request);
		} catch(Exception e) {
			e.printStackTrace();
		}
		return null;
	}
	/**
	 * JSP 에 전달할 Parameter를 Setting
	 * 기본적으로 JSP 상에서 Ajax Service를 이용해야 하며, 이부분은 부득이 꼭 필요한 경우에만 사용.
	 * @param pageId
	 * @param request
	 */
	public void setRequestParameter(String pageId, HttpServletRequest request, HttpServletResponse response) throws Exception{
		// Sample Page
		//if		("SAMPLE"			.equals(pageId)) sampleService.setRequestParameter		(pageId, request);
	}
	/**
	 * // PAGE ID에 해당하는 JSP Path 리턴
	 * @param pageId
	 * @param request
	 * @return
	 */
	@SuppressWarnings({ "rawtypes" })
	public String getJspPagePath(String pageId, HttpServletRequest request) {
		makePageInfo();
		
		String returnUrl = null;
		
		//// Page ID에 따른 jsp 분기 ////
		if(pageId != null) {
			for (Map map : pageMap) {
				String tPageId = (String)map.get("PAGE_ID");
				String jspPath = (String)map.get("URL");
				if(pageId.equals(tPageId)) {
					returnUrl = jspPath;
					break;
				}
			}
		}
		
		// 페이지 없으면 기본 Sample Page 로( 차후 에러처리 해야함.)
		if		( returnUrl == null ) 		returnUrl = "/explan/noPage";
		// returnUrl 이 "N/A"인경우는 실제로 Page가 없다는 의미로 returnUrl을 null로 Setting 한다.
		else if	( "N/A".equals(returnUrl)) 	returnUrl = null;
		
		return returnUrl;
	}
}
