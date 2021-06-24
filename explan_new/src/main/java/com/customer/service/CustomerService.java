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
package com.customer.service;

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

/**
 * This MovieServiceImpl class is an Implementation class to provide movie crud
 * functionality.
 * 
 * @author Sooyeon Park
 */
@Service("CustomerService")
@Transactional(rollbackFor = { Exception.class }, propagation = Propagation.REQUIRED)
public class CustomerService extends BaseService{
	
	@Inject
	@Named("CommonDao")
	private CommonDao commonDao;
	
	@SuppressWarnings({ "unchecked", "rawtypes" })
	public Map saveCustomerList(Map map , HttpServletRequest request ) throws Exception {
		
		List<Map> customerList = (List<Map>)map.get("customerList");
		
		String loginId = CommonAPI.getLoginId(request);

		// 삭제 대상 List
		List deletedCustomerNumList = (List)map.get("deletedCustomerNumList");
		if(CommonAPI.isValid(deletedCustomerNumList)) {
			for (Object delCustomerNum : deletedCustomerNumList) {
				if(!CommonAPI.isValid(delCustomerNum)) continue;
				commonDao.update("Customer.deleteCustomer", delCustomerNum);
			}
		}
		
		for (Map customer : customerList) {
			String customerNum = String.valueOf(customer.get("CUSTOMER_NUM"));
			if("".equals(customerNum)) {
				// 신규
				customerNum = CommonAPI.makeUniqueID();
				customer.put("CUSTOMER_NUM", customerNum);
				customer.put("USER_ID", loginId);
			}
			commonDao.update("Customer.saveCustomer", customer);
		}
		resultInfo = makeResult(BaseService.REQUEST_SUCCESS, "", null);
		return resultInfo;
	}
}
