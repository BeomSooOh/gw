package neos.migration.suite.dao;

import java.io.Reader; 
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Properties;

import org.apache.ibatis.io.Resources;
import org.apache.ibatis.session.SqlSession;
import org.apache.ibatis.session.SqlSessionFactory;
import org.apache.ibatis.session.SqlSessionFactoryBuilder;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.stereotype.Repository;

import neos.migration.suite.vo.SuiteBaseInfoVO;
import neos.migration.suite.vo.SuiteDBCnntVO;


@Repository("ExecuteSuiteDAO")
public class ExecuteSuiteDAO {

	private Logger LOG = LogManager.getLogger(this.getClass());
	
	/* 변수정의 */
	private SqlSessionFactory	sqlSessionFactory;
	
	/* 공통사용 */
	/* 공통사용 - 커넥션 */
	private boolean connect(SuiteDBCnntVO suiteDBCnntVO) {
		boolean result = false;
		try {
			// 환경 설정 파일의 경로를 문자열로 저장 / String resource = "sample/mybatis/sql/mybatis-config.xml";
			String resource = "egovframework/sqlmap/config/mssql/migration/mig-suite-mybatis-config.xml";
			Properties props = new Properties();
			props.put("driver", suiteDBCnntVO.getDriver());
			props.put("url", suiteDBCnntVO.getUrl());
			props.put("username", suiteDBCnntVO.getUserId());
			props.put("password", suiteDBCnntVO.getPassWord());
			
			LOG.info("DB 연결 정보 : " + props.get("url"));

			// 문자열로 된 경로의파일 내용을 읽을 수 있는 Reader 객체 생성
			Reader reader = Resources.getResourceAsReader(resource);
			// reader 객체의 내용을 가지고 SqlSessionFactory 객체 생성 / sqlSessionFactory = new SqlSessionFactoryBuilder().build(reader, props);

			if (sqlSessionFactory == null) {
				sqlSessionFactory = new SqlSessionFactoryBuilder().build(reader, props);
			} else {
				sqlSessionFactory = null;
				sqlSessionFactory = new SqlSessionFactoryBuilder().build(reader, props);
			}
			result = true;
		}
		catch (Exception e) {
			System.out.println("세션 팩토리 생성 실패:" + e.getMessage());
			System.out.println("");
			LOG.error("세션 팩토리 생성 실패: " + e.getMessage());
		}

		return result;
	}
	
	public Map<String, Object> selectOne(String queryID, SuiteDBCnntVO suiteDBCnntVO) {
		Map<String, Object> result = new HashMap<String, Object>();
		connect(suiteDBCnntVO);
		SqlSession session = sqlSessionFactory.openSession();

		try {
            result = session.selectOne(queryID);
        } catch(Exception e){
            System.out.println(e);
            System.out.println("");
            LOG.error("selectOne 오류 " + e.getMessage());
        } finally {
            session.close();
        }
        
		return result;
	}
	
	private Map<String, Object> selectOne(String queryID, SuiteDBCnntVO suiteDBCnntVO, SuiteBaseInfoVO suiteBaseInfoVO) {
		Map<String, Object> result = new HashMap<String, Object>();
		connect(suiteDBCnntVO);
		SqlSession session = sqlSessionFactory.openSession();
		
        try {
            result = session.selectOne(queryID, suiteBaseInfoVO);
        } catch(Exception e){
        	 System.out.println(e);
             System.out.println("");
             LOG.error("selectOne 오류 " + e.getMessage());
        } finally {
            session.close();
        }
        
		return result;
	}
	
	private Map<String, Object> selectOneParam(String queryID, SuiteDBCnntVO suiteDBCnntVO, Map<String, Object> param) {
		Map<String, Object> result = new HashMap<String, Object>();
		connect(suiteDBCnntVO);
		SqlSession session = sqlSessionFactory.openSession();
		
        try {
            result = session.selectOne(queryID, param);
        } catch(Exception e){
        	 System.out.println(e);
             System.out.println("");
             LOG.error("selectOne 오류 " + e.getMessage());
        } finally {
            session.close();
        }
        
		return result;
	}
	
	/* list */
    public List<Map<String, Object>> selectList(String queryID, SuiteDBCnntVO suiteDBCnntVO, Map<String, Object> params){
        List<Map<String, Object>> result = new ArrayList<Map<String, Object>>();
        connect(suiteDBCnntVO);
        SqlSession session = sqlSessionFactory.openSession();
        
        try{
            result = session.selectList(queryID, params);
        }catch(Exception e){
        	 System.out.println(e);
             System.out.println("");
             LOG.error("selectList 오류 " + e.getMessage());
        }finally {
            session.close();
        }
        return result;
    }
    
    public int delete(String queryID, SuiteDBCnntVO suiteDBCnntVO, Map<String, Object> params) {
		int result = -1;
		connect(suiteDBCnntVO);
		SqlSession session = sqlSessionFactory.openSession();

		try {
            result = session.update(queryID, params);
        } catch(Exception e){
            System.out.println(e);
            System.out.println("");
            LOG.error("selectOne 오류 " + e.getMessage());
        } finally {
            session.close();
        }
        
		return result;
	}

	public Map<String, Object> selectSuiteCompanyInfoB(SuiteDBCnntVO suiteDBCnntVO) {
		
		return selectOne("ExecuteSuiteDAO.selectSuiteCompanyInfoB", suiteDBCnntVO);
	}
	
	public Map<String, Object> selectSuiteCompanyInfoC(SuiteDBCnntVO suiteDBCnntVO, SuiteBaseInfoVO suiteBaseInfoVO) {

		return selectOne("ExecuteSuiteDAO.selectSuiteCompanyInfoC", suiteDBCnntVO, suiteBaseInfoVO);
	}	
	public List<Map<String, Object>> selectSuiteTwfgProcess(SuiteDBCnntVO suiteDBCnntVO, Map<String, Object> params) {
		
		return selectList("ExecuteSuiteDAO.selectSuiteTwfgProcess", suiteDBCnntVO, params);
	}
	
	public List<Map<String, Object>> selectSuiteDocId(SuiteDBCnntVO suiteDBCnntVO, Map<String, Object> params) {
		return selectList("ExecuteSuiteDAO.selectSuiteDocId", suiteDBCnntVO, params);
	}

	public Map<String, Object> selectAuthApproveDocCount(SuiteDBCnntVO suiteDBCnntVO, SuiteBaseInfoVO suiteBaseInfoVO) {
		return selectOne("ExecuteSuiteDAO.selectAuthApproveDocCount", suiteDBCnntVO, suiteBaseInfoVO);
	}

	public Map<String, Object> selectViewDocCount(SuiteDBCnntVO suiteDBCnntVO, SuiteBaseInfoVO suiteBaseInfoVO) {
		return selectOne("ExecuteSuiteDAO.selectViewDocCount", suiteDBCnntVO, suiteBaseInfoVO);
	}

	public List<Map<String, Object>> selectAuthApproveDocList(SuiteDBCnntVO suiteDBCnntVO, Map<String, Object> param) {
		return selectList("ExecuteSuiteDAO.selectAuthApproveDocList", suiteDBCnntVO, param);
	}

	public List<Map<String, Object>> selectViewDocList(SuiteDBCnntVO suiteDBCnntVO, Map<String, Object> param) {
		return selectList("ExecuteSuiteDAO.selectViewDocList", suiteDBCnntVO, param);
	}
	
	public Map<String, Object> selectSuiteDocCount(SuiteDBCnntVO suiteDBCnntVO, SuiteBaseInfoVO suiteBaseInfoVO, Map<String, Object> param) {
		// TODO Auto-generated method stub
		return selectOneParam("ExecuteSuiteDAO.selectSuiteDocCount", suiteDBCnntVO, param);
	}

	public List<Map<String, Object>> selectSuiteBoardCommentList(SuiteDBCnntVO suiteDBCnntVO,
			Map<String, Object> param) {
		return selectList("ExecuteSuiteDAO.selectSuiteBoardCommentList", suiteDBCnntVO, param);
	}

	public List<Map<String, Object>> selectSuiteDocCommentList(SuiteDBCnntVO suiteDBCnntVO, Map<String, Object> param) {
		return selectList("ExecuteSuiteDAO.selectSuiteDocCommentList", suiteDBCnntVO, param);
	}

	public Map<String, Object> createTedgDocTemp(SuiteDBCnntVO suiteDBCnntVO) {
		return selectOne("ExecuteSuiteDAO.createTedgDocTemp", suiteDBCnntVO);
	}

	public Map<String, Object> selectExistTedgDocTemp(SuiteDBCnntVO suiteDBCnntVO) {
		return selectOne("ExecuteSuiteDAO.selectExistTedgDocTemp", suiteDBCnntVO);
	}

	public int deleteTedgDocTempDocId(SuiteDBCnntVO suiteDBCnntVO, Map<String, Object> param) {
		return delete("ExecuteSuiteDAO.deleteTedgDocTempDocId", suiteDBCnntVO, param);
	}
}
