package neos.cmm.systemx.license.service.impl;

import java.io.StringReader;
import java.util.HashMap;
import java.util.Map;

import javax.annotation.Resource;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.stereotype.Service;
import org.tempuri.GrpInfoSoapProxy;
import org.tempuri.WS_GRP_RealUserUpdateAlphaResponseWS_GRP_RealUserUpdateAlphaResult;
import org.w3c.dom.Document;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;
import org.xml.sax.InputSource;

import cloud.CloudConnetInfo;
import main.web.BizboxAMessage;
import neos.cmm.systemx.license.dao.LicenseDAO;
import neos.cmm.systemx.license.service.LicenseService;
import neos.cmm.util.AESCipher;
import neos.cmm.util.BizboxAProperties;
import neos.cmm.util.CommonUtil;
import neos.cmm.util.HttpJsonUtil;
import net.sf.json.JSONObject;
import net.sf.json.JSONSerializer;



@Service("LicenseService")
public class LicenseServiceImpl implements LicenseService {
	/* 로그 설정 */
	Logger LOG = LogManager.getLogger(this.getClass());
	
	/* 변수 정의 - DAO */
	@Resource(name = "LicenseDAO")
	private LicenseDAO licenseDAO;
	
	private static String LicenseDBCnt = null;
	private static String gcmsConnectionYn = "";
	
	public void resetLicense() {
		LicenseDBCnt = null;
		gcmsConnectionYn = "";		
	}
	
	public String updateDBLicenseKey(Map<String, Object> params) throws Exception {
		
		LicenseDBCnt = null;
		
		licenseDAO.updateLicenseKey(params);
		
		Map<String, Object> groupInfo = licenseDAO.getGroupInfo(params);
		
		if(groupInfo != null && groupInfo.get("licenseKey") != null && !groupInfo.get("licenseKey").equals("")) {
			String licenseCheck = groupInfo.get("licenseKey").toString().replace(AESCipher.AES_Encode(params.get("groupSeq").toString()) + "▦", "");
			
			String array[] = licenseCheck.split("â¦");
			
			if(array.length < 2){
				array = licenseCheck.split("▦");
			}
			
			String gwCount = AESCipher.AES_Decode(array[0]);
			String mailCount = AESCipher.AES_Decode(array[1]);
			
			return "GW [" + gwCount + "] , Mail [" + mailCount + "]";
			
		}else {
			return "Not set";
		}		
		
	}
	
	/* 라이센스 카운트 가져오기 */
	public Map<String, Object> LicenseCountShow(Map<String, Object> params) throws Exception {
		
		/* 변수정의 */
		Map<String, Object> licenseCount = new HashMap<String, Object>();  
		Map<String, Object> gwLicenseCount = new HashMap<String, Object>(); 
		Map<String, Object> mailLicenseCount = new HashMap<String, Object>(); 
		Map<String, Object> notLicenseCount = new HashMap<String, Object>(); 
		
		try {
			String licenseCheck = BizboxAProperties.getCustomProperty("BizboxA.licenseCount");
			
			// 현재 실 사용자 라이센스 값 가져오기 (그룹웨어)
			params.put("licenseCheckGubun", "gw");
			gwLicenseCount = (Map<String, Object>)licenseDAO.LicenseCountShow(params);
			int realGwLicenseCount = Integer.parseInt(gwLicenseCount.get("licenseCnt").toString());
			
			// 현재 실 사용자 라이센스 값 가져오기 (메일)
			params.put("licenseCheckGubun", "mail");
			mailLicenseCount = (Map<String, Object>)licenseDAO.LicenseCountShow(params);
			int realMailLicenseCount = Integer.parseInt(mailLicenseCount.get("licenseCnt").toString());
			
			// 현재 실 사용자 라이센스 값 가져오기 (비라이센스)
			params.put("licenseCheckGubun", "notLicense");
			notLicenseCount = (Map<String, Object>)licenseDAO.LicenseCountShow(params);
			int realNotLicenseCount = Integer.parseInt(notLicenseCount.get("licenseCnt").toString());
			
			//DB라이센스키 조회 
			if(LicenseDBCnt == null || CloudConnetInfo.getBuildType().equals("cloud")){
				
				Map<String, Object> groupInfo = licenseDAO.getGroupInfo(params);
				
				if(groupInfo != null && groupInfo.get("licenseKey") != null && !groupInfo.get("licenseKey").equals("")) {
					LicenseDBCnt = groupInfo.get("licenseKey").toString().replace(AESCipher.AES_Encode(params.get("groupSeq").toString()) + "▦", "");
					licenseCheck = LicenseDBCnt;
				}else {
					LicenseDBCnt = "";
				}
				
			}else if(!LicenseDBCnt.equals("")) {
				licenseCheck = LicenseDBCnt;
			}
			
			if(!licenseCheck.equals("99")) {		// 개발모드
				// 전체 카운트 가져오기
				String array[] = licenseCheck.split("â¦");
				
				if(array.length < 2){
					array = licenseCheck.split("▦");
				}
				
				String gwCount = AESCipher.AES_Decode(array[0]);
				String mailCount = AESCipher.AES_Decode(array[1]);
				
				int gwCountNum = Integer.parseInt(gwCount);
				int mailCountNum = Integer.parseInt(mailCount);
				
				if (gwCountNum > Integer.MAX_VALUE || gwCountNum < Integer.MIN_VALUE) {//정수형 오버플로우 방지 적용
			        throw new IllegalArgumentException("out of bound");
			    }
				if (mailCountNum > Integer.MAX_VALUE || mailCountNum < Integer.MIN_VALUE) {//정수형 오버플로우 방지 적용
			        throw new IllegalArgumentException("out of bound");
			    }
				
				int totalCount = gwCountNum + mailCountNum;

				licenseCount.put("resultCode", "success");
				licenseCount.put("totalGwCount", gwCount);
				licenseCount.put("totalMailCount", mailCount);
				licenseCount.put("realGwCount", realGwLicenseCount);
				licenseCount.put("realMailCount", realMailLicenseCount);
				licenseCount.put("realNotLicenseCount", realNotLicenseCount);
				
				int mailOverCnt = 0;
				if(realMailLicenseCount > Integer.parseInt(mailCount)){
					mailOverCnt = realMailLicenseCount - Integer.parseInt(mailCount);
				}
				
				if((Integer.parseInt(gwCount) - mailOverCnt) > realGwLicenseCount){
					licenseCount.put("executeYn", "0");	
				}else{
					licenseCount.put("executeYn", "1");
				}
				
				if(totalCount > (realGwLicenseCount + realMailLicenseCount)) {
					licenseCount.put("executeMailYn", "0");
				} else {
					licenseCount.put("executeMailYn", "1");
				}

				
			} else {
				//라이센스 서버 요청 
				
				String gcmsCd = params.get("groupSeq").toString();
				
	            String cUserCnt = "0";
	            String mailUserLimit = "0";
	            String eYn = "1";
	            String eMailYn = "1";
	            
	            if(!gcmsConnectionYn.equals("N")) {
					//전자결재 카운트조회
					JSONObject jsonParam = new JSONObject();
					jsonParam.put("custCd",gcmsCd);
					jsonParam.put("prodCd","alpha");
					jsonParam.put("userCnt",realGwLicenseCount);
					jsonParam.put("mailCnt",realMailLicenseCount);
					
					String responseStr = HttpJsonUtil.execute("POST", "http://gcms.bizboxa.com:60801/gcms_api/License/GetUserLicense", jsonParam);
					
					if(responseStr != null && responseStr != "") {
						Map<String, Object> resultMap = JSONObject.fromObject(JSONSerializer.toJSON(responseStr));
						
						if(resultMap != null && resultMap.get("resultCode") != null && resultMap.get("resultCode").equals("1")) {
							Map<String, Object> resultMapInfo = (Map<String, Object>) resultMap.get("result");
							
							if(resultMapInfo != null) {
					            cUserCnt = resultMapInfo.get("apprUserCnt").toString();
					            mailUserLimit = resultMapInfo.get("apprMailCnt").toString();
					            eYn = resultMapInfo.get("executeUserYn").toString();
					            eMailYn = resultMapInfo.get("executeMailYn").toString();
							}
						}
						
						gcmsConnectionYn = "Y";
						
					} else if(gcmsConnectionYn.equals("")) {
						gcmsConnectionYn = "N";
					}
	            }
								
				if(!gcmsConnectionYn.equals("Y")) {
					
					GrpInfoSoapProxy grpInfo = new GrpInfoSoapProxy();
					WS_GRP_RealUserUpdateAlphaResponseWS_GRP_RealUserUpdateAlphaResult webServiceData = new WS_GRP_RealUserUpdateAlphaResponseWS_GRP_RealUserUpdateAlphaResult();
					
					webServiceData = grpInfo.WS_GRP_RealUserUpdateAlpha(gcmsCd, realGwLicenseCount, realMailLicenseCount);
	   
		            DocumentBuilderFactory factory  =  DocumentBuilderFactory.newInstance();
		            //부적절한 XML 외부 개체 참조 (XXE 공격)
		            factory.setFeature("http://xml.org/sax/features/external-general-entities", false);
		            factory.setFeature("http://xml.org/sax/features/external-parameter-entities", false);
		            factory.setFeature("http://apache.org/xml/features/nonvalidating/load-external-dtd", false);
		            DocumentBuilder builder    =  factory.newDocumentBuilder();
		            Document document     =  builder.parse(new InputSource(new StringReader(webServiceData.get_any()[1].toString())));

		            NodeList gwNodeList     =  document.getElementsByTagName("CONTRACT_USER_CNT");
		            NodeList mailNodeList     =  document.getElementsByTagName("MailUserLimit");
		            NodeList executeGwNodeList     =  document.getElementsByTagName("EXECUTE_YN");
		            NodeList executeMailNodeList     =  document.getElementsByTagName("EXECUTE_MAIL_YN");

		            Node gwTextNode      =  gwNodeList.item(0).getChildNodes().item(0);
		            Node mailTextNode      =  mailNodeList.item(0).getChildNodes().item(0);
		            Node executeGwTextNode      =  executeGwNodeList.item(0).getChildNodes().item(0);
		            Node executeMailTextNode      =  executeMailNodeList.item(0).getChildNodes().item(0);
		            
		            cUserCnt = gwTextNode.getNodeValue();
		            mailUserLimit = mailTextNode.getNodeValue();
		            eYn = executeGwTextNode.getNodeValue();
		            eMailYn = executeMailTextNode.getNodeValue();					
					
				}
	            
	            licenseCount.put("resultCode", "success");
				licenseCount.put("totalGwCount", cUserCnt);
				licenseCount.put("totalMailCount", mailUserLimit);
				licenseCount.put("realGwCount", realGwLicenseCount);
				licenseCount.put("realMailCount", realMailLicenseCount);
				licenseCount.put("realNotLicenseCount", realNotLicenseCount);
				licenseCount.put("executeYn", eYn);
				licenseCount.put("executeMailYn", eMailYn);
			}
		}catch(Exception e) {
//			StringWriter sw = new StringWriter();
//			e.printStackTrace(new PrintWriter(sw));
//			String exceptionAsStrting = sw.toString();
			LOG.error("! [LicenseService.LicenseCountShow] ERROR - " + e);
			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
			throw e;
		}
				
		return licenseCount;
	}
	
	/* 입사처리, 사원정보 수정 라이센스 체크 */
	public Map<String, Object> LicenseAddCheck(Map<String, Object> params) throws Exception {

		/* 변수정의 */
		Map<String, Object> licenseAddCheck = new HashMap<String, Object>();
		
		try{
			params.put("groupSeq", params.get("groupSeq"));
			// 라이센스 체크
			Map<String, Object> licenseCount = LicenseCountShow(params);
			
			if(params.get("licenseAddGubun").equals("gw")){
				if(licenseCount.get("executeYn").equals("1")){
					licenseAddCheck.put("result", "fail");
					licenseAddCheck.put("resultCode", "-4");
					licenseAddCheck.put("resultMessage", BizboxAMessage.getMessage("TX800000069","그룹웨어 라이센스 초과"));					
				}else{
					//추가된 부분 (검토 완료_2020-09-07)
					//메일 > gw로 라이센스 이동인경우 (licenseAddGubunExt = mail2gw인경우)
					//라이센스 체크부분 LicenseDAO.LicenseCountShow 쿼리에서 gw 실사용자 카운트에서 -1을 하고 gcms 라이센스 api를 호출하여 excuteYn :0 이되었지만
					//realGwCount 에서 1을 더한 값(현재 실제 그룹웨어사용자수)이 gcms 라이센스에서 리턴해준  totalGwCount 와 같거나 크면 라이센스를 이동시키면 안된다.
					//예를들어 GW [50 / 50] , Mail [4 / 50] 인 경우
					//licenseAddGubunExt = mail2gw 에 의해 gw = 49 의 카운트로 gcms를 조회하여 excuteYn : 0 으로 되어 성공처리가되고
					//GW [51 / 50] , Mail [3 / 50] 이 되는 현상이 발생.
					
					int realGwCount = (int) licenseCount.get("realGwCount");
					
					if (realGwCount > Integer.MAX_VALUE || realGwCount < Integer.MIN_VALUE) {//정수형 오버플로우 방지 적용
				        throw new IllegalArgumentException("out of bound");
				    }
					
					if(params.containsKey("licenseAddGubunExt") && "mail2gw".equals((String) params.get("licenseAddGubunExt")) 
							&& (realGwCount) + 1 >= Integer.parseInt((String)licenseCount.get("totalGwCount")) ) {
						licenseAddCheck.put("result", "fail");
						licenseAddCheck.put("resultCode", "-4");
						licenseAddCheck.put("resultMessage", BizboxAMessage.getMessage("TX800000069","그룹웨어 라이센스 초과"));
					}else {
						licenseAddCheck.put("result", "success");
						licenseAddCheck.put("resultCode", "100");
						licenseAddCheck.put("resultMessage", BizboxAMessage.getMessage("TX000011981","성공"));	
					}
				}
			}else{
				if(licenseCount.get("executeMailYn").equals("1")){
					licenseAddCheck.put("result", "fail");
					licenseAddCheck.put("resultCode", "-5");
					licenseAddCheck.put("resultMessage", BizboxAMessage.getMessage("TX800000070","메일 라이센스 초과"));				
				}else{
					licenseAddCheck.put("result", "success");
					licenseAddCheck.put("resultCode", "100");
					licenseAddCheck.put("resultMessage", BizboxAMessage.getMessage("TX000011981","성공"));					
				}				
			}
			
		}catch(Exception e) {
//			StringWriter sw = new StringWriter();
//			e.printStackTrace(new PrintWriter(sw));
//			String exceptionAsStrting = sw.toString();
			LOG.error("! [LicenseService.LicenseAddCheck] ERROR - " + e);
			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
			throw e;
		}
		return licenseAddCheck;
	}
}
