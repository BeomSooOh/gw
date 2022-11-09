package api.orgchart.init;

import javax.servlet.ServletContext;

import org.springframework.context.ApplicationContext;
import org.springframework.web.context.support.WebApplicationContextUtils;

import api.common.dao.APIDAO;
import neos.cmm.util.CommonUtil;

public class OrgChartInit {
	
	public static void init(ServletContext sc){
		try {
			ApplicationContext act = WebApplicationContextUtils.getRequiredWebApplicationContext(sc);
			APIDAO apiDAO = (APIDAO)act.getBean("APIDAO");
			apiDAO.update("orgchartDAO.updateOrgSyncTaskInit", null);
			
		} catch (Exception e) {
			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
		}
	}
	
}
