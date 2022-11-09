package neos.cmm.systemx.cert.web;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import api.common.model.APIResponse;
import bizbox.orgchart.service.vo.LoginVO;
import egovframework.com.cmm.util.EgovUserDetailsHelper;
import egovframework.com.utl.fcc.service.EgovStringUtil;
import egovframework.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;
import main.web.BizboxAMessage;
import main.web.BizboxTimelineController;
import neos.cmm.systemx.cert.service.CertManageService;
import neos.cmm.systemx.img.service.FileUploadService;
import neos.cmm.util.BizboxAProperties;
import neos.cmm.util.CommonUtil;
import neos.cmm.util.HttpJsonUtil;
import neos.cmm.util.MessageUtil;
import neos.cmm.util.code.service.CommonCodeService;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;


@Controller
public class CertManageController {

	private static final Logger logger = LoggerFactory.getLogger( BizboxTimelineController.class );
	@Resource ( name = "CertManageService" )
	public CertManageService certManageService;
	@Resource ( name = "CommonCodeService" )
	CommonCodeService commonCodeService;
	@Resource ( name = "FileUploadService" )
	private FileUploadService fileUploadService;

	@RequestMapping ( "/systemx/certRequestAdmin.do" )
	public ModelAndView certRequestList ( @RequestParam Map<String, Object> params, HttpServletRequest request ) throws Exception {
		ModelAndView mv = new ModelAndView( );
		mv.setViewName( "/neos/cmm/systemx/cert/certRequestAdmin" );
		params.put( "redirectPage", "certRequestAdmin.do" );
		MessageUtil.getRedirectMessage( mv, request );
		mv.addObject( "params", params );
		return mv;
	}

	@RequestMapping ( "/systemx/certRequestManage.do" )
	public ModelAndView certRequestManage ( @RequestParam Map<String, Object> params, HttpServletRequest request ) throws Exception {
		ModelAndView mv = new ModelAndView( );
		mv.setViewName( "/neos/cmm/systemx/cert/certRequestManage" );
		params.put( "redirectPage", "certRequestManage.do" );
		MessageUtil.getRedirectMessage( mv, request );
		mv.addObject( "params", params );
		return mv;
	}

	@RequestMapping ( "/systemx/certRequestForm.do" )
	public ModelAndView certRequestForm ( @RequestParam Map<String, Object> params, HttpServletRequest request ) throws Exception {
		LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser( );
		params.put( "compSeq", loginVO.getCompSeq( ) );
		ModelAndView mv = new ModelAndView( );
		mv.setViewName( "/neos/cmm/systemx/cert/certRequestForm" );
		params.put( "redirectPage", "certRequestForm.do" );
		MessageUtil.getRedirectMessage( mv, request );
		mv.addObject( "params", params );
		return mv;
	}

	@RequestMapping ( "/systemx/certRequestUser.do" )
	public ModelAndView certRequestUser ( @RequestParam Map<String, Object> params, HttpServletRequest request ) throws Exception {
		ModelAndView mv = new ModelAndView( );
		mv.setViewName( "/neos/cmm/systemx/cert/certRequestUser" );
		params.put( "redirectPage", "certRequestUser.do" );
		MessageUtil.getRedirectMessage( mv, request );
		mv.addObject( "params", params );
		return mv;
	}

	@RequestMapping ( "/systemx/certRequestIssue.do" )
	public ModelAndView certRequestIssue ( @RequestParam Map<String, Object> params, HttpServletRequest request ) throws Exception {
		ModelAndView mv = new ModelAndView( );
		mv.setViewName( "/neos/cmm/systemx/cert/certRequestIssue" );
		params.put( "redirectPage", "certRequestIssue.do" );
		MessageUtil.getRedirectMessage( mv, request );
		mv.addObject( "params", params );
		return mv;
	}

	@RequestMapping ( "/systemx/getCertificateCompForm.do" )
	public ModelAndView getCertificateCompForm ( @RequestParam Map<String, Object> paramMap, HttpServletRequest request ) throws Exception {
		LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser( );
		APIResponse response = new APIResponse( );
		paramMap.put( "compSeq", loginVO.getCompSeq( ) );
		paramMap.put( "empSeq", loginVO.getUniqId( ) );
		paramMap.put( "groupSeq", loginVO.getGroupSeq( ) );
		ModelAndView mv = new ModelAndView( );
		String result = certManageService.getCertificateCompForm( paramMap );
		if ( result == null || "".equals( result ) ) { // form_seq가 없을 경우
			if ( "USER".equals( loginVO.getUserSe( ) ) ) { // 유저면
				response.setResultCode( "SUCCESS" );
				response.setResultMessage( BizboxAMessage.getMessage( "TX000017927", "증명서가 아직 생성되지 않았습니다.\n증명서 생성 후 사용하여주시기 바랍니다." ) );
				mv.addObject( "ret", response );
			}
			else { // 관리자면
				response.setResultCode( "IGNORE" );
				response.setResultMessage( "IGNORE" );
				mv.addObject( "ret", response );
				certManageService.insertCertificateCompForm( paramMap );
			}
		}
		else {
			if ( "USER".equals( loginVO.getUserSe( ) ) ) {
				response.setResultCode( "FAIL" );
				mv.addObject( "ret", response );
			}
			else {
				response.setResultCode( "FAIL" );
				mv.addObject( "ret", response );
			}
		}
		mv.setViewName( "jsonView" );
		return mv;
	}

	@RequestMapping ( "/systemx/certRequestTest.do" )
	public ModelAndView certRequestTest ( @RequestParam Map<String, Object> params, HttpServletRequest request ) throws Exception {
		ModelAndView mv = new ModelAndView( );
		mv.setViewName( "/neos/cmm/systemx/cert/pop/certRequestTest" );
		params.put( "redirectPage", "certRequestTest.do" );
		MessageUtil.getRedirectMessage( mv, request );
		mv.addObject( "params", params );
		return mv;
	}

	@RequestMapping ( "/systemx/getCertificateList.do" )
	public ModelAndView getCertificateList ( @RequestParam Map<String, Object> paramMap, HttpServletRequest request ) throws Exception {
		/* 변수정의 */
		ModelAndView mv = new ModelAndView( );
		LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser( ); /* 로그인 사용자 정보 */
		try {
			/* 파라미터 정의 정의 */
			paramMap.put( "groupSeq", loginVO.getGroupSeq( ) ); /* 그룹 시퀀스 */
			paramMap.put( "compSeq", loginVO.getCompSeq( ) ); /* 회사 시퀀스 */
			paramMap.put( "langCode", loginVO.getLangCode( ) ); /* 사용자 사용 언어 코드 ( kr, en, jp, cn ) */
			/* 증명서구분 조회 */
			List<Map<String, Object>> certList = certManageService.getCertificateList( paramMap );
			/* 반환값 정의 */
			mv.addObject( "certList", certList );
			mv.addObject( "groupSeq", loginVO.getGroupSeq( ) );
			mv.addObject( "compSeq", loginVO.getCompSeq( ) );
			mv.addObject( "empSeq", loginVO.getUniqId( ) );
		}
		catch ( Exception e ) {
			logger.error( "[증명서신청-/systemx/getCertificateList.do] " + e.toString( ) );
			mv.addObject( "certList", null );
			mv.addObject( "groupSeq", loginVO.getGroupSeq( ) );
			mv.addObject( "compSeq", loginVO.getCompSeq( ) );
			mv.addObject( "empSeq", loginVO.getUniqId( ) );
		}
		mv.setViewName( "jsonView" );
		return mv;
	}

	@RequestMapping ( "/systemx/getCertificateUserList.do" )
	public ModelAndView getCertificateUserList ( @RequestParam Map<String, Object> paramMap, HttpServletRequest request ) throws Exception {
		/* 변수정의 */
		ModelAndView mv = new ModelAndView( );
		LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser( );
		try {
			/* 파라미터 정의 정의 */
			paramMap.put( "groupSeq", loginVO.getGroupSeq( ) );
			paramMap.put( "compSeq", loginVO.getCompSeq( ) );
			paramMap.put( "empSeq", loginVO.getUniqId( ) );
			paramMap.put( "langCode", loginVO.getLangCode( ) );
			/* 증명서구분 조회 */
			List<Map<String, Object>> certList = certManageService.getCertificateUserList( paramMap );
			/* 반환값 정의 */
			mv.addObject( "certList", certList );
			mv.addObject( "groupSeq", loginVO.getGroupSeq( ) );
			mv.addObject( "compSeq", loginVO.getCompSeq( ) );
			mv.addObject( "empSeq", loginVO.getUniqId( ) );
			mv.addObject( "langCode", loginVO.getLangCode( ) );
		}
		catch ( Exception e ) {
			logger.error( "[증명서신청-/systemx/getCertificateUserList.do] " + e.toString( ) );
			mv.addObject( "certList", null );
			mv.addObject( "groupSeq", loginVO.getGroupSeq( ) );
			mv.addObject( "compSeq", loginVO.getCompSeq( ) );
			mv.addObject( "empSeq", loginVO.getUniqId( ) );
			mv.addObject( "langCode", loginVO.getLangCode( ) );
		}
		mv.setViewName( "jsonView" );
		return mv;
	}

	@RequestMapping ( "/systemx/getCertificateStatusList.do" )
	public ModelAndView getCertificateStatusList ( @RequestParam Map<String, Object> paramMap, HttpServletRequest request ) throws Exception {
		LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser( );
		paramMap.put( "langCode", loginVO.getLangCode( ) );
		List<Map<String, Object>> list = certManageService.getCertificateStatusList( paramMap );
		ModelAndView mv = new ModelAndView( );
		mv.addObject( "certStatusList", list );
		mv.setViewName( "jsonView" );
		return mv;
	}

	@RequestMapping ( "/systemx/getCertificateSubmitList.do" )
	public ModelAndView getCertificateSubmitList ( @RequestParam Map<String, Object> paramMap, HttpServletRequest request ) throws Exception {
		LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser( );
		paramMap.put( "langCode", loginVO.getLangCode( ) );
		List<Map<String, Object>> list = certManageService.getCertificateSubmitList( paramMap );
		ModelAndView mv = new ModelAndView( );
		mv.addObject( "certSubmitList", list );
		mv.setViewName( "jsonView" );
		return mv;
	}

	@RequestMapping ( "/systemx/certRequestData.do" )
	public ModelAndView certRequestData ( @RequestParam Map<String, Object> paramMap, HttpServletRequest request ) throws Exception {
		LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser( );
		PaginationInfo paginationInfo = new PaginationInfo( );
		paginationInfo.setCurrentPageNo( EgovStringUtil.zeroConvert( paramMap.get( "page" ) ) );
		paginationInfo.setPageSize( EgovStringUtil.zeroConvert( paramMap.get( "pageSize" ) ) );
		paramMap.put( "groupSeq", loginVO.getGroupSeq( ) );
		paramMap.put( "compSeq", loginVO.getCompSeq( ) );
		paramMap.put( "empSeq", loginVO.getUniqId( ) );
		paramMap.put( "langCode", loginVO.getLangCode( ) );
		Map<String, Object> list = certManageService.selectCertificateList( paramMap, paginationInfo );
		//System.out.println(paramMap);
		ModelAndView mv = new ModelAndView( );
		mv.addAllObjects( list );
		mv.setViewName( "jsonView" );
		return mv;
	}

	@RequestMapping ( "/systemx/certRequestPop.do" )
	public ModelAndView certRequestPop ( @RequestParam Map<String, Object> paramMap, HttpServletRequest request ) throws Exception {
		LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser( );
		ModelAndView mv = new ModelAndView( );
		mv.addObject( "userSe", loginVO.getUserSe( ) );
		mv.addObject( "compSeq", loginVO.getCompSeq( ) );
		mv.setViewName( "/neos/cmm/systemx/cert/pop/certRequestPop" );
		return mv;
	}

	@RequestMapping ( "/systemx/certRequestOpt.do" )
	public ModelAndView certRequestOpt ( @RequestParam Map<String, Object> paramMap, HttpServletRequest request ) throws Exception {
		//LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		ModelAndView mv = new ModelAndView( );
		mv.setViewName( "/neos/cmm/systemx/cert/pop/certRequestOpt" );
		return mv;
	}

	@RequestMapping ( "/systemx/certRequestPrint.do" )
	public ModelAndView certRequestPrint ( @RequestParam Map<String, Object> paramMap, HttpServletRequest request ) throws Exception {
		ModelAndView mv = new ModelAndView( );
		mv.setViewName( "/neos/cmm/systemx/cert/pop/certRequestPrint" );
		LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser( );
		paramMap.put( "groupSeq", loginVO.getGroupSeq( ) );
		paramMap.put( "compSeq", loginVO.getCompSeq( ) );
		paramMap.put( "empSeq", loginVO.getUniqId( ) );
		paramMap.put( "langCode", loginVO.getLangCode( ) );
		Map<String, Object> formLangCode = certManageService.getCertFormLangCode( paramMap ); //증명서 양식 사용언어 가져오기
		paramMap.put( "formLangCode", (String)formLangCode.get("formLangCode") );
		Map<String, Object> cInfo = certManageService.getCertificateInfo( paramMap );
		if ( loginVO.getUserSe( ).equals( "USER" ) && !(Integer.parseInt( cInfo.get( "reqCnt" ).toString( ) ) > Integer.parseInt( cInfo.get( "printCnt" ).toString( ) )) ) {
			mv.addObject( "printAuth", "N" );
			return mv;
		}
		String optionValue = (String) cInfo.get( "optionValue" );
		//데이터 치환
		String cForm = (String) cInfo.get( "formContent" );
		try {
			cForm = cForm.replaceAll( "_DF01_", cInfo.get( "empName" ) == null ? "" : (String) cInfo.get( "empName" ) ); //이름
			cForm = cForm.replaceAll( "_DF02_", cInfo.get( "idnNo" ) == null ? "" : (String) cInfo.get( "idnNo" ) ); //주민등록번호
			cForm = cForm.replaceAll( "_DF03_", cInfo.get( "addr" ) == null ? "" : (String) cInfo.get( "addr" ) ); //주소
			cForm = cForm.replaceAll( "_DF04_", cInfo.get( "dutyNm" ) == null ? "" : (String) cInfo.get( "dutyNm" ) ); //직위
			if ( "0".equals( optionValue ) ) { // 부서
				cForm = cForm.replaceAll( "_DF05_", cInfo.get( "deptNm2" ) == null ? "" : (String) cInfo.get( "deptNm2" ) ); //부서
			}
			else { // 팀
				cForm = cForm.replaceAll( "_DF05_", cInfo.get( "deptNm" ) == null ? "" : (String) cInfo.get( "deptNm" ) ); //부서
			}
			cForm = cForm.replaceAll( "_DF06_", cInfo.get( "workTerm" ) == null ? "" : (String) cInfo.get( "workTerm" ) ); //재직기간
			cForm = cForm.replaceAll( "_DF07_", cInfo.get( "reportTo" ) == null ? "" : (String) cInfo.get( "reportTo" ) ); //제출처
			cForm = cForm.replaceAll( "_DF08_", cInfo.get( "chaBiz" ) == null ? "" : (String) cInfo.get( "chaBiz" ) ); //담당업무
			cForm = cForm.replaceAll( "_DF09_", cInfo.get( "usePurpose2" ) == null ? "" : (String) cInfo.get( "usePurpose2" ) ); //용도
			cForm = cForm.replaceAll( "_DF10_", cInfo.get( "cerSeq" ) == null ? "" : (String) cInfo.get( "cerSeq" ) ); //발급번호
			cForm = cForm.replaceAll( "_DF11_", cInfo.get( "reportDt" ) == null ? "" : (String) cInfo.get( "reportDt" ) ); //제출예정일
			cForm = cForm.replaceAll( "_DF12_", cInfo.get( "bizAddr" ) == null ? "" : (String) cInfo.get( "bizAddr" ) ); //사업장 or 회사주소
			cForm = cForm.replaceAll( "_DF13_", cInfo.get( "coNm" ) == null ? "" : (String) cInfo.get( "coNm" ) ); //상호
			cForm = cForm.replaceAll( "_DF14_", cInfo.get( "ownerName" ) == null ? "" : (String) cInfo.get( "ownerName" ) ); //대표이사
			cForm = cForm.replaceAll( "_DF15_", cInfo.get( "compRegistNum" ) == null ? "" : (String) cInfo.get( "compRegistNum" ) ); //사업자번호
			cForm = cForm.replaceAll( "_DF18_", cInfo.get( "coNm" ) == null ? "" : (String) cInfo.get( "coNm" ) ); //회사명
			cForm = cForm.replaceAll( "_DF19_", cInfo.get( "erpEmpNo" ) == null ? "" : (String) cInfo.get( "erpEmpNo" ) ); //사번
			cForm = cForm.replaceAll( "_DF20_", cInfo.get( "coNmDisp" ) == null ? "" : (String) cInfo.get( "coNmDisp" ) ); //회사약칭
			cForm = cForm.replaceAll( "_DF21_", cInfo.get( "workNmDisp" ) == null ? "" : (String) cInfo.get( "workNmDisp" ) ); //사업장약칭
			cForm = cForm.replaceAll( "_DF22_", cInfo.get( "joinDay" ) == null ? "" : (String) cInfo.get( "joinDay" ) ); //입사일
			cForm = cForm.replaceAll( "_DF23_", cInfo.get( "appDt2" ) == null ? "" : (String) cInfo.get( "appDt2" ) ); //발급일자
			cForm = cForm.replaceAll( "_DF24_", cInfo.get( "gradeNm" ) == null ? "" : (String) cInfo.get( "gradeNm" ) ); //직급
			cForm = cForm.replaceAll( "_DF25_", cInfo.get( "bday" ) == null ? "" : (String) cInfo.get( "bday" ) ); //생년월일
			cForm = cForm.replaceAll( "_DF31_", cInfo.get( "yyyy" ) == null ? "" : (String) cInfo.get( "yyyy" ) ); //해당년도
			cForm = cForm.replaceAll( "_DF32_", cInfo.get( "workTerm2" ) == null ? "" : (String) cInfo.get( "workTerm2" ) ); //재직기간(개월수)
			cForm = cForm.replaceAll( "_DF33_", cInfo.get( "resignDay" ) == null ? "" : (String) cInfo.get( "resignDay" ) ); //퇴직일자
			cForm = cForm.replaceAll( "_DF34_", cInfo.get( "deptNickname" ) == null ? "" : (String) cInfo.get( "deptNickname" ) ); //부서약칭
			paramMap.put( "orgSeq", loginVO.getCompSeq( ) );
			List<Map<String, Object>> imgList = fileUploadService.getOrgImg( paramMap );
			if ( imgList != null ) {
				Map<String, Object> imgMap = new HashMap<String, Object>( );
				for ( Map map : imgList ) {
					if ( "IMG_COMP_STAMP1".equals( map.get( "imgType" ) ) ) {
						cForm = cForm.replaceAll( "/gw/Images/temp/_DF26_.jpg", "/gw/cmm/file/fileDownloadProc.do?fileId=" + map.get( "fileId" ) + "&fileSn=0" ); //법인인감
					}
					else if ( "IMG_COMP_STAMP2".equals( map.get( "imgType" ) ) ) {
						cForm = cForm.replaceAll( "/gw/Images/temp/_DF27_.jpg", "/gw/cmm/file/fileDownloadProc.do?fileId=" + map.get( "fileId" ) + "&fileSn=0" ); //법인인감
					}
					else if ( "IMG_COMP_STAMP3".equals( map.get( "imgType" ) ) ) {
						cForm = cForm.replaceAll( "/gw/Images/temp/_DF28_.jpg", "/gw/cmm/file/fileDownloadProc.do?fileId=" + map.get( "fileId" ) + "&fileSn=0" ); //법인인감
					}
					else if ( "IMG_COMP_DRAFT_LOGO".equals( map.get( "imgType" ) ) ) {
						cForm = cForm.replaceAll( "/gw/Images/temp/_DF29_.jpg", "/gw/cmm/file/fileDownloadProc.do?fileId=" + map.get( "fileId" ) + "&fileSn=0" ); //법인인감
					}
				}
			}
			// 샘플이미지 유효성검사
			if ( cForm.indexOf( "_DF26_" ) > -1 ) {
				cForm = cForm.replaceAll( "<img id=\"_DF26_\" src=\"/gw/Images/temp/_DF26_.jpg\" alt=\"\" width=\"76\">", "" );
				cForm = cForm.replaceAll( "<img width=\"76\" id=\"_DF26_\" alt=\"\" src=\"/gw/Images/temp/_DF26_.jpg\">", "" );
				cForm = cForm.replaceAll( "<img width=\"76\" id=\"_DF26_\" alt src=\"/gw/Images/temp/_DF26_.jpg\">", "" );
			}
			if ( cForm.indexOf( "_DF27_" ) > -1 ) {
				cForm = cForm.replaceAll( "<img id=\"_DF27_\" src=\"/gw/Images/temp/_DF27_.jpg\" alt=\"\" width=\"76\">", "" );
				cForm = cForm.replaceAll( "<img width=\"76\" id=\"_DF27_\" alt=\"\" src=\"/gw/Images/temp/_DF27_.jpg\">", "" );
				cForm = cForm.replaceAll( "<img width=\"76\" id=\"_DF27_\" alt src=\"/gw/Images/temp/_DF27_.jpg\">", "" );
			}
			if ( cForm.indexOf( "_DF28_" ) > -1 ) {
				cForm = cForm.replaceAll( "<img id=\"_DF28_\" src=\"/gw/Images/temp/_DF28_.jpg\" alt=\"\" width=\"76\">", "" );
				cForm = cForm.replaceAll( "<img width=\"76\" id=\"_DF28_\" alt=\"\" src=\"/gw/Images/temp/_DF28_.jpg\">", "" );
				cForm = cForm.replaceAll( "<img width=\"76\" id=\"_DF28_\" alt src=\"/gw/Images/temp/_DF28_.jpg\">", "" );
			}
			if ( cForm.indexOf( "_DF29_" ) > -1 ) {
				cForm = cForm.replaceAll( "<img id=\"_DF29_\" src=\"/gw/Images/temp/_DF29_.jpg\" alt=\"\" width=\"160\">", "" );
				cForm = cForm.replaceAll( "<img width=\"76\" id=\"_DF29_\" alt=\"\" src=\"/gw/Images/temp/_DF29_.jpg\">", "" );
				cForm = cForm.replaceAll( "<img width=\"76\" id=\"_DF29_\" alt src=\"/gw/Images/temp/_DF29_.jpg\">", "" );
			}
		}
		catch ( Exception e ) {
			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
		}
		cInfo.put( "formContent2", cForm );
		mv.addObject( "cInfo", cInfo );
		mv.addObject( "printAuth", "Y" );
		return mv;
	}

	@RequestMapping ( "/systemx/getCertificateInfo.do" )
	public ModelAndView getCertificateInfo ( @RequestParam Map<String, Object> paramMap, HttpServletRequest request ) throws Exception {
		LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser( );
		paramMap.put( "groupSeq", loginVO.getGroupSeq( ) );
		paramMap.put( "compSeq", loginVO.getCompSeq( ) );
		paramMap.put( "empSeq", loginVO.getUniqId( ) );
		paramMap.put( "langCode", loginVO.getLangCode( ) );
		Map<String, Object> cInfo = certManageService.getCertificateInfo( paramMap );
		ModelAndView mv = new ModelAndView( );
		//데이터 치환 
		String cForm = (String) cInfo.get( "formContent" );
		try {
			cForm = cForm.replaceAll( "_DF01_", cInfo.get( "empName" ) == null ? "" : (String) cInfo.get( "empName" ) ); //이름
			cForm = cForm.replaceAll( "_DF02_", cInfo.get( "idnNo" ) == null ? "" : (String) cInfo.get( "idnNo" ) ); //주민등록번호
			cForm = cForm.replaceAll( "_DF03_", cInfo.get( "addr" ) == null ? "" : (String) cInfo.get( "addr" ) ); //주소
			cForm = cForm.replaceAll( "_DF04_", cInfo.get( "dutyNm" ) == null ? "" : (String) cInfo.get( "dutyNm" ) ); //직위
			cForm = cForm.replaceAll( "_DF05_", cInfo.get( "deptNm" ) == null ? "" : (String) cInfo.get( "deptNm" ) ); //부서
			cForm = cForm.replaceAll( "_DF06_", cInfo.get( "workTerm" ) == null ? "" : (String) cInfo.get( "workTerm" ) ); //재직기간
			cForm = cForm.replaceAll( "_DF07_", cInfo.get( "reportTo" ) == null ? "" : (String) cInfo.get( "reportTo" ) ); //제출처
			cForm = cForm.replaceAll( "_DF08_", cInfo.get( "chaBiz" ) == null ? "" : (String) cInfo.get( "chaBiz" ) ); //담당업무
			cForm = cForm.replaceAll( "_DF09_", cInfo.get( "usePurpose2" ) == null ? "" : (String) cInfo.get( "usePurpose2" ) ); //용도
			cForm = cForm.replaceAll( "_DF10_", cInfo.get( "cerSeq" ) == null ? "" : (String) cInfo.get( "cerSeq" ) ); //발급번호
			cForm = cForm.replaceAll( "_DF11_", cInfo.get( "reportDt" ) == null ? "" : (String) cInfo.get( "reportDt" ) ); //제출예정일
			cForm = cForm.replaceAll( "_DF12_", cInfo.get( "bizAddr" ) == null ? "" : (String) cInfo.get( "bizAddr" ) ); //사업장 or 회사주소
			cForm = cForm.replaceAll( "_DF13_", cInfo.get( "coNm" ) == null ? "" : (String) cInfo.get( "coNm" ) ); //상호
			cForm = cForm.replaceAll( "_DF14_", cInfo.get( "ownerName" ) == null ? "" : (String) cInfo.get( "ownerName" ) ); //대표이사
			cForm = cForm.replaceAll( "_DF15_", cInfo.get( "compRegistNum" ) == null ? "" : (String) cInfo.get( "compRegistNum" ) ); //사업자번호
			cForm = cForm.replaceAll( "_DF18_", cInfo.get( "coNm" ) == null ? "" : (String) cInfo.get( "coNm" ) ); //회사명
			cForm = cForm.replaceAll( "_DF19_", cInfo.get( "erpEmpNo" ) == null ? "" : (String) cInfo.get( "erpEmpNo" ) ); //사번
			cForm = cForm.replaceAll( "_DF20_", cInfo.get( "coNmDisp" ) == null ? "" : (String) cInfo.get( "coNmDisp" ) ); //회사약칭
			cForm = cForm.replaceAll( "_DF21_", cInfo.get( "workNmDisp" ) == null ? "" : (String) cInfo.get( "workNmDisp" ) ); //사업장약칭
			cForm = cForm.replaceAll( "_DF22_", cInfo.get( "joinDay" ) == null ? "" : (String) cInfo.get( "joinDay" ) ); //입사일
			cForm = cForm.replaceAll( "_DF23_", cInfo.get( "appDt2" ) == null ? "" : (String) cInfo.get( "appDt2" ) ); //발급일자
			cForm = cForm.replaceAll( "_DF24_", cInfo.get( "gradeNm" ) == null ? "" : (String) cInfo.get( "gradeNm" ) ); //직급
			cForm = cForm.replaceAll( "_DF25_", cInfo.get( "bday" ) == null ? "" : (String) cInfo.get( "bday" ) ); //생년월일
			cForm = cForm.replaceAll( "_DF31_", cInfo.get( "yyyy" ) == null ? "" : (String) cInfo.get( "yyyy" ) ); //해당년도
			cForm = cForm.replaceAll( "_DF32_", cInfo.get( "workTerm2" ) == null ? "" : (String) cInfo.get( "workTerm2" ) ); //재직기간(개월수)
			cForm = cForm.replaceAll( "_DF33_", cInfo.get( "resignDay" ) == null ? "" : (String) cInfo.get( "resignDay" ) ); //퇴직일자
			cForm = cForm.replaceAll( "_DF34_", cInfo.get( "deptNickname" ) == null ? "" : (String) cInfo.get( "deptNickname" ) ); //부서약칭
			paramMap.put( "orgSeq", loginVO.getCompSeq( ) );
			List<Map<String, Object>> imgList = fileUploadService.getOrgImg( paramMap );
			if ( imgList != null ) {
				for ( Map map : imgList ) {
					if ( "IMG_COMP_STAMP1".equals( map.get( "imgType" ) ) ) {
						cForm = cForm.replaceAll( "/gw/Images/temp/_DF26_.jpg", "/gw/cmm/file/fileDownloadProc.do?fileId=" + map.get( "fileId" ) + "&fileSn=0" ); //법인인감
					}
					else if ( "IMG_COMP_STAMP2".equals( map.get( "imgType" ) ) ) {
						cForm = cForm.replaceAll( "/gw/Images/temp/_DF27_.jpg", "/gw/cmm/file/fileDownloadProc.do?fileId=" + map.get( "fileId" ) + "&fileSn=0" ); //법인인감
					}
					else if ( "IMG_COMP_STAMP3".equals( map.get( "imgType" ) ) ) {
						cForm = cForm.replaceAll( "/gw/Images/temp/_DF28_.jpg", "/gw/cmm/file/fileDownloadProc.do?fileId=" + map.get( "fileId" ) + "&fileSn=0" ); //법인인감
					}
					else if ( "IMG_COMP_DRAFT_LOGO".equals( map.get( "imgType" ) ) ) {
						cForm = cForm.replaceAll( "/gw/Images/temp/_DF29_.jpg", "/gw/cmm/file/fileDownloadProc.do?fileId=" + map.get( "fileId" ) + "&fileSn=0" ); //법인인감
					}
				}
			}
			// 샘플이미지 유효성검사
			if ( cForm.indexOf( "_DF26_" ) > -1 ) {
				cForm = cForm.replaceAll( "<img id=\"_DF26_\" src=\"/gw/Images/temp/_DF26_.jpg\" alt=\"\" width=\"76\">", "" );
				cForm = cForm.replaceAll( "<img width=\"76\" id=\"_DF26_\" alt=\"\" src=\"/gw/Images/temp/_DF26_.jpg\">", "" );
				cForm = cForm.replaceAll( "<img width=\"76\" id=\"_DF26_\" alt src=\"/gw/Images/temp/_DF26_.jpg\">", "" );
			}
			if ( cForm.indexOf( "_DF27_" ) > -1 ) {
				cForm = cForm.replaceAll( "<img id=\"_DF27_\" src=\"/gw/Images/temp/_DF27_.jpg\" alt=\"\" width=\"76\">", "" );
				cForm = cForm.replaceAll( "<img width=\"76\" id=\"_DF27_\" alt=\"\" src=\"/gw/Images/temp/_DF27_.jpg\">", "" );
				cForm = cForm.replaceAll( "<img width=\"76\" id=\"_DF27_\" alt src=\"/gw/Images/temp/_DF27_.jpg\">", "" );
			}
			if ( cForm.indexOf( "_DF28_" ) > -1 ) {
				cForm = cForm.replaceAll( "<img id=\"_DF28_\" src=\"/gw/Images/temp/_DF28_.jpg\" alt=\"\" width=\"76\">", "" );
				cForm = cForm.replaceAll( "<img width=\"76\" id=\"_DF28_\" alt=\"\" src=\"/gw/Images/temp/_DF28_.jpg\">", "" );
				cForm = cForm.replaceAll( "<img width=\"76\" id=\"_DF28_\" alt src=\"/gw/Images/temp/_DF28_.jpg\">", "" );
			}
			if ( cForm.indexOf( "_DF29_" ) > -1 ) {
				cForm = cForm.replaceAll( "<img id=\"_DF29_\" src=\"/gw/Images/temp/_DF29_.jpg\" alt=\"\" width=\"160\">", "" );
				cForm = cForm.replaceAll( "<img width=\"76\" id=\"_DF29_\" alt=\"\" src=\"/gw/Images/temp/_DF29_.jpg\">", "" );
				cForm = cForm.replaceAll( "<img width=\"76\" id=\"_DF29_\" alt src=\"/gw/Images/temp/_DF29_.jpg\">", "" );
			}
		}
		catch ( Exception e ) {
			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
		}
		cInfo.put( "formContent2", cForm );
		mv.addObject( "cInfo", cInfo );
		mv.setViewName( "jsonView" );
		return mv;
	}

	@RequestMapping ( "/systemx/getCertificatePresentConditionList.do" )
	public ModelAndView selectCertificatePresentCondition ( @RequestParam Map<String, Object> paramMap, HttpServletRequest request ) throws Exception {
		LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser( );
		paramMap.put( "groupSeq", loginVO.getGroupSeq( ) );
		paramMap.put( "compSeq", loginVO.getCompSeq( ) );
		paramMap.put( "langCode", loginVO.getLangCode( ) );
		List<Map<String, Object>> list = certManageService.selectCertificatePresentCondition( paramMap );
		//System.out.println(list);
		int reqCnt10 = 0;
		int reqCnt20 = 0;
		int reqCnt30 = 0;
		int reqCnt40 = 0;
		int reqCnt50 = 0;
		int reqCnt60 = 0;
		int reqCnt70 = 0;
		int reqCntSum = 0;
		for ( int r = 0; r < list.size( ); r++ ) {
			Map<String, Object> addMap = new HashMap<String, Object>( );
			addMap = list.get( r );
			reqCnt10 += (long) addMap.get( "reqCnt10" );
			reqCnt20 += (long) addMap.get( "reqCnt20" );
			reqCnt30 += (long) addMap.get( "reqCnt30" );
			reqCnt40 += (long) addMap.get( "reqCnt40" );
			reqCnt50 += (long) addMap.get( "reqCnt50" );
			reqCnt60 += (long) addMap.get( "reqCnt60" );
			reqCnt70 += (long) addMap.get( "reqCnt70" );
			reqCntSum += (long) addMap.get( "reqCntSum" );
		}
		Map<String, Object> sumMap = new HashMap<String, Object>( );
		sumMap.put( "formSeq", "0" );
		sumMap.put( "groupSeq", "0" );
		sumMap.put( "compSeq", "0" );
		sumMap.put( "formNm", "[" + BizboxAMessage.getMessage( "TX000007417", "소계" ) + "]" );
		sumMap.put( "reqCnt70", reqCnt70 );
		sumMap.put( "reqCnt10", reqCnt10 );
		sumMap.put( "reqCnt20", reqCnt20 );
		sumMap.put( "reqCnt30", reqCnt30 );
		sumMap.put( "reqCnt40", reqCnt40 );
		sumMap.put( "reqCnt50", reqCnt50 );
		sumMap.put( "reqCnt60", reqCnt60 );
		sumMap.put( "reqCnt70", reqCnt70 );
		sumMap.put( "reqCntSum", reqCntSum );
		list.add( sumMap );
		/*
		 * if (list.size() > 0) {
		 * Map<String, Object> map = new HashMap<String, Object>();
		 * map = list.get(0);
		 * for (Map.Entry<String, Object> entry : map.entrySet()) {
		 * if(entry.getKey().equals("formNm")){
		 * map.put(entry.getKey(), "[소계]");
		 * }
		 * else {
		 * map.put(entry.getKey(), 0);
		 * }
		 * }
		 * for (int r = 0 ; r < list.size() ; r++) {
		 * Map<String, Object> sumMap = new HashMap<String, Object>();
		 * sumMap = list.get(r);
		 * for (Map.Entry<String, Object> entry2 : sumMap.entrySet()) {
		 * if(!entry2.getKey().equals("formNm")){
		 * // !확인필요
		 * map.put(entry2.getKey(), (int)map.get(entry2.getKey()) + (int)entry2.getValue());
		 * }
		 * }
		 * }
		 * list.add(map);
		 * }
		 * System.out.println(list);
		 */
		ModelAndView mv = new ModelAndView( );
		mv.addObject( "cpcList", list );
		mv.setViewName( "jsonView" );
		return mv;
	}

	@RequestMapping ( "/systemx/certFromData.do" )
	public ModelAndView certFromData ( @RequestParam Map<String, Object> paramMap, HttpServletRequest request ) throws Exception {
		LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser( );
		paramMap.put( "groupSeq", loginVO.getGroupSeq( ) );
		paramMap.put( "compSeq", loginVO.getCompSeq( ) );
		Map<String, Object> fData = certManageService.getCertificateFormInfo( paramMap );
		//System.out.println(fData);
		ModelAndView mv = new ModelAndView( );
		mv.addObject( "formData", fData );
		mv.setViewName( "jsonView" );
		return mv;
	}

	@RequestMapping ( "/systemx/getCertificateDefaultInfo.do" )
	public ModelAndView getCertificateDefaultInfo ( @RequestParam Map<String, Object> paramMap, HttpServletRequest request ) throws Exception {
		/* 변수정의 */
		ModelAndView mv = new ModelAndView( );
		LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser( );
		try {
			/* 파라미터 정의 */
			paramMap.put( "groupSeq", loginVO.getGroupSeq( ) );
			paramMap.put( "compSeq", loginVO.getCompSeq( ) );
			paramMap.put( "langCode", loginVO.getLangCode( ) );
			if ( paramMap.get( "eSeq" ) != null ) {
				paramMap.put( "deptSeq", paramMap.get( "dSeq" ) );
				paramMap.put( "empSeq", paramMap.get( "eSeq" ) );
			}
			else {
				paramMap.put( "deptSeq", loginVO.getOrgnztId( ) );
				paramMap.put( "empSeq", loginVO.getUniqId( ) );
			}
			Map<String, Object> dInfo = certManageService.getCertificateDefaultInfo( paramMap );
			mv.addObject( "dInfo", dInfo );
		}
		catch ( Exception e ) {
			logger.error( "[증명서신청-/systemx/getCertificateDefaultInfo.do] " + e.toString( ) );
			mv.addObject( "dInfo", null );
		}
		mv.setViewName( "jsonView" );
		return mv;
	}

	@SuppressWarnings ( "static-access" )
	@RequestMapping ( "/systemx/requestCertificate.do" )
	public ModelAndView requestCertificate ( @RequestParam Map<String, Object> paramMap, HttpServletRequest request ) throws Exception {
		LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser( );
		
		if( paramMap.get( "groupSeq" ) == null) {
			paramMap.put( "groupSeq", loginVO.getGroupSeq( ) );
		}
		
		if( paramMap.get( "deptSeq" ) == null ) {
			paramMap.put( "deptSeq", loginVO.getOrgnztId( ) );
		}
		
		String cerSeq = certManageService.getCerSeq( paramMap );
		int cerNo = certManageService.getCerNo( paramMap );
		if ( paramMap.get( "eSeq" ) != null ) {
			paramMap.put( "eSeq", paramMap.get( "eSeq" ) );
		}
		else {
			paramMap.put( "eSeq", loginVO.getUniqId( ) );
		}
		if ( paramMap.get( "empSeq" ) == null ) {
			paramMap.put( "empSeq", loginVO.getUniqId( ) );
		}
		if ( paramMap.get( "compSeq" ) == null ) {
			paramMap.put( "compSeq", loginVO.getCompSeq( ) );
		}
		paramMap.put( "cerSeq", cerSeq );
		paramMap.put( "cerNo", cerNo );
		
		
		//직급,직책명 조회
		Map<String, Object> empDutyPosiInfo = certManageService.getEmpDutyPosiInfo( paramMap );
		if(empDutyPosiInfo != null){
			paramMap.put("dutyNm", empDutyPosiInfo.get("dutyNm"));
			paramMap.put("gradeNm", empDutyPosiInfo.get("gradeNm"));
		}
		
		certManageService.requestCertificate( paramMap );
		//IF알림 전송
		if ( paramMap.get( "adminReqYn" ).equals( "N" ) ) {
			List<Map<String, Object>> list = certManageService.getCertificateAlarmList( paramMap );
			if ( list != null && list.size( ) > 0 ) {
				JSONObject obj = new JSONObject( );
				JSONObject objData = new JSONObject( );
				JSONArray objSubArr = new JSONArray( );
				JSONObject objSub = new JSONObject( );
				obj.put( "eventType", "ATTEND" );
				obj.put( "eventSubType", "AT001" );
				obj.put( "groupSeq", loginVO.getGroupSeq( ) );
				obj.put( "compSeq", loginVO.getCompSeq( ) );
				obj.put( "senderSeq", loginVO.getUniqId( ) );
				obj.put( "alertYn", "Y" );
				obj.put( "pushYn", "Y" );
				obj.put( "talkYn", "N" );
				obj.put( "mailYn", "N" );
				obj.put( "smsYn", "N" );
				obj.put( "portalYn", "Y" );
				obj.put( "timelineYn", "Y" );
				obj.put( "recvEmpBulk", "" );
				//알림 데이터 정의
				objData.put( "cert_seq", cerSeq );
				objData.put( "form_nm", paramMap.get( "formNm" ) );
				objData.put( "purpose_nm", paramMap.get( "purposeNm" ) );
				objData.put( "report_to", paramMap.get( "reportTo" ) );
				objData.put( "comp_nm", paramMap.get( "coNm" ) );
				objData.put( "dept_nm", paramMap.get( "deptNm" ) );
				objData.put( "grade_nm", paramMap.get( "gradeNm" ) );
				objData.put( "user_nm", loginVO.getName( ) );
				objData.put( "user_seq", loginVO.getUniqId( ) );
				objData.put( "menu_id", "934000001" );
				obj.put( "url", "/systemx/certRequestPop.do?rType=A&cerSeq=" + cerSeq );
				//알림 수신자 설정
				for ( Map<String, Object> map : list ) {
					objSub.put( "compSeq", map.get( "compSeq" ) );
					objSub.put( "deptSeq", map.get( "deptSeq" ) );
					objSub.put( "empSeq", map.get( "empSeq" ) );
					objSub.put( "normalTalk", "0" );
					objSub.put( "projectTalk", "0" );
					objSub.put( "mail", "0" );
					objSub.put( "eapproval", "0" );
					objSub.put( "eapprovalRef", "0" );
					objSub.put( "message", "0" );
					objSub.put( "pushYn", "Y" );
					objSubArr.add( objSub );
				}
				obj.put( "recvEmpList", objSubArr );
				obj.put( "data", objData );
				HttpJsonUtil httpJsonUtil = new HttpJsonUtil( );
				httpJsonUtil.execute( "POST", BizboxAProperties.getProperty( "BizboxA.event.url" ) + "/event/EventSend", obj );
			}
		}
		ModelAndView mv = new ModelAndView( );
		mv.addObject( "ret", "succ" );
		mv.setViewName( "jsonView" );
		return mv;
	}

	@RequestMapping ( "/systemx/setCertificatePrintInfo.do" )
	public ModelAndView setCertificatePrintInfo ( @RequestParam Map<String, Object> paramMap, HttpServletRequest request ) throws Exception {
		LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser( );
		paramMap.put( "groupSeq", loginVO.getGroupSeq( ) );
		paramMap.put( "compSeq", loginVO.getCompSeq( ) );
		paramMap.put( "empSeq", loginVO.getUniqId( ) );
		if ( loginVO.getUserSe( ).equals( "USER" ) ) {
			certManageService.setCertificatePrintInfo( paramMap );
		}
		ModelAndView mv = new ModelAndView( );
		mv.addObject( "resultVal", "1" );
		mv.setViewName( "jsonView" );
		return mv;
	}

	@RequestMapping ( "/systemx/apprCertificate.do" )
	public ModelAndView apprCertificate ( @RequestParam Map<String, Object> paramMap, HttpServletRequest request ) throws Exception {
		String alertYn = "";
		String pushYn = "";
		String talkYn = "";
		String mailYn = "";
		String smsYn = "";
		String portalYn = "";
		String timelineYn = "";
		LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser( );
		paramMap.put( "groupSeq", loginVO.getGroupSeq( ) );
		paramMap.put( "compSeq", loginVO.getCompSeq( ) );
		paramMap.put( "empSeq", loginVO.getUniqId( ) );
		certManageService.apprCertificate( paramMap );
		//IF알림 전송
		String apprStat = paramMap.get( "apprStat" ).toString( );
		String cerSeq = paramMap.get( "cerSeq" ).toString( );
		String compNm = loginVO.getOrganNm();
		String formNm = paramMap.get("formNm").toString();
		String deptNm = paramMap.get("deptNm").toString();
		String gradeNm = paramMap.get("gradeNm").toString();
		String userNm = paramMap.get("userName").toString();
		String userSeq = paramMap.get("userSeq").toString();
		String purposeNm = paramMap.get("purposeNm").toString();
		String reportTo = paramMap.get("reportTo").toString();
		String applyDate = paramMap.get("applyDate").toString();
		String approvalDate = new java.text.SimpleDateFormat("yyyy-MM-dd").format(new java.util.Date());
		Map<String, Object> userInfo = certManageService.selectCertificateUserInfo( paramMap );
		if ( userInfo != null && userInfo.size( ) > 0 ) {
			JSONObject obj = new JSONObject( );
			JSONObject objData = new JSONObject( );
			JSONArray objSubArr = new JSONArray( );
			JSONObject objSub = new JSONObject( );
			obj.put( "eventType", "ATTEND" ); // 이벤트 구분값
			obj.put( "eventSubType", apprStat.equals( "20" ) ? "AT002" : "AT003" ); // 이벤트 구분값 	
			obj.put( "groupSeq", loginVO.getGroupSeq( ) ); // 그룹 시퀀스
			obj.put( "compSeq", loginVO.getCompSeq( ) ); // 회사 시퀀스
			obj.put( "senderSeq", loginVO.getUniqId( ) ); // 발신자 시퀀스
			obj.put( "alertYn", alertYn ); // 메신저 알림 여부 Y/N
			obj.put( "pushYn", pushYn ); // 모바일 알림 여부 Y/N
			obj.put( "talkYn", talkYn ); // 대화 발송 여부 Y/N
			obj.put( "mailYn", mailYn ); // 메일 전송 여부 Y/N
			obj.put( "smsYn", smsYn ); // SMS 발송여부 Y/N
			obj.put( "portalYn", portalYn ); // 알림 페이지 등록 여부 Y/N
			obj.put( "timelineYn", timelineYn ); // 타임라인 등록 여부 Y/N												
			obj.put( "recvEmpBulk", "" ); // 수신자 일괄 전송( 그룹 : "G|그룹seq|0|0"   ex. G|53|0|0 )
			//알림 데이터 정의
			objData.put( "cert_seq", cerSeq ); // 증명서 키값
			objData.put( "appr_nm", apprStat.equals( "20" ) ? BizboxAMessage.getMessage( "TX000000798", "승인" ) : BizboxAMessage.getMessage( "TX000002954", "반려" ) ); // 상태값 문자열
			objData.put( "user_nm", loginVO.getName( ) ); // 알림자 이름
			objData.put( "user_seq", loginVO.getUniqId( ) ); // 알림자 시퀀스
			objData.put( "menu_id", apprStat.equals( "20" ) ? "702000002" : "702000001" ); // 증명서 메뉴 ID
			
			objData.put( "comp_nm", compNm); // 신청자 회사명
			objData.put( "form_nm", formNm); // 증명서 구분명
			objData.put( "dept_nm", deptNm); // 신청자 부서명
			objData.put( "grade_nm", gradeNm); // 신청자 직습
			objData.put( "req_user_nm", userNm); // 신청자명
			objData.put( "req_user_seq", userSeq); // 신청자 시퀀스
			objData.put( "purpose_nm", purposeNm); // 사용목적
			objData.put( "report_to", reportTo); // 제출처
			objData.put( "applyDate", applyDate); // 증명서 신청일자
			objData.put( "approvalDate", approvalDate); //증명서 승인일자
			
			//증명서 이동 url
			obj.put( "url", apprStat.equals( "20" ) ? "/systemx/certRequestUser.do?mType=issue&menu_no=702000002" : "/systemx/certRequestUser.do?mType=request&menu_no=702000001" );
			//알림 수신자 설정
			objSub.put( "compSeq", userInfo.get( "compSeq" ) ); // 회사 시퀀스 
			objSub.put( "deptSeq", userInfo.get( "deptSeq" ) ); // 부서 시퀀스		
			objSub.put( "empSeq", userInfo.get( "empSeq" ) ); // 사용자 시퀀스	
			objSub.put( "normalTalk", "0" ); // 일반 대화 카운트
			objSub.put( "projectTalk", "0" ); // 프로젝트 대화 카운트
			objSub.put( "mail", "0" ); // 메일 카운트
			objSub.put( "eapproval", "0" ); // 전자결재(미결함) 카운트
			objSub.put( "eapprovalRef", "0" ); // 전자결재(수신참조함) 카운트
			objSub.put( "message", "0" ); // 쪽지 안읽은 카운트
			objSub.put( "pushYn", "Y" ); // 대화방의 경우 모바일 푸시 알림 전송 유무
			objSubArr.add( objSub );
			obj.put( "recvEmpList", objSubArr ); // 수신자 리스트 []							
			obj.put( "data", objData );
			HttpJsonUtil httpJsonUtil = new HttpJsonUtil( );
			httpJsonUtil.execute( "POST", BizboxAProperties.getProperty( "BizboxA.event.url" ) + "/event/EventSend", obj );
		}
		ModelAndView mv = new ModelAndView( );
		mv.addObject( "ret", "succ" );
		mv.setViewName( "jsonView" );
		return mv;
	}

	@RequestMapping ( "/systemx/updateCertificateForm.do" )
	public ModelAndView updateCertificateForm ( @RequestParam Map<String, Object> paramMap, HttpServletRequest request ) throws Exception {
		LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser( );
		paramMap.put( "groupSeq", loginVO.getGroupSeq( ) );
		paramMap.put( "compSeq", loginVO.getCompSeq( ) );
		paramMap.put( "empSeq", loginVO.getUniqId( ) );
		APIResponse response = new APIResponse( );
		try {
			if ( "N".equals( paramMap.get( "formSeq" ) ) ) {
				paramMap.put( "formSeq", certManageService.getFormSeq( paramMap ) );
			}
			certManageService.updateCertificateForm( paramMap ); // comp_seq 로 업데이트
			certManageService.updateCertificateFormDefault( paramMap ); // comp_seq 0 번 업데이트
			response.setResultCode( "SUCCESS" );
			response.setResultMessage( BizboxAMessage.getMessage( "TX000016536", "증명서 양식이 저장되었습니다." ) );
		}
		catch ( Exception ex ) {
			CommonUtil.printStatckTrace(ex);//오류메시지를 통한 정보노출
			response.setResultCode( "FAIL" );
			response.setResultMessage( ex.getMessage( ) );
		}
		ModelAndView mv = new ModelAndView( );
		mv.addObject( "ret", response );
		mv.setViewName( "jsonView" );
		return mv;
	}

	@RequestMapping ( "/systemx/getCertificateUseYn.do" )
	public ModelAndView getCertificateUseYn ( @RequestParam Map<String, Object> paramMap, HttpServletRequest request ) throws Exception {
		LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser( );
		paramMap.put( "groupSeq", loginVO.getGroupSeq( ) );
		paramMap.put( "compSeq", loginVO.getCompSeq( ) );
		paramMap.put( "langCode", loginVO.getLangCode( ) );
		List<Map<String, Object>> list = certManageService.getCertificateUseYn( paramMap );
		ModelAndView mv = new ModelAndView( );
		mv.addObject( "certList", list );
		mv.setViewName( "jsonView" );
		return mv;
	}

	@RequestMapping ( "/systemx/setCertificateUseYn.do" )
	public ModelAndView setCertificateUseYn ( @RequestParam Map<String, Object> paramMap, HttpServletRequest request ) throws Exception {
		LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser( );
		paramMap.put( "groupSeq", loginVO.getGroupSeq( ) );
		paramMap.put( "compSeq", loginVO.getCompSeq( ) );
		paramMap.put( "empSeq", loginVO.getUniqId( ) );
		APIResponse response = new APIResponse( );
		try {
			certManageService.setCertificateUseYn( paramMap );
			response.setResultCode( "SUCCESS" );
			response.setResultMessage( "" );
		}
		catch ( Exception ex ) {
			CommonUtil.printStatckTrace(ex);//오류메시지를 통한 정보노출
			response.setResultCode( "FAIL" );
			response.setResultMessage( ex.getMessage( ) );
		}
		ModelAndView mv = new ModelAndView( );
		mv.addObject( "ret", response );
		mv.setViewName( "jsonView" );
		return mv;
	}

	@RequestMapping ( "/systemx/setCertificateAlarm.do" )
	public ModelAndView setCertificateAlarm ( @RequestParam Map<String, Object> paramMap, HttpServletRequest request ) throws Exception {
		Map<String, String> param = new HashMap<String, String>( );
		String certAlramList = (String) paramMap.get( "certAlarmList" );
		String[] certAlramTail;
		String[] certAlramTailDetail;
		LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser( );
		paramMap.put( "compSeq", loginVO.getCompSeq( ) );
		try {
			//먼저 form_seq로 삭제
			if ( certAlramList.indexOf( "," ) > -1 ) {
				certManageService.setCertificateAlarmReset( paramMap );
				certAlramTail = certAlramList.split( "," );
				for ( int i = 0; i < certAlramTail.length; i++ ) {
					certAlramTailDetail = certAlramTail[i].split( "\\|" );
					param.put( "formSeq", (String) paramMap.get( "formSeq" ) );
					param.put( "orgEmpSeq", certAlramTailDetail[1] );
					param.put( "compSeq", certAlramTailDetail[2] );
					param.put( "orgType", certAlramTailDetail[3] );
					param.put( "empSeq", loginVO.getUniqId( ) );
					certManageService.setCertificateAlarm( param );
				}
			}
			else if ( !"".equals( certAlramList ) ) {
				certManageService.setCertificateAlarmReset( paramMap );
				certAlramTailDetail = certAlramList.split( "\\|" );
				param.put( "formSeq", (String) paramMap.get( "formSeq" ) );
				param.put( "orgEmpSeq", certAlramTailDetail[1] );
				param.put( "compSeq", certAlramTailDetail[2] );
				param.put( "orgType", certAlramTailDetail[3] );
				param.put( "empSeq", loginVO.getUniqId( ) );
				certManageService.setCertificateAlarm( param );
			}
		}
		catch ( Exception e ) {
			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
		}
		ModelAndView mv = new ModelAndView( );
		//	mv.addObject("ret", response);
		mv.setViewName( "jsonView" );
		return mv;
	}

	@RequestMapping ( "/systemx/getCertificateAlarmList.do" )
	public ModelAndView getCertificateAlarmList ( @RequestParam Map<String, Object> paramMap, HttpServletRequest request ) throws Exception {
		LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser( );
		JSONObject objSub = new JSONObject( );
		String alarmTemp = "";
		String alarmList = "";
		String orgList = "";
		paramMap.put( "groupSeq", loginVO.getGroupSeq( ) );
		paramMap.put( "compSeq", loginVO.getCompSeq( ) );
		paramMap.put( "langCode", loginVO.getLangCode( ) );
		List<Map<String, Object>> list = certManageService.getCertificateAlarmList( paramMap );
		for ( Map<String, Object> map : list ) {
			alarmTemp = "";
			alarmTemp = (String) map.get( "empName" );
			if ( "".equals( alarmList ) ) {
				alarmList = alarmTemp;
			}
			else {
				alarmList += "/" + alarmTemp;
			}
			alarmTemp = "";
			alarmTemp = (String) map.get( "orgSeq" );
			orgList += alarmTemp + ",";
			objSub.put( "alarmList", alarmList );
			objSub.put( "orgList", orgList );
		}
		ModelAndView mv = new ModelAndView( );
		mv.addObject( "ret", objSub );
		mv.setViewName( "jsonView" );
		return mv;
	}
}
