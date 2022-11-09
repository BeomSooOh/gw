package neos.cmm.filter;

import java.io.IOException;
import java.util.Enumeration;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import neos.cmm.util.BizboxAProperties;

public class HttpsFilter implements Filter {
	
	public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) throws IOException, ServletException {
		
		/** 디버깅을 위한 요청 URL 확인 */
		request.setCharacterEncoding("UTF-8");
//		HttpServletRequest  hsr = (HttpServletRequest )request;
//		String uri = hsr.getRequestURI();
//		if (uri != null && uri.indexOf(".do") > -1 && uri.indexOf("gwnoticeutil.do") < 0) {
//			String ipAddress = ((HttpServletRequest)request).getHeader("X-FORWARDED-FOR");  
//			
//			if ( ipAddress == null || ipAddress.length( ) == 0 ) {
//				ipAddress = ((HttpServletRequest)request).getHeader( "Proxy-Client-IP" );
//			}
//			
//			if ( ipAddress == null || ipAddress.length( ) == 0 ) {
//				ipAddress = ((HttpServletRequest)request).getHeader( "WL-Proxy-Client-IP" ); // 웹로직?
//			}
//			
//			//Custom property 값 ProxyAddYn이 "Y"경우 header 값 체크 추가 (proxy 및 모든 l4 대응 방안)
//			if(BizboxAProperties.getCustomProperty("BizboxA.ProxyAddYn").equals("Y")) {
//				if(ipAddress == null || ipAddress.length( ) == 0) {
//					ipAddress = ((HttpServletRequest)request).getHeader( "HTTP_CLIENT_IP" );
//				}
//				if(ipAddress == null || ipAddress.length( ) == 0) {
//					ipAddress = ((HttpServletRequest)request).getHeader( "HTTP_X_FORWARDED_FOR" );
//				}
//				if(ipAddress == null || ipAddress.length( ) == 0) {
//					ipAddress = ((HttpServletRequest)request).getHeader( "X-Real-IP" );
//				}
//			}
//			if ( ipAddress == null || ipAddress.length( ) == 0 ) {
//				ipAddress = request.getRemoteAddr( );
//			}
//			
//			if ( ipAddress == null ) {
//				ipAddress = ""; 
//			}
//		}
		
		HttpsRequestWrapper httpsRequest = new HttpsRequestWrapper( (HttpServletRequest) request);
		httpsRequest.setResponse((HttpServletResponse) response);
		chain.doFilter(httpsRequest, response);
	}

	@Override
	public void destroy() {
		return;
		
	}


	@Override
	public void init(FilterConfig config) throws ServletException {
		return;
	}
}
