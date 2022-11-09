package neos.cmm.systemx.emp.web;

import java.io.BufferedReader;
import java.io.File;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.io.Reader;
import java.io.StringWriter;
import java.io.Writer;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLDecoder;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Calendar;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.compress.archivers.zip.ZipArchiveEntry;
import org.apache.commons.compress.archivers.zip.ZipArchiveInputStream;
import org.apache.log4j.Logger;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;

import api.poi.service.ExcelService;
import bizbox.orgchart.service.vo.LoginVO;
import egovframework.com.cmm.EgovMessageSource;
import egovframework.com.cmm.annotation.IncludedInfo;
import egovframework.com.cmm.util.EgovUserDetailsHelper;
import egovframework.com.uat.uia.service.EgovLoginService;
import egovframework.com.utl.fcc.service.EgovDateUtil;
import egovframework.com.utl.fcc.service.EgovFileUploadUtil;
import egovframework.com.utl.fcc.service.EgovStringUtil;
import egovframework.com.utl.sim.service.EgovFileTool;
import egovframework.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;
import main.web.BizboxAMessage;
import neos.cmm.common.util.FormatUtil;

import neos.cmm.db.CommonSqlDAO;
import neos.cmm.menu.service.MenuManageService;
import neos.cmm.systemx.author.service.AuthorManageService;
import neos.cmm.systemx.commonOption.service.CommonOptionManageService;
import neos.cmm.systemx.comp.service.CompManageService;
import neos.cmm.systemx.dept.service.DeptManageService;
import neos.cmm.systemx.dutyPosition.sercive.DutyPositionManageService;
import neos.cmm.systemx.emp.service.EmpManageService;
import neos.cmm.systemx.empdept.service.EmpDeptManageService;
import neos.cmm.systemx.file.service.WebAttachFileService;
import neos.cmm.systemx.group.service.GroupManageService;
import neos.cmm.systemx.license.service.LicenseService;
import neos.cmm.systemx.orgAdapter.dao.OrgAdapterDAO;
import neos.cmm.systemx.orgAdapter.service.OrgAdapterService;
import neos.cmm.systemx.orgchart.service.OrgChartService;
import neos.cmm.util.BizboxAProperties;
import neos.cmm.util.CommonUtil;
import neos.cmm.util.HttpJsonUtil;
import neos.cmm.util.ImageUtil;
import neos.cmm.util.MessageUtil;
import neos.cmm.util.NeosConstants;
import neos.cmm.util.code.service.SequenceService;
import neos.cmm.util.FileUtils;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;
import restful.com.controller.AttachFileController;
import cloud.CloudConnetInfo;
import api.drm.service.DrmService;
import sun.misc.BASE64Decoder;

@Controller
public class EmpManageController {

	protected Logger logger = Logger.getLogger( super.getClass( ) );
	/* 변수정의 */
	@Resource ( name = "OrgAdapterService" )
	private OrgAdapterService orgAdapterService;
	@Resource ( name = "EmpDeptManageService" )
	private EmpDeptManageService empDeptManageService;
	@Resource ( name = "OrgChartService" )
	private OrgChartService orgChartService;
	@Resource ( name = "OrgAdapterDAO" )
	private OrgAdapterDAO orgAdapterDAO;
	/** EgovMessageSource */
	@Resource ( name = "egovMessageSource" )
	EgovMessageSource egovMessageSource;
	@Resource ( name = "EmpManageService" )
	private EmpManageService empManageService;
	@Resource ( name = "CompManageService" )
	private CompManageService compService;
	@Resource ( name = "SequenceService" )
	private SequenceService sequenceService;
	@Resource ( name = "DeptManageService" )
	private DeptManageService deptManageService;
	@Resource ( name = "AuthorManageService" )
	private AuthorManageService authorManageService;
	@Resource ( name = "CommonOptionManageService" )
	private CommonOptionManageService commonOptionManageService;
	@Resource ( name = "DutyPositionManageService" )
	private DutyPositionManageService dutyPositionService;
	@Resource ( name = "GroupManageService" )
	private GroupManageService groupManageService;
	@Resource ( name = "ExcelService" )
	private ExcelService excelService;
	@Resource ( name = "WebAttachFileService" )
	WebAttachFileService attachFileService;
	@Resource ( name = "commonSql" )
	private CommonSqlDAO commonSql;
	@Resource ( name = "MenuManageService" )
	private MenuManageService menuManageService;
	@Resource ( name = "LicenseService" )
	private LicenseService licenseService;
	@Resource ( name = "attachFileController" )
	private AttachFileController attachFileController;
	@Resource(name = "DrmService")
	private DrmService drmService;		
	//크로스사이트 요청 위조
	@RequestMapping(value="/cmm/systemx/myInfosaveProc.do", method=RequestMethod.POST)
	public ModelAndView myInfosaveProc ( @RequestParam Map<String, Object> params, HttpServletRequest request ) throws Exception {
		
		LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser( );
		ModelAndView mv = new ModelAndView( "redirect:/cmm/systemx/myInfoManage.do" );
		
		//세션이상
		if(loginVO == null || params.get("empSeq") == null || (!loginVO.getUniqId().equals(params.get("empSeq")))){
			Map<String, Object> resultMap = new HashMap<String, Object>( );
			resultMap.put( "result", BizboxAMessage.getMessage( "TX000009248", "로그인한 세션이 종료되었습니다" ) );
			resultMap.put( "resultCode", "fail" );
			mv.addAllObjects( resultMap );
			return mv;
		}
		
		boolean passwdCheck = true;
		
		Map<String, Object> paramMap = new HashMap<String, Object>( );
		
		//필수, 제한항목 조회
		paramMap.put( "optionList", "'cm1000','cm1014'" );
		Map<String, Object> optionObject = commonOptionManageService.getGroupOptionList( paramMap );

		//그룹옵션설정 체크
		if ( optionObject.get( "cm1000" ) != null && optionObject.get( "cm1000" ).equals( "1" ) ) {
		
			//패스워드
			if ( optionObject.get( "cm1014" ) != null && !optionObject.get( "cm1014" ).equals("") ) {
				
				String cm1014 = optionObject.get( "cm1014" ).toString();
				
				if(cm1014.contains("def")) {
					passwdCheck = false;
				}
			}			
		}

		if(passwdCheck) {
	    	paramMap.put("type", "def");
			paramMap.put("encPasswdOld", CommonUtil.passwordEncrypt(new String(new BASE64Decoder().decodeBuffer(params.get("secuStrBase").toString()),"UTF-8")));
	    	paramMap.put("empSeq", loginVO.getUniqId());

	    	@SuppressWarnings("unchecked")
			Map<String, Object> empInfo = (Map<String, Object>) commonSql.select("OrgAdapterManage.selectEmpPasswdCheck", paramMap);
	    	
	    	//패스워드 체크 실패
	    	if(empInfo != null && !empInfo.get("checkYn").equals("Y")){
				Map<String, Object> resultMap = new HashMap<String, Object>( );
				resultMap.put( "result", BizboxAMessage.getMessage( "TX000002303", "비정상적으로 호출 되었습니다. 다시 선택해 주십시오." ) );
				resultMap.put( "resultCode", "fail" );
				mv.addAllObjects( resultMap );
				return mv;
	    	}			
		}
		
		params.put( "groupSeq", loginVO.getGroupSeq( ) );
		params.put( "compSeq", loginVO.getCompSeq( ) );
		params.put( "deptSeq", loginVO.getOrgnztId( ) );
		params.put( "empSeq", loginVO.getUniqId( ) );
		params.put( "createSeq", loginVO.getUniqId( ) );
		params.put( "callType", "saveMyEmp" );
		if ( params.get( "mainCompLoginYn" ).toString( ).equals( "N" ) ) {
			params.put( "mainCompSeq", params.get( "oriMainCompSeq" ) );
		}
		//수정불가항목 제거
		params.remove( "erpEmpSeq" );
		params.remove( "erpEmpNum" );
		params.remove( "loginPasswdNew" );
		params.remove( "apprPasswdNew" );
		params.remove( "payPasswdNew" );
		params.remove( "positionCode" );
		params.remove( "dutyCode" );
		params.remove( "authCodeList" );
		params.remove( "orderNum" );
		params.remove( "deptSeqNew" );
		params.remove( "useYn" );
		params.remove( "licenseCheckYn" );
		params.remove( "eaType" );
		params.remove( "mainDeptYn" );
		params.remove( "checkWork" );
		params.remove( "workStatus" );
		params.remove( "emailAddr" );
		
		//파라미터명 보정
		params.put( "empName", params.get( "empNameKr" ) );
		params.put( "genderCode", params.get( "mf" ) );
		params.put( "telNum", params.get( "comptel" ) );
		params.put( "homeTelNum", params.get( "hometel" ) );
		params.put( "mobileTelNum", params.get( "phone" ) );
		params.put( "faxNum", params.get( "fax" ) );
		params.put( "deptZipCode", params.get( "compZipCode" ) );
		params.put( "deptAddr", params.get( "comp_addr" ) );
		params.put( "deptDetailAddr", params.get( "comp_detailaddr" ) );
		params.put( "addr", params.get( "home_addr" ) );
		params.put( "detailAddr", params.get( "home_detailaddr" ) );
		params.put( "bday", params.get( "birthday_date" ) );
		params.put( "weddingDay", params.get( "wedding_date" ) );
		
		mv.addAllObjects( orgAdapterService.empSaveAdapter( params ) );
		
		// mailSync호출
		if(params.get("compSeq") != null){
			orgAdapterService.mailUserSync(params);	    					
		} 			
		
		//다국어코드 변경시 세션에 적용
		if ( params.get( "nativeLangCode" ) != null && params.get( "oldLangCode" ) != null && params.get( "nativeLangCode" ).toString( ) != params.get( "oldLangCode" ).toString( ) ) {
			loginVO.setLangCode( params.get( "nativeLangCode" ).toString( ) );
			request.getSession( ).setAttribute( "loginVO", loginVO );
			request.getSession( ).setAttribute( "langCode", params.get( "nativeLangCode" ).toString( ) );
		}
		
		//메일주소 세션에 적용
		Map<String, Object> mailMap = (Map<String, Object>) commonSql.select("EmpManage.getEmpEmailInfo", params);
		loginVO.setEmail( mailMap.get( "email" ).toString( ) );
		loginVO.setEmailDomain( mailMap.get( "emailDomain" ).toString( ) );
		request.getSession( ).setAttribute( "loginVO", loginVO );
		
		mv.addObject("saveFlag", true);
		
		return mv;
	}

	@Resource ( name = "loginService" )
	private EgovLoginService loginService;

	@RequestMapping ( "/cmm/systemx/myInfoManage.do" )
	public ModelAndView myInfoManage ( @RequestParam Map<String, Object> params, HttpServletRequest request ) throws Exception {
		ModelAndView mv = new ModelAndView( );
		LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser( );
		
		if(!menuManageService.checkMenuAuth(loginVO, request.getServletPath())) {
			mv.setViewName( "redirect:/forwardIndex.do" );
			return mv;
		}
		
		params.put( "empSeq", loginVO.getUniqId( ) );
		params.put( "groupSeq", loginVO.getGroupSeq( ) );
		params.put( "langCode", loginVO.getLangCode( ) );
		params.put( "compSeq", loginVO.getCompSeq( ) );
		params.put( "deptSeq", loginVO.getOrgnztId() );
		params.put( "compSeqOld", loginVO.getCompSeq( ) );
		params.put( "mainYn", "Y" );
		params.put( "subYn", "Y" );
		params.put( "eaType", loginVO.getEaType() );
		List<Map<String, Object>> langList = orgChartService.getGroupLangList( params );
		mv.addObject( "langList", langList );
		Map<String, Object> infoMap = empManageService.selectEmpInfo( params, new PaginationInfo( ) );
		Map<String, Object> erpMap = compService.getErpEmpInfo( params );
		List<Map<String, Object>> list = (List<Map<String, Object>>) infoMap.get( "list" );
		Map<String, Object> map = list.get( 0 );
		List<Map<String, Object>> complist = null;
		params.remove( "compSeq" );
		complist = compService.getMyCompList( params );
		//메일 도메인 얻어오기 위해 주회사(main_comp_seq) 정보 조회.
		params.put( "compSeq", map.get( "mainCompSeq" ) );
		Map<String, Object> compMap = compService.getCompAdmin( params );
		//필수, 제한항목 조회
		params.put( "optionList", "'cm1100','cm1103','cm1104','cm1105','cm1106','cm1107','cm1108','cm1109','cm2000','cm1000','cm1001','cm1002','cm1003','cm1004','cm1006','cm1007','cm1008','cm1009','cm1010','cm1011','cm1012','cm1013','cm1014'" );
		Map<String, Object> optionObject = commonOptionManageService.getGroupOptionList( params );
		Map<String, Object> userRestricted = new HashMap<String, Object>( );
		Map<String, Object> userRequired = new HashMap<String, Object>( );
		//ERP옵션설정 체크
		if ( optionObject.get( "cm1100" ) != null && optionObject.get( "cm1100" ).equals( "1" ) && optionObject.get( "cm1103" ) != null && optionObject.get( "cm1103" ).equals( "1" ) ) {
			//생년월일
			if ( optionObject.get( "cm1105" ) != null && optionObject.get( "cm1105" ).equals( "1" ) ) {
				userRestricted.put( "bday", "Y" );
			}
			//결혼 기념일
			if ( optionObject.get( "cm1106" ) != null && optionObject.get( "cm1106" ).equals( "1" ) ) {
				userRestricted.put( "weddingDay", "Y" );
			}
			//전화번호
			if ( optionObject.get( "cm1107" ) != null && optionObject.get( "cm1107" ).equals( "1" ) ) {
				userRestricted.put( "homeTelNum", "Y" );
				userRestricted.put( "telNum", "Y" );
				userRestricted.put( "mobileTelNum", "Y" );
			}
			//집주소
			if ( optionObject.get( "cm1108" ) != null && optionObject.get( "cm1108" ).equals( "1" ) ) {
				userRestricted.put( "homeAddr", "Y" );
			}
			//사용자명
			if ( optionObject.get( "cm1109" ) != null && optionObject.get( "cm1109" ).equals( "1" ) ) {
				userRestricted.put( "empName", "Y" );
			}
			//ERP전송여부
			if ( optionObject.get( "cm1104" ) != null && optionObject.get( "cm1104" ).equals( "1" ) ) {
				userRestricted.put( "erpSyncYn", "Y" );
			}
		}
		//그룹옵션설정 체크
		if ( optionObject.get( "cm1000" ) != null && optionObject.get( "cm1000" ).equals( "1" ) ) {
			//프로필이미지
			if ( optionObject.get( "cm1001" ) != null && optionObject.get( "cm1001" ).equals( "1" ) ) {
				userRestricted.put( "picImg", "Y" );
			}
			//사인이미지
			if ( optionObject.get( "cm1002" ) != null && optionObject.get( "cm1002" ).equals( "1" ) ) {
				userRestricted.put( "signImg", "Y" );
			}
			//담당업무
			if ( optionObject.get( "cm1003" ) != null && optionObject.get( "cm1003" ).equals( "1" ) ) {
				userRestricted.put( "mainWork", "Y" );
			}
			//사용자명
			if ( optionObject.get( "cm1004" ) != null && optionObject.get( "cm1004" ).equals( "1" ) ) {
				userRestricted.put( "empName", "Y" );
			}
			//전화번호(회사)
			if ( optionObject.get( "cm1006" ) != null && optionObject.get( "cm1006" ).equals( "1" ) ) {
				userRestricted.put( "telNum", "Y" );
			}
			//전화번호(집)
			if ( optionObject.get( "cm1007" ) != null && optionObject.get( "cm1007" ).equals( "1" ) ) {
				userRestricted.put( "homeTelNum", "Y" );
			}
			//주소(회사)
			if ( optionObject.get( "cm1008" ) != null && optionObject.get( "cm1008" ).equals( "1" ) ) {
				userRestricted.put( "addr", "Y" );
			}
			//주소(집)
			if ( optionObject.get( "cm1009" ) != null && optionObject.get( "cm1009" ).equals( "1" ) ) {
				userRestricted.put( "homeAddr", "Y" );
			}
			//팩스번호
			if ( optionObject.get( "cm1010" ) != null && optionObject.get( "cm1010" ).equals( "1" ) ) {
				userRestricted.put( "faxNum", "Y" );
			}
			//휴대전화
			if ( optionObject.get( "cm1011" ) != null && optionObject.get( "cm1011" ).equals( "1" ) ) {
				userRestricted.put( "mobileTelNum", "Y" );
			}
			//기념일 공개여부
			if ( optionObject.get( "cm1012" ) != null && optionObject.get( "cm1012" ).equals( "1" ) ) {
				userRestricted.put( "anniversaryOpen", "Y" );
			}
			//개인매일
			if ( optionObject.get( "cm1013" ) != null && optionObject.get( "cm1013" ).equals( "1" ) ) {
				userRestricted.put( "outMail", "Y" );
			}
			//패스워드
			if ( optionObject.get( "cm1014" ) != null && !optionObject.get( "cm1014" ).equals("") ) {
				
				String cm1014 = optionObject.get( "cm1014" ).toString();
				
				if(cm1014.contains("def")) {
					userRestricted.put( "password_def", "Y" );
				}
				
				if(cm1014.contains("app")) {
					userRestricted.put( "password_app", "Y" );
				}
				
				if(cm1014.contains("pay")) {
					userRestricted.put( "password_pay", "Y" );
				}
				
			}			
			
		}
		//메일 전용계정 설정
		if ( loginVO.getLicenseCheckYn( ) == "2" ) {
			userRestricted.put( "signImg", "Y" );
			userRestricted.put( "mainWork", "Y" );
			userRestricted.put( "bday", "Y" );
			userRestricted.put( "weddingDay", "Y" );
			userRestricted.put( "homeTelNum", "Y" );
			userRestricted.put( "telNum", "Y" );
			userRestricted.put( "mobileTelNum", "Y" );
			userRestricted.put( "homeAddr", "Y" );
			userRestricted.put( "addr", "Y" );
			userRestricted.put( "faxNum", "Y" );
		}
		//필수항목 설정
		if ( optionObject.get( "cm2000" ) != null && !optionObject.get( "cm2000" ).equals( "" ) ) {
			String cm2000Val = optionObject.get( "cm2000" ).toString( ).toLowerCase( );
			//a:사진, b:사인, c:담당업무, d:이름, f:전화번호(회사), g:전화번호(집), h:주소(회사), i:주소(집), j:팩스번호, k:휴대전화, l:개인메일
			if ( cm2000Val.contains( "a" ) && userRestricted.get( "picImg" ) == null ) {
				userRequired.put( "picImg", "Y" );
			}
			if ( cm2000Val.contains( "b" ) && userRestricted.get( "signImg" ) == null ) {
				userRequired.put( "signImg", "Y" );
			}
			if ( cm2000Val.contains( "c" ) && userRestricted.get( "mainWork" ) == null ) {
				userRequired.put( "mainWork", "Y" );
			}
			if ( cm2000Val.contains( "d" ) && userRestricted.get( "empName" ) == null ) {
				userRequired.put( "empName", "Y" );
			}
			if ( cm2000Val.contains( "f" ) && userRestricted.get( "telNum" ) == null ) {
				userRequired.put( "telNum", "Y" );
			}
			if ( cm2000Val.contains( "g" ) && userRestricted.get( "homeTelNum" ) == null ) {
				userRequired.put( "homeTelNum", "Y" );
			}
			if ( cm2000Val.contains( "h" ) && userRestricted.get( "addr" ) == null ) {
				userRequired.put( "addr", "Y" );
			}
			if ( cm2000Val.contains( "i" ) && userRestricted.get( "homeAddr" ) == null ) {
				userRequired.put( "homeAddr", "Y" );
			}
			if ( cm2000Val.contains( "j" ) && userRestricted.get( "faxNum" ) == null ) {
				userRequired.put( "faxNum", "Y" );
			}
			if ( cm2000Val.contains( "k" ) && userRestricted.get( "mobileTelNum" ) == null ) {
				userRequired.put( "mobileTelNum", "Y" );
			}
			if ( cm2000Val.contains( "l" ) && userRestricted.get( "outMail" ) == null ) {
				userRequired.put( "outMail", "Y" );
			}
		}
		if ( request.getRequestURL( ).toString( ).indexOf( "https://" ) != -1 ) {
			mv.addObject( "isSecure", "Y" );
		}
		else {
			mv.addObject( "isSecure", "N" );
		}
		//폐쇄망 사용유무 커스텀 프로퍼티에서 조회.
		//폐쇄망일 경우 우편번호검색(다음api) 사용불가.
		if ( !BizboxAProperties.getCustomProperty( "BizboxA.ClosedNetworkYn" ).equals( "99" ) ) {
			if ( BizboxAProperties.getCustomProperty( "BizboxA.ClosedNetworkYn" ).equals( "Y" ) ) {
				mv.addObject( "ClosedNetworkYn", "Y" );
			}
		}
		mv.addObject( "userRequired", userRequired );
		mv.addObject( "userRestricted", userRestricted );
		mv.addObject( "selectList", complist );
		mv.addObject( "erpMap", erpMap );
		mv.addObject( "infoMap", map );
		mv.addObject( "compMap", compMap );
		mv.addObject( "loginVO", loginVO );
		mv.addObject( "saveFlag", params.get("saveFlag"));
		
		if(CloudConnetInfo.getBuildType().equals("cloud")){
			mv.addObject("profilePath", "/upload/" + loginVO.getGroupSeq() + "/img/profile/" + loginVO.getGroupSeq());
		}else{
			mv.addObject("profilePath", "/upload/img/profile/" + loginVO.getGroupSeq());
		}		
		
		mv.setViewName( "/neos/cmm/systemx/emp/myInfoManage" );
		return mv;
	}

	@RequestMapping ( "/cmm/systemx/myinfoZipPop.do" )
	public ModelAndView myinfoZipPop ( @RequestParam Map<String, Object> params, HttpServletRequest request ) {
		ModelAndView mv = new ModelAndView( );
		mv.setViewName( "/neos/cmm/systemx/emp/pop/myInfoZipPop" );
		return mv;
	}

	@IncludedInfo ( name = "사원정보관리", order = 150, gid = 60 )
	@RequestMapping ( "/cmm/systemx/empManageView.do" )
	public ModelAndView empManageView ( @RequestParam Map<String, Object> params, PaginationInfo paginationInfo, HttpServletRequest request ) throws Exception {
		LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser( );
		params.put( "groupSeq", loginVO.getGroupSeq());
		params.put( "compSeq", loginVO.getOrganId());
		params.put( "empSeq", loginVO.getUniqId());
		params.put( "userSe", loginVO.getUserSe());
		params.put( "langCode", loginVO.getLangCode());
		
		/** 그룹 정보 가져오기. 그룹명 가져오기 위해 */
		Map<String, Object> groupMap = orgChartService.getGroupInfo( params );
		ModelAndView mv = new ModelAndView( );
		boolean isAuthMenu = menuManageService.checkIsAuthMenu( params, loginVO );
		if ( !isAuthMenu ) {
			mv.setViewName( "redirect:/forwardIndex.do" );
			return mv;
		}
		mv.addObject( "groupMap", groupMap );
		String compSeq = FormatUtil.getString( params.get( "compSeq" ) );
		String groupSeq = FormatUtil.getString( params.get( "groupSeq" ) );
		
		if ( EgovStringUtil.isEmpty( compSeq ) ) {
			if ( loginVO.getUserSe( ).equals( "MASTER" ) ) {
				CommonUtil.getSessionData( request, "compSeq", params );
			}
			else {
				params.put( "compSeq", loginVO.getCompSeq( ) );
			}
		}
		if ( EgovStringUtil.isEmpty( groupSeq ) ) {
			params.put( "groupSeq", loginVO.getGroupSeq( ) );
		}
		
		//패스워드 초기화 요청리스트 조회
		List<Map<String, Object>> findPasswdEmpList = (List<Map<String, Object>>) commonSql.list("OrgAdapterManage.selectFindPasswdEmpList", params);
		mv.addObject("findPasswdEmpList", JSONArray.fromObject(findPasswdEmpList));		

		/** 회사 리스트 조회 */
		String userSe = loginVO.getUserSe( );
		List<Map<String, Object>> compList = null;
		if ( userSe != null && userSe.equals( "MASTER" ) ) {
			compList = compService.getCompListAuth( params );
		}
		mv.addObject( "compList", compList );
		JSONArray json = JSONArray.fromObject( compList );
		mv.addObject( "compListJson", json );
		mv.addObject( "loginVO", loginVO );
		mv.addObject( "params", params );
		mv.setViewName( "/neos/cmm/systemx/emp/empManageView" );
		return mv;
	}

	@RequestMapping ( "/cmm/systemx/empResignPop.do" )
	public ModelAndView empResignPop ( @RequestParam Map<String, Object> params, PaginationInfo paginationInfo, HttpServletRequest request ) throws Exception {
		LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser( );
		ModelAndView mv = new ModelAndView( );
		String isMailUse = EgovStringUtil.isNullToString( empManageService.isMailUse( params ) );
		//마스터권한 가지고 있는지 유무체크
		String isMasterAuth = empManageService.getEmpMasterAuth( params );
		if ( !isMasterAuth.equals( "0" ) ) {
			//마스터권한 사용자 리스트 조회(유일한 마스터권한 사용자인 경우 마스터권한 삭제처리 불가처리하기 위해)
			Map<String, Object> para = new HashMap<String, Object>();
			para.put("groupSeq", loginVO.getGroupSeq());
			para.put("langCode", loginVO.getLangCode());
			List<Map<String, Object>> masterAuthList = commonSql.list("AuthorManageDAO.getAuthorMasterList", para);
			
			mv.addObject("masterAuthCnt", masterAuthList.size());
			mv.addObject( "isMasterAuth", "Y" );
		}
		else {
			mv.addObject( "isMasterAuth", "N" );
		}
		
		
		//겸직회사중 같은 메일도메인 사용회사가 있는지 체크.
		Map<String, Object> empDeptCntInfo = (Map<String, Object>) commonSql.select("EmpManage.getCompMailDomainCntInfo", params);
		
		if(empDeptCntInfo.get("targetWorkStatus") != null && empDeptCntInfo.get("targetWorkStatus").equals("001")) {
			empDeptCntInfo.put("empMailDomainCount", commonSql.select("EmpManage.selectEmpMailDomainCount", params));
		}
		
		mv.addObject("empDeptCntInfo", empDeptCntInfo);
		
		mv.addObject( "loginVO", loginVO );
		mv.addObject( "isMailUse", isMailUse );
		mv.addObject( "params", params );
		mv.setViewName( "/neos/cmm/systemx/emp/pop/empResignPop" );
		return mv;
	}

	@RequestMapping ( "/cmm/systemx/empListData.do" )
	public ModelAndView empListData ( @RequestParam Map<String, Object> params, HttpServletRequest request ) throws Exception {
		LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser( );
		params.put( "langCode", loginVO.getLangCode( ) );
		String compSeq = FormatUtil.getString( params.get( "compSeq" ) );
		String groupSeq = FormatUtil.getString( params.get( "groupSeq" ) );
		if ( EgovStringUtil.isEmpty( compSeq ) ) {
			if ( !loginVO.getUserSe( ).equals( "MASTER" ) ) {
				//				 CommonUtil.getSessionData(request, "compSeq", params);
				//			 } else {
				params.put( "compSeq", loginVO.getCompSeq( ) );
			}
		}
		if ( EgovStringUtil.isEmpty( groupSeq ) ) {
			params.put( "groupSeq", loginVO.getGroupSeq( ) );
		}
		params.put( "groupSeq", loginVO.getGroupSeq( ) );
		/** 그룹 정보 가져오기. 그룹명 가져오기 위해 */
		Map<String, Object> groupMap = orgChartService.getGroupInfo( params );
		ModelAndView mv = new ModelAndView( );
		mv.addObject( "groupMap", groupMap );
		PaginationInfo paginationInfo = new PaginationInfo( );
		String noPage = FormatUtil.getString( params.get( "isNoPage" ) );
		if ( !noPage.equals( "true" ) ) {
			paginationInfo.setCurrentPageNo( EgovStringUtil.zeroConvert( params.get( "page" ) ) );
			paginationInfo.setPageSize( EgovStringUtil.zeroConvert( params.get( "pageSize" ) ) );
		}
		params.put( "orderBy", "v.emp_name" ); //사원 이름순으로 기본 정렬.
		Map<String, Object> listMap = empManageService.selectEmpInfo( params, paginationInfo );
		List<Map<String, Object>> list = (List<Map<String, Object>>) listMap.get( "list" );
		for ( Map<String, Object> mp : list ) {
			if ( mp.get( "workStatus" ).toString( ).equals( "999" ) ) {
				mp.put( "workStatusNm", BizboxAMessage.getMessage( "TX000010068", "재직" ) );}
			else if ( mp.get( "workStatus" ).toString( ).equals( "001" ) ) {
				mp.put( "workStatusNm", BizboxAMessage.getMessage( "TX000008312", "퇴직" ) );}
			else if ( mp.get( "workStatus" ).toString( ).equals( "002" ) ) {
				mp.put( "workStatusNm", BizboxAMessage.getMessage( "TX000010067", "휴직" ) );}
			if ( mp.get( "useYn" ).toString( ).equals( "Y" ) ) {
				mp.put( "useYn2", BizboxAMessage.getMessage( "TX000000180", "사용" ) );}
			else if ( mp.get( "useYn" ).toString( ).equals( "N" ) ) {
				mp.put( "useYn2", BizboxAMessage.getMessage( "TX000001243", "미사용" ) );}
			if ( mp.get( "licenseCheckYn" ).toString( ).equals( "2" ) ) {
				mp.put( "licenseCheck", BizboxAMessage.getMessage( "TX000000262", "메일" ) );}
			else if ( mp.get( "licenseCheckYn" ).toString( ).equals( "3" ) ) {
				mp.put( "licenseCheck", BizboxAMessage.getMessage( "TX000017901", "비라이선스" ) );}
			else {
				mp.put( "licenseCheck", BizboxAMessage.getMessage( "TX000005020", "그룹웨어" ) );}
		}
		mv.addAllObjects( listMap );
		mv.setViewName( "jsonView" );
		return mv;
	}

	@RequestMapping ( "/cmm/systemx/empListDataNew.do" )
	public ModelAndView empListDataNew ( @RequestParam Map<String, Object> params, HttpServletRequest request ) throws Exception {
		LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser( );
		
		ModelAndView mv = new ModelAndView( );
		mv.setViewName( "jsonView" );
		
		//보안취약점 조치(관리자/마스터권한 체크) 2020.09.09
		if(loginVO == null || loginVO.getUserSe().equals("USER") || (loginVO.getUserSe().equals("ADMIN") && !params.get("compSeq").equals(loginVO.getCompSeq()))) {
			params = new HashMap<String, Object>( );
			params.put("resultCode", "fail");
			params.put("result", BizboxAMessage.getMessage( "TX000008060", "권한이 없습니다" ));
			mv.addAllObjects( params );
			return mv;
		}		
		
		String searchTxt = FormatUtil.getString( params.get( "nameAndLoginId" ) );
		searchTxt = searchTxt.replaceAll( "_", "▩_" );
		params.put( "nameAndLoginId", searchTxt );
		params.put( "langCode", loginVO.getLangCode( ) );
		String compSeq = FormatUtil.getString( params.get( "compSeq" ) );
		if ( EgovStringUtil.isEmpty( compSeq ) ) {
			if ( !loginVO.getUserSe( ).equals( "MASTER" ) ) {
				params.put( "compSeq", loginVO.getCompSeq( ) );
			}
		}
		params.put( "groupSeq", loginVO.getGroupSeq( ) );
		
		PaginationInfo paginationInfo = new PaginationInfo( );
		String noPage = FormatUtil.getString( params.get( "isNoPage" ) );
		if ( !noPage.equals( "true" ) ) {
			paginationInfo.setCurrentPageNo( EgovStringUtil.zeroConvert( params.get( "page" ) ) );
			paginationInfo.setPageSize( EgovStringUtil.zeroConvert( params.get( "pageSize" ) ) );
		}
		Map<String, Object> listMap = empManageService.selectEmpInfoNew( params, paginationInfo );
		mv.addAllObjects( listMap );
		return mv;
	}

	@RequestMapping ( "/cmm/systemx/empLoginIdCheck.do" )
	public ModelAndView empLoginIdCheck ( @RequestParam Map<String, Object> params, HttpServletRequest request ) throws Exception {
		LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser( );
		params.put( "langCode", loginVO.getLangCode( ) );
		String compSeq = FormatUtil.getString( params.get( "compSeq" ) );
		String groupSeq = FormatUtil.getString( params.get( "groupSeq" ) );
		if ( EgovStringUtil.isEmpty( compSeq ) ) {
			if ( loginVO.getUserSe( ).equals( "MASTER" ) ) {
				CommonUtil.getSessionData( request, "compSeq", params );
			}
			else {
				params.put( "compSeq", loginVO.getCompSeq( ) );
			}
		}
		if ( EgovStringUtil.isEmpty( groupSeq ) ) {
			params.put( "groupSeq", loginVO.getGroupSeq( ) );
		}
		String result = empManageService.selectEmpDuplicate( params );
		ModelAndView mv = new ModelAndView( );
		mv.addObject( "result", result );
		mv.setViewName( "jsonView" );
		return mv;
	}

	@RequestMapping ( "/cmm/systemx/empLoginIdSaveProc.do" )
	public ModelAndView empLoginIdSaveProc ( @RequestParam Map<String, Object> params, HttpServletRequest request ) throws Exception {
		LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser( );
		ModelAndView mv = new ModelAndView( );
		
		if(loginVO != null && !loginVO.getUserSe().equals("USER")) {
			params.put( "groupSeq", loginVO.getGroupSeq( ) );
			params.put( "createSeq", loginVO.getUniqId( ) );
			if ( params.get( "emailId" ) != null ) {
				params.put( "emailAddr", params.get( "emailId" ) );
			}
			mv.addAllObjects( orgAdapterService.empLoginEmailIdModifyAdapter( params ) );
			// mailSync호출
			if ( params.get( "compSeq" ) != null ) {
				orgAdapterService.mailUserSync(params);
			}
		}
		
		mv.setViewName( "jsonView" );
		return mv;
	}
	
	@RequestMapping ( "/cmm/systemx/empLoginPasswdResetProc.do" )
	public ModelAndView empLoginPasswdResetProc ( @RequestParam Map<String, Object> params, HttpServletRequest request ) throws Exception {
		
		ModelAndView mv = new ModelAndView( );
		
		LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser( );
		
		if((loginVO.getUserSe().equals("ADMIN") || loginVO.getUserSe().equals("MASTER")) && !params.get("newPasswd").equals("")){
			params.put( "groupSeq", loginVO.getGroupSeq( ) );
			params.put( "createSeq", loginVO.getUniqId( ) );
			params.put( "loginPasswd", CommonUtil.passwordEncrypt( params.get( "newPasswd" ).toString( ) ) );
			
			if(params.get("empSeqArray") != null) {
				JSONArray ja = JSONArray.fromObject(params.get("empSeqArray"));
				
				for (int i = 0; i < ja.size(); i++) {
					JSONObject jsonObject = JSONObject.fromObject(ja.get(i));
					Map<String,Object> item =  new HashMap<String,Object>();
					params.put("empSeq", jsonObject.get("empSeq"));
					
					mv.addAllObjects( orgAdapterService.empLoginPasswdResetProc( params ) );
				}				
				
			}else {
				mv.addAllObjects( orgAdapterService.empLoginPasswdResetProc( params ) );	
			}
			
			// mailSync호출
			if ( params.get( "compSeq" ) != null ) {
				orgAdapterService.mailUserSync(params);
			}			
		}
		
		mv.setViewName( "jsonView" );
		return mv;
	}	

	@RequestMapping ( "/cmm/systemx/myInfo.do" )
	public ModelAndView myInfo ( @RequestParam Map<String, Object> params, HttpServletRequest request ) throws Exception {
		ModelAndView mv = new ModelAndView( );
		LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser( );
		params.put( "empSeq", loginVO.getUniqId( ) );
		params.put( "groupSeq", loginVO.getGroupSeq( ) );
		params.put( "langCode", loginVO.getLangCode( ) );
		params.put( "compSeq", loginVO.getCompSeq( ) );
		params.put( "mainYn", "Y" );
		params.put( "subYn", "Y" );
		List<Map<String, Object>> langList = orgChartService.getCompLangList( params );
		mv.addObject( "langList", langList );
		Map<String, Object> infoMap = empManageService.selectEmpInfo( params, new PaginationInfo( ) );
		List<Map<String, Object>> list = (List<Map<String, Object>>) infoMap.get( "list" );
		Map<String, Object> map = list.get( 0 );
		mv.addObject( "infoMap", map );
		
		if(CloudConnetInfo.getBuildType().equals("cloud")){
			mv.addObject("profilePath", "/upload/" + loginVO.getGroupSeq() + "/img/profile/" + loginVO.getGroupSeq());
		}else{
			mv.addObject("profilePath", "/upload/img/profile/" + loginVO.getGroupSeq());
		}		
		
		mv.setViewName( "/neos/cmm/systemx/emp/myInfoManage" );
		return mv;
	}

	@RequestMapping ( "/cmm/systemx/empInfoPop.do" )
	public ModelAndView empInfoPop ( @RequestParam Map<String, Object> params, PaginationInfo paginationInfo, HttpServletRequest request ) throws Exception {
		LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser( );
		
		ModelAndView mv = new ModelAndView();
		
		if ( loginVO == null || (!"MASTER".equals(loginVO.getUserSe()) && !"ADMIN".equals(loginVO.getUserSe())) ) {
			mv.setViewName( "redirect:/forwardIndex.do" );
			return mv;
		}
		
		params.put( "groupSeq", loginVO.getGroupSeq( ) );
		Enumeration enu = request.getAttributeNames( );
		while ( enu.hasMoreElements( ) ) {
			String key = (String) enu.nextElement( );
		}
		/** 그룹 정보 가져오기. 그룹명 가져오기 위해 */
		Map<String, Object> groupMap = orgChartService.getGroupInfo( params );
		mv.addObject( "groupMap", groupMap );
		mv.addObject( "eaType", loginVO.getEaType( ) );
		String compSeq = FormatUtil.getString( params.get( "compSeq" ) );
		String groupSeq = FormatUtil.getString( params.get( "groupSeq" ) );
		params.put( "langCode", loginVO.getLangCode( ) );
		if ( EgovStringUtil.isEmpty( compSeq ) ) {
			params.put( "compSeq", loginVO.getCompSeq( ) );
		}
		if ( EgovStringUtil.isEmpty( groupSeq ) ) {
			params.put( "groupSeq", loginVO.getGroupSeq( ) );
		}

		String empSeq = FormatUtil.getString( params.get( "empSeq" ) );
		JSONArray json = new JSONArray( );
		if ( !EgovStringUtil.isEmpty( empSeq ) ) {
			Map<String, Object> listMap = empManageService.selectEmpInfo( params, new PaginationInfo( ) );
			@SuppressWarnings ( "unchecked" )
			List<Map<String, Object>> list = (List<Map<String, Object>>) listMap.get( "list" );
			mv.addObject( "empInfoList", list );
			String deptSeq = "";
			if ( list != null && list.size( ) > 0 ) {
				Map<String, Object> map = list.get( 0 );
				String[] empNameMulti = map.get( "empNameMulti" ).toString( ).split( "▦", -1 );
				map.put( "empName", empNameMulti[0] );
				map.put( "empNameEn", empNameMulti[1] );
				map.put( "empNameJp", empNameMulti[2] );
				map.put( "empNameCn", empNameMulti[3] );
				mv.addObject( "infoMap", map );
				/** 사용자 권한 정보 가져오기 */
				Map<String, Object> authMap = new HashMap<String, Object>( );
				deptSeq = EgovStringUtil.isNullToString( map.get( "deptSeq" ) );
				authMap.put( "empSeq", map.get( "empSeq" ) );
				authMap.put( "dutyCode", map.get( "dutyCode" ) );
				authMap.put( "positionCode", map.get( "positionCode" ) );
				authMap.put( "deptSeq", deptSeq );
				authMap.put( "langCode", loginVO.getLangCode( ) );
				authMap.put( "groupSeq", loginVO.getGroupSeq( ) );
				authMap.put( "compSeq", compSeq );
				authMap.put( "authFlag", "Y" ); //사용자, 관리자 권한만 가져오기위한 플레그
				List<Map<String, Object>> authList = empManageService.selectEmpCurAuthList( authMap );
				String authHtml = "";
				int cnt = 1;
				for ( Map<String, Object> authmap : authList ) {
					authHtml += "<tr><td><input type='checkbox' name='all_chk' id='all_chk" + cnt + "' class='k-checkbox' ";
					if ( authmap.get( "userAuth" ) != null ) {
						authHtml += "checked='checked'/>";
					}
					else {
						authHtml += "/>";
					}
					authHtml += "<label class='k-checkbox-label bdChk' for='all_chk" + cnt + "'></label>";
					authHtml += "<input type='hidden' id='authorCode" + cnt + "' value='" + authmap.get( "authorCode" ).toString( ) + "'/></td>";
					authHtml += "<td class='le'>" + authmap.get( "authorNm" ) + "</td></tr>";
					cnt++;
				}
				mv.addObject( "authCurHtml", authHtml );
			}
			//erp사번 정보 가져오기 (t_co_erp_emp)
			params.put( "compSeqOld", params.get( "compSeq" ) );
			Map<String, Object> erpMap = compService.getErpEmpInfo( params );
			mv.addObject( "erpMap", erpMap );
			//소속근무조 가져오기(t_at_work_team_member)
			params.put( "deptSeq", deptSeq );
			Map<String, Object> teamWorkMap = compService.getTeamWorkInfo( params );
			mv.addObject( "teamWorkMap", teamWorkMap );
		}
		else {
			Map<String, Object> infoMap = new HashMap<String, Object>( );
			infoMap.put( "compSeq", params.get( "compSeq" ) );
			infoMap.put( "groupSeq", params.get( "groupSeq" ) );
			infoMap.put( "stamp", "stamp_de" );
			mv.addObject( "infoMap", infoMap );
		}
		if ( loginVO.getUserSe( ).equals( "MASTER" ) && EgovStringUtil.isEmpty( empSeq ) ) {
			Map<String, Object> infoMap = new HashMap<String, Object>( );
			infoMap.put( "compSeq", "" );
			infoMap.put( "groupSeq", params.get( "groupSeq" ) );
			infoMap.put( "stamp", "stamp_de" );
			mv.addObject( "infoMap", infoMap );
		}
		Map<String, Object> compMap = new HashMap<String, Object>( );
		compMap.put( "compSeq", "" );
		compMap.put( "groupSeq", params.get( "groupSeq" ) );
		compMap.put( "langCode", loginVO.getLangCode( ) );
		/** 마스터계정은 회사 선택 가능 */
		List<Map<String, Object>> compList = compService.getCompList( compMap );
		JSONArray jsonComp = new JSONArray( );
		jsonComp = JSONArray.fromObject( compList );
		mv.addObject( "compList", jsonComp );
		mv.addObject( "userSe", loginVO.getUserSe( ) );
		mv.addObject( "authList", json );
		mv.addObject( "flag", params.get( "flag" ) );
		params.put( "mainYn", "Y" );
		params.put( "subYn", "Y" );
		//List<Map<String,Object>> langList = orgChartService.getCompLangList(params);
		List<Map<String, Object>> langList = orgChartService.getGroupLangList( params );
		mv.addObject( "langList", langList );
		mv.addObject( "erpEmpOptions", "N" );
		/** ERP조직도 연동 옵션값 가져오기 2016.12.29 장지훈 추가 */
		params.put( "option", "cm1100" );
		// ERP 조직도 연동 사용여부
		Map<String, Object> parentOption = commonOptionManageService.getErpOptionValue( params );
		// ERP 조직도 연동 사용
		if ( parentOption.get( "optionRealValue" ).equals( "1" ) ) {
			params.put( "option", "cm1103" );
			// 사용자 항목 수정 사용 여부
			Map<String, Object> useItemUpdate = commonOptionManageService.getErpOptionValue( params );
			// 사용자 항목 수정 사용	
			if ( useItemUpdate.get( "optionRealValue" ).equals( "1" ) ) {
				//params.put("option", "cm1104");
				//Map<String, Object> useItemErpUpdate = commonOptionManageService.getErpOptionValue(params);
				List<Map<String, Object>> erpEmpOptions = commonOptionManageService.getErpEmpOptionValue( params );
				//if(useItemErpUpdate.get("optionRealValue").equals("1")) {
				List<String> optionId = new ArrayList<String>( );
				List<Map<String, Object>> options = new ArrayList<Map<String, Object>>( );
				for ( int i = 0; i < erpEmpOptions.size( ); i++ ) {
					Map<String, Object> items = new HashMap<String, Object>( );
					String realOptionId = erpEmpOptions.get( i ).get( "optionId" ).toString( );
					String optionNm = erpEmpOptions.get( i ).get( "optionNm" ).toString( );
					String realValue = erpEmpOptions.get( i ).get( "optionRealValue" ).toString( );
					optionId.add( realOptionId );
					items.put( "realOptionId", realOptionId );
					items.put( "optionNm", optionNm );
					items.put( "realValue", realValue );
					options.add( items );
				}
				JSONArray optionJson = JSONArray.fromObject( options );
				mv.addObject( "gwUpdateYN", "Y" );
				mv.addObject( "erpEmpOptions", optionJson );
			}
			else {
				mv.addObject( "erpEmpOptions", "Y" );
				mv.addObject( "gwUpdateYN", "N" );
			}
		}
		//폐쇄망 사용유무 커스텀 프로퍼티에서 조회.
		//폐쇄망일 경우 우편번호검색(다음api) 사용불가.
		if ( !BizboxAProperties.getCustomProperty( "BizboxA.ClosedNetworkYn" ).equals( "99" ) ) {
			if ( BizboxAProperties.getCustomProperty( "BizboxA.ClosedNetworkYn" ).equals( "Y" ) ) {
				mv.addObject( "ClosedNetworkYn", "Y" );
			}
		}
		if ( request.getRequestURL( ).toString( ).indexOf( "https://" ) != -1 ) {
			mv.addObject( "isSecure", "Y" );
		}
		else {
			mv.addObject( "isSecure", "N" );
		}
		
		if(CloudConnetInfo.getBuildType().equals("cloud")){
			mv.addObject("profilePath", "/upload/" + loginVO.getGroupSeq() + "/img/profile/" + loginVO.getGroupSeq());
		}else{
			mv.addObject("profilePath", "/upload/img/profile/" + loginVO.getGroupSeq());
		}		
		
		mv.addObject("buildType", CloudConnetInfo.getBuildType());
		mv.setViewName( "/neos/cmm/systemx/emp/pop/empInfoPop" );
		MessageUtil.getRedirectMessage( mv, request );
		return mv;
	}

	@RequestMapping ( "/cmm/systemx/empInfoSaveProc.do" )
	public ModelAndView empInfoSaveProc ( @RequestParam Map<String, Object> params, HttpServletRequest request, RedirectAttributes ra ) throws Exception {
		
		LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser( );
		ModelAndView mv = new ModelAndView( );
		params.put( "groupSeq", loginVO.getGroupSeq( ) );
		params.put( "eaType", loginVO.getEaType( ) );
		params.put( "createSeq", loginVO.getUniqId( ) );
		
		//보안취약점 조치(관리자/마스터권한 체크) 2019.06.10
		if(loginVO.getUserSe().equals("USER") || (loginVO.getUserSe().equals("ADMIN") && !params.get("compSeq").equals(loginVO.getCompSeq()))) {
			
			params = new HashMap<String, Object>( );
			params.put("resultCode", "fail");
			params.put("result", BizboxAMessage.getMessage( "TX000008060", "권한이 없습니다" ));
			mv.addAllObjects( params );
			
		}else {
			
			mv.addAllObjects( orgAdapterService.empSaveAdapter( params ) );

			// mailSync호출
			if ( params.get( "compSeq" ) != null ) {
				orgAdapterService.mailUserSync(params);
			}			
		}

		mv.setViewName( "jsonView" );
		return mv;
	}

	@RequestMapping ( "/cmm/systemx/empRemoveDataCheck.do" )
	public ModelAndView empRemoveDataCheck ( @RequestParam Map<String, Object> params, HttpServletRequest request ) throws Exception {
		LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser( );
		Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated( );
		ModelAndView mv = new ModelAndView( );
		Map<String, Object> paramMap = new HashMap<String, Object>( );
		paramMap.put( "klUserKey", params.get( "empSeq" ) );
		paramMap.put( "klOrgCode", params.get( "deptSeq" ) );
		params.put( "langCode", loginVO.getLangCode( ) );
		String result = "0";
		boolean isProcess = true;
		if ( isAuthenticated ) {
			//결재가능 문서 
			isProcess = empManageService.isPossbileSettleDocument( paramMap );
			if ( isProcess ) { //결재가능문서 있으면 삭제 못함
				mv.setViewName( "jsonView" );
				result = "1";
				mv.addObject( "docApprovalList", paramMap.get( "docApprovalList" ) );
			}
			Map<String, Object> listMap = empManageService.selectEmpInfo( params, new PaginationInfo( ) );
			@SuppressWarnings ( "unchecked" )
			List<Map<String, Object>> list = (List<Map<String, Object>>) listMap.get( "list" );
			if ( list != null && list.size( ) > 0 ) {
				Map<String, Object> empInfoMap = list.get( 0 );
				if ( empInfoMap != null ) {
					String mainYn = String.valueOf( empInfoMap.get( "mainDeptYn" ) );
					if (!mainYn.equals( "Y" )) { //부부서
						result = "2";
					}
				}
			}
		}
		else {
			result = "-1";
		}
		mv.addObject( "result", result );
		mv.setViewName( "jsonView" );
		return mv;
	}

	@RequestMapping ( "/cmm/systemx/empRemoveProc.do" )
	public ModelAndView empRemoveProc ( @RequestParam Map<String, Object> params, HttpServletRequest request ) throws Exception {
		ModelAndView mv = new ModelAndView( );
		LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser( );
		mv.addObject( "resultCode", "fail" );
		mv.addObject( "result", "User Auth Fail" );
		if ( loginVO.getUserSe( ).equals( "USER" ) ) {
			mv.addObject( "resultCode", "fail" );
			mv.addObject( "result", "User Auth Fail" );
		}
		else {
			params.put( "groupSeq", loginVO.getGroupSeq( ) );
			params.put( "createSeq", loginVO.getUniqId( ) );
			mv.addAllObjects( orgAdapterService.empRemoveAdapter( params ) );
		}		
		// mailSync호출
		orgAdapterService.mailUserSync(params);
		
		mv.setViewName( "jsonView" );
		return mv;
	}

	@RequestMapping ( "/cmm/systemx/getEmpListNodes.do" )
	public ModelAndView getEmpListNodes ( @RequestParam Map<String, Object> params, HttpServletRequest request ) throws Exception {
		ModelAndView mv = new ModelAndView( );
		String mode = FormatUtil.getString( params.get( "mode" ) );
		LoginVO loginVO = null;
		String compSeq = FormatUtil.getString( params.get( "compSeq" ) );
		String groupSeq = FormatUtil.getString( params.get( "groupSeq" ) );
		String langCode = FormatUtil.getString( params.get( "langCode" ) );
		if ( mode.equals( "dev" ) ) {
			loginVO = new LoginVO( );
			loginVO.setGroupSeq( groupSeq );
			loginVO.setCompSeq( compSeq );
			loginVO.setLangCode( langCode );
			loginVO.setUserSe( "USER" );
		}
		else {
			loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser( );
		}
		params.put( "langCode", loginVO.getLangCode( ) );
		if ( EgovStringUtil.isEmpty( FormatUtil.getString( params.get( "userSe" ) ) ) ) {
			params.put( "userSe", "USER" );
		}
		if ( EgovStringUtil.isEmpty( groupSeq ) ) {
			params.put( "groupSeq", loginVO.getGroupSeq( ) );
		}
		Map<String, Object> listMap = empManageService.selectEmpInfo( params, new PaginationInfo( ) );
		List<Map<String, Object>> resultList = new ArrayList<Map<String, Object>>( );
		if ( listMap != null && listMap.get( "list" ) != null ) {
			List<Map<String, Object>> list = (List<Map<String, Object>>) listMap.get( "list" );
			int depth = EgovStringUtil.zeroConvert( params.get( "depth" ) );
			
			if (depth > Integer.MAX_VALUE || depth < Integer.MIN_VALUE) {
		        throw new IllegalArgumentException("out of bound");
		    }
			
			for ( Map<String, Object> map : list ) {
				Map<String, Object> empInfo = new HashMap<String, Object>( );
				empInfo.put( "groupSeq", String.valueOf( map.get( "groupSeq" ) ) );
				empInfo.put( "compSeq", String.valueOf( map.get( "compSeq" ) ) );
				empInfo.put( "compName", String.valueOf( map.get( "compName" ) ) );
				empInfo.put( "bizSeq", String.valueOf( map.get( "bizSeq" ) ) );
				empInfo.put( "deptSeq", String.valueOf( map.get( "deptSeq" ) ) );
				empInfo.put( "deptName", String.valueOf( map.get( "deptName" ) ) );
				empInfo.put( "seq", String.valueOf( map.get( "empSeq" ) ) );
				empInfo.put( "parentSeq", String.valueOf( params.get( "parentSeq" ) ) );
				empInfo.put( "dutyCode", String.valueOf( params.get( "dutyCode" ) ) );
				empInfo.put( "positionCode", String.valueOf( params.get( "positionCode" ) ) );
				empInfo.put( "positionCodeName", String.valueOf( params.get( "positionCodeName" ) ) );
				empInfo.put( "loginId", String.valueOf( params.get( "loginId" ) ) );
				empInfo.put( "depth", depth + 1 );
				empInfo.put( "gbn", "m" );
				empInfo.put( "name", String.valueOf( map.get( "empName" ) ) );
				String duty = String.valueOf( map.get( "deptDutyCodeName" ) );
				if ( !EgovStringUtil.isEmpty( duty ) ) {
					empInfo.put( "dutyCodeName", duty );
				}
				else {
					empInfo.put( "dutyCodeName", String.valueOf( params.get( "dutyCodeName" ) ) );
				}

				empInfo.put( "expanded", false );
				resultList.add( empInfo );
			}
		}
		mv.addObject( "list", resultList );
		mv.setViewName( "jsonView" );
		return mv;
	}

	@RequestMapping ( "/cmm/systemx/getEmpJobList.do" )
	public ModelAndView getEmpJobList ( @RequestParam Map<String, Object> params, HttpServletRequest request ) throws Exception {
		LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser( );
		ModelAndView mv = new ModelAndView( );
		params.put( "langCode", loginVO.getLangCode( ) );
		//직무유형 가져오기
		List<Map<String, Object>> jobList = empManageService.getEmpJobList( params );
		mv.addObject( "jobList", jobList );
		mv.setViewName( "jsonView" );
		return mv;
	}

	@RequestMapping ( "/cmm/systemx/getEmpStatusList.do" )
	public ModelAndView getEmpStatusList ( @RequestParam Map<String, Object> params, HttpServletRequest request ) throws Exception {
		LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser( );
		ModelAndView mv = new ModelAndView( );
		params.put( "langCode", loginVO.getLangCode( ) );
		//고용형태 가져오기
		List<Map<String, Object>> statusList = empManageService.getEmpStatusList( params );
		mv.addObject( "statusList", statusList );
		mv.setViewName( "jsonView" );
		return mv;
	}

	@RequestMapping ( "/cmm/systemx/getDutyPositionListData.do" )
	public ModelAndView getDutyPositionListData ( @RequestParam Map<String, Object> params, HttpServletRequest request ) throws Exception {
		LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser( );
		ModelAndView mv = new ModelAndView( );
		params.put( "langCode", loginVO.getLangCode( ) );
		params.put( "groupSeq", loginVO.getGroupSeq( ) );
		params.put( "userSe", loginVO.getUserSe( ) );

		List<Map<String, Object>> dpList = dutyPositionService.getCompDutyPositionList( params );
		JSONArray jsonDp = new JSONArray( );
		jsonDp = JSONArray.fromObject( dpList );
		mv.addObject( "dpList", jsonDp );

		mv.setViewName( "jsonView" );
		return mv;
	}

	@RequestMapping ( "/cmm/systemx/empResignInitData.do" )
	public ModelAndView empResignInitData ( @RequestParam Map<String, Object> params, HttpServletRequest request ) throws Exception {
		LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser( );
		Map<String, Object> map = new HashMap<String, Object>( );
		ModelAndView mv = new ModelAndView( );
		params.put( "loginVo", loginVO );
		params.put( "langCode", loginVO.getLangCode( ) );
		map = empManageService.empResignInitData( params );
		mv.addAllObjects( map );
		mv.setViewName( "jsonView" );
		return mv;
	}

	//필수결재라인 리스트 조회
	@SuppressWarnings("unchecked")
	@RequestMapping ( "/cmm/systemx/empResignDocStep4Data.do" )
	public ModelAndView empResignDocStep4Data ( @RequestParam Map<String, Object> params, HttpServletRequest request ) throws Exception {
		LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser( );
		ModelAndView mv = new ModelAndView( );
		params.put( "loginVo", loginVO );
		params.put( "langCode", loginVO.getLangCode( ) );
		if ( params.get( "isEmpDelProc" ) != null && params.get( "isEmpDelProc" ).toString( ).equals( "Y" ) ) {
			String allComp = "";
			List<Map<String, Object>> compList = commonSql.list( "EmpManage.GetEmpCompList", params );
			for ( Map<String, Object> mp : compList ) {
				allComp += "," + mp.get( "compSeq" );
			}
			if ( allComp.length( ) > 0 ) {
				allComp = allComp.substring( 1 );
			}
			params.put( "allComp", allComp );
		}
		Map<String, Object> docStep4Data = new HashMap<String, Object>( );
		String compArray[] = params.get( "allComp" ).toString( ).split( "," );
		JSONObject jsonObject = new JSONObject( );
		JSONObject header = new JSONObject( );
		JSONObject body = new JSONObject( );
		header.put( "groupSeq", loginVO.getGroupSeq( ) );
		header.put( "empSeq", loginVO.getUniqId( ) );
		header.put( "tId", UUID.randomUUID( ).toString( ) );
		header.put( "pId", "EAP022" );
		body.put( "langCode", loginVO.getLangCode( ) );
		for ( int i = 0; i < compArray.length; i++ ) {
			JSONObject companyInfo = new JSONObject( );
			JSONObject resignEmpInfo = new JSONObject( );
			params.put( "compSeq", compArray[i] );
			params.put("eaType", loginVO.getEaType());
			List<Map<String, Object>> resignEmpMp = commonSql.list( "EmpManage.selectResignEmpInfo", params );
			companyInfo.put( "compSeq", loginVO.getOrganId( ) );
			companyInfo.put( "bizSeq", loginVO.getBizSeq( ) );
			companyInfo.put( "deptSeq", loginVO.getOrgnztId( ) );
			companyInfo.put( "emailAddr", loginVO.getEmail( ) );
			companyInfo.put( "emailDomain", loginVO.getEmailDomain( ) );
			resignEmpInfo.put( "resignCompSeq", compArray[i] );
			resignEmpInfo.put( "resignBizSeq", resignEmpMp.get(0).get( "bizSeq" ) );
			resignEmpInfo.put( "resignDeptSeq", resignEmpMp.get(0).get( "deptSeq" ) );
			resignEmpInfo.put( "resignEmpSeq", resignEmpMp.get(0).get( "empSeq" ) );
			body.put( "companyInfo", companyInfo );
			body.put( "resignEmpInfo", resignEmpInfo );
			jsonObject.put( "header", header );
			jsonObject.put( "body", body );
			String apiUrl = CommonUtil.getApiCallDomain(request) + "/eap/restful/ea/GetEaMustRoleAppLineList";

			HttpJsonUtil httpJson = new HttpJsonUtil( );
			String pEaMustRoleAppLineList = httpJson.execute( "POST", apiUrl, jsonObject );
			pEaMustRoleAppLineList = pEaMustRoleAppLineList.replaceAll( "\'", "&#39;" );
			pEaMustRoleAppLineList = pEaMustRoleAppLineList.replaceAll( "<", "&lt;" );
			pEaMustRoleAppLineList = pEaMustRoleAppLineList.replaceAll( ">'", "&gt;" );
			ObjectMapper om = new ObjectMapper( );
			Map<String, Object> m = om.readValue( pEaMustRoleAppLineList, new TypeReference<Map<String, Object>>( ) {} );
			m.put( "resignCompSeq", compArray[i] );
			m.put( "resignDeptSeq", resignEmpMp.get(0).get( "deptSeq" ) );
			m.put( "resignEmpSeq", resignEmpMp.get(0).get( "empSeq" ) );
			docStep4Data.put( compArray[i], m );
		}
		mv.addObject( "docStep4Data", docStep4Data );
		mv.setViewName( "jsonView" );
		return mv;
	}

	//결재문서 조회
	@SuppressWarnings({ "static-access", "unchecked" })
	@RequestMapping ( "/cmm/systemx/empResignDocStep5Data.do" )
	public ModelAndView empResignDocStep5Data ( @RequestParam Map<String, Object> params, HttpServletRequest request ) throws Exception {
		LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser( );

		Map<String, Object> result = new HashMap<String, Object>( );
		ModelAndView mv = new ModelAndView( );
		params.put( "loginVo", loginVO );
		params.put( "langCode", loginVO.getLangCode( ) );
		if ( params.get( "isEmpDelProc" ) != null && params.get( "isEmpDelProc" ).toString( ).equals( "Y" ) ) {
			String allComp = "";
			List<Map<String, Object>> compList = commonSql.list( "EmpManage.GetEmpCompList", params );
			for ( Map<String, Object> mp : compList ) {
				allComp += "," + mp.get( "compSeq" );
			}
			if ( allComp.length( ) > 0 ) {
				allComp = allComp.substring( 1 );
			}
			params.put( "allComp", allComp );
		}
		Map<String, Object> docStep5Data = new HashMap<String, Object>( );
		String compArray[] = params.get( "allComp" ).toString( ).split( "," );
		JSONObject jsonObject = new JSONObject( );
		JSONObject header = new JSONObject( );
		JSONObject body = new JSONObject( );
		header.put( "groupSeq", loginVO.getGroupSeq( ) );
		header.put( "empSeq", loginVO.getUniqId( ) );
		header.put( "tId", UUID.randomUUID( ).toString( ) );
		header.put( "pId", "EAP019" );
		body.put( "langCode", loginVO.getLangCode( ) );
		int totalDocCnt = 0;
		for ( int i = 0; i < compArray.length; i++ ) {
			JSONObject companyInfo = new JSONObject( );
			JSONObject resignEmpInfo = new JSONObject( );
			params.put( "compSeq", compArray[i] );
			params.put("eaType", loginVO.getEaType());
			List<Map<String, Object>> resignEmpMp = commonSql.list( "EmpManage.selectResignEmpInfo", params );
			
			if(loginVO.getEaType().equals("eap")){			
				companyInfo.put( "compSeq", loginVO.getOrganId( ) );
				companyInfo.put( "bizSeq", loginVO.getBizSeq( ) );
				companyInfo.put( "deptSeq", loginVO.getOrgnztId( ) );
				companyInfo.put( "emailAddr", loginVO.getEmail( ) );
				companyInfo.put( "emailDomain", loginVO.getEmailDomain( ) );
				resignEmpInfo.put( "resignCompSeq", compArray[i] );
				resignEmpInfo.put( "resignBizSeq", resignEmpMp.get(0).get( "bizSeq" ) );
				resignEmpInfo.put( "resignDeptSeq", resignEmpMp.get(0).get( "deptSeq" ) );
				resignEmpInfo.put( "resignEmpSeq", resignEmpMp.get(0).get( "empSeq" ) );
				body.put( "companyInfo", companyInfo );
				body.put( "resignEmpInfo", resignEmpInfo );
				jsonObject.put( "header", header );
				jsonObject.put( "body", body );
				String apiUrl = "";
				apiUrl = CommonUtil.getApiCallDomain(request) + "/eap/restful/ea/GetEaPendingList";
				HttpJsonUtil httpJson = new HttpJsonUtil( );
				String pEaAppDocList = httpJson.execute( "POST", apiUrl, jsonObject );
				pEaAppDocList = pEaAppDocList.replaceAll( "\'", "&#39;" );
				pEaAppDocList = pEaAppDocList.replaceAll( "<", "&lt;" );
				pEaAppDocList = pEaAppDocList.replaceAll( ">'", "&gt;" );
				ObjectMapper om = new ObjectMapper( );
				Map<String, Object> m = om.readValue( pEaAppDocList, new TypeReference<Map<String, Object>>( ) {} );
				docStep5Data.put( compArray[i], m );
				
				int pendingDocCnt = (int) m.get( "pendingDocCnt" ); 
				int afterDocCnt = (int) m.get( "afterDocCnt" );
				int waitingDocCnt = (int) m.get( "waitingDocCnt" );
				
				if (pendingDocCnt > Integer.MAX_VALUE || pendingDocCnt < Integer.MIN_VALUE) {//정수형 오버플로우 방지 적용
			        throw new IllegalArgumentException("out of bound");
			    }
				if (afterDocCnt > Integer.MAX_VALUE || afterDocCnt < Integer.MIN_VALUE) {//정수형 오버플로우 방지 적용
			        throw new IllegalArgumentException("out of bound");
			    }
				if (waitingDocCnt > Integer.MAX_VALUE || waitingDocCnt < Integer.MIN_VALUE) {//정수형 오버플로우 방지 적용
			        throw new IllegalArgumentException("out of bound");
			    }
				
				totalDocCnt += pendingDocCnt + afterDocCnt + waitingDocCnt; 
			}else{
				for(Map<String, Object> mp : resignEmpMp){
					Map<String, Object> para = new HashMap<String, Object>();
					para.put("empSeq", mp.get("empSeq"));
					para.put("deptSeq", mp.get("deptSeq"));
					
					//비영리 미결문서 조회
					String cnt = (String) commonSql.select("EmpManage.getEaCntForNp", para);
					totalDocCnt += Integer.parseInt(cnt);
				}
			}
		}
		mv.addObject( "totalDocCnt", totalDocCnt );
		mv.addObject( "docStep5Data", docStep5Data );
		mv.setViewName( "jsonView" );
		return mv;
	}

	@RequestMapping ( "/cmm/systemx/empResignSetEaMustRoleAppLine.do" )
	public ModelAndView empResignSetEaMustRoleAppLine ( @RequestParam Map<String, Object> params, HttpServletRequest request ) throws Exception {
		ModelAndView mv = new ModelAndView( );
		LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser( );
		String[] sReplaceMustList = params.get( "eaMustRoleInfo" ).toString( ).split( "," );
		String[] compSeqArray = params.get( "allComp" ).toString( ).split( "," );
		String result = "";
		for ( int k = 0; k < compSeqArray.length; k++ ) {
			JSONObject jsonObject = new JSONObject( );
			JSONObject header = new JSONObject( );
			JSONObject body = new JSONObject( );
			header.put( "groupSeq", loginVO.getGroupSeq( ) );
			header.put( "empSeq", loginVO.getUniqId( ) );
			header.put( "tId", UUID.randomUUID( ).toString( ) );
			header.put( "pId", "EAP023" );
			body.put( "langCode", loginVO.getLangCode( ) );
			JSONObject companyInfo = new JSONObject( );
			JSONObject resignEmpInfo = new JSONObject( );
			companyInfo.put( "compSeq", loginVO.getOrganId( ) );
			companyInfo.put( "bizSeq", loginVO.getBizSeq( ) );
			companyInfo.put( "deptSeq", loginVO.getOrgnztId( ) );
			companyInfo.put( "emailAddr", loginVO.getEmail( ) );
			companyInfo.put( "emailDomain", loginVO.getEmailDomain( ) );
			params.put( "compSeq", compSeqArray[k] );
			params.put("eaType", loginVO.getEaType());
			List<Map<String, Object>> resignEmpMp = commonSql.list( "EmpManage.selectResignEmpInfo", params );
			resignEmpInfo.put( "resignCompSeq", resignEmpMp.get(0).get( "compSeq" ) );
			resignEmpInfo.put( "resignBizSeq", resignEmpMp.get(0).get( "bizSeq" ) );
			resignEmpInfo.put( "resignDeptSeq", resignEmpMp.get(0).get( "deptSeq" ) );
			resignEmpInfo.put( "resignEmpSeq", resignEmpMp.get(0).get( "empSeq" ) );
			body.put( "companyInfo", companyInfo );
			body.put( "resignEmpInfo", resignEmpInfo );
			JSONArray replaceMustList = new JSONArray( );
			
			if(params.get("deleteFlage") == null){			
				for ( int i = 0; i < sReplaceMustList.length; i++ ) {
					String[] sReplaceMustEmpInfo = sReplaceMustList[i].split( "\\*" );
					if ( sReplaceMustEmpInfo[10].equals( compSeqArray[k] ) ) {
						JSONObject replaceMustInfo = new JSONObject( );
						replaceMustInfo.put( "formId", sReplaceMustEmpInfo[0] );
						replaceMustInfo.put( "actId", sReplaceMustEmpInfo[1] );
						replaceMustInfo.put( "lineType", sReplaceMustEmpInfo[2] );
						replaceMustInfo.put( "roleId", sReplaceMustEmpInfo[3] );
						replaceMustInfo.put( "proxyEmpSeq", sReplaceMustEmpInfo[4] );
						replaceMustInfo.put( "proxyGroupSeq", sReplaceMustEmpInfo[5] );
						replaceMustInfo.put( "proxyCompSeq", sReplaceMustEmpInfo[6] );
						replaceMustInfo.put( "proxyBizSeq", sReplaceMustEmpInfo[7] );
						replaceMustInfo.put( "proxyDeptSeq", sReplaceMustEmpInfo[8] );
						replaceMustInfo.put( "proxyOrgPath", sReplaceMustEmpInfo[9] );
						replaceMustList.add( replaceMustInfo );
					}
				}
			}		
			
			
			body.put( "replaceMustList", replaceMustList );
			jsonObject.put( "header", header );
			jsonObject.put( "body", body );
			String apiUrl = CommonUtil.getApiCallDomain(request) + "/eap/restful/ea/SetEaMustRoleAppLine";

			HttpJsonUtil httpJson = new HttpJsonUtil( );
			result = httpJson.execute( "POST", apiUrl, jsonObject );
		}
		ObjectMapper om = new ObjectMapper( );
		Map<String, Object> resultMap = om.readValue( result, new TypeReference<Map<String, Object>>( ) {} );
		mv.addObject( "result", resultMap );
		mv.setViewName( "jsonView" );
		return mv;
	}

	@SuppressWarnings({ "static-access", "unchecked" })
	@RequestMapping ( "/cmm/systemx/empResignAppDocApprovalProc.do" )
	public ModelAndView empResignAppDocApprovalProc ( @RequestParam Map<String, Object> params, HttpServletRequest request ) throws Exception {
		ModelAndView mv = new ModelAndView( );
		LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser( );
		String[] sDocIdArray = params.get( "docIds" ).toString( ).split( "," );
		JSONObject jsonObject = new JSONObject( );
		JSONObject header = new JSONObject( );
		JSONObject body = new JSONObject( );
		header.put( "groupSeq", loginVO.getGroupSeq( ) );
		header.put( "empSeq", loginVO.getUniqId( ) );
		header.put( "tId", UUID.randomUUID( ).toString( ) );
		header.put( "pId", "EAP020" );
		body.put( "langCode", loginVO.getLangCode( ) );
		JSONObject companyInfo = new JSONObject( );
		JSONObject resignEmpInfo = new JSONObject( );
		params.put("eaType", loginVO.getEaType());
		List<Map<String, Object>> resignEmpMp = commonSql.list( "EmpManage.selectResignEmpInfo", params );
		companyInfo.put( "compSeq", loginVO.getOrganId( ) );
		companyInfo.put( "bizSeq", loginVO.getBizSeq( ) );
		companyInfo.put( "deptSeq", loginVO.getOrgnztId( ) );
		companyInfo.put( "emailAddr", loginVO.getEmail( ) );
		companyInfo.put( "emailDomain", loginVO.getEmailDomain( ) );
		resignEmpInfo.put( "resignCompSeq", resignEmpMp.get(0).get( "compSeq" ) );
		resignEmpInfo.put( "resignBizSeq", resignEmpMp.get(0).get( "bizSeq" ) );
		resignEmpInfo.put( "resignDeptSeq", resignEmpMp.get(0).get( "deptSeq" ) );
		resignEmpInfo.put( "resignEmpSeq", resignEmpMp.get(0).get( "empSeq" ) );
		JSONArray docIdArray = new JSONArray( );
		for ( int i = 0; i < sDocIdArray.length; i++ ) {
			JSONObject jsonDocId = new JSONObject( );
			jsonDocId.put( "docId", sDocIdArray[i] );
			docIdArray.add( jsonDocId );
		}
		body.put( "companyInfo", companyInfo );
		body.put( "resignEmpInfo", resignEmpInfo );
		body.put( "docList", docIdArray );
		jsonObject.put( "header", header );
		jsonObject.put( "body", body );
		String apiUrl = CommonUtil.getApiCallDomain(request) + "/eap/restful/ea/SetEaResignMultiApproval";

		HttpJsonUtil httpJson = new HttpJsonUtil( );
		String apiResult = httpJson.execute( "POST", apiUrl, jsonObject );
		ObjectMapper om = new ObjectMapper( );
		Map<String, Object> result = om.readValue( apiResult, new TypeReference<Map<String, Object>>( ) {} );
		mv.addObject( "result", result );
		mv.setViewName( "jsonView" );
		return mv;
	}

	@SuppressWarnings({ "unchecked", "static-access" })
	@RequestMapping ( "/cmm/systemx/empResignReplaceAppDocProc.do" )
	public ModelAndView empResignReplaceAppDocProc ( @RequestParam Map<String, Object> params, HttpServletRequest request ) throws Exception {
		ModelAndView mv = new ModelAndView( );
		LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser( );
		String[] sReplaceAppDocArray = params.get( "replaceAppDocInfo" ).toString( ).split( "," );
		JSONObject jsonObject = new JSONObject( );
		JSONObject header = new JSONObject( );
		JSONObject body = new JSONObject( );
		header.put( "groupSeq", loginVO.getGroupSeq( ) );
		header.put( "empSeq", loginVO.getUniqId( ) );
		header.put( "tId", UUID.randomUUID( ).toString( ) );
		header.put( "pId", "EAP021" );
		body.put( "langCode", loginVO.getLangCode( ) );
		JSONObject companyInfo = new JSONObject( );
		JSONObject resignEmpInfo = new JSONObject( );
		params.put("eaType", loginVO.getEaType());
		List<Map<String, Object>> resignEmpMp = commonSql.list( "EmpManage.selectResignEmpInfo", params );
		companyInfo.put( "compSeq", loginVO.getOrganId( ) );
		companyInfo.put( "bizSeq", loginVO.getBizSeq( ) );
		companyInfo.put( "deptSeq", loginVO.getOrgnztId( ) );
		companyInfo.put( "emailAddr", loginVO.getEmail( ) );
		companyInfo.put( "emailDomain", loginVO.getEmailDomain( ) );
		resignEmpInfo.put( "resignCompSeq", resignEmpMp.get(0).get( "compSeq" ) );
		resignEmpInfo.put( "resignBizSeq", resignEmpMp.get(0).get( "bizSeq" ) );
		resignEmpInfo.put( "resignDeptSeq", resignEmpMp.get(0).get( "deptSeq" ) );
		resignEmpInfo.put( "resignEmpSeq", resignEmpMp.get(0).get( "empSeq" ) );
		JSONArray jsonReplaceInfo = new JSONArray( );
		for ( int i = 0; i < sReplaceAppDocArray.length; i++ ) {
			JSONObject jsonReplaceAppDocInfo = new JSONObject( );
			String[] replaceInfo = sReplaceAppDocArray[i].split( "\\|" );
			jsonReplaceAppDocInfo.put( "docId", Integer.parseInt( replaceInfo[0] ) );
			jsonReplaceAppDocInfo.put( "replaceCoId", replaceInfo[1] );
			jsonReplaceAppDocInfo.put( "replaceDeptId", replaceInfo[2] );
			jsonReplaceAppDocInfo.put( "replaceUserId", replaceInfo[3] );
			jsonReplaceAppDocInfo.put( "replaceDutyCode", replaceInfo[4] );
			jsonReplaceAppDocInfo.put( "replacePositionCode", replaceInfo[5] );
			
			jsonReplaceInfo.add( jsonReplaceAppDocInfo );
		}
		body.put( "companyInfo", companyInfo );
		body.put( "resignEmpInfo", resignEmpInfo );
		body.put( "replaceAppLineList", jsonReplaceInfo );
		jsonObject.put( "header", header );
		jsonObject.put( "body", body );
		String apiUrl = CommonUtil.getApiCallDomain(request) + "/eap/restful/ea/SetEaWaitingAppLine";

		HttpJsonUtil httpJson = new HttpJsonUtil( );
		String apiResult = httpJson.execute( "POST", apiUrl, jsonObject );
		ObjectMapper om = new ObjectMapper( );
		Map<String, Object> result = om.readValue( apiResult, new TypeReference<Map<String, Object>>( ) {} );
		mv.addObject( "result", result );
		mv.setViewName( "jsonView" );
		return mv;
	}

	@SuppressWarnings({ "static-access", "unchecked" })
	@RequestMapping ( "/cmm/systemx/empResignDocData.do" )
	public ModelAndView empResignDocData ( @RequestParam Map<String, Object> params, HttpServletRequest request ) throws Exception {
		LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser( );

		Map<String, Object> result = new HashMap<String, Object>( );
		ModelAndView mv = new ModelAndView( );
		
		// mailSync 주소 셋팅
		Map<String, Object> mailInfo = orgAdapterDAO.selectMailInfoGroup( params );
		if ( mailInfo != null && mailInfo.get( "mailUrl" ) != null && !mailInfo.get( "mailUrl" ).equals( "" ) ) {
			mv.addObject("mailUrl", mailInfo.get( "mailUrl" ).toString( ));				
		}
		
		
		params.put( "loginVo", loginVO );
		params.put( "langCode", loginVO.getLangCode( ) );
		if ( params.get( "isEmpDelProc" ) != null && params.get( "isEmpDelProc" ).toString( ).equals( "Y" ) ) {
			String allComp = "";
			List<Map<String, Object>> compList = commonSql.list( "EmpManage.GetEmpCompList", params );
			for ( Map<String, Object> mp : compList ) {
				allComp += "," + mp.get( "compSeq" );
			}
			if ( allComp.length( ) > 0 ) {
				allComp = allComp.substring( 1 );
			}
			params.put( "allComp", allComp );
		}
		//사용자 삭제인 경우 미결, 후결문서 일괄결재 
		//결재 예정 문서가 있을경우 삭제불가(퇴사로직 진행 후 삭제 가능)
		//결재진행 리스트조회(미결,후결,예정문서 모두)          
		Map<String, Object> docStep5Data = new HashMap<String, Object>( );
		String compArray[] = params.get( "allComp" ).toString( ).split( "," );
		compArray = new HashSet<String>( Arrays.asList( compArray ) ).toArray( new String[0] );
		JSONObject jsonObject = new JSONObject( );
		JSONObject header = new JSONObject( );
		JSONObject body = new JSONObject( );
		header.put( "groupSeq", loginVO.getGroupSeq( ) );
		header.put( "empSeq", loginVO.getUniqId( ) );
		header.put( "tId", UUID.randomUUID( ).toString( ) );
		header.put( "pId", "EAP019" );
		body.put( "langCode", loginVO.getLangCode( ) );
		int eDocCnt = 0;
		for ( int i = 0; i < compArray.length; i++ ) {
			JSONObject companyInfo = new JSONObject( );
			JSONObject resignEmpInfo = new JSONObject( );
			params.put( "compSeq", compArray[i] );
			params.put("eaType", loginVO.getEaType());
			List<Map<String, Object>> resignEmpMp = commonSql.list( "EmpManage.selectResignEmpInfo", params );
			
			//전자결재 영리는 미결문서 api 호출로 조회
			if(loginVO.getEaType().equals("eap")){
				companyInfo.put( "compSeq", loginVO.getOrganId( ) );
				companyInfo.put( "bizSeq", loginVO.getBizSeq( ) );
				companyInfo.put( "deptSeq", loginVO.getOrgnztId( ) );
				companyInfo.put( "emailAddr", loginVO.getEmail( ) );
				companyInfo.put( "emailDomain", loginVO.getEmailDomain( ) );
				resignEmpInfo.put( "resignCompSeq", compArray[i] );
				resignEmpInfo.put( "resignBizSeq", resignEmpMp.get(0).get( "bizSeq" ) );
				resignEmpInfo.put( "resignDeptSeq", resignEmpMp.get(0).get( "deptSeq" ) );
				resignEmpInfo.put( "resignEmpSeq", resignEmpMp.get(0).get( "empSeq" ) );
				body.put( "companyInfo", companyInfo );
				body.put( "resignEmpInfo", resignEmpInfo );
				jsonObject.put( "header", header );
				jsonObject.put( "body", body );
				//전자결재 진행 리스트 조회
				String apiUrl = CommonUtil.getApiCallDomain(request) + "/eap/restful/ea/GetEaPendingList";

				HttpJsonUtil httpJson = new HttpJsonUtil( );
				String pEaAppDocList = httpJson.execute( "POST", apiUrl, jsonObject );
				pEaAppDocList = pEaAppDocList.replaceAll( "\'", "&#39;" );
				pEaAppDocList = pEaAppDocList.replaceAll( "<", "&lt;" );
				pEaAppDocList = pEaAppDocList.replaceAll( ">'", "&gt;" );
				ObjectMapper om = new ObjectMapper( );
				Map<String, Object> m = om.readValue( pEaAppDocList, new TypeReference<Map<String, Object>>( ) {} );
				docStep5Data.put( compArray[i], m );
				
				int pendingDocCnt = (int) m.get( "pendingDocCnt" ); 
				int afterDocCnt = (int) m.get( "afterDocCnt" );
				int waitingDocCnt = (int) m.get( "waitingDocCnt" );
				
				if (pendingDocCnt > Integer.MAX_VALUE || pendingDocCnt < Integer.MIN_VALUE) {//정수형 오버플로우 방지 적용
			        throw new IllegalArgumentException("out of bound");
			    }
				if (afterDocCnt > Integer.MAX_VALUE || afterDocCnt < Integer.MIN_VALUE) {//정수형 오버플로우 방지 적용
			        throw new IllegalArgumentException("out of bound");
			    }
				if (waitingDocCnt > Integer.MAX_VALUE || waitingDocCnt < Integer.MIN_VALUE) {//정수형 오버플로우 방지 적용
			        throw new IllegalArgumentException("out of bound");
			    }
				
				eDocCnt += pendingDocCnt;
				eDocCnt += afterDocCnt;
				eDocCnt += waitingDocCnt;
				//전자결재 필수 롤 결재라인 리스트 조회
				apiUrl = CommonUtil.getApiCallDomain(request) + "/eap/restful/ea/GetEaMustRoleAppLineList";

				header.put( "tId", UUID.randomUUID( ).toString( ) );
				header.put( "pId", "EAP022" );
				httpJson = new HttpJsonUtil( );
				pEaAppDocList = httpJson.execute( "POST", apiUrl, jsonObject );
				pEaAppDocList = pEaAppDocList.replaceAll( "\'", "&#39;" );
				pEaAppDocList = pEaAppDocList.replaceAll( "<", "&lt;" );
				pEaAppDocList = pEaAppDocList.replaceAll( ">'", "&gt;" );
				om = new ObjectMapper( );
				m = om.readValue( pEaAppDocList, new TypeReference<Map<String, Object>>( ) {} );
				docStep5Data.put( compArray[i], m );
				
				int eaMustRoleAppLineCount = (int) m.get( "eaMustRoleAppLineCount" );
				
				if (eaMustRoleAppLineCount > Integer.MAX_VALUE || eaMustRoleAppLineCount < Integer.MIN_VALUE) {//정수형 오버플로우 방지 적용
			        throw new IllegalArgumentException("out of bound");
			    }
				
				eDocCnt += eaMustRoleAppLineCount;
			}
			//전자결재 비영리는 전달받은 쿼리로 직접 조회
			else{
				for(Map<String, Object> mp : resignEmpMp){
					Map<String, Object> para = new HashMap<String, Object>();
					para.put("empSeq", mp.get("empSeq"));
					para.put("deptSeq", mp.get("deptSeq"));
					
					//비영리 미결문서 조회
					String cnt = (String) commonSql.select("EmpManage.getEaCntForNp", para);
					eDocCnt += Integer.parseInt(cnt);
				}
			}
		}
		if ( eDocCnt > 0 ) {
			//결재문서 및 필수 롤 결재라인이 있을 경우 삭제처리 불가.
			mv.addObject( "result", "-1" );
		}
		else {
			mv.addObject( "result", "0" );
		}
		mv.setViewName( "jsonView" );
		return mv;
	}

	@RequestMapping ( "/cmm/systemx/empResignProc.do" )
	public ModelAndView empResignProc ( @RequestParam Map<String, Object> params, HttpServletRequest request ) throws Exception {
		LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser( );
		ModelAndView mv = new ModelAndView( );
		params.put( "createSeq", loginVO.getUniqId( ) );
		params.put( "groupSeq", loginVO.getGroupSeq( ) );
		mv.addAllObjects( orgAdapterService.empResignProcFinish( params ) );
		mv.setViewName( "jsonView" );
		return mv;
	}

	@RequestMapping ( "/cmm/systemx/empResignProcFinish.do" )
	public ModelAndView empResignProcFinish ( @RequestParam Map<String, Object> params, HttpServletRequest request ) throws Exception {
		LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser( );
		ModelAndView mv = new ModelAndView( );
		params.put( "createSeq", loginVO.getUniqId( ) );
		params.put( "groupSeq", loginVO.getGroupSeq( ) );
		mv.addAllObjects( orgAdapterService.empResignProcFinish( params ) );
		// mailSync호출
		if ( params.get( "compSeq" ) != null ) {
			orgAdapterService.mailUserSync(params);
		}
		mv.setViewName( "jsonView" );
		return mv;
	}

	@SuppressWarnings("unchecked")
	@RequestMapping ( "/cmm/systemx/empChangeIdPop.do" )
	public ModelAndView empChangeIdPop ( @RequestParam Map<String, Object> params, HttpServletRequest request ) throws Exception {
		ModelAndView mv = new ModelAndView( );
		String isMailUse = EgovStringUtil.isNullToString( empManageService.isMailUse( params ) );
		Map<String, Object> empInfo = (Map<String, Object>) commonSql.select( "EmpManage.selectEmpInfo", params );
		mv.addObject( "empInfo", empInfo );
		mv.addObject( "params", params );
		mv.addObject( "isMailUse", isMailUse );
		mv.setViewName( "/neos/cmm/systemx/emp/pop/empChangeIdPop" );
		return mv;
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping ( "/cmm/systemx/empChangePassPop.do" )
	public ModelAndView empChangePassPop ( @RequestParam Map<String, Object> params, HttpServletRequest request ) throws Exception {
		ModelAndView mv = new ModelAndView( );
		Map<String, Object> empInfo = (Map<String, Object>) commonSql.select( "EmpManage.selectEmpInfo", params );
		mv.addObject( "empInfo", empInfo );
		mv.addObject( "params", params );
		mv.addObject( "buildType", CloudConnetInfo.getBuildType());
		mv.setViewName( "/neos/cmm/systemx/emp/pop/empChangePassPop" );
		return mv;
	}
	
	@RequestMapping ( "/cmm/systemx/empChangePassReqPop.do" )
	public ModelAndView empChangePassReqPop ( @RequestParam Map<String, Object> params, HttpServletRequest request ) throws Exception {
		ModelAndView mv = new ModelAndView( );
		mv.setViewName( "/neos/cmm/systemx/emp/pop/empChangePassReqPop" );
		return mv;
	}
	
	@RequestMapping ( "/cmm/systemx/backupServiceInfoPop.do" )
	public ModelAndView backupServiceInfoPop ( @RequestParam Map<String, Object> params, HttpServletRequest request ) throws Exception {
		ModelAndView mv = new ModelAndView( );
		mv.setViewName( "/neos/cmm/systemx/group/pop/backupServiceInfoPop" );
		return mv;
	}	

	@RequestMapping ( "/cmm/systemx/getAuthCodeList.do" )
	public ModelAndView getAuthCodeList ( @RequestParam Map<String, Object> params, HttpServletRequest request ) throws Exception {
		LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser( );
		ModelAndView mv = new ModelAndView( );
		params.put( "groupSeq", loginVO.getGroupSeq( ) );
		params.put( "langCode", loginVO.getLangCode( ) );
		params.put( "searchKeyword", "" );
		params.put( "group_seq", loginVO.getGroupSeq( ) );
		params.put( "searchAuthorUseYn", "Y" );
		params.put( "searchAuthorType", "001" );
		if ( !(FormatUtil.getString( params.get( "pageInfo" ) )).equals( "" ) ) {
			if ( (FormatUtil.getString( params.get( "pageInfo" ) ).equals( "empinfoPop" )) ) {
				params.remove( "searchAuthorType" );
			}
		}
		params.put( "authFlag", "Y" ); //사용자, 관리자 권한만 가져오기위한 플레그
		Map<String, Object> resultMap = authorManageService.selectAuthorList( params );
		@SuppressWarnings ( "unchecked" )
		List<Map<String, Object>> list = (List<Map<String, Object>>) resultMap.get( "list" );
		String authHtml = "";
		int cnt = 1;
		for ( Map<String, Object> map : list ) {
			authHtml += "<tr><td><input type='checkbox' name='all_chk' id='all_chk" + cnt + "' class='k-checkbox' ";
			if ( map.get( "authorBaseYn" ).toString( ).equals( "Y" ) ) {
				authHtml += "checked='checked'/>";
			}
			else {
				authHtml += "/>";
			}
			authHtml += "<label class='k-checkbox-label bdChk' for='all_chk" + cnt + "'></label>";
			authHtml += "<input type='hidden' id='authorCode" + cnt + "' value='" + map.get( "authorCode" ).toString( ) + "'/></td>";
			authHtml += "<td class='le'>" + map.get( "authorNm" ) + "</td></tr>";
			cnt++;
		}
		mv.addAllObjects( resultMap );
		mv.addObject( "authHtml", authHtml );
		mv.setViewName( "jsonView" );
		return mv;
	}

	@RequestMapping ( "/cmm/systemx/getEmpInfoList.do" )
	public ModelAndView getEmpInfoList ( @RequestParam Map<String, Object> params, HttpServletRequest request ) throws Exception {
		LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser( );
		ModelAndView mv = new ModelAndView( );
		params.put( "langCode", loginVO.getLangCode( ) );
		params.put( "groupSeq", loginVO.getGroupSeq( ) );
		//겸직부서정보는 관리자 권한도 모든 회사 조회가능해야 하기때문에 userSe파라미터 MASTER로 셋팅
		params.put( "userSe", "MASTER" );
		List<Map<String, Object>> empList = empManageService.getEmpInfoList( params );
		mv.addObject( "empList", empList );
		mv.setViewName( "jsonView" );
		return mv;
	}

	@RequestMapping ( "/cmm/systemx/getEmpInfoListNew.do" )
	public ModelAndView getEmpInfoListNew ( @RequestParam Map<String, Object> params, HttpServletRequest request ) throws Exception {
		LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser( );
		ModelAndView mv = new ModelAndView( );
		params.put( "langCode", loginVO.getLangCode( ) );
		params.put( "groupSeq", loginVO.getGroupSeq( ) );
		params.put( "userSe", loginVO.getUserSe( ) );
		List<Map<String, Object>> empList = empManageService.getEmpInfoListNew( params );
		mv.addObject( "empList", empList );
		mv.setViewName( "jsonView" );
		return mv;
	}

	@RequestMapping ( "/cmm/systemx/changeEmailData.do" )
	public ModelAndView changeEmailData ( @RequestParam Map<String, Object> param, HttpServletRequest request ) throws Exception {
		/**
		 * 변 경 : 김상겸
		 * 변 경 일 : 2018-01-04
		 * 변경사유 : Mail ID 변경 진행 시 조건에 따라서 t_co_emp.email_addr 업데이트 예외 처리
		 * 주의사항 : Mail ID만 변경 하는 경우 존재, Mail ID 및 Login ID 변경 하는 경우 존재
		 */
		/* 변수 정의 */
		ModelAndView mv = new ModelAndView( );
		HashMap<String, Object> result = new HashMap<String, Object>( );
		String[] keys = { "groupSeq", "userSe", "langCode" };
		/* 파라미터 설정 */
		param = FormatUtil.getLoginVo( param, keys );
		/* 메일 ID 변경 API 호출 */
		result = empManageService.changeEmailData( param );
		/* 메일 ID 변경 정상 처리 시 t_co_emp.email_addr update - 통합 Adapter 개발로 인하여 불필한 업데이트 프로세스로 삭제 처리 ( 2018-01-04 / 오범수, 김상겸 ) */
		/* if ( result.get( "resultCode" ).equals( IfUtil.Api.MailApi.MailResultSuccess ) ) { empManageService.updateMailAddr( param ); } */
		/* 반환 처리 */
		mv.addObject( "result", result );
		mv.setViewName( "jsonView" );
		return mv;
	}

	@RequestMapping ( "/cmm/systemx/getWorkTeamMst.do" )
	public ModelAndView getWorkTeamMst ( @RequestParam Map<String, Object> params, HttpServletRequest request ) throws Exception {
		LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser( );
		List<Map<String, Object>> result = new ArrayList<Map<String, Object>>( );
		ModelAndView mv = new ModelAndView( );
		params.put( "langCode", loginVO.getLangCode( ) );
		params.put( "compSeq", EgovStringUtil.isNullToString( params.get( "compSeq" ) ) );
		result = empManageService.getWorkTeamMst( params );
		mv.addObject( "result", result );
		mv.setViewName( "jsonView" );
		return mv;
	}

	@RequestMapping ( "/cmm/systemx/isMailUseYn.do" )
	public ModelAndView isMailUseYn ( @RequestParam Map<String, Object> params, HttpServletRequest request ) throws Exception {
		String result = "";
		ModelAndView mv = new ModelAndView( );
		params.put( "compSeq", EgovStringUtil.isNullToString( params.get( "compSeq" ) ) );
		result = empManageService.isMailUse( params );
		mv.addObject( "result", result );
		mv.setViewName( "jsonView" );
		return mv;
	}

	@RequestMapping ( "/cmm/systemx/getMailDomain.do" )
	public ModelAndView getMailDomain ( @RequestParam Map<String, Object> params, HttpServletRequest request ) throws Exception {
		String result = "";
		ModelAndView mv = new ModelAndView( );
		params.put( "compSeq", EgovStringUtil.isNullToString( params.get( "compSeq" ) ) );
		result = empManageService.getMailDomain( params );
		mv.addObject( "result", result );
		mv.setViewName( "jsonView" );
		return mv;
	}
	
	@RequestMapping ( "/cmm/systemx/getNativeLangCode.do" )
	public ModelAndView getNativeLangCode ( @RequestParam Map<String, Object> params, HttpServletRequest request ) throws Exception {
		String result = "";
		ModelAndView mv = new ModelAndView( );
		params.put( "compSeq", EgovStringUtil.isNullToString( params.get( "compSeq" ) ) );
		result = compService.getComp(params).get("nativeLangCode").toString();
		mv.addObject( "result", result );
		mv.setViewName( "jsonView" );
		return mv;
	}	

	@RequestMapping ( "/cmm/systemx/empRegBatchPop.do" )
	public ModelAndView empRegBatchPop ( @RequestParam Map<String, Object> params, HttpServletRequest request ) throws Exception {
		LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser( );
		params.put( "groupSeq", loginVO.getGroupSeq( ) );
		/** 그룹 정보 가져오기. 그룹명 가져오기 위해 */
		Map<String, Object> groupMap = orgChartService.getGroupInfo( params );
		ModelAndView mv = new ModelAndView( );
		mv.addObject( "groupMap", groupMap );
		/** 회사 리스트 조회 */
		String userSe = loginVO.getUserSe( );
		List<Map<String, Object>> compList = null;
		if ( userSe != null && !userSe.equals( "USER" ) ) {
			params.put( "groupSeq", loginVO.getGroupSeq( ) );
			params.put( "langCode", loginVO.getLangCode( ) );
			params.put( "userSe", userSe );
			if ( userSe.equals( "ADMIN" ) ) {
				params.put( "empSeq", loginVO.getUniqId( ) );
			}
			compList = compService.getCompListAuth( params );
		}
		mv.addObject( "compList", compList );
		JSONArray json = JSONArray.fromObject( compList );
		mv.addObject( "compListJson", json );
		/** 현재 회사 선택 */
		String compSeq = FormatUtil.getString( params.get( "compSeq" ) );
		if ( EgovStringUtil.isEmpty( compSeq ) ) {
			if ( loginVO.getUserSe( ).equals( "MASTER" ) ) {
				//마스터일경우 회사선택 가능
				if(compList!=null) {//Null Pointer 역참조
				params.put( "compSeq", compList.get( 0 ).get( "compSeq" ) );
				}
			}
			else {
				//admin일경우 자기가 속한 회사 선택 
				params.put( "compSeq", loginVO.getCompSeq( ) );
			}
		}
		mv.addObject( "params", params );
		mv.addObject( "loginVO", loginVO );
		mv.setViewName( "/neos/cmm/systemx/emp/pop/empRegBatchPop" );
		return mv;
	}

	@SuppressWarnings ( "unchecked" )
	@RequestMapping ( value = "/cmm/systemx/empExcelValidate", method = RequestMethod.POST )
	@ResponseBody
	public ModelAndView empExcelValidate ( @RequestParam Map<String, Object> params, HttpServletRequest request ) throws Exception {
		ModelAndView mv = new ModelAndView( );
		Map<String, Object> licenseCountCheck = new HashMap<String, Object>( );
		mv.setViewName( "jsonView" );
		List<Map<String, Object>> validateList = null;
		List<String> imgList = new ArrayList<String>( );
		LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser( );
		String mode = (String) params.get( "mode" );
		String osType = NeosConstants.SERVER_OS;
		Map<String, Object> para = new HashMap<String, Object>( );
		para.put( "groupSeq", loginVO.getGroupSeq( ) );
		para.put( "pathSeq", "0" );
		para.put( "osType", osType );
		Map<String, Object> pathMap = groupManageService.selectGroupPath( para );
		String savePath = "";
		if ( pathMap.size( ) == 0 ) {
			savePath = File.separator;
		}
		else {
			savePath = pathMap.get( "absolPath" ) + "/exceltemp/";
		}
		String excelFileName = "";
		String photoFileName = "";
		String relativePath = File.separator + loginVO.getGroupSeq( );
		String rootPath = null;
		String pathSeq = "910";
		MultipartHttpServletRequest multipartRequest = (MultipartHttpServletRequest) request;
		//업로드파일 로드
		MultipartFile excelFile = multipartRequest.getFile( "excel" );
		MultipartFile photoFile = null;
		if ( mode.equals( "photo" ) ) {
			photoFile = multipartRequest.getFile( "photo" );
		}
		else if ( mode.equals( "sign" ) ) {
			pathSeq = "900";
			photoFile = multipartRequest.getFile( "sign" );
		}
		//엑셀파일로드
		List<Map<String, Object>> excelContentList = null;
		if ( excelFile != null && excelFile.getSize( ) > 0 ) {
			excelFileName = excelFile.getOriginalFilename( );
			String saveFileName = excelFile.getOriginalFilename( );
			long fileSize = excelFile.getSize( );
			if ( fileSize > 0 && !saveFileName.equals( "" ) ) {
				saveFileName = savePath + saveFileName;
				EgovFileUploadUtil.saveFile( excelFile.getInputStream( ), new File( saveFileName ) );
				int index = excelFile.getOriginalFilename( ).lastIndexOf( "." );
				String fileExt = excelFile.getOriginalFilename( ).substring( index + 1 );
				String newName = excelFile.getOriginalFilename( ).substring( 0, index );
				
				//DRM 체크
				drmService.drmConvert("U", "", "E", savePath, newName, fileExt);
				excelContentList = excelService.procExtractExcelTemp( saveFileName );
			}
		}
		if ( excelContentList == null || excelContentList.size( ) == 0 ) {
			mv.addObject( "retData", BizboxAMessage.getMessage( "TX000011779", "엑셀파일 로드 실패" ) );
			return mv;
		}
		//이미지파일 로드
		if ( photoFile != null && !photoFile.isEmpty( ) ) {
			photoFileName = photoFile.getOriginalFilename( );
			Map<String, Object> param = new HashMap<String, Object>( );
			param.put( "groupSeq", loginVO.getGroupSeq( ) );
			param.put( "pathSeq", "" );
			param.put( "osType", NeosConstants.SERVER_OS );
			List<Map<String, Object>> pathList = groupManageService.selectGroupPathList( param );
			if ( pathList == null || pathList.size( ) < 1 ) {
				mv.addObject( "retData", BizboxAMessage.getMessage( "TX000011778", "그룹웨어 경로설정값 없음" ) );
				return mv;
			}
			//파일 절대경로 조회 
			for ( Map<String, Object> path : pathList ) {
				String ps = FormatUtil.getString( path.get( "pathSeq" ) );
				if ( ps.equals( pathSeq ) ) {
					rootPath = FormatUtil.getString( path.get( "absolPath" ) );
				}
			}
			if ( EgovStringUtil.isEmpty( rootPath ) ) {
				mv.addObject( "retData", BizboxAMessage.getMessage( "TX000011778", "그룹웨어 경로설정값 없음" ) );
				return mv;
			}
			String targetDir = rootPath + relativePath + File.separator + "tempimg";
			//기존 임시파일 제거
			EgovFileTool.deleteDirectory( targetDir );
			ZipArchiveInputStream zis = null;
			ZipArchiveEntry zipentry = null;
			try {
				zis = new ZipArchiveInputStream( photoFile.getInputStream( ), "EUC-KR" );
				//entry가 없을때까지 뽑기
				while ( (zipentry = zis.getNextZipEntry( )) != null ) {
					String filename = zipentry.getName( );
					File file = new File( targetDir, filename );
					if ( zipentry.isDirectory( ) ) {
						file.mkdirs( );
					}
					else {
						//파일이면 파일 만들기
						imgList.add( filename );
						EgovFileUploadUtil.saveFile( zis, file );
					}
				}
			}
			catch ( Throwable e ) {
				CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
			}
			finally {
				if ( zis != null ) {
					zis.close( );
				}
			}
		}
		//사원이미지 업로드
		if ( mode.equals( "photo" ) || mode.equals( "sign" ) ) {
			if ( imgList == null || imgList.size( ) == 0 ) {
				mv.addObject( "retData", BizboxAMessage.getMessage( "TX000011777", "이미지파일 없음" ) );
				return mv;
			}
			params.put( "excelContentList", excelContentList );
			params.put( "imgList", imgList );
			validateList = commonSql.list( "EmpManage.getValidateList", params );
		}
		else {
			String batchKey = EgovDateUtil.today( "yyyyMMddHHmmss" ) + loginVO.getUniqId( );
			if ( loginVO.getUserSe( ).equals( "MASTER" ) ) {
				params.put( "compSeq", "" );
			}
			else {
				params.put( "compSeq", loginVO.getCompSeq( ) );
			}
			mv.addObject( "batch_key", batchKey );
			params.put( "batch_key", batchKey );
			params.put( "excelContentList", excelContentList );
			params.put( "createdSeq", loginVO.getUniqId( ) );
			params.put( "langCode", loginVO.getLangCode( ) );
			commonSql.delete( "EmpManage.deleteBatchList", params );
			commonSql.insert( "EmpManage.insertValidateList", params );
			validateList = commonSql.list( "EmpManage.getEmpValidateList", params );
			try {
				params.put( "groupSeq", loginVO.getGroupSeq( ) );
				licenseCountCheck = licenseService.LicenseCountShow( params );
			}
			catch ( Exception e ) {
				CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
			}

			String executeYn = licenseCountCheck.get( "executeYn" ).toString( );
			int totalGwLicense = Integer.parseInt( licenseCountCheck.get( "totalGwCount" ).toString( ) );
			int totalMailLicense = Integer.parseInt( licenseCountCheck.get( "totalMailCount" ).toString( ) );
			int realTotalGwLicense = Integer.parseInt( licenseCountCheck.get( "realGwCount" ).toString( ) );
			int realTotalMailLicense = Integer.parseInt( licenseCountCheck.get( "realMailCount" ).toString( ) );
			
			if (totalGwLicense > Integer.MAX_VALUE || totalGwLicense < Integer.MIN_VALUE) {//정수형 오버플로우 방지 적용
		        throw new IllegalArgumentException("out of bound");
		    }
			if (totalMailLicense > Integer.MAX_VALUE || totalMailLicense < Integer.MIN_VALUE) {//정수형 오버플로우 방지 적용
		        throw new IllegalArgumentException("out of bound");
		    }
			if (realTotalGwLicense > Integer.MAX_VALUE || realTotalGwLicense < Integer.MIN_VALUE) {//정수형 오버플로우 방지 적용
		        throw new IllegalArgumentException("out of bound");
		    }
			if (realTotalMailLicense > Integer.MAX_VALUE || realTotalMailLicense < Integer.MIN_VALUE) {//정수형 오버플로우 방지 적용
		        throw new IllegalArgumentException("out of bound");
		    }
			
			totalGwLicense = totalGwLicense - realTotalGwLicense;
			totalMailLicense = totalMailLicense - realTotalMailLicense;
			
			if(totalMailLicense < 0) {
				totalGwLicense = totalGwLicense + totalMailLicense;
				totalMailLicense = 0;
			}
			
			for ( Map<String, Object> temp : validateList ) {
				
				if(temp.get("check_emp_name").equals(0)
						&& temp.get("check_comp").equals(0)
						&& temp.get("check_auth").equals(0)
						&& temp.get("check_dept").equals(0)
						&& temp.get("check_login_id").equals(0)
						&& temp.get("check_block_login_id").equals(0)
						&& temp.get("check_mail").equals(0)
						&& temp.get("check_block_mail").equals(0)
						&& temp.get("check_position").equals(0)
						&& temp.get("check_duty").equals(0)
						&& temp.get("check_pw").equals(0)
						&& temp.get("check_join_day").equals(0)
						) {
					
					if(!executeYn.equals("-1")) {
						String licenseCheckYn = temp.get( "license_check_yn" ).toString();
						
						if(licenseCheckYn.equals("1")) {
							
							if(totalGwLicense < 1) {
								temp.put( "license_count_check", "-1" );
							}else {
								totalGwLicense --;
							}
							
						}else if(licenseCheckYn.equals("2")) {
							
							if(totalMailLicense > 0) {
								totalMailLicense --;
							}else if(totalGwLicense > 0) {
								totalGwLicense --;
							}else {
								temp.put( "license_count_check", "-2" );
							}
							
						}							
					}
				}
			}			
		}
		
		File path = new File( savePath );
		File[] fileList = path.listFiles( );
		for ( File file : fileList ) {
			if ( file.getName( ).equals( excelFileName ) || file.getName( ).equals( photoFileName ) ) {
				file.delete( );
			}
		}
		mv.addObject( "groupSeq", loginVO.getGroupSeq( ) );
		mv.addObject( "mode", mode );
		mv.addObject( "pathSeq", pathSeq );
		mv.addObject( "rootPath", rootPath );
		mv.addObject( "relativePath", relativePath );
		mv.addObject( "validateList", validateList );
		mv.addObject( "retData", "" );
		return mv;
	}

	@RequestMapping ( "/cmm/systemx/saveEmpBatch.do" )
	public ModelAndView saveEmpBatch ( @RequestParam Map<String, Object> params, HttpServletRequest request ) throws Exception {
		LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser( );
		ModelAndView mv = new ModelAndView( );
		String batchKey = (String) params.get( "batchKey" );
		String jsonStr = (String) params.get( "saveList" );
		ObjectMapper mapper = new ObjectMapper( );
		List<Map<String, Object>> saveList = mapper.readValue( jsonStr, new TypeReference<List<Map<String, Object>>>( ) {} );
		Map<String, Object> mailSyncParam = new HashMap<String, Object>( );
		params.put( "saveList", saveList );
		params.put( "batchKey", batchKey );
		params.put( "langCode", loginVO.getLangCode( ) );
		params.put( "groupSeq", loginVO.getGroupSeq( ) );
		List<Map<String, Object>> empSaveList = commonSql.list( "EmpManage.getEmpBatchList", params );
		for ( Map<String, Object> empInfo : empSaveList ) {
			empInfo.put( "groupSeq", loginVO.getGroupSeq( ) );
			empInfo.put( "createSeq", loginVO.getUniqId( ) );
			empInfo.put( "callType", "saveEmp" );
			
			if(empInfo.get( "licenseCheckYn" ).equals( "1" )) {
				empInfo.put( "orgchartDisplayYn", "Y" );
				empInfo.put( "messengerDisplayYn", "Y" );
			} else if(empInfo.get( "licenseCheckYn" ).equals( "2" )) {
				empInfo.put( "orgchartDisplayYn", "N" );
				empInfo.put( "messengerDisplayYn", "N" );
			} else {
				empInfo.put( "orgchartDisplayYn", "N" );
				empInfo.put( "messengerDisplayYn", "N" );
			}
			
			//날짜데이터 보정
			if(empInfo.get("bday") != null){
				empInfo.put( "bday", dateReplace(empInfo.get("bday").toString()) );	
			}
			
			if(empInfo.get("weddingDay") != null){
				empInfo.put( "weddingDay", dateReplace(empInfo.get("weddingDay").toString()) );	
			}
			
			if(empInfo.get("joinDay") != null){
				empInfo.put( "joinDay", dateReplace(empInfo.get("joinDay").toString()) );	
			}			
			
			Map<String, Object> empSaveAdapterResult = orgAdapterService.empSaveAdapter( empInfo );
			if ( empSaveAdapterResult.get( "resultCode" ).equals( "fail" ) ) {
				empInfo.put( "result", empSaveAdapterResult.get( "result" ) );
			}
			else {
				if ( empInfo.get( "compSeq" ) != null ) {
					mailSyncParam.put( "compSeq", empInfo.get( "compSeq" ) );
				}
				empInfo.put( "result", "" );
			}
		}
		// mailSync호출
		if ( mailSyncParam.get( "compSeq" ) != null ) {
			orgAdapterService.mailUserSync(params);
		}
		//edms 사원 동기화 api호출
//		if ( empSaveList.size( ) > 0 ) {
//			Map<String, Object> para = new HashMap<String, Object>( );
//			para.put( "retKey", batchKey );
//			List<Map<String, Object>> batchEmpList = (List<Map<String, Object>>) commonSql.list( "EmpManage.getEmpBatchCompList", para );
//			if ( batchEmpList != null ) {
//				
//				String domainUrl = CommonUtil.getApiCallDomain(request);
//
//				for ( Map<String, Object> mp : batchEmpList ) {
//					BufferedReader in = null;
//					try {
//						String sUrl = domainUrl + "/edms/home/convUser.do?groupSeq=" + loginVO.getGroupSeq( ) + "&compSeq=" + mp.get( "compSeq" );
//						URL obj = new URL( sUrl ); // 호출할 url
//						HttpURLConnection con = (HttpURLConnection) obj.openConnection( );
//						con.setRequestMethod( "GET" );
//						in = new BufferedReader( new InputStreamReader( con.getInputStream( ), "UTF-8" ) );
//						String line;
//						while ( (line = in.readLine( )) != null ) { // response를 차례대로 출력
//							System.out.println( line );
//						}
//					}
//					catch ( Exception e ) {
//						e.printStackTrace( );
//					}
//					finally {
//						if ( in != null )
//							try {
//								in.close( );
//							}
//							catch ( Exception e ) {
//								e.printStackTrace( );
//							}
//					}
//				}
//			}
//		}
		mv.addObject( "empSaveList", empSaveList );
		mv.addObject( "value", "1" );
		mv.setViewName( "jsonView" );
		return mv;
	}
	
	private String dateReplace ( String inputDate ) {
		String outDate = null;
		
		if(inputDate != null && !inputDate.equals("")){
			inputDate = inputDate.replace("-", "").replace(".", "").replace("/", "");
			
			if(inputDate.length() > 7){
				outDate = inputDate.substring(0,4) + inputDate.substring(4,6) + inputDate.substring(6,8);
			}
		}
		return outDate;
	}

	@RequestMapping(value="/cmm/systemx/saveImageBatch.do", method=RequestMethod.POST)
	public ModelAndView saveImageBatch ( @RequestParam Map<String, Object> params, HttpServletRequest request ) throws Exception {
		String jsonStr = (String) params.get( "saveList" );
		ObjectMapper mapper = new ObjectMapper( );
		List<Map<String, Object>> saveList = mapper.readValue( jsonStr, new TypeReference<List<Map<String, Object>>>( ) {} );
		String groupSeq = (String) params.get( "groupSeq" );
		String pathSeq = (String) params.get( "pathSeq" );
		String rootPath = (String) params.get( "rootPath" );
		String relativePath = (String) params.get( "relativePath" );
		for ( Map<String, Object> saveInfo : saveList ) {
			saveInfo.put( "result", addProfile( groupSeq, pathSeq, (String) saveInfo.get( "emp_seq" ), rootPath, relativePath, (String) saveInfo.get( "pic_file_dir" ) ) );
		}
		ModelAndView mv = new ModelAndView( );
		mv.addObject( "saveList", saveList );
		mv.addObject( "value", "1" );
		mv.setViewName( "jsonView" );
		return mv;
	}

	@SuppressWarnings("unchecked")
	@RequestMapping ( "/cmm/systemx/signPop.do" )
	public ModelAndView myInfoSignPop ( @RequestParam Map<String, Object> params, HttpServletRequest request ) throws Exception {
		ModelAndView mv = new ModelAndView( );
		
		// 마이페이지
		if ( params.get( "page" ).toString( ).equals( "myPage" ) ) {
			Map<String, Object> empInfo = new HashMap<String, Object>( );
			empInfo.put( "empSeq", params.get( "empSeq" ) );
			empInfo.put( "groupSeq", params.get( "groupSeq" ) );
			empInfo.put( "langCode", params.get( "langCode" ) );
			empInfo.put( "compSeq", params.get( "compSeq" ) );
			empInfo.put( "compSeqOld", params.get( "compSeq" ) );
			empInfo.put( "mainYn", "Y" );
			empInfo.put( "subYn", "Y" );
			Map<String, Object> infoMap = empManageService.selectEmpInfo( empInfo, new PaginationInfo( ) );
			List<Map<String, Object>> list = (List<Map<String, Object>>) infoMap.get( "list" );
			Map<String, Object> map = list.get( 0 );
			mv.addObject( "signInfo", params );
			mv.addObject( "infoMap", map );
		}
		else { // 사원등록 페이지
			Map<String, Object> empInfo = new HashMap<String, Object>( );
			if ( params.get( "empSeq" ) != null && !params.get( "empSeq" ).equals("")) {
				empInfo.put( "empSeq", params.get( "empSeq" ) );
				empInfo.put( "groupSeq", params.get("groupSeq") );
				empInfo.put( "compSeq", params.get( "compSeq" ) );
				empInfo.put( "compSeqOld", params.get( "compSeq" ) );
				Map<String, Object> infoMap = empManageService.selectEmpInfo( empInfo, new PaginationInfo( ) );
				List<Map<String, Object>> list = (List<Map<String, Object>>) infoMap.get( "list" );
				Map<String, Object> map = list.get( 0 );
				mv.addObject( "infoMap", map );
			}
			mv.addObject( "signInfo", params );
		}
		
		mv.setViewName( "/neos/cmm/systemx/emp/pop/myInfoSignPop" );
		return mv;
	}

	private String addProfile ( String groupSeq, String pathSeq, String empSeq, String rootPath, String relativePath, String fileDir ) throws Exception {
		/** File Id 생성(성공시 return) */
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("groupSeq", groupSeq);
		mp.put("value", "atchfileid");
		
		String tempDir = rootPath + File.separator + relativePath + File.separator + "tempimg" + File.separator + fileDir;
		
		File tempFile = new File(tempDir);
		if(!tempFile.exists()) {
			return BizboxAMessage.getMessage( "TX000011774", "이미지파일 로드오류" );
		}
		
		String fileNm = EgovFileTool.getName( tempDir );
		String path = rootPath + File.separator + relativePath;
		String orginFileName = "";
		if ( fileNm == "" ) {
			return BizboxAMessage.getMessage( "TX000011774", "이미지파일 로드오류" );
		}
		long fileSize = EgovFileTool.getSize( tempDir );
		/* 확장자 */
		int index = fileNm.lastIndexOf( "." );
		if ( index == -1 ) {
			return BizboxAMessage.getMessage( "TX000011773", "이미지파일명 오류" );
		}
		String fileExt = pathSeq.equals("910") ? "jpg" : fileNm.substring( index + 1 ).toLowerCase( );
		orginFileName = fileNm.substring( 0, index );
		
		String fileId = sequenceService.getSequence( mp );
		
		String newName = pathSeq.equals("910") ? empSeq : (EgovDateUtil.today( "yyyyMMdd_HHmmss" ) + "_" + fileId + "_0");
		
		String saveFilePath = path + File.separator + newName + "." + fileExt;
		
		FileUtils.moveTransfer(tempDir, saveFilePath);
		ImageUtil.saveResizeImage( new File( path + File.separator + newName + "_thum.jpg" ), new File( saveFilePath ), 420 );
		
		List<Map<String, Object>> saveFileList = new ArrayList<Map<String, Object>>( ); // 파일 저장 리스트
		if ( fileSize > 0 ) {
			Map<String, Object> newFileInfo = new HashMap<String, Object>( );
			newFileInfo.put( "fileId", fileId );
			newFileInfo.put( "fileSn", 0 );
			newFileInfo.put( "pathSeq", pathSeq );
			newFileInfo.put( "fileStreCours", relativePath );
			newFileInfo.put( "streFileName", newName );
			newFileInfo.put( "orignlFileName", orginFileName );
			newFileInfo.put( "fileExtsn", fileExt );
			newFileInfo.put( "fileSize", fileSize );
			newFileInfo.put( "createSeq", empSeq );
			newFileInfo.put( "inpName", fileNm );
			saveFileList.add( newFileInfo );
		}
		/** 파일 저장 리스트 확인 */
		if ( saveFileList.size( ) < 1 ) {
			return BizboxAMessage.getMessage( "TX000011772", "이미지파일 저장실패" );
		}
		/** DB Insert */
		List<Map<String, Object>> resultFileIdList = attachFileService.insertAttachFile( saveFileList );
		Map<String, Object> params = new HashMap<String, Object>( );
		params.put("groupSeq", groupSeq);
		params.put( "empSeq", empSeq );
		params.put( "picFileId", fileId );
		if ( pathSeq.equals( "910" ) ) {
			commonSql.update( "loginDAO.updateUserImg", params );
			//프로필 이미지 FTP 전송
			orgAdapterService.ftpProfileSync(params);
		}
		else {
			commonSql.update( "loginDAO.updateSignImg", params );
		}
		/** insert 결과 체크 */
		if ( resultFileIdList == null || resultFileIdList.size( ) == 0 ) {
			return "DB " + BizboxAMessage.getMessage( "TX000002427", "저장실패" );
		}
		else {
			return "";
		}
	}

	@RequestMapping ("/cmm/systemx/deleteEmpMailInfo.do")
	public ModelAndView deleteEmpMailInfo ( @RequestParam Map<String, Object> params, HttpServletRequest request ) throws Exception {
		
		ModelAndView mv = new ModelAndView();
		
		List<Map<String, Object>> selectEmpMailResignList = orgAdapterDAO.selectEmpMailResignList( params );
		if ( selectEmpMailResignList != null && selectEmpMailResignList.size( ) > 0 && ((params.get( "isAll" ).equals( "N" ) && selectEmpMailResignList.size( ) == 1) || params.get( "isAll" ).equals( "Y" )) ) {
			for ( Map<String, Object> info : selectEmpMailResignList ) {
				sendEmailApi( info );
			}
		}
		
		//메일삭제유무 mail_del_yn = 'Y' 셋팅
		commonSql.update("EmpManage.SetEmpMailDelYn", params);
		
		mv.setViewName( "jsonView" );
		
		return mv;
	}
	
	private boolean sendEmailApi ( Map<String, Object> paramMap ) {
		URL u = null;
		HttpURLConnection huc = null;
		try {
			u = new URL( paramMap.get( "url" ).toString( ) );
			paramMap.remove( "url" );
			huc = (HttpURLConnection) u.openConnection( );
			huc.setRequestMethod( "POST" );
			huc.setDoInput( true );
			huc.setDoOutput( true );
			huc.setRequestProperty( "Content-Type", "application/x-www-form-urlencoded" );
			String param = setParam( paramMap );
			OutputStream os = huc.getOutputStream( );
			os.write( param.getBytes( ) );
			os.flush( );
			os.close( );
			InputStream is = huc.getInputStream( );
			Writer writer = new StringWriter( );
			char[] buffer = new char[1024];
			try {
				Reader reader = new BufferedReader( new InputStreamReader( is, "UTF-8" ) );
				int n;
				while ( (n = reader.read( buffer )) != -1 ) {
					writer.write( buffer, 0, n );
				}
				return true;
			}
			finally {
				is.close( );
				writer.close( );
			}
		}
		catch ( Exception e ) {
			return false;
		}
	}

	private String setParam ( Map<String, Object> paramMap ) {
		String param = "";
		for ( String mapKey : paramMap.keySet( ) ) {
			param += mapKey + "=" + paramMap.get( mapKey ) + "&";
		}
		return param;
	}
	
	@RequestMapping ( "/cmm/systemx/getEmpDeptList.do" )
	public ModelAndView getEmpDeptList ( @RequestParam Map<String, Object> params, HttpServletRequest request ) throws Exception {
		ModelAndView mv = new ModelAndView();
		
		mv.addObject("empDeptList", commonSql.list("EmpManage.selectEmpDeptList", params));
		
		mv.setViewName("jsonView");
		return mv;
	}
	
    @RequestMapping ("/cmm/systemx/empExcelDownProc.do")
	public void empExcelDownProc (@RequestParam Map<String, Object> params, HttpServletResponse response, HttpServletRequest servletRequest) 
			throws Exception {
		
		LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser();
		
		//보안취약점 조치(관리자/마스터권한 체크) 2020.09.09
		if(loginVO == null || loginVO.getUserSe().equals("USER") || (loginVO.getUserSe().equals("ADMIN") && !params.get("compSeq").equals(loginVO.getCompSeq()))) {
			return;
		}
		
		// 한글 문자열을 디코딩 해줘야 한다.
		params.put("searchKeyword", URLDecoder.decode((String)params.get("searchKeyword"), "UTF-8"));
		params.put("deptName", URLDecoder.decode((String)params.get("deptName"), "UTF-8"));
		params.put("positionDutyName", URLDecoder.decode((String)params.get("positionDutyName"), "UTF-8"));
				
		SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");
	    Calendar c1 = Calendar.getInstance();
		String strToday = sdf.format(c1.getTime());
		
		String[] colName = new String[9];
		String searchTxt = null;
		String fileNm = "BizboxA_empList_" + strToday;
		String compSeq = null;
		
		colName[0] = BizboxAMessage.getMessage("TX000000018","회사명");
		colName[1] = BizboxAMessage.getMessage("TX000000068","부서명");
		colName[2] = BizboxAMessage.getMessage("TX000000099","직급");
		colName[3] = BizboxAMessage.getMessage("TX000000105","직책");
		colName[4] = BizboxAMessage.getMessage("TX000000076","사원명") + "(ID)";
		colName[5] = "Mail ID";
		colName[6] = BizboxAMessage.getMessage("TX000003305","재직여부");
		colName[7] = BizboxAMessage.getMessage("TX000016716","사용여부");
		colName[8] = BizboxAMessage.getMessage("TX000017941","라이선스");
		
		searchTxt = FormatUtil.getString(params.get("searchKeyword"));
		searchTxt = searchTxt.replaceAll("_", "▩_");
		params.put("nameAndLoginId", searchTxt);
		params.put("langCode", loginVO.getLangCode());
		compSeq = FormatUtil.getString( params.get( "compSeq" ) );
		if ( EgovStringUtil.isEmpty( compSeq ) ) {
			if ( !loginVO.getUserSe( ).equals( "MASTER" ) ) {
				params.put( "compSeq", loginVO.getCompSeq( ) );
			}
		}
		params.put("groupSeq", loginVO.getGroupSeq());
		PaginationInfo paginationInfo = new PaginationInfo();
		
		Map<String, Object> listMap = empManageService.selectEmpInfoNew(params, paginationInfo);
		List<Map<String, Object>> list = (List)listMap.get("list");
		
		
		for(Map item : list) {			
			item.remove("compSeq");
			item.remove("deptSeq");
			item.remove("empSeq");
			item.remove("loginId");
			item.remove("groupSeq");
			item.remove("empName");
			//item.remove("emailAddr");
		}
		
		excelService.CmmExcelDownload(list, colName, fileNm, response, servletRequest);
		
	}
	
	
	
	
	@RequestMapping ( "/cmm/systemx/checkMasterAuth.do" )
	public ModelAndView checkMasterAuth ( @RequestParam Map<String, Object> params, HttpServletRequest request ) throws Exception {
		
		LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser();
		
		ModelAndView mv = new ModelAndView();
		
		//마스터권한 사용자 리스트 조회(유일한 마스터권한 사용자인 경우 삭제처리 불가처리하기 위해)
		Map<String, Object> para = new HashMap<String, Object>();
		para.put("groupSeq", loginVO.getGroupSeq());
		para.put("langCode", loginVO.getLangCode());
		para.put("excludeEmpSeq", params.get("empSeq"));
		List<Map<String, Object>> masterAuthList = commonSql.list("AuthorManageDAO.getAuthorMasterList", para);
		
		mv.addObject("masterAuthCnt", masterAuthList.size());
		mv.setViewName("jsonView");
		
		return mv;
	}

}
