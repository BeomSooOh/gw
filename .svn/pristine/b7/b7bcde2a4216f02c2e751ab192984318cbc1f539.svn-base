package neos.cmm.mp.addr.web;

import java.io.File;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.servlet.ModelAndView;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;

import api.drm.service.DrmService;
import api.poi.service.ExcelService;
import bizbox.orgchart.service.vo.LoginVO;
import cloud.CloudConnetInfo;
import egovframework.com.cmm.util.EgovUserDetailsHelper;
import egovframework.com.utl.fcc.service.EgovFileUploadUtil;
import egovframework.com.utl.fcc.service.EgovStringUtil;
import egovframework.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;
import main.web.BizboxAMessage;
import neos.cmm.db.CommonSqlDAO;
import neos.cmm.menu.service.MenuManageService;
import neos.cmm.mp.addr.service.AddrManageService;
import neos.cmm.systemx.commonOption.service.CommonOptionManageService;
import neos.cmm.systemx.group.service.GroupManageService;
import neos.cmm.util.CommonUtil;
import neos.cmm.util.NeosConstants;
import net.sf.json.JSONArray;
import restful.com.controller.AttachFileController;

@SuppressWarnings("unused")
@Controller
public class AddrManageController {
	
	@Resource(name = "AddrManageService")
	private AddrManageService addrManageService;
	
	@Resource(name = "commonSql")
	private CommonSqlDAO commonSql;
	
	@Resource(name = "GroupManageService")
	private GroupManageService groupManageService;
	
	@Resource(name="ExcelService")
	private ExcelService excelService;
	
	@Resource(name = "attachFileController")
	private AttachFileController attachFileController;

	@Resource(name = "DrmService")
	private DrmService drmService;	
	
    @Resource(name="CommonOptionManageService")
    private CommonOptionManageService commonOptionManageService;
    
    @Resource ( name = "MenuManageService" )
	private MenuManageService menuManageService;

	
	/**
	 * 전체주소록 페이지 호출
	 * @param paramMap
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/cmm/mp/addr/AddrInfoAdminView.do")
	public ModelAndView AddrInfoAdminView(@RequestParam Map<String, Object> paramMap , HttpServletRequest request) throws Exception{
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		ModelAndView mv = new ModelAndView();
		
		if(!menuManageService.checkMenuAuth(loginVO, request.getServletPath())) {
			mv.setViewName( "redirect:/forwardIndex.do" );
			return mv;
		}
		
		
		mv.addObject("authDiv", loginVO.getUserSe());
		mv.setViewName("/neos/cmm/mp/addr/AddrInfoAdmin");
		
		return mv;
	}
	
	
	
	/**
	 * 주소록 그룹등록 페이지 호출
	 * @param paramMap
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/cmm/mp/addr/AddrGroupView.do")
	public ModelAndView AddrGroupView(@RequestParam Map<String, Object> paramMap , HttpServletRequest request) throws Exception{
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		
		ModelAndView mv = new ModelAndView();
		
		if(!menuManageService.checkMenuAuth(loginVO, request.getServletPath())) {
			mv.setViewName( "redirect:/forwardIndex.do" );
			return mv;
		}
		
		mv.addObject("empSeq", loginVO.getUniqId());
		mv.addObject("compSeq", loginVO.getCompSeq());
		mv.addObject("authDiv", loginVO.getUserSe());
		
		paramMap.put("groupSeq", loginVO.getGroupSeq());
		paramMap.put("compSeq", loginVO.getCompSeq());
		paramMap.put("deptSeq", loginVO.getDept_seq());
		paramMap.put("empSeq", loginVO.getUniqId());
		paramMap.put("langCode", loginVO.getLangCode());
		
		
		Map<String,Object> list = new HashMap<String, Object>(); 
		list.put("compName", addrManageService.getCompName(paramMap));
		list.put("empName", addrManageService.getEmpName(paramMap));
		
		String optionValue = commonOptionManageService.getCommonOptionValue(loginVO.getGroupSeq(), loginVO.getCompSeq(), "com400");
		
		mv.addObject("list", list);
		mv.addObject("optionValue", optionValue);
		mv.setViewName("/neos/cmm/mp/addr/AddrGroup");
		
		return mv;
	}
	
	
	/**
	 * 주소록 그룹 리스트
	 * @param paramMap
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/cmm/mp/addr/getAddrGroupList.do")
	public ModelAndView getAddrGroupList(@RequestParam Map<String, Object> paramMap , HttpServletRequest request) throws Exception{
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		
		paramMap.put("empSeq", loginVO.getUniqId());
		paramMap.put("compSeq", loginVO.getCompSeq());
		paramMap.put("deptSeq", loginVO.getOrgnztId());
		paramMap.put("langCode", loginVO.getLangCode());
		paramMap.put("groupSeq", loginVO.getGroupSeq());
		
		if(!loginVO.getUserSe().equals("USER")) {
			paramMap.put("adminAuth", loginVO.getUserSe());
		}
		
		PaginationInfo paginationInfo = new PaginationInfo();
		
		paginationInfo.setCurrentPageNo(EgovStringUtil.zeroConvert(paramMap.get("page")));
		paginationInfo.setPageSize(EgovStringUtil.zeroConvert(paramMap.get("pageSize")));
		
		Map<String, Object> list = addrManageService.GetAddrGroupList(paramMap, paginationInfo);
		
		ModelAndView mv = new ModelAndView();
		mv.addAllObjects(list);
		mv.setViewName("jsonView");
		return mv;
	}
	
	
	/**
	 * 주소록 그룹 등록(Insert/Update)
	 * @param paramMap
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/cmm/mp/addr/InsertAddrGroupInfo.do")
	public ModelAndView InsertAddrGroupInfo(@RequestParam Map<String, Object> paramMap , HttpServletRequest request) throws Exception{
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		
		paramMap.put("empSeq", loginVO.getUniqId());
		paramMap.put("groupSeq", loginVO.getGroupSeq());
		addrManageService.InsertAddrGroupInfo(paramMap);
		
		ModelAndView mv = new ModelAndView();
		
		mv.setViewName("jsonView");
		
		return mv;
	}
	
	
	/**
	 * 주소록 그룹 삭제
	 * @param paramMap
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/cmm/mp/addr/DeleteAddrGroupInfo.do")
	public ModelAndView DeleteAddrGroupInfo(@RequestParam Map<String, Object> paramMap , HttpServletRequest request) throws Exception{
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		paramMap.put("groupSeq", loginVO.getGroupSeq());
		
		
		addrManageService.DeleteAddrGroupInfo(paramMap);
		
		ModelAndView mv = new ModelAndView();
		
		mv.setViewName("jsonView");
		
		return mv;
	}
	
	
	
	/**
	 * 주소록 그룹 삭제(다중)
	 * @param paramMap
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/cmm/mp/addr/DeleteAddrGroupListInfo.do")
	public ModelAndView DeleteAddrGroupListInfo(@RequestParam Map<String, Object> paramMap , HttpServletRequest request) throws Exception{
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		paramMap.put("groupSeq", loginVO.getGroupSeq());
		
		
		addrManageService.DeleteAddrGroupListInfo(paramMap);
		
		ModelAndView mv = new ModelAndView();
		
		mv.setViewName("jsonView");
		
		return mv;
	}
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	/**
	 * 주소록등록 페이지 호출
	 * @param paramMap
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/cmm/mp/addr/AddrInfoView.do")
	public ModelAndView AddrInfoView(@RequestParam Map<String, Object> paramMap , HttpServletRequest request) throws Exception{
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		
		ModelAndView mv = new ModelAndView();
		
		if(!menuManageService.checkMenuAuth(loginVO, request.getServletPath())) {
			mv.setViewName( "redirect:/forwardIndex.do" );
			return mv;
		}
		
		mv.addObject("empSeq", loginVO.getUniqId());
		mv.addObject("empName", loginVO.getEmpname());
		mv.addObject("compSeq", loginVO.getCompSeq());
		mv.addObject("authDiv", loginVO.getUserSe());
		mv.addObject("loginVO", loginVO);
		
		String optionValue = commonOptionManageService.getCommonOptionValue(loginVO.getGroupSeq(), loginVO.getCompSeq(), "com400");
		
		mv.addObject("optionValue", optionValue);
		mv.setViewName("/neos/cmm/mp/addr/AddrInfo");
		
		return mv;
	}




	/**
	 * 주소록 그룹리스트 조회(ddl바인딩)
	 * @param paramMap
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/cmm/mp/addr/GetGroupList.do")
	public ModelAndView GetGroupList(@RequestParam Map<String, Object> paramMap , HttpServletRequest request) throws Exception{
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		
		ModelAndView mv = new ModelAndView();
		paramMap.put("deptSeq", loginVO.getOrgnztId());
		paramMap.put("compSeq", loginVO.getCompSeq());
		paramMap.put("empSeq", loginVO.getUniqId());
		paramMap.put("langCode", loginVO.getLangCode());
		paramMap.put("groupSeq", loginVO.getGroupSeq());
		
		if(!loginVO.getUserSe().equals("USER")) {
			paramMap.put("adminAuth", loginVO.getUserSe());
		}
		
		List<Map<String,Object>> list = addrManageService.GetGroupList(paramMap);
		
		mv.addObject("list", list);
		mv.setViewName("jsonView");
		
		return mv;
	}
	
		
		
	/**
	 * 주소록 리스트 조회
	 * @param paramMap
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/cmm/mp/addr/getAddrList.do")
	public ModelAndView getAddrList(@RequestParam Map<String, Object> paramMap , HttpServletRequest request) throws Exception{
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		
		PaginationInfo paginationInfo = new PaginationInfo();
		
		paginationInfo.setCurrentPageNo(EgovStringUtil.zeroConvert(paramMap.get("page")));
		paginationInfo.setPageSize(EgovStringUtil.zeroConvert(paramMap.get("pageSize")));
		
		
		paramMap.put("empSeq", loginVO.getUniqId());
		paramMap.put("deptSeq", loginVO.getOrgnztId());
		paramMap.put("compSeq", loginVO.getCompSeq());
		
		paramMap.put("langCode", loginVO.getLangCode());
		paramMap.put("groupSeq", loginVO.getGroupSeq());
		
		if(!loginVO.getUserSe().equals("USER")) {
			paramMap.put("adminAuth", loginVO.getUserSe());
		}
		
		Map<String,Object> list = addrManageService.GetAddrList(paramMap, paginationInfo);
		
		ModelAndView mv = new ModelAndView();
		mv.addAllObjects(list);
		mv.setViewName("jsonView");
		
		return mv;
	}
	
	
		
		
	/**
	 * 주소록 저장
	 * @param paramMap
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/cmm/mp/addr/InsertAddrInfo.do")
	public ModelAndView InsertAddrInfo(@RequestParam Map<String, Object> paramMap , HttpServletRequest request) throws Exception{
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		
		paramMap.put("empSeq", loginVO.getUniqId());
		paramMap.put("groupSeq", loginVO.getGroupSeq());
		paramMap.put("compSeq", loginVO.getCompSeq());
		paramMap.put("groupSeq", loginVO.getGroupSeq());
		
		addrManageService.InsertAddrInfo(paramMap);
		
		ModelAndView mv = new ModelAndView();
		
		mv.setViewName("jsonView");
		return mv;
	}
	
	
	
	
	/**
	 * 주소록 정보 조회(단일정보)
	 * @param paramMap
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/cmm/mp/addr/GetAddrInfo.do")
	public ModelAndView GetAddrInfo(@RequestParam Map<String, Object> paramMap , HttpServletRequest request) throws Exception{
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		
		paramMap.put("empSeq", loginVO.getUniqId());
		paramMap.put("groupSeq", loginVO.getGroupSeq());
		paramMap.put("compSeq", loginVO.getCompSeq());
		paramMap.put("groupSeq", loginVO.getGroupSeq());
		
		Map<String,Object> result = addrManageService.GetAddrInfo(paramMap);
		
		ModelAndView mv = new ModelAndView();
		mv.addObject("result", result);
		
		mv.setViewName("jsonView");
		return mv;
	}
	
	
	
	
	/**
	 * 주소록 정보 삭제(단일정보)
	 * @param paramMap
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/cmm/mp/addr/DeleteAddrInfo.do")
	public ModelAndView DeleteAddrInfo(@RequestParam Map<String, Object> paramMap , HttpServletRequest request) throws Exception{
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		
		paramMap.put("groupSeq", loginVO.getGroupSeq());

		addrManageService.DeleteAddrInfo(paramMap);
		
		ModelAndView mv = new ModelAndView();
		
		mv.setViewName("jsonView");
		return mv;
	}
	
	
	/**
	 * 주소록 정보 삭제(멀티정보)
	 * @param paramMap
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/cmm/mp/addr/DeleteAddrListInfo.do")
	public ModelAndView DeleteAddrListInfo(@RequestParam Map<String, Object> paramMap , HttpServletRequest request) throws Exception{
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		
		paramMap.put("groupSeq", loginVO.getGroupSeq());

		addrManageService.DeleteAddrListInfo(paramMap);
		
		ModelAndView mv = new ModelAndView();
		
		mv.setViewName("jsonView");
		return mv;
	}
	
	
	/**
	 * 주소록 그룹 공개범위 정보 조회
	 * @param paramMap
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/cmm/mp/addr/getAddrPublic.do")
	public ModelAndView getAddrPublic(@RequestParam Map<String, Object> paramMap , HttpServletRequest request) throws Exception{
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();

		paramMap.put("groupSeq", loginVO.getGroupSeq());
		paramMap.put("langCode", loginVO.getLangCode());
		
		List<Map<String,Object>> list = addrManageService.GetAddrPublic(paramMap);
		
		ModelAndView mv = new ModelAndView();
		mv.addObject("list",list);
		mv.setViewName("jsonView");
		return mv;
	}
	
	
	/**
	 * 거래처 선택 팝업
	 * @param paramMap
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/cmm/mp/addr/fnPartnerPop.do")
	public ModelAndView fnPartnerPop(@RequestParam Map<String, Object> paramMap , HttpServletRequest request) throws Exception{
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();

		ModelAndView mv = new ModelAndView();
		mv.setViewName("/neos/cmm/mp/addr/pop/partnerInfoPop");
		return mv;
	}
	
	
	@RequestMapping("/cmm/mp/addr/fnAddrGroupPop.do")
	public ModelAndView fnAddrGroupPop(@RequestParam Map<String, Object> paramMap , HttpServletRequest request) throws Exception{
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		
		ModelAndView mv = new ModelAndView();
		paramMap.put("deptSeq", loginVO.getOrgnztId());
		paramMap.put("compSeq", loginVO.getCompSeq());
		paramMap.put("empSeq", loginVO.getUniqId());
		paramMap.put("langCode", loginVO.getLangCode());
		paramMap.put("groupSeq", loginVO.getGroupSeq());
		
		paramMap.put("adminAuth", loginVO.getUserSe());
		
		List<Map<String,Object>> list = addrManageService.GetGroupList(paramMap);
		
		mv.addObject("groupDiv", paramMap.get("groupDiv"));
		mv.addObject("list", list);
		mv.setViewName("/neos/cmm/mp/addr/pop/addrGroupPop");
		return mv;
	}
	

	@RequestMapping("/cmm/mp/addr/serchAddrGroupInfo.do")
	public ModelAndView serchAddrGroupInfo(@RequestParam Map<String, Object> paramMap , HttpServletRequest request) throws Exception{
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		
		ModelAndView mv = new ModelAndView();
		paramMap.put("deptSeq", loginVO.getOrgnztId());
		paramMap.put("compSeq", loginVO.getCompSeq());
		paramMap.put("empSeq", loginVO.getUniqId());
		paramMap.put("langCode", loginVO.getLangCode());
		paramMap.put("groupSeq", loginVO.getGroupSeq());
		
		paramMap.put("adminAuth", loginVO.getUserSe());
		
		List<Map<String,Object>> list = addrManageService.GetGroupList(paramMap);
		
		mv.addObject("list", list);
		mv.setViewName("jsonView");
		return mv;
	}
	
	/**
	 * 거래처 리스트 조회
	 * @param paramMap
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/cmm/mp/addr/getPartnerList.do")
	public ModelAndView getPartnerList(@RequestParam Map<String, Object> paramMap , HttpServletRequest request) throws Exception{
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		ModelAndView mv = new ModelAndView();
		
		paramMap.put("compSeq", loginVO.getCompSeq());
		paramMap.put("groupSeq", loginVO.getGroupSeq());
		paramMap.put("langCode", loginVO.getLangCode());
		
		List<Map<String,Object>> list = addrManageService.getPartnerList(paramMap);
		
		mv.addObject("list", list);
		
		mv.setViewName("jsonView");
		return mv;
	}
	
	
	
	
	/**
	 * 내보내기버튼(액셀다운로드)
	 * @param paramMap
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/cmm/mp/addr/AddrInfoExcelExport.do")
	public ModelAndView AddrInfoExcelExport(@RequestParam Map<String, Object> paramMap , HttpServletRequest request, HttpServletRequest servletRequest, HttpServletResponse response) throws Exception{
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();		

		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		
		paramMap.put("empSeq", loginVO.getUniqId());
		paramMap.put("deptSeq", loginVO.getOrgnztId());
		paramMap.put("compSeq", loginVO.getCompSeq());
		paramMap.put("groupSeq", loginVO.getGroupSeq());
		
		paramMap.put("langCode", loginVO.getLangCode());
		
		if(!loginVO.getUserSe().equals("USER")) {
			paramMap.put("adminAuth", loginVO.getUserSe());
		}
		
		@SuppressWarnings("unchecked")
		List<Map<String,Object>> list = commonSql.list("AddrManageService.AddrListExcelExport", paramMap);
		mv.addObject("list", list);
		
		return mv;
		
	}
	
	
	/**
	 * 내보내기버튼(액셀다운로드)
	 * @param paramMap
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/cmm/mp/addr/AddrEmergencyContactExport.do")
	public void AddrEmergencyContactExport(@RequestParam Map<String, Object> paramMap , HttpServletRequest request, HttpServletRequest servletRequest, HttpServletResponse response) throws Exception{
LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		
		paramMap.put("langCode", loginVO.getLangCode());
		

		String compSeq = paramMap.get("compSeq")+"";
		String groupSeq = paramMap.get("groupSeq")+"";
		
		if (EgovStringUtil.isEmpty(compSeq)) {
				 paramMap.put("compSeq", loginVO.getCompSeq());
		}
		paramMap.put("groupSeq", loginVO.getGroupSeq());
		
		/** 그룹 정보 가져오기. 그룹명 가져오기 위해 */
		Map<String, Object> groupMap = addrManageService.getGroupInfo(paramMap);
		
		ModelAndView mv = new ModelAndView();
		mv.addObject("groupMap", groupMap);
		
		PaginationInfo paginationInfo = new PaginationInfo();
		String noPage = paramMap.get("isNoPage")+"";
		
		if (!noPage.equals("true")) {
			paginationInfo.setCurrentPageNo(EgovStringUtil.zeroConvert(paramMap.get("page")));
			paginationInfo.setPageSize(EgovStringUtil.zeroConvert(paramMap.get("pageSize")));
		}
		
		paramMap.put("orderBy", "tcem.emp_name"); //사원 이름순으로 기본 정렬.
		
		//검색 분류 및 검색 기능
		if(paramMap.get("searchSelect") !=null) {
			String selectBox = paramMap.get("searchSelect").toString();
			
			if(selectBox.equals("empNmSearch")) {
				paramMap.put("nameAndLoginId", paramMap.get("searchContent"));
			} else if(selectBox.equals("deptNmSearch")) {
				paramMap.put("deptName", paramMap.get("searchContent"));
			} else if(selectBox.equals("positionNmSearch")) {
				paramMap.put("positionName", paramMap.get("searchContent"));
			} else if(selectBox.equals("dutyNmSearch")) {
				paramMap.put("dutyName", paramMap.get("searchContent"));
			} else if(selectBox.equals("telNoSearch")) {
				paramMap.put("telNum", paramMap.get("searchContent"));
			} else if(selectBox.equals("mobileSearch")) {
				paramMap.put("mobileTelNum", paramMap.get("searchContent"));
			}
		}
		
		
		String[] arrCol = new String[13];
		arrCol[0] = BizboxAMessage.getMessage("TX000018385","회사명");
		arrCol[1] = BizboxAMessage.getMessage("TX000000068","부서명");
		arrCol[2] = BizboxAMessage.getMessage("TX000018672","직급");
		arrCol[3] = BizboxAMessage.getMessage("TX000000105","직책");
		arrCol[4] = BizboxAMessage.getMessage("TX000000277","이름");
		arrCol[5] = BizboxAMessage.getMessage("TX000000075","ID");
		arrCol[6] = BizboxAMessage.getMessage("TX000000262","메일");
		arrCol[7] = BizboxAMessage.getMessage("TX000001672","생일");
		arrCol[8] = BizboxAMessage.getMessage("TX000002886","전화(회사)");
		arrCol[9] = BizboxAMessage.getMessage("TX000002887","전화(집)");
		arrCol[10] = BizboxAMessage.getMessage("TX000001047","휴대폰");
		arrCol[11] = BizboxAMessage.getMessage("TX000000385","사원번호");
		arrCol[12] = BizboxAMessage.getMessage("TX000000375","주소");
		
		SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");
        Calendar c1 = Calendar.getInstance();
        String strToday = sdf.format(c1.getTime());

		String fileNm = "BizBoxAlpha_" + "EmergencyContact_" + strToday;	
		
		paramMap.put("empSeq", loginVO.getUniqId());
		
		@SuppressWarnings("unchecked")
		List<Map<String,Object>> list = commonSql.list("AddrManageService.selectContactInfoForExcel", paramMap);
		
		excelService.CmmExcelDownload(list, arrCol, fileNm, response, servletRequest);
		
	}
	
	/**
	 * 주소록 엑셀업로드 팡업
	 * @param paramMap
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/cmm/mp/addr/addrRegBatchPop.do")
	public ModelAndView addrRegBatchPop(@RequestParam Map<String, Object> paramMap , HttpServletRequest request) throws Exception{
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		
		ModelAndView mv = new ModelAndView();

		mv.setViewName("/neos/cmm/mp/addr/pop/addrRegBatchPop");
		
		return mv;
	}
	
	
	
	
	
	/**
	 * 주소록 엑셀업로드 업로드 팝업창(업로드버튼)
	 * @param paramMap
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/cmm/mp/addr/addrExcelValidate.do")
	public ModelAndView addrExcelValidate(@RequestParam Map<String, Object> paramMap , HttpServletRequest request) throws Exception{
		 ModelAndView mv = new ModelAndView();
			
		  //logger.info("CONTROLLER BEGIN METHOD :: " + new Object(){}.getClass().getEnclosingMethod().getName());
		  LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();	
		
		  
		  Map<String,Object> resultMap = new HashMap<String, Object>();
	
		  // SET LOCAL VALUE
		  List<Map<String,Object>> excelContentList = null; 	  
	
		  try {
			  String osType = NeosConstants.SERVER_OS;
			  
			  Map<String, Object> param = new HashMap<String, Object>();
			  param.put("groupSeq", loginVO.getGroupSeq());
			  param.put("pathSeq", "0");
			  param.put("osType", osType);
			  
			  Map<String, Object> pathMap = groupManageService.selectGroupPath(param);
			  
			  String savePath = "";
			  
			  if(pathMap.size() == 0) {
				  savePath = File.separator;
			  }
			  else {
				  savePath = pathMap.get("absolPath") + "/exceltemp/";
			  }
			  
			  File dir = new File(savePath);
			  
			  if(!dir.exists()){
			         dir.mkdir();
	  		  }
	
			  MultipartHttpServletRequest multipartRequest = (MultipartHttpServletRequest)request;
			  MultipartFile mFile = multipartRequest.getFile("excelUploadFile"); // NAME IN JSP FORM
	
			  if (mFile != null && mFile.getSize() > 0) {
				  String saveFileName  = mFile.getOriginalFilename();
	
				  long fileSize   = mFile.getSize();
	
				  if (fileSize > 0 && !saveFileName.equals("")) {
					 saveFileName = savePath + saveFileName;					 
					 
					 EgovFileUploadUtil.saveFile(mFile.getInputStream(), new File(saveFileName));
					 
					 
					 int index = mFile.getOriginalFilename().lastIndexOf(".");
						
					 String fileExt = mFile.getOriginalFilename().substring(index + 1);
					 String newName = mFile.getOriginalFilename().substring(0, index);				
						
					 //DRM 체크
					 drmService.drmConvert("U", "", "E", savePath, newName, fileExt);					 
					 
				     excelContentList = excelService.procAddrExcelTemp(saveFileName);
				     
				     File path = new File(savePath);
			   			File[] fileList = path.listFiles();
			   			
			   			for(File file: fileList){
			   				if(file.getName().equals(mFile.getOriginalFilename())){
			   					file.delete();
			   				}
			   			}
				     
				  }
				  
				  if (excelContentList != null && excelContentList.size() > 7) {
					  Calendar cal = Calendar.getInstance();
					  SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMddHHmmss");
					  String ts = sdf.format(cal.getTime());			  
					  
					  List<Map<String,Object>> addrList = excelContentList.subList(8, excelContentList.size());
					  
					  param.put("empSeq", loginVO.getUniqId());
					  param.put("langCode", "kr");
					  String empName = addrManageService.getEmpName(param);
					  
					  
					  
					  
					  //엑셀데이터 check_group_tp, batch_group_tp 셋팅
					  @SuppressWarnings("unchecked")
					  List<Map<String, Object>> addrGrouopTarget = commonSql.list("AddrManageService.GetAddrGrouopTarget", param);
					  for(Map<String, Object> tmp : addrList) {
						  if(tmp.get("C0") != null && tmp.get("C0").toString().equals("회사")) {
							  tmp.put("batchGroupTp", "10");
						  }else if(tmp.get("C0") != null && tmp.get("C0").toString().equals("공용")) {
							  tmp.put("batchGroupTp", "20");
						  }else if(tmp.get("C0") != null && tmp.get("C0").toString().equals("개인")) {
							  tmp.put("batchGroupTp", "30");
						  }else if(tmp.get("C0") != null && tmp.get("C0").toString().equals("개인")) {
							  tmp.put("batchGroupTp", "");
						  }
						  
						  for(Map<String, Object> target : addrGrouopTarget) {
							  if((tmp.get("C1").toString() + tmp.get("batchGroupTp").toString()).equals(target.get("target"))) {
								  tmp.put("checkGroupTp", target.get("addrGroupTp"));
							  }
						  }
					  }
					  
					  
					  for(int i=0;i<=(int)(addrList.size() / 500); i++) {
						  int lastIdx = 0;
						  lastIdx = ((i * 500) + 500) > addrList.size() ? addrList.size() : ((i * 500) + 500);
						  List<Map<String,Object>> addrListTmp = addrList.subList(i*500, lastIdx);
						  
						  Map<String,Object> map = new HashMap<String, Object>();
						  map.put("addrList", addrListTmp);
						  map.put("batchSeq", ts);
						  map.put("empName", empName);
						  map.put("createSeq", loginVO.getUniqId());
						  map.put("groupSeq", loginVO.getGroupSeq());
						  
						  commonSql.insert("AddrManageService.insertAddrBatch", map);

						  resultMap.put("retMsg", "success");
						  resultMap.put("retKey", ts);
					  }
					  
				  }
				  else {
					  resultMap.put("retMsg", "fail");
					  resultMap.put("retKey", "0");
				  }
			  }
			  
		  } catch (Exception ex) {
			  CommonUtil.printStatckTrace(ex);//오류메시지를 통한 정보노출
			  resultMap.put("retMsg", "fail");
		  }
	
		  //logger.info("CONTROLLER END METHOD :: " + new Object(){}.getClass().getEnclosingMethod().getName());

		  mv.addAllObjects(resultMap);
		  mv.setViewName("jsonView");
		  return mv;
	}
	
	
	
	@RequestMapping("/cmm/mp/addr/getAddrBatchInfo.do")
	public ModelAndView getAddrBatchInfo(@RequestParam Map<String, Object> paramMap , HttpServletRequest request) throws Exception{
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		paramMap.put("groupSeq", loginVO.getGroupSeq());

		ModelAndView mv = new ModelAndView();
		paramMap.put("compSeq", loginVO.getCompSeq());
		paramMap.put("empSeq", loginVO.getUniqId());
		paramMap.put("deptSeq", loginVO.getOrgnztId());
		paramMap.put("langCode", loginVO.getLangCode()); /* 다국어용 langCode 추가 */
		paramMap.put("groupSeq", loginVO.getGroupSeq());
		@SuppressWarnings("unchecked")
		List<Map<String, Object>> list = commonSql.list("AddrManageService.getAddrBatchInfo", paramMap); 
		
		mv.addObject("addrBatchList", list);
		mv.setViewName("jsonView");
		return mv;
	}
	
	
	
	@RequestMapping("/cmm/mp/addr/deleteAddrBatchInfo.do")
	public ModelAndView deleteAddrBatchInfo(@RequestParam Map<String, Object> paramMap , HttpServletRequest request) throws Exception{
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		ModelAndView mv = new ModelAndView();
		paramMap.put("groupSeq", loginVO.getGroupSeq());
		commonSql.delete("AddrManageService.deleteAddrBatchInfo", paramMap);
		
		mv.setViewName("jsonView");		
		
		return mv;
	}
	
	
	
	@RequestMapping("/cmm/mp/addr/saveAddrBatch.do")
	public ModelAndView saveAddrBatch(@RequestParam Map<String, Object> paramMap , HttpServletRequest request) throws Exception{
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		ModelAndView mv = new ModelAndView();
		
		String jsonStr = (String)paramMap.get("saveList");
		ObjectMapper mapper = new ObjectMapper();
		List<Map<String, Object>> saveList = mapper.readValue(jsonStr, new TypeReference<List<Map<String, Object>>>(){});
		
		String retKey = (String) paramMap.get("retKey");
		
		paramMap.put("saveList", saveList);
		paramMap.put("retKey", retKey);
		paramMap.put("compSeq", loginVO.getCompSeq());
		paramMap.put("groupSeq", loginVO.getGroupSeq());
		paramMap.put("empSeq", loginVO.getUniqId());
		paramMap.put("langCode", loginVO.getLangCode());
		commonSql.insert("AddrManageService.saveAddrBatch", paramMap);
		
		mv.setViewName("jsonView");		
		
		return mv;
	}
	
	/**
	 * 주소록 비상연락망
	 * @param paramMap
	 * @param request
	 * @return
	 * @throws Exception
	 */
	//회사선택 창 보기
	@RequestMapping("/cmm/mp/addr/AddrEmergencyContact.do")
	public ModelAndView emergencyContactView(@RequestParam Map<String, Object> paramMap, HttpServletRequest reqest) throws Exception {
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
//		로그인 된 사람의 회사 정보 가져오기
		paramMap.put("groupSeq", loginVO.getGroupSeq());
		
		
//		회사선택 창을 위해 그룹 정보 가져오기
		Map<String, Object> groupMap = addrManageService.getGroupInfo(paramMap);
		
		ModelAndView mv = new ModelAndView();
		
		mv.addObject("groupMap", groupMap);
		
		String compSeq = paramMap.get("compSeq")+"";
		String groupSeq = paramMap.get("groupSeq")+"";
		paramMap.put("langCode", loginVO.getLangCode());
		
		if(EgovStringUtil.isEmpty(compSeq)) {
			paramMap.put("compSeq", loginVO.getCompSeq());
		}
		if (EgovStringUtil.isEmpty(groupSeq)) {
			paramMap.put("groupSeq", loginVO.getGroupSeq());
		}
		String userSe = loginVO.getUserSe();
		List<Map<String, Object>> companyList = null;
		if(userSe !=null) {
			paramMap.put("groupSeq", loginVO.getGroupSeq());
			paramMap.put("langCode", loginVO.getLangCode());
			paramMap.put("empSeq", loginVO.getUniqId());
			paramMap.put("userSe", userSe);
			
			companyList = addrManageService.getCompanyNames(paramMap);
		}
	
		JSONArray json = JSONArray.fromObject(companyList);
		mv.addObject("companyListJson", json);
		
		mv.setViewName("/neos/cmm/mp/addr/AddrEmergencyContact");
		
		return mv;
	}
	
	// 선택된 비상연락망 사원 리스트 
	@RequestMapping("/cmm/mp/addr/AddrEmergencyContactList.do")
	public ModelAndView emergencyContatctList(@RequestParam Map<String, Object> paramMap, HttpServletRequest request) throws Exception {
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		
		paramMap.put("langCode", loginVO.getLangCode());
		

		String compSeq = paramMap.get("compSeq")+"";
		String groupSeq = paramMap.get("groupSeq")+"";		
		
		paramMap.put("groupSeq", loginVO.getGroupSeq());
		
		/** 그룹 정보 가져오기. 그룹명 가져오기 위해 */
		Map<String, Object> groupMap = addrManageService.getGroupInfo(paramMap);
		
		ModelAndView mv = new ModelAndView();
		mv.addObject("groupMap", groupMap);
		
		PaginationInfo paginationInfo = new PaginationInfo();
		String noPage = paramMap.get("isNoPage")+"";
		
		if (!noPage.equals("true")) {
			paginationInfo.setCurrentPageNo(EgovStringUtil.zeroConvert(paramMap.get("page")));
			paginationInfo.setPageSize(EgovStringUtil.zeroConvert(paramMap.get("pageSize")));
		}
		
		paramMap.put("orderBy", "tcem.emp_name"); //사원 이름순으로 기본 정렬.
		
		//검색 분류 및 검색 기능
		if(paramMap.get("searchSelect") !=null) {
			String selectBox = paramMap.get("searchSelect").toString();
			
			if(selectBox.equals("empNmSearch")) {
				paramMap.put("nameAndLoginId", paramMap.get("searchContent"));
			} else if(selectBox.equals("deptNmSearch")) {
				paramMap.put("deptName", paramMap.get("searchContent"));
			} else if(selectBox.equals("positionNmSearch")) {
				paramMap.put("positionName", paramMap.get("searchContent"));
			} else if(selectBox.equals("dutyNmSearch")) {
				paramMap.put("dutyName", paramMap.get("searchContent"));
			} else if(selectBox.equals("telNoSearch")) {
				paramMap.put("telNum", paramMap.get("searchContent"));
			} else if(selectBox.equals("mobileSearch")) {
				paramMap.put("mobileTelNum", paramMap.get("searchContent"));
			}
		}
		paramMap.put("empSeq", loginVO.getUniqId());
		Map<String,Object> listMap = addrManageService.selectContactInfo(paramMap, paginationInfo);
		
		mv.addAllObjects(listMap);
		mv.setViewName("jsonView");
		
		return mv;
	}
	
	// 비상연락망 팝업창
	@RequestMapping("/cmm/mp/addr/addrEmergencyContactPop.do")
	public ModelAndView AddrEmergencyContactPop(@RequestParam String compSeq, @RequestParam String groupSeq,
												@RequestParam String langCode, @RequestParam String empSeq,
												HttpServletRequest request,	HttpServletResponse response)throws Exception{
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		ModelAndView mv = new ModelAndView();
		Map<String, Object> paramMap = new HashMap<String, Object>();
		
		paramMap.put("compSeq", compSeq);
		paramMap.put("groupSeq", groupSeq);
		paramMap.put("langCode", langCode);
		paramMap.put("empSeq", empSeq);
		
		Map<String, Object> listMap = addrManageService.selectSpecificContactInfo(paramMap);
		mv.addObject("listMap", listMap);
		
		if(CloudConnetInfo.getBuildType().equals("cloud")){
			mv.addObject("profilePath", "/upload/" + loginVO.getGroupSeq() + "/img/profile/" + loginVO.getGroupSeq());
		}else{
			mv.addObject("profilePath", "/upload/img/profile/" + loginVO.getGroupSeq());
		}		
		
		mv.setViewName("/neos/cmm/mp/addr/pop/addrEmergencyContactPop");
		return mv;
	}
	
	
}