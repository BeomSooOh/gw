package neos.cmm.db;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.sql.DataSource;

import org.apache.ibatis.datasource.pooled.PooledDataSource;
import org.apache.ibatis.mapping.BoundSql;
import org.apache.ibatis.mapping.Environment;
import org.apache.ibatis.mapping.ParameterMapping;
import org.apache.ibatis.session.Configuration;
import org.apache.ibatis.session.SqlSession;
import org.apache.ibatis.session.SqlSessionFactory;
import org.apache.ibatis.session.SqlSessionFactoryBuilder;
import org.apache.ibatis.transaction.TransactionFactory;
import org.apache.ibatis.transaction.jdbc.JdbcTransactionFactory;
import org.apache.ibatis.type.JdbcType;
import org.apache.log4j.Logger;

import egovframework.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;

public abstract class AbstractInterlockSqlSession {
	private Logger logger = Logger.getLogger(this.getClass());
	protected String oracleDriver = "oracle.jdbc.driver.OracleDriver";
	protected String mssqlDriver = "com.microsoft.sqlserver.jdbc.SQLServerDriver";
	protected String dbType = "";
	protected String pakage = "";
	
	SqlSessionFactory sqlSessionFactory;

	protected void createSqlSession(String dbType, String url, String username, String password, String pakage) {
		this.dbType = dbType.toLowerCase();
		this.pakage = pakage;
		String driver = "mssql".equals(this.dbType) ? mssqlDriver : oracleDriver;
		DataSource dataSource = new PooledDataSource(driver, url, username, password);
		TransactionFactory transactionFactory = new JdbcTransactionFactory();
		Environment environment = new Environment("development", transactionFactory, dataSource);
		Configuration configuration = new Configuration(environment);
		configuration.addMappers(pakage);
//		configuration.addMapper(mariadb.class);
//		configuration.addMapper(oracle.class);
		configuration.setJdbcTypeForNull(JdbcType.NULL);
		sqlSessionFactory = new SqlSessionFactoryBuilder().build(configuration);
	}
	
	public abstract void setSqlSession(Map<String,Object> params);
	
	@SuppressWarnings("unchecked")
	public Map<String, Object> selectListOfPage(String queryID, Map<String, Object> paramMap, PaginationInfo paginationInfo) {
		
		Map<String ,Object> resultMap = new HashMap<String ,Object>();
		
		int startNum = (( paginationInfo.getCurrentPageNo() -1) * paginationInfo.getPageSize()) ;
		int endNum = startNum + paginationInfo.getPageSize() - 1 ;
		
		// endNum = startNum + 9;
		
		paramMap.put("startNum", startNum) ;
		paramMap.put("endNum", endNum) ;	
			
		int totalCount =   0 ;
		List<?> list =  selectList(queryID, paramMap);
		
		if( list !=  null && !list.isEmpty()) {
			Map<String, Object> map = null ;
			Object temp = null ;
			temp  = list.get(0) ;
			if( temp == null) {
				return null ;
			}
			map =  (Map<String, Object>)temp ;
			temp = map.get("TOTAL_COUNT") ;
			if(temp  != null  ) {
				totalCount = Integer.parseInt(temp.toString() ) ;
			}
		}
		
		paginationInfo.setTotalRecordCount(totalCount);
		resultMap.put("list", list) ;
		int startCount = totalCount - ( ( paginationInfo.getCurrentPageNo() - 1 )  * paginationInfo.getPageSize() );
		resultMap.put("startCount", startCount) ;
		resultMap.put("totalCount", totalCount) ;
		return resultMap;
	}
	
	protected List<Map<String, Object>> selectList(String queryId, Map<String,Object> paramMap) {
		if (sqlSessionFactory == null) {
			setSqlSession(paramMap);
		}
		return getQueryResultList(null, pakage+"."+dbType+"."+queryId, paramMap);
	}
	
	protected Map<String, Object> selectOne(String queryId, Map<String,Object> paramMap) {
		if (sqlSessionFactory == null) {
			setSqlSession(paramMap);
		}
		return getQueryResultOne(null, pakage+"."+dbType+"."+queryId, paramMap);
	}
	protected int insert(String queryId, Map<String,Object> paramMap) {
		if (sqlSessionFactory == null) {
			setSqlSession(paramMap);
		}
		return setQuery(null, pakage+"."+dbType+"."+queryId, paramMap);
	}
	protected int update(String queryId, Map<String,Object> paramMap) {
		if (sqlSessionFactory == null) {
			setSqlSession(paramMap);
		}
		return setQuery(null, pakage+"."+dbType+"."+queryId, paramMap);
	}
	protected int delete(String queryId, Map<String,Object> paramMap) {
		if (sqlSessionFactory == null) {
			setSqlSession(paramMap);
		}
		return setQuery(null, pakage+"."+dbType+"."+queryId, paramMap);
	}
	
	protected List<Map<String, Object>> getQueryResultList(SqlSession sqlSession, String queryId, Object paramMap){
		List<Map<String, Object>> resultList = null;
		
		if(sqlSession != null){
			try{
				if(paramMap == null) {
					resultList = sqlSession.selectList(queryId);
				}
				else {
					resultList = sqlSession.selectList(queryId, paramMap);
				}
			}catch(Exception e){
				logger.error("Orgchart Query Error.", e);
			}
		}else{
			try{
				sqlSession = sqlSessionFactory.openSession();
				if(paramMap == null) {
					resultList = sqlSession.selectList(queryId);
				}
				else {
					resultList = sqlSession.selectList(queryId, paramMap);
				}
			}catch(Exception e){
				logger.error("Orgchart Query Error.", e);
			}finally{
				if(sqlSession != null) {
					logger.debug("sqlSession.close()");
					sqlSession.close();
				}
			}
		}
		
		printLog(sqlSession, queryId, paramMap);
		
		logger.debug("resultList : " + resultList);
		
		return resultList;
	}
	
	protected Map<String, Object> getQueryResultOne(SqlSession sqlSession, String queryId, Object paramMap){
		Map<String, Object> result = null;
		
		if(sqlSession != null){
			try{
				if(paramMap == null) {
					result = sqlSession.selectOne(queryId);
				}
				else {
					result = sqlSession.selectOne(queryId, paramMap);
				}
			}catch(Exception e){
				logger.error("Orgchart Query Error.", e);
			}
		}else{
			try{
				sqlSession = sqlSessionFactory.openSession();
				if(paramMap == null) {
					result = sqlSession.selectOne(queryId);
				}
				else {
					result = sqlSession.selectOne(queryId, paramMap);
				}
			}catch(Exception e){
				logger.error("Orgchart Query Error.", e);
			}finally{
				if(sqlSession != null) {
					logger.debug("sqlSession.close()");
					sqlSession.close();
				}
			}
		}
		
		printLog(sqlSession, queryId, paramMap);
		
		logger.debug("result : " + result);
		
		return result;
	}
	
	@SuppressWarnings("rawtypes")
	protected void printLog(SqlSession sqlSession, String queryId, Object paramMap) {
		BoundSql boundSql = sqlSession.getConfiguration().getMappedStatement(queryId).getSqlSource().getBoundSql(paramMap);
		String query1 = boundSql.getSql();
		Object paramObj = boundSql.getParameterObject();
		
//		System.out.println(query1);
//		System.out.println(paramObj);

		if(paramObj != null){              // 파라미터가 아무것도 없을 경우

			List<ParameterMapping> paramMapping = boundSql.getParameterMappings();
			
			
			for(ParameterMapping mapping : paramMapping){
				Object value = null;
				
				String propValue = mapping.getProperty();      
				if(paramObj instanceof Map) {
					value = ((Map)paramObj).get(propValue);
				}

				if (value != null) {
					if(value instanceof String) {
						value = "'"+value+"'";
					}
				}
				query1=query1.replaceFirst("\\?", value+"");
				
			}
			logger.debug(query1);

		}
		
		
	}
	
	protected int setQuery(SqlSession sqlSession, String queryId, Object param){
		int result = 0;
		
		if(sqlSession != null){
			try{
				if(queryId.indexOf("insert") > 0) {
					result = sqlSession.insert(queryId, param);
				}
				else {
					result = sqlSession.update(queryId, param);
				}
			}catch(Exception e){
				logger.error("Orgchart Query Error.", e);
			}
		}else{
			try{
				sqlSession = sqlSessionFactory.openSession();
				if(queryId.indexOf("insert") > 0) {
					result = sqlSession.insert(queryId, param);
				}
				else {
					result = sqlSession.update(queryId, param);
				}
				sqlSession.commit();
			}catch(Exception e){
				logger.error("Orgchart Query Error.", e);
			}finally{
				if(sqlSession != null) {
					logger.debug("sqlSession.close()");
					sqlSession.close();
				}
			}
		}
		
		printLog(sqlSession, queryId, param);
		
		logger.debug("result : " + result);
		
		return result;
	}

}
