package egovframework.com.uat.uia.web;
import java.io.File;
import java.io.PrintWriter;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import cloud.CloudConnetInfo;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.apache.commons.mail.DefaultAuthenticator;
import org.apache.commons.mail.HtmlEmail;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.support.RequestContextUtils;

import com.google.common.base.Charsets;
import com.google.common.io.Files;

import api.common.model.EventRequest;
import bizbox.orgchart.service.vo.LoginVO;
import egovframework.com.cmm.ComDefaultCodeVO;
import egovframework.com.cmm.EgovComponentChecker;
import egovframework.com.cmm.EgovMessageSource;
import egovframework.com.cmm.annotation.IncludedInfo;
import egovframework.com.cmm.service.EgovCmmUseService;
import egovframework.com.cmm.util.EgovUserDetailsHelper;
import egovframework.com.uat.uia.service.EgovLoginService;
import egovframework.com.utl.fcc.service.EgovStringUtil;
import egovframework.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;
import main.web.BizboxAMessage;
import neos.cmm.db.CommonSqlDAO;
import neos.cmm.systemx.commonOption.service.CommonOptionManageService;
import neos.cmm.systemx.comp.service.CompManageService;
import neos.cmm.systemx.emp.service.EmpManageService;
import neos.cmm.systemx.etc.service.LogoManageService;
import neos.cmm.systemx.group.service.GroupManageService;
import neos.cmm.systemx.img.service.FileUploadService;
import neos.cmm.systemx.orgchart.service.OrgChartService;
import neos.cmm.util.AESCipher;
import neos.cmm.util.BizboxAProperties;
import neos.cmm.util.CommonUtil;
import neos.cmm.util.ReturnPath;
import neos.cmm.systemx.orgAdapter.service.OrgAdapterService;
import neos.cmm.systemx.orgAdapter.dao.OrgAdapterDAO;
import api.common.service.EventService;

/**
 * 일반 로그인, 인증서 로그인을 처리하는 컨트롤러 클래스
 * @author 공통서비스 개발팀 박지욱
 * @since 2009.03.06
 * @version 1.0
 * @see
 *
 * <pre>
 * << 개정이력(Modification Information) >>
 *
 *   수정일      수정자          수정내용
 *  -------    --------    ---------------------------
 *  2009.03.06  박지욱          최초 생성
 *  2011.8.26	정진오			IncludedInfo annotation 추가
 *  2011.09.07  서준식          스프링 시큐리티 로그인 및 SSO 인증 로직을 필터로 분리
 *  2011.09.25  서준식          사용자 관리 컴포넌트 미포함에 대한 점검 로직 추가
 *  2011.09.27  서준식          인증서 로그인시 스프링 시큐리티 사용에 대한 체크 로직 추가
 *  2011.10.27  서준식          아이디 찾기 기능에서 사용자 리름 공백 제거 기능 추가
 *  2013.01.23  문의형          SSO관련 로그아웃 기능 추가
 *  </pre>
 */

@Controller
public class EgovLoginController {

//    @Resource(name="MobileWebApprovalService")
//	private MobileWebApprovalService mobileWebApprovalService;
//

	@Resource(name = "OrgAdapterService")
	private OrgAdapterService orgAdapterService;

	@Resource(name = "OrgAdapterDAO")
    private OrgAdapterDAO orgAdapterDAO;

	/** EgovLoginService */
	@Resource(name = "loginService")
    private EgovLoginService loginService;

	/** EgovCmmUseService */
	@Resource(name="EgovCmmUseService")
	private EgovCmmUseService cmmUseService;


	/** EgovMessageSource */
    @Resource(name="egovMessageSource")
    EgovMessageSource egovMessageSource;

    @Resource(name="LogoManageService")
	private LogoManageService logoManageService;

    @Resource(name = "commonSql")
	private CommonSqlDAO commonSql;

    @Resource(name = "FileUploadService")
    private FileUploadService fileUploadService;

    @Resource(name = "GroupManageService")
	private GroupManageService groupManageService;

    @Resource(name = "CompManageService")
	private CompManageService compManageService;

    @Resource(name="CommonOptionManageService")
    private CommonOptionManageService commonOptionManageService;

    @Resource(name="OrgChartService")
	OrgChartService orgChartService;

    @Resource(name="EmpManageService")
    private EmpManageService empManageService;
    
	@Resource(name="EventService")
	EventService eventService;    

	/** log */
    protected static final Log LOG = LogFactory.getLog(EgovLoginController.class);

	/**
	 * 로그인 화면으로 들어간다
	 * @param vo - 로그인후 이동할 URL이 담긴 LoginVO
	 * @return 로그인 페이지
	 * @exception Exception
	 */

    @IncludedInfo(name="로그인", listUrl="/uat/uia/egovLoginUsr.do", order = 10, gid = 10)
    @RequestMapping(value="/uat/uia/egovLoginUsr.do")
    public String loginUsrView(@ModelAttribute("loginVO") LoginVO loginVO,
            HttpServletRequest request,
            HttpServletResponse response,
            ModelMap model,
            @RequestParam Map<String,Object> paramMap)
            throws Exception {
    	
    	model.addAttribute("LoginParamEncType", BizboxAProperties.getCustomProperty("BizboxA.Cust.LoginParamEncType"));	
		model.addAttribute("securityEncLevel", this.getSecurityEncLevel());    	
    	
    	// 로그인 페이지의 패스워드 암호화 key iv값을 서버에서 동적으로 만들어준다.
    	String encKey = "";
    	String encIv = "";
    	
    	Map<String, ?> passChangeCheck = RequestContextUtils.getInputFlashMap(request);
        String selectPosition = "N";
        String empSeq = "";
        String passCheck = "N";
        
        if(passChangeCheck != null) {

        	if(passChangeCheck.get("selectPosition") != null && !passChangeCheck.get("selectPosition").equals("N")) {
        		selectPosition = "Y";
        		empSeq = passChangeCheck.get("empSeq").toString();
            }

        	if(passChangeCheck.get("passwdChange") != null && !passChangeCheck.get("passwdChange").equals("N")) {
            	passCheck = "Y";
            }
        }

    	if(paramMap.get("AccessIpFailMsg") == null && paramMap.get("ScTargetEmpSeq") == null && selectPosition.equals("N") && passCheck.equals("N") && (EgovUserDetailsHelper.isAuthenticated() || request.getSession().getAttribute("loginVO") != null)) {
    		return "redirect:/uat/uia/actionLogout.do?target=login";
    	}
    	
    	request.getSession().setAttribute("forceLogoutYn", "N");

    	String serverName = request.getServerName();
    	String loginType = "A";
        request.getSession().setAttribute("firstLoginYn", "Y");
        request.getSession().setAttribute("firstGnbRenderTp", "WEB");

    	String buildType = CloudConnetInfo.getBuildType();
    	Map<String, Object> jedisMp = null; 

    	if(buildType.equals("cloud")){
    		
    		String baseCloudDomain = BizboxAProperties.getProperty("BizboxA.cloud.default.url");
    		baseCloudDomain = baseCloudDomain.replace("http://", "");
    		
    		if(baseCloudDomain.equals(serverName)){
    			model.remove("groupSeq");
    			model.addAttribute("groupDisplayName", "BizBox Alpha");
    			model.addAttribute("loginType", loginType);
    			model.addAttribute("securityEncLevel", this.getSecurityEncLevel());
    			return "/neos/NeosCloudLogin";
    		}else{
    			jedisMp = CloudConnetInfo.getParamMapByDomain(serverName);
    			if(jedisMp.get("groupSeq") == null) {
    				return "redirect:" + BizboxAProperties.getProperty("BizboxA.cloud.default.url");
    			}else {
    				model.addAttribute("groupSeq", jedisMp.get("groupSeq"));
    			}
    		}
    	}else {
    		jedisMp = CloudConnetInfo.getParamMapByDomain(serverName);
    	}

        paramMap.put("groupSeq", jedisMp.get("groupSeq"));

        paramMap.put("domain", serverName);

        /** 로그인 타입 및 회사 관련 이미지 가져오기 */

        Map<String,Object> compInfo = logoManageService.getDomainCompInfo(paramMap);
        Map<String, Object> groupMap = groupManageService.getGroupInfo(paramMap);

        //도메인 리다이렉트 처리
        if(!CloudConnetInfo.getBuildType().equals("cloud") && compInfo == null && groupMap != null && groupMap.get("domainRedirectYn") != null && groupMap.get("domainRedirectYn").equals("Y")) {
        	
        	String gwUrl = groupMap.get("gwUrl").toString();
        	
        	if(!gwUrl.contains(serverName)) {
        		
        		String validIp = "^([1-9]|[1-9][0-9]|1[0-9][0-9]|2[0-4][0-9]|25[0-5])(\\.([0-9]|[1-9][0-9]|1[0-9][0-9]|2[0-4][0-9]|25[0-5])){3}$";
        		  
        		  if (Pattern.matches(validIp, serverName)) {
        			  return "redirect:" + gwUrl;	  
        		  }
        	}
        }

        Map<String, Object> clogoMap = null;
        Map<String, Object> cbannerMap = null;
        Map<String, Object> ctxtMap = null;
        Map<String, Object> glogoMap = null;
        Map<String, Object> gbannerMap = null;
        Map<String, Object> gtxtMap = null;

        String redirectMsg = "N";
        
        if(request.getSession().getAttribute("maxSessionOut") != null) {
        	redirectMsg = request.getSession().getAttribute("maxSessionOut").toString();
        	request.getSession().removeAttribute("maxSessionOut");
        }

        if(paramMap.get("AccessIpFailMsg") != null) {
    		model.addAttribute("AccessIpFailMsg", "Y");
    	}else if(redirectMsg.equals("Y")) {
    		model.addAttribute("redirectMsg", "중복 로그인으로 인해 로그아웃 처리되었습니다.");
    	}

        String gwDomain = groupMap.get("gwUrl") + "";
        if(gwDomain.indexOf("http://") != -1) {
        	gwDomain = gwDomain.replace("http://", "");}
		if(gwDomain.indexOf("https://") != -1) {
			gwDomain = gwDomain.replace("https://", "");}
		if(gwDomain.indexOf(":") != -1) {
			gwDomain = gwDomain.substring(0, gwDomain.indexOf(":"));}

        String groupSeq = jedisMp.get("groupSeq") == null ? "" : jedisMp.get("groupSeq").toString();

        String nativeLangCode = "kr";
        
        if(groupMap != null){
        	groupSeq = groupMap.get("groupSeq").toString();
        	nativeLangCode = groupMap.get("nativeLangCode") == null ? "kr" : groupMap.get("nativeLangCode").toString();
        }
        
        request.getSession().setAttribute("nativeLangCode", nativeLangCode);

        //로그인 타입 및 로그인 이미지 지정
        //그룹접속정보 와 회사도메인(comp_domain)이 일치하면 그룹의 loginType으로 설정
        //불일치시 해당 회사의 loginType으로 설정.
        //loginType존재하지 않을시 기본 A타입으로 지정.
        if(compInfo != null && compInfo.get("compDomain") != null && !compInfo.get("compDomain").toString().equals("") && compInfo.get("compDomain").toString().indexOf(":") != -1){
        	compInfo.put("compDomain", compInfo.get("compDomain").toString().substring(0, compInfo.get("compDomain").toString().indexOf(":")));
        }

        //커스텀 로그인페이지
        String custLogonHtmlPath = BizboxAProperties.getProperty("BizboxA.custLogonHtmlPath");
        String custLogonHtml = "";

        if(!custLogonHtmlPath.equals("99")) {
        	custLogonHtml = Files.toString(new File(custLogonHtmlPath), Charsets.UTF_8);
        }

        //커스텀 스크립트
        String custLogonHtmlAppendPath = BizboxAProperties.getProperty("BizboxA.custLogonHtmlAppendPath");
        String custLogonHtmlAppend = "";

        if(!custLogonHtmlAppendPath.equals("99")) {
        	custLogonHtmlAppend = Files.toString(new File(custLogonHtmlAppendPath), Charsets.UTF_8);
        }

        model.addAttribute("custLogonHtmlAppend", custLogonHtmlAppend);

        if(!custLogonHtml.equals("")) {
        	model.addAttribute("custLogonHtml", custLogonHtml);
        	model.addAttribute("loginType", "CUST");
        }else if(compInfo == null || compInfo.get("compDomain").toString().equals(gwDomain) || compInfo.get("compDomain").toString().equals("")){

        	if(groupMap != null && groupMap.get("loginType") != null && !groupMap.get("loginType").toString().equals("")) {
        		loginType = groupMap.get("loginType").toString();
        	}

        	paramMap.put("imgType", "IMG_COMP_LOGIN_LOGO_" + loginType);
         	paramMap.put("compSeq", groupSeq);
         	glogoMap = compManageService.getOrgImg(paramMap);

         	paramMap.put("imgType", "IMG_COMP_LOGIN_BANNER_" + loginType);
         	gbannerMap = compManageService.getOrgImg(paramMap);

         	paramMap.put("imgType", "TEXT_COMP_LOGIN_" + loginType);
         	gtxtMap = compManageService.getOrgImg(paramMap);

         	String logoPath = "";
         	String bnPath = "";


         	if(glogoMap != null) {
         		logoPath = glogoMap.get("orgPath") + "IMG_COMP_LOGIN_LOGO_" + loginType + "_" + groupSeq + "." + glogoMap.get("file_extsn");
         	}
         	if(gbannerMap != null) {
         		bnPath = gbannerMap.get("orgPath") + "IMG_COMP_LOGIN_BANNER_" + loginType + "_" + groupSeq + "." + gbannerMap.get("file_extsn");
         	}

         	model.addAttribute("logoPath", logoPath);
         	model.addAttribute("bnPath", bnPath);
         	model.addAttribute("logoMap", glogoMap);
    		model.addAttribute("baMap", gbannerMap);
    		model.addAttribute("txtMap", gtxtMap);
    		model.addAttribute("loginType", loginType);
        }
        else{
        	if(!EgovStringUtil.isEmpty(compInfo.get("loginType")+"")) {
        		loginType = compInfo.get("loginType").toString();
        	}
        	else {
        		loginType = "A";	//기본값
        	}

        	paramMap.put("imgType", "IMG_COMP_LOGIN_LOGO_" + loginType);
        	paramMap.put("compSeq", compInfo.get("compSeq").toString());
        	clogoMap = compManageService.getOrgImg(paramMap);

        	paramMap.put("imgType", "IMG_COMP_LOGIN_BANNER_" + loginType);
        	cbannerMap = compManageService.getOrgImg(paramMap);

        	paramMap.put("imgType", "TEXT_COMP_LOGIN_" + loginType);
        	ctxtMap = compManageService.getOrgImg(paramMap);

        	String logoPath = "";
        	String bnPath = "";

        	if(clogoMap != null) {
        		logoPath = clogoMap.get("orgPath") + "IMG_COMP_LOGIN_LOGO_" + loginType + "_" + compInfo.get("compSeq").toString() + "." + clogoMap.get("file_extsn");
        	}
        	
        	if(cbannerMap != null) {
        		bnPath = cbannerMap.get("orgPath") + "IMG_COMP_LOGIN_BANNER_" + loginType + "_" + compInfo.get("compSeq").toString() + "." + cbannerMap.get("file_extsn");
        	}

        	model.addAttribute("logoPath", logoPath);
        	model.addAttribute("bnPath", bnPath);
        	model.addAttribute("logoMap", clogoMap);
    		model.addAttribute("baMap", cbannerMap);
    		model.addAttribute("txtMap", ctxtMap);
    		model.addAttribute("loginType", loginType);
        }

    	if(groupMap != null && groupMap.get("groupDisplayName") != null && !groupMap.get("groupDisplayName").toString().equals("")){
    		model.addAttribute("groupDisplayName", groupMap.get("groupDisplayName").toString());
    	}else{
    		model.addAttribute("groupDisplayName", "BizBox Alpha");
    	}

	    String userSe = request.getParameter("userSe")+"";
	    model.addAttribute("userSe", userSe);


    	if(EgovStringUtil.isEmpty(loginVO.getGroupSeq())) {

    		if (compInfo != null) {
    			loginVO.setGroupSeq(compInfo.get("groupSeq")+"");
    			request.getSession().setAttribute("loginGroupSeq", compInfo.get("groupSeq")+"");
    		}
    	}else{
    		request.getSession().setAttribute("loginGroupSeq", loginVO.getGroupSeq());
    	}

        if(passChangeCheck != null) {
        	if(passChangeCheck.get("selectPosition") != null && !passChangeCheck.get("selectPosition").equals("N")) {
        		selectPosition = "Y";
        		empSeq = passChangeCheck.get("empSeq") + "";
            }
        }

        //이차인증 사용에따른 처리.
        if(paramMap.get("ScTargetEmpSeq") != null && request.getHeader("referer") != null){
        	//이차인증 정보 셋팅
        	model.addAttribute("ScTargetEmpSeq", paramMap.get("ScTargetEmpSeq"));
        	model.addAttribute("seq", paramMap.get("seq"));
        	model.addAttribute("qrData", paramMap.get("qrData"));
        	model.addAttribute("type", paramMap.get("type"));
        	model.addAttribute("scGroupSeq", paramMap.get("scGroupSeq"));
        	model.addAttribute("scUserId", paramMap.get("scUserId"));
        	model.addAttribute("scUserPwd", paramMap.get("scUserPwd"));
        }

        /* 세션이 살아있는 경우는 로그인 완료로 처리 해준다.*/
        boolean isAuth = EgovUserDetailsHelper.isAuthenticated();
        String port = "" ;
        String eaType = "";
        if(isAuth){
        	/* 사용자 겸직회사 선택여부 확인 */
    		if(selectPosition.equals("Y")) {
       	    	//겸직정보
    	    	Map<String, Object> param = new HashMap<String, Object>();
    	    	param.put("empSeq", empSeq);
    	    	param.put("authCheck", "Y");
    	    	param.put("groupSeq", groupSeq);
    	    	List<Map<String, Object>> positionList = orgChartService.selectUserPositionList(param);

    	    	eaType = positionList.get(0).get("eaType") + "";
	  			if(eaType == null || eaType == "") {
	  				eaType = "eap";
	  			}

	  			if(eaType.equals("ea")){
	  				param.put("eaType", eaType);
	  				positionList = orgChartService.selectUserPositionList(param);
	  			}

    	    	int cnt = 0;
    	    	if(positionList.size() > 0){

    	    		for(Map<String,Object> mp : positionList){

    		    		Map<String, Object> cntParam = new HashMap<String, Object>();
    	   				cntParam.put("groupSeq", mp.get("groupSeq"));
    	   				cntParam.put("compSeq", mp.get("deptCompSeq"));
    	   				cntParam.put("empSeq", mp.get("empSeq"));

    	   				Map<String, Object> eaCntInfo = (Map<String, Object>) commonSql.select("MainManageDAO.eapprovalCount", cntParam);
    	   				if(eaCntInfo != null){
    	   					positionList.get(cnt).put("eapproval", eaCntInfo.get("eapproval")+"");
    	   					positionList.get(cnt).put("eapprovalRef", eaCntInfo.get("eapprovalRef")+"");
    	   				}else{
    	   					positionList.get(cnt).put("eapproval", "0");
    	   					positionList.get(cnt).put("eapprovalRef", "0");
    	   				}
    	   				cnt++;
    		    	}
    	    	}

    	    	model.addAttribute("positionList", positionList);
    	    	model.addAttribute("eaType", eaType);
    	    	model.addAttribute("securityEncLevel", this.getSecurityEncLevel());

    	    	if(buildType.equals("build")) {
    	    		return "/neos/NeosLogin";
    	    	}
    	    	else {
    	    		return "/neos/NeosCloudLogin";
    	    	}
    		}

        	/* 비밀번호 만료 옵션 확인 */
        	if(passCheck.equals("Y")) {

            	model.addAttribute("passwdChange", "Y");
            	model.addAttribute("result", passChangeCheck.get("result"));
            	model.addAttribute("message", passChangeCheck.get("msg"));
            	model.addAttribute("securityEncLevel", this.getSecurityEncLevel());

            	if(buildType.equals("build")) {
    	    		return "/neos/NeosLogin";
            	}
    	    	else {
    	    		return "/neos/NeosCloudLogin";
    	    	}
            } else {
            	EgovUserDetailsHelper.reSetAuthenticatedUser();
            	model.addAttribute("result", "success");
            	model.addAttribute("passwdChange", "N");
            }

            if(request.isSecure() ) {
                port = request.getServerPort() + "";

                return "redirect:" + request.getScheme() + "://"+request.getServerName()+":"+port+request.getContextPath()+"/forwardIndex.do";
            }else {
                return "redirect:/forwardIndex.do";
            }
        }
        
        if(EgovComponentChecker.hasComponent("mberManageService")){
            model.addAttribute("useMemberManage", "true");
        }
        
        //비밀번호찾기 사용여부 옵션체크
        paramMap.put("optionId", "cm210");
		Object option = commonSql.select("CmmnCodeDetailManageDAO.getOptionSetValue", paramMap);
		
		if(option != null && !option.equals("999")) {
			model.addAttribute("findPasswdYn", "Y");	
		}
        
    	if(BizboxAProperties.getCustomProperty("BizboxA.Cust.CustLogon") != "99" && paramMap.get("pkglogin") == null && paramMap.get("id") == null && paramMap.get("password") == null){
    		return BizboxAProperties.getCustomProperty("BizboxA.Cust.CustLogon");
    	}else{
    		if(buildType.equals("build")) {
	    		return "/neos/NeosLogin";
    		}
	    	else {
	    		return "/neos/NeosCloudLogin";
	    	}
    	}
	}



    /**
	 * 일반(세션) 로그인을 처리한다
	 * @param vo - 아이디, 비밀번호가 담긴 LoginVO
	 * @param request - 세션처리를 위한 HttpServletRequest
	 * @return result - 로그인결과(세션정보)
	 * @exception Exception
	 */
    @RequestMapping(value="/uat/uia/actionLogin.do")
    public String actionLogin(@ModelAttribute("loginVO") LoginVO loginVO,
    		                   HttpServletRequest request,
    		                   ModelMap model,
    		                   @RequestParam Map<String,Object> paramMap)
            throws Exception {

    	// security 에서 넘겨받는 값으로 로그인 통제설정 값
    	Object o = request.getAttribute("isBlock");
    	if(o != null && (boolean)o) {
    		model.addAttribute("securityEncLevel", this.getSecurityEncLevel());
    		return "/neos/NeosLogin";
    	}

    	String userSe = "USER";
    	loginVO.setUserSe(userSe);

    	/**
    	 * 로그인 페이지를 열어놓고 session 제한시간이 지나면 session이 null이 된다.
    	 * 로그인 페이지에서 group_seq를 session에 담아두는데 세션이 null 이 되면 groupSeq를 조회할수 없다.
    	 * 그로 인해 정상적인 login id, pass 입력했음에도 실패가 떨어진다.
    	 */
    	String groupSeq = null;
    	if(request.getSession() != null && request.getSession().getAttribute("loginGroupSeq") != null) {
    		groupSeq = request.getSession().getAttribute("loginGroupSeq").toString();
    	}
    	if(EgovStringUtil.isEmpty(groupSeq)) {
    		String serverName = request.getServerName();
    		paramMap.put("domain", serverName);
    		Map<String,Object> compInfo = logoManageService.getDomainCompInfo(paramMap);
    		if(compInfo != null){
    			groupSeq = compInfo.get("groupSeq").toString();
    		}
    	}

    	loginVO.setGroupSeq(groupSeq);

    	LoginVO resultVO = null;
    	// BASE64 Des
    	try{
    		
    		String pLoginParamEncType = BizboxAProperties.getCustomProperty("BizboxA.Cust.LoginParamEncType");
    		String inputLoginId = paramMap.get("id").toString() + paramMap.get("id_sub1").toString() + paramMap.get("id_sub2").toString();
    		
    		//21년 11월 24일 이지케어텍 고객사에서 패스워드 암호화 처리 관련 요청 사항 처리
    		//요청 사항: 
    		// 1. 기존 암호화 키보다 더 복잡한 키 적용 요청
    		// 2. JSP 파일에 암호화 키를 하드코딩이 아닌 서버에서 내려주는 방식으로 처리
    		String ezcaretechYn = BizboxAProperties.getCustomProperty("BizboxA.Cust.ezcaretechYn");
    		
    		if(pLoginParamEncType.equals("BASE64")) {
        		loginVO.setId(new String(org.apache.commons.codec.binary.Base64.decodeBase64(inputLoginId.getBytes("UTF-8")), "UTF-8"));
        		loginVO.setPassword(new String(org.apache.commons.codec.binary.Base64.decodeBase64(loginVO.getPassword().getBytes("UTF-8")), "UTF-8"));  
    		}else if(pLoginParamEncType.equals("NONE")) {
        		loginVO.setId(inputLoginId);
        		loginVO.setPassword(loginVO.getPassword());    			
    		}else {
    			Boolean completeKeyFlag = ezcaretechYn.equals("Y") ? true : false;
    			
        		loginVO.setId(AESCipher.AES128SCRIPT_Decode(inputLoginId, completeKeyFlag));        		
    			loginVO.setPassword(AESCipher.AES128SCRIPT_Decode(loginVO.getPassword(), completeKeyFlag));			
    		}

        	// 1. 일반 로그인 처리
    		resultVO = loginService.actionLogin(loginVO, request);
    		userSe = resultVO.getUserSe();
    	}catch(Exception e){
    		CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
    	}

		String mobileYN = (String)request.getAttribute("MOBILE_YN") ;
        if (resultVO != null && resultVO.getId() != null && !resultVO.getId().equals("")) {
        	// 2-1. 로그인 정보를 세션에 저장

        	Map<String, Object> mp = new HashMap<String, Object>();
	    	mp.put("groupSeq", resultVO.getGroupSeq());
	    	mp.put("compSeq", resultVO.getOrganId());

        	Map<String, Object> optionSet = loginService.selectOptionSet(mp);
        	request.getSession().setAttribute("optionSet", optionSet);
        	request.getSession().setAttribute("loginVO", resultVO);
        	request.setAttribute("langCode", resultVO.getLangCode());

        	String port = "" ;
        	if(request.isSecure()) {
    			port = request.getServerPort() + "";
	        	if("Y".equals(mobileYN) ) {
	        		return "redirect:" + request.getScheme() + "://"+request.getServerName()+":"+port+request.getContextPath()+"/uat/uia/actionMobileMain.do";
	        	}
	        	else  {
	        		if (EgovStringUtil.isEmpty(userSe) || userSe.equals("USER")) {
	        			return "redirect:" + request.getScheme() + "://"+request.getServerName()+":"+port+request.getContextPath()+"/userMain.do";
	        		}
	        		else if (userSe.equals("ADMIN")) {
	        			return "redirect:" + request.getScheme() + "://"+request.getServerName()+":"+port+request.getContextPath()+"/adminMain.do";
	        		}
	        		else if (userSe.equals("MASTER")) {
	        			return "redirect:" + request.getScheme() + "://"+request.getServerName()+":"+port+request.getContextPath()+"/newMasterMain.do";
	        		}
	        		else {
	        			return "redirect:" + request.getScheme() + "://"+request.getServerName()+":"+port+request.getContextPath()+"/userMain.do";
	        		}
	        	}

        	}else {
        		if("Y".equals(mobileYN) ) {
        			return "redirect:/uat/uia/actionMobileMain.do";
        		}
	        	else {
	        		if (EgovStringUtil.isEmpty(userSe) || userSe.equals("USER")) {
	        			return "redirect:/userMain.do";
	        		}
	        		else if (userSe.equals("ADMIN")) {
	        			return "redirect:/adminMain.do";
	        		}
	        		else if (userSe.equals("MASTER")) {
	        			return "redirect:/masterMain.do";
	        		}
	        		else {
	        			return "redirect:/userMain.do";
	        		}
	        	}
        	}
        } else {
        	if("Y".equals(mobileYN) ) {
        		return "/mobile_login/frmNeosMobileLogin";
        	}
        	else{
        		model.addAttribute("securityEncLevel", this.getSecurityEncLevel());
        		return "/neos/NeosLogin";
        	}
        }
    }


    /**
	 * 로그아웃한다.
	 * @return String
	 * @exception Exception
	 */
    @RequestMapping(value="/uat/uia/actionLogout.do")
	public String actionLogout(HttpServletRequest request, ModelMap model)
			throws Exception {

    	request.getSession().removeAttribute("loginVO");
    	request.getSession().removeAttribute("optionSet");
    	request.getSession().removeAttribute("eaType");
    	request.getSession().removeAttribute("autoAttOptionCheck");

    	if(BizboxAProperties.getCustomProperty("BizboxA.Cust.CustLogout") != "99"){
    		return BizboxAProperties.getCustomProperty("BizboxA.Cust.CustLogout");
    	}else{
            ReturnPath.scriptPath(request, request.getContextPath() + "/bizbox.do");
            return "neos/cmm/message";
    	}
    }

    @RequestMapping(value="/uat/uia/removeSession.do")
	public ModelAndView removeSession(HttpServletRequest request, ModelMap model)
			throws Exception {

    	ModelAndView mv = new ModelAndView();
    	LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
    	request.getSession().setAttribute("reLoginVO", loginVO);
    	request.getSession().setAttribute("loginVO" , new LoginVO());
    	request.getSession().removeAttribute("loginVO");
        mv.setViewName("jsonView");

        return mv;
    }

    /**
	 * 아이디/비밀번호 찾기 화면으로 들어간다
	 * @param
	 * @return 아이디/비밀번호 찾기 페이지
	 * @exception Exception
	 */
	@RequestMapping(value="/uat/uia/egovIdPasswordSearch.do")
	public String idPasswordSearchView(ModelMap model)
			throws Exception {

		// 1. 비밀번호 힌트 공통코드 조회
		ComDefaultCodeVO vo = new ComDefaultCodeVO();
		vo.setCodeId("COM022");
		List code = cmmUseService.selectCmmCodeDetail(vo);
		model.addAttribute("pwhtCdList", code);

		return "egovframework/com/uat/uia/EgovIdPasswordSearch";
	}

	/**
	 * 인증서안내 화면으로 들어간다
	 * @return 인증서안내 페이지
	 * @exception Exception
	 */
	@RequestMapping(value="/uat/uia/egovGpkiIssu.do")
	public String gpkiIssuView(ModelMap model)
			throws Exception {
		return "egovframework/com/uat/uia/EgovGpkiIssu";
	}

    //@RequestMapping(value="/")
    @RequestMapping(value="/loginPwCheck.do")
    public ModelAndView loginPwCheck(HttpServletRequest request, @RequestParam Map<String, Object> paramMap) throws Exception {
    	ModelAndView mv = new ModelAndView();
    	String ParamEncType = BizboxAProperties.getCustomProperty("BizboxA.Cust.LoginParamEncType");
    	boolean Flag = false;
    	//패스워드 체크
    	if(paramMap.get("secuStrBase") != null && !paramMap.get("secuStrBase").equals("")) {
    		if(ParamEncType.equals("AES")) {
    			
    			paramMap.put("tempKey", AESCipher.AES128SCRIPT_Decode(paramMap.get("secuStrBase").toString(), Flag));
				paramMap.put("encPasswdOld", CommonUtil.passwordEncrypt(paramMap.get("tempKey").toString()));
				
    		}else {
    			paramMap.put("encPasswdOld", CommonUtil.passwordEncrypt(new String(org.apache.commons.codec.binary.Base64.decodeBase64(paramMap.get("secuStrBase").toString().getBytes("UTF-8")), "UTF-8")));
    		}
    	}else {
    		paramMap.put("encPasswdOld", CommonUtil.passwordEncrypt(paramMap.get("encPasswdOld").toString()));	
    	}

    	@SuppressWarnings("unchecked")
		Map<String, Object> empInfo = (Map<String, Object>) commonSql.select("OrgAdapterManage.selectEmpPasswdCheck", paramMap);

    	//패스워드 체크 성공
    	if(empInfo != null && empInfo.get("checkYn").equals("Y")){
    		
    		if(paramMap.get("onlyCheck") != null && paramMap.get("onlyCheck").equals("Y")) {
    			mv.addObject("result", "1");
    		}else if(request.getSession().getAttribute("reLoginVO") != null){
    			//reLoginVO 세션이 있을경우 처리
    			LoginVO loginVO = (LoginVO)request.getSession().getAttribute("reLoginVO");
    	    	request.getSession().setAttribute("loginVO", loginVO);
    	    	LoginVO loginVo = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
    	    	mv.addObject("result", "1");
    		}else{
    			//서버세션이 끊겼을 경우 처리
    			mv.addObject("result", "2");
    		}

    	}else{
    		mv.addObject("result", "0");
    	}

        mv.setViewName("jsonView");
    	return mv;
    }

    @RequestMapping(value="/uat/uia/passwordCheckPop.do")
    public ModelAndView passwordCheckPop(HttpServletRequest request, @RequestParam Map<String, Object> paramMap) throws Exception {

    	/* 변수선언 */
    	ModelAndView mv = new ModelAndView();
    	LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
    	
    	//Redis 그룹시퀀스 조회
    	if(loginVO == null && CloudConnetInfo.getBuildType().equals("cloud") && (paramMap.get("groupSeq") == null || paramMap.get("groupSeq").equals(""))) {
        	Map<String, Object> jedisMp = CloudConnetInfo.getParamMapByDomain(request.getServerName());
        	
        	if(jedisMp != null) {
        		paramMap.put("groupSeq", jedisMp.get("groupSeq"));	
        	}
    	}
    	
    	String type = "def";

    	if(paramMap.get("type") != null && !paramMap.get("type").equals("")){
    		type = paramMap.get("type").toString();
    	}

    	String passwdChangeNext = "N";
    	String title = "";
    	String content = "";
		String passwdOptionUseYN = "";
		String inputDigitValue = "";
		String inputRuleValue = "";
		String inputLimitValue = "";
		String inputBlockTextValue = "";
		String inputDueOptionValue = "";
		String inputAlertValue = "0";
		String inputDueValue = "0";

		/* 결과 오류 변수 선언 */
		String inputDigitResult = "";
		String inputRuleResult = "";
		String inputLimitResult = "";
		String inputDueValueResult = "";

    	/* 비밀번호 설정규칙 값 추가 */
		/*
		 * I : 최초로그인
		 * C : 옵션 변경
		 * P : 통과
		 * D : 만료기간
		 * */
		
		String loginPasswdStatusCode = "";
		if(paramMap.get("passwdStatusCode") != null && !paramMap.get("passwdStatusCode").equals("")) {
			loginPasswdStatusCode = paramMap.get("passwdStatusCode").toString();
		}
		else {
			loginPasswdStatusCode = loginVO.getPasswdStatusCode();
			if(request.getSession().getAttribute("loginPasswdStatusCode") != null){
				loginPasswdStatusCode = (String)request.getSession().getAttribute("loginPasswdStatusCode");
				request.getSession().removeAttribute("loginPasswdStatusCode");
			}
		}

    	if(loginPasswdStatusCode.equals("P") || loginPasswdStatusCode.equals("N")) {
    		title = BizboxAMessage.getMessage("TX000004150","비밀번호 변경");
    		content = BizboxAMessage.getMessage("TX000004150","비밀번호 변경");
    	} else if(loginPasswdStatusCode.equals("R")) {
    		title = BizboxAMessage.getMessage("TX000022591","비밀번호 재설정 안내");
			content = BizboxAMessage.getMessage("TX000022592","시스템관리자에 의해 비밀번호가 초기화되었습니다.<br>비밀번호 설정 규칙에 따라 변경 후, 그룹웨어 서비스가 이용 가능합니다.");
    	} else if(loginPasswdStatusCode.equals("I")) {
    		title = BizboxAMessage.getMessage("TX000022472","최초 로그인 비밀번호 변경 안내");
			content = BizboxAMessage.getMessage("TX000022473","그룹웨어에 처음 로그인 하셨습니다.<br>비밀번호 설정 규칙에 따라 변경 후, 그룹웨어 서비스가 이용 가능합니다.");
    	} else if(loginPasswdStatusCode.equals("C")) {
    		title = BizboxAMessage.getMessage("TX000022593","비밀번호 설정규칙 변경 안내");
			content = BizboxAMessage.getMessage("TX000022594","시스템관리자에 의해 비밀번호 설정규칙이 변경되었습니다.<br>비밀번호 설정 규칙에 따라 변경 후 , 그룹웨어 서비스가 이용 가능 합니다.");
    	} else if(loginPasswdStatusCode.equals("D")) {
    		title = BizboxAMessage.getMessage("","비밀번호 만료 안내");
			content = BizboxAMessage.getMessage("","비밀번호가 만료되었습니다.<br>비밀번호 설정 규칙에 따라 변경 후, 그룹웨어 서비스가 이용 가능 합니다.");
    	} else if(loginPasswdStatusCode.equals("T")) {
    		
    		if(request.getSession().getAttribute("passwdChangeOptionText") != null) {
    			
    			String passwdChangeOptionText = request.getSession().getAttribute("passwdChangeOptionText").toString();
    			request.getSession().removeAttribute("passwdChangeOptionText");
    			
        		title = BizboxAMessage.getMessage("","비밀번호 만료 안내");
    			content = BizboxAMessage.getMessage("","비밀번호 만료기한이 {0}일 남았습니다.<br>만료 기한 내 비밀번호를 변경해주세요.");
    			content = content.replace("{0}", passwdChangeOptionText);
    			
    		}else {
        		title = BizboxAMessage.getMessage("TX000022597","비밀번호 변경 안내");
    			content = BizboxAMessage.getMessage("TX000022598","비밀번호 사용 기한이 지났습니다.<br>비밀번호 설정 규칙에 따라 변경 가능 합니다.");
    		}
    		
			passwdChangeNext = "Y";
    	}

    	/* 비밀번호 옵션 체크 */
    	/* 옵션 확인 */
    	try{
    		paramMap.put("option", "cm20");
    		List<Map<String, Object>> loginOptionValue = commonOptionManageService.getLoginOptionValue(paramMap);


    		for(Map<String, Object> temp : loginOptionValue) {
    			// 비밀번호 설정규칙 사용 여부
    			if(temp.get("optionId").equals("cm200")) {
    				if(temp.get("optionRealValue").equals("0")) {			// 비밀번호 설정 옵션 미사용
    					passwdOptionUseYN = "N";
    					break;
    				} else if(temp.get("optionRealValue").equals("1")) {	// 비밀번호 설정 옵션 사용
    					passwdOptionUseYN = "Y";
    				}
    			}

    			// 비밀번호 만료 일자
    			if(temp.get("optionId").equals("cm201")) {
    				inputDueValue = temp.get("optionRealValue").toString();

        			if(inputDueValue != null && !inputDueValue.equals("")){
        				
        				if(inputDueValue.split("▦").length > 1) {
        					inputDueOptionValue = inputDueValue.split("▦")[0];
        					inputDueValue = inputDueValue.split("▦")[1];
        				}
        				
	    				//안내기간, 만료기간 고도화 처리 (수정예정)
	    				String[] cm201Array = inputDueValue.split("\\|");
	    				if(cm201Array.length > 1){
	    					inputAlertValue = cm201Array[0];
	    					inputDueValue = cm201Array[1];
	    				}else{
	    					inputDueValue = cm201Array[0];
	    				}
        			}
    			}

    			// 비밀번호 입력 자리수 설정
    			if(temp.get("optionId").equals("cm202")) {
    				inputDigitValue = temp.get("optionRealValue").toString();
    			}

    			// 입력규칙값
    			if(temp.get("optionId").equals("cm203")) {
    				inputRuleValue = temp.get("optionRealValue").toString();
    			}

    			// 입력제한값
    			if(temp.get("optionId").equals("cm204")) {
    				inputLimitValue = temp.get("optionRealValue").toString();
    			}

    			// 입력제한단어
    			if(temp.get("optionId").equals("cm205")) {
    				inputBlockTextValue = temp.get("optionRealValue").toString();
    			}

    		}

    		// 비밀번호 설정 옵션값 체크
    		if(passwdOptionUseYN.equals("Y")) {

				// 자릿수 설정
				if(!inputDigitValue.equals("")) {
					String[] digit = inputDigitValue.split("\\|");

					if(digit.length > 1 && !digit[0].equals("") && !digit[1].equals("")){

						String min = digit[0];
						String max = digit[1];

						if(max.equals("0")) {
							max = "16";
						}

						String minStr = BizboxAMessage.getMessage("TX000010842","최소");
						String maxStr = BizboxAMessage.getMessage("TX000002618","최대");
						inputDigitResult = minStr + " " + min + " / " + maxStr + " " + max;
					}
				}

    			if(!inputDigitValue.equals("999") && !inputDigitValue.equals("")) {

    				// 0:영문(대문자), 1:영문(소문자), 2:숫자, 3:특수문자
    				if(inputRuleValue.indexOf("0") > -1) {
   						inputRuleResult += BizboxAMessage.getMessage("TX000016171","영문(대문자)") + ",";
    				}

    				if(inputRuleValue.indexOf("1") > -1) {
   						inputRuleResult += BizboxAMessage.getMessage("TX000016170","영문(소문자)") + ",";
    				}

    				if(inputRuleValue.indexOf("2") > -1) {
   						inputRuleResult += BizboxAMessage.getMessage("TX000008448","숫자") + ",";
    				}

    				if(inputRuleValue.indexOf("3") > -1) {
    					inputRuleResult += BizboxAMessage.getMessage("TX000006041","특수문자") + ",";
    				}
    			}
    			
    			if(inputDueOptionValue.equals("m")) {
    				
    				inputDueValueResult = BizboxAMessage.getMessage("","매월") + " "
    						+ inputAlertValue + BizboxAMessage.getMessage("","일 만료(종료)") + ", "
    						+ inputDueValue + BizboxAMessage.getMessage("","일 전 안내");
    				
    			}else {
    				
        			if(!inputAlertValue.equals("0")) {
        				inputDueValueResult = inputAlertValue + BizboxAMessage.getMessage("TX000022607","일 이후 안내, ");
        			}

        			if(!inputDueValue.equals("0")) {
        				inputDueValueResult += inputDueValue + BizboxAMessage.getMessage("TX000022608","일 이후 만료");
        			} else {
        				inputDueValueResult += BizboxAMessage.getMessage("TX000004167","제한없음");
        			}
        			
    			}


    			if(!inputLimitValue.equals("999") && !inputLimitValue.equals("")) {

    				inputLimitValue = "|" + inputLimitValue + "|";

    				// 0:아이디, 1:ERP사번, 2:전화번호, 3:생년월일, 4:연속문자/순차숫자, 5:직전비밀번호, 6:키보드일련배열
					if(inputLimitValue.indexOf("|0|") > -1) {
						inputLimitResult += BizboxAMessage.getMessage("TX000000075","아이디") + ",";
    				}

					if(inputLimitValue.indexOf("|1|") > -1) {
						inputLimitResult += BizboxAMessage.getMessage("TX000000106","ERP사번") + ",";
    				}

					if(inputLimitValue.indexOf("|2|") > -1) {
						inputLimitResult += BizboxAMessage.getMessage("TX000000654","휴대전화") + ",";
    				}

					if(inputLimitValue.indexOf("|3|") > -1) {
						inputLimitResult += BizboxAMessage.getMessage("TX000000083","생년월일") + ",";
    				}

					if(inputLimitValue.indexOf("|4|") > -1) {

						String termLength = "";

						if(inputLimitValue.indexOf("|4_3|") > -1) {
							termLength = BizboxAMessage.getMessage("TX000022599","3자리");
						}else if(inputLimitValue.indexOf("|4_4|") > -1) {
							termLength = BizboxAMessage.getMessage("TX000022600","4자리");
						}else if(inputLimitValue.indexOf("|4_5|") > -1) {
							termLength = BizboxAMessage.getMessage("TX000022602","5자리");
						}

			    		inputLimitResult += termLength + BizboxAMessage.getMessage("TX000022602","연속문자") + ",";
			    		inputLimitResult += termLength + BizboxAMessage.getMessage("TX000022603","반복문자") + ",";
    				}

					if(inputLimitValue.indexOf("|5|") > -1) {
			    		inputLimitResult += BizboxAMessage.getMessage("TX000022604","직전 비밀번호") + ",";
    				}

					if(inputLimitValue.indexOf("|6|") > -1) {
			    		inputLimitResult += BizboxAMessage.getMessage("TX000022605","키보드 일련배열") + ",";
    				}

    			}

    			if(!inputBlockTextValue.equals("")){
    				inputLimitResult += BizboxAMessage.getMessage("TX000022606","추측하기 쉬운단어") + ",";
    			}

    			if(inputRuleResult.equals("")){
    				inputRuleResult += BizboxAMessage.getMessage("TX000004167","제한없음") + ",";
    			}

    			if(inputLimitResult.equals("")){
    				inputLimitResult += BizboxAMessage.getMessage("TX000004167","제한없음") + ",";
    			}

    		}

    	} catch(Exception e) {
    		CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
    	}

    	mv.addObject("groupSeq", loginVO.getGroupSeq());
    	if(paramMap.containsKey("pageInfo") && paramMap.get("pageInfo").equals("empInfoPop")) {
    		mv.addObject("empSeq", paramMap.get("empSeq"));
    	}else {
    		mv.addObject("empSeq", loginVO.getUniqId());
    	}
    	mv.addObject("loginId", loginVO.getId());
    	mv.addObject("type", type);
    	mv.addObject("title", title);
    	mv.addObject("content", content);
    	mv.addObject("loginPasswdStatusCode", loginPasswdStatusCode);
    	mv.addObject("passwdChangeNext", passwdChangeNext);
    	mv.addObject("inputDueValueResult", inputDueValueResult);
    	mv.addObject("inputDigitResult", inputDigitResult);
    	mv.addObject("inputRuleResult", inputRuleResult);
    	mv.addObject("inputLimitResult", inputLimitResult);
    	mv.addObject("inputAlertValue", inputAlertValue);
    	
    	Boolean openPageFlag = false;
    	
    	if(paramMap.containsKey("pageInfo") && (paramMap.get("pageInfo").equals("myInfoManage") || paramMap.get("pageInfo").equals("empInfoPop"))) {
    		openPageFlag = true;
    	}
    	
    	mv.addObject("pageInfo", paramMap.get("pageInfo"));
    	
    	if(loginPasswdStatusCode.equals("N") && !openPageFlag) {
    		mv.setViewName("/neos/cmm/popup/passwordAlertPop");
    	}else {
    		mv.setViewName("/neos/cmm/popup/passwordCheckPop");	
    	}

    	return mv;
    }

    @RequestMapping(value="/uat/uia/passwordChangeCheck.do")
    public ModelAndView passwordChangeCheck(HttpServletRequest request, @RequestParam Map<String, Object> paramMap) throws Exception {

    	ModelAndView mv = new ModelAndView();

    	LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
    	
    	//Redis 그룹시퀀스 조회
    	if(loginVO == null && CloudConnetInfo.getBuildType().equals("cloud") && (paramMap.get("groupSeq") == null || paramMap.get("groupSeq").equals(""))) {
        	Map<String, Object> jedisMp = CloudConnetInfo.getParamMapByDomain(request.getServerName());
        	
        	if(jedisMp != null) {
        		paramMap.put("groupSeq", jedisMp.get("groupSeq"));	
        	}
    	}

		String passwdOptionUseYN = "";
		String inputDigitValue = "";
		String inputRuleValue = "";
		String inputLimitValue = "";
		String inputBlockTextValue = "";
		String regExpression = "";

		/* 결과 오류 변수 선언 */
		String inputDigitResult = "";
		String inputRuleResult = "";
		String inputLimitResult = "";

		String returnInputRuleResult = "";
		String returnInputLimitResult = "";
		
		Map<String, Object> resultObj = new HashMap<String, Object>();

		boolean regExpressionFlag = false;
		boolean passwdSave = false;
		boolean Flag = false;
		
		String ParamEncType = BizboxAProperties.getCustomProperty("BizboxA.Cust.LoginParamEncType");
		
		try {	
			
    		if(ParamEncType.equals("AES")) {
    			paramMap.put("nPWD", AESCipher.AES128SCRIPT_Decode(paramMap.get("nPWD").toString(), Flag));

    		}else {
    			paramMap.put("nPWD", new String(org.apache.commons.codec.binary.Base64.decodeBase64(paramMap.get("nPWD").toString().getBytes("UTF-8")), "UTF-8"));
    		}
    				
			/* 기존 비밀번호 체크 */
			String empSeq = (String) paramMap.get("empSeq");
			String nPWD = (String) paramMap.get("nPWD");
			String groupSeq = (String) paramMap.get("groupSeq");
			String langCode = "kr";

			if(paramMap.get("type").equals("find")) {
				
				if(request.getSession().getAttribute("findPasswdSecuNum") != null && request.getSession().getAttribute("findPasswdSecuNum").equals(paramMap.get("loginId").toString() + "|" + paramMap.get("findPasswdSecuNum").toString())) {
					//인증번호 일치
				}else {
					
					//인증번호 불일치
					resultObj.put("resultCode", "fail");
					resultObj.put("ex", "Y");
					resultObj.put("message", BizboxAMessage.getMessage("","인증번호가 올바르지 않습니다."));
					mv.addObject("result", resultObj);
					mv.setViewName("jsonView");
					return mv;					
				}
					
			}else {

	    		if(ParamEncType.equals("AES")) {
	    			paramMap.put("oPWD", AESCipher.AES128SCRIPT_Decode(paramMap.get("oPWD").toString(), Flag));
					paramMap.put("encPasswdOld", CommonUtil.passwordEncrypt(paramMap.get("oPWD").toString()));

	    		}else {
	    			paramMap.put("oPWD", new String(org.apache.commons.codec.binary.Base64.decodeBase64(paramMap.get("oPWD").toString().getBytes("UTF-8")), "UTF-8"));
					paramMap.put("encPasswdOld", CommonUtil.passwordEncrypt(paramMap.get("oPWD").toString()));
	    		}
			}
			
			// 아이디와 암호화된 비밀번호가 DB와 일치하는지 확인한다.
			@SuppressWarnings("unchecked")
			Map<String, Object> resultEmp = (Map<String, Object>) commonSql.select("OrgAdapterManage.selectEmpPasswdCheck", paramMap);

			if(resultEmp != null){
				langCode = resultEmp.get("langCode").toString();
			}

	    	// 비밀번호 일치
			// 관리자/마스터 사용자수정 팝업내에서 호출이 들어온경우 기존 비밀번호 미체크(클라우드만 적용)
	    	if((resultEmp != null && resultEmp.get("checkYn").equals("Y")) || (paramMap.get("pageInfo") != null && paramMap.get("pageInfo").toString().equals("empInfoPop") && CloudConnetInfo.getBuildType().equals("cloud"))){
				/* 옵션 확인 */
	    		paramMap.put("option", "cm20");
	    		List<Map<String, Object>> loginOptionValue = commonOptionManageService.getLoginOptionValue(paramMap);

	    		// 메일 싱크를 위한 정보
		    	Map<String, Object> mailParam = new HashMap<String, Object>();
		    	mailParam.put("compSeq", resultEmp.get("compSeq"));

	    		for(Map<String, Object> temp : loginOptionValue) {

	    			// 비밀번호 설정규칙 사용 여부
	    			if(temp.get("optionId").equals("cm200")) {
	    				if(temp.get("optionRealValue").equals("0")) {			// 비밀번호 설정 옵션 미사용
	    					passwdOptionUseYN = "N";
	    					break;
	    				} else if(temp.get("optionRealValue").equals("1")) {	// 비밀번호 설정 옵션 사용
	    					passwdOptionUseYN = "Y";
	    				}
	    			}

	    			// 비밀번호 입력 자리수 설정
	    			if(temp.get("optionId").equals("cm202")) {
	    				inputDigitValue = temp.get("optionRealValue").toString();
	    			}

	    			// 입력규칙값
	    			if(temp.get("optionId").equals("cm203")) {
	    				inputRuleValue = temp.get("optionRealValue").toString();
	    			}

	    			// 입력제한값
					if(temp.get("optionId").equals("cm204")) {
						inputLimitValue = temp.get("optionRealValue").toString();
					}

	    			// 입력제한단어
					if(temp.get("optionId").equals("cm205")) {
						inputBlockTextValue = temp.get("optionRealValue").toString();
					}

	    		}

	    		Pattern p = null;		// 정규식

	    		// 비밀번호 설정 옵션값 체크
	    		if(passwdOptionUseYN.equals("Y")) {

    				// 자릿수 설정
    				if(!inputDigitValue.equals("")) {
    					String[] digit = inputDigitValue.split("\\|");

    					if(digit.length > 1 && !digit[0].equals("") && !digit[1].equals("")){
        					String min = digit[0];
        					String max = digit[1];

        					if(max.equals("0")) {
        						max = "16";
        					}

        					if(nPWD.length() < Integer.parseInt(min) || nPWD.length() > Integer.parseInt(max)) {
        						inputDigitResult = "- "+ BizboxAMessage.getMessage("TX000010842","최소", langCode) +" <span class='text_blue'>" + min +"</span> " + BizboxAMessage.getMessage("TX000022609","자리 이상", langCode) + " <span class='text_blue'>" + max +"</span> " +BizboxAMessage.getMessage("TX000022610"," 자리 이하로 입력해 주세요.", langCode);
        					}
    					}
    				}

	    			if(!inputRuleValue.equals("999") && !inputRuleValue.equals("")) {

	    				// 0:영문(대문자), 1:영문(소문자), 2:숫자, 3:특수문자
	    				if(inputRuleValue.indexOf("0") > -1) {
	    					regExpression = ".*[A-Z]+.*";

	    					p = Pattern.compile(regExpression);

	    					regExpressionFlag = fnRegExpression(p, nPWD);

	    					if(!regExpressionFlag) {
	    						inputRuleResult += BizboxAMessage.getMessage("TX000016171","영문(대문자)", langCode) + ",";
	    					}
	    				}

	    				if(inputRuleValue.indexOf("1") > -1) {
						regExpression = ".*[a-z]+.*";

						p = Pattern.compile(regExpression);

	    					regExpressionFlag = fnRegExpression(p, nPWD);

	    					if(!regExpressionFlag) {
	    						inputRuleResult += BizboxAMessage.getMessage("TX000016170","영문(소문자)", langCode) + ",";
	    					}
	    				}

	    				if(inputRuleValue.indexOf("2") > -1) {
						regExpression = ".*[0-9]+.*";

						p = Pattern.compile(regExpression);

	    					regExpressionFlag = fnRegExpression(p, nPWD);

	    					if(!regExpressionFlag) {
	    						inputRuleResult += BizboxAMessage.getMessage("TX000008448","숫자", langCode) + ",";
	    					}
	    				}

	    				if(inputRuleValue.indexOf("3") > -1) {
	    					regExpression = ".*[^가-힣a-zA-Z0-9].*";

	    					p = Pattern.compile(regExpression);

	    					regExpressionFlag = fnRegExpression(p, nPWD);

	    					if(!regExpressionFlag) {
	    						inputRuleResult += BizboxAMessage.getMessage("TX000006041","특수문자", langCode) + ",";
	    					}
	    				}

	    				if(inputRuleResult.length() > 0) {
	    					returnInputRuleResult = "- <span class='text_blue'>" + inputRuleResult.substring(0, inputRuleResult.length() - 1) + "</span> " + BizboxAMessage.getMessage("TX000022611","를 포함해 주세요.", langCode);
	    				}
	    			}

	    			if(!inputLimitValue.equals("999") && !inputLimitValue.equals("")) {

	    				inputLimitValue = "|" + inputLimitValue + "|";

	    				Map<String, Object> params = new HashMap<String, Object>();
	    				params.putAll(resultEmp);
	    				params.remove( "deptSeq" );
	    				/* 사용자 정보 가져오기 */
	    	    		// 사원 정보 (비밀번호 변경 옵션 값에 필요)
	    	    		Map<String, Object> infoMap = empManageService.selectEmpInfo(params, new PaginationInfo());
	    	    		@SuppressWarnings("unchecked")
						List<Map<String,Object>> list = (List<Map<String, Object>>) infoMap.get("list");
	    	    		Map<String,Object> map = list.get(0);

	    	    		// 0:아이디, 1:ERP사번, 2:전화번호, 3:생년월일, 4:연속문자/순차숫자, 5:직전 비밀번호, 6:키보드 일련배열
	    	    		if(inputLimitValue.indexOf("|0|") > -1) {
	    					String loginIdCheck = map.get("loginId").toString();

	    					if(nPWD.indexOf(loginIdCheck) > -1) {
	    						inputLimitResult += BizboxAMessage.getMessage("TX000000075","아이디", langCode) + ",";
	    					}
	    				}

	    	    		if(inputLimitValue.indexOf("|1|") > -1) {
	    	    			String erpNum = map.get("erpEmpNum") != null ? map.get("erpEmpNum").toString() : "";

	    					if(nPWD.indexOf(erpNum) > -1 && !erpNum.equals("")) {
	    						inputLimitResult += BizboxAMessage.getMessage("TX000000106","ERP사번", langCode) + ",";
	    					}
	    				}

	    	    		if(inputLimitValue.indexOf("|2|") > -1) {
							String phoneNum = map.get("mobileTelNum") != null ? map.get("mobileTelNum").toString().replaceAll("-", "") : "";

							String phoneNumPattern = "";
							String[] phoneArray = null;
							String middleNum = "";
							String endNum = "";

							if(!phoneNum.equals("")) {
								phoneNumPattern = phoneFormat(phoneNum);
								phoneArray = phoneNumPattern.split("-");

								if(phoneArray.length > 2) {
									middleNum = phoneArray[1];
									endNum = phoneArray[2];
								} else if(phoneArray.length == 1 && phoneArray[0].length() > 3){
									middleNum = phoneArray[0];
									endNum = phoneArray[0];
								}

								if(!middleNum.equals("") && !endNum.equals("")){
									if(nPWD.indexOf(middleNum) > -1 || nPWD.indexOf(endNum) > -1) {
										inputLimitResult += BizboxAMessage.getMessage("TX000000654","휴대전화", langCode) + ",";
									}
								}
							}
	    				}

	    	    		if(inputLimitValue.indexOf("|3|") > -1) {
							String birthDay = map.get("bday") != null ? map.get("bday").toString() : "0000-00-00";

							if(!birthDay.equals("0000-00-00")) {
								String[] yearMonthDay = birthDay.split("-");
								String year = yearMonthDay[0];
								String monthDay = yearMonthDay[1] + yearMonthDay[2];
								String residentReg = year.substring(2,4) + monthDay;

								if(nPWD.indexOf(year) > -1 || nPWD.indexOf(monthDay) > -1 || nPWD.indexOf(residentReg) > -1) {
									inputLimitResult += BizboxAMessage.getMessage("TX000000083","생년월일", langCode) + ",";
								}
							}
	    				}

	    	    		if(inputLimitValue.indexOf("|4|") > -1) {
	    					int samePass1 = 1; //연속성(+) 카운드
		 				    int samePass2 = 1; //반복성(+) 카운드
		 				    int blockCnt = 3;

		 				    if(inputLimitValue.indexOf("|4_4|") > -1) {
		 				    	blockCnt = 4;
		 				    }else if(inputLimitValue.indexOf("|4_5|") > -1) {
		 				    	blockCnt = 5;
		 				    }

		 				    for(int j=1; j < nPWD.length(); j++){
		 				    	int tempA = (int) nPWD.charAt(j-1);
		 				    	int tempB = (int) nPWD.charAt(j);

		 				    	if(tempA - (tempB-1) == 0 ) {
		 				    		samePass1++;
		 				    	}else{
		 				    		samePass1 = 1;
		 				    	}

		 				    	if(tempA - tempB == 0) {
		 				    		samePass2++;
		 				    	}else{
		 				    		samePass2 = 1;
		 				    	}

		 				    	if(samePass1 >= blockCnt) {
		 				    		inputLimitResult += blockCnt + BizboxAMessage.getMessage("TX000005067","자리", langCode) + " " + BizboxAMessage.getMessage("TX000022602","연속문자", langCode) + ",";
		 				    		break;
		 				    	}

		 				    	if(samePass2 >= blockCnt) {
		 				    		inputLimitResult += blockCnt + BizboxAMessage.getMessage("TX000005067","자리", langCode) + " "  + BizboxAMessage.getMessage("TX000022603","반복문자", langCode) + ",";
		 				    		break;
		 				    	}
		 				    }
	    				}

	    	    		if(inputLimitValue.indexOf("|5|") > -1) {
	    	    			if(map.get("prevLoginPasswd").equals(CommonUtil.passwordEncrypt(nPWD))){
	    	    				inputLimitResult += BizboxAMessage.getMessage("TX000022604","직전 비밀번호", langCode) + ",";
	    	    			}
	    				}

	    	    		if(inputLimitValue.indexOf("|6|") > -1 && nPWD.length() > 1) {

	    	    			int samePass1 = 1; //연속성(+) 카운드
	    	    			int samePass2 = 1; //연속성(-) 카운드
		 				    int blockCnt = 3;
		 				    String keyArray = "`1234567890-=!@#$%^&*()_+qwertyuiopasdfghjkl;'zxcvbnm,./";
		 				    String newPasswdLow = nPWD.toLowerCase();

		 				    if(inputLimitValue.indexOf("|4_4|") > -1) {
		 				    	blockCnt = 4;
		 				    }else if(inputLimitValue.indexOf("|4_5|") > -1) {
		 				    	blockCnt = 5;
		 				    }

		 				    for(int j=1; j < newPasswdLow.length(); j++){
		 				    	int tempA = keyArray.indexOf(newPasswdLow.charAt(j-1));
		 				    	int tempB = keyArray.indexOf(newPasswdLow.charAt(j));

		 				    	if(tempA == -1 || tempB == -1){
		 				    		samePass1 = 1;
		 				    		samePass2 = 1;
		 				    	}else{

		 				    		if((tempB-tempA) == 1){
		 				    			samePass1++;
		 				    		}else{
		 				    			samePass1 = 1;
		 				    		}

		 				    		if((tempA-tempB) == 1){
		 				    			samePass2++;
		 				    		}else{
		 				    			samePass2 = 1;
		 				    		}
		 				    	}

		 				    	if(samePass1 >= blockCnt || samePass2 >= blockCnt) {
		 				    		inputLimitResult += BizboxAMessage.getMessage("TX000022605","키보드 일련배열", langCode) + ",";
		 				    		break;
		 				    	}
		 				    }
	    				}
	    			}

	    			if(!inputBlockTextValue.equals("")){

	    				inputBlockTextValue = "|" + inputBlockTextValue + "|";

	    				if(inputBlockTextValue.indexOf("|" + nPWD + "|") != -1){
	    					inputLimitResult += BizboxAMessage.getMessage("TX000022606","추측하기 쉬운단어", langCode) + ",";
	    				}

	    			}

					if(inputLimitResult.length() > 0) {
						returnInputLimitResult = "- <span class='text_blue'>" + inputLimitResult.substring(0, inputLimitResult.length() - 1) +"</span> "+ BizboxAMessage.getMessage("TX000022612","(이)가 포함되어 있습니다.", langCode);
					}

	    			String result = inputDigitResult + "<br>" + returnInputRuleResult + "<br>" + returnInputLimitResult;

	    			if(result.equals("<br><br>")) {
	    				passwdSave = true;
	    			} else {
	    				passwdSave = false;
	    			}

	    			if(passwdSave) {
	    				Map<String, Object> adapterParam = new HashMap<String,Object>();
	    				adapterParam.put("groupSeq", groupSeq);
	    				adapterParam.put("callType", "updatePasswd");
	    				adapterParam.put("empSeq", empSeq);
	    				adapterParam.put("compSeq", resultEmp.get("compSeq"));
	    				adapterParam.put("deptSeq", resultEmp.get("deptSeq"));
	    				adapterParam.put("createSeq", empSeq);

	    				if(paramMap.get("type").equals("def") || paramMap.get("type").equals("find")){
	    					adapterParam.put("loginPasswdNew", nPWD);
	    				}else if(paramMap.get("type").equals("app")){
	    					adapterParam.put("apprPasswdNew", nPWD);
	    				}else{
	    					adapterParam.put("payPasswdNew", nPWD);
	    				}

	    				Map<String, Object> adapterResult = orgAdapterService.empSaveAdapter(adapterParam);

	    				// mailSync호출
	    				if(adapterParam.get("compSeq") != null){
	    					orgAdapterService.mailUserSync(adapterResult);
	    				}

	    				if(adapterResult.get("resultCode").equals("fail")){
		    				resultObj.put("resultCode", "fail");
		    				resultObj.put("message", adapterResult.get("result"));
	    				}else{
			    			resultObj.put("resultCode", "success");
			    			resultObj.put("message", BizboxAMessage.getMessage("TX000014067","비밀번호 변경을 성공했습니다", langCode));
	    				}

	    			} else {
	    				resultObj.put("resultCode", "fail");
	    				resultObj.put("message", result.substring(0, result.length()-1));
	    			}

	    		} else if(passwdOptionUseYN.equals("N")) {

    				Map<String, Object> adapterParam = new HashMap<String,Object>();
    				adapterParam.put("callType", "updatePasswd");
    				adapterParam.put("groupSeq", groupSeq);
    				adapterParam.put("empSeq", empSeq);
    				adapterParam.put("compSeq", resultEmp.get("compSeq"));
    				adapterParam.put("deptSeq", resultEmp.get("deptSeq"));
    				adapterParam.put("createSeq", empSeq);

    				if(paramMap.get("type").equals("def") || paramMap.get("type").equals("find")){
    					adapterParam.put("loginPasswdNew", nPWD);
    				}else if(paramMap.get("type").equals("app")){
    					adapterParam.put("apprPasswdNew", nPWD);
    				}else{
    					adapterParam.put("payPasswdNew", nPWD);
    				}

    				Map<String, Object> adapterResult = orgAdapterService.empSaveAdapter(adapterParam);

    				// mailSync호출
    				if(adapterParam.get("compSeq") != null){
    					orgAdapterService.mailUserSync(adapterResult);
    				}

    				if(adapterResult.get("resultCode").equals("fail")){
	    				resultObj.put("resultCode", "fail");
	    				resultObj.put("message", adapterResult.get("result"));
    				}else{
    	    			resultObj.put("resultCode", "success");
    	    			resultObj.put("message", BizboxAMessage.getMessage("TX000014067","비밀번호 변경을 성공했습니다", langCode));
    				}
	    		}

			} else {		// 비밀번호 불일치
				resultObj.put("resultCode", "fail");
				resultObj.put("ex", "Y");
				resultObj.put("message", BizboxAMessage.getMessage("TX000004152","기존 비밀번호가 일치하지 않습니다.", langCode));
			}

		}catch(Exception e) {
			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
			resultObj.put("resultCode", "fail");
			resultObj.put("message", BizboxAMessage.getMessage("TX000016542","API 요청 처리중 문제가 발생하였습니다."));
		}

		mv.addObject("result", resultObj);
		mv.setViewName("jsonView");
    	return mv;
    }

	/*
	 * 정규식 확인 메서드
	 *
	 * */

	public boolean fnRegExpression(Pattern regExpression, String modPass) {
		Matcher match = regExpression.matcher(modPass);

		boolean result = match.find();

		return result;
	}

	/* 핸드폰 번호 정규화 */
	public static String phoneFormat(String phoneNo){

	   if (phoneNo.length() == 0){
	    return phoneNo;
	      }

	      String strTel = phoneNo;
	      String[] strDDD = {"02" , "031", "032", "033", "041", "042", "043",
	                           "051", "052", "053", "054", "055", "061", "062",
	                           "063", "064", "010", "011", "012", "013", "015",
	                           "016", "017", "018", "019", "070", "050"};

	      if (strTel.length() < 9) {
	          return strTel;
	      } else if (strTel.substring(0,2).equals(strDDD[0])) {
	          strTel = strTel.substring(0,2) + '-' + strTel.substring(2, strTel.length()-4)
	               + '-' + strTel.substring(strTel.length() -4, strTel.length());
	      } else if(strTel.substring(0, 3).equals(strDDD[26])){
	    	  strTel = strTel.substring(0,4) + '-' + strTel.substring(4, strTel.length()-4)
	                   + '-' + strTel.substring(strTel.length() -4, strTel.length());
	      } else {
	          for(int i=1; i < strDDD.length; i++) {
	              if (strTel.substring(0,3).equals(strDDD[i])) {
	                  strTel = strTel.substring(0,3) + '-' + strTel.substring(3, strTel.length()-4)
	                   + '-' + strTel.substring(strTel.length() -4, strTel.length());
	              }
	          }
	      }
	      return strTel;
	 }

    @RequestMapping(value="/uat/uia/serverSessionReset.do")
    public ModelAndView serverSessionReset(HttpServletRequest request) throws Exception {
    	ModelAndView mv = new ModelAndView();
    	mv.addObject("isAuthenticated", EgovUserDetailsHelper.isAuthenticated());
		mv.setViewName("jsonView");
    	return mv;
    }
    
    @RequestMapping(value="/uat/uia/findPasswdPop.do")
    public ModelAndView findPasswdPop(HttpServletRequest request, @RequestParam Map<String, Object> paramMap, HttpServletResponse response) throws Exception {

    	/* 변수선언 */
    	ModelAndView mv = new ModelAndView();
    	
        //비밀번호찾기 사용여부 옵션체크
        paramMap.put("optionId", "cm210");
		Object option = commonSql.select("CmmnCodeDetailManageDAO.getOptionSetValue", paramMap);
		
		if(option != null && !option.equals("999")) {
			mv.addObject("cm210", option);
		}else {
			PrintWriter printwriter = response.getWriter();
			printwriter.println("<script>");
			printwriter.println("alert('You do not have permission.');self.close();");
			printwriter.println("</script>");			
			printwriter.flush();
			printwriter.close();						
			return null;
		}
		
		mv.addObject("groupSeq", paramMap.get("groupSeq") != null && !paramMap.get("groupSeq").equals("") ? paramMap.get("groupSeq").toString() : "");
		
		String passwdOptionUseYN = "";
		String inputDigitValue = "";
		String inputRuleValue = "";
		String inputLimitValue = "";
		String inputBlockTextValue = "";
		String inputDueOptionValue = "";
		String inputAlertValue = "0";
		String inputDueValue = "0";

		/* 결과 오류 변수 선언 */
		String inputDigitResult = "";
		String inputRuleResult = "";
		String inputLimitResult = "";
		String inputDueValueResult = "";		

		paramMap.put("option", "cm20");
		List<Map<String, Object>> loginOptionValue = commonOptionManageService.getLoginOptionValue(paramMap);


		for(Map<String, Object> temp : loginOptionValue) {
			// 비밀번호 설정규칙 사용 여부
			if(temp.get("optionId").equals("cm200")) {
				if(temp.get("optionRealValue").equals("0")) {			// 비밀번호 설정 옵션 미사용
					passwdOptionUseYN = "N";
					break;
				} else if(temp.get("optionRealValue").equals("1")) {	// 비밀번호 설정 옵션 사용
					passwdOptionUseYN = "Y";
				}
			}

			// 비밀번호 만료 일자
			if(temp.get("optionId").equals("cm201")) {
				inputDueValue = temp.get("optionRealValue").toString();
				
				if(inputDueValue.split("▦").length > 1) {
					inputDueOptionValue = inputDueValue.split("▦")[0];
					inputDueValue = inputDueValue.split("▦")[1];
				}				

    			if(inputDueValue != null){
    				//안내기간, 만료기간 고도화 처리 (수정예정)
    				String[] cm201Array = inputDueValue.split("\\|");
    				if(cm201Array.length > 1){
    					inputAlertValue = cm201Array[0];
    					inputDueValue = cm201Array[1];
    				}else{
    					inputDueValue = cm201Array[0];
    				}
    			}
			}

			// 비밀번호 입력 자리수 설정
			if(temp.get("optionId").equals("cm202")) {
				inputDigitValue = temp.get("optionRealValue").toString();
			}

			// 입력규칙값
			if(temp.get("optionId").equals("cm203")) {
				inputRuleValue = temp.get("optionRealValue").toString();
			}

			// 입력제한값
			if(temp.get("optionId").equals("cm204")) {
				inputLimitValue = temp.get("optionRealValue").toString();
			}

			// 입력제한단어
			if(temp.get("optionId").equals("cm205")) {
				inputBlockTextValue = temp.get("optionRealValue").toString();
			}

		}

		// 비밀번호 설정 옵션값 체크
		if(passwdOptionUseYN.equals("Y")) {

			// 자릿수 설정
			if(!inputDigitValue.equals("")) {
				String[] digit = inputDigitValue.split("\\|");

				if(digit.length > 1 && !digit[0].equals("") && !digit[1].equals("")){

					String min = digit[0];
					String max = digit[1];

					if(max.equals("0")) {
						max = "16";
					}

					String minStr = BizboxAMessage.getMessage("TX000010842","최소");
					String maxStr = BizboxAMessage.getMessage("TX000002618","최대");
					inputDigitResult = minStr + " " + min + " / " + maxStr + " " + max;
				}
			}

			if(!inputDigitValue.equals("999") && !inputDigitValue.equals("")) {

				// 0:영문(대문자), 1:영문(소문자), 2:숫자, 3:특수문자
				if(inputRuleValue.indexOf("0") > -1) {
						inputRuleResult += BizboxAMessage.getMessage("TX000016171","영문(대문자)") + ",";
				}

				if(inputRuleValue.indexOf("1") > -1) {
						inputRuleResult += BizboxAMessage.getMessage("TX000016170","영문(소문자)") + ",";
				}

				if(inputRuleValue.indexOf("2") > -1) {
						inputRuleResult += BizboxAMessage.getMessage("TX000008448","숫자") + ",";
				}

				if(inputRuleValue.indexOf("3") > -1) {
					inputRuleResult += BizboxAMessage.getMessage("TX000006041","특수문자") + ",";
				}
			}
			
			
			if(inputDueOptionValue.equals("m")) {
				
				inputDueValueResult = BizboxAMessage.getMessage("","매월") + " "
						+ inputAlertValue + BizboxAMessage.getMessage("","일 만료(종료)") + ", "
						+ inputDueValue + BizboxAMessage.getMessage("","일 전 안내");
				
			}else {
				
    			if(!inputAlertValue.equals("0")) {
    				inputDueValueResult = inputAlertValue + BizboxAMessage.getMessage("TX000022607","일 이후 안내, ");
    			}

    			if(!inputDueValue.equals("0")) {
    				inputDueValueResult += inputDueValue + BizboxAMessage.getMessage("TX000022608","일 이후 만료");
    			} else {
    				inputDueValueResult += BizboxAMessage.getMessage("TX000004167","제한없음");
    			}
    			
			}			
			
			if(!inputLimitValue.equals("999") && !inputLimitValue.equals("")) {

				inputLimitValue = "|" + inputLimitValue + "|";

				// 0:아이디, 1:ERP사번, 2:전화번호, 3:생년월일, 4:연속문자/순차숫자, 5:직전비밀번호, 6:키보드일련배열
				if(inputLimitValue.indexOf("|0|") > -1) {
					inputLimitResult += BizboxAMessage.getMessage("TX000000075","아이디") + ",";
				}

				if(inputLimitValue.indexOf("|1|") > -1) {
					inputLimitResult += BizboxAMessage.getMessage("TX000000106","ERP사번") + ",";
				}

				if(inputLimitValue.indexOf("|2|") > -1) {
					inputLimitResult += BizboxAMessage.getMessage("TX000000654","휴대전화") + ",";
				}

				if(inputLimitValue.indexOf("|3|") > -1) {
					inputLimitResult += BizboxAMessage.getMessage("TX000000083","생년월일") + ",";
				}

				if(inputLimitValue.indexOf("|4|") > -1) {

					String termLength = "";

					if(inputLimitValue.indexOf("|4_3|") > -1) {
						termLength = BizboxAMessage.getMessage("TX000022599","3자리");
					}else if(inputLimitValue.indexOf("|4_4|") > -1) {
						termLength = BizboxAMessage.getMessage("TX000022600","4자리");
					}else if(inputLimitValue.indexOf("|4_5|") > -1) {
						termLength = BizboxAMessage.getMessage("TX000022602","5자리");
					}

		    		inputLimitResult += termLength + BizboxAMessage.getMessage("TX000022602","연속문자") + ",";
		    		inputLimitResult += termLength + BizboxAMessage.getMessage("TX000022603","반복문자") + ",";
				}

				if(inputLimitValue.indexOf("|5|") > -1) {
		    		inputLimitResult += BizboxAMessage.getMessage("TX000022604","직전 비밀번호") + ",";
				}

				if(inputLimitValue.indexOf("|6|") > -1) {
		    		inputLimitResult += BizboxAMessage.getMessage("TX000022605","키보드 일련배열") + ",";
				}

			}

			if(!inputBlockTextValue.equals("")){
				inputLimitResult += BizboxAMessage.getMessage("TX000022606","추측하기 쉬운단어") + ",";
			}

			if(inputRuleResult.equals("")){
				inputRuleResult += BizboxAMessage.getMessage("TX000004167","제한없음") + ",";
			}

			if(inputLimitResult.equals("")){
				inputLimitResult += BizboxAMessage.getMessage("TX000004167","제한없음") + ",";
			}

		}		
		
    	mv.addObject("inputDueValueResult", inputDueValueResult);
    	mv.addObject("inputDigitResult", inputDigitResult);
    	mv.addObject("inputRuleResult", inputRuleResult);
    	mv.addObject("inputLimitResult", inputLimitResult);
    	
		mv.setViewName("/neos/cmm/popup/findPasswdPop");

    	return mv;
    }
    
    @SuppressWarnings("unchecked")
	@RequestMapping(value="/uat/uia/findPasswdInfo.do")
    public ModelAndView findPasswdInfo(HttpServletRequest request, @RequestParam Map<String, Object> paramMap) throws Exception {

    	ModelAndView mv = new ModelAndView();
    	
    	Map<String, Object> empInfo = (Map<String, Object>) commonSql.select("OrgAdapterManage.selectLiveEmp", paramMap);
    	
    	if(empInfo != null) {
    		
        	if(empInfo.get("outMail") != null && !empInfo.get("outMail").equals("") && empInfo.get("outDomain") != null && !empInfo.get("outDomain").equals("")) {
        		
        		String outMail = empInfo.get("outMail").toString();
        		int outMailLength = outMail.length();
        		
        		if(outMailLength > 3) {
        			
        			outMail = outMail.substring(0, 3);
        			
 				    for(int j=3; j < outMailLength; j++){
 				    	outMail += "*";
 				    }        			
        			
        		}
        		
            	mv.addObject("emailId", outMail);
            	mv.addObject("emailDomain", empInfo.get("outDomain"));        		
        		mv.addObject("outMailExistYn", "Y");
        		
        		//SMTP서버정보 체크
        		String mailUrl = empInfo.get("mailUrl") + "";
        		String outSmtpUseYn = empInfo.get("outSmtpUseYn") + "";
        		String smtpUrl = BizboxAProperties.getProperty("BizboxA.smtp.url");
        		
        		if(mailUrl.equals("") && !outSmtpUseYn.equals("Y") && smtpUrl.equals("99")) {
        			mv.addObject("smtpExistYn", "N");	
        		}else {
        			mv.addObject("smtpExistYn", "Y");	
        		}
        		
        	}else {
        		mv.addObject("outMailExistYn", "N");
        	}
        	
        	mv.addObject("empExistYn", "Y");
        	mv.addObject("empSeq", empInfo.get("empSeq"));
        	
    	}else {
    		mv.addObject("empExistYn", "N");
    	}
    	
    	mv.setViewName("jsonView");

    	return mv;
    }    
    
    @RequestMapping(value="/uat/uia/findPasswdReq.do")
    public ModelAndView findPasswdReq(HttpServletRequest request, @RequestParam Map<String, Object> paramMap) throws Exception {

    	ModelAndView mv = new ModelAndView();
    	mv.setViewName("jsonView");
    	
    	Map<String, Object> empInfo = (Map<String, Object>) commonSql.select("OrgAdapterManage.selectLiveEmp", paramMap);
    	
    	if(empInfo != null) {
    		
    		if(paramMap.get("passwdStatusCode").equals("F") && empInfo.get("passwdStatusCode") != null && empInfo.get("passwdStatusCode").equals("F")) {
    			
    			mv.addObject("result", "REQ");
    			
    		}else if(paramMap.get("passwdStatusCode").equals("F")) {
    			
    			paramMap.put("empSeq", empInfo.get("empSeq"));
    			paramMap.put("clientIp", CommonUtil.getClientIp(request));
    			paramMap.put("compSeq", empInfo.get("compSeq"));
    			
            	commonSql.update("OrgAdapterManage.updateEmpFindPasswdInfo", paramMap);
            	
            	//알림전송
            	List<Map<String, Object>> recvEmpList = (List<Map<String, Object>>) commonSql.list("OrgAdapterManage.selectEmpFindPasswdAdminList", paramMap);
            	
            	if(recvEmpList != null && recvEmpList.size() > 0) {
            		
                	EventRequest eventRequest = new EventRequest();
            		eventRequest.setEventType("COMMON");
            		eventRequest.setEventSubType("GW001");
            		eventRequest.setGroupSeq(empInfo.get("groupSeq").toString());
            		eventRequest.setCompSeq(empInfo.get("compSeq").toString());
            		eventRequest.setSenderSeq(empInfo.get("empSeq").toString());
        			eventRequest.setAlertYn("Y");
        			eventRequest.setPushYn("Y");
        			eventRequest.setTalkYn("Y");
        			eventRequest.setMailYn("Y");
        			eventRequest.setSmsYn("Y");
        			eventRequest.setPortalYn("Y");
        			eventRequest.setTimelineYn("N");
        			
            		eventRequest.setRecvEmpList(recvEmpList);
            		HashMap<String, Object> data = new HashMap<>();
            		data.put("userSeq", empInfo.get("empSeq").toString());
            		eventRequest.setData(data);            	
                	
            		try {
            			eventService.eventSend(eventRequest);
            		} catch (Exception e) {
            			LOG.error( "findPasswdReq eventSend Exception", e);
            		} 
            		
            	}
            	
            	mv.addObject("result", "SUCCESS");  
            	
    		}else if(paramMap.get("passwdStatusCode").equals("M")) {
    			
    			Map<String, Object> groupInfo = (Map<String, Object>) commonSql.select("OrgChart.selectGroupInfo", paramMap);
    			
    			String smtpServer = "";
    			String smtpPort = "25";
    			String smtpId = "";
    			String smtpPw = "";
    			String groupEmailName = "그룹웨어시스템";
    			String groupEmailId = "groupwaresystem";
    			String groupEmailDomain = empInfo.get("emailDomain") != null ? empInfo.get("emailDomain").toString() : "";
    			int secuNum = (int) (Math.random() * (9999 - 1000 + 1)) + 1000;

    			String contents = "<!doctype html>\r\n" + 
    					"<html lang=\"en\">\r\n" + 
    					"<head>\r\n" + 
    					"<meta http-equiv=\"Content-Type\" content=\"text/html; charset=UTF-8\" />\r\n" + 
    					"<meta http-equiv=\"X-UA-Compatible\" content=\"IE=edge\">\r\n" + 
    					"<title>그룹웨어 인증번호 발송</title>\r\n" + 
    					"<body style=\"padding:0px; margin:0px;\">\r\n" + 
    					"<div style=\"width:500px;display: table; vertical-align: middle; margin: 0 auto; margin-top:20px; font-family:sans-serif, NSB; font-size:13px; background:url('data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAEoAAABKCAYAAAFr1/LnAAAAGXRFWHRTb2Z0d2FyZQBBZG9iZSBJbWFnZVJlYWR5ccllPAAAA2hpVFh0WE1MOmNvbS5hZG9iZS54bXAAAAAAADw/eHBhY2tldCBiZWdpbj0i77u/IiBpZD0iVzVNME1wQ2VoaUh6cmVTek5UY3prYzlkIj8+IDx4OnhtcG1ldGEgeG1sbnM6eD0iYWRvYmU6bnM6bWV0YS8iIHg6eG1wdGs9IkFkb2JlIFhNUCBDb3JlIDUuMy1jMDExIDY2LjE0NTY2MSwgMjAxMi8wMi8wNi0xNDo1NjoyNyAgICAgICAgIj4gPHJkZjpSREYgeG1sbnM6cmRmPSJodHRwOi8vd3d3LnczLm9yZy8xOTk5LzAyLzIyLXJkZi1zeW50YXgtbnMjIj4gPHJkZjpEZXNjcmlwdGlvbiByZGY6YWJvdXQ9IiIgeG1sbnM6eG1wTU09Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC9tbS8iIHhtbG5zOnN0UmVmPSJodHRwOi8vbnMuYWRvYmUuY29tL3hhcC8xLjAvc1R5cGUvUmVzb3VyY2VSZWYjIiB4bWxuczp4bXA9Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC8iIHhtcE1NOk9yaWdpbmFsRG9jdW1lbnRJRD0ieG1wLmRpZDowNDgwMTE3NDA3MjA2ODExODcxRkU4RjlGQzZCMEQxQyIgeG1wTU06RG9jdW1lbnRJRD0ieG1wLmRpZDo2NEE4ODc5OEYzMjAxMUU2QjczOUNENEFEMkFFNkREMCIgeG1wTU06SW5zdGFuY2VJRD0ieG1wLmlpZDo2NEE4ODc5N0YzMjAxMUU2QjczOUNENEFEMkFFNkREMCIgeG1wOkNyZWF0b3JUb29sPSJBZG9iZSBQaG90b3Nob3AgQ1M2IChNYWNpbnRvc2gpIj4gPHhtcE1NOkRlcml2ZWRGcm9tIHN0UmVmOmluc3RhbmNlSUQ9InhtcC5paWQ6MjRDRkQxNEMxQzIwNjgxMTgyMkFGQzBCODc0QTcyNDIiIHN0UmVmOmRvY3VtZW50SUQ9InhtcC5kaWQ6MDQ4MDExNzQwNzIwNjgxMTg3MUZFOEY5RkM2QjBEMUMiLz4gPC9yZGY6RGVzY3JpcHRpb24+IDwvcmRmOlJERj4gPC94OnhtcG1ldGE+IDw/eHBhY2tldCBlbmQ9InIiPz6NMr63AAAHIElEQVR42mIUW/WfgRjAgsQWwqHmHYhgIqAILgdTyGCyNOUtCONSzYTMORM9RxiHOl4Uhc2fVr0FYWwGInuGoZYvDNlEmAaQ2EdGaPAIEQidd0zIQYAveFjQBYCAB4iZQdYhqwYIIEZiYoZQrBAVI/DYEILFBi6FIDcRCgrU6MIVE/hMgscAC9QH2BQKExvyn3GFOsjUT0D8ByYBEEC4QpwRiAXxePg7FOOMGWJSEAxwQjGKl1jQXWKyLPUaw///4oRMQ8otIAeAvPceFmAILxFhEI5gwfAmoTwKA+nYkhcLGa6AJZY2tHTxiQUpdiABysj4El8xA3Q1Lqk/6ElDiAyXghLib2xh9g4pQhgJFTToAgABWCvfFYCAIIhHIhHyPF7aayl/vhCFuDqatk3juLqPN7t3e/MbjwX4G5TgKjRLP3UkhQzZcqIB86YbUhCrhqQIFi01odTxeRK8WonRxZwGR0TnHgMHy2jFskCyie1IDo1CO7N8hzO1MPOzEOaJyJZKBZXD1VotbkxHw19e29mpKV+jubx3ud8IZh8aulN0/SIip9bZyHktomGkJ9E7nXtmwNaBIWOL3sUKqOsQQOQWtRxIFuADv6CW/6NGsY0O+KGFIqmADYqx1mTkOIodVphSGfDiq5NwOYrYuokaAN4Aw1fI8dPRQcgNOSFcjhLElm7IrGSIrdXQQ40R2VEcROQkegBBZEdxMQwewM5ER8veQlvNoCiswtetIbltD6vVQd1zYthIFTd6d74NV8In2L0HJU5immZ4wDUgxtW9CgfiPWhiP2DR95uG0Yavv7cSW6XKhNybHgTgK7YKWWgAHQRvdjBhaWb8HQAHvUduB2HLfR/pGGpfoW0rolsJ75C6Xew0CJn/lLSnvsISILQq4iWhHQYDX6ANPqIAQABmrSWnYRiITkz6UUEKvQbn4BQ9Blt23IA1J+AuXCSbIhASMS0JGE2ECTO2M7WdjORFpSZ6Hns+702ikfyYJlFrFNbKped/HQo3TUpQttQW2idtcLUYQF0sUItBCyul3tuhiiLl6VUEQJQicyYF5X34BKtcaUY5AKW2cy5YFNeSZrIL6jQUgT53r175QK1gGqu4lLAV0KKRDK+on3YPV0xUFn0es8cM7LGd2A6HbvCyZ8qK4PfOF0b13P8K8OdOeTN7761YXmNsHVz7EnqHqq9NGRJxme4U2FrCMlfch25OJaxvtt0iK+6XF1QOPeEGabtZd/A7EWBBBffD3LTAMUWg7B6Y6YINqoWZmSEOmz4/JBA4rhm9wFj9vaiS8zNr+Ei46UeJ8GFAHWd0cgfIFHmjVRdl/5iBtXbt0+CYLkhqHwZHDW7RzLZ3iravYVqVeE+1w82EgF5dPfrzBIA+hxlAEaJEbv3zJYT3HTJG434MQ9aJPdaB44s75cmuKe6Y9r23DNxRjHTRhW4yVDRrcElGuMbjb2P6tlLgem09a/r7BV6DAsvEEYFoqUu/BGjn2nUSCKLoAKOsCEQaKf0BE3/CRBt7v8LE3tIvoNPK1lgZQ+dnWFrZ+ChEIQorj3UH7+A47mOe+wonuSFZ2GU4c+fOfQ1pJWIxxAYVJk4ocZG6x8gUfvA0yK4lNWBrTi3MblXxe1jSKgJq68KrlweiRJtNTGMFhDU+Shl8W0TR7H1a6b+4cdUYO/apo21YYwbrKBvNFSKogniws4xtE2WrcylJTWswwZtrmigTNaysYR1kIKJhWGAGmiiZNF9aaIDL0Y+yYeUYElsFJwkx7kcrSnFwxDYvFB9s35zsOoPnjuIhD4vWqPQ8arSP7g5ObyXuaqKADt8woqQK/E7/6ZJJ+GQGJGkFY5MdVw1MzjBq6VWRXBdE4ADZzFrccb6MYo33DTFHmvbWz2tW1jRNclccIy73inRJyqHWiJL15xQi5mIlbU3Kgo0yFEMSbiaUqNWiqYLBiSPcTMoMc0XBHvop/z6AXMM1Ha1a7HrlghBEltuFL11fdkC6cI28t6/w3DJro0oFIOocXkkVusddv/Ll3pczX7YUAukFUTMbWsU3I9ADDqauc6CHYoOqBT3uMzKYsUtuipYIw5wbWlxQzjPRbTgl9yDqpEscwppFeMzzVlSjXGQpKW8Zbcv3esDNH7s0XK6yfxgGBcUktTBZcrPAhE238DvdIKdL0DT+9YbggA+Q/w7YEPWtRs32oTN46SQZFDMbx6EvHV82JR/x6MtxBElvvMJEldRVD63n3RV4D3XPQ/CONJoacggXRZxwiqvCfIBBaxYkzAlbav04pxsLqmMP0g31gpEkfAZTplJMHviK8l8tXnjbMjdgxbXsgqGv58jgT0GDlOJarPnF1PiR5FYtg6SRMZI6nfafGJjqjxozpBGj78ASTTohOANtH5l2nG103NEmriHnhtDeSmxgB/XQb1/mF0rgDA1OcKZHKN0mey18AwxGF6N0wsdxAAAAAElFTkSuQmCC') no-repeat left top;\">\r\n" + 
    					"<div style=\"height:70px; line-height:70px; font-size:22px; border-bottom:1px solid #000; padding-bottom:10px; padding-left:90px;\">\r\n" + 
    					"		그룹웨어 <span style=\"color:#058df5;\">인증 번호</span>를 안내드립니다.\r\n" + 
    					"	</div>\r\n" + 
    					"\r\n" + 
    					"	<div style=\"margin-top:20px;\">\r\n" + 
    					"		<table style=\"border-collapse:collapse;border-spacing:0; width:100%;\">\r\n" + 
    					"			<colgroup>\r\n" + 
    					"			<col width=\"50%\"/>\r\n" + 
    					"			<col width=\"\"/>\r\n" + 
    					"			</colgroup>\r\n" + 
    					"			<tr>\r\n" + 
    					"				<th style=\"font-weight:bold; font-size:15px; height:30px; color:#4a4a4a;border: 1px solid #d6d6d6;padding:5px 0; background: #f1f1f1;\">인증 번호</th>\r\n" + 
    					"				<td style=\"font-weight:bold; font-size:15px;color:#4a4a4a;border: 1px solid #d6d6d6;padding:5px 0; text-align:center;\">" + secuNum + "</td>\r\n" + 
    					"			</tr>\r\n" + 
    					"		</table>\r\n" + 
    					"	</div>\r\n" + 
    					"	<div style=\"float:left; padding-top:20px;\">\r\n" + 
    					"		<span style=\"color:#058df5;\">비밀번호찾기 팝업</span>에서 인증번호를 입력 후 다음 단계를 진행해주세요.\r\n" + 
    					"	</div>\r\n" + 
    					"</div>\r\n" + 
    					"\r\n" + 
    					" </body>\r\n" + 
    					"</html>";
    			
    			if(groupInfo.get("groupEmailName") != null && !groupInfo.get("groupEmailName").equals("")) {
    				groupEmailName = groupInfo.get("groupEmailName").toString();
    			}else {
    				groupEmailName = "그룹웨어시스템관리자";
    			}
    			
    			if(groupInfo.get("groupEmailId") != null && !groupInfo.get("groupEmailId").equals("")) {
    				groupEmailId = groupInfo.get("groupEmailId").toString();
    			}  
    			
    			if(groupInfo.get("groupEmailDomain") != null && !groupInfo.get("groupEmailDomain").equals("")) {
    				groupEmailDomain = groupInfo.get("groupEmailDomain").toString();
    			}
    			
    			if(groupInfo.get("outSmtpUseYn") != null && groupInfo.get("outSmtpUseYn").equals("Y")) {
    				smtpServer = groupInfo.get("smtpServer").toString();
    				smtpPort = groupInfo.get("smtpPort").toString();
    				smtpId = groupInfo.get("smtpId").toString();
    				smtpPw = groupInfo.get("smtpPw").toString();
    			}else {
    				
    				//프로퍼티 설정값이 있을경우 우선으로 처리
    				if(!CloudConnetInfo.getBuildType().equals("cloud") && !BizboxAProperties.getProperty("BizboxA.smtp.url").equals("99")) {
    					
    					smtpServer = BizboxAProperties.getProperty("BizboxA.smtp.url");
    					
    					if(!BizboxAProperties.getProperty("BizboxA.smtp.port").equals("99")) {
    						smtpPort = BizboxAProperties.getProperty("BizboxA.smtp.port");
    					}

    					if(BizboxAProperties.getProperty("BizboxA.smtp.auth").equals("Y")) {
    						
        					if(!BizboxAProperties.getProperty("BizboxA.smtp.auth.id").equals("99")) {
        						smtpId = BizboxAProperties.getProperty("BizboxA.smtp.auth.id");		
        					}
    						
        					if(!BizboxAProperties.getProperty("BizboxA.smtp.auth.password").equals("99")) {
        						smtpPw = BizboxAProperties.getProperty("BizboxA.smtp.auth.password");		
        					}
    						
    					}
    					
    				}else if(groupInfo.get("mailUrl") != null && !groupInfo.get("mailUrl").equals("")) {
    					
    					String mailUrl = groupInfo.get("mailUrl").toString();
    					mailUrl = mailUrl.split("://")[1];
    					mailUrl = mailUrl.split("/mail")[0];
    					smtpServer = mailUrl.split(":")[0];
    					
    				}
    			}
    			
    			if(smtpServer.equals("") || groupEmailDomain.equals("")) {
    				mv.addObject("result", "SMTP");
    				mv.addObject("resultMsg","there's no smtpServer");
    				return mv;
    			}
            	
            	//메일전송
    			HtmlEmail email = new HtmlEmail();
    			email.setCharset("UTF-8");
    			email.setHostName(smtpServer);
    			email.setSmtpPort(Integer.parseInt(smtpPort));
    			
    			//TLS or SSL
    			if(groupInfo.get("smtpSecuTp") != null) {
    				if(groupInfo.get("smtpSecuTp").equals("TLS")) {
    					email.setTLS(true);
    				}else if(groupInfo.get("smtpSecuTp").equals("SSL")) {
    					email.setSSL(true);
    				}
    			}
    			
    			if(!smtpId.equals("") && !smtpPw.equals("")) {
    				email.setAuthenticator(new DefaultAuthenticator(smtpId, smtpPw));
    			}
    			
    			email.setSocketConnectionTimeout(60000);
    			email.setSocketTimeout(60000);
    			email.setFrom(groupEmailId + "@" + groupEmailDomain, groupEmailName);
    			email.addTo(empInfo.get("outMail").toString() + "@" + empInfo.get("outDomain").toString());
    			email.setSubject("[그룹웨어 인증번호 메일] 그룹웨어 인증번호입니다.");
    			email.setHtmlMsg(contents);
    			
    			try {
    				email.send();
    				mv.addObject("result", "SUCCESS");
    				request.getSession().setAttribute("findPasswdSecuNum", paramMap.get("loginId").toString() + "|" + secuNum);
    			}catch(Exception ex) {
    				mv.addObject("result", "SMTP");
    				mv.addObject("resultMsg",ex.getMessage());
    			}
            	    			
    		}

    	}else {
    		mv.addObject("result", "FAIL");	
    	}
    	
    	return mv;
    }  

    @RequestMapping(value="/uat/uia/findPasswdCheck.do")
    public ModelAndView findPasswdCheck(HttpServletRequest request, @RequestParam Map<String, Object> paramMap) throws Exception {

    	ModelAndView mv = new ModelAndView();
    	
    	if(request.getSession().getAttribute("findPasswdSecuNum") != null && request.getSession().getAttribute("findPasswdSecuNum").equals(paramMap.get("loginId").toString() + "|" + paramMap.get("findPasswdSecuNum").toString())) {
    		mv.addObject("result", "SUCCESS");
    	}else {
    		mv.addObject("result", "FAIL");
    	}
    	
    	mv.setViewName("jsonView");

    	return mv;
    }     
    

    @RequestMapping(value="/smtpSendProc.do")
    public ModelAndView smtpSendProc(HttpServletRequest request, @RequestParam Map<String, Object> paramMap) throws Exception {

    	ModelAndView mv = new ModelAndView();
    	
    	//메일전송
    	HtmlEmail email = new HtmlEmail();
    	email.setCharset("UTF-8");
    	email.setHostName(paramMap.get("smtpServer").toString());
    	email.setSmtpPort(Integer.parseInt(paramMap.get("smtpPort").toString()));
    	
    	//TLS or SSL
    	if(paramMap.get("smtpSecuTp") != null) {
    		if(paramMap.get("smtpSecuTp").equals("TLS")) {
    			email.setTLS(true);
    		}else if(paramMap.get("smtpSecuTp").equals("SSL")) {
    			email.setSSL(true);
    		}
    	}
    	
    	if(!paramMap.get("smtpId").equals("") && !paramMap.get("smtpPw").equals("")) {
    		email.setAuthenticator(new DefaultAuthenticator(paramMap.get("smtpId").toString(), paramMap.get("smtpPw").toString()));
    	}
    	
    	email.setSocketConnectionTimeout(60000);
    	email.setSocketTimeout(60000);
    	email.setFrom(paramMap.get("from").toString(), paramMap.get("fromName").toString());
    	email.addTo(paramMap.get("to").toString());
    	email.setSubject("[그룹웨어 인증번호 메일] 그룹웨어 인증번호입니다.");
    	email.setHtmlMsg(paramMap.get("contents").toString());
    	
    	try {
    		email.send();
    		mv.addObject("result", "SUCCESS");
    	}catch(Exception ex) {
    		mv.addObject("result", ex.getMessage());
    	}
    	
    	mv.setViewName("jsonView");

    	return mv;
    }
	
    //21년 11월 24일 이지케어텍 고객사에서 패스워드 암호화 처리 관련 요청 사항 처리
	//요청 사항: 
	// 1. 기존 암호화 키보다 더 복잡한 키 적용 요청
	// 2. JSP 파일에 암호화 키를 하드코딩이 아닌 서버에서 내려주는 방식으로 처리
    public int getSecurityEncLevel() {    	
    	String ezcaretechYn = BizboxAProperties.getCustomProperty("BizboxA.Cust.ezcaretechYn");
    	
    	if(ezcaretechYn.equals("Y")) {
    		return 1;
    	} else {
    		return 0;
    	}
    }
    
}