package com.common;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;

import com.CommonAPI;

public class CommonInterceptor extends HandlerInterceptorAdapter {
	
	// 사전처리
	@Override
	public boolean preHandle(
		HttpServletRequest request	,
		HttpServletResponse response, 
	Object handler) throws Exception {
		System.out.println("---PreHandle---");
		
		// TODO : 나중에 로그인 처리할때 변경 해야함.
		String loginId = CommonAPI.getLoginId(request);
		if(!CommonAPI.isValid(loginId)) {
			HttpSession	session = request.getSession();
			session.setAttribute("LOGIN_ID", "jonsaram");
			request.setAttribute("loginId", "jonsaram");
		}
		return true;
	}
	// jsp 호출하기 직전 처리
	@Override
	public void postHandle( 
		HttpServletRequest request, 
		HttpServletResponse response, 
		Object handler, 
		ModelAndView modelAndView
	) throws Exception {
		System.out.println("---PostHandle---");
	}	
}
