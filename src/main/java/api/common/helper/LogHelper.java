package api.common.helper;

import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang3.StringUtils;
import org.codehaus.jackson.map.ObjectMapper;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import api.common.exception.APIException;
import api.common.model.APIResponse;
import neos.cmm.util.CommonUtil;
import neos.cmm.util.MessageUtil;

public class LogHelper {
	static Logger logger = LoggerFactory.getLogger(LogHelper.class);

	
	/**
	 * 로그 찍기
	 * @param request
	 * @return
	 */
	public static String getRequestString(Map<String, Object> request) {
		StringBuilder sb = new StringBuilder();

		sb.append("request=");
		ObjectMapper mapper = new ObjectMapper();
		try {
			sb.append(mapper.writeValueAsString(request));
		} catch (Exception e) {
			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
		}		
		
		return sb.toString();
	}
	
	 /**
	  * 로그 찍기
	  * @param request
	  * @param response
	  * @return
	  */
	public static String getResponseString(Map<String, Object> request, APIResponse response) {
		StringBuilder sb = new StringBuilder();
		sb.append(getRequestString(request));

		Object result = response.getResult();
		if (logger.isDebugEnabled() && result != null) {
			sb.append("\n+-result=").append(result);
		}
		
		return sb.toString();
	}
	
	/**
	 * 성공 리턴 생성
	 * @param result
	 * @return
	 */
	public static APIResponse createSuccess(Object result) {
		APIResponse response = new APIResponse();
		response.setResultCode("0");
		response.setResultMessage("SUCCESS");
		response.setResult(result);
		return response;
	}

	/**
	 * 실패 리턴 생성
	 * @param request
	 * @param code
	 * @return
	 */
	public static APIResponse createError(HttpServletRequest request, String codeHead, String code) {
		APIResponse response = new APIResponse();
		response.setResultCode(code);
		response.setResultMessage(MessageUtil.getMessage(request, codeHead
				+ "." + code));
		return response;
	}
	
	public static APIResponse createResponse(HttpServletRequest request, String code, String txtCode) {
		APIResponse response = new APIResponse();
		response.setResultCode(code);
		response.setResultMessage(MessageUtil.getMessage(request, txtCode));
		return response;
	}
	
	/**
	 * 실패 리턴 생성
	 * @param request
	 * @param e
	 * @return
	 */
	public static APIResponse createError(HttpServletRequest request, String codeHead,
			APIException e) {
		APIResponse response = new APIResponse();
		response.setResultCode(e.getErrorCode());
		if (StringUtils.isNotEmpty(e.getErrorMessage())) {
			response.setResultMessage(MessageUtil.getMessage(request, codeHead
					+ e.getErrorCode()) + "(" + e.getErrorMessage() + ")");
		}
		else {
			response.setResultMessage(MessageUtil.getMessage(request, codeHead
					+ e.getErrorCode()));
		}
		return response;
	}
}
