package egovframework.com.sec.security.filter;

import java.io.IOException;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.context.ApplicationContext;
import org.springframework.web.context.support.WebApplicationContextUtils;

import bizbox.orgchart.service.vo.LoginVO;
import egovframework.com.cmm.util.EgovUserDetailsHelper;
import egovframework.com.sym.log.clg.service.EgovLoginLogService;
import egovframework.com.sym.log.clg.service.LoginLog;
import neos.cmm.util.CommonUtil;
import neos.cmm.util.code.CommonCodeSpecific;


/**
 * 
 * @author 공통서비스 개발팀 서준식
 * @since 2011. 8. 29.
 * @version 1.0
 * @see
 *
 * <pre>
 * 개정이력(Modification Information) 
 * 
 *   수정일      수정자          수정내용
 *  -------    --------    ---------------------------
 *  2011. 8. 29.    서준식        최초생성
 *  
 *  </pre>
 */

public class EgovSpringSecurityLogoutFilter implements Filter{
	
	private FilterConfig config;
	
	protected final static Log LOG = LogFactory.getLog(EgovSpringSecurityLogoutFilter.class);

	
	public void destroy() {
		return;
	}

	
	public void doFilter(ServletRequest request, ServletResponse response,
			FilterChain chain) throws IOException, ServletException {

		ApplicationContext act = WebApplicationContextUtils.getRequiredWebApplicationContext(config.getServletContext());
		EgovLoginLogService loginLogService = (EgovLoginLogService)act.getBean("EgovLoginLogService");
		String requestURL = ((HttpServletRequest)request).getRequestURI();	
		LOG.debug(requestURL);
		try {
			if(requestURL.contains("/uat/uia/actionLogout") && !CommonCodeSpecific.getCompanyCD().equals("10014")){
				HttpServletRequest httpRequest = (HttpServletRequest)request;
				
				LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
				
				if(loginVO != null && (httpRequest.getSession().getAttribute("masterLogon") == null || !httpRequest.getSession().getAttribute("masterLogon").toString().equals("Y"))){
					//접속기록 저장
					LoginLog loginLog = new LoginLog();
					loginLog.setLoginId(loginVO.getUniqId());
					loginLog.setLoginIp(loginVO.getIp());
					loginLog.setLoginMthd("WEB_LOGOUT");
					loginLog.setErrOccrrAt("N");
					loginLog.setErrorCode("");
					loginLog.setGroupSeq(loginVO.getGroupSeq());
					loginLogService.logInsertLoginLog(loginLog);
				}
			}
		} catch (Exception e) {
			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
		}
		
		
		((HttpServletRequest)request).getSession().setAttribute("loginVO", null);
		((HttpServletResponse)response).sendRedirect(((HttpServletRequest)request).getContextPath() + "/j_spring_security_logout");

	}

	
	public void init(FilterConfig filterConfig) throws ServletException {

		this.config = filterConfig;
		
	}
	
}
