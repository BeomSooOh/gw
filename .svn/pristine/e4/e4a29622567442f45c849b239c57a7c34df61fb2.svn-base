package neos.cmm.systemx.partner.web;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import bizbox.orgchart.service.vo.LoginVO;
import egovframework.com.cmm.annotation.IncludedInfo;
import egovframework.com.cmm.util.EgovUserDetailsHelper;
import egovframework.com.utl.fcc.service.EgovStringUtil;
import egovframework.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;
import main.web.BizboxAMessage;
import neos.cmm.erp.batch.service.ErpPartnerService;
import neos.cmm.erp.constant.ErpConstant;
import neos.cmm.menu.service.MenuManageService;
import neos.cmm.systemx.partner.service.PartnerManageService;
import neos.cmm.util.BizboxAProperties;
import neos.cmm.util.CommonUtil;
import neos.cmm.util.MessageUtil;
import neos.cmm.util.code.service.CommonCodeService;
import net.sf.json.JSONArray;

@Controller
public class PartnerManageController {
	
	@Resource(name="PartnerManageService")
	public PartnerManageService partnerManageService;
	
	@Resource(name="CommonCodeService")
	CommonCodeService commonCodeService;
	
	@Resource(name="ErpPartnerService")
	ErpPartnerService erpPartnerSevice;
	
	@Resource(name="MenuManageService")
	private MenuManageService menuManageService;
	
	@IncludedInfo(name="거래처관리", order = 220 ,gid = 60)
	@RequestMapping("/systemx/partnerManageView.do")
    public ModelAndView partnerManageView(@RequestParam Map<String,Object> params, HttpServletRequest request) throws Exception {
		ModelAndView mv = new ModelAndView();
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		
		boolean isAuthMenu = menuManageService.checkIsAuthMenu(params, loginVO);
		if(!isAuthMenu){
			mv.setViewName("redirect:/forwardIndex.do");			
			return mv;
		}
		
		params.put("loginVO", loginVO);
		params.put("langCode", loginVO.getLangCode());
		params.put("achrGbn", "ac");
		
		if(loginVO.getUserSe().equals("MASTER")){
			params.put("compSeq", "");
		}else{
			params.put("compSeq", loginVO.getCompSeq());
		}
		
		List<Map<String,Object>> compList = partnerManageService.selectCompList(params);
		mv.addObject("compList", compList);			
		
		mv.setViewName("/neos/cmm/systemx/partner/partnerManageView");
		
		//params.put("redirectPage", "partnerManageView.do");
		
		//MessageUtil.getRedirectMessage(mv, request);
		
		//mv.addObject("isSyncAuto", ErpConstant.PARTNER_AUTO);
		
		mv.addObject("params", params);
		
		return mv; 
	}
	
	@RequestMapping("/systemx/partnerManageData.do")
    public ModelAndView partnerManageData(@RequestParam Map<String,Object> params) throws Exception {
		ModelAndView mv = new ModelAndView();
		
		PaginationInfo paginationInfo = new PaginationInfo();
		
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		
		params.put("groupSeq", loginVO.getGroupSeq());
		params.put("langCode", loginVO.getLangCode());
		
		if(!loginVO.getUserSe().equals("MASTER")){
			params.put("compSeq", loginVO.getCompSeq());	
		}
		
		paginationInfo.setCurrentPageNo(EgovStringUtil.zeroConvert(params.get("page")));
		paginationInfo.setPageSize(EgovStringUtil.zeroConvert(params.get("pageSize")));
		
		Map<String,Object> listMap = partnerManageService.selectPartnerList(params, paginationInfo);

		mv.addAllObjects(listMap);
		
		mv.setViewName("jsonView"); 
		
		return mv;
	}
	
	@IncludedInfo(name="거래처등록", order = 230 ,gid = 60)
	@RequestMapping("/systemx/partnerRegPop.do")
    public ModelAndView partnerRegPop(@RequestParam Map<String,Object> params, HttpServletRequest request) throws Exception {
		
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		
		params.put("groupSeq", loginVO.getGroupSeq());
		params.put("langCode", loginVO.getLangCode());
		
		ModelAndView mv = new ModelAndView();
		
		mv.setViewName("/neos/cmm/systemx/partner/pop/partnerRegPop");
		
		params.put("redirectPage", "partnerRegPop.do");
		
		String cdPartner = params.get("cdPartner")+"";
		
		if (!EgovStringUtil.isEmpty(cdPartner)) {
			Map<String,Object> info = partnerManageService.selectPartnerInfo(params);
			mv.addObject("info", info);
			
			List<Map<String,Object>> detailList = partnerManageService.selectPartnerDetailList(params);
			mv.addObject("detailList", detailList);
		}else{
			mv.addObject("info", params);
		}
		
		MessageUtil.getRedirectMessage(mv, request);
		
		mv.addObject("params", params);
		
		MessageUtil.getRedirectMessage(mv, request);
		
		//폐쇄망 사용유무 커스텀 프로퍼티에서 조회.
		//폐쇄망일 경우 우편번호검색(다음api) 사용불가.
		if(!BizboxAProperties.getCustomProperty("BizboxA.ClosedNetworkYn").equals("99")){
			if(BizboxAProperties.getCustomProperty("BizboxA.ClosedNetworkYn").equals("Y")){
				mv.addObject("ClosedNetworkYn", "Y");
			}
		}
		
		return mv; 
	}
	
	@RequestMapping("/systemx/partnerCdCheck.do")
	public ModelAndView partnerCdCheck(@RequestParam Map<String,Object> params) throws Exception {
		ModelAndView mv = new ModelAndView();
		
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		
		params.put("groupSeq", loginVO.getGroupSeq());
		params.put("langCode", loginVO.getLangCode());
		
		/** 그룹웨어에 저장된 cd_partner 확인 */
		Map<String,Object> info = partnerManageService.selectPartnerInfo(params);
		
		int r = 0;
		
		if (info != null && info.size() > 0) {
			r = 1;
		}
		
		/** IU cd partner 확인 로직 추가 해야됨. */
		mv.addObject("result", r);
		
		mv.setViewName("jsonView"); 
		
		return mv;
	}
	
	@RequestMapping("/systemx/partnerSaveProc.do")
	public ModelAndView partnerSaveProc(HttpServletRequest request, @RequestParam Map<String,Object> params, RedirectAttributes ra) throws Exception {
		
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		
		params.put("groupSeq", loginVO.getGroupSeq());
		ModelAndView mv = new ModelAndView();
		
		/** 필수 데이터 셋팅 */
		if(EgovStringUtil.isEmpty(params.get("cdCompany")+"")) {
			params.put("cdCompany", loginVO.getCompSeq());
		}
		if(EgovStringUtil.isEmpty(params.get("compSeq")+"")) {
			params.put("compSeq", loginVO.getCompSeq());
		}
		if(EgovStringUtil.isEmpty(params.get("svType")+"")) {
			params.put("svType", "GW");
		}
		
		params.put("editSeq", loginVO.getUniqId());
		params.put("empSeq", loginVO.getUniqId());

		/** 번호 관련 조합 */
		String[] noCompany = request.getParameterValues("noCompany");
		if (noCompany != null && noCompany.length > 0) {
			params.put("noCompany", CommonUtil.getStrNumberDelimiter(noCompany, "-"));
		}
		String[] noTel1 = request.getParameterValues("noTel1");
		if (noTel1 != null && noTel1.length > 0) {
			params.put("noTel1", CommonUtil.getStrNumberDelimiter(noTel1, "-"));
		}
		String[] noFax1 = request.getParameterValues("noFax1");
		if (noFax1 != null && noFax1.length > 0) {
			params.put("noFax1", CommonUtil.getStrNumberDelimiter(noFax1, "-"));
		}
		String[] noPost1 = request.getParameterValues("noPost1");
		if (noPost1 != null && noPost1.length > 0) {
			params.put("noPost1", CommonUtil.getStrNumberDelimiter(noPost1, "-"));
		}
		
		String cdPartner = params.get("cdPartner")+"";
		if(!EgovStringUtil.isEmpty(cdPartner)) {
			partnerManageService.deletePartnerDetail(params);
		}
		
		/** 담당자 리스트 정보 가져오기 */
		String[] nmPtrList = request.getParameterValues("nmPtr");
		String[] noFaxList = request.getParameterValues("noFax");
		String[] eMailList = request.getParameterValues("eMail");
		String[] noTelList = request.getParameterValues("noTel");
		String[] noHpList = request.getParameterValues("noHp");
		
		boolean bool = false;
		
		try{
			partnerManageService.insertPartnerMain(params);
			
			for(int i = 0; i < nmPtrList.length; i++) {
				
				params.put("noSeq", i);
				params.put("nmPtr", nmPtrList[i]);
				params.put("noFax", noFaxList[i]);
				params.put("eMail", eMailList[i]);
				params.put("noTel", noTelList[i]);
				params.put("noHp", noHpList[i]);
				
				partnerManageService.insertPartnerDetail(params);
			}
			
			bool = true;

		} catch(Exception e) {
			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
		}

		MessageUtil.setRedirectMessage(request, ra, bool?"success.common.insert":"fail.common.insert");
		if(bool) {
			ra.addFlashAttribute("msg", BizboxAMessage.getMessage("TX000019391","정상적으로 저장 되었습니다."));
		}
		else {
			ra.addFlashAttribute("msg", BizboxAMessage.getMessage("TX000002299","저장에 실패하였습니다."));
		}
		
		mv.setViewName("redirect:partnerRegPop.do?procTp=S&cdPartner="+params.get("cdPartner")+"&compSeq="+params.get("compSeq"));
		
		return mv; 
	}
	
	@RequestMapping("/systemx/partnerSaveProcAPI.do")
	public ModelAndView partnerSaveProcAPI(HttpServletRequest request, @RequestParam Map<String, Object> params, HttpServletResponse response) throws Exception {
		
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		
		params.put("groupSeq", loginVO.getGroupSeq());
		ModelAndView mv = new ModelAndView();
		
		/** 필수 데이터 셋팅 */
		if(EgovStringUtil.isEmpty(params.get("cdCompany")+"")) {
			params.put("cdCompany", loginVO.getCompSeq());
		}
		if(EgovStringUtil.isEmpty(params.get("compSeq")+"")) {
			params.put("compSeq", loginVO.getCompSeq());
		}
		if(EgovStringUtil.isEmpty(params.get("svType")+"")) {
			params.put("svType", "GW");
		}
		
		params.put("editSeq", loginVO.getUniqId());
		params.put("empSeq", loginVO.getUniqId());

		/** 번호 관련 조합 */
		String[] noCompany = request.getParameterValues("noCompany");
		if (noCompany != null && noCompany.length > 0) {
			params.put("noCompany", CommonUtil.getStrNumberDelimiter(noCompany, "-"));
		}
		String[] noTel1 = request.getParameterValues("noTel1");
		if (noTel1 != null && noTel1.length > 0) {
			params.put("noTel1", CommonUtil.getStrNumberDelimiter(noTel1, "-"));
		}
		String[] noFax1 = request.getParameterValues("noFax1");
		if (noFax1 != null && noFax1.length > 0) {
			params.put("noFax1", CommonUtil.getStrNumberDelimiter(noFax1, "-"));
		}
		String[] noPost1 = request.getParameterValues("noPost1");
		if (noPost1 != null && noPost1.length > 0) {
			params.put("noPost1", CommonUtil.getStrNumberDelimiter(noPost1, "-"));
		}
		
		String cdPartner = params.get("cdPartner")+"";
		if(!EgovStringUtil.isEmpty(cdPartner)) {
			partnerManageService.deletePartnerDetail(params);
		}
		
		/** 담당자 리스트 정보 가져오기 */
		String[] nmPtrList = request.getParameterValues("nmPtr");
		String[] noFaxList = request.getParameterValues("noFax");
		String[] eMailList = request.getParameterValues("eMail");
		String[] noTelList = request.getParameterValues("noTel");
		String[] noHpList = request.getParameterValues("noHp");
		
		boolean bool = false;
		
		try{
			partnerManageService.insertPartnerMain(params);
			
			for(int i = 0; i < nmPtrList.length; i++) {
				
				params.put("noSeq", i);
				params.put("nmPtr", nmPtrList[i]);
				params.put("noFax", noFaxList[i]);
				params.put("eMail", eMailList[i]);
				params.put("noTel", noTelList[i]);
				params.put("noHp", noHpList[i]);
				
				partnerManageService.insertPartnerDetail(params);
			}
			
			bool = true;

		} catch(Exception e) {
			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
		}
		
		mv.setViewName("jsonView");
		
		if(bool){
			mv.addObject("apiResult", "Y");
		}else{
			mv.addObject("apiResult", "N");
		}
		
		return mv; 
	}
	
	@RequestMapping("/systemx/partnerDelProc.do")
	public ModelAndView partnerDelProc(@RequestParam Map<String,Object> params) throws Exception {
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		
		params.put("groupSeq", loginVO.getGroupSeq());
		ModelAndView mv = new ModelAndView();
		
		try{
			// 트랜잭션 걸어야 함..
			partnerManageService.deletePartnerInfo(params);
			mv.addObject("result", "1");
		} catch(Exception e) {
			mv.addObject("result", "0");
		}
		
		mv.setViewName("jsonView");

		return mv;
	}
	
	@IncludedInfo(name="거래처리스트팝업", order = 240 ,gid = 60)
	@RequestMapping("/systemx/partnerListPop.do")
	public ModelAndView partnerListPop(@RequestParam Map<String,Object> params, HttpServletRequest request) throws Exception {
		ModelAndView mv = new ModelAndView();
		
		mv.setViewName("/neos/cmm/systemx/partner/pop/partnerListPop");
		
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		
		if(!loginVO.getUserSe().equals("MASTER")){
			params.put("compSeq", loginVO.getCompSeq());
		}
		
		mv.addObject("params", params);
		
		return mv; 
	}
	
	@RequestMapping("/systemx/partnerSyncPop.do")
    public ModelAndView partnerSyncPop(@RequestParam Map<String,Object> params, HttpServletRequest request) throws Exception {
		ModelAndView mv = new ModelAndView();
		
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		
		mv.addObject("cycleCount", commonCodeService.getCommonDetailCodeFlag1("ERP010", "201", "FLAG_1"));
		
		mv.addObject("isSyncAuto", commonCodeService.getCommonDetailCodeFlag1("ERP010", "205", "FLAG_1"));
		
		mv.setViewName("/neos/cmm/systemx/partner/pop/partnerSyncPop");
		
		MessageUtil.getRedirectMessage(mv, request);
		
		return mv; 
	}
	
	@RequestMapping("/systemx/partnerSyncSetProc.do")
	public ModelAndView partnerSyncSetProc(@RequestParam Map<String,Object> params, HttpServletRequest request, RedirectAttributes ra) throws Exception {
		ModelAndView mv = new ModelAndView();
		
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		
		commonCodeService.updateCommonDetail("ERP010", "201", params.get("cycleCount")+"", null, loginVO.getUniqId());
		commonCodeService.updateCommonDetail("ERP010", "205", params.get("isSyncAuto")+"", null, loginVO.getUniqId());
		
		ErpConstant.PARTNER_AUTO = params.get("isSyncAuto")+"";
		ErpConstant.PARTNER_SET_COUNT = CommonUtil.getIntNvl(params.get("cycleCount")+"");
		
		mv.setViewName("redirect:partnerSyncPop.do");
		 
		MessageUtil.setRedirectMessage(request, ra, "success.common.update");
		
		return mv; 
	}
	
	@RequestMapping("/systemx/partnerRestoreProc.do")
	public ModelAndView partnerRestoreProc(@RequestParam Map<String,Object> params) throws Exception {
		ModelAndView mv = new ModelAndView();
		
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		
		params.put("groupSeq", loginVO.getGroupSeq());
		params.put("editSeq", loginVO.getUniqId());
		
		/** 그룹웨어에 저장된 cd_partner 확인. ERP삭제된 프로젝트를 그룹웨어로 복원하기. 완료후 ERP로 연결 불가. */
		params.put("flagDelete", "r");	// d -> r 변경
		params.put("svType", "GW");		// ERP -> GW 변경
		partnerManageService.updatePartnerRestore(params);
		
		mv.addObject("result", "1");
		
		mv.setViewName("jsonView"); 
		
		return mv;
	}
	
	@RequestMapping("/systemx/partnerSyncProc.do")
	public ModelAndView partnerSyncProc(@RequestParam Map<String,Object> params) throws Exception {
		ModelAndView mv = new ModelAndView();
		
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		
		params.put("groupSeq", loginVO.getGroupSeq());
		params.put("editSeq", loginVO.getUniqId());
		
		if (!ErpConstant.PARTNER_SYNC_RUN) {
			erpPartnerSevice.syncPartnerFromErp();
			mv.addObject("result", "1");
		} else {
			mv.addObject("result", "-1");
		}
		
		mv.setViewName("jsonView"); 
		
		return mv;
	}
	

	@RequestMapping("/systemx/partnerPmListPop.do")
	public ModelAndView partnerPmListPop(@RequestParam Map<String,Object> params, HttpServletRequest request, RedirectAttributes ra) throws Exception {
		ModelAndView mv = new ModelAndView();
		
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		
		PaginationInfo paginationInfo = new PaginationInfo();
		
		params.put("groupSeq", loginVO.getGroupSeq());
		params.put("compSeq", loginVO.getCompSeq());
				
		params.put("langCode", loginVO.getLangCode());
		
		int page = EgovStringUtil.zeroConvert(params.get("page"));
		int pageSize = EgovStringUtil.zeroConvert(params.get("pageSize"));
		if (page == 0) {
			page = 1;
		}
		if (pageSize == 0) {
			pageSize = 10;
		}
		
		paginationInfo.setCurrentPageNo(page);
		paginationInfo.setPageSize(pageSize);
		paginationInfo.setRecordCountPerPage(10); 
		
		Map<String,Object> pmListMap = partnerManageService.selectPartnerDetailList(params, paginationInfo);
		
		Map<String,Object> partnerInfo = partnerManageService.selectPartnerInfo(params);
		mv.addObject("partnerInfo", partnerInfo);

		@SuppressWarnings("unused")
		List<Map<String,Object>> list = (List<Map<String,Object>>)pmListMap.get("list");
		
		mv.addObject("pmList", list);
		mv.addObject("pmListJson", JSONArray.fromObject(list));
		
		mv.addObject("params", params);
		mv.addObject("paginationInfo", paginationInfo);
		
		mv.setViewName("/neos/cmm/systemx/partner/pop/partnerPmListPop");
		
		return mv; 
	}
}
