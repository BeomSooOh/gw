package neos.cmm.systemx.holiday.web;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import bizbox.orgchart.service.vo.LoginVO;
import egovframework.com.cmm.annotation.IncludedInfo;
import egovframework.com.cmm.util.EgovUserDetailsHelper;
import egovframework.com.utl.fcc.service.EgovStringUtil;
import main.web.BizboxAMessage;
import neos.cmm.menu.service.MenuManageService;
import neos.cmm.systemx.holiday.service.HolidayManageService;
import neos.cmm.systemx.comp.service.CompManageService;
import net.sf.json.JSONArray;









import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
 
import java.util.HashMap;
import java.util.Iterator;
import java.util.TreeMap;

import com.ibm.icu.util.ChineseCalendar;



@Controller
public class HolidayManageController {
	@Resource(name = "HolidayManageService")
	private HolidayManageService holidayManageService;
	
	@Resource(name = "CompManageService")
	private CompManageService compService;
	
	@Resource(name="MenuManageService")
	private MenuManageService menuManageService;

	
	@IncludedInfo(name="공휴일관리", order = 251 ,gid = 96)
	@RequestMapping("/cmm/systemx/holidayManageView.do")
	public ModelAndView holidayManageView(@RequestParam Map<String,Object> params, HttpServletRequest request) throws Exception {
		ModelAndView mv = new ModelAndView();
		
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();		
		
		boolean isAuthMenu = menuManageService.checkIsAuthMenu(params, loginVO);
		if(!isAuthMenu){
			mv.setViewName("redirect:/forwardIndex.do");			
			return mv;
		}
		
		String compSeq = params.get("compSeq") + "";
		
		if(!loginVO.getUserSe().equals("MASTER")){
			if (EgovStringUtil.isEmpty(compSeq)) {
				compSeq = loginVO.getCompSeq();	
			}	
		}
		
		params.put("compSeq", compSeq);

		String groupSeq = params.get("groupSeq")+"";
		params.put("langCode", loginVO.getLangCode());
		if (EgovStringUtil.isEmpty(groupSeq)) {
			params.put("groupSeq", loginVO.getGroupSeq());
		}
		
		
		/** 관리자 권하을 갖고 있는 회사정보 가져오기 */
		List<Map<String,Object>> compList = null;
		String userSe = loginVO.getUserSe();
		params.put("userSe", userSe);
		if (userSe != null && !userSe.equals("USER")) {
			params.put("groupSeq", loginVO.getGroupSeq());
			params.put("langCode", loginVO.getLangCode());
			
			if (userSe.equals("ADMIN")) {
				params.put("empSeq", loginVO.getUniqId());
			}
			compList = compService.getCompListAuth(params);

			JSONArray json = JSONArray.fromObject(compList);
			mv.addObject("compListJson", json);
		}
		
		
		java.util.Calendar cal = java.util.Calendar.getInstance();
		int year = cal.get ( cal.YEAR );
		
		params.put("hYear", year);
		
		if(loginVO.getUserSe().equals("ADMIN")){
			params.put("compSeq", "0");
			params.put("adminCompSeq", loginVO.getCompSeq()); 
		}
		
		else if(loginVO.getUserSe().equals("MASTER")){
			params.put("compSeq", "0");		//전체 조회.
		}
		
		params.put("userSe", loginVO.getUserSe());
		//공휴일 목록 조회.
		List<Map<String, Object>> list = holidayManageService.selectHolidayList(params);
		mv.addObject("loginVO", loginVO);
		mv.addObject("holidayList", list);
		
		mv.setViewName("/neos/cmm/systemx/holiday/HolidayManageView");
		return mv;
	}
	
	
	@RequestMapping("/cmm/systemx/getHolidayList.do")
	public ModelAndView getHolidayList(@RequestParam Map<String,Object> params, HttpServletRequest request) throws Exception {
		ModelAndView mv = new ModelAndView();
		
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		
		if(loginVO.getUserSe().equals("ADMIN")) {
			params.put("adminCompSeq", loginVO.getCompSeq());
		}
		
		params.put("userSe", loginVO.getUserSe());
		params.put("langCode", loginVO.getLangCode());
		
		List<Map<String, Object>> list = holidayManageService.selectHolidayList(params);
		mv.addObject("holidayList", list);
		
		mv.setViewName("jsonView");
		return mv;
	}
	
	
	
	@RequestMapping("/cmm/systemx/getHolidayInfo.do")
	public ModelAndView getHolidayInfo(@RequestParam Map<String,Object> params, HttpServletRequest request) throws Exception {
		ModelAndView mv = new ModelAndView();
		
		params.put("hDay", params.get("hDay").toString().replaceAll("-", ""));	//2016-01-01 -> 20160101 변환
		Map<String, Object> holidayInfo = holidayManageService.getHolidayInfo(params);
		mv.addObject("holidayInfo", holidayInfo);
		
		String hDay = holidayInfo.get("hDay").toString().replaceAll("-", "");
		String converthDay = converSolarToLunar(hDay).replaceAll("-", "").substring(4);
		String legalYn = "";
		
		
		Map<String, Object> para = new HashMap<String, Object>();
		para.put("title", holidayInfo.get("title"));
		
		
		//설날양력체크
		if(converthDay.equals("0101") || converthDay.equals("0102") || converthDay.equals("1231") || converthDay.equals("1230") || converthDay.equals("1229")){
			para.put("hMonth", "01");
			para.put("hDay", "01");			
			if(holidayInfo.get("title").toString().equals(BizboxAMessage.getMessage("TX000011766","설날"))) {
				para.put("title", BizboxAMessage.getMessage("TX000011765","설연휴"));
			}
		}
		
		//추석양력체크
		else if(converthDay.equals("0815") || converthDay.equals("0816") || converthDay.equals("0814")){
			para.put("hMonth", "08");
			para.put("hDay", "15");			
			if(holidayInfo.get("title").toString().equals(BizboxAMessage.getMessage("TX000011764","추석"))) {
				para.put("title", BizboxAMessage.getMessage("TX000011763","추석연휴"));
			}
		}
		
		//석가탄신일양력체크
		else if(converthDay.equals("0408")){
			para.put("hMonth", "04");
			para.put("hDay", "08");			
		}
		
		else{
			para.put("hMonth", hDay.substring(4, 6));
			para.put("hDay", hDay.substring(6, 8));			
		}		

		legalYn = holidayManageService.checkLegalDayYn(para);
		
		mv.addObject("legalYn", legalYn);
		
		mv.setViewName("jsonView");
		
		return mv;
	}
	
	
	@RequestMapping("/cmm/systemx/saveHolidayInfo.do")
	public ModelAndView saveHolidayInfo(@RequestParam Map<String,Object> params, HttpServletRequest request) throws Exception {
		ModelAndView mv = new ModelAndView();
		
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		String result = "0";
		
		params.put("hDay", params.get("hDay").toString().replaceAll("-", ""));
		
		//파라미터(hidHolidaySeq) 값이 존재 하는 경우 수정(update)
		//ex) hidHolidaySeq = "2016-01-01|구정"
		if(!params.get("hidHolidaySeq").toString().equals("")){
			String[] holidaySeq = params.get("hidHolidaySeq").toString().split("\\|");
			params.put("hDayOld", holidaySeq[0].replaceAll("-", ""));
			params.put("compSeqOld", holidaySeq[1]);
			
			params.put("hDayInfo", params.get("hDay") + "");
			int holidayCnt = holidayManageService.getHolidayCnt(params);
				
			if(holidayCnt == 0) {
				holidayManageService.updateHolidayInfo(params);
			}
			else {
				result = "-1";	//중복된 공휴일이 존재.
			}
		}
		
		//파라미터(hidHolidaySeq) 값이 존재하지 않는 경우(신규) 중복되는 공휴일이 있는지 체크.
		else{
			String compSeq = params.get("compSeq").toString();	
			int holidayInfoCnt = holidayManageService.getHolidayInfoCnt(params);
			if(holidayInfoCnt == 0){
				params.put("compSeq", compSeq);
				params.put("empSeq", loginVO.getUniqId());		
				holidayManageService.saveHolidayInfo(params);				
			}
			else{
				result = "-1";	//중복된 공휴일이 존재.
			}
		}
		
		
		mv.addObject("result", result);
		mv.setViewName("jsonView");
		return mv;
	}
	
	
	
	
	@RequestMapping("/cmm/systemx/delHolidayInfo.do")
	public ModelAndView delHolidayInfo(@RequestParam Map<String,Object> params, HttpServletRequest request) throws Exception {
		ModelAndView mv = new ModelAndView();
		
		String[] arrHolidayInfo = params.get("arrHolidayInfo").toString().split("&");
		
		for(int i=0;i<arrHolidayInfo.length;i++){
			String hDay = arrHolidayInfo[i].split("\\|")[0].replaceAll("-", "");
			String compSeq = arrHolidayInfo[i].split("\\|")[1];
			
			params.put("hDay", hDay);
			params.put("compSeq", compSeq);
			
			holidayManageService.delHolidayInfo(params);
		}
		
		mv.setViewName("jsonView");
		return mv;
	}
	
	
	
	//법정공휴일 등록 팝업 및 법정공휴일 조회.
	@RequestMapping("/cmm/systemx/legalHolidayRegPop.do")
	public ModelAndView legalHolidayRegPop(@RequestParam Map<String,Object> params, HttpServletRequest request) throws Exception {
		ModelAndView mv = new ModelAndView();
		
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();	
		int year = 0;
		
		if(params.get("Year") != null) {
			year = Integer.parseInt(params.get("Year") + "");
		}
		
		if(params.get("hYear") != null) {
			year = Integer.parseInt(params.get("hYear").toString());
		}
		
		//기본 법정공휴일 리스트 가져오기.
		params.put("langCode", loginVO.getLangCode());
		List<Map<String,Object>> holidayList = holidayManageService.selectLegalHolidayList(params);

		Map<String,Object> mp = new HashMap<String,Object>();
		
		for(Map<String,Object> map : holidayList){
			if(map.get("lunarYn").toString().equals("N")){
				String convertDate = convertLunarToSolar((year + "-" + map.get("hMonth").toString() + "-" + map.get("hDay").toString()).replaceAll("-", ""));
				
				//설연휴, 추석연휴(앞뒤로 1일씩 연휴 추가)
				if((map.get("hMonth").toString() + "-" + map.get("hDay").toString()).equals("01-01") || (map.get("hMonth").toString() + "-" + map.get("hDay").toString()).equals("08-15")){
					String dateStr = convertDate; 

					SimpleDateFormat curFormater = new SimpleDateFormat("yyyy-MM-dd"); 
					Date dateObj = curFormater.parse(dateStr); 
					Calendar calendar = Calendar.getInstance();
					calendar .setTime(dateObj);
					
					if((map.get("hMonth").toString() + "-" + map.get("hDay").toString()).equals("01-01")){
						mp.put(convertDate, BizboxAMessage.getMessage("TX000011766","설날"));
						calendar.add(calendar.DATE, -1);
						mp.put(curFormater.format(calendar.getTime()), BizboxAMessage.getMessage("TX000011765","설연휴"));
						calendar.add(calendar.DATE, +2);
						mp.put(curFormater.format(calendar.getTime()), BizboxAMessage.getMessage("TX000011765","설연휴"));
						
						//2023년도 설연휴 보정 2023년1월24일 대체공휴일설날연휴추가 2022-08-23
						if(year == 2023) {
							calendar.add(calendar.DATE, +1);
							mp.put(curFormater.format(calendar.getTime()), BizboxAMessage.getMessage("TX000011765","설연휴"));
						}
						
					}
					else if((map.get("hMonth").toString() + "-" + map.get("hDay").toString()).equals("08-15")){
						mp.put(convertDate, BizboxAMessage.getMessage("TX000011764","추석"));
						calendar.add(calendar.DATE, -1);
						mp.put(curFormater.format(calendar.getTime()), BizboxAMessage.getMessage("TX000011763","추석연휴"));
						calendar.add(calendar.DATE, +2);
						mp.put(curFormater.format(calendar.getTime()), BizboxAMessage.getMessage("TX000011763","추석연휴"));
					}	
				}
				//석가탄신일
				else{
					//2023년도 석가탄신일 보정: 계산상 2023년5월26일을 2023년 5월 27일로 변경 
					if(year == 2023) {
						mp.put("2023-05-27", BizboxAMessage.getMessage("TX000011762","석가탄신일"));
					} else {
						mp.put(convertDate, BizboxAMessage.getMessage("TX000011762","석가탄신일"));
					}
				}
			}
			else{
				mp.put(year + "-" + map.get("hMonth").toString() + "-" + map.get("hDay").toString(), map.get("holidayName").toString());
			}		
		}
		
		List<Map<String,Object>> list = new ArrayList<Map<String, Object>>();
		
		
		//공휴일 리스트 일자순으로 정렬.
		TreeMap treeMap = new TreeMap(mp);
		Iterator treeMapIter = treeMap.keySet().iterator();
		while(treeMapIter.hasNext()){
			String key = (String)treeMapIter.next();
			String value = (String)treeMap.get(key);
			Map<String,Object> result = new HashMap<String,Object>();
			result.put("hDay", key);
			result.put("title", value);
			list.add(result);
		}
		
		Map<String, Object> paramMap = new HashMap<String, Object>();
		paramMap.put("hYear", year);
		paramMap.put("langCode", loginVO.getLangCode());
		
		if(!loginVO.getUserSe().equals("MASTER")){
			paramMap.put("userSe", loginVO.getUserSe());
			paramMap.put("adminCompSeq", loginVO.getCompSeq());
			paramMap.put("compSeq", "0");
		}
		else{
			paramMap.put("flag", "1");
		}
		List<Map<String, Object>> list2 = holidayManageService.selectHolidayList(paramMap);
		
		List<Map<String,Object>> result = new ArrayList<Map<String, Object>>();
		int cnt = 0;
		for(Map<String, Object> map : list){
			for(Map<String, Object> iMap : list2){
				if(map.get("hDay").toString().equals(iMap.get("hDay").toString()) && map.get("title").toString().equals(iMap.get("title").toString())) {
					cnt++;
				}
			}
			if(cnt == 0) {
				result.add(map);
			}
			cnt = 0;
		}
		
		
		
		mv.addObject("holidayList", result);
		if(params.get("Year") != null) {
			mv.addObject("Year", params.get("Year"));
		}
		if(params.get("hYear") == null) {
			mv.setViewName("/neos/cmm/systemx/holiday/pop/legalHolidayRegPop");
		}
		else {
			mv.setViewName("jsonView");
		}
		
		mv.addObject("userSe", loginVO.getUserSe());
		return mv;
		
	}
	
	
	public static String getDateByString(Date date) {
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
        return sdf.format(date);
    }       
     
    /**
     * 음력날짜를 양력날짜로 변환
     * @param 음력날짜 (yyyyMMdd)
     * @return 양력날짜 (yyyyMMdd)
     */
    private static String convertLunarToSolar(String date) {
        ChineseCalendar cc = new ChineseCalendar();
        Calendar cal = Calendar.getInstance();
         
        cc.set(ChineseCalendar.EXTENDED_YEAR, Integer.parseInt(date.substring(0, 4)) + 2637);
        cc.set(ChineseCalendar.MONTH, Integer.parseInt(date.substring(4, 6)) - 1);
        cc.set(ChineseCalendar.DAY_OF_MONTH, Integer.parseInt(date.substring(6)));
         
        cal.setTimeInMillis(cc.getTimeInMillis());
        return getDateByString(cal.getTime());
    }
     
    /**
     * 양력날짜를 음력날짜로 변환
     * @param 양력날짜 (yyyyMMdd)
     * @return 음력날짜 (yyyyMMdd)
     */
    private static String converSolarToLunar(String date) {
        ChineseCalendar cc = new ChineseCalendar();
        Calendar cal = Calendar.getInstance();
         
        cal.set(Calendar.YEAR, Integer.parseInt(date.substring(0, 4)));
        cal.set(Calendar.MONTH, Integer.parseInt(date.substring(4, 6)) - 1);
        cal.set(Calendar.DAY_OF_MONTH, Integer.parseInt(date.substring(6)));
         
        cc.setTimeInMillis(cal.getTimeInMillis());
         
        int y = cc.get(ChineseCalendar.EXTENDED_YEAR) - 2637;
        int m = cc.get(ChineseCalendar.MONTH) + 1;
        int d = cc.get(ChineseCalendar.DAY_OF_MONTH);
         
        StringBuffer ret = new StringBuffer();
        ret.append(String.format("%04d", y)).append("-");
        ret.append(String.format("%02d", m)).append("-");
        ret.append(String.format("%02d", d));
         
        return ret.toString();
    }    
    
    
    
    
    @RequestMapping("/cmm/systemx/saveLegalHolidayInfo.do")
	public ModelAndView saveLegalHolidayInfo(@RequestParam Map<String,Object> params, HttpServletRequest request) throws Exception {
		ModelAndView mv = new ModelAndView();
		
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		
		String[] arrHolidayInfo = params.get("arrHolidayInfo").toString().split("&");
		String hDayInfo = "";
		
		
		for(int i=0;i<arrHolidayInfo.length;i++){
			hDayInfo += "," + arrHolidayInfo[i].split("\\|")[0].replaceAll("-", "");
		}
		
		params.put("hDayInfo", hDayInfo.substring(1));
		if(loginVO.getUserSe().equals("MASTER")) {
			params.put("compSeq", "0");
		}
		else {
			params.put("compSeq", loginVO.getCompSeq());
		}
		
		if(params.get("saveFlag") == null){		
			int holidayCnt = holidayManageService.getHolidayCnt(params);
			
			mv.addObject("holidayCnt", holidayCnt);
			mv.setViewName("jsonView");
		}
		
		else{
			params.put("legalFlag", "Y");									
			holidayManageService.delHolidayInfo(params);
			
			params.put("useYn", "Y");
			params.put("empSeq", loginVO.getUniqId());		
			
			for(int i=0;i<arrHolidayInfo.length;i++){
				params.put("hDay", arrHolidayInfo[i].split("\\|")[0].replaceAll("-", ""));
				params.put("title", arrHolidayInfo[i].split("\\|")[1]);	
				holidayManageService.saveHolidayInfo(params);
			}			
		}
		mv.setViewName("jsonView");
		return mv;
	}
	
}
