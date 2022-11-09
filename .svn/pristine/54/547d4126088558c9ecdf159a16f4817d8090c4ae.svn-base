package neos.cmm.systemx.comp.dao;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.Reader;
import java.sql.SQLException;
import java.util.List;
import java.util.Map;
import java.util.Properties;

import org.apache.ibatis.io.Resources;
import org.apache.ibatis.session.SqlSession;
import org.apache.ibatis.session.SqlSessionFactory;
import org.apache.ibatis.session.SqlSessionFactoryBuilder;
import org.springframework.stereotype.Repository;

import neos.cmm.util.CommonUtil;
import neos.cmm.vo.ConnectionVO;
import oracle.sql.CLOB;

@SuppressWarnings("deprecation")
@Repository("ExCodeOrgERPiUDAO")
public class ExCodeOrgERPiUDAO {

	private SqlSessionFactory sqlSessionFactory;
	
	// 세션 팩토리 객체를 생성하고 그 결과를 리턴해주는 메서드
	private boolean connect(ConnectionVO conVo) {
		boolean result = false;
		try {
			// 환경 설정 파일의 경로를 문자열로 저장
//			String resource = "sample/mybatis/sql/mybatis-config.xml";
			String resource = "egovframework/sqlmap/config/"+ conVo.getDatabaseType() + "/ex/ex-mybatis-config.xml";
			
			Properties props = new Properties();
			props.put("databaseType", conVo.getDatabaseType());
			props.put("driver",conVo.getDriver());
			props.put("url", conVo.getUrl());
			props.put("username", conVo.getUserId());
			props.put("password",conVo.getPassWord());
			props.put("erpTypeCode",conVo.getSystemType());
			// 문자열로 된 경로의파일 내용을 읽을 수 있는 Reader 객체 생성
			Reader reader = Resources.getResourceAsReader(resource);
			// reader 객체의 내용을 가지고 SqlSessionFactory 객체 생성
//			sqlSessionFactory = new SqlSessionFactoryBuilder().build(reader, props);
			if (sqlSessionFactory == null) {
				sqlSessionFactory = new SqlSessionFactoryBuilder().build(reader, props);
			}else{
				sqlSessionFactory = null;
				sqlSessionFactory = new SqlSessionFactoryBuilder().build(reader, props);
			}
			result = true;
		}catch (Exception e) {
			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
		}
		
		return result;
	}
	
	public List<Map<String,Object>> getExCompList(Map<String, Object> param, ConnectionVO conVo) {
		List<Map<String, Object>> list = null;
		connect(conVo);

		// 세션팩토리를 이용해서 세션 객체를 생성
		SqlSession session = sqlSessionFactory.openSession();
		try{
			
			list =  session.selectList("getExCompList", param);
			session.close();
		}catch(Exception e){
			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
		}finally {
			session.close();
		}
		
		return list;
	}

	public List<Map<String, Object>> getExEmpList(Map<String, Object> params, ConnectionVO conVo) {
		List<Map<String, Object>> list = null;
		connect(conVo);

		// 세션팩토리를 이용해서 세션 객체를 생성
		SqlSession session = sqlSessionFactory.openSession();
		try{
			list =  session.selectList("getExEmpList", params);
			session.close();
		}catch(Exception e){
			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
		}finally {
			session.close();
		}
		return list;
	}

	public Map<String, Object> GetFiGwDocInfo(Map<String, Object> params, ConnectionVO conVo) {
		Map<String, Object> result = null;
		connect(conVo);
		// 세션팩토리를 이용해서 세션 객체를 생성
		SqlSession session = sqlSessionFactory.openSession();
		try{
			result =  session.selectOne("GetFiGwDocInfo", params);
			session.close();
		}catch(Exception e){
			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
		}finally {
			session.close();
		}
		return result;
	}
	
	 public static String clobToStr(CLOB clob) throws SQLException, IOException{
		  BufferedReader contentReader = new BufferedReader(clob.getCharacterStream());
		  StringBuffer out = new StringBuffer();
		  String aux;
		  while ((aux=contentReader.readLine())!=null) {
		   out.append(aux);
		   out.append("<br>");
		      }
		  return out.toString();
		 }	
	
	public List<Map<String, Object>> getExQueryResult(Map<String, Object> params, ConnectionVO conVo, String queryName) {
		List<Map<String, Object>> list = null;
		connect(conVo);

		// 세션팩토리를 이용해서 세션 객체를 생성
		SqlSession session = sqlSessionFactory.openSession();
		try{
			list =  session.selectList(queryName, params);
			
			for (Map<String, Object> map : list) {
				map.put("nttCn", clobToStr((CLOB)map.get("nttCn")));
			}
			
			session.close();
		}catch(Exception e){
			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
		}finally {
			session.close();
		}
		return list;
	}	

}
