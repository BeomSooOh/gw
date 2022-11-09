package api.hdcs.handler;

import java.util.Locale;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;


public interface HdcsHandler {
	
	public String getPid();
	
	public String getServiceName();
	
	public String getErrorCode();
	
	public String getMessageBaseName();
	
	public String getMessage(String code, Locale locale);

	public String getMessage(String code, Object[] args, Locale locale);
	
	public Object handle(HttpServletRequest servletRequest, HttpServletResponse servletResponse, Map<String, Object> request) throws Exception;
	
}

