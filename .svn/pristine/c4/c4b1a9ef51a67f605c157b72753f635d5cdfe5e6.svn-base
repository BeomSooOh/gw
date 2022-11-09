package neos.cmm.util.code;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import bizbox.orgchart.service.vo.LoginVO;
import bizbox.orgchart.util.JedisClient;
import cloud.CloudConnetInfo;
import egovframework.com.cmm.util.EgovUserDetailsHelper;
import neos.cmm.util.CommonUtil;
import neos.cmm.util.code.service.impl.CommonCodeDAO;

/**
 * 클라우드 공통코드, 옵션 유틸리티
 * @author yongil
 *
 */

public class CloudCommonCodeUtil {
	private static Logger logger = LogManager.getLogger(CloudCommonCodeUtil.class);
	
	/**
	 * 세션에서 기본 파라미터 가져오기
	 * 
	 * @return
	 */
	private static String getBaseParam() {
		String groupSeq = "";
		try {
			LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
			if(loginVO == null){
				return "";
			}
			groupSeq = loginVO.getGroupSeq();
			logger.debug("groupSeq : " + groupSeq);
		} catch (Exception e) {
			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
		}
		
		return groupSeq;
	}
	
	/**
	 * redis 연결 object
	 * @return
	 */
	private static JedisClient getJedisClient() {
		JedisClient jedisClient = CloudConnetInfo.getJedisClient();
		logger.debug("jedisClient : " + jedisClient);
		return jedisClient;
	}
	
	/**
	 * 공통코드 초기화
	 * @param commonCodeDAO
	 * @param groupSeq	그룹시퀀스가 있으면 해당 그룹만 초기화
	 * @throws Exception
	 */
	public static void cloudInit(CommonCodeDAO commonCodeDAO, String groupSeq) throws Exception {
			JedisClient jedis = getJedisClient();
		
			if(groupSeq == null){
				
				List<Map<String, String>> list = jedis.getManageInfoList();
				logger.debug("list : " + list);

				if (list != null && list.size() > 0) {
					for(Map<String,String> map : list) {
						if(map.get("OPERATE_STATUS") != null && map.get("OPERATE_STATUS").equals("20")) {
							try {
								logger.debug("map : " + map);
	
								groupSeq = map.get("GROUP_SEQ");
								logger.debug("GROUP_SEQ : " + groupSeq);
	
								Map<String,String> baseParam = jedis.getDBInfo(groupSeq);
								
								// 이미 등록된 공통코드가 없을 경우 진행
								boolean isExist = jedis.isExistCommonCode(groupSeq);
								if (!isExist) {
									Map<String, Object> param = new HashMap<String, Object>();
									param.put("groupSeq", groupSeq);
									List<Map<String, String>> codeList = commonCodeDAO.selectCommonCodeList(param) ;
									logger.debug("codeList : " + codeList.size());
									jedis.initCommonCode(groupSeq, codeList);
								} else {
									logger.info("CommonCode isExist : " + isExist);
								}
							} catch (Exception e) {
								CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
							}
						}
					}
				}
				
			}
			else{
				Map<String, Object> param = new HashMap<String, Object>();
				param.put("groupSeq", groupSeq);
				
				List<Map<String, String>> list = commonCodeDAO.selectCommonCodeList(param);
				List<Map<String, String>> codeList = null ;
				
				jedis.initCommonCode(groupSeq, list);
			}
	}
	
	public static  void cloudInitChild(CommonCodeDAO commonCodeDAO, String groupSeq) throws Exception {
		JedisClient jedis = getJedisClient();
		
		
		if(groupSeq == null){
			
			List<Map<String, String>> list = jedis.getManageInfoList();
			logger.debug("list : " + list);

			if (list != null && list.size() > 0) {
				for(Map<String,String> map : list) {
					if(map.get("OPERATE_STATUS") != null && map.get("OPERATE_STATUS").equals("20")) {
						try {
							logger.debug("map : " + map);
	
							groupSeq = map.get("GROUP_SEQ");
							logger.debug("GROUP_SEQ : " + groupSeq);
	
							boolean isExist = jedis.isExistCommonCode(groupSeq);
	
							if (!isExist) {
								Map<String, Object> param = new HashMap<String, Object>();
								param.put("groupSeq", groupSeq);
								List<Map<String, String>> codeList = commonCodeDAO.selectChildCommonCode(param) ;
								logger.debug("codeList : " + codeList.size());
								jedis.initCommonCode(map.get("GROUP_SEQ"), codeList);
							} else {
								logger.info("CommonCode isExist : " + isExist);
							}
	
						} catch (Exception e) {
							CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
						}
					}
				}
			}
			
		}
		else{
			Map<String, Object> param = new HashMap<String, Object>();
			param.put("groupSeq", groupSeq);
			
			List<Map<String, String>> list = commonCodeDAO.selectChildCommonCode(param) ;
	
			jedis.initCommonCode(groupSeq, list);
		}
	}
		
	public static  List<Map<String, String>>  getCloudCodeList( String codeId )throws Exception  {		
		String groupSeq = getBaseParam();
		JedisClient jedis = getJedisClient();
		
		List<Map<String,String>> list = jedis.getCodeList(groupSeq, codeId);
		org.apache.log4j.Logger.getLogger( CloudCommonCodeUtil.class ).debug( "getCloudCodeList codeId = " + codeId + ",  result : " + list);
		return list;
	}
	
	public static  List<Map<String, String>>  getCloudCodeList( String codeId, Map<String, Object> param )throws Exception  {		
		String groupSeq = param.get("groupSeq") + "";
		JedisClient jedis = getJedisClient();
		
		List<Map<String,String>> list = jedis.getCodeList(groupSeq, codeId);
		logger.debug("list : " + list);
		return list;
	}
	
	
	public static  List<Map<String, String>>  getCloudChildCodeList( String codeId )throws Exception  {		
		String groupSeq = getBaseParam();
		JedisClient jedis = getJedisClient();
		
		List<Map<String,String>> list = jedis.getChildCodeList(groupSeq, codeId);
		logger.debug("list : " + list);
		return list;
	}
	
	public static  List<Map<String, String>>  getCloudChildCodeListLang( String codeId, String langCode )throws Exception  {		
		String groupSeq = getBaseParam();
		JedisClient jedis = getJedisClient();
		
		List<Map<String,String>> list = jedis.getCodeListLang(groupSeq, codeId, langCode);
		logger.debug("list : " + list);
		return list;
	}
	
	public static  List<Map<String, String>>  getCloudChildCodeListAll()throws Exception  {		
		String groupSeq = getBaseParam();
		JedisClient jedis = getJedisClient();
		
		List<Map<String,String>> list = jedis.getChildCodeListAll(groupSeq);
		logger.debug("list : " + list);
		return list;
	}
	
	public static  List<Map<String, String>>  getCloudCodeListLang( String codeId, String langCode)throws Exception  {
		String groupSeq = getBaseParam();
		JedisClient jedis = getJedisClient();
		
		List<Map<String,String>> list = jedis.getCodeListLang(groupSeq, codeId, langCode);
		logger.debug("list : " + list + " / langCode : " + langCode);
		
		return list;
	}
	
	public static  String getCloudCodeName( String codeId, String code, String langCode ) throws Exception  {		
		String groupSeq = getBaseParam();
		JedisClient jedis = getJedisClient();
		
		String s = jedis.getCodeName(groupSeq, codeId, code, langCode);
		logger.debug("s : " + s);
		return s;
		
	}
	
	
	
	/**
	 * 공통옵션 초기화
	 * @param commonCodeDAO
	 * @param groupSeq	그룹시퀀스가 있으면 해당 그룹만 초기화
	 * @throws Exception
	 */
	public static void cmmOptionInit(CommonCodeDAO commonCodeDAO, String groupSeq) throws Exception {
			JedisClient jedis = getJedisClient();
		
			if(groupSeq == null){
				List<Map<String, String>> list = jedis.getManageInfoList();
				logger.debug("list : " + list);

				if (list != null && list.size() > 0) {
					for(Map<String,String> map : list) {
						if(map.get("OPERATE_STATUS") != null && map.get("OPERATE_STATUS").equals("20")) {
							try {
							groupSeq = map.get("GROUP_SEQ");
							
							Map<String, Object> param = new HashMap<String, Object>();
							param.put("groupSeq", groupSeq);
							param.put("type", "cm");
							
							List<Map<String, String>> optionList = commonCodeDAO.selectCommonOptionList(param) ;
							
							jedis.initCMOptionCode(groupSeq, "CM", optionList);
							} catch (Exception e) {
								CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
							}
						}
						
					}
				}
				
			}
			else{
				Map<String, Object> param = new HashMap<String, Object>();
				param.put("groupSeq", groupSeq);
				param.put("type", "cm");
				List<Map<String, String>> optionList = commonCodeDAO.selectCommonOptionList(param) ;
				
				jedis.initCMOptionCode(groupSeq, "CM", optionList);
			}
	}
	
	public static String cmmGetOptionValue(String groupSeq, String compSeq, String optionId) throws Exception {
		
		try {
			return getJedisClient().getOptionValue(groupSeq, compSeq, "CM", optionId);	
		}catch(Exception e){
			return "";
		}

	}	

	
}

