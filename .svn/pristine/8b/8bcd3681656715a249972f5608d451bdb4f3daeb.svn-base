package neos.cmm.util;

import java.util.HashMap;
import java.util.Map;

import javax.servlet.ServletContext;
import javax.servlet.http.HttpServletRequest;

import neos.cmm.db.CommonSqlDAO;
import neos.cmm.util.code.CommonCodeSpecific;

import org.springframework.context.ApplicationContext;
import org.springframework.web.context.support.WebApplicationContextUtils;

import bizbox.orgchart.service.vo.LoginVO;
import egovframework.com.cmm.util.EgovUserDetailsHelper;
import egovframework.rte.fdl.string.EgovStringUtil;


public class CommonNeosRight {
	public static boolean isAuthRight(HttpServletRequest request) {
		boolean result = false ;
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		if(loginVO == null ) {
			return false ;
		}
		
		ServletContext sc = request.getSession().getServletContext();
		ApplicationContext act = WebApplicationContextUtils.getRequiredWebApplicationContext(sc);
		CommonSqlDAO commonSql = (CommonSqlDAO)act.getBean("commonSql");
		String requestURI = request.getRequestURI() ;
		String contextPath = request.getContextPath() ;
		
		if(!EgovStringUtil.isEmpty(contextPath)) {
			requestURI = requestURI.substring(contextPath.length());
		}
		
		Map<String, String> paramMap = new HashMap<String, String>();
		
		paramMap.put("loginUserID", loginVO.getUniqId());
		paramMap.put("requestURI", requestURI);
		
		Object temp = null ;
		if(CommonCodeSpecific.getNewAuthorUseYN().equals("Y")) {
			temp = commonSql.select("UserAuthorManageDAO.getNewUserAuthor", paramMap);
		}else {
			temp = commonSql.select("UserAuthorManageDAO.getUserAuthor", paramMap);
		}
		
		if(temp != null ) {
			result = true ;
		}
		return result ;
	}
}
