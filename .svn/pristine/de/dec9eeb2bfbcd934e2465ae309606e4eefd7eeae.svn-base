package neos.cmm.systemx.weather.web;

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
import egovframework.com.cmm.util.EgovUserDetailsHelper;
import neos.cmm.db.CommonSqlDAO;
import neos.cmm.systemx.weather.service.WeatherApiService;


@Controller
public class WeatherApiController {	
	/* 변수정의 로그 */
	//private Logger LOG = LogManager.getLogger(this.getClass());
	
	@Resource(name = "commonSql")
	private CommonSqlDAO commonSql;	
	
	@Resource(name = "WeatherApiService")
	private WeatherApiService weatherApiService;
	
	@RequestMapping("/cmm/systemx/weather/getWeather.do")
	public ModelAndView getWeather(@RequestParam Map<String, Object> params, HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		
		params.put("groupSeq", loginVO.getGroupSeq());
		
		return weatherApiService.getWeatherApiResult(params);				
	}	
}
