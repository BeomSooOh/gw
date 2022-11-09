package neos.cmm.systemx.orgchart;

import java.sql.SQLException;

import javax.servlet.ServletContext;

import org.apache.ibatis.session.SqlSession;
import org.springframework.context.ApplicationContext;
import org.springframework.web.context.support.WebApplicationContextUtils;

import bizbox.orgchart.service.IOrgEditService;
import bizbox.orgchart.service.IOrgEmpService;
import bizbox.orgchart.service.IOrgGrpService;
import bizbox.orgchart.service.IOrgService;
import bizbox.orgchart.service.impl.OrgEditServiceImpl;
import bizbox.orgchart.service.impl.OrgEmpServiceImpl;
import bizbox.orgchart.service.impl.OrgGrpServiceImpl;
import bizbox.orgchart.service.impl.OrgServiceImpl;
import bizbox.orgchart.util.JedisClient;
import cloud.CloudConnetInfo;
import neos.cmm.util.CommonUtil;

public class OrgChartSupport {
	private static IOrgService orgService = null;
	private static IOrgEditService editService = null;
	private static IOrgEmpService empService = null;
	private static IOrgGrpService grpService = null;
	
	
	public static void init(ServletContext sc){
		 ApplicationContext act = WebApplicationContextUtils.getRequiredWebApplicationContext(sc);
		 SqlSession sqlSession = (SqlSession)act.getBean("sqlSession");
		 
		 JedisClient jedis = CloudConnetInfo.getJedisClient();
		 
		 try {
			orgService = new OrgServiceImpl(sqlSession, jedis);
			editService = new OrgEditServiceImpl(sqlSession, jedis);
			empService = new OrgEmpServiceImpl(sqlSession, jedis);
			grpService = new OrgGrpServiceImpl(sqlSession, jedis);
		} catch (SQLException e) {
			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
		}
		 
	}
	
	public static IOrgService getIOrgService() {
		return orgService;
	}
	public static IOrgEditService getIOrgEditService() {
		return editService;
	}
	public static IOrgEmpService getIOrgEmpService() {
		return empService;
	}
	public static IOrgGrpService getIOrgGrpService() {
		return grpService;
	}
}
