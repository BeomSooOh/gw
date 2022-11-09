package neos.cmm.util;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.Map;
import java.util.Properties;

import org.apache.log4j.Logger;

import egovframework.com.cmm.EgovWebUtil;
import egovframework.com.cmm.service.EgovProperties;

/**
 *  Class Name : EgovProperties.java
 *  Description : properties값들을 파일로부터 읽어와   Globals클래스의 정적변수로 로드시켜주는 클래스로
 *   문자열 정보 기준으로 사용할 전역변수를 시스템 재시작으로 반영할 수 있도록 한다.
 *  Modification Information
 *
 *     수정일         수정자                   수정내용
 *   -------    --------    ---------------------------
 *   2009.01.19    박지욱          최초 생성
 *	 2011.07.20    서준식 	      Globals파일의 상대경로를 읽은 메서드 추가
 *  @author 공통 서비스 개발팀 박지욱
 *  @since 2009. 01. 19
 *  @version 1.0
 *  @see
 *
 */

public class BizboxAProperties{

	//프로퍼티값 로드시 에러발생하면 반환되는 에러문자열
	public static final String ERR_CODE =" EXCEPTION OCCURRED";
	public static final String ERR_CODE_FNFE =" EXCEPTION(FNFE) OCCURRED";
	public static final String ERR_CODE_IOE =" EXCEPTION(IOE) OCCURRED";

	//파일구분자
    static final char FILE_SEPARATOR     = File.separatorChar;

	private static volatile Properties bizboxaPropertis = null;
	private static volatile Properties customPropertis = null;
	private static volatile Properties edmsPropertis = null;

    public static final String RELATIVE_PATH_PREFIX = "../";

    public static final String GLOBALS_PROPERTIES_FILE = EgovProperties.getProperty("Globals.BizboxA.path");
    
    public static final String GLOBALS_CUSTOM_PROPERTIES_FILE = "../bizboxaconf/bizboxa.custom.properties";
    
    public static final String GLOBALS_EDMS_PROPERTIES_FILE = "../bizboxaconf/bizboxa.edms.properties";


    //이중체크락. 1.5 버전 이상에만 사용가능, 1.5 버전 이하이면 사용하면안됨.
    private static void   init() {
		FileInputStream fis = null;
		try{
			if(bizboxaPropertis == null ) {
				synchronized(BizboxAProperties.class) {
					if(bizboxaPropertis == null ) {
						bizboxaPropertis = new Properties();
						fis = new FileInputStream(new File(GLOBALS_PROPERTIES_FILE));
						bizboxaPropertis.load(new java.io.BufferedInputStream(fis));
					}
				}
			}

		}catch(FileNotFoundException fne){
			debug(fne);
		}catch(IOException ioe){
			debug(ioe);
		}catch(Exception e){
			debug(e);
		}finally{
			try {
				if (fis != null) {
					fis.close();
				}
			} catch (Exception ex) {
				debug("IGNORED: " + ex.getMessage());
			}
		}
    }
    /**
	 * 인자로 주어진 문자열을 Key값으로 하는 상대경로 프로퍼티 값을 절대경로로 반환한다(Globals.java 전용)
	 * @param keyName String
	 * @return String
	 */
	public static String getPathProperty(String keyName){
		String value = "99";
		try{
			init();
			
			if(bizboxaPropertis.getProperty(keyName) != null) {
				value = bizboxaPropertis.getProperty(keyName).trim();
				value = RELATIVE_PATH_PREFIX + "egovProps" + System.getProperty("file.separator") + value;
			}
			
		}catch(Exception e){
			debug(e);
		}
		return value;
	}

	/**
	 * 인자로 주어진 문자열을 Key값으로 하는 프로퍼티 값을 반환한다(Globals.java 전용)
	 * @param keyName String
	 * @return String
	 */
	public static String getProperty(String keyName){
		String value = "99";

		try{
			init();
			
			if(bizboxaPropertis.getProperty(keyName) != null) {
				value = bizboxaPropertis.getProperty(keyName).trim();	
			}
			
		}catch(Exception e){
			debug(e);
		}
		return value;
	}

	/**
	 * 주어진 파일에서 인자로 주어진 문자열을 Key값으로 하는 프로퍼티 상대 경로값을 절대 경로값으로 반환한다
	 * @param fileName String
	 * @param key String
	 * @return String
	 */
	public static String getPathProperty(String fileName, String key){
		FileInputStream fis = null;
		try{
			java.util.Properties props = new java.util.Properties();
			fis = new FileInputStream(EgovWebUtil.filePathBlackList(fileName));
			props.load(new java.io.BufferedInputStream(fis));
			fis.close();

			String value = props.getProperty(key);
			value = RELATIVE_PATH_PREFIX + "egovProps" + System.getProperty("file.separator") + value;
			return value;
		}catch(java.io.FileNotFoundException fne){
			return ERR_CODE_FNFE;
		}catch(java.io.IOException ioe){
			return ERR_CODE_IOE;
		}finally{
			try {
				if (fis != null) {
					fis.close();
				}
			} catch (Exception ex) {
			    debug(ex);
			}
		}
	}


	/**
	 * 주어진 파일에서 인자로 주어진 문자열을 Key값으로 하는 프로퍼티 값을 반환한다
	 * @param fileName String
	 * @param key String
	 * @return String
	 */
	public static String getProperty(String fileName, String key){
		FileInputStream fis = null;
		try{
			java.util.Properties props = new java.util.Properties();
			fis = new FileInputStream(EgovWebUtil.filePathBlackList(fileName));
			props.load(new java.io.BufferedInputStream(fis));
			fis.close();

			String value = props.getProperty(key);
			return value;
		}catch(java.io.FileNotFoundException fne){
			return ERR_CODE_FNFE;
		}catch(java.io.IOException ioe){
			return ERR_CODE_IOE;
		}finally{
			try {
				if (fis != null) { 
					fis.close();
				}
			} catch (Exception ex) {
				debug("IGNORED: " + ex.getMessage());
			}
		}
	}

	/**
	 * 주어진 프로파일의 내용을 파싱하여 (key-value) 형태의 구조체 배열을 반환한다.
	 * @param property String
	 * @return ArrayList
	 */
	@SuppressWarnings({ "rawtypes", "unchecked" })
	public static ArrayList loadPropertyFile(String property){

		// key - value 형태로 된 배열 결과
		ArrayList keyList = new ArrayList();

		String src = property.replace('\\', FILE_SEPARATOR).replace('/', FILE_SEPARATOR);
		FileInputStream fis = null;
		try
		{

			File srcFile = new File(EgovWebUtil.filePathBlackList(src));
			if (srcFile.exists()) {

				java.util.Properties props = new java.util.Properties();
				fis  = new FileInputStream(src);
				props.load(new java.io.BufferedInputStream(fis));
				fis.close();

				Enumeration plist = props.propertyNames();
				if (plist != null) {
					while (plist.hasMoreElements()) {
						Map map = new HashMap();
						String key = (String)plist.nextElement();
						map.put(key, props.getProperty(key));
						keyList.add(map);
					}
				}
			}
		} catch (Exception ex){
			debug(ex);
		} finally {
			try {
				if (fis != null) {
					fis.close();
				}
			} catch (Exception ex) {
				debug("IGNORED: " + ex.getMessage());
			}
		}

		return keyList;
	}
	
	/**
	 * 커스텀 프로퍼티  파일에서 인자로 주어진 문자열을 Key값으로 하는 프로퍼티 값을 반환한다
	 * @param key String
	 * @return String
	 */
	public static String getCustomProperty(String key){
		
		String value = "99";
		
		Properties prop = new Properties();
		value = value == null ? (String)prop.getProperty("key") : "99";
		
		try{
			
			if(customPropertis == null){
				File file = new File(GLOBALS_CUSTOM_PROPERTIES_FILE);
				if(file.exists()){
					customPropertis = new Properties();
					customPropertis.load(new java.io.BufferedInputStream(new FileInputStream(new File(GLOBALS_CUSTOM_PROPERTIES_FILE))));
				}					
			}
			
			if(customPropertis != null){
				if(customPropertis.getProperty(key) != null) {
					value = customPropertis.getProperty(key).trim();	
				}
			}
			
		}catch(Exception e){
			debug(e);
		}
		return value;		
	}
	
	
	/**
	 * edms 프로퍼티 파일에서 인자로 주어진 문자열을 Key값으로 하는 프로퍼티 값을 반환한다
	 * @param key String
	 * @return String
	 */
	public static String getEdmsProperty(String key){
		
		String value = "99";
		
		try{
			if(edmsPropertis == null){
				File file = new File(GLOBALS_EDMS_PROPERTIES_FILE);
				if(file.exists()){
					edmsPropertis = new Properties();
					edmsPropertis.load(new java.io.BufferedInputStream(new FileInputStream(new File(GLOBALS_EDMS_PROPERTIES_FILE))));		
				}
			}
			
			if(edmsPropertis != null){
				if(edmsPropertis.getProperty(key) != null) {
					value = edmsPropertis.getProperty(key).trim();
				}
			}
			
		}catch(Exception e){
			debug(e);
		}
		return value;		
	}
	
	/**
	 * 프로퍼티 캐쉬를 초기화 한다
	 */
	public static void resetProperty(){
		bizboxaPropertis = null;
		customPropertis = null;
		edmsPropertis = null;
	}	
	
	/**
	 * 시스템 로그를 출력한다.
	 * @param obj Object
	 */
	private static void debug(Object obj) {
		if (obj instanceof java.lang.Exception) {
			Logger.getLogger(BizboxAProperties.class).debug("IGNORED: " + ((Exception)obj).getMessage());
		}
	}
}

