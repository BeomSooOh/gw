package main.web;

import java.awt.geom.AffineTransform;
import java.awt.image.AffineTransformOp;
import java.awt.image.BufferedImage;
import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.io.UnsupportedEncodingException;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLDecoder;
import java.net.URLEncoder;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Calendar;
import java.util.Date;
import java.util.GregorianCalendar;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Properties;
import java.util.Map.Entry;
import java.util.UUID;
import java.util.zip.ZipEntry;
import java.util.zip.ZipOutputStream;

import neos.cmm.util.WhiteListItem;
import neos.cmm.util.WhiteListManager;
import javax.annotation.Resource;
import javax.crypto.Cipher;
import javax.crypto.spec.SecretKeySpec;
import javax.imageio.IIOImage;
import javax.imageio.ImageIO;
import javax.imageio.ImageWriteParam;
import javax.imageio.ImageWriter;
import javax.imageio.stream.FileImageOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.xml.bind.DatatypeConverter;

import org.apache.commons.codec.binary.Base64;
import org.apache.commons.lang3.StringUtils;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.codehaus.jackson.map.ObjectMapper;
import org.codehaus.jackson.type.TypeReference;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.servlet.ModelAndView;

import com.drew.imaging.ImageMetadataReader;
import com.drew.imaging.ImageProcessingException;
import com.drew.metadata.Directory;
import com.drew.metadata.Metadata;
import com.drew.metadata.MetadataException;
import com.drew.metadata.exif.ExifIFD0Directory;
import com.drew.metadata.jpeg.JpegDirectory;

import api.comment.service.CommentService;
import api.comment.vo.CommentVO;
import api.drm.service.DrmService;
import api.hdcs.helper.ShellExecHelper;
import api.mail.service.ApiMailInterface;
import api.msg.helper.ConvertHtmlHelper;
import bizbox.orgchart.service.vo.LoginVO;
import cloud.CloudConnetInfo;
import egovframework.com.cmm.annotation.IncludedInfo;
import egovframework.com.cmm.util.EgovUserDetailsHelper;
import egovframework.com.sym.log.clg.service.EgovLoginLogService;
import egovframework.com.sym.log.clg.service.LoginLog;
import egovframework.com.uat.uia.service.EgovLoginService;
import egovframework.com.utl.fcc.service.EgovDateUtil;
import egovframework.com.utl.fcc.service.EgovFileUploadUtil;
import egovframework.com.utl.fcc.service.EgovStringUtil;
import main.service.MainService;
import neos.cmm.db.CommonSqlDAO;
import neos.cmm.kendo.KItemBase;
import neos.cmm.kendo.KTree;
import neos.cmm.kendo.KTreeItem;
import neos.cmm.menu.service.MenuManageService;
import neos.cmm.systemx.commonOption.service.CommonOptionManageService;
import neos.cmm.systemx.comp.service.CompManageService;
import neos.cmm.systemx.emp.service.EmpManageService;
import neos.cmm.systemx.file.service.WebAttachFileService;
import neos.cmm.systemx.group.service.GroupManageService;
import neos.cmm.systemx.holiday.service.HolidayManageService;
import neos.cmm.systemx.orgchart.service.OrgChartService;
import neos.cmm.util.AESCipher;
import neos.cmm.util.BizboxAProperties;
import neos.cmm.util.CommonUtil;
import neos.cmm.util.DateUtil;
import neos.cmm.util.HttpJsonUtil;
import neos.cmm.util.NeosConstants;
import neos.cmm.util.code.CommonCodeUtil;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;
import net.sf.json.JSONSerializer;
import restful.com.controller.AttachFileController;
//2022-05-31 path traversal 방지
import egovframework.com.cmm.EgovWebUtil;

@Controller
public class BizboxMainController {
	
	@Resource(name="MenuManageService")
	private MenuManageService menuManageService; 	
	
	@Resource(name = "MainService")
	MainService mainService;

	@Resource(name = "OrgChartService")
	OrgChartService orgChartService;

	@Resource(name = "EgovLoginLogService")
	EgovLoginLogService egovLoginLogService;

	@Resource(name = "EmpManageService")
	EmpManageService empManageService;

	@Resource(name = "GroupManageService")
	GroupManageService groupManageService;
	
	@Resource(name = "CommonOptionManageService")
	CommonOptionManageService commonOptionManageService;

	@Resource(name = "CompManageService")
	private CompManageService compManageService;

	@Resource(name = "loginService")
	EgovLoginService loginService;

	@Resource(name = "commonSql")
	private CommonSqlDAO commonSql;

	@Resource(name = "WebAttachFileService")
	WebAttachFileService attachFileService;	

	@Resource(name = "HolidayManageService")
	private HolidayManageService holidayManageService;
	
	@Resource(name = "attachFileController")
	private AttachFileController attachFileController;
	
	@Resource(name = "DrmService")
	private DrmService drmService;
	
	@Resource(name = "CommentService")
	private CommentService commentService;	
	
	@Resource(name="whiteListManager")
	private WhiteListManager whiteListManager;

	/* 변수정의 로그 */
	private Logger LOG = LogManager.getLogger(this.getClass());
	
	final static String WEHAGO_aes256Key = "534e8d1a72c34625b7b7cc6d68f75731";//하드코드된 중요정보: 암호화 키

	@IncludedInfo(name = "사용자 메인", order = 10, gid = 0)
	@RequestMapping("/userMain.do")
	public ModelAndView userMain(@RequestParam Map<String, Object> params, HttpServletRequest request)
			throws Exception {

		ModelAndView mv = new ModelAndView();
		
		if(request.getSession().getAttribute("loginVO") == null) {
			if(BizboxAProperties.getCustomProperty("BizboxA.Cust.CustLogon") != "99"){
				mv.setViewName(BizboxAProperties.getCustomProperty("BizboxA.Cust.CustLogon"));
			}else {	    	
				mv.setViewName("redirect:/uat/uia/actionLogout.do");
			}
			return mv;
		}
		
		//메인포털 사용안함
		String userMainFunction = BizboxAProperties.getCustomProperty("BizboxA.Cust.UserMainFunction");
		
		if(!userMainFunction.equals("99")){
			
			if(userMainFunction.contains("redirect:")) {
				mv.setViewName(userMainFunction);
			}else {
				mv.addObject("UserMainFunction", BizboxAProperties.getCustomProperty("BizboxA.Cust.UserMainFunction"));
				mv.setViewName("/main/userCustMain");				
			}

			return mv;			
		}
		
		if (!EgovUserDetailsHelper.isAuthenticated()) {

			mv.setViewName("redirect:/uat/uia/egovLoginUsr.do");

			return mv;

		}

		LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser();
		params.put("groupSeq", loginVO.getGroupSeq());
		params.put("compSeq", loginVO.getCompSeq());
		params.put("empSeq", loginVO.getUniqId());
		params.put("langCode", loginVO.getLangCode());
		params.put("deptSeq", loginVO.getOrgnztId());	
		
		mv.setViewName("/main/userMain");
		
		String portalDiv = "";
		
		/** 메인 하단 푸터 버튼 가져오기(포털id) */
		@SuppressWarnings("unchecked")
		Map<String, Object> portalInfo = (Map<String, Object>) commonSql.select("CompManage.getPortalId", params);
		
		if(portalInfo != null){
			
			portalDiv = portalInfo.get("portalDiv").toString();
			
			if(portalDiv.equals("cloud")){
				mv.setViewName("/main/userCloudMain");
				
				params.put("portalId", portalInfo.get("portalId"));
				
				@SuppressWarnings("unchecked")
				Map<String, Object> portletCloudInfo = (Map<String, Object>) commonSql.select("PortalManageDAO.selectportletCloudInfo", params);
				
				if(portletCloudInfo != null){
					mv.addObject("portalHeight", portletCloudInfo.get("portalHeight"));
					mv.addObject("portletInfo", portletCloudInfo.get("portletInfo"));
					
					@SuppressWarnings({ "unchecked" })
					List<Map<String,Object>> portletUserSetList = commonSql.list("PortalManageDAO.selectPortletUserSetList", params);
					
					if(portletUserSetList != null){
						mv.addObject("portletUserSetList", JSONArray.fromObject(portletUserSetList));	
					}
					
				}else{
					mv.addObject("portalHeight", "");
					mv.addObject("portletInfo", "");
				}				
				
			}else{
				
				List<Map<String, Object>> portletList = (List<Map<String, Object>>) commonSql.list("MainManageDAO.selectMainPortlet", params);
				
				
				for (Map<String, Object> map : portletList) {
					if(map.get("ifSso").equals("GET") || map.get("ifSso").equals("POST")){
						params.put("linkId", map.get("linkId"));
						params.put("linkTp", map.get("portletTp"));
						params.put("url", map.get("ifUrl"));
						params.put("linkSeq", "-1");
						map.put("ifUrl", menuManageService.getMenuSSOLinkInfo(params, loginVO).get("ssoUrl"));
					}
				}

				JSONArray portletListJson = JSONArray.fromObject(portletList);
				mv.addObject("portletListJson", portletListJson);

				mv.addObject("portletList", portletList);				
				
			}
			
			mv.addObject("portalId", portalInfo.get("portalId"));
			mv.addObject("portalDiv", portalInfo.get("portalDiv"));
		}		
		
		//포틀릿 갱신주기
		List<Map<String, String>> mentionOption = CommonCodeUtil.getCodeList("cycleTime");
		if(mentionOption != null && mentionOption.size() > 0){
			if(mentionOption.get(0) == null || mentionOption.get(0).get("CODE") == null){
				mv.addObject("portletCycleTime", null);
			}else{
				mv.addObject("portletCycleTime",mentionOption.get(0).get("CODE"));
			}
		}

		// 개인정보 표시 옵션 가져와 셋팅
		if (commonOptionManageService.getCommonOptionValue(loginVO.getGroupSeq(), loginVO.getCompSeq(), "cm700").equals("1")) {
			mv.addObject("optionValue", "1");
			String empPathNm = getEmpPathNm();
			mv.addObject("empPathNm", empPathNm);
		}

		mv.addObject("topType", "main");

		params.put("groupSeq", loginVO.getGroupSeq());
		Map<String, Object> groupMap = orgChartService.getGroupInfo(params);
		mv.addObject("groupMap", groupMap);


		String empCheckWorkYn = (String) commonSql.select("Empmanage.getEmpCheckWorkYn", params);
		
		if(empCheckWorkYn == null){
			mv.setViewName("redirect:/uat/uia/egovLoginUsr.do");
			return mv;
		}
		
		if (!empCheckWorkYn.equals("") && empCheckWorkYn.equals("Y")) {
			// 출퇴근 정보
			params.put("loginId", loginVO.getId());
			@SuppressWarnings("unchecked")
			Map<String, Object> userAttInfo = (Map<String, Object>) commonSql.select("PortalManageDAO.selectUserAttPortalInfo", params);
			mv.addObject("userAttInfo", userAttInfo);

			// 출퇴근 옵션 정보
			if(!portalDiv.equals("cloud")){
				@SuppressWarnings("unchecked")
				Map<String, Object> userAttOptionInfo = (Map<String, Object>) commonSql.select("PortalManageDAO.selectUserAttOptionInfo", params);
				if (userAttOptionInfo != null) {
					mv.addObject("userAttOptionInfo", userAttOptionInfo);
				}
			}
			mv.addObject("empCheckWorkYn", "Y");
		} else {
			mv.addObject("empCheckWorkYn", "N");
		}

		//사용자별 출근체크가능여부 API호출 (출/퇴근 버튼 노출여부 결정)
		/*
		JSONObject json = new JSONObject();
		json.put("accessType", "web");
		json.put("groupSeq", loginVO.getGroupSeq());
		json.put("compSeq", loginVO.getOrganId());
		json.put("deptSeq", loginVO.getOrgnztId());
		json.put("empSeq", loginVO.getUniqId());
		
		String serverName = CommonUtil.getApiCallDomain(request);
		String apiUrl = serverName + "/attend/external/api/gw/commuteCheckPermit";
				
		//사용자별 출근체크가능 여부 확인 API
		net.sf.json.JSONObject resultJson = CommonUtil.getPostJSON(apiUrl, json.toString());		
		if(resultJson != null && resultJson.get("result").equals("SUCCESS")) {
			mv.addObject("comeLeaveYn","Y");
		}
		*/
		
		
		
		// 부서 정보
		params.put("deptSeq", loginVO.getOrgnztId());
		List<Map<String, Object>> positionList = orgChartService.selectUserPositionList(params);

		// eaType 셋팅
		String eaType = loginVO.getEaType();
		if (eaType == null || eaType == "") {
			eaType = "eap";
		}

		if (eaType.equals("ea")) {
			params.put("eaType", eaType);
			positionList = orgChartService.selectUserPositionList(params);
		}

		params.remove("deptSeq");

		JSONArray positionListJson = JSONArray.fromObject(positionList);

		if (positionList.size() > 0) {
			mv.addObject("positionInfo", positionListJson.get(0));
		}

		/** 사용자 프로필 */
		mv.addObject("loginVO", loginVO);

		/** 사용자 프로필 */
		params.put("compSeq", loginVO.getCompSeq());
		params.put("groupSeq", loginVO.getGroupSeq());
		params.put("langCode", loginVO.getLangCode());

		params.put("startNum", "0");
		params.put("endNum", "1");
		
		@SuppressWarnings("unchecked")
		Map<String, Object> userInfo = (Map<String, Object>) commonSql.select("EmpManage.selectEmp", params);

		if (userInfo != null) {
			mv.addObject("picFileId", userInfo.get("picFileId"));
		} else {
			mv.setViewName("redirect:/uat/uia/actionLogout.do");
			return mv;
		}

		/** 메인 하단 푸터 이미지,Text 가져오기 */
		if (!loginVO.getUserSe().equals("MASTER")) {
			// 메인 하단 푸터 이미지.
			params.put("imgType", "IMG_COMP_FOOTER");
			Map<String, Object> imgMap = (Map<String, Object>) commonSql.select("CompManage.selectOrgImg", params);
			mv.addObject("imgMap", imgMap);

			// 메인 하단 푸터 텍스트
			params.put("imgType", "TEXT_COMP_FOOTER");
			Map<String, Object> txtMap = (Map<String, Object>) commonSql.select("CompManage.selectOrgImg", params);
			mv.addObject("txtMap", txtMap);
		}

		if(!portalDiv.equals("cloud")){
			// 자동출퇴근 메세지 가져오기
			if (request.getSession().getAttribute("empAttCheckFlag") != null && request.getSession().getAttribute("empAttCheckFlag").toString().equals("Y")) {
				mv.addObject("empAttCheckFlag", request.getSession().getAttribute("empAttCheckFlag"));
				request.getSession().removeAttribute("empAttCheckFlag");
			}			
		}

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
		
		mv.addObject("mainPortalYn", "Y");
		mv.addObject("displayPositionDuty", displayPositionDuty);
		
		if(CloudConnetInfo.getBuildType().equals("cloud")){
			mv.addObject("profilePath", "/upload/" + loginVO.getGroupSeq() + "/img/profile/" + loginVO.getGroupSeq());
		}else{
			mv.addObject("profilePath", "/upload/img/profile/" + loginVO.getGroupSeq());
		}
		
		//메인포털 사용안함
		if(BizboxAProperties.getCustomProperty("BizboxA.Cust.edmsUseYn").equals("N")){
			mv.addObject("callAllPopup", "N");	
		}else {
			mv.addObject("callAllPopup", "Y");	
		}
				
		//사용자 메뉴 리스트 조회(포틀릿 정보 표시여부 결정하기위한 값)
		params.put("deptSeq", loginVO.getOrgnztId());		
		ObjectMapper mapper = new ObjectMapper(); 
		String userMenuList = ""; 
		try { 
			userMenuList = mapper.writeValueAsString(commonSql.list("EmpManage.getUserMenuList", params)); 
		} catch (IOException e) { 
			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
		}		
		mv.addObject("userMenuList", userMenuList);
		request.setAttribute("langCode", loginVO.getLangCode());
		
		
		return mv;
	}

	@IncludedInfo(name = "관리자 메인", order = 11, gid = 0)
	@RequestMapping("/adminMain.do")
	public ModelAndView adminMain(@RequestParam Map<String, Object> params, HttpServletRequest request) throws Exception {

		Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();

		ModelAndView mv = new ModelAndView();

		if(request.getSession().getAttribute("loginVO") == null) {
			mv.setViewName("redirect:/uat/uia/actionLogout.do");	
			return mv;
		}
		
		if (!isAuthenticated) {
			mv.setViewName("redirect:/uat/uia/egovLoginUsr.do");
			return mv;
		}

		LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser();
		
		//세션 어드민권한 체크
		if(!loginVO.getUserSe().equals("ADMIN")){
			params.put("compSeq", loginVO.getCompSeq());
			params.put("empSeq", loginVO.getUniqId());
			params.put("userSe", "ADMIN");
			
			if(CommonUtil.getIntNvl(mainService.selectAdminAuthCnt(params)) > 0){
				
				//스프링 시큐리티 로그인 
				Map<String, Object> springParam = new HashMap<String, Object>();
				String springSecurityKey = UUID.randomUUID().toString().replace("-", "").substring(6);
				springParam.put("empSeq", loginVO.getUniqId());
				springParam.put("springSecurityKey", springSecurityKey + "ADMIN");
				try {
					loginService.updateSpringSecuKey(springParam);
				} catch (Exception e) {
					LOG.error(e.getMessage());
					CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
				}
				
				String compAccessDomain = request.getServerName() + (request.getServerPort() == 80 ? "" : ":" + request.getServerPort());

				mv.setViewName("redirect:/j_spring_security_check?j_username=ADMIN$" + loginVO.getCompSeq() + "$" + loginVO.getOrgnztId() + "$" + loginVO.getGroupSeq() + "$" + loginVO.getGroupSeq() + springSecurityKey + "$" + loginVO.getIp() + "$" + compAccessDomain + "&j_password=" + loginVO.getUniqId());
				Map<String, Object> sessionChangeLog = new HashMap<String, Object>();
				sessionChangeLog.put("groupSeq", loginVO.getGroupSeq());
				sessionChangeLog.put("compSeq", loginVO.getCompSeq());
				sessionChangeLog.put("deptSeq", loginVO.getOrgnztId());
				sessionChangeLog.put("empSeq", loginVO.getUniqId());
				sessionChangeLog.put("userSe", params.get("userSe"));
				sessionChangeLog.put("accessIp", loginVO.getIp());		
				
				commonSql.insert("LoginLogDAO.logInsertSessionChangeLog",sessionChangeLog);

				loginVO.setUserSe(params.get("userSe").toString());
				request.getSession().setAttribute("loginVO", loginVO);
				
				return mv;				
			}else {
				mv.setViewName("redirect:/userMain.do");
				return mv;
			}
		}

		params.put("compSeq", loginVO.getCompSeq());

		List<Map<String, Object>> portletList = mainService.selectMainPortletList(params);

		mv.addObject("portletList", portletList);

		mv.addObject("topType", "main");

		params.put("groupSeq", loginVO.getGroupSeq());
		Map<String, Object> groupMap = orgChartService.getGroupInfo(params);
		mv.addObject("groupMap", groupMap);

		/** 메인 하단 푸터 이미지,Text 가져오기 */
		if (!loginVO.getUserSe().equals("MASTER")) {
			// 메인 하단 푸터 이미지.
			params.put("imgType", "IMG_COMP_FOOTER");
			Map<String, Object> imgMap = compManageService.getOrgImg(params);
			mv.addObject("imgMap", imgMap);

			// 메인 하단 푸터 텍스트
			params.put("imgType", "TEXT_COMP_FOOTER");
			Map<String, Object> txtMap = compManageService.getOrgImg(params);
			mv.addObject("txtMap", txtMap);
		}

		mv.addObject("topType", "main");

		mv.setViewName("/main/adminMain");

		params.put("userSe", loginVO.getUserSe());
		params.put("empSeq", loginVO.getUniqId());
		params.put("deptSeq", loginVO.getOrgnztId());
		params.put("compSeq", loginVO.getOrganId());
		params.put("groupSeq", loginVO.getGroupSeq());
		params.put("langCode", loginVO.getLangCode());
		params.put("eaType", loginVO.getEaType());
		
		/** 메인 하단 푸터 버튼 가져오기(포털id) */
		@SuppressWarnings("unchecked")
		Map<String, Object> portalInfo = (Map<String, Object>) commonSql.select("CompManage.getPortalId", params);
		
		if(portalInfo != null){
			mv.addObject("portalId", portalInfo.get("portalId"));
			mv.addObject("portalDiv", portalInfo.get("portalDiv"));
		}		

		Map<String, Object> userInfo = empManageService.selectEmpInfo(params);

		if (userInfo == null) {
			mv.setViewName("redirect:/uat/uia/actionLogout.do");
			return mv;
		}
		
		// 개인정보 표시 옵션 가져와 셋팅
		if (commonOptionManageService.getCommonOptionValue(loginVO.getGroupSeq(), loginVO.getCompSeq(), "cm700").equals("1")) {
			mv.addObject("optionValue", "1");
			String empPathNm = getEmpPathNm();
			mv.addObject("empPathNm", empPathNm);
		}
		
		/** 마지막 접속 정보 */
		LoginLog logVO = new LoginLog();
		logVO.setLoginId(loginVO.getUniqId());
		logVO = egovLoginLogService.selectLastLoginLog(logVO);

		/** os 구분에 따른 업로드 경로 */
		String os = System.getProperty("os.name").toLowerCase();
		
		if (os.indexOf("win") >= 0) {
			params.put("osType", "windows");
		} else if (os.indexOf("nix") >= 0 || os.indexOf("nux") >= 0 || os.indexOf("aix") > 0) {
			params.put("osType", "linux");
		}

		List<Map<String, Object>> serverInfo = groupManageService.selectGroupPathList(params);	
		
		/** 사용자 겸직정보 */
		params.put("separator", " > ");
		List positionList = orgChartService.selectUserPositionList(params);

		if (positionList.size() > 0) {
			mv.addObject("positionInfo", positionList.get(0));
		}

		// eaType 셋팅

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
		mv.addObject("groupMap", groupMap);
		mv.addObject("logVO", logVO);
		mv.addObject("serverInfo", serverInfo);
		mv.addObject("loginVO", loginVO);
		
		if(CloudConnetInfo.getBuildType().equals("cloud")){
			mv.addObject("profilePath", "/upload/" + loginVO.getGroupSeq() + "/img/profile/" + loginVO.getGroupSeq());
		}else{
			mv.addObject("profilePath", "/upload/img/profile/" + loginVO.getGroupSeq());
		}
		
		//패스워드 초기화 요청리스트 조회
		List<Map<String, Object>> findPasswdEmpList = (List<Map<String, Object>>) commonSql.list("OrgAdapterManage.selectFindPasswdEmpList", params);
		mv.addObject("findPasswdEmpList", JSONArray.fromObject(findPasswdEmpList));
		
		return mv;
	}

	@IncludedInfo(name = "마스터 메인", order = 12, gid = 0)
	@RequestMapping("/masterMain.do")
	public ModelAndView masterMain(@RequestParam Map<String, Object> params, HttpServletRequest request) throws Exception {

		Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();

		ModelAndView mv = new ModelAndView();

		if(request.getSession().getAttribute("loginVO") == null) {
	    	
			mv.setViewName("redirect:/uat/uia/actionLogout.do");	
			return mv;
		}
		
		String os = System.getProperty("os.name").toLowerCase();

		LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser();

		if (loginVO == null) {
			mv.setViewName("redirect:/uat/uia/egovLoginUsr.do");
			return mv;
		}
		
		//세션 마스터권한 체크
		if(!loginVO.getUserSe().equals("MASTER")){
			params.put("compSeq", loginVO.getCompSeq());
			params.put("empSeq", loginVO.getUniqId());
			params.put("userSe", "MASTER");
			
			if(CommonUtil.getIntNvl(mainService.selectMasterAuthCnt(params)) > 0){
				
				//스프링 시큐리티 로그인 
				Map<String, Object> springParam = new HashMap<String, Object>();
				String springSecurityKey = UUID.randomUUID().toString().replace("-", "").substring(6);
				springParam.put("empSeq", loginVO.getUniqId());
				springParam.put("springSecurityKey", springSecurityKey + "MASTER");
				try {
					loginService.updateSpringSecuKey(springParam);
				} catch (Exception e) {
					LOG.error(e.getMessage());
					CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
				}
				
				String compAccessDomain = request.getServerName() + (request.getServerPort() == 80 ? "" : ":" + request.getServerPort());				

				mv.setViewName("redirect:/j_spring_security_check?j_username=MASTER$" + loginVO.getCompSeq() + "$" + loginVO.getOrgnztId() + "$" + loginVO.getGroupSeq() + "$" + loginVO.getGroupSeq() + springSecurityKey + "$" + loginVO.getIp() + "$" + compAccessDomain + "&j_password=" + loginVO.getUniqId());
				Map<String, Object> sessionChangeLog = new HashMap<String, Object>();
				sessionChangeLog.put("groupSeq", loginVO.getGroupSeq());
				sessionChangeLog.put("compSeq", loginVO.getCompSeq());
				sessionChangeLog.put("deptSeq", loginVO.getOrgnztId());
				sessionChangeLog.put("empSeq", loginVO.getUniqId());
				sessionChangeLog.put("userSe", params.get("userSe"));
				sessionChangeLog.put("accessIp", loginVO.getIp());		
				
				commonSql.insert("LoginLogDAO.logInsertSessionChangeLog",sessionChangeLog);

				loginVO.setUserSe(params.get("userSe").toString());
				request.getSession().setAttribute("loginVO", loginVO);
				
				return mv;				
			}else {
				mv.setViewName("redirect:/userMain.do");
				return mv;
			}
		}

		params.put("userSe", loginVO.getUserSe());
		params.put("empSeq", loginVO.getUniqId());
		params.put("deptSeq", loginVO.getOrgnztId());
		params.put("compSeq", loginVO.getOrganId());
		params.put("groupSeq", loginVO.getGroupSeq());
		params.put("langCode", loginVO.getLangCode());
		params.put("eaType", loginVO.getEaType());
		
		/**헬프데스크 인증파라미터**/
		String helpParam = "bizboxAlpha▦" + loginVO.getGroupSeq() + "▦" + loginVO.getUniqId() + "▦" + loginVO.getId() + "▦" + loginVO.getName();
		helpParam = new String(Base64.encodeBase64(helpParam.getBytes()), "UTF-8");
		helpParam = helpParam.replace("+", "_").replace("=", "|").replace("4pam", "!@");
		mv.addObject("helpParam", helpParam);	

		/** 사용자 프로필 */
		Map<String, Object> userInfo = empManageService.selectEmpInfo(params);

		if (userInfo != null) {
			mv.addObject("picFileId", userInfo.get("picFileId"));
		} else {
			mv.setViewName("redirect:/uat/uia/actionLogout.do");
			return mv;
		}

		// 개인정보 표시 옵션 가져와 셋팅
		if (commonOptionManageService.getCommonOptionValue(loginVO.getGroupSeq(), loginVO.getCompSeq(), "cm700").equals("1")) {
			mv.addObject("optionValue", "1");
			String empPathNm = getEmpPathNm();
			mv.addObject("empPathNm", empPathNm);
		}

		/** 그룹기본정보 조회 */
		Map<String, Object> groupMap = orgChartService.getGroupInfo(params);

		/** 마지막 접속 정보 */
		LoginLog logVO = new LoginLog();
		logVO.setLoginId(loginVO.getUniqId());
		logVO = egovLoginLogService.selectLastLoginLog(logVO);

		/** os 구분에 따른 업로드 경로 */
		if (os.indexOf("win") >= 0) {
			params.put("osType", "windows");
		} else if (os.indexOf("nix") >= 0 || os.indexOf("nux") >= 0 || os.indexOf("aix") > 0) {
			params.put("osType", "linux");
		}

		List<Map<String, Object>> serverInfo = groupManageService.selectGroupPathList(params);

		if (!isAuthenticated) {

			mv.setViewName("redirect:/uat/uia/egovLoginUsr.do");

			return mv;

		}

		/** 사용자 겸직정보 */
		params.put("separator", " > ");

		List positionList = orgChartService.selectUserPositionList(params);

		if (positionList.size() > 0) {
			mv.addObject("positionInfo", positionList.get(0));
		}

		/** 메인 하단 푸터 버튼 가져오기(포털id) */
		Map<String, Object> portalInfo = (Map<String, Object>) commonSql.select("CompManage.getPortalId", params);
		
		if(portalInfo != null){
			mv.addObject("portalId", portalInfo.get("portalId"));
			mv.addObject("portalDiv", portalInfo.get("portalDiv"));
		}			

		// eaType 셋팅
		String eaType = loginVO.getEaType() + "";
		if (eaType == null || eaType.equals("")) {
			eaType = "eap";
		}

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
		mv.addObject("userType", "USER");
		mv.addObject("topType", "main");
		mv.addObject("groupMap", groupMap);
		mv.addObject("logVO", logVO);
		mv.addObject("serverInfo", serverInfo);
		mv.addObject("loginVO", loginVO);
		mv.addObject("eaType", eaType);
		
		if(CloudConnetInfo.getBuildType().equals("cloud")){
			mv.addObject("profilePath", "/upload/" + loginVO.getGroupSeq() + "/img/profile/" + loginVO.getGroupSeq());
		}else{
			mv.addObject("profilePath", "/upload/img/profile/" + loginVO.getGroupSeq());
		}
		
		//패스워드 초기화 요청리스트 조회
		List<Map<String, Object>> findPasswdEmpList = (List<Map<String, Object>>) commonSql.list("OrgAdapterManage.selectFindPasswdEmpList", params);
		mv.addObject("findPasswdEmpList", JSONArray.fromObject(findPasswdEmpList));
		
		mv.setViewName("/main/masterMain");
		return mv;
	}

	@IncludedInfo(name = "게시판 메인", order = 13, gid = 0)
	@RequestMapping("/boardMain.do")
	public ModelAndView boardMain(@RequestParam Map<String, Object> params) throws Exception {

		Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();

		ModelAndView mv = new ModelAndView();

		if (!isAuthenticated) {

			mv.setViewName("redirect:/uat/uia/egovLoginUsr.do");

			return mv;

		}

		LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser();
		params.put("loginId", loginVO.getId());
		params.put("id", loginVO.getId());
		params.put("compSeq", loginVO.getCompSeq());
		params.put("groupSeq", loginVO.getGroupSeq());
		params.put("bizSeq", loginVO.getBizSeq());
		params.put("deptSeq", loginVO.getOrgnztId());
		params.put("empSeq", loginVO.getEmpid());
		params.put("countYn", "N");
		params.put("tid", "web");

		Map<String, Object> groupMap = orgChartService.getGroupInfo(params);
		// params.put("tId", "gw-getMenuTreeList-do");
		// params.put("fields", new String[]{"cat_seq_no", "not_read_cnt",
		// "total_art_cnt", "board_title", "not_read_cnt", "total_art_cnt"});

		JSONArray list = (JSONArray) CommonUtil.getJsonData(params,
				groupMap.get("edmsUrl") + "/edms/board/getUserBoardList.do");

		// //System.out.println(list);

		mv.addObject("returnList", list);
		mv.addObject("cnt", list.size());
		mv.addObject("groupMap", groupMap);
		mv.addObject("topType", "main");

		mv.setViewName("/main/boardMain");

		return mv;
	}

	@IncludedInfo(name = "일반문서 메인", order = 14, gid = 0)
	@RequestMapping("/docMain.do")
	public ModelAndView docMain(@RequestParam Map<String, Object> params) throws Exception {

		Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();

		ModelAndView mv = new ModelAndView();

		if (!isAuthenticated) {

			mv.setViewName("redirect:/uat/uia/egovLoginUsr.do");

			return mv;

		}

		LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser();
		params.put("loginId", loginVO.getId());
		params.put("id", loginVO.getId());
		params.put("compSeq", loginVO.getCompSeq());
		params.put("groupSeq", loginVO.getGroupSeq());
		params.put("bizSeq", loginVO.getBizSeq());
		params.put("deptSeq", loginVO.getOrgnztId());
		params.put("tid", "web");

		Map<String, Object> groupMap = orgChartService.getGroupInfo(params);

		JSONArray list = null;
		String urlStr = groupMap.get("edmsUrl") + "/edms/doc/getDocDirWebList.do";
		if (!EgovStringUtil.isEmpty(urlStr)) {
			String data = CommonUtil.getJsonFromUri(params, urlStr);
			if (!EgovStringUtil.isEmpty(data)) {
				JSONObject json = JSONObject.fromObject(data.substring(1));
				try {
					if (json != null) {
						String jsonArrStr = json.getString("result");
						if (jsonArrStr != null) {
							JSONObject json2 = JSONObject.fromObject(jsonArrStr);
							if (json2 != null) {

								String dirDocListStr = json2.getString("dirDocList");

								if (!EgovStringUtil.isEmpty(dirDocListStr) && !dirDocListStr.equals("[]")) {
									list = JSONArray.fromObject(dirDocListStr);
								}
							}
						}
					}
				} catch (Exception e) {
					CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
				}
			}
		}

		// //System.out.println(list);

		mv.addObject("returnList", list);
		if (list != null) {
			mv.addObject("cnt", list.size());
		}

		mv.addObject("topType", "main");
		mv.addObject("groupMap", groupMap);

		mv.setViewName("/main/docMain");

		return mv;
	}

	@IncludedInfo(name = "전자결재문서 메인", order = 15, gid = 0)
	@RequestMapping("/edocMain.do")
	public ModelAndView edocMain(@RequestParam Map<String, Object> params) throws Exception {

		Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();

		ModelAndView mv = new ModelAndView();

		if (!isAuthenticated) {

			mv.setViewName("redirect:/uat/uia/egovLoginUsr.do");

			return mv;

		}

		LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser();
		params.put("compSeq", loginVO.getCompSeq());
		params.put("groupSeq", loginVO.getGroupSeq());
		params.put("bizSeq", loginVO.getBizSeq());
		params.put("deptSeq", loginVO.getOrgnztId());
		params.put("loginId", loginVO.getId());
		params.put("id", loginVO.getId());

		Map<String, Object> groupMap = orgChartService.getGroupInfo(params);

		JSONArray list = null;
		String urlStr = groupMap.get("edmsUrl") + "/edms/doc/getBpmDirWebList.do";
		if (!EgovStringUtil.isEmpty(urlStr)) {
			String data = CommonUtil.getJsonFromUri(params, urlStr);
			if (!EgovStringUtil.isEmpty(data)) {
				JSONObject json = JSONObject.fromObject(data.substring(1));
				try {
					if (json != null) {
						String jsonArrStr = json.getString("result");
						if (jsonArrStr != null) {
							JSONObject json2 = JSONObject.fromObject(jsonArrStr);
							if (json2 != null) {

								String dirDocListStr = json2.getString("dirList");

								if (!EgovStringUtil.isEmpty(dirDocListStr) && !dirDocListStr.equals("[]")) {
									list = JSONArray.fromObject(dirDocListStr);
								}
							}
						}
					}
				} catch (Exception e) {
					CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
				}
			}
		}

		// //System.out.println(list);

		mv.addObject("returnList", list);
		if (list != null) {
			mv.addObject("cnt", list.size());
		}

		mv.addObject("topType", "main");
		mv.addObject("groupMap", groupMap);

		mv.setViewName("/main/edocMain");

		return mv;
	}

	@RequestMapping("/mainPortletData.do")
	public ModelAndView mainPortletData(@RequestParam Map<String, Object> params, HttpServletRequest request,
			HttpServletResponse response) throws Exception {

		ModelAndView mv = new ModelAndView();

		LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser();

		params.put("compSeq", loginVO.getCompSeq());

		Map<String, Object> portletInfo = mainService.selectMainPortlet(params);

		mv.addObject("portletInfo", portletInfo);

		mv.setViewName("jsonView");

		return mv;
	}

	@SuppressWarnings("unchecked")
	@RequestMapping("/mainPortletLnb.do")
	public ModelAndView mainPortletLnb(@RequestParam Map<String, Object> params, HttpServletRequest request,
			HttpServletResponse response) throws Exception {

		ModelAndView mv = new ModelAndView();

		LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser();

		params.put("compSeq", loginVO.getCompSeq());
		params.put("langCode", loginVO.getLangCode());

		Map<String, Object> portletInfo = (Map<String, Object>) commonSql.select("MainManageDAO.selectMainPortletLnb", params);

		mv.addObject("portletInfo", portletInfo);

		mv.setViewName("jsonView");

		return mv;
	}

	@SuppressWarnings("unused")
	@RequestMapping("/userInfo.do")
	public ModelAndView userInfo(@RequestParam Map<String, Object> params, HttpServletRequest request)
			throws Exception {

		LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser();

		ModelAndView mv = new ModelAndView();

		/** 사용자 겸직정보 */
		params.put("empSeq", loginVO.getUniqId());
		params.put("langCode", loginVO.getLangCode());

		@SuppressWarnings("unchecked")
		Map<String, Object> userAttInfo = (Map<String, Object>) commonSql
				.select("PortalManageDAO.selectUserAttPortalInfo", params);
		mv.addObject("userAttInfo", userAttInfo);

		@SuppressWarnings("unchecked")
		List positionList = orgChartService.selectUserPositionList(params);

		@SuppressWarnings("unchecked")
		List<Map<String, Object>> compList = commonSql.list("PortalManageDAO.selectCoList", params);

		if (positionList.size() > 0) {
			mv.addObject("positionInfo", positionList.get(0));
		}

		/** 사용자 프로필 */
		mv.addObject("loginVO", loginVO);

		/** 사용자 프로필 */
		params.put("compSeq", loginVO.getCompSeq());
		params.put("groupSeq", loginVO.getGroupSeq());
		params.put("langCode", loginVO.getLangCode());

		Map<String, Object> userInfo = empManageService.selectEmpInfo(params);

		if (userInfo != null) {
			mv.addObject("picFileId", userInfo.get("picFileId"));
		} else {
			mv.setViewName("redirect:/uat/uia/actionLogout.do");
			return mv;
		}

		loginVO.setEmailDomain((String) userInfo.get("emailDomain"));

		loginService.LoginSessionInfo(loginVO);

		/** 마지막 접속 정보 */
		LoginLog logVO = new LoginLog();
		logVO.setLoginId(loginVO.getUniqId());
		logVO = egovLoginLogService.selectLastLoginLog(logVO);

		if (logVO == null) {
			logVO = new LoginLog();
		}

		logVO.setLoginIp(request.getRemoteAddr());

		mv.addObject("logVO", logVO);

		if (loginVO.getUserSe().equals("MASTER")) {
			CommonUtil.getSessionData(request, "selectedCompSeq", mv);
		}

		mv.setViewName("/main/portlet/userInfo");

		return mv;
	}

	@SuppressWarnings("unchecked")
	@RequestMapping("/weather.do")
	public ModelAndView weather(@RequestParam Map<String, Object> params, HttpServletRequest request) throws Exception {

		LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser();

		ModelAndView mv = new ModelAndView();

		params.put("empSeq", loginVO.getUniqId());
		params.put("compSeq", loginVO.getCompSeq());
		params.put("langCode", loginVO.getLangCode());
		Map<String, Object> map = (Map<String, Object>) commonSql.select("PortalManageDAO.getEmpWeatherCityInfo", params);

		String weatherCity = "";
		String cityName = "";

		if (map == null) {
			weatherCity = "60,127";
			cityName = BizboxAMessage.getMessage("TX000011881", "서울");
		} else {
			weatherCity = map.get("weatherCity") + "";
			cityName = map.get("cityName") + "";
		}
		mv.addObject("langCode", loginVO.getLangCode());
		mv.addObject("weatherCity", weatherCity);
		mv.addObject("cityName", cityName);
		mv.addObject("sHeight", map.get("abjustHeight") + "");
		mv.setViewName("/main/portlet/weather");
		mv.setViewName("jsonView");
		//mv.setViewName("/main/portlet/weather");

		return mv;
	}

	@SuppressWarnings("unchecked")
	@RequestMapping("/custPortletView.do")
	public ModelAndView custPortletView(@ModelAttribute("loginVO") LoginVO loginVO,
			@RequestParam Map<String, Object> params, HttpServletRequest request) throws Exception {

		request.getSession().setAttribute("loginVO", null);
		ModelAndView mv = new ModelAndView();
		Map<String, Object> param = new HashMap<String, Object>();

		String ssoId = (String) request.getSession().getAttribute("SSO_ID");

		if (ssoId != null) {
			param.put("ssoToken", ssoId);
			if(BizboxAProperties.getCustomProperty("BizboxA.Cust.skFlag").equals("Y")){
				param.put("skFlag", "Y");	
			}
			
			Map<String, Object> custInfo = mainService.selectCustInfo(param);

			if (custInfo != null) {
				/** SSO 처리 **/
				String userSe = "USER";
				loginVO.setUserSe(userSe);
				loginVO.setGroupSeq((String) custInfo.get("groupSeq"));
				loginVO.setCompSeq((String) custInfo.get("compSeq"));
				loginVO.setUniqId((String) custInfo.get("empSeq"));
				LoginVO resultVO = loginService.actionLoginSSO(loginVO);

				loginVO = resultVO;

				request.getSession().setAttribute("custPortlet", null);

				String mailUrl = "";

				params.put("groupSeq", loginVO.getGroupSeq());

				@SuppressWarnings("unchecked")
				Map<String, Object> groupInfo = (Map<String, Object>) commonSql
						.select("PortalManageDAO.selectGroupInfo", params);

				if (groupInfo != null && groupInfo.get("mailUrl") != "") {
					mailUrl = (String) groupInfo.get("mailUrl");
				}

				JSONObject cntList = new JSONObject();

				Map<String, Object> paraMap = new HashMap<String, Object>();
				paraMap.put("groupSeq", loginVO.getGroupSeq());
				paraMap.put("compSeq", loginVO.getCompSeq());
				paraMap.put("empSeq", loginVO.getUniqId());

				// 메일 카운트 조회 시작
				try {
					Map<String, Object> mp = (Map<String, Object>) commonSql.select("MainManageDAO.emailCount",
							paraMap);
					cntList.put("count", (mp == null ? "0" : mp.get("mail")));
				} catch (Exception e) {
					cntList.put("count", "-1");
				}
				// 메일 카운트 조회 끝

				// 미결함 카운트 조회 시작
				try {
					Map<String, Object> mp = (Map<String, Object>) commonSql.select("MainManageDAO.eapprovalCount",
							paraMap);
					cntList.put("eaCnt1", (mp == null ? "0" : mp.get("eapproval")));
					cntList.put("eaCnt3", (mp == null ? "0" : mp.get("eapprovalRef")));
				} catch (Exception e) {
					cntList.put("eaCnt1", "-1");
					cntList.put("eaCnt3", "-1");
				}
				// 미결함 카운트 조회 끝

				// 상신함 카운트 조회 시작
				try {
					Map<String, Object> mp = (Map<String, Object>) commonSql.select("MainManageDAO.eapprovalReqCount", paraMap);
					cntList.put("eaCnt2", (mp == null ? "0" : mp.get("cnt")));
				} catch (Exception e) {
					cntList.put("eaCnt2", "-1");
				}
				// 상신함 카운트 조회 끝

				mv.addObject("mailUrl", mailUrl);
				mv.addObject("email", loginVO.getEmail() + "@" + loginVO.getEmailDomain());
				mv.addObject("cntList", cntList);
				mv.setViewName("/main/portlet/custPortlet");
				// mv.setViewName("redirect:/custPortletView.do");

			} else {
				mv.setViewName("redirect:/custPortlet.do");
			}
		} else {
			mv.setViewName("redirect:/custPortlet.do");
		}
		return mv;
	}

	@RequestMapping("/loginExecPortletView.do")
	public ModelAndView loginExecPortletView(@RequestParam Map<String, Object> params, HttpServletRequest request)
			throws Exception {
		ModelAndView mv = new ModelAndView();
		commonSql.update("MainManage.updateSSoKey", params);
		request.getSession().setAttribute("ssoYn", "Y");
		mv.setViewName(BizboxAProperties.getCustomProperty("BizboxA.Cust.CustPortlet"));
		return mv;
	}

	@SuppressWarnings("unchecked")
	@RequestMapping("/checkSessionSSo.do")
	public ModelAndView checkSessionSSo(@ModelAttribute("loginVO") LoginVO loginVO,
			@RequestParam Map<String, Object> params, HttpServletRequest request) throws Exception {
		ModelAndView mv = new ModelAndView();

		LoginVO tempVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser();

		if (params.get("key") == null) {
			mv.addObject("result", "-1");
		}
		else {
			mv.addObject("result", "0");

			if (tempVO == null) {
				String ssoId = (String) commonSql.select("MainManage.selectEmpBySsoKey", params);

				request.getSession().setAttribute("loginVO", null);
				Map<String, Object> param = new HashMap<String, Object>();

				param.put("ssoToken", ssoId);
				Map<String, Object> custInfo = mainService.selectCustInfo(param);

				if (custInfo == null) {
					mv.addObject("result", "-1");
					mv.setViewName("jsonView");
					return mv;
				} else {
					/** SSO 처리 **/
					String userSe = "USER";
					loginVO.setUserSe(userSe);
					loginVO.setGroupSeq((String) custInfo.get("groupSeq"));
					loginVO.setCompSeq((String) custInfo.get("compSeq"));
					loginVO.setUniqId((String) custInfo.get("empSeq"));
					LoginVO resultVO = loginService.actionLoginSSO(loginVO);
					resultVO.setCompSeq(resultVO.getOrganId());
					loginVO = resultVO;

					request.getSession().setAttribute("loginVO", loginVO);

					request.getSession().setAttribute("custPortlet", "Y");
				}
			} else {
				loginVO = tempVO;
			}

			String mailUrl = "";

			params.put("groupSeq", loginVO.getGroupSeq());

			@SuppressWarnings("unchecked")
			Map<String, Object> groupInfo = (Map<String, Object>) commonSql.select("PortalManageDAO.selectGroupInfo",
					params);

			if (groupInfo != null && groupInfo.get("mailUrl") != "") {
				mailUrl = (String) groupInfo.get("mailUrl");
			}

			JSONObject cntList = new JSONObject();

			Map<String, Object> paraMap = new HashMap<String, Object>();
			paraMap.put("groupSeq", loginVO.getGroupSeq());
			paraMap.put("compSeq", loginVO.getCompSeq());
			paraMap.put("empSeq", loginVO.getUniqId());

			// 메일 카운트 조회 시작
			try {
				Map<String, Object> mp = (Map<String, Object>) commonSql.select("MainManageDAO.emailCount", paraMap);
				cntList.put("count", (mp == null ? "0" : mp.get("mail")));
			} catch (Exception e) {
				cntList.put("count", "-1");
			}
			// 메일 카운트 조회 끝

			// 미결함 카운트 조회 시작
			try {
				Map<String, Object> mp = (Map<String, Object>) commonSql.select("MainManageDAO.eapprovalCount",
						paraMap);
				cntList.put("eaCnt1", (mp == null ? "0" : mp.get("eapproval")));
				cntList.put("eaCnt3", (mp == null ? "0" : mp.get("eapprovalRef")));
			} catch (Exception e) {
				cntList.put("eaCnt1", "-1");
				cntList.put("eaCnt3", "-1");
			}
			// 미결함 카운트 조회 끝

			// 상신함 카운트 조회 시작
			try {
				Map<String, Object> mp = (Map<String, Object>) commonSql.select("MainManageDAO.eapprovalReqCount",
						paraMap);
				cntList.put("eaCnt2", (mp == null ? "0" : mp.get("cnt")));
			} catch (Exception e) {
				cntList.put("eaCnt2", "-1");
			}
			// 상신함 카운트 조회 끝

			mv.addObject("mailUrl", mailUrl);
			mv.addObject("email", loginVO.getEmail() + "@" + loginVO.getEmailDomain());
			mv.addObject("cntList", cntList);

		}

		mv.setViewName("jsonView");
		return mv;
	}

	@SuppressWarnings("unchecked")
	@RequestMapping("/custPortlet.do")
	public ModelAndView custPortlet(@ModelAttribute("loginVO") LoginVO loginVO,
			@RequestParam Map<String, Object> params, HttpServletRequest request) throws Exception {
		ModelAndView mv = new ModelAndView();
		if (params.get("GWP_EMP_ID") == null) {
			mv.setViewName("/main/portlet/custPortlet");
			return mv;
		}

		Map<String, Object> param = new HashMap<String, Object>();
		param.put("ssoToken", params.get("GWP_EMP_ID"));
		param.put("skFlag", "Y");
		Map<String, Object> custInfo = mainService.selectCustInfo(param);

		if (custInfo != null) {
			/** SSO 처리 **/
			String userSe = "USER";
			loginVO.setUserSe(userSe);
			loginVO.setGroupSeq((String) custInfo.get("groupSeq"));
			loginVO.setCompSeq((String) custInfo.get("compSeq"));
			loginVO.setUniqId((String) custInfo.get("empSeq"));
			LoginVO resultVO = loginService.actionLoginSSO(loginVO);

			loginVO = resultVO;
			request.getSession().setAttribute("loginVO", resultVO);
			
			Map<String, Object> para = new HashMap<String, Object>();
			para.put("groupSeq", custInfo.get("groupSeq"));
			para.put("compSeq", custInfo.get("compSeq"));
			
			Map<String, Object> optionSet = loginService.selectOptionSet(para);
			request.getSession().setAttribute("optionSet", optionSet);
			request.setAttribute("langCode", resultVO.getLangCode());
			loginVO.setCompSeq(resultVO.getOrganId());

			String mailUrl = "";

			params.put("groupSeq", loginVO.getGroupSeq());
			params.put("groupSeq", loginVO.getGroupSeq());
			params.put("compSeq", loginVO.getCompSeq());
			params.put("empSeq", loginVO.getUniqId());

			@SuppressWarnings("unchecked")
			Map<String, Object> groupInfo = (Map<String, Object>) commonSql.select("PortalManageDAO.selectGroupInfo",
					params);

			if (groupInfo != null && groupInfo.get("mailUrl") != "") {
				mailUrl = (String) groupInfo.get("mailUrl");
			}

			JSONObject cntList = new JSONObject();

			Map<String, Object> paraMap = new HashMap<String, Object>();
			paraMap.put("groupSeq", loginVO.getGroupSeq());
			paraMap.put("compSeq", loginVO.getCompSeq());
			paraMap.put("empSeq", loginVO.getUniqId());

			// 메일 카운트 조회 시작
			try {
				Map<String, Object> mp = (Map<String, Object>) commonSql.select("MainManageDAO.emailCount", paraMap);
				cntList.put("count", (mp == null ? "0" : mp.get("mail")));
			} catch (Exception e) {
				cntList.put("count", "-1");
			}
			// 메일 카운트 조회 끝

			// 미결함 카운트 조회 시작
			try {
				Map<String, Object> mp = (Map<String, Object>) commonSql.select("MainManageDAO.eapprovalCount",
						paraMap);
				cntList.put("eaCnt1", (mp == null ? "0" : mp.get("eapproval")));
				cntList.put("eaCnt3", (mp == null ? "0" : mp.get("eapprovalRef")));
			} catch (Exception e) {
				cntList.put("eaCnt1", "-1");
				cntList.put("eaCnt3", "-1");
			}
			// 미결함 카운트 조회 끝

			// 상신함 카운트 조회 시작
			try {
				Map<String, Object> mp = (Map<String, Object>) commonSql.select("MainManageDAO.eapprovalReqCount",
						paraMap);
				cntList.put("eaCnt2", (mp == null ? "0" : mp.get("cnt")));
			} catch (Exception e) {
				cntList.put("eaCnt2", "-1");
			}
			// 상신함 카운트 조회 끝

			mv.addObject("mailUrl", mailUrl);
			mv.addObject("email", loginVO.getEmail() + "@" + loginVO.getEmailDomain());
			mv.addObject("cntList", cntList);
			mv.addObject("result", "0"); // 0정상조회

			LoginVO userinfoVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser();

			//if (userinfoVO == null) {
			//	request.getSession().setAttribute("url", "/custPortlet.do?GWP_EMP_ID=" + params.get("GWP_EMP_ID"));
			//	request.getSession().setAttribute("custPortlet", "Y");
			//	mv.setViewName("redirect:/custPortlet.do?GWP_EMP_ID=" + params.get("GWP_EMP_ID"));
			//} else {
				mv.setViewName("/main/portlet/custPortlet");
			//}

		} else {
			mv.setViewName("/main/portlet/custPortlet");
		}

		return mv;

	}

	@RequestMapping("/custPortletTargetPop.do")
	public ModelAndView custPortletTargetPop(@ModelAttribute("loginVO") LoginVO loginVO,
			@RequestParam Map<String, Object> params, HttpServletRequest request) throws Exception {
		ModelAndView mv = new ModelAndView();
		if (params.get("url") != null) {
			request.getSession().setAttribute("url", params.get("url"));
		}

		if (request.getSession().getAttribute("SSO_ID") == null) {
			mv.setViewName(BizboxAProperties.getCustomProperty("BizboxA.Cust.CustPortlet"));
			return mv;
		} else {
			Map<String, Object> param = new HashMap<String, Object>();
			param.put("ssoToken", request.getSession().getAttribute("SSO_ID"));
			param.put("skFlag", "Y");
			Map<String, Object> custInfo = mainService.selectCustInfo(param);

			if (custInfo != null) {
				/** SSO 처리 **/
				String userSe = "USER";
				loginVO.setUserSe(userSe);
				loginVO.setGroupSeq((String) custInfo.get("groupSeq"));
				loginVO.setCompSeq((String) custInfo.get("compSeq"));
				loginVO.setUniqId((String) custInfo.get("empSeq"));
				LoginVO resultVO = loginService.actionLoginSSO(loginVO);
				loginVO = resultVO;
				request.getSession().setAttribute("loginVO", resultVO);
				
				Map<String, Object> mp = new HashMap<String, Object>();
		    	mp.put("groupSeq", custInfo.get("groupSeq"));
		    	mp.put("compSeq", custInfo.get("compSeq"));
				
				Map<String, Object> optionSet = loginService.selectOptionSet(mp);
				request.getSession().setAttribute("optionSet", optionSet);
				request.setAttribute("langCode", resultVO.getLangCode());
			}

			request.getSession().setAttribute("loginVO", loginVO);
			request.getSession().setAttribute("custPortlet", "Y");
			
			if(BizboxAProperties.getCustomProperty("BizboxA.Cust.custPortletDomain") != "99"){
				mv.setViewName("redirect:" + BizboxAProperties.getCustomProperty("BizboxA.Cust.custPortletDomain") + request.getSession().getAttribute("url"));
			}else {			
				mv.setViewName("redirect:" + request.getScheme()+"://"+request.getServerName()+(request.getServerPort() == 80 ? "" : ":" + request.getServerPort()) + request.getSession().getAttribute("url"));
			}
			
			return mv;
		}
	}

	@RequestMapping("/custNoticePortlet.do")
	public ModelAndView custNoticePortlet(@ModelAttribute("loginVO") LoginVO loginVO,
			@RequestParam Map<String, Object> params, HttpServletRequest request) throws Exception {
		ModelAndView mv = new ModelAndView();

		if (params.get("edmsUrl") != null) {
			request.getSession().setAttribute("custNoticePortlet", "Y");
			request.getSession().setAttribute("edmsUrl", params.get("edmsUrl"));
			request.getSession().setAttribute("boardNo", params.get("boardNo"));
			request.getSession().setAttribute("artNo", params.get("artNo"));
			request.getSession().setAttribute("menuNo", params.get("menuNo"));
		}
		if (request.getSession().getAttribute("SSO_ID") == null) {
			mv.setViewName("/neos/login_exec_portlet");
			return mv;
		}

		else {
			request.getSession().setAttribute("custNoticePortlet", null);
			if (request.getSession().getAttribute("loginVO") == null) {
				Map<String, Object> param = new HashMap<String, Object>();
				param.put("ssoToken", request.getSession().getAttribute("SSO_ID"));
				param.put("skFlag", "Y");
				Map<String, Object> custInfo = mainService.selectCustInfo(param);

				if (custInfo != null) {
					/** SSO 처리 **/
					String userSe = "USER";
					loginVO.setUserSe(userSe);
					loginVO.setGroupSeq((String) custInfo.get("groupSeq"));
					loginVO.setCompSeq((String) custInfo.get("compSeq"));
					loginVO.setUniqId((String) custInfo.get("empSeq"));
					LoginVO resultVO = loginService.actionLoginSSO(loginVO);
					loginVO = resultVO;
					request.getSession().setAttribute("loginVO", resultVO);
					
					Map<String, Object> mp = new HashMap<String, Object>();
			    	mp.put("groupSeq", custInfo.get("groupSeq"));
			    	mp.put("compSeq", custInfo.get("compSeq"));
					
					Map<String, Object> optionSet = loginService.selectOptionSet(mp);
					request.getSession().setAttribute("optionSet", optionSet);
					request.setAttribute("langCode", resultVO.getLangCode());
				}
			}

			String edmsUrl = request.getSession().getAttribute("edmsUrl").toString();
			String boardNo = request.getSession().getAttribute("boardNo").toString();
			String artNo = request.getSession().getAttribute("artNo").toString();
			String menuNo = request.getSession().getAttribute("menuNo").toString();
			String url = edmsUrl + "?boardNo=" + boardNo + "&artNo=" + artNo + "&menu_no=" + menuNo;

			request.getSession().removeAttribute("edmsUrl");
			request.getSession().removeAttribute("boardNo");
			request.getSession().removeAttribute("artNo");
			request.getSession().removeAttribute("menuNo");

			mv.setViewName("redirect:" + url);
			return mv;
		}

	}

	@RequestMapping("/custNoticePortletView.do")
	public ModelAndView custNoticePortletView(@ModelAttribute("loginVO") LoginVO loginVO,
			@RequestParam Map<String, Object> params, HttpServletRequest request) throws Exception {

		request.getSession().setAttribute("loginVO", null);
		ModelAndView mv = new ModelAndView();
		Map<String, Object> param = new HashMap<String, Object>();

		String ssoId = (String) request.getSession().getAttribute("SSO_ID");

		if (ssoId != null) {
			param.put("ssoToken", ssoId);
			param.put("skFlag", "Y");
			Map<String, Object> custInfo = mainService.selectCustInfo(param);

			if (custInfo != null) {
				/** SSO 처리 **/
				String userSe = "USER";
				loginVO.setUserSe(userSe);
				loginVO.setGroupSeq((String) custInfo.get("groupSeq"));
				loginVO.setCompSeq((String) custInfo.get("compSeq"));
				loginVO.setUniqId((String) custInfo.get("empSeq"));
				LoginVO resultVO = loginService.actionLoginSSO(loginVO);

				loginVO = resultVO;

				request.getSession().setAttribute("loginVO", loginVO);

				String edmsUrl = request.getSession().getAttribute("edmsUrl") + "?boardNo=3083&artNo="
						+ request.getSession().getAttribute("artNo");

				request.getSession().setAttribute("custNoticePortlet", null);
				request.getSession().setAttribute("artNo", null);
				request.getSession().setAttribute("edmsUrl", null);

				mv.setViewName("redirect:" + edmsUrl);

			} else {
				mv.setViewName("redirect:/custNoticePortlet.do");
			}
		} else {
			mv.setViewName("redirect:/custNoticePortlet.do");
		}
		return mv;
	}

	@RequestMapping ( "/emailList.do" )
	public ModelAndView emailList ( @RequestParam Map<String, Object> params, HttpServletRequest request ) throws Exception {
		LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser( );
		String mailUrl = "";
		String title = "";
		params.put("groupSeq", loginVO.getGroupSeq());
		params.put("compSeq", loginVO.getCompSeq());
		
		if(loginVO.getUrl() != null && !loginVO.getUrl().equals("")){
			mailUrl = loginVO.getUrl();
		}
		
		if ( params.get( "title" ) == null ) {
			title = "";
		}
		else {
			String changeUrl = params.get( "title" ).toString( ).replace( "^", "%" );
			String decodeUrl = URLDecoder.decode( changeUrl, "UTF-8" );
			title = decodeUrl;
		}
		ModelAndView mv = new ModelAndView( );
		JSONObject obj = new JSONObject( );
		JSONObject header = new JSONObject( );
		header.put( "groupSeq", loginVO.getGroupSeq( ) );
		header.put( "empSeq", "0" );
		header.put( "tId", "0" );
		header.put( "pId", "P041" );
		JSONObject companyInfo = new JSONObject( );
		companyInfo.put( "compSeq", loginVO.getCompSeq( ) );
		companyInfo.put( "bizSeq", loginVO.getBiz_seq( ) );
		companyInfo.put( "deptSeq", loginVO.getDept_seq( ) );
		companyInfo.put( "emailAddr", loginVO.getEmail( ) );
		companyInfo.put( "emailDomain", loginVO.getEmailDomain( ) );
		JSONObject body = new JSONObject( );
		body.put( "companyInfo", companyInfo );
		body.put( "mboxname", "INBOX" );
		if ( params.get( "count" ) == null ) {
			body.put( "cnt", "10" );
			mv.addObject( "cnt", "10" );
		}
		else {
			body.put( "cnt", params.get( "count" ) );
			mv.addObject( "cnt", params.get( "count" ) );
		}
		if ( params.get( "title" ) == null ) {
			body.put( "seen", 1 );
			mv.addObject( "seen", 1 );
		}
		else {
			body.put( "seen", 0 );
			mv.addObject( "seen", 0 );
		}
		body.put( "mailTime", (long) 0 );
		obj.put( "header", header );
		obj.put( "body", body );
		JSONObject mailList = getPostJSON( mailUrl + "appendMailListApi.do", obj.toString( ) );
		mv.addObject( "mailUrl", mailUrl );
		mv.addObject( "email", loginVO.getEmail( ) + "@" + loginVO.getEmailDomain( ) );
		mv.addObject( "mailList", mailList );
		if ( params.get( "title" ) == null ) {
			mv.addObject( "title", title );
		}
		else {
			mv.addObject( "title", title );
		}
		mv.setViewName( "jsonView" );
		//mv.setViewName("/main/portlet/emailList");
		return mv;
	}
	
	@RequestMapping ("/portletEmailList.do")
	public ModelAndView portletEmailList ( @RequestParam Map<String, Object> params, HttpServletRequest request ) throws Exception {
		LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser( );
		String mailUrl = "";
		
		params.put("groupSeq", loginVO.getGroupSeq());
		params.put("compSeq", loginVO.getCompSeq());
		
		if(loginVO.getUrl() != null && !loginVO.getUrl().equals("")){
			mailUrl = loginVO.getUrl();
		}
		
		ModelAndView mv = new ModelAndView( );
		JSONObject obj = new JSONObject( );
		JSONObject header = new JSONObject( );
		header.put( "groupSeq", loginVO.getGroupSeq( ) );
		header.put( "empSeq", "0" );
		header.put( "tId", "0" );
		header.put( "pId", "P041" );
		
		JSONObject companyInfo = new JSONObject( );
		companyInfo.put( "compSeq", loginVO.getCompSeq( ) );
		companyInfo.put( "bizSeq", loginVO.getBiz_seq( ) );
		companyInfo.put( "deptSeq", loginVO.getDept_seq( ) );
		companyInfo.put( "emailAddr", loginVO.getEmail( ) );
		companyInfo.put( "emailDomain", loginVO.getEmailDomain( ) );
		
		JSONObject body = new JSONObject( );
		body.put( "companyInfo", companyInfo );
		body.put( "mboxname", "INBOX" );
		
		if(params.get( "count" ) == null ) {
			body.put( "cnt", "10" );
			mv.addObject( "cnt", "10" );
		} else {
			body.put( "cnt", params.get( "count" ) );
			mv.addObject( "cnt", params.get( "count" ) );
		}
		
		if(params.get("seen") == null) {
			body.put("seen", 0);
			mv.addObject("seen", 0);
		} else {
			body.put("seen", params.get("seen") == "Y" ? 0 : 1);
			mv.addObject("seen", params.get("seen"));
		}
		
		body.put( "mailTime", (long) 0 );
		obj.put( "header", header );
		obj.put( "body", body );
		JSONObject mailList = getPostJSON( mailUrl + "appendMailListApi.do", obj.toString( ) );
		mv.addObject( "mailUrl", mailUrl );
		mv.addObject( "email", loginVO.getEmail( ) + "@" + loginVO.getEmailDomain( ) );
		mv.addObject( "mailList", mailList );
		
		mv.setViewName( "jsonView" );
		return mv;
	}
	
	@RequestMapping ( "/emailTotal.do" )
	public ModelAndView emailTotal ( @RequestParam Map<String, Object> params, HttpServletRequest request ) throws Exception {
		/* 로그인 세션 가져오기 */
		LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser( );
		/* 변수정의 */
		String mailUrl = "";
		String mail = "";
		String seen = "false";
		// 테스트
		String pageSize = "0";
		if ( params.get( "pageSize" ) != null ) {
			pageSize = params.get( "pageSize" ).toString( );
		}
		if ( params.get( "seen" ) != null ) {
			if(params.get("seen").toString( ).equals( "Y" )) {
				seen = "true";
			} else {
				seen = "false";
			}
		}
		String flag = "false";
		String page = "1";
		params.put("groupSeq", loginVO.getGroupSeq());
		params.put("compSeq", loginVO.getCompSeq());
		
		if(loginVO.getUrl() != null && !loginVO.getUrl().equals("")){
			mailUrl = loginVO.getUrl();
		}
		
		/* 메일 API 호출 */
		ApiMailInterface apiMail = new ApiMailInterface( );
		ModelAndView mv = new ModelAndView( );
		/* 2018-02-06 Mail API 변경으로 구조 변경 ( 김상겸, 장지훈 ) : 오류 발생시 NULL 반환 */
		JSONObject mailTotalList = apiMail.AllMailList( loginVO, mailUrl, pageSize, page, seen, flag, "MAILTIME DESC" );
		mv.addObject( "mailUrl", mailUrl );
		mv.addObject( "mail", mail );
		mv.addObject( "totalMailList", (mailTotalList == null ? "{}" : ( mailTotalList.get("result") == null ? "{}" : mailTotalList.get("result") ) ) );
		
		mv.setViewName( "jsonView" );
		return mv;
	}
	
	@RequestMapping("/emailListReload.do")
	public ModelAndView emailListReload(@RequestParam Map<String, Object> params, HttpServletRequest request)
			throws Exception {

		LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser();
		ModelAndView mv = new ModelAndView();

		JSONObject obj = new JSONObject();

		JSONObject header = new JSONObject();
		header.put("groupSeq", loginVO.getGroupSeq());
		header.put("empSeq", "0");
		header.put("tId", "0");
		header.put("pId", "P041");

		JSONObject companyInfo = new JSONObject();

		companyInfo.put("compSeq", loginVO.getCompSeq());
		companyInfo.put("bizSeq", loginVO.getBiz_seq());
		companyInfo.put("deptSeq", loginVO.getDept_seq());
		companyInfo.put("emailAddr", loginVO.getEmail());
		companyInfo.put("emailDomain", loginVO.getEmailDomain());

		JSONObject body = new JSONObject();
		body.put("companyInfo", companyInfo);
		body.put("mboxname", "INBOX");
		
		if(params.get( "count" ) == null ) {
			body.put( "cnt", "10" );
			mv.addObject( "cnt", "10" );
		} else {
			body.put( "cnt", params.get( "count" ) );
			mv.addObject( "cnt", params.get( "count" ) );
		}
		
		if(params.get("seen") == null) {
			body.put("seen", 0);
			mv.addObject("seen", 0);
		} else {
			body.put("seen", params.get("seen") == "Y" ? 0 : 1);
			mv.addObject("seen", params.get("seen"));
		}

		body.put("mailTime", (long) 0);
		obj.put("header", header);
		obj.put("body", body);

		String mailUrl = params.get("mailUrl").toString();
		JSONObject mailList = getPostJSON(mailUrl + "appendMailListApi.do", obj.toString());
		mv.addObject("list", mailList);
		mv.setViewName("jsonView");
		return mv;
	}

	@RequestMapping ( "/emailCountUsage.do" )
	public ModelAndView emailCountUsage ( @RequestParam Map<String, Object> params, HttpServletRequest request ) throws Exception {

		/* 로그인 세션 */
		LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser( );
		/* 변수선언 */
		ModelAndView mv = new ModelAndView( );
		String mailUrl = "";
		
		params.put("groupSeq", loginVO.getGroupSeq());
		params.put("compSeq", loginVO.getCompSeq());
		
		if(loginVO.getUrl() != null && !loginVO.getUrl().equals("")){
			mailUrl = loginVO.getUrl();
		}
		
		/* 메일 API 호출 */
		ApiMailInterface apiMail = new ApiMailInterface( );
		JSONObject mailUsageCountData = apiMail.MailBoxCount( loginVO, mailUrl, false , false );
		mv.addObject( "mailUrl", mailUrl );
		/* 2018-02-06 Mail API 변경으로 구조 변경 ( 김상겸, 장지훈 ) : 오류 발생시 NULL 반환 */
		mv.addObject( "mailUsageCountData", (mailUsageCountData == null ? "{}" : ( mailUsageCountData.get("result") == null ? "{}" : mailUsageCountData.get("result") ) ) );
		mv.setViewName( "jsonView" );
		return mv;
	}

	@RequestMapping("/eapInfoCount.do")
	public ModelAndView eapInfoCount(@RequestParam Map<String, Object> params, HttpServletRequest request)
			throws Exception {

		LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser();
		String eapUrl = "";
		params.put("groupSeq", loginVO.getGroupSeq());

		@SuppressWarnings("unchecked")
		Map<String, Object> groupInfo = (Map<String, Object>) commonSql.select("PortalManageDAO.selectGroupInfo",
				params);

		if (groupInfo != null) {
			eapUrl = CommonUtil.getApiCallDomain(request) + "/eap/restful/ea/box";
		}

		ModelAndView mv = new ModelAndView();

		JSONObject obj = new JSONObject();

		JSONObject header = new JSONObject();
		header.put("groupSeq", loginVO.getGroupSeq());
		header.put("empSeq", loginVO.getUniqId());
		header.put("tId", "B001");
		header.put("pId", "B001");

		JSONObject companyInfo = new JSONObject();

		companyInfo.put("compSeq", loginVO.getCompSeq());
		companyInfo.put("bizSeq", loginVO.getBizSeq());
		companyInfo.put("deptSeq", loginVO.getOrgnztId());
		companyInfo.put("empSeq", loginVO.getUniqId());
		companyInfo.put("langCode", loginVO.getLangCode());
		companyInfo.put("emailAddr", loginVO.getEmail());
		companyInfo.put("emailDomain", loginVO.getEmailDomain());

		JSONObject body = new JSONObject();
		body.put("companyInfo", companyInfo);
		body.put("langCode", loginVO.getLangCode());
		body.put("parMenuId", "0");

		Date date = new Date();
		Calendar calendar = new GregorianCalendar();
		calendar.setTime(date);
		int year = calendar.get(Calendar.YEAR);
		int month = calendar.get(Calendar.MONTH) + 1;
		int day = calendar.get(Calendar.DAY_OF_MONTH);

		String fromDt = Integer.toString(year - 1)
				+ (month < 10 ? "0" + Integer.toString(month) : Integer.toString(month))
				+ (day < 10 ? "0" + Integer.toString(day) : Integer.toString(day));
		String toDt = Integer.toString(year) + (month < 10 ? "0" + Integer.toString(month) : Integer.toString(month))
				+ (day < 10 ? "0" + Integer.toString(day) : Integer.toString(day));

		body.put("fromDt", fromDt);
		body.put("toDt", toDt);

		obj.put("header", header);
		obj.put("body", body);

		JSONObject eapInfoCount = getPostJSON(eapUrl, obj.toString());

		mv.addObject("eapInfoCount", eapInfoCount);
		mv.setViewName("jsonView");

		return mv;
	}

	@RequestMapping("/nonEaInfoCount.do")
	public ModelAndView nenEaInfoCount(@RequestParam Map<String, Object> params, HttpServletRequest request)
			throws Exception {

		LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser();
		String eapUrl = "";
		params.put("groupSeq", loginVO.getGroupSeq());

		@SuppressWarnings("unchecked")
		Map<String, Object> groupInfo = (Map<String, Object>) commonSql.select("PortalManageDAO.selectGroupInfo",
				params);

		if (groupInfo != null) {
			eapUrl = CommonUtil.getApiCallDomain(request) + "/ea/restful/ea/box";
		}

		ModelAndView mv = new ModelAndView();

		JSONObject obj = new JSONObject();

		JSONObject header = new JSONObject();
		header.put("groupSeq", loginVO.getGroupSeq());
		header.put("empSeq", loginVO.getUniqId());
		header.put("tId", "B001");
		header.put("pId", "B001");

		JSONObject companyInfo = new JSONObject();

		companyInfo.put("compSeq", loginVO.getCompSeq());
		companyInfo.put("bizSeq", loginVO.getBizSeq());
		companyInfo.put("deptSeq", loginVO.getOrgnztId());
		companyInfo.put("empSeq", loginVO.getUniqId());
		companyInfo.put("langCode", loginVO.getLangCode());
		companyInfo.put("emailAddr", loginVO.getEmail());
		companyInfo.put("emailDomain", loginVO.getEmailDomain());

		JSONObject body = new JSONObject();
		body.put("companyInfo", companyInfo);
		body.put("langCode", loginVO.getLangCode());
		body.put("parMenuId", "0");

		Date date = new Date();
		Calendar calendar = new GregorianCalendar();
		calendar.setTime(date);
		int year = calendar.get(Calendar.YEAR);
		// Add one to month {0 - 11}
		int month = calendar.get(Calendar.MONTH) + 1;
		int day = calendar.get(Calendar.DAY_OF_MONTH);

		String fromDt = Integer.toString(year - 1)
				+ (month < 10 ? "0" + Integer.toString(month) : Integer.toString(month))
				+ (day < 10 ? "0" + Integer.toString(day) : Integer.toString(day));
		String toDt = Integer.toString(year) + (month < 10 ? "0" + Integer.toString(month) : Integer.toString(month))
				+ (day < 10 ? "0" + Integer.toString(day) : Integer.toString(day));

		body.put("fromDt", fromDt);
		body.put("toDt", toDt);

		obj.put("header", header);
		obj.put("body", body);

		JSONObject eapInfoCount = getPostJSON(eapUrl, obj.toString());

		mv.addObject("eapInfoCount", eapInfoCount);
		mv.setViewName("jsonView");
		// mv.setViewName("/main/portlet/eapInfoCount");

		return mv;
	}	
	
	@RequestMapping("/emailSetSeenFlag.do")
	public ModelAndView emailSetSeenFlag(@RequestParam Map<String, Object> params, HttpServletRequest request)
			throws Exception {

		LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser();
		ModelAndView mv = new ModelAndView();
		JSONObject obj = new JSONObject();

		JSONObject header = new JSONObject();
		header.put("groupSeq", loginVO.getGroupSeq());
		header.put("empSeq", "0");
		header.put("tId", "0");
		header.put("pId", "P041");

		JSONObject companyInfo = new JSONObject();

		companyInfo.put("compSeq", loginVO.getCompSeq());
		companyInfo.put("bizSeq", loginVO.getBiz_seq());
		companyInfo.put("deptSeq", loginVO.getDept_seq());
		companyInfo.put("emailAddr", loginVO.getEmail());
		companyInfo.put("emailDomain", loginVO.getEmailDomain());

		JSONObject body = new JSONObject();
		body.put("companyInfo", companyInfo);
		body.put("muids", params.get("muids"));
		body.put("seen", 1);
		obj.put("header", header);
		obj.put("body", body);

		JSONObject returnValue = getPostJSON(params.get("mailUrl") + "setSeenMailApi.do", obj.toString());
		mv.addObject("return", returnValue);
		mv.setViewName("jsonView");
		return mv;
	}

	public static JSONObject getPostJSON(String url, String data) {
		StringBuilder sbBuf = new StringBuilder();
		HttpURLConnection con = null;
		BufferedReader brIn = null;
		OutputStreamWriter wr = null;
		String line = null;
		try {
			if (url!=null && url.startsWith("")) {//서버사이드 요청 위조
				con = (HttpURLConnection) new URL(url).openConnection();
				con.setRequestMethod("POST");
				con.setConnectTimeout(5000);
				con.setRequestProperty("Content-Type", "application/json;charset=UTF-8");
				con.setDoOutput(true);
				con.setDoInput(true);
			}else {
				return null;
			}
			wr = new OutputStreamWriter(con.getOutputStream());
			wr.write(data);
			wr.flush();
			brIn = new BufferedReader(new InputStreamReader(con.getInputStream(), "UTF-8"));
			while ((line = brIn.readLine()) != null) {
				sbBuf.append(line);
			}
			// //System.out.println(sbBuf);

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
				e.getMessage();
			}
			try {
				if(brIn!=null) {//Null Pointer 역참조
				brIn.close();
				}
			} catch (Exception e) {
				e.getMessage();
			}
			try {
				if(con!=null) {//Null Pointer 역참조
				con.disconnect();
				}
			} catch (Exception e) {
				e.getMessage();
			}
		}
	}

	@RequestMapping("/mainTempPage.do")
	public ModelAndView mainTempPage(@RequestParam Map<String, Object> params, HttpServletRequest request)
			throws Exception {

		ModelAndView mv = new ModelAndView();

		mv.setViewName("/main/temp/" + params.get("page"));

		return mv;
	}

	@RequestMapping("/mainEmptyPage.do")
	public ModelAndView mainEmptyPage(@RequestParam Map<String, Object> params, HttpServletRequest request)
			throws Exception {

		ModelAndView mv = new ModelAndView();

		mv.setViewName("/main/empty/" + params.get("page"));

		return mv;
	}

	@RequestMapping("/portalBanner.do")
	public ModelAndView portalBanner(@RequestParam Map<String, Object> params, HttpServletRequest request)
			throws Exception {

		ModelAndView mv = new ModelAndView();
		mv.addObject("params", params);
		mv.setViewName("/main/portal/portalBanner");

		return mv;
	}

	@RequestMapping("/editorView.do")
	public ModelAndView editorView(@RequestParam Map<String, Object> params, HttpServletRequest request)
			throws Exception {

		ModelAndView mv = new ModelAndView();

		params.put("pathSeq", "0");
		params.put("osType", NeosConstants.SERVER_OS);
		
		if(CloudConnetInfo.getBuildType().equals("cloud")){
			LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
			
			if(loginVO != null) {
				params.put("webPath", "/upload/" + loginVO.getGroupSeq());	
			}else if(params.get("groupSeq") != null) {
				params.put("webPath", "/upload/" + params.get("groupSeq"));	
			}
			
		}else{
			params.put("webPath", "/upload");
		}

		Map<String, Object> pathMap = groupManageService.selectGroupPath(params);
		params.put("absolPath", pathMap.get("absolPath"));

		// 에디터 설정옵션 가져오기
		String editorTp = "dzeditor";
		params.put("optionId", "cm300");
		params.put("compSeq", "0");
		Object option = commonSql.select("CmmnCodeDetailManageDAO.getOptionSetValue", params);

		if (option != null) {
			editorTp = option.toString();
		}

		// 기본 옵션 설정값 가져오기
		String opFont = "돋움";
		String opSize = "10pt";
		String opLine = "120";

		params.put("optionId", "cm301");
		option = commonSql.select("CmmnCodeDetailManageDAO.getOptionSetValue", params);
		if (option != null) {
			opFont = option.toString();
		}

		params.put("optionId", "cm302");
		option = commonSql.select("CmmnCodeDetailManageDAO.getOptionSetValue", params);
		if (option != null) {
			opSize = option.toString();
		}

		params.put("optionId", "cm303");
		option = commonSql.select("CmmnCodeDetailManageDAO.getOptionSetValue", params);
		if (option != null) {
			opLine = option.toString();
		}

		params.put("op_font", opFont);
		params.put("op_size", opSize);
		params.put("op_line", opLine);

		// 전자결재(한글기안기 사용여부)
		if (params.get("module") != null) {
			if (params.get("module").equals("hancom")) {
				editorTp = "hancom";
			} else if (params.get("module").equals("ea") || params.get("module").equals("eap")) {
				params.put("optionId", "cm301");
				option = commonSql.select("CmmnCodeDetailManageDAO.getOptionSetValue", params);

				if (option != null && option.equals("1")) {
					editorTp = "hancom";
				}
			}
		}

		mv.setViewName("/share/editor/" + editorTp);

		mv.addObject("params", params);
		
		//추가폰트 설정
		if(!BizboxAProperties.getCustomProperty("BizboxA.Cust.arrCustomFontName").equals("99")){
			mv.addObject("arrCustomFontName", BizboxAProperties.getCustomProperty("BizboxA.Cust.arrCustomFontName"));
		}

		return mv;
	}
	
	@RequestMapping("/empProfileInfo.do")
	public ModelAndView empProfileInfo(@RequestParam Map<String, Object> params, HttpServletRequest request) throws Exception{

		ModelAndView mv = new ModelAndView();
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		
		if(loginVO != null){

			params.put("groupSeq", loginVO.getGroupSeq());
			params.put("langCode", loginVO.getLangCode());			
			
			@SuppressWarnings("unchecked")
			Map<String, Object> profileInfo = (Map<String, Object>) commonSql.select("EmpManage.getEmpProfileInfo", params);
			
			if(profileInfo != null){
				if(CloudConnetInfo.getBuildType().equals("cloud")){
					profileInfo.put("profilePath", "/upload/" + loginVO.getGroupSeq() + "/img/profile/" + loginVO.getGroupSeq());
				}else{
					profileInfo.put("profilePath", "/upload/img/profile/" + loginVO.getGroupSeq());
				}				
			}
			
			mv.addObject("profileInfo", profileInfo);
			
			mv.setViewName("/share/profile/empProfileInfo");
			
		}else{
			mv.setViewName("redirect:/uat/uia/egovLoginUsr.do");
		}

		return mv;
	}	
	
	@SuppressWarnings("unchecked")
	@RequestMapping("/deptPathInfo.do")
	public ModelAndView deptPathInfo(@RequestParam Map<String, Object> params, HttpServletRequest request) throws Exception{

		ModelAndView mv = new ModelAndView();
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		List<Map<String,Object>> deptPathInfoList  = null;		// 파일 저장 리스트
		
		if(loginVO != null){
			params.put("groupSeq", loginVO.getGroupSeq());
			params.put("langCode", loginVO.getLangCode());
			
			if(params.get("orgDiv") != null) {
				params.put("orgDiv", params.get("orgDiv").toString().toUpperCase());
			}
			
			if(params.get("orgSeq") == null) {
				params.put("orgSeq", loginVO.getUniqId());
			}
			
			if(params.get("delimiter") == null) {
				params.put("delimiter", " ");
			}
			
			if(params.get("mainDeptYn") == null) {
				params.put("mainDeptYn", "N");
			}
			
			if(params.get("orgDiv").equals("U") || params.get("orgDiv").equals("D")) {
				deptPathInfoList = commonSql.list("Empmanage.empDeptInfoList", params);
			}
		}
		
		mv.addObject("deptPathInfoList", deptPathInfoList);
		mv.setViewName("jsonView");
		return mv;
	}		
	
	@SuppressWarnings("unchecked")
	@RequestMapping("/comment.do")
	public ModelAndView comment(@RequestParam Map<String, Object> params, HttpServletRequest request)
			throws Exception {
		
		ModelAndView mv = new ModelAndView();
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		
		if(params.get("createCommentKey") != null) {
			ObjectMapper mapper = new ObjectMapper();
			mv.addObject("commentKey", AESCipher.AES_Encode(mapper.writeValueAsString(params)));
			mv.setViewName("jsonView");
			return mv;			
		}
		
		//보안취약 조치
		if(params.get("commentKey") != null) {
			
			String commentKeyEnc = params.get("commentKey").toString();
			commentKeyEnc = URLDecoder.decode(commentKeyEnc, "UTF-8").replaceAll(" ", "+");
			
			Map<String, Object> commentKey = JSONObject.fromObject(JSONSerializer.toJSON(AESCipher.AES_Decode(commentKeyEnc)));
			params.remove("commentKey");
			params.putAll(commentKey);
			
			if(params.get("interlockYn") != null && params.get("interlockYn").equals("Y")) {
				params.put("pdfYn", "Y");
				params.put("langCode", "kr");
			}else if(!loginVO.getUniqId().equals(params.get("empSeq"))) {
				//비정상 접근
				mv.setViewName("jsonView");
				return mv;
			}
		}
		
		if(params.get("moduleGbnCode") == null || params.get("moduleGbnCode").equals("") || params.get("moduleSeq") == null || params.get("moduleSeq").equals("")) {
			mv.setViewName("jsonView");
			mv.addObject("result", "비정상 접근");
			return mv;			
		}

		if(loginVO != null || (params.get("pdfYn") != null && params.get("pdfYn").equals("Y"))){
			
			if((params.get("printYn") != null && params.get("printYn").equals("Y")) || (params.get("pdfYn") != null && params.get("pdfYn").equals("Y"))){
				
				CommentVO commentVo = new CommentVO();
				
				if(params.get("pdfYn") != null && params.get("pdfYn").equals("Y")) {
					commentVo.setGroupSeq(params.get("groupSeq").toString());
					commentVo.setLangCode(params.get("langCode").toString());
					commentVo.setCommentSeq("");
				}else {
					commentVo.setLangCode(loginVO.getLangCode());
					commentVo.setCompSeq(loginVO.getCompSeq());
					commentVo.setBizSeq(loginVO.getBizSeq());
					commentVo.setDeptSeq(loginVO.getOrgnztId());
					commentVo.setGroupSeq(loginVO.getGroupSeq());
					commentVo.setEmpSeq(loginVO.getUniqId());
				}
				
				commentVo.setModuleGbnCode(params.get("moduleGbnCode") == null ? "" : params.get("moduleGbnCode").toString());
				commentVo.setModuleSeq(params.get("moduleSeq") == null ? "" : params.get("moduleSeq").toString());
				commentVo.setCommentType(params.get("commentType") == null ? "" : params.get("commentType").toString());
				commentVo.setCommentSeq(params.get("commentSeq") == null ? "" : params.get("commentSeq").toString());
				commentVo.setPageSize(1000);
				
				String sort = "A";
				if(params.get("sort") != null && !params.get("sort").equals("")){
					sort = params.get("sort").toString();
				}
				
				commentVo.setSort(sort);
				
				String searchWay = "A";
				if(params.get("searchWay") != null && !params.get("searchWay").equals("")){
					searchWay = params.get("searchWay").toString();
				}
				
				commentVo.setSearchWay(searchWay);
				
				String reqSubType = "N";
				if(params.get("reqSubType") != null && !params.get("reqSubType").equals("")){
					reqSubType = params.get("reqSubType").toString();
				}				
				
				commentVo.setReqSubType(reqSubType);

				Map<String,Object> commentInfo = commentService.selectCommentList(commentVo);
				
				@SuppressWarnings("unchecked")
				List<Map<String,Object>> commentList = (List<Map<String,Object>>) commentInfo.get("commentList");
				
				if(commentList != null && commentList.size() > 0){
					
					for(Map<String, Object> map : commentList){
						if(map.get("contents") != null && !map.get("contents").equals("")){
							map.put("contents", resetCommentContents(map.get("contents").toString().replace("\n", "</br>")));
						}
					}
					
				}
				
				mv.addObject("commentList", commentList);
				
				mv.setViewName("/share/comment/commentPrint");
				
			}else{
				
				if(CloudConnetInfo.getBuildType().equals("cloud")){
					mv.addObject("profilePath", "/upload/" + loginVO.getGroupSeq() + "/img/profile/" + loginVO.getGroupSeq());
				}else{
					mv.addObject("profilePath", "/upload/img/profile/" + loginVO.getGroupSeq());
				}		
				
				mv.addObject("loginVO", loginVO);
				params.put("groupSeq", loginVO.getGroupSeq());
				params.put("pathSeq", "2");
				params.put("osType", NeosConstants.SERVER_OS);	
				Map<String, Object> pathMap = groupManageService.selectGroupPath(params);
				params.put("absolPath", pathMap.get("absolPath"));
				
				 //모듈별 용량제한(갯수,용량) 옵션값 가져오기
				String optionId = "";
				String moduleId = "cm";
				
				 Map<String, Object> mp = new HashMap<String, Object>();
				 params.put("osType", NeosConstants.SERVER_OS);
				 
				 String moduleGbnCode = "";
				 
				 if(params.get("moduleGbnCode") != null){
					 
					 moduleGbnCode = params.get("moduleGbnCode").toString();
					 
					 if(moduleGbnCode.equals("eap")){
						 params.put("pathSeq", "100");
						 optionId = "pathSeqEa";
						 moduleId = "ea";
					 }else if(moduleGbnCode.equals("ea")){
						 params.put("pathSeq", "200");
						 optionId = "pathSeqEa";
						 moduleId = "ea";
					 }else if(moduleGbnCode.equals("board")){
						 params.put("pathSeq", "500");
						 optionId = "pathSeq500";
						 moduleId = "board";
					 }else if(moduleGbnCode.equals("doc")){					 
						 params.put("pathSeq", "600");
						 optionId = "pathSeq600";
						 moduleId = "doc";
					 }else if(moduleGbnCode.equals("report")){
						 params.put("pathSeq", "1300");
						 optionId = "pathSeq400";
						 moduleId = "report";
					 }else if(moduleGbnCode.equals("project")){
						 params.put("pathSeq", "300");
						 optionId = "pathSeq300";
						 moduleId = "project";
					 }else if(moduleGbnCode.equals("schedule")){
						 params.put("pathSeq", "400");
						 optionId = "pathSeq400";
						 moduleId = "schedule";
					 }else {
						 params.put("pathSeq", "0");
						 moduleId = moduleGbnCode;
					 }
				 }else{
					 params.put("pathSeq", "0");
				 }
				 
				 if(!params.get("pathSeq").equals("0")){		
					mp = (Map<String, Object>) commonSql.select("AttachFileUpload.selectGroupPathInfo", params);
					if(mp != null) {
						mv.addObject("groupPathInfo", mp);
					}
				 }
				 
				//모듈별 첨부파일 보기 설정 옵션 가져오기(문서뷰어 or 파일다운)
				params.put("optionId", "cm1700");
				String cmmOptionValue = (String) commonSql.select("CmmnCodeDetailManageDAO.getOptionSetValue", params);
				
				if(cmmOptionValue.equals("1") && !params.get("pathSeq").equals("0")){
					
					params.put("optionId", optionId);
					Map<String, Object> optionMap = (Map<String, Object>) commonSql.select("CmmnCodeDetailManageDAO.getOptionSetValueMap", params);
					
					 if(optionMap != null){				 
						 //미선택
						 if(optionMap.get("val").toString().equals("999")){
							 mv.addObject("downloadType", "-1");
						 }
						 else{
							 String optionValueArr[] = optionMap.get("val").toString().split("\\|");
							 if(optionValueArr.length == 2) {
								 mv.addObject("downloadType", "0");
							 }
							 else{
								 if(optionValueArr[0].equals("0")) {
									 mv.addObject("downloadType", "2");
								 }
								 else {
									 mv.addObject("downloadType", "1");
								 }
							 }
						 }
					 }else{
						 mv.addObject("downloadType", "1");
					 }				
				}else{
					mv.addObject("downloadType", "1");
				}
				
				//activeX 사용유무 설정값 가져오기
				params.put("optionId", "cm410");
				Object option = commonSql.select("CmmnCodeDetailManageDAO.getOptionSetValue", params);
				
				if(option == null) {
					mv.addObject("activxYn", "N");
				}
				
				else{
					if(option.equals("1")){
						mv.addObject("activxYn", "Y");
					}
					else {
						mv.addObject("activxYn", "N");
					}
				}
				
				//확장자 제한 파라미터 체크
				String allowExtention = "";
				String blockExtention = "";
				
				if(params.get("allowExtention") != null && !params.get("allowExtention").toString().equals("")){
					allowExtention = params.get("allowExtention").toString();
				}else {

					//공통옵션 체크
					params.put("optionId", "cm1710");
					String cm1710 = (String)commonSql.select("CmmnCodeDetailManageDAO.getOptionSetValue", params);
					
					if(cm1710 != null) {
						
						if(cm1710.equals("1")){
							//전체적용 
							params.put("optionId", "cm1711");
							String cm1711 = (String)commonSql.select("CmmnCodeDetailManageDAO.getOptionSetValue", params);
							
							if(cm1711 != null) {
								
								String[] extOptionValueArray = cm1711.split("▦",-1);
								
								if(extOptionValueArray.length > 1) {
									
									if(extOptionValueArray[0].equals("limit")) {
										blockExtention = extOptionValueArray[1];
									}else {
										allowExtention = extOptionValueArray[1];
									}
								}	
							}
							
						}else if(cm1710.equals("2")){
							//모듈별
							String extOptionID = "";
							
							if(moduleGbnCode.equals("eap") || moduleGbnCode.equals("ea")) {
								extOptionID = "cm1712";//전자결재 
							}else if(moduleGbnCode.equals("project")) {
								extOptionID = "cm1714";//업무관리 
							}else if(moduleGbnCode.equals("schedule")) {
								extOptionID = "cm1715";//일정|노트 
							}else if(moduleGbnCode.equals("report")) {
								extOptionID = "cm1716";//업무보고 
							}else if(moduleGbnCode.equals("board")) {
								extOptionID = "cm1717";//게시판 
							}else if(moduleGbnCode.equals("doc")) {
								extOptionID = "cm1718";//문서 
							}
							
							if(!extOptionID.equals("")) {
								params.put("optionId", extOptionID);
								String cm1711 = (String)commonSql.select("CmmnCodeDetailManageDAO.getOptionSetValue", params);
								
								if(cm1711 != null) {
									
									String[] extOptionValueArray = cm1711.split("▦",-1);
									
									if(extOptionValueArray.length > 1) {
										
										if(extOptionValueArray[0].equals("limit")) {
											blockExtention = extOptionValueArray[1];
										}else {
											allowExtention = extOptionValueArray[1];
										}
									}	
								}								
							}
						}
					}
				}
				
				mv.addObject("allowExtention", allowExtention);
				mv.addObject("blockExtention", blockExtention);				
				
				if(params.get("styleTp") == null){
					
					params.put("optionId", "cm1750_" + moduleId);
					option = commonSql.select("CmmnCodeDetailManageDAO.getOptionSetValue", params);
					
					if(option != null){
						params.put("styleTp", option);
					}
					
				}
				
				if(params.get("imgPreYn") == null){
					
					params.put("optionId", "cm1751_" + moduleId);
					option = commonSql.select("CmmnCodeDetailManageDAO.getOptionSetValue", params);
					
					if(option != null){
						params.put("imgPreYn", option);
					}
					
				}				
				
				mv.addObject("inlineViewYn", BizboxAProperties.getCustomProperty("BizboxA.inlineViewYn"));
				mv.setViewName("/share/comment/comment");	
			}
			
		}else{
			mv.setViewName("/share/comment/commentPrint");
		}
		
		mv.addObject("params", params);

		return mv;
	}
	
	private String resetCommentContents(String contents){
		
		if(contents.indexOf("|>@empseq=\"") > -1){
			
			int startIdx = contents.indexOf("|>@empseq=\"");
			int endIdx = contents.indexOf("\"@<|");			
			
			String resultHtml = contents.substring(0,startIdx);
			String userInfoText = contents.substring(startIdx + 11, endIdx);
			String[] userInfo = userInfoText.split("\",name=\"");
			
			if(userInfo.length == 2){
				resultHtml = resultHtml + "<input type=\"button\" name=\"mentionSpan\" class=\"mentionSpan\" contenteditable=\"true\" value=\""+userInfo[1]+"\">";
			}
			
			resultHtml = resultHtml + contents.substring(endIdx + 4);
			
			return resetCommentContents(resultHtml);			
			
		}else{
			return contents;
		}
		
	}
	
	private static String manualDomain = "";
	
	@RequestMapping("/manualReset.do")
	public ModelAndView manualReset(@RequestParam Map<String, Object> params, HttpServletRequest request){
		ModelAndView mv = new ModelAndView();
		mv.addObject("oldManualDomain", manualDomain);
		manualDomain = "";
		mv.setViewName("jsonView");
		return mv;
	}
	
	@RequestMapping("/manual.do")
	public ModelAndView manual(@RequestParam Map<String, Object> params, HttpServletRequest request){
		ModelAndView mv = new ModelAndView();
		
		if(params != null) {
			if(params.containsKey("type")) {
				String type = (String) params.get("type");
				params.put("type", type.replaceAll("<script>", "").replaceAll("</script>", ""));
			}
			if(params.containsKey("name")) {
				String name = (String) params.get("name");
				params.put("name", name.replaceAll("<script>", "").replaceAll("</script>", ""));
			}
		}
		
		if(manualDomain.equals("")){
			
			LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
			params.put("groupSeq", loginVO.getGroupSeq());
			
			@SuppressWarnings("unchecked")
			Map<String, Object> mp = (Map<String, Object>) commonSql.select("GroupManage.getGroupInfo", params);
			
			if(mp != null && !mp.get("manualUrl").equals("")){
				manualDomain = mp.get("manualUrl").toString();
			}else{
				manualDomain = "http://manual.bizboxa.com";
			}
			
			params.put("groupSeq", mp.get("groupSeq"));			
		}
		
		mv.addObject("manualDomain", manualDomain);
		mv.setViewName("/share/manual/manual");
		mv.addObject("params", params);
		return mv;
	}	
	
	@RequestMapping("/getMentionList.do")
	public ModelAndView getMentionList(@RequestParam Map<String, Object> params, HttpServletRequest request) {
		
		ModelAndView mv = new ModelAndView();

		Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();
		
		if (isAuthenticated) {
			LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
			params.put("langCode", loginVO.getLangCode());
			params.put("compSeq", loginVO.getCompSeq());
			params.put("empSeq", loginVO.getUniqId());
			
			List<Map<String,Object>> mentionList = commonSql.list("Empmanage.getMentionList", params);
			mv.addObject("mentionList", mentionList);
		}
		
		mv.addObject("searchSeq", params.get("searchSeq"));
		mv.setViewName("jsonView");

		return mv;
	}
	
	@RequestMapping("/getCommentRecvEmpList.do")
	public ModelAndView getCommentRecvEmpList(@RequestParam Map<String, Object> params, HttpServletRequest request) {
		
		ModelAndView mv = new ModelAndView();

		Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();
		
		if (isAuthenticated) {
			LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
			params.put("langCode", loginVO.getLangCode());
			params.put("compSeq", loginVO.getCompSeq());
			params.put("empSeq", loginVO.getUniqId());
			
			List<Map<String,Object>> recvEmpList = commonSql.list("Empmanage.getCommentRecvEmpList", params);
			mv.addObject("recvEmpList", recvEmpList);
		}
		
		mv.setViewName("jsonView");

		return mv;
	}	
	
	@RequestMapping("/updateAttachDetail.do")
	public ModelAndView updateAttachDetail(@RequestParam Map<String, Object> params, HttpServletRequest request) {
		
		ModelAndView mv = new ModelAndView();

		Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();
		
		if (isAuthenticated) {
			params.put("useYn", "N");
			commonSql.update("AttachFileUpload.updateAttachFileDetail", params);
			mv.addObject("result", "1");
		}else{
			mv.addObject("result", "-1");
		}
		
		mv.setViewName("jsonView");

		return mv;
	}	
	
	@SuppressWarnings("unchecked")
	@RequestMapping("/ajaxFileUploadProcView.do")
	public ModelAndView ajaxFileUploadProcView(@RequestParam Map<String,Object> params, HttpServletRequest request) throws Exception {

		ModelAndView mv = new ModelAndView();
		mv.addObject("uploadMode",params.get("uploadMode"));

		//2022-06-03 세션 미생성시 return null;
		LoginVO loginVOCheck = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser();
		if(loginVOCheck == null) {
			org.apache.log4j.Logger.getLogger( BizboxMainController.class ).info("세션이 존재하지 않습니다. loginVO : " + loginVOCheck);	
			return null;
		}
		
		
		//groupSeq 체크
		if(params.get("groupSeq") == null || params.get("groupSeq").toString().equals("")){
			LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
			if(loginVO != null && loginVO.getGroupSeq() != null) {
				params.put("groupSeq", loginVO.getGroupSeq());
			}
			else{
				Map<String, Object> mp = (Map<String, Object>) commonSql.select("GroupManage.getGroupInfo", params);
				params.put("groupSeq", mp.get("groupSeq"));
			}
		}

		mv.addObject("groupSeq",params.get("groupSeq"));
		String pathSeq = "";

		//업로드용량제한 파라미터 체크
		if(params.get("allowFileSize") != null && !params.get("allowFileSize").toString().equals("")){
			String allowFileSize = params.get("allowFileSize") + "";
			try{
				int checkSize = Integer.parseInt(allowFileSize);
				mv.addObject("allowFileSize", checkSize);
			}catch(Exception E){
				mv.addObject("allowFileSize", "");
			}
		}

		if(params.get("allowFileCnt") != null && !params.get("allowFileCnt").toString().equals("")){
			try{
				mv.addObject("allowFileCnt", Integer.parseInt(params.get("allowFileCnt").toString()));
			}catch(Exception e){
				mv.addObject("allowFileCnt", "");
			}			
		}

		if(params.get("pathSeq") != null && !params.get("pathSeq").toString().equals("")){
			pathSeq = params.get("pathSeq") + "";
		}
		else{
			params.put("pathSeq", "0");
			pathSeq = "0";
		}

		params.put("osType", NeosConstants.SERVER_OS);	

		Map<String, Object> pathMap = (Map<String, Object>) commonSql.select("GroupManage.selectGroupPathList", params);

		if(pathMap == null){
			params.put("pathSeq", "0");
			pathMap = (Map<String, Object>) commonSql.select("GroupManage.selectGroupPathList", params);
		}

		params.put("drmUseYn", pathMap.get("drmUseYn"));
		params.put("absolPath", pathMap.get("absolPath"));
		mv.addObject("params", params);
		mv.addObject("pathSeq", params.get("pathSeq"));

		//업무보고 옵션 예외처리
		if(params.get("moduleGbn") != null) {

			if(params.get("moduleGbn").equals("REPORT")) {
				pathSeq = "1300";
			}

		}

		//첨부파일 타입 기본값 설정
		String viewType = "Thumbnail";

		if(params.get("displayMode") != null && params.get("displayMode").toString().equals("L")) {
			viewType = "List";
		}else if(params.get("viewType") != null) {
			viewType = params.get("viewType").toString();
		}else {

			String viewOptionID = "";

			if(pathSeq.equals("100") || pathSeq.equals("200") || pathSeq.equals("1400")) {
				viewOptionID = "cm1721";//전자결재 
			}else if(pathSeq.equals("300")) {
				viewOptionID = "cm1723";//업무관리 
			}else if(pathSeq.equals("400") || pathSeq.equals("1000")) {
				viewOptionID = "cm1724";//일정|노트 
			}else if(pathSeq.equals("1300")) {
				viewOptionID = "cm1725";//업무보고 
			}else if(pathSeq.equals("500")) {
				viewOptionID = "cm1726";//게시판 
			}else if(pathSeq.equals("600")) {
				viewOptionID = "cm1727";//문서 
			}

			if(!viewOptionID.equals("")) {
				params.put("optionId", viewOptionID);
				params.put("compSeq", "0");
				String cm1720 = (String)commonSql.select("CmmnCodeDetailManageDAO.getOptionSetValue", params);


				if(cm1720 != null) {
					viewType = cm1720;
				}								
			}				
		}

		mv.addObject("viewType", viewType);

		if(params.get("uploadMode").equals("U")){
			
			/*
			//업로더 설정옵션 가져오기
			params.put("optionId", "cm400");
			params.put("compSeq", "0");
			Object option = commonSql.select("CmmnCodeDetailManageDAO.getOptionSetValue", params);			

			if(option.equals("0")){
				viewName = "dext5FileUploader";
			}
			*/
			
			//확장자 제한 파라미터 체크
			String allowExtention = "";
			String blockExtention = "";

			//공통옵션 체크
			params.put("optionId", "cm1710");
			String cm1710 = (String)commonSql.select("CmmnCodeDetailManageDAO.getOptionSetValue", params);

			// cm1710: 첨부파일 확장자 설정
			// 1: 전체적용
			// 2: 선택적용
			// 3: 미사용

			if(cm1710 != null) {

				if(cm1710.equals("1")){
					//전체적용 
					params.put("optionId", "cm1711");
					String cm1711 = (String)commonSql.select("CmmnCodeDetailManageDAO.getOptionSetValue", params);

					if(cm1711 != null) {

						String[] extOptionValueArray = cm1711.split("▦",-1);

						if(extOptionValueArray.length > 1) {

							if(extOptionValueArray[0].equals("limit")) {
								blockExtention = extOptionValueArray[1];
							}else {
								allowExtention = extOptionValueArray[1];
							}
						}	
					}

				}else if(cm1710.equals("2")){
					//모듈별
					String extOptionID = "";
					if(pathSeq.equals("100") || pathSeq.equals("200") || pathSeq.equals("1400")) {
						extOptionID = "cm1712";//전자결재 
					}else if(pathSeq.equals("300")) {
						extOptionID = "cm1714";//업무관리 
					}else if(pathSeq.equals("400") || pathSeq.equals("1000")) {
						extOptionID = "cm1715";//일정|노트 
					}else if(pathSeq.equals("1300")) {
						extOptionID = "cm1716";//업무보고 
					}else if(pathSeq.equals("500")) {
						extOptionID = "cm1717";//게시판 
					}else if(pathSeq.equals("600")) {
						extOptionID = "cm1718";//문서 
					}
					// extOptionID: 모듈별 확장자 제한 설정

					if(!extOptionID.equals("")) {
						params.put("optionId", extOptionID);
						String cm1711 = (String)commonSql.select("CmmnCodeDetailManageDAO.getOptionSetValue", params);

						if(cm1711 != null) {

							String[] extOptionValueArray = cm1711.split("▦",-1);

							if(extOptionValueArray.length > 1) {

								if(extOptionValueArray[0].equals("limit")) {
									// cm1711 -> 첫번째 인자 limit이면 제한확장자 -> 1번째 인자 제한(block)
									blockExtention = extOptionValueArray[1];
								}else {
									// cm1711 -> 두번째 인자 limit이 아니면(permit) 허용확장자 -> 1번쨰 인자 허용(allow)
									allowExtention = extOptionValueArray[1];
								}
							}	
						}								
					}
				}
			}
			

			mv.addObject("allowExtention", allowExtention);
			mv.addObject("blockExtention", blockExtention);

			//자동첨부 파일리스트 조회
			if(params.get("fileKey") != null && ! params.get("fileKey").toString().equals("") ){

				Map<String, Object> mp = new HashMap<String, Object>();
				mp.put("groupSeq", params.get("groupSeq"));
				mp.put("pathSeq", "0");
				mp.put("osType", NeosConstants.SERVER_OS);

				Map<String, Object> pathMp = (Map<String, Object>) commonSql.select("GroupManage.selectPathInfo", mp);				

				String saveFilePath = pathMp.get("absolPath").toString() + File.separator + "uploadTemp" + File.separator + params.get("fileKey").toString();
				String fileNms = "";
				String fileSize = "";
				File folder = new File(saveFilePath);
				File[] listOfFiles = folder.listFiles();

				if(listOfFiles != null){
					for(int i=0;i<listOfFiles.length;i++){
						fileNms = fileNms + listOfFiles[i].getName() + "" + "|";
						fileSize = listOfFiles[i].length() + "|";
					}

					mv.addObject("deleteYN",params.get("fileKey").toString().substring(0,1));
					mv.addObject("fileNms",fileNms);
					mv.addObject("autoFileSizeList",fileSize);
					mv.addObject("fileKey",params.get("fileKey"));					
				}
				mv.addObject("pathMp", pathMp);
			}
		}else{
			//activeX 사용유무 설정값 가져오기
			params.put("optionId", "cm410");
			Object option = commonSql.select("CmmnCodeDetailManageDAO.getOptionSetValue", params);

			if(option == null) {
				mv.addObject("activxYn", "N");
			}

			else{
				if(option.equals("1")){
					LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
					mv.addObject("activxYn", "Y");
					if(loginVO != null) {
						mv.addObject("loginId", loginVO.getId());
					}
				}
				else {
					mv.addObject("activxYn", "N");
				}
			}			
		}

		//로컬 파일경로 저장옵션
		params.put("optionId", "cm411");
		Object showPath = commonSql.select("CmmnCodeDetailManageDAO.getOptionSetValue", params);

		if(showPath == null) {
			mv.addObject("showPath", "0");
		}

		else{
			mv.addObject("showPath", showPath);
		}		

		//모듈별 첨부파일 보기 설정 옵션 가져오기(문서뷰어 or 파일다운)
		params.put("optionId", "cm1700");
		String cmmOptionValue = (String) commonSql.select("CmmnCodeDetailManageDAO.getOptionSetValue", params);
		if(cmmOptionValue.equals("1") && !params.get("pathSeq").equals("0")){
			//downloadType : -1 -> 미선택
			//downloadType : 0 -> 문서뷰어+파일다운
			//downloadType : 1 -> 파일다운
			//downloadType : 2 -> 문서뷰어
			String downloadType = "";			 

			if(params.get("pathSeq").toString().equals("100") || params.get("pathSeq").toString().equals("200") || params.get("pathSeq").toString().equals("1400")) {
				params.put("pathSeq", "Ea");
			}

			params.put("optionId", "pathSeq" + params.get("pathSeq"));

			Map<String, Object> optionMap = (Map<String, Object>) commonSql.select("CmmnCodeDetailManageDAO.getOptionSetValueMap", params);

			if(optionMap != null){				 
				//미선택
				if(optionMap.get("val").toString().equals("999")){
					downloadType = "-1";
				}
				else{
					String optionValueArr[] = optionMap.get("val").toString().split("\\|");
					if(optionValueArr.length == 2) {
						downloadType = "0";
					}
					else{
						if(optionValueArr[0].equals("0")) {
							downloadType = "2";
						}
						else {
							downloadType = "1";
						}
					}

				}
			}else{
				downloadType = "1";
			}
			mv.addObject("downloadType", downloadType);
		}else{
			mv.addObject("downloadType", "1");
		}


		//모듈별 용량제한(갯수,용량) 옵션값 가져오기
		Map<String, Object> mp = new HashMap<String, Object>();
		params.put("osType", NeosConstants.SERVER_OS);
		params.put("pathSeq", pathSeq);
		if(params.get("pathSeq") != null && !params.get("pathSeq").toString().equals("") && !params.get("pathSeq").toString().equals("0")){		
			mp = (Map<String, Object>) commonSql.select("AttachFileUpload.selectGroupPathInfo", params);
			if(mp != null) {
				mv.addObject("groupPathInfo", mp);
			}
		}

		String buildType = CloudConnetInfo.getBuildType();
		mv.addObject("buildType", buildType);

		if(buildType.equals("cloud")){
			//그룹웨어 총 업로드파일용량 및 계약용량(클라우드용)
			Map<String, Object> gwVolumeInfo = (Map<String, Object>) commonSql.select("GetGwUploadTotalFileSize",params);
			mv.addObject("gwVolumeInfo", gwVolumeInfo);
		}

		mv.addObject("inlineViewYn", BizboxAProperties.getCustomProperty("BizboxA.inlineViewYn"));
		mv.setViewName("/share/uploader/dzUpDownloader");	

		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		mv.addObject("loginVO", loginVO);

		return mv;
	}
		

	@SuppressWarnings("unchecked")
	@RequestMapping("/docViewerPop.do")
	public ModelAndView docViewerPop(@RequestParam Map<String,Object> params, HttpServletRequest request) throws Exception {
		ModelAndView mv = new ModelAndView();
		
		String moduleTp = params.get("moduleTp") + "";

		params.put("osType", NeosConstants.SERVER_OS);
		
		String groupSeq = params.get("groupSeq")+"";
	 	if (EgovStringUtil.isEmpty(groupSeq)) {
	 		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
	 		
	 		if(loginVO == null) {
				mv.addObject("result", "세션이 만료되었습니다.");
				mv.setViewName("jsonView");
	 			return mv; 
	 		}else {
	 			params.put("groupSeq", loginVO.getGroupSeq());	
	 		}
	 	}
		
	 	//edms 업로드경로 찾기위한 변수
	 	Map<String, Object> fileMap = null;
	 	String pathSeq = "1100";
	 	
	 	if(params.get("moduleTp").toString().equals("gw")){
	 		fileMap = (Map<String, Object>) commonSql.select("AttachFileUpload.getFilePathInfoGw", params);
	 		pathSeq = fileMap.get("pathSeq") + "";
	 	}
	 	else if(params.get("moduleTp").toString().equals("board")){
	 		fileMap = (Map<String, Object>) commonSql.select("AttachFileUpload.getFilePathInfoBoard", params);
	 	}
	 	else if(params.get("moduleTp").toString().equals("doc")){
	 		fileMap = (Map<String, Object>) commonSql.select("AttachFileUpload.getFilePathInfoDoc", params);
	 	}
	 	else if(params.get("moduleTp").toString().equals("doc_old")){
	 		fileMap = (Map<String, Object>) commonSql.select("AttachFileUpload.getFilePathInfoDocOld", params);
	 	}	 	
	 	else if(params.get("moduleTp").toString().equals("bpm")){
	 		fileMap = (Map<String, Object>) commonSql.select("AttachFileUpload.getFilePathInfoBpm", params);
	 	}
		
		ConvertHtmlHelper convert = new ConvertHtmlHelper();
		
		String docConvertPath = BizboxAProperties.getProperty("BizboxA.DocConvert.path");
		String fileLocalPath = fileMap.get("fileFullPath") + "";
		String saveLocalPath = fileMap.get("filePath").toString();
		
		if(!new File(fileMap.get("fileFullPath") + "").isFile() && new File(fileMap.get("fileFullPathMig") + "").isFile()){
			fileLocalPath = fileMap.get("fileFullPathMig").toString();
			saveLocalPath = fileMap.get("filePathMig").toString();
		}
		
		String filePath = saveLocalPath;
		
		if(moduleTp.equals("gw")){
			saveLocalPath += fileMap.get("fileId").toString() + fileMap.get("fileSn").toString() +  "/";
		}else{
			saveLocalPath += fileMap.get("fileSeqNo").toString() + "/";
		}
		
		fileLocalPath = fileLocalPath.replace("//", "/");
		
		/** 절대경로 조회 */
		params.put("pathSeq", "0");
		params.put("osType", NeosConstants.SERVER_OS);
		Map<String, Object> groupPahtInfo = groupManageService.selectGroupPath(params);

		saveLocalPath = groupPahtInfo.get("absolPath") + "/convertDocTemp/" + pathSeq + "_" + CommonUtil.sha256Enc(saveLocalPath, "") + "/";
		
		//이미 변환처리된 건인지 체크
		File chk = new File(saveLocalPath + "document.html");

		if (!chk.exists()) {
			//DRM 체크
			String drmPath = drmService.drmConvert("V", params.get("groupSeq").toString(), pathSeq, filePath.replace("//", "/"), fileMap.get("streFileName").toString(), fileMap.get("fileExtsn").toString());
			convert.convertHtml(docConvertPath, drmPath, saveLocalPath, "document.html", (drmPath.contains("drmDecTemp") && !filePath.contains("drmDecTemp")));
		}		
		
		Map<String, String> docMap = convert.checkConvertHtml(saveLocalPath);
		
		mv.setViewName("/share/uploader/docViewerPop");
		mv.addObject("docMap", docMap);
		
		return mv;
	}
	
	static int toDate = 0;
	static String livePathSeq = "|300|400|1000|1300|";

	@SuppressWarnings("unchecked")
	@RequestMapping("/ajaxFileUploadProc.do")
	public ModelAndView ajaxFileUploadProc(MultipartHttpServletRequest multiRequest,
			@RequestParam Map<String, Object> paramMap) throws Exception {

		//System.out.println("upload start param: " + paramMap);
		ModelAndView mv = new ModelAndView();

		LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser();
		String imgExt = "jpeg|jpg";

		//groupSeq 체크
		if(paramMap.get("groupSeq") == null || paramMap.get("groupSeq").toString().equals("")){
			loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
			if(loginVO != null && loginVO.getGroupSeq() != null) {
				paramMap.put("groupSeq", loginVO.getGroupSeq());
			}
			else{
				Map<String, Object> mp = (Map<String, Object>) commonSql.select("GroupManage.getGroupInfo", paramMap);
				paramMap.put("groupSeq", mp.get("groupSeq"));
			}
		}
		
		//System.out.println("upload param 2: " + paramMap);

		/** 파일 체크 */
		Map<String, MultipartFile> files = multiRequest.getFileMap();
		
		if (files.isEmpty()) {
			mv.addObject("result", "Empty");
			mv.setViewName("jsonView");
			return mv;
		}

		Long fileTotalSize = 0L;

		/** save file */
		Iterator<Entry<String, MultipartFile>> itr = files.entrySet().iterator(); // 파일

		// 순번
		MultipartFile file = null;
		String attachFileNm = "";
		
		String tempFolder = paramMap.get("tempFolder").toString();
		
		//비정상 호출체크
		if(tempFolder.contains("..")) {
			return mv;
		}
		
		//보안취약성 관련 수정(서버경로 재검색)
		paramMap.put("osType", NeosConstants.SERVER_OS);
		Map<String, Object> pathMp = (Map<String, Object>) commonSql.select("GroupManage.selectPathInfo", paramMap);
		
		//System.out.println("pathMp: " + pathMp);

		String tempFolderTop = pathMp.get("absolPath").toString() + File.separator + "uploadTemp" + File.separator;
		tempFolder = tempFolderTop + tempFolder;

		//System.out.println("tempFolder: " + tempFolder);

		int fileCnt = 0;
		String[] fileNamesArray = null;

		if(paramMap.get("nfcFileNames") != null && !paramMap.get("nfcFileNames").equals("")) {
			fileNamesArray = paramMap.get("nfcFileNames").toString().split("\\|");
		}

		//System.out.println("fileNamesArray: " + fileNamesArray);


		String allowExtention = "";
		String blockExtention = "";

		mv.addObject("groupSeq",paramMap.get("groupSeq"));
		String pathSeq = "";

		if(paramMap.get("uploadMode").equals("U")){
			//업로더 설정옵션 가져오기
			paramMap.put("optionId", "cm400");
			paramMap.put("compSeq", "0");
			Object option = commonSql.select("CmmnCodeDetailManageDAO.getOptionSetValue", paramMap);			
			//System.out.println("option11: " + option);

			// 임시
			pathSeq = paramMap.get("targetPathSeq")+"";

			//공통옵션 체크
			paramMap.put("optionId", "cm1710");
			String cm1710 = (String)commonSql.select("CmmnCodeDetailManageDAO.getOptionSetValue", paramMap);

			//System.out.println("cm1710: " + cm1710);
			//System.out.println("sss cm1710 : " + cm1710);
			// cm1710: 첨부파일 확장자 설정
			// 1: 전체적용
			// 2: 선택적용
			// 3: 미사용

			if(cm1710 != null) {
				
				if(cm1710.equals("1")){
					//전체적용 
					System.out.println("cm1710: " + cm1710);

					paramMap.put("optionId", "cm1711");
					String cm1711 = (String)commonSql.select("CmmnCodeDetailManageDAO.getOptionSetValue", paramMap);
					System.out.println("cm1711: " + cm1711);

					if(cm1711 != null) {

						String[] extOptionValueArray = cm1711.split("▦",-1);
						//System.out.println("extOptionValueArray: " + extOptionValueArray.toString());

						//System.out.println(cm1711);

						if(extOptionValueArray.length > 1) {
							//System.out.println("extOptionValueArray[0]: " + extOptionValueArray[0]);

							if(extOptionValueArray[0].equals("limit")) {
								blockExtention = extOptionValueArray[1];
								//System.out.println("blockExtention: " + blockExtention);
							}else {
								allowExtention = extOptionValueArray[1];
								//System.out.println("allowExtention: " + allowExtention);

							}
						}	
					}

				}else if(cm1710.equals("2")){
					//모듈별
					String extOptionID = "";
					System.out.println("pathSeq: " + pathSeq);

					if(pathSeq.equals("100") || pathSeq.equals("200")) {
						extOptionID = "cm1712";//전자결재 
					}else if(pathSeq.equals("300")) {
						extOptionID = "cm1714";//업무관리 
					}else if(pathSeq.equals("400") || pathSeq.equals("1000")) {
						extOptionID = "cm1715";//일정|노트 
					}else if(pathSeq.equals("1300")) {
						extOptionID = "cm1716";//업무보고 
					}else if(pathSeq.equals("500")) {
						extOptionID = "cm1717";//게시판 
					}else if(pathSeq.equals("600")) {
						extOptionID = "cm1718";//문서 
					}
					System.out.println("extOptionID: " + extOptionID);

					// extOptionID: 모듈별 확장자 제한 설정
					//System.out.println("extOptionID: " + extOptionID);
					if(!extOptionID.equals("")) {
						paramMap.put("optionId", extOptionID);
						String cm1711 = (String)commonSql.select("CmmnCodeDetailManageDAO.getOptionSetValue", paramMap);
						System.out.println("cm1711 : " + cm1711);

						if(cm1711 != null) {

							String[] extOptionValueArray = cm1711.split("▦",-1);

//							for(int i=0; i<extOptionValueArray.length; i++)
//								System.out.println("extOptionValueArray[i]: " + extOptionValueArray[i]);

							if(extOptionValueArray.length > 1) {

								if(extOptionValueArray[0].equals("limit")) {
									// cm1711 -> 첫번째 인자 limit이면 제한확장자 -> 1번째 인자 제한(block)
									blockExtention = extOptionValueArray[1];
									System.out.println("1 blockExtention: " + blockExtention);

								}else {
									// cm1711 -> 두번째 인자 limit이 아니면(permit) 허용확장자 -> 1번쨰 인자 허용(allow)
									allowExtention = extOptionValueArray[1];
									System.out.println("1 allowExtention: " + allowExtention);

								}
							}
						}								
					}
				}
			}
			


			while (itr.hasNext()) {
				Entry<String, MultipartFile> entry = itr.next();			
				file = entry.getValue();
				fileTotalSize += file.getSize();
				
				Map<String, Object> rotateImgInfoMap = null;

				String orginFileName = file.getOriginalFilename(); // 저장할 파일명
				//System.out.println("orginFileName: " + orginFileName);

				if(fileNamesArray != null) {
					orginFileName = new String(org.apache.commons.codec.binary.Base64.decodeBase64(fileNamesArray[fileCnt].getBytes("UTF-8")), "UTF-8");
					//System.out.println("orginFileName utf=8: " + orginFileName);
					fileCnt++;
				}

				/* path traversal 방지 2022-05-31 */
				try {
					orginFileName = EgovWebUtil.filePathBlackList(orginFileName);
				} catch (Exception e) {
					continue;
				}
				
				/* 확장자 */
				int index = orginFileName.lastIndexOf(".");
				if (index == -1) {
					continue;
				}
				
				
				
				/* 확장자 체크 */
				// fileExt : 확장자
				String fileExt = orginFileName.substring(index + 1);
				//System.out.println("fileExt: " + fileExt);

				if(!allowExtention.equals("") && ("|" + allowExtention + "|").indexOf("|" + fileExt.toLowerCase().substring(0) + "|") == -1){
					// 허용확장자
					continue;
				}else if(!blockExtention.equals("") && ("|" + blockExtention + "|").indexOf("|" + fileExt.toLowerCase().substring(0) + "|") > -1){
					// 제한확장자
					continue;
				}else if(fileExt == null){
					continue;
				}
				
				String saveFilePath = tempFolder + File.separator + orginFileName;
				//System.out.println("saveFilePath: " + saveFilePath);

				if(imgExt.indexOf(fileExt.toLowerCase()) != -1){
					
					File saveFile = new File(saveFilePath);
					
					EgovFileUploadUtil.saveFile(file.getInputStream(), saveFile);
					rotateImgInfoMap = calcImgFileOrientation(saveFile);
					
					// 이미지가 회전 되어있을 경우 회전 후 덮어쓰기
					if((int)rotateImgInfoMap.get("orientation") != 1 || (int)rotateImgInfoMap.get("width") != 0) {
						saveRotateImgFile(saveFile, rotateImgInfoMap, saveFilePath, fileExt);
					}
				}else {
										
					File saveFile = new File(saveFilePath);
					//System.out.println("saveFile: " + saveFile);

					EgovFileUploadUtil.saveFile(file.getInputStream(), saveFile);
				}

				String newName = orginFileName.substring(0, index);
				//System.out.println("newName: " + newName);

				String targetPathSeq = paramMap.get("targetPathSeq") + "";
				//System.out.println("targetPathSeq: " + targetPathSeq);

				//DRM 체크
				drmService.drmConvert("U", loginVO != null ? loginVO.getGroupSeq() : "", targetPathSeq, tempFolder, newName, fileExt);

				attachFileNm += "|" + orginFileName;

			}
		}

		Map<String, Object> resultMap = new HashMap<String, Object>();
		if (attachFileNm.length() > 0) {
			resultMap.put("attachFileNm", attachFileNm.substring(1));
		}
		else {
			resultMap.put("attachFileNm", attachFileNm);
		}

		//임시폴더 정리
		Date dt = new Date();
		SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");			
		int today = Integer.parseInt(sdf.format(dt)); 
		//System.out.println("today: " + today);
		//System.out.println("toDate: " + toDate);
		if(toDate < today) {
			toDate = today;
			livePathSeq = "|300|400|1000|1300|";
		}
		
		//System.out.println("livePathSeq: " + livePathSeq);

		
		
		
		if(!livePathSeq.contains("|" + pathSeq + "|")) {
			
			livePathSeq += pathSeq + "|";
			//System.out.println("livePathSeq 2: " + livePathSeq);

			String cmd = "find " + tempFolderTop + " -mindepth 1 -type d -empty -mtime +1 -delete";
			
			//System.out.println("ajaxFileUploadProc.executeCommand Start : " + cmd);
			
			try {
				ShellExecHelper.executeCommand(cmd);
				//System.out.println("ajaxFileUploadProc.executeCommand Result : " + );
			}catch(Exception ex) {
				CommonUtil.printStatckTrace(ex);//오류메시지를 통한 정보노출
				//System.out.println("ajaxFileUploadProc.executeCommand Error : " + ex.getMessage());
			}
		}
		
		mv.addObject("fileTotalSize", fileTotalSize);
		mv.addAllObjects(resultMap);
		mv.setViewName("jsonView");
		return mv;
	}
	
	@RequestMapping("/ajaxFileUploadProcComment.do")
	public ModelAndView ajaxFileUploadProcComment(MultipartHttpServletRequest multiRequest,
			@RequestParam Map<String, Object> paramMap) throws Exception {
		ModelAndView mv = new ModelAndView();

		/** 파일 체크 */
		Map<String, MultipartFile> files = multiRequest.getFileMap();
		if (files.isEmpty()) {
			mv.addObject("result", "Empty");
			mv.setViewName("jsonView");
			return mv;
		}

		Long fileTotalSize = 0L;
		
		/** save file */
		Iterator<Entry<String, MultipartFile>> itr = files.entrySet().iterator(); // 파일
		MultipartFile file = null;

		String fileId = paramMap.get("fileId").toString();
		int fileSn = 0;
		long fileSz = 0L;	
		
		if(fileId.equals("")){
			fileId  = java.util.UUID.randomUUID().toString().replaceAll("-", "");
		}else{
			//MAX fileSn 조회
			fileSn = (int)commonSql.select("AttachFileUpload.selectAttachFileMaxSn",paramMap) + 1;
		}
		
		String absolPath = paramMap.get("absolPath").toString();
		String relativePath = File.separator + paramMap.get("moduleGbnCode").toString() + File.separator + fileId;
		String saveFilePath = absolPath + relativePath;
		
		List<Map<String,Object>> saveFileList  = new ArrayList<Map<String,Object>>();		// 파일 저장 리스트
		
		Map<String,Object> newFileInfo = null;
		
		//확장자 제한 파라미터 체크
		String allowExtention = "";
		String blockExtention = "";
		
		// 모듈코드
		String moduleGbnCode = paramMap.get("moduleGbnCode").toString();
		
		if(paramMap.get("allowExtention") != null && !paramMap.get("allowExtention").toString().equals("")){
			allowExtention = paramMap.get("allowExtention").toString();
		}else {

			//공통옵션 체크
			paramMap.put("optionId", "cm1710");
			String cm1710 = (String)commonSql.select("CmmnCodeDetailManageDAO.getOptionSetValue", paramMap);
			
			if(cm1710 != null) {
				
				if(cm1710.equals("1")){
					//전체적용 
					paramMap.put("optionId", "cm1711");
					String cm1711 = (String)commonSql.select("CmmnCodeDetailManageDAO.getOptionSetValue", paramMap);
					
					if(cm1711 != null) {
						
						String[] extOptionValueArray = cm1711.split("▦",-1);
						
						if(extOptionValueArray.length > 1) {
							
							if(extOptionValueArray[0].equals("limit")) {
								blockExtention = extOptionValueArray[1];
							}else {
								allowExtention = extOptionValueArray[1];
							}
						}	
					}
					
				}else if(cm1710.equals("2")){
					//모듈별
					String extOptionID = "";
					
					if(moduleGbnCode.equals("eap") || moduleGbnCode.equals("ea")) {
						extOptionID = "cm1712";//전자결재 
					}else if(moduleGbnCode.equals("project")) {
						extOptionID = "cm1714";//업무관리 
					}else if(moduleGbnCode.equals("schedule")) {
						extOptionID = "cm1715";//일정|노트 
					}else if(moduleGbnCode.equals("report")) {
						extOptionID = "cm1716";//업무보고 
					}else if(moduleGbnCode.equals("board")) {
						extOptionID = "cm1717";//게시판 
					}else if(moduleGbnCode.equals("doc")) {
						extOptionID = "cm1718";//문서 
					}
					
					if(!extOptionID.equals("")) {
						paramMap.put("optionId", extOptionID);
						String cm1711 = (String)commonSql.select("CmmnCodeDetailManageDAO.getOptionSetValue", paramMap);
						
						if(cm1711 != null) {
							
							String[] extOptionValueArray = cm1711.split("▦",-1);
							
							if(extOptionValueArray.length > 1) {
								
								if(extOptionValueArray[0].equals("limit")) {
									blockExtention = extOptionValueArray[1];
								}else {
									allowExtention = extOptionValueArray[1];
								}
							}	
						}								
					}
				}
			}
		}
		
		
		
		while (itr.hasNext()) {
			Entry<String, MultipartFile> entry = itr.next();			
			file = entry.getValue();
			fileTotalSize += file.getSize();
			String orginFileName = file.getOriginalFilename(); // 저장할 파일명
			
			/* 확장자 */
			int index = orginFileName.lastIndexOf(".");
			if (index == -1) {
				continue;
			}
			
			String fileExt = file.getOriginalFilename().substring(index + 1);
			
			if(!allowExtention.equals("") && ("|" + allowExtention + "|").indexOf("|" + fileExt.toLowerCase().substring(0) + "|") == -1){
				// 허용확장자
				//System.out.println(ExtCheck.toString());
			}else if(!blockExtention.equals("") && ("|" + blockExtention + "|").indexOf("|" + fileExt.toLowerCase().substring(0) + "|") > -1){
				// 제한확장자
				//System.out.println(ExtCheck.toString());
			}else if(fileExt == null){
				//System.out.println(ExtCheck.toString());
			}
			
			String orignlFileName = file.getOriginalFilename().substring(0, index);
			String newName =  EgovDateUtil.today("yyyyMMdd_HHmmss") +"_" + fileId + "_" + fileSn;	// 저장할 파일명

			fileSz = EgovFileUploadUtil.saveFile(file.getInputStream(), new File(saveFilePath+File.separator+newName+"."+fileExt));
			
			newFileInfo = new HashMap<String,Object>();
			newFileInfo.put("fileId", fileId);
			newFileInfo.put("fileSn", fileSn);
			newFileInfo.put("pathSeq", "2");
			newFileInfo.put("fileStreCours", relativePath);
			newFileInfo.put("streFileName", newName);
			newFileInfo.put("orignlFileName", orignlFileName);
			newFileInfo.put("fileExtsn", fileExt);
			newFileInfo.put("fileSize", fileSz);
			newFileInfo.put("createSeq", paramMap.get("empSeq"));
			saveFileList.add(newFileInfo);
			fileSn++;
			
			//파수DRM연동 사용시 복호화작업
			drmService.drmConvert("U", paramMap.get("groupSeq") != null ? paramMap.get("groupSeq").toString() : "", "0", saveFilePath, newName, fileExt);			
			
		}
		
		/** 파일 저장 리스트 확인 */
		if (saveFileList.size() > 0) {
			/** DB Insert */
			List<Map<String,Object>> resultList = attachFileService.insertAttachFile(saveFileList);
		}

		mv.addObject("fileTotalSize", fileTotalSize);
		mv.addObject("fileId", fileId);
		mv.setViewName("jsonView");
		return mv;
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping("/ajaxAllFileDownloadProc.do")
	public ModelAndView ajaxAllFileDownloadProc(@RequestParam Map<String, Object> paramMap, HttpServletRequest request, HttpServletResponse response) throws Exception {
		ModelAndView mv = new ModelAndView();		
		
		LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser();
		
		String[] fileIdList = paramMap.get("fileIdList").toString().split("\\|");
		String[] fileSnList = paramMap.get("fileSnList").toString().split("\\|");
		String[] moduleTpList = paramMap.get("moduleTp").toString().split("\\|");
		
		List<Map<String, Object>> fileInfoList = new ArrayList<Map<String, Object>>();
		
		String pathSeq = "";
		
		for(int i=0;i<fileIdList.length;i++){
			
			Map<String, Object> params = new HashMap<String, Object>();		
			
			params.put("uploadPath", BizboxAProperties.getEdmsProperty("UPLOAD_PATH"));
			params.put("osType", NeosConstants.SERVER_OS);
			params.put("groupSeq", loginVO.getGroupSeq());		
			params.put("fileId", fileIdList[i]);
			params.put("fileSn", fileSnList[i]);
			
			Map<String, Object> fileMap = null;

			if(moduleTpList[i].equals("gw")){
				fileMap = (Map<String, Object>) commonSql.select("AttachFileUpload.getFilePathInfoGw", params);
				pathSeq = fileMap.get("pathSeq").toString();
				
			}else if(moduleTpList[i].equals("board")){
				fileMap = (Map<String, Object>) commonSql.select("AttachFileUpload.getFilePathInfoBoard", params);
				pathSeq = "1100";
			}else if(moduleTpList[i].equals("doc")){
				fileMap = (Map<String, Object>) commonSql.select("AttachFileUpload.getFilePathInfoDoc", params);
				pathSeq = "1100";
			}else if(moduleTpList[i].equals("doc_old")){
				fileMap = (Map<String, Object>) commonSql.select("AttachFileUpload.getFilePathInfoDocOld", params);
				pathSeq = "1100";
			}else if(moduleTpList[i].equals("bpm")){
				fileMap = (Map<String, Object>) commonSql.select("AttachFileUpload.getFilePathInfoBpm", params);
				pathSeq = "1100";
			}
			
			fileInfoList.add(fileMap);			
		}
		
		
		Map<String, Object> para = new HashMap<String, Object>();
		para.put("groupSeq", loginVO.getGroupSeq());
		para.put("empSeq", loginVO.getUniqId());
		para.put("osType", NeosConstants.SERVER_OS);
		para.put("pathSeq", "0");
		
		Map<String, Object> pathMap = (Map<String, Object>) commonSql.select("AttachFileUpload.selectGroupPathList", para);
		
		File ckDir = new File(pathMap.get("absolPath") + "/AllDownTempFolder/" + loginVO.getUniqId());
		
		if (ckDir.exists()) {
			deleteAllFiles(pathMap.get("absolPath") + "/AllDownTempFolder/" + loginVO.getUniqId());
			ckDir.mkdirs();
		}else{
			ckDir.mkdirs();
		}
		
		String tmpFileName = fileInfoList.get(0).get("oriFileName").toString().substring(0,fileInfoList.get(0).get("oriFileName").toString().lastIndexOf("."));
		if(fileInfoList.size() > 1) {
			tmpFileName = tmpFileName + "(외" + (fileInfoList.size() -1) + ").zip";
		}
		else {
			tmpFileName = tmpFileName + ".zip";
		}
		
		String zipFileName = pathMap.get("absolPath") + "/AllDownTempFolder/" + loginVO.getUniqId() + "/" + tmpFileName;
		 
		String[] files = new String[fileInfoList.size()];
		
		 
		for(int i=0;i<fileInfoList.size();i++){
			
			String filePath = fileInfoList.get(i).get("filePath").toString();			
			
			if(!new File(fileInfoList.get(i).get("fileFullPath") + "").isFile() && new File(fileInfoList.get(i).get("fileFullPathMig") + "").isFile()){
				filePath = fileInfoList.get(i).get("filePathMig").toString();
			}
			
			//DRM 체크
			files[i] = drmService.drmConvert("D", loginVO.getGroupSeq(), pathSeq, filePath, fileInfoList.get(i).get("streFileName").toString(), fileInfoList.get(i).get("fileExtsn").toString());			
				
		}
		
		byte[] buf = new byte[4096];
		 
		try {
		    ZipOutputStream out = new ZipOutputStream(new FileOutputStream(zipFileName));
		 
		    for (int i=0; i<files.length; i++) {
		        FileInputStream in = new FileInputStream(files[i]);
		                
		        
		        ZipEntry ze = new ZipEntry(fileInfoList.get(i).get("oriFileName").toString());
		        out.putNextEntry(ze);
		          
		        int len;
		        while ((len = in.read(buf)) > 0) {
		            out.write(buf, 0, len);
		        }
		          
		        out.closeEntry();
		        in.close();
		 
		    }
		          
		    out.close();
		    mv.addObject("resultCode", "SUCCESS");
		    request.getSession().setAttribute("ajaxAllFileDownloadPath", zipFileName);
		    
		} catch (IOException e) {
			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
		    mv.addObject("resultCode", "FAIL");
		}
		
		mv.setViewName("jsonView");
		return mv;
	}
	

	public static void deleteAllFiles(String path){ 
		File file = new File(path); 		
		//폴더내 파일을 배열로 가져온다. 
		File[] tempFile = file.listFiles(); 
		if(tempFile.length >0){ 
			for (int i = 0; i < tempFile.length; i++) { 
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
	
	@RequestMapping("/ajaxAllFileDownload.do")
	public void ajaxAllFileDownload(@RequestParam Map<String, Object> paramMap, HttpServletRequest request, HttpServletResponse response) throws Exception {
		
		LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser();

		if (loginVO == null) {
			return;
		}
		
		String zipFileName = "";
		
		//파일경로 노출로인한 보안이슈로 세션에 저장 후 가져오는 방식으로 전환 
		if(request.getSession().getAttribute("ajaxAllFileDownloadPath") != null) {
			zipFileName = request.getSession().getAttribute("ajaxAllFileDownloadPath").toString();
			request.getSession().removeAttribute("ajaxAllFileDownloadPath");
		}else {
			return;
		}
		
		String orignlFileName = zipFileName.substring(zipFileName.lastIndexOf("/")+1);

	    String browser = request.getHeader("User-Agent");
	    
	    //파일 인코딩
	    if(browser.contains("MSIE") || browser.contains("Trident") || browser.contains("Edge")){
	    	orignlFileName = URLEncoder.encode(orignlFileName,"UTF-8").replaceAll("\\+", "%20"); 
	    } 
	    else {
	    	orignlFileName = new String(orignlFileName.getBytes("UTF-8"), "ISO-8859-1"); 
	    }
		
		File file = null;
		FileInputStream fis = null;
		
		try {
			file = new File(zipFileName);
		    fis = new FileInputStream(file);
		    
		    response.setHeader( "Content-Disposition", "attachment; filename=\""+ orignlFileName + "\"" );
			response.setContentType( CommonUtil.getContentType(file) );
			response.setHeader( "Content-Transfer-Coding", "binary" );
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
		} catch(Exception e) {
			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
			//System.out.println("Exception : " + e.getMessage());
		} finally {
			if (fis != null) {
				try {
					fis.close();
				} catch (Exception ignore) {
					//LOGGER.debug("IGNORE: {}", ignore.getMessage());
				}
			}

			//임시파일(폴더포함) 삭제
			if(file != null && file.exists()) {//Null Pointer 역참조
				String dirPath = file.getParent();
				if(file.delete()) {
					file = new File(dirPath);
					if(file.isDirectory()) {
						file.delete();	
					}
				}
			}
			
		}
	}
	
	

	@RequestMapping("/outProcessUpload.do")
	public ModelAndView outProcessUpload(MultipartHttpServletRequest multiRequest,
			@RequestParam Map<String, Object> paramMap) throws Exception {
		ModelAndView mv = new ModelAndView();

		String resultCode = "-1";
		String resultMessage = "";
		String fileKey = "";

		/** 파일 체크 */
		Map<String, MultipartFile> files = multiRequest.getFileMap();
		if (!files.isEmpty()) {
			
			if(paramMap.get("groupSeq") == null || paramMap.get("groupSeq").equals("")) {
		    	String serverName = multiRequest.getServerName();
		    	Map<String, Object> jedisMp = CloudConnetInfo.getParamMapByDomain(serverName);
		    	
		    	if(jedisMp != null && jedisMp.get("groupSeq") != null) {
		    		paramMap.put("groupSeq", jedisMp.get("groupSeq"));
		    	}
			}			

			// 인증체크
			Map<String, Object> userInfo = new HashMap<String, Object>();
			userInfo.put("osType", NeosConstants.SERVER_OS);
			
			if (paramMap.get("groupSeq") != null && paramMap.get("groupSeq").toString() != "") {
				userInfo.put("groupSeq", paramMap.get("groupSeq"));
			}			

			if (paramMap.get("compSeq") != null && paramMap.get("compSeq").toString() != "") {
				userInfo.put("compSeq", paramMap.get("compSeq"));
			}
			
			if (paramMap.get("compCd") != null && paramMap.get("compCd").toString() != "") {
				userInfo.put("compCd", paramMap.get("compCd"));
				
				//compCd 우선순위 처리를 위해 compSeq 초기화
				userInfo.put("compSeq", "");				
			}			

			if (paramMap.get("loginId") != null && paramMap.get("loginId").toString() != "") {
				userInfo.put("loginId", paramMap.get("loginId"));
			}

			if (paramMap.get("empSeq") != null && paramMap.get("empSeq").toString() != "") {
				userInfo.put("empSeq", paramMap.get("empSeq"));
			}

			if (paramMap.get("erpSeq") != null && paramMap.get("erpSeq").toString() != "") {
				userInfo.put("erpSeq", paramMap.get("erpSeq"));
			}
			
			if (paramMap.get("kicpaNum") != null && paramMap.get("kicpaNum").toString() != "") {
				userInfo.put("kicpaNum", paramMap.get("kicpaNum"));
			}			

			Map<String, Object> userInfoList = new HashMap<String, Object>();

			if (paramMap.get("loginId") != null || paramMap.get("empSeq") != null || paramMap.get("erpSeq") != null || paramMap.get("kicpaNum") != null) {
				userInfoList = (Map<String, Object>) commonSql.select("Empmanage.getEmpAuthCheck", userInfo);
			}

			if (userInfoList != null && userInfoList.size() > 0) {
				/** save file */
				Iterator<Entry<String, MultipartFile>> itr = files.entrySet().iterator(); // 파일
																							// 순번
				MultipartFile file = null;
				fileKey = paramMap.get("deleteYN").toString() + java.util.UUID.randomUUID().toString();

				while (itr.hasNext()) {
					Entry<String, MultipartFile> entry = itr.next();
					file = entry.getValue();
					String orginFileName = null;
					try {
						
						orginFileName = URLDecoder.decode(file.getOriginalFilename(), "UTF-8");
						
					} catch (Exception e) {
						orginFileName = file.getOriginalFilename();
					}
								

					// 파일명
					String tempFolderTop = userInfoList.get("absolPath").toString() + File.separator + "uploadTemp"	+ File.separator;
					
					String saveFilePath = tempFolderTop + fileKey + File.separator + orginFileName;
					EgovFileUploadUtil.saveFile(file.getInputStream(), new File(saveFilePath));
					
					
					int index = file.getOriginalFilename().lastIndexOf(".");
					
					String fileExt = file.getOriginalFilename().substring(index + 1);
					String newName = file.getOriginalFilename().substring(0, index);				
					String savePath = tempFolderTop + fileKey;
					
					//DRM 체크
					drmService.drmConvert("U", paramMap.get("groupSeq") != null ? paramMap.get("groupSeq").toString() : "", paramMap.get("pathSeq") != null ? paramMap.get("pathSeq").toString() : "0", savePath, newName, fileExt);
					
					//임시폴더 정리
					Date dt = new Date();
					SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");			
					int today = Integer.parseInt(sdf.format(dt)); 
					
					if(toDate < today) {
						toDate = today;
						livePathSeq = "|300|400|1000|1300|";
					}
					
					if(!livePathSeq.contains("|0|")) {
						
						livePathSeq += "0|";
						
						String cmd = "find " + tempFolderTop + " -mindepth 1 -type d -empty -mtime +1 -delete";
						
						//System.out.println("outProcessUpload.executeCommand Start : " + cmd);
						
						try {
							ShellExecHelper.executeCommand(cmd);
							//System.out.println("outProcessUpload.executeCommand Result : " + );
						}catch(Exception ex) {
							CommonUtil.printStatckTrace(ex);//오류메시지를 통한 정보노출
							//System.out.println("outProcessUpload.executeCommand Error : " + ex.getMessage());
						}
					}					
					
	
				}

				resultCode = "1";
				resultMessage = BizboxAMessage.getMessage("TX000011981","성공");

			} else {
				// 인증실패
				resultMessage = BizboxAMessage.getMessage("TX800000036","사용자인증실패");
			}
		} else {
			resultMessage = BizboxAMessage.getMessage("TX800000037","첨부파일 없음");
		}

		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("resultCode", resultCode);
		resultMap.put("resultMessage", resultMessage);
		resultMap.put("fileKey", fileKey);

		mv.addAllObjects(resultMap);
		mv.setViewName("jsonView");
		return mv;
	}
	
	@RequestMapping("/outProcessEncUpload.do")
	public ModelAndView outProcessEncUpload(MultipartHttpServletRequest multiRequest,
			@RequestParam Map<String, Object> paramMap) throws Exception {
		ModelAndView mv = new ModelAndView();

		String resultCode = "-1";
		String resultMessage = "";
		String fileKey = "";

		/** 파일 체크 */
		Map<String, MultipartFile> files = multiRequest.getFileMap();
		if (!files.isEmpty()) {

			if(paramMap.get("groupSeq") == null || paramMap.get("groupSeq").equals("")) {
		    	String serverName = multiRequest.getServerName();
		    	Map<String, Object> jedisMp = CloudConnetInfo.getParamMapByDomain(serverName);
		    	
		    	if(jedisMp != null && jedisMp.get("groupSeq") != null) {
		    		paramMap.put("groupSeq", jedisMp.get("groupSeq"));
		    	}
			}						

			// 인증체크
			Map<String, Object> userInfo = new HashMap<String, Object>();
			userInfo.put("osType", NeosConstants.SERVER_OS);
			
			if (paramMap.get("groupSeq") != null && paramMap.get("groupSeq").toString() != "") {
				userInfo.put("groupSeq", paramMap.get("groupSeq"));
			}			

			if (paramMap.get("compSeq") != null && paramMap.get("compSeq").toString() != "") {
				userInfo.put("compSeq", paramMap.get("compSeq"));
			}
			
			if (paramMap.get("compCd") != null && paramMap.get("compCd").toString() != "") {
				userInfo.put("compCd", paramMap.get("compCd"));
				
				//compCd 우선순위 처리를 위해 compSeq 초기화
				userInfo.put("compSeq", "");
			}				

			if (paramMap.get("loginId") != null && paramMap.get("loginId").toString() != "") {
				userInfo.put("loginId", AESCipher.AESEX_ExpirDecode(paramMap.get("aesType") == null ? "" : paramMap.get("aesType").toString(), paramMap.get("loginId").toString(), paramMap.get("aesKey") == null || paramMap.get("aesKey").equals("") ? "1023497555960596" : paramMap.get("aesKey").toString(), 60));
			}

			if (paramMap.get("empSeq") != null && paramMap.get("empSeq").toString() != "") {
				userInfo.put("empSeq", AESCipher.AESEX_ExpirDecode(paramMap.get("aesType") == null ? "" : paramMap.get("aesType").toString(), paramMap.get("empSeq").toString(), paramMap.get("aesKey") == null || paramMap.get("aesKey").equals("") ? "1023497555960596" : paramMap.get("aesKey").toString(), 60));
			}

			if (paramMap.get("erpSeq") != null && paramMap.get("erpSeq").toString() != "") {
				userInfo.put("erpSeq", AESCipher.AESEX_ExpirDecode(paramMap.get("aesType") == null ? "" : paramMap.get("aesType").toString(), paramMap.get("erpSeq").toString(), paramMap.get("aesKey") == null || paramMap.get("aesKey").equals("") ? "1023497555960596" : paramMap.get("aesKey").toString(), 60));
			}
			
			if (paramMap.get("kicpaNum") != null && paramMap.get("kicpaNum").toString() != "") {
				userInfo.put("kicpaNum", AESCipher.AESEX_ExpirDecode(paramMap.get("aesType") == null ? "" : paramMap.get("aesType").toString(), paramMap.get("kicpaNum").toString(), paramMap.get("aesKey") == null || paramMap.get("aesKey").equals("") ? "1023497555960596" : paramMap.get("aesKey").toString(), 60));
			}			

			Map<String, Object> userInfoList = new HashMap<String, Object>();

			if (paramMap.get("loginId") != null || paramMap.get("empSeq") != null || paramMap.get("erpSeq") != null || paramMap.get("kicpaNum") != null) {
				userInfoList = (Map<String, Object>) commonSql.select("Empmanage.getEmpAuthCheck", userInfo);
			}

			if (userInfoList != null && userInfoList.size() > 0) {
				/** save file */
				Iterator<Entry<String, MultipartFile>> itr = files.entrySet().iterator(); // 파일
																							// 순번
				MultipartFile file = null;
				fileKey = paramMap.get("deleteYN").toString() + java.util.UUID.randomUUID().toString();

				while (itr.hasNext()) {
					Entry<String, MultipartFile> entry = itr.next();
					file = entry.getValue();
					String orginFileName = null;
					try {
						orginFileName = URLDecoder.decode(file.getOriginalFilename(), "UTF-8"); // 저장할
						
					} catch (Exception e) {
						orginFileName = file.getOriginalFilename();
					}
							
					// 파일명
					String tempFolderTop = userInfoList.get("absolPath").toString() + File.separator + "uploadTemp" + File.separator;
					String saveFilePath = tempFolderTop + fileKey + File.separator + orginFileName;
					EgovFileUploadUtil.saveFile(file.getInputStream(), new File(saveFilePath));
					
					int index = file.getOriginalFilename().lastIndexOf(".");
					
					String fileExt = file.getOriginalFilename().substring(index + 1);
					String newName = file.getOriginalFilename().substring(0, index);				
					String savePath = tempFolderTop + fileKey;
					
					//DRM 체크
					drmService.drmConvert("U", paramMap.get("groupSeq") != null ? paramMap.get("groupSeq").toString() : "", paramMap.get("pathSeq") != null ? paramMap.get("pathSeq").toString() : "0", savePath, newName, fileExt);					
	
					//임시폴더 정리
					Date dt = new Date();
					SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");			
					int today = Integer.parseInt(sdf.format(dt)); 
					
					if(toDate < today) {
						toDate = today;
						livePathSeq = "|300|400|1000|1300|";
					}
					
					if(!livePathSeq.contains("|0|")) {
						
						livePathSeq += "0|";
						
						String cmd = "find " + tempFolderTop + " -mindepth 1 -type d -empty -mtime +1 -delete";
						
						try {
							ShellExecHelper.executeCommand(cmd);
						}catch(Exception ex) {
							CommonUtil.printStatckTrace(ex);//오류메시지를 통한 정보노출
							//System.out.println("outProcessUpload.executeCommand Error : " + ex.getMessage());
						}
					}					
					
				}

				resultCode = "1";
				resultMessage = BizboxAMessage.getMessage("TX000011981","성공");

			} else {
				// 인증실패
				resultMessage = BizboxAMessage.getMessage("TX800000036","사용자인증실패");
			}
		} else {
			resultMessage = BizboxAMessage.getMessage("TX800000037","첨부파일 없음");
		}

		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("resultCode", resultCode);
		resultMap.put("resultMessage", resultMessage);
		resultMap.put("fileKey", fileKey);

		mv.addAllObjects(resultMap);
		mv.setViewName("jsonView");
		return mv;
	}	

	@RequestMapping("/ajaxFileDownLoadProc.do")
	public void ajaxFileDownLoadProc(@RequestParam Map<String, Object> paramMap, HttpServletResponse response) {

		String fileId = paramMap.get("fileId").toString();

		if (fileId == null || fileId.equals("")) {
			return;
		}

		/** 첨부파일 상세정보 조회 */
		Map<String, Object> fileMap = attachFileService.getAttachFileDetail(paramMap);

		if (fileMap == null) {
			return;
		}

		String pathSeq = fileMap.get("pathSeq") + "";

		String groupSeq = paramMap.get("groupSeq") + "";
		if (EgovStringUtil.isEmpty(groupSeq)) {
			return;
		}

		/** 절대경로 조회 */
		paramMap.put("pathSeq", pathSeq);
		paramMap.put("osType", NeosConstants.SERVER_OS);
		Map<String, Object> groupPahtInfo = groupManageService.selectGroupPath(paramMap);

		String path = groupPahtInfo.get("absolPath") + File.separator + fileMap.get("fileStreCours");
		String orignlFileName = fileMap.get("orignlFileName") + "." + fileMap.get("fileExtsn");

		File file = null;
		FileInputStream fis = null;

		String type = "";

		String fileExtsn = String.valueOf(fileMap.get("fileExtsn"));

		if (fileExtsn != null && !"".equals(fileExtsn)) {

			if ("jpg".equals(fileExtsn.toLowerCase())) {
				type = "image/jpeg";
			} else {
				type = "image/" + fileExtsn.toLowerCase();
			}
			type = "image/" + fileExtsn.toLowerCase();

		} else {
			// LOGGER.debug("Image fileType is null.");
		}

		String imgExt = "jpeg|bmp|gif|jpg|png";

		try {
			
			//DRM 체크
			String drmPath = drmService.drmConvert("D", groupSeq, pathSeq, path, fileMap.get("streFileName").toString(), fileExtsn);			
			file = new File(drmPath);
		    fis = new FileInputStream(file);

			orignlFileName = URLEncoder.encode(orignlFileName, "UTF-8");
			orignlFileName = orignlFileName.replaceAll("\\+", "%20"); // 한글 공백이
																		// + 되는
																		// 현상 해결
																		// 위해
			response.setHeader("Content-Disposition", "attachment; filename=\"" + orignlFileName + "\"");

			/** 이미지 */
			if (imgExt.indexOf(fileExtsn) > -1) {
				response.setHeader("Content-Type", type);
			}
			/** 일반 */
			else {
				response.setContentType(CommonUtil.getContentType(file));
				response.setHeader("Content-Transfer-Coding", "binary");
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
			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
			//System.out.println(e.getMessage());
		} catch (IOException e) {
			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
			//System.out.println(e.getMessage());
		} finally {
			if (fis != null) {
				try {
					fis.close();
				} catch (Exception ignore) {
					// LOGGER.debug("IGNORE: {}", ignore.getMessage());
				}
			}
		}
	}

	@SuppressWarnings("unchecked")
	@RequestMapping("cmm/systemx/getAttendTimeInfo.do")
	public ModelAndView getAttendTimeInfo(@RequestParam Map<String, Object> params, HttpServletRequest request)
			throws Exception {
		ModelAndView mv = new ModelAndView();

		LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser();
		
		if(loginVO != null) {

			params.put("empSeq", loginVO.getUniqId());
			params.put("compSeq", loginVO.getCompSeq());
			params.put("groupSeq", loginVO.getGroupSeq( ));
			
			String weekYn = params.get("weekSeq") + "";
			
			if(weekYn.equals("0") || weekYn.equals("6")) {
				weekYn = "Y";
			}
			else {
				weekYn = "N";
			}
			
			params.put("weekYn", weekYn);
			
			//근무조 출퇴근 설정확인
			boolean isWorkTeamTime = false;
			Map<String, Object> mp = (Map<String, Object>) commonSql.select("EmpManage.selectEmpWorkTeamTime", params);		
			
			if(mp != null && mp.get("workTeamSqno") != null){
				
				params.put("workTeamSqno", mp.get("workTeamSqno"));
				
				Map<String, Object> map = (Map<String, Object>) commonSql.select("EmpManage.selectEmpWorkTeamTimeInfo", params);
				if(map != null){
					isWorkTeamTime = true;
					mv.addObject("attendTimeInfo", map);
				}
			}
			
			if(!isWorkTeamTime){
				Map<String, Object> map = (Map<String, Object>) empManageService.getAttendTimeInfo(params);
				mv.addObject("attendTimeInfo", map);
			}
			
			// 통제 IP
			String now   = new java.text.SimpleDateFormat("HHmmss").format(new java.util.Date());
			
			mv.addObject("localIpAddr", loginVO.getIp());
			mv.addObject("ipAddr", loginVO.getIp());
			mv.addObject("now", now);			
			
		}

		mv.setViewName("jsonView");
		return mv;
	}

	@RequestMapping("/totalSearch.do")
	public ModelAndView totalSearch(@RequestParam Map<String, Object> params) throws Exception {
		
		ModelAndView mv = new ModelAndView();
		LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser();

		if (loginVO == null) {
			mv.setViewName("redirect:/uat/uia/egovLoginUsr.do");
			return mv;
		}
		
		params.put("compSeq", loginVO.getCompSeq());
		params.put("groupSeq", loginVO.getGroupSeq());
		
		@SuppressWarnings("unchecked")
		Map<String, Object> portalInfo = (Map<String, Object>) commonSql.select("CompManage.getPortalId", params);
		
		if(portalInfo != null){
			mv.addObject("portalId", portalInfo.get("portalId"));
			mv.addObject("portalDiv", portalInfo.get("portalDiv"));
			
			if(portalInfo.get("portalDiv").equals("cloud")){
				mv.addObject("topMenuList", mainService.getTopMenuList(loginVO));
			}		
		}		
		// "\" 검색 시 누락되는 오류 수정
		if(params.get("tsearchKeyword").toString().indexOf("\\") > -1){
			String key = params.get("tsearchKeyword").toString();
			key = key.replace("\\","\\\\\\\\");
			params.put("tsearchKeyword" , key);
    	}
		
		mv.addObject("tsearchKeyword", params.get("tsearchKeyword"));
		mv.addObject("topType", "tsearch");
		mv.setViewName("/main/totalsearch/totalSearch");

		return mv;
	}

	@RequestMapping("/totalSearchParam.do")
	public ModelAndView totalSearchParam(@RequestParam Map<String, Object> params) throws Exception {

		Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();

		ModelAndView mv = new ModelAndView();
		if (!isAuthenticated) {

			mv.setViewName("redirect:/uat/uia/egovLoginUsr.do");

			return mv;

		}

		mv.addObject("params", params);
		mv.setViewName("/main/totalsearch/totalSearchParam");

		return mv;
	}

	public String getNowTime(){
		
		Calendar now = Calendar.getInstance();
		int hour = now.get(Calendar.HOUR);
		int min = now.get(Calendar.MINUTE);
		int sec = now.get(Calendar.SECOND);
		int milsec = now.get(Calendar.MILLISECOND);
		
		return hour+BizboxAMessage.getMessage("TX000001228","시")+" "+min+BizboxAMessage.getMessage("TX000001229","분")+" "+sec+BizboxAMessage.getMessage("TX000013861","초")+" "+milsec+"milSec"; 
	}
	
	
	@SuppressWarnings("unchecked")
	@IncludedInfo(name = "통합검색", order = 17, gid = 0)
	@RequestMapping("/getTotalSearchContent.do")
	public ModelAndView getTotalSearchContent(@RequestParam Map<String, String> params) throws Exception {

		LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser();
		Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();
		ModelAndView mv = new ModelAndView();
		
		if (!isAuthenticated) {

			mv.setViewName("redirect:/uat/uia/egovLoginUsr.do");

			return mv;

		}
		try {
			PagingReturnObj boardMap;
			PagingReturnObj projectMap;
			PagingReturnObj scheduleMap;
			PagingReturnObj noteMap;
			PagingReturnObj reportMap;
			PagingReturnObj eadocMap;
			PagingReturnObj eapprovalMap;
			PagingReturnObj edmsMap;
			PagingReturnObj fileMap;
			PagingReturnObj hrMap;
			PagingReturnObj mailMap = new PagingReturnObj();
			PagingReturnObj onefficeMap;
			
			int totalCnt = 0;
			params.put("pageIndex", (params.get("pageIndex") != null ? params.get("pageIndex") : "1"));
			params.put("eaType", (loginVO.getEaType() != null ? loginVO.getEaType() : "eap"));
			params.put("empSeq", loginVO.getUniqId());
			params.put("compSeq", loginVO.getCompSeq());
			params.put("groupSeq", loginVO.getGroupSeq());
			params.put("langCode", loginVO.getLangCode()); 
			
			//빈 Array iOS null 방지
			List<Map<String, Object>> spaceList = new ArrayList<Map<String,Object>>(); // 리스트로 담기
			
			String tsearchKeyword = params.get("tsearchKeyword").trim(); // 검색어
			String tsearchKeywordTmp = params.get("tsearchKeyword").trim(); // 검색어
        	        	
        	if(tsearchKeyword.indexOf("^^^") > -1){
	        	params.put("tsearchKeyword",tsearchKeyword.substring(0,tsearchKeyword.length()-4));
	        	tsearchKeywordTmp = tsearchKeywordTmp.substring(0,tsearchKeywordTmp.length()-4);
	        	params.put("boardType",tsearchKeyword.substring(tsearchKeyword.length()-1,tsearchKeyword.length()));
        	}
			
			//사용자별 대메뉴 권한 가져오기
			List<String> menuAuthList = mainService.getTotalSearchMenuAuth(params);
			Map<String,Object> menuAuthMap = new HashMap<String,Object>();
			
			menuAuthMap.put("mailYn","N");
			menuAuthMap.put("scheduleYn","N");
			menuAuthMap.put("noteYn","N");
			menuAuthMap.put("reportYn","N");
			menuAuthMap.put("projectYn","N");
			menuAuthMap.put("boardYn","N");
			menuAuthMap.put("edmsYn","N");
			menuAuthMap.put("eadocYn","N");
			menuAuthMap.put("onefficeYn","N");
			
			for(int i = 0; i < menuAuthList.size() ; i++){
				if("200000000".equals(menuAuthList.get(i))){
					menuAuthMap.put("mailYn", "Y");
				}else if("300000000".equals(menuAuthList.get(i))){
					menuAuthMap.put("scheduleYn", "Y");
				}else if("303010000".equals(menuAuthList.get(i))){
					menuAuthMap.put("noteYn", "Y");
				}else if("304000000".equals(menuAuthList.get(i))){
					menuAuthMap.put("reportYn", "Y");
				}else if("400000000".equals(menuAuthList.get(i))){
					menuAuthMap.put("projectYn", "Y");
				}else if("500000000".equals(menuAuthList.get(i))){
					menuAuthMap.put("boardYn", "Y");
				}else if("600000000".equals(menuAuthList.get(i))){
					menuAuthMap.put("edmsYn", "Y");
				}else if("2000000000".equals(menuAuthList.get(i))){
					menuAuthMap.put("eadocYn", "Y");
				}else if("100000000".equals(menuAuthList.get(i))){
					menuAuthMap.put("eadocYn", "Y");
				}else if("1".equals(menuAuthList.get(i))){
					menuAuthMap.put("onefficeYn", "Y");
				}
			}

			String mailUrl = mainService.getTotalSearchMailDomain(params);

			//메일 검색 시작(메뉴 권한이 있을 경우에만)
			if("Y".equals(menuAuthMap.get("mailYn"))){
					
	        	int pageIndex = 0;
	        	if(params.get("pageIndex") == null || "".equals(params.get("pageIndex"))){
		        	pageIndex = 1;
		        }else{
		        	pageIndex = Integer.parseInt(params.get("pageIndex"));
		        }
	        	
	        	int pageSize = 0;
		        if("1".equals(params.get("boardType"))){
		        	pageSize = 3;
		        }else if(!"1".equals(params.get("boardType")) && !"0".equals(params.get("boardType"))){ // 전체나 메일이 아닐경우
		        	pageIndex = 1;
		        	pageSize = 0;
		        }else{
		        	pageSize = 10;
		        }
	        	
		        String tTailTmp = "";
				char[] tTail = params.get("tsearchKeyword").toCharArray();
				for(int i = 0; i < tTail.length; i++){
					if((tTail[i] >= 65) && (tTail[i] <= 90)){
						tTail[i] += 32;
					}
					tTailTmp += tTail[i];
				}
				
				tTailTmp = URLEncoder.encode(tTailTmp,"UTF-8");
				String sUrl = mailUrl + "getsearchMailList.do?id="+loginVO.getEmail()+"&domain="+loginVO.getEmailDomain()+"&mboxSeq=0&page="+pageIndex+"&pageSize="+pageSize+"&search="+tTailTmp+"&type=all&integrate=true";
	            
				JSONObject obj = new JSONObject();
				obj.put("id", loginVO.getEmail());
				obj.put("domain", loginVO.getEmailDomain());
				obj.put("mboxSeq", "0");
				obj.put("page", pageIndex);
				obj.put("pageSize", pageSize);
				obj.put("search", tTailTmp);
				obj.put("type", "all");
				obj.put("integrate", "true");
				
				//메일 검색 진행
				JSONObject mailList = getPostJSON(sUrl, obj.toString());
				
				if(mailList != null) {
	
					int mailCode = (int) mailList.get("code");
					// mailCode : 성공 = 0, 오류 = -1, 세션오류 = -2
					if(mailCode == 0){
						JSONArray mailInfo = mailList.getJSONArray("Records"); // 메일 본문정보
						int mainCount = (int)mailList.get("TotalRecordCount"); // 메일 카운트 가져오기
						
						Map<String, Object> items = null; // JSONArray에서 Map으로
						List<Map<String, Object>> mailInsertParam = new ArrayList<Map<String,Object>>(); // 리스트로 담기
						
						for(int j=0; j<mailInfo.size(); j++) {
							items = new HashMap<String, Object>();
							JSONObject info = mailInfo.getJSONObject(j);
							
							JSONObject highlightInfo = (JSONObject)info.get("highlight");
							
							items.put("mailBody", highlightInfo.get("mail_body").toString());
							items.put("subject", info.get("subject").toString());
							items.put("boxName", info.get("boxName").toString());
							items.put("muid", info.get("muid").toString());
							items.put("size", info.get("size").toString());
							items.put("mailTo", info.get("mail_to").toString());
							items.put("mailFrom", info.get("mail_from").toString());
							items.put("rfc822date", info.get("rfc822date").toString());
							items.put("emailAddr", loginVO.getEmail()+"@"+loginVO.getEmailDomain());
							mailInsertParam.add(items);
						}
						
						mailMap.setResultgrid(mailInsertParam);
						mailMap.setTotalcount(mainCount);
						
						mv.addObject("mailList", mailMap.getResultgrid());
						mv.addObject("mailCnt", mailMap.getTotalcount());
						totalCnt += mailMap.getTotalcount();
						mv.addObject("mailUrl",mailUrl);
						mv.addObject("searchCnt", mailMap.getTotalcount());
					}
				}
			}
			
			int projectCnt = 0;
			int scheduleCnt = 0;
			int noteCnt = 0;
			int reportCnt = 0;
			int eadocCnt = 0;
			int eapprovalCnt = 0;
			int edmsCnt = 0;
			int boardCnt = 0;
			int onefficeCnt = 0;
			
			if("Y".equals(menuAuthMap.get("projectYn"))){
				// 업무관리(project-1:업무관리프로젝트, project-2:업묵솬리_업무, project-3:할일)
				projectMap = mainService.tsearchList(params, "2");
				mv.addObject("projectList", projectMap.getResultgrid());
				mv.addObject("projectCnt", projectMap.getTotalcount());
				totalCnt += projectMap.getTotalcount();
				projectCnt += projectMap.getTotalcount();
			}
			if("Y".equals(menuAuthMap.get("scheduleYn"))){
				// 일정(schedule-1:일정등록, schedule-2:자원예약)
				scheduleMap = mainService.tsearchList(params, "3");
				mv.addObject("scheduleList", scheduleMap.getResultgrid());
				mv.addObject("scheduleCnt", scheduleMap.getTotalcount());
				totalCnt += scheduleMap.getTotalcount();
				scheduleCnt += scheduleMap.getTotalcount();
			}
			if("Y".equals(menuAuthMap.get("noteYn"))){
				// 노트(note:노트)
				noteMap = mainService.tsearchList(params, "4");
				mv.addObject("noteList", noteMap.getResultgrid());
				mv.addObject("noteCnt", noteMap.getTotalcount());
				totalCnt += noteMap.getTotalcount();
				noteCnt += noteMap.getTotalcount();
			}
			if("Y".equals(menuAuthMap.get("reportYn"))){
				// 업무보고(report-1:일일, report-2:수시)
				reportMap = mainService.tsearchList(params, "5");
				mv.addObject("reportList", reportMap.getResultgrid());
				mv.addObject("reportCnt", reportMap.getTotalcount());
				totalCnt += reportMap.getTotalcount();
				reportCnt += reportMap.getTotalcount();
			}
			if("Y".equals(menuAuthMap.get("eadocYn"))){
				// 전자결재(영리)(eadoc-1:결재, eadoc-2:공문)
				eadocMap = mainService.tsearchList(params, "6");
				mv.addObject("eadocList", eadocMap.getResultgrid());
				mv.addObject("eadocCnt", eadocMap.getTotalcount());
				totalCnt += eadocMap.getTotalcount();
				eadocCnt += eadocMap.getTotalcount();
			}
			if("Y".equals(menuAuthMap.get("eadocYn"))){
				// 전자결재(비영리)(eapproval-1:결재, eapproval-2:유통)
				eapprovalMap = mainService.tsearchList(params, "7");
				mv.addObject("eapprovalList", eapprovalMap.getResultgrid());
				mv.addObject("eapprovalCnt", eapprovalMap.getTotalcount());
				totalCnt += eapprovalMap.getTotalcount();
				eapprovalCnt += eapprovalMap.getTotalcount();
			}
			if("Y".equals(menuAuthMap.get("edmsYn"))){
				// 문서(edms-1:비영리전자결재, edms-2:영리전자결재, edms-3:비영리전자결재, edms-4:업무)
				edmsMap = mainService.tsearchList(params, "8");
				mv.addObject("edmsList", edmsMap.getResultgrid());
				mv.addObject("edmsCnt", edmsMap.getTotalcount());
				totalCnt += edmsMap.getTotalcount();
				edmsCnt += edmsMap.getTotalcount();
			}
			if("Y".equals(menuAuthMap.get("boardYn"))){
				// 게시판(board-1:게시판일반, board-2:게시판설문, board-3:게시판프로젝트)
				boardMap = mainService.tsearchList(params, "9");
				mv.addObject("boardList", boardMap.getResultgrid());
				mv.addObject("boardCnt", boardMap.getTotalcount());
				totalCnt += boardMap.getTotalcount();
				boardCnt += boardMap.getTotalcount();
			}
			// 원피스 신규 추가(2019.03.04~)
			if("Y".equals(menuAuthMap.get("onefficeYn"))){
				onefficeMap = mainService.tsearchList(params, "12");
				mv.addObject("onefficeList", onefficeMap.getResultgrid());
				mv.addObject("onefficeCnt", onefficeMap.getTotalcount());
				totalCnt += onefficeMap.getTotalcount();
				onefficeCnt += onefficeMap.getTotalcount();
			}
			
			// 첨부파일(attach_file:첨부파일))
			fileMap = mainService.tsearchList(params, "10");
			mv.addObject("fileList", fileMap.getResultgrid());
			mv.addObject("fileCnt", fileMap.getTotalcount());
			totalCnt += fileMap.getTotalcount();
			
			// 인물검색 메인화면
			hrMap = mainService.tsearchList(params, "11");
			mv.addObject("hrList", hrMap.getResultgrid());
			mv.addObject("hrCnt", hrMap.getTotalcount());
			totalCnt += hrMap.getTotalcount();
			params.put("tsearchKeyword",tsearchKeywordTmp);
			
			mv.addObject("params", params);
			if(mailMap.getResultgrid() == null){
				mv.addObject("mailList", spaceList);
				mv.addObject("mailCnt", 0);
				mv.addObject("mailUrl",mailUrl);
			}
			mv.addObject("totalCnt", totalCnt);
			
			String bordType = "1";
			if(params.get("boardType") != null){
				bordType = params.get("boardType");
			}
			if("1".equals(bordType)){
				mv.addObject("searchCnt", totalCnt);
			}else if("2".equals(bordType)){
				mv.addObject("searchCnt", projectCnt);
			}else if("3".equals(bordType)){
				mv.addObject("searchCnt", scheduleCnt);
			}else if("4".equals(bordType)){
				mv.addObject("searchCnt", noteCnt);
			}else if("5".equals(bordType)){
				mv.addObject("searchCnt", reportCnt);
			}else if("6".equals(bordType)){
				mv.addObject("searchCnt", eadocCnt);
			}else if("7".equals(bordType)){
				mv.addObject("searchCnt", eapprovalCnt);
			}else if("8".equals(bordType)){
				mv.addObject("searchCnt", edmsCnt);
			}else if("9".equals(bordType)){
				mv.addObject("searchCnt", boardCnt);
			}else if("10".equals(bordType)){
				mv.addObject("searchCnt", fileMap.getTotalcount());
			}else if("0".equals(bordType)){
				mv.addObject("searchCnt", mailMap.getTotalcount());
			}else if("11".equals(bordType)){
				mv.addObject("searchCnt", hrMap.getTotalcount());
			}else if("12".equals(bordType)){
				mv.addObject("searchCnt", onefficeCnt);
			}
			//첨부파일 보기옵션 모듈별 가져오기.
			Map<String, Object> mp = new HashMap<String, Object>();
			mp.put("optionId", "cm1700");
			String cmmOptionValue = (String) commonSql.select("CmmnCodeDetailManageDAO.getOptionSetValue", mp);
			mv.addObject("attViewOptionValue", cmmOptionValue);
			if(cmmOptionValue.equals("1")){
				//downloadType : -1 -> 미선택
				//downloadType : 0 -> 문서뷰어+파일다운
				//downloadType : 1 -> 파일다운
				//downloadType : 2 -> 문서뷰어
				
				Map<String, Object> empMap = new HashMap<String, Object>();
				List<Map<String, Object>> attViewOptionList = (List<Map<String, Object>>) commonSql.list("CmmnCodeDetailManageDAO.getOptionSetValueList", empMap);
				
				for(Map<String, Object> map : attViewOptionList){
					String downloadType = "";
					//미선택
					if(map.get("val").toString().equals("999")){
						downloadType = "-1";
					}
					else{
						String optionValueArr[] = map.get("val").toString().split("\\|");
						if(optionValueArr.length == 2) {
							downloadType = "0";
						}
						else{
							
							if(optionValueArr[0].equals("0")) {
								downloadType = "2";
							}
							else {
								downloadType = "1";
							}
						}						 
					}
					mv.addObject(map.get("optionId").toString(), downloadType);
				 }
			}
			mv.addObject("menuAuthMap",menuAuthMap);
			
			if(CloudConnetInfo.getBuildType().equals("cloud")){
				mv.addObject("profilePath", "/upload/" + loginVO.getGroupSeq() + "/img/profile/" + loginVO.getGroupSeq());
			}else{
				mv.addObject("profilePath", "/upload/img/profile/" + loginVO.getGroupSeq());
			}			
			
			mv.setViewName("/main/totalsearch/totalSearchContent");

		} catch (Exception e) {
			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
		}
		return mv;
	}
	
	@SuppressWarnings("unchecked")
	@IncludedInfo(name = "통합검색(인물)", order = 18, gid = 0)
	@RequestMapping("/getTotalSearchContentHr.do")
	public ModelAndView getTotalSearchContentHr(@RequestParam Map<String, String> params) throws Exception {

		//System.out.println("getTotalSearchContentHr params : "+params);
		
		LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser();
		Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();
		ModelAndView mv = new ModelAndView();
		
		if (!isAuthenticated) {

			mv.setViewName("redirect:/uat/uia/egovLoginUsr.do");

			return mv;

		}
		try {
			PagingReturnObj boardMap;
			PagingReturnObj projectMap;
			PagingReturnObj scheduleMap;
			PagingReturnObj noteMap;
			PagingReturnObj reportMap;
			PagingReturnObj eadocMap;
			PagingReturnObj eapprovalMap;
			PagingReturnObj edmsMap;
			PagingReturnObj fileMap;
			PagingReturnObj hrMap;
			
			PagingReturnObj boardHrMap;
			PagingReturnObj projectHrMap;
			PagingReturnObj scheduleHrMap;
			PagingReturnObj noteHrMap;
			PagingReturnObj reportHrMap;
			PagingReturnObj eadocHrMap;
			PagingReturnObj eapprovalHrMap;
			PagingReturnObj edmsHrMap;
			PagingReturnObj fileHrMap;
			
			PagingReturnObj mailMap = new PagingReturnObj();
			int totalCnt = 0;
			params.put("pageIndex", (params.get("pageIndex") != null ? params.get("pageIndex") : "1"));
			params.put("eaType", (loginVO.getEaType() != null ? loginVO.getEaType() : "eap"));
			params.put("empSeq", loginVO.getUniqId());
			params.put("compSeq", loginVO.getCompSeq());
			params.put("groupSeq", loginVO.getGroupSeq());
			//System.out.println("totalsearch : " + params);
			
			
		/*	//System.out.println("sUrl3 Start");
			String sUrl3 = "http://bizboxa.duzonnext.com/schedule/WebMtSchedule/InsertMtSchedule";

			JSONObject obj2 = new JSONObject();	
			obj2.put("schmSeq", "0");
			obj2.put("schSeq", "0");
			obj2.put("schTitle", "일정등록테스트");
			obj2.put("startDate", "20170714090000");
			obj2.put("endDate", "20170714180000");
			obj2.put("alldayYn", "N");
			obj2.put("gbnCode", "M");
			obj2.put("gbnSeq", "1200");
			obj2.put("schGbnCode", "10");
			obj2.put("repeatType", "10");
			obj2.put("repeatEndDay", "");
			obj2.put("contents", "");
			obj2.put("rangeCode", "N");
			obj2.put("schPlace", "");
			obj2.put("placeFileId", "");
			obj2.put("fileId", "");
			obj2.put("langCode", "kr");
			obj2.put("mcalSeq", "10000");
			JSONObject mailList2 = getPostJSON(sUrl3, obj2.toString());
			//System.out.println("sUrl3 sUrl3 : "+sUrl3);
			//System.out.println("sUrl3 mailList2 : "+mailList2);*/
			
			
			
			//빈 Array iOS null 방지
			List<Map<String, Object>> spaceList = new ArrayList<Map<String,Object>>(); // 리스트로 담기
			
			String tsearchKeyword = params.get("tsearchKeyword").trim(); // 검색어
			String tsearchKeywordTmp = params.get("tsearchKeyword").trim(); // 검색어
        	        	
        	if(tsearchKeyword.indexOf("^^^") > -1){
	        	params.put("tsearchKeyword",tsearchKeyword.substring(0,tsearchKeyword.length()-4));
	        	tsearchKeywordTmp = tsearchKeywordTmp.substring(0,tsearchKeywordTmp.length()-4);
	        	params.put("boardType",tsearchKeyword.substring(tsearchKeyword.length()-1,tsearchKeyword.length()));
        	}
			
			//사용자별 대메뉴 권한 가져오기
			List<String> menuAuthList = mainService.getTotalSearchMenuAuth(params);
			Map<String,Object> menuAuthMap = new HashMap<String,Object>();
			
			menuAuthMap.put("mailYn","N");
			menuAuthMap.put("scheduleYn","N");
			menuAuthMap.put("noteYn","N");
			menuAuthMap.put("reportYn","N");
			menuAuthMap.put("projectYn","N");
			menuAuthMap.put("boardYn","N");
			menuAuthMap.put("edmsYn","N");
			menuAuthMap.put("eadocYn","N");
			
			for(int i = 0; i < menuAuthList.size() ; i++){
				//System.out.println("menuAuthMap ["+i+"]"+menuAuthList.get(i));
				if("200000000".equals(menuAuthList.get(i))){
					menuAuthMap.put("mailYn", "Y");
				}else if("300000000".equals(menuAuthList.get(i))){
					menuAuthMap.put("scheduleYn", "Y");
				}else if("303010000".equals(menuAuthList.get(i))){
					menuAuthMap.put("noteYn", "Y");
				}else if("304000000".equals(menuAuthList.get(i))){
					menuAuthMap.put("reportYn", "Y");
				}else if("400000000".equals(menuAuthList.get(i))){
					menuAuthMap.put("projectYn", "Y");
				}else if("500000000".equals(menuAuthList.get(i))){
					menuAuthMap.put("boardYn", "Y");
				}else if("600000000".equals(menuAuthList.get(i))){
					menuAuthMap.put("edmsYn", "Y");
				}else if("2000000000".equals(menuAuthList.get(i))){
					menuAuthMap.put("eadocYn", "Y");
				}
			}
			
			//메일(200000000)
			//일정(300000000)
			//노트(303010000)
			//업무보고(304000000)
			//업무관리(400000000)
			//게시판(500000000)
			//문서(600000000)
			//전자결재(2000000000)
			
			String mailUrl = mainService.getTotalSearchMailDomain(params);
			//JSONObject obj = new JSONObject();
			
			//메일 검색 시작(메뉴 권한이 있을 경우에만)
			if("Y".equals(menuAuthMap.get("mailYn"))){
				
			// 메일 도메인 검색
			
        	int pageIndex = 0;
        	if(params.get("pageIndex") == null || "".equals(params.get("pageIndex"))){
	        	pageIndex = 1;
	        }else{
	        	pageIndex = Integer.parseInt(params.get("pageIndex"));
	        }
        	
        	int pageSize = 0;
	        if("1".equals(params.get("boardType"))){
	        	pageSize = 3;
	        }else if(!"1".equals(params.get("boardType")) && !"0".equals(params.get("boardType"))){ // 전체나 메일이 아닐경우
	        	pageIndex = 1;
	        	pageSize = 0;
	        }else{
	        	pageSize = 10;
	        }
        	
	        String tTailTmp = "";
			char[] tTail = params.get("tsearchKeyword").toCharArray();
			for(int i = 0; i < tTail.length; i++){
				if((tTail[i] >= 65) && (tTail[i] <= 90)){
					tTail[i] += 32;
				}
				tTailTmp += tTail[i];
			}
			
			tTailTmp = URLEncoder.encode(tTailTmp,"UTF-8");
		
			String sUrl = mailUrl + "getsearchMailList.do?id="+loginVO.getEmail()+"&domain="+loginVO.getEmailDomain()+"&mboxSeq=0&page="+pageIndex+"&pageSize="+pageSize+"&search="+tTailTmp+"&type=all&integrate=true";
            
			JSONObject obj = new JSONObject();	
			obj.put("id", loginVO.getEmail());
			obj.put("domain", loginVO.getEmailDomain());
			obj.put("mboxSeq", "0");
			obj.put("page", pageIndex);
			obj.put("pageSize", pageSize);
			obj.put("search", tTailTmp);
			obj.put("type", "all");
			obj.put("integrate", "true");
			
			//메일 검색 진행
			JSONObject mailList = getPostJSON(sUrl, obj.toString());
			//System.out.println("sUrl2 : "+sUrl);
			
			String mailMsg = (String) mailList.get("msg");
			int mailCode = (int) mailList.get("code");
			if(mailList != null) {
				// mailCode : 성공 = 0, 오류 = -1, 세션오류 = -2
				if(mailMsg != null && mailCode == 0){
				//System.out.println("totalsearchLogTime mail msg : "+mailMsg);
					//System.out.println("mailList : "+mailList);
					/*String mainInfoTmp = mailList.get("Records").toString();
					mainInfoTmp = mainInfoTmp.replace("[", "");
					mainInfoTmp = mainInfoTmp.replace("]", "");
					//System.out.println("mainInfoTmp : "+mainInfoTmp);
					JSONObject mainInfo = JSONObject.fromObject(JSONSerializer.toJSON(mainInfoTmp));
					*/
					JSONArray mailInfo = mailList.getJSONArray("Records"); // 메일 본문정보
					int mainCount = (int)mailList.get("TotalRecordCount"); // 메일 카운트 가져오기
					
					Map<String, Object> items = null; // JSONArray에서 Map으로
					List<Map<String, Object>> mailInsertParam = new ArrayList<Map<String,Object>>(); // 리스트로 담기
					
					for(int j=0; j<mailInfo.size(); j++) {
						items = new HashMap<String, Object>();
						JSONObject info = mailInfo.getJSONObject(j);
						
						JSONObject highlightInfo = (JSONObject)info.get("highlight");
						//System.out.println("highlightInfo : "+highlightInfo);
						
						items.put("mailBody", highlightInfo.get("mail_body").toString());
						items.put("subject", info.get("subject").toString());
						items.put("boxName", info.get("boxName").toString());
						items.put("muid", info.get("muid").toString());
						items.put("size", info.get("size").toString());
						items.put("mailTo", info.get("mail_to").toString());
						items.put("mailFrom", info.get("mail_from").toString());
						items.put("rfc822date", info.get("rfc822date").toString());
						items.put("emailAddr", loginVO.getId()+"@"+loginVO.getEmailDomain());
						mailInsertParam.add(items);
					}
					
					mailMap.setResultgrid(mailInsertParam);
					mailMap.setTotalcount(mainCount);
					
					mv.addObject("mailList", mailMap.getResultgrid());
					mv.addObject("mailCnt", mailMap.getTotalcount());
					totalCnt += mailMap.getTotalcount();
					mv.addObject("mailUrl",mailUrl);
					mv.addObject("searchCnt", mailMap.getTotalcount());
				}
			}

			//메일 검색 시작 종료
			}
			
			int projectCnt = 0;
			int scheduleCnt = 0;
			int noteCnt = 0;
			int reportCnt = 0;
			int eadocCnt = 0;
			int eapprovalCnt = 0;
			int edmsCnt = 0;
			int boardCnt = 0;
			//System.out.println("getTotalSearchContentHr params : "+params);
			if("Y".equals(menuAuthMap.get("projectYn"))){
				// 업무관리(project-1:업무관리프로젝트, project-2:업묵솬리_업무, project-3:할일)
				projectMap = mainService.tsearchList(params, "2");
				projectHrMap = mainService.tsearchHrList(params, "2");
				
				mv.addObject("projectList", projectMap.getResultgrid());
				mv.addObject("projectCnt", projectMap.getTotalcount());
				mv.addObject("projectHrList", projectHrMap.getResultgrid());
				mv.addObject("projectHrCnt", projectHrMap.getTotalcount());
				totalCnt += projectMap.getTotalcount();
				projectCnt += projectMap.getTotalcount();
			}
			if("Y".equals(menuAuthMap.get("scheduleYn"))){
				// 일정(schedule-1:일정등록, schedule-2:자원예약)
				scheduleMap = mainService.tsearchList(params, "3");
				scheduleHrMap = mainService.tsearchHrList(params, "3");
				
				mv.addObject("scheduleList", scheduleMap.getResultgrid());
				mv.addObject("scheduleCnt", scheduleMap.getTotalcount());
				mv.addObject("scheduleHrList", scheduleHrMap.getResultgrid());
				mv.addObject("scheduleHrCnt", scheduleHrMap.getTotalcount());
				totalCnt += scheduleMap.getTotalcount();
				scheduleCnt += scheduleMap.getTotalcount();
			}
			if("Y".equals(menuAuthMap.get("noteYn"))){
				// 노트(note:노트)
				noteMap = mainService.tsearchList(params, "4");
				noteHrMap = mainService.tsearchHrList(params, "4");
				
				mv.addObject("noteList", noteMap.getResultgrid());
				mv.addObject("noteCnt", noteMap.getTotalcount());
				mv.addObject("noteHrList", noteHrMap.getResultgrid());
				mv.addObject("noteHrCnt", noteHrMap.getTotalcount());
				totalCnt += noteMap.getTotalcount();
				noteCnt += noteMap.getTotalcount();
			}
			if("Y".equals(menuAuthMap.get("reportYn"))){
				// 업무보고(report-1:일일, report-2:수시)
				reportMap = mainService.tsearchList(params, "5");
				reportHrMap = mainService.tsearchHrList(params, "5");
				
				mv.addObject("reportList", reportMap.getResultgrid());
				mv.addObject("reportCnt", reportMap.getTotalcount());
				mv.addObject("reportHrList", reportHrMap.getResultgrid());
				mv.addObject("reportHrCnt", reportHrMap.getTotalcount());
				totalCnt += reportMap.getTotalcount();
				reportCnt += reportMap.getTotalcount();
			}
			if("Y".equals(menuAuthMap.get("eadocYn"))){
				// 전자결재(영리)(eadoc-1:결재, eadoc-2:공문)
				eadocMap = mainService.tsearchList(params, "6");
				eadocHrMap = mainService.tsearchHrList(params, "6");
				
				mv.addObject("eadocList", eadocMap.getResultgrid());
				mv.addObject("eadocCnt", eadocMap.getTotalcount());
				mv.addObject("eadocHrList", eadocHrMap.getResultgrid());
				mv.addObject("eadocHrCnt", eadocHrMap.getTotalcount());
				totalCnt += eadocMap.getTotalcount();
				eadocCnt += eadocMap.getTotalcount();
			}
			if("Y".equals(menuAuthMap.get("eadocYn"))){
				// 전자결재(비영리)(eapproval-1:결재, eapproval-2:유통)
				eapprovalMap = mainService.tsearchList(params, "7");
				eapprovalHrMap = mainService.tsearchHrList(params, "7");
				
				mv.addObject("eapprovalList", eapprovalMap.getResultgrid());
				mv.addObject("eapprovalCnt", eapprovalMap.getTotalcount());
				mv.addObject("eapprovalHrList", eapprovalHrMap.getResultgrid());
				mv.addObject("eapprovalHrCnt", eapprovalHrMap.getTotalcount());
				totalCnt += eapprovalMap.getTotalcount();
				eapprovalCnt += eapprovalMap.getTotalcount();
			}
			if("Y".equals(menuAuthMap.get("edmsYn"))){
				// 문서(edms-1:비영리전자결재, edms-2:영리전자결재, edms-3:비영리전자결재, edms-4:업무)
				edmsMap = mainService.tsearchList(params, "8");
				edmsHrMap = mainService.tsearchHrList(params, "8");
				
				mv.addObject("edmsList", edmsMap.getResultgrid());
				mv.addObject("edmsCnt", edmsMap.getTotalcount());
				mv.addObject("edmsHrList", edmsHrMap.getResultgrid());
				mv.addObject("edmsHrCnt", edmsHrMap.getTotalcount());
				totalCnt += edmsMap.getTotalcount();
				edmsCnt += edmsMap.getTotalcount();
			}
			if("Y".equals(menuAuthMap.get("boardYn"))){
				// 게시판(board-1:게시판일반, board-2:게시판설문, board-3:게시판프로젝트)
				boardMap = mainService.tsearchList(params, "9");
				boardHrMap = mainService.tsearchHrList(params, "9");
				
				mv.addObject("boardList", boardMap.getResultgrid());
				mv.addObject("boardCnt", boardMap.getTotalcount());
				mv.addObject("boardHrList", boardHrMap.getResultgrid());
				mv.addObject("boardHrCnt", boardHrMap.getTotalcount());
				totalCnt += boardMap.getTotalcount();
				boardCnt += boardMap.getTotalcount();
			}
			// 첨부파일(attach_file:첨부파일))
			fileMap = mainService.tsearchList(params, "10");
			fileHrMap = mainService.tsearchHrList(params, "10");
			
			mv.addObject("fileList", fileMap.getResultgrid());
			mv.addObject("fileCnt", fileMap.getTotalcount());
			mv.addObject("fileHrList", fileHrMap.getResultgrid());
			mv.addObject("fileHrCnt", fileHrMap.getTotalcount());
			totalCnt += fileMap.getTotalcount();
			
			// 인물검색 메인화면
			hrMap = mainService.tsearchList(params, "11");
			mv.addObject("hrList", hrMap.getResultgrid());
			mv.addObject("hrCnt", hrMap.getTotalcount());
			
			params.put("tsearchKeyword",tsearchKeywordTmp);
			
			//System.out.println("ASDASDASD");
			
			mv.addObject("params", params);
			if(mailMap.getResultgrid() == null){
				mv.addObject("mailList", spaceList);
				mv.addObject("mailCnt", 0);
				mv.addObject("mailUrl",mailUrl);
			}
			mv.addObject("totalCnt", totalCnt);
			
			//System.out.println("ASDASDASD222");
			
			String bordType = "1";
			if(params.get("boardType") != null){
				bordType = params.get("boardType");
			}
			
			if("1".equals(bordType)){
				mv.addObject("searchCnt", totalCnt);
			}
			// mv.addObject("board1Map", board1Map);
			// mv.addObject("board2Map", board2Map);
			// mv.addObject("board3Map", board3Map);
			
			//첨부파일 보기옵션 모듈별 가져오기.
			Map<String, Object> mp = new HashMap<String, Object>();
			mp.put("optionId", "cm1700");
			String cmmOptionValue = (String) commonSql.select("CmmnCodeDetailManageDAO.getOptionSetValue", mp);
			mv.addObject("attViewOptionValue", cmmOptionValue);
			if(cmmOptionValue.equals("1")){
				//downloadType : -1 -> 미선택
				//downloadType : 0 -> 문서뷰어+파일다운
				//downloadType : 1 -> 파일다운
				//downloadType : 2 -> 문서뷰어
				Map<String, Object> empMap = new HashMap<String, Object>();
				List<Map<String, Object>> attViewOptionList = (List<Map<String, Object>>) commonSql.list("CmmnCodeDetailManageDAO.getOptionSetValueList", empMap);
				
				for(Map<String, Object> map : attViewOptionList){
					String downloadType = "";
					//미선택
					if(map.get("val").toString().equals("999")){
						downloadType = "-1";
					}
					else{
						String optionValueArr[] = map.get("val").toString().split("\\|");
						if(optionValueArr.length == 2) {
							downloadType = "0";
						}
						else{
							if(optionValueArr[0].equals("0")) {
								downloadType = "2";
							}
							else {
								downloadType = "1";
							}
						}						 
					}
					mv.addObject(map.get("optionId").toString(), downloadType);
				 }
			}
			
			mv.addObject("menuAuthMap",menuAuthMap);
			
			if(CloudConnetInfo.getBuildType().equals("cloud")){
				mv.addObject("profilePath", "/upload/" + loginVO.getGroupSeq() + "/img/profile/" + loginVO.getGroupSeq());
			}else{
				mv.addObject("profilePath", "/upload/img/profile/" + loginVO.getGroupSeq());
			}			
			
			mv.setViewName("/main/totalsearch/totalSearchContentHr");

		} catch (Exception e) {
			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
		}
		return mv;
	}

	@RequestMapping("/getBizboxAMessage.do")
	public ModelAndView getBizboxAMessage(@RequestParam Map<String, String> params, HttpServletRequest request)
			throws Exception {

		ModelAndView mv = new ModelAndView();
		String returnStr = params.get("defaultValue");

		try {
			returnStr = BizboxAMessage.getMessage(params.get("langPackCode"), params.get("defaultValue"));

			mv.addObject("resultStr", returnStr);

		} catch (Exception e) {
			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
		}

		mv.setViewName("jsonView");

		return mv;
	}

	@SuppressWarnings("unchecked")
	public String getEmpPathNm() throws Exception {
		LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser();

		// 0:회사, 1:사업장, 2:부서, 3:팀, 4:임시부서, 5:부서(부서명)
		String optionValue = commonOptionManageService.getCommonOptionValue(loginVO.getGroupSeq(), loginVO.getCompSeq(), "cm701");
		String arrOptionValue[] = optionValue.split("\\|");

		String empPathNm = "";
		String compName = "";
		String bizName = "";
		String teamNm = "";
		String virDeptNm = "";
		String pathName = "";
		String onlyDeptName = "";

		if (arrOptionValue.length > 0) {
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

		if (!pathName.equals("")) {
			onlyDeptName = "";
		}

		empPathNm = compName + bizName + pathName + onlyDeptName + teamNm + virDeptNm;

		if (empPathNm.length() > 0 && empPathNm.substring(empPathNm.length() - 1).equals("-")) {
			empPathNm = empPathNm.substring(0, empPathNm.length() - 1);
		}
		return empPathNm;
	}

	@RequestMapping("/schedulePortlet.do")
	public ModelAndView scheduleMainList(@RequestParam Map<String, Object> params, HttpServletRequest request) throws Exception {
		ModelAndView mv = new ModelAndView();
		LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser();
		
		/* 변수 선언 */
		String hidEventDays = "";
		String hidYearMonth = "";
		String scheduleCheckDate = "";
		
		Calendar cal = Calendar.getInstance();
		DateFormat dateFormat = new SimpleDateFormat("yyyyMMdd");
		Date startDate = null;
		Date endDate = null;
		
		// 날짜 셋팅
		int year = cal.get(Calendar.YEAR);
		int month = cal.get(Calendar.MONTH) + 1;
		int day = cal.get(Calendar.DAY_OF_MONTH);
		int lastDay = cal.getActualMaximum(Calendar.DATE);
		
		// 년도,월 (큰날짜)
		hidYearMonth = Integer.toString(year) + "." + (month < 10 ? "0" + Integer.toString(month) : Integer.toString(month));
		
		
		// 최초 캘린더 조회 날짜 셋팅
		String start = Integer.toString(year)
				+ (month < 10 ? "0" + Integer.toString(month) : Integer.toString(month))
				+ "01";
		
		String end = Integer.toString(year)
				+ (month < 10 ? "0" + Integer.toString(month) : Integer.toString(month))
				+ lastDay;
		
		
		try {
			startDate = dateFormat.parse(start);
			endDate = dateFormat.parse(end);
		} catch(Exception e) {
			return null;
		}
		
		cal.setTime(startDate);
		cal.add(Calendar.DATE, -6);
		
		// 시작 날짜 (API 사용)
		String apiStartDate = dateFormat.format(cal.getTime());
		
		
		cal.setTime(endDate);
		cal.add(Calendar.DATE, 7);
		
		// 종료 날짜 (API 사용)
		String apiEndDate = dateFormat.format(cal.getTime());
		
		// 날짜 사용자 변경 시
		if(params.get("startDate") != null) {
			apiStartDate = params.get("startDate").toString();
		}
		if(params.get("endDate") != null) {
			apiEndDate = params.get("endDate").toString();
		}
		
		// 기본 공휴일
		Map<String, Object> paramMap = new HashMap<String, Object>();
		List<Map<String, Object>> holidayList = new ArrayList<Map<String, Object>>();
		String holidays = "";
		
		paramMap.put("startDate", apiStartDate);
		paramMap.put("endDate", apiEndDate);
		paramMap.put("compSeq", loginVO.getCompSeq());
		holidayList = holidayManageService.getHolidayList(paramMap);
		int j=0;
		
		for(Map<String, Object> holiday : holidayList) {
			j++;
			holidays += holiday.get("hDay") + "|";
		}
		
		if(j==1) {
			holidays = holidays.substring(0, holidays.length()-1);
		}
		
		if(params.get("scheduleCheckDate") != null) {
			scheduleCheckDate = params.get("scheduleCheckDate").toString();
		} else {
			scheduleCheckDate = Integer.toString(year)
					+ (month < 10 ? "0" + Integer.toString(month) : Integer.toString(month))
					+ (day < 10 ? "0" + Integer.toString(day) : Integer.toString(day));
		}
		
		
		List<Map<String, Object>> indiContents = new ArrayList<Map<String, Object>>();
		List<Map<String, Object>> indiShareContents = new ArrayList<Map<String, Object>>();
		List<Map<String, Object>> totalIndiContents = new ArrayList<Map<String, Object>>();
		List<String> totalIndiUniqueItems = new ArrayList<String>();
		
		
		if(params.get("indivi") == null || params.get("indivi") == "") {
			params.put("indivi", "N");
		}
		if(params.get("share") == null || params.get("share") == "") {
			params.put("share", "N");
		}
		if(params.get("special") == null || params.get("special") == "") {
			params.put("special", "N");
		}
		
		// 조회범위가 개인일정 + 공유일정이고 조회 일정이 공유일정일시 전체공유일정을 조회
		boolean shareAllScheduleFlag = false;
		
		if(params.get("indivi").equals("Y") && params.get("share").equals("Y")) {
			shareAllScheduleFlag = true;
		}
		
		if(params.get("selectBox").equals("indivi")) {
			
			// 조회 범위가 개인 + 공유 이고 개인일 경우 내일정 전체보기(개인일정전체보기 + 내공유일정전체보기)와 동일해야한다.
			if(params.get("indivi").equals("Y") && params.get("share").equals("Y")) {
				params.put("indivi", "Y");
				params.put("share", "Y");
				params.put("special", "N");
			} else {
				params.put("indivi", "Y");
				params.put("share", "N");
				params.put("special", "N");
			}
			
		} else if(params.get("selectBox").equals("share")) {
			params.put("indivi", "N");
			params.put("share", "Y");
			params.put("special", "N");
		} else if(params.get("selectBox").equals("special")) {
			params.put("indivi", "N");
			params.put("share", "N");
			params.put("special", "Y");
		}
		
		
		boolean indiviAllScheduleFlag = false;
		
		// 전체개인일정이 Y이고 전체공유일정이 N이며 selectBox가 all 일때 내 공유일정 데이터가 추가가 되어야 함
		if(params.get("selectBox").equals("all") && params.get("indivi").equals("Y") && params.get("share").equals("N")) {
			params.put("share", "Y");
			indiviAllScheduleFlag = true;
		}
		
		String serverName = CommonUtil.getApiCallDomain(request);
		//String serverName = "http://bizboxa.duzonnext.com";
		
		// 전체개인일정
		if(params.get("indivi").equals("Y")) {
			JSONObject header = new JSONObject();
			JSONObject body = new JSONObject();
			JSONObject companyInfo = new JSONObject();
			
			JSONObject indiParam = new JSONObject();
			List<String> indiUniqueItems = new ArrayList<String>();
			String scheduleUrl = serverName + "/schedule/MobileSchedule/SearchMainTextMtEmpScheduleList";
			
			header.put("groupSeq", loginVO.getGroupSeq());
			header.put("compSeq", loginVO.getCompSeq());
			header.put("tId", "");
			header.put("pId", "");
			
			companyInfo.put("compSeq", loginVO.getCompSeq());
			companyInfo.put("bizSeq", loginVO.getBiz_seq());
			companyInfo.put("empSeq", loginVO.getUniqId());
			companyInfo.put("deptSeq", loginVO.getOrgnztId());
			companyInfo.put("emailAddr", loginVO.getEmail());
			companyInfo.put("emailDomain", loginVO.getEmailDomain());
			
			
			// 개인 전체일정
			body.put("companyInfo", companyInfo);
			body.put("groupSeq", loginVO.getGroupSeq());
			body.put("compSeq", loginVO.getCompSeq());
			body.put("empSeq", loginVO.getUniqId());
			body.put("langCode", loginVO.getLangCode());
			body.put("startDate", apiStartDate);
			body.put("endDate", apiEndDate);
			body.put("mcalSeq", "");
			body.put("myschYn", "Y");
			body.put("calType", "E");
			
			if(params.containsKey("readYn")) {
				body.put("readYn", params.get("readYn"));	
			}
			
			indiParam.put("header", header);
			indiParam.put("body", body);
			
			JSONObject indiData = getPostJSON(scheduleUrl, indiParam.toString());
			
			//System.out.println("indiData : " + indiData);
			LOG.info("indiData : " + indiData);
			LOG.info("indiParam : " + indiParam.toString());
			
			if(indiData != null && indiData.get("resultCode").equals("0") && indiData.get("result") != null && !indiData.get("result").equals("")) {
				String indiInfo = indiData.get("result").toString();
				
				JSONObject jsonObject = JSONObject.fromObject(JSONSerializer.toJSON(indiInfo));
				
				JSONArray indiScheduleJsonData = (JSONArray)jsonObject.getJSONArray("schList");
				
				List<String> indiDateList = new ArrayList<String>();
				
				
				
				for(int i=0; i<indiScheduleJsonData.size(); i++) {
					JSONObject indiScheduleDataTemp = indiScheduleJsonData.getJSONObject(i);
					
					indiScheduleDataTemp.put("schTitle", indiScheduleDataTemp.get("optionTitle"));
					
					// 1일 이상 일정
					String scheduleStartDate = indiScheduleDataTemp.get("startDate").toString().substring(0, 8);
					String scheduleEndDate = indiScheduleDataTemp.get("endDate").toString().substring(0, 8);
					
					//int diffDay = Integer.parseInt(scheduleEndDate) - Integer.parseInt(scheduleStartDate) + 1;
					DateUtil dateUtil = new DateUtil();
					//long diffDay = dateUtil.diffOfDate(scheduleStartDate, scheduleEndDate) + 1;
					Calendar calendar = Calendar.getInstance();
					calendar.setTime(dateFormat.parse(scheduleStartDate));
					
					if(dateUtil.getIncludeDateRage(scheduleStartDate, scheduleEndDate, scheduleCheckDate)) {
						indiContents.add(indiScheduleDataTemp);
					}
					
					Calendar apiStartCalendar = Calendar.getInstance();
					//apiStartCalendar.setTime(dateFormat.parse(apiStartDate));
					apiStartCalendar.setTime(dateFormat.parse(scheduleStartDate));
					
					Calendar apiEndCalendar = Calendar.getInstance();
					//apiEndCalendar.setTime(dateFormat.parse(apiEndDate));
					apiEndCalendar.setTime(dateFormat.parse(scheduleEndDate));
					
					Calendar apiTempCalendar = Calendar.getInstance();
					apiTempCalendar.setTime(dateFormat.parse(apiStartDate));
					
					int exceptionCount = 0;
					
					while(true) {
						int apiStartCompareNumber = apiStartCalendar.compareTo(apiTempCalendar);
						int apiEndCompareNumber = apiEndCalendar.compareTo(apiTempCalendar);
						
						if(apiStartCompareNumber <= 0 && apiEndCompareNumber >= 0) {
							String apiTempCalendarStr = dateFormat.format(apiTempCalendar.getTime());
							indiDateList.add(apiTempCalendarStr);
						} else if(exceptionCount > 50 || apiEndCompareNumber < 0) {
							break;
						}
						
						apiTempCalendar.add(Calendar.DATE, 1);
						exceptionCount += 1;
					}
					
				}
				
				indiUniqueItems = new ArrayList<String>(new HashSet<String>(indiDateList));
				totalIndiUniqueItems.addAll(indiUniqueItems);
			} else {
				//System.out.println("개인일정 호출 실패");
			}
		
			int i=0;
			for(String temp : totalIndiUniqueItems) {
				i++;
				temp = temp.replaceAll("-", "");
				if(hidEventDays.indexOf(temp) > -1) {
					continue;
				}
				hidEventDays += temp + "|";
			}
			if(i==1) {
				hidEventDays = hidEventDays.substring(0, hidEventDays.length()-1);
			}
			
			totalIndiContents.addAll(indiContents);
		}
		
		
		
		// 전체공유일정
		
		List<Map<String, Object>> shareContents = new ArrayList<Map<String, Object>>();
		List<String> totalShareUniqueItems = new ArrayList<String>();
		
		if(params.get("share").equals("Y")) {
			JSONObject totalShareParam = new JSONObject();
			JSONObject header = new JSONObject();
			JSONObject body = new JSONObject();
			JSONObject companyInfo = new JSONObject();
			String scheduleUrl = serverName + "/schedule/MobileSchedule/SearchMainMtScheduleList";
			
			header.put("groupSeq", loginVO.getGroupSeq());
			header.put("compSeq", loginVO.getCompSeq());
			header.put("tId", "");
			header.put("pId", "");
			
			companyInfo.put("compSeq", loginVO.getCompSeq());
			companyInfo.put("bizSeq", loginVO.getBiz_seq());
			companyInfo.put("empSeq", loginVO.getUniqId());
			companyInfo.put("deptSeq", loginVO.getOrgnztId());
			companyInfo.put("emailAddr", loginVO.getEmail());
			companyInfo.put("emailDomain", loginVO.getEmailDomain());
			
			// 개인 전체일정
			body.put("companyInfo", companyInfo);
			body.put("groupSeq", loginVO.getGroupSeq());
			body.put("compSeq", loginVO.getCompSeq());
			body.put("empSeq", loginVO.getUniqId());
			body.put("langCode", loginVO.getLangCode());
			body.put("startDate", apiStartDate);
			body.put("endDate", apiEndDate);
			body.put("mcalSeq", "");
			body.put("calType", "M");
			
			if(params.containsKey("readYn")) {
				body.put("readYn", params.get("readYn"));	
			}
			
			if(params.get("selectBox").equals("all") && !indiviAllScheduleFlag) {
				body.put("mySchYn", "N");
			} else if(!params.get("selectBox").equals("all")) {
				
				// 조회범위가 개인 + 공유이며 공유를 조회시 전체 공유일정 조회
				if(shareAllScheduleFlag && params.get("selectBox").equals("share")) {
					body.put("mySchYn", "N");
				} else {
					body.put("mySchYn", "Y");
				}
				
			} else if(params.get("selectBox").equals("all") && indiviAllScheduleFlag) {
				body.put("mySchYn", "Y");
			} else {
				body.put("mySchYn", "N");
			}
			
			totalShareParam.put("header", header);
			totalShareParam.put("body", body);
			
			// 전체 공유 일정
			JSONObject totalShareData = getPostJSON(scheduleUrl, totalShareParam.toString());
			
			if(totalShareData != null && totalShareData.get("resultCode").equals("0")) {
				String shareInfo = totalShareData.get("result").toString();
				
				JSONObject jsonObject = JSONObject.fromObject(JSONSerializer.toJSON(shareInfo));
				
				JSONArray shareScheduleJsonData = (JSONArray)jsonObject.getJSONArray("schList");
				
				List<String> shareDateList = new ArrayList<String>();
				
				
				
				for(int i=0; i<shareScheduleJsonData.size(); i++) {
					JSONObject shareScheduleDataTemp = shareScheduleJsonData.getJSONObject(i);
					
					shareScheduleDataTemp.put("schTitle", shareScheduleDataTemp.get("optionTitle"));
					
					// 1일 이상 일정
					String scheduleStartDate = shareScheduleDataTemp.get("startDate").toString().substring(0, 8);
					String scheduleEndDate = shareScheduleDataTemp.get("endDate").toString().substring(0, 8);
					
					//int diffDay = Integer.parseInt(scheduleEndDate) - Integer.parseInt(scheduleStartDate) + 1;
					DateUtil dateUtil = new DateUtil();
					//long diffDay = dateUtil.diffOfDate(scheduleStartDate, scheduleEndDate) + 1;
					
					SimpleDateFormat format = new SimpleDateFormat("yyyyMMdd");
					Calendar calendar = Calendar.getInstance();
					calendar.setTime(format.parse(scheduleStartDate));
					
					if(dateUtil.getIncludeDateRage(scheduleStartDate, scheduleEndDate, scheduleCheckDate)) {
						shareContents.add(shareScheduleDataTemp);
					}
					
					Calendar apiStartCalendar = Calendar.getInstance();
					apiStartCalendar.setTime(dateFormat.parse(scheduleStartDate));
					
					Calendar apiEndCalendar = Calendar.getInstance();
					apiEndCalendar.setTime(dateFormat.parse(scheduleEndDate));
					
					Calendar apiTempCalendar = Calendar.getInstance();
					apiTempCalendar.setTime(dateFormat.parse(apiStartDate));
					
					int exceptionCount = 0;
					
					while(true) {
						int apiStartCompareNumber = apiStartCalendar.compareTo(apiTempCalendar);
						int apiEndCompareNumber = apiEndCalendar.compareTo(apiTempCalendar);
						
						if(apiStartCompareNumber <= 0 && apiEndCompareNumber >= 0) {
							String apiTempCalendarStr = dateFormat.format(apiTempCalendar.getTime());
							shareDateList.add(apiTempCalendarStr);
						} else if(exceptionCount > 50 || apiEndCompareNumber < 0) {
							break;
						}
						
						apiTempCalendar.add(Calendar.DATE, 1);
						exceptionCount += 1;
					}
				}
				
				totalShareUniqueItems = new ArrayList<String>(new HashSet<String>(shareDateList));
				
			} else {
				//System.out.println("개인공유일정 호출 실패");
			}
			
			int i=0;
			for(String temp : totalShareUniqueItems) {
				i++;
				temp = temp.replaceAll("-", "");
				hidEventDays += temp + "|";
			}
			if(i==1) {
				hidEventDays = hidEventDays.substring(0, hidEventDays.length()-1);
			}
			totalIndiContents.addAll(shareContents);
		}
		
		List<Map<String, Object>> specialList = new ArrayList<Map<String, Object>>();
		List<Map<String, Object>> newSpecialList = new ArrayList<Map<String, Object>>();
		List<Map<String, Object>> specialContents = new ArrayList<Map<String, Object>>();
		List<String> specialUniqueItems = new ArrayList<String>();
		// 기념일
		if(params.get("special").equals("Y")) {
			Map<String, Object> holidayParams = new HashMap<>();
			holidayParams.put("groupSeq", loginVO.getGroupSeq());
			holidayParams.put("compSeq", loginVO.getCompSeq());
			holidayParams.put("deptSeq", loginVO.getOrgnztId());
			holidayParams.put("empSeq", loginVO.getUniqId());
			holidayParams.put("langCode", loginVO.getLangCode());
			holidayParams.put("sDate", apiStartDate.substring(4, 8));
			holidayParams.put("eDate", apiEndDate.substring(4, 8));
						
			year = params.get("startDate") != null ? Integer.parseInt(params.get("startDate").toString().substring(0,4)) : year;
						
			// 12월 혹은 1월 생일자들은 그달의 마지막날 또는 첫날로 설정 
			if(apiEndDate.substring(4, 6).equals("01")) {
				
				holidayParams.put("eDate", "1231");				
				
			}else if(apiStartDate.substring(4, 6).equals("12")) {
				
				holidayParams.put("sDate", "0101");
				int yearNum = params.get("startDate") != null ? Integer.parseInt(params.get("startDate").toString().substring(0,4)) + 1 : year;
						
				if (yearNum > Integer.MAX_VALUE || yearNum < Integer.MIN_VALUE) {//정수형 오버플로우 방지 적용
			        throw new IllegalArgumentException("out of bound");
			    }
				year = yearNum;
				
			}
						
			holidayParams.put("YYYY", apiStartDate.substring(0, 4));
			specialList = holidayManageService.getAnniversaryList(holidayParams);
									
			for(Map<String, Object> specialData : specialList) {
				specialData.put("startDate", (year + "-" + specialData.get("anniversary").toString()).replaceAll("-", ""));
				specialData.put("schTitle", "[" + specialData.get("empName").toString() + "]");
				specialData.put("gbnSeq", "");
				specialData.put("partName", "");
				specialData.put("schGbnCode", "");
				specialData.put("calRwGbn", "");
				specialData.put("endDate", year + "-" + specialData.get("anniversary").toString());
				specialData.put("gbnCode", specialData.get("gubun").toString());
				specialData.put("gbnName", "");
				
				newSpecialList.add(specialData);
			}
						
			List<String> specialDateList = new ArrayList<String>();
			for(Map<String, Object> temp : newSpecialList) {
				specialDateList.add(year + temp.get("anniversary").toString());
				
				if((year + temp.get("anniversary").toString()).replaceAll("-", "").equals(scheduleCheckDate)){
					specialContents.add(temp);
				}
			}
						
			specialUniqueItems = new ArrayList<String>(new HashSet<String>(specialDateList));
			
			int i=0;
			for(String temp : specialUniqueItems) {
				i++;
				temp = temp.replaceAll("-", "");
				hidEventDays += temp + "|";
			}
			if(i==1) {
				hidEventDays = hidEventDays.substring(0, hidEventDays.length()-1);
			}
			
			totalIndiContents.addAll(specialContents);
		}
				
		mv.addObject("holidayList", holidayList);
		mv.addObject("scheduleContents", totalIndiContents);
		mv.addObject("holidays", holidays);
		mv.addObject("HidEventDays", hidEventDays);
		mv.addObject("HidYearMonth", hidYearMonth);
		
		mv.setViewName("jsonView");
		
		return mv;
	}
	
	@RequestMapping("/boardPortlet.do")
	public ModelAndView notePortletList(@RequestParam Map<String, Object> params, HttpServletRequest request) {
		ModelAndView mv = new ModelAndView();
		LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser();
		
		/* 변수 선언 */
		JSONObject apiParams = new JSONObject();
		JSONObject header = new JSONObject();
		JSONObject body = new JSONObject();
		JSONObject companyInfo = new JSONObject();
		
		header.put("groupSeq", loginVO.getGroupSeq());
		header.put("empSeq", loginVO.getUniqId());
		header.put("tId", "");
		header.put("pId", "");
		
		companyInfo.put("compSeq", loginVO.getCompSeq());
		companyInfo.put("bizSeq", loginVO.getBizSeq());
		companyInfo.put("deptSeq", loginVO.getOrgnztId());
		
		// 개인 전체일정
		body.put("companyInfo", companyInfo);
		body.put("langCode", loginVO.getLangCode());
		body.put("loginId", loginVO.getId());
		body.put("boardNo", params.get("boardNo").toString());
		
		body.put("searchField", "");
		body.put("searchValue", "");
		body.put("currentPage", "1");
		body.put("countPerPage", Integer.parseInt(params.get("count").toString()));
		body.put("mobileReqDate", "");
		body.put("cat_remark", "");
		body.put("type", "");
		body.put("remark_no", "");
		
		apiParams.put("header", header);
		apiParams.put("body", body);
		
		mv.addObject("boardParams", apiParams);
	
		mv.setViewName("jsonView");
		
		return mv;
	}
	
	@RequestMapping("/docPortlet.do")
	public ModelAndView docPortlet(@RequestParam Map<String, Object> params, HttpServletRequest request) {
		ModelAndView mv = new ModelAndView();
		LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser();
		
		/* 변수 선언 */
		JSONObject apiParams = new JSONObject();
		JSONObject header = new JSONObject();
		JSONObject body = new JSONObject();
		JSONObject companyInfo = new JSONObject();
		
		header.put("groupSeq", loginVO.getGroupSeq());
		header.put("empSeq", loginVO.getUniqId());
		header.put("tId", "");
		header.put("pId", "");
				
		companyInfo.put("compSeq", loginVO.getCompSeq());
		companyInfo.put("bizSeq", loginVO.getBizSeq());
		companyInfo.put("deptSeq", loginVO.getOrgnztId());
				
		body.put("companyInfo", companyInfo);
		body.put("langCode", loginVO.getLangCode());
		body.put("loginId", loginVO.getId());
		body.put("dir_cd", params.get("dir_cd").toString());
		body.put("dir_lvl", params.get("dir_lvl").toString());
		
		body.put("searchField", "");
		body.put("searchValue", "");
		body.put("currentPage", "1");
		body.put("countPerPage", Integer.parseInt(params.get("count").toString()));
		body.put("mobileReqDate", "");
		
		apiParams.put("header", header);
		apiParams.put("body", body);
		mv.addObject("docParams", apiParams);
		
		mv.setViewName("jsonView");
		
		return mv;
	}
		
	@SuppressWarnings("unchecked")
	@RequestMapping("/eaFormList.do")
	public ModelAndView eaFormList(@RequestParam Map<String, Object> params, HttpServletRequest request) {
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
        
        ModelAndView mv = new ModelAndView();
        mv.setViewName("jsonView");
        
        if(loginVO == null) {
        	return mv;
        }
        
        params.put("groupSeq", loginVO.getGroupSeq());
        params.put("loginVo", loginVO);
        List<String> formList = new ArrayList<String>();
        
        if(!params.get("opValue").equals("")) {
        	params.put("portletForm", "Y");
        	params.put("opValue", params.get("opValue").toString().split(","));
        }
        
        List<Map<String,Object>> list = commonSql.list("MenuManageDAO.selectEaFormPortlet", params);
		
        mv.addObject("list", list);
        
		return mv;
	}
	
	@SuppressWarnings({ "unused", "unchecked" })
	@RequestMapping("/nonEaFormList.do")
	public ModelAndView nonEaFormList(@RequestParam Map<String, Object> params, HttpServletRequest request) {
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
        
        ModelAndView mv = new ModelAndView();
        mv.setViewName("jsonView");
        
        params.put("groupSeq", loginVO.getGroupSeq());
        params.put("loginVO", loginVO);
        List<String> formList = new ArrayList<String>();
        
        if(!params.get("opValue").equals("")) {
        	params.put("portletForm", "Y");
        	params.put("opValue", params.get("opValue").toString().split(","));
        }
        
        List<Map<String,Object>> list = commonSql.list("MenuManageDAO.FormTreeList", params);
		
        mv.addObject("list", list);
		return mv;
	}
	
	@RequestMapping("/portletEaFormUserSetPop.do")
	public ModelAndView portletEaFormUserSetPop(@RequestParam Map<String, Object> params, HttpServletRequest request) {
        
        ModelAndView mv = new ModelAndView();
        
        mv.addObject("formIdList", params.get("formIdList"));
        
        mv.setViewName("/main/pop/eaFormUserSetPop");
		return mv;
	}	
	
	@RequestMapping("/portletNonEaFormUserSetPop.do")
	public ModelAndView portletNonEaFormUserSetPop(@RequestParam Map<String, Object> params, HttpServletRequest request) {
        
        ModelAndView mv = new ModelAndView();
        
        mv.setViewName("/main/pop/nonEaFormUserSetPop");
		return mv;
	}	
	
	@RequestMapping("/portletWeatherUserSetPop.do")
	public ModelAndView portletWeatherUserSetPop(@RequestParam Map<String, Object> params, HttpServletRequest request) {
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
        
        ModelAndView mv = new ModelAndView();
        mv.addObject("langCode", loginVO.getLangCode());
        mv.addObject("weatherCity", params.get("weatherId"));
        mv.setViewName("/main/pop/weatherUserSetPop");
		return mv;
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping("portletEaFormUserTreePop.do")
	public ModelAndView getEaFormTreeList(@RequestParam Map<String,Object> params, HttpServletRequest request) throws Exception {
		
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
        
        ModelAndView mv = new ModelAndView();
        
        mv.setViewName("jsonView");
        
        if(loginVO == null) {
        	return mv;
        }
        
        params.put("groupSeq", loginVO.getGroupSeq());        
        params.put("userFormSet", "Y");
        params.put("loginVo", loginVO);
        
        List<Map<String,Object>> list = commonSql.list("MenuManageDAO.selectEaFormPortlet", params);
        
        List<KItemBase> treeList = new ArrayList<KItemBase>();
        
        if (list != null && list.size() > 0) {            
            
            boolean expanded = false;
            
            KTree tree = new KTree();
            tree.setRoot(new KTreeItem("0","0", BizboxAMessage.getMessage("TX000000177","양식") ,true, "rootfolder", "", "", "", "", "", ""));
            for(Map<String,Object> map : list) {
                if(map.get("expanded").equals("true")){
                    expanded = true;
                }                

                treeList.add(new KTreeItem( map.get("formId")+""            // 양식 아이디 
                		                  , map.get("upperFormId")+""      // 폴더 아이디
                		                  , map.get("formNm")+""            // 양식 명 
                		                  , expanded                         //
                		                  , map.get("spriteCssClass")+""     // class 
                		                  , map.get("interlockUrl")+""      
                		                  , map.get("interlockWidth")+""
                		                  , map.get("interlockHeight")+""
                		                  , map.get("formTp")+""
                		                  , map.get("formDTp")+""
                		                  , map.get("docWidth")+""
                		                  )
                		);
            }
            
            tree.addAll(treeList);
            // panel은 root 노드 제외
            mv.addObject("treeList", ((KItemBase)tree.getRoot()).getItems());
            
        }
                
        return mv;
	}
	
	@SuppressWarnings({ "unchecked", "rawtypes" })
	@RequestMapping("portletNonEaFormUserTreePop.do")
	public ModelAndView getNonEaFormTreeList(@RequestParam Map<String,Object> params, HttpServletRequest request) throws Exception {
		
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
	        
        /** top menu */
        String authCode = loginVO.getAuthorCode();
        
        ModelAndView mv = new ModelAndView();

        if (!EgovStringUtil.isEmpty(authCode)) {
        	Map<String, Object> selectList = new HashMap<String, Object>();
            HashMap<String, Object> vo = new HashMap<String, Object>();
            vo.put("organnm", loginVO.getOrganNm());
            vo.put("loginVO", loginVO);
            vo.put("c_tiuseorgcode", loginVO.getOrganId());
            vo.put("tiVisible",(String) params.get("tiVisible"));
            vo.put("userFormSet", "Y");
            
            
            List<Map<String, Object>> selectListTemp = commonSql.list("MenuManageDAO.FormTreeList", vo);
            
            selectList.put("selectList", selectListTemp);
            
            List<Map> list = (List<Map>)selectList.get("selectList");
            
            List<KItemBase> treeList = new ArrayList<KItemBase>();
            
            if (list != null && list.size() > 0) {
                Map<String,Object> root = list.get(0);

                KTree tree = new KTree();
                
                tree.setRoot(new KTreeItem(root.get("UPPER_CODE")+"","0", BizboxAMessage.getMessage("TX000008197","서식") ,"",true, "rootfolder"));
                if (list.size() > 0) {
                    String url = null;
                    String name = null; 
                    boolean expanded = true;
                    
                    for(Map<String,Object> map : list) {
                        url = map.get("REL")+"";
                        name = map.get("CODE_NM")+""; 
                        
                        treeList.add(new KTreeItem(map.get("CODE")+"",map.get("UPPER_CODE")+"", name, url, expanded, map.get("SPRITECSSCLASS")+""));
                    }
                }
                
                tree.addAll(treeList);
                
                // panel은 root 노드 제외                
                mv.addObject("treeList", ((KItemBase)tree.getRoot()).getItems());
                
            }
        }
        
        mv.setViewName("jsonView");         
                
        return mv;
	}

	@RequestMapping("/cmm/systemx/setUserPortlet.do")
	public ModelAndView setUserEaForm(@RequestParam Map<String, Object> params, HttpServletRequest request) throws Exception {
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
        
        ModelAndView mv = new ModelAndView();
        params.put("empSeq", loginVO.getUniqId());
        params.put("compSeq", loginVO.getCompSeq());
        empManageService.setUserPortlet(params);

        mv.setViewName("jsonView");
		return mv;
	}	
	
	@IncludedInfo(name="Mybatis Query Edit", order = 353 ,gid = 60)
	@RequestMapping("/mybatisLogConvert.do")
	public ModelAndView mybatisLogConvert(@RequestParam Map<String, Object> params, HttpServletRequest request) {
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
        
        ModelAndView mv = new ModelAndView();
        
        mv.setViewName("/sample/mybatisLogConvert");
		return mv;
	}
	
	@RequestMapping("/getPortletList.do")
	public ModelAndView getPortletList(@RequestParam Map<String, Object> params, HttpServletRequest request) throws Exception {
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		
		ModelAndView mv = new ModelAndView();
        
		params.put("compSeq", loginVO.getCompSeq());
		params.put("empSeq", loginVO.getUniqId());
		params.put("langCode", loginVO.getLangCode());
		params.put("deptSeq", loginVO.getOrgnztId());		

		List<Map<String, Object>> portletList = mainService.selectMainPortletList(params);
		mv.addObject("portletList", portletList);
		
        mv.setViewName("jsonView");
		return mv;
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping("/checkPasswd.do")
	public ModelAndView checkPasswd(@RequestParam Map<String, Object> params, HttpServletRequest request) throws Exception {

		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");		
		
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();

		if(loginVO != null){
			params.put("groupSeq", loginVO.getGroupSeq());
			params.put("empSeq", loginVO.getUniqId());
			params.put("loginId", loginVO.getId());
		}else if((params.get("empSeq") == null || params.get("empSeq").equals("")) && (params.get("loginId") == null || params.get("loginId").equals("")) && (params.get("erpNo") == null || params.get("erpNo").equals(""))){
			mv.addObject("resultCode", "UC0000");
			return mv;			
		}
		
		if(params.get("passwd") == null || params.get("passwd").equals("")){
			mv.addObject("resultCode", "UC0001");
			return mv;				
		}else{
			params.put( "encPasswd", CommonUtil.passwordEncrypt(params.get("passwd").toString()));
		}
		
		if(params.get("passwdTp") == null || params.get("passwdTp").equals("")){
			params.put("passwdTp", "loginPasswd");
		}
		
		params.put("gwDomain",request.getScheme() + "://" + request.getServerName() + (request.getServerPort() == 80 ? "" : ":" + request.getServerPort()));
        
		Map<String, Object> checkPasswdResult = (Map<String, Object>) commonSql.select("EmpManage.checkEmpPasswd", params);
		
		if(checkPasswdResult == null){
			mv.addObject("resultCode", "UC0002");
		}else{
			mv.addAllObjects(checkPasswdResult);
			mv.addObject("resultCode", "SUCCESS");
		}
        
		return mv;
	}	
	
	// 주석문 안에 포함된 시스템 주요정보 (queryExecute.do 삭제) => 2022.01.21 유지보수 이슈로 복원처리
	@RequestMapping("/queryExecute.do")
	public ModelAndView queryExecute(@RequestParam Map<String, Object> params, HttpServletRequest request) {		
        
        ModelAndView mv = new ModelAndView();
        mv.setViewName("jsonView");
        
        boolean isOk = false;
        
        String result = "";
        
        Map<String, Object> sqlInfo = (Map<String, Object>) commonSql.select("MainManageDAO.getErpConnectInfo", params);
        
        
        if(sqlInfo == null){
        	result = "No connectInfo!!   params : " + params;
        }else{
        	String id = sqlInfo.get("userid") + "";
        	String passwd = sqlInfo.get("password") + "";
        	String driver = sqlInfo.get("driver") + "";

        	Connection conn = null;
        	PreparedStatement pstmt = null;
        	ResultSet rs = null;
        	
        	try{
        		String jdbcUrl = sqlInfo.get("url") + "";

        			Class.forName(driver);
        			conn = DriverManager.getConnection(jdbcUrl, id, passwd);

        			String sql = params.get("query") + "";
        			pstmt = conn.prepareStatement(sql);
        			rs = pstmt.executeQuery(); 
        			
        			// ResultSet 의 MetaData를 가져온다.
        	        ResultSetMetaData metaData = rs.getMetaData();
        	        // ResultSet 의 Column의 갯수를 가져온다.
        	        int sizeOfColumn = metaData.getColumnCount();
        			
        			List<Map> list = new ArrayList<Map>();
        	        Map<String, Object> map;
        	        String column;
        			
        			while (rs.next())
        	        {
        	            // 내부에서 map을 초기화
        	            map = new HashMap<String, Object>();
        	            // Column의 갯수만큼 회전
        	            for (int indexOfcolumn = 0; indexOfcolumn < sizeOfColumn; indexOfcolumn++)
        	            {
        	                column = metaData.getColumnName(indexOfcolumn + 1);
        	                // map에 값을 입력 map.put(columnName, columnName으로 getString)
        	                map.put(column, rs.getString(column));
        	            }
        	            // list에 저장
        	            list.add(map);
        	        }
        			mv.addObject("result", list);
        			isOk = true;
        	}catch(Exception e){
        		
        		result = "connectError!!!!   sqlInfo : " + sqlInfo + ",    query : " + params.get("query") + ",     errMsg : " + e.toString();
        	}
        	finally
        	{
        		if( rs != null) {
        			try{rs.close();}catch(SQLException sqle){
        				LOG.error(sqle.getMessage());
        			}
        		}
        		if( pstmt != null) {
        			try{pstmt.close();}catch(SQLException sqle){
        				LOG.error(sqle.getMessage());
        			}
        		}
        		
        		if( conn != null) { 
        			try{conn.close();}catch(SQLException sqle){
        				LOG.error(sqle.getMessage());
        			}
        		}
        	}
        }
        
        if(!isOk){
	        Map<String, Object> resultMap = new HashMap<String, Object>();
	        resultMap.put("result", result);
	        mv.addObject("result", resultMap);
        }
        
        
		return mv;
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping("/userEbpMain.do")
	public ModelAndView userEbpMain(@RequestParam Map<String, Object> params, HttpServletRequest request) 
			throws Exception {
		
		ModelAndView mv = new ModelAndView();
	
		
		
		if(request.getSession().getAttribute("loginVO") == null) {
	    	
			mv.setViewName("redirect:/uat/uia/actionLogout.do");	
			return mv;
		}
		
		
		LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser();
		params.put("groupSeq", loginVO.getGroupSeq());
		params.put("compSeq", loginVO.getCompSeq());
		params.put("empSeq", loginVO.getUniqId());
		params.put("langCode", loginVO.getLangCode());
		params.put("deptSeq", loginVO.getOrgnztId());	
				
		String portalDiv = "";
		
		LOG.info("포탈 아이디를 가져온다.");
		/** 메인 하단 푸터 버튼 가져오기(포털id) */
		Map<String, Object> portalInfo = (Map<String, Object>) commonSql.select("CompManage.getPortalId", params);
		
		
		LOG.info("EBP 프로퍼티 값을 가져온다.");
		
		/* EBP 프로퍼티 값을 가져온다. */
		portalDiv = BizboxAProperties.getProperty("BizboxA.Cust.ebpYn");
		
		LOG.info("EBP 프로퍼티 값을 가져옴" + portalDiv);
				
		/* 추후 t_co_portal > portal_div 컬럼에 ebp 값이 들어갈지 안갈지를 협의 필요 */		
		//portalDiv = portalInfo.get("portalDiv").toString();
		
		/* EBP 프로퍼티 값이 없다면 기존 userMain.do 경로로 리다이렉트 한다. */
		if(portalDiv.equals("Y")){
			mv.setViewName("/main/userEbpMain");
			
			params.put("portalId", portalInfo.get("portalId"));
			
			String loginId = loginVO.getId();
			
			if(loginId.equals("todcode")) {
			
				params.put("portalId", "2");
			
			}else if(loginId.equals("cjrain")) {
				
				params.put("portalId", "3");
			
			}else if(loginId.equals("blip")) {
			
				params.put("portalId", "4");
			
			}else if(loginId.equals("Pong1233")) {
			
				params.put("portalId", "5");
			
			}
			
			LOG.info("포털 상세 정보값 조회를 한다.");
						
			@SuppressWarnings("unchecked")
			Map<String, Object> portletCloudInfo = (Map<String, Object>) commonSql.select("PortalManageDAO.selectportletCloudInfo", params);
			
			if(portletCloudInfo != null){
				mv.addObject("portalHeight", portletCloudInfo.get("portalHeight"));
				mv.addObject("portletInfo", portletCloudInfo.get("portletInfo"));
				
				LOG.info("개인 포털 설정 정보를 가져온다.");
				@SuppressWarnings({ "unchecked" })
				List<Map<String,Object>> portletUserSetList = commonSql.list("PortalManageDAO.selectPortletUserSetList", params);
				
				if(portletUserSetList != null){
					mv.addObject("portletUserSetList", JSONArray.fromObject(portletUserSetList));	
				}
				
			}else{
				mv.addObject("portalHeight", "");
				mv.addObject("portletInfo", "");
			}				
			
		}else{
			
			mv.setViewName("redirect:/userMain.do");	
			return mv;
	
		}
		
		mv.addObject("portalId", portalInfo.get("portalId"));
		mv.addObject("portalDiv", portalInfo.get("portalDiv"));	
		
		//포틀릿 갱신주기
		List<Map<String, String>> mentionOption = CommonCodeUtil.getCodeList("cycleTime");
		if(mentionOption != null && mentionOption.size() > 0){
			if(mentionOption.get(0) == null || mentionOption.get(0).get("CODE") == null){
				mv.addObject("portletCycleTime", null);
			}else{
				mv.addObject("portletCycleTime",mentionOption.get(0).get("CODE"));
			}
		}

		LOG.info("개인정보 표시 옵션을 가져와 셋팅한다.");
		// 개인정보 표시 옵션 가져와 셋팅
		if (commonOptionManageService.getCommonOptionValue(loginVO.getGroupSeq(), loginVO.getCompSeq(), "cm700").equals("1")) {
			mv.addObject("optionValue", "1");
			String empPathNm = getEmpPathNm();
			mv.addObject("empPathNm", empPathNm);
		}

		mv.addObject("topType", "main");

		params.put("groupSeq", loginVO.getGroupSeq());
		LOG.info("그룹정보를 가져온다.");
		Map<String, Object> groupMap = orgChartService.getGroupInfo(params);
		mv.addObject("groupMap", groupMap);

		LOG.info("EmpCheckWorkYn 값을 가져온다.");

		String empCheckWorkYn = (String) commonSql.select("Empmanage.getEmpCheckWorkYn", params);
		
		if(empCheckWorkYn == null){
			mv.setViewName("redirect:/uat/uia/egovLoginUsr.do");
			return mv;
		}
		
		if (!empCheckWorkYn.equals("") && empCheckWorkYn.equals("Y")) {
			// 출퇴근 정보
			params.put("loginId", loginVO.getId());
			LOG.info("출퇴근 정보를 가져온다.");
			Map<String, Object> userAttInfo = (Map<String, Object>) commonSql.select("PortalManageDAO.selectUserAttPortalInfo", params);
			mv.addObject("userAttInfo", userAttInfo);

			// 출퇴근 옵션 정보
			if(!portalDiv.equals("cloud")){
				LOG.info("출퇴근 옵션 정보를 가져온다.");
				Map<String, Object> userAttOptionInfo = (Map<String, Object>) commonSql.select("PortalManageDAO.selectUserAttOptionInfo", params);
				if (userAttOptionInfo != null) {
					mv.addObject("userAttOptionInfo", userAttOptionInfo);
				}
			}
			mv.addObject("empCheckWorkYn", "Y");
		} else {
			mv.addObject("empCheckWorkYn", "N");
		}

		// 부서 정보
		params.put("deptSeq", loginVO.getOrgnztId());
		LOG.info("부서정보를 가져온다.");
		List<Map<String, Object>> positionList = orgChartService.selectUserPositionList(params);

		// eaType 셋팅
		String eaType = loginVO.getEaType();
		if (eaType == null || eaType == "") {
			eaType = "eap";
		}

		if (eaType.equals("ea")) {
			params.put("eaType", eaType);
			positionList = orgChartService.selectUserPositionList(params);
		}

		params.remove("deptSeq");

		JSONArray positionListJson = JSONArray.fromObject(positionList);

		if (positionList.size() > 0) {
			mv.addObject("positionInfo", positionListJson.get(0));
		}

		/** 사용자 프로필 */
		mv.addObject("loginVO", loginVO);

		/** 사용자 프로필 */
		params.put("compSeq", loginVO.getCompSeq());
		params.put("groupSeq", loginVO.getGroupSeq());
		params.put("langCode", loginVO.getLangCode());

		params.put("startNum", "0");
		params.put("endNum", "1");
		
		LOG.info("사용자 정보를 조회");

		Map<String, Object> userInfo = (Map<String, Object>) commonSql.select("EmpManage.selectEmp", params);

		if (userInfo != null) {
			mv.addObject("picFileId", userInfo.get("picFileId"));
		} else {
			mv.setViewName("redirect:/uat/uia/actionLogout.do");
			return mv;
		}
		
		LOG.info("하단 푸터 이미지 조회");

		/** 메인 하단 푸터 이미지,Text 가져오기 */
		if (!loginVO.getUserSe().equals("MASTER")) {
			// 메인 하단 푸터 이미지.
			params.put("imgType", "IMG_COMP_FOOTER");
			Map<String, Object> imgMap = compManageService.getOrgImg(params);
			mv.addObject("imgMap", imgMap);

			// 메인 하단 푸터 텍스트
			params.put("imgType", "TEXT_COMP_FOOTER");
			Map<String, Object> txtMap = compManageService.getOrgImg(params);
			mv.addObject("txtMap", txtMap);
		}
		
		/*
		if(!portalDiv.equals("cloud")){
			// 자동출퇴근 메세지 가져오기
			if (request.getSession().getAttribute("empAttCheckFlag") != null && request.getSession().getAttribute("empAttCheckFlag").toString().equals("Y")) {
				mv.addObject("empAttCheckFlag", request.getSession().getAttribute("empAttCheckFlag"));
				request.getSession().removeAttribute("empAttCheckFlag");
			}			
		}
		*/
		
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
		
		mv.addObject("mainPortalYn", "Y");
		mv.addObject("displayPositionDuty", displayPositionDuty);
		
		if(CloudConnetInfo.getBuildType().equals("cloud")){
			mv.addObject("profilePath", "/upload/" + loginVO.getGroupSeq() + "/img/profile/" + loginVO.getGroupSeq());
		}else{
			mv.addObject("profilePath", "/upload/img/profile/" + loginVO.getGroupSeq());
		}
		
		//메인포털 사용안함
		if(BizboxAProperties.getCustomProperty("BizboxA.Cust.edmsUseYn").equals("N")){
			mv.addObject("callAllPopup", "N");	
		}else {
			mv.addObject("callAllPopup", "Y");	
		}			

		return mv;
		
	}
	
	
	@RequestMapping("/ebpUserMain.do")
	public ModelAndView ebpUserMain(@RequestParam Map<String, Object> params, HttpServletRequest request)
			throws Exception {

		ModelAndView mv = new ModelAndView();
		
		if(request.getSession().getAttribute("loginVO") == null) {
	    	
			mv.setViewName("redirect:/uat/uia/actionLogout.do");	
			return mv;
		}
		
		LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser();
		String viewName = "";
		
		if(loginVO.getId().toLowerCase().equals("todcode")) {
			viewName = BizboxAProperties.getCustomProperty("BizboxA.Cust.ebpCEOMain").equals("99") ? "/ebp/Views/main/ebpCEOMain.html" : BizboxAProperties.getCustomProperty("BizboxA.Cust.ebpCEOMain");
		}else if(loginVO.getId().toLowerCase().equals("pong1233")) {
			viewName = BizboxAProperties.getCustomProperty("BizboxA.Cust.ebpExpMain").equals("99") ? "/ebp/Views/main/ebpExpMain.html" : BizboxAProperties.getCustomProperty("BizboxA.Cust.ebpExpMain");
		}else if(loginVO.getId().toLowerCase().equals("cjrain")) {
			viewName = BizboxAProperties.getCustomProperty("BizboxA.Cust.ebpHrMain").equals("99") ? "/ebp/Views/main/ebpHrMain.html" : BizboxAProperties.getCustomProperty("BizboxA.Cust.ebpHrMain");
		}else {
			viewName = BizboxAProperties.getCustomProperty("BizboxA.Cust.ebpSaleMain").equals("99") ? "/ebp/Views/main/ebpSaleMain.html" : BizboxAProperties.getCustomProperty("BizboxA.Cust.ebpSaleMain");
		}
		
		mv.setViewName("redirect:" + viewName);
		
		return mv;
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping("/insertComeLeaveEventApi.do")
	public ModelAndView insertComeLeaveEventApi(@RequestParam Map<String, Object> params, HttpServletRequest request) throws Exception {

		ModelAndView mv = new ModelAndView();

		LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser();
		
		if(loginVO != null) {

			String jsonParam =	 "{\"empSeq\":\"" + loginVO.getUniqId() + "\", \"deptSeq\":\"" + loginVO.getOrgnztId() + "\", \"compSeq\":\"" + loginVO.getOrganId() + "\", \"groupSeq\":\"" + loginVO.getGroupSeq() + "\", \"connectExtIp\":\"" + loginVO.getIp() + "\", \"connectIp\":\"" + loginVO.getIp() + "\", \"gbnCode\":\"" + params.get("gbnCode").toString() + "\"}";
			String apiUrl = CommonUtil.getApiCallDomain(request) + "/attend/external/api/gw/insertComeLeaveEvent";

			JSONObject jsonObject2 = JSONObject.fromObject(JSONSerializer.toJSON(jsonParam));
			HttpJsonUtil httpJson = new HttpJsonUtil();
			@SuppressWarnings("static-access")
			String empAttCheck = httpJson.execute("POST", apiUrl, jsonObject2);
			
			Map<String, Object> map = new HashMap<String, Object>();
			ObjectMapper mapper = new ObjectMapper();
			map = mapper.readValue(empAttCheck, new TypeReference<Map<String, String>>(){});			
			mv.addAllObjects(map);			
		}

		mv.setViewName("jsonView");

		return mv;
	}
	
	
	// path traversal 취약점 보완을 위함.
	@RequestMapping("/auth")
	public void securityAuth(HttpServletRequest servletRequest, HttpServletResponse servletResponse) {					

		//세션 미생성시 실패처리
		LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser();
		if(loginVO == null) {
			servletResponse.setStatus(404);
			org.apache.log4j.Logger.getLogger( BizboxMainController.class ).info("세션이 존재하지 않습니다. loginVO : " + loginVO);	
			return;
		}
		
		String path = servletRequest.getHeader("X-Original-URI");
		org.apache.log4j.Logger.getLogger( BizboxMainController.class ).debug( "path : " + path );
		if(!whiteListManager.isInitialized()) {
			servletResponse.setStatus(404);
			org.apache.log4j.Logger.getLogger( BizboxMainController.class ).info("화이트 리스트 초기화가 아직 이루어지지 않았습니다. path : " + path);	
			return;
		}
		
		//화이트 리스트 항목이 정의되어 있지 않기 때문에 무조건 성공으로 판단.
		if(!(whiteListManager.getWhiteList().size() > 0)) {
			servletResponse.setStatus(200);
			return;
		}
		
		//path 값이 없으면 알 수 없는 형태이기 때문에 성공으로 판단.
		if (StringUtils.isEmpty(path)) {
			servletResponse.setStatus(200);
			org.apache.log4j.Logger.getLogger( BizboxMainController.class ).warn("URI 값이 header( KEY : X-Original-URI )에 들어오지 않고 있습니다.");
			return;
		}
		
		boolean isWhite = false;
		for(WhiteListItem item : whiteListManager.getWhiteList()) {
			if(EgovStringUtil.isEmpty(item.getValue())) {
				continue;
			}
			
			switch(item.getType()) {
				case NORMAL : {
					//요청 값이 화이트리스트에 있는 값으로 시작하고, 
					//상위 디렉토리로 이동하는 패스 값(..)이 없을 경우 허용.
					if (path.startsWith(item.getValue())
							&& !path.contains("..")		
							) {
						isWhite = true;
					}
					break;
				}
				case REGEX : {
					if(path.matches(item.getValue())) {
						isWhite = true;
					}
					break;
				}
			}
			
			if(isWhite) {
				break;
			}
		}
		
		if(isWhite) {
			servletResponse.setStatus(200);
		}else {
			servletResponse.setStatus(404);
		}
		org.apache.log4j.Logger.getLogger( BizboxMainController.class ).info("path : " + path);
	} 
	
	@RequestMapping("/wehagoLink.do")
	public ModelAndView wehagoLink(@RequestParam Map<String, Object> params, HttpServletRequest request) throws Exception {
		
		ModelAndView mv = new ModelAndView();
		
		String getTokenUrl = "http://dev.api0.wehago.com/get_token/?url=";
		String subApiUrl = "/auth/temporarily/createToken";
		
		String serverToken = "umPqVKVKBufX8R8VYkhXJp6wo5po82";		
		
		String tokenSign = "";
		String wehagoId = (String)params.get("wehagoId");
		
		if(wehagoId == null) {
			wehagoId = "test0503";
		}
		
		tokenSign = AESCipher.AES256_Encode(wehagoId, StringUtils.rightPad(serverToken, 32, "0"));
		
		/*
		String device_id = "10ac0b6f";
		String token_sign = tokenSign;
		String cno = "13718";
		String software_name = "bizbox";
		*/
		
		String url = getTokenUrl + subApiUrl;
		
		JSONObject a = getPostJSON(url, "");
		
        String resToken = (String) a.get("token");
        String signature = subApiUrl + a.get("cur_date") + resToken;
		        
        MessageDigest localMessageDigest = MessageDigest.getInstance("SHA-256");
        localMessageDigest.update(signature.getBytes("UTF-8"));
        byte[] paramByte = localMessageDigest.digest();
        signature = DatatypeConverter.printBase64Binary(paramByte);   
		
        mv.addObject("signature", signature);
        mv.setViewName("/main/wehago/wehagoLogin");
        
		return mv;
	}
	
	@RequestMapping("/getWehagoServiceInfo.do")
	public ModelAndView getWehagoServiceInfo(@RequestParam Map<String, Object> params, HttpServletRequest request) throws Exception {
		
		ModelAndView mv = new ModelAndView();

		String token = (String) params.get("token");
		String wehagoId = (String) params.get("wehagoId");
		String cno = (String) params.get("cno");
		String serviceCd = (String) params.get("serviceCd");
		String timeStamp = (String) commonSql.select("MainManageDAO.getTimeStamp", params);
		
		Properties prop = new Properties();
		String aes256Key = WEHAGO_aes256Key == null ? (String)prop.getProperty("key") : "534e8d1a72c34625b7b7cc6d68f75731";//하드코드된 중요정보: 암호화 키
		
		String domain = (String)params.get("domain");
		domain = new String(Base64.encodeBase64(domain.getBytes("UTF-8")), "UTF-8");
		
		
		JSONObject json = new JSONObject();
		JSONObject serviceParam = new JSONObject();
		
		json.put("sso_token", token);
		json.put("portal_id", wehagoId);
		json.put("company_no", cno);
		json.put("service_code", serviceCd);
		json.put("timestamp", timeStamp);
		json.put("service_param", serviceParam);
		
		
		String securityParam = AES256_Encrypt_ECB(aes256Key, json.toString());
		String softwareName = (String) params.get("softwareName");
		
		mv.addObject("security_param", securityParam);
		mv.addObject("domain", domain);
		mv.addObject("softwareName", softwareName);
		
        mv.setViewName("jsonView");
        
		return mv;
	}
	
	public static String AES256_Encrypt_ECB(String key, String str) {

		 String encStr = "";

		 try {
			 if (key == null || key.equals("")) {//하드코드된 중요정보: 암호화 키
		    		key = "534e8d1a72c34625b7b7cc6d68f75731";
		    	    Properties prop = new Properties();
		    	    key = key == null ? (String)prop.getProperty("key") : "534e8d1a72c34625b7b7cc6d68f75731";
		    	}
		 byte[] keyData = key.getBytes();
		 byte[] text = str.getBytes("UTF-8");

		 // AES/ECB/PKCS5Padding
		 Cipher cipher = Cipher.getInstance("AES/ECB/PKCS5Padding");
		 cipher.init(Cipher.ENCRYPT_MODE, new SecretKeySpec(keyData, "AES"));

		 // 암호화
		 byte[] encrypted = cipher.doFinal(text);
		 encStr = new String(Base64.encodeBase64(encrypted));
		 } catch (Exception e) {
			 CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
		 encStr = null;
		 }

		 return encStr;
		 }
	
	public static String AES256_Decrypt_ECB(String key, String enStr) {

		 String decStr = "";

		 try {
		 byte[] keyData = key.getBytes();
		 byte[] encText = Base64.decodeBase64(enStr.getBytes());

		 // AES/ECB/PKCS5Padding
		 Cipher cipher = Cipher.getInstance("AES/ECB/PKCS5Padding");
		 cipher.init(Cipher.DECRYPT_MODE, new SecretKeySpec(keyData, "AES"));

		 // 복호화
		 byte[] decrypted = cipher.doFinal(encText);
		 decStr = new String(decrypted, "UTF-8");
		 } catch (Exception e) {
			 CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
		 decStr = null;
		 }
		 
		 return decStr;
	}
	
	
	@SuppressWarnings("unchecked")
	@RequestMapping("/getSignature.do")
	public ModelAndView getSignature(@RequestParam Map<String, Object> params, HttpServletRequest request) throws NoSuchAlgorithmException, UnsupportedEncodingException {
		
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		
		LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser();
		
		if(request.getSession().getAttribute("loginVO") == null || loginVO == null) {	    	
			mv.setViewName("redirect:/uat/uia/actionLogout.do");	
			return mv;
		}
		
		params.put("empSeq", loginVO.getUniqId());
		params.put("compSeq", loginVO.getOrganId());
		Map<String, Object> wehagoUserInfo = (Map<String, Object>) commonSql.select("MainManageDAO.getWehagoUserInfo", params);
		mv.addAllObjects(wehagoUserInfo);
		
		if(wehagoUserInfo.get("cno").toString().equals("") || wehagoUserInfo.get("wehagoId").toString().equals("")) {
			return mv;
		}
		
		String getTokenUrl = "http://dev.api0.wehago.com/get_token/?url=";
		String subApiUrl = "/auth/temporarily/createToken";
		
		String serverToken = "umPqVKVKBufX8R8VYkhXJp6wo5po82";		
		
		String tokenSign = "";
		String wehagoId = (String) wehagoUserInfo.get("wehagoId");
		
		String aes256Key = StringUtils.rightPad(serverToken, 32, "0");
		tokenSign = AESCipher.AES256_Encode(wehagoId, aes256Key);
		
		/*
		String device_id = "10ac0b6f";
		String token_sign = tokenSign;
		String cno = (String) wehagoUserInfo.get("cno");
		String software_name = "bizbox";
		*/
		
		String url = getTokenUrl + subApiUrl;
		
		JSONObject a = getPostJSON(url, "");
		
        String resToken = (String) a.get("token");
        String signature = subApiUrl + a.get("cur_date") + resToken;
		        
        MessageDigest localMessageDigest = MessageDigest.getInstance("SHA-256");
        localMessageDigest.update(signature.getBytes("UTF-8"));
        byte[] paramByte = localMessageDigest.digest();
        signature = DatatypeConverter.printBase64Binary(paramByte);   
		
        mv.addObject("wehagoId", wehagoId);
        mv.addObject("tokenSign", tokenSign);
        mv.addObject("signature", signature);
		
		return mv;
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping("/getFindPasswdEmpList.do")
	public ModelAndView getFindPasswdEmpList(@RequestParam Map<String, Object> params, HttpServletRequest request) throws Exception {

		ModelAndView mv = new ModelAndView();

		LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser();

		if (loginVO == null) {
			mv.setViewName("redirect:/uat/uia/egovLoginUsr.do");
			return mv;
		}
		
		params.put("userSe", loginVO.getUserSe());
		params.put("empSeq", loginVO.getUniqId());
		params.put("deptSeq", loginVO.getOrgnztId());
		params.put("compSeq", loginVO.getOrganId());
		params.put("groupSeq", loginVO.getGroupSeq());
		params.put("langCode", loginVO.getLangCode());
		params.put("eaType", loginVO.getEaType());
		
		//패스워드 초기화 요청리스트 조회
		List<Map<String, Object>> findPasswdEmpList = (List<Map<String, Object>>) commonSql.list("OrgAdapterManage.selectFindPasswdEmpList", params);
		mv.addObject("findPasswdEmpList", JSONArray.fromObject(findPasswdEmpList));
		
		mv.setViewName("jsonView");
		return mv;
	}
	
	@RequestMapping("/makeSecretKey.do")
	public ModelAndView makeSecretKey(@RequestParam Map<String, Object> params, HttpServletRequest request) throws Exception {

//		Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();

		ModelAndView mv = new ModelAndView();
		LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser();
		SimpleDateFormat dateFormat = new SimpleDateFormat("yyyyMMddHHmmss");
		Date date = new Date();
		String currentTime = dateFormat.format(date);
		String secretKey = null;
		
		if (loginVO == null) {
			mv.setViewName("redirect:/uat/uia/egovLoginUsr.do");
			return mv;
		}
		
		secretKey = AESCipher.AES_Encode(currentTime + "▦" + loginVO.getGroupSeq() + "▦" + loginVO.getId());
//		//System.out.println("secretKey : " + secretKey);
//		//System.out.println("decoding secretKey : " + AESCipher.AES_Decode(secretKey));

		mv.setViewName("jsonView");
		mv.addObject("secretKey", secretKey);
		return mv;
	}
	
	public Map<String, Object> calcImgFileOrientation(File imageFile) {
		
		int orientation = 1; // 회전정보, 1. 0도, 3. 180도, 6. 270도, 8. 90도 회전한 정보 
		int width = 0; // 이미지의 가로폭
		int height = 0; // 이미지의 세로높이 
		int tempWidth = 0; // 이미지 가로, 세로 교차를 위한 임의 변수 
		Metadata metadata; // 이미지 메타 데이터 객체 
		Directory directory; // 이미지의 Exif 데이터를 읽기 위한 객체 
		JpegDirectory jpegDirectory; // JPG 이미지 정보를 읽기 위한 객체
		
		Map<String, Object> resultMap = new HashMap<>();
		
		try {
			metadata = ImageMetadataReader.readMetadata(imageFile);
			directory = metadata.getFirstDirectoryOfType(ExifIFD0Directory.class);
			jpegDirectory = metadata.getFirstDirectoryOfType(JpegDirectory.class);

			if(directory != null){
				orientation = directory.getInt(ExifIFD0Directory.TAG_ORIENTATION); // 회전정보
				width = jpegDirectory.getImageWidth(); // 가로
				height = jpegDirectory.getImageHeight(); // 세로
			}
			
			// 3. 변경할 값들을 설정한다.
		    AffineTransform atf = new AffineTransform();
		    //System.out.println("orientation: " + orientation);
		    switch (orientation) {
		    case 1:
		        break;
		    case 2: // Flip X
		    	atf.scale(-1.0, 1.0);
		    	atf.translate(-width, 0);
		        break;
		    case 3: // PI rotation 
		    	atf.translate(width, height);
		    	atf.rotate(Math.PI);
		        break;
		    case 4: // Flip Y
		    	atf.scale(1.0, -1.0);
		    	atf.translate(0, -height);
		        break;
		    case 5: // - PI/2 and Flip X
		    	atf.rotate(-Math.PI / 2);
		    	atf.scale(-1.0, 1.0);
		        break;
		    case 6: // -PI/2 and -width
		    	atf.translate(height, 0);
		    	atf.rotate(Math.PI / 2);
		        break;
		    case 7: // PI/2 and Flip
		    	atf.scale(-1.0, 1.0);
		    	atf.translate(-height, 0);
		    	atf.translate(0, width);
		    	atf.rotate(  3 * Math.PI / 2);
		        break;
		    case 8: // PI / 2
		    	atf.translate(0, width);
		    	atf.rotate(  3 * Math.PI / 2);
		        break;
		    default:break;
		    }
		    
		    switch (orientation) {
			case 5:
			case 6:
			case 7:
			case 8:
		        tempWidth = width;
		        width = height;
		        height = tempWidth;
				break;
			default:break;
			}
		    
		    resultMap.put("atf", atf);
		    resultMap.put("width", width);
		    resultMap.put("height", height);
		    resultMap.put("orientation", orientation);
		    
		    return resultMap;
			
		} catch (ImageProcessingException e) {
			//System.out.println("WebAttachFileController calcImgFileOrientation error: " + e.getMessage());
			e.printStackTrace();
			resultMap.put("orientation", 1);
			resultMap.put("width", 0);
			return resultMap;
			
		} catch (MetadataException e) {
			//System.out.println("WebAttachFileController calcImgFileOrientation error: " + e.getMessage());
			e.printStackTrace();
			resultMap.put("orientation", 1);
			resultMap.put("width", 0);
			return resultMap;
			
		} catch (IOException e) {
			//System.out.println("WebAttachFileController calcImgFileOrientation error: " + e.getMessage());
			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
			resultMap.put("orientation", 1);
			resultMap.put("width", 0);
			return resultMap;
		}
	}
	
//	public File multipartToFile(MultipartFile multipart) {
//		
//		try {
//			
//			File convFile = new File( multipart.getOriginalFilename());
//			convFile.createNewFile();
//			FileOutputStream fos = new FileOutputStream(convFile);
//			fos.write(multipart.getBytes());
//			fos.close();
//			return convFile;
//		}catch(IllegalStateException e) {
//			//System.out.println("multipartToFile error: " + e.getMessage());
//			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
//		}catch(IOException e) {
//			//System.out.println("multipartToFile error: " + e.getMessage());
//			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
//		}
//		
//		return null;
//	}
	
	public void saveRotateImgFile(File imgFile, Map<String, Object> rotateImgInfoMap, String saveFilePath, String fileExtsn) {
		
		try {
			
			AffineTransform atf = (AffineTransform) rotateImgInfoMap.get("atf");
			int width = (int) rotateImgInfoMap.get("width");
			int height = (int) rotateImgInfoMap.get("height");
			
			BufferedImage image = ImageIO.read(imgFile);
			final BufferedImage afterImage = new BufferedImage(width, height, image.getType());
			final AffineTransformOp rotateOp = new AffineTransformOp(atf, AffineTransformOp.TYPE_BILINEAR);
			final BufferedImage rotatedImage = rotateOp.filter(image, afterImage);
			Iterator<ImageWriter> iter = ImageIO.getImageWritersByFormatName(fileExtsn);
		    ImageWriter writer = iter.next();
		    ImageWriteParam iwp = writer.getDefaultWriteParam();
		    iwp.setCompressionMode(ImageWriteParam.MODE_EXPLICIT);
		    iwp.setCompressionQuality(1.0f);

		    //System.out.println("회전 후 저장");
		    // 4. 회전하여 생성할 파일을 만든다.
		    File outFile = new File(saveFilePath);
		    
			if (!outFile.getParentFile().exists()) {
				outFile.getParentFile().mkdirs();
	    	}
		    FileImageOutputStream fios = new FileImageOutputStream(outFile);


		    // 5. 원본파일을 회전하여 파일을 저장한다.
		    writer.setOutput(fios);
		    writer.write(null, new IIOImage(rotatedImage ,null,null),iwp);
		    fios.close();
		    writer.dispose();

	    
		} catch (IOException e) {
			//System.out.println("WebAttachFileController saveRotateImgFileAndReadFile error: " + e.getMessage());
			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
		}
		
	}
	
	
	@SuppressWarnings("unchecked")
	@RequestMapping("/checkUserInfo.do")
	public ModelAndView checkUserInfo(@RequestParam Map<String, Object> params, HttpServletRequest request) throws Exception {

		//SK toktok 모바일 앱 연동용 사용자계정 정보 체크 API - SK리츠운용
		
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		
		if (params.get("GWP_EMP_ID") == null || params.get("GWP_EMP_ID").equals("") || params.get("GWP_EMP_PASSWD") == null || params.get("GWP_EMP_PASSWD").equals("")) {
			mv.addObject("resultCode", "401");
			mv.addObject("resultMessage", "사용자 정보조회 실패");
			return mv;
		}

		Map<String, Object> param = new HashMap<String, Object>();
		param.put("loginId", params.get("GWP_EMP_ID"));
		param.put("loginPasswd", CommonUtil.passwordEncrypt(params.get("GWP_EMP_PASSWD").toString()));
		param.put("skFlag", "Y");
		Map<String, Object> custInfo = (Map<String, Object>) commonSql.select("EmpManage.selectEmpInfoByIdPwd", param);

		if (custInfo != null) {
			mv.addObject("resultCode", "200");
			mv.addObject("resultMessage", "사용자 정보조회 성공");
			return mv;

		} else {
			mv.addObject("resultCode", "401");
			mv.addObject("resultMessage", "사용자 정보조회 실패");
			return mv;
		}
	}

}
