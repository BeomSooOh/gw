package api.msg.controller;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.Reader;
import java.io.StringWriter;
import java.io.Writer;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.HashMap;
import java.util.Map;

import javax.annotation.Resource;
import javax.net.ssl.HttpsURLConnection;
import javax.servlet.http.HttpServletRequest;
import neos.cmm.util.CommonUtil;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RequestBody;

import com.fasterxml.jackson.core.JsonParseException;
import com.fasterxml.jackson.databind.JsonMappingException;

import neos.cmm.db.CommonSqlDAO;
import net.sf.json.JSONObject;
import net.sf.json.JSONSerializer;
import api.common.model.APIResponse;
import api.msg.service.MsgService;
import main.web.BizboxAMessage;



@Controller
public class MsgController {
	
	@Resource(name = "commonSql")
	private CommonSqlDAO commonSql;	
	
	//private static final Logger logger = LoggerFactory.getLogger(MsgController.class);
	 
	 @Resource(name="MsgService")
	 private MsgService msgService;
		
	@RequestMapping(value="/msg/MsgMenuVer", method=RequestMethod.POST)
	@ResponseBody
	public APIResponse getMsgMenuVer(@RequestBody Map<String, Object> paramMap) {
		APIResponse response = null;

		// 리턴 결과 
		response = msgService.MsgMenuVer(paramMap);
		
		return response;
	}
	
	@RequestMapping(value="/msg/MsgMenuList", method=RequestMethod.POST)
	@ResponseBody
	public APIResponse getMsgMenuList(@RequestBody Map<String, Object> paramMap, HttpServletRequest request) {
		//ModelAndView mv = new ModelAndView();
		APIResponse response = null;
		
		paramMap.put("scheme", request.getScheme() + "://");
		paramMap.put("serverName", CommonUtil.getApiCallDomain(request));
		// 리턴결과
		response = msgService.MsgMenuList(paramMap);
		
		return response;
		
	}
	
	
	@RequestMapping(value="/msg/MsgBoardList", method=RequestMethod.POST)
	@ResponseBody
	public APIResponse MsgBoardList(@RequestBody Map<String, Object> paramMap) throws JsonParseException, JsonMappingException, IOException {
		//ModelAndView mv = new ModelAndView();
		APIResponse response = null;
		
		// 리턴결과
		response = msgService.MsgBoardList(paramMap);
		
		return response;
		
	}
	
	
	@RequestMapping(value="/msg/MsgLinkToken", method=RequestMethod.POST)
	@ResponseBody
	public APIResponse getMsgLinkToken(@RequestBody Map<String, Object> paramMap) {
		//ModelAndView mv = new ModelAndView();
		APIResponse response = null;
		
		// 리턴결과
		response = msgService.MsgLinkToken(paramMap);
		
		return response;
		
	}
	
	
	@RequestMapping(value="/msg/GerpLinkToken.do", method=RequestMethod.POST)
	@ResponseBody
	public APIResponse GerpLinkToken(@RequestBody Map<String, Object> paramMap) {
		APIResponse response = null;
		
		// 리턴결과
		response = msgService.GerpLinkToken(paramMap);
		
		return response;
		
	}
	
	@RequestMapping(value="/msg/GerpMailboxList.do", method=RequestMethod.POST)
	@ResponseBody
	public APIResponse GerpMailboxList(@RequestBody Map<String, Object> paramMap) {
		APIResponse response = new APIResponse();
		
		if(paramMap.get("gerpId") != null && !paramMap.get("gerpId").equals("")){
			Map<String, Object> gerpUserInfo = (Map<String, Object>) commonSql.select("EmpManage.selectGerpUserInfo", paramMap);
			
			if(gerpUserInfo != null){
		        String url = gerpUserInfo.get("emailUrl").toString() + "mailBoxListApi.do?id=" + gerpUserInfo.get("emailAddr").toString() + "&domain=" + gerpUserInfo.get("emailDomain").toString();
		        
		        String json = "";
		        InputStream is = null;
		        		
		        try {
			        if(gerpUserInfo.get("emailUrl").toString().toLowerCase().contains("https://")){
			        	HttpsURLConnection  huc = (HttpsURLConnection) new URL(url).openConnection();
			            huc.setRequestMethod("POST");
			            huc.setDoInput(true);
			            huc.setDoOutput(true);
			            huc.setRequestProperty("Content-Type", "application/x-www-form-urlencoded");
			            is = huc.getInputStream();
			        }else{
			        	HttpURLConnection  huc = (HttpURLConnection) new URL(url).openConnection();
			            huc.setRequestMethod("POST");
			            huc.setDoInput(true);
			            huc.setDoOutput(true);
			            huc.setRequestProperty("Content-Type", "application/x-www-form-urlencoded");
			            is = huc.getInputStream();
			        }
		            
		            Writer writer = new StringWriter();

		            char[] buffer = new char[1024];
		            try
		            {
		                Reader reader = new BufferedReader(new InputStreamReader(is, "UTF-8"));
		                int n;
		                while ((n = reader.read(buffer)) != -1) 
		                {
		                    writer.write(buffer, 0, n);
		                }
//		                System.out.println(writer.toString());
		                json = writer.toString();
		            }
		            finally 
		            {
		                is.close();
		                writer.close();
		            }
		            
		        }
		        catch(Exception e) {
		        	response.setResultCode("FAIL");
		        	response.setResultMessage(e.getMessage());
		        	return response;
		        }
		        
		        JSONObject jsonObject = JSONObject.fromObject(JSONSerializer.toJSON(json));
			
		        Map<String, Object> result = new HashMap<String, Object>();
       			result.put("emailUrl", gerpUserInfo.get("emailUrl").toString() + "mailListViewApi.do?mboxSeq=");	
		        result.put("allunseen", jsonObject.get("allunseen"));
		        result.put("mailboxList", jsonObject.get("mailboxList"));
		        
		        response.setResultCode("SUCCESS");
		        response.setResult(result);
		        response.setResultMessage(BizboxAMessage.getMessage("TX800000021","메일함 리스트 조회 완료"));
			}else{
	        	response.setResultCode("FAIL");
	        	response.setResultMessage(BizboxAMessage.getMessage("TX800000022","통합ERP사번에 대한 그룹웨어 메일계정이 존재하지 않습니다."));				
			}
		}else{
        	response.setResultCode("FAIL");
        	response.setResultMessage(BizboxAMessage.getMessage("TX800000023","통합ERP사번 입력 오류"));				
		}
		
		return response;
	}	
	
	@RequestMapping(value="/msg/createMsgMenu", method=RequestMethod.POST)
	@ResponseBody
	public APIResponse createMsgMenu(@RequestParam Map<String, Object> paramMap , HttpServletRequest request) {
		//ModelAndView mv = new ModelAndView();
		APIResponse response = null;
		
		// 리턴결과
		response = msgService.setMsgMenu(paramMap);
		
		return response;
		
	}
	 
}
