package neos.cmm.systemx.alarm.master.web;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletResponse;

import neos.cmm.menu.service.MenuManageService;
import neos.cmm.systemx.alarm.master.service.AlarmMasterService;
import neos.cmm.systemx.orgchart.service.OrgChartService;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import bizbox.orgchart.service.vo.LoginVO;
import egovframework.com.cmm.util.EgovUserDetailsHelper;

@Controller
public class AlarmMasterController {
	
	private static final Logger logger = LoggerFactory.getLogger(AlarmMasterController.class);
	
	@Resource(name = "OrgChartService")
	private OrgChartService orgChartService;
	
	@Resource(name = "AlarmMasterService")
	private AlarmMasterService alarmMasterService;
	
	@Resource(name="MenuManageService")
	private MenuManageService menuManageService;
	
	/**
	 * 알림 설정 정보 가져오기 alarmMaterView
	 * @param paramMap
	 * @param response
	 * @return compList : 회사 정보들
	 * @throws Exception
	 */
	@RequestMapping("/cmm/systemx/alarm/alarmMasterView.do")
	public ModelAndView alarmMasterView(@RequestParam Map<String, Object> paramMap, HttpServletResponse response) throws Exception {
		long time = System.currentTimeMillis();
		
		ModelAndView mv = new ModelAndView();

		/** 로그인 정보 (user 정보) 가져오기 */
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		
		
		boolean isAuthMenu = menuManageService.checkIsAuthMenu(paramMap, loginVO);
		if(!isAuthMenu){
			mv.setViewName("redirect:/forwardIndex.do");			
			return mv;
		}
		
		paramMap.put("langCode", loginVO.getLangCode());
		paramMap.put("gbnOrgList", "'c'");
		paramMap.put("groupSeq", loginVO.getGroupSeq());
		
		/** 그룹 정보 가져오기, 그룹명 가져오기 위해 */
		Map<String, Object> groupMap = orgChartService.getGroupInfo(paramMap);
		
		paramMap.put("groupName", groupMap.get("groupName"));
				
		/** 회사리스트 조회*/
		try{
			logger.info( "-start alarmMasterView(Controller)");
			
			List<Map<String,Object>> compList = alarmMasterService.getAlarmInfoList(paramMap);
			
			mv.addObject("compList", compList);
			mv.addObject("compSize", compList.size());
			mv.setViewName("/neos/cmm/systemx/alarm/alarmMasterView");

		} catch(Exception ex) {
			time = System.currentTimeMillis() - time;
			logger.error("-error alarmMasterView(Controller) [" + time + "] " + ex);
		}

		return mv;
	}
	
	/**
	 * 회사 별 알림 설정 값 저장(수정)
	 * @param paramMap [{"compSeq":"58","alert":"Y","push":"Y","talk":"N","mail":"N","sms":"N"}, {}]
	 *              	compSeq : 회사 키값
	 *              	alert : 알림 사용 / 미사용 여부 Y: 사용, N: 미사용, B: 사용안함
	 * @return
	 */
    @RequestMapping("/cmm/systemx/alarm/alarmUpdate.do")
	public ModelAndView updateAlarm(@RequestParam Map<String,Object> paramMap){
    	long time = System.currentTimeMillis();
    	
		ModelAndView mv = new ModelAndView();

		/** 로그인 정보 (user 정보) 가져오기 */
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();

		/** 회사 별 알림 설정 값 저장(수정) */
		try {
			logger.info( "-start updateAlarm(Controller)");
			
			alarmMasterService.updateAlarm(paramMap, loginVO.getUniqId(), loginVO.getGroupSeq());
		}catch(Exception ex) {
			time = System.currentTimeMillis() - time;
			logger.error("-error updateAlarm(Controller) [" + time + "] " + ex);
		}
		mv.setViewName("jsonView");
		
		return mv;	
	}

}
