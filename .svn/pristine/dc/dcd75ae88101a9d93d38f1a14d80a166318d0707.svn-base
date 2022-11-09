package neos.cmm.filter;

import java.io.IOException;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;

/*
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.context.ApplicationContext;
import org.springframework.web.context.support.WebApplicationContextUtils;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.com.uat.uia.service.EgovLoginService;
*/


/**
 * 
 * @title Neos URL 접근 권한 필터
 * @author 공공사업부 포털개발팀 박기환
 * @since 2012. 7. 12.
 * @version 
 * @dscription 	권한에 접근이 허락 된 url에만 접근을 허락한다. 
 * 
 *
 * << 개정이력(Modification Information) >>
 *  수정일                수정자        수정내용  
 * -----------  -------  --------------------------------
 * 2012. 7. 12.  박기환        최초 생성
 *
 */
public class NeosAuthFilter implements Filter {

	@SuppressWarnings("unused")
	private FilterConfig config;	
	
	public void doFilter(ServletRequest request, ServletResponse response,
			FilterChain chain) throws IOException, ServletException {
		
		/*
		ApplicationContext act = WebApplicationContextUtils.getRequiredWebApplicationContext(config.getServletContext());
		EgovLoginService loginService = (EgovLoginService) act.getBean("loginService");
		EgovMessageSource egovMessageSource = (EgovMessageSource)act.getBean("egovMessageSource");
		HttpServletRequest httpRequest = (HttpServletRequest)request;
		HttpServletResponse httpResponse = (HttpServletResponse)response;
		HttpSession session = httpRequest.getSession();
		String isRemotelyAuthenticated = (String)session.getAttribute("isRemotelyAuthenticated");
		String requestURL = ((HttpServletRequest)request).getRequestURI();
		*/
		
		chain.doFilter(request, response);
	}

	public void init(FilterConfig config) throws ServletException {
		this.config = config;		
	}
	
	public void destroy() {
		return;
	}

}
