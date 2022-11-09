package egovframework.com.sym.cal.web;

import java.util.ArrayList;
import java.util.Calendar;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import neos.cmm.util.DateUtil;
import neos.cmm.util.NeosExcelView;
import net.sf.json.JSONArray;

import org.apache.commons.collections.map.ListOrderedMap;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.View;
import org.springmodules.validation.commons.DefaultBeanValidator;

import egovframework.com.cmm.ComDefaultCodeVO;
import egovframework.com.cmm.EgovMessageSource;
import bizbox.orgchart.service.vo.LoginVO;
import egovframework.com.cmm.annotation.IncludedInfo;
import egovframework.com.cmm.service.EgovCmmUseService;
import egovframework.com.cmm.service.EgovFileMngUtil;
import egovframework.com.cmm.util.EgovUserDetailsHelper;
import egovframework.com.sym.cal.service.EgovCalRestdeManageService;
import egovframework.com.sym.cal.service.Restde;
import egovframework.com.sym.cal.service.RestdeVO;
import egovframework.com.utl.fcc.service.EgovStringUtil;
import egovframework.rte.fdl.idgnr.EgovIdGnrService;
import egovframework.rte.fdl.property.EgovPropertyService;
import egovframework.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;
import main.web.BizboxAMessage;


/**
 * 
 * 공휴일에 관한 요청을 받아 서비스 클래스로 요청을 전달하고 서비스클래스에서 처리한 결과를 웹 화면으로 전달을 위한 Controller를 정의한다
 * @author 공통서비스 개발팀 이중호
 * @since 2009.04.01
 * @version 1.0
 * @see
 *
 * <pre>
 * << 개정이력(Modification Information) >>
 *   
 *   수정일      수정자           수정내용
 *  -------    --------    ---------------------------
 *   2009.04.01  이중호          최초 생성
 *   2011.8.26	  정진오	   IncludedInfo annotation 추가
 *   2011.10.18  서준식          보안점검 조치 사항으로 sql injection에 대비한 파라미터 체크(달력 출력을 위한 숫자만 가능하도록)
 * </pre>
 */

@Controller
public class EgovCalRestdeManageController {

	@Resource(name = "RestdeManageService")
    private EgovCalRestdeManageService restdeManageService;

    /** EgovPropertyService */
    @Resource(name = "propertiesService")
    protected EgovPropertyService propertiesService;

	@Resource(name="egovRestDeIdGnrService")
	private EgovIdGnrService idgenService;	

	@Resource(name="EgovCmmUseService")
	private EgovCmmUseService cmmUseService;

	@Resource(name="egovMessageSource")
    EgovMessageSource egovMessageSource;
    
    @Resource(name = "EgovFileMngUtil")
    private EgovFileMngUtil fileUtil;
    
	@Autowired
	private DefaultBeanValidator beanValidator;
	
	public BindingResult checkRestdeWithValidator(Restde restde, BindingResult bindingResult){
		
		restde.setRestdeDe("dummy");
		restde.setRestdeNm("dummy");
		restde.setRestdeDc("dummy");
		restde.setRestdeSeCode("dummy");
		
		beanValidator.validate(restde, bindingResult);
		
		return bindingResult;
	}

	/**
	 * 달력 메인창을 호출한다.
	 * @param model
	 * @return "egovframework/com/sym/cal/EgovNormalCalPopup"
	 * @throws Exception
	 */
	@RequestMapping(value="/sym/cal/callCalPopup.do")
 	public String callCalendar (ModelMap model
 			) throws Exception {
		return "egovframework/com/sym/cal/EgovCalPopup";
	}    
	
	/**
	 * 달력을 호출한다.
	 * @param model
	 * @return "egovframework/com/sym/cal/EgovNormalCalPopup"
	 * @throws Exception
	 */
	@SuppressWarnings({ "rawtypes", "unchecked" })
	@RequestMapping(value="/sym/cal/callCal.do")
 	public String callCal (Restde restde, BindingResult bindingResult
 			, ModelMap model
 			) throws Exception {
		
		//2011.10.18 달력 출력을 위해 필요한 숫자 이외의 값을 사용하는 경우 체크
		bindingResult = checkRestdeWithValidator(restde, bindingResult);
		
		if(bindingResult.hasErrors()){
			
			return "egovframework/com/cmm/error/dataAccessFailure";
						
		}
		

		Calendar cal = Calendar.getInstance();

		if(restde.getYear()==null || restde.getYear().equals("")){
			restde.setYear(Integer.toString(cal.get(Calendar.YEAR)));
		}
		if(restde.getMonth()==null || restde.getMonth().equals("")){
			restde.setMonth(Integer.toString(cal.get(Calendar.MONTH)+1));
		}
		int iYear  = Integer.parseInt(restde.getYear());
		int iMonth = Integer.parseInt(restde.getMonth());

		if (iMonth<1){
			iYear--;
			iMonth = 12;
		}
		if (iMonth>12){
			iYear++;
			iMonth = 1;
		}
		if (iYear<1){
			iYear = 1;
			iMonth = 1;
		}
		if (iYear>9999){
			iYear = 9999;
			iMonth = 12;
		}
		
		cal.set(iYear,iMonth-1,1);
		
		int firstWeek = cal.get(Calendar.DAY_OF_WEEK);
		int lastDay   = cal.getActualMaximum(Calendar.DATE);
		int week      = cal.get(Calendar.DAY_OF_WEEK);
		
		String year   = Integer.toString(iYear);
		String month  = Integer.toString(iMonth);
		
		restde.setStartWeekMonth(firstWeek);
		restde.setLastDayMonth(lastDay);
		restde.setYear(year);
		restde.setMonth(month);
		
		List calInfoList = new ArrayList();
		String tmpDay = "";
		
		/**
		 * 계산... START
		 */
		for(int i=0; i<42;i++) {
			ListOrderedMap  map   = new ListOrderedMap();
			int cc = i + 1;
			int dd = cc-firstWeek+1;

			if (dd > 0 && dd <= lastDay) {
				tmpDay = Integer.toString(dd);
			} else {
				tmpDay = "";
			}
			
			map.put("year",		year);
	        map.put("month",	month);
	        map.put("day",		tmpDay);
	        map.put("cellNum",	cc);
	        map.put("weeks",	(cc - 1) / 7 + 1);
	        map.put("week",		(week-1) % 7 + 1);
	        map.put("restAt",	((week-1) % 7 + 1==1) ? "Y" : "N");

	    	if (dd > 0 && dd <= lastDay) {
				week ++;
			}    	
	    	calInfoList.add(map);

		}
		/**
		 * 계산... END		
		 */
		
        model.addAttribute("resultList", calInfoList);
		
		return "egovframework/com/sym/cal/EgovCalendar";
	}    
	
	/**
	 * 일반달력 팝업 메인창을 호출한다.
	 * @param model
	 * @return "egovframework/com/sym/cal/EgovNormalCalPopup"
	 * @throws Exception
	 */
	@RequestMapping(value="/sym/cal/EgovNormalCalPopup.do")
 	public String callNormalCalPopup (ModelMap model
 			) throws Exception {
		return "popup/egovframework/com/sym/cal/EgovNormalCalPopup";
	}    

	/**
	 * 일반달력 팝업 정보를 조회한다.
	 * @param restde
	 * @param model
	 * @return "egovframework/com/sym/cal/EgovNormalCalendar"
	 * @throws Exception
	 */
	@SuppressWarnings("rawtypes")
	@RequestMapping(value="/sym/cal/EgovselectNormalCalendar.do")
 	public String selectNormalRestdePopup (Restde restde, BindingResult bindingResult
 			, ModelMap model
 			) throws Exception {		
		
		//2011.10.18 달력 출력을 위해 필요한 숫자 이외의 값을 사용하는 경우 체크
		bindingResult = checkRestdeWithValidator(restde, bindingResult);
		
		if(bindingResult.hasErrors()){
			
			return "egovframework/com/cmm/error/dataAccessFailure";
						
		}
		
		Calendar cal = Calendar.getInstance();

		if(restde.getYear()==null || restde.getYear().equals("")){
			restde.setYear(Integer.toString(cal.get(Calendar.YEAR)));
		}
		if(restde.getMonth()==null || restde.getMonth().equals("")){
			restde.setMonth(Integer.toString(cal.get(Calendar.MONTH)+1));
		}
		int iYear  = Integer.parseInt(restde.getYear());
		int iMonth = Integer.parseInt(restde.getMonth());

		if (iMonth<1){
			iYear--;
			iMonth = 12;
		}
		if (iMonth>12){
			iYear++;
			iMonth = 1;
		}
		if (iYear<1){
			iYear = 1;
			iMonth = 1;
		}
		if (iYear>9999){
			iYear = 9999;
			iMonth = 12;
		}
		restde.setYear(Integer.toString(iYear));
		restde.setMonth(Integer.toString(iMonth));
		
		cal.set(iYear,iMonth-1,1);
		
		restde.setStartWeekMonth(cal.get(Calendar.DAY_OF_WEEK));
		restde.setLastDayMonth(cal.getActualMaximum(Calendar.DATE));

        List calInfoList = restdeManageService.selectNormalRestdePopup(restde);

        model.addAttribute("resultList", calInfoList);
		
		return "popup/egovframework/com/sym/cal/EgovNormalCalendar";
	}
	
	
	/**
	 * 행정달력 팝업 메인창을 호출한다.
	 * @param model
	 * @return "egovframework/com/sym/cal/EgovAdministCalPopup"
	 * @throws Exception
	 */
	@RequestMapping(value="/sym/cal/EgovAdministCalPopup.do")
 	public String callAdministCalPopup (ModelMap model
 			) throws Exception {
		return "egovframework/com/sym/cal/EgovAdministCalPopup";
	}    
	
	/**
	 * 행정달력 팝업 정보를 조회한다.
	 * @param restde
	 * @param model
	 * @return "egovframework/com/sym/cal/EgovAdministCalendar"
	 * @throws Exception
	 */
	@SuppressWarnings("rawtypes")
	@RequestMapping(value="/sym/cal/EgovselectAdministCalendar.do")
 	public String selectAdministRestdePopup (Restde restde, BindingResult bindingResult
 			, ModelMap model
 			) throws Exception {
		
		//2011.10.18 달력 출력을 위해 필요한 숫자 이외의 값을 사용하는 경우 체크
		bindingResult = checkRestdeWithValidator(restde, bindingResult);
		
		if(bindingResult.hasErrors()){
			
			return "egovframework/com/cmm/error/dataAccessFailure";
						
		}

		Calendar cal = Calendar.getInstance();

		if(restde.getYear()==null || restde.getYear().equals("")){
			restde.setYear(Integer.toString(cal.get(Calendar.YEAR)));
		}
		if(restde.getMonth()==null || restde.getMonth().equals("")){
			restde.setMonth(Integer.toString(cal.get(Calendar.MONTH)+1));
		}
		int iYear  = Integer.parseInt(restde.getYear());
		int iMonth = Integer.parseInt(restde.getMonth());

		if (iMonth<1){
			iYear--;
			iMonth = 12;
		}
		if (iMonth>12){
			iYear++;
			iMonth = 1;
		}
		if (iYear<1){
			iYear = 1;
			iMonth = 1;
		}
		if (iYear>9999){
			iYear = 9999;
			iMonth = 12;
		}
		restde.setYear(Integer.toString(iYear));
		restde.setMonth(Integer.toString(iMonth));
		
		cal.set(iYear,iMonth-1,1);
		
		restde.setStartWeekMonth(cal.get(Calendar.DAY_OF_WEEK));
		restde.setLastDayMonth(cal.getActualMaximum(Calendar.DATE));

        List calInfoList = restdeManageService.selectAdministRestdePopup(restde);

        model.addAttribute("resultList", calInfoList);
		
		return "egovframework/com/sym/cal/EgovAdministCalendar";
	}

	/**
	 * 일반달력 일간
	 * @param restde
	 * @param model
	 * @return "egovframework/com/sym/cal/EgovNormalDayCalendar"
	 * @throws Exception
	 */
	@SuppressWarnings({ "static-access", "rawtypes" })
	@RequestMapping(value="/sym/cal/EgovNormalDayCalendar.do")
 	public String selectNormalDayCalendar (Restde restde, BindingResult bindingResult
 			, ModelMap model
 			) throws Exception {
		
		//2011.10.18 달력 출력을 위해 필요한 숫자 이외의 값을 사용하는 경우 체크
		bindingResult = checkRestdeWithValidator(restde, bindingResult);
		
		if(bindingResult.hasErrors()){
			
			return "egovframework/com/cmm/error/dataAccessFailure";
						
		}

		Calendar cal = Calendar.getInstance();


		if(restde.getYear()==null || restde.getYear().equals("")){
			restde.setYear(Integer.toString(cal.get(Calendar.YEAR)));
		}
		if(restde.getMonth()==null || restde.getMonth().equals("")){
			restde.setMonth(Integer.toString(cal.get(Calendar.MONTH)+1));
		}
		if(restde.getDay()==null || restde.getDay().equals("")){
			restde.setDay(Integer.toString(cal.get(Calendar.DATE)));
		}

		int iYear  = Integer.parseInt(restde.getYear());
		int iMonth = Integer.parseInt(restde.getMonth());
		int iDay   = Integer.parseInt(restde.getDay());
		
		if (iMonth<1){
			iYear--;
			iMonth = 12;
		}
		if (iMonth>12){
			iYear++;
			iMonth = 1;
		}
		if (iYear<1){
			iYear = 1;
			iMonth = 1;
		}
		if (iYear>9999){
			iYear = 9999;
			iMonth = 12;
		}
		restde.setYear(Integer.toString(iYear));
		restde.setMonth(Integer.toString(iMonth));
		
		cal.set(iYear,iMonth-1,iDay);
		restde.setStartWeekMonth(cal.get(Calendar.DAY_OF_WEEK));

		cal.set(iYear,iMonth-1,Integer.parseInt(restde.getDay()));
		restde.setLastDayMonth(cal.getActualMaximum(Calendar.DAY_OF_MONTH));

		restde.setYear(Integer.toString(cal.get(cal.YEAR)));
		restde.setMonth(Integer.toString(cal.get(cal.MONTH)+1));
		restde.setDay(Integer.toString(cal.get(cal.DAY_OF_MONTH)));
		restde.setWeek(cal.get(cal.DAY_OF_WEEK));
		restde.setLastDayMonth(cal.getActualMaximum(Calendar.DATE));
		
		List calInfoList          = restdeManageService.selectNormalDayCal(restde);
        List normalWeekRestdeList = restdeManageService.selectNormalDayRestde(restde);

        model.addAttribute("resultList", calInfoList);
        model.addAttribute("RestdeList", normalWeekRestdeList);
        
		return "egovframework/com/sym/cal/EgovNormalDayCalendar";
	}
	
	/**
	 * 일반달력 주간
	 * @param restde
	 * @param model
	 * @return "egovframework/com/sym/cal/EgovNormalWeekCalendar"
	 * @throws Exception
	 */
	@SuppressWarnings({ "rawtypes", "static-access" })
	@RequestMapping(value="/sym/cal/EgovNormalWeekCalendar.do")
 	public String selectNormalWeekCalendar (Restde restde, BindingResult bindingResult
 			, ModelMap model
 			) throws Exception {
		
		//2011.10.18 달력 출력을 위해 필요한 숫자 이외의 값을 사용하는 경우 체크
		bindingResult = checkRestdeWithValidator(restde, bindingResult);
		
		if(bindingResult.hasErrors()){
			
			return "egovframework/com/cmm/error/dataAccessFailure";
						
		}

		Calendar cal = Calendar.getInstance();

		if(restde.getYear()==null || restde.getYear().equals("")){
			restde.setYear(Integer.toString(cal.get(Calendar.YEAR)));
		}
		if(restde.getMonth()==null || restde.getMonth().equals("")){
			restde.setMonth(Integer.toString(cal.get(Calendar.MONTH)+1));
		}
		if(restde.getDay()==null || restde.getDay().equals("")){
			restde.setDay(Integer.toString(cal.get(Calendar.DATE)));
		}

		int iYear  = Integer.parseInt(restde.getYear());
		int iMonth = Integer.parseInt(restde.getMonth());
		
		if (iMonth<1){
			iYear--;
			iMonth = 12;
		}
		if (iMonth>12){
			iYear++;
			iMonth = 1;
		}
		if (iYear<1){
			iYear = 1;
			iMonth = 1;
		}
		if (iYear>9999){
			iYear = 9999;
			iMonth = 12;
		}
		restde.setYear(Integer.toString(iYear));
		restde.setMonth(Integer.toString(iMonth));
		
		cal.set(iYear,iMonth-1,1);
		restde.setStartWeekMonth(cal.get(Calendar.DAY_OF_WEEK));

		cal.set(iYear,iMonth-1,Integer.parseInt(restde.getDay()));
		restde.setLastDayMonth(cal.getActualMaximum(Calendar.DAY_OF_MONTH));

		int iStartWeek = restde.getStartWeekMonth(); 
		int iLastDate  = restde.getLastDayMonth();
		int iDayWeek  = cal.get(Calendar.DAY_OF_WEEK);
		
		int iMaxWeeks = (int)Math.floor(iLastDate/7);
		iMaxWeeks = iMaxWeeks + (int)Math.ceil(((iLastDate - iMaxWeeks * 7) + iStartWeek - 1) / 7.0);
		restde.setMaxWeeks(iMaxWeeks);
		
		if (iMaxWeeks < restde.getWeeks()) {
			restde.setWeeks(iMaxWeeks);
		}
		
		Restde vo = new Restde();
		Calendar weekCal = Calendar.getInstance();
		weekCal.setTime(cal.getTime());
		
		if(restde.getWeeks()!=0){
			weekCal.set(weekCal.DATE, (restde.getWeeks() - 1) * 7 + 1);
			if(restde.getWeeks()>1){
				iDayWeek  = weekCal.get(weekCal.DAY_OF_WEEK);
				weekCal.add(weekCal.DATE, (-1)*(iDayWeek-1));
			}
			restde.setDay(Integer.toString(weekCal.get(weekCal.DAY_OF_MONTH)+1));
		}

		iDayWeek  = weekCal.get(weekCal.DAY_OF_WEEK);

		// 일요일
		weekCal.add(weekCal.DATE, (-1)*(iDayWeek-1));
		vo.setYear(Integer.toString(weekCal.get(weekCal.YEAR)));
		vo.setMonth(Integer.toString(weekCal.get(weekCal.MONTH)+1));
		vo.setDay(Integer.toString(weekCal.get(weekCal.DAY_OF_MONTH)));
		vo.setWeek(weekCal.get(weekCal.DAY_OF_WEEK));
		List calInfoList1          = restdeManageService.selectNormalDayCal(vo);
        List normalWeekRestdeList1 = restdeManageService.selectNormalDayRestde(vo);

		// 월요일
		weekCal.add(weekCal.DATE, 1);
		vo.setYear(Integer.toString(weekCal.get(weekCal.YEAR)));
		vo.setMonth(Integer.toString(weekCal.get(weekCal.MONTH)+1));
		vo.setDay(Integer.toString(weekCal.get(weekCal.DAY_OF_MONTH)));
		vo.setWeek(weekCal.get(weekCal.DAY_OF_WEEK));
		List calInfoList2          = restdeManageService.selectNormalDayCal(vo);
        List normalWeekRestdeList2 = restdeManageService.selectNormalDayRestde(vo);

		// 화요일
		weekCal.add(weekCal.DATE, 1);
		vo.setYear(Integer.toString(weekCal.get(weekCal.YEAR)));
		vo.setMonth(Integer.toString(weekCal.get(weekCal.MONTH)+1));
		vo.setDay(Integer.toString(weekCal.get(weekCal.DAY_OF_MONTH)));
		vo.setWeek(weekCal.get(weekCal.DAY_OF_WEEK));
		List calInfoList3          = restdeManageService.selectNormalDayCal(vo);
        List normalWeekRestdeList3 = restdeManageService.selectNormalDayRestde(vo);

		// 수요일
		weekCal.add(weekCal.DATE, 1);
		vo.setYear(Integer.toString(weekCal.get(weekCal.YEAR)));
		vo.setMonth(Integer.toString(weekCal.get(weekCal.MONTH)+1));
		vo.setDay(Integer.toString(weekCal.get(weekCal.DAY_OF_MONTH)));
		vo.setWeek(weekCal.get(weekCal.DAY_OF_WEEK));
		List calInfoList4          = restdeManageService.selectNormalDayCal(vo);
        List normalWeekRestdeList4 = restdeManageService.selectNormalDayRestde(vo);

		// 목요일
		weekCal.add(weekCal.DATE, 1);
		vo.setYear(Integer.toString(weekCal.get(weekCal.YEAR)));
		vo.setMonth(Integer.toString(weekCal.get(weekCal.MONTH)+1));
		vo.setDay(Integer.toString(weekCal.get(weekCal.DAY_OF_MONTH)));
		vo.setWeek(weekCal.get(weekCal.DAY_OF_WEEK));
		List calInfoList5          = restdeManageService.selectNormalDayCal(vo);
        List normalWeekRestdeList5 = restdeManageService.selectNormalDayRestde(vo);

		// 금요일
		weekCal.add(weekCal.DATE, 1);
		vo.setYear(Integer.toString(weekCal.get(weekCal.YEAR)));
		vo.setMonth(Integer.toString(weekCal.get(weekCal.MONTH)+1));
		vo.setDay(Integer.toString(weekCal.get(weekCal.DAY_OF_MONTH)));
		vo.setWeek(weekCal.get(weekCal.DAY_OF_WEEK));
		List calInfoList6          = restdeManageService.selectNormalDayCal(vo);
        List normalWeekRestdeList6 = restdeManageService.selectNormalDayRestde(vo);

		// 토요일
		weekCal.add(weekCal.DATE, 1);
		vo.setYear(Integer.toString(weekCal.get(weekCal.YEAR)));
		vo.setMonth(Integer.toString(weekCal.get(weekCal.MONTH)+1));
		vo.setDay(Integer.toString(weekCal.get(weekCal.DAY_OF_MONTH)));
		vo.setWeek(weekCal.get(weekCal.DAY_OF_WEEK));
		List calInfoList7          = restdeManageService.selectNormalDayCal(vo);
        List normalWeekRestdeList7 = restdeManageService.selectNormalDayRestde(vo);

		model.addAttribute("resultList_1", calInfoList1);
        model.addAttribute("resultList_2", calInfoList2);
        model.addAttribute("resultList_3", calInfoList3);
        model.addAttribute("resultList_4", calInfoList4);
        model.addAttribute("resultList_5", calInfoList5);
        model.addAttribute("resultList_6", calInfoList6);
        model.addAttribute("resultList_7", calInfoList7);
        model.addAttribute("RestdeList_1", normalWeekRestdeList1);
        model.addAttribute("RestdeList_2", normalWeekRestdeList2);
        model.addAttribute("RestdeList_3", normalWeekRestdeList3);
        model.addAttribute("RestdeList_4", normalWeekRestdeList4);
        model.addAttribute("RestdeList_5", normalWeekRestdeList5);
        model.addAttribute("RestdeList_6", normalWeekRestdeList6);
        model.addAttribute("RestdeList_7", normalWeekRestdeList7);

		List calInfoList = restdeManageService.selectNormalDayCal(restde);
        model.addAttribute("resultList", calInfoList);
        
        return "egovframework/com/sym/cal/EgovNormalWeekCalendar";
	}	

	/**
	 * 일반달력 월간
	 * @param restde
	 * @param model
	 * @return "egovframework/com/sym/cal/EgovNormalMonthCalendar"
	 * @throws Exception
	 */
	@SuppressWarnings("rawtypes")
	@RequestMapping(value="/sym/cal/EgovNormalMonthCalendar.do")
 	public String selectNormalMonthCalendar (Restde restde, BindingResult bindingResult
 			, ModelMap model
 			) throws Exception {
		
		//2011.10.18 달력 출력을 위해 필요한 숫자 이외의 값을 사용하는 경우 체크
		bindingResult = checkRestdeWithValidator(restde, bindingResult);
		
		if(bindingResult.hasErrors()){
			
			return "egovframework/com/cmm/error/dataAccessFailure";
						
		}

		Calendar cal = Calendar.getInstance();

		if(restde.getYear()==null || restde.getYear().equals("")){
			restde.setYear(Integer.toString(cal.get(Calendar.YEAR)));
		}
		if(restde.getMonth()==null || restde.getMonth().equals("")){
			restde.setMonth(Integer.toString(cal.get(Calendar.MONTH)+1));
		}
		int iYear  = Integer.parseInt(restde.getYear());
		int iMonth = Integer.parseInt(restde.getMonth());

		if (iMonth<1){
			iYear--;
			iMonth = 12;
		}
		if (iMonth>12){
			iYear++;
			iMonth = 1;
		}
		if (iYear<1){
			iYear = 1;
			iMonth = 1;
		}
		if (iYear>9999){
			iYear = 9999;
			iMonth = 12;
		}
		restde.setYear(Integer.toString(iYear));
		restde.setMonth(Integer.toString(iMonth));
		
		cal.set(iYear,iMonth-1,1);
		
		restde.setStartWeekMonth(cal.get(Calendar.DAY_OF_WEEK));
		restde.setLastDayMonth(cal.getActualMaximum(Calendar.DATE));

        List calInfoList = restdeManageService.selectNormalRestdePopup(restde);
        
        
        List normalMonthRestdeList = restdeManageService.selectNormalMonthRestde(restde);
        
        model.addAttribute("resultList", calInfoList);
        model.addAttribute("RestdeList", normalMonthRestdeList);

        return "egovframework/com/sym/cal/EgovNormalMonthCalendar";
	}	
	
	/**
	 * 일반달력 연간
	 * @param restde
	 * @param model
	 * @return "egovframework/com/sym/cal/EgovNormalYearCalendar"
	 * @throws Exception
	 */
	@SuppressWarnings("rawtypes")
	@RequestMapping(value="/sym/cal/EgovNormalYearCalendar.do")
 	public String selectNormalYearCalendar (Restde restde, BindingResult bindingResult
 			, ModelMap model
 			) throws Exception {

		//2011.10.18 달력 출력을 위해 필요한 숫자 이외의 값을 사용하는 경우 체크
		bindingResult = checkRestdeWithValidator(restde, bindingResult);
		
		if(bindingResult.hasErrors()){
			
			return "egovframework/com/cmm/error/dataAccessFailure";
						
		}
		
		Calendar cal = Calendar.getInstance();

		if(restde.getYear()==null || restde.getYear().equals("")){
			restde.setYear(Integer.toString(cal.get(Calendar.YEAR)));
		}
		if(restde.getMonth()==null || restde.getMonth().equals("")){
			restde.setMonth(Integer.toString(cal.get(Calendar.MONTH)+1));
		}
		int iYear  = Integer.parseInt(restde.getYear());
		int iMonth = Integer.parseInt(restde.getMonth());

		if (iMonth<1){
			iYear--;
			iMonth = 12;
		}
		if (iMonth>12){
			iYear++;
			iMonth = 1;
		}
		if (iYear<1){
			iYear = 1;
			iMonth = 1;
		}
		if (iYear>9999){
			iYear = 9999;
			iMonth = 12;
		}
		restde.setYear(Integer.toString(iYear));
		
		/* 월별확인 */

		/* 1월 */
		iMonth = 1;
		restde.setMonth(Integer.toString(iMonth));
		cal.set(iYear,iMonth-1,1);
		restde.setStartWeekMonth(cal.get(Calendar.DAY_OF_WEEK));
		restde.setLastDayMonth(cal.getActualMaximum(Calendar.DATE));
        List calInfoList1 = restdeManageService.selectNormalRestdePopup(restde);
        List normalMonthRestdeList1 = restdeManageService.selectNormalMonthRestde(restde);

		/* 2월 */
		iMonth = 2;
		restde.setMonth(Integer.toString(iMonth));
		cal.set(iYear,iMonth-1,1);
		restde.setStartWeekMonth(cal.get(Calendar.DAY_OF_WEEK));
		restde.setLastDayMonth(cal.getActualMaximum(Calendar.DATE));
        List calInfoList2 = restdeManageService.selectNormalRestdePopup(restde);
        List normalMonthRestdeList2 = restdeManageService.selectNormalMonthRestde(restde);

		/* 3월 */
		iMonth = 3;
		restde.setMonth(Integer.toString(iMonth));
		cal.set(iYear,iMonth-1,1);
		restde.setStartWeekMonth(cal.get(Calendar.DAY_OF_WEEK));
		restde.setLastDayMonth(cal.getActualMaximum(Calendar.DATE));
        List calInfoList3 = restdeManageService.selectNormalRestdePopup(restde);
        List normalMonthRestdeList3 = restdeManageService.selectNormalMonthRestde(restde);

		/* 4월 */
		iMonth = 4;
		restde.setMonth(Integer.toString(iMonth));
		cal.set(iYear,iMonth-1,1);
		restde.setStartWeekMonth(cal.get(Calendar.DAY_OF_WEEK));
		restde.setLastDayMonth(cal.getActualMaximum(Calendar.DATE));
        List calInfoList4 = restdeManageService.selectNormalRestdePopup(restde);
        List normalMonthRestdeList4 = restdeManageService.selectNormalMonthRestde(restde);

		/* 5월 */
		iMonth = 5;
		restde.setMonth(Integer.toString(iMonth));
		cal.set(iYear,iMonth-1,1);
		restde.setStartWeekMonth(cal.get(Calendar.DAY_OF_WEEK));
		restde.setLastDayMonth(cal.getActualMaximum(Calendar.DATE));
        List calInfoList5 = restdeManageService.selectNormalRestdePopup(restde);
        List normalMonthRestdeList5 = restdeManageService.selectNormalMonthRestde(restde);

		/* 6월 */
		iMonth = 6;
		restde.setMonth(Integer.toString(iMonth));
		cal.set(iYear,iMonth-1,1);
		restde.setStartWeekMonth(cal.get(Calendar.DAY_OF_WEEK));
		restde.setLastDayMonth(cal.getActualMaximum(Calendar.DATE));
        List calInfoList6 = restdeManageService.selectNormalRestdePopup(restde);
        List normalMonthRestdeList6 = restdeManageService.selectNormalMonthRestde(restde);

		/* 7월 */
		iMonth = 7;
		restde.setMonth(Integer.toString(iMonth));
		cal.set(iYear,iMonth-1,1);
		restde.setStartWeekMonth(cal.get(Calendar.DAY_OF_WEEK));
		restde.setLastDayMonth(cal.getActualMaximum(Calendar.DATE));
        List calInfoList7 = restdeManageService.selectNormalRestdePopup(restde);
        List normalMonthRestdeList7 = restdeManageService.selectNormalMonthRestde(restde);

		/* 8월 */
		iMonth = 8;
		restde.setMonth(Integer.toString(iMonth));
		cal.set(iYear,iMonth-1,1);
		restde.setStartWeekMonth(cal.get(Calendar.DAY_OF_WEEK));
		restde.setLastDayMonth(cal.getActualMaximum(Calendar.DATE));
        List calInfoList8 = restdeManageService.selectNormalRestdePopup(restde);
        List normalMonthRestdeList8 = restdeManageService.selectNormalMonthRestde(restde);

		/* 9월 */
		iMonth = 9;
		restde.setMonth(Integer.toString(iMonth));
		cal.set(iYear,iMonth-1,1);
		restde.setStartWeekMonth(cal.get(Calendar.DAY_OF_WEEK));
		restde.setLastDayMonth(cal.getActualMaximum(Calendar.DATE));
        List calInfoList9 = restdeManageService.selectNormalRestdePopup(restde);
        List normalMonthRestdeList9 = restdeManageService.selectNormalMonthRestde(restde);

		/* 10월 */
		iMonth = 10;
		restde.setMonth(Integer.toString(iMonth));
		cal.set(iYear,iMonth-1,1);
		restde.setStartWeekMonth(cal.get(Calendar.DAY_OF_WEEK));
		restde.setLastDayMonth(cal.getActualMaximum(Calendar.DATE));
        List calInfoList10 = restdeManageService.selectNormalRestdePopup(restde);
        List normalMonthRestdeList10 = restdeManageService.selectNormalMonthRestde(restde);

		/* 11월 */
		iMonth = 11;
		restde.setMonth(Integer.toString(iMonth));
		cal.set(iYear,iMonth-1,1);
		restde.setStartWeekMonth(cal.get(Calendar.DAY_OF_WEEK));
		restde.setLastDayMonth(cal.getActualMaximum(Calendar.DATE));
        List calInfoList11 = restdeManageService.selectNormalRestdePopup(restde);
        List normalMonthRestdeList11 = restdeManageService.selectNormalMonthRestde(restde);

		/* 12월 */
		iMonth = 12;
		restde.setMonth(Integer.toString(iMonth));
		cal.set(iYear,iMonth-1,1);
		restde.setStartWeekMonth(cal.get(Calendar.DAY_OF_WEEK));
		restde.setLastDayMonth(cal.getActualMaximum(Calendar.DATE));
        List calInfoList12 = restdeManageService.selectNormalRestdePopup(restde);
        List normalMonthRestdeList12 = restdeManageService.selectNormalMonthRestde(restde);
        
        model.addAttribute("resultList_1" , calInfoList1 );
        model.addAttribute("resultList_2" , calInfoList2 );
        model.addAttribute("resultList_3" , calInfoList3 );
        model.addAttribute("resultList_4" , calInfoList4 );
        model.addAttribute("resultList_5" , calInfoList5 );
        model.addAttribute("resultList_6" , calInfoList6 );
        model.addAttribute("resultList_7" , calInfoList7 );
        model.addAttribute("resultList_8" , calInfoList8 );
        model.addAttribute("resultList_9" , calInfoList9 );
        model.addAttribute("resultList_10", calInfoList10);
        model.addAttribute("resultList_11", calInfoList11);
        model.addAttribute("resultList_12", calInfoList12);
        model.addAttribute("RestdeList_1" , normalMonthRestdeList1 );
        model.addAttribute("RestdeList_2" , normalMonthRestdeList2 );
        model.addAttribute("RestdeList_3" , normalMonthRestdeList3 );
        model.addAttribute("RestdeList_4" , normalMonthRestdeList4 );
        model.addAttribute("RestdeList_5" , normalMonthRestdeList5 );
        model.addAttribute("RestdeList_6" , normalMonthRestdeList6 );
        model.addAttribute("RestdeList_7" , normalMonthRestdeList7 );
        model.addAttribute("RestdeList_8" , normalMonthRestdeList8 );
        model.addAttribute("RestdeList_9" , normalMonthRestdeList9 );
        model.addAttribute("RestdeList_10", normalMonthRestdeList10);
        model.addAttribute("RestdeList_11", normalMonthRestdeList11);
        model.addAttribute("RestdeList_12", normalMonthRestdeList12);

        return "egovframework/com/sym/cal/EgovNormalYearCalendar";
	}	
	

	/**
	 * 행정달력 일간
	 * @param restde
	 * @param model
	 * @return "egovframework/com/sym/cal/EgovAdministDayCalendar"
	 * @throws Exception
	 */
	@SuppressWarnings({ "rawtypes", "static-access" })
	@RequestMapping(value="/sym/cal/EgovAdministDayCalendar.do")
 	public String selectAdministDayCalendar (Restde restde, BindingResult bindingResult
 			, ModelMap model
 			) throws Exception {

		//2011.10.18 달력 출력을 위해 필요한 숫자 이외의 값을 사용하는 경우 체크
		bindingResult = checkRestdeWithValidator(restde, bindingResult);
		
		if(bindingResult.hasErrors()){
			
			return "egovframework/com/cmm/error/dataAccessFailure";
						
		}
		
		Calendar cal = Calendar.getInstance();


		if(restde.getYear()==null || restde.getYear().equals("")){
			restde.setYear(Integer.toString(cal.get(Calendar.YEAR)));
		}
		if(restde.getMonth()==null || restde.getMonth().equals("")){
			restde.setMonth(Integer.toString(cal.get(Calendar.MONTH)+1));
		}
		if(restde.getDay()==null || restde.getDay().equals("")){
			restde.setDay(Integer.toString(cal.get(Calendar.DATE)));
		}

		int iYear  = Integer.parseInt(restde.getYear());
		int iMonth = Integer.parseInt(restde.getMonth());
		int iDay   = Integer.parseInt(restde.getDay());
		
		if (iMonth<1){
			iYear--;
			iMonth = 12;
		}
		if (iMonth>12){
			iYear++;
			iMonth = 1;
		}
		if (iYear<1){
			iYear = 1;
			iMonth = 1;
		}
		if (iYear>9999){
			iYear = 9999;
			iMonth = 12;
		}
		restde.setYear(Integer.toString(iYear));
		restde.setMonth(Integer.toString(iMonth));
		
		cal.set(iYear,iMonth-1,iDay);
		restde.setStartWeekMonth(cal.get(Calendar.DAY_OF_WEEK));

		cal.set(iYear,iMonth-1,Integer.parseInt(restde.getDay()));
		restde.setLastDayMonth(cal.getActualMaximum(Calendar.DAY_OF_MONTH));

		restde.setYear(Integer.toString(cal.get(cal.YEAR)));
		restde.setMonth(Integer.toString(cal.get(cal.MONTH)+1));
		restde.setDay(Integer.toString(cal.get(cal.DAY_OF_MONTH)));
		restde.setWeek(cal.get(cal.DAY_OF_WEEK));
		restde.setLastDayMonth(cal.getActualMaximum(Calendar.DATE));
		
		List calInfoList          = restdeManageService.selectAdministDayCal(restde);
        List administWeekRestdeList = restdeManageService.selectAdministDayRestde(restde);

        model.addAttribute("resultList", calInfoList);
        model.addAttribute("RestdeList", administWeekRestdeList);
        
		return "egovframework/com/sym/cal/EgovAdministDayCalendar";
	}
	

	/**
	 * 행정달력 주간
	 * @param restde
	 * @param model
	 * @return "egovframework/com/sym/cal/EgovAdministWeekCalendar"
	 * @throws Exception
	 */
	@SuppressWarnings({ "static-access", "rawtypes" })
	@RequestMapping(value="/sym/cal/EgovAdministWeekCalendar.do")
 	public String selectAdministWeekCalendar (Restde restde, BindingResult bindingResult
 			, ModelMap model
 			) throws Exception {

		//2011.10.18 달력 출력을 위해 필요한 숫자 이외의 값을 사용하는 경우 체크
		bindingResult = checkRestdeWithValidator(restde, bindingResult);
		
		if(bindingResult.hasErrors()){
			
			return "egovframework/com/cmm/error/dataAccessFailure";
						
		}
		
		Calendar cal = Calendar.getInstance();

		if(restde.getYear()==null || restde.getYear().equals("")){
			restde.setYear(Integer.toString(cal.get(Calendar.YEAR)));
		}
		if(restde.getMonth()==null || restde.getMonth().equals("")){
			restde.setMonth(Integer.toString(cal.get(Calendar.MONTH)+1));
		}
		if(restde.getDay()==null || restde.getDay().equals("")){
			restde.setDay(Integer.toString(cal.get(Calendar.DATE)));
		}

		int iYear  = Integer.parseInt(restde.getYear());
		int iMonth = Integer.parseInt(restde.getMonth());
		
		if (iMonth<1){
			iYear--;
			iMonth = 12;
		}
		if (iMonth>12){
			iYear++;
			iMonth = 1;
		}
		if (iYear<1){
			iYear = 1;
			iMonth = 1;
		}
		if (iYear>9999){
			iYear = 9999;
			iMonth = 12;
		}
		restde.setYear(Integer.toString(iYear));
		restde.setMonth(Integer.toString(iMonth));
		
		cal.set(iYear,iMonth-1,1);
		restde.setStartWeekMonth(cal.get(Calendar.DAY_OF_WEEK));

		cal.set(iYear,iMonth-1,Integer.parseInt(restde.getDay()));
		restde.setLastDayMonth(cal.getActualMaximum(Calendar.DAY_OF_MONTH));

		int iStartWeek = restde.getStartWeekMonth(); 
		int iLastDate  = restde.getLastDayMonth();
		int iDayWeek  = cal.get(Calendar.DAY_OF_WEEK);
		
		int iMaxWeeks = (int)Math.floor(iLastDate/7);
		iMaxWeeks = iMaxWeeks + (int)Math.ceil(((iLastDate - iMaxWeeks * 7) + iStartWeek - 1) / 7.0);
		restde.setMaxWeeks(iMaxWeeks);
		
		if (iMaxWeeks < restde.getWeeks()) {
			restde.setWeeks(iMaxWeeks);
		}

		Restde vo = new Restde();
		Calendar weekCal = Calendar.getInstance();
		weekCal.setTime(cal.getTime());
		
		if(restde.getWeeks()!=0){
			weekCal.set(weekCal.DATE, (restde.getWeeks() - 1) * 7 + 1);
			if(restde.getWeeks()>1){
				iDayWeek  = weekCal.get(weekCal.DAY_OF_WEEK);
				weekCal.add(weekCal.DATE, (-1)*(iDayWeek-1));
			}
			restde.setDay(Integer.toString(weekCal.get(weekCal.DAY_OF_MONTH)+1));
		}
		List calInfoList = restdeManageService.selectAdministDayCal(restde);

		iDayWeek  = weekCal.get(weekCal.DAY_OF_WEEK);

		// 일요일
		weekCal.add(weekCal.DATE, (-1)*(iDayWeek-1));
		vo.setYear(Integer.toString(weekCal.get(weekCal.YEAR)));
		vo.setMonth(Integer.toString(weekCal.get(weekCal.MONTH)+1));
		vo.setDay(Integer.toString(weekCal.get(weekCal.DAY_OF_MONTH)));
		vo.setWeek(weekCal.get(weekCal.DAY_OF_WEEK));
		List calInfoList1          = restdeManageService.selectAdministDayCal(vo);
        List administWeekRestdeList1 = restdeManageService.selectAdministDayRestde(vo);

		// 월요일
		weekCal.add(weekCal.DATE, 1);
		vo.setYear(Integer.toString(weekCal.get(weekCal.YEAR)));
		vo.setMonth(Integer.toString(weekCal.get(weekCal.MONTH)+1));
		vo.setDay(Integer.toString(weekCal.get(weekCal.DAY_OF_MONTH)));
		vo.setWeek(weekCal.get(weekCal.DAY_OF_WEEK));
		List calInfoList2          = restdeManageService.selectAdministDayCal(vo);
        List administWeekRestdeList2 = restdeManageService.selectAdministDayRestde(vo);

		// 화요일
		weekCal.add(weekCal.DATE, 1);
		vo.setYear(Integer.toString(weekCal.get(weekCal.YEAR)));
		vo.setMonth(Integer.toString(weekCal.get(weekCal.MONTH)+1));
		vo.setDay(Integer.toString(weekCal.get(weekCal.DAY_OF_MONTH)));
		vo.setWeek(weekCal.get(weekCal.DAY_OF_WEEK));
		List calInfoList3          = restdeManageService.selectAdministDayCal(vo);
        List administWeekRestdeList3 = restdeManageService.selectAdministDayRestde(vo);

		// 수요일
		weekCal.add(weekCal.DATE, 1);
		vo.setYear(Integer.toString(weekCal.get(weekCal.YEAR)));
		vo.setMonth(Integer.toString(weekCal.get(weekCal.MONTH)+1));
		vo.setDay(Integer.toString(weekCal.get(weekCal.DAY_OF_MONTH)));
		vo.setWeek(weekCal.get(weekCal.DAY_OF_WEEK));
		List calInfoList4          = restdeManageService.selectAdministDayCal(vo);
        List administWeekRestdeList4 = restdeManageService.selectAdministDayRestde(vo);

		// 목요일
		weekCal.add(weekCal.DATE, 1);
		vo.setYear(Integer.toString(weekCal.get(weekCal.YEAR)));
		vo.setMonth(Integer.toString(weekCal.get(weekCal.MONTH)+1));
		vo.setDay(Integer.toString(weekCal.get(weekCal.DAY_OF_MONTH)));
		vo.setWeek(weekCal.get(weekCal.DAY_OF_WEEK));
		List calInfoList5          = restdeManageService.selectAdministDayCal(vo);
        List administWeekRestdeList5 = restdeManageService.selectAdministDayRestde(vo);

		// 금요일
		weekCal.add(weekCal.DATE, 1);
		vo.setYear(Integer.toString(weekCal.get(weekCal.YEAR)));
		vo.setMonth(Integer.toString(weekCal.get(weekCal.MONTH)+1));
		vo.setDay(Integer.toString(weekCal.get(weekCal.DAY_OF_MONTH)));
		vo.setWeek(weekCal.get(weekCal.DAY_OF_WEEK));
		List calInfoList6          = restdeManageService.selectAdministDayCal(vo);
        List administWeekRestdeList6 = restdeManageService.selectAdministDayRestde(vo);

		// 토요일
		weekCal.add(weekCal.DATE, 1);
		vo.setYear(Integer.toString(weekCal.get(weekCal.YEAR)));
		vo.setMonth(Integer.toString(weekCal.get(weekCal.MONTH)+1));
		vo.setDay(Integer.toString(weekCal.get(weekCal.DAY_OF_MONTH)));
		vo.setWeek(weekCal.get(weekCal.DAY_OF_WEEK));
		List calInfoList7          = restdeManageService.selectAdministDayCal(vo);
        List administWeekRestdeList7 = restdeManageService.selectAdministDayRestde(vo);

        model.addAttribute("resultList_1", calInfoList1);
        model.addAttribute("resultList_2", calInfoList2);
        model.addAttribute("resultList_3", calInfoList3);
        model.addAttribute("resultList_4", calInfoList4);
        model.addAttribute("resultList_5", calInfoList5);
        model.addAttribute("resultList_6", calInfoList6);
        model.addAttribute("resultList_7", calInfoList7);
        model.addAttribute("RestdeList_1", administWeekRestdeList1);
        model.addAttribute("RestdeList_2", administWeekRestdeList2);
        model.addAttribute("RestdeList_3", administWeekRestdeList3);
        model.addAttribute("RestdeList_4", administWeekRestdeList4);
        model.addAttribute("RestdeList_5", administWeekRestdeList5);
        model.addAttribute("RestdeList_6", administWeekRestdeList6);
        model.addAttribute("RestdeList_7", administWeekRestdeList7);

        model.addAttribute("resultList", calInfoList);

		return "egovframework/com/sym/cal/EgovAdministWeekCalendar";
	}
	
	/**
	 * 행정달력 월간
	 * @param restde
	 * @param model
	 * @return "egovframework/com/sym/cal/EgovAdministMonthCalendar"
	 * @throws Exception
	 */
	@SuppressWarnings("rawtypes")
	@RequestMapping(value="/sym/cal/EgovAdministMonthCalendar.do")
 	public String selectAdministMonthCalendar (Restde restde, BindingResult bindingResult
 			, ModelMap model
 			) throws Exception {

		//2011.10.18 달력 출력을 위해 필요한 숫자 이외의 값을 사용하는 경우 체크
		bindingResult = checkRestdeWithValidator(restde, bindingResult);
		
		if(bindingResult.hasErrors()){
			
			return "egovframework/com/cmm/error/dataAccessFailure";
						
		}
		
		Calendar cal = Calendar.getInstance();

		if(restde.getYear()==null || restde.getYear().equals("")){
			restde.setYear(Integer.toString(cal.get(Calendar.YEAR)));
		}
		if(restde.getMonth()==null || restde.getMonth().equals("")){
			restde.setMonth(Integer.toString(cal.get(Calendar.MONTH)+1));
		}
		int iYear  = Integer.parseInt(restde.getYear());
		int iMonth = Integer.parseInt(restde.getMonth());

		if (iMonth<1){
			iYear--;
			iMonth = 12;
		}
		if (iMonth>12){
			iYear++;
			iMonth = 1;
		}
		if (iYear<1){
			iYear = 1;
			iMonth = 1;
		}
		if (iYear>9999){
			iYear = 9999;
			iMonth = 12;
		}
		restde.setYear(Integer.toString(iYear));
		restde.setMonth(Integer.toString(iMonth));
		
		cal.set(iYear,iMonth-1,1);
		
		restde.setStartWeekMonth(cal.get(Calendar.DAY_OF_WEEK));
		restde.setLastDayMonth(cal.getActualMaximum(Calendar.DATE));

        List calInfoList = restdeManageService.selectAdministRestdePopup(restde);
        
        
        List administMonthRestdeList = restdeManageService.selectAdministMonthRestde(restde);
        
        model.addAttribute("resultList", calInfoList);
        model.addAttribute("RestdeList", administMonthRestdeList);

        return "egovframework/com/sym/cal/EgovAdministMonthCalendar";
	}	


	/**
	 * 행정달력 연간
	 * @param restde
	 * @param model
	 * @return "egovframework/com/sym/cal/EgovAdministYearCalendar"
	 * @throws Exception
	 */
	@SuppressWarnings("rawtypes")
	@RequestMapping(value="/sym/cal/EgovAdministYearCalendar.do")
 	public String selectAdministYearCalendar (Restde restde, BindingResult bindingResult
 			, ModelMap model
 			) throws Exception {

		//2011.10.18 달력 출력을 위해 필요한 숫자 이외의 값을 사용하는 경우 체크
		bindingResult = checkRestdeWithValidator(restde, bindingResult);
		
		if(bindingResult.hasErrors()){
			
			return "egovframework/com/cmm/error/dataAccessFailure";
						
		}
		
		Calendar cal = Calendar.getInstance();

		if(restde.getYear()==null || restde.getYear().equals("")){
			restde.setYear(Integer.toString(cal.get(Calendar.YEAR)));
		}
		if(restde.getMonth()==null || restde.getMonth().equals("")){
			restde.setMonth(Integer.toString(cal.get(Calendar.MONTH)+1));
		}
		int iYear  = Integer.parseInt(restde.getYear());
		int iMonth = Integer.parseInt(restde.getMonth());

		if (iMonth<1){
			iYear--;
			iMonth = 12;
		}
		if (iMonth>12){
			iYear++;
			iMonth = 1;
		}
		if (iYear<1){
			iYear = 1;
			iMonth = 1;
		}
		if (iYear>9999){
			iYear = 9999;
			iMonth = 12;
		}
		restde.setYear(Integer.toString(iYear));
		
		/* 월별확인 */

		/* 1월 */
		iMonth = 1;
		restde.setMonth(Integer.toString(iMonth));
		cal.set(iYear,iMonth-1,1);
		restde.setStartWeekMonth(cal.get(Calendar.DAY_OF_WEEK));
		restde.setLastDayMonth(cal.getActualMaximum(Calendar.DATE));
        List calInfoList1 = restdeManageService.selectAdministRestdePopup(restde);
        List administMonthRestdeList1 = restdeManageService.selectAdministMonthRestde(restde);

		/* 2월 */
		iMonth = 2;
		restde.setMonth(Integer.toString(iMonth));
		cal.set(iYear,iMonth-1,1);
		restde.setStartWeekMonth(cal.get(Calendar.DAY_OF_WEEK));
		restde.setLastDayMonth(cal.getActualMaximum(Calendar.DATE));
        List calInfoList2 = restdeManageService.selectAdministRestdePopup(restde);
        List administMonthRestdeList2 = restdeManageService.selectAdministMonthRestde(restde);

		/* 3월 */
		iMonth = 3;
		restde.setMonth(Integer.toString(iMonth));
		cal.set(iYear,iMonth-1,1);
		restde.setStartWeekMonth(cal.get(Calendar.DAY_OF_WEEK));
		restde.setLastDayMonth(cal.getActualMaximum(Calendar.DATE));
        List calInfoList3 = restdeManageService.selectAdministRestdePopup(restde);
        List administMonthRestdeList3 = restdeManageService.selectAdministMonthRestde(restde);

		/* 4월 */
		iMonth = 4;
		restde.setMonth(Integer.toString(iMonth));
		cal.set(iYear,iMonth-1,1);
		restde.setStartWeekMonth(cal.get(Calendar.DAY_OF_WEEK));
		restde.setLastDayMonth(cal.getActualMaximum(Calendar.DATE));
        List calInfoList4 = restdeManageService.selectAdministRestdePopup(restde);
        List administMonthRestdeList4 = restdeManageService.selectAdministMonthRestde(restde);

		/* 5월 */
		iMonth = 5;
		restde.setMonth(Integer.toString(iMonth));
		cal.set(iYear,iMonth-1,1);
		restde.setStartWeekMonth(cal.get(Calendar.DAY_OF_WEEK));
		restde.setLastDayMonth(cal.getActualMaximum(Calendar.DATE));
        List calInfoList5 = restdeManageService.selectAdministRestdePopup(restde);
        List administMonthRestdeList5 = restdeManageService.selectAdministMonthRestde(restde);

		/* 6월 */
		iMonth = 6;
		restde.setMonth(Integer.toString(iMonth));
		cal.set(iYear,iMonth-1,1);
		restde.setStartWeekMonth(cal.get(Calendar.DAY_OF_WEEK));
		restde.setLastDayMonth(cal.getActualMaximum(Calendar.DATE));
        List calInfoList6 = restdeManageService.selectAdministRestdePopup(restde);
        List administMonthRestdeList6 = restdeManageService.selectAdministMonthRestde(restde);

		/* 7월 */
		iMonth = 7;
		restde.setMonth(Integer.toString(iMonth));
		cal.set(iYear,iMonth-1,1);
		restde.setStartWeekMonth(cal.get(Calendar.DAY_OF_WEEK));
		restde.setLastDayMonth(cal.getActualMaximum(Calendar.DATE));
        List calInfoList7 = restdeManageService.selectAdministRestdePopup(restde);
        List administMonthRestdeList7 = restdeManageService.selectAdministMonthRestde(restde);

		/* 8월 */
		iMonth = 8;
		restde.setMonth(Integer.toString(iMonth));
		cal.set(iYear,iMonth-1,1);
		restde.setStartWeekMonth(cal.get(Calendar.DAY_OF_WEEK));
		restde.setLastDayMonth(cal.getActualMaximum(Calendar.DATE));
        List calInfoList8 = restdeManageService.selectAdministRestdePopup(restde);
        List administMonthRestdeList8 = restdeManageService.selectAdministMonthRestde(restde);

		/* 9월 */
		iMonth = 9;
		restde.setMonth(Integer.toString(iMonth));
		cal.set(iYear,iMonth-1,1);
		restde.setStartWeekMonth(cal.get(Calendar.DAY_OF_WEEK));
		restde.setLastDayMonth(cal.getActualMaximum(Calendar.DATE));
        List calInfoList9 = restdeManageService.selectAdministRestdePopup(restde);
        List administMonthRestdeList9 = restdeManageService.selectAdministMonthRestde(restde);

		/* 10월 */
		iMonth = 10;
		restde.setMonth(Integer.toString(iMonth));
		cal.set(iYear,iMonth-1,1);
		restde.setStartWeekMonth(cal.get(Calendar.DAY_OF_WEEK));
		restde.setLastDayMonth(cal.getActualMaximum(Calendar.DATE));
        List calInfoList10 = restdeManageService.selectAdministRestdePopup(restde);
        List administMonthRestdeList10 = restdeManageService.selectAdministMonthRestde(restde);

		/* 11월 */
		iMonth = 11;
		restde.setMonth(Integer.toString(iMonth));
		cal.set(iYear,iMonth-1,1);
		restde.setStartWeekMonth(cal.get(Calendar.DAY_OF_WEEK));
		restde.setLastDayMonth(cal.getActualMaximum(Calendar.DATE));
        List calInfoList11 = restdeManageService.selectAdministRestdePopup(restde);
        List administMonthRestdeList11 = restdeManageService.selectAdministMonthRestde(restde);

		/* 12월 */
		iMonth = 12;
		restde.setMonth(Integer.toString(iMonth));
		cal.set(iYear,iMonth-1,1);
		restde.setStartWeekMonth(cal.get(Calendar.DAY_OF_WEEK));
		restde.setLastDayMonth(cal.getActualMaximum(Calendar.DATE));
        List calInfoList12 = restdeManageService.selectAdministRestdePopup(restde);
        List administMonthRestdeList12 = restdeManageService.selectAdministMonthRestde(restde);
        
        model.addAttribute("resultList_1" , calInfoList1 );
        model.addAttribute("resultList_2" , calInfoList2 );
        model.addAttribute("resultList_3" , calInfoList3 );
        model.addAttribute("resultList_4" , calInfoList4 );
        model.addAttribute("resultList_5" , calInfoList5 );
        model.addAttribute("resultList_6" , calInfoList6 );
        model.addAttribute("resultList_7" , calInfoList7 );
        model.addAttribute("resultList_8" , calInfoList8 );
        model.addAttribute("resultList_9" , calInfoList9 );
        model.addAttribute("resultList_10", calInfoList10);
        model.addAttribute("resultList_11", calInfoList11);
        model.addAttribute("resultList_12", calInfoList12);
        model.addAttribute("RestdeList_1" , administMonthRestdeList1 );
        model.addAttribute("RestdeList_2" , administMonthRestdeList2 );
        model.addAttribute("RestdeList_3" , administMonthRestdeList3 );
        model.addAttribute("RestdeList_4" , administMonthRestdeList4 );
        model.addAttribute("RestdeList_5" , administMonthRestdeList5 );
        model.addAttribute("RestdeList_6" , administMonthRestdeList6 );
        model.addAttribute("RestdeList_7" , administMonthRestdeList7 );
        model.addAttribute("RestdeList_8" , administMonthRestdeList8 );
        model.addAttribute("RestdeList_9" , administMonthRestdeList9 );
        model.addAttribute("RestdeList_10", administMonthRestdeList10);
        model.addAttribute("RestdeList_11", administMonthRestdeList11);
        model.addAttribute("RestdeList_12", administMonthRestdeList12);

        return "egovframework/com/sym/cal/EgovAdministYearCalendar";
	}	
	

	/**
	 * 휴일을 삭제한다.
	 * @param loginVO
	 * @param restde
	 * @param model
	 * @return "forward:/sym/cal/EgovRestdeList.do"
	 * @throws Exception
	 */
    @RequestMapping(value="/sym/cal/EgovRestdeRemove.do")
	public ModelAndView deleteRestde (@RequestParam(required = true) String restdeNo
			//@ModelAttribute("loginVO") LoginVO loginVO
			//, Restde restde
			//, ModelMap model
			) throws Exception {
    	int result = -9;
		ModelAndView mv = new ModelAndView();	
		
		try{
			restdeManageService.deleteRestde(restdeNo);
	    	result = 0;
		}catch(Exception e){
			 result = -9;
		}	
		mv.setViewName("jsonView");
		mv.addObject("result", result);	// data.result
		return mv;	
	}


    /**
     * 휴일을 등록한다.
     * @param loginVO
     * @param restde
     * @param bindingResult
     * @param model
     * @return "egovframework/com/sym/cal/EgovRestdeRegist"
     * @throws Exception
     */
    @RequestMapping(value="/sym/cal/EgovRestdeRegist.do")
	public ModelAndView insertRestde (//@ModelAttribute("loginVO") LoginVO loginVO,
			@ModelAttribute("restde") Restde restde
			//, BindingResult bindingResult
			//, ModelMap model
			) throws Exception {

    	int result = -9;
		ModelAndView mv = new ModelAndView();	
		
        //beanValidator.validate(restde, bindingResult);
		//if (bindingResult.hasErrors()){
        //    return "egovframework/com/sym/cal/EgovRestdeRegist";
		//}


    	
    	if   (restde.getRestdeDe() == null||restde.getRestdeDe().equals("")) 
    	{
    		result = -8;    	
    	}
    	else
    	{
        	// 1. Spring Security 사용자권한 처리
        	Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();
        	
        	if(isAuthenticated) {
            	LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();     

        		try{		
        	    	restde.setRestdeNo(idgenService.getNextIntegerId()%1000000);
        	    	restde.setFrstRegisterId(loginVO.getUniqId());    	    	
        	    	restdeManageService.insertRestde(restde);
        	    	result = 0;
        		}catch(Exception e){
        			result = -9;
        		}
        	}else{
    	    	result = 100;    		
        	}
		}
	
		mv.setViewName("jsonView");
		mv.addObject("result", result);	// data.result
		return mv;	
    }


    /**
     * 휴일 세부내역을 조회한다.
     * @param loginVO
     * @param restde
     * @param model
     * @return "egovframework/com/sym/cal/EgovRestdeDetail"
     * @throws Exception
	@RequestMapping(value="/sym/cal/EgovRestdeDetail.do")
 	public String selectRestdeDetail (@ModelAttribute("loginVO") LoginVO loginVO
 			, Restde restde
 			, ModelMap model
 			) throws Exception {
		Restde vo = restdeManageService.selectRestdeDetail(restde);
		model.addAttribute("result", vo);
		
		return "egovframework/com/sym/cal/EgovRestdeDetail";
	}
     */


	/**
	 * 휴일 상세 정보를 불러온다
	 * @param clCode
	 * @return ModelAndView
	 * @throws Exception
	 */
    @RequestMapping(value="/sym/cal/govRestdeDc.do")
	public ModelAndView selectRestdeDc (@RequestParam(required = true) String restdeNo) throws Exception {
    	
    	String restdeDc = null;
    	int result = -9;
		ModelAndView mv = new ModelAndView();			
		
		if(EgovStringUtil.isEmpty(restdeNo)){
			result = -9;

		}else{
			try{	  	
				restdeDc = restdeManageService.selectRestdeDc(restdeNo);  //  CmmnCodeManageDAO.selectCcmCmmnCodeDc
				result = 0;
			}catch(Exception e){
				result = -9;
			}			
		}
		mv.setViewName("jsonView");
		mv.addObject("restdeDc", restdeDc);	// data.restdeDc
		mv.addObject("result", result);	// data.result
		
		return mv;	 
    }
    /**
	 * 휴일 리스트를 조회한다.
     * @param loginVO
     * @param searchVO
     * @param model
     * @return "egovframework/com/sym/cal/EgovRestdeList"
     * @throws Exception
     */
	@SuppressWarnings("rawtypes")
	@IncludedInfo(name="공휴일관리(달력)", listUrl="/sym/cal/EgovRestdeList.do", order = 1300 ,gid = 90)
    @RequestMapping(value="/sym/cal/EgovRestdeList.do")
	public String selectRestdeList (//@ModelAttribute("loginVO") LoginVO loginVO, 
			@ModelAttribute("searchVO") RestdeVO searchVO
			, ModelMap model
			) throws Exception {
    	/** EgovPropertyService.sample */
    	searchVO.setPageUnit(propertiesService.getInt("pageUnit"));
    	searchVO.setPageSize(propertiesService.getInt("pageSize"));

    	/** pageing */
    	PaginationInfo paginationInfo = new PaginationInfo();
		paginationInfo.setCurrentPageNo(searchVO.getPageIndex());
		paginationInfo.setRecordCountPerPage(searchVO.getPageUnit());
		paginationInfo.setPageSize(searchVO.getPageSize());
		
		searchVO.setFirstIndex(paginationInfo.getFirstRecordIndex());
		searchVO.setLastIndex(paginationInfo.getLastRecordIndex());
		searchVO.setRecordCountPerPage(paginationInfo.getRecordCountPerPage());
		
        List cmmnCodeList = restdeManageService.selectRestdeList(searchVO);
        //model.addAttribute("resultList", CmmnCodeList);
		JSONArray  jsonArr = JSONArray.fromObject(cmmnCodeList);
		model.addAttribute("resultList", jsonArr);
        
        int totCnt = restdeManageService.selectRestdeListTotCnt(searchVO);
		paginationInfo.setTotalRecordCount(totCnt);
        model.addAttribute("paginationInfo", paginationInfo);
        

        //  휴일구분 가져오기 
		ComDefaultCodeVO vo = new ComDefaultCodeVO();
		vo.setCodeId("COM017");
        List restdeCodeList = cmmUseService.selectCmmCodeDetail(vo);
		jsonArr = JSONArray.fromObject(restdeCodeList);
		model.addAttribute("restdeCode", jsonArr);
        //  ---------------------------
        return "egovframework/com/sym/cal/EgovRestdeList";
	}

    /**
	 * 휴일을 수정한다.
     * @param loginVO
     * @param restde
     * @param bindingResult
     * @param commandMap
     * @param model
     * @return "egovframework/com/sym/cal/EgovRestdeModify"
     * @throws Exception
     */
    @RequestMapping(value="/sym/cal/EgovRestdeModify.do")
	public ModelAndView updateRestde (//@ModelAttribute("loginVO") LoginVO loginVO, 
			@ModelAttribute("restde") Restde restde
			//, BindingResult bindingResult
			//, Map commandMap
			//, ModelMap model
			) throws Exception {
    	
    	
    	/*
		String sCmd = commandMap.get("cmd") == null ? "" : (String)commandMap.get("cmd");

		//if(EgovStringUtil.isEmpty(sCmd)){
    	if (sCmd.equals("Modify")) {
            beanValidator.validate(restde, bindingResult);
    		if (bindingResult.hasErrors()){
        		ComDefaultCodeVO CodeVO = new ComDefaultCodeVO();
        		CodeVO.setCodeId("COM017");
                List restdeCodeList = cmmUseService.selectCmmCodeDetail(CodeVO);
                model.addAttribute("restdeCode", restdeCodeList);

                return "egovframework/com/sym/cal/EgovRestdeModify";
    		}

    		restde.setLastUpdusrId(loginVO.getUniqId());
    		restdeManageService.updateRestde(restde);
	        return "forward:/sym/cal/EgovRestdeList.do";
    	}
    	*/

    	int result = -9;
		ModelAndView mv = new ModelAndView();	
    	
		
    	// 1. Spring Security 사용자권한 처리
    	Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();
    	
    	if(isAuthenticated) {
        	LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();        	

    		try{		
    			restde.setLastUpdusrId(loginVO.getUniqId());
    			restdeManageService.updateRestde(restde);
    			result = 0;
    		}catch(Exception e){
    			result = -9;
    		}
    	}else{
	    	result = 100;    		
    	}
    	
		mv.setViewName("jsonView");
		mv.addObject("result", result);	// data.result
		
		return mv;	
    }

    /**
     * 사용자정보 엑셀 샘플 다운로드
     * 
     * @return
     * @throws Exception
     */
    @RequestMapping("/sym/cal/restdeExcelDown.do")
    public View restdeExcelDown(HttpServletRequest request, ModelMap model, HttpServletResponse response,Map<String, Object> modelMap) throws Exception{
        List<String> colName = new ArrayList<String>();
        List<String[]> colValue = new ArrayList<String[]>();
        colName.add(BizboxAMessage.getMessage("TX000006841","휴일명"));
        colName.add(BizboxAMessage.getMessage("TX000000480","날짜"));
            
        String[] colval = {BizboxAMessage.getMessage("TX000011945","식목일"),"20130405"};
		colValue.add(colval);
		
		modelMap.put("ExcelName", "restde_"+DateUtil.getToday("yyyyMMdd"));
		modelMap.put("ColName", colName);
		modelMap.put("ColValue", colValue);

		return new NeosExcelView();
    }
    /**
     * 엑셀 업로드 폼
     * 
     * @return
     * @throws Exception
     */
    //@RequestMapping("/PortalGuide.do")
    @RequestMapping("/sym/cal/com/restdeExcelUploadForm.do")
    public String restdeExcelUploadForm(HttpServletRequest request, ModelMap model) throws Exception{
        
        //return "/portal/PortalGuide";
        return "/egovframework/com/sym/cal/com/restdeExcelUploadForm";
    }
    
//    /**
//     * 엑셀 업로드  및 처리
//     * 
//     * @return
//     * @throws Exception
//     */    
//    @RequestMapping("/sym/cal/restdeExcelUploadProc.do")
//    public String restdeExcelUploadProc(final MultipartHttpServletRequest multiRequest, ModelMap model, HttpServletRequest request, @ModelAttribute("FileUploadVO") FileUploadVO fileUploadVO) throws Exception{
//        
//    	final Map<String, MultipartFile> files = multiRequest.getFileMap();
//    	List<FileVO> result = null;
//    	
//    	LoginVO user = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
//    	NeosExcelUtil excelUtil = new NeosExcelUtil();
//    	try{
//    		if (!files.isEmpty()) {
//    			String KeyStr = "";
//    			String storePath = egovMessageSource.getMessage("upload.mobile.file.path." + NeosConstants.SERVER_OS);
//    			storePath = storePath + "_temp/";
//    			result = fileUtil.parseFileInfPortal(files, KeyStr, 0, "", storePath);
//    			if(result.size()>0){
//    				// 파일정보
//    				FileVO fileVo = (FileVO)result.get(0);
//    				File file = new File(storePath + fileVo.getStreFileNm());
//    				List<Restde> restdeList = excelUtil.restdeList(file, idgenService, user.getUniqId());
//    				for(int i = 0;i < restdeList.size(); i++){
//    					try {
//    						restdeManageService.insertRestde(restdeList.get(i));
//    					} catch (Exception e) {
//    						//System.out.println(e);
//    					}
//    				}
//    			}
//
//    		}
//    		if(excelUtil.getErrCount() > 0){
//    			excelUtil.setErrCount(0);
//    			model.addAttribute("err_code", "0001");
//    		}else{
//    			model.addAttribute("err_code", "0000");
//    		}
//    	}catch(Exception e){
//    		model.addAttribute("err_code", "9999");
//    		model.addAttribute("err_msg", e);
//    	}
//        return "egovframework/com/sym/cal/restdeExcelUploadProc";
//    }
}