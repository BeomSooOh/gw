package api.visitor.controller;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import api.common.exception.APIException;
import api.common.model.APIResponse;
import api.visitor.service.VisitorService;
import neos.cmm.util.CommonUtil;
import neos.cmm.vo.SendMessageVO;
import restful.mobile.vo.RestfulRequest;
import restful.mobile.vo.RestfulRequestHeader;

@SuppressWarnings("unused")
@Controller
public class VisitorController {

	@Resource(name = "VisitorService")
	private VisitorService visitorService;
	
	 /**
     * 특정일자 방문객 리스트 조회
     * @param request
	 * @return
	 * @throws APIException 
     * */
    @RequestMapping("/visitor/getAppvVisitorList")
    @ResponseBody
    public APIResponse getAppvVisitorList( @RequestBody Map<String, Object> request, HttpServletRequest servletRequest ) throws APIException {
    	
    	APIResponse response = new APIResponse();
    	
    	
    	try {

    		List<Map<String, Object>> result =  visitorService.getAppvVisitorList(request);
    		
    		response.setResult(result);
    		response.setResultMessage("방문객 리스트 조회 완료");
    		response.setResultCode("SUCCESS");

    	} catch(Exception e) {
    		response.setResultMessage("방문객 리스트 조회 실패(예외오류)");
    		response.setResultCode("ERR000");
    		response.setResult(e.getMessage());
    		CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
    	}
    	
    	return response;
    }
    
    /**
     * 인하우스 방문객 일괄 등록 - MMS 전송
     * @param request
	 * @return
	 * @throws APIException 
     * */
    @RequestMapping("/visitor/insertInHouseVisitorList")
    @ResponseBody
    public APIResponse insertInHouseVisitorList( @RequestBody Map<String, Object> request, HttpServletRequest servletRequest ) throws APIException {
    	
    	APIResponse response = new APIResponse();
    	Map<String, Object> result = new HashMap<String, Object>();
    	
    	try {
    		result = visitorService.insertInHouseVisitorList(request);
    		
    		response.setResultMessage(result.get("message").toString());
    		response.setResultCode(result.get("code").toString());
    		
    	} catch(Exception e) {
    		
    		response.setResultMessage("인하우스 방문객 일괄 등록 실패(예외오류)");
    		response.setResultCode("ERR000");
    		CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
    	}
    	
    	return response;
    }
    
    /**
     * 방문객 정보 조회(단일)
     * @param request
	 * @return
	 * @throws APIException 
     * */
    @RequestMapping(value="/visitor/getVisitorInfo", method={RequestMethod.GET, RequestMethod.POST})
    @ResponseBody
    public APIResponse getVisitorInfo(
									HttpServletRequest servletRequest, 
									HttpServletResponse servletResponse,
									@RequestBody RestfulRequest request,
									HttpServletRequest requests
								) throws Exception  {
    	
    	APIResponse response = new APIResponse();
    	
		Map<String, Object> reBody =  request.getBody();	
		RestfulRequestHeader reHeader = request.getHeader();
		
	    String groupSeq = reHeader.getGroupSeq();
		String rNo = reBody.get("rNo") == null ? "" : (String)reBody.get("rNo");
	    String visitCardNo = reBody.get("visitCardNo") == null ? "" : (String)reBody.get("visitCardNo");
	    
	    Map<String, Object> param = new HashMap<String, Object>();
	    param.put("groupSeq", reHeader.getGroupSeq());
	    param.put("empSeq", reHeader.getEmpSeq());
		param.put("rNo", rNo);
		param.put("visitCardNo", visitCardNo);
	    
		Map<String, Object> result = new HashMap<String,Object>();
		
    	try {
    		
    		result =  visitorService.getVisitorInfo(param);
    		
    		if(result.get("code").equals("SUCCESS") && result.get("result") == null) {
    			response.setResult(result.get("result"));
        		response.setResultMessage("방문일자가 일치하지 않거나 이미 퇴실처리된 QR코드 입니다.");
        		response.setResultCode("ERR002");
        		return response;
    		}
    		
			response.setResult(result.get("result"));
    		response.setResultMessage(result.get("message").toString());
    		response.setResultCode(result.get("code").toString());

    	} catch(Exception e) {
    		response.setResultMessage("방문객 정보 조회 실패(예외오류)");
    		response.setResultCode("ERR000");
    		response.setResult(result);
    		CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
    	}
    	
    	return response;
    	
    }

    /**
     * 일괄 입/퇴실 체크(인하우스 방문객)
     * @param request
	 * @return
	 * @throws APIException 
     * */
    @RequestMapping("/visitor/BatchInOutCheck")
    @ResponseBody
    public APIResponse UpdateInOutCheck( 
						    		HttpServletRequest servletRequest, 
									HttpServletResponse servletResponse,
									@RequestBody RestfulRequest request,
									HttpServletRequest requests) throws APIException {
    	
    	APIResponse response = new APIResponse();
    	
    	RestfulRequestHeader reHeader = request.getHeader();
		Map<String, Object> reBody =  request.getBody();
		
	    String groupSeq = reHeader.getGroupSeq();
	    String empSeq = reHeader.getEmpSeq();
	    
	    List<Map<String, Object>> inOutCheckList = (List<Map<String, Object>>) reBody.get("inOutCheckList");
		
	    Map<String, Object> param = new HashMap<String, Object>();
	    param.put("groupSeq", groupSeq);
	    param.put("empSeq", empSeq);
		param.put("inOutCheckList", inOutCheckList);
	    
		Map<String, Object> result = new HashMap<String,Object>();
		
    	try {
    		result = visitorService.BatchInOutCheck(param);
    		response.setResultMessage(result.get("message").toString());
    		response.setResultCode(result.get("code").toString());
    		
    	} catch(Exception e) {
    		response.setResultMessage("방문객 일괄 입/퇴실 시간 업데이트 실패(예외오류)");
    		response.setResultCode("ERR000");
    		CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
    	}
    	
    	return response;
    }
    
    @RequestMapping("/visitor/insertQrStayLog")
    @ResponseBody
    public APIResponse insertQrStayLog( 
						    		HttpServletRequest servletRequest, 
									HttpServletResponse servletResponse,
									@RequestBody RestfulRequest request,
									HttpServletRequest requests) throws Exception {
    	
    	APIResponse response = new APIResponse();
    	
    	RestfulRequestHeader reHeader = request.getHeader();
		Map<String, Object> reBody =  request.getBody();
		
	    String groupSeq = reHeader.getGroupSeq();
	    
	    Map<String, Object> param = new HashMap<String, Object>();
	    Map<String, Object> result = new HashMap<String, Object>();
	    
	    param.putAll(reBody);
	    param.put("groupSeq", groupSeq);
		
    	try {
    		Map<String, Object> insertResult = visitorService.insertQrStayLog(param);
    		response.setResultCode("SUCCESS");
    		response.setResultMessage("QR 정보 저장 성공");
    		
    		result.put("alertMessage", insertResult.get("message"));
    		response.setResult(result);
    		
    		if(insertResult.get("code").equals("duple")) {
    			return response;
    		}
    		
    	} catch(Exception e) {
    		response.setResultCode("ERR000");
    		response.setResultMessage("QR 정보 저장 실패");
    		result.put("alertMessage", "QR 정보 저장 실패");
    		response.setResult(result);
    		CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
    	}
    	
    	//쪽지전송
    	String[] recvEmpSeq = {param.get("empSeq") + ""};
    	String date = new SimpleDateFormat ( "yyyy년 MM월 dd일 HH:mm").format(new Date());
    	String content = "";
    	
    	content += "[QR인증]\n";
    	content += param.get("empName") + "님의 QR인증 정보입니다.\n\n";
    	content += "◼︎인증 정보◼\n";
    	content += "일      시 : " + date + "\n";
    	content += "이 용 자 산 : " + param.get("qrGbnCode").toString().toUpperCase() + " / " + param.get("qrCode") + " / " + param.get("qrDetailCode") + "\n"; 
    	content += "소      속 : " + param.get("deptPathName") + "\n";
    	content += "성      명 : " + param.get("empName") + "\n";
    	content += "전 화 번 호 : " + param.get("mobileTelNum");
    	
    	SendMessageVO vo = new SendMessageVO();
    	vo.setRecvEmpSeq(recvEmpSeq);
    	vo.setContent(content);
    	
    	CommonUtil.SendMessage(CommonUtil.getApiCallDomain(servletRequest), vo, groupSeq, param.get("empSeq") + "");
    	
    	return response;
    }
}
