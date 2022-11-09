package api.main.controller;

import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import api.common.exception.APIException;
import api.common.helper.LogHelper;
import api.common.model.APIResponse;
import api.main.service.ApiMainService;

@Controller
public class ApiMainController {

	 private static final Logger logger = LoggerFactory.getLogger(ApiMainController.class);
	 
	 @Resource(name="ApiMainService")
	 private ApiMainService apiMainService;
	 
	 
	 private String codeHead = "system.api.common.";
	 
	 @RequestMapping(value="/main/{serviceName}", method=RequestMethod.POST)
	 @ResponseBody
	 public APIResponse main(HttpServletRequest servletRequest, HttpServletResponse servletResponse, 
			 @PathVariable String serviceName, @RequestBody Map<String, Object> request){


		 long time = System.currentTimeMillis();

		 APIResponse response = null;
		 String serviceErrorCode = "CO0000";

		 Map<String, Object> header = (Map<String, Object>) request.get("header");
		 Map<String, Object> body = (Map<String, Object>) request.get("body");
		 body.putAll((Map<String, Object>)body.get("companyInfo"));
		 body.putAll(header);

		 /* 인터페이스 별 로직 수행 */
		 try {
			 logger.info(serviceName + "-start " + LogHelper.getRequestString(request));
//			 Object result = null;

//			 Method method = apiMainService.getClass().getMethod(serviceName, Map.class);
			 
			 Object result = apiMainService.action(serviceName, body);

			 response = LogHelper.createSuccess(result);
			 time = System.currentTimeMillis() - time;
			 logger.info(serviceName + "-end ET[" + time + "] "+ LogHelper.getResponseString(request, response));
		 } catch (APIException ae) {
			 response = LogHelper.createError(servletRequest, codeHead, ae);
			 time = System.currentTimeMillis() - time;
			 logger.error(serviceName + "-error ET[" + time + "] " + LogHelper.getResponseString(request, response), ae);
		 } catch (Exception e) {
			 response = LogHelper.createError(servletRequest, codeHead, serviceErrorCode);
			 time = System.currentTimeMillis() - time;
			 logger.error(serviceName + "-error ET[" + time + "] " + LogHelper.getResponseString(request, response), e);
		 }

		 return response;
	 }
}
