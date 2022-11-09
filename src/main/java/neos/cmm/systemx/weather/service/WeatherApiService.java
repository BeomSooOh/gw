package neos.cmm.systemx.weather.service;

import java.util.Map;

import org.springframework.web.servlet.ModelAndView;

public interface WeatherApiService {	
	public ModelAndView getWeatherApiResult(Map<String, Object> params) throws Exception;
	
	public String connectWeatherApi(StringBuilder url) throws Exception;
}
