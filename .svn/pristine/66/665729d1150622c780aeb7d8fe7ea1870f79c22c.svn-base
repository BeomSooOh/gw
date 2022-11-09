package neos.cmm.systemx.group.web;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import neos.cmm.db.CommonSqlDAO;
import neos.cmm.menu.service.MenuManageService;
import neos.cmm.systemx.commonOption.service.CommonOptionManageService;
import neos.cmm.systemx.etc.service.LogoManageService;
import neos.cmm.systemx.group.service.GroupManageService;
import neos.cmm.systemx.orgchart.service.OrgChartService;
import neos.cmm.util.BizboxAProperties;
import neos.cmm.util.CommonUtil;
import neos.cmm.util.HttpJsonUtil;
import neos.cmm.util.MessageUtil;
import neos.cmm.util.NeosConstants;
import net.sf.json.JSONArray;
import net.sf.json.JSONException;
import net.sf.json.JSONObject;
import egovframework.com.utl.fcc.service.EgovStringUtil;
import egovframework.com.utl.sim.service.EgovFileScrty;
import main.service.MainService;
import main.web.BizboxAMessage;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.fasterxml.jackson.core.JsonParseException;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.JsonMappingException;
import com.fasterxml.jackson.databind.ObjectMapper;

import cloud.CloudConnetInfo;
import bizbox.orgchart.service.vo.LoginVO;
import egovframework.com.cmm.annotation.IncludedInfo;
import egovframework.com.cmm.util.EgovUserDetailsHelper;

@Controller
public class GroupManageController {
	
	@Resource(name = "GroupManageService")
	private GroupManageService groupManageService;
	
	@Resource(name = "OrgChartService")
	private OrgChartService orgChartService;
	
	@Resource(name="LogoManageService")
	private LogoManageService logoManageService;
	
	@Resource(name="MenuManageService")
	private MenuManageService menuManageService;

	@Resource(name="MainService")
	MainService mainService;	
	
	@Resource ( name = "commonSql" )
	private CommonSqlDAO commonSql;
	
	@Resource(name="CommonOptionManageService")
    CommonOptionManageService commonOptionManageService;
	
	@IncludedInfo(name="그룹정보관리", order = 100 ,gid = 60)
	@RequestMapping("/cmm/systemx/groupManageView.do")
	public ModelAndView groupManageView(@RequestParam Map<String,Object> params, HttpServletRequest request) throws Exception {
		
		ModelAndView mv = new ModelAndView();
		
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		
		params.put("groupSeq", loginVO.getGroupSeq());
		params.put("langCode", loginVO.getLangCode());		
		
		if(!loginVO.getUserSe().equals("MASTER")){
			
			/** 마스터 권한 체크 */
			if(CommonUtil.getIntNvl(mainService.selectMasterAuthCnt(params)) == 0){
				mv.setViewName("redirect:/forwardIndex.do");
				return mv;
			}else{
				loginVO.setUserSe("MASTER");
				request.getSession().setAttribute("loginVO", loginVO);
				request.setAttribute("loginVO", loginVO);
			}
		}
		
		/** 그룹기본정보 조회 */
		Map<String,Object> groupMap = orgChartService.getGroupInfo(params);
		
		String groupIpInfo = BizboxAProperties.getProperty("BizboxA.groupware.domin");
		mv.addObject("groupIpInfo", groupIpInfo);
		
		params.put("osType", "windows");
		List<Map<String,Object>> wList = groupManageService.selectGroupPathList(params);
		mv.addObject("wList", wList);
		
		params.put("osType", "linux");
		
		List<Map<String,Object>> lList = groupManageService.selectGroupPathList(params);
		mv.addObject("lList", lList);
		
		params.put("usage", "Y");
		params.put("eaType", loginVO.getEaType() == null ? "eap" : loginVO.getEaType());
		List<Map<String,Object>> usageList = groupManageService.selectGroupPathList(params);
		mv.addObject("usageList", usageList);
		
		//프로퍼티 SMTP설정정보 반영
		if(!CloudConnetInfo.getBuildType().equals("cloud") && !BizboxAProperties.getProperty("BizboxA.smtp.url").equals("99")) {
			groupMap.put("smtpProperties", "Y");		
		}
		
		if(groupMap.get("outSmtpUseYn") != null && !groupMap.get("outSmtpUseYn").equals("Y")) {
			
			//프로퍼티 설정값이 있을경우 우선으로 처리
			if(!CloudConnetInfo.getBuildType().equals("cloud") && !BizboxAProperties.getProperty("BizboxA.smtp.url").equals("99")) {
				
				groupMap.put("outSmtpUseYn", "Y");
				groupMap.put("smtpPort", "25");	
				groupMap.put("smtpId", "");
				groupMap.put("smtpPw", "");
				groupMap.put("smtpServer", BizboxAProperties.getProperty("BizboxA.smtp.url"));
				
				if(!BizboxAProperties.getProperty("BizboxA.smtp.port").equals("99")) {
					groupMap.put("smtpPort", BizboxAProperties.getProperty("BizboxA.smtp.port"));
				}

				if(BizboxAProperties.getProperty("BizboxA.smtp.auth").equals("Y")) {
					
					if(!BizboxAProperties.getProperty("BizboxA.smtp.auth.id").equals("99")) {
						groupMap.put("smtpId", BizboxAProperties.getProperty("BizboxA.smtp.auth.id"));
					}						
					
					if(!BizboxAProperties.getProperty("BizboxA.smtp.auth.password").equals("99")) {
						groupMap.put("smtpPw", BizboxAProperties.getProperty("BizboxA.smtp.auth.password"));
					}
					
				}
				
			}			
		}
		
		mv.addObject("groupMap", groupMap);
		
		/** 그룹웨어 WEB 컨테이너분리 정보 */
		List<Map<String,Object>> containerList = groupManageService.selectGroupContainerList(params);
		mv.addObject("containerList", containerList);
		
		
		/** A타입, B타입 정보 불러오기*/
		String loginType = "A";
		String serverName = request.getServerName();                
        params.put("domain", serverName);        
		Map<String, Object> compInfo = logoManageService.getDomainCompInfo(params);
		
		if(compInfo != null){
    		if(compInfo.get("loginType") != null && !compInfo.get("loginType").equals("")){
    			loginType = (String) compInfo.get("loginType");    
    		}
    	}
		mv.addObject("loginType", loginType);
		mv.addObject("eaType", loginVO.getEaType());

		//마스터패스워드 변경 가능여부
		if(request.getSession().getAttribute("masterLogon") != null){
			if(BizboxAProperties.getCustomProperty("BizboxA.Cust.masterEdit").equals("Y")){
				mv.addObject("masterEdit", "Y");	
			}			
		}
		
		//빌드타입
		String buildType = CloudConnetInfo.getBuildType();
		mv.addObject("buildType", buildType);
		
		MessageUtil.getRedirectMessage(mv, request);
		
		mv.setViewName("/neos/cmm/systemx/group/groupManageView");
		
		return mv;
	}
	
	@RequestMapping("/cmm/systemx/group/mailAlertInfoSave.do")
	public ModelAndView mailAlertInfoSave(@RequestParam Map<String, Object> paramMap, HttpServletRequest request) throws Exception {
		ModelAndView mv = new ModelAndView();
		
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		
		if(loginVO != null && loginVO.getUserSe().equals("MASTER")) {
			
			paramMap.put("groupSeq", loginVO.getGroupSeq());
			paramMap.put("modifySeq", loginVO.getUniqId());
			
			commonSql.update("GroupManage.updateGroup", paramMap);
			
			mv.addObject("result", "success");
			
		}else {
			mv.addObject("result", "fail");
		}
		
		mv.setViewName("jsonView");
		return mv;
	}	
	
	@RequestMapping("/cmm/systemx/groupVolumeManageView.do")
	public ModelAndView groupVolumeManageView(@RequestParam Map<String,Object> params, HttpServletRequest request) throws Exception {
		
		ModelAndView mv = new ModelAndView();
		
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		
		params.put("groupSeq", loginVO.getGroupSeq());
		params.put("osType", NeosConstants.SERVER_OS);	
		params.put("sizeMail", "0");
		
		try{
			String mailAdminUrl = (String)commonSql.select("GroupManage.getMailAdminUrl", params);
			
			if(mailAdminUrl != null && !mailAdminUrl.equals("")){
				
				mailAdminUrl = mailAdminUrl + "cloud/getGroupUsage.do";
			
				JSONObject jsonObj = new JSONObject();
				JSONObject body = new JSONObject();
				body.put("groupSeq", loginVO.getGroupSeq());
				jsonObj.put("body", body);
				
				Map<String, Object> result = callApiToMap(jsonObj, mailAdminUrl);
				
				if(result != null){
					
					@SuppressWarnings("unchecked")
					Map<String, Object> resultInfo = (Map<String, Object>)result.get("result");
					params.put("sizeMail", resultInfo.get("totalUsageMB"));
					
				}
			}
		}catch(Exception ex){
			CommonUtil.printStatckTrace(ex);//오류메시지를 통한 정보노출
		}
		
		@SuppressWarnings("unchecked")
		Map<String, Object> volInfo = (Map<String, Object>)commonSql.select("GroupManage.getGwVolumeReport", params);
		
		mv.addObject("volInfo", volInfo);
		mv.addObject("buildType", CloudConnetInfo.getBuildType());
		
		mv.setViewName("/neos/cmm/systemx/group/groupVolumeManageView");
		
		return mv;
	}
	
	 public Map<String, Object> callApiToMap(JSONObject jsonObject, String url) throws JsonParseException, JsonMappingException, IOException{
		 HttpJsonUtil httpJson = new HttpJsonUtil();
		 String alertList = httpJson.execute("POST", url, jsonObject);
		 alertList = alertList.replaceAll("\'", "&#39;");
		 alertList = alertList.replaceAll("<", "&lt;");
		 alertList = alertList.replaceAll(">'", "&gt;");
		 
		 ObjectMapper om = new ObjectMapper();
		 Map<String, Object> m = om.readValue(alertList, new TypeReference<Map<String, Object>>(){});
		 
		 return m;
	 }	
	
	
	@RequestMapping("/cmm/systemx/group/getVolumeHistoryInfo.do")
	public ModelAndView getVolumeHistoryInfo(@RequestParam Map<String,Object> params, HttpServletRequest request) throws Exception {
		
		ModelAndView mv = new ModelAndView();		
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		
		Map<String, Object> mp = new HashMap<String, Object>();
		
		mp.put("groupSeq", loginVO.getGroupSeq());
		
		
		List<Map<String, Object>> list = commonSql.list("GroupManage.getGwVolumeHistoryInfo", mp);
		
		mv.addObject("result", list);
		
		mv.setViewName("jsonView");
		
		return mv;
	}
	
	@RequestMapping("/cmm/systemx/group/groupPatchHistoryInfoPop.do")
	public ModelAndView groupPatchHistoryInfoPop(@RequestParam Map<String,Object> params, HttpServletRequest request) throws Exception {
		
		ModelAndView mv = new ModelAndView();		
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		
		Map<String, Object> mp = new HashMap<String, Object>();
		
		mp.put("groupSeq", loginVO.getGroupSeq());
		mp.put("langCode", loginVO.getLangCode());
		
		@SuppressWarnings("unchecked")
		List<Map<String, Object>> list = commonSql.list("GroupManage.getPatchHistoryInfo", mp);
		
		JSONArray jarr = JSONArray.fromObject(list);
		mv.addObject("result", jarr);
		
		MessageUtil.getRedirectMessage(mv, request);
		
		mv.setViewName("/neos/cmm/systemx/group/pop/groupPatchHistoryInfoPop");
		
		return mv;
		
	}
	
	@RequestMapping("/cmm/systemx/group/setUpdateClientToken.do")
	public ModelAndView setUpdateClientToken(@RequestParam Map<String, Object> paramMap, HttpServletRequest request) throws Exception {
		ModelAndView mv = new ModelAndView();
		
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		
		if(loginVO != null && loginVO.getUserSe().equals("MASTER")){
			paramMap.put("groupSeq", loginVO.getGroupSeq());
			paramMap.put("empSeq", loginVO.getUniqId());
			paramMap.put("deptName", loginVO.getOrgnztNm());
			paramMap.put("positionName", loginVO.getPositionNm());
			paramMap.put("dutyName", loginVO.getClassNm());
			paramMap.put("empName", loginVO.getName());
			paramMap.put("loginId", loginVO.getId());
			paramMap.put("loginIp", loginVO.getIp());
			String token = UUID.randomUUID().toString().toUpperCase().replace("-", "");
			paramMap.put("token", token);
			
			commonSql.insert("GroupManage.setUpdateClientToken", paramMap);
			mv.addObject("token",token);			
		}
		
		mv.setViewName("jsonView");
		return mv;
	}	
	
	@RequestMapping("/cmm/systemx/group/setMasterSecu.do")
	public ModelAndView setMasterSecu(@RequestParam Map<String, Object> paramMap, HttpServletRequest request) throws Exception {
		ModelAndView mv = new ModelAndView();
		
		if(paramMap.get("masterSecu").toString().length() < 10 && paramMap.get("masterSecu").toString().length() > 0){
			mv.addObject("resultMsg",BizboxAMessage.getMessage("TX800000048","마스터 패스워드 설정은 10글자 이상만 가능합니다."));
		}else{
			if(request.getSession().getAttribute("masterLogon") != null && BizboxAProperties.getCustomProperty("BizboxA.Cust.masterEdit").equals("Y")){
				paramMap.put("masterSecu", EgovFileScrty.encryptPassword(paramMap.get("masterSecu").toString()));
				LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
				paramMap.put("groupSeq", loginVO.getGroupSeq());
				groupManageService.setMasterSecu(paramMap);
				mv.addObject("resultMsg",BizboxAMessage.getMessage("TX800000049","패스워드 변경 완료"));
			}else{
				mv.addObject("resultMsg",BizboxAMessage.getMessage("TX000002439","권한이 없습니다."));
			}
		}
		
		mv.setViewName("jsonView");
		return mv;
	}
	
	@RequestMapping("/cmm/systemx/groupPathData.do")
	public void groupPathData(@RequestParam Map<String,Object> paramMap, HttpServletResponse response) throws Exception {

		response.setCharacterEncoding("UTF-8");

		List<Map<String,Object>> list = null; 

		/** 회사 정보 가져오기 */
		list = groupManageService.selectGroupPathList(paramMap);

		JSONArray jarr = JSONArray.fromObject(list);
		//크로스사이트 스크립트 (XSS)
		String callback = EgovStringUtil.isNullToString(paramMap.get("callback"));
		
		if (callback != null) {
			  // 외부 입력 내 위험한 문자를 이스케이핑
			callback = callback.replaceAll("<", "&lt;"); 
			callback = callback.replaceAll(">", "&gt;");
		}
		/** jsonp 는 callback(data) 로 넘겨야 한다. */
		response.getWriter().write(callback+"("+jarr+")");
		response.getWriter().flush();
		response.getWriter().close();
	}
	
	@RequestMapping("/cmm/systemx/groupManageSaveProc.do")
	public ModelAndView groupManageSaveProc(@RequestParam Map<String,Object> params, HttpServletRequest request, RedirectAttributes ra) throws Exception {
		
		ModelAndView mv = new ModelAndView();
		
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		
		params.put("modify_seq", loginVO.getUniqId());
		
		String rc = "success.common.update";
		
		try {
			
			if(params.get("saveTarget").toString().equals("B")){
				groupManageService.insertGroup(params);
			}
			
			else if(params.get("saveTarget").toString().equals("U")){
				String[] seqList = request.getParameterValues("pathSeq");
				String[] availCapac = request.getParameterValues("availCapac");
				String[] totalCapac = request.getParameterValues("totalCapac");
				String[] limitFileCount = request.getParameterValues("limitFileCount");
				String[] osType = request.getParameterValues("osType");
	
				for(int i = 0; i < seqList.length; i++) {
					Map<String,Object> p = new HashMap<String,Object>();
					p.put("availCapac", CommonUtil.getStrNumber(availCapac[i], "0"));
					p.put("limitFileCount", CommonUtil.getStrNumber(limitFileCount[i], "0"));
					p.put("totalCapac", CommonUtil.getStrNumber(totalCapac[i], "0"));
					p.put("modifySeq", loginVO.getUniqId());
					p.put("groupSeq", params.get("groupSeq"));
					p.put("pathSeq", seqList[i]);
					p.put("osType", osType[i]);
	
					groupManageService.updateGroupPath(p);
				}
			}
			
			else if(params.get("saveTarget").toString().equals("C")){
				/** 컨테이너 정보 저장(최대 20개로 설정) */
				int containerSize = CommonUtil.getIntNvl(params.get("containerSize")+"");
				Map<String,Object> cParams = new HashMap<String,Object>();
				cParams.put("groupSeq", params.get("groupSeq"));
				cParams.put("editSeq", loginVO.getUniqId());
				for(int i = 1; i < containerSize+1; i++) {
					String conName = params.get("conName"+i)+"";
					String ip = params.get("ip"+i)+"";
					String port = params.get("port"+i)+"";
					
					cParams.put("conName", conName);
					cParams.put("ip", ip);
					cParams.put("port", port);
					
					groupManageService.insertGroupContainer(cParams);
				}
			}
			
		} catch (Exception e) {
			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
			rc = "fail.common.sql";
		}
				
		//공통옵션 리블드(그룹웨어 타이틀 갱신용)
		commonOptionManageService.rebuildCommonOptionList(loginVO.getGroupSeq());
		
		MessageUtil.setRedirectMessage(request, ra, rc);
		mv.addObject("menu_no", "1901010000");
		mv.setViewName("redirect:/cmm/systemx/groupManageView.do");
		
		return mv;
	}
	
	@RequestMapping("/cmm/systemx/groupLogoUploadPop.do")
	public ModelAndView compLogoUploadPop(@RequestParam Map<String,Object> paramMap,
			HttpServletRequest request, HttpServletResponse response) throws Exception {

		ModelAndView mv = new ModelAndView();
		
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		
		if(loginVO.getUserSe().equals("MASTER")){
			paramMap.put("orgSeq", loginVO.getGroupSeq());
			mv.addObject("orgSeq", loginVO.getGroupSeq());
		}
		else if(loginVO.toString().equals("ADMIN")){
			paramMap.put("orgSeq", loginVO.getCompSeq());
			mv.addObject("orgSeq", loginVO.getCompSeq());
		}	
		
		//마스터가 회사를 선택했을 경우(회사정보관리 페이지)
		if(paramMap.get("compSeq") != null){
			if(!paramMap.get("compSeq").toString().equals("")){
				paramMap.put("orgSeq", paramMap.get("compSeq").toString());
				mv.addObject("orgSeq", paramMap.get("compSeq").toString());
			}
		}
		
		List<Map<String, Object>> logoMap = groupManageService.getLogoImgFile(paramMap);
		List<Map<String, Object>> bgMap = groupManageService.getBgImgFile(paramMap);
		paramMap.put("imgType", "TEXT_COMP_LOGIN_" + paramMap.get("type").toString());		
		Map<String,Object> txtMap = groupManageService.getOrgDisplayText(paramMap);
		mv.addObject("txtMap", txtMap);
		
		JSONArray jsonArrLogo=new JSONArray();
		JSONArray jsonArrBg=new JSONArray();

		for(Map<String, Object> map:logoMap){
			JSONObject jsonObj = new JSONObject();
			for(Map.Entry<String, Object> entry : map.entrySet()){
				String key = entry.getKey();
				Object value = entry.getValue();
				try{
					jsonObj.put(key, value);
				}catch(JSONException e){
					e.printStackTrace();
				}
			}
			jsonArrLogo.add(jsonObj);
		}
		
		
		for(Map<String, Object> map:bgMap){
			JSONObject jsonObj = new JSONObject();
			for(Map.Entry<String, Object> entry : map.entrySet()){
				String key = entry.getKey();
				Object value = entry.getValue();
				try{
					jsonObj.put(key, value);
				}catch(JSONException e){
					e.printStackTrace();
				}
			}
			jsonArrBg.add(jsonObj);
		}
		
		mv.addObject("logoMap", jsonArrLogo);
		mv.addObject("bgMap", jsonArrBg);
		mv.addAllObjects(paramMap);
		
		mv.setViewName("/neos/cmm/systemx/group/pop/groupLogoUploadPop");

		return mv;
	}
	
	@RequestMapping("/cmm/systemx/groupPhLogoUploadPop.do")
	public ModelAndView groupPhLogoUploadPop(@RequestParam Map<String,Object> paramMap,
			HttpServletRequest request, HttpServletResponse response) throws Exception {

		ModelAndView mv = new ModelAndView();
		
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		
		if(loginVO.getUserSe().equals("MASTER")){
			paramMap.put("orgSeq", loginVO.getGroupSeq());
			mv.addObject("orgSeq", loginVO.getGroupSeq());
		}
		else if(loginVO.getUserSe().equals("ADMIN")){
			paramMap.put("orgSeq", loginVO.getCompSeq());
			mv.addObject("orgSeq", loginVO.getCompSeq());
		}
		//마스터가 회사를 선택했을 경우(회사정보관리 페이지)
		if(paramMap.get("compSeq") != null){
			if(!paramMap.get("compSeq").toString().equals("")){
				paramMap.put("orgSeq", paramMap.get("compSeq").toString());
				mv.addObject("orgSeq", paramMap.get("compSeq").toString());
			}
		}
		String fileNmList = "LOGO_01P1102xdpi|LOGO_02P1102xdpi|LOGO_01P1101hdpi|LOGO_02P1101hdpi|LOGO_01P1201hdpi|LOGO_02P1201hdpi";
		String typeList = "LOGO_01P1102xdpi|LOGO_02P1102xdpi|LOGO_01P1101hdpi|LOGO_02P1101hdpi|LOGO_01P1201hdpi|LOGO_02P1201hdpi";
		String[] items = fileNmList.split("\\|");		
		String[] types = typeList.split("\\|");
		
		
		if (items.length > 1) {
			for(int i=0;i<items.length;i++){
				
				String type = items[i];
				String imgType = type.substring(0,7);
				String dispMode = type.substring(7, 8);	// P
				String appType = type.substring(8, 10);	// 12
				String osType = type.substring(10, 12);	// 02
				String dispType = type.substring(12);	// xxdpi_p
				
				paramMap.put("dispMode", dispMode);
				paramMap.put("appType", appType);
				paramMap.put("osType", osType);
				paramMap.put("dispType", dispType);
				paramMap.put("imgType", imgType);
				
				List<Map<String,Object>> list = groupManageService.getPhoneImgFile(paramMap);
				
				JSONArray jsonArrList=new JSONArray();

				for(Map<String, Object> map:list){
					JSONObject jsonObj = new JSONObject();
					for(Map.Entry<String, Object> entry : map.entrySet()){
						String key = entry.getKey();
						Object value = entry.getValue();
						try{
							jsonObj.put(key, value);
						}catch(JSONException e){
							e.printStackTrace();
						}
					}
					jsonArrList.add(jsonObj);
				}
				mv.addObject(types[i], jsonArrList);
			}
		}
		
		mv.addAllObjects(paramMap);
		
		mv.setViewName("/neos/cmm/systemx/group/pop/groupPhLogoUploadPop");

		return mv;
	}
	
	
	@RequestMapping("/cmm/systemx/groupMsgLogoUploadPop.do")
	public ModelAndView groupMsgLogoUploadPop(@RequestParam Map<String,Object> paramMap,
			HttpServletRequest request, HttpServletResponse response) throws Exception {

		ModelAndView mv = new ModelAndView();
		
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		
		if(loginVO.getUserSe().equals("MASTER")){
			paramMap.put("orgSeq", loginVO.getGroupSeq());
			mv.addObject("orgSeq", loginVO.getGroupSeq());
		}
		else if(loginVO.getUserSe().equals("ADMIN")){
			paramMap.put("orgSeq", loginVO.getCompSeq());
			mv.addObject("orgSeq", loginVO.getCompSeq());
		}
		//마스터가 회사를 선택했을 경우(회사정보관리 페이지)
		if(paramMap.get("compSeq") != null){
			if(!paramMap.get("compSeq").toString().equals("")){
				paramMap.put("orgSeq", paramMap.get("compSeq").toString());
				mv.addObject("orgSeq", paramMap.get("compSeq").toString());
			}
		}
		
		List<Map<String, Object>> loginImg = groupManageService.getMsgLoginLogoImgFile(paramMap);
		List<Map<String, Object>> mainTopImg = groupManageService.getMsgMainTopImgFile(paramMap);
		
		
		
		
		JSONArray jsonArrLoginImg=new JSONArray();
		JSONArray jsonArrMainTopImg=new JSONArray();

		for(Map<String, Object> map:loginImg){
			JSONObject jsonObj = new JSONObject();
			for(Map.Entry<String, Object> entry : map.entrySet()){
				String key = entry.getKey();
				Object value = entry.getValue();
				try{
					jsonObj.put(key, value);
				}catch(JSONException e){
					e.printStackTrace();
				}
			}
			jsonArrLoginImg.add(jsonObj);
		}
		
		
		for(Map<String, Object> map:mainTopImg){
			JSONObject jsonObj = new JSONObject();
			for(Map.Entry<String, Object> entry : map.entrySet()){
				String key = entry.getKey();
				Object value = entry.getValue();
				try{
					jsonObj.put(key, value);
				}catch(JSONException e){
					e.printStackTrace();
				}
			}
			jsonArrMainTopImg.add(jsonObj);
		}
		
		mv.addObject("loginImg", jsonArrLoginImg);
		mv.addObject("mainTopImg", jsonArrMainTopImg);
		
		mv.addAllObjects(paramMap);
		
		mv.setViewName("/neos/cmm/systemx/group/pop/groupMsgLogoUploadPop");

		return mv;
	}
	
	
	
	@RequestMapping("/cmm/systemx/groupMainTopLogoUploadPop.do")
	public ModelAndView groupMainTopLogoUploadPop(@RequestParam Map<String,Object> paramMap,
			HttpServletRequest request, HttpServletResponse response) throws Exception {

		ModelAndView mv = new ModelAndView();
		
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		
		if(loginVO.getUserSe().equals("MASTER")){
			paramMap.put("orgSeq", loginVO.getGroupSeq());
			mv.addObject("orgSeq", loginVO.getGroupSeq());
		}
		else if(loginVO.getUserSe().equals("ADMIN")){
			paramMap.put("orgSeq", loginVO.getCompSeq());
			mv.addObject("orgSeq", loginVO.getCompSeq());
		}
		//마스터가 회사를 선택했을 경우(회사정보관리 페이지)
		if(paramMap.get("compSeq") != null){
			if(!paramMap.get("compSeq").toString().equals("")){
				paramMap.put("orgSeq", paramMap.get("compSeq").toString());
				mv.addObject("orgSeq", paramMap.get("compSeq").toString());
			}
		}
		
		List<Map<String, Object>> mainTopImg = groupManageService.getMainTopLogoImgFile(paramMap);
		
		
		
		
		JSONArray jsonArrMainTopImg=new JSONArray();

		for(Map<String, Object> map:mainTopImg){
			JSONObject jsonObj = new JSONObject();
			for(Map.Entry<String, Object> entry : map.entrySet()){
				String key = entry.getKey();
				Object value = entry.getValue();
				try{
					jsonObj.put(key, value);
				}catch(JSONException e){
					e.printStackTrace();
				}
			}
			jsonArrMainTopImg.add(jsonObj);
		}
		
		
		mv.addObject("mainTopImg", jsonArrMainTopImg);
		
		mv.addAllObjects(paramMap);
		
		mv.setViewName("/neos/cmm/systemx/group/pop/groupMainTopLogoUploadPop");

		return mv;
	}
	
	
	@RequestMapping("/cmm/systemx/groupMainFootLogoUploadPop.do")
	public ModelAndView groupMainFootLogoUploadPop(@RequestParam Map<String,Object> paramMap,
			HttpServletRequest request, HttpServletResponse response) throws Exception {

		ModelAndView mv = new ModelAndView();
		
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		
		if(loginVO.getUserSe().equals("MASTER")){
			paramMap.put("orgSeq", loginVO.getGroupSeq());
			mv.addObject("orgSeq", loginVO.getGroupSeq());
		}
		else if(loginVO.getUserSe().equals("ADMIN")){
			paramMap.put("orgSeq", loginVO.getCompSeq());
			mv.addObject("orgSeq", loginVO.getCompSeq());
		}
		//마스터가 회사를 선택했을 경우(회사정보관리 페이지)
		if(paramMap.get("compSeq") != null){
			if(!paramMap.get("compSeq").toString().equals("")){
				paramMap.put("orgSeq", paramMap.get("compSeq").toString());
				mv.addObject("orgSeq", paramMap.get("compSeq").toString());
			}
		}
		
		List<Map<String, Object>> mainFootImg = groupManageService.getMainFootImgFile(paramMap);
		
		paramMap.put("imgType", "TEXT_COMP_FOOTER");		
		Map<String,Object> txtMap = groupManageService.getOrgDisplayText(paramMap);
		mv.addObject("txtMap", txtMap);
		
		
		JSONArray jsonArrMainFootImg=new JSONArray();

		for(Map<String, Object> map:mainFootImg){
			JSONObject jsonObj = new JSONObject();
			for(Map.Entry<String, Object> entry : map.entrySet()){
				String key = entry.getKey();
				Object value = entry.getValue();
				try{
					jsonObj.put(key, value);
				}catch(JSONException e){
					e.printStackTrace();
				}
			}
			jsonArrMainFootImg.add(jsonObj);
		}
		
		mv.addObject("imgMap", mainFootImg);
		
		mv.addObject("mainFootImg", jsonArrMainFootImg);
		
		mv.addAllObjects(paramMap);
		
		mv.setViewName("/neos/cmm/systemx/group/pop/groupMainFootLogoUploadPop");

		return mv;
	}
	
	
	@RequestMapping("/cmm/systemx/group/setLoginImgType.do")
	public ModelAndView setLoginImgType(@RequestParam Map<String,Object> paramMap,
			HttpServletRequest request, HttpServletResponse response) throws Exception {

		ModelAndView mv = new ModelAndView();
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		
		paramMap.put("groupSeq", loginVO.getGroupSeq());
		
		groupManageService.setLoginImgType(paramMap);
		
		mv.setViewName("jsonView");

		return mv;
	}	
	
	@RequestMapping("/cmm/systemx/group/test.do")
	public ModelAndView test(@RequestParam Map<String,Object> paramMap,
			HttpServletRequest request, HttpServletResponse response) throws Exception {

		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");

		return mv;
	}
	
	@RequestMapping("/cmm/systemx/groupManage/groupListView.do")
	public ModelAndView getGroupListView(@RequestParam Map<String,Object> paramMap) {
		
		ModelAndView mv = new ModelAndView();		
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		
		boolean isAuthMenu = menuManageService.checkIsAuthMenu(paramMap, loginVO);
		if(!isAuthMenu){
			mv.setViewName("redirect:/forwardIndex.do");			
			return mv;
		}
		
		mv.setViewName("/neos/cmm/systemx/groupManage/groupListView");

		return mv;

	}
	
	@RequestMapping("/cmm/systemx/groupManage/getGroupData.do")
	public ModelAndView getGroupList(@RequestParam Map<String,Object> paramMap) {
		ModelAndView mv = new ModelAndView();
		
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		
		List<Map<String, Object>> groupList = new ArrayList<Map<String,Object>>();
		
		paramMap.put("langCode", loginVO.getLangCode());
		
		groupList = groupManageService.getGroupList(paramMap);
		
		JSONArray groupListJson = JSONArray.fromObject(groupList);
		
		mv.addObject("groupList", groupListJson);
		
		mv.setViewName("jsonView");

		return mv;

	}

	@RequestMapping("/cmm/systemx/groupManage/groupSave.do")
	public ModelAndView groupSave(@RequestParam Map<String, Object> paramMap) {
		ModelAndView mv = new ModelAndView();
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		Map<String, Object> groupSeq = null;		// 그룹 아이디
		
		groupSeq = groupManageService.selectGroupSeq();
		
		paramMap.put("empSeq", loginVO.getUniqId()+"");
		paramMap.put("groupSeq", loginVO.getGroupSeq()+"");
		paramMap.put("grouppingSeq", groupSeq.get("seq")+"");
		paramMap.put("useYn", "Y");
		
		groupManageService.groupSave(paramMap);
		
		mv.setViewName("jsonView");
		return mv;
	}
	
	@RequestMapping("/cmm/systemx/groupManage/groupDel.do")
	public ModelAndView groupDel(@RequestParam Map<String, Object> paramMap) {
		ModelAndView mv = new ModelAndView();
	
		//paramMap.put("grouppingSeq", paramMap.get("grouppingSeq")+"");
		// 기존 등록 회사 삭제
		groupManageService.groupingCompDel(paramMap);
		
		groupManageService.groupDel(paramMap);
		
		mv.setViewName("jsonView");
		return mv;
	}

	
	@RequestMapping("/cmm/systemx/groupManage/allCompList.do")
	public ModelAndView allCompList(@RequestParam Map<String, Object> paramMap) {
		ModelAndView mv = new ModelAndView();
		
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		
		paramMap.put("gbnOrgList", "'c'");
		paramMap.put("langCode", loginVO.getLangCode());
		paramMap.put("groupSeq", loginVO.getGroupSeq());
		paramMap.put("gubun", "gubun");
		
		/* 조직도 조회 */
		List<Map<String,Object>> list = orgChartService.selectCompBizDeptListAdmin(paramMap);
		
		mv.addObject("compList", list);
		mv.setViewName("jsonView");
		
		return mv;
	}
	
	@RequestMapping("/cmm/systemx/groupManage/groupingComp.do")
	public ModelAndView groupingComp(@RequestParam Map<String, Object> paramMap) {
		ModelAndView mv = new ModelAndView();
		
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		
		List<Map<String, Object>> groupingComp = new ArrayList<Map<String,Object>>();
		
		paramMap.put("gbnOrgList", "'c'");
		paramMap.put("langCode", loginVO.getLangCode());
		paramMap.put("groupSeq", loginVO.getGroupSeq());

		groupingComp = orgChartService.selectCompBizDeptListAdmin(paramMap);
		JSONArray groupingCompJson = JSONArray.fromObject(groupingComp);
		mv.addObject("groupingComp", groupingCompJson);

		
		
		mv.setViewName("jsonView");
		
		return mv;
	}
	
	@RequestMapping("/cmm/systemx/groupManage/groupingCompAdd.do")
	public ModelAndView groupingCompAdd(@RequestBody Map<String, Object> paramMap) {
		ModelAndView mv = new ModelAndView();
		
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		paramMap.put("empSeq", loginVO.getUniqId());
		paramMap.put("useYn", "Y");
		
		// 기존 데이터 있을 시 삭제
		groupManageService.groupingCompDel(paramMap);
		groupManageService.groupingCompAdd(paramMap);
		
		mv.setViewName("jsonView");
		return mv;
	}
	
	@RequestMapping("/cmm/systemx/groupManage/groupAddPop.do")
	public ModelAndView groupAddPop(@RequestParam Map<String, Object> paramMap) {
		ModelAndView mv = new ModelAndView();
		mv.setViewName("/neos/cmm/systemx/groupManage/groupAddPop");
		return mv;
	}	
	
	@RequestMapping("/cmm/systemx/groupManage/groupInfo.do")
	public ModelAndView groupInfo(@RequestParam Map<String, Object> paramMap) {
		ModelAndView mv = new ModelAndView();

		List<Map<String, Object>> groupInfo = new ArrayList<Map<String, Object>>();
			
		groupInfo = groupManageService.groupInfo(paramMap);
		mv.addObject("groupInfo", groupInfo);
		mv.setViewName("jsonView");
	
		return mv;
	}

	@RequestMapping("/cmm/systemx/groupManage/groupInfoUpdate.do")
	public ModelAndView groupInfoUpdate(@RequestParam Map<String, Object> paramMap) {
		ModelAndView mv = new ModelAndView();
		
		groupManageService.groupInfoUpdate(paramMap);
		
		mv.setViewName("jsonView");
		
		return mv;
	}
	
	@RequestMapping("/getGroupInfo.do")
	public ModelAndView getGroupInfo(@RequestParam Map<String, Object> paramMap) {
		ModelAndView mv = new ModelAndView();
		
		Map<String, Object> groupInfo = groupManageService.getGroupInfo(paramMap);
		mv.addObject("groupInfo", groupInfo);
		mv.setViewName("jsonView");
		
		return mv;
	}
	
	
}
