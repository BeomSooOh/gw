package neos.cmm.systemx.project.web;

import java.net.URLEncoder;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import api.common.service.EventService;
import bizbox.orgchart.service.vo.LoginVO;
import egovframework.com.cmm.annotation.IncludedInfo;
import egovframework.com.cmm.util.EgovUserDetailsHelper;
import egovframework.com.utl.fcc.service.EgovStringUtil;
import egovframework.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;
import neos.cmm.erp.batch.service.ErpProjectService;
import neos.cmm.erp.constant.ErpConstant;
import neos.cmm.menu.service.MenuManageService;
import neos.cmm.systemx.emp.service.EmpManageService;
import neos.cmm.systemx.file.WebAttachFileUtil;
import neos.cmm.systemx.orgchart.service.OrgChartService;
import neos.cmm.systemx.project.service.ProjectManageService;
import neos.cmm.util.CommonUtil;
import neos.cmm.util.HttpJsonUtil;
import neos.cmm.util.MessageUtil;
import neos.cmm.util.code.service.CommonCodeService;
import net.sf.json.JSONObject;
import net.sf.json.JSONSerializer;

@Controller
public class ProjectManageController {
	
	@Resource(name="ProjectManageService")
	ProjectManageService projectManageService;
	
	@Resource(name="OrgChartService")
	OrgChartService orgChartService;
	
	@Resource(name="ErpProjectService")
	ErpProjectService erpProjectSevice;
	
	@Resource(name="CommonCodeService")
	CommonCodeService commonCodeService;
	
	@Resource(name="EmpManageService")
	EmpManageService empManageService;
	
	@Resource(name="EventService")
	EventService eventService;
	
	@Resource(name="MenuManageService")
	private MenuManageService menuManageService;
	
	//private org.apache.logging.log4j.Logger LOG = LogManager.getLogger("ProjectManageController");

	@IncludedInfo(name="프로젝트관리", order = 210 ,gid = 60)
	@RequestMapping("/systemx/projectManageView.do")
    public ModelAndView projectManageView(@RequestParam Map<String,Object> params, HttpServletRequest request) throws Exception {
		ModelAndView mv = new ModelAndView();
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		
		if(params.get("isRedirect") == null){
			boolean isAuthMenu = menuManageService.checkIsAuthMenu(params, loginVO);
			if(!isAuthMenu){
				mv.setViewName("redirect:/forwardIndex.do");			
				return mv;
			}			
		}
		
		mv.setViewName("/neos/cmm/systemx/project/projectManageView");
		
		params.put("redirectPage", "projectManageView.do");
		
		MessageUtil.getRedirectMessage(mv, request);
		
		mv.addObject("isSyncAuto", ErpConstant.PROJECT_AUTO);
		
		mv.addObject("params", params);
		
		return mv; 
	}
	
	@RequestMapping("/systemx/projectManageData.do")
    public ModelAndView projectManageData(@RequestParam Map<String,Object> params) throws Exception {
		ModelAndView mv = new ModelAndView();
		
		PaginationInfo paginationInfo = new PaginationInfo();
		
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		
		params.put("groupSeq", loginVO.getGroupSeq());
		
		params.put("compSeq", loginVO.getCompSeq());
				
		params.put("langCode", loginVO.getLangCode());
		
		paginationInfo.setCurrentPageNo(EgovStringUtil.zeroConvert(params.get("page")));
		paginationInfo.setPageSize(EgovStringUtil.zeroConvert(params.get("pageSize")));
		
		Map<String,Object> listMap = projectManageService.selectProjectList(params, paginationInfo);

		mv.addAllObjects(listMap);
		
		mv.setViewName("jsonView"); 
		
		return mv;
	}
	
	@IncludedInfo(name="프로젝트등록", order = 211 ,gid = 60)
	@RequestMapping("/systemx/projectRegView.do")
    public ModelAndView projectRegView(@RequestParam Map<String,Object> params, HttpServletRequest request) throws Exception {
		ModelAndView mv = new ModelAndView();
		
		mv.setViewName("/neos/cmm/systemx/project/projectRegView");
		
		params.put("redirectPage", "projectRegView.do");
		
		mv.addObject("check", 0);
		mv.addObject("params", params);
		
		MessageUtil.getRedirectMessage(mv, request);
		
		return mv; 
	}
	
	@RequestMapping("/systemx/projectModifyView.do")
    public ModelAndView projectModifyView(@RequestParam Map<String,Object> params, HttpServletRequest request) throws Exception {
		
		ModelAndView mv = new ModelAndView();
		
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		
		params.put("langCode", loginVO.getLangCode());
		params.put("groupSeq", loginVO.getGroupSeq());
		
		Map<String,Object> projectInfo = projectManageService.selectProjectInfo(params);
		
		mv.addObject("projectInfo", projectInfo);
		
		
		params.put("redirectPage", "projectModifyView.do");
		
		mv.addObject("params", params);
		mv.addObject("check", 1);
		MessageUtil.getRedirectMessage(mv, request);
		
		mv.setViewName("/neos/cmm/systemx/project/projectRegView");
		return mv; 
	}
	
	
	@RequestMapping("/systemx/projectInfoView.do")
    public ModelAndView projectInfoView(@RequestParam Map<String,Object> params, HttpServletRequest request) throws Exception {
		ModelAndView mv = new ModelAndView();
		
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		
		params.put("langCode", loginVO.getLangCode());
		params.put("groupSeq", loginVO.getGroupSeq());
		
		Map<String,Object> projectInfo = projectManageService.selectProjectInfo(params);
		
		mv.addObject("groupSeq", loginVO.getGroupSeq());
		mv.addObject("projectInfo", projectInfo);
		mv.addObject("params", params);
		
		params.put("redirectPage", "projectInfoView.do");
		
		MessageUtil.getRedirectMessage(mv, request);
		
		mv.setViewName("/neos/cmm/systemx/project/projectInfoView");
		
		return mv; 
	}
	//크로스사이트 요청 위조
	@RequestMapping(value="/systemx/projectSaveProc.do", method=RequestMethod.POST)
	public ModelAndView projectSaveProc(MultipartHttpServletRequest multiRequest, @RequestParam Map<String,Object> params, HttpServletRequest request) throws Exception {
		
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		
		ModelAndView mv = new ModelAndView();
		
		if(EgovStringUtil.isEmpty(params.get("noSeq")+"")) {
			params.put("noSeq", "1");  // IU측에서 1로 설정
		}
		if(EgovStringUtil.isEmpty(params.get("cdCompany")+"")) {
			params.put("cdCompany", loginVO.getCompSeq());
		}
		if(EgovStringUtil.isEmpty(params.get("compSeq")+"")) {
			params.put("compSeq", loginVO.getCompSeq());
		}
		if(EgovStringUtil.isEmpty(params.get("svType")+"")) {
			params.put("svType", "GW");
		}
		
		params.put("groupSeq", loginVO.getGroupSeq());
		
		
		Map<String,Object> projectInfo = projectManageService.selectProjectInfo(params);
		String oldPmSeq = null;
		String roomId = null;
		if (projectInfo != null) {
			oldPmSeq = projectInfo.get("pmSeq")+"";
			roomId = projectInfo.get("roomId")+"";
		}

		params.put("editSeq", loginVO.getUniqId());
		params.put("empSeq", loginVO.getUniqId());

		if (!multiRequest.getFileMap().isEmpty()) {
			try{
				/** 첨부파일  등록 */
				params.put("pathSeq", "400");
				params.put("relativePath", "/project");
				ModelAndView fileMv = WebAttachFileUtil.attachFileUpload(mv, multiRequest, params);

				String fileId = fileMv.getModelMap().get("fileId")+"";

				if(EgovStringUtil.isEmpty(fileId)) {
					fileId = params.get("fileId")+"";
				}

				params.put("idAttach", fileId);
			} catch(Exception e) {
				CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
			}
		}
		
		boolean bool = false;
		try{

			projectManageService.insertProjectMain(params);
			projectManageService.insertProjectDetail(params);
			bool = true;
			
			/** 프로젝트 등록시 대화방 연동 */
			String noProject = params.get("noProject")+"";
			if (!EgovStringUtil.isEmpty(noProject)) {
				
				params.put("roomType", "4");
				
				// uri 셋팅
				params.put("groupSeq", loginVO.getGroupSeq());
				Map<String,Object> groupMap = orgChartService.getGroupInfo(params);
				String uri = groupMap.get("messengerUrl")+"/messenger/Mobile/InsertRoom";
				
				params.put("uri", uri);
				
				String pmSeq = params.get("pmSeq")+"";
				
				
				params.put("compSeq", params.get("pmCompSeq")+"");
				params.put("mainDeptYn", "Y");
				params.put("langCode", loginVO.getLangCode());
				params.put("workStatus", "999");

				try {
					Map<String,Object> userInfo = empManageService.selectEmpInfo(params);
					if (userInfo != null) {
						String positionName = userInfo.get("deptPositionCodeName")+"";
						if (EgovStringUtil.isEmpty(positionName)) {
							positionName = userInfo.get("positionCodeName")+"";
						}

						params.put("positionName", positionName);

					}
				} catch (Exception e) {
					CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
				}
				
				/** 신규 프로젝트 대화방 생성 */
				if (EgovStringUtil.isEmpty(oldPmSeq)&& !EgovStringUtil.isEmpty(pmSeq)) {
					
					projectManageService.projectRoomCreate(params);
				
				} 
				/** 기존 프로젝트 대화방에 참여자 변경 */
				else if(!EgovStringUtil.isEmpty(oldPmSeq) && !EgovStringUtil.isEmpty(pmSeq) 
						&& !EgovStringUtil.isEmpty(roomId) && !oldPmSeq.equals(pmSeq)) {
					
					params.put("roomId", roomId);
					
					// 신규 pm 대화방 초대하기
					params.put("uri", groupMap.get("messengerUrl")+"/messenger/Mobile/RoomIn");
					
					JSONObject result = projectManageService.projectRoomIn(params);
					
					// 기존 pm 대화방 나가기
					if (result != null) {
						params.put("uri", groupMap.get("messengerUrl")+"/messenger/Mobile/RoomOut");
						projectManageService.projectRoomOut(params);
						
					}
					
				}
			}

		} catch(Exception e) {
			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
		}
		
		if (bool) {
			mv.setViewName("redirect:projectInfoView.do?noProject=" + URLEncoder.encode((String)params.get("noProject"),"UTF-8"));
		} else {
			mv = projectRegView(params, multiRequest);
			mv.addObject("projectInfo", params);
		}
		
		return mv; 
	}
	
	@RequestMapping("/systemx/projectNoCheck.do")
	public ModelAndView projectNoCheck(@RequestParam Map<String,Object> params) throws Exception {
		ModelAndView mv = new ModelAndView();
		
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		
		params.put("groupSeq", loginVO.getGroupSeq());
		params.put("langCode", loginVO.getLangCode());
		
		/** 그룹웨어에 저장된 no_project 확인 */
		Map<String,Object> info = projectManageService.selectProjectInfo(params);
		
		int r = 0;
		
		if (info != null && info.size() > 0) {
			r = 1;
		}
		
		/** IU no project 확인 로직 추가 해야됨. */
		mv.addObject("result", r);
		
		mv.setViewName("jsonView"); 
		
		return mv;
	}
	
	@RequestMapping("/systemx/projectRestoreProc.do")
	public ModelAndView projectRestoreProc(@RequestParam Map<String,Object> params) throws Exception {
		ModelAndView mv = new ModelAndView();
		
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		
		params.put("groupSeq", loginVO.getGroupSeq());
		params.put("editSeq", loginVO.getUniqId());
		
		/** 그룹웨어에 저장된 no_project 확인. ERP삭제된 프로젝트를 그룹웨어로 복원하기. 완료후 ERP로 연결 불가. */
		params.put("flagDelete", "r");	// d -> r 변경
		params.put("svType", "GW");		// ERP -> GW 변경
		projectManageService.updateProjectRestore(params);
		
		mv.addObject("result", "1");
		
		mv.setViewName("jsonView"); 
		
		return mv;
	}
	
	@RequestMapping("/systemx/projectSyncProc.do")
	public ModelAndView projectSyncProc(@RequestParam Map<String,Object> params) throws Exception {
		ModelAndView mv = new ModelAndView();
		
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		
		params.put("groupSeq", loginVO.getGroupSeq());
		params.put("editSeq", loginVO.getUniqId());
		
		if (!ErpConstant.PROJECT_SYNC_RUN) {
			erpProjectSevice.syncProjectFromErp();
			mv.addObject("result", "1");
		} else {
			mv.addObject("result", "-1");
		}
		
		mv.setViewName("jsonView"); 
		
		return mv;
	}
	
	@SuppressWarnings("static-access")
	@RequestMapping("/systemx/projectDelProc.do")
	public ModelAndView projectDelProc(@RequestParam Map<String,Object> params, HttpServletRequest request, RedirectAttributes ra) throws Exception {

		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		params.put("groupSeq", loginVO.getGroupSeq());
		
		ModelAndView mv = new ModelAndView();

		/** 프로젝트 관리 리스트에서 다중 체크로 넘어온경우.. */
		String[] noProject = request.getParameterValues("chkNoProject");		// list 에서 다중 체크해서 삭제하는 경우
		if (noProject != null && noProject.length > 0) {
			StringBuffer sb = new StringBuffer();
			for(int i = 0; i < noProject.length; i++) {
				sb.append("'"+noProject[i]+"'");
				if (i < noProject.length-1) {
					sb.append(",");
				}
			}
			params.put("noProjectList", sb.toString());
		}
		
		
		//삭제되는 프로젝트 구성원 프로젝트 대화방 나가기
		List<Map<String, Object>>  roomIdList = projectManageService.getRoomIdList(params);
		// 기존 pm 대화방 나가기
		if (roomIdList != null) {
			Map<String,Object> groupMap = orgChartService.getGroupInfo(params);
			params.put("uri", groupMap.get("messengerUrl")+"/messenger/Mobile/ProjectRoomOut");
			projectManageService.projectUserRoomOut(params, roomIdList);
		}
		
		int r = 0;

		try{
			// 트랜잭션 걸어야 함..
			projectManageService.deleteProjectInfo(params);
			r = 1;
		} catch(Exception e) {
			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
		}

		String result = null;
		if (r > 0) {
			mv.addObject("menu_no", "905030000");
			mv.setViewName("redirect:projectManageView.do"+"?"+CommonUtil.makeHttpParameter(params));
			result = "success.common.delete";
		} else {
			mv.setViewName("redirect:"+params.get("redirectPage")+"?"+CommonUtil.makeHttpParameter(params));
			result = "fail.common.delete";
		}
		
		// 프로젝트 삭제 시 프로젝트 게시판 삭제
		try {
			String serverName = request.getServerName();
			
			String apiUrl = request.getScheme() + "://" + serverName + "/" + "edms/doc/deleteProjDo.do";
			//String apiUrl = "http://bizboxa.duzonnext.com/edms/doc/projDirAddDo.do";
			
			//String apiUrl = "http://bizboxa.duzonnext.com/edms/doc/projDirAddDo.do";
			for(int i=0; i<noProject.length; i++) {
				String jsonParam =	  "{\"header\":{";
				jsonParam +=	    "\"groupSeq\":\"" + loginVO.getGroupSeq() + "\",";
				jsonParam +=	    "\"empSeq\":\"" + loginVO.getUniqId() + "\",";
				jsonParam +=	    "\"tId\":\"P001\",";
				jsonParam +=	    "\"pId\":\"P01\"},";
				jsonParam +=	  "\"body\":{";
				jsonParam +=	    "\"companyInfo\" :{";
				jsonParam +=	      "\"compSeq\":\"" + loginVO.getCompSeq() + "\",";
				jsonParam +=	      "\"bizSeq\":\"" + loginVO.getBizSeq() + "\",";
				jsonParam +=	      "\"deptSeq\":\"" + loginVO.getOrgnztId() + "\",";
				jsonParam +=	      "\"emailAddr\":\"" + loginVO.getEmail() + "\",";
				jsonParam +=	      "\"emailDomain\":\"" + loginVO.getEmailDomain() + "\"},";
				jsonParam +=	    "\"langCode\" : \"" + loginVO.getLangCode() + "\",";
				jsonParam +=	    "\"serverReq\":\"W\",";
				jsonParam +=	    "\"project_id\":\"" + noProject[i] + "\"}}";
				
				
				JSONObject jsonObject2 = JSONObject.fromObject(JSONSerializer.toJSON(jsonParam));
				HttpJsonUtil httpJson = new HttpJsonUtil();
				httpJson.execute("POST", apiUrl, jsonObject2);
				jsonParam = "";
			}
					
		} catch(Exception e) {
			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
		}
		
		MessageUtil.setRedirectMessage(request, ra, result);

		return mv;
	}
	
	
	@RequestMapping("/systemx/projectSyncPop.do")
    public ModelAndView projectSyncPop(@RequestParam Map<String,Object> params, HttpServletRequest request) throws Exception {
		ModelAndView mv = new ModelAndView();
		
		mv.addObject("cycleCount", commonCodeService.getCommonDetailCodeFlag1("ERP010", "101", "FLAG_1"));
		
		mv.addObject("isSyncAuto", commonCodeService.getCommonDetailCodeFlag1("ERP010", "105", "FLAG_1"));
		
		mv.setViewName("/neos/cmm/systemx/project/pop/projectSyncPop");
		
		MessageUtil.getRedirectMessage(mv, request);
		
		return mv; 
	}
	
	@RequestMapping("/systemx/projectSyncSetProc.do")
	public ModelAndView projectSyncSetProc(@RequestParam Map<String,Object> params, HttpServletRequest request, RedirectAttributes ra) throws Exception {
		ModelAndView mv = new ModelAndView();
		
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		
		commonCodeService.updateCommonDetail("ERP010", "101", params.get("cycleCount")+"", null, loginVO.getUniqId());
		commonCodeService.updateCommonDetail("ERP010", "105", params.get("isSyncAuto")+"", null, loginVO.getUniqId());
		
		ErpConstant.PROJECT_AUTO = params.get("isSyncAuto")+"";
		ErpConstant.PROJECT_SET_COUNT = CommonUtil.getIntNvl(params.get("cycleCount")+"");
		
		mv.setViewName("redirect:projectSyncPop.do");
		 
		MessageUtil.setRedirectMessage(request, ra, "success.common.update");
		
		return mv; 
	}
	
	@RequestMapping("/systemx/prjectPop.do")
	public ModelAndView projectSelect(@RequestParam Map<String, Object> params, HttpServletResponse response) throws Exception {
		ModelAndView mv = new ModelAndView();
		LoginVO v = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser();
		
		if (params.get("langCode") == null) {
			params.put("langCode", v.getLangCode());
		}
		if (EgovStringUtil.isEmpty(params.get("langCode").toString())) {
			params.put("langCode", v.getLangCode());
		}

		if (params.get("groupSeq") == null) {
			params.put("groupSeq", v.getGroupSeq());
		}
		if (EgovStringUtil.isEmpty(params.get("groupSeq").toString())) {
			params.put("groupSeq", v.getGroupSeq());
		}

		if (params.get("compSeq") == null) {
			params.put("compSeq", v.getCompSeq());
		}
		if (EgovStringUtil.isEmpty(params.get("compSeq").toString())) {
			params.put("compSeq", v.getCompSeq());
		}
		
		if (params.get("selectedItems") == null) {
			params.put("selectedItems", "");
		}
		if (EgovStringUtil.isEmpty(params.get("selectedItems").toString())) {
			params.put("selectedItems", "");
		}
		
		if (params.get("empSeq") == null) {
			params.put("empSeq", v.getUniqId());
		}
		if (EgovStringUtil.isEmpty(params.get("empSeq").toString())) {
			params.put("empSeq", v.getUniqId());
		}
		
		if (params.get("callback") == null) {
			params.put("callback", "");
		}
		if (EgovStringUtil.isEmpty(params.get("callback").toString())) {
			params.put("callback", "");
		}
		
		if (params.get("callbackUrl") == null) {
			params.put("callbackUrl", "");
		}
		if (EgovStringUtil.isEmpty(params.get("callbackUrl").toString())) {
			params.put("callbackUrl", "");
		}
		
		mv.addObject("params", params);
		mv.setViewName("/neos/cmm/systemx/project/pop/projectBucketPop");
		
		return mv;
	}
	
	@IncludedInfo(name = "프로젝트 공통팝업(항목관리)", order = 352, gid = 60)
	@RequestMapping("/systemx/prjectPopTest.do")
	public ModelAndView prjectPopTest(@RequestParam Map<String, Object> params, HttpServletResponse response)
			throws Exception {
		ModelAndView mv = new ModelAndView();
		mv.addObject("params", params);
		mv.setViewName("/neos/cmm/systemx/project/pop/projectBucketPopTestPage");
		return mv;
	}
	
	@RequestMapping("/systemx/projectData.do")
	public ModelAndView projectData(@RequestParam Map<String, Object> params, HttpServletResponse response) 
			throws Exception {
		ModelAndView mv = new ModelAndView();
		Map<String, Object> result = new HashMap<String,Object>();
		
		PaginationInfo paginationInfo = new PaginationInfo();
		
		paginationInfo.setCurrentPageNo(EgovStringUtil.zeroConvert(params.get("page")));
		paginationInfo.setPageSize(EgovStringUtil.zeroConvert(params.get("pageSize")));
		
		result = projectManageService.projectData(params, paginationInfo);
		result.put("currentPage", params.get("page"));
		mv.addObject("result", result);
		mv.setViewName("jsonView");
		return mv;
	}
}
