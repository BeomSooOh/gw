package api.hdcs.helper;

import java.util.Locale;

import api.hdcs.exception.HdcsException;
import api.hdcs.handler.HdcsHandler;

import api.common.model.APIResponse;


public class ResponseHelper {
	
	public static APIResponse createSuccess(Object result) {
		
		APIResponse response = new APIResponse();
		
		response.setResultCode("0");
		response.setResultMessage("SUCCESS");
		response.setResult(result);
		
		return response;
		
	}
	
	public static APIResponse createError(HdcsHandler handler, Locale locale) {
		
		APIResponse response = new APIResponse();
		String code = handler.getErrorCode();
		
		response.setResultCode(code);
		response.setResultMessage(handler.getMessage(code, locale));
		
		return response;
		
	}
	
	public static APIResponse createError(HdcsHandler handler, HdcsException hdcsException, Locale locale) {
		
		APIResponse response = new APIResponse();
		String code = hdcsException.getErrorCode();
		
		response.setResultCode(code);
		
		String message = hdcsException.getErrorMessage();
		if (message == null) {
			response.setResultMessage(handler.getMessage(code, locale));
		}
		else {
			response.setResultMessage(handler.getMessage(code, locale) + "(" + message + ")");
		}
		
		return response;
	}
	
}
