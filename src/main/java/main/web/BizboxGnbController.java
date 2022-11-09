package main.web;

import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Calendar;
import java.util.Date;
import java.util.GregorianCalendar;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.log4j.Logger;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import com.fasterxml.jackson.core.JsonParseException;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.JsonMappingException;
import com.fasterxml.jackson.databind.ObjectMapper;

import api.helpdesk.constants.HelpdeskConstants;
import api.helpdesk.service.HelpdeskService;
import bizbox.orgchart.service.vo.LoginVO;
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
import neos.cmm.systemx.group.service.GroupManageService;
import neos.cmm.systemx.orgchart.service.OrgChartService;
import neos.cmm.util.AESCipher;
import neos.cmm.util.BizboxAProperties;
import neos.cmm.util.CommonUtil;
import neos.cmm.util.HttpJsonUtil;
import neos.cmm.util.code.CommonCodeUtil;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;
import net.sf.json.JSONSerializer;
import cloud.CloudConnetInfo;
import api.cloud.service.CloudService;


@Controller
public class BizboxGnbController {
	
	@Resource(name="MenuManageService")
	MenuManageService menuManageService;
	
	@Resource(name="EmpManageService")
	EmpManageService eenuManageService;
	
	@Resource(name="EgovLoginLogService")
	EgovLoginLogService egovLoginLogService;
	
	@Resource(name="loginService")
	EgovLoginService loginService;
	
	@Resource(name="OrgChartService")
	OrgChartService orgChartService;
	
	@Resource(name="MainService")
	MainService mainService;
	
	@Resource(name="CloudService")
	private CloudService cloudService;	
	
	@Resource(name="HelpdeskService")
	private HelpdeskService helpdeskService;
	
	@Resource(name = "CompManageService")
	private CompManageService compManageService;
	
	@Resource(name = "EmpManageService")
    private EmpManageService empManageService;
	
	@Resource(name = "GroupManageService")
	private GroupManageService groupManageService;
	
	@Resource(name = "commonSql")
	private CommonSqlDAO commonSql;
	
	@Resource(name = "bizboxIndexController")
	private BizboxIndexController bizboxIndexController;
	
    @Resource(name="CommonOptionManageService")
    private CommonOptionManageService commonOptionManageService;
    
    protected Logger logger = Logger.getLogger( super.getClass( ) );
	
    @SuppressWarnings("unchecked")
	@RequestMapping("/topGnb.do")
	public ModelAndView topGnb(@RequestParam Map<String,Object> params, HttpServletRequest request) throws Exception {
		
		ModelAndView mv = new ModelAndView();
		
		// 공통옵션 'cm1001' 프로필 수정 여부 옵션 조회 하기 위한 파라미터 변수 
		Map<String, Object> commonOptionParam = new HashMap<String, Object>();
		
		if(request.getSession().getAttribute("loginVO") == null) {
	    	EgovUserDetailsHelper.reSetAuthenticatedUser();
			mv.setViewName("redirect:/uat/uia/actionLogout.do");	
			return mv;
		}
		
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		
		
		String parentOptionValue = null;	// 로그인 통제 사용 여부 (상위)
		String optionValueLogoutTime = null;	// 강제 로그아웃 옵션 값
		String optionValueLogoutType = null;	// 강제 로그아웃 화면옵션 값
		
		/** 사용자 겸직정보 및 미결함, 수신참조함 카운트조회 */
		params.put("empSeq", loginVO.getUniqId());
		params.put("langCode", loginVO.getLangCode());
		params.put("separator", "-");
		params.put("authCheck", "Y");
		
		//eaType 셋팅
		String eaType = loginVO.getEaType() + "";
		if(eaType == null || eaType.equals("")) {
			eaType = "eap";
		}
		
		if(eaType.equals("ea")){
			params.put("eaType", eaType);
			params.put("eaUserSe", loginVO.getUserSe());
			params.put("deptSeq", loginVO.getOrgnztId());
			Map<String, Object> mp = (Map<String, Object>) commonSql.select("OrgChart.getMainDeptYn", params);
			if(mp != null) {
				mv.addObject("mainDeptYn", mp.get("mainDeptYn")+"");
			}
			else {
				mv.addObject("mainDeptYn", "N");
			}
		}else{
			mv.addObject("mainDeptYn", "Y");
		}
    			
		/** 사용자 프로필 */
		params.put("compSeq", loginVO.getCompSeq());
		params.put("groupSeq", loginVO.getGroupSeq());
		params.put("deptSeq", loginVO.getOrgnztId());
		
		if(eaType != null && eaType.equals("ea")) {
			params.put("eaType", eaType);
		}
		
		Map<String,Object> userInfo = (Map<String, Object>) commonSql.select("EmpManage.selectEmp", params);
				
		if (userInfo != null) {
			mv.addObject("picFileId", userInfo.get("picFileId"));
		}
		
		mv.addObject("loginVO", loginVO);
		
		mv.addAllObjects(mainService.userSeSetting(loginVO, params));
		
		if (loginVO.getUserSe().equals("MASTER")) {
			 CommonUtil.getSessionData(request, "selectedCompSeq", mv);
		} 
		
		mv.addObject("empNameInfo", loginVO.getName() + "(" + loginVO.getId() + ")");
		
		//그룹사의 사용자 정보 수정 제한 옵션값을 가져옴 
		commonOptionParam.put("gubunType","single");
		commonOptionParam.put("optionId","cm1000");
		commonOptionParam.put("compSeq", "0");
		
		List<Map<String, Object>>commonParentOption = commonOptionManageService.getOptionSettingValue(commonOptionParam);
		
		//사용자 정보 수정이 가능 하면 값이 1 아니면 0
		if(commonParentOption.get(0).get("optionValueDisplay").equals("1")) {
			//사용자 정보 수정의 하위 옵션인 사진 수정 제한 옵션값을 가져옴 
			commonOptionParam.put("optionId", "cm1001");
			List<Map<String,Object>>commonOption = commonOptionManageService.getOptionSettingValue(commonOptionParam);
			//프로필 사진 수정이 가능하면 값은 0 아니면 1 
			if(commonOption.get(0).get("optionValueDisplay").equals("0")) {
				mv.addObject("profileModifyOption","1");
			}else {
				mv.addObject("profileModifyOption","0");
			}
		}else {
			mv.addObject("profileModifyOption","1");
		}
			
		//개인정보 표시 옵션 가져와 셋팅
	    if(commonOptionManageService.getCommonOptionValue(loginVO.getGroupSeq(), loginVO.getCompSeq(), "cm700").equals("1")){
	    	mv.addObject("optionValue","1");		    
	    }else{
	    	mv.addObject("optionValue","0");
	    }
	    
	    String empPathNm = getEmpPathNm();		    
	    mv.addObject("empPathNm", empPathNm);
				
		/** 공통옵션(강제 로그아웃 시간 설정) 값 가져오기 */
		parentOptionValue = commonOptionManageService.getCommonOptionValue(loginVO.getGroupSeq(), loginVO.getCompSeq(), "cm100");
		
		if(BizboxAProperties.getCustomProperty("BizboxA.Cust.ScriptAppendYn").equals("Y")){
			String mainPortalYn = params.get("mainPortalYn") == null ? "N" : params.get("mainPortalYn").toString();
			
			if(!BizboxAProperties.getCustomProperty("BizboxA.Cust.ScriptAppendMainPortalOnly").equals("Y") || mainPortalYn.equals("Y")){
				mv.addObject("ScriptAppendYn", "Y");	
				mv.addObject("ScriptAppendUrl", BizboxAProperties.getCustomProperty("BizboxA.Cust.ScriptAppendUrl"));
				mv.addObject("ScriptAppendFunction", BizboxAProperties.getCustomProperty("BizboxA.Cust.ScriptAppendFunction"));
				mv.addObject("TokTokSSLUseYn", BizboxAProperties.getCustomProperty("BizboxA.Cust.TokTokSSLUseYn"));				
			}
		}
		
		// 상위 옵션 사용
		if(parentOptionValue.equals("1")) {
			optionValueLogoutTime = commonOptionManageService.getCommonOptionValue(loginVO.getGroupSeq(), loginVO.getCompSeq(), "cm102");
			optionValueLogoutType = commonOptionManageService.getCommonOptionValue(loginVO.getGroupSeq(), loginVO.getCompSeq(), "cm102_1");
			
			Calendar calendar = Calendar.getInstance();    
			calendar.set(Calendar.MILLISECOND, 0); // Clear the millis part. Silly API.
			calendar.set(1970, 1, 1, 0, 0, 0); // Note that months are 0-based
			Date date = calendar.getTime();
			long fixTime = date.getTime() / 10000; // Millis since Unix epoch
		
			SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss.SSS");
			String dateInString1 = loginVO.getLastLoginDateTime();
			Date date1 = sdf.parse(dateInString1);
			long loginTime = date1.getTime();
			
			request.getSession().setAttribute("logoutFlag", "N");
			
			mv.addObject("standTime", fixTime);
			mv.addObject("optionValueLogoutTime", optionValueLogoutTime);
			mv.addObject("optionValueLogoutType", optionValueLogoutType);
			mv.addObject("logonTime", loginTime);
		}
		
		mv.addObject("parentOptionValue", parentOptionValue);
		
		
		/** 그룹정보 가져오기 */
		params.put("groupSeq", loginVO.getGroupSeq());
		Map<String,Object> groupMap = orgChartService.getGroupInfo(params);
		String groupDomain = BizboxAProperties.getProperty("BizboxA.groupware.domin");
		
		if(groupDomain.indexOf("http://") != -1) {
			groupDomain = groupDomain.replace("http://", "");
		}
		if(groupDomain.indexOf("https://") != -1) {
			groupDomain = groupDomain.replace("https://", "");
		}

		groupMap.put("groupDomain", groupDomain);
		mv.addObject("groupMap", groupMap);
		
		/** 관리자 권한 체크 */
		int cnt = CommonUtil.getIntNvl(mainService.selectAdminAuthCnt(params));
		if (cnt > 0) {
			mv.addObject("isAdminAuth", true);
		}
		
		// 마스터 권한 여부 체크 
		int mCnt = CommonUtil.getIntNvl(mainService.selectMasterAuthCnt(params));
		if (mCnt > 0) {
			mv.addObject("isMasterAuth", true);
			
			mv.addObject("helpDeskApiInfo", HelpdeskConstants.HELPDESK_APIINFO);
			mv.addObject("noticeContents", HelpdeskConstants.NOTICE_CONTENTS);
		}
		
		/** 메인 상단로고 가져오기 및 브라우저 타이틀 가져오기 */
		if(!loginVO.getUserSe().equals("MASTER")){
			params.put("imgType", "IMG_COMP_LOGO");
			Map<String,Object> imgMap = compManageService.getOrgImg(params);
			mv.addObject("imgMap", imgMap);
			
			params.put("compSeq", loginVO.getCompSeq());
			params.put("langCode", loginVO.getLangCode());
			Map<String, Object> titleMap = compManageService.getTitle(params);
			
			if(titleMap != null && !(titleMap.get("compDisplayName")+"").equals("")){
				mv.addObject("titleMap", titleMap);	
			}else{
				Map<String, Object> titleGroupMap = new HashMap<String, Object>();
				titleGroupMap.put("compDomain", groupDomain);
				titleGroupMap.put("compDisplayName", groupMap.get("groupDisplayName"));
				mv.addObject("titleMap", titleGroupMap);
			}
		}else{
			params.put("imgType", "IMG_COMP_LOGO");
			Map<String,Object> imgMap = compManageService.getOrgImg(params);
			mv.addObject("imgMap", imgMap);			
			
			Map<String, Object> titleMap = new HashMap<String, Object>();
			titleMap.put("compDomain", groupDomain);
			titleMap.put("compDisplayName", groupMap.get("groupDisplayName"));
			mv.addObject("titleMap", titleMap);		
		}
		
		String totalSearchOptionValue = commonOptionManageService.getCommonOptionValue(loginVO.getGroupSeq(), loginVO.getCompSeq(), "cm1800");
		
		/** 직급/직책 옵션 가져오기 */
		/* 2017.05.29 장지훈 추가 (직급/직책 옵션값 추가)
		 * positionDutyOptionValue = 0 : 직급 (default)
		 * positionDutyOptionValue = 1 : 직책
		 * */
		String positionDutyOptionValue = commonOptionManageService.getCommonOptionValue(loginVO.getGroupSeq(), loginVO.getCompSeq(), "cm1900");
		String displayPositionDuty = "";
		
		
		if(positionDutyOptionValue == null) {
			displayPositionDuty = "position";
		} else if(positionDutyOptionValue.equals("0")){
			displayPositionDuty = "position";
		} else if(positionDutyOptionValue.equals("1")) {
			displayPositionDuty = "duty";
		}
		
		mv.addObject("displayPositionDuty", displayPositionDuty);
		mv.addObject("totalSearchOptionValue",totalSearchOptionValue);
	    mv.addObject("userType", "USER");
		
		List<Map<String, String>> mentionOption = CommonCodeUtil.getCodeList("mentionUseYn");
		if(mentionOption != null && mentionOption.size() > 0) {
			mv.addObject("mentionUseYn","Y");
		}
		else {
			mv.addObject("mentionUseYn","N");
		}
		
		if(CloudConnetInfo.getBuildType().equals("cloud")){
			mv.addObject("cloudYn", "Y");
			mv.addObject("profilePath", "/upload/" + loginVO.getGroupSeq() + "/img/profile/" + loginVO.getGroupSeq());
			mv.addObject("uploadPathBase", "/upload/" + loginVO.getGroupSeq() + "/");
		}else{
			mv.addObject("cloudYn", "N");
			mv.addObject("profilePath", "/upload/img/profile/" + loginVO.getGroupSeq());
			mv.addObject("uploadPathBase", "/upload/");
		}
		
		if(params.get("portalDiv") != null && params.get("portalDiv").equals("cloud")){
			mv.addObject("type", params.get("type"));
			mv.setViewName("/main/include/cloudGnb");
			
			if(params.get("type") == null || !params.get("type").equals("cloudSub")){
				mv.addObject("topMenuList", mainService.getTopMenuList(loginVO));
			}
			
		}else{
			mv.setViewName("/main/include/topGnb");
			mv.addObject("topMenuList", mainService.getTopMenuList(loginVO));
		}
		
		//강제로그아웃 여부
		if(!BizboxAProperties.getCustomProperty("BizboxA.Cust.CustLogon").equals("99")) {
			//패키지 자체 로그인 페이지를 사용하지 않는 경우 forceLogoutYn : N 고정
			mv.addObject("forceLogoutYn", "N");
		}else if(request.getSession().getAttribute("forceLogoutYn") != null) {
			mv.addObject("forceLogoutYn", request.getSession().getAttribute("forceLogoutYn"));
			request.getSession().removeAttribute("forceLogoutYn");
		}
		
		//로그인 후 최초 진입여부
		if(request.getSession().getAttribute("firstGnbRenderTp") != null) {

			mv.addObject("bizboxCloudNoticeInfo", cloudService.getBizboxCloudNoticeInfo());
			mv.addObject("firstGnbRenderTp", request.getSession().getAttribute("firstGnbRenderTp"));
			request.getSession().removeAttribute("firstGnbRenderTp");
			
		}
		
		mv.addObject("compMailUrl", loginVO.getUrl());
		
		return mv;
	}
	
    @SuppressWarnings("unchecked")
	@RequestMapping("/footer.do")
	public ModelAndView footer(@RequestParam Map<String,Object> params, HttpServletRequest request) throws Exception {
		
    	ModelAndView mv = new ModelAndView();
    	
		LoginVO user = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		
		Map<String,Object> optionObject = new HashMap<String,Object>();
		
		String optionObjectStr = "0|1|2|3|4|5|6";
		
		if(!user.getUserSe().equals("MASTER")){
			params.put("optionList", "'cm850'");
			params.put("compSeq", user.getCompSeq());
			optionObject = commonOptionManageService.getGroupOptionList(params);
			
			if(optionObject.get("cm850") != null){
				optionObjectStr = optionObject.get("cm850").toString();
			}
			
			//하단푸터 텍스트
			String footerText = (String)commonSql.select("CompManage.getFooterText",params);
			
			if(footerText != null && !footerText.equals("")){
				optionObject.put("footerText", footerText);
			}else{
				optionObject.put("footerText", "Copyright © DOUZONE BIZON. All rights reserved.");
			}
		}else {
			
			//백업서비스 조회
			Map<String, Object> backupServiceInfo = (Map<String, Object>) commonSql.select("OrgAdapterManage.selectBackupServiceInfo", params);
			
			if(backupServiceInfo != null) {
				mv.addObject("backupServiceInfo", backupServiceInfo);
			}
			
		}
		
		for(String info : optionObjectStr.split("\\|")){
			optionObject.put("option_" + info, "1");
		}
		
		mv.addObject("optionObject",optionObject);
		
		//후지제록스 복합기 연동정보 조회
		String userSe = user.getUserSe();
		if(userSe.equals("ADMIN") || userSe.equals("MASTER")) {
			params.put("groupSeq", user.getGroupSeq());
			Map<String, Object> groupInfo = (Map<String, Object>) commonSql.select("OrgAdapterManage.selectGroupInfo", params);
			
			if(groupInfo.get("mfpUseYn") != null && groupInfo.get("mfpUseYn").equals("Y") && groupInfo.get("mfpUrl") != null && !groupInfo.get("mfpUrl").equals("")) {
				mv.addObject("mfpUseYn","Y");
				mv.addObject("mfpUrl",groupInfo.get("mfpUrl"));
				
		    	if(!BizboxAProperties.getCustomProperty("BizboxA.Cust.mfpGwDomain").equals("99")) {
		    		mv.addObject("gwDomain", BizboxAProperties.getCustomProperty("BizboxA.Cust.mfpGwDomain"));
		    	}else {
		    		mv.addObject("gwDomain", request.getScheme() + "://" + request.getServerName() + (request.getServerPort() == 80 ? "" : ":" + request.getServerPort()));
		    	}				
			}
			
			if(groupInfo.get("dfUseYn") != null && groupInfo.get("dfUseYn").equals("Y") && groupInfo.get("dfUrl") != null && !groupInfo.get("dfUrl").equals("")) {
				mv.addObject("dfUseYn","Y");
				mv.addObject("dfUrl",groupInfo.get("dfUrl"));
			}			
		}
		
		if(params.get("portalDiv") != null && params.get("portalDiv").equals("cloud")){
			mv.setViewName("/main/include/footerCloud");
		}else{
			mv.setViewName("/main/include/footer");	
		}
		
		return mv;
	}
    
	/**
	 * 사용자 전환
	 * @param params
	 * @param session
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/changeUserSe.do")
	public ModelAndView changeUserSe(@RequestParam Map<String,Object> params, HttpSession session, HttpServletResponse response, HttpServletRequest request, ModelMap model) throws Exception {
		
        Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();
		
		ModelAndView mv = new ModelAndView();
		
		if(!isAuthenticated) {
			mv.setViewName("redirect:/uat/uia/egovLoginUsr.do");
			return mv;
			
		}
		
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		
		if(params.get("userSe").equals("ADMIN")){
			params.put("compSeq", loginVO.getCompSeq());
			params.put("empSeq", loginVO.getUniqId());
			
			/** 관리자 권한 체크 */
			if(CommonUtil.getIntNvl(mainService.selectAdminAuthCnt(params)) == 0){
				params.put("userSe","USER");
			}
		}else if(params.get("userSe").equals("MASTER")){
			params.put("compSeq", loginVO.getCompSeq());
			params.put("empSeq", loginVO.getUniqId());			
			
			/** 마스터 권한 체크 */
			if(CommonUtil.getIntNvl(mainService.selectMasterAuthCnt(params)) == 0){
				params.put("userSe","USER");
			}			
		}		
		
		//스프링 시큐리티 로그인 
		Map<String, Object> springParam = new HashMap<String, Object>();
		String springSecurityKey = UUID.randomUUID().toString().replace("-", "").substring(6);
		springParam.put("empSeq", loginVO.getUniqId());
		springParam.put("springSecurityKey", springSecurityKey + params.get("userSe").toString());
		try {
			loginService.updateSpringSecuKey(springParam);
		} catch (Exception e) {
			logger.error(e.getMessage());
			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
		}
		
		String compAccessDomain = request.getServerName() + (request.getServerPort() == 80 ? "" : ":" + request.getServerPort());		

		mv.setViewName("redirect:/j_spring_security_check?j_username=" + params.get("userSe").toString() + "$" + loginVO.getCompSeq() + "$" + loginVO.getOrgnztId() + "$" + loginVO.getGroupSeq() + "$" + loginVO.getGroupSeq() + springSecurityKey + "$" + loginVO.getIp() + "$" + compAccessDomain + "&j_password=" + loginVO.getUniqId());
		
		Map<String, Object> sessionChangeLog = new HashMap<String, Object>();
		
		sessionChangeLog.put("groupSeq", loginVO.getGroupSeq());
		sessionChangeLog.put("compSeq", loginVO.getCompSeq());
		sessionChangeLog.put("deptSeq", loginVO.getOrgnztId());
		sessionChangeLog.put("empSeq", loginVO.getUniqId());
		sessionChangeLog.put("userSe", params.get("userSe"));
		sessionChangeLog.put("accessIp", loginVO.getIp());		
		
		commonSql.insert("LoginLogDAO.logInsertSessionChangeLog",sessionChangeLog);

		loginVO.setUserSe(params.get("userSe").toString());
		model.addAttribute("loginVO", loginVO);
		request.getSession().setAttribute("loginVO", loginVO);
		
		return mv;
	}
	
	@RequestMapping("/myMenu.do")
	public ModelAndView myMenu(@RequestParam Map<String,Object> params, HttpServletRequest request) throws Exception {
		
		ModelAndView mv = new ModelAndView();
		
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		
		params.put("empSeq", loginVO.getUniqId());
		params.put("deptSeq", loginVO.getOrgnztId());
		params.put("langCode", loginVO.getLangCode());
		params.put("loginId", loginVO.getId());
		params.put("compSeq", loginVO.getCompSeq());
		params.put("groupSeq", loginVO.getGroupSeq());
		params.put("deptSeq", loginVO.getOrgnztId());
		
		
		params.put("groupSeq", loginVO.getGroupSeq());
		
		Map<String,Object> groupMap = orgChartService.getGroupInfo(params);
		
		params.put("edmsUrl", groupMap.get("edmsUrl"));
		
		/** 외부 게시판 리스트 */
		List<Map<String,Object>> boardList = menuManageService.getOuterMenuList(params);
		
		List<Map<String,Object>> myMenuList = mainService.getMyMenuList(params);
		
		String boardNo = "501000000";						// 게시판 2레벨 메뉴번호
		String gnbMenuNm = BizboxAMessage.getMessage("TX000011134","게시판");						// 게시판 구분코드
		String type = "BOARD";						// 게시판 구분코드
		String urlGubun = "edms";						// 게시판 구분코드
		String boardUrl = "/board/viewBoard.do?boardNo=";	// 게시판 url
		
		int no =  Integer.parseInt(boardNo);			
		
		for(Map<String,Object> boardMap : boardList) {
			
			int seq = CommonUtil.getIntNvl(boardMap.get("boardNo")+"");	// 게시판 시퀀스 번호
			
			for(Map<String,Object> myMenuMap : myMenuList) {
				int myMenuNo = CommonUtil.getIntNvl(myMenuMap.get("menuNo")+"");
				
				if(myMenuNo == no + seq) {
					myMenuMap.put("menuNm", boardMap.get("board_title")+"");
					myMenuMap.put("urlPath", boardUrl+seq);
					myMenuMap.put("menuImgClass", "bd");
					myMenuMap.put("gnbMenuNo", boardNo);
					myMenuMap.put("gnbMenuNm", gnbMenuNm);
					myMenuMap.put("urlGubun", urlGubun);
					myMenuMap.put("seq", "seq");
					myMenuMap.put("type", type);
				}
			}
		}
		
		
		mv.addObject("myMenuList", myMenuList);
		
		mv.setViewName("/main/include/myMenu");
		
		return mv;
	}
	
	@RequestMapping("/myMenuSetPop.do")
	public ModelAndView myMenuSetPop(@RequestParam Map<String,Object> params, HttpServletRequest request) throws Exception {
		
		ModelAndView mv = new ModelAndView();
		
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		
		params.put("empSeq", loginVO.getUniqId());
		params.put("deptSeq", loginVO.getOrgnztId());
		params.put("langCode", loginVO.getLangCode());
		params.put("compSeq", loginVO.getCompSeq());
		params.put("loginId", loginVO.getId());
		params.put("startWith", 0);
		params.put("authCodeList", loginVO.getAuthorCode().split("#"));
		params.put("groupSeq", loginVO.getGroupSeq());
		params.put("bizSeq", loginVO.getBizSeq());
		
		Map<String,Object> groupMap = orgChartService.getGroupInfo(params);
		
		params.put("edmsUrl", groupMap.get("edmsUrl"));
	
		
		/** 권한을 갖고 있는 모든 메뉴 조회 */
		List<Map<String,Object>> menuList = menuManageService.selectMenuTreeList(params);
		
		/** 외부 게시판정보 조회*/
		List<Map<String,Object>> boardList = menuManageService.getOuterMenuList(params);

		/** 최종 메뉴 리스트 */
		List<Map<String,Object>> mList = menuManageService.getSiteMapList(menuList, boardList);
		
		
		List<Map<String,Object>> myMenuList = mainService.getMyMenuList(params);
		
		/** jsp에 넘길 메뉴 리스트(열 -> 행) */
		List<Map<String,Object>> list = new ArrayList<Map<String,Object>>();
		Map<String,Object> map = new HashMap<String,Object>();
		list.add(map);
		
		List<String> gubunList = new ArrayList<String>();
		
		/** html table 형태로 변경(열->행) */
		int tdIdx = 0;
		int trIdx = 0;
		String tmpG = null;
		if (mList != null) {
			for(int i = 0; i < mList.size(); i++) {
				Map<String,Object> m = mList.get(i);		// DB Menu Map
				String g = m.get("menuGubun")+"";			// Menu 구분
				if (tmpG == null) {							// 임시저장 Menu 구분값 초기화	
					tmpG = g;	
					gubunList.add(g);
				}			
				
				if (tmpG.equals(g)) {						// 임시저장 Menu와 현재 Menu 구분이 같다면 신규 Map 증가. 다만 기존 row Map이 있는지 확인
					if (list.size() > trIdx) {				// list 보다 row수가 적을 경우
						map = list.get(trIdx);				// list에서 기존 row map을 가져옴
					} else {
						 map = new HashMap<String,Object>();// 아닌 경우 신규 map을 생성
						 list.add(map);	
					}
				} else {									// 임시저장 Menu와 현재 Menu 구분이 다르다면 신규 td
//					System.out.println(list.size());
					gubunList.add(g);
					tmpG = g;
					trIdx = 0;								// row 수 초기화
					tdIdx++;								// td 증가
					map = list.get(trIdx);				// list에서 기존 row map을 가져옴
				} 
				m.put("isChecked", mainService.isMyMenuCheck(myMenuList, m));
				
				map.put(g+tdIdx, m);						// map에 menu 정보 저장
				
				trIdx++;									// row 수 증가
			}
		}
		
		mv.addObject("menuList", list);
		
		mv.addObject("gubunList", gubunList);
		
		mv.addObject("result", params.get("result"));
		 
		mv.setViewName("/main/pop/myMenuSetPop");
		
		return mv;
	}
			
	@RequestMapping("/myMenuSetPopSaveProc.do")
	public ModelAndView myMenuSetPopSaveProc(@RequestParam Map<String,Object> params, HttpServletRequest request) throws Exception {
		
		ModelAndView mv = new ModelAndView();
		
		String[] menuNoList = request.getParameterValues("menuNo");
		
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		
		List<Map<String,Object>> paramList = new ArrayList<Map<String,Object>>();
		
		for(String s : menuNoList) {
			Map<String,Object> p = new HashMap<String,Object>();
			p.put("menuNo", s);
			p.put("empSeq", loginVO.getUniqId());
			p.put("deptSeq", loginVO.getOrgnztId());
			p.put("compSeq", loginVO.getCompSeq());
			
			paramList.add(p);
		}
		int r = 0;
		if (paramList.size() > 0) {
			params.put("empSeq", loginVO.getUniqId());
			params.put("deptSeq", loginVO.getOrgnztId());
			 
			/** 메뉴 정보 삭제(사용자,부서) */
			mainService.deleteMyMenuList(params);
			
			/** 메뉴 설정 입력 */
			Map<String, Object> menuMp = new HashMap<String, Object>();
			menuMp.put("menuList", paramList);
			mainService.insertMyMenuList(menuMp);
			r = paramList.size();
			
		}
		
		mv.setViewName("redirect:myMenuSetPop.do?result="+r);
		
		return mv;
	}
	
	/**
	 * 알림 정보 조회	
	 * @param params
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings("static-access")
	@RequestMapping("/alertInfo.do")
	public ModelAndView alertInfo(@RequestParam Map<String,Object> params, HttpServletRequest request) throws Exception {
		
		ModelAndView mv = new ModelAndView();
		
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		//eaType 셋팅
		String eaType = loginVO.getEaType() + "";
		if(eaType == null || eaType.equals("")) {
			eaType = "eap";
		}
		
		mv.addObject("loginVO", loginVO);
		
		// 알림 조회 API호출(전체)
		String jsonParam =	"{\"header\":{";
		jsonParam +=	    "\"groupSeq\":\"" + loginVO.getGroupSeq() + "\",";
		jsonParam +=	    "\"empSeq\":\"" + loginVO.getUniqId() + "\"},";
		jsonParam +=	    "\"body\":{";
		jsonParam +=	    "\"timeStamp\":\"" + System.currentTimeMillis() + "\",";
		jsonParam +=	    "\"reqType\":\"" + "2" + "\",";
		jsonParam +=	    "\"reqSubType\":\"" + "N" + "\",";
		jsonParam +=	    "\"pageSize\":\"" + "30" + "\",";
		jsonParam +=	    "\"newYn\":\"" + "N" + "\",";
		jsonParam +=	    "\"mentionYn\":\"" + "N" + "\",";
		jsonParam +=	    "\"langCode\":\"" + loginVO.getLangCode() + "\"}}";

		String apiUrl = CommonUtil.getApiCallDomain(request) + "/event/common/AlertList";
//			String apiUrl = "http://bizboxa.duzonnext.com/event/common/AlertList";
		 
		JSONObject jsonObject2 = JSONObject.fromObject(JSONSerializer.toJSON(jsonParam));
		HttpJsonUtil httpJson = new HttpJsonUtil();
		
		Logger.getLogger( BizboxGnbController.class ).debug( "AlertCall-start : apiUrl=" + apiUrl + ", jsonObject2=" + jsonObject2.toString() );
		String alertList = httpJson.execute("POST", apiUrl, jsonObject2);			
		Logger.getLogger( BizboxGnbController.class ).debug( "AlertCall-end : alertList=" + alertList );
		
		alertList = alertList.replaceAll("\'", "&#39;");
		alertList = alertList.replaceAll("<", "&lt;");
		alertList = alertList.replaceAll(">'", "&gt;");
		
		
		// 알림 조회 API호출(멘션만)
		jsonParam =	        "{\"header\":{";
		jsonParam +=	    "\"groupSeq\":\"" + loginVO.getGroupSeq() + "\",";
		jsonParam +=	    "\"empSeq\":\"" + loginVO.getUniqId() + "\"},";
		jsonParam +=	    "\"body\":{";
		jsonParam +=	    "\"timeStamp\":\"" + System.currentTimeMillis() + "\",";
		jsonParam +=	    "\"reqType\":\"" + "2" + "\",";
		jsonParam +=	    "\"reqSubType\":\"" + "N" + "\",";
		jsonParam +=	    "\"pageSize\":\"" + "30" + "\",";
		jsonParam +=	    "\"newYn\":\"" + "N" + "\",";
		jsonParam +=	    "\"mentionYn\":\"" + "Y" + "\",";
		jsonParam +=	    "\"langCode\":\"" + loginVO.getLangCode() + "\"}}";
		 
		jsonObject2 = JSONObject.fromObject(JSONSerializer.toJSON(jsonParam));
		httpJson = new HttpJsonUtil();
		
		Logger.getLogger( BizboxGnbController.class ).debug( "AlertCall-start : apiUrl=" + apiUrl + ", jsonObject2=" + jsonObject2.toString() );		
		String mentionList = httpJson.execute("POST", apiUrl, jsonObject2);
		Logger.getLogger( BizboxGnbController.class ).debug( "AlertCall-end : mentionList=" + mentionList );
		
		mentionList = mentionList.replaceAll("\'", "&#39;");
		mentionList = mentionList.replaceAll("<", "&lt;");
		mentionList = mentionList.replaceAll(">'", "&gt;");
		
		ObjectMapper om = new ObjectMapper();
		Map<String, Object> m = om.readValue(alertList, new TypeReference<Map<String, Object>>(){});
		mv.addObject("alertList", m);
		
		m = om.readValue(mentionList, new TypeReference<Map<String, Object>>(){});
		mv.addObject("mentionList", m);
		
		if(CloudConnetInfo.getBuildType().equals("cloud")){
			mv.addObject("profilePath", "/upload/" + loginVO.getGroupSeq() + "/img/profile/" + loginVO.getGroupSeq());
		}else{
			mv.addObject("profilePath", "/upload/img/profile/" + loginVO.getGroupSeq());
		}
		
		mv.setViewName("/main/include/alertInfo");
		
		return mv;
		
	}
	
	
	//추가알림 10개 조회
	@SuppressWarnings("static-access")
	@RequestMapping("/alertAddInfo.do")
	public ModelAndView alertAddInfo(@RequestParam Map<String,Object> params, HttpServletRequest request) throws Exception {
		
		ModelAndView mv = new ModelAndView();
		
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		
		// 알림 조회 API호출(전체)
		String mentionYn = params.get("mentionYn") == null ? "N" : params.get("mentionYn")+"";
		
		if(params.get("timeStamp").toString().equals("0")) {
			params.put("timeStamp", System.currentTimeMillis());
		}
		
		String eventType = "";
		
		if(params.get("eventType") != null && !params.get("eventType").toString().equals("")){
			eventType = params.get("eventType").toString();
		}
		
		String jsonParam =	"{\"header\":{";
		jsonParam +=	    "\"groupSeq\":\"" + loginVO.getGroupSeq() + "\",";
		jsonParam +=	    "\"empSeq\":\"" + loginVO.getUniqId() + "\"},";
		jsonParam +=	    "\"body\":{";
		jsonParam +=	    "\"timeStamp\":\"" + params.get("timeStamp") + "\",";
		jsonParam +=	    "\"reqType\":\"" + "2" + "\",";
		jsonParam +=	    "\"reqSubType\":\"" + "N" + "\",";
		jsonParam +=	    "\"pageSize\":\"" + "30" + "\",";
		jsonParam +=	    "\"newYn\":\"" + "N" + "\",";
		jsonParam +=	    "\"mentionYn\":\"" + mentionYn + "\",";
		jsonParam +=	    "\"eventType\":\"" + eventType.toUpperCase() + "\",";
		jsonParam +=	    "\"langCode\":\"" + loginVO.getLangCode() + "\"}}";
		

		String apiUrl = CommonUtil.getApiCallDomain(request) + "/event/common/AlertList";
//		String apiUrl = "http://bizboxa.duzonnext.com/event/common/AlertList";
		 
		JSONObject jsonObject2 = JSONObject.fromObject(JSONSerializer.toJSON(jsonParam));
		HttpJsonUtil httpJson = new HttpJsonUtil();
		String alertList = httpJson.execute("POST", apiUrl, jsonObject2);
		alertList = alertList.replaceAll("\'", "&#39;");
		alertList = alertList.replaceAll("<", "&lt;");
		alertList = alertList.replaceAll(">'", "&gt;");
		
		mv.addObject("alertList", alertList);	
		
		mv.setViewName("jsonView");
		
		return mv;
	}
	
	@RequestMapping("/alertCnt.do")
	public ModelAndView alertCnt(@RequestParam Map<String,Object> params, HttpServletRequest request) throws Exception {
		
		ModelAndView mv = new ModelAndView();
		
		
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		if (loginVO != null) {
			params.put("empSeq", loginVO.getUniqId());
			params.put("compSeq", loginVO.getCompSeq());
			params.put("deptSeq", loginVO.getOrgnztId());
			params.put("langCode", loginVO.getLangCode());

			Map<String,Object> alertReadInfo = mainService.selectAlertReceiverReadCnt(params);

			mv.addObject("alertCnt", alertReadInfo.get("alertCnt"));

		}
		
		mv.setViewName("jsonView");
		
		return mv;
	}
	
	
	@SuppressWarnings("unchecked")
	@RequestMapping("/alertUnreadCnt.do")
	public ModelAndView alertUnreadCnt(@RequestParam Map<String,Object> params, HttpServletRequest request) throws Exception {
		
		ModelAndView mv = new ModelAndView();
		
		
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		if (loginVO != null) {
			
			JSONObject jsonObj = new JSONObject();
			JSONObject header = new JSONObject();
			JSONObject body = new JSONObject();
			
			header.put("groupSeq", loginVO.getGroupSeq());
			header.put("empSeq", loginVO.getUniqId());
			
			jsonObj.put("header", header);
			jsonObj.put("body", body);
					
			String apiUrl = CommonUtil.getApiCallDomain(request) + "/event/common/CheckAlertNotify";
//			String apiUrl = "http://bizboxa.duzonnext.com/event/common/CheckAlertNotify";
			
			Map<String, Object> result = callApiToMap(jsonObj, apiUrl);
			Map<String, Object> cntResult = (Map<String, Object>) result.get("result");
			
			mv.addObject("alertNotifyYn", cntResult.get("alertNotifyYn").toString());
			
			
			apiUrl = CommonUtil.getApiCallDomain(request) + "/event/common/AlertUnreadCount";
//			apiUrl = "http://bizboxa.duzonnext.com/event/common/AlertUnreadCount";
			body.put("mentionYn", "Y");
			jsonObj.put("body", body);
			
			result = callApiToMap(jsonObj, apiUrl);
			cntResult = (Map<String, Object>) result.get("result");
			
			mv.addObject("alertMentionCnt", cntResult.get("alertCnt").toString());
		}		
		mv.setViewName("jsonView");
		
		return mv;
	}
	
	
	@RequestMapping("/alertReadCheckProc.do")
	public ModelAndView alertReadCheckProc(@RequestParam Map<String,Object> params, HttpServletRequest request) throws Exception {
		
		ModelAndView mv = new ModelAndView();
		
		
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		
		params.put("empSeq", loginVO.getUniqId());
		params.put("compSeq", loginVO.getCompSeq());
		params.put("groupSeq", loginVO.getGroupSeq());
		params.put("deptSeq", loginVO.getOrgnztId());
		
		int r = mainService.updateAlertReceiver(params);
		
		mv.addObject("result", r);
		
		mv.setViewName("jsonView");
		
		return mv;
	}
	
	
	@RequestMapping("/alertDeleteProc.do")
	public ModelAndView alertDeleteProc(@RequestParam Map<String,Object> params, HttpServletRequest request) throws Exception {
		
		ModelAndView mv = new ModelAndView();
		
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		
		params.put("empSeq", loginVO.getUniqId());
		params.put("compSeq", loginVO.getCompSeq());
		params.put("groupSeq", loginVO.getGroupSeq());
		params.put("deptSeq", loginVO.getOrgnztId());
		
		mainService.deleteAlert(params);
		mainService.deleteAlertReceiver(params);
		
		mv.setViewName("jsonView");
		
		return mv;
	}
	
	
	@RequestMapping("/alertReadAll.do")
	public ModelAndView alertReadAll(@RequestParam Map<String,Object> params, HttpServletRequest request) throws Exception {
		ModelAndView mv = new ModelAndView();
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		
		JSONObject jsonObj = new JSONObject();
		JSONObject header = new JSONObject();
		JSONObject body = new JSONObject();
		
		header.put("groupSeq", loginVO.getGroupSeq());
		header.put("empSeq", loginVO.getUniqId());
		
		body.put("mentionYn", "ALL");
		
		jsonObj.put("header", header);
		jsonObj.put("body", body);
				
		String apiUrl = CommonUtil.getApiCallDomain(request) + "/event/common/AlertReadAll";
//		String apiUrl = "http://gwa.duzon.com/event/common/AlertReadAll";
		
		Map<String, Object> result = callApiToMap(jsonObj, apiUrl);
		
		mv.addObject("result", result);
		
		mv.setViewName("jsonView");
		
		return mv;
	}
	
	
	
	@SuppressWarnings("unchecked")
	@RequestMapping("/alertRead.do")
	public ModelAndView alertRead(@RequestParam Map<String,Object> params, HttpServletRequest request) throws Exception {
		ModelAndView mv = new ModelAndView();
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		
		JSONObject jsonObj = new JSONObject();
		JSONObject header = new JSONObject();
		JSONObject body = new JSONObject();
		JSONArray alertIds = new JSONArray();
		
		header.put("groupSeq", loginVO.getGroupSeq());
		header.put("empSeq", loginVO.getUniqId());
		
		alertIds.add(params.get("alertId").toString());
		
		body.put("alertIds", alertIds);
		
		jsonObj.put("header", header);
		jsonObj.put("body", body);
				
		String apiUrl = CommonUtil.getApiCallDomain(request) + "/event/common/AlertRead";
//		String apiUrl = "http://bizboxa.duzonnext.com/event/common/AlertRead";
		
		Map<String, Object> result = callApiToMap(jsonObj, apiUrl);
		
		mv.addObject("result", result);
		
		
		JSONObject cntJsonObj = new JSONObject();
		JSONObject cntHeader = new JSONObject();
		JSONObject cntBody = new JSONObject();
		
		cntHeader.put("groupSeq", loginVO.getGroupSeq());
		cntHeader.put("empSeq", loginVO.getUniqId());
		
		cntBody.put("mentionYn", "N");
		
		cntJsonObj.put("header", cntHeader);
		cntJsonObj.put("body", cntBody);
				
		apiUrl = CommonUtil.getApiCallDomain(request) + "/event/common/AlertUnreadCount";
//		apiUrl = "http://bizboxa.duzonnext.com/event/common/AlertUnreadCount";
		
		Map<String, Object> res = callApiToMap(cntJsonObj, apiUrl);
		Map<String, Object> cntResult = (Map<String, Object>) res.get("result");
		
		mv.addObject("alertCnt", cntResult.get("alertCnt").toString());
		
		//멘션알림 카운트만 재조회
		cntBody.put("mentionYn", "Y");
		cntJsonObj.put("body", cntBody);
		
		res = callApiToMap(cntJsonObj, apiUrl);
		cntResult = (Map<String, Object>) res.get("result");
		
		mv.addObject("alertMentionCnt", cntResult.get("alertCnt").toString());
		
		mv.setViewName("jsonView");
		
		return mv;
	}
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	@RequestMapping("/alertRemoveNew.do")
	public ModelAndView alertRemoveNew(@RequestParam Map<String,Object> params, HttpServletRequest request) throws Exception {
		
		ModelAndView mv = new ModelAndView();
		
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		
		params.put("empSeq", loginVO.getUniqId());
		params.put("deptSeq", loginVO.getOrgnztId());
		params.put("compSeq", loginVO.getCompSeq());
		
		//알림 읽음처림 메일은 따로 분기태워서 처리.(회사마다 도메인이 틀릴수 있기대문)
		mainService.alertRemoveNew(params);		
		//메일알림 읽음처리
		Map<String, Object> emailDomain = mainService.getCompMailDomain(params);
		params.put("emailDomain", emailDomain.get("emailDomain"));
		List<Map<String, Object>> list = mainService.getAlaramCompList(params);
		String sCompSeq = "";
		if(list.size() > 0 ){
			for(Map<String, Object> mp : list){
				sCompSeq += ",'" + mp.get("compSeq") + "'";
			}
			if(sCompSeq.length() > 0){
				params.put("sCompSeq", sCompSeq.substring(1));
				mainService.mailAlertRemoveNew(params);
			}
		}
		
		
		mv.setViewName("jsonView");
		
		return mv;
	}
	
	 @SuppressWarnings("unchecked")
	@RequestMapping("/systemx/changeUserPositionProc.do")
		public ModelAndView changeUserPositionProc(@RequestParam Map<String,Object> params, HttpServletRequest request, ModelMap model) throws Exception{
		 
	        Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();
			
			ModelAndView mv = new ModelAndView();
			String seq = params.get("seq")+"";
			
			if(!isAuthenticated || EgovStringUtil.isEmpty(seq)) {
				mv.setViewName("redirect:/uat/uia/egovLoginUsr.do");
				return mv;
			}
			
			String[] arr = seq.split("\\|");
			params.put("groupSeq", arr[0]);
			params.put("compSeq", arr[1]);
			params.put("deptSeq", arr[2]);
			
			LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
			Map<String, Object> sessionChangeLog = new HashMap<String, Object>();
			
			//스프링 시큐리티 로그인 
			Map<String, Object> springParam = new HashMap<String, Object>();
			String springSecurityKey = UUID.randomUUID().toString().replace("-", "").substring(6);
			springParam.put("empSeq", loginVO.getUniqId());
			springParam.put("springSecurityKey", springSecurityKey + loginVO.getUserSe());
			try {
				loginService.updateSpringSecuKey(springParam);
			} catch (Exception e) {
				logger.error(e.getMessage());
				CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
			}
			
			String compAccessDomain = request.getServerName() + (request.getServerPort() == 80 ? "" : ":" + request.getServerPort());

			mv.setViewName("redirect:/j_spring_security_check?j_username=" + loginVO.getUserSe() + "$" + params.get("compSeq").toString() + "$" + params.get("deptSeq").toString() + "$" + loginVO.getGroupSeq() + "$" + loginVO.getGroupSeq() + springSecurityKey + "$" + loginVO.getIp() + "$" + compAccessDomain + "&j_password=" + loginVO.getUniqId());
			
			//추가 세션항목 세팅
			params.put("groupSeq", loginVO.getGroupSeq());
			params.put("empSeq", loginVO.getUniqId()); 
			params.put("langCode", loginVO.getLangCode());
			params.put("userSe", loginVO.getUserSe());
			
			sessionChangeLog.putAll(params);
			
			//옵션정보 리셋팅
			Map<String, Object> mp = new HashMap<String, Object>();
	    	mp.put("groupSeq", params.get("groupSeq"));
	    	mp.put("compSeq", params.get("compSeq"));
			
			Map<String, Object> optionSet = loginService.selectOptionSet(mp);
			request.getSession().setAttribute("optionSet", optionSet);			
			request.setAttribute("langCode", loginVO.getLangCode());
			
			//자동출퇴근 옵션 처리
			if(true){
				Map<String, Object> paraMap = new HashMap<String, Object>();
				paraMap.put("compSeq", params.get("compSeq"));
				paraMap = (Map<String, Object>) commonSql.select("MainManageDAO.getAutoAttOptionInfo", paraMap);
				
				if(paraMap != null && paraMap.get("val3") != null && paraMap.get("val3").toString().equals("Y")){
					Date date = new Date();
		  			Calendar calendar = new GregorianCalendar();
		  			calendar.setTime(date);
		  			int year = calendar.get(Calendar.YEAR);
		  			//Add one to month {0 - 11}
		  			int month = calendar.get(Calendar.MONTH) + 1;
		  			int day = calendar.get(Calendar.DAY_OF_MONTH);	  			
		  			String sToDay = Integer.toString(year) + (month < 10 ? "0" + Integer.toString(month) : Integer.toString(month)) + (day < 10 ? "0" + Integer.toString(day) : Integer.toString(day));
		  			
		  			params.put("sToDay", sToDay);
		  			
		  			String empCheckWorkYn = (String) commonSql.select("Empmanage.getEmpCheckWorkYn",params);
		  			
	  				if(empCheckWorkYn.equals("Y")){
	  					Map<String, Object> empAttInfo = (Map<String, Object>) commonSql.select("Empmanage.getEmpComAttInfo",params);
	  					if(empAttInfo == null){
							bizboxIndexController.empAttCheck(request);
	  					}else{
	  						if(empAttInfo.get("comeDt").toString().length() == 0){
	  							bizboxIndexController.empAttCheck(request);
	  						}
	  					}
	  				}
				}
				request.getSession().setAttribute("autoAttOptionCheck", "Y");
			}			
			
			sessionChangeLog.put("accessIp", loginVO.getIp());
			
			commonSql.insert("LoginLogDAO.logInsertSessionChangeLog",sessionChangeLog);
			
			Map<String, Object> empSessionChangeInfo = (Map<String, Object>) commonSql.select("OrgAdapterManage.selectEmpSessionChangeInfo", params);
			loginVO.setOrgnztId(empSessionChangeInfo.get("deptSeq")+"");
			loginVO.setOrgnztNm(empSessionChangeInfo.get("deptName")+"");			
			loginVO.setPositionCode(empSessionChangeInfo.get("positionCode")+"");
			loginVO.setPositionNm(empSessionChangeInfo.get("positionName")+"");
			loginVO.setClassCode(empSessionChangeInfo.get("dutyCode")+"");
			loginVO.setClassNm(empSessionChangeInfo.get("dutyName")+"");			
			loginVO.setOrganId(empSessionChangeInfo.get("compSeq")+"");
			loginVO.setOrganNm(empSessionChangeInfo.get("compName")+"");
			loginVO.setCompSeq(empSessionChangeInfo.get("compSeq")+"");
			loginVO.setBizSeq(empSessionChangeInfo.get("bizSeq")+"");
			loginVO.setEmail(empSessionChangeInfo.get("emailAddr")+"");
			loginVO.setEmailDomain(empSessionChangeInfo.get("emailDomain")+"");
			loginVO.setErpCoCd(empSessionChangeInfo.get("erpCompSeq")+"");
			loginVO.setErpEmpCd(empSessionChangeInfo.get("erpEmpSeq")+"");			
			model.addAttribute("loginVO", loginVO);
			request.getSession().setAttribute("loginVO", loginVO);
			
			
			return mv;
		}
	 
	 @SuppressWarnings("unchecked")
	@RequestMapping("/systemx/reLogonProc.do")
		public ModelAndView reLogonProc(@RequestParam Map<String,Object> params, HttpServletRequest request, ModelMap model) throws Exception{
		 
			ModelAndView mv = new ModelAndView();
			
	    	//패스워드 체크
	    	params.put("encPasswdOld", CommonUtil.passwordEncrypt(params.get("encPasswdOld").toString()));
	    	
			Map<String, Object> empInfo = (Map<String, Object>) commonSql.select("OrgAdapterManage.selectEmpPasswdCheck", params);
	    	
	    	if(empInfo != null && empInfo.get("checkYn").equals("Y")){
		    	/** SSO 처리 **/
		    	LoginVO loginVO = new LoginVO();
		    	loginVO.setUserSe(params.get("userSe").toString());
		    	loginVO.setGroupSeq(params.get("groupSeq").toString());
		    	loginVO.setCompSeq(params.get("compSeq").toString());
		    	loginVO.setUniqId(params.get("empSeq").toString());
		    	 	
		    	LoginVO resultVO = loginService.actionLoginSSO(loginVO);    		
		    	request.getSession().invalidate();
		    	request.getSession().setAttribute("loginVO", resultVO);
		    	
		    	Map<String, Object> mp = new HashMap<String, Object>();
		    	mp.put("groupSeq", params.get("groupSeq"));
		    	mp.put("compSeq", params.get("compSeq"));
	    		
	        	Map<String, Object> optionSet = loginService.selectOptionSet(mp);
	        	request.getSession().setAttribute("optionSet", optionSet);
	        	request.getSession().setAttribute("langCode", params.get("langCode").toString());
	        	request.setAttribute("langCode", params.get("langCode").toString());
				mv.setViewName("redirect:/forwardIndex.do");
				
				//자동출퇴근 옵션 처리
				if(true){
					Map<String, Object> paraMap = new HashMap<String, Object>();
					paraMap.put("compSeq", params.get("compSeq"));
					paraMap = (Map<String, Object>) commonSql.select("MainManageDAO.getAutoAttOptionInfo", paraMap);
					
					if(paraMap != null && paraMap.get("val3") != null && paraMap.get("val3").toString().equals("Y")){
						Date date = new Date();
			  			Calendar calendar = new GregorianCalendar();
			  			calendar.setTime(date);
			  			int year = calendar.get(Calendar.YEAR);
			  			//Add one to month {0 - 11}
			  			int month = calendar.get(Calendar.MONTH) + 1;
			  			int day = calendar.get(Calendar.DAY_OF_MONTH);	  			
			  			String sToDay = Integer.toString(year) + (month < 10 ? "0" + Integer.toString(month) : Integer.toString(month)) + (day < 10 ? "0" + Integer.toString(day) : Integer.toString(day));
			  			
			  			params.put("sToDay", sToDay);
			  			
			  			String empCheckWorkYn = (String) commonSql.select("Empmanage.getEmpCheckWorkYn",params);
			  			
		  				if(empCheckWorkYn.equals("Y")){
		  					Map<String, Object> empAttInfo = (Map<String, Object>) commonSql.select("Empmanage.getEmpComAttInfo",params);
		  					if(empAttInfo == null){
								bizboxIndexController.empAttCheck(request);
		  					}else{
		  						if(empAttInfo.get("comeDt").toString().length() == 0){
		  							bizboxIndexController.empAttCheck(request);
		  						}
		  					}
		  				}
					}
					request.getSession().setAttribute("autoAttOptionCheck", "Y");
				}	    		
	    	}else{
	    		mv.setViewName("redirect:/uat/uia/egovLoginUsr.do");
	    	}

	    	return mv;
		}	 
	 
	 @SuppressWarnings("static-access")
	@RequestMapping("/refleshMenuCnt.do")
	 public ModelAndView refleshMenuCnt(@RequestParam Map<String,Object> params, HttpServletRequest request) throws Exception {
		 ModelAndView mv = new ModelAndView();	
		 
		 mv.addObject("boxCntList", null);
		 
		 LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		 mv.addObject("loginVO", loginVO);
		 
		 if(loginVO == null) {
			 mv.setViewName("jsonView");
			return mv;
		 }
		 
		 //전자결재 카운트 사용유무 체크(공통옵션)
		 if(commonOptionManageService.getCommonOptionValue(loginVO.getGroupSeq(), loginVO.getCompSeq(), "cm1500") != null && commonOptionManageService.getCommonOptionValue(loginVO.getGroupSeq(), loginVO.getCompSeq(), "cm1500").equals("1")){
				if(commonOptionManageService.getCommonOptionValue(loginVO.getGroupSeq(), loginVO.getCompSeq(), "cm1501") != null && commonOptionManageService.getCommonOptionValue(loginVO.getGroupSeq(), loginVO.getCompSeq(), "cm1501").equals("1")){
				 
				 Map<String, Object> para = new HashMap<String, Object>();
				 para.put("compSeq", loginVO.getCompSeq());
				 para.put("groupSeq", loginVO.getGroupSeq());
				 para.put("empSeq", loginVO.getUniqId());
				 para.put("deptSeq", loginVO.getOrgnztId());
				 
				 try{
					 
					 Date date = new Date();
					 Calendar calendar = new GregorianCalendar();
					 calendar.setTime(date);
					 int year = calendar.get(Calendar.YEAR);
					 //Add one to month {0 - 11}
					 int month = calendar.get(Calendar.MONTH) + 1;
					 int day = calendar.get(Calendar.DAY_OF_MONTH);			 
					 
					 String fromDt = Integer.toString(year-1) + (month < 10 ? "0" + Integer.toString(month) : Integer.toString(month)) + (day < 10 ? "0" + Integer.toString(day) : Integer.toString(day));
					 String toDt = Integer.toString(year) + (month < 10 ? "0" + Integer.toString(month) : Integer.toString(month)) + (day < 10 ? "0" + Integer.toString(day) : Integer.toString(day));
					 
						
					// 결재함별 카운트 조회 API호출
					String jsonParam =	  "{\"header\":{";
					jsonParam +=	    "\"groupSeq\":\"" + loginVO.getGroupSeq() + "\",";
					jsonParam +=	    "\"empSeq\":\"" + loginVO.getUniqId() + "\",";
					jsonParam +=	    "\"tId\":\"B001\",";
					jsonParam +=	    "\"pId\":\"B001\"},";
					jsonParam +=	  "\"body\":{";
					jsonParam +=	    "\"companyInfo\" :{";
					jsonParam +=	      "\"compSeq\":\"" + loginVO.getCompSeq() + "\",";
					jsonParam +=	      "\"bizSeq\":\"" + loginVO.getBizSeq() + "\",";
					jsonParam +=	      "\"deptSeq\":\"" + loginVO.getOrgnztId() + "\",";
					jsonParam +=	      "\"empSeq\":\"" + loginVO.getUniqId() + "\",";
					jsonParam +=	      "\"langCode\":\"" + loginVO.getLangCode() + "\",";
					jsonParam +=	      "\"emailAddr\":\"" + loginVO.getEmail() + "\",";
					jsonParam +=	      "\"emailDomain\":\"" + loginVO.getEmailDomain() + "\"},";
					jsonParam +=	    "\"parMenuId\" : \"" + "0" + "\",";
					jsonParam +=	    "\"leftMenuCntYn\":\"" + "Y" + "\",";
					jsonParam +=	    "\"fromDt\":\"" + fromDt + "\",";
					jsonParam +=	    "\"toDt\":\"" + toDt + "\"}}";
					 
					//eaType 셋팅
					String eaType = loginVO.getEaType();
					if(eaType == null || eaType.equals("")){
						eaType = "eap";
					}			
					
					String apiUrl = CommonUtil.getApiCallDomain(request) + "/" + eaType + "/ea/box.do";
		
					JSONObject jsonObject2 = JSONObject.fromObject(JSONSerializer.toJSON(jsonParam));
					HttpJsonUtil httpJson = new HttpJsonUtil();
					String boxCntList = httpJson.execute("POST", apiUrl, jsonObject2);
					
					mv.addObject("boxCntList", boxCntList);
				 }
				 catch (Exception e) {
					 CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
				 }
			}
		 }
		 
		 mv.addObject("upperMenuNo", params.get("upperMenuNo"));
		 mv.setViewName("jsonView");
		 
		 return mv;
	 }
	 
	 
	 
	 @SuppressWarnings("unchecked")
	public String getEmpPathNm() throws Exception{
			LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
			
			//0:회사, 1:사업장, 2:부서, 3:팀, 4:임시부서, 5:부서(부서명)
			String optionValue = commonOptionManageService.getCommonOptionValue(loginVO.getGroupSeq(), loginVO.getCompSeq(), "cm701");
			String arrOptionValue[] = optionValue.split("\\|");
			
			String empPathNm = "";
			String compName = "";
			String bizName = "";
			String teamNm = "";
			String virDeptNm = "";
			String pathName = "";
			String onlyDeptName = "";
			
			if(arrOptionValue.length > 0){
				Map<String, Object> mp = new HashMap<String, Object>();
				
				mp.put("empSeq", loginVO.getUniqId());
				mp.put("compSeq", loginVO.getCompSeq());
				mp.put("bizSeq", loginVO.getBizSeq());
				mp.put("deptSeq", loginVO.getOrgnztId());
				mp.put("langCode", loginVO.getLangCode());
				mp.put("groupSeq", loginVO.getGroupSeq());
				
				Map<String, Object> empInfoMap = (Map<String, Object>) commonSql.select("Empmanage.getEmpInfo", mp);

				String virDeptYn = empInfoMap.get("virDeptYn") + "";
				String teamYn = empInfoMap.get("teamYn") + "";
				pathName = "";
				String removeDeptNm ="";
				for (int i = 0; i < arrOptionValue.length; i++) {
					if (arrOptionValue[i].equals("0")) {
						compName = empInfoMap.get("compName") + "-";
					} else if (arrOptionValue[i].equals("1")) {
						bizName = empInfoMap.get("bizName") + "-";
					} else if(arrOptionValue[i].equals("2")){
						if(teamYn.equals("Y") || virDeptYn.equals("Y")) {
							String [] array = empInfoMap.get("pathName").toString().split("-");
							List<String> list = new ArrayList<>(Arrays.asList(array));
							removeDeptNm = list.get(list.size()-1);
							list.remove(list.size()-1);
							for(int j=0;j<list.size(); j++) {
								pathName +=  list.get(j)+"-";
							}
						}else {
							pathName = empInfoMap.get("pathName")+"-";
						}
						
					} else if (arrOptionValue[i].equals("3") && teamYn.equals("Y")) {
						teamNm = empInfoMap.get("deptName") + "-";
					} else if (arrOptionValue[i].equals("4") && virDeptYn.equals("Y")) {
						virDeptNm = empInfoMap.get("deptName") + "-";
					} else if (arrOptionValue[i].equals("5")) {
						onlyDeptName = empInfoMap.get("displayDeptName") + "-";
					}
				}
				if(removeDeptNm != null && removeDeptNm !="") {
					if(teamNm==""&&virDeptNm=="") {
						pathName += removeDeptNm;
					}
				}
			}
			
			if(!pathName.equals("")) {
				onlyDeptName = "";
			}

			
			empPathNm = compName + bizName + pathName + onlyDeptName + teamNm + virDeptNm;
			
			if(empPathNm.length() > 0 && empPathNm.substring(empPathNm.length()-1).equals("-")){
				empPathNm = empPathNm.substring(0, empPathNm.length()-1);
			}		
			return empPathNm;
		}
	 
	 
	 
	 @SuppressWarnings("unchecked")
	@RequestMapping("/getPositionList.do")
	 public ModelAndView getPositionList(@RequestParam Map<String,Object> params, HttpServletRequest request) throws Exception {
		 ModelAndView mv = new ModelAndView();	
		 
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		
		/** 사용자 겸직정보 및 미결함, 수신참조함 카운트조회 */
		params.put("empSeq", loginVO.getUniqId());
		params.put("langCode", loginVO.getLangCode());
		params.put("separator", "-");
		
		//메일라이선스는 권한상관없이 겸직정보 모두 조회.
		if(!loginVO.getLicenseCheckYn().equals("2")) {
			params.put("authCheck", "Y");
		}
		
		params.put("notInWorkStatus", "001");
		
		List<Map<String, Object>> positionList = orgChartService.selectUserPositionList(params);
		
		//eaType 셋팅
		String eaType = positionList.get(0).get("eaType") + "";
		if(eaType == null || eaType == "") {
			eaType = "eap";
		}
		
		if(eaType.equals("ea")){
			params.put("eaType", eaType);
			params.put("eaUserSe", loginVO.getUserSe());
			positionList = orgChartService.selectUserPositionList(params);
			params.put("deptSeq", loginVO.getOrgnztId());
			Map<String, Object> mp = (Map<String, Object>) commonSql.select("OrgChart.getMainDeptYn", params);
			if(mp != null) {
				mv.addObject("mainDeptYn", mp.get("mainDeptYn")+"");
			}
			else {
				mv.addObject("mainDeptYn", "N");
			}
		}else{
			mv.addObject("mainDeptYn", "Y");
		}
		
		request.getSession().setAttribute("eaType", eaType);
		
		
		int count = 0;
    	if(positionList.size() > 0){    		    		
   			for(Map<String,Object> mp : positionList){
   				if(!eaType.equals("ea")){
	   				Map<String, Object> cntParam = new HashMap<String, Object>();
	   				cntParam.put("groupSeq", mp.get("groupSeq"));
	   				cntParam.put("compSeq", mp.get("deptCompSeq"));
	   				cntParam.put("empSeq", mp.get("empSeq"));
	   				
	   				Map<String, Object> eaCntInfo = (Map<String, Object>) commonSql.select("MainManageDAO.eapprovalCount", cntParam);
	   				if(eaCntInfo != null){
	   					positionList.get(count).put("eapproval", eaCntInfo.get("eapproval")+""); 
	   					positionList.get(count).put("eapprovalRef", eaCntInfo.get("eapprovalRef")+""); 
	   				}else{
	   					positionList.get(count).put("eapproval", "0"); 
	   					positionList.get(count).put("eapprovalRef", "0");
	   				}
   				}else{
   					try{
	   					List<Map<String, Object>> cntList = CommonUtil.getNonEaInfoCount(positionList.get(count).get("groupSeq")+"", positionList.get(count).get("compSeq")+"", positionList.get(count).get("bizSeq")+"", positionList.get(count).get("deptSeq")+"", positionList.get(count).get("empSeq")+"", positionList.get(count).get("langCode")+"", "102010000", request); 							
	   							
	   					if(cntList != null){
	   						for(Map<String, Object> cntMp : cntList){
	   							if(cntMp.get("menuId").toString().equals("102010000")){	   				
	   								positionList.get(count).put("eapproval", cntMp.get("alramCnt") + "");
	   							}
	   						}						
	   					}else{
	   						positionList.get(count).put("eapproval", "0"); 
	   					}
   					}catch(Exception e){
   						positionList.get(count).put("eapproval", "0");
   					}
   					
   				}
   				count++;
   			}
   			
    	}
    	mv.addObject("positionList", positionList);
		 
		 
		
		 mv.setViewName("jsonView");
		 
		 return mv;
	 }
	 
	 
	 
	 
	 @SuppressWarnings("static-access")
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
	 
	 
	 @RequestMapping("/mentionDetailPop.do")
	 public ModelAndView mentionDetailPop(@RequestParam Map<String,Object> params, HttpServletRequest request) throws Exception {
		ModelAndView mv = new ModelAndView();
		 
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
			
		JSONObject jsonObj = new JSONObject();
		JSONObject header = new JSONObject();
		JSONObject body = new JSONObject();
		JSONArray alertIds = new JSONArray();
		
		header.put("groupSeq", loginVO.getGroupSeq());
		header.put("empSeq", loginVO.getUniqId());
		
		alertIds.add(params.get("alertId").toString());
		
		body.put("alertIds", alertIds);
		body.put("langCode", loginVO.getLangCode());
		
		jsonObj.put("header", header);
		jsonObj.put("body", body);
				
		String apiUrl = CommonUtil.getApiCallDomain(request) + "/event/common/AlertDetail";
		Map<String, Object> result = callApiToMap(jsonObj, apiUrl);
		
		mv.addObject("result", result);
			
		if(CloudConnetInfo.getBuildType().equals("cloud")){
			mv.addObject("profilePath", "/upload/" + loginVO.getGroupSeq() + "/img/profile/" + loginVO.getGroupSeq());
		}else{
			mv.addObject("profilePath", "/upload/img/profile/" + loginVO.getGroupSeq());
		}	
		 
		mv.addObject("loginVO", loginVO);
		mv.addAllObjects(params);
		mv.setViewName("/main/pop/mentionDetailPop");
		 
		return mv;
	 }
	 
	 
	@SuppressWarnings("static-access")
	@RequestMapping("/getAlertList.do")
	public ModelAndView getAlertList(@RequestParam Map<String,Object> params, HttpServletRequest request) throws Exception {	
		
		ModelAndView mv = new ModelAndView();
		
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		//eaType 셋팅
		String eaType = loginVO.getEaType() + "";
		if(eaType == null || eaType.equals("")) {
			eaType = "eap";		
		}
		
		// 알림 조회 API호출(전체)
		String jsonParam =	"{\"header\":{";
		jsonParam +=	    "\"groupSeq\":\"" + loginVO.getGroupSeq() + "\",";
		jsonParam +=	    "\"empSeq\":\"" + loginVO.getUniqId() + "\"},";
		jsonParam +=	    "\"body\":{";
		jsonParam +=	    "\"timeStamp\":\"" + (params.get("timeStamp") == null || params.get("timeStamp").equals("") ? System.currentTimeMillis() : params.get("timeStamp")) + "\",";
		jsonParam +=	    "\"reqType\":\"" + "2" + "\",";
		jsonParam +=	    "\"reqSubType\":\"" + "N" + "\",";
		jsonParam +=	    "\"pageSize\":\"" + "30" + "\",";
		jsonParam +=	    "\"newYn\":\"" + "N" + "\",";
		jsonParam +=	    "\"mentionYn\":\"" + "N" + "\",";
		jsonParam +=	    "\"langCode\":\"" + loginVO.getLangCode() + "\"}}";
		

		String apiUrl = CommonUtil.getApiCallDomain(request) + "/event/common/AlertList";
		 
		JSONObject jsonObject2 = JSONObject.fromObject(JSONSerializer.toJSON(jsonParam));
		HttpJsonUtil httpJson = new HttpJsonUtil();
		String alertList = "";
		
		if(params.get("alMoreYn").equals("Y")){
			alertList = httpJson.execute("POST", apiUrl, jsonObject2);
			alertList = alertList.replaceAll("\'", "&#39;");
			alertList = alertList.replaceAll("<", "&lt;");
			alertList = alertList.replaceAll(">'", "&gt;");
			
			ObjectMapper om = new ObjectMapper();
			Map<String, Object> m = om.readValue(alertList, new TypeReference<Map<String, Object>>(){});
			mv.addObject("alertList", m);
		}
		
		// 알림 조회 API호출(멘션만)
		jsonParam =	        "{\"header\":{";
		jsonParam +=	    "\"groupSeq\":\"" + loginVO.getGroupSeq() + "\",";
		jsonParam +=	    "\"empSeq\":\"" + loginVO.getUniqId() + "\"},";
		jsonParam +=	    "\"body\":{";
		jsonParam +=	    "\"timeStamp\":\"" + (params.get("timeStamp") == null || params.get("timeStamp").equals("") ? System.currentTimeMillis() : params.get("timeStamp")) + "\",";
		jsonParam +=	    "\"reqType\":\"" + "2" + "\",";
		jsonParam +=	    "\"reqSubType\":\"" + "N" + "\",";
		jsonParam +=	    "\"pageSize\":\"" + "60" + "\",";
		jsonParam +=	    "\"newYn\":\"" + "N" + "\",";
		jsonParam +=	    "\"mentionYn\":\"" + "Y" + "\",";
		jsonParam +=	    "\"langCode\":\"" + loginVO.getLangCode() + "\"}}";
		
		jsonObject2 = JSONObject.fromObject(JSONSerializer.toJSON(jsonParam));
		httpJson = new HttpJsonUtil();
		String mentionList = "";
		
		if(params.get("mtMoreYn").equals("Y")){
			mentionList = httpJson.execute("POST", apiUrl, jsonObject2);
			mentionList = mentionList.replaceAll("\'", "&#39;");
			mentionList = mentionList.replaceAll("<", "&lt;");
			mentionList = mentionList.replaceAll(">'", "&gt;");
			
			ObjectMapper om = new ObjectMapper();
			Map<String, Object> m = om.readValue(mentionList, new TypeReference<Map<String, Object>>(){});
			mv.addObject("mentionList", m);
		}
		 
		mv.setViewName("jsonView");
	    return mv;
	 }
	
	@SuppressWarnings("unchecked")
	@RequestMapping("/ebpGnb.do")
	public ModelAndView ebpGnb(@RequestParam Map<String,Object> params, HttpServletRequest request) throws Exception {
		
		ModelAndView mv = new ModelAndView();
		
		// 공통옵션 'cm1001' 프로필 수정 여부 옵션 조회 하기 위한 파라미터 변수 
		Map<String, Object> commonOptionParam = new HashMap<String, Object>();
		
		if(request.getSession().getAttribute("loginVO") == null) {
	    	EgovUserDetailsHelper.reSetAuthenticatedUser();
			mv.setViewName("redirect:/uat/uia/actionLogout.do");	
			return mv;
		}
		
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		
		
		String parentOptionValue = null;	// 로그인 통제 사용 여부 (상위)
		String optionValueLogoutTime = null;	// 강제 로그아웃 옵션 값
		String optionValueLogoutType = null;	// 강제 로그아웃 화면옵션 값
		
		/** 사용자 겸직정보 및 미결함, 수신참조함 카운트조회 */
		params.put("empSeq", loginVO.getUniqId());
		params.put("langCode", loginVO.getLangCode());
		params.put("separator", "-");
		params.put("authCheck", "Y");
		
		//eaType 셋팅
		String eaType = loginVO.getEaType() + "";
		if(eaType == null || eaType.equals("")) {
			eaType = "eap";
		}
		
		if(eaType.equals("ea")){
			params.put("eaType", eaType);
			params.put("eaUserSe", loginVO.getUserSe());
			params.put("deptSeq", loginVO.getOrgnztId());
			Map<String, Object> mp = (Map<String, Object>) commonSql.select("OrgChart.getMainDeptYn", params);
			if(mp != null) {
				mv.addObject("mainDeptYn", mp.get("mainDeptYn")+"");
			}
			else {
				mv.addObject("mainDeptYn", "N");
			}
		}else{
			mv.addObject("mainDeptYn", "Y");
		}
    			
		/** 사용자 프로필 */
		params.put("compSeq", loginVO.getCompSeq());
		params.put("groupSeq", loginVO.getGroupSeq());
		params.put("deptSeq", loginVO.getOrgnztId());
		
		if(eaType != null && eaType.equals("ea")) {
			params.put("eaType", eaType);
		}
		
		Map<String,Object> userInfo = (Map<String, Object>) commonSql.select("EmpManage.selectEmp", params);
				
		if (userInfo != null) {
			mv.addObject("picFileId", userInfo.get("picFileId"));
		}
		
		mv.addObject("loginVO", loginVO);
		
		mv.addAllObjects(mainService.userSeSetting(loginVO, params));
		
		if (loginVO.getUserSe().equals("MASTER")) {
			 CommonUtil.getSessionData(request, "selectedCompSeq", mv);
		} 
		
		mv.addObject("empNameInfo", loginVO.getName() + "(" + loginVO.getId() + ")");
		
		//그룹사의 사용자 정보 수정 제한 옵션값을 가져옴 
		commonOptionParam.put("gubunType","single");
		commonOptionParam.put("optionId","cm1000");
		commonOptionParam.put("compSeq", "0");
		
		List<Map<String, Object>>commonParentOption = commonOptionManageService.getOptionSettingValue(commonOptionParam);
		
		//사용자 정보 수정이 가능 하면 값이 1 아니면 0
		if(commonParentOption.get(0).get("optionValueDisplay").equals("1")) {
			//사용자 정보 수정의 하위 옵션인 사진 수정 제한 옵션값을 가져옴 
			commonOptionParam.put("optionId", "cm1001");
			List<Map<String,Object>>commonOption = commonOptionManageService.getOptionSettingValue(commonOptionParam);
			//프로필 사진 수정이 가능하면 값은 0 아니면 1 
			if(commonOption.get(0).get("optionValueDisplay").equals("0")) {
				mv.addObject("profileModifyOption","1");
			}else {
				mv.addObject("profileModifyOption","0");
			}
		}else {
			mv.addObject("profileModifyOption","1");
		}
			
		//개인정보 표시 옵션 가져와 셋팅
	    if(commonOptionManageService.getCommonOptionValue(loginVO.getGroupSeq(), loginVO.getCompSeq(), "cm700").equals("1")){
	    	mv.addObject("optionValue","1");		    
	    }else{
	    	mv.addObject("optionValue","0");
	    }
	    
	    String empPathNm = getEmpPathNm();		    
	    mv.addObject("empPathNm", empPathNm);
				
		/** 공통옵션(강제 로그아웃 시간 설정) 값 가져오기 */
		parentOptionValue = commonOptionManageService.getCommonOptionValue(loginVO.getGroupSeq(), loginVO.getCompSeq(), "cm100");
		
		if(BizboxAProperties.getCustomProperty("BizboxA.Cust.ScriptAppendYn").equals("Y")){
			String mainPortalYn = params.get("mainPortalYn") == null ? "N" : params.get("mainPortalYn").toString();
			
			if(!BizboxAProperties.getCustomProperty("BizboxA.Cust.ScriptAppendMainPortalOnly").equals("Y") || mainPortalYn.equals("Y")){
				mv.addObject("ScriptAppendYn", "Y");	
				mv.addObject("ScriptAppendUrl", BizboxAProperties.getCustomProperty("BizboxA.Cust.ScriptAppendUrl"));
				mv.addObject("ScriptAppendFunction", BizboxAProperties.getCustomProperty("BizboxA.Cust.ScriptAppendFunction"));				
			}
		}
		
		// 상위 옵션 사용
		if(parentOptionValue.equals("1")) {
			optionValueLogoutTime = commonOptionManageService.getCommonOptionValue(loginVO.getGroupSeq(), loginVO.getCompSeq(), "cm102");
			optionValueLogoutType = commonOptionManageService.getCommonOptionValue(loginVO.getGroupSeq(), loginVO.getCompSeq(), "cm102_1");
			
			Calendar calendar = Calendar.getInstance();    
			calendar.set(Calendar.MILLISECOND, 0); // Clear the millis part. Silly API.
			calendar.set(1970, 1, 1, 0, 0, 0); // Note that months are 0-based
			Date date = calendar.getTime();
			long fixTime = date.getTime() / 10000; // Millis since Unix epoch
		
			SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss.SSS");
			String dateInString1 = loginVO.getLastLoginDateTime();
			Date date1 = sdf.parse(dateInString1);
			long loginTime = date1.getTime();
			
			request.getSession().setAttribute("logoutFlag", "N");
			
			mv.addObject("standTime", fixTime);
			mv.addObject("optionValueLogoutTime", optionValueLogoutTime);
			mv.addObject("optionValueLogoutType", optionValueLogoutType);
			mv.addObject("logonTime", loginTime);
		}
		
		mv.addObject("parentOptionValue", parentOptionValue);
		
		
		/** 그룹정보 가져오기 */
		params.put("groupSeq", loginVO.getGroupSeq());
		Map<String,Object> groupMap = orgChartService.getGroupInfo(params);
		String groupDomain = BizboxAProperties.getProperty("BizboxA.groupware.domin");
		
		if(groupDomain.indexOf("http://") != -1) {
			groupDomain = groupDomain.replace("http://", "");
		}
		if(groupDomain.indexOf("https://") != -1) {
			groupDomain = groupDomain.replace("https://", "");
		}

		groupMap.put("groupDomain", groupDomain);
		mv.addObject("groupMap", groupMap);
		
		/** 관리자 권한 체크 */
		int cnt = CommonUtil.getIntNvl(mainService.selectAdminAuthCnt(params));
		if (cnt > 0) {
			mv.addObject("isAdminAuth", true);
		}
		
		// 마스터 권한 여부 체크 
		int mCnt = CommonUtil.getIntNvl(mainService.selectMasterAuthCnt(params));
		if (mCnt > 0) {
			mv.addObject("isMasterAuth", true);
		}
		
		/** 메인 상단로고 가져오기 및 브라우저 타이틀 가져오기 */
		if(!loginVO.getUserSe().equals("MASTER")){
			params.put("imgType", "IMG_COMP_LOGO");
			Map<String,Object> imgMap = compManageService.getOrgImg(params);
			mv.addObject("imgMap", imgMap);
			
			params.put("compSeq", loginVO.getCompSeq());
			params.put("langCode", loginVO.getLangCode());
			Map<String, Object> titleMap = compManageService.getTitle(params);
			
			if(titleMap != null && !(titleMap.get("compDisplayName")+"").equals("")){
				mv.addObject("titleMap", titleMap);	
			}else{
				Map<String, Object> titleGroupMap = new HashMap<String, Object>();
				titleGroupMap.put("compDomain", groupDomain);
				titleGroupMap.put("compDisplayName", groupMap.get("groupDisplayName"));
				mv.addObject("titleMap", titleGroupMap);
			}
		}else{
			params.put("imgType", "IMG_COMP_LOGO");
			Map<String,Object> imgMap = compManageService.getOrgImg(params);
			mv.addObject("imgMap", imgMap);			
			
			Map<String, Object> titleMap = new HashMap<String, Object>();
			titleMap.put("compDomain", groupDomain);
			titleMap.put("compDisplayName", groupMap.get("groupDisplayName"));
			mv.addObject("titleMap", titleMap);		
		}
		
		String totalSearchOptionValue = commonOptionManageService.getCommonOptionValue(loginVO.getGroupSeq(), loginVO.getCompSeq(), "cm1800");
		
		/** 직급/직책 옵션 가져오기 */
		/* 2017.05.29 장지훈 추가 (직급/직책 옵션값 추가)
		 * positionDutyOptionValue = 0 : 직급 (default)
		 * positionDutyOptionValue = 1 : 직책
		 * */
		String positionDutyOptionValue = commonOptionManageService.getCommonOptionValue(loginVO.getGroupSeq(), loginVO.getCompSeq(), "cm1900");
		String displayPositionDuty = "";
		
		
		if(positionDutyOptionValue == null) {
			displayPositionDuty = "position";
		} else if(positionDutyOptionValue.equals("0")){
			displayPositionDuty = "position";
		} else if(positionDutyOptionValue.equals("1")) {
			displayPositionDuty = "duty";
		}
		
		mv.addObject("displayPositionDuty", displayPositionDuty);
		mv.addObject("totalSearchOptionValue",totalSearchOptionValue);
	    mv.addObject("userType", "USER");
		
		List<Map<String, String>> mentionOption = CommonCodeUtil.getCodeList("mentionUseYn");
		if(mentionOption != null && mentionOption.size() > 0) {
			mv.addObject("mentionUseYn","Y");
		}
		else {
			mv.addObject("mentionUseYn","N");
		}
		
		if(CloudConnetInfo.getBuildType().equals("cloud")){
			mv.addObject("cloudYn", "Y");
			mv.addObject("profilePath", "/upload/" + loginVO.getGroupSeq() + "/img/profile/" + loginVO.getGroupSeq());
			mv.addObject("uploadPathBase", "/upload/" + loginVO.getGroupSeq() + "/");
		}else{
			mv.addObject("cloudYn", "N");
			mv.addObject("profilePath", "/upload/img/profile/" + loginVO.getGroupSeq());
			mv.addObject("uploadPathBase", "/upload/");
		}
		
		mv.addObject("type", params.get("type"));
		mv.setViewName("/main/include/ebpGnb");
					
		mv.addObject("topMenuList", mainService.getTopMenuList(loginVO));
			
	
		if(request.getSession().getAttribute("forceLogoutYn") != null) {
			mv.addObject("forceLogoutYn", request.getSession().getAttribute("forceLogoutYn"));
			request.getSession().removeAttribute("forceLogoutYn");
		}
		
		mv.addObject("compMailUrl", loginVO.getUrl());
		
		return mv;
	}
	
	
	@RequestMapping("/getMfpToken.do")
	public ModelAndView getMfpToken(@RequestParam Map<String,Object> params, HttpServletRequest request) throws Exception {
		
		ModelAndView mv = new ModelAndView();
		
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		
		if(loginVO.getUserSe().equals("ADMIN") || loginVO.getUserSe().equals("MASTER")) {

			Date now = new Date();
			SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMddHHmmss");
			String token = sdf.format(now) + loginVO.getId();
			token = AESCipher.AES128_Encode(token, "1023497555960596");
			mv.addObject("mfpToken", token);
		}
				
		mv.setViewName("jsonView");
		
		return mv;
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping("/getDfToken.do")
	public ModelAndView getDfToken(@RequestParam Map<String,Object> params, HttpServletRequest request) throws Exception {
		
		ModelAndView mv = new ModelAndView();
		
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		
		if(loginVO.getUserSe().equals("ADMIN") || loginVO.getUserSe().equals("MASTER")) {

			Date now = new Date();
			SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMddHHmmss");
			String domain = "";
			
			if(!BizboxAProperties.getCustomProperty("BizboxA.Cust.DeepFinderDomain").equals("99")) {
				domain = BizboxAProperties.getCustomProperty("BizboxA.Cust.DeepFinderDomain");
			}else {
				params.put("groupSeq", loginVO.getGroupSeq());
				
				List<Map<String, Object>> compList = (List<Map<String, Object>>) commonSql.list("CompManage.getCompList", params);
				
				for (Map<String, Object> map : compList) {
					if(!domain.contains("," + map.get("compDomain").toString())){
						domain += "," + map.get("compDomain").toString();
					}
				}
				
				if(!domain.equals("")) {
					domain = domain.substring(1);
				}
			}
			
			String token = sdf.format(now) + loginVO.getId() + "|" + domain;
			token = AESCipher.AES128_Encode(token, "1023497555960596");
			mv.addObject("dfToken", token);
		}
				
		mv.setViewName("jsonView");
		
		return mv;
	}	
	
}
