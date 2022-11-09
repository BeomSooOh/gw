package neos.cmm.ex.visitor.web;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;





import egovframework.com.utl.fcc.service.EgovStringUtil;
import egovframework.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;
import main.web.BizboxAMessage;

import org.apache.log4j.Logger;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import api.common.exception.APIException;
import api.common.model.APIResponse;
import bizbox.orgchart.service.vo.LoginVO;
import egovframework.com.cmm.util.EgovUserDetailsHelper;

import neos.cmm.ex.visitor.service.VisitorManageService;
import neos.cmm.ex.visitor.vo.EaDocInterlockVO;
import neos.cmm.menu.service.MenuManageService;
import neos.cmm.systemx.comp.service.CompManageService;
import neos.cmm.util.CommonUtil;
import neos.cmm.util.HttpJsonUtil;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

@SuppressWarnings("unused")
@Controller
public class VisitorManageController {
	
	@Resource(name = "VisitorManageService")
	private VisitorManageService visitorManageService;

	@Resource ( name = "MenuManageService" )
	private MenuManageService menuManageService;
	
	@Resource ( name = "CompManageService" )
	private CompManageService compManageService;
	
	/**
	 * 일반방문객 페이지 호출
	 * @param paramMap
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/cmm/ex/visitor/BSDuzonVisitorView.do")
	public ModelAndView BSDuzonVisitorView(@RequestParam Map<String, Object> paramMap , HttpServletRequest request) throws Exception{
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		
		ModelAndView mv = new ModelAndView();
		
		if(!menuManageService.checkMenuAuth(loginVO, request.getServletPath())) {
			mv.setViewName( "redirect:/forwardIndex.do" );
			return mv;
		}
		
		mv.setViewName("/neos/cmm/ex/visitor/BSDuzonVisitor");
		
		return mv;
	}
	
	
	/**
	 * 일반방문객 조회
	 * @param paramMap
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/cmm/ex/visitor/getVisitorList.do")
	public ModelAndView getVisitorList(@RequestParam Map<String, Object> paramMap , HttpServletRequest request) throws Exception{
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		
		PaginationInfo paginationInfo = new PaginationInfo();
		
		Map<String, Object> list = new HashMap<String, Object>();
		paginationInfo.setCurrentPageNo(EgovStringUtil.zeroConvert(paramMap.get("page")));
		paginationInfo.setPageSize(EgovStringUtil.zeroConvert(paramMap.get("pageSize")));
		
		paramMap.put("langCD", loginVO.getLangCode());
		paramMap.put("empSeq", loginVO.getUniqId());
		paramMap.put("userSe", loginVO.getUserSe());
	
		list = visitorManageService.getVisitorList(paramMap, paginationInfo);
		ModelAndView mv = new ModelAndView();
		
		mv.addAllObjects(list);
		mv.setViewName("jsonView");
		return mv;
	}
	
	
	/**
	 * 방문객 상세조회(일반/외주)
	 * @param paramMap
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/cmm/ex/visitor/GetVisitor.do")
	public ModelAndView GetVisitor(@RequestParam Map<String, Object> paramMap , HttpServletRequest request) throws Exception{
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();	
	
		paramMap.put("langCD", loginVO.getLangCode());
		
		Map<String, Object> result = visitorManageService.GetVisitor(paramMap);
		
		ModelAndView mv = new ModelAndView();
		
		mv.addAllObjects(result);
		mv.setViewName("jsonView");
		return mv;
	}
	
	
	
	/**
	 * 방문객 삭제(일반/외주)
	 * @param paramMap
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/cmm/ex/visitor/DeleteVisitor.do")
	public ModelAndView DeleteVisitor(@RequestParam Map<String, Object> paramMap , HttpServletRequest request) throws Exception{
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		ModelAndView mv = new ModelAndView();
		
		visitorManageService.DeleteVisitor(paramMap);
		
		mv.setViewName("jsonView");
		return mv;
	}
	
	
	
	/**
	 * 일반방문객 등록 팝업 호출
	 * @param paramMap
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/cmm/ex/visitor/visitorPopView.do")
	public ModelAndView visitorPopView(@RequestParam Map<String, Object> paramMap , HttpServletRequest request) throws Exception{
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		
		ModelAndView mv = new ModelAndView();
		
		Map<String, Object> content = new HashMap<String,Object>();
		/* 기존 로직 */
		mv.setViewName("/neos/cmm/ex/visitor/pop/BSDuzonVisitorPop");
		
//			// 상신 -> 문서 생성 -> 이전단계
//			if(paramMap.get("approKey") != null) {
//				
//				String approKey = paramMap.get("approKey").toString();
//				String reqNo = approKey.substring(approKey.lastIndexOf("_")+1);
//				content = visitorManageService.getVisitorPopContent(paramMap);
//				content.put("approKey", approKey);
//				content.put("reqNo", reqNo);
//				mv.addObject("content", content);
//			}
//			mv.setViewName("/neos/cmm/ex/visitor/pop/BSDuzonVisitorPop2");
		return mv;
	}
	
	
	/**
	 * 방문객 등록(일반/외주)
	 * @param paramMap
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/cmm/ex/visitor/InsertVisitor.do")
	public ModelAndView InsertVisitor(@RequestParam Map<String, Object> paramMap , HttpServletRequest request) throws Exception{
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		paramMap.put("req_comp_seq", loginVO.getCompSeq());
		paramMap.put("req_emp_seq", loginVO.getUniqId());
		visitorManageService.insertVisitor(paramMap);
		ModelAndView mv = new ModelAndView();

		mv.setViewName("jsonView");

		return mv;
	}
	

	/**
	 * 외주인원 페이지 호출
	 * @param paramMap
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/cmm/ex/visitor/BSDuzonVisitorSubView.do")
	public ModelAndView BSDuzonVisitorSubView(@RequestParam Map<String, Object> paramMap , HttpServletRequest request) throws Exception{
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		
		ModelAndView mv = new ModelAndView();
		
		if(!menuManageService.checkMenuAuth(loginVO, request.getServletPath())) {
			mv.setViewName( "redirect:/forwardIndex.do" );
			return mv;
		}
		
		mv.setViewName("/neos/cmm/ex/visitor/BSDuzonVisitorSub");
		
		return mv;
	}
	
	
	/**
	 * 외주인원 상세보기 팝업 페이지 호출
	 * @param paramMap
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/cmm/ex/visitor/visitorPopSubView.do")
	public ModelAndView BSDuzonVisitorSubPopView(@RequestParam Map<String, Object> paramMap , HttpServletRequest request) throws Exception{
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		
		ModelAndView mv = new ModelAndView();
		
		mv.setViewName("/neos/cmm/ex/visitor/pop/BSDuzonVisitorPopSub");
		
		return mv;
	}
	
	
	/**
	 * 승인관리 페이지 호출
	 * @param paramMap
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/cmm/ex/visitor/BSDuzonVisitorAppSetView.do")
	public ModelAndView BSDuzonVisitorAppSetView(@RequestParam Map<String, Object> paramMap , HttpServletRequest request) throws Exception{
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		
		ModelAndView mv = new ModelAndView();
		
		mv.setViewName("/neos/cmm/ex/visitor/BSDuzonVisitorAppSet");
		
		return mv;
	}
	
	
	
	/**
	 * 회사별 승인자 목록 조회
	 * @param paramMap
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/cmm/ex/visitor/GetApproverList.do")
	public ModelAndView GetApproverList(@RequestParam Map<String, Object> paramMap , HttpServletRequest request) throws Exception{
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();	
	
		paramMap.put("langCD", loginVO.getLangCode());
		paramMap.put("groupSeq", loginVO.getGroupSeq());
		
		List<Map<String, Object>> list = visitorManageService.GetApproverList(paramMap);
		Map<String, Object> result = new HashMap<String,Object>();
		result.put("list", list);
		ModelAndView mv = new ModelAndView();
		
		mv.addAllObjects(result);
		mv.setViewName("jsonView");
		return mv;
	}
	
	
	/**
	 * 방문객현황 페이지 호출
	 * @param paramMap
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/cmm/ex/visitor/BSDuzonVisitListView.do")
	public ModelAndView BSDuzonVisitListView(@RequestParam Map<String, Object> paramMap , HttpServletRequest request) throws Exception{
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		
		ModelAndView mv = new ModelAndView();
		
		if(!menuManageService.checkMenuAuth(loginVO, request.getServletPath())) {
			mv.setViewName( "redirect:/forwardIndex.do" );
			return mv;
		}
		
		mv.addObject("userSe", loginVO.getUserSe());
		mv.setViewName("/neos/cmm/ex/visitor/BSDuzonVisitList");
		
		return mv;
	}
	
	
	/**
	 * 외주인원 승인 페이지 호출
	 * @param paramMap
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/cmm/ex/visitor/BSDuzonVisitorAppView.do")
	public ModelAndView BSDuzonVisitorAppView(@RequestParam Map<String, Object> paramMap , HttpServletRequest request) throws Exception{
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		
		ModelAndView mv = new ModelAndView();
		
		if(!menuManageService.checkMenuAuth(loginVO, request.getServletPath())) {
			mv.setViewName( "redirect:/forwardIndex.do" );
			return mv;
		}
		
		mv.setViewName("/neos/cmm/ex/visitor/BSDuzonVisitorApp");
		
		return mv;
	}
	
	/**
	 *입/퇴실체크(일반방문객)페이지 호출
	 * @param paramMap
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/cmm/ex/visitor/BSDuzonVisitCheckView.do")
	public ModelAndView BSDuzonVisitCheckView(@RequestParam Map<String, Object> paramMap , HttpServletRequest request) throws Exception{
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		
		ModelAndView mv = new ModelAndView();
		
		if(!menuManageService.checkMenuAuth(loginVO, request.getServletPath())) {
			mv.setViewName( "redirect:/forwardIndex.do" );
			return mv;
		}
		
		mv.setViewName("/neos/cmm/ex/visitor/BSDuzonVisitCheck");
		
		return mv;
	}
	

	/**
	 * 입/퇴실 처리
	 * @param paramMap
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/cmm/ex/visitor/CheckVisitor.do")
	public ModelAndView CheckVisitor(@RequestParam Map<String, Object> paramMap , HttpServletRequest request) throws Exception{
		
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();	
		paramMap.put("langCD", loginVO.getLangCode());
		ModelAndView mv = new ModelAndView();

		visitorManageService.CheckVisitor(paramMap);
		
		mv.setViewName("jsonView");
		return mv;
	}
	

	/**
	 * 입/퇴실체크(외주인원) 페이지 호출
	 * @param paramMap
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/cmm/ex/visitor/BSDuzonVisitCheckSubView.do")
	public ModelAndView BSDuzonVisitCheckSubView(@RequestParam Map<String, Object> paramMap , HttpServletRequest request) throws Exception{
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		
		ModelAndView mv = new ModelAndView();
		
		if(!menuManageService.checkMenuAuth(loginVO, request.getServletPath())) {
			mv.setViewName( "redirect:/forwardIndex.do" );
			return mv;
		}
		
		mv.setViewName("/neos/cmm/ex/visitor/BSDuzonVisitCheckSub");
		
		return mv;
	}
	
	/**
	 * 방문객현황 페이지 해당 주의 방문객 리스트 조회
	 * @param paramMap
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/cmm/ex/visitor/GetVisitorWeekList.do")
	public ModelAndView GetVisitorWeekList(@RequestParam Map<String, Object> paramMap) throws Exception{
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		String userSe = loginVO.getUserSe();
		String[] arrWeek = paramMap.get("sData").toString().split("\\|");	//해당 주의 날짜(yyyymmdd)
		String[] week = {"Sun","Mon","Tue","Wed","Thu","Fri","Sat"};
		
		
		ModelAndView mv = new ModelAndView();
		
		
		for(int i=0;i<arrWeek.length-1;i++){
			String retVal = "";
			paramMap.put("sDate", arrWeek[i]);
			List<Map<String,Object>> list = visitorManageService.GetVisitorWeekList(paramMap);
			
			for(Map<String,Object> map : list){
				
				int up = 0; // 0 : 일반, 1: 고도화
				/* 일반 */
				if(map.get("visit_place_code").toString().equals("")) {
					up = 0;
				}
				/* 고도화 */
				else {
					up = 1;
				}
				
				if(up == 0) {
					//방문객이 1명 이상인경우
					if(Integer.parseInt(map.get("visit_cnt").toString()) > 1){
						if(userSe.equals("USER")) {
							retVal += "<div>" + map.get("visit_tm_fr").toString().substring(0, 2) + BizboxAMessage.getMessage("TX000001228","시") + map.get("visit_tm_fr").toString().substring(2, 4) + BizboxAMessage.getMessage("TX000001229","분")+" : " + map.get("visitor_co") + " ; " + map.get("visitor_nm") + BizboxAMessage.getMessage("TX000005613","외") + (Integer.parseInt(map.get("visit_cnt").toString()) - 1) + BizboxAMessage.getMessage("TX000000878","명")+" ; " + map.get("visit_aim") + "</div>";
						}
						else {
							retVal += "<div><a href='javascript:;' onclick='fnDetailView(" + map.get("r_no") + ", 0)'>" + map.get("visit_tm_fr").toString().substring(0, 2) + BizboxAMessage.getMessage("TX000001228","시") + map.get("visit_tm_fr").toString().substring(2, 4) + BizboxAMessage.getMessage("TX000001229","분")+" : " + map.get("visitor_co") + " ; " + map.get("visitor_nm") + BizboxAMessage.getMessage("TX000005613","외") + (Integer.parseInt(map.get("visit_cnt").toString()) - 1) + BizboxAMessage.getMessage("TX000000878","명")+" ; " + map.get("visit_aim") + "</a></div>";
						}
					}
					else{
						if(userSe.equals("USER")) {
							retVal += "<div>" + map.get("visit_tm_fr").toString().substring(0, 2) + BizboxAMessage.getMessage("TX000001228","시") + map.get("visit_tm_fr").toString().substring(2, 4) + BizboxAMessage.getMessage("TX000001229","분")+" : " + map.get("visitor_co") + " ; " + map.get("visitor_nm") + " ; " + map.get("visit_aim") + "</div>";
						}
						else {
							retVal += "<div><a href='javascript:;' onclick='fnDetailView(" + map.get("r_no") + ", 0)'>" + map.get("visit_tm_fr").toString().substring(0, 2) + BizboxAMessage.getMessage("TX000001228","시") + map.get("visit_tm_fr").toString().substring(2, 4) + BizboxAMessage.getMessage("TX000001229","분")+" : " + map.get("visitor_co") + " ; " + map.get("visitor_nm") + " ; " + map.get("visit_aim") + "</a></div>";
						}
					}
				}
				else {
					if(userSe.equals("USER")) {
						retVal += "<div>" + map.get("visit_tm_fr").toString().substring(0, 2) + BizboxAMessage.getMessage("TX000001228","시") + map.get("visit_tm_fr").toString().substring(2, 4) + BizboxAMessage.getMessage("TX000001229","분")+" : " + map.get("visitor_co") + " ; " + map.get("visitor_nm") + " ; " + map.get("visit_aim") + "</div>";
					}
					else {
						retVal += "<div><a href='javascript:;' onclick='fnDetailView(" + map.get("r_no") + ", 1)'>" + map.get("visit_tm_fr").toString().substring(0, 2) + BizboxAMessage.getMessage("TX000001228","시") + map.get("visit_tm_fr").toString().substring(2, 4) + BizboxAMessage.getMessage("TX000001229","분")+" : " + map.get("visitor_co") + " ; " + map.get("visitor_nm") + " ; " + map.get("visit_aim") + "</a></div>";
					}
				}
			}
			
			mv.addObject(week[i], retVal);
		}
		
		mv.setViewName("jsonView");
		
		return mv;
	}
	
	
	/**
	 * 외주인원 승인 목록 조회
	 * @param paramMap
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/cmm/ex/visitor/GetVisitorListApp.do")
	public ModelAndView GetVisitorListApp(@RequestParam Map<String, Object> paramMap , HttpServletRequest request) throws Exception{
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		
		PaginationInfo paginationInfo = new PaginationInfo();
		
		paginationInfo.setCurrentPageNo(EgovStringUtil.zeroConvert(paramMap.get("page")));
		paginationInfo.setPageSize(EgovStringUtil.zeroConvert(paramMap.get("pageSize")));
		
		paramMap.put("nUserSeq", loginVO.getUniqId());
		paramMap.put("nCoSeq", loginVO.getCompSeq());
		paramMap.put("sLangKind", loginVO.getLangCode());
		
		Map<String, Object> list = visitorManageService.GetVisitorListApp(paramMap, paginationInfo);
		
		ModelAndView mv = new ModelAndView();
		
		mv.addAllObjects(list);
		mv.setViewName("jsonView");
		
		return mv;
	}
	
	
	/**
	 * 외주인원 승인/반려 처리.
	 * @param paramMap
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/cmm/ex/visitor/SetVisitorApp.do")
	public ModelAndView SetVisitorApp(@RequestParam Map<String, Object> paramMap) throws Exception{
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		
		paramMap.put("nUserSeq", loginVO.getUniqId());
		paramMap.put("nCoSeq", loginVO.getCompSeq());
	
		visitorManageService.SetVisitorApp(paramMap);
		
		ModelAndView mv = new ModelAndView();

		mv.setViewName("jsonView");
		
		return mv;
	}
	
	
	/**
	 * 승인자 저장
	 * @param paramMap
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/cmm/ex/visitor/SetVisitApproval.do")
	public ModelAndView SetVisitApproval(@RequestParam Map<String, Object> paramMap) throws Exception{
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		
		paramMap.put("nCreatedSeq", loginVO.getUniqId());
	
		visitorManageService.SetVisitApproval(paramMap);
		
		ModelAndView mv = new ModelAndView();

		mv.setViewName("jsonView");
		
		return mv;
	}
	
	/**
	 * 해당 회사 승인자 조회
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/cmm/ex/visitor/GetAppInfo.do")
	public ModelAndView GetAppInfo(@RequestParam Map<String, Object> paramMap) throws Exception{
	
		Map<String,Object> result = visitorManageService.GetAppInfo(paramMap);
		ModelAndView mv = new ModelAndView();

		mv.addAllObjects(result);
		mv.setViewName("jsonView");
		
		return mv;
	}
	
	
	
	/********* 그룹사 전용 **********/
    /**
	 * 방문객등록(QR인증) 페이지 호출
	 * @param paramMap
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/cmm/ex/visitor/BSDuzonVisitListQr.do")
	public ModelAndView BSDuzonVisitListQr(@RequestParam Map<String, Object> paramMap , HttpServletRequest request) throws Exception{
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		
		Map<String, Object> params = new HashMap<String, Object>();
		
		params.put( "groupSeq", loginVO.getGroupSeq());
		params.put( "compSeq", loginVO.getOrganId());
		params.put( "empSeq", loginVO.getUniqId());
		params.put( "langCode", loginVO.getLangCode());
		
		ModelAndView mv = new ModelAndView();
		
		if(!menuManageService.checkMenuAuth(loginVO, request.getServletPath())) {
			mv.setViewName( "redirect:/forwardIndex.do" );
			return mv;
		}
		
		/* 2020.10.14 관리자 권한인 경우에도 전체 회사 리스트 조회를 위해 userSe 세팅 */
		String userSe = loginVO.getUserSe();
		
		if(userSe.equals("ADMIN")) {
			userSe = "MASTER";
		}
		params.put( "userSe", userSe);
		
		/* 전자결재 form_id 가져오기 */
		String formId = visitorManageService.getEaDocFormId(paramMap);
		mv.addObject("formId",formId);
		
		List<Map<String, Object>> compList = null;
		if ( userSe != null ) {
			compList = compManageService.getCompListAuth( params );
		}
		mv.addObject( "compList", compList );
		JSONArray json = JSONArray.fromObject( compList );
		mv.addObject( "compListJson", json );
		
		mv.addObject("userSe", userSe);
		mv.addObject("loginVO",loginVO);
		
		mv.setViewName("/neos/cmm/ex/visitor/BSDuzonVisitorListQr");
		
		return mv;
	}
	
    
	/**
	 * 일반방문객 조회
	 * @param paramMap
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/cmm/ex/visitor/getNormalVisitorList.do")
	public ModelAndView getVisitorNormalList(@RequestParam Map<String, Object> paramMap , HttpServletRequest request) throws Exception{
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		
		PaginationInfo paginationInfo = new PaginationInfo();
		
		Map<String, Object> list = new HashMap<String, Object>();
		paginationInfo.setCurrentPageNo(EgovStringUtil.zeroConvert(paramMap.get("page")));
		paginationInfo.setPageSize(EgovStringUtil.zeroConvert(paramMap.get("pageSize")));
		
		paramMap.put("langCD", loginVO.getLangCode());
		paramMap.put("empSeq", loginVO.getUniqId());
		paramMap.put("compSeq", loginVO.getCompSeq());
		
		/* 2020.10.14 관리자권한인 경우에도 마스터 권한으로 세팅 */
		String userSe = loginVO.getUserSe();
		if(userSe.equals("ADMIN")) {
			userSe = "MASTER";
		}
		
		paramMap.put("userSe", userSe);
		paramMap.put("groupSeq", loginVO.getGroupSeq());
		
		list = visitorManageService.getNormalVisitorList(paramMap, paginationInfo);
		ModelAndView mv = new ModelAndView();
		
		mv.addAllObjects(list);
		mv.setViewName("jsonView");
		return mv;
	}
	
	
	/**
	 * 방문객등록(QR인증) 등록 팝업 호출
	 * @param paramMap
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/cmm/ex/visitor/visitorPopViewNew.do")
	public ModelAndView visitorPopViewNew(@RequestParam Map<String, Object> paramMap , HttpServletRequest request) throws Exception{
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		
		ModelAndView mv = new ModelAndView();
		
		Map<String, Object> content = new HashMap<String,Object>();
		
		/* 전자결재 form_id 가져오기 */
		String formId = visitorManageService.getEaDocFormId(paramMap);
		mv.addObject("formId",formId);
		
		// 상신 -> 문서 생성 -> 이전단계
		if(paramMap.get("approKey") != null) {
			String approKey = paramMap.get("approKey").toString();
			String reqNo = approKey.substring(approKey.lastIndexOf("_")+1);
			content = visitorManageService.getVisitorPopContent(paramMap);
			content.put("approKey", approKey);
			content.put("reqNo", reqNo);
			mv.addObject("content", content);
		}
		
		/* view모드 팝업 호출 시 방문객 데이터 호출 */
		if(paramMap.get("type").equals("view")) {
			paramMap.put("pDist", "1");
			paramMap.put("nRNo", paramMap.get("r_no"));

			Map<String, Object> visitorInfo = visitorManageService.getVisitorNew(paramMap);
			mv.addObject("visitorInfo", visitorInfo);
		}
		
		mv.addObject("loginVO", loginVO);
		mv.setViewName("/neos/cmm/ex/visitor/pop/BSDuzonVisitorPopNew");
		
		return mv;
	}
	
	/**
	 * 방문객 등록(일반) - 고도화
	 * @param paramMap
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/cmm/ex/visitor/InsertVisitorNew.do")
	public ModelAndView InsertVisitorNew(@RequestParam Map<String, Object> paramMap , HttpServletRequest request) throws Exception{
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		
		paramMap.put("servletRequest", request);
		paramMap.put("req_comp_seq", loginVO.getCompSeq());
		paramMap.put("req_emp_seq", loginVO.getUniqId());
		paramMap.put("groupSeq", loginVO.getGroupSeq());
		
		String serverName = CommonUtil.getApiCallDomain(request);
		paramMap.put("serverName", serverName);
		
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		
		Map<String, Object> result = new HashMap<String, Object>();
		
		/* 전자결재 연동 X */
		/* 신규 등록 - 일반 */
		result = visitorManageService.InsertVisitorNew(paramMap);
		
		/* QR 발급여부 - Y */
		/* 정상적으로 방문객이 등록되었을 경우에만 전송 */
		if(result.get("resultCode").equals("SUCCESS") || result.get("resultCode").equals("ERR001")) {
			if(paramMap.get("qr_send_yn").toString().equals("Y")) {
				ArrayList rNoList = (ArrayList) result.get("r_no_list");
				for(int i=0; i<rNoList.size(); i++) {
					Map<String, Object> qrParam = new HashMap<String, Object>();
					qrParam.put("groupSeq", loginVO.getGroupSeq());
					qrParam.put("nR_NO", rNoList.get(i));
					Map<String, Object> qrResult = visitorManageService.sendMMSQrImage(qrParam);
					
					if(qrResult.get("resultCode").equals("Fail")) {
						//System.out.println(qr_result.get("resultMessage"));
					}
				}
			}
			
			/* 일정 등록 */
			/* 등록가능한 캘린더가 있는 경우에만 처리 */
			Map<String, Object> schResult = new HashMap<String, Object>();
			if(!paramMap.get("calCheck").equals("no")) {
				paramMap.put("visitor_detail_info", result.get("visitorInfoListStr"));
				schResult = visitorManageService.insertSchedule(paramMap);
				if(!schResult.get("resultCode").equals("SUCCESS")) {
					//System.out.println(schResult.get("resultMessage"));
				}
			}
		}
		
		mv.addObject("resultCode", result.get("resultCode"));
		mv.addObject("resultMessage", result.get("resultMessage"));
		return mv;
	}
	
	/**
	 * 방문객 삭제 - 고도화
	 * @param paramMap
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/cmm/ex/visitor/DeleteVisitorNew.do")
	public ModelAndView DeleteVisitorNew(@RequestParam Map<String, Object> paramMap , HttpServletRequest request) throws Exception{
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		ModelAndView mv = new ModelAndView();
		
		try {
			visitorManageService.DeleteVisitorNew(paramMap);
			mv.addObject("resultCode", "SUCCESS");
			mv.addObject("resultMessage", "방문객 삭제 성공");
		}
		catch(Exception e) {
			mv.addObject("resultCode", "FAIL");
			mv.addObject("resultMessage", e.getMessage());
			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
		}
		
		mv.setViewName("jsonView");
		return mv;
	}
	
	
	/**
	 * 방문객 상세조회 - 고도화
	 * @param paramMap
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/cmm/ex/visitor/getVisitorNew.do")
	public ModelAndView getVisitorNew(@RequestParam Map<String, Object> paramMap , HttpServletRequest request) throws Exception{
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();	
	
		paramMap.put("langCD", loginVO.getLangCode());
		
		Map<String, Object> result = visitorManageService.getVisitorNew(paramMap);
		
		ModelAndView mv = new ModelAndView();
		
		mv.addAllObjects(result);
		mv.setViewName("jsonView");
		return mv;
	}
	
	/**
	 * 방문객 정보 업데이트 
	 * @param paramMap
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/cmm/ex/visitor/UpdateVisitor.do")
	public ModelAndView UpdateVisitor(@RequestParam Map<String, Object> paramMap , HttpServletRequest request) throws Exception{
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		
		Map<String, Object> result = new HashMap<String, Object>();
		
		/* 전자결재 연동 X - 방문객 정보 업데이트 */
		result = visitorManageService.updateVisitor(paramMap);
		
		ModelAndView mv = new ModelAndView();

		mv.addAllObjects(result);
		mv.setViewName("jsonView");

		return mv;
	}
	
	
	
	/**
	 * 주차권 무료현황 페이지 호출
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/cmm/ex/visitor/BSDuzonVisitPticketList.do")
	public ModelAndView BSDuzonVisitPticketList(@RequestParam Map<String, Object> paramMap) throws Exception{
	
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		
		ModelAndView mv = new ModelAndView();
		
		Map<String, Object> params = new HashMap<String, Object>();
		
		params.put( "groupSeq", loginVO.getGroupSeq());
		params.put( "compSeq", loginVO.getOrganId());
		params.put( "empSeq", loginVO.getUniqId());
		params.put( "langCode", loginVO.getLangCode());
		
		
		/* 2020.10.14 관리자 권한인 경우에도 전체 회사 리스트 조회를 위해 userSe 세팅 */
		String userSe = loginVO.getUserSe();
		
		if(userSe.equals("ADMIN")) {
			userSe = "MASTER";
		}
		params.put( "userSe", userSe);
		
		/* 전자결재 form_id 가져오기 */
		String formId = visitorManageService.getEaDocFormId(paramMap);
		mv.addObject("formId",formId);
		
		List<Map<String, Object>> compList = null;
		if ( userSe != null ) {
			compList = compManageService.getCompListAuth( params );
		}
		mv.addObject( "compList", compList );
		JSONArray json = JSONArray.fromObject( compList );
		mv.addObject( "compListJson", json );
		
		mv.addObject("userSe", userSe);
		mv.addObject("loginVO",loginVO);
		
		mv.setViewName("/neos/cmm/ex/visitor/BSDuzonVisitPticketList");
		
		return mv;
	}
	
	/**
	 *입/퇴실체크(일반방문객)페이지 호출
	 * @param paramMap
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/cmm/ex/visitor/BSDuzonVisitCheckQr.do")
	public ModelAndView BSDuzonVisitCheckQr(@RequestParam Map<String, Object> paramMap , HttpServletRequest request) throws Exception{
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		
		ModelAndView mv = new ModelAndView();
		
		if(!menuManageService.checkMenuAuth(loginVO, request.getServletPath())) {
			mv.setViewName( "redirect:/forwardIndex.do" );
			return mv;
		}
		
		Map<String, Object> params = new HashMap<String, Object>();
		
		params.put( "groupSeq", loginVO.getGroupSeq());
		params.put( "compSeq", loginVO.getOrganId());
		params.put( "empSeq", loginVO.getUniqId());
		params.put( "langCode", loginVO.getLangCode());
		
		/* 2020.10.14 관리자 권한인 경우에도 전체 회사 리스트 조회를 위해 userSe 세팅 */
		String userSe = loginVO.getUserSe();
		
		if(userSe.equals("ADMIN")) {
			userSe = "MASTER";
		}
		params.put( "userSe", userSe);
		
		List<Map<String, Object>> compList = null;
		if ( userSe != null ) {
			compList = compManageService.getCompListAuth( params );
		}
		mv.addObject( "compList", compList );
		JSONArray json = JSONArray.fromObject( compList );
		mv.addObject( "compListJson", json );
		
		mv.addObject("userSe", userSe);
		mv.addObject("loginVO",loginVO);
		
		mv.setViewName("/neos/cmm/ex/visitor/BSDuzonVisitCheckQr");
		
		return mv;
	}
	
	/**
	 * 입/퇴실체크 팝업 호출
	 * @param paramMap
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/cmm/ex/visitor/visitCheckPopView.do")
	public ModelAndView visitCheckPopView(@RequestParam Map<String, Object> paramMap , HttpServletRequest request) throws Exception{
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		
		ModelAndView mv = new ModelAndView();
		
		paramMap.put("groupSeq", loginVO.getGroupSeq());
		paramMap.put("nRNo", paramMap.get("r_no"));
		paramMap.put("pDist", 1);
		
		Map<String, Object> visitorInfo = visitorManageService.getVisitorNew(paramMap);
		
		mv.addObject("paramMap",paramMap);
		mv.addObject("visitorInfo", visitorInfo);
		mv.addObject("loginVO", loginVO);
		
		mv.setViewName("/neos/cmm/ex/visitor/pop/BSDuzonVisitCheckPop");
		
		return mv;
	}
	
	/**
	 * 입/퇴실 처리 - 고도화
	 * @param paramMap
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/cmm/ex/visitor/CheckVisitorNew.do")
	public ModelAndView CheckVisitorNew(@RequestParam Map<String, Object> paramMap , HttpServletRequest request) throws Exception{
		
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();	
		paramMap.put("langCD", loginVO.getLangCode());
		ModelAndView mv = new ModelAndView();
		
		Map<String, Object> result = visitorManageService.CheckVisitorNew(paramMap);
		
		mv.addAllObjects(result);
		mv.setViewName("jsonView");
		return mv;
	}
	
	/**
	 * 표찰번호 체크
	 * @param paramMap
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/cmm/ex/visitor/CheckVisitCard.do")
	public ModelAndView CheckVisitCard(@RequestParam Map<String, Object> paramMap , HttpServletRequest request) throws Exception{
		
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();	
		paramMap.put("groupSeq", loginVO.getGroupSeq());
		ModelAndView mv = new ModelAndView();

		Map<String, Object> result = visitorManageService.CheckVisitCard(paramMap);
		
		mv.addAllObjects(result);
		mv.setViewName("jsonView");
		return mv;
	}
	
	
	/**
	 * QR코드 주차권/조회 페이지 호출
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/cmm/ex/visitor/BSDuzonVisitQRListView.do")
	public ModelAndView BSDuzonVisitQRCodeView(@RequestParam Map<String, Object> paramMap) throws Exception{
	
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		
		ModelAndView mv = new ModelAndView();
		
		mv.setViewName("/neos/cmm/ex/visitor/BSDuzonVisitQR");
		
		return mv;
	}
	
	
	@RequestMapping("/cmm/ex/visitor/SendMMSTest.do")
	public ModelAndView SendMMSTest(HttpServletRequest request, @RequestParam Map<String, Object> paramMap) throws Exception{
		
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("result", visitorManageService.sendMMSQrImage(paramMap));
		return mv;
	}
	
	/* QR코드 재전송 */
	@RequestMapping("/cmm/ex/visitor/ReSendMMS.do")
	public ModelAndView ReSendMMS(HttpServletRequest request, @RequestParam Map<String, Object> paramMap) throws Exception{
		
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		Map<String, Object> result = new HashMap<String, Object>();
		
		ModelAndView mv = new ModelAndView();
		
		paramMap.put("groupSeq", loginVO.getGroupSeq());
		paramMap.put("nR_NO", paramMap.get("r_no"));
		
		result = visitorManageService.sendMMSQrImage(paramMap);
			
		mv.setViewName("jsonView");
		mv.addObject("result", result);
		return mv;
		
	}	
	
	
	/**
	 * 방문객 등록 - 결재 연동 임시 테이블 저장
	 */
	@RequestMapping("/cmm/ex/visitor/InsertVisitorExt.do")
	public ModelAndView InsertVisitorExt(@RequestParam Map<String, Object> paramMap) throws Exception{
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		
		paramMap.put("req_emp_seq", loginVO.getUniqId());
		paramMap.put("req_comp_seq", loginVO.getCompSeq());
		
		Map<String,Object> result = visitorManageService.InsertVisitorExt(paramMap);
		ModelAndView mv = new ModelAndView();
		
		mv.addAllObjects(result);
		mv.setViewName("jsonView");
		
		return mv;
	}

	/**
	 * 전자결재 인터락 연동
	 * @param params
	 * @param servletRequest
	 * @return
	 */
    @RequestMapping( value = "/cmm/ex/visitor/eadocmake.do", method = {RequestMethod.GET, RequestMethod.POST } )
    @ResponseBody
    public APIResponse eaDocInterLockMake(@RequestBody EaDocInterlockVO eaDocInterlockVO, HttpServletRequest servletRequest) {
		APIResponse response = new APIResponse();

    	try {

    		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
    		
    		if (loginVO == null) {
    			response.setResultMessage("로그인 정보를 확인하세요."); // 결과 메시지(String)
    			response.setResultCode("FAIL");
    			return response;
    		}
    		
    		response.setResult(eaDocInterLockMake(eaDocInterlockVO, loginVO));
    		response.setResultMessage("성공하였습니다.");
    		response.setResultCode("SUCCESS");
    		return response;
    		
    	} catch(Exception e) {
    		
    		response.setResultMessage("에러가 발생하였습니다.");
    		response.setResultCode("FAIL");
    		response.setResult(e.getMessage());
    		return response;
			
    	}
    	
    }
    
    /**
	 * 전자결재-결재문서-결재연동(docId:전자결재 생성요청API)
	 * 
	 * @param request
	 * @return
	 * @throws APIException
	 */
    @RequestMapping( value = "/cmm/ex/visitor/updateEaAttDocId.do", method = {RequestMethod.GET, RequestMethod.POST } )
    @ResponseBody
	public APIResponse updateEaAttDocId (@RequestBody Map<String, Object> request, HttpServletRequest servletRequest ) throws APIException {

    	APIResponse response = new APIResponse();
    	
    	try {

    		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();

    		if (loginVO == null) {
    			response.setResultMessage("로그인 정보를 확인하세요."); // 결과 메시지(String)
    			response.setResultCode("FAIL");
    			return response;
    		}
    		
    		visitorManageService.UpdateDocId(request);
    		
    		response.setResult("결재연동(docId) 반영 성공");
    		response.setResultMessage("성공하였습니다.");
    		response.setResultCode("SUCCESS");
    		return response;
    		
    	} catch(Exception e) {
    		
    		response.setResultMessage("결재연동(docId)반영 수정 실패");
    		response.setResultCode("FAIL");
    		response.setResult(e.getMessage());
    		return response;
			
    	}
		
	}
    
    public Map<String, Object> eaDocInterLockMake(EaDocInterlockVO eaDocInterlockVO, LoginVO loginVO) throws Exception {
		/* 전자결재 연동 파리미터 정의 */
		String groupSeq = loginVO.getGroupSeq();
		String approkey = eaDocInterlockVO.getApproKey();
		
		JSONObject jsonBodyContent = new JSONObject();
		jsonBodyContent.put("form_id", eaDocInterlockVO.getFormId());
		jsonBodyContent.put("processId", eaDocInterlockVO.getProcessId());
		jsonBodyContent.put("approKey", eaDocInterlockVO.getApproKey());
		jsonBodyContent.put("doc_id", eaDocInterlockVO.getDocId());
		jsonBodyContent.put("docTitle", eaDocInterlockVO.getDocTitle());
		jsonBodyContent.put("docContent", eaDocInterlockVO.getDocContent());
		jsonBodyContent.put("interlockUrl", eaDocInterlockVO.getInterlockUrl());
		jsonBodyContent.put("interlockName", eaDocInterlockVO.getInterlockName());
		jsonBodyContent.put("interlockNameEn", eaDocInterlockVO.getInterlockNameEn());
		jsonBodyContent.put("interlockNameJp", eaDocInterlockVO.getInterlockNameJp());
		jsonBodyContent.put("interlockNameCn", eaDocInterlockVO.getInterlockNameCn());
		jsonBodyContent.put("tId", eaDocInterlockVO.gettId());
		jsonBodyContent.put("loginVo", loginVO);
		
		
		/* 전자결재 연동 파리미터 조합 */
		JSONObject jsonBody = new JSONObject();
		jsonBody.put("body", jsonBodyContent);
		
		/* 리턴 JSON 정의 */
		JSONObject jsonResult = new JSONObject();
		String apiUrl = eaDocInterlockVO.getOrigin() + "/" + eaDocInterlockVO.getEaType() + "/ea/interface/eadocmake.do";
//		String apiUrl = "http://bizboxa.duzonnext.com" + "/" + "eap" + "/ea/interface/eadocmake.do";
		jsonResult = JSONObject.fromObject( HttpJsonUtil.execute("POST", apiUrl, jsonBody));
		
		Map<String, Object> result = new HashMap<>();
		result.put("resultCode", String.valueOf(jsonResult.get("resultCode")));
		result.put("resultMessage", String.valueOf(jsonResult.get("resultMessage")));
		result.put("approKey", String.valueOf(((JSONObject) jsonResult.get( "result" )).get( "approKey" )));
		result.put("docId", String.valueOf(((JSONObject) jsonResult.get( "result" )).get( "docId" )));
		result.put("processId", String.valueOf(((JSONObject) jsonResult.get( "result" )).get( "processId" )));	
		
		return result;
	}
    
    /*
	 * 전자결재 외부API연동 공통(resultCode) SUCCESS : 성공하였습니다 UC0000 : 데이터가 존재하지 않습니다.
	 * UC0001 : 프로토콜 정보 조회를 실패 하였습니다. UC6000 : 허가되지 않은 접근입니다. 전달받는 파라메터 예시) {
	 * "erpCompSeq":"8888", "processId":"ATTProc18",
	 * "approKey":"ATTEND_EAP_2018050813095214", "compSeq":"1000",
	 * "docSts":"90", "deptSeq":"1100", "erpEmpSeq":"2006070101",
	 * "langCode":"kr", "groupSeq":"toovit_A", "empSeq":"3", "docTitle":
	 * "반차사용신청서_기술지원팀 최순미", "userId":"sjryu", "docId":"241", "userSe":"USER",
	 * "bizSeq":"1000" }
	 * 
	 */
	@RequestMapping(value = "/eaInterLock.do", method = { RequestMethod.GET, RequestMethod.POST })
	@ResponseBody
	public Map<String, Object> eaInterLock(HttpServletRequest servletRequest,
			@RequestBody Map<String, Object> request, @RequestParam Map<String, Object> params) throws Exception {
		//10 : 임시보관, 20 : 상신, 30 : 진행, 40 : 발신종결, 50 : 수신상신, 60 : 수신진행, 70 : 수신반려, 80 : 수신확인, 90 : 종결, 100 : 반려, 	110 : 보류
		
		// elet_appv_link_yn : 결재 연동 여부 -> 해당 API 사용 시 반드시 결재 연동 
		request.put("elet_appv_link_yn", "Y");
		request.put("servletRequest", servletRequest);
		
		Logger.getLogger( VisitorManageController.class ).debug( "request : " + request );
		
		Map<String, Object> result = new HashMap<String, Object>();
		String docStatus = ""; // 전자결재 진행 상태
	
		try {
			// 상신
			if(request.get("docSts").toString().equals("20"))
			{	
				request.put("docStatus", "진행");
				
				/* 보관 -> 상신 체크 */
				int useEaDocId = visitorManageService.getEaDocId(request);
				
				/* 보관되었던 문서 -> 재상신 */
				if(useEaDocId > 0) {
					visitorManageService.UpdateAppvDocSts(request);
					result.put("resultCode", "SUCCESS");
				}
				else {
					Map<String, Object> insertResult = visitorManageService.InsertVisitorNew(request);
					if(insertResult.get("resultCode").equals("SUCCESS")) {
						result.put("resultCode", "SUCCESS");
					}
					else {
						result.put("resultCode", "FAIL");
						result.put("resultMessage", "방문객 저장 중 오류 발생");
					}
				}
				
			}
			else {
				/* 상신취소-보관 */
				if(request.get("docSts").toString().equals("10")) {
					request.put("docStatus", "보관");
					visitorManageService.UpdateAppvDocSts(request);
					result.put("resultCode", "SUCCESS");
				}
				
				/* 진행 callback 전자결재 제공 X */
				else if(request.get("docSts").toString().equals("30")) {
					request.put("docStatus", "결재진행");
					visitorManageService.UpdateAppvDocSts(request);
					result.put("resultCode", "SUCCESS");
				}
				
				else if(request.get("docSts").toString().equals("90")) {
					request.put("docStatus", "종결");
					
					visitorManageService.UpdateAppvDocSts(request);

					/* 결재 종결 후 QR 발송 - qr전송여부에 따라서 전송 필요 */
					Map<String, Object> rNoListAndQrSendYn = visitorManageService.getRNoList(request);
					
					/* qr전송여부 - Y인 경우에만 qr 전송 */
					if(rNoListAndQrSendYn.get("qr_send_yn").toString().equals("Y")) {
						String rNoList = rNoListAndQrSendYn.get("r_no_list").toString();
						String[] rNoArr = rNoList.split(",");
						for(int i=0; i<rNoArr.length; i++) {
							Map<String, Object> qrParam = new HashMap<String, Object>();
							qrParam.put("groupSeq", request.get("groupSeq"));
							qrParam.put("nR_NO", Integer.parseInt(rNoArr[i]));
							Map<String, Object> qrResult = visitorManageService.sendMMSQrImage(qrParam);
						}
					}
					
					/* 무료 주차권 발급 로직 */
					Map<String, Object> tMapConnectResult = visitorManageService.tMapConnectSetting(rNoListAndQrSendYn);
					
					/* 모든 주차권 발급 성공 */
					if(tMapConnectResult.get("resultCode").equals("SUCCESS")) {
						Logger.getLogger( VisitorManageController.class ).debug( "T-map 연동 전체 성공");	
					}
					/* 주차권 발급 실패건이 있는 경우*/
					else {
						String failStr = "";
						
						List<Map<String, Object>> tmapFailList = (List<Map<String, Object>>) tMapConnectResult.get("failList");
						for(Map<String ,Object> obj : tmapFailList) {
							failStr += obj.get("rNo")+ "|"+ obj.get("status")+"|"+obj.get("message")+", ";
						}
						failStr = failStr.substring(0,failStr.length()-2);
						Logger.getLogger( VisitorManageController.class ).debug( "T-map 연동 (부분/전체) 실패: " + failStr );
					}
						
					/* 캘린더 존재 여부 검사 - 등록 */
					String serverName = CommonUtil.getApiCallDomain(servletRequest);
					String scheduleListUrl = serverName + "/schedule/MobileSchedule/SearchMyCalendarList";
					
					/* 캘린더 존재 여부 검사 */
					Map<String, Object> param = visitorManageService.getVisitorPopContent(request);
					param.put("serverName", serverName);
					param.put("groupSeq", request.get("groupSeq"));
					param.put("url", scheduleListUrl);
					param.put("elet_appv_link_yn","Y");
					param.put("approKey", request.get("approKey"));
					Map<String, Object> calListResult = visitorManageService.checkCalendar(param);
					
					/* 캘린더가 존재한다면 등록 진행 */
					Map<String, Object> schResult = new HashMap<String, Object>();
					if(!calListResult.get("resultCode").equals("no")) {
						param.put("mcalSeq", calListResult.get("mcalSeq"));
						if(calListResult.get("resultCode").equals("req")) {
							param.put("calCheck","req");
						}
						else if(calListResult.get("resultCode").equals("man")) {
							param.put("calCheck","man");
						}
						schResult = visitorManageService.insertSchedule(param);
					}
					
					if(schResult.get("resultCode") != null && schResult.get("resultCode").equals("FAIL")) {
						//System.out.println("일정 등록 중 오류 발생");
					}
					result.put("resultCode", "SUCCESS");
				}
				else if(request.get("docSts").toString().equals("100")) {
					request.put("docStatus", "반려");
					visitorManageService.UpdateAppvDocSts(request);
					result.put("resultCode", "SUCCESS");
				}
				
				else if(request.get("docSts").toString().equals("999")) {
					request.put("docStatus", "삭제");
					visitorManageService.UpdateAppvDocSts(request);
					
					/* 결재 삭제 시 테이블 데이터 삭제 */
					visitorManageService.DeleteVisitorByAppv(request);
					result.put("resultCode", "SUCCESS");
				}
				
				else if(request.get("docSts").toString().equals("110")) {
					request.put("docStatus", "보류");
					visitorManageService.UpdateAppvDocSts(request);
					result.put("resultCode", "SUCCESS");
				}
			}
		}
		catch(Exception e) {
			result.put("ResultCode", "FAIL");
			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
		}
		
		return result;
	}
	
    
    /**
	 * 엑셀 다운로드 - totalCount
	 * @param request
	 * @return
	 * @throws APIException
	 */
    @RequestMapping( value = "/cmm/ex/visitor/qrListTotalCount.do", method = {RequestMethod.GET, RequestMethod.POST } )
	public ModelAndView qrListTotalCount ( @RequestParam Map<String, Object> request, HttpServletRequest servletRequest ) throws APIException {

    	ModelAndView mv = new ModelAndView();
    	
    	try {

    		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();

    		request.put("langCD", loginVO.getLangCode());
    		request.put("empSeq", loginVO.getUniqId());
    		request.put("userSe", loginVO.getUserSe());
    		
    		Map<String,Object> result = visitorManageService.getQrListTotalCount(request);
    		
    		mv.addObject("totalCount", result.get("result"));
    		mv.addObject("resultCode", "SUCCESS");
    		
    	} catch(Exception e) {
    		
    		mv.addObject("result", "");
    		mv.addObject("resultCode", "FAIL");
    	}
    	
    	mv.setViewName("jsonView");
    	return mv;
		
	}
    
    /**
	 * 
	 * @param request
	 * @return
	 * @throws APIException
	 */
    @RequestMapping( value = "/cmm/ex/visitor/getEmpTelNum.do", method = {RequestMethod.GET, RequestMethod.POST } )
	public ModelAndView getEmpTelNum ( @RequestParam Map<String, Object> request, HttpServletRequest servletRequest ) throws APIException {

    	ModelAndView mv = new ModelAndView();
    	
    	try {

    		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();

    		request.put("groupSeq", loginVO.getGroupSeq());
    		
    		String result = visitorManageService.getEmpTelNum(request);
    		
    		mv.addObject("resultCode", "SUCCESS");
    		mv.addObject("result", result);
    		
    	} catch(Exception e) {
    		
    		mv.addObject("result", "");
    		mv.addObject("resultCode", "FAIL");
    	}
    	
    	mv.setViewName("jsonView");
    	return mv;
	}
    
    /**
	 * 
	 * @param request
	 * @return
	 * @throws APIException
	 */
    @RequestMapping( value = "/cmm/ex/visitor/checkCalendar.do", method = {RequestMethod.GET, RequestMethod.POST } )
	public ModelAndView checkCalendar ( @RequestParam Map<String, Object> paramMap, HttpServletRequest servletRequest ) throws APIException {

    	LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
    	
    	String serverName = CommonUtil.getApiCallDomain(servletRequest);
		String scheduleListUrl = serverName + "/schedule/MobileSchedule/SearchMyCalendarList";
		
    	ModelAndView mv = new ModelAndView();
    	
    	try {
    		
    		paramMap.put("groupSeq", loginVO.getGroupSeq());
			paramMap.put("url", scheduleListUrl);
    		
    		Map<String, Object> result = visitorManageService.checkCalendar(paramMap);
    		
    		mv.addAllObjects(result);
    		
    	} catch(Exception e) {
    		
    		mv.addObject("resultCode", "FAIL");
    	}
    	
    	mv.setViewName("jsonView");
    	return mv;
	}
    
    
    /**
	 * 
	 * @param request
	 * @return
	 * @throws APIException
	 */
    @RequestMapping( value = "/cmm/ex/visitor/checkVisitCarNo.do", method = {RequestMethod.GET, RequestMethod.POST } )
	public ModelAndView checkVisitCarNo ( @RequestParam Map<String, Object> paramMap, HttpServletRequest servletRequest ) throws APIException {

    	LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
    	
    	ModelAndView mv = new ModelAndView();
    	Map<String, Object> result = new HashMap<String, Object>();
    	
    	try {
    		paramMap.put("groupSeq", loginVO.getGroupSeq());
    		result = visitorManageService.checkVisitCarNo(paramMap);
    		
    	} catch(Exception e) {
    		result.put("resultCode", "FAIL");
			result.put("resultMessage", "주차권 발급 가능 여부 체크 중 오류 발생..");
			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
    	}
    	
    	mv.addAllObjects(result);
    	mv.setViewName("jsonView");
    	return mv;
	}
    
    /**
	 * t-map 주차권 목록 조회(개발팀 확인용)
	 * @param request
	 * @return
	 * @throws APIException
	 */
    @RequestMapping( value = "/cmm/ex/visitor/getTmapList.do", method = {RequestMethod.GET, RequestMethod.POST } )
	public ModelAndView getTmapList ( @RequestParam Map<String, Object> paramMap, HttpServletRequest servletRequest ) throws APIException {

    	LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
    	
    	ModelAndView mv = new ModelAndView();
    	Map<String, Object> result = new HashMap<String, Object>();
    	
    	try {
    		paramMap.put("groupSeq", loginVO.getGroupSeq());
    		result = visitorManageService.getTmapList(paramMap);
    		
    	} catch(Exception e) {
    		result.put("resultCode", "FAIL");
			result.put("resultMessage", "T-map 주차권 목록 조회 실패..");
			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
    	}
    	
    	mv.addAllObjects(result);
    	mv.setViewName("jsonView");
    	return mv;
	}
    
    
    /**
	 * QR 위치 인증 데이터 메뉴 호출(그룹사 전용)
	 * @param paramMap
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/cmm/ex/visitor/QrPlaceCertification.do")
	public ModelAndView QrPlaceCertification(@RequestParam Map<String, Object> paramMap , HttpServletRequest request) throws Exception{
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		
		ModelAndView mv = new ModelAndView();
		
		if(!menuManageService.checkMenuAuth(loginVO, request.getServletPath())) {
			mv.setViewName( "redirect:/forwardIndex.do" );
			return mv;
		}
		
		mv.setViewName("/neos/cmm/ex/visitor/QrPlaceCertification");
		
		return mv;
	}
	
	/**
	 * QR 위치 인증 데이터 조회
	 * @param request
	 * @return
	 * @throws APIException
	 */
    @RequestMapping( value = "/cmm/ex/visitor/getQrPlaceCertificationData.do", method = {RequestMethod.GET, RequestMethod.POST } )
	public ModelAndView getQrPlaceCertificationData ( @RequestParam Map<String, Object> paramMap, HttpServletRequest servletRequest ) throws APIException {

    	LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
    	
    	ModelAndView mv = new ModelAndView();
    	Map<String, Object> result = new HashMap<String, Object>();
    	List<Map<String, Object>> list = new ArrayList<Map<String, Object>>();
    	
    	try {
    		paramMap.put("groupSeq", loginVO.getGroupSeq());
    		list= visitorManageService.getQrPlaceCertificationData(paramMap);
    		
    		result.put("list", list);
    		result.put("count", list.size());
    		
    	} catch(Exception e) {
			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
    	}
    	
    	mv.addAllObjects(result);
    	mv.setViewName("jsonView");
    	return mv;
	}
}
