package neos.cmm.systemx.secGrade.web;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;

import api.common.model.APIResponse;
import api.poi.service.ExcelService;
import bizbox.orgchart.service.vo.LoginVO;
import egovframework.com.cmm.annotation.IncludedInfo;
import egovframework.com.cmm.util.EgovUserDetailsHelper;
import main.web.BizboxAMessage;
import neos.cmm.db.CommonSqlDAO;
import neos.cmm.menu.service.MenuManageService;
import neos.cmm.systemx.comp.service.CompManageService;
import neos.cmm.systemx.empdept.service.EmpDeptManageService;
import neos.cmm.systemx.orgAdapter.dao.OrgAdapterDAO;
import neos.cmm.systemx.orgAdapter.service.OrgAdapterService;
import neos.cmm.systemx.secGrade.constant.Constant;
import neos.cmm.systemx.secGrade.service.SecGradeService;
import neos.cmm.systemx.secGrade.vo.SecGrade;
import neos.cmm.systemx.secGrade.vo.SecGradeRemoveResponse;
import neos.cmm.systemx.secGrade.vo.SecGradeUser;
import neos.cmm.util.MessageUtil;
import neos.cmm.util.code.CommonCodeUtil;
import net.sf.json.JSONObject;

@Controller
public class SecGradeManageController {
	
	@Resource(name="MenuManageService")
	private MenuManageService menuManageService;
	
	@Resource(name = "OrgAdapterService")
	private OrgAdapterService orgAdapterService;		

	@Resource(name = "OrgAdapterDAO")
    private OrgAdapterDAO orgAdapterDAO;	
	
	@Resource(name = "CompManageService")
	private CompManageService compService;
	
	@Resource(name = "commonSql")
	private CommonSqlDAO commonSql;	
	
	@Resource(name = "EmpDeptManageService")
    private EmpDeptManageService empDeptManageService;
	
	@Resource(name = "ExcelService")
	private ExcelService excelService;
	
	@Resource(name = "SecGradeService")
	private SecGradeService secGradeService;
	
	/* 변수정의 로그 */
	private Logger logger = Logger.getLogger(SecGradeManageController.class);

	@RequestMapping("/cmm/systemx/secGrade/secGradeManageView.do")
   	public ModelAndView secGradeManageView(@RequestParam Map<String,Object> params, HttpServletRequest request) throws Exception{
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
	 	ModelAndView mv = new ModelAndView();
	 	
	 	//로그인 이상
	 	if(loginVO == null){
			mv.setViewName("redirect:/forwardIndex.do");			
			return mv;
		}
		params.put("groupSeq", loginVO.getGroupSeq());
		boolean isAuthMenu = menuManageService.checkIsAuthMenu(params, loginVO);
		//관리자&마스터 권한 이상
		if(!isAuthMenu){
			mv.setViewName("redirect:/forwardIndex.do");			
			return mv;
		}
		
		/** 회사 리스트 조회 */
		String userSe = loginVO.getUserSe();
		List<Map<String,Object>> compList = null;
		if (userSe != null && !userSe.equals("USER")) {
			params.put("groupSeq", loginVO.getGroupSeq());
			params.put("langCode", loginVO.getLangCode());
			params.put("userSe", userSe);
			
			if (userSe.equals("ADMIN")) {
				params.put("compSeq", loginVO.getCompSeq());
				params.put("empSeq", loginVO.getUniqId());
				params.put("compFilter", loginVO.getCompSeq());
			}else if(userSe.equals("MASTER")) {
				params.put("compFilter", "");
			}
			compList = compService.getCompListAuth(params);
			
			//전체/그룹 추가
			HashMap<String, Object> all = new HashMap<>();
			all.put("compSeq", "");
			all.put("compName", BizboxAMessage.getMessage("TX000000862", "전체"));
			HashMap<String, Object> group = new HashMap<>();
			group.put("compSeq", "0");
			group.put("compName", BizboxAMessage.getMessage("TX000000933", "그룹"));
			compList.add(0, group);
			compList.add(0, all);
		}
		if(compList == null) {
			compList = new ArrayList<>();
		}
		
		mv.addObject("compList", compList);
		mv.addObject("moduleList", CommonCodeUtil.getCodeList("COM550", loginVO.getLangCode()));
		mv.addObject("params", params);
		mv.addObject("loginVO", loginVO);
		mv.setViewName("/neos/cmm/systemx/secGrade/secGradeManageView");
		return mv;
	}
	/*
	 * 
	 * post 호출 및 json 응답
	 * 보안등급코드 리스트 조회
	 */
	@RequestMapping(value="/cmm/systemx/secGrade/secGradeList.do", method={RequestMethod.GET, RequestMethod.POST})
	@ResponseBody
	public APIResponse secGradeList(@RequestParam Map<String, Object> reqParams, HttpServletRequest servletRequest) throws Exception {
		APIResponse response = new APIResponse();
	
		logger.debug("/secGradeList.do Request Params: " + JSONObject.fromObject(reqParams).toString());
		
		LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser();
		
		//로그인 이상
		if(loginVO == null) {
			MessageUtil.setApiMessage(response, servletRequest, "systemx.login.", "LOGIN004");
			return response;
		}
		//Validation
		if(!validateForSecGradeList(reqParams, response)) {
			logger.debug("/secGradeList.do Response: " + JSONObject.fromObject(response).toString());
			return response;
		}
		try{
			reqParams.put("groupSeq", loginVO.getGroupSeq());
			reqParams.put("langCode", loginVO.getLangCode());
			String userSe = loginVO.getUserSe();
			reqParams.put("userSe", userSe);
			reqParams.put("compSeqForAdmin", loginVO.getCompSeq());
			reqParams.put("empSeq", loginVO.getUniqId());
			
			//보안등급코드 리스트 맵 조회(그룹(key:"0"), 회사별(key:"compSeq")
			List<SecGrade> secGradeList = secGradeService.getSecGradeList(reqParams);
			
			response.setResultCode(Constant.API_RESPONSE_SUCCESS);
			response.setResultMessage(BizboxAMessage.getMessage("TX000011955","성공하였습니다"));
			HashMap<String, Object> resultMap = new HashMap<>();
			resultMap.put("secGradeList", secGradeList);
			response.setResult(resultMap);
		}catch(Exception e){
			response.setResultCode(Constant.API_RESPONSE_FAIL);
			response.setResultMessage(e.getMessage());	
		}
		
		logger.debug("/secGradeList.do Response: " + JSONObject.fromObject(response).toString());
	
		return response;		
	}
	private boolean validateForSecGradeList(Map<String, Object> reqParams, APIResponse response) {

		if(!reqParams.containsKey("compSeq")) {
			response.setResultCode(Constant.API_RESPONSE_FAIL);
			response.setResultMessage("NOT CONTAINS KEY [compSeq] in body");
			return false;
		}
		
		if(!reqParams.containsKey("useYn")) {
			response.setResultCode(Constant.API_RESPONSE_FAIL);
			response.setResultMessage("NOT CONTAINS KEY [useYn] in body");
			return false;
		}
		
		if(!reqParams.containsKey("useModule")) {
			response.setResultCode(Constant.API_RESPONSE_FAIL);
			response.setResultMessage("NOT CONTAINS KEY [useModule] in body");
			return false;
		}
		
		return true;
	}
	/*
	 * 
	 * post 호출 및 json 응답
	 * 보안등급사용자 저장.
	 */
	@RequestMapping(value="/cmm/systemx/secGrade/saveSecGradeUser.do", method={RequestMethod.GET, RequestMethod.POST})
	@ResponseBody
	public APIResponse saveSecGrade(@RequestParam Map<String, Object> reqParams, HttpServletRequest servletRequest) throws Exception {
		APIResponse response = new APIResponse();
		
		logger.debug("/saveSecGradeUser.do Request Params: " + JSONObject.fromObject(reqParams).toString());
		
		LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser();
		
		//로그인 이상
		if(loginVO == null) {
			MessageUtil.setApiMessage(response, servletRequest, "systemx.login.", "LOGIN004");
			return response;
		}
		//Validation
		if(!validateForSaveSecGradeUser(reqParams, response)) {
			logger.debug("/saveSecGradeUser.do Response: " + JSONObject.fromObject(response).toString());
			return response;
		}
		try{
			reqParams.put("groupSeq", loginVO.getGroupSeq());
			reqParams.put("createSeq", loginVO.getUniqId());
			reqParams.put("saveList", new ObjectMapper().readValue((String)reqParams.get("saveList"), new TypeReference<List<Map<String, Object>>>(){}));
			
			//보안등급사용자 반영
			secGradeService.saveSecGradeUser(reqParams);
			
			response.setResultCode(Constant.API_RESPONSE_SUCCESS);
			response.setResultMessage(BizboxAMessage.getMessage("TX000011955","성공하였습니다"));
		}catch(Exception e){
			response.setResultCode(Constant.API_RESPONSE_FAIL);
			response.setResultMessage(e.getMessage());	
		}
		
		logger.debug("/saveSecGradeUser.do Response: " + JSONObject.fromObject(response).toString());
	
		return response;		
	}
	private boolean validateForSaveSecGradeUser(Map<String, Object> reqParams, APIResponse response) {

		if(!reqParams.containsKey("secId")) {
			response.setResultCode(Constant.API_RESPONSE_FAIL);
			response.setResultMessage("NOT CONTAINS KEY [secId] in body");
			return false;
		}
		
		if(!reqParams.containsKey("saveList")) {
			response.setResultCode(Constant.API_RESPONSE_FAIL);
			response.setResultMessage("NOT CONTAINS KEY [saveList] in body");
			return false;
		}
		
		return true;
	}
	/*
	 * 
	 * post 호출 및 json 응답
	 * 보안등급사용자 리스트 조회
	 */
	@RequestMapping(value="/cmm/systemx/secGrade/secGradeUserList.do", method={RequestMethod.GET, RequestMethod.POST})
	@ResponseBody
	public APIResponse secGradeUserList(@RequestParam Map<String, Object> reqParams, HttpServletRequest servletRequest) throws Exception {
		APIResponse response = new APIResponse();
	
		logger.debug("/secGradeUserList.do Request Params: " + JSONObject.fromObject(reqParams).toString());
		
		LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser();
		
		//로그인 이상
		if(loginVO == null) {
			MessageUtil.setApiMessage(response, servletRequest, "systemx.login.", "LOGIN004");
			return response;
		}
		//Validation
		if(!validateForSecGradeUserList(reqParams, response)) {
			logger.debug("/secGradeUserList.do Response: " + JSONObject.fromObject(response).toString());
			return response;
		}
		try{
			reqParams.put("groupSeq", loginVO.getGroupSeq());
			reqParams.put("langCode", loginVO.getLangCode());
			String userSe = loginVO.getUserSe();
			reqParams.put("userSe", userSe);
			reqParams.put("compSeqForAdmin", loginVO.getCompSeq());
			reqParams.put("empSeq", loginVO.getUniqId());
			
			//보안등급사용자 리스트 조회
			List<SecGradeUser> secGradeUserList = secGradeService.getSecGradeUserList(reqParams);
			
			response.setResultCode(Constant.API_RESPONSE_SUCCESS);
			response.setResultMessage(BizboxAMessage.getMessage("TX000011955","성공하였습니다"));
			HashMap<String, Object> resultMap = new HashMap<>();
			resultMap.put("secGradeUserList", secGradeUserList);
			response.setResult(resultMap);
		}catch(Exception e){
			response.setResultCode(Constant.API_RESPONSE_FAIL);
			response.setResultMessage(e.getMessage());	
		}
		
		logger.debug("/secGradeUserList.do Response: " + JSONObject.fromObject(response).toString());
	
		return response;		
	}
	private boolean validateForSecGradeUserList(Map<String, Object> reqParams, APIResponse response) {

		if(!reqParams.containsKey("secId")) {
			response.setResultCode(Constant.API_RESPONSE_FAIL);
			response.setResultMessage("NOT CONTAINS KEY [secId] in body");
			return false;
		}
		
		if(!reqParams.containsKey("compSeq")) {
			response.setResultCode(Constant.API_RESPONSE_FAIL);
			response.setResultMessage("NOT CONTAINS KEY [compSeq] in body");
			return false;
		}
		
		if(!reqParams.containsKey("searchText")) {
			response.setResultCode(Constant.API_RESPONSE_FAIL);
			response.setResultMessage("NOT CONTAINS KEY [searchText] in body");
			return false;
		}
		
		return true;
	}
	/*
	 * 
	 * post 호출 및 json 응답
	 * 보안등급사용자 삭제.
	 */
	@RequestMapping(value="/cmm/systemx/secGrade/removeSecGradeUser.do", method={RequestMethod.GET, RequestMethod.POST})
	@ResponseBody
	public APIResponse removeSecGradeUser(@RequestParam Map<String, Object> reqParams, HttpServletRequest servletRequest) throws Exception {
		APIResponse response = new APIResponse();
		
		logger.debug("/removeSecGradeUser.do Request Params: " + JSONObject.fromObject(reqParams).toString());
		
		LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser();
		
		//로그인 이상
		if(loginVO == null) {
			MessageUtil.setApiMessage(response, servletRequest, "systemx.login.", "LOGIN004");
			return response;
		}
		//Validation
		if(!validateForRemoveSecGradeUser(reqParams, response)) {
			logger.debug("/removeSecGradeUser.do Response: " + JSONObject.fromObject(response).toString());
			return response;
		}
		try{
			reqParams.put("groupSeq", loginVO.getGroupSeq());
			reqParams.put("removeList", new ObjectMapper().readValue((String)reqParams.get("removeList"), new TypeReference<List<Map<String, Object>>>(){}));
			
			//보안등급사용자 삭제
			secGradeService.removeSecGradeUser(reqParams);
			
			response.setResultCode(Constant.API_RESPONSE_SUCCESS);
			response.setResultMessage(BizboxAMessage.getMessage("TX000011955","성공하였습니다"));
		}catch(Exception e){
			response.setResultCode(Constant.API_RESPONSE_FAIL);
			response.setResultMessage(e.getMessage());	
		}
		
		logger.debug("/removeSecGradeUser.do Response: " + JSONObject.fromObject(response).toString());
	
		return response;		
	}
	
	private boolean validateForRemoveSecGradeUser(Map<String, Object> reqParams, APIResponse response) {

		if(!reqParams.containsKey("removeList")) {
			response.setResultCode(Constant.API_RESPONSE_FAIL);
			response.setResultMessage("NOT CONTAINS KEY [removeList] in body");
			return false;
		}
		
		return true;
	}
	
	@IncludedInfo(name = "보안등급 선택 팝업", order = 350, gid = 60)
	@RequestMapping("/cmm/systemx/secGrade/secGradePop.do")
	public ModelAndView secGradePop(@RequestParam Map<String, Object> params, HttpServletResponse response, HttpServletRequest request)
			throws Exception {
		ModelAndView mv = new ModelAndView();

		mv.addObject("params", params);
		
		mv.setViewName("/neos/cmm/systemx/secGrade/pop/secGradePop");
		
		return mv;
	}
	/*
	 * 
	 * post 호출 및 json 응답
	 * 보안등급코드 리스트 조회
	 */
	@RequestMapping(value="/cmm/systemx/secGrade/secGradeListForPop.do", method={RequestMethod.GET, RequestMethod.POST})
	@ResponseBody
	public APIResponse secGradeListForPop(@RequestParam Map<String, Object> reqParams, HttpServletRequest servletRequest) throws Exception {
		APIResponse response = new APIResponse();
	
		logger.debug("/secGradeListForPop.do Request Params: " + JSONObject.fromObject(reqParams).toString());
		
		LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser();
		
		//로그인 이상
		if(loginVO == null) {
			MessageUtil.setApiMessage(response, servletRequest, "systemx.login.", "LOGIN004");
			return response;
		}
		//Validation
		if(!validateForSecGradeListForPop(reqParams, response)) {
			logger.debug("/secGradeListForPop.do Response: " + JSONObject.fromObject(response).toString());
			return response;
		}
		try{
			reqParams.put("groupSeq", loginVO.getGroupSeq());
			reqParams.put("langCode", loginVO.getLangCode());
			
			//보안등급코드 리스트 맵 조회(그룹(key:"0"), 회사별(key:"compSeq")
			List<SecGrade> secGradeList = secGradeService.getSecGradeListForPop(reqParams);
			
			response.setResultCode(Constant.API_RESPONSE_SUCCESS);
			response.setResultMessage(BizboxAMessage.getMessage("TX000011955","성공하였습니다"));
			HashMap<String, Object> resultMap = new HashMap<>();
			resultMap.put("secGradeList", secGradeList);
			response.setResult(resultMap);
		}catch(Exception e){
			response.setResultCode(Constant.API_RESPONSE_FAIL);
			response.setResultMessage(e.getMessage());	
		}
		
		logger.debug("/secGradeListForPop.do Response: " + JSONObject.fromObject(response).toString());
	
		return response;		
	}
	private boolean validateForSecGradeListForPop(Map<String, Object> reqParams, APIResponse response) {

		if(!reqParams.containsKey("compSeq")) {
			response.setResultCode(Constant.API_RESPONSE_FAIL);
			response.setResultMessage("NOT CONTAINS KEY [compSeq] in body");
			return false;
		}
		
		if(!reqParams.containsKey("useYn")) {
			response.setResultCode(Constant.API_RESPONSE_FAIL);
			response.setResultMessage("NOT CONTAINS KEY [useYn] in body");
			return false;
		}
		
		if(!reqParams.containsKey("useModule")) {
			response.setResultCode(Constant.API_RESPONSE_FAIL);
			response.setResultMessage("NOT CONTAINS KEY [useModule] in body");
			return false;
		}
		
		return true;
	}
	@IncludedInfo(name = "보안등급 등록 팝업", order = 350, gid = 60)
	@RequestMapping("/cmm/systemx/secGrade/secGradeRegPop.do")
	public ModelAndView secGradeRegPop(@RequestParam Map<String, Object> params, HttpServletResponse response, HttpServletRequest request)
			throws Exception {
		ModelAndView mv = new ModelAndView();
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		
		//팝업모드 : "c":신규, "u":수정
		String popMode = (String) params.get("popMode");
		
		/** 회사 리스트 조회 */
		String userSe = loginVO.getUserSe();
		List<Map<String,Object>> compList = null;
		if (userSe != null && !userSe.equals("USER")) {
			params.put("groupSeq", loginVO.getGroupSeq());
			params.put("langCode", loginVO.getLangCode());
			params.put("userSe", userSe);
			
			if (userSe.equals("ADMIN")) {
				params.put("compSeq", loginVO.getCompSeq());
				params.put("empSeq", loginVO.getUniqId());
				params.put("compFilter", loginVO.getCompSeq());
			}else if(userSe.equals("MASTER")) {
				params.put("compFilter", "");
			}
			compList = compService.getCompListAuth(params);
			
			//그룹 추가(관리자는 팝업에서는 수정일 때만 그룹이 보임/마스터는 항상 보임)
			if(!userSe.equals("ADMIN") || !"c".equals(popMode)) {
				HashMap<String, Object> group = new HashMap<>();
				group.put("compSeq", "0");
				group.put("compName", BizboxAMessage.getMessage("TX000000933", "그룹"));
				compList.add(0, group);	
			}
			
		}
		if(compList == null) {
			compList = new ArrayList<>();
		}
		
		mv.addObject("compList", compList);
		mv.addObject("moduleList", CommonCodeUtil.getCodeList("COM550", loginVO.getLangCode()));
		mv.addObject("params", params);
				
		mv.setViewName("/neos/cmm/systemx/secGrade/pop/secGradeRegPop");
		return mv;
	}
	/*
	 * 
	 * post 호출 및 json 응답
	 * 보안등급코드 중복 조회
	 */
	@RequestMapping(value="/cmm/systemx/secGrade/secGrade.do", method={RequestMethod.GET, RequestMethod.POST})
	@ResponseBody
	public APIResponse secGrade(@RequestParam Map<String, Object> reqParams, HttpServletRequest servletRequest) throws Exception {
		APIResponse response = new APIResponse();
	
		logger.debug("/secGrade.do Request Params: " + JSONObject.fromObject(reqParams).toString());
		
		LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser();
		
		//로그인 이상
		if(loginVO == null) {
			MessageUtil.setApiMessage(response, servletRequest, "systemx.login.", "LOGIN004");
			return response;
		}
		//Validation
		if(!validateForSecGrade(reqParams, response)) {
			logger.debug("/secGrade.do Response: " + JSONObject.fromObject(response).toString());
			return response;
		}
		try{
			reqParams.put("groupSeq", loginVO.getGroupSeq());
			
			//보안등급코드 조회
			SecGrade secGrade = secGradeService.getSecGrade(reqParams);
			
			response.setResultCode(Constant.API_RESPONSE_SUCCESS);
			response.setResultMessage(BizboxAMessage.getMessage("TX000011955","성공하였습니다"));
			HashMap<String, Object> resultMap = new HashMap<>();
			resultMap.put("secGrade", secGrade);
			response.setResult(resultMap);
		}catch(Exception e){
			response.setResultCode(Constant.API_RESPONSE_FAIL);
			response.setResultMessage(e.getMessage());	
		}
		
		logger.debug("/secGrade.do Response: " + JSONObject.fromObject(response).toString());
	
		return response;		
	}
	private boolean validateForSecGrade(Map<String, Object> reqParams, APIResponse response) {

		if(!reqParams.containsKey("secId")) {
			response.setResultCode(Constant.API_RESPONSE_FAIL);
			response.setResultMessage("NOT CONTAINS KEY [secId] in body");
			return false;
		}
		
		return true;
	}
	
	/*
	 * 
	 * post 호출 및 json 응답
	 * 보안등급 수정.
	 */
	@RequestMapping(value="/cmm/systemx/secGrade/modifySecGrade.do", method={RequestMethod.GET, RequestMethod.POST})
	@ResponseBody
	public APIResponse modifySecGrade(@RequestParam Map<String, Object> reqParams, HttpServletRequest servletRequest) throws Exception {
		APIResponse response = new APIResponse();
		
		logger.debug("/modifySecGrade.do Request Params: " + JSONObject.fromObject(reqParams).toString());
		
		LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser();
		
		//로그인 이상
		if(loginVO == null) {
			MessageUtil.setApiMessage(response, servletRequest, "systemx.login.", "LOGIN004");
			return response;
		}
		//Validation
		if(!validateForModifySecGrade(reqParams, response)) {
			logger.debug("/modifySecGrade.do Response: " + JSONObject.fromObject(response).toString());
			return response;
		}
		try{
			reqParams.put("groupSeq", loginVO.getGroupSeq());
			reqParams.put("empSeq", loginVO.getUniqId());
			//보안등급 수정
			secGradeService.modifySecGrade(reqParams);
			
			response.setResultCode(Constant.API_RESPONSE_SUCCESS);
			response.setResultMessage(BizboxAMessage.getMessage("TX000011955","성공하였습니다"));
		}catch(Exception e){
			response.setResultCode(Constant.API_RESPONSE_FAIL);
			response.setResultMessage(e.getMessage());	
		}
		
		logger.debug("/modifySecGrade.do Response: " + JSONObject.fromObject(response).toString());
	
		return response;		
	}
	
	private boolean validateForModifySecGrade(Map<String, Object> reqParams, APIResponse response) {

		if(!reqParams.containsKey("secId")) {
			response.setResultCode(Constant.API_RESPONSE_FAIL);
			response.setResultMessage("NOT CONTAINS KEY [secId] in body");
			return false;
		}
		
		if(!reqParams.containsKey("secNameKr")) {
			response.setResultCode(Constant.API_RESPONSE_FAIL);
			response.setResultMessage("NOT CONTAINS KEY [secNameKr] in body");
			return false;
		}
		
		if(!reqParams.containsKey("iconYn")) {
			response.setResultCode(Constant.API_RESPONSE_FAIL);
			response.setResultMessage("NOT CONTAINS KEY [iconYn] in body");
			return false;
		}
		
		if(!reqParams.containsKey("useYn")) {
			response.setResultCode(Constant.API_RESPONSE_FAIL);
			response.setResultMessage("NOT CONTAINS KEY [useYn] in body");
			return false;
		}
		
		return true;
	}
	/*
	 * 
	 * post 호출 및 json 응답
	 * 보안등급 등록.
	 */
	@RequestMapping(value="/cmm/systemx/secGrade/regSecGrade.do", method={RequestMethod.GET, RequestMethod.POST})
	@ResponseBody
	public APIResponse regSecGrade(@RequestParam Map<String, Object> reqParams, HttpServletRequest servletRequest) throws Exception {
		APIResponse response = new APIResponse();
		
		logger.debug("/regSecGrade.do Request Params: " + JSONObject.fromObject(reqParams).toString());
		
		LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser();
		
		//로그인 이상
		if(loginVO == null) {
			MessageUtil.setApiMessage(response, servletRequest, "systemx.login.", "LOGIN004");
			return response;
		}
		//Validation
		if(!validateForRegSecGrade(reqParams, response)) {
			logger.debug("/regSecGrade.do Response: " + JSONObject.fromObject(response).toString());
			return response;
		}
		try{
			reqParams.put("groupSeq", loginVO.getGroupSeq());
			reqParams.put("empSeq", loginVO.getUniqId());
			//보안등급 등록
			secGradeService.regSecGrade(reqParams);
			
			response.setResultCode(Constant.API_RESPONSE_SUCCESS);
			response.setResultMessage(BizboxAMessage.getMessage("TX000011955","성공하였습니다"));
		}catch(Exception e){
			response.setResultCode(Constant.API_RESPONSE_FAIL);
			response.setResultMessage(e.getMessage());	
		}
		
		logger.debug("/regSecGrade.do Response: " + JSONObject.fromObject(response).toString());
	
		return response;		
	}
	
	private boolean validateForRegSecGrade(Map<String, Object> reqParams, APIResponse response) {

		if(!reqParams.containsKey("secId")) {
			response.setResultCode(Constant.API_RESPONSE_FAIL);
			response.setResultMessage("NOT CONTAINS KEY [secId] in body");
			return false;
		}
		
		if(!reqParams.containsKey("compSeq")) {
			response.setResultCode(Constant.API_RESPONSE_FAIL);
			response.setResultMessage("NOT CONTAINS KEY [compSeq] in body");
			return false;
		}
		
		if(!reqParams.containsKey("useModule")) {
			response.setResultCode(Constant.API_RESPONSE_FAIL);
			response.setResultMessage("NOT CONTAINS KEY [useModule] in body");
			return false;
		}
		
		if(!reqParams.containsKey("upperSecId")) {
			response.setResultCode(Constant.API_RESPONSE_FAIL);
			response.setResultMessage("NOT CONTAINS KEY [upperSecId] in body");
			return false;
		}
		
		if(!reqParams.containsKey("upperSecDepth")) {
			response.setResultCode(Constant.API_RESPONSE_FAIL);
			response.setResultMessage("NOT CONTAINS KEY [upperSecDepth] in body");
			return false;
		}
		
		if(!reqParams.containsKey("secNameKr")) {
			response.setResultCode(Constant.API_RESPONSE_FAIL);
			response.setResultMessage("NOT CONTAINS KEY [secNameKr] in body");
			return false;
		}
		
		if(!reqParams.containsKey("iconYn")) {
			response.setResultCode(Constant.API_RESPONSE_FAIL);
			response.setResultMessage("NOT CONTAINS KEY [iconYn] in body");
			return false;
		}
		
		if(!reqParams.containsKey("useYn")) {
			response.setResultCode(Constant.API_RESPONSE_FAIL);
			response.setResultMessage("NOT CONTAINS KEY [useYn] in body");
			return false;
		}
		
		return true;
	}
	
	/*
	 * 
	 * post 호출 및 json 응답
	 * 보안등급 삭제 가능여부.
	 */
	@RequestMapping(value="/cmm/systemx/secGrade/canRemoveSecGrade.do", method={RequestMethod.GET, RequestMethod.POST})
	@ResponseBody
	public APIResponse canRemoveSecGrade(@RequestParam Map<String, Object> reqParams, HttpServletRequest servletRequest) throws Exception {
		APIResponse response = new APIResponse();
		
		logger.debug("/canRemoveSecGrade.do Request Params: " + JSONObject.fromObject(reqParams).toString());
		
		LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser();
		
		//로그인 이상
		if(loginVO == null) {
			MessageUtil.setApiMessage(response, servletRequest, "systemx.login.", "LOGIN004");
			return response;
		}
		
		//사용자권한
		reqParams.put("userSe", loginVO.getUserSe());
		
		//Validation
		if(!validateForCanRemoveSecGrade(reqParams, response)) {
			logger.debug("/canRemoveSecGrade.do Response: " + JSONObject.fromObject(response).toString());
			return response;
		}
		try{
			reqParams.put("groupSeq", loginVO.getGroupSeq());
			reqParams.put("empSeq", loginVO.getUniqId());
			reqParams.put("langCode", loginVO.getLangCode());
			reqParams.put("scheme", servletRequest.getScheme());
			reqParams.put("serverName", servletRequest.getServerName());
			reqParams.put("serverPort", servletRequest.getServerPort());
			reqParams.put("apiUrl", Constant.EAP_CAN_REMOVE_API_URL);
			
			//보안등급 삭제 가능여부
			response.setResult(secGradeService.canRemoveSecGrade(reqParams));
			
			response.setResultCode(Constant.API_RESPONSE_SUCCESS);
			response.setResultMessage(BizboxAMessage.getMessage("TX000011955","성공하였습니다"));
		}catch(Exception e){
			response.setResultCode(Constant.API_RESPONSE_FAIL);
			response.setResultMessage(e.getMessage());	
		}
		
		logger.debug("/canRemoveSecGrade.do Response: " + JSONObject.fromObject(response).toString());
	
		return response;		
	}
	
	/*
	 * 
	 * post 호출 및 json 응답
	 * 보안등급 삭제 가능여부.
	 */
	@RequestMapping(value="/cmm/systemx/secGrade/canUnUseSecGrade.do", method={RequestMethod.GET, RequestMethod.POST})
	@ResponseBody
	public APIResponse canUnUseSecGrade(@RequestParam Map<String, Object> reqParams, HttpServletRequest servletRequest) throws Exception {
		APIResponse response = new APIResponse();
		
		logger.debug("/canUnUseSecGrade.do Request Params: " + JSONObject.fromObject(reqParams).toString());
		
		LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser();
		
		//로그인 이상
		if(loginVO == null) {
			MessageUtil.setApiMessage(response, servletRequest, "systemx.login.", "LOGIN004");
			return response;
		}
		
		//사용자권한
		reqParams.put("userSe", loginVO.getUserSe());
		
		//Validation
		if(!validateForCanRemoveSecGrade(reqParams, response)) {
			logger.debug("/canUnUseSecGrade.do Response: " + JSONObject.fromObject(response).toString());
			return response;
		}
		try{
			reqParams.put("groupSeq", loginVO.getGroupSeq());
			reqParams.put("empSeq", loginVO.getUniqId());
			reqParams.put("langCode", loginVO.getLangCode());
			reqParams.put("scheme", servletRequest.getScheme());
			reqParams.put("serverName", servletRequest.getServerName());
			reqParams.put("serverPort", servletRequest.getServerPort());
			reqParams.put("apiUrl", Constant.EAP_CAN_UNUSED_API_URL);
			reqParams.put("unused", true);
			
			//보안등급 삭제 가능여부
			response.setResult(secGradeService.canRemoveSecGrade(reqParams));
			
			response.setResultCode(Constant.API_RESPONSE_SUCCESS);
			response.setResultMessage(BizboxAMessage.getMessage("TX000011955","성공하였습니다"));
		}catch(Exception e){
			response.setResultCode(Constant.API_RESPONSE_FAIL);
			response.setResultMessage(e.getMessage());	
		}
		
		logger.debug("/canUnUseSecGrade.do Response: " + JSONObject.fromObject(response).toString());
	
		return response;		
	}
	
	private boolean validateForCanRemoveSecGrade(Map<String, Object> reqParams, APIResponse response) {

		if(!reqParams.containsKey("secId")) {
			response.setResultCode(Constant.API_RESPONSE_FAIL);
			response.setResultMessage("NOT CONTAINS KEY [secId] in body");
			return false;
		}
		if(!reqParams.containsKey("parent")) {
			response.setResultCode(Constant.API_RESPONSE_FAIL);
			response.setResultMessage("NOT CONTAINS KEY [parent] in body");
			return false;
		}
		if(!reqParams.containsKey("module")) {
			response.setResultCode(Constant.API_RESPONSE_FAIL);
			response.setResultMessage("NOT CONTAINS KEY [module] in body");
			return false;
		}
		if(!reqParams.containsKey("compSeq")) {
			response.setResultCode(Constant.API_RESPONSE_FAIL);
			response.setResultMessage("NOT CONTAINS KEY [compSeq] in body");
			return false;
		}
		
		if(!reqParams.containsKey("secDepth")) {
			response.setResultCode(Constant.API_RESPONSE_FAIL);
			response.setResultMessage("NOT CONTAINS KEY [secDepth] in body");
			return false;
		}
		String userSe = (String) reqParams.get("userSe");
		String compSeq = (String) reqParams.get("compSeq");
		String parent = (String) reqParams.get("parent");
		
		if("#".equals(parent)) {
			response.setResultCode(Constant.API_RESPONSE_FAIL);
			response.setResultMessage(BizboxAMessage.getMessage("", "최상위는 삭제 불가능 합니다."));
			return false;
		}
		
		if("ADMIN".equals(userSe) && "0".equals(compSeq)) {
			response.setResultCode(Constant.API_RESPONSE_FAIL);
			response.setResultMessage(BizboxAMessage.getMessage("", "관리자는 그룹을 삭제할 수 없습니다."));
			return false;
		}
		/*
		if("0".equals(compSeq) && secDepth < 4 && ("001".equals(secId) || "002".equals(secId) || "003".equals(secId))) {
			response.setResultCode(Constant.API_RESPONSE_FAIL);
			response.setResultMessage(BizboxAMessage.getMessage("", "기본 제공되는 등급은 삭제 불가합니다. 미사용 처리 해주세요."));
			return false;
		}
		*/
		return true;
	}
	
	/*
	 * 
	 * post 호출 및 json 응답
	 * 보안등급 삭제 실행.
	 */
	@RequestMapping(value="/cmm/systemx/secGrade/removeSecGrade.do", method={RequestMethod.GET, RequestMethod.POST})
	@ResponseBody
	public APIResponse removeSecGrade(@RequestParam Map<String, Object> reqParams, HttpServletRequest servletRequest) throws Exception {
		APIResponse response = new APIResponse();
		
		logger.debug("/removeSecGrade.do Request Params: " + JSONObject.fromObject(reqParams).toString());
		
		LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser();
		
		//로그인 이상
		if(loginVO == null) {
			MessageUtil.setApiMessage(response, servletRequest, "systemx.login.", "LOGIN004");
			return response;
		}
		
		//사용자권한
		reqParams.put("userSe", loginVO.getUserSe());
		
		//Validation
		if(!validateForCanRemoveSecGrade(reqParams, response)) {
			logger.debug("/removeSecGrade.do Response: " + JSONObject.fromObject(response).toString());
			return response;
		}
		
		try{
			reqParams.put("groupSeq", loginVO.getGroupSeq());
			reqParams.put("empSeq", loginVO.getUniqId());
			reqParams.put("langCode", loginVO.getLangCode());
			reqParams.put("scheme", servletRequest.getScheme());
			reqParams.put("serverName", servletRequest.getServerName());
			reqParams.put("serverPort", servletRequest.getServerPort());
			
			//보안등급 삭제
			secGradeService.removeSecGrade(reqParams);
			
			response.setResultCode(Constant.API_RESPONSE_SUCCESS);
			response.setResultMessage(BizboxAMessage.getMessage("TX000011955","성공하였습니다"));
		}catch(Exception e){
			response.setResultCode(Constant.API_RESPONSE_FAIL);
			response.setResultMessage(e.getMessage());	
		}
		
		logger.debug("/removeSecGrade.do Response: " + JSONObject.fromObject(response).toString());
	
		return response;		
	}
	
	/*
	 * post 호출 및 json 응답
	 * 전자결재 삭제 API MOCKUP.
	 */
	@RequestMapping(value="/cmm/systemx/secGrade/removeTest.do", method={RequestMethod.GET, RequestMethod.POST})
	@ResponseBody
	public SecGradeRemoveResponse testMockup(@RequestBody Map<String, Object> reqParams, HttpServletRequest servletRequest) throws Exception {
		SecGradeRemoveResponse response = new SecGradeRemoveResponse();
		
		logger.debug("/removeSecGrade.do Request Params: " + JSONObject.fromObject(reqParams).toString());
		
		//EXMPLE1

		response.setCanRemoveYn("Y");
		response.setType("EA001");
		response.setTypeMessage("기안양식등록에 기본값으로 설정되어 있습니다. 삭제시 기본값이 변경됩니다. 삭제하시겠습니까?");
		response.setCallBackYn("Y");
		response.setCallBackUrl("/gw/cmm/systemx/secGrade/callBackTest.do");

		//EXAMPLE2
		/*response.setCanRemoveYn("N");
		response.setType("EA002");
		response.setTypeMessage("결재문서에 매핑되어 있어 삭제 불가합니다. 미사용 처리 해주세요.");
		response.setCallBackYn("N");*/
		//response.setCallBackUrl(Constant.EAP_CAN_REMOVE_API_URL);
		
		
		logger.debug("/removeSecGrade.do Response: " + JSONObject.fromObject(response).toString());
	
		return response;		
	}
	/*
	 * post 호출 및 json 응답
	 * 전자결재 삭제 API CALLBACK MOCKUP.
	 */
	@RequestMapping(value="/cmm/systemx/secGrade/callBackTest.do", method={RequestMethod.GET, RequestMethod.POST})
	@ResponseBody
	public SecGradeRemoveResponse testMockup2(@RequestBody Map<String, Object> reqParams, HttpServletRequest servletRequest) throws Exception {
		SecGradeRemoveResponse response = new SecGradeRemoveResponse();
		
		logger.debug("/callBackTest.do Request Params: " + JSONObject.fromObject(reqParams).toString());
		
		//EXMPLE1
		response.setCanRemoveYn("Y");
		response.setType("EA001");
		response.setTypeMessage("기안양식등록에 기본값으로 설정되어 있습니다. 삭제시 기본값이 변경됩니다. 삭제하시겠습니까?");
		response.setCallBackYn("Y");
		response.setCallBackUrl("성공공성공공성공공성공공성공공성공공성공공");

		//EXAMPLE2
		/*response.setCanRemoveYn("N");
		response.setType("EA002");
		response.setTypeMessage("결재문서에 매핑되어 있어 삭제 불가합니다. 미사용 처리 해주세요.");
		response.setCallBackYn("N");*/
		//response.setCallBackUrl(Constant.EAP_CAN_REMOVE_API_URL);
		
		
		logger.debug("/callBackTest.do Response: " + JSONObject.fromObject(response).toString());
	
		return response;		
	}
	
}
