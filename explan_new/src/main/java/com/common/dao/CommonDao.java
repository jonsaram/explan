package com.common.dao;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import org.mybatis.spring.support.SqlSessionDaoSupport;
import org.springframework.stereotype.Repository;

@Repository("CommonDao")
public class CommonDao extends SqlSessionDaoSupport {
	@SuppressWarnings("rawtypes")
	public List<Map> getList(String queryId, Object obj) throws Exception {
		return super.getSqlSession().selectList(queryId, obj);
	}
	public int update(String queryId, Object obj) throws Exception {
		return super.getSqlSession().update(queryId, obj);
	}
}