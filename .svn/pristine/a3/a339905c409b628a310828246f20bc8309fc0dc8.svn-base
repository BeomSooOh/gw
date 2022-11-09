package neos.cmm.systemx.weather.service.impl;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.log4j.Logger;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.springframework.stereotype.Service;
import org.springframework.web.servlet.ModelAndView;

import main.web.BizboxAMessage;
import neos.cmm.db.CommonSqlDAO;
import neos.cmm.systemx.weather.service.WeatherApiService;

@Service("WeatherApiService")
public class WeatherApiServiceImpl implements WeatherApiService{
	
	@Resource(name = "commonSql")
	private CommonSqlDAO commonSql;	
	
	public ModelAndView getWeatherApiResult(Map<String, Object> params) throws Exception{
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		String weatherApiKey = null;
		Logger log = Logger.getLogger(this.getClass());
		JSONObject response = null;
		JSONObject obj = null;
		JSONObject header = null;
				
		//파라미터에 weatherApiKey가 없다면 DB에서 조회 
		if(params.get("weatherApiKey") == null) {
			weatherApiKey = (String) commonSql.select("PortalManageDAO.selectWeatherApiKey", params);
		}else {
			weatherApiKey = (String) params.get("weatherApiKey");
		}
		
		if(((String) params.get("location")).split(",").length < 2) {
			/* 날씨 위치 정보가 없으면 API 요청을 하지 않는다. */
			response = new JSONObject();
			obj = new JSONObject();
			header = new JSONObject();
			
			header.put("resultCode", "");
			header.put("resultMsg", "날씨 위치 지역 정보 없음");
			
			
			response.put("header", header);
			obj.put("response", response);
			
			
			mv.addObject("result", obj);		
			return mv;
		} else if(weatherApiKey == null || weatherApiKey.equals("")) {
			/* 기상청 API 키가 없으면 API 요청을 하지 않는다. */
			response = new JSONObject();
			obj = new JSONObject();
			header = new JSONObject();
			
			header.put("resultCode", "");
			header.put("resultMsg", "기상청 API키 없음");
			
			
			response.put("header", header);
			obj.put("response", response);
			
			mv.addObject("result", obj);
			return mv;
		}
			
		/*
		String addr = "http://newsky2.kma.go.kr/service/SecndSrtpdFrcstInfoService2/ForecastSpaceData?ServiceKey=" 
				+ weatherApiKey
				+ "&nx=" + ((String) params.get("location")).split(",")[0] 
				+ "&ny=" + ((String) params.get("location")).split(",")[1]
				+ "&base_date=" + params.get("baseDate")
				+ "&base_time=" + params.get("baseTime") 
				+ "&_type=json";
		
		*/
		StringBuilder urlBuilder = new StringBuilder("http://apis.data.go.kr/1360000/VilageFcstInfoService_2.0/getUltraSrtFcst"); /*URL*/
        urlBuilder.append("?" + URLEncoder.encode("ServiceKey","UTF-8") + "=" + weatherApiKey); /*Service Key*/
        urlBuilder.append("&" + URLEncoder.encode("pageNo","UTF-8") + "=" + URLEncoder.encode("1", "UTF-8")); /*페이지번호*/
        urlBuilder.append("&" + URLEncoder.encode("numOfRows","UTF-8") + "=" + URLEncoder.encode("100", "UTF-8")); /*한 페이지 결과 수*/
        urlBuilder.append("&" + URLEncoder.encode("dataType","UTF-8") + "=" + URLEncoder.encode("JSON", "UTF-8")); /*요청자료형식(XML/JSON)Default: XML*/
        urlBuilder.append("&" + URLEncoder.encode("base_date","UTF-8") + "=" + URLEncoder.encode(params.get("baseDate").toString(), "UTF-8")); /* 기준일자 */
        urlBuilder.append("&" + URLEncoder.encode("base_time","UTF-8") + "=" + URLEncoder.encode(params.get("baseTime").toString(), "UTF-8")); /* 기준시간 */
        urlBuilder.append("&" + URLEncoder.encode("nx","UTF-8") + "=" + URLEncoder.encode(((String) params.get("location")).split(",")[0], "UTF-8")); /* x축 좌표 */
        urlBuilder.append("&" + URLEncoder.encode("ny","UTF-8") + "=" + URLEncoder.encode(((String) params.get("location")).split(",")[1], "UTF-8")); /* y축 좌표 */
	
		log.debug("==> 날씨 API 요청 URL: " + urlBuilder );		
		
		JSONParser parser = new JSONParser();
		
		try {
			obj = (JSONObject) parser.parse(this.connectWeatherApi(urlBuilder));
		} catch(Exception e) {
			JSONObject errorResult = new JSONObject();
			JSONObject errorResponse = new JSONObject();
			JSONObject errorHeader = new JSONObject();
			
			errorHeader.put("resultCode", "-1");
			errorHeader.put("resultMsg", "기상청 API 결괏값 파싱 실패");
			
			errorResponse.put("header", errorHeader);
			errorResult.put("response", errorResponse);
			
			obj = errorResult;
		}
		
		
		mv.addObject("result", obj);		
		return mv;
	}
	
	public String connectWeatherApi(StringBuilder sUrl) throws Exception{
				
		String inputLine = null;
		StringBuffer resBuf = null;
		Logger log = Logger.getLogger(this.getClass());
		
		try {
			
			URL url = new URL(sUrl.toString());			
			HttpURLConnection con = (HttpURLConnection) url.openConnection();
			
			con.setRequestMethod("GET");
			con.setRequestProperty("User-Agent", "Chrome/version");
		    con.setRequestProperty("Accept-Charset", "UTF-8");
		    con.setRequestProperty("Content-Type", "text/plain; charset=utf-8");
		    con.setConnectTimeout(9000);
		    con.setReadTimeout(9000);
		    		    
		    log.debug("==> 날씨 API 요청 성공");
			
		    long startTime = System.currentTimeMillis();
		    
			BufferedReader in = new BufferedReader(
					new InputStreamReader(con.getInputStream())
			);
					 
			resBuf = new StringBuffer(); 
			
			while ((inputLine = in.readLine()) != null) { 
				resBuf.append(inputLine); 
			}
			
			in.close();
			
			long endTime = System.currentTimeMillis();
			long diffTime = endTime - startTime;
			
			//System.out.println("WEATHER CONNECT TIME: " + diffTime + "(ms)");

		} catch (Exception e) {
			log.debug("==> 날씨 API 요청 실패: " + e);
			inputLine = BizboxAMessage.getMessage("TX800000090","서버 접속인 원활하지 않습니다.");
			if(resBuf!=null) {//Null Pointer 역참조
			resBuf.append(inputLine);
			}
		}
		
		//System.out.println("HTTP body : " + resBuf.toString());
		
		return resBuf.toString();
		
	}

}
