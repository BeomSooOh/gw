package api.oneffice.controller;

import java.util.Iterator;
import java.util.Map;
import java.util.UUID;

import javax.annotation.Resource;
import javax.crypto.BadPaddingException;
import javax.crypto.IllegalBlockSizeException;
import javax.crypto.NoSuchPaddingException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang.reflect.MethodUtils;
import org.apache.log4j.Logger;
import org.joda.time.format.DateTimeFormat;
import org.joda.time.format.DateTimeFormatter;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.PrintWriter;
import java.io.UnsupportedEncodingException;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLDecoder;
import java.net.URLEncoder;
import java.nio.channels.FileChannel;
import java.security.InvalidAlgorithmParameterException;
import java.security.InvalidKeyException;
import java.security.NoSuchAlgorithmException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;

import neos.cmm.db.CommonSqlDAO;
import neos.cmm.menu.service.MenuManageService;
import neos.cmm.util.CommonUtil;
import neos.cmm.util.FileUtils;
import neos.cmm.util.HttpJsonUtil;
import neos.cmm.util.NeosConstants;
import net.sf.json.JSONObject;
import restful.mobile.vo.RestfulRequest;

import neos.cmm.util.AESCipher;
import neos.cmm.util.BizboxAProperties;
import bizbox.orgchart.service.vo.LoginVO;
import bizbox.statistic.data.dto.ActionDTO;
import bizbox.statistic.data.dto.CreatorInfoDTO;
import bizbox.statistic.data.enumeration.EnumActionStep1;
import bizbox.statistic.data.enumeration.EnumActionStep2;
import bizbox.statistic.data.enumeration.EnumActionStep3;
import bizbox.statistic.data.enumeration.EnumDevice;
import bizbox.statistic.data.enumeration.EnumModuleName;
import bizbox.statistic.data.service.ModuleLogService;
import egovframework.com.cmm.util.EgovUserDetailsHelper;
import main.web.BizboxAMessage;
import com.google.common.base.Charsets;
import com.google.common.io.Files;
import org.joda.time.DateTime;
import api.drm.service.DrmService;
import com.fasterxml.jackson.core.JsonParseException;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.JsonMappingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import neos.cmm.systemx.file.service.WebAttachFileService;
import neos.cmm.systemx.group.service.GroupManageService;
import cloud.CloudConnetInfo;

@Controller
public class OnefficeController {
	
	@Resource(name="GroupManageService")
	GroupManageService groupManageService;	
	
	@Resource(name = "commonSql")
	private CommonSqlDAO commonSql;
	
	@Resource(name="WebAttachFileService")
	WebAttachFileService attachFileService;
	
	@Resource ( name = "MenuManageService" )
	private MenuManageService menuManageService;
	
	@Resource(name = "DrmService")
	private DrmService drmService;  
	
	private static String htmlOnefficeString = "";
	private static String htmlOnefficeMobile = "";
	private static String htmlOnefficeReport = "";
	private static String htmlOnefficeClientString = "";
	private static String htmlOnefficeIndexMobile = ""; 
	
	private static String mobileEmpSeq = "";
	private static String mobileGroupSeq = "";
	
	private static int MAX_RECENT_DB_COLUMN = 100;
		
	@RequestMapping(value="/oneffice/oneffice.do")
	public ModelAndView oneffice(Map<String, Object> para, HttpServletRequest request, HttpServletResponse response) throws IOException, InvalidKeyException, NoSuchAlgorithmException, NoSuchPaddingException, InvalidAlgorithmParameterException, IllegalBlockSizeException, BadPaddingException {
		
		String docKey = request.getQueryString();
		String queryString = "";
		
		if(docKey != null && !docKey.contains("bizbox_report")) {
			queryString = new String(org.apache.commons.codec.binary.Base64.decodeBase64(URLDecoder.decode(docKey, "UTF-8").getBytes("UTF-8")), "UTF-8");
		}else {
			queryString = docKey == null ? "" : docKey;
		}
			
	    String htmlString = "";
	    
	    //캐쉬방지
	    java.text.SimpleDateFormat formatter=new java.text.SimpleDateFormat("yyyyMMddHHmmss");
        String strToday = formatter.format(new java.util.Date());
	    
	    Map<String, String> param = new HashMap<String, String>();
	    for (String info : queryString.split("&")) {
	        String pair[] = info.split("=");
	        if (pair.length>1) {
	        	param.put(pair[0], pair[1]);
	        }else{
	        	param.put(pair[0], "");
	        }
	    }
		
		
		ModelAndView mv = new ModelAndView();
		
		LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser( );
		Logger.getLogger( OnefficeController.class ).debug( "OnedfficeController.oneffice.do param : " +  param);
		Logger.getLogger( OnefficeController.class ).debug( "OnedfficeController.oneffice.do loginVO : " +  loginVO);
		Logger.getLogger( OnefficeController.class ).debug( "OnedfficeController.oneffice.do bizboxa-oneffice-token : " +  request.getHeader("bizboxa-oneffice-token"));
		
		String groupSeq = param.get("groupseq") == null ? param.get("groupSeq") : param.get("groupseq");
		
		
		if(request.getHeader("bizboxa-oneffice-token") != null && checkMobileToken(request, groupSeq)) {
			if(loginVO == null) {
				Map<String, Object> paramMap = new HashMap<String, Object>();
				paramMap.put("groupSeq", mobileGroupSeq);
				paramMap.put("empSeq", mobileEmpSeq);
				
				
				Logger.getLogger( OnefficeController.class ).debug( "OnedfficeController.oneffice.do mobileGroupSeq : " +  mobileGroupSeq);
				Logger.getLogger( OnefficeController.class ).debug( "OnedfficeController.oneffice.do mobileEmpSeq : " +  mobileEmpSeq);
				
				loginVO = (LoginVO) commonSql.select("loginDAO.actionLoginForOneffice", paramMap);
				
				if(loginVO == null) {
					return null;
				}
					
						
				request.getSession().invalidate();
		    	request.getSession().setAttribute("loginVO", loginVO);
		    	request.getSession().setAttribute("onefficeInfo",  request.getQueryString());
		    	
		    	mv.setViewName("redirect:/oneffice/oneffice.do");
		    	
		    	return mv;
			}
		}
		
	    Logger.getLogger( OnefficeController.class ).debug( "OnedfficeController.oneffice.do param : " +  param);
	    Logger.getLogger( OnefficeController.class ).debug( "OnefficeController.oneffice.do queryString : " +  queryString);
	    
	    
	    if(param.get("seq") != null){
	    	param.put("doc_no", param.get("seq"));
	    	param.put("empSeq", "");
	    }
	    
	    if(param.get("groupseq") != null){
	    	param.put("groupSeq", param.get("groupseq"));
	    }
	    
	    @SuppressWarnings("unchecked")
		Map<String, Object> result = (Map<String, Object>) commonSql.select("OnefficeDao.getDocument", param);
	    if (result != null && loginVO != null){
	    	result.put("user_id", loginVO.getUniqId());
	    	result.put("groupSeq", loginVO.getGroupSeq()); //모바일 Cloud 일때는 그룹 정보를 추가해주어야 한다.
	    	setRecentDocument(result);
	    }
	    
	    if(result != null || (param.get("ref") != null && param.get("ref").equals("bizbox_report"))){
		    //쿠키에 token저장
	    	Logger.getLogger( OnefficeController.class ).debug( "OnefficeController.oneffice.do bizboxa-oneffice-token : " +  request.getHeader("bizboxa-oneffice-token"));
	    	if(request.getHeader("bizboxa-oneffice-token") != null){
	    		//모바일 호출
	    		if(param.get("ref") != null && param.get("ref").equals("bizbox_report")){
	    			if(!htmlOnefficeReport.equals("")){
	    				htmlString = htmlOnefficeReport;
	    			}else{
						htmlString = request.getSession().getServletContext().getRealPath("/oneffice/oneffice.html");
		    			
		    			Logger.getLogger( OnefficeController.class ).debug( "OnefficeController.oneffice.do htmlString path : " +  htmlString);
		    			
		    			htmlString = Files.toString(new File(htmlString), Charsets.UTF_8);
		    			htmlOnefficeReport = htmlString;
	    			}
	    		}else{
		    		Logger.getLogger( OnefficeController.class ).debug( "OnefficeController.oneffice.do htmlOnefficeMobile : " +  htmlOnefficeMobile);
		    		if(!htmlOnefficeMobile.equals("")){
		    			htmlString = htmlOnefficeMobile;
		    		}else{
	    				htmlString = request.getSession().getServletContext().getRealPath("/oneffice/oneffice_view.html");
		    			
		    			Logger.getLogger( OnefficeController.class ).debug( "OnefficeController.oneffice.do htmlString path : " +  htmlString);
		    			
		    			htmlString = Files.toString(new File(htmlString), Charsets.UTF_8);
		    			htmlOnefficeMobile = htmlString;
		    		}
	    		}
	    		
	    		request.getSession().setAttribute("bizboxa_oneffice_token", request.getHeader("bizboxa-oneffice-token"));
	    		param.put("apiTp", "oneffice.do");
	    		param.put("reqType", "insertSession");
	    		param.put("data", request.getHeader("bizboxa-oneffice-token"));
	    		commonSql.insert("OnefficeDao.setApiLog", param);
	    		
	    	}else{
	    		
	    		Logger.getLogger( OnefficeController.class ).debug( "OnefficeController.oneffice.do htmlString path : " +  htmlString);
	    		Logger.getLogger( OnefficeController.class ).debug( "OnefficeController.oneffice.do htmlOnefficeString : " +  htmlOnefficeString);
	    		
	    		if(!htmlOnefficeString.equals("")){
	    			htmlString = htmlOnefficeString;
	    		}else{
	    			//htmlString = request.getSession().getServletContext().getRealPath("/html/oneffice.html");	    			
	    			htmlString = request.getSession().getServletContext().getRealPath("/oneffice/oneffice.html");
	    			htmlString = Files.toString(new File(htmlString), Charsets.UTF_8);
	    			
	    			/*
	    			LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
	    			String sessionKey = "";
	    			
	    			if(loginVO != null){
	    				sessionKey = AESCipher.AES_Encode(DateUtils.getCurrentTime("yyyyMMddHHmmss") + "▦" + loginVO.getUniqId() + "▦" + loginVO.getGroupSeq());
	    			}
	    			
	    			htmlString = htmlString.replace("{SESSION_KEY}", sessionKey);
	    			*/
	    			
	    			htmlOnefficeString = htmlString;
	    		}	    		
	    	}
	    	
	    	htmlString = htmlString.replace("{ONEFFICE_OG_TITLE}", result == null || result.get("doc_name") == null ? "" : result.get("doc_name").toString());
	    	htmlString = htmlString.replace("{ONEFFICE_OG_IMAGE}", request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + "/gw/oneffice/image/oneffice_og.png");
	    	
	    	if(param.get("ref") != null && param.get("ref").equals("bizbox_report")){
		    	htmlString = htmlString.replace("{ref}", param.get("ref"));
		    	htmlString = htmlString.replace("{report_no}", param.get("report_no"));
	    	}
	    }else if(docKey == null || (param.get("seq") == null && param.get("chgown") != null)) {
	    	//쿠키에 token저장
	    	Logger.getLogger( OnefficeController.class ).debug( "OnefficeController.oneffice.do bizboxa-oneffice-token : " +  request.getHeader("bizboxa-oneffice-token"));
	    		    	
	    	if(request.getHeader("bizboxa-oneffice-token") != null){
	    		Logger.getLogger( OnefficeController.class ).debug( "OnefficeController.oneffice.do htmlOnefficeIndexMobile : " +  htmlOnefficeIndexMobile);
	    		if(!htmlOnefficeIndexMobile.equals("")){
	    			htmlString = htmlOnefficeIndexMobile;
	    		}else{
    				htmlString = request.getSession().getServletContext().getRealPath("/oneffice/index.html");
	    			
	    			Logger.getLogger( OnefficeController.class ).debug( "OnefficeController.oneffice.do htmlString path : " +  htmlString);
	    			
	    			htmlString = Files.toString(new File(htmlString), Charsets.UTF_8);
	    			htmlOnefficeIndexMobile = htmlString;
	    		}
	    		
	    		request.getSession().setAttribute("bizboxa_oneffice_token", request.getHeader("bizboxa-oneffice-token"));
	    		param.put("apiTp", "oneffice.do");
	    		param.put("reqType", "insertSession");
	    		param.put("data", request.getHeader("bizboxa-oneffice-token"));
	    		commonSql.insert("OnefficeDao.setApiLog", param);
	    		
	    	}else{
	    		
	    		Logger.getLogger( OnefficeController.class ).debug( "OnefficeController.oneffice.do htmlString path : " +  htmlString);
	    		Logger.getLogger( OnefficeController.class ).debug( "OnefficeController.oneffice.do htmlOnefficeIndexMobile : " +  htmlOnefficeIndexMobile);
	    		
	    		if(!htmlOnefficeIndexMobile.equals("")){
	    			htmlString = htmlOnefficeIndexMobile;
	    		}else{
	    			//htmlString = request.getSession().getServletContext().getRealPath("/html/oneffice.html");	    			
	    			htmlString = request.getSession().getServletContext().getRealPath("/oneffice/index.html");
	    			htmlString = Files.toString(new File(htmlString), Charsets.UTF_8);	    			
	    			htmlOnefficeIndexMobile = htmlString;
	    		}	    		
	    	}	    	
	    }else if(result == null) {
	    	if(request.getHeader("bizboxa-oneffice-token") != null){
	    		htmlString = request.getSession().getServletContext().getRealPath("/oneffice/oneffice_view.html");
	    	}else {
	    		htmlString = request.getSession().getServletContext().getRealPath("/oneffice/oneffice.html");
	    	}	    	
	    	htmlString = Files.toString(new File(htmlString), Charsets.UTF_8);	
	    }

	    /*
	    //사파리 모드일때 Close 예외 처리 코드
	    @SuppressWarnings("unchecked")
		Map<String, Object> invalideResult = (Map<String, Object>) commonSql.select("OnefficeDao.isSafariEditorTimeInvalideTime", param);
	    if (invalideResult != null) {
	    	
	    	Map<String, String> deleteParamMap = new HashMap<String, String>();
	    	
	    	deleteParamMap.put("doc_no", param.get("doc_no"));
	    	deleteParamMap.put("empSeq", (String) invalideResult.get("editor_id"));
	    	deleteParamMap.put("editor_id", (String) invalideResult.get("editor_id"));
	    	deleteParamMap.put("access_perm", "W");
	    	
	    	commonSql.delete("OnefficeDao.accessDocument_1", deleteParamMap);
	    	commonSql.delete("OnefficeDao.manager_delete_docno", deleteParamMap);
	    }
	    */
	    
	    response.setContentType("text/html;charset=utf-8");
	    response.setHeader("Cache-Control", "no-cache");
	    PrintWriter out = null ;
        out = response.getWriter();
        out.println(htmlString);
        out.flush();
        
        Logger.getLogger( OnefficeController.class ).debug( "OnefficeController.oneffice.do htmlString : " +  htmlString);
	    
	    return null;
	}
		
	@RequestMapping(value="/oneffice/initOnefficeCache.do")
	public void initOnefficeCache(Map<String, Object> paramMap, HttpServletRequest request, HttpServletResponse response) {
		htmlOnefficeString = "";
		htmlOnefficeMobile = "";
		htmlOnefficeReport = "";
		htmlOnefficeClientString = "";
		htmlOnefficeIndexMobile = "";
		return;
	}
	
	
	@RequestMapping(value="/oneffice/onefficeClient.do")
	public void onefficeClient(@RequestParam Map<String, Object> paramMap, HttpServletRequest request, HttpServletResponse response) throws IOException, InvalidKeyException, NoSuchAlgorithmException, NoSuchPaddingException, InvalidAlgorithmParameterException, IllegalBlockSizeException, BadPaddingException {
		
		//원피스 전용세션 처리
		request.getSession().removeAttribute("bizboxa_oneffice_emp_seq");
		String sessionKey = AESCipher.AES_Decode(paramMap.get("sessionKey").toString());
		String reqTime = sessionKey.split("▦")[0];
		
		DateTimeFormatter formatter = DateTimeFormat.forPattern("yyyyMMddHHmmss");
		DateTime nowDT = DateTime.now().minusSeconds(10);
		DateTime ssoDT = formatter.parseDateTime(reqTime);
		
		if(ssoDT.isAfter(nowDT)){
			request.getSession().setAttribute("bizboxa_oneffice_emp_seq", sessionKey);
		}
		
		String htmlString = "";
		
		if(!htmlOnefficeClientString.equals("")){
			htmlString = htmlOnefficeClientString;
		}else{
			htmlString = request.getSession().getServletContext().getRealPath("/html/onefficeClient.html");
			htmlString = Files.toString(new File(htmlString), Charsets.UTF_8);
			htmlString = htmlString.replace("{SEQ}", paramMap.get("seq").toString());
			
			htmlOnefficeClientString = htmlString;
		}
		
		response.setContentType("text/html;charset=utf-8");
	    response.setHeader("Cache-Control", "no-cache");
	    PrintWriter out = null ;
        out = response.getWriter();
        out.println(htmlString);
	    
	    return;
	}	

	@RequestMapping(value="/onefficeApi/getDocumentList.do")
	public ModelAndView getDocumentList(@RequestParam Map<String, Object> paramMap, HttpServletRequest request, HttpServletResponse response) {
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		
		LoginVO loginVO = checkLoginVO(request);
		
		if(loginVO != null){
			paramMap.put("groupSeq", loginVO.getGroupSeq());
			paramMap.put("empSeq", loginVO.getUniqId());
			
			@SuppressWarnings("unchecked")
			List<Map<String, Object>> result = (List<Map<String, Object>>) commonSql.list("OnefficeDao.getDocumentList", paramMap);
			mv.addObject("result","success");
			mv.addObject("data",result);			
		}else{
			mv.addObject("result","fail");
		}
		
		return mv;
	}
	
	@SuppressWarnings("deprecation")
	@RequestMapping(value="/onefficeApi/getSearchDocumentList.do")
	public ModelAndView getSearchDocumentList(@RequestParam Map<String, Object> paramMap, HttpServletRequest request, HttpServletResponse response) throws UnsupportedEncodingException {
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		
		LoginVO loginVO = checkLoginVO(request);
		
		if(loginVO != null){
			paramMap.put("groupSeq", loginVO.getGroupSeq());
			paramMap.put("empSeq", loginVO.getUniqId());
			paramMap.put("langCode", loginVO.getLangCode());
			
			if(paramMap.get("keyword") != null && !paramMap.get("keyword").equals("")){
				paramMap.put("keyword", URLDecoder.decode(paramMap.get("keyword").toString(),"UTF-8"));
			}
			
			@SuppressWarnings("unchecked")
			List<Map<String, Object>> result = (List<Map<String, Object>>) commonSql.list("OnefficeDao.getSearchDocumentList", paramMap);
			mv.addObject("result","success");
			mv.addObject("data",result);			
		}else{
			mv.addObject("result","fail");
		}
		
		return mv;
	}	
	
	@RequestMapping(value="/onefficeApi/getImportantDocumentList.do")
	public ModelAndView getImportantDocumentList(@RequestParam Map<String, Object> paramMap, HttpServletRequest request, HttpServletResponse response) {
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		
		LoginVO loginVO = checkLoginVO(request);
		
		if(loginVO != null){
			paramMap.put("groupSeq", loginVO.getGroupSeq());
			paramMap.put("empSeq", loginVO.getUniqId());
			
			@SuppressWarnings("unchecked")
			List<Map<String, Object>> result = (List<Map<String, Object>>) commonSql.list("OnefficeDao.getImportantDocumentList", paramMap);
			mv.addObject("result","success");
			mv.addObject("data",result);			
		}else{
			mv.addObject("result","fail");
		}
		
		return mv;
	}
	
	@RequestMapping(value="/onefficeApi/getDocument.do")
	public ModelAndView getDocument(@RequestParam Map<String, Object> paramMap, HttpServletRequest request, HttpServletResponse response) throws JsonParseException, JsonMappingException, IOException {
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		
		Logger.getLogger( OnefficeController.class ).debug( "OnefficeController.getDocument.do paramMap : " +  paramMap);
		
		LoginVO loginVO = checkLoginVO(request);
		
		Logger.getLogger( OnefficeController.class ).debug( "OnefficeController.getDocument.do loginVO : " +  loginVO);
		
		//모바일 비세션 처리(토큰 헤더방식)
		boolean mobileToken = false;
		
		Logger.getLogger( OnefficeController.class ).debug( "OnefficeController.getDocument.do bizboxa_oneffice_token : " +  request.getSession().getAttribute("bizboxa_oneffice_token"));
		
		if(loginVO == null && request.getSession().getAttribute("bizboxa_oneffice_token") != null){
			
			String bizboxaOnefficeToken = (String) request.getSession().getAttribute("bizboxa_oneffice_token");
			
			loginVO = new LoginVO();
			loginVO.setGroupSeq(paramMap.get("groupSeq").toString());
			
			if(request.getSession().getAttribute("bizboxa_oneffice_emp_seq") != null && request.getSession().getAttribute("bizboxa_oneffice_emp_seq").toString().contains(bizboxaOnefficeToken)){
				loginVO.setUniqId(request.getSession().getAttribute("bizboxa_oneffice_emp_seq").toString().split("▦")[1]);
				mobileToken = true;				
			}else{
				
				paramMap.put("apiTp", "getDocument.do");
				paramMap.put("reqType", "getSession");
				paramMap.put("data", bizboxaOnefficeToken);
	    		commonSql.insert("OnefficeDao.setApiLog", paramMap);
				
				Map<String, Object> groupInfo = (Map<String, Object>) commonSql.select("OnefficeDao.getGroupInfo", paramMap);
				
				Logger.getLogger( OnefficeController.class ).debug( "OnefficeController.getDocument.do groupInfo : " +  groupInfo);
				
				if(groupInfo != null){
					//API호출
					//token으로 사용자 시퀀스 가져오기
					JSONObject jsonObj = new JSONObject();
					JSONObject header = new JSONObject();
					JSONObject body = new JSONObject();
					
					header.put("companyId", "");
					header.put("userId", "");
					header.put("token", "");
					header.put("tId", "0");
					header.put("pId", "P011");
					header.put("appType", "11");
					body.put("mobileId", groupInfo.get("mobile_id"));
					body.put("token", bizboxaOnefficeToken);
					
					jsonObj.put("header", header);
					jsonObj.put("body", body);
			
					String apiUrl = groupInfo.get("oneffice_token_api_url").toString() + "/BizboxMobileGateway/service/SearchTokenInfo";
					
					paramMap.put("apiTp", "SearchTokenInfo");
					paramMap.put("reqType", "param");
					paramMap.put("data", apiUrl + " > " + jsonObj.toString());
		    		commonSql.insert("OnefficeDao.setApiLog", paramMap);
					
					Map<String, Object> result = callApiToMap(jsonObj, apiUrl);
					
					Logger.getLogger( OnefficeController.class ).debug( "OnefficeController.getDocument.do result : " +  result);
					
					paramMap.put("apiTp", "SearchTokenInfo");
					paramMap.put("reqType", "result");
					paramMap.put("data", result.toString());
		    		commonSql.insert("OnefficeDao.setApiLog", paramMap);				
					
					if(result != null && result.get("resultCode").equals("0")){
						@SuppressWarnings("unchecked")
						Map<String, Object> resultInfo = (Map<String, Object>) result.get("result");
						
						Logger.getLogger( OnefficeController.class ).debug( "OnefficeController.getDocument.do resultInfo : " + resultInfo);
						Logger.getLogger( OnefficeController.class ).debug( "OnefficeController.getDocument.do bizboxa_oneffice_emp_seq : " + bizboxaOnefficeToken + "▦" + resultInfo.get("empSeq").toString() + "▦" + paramMap.get("groupSeq").toString());
						
						if(resultInfo != null && resultInfo.get("empSeq") != null){
							loginVO.setUniqId(resultInfo.get("empSeq").toString());
							request.getSession().setAttribute("bizboxa_oneffice_emp_seq", bizboxaOnefficeToken + "▦" + resultInfo.get("empSeq").toString() + "▦" + paramMap.get("groupSeq").toString());
							mobileToken = true;
						}
					}
				}				
			}
		}
		
		if(loginVO != null || mobileToken){
			paramMap.put("groupSeq", loginVO.getGroupSeq());
			paramMap.put("empSeq", loginVO.getUniqId());
			
			//보안문서여부 체크
			Map<String, Object> secuKeyMap = (Map<String, Object>) commonSql.select("OnefficeDao.getDocumentSecurityKey", paramMap);			
			if(secuKeyMap != null && paramMap.get("security_key") != null){
				if(secuKeyMap.get("security_key") != null && !secuKeyMap.get("security_key").toString().equals("")){
					paramMap.put("isSecureDoc", "Y");
				}
			}
			
			@SuppressWarnings("unchecked")
			Map<String, Object> result = (Map<String, Object>) commonSql.select("OnefficeDao.getDocument", paramMap);
			
			if(result != null){
				
				if(!result.get("owner_id").equals(loginVO.getUniqId()) && result.get("share_type") != null && result.get("share_type").equals("9")){
					//해당 문서가 OpenLink로 설정 되어 있는지 확인 하자.
					//OpenLink로 열어 본 사용자가 있는지 체크 하자.
					paramMap.put("share_id", loginVO.getUniqId());
					paramMap.put("empSeq", result.get("owner_id"));
					paramMap.put("share_perm", result.get("share_perm"));
					
					Map<String, Object> openLinkParamMap = (Map<String, Object>) commonSql.select("OnefficeDao.getOpenShareDocument", paramMap);
					if (openLinkParamMap != null) 
					{
						Map<String, Object> userShareDocument = (Map<String, Object>) commonSql.select("OnefficeDao.getShareDocument", paramMap);
						
						if (userShareDocument != null) {
							if ("9".equals(userShareDocument.get("share_type"))  && !userShareDocument.get("share_perm").equals(openLinkParamMap.get("share_perm"))) 
							{
								paramMap.put("share_perm", openLinkParamMap.get("share_perm"));
								Logger.getLogger( OnefficeController.class ).debug("getDocument Update Share =  " + paramMap);
								commonSql.update("OnefficeDao.updateShareDocument", paramMap);	
							}
						}else {
							paramMap.put("empSeq", openLinkParamMap.get("owner_id"));
							paramMap.put("share_perm", openLinkParamMap.get("share_perm"));
							paramMap.put("share_type", openLinkParamMap.get("share_type"));
							Logger.getLogger( OnefficeController.class ).debug("getDocument Insert Share =  " + paramMap);
							commonSql.insert("OnefficeDao.shareDocument", paramMap);
						}
					}
				}
				/*
				if(!result.get("owner_id").equals(loginVO.getUniqId()) && result.get("share_type") != null && result.get("share_type").equals("9")){
					
					paramMap.put("share_id", loginVO.getUniqId());
					paramMap.put("empSeq", result.get("owner_id"));
					paramMap.put("share_perm", result.get("share_perm"));
					
					Map<String, Object> shareDocument = (Map<String, Object>) commonSql.select("OnefficeDao.getShareDocument", paramMap);
					
					
					if(shareDocument != null) {
						if (shareDocument.get("share_type").equals("9")) {
							if(!shareDocument.get("share_type").equals(result.get("share_type")) || !shareDocument.get("share_perm").equals(result.get("share_perm"))){
								//EX) 읽기모드로 지정 -> 오프링크로 편집권한 -> 문서 Open -> 쓰기권한으로 DB 업데이트 코드
								Logger.getLogger( OnefficeController.class ).debug("getDocument Update Share =  " + paramMap);
								//commonSql.update("OnefficeDao.updateShareDocument", paramMap);	
								
							}							
						}
					}else{
						Logger.getLogger( OnefficeController.class ).debug("getDocument Insert Share =  " + paramMap);
						commonSql.insert("OnefficeDao.shareDocument", paramMap);
					}
				}
				*/
				
				//원피스 문서조회 로그(운영일경우에만 처리)
				if(BizboxAProperties.getProperty("BizboxA.mode").equals("live") || BizboxAProperties.getProperty("BizboxA.mode").equals("dev")) {
		        	ActionDTO action = new ActionDTO(EnumActionStep1.OnefficeInquiry, EnumActionStep2.ActionNone, EnumActionStep3.ActionNone);
		
		    		CreatorInfoDTO creatorInfo = new CreatorInfoDTO();
		    		creatorInfo.setEmpSeq(loginVO.getUniqId());
		    		creatorInfo.setCompSeq(loginVO.getOrganId());
		    		creatorInfo.setDeptSeq(loginVO.getOrgnztId());
		    		creatorInfo.setGroupSeq(loginVO.getGroupSeq());
		    		
		    		org.json.simple.JSONObject actionID = new org.json.simple.JSONObject();
		    		actionID.put("doc_no", result.get("doc_no"));
		    		
		    		ModuleLogService.getInstance().writeStatisticLog(EnumModuleName.MODULE_ONEFFICE, creatorInfo, action, actionID, loginVO.getIp(), EnumDevice.Web);
		    	}

				Logger.getLogger( OnefficeController.class ).debug( "OnefficeController.getDocument.do mobile_open : " +  paramMap.get("mobile_open"));

				if (paramMap.get("mobile_open")!= null && paramMap.get("mobile_open").equals("M")) {
					result.put("user_id", loginVO.getUniqId());
					Logger.getLogger( OnefficeController.class ).debug( "OnefficeController.getDocument.do loginVO.getUniqId() : " +  loginVO.getUniqId());
					result.put("groupSeq", loginVO.getGroupSeq());
					setRecentDocument(result);
				}
				
				mv.addObject("result","success");
				result.put("gw_url",request.getScheme() + "://" + request.getServerName() + (request.getServerPort() == 80 ? "" : ":" + request.getServerPort()) + "/");
				mv.addObject("data",result);
				
			}else{
				mv.addObject("result","fail");
			}		
		}else{
			
			@SuppressWarnings("unchecked")
			Map<String, Object> result = (Map<String, Object>) commonSql.select("OnefficeDao.getDocument", paramMap);			
			
			if(result.get("share_type").equals("9")){
				mv.addObject("result","success");
				result.put("gw_url",request.getScheme() + "://" + request.getServerName() + (request.getServerPort() == 80 ? "" : ":" + request.getServerPort()) + "/");
				mv.addObject("data",result);
			}else{
				mv.addObject("result","fail");	
			}
		}
		
		return mv;
	}
	
	 public Map<String, Object> callApiToMap(JSONObject jsonObject, String url) throws JsonParseException, JsonMappingException, IOException{
		 HttpJsonUtil httpJson = new HttpJsonUtil();
		 @SuppressWarnings("static-access")
		 String returnStr = httpJson.execute("POST", url, jsonObject);
		 ObjectMapper om = new ObjectMapper();
		 Map<String, Object> m = om.readValue(returnStr, new TypeReference<Map<String, Object>>(){});
		 return m;
	 }	
	
	@RequestMapping(value="/onefficeApi/createFolder.do")
	public ModelAndView createFolder(@RequestParam Map<String, Object> paramMap, HttpServletRequest request, HttpServletResponse response) {
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		
		LoginVO loginVO = checkLoginVO(request);
		
		if(loginVO != null){
			paramMap.put("groupSeq", loginVO.getGroupSeq());
			paramMap.put("empSeq", loginVO.getUniqId());
			
			String docNo = UUID.randomUUID().toString().replace("-", "");
			paramMap.put("doc_no", docNo);
			commonSql.insert("OnefficeDao.createFolder", paramMap);			
			
			//원피스 폴더 생성 로그(운영일경우에만 처리)
			if(BizboxAProperties.getProperty("BizboxA.mode").equals("live") || BizboxAProperties.getProperty("BizboxA.mode").equals("dev")) {
	        	ActionDTO action = new ActionDTO(EnumActionStep1.OnefficeCreate, EnumActionStep2.OnefficeFolder, EnumActionStep3.ActionNone);
	
	    		CreatorInfoDTO creatorInfo = new CreatorInfoDTO();
	    		creatorInfo.setEmpSeq(loginVO.getUniqId());
	    		creatorInfo.setCompSeq(loginVO.getOrganId());
	    		creatorInfo.setDeptSeq(loginVO.getOrgnztId());
	    		creatorInfo.setGroupSeq(loginVO.getGroupSeq());
	    		
	    		org.json.simple.JSONObject actionID = new org.json.simple.JSONObject();
	    		actionID.put("folder_no", docNo);
	    		
	    		ModuleLogService.getInstance().writeStatisticLog(EnumModuleName.MODULE_ONEFFICE, creatorInfo, action, actionID, loginVO.getIp(), EnumDevice.Web);
	    	}			
			
			Map<String, Object> result = new HashMap<String, Object>();
			result.put("doc_no", docNo);
			mv.addObject("result","success");
			mv.addObject("data",result);
		}else{
			mv.addObject("result","fail");
		}
		
		return mv;
	}
	
	@RequestMapping(value="/onefficeApi/updateFolder.do")
	public ModelAndView updateFolder(@RequestParam Map<String, Object> paramMap, HttpServletRequest request, HttpServletResponse response) {
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		
		LoginVO loginVO = checkLoginVO(request);
		
		if(loginVO != null){
			paramMap.put("groupSeq", loginVO.getGroupSeq());
			paramMap.put("empSeq", loginVO.getUniqId());
			
			commonSql.update("OnefficeDao.updateFolder", paramMap);
			
			Map<String, Object> result = new HashMap<String, Object>();
			result.put("doc_no", paramMap.get("doc_no"));
			mv.addObject("result","success");
			mv.addObject("data",result);
		}else{
			mv.addObject("result","fail");
		}
		
		return mv;
	}
	
	@RequestMapping(value="/onefficeApi/deleteFolder.do")
	public ModelAndView deleteFolder(@RequestParam Map<String, Object> paramMap, HttpServletRequest request, HttpServletResponse response) {
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		
		LoginVO loginVO = checkLoginVO(request);
		
		if(loginVO != null){
			paramMap.put("groupSeq", loginVO.getGroupSeq());
			paramMap.put("empSeq", loginVO.getUniqId());
			
			commonSql.update("OnefficeDao.deleteFolder", paramMap);
			
			Map<String, Object> result = new HashMap<String, Object>();
			result.put("doc_no", paramMap.get("doc_no"));
			mv.addObject("result","success");
			mv.addObject("data",result);
		}else{
			mv.addObject("result","fail");
		}
		
		return mv;
	}	
	
	@RequestMapping(value="/onefficeApi/createDocument.do")
	public ModelAndView createDocument(@RequestParam Map<String, Object> paramMap, HttpServletRequest request, HttpServletResponse response) {
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		
		LoginVO loginVO = checkLoginVO(request);
		
		if(loginVO != null){
			paramMap.put("groupSeq", loginVO.getGroupSeq());
			paramMap.put("empSeq", loginVO.getUniqId());
			
			String docNo = UUID.randomUUID().toString().replace("-", "");
			paramMap.put("doc_no", docNo);
			
			if(paramMap.get("content") != null && !paramMap.get("content").equals("")){
				paramMap.put("contentSize", String.valueOf(paramMap.get("content").toString().getBytes().length));	
			}else{
				paramMap.put("contentSize", "0");	
			}
			
			commonSql.insert("OnefficeDao.createDocument", paramMap);
			
			//원피스 문서 생성 로그(운영일경우에만 처리)
			if(BizboxAProperties.getProperty("BizboxA.mode").equals("live") || BizboxAProperties.getProperty("BizboxA.mode").equals("dev")) {
	        	ActionDTO action = new ActionDTO(EnumActionStep1.OnefficeCreate, EnumActionStep2.OnefficeDocument, EnumActionStep3.ActionNone);
	
	    		CreatorInfoDTO creatorInfo = new CreatorInfoDTO();
	    		creatorInfo.setEmpSeq(loginVO.getUniqId());
	    		creatorInfo.setCompSeq(loginVO.getOrganId());
	    		creatorInfo.setDeptSeq(loginVO.getOrgnztId());
	    		creatorInfo.setGroupSeq(loginVO.getGroupSeq());
	    		
	    		org.json.simple.JSONObject actionID = new org.json.simple.JSONObject();
	    		actionID.put("doc_no", docNo);
	    		
	    		ModuleLogService.getInstance().writeStatisticLog(EnumModuleName.MODULE_ONEFFICE, creatorInfo, action, actionID, loginVO.getIp(), EnumDevice.Web);
	    	}
			
			
			Map<String, Object> result = new HashMap<String, Object>();
			result.put("doc_no", docNo);
			mv.addObject("result","success");
			mv.addObject("data",result);
		}else{
			mv.addObject("result","fail");
		}
		
		return mv;
	}		
	
	@RequestMapping(value="/onefficeApi/updateDocument.do")
	public ModelAndView updateDocument(@RequestParam Map<String, Object> paramMap, HttpServletRequest request, HttpServletResponse response) {
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		
		LoginVO loginVO = checkLoginVO(request);
		
		if(loginVO != null){
			
			paramMap.put("groupSeq", loginVO.getGroupSeq());
			paramMap.put("empSeq", loginVO.getUniqId());			
			
			@SuppressWarnings("unchecked")
			Map<String, Object> docInfo = (Map<String, Object>) commonSql.select("OnefficeDao.getDocument", paramMap);
			
			if(docInfo != null){
				if((paramMap.get("content") != null && !paramMap.get("content").equals("")) && (docInfo.get("readonly").equals("1") || (!docInfo.get("owner_id").equals(loginVO.getUniqId()) && docInfo.get("share_perm").equals("R")))){
					mv.addObject("result","fail");
					mv.addObject("data","");
					mv.addObject("msg","ReadOnly Document");
				}else{
					if(paramMap.get("content") != null && !paramMap.get("content").equals("")){
						paramMap.put("contentSize", String.valueOf(paramMap.get("content").toString().getBytes().length));
					}
					
					//보안문서여부 체크
					Map<String, Object> secuKeyMap = (Map<String, Object>) commonSql.select("OnefficeDao.getDocumentSecurityKey", paramMap);			
					if(secuKeyMap != null){
						if(secuKeyMap.get("security_key") != null && !secuKeyMap.get("security_key").toString().equals("")){
							paramMap.put("isSecureDoc", "Y");
						}
					}
					
					if(paramMap.get("security_key") != null && !paramMap.get("security_key").toString().equals("")) {
						//원피스 문서보 안로그(운영일경우에만 처리)
						if(BizboxAProperties.getProperty("BizboxA.mode").equals("live") || BizboxAProperties.getProperty("BizboxA.mode").equals("dev")) {
				        	ActionDTO action = new ActionDTO(EnumActionStep1.OnefficeSecurity, EnumActionStep2.ActionNone, EnumActionStep3.ActionNone);
				
				    		CreatorInfoDTO creatorInfo = new CreatorInfoDTO();
				    		creatorInfo.setEmpSeq(loginVO.getUniqId());
				    		creatorInfo.setCompSeq(loginVO.getOrganId());
				    		creatorInfo.setDeptSeq(loginVO.getOrgnztId());
				    		creatorInfo.setGroupSeq(loginVO.getGroupSeq());
				    		
				    		org.json.simple.JSONObject actionID = new org.json.simple.JSONObject();
				    		actionID.put("doc_no", paramMap.get("doc_no"));
				    		
				    		ModuleLogService.getInstance().writeStatisticLog(EnumModuleName.MODULE_ONEFFICE, creatorInfo, action, actionID, loginVO.getIp(), EnumDevice.Web);
				    	}
					}
					

					commonSql.update("OnefficeDao.updateDocument", paramMap);
					Map<String, Object> result = new HashMap<String, Object>();
					result.put("doc_no", paramMap.get("doc_no"));
					mv.addObject("result","success");
					mv.addObject("data",result);
				}
			}

		}else{
			mv.addObject("result","fail");
		}
		
		return mv;
	}	
	
	@RequestMapping(value="/onefficeApi/deleteDocument.do")
	public ModelAndView deleteDocument(@RequestParam Map<String, Object> paramMap, HttpServletRequest request, HttpServletResponse response) {
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		
		LoginVO loginVO = checkLoginVO(request);
		
		if(loginVO != null){
			paramMap.put("groupSeq", loginVO.getGroupSeq());
			paramMap.put("empSeq", loginVO.getUniqId());
			paramMap.put("owner_id", loginVO.getUniqId());
			
			commonSql.update("OnefficeDao.deleteDocument", paramMap);
			commonSql.update("OnefficeDao.deleteRecentDocument", paramMap);

	//원피스 문서삭제 로그(운영일경우에만 처리)
			if(BizboxAProperties.getProperty("BizboxA.mode").equals("live") || BizboxAProperties.getProperty("BizboxA.mode").equals("dev")) {
	        	ActionDTO action = new ActionDTO(EnumActionStep1.OnefficeDelete, EnumActionStep2.ActionNone, EnumActionStep3.ActionNone);
	
	    		CreatorInfoDTO creatorInfo = new CreatorInfoDTO();
	    		creatorInfo.setEmpSeq(loginVO.getUniqId());
	    		creatorInfo.setCompSeq(loginVO.getOrganId());
	    		creatorInfo.setDeptSeq(loginVO.getOrgnztId());
	    		creatorInfo.setGroupSeq(loginVO.getGroupSeq());
	    		
	    		org.json.simple.JSONObject actionID = new org.json.simple.JSONObject();
	    		actionID.put("doc_no", paramMap.get("doc_no"));
	    		
	    		ModuleLogService.getInstance().writeStatisticLog(EnumModuleName.MODULE_ONEFFICE, creatorInfo, action, actionID, loginVO.getIp(), EnumDevice.Web);
	    	}
			
			
			Map<String, Object> result = new HashMap<String, Object>();
			result.put("doc_no", paramMap.get("doc_no"));
			mv.addObject("result","success");
			mv.addObject("data",result);
		}else{
			mv.addObject("result","fail");
		}
		
		return mv;
	}
	
	
	@RequestMapping(value="/onefficeApi/deleteRecentDocument.do")
	public ModelAndView deleteRecentDocument(@RequestParam Map<String, Object> paramMap, HttpServletRequest request, HttpServletResponse response) {
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		
		LoginVO loginVO = checkLoginVO(request);
		
		if(loginVO != null){
			paramMap.put("groupSeq", loginVO.getGroupSeq());
			paramMap.put("empSeq", loginVO.getUniqId());
			
			int nRet = commonSql.delete("OnefficeDao.deleteRecentDocument", paramMap);
			
			if (nRet > 0 ) {
				mv.addObject("result","success");
			}else {
				mv.addObject("result","fail");
				mv.addObject("failResult","delete_fail");
			}
		}else{
			mv.addObject("result","fail");
			mv.addObject("failResult","login_error");
		}
		
		return mv;
	}
	
	@RequestMapping(value="/onefficeApi/getTrashList.do")
	public ModelAndView getTrashList(@RequestParam Map<String, Object> paramMap, HttpServletRequest request, HttpServletResponse response) {
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		
		LoginVO loginVO = checkLoginVO(request);
		
		if(loginVO != null){
			paramMap.put("groupSeq", loginVO.getGroupSeq());
			paramMap.put("empSeq", loginVO.getUniqId());
			
			@SuppressWarnings("unchecked")
			List<Map<String, Object>> result = (List<Map<String, Object>>) commonSql.list("OnefficeDao.getTrashList", paramMap);
			mv.addObject("result","success");
			mv.addObject("data",result);			
		}else{
			mv.addObject("result","fail");
		}
		
		return mv;
	}	
	
	@RequestMapping(value="/onefficeApi/recoverTrashDocument.do")
	public ModelAndView recoverTrashDocument(@RequestParam Map<String, Object> paramMap, HttpServletRequest request, HttpServletResponse response) {
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		
		LoginVO loginVO = checkLoginVO(request);
		
		if(loginVO != null){
			paramMap.put("groupSeq", loginVO.getGroupSeq());
			paramMap.put("empSeq", loginVO.getUniqId());
			
			commonSql.update("OnefficeDao.recoverTrashDocument", paramMap);
			
			Map<String, Object> result = new HashMap<String, Object>();
			result.put("doc_no", paramMap.get("doc_no"));
			mv.addObject("result","success");
			mv.addObject("data",result);
		}else{
			mv.addObject("result","fail");
		}
		
		return mv;
	}	
	
	@RequestMapping(value="/onefficeApi/deleteTrashDocument.do")
	public ModelAndView deleteTrashDocument(@RequestParam Map<String, Object> paramMap, HttpServletRequest request, HttpServletResponse response) throws Exception {
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		
		LoginVO loginVO = checkLoginVO(request);
		
		if(loginVO != null){
			paramMap.put("groupSeq", loginVO.getGroupSeq());
			paramMap.put("empSeq", loginVO.getUniqId());
			
			
			//실제 파일 삭제처리.
			boolean cloudYn = false;
			String uploadPath = "";
			if(CloudConnetInfo.getBuildType().equals("cloud")){
				cloudYn = true;
			}	
			
			paramMap.put("groupSeq", loginVO.getGroupSeq());
			paramMap.put("pathSeq", "0");
			paramMap.put("osType", NeosConstants.SERVER_OS);
			
			if(CloudConnetInfo.getBuildType().equals("cloud")){
				cloudYn = true;
			}		
			String absolPath = "";
			Map<String, Object> pathMap = groupManageService.selectGroupPath(paramMap);
			if(pathMap != null){
				absolPath = pathMap.get("absolPath").toString();	
			}
			
			uploadPath = absolPath + "/onefficeFile/";					
			
            boolean bFolderDelete = false;
			List<Map<String, Object>> list = commonSql.list("OnefficeDao.selectTrashDocument",  paramMap);
			for(Map<String, Object> mp : list){
				String path = uploadPath + (String)mp.get("owner_id") + "/" + (String)mp.get("doc_no") + "/";
				deleteAllFiles(path);
				
				if ("0".equals(mp.get("doc_type").toString())) {
					bFolderDelete = true;
				}
					
			}
			
			commonSql.delete("OnefficeDao.deleteTrashDocument", paramMap);

			if (bFolderDelete) {
				// 하위폴더 및 문서 삭제
				paramMap.put("folderNo", paramMap.get("doc_no"));
				Map<String, Object> returnMap = getFolderNoStr(paramMap);

				paramMap.put("folderNoStr", returnMap.get("folderNoStr"));
				paramMap.put("subFolderDeleteList", returnMap.get("subFolderDeleteList"));

				List<Map<String, Object>> list2 = commonSql.list("OnefficeDao.selectTrashDocumentChild", paramMap);
				for (Map<String, Object> mp : list2) {
					String path = uploadPath + "/" + (String) mp.get("doc_no") + "/";
					deleteAllFiles(path);
				}

				commonSql.delete("OnefficeDao.deleteTrashDocumentChild", paramMap);				
			}
			
			Map<String, Object> result = new HashMap<String, Object>();
			result.put("doc_no", paramMap.get("doc_no"));
			mv.addObject("result","success");
			mv.addObject("data",result);
		}else{
			mv.addObject("result","fail");
		}
		
		return mv;
	}	
	
	@RequestMapping(value="/onefficeApi/emptyTrash.do")
	public ModelAndView emptyTrash(@RequestParam Map<String, Object> para, HttpServletRequest request, HttpServletResponse response) throws Exception {
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		
		LoginVO loginVO = checkLoginVO(request);
		
		if(loginVO != null){
			
			Map<String, Object> paramMap = new HashMap<String, Object>();
			
			paramMap.put("groupSeq", loginVO.getGroupSeq());
			paramMap.put("empSeq", loginVO.getUniqId());
			
			//삭제폴더 하위 폴더 및 문서 삭제
			String folderNoStr = (String) commonSql.select("OnefficeDao.getTrashAllFolderNoStr", paramMap);
			paramMap.put("folderNo", folderNoStr);

			Map<String, Object> returnMap = getFolderNoStr(paramMap);

			paramMap.put("folderNoStr", returnMap.get("folderNoStr"));
			paramMap.put("subFolderDeleteList", returnMap.get("subFolderDeleteList"));
			// 실제 파일 삭제처리.
			boolean cloudYn = false;
			String uploadPath = "";
			if(CloudConnetInfo.getBuildType().equals("cloud")){
				cloudYn = true;
			}	
			
			paramMap.put("groupSeq", loginVO.getGroupSeq());
			paramMap.put("pathSeq", "0");
			paramMap.put("osType", NeosConstants.SERVER_OS);
		
			String absolPath = "";
			Map<String, Object> pathMap = groupManageService.selectGroupPath(paramMap);
			if(pathMap != null){
				absolPath = pathMap.get("absolPath").toString();	
			}
			
			uploadPath = absolPath + "/onefficeFile/";

			boolean bSubFolderDelete = false;
			List<Map<String, Object>> list = commonSql.list("OnefficeDao.selectTrashDocumentChild", paramMap);
			for (Map<String, Object> mp : list) {
				String path = uploadPath + (String) mp.get("owner_id") + "/" + (String) mp.get("doc_no") + "/";
				deleteAllFiles(path);
				if ("0".equals(mp.get("doc_type").toString())) {
					bSubFolderDelete = true;
				}
			}
			
			if (bSubFolderDelete) {
				commonSql.delete("OnefficeDao.deleteTrashDocumentChild", paramMap);
			}
						

			List<Map<String, Object>> list2 = commonSql.list("OnefficeDao.selectEmptyTrash", paramMap);
			for (Map<String, Object> mp : list2) {
				String path = uploadPath + "/" + (String) mp.get("doc_no") + "/";
				deleteAllFiles(path);
			}			
			//삭제된 문서 전체삭제
			commonSql.delete("OnefficeDao.emptyTrash", paramMap);
			
						
			
			mv.addObject("result","success");
		}else{
			mv.addObject("result","fail");
		}
		
		return mv;
	}		
	
	@RequestMapping(value="/onefficeApi/checkSession.do")
	public ModelAndView checkSession(@RequestParam Map<String, Object> paramMap, HttpServletRequest request, HttpServletResponse response) {
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		
		Logger.getLogger( OnefficeController.class ).debug( "OnefficeController.checkSession.do paramMap : " +  paramMap);
		Logger.getLogger( OnefficeController.class ).debug( "OnefficeController.checkSession.do bizboxa_oneffice_token : " +  request.getSession().getAttribute("bizboxa_oneffice_token"));
		
		Map<String, Object> result = new HashMap<String, Object>();
		LoginVO loginVO = checkLoginVO(request);
		
		if(loginVO != null){
			result.put("login", "1");
			
		}else{
			if(request.getSession().getAttribute("bizboxa_oneffice_token") != null){
				result.put("login", "1");
				
			}else{
				result.put("login", "0");	
			}
		}
		
		result.put("login_url", "/gw/uat/uia/egovLoginUsr.do");
		mv.addObject("result","success");
		mv.addObject("data",result);
		
		return mv;
	}		
	
	@RequestMapping(value="/onefficeApi/shareDocument.do")
	public ModelAndView shareDocument(@RequestParam Map<String, Object> paramMap, HttpServletRequest request, HttpServletResponse response) {
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		
		LoginVO loginVO = checkLoginVO(request);
		boolean bCheck = false;
		
		if(loginVO != null){
			paramMap.put("groupSeq", loginVO.getGroupSeq());
			paramMap.put("empSeq", loginVO.getUniqId());
			
            //// 추가 
			if (paramMap.get("share_type").equals("9") ) {
				Map<String, Object> unshareParamMap = new HashMap<String, Object>();
				unshareParamMap.put("share_type", "9");
				unshareParamMap.put("doc_no", paramMap.get("doc_no"));
				if (paramMap.get("share_perm").equals("R")) {
					unshareParamMap.put("share_perm","R");
					unshareParamMap.put("compareshareperm","W");
					
					bCheck = true;
				}
				else // 읽기 모드에서 쓰기모드로 변경시
				{
					unshareParamMap.put("share_perm","W");
					unshareParamMap.put("compareshareperm","R");
				}
				commonSql.update("OnefficeDao.linkupdateShareDocument", unshareParamMap);
			}
            // 추가 끝
			commonSql.delete("OnefficeDao.shareDocumentReset", paramMap);
			commonSql.insert("OnefficeDao.shareDocument", paramMap);
			
			if (bCheck) {
				shareOPAfterAccessInfo(paramMap);
			}
			
			//원피스 문서공유 로그(운영일경우에만 처리)
			if(BizboxAProperties.getProperty("BizboxA.mode").equals("live") || BizboxAProperties.getProperty("BizboxA.mode").equals("dev")) {
	        	ActionDTO action = new ActionDTO(EnumActionStep1.OnefficeShare, EnumActionStep2.ActionNone, EnumActionStep3.ActionNone);
	
	    		CreatorInfoDTO creatorInfo = new CreatorInfoDTO();
	    		creatorInfo.setEmpSeq(loginVO.getUniqId());
	    		creatorInfo.setCompSeq(loginVO.getOrganId());
	    		creatorInfo.setDeptSeq(loginVO.getOrgnztId());
	    		creatorInfo.setGroupSeq(loginVO.getGroupSeq());
	    		
	    		org.json.simple.JSONObject actionID = new org.json.simple.JSONObject();
	    		actionID.put("doc_no", paramMap.get("doc_no"));
	    		
	    		ModuleLogService.getInstance().writeStatisticLog(EnumModuleName.MODULE_ONEFFICE, creatorInfo, action, actionID, loginVO.getIp(), EnumDevice.Web);
	    	}
			
			
			Map<String, Object> result = new HashMap<String, Object>();
			result.put("doc_no", paramMap.get("doc_no"));
			mv.addObject("result","success");
			mv.addObject("data",result);
		}else{
			mv.addObject("result","fail");
		}
		
		return mv;
	}		
	
	@RequestMapping(value="/onefficeApi/unshareDocument.do")
	public ModelAndView unshareDocument(@RequestParam Map<String, Object> paramMap, HttpServletRequest request, HttpServletResponse response) {
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		
		LoginVO loginVO = checkLoginVO(request);
		
		if(loginVO != null){
			paramMap.put("groupSeq", loginVO.getGroupSeq());
			paramMap.put("empSeq", loginVO.getUniqId());
			
			commonSql.delete("OnefficeDao.unshareDocument", paramMap);
			
			Map<String, Object> result = new HashMap<String, Object>();
			result.put("doc_no", paramMap.get("doc_no"));
			
			// 편집 권한이 변경 되어 으면 accessinfo Data 값을 삭제를 하여 주자. 부서 & 링크 공유 & 개인별 공유 별로 처리를 해야 됨
			// 문서
			shareOPAfterAccessInfo(paramMap);
			
			mv.addObject("result","success");
			mv.addObject("data",result);
		}else{
			mv.addObject("result","fail");
		}
		
		return mv;
	}
	
	@RequestMapping(value="/onefficeApi/getShareInfo.do")
	public ModelAndView getShareInfo(@RequestParam Map<String, Object> paramMap, HttpServletRequest request, HttpServletResponse response) {
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		
		LoginVO loginVO = checkLoginVO(request);
		
		if(loginVO != null){
			paramMap.put("groupSeq", loginVO.getGroupSeq());
			paramMap.put("empSeq", loginVO.getUniqId());
			paramMap.put("langCode", loginVO.getLangCode());
			
			@SuppressWarnings("unchecked")
			List<Map<String, Object>> result = (List<Map<String, Object>>) commonSql.list("OnefficeDao.getShareInfo", paramMap);
			mv.addObject("result","success");
			mv.addObject("data",result);
		}else{
			mv.addObject("result","fail");
		}
		
		return mv;
	}		
	
	@RequestMapping(value="/onefficeApi/getShareDocumentList.do")
	public ModelAndView getShareDocumentList(@RequestParam Map<String, Object> paramMap, HttpServletRequest request, HttpServletResponse response) {
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		
		LoginVO loginVO = checkLoginVO(request);
		
		if(loginVO != null){
			paramMap.put("groupSeq", loginVO.getGroupSeq());
			paramMap.put("empSeq", loginVO.getUniqId());
			paramMap.put("langCode", loginVO.getLangCode());
			
			@SuppressWarnings("unchecked")
			List<Map<String, Object>> result = (List<Map<String, Object>>) commonSql.list("OnefficeDao.getShareDocumentList", paramMap);
			mv.addObject("result","success");
			mv.addObject("data",result);
		}else{
			mv.addObject("result","fail");
		}
		
		return mv;
	}	
	
	@RequestMapping(value="/onefficeApi/getMyInfo.do")
	public ModelAndView getMyInfo(@RequestParam Map<String, Object> paramMap, HttpServletRequest request, HttpServletResponse response) throws Exception {
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		
		LoginVO loginVO = checkLoginVO(request);
		
		if(loginVO != null){
			
			if(!menuManageService.checkMenuAuth(loginVO, "/oneffice/index.html")) {
				mv.setViewName( "redirect:/forwardIndex.do" );
				return mv;
			}
			
			paramMap.put("groupSeq", loginVO.getGroupSeq());
			paramMap.put("compSeq", loginVO.getCompSeq());
			paramMap.put("empSeq", loginVO.getUniqId());
			paramMap.put("langCode", loginVO.getLangCode());
			paramMap.put("pathSeq", "0");
			paramMap.put("osType", "linux");
			
			Map<String, Object> pathMap = (Map<String, Object>) commonSql.select("GroupManage.selectPathInfo", paramMap);
			
			String uploadPath = pathMap.get("absolPath").toString().replace("/home", "");				

			paramMap.put("profilePath", uploadPath + "/img/profile/" + loginVO.getGroupSeq() + "/");

			@SuppressWarnings("unchecked")
			Map<String, Object> result = (Map<String, Object>) commonSql.select("OnefficeDao.getMyInfo", paramMap);
			
			//메일도메인 주소 셋팅
			result.put("emailUrl", loginVO.getUrl());
			result.put("langCode", loginVO.getLangCode());	//UCDOC-3476
			
			mv.addObject("result","success");
			mv.addObject("data",result);
		}else{
			mv.addObject("result","fail");
		}
		
		return mv;
	}
	
	@RequestMapping(value="/onefficeApi/accessDocument.do")
	public ModelAndView accessDocument(@RequestParam Map<String, Object> paramMap, HttpServletRequest request, HttpServletResponse response) {
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		
		LoginVO loginVO = checkLoginVO(request);
		
		if(loginVO != null){
			paramMap.put("groupSeq", loginVO.getGroupSeq());
			paramMap.put("compSeq", loginVO.getCompSeq());
			paramMap.put("empSeq", loginVO.getUniqId());
			paramMap.put("langCode", loginVO.getLangCode());
			
			String strPerm = paramMap.get("access_perm").toString();
			
			//유효시간(초)이 지나도 상태값이 사용중인 데이터들 모두 close시킴
			commonSql.delete("OnefficeDao.accessDocument_0", paramMap);

			//[2] 사용 요청 처리
			//[2-1] 사용 해제 요청 처리
			if(paramMap.get("access_status").equals("0")) 
			{
				commonSql.delete("OnefficeDao.accessDocument_1", paramMap);
			}
			//[2-1] 사용 등록 요청 처리
			else 
			{
			    //[2-1-1] 읽기 사용 요청
			    if(paramMap.get("access_perm").equals("R")) 
			    {
			    	commonSql.delete("OnefficeDao.accessDocument_1", paramMap);
			    	commonSql.insert("OnefficeDao.accessDocument_2", paramMap);
			    }
			    //[2-1-2] 쓰기 사용 요청
			    else if(strPerm.equals("W") || strPerm.equals("M")) 	
			    {
					if (strPerm.equals("W")) {
						paramMap.put("access_perm1", "M");
					}
					else if (strPerm.equals("M")) {
						paramMap.put("access_perm1", "W");
					}
					
			    	String accessID = (String) commonSql.select("OnefficeDao.accessDocument_3", paramMap);
					 
					//[2-1-2-1] 결과가 있으면
					if(accessID != null) 
					{
						//위 결과 필드값을 {access_id} 로 세팅
						if(accessID.equals(loginVO.getUniqId())){
							//[2-1-2-1-1] 내 아이디이면 날짜필드만 업데이트							
							commonSql.update("OnefficeDao.accessDocument_4", paramMap);         
						} 

						else{
							//[2-1-2-1-2] 내 아이디가 아니면 R 모드로 변경 등록							
							paramMap.put("access_perm", "R");
							commonSql.insert("OnefficeDao.accessDocument_2", paramMap);
						}
					}
					else {
						//[2-1-2-2] 결과가 없으면 새로 등록						
						commonSql.insert("OnefficeDao.accessDocument_2", paramMap);
					}
			    }
			}
			
			Map<String, Object> result = new HashMap<String, Object>();
			result.put("doc_no", paramMap.get("doc_no"));
			result.put("access_perm", paramMap.get("access_perm"));
			mv.addObject("result","success");
			mv.addObject("data",result);
		}else{
			mv.addObject("result","success");
		}
		
		return mv;
	}
	
	@RequestMapping(value="/onefficeApi/getAccessUserFunctionInfo.do")
	public ModelAndView getAccessUserFunctionInfo(@RequestParam Map<String, Object> paramMap, HttpServletRequest request, HttpServletResponse response) {
		
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		LoginVO loginVO = checkLoginVO(request);
		
	//	Logger.getLogger( OnefficeController.class ).debug( "OnefficeController.paramMap.do loginVO : " +  loginVO);
		try {
				if(loginVO != null){
					paramMap.put("groupSeq", loginVO.getGroupSeq()/*"demo"*/);
					paramMap.put("user_id", loginVO.getUniqId()/*"bizwatch"*/);
										
					@SuppressWarnings("unchecked")
					List<Map<String, Object>> result = (List<Map<String, Object>>) commonSql.list("OnefficeDao.getAccessUserFunctionInfo", paramMap);
				
					mv.addObject("result","success");
					mv.addObject("data",result);
					
				}else {
					mv.addObject("result","fail");
				}
		}catch(Exception e) {
			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
			mv.addObject("result","fail");
		}		
		
		return mv;
	}	
	
	@RequestMapping(value="/onefficeApi/getDocumentAccessInfo.do")
	public ModelAndView getDocumentAccessInfo(@RequestParam Map<String, Object> paramMap, HttpServletRequest request, HttpServletResponse response) {
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		
		LoginVO loginVO = checkLoginVO(request);
		
		if(loginVO != null){
			paramMap.put("groupSeq", loginVO.getGroupSeq());
			paramMap.put("empSeq", loginVO.getUniqId());
			
			@SuppressWarnings("unchecked")
			List<Map<String, Object>> result = (List<Map<String, Object>>) commonSql.list("OnefficeDao.getDocumentAccessInfo", paramMap);
			
			/*
			//AccessManager에 시간을 업데이트 하자.
			if (paramMap.get("bTimeUpdate") != null && paramMap.get("bTimeUpdate").equals("1")) {
				int nRet = commonSql.update("OnefficeDao.updateSearchEditorDate", paramMap);
				Logger.getLogger( OnefficeController.class ).debug( "OnefficeDao.updateSearchEditorDate nRet : " +  nRet);
			}
			*/
			
			mv.addObject("result","success");
			mv.addObject("data",result);			
		}else{
			mv.addObject("result","fail");
		}
		
		return mv;
	}
	
	@RequestMapping(value="/onefficeApi/getRecentDocumentList.do")
	public ModelAndView getRecentDocumentList(@RequestParam Map<String, Object> paramMap, HttpServletRequest request, HttpServletResponse response) {
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		
		LoginVO loginVO = checkLoginVO(request);
		
		if(loginVO != null){
			paramMap.put("groupSeq", loginVO.getGroupSeq());
			paramMap.put("empSeq", loginVO.getUniqId());
			
			@SuppressWarnings("unchecked")
			List<Map<String, Object>> result = (List<Map<String, Object>>) commonSql.list("OnefficeDao.getRecentDocumentList", paramMap);
			mv.addObject("result","success");
			mv.addObject("data",result);			
		}else{
			mv.addObject("result","fail");
		}
		
		return mv;
	}
	
	@RequestMapping(value="/onefficeApi/getNewRecentDocumentList.do")
	public ModelAndView getNewRecentDocumentList(@RequestParam Map<String, Object> paramMap, HttpServletRequest request, HttpServletResponse response) {
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		
		LoginVO loginVO = checkLoginVO(request);
		
		if(loginVO != null){
			paramMap.put("groupSeq", loginVO.getGroupSeq());
			paramMap.put("empSeq", loginVO.getUniqId());

			if (paramMap.get("order_type") == null) {
				paramMap.put("order_type", "access_date");
			}
			
			if (paramMap.get("page_index") == null) {
				paramMap.put("page_index", 0);
			} else {
				paramMap.put("page_index", Integer.parseInt(paramMap.get("page_index").toString()));
			}
				

			if (paramMap.get("list_count") == null) {
				paramMap.put("list_count", 100);
			} else {
				paramMap.put("list_count", Integer.parseInt(paramMap.get("list_count").toString()));
			}

			@SuppressWarnings("unchecked")

			List<Map<String, Object>> result = (List<Map<String, Object>>) commonSql.list("OnefficeDao.getNewRecentDocumentList", paramMap);
			mv.addObject("result","success");
			mv.addObject("data",result);			
		}else{
			mv.addObject("result","fail");
		}
		
		return mv;
	}
	
	@RequestMapping(value="/onefficeApi/accessUserFunction.do")
	public ModelAndView accessUserFunction(@RequestParam Map<String, Object> paramMap, HttpServletRequest request, HttpServletResponse response) throws JsonParseException, JsonMappingException, IOException {
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		LoginVO loginVO = checkLoginVO(request);
		
		Logger.getLogger( OnefficeController.class ).debug( "OnefficeController.paramMap.do loginVO : " +  loginVO);
		
		if(loginVO != null){
			paramMap.put("groupSeq", loginVO.getGroupSeq());
			paramMap.put("user_id", loginVO.getUniqId());
		}else if(loginVO == null && request.getSession().getAttribute("bizboxa_oneffice_token") != null){
			
			String bizboxaOnefficeToken = (String) request.getSession().getAttribute("bizboxa_oneffice_token");
			
			Logger.getLogger( OnefficeController.class ).debug( "OnefficeController.paramMap.do bizboxa_oneffice_token : " +  bizboxaOnefficeToken);
			
			if(request.getSession().getAttribute("bizboxa_oneffice_emp_seq") != null && request.getSession().getAttribute("bizboxa_oneffice_emp_seq").toString().contains(bizboxaOnefficeToken)){
				paramMap.put("user_id", request.getSession().getAttribute("bizboxa_oneffice_emp_seq").toString().split("▦")[1]);
			}else{
				paramMap.put("apiTp", "getDocument.do");
				paramMap.put("reqType", "getSession");
				paramMap.put("data", bizboxaOnefficeToken);
	    		commonSql.insert("OnefficeDao.setApiLog", paramMap);
				
				Map<String, Object> groupInfo = (Map<String, Object>) commonSql.select("OnefficeDao.getGroupInfo", paramMap);
				
				Logger.getLogger( OnefficeController.class ).debug( "OnefficeController.paramMap.do groupInfo : " +  groupInfo);
				
				paramMap.put("user_id", "guest");
				
				if(groupInfo != null){
					//API호출
					//token으로 사용자 시퀀스 가져오기
					JSONObject jsonObj = new JSONObject();
					JSONObject header = new JSONObject();
					JSONObject body = new JSONObject();
					
					header.put("companyId", "");
					header.put("userId", "");
					header.put("token", "");
					header.put("tId", "0");
					header.put("pId", "P011");
					header.put("appType", "11");
					body.put("mobileId", groupInfo.get("mobile_id"));
					body.put("token", bizboxaOnefficeToken);
					
					jsonObj.put("header", header);
					jsonObj.put("body", body);
			
					String apiUrl = groupInfo.get("oneffice_token_api_url").toString() + "/BizboxMobileGateway/service/SearchTokenInfo";
					
					paramMap.put("apiTp", "SearchTokenInfo");
					paramMap.put("reqType", "param");
					paramMap.put("data", apiUrl + " > " + jsonObj.toString());
		    		commonSql.insert("OnefficeDao.setApiLog", paramMap);
					
					Map<String, Object> result = callApiToMap(jsonObj, apiUrl);
					
					Logger.getLogger( OnefficeController.class ).debug( "OnefficeController.paramMap.do result : " +  result);
					
					paramMap.put("apiTp", "SearchTokenInfo");
					paramMap.put("reqType", "result");
					paramMap.put("data", result.toString());
		    		commonSql.insert("OnefficeDao.setApiLog", paramMap);				
					
					if(result != null && result.get("resultCode").equals("0")){
						@SuppressWarnings("unchecked")
						Map<String, Object> resultInfo = (Map<String, Object>) result.get("result");
						
						Logger.getLogger( OnefficeController.class ).debug( "OnefficeController.getDocument.do resultInfo : " + resultInfo);
						
						if(resultInfo != null && resultInfo.get("empSeq") != null){
							paramMap.put("user_id", resultInfo.get("empSeq"));
							request.getSession().setAttribute("bizboxa_oneffice_emp_seq", bizboxaOnefficeToken + "▦" + resultInfo.get("empSeq").toString() + "▦" + groupInfo.get("group_seq"));
						}
					}
				}				
			}
		}
		
		if(paramMap.get("user_id") == null) {
			paramMap.put("user_id", "guest");
		}
		
		commonSql.insert("OnefficeDao.accessUserFunction", paramMap);
		
		mv.addObject("result","success");
		
		return mv;
	}	
	
	
	public Map<String, Object> getFolderNoStr(Map<String, Object> paramMap) {

		Map<String, Object> returnMap = new HashMap<String, Object>();

		ArrayList<String> folderList = new ArrayList<String>();

		String folderNo = paramMap.get("folderNo").toString();
		String result = "";

		if (!folderNo.isEmpty()) {
			folderNo = "|" + folderNo + "|";
			result = folderNo;
			Boolean state = true;

			while (state) {
				paramMap.put("folderNoStr", folderNo);
				folderNo = (String) commonSql.select("OnefficeDao.getFolderNoStr", paramMap);

				if (!folderNo.isEmpty() && !folderNo.equals("")) {
					result += folderNo;
				} else {
					state = false;
				}
			}
		}

		String tempList[] = result.split("\\|");
		for (int i = 0; i < tempList.length; i++) {
			if (!tempList[i].isEmpty()) {
				folderList.add(tempList[i]);
				Logger.getLogger( OnefficeController.class ).debug( "OnedfficeController.subFolderDelete param "
																	+ "i : " +  i + "folder_no=" +  tempList[i]);
				
			}
		}

		returnMap.put("folderNoStr", result);
		returnMap.put("subFolderDeleteList", folderList);
		return returnMap;
	}

	@RequestMapping(value="/onefficeApi/getSecurityDocumentList.do")
	public ModelAndView getSecurityDocumentList(@RequestParam Map<String, Object> paramMap, HttpServletRequest request, HttpServletResponse response) {
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		
		LoginVO loginVO = checkLoginVO(request);
		
		if(loginVO != null){
			paramMap.put("groupSeq", loginVO.getGroupSeq());
			paramMap.put("empSeq", loginVO.getUniqId());
			
			@SuppressWarnings("unchecked")
			List<Map<String, Object>> result = (List<Map<String, Object>>) commonSql.list("OnefficeDao.getSecurityDocumentList", paramMap);
			mv.addObject("result","success");
			mv.addObject("data",result);			
		}else{
			mv.addObject("result","fail");
		}
		
		return mv;
	}
	
	
	@RequestMapping(value="/onefficeApi/getSecurityInfo.do")
	public ModelAndView getSecurityInfo(@RequestParam Map<String, Object> paramMap, HttpServletRequest request, HttpServletResponse response) throws JsonParseException, JsonMappingException, IOException {
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		
		LoginVO loginVO = checkLoginVO(request);
		
		if(loginVO == null && request.getSession().getAttribute("bizboxa_oneffice_token") != null){
			
			String bizboxaOnefficeToken = (String) request.getSession().getAttribute("bizboxa_oneffice_token");
			
			loginVO = new LoginVO();
			loginVO.setGroupSeq(paramMap.get("groupSeq").toString());
			
			if(request.getSession().getAttribute("bizboxa_oneffice_emp_seq") != null && request.getSession().getAttribute("bizboxa_oneffice_emp_seq").toString().contains(bizboxaOnefficeToken)){
				loginVO.setUniqId(request.getSession().getAttribute("bizboxa_oneffice_emp_seq").toString().split("▦")[1]);
			}else{
				
				paramMap.put("apiTp", "getSecurityInfo.do");
				paramMap.put("reqType", "getSession");
				paramMap.put("data", bizboxaOnefficeToken);
	    		commonSql.insert("OnefficeDao.setApiLog", paramMap);
				
				@SuppressWarnings("unchecked")
				Map<String, Object> groupInfo = (Map<String, Object>) commonSql.select("OnefficeDao.getGroupInfo", paramMap);
				
				if(groupInfo != null){
					//API호출
					//token으로 사용자 시퀀스 가져오기
					JSONObject jsonObj = new JSONObject();
					JSONObject header = new JSONObject();
					JSONObject body = new JSONObject();
					
					header.put("companyId", "");
					header.put("userId", "");
					header.put("token", "");
					header.put("tId", "0");
					header.put("pId", "P011");
					header.put("appType", "11");
					body.put("mobileId", groupInfo.get("mobile_id"));
					body.put("token", bizboxaOnefficeToken);
					
					jsonObj.put("header", header);
					jsonObj.put("body", body);
			
					String apiUrl = groupInfo.get("oneffice_token_api_url").toString() + "/BizboxMobileGateway/service/SearchTokenInfo";
					
					paramMap.put("apiTp", "SearchTokenInfo");
					paramMap.put("reqType", "param");
					paramMap.put("data", apiUrl + " > " + jsonObj.toString());
		    		commonSql.insert("OnefficeDao.setApiLog", paramMap);
					
					Map<String, Object> result = callApiToMap(jsonObj, apiUrl);
					
					paramMap.put("apiTp", "SearchTokenInfo");
					paramMap.put("reqType", "result");
					paramMap.put("data", result.toString());
		    		commonSql.insert("OnefficeDao.setApiLog", paramMap);				
					
					if(result != null && result.get("resultCode").equals("0")){
						@SuppressWarnings("unchecked")
						Map<String, Object> resultInfo = (Map<String, Object>) result.get("result");
						
						if(resultInfo != null && resultInfo.get("empSeq") != null){
							loginVO.setUniqId(resultInfo.get("empSeq").toString());
							request.getSession().setAttribute("bizboxa_oneffice_emp_seq", bizboxaOnefficeToken + "▦" + resultInfo.get("empSeq").toString() + "▦" + paramMap.get("groupSeq").toString());
						}
					}
				}				
			}
		}		
		
		if(loginVO != null){
			paramMap.put("groupSeq", loginVO.getGroupSeq());
			paramMap.put("empSeq", loginVO.getUniqId());
			
			@SuppressWarnings("unchecked")
			Map<String, Object> result = (Map<String, Object>) commonSql.select("OnefficeDao.getSecurityInfo", paramMap);
			if(result == null){
				mv.addObject("result","fail");
			}else{
				mv.addObject("result","success");
				mv.addObject("status",result.get("status"));
			}		
		}else{
			mv.addObject("result","fail");
		}
		
		return mv;
	}	
	
	
	
	@RequestMapping(value="/onefficeApi/copyDocument.do")
	public ModelAndView copyDocument(@RequestParam Map<String, Object> paramMap, HttpServletRequest request, HttpServletResponse response) throws Exception {
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		
		LoginVO loginVO = checkLoginVO(request);
		
		if(loginVO != null){
			paramMap.put("groupSeq", loginVO.getGroupSeq());
			paramMap.put("empSeq", loginVO.getUniqId());
			
			String newDocNo = UUID.randomUUID().toString().replace("-", "");
			paramMap.put("new_doc_no", newDocNo);
			
			commonSql.insert("OnefficeDao.copyDocument", paramMap);
			
			
			//문서정보 조회
			Map<String, Object> docInfo = (Map<String, Object>) commonSql.select("OnefficeDao.getDocumentInfo", paramMap);
			
			if(docInfo == null)
			{
				mv.addObject("result","fail");
				return mv;
			}
			
			String ownerId = docInfo.get("owner_id") == null ? "" : docInfo.get("owner_id").toString();
			
			
			//첨부파일 복사.
			boolean cloudYn = false;
			String uploadPath = "";
			String copyPath = "";
			if(CloudConnetInfo.getBuildType().equals("cloud")){
				cloudYn = true;
			}	
			
			paramMap.put("groupSeq", loginVO.getGroupSeq());
			paramMap.put("pathSeq", "0");
			paramMap.put("osType", NeosConstants.SERVER_OS);
		
			String absolPath = "";
			Map<String, Object> pathMap = groupManageService.selectGroupPath(paramMap);
			if(pathMap != null){
				absolPath = pathMap.get("absolPath").toString();	
			}			

			uploadPath = absolPath + "/onefficeFile/" + ownerId + "/" + paramMap.get("doc_no") + "/";
			copyPath = absolPath + "/onefficeFile/" + loginVO.getUniqId() + "/" + newDocNo + "/";
			
			File sourceF = new File(uploadPath);
			File targetF = new File(copyPath);

			copy(sourceF, targetF, newDocNo, (String)paramMap.get("doc_no"));
			
			//원피스 문서 복사로그(운영일경우에만 처리)
			if(BizboxAProperties.getProperty("BizboxA.mode").equals("live") || BizboxAProperties.getProperty("BizboxA.mode").equals("dev")) {
	        	ActionDTO action = new ActionDTO(EnumActionStep1.OnefficeCreate, EnumActionStep2.OnefficeCopy, EnumActionStep3.ActionNone);
	
	    		CreatorInfoDTO creatorInfo = new CreatorInfoDTO();
	    		creatorInfo.setEmpSeq(loginVO.getUniqId());
	    		creatorInfo.setCompSeq(loginVO.getOrganId());
	    		creatorInfo.setDeptSeq(loginVO.getOrgnztId());
	    		creatorInfo.setGroupSeq(loginVO.getGroupSeq());
	    		
	    		org.json.simple.JSONObject actionID = new org.json.simple.JSONObject();
	    		actionID.put("doc_no", newDocNo);
	    		
	    		ModuleLogService.getInstance().writeStatisticLog(EnumModuleName.MODULE_ONEFFICE, creatorInfo, action, actionID, loginVO.getIp(), EnumDevice.Web);
	    	}
			
			
			Map<String, Object> result = new HashMap<String, Object>();
			result.put("new_doc_no", newDocNo);
			mv.addObject("result","success");
			mv.addObject("data",result);
		}else{
			mv.addObject("result","fail");
		}
		return mv;
	}
	
	@RequestMapping(value="/onefficeApi/updateContentsList.do")
	public ModelAndView updateContentsList(@RequestParam Map<String, Object> paramMap, HttpServletRequest request, HttpServletResponse response) throws Exception {
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		
		LoginVO loginVO = checkLoginVO(request);
		
		if(loginVO != null){
			//문서정보 조회
			Map<String, Object> docInfo = (Map<String, Object>) commonSql.select("OnefficeDao.getDocumentInfo", paramMap);
			
			if (docInfo == null) {
				docInfo = new HashMap<String, Object>();
			}
			
			String ownerId = docInfo.get("owner_id") == null ? "" : docInfo.get("owner_id").toString();
			
			String contentsList = (String)paramMap.get("contents_list");
			String docNo = (String)paramMap.get("doc_no");			
			String []arrFileNm = contentsList.split(",");
			
			boolean cloudYn = false;
			String uploadPath = "";
			if(CloudConnetInfo.getBuildType().equals("cloud")){
				cloudYn = true;
			}	
			
			paramMap.put("groupSeq", loginVO.getGroupSeq());
			paramMap.put("pathSeq", "0");
			paramMap.put("osType", NeosConstants.SERVER_OS);
		
			String absolPath = "";
			Map<String, Object> pathMap = groupManageService.selectGroupPath(paramMap);
			if(pathMap != null){
				absolPath = pathMap.get("absolPath").toString();	
			}			
			
			uploadPath = absolPath + "/onefficeFile/" + ownerId + "/" + docNo + "/";
			
			File dirFile = new File(uploadPath);
			File[] fileList = dirFile.listFiles();
			if(fileList != null && fileList.length >0){ 
				for (File tempFile : fileList) {
					if (tempFile.isFile()) {
						String tempFileName = tempFile.getName();
						
						if(tempFileName.indexOf("uploadThumbImg") != -1){
							continue;
						}
						
						int checkCnt = 0;
						
						for(int i=0;i<arrFileNm.length;i++){
							if(tempFileName.equals(arrFileNm[i])){
								checkCnt ++;
							}
						}
						if(checkCnt == 0){
							tempFile.delete();
						}
					}
				}
			}
			
			mv.addObject("result","success");
			
		}else{
			mv.addObject("result","fail");
		}
		
		return mv;
	}
	
	
	
	@RequestMapping(value="/onefficeApi/getEmpListWithinDept.do")
	public ModelAndView getEmpListWithinDept(@RequestParam Map<String, Object> paramMap, HttpServletRequest request, HttpServletResponse response) throws Exception {
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		
		LoginVO loginVO = checkLoginVO(request);
		
		if(loginVO != null){
			paramMap.put("groupSeq", loginVO.getGroupSeq());
			paramMap.put("langCode", loginVO.getLangCode());
			
			@SuppressWarnings("unchecked")
			List<Map<String, Object>> result = (List<Map<String, Object>>) commonSql.list("OnefficeDao.getEmpListWithinDept", paramMap);
			mv.addObject("result","success");
			mv.addObject("data",result);	
			
			mv.addObject("result","success");
			
		}else{
			mv.addObject("result","fail");
		}
		
		return mv;
	}
	
	
	@RequestMapping(value="/onefficeApi/getEmpMentionList.do")
	public ModelAndView getEmpMentionList(@RequestParam Map<String, Object> paramMap, HttpServletRequest request, HttpServletResponse response) throws Exception {
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		
		LoginVO loginVO = checkLoginVO(request);
		
		try {
			if(loginVO != null && (paramMap.get("compSeqList") != null || paramMap.get("deptSeqList") != null)){
				paramMap.put("groupSeq", loginVO.getGroupSeq());
				paramMap.put("langCode", loginVO.getLangCode());
				
				if(paramMap.get("compSeqList") != null) {
					paramMap.put("compSeqList", paramMap.get("compSeqList").toString().split(","));
				}else if(paramMap.get("deptSeqList") != null) {
					paramMap.put("deptSeqList", paramMap.get("deptSeqList").toString().split(","));
				}
				
				@SuppressWarnings("unchecked")
				List<Map<String, Object>> result = (List<Map<String, Object>>) commonSql.list("OnefficeDao.getEmpMentionList", paramMap);
				mv.addObject("result","success");
				mv.addObject("data",result);	
				
				mv.addObject("result","success");
				
			}else{
				mv.addObject("result","fail");
		}
		}catch(Exception e) {
			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
			mv.addObject("result","fail");
		}
		
		return mv;
	}
	
	@RequestMapping(value="/onefficeApi/accessDocumentHistory.do")
	public ModelAndView accessDocumentHistory(@RequestParam Map<String, Object> paramMap, HttpServletRequest request, HttpServletResponse response) throws Exception {
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		
		LoginVO loginVO = checkLoginVO(request);
		
		if(loginVO != null){
			paramMap.put("groupSeq", loginVO.getGroupSeq());
			paramMap.put("empSeq", loginVO.getUniqId());
			paramMap.put("langCode", loginVO.getLangCode());
			paramMap.put("user_ip", CommonUtil.getClientIp(request));
			commonSql.insert("OnefficeDao.InsertAccessDocumentHistory", paramMap);
			mv.addObject("result","success");
		}else{
			mv.addObject("result","fail");
		}		
		return mv;
	}
	
	
	@RequestMapping(value="/onefficeApi/getDocumentHistory.do")
	public ModelAndView getDocumentHistory(@RequestParam Map<String, Object> paramMap, HttpServletRequest request, HttpServletResponse response) throws Exception {
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		
		LoginVO loginVO = checkLoginVO(request);
		
		if(loginVO != null){
			paramMap.put("groupSeq", loginVO.getGroupSeq());
			List<Map<String, Object>> result = (List<Map<String, Object>>) commonSql.list("OnefficeDao.getDocumentHistory", paramMap);				
			mv.addObject("result","success");
			mv.addObject("data",result);
		}else{
			mv.addObject("result","fail");
		}		
		return mv;
	}
	
	@RequestMapping(value="/onefficeApi/AESSecurity.do")
	public ModelAndView AESSecurity(@RequestParam Map<String, Object> paramMap, HttpServletRequest request, HttpServletResponse response) throws Exception {
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		
		LoginVO loginVO = checkLoginVO(request);
		
		if(loginVO != null){
			String aesEncode = (String)paramMap.get("aesEncode");
			String temp = "\",\"empSeq\": "+ "\""+ loginVO.getUniqId() + "\"}"; 
			aesEncode = aesEncode.replace("\"}", temp);
			String encodeComment = AESCipher.AES128_Encode(aesEncode, "1023497555960596");

			Logger.getLogger( OnefficeController.class ).debug( "aes String : " +  aesEncode);
			Logger.getLogger( OnefficeController.class ).debug( "aes encodeComment  : " +  encodeComment);
			
			mv.addObject("result","success");
			mv.addObject("encode",encodeComment);
			//String decodeComment = AESCipher.AES128_Decode(encodeComment, "1023497555960596");
			//Logger.getLogger( OnefficeController.class ).debug( "aes decodeComment  : " +  decodeComment);
			//mv.addObject("decodeComment",decodeComment);
		}else{
			mv.addObject("result","fail");
		}
		
		return mv;
	}
	
	@RequestMapping(value="/onefficeApi/getAttachmentData.do")
	public void getAttachmentData(@RequestParam Map<String, Object> paramMap, HttpServletRequest request, HttpServletResponse response) throws Exception {
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		
		LoginVO loginVO = checkLoginVO(request);
		
		/*
		if(paramMap.get("reqType") != null && paramMap.get("reqType").equals("pdf") && paramMap.get("groupSeq") != null && !paramMap.get("groupSeq").equals("") && paramMap.get("empSeq") != null && !paramMap.get("empSeq").equals("")){
			loginVO = new LoginVO();
			loginVO.setGroupSeq(paramMap.get("groupSeq").toString());
			loginVO.setUniqId(paramMap.get("empSeq").toString());
		}*/
		Logger.getLogger( OnefficeController.class ).debug( "OnefficeController.getAttachmentData.do paramMap : " +  paramMap);
		Logger.getLogger( OnefficeController.class ).debug( "OnefficeController.getAttachmentData.do loginVO : " +  loginVO);
		
		String fileName = paramMap.get("seq") == null ? "" : paramMap.get("seq").toString();
		
		if(paramMap.get("ref") != null && paramMap.get("ref").toString().equals("bizbox_report")){
			String serverName = request.getServerName();
			Map<String, Object> jedisMp = CloudConnetInfo.getParamMapByDomain(serverName);
			
			loginVO = new LoginVO();
			loginVO.setGroupSeq(jedisMp.get("groupSeq").toString());
			
			Logger.getLogger( OnefficeController.class ).debug( "OnefficeController.getAttachmentData.do jedisMp : " +  jedisMp);
		}
		
		if (loginVO != null && paramMap.get("noAuth") == null) {
			paramMap.put("noAuth", "Y");
		}
		
		if((loginVO != null || (paramMap.get("noAuth") != null && paramMap.get("noAuth").toString().equals("Y")) && !fileName.equals(""))){
			String docNo = fileName.split("-")[0];
			paramMap.put("doc_no", docNo);
			paramMap.put("empSeq", loginVO == null ? "" : loginVO.getUniqId());
			paramMap.put("groupSeq", loginVO == null ? paramMap.get("groupSeq") : loginVO.getGroupSeq());
			Map<String, Object> result = (Map<String, Object>) commonSql.select("OnefficeDao.getDocument", paramMap);
			
			if(result != null || (paramMap.get("ref") != null && paramMap.get("ref").toString().equals("bizbox_report"))){
				
				String filePath = "";
				String absolPath = "";
				
				paramMap.put("pathSeq", "0");
				paramMap.put("osType", NeosConstants.SERVER_OS);
				Map<String, Object> pathMap = groupManageService.selectGroupPath(paramMap);
				
				if(pathMap != null){
					absolPath = pathMap.get("absolPath").toString();	
				}				
				
				if(paramMap.get("ref") != null && paramMap.get("ref").toString().equals("bizbox_report")){
					filePath = absolPath + "/onefficeFile/report/" + (!docNo.equals("") ? (docNo + "/") : "") + fileName;
				}else{				
					filePath = absolPath + "/onefficeFile/" + result.get("owner_id").toString() + "/" + (!docNo.equals("") ? (docNo + "/") : "") + fileName;
				}
				
				FileInputStream fis = null;
				
				try {
					String orignlFileName = "";
					String fileExtsn = fileName.substring(fileName.lastIndexOf(".") + 1);
					
					String imgExt = "jpeg|bmp|gif|jpg|png";
					String applicationExt = "pdf";
					
					File file = new File(filePath);
					
					fis = new FileInputStream(file);

				    String browser = request.getHeader("User-Agent");
				    
				    //파일 인코딩
				    if(browser.contains("MSIE") || browser.contains("Trident") || browser.contains("Edge")){
				    	orignlFileName = URLEncoder.encode(fileName,"UTF-8").replaceAll("\\+", "%20"); 
				    } 
				    else {
				    	orignlFileName = new String(fileName.getBytes("UTF-8"), "ISO-8859-1"); 
				    }
				    
				    String type = "";
				    
					if (fileExtsn != null && !fileExtsn.equals("")) {
						//이미지 컨텐츠타입 설정
						if(imgExt.indexOf(fileExtsn.toLowerCase()) != -1){
							
							if(fileExtsn.toLowerCase().equals("jpg")){
								type = "image/jpeg";
							}else{
								type = "image/" + fileExtsn.toLowerCase();
							}
						}
						//어플리케인션 컨텐츠타입 설정
						else if(applicationExt.indexOf(fileExtsn.toLowerCase()) != -1){
							type = "application/" + fileExtsn.toLowerCase();
						}				
					}
				    
					if(!type.equals("")){
						response.setHeader("Content-Type", type);
					}else{
						response.setContentType(CommonUtil.getContentType(file));
						response.setHeader("Content-Transfer-Encoding", "binary;");
					}

				    if(!type.equals("") && paramMap.get("inlineView") != null && paramMap.get("inlineView").toString().equals("Y")){
						//Inline View
				    	response.setHeader("Content-Disposition","inline;filename=\"" + orignlFileName+"\"");
				    }else{
				    	//Attach Download
				    	response.setHeader("Content-Disposition","attachment;filename=\"" + orignlFileName+"\"");	
				    }

				    response.setContentLength((int) file.length());
					byte buffer[] = new byte[4096];
					int bytesRead = 0, byteBuffered = 0;
					
					while((bytesRead = fis.read(buffer)) > -1) {
						
						response.getOutputStream().write(buffer, 0, bytesRead);
						byteBuffered += bytesRead;
						
						//flush after 1MB
						if(byteBuffered > 1024*1024) {
							byteBuffered = 0;
							response.getOutputStream().flush();
						}
					}

					response.getOutputStream().flush();
					response.getOutputStream().close();
					
				} catch (FileNotFoundException e) {
					//System.out.println(e.getMessage());
					Logger.getLogger( OnefficeController.class ).debug( "getAttachmentData.do  ignore 1: " +  e.getMessage());
				} catch (IOException e) {
					//System.out.println(e.getMessage());
					Logger.getLogger( OnefficeController.class ).debug( "getAttachmentData.do  ignore 2: " +  e.getMessage());
				} finally {
					if (fis != null) {
						try {
							fis.close();
						} catch (Exception ignore) {
							//System.out.println(ignore.getMessage());
							Logger.getLogger( OnefficeController.class ).debug( "getAttachmentData.do  ignore 3: " +  ignore.getMessage());
							//LOGGER.debug("IGNORE: {}", ignore.getMessage());
						}
					}
				}
			}else {
				response.setStatus(403);
			}
		}else {
			response.setStatus(403);
		}
	}

	
	
	
	
	public void deleteAllFiles(String path){
		Logger.getLogger( OnefficeController.class ).debug( "path : " + path);
		
		File file = new File(path); //폴더내 파일을 배열로 가져온다. 
		File[] tempFile = file.listFiles();		
		if(tempFile != null && tempFile.length >0){ 
			for (int i = 0; i < tempFile.length; i++){ 
				if(tempFile[i].isFile()){ 
					tempFile[i].delete(); 
				}else{
					//재귀함수 
					deleteAllFiles(tempFile[i].getPath()); 
				} 
				tempFile[i].delete(); 
			} 
			file.delete(); 
		}
	}
	
	public void copy(File sourceF, File targetF, String newDocNo, String docNo) {
		
		File[] ff = sourceF.listFiles();
		if(ff != null && ff.length > 0){
			for (File file : ff) {
				
				if(!targetF.exists()){
					targetF.mkdirs();
				}
				
				File temp = new File(targetF.getAbsolutePath() + File.separator + file.getName().replace(docNo, newDocNo));

				FileInputStream fis = null;
				FileOutputStream fos = null;
				try {
					fis = new FileInputStream(file);
					fos = new FileOutputStream(temp);
					byte[] b = new byte[4096];
					int cnt = 0;
					while ((cnt = fis.read(b)) != -1) {
						fos.write(b, 0, cnt);
					}
				} catch (Exception e) {
					CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
				} finally {
					try {
						if(fis!=null) {//Null Pointer 역참조
							fis.close();
						}
						if(fos!=null) {//Null Pointer 역참조
							fos.close();
						}
					} catch (IOException e) {
						CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
					}
				}
			}
		}
	}
	
	
	public LoginVO checkLoginVO(HttpServletRequest request){
		
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		
		Logger.getLogger( OnefficeController.class ).debug( "OnefficeController.checkLoginVO loginVO : " + loginVO);
		Logger.getLogger( OnefficeController.class ).debug( "OnefficeController.checkLoginVO bizboxa_oneffice_emp_seq : " + request.getSession().getAttribute("bizboxa_oneffice_emp_seq"));
		
		if(loginVO == null && request.getAttribute("empSeq") != null && request.getAttribute("groupSeq") != null) {
			Map<String, Object> paramMap = new HashMap<String, Object>();
			paramMap.put("empSeq", request.getAttribute("empSeq"));
			paramMap.put("groupSeq", request.getAttribute("groupSeq"));
			loginVO = (LoginVO) commonSql.select("loginDAO.getLoginVoByEmpSeq", paramMap);
		}
		
		
//		if(loginVO == null && request.getSession().getAttribute("bizboxa_oneffice_emp_seq") != null){
//			LoginVO tempVO = new LoginVO();
//			try{
//				Map<String, Object> params = new HashMap<String, Object>();
//				params.put("empSeq", request.getSession().getAttribute("bizboxa_oneffice_emp_seq").toString().split("▦")[1]);
//				params.put("groupSeq", request.getSession().getAttribute("bizboxa_oneffice_emp_seq").toString().split("▦")[2]);
//				
//				Map<String, Object> userInfo = (Map<String, Object>) commonSql.select("OnefficeDao.getUserInfo", params);
//				
//				Logger.getLogger( OnefficeController.class ).debug( "OnefficeController.checkLoginVO userInfo : " + userInfo);
//				
//				tempVO.setGroupSeq(userInfo.get("group_seq").toString());
//				tempVO.setUniqId(userInfo.get("emp_seq").toString());
//				tempVO.setLangCode(userInfo.get("lang_code").toString());
//				tempVO.setOrganId(userInfo.get("comp_seq").toString());
//				tempVO.setCompSeq(userInfo.get("comp_seq").toString());
//				tempVO.setEaType(userInfo.get("ea_type").toString());
//			}catch(Exception e){
//				Logger.getLogger( OnefficeController.class ).error( "OnefficeController.checkLoginVO");
//				Logger.getLogger( OnefficeController.class ).error( e);
//				e.printStackTrace();
//				
//				tempVO = null;
//			}
//			loginVO = tempVO;
//		}
		
		return loginVO;
	}
	
	
	@RequestMapping(value="/onefficeApi/reportRegPop.do")
	public ModelAndView reportRegPop(@RequestParam Map<String, Object> paramMap, HttpServletRequest request, HttpServletResponse response) throws Exception {
		ModelAndView view = new ModelAndView();
		
		LoginVO loginVO = checkLoginVO(request);
		
		view.addObject("ref", paramMap.get("ref"));
		view.addObject("seq", paramMap.get("seq"));
		view.addObject("groupSeq", loginVO.getGroupSeq());
		view.addObject("compSeq", loginVO.getOrganId());
		view.addObject("empSeq", loginVO.getUniqId());		
		view.addObject("eaType", loginVO.getEaType() == null || loginVO.getEaType().equals("") ? "eap" : loginVO.getEaType());
		
		//첨부파일 이동처리 (원피스 다운로드 경로 -> 원피스 폴더내 업무보고 폴더 생성후 파일 이동처리)
		Map<String, Object> docInfo = (Map<String, Object>) commonSql.select("OnefficeDao.getOnefficeDocInfo", paramMap);
		moveOnefficeFileToReport(paramMap.get("seq").toString(), docInfo.get("owner_id").toString(), loginVO.getGroupSeq());
		
		String path = request.getScheme() + "://"+request.getServerName()+":"+request.getServerPort();
		
		view.setViewName("redirect:" + path + "/schedule/Views/Common/report/reportRegPop");
		
		return view;
	}
	
	
	@RequestMapping(value="/onefficeApi/reportUpdate.do")
	public ModelAndView reportUpdate(@RequestParam Map<String, Object> paramMap, HttpServletRequest request, HttpServletResponse response) throws Exception {
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		
		LoginVO loginVO = checkLoginVO(request);
		
	
		if(loginVO == null){
			String serverName = request.getServerName();
			Map<String, Object> jedisMp = CloudConnetInfo.getParamMapByDomain(serverName);
			
			loginVO = new LoginVO();
			loginVO.setGroupSeq(jedisMp.get("groupSeq").toString());
		}

		
		paramMap.put("groupSeq", loginVO.getGroupSeq());
		paramMap.put("readYn", "N");
		
		Map<String, Object> reportInfo = (Map<String, Object>) commonSql.select("OnefficeDao.getReportInfo", paramMap);		
		
		if(reportInfo != null){
						
			if(!CommonUtil.isEmptyStr(paramMap.get("type"))) {
				commonSql.update("OnefficeDao.updateReportInfo", paramMap);
			}else {
				paramMap.put("type", reportInfo.get("type"));
			}
			
			//첨부파일 경로 수정(원피스 업로드경로 -> 원피스(업무보고)경로)
			String contents = paramMap.get("oneffice_doc_data") + "";
			contents.replaceAll("/gw/onefficeApi/getAttachmentData.do?seq=", "/gw/onefficeApi/getAttachmentData.do?ref=bizbox_report&seq=");
			
			paramMap.put("oneffice_doc_data", contents);
			
			commonSql.update("OnefficeDao.updateReportContetns", paramMap);
			
			mv.addObject("result","success");
			
			Map<String, Object> result = new HashMap<String, Object>();
			result.put("report_no", paramMap.get("report_no"));
			
			mv.addObject("data",result);
		}else{
			mv.addObject("result","fail");
		}		
		
		return mv;
	}
	
	
	@RequestMapping(value="/onefficeApi/getOnefficeUserEnv.do")
	public ModelAndView getOnefficeUserEnv(@RequestParam Map<String, Object> paramMap, HttpServletRequest request, HttpServletResponse response) {
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		
		LoginVO loginVO = checkLoginVO(request);
		
		if(loginVO != null){
			paramMap.put("groupSeq", loginVO.getGroupSeq());
			paramMap.put("empSeq", loginVO.getUniqId());
			
			@SuppressWarnings("unchecked")
			List<Map<String, Object>> result = (List<Map<String, Object>>) commonSql.list("OnefficeDao.getOnefficeUserEnv", paramMap);
			mv.addObject("result","success");
			mv.addObject("data",result);			
		}else{
			mv.addObject("result","fail");
		}
		
		return mv;
	}
	
	
	@RequestMapping(value="/onefficeApi/updateOnefficeUserEnv.do")
	public ModelAndView updateOnefficeUserEnv(@RequestParam Map<String, Object> paramMap, HttpServletRequest request, HttpServletResponse response) {
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		
		LoginVO loginVO = checkLoginVO(request);
		
		if(loginVO != null){
			paramMap.put("groupSeq", loginVO.getGroupSeq());
			paramMap.put("empSeq", loginVO.getUniqId());
			
			commonSql.insert("OnefficeDao.updateOnefficeUserEnv", paramMap);
			mv.addObject("result","success");
			mv.addObject("data","");			
		}else{
			mv.addObject("result","fail");
		}
		
		return mv;
	}
	
	@RequestMapping(value="/onefficeApi/getReportInfo.do")
	public ModelAndView getReportInfo(@RequestParam Map<String, Object> paramMap, HttpServletRequest request, HttpServletResponse response) throws Exception {
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		
		LoginVO loginVO = checkLoginVO(request);
		
		if(loginVO == null){
			String serverName = request.getServerName();
			Map<String, Object> jedisMp = CloudConnetInfo.getParamMapByDomain(serverName);
			
			loginVO = new LoginVO();
			loginVO.setGroupSeq(jedisMp.get("groupSeq").toString());
		}
		

		paramMap.put("groupSeq", loginVO.getGroupSeq());
		paramMap.put("empSeq", loginVO.getUniqId());
		
		Map<String, Object> reportInfo = (Map<String, Object>) commonSql.select("OnefficeDao.getReportInfo", paramMap);

		if(reportInfo != null){
			paramMap.put("type", reportInfo.get("type"));
			mv.addObject("result","success");
			Map<String, Object> data = (Map<String, Object>) commonSql.select("OnefficeDao.getOnefficeReportContents", paramMap);
			data.put("contents", data.get("contents").toString().replace("%2B", "+"));
			data.put("contents", data.get("contents").toString().replace("%26", "&"));
			mv.addObject("data",data);
		}else{
			mv.addObject("result","fail");
		}			

		return mv;
	}
	
	
	public void moveOnefficeFileToReport(String docNo, String ownerID, String groupSeq){
		
		Map<String, Object> paramMap = new HashMap<String, Object>();
		
		paramMap.put("groupSeq", groupSeq);
		paramMap.put("pathSeq", "0");
		paramMap.put("osType", NeosConstants.SERVER_OS);
		
		String absolPath = "";
		Map<String, Object> pathMap = groupManageService.selectGroupPath(paramMap);
		
		String targetPath = pathMap.get("absolPath") + "/onefficeFile/" + ownerID + "/" + docNo + "/";
		String movePath = pathMap.get("absolPath") + "/onefficeFile/report/" + docNo + "/";
		
		File dir = new File(movePath);
		
		if(!dir.exists()){
			dir.mkdirs();
		}
		
		try{			  
			File folder = new File(targetPath);
			File[] listOfFiles = folder.listFiles();

			for (File file : listOfFiles) {
			    if (file.isFile()) {
			    	
			    	File newFile = new File(movePath + file.getName());

			    	FileInputStream inputStream = new FileInputStream(file);        
			    	FileOutputStream outputStream = new FileOutputStream(newFile);

			    	FileChannel fcin =  inputStream.getChannel();
			    	FileChannel fcout = outputStream.getChannel();
			    	  
			    	long size = fcin.size();
			    	fcin.transferTo(0, size, fcout);
			    	  
			    	fcout.close();
			    	fcin.close();
			    	  
			    	outputStream.close();
			    	inputStream.close();
			    }
			}
 
        }catch(Exception e){
        	CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
        }
	
	}
	
	
	
	@RequestMapping(value="/onefficeApi/searchUserInfoList.do")
	public ModelAndView searchUserInfoList(@RequestParam Map<String, Object> paramMap, HttpServletRequest request, HttpServletResponse response) throws Exception {
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		
		LoginVO loginVO = checkLoginVO(request);
		
		String txtSearch = paramMap.get("txt_search") + "";
		paramMap.put("txt_search", URLDecoder.decode(txtSearch,"UTF-8"));
		
		Logger.getLogger( CloudConnetInfo.class ).debug( "OnefficeController.searchUserInfoList  txt_search : " + URLEncoder.encode(txtSearch,"UTF-8") );
		Logger.getLogger( CloudConnetInfo.class ).debug( "OnefficeController.searchUserInfoList  paramMap : " + paramMap );
		
		String option = paramMap.get("option") + "";
		
		paramMap.put("pathSeq", "0");
		paramMap.put("osType", "linux");
		paramMap.put("groupSeq", loginVO.getGroupSeq());
		
		Map<String, Object> pathMap = (Map<String, Object>) commonSql.select("GroupManage.selectPathInfo", paramMap);
		
		String uploadPath = pathMap.get("absolPath").toString().replace("/home", "");
		
		if(loginVO != null){
			if(txtSearch.equals("")){
				mv.addObject("result","fail");
			}else{

				paramMap.put("profilePath", uploadPath + "/img/profile/" + loginVO.getGroupSeq() + "/");
				paramMap.put("groupSeq", loginVO.getGroupSeq());
				paramMap.put("langCode", loginVO.getLangCode());
				mv.addObject("result","success");
				
				if(option != null && option.equals("4")) {
					mv.addObject("data", commonSql.select("OnefficeDao.getBasicDocInfo", paramMap));
				}else {
					mv.addObject("data", commonSql.list("OnefficeDao.searchUserInfoList", paramMap));
				}
			}
		}else{
			mv.addObject("result","fail");
		}		
		return mv;
	}
	
	
	public boolean checkMobileToken(HttpServletRequest request, String groupSeq) {
		
		Logger.getLogger( CloudConnetInfo.class ).debug( "OnefficeController.checkMobileToken  groupSeq : " + groupSeq );
		
		
		Map<String, Object> paramMap = new HashMap<String, Object>();
		paramMap.put("groupSeq", groupSeq);
		
		boolean flag = false;
		
		if(request.getHeader("bizboxa-oneffice-token") != null){
			
			String bizboxaOnefficeToken = (String) request.getHeader("bizboxa-oneffice-token");
			
			paramMap.put("apiTp", "getDocument.do");
			paramMap.put("reqType", "getSession");
			paramMap.put("data", bizboxaOnefficeToken);
    		commonSql.insert("OnefficeDao.setApiLog", paramMap);
			
			Map<String, Object> groupInfo = (Map<String, Object>) commonSql.select("OnefficeDao.getGroupInfo", paramMap);
			
			try {
			
			if(groupInfo != null){
				//API호출
				//token으로 사용자 시퀀스 가져오기
				JSONObject jsonObj = new JSONObject();
				JSONObject header = new JSONObject();
				JSONObject body = new JSONObject();
				
				header.put("companyId", "");
				header.put("userId", "");
				header.put("token", "");
				header.put("tId", "0");
				header.put("pId", "P011");
				header.put("appType", "11");
				body.put("mobileId", groupInfo.get("mobile_id"));
				body.put("token", bizboxaOnefficeToken);
				
				jsonObj.put("header", header);
				jsonObj.put("body", body);
		
				String apiUrl = groupInfo.get("oneffice_token_api_url").toString() + "/BizboxMobileGateway/service/SearchTokenInfo";
				
				paramMap.put("apiTp", "checkMobileToken");
				paramMap.put("reqType", "param");
				paramMap.put("data", apiUrl + " > " + jsonObj.toString());
	    		commonSql.insert("OnefficeDao.setApiLog", paramMap);
	    		
	    		Logger.getLogger( CloudConnetInfo.class ).debug( "OnefficeController.checkMobileToken  apiUrl : " + apiUrl );
	    		Logger.getLogger( CloudConnetInfo.class ).debug( "OnefficeController.checkMobileToken  jsonObj : " + jsonObj );
				
				Map<String, Object> result = callApiToMap(jsonObj, apiUrl);
				
				Logger.getLogger( CloudConnetInfo.class ).debug( "OnefficeController.checkMobileToken  result : " + result );
				
				paramMap.put("apiTp", "checkMobileToken");
				paramMap.put("reqType", "result");
				paramMap.put("data", result.toString());
	    		commonSql.insert("OnefficeDao.setApiLog", paramMap);				
				
				if(result != null && result.get("resultCode").equals("0")){					
					@SuppressWarnings("unchecked")
					Map<String, Object> resultInfo = (Map<String, Object>) result.get("result");
					if(resultInfo != null && resultInfo.get("empSeq") != null){
						flag = true;
						mobileGroupSeq = groupSeq;
						mobileEmpSeq = (String)resultInfo.get("empSeq");
					}
				}
			}			
			}catch(Exception e) {
				CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
			}
		}else {
			LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser( );
			if (loginVO != null) {
				flag = true;
			}
		}
		return flag;
	}

	@RequestMapping(value="/onefficeApi/searchAMRequestUserID.do")
	public ModelAndView searchAMRequestUserID(@RequestParam HashMap<String, Object> paramMap, HttpServletRequest request, HttpServletResponse response) throws Exception {
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");	
	
		LoginVO loginVO = checkLoginVO(request);
		
		Logger.getLogger( OnefficeController.class ).debug("accessManager Start");
		
		if(loginVO != null)
		{
			paramMap.put("groupSeq", loginVO.getGroupSeq());
			paramMap.put("compSeq", loginVO.getCompSeq());
			paramMap.put("empSeq", loginVO.getUniqId());
			
			paramMap.put("pathSeq", "0");
			paramMap.put("osType", "linux");
			
			Map<String, Object> pathMap = (Map<String, Object>) commonSql.select("GroupManage.selectPathInfo", paramMap);
			
			String uploadPath = pathMap.get("absolPath").toString().replace("/home", "");
			
			paramMap.put("profilePath", uploadPath + "/img/profile/" + loginVO.getGroupSeq() + "/");

			paramMap.put("langCode", loginVO.getLangCode());
			
			String sqlQuery;
    		sqlQuery = "OnefficeDao.manager_search_requestUser";
			Logger.getLogger( OnefficeController.class ).debug("nRet searchRequestUser");
			@SuppressWarnings("unchecked")
			List<Map<String, Object>> result = (List<Map<String, Object>>) commonSql.list(sqlQuery, paramMap);
			 
			
			mv.addObject("result","success");
			mv.addObject("data",result);
		}
		else
		{
			mv.addObject("result","fail");
		}
		
		return mv;
	} 
	 
	@RequestMapping(value="/onefficeApi/searchAMResponeAnswer.do")
	public ModelAndView searchAMResponeAnswer(@RequestParam HashMap<String, Object> paramMap, HttpServletRequest request, HttpServletResponse response) throws Exception {
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");	
	
		LoginVO loginVO = checkLoginVO(request);
		
		Logger.getLogger( OnefficeController.class ).debug("searchResponseAnswer Start");
		
		if(loginVO != null) 
		{
			paramMap.put("groupSeq", loginVO.getGroupSeq());
			paramMap.put("compSeq", loginVO.getCompSeq());
			paramMap.put("empSeq", loginVO.getUniqId());
			
			String sqlQuery;
			sqlQuery = "OnefficeDao.manager_search_reponse_answer";
			Logger.getLogger( OnefficeController.class ).debug("nRet searchRequestUser");
			@SuppressWarnings("unchecked")
			String result = (String)commonSql.select(sqlQuery, paramMap);
			
			mv.addObject("result","success");
			mv.addObject("data",result);
		}
		else  
		{
			mv.addObject("result","fail");
			
			Logger.getLogger( OnefficeController.class ).debug("LoginVO null");
		}
		
		return mv;
	}

	@RequestMapping(value="/onefficeApi/updateAMRequestID.do")
	public ModelAndView updateAMRequestID(@RequestParam HashMap<String, Object> paramMap, HttpServletRequest request, HttpServletResponse response) throws Exception {
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");	
	
		LoginVO loginVO = checkLoginVO(request);
		
		Logger.getLogger( OnefficeController.class ).debug("updateRequestID Start");
		
		int result = 0;
		if(loginVO != null)
		{
			paramMap.put("groupSeq", loginVO.getGroupSeq());
			paramMap.put("compSeq", loginVO.getCompSeq());
			paramMap.put("empSeq", loginVO.getUniqId());
			  
			String sqlQuery;
        	sqlQuery = "OnefficeDao.manager_update_request_id";
        	if (paramMap.get("mode").equals("cancel")) {
				sqlQuery = "OnefficeDao.manager_update_cancel_request_id";
        	}
			
		    result = (int)commonSql.update(sqlQuery, paramMap);
		      
		    if (result == 0) {
				List<Map<String, Object>> accessResult = (List<Map<String, Object>>) commonSql.list("OnefficeDao.getDocumentAccessInfo", paramMap);
				Logger.getLogger(OnefficeController.class ).debug("access_result.size() = " + accessResult.size());
				result = 9999; //편집자가 문서를 닫고 나간 경우 
				for (Map<String, Object> tmpMap : accessResult)
				{
					if (tmpMap.get("access_perm").equals("W")) {
						result = 0; // 다른 사용자가 이미 요청중인 경우
						Logger.getLogger(OnefficeController.class ).debug("access_result Write Used");
						break;
					}
				}
		    }
			
			mv.addObject("result","success");
			mv.addObject("data",result);
		}
		else
		{
			mv.addObject("result","fail");
			Logger.getLogger( OnefficeController.class ).debug("LoginVO null");
		}
		
		Logger.getLogger( OnefficeController.class ).debug("updateReqAnswerManager end ");
		return mv;
	}
	 
	@RequestMapping(value="/onefficeApi/updateAMAnswer.do")
	public ModelAndView updateAMAnswer(@RequestParam HashMap<String, Object> paramMap, HttpServletRequest request, HttpServletResponse response) throws Exception {
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");	
	
		LoginVO loginVO = checkLoginVO(request);
		
		Logger.getLogger( OnefficeController.class ).debug("updateReqAnswerManager Start");

		int result = 0; 
		if(loginVO != null)
		{
			paramMap.put("groupSeq", loginVO.getGroupSeq());
			paramMap.put("compSeq", loginVO.getCompSeq());
			paramMap.put("empSeq", loginVO.getUniqId());
			
			String sqlQuery; 
        	sqlQuery = "OnefficeDao.manager_update_response_answer";
			Logger.getLogger( OnefficeController.class ).debug("nRet update Reuqest Answer ");
			result = (int)commonSql.update(sqlQuery, paramMap);
			if (result >= 1 && paramMap.get("response_answer").equals("1")) {
				//Access_info도 변경 해 주자.
				//권한 넘겨주는 사람의 편집권한을 읽기 권한으로 변경 
				sqlQuery = "OnefficeDao.am_update_changemode_access_info";
				paramMap.put("access_id", paramMap.get("editor_id"));
				paramMap.put("change_access_perm", "R");
				result = (int)commonSql.update(sqlQuery, paramMap);
				
				//요청자의 권한을 쓰기 모드로 변경 하여 주자. 
				paramMap.put("access_id", paramMap.get("request_id"));
				paramMap.put("change_access_perm", "W");
				result = (int)commonSql.update(sqlQuery, paramMap);
			}
			
			mv.addObject("result","success");
			mv.addObject("data",result);
		}
		else
		{
			mv.addObject("result","fail");
			
			Logger.getLogger( OnefficeController.class ).debug("LoginVO null");
		}
		
		Logger.getLogger( OnefficeController.class ).debug("updateReqAnswerManager end ");
		return mv;
	}

	@RequestMapping(value="/onefficeApi/accessManager.do")
	public ModelAndView accessManager(@RequestParam Map<String, Object> paramMap,  HttpServletRequest request, HttpServletResponse response) 
	{
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");	
	
		LoginVO loginVO = checkLoginVO(request);
		
		Logger.getLogger( OnefficeController.class ).debug("accessManager Start");
		
		if(loginVO != null)
		{
			paramMap.put("groupSeq", loginVO.getGroupSeq());
			paramMap.put("compSeq", loginVO.getCompSeq());
			paramMap.put("empSeq", loginVO.getUniqId());
			
			String sqlQuery;
			Map<String, Object> resultMap = new HashMap<String, Object>();
			if (paramMap.get("mode").equals("delete"))
			{
				sqlQuery = "OnefficeDao.manager_delete_docno";
				Logger.getLogger( OnefficeController.class ).debug("nRet deleteAccessManager");
			    int nRet = (int)commonSql.delete(sqlQuery, paramMap);
			    if (nRet <= 0) {
			    	Logger.getLogger( OnefficeController.class ).error("delete accessManager Error");
			    	resultMap.put("result", 0);
			    }else {
			    	resultMap.put("result", nRet);	
			    }
			}
			else   
			{
				//Sync Accessinfo와 AccessManager Sync 맞추어주는 쿼리 실행
				sqlQuery = "OnefficeDao.syncAccessManagerandAccessInfo";
				
				try {
					int nDeleteCnt = commonSql.delete(sqlQuery, paramMap);
					Logger.getLogger( OnefficeController.class ).debug("syncAccessManagerAccessInfo " + paramMap.get("doc_no") + "nDeletCnt = " + nDeleteCnt);
				}catch (Exception e) {
					Logger.getLogger( OnefficeController.class ).debug("nRet syncAccessManagerandAccessInfo" + e);	
				}
				 
				
				sqlQuery = "OnefficeDao.manager_insert";
				try {
					int insertCnt  = commonSql.update(sqlQuery, paramMap);
					if (insertCnt > 0) {
						sqlQuery = "OnefficeDao.sharedoc_write_open_cnt";
						int nTotalCnt = (int)commonSql.select(sqlQuery, paramMap);
						resultMap.put("result", insertCnt);
						resultMap.put("openDocCnt", nTotalCnt);
						resultMap.put("update_try",0);
					}
					else 
					{
						//기존에 있는 Data가 맞지 않으면 강제로 입력을 하자.
						sqlQuery = "OnefficeDao.am_force_change_editor_id";
						Logger.getLogger( OnefficeController.class ).debug("nRet managerInsert Fail Update 시도" + sqlQuery);
						insertCnt  = commonSql.update(sqlQuery, paramMap);
						if (insertCnt > 0) {
							sqlQuery = "OnefficeDao.sharedoc_write_open_cnt";
							int nTotalCnt = (int)commonSql.select(sqlQuery, paramMap);
							resultMap.put("result", insertCnt);
							resultMap.put("openDocCnt", nTotalCnt);
							resultMap.put("update_try",1);
						}else {
							resultMap.put("result", 0);
							resultMap.put("update_try",1);
						}
					}
				}catch (Exception e) {
					Logger.getLogger( OnefficeController.class ).debug("nRet manager_insert" + sqlQuery);	
				}
			}
	
			
			mv.addObject("result","success");
			mv.addObject("data",resultMap);
		}
		else
		{
			mv.addObject("result","fail");
			Logger.getLogger( OnefficeController.class ).debug("LoginVO null");
		}
		return mv;
	}	

	//문서 소유자 변경 요청 (UCDOC-1340)
	@RequestMapping(value="/onefficeApi/createChangeOwnerReq.do")
	public ModelAndView createChangeOwnerReq(@RequestParam Map<String, Object> paramMap, HttpServletRequest request, HttpServletResponse response) throws Exception {
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");

		LoginVO loginVO = checkLoginVO(request);
		String errCode = "";
		try{			
			if(loginVO == null){
				throw new Exception();
			}

			//* param
			//1) new_owner_id : 새 소유자 아이디
			//2) doc_no_list  : 이전할 문서/폴더 리스트

			String orgOwnerID = loginVO.getUniqId();
			String newOwnerID = (String) paramMap.get("new_owner_id");
			String strDocNoList = (String) paramMap.get("doc_no_list");

			if(newOwnerID == null || newOwnerID.equals("") || strDocNoList == null || strDocNoList.equals("")) {
				errCode = "ERR_PARAM_OMIT";
				throw new Exception();
			}

			if(orgOwnerID.equals(newOwnerID)) {	//new_owner_id가 실제 있는 사람 인지
				errCode = "ERR_PARAM_NEW_OWNER";
				throw new Exception();
			}

			List<String> docNoList = Arrays.asList(strDocNoList.split(","));	//선택한 문서/폴더 list
			if(docNoList.size() == 0) {	// doc_no_list가 실제 있는 doc_no 인지
				errCode = "ERR_PARAM_DOC_NO";
				throw new Exception();
			}

			paramMap.put("user_id", orgOwnerID);	//내 아이디
			paramMap.put("doc_no_list", docNoList);

			String reqID = UUID.randomUUID().toString().replace("-", "");	//1) 요청 아이디 생성
			paramMap.put("req_id", reqID);
			
			commonSql.insert("OnefficeDao.insertChgOwnReq", paramMap);	//2) 요청 /요청 문서 테이블 추가
			commonSql.insert("OnefficeDao.insertChgOwnDoc", paramMap);

			//* return
			//req_id : 요청 아이디
			HashMap<String, Object> data = new HashMap<String, Object>();
			data.put("req_id", reqID);

			mv.addObject("result", "success");
			mv.addObject("data", data);

		} catch (Exception e) {
			mv.addObject("result", "fail");
			mv.addObject("err_code", errCode);
		}
		return mv;
	}

	//문서 소유자 변경 승인/거부/확인 (UCDOC-1340)
	@RequestMapping(value="/onefficeApi/changeOwner.do")
	public ModelAndView changeOwner(@RequestParam HashMap<String, Object> paramMap, HttpServletRequest request, HttpServletResponse response) throws Exception {
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");

		LoginVO loginVO = checkLoginVO(request);
		String errCode = "";
		try{
			
			if(loginVO == null){
				throw new Exception();
			}

			//* param
			//1) req_id : 요청 번호
			//2) type 	: "accept"(승인, 1), "reject"(거부, 2), "confirm"(확인, 3)
			//3) folder_no  : 파일을 옮길 폴더
			//4-1) action_code  : for 히스토리
			//4-2) action_use
			//4-3) action_user_name
			//4-4) user_gps

			String reqID = (String) paramMap.get("req_id");
			String type = (String) paramMap.get("type");
			String folderNo = (String) paramMap.get("folder_no");
			String actionCode = (String) paramMap.get("action_code");	//15

			//예외 처리
			if(reqID == null || reqID.equals("")) {
				errCode = "ERR_PARAM_REQ";
				throw new Exception();
			}
			
			int nType = 0;	//승인: 1, 거부: 2, 확인: 3	
			switch(type) {
				case "accept": nType = 1; break;
				case "reject": nType = 2; break;
				case "confirm": nType = 3; break;
				default:
					errCode = "ERR_PARAM_TYPE";
					throw new Exception();
			}

			@SuppressWarnings("unchecked")
			Map<String, Object> reqInfo = (Map<String, Object>) commonSql.select("OnefficeDao.selectChgOwnReq", paramMap);
			if(reqInfo == null || reqInfo.size() == 0) {
				errCode = "ERR_NO_REQ";	//올바르지 않은 req_id 이거나, 이미 요청자가 확인을 완료 해서 이관 process가 끝난 경우
				throw new Exception();
			}

			if(nType == 1 && !folderNo.equals("")) {
				@SuppressWarnings("unchecked")
				Map<String, Object> isFolder = (Map<String, Object>) commonSql.select("OnefficeDao.isFolder", paramMap);
				if(isFolder == null || isFolder.size() == 0) {
					errCode = "ERR_PARAM_FOLDER_NO";	//올바르지 않은 폴더를 선택해서 승인한 경우
					throw new Exception();
				}
			}

			String loginID = loginVO.getUniqId();							//접속자 아이디
			String orgUserID = (String) reqInfo.get("org_owner_id"); 	//이관 요청자 아이디
			String newUserID = (String) reqInfo.get("new_owner_id"); 	//이관 대상자 아이디
			int nState = Integer.parseInt((String) reqInfo.get("state"));	//상태 (0:대기중, 1: 승인, 2: 거부)

			if(nType == 1 || nType == 2) {
				if(nState != 0) {
					errCode = "ERR_STATE";	//이미 승인/거부 된 경우
					throw new Exception();	
				}

				if(!newUserID.equals(loginID)) {
					errCode = "ERR_OTHER_EMP";	//승인/거부를 다른 사람이 한 경우
					throw new Exception();	
				}
			}

			if(nType == 3 && !orgUserID.equals(loginID)) {
				errCode = "ERR_OTHER_EMP";	//확인을 다른 사람이 한 경우
				throw new Exception();
			}

			paramMap.put("user_id", orgUserID);
			paramMap.put("owner_id", orgUserID);
			paramMap.put("empSeq", orgUserID);
			paramMap.put("langCode", loginVO.getLangCode());
			paramMap.put("groupSeq", loginVO.getGroupSeq());

			int nCount = 0;						//이관 요청한 문서/폴더 갯수
			List<String> docNoList = null;	//이관 요청한 문서 번호 list

			//승인
			if(nType == 1)
			{
				//1) 요청 번호의 doc list를 가져온다.
				@SuppressWarnings("unchecked")
				List<Map<String, String>> docNoMapList = commonSql.list("OnefficeDao.getWillChgOwnDocList", paramMap);

				docNoList = new ArrayList<String>();
				for(Map<String, String> doc_no_map : docNoMapList) {
					docNoList.add(doc_no_map.get("doc_no"));
				}

				paramMap.put("doc_no_list", docNoList);		//이관 요청한 문서/폴더
				
				nCount = docNoList.size();
				
				//2) 요청 상태를 승인(1) 상태로 바꾼다.
				paramMap.put("state", nType);
				commonSql.update("OnefficeDao.updateChgOwnReq", paramMap);	//상태 1

				if(nCount > 0)
				{
					/*** 실제 여기서 문서 소유자가 변경 됩니다!!! ***/
					
					//3) 요청 folder 아래에 임시 폴더를 만든다.
					//4) doc list 를 모두 임시 폴더로 옮긴다.
					//5) 임시 폴더 내부의 모든 doc list를 가져온다 (하위 폴더 포함)
					//6) 모든 doc_no_list의 소유자를 변경한다.
					//7) 히스토리를 쌓는다. (action_code: 15)
					//8) doc list 를 요청 folder 로 옮긴다.
					//9) 임시 폴더를 삭제 한다.	
					//10) org 소유자가 가지고 있는 리소스(이미지) 폴더를 new 소유자 에게 넘긴다.

					
					//3) 요청 folder 아래에 임시 폴더를 만든다.
					String tempFolderNo = UUID.randomUUID().toString().replace("-", "");
					paramMap.put("doc_no", tempFolderNo);
					paramMap.put("doc_name", "temp_chgown_" + orgUserID + "_" + newUserID);

					commonSql.insert("OnefficeDao.createTempFolder", paramMap);

					//4) doc list 를 모두 임시 폴더로 옮긴다.
					paramMap.put("folder_no", tempFolderNo);

					commonSql.update("OnefficeDao.updateFolderNo", paramMap);

					//5) 임시 폴더 내부의 모든 doc list를 가져온다 (하위 폴더 포함)
					paramMap.put("folderNo", tempFolderNo);
					
					Map<String, Object> returnMap = getFolderNoStr(paramMap);
					paramMap.put("folderNoStr", returnMap.get("folderNoStr"));
					paramMap.put("subFolderDeleteList", returnMap.get("subFolderDeleteList"));

					@SuppressWarnings("unchecked")
					List<Map<String, String>> allfileNoMapList = commonSql.list("OnefficeDao.getAllChild", paramMap);

					List<String> allFileNoList = new ArrayList<String>();	//모든 파일
					List<String> allFolderNoList = new ArrayList<String>();	//폴더만
					List<String> allDocNoList = new ArrayList<String>();		//문서만

					for(Map<String, String> all_file_no_map : allfileNoMapList) {
						String tempDocNo = all_file_no_map.get("doc_no");
						int tempDocType = Integer.parseInt((String) all_file_no_map.get("doc_type"));

						if(tempDocType == 0) {
							allFolderNoList.add(tempDocNo);
						} else {
							allDocNoList.add(tempDocNo);
						}
						allFileNoList.add(tempDocNo);
					}
					
					//6) 모든 doc_no_list의 소유자를 변경한다.
					paramMap.put("doc_no_list", allFileNoList);
					paramMap.put("owner_id", newUserID);

					commonSql.update("OnefficeDao.updateShareOwner", paramMap);		//공유 owner
					commonSql.update("OnefficeDao.updateDocumentOwner", paramMap);	//문서 owner

					//7) 히스토리를 쌓는다. (action_code: 15)
					if(actionCode != null && actionCode.equals("15")) {

						String userIP = ((HttpServletRequest)request).getHeader("X-FORWARDED-FOR");	//accessDocumentHistory 코드와 동일

						if(userIP == null || userIP.length( ) == 0) {
							userIP = ((HttpServletRequest)request).getHeader( "Proxy-Client-IP" );
						}

						if(userIP == null || userIP.length( ) == 0) {
							userIP = ((HttpServletRequest)request).getHeader( "WL-Proxy-Client-IP" );
						}
						//Custom property 값 ProxyAddYn이 "Y"경우 header 값 체크 추가 (proxy 및 모든 l4 대응 방안)
						if(BizboxAProperties.getCustomProperty("BizboxA.ProxyAddYn").equals("Y")) {
							if(userIP == null || userIP.length( ) == 0) {
								userIP = ((HttpServletRequest)request).getHeader( "HTTP_CLIENT_IP" );
							}
							if(userIP == null || userIP.length( ) == 0) {
								userIP = ((HttpServletRequest)request).getHeader( "HTTP_X_FORWARDED_FOR" );
							}
							if(userIP == null || userIP.length( ) == 0) {
								userIP = ((HttpServletRequest)request).getHeader( "X-Real-IP" );
							}
						}
						if(userIP == null || userIP.length( ) == 0) {
							userIP = request.getRemoteAddr( );
						}

						if(userIP == null) {
							userIP = "";
						}

						if(request.getServerName().equals("localhost")){
							userIP = "127.0.0.1";
						}

						paramMap.put("user_ip", userIP);

						//원래 문서 소유자 이름 이름 얻기
						HashMap<String, Object> paramMap1 = new HashMap<String, Object>();
						paramMap1.put("compSeq", loginVO.getCompSeq());
						paramMap1.put("empSeq", orgUserID);
						paramMap1.put("langCode", loginVO.getLangCode());

						@SuppressWarnings("unchecked")
						Map<String, Object> orgEmpInfo = (Map<String, Object>) commonSql.select("OnefficeDao.getMyInfo", paramMap1);

						paramMap.put("action_data", "{\"org_owner_id\":\"" + orgUserID + 
													  "\",\"new_owner_id\":\"" + newUserID +
													  "\",\"org_owner_name\":\"" + orgEmpInfo.get("name") +
													  "\",\"new_owner_name\":\"" + loginVO.getName() + "\"}");

						paramMap.put("empSeq", loginID);
						for(String doc_no : allDocNoList) {
							paramMap.put("doc_no", doc_no);
							commonSql.insert("OnefficeDao.InsertAccessDocumentHistory", paramMap);
						}
					}
					
					//8) doc list 를 요청 folder 로 옮긴다.
					paramMap.put("doc_no_list", docNoList);
					paramMap.put("folder_no", folderNo);

					commonSql.update("OnefficeDao.updateFolderNo", paramMap);

					//9) 임시 폴더를 삭제 한다.
					paramMap.put("doc_no", tempFolderNo);
					paramMap.put("empSeq", orgUserID);

					commonSql.delete("OnefficeDao.deleteTrashDocument", paramMap);

					//10) org 소유자가 가지고 있는 리소스(이미지) 폴더를 new 소유자 에게 넘긴다.
					String uploadPath = "";
					String absolPath = "";

					paramMap.put("pathSeq", "0");
					paramMap.put("osType", NeosConstants.SERVER_OS);

					Map<String, Object> pathMap = groupManageService.selectGroupPath(paramMap);
					if(pathMap != null) {
						absolPath = pathMap.get("absolPath").toString();
					}

					uploadPath = absolPath + "/onefficeFile/";

					String targetPath = ""; //새 소유자 리소스 폴더
					String srcPath = "";	//원래 소유자 문서별 리소스 폴더

					for(String doc_no : allDocNoList) {
						srcPath = uploadPath + orgUserID + "/" + doc_no + "/";
						targetPath = uploadPath + newUserID + "/" + doc_no + "/";	

						File srcFolder = new File(srcPath);
						if(srcFolder.exists() && srcFolder.isDirectory()) {
							FileUtils.moveTransfer(srcPath, targetPath);
						}
					}
				}
			}
			//거부
			else if(nType == 2)
			{
				paramMap.put("state", nType);
				commonSql.update("OnefficeDao.updateChgOwnReq", paramMap);	//상태 2
			}
			//확인
			else if(nType == 3)
			{
				commonSql.delete("OnefficeDao.deleteChgOwnDoc", paramMap);	//요청 내역 삭제
				commonSql.delete("OnefficeDao.deleteChgOwnReq", paramMap);
			}

			HashMap<String, Object> retData = new HashMap<String, Object>();
			retData.put("count", nCount);
			if(docNoList != null) {
				retData.put("doc_no_list", docNoList);	//승인 시, 이관 완료된 문서 번호
			}

			mv.addObject("result", "success");
			mv.addObject("data", retData);

		} catch (Exception e) {
			mv.addObject("result", "fail");
			mv.addObject("err_code", errCode);
		}
		return mv;
	}

	//나와 관련된 문서 이관 정보(UCDOC-1340)
	@RequestMapping(value="/onefficeApi/getChangeOwner.do")
	public ModelAndView getChangeOwner(@RequestParam HashMap<String, Object> paramMap, HttpServletRequest request, HttpServletResponse response) throws Exception {
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");

		LoginVO loginVO = checkLoginVO(request);
		try{
			if(loginVO == null){
				throw new Exception();
			}
			
			String userID = loginVO.getUniqId();
			paramMap.put("user_id", userID);

			//나와 관계된 이관 요청 정보
			@SuppressWarnings("unchecked")
			List<Map<String, Object>> chgOwnReqList = (List<Map<String, Object>>)commonSql.list("OnefficeDao.getChgOwnReq", paramMap);

			List<Map<String, Object>> reqList = new ArrayList<Map<String, Object>>();	//내가 요청 보냄
			List<Map<String, Object>> resList = new ArrayList<Map<String, Object>>();	//내가 요청 받음
			List<Map<String, Object>> empList = new ArrayList<Map<String, Object>>();	//다른 사용자 정보

			if(chgOwnReqList.size() > 0)
			{
				HashSet<String> empSeqSet = new HashSet<String>();	//다른 사용자 정보
				empSeqSet.add(userID);

				String orgOwnerID = null;
				String newOwnerID = null;

				for(Map<String, Object> chgOwnReq : chgOwnReqList) {
					orgOwnerID = (String) chgOwnReq.get("org_owner_id");
					newOwnerID = (String) chgOwnReq.get("new_owner_id");

					if(userID.equals(orgOwnerID)) {	//내가 요청 보낸 경우
						reqList.add(chgOwnReq);
						empSeqSet.add(newOwnerID);
					}
					else if(userID.equals(newOwnerID)) {	//내가 요청 받은 경우
						resList.add(chgOwnReq);
						empSeqSet.add(orgOwnerID);
					}
					else {
						continue;
					}

					//요청 받거나/요청한 문서 번호 리스트
					paramMap.put("req_id", chgOwnReq.get("req_id"));

					@SuppressWarnings("unchecked")
					List<Map<String, String>> docNoMapList = (List<Map<String, String>>)commonSql.list("OnefficeDao.selectChgOwnDoc", paramMap);

					List<String> docNoList = new ArrayList<String>();
					for(Map<String, String> docNoMap : docNoMapList) {
						docNoList.add(docNoMap.get("doc_no"));
					}

					chgOwnReq.put("doc_no_list", docNoList);
				}

				//나와 요청을 주고/받은 사원 정보
				String groupSeq = loginVO.getGroupSeq();
				paramMap.put("groupSeq", groupSeq);
				paramMap.put("compSeq", loginVO.getCompSeq());
				paramMap.put("empSeq", loginVO.getUniqId());
				paramMap.put("langCode", loginVO.getLangCode());
				
				paramMap.put("pathSeq", "0");
				paramMap.put("osType", "linux");
				
				Map<String, Object> pathMap = (Map<String, Object>) commonSql.select("GroupManage.selectPathInfo", paramMap);
				
				String uploadPath = pathMap.get("absolPath").toString().replace("/home", "");
				
				paramMap.put("profilePath", uploadPath + "/img/profile/" + groupSeq + "/");

				for(String empSeq : empSeqSet) {
					paramMap.put("empSeq", empSeq);

					@SuppressWarnings("unchecked")
					Map<String, Object> empInfo = (Map<String, Object>) commonSql.select("OnefficeDao.getMyInfo", paramMap);
					empList.add(empInfo);
				}
			}

			//* return
			HashMap<String, Object> data = new HashMap<String, Object>();
			data.put("req_list", reqList);
			data.put("res_list", resList);
			data.put("emp_list", empList);

			mv.addObject("result", "success");
			mv.addObject("data", data);

		}catch (Exception e) {
			mv.addObject("result", "fail");
		}
		return mv;
	}

	//이관 대기중인 문서 취소 (UCDOC-1340)
	@RequestMapping(value="/onefficeApi/cancelChangeOwner.do")
	public ModelAndView cancelChangeOwner(@RequestParam HashMap<String, Object> paramMap, HttpServletRequest request, HttpServletResponse response) throws Exception {
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");

		LoginVO loginVO = checkLoginVO(request);
		String errCode = "";
		try{
			if(loginVO == null){
				throw new Exception();
			}

			//* param
			//1) doc_no_list : 이전 대기중 문서/폴더 리스트

			String strDocNoList = (String) paramMap.get("doc_no_list");
			String reqID = (String) paramMap.get("req_id");

			int count = 0;

			paramMap.put("user_id", loginVO.getUniqId());

			/*
			if(reqID != null && !reqID.equals(""))
			{
				//TODO
			}
			else
			*/
			if(strDocNoList != null && !strDocNoList.equals(""))
			{
				List<String> docNoList = Arrays.asList(strDocNoList.split(","));
				if(docNoList.size() == 0) {
					errCode = "ERR_PARAM_DOC_NO";
					throw new Exception();
				}

				paramMap.put("doc_no_list", docNoList);

				count = commonSql.delete("OnefficeDao.deleteChgOwnDoc", paramMap);	//요청 문서 삭제
			}

			//return
			//1) 삭제된 갯수
			HashMap<String, Object> data = new HashMap<String, Object>();
			data.put("count", count);

			mv.addObject("result", "success");
			mv.addObject("data", data);

		}catch (Exception e) {
			mv.addObject("result", "fail");
			mv.addObject("err_code", errCode);
		}
		return mv;
	}
	
	
	
	//원피스 PDF 변환 다운로드 (세션체크 X)
	@RequestMapping(value="/onefficeApi/onefficePdfDownLoad.do")
	public void onefficePdfDownLoad(@RequestParam HashMap<String, Object> paramMap, HttpServletRequest request, HttpServletResponse response) throws Exception {
		String fileId = paramMap.get("fileId").toString();
		if (fileId == null || fileId.equals("")) {
			return;
		}
		
		Map<String, Object> fileMap = new HashMap<String, Object>();
		
		String pathSeq = "0";
		
		//모듈별 공통 필수 변수
		File file = null;
		FileInputStream fis = null;

		String path = "";
		String fileNameWithoutExt = "";
		String fileName = "";
		String orignlFileName = "";
		String fileExtsn = "";
		String imgExt = "jpeg|bmp|gif|jpg|png";
		String applicationExt = "pdf";
		
		paramMap.put("osType", NeosConstants.SERVER_OS);
				
		/** 첨부파일 상세정보 조회 */
	 	fileMap = attachFileService.getAttachFileDetail(paramMap);
	 	
	 	if (fileMap == null) {
	 		return;
	 	}
	 	
	 	pathSeq = fileMap.get("pathSeq")+"";
	 	

	 	/** 절대경로 조회 */
	 	paramMap.put("pathSeq", pathSeq);
	 	paramMap.put("osType", NeosConstants.SERVER_OS);
	 	Map<String, Object> groupPahtInfo = groupManageService.selectGroupPath(paramMap);
	 	
	 	path = groupPahtInfo.get("absolPath") + File.separator + (fileMap.get("fileStreCours") == null ? "" : fileMap.get("fileStreCours"));
	 	fileNameWithoutExt = fileMap.get("streFileName") + "";
	 	fileName =  fileMap.get("streFileName") + "." + fileMap.get("fileExtsn");
	 	orignlFileName = fileMap.get("orignlFileName") + "." + fileMap.get("fileExtsn");
		
		fileExtsn = String.valueOf(fileMap.get("fileExtsn"));
		
		try {
			//DRM 체크
			String drmPath = drmService.drmConvert("D", paramMap.get("groupSeq") != null ? paramMap.get("groupSeq").toString() : "", pathSeq, path, fileNameWithoutExt, fileExtsn);
			file = new File(drmPath);
		    fis = new FileInputStream(file);

		    String browser = request.getHeader("User-Agent");
		    
		    //파일 인코딩
		    if(browser.contains("MSIE") || browser.contains("Trident") || browser.contains("Edge")){
		    	orignlFileName = URLEncoder.encode(orignlFileName,"UTF-8").replaceAll("\\+", "%20"); 
		    } 
		    else {
		    	orignlFileName = new String(orignlFileName.getBytes("UTF-8"), "ISO-8859-1"); 
		    }
		    
		    String type = "";
		    
			if (fileExtsn != null && !fileExtsn.equals("")) {
				//이미지 컨텐츠타입 설정
				if(imgExt.indexOf(fileExtsn.toLowerCase()) != -1){
					
					if(fileExtsn.toLowerCase().equals("jpg")){
						type = "image/jpeg";
					}else{
						type = "image/" + fileExtsn.toLowerCase();
					}
				}
				//어플리케인션 컨텐츠타입 설정
				else if(applicationExt.indexOf(fileExtsn.toLowerCase()) != -1){
					type = "application/" + fileExtsn.toLowerCase();
				}				
			}
		    
			if(!type.equals("")){
				response.setHeader("Content-Type", type);
			}else{
				response.setContentType(CommonUtil.getContentType(file));
				response.setHeader("Content-Transfer-Encoding", "binary;");
			}

		    if(!type.equals("") && paramMap.get("inlineView") != null && paramMap.get("inlineView").toString().equals("Y")){
				//Inline View
		    	response.setHeader("Content-Disposition","inline;filename=\"" + orignlFileName+"\"");
		    }else{
		    	//Attach Download
		    	response.setHeader("Content-Disposition","attachment;filename=\"" + orignlFileName+"\"");	
		    }

		    response.setContentLength((int) file.length());

			byte buffer[] = new byte[4096];
			int bytesRead = 0, byteBuffered = 0;
			
			while((bytesRead = fis.read(buffer)) > -1) {
				
				response.getOutputStream().write(buffer, 0, bytesRead);
				byteBuffered += bytesRead;
				
				//flush after 1MB
				if(byteBuffered > 1024*1024) {
					byteBuffered = 0;
					response.getOutputStream().flush();
				}
			}

			response.getOutputStream().flush();
			response.getOutputStream().close();
			
		} catch (FileNotFoundException e) {
			Logger.getLogger( OnefficeController.class ).debug( "onefficePdfDownLoad FileNotFoundException : " + e.getMessage());
		} catch (IOException e) {
			Logger.getLogger( OnefficeController.class ).debug( "onefficePdfDownLoad IOException : " + e.getMessage());
		} finally {
			if (fis != null) {
				try {
					fis.close();
				} catch (Exception ignore) {
					//LOGGER.debug("IGNORE: {}", ignore.getMessage());
				}
			}
		}
	}
	
	
	@RequestMapping(value="/onefficeApi/OnefficeApiService.do", method={RequestMethod.GET, RequestMethod.POST})
	@ResponseBody
	public ModelAndView OnefficeApiService(HttpServletRequest servletRequest, HttpServletResponse servletResponse, @RequestBody RestfulRequest request) throws Exception {
		
		ModelAndView mv = new ModelAndView();
		
		Logger.getLogger( OnefficeController.class ).debug( "OnefficeApiService.do request.body : " + request.getBody() );
		Logger.getLogger( OnefficeController.class ).debug( "OnefficeApiService.do request.header : " + request.getHeader() );
		
		Map<String, Object> reBody =  request.getBody();
		String apiName = (String) reBody.get("apiName");
		
		reBody.remove("companyInfo");
		
		HashMap<String, Object> apiParam = new HashMap<String, Object>();
		
		Iterator<String> keys = reBody.keySet().iterator();
        while( keys.hasNext() ){
            String key = keys.next();
            apiParam.put(key, reBody.get(key));
        }
        
        servletRequest.setAttribute("groupSeq", request.getHeader().getGroupSeq());
        servletRequest.setAttribute("empSeq", request.getHeader().getEmpSeq());
        
        Object arr[] =new Object[3];
        arr[0] = apiParam;
        arr[1] = servletRequest;
        arr[2] = servletResponse;        
        ModelAndView resultMv = (ModelAndView) MethodUtils.invokeMethod(this,apiName,arr);
        
        mv.addObject("result", resultMv.getModel());
        mv.addObject("resultCode", "SUCCESS");
        mv.addObject("resultMessage", BizboxAMessage.getMessage("TX000011955","성공하였습니다"));
        
        mv.setViewName("jsonView");
        
        return mv;
        
	}
	
	private void setRecentDocument(Map<String, Object> getDocumentMap) {
		/* 공유 문서 Data
		 * {owner_name=곽윤우, owner_id=1406, 
		 *  access_date=2020-04-02 20:55:11.0, 
		 * doc_no=5339b95bda6f4f6ab346a6481eabcf1f, 
		 * share_date=2020-04-02 20:55:11.0, 
		 * share_id=1405, 
		 * doc_name=윤우공유, my_id=1405, share_perm=W}
		 */
		
	
		if (!getDocumentMap.get("doc_type").equals("1")) {
			return;
		}
		
		String strOwnerid = (String)getDocumentMap.get("owner_id");
		String strUserid = (String)getDocumentMap.get("user_id");
		String strDocNo = (String)getDocumentMap.get("doc_no");
		java.sql.Timestamp shareDate = (java.sql.Timestamp)getDocumentMap.get("share_date");
		String strOwnerName = (String)getDocumentMap.get("owner_name");
		
		String strSharePerm = "";
		if (getDocumentMap.get("share_perm") != null) {
			strSharePerm = (String)getDocumentMap.get("share_perm");	
		}
		

		if (strUserid.isEmpty()) {
			strUserid = "blank";
			Logger.getLogger(OnefficeController.class).debug("SetRecent UserID Blank");
			return;
		}

		if (!strUserid.equals(strOwnerid) && strSharePerm.isEmpty()) {
			Logger.getLogger(OnefficeController.class).debug("권한이 없는 문서이다. 최근 문서에 쌓아두지 말자.");
			return;
		}
		
		Map<String, Object> recentDocumentMap = new HashMap<String, Object>();
		recentDocumentMap.put("user_id", strUserid);
		recentDocumentMap.put("share_date", shareDate);
		recentDocumentMap.put("owner_id", strOwnerid);
		recentDocumentMap.put("owner_name", strOwnerName);
		//모바일 앱 cloud인 경우 때문에 추가
		recentDocumentMap.put("groupSeq", getDocumentMap.get("groupSeq")); 
		

		
		if (shareDate == null || strUserid.equals(strOwnerid) ) {
			recentDocumentMap.put("list_my", "1");
		} else {
			recentDocumentMap.put("list_share", "1");
		}
								
		List<Map<String,Object>> recentList  = (List<Map<String,Object>>)commonSql.list("OnefficeDao.getRecentDocumentForInsert", recentDocumentMap);
		
		//Insert
		boolean bUpdate = false;
        for (Map<String, Object> recentData : recentList) {
            String tempUserID = (String)recentData.get("user_id");
            String tempDocNo = (String)recentData.get("doc_no");
            
            if (tempUserID.equals(strUserid) && tempDocNo.equals(strDocNo)) {
            	//해당 data를 Update
            	recentDocumentMap.put("seq", recentData.get("seq"));
            	commonSql.update("OnefficeDao.updateRecentDocument", recentDocumentMap);
            	bUpdate = true;
            }
        }
        
        if (!bUpdate) {
        	recentDocumentMap.put("doc_no", strDocNo);
    		if (recentList.size() >= MAX_RECENT_DB_COLUMN) {
    			//Update
    			int nIndex = MAX_RECENT_DB_COLUMN-1;
    			Logger.getLogger( OnefficeController.class ).debug( "index = "+ nIndex + " seq : " +  recentList.get(nIndex).get("seq"));
    			recentDocumentMap.put("seq", recentList.get(nIndex).get("seq"));
    			commonSql.update("OnefficeDao.updateRecentDocument", recentDocumentMap);
    		}
    		else 
    		{
    	        commonSql.insert("OnefficeDao.insertRecentDocument", recentDocumentMap);
    		}
        }
		
	}
	
	private void shareOPAfterAccessInfo(Map<String, Object> paramMap) {
		// 편집 권한이 변경 되어 으면 accessinfo Data 값을 삭제를 하여 주자. 부서 & 링크 공유 & 개인별 공유 별로 처리를 해야 됨
		// 문서
		List<Map<String, Object>> writeAccessInfoList = (List<Map<String, Object>>) commonSql.list("OnefficeDao.getDocumentAccessInfoWrite", paramMap);
		if (writeAccessInfoList != null && writeAccessInfoList.size() >= 1) {
			
			Logger.getLogger( OnefficeController.class ).debug( "writeAccessInfoList.size() : " +  writeAccessInfoList.size());
			Logger.getLogger( OnefficeController.class ).debug( " writeAccessInfoList.get(0).access_id : " +   writeAccessInfoList.get(0).get("access_id"));

			//해당 access_id의 공유 정보를 가지고 오자
			
			Map<String, Object> deleteAccessMap = new HashMap<String, Object>();
			deleteAccessMap.put("empSeq", writeAccessInfoList.get(0).get("access_id"));
			deleteAccessMap.put("share_id", writeAccessInfoList.get(0).get("access_id"));
			deleteAccessMap.put("doc_no", paramMap.get("doc_no"));
			deleteAccessMap.put("access_perm", "W");
			
			Map<String, Object> shareDocument = (Map<String, Object>) commonSql.select("OnefficeDao.getShareDocument", deleteAccessMap);
			
			//공유된 정보가 없으면 AccessInfo data를 삭제 하자 
			if (shareDocument == null || shareDocument.get("share_perm").equals("R")) {
				commonSql.delete("OnefficeDao.accessDocument_1", deleteAccessMap);
			}
		}
		// 소유자가 공유
	}
	
	public ModelAndView OnefficeGetWebcontent(@RequestParam Map<String, Object> paramMap, HttpServletRequest request, HttpServletResponse res) throws Exception {
		
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");	
	
		Logger.getLogger( OnefficeController.class ).debug("OnefficeGetWebcontent Start");
		Logger.getLogger( OnefficeController.class ).debug("OnefficeGetWebcontent Params : " + paramMap);
		
		request.setCharacterEncoding("UTF-8");
		res.setContentType("text/html;charset=UTF-8");
		
		
		request.setCharacterEncoding("UTF-8");
		res.setContentType("text/html;charset=UTF-8");
		
		URL url = null;
		HttpURLConnection con = null;
		int timeOutValue = 10000;

		try {
			
			String accessUrl = paramMap.get("url").toString().trim();
			accessUrl = java.net.URLDecoder.decode(accessUrl, "UTF-8");

			String charSet = "utf-8";
			if(request.getParameter("charSet") != null) {
				charSet = request.getParameter("charSet").trim();
			}

			url = new URL(accessUrl);
			con = (HttpURLConnection)url.openConnection();
			con.setConnectTimeout(timeOutValue);
			con.setReadTimeout(timeOutValue);

			con.setRequestMethod("GET");
			int responseCode = con.getResponseCode();
			BufferedReader br;
			if(responseCode==200) {
				br = new BufferedReader(new InputStreamReader(con.getInputStream(),charSet));
			} else { 
				br = new BufferedReader(new InputStreamReader(con.getErrorStream(),charSet));
			}
			String inputLine;
			StringBuffer sb = new StringBuffer();
			while ((inputLine = br.readLine()) != null) {
				sb.append(inputLine);
			}
			br.close();

			String content = sb.toString();
			
			mv.addObject("result", "success");
			mv.addObject("data", content);
		}catch(Exception e){
			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
		}finally{
			if(con!=null) {//Null Pointer 역참조
				con.disconnect();
			}
		}
		
		Logger.getLogger( OnefficeController.class ).debug("OnefficeGetWebcontent end ");
		
		return mv;
	}
	
	/*
	@RequestMapping(value="/oneffice/oneffice_share_recovery_new.do", method={RequestMethod.GET, RequestMethod.POST})
	public void oneffice_share_recovery_new(Map<String, Object> paramMap, HttpServletRequest request, HttpServletResponse response) {
		LoginVO loginVO = checkLoginVO(request);
		BufferedWriter bWriter = null;
		ArrayList<String> strRecoveryList  = new ArrayList<String>();
		String strDirect = (String)paramMap.get("directUpdate");
		String execCode = (String)paramMap.get("exec");
		
		if(loginVO != null)
		{
	        try {
	        	
	        	Map<String, Object> execUserEnvMap = new HashMap<String, Object>();
	        	execUserEnvMap.put("empSeq", execCode);
	        	Map<String, Object> userEnvData = (Map<String, Object>) commonSql.select("OnefficeDao.getOnefficeUserEnv", execUserEnvMap);

	        	if (userEnvData == null) {
	        		Logger.getLogger( OnefficeController.class ).debug("oneffice_share_recovery_new auth fail ");
	        		return;
	        	}
	        	
	        	if ("Y".equals(userEnvData.get("user_agree")) == true ) {
	        		return;
	        	}
	        	
	    		paramMap.put("groupSeq", loginVO.getGroupSeq());
				paramMap.put("empSeq", loginVO.getUniqId());
				paramMap.put("langCode", loginVO.getLangCode());
				int nRunCnt = 0;
				String strCheckList = "";
				
		        bWriter = new BufferedWriter( new OutputStreamWriter( System.out ) );
		        
			
				@SuppressWarnings("unchecked")
				List<Map<String, Object>> result = (List<Map<String, Object>>) commonSql.list("OnefficeDao.onefficeShareRecoveryList", paramMap);
				Logger.getLogger( OnefficeController.class ).debug("OnefficeDao.onefficeShareRecoveryList size = " + result.size());
				for (int nIndex = 0 ; nIndex < result.size(); nIndex++) 
				{
					Map<String, Object> resultMap = result.get(nIndex);
					if (resultMap != null) {
						String shareDocNo = (String)resultMap.get("doc_no");
						String shareID = (String)resultMap.get("share_id");
						String shareType = (String)resultMap.get("share_type");
						String sharePerm = (String)resultMap.get("share_perm");
						
						
						Map<String, Object> newHistoryDocNo = new HashMap<String, Object>();
						newHistoryDocNo.put("groupSeq", loginVO.getGroupSeq());
						newHistoryDocNo.put("doc_no", shareDocNo);
						String unionshareID = "%"+shareID+"%";
						newHistoryDocNo.put("share_id", unionshareID);
						
										
						Map<String, Object> compareData = (Map<String, Object>) commonSql.select("OnefficeDao.findCompareShareData", newHistoryDocNo);
						if (compareData != null) {
							String strActionData = (String)compareData.get("action_data");
							strActionData = strActionData.replaceAll("}", "").replaceAll("\"", "");
							String[] splitCodes = strActionData.split(",");
							String change_share_type ="";
							String change_share_id = "";
							String change_share_perm = "";
							
							if (splitCodes[1].split(":").length > 1)
								change_share_type = splitCodes[1].split(":")[1];
		
							if (splitCodes[2].split(":").length > 1)
								change_share_id = splitCodes[2].split(":")[1];
							
							if (splitCodes[3].split(":").length > 1)
								change_share_perm = splitCodes[3].split(":")[1];
							
							if (change_share_id.length() == 0)
								continue;
		
							java.sql.Timestamp change_reg_date = (java.sql.Timestamp )compareData.get("reg_date");
							
							if (change_share_type.indexOf("0")> -1) {
								System.out.print(" shareType = " + shareType);
								System.out.print("| change_share_type = " + change_share_type);
								System.out.print("| sharePerm = " + sharePerm);
								System.out.print("| change_share_perm = " + change_share_perm);
								System.out.print("| change_share_type.indexOf(shareType) = " + change_share_type.indexOf(shareType));
								System.out.println("| change_share_perm.indexOf(sharePerm) = " + change_share_perm.indexOf(sharePerm));
								if (change_share_type.indexOf(shareType) < 0 || change_share_perm.indexOf(sharePerm) < 0)
								{
								  //공유 type이 틀리다 History에 있는 걸로 변경 하자.
									System.out.println("===============RECOVERY_UPDATE_START=====================");
									Map<String, Object> updateParamMap = new HashMap<String, Object>();
									updateParamMap.put("groupSeq", loginVO.getGroupSeq());
									updateParamMap.put("doc_no", shareDocNo);
									updateParamMap.put("share_id", shareID);
									updateParamMap.put("change_share_type", change_share_type);
									updateParamMap.put("change_share_perm", change_share_perm);
									updateParamMap.put("change_reg_date", change_reg_date);
									
									Map<String, Object> duplicateData = (Map<String, Object>) commonSql.select("OnefficeDao.getRecoveryShareCount", updateParamMap);
									
									if (duplicateData != null) {
										if ((long)duplicateData.get("cnt") > 1)
										{
											//수동체크 필요
											String tempData;
											tempData = "shareDocNo:"+shareDocNo+"share_id:"+ shareID;
											strCheckList += tempData + ",";
											continue;
										}
									}
									
									if (strDirect.equals("direct")) {
										commonSql.update("OnefficeDao.updateRecoveryShareDocument", updateParamMap);	
									}
									
									nRunCnt++;
									String strUpdate = "update oneffice_share set share_type = '" + change_share_type + "'" 
														+ ",share_perm = '" + change_share_perm + "'"
														+ ",share_date = '" + change_reg_date + "'"
														+ "where doc_no = '" + shareDocNo + "'"
														+ "and share_id = '" + shareID + "';";
									
									strRecoveryList.add(strUpdate);
									
									if ((nRunCnt % 1000) == 0 ) {
										String filePath = "recovery_"+nRunCnt+".sql";
										writeToFile(filePath, strRecoveryList);
										strRecoveryList.clear();
									}
									System.out.println("===============RECOVERY_UPDATE_END nRet = " + nRunCnt +" ===================== ");
								}
							}
						}
					}
				}
				String filePath = "recovery_"+nRunCnt+".sql";
				writeToFile(filePath, strRecoveryList);
				strRecoveryList.clear();
				Logger.getLogger( OnefficeController.class ).debug("OnefficeDao.errorList = " + strCheckList);
	        } finally {
	            try {
	                if(bWriter != null) bWriter.close();
	            } catch(IOException e) {
	                e.printStackTrace();
	            }
	        }
	
		}
	}
	
	private void writeToFile(String strRecoveryFile, ArrayList<String> strRecoveryList) {
		
		String filePath = "";
		String absolPath = "";
		
		Map<String, Object> paramMap = new HashMap<String, Object>();
		paramMap.put("pathSeq", "0");
		paramMap.put("osType", NeosConstants.SERVER_OS);
		Map<String, Object> pathMap = groupManageService.selectGroupPath(paramMap);
		
		if(pathMap != null){
			absolPath = pathMap.get("absolPath").toString();	
		}				
		
		filePath = absolPath + "/onefficeFile/recovery/" +  strRecoveryFile;
		
		Logger.getLogger( OnefficeController.class ).debug("writeToFile =  " + filePath);
		
        File file = new File(filePath);
        FileWriter writer = null;
        BufferedWriter bWriter = null; 
        
        try {
            writer = new FileWriter(file, true);
            bWriter = new BufferedWriter(writer);
            for (int i = 0 ; i < strRecoveryList.size() ; i++ ) {
            	bWriter.write(strRecoveryList.get(i));
            	bWriter.newLine();
            }
            
            bWriter.flush();
        } catch(IOException e) {
            e.printStackTrace();
        } finally {
            try {
                if(bWriter != null) bWriter.close();
                if(writer != null) writer.close();
            } catch(IOException e) {
                e.printStackTrace();
            }
        }
	}
	*/
}
