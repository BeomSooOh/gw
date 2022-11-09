package api.orgchart.controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.security.InvalidAlgorithmParameterException;
import java.security.InvalidKeyException;
import java.security.NoSuchAlgorithmException;
import java.util.HashMap;
import java.util.Map;

import javax.crypto.BadPaddingException;
import javax.crypto.IllegalBlockSizeException;
import javax.crypto.NoSuchPaddingException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import api.common.exception.APIException;
import api.common.helper.LogHelper;
import api.common.model.APIResponse;
import api.orgchart.service.ApiOrgchartService;
import cloud.CloudConnetInfo;
import neos.cmm.util.BizboxAProperties;
import neos.cmm.util.CommonUtil;
import neos.cmm.util.AESCipher;

@Controller
public class OrgchartController {
	private Log logger = LogFactory.getLog(OrgchartController.class);

	@Autowired
	private ApiOrgchartService orgchartService;

	private String codeHead = "system.api.common.";

	@RequestMapping(value="/org/download/{groupSeq}" , method={ RequestMethod.POST, RequestMethod.GET})
	public void orgChartDownload(HttpServletRequest request, HttpServletResponse response, @PathVariable("groupSeq") String groupSeq) {
		logger.debug("orgChartDownload  : groupSeq=" + groupSeq);
		try {
			orgchartService.downloadOrgChart(request, response, groupSeq);
		} catch (IOException e) {
			// TODO Auto-generated catch block
			logger.error(e);
		}

	}

	@RequestMapping(value="/org/download/zip/{groupSeq}" , method={ RequestMethod.POST, RequestMethod.GET})
	public void orgChartDownloadZip(HttpServletRequest request, HttpServletResponse response
			, @PathVariable("groupSeq") String groupSeq) {
		logger.debug("orgChartDownload  : groupSeq=" + groupSeq);
		try {
			orgchartService.downloadOrgChartZip(request, response, groupSeq);
		} catch (IOException e) {
			// TODO Auto-generated catch block
			logger.error(e);
		}

	}
	
	@RequestMapping(value="/org/download/interlock" , method={ RequestMethod.POST, RequestMethod.GET})
	@ResponseBody
	public void orgChartDownloadInterlock(HttpServletRequest request, HttpServletResponse response, @RequestParam Map<String,Object> params) throws IOException, InvalidKeyException, NoSuchAlgorithmException, NoSuchPaddingException, InvalidAlgorithmParameterException, IllegalBlockSizeException, BadPaddingException {
		
		String groupSeq = "";
		
		if(params.get("token") != null && !params.get("token").equals("")) {
			
			groupSeq = AESCipher.AES128EX_ExpirDecode(params.get("token").toString(), "", 60);
			
			if(groupSeq == null || groupSeq.equals("")) {
				logger.error("orgChartDownloadInterlock  : tokenEnc=" + params.get("token").toString());
				response.setCharacterEncoding("UTF-8");
				response.setContentType("text/html; charset=UTF-8");
				PrintWriter printwriter = response.getWriter();
				printwriter.println("<html>");
				printwriter.println("인증 토큰이 유효하지 않습니다.");
				printwriter.println("</html>");
				printwriter.flush();
				printwriter.close();
				return;				
			}			
			
		}else if(params.get("groupSeq") != null && !params.get("groupSeq").equals("")){
			
			groupSeq = params.get("groupSeq").toString();
			
			String clientIp = CommonUtil.getClientIp(request);
			String setIps = BizboxAProperties.getCustomProperty("BizboxA.Cust.orgChartDownloadInterlockIp");
			
			if(!setIps.equals("*") && !setIps.contains(clientIp)) {
				logger.error("orgChartDownloadInterlock  : groupSeq=" + groupSeq + "/clientIp=" + clientIp + "/setIps=" + setIps);
				response.setCharacterEncoding("UTF-8");
				response.setContentType("text/html; charset=UTF-8");
				PrintWriter printwriter = response.getWriter();
				printwriter.println("<html>");
				printwriter.println("보안설정으로 인해 접근이 불가합니다.");
				printwriter.println("</html>");
				printwriter.flush();
				printwriter.close();
				return;
			}

		}else {
			response.setCharacterEncoding("UTF-8");
			response.setContentType("text/html; charset=UTF-8");
			PrintWriter printwriter = response.getWriter();
			printwriter.println("<html>");
			printwriter.println("groupSeq가 유효하지 않습니다.");
			printwriter.println("</html>");
			printwriter.flush();
			printwriter.close();
			return;			
		}
		
		try {
			
			if(params.get("zipYn") != null && params.get("zipYn").equals("Y")) {
				orgchartService.downloadOrgChartZip(request, response, groupSeq);	
			}else {
				orgchartService.downloadOrgChart(request, response, groupSeq);	
			}
			
		} catch (IOException e) {
			response.setCharacterEncoding("UTF-8");
			response.setContentType("text/html; charset=UTF-8");
			PrintWriter printwriter = response.getWriter();
			printwriter.println("<html>");
			printwriter.println(e.getMessage());
			printwriter.println("</html>");
			printwriter.flush();
			printwriter.close();
		}		

	}	

	@RequestMapping(value="/org/editYn/{groupSeq}/{orgChartDt}/{reqType}" , method={ RequestMethod.POST, RequestMethod.GET})
	@ResponseBody
	public String[] orgChartEditYn(HttpServletRequest request, HttpServletResponse response, @PathVariable("groupSeq") String groupSeq, @PathVariable("orgChartDt") String orgChartDt, @PathVariable("reqType") String reqType) {
		logger.debug("orgChartEditYn  : groupSeq=" + groupSeq + ", orgChartDt=" + orgChartDt + ", reqType=" + reqType);
		String[] result = null;
		try {
			result = orgchartService.orgChartEidtYn(request, response, groupSeq, orgChartDt, reqType);
		} catch (IOException e) {
			logger.error(e);
		}

		return result;
	}

	@RequestMapping(value="/org/editYn/{groupSeq}/{orgChartDt}" , method={ RequestMethod.POST, RequestMethod.GET})
	@ResponseBody
	public String[] orgChartEditYn(HttpServletRequest request, HttpServletResponse response, @PathVariable("groupSeq") String groupSeq, @PathVariable("orgChartDt") String orgChartDt) {
		logger.debug("orgChartEditYn  : groupSeq=" + groupSeq + ", orgChartDt=" + orgChartDt);
		String[] result = null;
		try {
			result = orgchartService.orgChartEidtYn(request, response, groupSeq, orgChartDt, "mobile");
		} catch (IOException e) {
			logger.error(e);
		}

		return result;
	}

	@RequestMapping(value="/org/editYn/{groupSeq}" , method={ RequestMethod.POST, RequestMethod.GET})
	@ResponseBody
	public String[] orgChartEditYn(HttpServletRequest request, HttpServletResponse response, @PathVariable("groupSeq") String groupSeq) {
		logger.debug("orgChartEditYn  : groupSeq=" + groupSeq);
		String[] result = null;
		try {
			result = orgchartService.orgChartEidtYn(request, response, groupSeq, "", "mobile");
		} catch (IOException e) {
			logger.error(e);
		}

		return result;
	}

	@RequestMapping(value="/org/sync/{groupSeq}" , method={ RequestMethod.POST, RequestMethod.GET})
	@ResponseBody
	public APIResponse orgSync(HttpServletRequest request
			, HttpServletResponse response
			, @PathVariable("groupSeq") String groupSeq
			, @RequestParam Map<String,Object> params
			) {

		logger.debug("orgSync  : groupSeq=" + groupSeq);
		long time = System.currentTimeMillis();
		APIResponse responseData = null;
		try {
			 logger.info("groupList" + "-start ");

			 int count = orgchartService.pollingOrgSync(groupSeq, params.get("isEventSend")+"", true);

			 Map<String,Object> map = new HashMap<String, Object>();

			 map.put("count", count);

			 responseData = LogHelper.createSuccess(map);

			 time = System.currentTimeMillis() - time;
			 logger.info("groupList" + "-end ET[" + time + "] groupSeq : "+ groupSeq);
		 } catch (APIException ae) {
			 responseData = LogHelper.createError(request, "system.api.org", "OR0010");
			 time = System.currentTimeMillis() - time;
			 logger.error("groupList" + "-error ET[" + time + "] groupSeq : "+ groupSeq, ae);
		 } catch (Exception e) {
			 responseData = LogHelper.createError(request, "system.api.org", "OR0010");
			 time = System.currentTimeMillis() - time;
			 logger.error("groupList" + "-error ET[" + time + "] groupSeq : "+ groupSeq, e);
		 }

		return responseData;

	}


	@RequestMapping(value="/org/groupList" , method={ RequestMethod.POST, RequestMethod.GET})
	@ResponseBody
	public APIResponse orgChartGroupList(HttpServletRequest request, HttpServletResponse response) {
		logger.debug("Select GroupList");
		//Map<String,Object> result = new HashMap<String,Object>();
		Map<String, Object> paramMap  = new HashMap<String,Object>();
		 long time = System.currentTimeMillis();
		 String serviceErrorCode = "CO0000";
		APIResponse responseData = null;
		try {
			 logger.info("groupList" + "-start " + LogHelper.getRequestString(paramMap));

			 String groupSeq = "";
			 Map<String, Object> jedisMp = CloudConnetInfo.getParamMapByDomain(request.getServerName());
		    	
	    	if(jedisMp != null && jedisMp.get("groupSeq") != null) {
	    		groupSeq = jedisMp.get("groupSeq").toString();	
	    	}		
	
	    	Map<String, Object> para = new HashMap<String, Object>();
	    	para.put("groupSeq", groupSeq);
	    	
			 Object result =  orgchartService.selectGroupList(para);

			 responseData = LogHelper.createSuccess(result);
			 time = System.currentTimeMillis() - time;
			 logger.info("groupList" + "-end ET[" + time + "] "+ LogHelper.getResponseString(paramMap, responseData));
		 } catch (APIException ae) {
			 responseData = LogHelper.createError(request, codeHead, ae);
			 time = System.currentTimeMillis() - time;
			 logger.error("groupList" + "-error ET[" + time + "] " + LogHelper.getResponseString(paramMap, responseData), ae);
		 } catch (Exception e) {
			 responseData = LogHelper.createError(request, codeHead, serviceErrorCode);
			 time = System.currentTimeMillis() - time;
			 logger.error("groupList" + "-error ET[" + time + "] " + LogHelper.getResponseString(paramMap, responseData), e);
		 }

		return responseData;
	}


	@RequestMapping(value="/org/compBizDeptList" , method={ RequestMethod.POST, RequestMethod.GET})
	@ResponseBody
	public Object orgChartCompBizDeptList(HttpServletRequest request, HttpServletResponse response, @RequestBody Map<String, Object> paramMap) {
		logger.debug("Select compBizDeptList");

		 long time = System.currentTimeMillis();
		 String serviceErrorCode = "CO0000";
		APIResponse responseData = null;
		try {
			 logger.info("compBizDeptList" + "-start " + LogHelper.getRequestString(paramMap));

			 Object result =  orgchartService.selectCompBizDeptList(paramMap);

			 responseData = LogHelper.createSuccess(result);
			 time = System.currentTimeMillis() - time;
			 logger.info("compBizDeptList" + "-end ET[" + time + "] "+ LogHelper.getResponseString(paramMap, responseData));
		 } catch (APIException ae) {
			 responseData = LogHelper.createError(request, codeHead, ae);
			 time = System.currentTimeMillis() - time;
			 logger.error("compBizDeptList" + "-error ET[" + time + "] " + LogHelper.getResponseString(paramMap, responseData), ae);
		 } catch (Exception e) {
			 responseData = LogHelper.createError(request, codeHead, serviceErrorCode);
			 time = System.currentTimeMillis() - time;
			 logger.error("compBizDeptList" + "-error ET[" + time + "] " + LogHelper.getResponseString(paramMap, responseData), e);
		 }

		return responseData;


	}

	@RequestMapping(value="/org/empList" , method={ RequestMethod.POST, RequestMethod.GET})
	@ResponseBody
	public Object orgChartEmpList(HttpServletRequest request, HttpServletResponse response, @RequestBody Map<String, Object> paramMap) {
		logger.debug("Select EmpList");

		 long time = System.currentTimeMillis();
		 String serviceErrorCode = "CO0000";
		APIResponse responseData = null;
		try {
			 logger.info("empList" + "-start " + LogHelper.getRequestString(paramMap));


			 Object result =  orgchartService.selectEmpList(request,paramMap );

			 responseData = LogHelper.createSuccess(result);
			 time = System.currentTimeMillis() - time;
			 logger.info("empList" + "-end ET[" + time + "] "+ LogHelper.getResponseString(paramMap, responseData));
		 } catch (APIException ae) {
			 responseData = LogHelper.createError(request, codeHead, ae);
			 time = System.currentTimeMillis() - time;
			 logger.error("empList" + "-error ET[" + time + "] " + LogHelper.getResponseString(paramMap, responseData), ae);
		 } catch (Exception e) {
			 responseData = LogHelper.createError(request, codeHead, serviceErrorCode);
			 time = System.currentTimeMillis() - time;
			 logger.error("empList" + "-error ET[" + time + "] " + LogHelper.getResponseString(paramMap, responseData), e);
		 }
		return responseData;
	}

	@RequestMapping(value="/org/insertEmpNum" , method={ RequestMethod.POST, RequestMethod.GET})
	@ResponseBody
	public Object orgChartInsertEmpNum(HttpServletRequest request, HttpServletResponse response, @RequestBody Map<String, Object> paramMap) {
		logger.debug("Select EmpList");

		 long time = System.currentTimeMillis();
		 String serviceErrorCode = "CO0000";
		APIResponse responseData = null;
		try {
			 logger.info("insertEmpNum" + "-start " + LogHelper.getRequestString(paramMap));


			 Object result =  orgchartService.insertEmpNum(paramMap );

			 responseData = LogHelper.createSuccess(result);
			 time = System.currentTimeMillis() - time;
			 logger.info("insertEmpNum" + "-end ET[" + time + "] "+ LogHelper.getResponseString(paramMap, responseData));
		 } catch (APIException ae) {
			 responseData = LogHelper.createError(request, codeHead, ae);
			 time = System.currentTimeMillis() - time;
			 logger.error("insertEmpNum" + "-error ET[" + time + "] " + LogHelper.getResponseString(paramMap, responseData), ae);
		 } catch (Exception e) {
			 responseData = LogHelper.createError(request, codeHead, serviceErrorCode);
			 time = System.currentTimeMillis() - time;
			 logger.error("insertEmpNum" + "-error ET[" + time + "] " + LogHelper.getResponseString(paramMap, responseData), e);
		 }
		return responseData;
	}

	//localhost:8080/gw/api/org/ebpSyncOrgchart?groupSeq=demo&syncAll=Y&compSeq=9300
    @RequestMapping(value="/org/ebpSyncOrgchart" , method={ RequestMethod.POST, RequestMethod.GET})
    @ResponseBody
    public APIResponse ebpSyncOrgchart(HttpServletRequest request, HttpServletResponse response, Map<String, Object> paramMap) { //@RequestBody
        paramMap.put("groupSeq", request.getParameter("groupSeq"));
        paramMap.put("compSeq", request.getParameter("compSeq"));
        paramMap.put("serverDomain", request.getServerName());
        paramMap.put("erpCompSeq", request.getParameter("erpCompSeq"));
        paramMap.put("isDelYn", request.getParameter("isDelYn"));
        String syncAll = request.getParameter("syncAll");
        paramMap.put("syncAll", syncAll);

        APIResponse respApi = new APIResponse();
        if (request.getParameter("groupSeq").isEmpty()) {
            respApi.setResult(request);
            respApi.setResultCode("API0000");
            respApi.setResultMessage("파라미터값이 입력되지 않았습니다. : groupSeq");
            return respApi;
        }
        else if (request.getParameter("syncAll").isEmpty()) {
            respApi.setResult(request);
            respApi.setResultCode("API0000");
            respApi.setResultMessage("파라미터값이 입력되지 않았습니다. : syncAll");
            return respApi;
        }
        else if (request.getServerName().isEmpty()) {
            respApi.setResult(request);
            respApi.setResultCode("API0000");
            respApi.setResultMessage("서버 도메인을 찾을수 없습니다. : serverDomain");
            return respApi;
        }

        if ("Y".equals(syncAll) || syncAll == "Y" || "y".equals(syncAll) || syncAll == "y") {
            // 전체 동기화
            return orgchartService.ebpSyncOrgchartAll(paramMap);
        }
        else {
            // 상시 동기화
            return orgchartService.ebpSyncOrgchart(paramMap);
        }
    }
}
