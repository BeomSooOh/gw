package neos.cmm.util;

import java.awt.Color;
import java.awt.Graphics2D;
import java.awt.image.BufferedImage;
import java.beans.BeanInfo;
import java.beans.Introspector;
import java.beans.PropertyDescriptor;
import java.io.BufferedReader;
import java.io.File;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.io.UnsupportedEncodingException;
import java.lang.reflect.Method;
import java.math.BigInteger;
import java.net.HttpURLConnection;
import java.net.MalformedURLException;
import java.net.URL;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.Enumeration;
import java.util.GregorianCalendar;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Set;

import javax.imageio.IIOImage;
import javax.imageio.ImageIO;
import javax.imageio.ImageWriteParam;
import javax.imageio.ImageWriter;
import javax.imageio.stream.FileImageOutputStream;
import javax.servlet.ServletRequest;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import neos.cmm.erp.convert.impl.ErpIuDataConverterImpl;
import neos.cmm.menu.web.MenuTreeContoroller;
import neos.cmm.vo.SendMessageVO;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;
import net.sf.json.JSONSerializer;

import org.apache.log4j.Logger;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.util.HtmlUtils;

import cloud.CloudConnetInfo;

import com.fasterxml.jackson.core.JsonParseException;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.JsonMappingException;
import com.fasterxml.jackson.databind.ObjectMapper;

import egovframework.com.utl.fcc.service.EgovStringUtil;
import egovframework.com.utl.sim.service.EgovFileScrty;

import neos.helper.ConnectionHelper;
import neos.helper.ConnectionHelperFactory;

public class CommonUtil {
		
	private CommonUtil(){}
	
	/**
	 * @Methid Name : HtmlEncode
	 * @param obj
	 * @return
	 * Desc : 홑 따옴표 및 html 인코딩 하는 메서드
	 * @code CommonUtil.HtmlEncode(listMap);
	 * 
	 */
	public  static String  HtmlEncode(Object obj){
		String returnVal = "";
		if(obj != null){
			returnVal = HtmlUtils.htmlEscape(obj.toString());
		}
		
		return returnVal.replace("'", "&#39;");
	}
	
	
	/**
	 * @Methid Name : HtmlEncode
	 * @param listMap
	 * @return
	 * Desc : iBatis 에서  Map 방식으로 받아올 경우 HtmlEncode 함.
	 * @code :  CommonUtil.HtmlEncode(listMap);
	 * 
	 */
	@SuppressWarnings({ "unchecked", "rawtypes" })
	public static List<Map> HtmlEncode(List<Map> listMap){
		
		if(listMap == null || listMap.size()==0){
			return listMap;
		}
		int rowNum = listMap.size() ;
		Map map = null ;
		Set set = null ;
		Iterator iter = null; 
		for(int i = 0;i<rowNum;i++){
			map = listMap.get(i);
			set =  map.keySet();
			 iter = set.iterator();
			 Object key = null;
			 Object value = null;
		 
			for(;iter.hasNext();){
				key = iter.next();
				value = map.get(key);
				if(value != null && value instanceof String ){
					value = HtmlEncode(value.toString());
					map.put(key, value);
				}
			}
		}
		return listMap;
	}
	
	/**
	 * @Methid Name : HtmlEncode
	 * @param listObject
	 * @return
	 * Desc : iBatis 에서  List<T> 방식으로 받아올 경우 HtmlEncode 함.
	 * @code :  CommonUtil.HtmlEncode(List<T>, T.class)
	 */
	@SuppressWarnings("rawtypes")
	public  static void  HtmlEncode(List listObject, Class cl){
	 
	 BeanInfo info =  null;
	 try{
		 info = Introspector.getBeanInfo(cl);
	 }
	 catch(Exception ex){
		 ex.printStackTrace();
	 }
	 
	 PropertyDescriptor pd[] = info.getPropertyDescriptors();
	 
	 Method readMethod =  null;
	 Method writeMethod =  null;
	 
	 Object value = null;
	 Object obj = null ;
		try{
			 for(int i = 0;i<listObject.size();i++){
				 obj = listObject.get(i); 
				 for(int j = 0;j<pd.length;j++){
					 readMethod = pd[j].getReadMethod();
					
					 if(readMethod !=null){
						 value = readMethod.invoke(obj, new Object[]{});
						 if(value != null && value instanceof String ){
							 value = HtmlEncode(value.toString());
							 writeMethod = pd[j].getWriteMethod();
							 if(writeMethod !=null && value != null){
								 writeMethod.invoke(listObject.get(i), new Object[]{value});
							 }
						 }
					 }
				 }
			 }
		}
		catch(Exception ex){
			ex.printStackTrace();
		}
	}


	
	//-----------------------------------------------------------------------------------------
	
	
	
	/**
	 * @Methid Name : HtmlDecode
	 * @param obj
	 * @return
	 * Desc : 홑 따옴표 및 html 인코딩 하는 메서드
	 * @code CommonUtil.HtmlDecode(listMap);
	 * 
	 */
	public  static String  HtmlDecode(Object obj){
		String returnVal = "";
		if(obj != null){
			returnVal = HtmlUtils.htmlUnescape(obj.toString());
		}
		
		return returnVal.replace("&#39;", "'");
	}
	
	
	/**
	 * @Methid Name : HtmlDecode
	 * @param listMap
	 * @return
	 * Desc : iBatis 에서  Map 방식으로 받아올 경우 HtmlDecode 함.
	 * @code :  CommonUtil.HtmlDecode(listMap);
	 * 
	 */
	@SuppressWarnings({ "unchecked", "rawtypes" })
	public static List<Map> HtmlDecode(List<Map> listMap){
		
		if(listMap == null || listMap.size()==0){
			return listMap;
		}
		for(int i = 0;i<listMap.size();i++){
			Map map = listMap.get(i);
			Set set =  map.keySet();
			 Iterator iter = set.iterator();
			 Object key = null;
			 Object value = null;
		 
			for(;iter.hasNext();){
				key = iter.next();
				value = map.get(key);
				if(value != null && value instanceof String ){
					value = HtmlDecode(value.toString());
					map.put(key, value);
				}
			}
		}
		return listMap;
	}
	
	/**
	 * @Methid Name : HtmlDecode
	 * @param listObject
	 * @return
	 * Desc : iBatis 에서  List<T> 방식으로 받아올 경우 HtmlDecode 함.
	 * @code :  CommonUtil.HtmlDecode(List<T>, T.class)
	 */
	@SuppressWarnings("rawtypes")
	public  static void  HtmlDecode(List listObject, Class cl){
	 
	 BeanInfo info =  null;
	 try{
		 info = Introspector.getBeanInfo(cl);
	 }
	 catch(Exception ex){
		 ex.printStackTrace();
	 }
	 
	 PropertyDescriptor pd[] = info.getPropertyDescriptors();
	 
	 Method readMethod =  null;
	 Method writeMethod =  null;
	 
	 Object value = null;
	 
		try{
			 for(int i = 0;i<listObject.size();i++){
				 for(int j = 0;j<pd.length;j++){
					 readMethod = pd[j].getReadMethod();
					 if(readMethod !=null){
						 value = readMethod.invoke(listObject.get(i), new Object[]{});
						 if(value != null && value instanceof String ){
							 value = HtmlDecode(value.toString());
							 writeMethod = pd[j].getWriteMethod();
							 if(writeMethod !=null && value != null){
								 writeMethod.invoke(listObject.get(i), new Object[]{value});
							 }
						 }
					 }
				 }
			 }
		}
		catch(Exception ex){
			ex.printStackTrace();
		}
	}
	
	/**
     * 
     *<pre>
     * 1. MethodName	: AddDashToZip
     * 2. Description	: 우편번호 중간에 '-' 삽입. view에서는 '-'를 삽입한다.
     *                    ex) 480070 -> 480-070
     * ------- 개정이력(Modification Information) ----------
     *    작성일            작성자         작성정보
     *    2013. 1. 22.    송상현        최초작성
     *  ---------------------------------------------------
     *</pre>
     * @param zip
     * @return zip
     * @throws Exception
     */
    public static String AddDashToZip(String zip) throws Exception {
		String result = "";
		if(!EgovStringUtil.isEmpty(zip) && zip.length() >= 6 ) {
			result = zip.substring(0, 3) + "-" + zip.substring(3, 6);
		}else{
			result = zip;
		}
		return result;
	}
	
    /**
     * 
     *<pre>
     * 1. MethodName	: RemoveDashFromZip
     * 2. Description	: 우편번호 중간에 '-' 제거. DB입력시는 '-'를 제거해야 함
     *                    ex) 480-070 -> 480070
     * ------- 개정이력(Modification Information) ----------
     *    작성일            작성자         작성정보
     *    2013. 1. 22.    송상현        최초작성
     *  ---------------------------------------------------
     *</pre>
     * @param zip
     * @return zip
     * @throws Exception
     */
	public static String RemoveDashFromZip(String zip){
		String result = "";
		if(zip != null && zip.length() >= 7){
			result= zip.substring(0, 3) + zip.substring(4, 7);
		}else{
			result = zip;
		}
		return result;
	}
	
	
	/**
	 * @param request : HttpServletRequest 객체
	 * @code CommonUtil.getRequestParam(request);
	 * @return HashMap<String, String>
	 * @see HttpServletRequest -> HashMap<String, String>
	 * @author 김석환
	 * 
	 */
	public static HashMap<String, String> getRequestParam(HttpServletRequest request){
        HashMap<String, String> requestParam = new HashMap<String, String>();
        @SuppressWarnings("rawtypes")
		Enumeration em =  request.getParameterNames();
        String v  = "";
        String k  = "";
        while (em.hasMoreElements()) {
			k = (String) em.nextElement();
			v = request.getParameter(k);
			requestParam.put(k, v);
		}
        
        return requestParam;
	}
	
	/**
	 * @param date : String으로 반환할  날짜
	 * @param format : String으로 변환할 format
	 * @code CommonUtil.date(sdate, "yyyyMMdd");
	 * @return String
	 * @see Date를 format 에 맞는 String으로 변환
	 * @author 김석환
	 * 
	 */		
	public static String date(Date date, String format){
		SimpleDateFormat sdf = new SimpleDateFormat(format);
		return sdf.format(date);
	}
	
	/**
	 * @param source : date로 반환할  날짜 
	 * @param format : String으로 변환할 format
	 * @code CommonUtil.date(sdate_param, "yyyyMMdd");
	 * @return Date
	 * @throws : 현재 날짜 Date
	 * @see : 문자열을 Date 형태로 변환
	 * @author 김석환 
	 * 
	 */	
	public static Date date(String source, String format){
		Date date = null;
				
		SimpleDateFormat sdf = new SimpleDateFormat(format);
		try {
			date = sdf.parse(source);
		} catch (Exception e) {
			date = new Date();
		}
		return date; 
	}	
	
	/**
	 * @param str : 변환할 문자열
	 * @param idx : 초기변환하지 않을 갯수
	 * @code CommonUtil.changeMask(sdate_param, 0);
	 * @return *로 변환된 문자열
	 * @throws : 
	 * @see : 문자열 mask 처리
	 * @author 박금조 
	 * 
	 */	
	public static String changeMask(String str, int idx){
		
		if(str == null || str.equals("")) {
			return "";
		}
		
		String val = "";
		
		int len = str.length();
		for(int i=0; i<len; i++){
			if(i<idx){
				val += str.substring(i,i+1);
			}else{
				val += "*";
			}
		}
		return val;
	}
	
	/**
	 * 패스워드 암호화
	 * @param userPassword
	 * @return
	 * @throws Exception
	 */
	public static String passwordEncrypt(String userPassword) throws Exception {
		if(userPassword != null && !userPassword.equals("")){
			return EgovFileScrty.encryptPassword(userPassword);			
		}else{
			return "";
		}
	}
	
	
	    /**
	     * 브라우저 구분 얻기.
	     * 
	     * @param request
	     * @return6
	     */
    public static  String getBrowser(HttpServletRequest request) {
        String header = request.getHeader("User-Agent");
        if (header.indexOf("MSIE") > -1 || header.indexOf("Trident") > -1) {
            return "MSIE";
        } else if (header.indexOf("Chrome") > -1) {
            return "Chrome";
        } else if (header.indexOf("Opera") > -1) {
            return "Opera";
        }
        return "Firefox";
    }
	public static boolean isHwpCtrl(String ext) {
		if ( EgovStringUtil.isEmpty(ext) ) {
			return false ;
		}
    	if( ext.equalsIgnoreCase("hwp")) {
    		return true ;
    	}
    	return false ;
	}
	public static boolean isImage(String ext) {
		if ( EgovStringUtil.isEmpty(ext) ) {
			return false ;
		}
		if 	( ext.equalsIgnoreCase("jpeg") || ext.equalsIgnoreCase("bmp") 
				|| ext.equalsIgnoreCase("jpg") || ext.equalsIgnoreCase("png") 
				|| ext.equalsIgnoreCase("pdf") ) {
			return true ;
		}
		return false ;
	}
    public static boolean isHwpFileOpen(String ext) {
    	if ( EgovStringUtil.isEmpty(ext) ) {
    		return false ;
    	}
    	if( ext.equalsIgnoreCase("hwp") || ext.equalsIgnoreCase("gif") 
    		|| ext.equalsIgnoreCase("jpeg") || ext.equalsIgnoreCase("bmp") 
    		|| ext.equalsIgnoreCase("jpg") || ext.equalsIgnoreCase("pdf")
    		|| ext.equalsIgnoreCase("html") || ext.equalsIgnoreCase("htm") ) {
    		return true ;
    	}
    	return false ;
    }
	public static void imageMerge( String[] imageFilePathName, String mergeImageFilePathName) throws Exception {
		int rowNum = imageFilePathName.length ;
		BufferedImage[] arrBufferedImage = new BufferedImage[rowNum];
		int point = mergeImageFilePathName.lastIndexOf('.') ;
		String ext = mergeImageFilePathName.substring(point+1, mergeImageFilePathName.length()) ;
		BufferedImage mergedImage= null ;
		File file = null ;
		int width =  0 ;
		int height = 0 ;
		Graphics2D graphics =  null ;
		File mergeImageFile =  null ;
		try {
			for(int inx =0 ; inx <rowNum; inx++) {
				file = new File(imageFilePathName[inx] ) ;
				arrBufferedImage[inx] = ImageIO.read(file);
				file.delete();
			}
			for(int inx =0 ; inx <rowNum; inx++) {
				width = Math.max(width, arrBufferedImage[inx].getWidth());
				height += arrBufferedImage[inx].getHeight();
			}
			
			mergedImage = new BufferedImage(width, height, BufferedImage.TYPE_INT_RGB);
			graphics = (Graphics2D) mergedImage.getGraphics();
			graphics.setBackground(Color.WHITE);
			height = 0 ;
			for( int inx = 0 ; inx < rowNum; inx++) {
				if(inx == 0) {
					graphics.drawImage(arrBufferedImage[inx], 0, 0, null);
				}else {
					height += arrBufferedImage[inx-1].getHeight();
					graphics.drawImage(arrBufferedImage[inx], 0, height, null);
				}
			}
			
			mergeImageFile = new File(mergeImageFilePathName);
			if (mergeImageFile.isFile()) {
				mergeImageFile.delete() ;
			}
			ImageIO.write(mergedImage, ext, mergeImageFile);
			graphics.dispose();
		}catch(Exception e ) {
			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
			if(graphics != null ) {
				try {graphics.dispose();}catch(Exception ignore) {
					CommonUtil.printStatckTrace(ignore);//오류메시지를 통한 정보노출
				}
			}
			
		}		
	}
	public static boolean docImageNoExists(String nonExtFilePathName, String fileExt) {
		File file = new File(nonExtFilePathName+".jpg");
		if(file.isFile()) {
			return true ;
		}
		FileConvert fileConvert = new PdfToImage() ;
		String filePathName = nonExtFilePathName +"."+fileExt ;
		String destFilePathName = nonExtFilePathName +".jpg" ;
		boolean result = false ;
		try {
			result = fileConvert.fileConvert(filePathName, destFilePathName) ;
		
		} catch (Exception e) {
			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
		}
		return result ;
	}
	public static  boolean writeToFile(BufferedImage buff,String savePath) {
		 ImageWriter writer = null ;
	       try {

	            Iterator iter = ImageIO.getImageWritersByFormatName("jpeg");
	            writer = (ImageWriter)iter.next();
	            ImageWriteParam iwp = writer.getDefaultWriteParam();


	            iwp.setCompressionMode(ImageWriteParam.MODE_EXPLICIT);
	            iwp.setCompressionQuality(.5f); 


	            File file = new File(savePath);
	            FileImageOutputStream output = new FileImageOutputStream(file);
	            writer.setOutput(output);
	            IIOImage image = new IIOImage(buff, null, null);
	            writer.write(null, image, iwp);
	            writer.dispose();

	            return true;
	        } catch (Exception e) {
	        	if(writer != null )  {
	        		writer.dispose() ;
	        	}
	        	CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
	        }

	        return false;

	}

	public static String nvl(String str) {
		return nvl(str,"");
	}

	public static String nvl(String str, String def) {
		if(str==null) {
			return def;
		}
		else {
			return str;
		}
	}
	
	/**
	 * 문자를 숫자인지 체크후 int로 변환하여 값 리턴
	 * @param str
	 * @return
	 */
	public static int getIntNvl(String str) {
		str = nvl(str);
		if (isNumeric(str)) {
			return Integer.parseInt(str);
		}
		return 0;
	}
	
	/**
	 * 숫자인지 체크
	 * @param str
	 * @return
	 */
	public static boolean isNumeric(String str){  
		try  
		{  
			double d = Double.parseDouble(str);  
		}  
		catch(NumberFormatException nfe)  
		{  
			return false;  
		}  
		return true;  
	} 
	
	
	public static String getSessionData(HttpServletRequest request, String key, Map params) {
		HttpSession session = request.getSession();
		params.put(key, session.getAttribute(key));
		
		return String.valueOf(session.getAttribute(key));
	}
	
	public static String getSessionData(HttpServletRequest request, String key, ModelAndView params) {
		HttpSession session = request.getSession();
		params.addObject(key, session.getAttribute(key));
		return String.valueOf(session.getAttribute(key));
	}
	
	/** 
	 * 외부 url 호출후 map list로 생성
	 * @param params
	 * @param urlStr
	 * @return
	 */
	public static List<Map<String, Object>> getJsonToBoardList(Map<String,Object> params, String urlStr) {
		
		String[] fields = (String[]) params.get("fields");
		params.remove("fields");
		if (!EgovStringUtil.isEmpty(urlStr)) {
			
			Logger.getLogger( CommonUtil.class ).debug( "CommonUtil.getJsonToBoardList params : " + params );
			Logger.getLogger( CommonUtil.class ).debug( "CommonUtil.getJsonToBoardList urlStr : " + urlStr );
			String data = getJsonFromUri(params, urlStr);
			if (!EgovStringUtil.isEmpty(data)) {
				JSONObject json = JSONObject.fromObject(data);
				List<Map<String, Object>> list = null;
				String jsonArrStr = null;
				try{
					if (json != null) {
						if(EgovStringUtil.isNullToString(params.get("resultType")).equals("dirGroup")){
							jsonArrStr = json.getString("dirGroup");							
						}else if(EgovStringUtil.isNullToString(params.get("resultType")).equals("root")) {
							jsonArrStr = json.getString("dir_main");	
						}else{
							jsonArrStr = json.getString("dir");	
						}
						
						if (!EgovStringUtil.isEmpty(jsonArrStr) && !jsonArrStr.equals("[]")) {
							list = JsonUtil.getJsonToArray(jsonArrStr, fields);
						}
						return list;
					}
				} catch (Exception e){
					CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
				}
			}
		}

		return new ArrayList<Map<String, Object>>();
		
	}
	
	/** 
	 * 외부 url 호출후 map list로 생성
	 * @param params
	 * @param urlStr
	 * @return
	 */
	public static List<Map<String, Object>> getJsonToList(Map<String,Object> params, String urlStr) {
		
		String[] fields = (String[]) params.get("fields");

		if (!EgovStringUtil.isEmpty(urlStr)) {
			String data = getJsonFromUri(params, urlStr);
			if (!EgovStringUtil.isEmpty(data)) {
				JSONObject json = JSONObject.fromObject(data.substring(1));
				try{
					if (json != null) {
						String jsonArrStr = json.getString("result");
						if (!EgovStringUtil.isEmpty(jsonArrStr) && !jsonArrStr.equals("[]")) {
							List<Map<String, Object>> list = JsonUtil.getJsonToArray(jsonArrStr, fields);
							return list;
						}
					}
				} catch (Exception e){
					CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
				}
			}
		}

		return new ArrayList<Map<String, Object>>();
		
	}
	
	@SuppressWarnings("unchecked")
	public static List<Map<String, Object>> getJsonData(Map<String,Object> params, String urlStr) {

		if (!EgovStringUtil.isEmpty(urlStr)) {
			String data = getJsonFromUri(params, urlStr);
			if (!EgovStringUtil.isEmpty(data)) {
				JSONObject json = JSONObject.fromObject(data.substring(1));
				try{
					if (json != null) {
						String jsonArrStr = json.getString("result");
						if (!EgovStringUtil.isEmpty(jsonArrStr) && !jsonArrStr.equals("[]")) {
							return JSONArray.fromObject(jsonArrStr);
						}
					}
				} catch (Exception e){
					CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
				}
			}
		}

		return new ArrayList<Map<String, Object>>();

	}
	
	/**
	 * api url 호출용
	 * @param params
	 * @param urlStr
	 * @param method
	 * @return
	 */
	public static String getJsonFromUri(Map<String,Object> params, String urlStr) {
		return getJsonFromUri(params, urlStr, "get");
	}
	
	
	public static String getJsonFromUri(Map<String,Object> params, String urlStr, String method) {
		
		Logger.getLogger( CommonUtil.class ).debug( "CommonUtil.getJsonFromUri urlStr : " + urlStr );
		Logger.getLogger( CommonUtil.class ).debug( "CommonUtil.getJsonFromUri method : " + method );
		Logger.getLogger( CommonUtil.class ).debug( "CommonUtil.getJsonFromUri getUrlParameter(params) : " + getUrlParameter(params) );
		
		String resultString = readJSONFeed(urlStr + "?" + getUrlParameter(params)); 
		
		Logger.getLogger( CommonUtil.class ).debug( "CommonUtil.getJsonFromUri resultString : " + resultString );
		
		return resultString;

	}

	public static String getUrlParameter(Map<String,Object> params) {
		StringBuffer sb = new StringBuffer();
		
		if (params != null) {
			Iterator itr = params.entrySet().iterator();
			
			while(itr.hasNext()) {
				String key = String.valueOf(itr.next());
				sb.append(key);
				if(itr.hasNext()) {
					sb.append("&");
				}
			}
			
		}
		
		return sb.toString();
		
	}
	
	
	public static String readJSONFeed(String url) {
		StringBuilder stringBuilder = new StringBuilder();		
		try{
			Logger.getLogger( CommonUtil.class ).debug( "CommonUtil.readJSONFeed URL : " + url );
			
			ConnectionHelper connect = ConnectionHelperFactory.createInstacne((String) url);
			
			ObjectMapper mapper = new ObjectMapper();
			String json = mapper.writeValueAsString(null);
			String resultStr = connect.requestData(json);
			Logger.getLogger( CommonUtil.class ).debug( "CommonUtil.readJSONFeed resultStr : " + resultStr );
			
			return resultStr;
		}catch(Exception e){
			Logger.getLogger( CommonUtil.class ).error( "CommonUtil.readJSONFeed readJSONFeed" );
			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
	    	return stringBuilder.toString();
		}		
	}
	
	
	public static String makeHttpParameter(Map<String,Object> params) {
		StringBuffer sb = new StringBuffer();
		if(params != null && params.size() > 0) {
			Iterator itr =  params.keySet().iterator();
			while(itr.hasNext()) {
				String key = (String)itr.next();
				sb.append(key);
				sb.append("=");
				sb.append(params.get(key));
				if (itr.hasNext()) {
					sb.append("&");
				}
			}
		}
		
		return sb.toString();
	}
	
	public static String getStrNumberDelimiter(String[] strArr, String delimiter) {
		StringBuffer sb = new StringBuffer();
		if (strArr != null) {
			for(int i = 0; i < strArr.length ; i++) {
				sb.append(strArr[i]);
				if(i < strArr.length-1) {
					sb.append(delimiter);
				}
			}
		}
		return sb.toString();
	}
	
	public static String getStrNumber(String str, String ref) {
		if (EgovStringUtil.isEmpty(str)) {
			return ref;
		} else {
			return str.replaceAll("[^0-9]", "");
		}
	}
	//제거되지 않고 남은 디버그 코드
//	public static void main(String[] args) {
//		
//		try {
//			CommonUtil.passwordEncrypt("1111");
//		} catch (Exception e) {
//			e.printStackTrace();
//		}
//	}
//	
	public static String getDateToTimeStamp(String getDate){
		
		SimpleDateFormat stampFormat = new SimpleDateFormat("yyyy-MM-dd");
		String returnStr = "";
		
		try{
		
			Date date = stampFormat.parse(getDate);
			long time = date.getTime();
			returnStr = Long.toString(time);
			
		}catch(Exception e){
			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
		}
		return returnStr;
	}
	
	public static Long getDateToTimeStampLong(String getDate){
		
		SimpleDateFormat stampFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		Long returnLong = null;
		
		try{
		
			Date date = stampFormat.parse(getDate);
			long time = date.getTime();
			//long a = new Timestamp(time);
			//System.out.println("timestamp : "+new Timestamp(time));
			returnLong = time;
			
		}catch(Exception e){
			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
		}
		return returnLong;
	}
	
	
	public static List<Map<String, Object>> getNonEaInfoCount(String groupSeq, String compSeq, String bizSeq, String deptSeq, String empSeq, String langCode, String menuList, HttpServletRequest request){
		
		String eapUrl = "";
		
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("groupSeq", groupSeq);
		
		eapUrl = getApiCallDomain(request) + "/ea/ea/box.do";

		ModelAndView mv = new ModelAndView();

		JSONObject obj = new JSONObject();

		JSONObject header = new JSONObject();
		header.put("groupSeq", groupSeq);
		header.put("empSeq", empSeq);
		header.put("tId", "B001");
		header.put("pId", "B001");

		JSONObject companyInfo = new JSONObject();

		companyInfo.put("compSeq", compSeq);
		companyInfo.put("bizSeq", bizSeq);
		companyInfo.put("deptSeq", deptSeq);
		companyInfo.put("empSeq", empSeq);
		companyInfo.put("langCode", langCode);
		companyInfo.put("emailAddr", "");
		companyInfo.put("emailDomain", "");

		JSONObject body = new JSONObject();
		body.put("companyInfo", companyInfo);
		body.put("langCode", langCode);
		body.put("parMenuId", "0");
		body.put("menuList", menuList);		
		
		Date date = new Date();
		Calendar calendar = new GregorianCalendar();
		calendar.setTime(date);
		int year = calendar.get(Calendar.YEAR);
		// Add one to month {0 - 11}
		int month = calendar.get(Calendar.MONTH) + 1;
		int day = calendar.get(Calendar.DAY_OF_MONTH);

		String fromDt = Integer.toString(year - 1)
				+ (month < 10 ? "0" + Integer.toString(month) : Integer.toString(month))
				+ (day < 10 ? "0" + Integer.toString(day) : Integer.toString(day));
		String toDt = Integer.toString(year) + (month < 10 ? "0" + Integer.toString(month) : Integer.toString(month))
				+ (day < 10 ? "0" + Integer.toString(day) : Integer.toString(day));

		body.put("fromDt", fromDt);
		body.put("toDt", toDt);

		obj.put("header", header);
		obj.put("body", body);

		try{		
			JSONObject jsonObject2 = JSONObject.fromObject(JSONSerializer.toJSON(obj));
			
			HttpJsonUtil httpJson = new HttpJsonUtil();
			String boxCntList = httpJson.execute("POST", eapUrl, jsonObject2);
			
			ObjectMapper om = new ObjectMapper();
			Map<String, Object> m = om.readValue(boxCntList, new TypeReference<Map<String, Object>>(){});		
			List<Map<String, Object>> list = (List<Map<String, Object>>) ((Map<String, Object>)m.get("result")).get("boxList");
			
			return list;
			
		}catch(Exception e){
			return null;
		}
	}
	
	public static String getContentType(File file){
		String fileName = file.getName();		
		int idx = fileName.lastIndexOf(".");
		
		String fileExtsn = fileName.substring(idx + 1);		
		String contentType = "application/octet-stream";
		
		if(fileExtsn.toLowerCase().equals("aac")){
			contentType = "audio/aac";
		}else if(fileExtsn.toLowerCase().equals("abw")){
			contentType = "application/x-abiword";
		}else if(fileExtsn.toLowerCase().equals("arc")){
			contentType = "application/octet-stream";
		} else if(fileExtsn.toLowerCase().equals("avi")){
			contentType = "video/x-msvideo";
		} else if(fileExtsn.toLowerCase().equals("azw")){
			contentType = "application/vnd.amazon.ebook";
		} else if(fileExtsn.toLowerCase().equals("bin")){
			contentType = "application/octet-stream";
		} else if(fileExtsn.toLowerCase().equals("bz")){
			contentType = "application/x-bzip";
		} else if(fileExtsn.toLowerCase().equals("bz2")){
			contentType = "application/x-bzip2";
		} else if(fileExtsn.toLowerCase().equals("csh")){
			contentType = "application/x-csh";
		} else if(fileExtsn.toLowerCase().equals("css")){
			contentType = "text/css";
		} else if(fileExtsn.toLowerCase().equals("csv")){
			contentType = "text/csv";
		} else if(fileExtsn.toLowerCase().equals("doc")){
			contentType = "application/msword";
		} else if(fileExtsn.toLowerCase().equals("epub")){
			contentType = "application/epub+zip";
		} else if(fileExtsn.toLowerCase().equals("gif")){
			contentType = "image/gif";
		} else if(fileExtsn.toLowerCase().equals("htm")){
			contentType = "text/html";
		} else if(fileExtsn.toLowerCase().equals("html")){
			contentType = "text/html";
		} else if(fileExtsn.toLowerCase().equals("ico")){
			contentType = "image/x-icon";
		} else if(fileExtsn.toLowerCase().equals("ics")){
			contentType = "text/calendar";
		} else if(fileExtsn.toLowerCase().equals("jar")){
			contentType = "application/java-archive";
		} else if(fileExtsn.toLowerCase().equals("jpeg")){
			contentType = "image/jpeg";
		} else if(fileExtsn.toLowerCase().equals("jpg")){
			contentType = "image/jpeg";
		} else if(fileExtsn.toLowerCase().equals("js")){
			contentType = "application/js";
		} else if(fileExtsn.toLowerCase().equals("json")){
			contentType = "application/json";
		} else if(fileExtsn.toLowerCase().equals("mid")){
			contentType = "audio/midi";
		} else if(fileExtsn.toLowerCase().equals("midi")){
			contentType = "audio/midi";
		} else if(fileExtsn.toLowerCase().equals("mpeg")){
			contentType = "video/mpeg";
		} else if(fileExtsn.toLowerCase().equals("mpkg")){
			contentType = "application/vnd.apple.installer+xml";
		} else if(fileExtsn.toLowerCase().equals("odp")){
			contentType = "application/vnd.oasis.opendocument.presentation";
		} else if(fileExtsn.toLowerCase().equals("ods")){
			contentType = "application/vnd.oasis.opendocument.spreadsheet";
		} else if(fileExtsn.toLowerCase().equals("odt")){
			contentType = "application/vnd.oasis.opendocument.text";
		} else if(fileExtsn.toLowerCase().equals("oga")){
			contentType = "audio/ogg";
		} else if(fileExtsn.toLowerCase().equals("ogv")){
			contentType = "video/ogg";
		} else if(fileExtsn.toLowerCase().equals("ogx")){
			contentType = "application/ogg";
		} else if(fileExtsn.toLowerCase().equals("pdf")){
			contentType = "application/pdf";
		} else if(fileExtsn.toLowerCase().equals("ppt")){
			contentType = "application/vnd.ms-powerpoint";
		} else if(fileExtsn.toLowerCase().equals("rar")){
			contentType = "application/x-rar-compressed";
		} else if(fileExtsn.toLowerCase().equals("rtf")){
			contentType = "application/rtf";
		} else if(fileExtsn.toLowerCase().equals("sh")){
			contentType = "application/x-sh";
		} else if(fileExtsn.toLowerCase().equals("svg")){
			contentType = "image/svg+xml";
		} else if(fileExtsn.toLowerCase().equals("swf")){
			contentType = "application/x-shockwave-flash";
		} else if(fileExtsn.toLowerCase().equals("tar")){
			contentType = "application/x-tar";
		} else if(fileExtsn.toLowerCase().equals("tif")){
			contentType = "image/tiff";
		} else if(fileExtsn.toLowerCase().equals("tiff")){
			contentType = "image/tiff";
		} else if(fileExtsn.toLowerCase().equals("ttf")){
			contentType = "application/x-font-ttf";
		} else if(fileExtsn.toLowerCase().equals("vsd")){
			contentType = "application/vnd.visio";
		} else if(fileExtsn.toLowerCase().equals("wav")){
			contentType = "audio/x-wav";
		} else if(fileExtsn.toLowerCase().equals("weba")){
			contentType = "audio/webm";
		} else if(fileExtsn.toLowerCase().equals("webm")){
			contentType = "video/webm";
		} else if(fileExtsn.toLowerCase().equals("webp")){
			contentType = "image/webp";
		} else if(fileExtsn.toLowerCase().equals("woff")){
			contentType = "application/x-font-woff";
		} else if(fileExtsn.toLowerCase().equals("xhtml")){
			contentType = "application/xhtml+xml";
		} else if(fileExtsn.toLowerCase().equals("xls") || fileExtsn.toLowerCase().equals("xlsx")){
			contentType = "application/vnd.ms-excel";
		} else if(fileExtsn.toLowerCase().equals("xml")){
			contentType = "application/xml";
		} else if(fileExtsn.toLowerCase().equals("xul")){
			contentType = "application/vnd.mozilla.xul+xml";
		} else if(fileExtsn.toLowerCase().equals("zip")){
			contentType = "application/zip";
		} else if(fileExtsn.toLowerCase().equals("7z")){
			contentType = "application/x-7z-compressed";
		} else if(fileExtsn.toLowerCase().equals("mp4")){
			contentType = "video/mp4";
		}
		
		return contentType;
	}
	
	
	public static String getApiCallDomain(HttpServletRequest request){
		String custDomain = BizboxAProperties.getCustomProperty("BizboxA.Cust.GroupWareDomain");
		String domain = "";
		
		if(custDomain.equals("99")) {
			try {
				if(CloudConnetInfo.getBuildType().equals("cloud")) {
					domain = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort();
				}else {
					domain = request.getScheme() + "://" + (request.getScheme().toUpperCase().equals("HTTPS") ? request.getServerName() : "localhost" + ":" + request.getServerPort());
				}
			} catch (Exception e) {
				CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
				domain = request.getScheme() + "://" + (request.getScheme().toUpperCase().equals("HTTPS") ? request.getServerName() : "localhost" + ":" + request.getServerPort());
			}
		}
		else {
			domain = custDomain;
		}
		
		
		Logger.getLogger( CommonUtil.class ).debug( "CommonUtil.getApiCallDomain domain : " + domain );
		return domain;
	}
	
	
	public static String dateCheck(String date) {
		//날짜형식 체크(yyyyMMdd)	
		
		Logger.getLogger( ErpIuDataConverterImpl.class ).debug( "ErpIuDataConverterImpl.dateCheck date : " + date );
		boolean validation = true;
		try {
			date = date.replace("-", "");
			SimpleDateFormat dateFormat = new SimpleDateFormat("yyyyMMdd", Locale.KOREAN);
			dateFormat.setLenient(false);
		
			dateFormat.parse(date);
		}catch(Exception e) {
			Logger.getLogger( ErpIuDataConverterImpl.class ).error( "ErpIuDataConverterImpl.dateCheck date : " + date );
			return "";
		}
		
		if(validation) {
			return date;
		}
		else {
			return "";
		}
	}
	
	
	public static boolean isEmptyStr(Object str) {
		try {
			if(str == null || str.toString().equals("")) {
				return true;
			}
			else {
				return false;
			}
		}catch(Exception e) {
			return true;
		}
	}
	
	
	public static JSONObject getPostJSON(String url, String data) {
		
		Logger.getLogger( MenuTreeContoroller.class ).debug( "CommonUtil.getPostJSON url : " + url);
		Logger.getLogger( MenuTreeContoroller.class ).debug( "CommonUtil.getPostJSON data : " + data);
		
		StringBuilder sbBuf = new StringBuilder();
		HttpURLConnection con = null;
		BufferedReader brIn = null;
		OutputStreamWriter wr = null;
		String line = null;
		try {
			con = (HttpURLConnection) new URL(url).openConnection();
			con.setRequestMethod("POST");
			con.setConnectTimeout(5000);
			con.setRequestProperty("Content-Type", "application/json;charset=UTF-8");
			con.setDoOutput(true);
			con.setDoInput(true);

			wr = new OutputStreamWriter(con.getOutputStream());
			wr.write(data);
			wr.flush();
			brIn = new BufferedReader(new InputStreamReader(con.getInputStream(), "UTF-8"));
			while ((line = brIn.readLine()) != null) {
				sbBuf.append(line);
			}
			// System.out.println(sbBuf);

			JSONObject rtn = JSONObject.fromObject(sbBuf.toString());

			sbBuf = null;

			return rtn;
		} catch (Exception e) {
			Logger.getLogger( MenuTreeContoroller.class ).error( "CommonUtil.getPostJSON error");
			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
			return null;
		} finally {
			try {
				if(wr!=null) {//Null Pointer 역참조
				wr.close();
				}
			} catch (Exception e) {
				CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
			}
			try {
				if(brIn!=null) {//Null Pointer 역참조
				brIn.close();
				}
			} catch (Exception e) {
				CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
			}
			try {
				if(con!=null) {//Null Pointer 역참조
				con.disconnect();
				}
			} catch (Exception e) {
				CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
			}
		}
	}
	
	
	
	public static Map<String, String> getQueryMap(String url) throws MalformedURLException
    {    	
		
		URL targetUrl = new URL(url);
		String query = targetUrl.getQuery();
		
    	if (query==null) {
    		return null;
    	}
    	
    	int pos1=query.indexOf("?");
    	if (pos1>=0) {
    		query=query.substring(pos1+1);
    	}
    	
        String[] params = query.split("&");
        Map<String, String> map = new HashMap<String, String>();
        for (String param : params)
        {
            String name = param.split("=")[0];
            String value = param.split("=")[1];
            map.put(name, value);
        }
        return map;
    }
	
	public static String getFileExtensionByMime(String contentType){
		String extension = "";
		
		if(contentType == null) {
			return extension;
		}
		else {	
			if(contentType.equals("video/x-ms-asf")) {
				extension = "asf";
			}else if(contentType.equals("text/asp")) {
				extension = "asp";
			}else if(contentType.equals("video/x-msvideo")) {
				extension = "avi";
			}else if(contentType.equals("image/bmp")) {
				extension = "bmp";
			}else if(contentType.equals("text/css")) {
				extension = "css";
			}else if(contentType.equals("application/msword")) {
				extension = "doc";
			}else if(contentType.equals("application/octet-stream")) {
				extension = "exe";
			}else if(contentType.equals("image/gif")) {
				extension = "gif";
			}else if(contentType.equals("text/html")) {
				extension = "htm";
			}else if(contentType.equals("text/html")) {
				extension = "html";
			}else if(contentType.equals("image/x-icon")) {
				extension = "ico";
			}else if(contentType.equals("text/plain")) {
				extension = "java";
			}else if(contentType.equals("image/jpeg")) {
				extension = "jpg";
			}else if(contentType.equals("image/jpeg")) {
				extension = "jpg";
			}else if(contentType.equals("application/x-javascript")) {
				extension = "js";
			}else if(contentType.equals("audio/mpeg3")) {
				extension = "mp3";
			}else if(contentType.equals("video/mpeg")) {
				extension = "mpeg";
			}else if(contentType.equals("audio/mpeg")) {
				extension = "mpg";
			}else if(contentType.equals("image/png")) {
				extension = "png";
			}else if(contentType.equals("application/vnd.ms-powerpoint")) {
				extension = "ppt";
			}else if(contentType.equals("application/x-shockwave-flash")) {
				extension = "swf";
			}else if(contentType.equals("application/octet-stream")) {
				extension = "txt"; 
			}else if(contentType.equals("application/ms-excel")) {
				extension = "xls"; 
			}else if(contentType.equals("application/xml")) {
				extension = "xml";
			}else if(contentType.equals("application/zip")) {
				extension = "zip";
			}
		}
		return extension;
	}
	
	public static String getClientIp(ServletRequest request)
    {    	
        String clientIp = ((HttpServletRequest)request).getHeader("X-FORWARDED-FOR");  
		
		if ( clientIp == null || clientIp.length( ) == 0 ) {
			clientIp = ((HttpServletRequest)request).getHeader( "Proxy-Client-IP" );
		}
		
		if ( clientIp == null || clientIp.length( ) == 0 ) {
			clientIp = ((HttpServletRequest)request).getHeader( "WL-Proxy-Client-IP" );
		}
		
		//Custom property 값 ProxyAddYn이 "Y"경우 header 값 체크 추가 (proxy 및 모든 l4 대응 방안)
		if(BizboxAProperties.getCustomProperty("BizboxA.ProxyAddYn").equals("Y")) {
			if(clientIp == null || clientIp.length( ) == 0) {
				clientIp = ((HttpServletRequest)request).getHeader( "HTTP_CLIENT_IP" );
			}
			if(clientIp == null || clientIp.length( ) == 0) {
				clientIp = ((HttpServletRequest)request).getHeader( "HTTP_X_FORWARDED_FOR" );
			}
			if(clientIp == null || clientIp.length( ) == 0) {
				clientIp = ((HttpServletRequest)request).getHeader( "X-Real-IP" );
			}
		}
		if ( clientIp == null || clientIp.length( ) == 0 ) {
			clientIp = request.getRemoteAddr( );
		}
		
		if ( clientIp == null ) {
			clientIp = ""; 
		}
		
		if(request.getServerName().equals("localhost")){
			clientIp = "127.0.0.1";
		}
		
		// 다수개 존재시 첫번째로 처리를 위함. X-Forwarded-For: client, proxy1, proxy2
		if (!clientIp.equals("") && clientIp.split(",").length > 0) {
			clientIp = clientIp.split(",")[0];
		}
		
		return clientIp.replace(" ", "");
    }	
	
	public static String sha256Enc(String input, String salt) throws UnsupportedEncodingException, NoSuchAlgorithmException
    {    	
		  MessageDigest digest = MessageDigest.getInstance("SHA-256");
		  digest.reset();
		  digest.update(input.getBytes("utf8"));
		  
		  if(salt != null && !salt.equals("")) {
			  digest.update(salt.getBytes("utf8"));
		  }
		  
		  return String.format("%064x", new BigInteger(1, digest.digest()));
    }	
	
	public static String sha512Enc(String input, String salt) throws UnsupportedEncodingException, NoSuchAlgorithmException
    {    	
		  MessageDigest digest = MessageDigest.getInstance("SHA-512");
		  digest.reset();
		  digest.update(input.getBytes("utf8"));
		  
		  if(salt != null && !salt.equals("")) {
			  digest.update(salt.getBytes("utf8"));
		  }
		  
		  return String.format("%0128x", new BigInteger(1, digest.digest()));
    }	
	
	
	public static void SendMessage(String domain, SendMessageVO vo, String groupSeq, String empSeq) {
		
		String apiUrl = domain + "/messenger/MobileMessage/SendMessage";
		
		JSONObject header = new JSONObject();
		JSONObject body = new JSONObject();
		JSONObject apiParam = new JSONObject();
		
		header.put("groupSeq", groupSeq);
		header.put("empSeq", empSeq);
		body.putAll(vo.getData());
		
		apiParam.put("header", header);
		apiParam.put("body", body);
		
		Logger.getLogger( CommonUtil.class ).debug( "CommonUtil.SendMessage apiParam : " + apiParam);
		JSONObject resultJson = getPostJSON(apiUrl, apiParam.toString());
		Logger.getLogger( CommonUtil.class ).debug( "CommonUtil.SendMessage result : " + resultJson);
	}
	
	//mobile Token기반 사용자정보 조회
	public static Map<String, Object> SearchTokenInfo(String token, String mobileGatewayUrl, String mobileId){
		
		Map<String, Object> result = new HashMap<String, Object>();
		
		try {
				//API호출
				//token으로 사용자 시퀀스 가져오기
				JSONObject jsonObj = new JSONObject();
				JSONObject header = new JSONObject();
				JSONObject body = new JSONObject();
				
				header.put("companyId", "");
				header.put("userId", "");
				header.put("token", "");
				header.put("tId", "0");
				header.put("pId", "P011");
				header.put("appType", "11");
				body.put("mobileId", mobileId);
				body.put("token", token);
				
				jsonObj.put("header", header);
				jsonObj.put("body", body);
		
				String apiUrl = mobileGatewayUrl + "/BizboxMobileGateway/service/SearchTokenInfo";
				
	    		Logger.getLogger( CommonUtil.class ).debug( "CommonUtil.SearchTokenInfo  apiUrl : " + apiUrl );
	    		Logger.getLogger( CommonUtil.class ).debug( "CommonUtil.SearchTokenInfo  jsonObj : " + jsonObj );
				
				result = callApiToMap(jsonObj, apiUrl);
				
				Logger.getLogger( CommonUtil.class ).debug( "CommonUtil.SearchTokenInfo  result : " + result );
				
		}catch(Exception e) {
			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
		}
		
		return result;
	}
	
	public static Map<String, Object> callApiToMap(JSONObject jsonObject, String url) throws JsonParseException, JsonMappingException, IOException{
		 HttpJsonUtil httpJson = new HttpJsonUtil();
		 @SuppressWarnings("static-access")
		 String returnStr = httpJson.execute("POST", url, jsonObject);
		 ObjectMapper om = new ObjectMapper();
		 Map<String, Object> m = om.readValue(returnStr, new TypeReference<Map<String, Object>>(){});
		 return m;
	 }
	
	public static void printStatckTrace(Exception e) {
		StackTraceElement[] elements = e.getStackTrace();
		String exceptionAsStrting = e.toString();
		for(StackTraceElement st : elements) {
		     exceptionAsStrting+=st+"\n";
		}
		System.out.println(exceptionAsStrting);
	}
	public static void printStatckTrace(Throwable e) {
		StackTraceElement[] elements = e.getStackTrace();
		String exceptionAsStrting = e.toString();
		for(StackTraceElement st : elements) {
		     exceptionAsStrting+=st+"\n";
		}
		System.out.println(exceptionAsStrting);
	}
	public static String getStatckTrace(Exception e) {
		StackTraceElement[] elements = e.getStackTrace();
		String exceptionAsStrting = e.toString();
		for(StackTraceElement st : elements) {
		     exceptionAsStrting+=st+"\n";
		}
		return exceptionAsStrting;
	}
}
