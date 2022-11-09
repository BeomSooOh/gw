package neos.cmm.systemx.alarm.admin.web;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletResponse;

import neos.cmm.menu.service.MenuManageService;
import neos.cmm.systemx.alarm.admin.service.AlarmAdminService;
import neos.cmm.systemx.comp.service.CompManageService;
import neos.cmm.systemx.orgchart.service.OrgChartService;
import net.sf.json.JSONArray;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import egovframework.com.cmm.util.EgovUserDetailsHelper;
import bizbox.orgchart.service.vo.LoginVO;

@Controller
public class AlarmAdminController {
	@Resource(name="OrgChartService")
	private OrgChartService orgChartService;
	
	@Resource(name="AlarmAdminService")
	private AlarmAdminService alarmAdminService;
	
    @Resource(name = "CompManageService")
	private CompManageService compService;
    
    @Resource(name="MenuManageService")
	private MenuManageService menuManageService;
	
	/**
	 * alarmAdminView ( 관리자 화면 ) 
	 * @param paramMap
	 * @param response
	 * @return
	 */
	@RequestMapping("/cmm/systemx/alarm/alarmAdminView.do")
	public ModelAndView alarmAdminView(@RequestParam Map<String, Object> param, HttpServletResponse response) {
		ModelAndView mv = new ModelAndView();

		/** 로그인 정보 (user 정보) 가져오기 */
		LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser();
		
		boolean isAuthMenu = menuManageService.checkIsAuthMenu(param, loginVO);
		if(!isAuthMenu){
			mv.setViewName("redirect:/forwardIndex.do");			
			return mv;
		}
		
		
		String userSe = loginVO.getUserSe();

		param.put("langCode", loginVO.getLangCode());
		param.put("gbnOrgList", "c");
		param.put("groupSeq", loginVO.getGroupSeq());
		param.put("compSeq", loginVO.getCompSeq());
		
		/** 알림 설정 셋팅 */
		//alarmAdminService.alarmSettingCheck(param);
		
		/** 메뉴 항목 가져오기 */
		List<Map<String, Object>> alarmMenuList = alarmAdminService.getAlarmMenu(param);

		/** 회사 리스트 조회 */
		List<Map<String,Object>> compList = null;
		if (userSe != null && !userSe.equals("USER")) {
			param.put("groupSeq", loginVO.getGroupSeq());
			param.put("langCode", loginVO.getLangCode());
			param.put("userSe", userSe);
			 
			if (userSe.equals("ADMIN")) {
				param.put("empSeq", loginVO.getUniqId());
			}
			compList = compService.getCompListAuth(param);
		}

		JSONArray jsonCompList = JSONArray.fromObject(compList);
		// 회사 목록 
		mv.addObject("compListJson", jsonCompList);
		
		// 메뉴 항목 (view페이지 그려줄때 필요)
		mv.addObject("alarmMenuList", alarmMenuList);
		
		JSONArray json = JSONArray.fromObject(alarmMenuList);

		// JSON 배열로 변환한 메뉴 항목 값
		mv.addObject("alarmMenuListJson", json);
		// master, admin 구분을 위한 설정 값
		mv.addObject("userSe", userSe);
		
		mv.setViewName("/neos/cmm/systemx/alarm/alarmAdminView");
		
		return mv;
		
	}
	
	@RequestMapping("/cmm/systemx/alarm/getAlarmDetailList.do")
	public ModelAndView getAlarmDetailList(@RequestParam Map<String, Object> param) {
		ModelAndView mv = new ModelAndView();
		
		/** 로그인 정보 (user 정보) 가져오기 */
		LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser();
		String userSe = loginVO.getUserSe();
		
		param.put("langCode", loginVO.getLangCode());
		param.put("gbnOrgList", "c");
		param.put("groupSeq", loginVO.getGroupSeq());
		
		if(userSe.equals("ADMIN")){
			param.put("compSeq", loginVO.getCompSeq());
		} else if(userSe.equals("MASTER")) {
			if(param.get("compSeq") != null) {
				param.put("compSeq", param.get("compSeq"));
			} else {
				param.put("compSeq", loginVO.getCompSeq());
			}
		}
		
		/** 메뉴 별 세부 항목 가져오기 */
		List<Map<String, Object>> alarmMenuDetail = alarmAdminService.getAlarmMenuDetail(param);


		
		// 메뉴 별 세부 항목
		mv.addObject("alarmMenuListDetail", alarmMenuDetail);
		
		JSONArray jsonAlarmDetail = JSONArray.fromObject(alarmMenuDetail);

		// JSON 배열로 변환한 메뉴 별 세부 항목 값
		mv.addObject("alarmMenuListDetailJson", jsonAlarmDetail);


		mv.setViewName("jsonView");
		
		return mv;
	}

	@RequestMapping("/cmm/systemx/alarm/getMasterSetting.do")
	public ModelAndView getMasterSetting(@RequestParam Map<String, Object> param) {
		ModelAndView mv = new ModelAndView();
		
		/** 로그인 정보 (user 정보) 가져오기 */
		LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser();
		String userSe = loginVO.getUserSe();
		
		param.put("langCode", loginVO.getLangCode());
		param.put("gbnOrgList", "c");
		param.put("groupSeq", loginVO.getGroupSeq());
		
		if(userSe.equals("ADMIN")){
			param.put("compSeq", loginVO.getCompSeq());
		} else if(userSe.equals("MASTER")) {
			if(param.get("compSeq") != null) {
				param.put("compSeq", param.get("compSeq"));
			} else {
				param.put("compSeq", loginVO.getCompSeq());
			}
		}
		
		//alarmAdminService.alarmSettingCheck(param);
		
		/** 마스터 설정 알림 가져오기 */
		List<Map<String, Object>> alarmMasterSetting = alarmAdminService.getAlarmMasterSetting(param);
		
		JSONArray jsonAlarmMaster = JSONArray.fromObject(alarmMasterSetting);
		// JSON 배열로 변환한 마스터 알림 설정 값
		mv.addObject("alarmMasterJson", jsonAlarmMaster);
		
		mv.setViewName("jsonView");
		
		return mv;
	}
	
	/**
	 * alarmDetailUpdate 세부 항목들 저장(수정)
	 * @param paramMap
	 * @return
	 */
    @RequestMapping("/cmm/systemx/alarm/alarmDetailUpdate.do")
	public ModelAndView alarmDetailUpdate(@RequestParam Map<String,Object> paramMap, Map<String, Object> param){
		ModelAndView mv = new ModelAndView();

		/** 로그인 정보 (user 정보) 가져오기 */
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();

		/** 회사 별 알림 설정 값 저장(수정) */
		alarmAdminService.updateAlarmDetail(paramMap, loginVO.getUniqId(), loginVO.getGroupSeq(), loginVO.getCompSeq());
		
		mv.setViewName("jsonView");
		
		return mv;	
	}
    
    /**
     * moduleAlarm (모듈 별 저장값 조회)
     * @param paramMap
     * @param response
     * @return
     */
    @RequestMapping("/cmm/systemx/alarm/moduleAlarm.do")
    public ModelAndView moduleAlarm(@RequestParam Map<String, Object> paramMap, HttpServletResponse response) {
    	ModelAndView mv = new ModelAndView();
    	//System.out.println("공통 부분 param : " + paramMap);
    	/** 로그인 정보 (user 정보) 가져오기 */
		LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser();
		
		
		boolean isAuthMenu = menuManageService.checkIsAuthMenu(paramMap, loginVO);
		if(!isAuthMenu){
			mv.setViewName("redirect:/forwardIndex.do");			
			return mv;
		}
		
		paramMap.put("langCode", loginVO.getLangCode());
		paramMap.put("gbnOrgList", "c");
		paramMap.put("groupSeq", loginVO.getGroupSeq());
		paramMap.put("compSeq", loginVO.getCompSeq());
		// 모듈 구분 코드값
		paramMap.put("codeValue", paramMap.get("codeValue"));
		
    	List<Map<String, Object>> moduleAlarmList = alarmAdminService.getModuleAlarmList(paramMap);
    	
    	// json 형태로 변환
    	JSONArray jsonAlarmList = JSONArray.fromObject(moduleAlarmList); 
    	
    	mv.addObject("alarmList", jsonAlarmList);
    	mv.setViewName("/neos/cmm/systemx/alarm/moduleView");
    	
    	return mv;
    }
    
}
