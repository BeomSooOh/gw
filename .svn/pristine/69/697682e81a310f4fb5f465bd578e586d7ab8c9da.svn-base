package neos.cmm.systemx.item.web;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import bizbox.orgchart.service.vo.LoginVO;
import egovframework.com.cmm.annotation.IncludedInfo;
import egovframework.com.cmm.util.EgovUserDetailsHelper;
import egovframework.com.utl.fcc.service.EgovStringUtil;
import neos.cmm.systemx.item.service.ItemManageService;
import neos.cmm.util.CommonUtil;

@Controller
public class ItemManageController {

	/* 변수 정의 서비스 */
	@Resource(name = "ItemMangeService")
	private ItemManageService itemManageService;

	/* 로그 설정 */
	Logger LOG = LogManager.getLogger(this.getClass());

	/* View */
	/* View - 마스터 > 시스템설정 > 항목관리 > 항목설정 */
	@RequestMapping("/cmm/systemx/item/ItemSettingView.do")
	public ModelAndView ItemSettingView() throws Exception {
		LOG.debug("+ [ItemManage] INFO - @Controller >> /cmm/systemx/item/ItemSettingView.do");
		ModelAndView mv = new ModelAndView();
		mv.setViewName("/neos/cmm/systemx/item/itemSettingView");

		LOG.debug("- [ItemManage] INFO - @Controller >> /cmm/systemx/item/ItemSettingView.do");
		return mv;
	}

	/* View - 마스터 > 시스템설정 > 항목관리 > 사용자정의 코드관리 */
	@RequestMapping("/cmm/systemx/item/ItemUserDefineCodeMangeView.do")
	public ModelAndView ItemUserDefineCodeMangeView() throws Exception {
		LOG.debug("+ [ItemManage] INFO - @Controller >> /cmm/systemx/item/ItemUserDefineCodeMangeView.do");
		ModelAndView mv = new ModelAndView();
		mv.setViewName("/neos/cmm/systemx/item/itemUserDefineCodeMangeView");

		LOG.debug("- [ItemManage] INFO - @Controller >> /cmm/systemx/item/ItemUserDefineCodeMangeView.do");
		return mv;
	}
	
	/* View - 마스터 > 시스템설정 > 항목관리 > 사용자정의 코드관리 */
	@RequestMapping("/cmm/systemx/item/ItemExternalCodeManageView.do")
	public ModelAndView ItemExternalCodeManageView() throws Exception {
		LOG.debug("+ [ItemManage] INFO - @Controller >> /cmm/systemx/item/ItemExternalCodeManageView.do");
		ModelAndView mv = new ModelAndView();
		mv.setViewName("/neos/cmm/systemx/item/itemExternalCodeManageView");

		LOG.debug("- [ItemManage] INFO - @Controller >> /cmm/systemx/item/ItemExternalCodeManageView.do");
		return mv;
	}

	/* View(팝업) - 코드 유형 및 기본 값 선택 팝업 */
	@RequestMapping("/cmm/systemx/item/pop/ItemPopCodeTypeSelectView.do")
	public ModelAndView ItemPopCodeTypeSelectView() throws Exception {
		LOG.debug("+ [ItemManage] INFO - @Controller >> /cmm/systemx/item/pop/ItemPopCodeTypeSelectView.do");
		ModelAndView mv = new ModelAndView();
		
		mv.setViewName("/neos/cmm/systemx/item/pop/popCodeTypeSelectView");

		LOG.debug("- [ItemManage] INFO - @Controller >> /cmm/systemx/item/pop/ItemPopCodeTypeSelectView.do");
		return mv;
	}
	
	/* View(팝업) - 외부코드 선택 선택 팝업 */
	@RequestMapping("/cmm/systemx/item/pop/ItemPopExternalTypeSelectView.do")
	public ModelAndView ItemPopExternalTypeSelectView() throws Exception {
		LOG.debug("+ [ItemManage] INFO - @Controller >> /cmm/systemx/item/pop/ItemPopExternalTypeSelectView.do");
		ModelAndView mv = new ModelAndView();
		
		mv.setViewName("/neos/cmm/systemx/item/pop/popExternalTypeSelectView");

		LOG.debug("- [ItemManage] INFO - @Controller >> /cmm/systemx/item/pop/ItemPopExternalTypeSelectView.do");
		return mv;
	}
	
	/* View(팝업) - 그룹 코드 등록 팝업 */
	@RequestMapping("/cmm/systemx/item/pop/ItemPopGroupCodeRegView.do")
	public ModelAndView ItemPopGroupCodeRegView(@RequestParam Map<String, Object> params, HttpServletRequest request) throws Exception {
		LOG.debug("+ [ItemManage] INFO - @Controller >> /cmm/systemx/item/pop/ItemPopGroupCodeRegView.do");
		ModelAndView mv = new ModelAndView();
		
		Map<String, Object> codeDetailInfo = itemManageService.getCodeGrpInfo(params);
		mv.addObject("codeDetailInfo", codeDetailInfo);
		
		
		mv.setViewName("/neos/cmm/systemx/item/pop/popCodeGroupRegView");

		LOG.debug("- [ItemManage] INFO - @Controller >> /cmm/systemx/item/pop/ItemPopGroupCodeRegView.do");
		return mv;
	}	
	
	/* View(팝업) - 그룹 코드 등록 팝업 */
	@RequestMapping("/cmm/systemx/item/pop/ItemPopAlertView.do")
	public ModelAndView ItemPopAlertView(@RequestParam Map<String, Object> params) throws Exception {
		LOG.debug("+ [ItemManage] INFO - @Controller >> /cmm/systemx/item/pop/ItemPopAlertView.do");
		ModelAndView mv = new ModelAndView();
		
		
		
		mv.addObject("result", params.get("resultMessage").toString());
		mv.setViewName("/neos/cmm/systemx/item/pop/popAlert");

		LOG.debug("- [ItemManage] INFO - @Controller >> /cmm/systemx/item/pop/ItemPopAlertView.do");
		return mv;
	}	

	/* 조회 */
	/* 조회 - 항목목록 */
	@RequestMapping("/cmm/systemx/item/ItemListSelect.do")
	public ModelAndView ItemListSelect(@RequestParam Map<String, Object> params, HttpServletRequest request) throws Exception {
		LOG.debug("+ [ItemManage] INFO - @Controller >> /cmm/systemx/item/ItemListSelect.do");
		ModelAndView mv = new ModelAndView();
		
		try {
			/* 변수정의 */
			LoginVO loginVO = (LoginVO) EgovUserDetailsHelper
					.getAuthenticatedUser();
			List<Map<String, Object>> result = new ArrayList<Map<String, Object>>();
			
			/* 초기값 정의 */
			
			/* 서비스 호출 */
			result = itemManageService.ItemListSelect(loginVO, params);
			/* 반환처리 */
			mv.setViewName("jsonView");
			mv.addObject("result", result);
			
		}catch(Exception e) {
//			StringWriter sw = new StringWriter();
//			e.printStackTrace(new PrintWriter(sw));
//			String exceptionAsStrting = sw.toString();
			LOG.error("! [AMAUTH] ERROR - " + e);
			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
			throw e;
		}
		mv.setViewName("jsonView");

		LOG.debug("- [ItemManage] INFO - @Controller >> /cmm/systemx/item/ItemListSelect.do");
		return mv;
	}
	
	/* 조회 - 항목목록 세부사항 */
	@RequestMapping("/cmm/systemx/item/ItemCodeDetailSelect.do")
	public ModelAndView ItemCodeDetailSelect(@RequestParam Map<String, Object> params, HttpServletRequest request) throws Exception {
		LOG.debug("+ [ItemManage] INFO - @Controller >> /cmm/systemx/item/ItemCodeDetailSelect.do");
		ModelAndView mv = new ModelAndView();
		Map<String, Object> result = new HashMap<String, Object>();
		try {
			/* 변수정의 */
			LoginVO loginVO = (LoginVO) EgovUserDetailsHelper
					.getAuthenticatedUser();
			
			
			/* 초기값 정의 */
			
			/* 서비스 호출 */
			result = itemManageService.ItemCodeDetailSelect(loginVO, params);
			/* 반환처리 */
			mv.setViewName("jsonView");
			mv.addObject("result", result);
			
		}catch(Exception e) {
//			StringWriter sw = new StringWriter();
//			e.printStackTrace(new PrintWriter(sw));
//			String exceptionAsStrting = sw.toString();
			LOG.error("! [AMAUTH] ERROR - " + e);
			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
			throw e;
		}
		mv.setViewName("jsonView");
		mv.addObject("result", result);

		LOG.debug("- [ItemManage] INFO - @Controller >> /cmm/systemx/item/ItemCodeDetailSelect.do");
		return mv;
	}

	
	/* 조회 - 사용자정의 코드관리 조회 */
	@RequestMapping("/cmm/systemx/item/ItemUserDefineCodeListSelect.do")
	public ModelAndView ItemUserDefineCodeListSelect(@RequestParam Map<String, Object> params, HttpServletRequest request) throws Exception {
		LOG.debug("+ [ItemManage] INFO - @Controller >> /cmm/systemx/item/ItemUserDefineCodeListSelect.do");
		ModelAndView mv = new ModelAndView();
		
		try {
			/* 변수정의 */
			LoginVO loginVO = (LoginVO) EgovUserDetailsHelper
					.getAuthenticatedUser();
			List<Map<String, Object>> result = new ArrayList<Map<String, Object>>();
			
			/* 초기값 정의 */
			
			/* 서비스 호출 */
			result = itemManageService.ItemUserDefineCodeListSelect(loginVO, params);
			/* 반환처리 */
			mv.setViewName("jsonView");
			mv.addObject("result", result);
			
		}catch(Exception e) {
//			StringWriter sw = new StringWriter();
//			e.printStackTrace(new PrintWriter(sw));
//			String exceptionAsStrting = sw.toString();
			LOG.error("! [ItemManage] ERROR - " + e);
			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
			throw e;
		}
		mv.setViewName("jsonView");

		LOG.debug("- [ItemManage] INFO - @Controller >> /cmm/systemx/item/ItemUserDefineCodeListSelect.do");
		return mv;
	}
	
	/* 조회 - 외부코드 목록 조회 */
	@RequestMapping("/cmm/systemx/item/ItemExternalCodeListSelect.do")
	public ModelAndView ItemExternalCodeListSelect(@RequestParam Map<String, Object> params, HttpServletRequest request) throws Exception {
		LOG.debug("+ [ItemManage] INFO - @Controller >> /cmm/systemx/item/ItemExternalCodeListSelect.do");
		ModelAndView mv = new ModelAndView();
		
		try {
			/* 변수정의 */
			LoginVO loginVO = (LoginVO) EgovUserDetailsHelper
					.getAuthenticatedUser();
			List<Map<String, Object>> result = new ArrayList<Map<String, Object>>();
			
			/* 초기값 정의 */
			params.put("langCode", loginVO.getLangCode());
			
			/* 서비스 호출 */
			result = itemManageService.ItemExternalCodeListSelect(loginVO, params);
			/* 반환처리 */
			mv.setViewName("jsonView");
			mv.addObject("result", result);
			
		}catch(Exception e) {
//			StringWriter sw = new StringWriter();
//			e.printStackTrace(new PrintWriter(sw));
//			String exceptionAsStrting = sw.toString();
			LOG.error("! [ItemManage] ERROR - " + e);
			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
			throw e;
		}
		mv.setViewName("jsonView");

		LOG.debug("- [ItemManage] INFO - @Controller >> /cmm/systemx/item/ItemExternalCodeListSelect.do");
		return mv;
	}

	/* 조회 - 그룹코드 상세코드 목록 조회 */
	@RequestMapping("/cmm/systemx/item/ItemCodeGroupDetailCodeSelect.do")
	public ModelAndView ItemCodeGroupDetailCodeSelect(@RequestParam Map<String, Object> params, HttpServletRequest request) throws Exception {
		LOG.debug("+ [ItemManage] INFO - @Controller >> /cmm/systemx/item/ItemCodeGroupDetailCodeSelect.do");
		ModelAndView mv = new ModelAndView();
		List<Map<String, Object>> result = new ArrayList<Map<String, Object>>();
		try {
			/* 변수정의 */
			LoginVO loginVO = (LoginVO) EgovUserDetailsHelper
					.getAuthenticatedUser();
			
			
			/* 초기값 정의 */
			
			/* 서비스 호출 */
			result = itemManageService.ItemCodeGroupDetailCodeSelect(loginVO, params);
			
		}catch(Exception e) {
//			StringWriter sw = new StringWriter();
//			e.printStackTrace(new PrintWriter(sw));
//			String exceptionAsStrting = sw.toString();
			LOG.error("! [ItemManage] ERROR - " + e);
			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
			throw e;
		}
		mv.setViewName("jsonView");
		mv.addObject("result", result);

		LOG.debug("- [ItemManage] INFO - @Controller >> /cmm/systemx/item/ItemCodeGroupDetailCodeSelect.do");
		return mv;
	}
	
	/* 조회 - 상세코드 데이터 조회 */
	@RequestMapping("/cmm/systemx/item/ItemDetailCodeSelect.do")
	public ModelAndView ItemDetailCodeSelect(@RequestParam Map<String, Object> params, HttpServletRequest request) throws Exception {
		LOG.debug("+ [ItemManage] INFO - @Controller >> /cmm/systemx/item/ItemDetailCodeSelect.do");
		ModelAndView mv = new ModelAndView();
		Map<String, Object> result = new HashMap<String, Object>();
		try {
			/* 변수정의 */
			LoginVO loginVO = (LoginVO) EgovUserDetailsHelper
					.getAuthenticatedUser();
			
			
			/* 초기값 정의 */
			
			/* 서비스 호출 */
			result = itemManageService.ItemDetailCodeSelect(loginVO, params);
			
		}catch(Exception e) {
//			StringWriter sw = new StringWriter();
//			e.printStackTrace(new PrintWriter(sw));
//			String exceptionAsStrting = sw.toString();
			LOG.error("! [ItemManage] ERROR - " + e);
			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
			throw e;
		}
		mv.setViewName("jsonView");
		mv.addObject("result", result);

		LOG.debug("- [ItemManage] INFO - @Controller >> /cmm/systemx/item/ItemDetailCodeSelect.do");
		return mv;
	}
	
	/* 조회 - 외부코드 상세 데이터 조회 */
	@RequestMapping("/cmm/systemx/item/ItemExternalCodeDetailSelect.do")
	public ModelAndView ItemExternalCodeDetailSelect(@RequestParam Map<String, Object> params, HttpServletRequest request) throws Exception {
		LOG.debug("+ [ItemManage] INFO - @Controller >> /cmm/systemx/item/ItemExternalCodeDetailSelect.do");
		ModelAndView mv = new ModelAndView();
		Map<String, Object> result = new HashMap<String, Object>();
		try {
			/* 변수정의 */
			LoginVO loginVO = (LoginVO) EgovUserDetailsHelper
					.getAuthenticatedUser();
			
			
			/* 초기값 정의 */
			params.put("langCode", loginVO.getLangCode());
			
			/* 서비스 호출 */
			result = itemManageService.ItemExternalCodeDetailSelect(loginVO, params);
			
		}catch(Exception e) {
//			StringWriter sw = new StringWriter();
//			e.printStackTrace(new PrintWriter(sw));
//			String exceptionAsStrting = sw.toString();
			LOG.error("! [ItemManage] ERROR - " + e);
			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
			throw e;
		}
		mv.setViewName("jsonView");
		mv.addObject("result", result);

		LOG.debug("- [ItemManage] INFO - @Controller >> /cmm/systemx/item/ItemDetailCodeSelect.do");
		return mv;
	}
	
	/* 조회 - 코드 중복 확인*/
	@RequestMapping("/cmm/systemx/item/checkItemCodeSeq.do")
	public ModelAndView checkItemCodeSeq(@RequestParam Map<String,Object> params, HttpServletRequest request) throws Exception {
		LOG.debug("+ [ItemManage] INFO - @Controller >> /cmm/systemx/item/checkItemCodeSeq.do");
		ModelAndView mv = new ModelAndView();
		Map<String, Object> result = new HashMap<String, Object>();

		/* 변수정의 */
		LoginVO loginVO = (LoginVO) EgovUserDetailsHelper
				.getAuthenticatedUser();
		
		
		/* 초기값 정의 */
		
		/* 서비스 호출 */
		result = itemManageService.checkItemCodeSeq(loginVO, params);
		
		if(result == null) {
			mv.addObject("result", "1");
		}
		else {
			mv.addObject("result", "0");
		}
		
		mv.setViewName("jsonView");
		LOG.debug("- [ItemManage] INFO - @Controller >> /cmm/systemx/item/checkItemCodeSeq.do");
		
		return mv;
	}
	
	/* 조회 - 상세코드 중복 확인*/
	@RequestMapping("/cmm/systemx/item/checkDetailCodeSeq.do")
	public ModelAndView checkDetailCodeSeq(@RequestParam Map<String,Object> params, HttpServletRequest request) throws Exception {
		LOG.debug("+ [ItemManage] INFO - @Controller >> /cmm/systemx/item/checkDetailCodeSeq.do");
		ModelAndView mv = new ModelAndView();
		Map<String, Object> result = new HashMap<String, Object>();

		/* 변수정의 */
		LoginVO loginVO = (LoginVO) EgovUserDetailsHelper
				.getAuthenticatedUser();
		
		
		/* 초기값 정의 */
		
		/* 서비스 호출 */
		result = itemManageService.checkDetailCodeSeq(loginVO, params);
		
		if(result == null) {
			mv.addObject("result", "1");
		}
		else {
			mv.addObject("result", "0");
		}
		
		mv.setViewName("jsonView");
		LOG.debug("- [ItemManage] INFO - @Controller >> /cmm/systemx/item/checkDetailCodeSeq.do");
		
		return mv;
	}
	
	/* 조회 - 외부코드 중복 확인*/
	@RequestMapping("/cmm/systemx/item/checkExternalCodeSeq.do")
	public ModelAndView checkExternalCodeSeq(@RequestParam Map<String,Object> params, HttpServletRequest request) throws Exception {
		LOG.debug("+ [ItemManage] INFO - @Controller >> /cmm/systemx/item/checkExternalCodeSeq.do");
		ModelAndView mv = new ModelAndView();
		Map<String, Object> result = new HashMap<String, Object>();

		/* 변수정의 */
		LoginVO loginVO = (LoginVO) EgovUserDetailsHelper
				.getAuthenticatedUser();
		
		
		/* 초기값 정의 */
		
		/* 서비스 호출 */
		result = itemManageService.checkExternalCodeSeq(loginVO, params);
		
		if(result == null) {
			mv.addObject("result", "1");
		}
		else {
			mv.addObject("result", "0");
		}
		
		mv.setViewName("jsonView");
		LOG.debug("- [ItemManage] INFO - @Controller >> /cmm/systemx/item/checkExternalCodeSeq.do");
		
		return mv;
	}
	
	/* 조회 - 크룹코드 중복 확인*/
	@RequestMapping("/cmm/systemx/item/checkGroupCodeSeq.do")
	public ModelAndView checkGroupCodeSeq(@RequestParam Map<String,Object> params, HttpServletRequest request) throws Exception {
		LOG.debug("+ [ItemManage] INFO - @Controller >> /cmm/systemx/item/checkGroupCodeSeq.do");
		ModelAndView mv = new ModelAndView();
		Map<String, Object> result = new HashMap<String, Object>();

		/* 변수정의 */
		LoginVO loginVO = (LoginVO) EgovUserDetailsHelper
				.getAuthenticatedUser();
		
		
		/* 초기값 정의 */
		
		/* 서비스 호출 */
		result = itemManageService.checkGroupCodeSeq(loginVO, params);
		
		if(result == null) {
			mv.addObject("result", "1");
		}
		else {
			mv.addObject("result", "0");
		}
		
		mv.setViewName("jsonView");
		LOG.debug("- [ItemManage] INFO - @Controller >> /cmm/systemx/item/checkGroupCodeSeq.do");
		
		return mv;
	}
	

	/* 생성 */
	/* 생성 - 항목 생성 */
	@RequestMapping("/cmm/systemx/item/ItemCodeInsert.do")
	public ModelAndView ItemCodeInsert(@RequestParam Map<String, Object> params, HttpServletRequest request) throws Exception {
		LOG.debug("+ [ItemManage] INFO - @Controller >> /cmm/systemx/item/ItemCodeInsert.do");
		
		ModelAndView mv = new ModelAndView();
		
		try {
			/* 변수정의 */
			LoginVO loginVO = (LoginVO) EgovUserDetailsHelper
					.getAuthenticatedUser();
			Map<String, Object> result = new HashMap<String, Object>();

			result = itemManageService.ItemCodeInsert(loginVO, params);
			mv.addObject(result);
			
		}catch(Exception e) {
//			StringWriter sw = new StringWriter();
//			e.printStackTrace(new PrintWriter(sw));
//			String exceptionAsStrting = sw.toString();
			LOG.error("! [AMAUTH] ERROR - " + e);
			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
			throw e;
		}

		mv.setViewName("jsonView");
		
		LOG.debug("- [ItemManage] INFO - @Controller >> /cmm/systemx/item/ItemCodeInsert.do");
		return mv;
	}
	
	/* 생성 - 코드 그룹 생성 */
	@RequestMapping("/cmm/systemx/item/ItemCodeGroupInsert.do")
	public ModelAndView ItemCodeGroupInsert(@RequestParam Map<String, Object> params, HttpServletRequest request) throws Exception {
		LOG.debug("+ [ItemManage] INFO - @Controller >> /cmm/systemx/item/ItemCodeGroupInsert.do");
		
		ModelAndView mv = new ModelAndView();
		Map<String, Object> result = new HashMap<String, Object>();
		
		try {
			/* 변수정의 */
			LoginVO loginVO = (LoginVO) EgovUserDetailsHelper
					.getAuthenticatedUser();
			
			result = itemManageService.ItemCodeGroupInsert(loginVO, params);
		}catch(Exception e) {
//			StringWriter sw = new StringWriter();
//			e.printStackTrace(new PrintWriter(sw));
//			String exceptionAsStrting = sw.toString();
			LOG.error("! [AMAUTH] ERROR - " + e);
			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
			throw e;
		}
		
		mv.setViewName("jsonView");
		mv.addObject(result);

		LOG.debug("- [ItemManage] INFO - @Controller >> /cmm/systemx/item/ItemCodeGroupInsert.do");
		return mv;
	}
	
	/* 생성 - 그룹코드 상세코드 생성 */
	@RequestMapping("/cmm/systemx/item/ItemCodeGroupDetailCodeInsert.do")
	public ModelAndView ItemCodeGroupDetailCodeInsert(@RequestParam Map<String, Object> params, HttpServletRequest request) throws Exception {
		LOG.debug("+ [ItemManage] INFO - @Controller >> /cmm/systemx/item/ItemCodeGroupDetailCodeInsert.do");
		
		ModelAndView mv = new ModelAndView();
		Map<String, Object> result = new HashMap<String, Object>();
		
		try {
			/* 변수정의 */
			LoginVO loginVO = (LoginVO) EgovUserDetailsHelper
					.getAuthenticatedUser();
			
			result = itemManageService.ItemCodeGroupDetailCodeInsert(loginVO, params);
		}catch(Exception e) {
//			StringWriter sw = new StringWriter();
//			e.printStackTrace(new PrintWriter(sw));
//			String exceptionAsStrting = sw.toString();
			LOG.error("! [AMAUTH] ERROR - " + e);
			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
			throw e;
		}
		
		mv.setViewName("jsonView");
		mv.addObject(result);

		LOG.debug("- [ItemManage] INFO - @Controller >> /cmm/systemx/item/ItemCodeGroupDetailCodeInsert.do");
		return mv;
	}	
	
	/* 생성 - 외부코드 생성 */
	@RequestMapping("/cmm/systemx/item/ItemExternalCodeInsert.do")
	public ModelAndView ItemExternalCodeInsert(@RequestParam Map<String, Object> params, HttpServletRequest request) throws Exception {
		LOG.debug("+ [ItemManage] INFO - @Controller >> /cmm/systemx/item/ItemExternalCodeInsert.do");
		
		ModelAndView mv = new ModelAndView();
		Map<String, Object> result = new HashMap<String, Object>();
		
		try {
			/* 변수정의 */
			LoginVO loginVO = (LoginVO) EgovUserDetailsHelper
					.getAuthenticatedUser();
			
			result = itemManageService.ItemExternalCodeInsert(loginVO, params);
		}catch(Exception e) {
//			StringWriter sw = new StringWriter();
//			e.printStackTrace(new PrintWriter(sw));
//			String exceptionAsStrting = sw.toString();
			LOG.error("! [AMAUTH] ERROR - " + e);
			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
			throw e;
		}
		
		mv.setViewName("jsonView");
		mv.addObject(result);

		LOG.debug("- [ItemManage] INFO - @Controller >> /cmm/systemx/item/ItemExternalCodeInsert.do");
		return mv;
	}
	
	
	/* 수정 */
	/* 수정 - 항목 수정 */
	@RequestMapping("/cmm/systemx/item/ItemCodeUpdate.do")
	public ModelAndView ItemCodeUpdate(@RequestParam Map<String, Object> params, HttpServletRequest request) throws Exception {
		LOG.debug("+ [ItemManage] INFO - @Controller >> /cmm/systemx/item/ItemCodeUpdate.do");
		
		ModelAndView mv = new ModelAndView();
		Map<String, Object> result = new HashMap<String, Object>();
		
		try {
			/* 변수정의 */
			LoginVO loginVO = (LoginVO) EgovUserDetailsHelper
					.getAuthenticatedUser();
			
			result = itemManageService.ItemCodeUpdate(loginVO, params);
		}catch(Exception e) {
//			StringWriter sw = new StringWriter();
//			e.printStackTrace(new PrintWriter(sw));
//			String exceptionAsStrting = sw.toString();
			LOG.error("! [AMAUTH] ERROR - " + e);
			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
			throw e;
		}
		
		mv.setViewName("jsonView");
		mv.addObject(result);

		LOG.debug("- [ItemManage] INFO - @Controller >> /cmm/systemx/item/ItemCodeUpdate.do");
		return mv;
	}
	
	/* 수정 - 상세 코드 수정 */
	@RequestMapping("/cmm/systemx/item/ItemCodeGroupDetailCodeEdit.do")
	public ModelAndView ItemCodeGroupDetailCodeEdit(@RequestParam Map<String, Object> params, HttpServletRequest request) throws Exception {
		LOG.debug("+ [ItemManage] INFO - @Controller >> /cmm/systemx/item/ItemCodeGroupDetailCodeEdit.do");
		
		ModelAndView mv = new ModelAndView();
		Map<String, Object> result = new HashMap<String, Object>();
		
		try {
			/* 변수정의 */
			LoginVO loginVO = (LoginVO) EgovUserDetailsHelper
					.getAuthenticatedUser();
			
			result = itemManageService.ItemCodeGroupDetailCodeEdit(loginVO, params);
		}catch(Exception e) {
//			StringWriter sw = new StringWriter();
//			e.printStackTrace(new PrintWriter(sw));
//			String exceptionAsStrting = sw.toString();
			LOG.error("! [AMAUTH] ERROR - " + e);
			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
			throw e;
		}
		
		mv.setViewName("jsonView");
		mv.addObject(result);

		LOG.debug("- [ItemManage] INFO - @Controller >> /cmm/systemx/item/ItemCodeGroupDetailCodeEdit.do");
		return mv;
	}
	
	/* 수정 - 외부코드 상세 수정 */
	@RequestMapping("/cmm/systemx/item/ItemExternalCodeEdit.do")
	public ModelAndView ItemExternalCodeEdit(@RequestParam Map<String, Object> params, HttpServletRequest request) throws Exception {
		LOG.debug("+ [ItemManage] INFO - @Controller >> /cmm/systemx/item/ItemExternalCodeEdit.do");
		
		ModelAndView mv = new ModelAndView();
		Map<String, Object> result = new HashMap<String, Object>();
		
		try {
			/* 변수정의 */
			LoginVO loginVO = (LoginVO) EgovUserDetailsHelper
					.getAuthenticatedUser();
			
			result = itemManageService.ItemExternalCodeEdit(loginVO, params);
		}catch(Exception e) {
//			StringWriter sw = new StringWriter();
//			e.printStackTrace(new PrintWriter(sw));
//			String exceptionAsStrting = sw.toString();
			LOG.error("! [AMAUTH] ERROR - " + e);
			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
			throw e;
		}
		
		mv.setViewName("jsonView");
		mv.addObject(result);

		LOG.debug("- [ItemManage] INFO - @Controller >> /cmm/systemx/item/ItemExternalCodeEdit.do");
		return mv;
	}	
	
	/* 수정 - 그룹코드 수정 */
	@RequestMapping("/cmm/systemx/item/ItemCodeGroupUpdate.do")
	public ModelAndView ItemCodeGroupUpdate(@RequestParam Map<String, Object> params, HttpServletRequest request) throws Exception {
		LOG.debug("+ [ItemManage] INFO - @Controller >> /cmm/systemx/item/ItemCodeGroupUpdate.do");
		
		ModelAndView mv = new ModelAndView();
		Map<String, Object> result = new HashMap<String, Object>();
		
		try {
			/* 변수정의 */
			LoginVO loginVO = (LoginVO) EgovUserDetailsHelper
					.getAuthenticatedUser();
			
			result = itemManageService.ItemCodeGroupUpdate(loginVO, params);
		}catch(Exception e) {
//			StringWriter sw = new StringWriter();
//			e.printStackTrace(new PrintWriter(sw));
//			String exceptionAsStrting = sw.toString();
			LOG.error("! [AMAUTH] ERROR - " + e);
			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
			throw e;
		}
		
		mv.setViewName("jsonView");
		mv.addObject(result);

		LOG.debug("- [ItemManage] INFO - @Controller >> /cmm/systemx/item/ItemCodeGroupUpdate.do");
		return mv;
	}	

	/* 삭제 */
	/* 삭제 - 항목 삭제 */
	@RequestMapping("/cmm/systemx/item/ItemCodeDelete.do")
	public ModelAndView ItemCodeDelete(@RequestParam Map<String, Object> params, HttpServletRequest request) throws Exception {
		LOG.debug("+ [ItemManage] INFO - @Controller >> /cmm/systemx/item/ItemCodeDelete.do");
		
		ModelAndView mv = new ModelAndView();
		Map<String, Object> result = new HashMap<String, Object>();
		
		try {
			/* 변수정의 */
			LoginVO loginVO = (LoginVO) EgovUserDetailsHelper
					.getAuthenticatedUser();
			
			result = itemManageService.ItemCodeDelete(loginVO, params);
		}catch(Exception e) {
//			StringWriter sw = new StringWriter();
//			e.printStackTrace(new PrintWriter(sw));
//			String exceptionAsStrting = sw.toString();
			LOG.error("! [AMAUTH] ERROR - " + e);
			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
			throw e;
		}
		
		mv.setViewName("jsonView");
		mv.addObject(result);

		LOG.debug("- [ItemManage] INFO - @Controller >> /cmm/systemx/item/ItemCodeDelete.do");
		return mv;
	}	
	
	/* 삭제 - 그룹코드 삭제*/
	@RequestMapping("/cmm/systemx/item/ItemGroupCodeDelete.do")
	public ModelAndView ItemGroupCodeDelete(@RequestParam Map<String, Object> params, HttpServletRequest request) throws Exception {
		LOG.debug("+ [ItemManage] INFO - @Controller >> /cmm/systemx/item/ItemGroupCodeDelete.do");
		
		ModelAndView mv = new ModelAndView();
		Map<String, Object> result = new HashMap<String, Object>();
		
		try {
			/* 변수정의 */
			LoginVO loginVO = (LoginVO) EgovUserDetailsHelper
					.getAuthenticatedUser();
			
			result = itemManageService.ItemGroupCodeDelete(loginVO, params);
		}catch(Exception e) {
//			StringWriter sw = new StringWriter();
//			e.printStackTrace(new PrintWriter(sw));
//			String exceptionAsStrting = sw.toString();
			LOG.error("! [AMAUTH] ERROR - " + e);
			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
			throw e;
		}
		
		mv.setViewName("jsonView");
		mv.addObject(result);

		LOG.debug("- [ItemManage] INFO - @Controller >> /cmm/systemx/item/ItemGroupCodeDelete.do");
		return mv;
	}
	
	/* 삭제 - 외부코드 삭제*/
	@RequestMapping("/cmm/systemx/item/ItemExternalCodeDelete.do")
	public ModelAndView ItemExternalCodeDelete(@RequestParam Map<String, Object> params, HttpServletRequest request) throws Exception {
		LOG.debug("+ [ItemManage] INFO - @Controller >> /cmm/systemx/item/ItemExternalCodeDelete.do");
		
		ModelAndView mv = new ModelAndView();
		Map<String, Object> result = new HashMap<String, Object>();
		
		try {
			/* 변수정의 */
			LoginVO loginVO = (LoginVO) EgovUserDetailsHelper
					.getAuthenticatedUser();
			
			result = itemManageService.ItemExternalCodeDelete(loginVO, params);
		}catch(Exception e) {
//			StringWriter sw = new StringWriter();
//			e.printStackTrace(new PrintWriter(sw));
//			String exceptionAsStrting = sw.toString();
			LOG.error("! [AMAUTH] ERROR - " + e);
			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
			throw e;
		}
		
		mv.setViewName("jsonView");
		mv.addObject(result);

		LOG.debug("- [ItemManage] INFO - @Controller >> /cmm/systemx/item/ItemExternalCodeDelete.do");
		return mv;
	}
	
	/* 상세코드 삭제 */
	@RequestMapping("/cmm/systemx/item/ItemDetailCodeDelete.do")
	public ModelAndView ItemDetailCodeDelete(@RequestParam Map<String, Object> params, HttpServletRequest request) throws Exception {
		LOG.debug("+ [ItemManage] INFO - @Controller >> /cmm/systemx/item/ItemDetailCodeDelete.do");
		
		ModelAndView mv = new ModelAndView();
		Map<String, Object> result = new HashMap<String, Object>();
		
		try {
			/* 변수정의 */
			LoginVO loginVO = (LoginVO) EgovUserDetailsHelper
					.getAuthenticatedUser();
			
			result = itemManageService.ItemDetailCodeDelete(loginVO, params);
		}catch(Exception e) {
//			StringWriter sw = new StringWriter();
//			e.printStackTrace(new PrintWriter(sw));
//			String exceptionAsStrting = sw.toString();
			LOG.error("! [AMAUTH] ERROR - " + e);
			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
			throw e;
		}
		
		mv.setViewName("jsonView");
		mv.addObject(result);

		LOG.debug("- [ItemManage] INFO - @Controller >> /cmm/systemx/item/ItemDetailCodeDelete.do");
		return mv;
	}
	
	/* [기타] 외부코드 팝업 */
	/* 외부코드 팝업 */
	@IncludedInfo(name = "외부코드 가져오기", order = 380, gid = 80)
	@RequestMapping("/cmm/systemx/item/externalCodePopTestPage.do")
	public ModelAndView externalCodePopTestPage(@RequestParam Map<String, Object> params, HttpServletResponse response)
			throws Exception {
		ModelAndView mv = new ModelAndView();
		mv.setViewName("/neos/cmm/systemx/externalCode/pop/externalBucketPopTestPage");
		
		return mv;
	}
	
	@RequestMapping("/cmm/systemx/item/externalCodePop.do")
	public ModelAndView externalCodePop(@RequestParam Map<String, Object> params, HttpServletResponse response)
			throws Exception {
		ModelAndView mv = new ModelAndView();
		String returnData = EgovStringUtil.isNullToString(params.get("returnData"));

		mv.addObject("returnData", returnData);
		mv.addObject("customCd", params.get("customCd"));
		mv.addObject("fnCallback", params.get("fnCallback"));
		mv.setViewName("/neos/cmm/systemx/externalCode/pop/externalCodePop");
		
		return mv;
	}
	
	/* [조회] 외부코드 설정값 조회 */
	@RequestMapping("/cmm/systemx/item/getExternalCodeInfo.do")
	public ModelAndView getExternalCodeInfo(@RequestParam Map<String, Object> params, HttpServletResponse response)
			throws Exception {
		LOG.debug("+ [ItemManage] INFO - @Controller >> /cmm/systemx/item/getExternalCodeInfo.do");
		ModelAndView mv = new ModelAndView();

		if(params.get("customCd") == null) {
			params.put("customCd", "");
		}
		
		Map<String, Object> externalCodeInfo = new HashMap<String, Object>();
		
		externalCodeInfo = itemManageService.getExternalCodeInfo(params);
		
		mv.setViewName("jsonView");
		mv.addObject("result", externalCodeInfo);
		
		LOG.debug("- [ItemManage] INFO - @Controller >> /cmm/systemx/item/getExternalCodeInfo.do");
		return mv;
	}
	
	/* [조회] DB 커넥션 후 데이터 가져오기 */
	@RequestMapping("/cmm/systemx/item/getCustomInfoQuery.do")
	public ModelAndView getCustomInfoQuery(@RequestParam Map<String, Object> params, HttpServletResponse response)
			throws Exception {
		LOG.debug("+ [ItemManage] INFO - @Controller >> /cmm/systemx/item/getCustomInfoQuery.do");
		ModelAndView mv = new ModelAndView();

		Map<String, Object> externalCodeInfo = new HashMap<String, Object>();
		List<Map<String, Object>> externalCodeList = new ArrayList<Map<String, Object>>();
		
		try{
			if(params.get("customCd") == null) {
				params.put("customCd", "");
			}
			
			externalCodeInfo = itemManageService.getExternalCodeInfo(params);
			
			externalCodeInfo.put("sSearchText", params.get("sSearchText"));
			
			externalCodeList = itemManageService.getExternalCodeList(externalCodeInfo);
			
		} catch(Exception e) {
//			StringWriter sw = new StringWriter();
//			e.printStackTrace(new PrintWriter(sw));
//			String exceptionAsStrting = sw.toString();
			LOG.error("! [ItemManage] ERROR - " + e);
			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
			throw e;
		}
		
		mv.setViewName("jsonView");
		mv.addObject("codeInfo", externalCodeInfo);
		mv.addObject("result", externalCodeList);
		
		LOG.debug("- [ItemManage] INFO - @Controller >> /cmm/systemx/item/getCustomInfoQuery.do");
		return mv;
	}	
	
}
