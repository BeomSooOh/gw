package neos.cmm.systemx.wehagoAdapter.service.impl;

import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.net.MalformedURLException;
import java.net.URLEncoder;
import java.security.InvalidAlgorithmParameterException;
import java.security.InvalidKeyException;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import javax.annotation.Resource;
import javax.crypto.BadPaddingException;
import javax.crypto.IllegalBlockSizeException;
import javax.crypto.Mac;
import javax.crypto.NoSuchPaddingException;
import javax.crypto.spec.SecretKeySpec;
import javax.servlet.http.HttpServletRequest;

import org.apache.commons.codec.binary.Base64;
import org.apache.log4j.Logger;
import org.springframework.stereotype.Service;

import api.common.model.APIResponse2;
import cloud.CloudConnetInfo;
import egovframework.com.cmm.EgovMessageSource;
import egovframework.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;
import neos.cmm.db.CommonSqlDAO;
import neos.cmm.systemx.orgAdapter.service.OrgAdapterService;
import neos.cmm.systemx.wehagoAdapter.dao.wehagoAdapterDAO;
import neos.cmm.systemx.wehagoAdapter.service.wehagoAdapterService;
import neos.cmm.util.AESCipher;
import neos.cmm.util.CommonUtil;
import neos.cmm.util.HttpJsonUtil;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;
import net.sf.json.JSONSerializer;

@Service("wehagoAdapterService")
public class wehagoAdapterServiceImpl implements wehagoAdapterService{

	protected Logger logger = Logger.getLogger( super.getClass() );

	/** EgovMessageSource */
	@Resource(name="egovMessageSource")
	EgovMessageSource egovMessageSource;

	@Resource(name = "commonSql")
	private CommonSqlDAO commonSql;

	@Resource(name = "wehagoAdapterDAO")
	private wehagoAdapterDAO wehagoAdapterDAO;

	@Resource(name = "OrgAdapterService")
	private OrgAdapterService orgAdapterService;

	String RSAPublicKey = "MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDHnMpO0btqa24zCzzAn+PBa9E178qB2cn3KwxUiwMX dYVkTDHmAGVNLJ34IXSY8BDjLOVDrHfrm4wqrfJkyWqc4d/dGrXfXeAYnOiSVRzmfvxjSGcc7hUDL0y4L2ncZdkst SC2fbplD/8nC/mMl/8M88mOR54GzAp/MDFqYTFWCwIDAQAB";
	String RSAPrivateKey = "MIICdQIBADANBgkqhkiG9w0BAQEFAASCAl8wggJbAgEAAoGBAMecyk7Ru2prbjMLPMCf48Fr0TXvyoHZyfcrDF SLAxd1hWRMMeYAZU0snfghdJjwEOMs5UOsd+ubjCqt8mTJapzh390atd9d4Bic6JJVHOZ+/GNIZxzuFQMvTLgva dxl2Sy1ILZ9umUP/ycL+YyX/wzzyY5HngbMCn8wMWphMVYLAgMBAAECgYAMAnPtkBLNkU8dBRUPpc8HKRx6 OUYez+Kl21Ivl/mEpM50vVzXMLjnjsKmViT0uqTZdi8JBkxkwYQKYVLPG4stb+wmbd0IGbJjT6dySFm2DirNyTweF5 YnmpEOs3fCtvjl7I3FHgPCgiOyuCO2d4Uy+YreOvsq09s+m5RrRBCmMQJBAPDGQxeAuTZMaquCDwZhZMtLZQk 1RiM7Sq7zt3NjFLGWhURPYN8ch6mQtRHH5WPMNqOlT/yaV2ls3AvSRE8bnukCQQDUPC8UcqKy3+avUoUjfiBB0 l4jivXH6a4RBeGZ6SmQUSOc/JiSSfKSgJGKn9tS3W2roaDsll0O/MmW1UH1APzTAkBDA9vusbxbWZ+jBvspmngUg XKownQ4ICukUF9yNVSwLSYAoltjHizATG+peErnoRJgMAX4V/kWdd81RxwOLLDpAkBmWlgCLn7UcTKZXtyij1MT K1cHIR8DOGkgAIwaY94NoXPhY9hYxJzdlm+aQRnOzsbzPNGVB7b9YV//A/35IG7NAkB9nMLhN3PzsmoDbRGq6 iJWWw2BtbXv8jyGxqXVvicCHCaTwKc06ZugmmrqWN9vqi2Xeb1zzuhtOeVJc1JDCn3F";

	// 위하고 가입 관련
	// 위하고 가입 도메인 생성
	@Override
	public Map<String, Object> getWehagoJoinUrl(Map<String, Object> params) throws UnsupportedEncodingException, InvalidKeyException, NoSuchAlgorithmException, NoSuchPaddingException, InvalidAlgorithmParameterException, IllegalBlockSizeException, BadPaddingException {
		Map<String, Object> resultMap = new HashMap<String, Object>();
		Map<String, Object> wehagoJoinUrlInfo = wehagoAdapterDAO.getWehagoJoinUrlInfo(params);

		resultMap.put("resultCode", "fail");
		resultMap.put("resultMsg", "연동정보 조회 시 오류가 발생했습니다.");

		if (wehagoJoinUrlInfo != null) {
			if (wehagoJoinUrlInfo.get("company_reg_no").equals("")) {
				resultMap.put("resultMsg", "연동할 회사에 사업자번호가 등록되지 않았습니다.");
			}
			else if (wehagoJoinUrlInfo.get("ceo_name_kr").equals("")) {
				resultMap.put("resultMsg", "연동할 회사에 대표자명이 등록되지 않았습니다.");
			}
			else if ("".equals(wehagoJoinUrlInfo.get("wehago_aes_key"))) {
				resultMap.put("resultMsg", "위하고 연동을 위한 암호화 키가 등록되지 않았습니다.");
			}
			else {
				Map<String, Object> serviceKey = new HashMap<String, Object>();

				serviceKey.put("company_name_kr", wehagoJoinUrlInfo.get("company_name_kr"));
				serviceKey.put("company_reg_no", wehagoJoinUrlInfo.get("company_reg_no").toString().replace("-", ""));
				serviceKey.put("company_sub_reg_no", wehagoJoinUrlInfo.get("company_sub_reg_no"));
				serviceKey.put("company_business_type", wehagoJoinUrlInfo.get("company_business_type"));
				serviceKey.put("company_business_no", wehagoJoinUrlInfo.get("company_business_no"));
				serviceKey.put("ceo_name_kr", wehagoJoinUrlInfo.get("ceo_name_kr"));
				serviceKey.put("company_tel1", wehagoJoinUrlInfo.get("company_tel1"));
				serviceKey.put("company_tel2", wehagoJoinUrlInfo.get("company_tel2"));
				serviceKey.put("company_tel3", wehagoJoinUrlInfo.get("company_tel3"));
				serviceKey.put("business_type_code", wehagoJoinUrlInfo.get("business_type_code"));
				serviceKey.put("business_format", wehagoJoinUrlInfo.get("business_format"));
				serviceKey.put("business_type", wehagoJoinUrlInfo.get("business_type"));
				serviceKey.put("company_zipcode", wehagoJoinUrlInfo.get("company_zipcode"));
				serviceKey.put("company_address1", wehagoJoinUrlInfo.get("company_address1"));
				serviceKey.put("company_address2", wehagoJoinUrlInfo.get("company_address2"));
				serviceKey.put("software_name", "bizbox");
				serviceKey.put("etc1", params.get("compSeq"));

				String domain = params.get("domain").toString();
				domain = new String(Base64.encodeBase64(domain.getBytes()), "UTF-8");

				serviceKey.put("domain", domain);
				serviceKey.put("rsa_public_key", RSAPublicKey);

				String serviceKeyStr = JSONObject.fromObject(serviceKey).toString();
				// 개발기(http://dev.wehago.com) 키 : 0c74da7014e34f488646a116024d0097
				// 개발기와 운영기 키가 다르기 때문에 디비에 값 추가(wehago_aes_key)
				serviceKeyStr = AESCipher.AES128EX_Encode(serviceKeyStr, wehagoJoinUrlInfo.get("wehago_aes_key").toString());
				Logger.getLogger( wehagoAdapterServiceImpl.class ).debug("wehagoAdapterService.getWehagoJoinUrl serviceKeyStr: " + serviceKeyStr);

				// TODO 이전 테스트시 wehagoServer값에 어떻게 url이 들어있었는지 모르겠는데 예상으로는 'http://dev.api.wehago.com' 으로 있어서 .api를 replace 제거처리 한 것 같음.
				// -> 혹시 wehagoServer 에 api쪽으로 호출할려고 사용하는 부분이 있는지 검토해야될 듯.
				// 생성 url로 위하고 호출시, 사업자번호가 이미 위하고에 가입되어있는 회사정보를 전달하면 로그인페이지로 넘어감.
//				String joinUrl = wehagoJoinUrlInfo.get("wehago_server").toString().replace(".api", "") + "/#/interface/join?is_douzone=T&service_key=" + URLEncoder.encode(serviceKeyStr,"UTF-8") + "&service_code=bizbox";
				String wehagoUrl = wehagoJoinUrlInfo.get("wehago_server").toString().replace("api.", "");
				String joinUrl = wehagoUrl + "/#/interface/join?is_douzone=T&service_key=" + URLEncoder.encode(serviceKeyStr,"UTF-8") + "&service_code=bizbox";
				Logger.getLogger( wehagoAdapterServiceImpl.class ).debug("wehagoAdapterService.getWehagoJoinUrl joinUrl: " + joinUrl);

				resultMap.put("resultCode", "success");
				resultMap.put("resultMsg", "연동정보 조회 성공");
				resultMap.put("joinUrl", joinUrl);
			}
		}
		return resultMap;
	}
	// 위하고 회사 가입 완료 체크용
	@Override
	public Map<String, Object> getWehagoJoinState(Map<String, Object> params) {
		Map<String, Object> resultMap = wehagoAdapterDAO.getWehagoServerInfo(params);

		if (resultMap != null) {
			resultMap.put("resultCode", "C");
		}
		else {
			resultMap = new HashMap<String, Object>();
			resultMap.put("resultCode", "P");
		}

		return resultMap;
	}
	// 위하고 회사 가입 완료 콜백(hrExtInterlockController 호출)
	@SuppressWarnings("unchecked")
	@Override
	public APIResponse2 wehagoJoinCallback(HttpServletRequest servletRequest) throws Exception {
		Enumeration params = servletRequest.getParameterNames();
		while (params.hasMoreElements()) {
			String name = (String)params.nextElement();
			Logger.getLogger( wehagoAdapterServiceImpl.class ).debug("wehagoAdapterService.wehagoJoinCallback " + name + " : " + servletRequest.getParameter(name));
		}

		APIResponse2 response = new APIResponse2();
		String groupSeq = "";

		// 도메인 정보로 groupSeq 조회
		String serverName = servletRequest.getServerName();
		Logger.getLogger( wehagoAdapterServiceImpl.class ).debug("wehagoAdapterService.wehagoJoinCallback serverName : " + serverName);
		Map<String, Object> jedisMp = CloudConnetInfo.getParamMapByDomain(serverName);
		if (jedisMp != null) {
			groupSeq = jedisMp.get("groupSeq") + "";
		}
		else {
			groupSeq = "demo";
		}
		Logger.getLogger( wehagoAdapterServiceImpl.class ).debug("wehagoAdapterService.wehagoJoinCallback groupSeq : " + groupSeq);

		String encryptKey = servletRequest.getParameter("encrypt_key");
		String securityParam = servletRequest.getParameter("security_param");
		Logger.getLogger( wehagoAdapterServiceImpl.class ).debug("wehagoAdapterService.wehagoJoinCallback encryptKey : " + encryptKey);
		Logger.getLogger( wehagoAdapterServiceImpl.class ).debug("wehagoAdapterService.wehagoJoinCallback securityParam : "  + securityParam);

		try {
			encryptKey = AESCipher.decryptRSA(encryptKey, RSAPrivateKey);
			securityParam = AESCipher.AES128EX_Decode(securityParam, encryptKey);
			Logger.getLogger( wehagoAdapterServiceImpl.class ).debug("wehagoAdapterService.wehagoJoinCallback decryptRSA encryptKey : " + encryptKey);
			Logger.getLogger( wehagoAdapterServiceImpl.class ).debug("wehagoAdapterService.wehagoJoinCallback AES128EX_Decode securityParam : "  + securityParam);
		} catch(Exception ex) {
			Logger.getLogger( wehagoAdapterServiceImpl.class ).error("wehagoAdapterService.wehagoJoinCallback AESCipher ERROR");
			CommonUtil.printStatckTrace(ex);//오류메시지를 통한 정보노출
			securityParam = "";
		}

		Map<String, Object> param = new HashMap<String, Object>();
		Map<String, Object> queryParam = new HashMap<String, Object>();

		if (securityParam != null && !securityParam.equals("")) {
			param = JSONObject.fromObject(JSONSerializer.toJSON(securityParam));
			param.put("groupSeq", groupSeq);

			if (param.get("etc1") != null) {
				param.put("etc1", param.get("etc1").toString().trim());
			}

			queryParam.putAll(param);
			Logger.getLogger( wehagoAdapterServiceImpl.class ).debug("wehagoAdapterService.wehagoJoinCallback queryParam : "  + queryParam);

			Map<String, Object> syncInfo = wehagoAdapterDAO.getWehagoSyncInfo(queryParam);
			Logger.getLogger( wehagoAdapterServiceImpl.class ).debug("wehagoAdapterService.wehagoJoinCallback syncInfo : "  + syncInfo);

			if (syncInfo.get("wehagoToken").equals("")) {
				//서버토큰정보가 없을경우 생성
				String serverToken = wehagoGetServerToken(syncInfo.get("wehagoServer").toString(), queryParam.get("authorization").toString(), queryParam.get("hash_key").toString(), "bizboxAlpha_" + groupSeq, syncInfo.get("wehagoSoftwareKey").toString(), queryParam.get("company_no").toString());
				Logger.getLogger( wehagoAdapterServiceImpl.class ).debug("wehagoAdapterService.wehagoJoinCallback serverToken : "  + serverToken);

				if (!serverToken.equals("")) {
					queryParam.put("wehagoToken", serverToken);
					Logger.getLogger( wehagoAdapterServiceImpl.class ).debug("wehagoAdapterService.wehagoJoinCallback param : "  + queryParam);
					wehagoAdapterDAO.updateWehagoToken(queryParam);
				}
			}
			wehagoAdapterDAO.updateWehagoJoinCallback(queryParam);

			response.setResultCode(200);
			response.setResultMessage("");
		}
		else {
			response.setResultCode(400);
			response.setResultMessage("요청한 값이 유효하지 않습니다.");
		}
		return response;
	}
	// 위하고 서버 토큰정보 조회
	@Override
	public String wehagoGetServerToken(String wehagoServer, String accessTokenIn, String hashKeyIn, String deviceIdIn, String softwareKeyIn, String cno) {
		Logger.getLogger( wehagoAdapterServiceImpl.class ).debug("wehagoAdapterService.wehagoGetServerToken : wehagoServer=" + wehagoServer + "|access_token=" + accessTokenIn + "|hash_key=" + hashKeyIn + "|device_id=" + deviceIdIn + "|software_key=" + softwareKeyIn + "|cno=" + cno);

		Map<String, Object> headers = new HashMap<String, Object>();

		String apiUrl = "/auth/fromsoftware/settingUserDeviceInfo";
		Long timestampNow = new Timestamp(System.currentTimeMillis()).getTime();
		String timestamp = timestampNow.toString();
		String transactionId = UUID.randomUUID().toString().toUpperCase();

		String hashKey = hashKeyIn+ timestamp;
		String hashDataIn = apiUrl + timestamp + transactionId;

		MessageDigest sh = null;
		try {
			sh = MessageDigest.getInstance("SHA-256");
		} catch (NoSuchAlgorithmException e) {
			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
		}
		try {
			sh.update(hashKey.getBytes("UTF-8"));
		} catch (UnsupportedEncodingException e) {
			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
		}
		byte byteData[] = sh.digest();
		hashKeyIn = new String(Base64.encodeBase64(byteData));

		SecretKeySpec signingKey = new SecretKeySpec( hashKeyIn.getBytes(), "HmacSHA256" );
		Mac mac = null;
		try {
			mac = Mac.getInstance("HmacSHA256");
		} catch (NoSuchAlgorithmException e) {
			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
		}
		try {
			mac.init( signingKey );
		} catch (InvalidKeyException e) {
			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
		}
		byte[] rawHmac = mac.doFinal( hashDataIn.getBytes() );

		String wehagoSign = new String(Base64.encodeBase64(rawHmac));

		headers.put("Authorization", accessTokenIn);
		headers.put("transaction-id", transactionId);
		headers.put("timestamp", timestamp);
		headers.put("cno", cno);
		headers.put("wehago-sign", wehagoSign);
		Logger.getLogger( wehagoAdapterServiceImpl.class ).debug("wehagoAdapterService.wehagoGetServerToken headers: " + headers);

		Map<String, Object> body = new HashMap<String, Object>();
		body.put("device_id", deviceIdIn);
		body.put("software_key", softwareKeyIn);
		body.put("software_name", "bizbox");
		body.put("token_type", "L");
		body.put("cno", cno);
		Logger.getLogger( wehagoAdapterServiceImpl.class ).debug("wehagoAdapterService.wehagoGetServerToken body: " + body);

		String responseStr = null;
		try {
			responseStr = HttpJsonUtil.executeCustom("POST", wehagoServer + apiUrl, body, headers);
		} catch (MalformedURLException e) {
			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
		} catch (IOException e) {
			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
		}
		
		Logger.getLogger( wehagoAdapterServiceImpl.class ).debug("wehagoAdapterService.wehagoGetServerToken responseStr: " + responseStr);

		if (responseStr != null) {
			Map<String, Object> resultMap = new HashMap<String, Object>();
			resultMap = JSONObject.fromObject(JSONSerializer.toJSON(responseStr));
			Logger.getLogger( wehagoAdapterServiceImpl.class ).debug("wehagoAdapterService.wehagoGetServerToken resultMap: " + resultMap);

			if (resultMap != null && resultMap.get("resultCode") != null && resultMap.get("resultCode").equals(200)) {
				Map<String, Object> resultData = (Map<String, Object>) resultMap.get("resultData");
				return resultData.get("thirdparty_a_token").toString();
			}
		}
		return "";
	}

	// 조직도 연동 관련
	// 위하고 API 호출 공통 함수
	// 위하고 회사 가입할때 인증 관련 정보(서버정보, 토큰값, 키, 아이디 등) 이미 다 있다는 가정으로 null check처리 안되어있음
	@SuppressWarnings("unchecked")
	@Override
	public Map<String, Object> wehagoApiCall(String groupSeq, String compSeq, String apiUrl, String method, Map<String, Object> params) {
		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("resultCode", "fail");
		resultMap.put("resultMsg", "");

		Map<String, Object> dbParam = new HashMap<String, Object>();
		dbParam.put("groupSeq", groupSeq);
		dbParam.put("compSeq", compSeq);

		//세팅정보 조회
		Map<String, Object> wehagoServerInfo = wehagoAdapterDAO.getWehagoServerInfo(dbParam);
		if (wehagoServerInfo == null) {
			return null;
		}

		params.put("cno", wehagoServerInfo.get("wehagoCno"));
		String wehagoServer = wehagoServerInfo.get("wehagoServer").toString();
		String wehagoToken = wehagoServerInfo.get("wehagoToken").toString();
		// 개발계 연동키: YMFctdCrQxac1Kwi
		// 운영계 연동키: kYnzIztVFrzeWqWi
		String wehagoKey = wehagoServerInfo.get("wehagoKey").toString();
		String wehagoId = wehagoServerInfo.get("wehagoId").toString();

		//인증파라미터 생성
		Long timestampNow = new Timestamp(System.currentTimeMillis()).getTime();
		String timestamp = timestampNow.toString();
		String transactionId = UUID.randomUUID().toString().toUpperCase();

		if (method.equals("GET")) {
			apiUrl = apiUrl.concat("?").concat(HttpJsonUtil.formEncodeCust(params));
		}

		String hashKey = wehagoToken+ timestamp;
		MessageDigest sh = null;
		try {
			sh = MessageDigest.getInstance("SHA-256");
		} catch (NoSuchAlgorithmException e) {
			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
		}
		try {
			sh.update(hashKey.getBytes("UTF-8"));
		} catch (UnsupportedEncodingException e) {
			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
		}
		byte byteData[] = sh.digest();
		String key = new String(Base64.encodeBase64(byteData));
		String hashData = apiUrl + timestamp + wehagoId;

		SecretKeySpec signingKey = new SecretKeySpec( key.getBytes(), "HmacSHA256" );
		Mac mac = null;
		try {
			mac = Mac.getInstance("HmacSHA256");
		} catch (NoSuchAlgorithmException e) {
			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
		}
		try {
			mac.init( signingKey );
		} catch (InvalidKeyException e) {
			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
		}
		byte[] rawHmac = mac.doFinal( hashData.getBytes() );

		String serverSign = new String(Base64.encodeBase64(rawHmac));
		String softwareUserId = null;
		try {
			softwareUserId = AESCipher.AES128EX_Encode(wehagoId, wehagoKey);
		} catch (InvalidKeyException e) {
			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
		} catch (UnsupportedEncodingException e) {
			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
		} catch (NoSuchAlgorithmException e) {
			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
		} catch (NoSuchPaddingException e) {
			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
		} catch (InvalidAlgorithmParameterException e) {
			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
		} catch (IllegalBlockSizeException e) {
			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
		} catch (BadPaddingException e) {
			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
		}

		//API 호출
		Map<String, Object> headers = new HashMap<String, Object>();
		headers.put("server-token", wehagoToken);
		headers.put("server-sign", serverSign);
		headers.put("timestamp", timestamp);
		headers.put("Transaction-ID", transactionId);
		headers.put("Software-user-id", softwareUserId);

		String responseStr = null;
		try {
			responseStr = HttpJsonUtil.executeCustom(method, wehagoServer + apiUrl, params, headers);
			Logger.getLogger( wehagoAdapterServiceImpl.class ).debug("wehagoAdapterService.wehagoApiCall responseStr: " + responseStr);
		} catch (MalformedURLException e) {
			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
		} catch (IOException e) {
			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
		}

		if (responseStr != null) {
			resultMap = JSONObject.fromObject(JSONSerializer.toJSON(responseStr));
			return resultMap;
		}
		else {
			return null;
		}
	}

	// 직급 직책 연동
	// 직급 직책 저장 공통 함수
	public Map<String, Object> wehagoInsertDutyPosition(String groupSeq, String compSeq, Map<String, Object> apiParam, String syncTp, String dpSeqDel) {
		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap = wehagoApiCall(groupSeq, compSeq, "/douzone-interface/positionrank/position", "POST", apiParam);

		if (resultMap != null && resultMap.get("resultCode") != null && resultMap.get("resultCode").toString().equals("200")) {
			if (syncTp.equals("I")) {
				List<Map<String, Object>> resultData = (List<Map<String, Object>>) resultMap.get("resultData");

				for (Map<String, Object> map : resultData) {
					Map<String, Object> mapParam = new HashMap<String, Object>();
					mapParam.put("dpType", apiParam.get("position_rank_type").equals("R") ? "POSITION" : "DUTY");
					mapParam.put("compSeq", compSeq);
					mapParam.put("dpSeq", map.get("seq"));
					mapParam.put("wehagoKey", map.get("position_rank_no"));

					wehagoAdapterDAO.updateWehagoDutyPositionKey(mapParam);
				}
			}
			else if (syncTp.equals("D")) {
				Map<String, Object> mapParam = new HashMap<String, Object>();
				mapParam.put("dpType", apiParam.get("position_rank_type").equals("R") ? "POSITION" : "DUTY");
				mapParam.put("compSeq", compSeq);
				mapParam.put("dpSeq", dpSeqDel);

				wehagoAdapterDAO.deleteWehagoDutyPositionKey(mapParam);
			}
			return resultMap;
		}
		else {
			return null;
		}
	}
	@Override
	@SuppressWarnings("unchecked")
	public Map<String, Object> wehagoInsertDutyPositionAll(String groupSeq, String compSeq) {
		Map<String, Object> resultMap = new HashMap<String, Object>();
		Map<String, Object> dbParam = new HashMap<String, Object>();

		dbParam.put("groupSeq", groupSeq);
		dbParam.put("compSeq", compSeq);

		Map<String, Object> apiParam = new HashMap<String, Object>();

		// 직책
		apiParam.put("seq", "0");
		apiParam.put("position_rank_type", "R"); //P: 직책 ,R:직급
		apiParam.put("position_rank_group_name", "그룹웨어연동직급");
		apiParam.put("position_rank_name", "--");

		resultMap = wehagoApiCall(groupSeq, compSeq, "/douzone-interface/positionrank/group", "POST", apiParam);
		if (resultMap != null && resultMap.get("resultCode") != null && resultMap.get("resultCode").toString().equals("200")) {
			Map<String, Object> resultData = (Map<String, Object>) resultMap.get("resultData");
			String positionRankGroupNo = resultData.get("position_rank_group_no").toString();

			Map<String, Object> mapParam = new HashMap<String, Object>();
			mapParam.put("compSeq", compSeq);
			mapParam.put("wehagoPositionGroup", positionRankGroupNo);

			wehagoAdapterDAO.updateWehagoDutyPositionGroupKey(mapParam);

			//일괄등록
			dbParam.put("dpType", "POSITION");
			List<Map<String, Object>> insertList = wehagoAdapterDAO.getWehagoGwDutyPositionAllList(dbParam);

			if (insertList != null && insertList.size() > 0) {
				apiParam = new HashMap<String, Object>();
				apiParam.put("position_rank_type", "R"); //P: 직책 ,R:직급
				apiParam.put("position_rank_group_no", positionRankGroupNo);

				JSONArray portletListJson = JSONArray.fromObject(insertList);
				apiParam.put("insert_list", portletListJson.toString());
				resultMap = wehagoInsertDutyPosition(groupSeq, compSeq, apiParam, "I", "");
			}
		}

		// 직급
		apiParam.put("position_rank_type", "P"); //P: 직책 ,R:직급
		apiParam.put("position_rank_group_name", "그룹웨어연동직책");
		apiParam.put("position_rank_name", "--");

		resultMap = wehagoApiCall(groupSeq, compSeq, "/douzone-interface/positionrank/group", "POST", apiParam);
		if (resultMap != null && resultMap.get("resultCode") != null && resultMap.get("resultCode").toString().equals("200")) {
			Map<String, Object> resultData = (Map<String, Object>) resultMap.get("resultData");
			String positionRankGroupNo = resultData.get("position_rank_group_no").toString();

			Map<String, Object> mapParam = new HashMap<String, Object>();
			mapParam.put("compSeq", compSeq);
			mapParam.put("wehagoDutyGroup", positionRankGroupNo);

			wehagoAdapterDAO.updateWehagoDutyPositionGroupKey(mapParam);

			//일괄등록
			dbParam.put("dpType", "DUTY");
			List<Map<String, Object>> insertList = wehagoAdapterDAO.getWehagoGwDutyPositionAllList(dbParam);

			if (insertList != null && insertList.size() > 0) {
				apiParam = new HashMap<String, Object>();
				apiParam.put("position_rank_type", "P"); //P: 직책 ,R:직급
				apiParam.put("position_rank_group_no", positionRankGroupNo);

				JSONArray portletListJson = JSONArray.fromObject(insertList);
				apiParam.put("insert_list", portletListJson.toString());
				resultMap = wehagoInsertDutyPosition(groupSeq, compSeq, apiParam, "I", "");
			}
		}
		return resultMap;
	}
	@Override
	public Map<String, Object> wehagoInsertDutyPositionOneSync(String groupSeq, String compSeq, String dpSeq, String dpType, String syncTp) {
		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("groupSeq", groupSeq);
		resultMap.put("compSeq", compSeq);
		resultMap.put("dpType", dpType);
		resultMap.put("dpSeq", dpSeq);

		Map<String, Object> apiParam = new HashMap<String, Object>();
		List<Map<String, Object>> insertList = wehagoAdapterDAO.getWehagoGwDutyPositionOneSyncInfo(resultMap);
		if (insertList != null) {
			for (Map<String, Object> map : insertList) {
				apiParam = new HashMap<String, Object>();
				apiParam.put("position_rank_type", dpType.equals("POSITION") ? "R" : "P");
				apiParam.put("position_rank_group_no", map.get("position_rank_group_no"));
				String positionRankNo = map.get("position_rank_no").toString();

				if (syncTp.equals("D")) {
					if (!positionRankNo.equals("")) {
						apiParam.put("deletePositionRankList", "[" + positionRankNo + "]");
						wehagoInsertDutyPosition(groupSeq, map.get("comp_seq").toString(), apiParam, syncTp, map.get("seq").toString());
					}
				}
				else {
					List<Map<String, Object>> paramList = new ArrayList<Map<String, Object>>();
					Map<String, Object> paramInfo = new HashMap<String, Object>();

					paramInfo.put("position_rank_name", map.get("position_rank_name"));
					paramInfo.put("position_rank_order", map.get("position_rank_order"));

					if (positionRankNo.equals("")) {
						paramInfo.put("seq", map.get("seq"));
					}
					else {
						paramInfo.put("position_rank_no", map.get("position_rank_no"));
						paramInfo.put("position_rank_group_no", map.get("position_rank_group_no"));
					}
					paramList.add(paramInfo);

					JSONArray portletListJson = JSONArray.fromObject(paramList);
					apiParam.put(positionRankNo.equals("") ? "insert_list" : "update_list", portletListJson.toString());
					wehagoInsertDutyPosition(groupSeq, map.get("comp_seq").toString(), apiParam, positionRankNo.equals("") ? "I" : "M", "");
				}
			}
		}
		return null;
	}

	// 조직도 연동
	// 조직도 저장 공통 함수
	@SuppressWarnings("unchecked")
	@Override
	public Map<String, Object> wehagoInsertOrgChart(String groupSeq, String compSeq, Map<String, Object> params) {
		Map<String, Object> resultMap = new HashMap<String, Object>();

		resultMap = wehagoApiCall(groupSeq, compSeq, "/common/douzone/organization/list", "POST", params);
		if (resultMap != null && resultMap.get("resultCode") != null && resultMap.get("resultCode").toString().equals("200")) {
			Map<String, Object> resultData = (Map<String, Object>)resultMap.get("resultData");

			//일괄등록일 경우 위하고키 업데이트
			if (resultData.get("insertList") != null) {
				List<Map<String, Object>> insertList = (List<Map<String, Object>>) resultData.get("insertList");
				for (Map<String, Object> map : insertList) {
					Map<String, Object> mapParam = new HashMap<String, Object>();
					mapParam.put("organization_no", map.get("organization_no"));
					mapParam.put("seq", map.get("seq"));

					wehagoAdapterDAO.updateWehagoOrgKey(mapParam);
				}
			}
			return (Map<String, Object>)resultMap.get("resultData");
		}
		else {
			return null;
		}
	}
	@Override
	public Map<String, Object> wehagoInsertOrgChartAll(String groupSeq, String compSeq) {
		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("groupSeq", groupSeq);
		resultMap.put("compSeq", compSeq);

		Map<String, Object> apiParam = new HashMap<String, Object>();
		List<Map<String, Object>> insertList = wehagoAdapterDAO.getWehagoGwOrgAllList(resultMap);
		if (insertList != null && insertList.size() > 0) {
			JSONArray portletListJson = JSONArray.fromObject(insertList);
			apiParam.put("insertList", portletListJson.toString());
			resultMap = wehagoInsertOrgChart(groupSeq, compSeq, apiParam);

			if (resultMap != null) {
				Map<String, Object> param = new HashMap<String, Object>();
				param.put("compSeq", compSeq);
				wehagoAdapterDAO.updateWehagoSyncYn(param);
			}
		}

		return resultMap;
	}
	@Override
	public Map<String, Object> wehagoInsertOrgChartOneSync(String groupSeq, String compSeq, String deptSeq, String syncTp) throws Exception{
		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("groupSeq", groupSeq);
		resultMap.put("compSeq", compSeq);
		resultMap.put("deptSeq", deptSeq);

		Map<String, Object> apiParam = new HashMap<String, Object>();
		List<Map<String, Object>> insertList = wehagoAdapterDAO.getWehagoGwOrgOneSyncInfo(resultMap);
		if (insertList != null && insertList.size() > 0) {
			if (syncTp.equals("I")) {
				JSONArray portletListJson = JSONArray.fromObject(insertList);
				apiParam.put("insertList", portletListJson.toString());
			}
			else if (syncTp.equals("U")) {
				JSONArray portletListJson = JSONArray.fromObject(insertList);
				apiParam.put(insertList.get(0).get("organization_no").equals("") ? "insert" : "updateList", portletListJson.toString());
			}
			else if (syncTp.equals("D")) {
				if (insertList.get(0).get("organization_no").equals("")) {
					return null;
				}

				String deleteList = "";
				for (Map<String, Object> map : insertList) {
					deleteList += (deleteList.equals("") ? "" : ",") + map.get("organization_no").toString();
				}
				apiParam.put("deleteList", deleteList);
			}

			resultMap = wehagoInsertOrgChart(groupSeq, compSeq, apiParam);

			if (syncTp.equals("I") && resultMap == null) {
				throw new Exception( "Wehago server connection failure" );
			}
		}
		return resultMap;
	}

	// 사용자 연동
	// 사용자 저장 공통함수
	@SuppressWarnings("unchecked")
	public Map<String, Object> wehagoInsertEmp(String groupSeq, String compSeq, Map<String, Object> params, String syncTp) {
		Map<String, Object> resultMap = new HashMap<String, Object>();

		if (syncTp.equals("I")) {
			resultMap = wehagoApiCall(groupSeq, compSeq, "/common/douzone/employee/list", "POST", params);
		}
		else if (syncTp.equals("M")) {
			resultMap = wehagoApiCall(groupSeq, compSeq, "/common/douzone/employee/list", "PUT", params);
		}
		else if (syncTp.equals("R")) {
			resultMap = wehagoApiCall(groupSeq, compSeq, "/common/douzone/employee/retire", "PUT", params);
		}
		else if (syncTp.equals("D")) {
			resultMap = wehagoApiCall(groupSeq, compSeq, "/common/douzone/employee/delete", "PUT", params);
		}
		else if (syncTp.equals("S")) {
			resultMap = wehagoApiCall(groupSeq, compSeq, "/common/douzone/employee/sendmail", "PUT", params);
		}

		if (resultMap != null && resultMap.get("resultCode") != null && resultMap.get("resultCode").toString().equals("200")) {
			if (syncTp.equals("I")) {
				List<Map<String, Object>> resultData = (List<Map<String, Object>>) resultMap.get("resultData");

				for (Map<String, Object> map : resultData) {
					Map<String, Object> mapParam = new HashMap<String, Object>();
					mapParam.put("wehagoKey", map.get("employee_no") + "▦" + map.get("user_no") + "▦" + compSeq);
					mapParam.put("seq", map.get("seq"));

					wehagoAdapterDAO.updateWehagoEmpKey(mapParam);
				}
			}
			return resultMap;
		}
		else if (syncTp.equals("S")) {
			return resultMap;
		}
		else {
			return null;
		}
	}
	@Override
	public Map<String, Object> wehagoInsertEmpAll(String groupSeq, String compSeq) {
		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("groupSeq", groupSeq);
		resultMap.put("compSeq", compSeq);

		Map<String, Object> apiParam = new HashMap<String, Object>();
		List<Map<String, Object>> insertList = wehagoAdapterDAO.getWehagoGwEmpAllList(resultMap);
		if (insertList != null && insertList.size() > 0) {
			JSONArray portletListJson = JSONArray.fromObject(insertList);
			apiParam.put("employee_list", portletListJson.toString());
			resultMap = wehagoInsertEmp(groupSeq, compSeq, apiParam, "I");
		}
		return resultMap;
	}
	@Override
	public Map<String, Object> wehagoInsertEmpOneSync(String groupSeq, String compSeq, String empSeq, String syncTp) throws Exception {
		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("groupSeq", groupSeq);
		resultMap.put("compSeq", compSeq);
		resultMap.put("empSeq", empSeq);
		resultMap.put("syncTp", syncTp);

		Map<String, Object> apiParam = new HashMap<String, Object>();
		List<Map<String, Object>> insertList = wehagoAdapterDAO.getWehagoGwEmpOneSyncInfo(resultMap);
		if (insertList != null && insertList.size() > 0) {
			if (syncTp.equals("I")) {
				JSONArray portletListJson = JSONArray.fromObject(insertList);
				apiParam.put("employee_list", portletListJson.toString());
			}
			else {
				String[] wehagoKeyArray = insertList.get(0).get("wehago_key").toString().split("▦");

				if (wehagoKeyArray.length > 2) {
					if (syncTp.equals("M") && wehagoKeyArray[2].equals(compSeq)) {
						Map<String, Object> userInfo = insertList.get(0);
						userInfo.put("employee_no", wehagoKeyArray[0]);
						userInfo.remove("wehago_key");
						apiParam.put("userInfo ", JSONObject.fromObject(userInfo));
					}
					else {
						if (compSeq.equals("")) {
							compSeq = wehagoKeyArray[2];
						}

						apiParam.put("employee_list", wehagoKeyArray[0]);
					}
				}
				else {
					return null;
				}
			}

			resultMap = wehagoInsertEmp(groupSeq, compSeq, apiParam, syncTp);

			if (resultMap == null) {
				throw new Exception( "Wehago server connection failure" );
			}
		}
		else {
			return null;
		}

		return resultMap;
	}



// -------------------------------------------------------------------------------------
// 검토중

	@SuppressWarnings("unchecked")
	@Override
	public Map<String, Object> wehagoGetGroupInfo(String groupSeq, String compSeq) {
		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap = wehagoApiCall(groupSeq, compSeq, "/common/douzone/company", "GET", resultMap);
		if (resultMap != null && resultMap.get("resultCode") != null && resultMap.get("resultCode").toString().equals("200")) {
			return (Map<String, Object>)resultMap.get("resultData");
		}
		else {
			return null;
		}
	}
	@SuppressWarnings("unchecked")
	@Override
	public Map<String, Object> wehagoUpdateGroupInfo(String groupSeq, String compSeq, Map<String, Object> params) {
		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap = wehagoApiCall(groupSeq, compSeq, "/common/douzone/company", "POST", params);
		if (resultMap != null && resultMap.get("resultCode") != null && resultMap.get("resultCode").equals("200")) {
			return (Map<String, Object>)resultMap.get("resultData");
		}
		else {
			return null;
		}
	}

	@Override
	public Map<String, Object> wehagoSyncDetailList(Map<String, Object> params, PaginationInfo paginationInfo) {
		return commonSql.listOfPaging2(params, paginationInfo, "wehagoManage.selectWehagoSyncList");
	}

	@Override
	public Map<String, Object> wehagoGetOrgChart(String groupSeq, String compSeq) {
		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap = wehagoApiCall(groupSeq, compSeq, "/common/douzone/organization", "GET", resultMap);
		if (resultMap != null && resultMap.get("resultCode") != null && resultMap.get("resultCode").toString().equals("200")) {
			return  resultMap;
		}
		else {
			return null;
		}
	}
	@Override
	public Map<String, Object> wehagoGetEmp(String groupSeq, String compSeq, String wehagoKey) {
		Map<String, Object> resultMap = new HashMap<String, Object>();
		String[] empKey = wehagoKey.split("▦",-1);

		if (empKey.length > 1) {
			resultMap.put("employee_no", empKey[0]);
			resultMap.put("user_no", empKey[1]);
		}

		resultMap = wehagoApiCall(groupSeq, compSeq, "/common/douzone/employee", "GET", resultMap);
		if (resultMap != null && resultMap.get("resultCode") != null && resultMap.get("resultCode").toString().equals("200")) {
			return resultMap;
		}
		else {
			return null;
		}
	}

	@Override
	public Map<String, Object> wehagoSendMail(String groupSeq, String compSeq) {
		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("groupSeq", groupSeq);
		resultMap.put("compSeq", compSeq);

		Map<String, Object> apiParam = new HashMap<String, Object>();
		List<Map<String, Object>> sendMailList = wehagoAdapterDAO.getWehagoSendMailList(resultMap);
		if (sendMailList != null && sendMailList.size() > 0) {
			JSONArray portletListJson = JSONArray.fromObject(sendMailList);
			apiParam.put("checkedMemberList", portletListJson.toString());
			resultMap = wehagoInsertEmp(groupSeq, compSeq, apiParam, "S");
		}
		return resultMap;
	}

	@Override
	public Map<String, Object> wehagoApiTest(String groupSeq, String compSeq, Map<String, Object> params) {
		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap = wehagoInsertOrgChartAll(groupSeq, compSeq);
		return resultMap;
	}
}