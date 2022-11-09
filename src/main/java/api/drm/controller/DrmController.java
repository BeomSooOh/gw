package api.drm.controller;

import java.util.Map;
import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import api.common.model.APIResponse;
import api.drm.service.DrmService;

@Controller
public class DrmController {

    
    //private static final Logger logger = LoggerFactory.getLogger(DrmController.class);
    
	
	@Resource(name = "DrmService")
	private DrmService drmService;
	
    /*
     * post 호출 및 json 응답
     * DRM Enc/Des
     */
	@RequestMapping(value="/drmConvertAPI", method=RequestMethod.POST)//크로스사이트 요청 위조
	@ResponseBody
	public APIResponse drmConvertAPI(
								HttpServletRequest servletRequest, 
								HttpServletResponse servletResponse,
								@RequestBody Map<String, Object> request
							) throws Exception {

		APIResponse response = new APIResponse();

		@SuppressWarnings("unchecked")
		Map<String, Object> body = (Map<String, Object>) request.get("body");
		
		String result = drmService.drmConvertAPI(body.get("action").toString(), body.get("groupSeq").toString(), body.get("filePath").toString(), body.get("fileName").toString(), body.get("overWrite").toString());
		
		if(result.equals("")) {
			response.setResultCode("fail");
		}else {
			response.setResultCode("success");
			response.setResult(result);
		}
		
		return response;		
	}
	
    /*
     * post 호출 및 json 응답
     * DRM Enc/Des
     */
	@RequestMapping(value="/drmConvert", method=RequestMethod.POST)//크로스사이트 요청 위조
	@ResponseBody
	public APIResponse drmConvert(
								HttpServletRequest servletRequest, 
								HttpServletResponse servletResponse,
								@RequestBody Map<String, Object> request
							) throws Exception {

		APIResponse response = new APIResponse();

		@SuppressWarnings("unchecked")
		Map<String, Object> body = (Map<String, Object>) request.get("body");
		
		String result = drmService.drmConvert(body.get("action").toString(), body.get("groupSeq").toString(), body.get("pathSeq").toString(), body.get("filePath").toString(), body.get("fileName").toString(), body.get("fileExt").toString());
		
		if(result.equals("")) {
			response.setResultCode("fail");
		}else {
			response.setResultCode("success");
			response.setResult(result);
		}
		
		return response;		
	}	
}
