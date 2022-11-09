package neos.cmm.util.code;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import cloud.CloudConnetInfo;
import neos.cmm.util.code.service.impl.CommonCodeDAO;

public class CommonCodeUtil extends CloudCommonCodeUtil {

	private static Map<String, List<Map<String, String>>> codeHashMap = null ;
	private static Map<String, List<Map<String, String>>> codeChildHashMap = null ;
	
	private static Map<String, List<Map<String, String>>>codeMultiHashMap = null ; // 다국어용
	private static Map<String, List<Map<String, String>>> codeChildMultiHashMap = null ; // 다국어용
	
	private static Object listLock = new Object();
	private static Object listChildLock = new Object();
	private static Object nameLock = new Object();
	private static Object nameChildLock = new Object();

	//상속을 못하게 하기위했어 생성자를 private 으로함.
	//private CommonCodeUtil() {};

	/**
	 * 전체코드 가져오기(ISCHILD 가 'Y' 인것 제외함)
	 */
	public static  void init(CommonCodeDAO commonCodeDAO, String groupSeq) throws Exception {
		if(CloudConnetInfo.getBuildType().equals("cloud")){
			cloudInit(commonCodeDAO, groupSeq);
		}else{
			codeHashMap = null ;
			codeHashMap = new HashMap <String, List<Map<String, String>>>();
			codeMultiHashMap = null;
			codeMultiHashMap = new HashMap <String, List<Map<String, String>>>();
			List<Map<String, String>> list = commonCodeDAO.selectCommonCode();
			List<Map<String, String>> codeList = null ;
			
			List<Map<String, String>> listMulti = commonCodeDAO.selectCommonCodeMulti();
			
			Map<String, String> codeMap = new HashMap<String, String>();
			int rowNum =  0;
			int rowNumMulti = 0;
			if( list != null ){
				rowNum = list.size() ;
			}
			
			if( listMulti != null ){
				rowNumMulti = listMulti.size();
			}
	
			String curCiflagCode = "" ;
			String prevCiflagCode = "" ;
			int inx = 0 ;
			int inxm = 0 ;
			//한글만 가져오기(기존)
			for( ; inx < rowNum; inx++ ) {
				codeMap = list.get(inx) ;
				curCiflagCode = codeMap.get("CODE_ID");
				
				if( !prevCiflagCode.equals(curCiflagCode)) {
					if(inx != 0) {
						codeHashMap.put(prevCiflagCode, codeList) ;
					}
					prevCiflagCode = curCiflagCode ;
					codeList = new ArrayList<Map<String, String>>();
					codeList.add(codeMap);
	
				}else {
					if(codeList!=null) {//Null Pointer 역참조
					codeList.add(codeMap);
					}
				}
			}
			
			codeHashMap.put(prevCiflagCode, codeList);
			
			codeList = new ArrayList<Map<String, String>>(); // 리스트 배열 초기화
			codeMap = new HashMap<String, String>(); // 초기화
			
			//다국어 가져오기(추가)
			curCiflagCode = "" ;
			prevCiflagCode = "" ;
			for( ; inxm < rowNumMulti; inxm++ ) {
				codeMap = listMulti.get(inxm) ;
				curCiflagCode = codeMap.get("CODE_ID");
				
				if( !prevCiflagCode.equals(curCiflagCode)) {
					if(inxm != 0) {
						codeMultiHashMap.put(prevCiflagCode, codeList) ;
					}
					//System.out.println("a:["+prevCiflagCode+"] "+codeMultiHashMap.get(prevCiflagCode));
					prevCiflagCode = curCiflagCode ;
					codeList = new ArrayList<Map<String, String>>();
					codeList.add(codeMap);
	
				}else {
					codeList.add(codeMap);
				}
			}
			
			codeMultiHashMap.put(prevCiflagCode, codeList);
		}
		
	}
	

	/**
	 * 전체코드 가져오기(ISCHILD 가 'Y' 인것만 가져옴)
	 */
	public static  void initChild(CommonCodeDAO commonCodeDAO, String groupSeq) throws Exception {
		if(CloudConnetInfo.getBuildType().equals("cloud")){
			cloudInitChild(commonCodeDAO, groupSeq);
		}else{
			codeChildHashMap = null ;
			codeChildHashMap = new HashMap <String, List<Map<String, String>>>() ;
			codeChildMultiHashMap = null;
			codeChildMultiHashMap = new HashMap <String, List<Map<String, String>>>();
			List<Map<String, String>> list = commonCodeDAO.selectChildCommonCode() ;
			List<Map<String, String>> listMulti = commonCodeDAO.selectChildCommonCodeMulti() ;
			List<Map<String, String>> codeList = null ;
			Map<String, String> codeMap = new HashMap<String, String>();
			int rowNum =  0 ;
			int rowNumMulti = 0 ;
			if( list != null ) {
				rowNum = list.size() ;
			}
			
			if( listMulti != null ) {
				rowNumMulti = listMulti.size() ;
			}
	
			String curCiflagCode = "" ;
			String prevCiflagCode = "" ;
			int inx = 0 ;
			int inxm = 0 ;
			for( ; inx < rowNum; inx++ ) {
				codeMap = list.get(inx) ;
				curCiflagCode = codeMap.get("CODE_ID");
	
				if( !prevCiflagCode.equals(curCiflagCode)) {
					if(inx != 0) {
						codeChildHashMap.put(prevCiflagCode, codeList) ;
					}
					prevCiflagCode = curCiflagCode ;
					codeList = new ArrayList<Map<String, String>>();
					codeList.add(codeMap);
	
				}else {
					if(codeList!=null) {//Null Pointer 역참조
					codeList.add(codeMap);
					}
				}
			}
	
			codeChildHashMap.put(prevCiflagCode, codeList) ;
			
			codeList = new ArrayList<Map<String, String>>(); // 리스트 배열 초기화
			codeMap = new HashMap<String, String>(); // 초기화
			
			curCiflagCode = "" ;
			prevCiflagCode = "" ;
			
			for( ; inxm < rowNum; inxm++ ) {
				codeMap = listMulti.get(inxm) ;
				curCiflagCode = codeMap.get("CODE_ID");
	
				if( !prevCiflagCode.equals(curCiflagCode)) {
					if(inxm != 0) {
						codeChildMultiHashMap.put(prevCiflagCode, codeList) ;
					}
					prevCiflagCode = curCiflagCode ;
					codeList = new ArrayList<Map<String, String>>();
					codeList.add(codeMap);
	
				}else {
					codeList.add(codeMap);
				}
			}
	
			codeChildMultiHashMap.put(prevCiflagCode, codeList) ;
		}
		
	}

	/**
	 * 코드리스트를 반환한다.
	 * @param flagCode
	 * @return
	 */
	public static  List<Map<String, String>>  getCodeList( String codeID )throws Exception  {
		if (CloudConnetInfo.getBuildType().equals("cloud")){
			return getCloudCodeList(codeID);
		} else {
			synchronized(CommonCodeUtil.listLock) {
				return codeHashMap.get(codeID) ;
			}
		}
	}
	
	
	public static  List<Map<String, String>>  getCodeList( String codeID, Map<String, Object> param )throws Exception  {
		if (CloudConnetInfo.getBuildType().equals("cloud")){
			return getCloudCodeList(codeID, param);
		} else {
			synchronized(CommonCodeUtil.listLock) {
				return codeHashMap.get(codeID) ;
			}
		}
	}
	
	/**
	 * 코드리스트를 반환한다.(다국어)
	 * @param flagCode
	 * @return
	 */
	public static  List<Map<String, String>>  getCodeList( String codeID , String langCode)throws Exception  {
		if (CloudConnetInfo.getBuildType().equals("cloud")){
			return getCloudCodeListLang(codeID, langCode);
		}else{
			synchronized(CommonCodeUtil.listLock) {
				return codeMultiHashMap.get(codeID+"-"+langCode);
			}
		}
	}

	/**
	 * 코드리스트를 반환한다.(Child)
	 * @param flagCode
	 * @return
	 */
	public static  List<Map<String, String>>  getChildCodeList( String codeID )throws Exception  {
		if (CloudConnetInfo.getBuildType().equals("cloud")){
			return getCloudChildCodeList(codeID);
		}else{
			synchronized(CommonCodeUtil.listChildLock) {
				return codeChildHashMap.get(codeID) ;
			}
		}
	}
	
	/**
	 * 코드리스트를 반환한다.(Child/다국어)
	 * @param flagCode
	 * @return
	 */
	public static  List<Map<String, String>>  getChildCodeList( String codeID , String langCode)throws Exception  {
		if (CloudConnetInfo.getBuildType().equals("cloud")){
			return getCloudChildCodeListLang(codeID, langCode);
		}else{
			synchronized(CommonCodeUtil.listChildLock) {
				return codeChildMultiHashMap.get(codeID+"-"+langCode) ;
			}
		}
	}

	/**
	 * 코드리스트 전체를 반환한다.(Child)
	 * @param flagCode
	 * @return
	 */
	public static  List<Map<String, String>>  getChildCodeListAll(  )throws Exception  {
		if (CloudConnetInfo.getBuildType().equals("cloud")){
			return getCloudChildCodeListAll();
		}else{
			List<Map<String, String>> list = new ArrayList<Map<String, String>>();
			synchronized(CommonCodeUtil.listChildLock) {
				Iterator<String> iter = codeChildHashMap.keySet().iterator();
				List<Map<String, String>> temp = null;
				while (iter.hasNext()) {
					String key = iter.next();
					String val = "";
					temp = 	codeChildHashMap.get(key);
					if(temp != null) {
						//System.out.println(temp.size() + " :  temp.size()");
						if(temp.size() > 0){
							val = temp.get(0).get("CODE_DC");
						}	
					}
					
					Map<String, String> item = new HashMap<String, String>();
					item.put("CODE", key);
					item.put("CODE_DC", val);
					list.add(item);
				}
			}
			return list;
		}
	}

	/**
	 * 코드 이름을 반환 한다.
	 * @param flagCode
	 * @param ciKeyCode
	 * @param columnName
	 * @return
	 */
	public static  String getCodeName( String codeID, String code ) throws Exception  {
		if (CloudConnetInfo.getBuildType().equals("cloud")){
			return getCloudCodeName(codeID, code, "kr");
		}else{
			return getCodeName( codeID, code, "kr") ;
		}
	}
	/**
	 * 코드 이름을 반환 한다.
	 * @param flagCode
	 * @param ciKeyCode
	 * @param columnName
	 * @return
	 */
	public static  String getCodeName( String codeID, String code, String lang ) throws Exception  {
		if (CloudConnetInfo.getBuildType().equals("cloud")){
			return getCloudCodeName(codeID, code, lang);
		}else{
			synchronized(CommonCodeUtil.nameLock) {
				List<Map<String, String>> codeList =  codeHashMap.get(codeID) ;
				Map<String, String> codeMap = null ;
				String codeName = "" ;
				String keyCode = "" ;
				if(codeList == null ) { 
					return "" ;
				}
				int rowNum = 0 ;
				rowNum  = codeList.size() ;
	
				for( int inx=0; inx< rowNum; inx++) {
					codeMap =  codeList.get(inx);
					if( codeMap == null ) {
						return "" ;
					}
					keyCode = codeMap.get("CODE") ;
					if(code.equals(keyCode)) {
						if(lang.equals("kr")) {
							codeName = codeMap.get("CODE_NM") ;
						}
						else if (lang.equals("en")) { 
							codeName = codeMap.get("CODE_EN") ;
						}
						
						break;
					}
				}
				return codeName ;
			}
		}
	}
	
	public static  String getCodeFlag( String codeID, String code, String flagType ) throws Exception  {
		synchronized(CommonCodeUtil.nameLock) {
			List<Map<String, String>> codeList =  codeHashMap.get(codeID) ;
			Map<String, String> codeMap = null ;
			String codeName = "" ;
			String keyCode = "" ;
			if(codeList == null ) {
				return "" ;
			}
			int rowNum = 0 ;
			rowNum  = codeList.size() ;

			for( int inx=0; inx< rowNum; inx++) {
				codeMap =  codeList.get(inx);
				if( codeMap == null ) {
					return "" ;
				}
				keyCode = codeMap.get("CODE") ;
				if(code.equals(keyCode)) {
					if(flagType.equals("1")) {
						codeName = codeMap.get("FLAG_1") ;
					}
					else if (flagType.equals("2")) { 
						codeName = codeMap.get("FLAG_2") ;
					}
					
					break;
				}
			}
			return codeName ;
		}
	}
	
	public static  Map<String, String> getDetailCodeInfo(String codeID, String code) throws Exception  {
		synchronized(CommonCodeUtil.nameLock) {
			List<Map<String, String>> codeList =  codeHashMap.get(codeID) ;
			Map<String, String> codeMap = null ;
			String keyCode = "" ;
			if(codeList == null ) {
				return null;
			}
			int rowNum = 0 ;
			rowNum  = codeList.size() ;

			for( int inx=0; inx< rowNum; inx++) {
				codeMap =  codeList.get(inx);
				if( codeMap == null ) {
					continue;
				}
				keyCode = codeMap.get("CODE") ;
				if(code.equals(keyCode)) {
					return codeMap ;
				}
			}
			return null ;
		}
	}
	
	
	/**
	 * 코드 이름을 반환 한다.
	 * @param flagCode
	 * @param ciKeyCode
	 * @param columnName
	 * @return
	 */
	public static  String getChildCodeName( String codeID, String code ) throws Exception  {
			synchronized(CommonCodeUtil.nameChildLock) {
				List<Map<String, String>> codeList =  codeChildHashMap.get(codeID) ;
				Map<String, String> codeMap = null ;
				String codeName = "" ;
				String keyCode = "" ;
				if(codeList == null ) {
					return "" ;
				}
				int rowNum = 0 ;
				rowNum  = codeList.size() ;
	
				for( int inx=0; inx< rowNum; inx++) {
					codeMap =  codeList.get(inx);
					if( codeMap == null ) {
						return "" ;
					}
					keyCode = codeMap.get("CODE") ;
					if(code.equals(keyCode)) {
						codeName = codeMap.get("CODE_NM") ;
						break;
					}
				}
				return codeName ;
			}
	}

	/*
	 *  코드를 다시 가져온다.
	 */
	public static  void reBuild( CommonCodeDAO commonCodeDAO, String groupSeq ) throws Exception {
		synchronized(CommonCodeUtil.listLock) {
			synchronized(CommonCodeUtil.nameLock) {
				init(commonCodeDAO, groupSeq);
			}
		}
		synchronized(CommonCodeUtil.listChildLock) {
			synchronized(CommonCodeUtil.nameChildLock) {
				initChild(commonCodeDAO, groupSeq);
			}
		}

	}

	public static void initCmmOption(CommonCodeDAO commonCodeDAO, String groupSeq) throws Exception {		
		cmmOptionInit(commonCodeDAO, groupSeq);		
	}
}
