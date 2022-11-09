package neos.cmm.systemx.comp.web;

import java.sql.Connection;
import java.sql.DriverManager;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.ServletContext;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.ibatis.session.SqlSessionFactory;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.context.ApplicationContext;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.context.support.WebApplicationContextUtils;
import org.springframework.web.servlet.ModelAndView;

import api.msg.service.MsgService;
import bizbox.orgchart.service.vo.CompMultiVO;
import bizbox.orgchart.service.vo.CompVO;
import bizbox.orgchart.service.vo.LoginVO;
import egovframework.com.cmm.EgovMessageSource;
import egovframework.com.cmm.annotation.IncludedInfo;
import egovframework.com.cmm.util.EgovUserDetailsHelper;
import egovframework.com.uat.uia.service.EgovLoginService;
import egovframework.com.utl.fcc.service.EgovStringUtil;
import egovframework.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;
import neos.cmm.db.CommonSqlDAO;
import neos.cmm.menu.service.MenuManageService;
import neos.cmm.systemx.comp.dao.ExCodeOrgERPiUDAO;
import neos.cmm.systemx.comp.service.CompManageService;
import neos.cmm.systemx.comp.service.ExCodeOrgService;
import neos.cmm.systemx.dept.service.DeptManageService;
import neos.cmm.systemx.group.service.GroupManageService;
import neos.cmm.systemx.img.service.FileUploadService;
import neos.cmm.systemx.orgAdapter.service.OrgAdapterService;
import neos.cmm.systemx.orgchart.OrgChartSupport;
import neos.cmm.systemx.orgchart.OrgChartTree;
import neos.cmm.systemx.orgchart.service.OrgChartService;
import neos.cmm.util.AESCipher;
import neos.cmm.util.BizboxAProperties;
import neos.cmm.util.CommonUtil;
import neos.cmm.util.HttpJsonUtil;
import neos.cmm.util.code.service.SequenceService;
import neos.cmm.vo.ConnectionVO;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;
import net.sf.json.JSONSerializer;

@Controller
public class CompManageController {
	
	@Resource(name = "ExCodeOrgERPiUDAO")
	private ExCodeOrgERPiUDAO exCodeOrgERPiUDAO;		
	
	@Resource(name = "OrgAdapterService")
	private OrgAdapterService orgAdapterService;	
	
	@Resource(name = "CompManageService")
	private CompManageService compService;
	
	@Resource(name = "OrgChartService")
	private OrgChartService orgChartService;
	
	@Resource(name = "FileUploadService")
	private FileUploadService fileUploadService;
	
	/** EgovMessageSource */
	@Resource(name="egovMessageSource")
	EgovMessageSource egovMessageSource;
	
	@Resource(name="MsgService")
	private MsgService msgService;
    
    @Resource(name="SequenceService")
    private SequenceService sequenceService;
    
    @Resource(name = "DeptManageService")
	private DeptManageService deptManageService;
    
    @Resource(name = "GroupManageService")
	private GroupManageService groupManageService;
    
    @Resource(name="loginService")
	EgovLoginService loginService;
    
    @Resource(name="MenuManageService")
	private MenuManageService menuManageService;
    
    @Resource(name = "commonSql")
	private CommonSqlDAO commonSql;
	
    private ConnectionVO		conVo				= new ConnectionVO();
    @SuppressWarnings("unused")
	private SqlSessionFactory sqlSessionFactory;
    
    /* 변수정의 로그 */
	private Logger LOG = LogManager.getLogger(this.getClass());
	/**
	 * 회사정보관리 메인
	 * @param paramMap
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@IncludedInfo(name="회사정보관리", order = 110 ,gid = 60)
	@RequestMapping("/cmm/systemx/compManageView.do")
	public ModelAndView compManageView(@RequestParam Map<String,Object> paramMap, HttpServletResponse response) throws Exception {
		
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		ModelAndView mv = new ModelAndView();
		
		
		boolean isAuthMenu = menuManageService.checkIsAuthMenu(paramMap, loginVO);
		if(!isAuthMenu){
			mv.setViewName("redirect:/forwardIndex.do");			
			return mv;
		}
	
		response.setCharacterEncoding("UTF-8");
		
		paramMap.put("groupSeq", loginVO.getGroupSeq());
		
		/** 그룹 정보 가져오기. 그룹명 가져오기 위해 */
		String gwDomain = BizboxAProperties.getProperty("BizboxA.groupware.domin");
		gwDomain = gwDomain.trim(); //앞뒤 공백제거
        if(gwDomain.indexOf("http://") != -1) {
        	gwDomain = gwDomain.replace("http://", "");
        }
		if(gwDomain.indexOf("https://") != -1) {
			gwDomain = gwDomain.replace("https://", "");
		}
		
		Map<String,Object> groupMap = orgChartService.getGroupInfo(paramMap);
		
		groupMap.put("groupDomain", gwDomain);
		
		mv.addObject("groupMap", groupMap);
		mv.addObject("loginVO", loginVO);
		
		paramMap.put("langCode", loginVO.getLangCode());
		 
		paramMap.put("gbnOrgList", "'c'");

		paramMap.put("groupSeq", loginVO.getGroupSeq());
	    paramMap.put("groupName", groupMap.get("groupName"));
	    
	    if(!loginVO.getUserSe().equals("MASTER")){
			 String compSeq = paramMap.get("compSeq")+"";
			 if (EgovStringUtil.isEmpty(compSeq)) {
				 compSeq = loginVO.getCompSeq();
			 }
			 paramMap.put("compSeq", compSeq);
		 }
	    
	    //폐쇄망 사용유무 커스텀 프로퍼티에서 조회.
		//폐쇄망일 경우 우편번호검색(다음api) 사용불가.
		if(!BizboxAProperties.getCustomProperty("BizboxA.ClosedNetworkYn").equals("99")){
			if(BizboxAProperties.getCustomProperty("BizboxA.ClosedNetworkYn").equals("Y")){
				mv.addObject("ClosedNetworkYn", "Y");
			}
		}
	    
		
	    /* 조직도 조회 */
		List<Map<String,Object>> list = orgChartService.selectCompBizDeptListAdmin(paramMap);
		
		mv.addObject("compList", list);
	    
		mv.setViewName("/neos/cmm/systemx/comp/compManageView");
		
		return mv;
	}
	
	/**
	 * 회사 리스트
	 * @param paramMap
	 * @param response
	 * @throws Exception
	 */
	@RequestMapping("/cmm/systemx/compList.do")
	public void compList(@RequestParam Map<String,Object> params, HttpServletRequest request, HttpServletResponse response) throws Exception {
		
		 response.setCharacterEncoding("UTF-8");
		
		 LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		
		 params.put("langCode", loginVO.getLangCode());
		 
		 params.put("gbnOrgList", "'c'");

		 params.put("groupSeq", loginVO.getGroupSeq());
		 Map<String,Object> groupMap = orgChartService.getGroupInfo(params);
		 params.put("groupName", groupMap.get("groupName"));

		 
		 if(!loginVO.getUserSe().equals("MASTER")){
			 String compSeq = params.get("compSeq")+"";
			 if (EgovStringUtil.isEmpty(compSeq)) {
				 compSeq = loginVO.getCompSeq();
			 }
			 params.put("compSeq", compSeq);
		 }
		 
		 /* 조직도 조회 */
		 List<Map<String,Object>> list = orgChartService.selectCompBizDeptListAdmin(params);

		 /** 트리 구조로 변환 */
		 OrgChartTree tree = orgChartService.getOrgChartTree(list, params);
//		 JSONObject json = JSONObject.fromObject(tree.getRoot());
//		 mv.addObject("orgChartList", json);
		  
		 /** 회사 정보 가져오기 */
//		 list = compService.getCompList(paramMap);
		 
		 JSONArray jarr = JSONArray.fromObject(tree.getRoot());
		//크로스사이트 스크립트 (XSS)
		 String callback = EgovStringUtil.isNullToString(params.get("callback"));
			
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
	
	/**
	 * 회사정보
	 * @param paramMap
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/cmm/systemx/comInfo.do")
	public ModelAndView comInfo(@RequestParam Map<String,Object> paramMap, HttpServletResponse response) throws Exception {

		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();

		ModelAndView mv = new ModelAndView();
		
		paramMap.put("groupSeq", loginVO.getGroupSeq());
		paramMap.put("langCode", loginVO.getLangCode());		
		
		/** 회사 정보 가져오기 */
		Map<String,Object> compMap = compService.getCompAdmin(paramMap);
		
		/** 회사 다국어 정보 가져오기 */
		List<Map<String,Object>> langList = orgChartService.getGroupLangList(paramMap);
		JSONArray json = JSONArray.fromObject(langList);
		mv.addObject("langList", json);		
		
		String gwDomain = BizboxAProperties.getProperty("BizboxA.groupware.domin");
		gwDomain = gwDomain.trim(); //문자 앞뒤 공백제거 추가
        if(gwDomain.indexOf("http://") != -1) {
        	gwDomain = gwDomain.replace("http://", "");
        }
		if(gwDomain.indexOf("https://") != -1) {
			gwDomain = gwDomain.replace("https://", "");
		}
		if(gwDomain.indexOf(":") != -1) {
			gwDomain = gwDomain.substring(0, gwDomain.indexOf(":"));
		}

		mv.addObject("eaType", loginVO.getEaType());
		if (compMap != null) {
			compMap.put("compDomain", compMap.get("compDomain").toString().trim()); //문자 앞뒤 공백제거 추가
			compMap.put("groupDomain", gwDomain);
			mv.addObject("compMap", compMap);			
			
			String lang = String.valueOf(compMap.get("nativeLangCode"));
			if (EgovStringUtil.isEmpty(lang)) {
				compMap.put("nativeLangCode", loginVO.getLangCode());
			}
			
			
			/** 회사 다국어 정보 가져오기 */
			Map<String,Object> compMultiMap = compService.getCompMultiLang(paramMap);
			mv.addObject("compMultiMap", compMultiMap);
			
			paramMap.put("orgSeq", paramMap.get("compSeq"));
			
			/** 회사 관련 이미지 가져오기 */
			List<Map<String,Object>> imgList = fileUploadService.getOrgImg(paramMap);
			
			if (imgList != null) {
				Map<String,Object> imgMap = new HashMap<String,Object>();
				for(Map map : imgList) {
					String key = String.valueOf(map.get("imgType")); 
					imgMap.put(key, map);
				}
				mv.addObject("imgMap", imgMap);
			}
			
			/** 인감정보 발신명의 displayText 가져오기 */
			paramMap.put("imgType", "TEXT_COMP_STAMP4");		
			Map<String,Object> txtMap = groupManageService.getOrgDisplayText(paramMap);
			mv.addObject("txtMap", txtMap);
		}
		
		//폐쇄망 사용유무 커스텀 프로퍼티에서 조회.
		//폐쇄망일 경우 우편번호검색(다음api) 사용불가.
		if(!BizboxAProperties.getCustomProperty("BizboxA.ClosedNetworkYn").equals("99")){
			if(BizboxAProperties.getCustomProperty("BizboxA.ClosedNetworkYn").equals("Y")){
				mv.addObject("ClosedNetworkYn", "Y");
			}
		}
		
		mv.setViewName("/neos/cmm/systemx/comp/include/compInfo");

		return mv;
	}
	
	/**
	 * 회사기본정보 저장
	 * @param paramMap
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/cmm/systemx/compInfoSaveProc.do")
	public ModelAndView compInfoSaveProc(@RequestParam Map<String,Object> paramMap, HttpServletResponse response, HttpServletRequest request) throws Exception {

		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		paramMap.put("groupSeq", loginVO.getGroupSeq());
		paramMap.put("createSeq", loginVO.getUniqId());
		paramMap.put("eaType", loginVO.getEaType());
		
		if (paramMap.get("compDomain").equals("") || paramMap.get("compDomain") == "") {
		    paramMap.put("compDomain", request.getServerName() + (request.getServerPort() == 80 ? "" : ":" + request.getServerPort()));
		}
		
		boolean isNew = paramMap.get("compSeq") == null || paramMap.get("compSeq").toString().equals("");
		
		//조직도 공통어뎁터 호출
		try {
			
			mv.addAllObjects(orgAdapterService.compSaveAdapter(paramMap));
			
		}catch(Exception ex) {
			
			mv.addObject("resultCode","fail");
			mv.addObject("result",ex.getMessage());
			return mv;
			
		}
		
		if(isNew){
			//전자결재 옵션 rebuild API
			try {
				String url = "";
				String jsonParam = "{}";
				String apiUrl = CommonUtil.getApiCallDomain(request) + "/" + paramMap.get( "eaType" ) + "/cmm/system/OptionReBuild.do?groupSeq=" + loginVO.getGroupSeq();
				JSONObject jsonObject2 = JSONObject.fromObject( JSONSerializer.toJSON( jsonParam ) );
				HttpJsonUtil httpJson = new HttpJsonUtil( );
				httpJson.execute( "POST", apiUrl, jsonObject2 );
			}
			catch ( Exception e ) {
				CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
			}
		}
		
		return mv;
	}
	
	
	@RequestMapping("/cmm/systemx/compRemoveImage.do")
	public ModelAndView compRemoveImage(@RequestParam Map<String,Object> paramMap, HttpServletResponse response) throws Exception {
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		return mv;
	}
	
	/**
	 * 회사 다국어 정보 저장
	 * @param paramMap
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/cmm/systemx/compLangSaveProc.do")
	public ModelAndView compLangSaveProc(@RequestParam Map<String,Object> paramMap, HttpServletRequest request, HttpServletResponse response) throws Exception {

		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		
		String result = egovMessageSource.getMessage("fail.common.update");
		
		String mainYn = String.valueOf(paramMap.get("mainYn"));		// 주사용언어
		String[] subYn = request.getParameterValues("subYn");			// 서브사용언어
		
		paramMap.put("langCode", loginVO.getLangCode());

		Map<String,Object> map = null;

		if (!EgovStringUtil.isEmpty(mainYn)) {
			
			/** DB에 저장되어 있는 주사용,서브사용 언어 사용여부(yn) 값을 모두 N 값으로 초기화 
			 *  데이터를 삭제하지 않는 이유는 history는 남지 않더라도 최초 등록자를 유지하기 위해
			 * */
			Map<String,Object> p = new HashMap<String, Object>();
			p.put("compSeq", paramMap.get("compSeq"));
			compService.updateCompLang(p);
			
			boolean checkMain = false;		// 주사용 코드 셋팅 여부
			if (subYn != null) {
				for(String s : subYn) {
					map = new HashMap<String,Object>();
					map.put("compSeq", paramMap.get("compSeq"));
					map.put("langCode", s); 
					map.put("createSeq", loginVO.getUniqId());
					map.put("modifySeq", loginVO.getUniqId());
					map.put("subYn", "Y");
					if (s.equals(mainYn)) {
						map.put("mainYn", "Y");
						checkMain = true;
					} else {
						map.put("mainYn", "N");
					}
					compService.insertCompLang(map);
					result = egovMessageSource.getMessage("success.common.update");
				}
			} 
			
			/** 주사용코드를 한번도 셋팅하지 않았다면(서브사용언어 값이 없다는 것) 주사용언어 셋팅 */
			if (!checkMain) {
				map = new HashMap<String,Object>();
				map.put("compSeq", paramMap.get("compSeq"));
				map.put("langCode", mainYn); 
				map.put("createSeq", loginVO.getUniqId());
				map.put("modifySeq", loginVO.getUniqId());
				map.put("subYn", "Y");
				map.put("mainYn", "Y");
				compService.insertCompLang(map);
				result = egovMessageSource.getMessage("success.common.update");
			}
			
		} 

		ModelAndView mv = new ModelAndView();
		
		mv.addObject("result", result);
		
		mv.setViewName("jsonView");

		return mv;
	}
	
	@IncludedInfo(name="마스터회사관리", order = 101 ,gid = 60)
	@RequestMapping("/cmm/systemx/groupCompList.do")
	public ModelAndView groupCompList(@RequestParam Map<String,Object> paramMap, HttpServletRequest request) throws Exception {
		
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		
		ModelAndView mv = new ModelAndView();
		
		
		mv.setViewName("/neos/cmm/systemx/comp/groupCompListView");
		
		return mv;
	}
	
	
	
	@RequestMapping("/cmm/systemx/groupCompListData.do")
	public ModelAndView groupCompListData(@RequestParam Map<String,Object> params, HttpServletRequest request) throws Exception {
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();

		params.put("langCode", loginVO.getLangCode());
		
		String compSeq = params.get("compSeq")+"";
		String groupSeq = params.get("groupSeq")+"";
		
		if (EgovStringUtil.isEmpty(groupSeq)) {
			params.put("groupSeq", loginVO.getGroupSeq());
		}
		
		params.put("groupSeq", loginVO.getGroupSeq());
		
		
		/** 그룹 정보 가져오기. 그룹명 가져오기 위해 */
		Map<String,Object> groupMap = orgChartService.getGroupInfo(params);
	
		ModelAndView mv = new ModelAndView();
		mv.addObject("groupMap", groupMap);
		
		PaginationInfo paginationInfo = new PaginationInfo();
		
		paginationInfo.setCurrentPageNo(EgovStringUtil.zeroConvert(params.get("page")));
		paginationInfo.setPageSize(EgovStringUtil.zeroConvert(params.get("pageSize")));
		
		Map<String,Object> listMap = compService.getGroupCompList(params, paginationInfo);
		
		mv.addAllObjects(listMap);
		
		mv.setViewName("jsonView");
		
		return mv;
	}
	
	/**
	 *  마스터 계정 회사변경
	 * @param params
	 * @param request
	 * @param session
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/cmm/systemx/compChangeProc.do", method=RequestMethod.POST)//크로스사이트 요청 위조
	public ModelAndView compChangeProc(@RequestParam Map<String,Object> params, HttpServletRequest request, HttpSession session) throws Exception {
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		
		String compSeq = String.valueOf(params.get("compSeq"));

		loginVO.setCompSeq(compSeq);
		
		loginService.LoginSessionInfo(loginVO);
		
		session.setAttribute("compSeq", compSeq);		// loginVO를 변경하수 없으니 마스터모드에서는 session 으로 compseq를 제어
		
		ModelAndView mv = new ModelAndView();
		
		if (!EgovStringUtil.isEmpty(compSeq)) {
			loginVO.setCompSeq(compSeq);
			mv.addObject("result", "0");
		}
		
		mv.setViewName("jsonView");
		
		return mv;
	}
	
	/**
	 * 회사 추가 (마스터만 가능)
	 * @param params
	 * @param request
	 * @param session
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/cmm/systemx/compInsertProc.do")
	public ModelAndView compInsertProc(@RequestParam Map<String,Object> params, HttpServletRequest request, HttpSession session) throws Exception {
		
		ModelAndView mv = new ModelAndView();
		
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		String compName = String.valueOf(params.get("compName"));
		String parentCompSeq = String.valueOf(params.get("parentCompSeq"));
		
		String groupSeq = loginVO.getGroupSeq();
		if (EgovStringUtil.isEmpty(parentCompSeq)) {
			parentCompSeq = groupSeq;
		}
		
		if (EgovStringUtil.isEmpty(compName)) {
			mv.addObject("result", "-1");
		} else {
			CompVO compVo = new CompVO();
			
			Map<String, Object> mp = new HashMap<String, Object>();
			mp.put("groupSeq", groupSeq);
			mp.put("value", "orgchart");
			
			String seq = groupSeq+sequenceService.getSequence(mp);
			compVo.setGroupSeq(groupSeq);
			compVo.setCompSeq(seq);	// 회사 시퀀스는 그룹 시퀀스와 조합으로 생성('53' + '1111' = '531111')
			compVo.setParentCompSeq(parentCompSeq);
			compVo.setEditerSeq(loginVO.getUniqId());
			compVo.setNativeLangCode(loginVO.getLangCode());
			compVo.setOrder("99999");
			compVo.setUseYn("Y");
			
			String s = OrgChartSupport.getIOrgEditService().InsertComp(compVo);
			
			CompMultiVO compMultiVo = new CompMultiVO();
			compMultiVo.setCompSeq(seq);
			compMultiVo.setGroupSeq(groupSeq);
			compMultiVo.setLangCode(loginVO.getLangCode());
			compMultiVo.setUseYn("Y");
			compMultiVo.setCompName(compName);
			compMultiVo.setCompDisplayName(compName);
			compMultiVo.setEditerSeq(loginVO.getUniqId());
			
			boolean bool = OrgChartSupport.getIOrgEditService().InsertCompMulti(compMultiVo);
			
			mv.addObject("result", "0");
			mv.addObject("compInfo", compVo);
			mv.addObject("compMultiInfo", compMultiVo);
		}
			
		mv.setViewName("jsonView");
		
		return mv;
	}
	
	@RequestMapping("/cmm/systemx/compRemoveProc.do")
	public ModelAndView compRemoveProc(@RequestParam Map<String,Object> params, HttpServletRequest request, HttpSession session) throws Exception {
		
		ModelAndView mv = new ModelAndView();
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		params.put("groupSeq", loginVO.getGroupSeq());
		params.put("createSeq", loginVO.getUniqId());

		//조직도 공통어뎁터 호출
		Map<String,Object> result = orgAdapterService.compRemoveAdapter(params);

		if(result != null && result.get("resultCode").equals("SUCCESS")) {
			//회사삭제 API호출(메일) 
			orgAdapterService.mailCompDelete(params);
		}

		mv.addAllObjects(result);
		
		mv.setViewName("jsonView");
		
		return mv;
	}
	
	
	@RequestMapping("/cmm/systemx/compSortSaveProc.do")
	public ModelAndView compSortSaveProc(@RequestParam Map<String,Object> paramMap,
			HttpServletRequest request, HttpServletResponse response) throws Exception {

		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		
		ModelAndView mv = new ModelAndView();
		
		JSONArray ja = JSONArray.fromObject(paramMap.get("list"));
		JSONObject jsonObject = JSONObject.fromObject(ja.get(0));
		
		String result = egovMessageSource.getMessage("systemx.comp.CP0003");
		
		try{
			JSONArray jsonArray = JSONArray.fromObject(jsonObject.get("nodes"));
			for(int i = 0 ; i < jsonArray.size() ; i++) {
				JSONObject json = JSONObject.fromObject(jsonArray.get(i));
				
				Map<String,Object> map = new HashMap<String,Object>();
				map.put("compSeq", json.get("seq"));
				map.put("modifySeq", loginVO.getUniqId());
				map.put("orderNum", 1000000+i*10000);
				compService.updateComp(map);
			}
			

		}catch (Exception e) {
			result = egovMessageSource.getMessage("fail.common.update");
		}
		
		mv.addObject("result", result);
		
		mv.setViewName("jsonView");

		return mv;
	}
	
	
	@RequestMapping("/cmm/systemx/compLogoUploadPop.do")
	public ModelAndView compLogoUploadPop(@RequestParam Map<String,Object> paramMap,
			HttpServletRequest request, HttpServletResponse response) throws Exception {

		ModelAndView mv = new ModelAndView();
		
		mv.addAllObjects(paramMap);
		
		mv.setViewName("/neos/cmm/systemx/comp/pop/compLogoUploadPop");

		return mv;
	}
	
	@RequestMapping("/cmm/systemx/compInfoJson.do")
	public ModelAndView compInfoJson(@RequestParam Map<String,Object> params,
			HttpServletRequest request, HttpServletResponse response) throws Exception {

		ModelAndView mv = new ModelAndView();

		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();

		params.put("langCode", loginVO.getLangCode());

		params.put("groupSeq", loginVO.getGroupSeq());

		mv.addAllObjects(compService.getComp(params));
		mv.addAllObjects(compService.getCompMulti(params));

		mv.setViewName("jsonView");

		return mv;
	}
	
	
	@RequestMapping("/cmm/systemx/erpConOptionPop.do")
	public ModelAndView erpConOptionPop(@RequestParam Map<String,Object> params,
			HttpServletRequest request, HttpServletResponse response) throws Exception {

		ModelAndView mv = new ModelAndView();
		
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		
		mv.addObject("compSeq", params.get("compSeq").toString());
		mv.setViewName("/neos/cmm/systemx/comp/pop/erpConOptionPop");

		return mv;
	}
	
	@RequestMapping("/cmm/systemx/smsConOptionPop.do")
	public ModelAndView smsConOptionPop(@RequestParam Map<String,Object> params,
			HttpServletRequest request, HttpServletResponse response) throws Exception {

		ModelAndView mv = new ModelAndView();
		
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		
		Map<String, Object> smsMap = compService.getCompSmsOption(params);
		
		mv.addObject("smsMap", smsMap);
		mv.addObject("compSeq", params.get("compSeq").toString());
		mv.setViewName("/neos/cmm/systemx/comp/pop/smsConOptionPop");

		return mv;
	}
	
	
	
	@RequestMapping("/cmm/systemx/getDbConnectInfo.do")
	public ModelAndView getDbConnectInfo(@RequestParam Map<String,Object> params,
			HttpServletRequest request, HttpServletResponse response) throws Exception {

		ModelAndView mv = new ModelAndView();
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		
		params.put("groupSeq", loginVO.getGroupSeq());
		
		//관리자일 경우만 compSeq 파라미터 추가.
		//마스터인 경우 설정 화면에서 선택한 회사seq로 파라미터 셋팅.(view단)
		if(loginVO.getUserSe().equals("ADMIN")) {
			params.put("compSeq", loginVO.getCompSeq());
		}
		
		//회계부분 ERP연동 설정 불러오기.
		Map<String, Object> acMap = compService.getErpConInfo_ac(params);
		
		//인사부분 ERP연동 설정 불러오기.
		Map<String, Object> hrMap = compService.getErpConInfo_hr(params);
		
		//기타부분 ERP연동 설정 불러오기.
		Map<String, Object> etcMap = compService.getErpConInfo_etc(params);
		
		mv.addObject("acMap", acMap);
		mv.addObject("hrMap", hrMap);
		mv.addObject("etcMap", etcMap);
		
		mv.setViewName("jsonView");

		return mv;
	}
	
	
	
	@RequestMapping("/cmm/systemx/dbConnectConfirm.do")
	public ModelAndView dbConnectConfirm(@RequestParam Map<String,Object> params, HttpServletRequest request, HttpServletResponse response) throws Exception {
		
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		params.put("groupSeq", loginVO.getGroupSeq());		
		
		String startTime = (String) commonSql.select("apiMainDAO.selectSynctime", params);
		LOG.error("ERP 연결 설정 [START] - neos/cmm/systemx/comp/web/ -> dbConnectConfirm");
		LOG.error("ERP 연동 시작 시간 : " + startTime);
		
		String pServerType = params.get("dbType").toString();
		String pServerIP = params.get("dbIpAddr").toString();
		String pServerDB = params.get("dbName").toString();
		String pServerID = params.get("dbLoginId").toString();
		String pServerPW = params.get("dbLoginPwd").toString();
		
		// DB별 driver 셋팅
		String driverMssql = "com.microsoft.sqlserver.jdbc.SQLServerDriver";
		String driverMysql = "com.mysql.jdbc.Driver";
		String driverOracle = "oracle.jdbc.driver.OracleDriver";
		
		//DB별 url 셋팅
		String urlMssql = "jdbc:sqlserver://"+pServerIP+";databasename="+pServerDB;
		String urlMysql = "jdbc:mysql://"+pServerIP+"/"+pServerDB;
		String urlOracle = "jdbc:oracle:thin:@"+pServerIP;
		
		String driver = "";
		String url = "";
		
		//Mssql
		if(pServerType.equals("mssql")){
			driver = driverMssql;
			url = urlMssql;
		}
		
		//Mysql, Maria
		else if(pServerType.equals("mysql") || pServerType.equals("mariadb")){
			driver = driverMysql;
			url = urlMysql;
		}
		
		//Oracle
		else if(pServerType.equals("oracle")){
			driver = driverOracle;
			url = urlOracle;
			
			if(pServerDB.equals("edms")){
				//암호화되지 않은 중요 정보: 평문 전송
				mv.addObject("result", getEdmsMigData(driver, url, pServerID, pServerPW == null ? AESCipher.AES_Encode(pServerPW) : pServerPW));	//접속 성공.
				mv.addObject("driver", driver);
				mv.addObject("url", url);
				return mv;
			}
		}
		
		try{
			Connection connection = null;
			Class.forName(driver);
			//암호화되지 않은 중요 정보: 평문 전송
			connection = DriverManager.getConnection(url, pServerID, pServerPW == null ? AESCipher.AES_Encode(pServerPW) : pServerPW);		
			mv.addObject("result", 1);	//접속 성공.
			mv.addObject("driver", driver);
			mv.addObject("url", url);
			connection.close();
		}
		catch(Exception e){
			LOG.error("dbConnectConfirm-error.  driver : " + driver + " url : " + url, e);
			mv.addObject("error", e);
			mv.addObject("result", -1);	//접속 실패.
		}
		
		String endTime = (String) commonSql.select("apiMainDAO.selectSynctime", params);
		
		LOG.error("ERP 연동 종료 시간 : " + endTime);
		LOG.error("ERP 연결 설정 [END] - neos/cmm/systemx/comp/web/ -> dbConnectConfirm");
		return mv;
	}

	//NP게시판 마이그레이션 데이터 가져오기
	private int getEdmsMigData(String driver, String url, String pServerID, String pServerPW){
		try{
			LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser();
			
			// 조회
			Map<String,Object> param = new HashMap<String,Object>();
			param.put("groupSeq", loginVO.getGroupSeq());			

			conVo.setDriver(driver);
			conVo.setUrl(url);			
			conVo.setDatabaseType("oracle");
			conVo.setSystemType("ERPiU");
			conVo.setUserId(pServerID);
			conVo.setPassWord(pServerPW);
			
			commonSql.delete("CompManage.deleteEdmsDocList", param);
			List<Map<String, Object>> docList = exCodeOrgERPiUDAO.getExQueryResult(param, conVo, "GetEdmsDocList");
			for (Map<String, Object> map : docList) {
				map.put("groupSeq", loginVO.getGroupSeq());
				commonSql.insert("CompManage.insertEdmsDocList", map);
			}

			commonSql.delete("CompManage.deleteEdmsBoxList", param);
			List<Map<String, Object>> boxList = exCodeOrgERPiUDAO.getExQueryResult(param, conVo, "GetEdmsBoxList");
			if(boxList != null && boxList.size() > 0){
				Map<String, Object> boxListMap = new HashMap<String, Object>();
				boxListMap.put("groupSeq", loginVO.getGroupSeq());
				boxListMap.put("resultList", boxList);				
				commonSql.insert("CompManage.insertEdmsBoxList", boxListMap);
			}
			
			commonSql.delete("CompManage.deleteEdmsBoxPermList", param);
			List<Map<String, Object>> boxPermList = exCodeOrgERPiUDAO.getExQueryResult(param, conVo, "GetEdmsBoxPermList");
			if(boxPermList != null && boxPermList.size() > 0){
				Map<String, Object> boxPermListMap = new HashMap<String, Object>();
				boxPermListMap.put("groupSeq", loginVO.getGroupSeq());
				boxPermListMap.put("resultList", boxPermList);				
				commonSql.insert("CompManage.insertEdmsBoxPermList", boxPermListMap);
			}			
			
			commonSql.delete("CompManage.deleteEdmsReadList", param);
			List<Map<String, Object>> readList = exCodeOrgERPiUDAO.getExQueryResult(param, conVo, "GetEdmsReadList");
			if(readList != null && readList.size() > 0){
				Map<String, Object> readListMap = new HashMap<String, Object>();
				readListMap.put("groupSeq", loginVO.getGroupSeq());
				readListMap.put("resultList", readList);				
				commonSql.insert("CompManage.insertEdmsReadList", readListMap);
			}
			
			commonSql.delete("CompManage.deleteEdmsPublicList", param);
			List<Map<String, Object>> publicList = exCodeOrgERPiUDAO.getExQueryResult(param, conVo, "GetEdmsPublicList");
			if(publicList != null && publicList.size() > 0){
				Map<String, Object> publicListMap = new HashMap<String, Object>();
				publicListMap.put("groupSeq", loginVO.getGroupSeq());
				publicListMap.put("resultList", publicList);				
				commonSql.insert("CompManage.insertEdmsPublicList", publicListMap);
			}			

			commonSql.delete("CompManage.deleteEdmsCommentList", param);
			List<Map<String, Object>> commentList = exCodeOrgERPiUDAO.getExQueryResult(param, conVo, "GetEdmsCommentList");
			if(commentList != null && commentList.size() > 0){
				Map<String, Object> commentListMap = new HashMap<String, Object>();
				commentListMap.put("groupSeq", loginVO.getGroupSeq());
				commentListMap.put("resultList", commentList);				
				commonSql.insert("CompManage.insertEdmsCommentList", commentListMap);
			}
			
			commonSql.delete("CompManage.deleteEdmsFileList", param);
			List<Map<String, Object>> fileList = exCodeOrgERPiUDAO.getExQueryResult(param, conVo, "GetEdmsFileList");
			if(fileList != null && fileList.size() > 0){
				Map<String, Object> fileListMap = new HashMap<String, Object>();
				fileListMap.put("groupSeq", loginVO.getGroupSeq());
				fileListMap.put("resultList", fileList);				
				commonSql.insert("CompManage.insertEdmsFileList", fileListMap);
			}		
			
			commonSql.delete("CompManage.deleteEdmsFileDetailList", param);
			List<Map<String, Object>> fileDetailList = exCodeOrgERPiUDAO.getExQueryResult(param, conVo, "GetEdmsFileDetailList");
			if(fileDetailList != null && fileDetailList.size() > 0){
				Map<String, Object> fileDetailListMap = new HashMap<String, Object>();
				fileDetailListMap.put("groupSeq", loginVO.getGroupSeq());
				fileDetailListMap.put("resultList", fileDetailList);				
				commonSql.insert("CompManage.insertEdmsFileDetailList", fileDetailListMap);
			}			
			
			return 1;
		}
		catch(Exception e){
			return -1;	//접속 실패.
		}
	}
	
	@RequestMapping("/cmm/systemx/dbConnectInfoSave.do")
	public ModelAndView dbConnectInfoSave(@RequestParam Map<String,Object> params, HttpServletRequest request, HttpServletResponse response) throws Exception {

		ModelAndView mv = new ModelAndView();
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		
		params.put("groupSeq", loginVO.getGroupSeq());
		params.put("empSeq", loginVO.getUniqId());
		
		//관리자일 경우만 compSeq 파라미터 추가.
		//마스터인 경우 설정 화면에서 선택한 회사seq로 파라미터 셋팅.(view단)
		if(loginVO.getUserSe().equals("ADMIN")) {
			params.put("compSeq", loginVO.getCompSeq());
		}
		
		String[] achrGbn = params.get("achrGbn").toString().split(",");
		String[] erpTypeCode = params.get("erpTypeCode").toString().split(",");		
		String[] databaseType = params.get("databaseType").toString().split(",");
		String[] listDriver = params.get("listDriver").toString().split(",");
		String[] listUrl = params.get("listUrl").toString().split(",");
		String[] listUserID = params.get("listUserID").toString().split(",");
		String[] listPassWord = params.get("listPassWord").toString().split(",");
		String[] delType = params.get("delType").toString().split(",");
		
		
		for(int i=0;i< achrGbn.length; i++){
			if(achrGbn[i].equals("")) {
				continue;
			}
			params.put("achrGbn", achrGbn[i]);
			params.put("erpTypeCode", erpTypeCode[i]);			
			params.put("databaseType", databaseType[i]);
			params.put("Driver", listDriver[i]);
			params.put("Url", listUrl[i]);
			params.put("UserID", listUserID[i]);
			params.put("PassWord", listPassWord[i]);
			
			if(achrGbn[i].equals("ac")){
				params.put("erpCompSeq", params.get("ErpCompSeq1").toString());
				params.put("erpCompName", params.get("ErpCompName1").toString());
				params.put("g20Yn", params.get("g20Yn1"));
			}
			else if(achrGbn[i].equals("hr")){
				params.put("erpCompSeq", params.get("ErpCompSeq2").toString());
				params.put("erpCompName", params.get("ErpCompName2").toString());
				params.put("g20Yn", params.get("g20Yn2"));
			}
			else if(achrGbn[i].equals("etc")){
				params.put("erpCompSeq", params.get("ErpCompSeq3").toString());
				params.put("erpCompName", params.get("ErpCompName3").toString());
				params.put("g20Yn", params.get("g20Yn3"));
			}			
			
			
			compService.dbConnectInfoDelete(params);
			compService.dbConnectInfoSave(params);
		}
		
		// erp연동 데이터가 존재하면 t_co_erp_comp테이블 데이터 추가.
		if(achrGbn.length > 0 ){
			int acCnt = 0;
			int hrCnt = 0;
			int etcCnt = 0;
			for(int i= 0;i<achrGbn.length;i++){
				if(achrGbn[i].equals("ac")) {
					acCnt ++;
				}
				if(achrGbn[i].equals("hr")) {
					hrCnt ++;
				}
				if(achrGbn[i].equals("etc")) {
					etcCnt ++;
				}
			}
			
			
			if(hrCnt > 0){
				for(int i=0;i< achrGbn.length; i++){
					if(achrGbn[i].equals("hr")){
						params.put("achrGbn", achrGbn[i]);
						params.put("erpTypeCode", erpTypeCode[i]);			
						params.put("databaseType", databaseType[i]);
						params.put("Driver", listDriver[i]);
						params.put("Url", listUrl[i]);
						params.put("UserID", listUserID[i]);
						params.put("PassWord", listPassWord[i]);
						params.put("erpCompSeq", params.get("ErpCompSeq2").toString());
						params.put("erpCompName", params.get("ErpCompName2").toString());
					}
				}
			}
			else if(acCnt > 0){
				for(int i=0;i< achrGbn.length; i++){
					if(achrGbn[i].equals("ac")){
						params.put("achrGbn", achrGbn[i]);
						params.put("erpTypeCode", erpTypeCode[i]);			
						params.put("databaseType", databaseType[i]);
						params.put("Driver", listDriver[i]);
						params.put("Url", listUrl[i]);
						params.put("UserID", listUserID[i]);
						params.put("PassWord", listPassWord[i]);
						params.put("erpCompSeq", params.get("ErpCompSeq1").toString());
						params.put("erpCompName", params.get("ErpCompName1").toString());
					}
				}
			}
			else if(etcCnt > 0){
				for(int i=0;i< achrGbn.length; i++){
					if(achrGbn[i].equals("etc")){
						params.put("achrGbn", achrGbn[i]);
						params.put("erpTypeCode", erpTypeCode[i]);			
						params.put("databaseType", databaseType[i]);
						params.put("Driver", listDriver[i]);
						params.put("Url", listUrl[i]);
						params.put("UserID", listUserID[i]);
						params.put("PassWord", listPassWord[i]);
						params.put("erpCompSeq", params.get("ErpCompSeq3").toString());
						params.put("erpCompName", params.get("ErpCompName3").toString());
					}
				}
			}
			
			if(acCnt > 0 || hrCnt > 0 || etcCnt > 0){
				if(achrGbn.length > 0){			
					compService.deleteErpCompInfo(params);
					compService.insertErpCompInfo(params);
				}
			}
		}
		
		
		
		for(int i=0;i<delType.length;i++){
			if(delType[i].equals("")) {
				continue;
			}
			params.put("achrGbn", delType[i]);
			compService.deleteDbConnectInfo(params);
		}
		
		if(delType.length == 3){
			compService.deleteErpCompInfo(params);
		}
		
		
		
		
		mv.setViewName("jsonView");

		return mv;
	}
	

	@RequestMapping("/cmm/systemx/compSeqCheck.do")
	public ModelAndView compSeqCheck(@RequestParam Map<String,Object> params, HttpServletRequest request, HttpServletResponse response) throws Exception {

		ModelAndView mv = new ModelAndView();
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		
//		params.put("blockUseYn", "N");
		params.put("groupSeq", loginVO.getGroupSeq());
		Map<String,Object> compMap = (Map<String, Object>) commonSql.select("CompManage.getCompCdInfo", params);
		
		if(compMap == null) {
			mv.addObject("result", "1");
		}
		else {
			mv.addObject("result","0");
		}
	
		mv.setViewName("jsonView");

		return mv;
	}
	
	
	/**
	 * erp회사 리스트 팝업
	 * @param param
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/cmm/systemx/ExCompPop.do")
	public ModelAndView ExCompPop(@RequestParam Map<String, Object> param, HttpServletRequest request) throws Exception {
		ModelAndView mv = new ModelAndView();
		
		//erp회사 리스트 조회.
		ServletContext sc = request.getSession().getServletContext();
		ApplicationContext act = WebApplicationContextUtils.getRequiredWebApplicationContext(sc);
		
		try {
			LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser();

			/*ex 시스템정보 */
			//conVo = compService.getExSystemType(param);
			conVo.setDriver(param.get("driver").toString());
			conVo.setUrl(param.get("url").toString());			
			conVo.setDatabaseType(param.get("dbType").toString());
			if(param.get("erpVer").toString().equals("ICUBE")) {
				conVo.setSystemType("iCUBE");
			}
			else {
				conVo.setSystemType("ERPiU");
			}
			conVo.setUserId(param.get("dbId").toString());
			conVo.setPassWord(param.get("dbPwd").toString());
			
			String serviceName = "ExCodeOrg"+conVo.getSystemType()+"Service";
			
			ExCodeOrgService exCodeOrgService = (ExCodeOrgService)act.getBean(serviceName);
			param.put("txtSearch", "");
			param.put("loginVO", loginVO);
			
			// 조회
			List<Map<String, Object>> aaData = exCodeOrgService.getExCompList(param, loginVO, conVo);

			// 반환처리
			mv.addAllObjects(param);
			mv.addObject("serviceName", serviceName);
			mv.addObject("compList", aaData);
			mv.addObject("index", param.get("index").toString());
		}
		catch (Exception e) {
			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
		}
		mv.setViewName("/neos/cmm/systemx/comp/pop/ExCompPop");
		return mv;
	}
	
	
	
	/**
	 * erp회사 리스트 조회
	 * @param param
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/cmm/systemx/getExCompList.do")
	public ModelAndView getExCompList(@RequestParam Map<String, Object> param, HttpServletRequest request) throws Exception {
		ModelAndView mv = new ModelAndView();
		
		//erp회사 리스트 조회.
		ServletContext sc = request.getSession().getServletContext();
		ApplicationContext act = WebApplicationContextUtils.getRequiredWebApplicationContext(sc);
		
		try {
			LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser();

			/*ex 시스템정보 */
			//conVo = compService.getExSystemType(param);
			conVo.setDriver(param.get("driver").toString());
			conVo.setUrl(param.get("url").toString());			
			conVo.setDatabaseType(param.get("dbType").toString());
			if(param.get("erpVer").toString().equals("ICUBE")) {
				conVo.setSystemType("iCUBE");
			}
			else {
				conVo.setSystemType("ERPiU");
			}
			conVo.setUserId(param.get("dbId").toString());
			conVo.setPassWord(param.get("dbPwd").toString());
			
			String serviceName = "ExCodeOrg"+conVo.getSystemType()+"Service";
			
			ExCodeOrgService exCodeOrgService = (ExCodeOrgService)act.getBean(serviceName);
			param.put("loginVO", loginVO);
			
			// 조회
			List<Map<String, Object>> aaData = exCodeOrgService.getExCompList(param, loginVO, conVo);

			// 반환처리
			mv.addObject("serviceName", serviceName);
			mv.addObject("compList", aaData);

		}
		catch (Exception e) {
			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
		}
		mv.setViewName("jsonView");
		return mv;
	}
	
	@RequestMapping("/cmm/systemx/ftpProfileSync.do")
	public ModelAndView ftpProfileSync(@RequestParam Map<String,Object> paramMap, HttpServletResponse response) throws Exception {
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		
		if(loginVO != null && loginVO.getUserSe().equals("MASTER")){
			orgAdapterService.ftpProfileSync(paramMap);
			mv.addObject("result", "SUCCESS");
		}else {
			mv.addObject("result", "FAIL");
		}
		
		return mv;
	}	
	
	
	//전자결재 옵션 rebuild api호출
	@SuppressWarnings({ "unused", "static-access" })
	private void EaOptionReBuild(String eaType, HttpServletRequest request){
		try{
			String url = "";
			String jsonParam =	  "{}";
			String serverName = request.getServerName();
			
			String apiUrl = request.getScheme() + "://" + serverName + "/" + eaType + "/cmm/system/OptionReBuild.do";			

			JSONObject jsonObject2 = JSONObject.fromObject(JSONSerializer.toJSON(jsonParam));
			HttpJsonUtil httpJson = new HttpJsonUtil();
			httpJson.execute("POST", apiUrl, jsonObject2);
		 }
		 catch (Exception e) {
			 CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
		 }
	}
	
}
