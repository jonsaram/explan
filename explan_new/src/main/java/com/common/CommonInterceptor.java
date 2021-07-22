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
		
		String url = request.getRequestURL().toString();
		if( 
						url.indexOf("/join.do") 		> -1
					||	url.indexOf("/login.do") 		> -1
					||	url.indexOf("/loginProcess.do") > -1
					||	url.indexOf("/registProcess.do") > -1
		) {
			return true;
		} else {
			String loginId = CommonAPI.getLoginId(request);
			if(!CommonAPI.isValid(loginId)) {
				response.sendRedirect("/explan");
			}
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
