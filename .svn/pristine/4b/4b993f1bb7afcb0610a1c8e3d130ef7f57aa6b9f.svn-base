package main.web;
import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.Enumeration;
import java.util.GregorianCalendar;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.apache.log4j.Logger;
import org.codehaus.jackson.map.ObjectMapper;
import org.codehaus.jackson.type.TypeReference;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import bizbox.orgchart.service.vo.LoginVO;
import cloud.CloudConnetInfo;
import derp.interlock.controller.DerpInterlockController;
import egovframework.com.cmm.annotation.IncludedInfo;
import egovframework.com.cmm.util.EgovUserDetailsHelper;
import egovframework.com.sym.log.clg.service.EgovLoginLogService;
import egovframework.com.uat.uia.service.EgovLoginService;
import egovframework.com.utl.fcc.service.EgovStringUtil;
import main.service.MainService;
import neos.cmm.db.CommonSqlDAO;
import neos.cmm.menu.service.MenuManageService;
import neos.cmm.systemx.commonOption.service.CommonOptionManageService;
import neos.cmm.systemx.comp.service.CompManageService;
import neos.cmm.systemx.emp.service.EmpManageService;
import neos.cmm.systemx.etc.service.LogoManageService;
import neos.cmm.systemx.orgchart.service.OrgChartService;
import neos.cmm.systemx.secondCertificate.service.SecondCertificateService;
import neos.cmm.util.AESCipher;
import neos.cmm.util.BizboxAProperties;
import neos.cmm.util.CommonUtil;
import neos.cmm.util.HttpJsonUtil;
import net.sf.json.JSONObject;
import net.sf.json.JSONSerializer;

@Controller
public class BizboxIndexController {

	@Resource(name="MenuManageService")
	MenuManageService menuManageService;
	
	@Resource(name="EmpManageService")
	EmpManageService empManageService;
	
	@Resource(name="EgovLoginLogService")
	EgovLoginLogService egovLoginLogService;
	
	@Resource(name="loginService")
	EgovLoginService loginService;
	
	@Resource(name="OrgChartService")
	OrgChartService orgChartService;
	
	@Resource(name = "commonSql")
	private CommonSqlDAO commonSql;
	
	@Resource(name="MainService")
	MainService mainService;
	
	@Resource(name = "CompManageService")
	private CompManageService compManageService;
	
	@Resource(name="LogoManageService")
	private LogoManageService logoManageService;
	
    @Resource(name="CommonOptionManageService")
    private CommonOptionManageService commonOptionManageService;
    
    @Resource(name="SecondCertificateService")
    private SecondCertificateService SecondCertificateService;	
    
    private static Log logger = LogFactory.getLog(BizboxIndexController.class);
	
	@RequestMapping("/forwardIndex.do")
	public ModelAndView forwardIndex(@RequestParam Map<String,Object> params, HttpServletRequest request, HttpServletResponse response) throws Exception {
		
		ModelAndView mv = new ModelAndView();
		
		//GERP Session
		if(request.getSession().getAttribute("SetGerpSession") != null && request.getSession().getAttribute("SetGerpSession").equals("Y")){
			request.getSession().removeAttribute("SetGerpSession");
			mv.addObject("result : ","Session creation succeeded!");
			mv.setViewName("jsonView");
			return mv;
		}
		
		//DERP 로그아웃 처리
		if(DerpInterlockController.LogOutCheck) {
			DerpInterlockController.LogOutCheck = false;
			mv.setViewName("redirect:/derp/LogoutResult.do");
			return mv;
		}
		
	    Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();
	    String scUserPwd = (String) request.getSession().getAttribute("scUserPwd");
	    request.getSession().removeAttribute("scUserPwd");
	    

	    if(!isAuthenticated) {
	    	
	    	if(!BizboxAProperties.getCustomProperty("BizboxA.Cust.CustLogout").equals("99")) {
	    		mv.setViewName(BizboxAProperties.getCustomProperty("BizboxA.Cust.CustLogout"));
	    		return mv;
	    	}
	    	
	    	if(params.get("AccessIpFailMsg") != null) {
	    		mv.addObject("AccessIpFailMsg", "Y");
	    	}
	    	
	    	
	    	//이차인증 사용에따른 처리.
	        if(params.get("ScTargetEmpSeq") != null){	        	
	        	mv.addObject("ScTargetEmpSeq", params.get("ScTargetEmpSeq"));
	        	mv.addObject("seq", params.get("seq"));
	        	mv.addObject("qrData", params.get("qrData"));
	        	mv.addObject("type", params.get("type"));
	        	mv.addObject("scGroupSeq", params.get("scGroupSeq"));
	        	mv.addObject("scUserId", params.get("scUserId"));
	        	mv.addObject("scUserPwd", params.get("scUserPwd"));
	        }
	        
	        //중복로그인 처리 메세지 셋팅
	        if(params.get("maxSessionOut") != null && params.get("maxSessionOut").equals("Y")) {
	        	request.getSession().setAttribute("maxSessionOut", "Y");
	        }else {
	        	request.getSession().removeAttribute("maxSessionOut");
	        }
	        
	    	mv.setViewName("redirect:/uat/uia/egovLoginUsr.do");
	    	return mv;
	    	
	    }
	    
	    LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
	    	
	    String userSe = loginVO.getUserSe();

	    String port = request.getServerPort() + "";
	    
	    	
	    String path = "";

	    if(request.isSecure()) {
	    	path = request.getScheme() + "://"+request.getServerName()+":"+port+request.getContextPath();
	    }
	    
	    //로그인 통제IP조회
	    if(loginVO != null) {
	    	boolean accessFlag = true;
	    	Map<String, Object> paraMap = new HashMap<String, Object>();
	    	paraMap.put("empSeq", loginVO.getUniqId());
	    	paraMap.put("groupSeq", loginVO.getGroupSeq());
	    	List<Map<String, Object>> empInfoList = commonSql.list("EmpManage.getEmpInfoListAccess", paraMap);
	    	
	    	String compList = "";
	    	String chkCompList = "";
	    	String compSeqList = "";
	    	
	    	
	    	for(Map<String, Object> mp : empInfoList){
	    		if(mp.get("mainDeptYn").toString().equals("Y")){
	    			compList += "," + mp.get("compSeq"); 
	    			chkCompList += "," + mp.get("compSeq");
	    		}
	    		compSeqList += ",'" + mp.get("compSeq") + "'";
	    	}
	    	if(compList.length() > 0 ) {
	    		compList = compList.substring(1);
	    	}
	    	if(compSeqList.length() > 0) {
	    		compSeqList = compSeqList.substring(1);
	    	}
	    	if(chkCompList.length() > 0) {
	    		chkCompList = chkCompList.substring(1);
	    	}
	    	
	    	paraMap.put("groupSeq", loginVO.getGroupSeq());
	    	paraMap.put("compSeqList", compSeqList);
	    	List<Map<String, Object>> compAccessIpList = commonSql.list("AcessManage.compAccessIpList", paraMap);
	    		
		    	if(compAccessIpList.size() > 0){
		    		
		    		List<Map<String, Object>> checkIpList = new ArrayList<Map<String, Object>>();
		    		
		    		for(Map<String, Object> empMap : empInfoList){
			    		for(Map<String, Object> mp : compAccessIpList){
			    			if(mp.get("gbnOrg").toString().equals("c")){
			    				if(empMap.get("compSeq").toString().equals(mp.get("compSeq").toString())){
			    					Map<String, Object> ipMap = new HashMap<String, Object>();
			    					ipMap.put("startIp", mp.get("startIp"));
			    					ipMap.put("endIp", mp.get("endIp"));
			    					checkIpList.add(ipMap);
			    				}
			    			}else if(mp.get("gbnOrg").toString().equals("d")){
			    				Map<String, Object> ipMap = new HashMap<String, Object>();
			    				if(mp.get("path") != null && !mp.get("path").toString().equals("")){
			    					String checkPath = "|" + empMap.get("path") + "|";
			    					if(empMap.get("compSeq").toString().equals(mp.get("compSeq").toString()) && checkPath.indexOf("|" + mp.get("path") + "|") != -1){
			    						ipMap.put("startIp", mp.get("startIp"));
				    					ipMap.put("endIp", mp.get("endIp"));
				    					checkIpList.add(ipMap);
			    					}
			    				}
			    				else{
				    				if(empMap.get("compSeq").toString().equals(mp.get("compSeq").toString()) && empMap.get("deptSeq").toString().equals(mp.get("deptSeq").toString())){				    					
				    					ipMap.put("startIp", mp.get("startIp"));
				    					ipMap.put("endIp", mp.get("endIp"));
				    					checkIpList.add(ipMap);
				    				}	
			    				}
			    			}else if(mp.get("gbnOrg").toString().equals("u")){
			    				if(empMap.get("compSeq").toString().equals(mp.get("compSeq").toString()) && empMap.get("deptSeq").toString().equals(mp.get("deptSeq").toString()) && empMap.get("empSeq").toString().equals(mp.get("empSeq").toString())){
			    					Map<String, Object> ipMap = new HashMap<String, Object>();
			    					ipMap.put("startIp", mp.get("startIp"));
			    					ipMap.put("endIp", mp.get("endIp"));
			    					checkIpList.add(ipMap);
			    				}
			    			}
			    		}
		    		}
		    				    		
		    		int successCnt = 0;
		    		for(Map<String, Object> mp : checkIpList){
		    			String startIp = mp.get("startIp") + "";
		    			String endIp = mp.get("endIp") + "";
		    			
		    			String[] ipTemp = startIp.split("\\.");
		    			Long startIpLong = (Long.parseLong(ipTemp[0]) << 24) + (Long.parseLong(ipTemp[1]) << 16) + (Long.parseLong(ipTemp[2]) << 8) + Long.parseLong(ipTemp[3]);
		    			ipTemp = endIp.split("\\.");
		    			Long endIpLong = (Long.parseLong(ipTemp[0]) << 24) + (Long.parseLong(ipTemp[1]) << 16) + (Long.parseLong(ipTemp[2]) << 8) + Long.parseLong(ipTemp[3]);
		    			ipTemp = CommonUtil.getClientIp(request).split("\\.");
		    			Long connectIp = (Long.parseLong(ipTemp[0]) << 24) + (Long.parseLong(ipTemp[1]) << 16) + (Long.parseLong(ipTemp[2]) << 8) + Long.parseLong(ipTemp[3]);
		    			
		    			if(connectIp >= startIpLong && connectIp <= endIpLong){
		    				successCnt++;
		    			}
		    		}
		    		if(successCnt > 0) {
		    			accessFlag = true;
		    		}
		    		else {
		    			accessFlag = false;
		    		}
		    		
		    		if(checkIpList.size() == 0) {
		    			accessFlag = true;
		    		}
		    	}
	    	
	    	
	    	if(accessFlag){
	    		logger.debug("IP Access SUCCESS");
	    	}else{
	    		if(!BizboxAProperties.getCustomProperty("BizboxA.Cust.CustLogout").equals("99")) {
		    		mv.setViewName(BizboxAProperties.getCustomProperty("BizboxA.Cust.CustLogout"));
		    		return mv;
		    	}
	    		mv.addObject("AccessIpFailMsg", "Y");
		    	mv.setViewName("redirect:/uat/uia/egovLoginUsr.do");
	        	request.getSession().invalidate();
		    	return mv;
	    	}
	    }
	    
	    Map<String, Object> para = new HashMap<String, Object>();
	    para.put("empSeq", loginVO.getUniqId());
	    Map<String,Object> mainCompSeq = (Map<String, Object>) commonSql.select("EmpManage.getEmpMainCompSeq", para);

	    Map<String,Object> ssoLinkInfo = (Map<String,Object>)request.getSession().getAttribute("ssoLinkInfo");
	    Map<String,Object> extLinkInfo = (Map<String,Object>)request.getSession().getAttribute("extLinkInfo");
	    Map<String,Object> enpassLinkInfo = (Map<String,Object>)request.getSession().getAttribute("enpassLinkInfo");
	    Map<String,Object> outerLinkInfo = (Map<String,Object>)request.getSession().getAttribute("outerLinkInfo");
	    Map<String,Object> fmInfo = (Map<String,Object>)request.getSession().getAttribute("fmInfo");
	    Map<String,Object> outProcessInfo = (Map<String,Object>)request.getSession().getAttribute("outProcessInfo");
	    String onefficeInfo = (String)request.getSession().getAttribute("onefficeInfo");
	    String custPortletYn = (String)request.getSession().getAttribute("custPortlet");
	    String derpProssLogOnYn = (String)request.getSession().getAttribute("derpProssLogOnYn");
	    	    
	    String passwdParentOption = commonOptionManageService.getCommonOptionValue(loginVO.getGroupSeq(), loginVO.getCompSeq(), "cm200");
	    Boolean passCheck = false;
	    
	    //최초 로그인정보 입력 후 Forward 여부
	    Boolean firstLoginYn = false;
	    
	    if(request.getSession().getAttribute("firstLoginYn") != null && request.getSession().getAttribute("firstLoginYn").equals("Y")){
	    	firstLoginYn = true;
	    	request.getSession().removeAttribute("firstLoginYn");
	    }
	    
	    if(params.get("passwdNext") != null && params.get("passwdNext").equals("Y") && request.getSession().getAttribute("passwdAertYn") != null && request.getSession().getAttribute("passwdAertYn").equals("Y")){
	    	
		    //패스워드 다음에 변경
	    	request.getSession().removeAttribute("passwdAertYn");
	    	
	    }else if(firstLoginYn && (passwdParentOption.equals("1") || loginVO.getPasswdStatusCode().equals("I") || loginVO.getPasswdStatusCode().equals("R"))) {
	    	
		    /* 비밀번호 설정규칙 값 추가 */
			/*
			 * I : 최초로그인
			 * C : 옵션 변경
			 * P : 통과
			 * D : 만료기간 
			 * T : 패스워드변경알림완료
			 * R : 패스워드초기화
			 * */	    	
	    	
	    	if(loginVO.getPasswdStatusCode().equals("R") || loginVO.getPasswdStatusCode().equals("I") || loginVO.getPasswdStatusCode().equals("D") || loginVO.getPasswdStatusCode().equals("T")) {
	    		
	    		if(loginVO.getPasswdStatusCode().equals("T")){
	    			request.getSession().setAttribute("loginPasswdStatusCode", "T");
	    			request.getSession().setAttribute("passwdAertYn", "Y");	    			
	    		}
	    	
	    		passCheck = true;
	    		
	    	}else{
	    		
		    	String cm201Val = commonOptionManageService.getCommonOptionValue(loginVO.getGroupSeq(), loginVO.getCompSeq(), "cm201");
		    	
		    	String inputDueOptionValue = "";
		    	String passwdAlertOption = "0";
			    String passwdChangeOption = "0";
				
				if(cm201Val != null){
					
    				if(cm201Val.split("▦").length > 1) {
    					inputDueOptionValue = cm201Val.split("▦")[0];
    					cm201Val = cm201Val.split("▦")[1];
    				}					
					
					//안내기간, 만료기간 고도화 처리 (수정예정)
					String[] cm201Array = cm201Val.split("\\|");
					
					if(cm201Array.length > 1){
						passwdAlertOption = cm201Array[0];
						passwdChangeOption = cm201Array[1];
					}else{
						passwdChangeOption = cm201Array[0];
					}
				}
				
		    	if((!passwdAlertOption.equals("0") || !passwdChangeOption.equals("0")) && (loginVO.getPasswdStatusCode().equals("P") || loginVO.getPasswdStatusCode().equals("C"))) {
		    		
		    		boolean dueYn = false;
		    		boolean alertYn = false;
		    		boolean noticeYn = false;
		    		
		    		if(inputDueOptionValue.equals("m")) {
		    			
		    			Calendar calendar = Calendar.getInstance();
		    			int year = calendar.get(calendar.YEAR);
		    			int month = calendar.get(calendar.MONTH)+1;
		    			int day = calendar.get(calendar.DAY_OF_MONTH);
		    			int lastDay = calendar.getActualMaximum(Calendar.DATE);
		    			int setDay = Integer.parseInt(passwdAlertOption);
		    			
		    			if(lastDay < setDay) {
		    				setDay = lastDay;
		    			}
		    			
		    			SimpleDateFormat transFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		    			String compareToday = "";
		    			
		    			if(day < setDay) {
		    				
			    			int yearPrev = month == 1 ? year-1 : year;
			    			int monthPrev = month == 1 ? 12 : month-1;
		    				int setDayPrev = Integer.parseInt(passwdAlertOption);
			    			
		    				Calendar prevCal = new GregorianCalendar(year,monthPrev-1 ,1);
		    				lastDay = prevCal.getActualMaximum(prevCal.DATE);
		    				
			    			if(lastDay < setDayPrev) {
			    				setDayPrev = lastDay;
			    			}	    				
		    				
		    				compareToday = yearPrev + "-" + (monthPrev < 10 ? "0" : "") + monthPrev + "-" + (setDay < 10 ? "0" : "") +  + setDayPrev + " 00:00:00";
		    				
		    			}else {
		    				compareToday = year + "-" + (month < 10 ? "0" : "") + month + "-" + (setDay < 10 ? "0" : "") +  + setDay + " 00:00:00";
		    			}
			    		
			    		String passChangeDate = loginVO.getPasswdChangeDate();

			    		Date todayDate = transFormat.parse(compareToday);
			    		Date changeDate = transFormat.parse(passChangeDate);
			    		
			    		if(changeDate.compareTo(todayDate) == -1) {
			    			
			    			dueYn = true;
			    			
			    		}else {
			    			//만료도래알림
			    			Calendar nowCal = new GregorianCalendar(year,month,day);
			    			Calendar nextCal = new GregorianCalendar(year,month,setDay);
			    			
			    			if(day >= setDay) {
			    				
			    				if(month == 12) {
			    					year += 1;
			    					month = 1;
			    				}else {
			    					month += 1;
			    				}
			    				
			    				nextCal.set(year, month, 1);
			    				
			    				lastDay = nextCal.getActualMaximum(nextCal.DATE);
			    				setDay = Integer.parseInt(passwdAlertOption);
			    				
				    			if(lastDay < setDay) {
				    				setDay = lastDay;
				    			}
				    			nextCal.set(year, month, setDay);
			    			}
			    			
				    		// 시간차이를 시간,분,초를 곱한 값으로 나누면 하루 단위가 나옴
				    		long diff = (nextCal.getTimeInMillis() - nowCal.getTimeInMillis()) / 1000;
				    		long diffDays = diff / (24 * 60 * 60);
				    		
				    		setDay = Integer.parseInt(passwdChangeOption);
				    		
				    		if(diffDays <= setDay) {
				    			noticeYn = true;	
				    		}
			    		}
		    			
		    		}else {
		    			
			    		Date today = new Date();
			    		SimpleDateFormat transFormat = new SimpleDateFormat("yyyy-MM-dd");
			    		String compareToday = transFormat.format(today);
			    		String passChangeDate = loginVO.getPasswdChangeDate();

			    		Date todayDate = transFormat.parse(compareToday);
			    		Date changeDate = transFormat.parse(passChangeDate);
			    		
			    		long diffDays = (todayDate.getTime() - changeDate.getTime()) / (24*60*60*1000);
			    		
			    		if(!passwdChangeOption.equals("0") && diffDays >= Long.parseLong(passwdChangeOption)) {
			    			dueYn = true;
			    		}else if(!loginVO.getPasswdStatusCode().equals("T") && !passwdAlertOption.equals("0") && diffDays >= Long.parseLong(passwdAlertOption)) {
			    			request.getSession().setAttribute("passwdChangeOptionText", (Long.parseLong(passwdChangeOption) - diffDays));
			    			alertYn = true;
			    		}
		    			
		    		}
		    		
		    		//만료되지 않고 설정변경일 경우 처리
		    		if(loginVO.getPasswdStatusCode().equals("C") && !dueYn) {
		    			alertYn = false;
		    			noticeYn = false;
		    		}
		    		
		    		if(dueYn){
		    			request.getSession().setAttribute("loginPasswdStatusCode", "D");
		    			params.put("passwdStatusCode", "D");
		    			passCheck = true;
		    		}else if(alertYn){
		    			request.getSession().setAttribute("loginPasswdStatusCode", "T");
		    			request.getSession().setAttribute("passwdAertYn", "Y");
		    			params.put("passwdStatusCode", "T");
		    			passCheck = true;
		    		}else if(noticeYn) {
		    			request.getSession().setAttribute("loginPasswdStatusCode", "N");
		    			request.getSession().setAttribute("passwdAertYn", "Y");
		    			params.put("passwdStatusCode", "N");
		    			passCheck = true;
		    		}
		    		
		    		if(passCheck){
		    			params.put("empSeq", loginVO.getUniqId());
		    			commonOptionManageService.changeEmpPwdDate(params);	    			
		    		}
		    	}	    		
	    	}
	    	
	    	if(!passCheck && loginVO.getPasswdStatusCode().equals("C")) {
	    		passCheck = true;
	    	}
	    	
	    }
	    
	    
	    //이차인증 사용여부 및 세부옵션값 조회.
	    Map<String, Object> paraMp = new HashMap<String, Object>();	    
	    paraMp.put("groupSeq", loginVO.getGroupSeq());
	    paraMp.put("empSeq", loginVO.getUniqId());
	    Map<String, Object> secondCertInfo = (Map<String, Object>) commonSql.select("SecondCertManage.getSecondCertOptionValue", paraMp);	    
	    Map<String, Object> scPinINfo = (Map<String, Object>) commonSql.select("SecondCertManage.getUserPinInfo", paraMp);
	    
	    if (ssoLinkInfo != null){
	    	
	    	String urlGubun = (String) ssoLinkInfo.get("urlGubun");
	    	if (urlGubun.toLowerCase().equals("main")) {
	    		mv.setViewName("redirect:"+path+"/userMain.do");
	    		request.getSession().setAttribute("ssoLinkInfo", null);
	    	}
	    	else if(urlGubun.equals("sessionRedirect")){
	    		mv.setViewName("redirect:"+ ssoLinkInfo.get("url"));
	    		request.getSession().setAttribute("ssoLinkInfo", null);
	    		return mv;
	    	}
	    	else{
	    		mv.setViewName("redirect:"+path+"/bizboxSSO.do");
	    	}
	    }
	    else if (extLinkInfo != null){
			String urlGubun = (String) extLinkInfo.get("urlGubun");
	    	if (urlGubun.toLowerCase().equals("main")) {
	    		mv.setViewName("redirect:"+path+"/userMain.do");
	    	}
	    	else{
	    		if (urlGubun.toLowerCase().equals("none")) {
	    			mv.setViewName("redirect:"+extLinkInfo.get("popUrl"));
	    			
	    			request.getSession().setAttribute("extLinkInfo", null);
	    		}
	    		else {
	    			mv.setViewName("redirect:"+path+"/bizboxExt.do");
	    		}
	    	}
	    }
	    else if (enpassLinkInfo != null){
			String popYn = (String) enpassLinkInfo.get("popYn");
	    	if (popYn.equals("Y")) {
    			mv.setViewName("redirect:"+enpassLinkInfo.get("popUrl"));
    		}
    		else {
    			mv.setViewName("redirect:"+path+"/bizboxSW.do");
	    	}
			
	    }
	    else if (fmInfo != null){
			mv.setViewName("redirect:"+path+"/bizboxFM.do");
	    }
	    else if (outProcessInfo != null){
			mv.setViewName("redirect:"+path+"/bizboxOut.do");
	    }
	    else if (outerLinkInfo != null){
	    	mv.setViewName("redirect:"+path+"/bizboxOuter.do");
	    }else if (request.getSession().getAttribute("outLogOn") != null && request.getSession().getAttribute("outLogOn").toString().equals("Y")){
	    	mv.setViewName("redirect:"+path+"/bizboxOutLogOn.do");
	    }	    
	    //이차인증 처리
	    else if(secondCertInfo != null && secondCertInfo.get("useYn").equals("Y") && secondCertInfo.get("scUseYn").equals("Y") && request.getSession().getAttribute("ScTargetEmpSeq") == null && (request.getHeader("referer") != null && (request.getHeader("referer").indexOf("egovLoginUsr.do") != -1 || request.getHeader("referer").indexOf("actionLogin.do") != -1)) && request.getSession().getAttribute("masterLogon") == null){	    	
	    	paraMp.put("type", "L");
	    	paraMp.put("devType", "1");
	    	Map<String, Object> result = SecondCertificateService.setQrCodeInfo(paraMp);
	    	
	    	if(result != null){
	    		mv.addObject("ScTargetEmpSeq", loginVO.getUniqId());
	    		mv.addObject("seq", result.get("seq"));
	    		mv.addObject("qrData", result.get("qrData"));
	    		mv.addObject("type", result.get("type"));
	    		mv.addObject("scGroupSeq", loginVO.getGroupSeq());
	    		mv.addObject("scUserId",loginVO.getId());
	    		mv.addObject("scUserPwd",scUserPwd);
	    		
	    	}
	    	mv.setViewName("redirect:/uat/uia/egovLoginUsr.do");
	    }
	    else{
	    	if(onefficeInfo != null) {
		    	mv.setViewName("redirect:/oneffice/oneffice.do?" + onefficeInfo);
	    		request.getSession().setAttribute("onefficeInfo", null);
	    		return mv;
		    }
	    	
		    if (EgovStringUtil.isEmpty(userSe) || userSe.equals("USER")) {
		    	mv.setViewName("redirect:"+path+"/userMain.do");
		    } 
		    else if (userSe.equals("ADMIN")) {
		    	mv.setViewName("redirect:"+path+"/adminMain.do");
		    }
		    else if (userSe.equals("MASTER")) {
		    	mv.setViewName("redirect:"+path+"/masterMain.do");
		    }
		    else {
		    	mv.setViewName("redirect:"+path+"/userMain.do");
		    }
	    }
		// 메일전용 계정이면
		if(loginVO.getLicenseCheckYn() != null){

			if(loginVO.getLicenseCheckYn().equals("2")){
				mv.setViewName("redirect:bizboxMailEx.do");
			}
		}
		
		if(mainCompSeq.get("mainCompLoginYn").toString().equals("N") && request.getSession().getAttribute("isLoginPage") != null){
			request.getSession().removeAttribute("isLoginPage");
			mv.addObject("empSeq", loginVO.getUniqId());
			mv.setViewName("redirect:bizboxSelectPosition.do");
	    }
		
		if(passCheck) {
			mv.setViewName("redirect:bizboxPasswdChange.do");
		}
		
		if(custPortletYn != null){			
			String url = (String) request.getSession().getAttribute("url");
			request.getSession().setAttribute("custPortlet", null);
			request.getSession().setAttribute("url", null);
			mv.setViewName("redirect:"+path+"/"+url);
	    }	
		
		if(derpProssLogOnYn != null && derpProssLogOnYn.equals("Y")){			
			request.getSession().setAttribute("derpProssLogOnYn", null);
			mv.setViewName("redirect:/derp/forwardIndex.do");
			return mv;
	    }
		
		//자동출퇴근 옵션 처리
		if(mv.getViewName().indexOf("/userMain.do") > -1 && request.getSession().getAttribute("autoAttOptionCheck") == null){
			Map<String, Object> paraMap = new HashMap<String, Object>();
			paraMap.put("compSeq", loginVO.getOrganId());
			paraMap = (Map<String, Object>) commonSql.select("MainManageDAO.getAutoAttOptionInfo", paraMap);
			
			if(paraMap != null && paraMap.get("val3") != null && paraMap.get("val3").toString().equals("Y")){
				Date date = new Date();
	  			Calendar calendar = new GregorianCalendar();
	  			calendar.setTime(date);
	  			int year = calendar.get(Calendar.YEAR);
	  			int month = calendar.get(Calendar.MONTH) + 1;
	  			int day = calendar.get(Calendar.DAY_OF_MONTH);	  			
	  			String sToDay = Integer.toString(year) + (month < 10 ? "0" + Integer.toString(month) : Integer.toString(month)) + (day < 10 ? "0" + Integer.toString(day) : Integer.toString(day));
	  			
	  			Map<String, Object> mp = new HashMap<String, Object>();
	  			mp.put("sToDay", sToDay);
	  			mp.put("empSeq", loginVO.getUniqId());
	  			mp.put("compSeq", loginVO.getOrganId());
	  			mp.put("deptSeq", loginVO.getOrgnztId());
	  			mp.put("groupSeq", loginVO.getGroupSeq());
	  			
	  			String empCheckWorkYn = (String) commonSql.select("Empmanage.getEmpCheckWorkYn", mp);
	  			String empCheckJoinDay = (String) commonSql.select("Empmanage.getEmpCheckJoinDay", mp);
	  			
	  			if(empCheckWorkYn.equals("Y") && !empCheckJoinDay.equals("0")){
  					Map<String, Object> empAttInfo = (Map<String, Object>) commonSql.select("Empmanage.getEmpComAttInfo",mp);
  					if(empAttInfo == null){
  						request.getSession().setAttribute("empAttCheckFlag", "Y");
  					}else{
  						if(empAttInfo.get("comeDt").toString().length() == 0){
  							request.getSession().setAttribute("empAttCheckFlag", "Y");
  						}
  					}
  				}
	  				   			  			  	
			}
			request.getSession().setAttribute("autoAttOptionCheck", "Y");
		}
		
	    return mv;
	}
	
    private Map<String, String> getHeadersInfo(HttpServletRequest request) {

        Map<String, String> map = new HashMap<String, String>();

        Enumeration headerNames = request.getHeaderNames();
        while (headerNames.hasMoreElements()) {
            String key = (String) headerNames.nextElement();
            String value = request.getHeader(key);
            map.put(key, value);
        }

        return map;
    }    
	
	
	@IncludedInfo(name="레이아웃", order = 16 ,gid = 0)
	@RequestMapping("/bizbox.do")
	public ModelAndView bizbox(@RequestParam Map<String,Object> params, HttpServletRequest request) throws Exception {
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		
		ModelAndView mv = new ModelAndView();
		
		if(request.getSession().getAttribute("loginVO") == null) {
    		//세션이 만료되었을 경우 로그저장 
    		String requestedSessionId = request.getRequestedSessionId();
    		logger.debug("[sessionInfo] there's no request session id : " + requestedSessionId + "headerInfo > " + getHeadersInfo(request).toString());			
			mv.setViewName("redirect:/uat/uia/egovLoginUsr.do");	
			return mv;
		}
		
		Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();
		
		if(!isAuthenticated) {
			mv.setViewName("redirect:/uat/uia/egovLoginUsr.do");
			return mv;
		}
		
		// 메뉴 정보가 없으면 메인으로 이동
		String no = params.get("no")+"";
		if(EgovStringUtil.isEmpty(no)) {
			
			mv.setViewName("redirect:/forwardIndex.do");
			
			return mv;
			
		}
		
		params.put("compSeq", loginVO.getCompSeq());
		
		/** 메인 하단 푸터 이미지,Text 가져오기*/
		if(!loginVO.getUserSe().equals("MASTER")){
			//메인 하단 푸터 이미지.
			params.put("imgType", "IMG_COMP_FOOTER");
			Map<String,Object> imgMap = compManageService.getOrgImg(params);
			mv.addObject("imgMap", imgMap);

			//메인 하단 푸터 텍스트
			params.put("imgType", "TEXT_COMP_FOOTER");
			Map<String,Object> txtMap = compManageService.getOrgImg(params);
			mv.addObject("txtMap", txtMap);
		}

		mv.setViewName("/main/sub/bizbox");
	    mv.addObject("userSe", loginVO.getUserSe());
	    mv.addObject("params", params);		
		
	    /** 메인 하단 푸터 버튼 가져오기(포털id)*/
		@SuppressWarnings("unchecked")
		Map<String, Object> portalInfo = (Map<String, Object>) commonSql.select("CompManage.getPortalId", params);
		
		if(portalInfo != null){
			mv.addObject("portalId", portalInfo.get("portalId"));
			mv.addObject("portalDiv", portalInfo.get("portalDiv"));
			
			if(portalInfo.get("portalDiv").equals("cloud")){
				mv.setViewName("/main/sub/bizboxCloud");
				mv.addObject("topMenuList", mainService.getTopMenuList(loginVO));
			}
		}
		
		return mv;
	}

	@RequestMapping("/bizboxMail.do")
	public ModelAndView bizboxMail(@RequestParam Map<String,Object> params, HttpServletRequest request) throws Exception {
		
		//System.out.println(params);
		ModelAndView mv = new ModelAndView();
		
		Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();
		
		if(!isAuthenticated || request.getSession().getAttribute("loginVO") == null) {
			mv.setViewName("redirect:/uat/uia/egovLoginUsr.do");
			return mv;
		}
		
		if(params == null || params.size() == 0) {
			mv.setViewName("redirect:/bizbox.do");
			return mv;			
		}
		
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		
		Logger.getLogger( BizboxIndexController.class ).debug( "menuMailInfo  session : " + request.getRequestedSessionId());
		Logger.getLogger( BizboxIndexController.class ).debug( "menuMailInfo  loginVO : " + loginVO );
		
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("groupSeq", loginVO.getGroupSeq());
		mp.put("compSeq", loginVO.getCompSeq());
		
		if(BizboxAProperties.getCustomProperty("BizboxA.Cust.MailUrlDef").equals("Y") && params.get("urlGubun").equals("mail")) {
			
			params.put("url", "/mail2/?ssoType=GW");
			
		}else {
			
			Map<String, Object> groupInfo = (Map<String, Object>) commonSql.select("GroupManage.getGroupInfo", mp);
			
			//비상교육 메일서버 분리로 인한 특이케이스 대응 외부서버 메일 url주소 컬럼 추가 (t_co_group - > ex_mail_url)
			//해당기능 필요한 고객사에만 컬럼 추가예정.
			if(params.get("urlGubun") != null && params.get("urlGubun").toString().equals("adminMail") && groupInfo.get("exMailUrl") != null && !groupInfo.get("exMailUrl").toString().equals("")){
				String mailUrl = params.get("url") + "";
				String[] arrUrl = mailUrl.split("/");
				String url = arrUrl[arrUrl.length -1] + "/";
				url = groupInfo.get("exMailUrl") + url;
				params.put("url", url);
			}else{
				if(loginVO.getUrl() != null && !loginVO.getUrl().equals("")){
					String compMailUrl = loginVO.getUrl();
					String mailUrl = params.get("url") + "";
					if(mailUrl.contains("/mail2/")){
						mailUrl = compMailUrl + mailUrl.substring(mailUrl.indexOf("/mail2/") + 7);
						params.put("url", mailUrl);
					}else if(mailUrl.contains("/mailAdmin/")){
						mailUrl = compMailUrl.replace("/mail2/", "") + "/mailAdmin/";
						params.put("url", mailUrl);
					}else if(mailUrl.contains("/approvalMail/")){
						mailUrl = compMailUrl.replace("/mail2/", "") + "/approvalMail/";
						params.put("url", mailUrl);
					}				
				}
			}
			
		}
		
		mv.setViewName("/main/mail/bizboxMail");
		
		/** 메인 하단 푸터 버튼 가져오기(포털id) */
		@SuppressWarnings("unchecked")
		Map<String, Object> portalInfo = (Map<String, Object>) commonSql.select("CompManage.getPortalId", mp);
		
		if(portalInfo != null){
			mv.addObject("portalId", portalInfo.get("portalId"));
			mv.addObject("portalDiv", portalInfo.get("portalDiv"));
			
			if(portalInfo.get("portalDiv").equals("cloud")){
				mv.setViewName("/main/mail/bizboxCloudMail");
				mv.addObject("topMenuList", mainService.getTopMenuList(loginVO));
			}		
		}
		
		mv.addObject("params", params);
		mv.addObject("topType", "mail");
		
		return mv;
	}
	
	@RequestMapping("/bizboxMailEx.do")
	public ModelAndView bizboxMailEx(@RequestParam Map<String,Object> params, HttpServletRequest request) throws Exception {
		
		//System.out.println(params);
		ModelAndView mv = new ModelAndView();
		
		Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();
		
		if(!isAuthenticated) {
			
			mv.setViewName("redirect:/uat/uia/egovLoginUsr.do");
			
			return mv;
			
		}
		
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		
		String compMailUrl = "";
		
		Map<String, Object> mailInfo = new HashMap<String, Object>();
		
		mailInfo.put("groupSeq", loginVO.getGroupSeq());
		mailInfo.put("compSeq", loginVO.getCompSeq());
		mailInfo.put("compAccessDomain", request.getServerName() + (request.getServerPort() == 80 ? "" : ":" + request.getServerPort()));
		
		if(loginVO.getUrl() != null && !loginVO.getUrl().equals("")){
			compMailUrl = loginVO.getUrl();
			
			if(compMailUrl.contains("/mail2/")){
				compMailUrl = compMailUrl + "?ssoType=GW";
			}			
		}
		
		if(BizboxAProperties.getCustomProperty("BizboxA.Cust.MailLayoutOnly").equals("Y")) {
			mv.setViewName("redirect:" + compMailUrl);
		}else{
			
			Map<String,Object> optionObject = new HashMap<String,Object>();
			String optionObjectStr = "1-1";
			params.put("optionList", "'cm850'");
			params.put("compSeq", loginVO.getCompSeq());
			optionObject = commonOptionManageService.getGroupOptionList(params);
			
			if(optionObject.get("cm850") != null){
				optionObjectStr = optionObject.get("cm850").toString();
			}
			
			if(optionObjectStr.contains("1-1")){
				mv.addObject("orgBtn", "Y");
			}else{
				mv.addObject("orgBtn", "N");	
			}
			
			mv.addObject("mailUrl", compMailUrl);		
			mv.addObject("params", params);
			mv.addObject("topType", "mailex");
			
			mv.setViewName("/main/mail/bizboxMailEx");			
		}
		
		return mv;
	}
	
	@RequestMapping("/bizboxPasswdChange.do")
	public ModelAndView bizboxPasswdChange(@RequestParam Map<String,Object> params, RedirectAttributes redirectAttributes) throws Exception {
		
		//System.out.println(params);
		ModelAndView mv = new ModelAndView();

		redirectAttributes.addFlashAttribute("passwdChange", "Y");
		mv.setViewName("redirect:/uat/uia/egovLoginUsr.do");
		
		return mv;
	}
	
	@RequestMapping("/bizboxSelectPosition.do")
	public ModelAndView bizboxSelectPosition(@RequestParam Map<String,Object> params, RedirectAttributes redirectAttributes) throws Exception {	
		ModelAndView mv = new ModelAndView();

		redirectAttributes.addFlashAttribute("selectPosition", "Y");
		redirectAttributes.addFlashAttribute("empSeq", params.get("empSeq"));
		mv.setViewName("redirect:/uat/uia/egovLoginUsr.do");
		
		return mv;
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping("/bizboxSSO.do")
	public ModelAndView bizboxSSO(@RequestParam Map<String,Object> param, HttpServletRequest request, HttpServletResponse response) throws Exception {
		
		ModelAndView mv = new ModelAndView();
		
		Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();

		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		
		if(!isAuthenticated) {
			
			mv.setViewName("redirect:/uat/uia/egovLoginUsr.do");
			
			return mv;
			
		}

		Map<String, Object> params = (Map<String,Object>)request.getSession().getAttribute("ssoLinkInfo");
		
		if(params != null) {
			String linkType = (String) params.get("linkType");
			String urlGubun = (String) params.get("urlGubun");
			String eventType = (String) params.get("eventType");
			String eventSubType = (String) params.get("eventSubType");
			params.put("ssoYn", "Y");

			if(params.get("msgTargetFlag") != null && params.get("msgTargetFlag").toString().equals("Y")){
				String path = request.getScheme() + "://"+request.getServerName() + ":" + request.getServerPort() + "/edms" + params.get("url");
				
				mv.setViewName("redirect:"+path);
				
				//SSO를 통해 들어왔던 페이지 이동정보 초기화
			    request.getSession().setAttribute("ssoLinkInfo", null);
				return mv;
			}
			
			
			//원피스 문서링크 및 외부URL SSO연동 예외처리
			if(params.get("urlGubun") != null && (params.get("urlGubun").equals("oneffice") || params.get("urlGubun").equals("out_link"))){
				mv.setViewName("redirect:" + params.get("url"));
				
				//SSO를 통해 들어왔던 페이지 이동정보 초기화
			    request.getSession().setAttribute("ssoLinkInfo", null);
			    
				return mv;
			}
			
			
			if(eventType == null){
				eventType = "";
			}
		
			if(eventSubType == null){
				eventSubType = "";
			}
			
			String compMailUrl = "";
			String messengerViewType = params.get("messengerViewType") + "";
			
			//messengerViewType ->  메신저 알림 SSO 이동 형태(A : 상세 페이지까지 이동, B : 메뉴까지만 이동, C: 상세 페이지 팝업으로 노출)   
			mv.addObject("userSe",loginVO.getUserSe());
			mv.addObject("params", params);			
			
			if(urlGubun.toLowerCase().equals("mail")){
				
				if(params.get("url") != "" && params.get("url").equals("forward")) {
					params.put("url", loginVO.getUrl());
				}
				
				compMailUrl = loginVO.getUrl();
				
				if(!linkType.equals("P")){
					
					String detailUrl = params.get("url").toString().substring(params.get("url").toString().indexOf("/mail2/")+7);
					
					if(detailUrl.length() > 0){
						if(compMailUrl.indexOf("?ssoType=GW") != -1){
							compMailUrl = compMailUrl.replace("?ssoType=GW", "");
						}
						compMailUrl = compMailUrl + detailUrl;
					}		
					
				}else if(linkType.equals("P")) {
					
					String url = (String) params.get("url");
					String detailUrl = params.get("url").toString().substring(params.get("url").toString().indexOf("/mail2/")+7);
					
					if(url.indexOf("/mail2/?ssoType=GWwriteMailViewApi.do") != -1){
						detailUrl = detailUrl.replace("?ssoType=GW", "");
						detailUrl = detailUrl + "&ssoType=GW";
					}
					
					compMailUrl = compMailUrl + detailUrl;
					
				}
				
				if(!linkType.equals("L")){
					mv.setViewName("redirect:"+compMailUrl);
				}else{
					
					mv.addObject("topType", "mail");
					params.put("url", compMailUrl);

					mv.addObject("userSe",loginVO.getUserSe());
					mv.addObject("params", params);
					mv.setViewName("/main/mail/bizboxMail");
					
					Map<String, Object> mp = new HashMap<String, Object>();
					mp.put("groupSeq", loginVO.getGroupSeq());
					mp.put("compSeq", loginVO.getCompSeq());					
					Map<String, Object> portalInfo = (Map<String, Object>) commonSql.select("CompManage.getPortalId", mp);
					if(portalInfo != null){
						mv.addObject("portalId", portalInfo.get("portalId"));
						mv.addObject("portalDiv", portalInfo.get("portalDiv"));
						
						if(portalInfo.get("portalDiv").equals("cloud")){
							mv.setViewName("/main/mail/bizboxCloudMail");
							mv.addObject("topMenuList", mainService.getTopMenuList(loginVO));
						}			
					}
					
				}
				
				request.getSession().setAttribute("ssoLinkInfo", null);
			}			
			else{
				if(messengerViewType.equals("C")){
					if(params.get("moduleTp") != null && params.get("moduleTp").equals("eapproval")){
						params.put("moduleTp", loginVO.getEaType());
					}					
					String redirectUrl = request.getScheme() + "://"+request.getServerName()+ ":" + request.getServerPort() + "/" + params.get("moduleTp") + params.get("url");
					mv.setViewName("redirect:"+redirectUrl);
				}else{
					mv.addObject("userSe",loginVO.getUserSe());
					mv.addObject("params", params);
					
					mv.setViewName("/main/sub/bizbox");
					
					Map<String, Object> mp = new HashMap<String, Object>();
					mp.put("groupSeq", loginVO.getGroupSeq());
					mp.put("compSeq", loginVO.getCompSeq());					
					Map<String, Object> portalInfo = (Map<String, Object>) commonSql.select("CompManage.getPortalId", mp);
					
					if(portalInfo != null){
						mv.addObject("portalId", portalInfo.get("portalId"));
						mv.addObject("portalDiv", portalInfo.get("portalDiv"));
						
						if(portalInfo.get("portalDiv").equals("cloud")){
							mv.setViewName("/main/sub/bizboxCloud");
							mv.addObject("topMenuList", mainService.getTopMenuList(loginVO));
						}			
					}					
					
				}
				//SSO를 통해 들어왔던 페이지 이동정보 초기화
			    request.getSession().setAttribute("ssoLinkInfo", null);
			}
		}else {
			mv.setViewName("redirect:/userMain.do");
		}
		
		return mv;
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping("/bizboxLink.do")
	public ModelAndView bizboxLink(@RequestParam Map<String,Object> params, HttpServletRequest request, HttpServletResponse response) throws Exception {
		
		ModelAndView mv = new ModelAndView();
		
		if(params.get("url") != null && !params.get("url").equals("")) {
			
			String url = params.get("url").toString();
			
			url = url.replace("../edms", "/edms");
			
			//URL 직접전달
			if(url.contains("..")) {
				url = "/userMain.do";
			}else {
				url = ".." + url;
			}
			
			params.put("url", url);
 
		}else if(params.get("linkType") != null){
			String serverName = request.getScheme() + "://" + request.getServerName() + (request.getServerPort() == 80 ? "" : ":" + request.getServerPort());
	    	
			Map<String, Object> jedisMp = CloudConnetInfo.getParamMapByDomain(request.getServerName());     
	    	String groupSeq = (String) jedisMp.get("groupSeq");
			if(params.get("linkType").equals("board")){
				String edmsUrl = "/edms/board/viewPost.do?";
				if(params.get("boardNo") != null && !params.get("boardNo").toString().equals("")){
					params.put("groupSeq", groupSeq);
					String catType = (String) commonSql.select("MainManageDAO.getBoardType", params);
					if(catType != null && catType.equals("B")){
						edmsUrl = "/edms/board/viewBoard.do?";
					}
				}
				params.put("url", serverName + edmsUrl + request.getQueryString());
			}else{
				params.put("url", "/userMain.do");
			}
		}else{
			params.put("url", "/userMain.do");
		}
		
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		
		if(loginVO == null) {
			params.put("urlGubun", "sessionRedirect");
			request.getSession().setAttribute("ssoLinkInfo", params);
			mv.setViewName("redirect:/uat/uia/egovLoginUsr.do");
			return mv;
		}else{
			request.getSession().setAttribute("ssoLinkInfo", null);
			mv.setViewName("redirect:" + params.get("url"));
		}
		return mv;
	}	
	
		
	@SuppressWarnings("unchecked")
	@RequestMapping("/bizboxExLink.do")
	public ModelAndView bizboxExLink(@RequestParam Map<String,Object> params, HttpServletRequest request, HttpServletResponse response) throws Exception {
		
		ModelAndView mv = new ModelAndView();
		
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		
		if(loginVO == null) {
			params.put("urlGubun", "sessionRedirect");
			request.getSession().setAttribute("ssoLinkInfo", params);
			mv.setViewName("redirect:/uat/uia/egovLoginUsr.do");
			return mv;
		}else{
			request.getSession().setAttribute("ssoLinkInfo", null);
			mv.setViewName("redirect:" + params.get("url"));
		}
		return mv;
	}

	@RequestMapping("/bizboxExt.do")
	public ModelAndView bizboxExt(@RequestParam Map<String,Object> params, HttpServletRequest request, HttpServletResponse response) throws Exception {
		
		ModelAndView mv = new ModelAndView();
		
		Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();
		
		if(!isAuthenticated) {
			
			mv.setViewName("redirect:/uat/uia/egovLoginUsr.do");
			
			return mv;
			
		}
		
		params.putAll((Map<String,Object>)request.getSession().getAttribute("extLinkInfo"));
		
		mv.addObject("params", params);
		mv.setViewName("/main/sub/bizboxExt");
		
	    //SSO를 통해 들어왔던 페이지 이동정보 초기화
	    request.getSession().setAttribute("extLinkInfo", null);
		
		return mv;
	}

	

	
	
	@RequestMapping("/bizboxOut.do")
	public ModelAndView bizboxOutProcess(@RequestParam Map<String,Object> params, HttpServletRequest request, HttpServletResponse response, RedirectAttributes redirectAttributes) throws Exception {
		
		ModelAndView mv = new ModelAndView();
		
		Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();
		
		String groupSeq = request.getSession().getAttribute("groupSeq") + "";
		String loginId = request.getSession().getAttribute("loginId") + "";
		String compSeq = request.getSession().getAttribute("compSeq") + "";
		String deptSeq = (String)request.getSession().getAttribute("deptSeq");
		
		request.getSession().removeAttribute("groupSeq");
		request.getSession().removeAttribute("loginId");
		request.getSession().removeAttribute("compSeq");
		request.getSession().removeAttribute("deptSeq");
		
		LoginVO loginVo = loginVOResetting(groupSeq, loginId, compSeq, deptSeq);
		
		if(loginVo != null) {
			request.getSession().setAttribute("loginVO", loginVo);
		}
		
		if(!isAuthenticated) {
			
			mv.setViewName("redirect:/uat/uia/egovLoginUsr.do");
			
			return mv;
			
		}
		
		params.putAll((Map<String,Object>)request.getSession().getAttribute("outProcessInfo"));
		
		String queryString = "";
		
		if(params != null) {
			
			//DERP 토큰처리 
			if(params.get("X-Authenticate-Token") != null){
				redirectAttributes.addFlashAttribute("X-Authenticate-Token",params.get("X-Authenticate-Token"));
				request.getSession().setAttribute("X-Authenticate-Token",params.get("X-Authenticate-Token"));
				params.remove("X-Authenticate-Token");
			}

			//전자결재본문내용 전달
			if(params.get("contentsStr") != null){
				redirectAttributes.addFlashAttribute("contentsStr",params.get("contentsStr"));
				params.remove("contentsStr");
			}else{
				redirectAttributes.addFlashAttribute("contentsStr","");
			}
			
			//전자결재본문내용 전달
			if(params.get("subjectStr") != null){
				redirectAttributes.addFlashAttribute("subjectStr",params.get("subjectStr"));
				params.remove("subjectStr");
			}else{
				redirectAttributes.addFlashAttribute("subjectStr","");
			}			
			
			//Query String 생성 
			for (String mapKey : params.keySet()) {
				queryString += (queryString.equals("") ? "?" : "&") + mapKey + "=" + URLEncoder.encode(params.get(mapKey).toString(),"UTF-8");
			}			
		}

		if(queryString.equalsIgnoreCase("")){
			mv.setViewName("redirect:/userMain.do");
		}else{
			String url = request.getScheme() + "://"+request.getServerName()+ ":" +request.getServerPort()+ "/" + loginVo.getEaType() + "/ea/docpop/bizboxOutProcess.do" + queryString;
			mv.setViewName("redirect:"+url);
		}
		
	    //SSO를 통해 들어왔던 페이지 이동정보 초기화
	    request.getSession().removeAttribute("outProcessInfo");
		
		return mv;
	}
	
	
	@RequestMapping("/bizboxOutLogOn.do")
	public void bizboxOutLogOn(@RequestParam Map<String,Object> params, HttpServletRequest request, HttpServletResponse response, RedirectAttributes redirectAttributes) throws Exception {
		
		ModelAndView mv = new ModelAndView();
		
		Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();
		
		String groupSeq = request.getSession().getAttribute("groupSeq") + "";
		String loginId = request.getSession().getAttribute("loginId") + "";
		String compSeq = request.getSession().getAttribute("compSeq") + "";
		String deptSeq = (String)request.getSession().getAttribute("deptSeq");
		
		request.getSession().removeAttribute("groupSeq");
		request.getSession().removeAttribute("loginId");
		request.getSession().removeAttribute("compSeq");
		request.getSession().removeAttribute("deptSeq");
		
		LoginVO loginVo = loginVOResetting(groupSeq, loginId, compSeq, deptSeq);
		
		//SSO를 통해 들어왔던 페이지 이동정보 초기화
	    request.getSession().removeAttribute("outLogOn");
		
		if(loginVo != null) {
			request.getSession().setAttribute("loginVO", loginVo);
		}
		
		if(!isAuthenticated) {
			mv.setViewName("redirect:/uat/uia/egovLoginUsr.do");
		}		
		
//		mv.setViewName("redirect:/userMain.do");
//		mv.addObject("sessionId", request.getSession().getId());
//		mv.addObject("result","SUCCESS");
	}
	
	
	
	@RequestMapping("/bizboxFM.do")
	public ModelAndView bizboxFM(@RequestParam Map<String,Object> params, HttpServletRequest request, HttpServletResponse response) throws Exception {
		
		ModelAndView mv = new ModelAndView();
		
		Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();
		
		String groupSeq = request.getSession().getAttribute("groupSeq") + "";
		String loginId = request.getSession().getAttribute("loginId") + "";
		String compSeq = request.getSession().getAttribute("compSeq") + "";
		String deptSeq = (String)request.getSession().getAttribute("deptSeq");
		
		request.getSession().removeAttribute("groupSeq");
		request.getSession().removeAttribute("loginId");
		request.getSession().removeAttribute("compSeq");
		request.getSession().removeAttribute("deptSeq");
		
		LoginVO loginVo = loginVOResetting(groupSeq, loginId, compSeq, deptSeq);
		
		if(loginVo != null) {
			request.getSession().setAttribute("loginVO", loginVo);
		}
		
		if(!isAuthenticated) {
			
			mv.setViewName("redirect:/uat/uia/egovLoginUsr.do");
			
			return mv;
			
		}
		
		params.putAll((Map<String,Object>)request.getSession().getAttribute("fmInfo"));
		//params.get("eaType").toString() > 영리(eap),비영리(ea) 
		String eaType = params.get("eaType").toString();
		
		String path = request.getScheme() + "://"+request.getServerName()+ ":" +request.getServerPort()+ "/" + eaType;
		
		if(params.get("callId").equals("0")) {
			path += "/ea/eadocpop/EAAppDocPopIFrameDaily.do";
			path += "?approKey=" + URLEncoder.encode(EgovStringUtil.isNullToString(params.get("approvalId")), "UTF-8");
		}
		else {
			path += "/ea/docpop/EAAppInterfacePop.do";
			path += "?approvalId=" + URLEncoder.encode(EgovStringUtil.isNullToString(params.get("approvalId")), "UTF-8");
			path += "&formAppKind=" + EgovStringUtil.isNullToString(params.get("formAppKind"));
			path += "&formId=" + EgovStringUtil.isNullToString(params.get("formId"));
			path += "&formKind=" + EgovStringUtil.isNullToString(params.get("formKind"));
			path += "&docId=" + EgovStringUtil.isNullToString(params.get("docId"));
			path += "&mod=" + EgovStringUtil.isNullToString(params.get("mod"));
			path += "&refDocId=" + EgovStringUtil.isNullToString(params.get("refDocId"));
			path += "&callId=" + params.get("callId");
		}
		
		mv.setViewName("redirect:"+path);
		
	    //SSO를 통해 들어왔던 페이지 이동정보 초기화
	    request.getSession().removeAttribute("fmInfo");
	    
		
		return mv;
	}
	
	@RequestMapping("/{groupSeq}/{compSeq}/index.do")
	public void compIndex(@RequestParam Map<String,Object> params, HttpServletRequest request, HttpServletResponse response
			,@PathVariable("groupSeq") String groupSeq,@PathVariable("compSeq") String compSeq) throws Exception {
		
		ModelAndView mv = new ModelAndView();
		
		Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();
		
		if(!isAuthenticated) {
			
			mv.setViewName("redirect:/uat/uia/egovLoginUsr.do");
			
		}
		
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		 
		params.put("groupSeq", groupSeq);
		params.put("compSeq", compSeq);
		params.put("empSeq", loginVO.getUniqId());
		Map<String,Object> compInfo = logoManageService.getCompInfo(params);
		
		if(compInfo != null) {
			String domain = compInfo.get("compDomain")+"";
			
			if(!EgovStringUtil.isEmpty(domain)) {
				loginVO.setGroupSeq(groupSeq);
				loginVO.setCompSeq(compSeq);
				
				response.sendRedirect(request.getScheme() + "://"+domain+"/gw/bizbox.do");
			}
		}
		
	}

	@RequestMapping("/bizboxSW.do")
	public ModelAndView bizboxSW(@RequestParam Map<String,Object> params, HttpServletRequest request, HttpServletResponse response) throws Exception {
	  
	  ModelAndView mv = new ModelAndView();
	  
	  Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();
	  
	  if(!isAuthenticated) {
	   
	   mv.setViewName("redirect:/uat/uia/egovLoginUsr.do");
	   
	   return mv;
	   
	  }
	  
	  params.putAll((Map<String,Object>)request.getSession().getAttribute("enpassLinkInfo"));
	  
	  mv.addObject("params", params);
	  mv.setViewName("/main/sub/bizboxSW");
	  
	     //SSO를 통해 들어왔던 페이지 이동정보 초기화
	     request.getSession().setAttribute("enpassLinkInfo", null);
	  
	  return mv;
	 }
	 
	@RequestMapping("/bizboxOuter.do")
	public ModelAndView bizboxOuter(@RequestParam Map<String,Object> params, HttpServletRequest request, HttpServletResponse response) throws Exception {
		
		ModelAndView mv = new ModelAndView();
		
		Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();
		
		if(!isAuthenticated) {
			
			mv.setViewName("redirect:/uat/uia/egovLoginUsr.do");
			
			return mv;
			
		}
		
		params.putAll((Map<String,Object>)request.getSession().getAttribute("outerLinkInfo"));
		
		String path = (String) params.get("rURL");
		
		mv.setViewName("redirect:"+path);
		
	    //SSO를 통해 들어왔던 페이지 이동정보 초기화
	    request.getSession().removeAttribute("outerLinkInfo");
	    
		
		return mv;
	}
	
	@RequestMapping("/oneContents.do")
	public ModelAndView oneContents(@RequestParam Map<String,Object> params, HttpServletRequest request) throws Exception {
		
		ModelAndView mv = new ModelAndView();
		
		Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();
		
		if(!isAuthenticated || request.getSession().getAttribute("loginVO") == null) {
			
			mv.setViewName("redirect:/uat/uia/egovLoginUsr.do");
			
			return mv;
			
		}
		
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("groupSeq", loginVO.getGroupSeq());
		mp.put("compSeq", loginVO.getCompSeq());
		
		String[] url = params.get("url").toString().split("▦",-1);
		params.put("url", url[0]);
		String urlType = url.length > 1 ? url[1] : ""; 
		params.put("urlType", urlType);
		
		//전자계약
		if(urlType.equals("electronicContract")){
			mp.put("deptSeq", loginVO.getOrgnztId());
			mp.put("empSeq", loginVO.getUniqId());
			
			Map<String, Object> ssoParam = (Map<String, Object>) commonSql.select("OrgAdapterManage.selectSSOParamInfo", mp);
			
			if(ssoParam != null){
				SimpleDateFormat format = new SimpleDateFormat("yyyyMMddHHmmss");
				params.put("token", AESCipher.AES_Encode(format.format(new Date())));
				params.put("urlType", urlType);
				
		    	if(!BizboxAProperties.getCustomProperty("BizboxA.Cust.electronicContractGroupCode").equals("99")) {
		    		params.put("groupCode", AESCipher.AES_Encode(BizboxAProperties.getCustomProperty("BizboxA.Cust.electronicContractGroupCode")));
		    	}else {
		    		params.put("groupCode", AESCipher.AES_Encode(ssoParam.get("groupCode").toString()));
		    	}
				
				params.put("eaType", AESCipher.AES_Encode(ssoParam.get("eaType") == null ? "eap" : ssoParam.get("eaType").toString()));
				params.put("compSeq", AESCipher.AES_Encode(ssoParam.get("compSeq") == null ? "" : ssoParam.get("compSeq").toString()));
				params.put("compCode", AESCipher.AES_Encode(ssoParam.get("compCode") == null ? "" : ssoParam.get("compCode").toString()));
				params.put("venderno", AESCipher.AES_Encode(ssoParam.get("venderno") == null ? "" : ssoParam.get("venderno").toString()));
				params.put("company", AESCipher.AES_Encode(ssoParam.get("company") == null ? "" : ssoParam.get("company").toString()));
				params.put("ceoName", AESCipher.AES_Encode(ssoParam.get("ceoName") == null ? "" : ssoParam.get("ceoName").toString()));
				params.put("uptae", AESCipher.AES_Encode(ssoParam.get("uptae") == null ? "" : ssoParam.get("uptae").toString()));
				params.put("upjong", AESCipher.AES_Encode(ssoParam.get("upjong") == null ? "" : ssoParam.get("upjong").toString()));
				params.put("zipCode", AESCipher.AES_Encode(ssoParam.get("zipCode") == null ? "" : ssoParam.get("zipCode").toString()));
				params.put("address", AESCipher.AES_Encode(ssoParam.get("address") == null ? "" : ssoParam.get("address").toString()));
				params.put("faxNo", AESCipher.AES_Encode(ssoParam.get("faxNo") == null ? "" : ssoParam.get("faxNo").toString()));
				
		    	if(!BizboxAProperties.getCustomProperty("BizboxA.Cust.electronicContractwebService").equals("99")) {
		    		params.put("webService", AESCipher.AES_Encode(BizboxAProperties.getCustomProperty("BizboxA.Cust.electronicContractwebService")));
		    	}else {
		    		params.put("webService", AESCipher.AES_Encode(request.getScheme() + "://" + request.getServerName() + (request.getServerPort() == 80 ? "" : ":" + request.getServerPort())));
		    	}
				
				params.put("compSeqList", AESCipher.AES_Encode(ssoParam.get("compSeqList") == null ? "" : ssoParam.get("compSeqList").toString()));
				params.put("deptSeq", AESCipher.AES_Encode(ssoParam.get("deptSeq") == null ? "" : ssoParam.get("deptSeq").toString()));
				params.put("deptCode", AESCipher.AES_Encode(ssoParam.get("deptCode") == null ? "" : ssoParam.get("deptCode").toString()));
				params.put("deptName", AESCipher.AES_Encode(ssoParam.get("deptName") == null ? "" : ssoParam.get("deptName").toString()));
				params.put("erpSeq", AESCipher.AES_Encode(ssoParam.get("erpSeq") == null ? "" : ssoParam.get("erpSeq").toString()));
				params.put("empSeq", AESCipher.AES_Encode(ssoParam.get("empSeq") == null ? "" : ssoParam.get("empSeq").toString()));
				params.put("userid", AESCipher.AES_Encode(ssoParam.get("userid") == null ? "" : ssoParam.get("userid").toString()));
				params.put("userName", AESCipher.AES_Encode(ssoParam.get("userName") == null ? "" : ssoParam.get("userName").toString()));
				params.put("telNo", AESCipher.AES_Encode(ssoParam.get("telNo") == null ? "" : ssoParam.get("telNo").toString()));
				params.put("hpNo", AESCipher.AES_Encode(ssoParam.get("hpNo") == null ? "" : ssoParam.get("hpNo").toString()));
				params.put("email", AESCipher.AES_Encode(ssoParam.get("email") == null ? "" : ssoParam.get("email").toString()));
				params.put("auth", AESCipher.AES_Encode(loginVO.getUserSe().equals("USER") ? "P" : "M"));
			}
		}else if(params.get("mainForward") != null && params.get("mainForward").equals("Y")) {

			//체크여부(키 대체사용) 
			params.put("linkId", params.get("no"));
		    params.put("linkTp", "gw_menu");
		    params.put("linkSeq", "1");
		    params.put("url", menuManageService.getMenuSSOLinkInfo(params, loginVO).get("ssoUrl"));
			
		}
		
		mv.setViewName("/main/onecontents/oneContents");
		
		/** 메인 하단 푸터 버튼 가져오기(포털id) */
		@SuppressWarnings("unchecked")
		Map<String, Object> portalInfo = (Map<String, Object>) commonSql.select("CompManage.getPortalId", mp);
		
		if(portalInfo != null){
			mv.addObject("portalId", portalInfo.get("portalId"));
			mv.addObject("portalDiv", portalInfo.get("portalDiv"));
			
			if(portalInfo.get("portalDiv").equals("cloud")){
				mv.setViewName("/main/onecontents/oneContentsCloud");
				mv.addObject("topMenuList", mainService.getTopMenuList(loginVO));
			}		
		}
		
		mv.addObject("params", params);
		mv.addObject("topType", "mail");
		
		return mv;
	}	
	
	public LoginVO loginVOResetting(String groupSeq, String loginId, String compSeq, String deptSeq){
		LoginVO user = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("groupSeq", groupSeq);
		param.put("loginId", loginId);
		param.put("compSeq", compSeq);
		param.put("deptSeq", deptSeq);
		
		Map<String, Object> empInfo = (Map<String, Object>) commonSql.select("Empmanage.getLoginVOInfo", param);
		
		if(empInfo != null){
			user.setUniqId(empInfo.get("esntlId")+"");
			user.setId(empInfo.get("userId")+"");
			user.setOrgnztNm(empInfo.get("orgnztNm")+"");
			
			user.setOrgnztId(empInfo.get("orgnztId")+"");
			user.setOrgnztNm(empInfo.get("orgnztNm")+"");
			
			String positionCode = empInfo.get("positionCode")+"";
			String positionCodeName = empInfo.get("positionNm")+"";
			user.setPositionCode(positionCode);
			user.setPositionNm(positionCodeName);
			
			String dutyCode = empInfo.get("classCode")+"";
			String dutyCodeName = empInfo.get("classNm")+"";			
			user.setClassCode(dutyCode);
			user.setClassNm(dutyCodeName);
			
			
			//user.setEmail(resultMember.get("email_addr")+"");
			user.setOrganId(empInfo.get("organId")+"");
			user.setOrganNm(empInfo.get("organNm")+"");
			user.setCompSeq(empInfo.get("organId")+"");
			user.setBizSeq(empInfo.get("bizSeq")+"");
			user.setEmailDomain(empInfo.get("emailDomain")+"");
			
			user.setAuthorCode(empInfo.get("authorCode")+"");
		
			//erp사번 , erp회사시퀀스 변경
			List<Map<String,Object>> erpList = compManageService.getEmpErpCompList(param);
			
			String erpCompSeqHr = "";
			String erpCompSeqAc = "";
			String erpCompSeqEtc = "";
			int cntHr = 0;
			int cntAc = 0;
			int cntEtc = 0;
			
			if(erpList != null){					
				
				for(Map<String,Object> mp : erpList){
					if(mp.get("achrGbn") != null && mp.get("achrGbn").equals("hr")){
						erpCompSeqHr = mp.get("erpCompSeq")+"";
						cntHr++;
					}
					if(mp.get("achrGbn") != null && mp.get("achrGbn").equals("ac")){
						erpCompSeqAc = mp.get("erpCompSeq")+"";
						cntAc++;
					}
					if(mp.get("achrGbn") != null && mp.get("achrGbn").equals("etc")){
						erpCompSeqEtc = mp.get("erpCompSeq")+"";
						cntEtc++;
					}
				}
			}
			String erpCompSeq = "";
			if(cntHr > 0) {
				erpCompSeq = erpCompSeqHr;
			}
			else if(cntAc > 0) {
				erpCompSeq = erpCompSeqAc;
			}
			else if(cntEtc > 0) {
				erpCompSeq = erpCompSeqEtc;
			}
			
			user.setErpCoCd(erpCompSeq);
			user.setErpEmpCd(empInfo.get("erpEmpCd")+"");	
			
			
		}
		
		return user;
	}
	
	public void empAttCheck(HttpServletRequest request) throws Exception{
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		
				
		try{			
			String jsonParam =	 "{\"empSeq\":\"" + loginVO.getUniqId() + "\", \"deptSeq\":\"" + loginVO.getOrgnztId() + "\", \"compSeq\":\"" + loginVO.getOrganId() + "\", \"groupSeq\":\"" + loginVO.getGroupSeq() + "\", \"connectExtIp\":\"" + loginVO.getIp() + "\", \"connectIp\":\"" + loginVO.getIp() + "\", \"gbnCode\":\"1\"}";
			String apiUrl = CommonUtil.getApiCallDomain(request) + "/attend/external/api/gw/insertComeLeaveEvent";

			JSONObject jsonObject2 = JSONObject.fromObject(JSONSerializer.toJSON(jsonParam));
			HttpJsonUtil httpJson = new HttpJsonUtil();
			String empAttCheck = httpJson.execute("POST", apiUrl, jsonObject2);
			
			Map<String, Object> map = new HashMap<String, Object>();

			ObjectMapper mapper = new ObjectMapper();
			map = mapper.readValue(empAttCheck, new TypeReference<Map<String, String>>(){});

			if(map.get("resultCode").toString().equals("SUCCESS")) {
				request.getSession().setAttribute("empAttCheckMsg", BizboxAMessage.getMessage("TX000001777","출근처리가 완료되었습니다."));
			}
			else {
				request.getSession().setAttribute("empAttCheckMsg", map.get("resultMessage"));
			}
		 }
		 catch (Exception e) {
			 CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
		 }
	}
	
	public static JSONObject getPostJSON(String url, String data) {
		StringBuilder sbBuf = new StringBuilder();
		HttpURLConnection con = null;
		BufferedReader brIn = null;
		OutputStreamWriter wr = null;
		String line = null;
		try {
			con = (HttpURLConnection) new URL(url).openConnection();
			con.setRequestMethod("POST");
			con.setConnectTimeout(5000);
			con.setRequestProperty("Content-Type", "application/json;charset=UTF-8");
			con.setDoOutput(true);
			con.setDoInput(true);

			wr = new OutputStreamWriter(con.getOutputStream());
			wr.write(data);
			wr.flush();
			brIn = new BufferedReader(new InputStreamReader(con.getInputStream(), "UTF-8"));
			while ((line = brIn.readLine()) != null) {
				sbBuf.append(line);
			}
			// System.out.println(sbBuf);

			JSONObject rtn = JSONObject.fromObject(sbBuf.toString());

			sbBuf = null;

			return rtn;
		} catch (Exception e) {
			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
			return null;
		} finally {
			try {
				if(wr!=null) {//Null Pointer 역참조
				wr.close();
				}
			} catch (Exception e) {
				logger.error(e.getMessage());
			}
			try {
				if(brIn!=null) {//Null Pointer 역참조
				brIn.close();
				}
			} catch (Exception e) {
				logger.error(e.getMessage());
			}
			try {
				if(con!=null) {//Null Pointer 역참조
				con.disconnect();
				}
			} catch (Exception e) {
				logger.error(e.getMessage());
			}
		}
	}
		
}
