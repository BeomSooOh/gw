package neos.cmm.util.init;

import javax.servlet.ServletContext;
import javax.servlet.http.HttpServlet;

import api.orgchart.init.OrgChartInit;
import neos.cmm.systemx.orgchart.OrgChartSupport;
import neos.cmm.util.CommonUtil;

public class NeosInit extends HttpServlet{
	/**
	 *
	 */
	private static final long serialVersionUID = 1716427616880062618L;

	public void init(){
		try {
			ServletContext sc = getServletContext();
		
			CodeUtilInit.init(sc);
			ConstantsInit.init();
			OrgChartSupport.init(sc); 
			OrgChartInit.init(sc);
			
		} catch (Exception e) {
			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
		}
	}

}
