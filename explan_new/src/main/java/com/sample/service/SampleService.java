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
package com.sample.service;

import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;
import javax.servlet.http.HttpServletRequest;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.common.dao.CommonDao;
import com.common.service.BaseService;

/**
 * This MovieServiceImpl class is an Implementation class to provide movie crud
 * functionality.
 * 
 * @author Sooyeon Park
 */
@Service("SampleService")
@Transactional(rollbackFor = { Exception.class }, propagation = Propagation.REQUIRED)
public class SampleService extends BaseService{
	
	@Inject
	@Named("CommonDao")
	private CommonDao commonDao;
	
	public Map getSample(Map obj , HttpServletRequest request ) throws Exception {
		
		resultList = (List<Map>)commonDao.getList("Sample.getSample", obj);
		
		resultInfo = makeResult(BaseService.REQUEST_SUCCESS, "", resultList);
		
		return resultInfo;
	}
}
