package api.fax.service;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;
import java.security.InvalidAlgorithmParameterException;
import java.security.InvalidKeyException;
import java.security.NoSuchAlgorithmException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import javax.annotation.Resource;
import javax.crypto.BadPaddingException;
import javax.crypto.IllegalBlockSizeException;
import javax.crypto.NoSuchPaddingException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.codec.DecoderException;
import org.apache.commons.lang3.StringUtils;
import org.codehaus.jackson.JsonGenerationException;
import org.codehaus.jackson.JsonParseException;
import org.codehaus.jackson.map.JsonMappingException;
import org.codehaus.jackson.map.ObjectMapper;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import api.common.dao.APIDAO;
import api.common.exception.APIException;
import api.common.helper.LogHelper;
import api.common.model.APIResponse;
import api.fax.model.FaxRequest;
import api.fax.model.FaxRequestHeader;
import api.fax.model.FaxResponse;
import api.fax.util.AES128Util;
import bizbox.orgchart.service.vo.LoginVO;
import main.web.BizboxAMessage;
import neos.cmm.util.BizboxAProperties;
import neos.cmm.util.CommonUtil;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;
import net.sf.json.JSONSerializer;

@Service("FaxService")
public class FaxService {
	
	Logger logger = LoggerFactory.getLogger(FaxService.class);
	
	@Resource(name = "APIDAO")
	private APIDAO apiDAO;
	
	// 마스터용
	private static final String URL_SUFFIX_AUTH = "/wsAuth.aspx";
	private static final String URL_SUFFIX_ALARM_CHANGE = "/wsFaxAlarmIPChange.aspx";
	private static final String URL_SUFFIX_FAX_NO_LIST = "/wsFaxNoList.aspx";
	private static final String URL_SUFFIX_POINT = "/wsPointInfo.aspx";
	// 사용자용
	private static final String URL_SUFFIX_FOLDER_LIST = "/wsFaxFolderInfo.aspx";
	private static final String URL_SUFFIX_SEND_LIST = "/wsSendList.aspx";
	private static final String URL_SUFFIX_RECV_LIST = "/wsRecvList.aspx";
	private static final String URL_SUFFIX_DOWNLOAD = "/wsFaxFileDownload.aspx";
	private static final String URL_SUFFIX_SEND = "/wsFaxSend.aspx";
	private static final String URL_SUFFIX_FAX_COUNT = "/wsPeriodFaxCount.aspx";
	private static final String URL_SUFFIX_FAX_MOVE = "/wsFaxFolderMove.aspx";
	private static final String URL_SUFFIX_FAX_RESEND = "/wsSendFaxReSend.aspx";
	// 팩스 이미지 다운로드 URL
	private static final String URL_SUFFIX_DOWN = "/gw/api/fax/download/%s/%s/%s/%s/%s";
	private String codeHead = "systemx.fax";
	private ObjectMapper mapper = new ObjectMapper();
	private static final String CRLF = "\r\n";
	private static final String CHARSET = "UTF-8";
	Map<String, String> code = new HashMap<String, String>();
	
	/**
	 * 웹 API 요청 처리
	 * @param servletRequest
	 * @param request
	 * @param auth MASTER, ADMIN, USER
	 * @param serviceName
	 * @return
	 */
	public APIResponse action(HttpServletRequest servletRequest, Map<String, Object> request, String auth, String serviceName) {
		//System.out.println("여기는 여기는 여기는");
		long time = System.currentTimeMillis();
		
		APIResponse response = null;
		String serviceErrorCode = "FX101";
		
		/* 세션 체크 */
		if(servletRequest.getSession() == null || servletRequest.getSession().getAttribute("loginVO") == null){
			APIException ae = new APIException("FX000");
			response = LogHelper.createError(servletRequest, codeHead, ae);
			time = System.currentTimeMillis() - time;
			logger.error(serviceName + "-error ET[" + time + "] " + LogHelper.getResponseString(request, response), ae);
			return response;
		}
		
		/* 세션에서 필요값 꺼내오기 */
		LoginVO loginVO = (LoginVO) servletRequest.getSession().getAttribute("loginVO");
		request.put("groupSeq", loginVO.getGroupSeq());
		if(!loginVO.getUserSe().equals(auth)){
			APIException ae = new APIException("FX001");
			response = LogHelper.createError(servletRequest, codeHead, ae);
			time = System.currentTimeMillis() - time;
			logger.error(serviceName + "-error ET[" + time + "] " + LogHelper.getResponseString(request, response), ae);
			return response;
		}
		
		/* 인터페이스 별 로직 수행 */
		try {
			logger.info(serviceName + "-start " + LogHelper.getRequestString(request));
			Object result = null;
			
			if(loginVO.getUserSe().equals("MASTER")){
				// 세션에서 필요 정보 꺼내오기
				request.put("groupSeq", loginVO.getGroupSeq());
				request.put("langCode", loginVO.getLangCode());
				
				if("FaxList".equals(serviceName)){
					result = faxList(request);
				}else if("FaxNoList".equals(serviceName)){
					result = faxNoListMaster(request);
				}else if("FaxAdd".equals(serviceName)){
					faxAdd(request);
				}else if("FaxDel".equals(serviceName)){
					faxDel(request);
				}else if("Refresh".equals(serviceName)){
					refresh(request);
				}else if("FaxNoCompList".equals(serviceName)){
					result = faxNoCompList(request);
				}else if("FaxNoCompAdd".equals(serviceName)){
					faxNoCompAdd(request);
				}else if("AlarmChange".equals(serviceName)){
					alarmChange(request);
				}else if("saveFaxNickNameOption".equals(serviceName)){
					saveFaxNickNameOption(request);	//웹팩스 별칭 옵션 저장
				}else if("saveFaxNickName".equals(serviceName)){
					saveFaxNickName(request);	//웹팩스 별칭  저장
				}
				
				
			}else if(loginVO.getUserSe().equals("ADMIN")){
				// 세션에서 필요 정보 꺼내오기
				request.put("groupSeq", loginVO.getGroupSeq());
				request.put("compSeq", loginVO.getOrganId());
				request.put("langCode", loginVO.getLangCode());
				
				if("FaxNoList".equals(serviceName)){
					result = faxNoListAdmin(request);
				}else if("FaxSyncList".equals(serviceName)){
					result = faxSyncList(request);
				}else if("FaxSyncAdd".equals(serviceName)){
					faxSyncAdd(request);
				}else if("FaxSyncDel".equals(serviceName)){
					faxSyncDel(request);
				}
			}else if(loginVO.getUserSe().equals("USER")){
				// 세션에서 필요 정보 꺼내오기
				request.put("groupSeq", loginVO.getGroupSeq());
				request.put("compSeq", loginVO.getOrganId());
				request.put("deptSeq", loginVO.getOrgnztId());
				request.put("empSeq", loginVO.getUniqId());
				request.put("langCode", loginVO.getLangCode());
				
				if("FaxNoList".equals(serviceName)){
					result = faxNoListUser(request);
				}
			}
			
			response = LogHelper.createSuccess(result);
			time = System.currentTimeMillis() - time;
			logger.info(serviceName + "-end ET[" + time + "] "+ LogHelper.getResponseString(request, response));
		} catch (APIException ae) {
			response = LogHelper.createError(servletRequest, codeHead, ae);
			time = System.currentTimeMillis() - time;
			logger.error(serviceName + "-error ET[" + time + "] " + LogHelper.getResponseString(request, response), ae);
		} catch (Exception e) {
			response = LogHelper.createError(servletRequest, codeHead, serviceErrorCode);
			time = System.currentTimeMillis() - time;
			logger.error(serviceName + "-error ET[" + time + "] " + LogHelper.getResponseString(request, response), e);
		}
		
		return response;
	}

	/**
	 * 팩스 목록 조회
	 * @param request
	 * @return
	 */
	private Map<String, Object> faxList(Map<String, Object> request) {
//		System.out.println(request);
		Map<String, Object> result = new HashMap<String, Object>();
		result.put("faxList", apiDAO.list("faxDAO.getFaxListMaster", request));
		return result;
	}
	
	/**
	 * 팩스 번호 목록 조회
	 * @param request
	 * @return
	 */
	private Map<String, Object> faxNoListMaster(Map<String, Object> request) {
		Map<String, Object> result = new HashMap<String, Object>();
		result.put("faxNoList", apiDAO.list("faxDAO.getFaxNoListMaster", request));
		return result;
	}
	
	/**
	 * 팩스 등록
	 * @param request
	 * @return
	 * @throws DecoderException 
	 * @throws IOException 
	 * @throws BadPaddingException 
	 * @throws IllegalBlockSizeException 
	 * @throws InvalidAlgorithmParameterException 
	 * @throws NoSuchPaddingException 
	 * @throws NoSuchAlgorithmException 
	 * @throws InvalidKeyException 
	 * @throws JsonMappingException 
	 * @throws JsonGenerationException 
	 */
	private void faxAdd(Map<String, Object> request) throws JsonGenerationException, JsonMappingException, InvalidKeyException, NoSuchAlgorithmException, NoSuchPaddingException, InvalidAlgorithmParameterException, IllegalBlockSizeException, BadPaddingException, IOException, DecoderException {
		
//		boolean isNew = request.get("faxSeq") == null || request.get("faxSeq").equals("") ? true : false;
		boolean isNew;
		if( request.get("faxSeq") == null || request.get("faxSeq").equals("") ) {
			isNew = true;
		}
		else {
			isNew = false;
		}
		
		String duplicateYn = (String) apiDAO.select("faxDAO.getDuplicateYnMaster", request);
		
		if(isNew && duplicateYn.equals("Y")) {
			throw new APIException("FX002");
		}
		
		// 팩스 계정 유효성 검사
		Map<String, Object> body = new HashMap<String, Object>();
		body.put("Bill36524ID", request.get("bill36524Id"));
		body.put("Bill36524PW", request.get("bill36524Pwd"));
		body.put("FaxAlarmIP", BizboxAProperties.getProperty("BizboxA.fax.callback"));
		
		if((request.get("smsCompParams") != null) && (!request.get("smsCompParams").toString().equals("{}"))) {
			setSmsComp(request);
		}
		
		FaxResponse res = getFaxAPIResult(body, URL_SUFFIX_AUTH);
		if(res.getResultCode().equals("2")) {
			throw new APIException("FX100");
		}
		else if(res.getResultCode().equals("-1")) {
			throw new APIException("FX101");
		}
		else if(res.getResultCode().equals("99")) {
			throw new APIException("FX102");
		}
		
		request.put("agentId", res.getResult().get("AgentID"));
		request.put("agentKey", res.getResult().get("AgentKey"));
		
		//수정이면 기존 팩스 번호 삭제 후 재등록함
//		if(isNew){
//			apiDAO.delete("faxDAO.delFaxNoMaster", request);
//		}
		
		// 포인트 조회
		body.putAll(res.getResult());
		res = getFaxAPIResult(body, URL_SUFFIX_POINT);
		if(res.getResultCode().equals("0")) {
			request.put("point", res.getResult().get("Bill36524Point"));
		}
		else {
			request.put("point", "");
		}
		
		if(isNew){
			request.put("faxSeq", UUID.randomUUID().toString().toUpperCase());
			apiDAO.insert("faxDAO.addFaxMaster", request);
		}else{
			apiDAO.update("faxDAO.editFaxMaster", request);
		}
		
		// 팩스 번호 등록
		res = getFaxAPIResult(body, URL_SUFFIX_FAX_NO_LIST);
		if(!res.getResultCode().equals("0")) {
			return;
		}
		if(isNew) {
			for(Map<String, String> fax : (List<Map<String, String>>)res.getResult().get("FaxNoList")){
				fax.put("faxSeq", (String) request.get("faxSeq"));
				apiDAO.insert("faxDAO.addFaxNoMaster", fax);
			}
		}
		
	}
	
	/**
	 * 팩스 삭제
	 * @param request
	 */
	private void faxDel(Map<String, Object> request) {
		int result = apiDAO.delete("faxDAO.delFaxMaster", request);
		if(result < 1) {
			throw new APIException("FX101");
		}
	}
	
	/**
	 * 갱신
	 * @param request
	 * @throws DecoderException 
	 * @throws IOException 
	 * @throws BadPaddingException 
	 * @throws IllegalBlockSizeException 
	 * @throws InvalidAlgorithmParameterException 
	 * @throws NoSuchPaddingException 
	 * @throws NoSuchAlgorithmException 
	 * @throws InvalidKeyException 
	 * @throws JsonMappingException 
	 * @throws JsonGenerationException 
	 */
	private void refresh(Map<String, Object> request) throws JsonGenerationException, JsonMappingException, InvalidKeyException, NoSuchAlgorithmException, NoSuchPaddingException, InvalidAlgorithmParameterException, IllegalBlockSizeException, BadPaddingException, IOException, DecoderException {
		Map<String, Object> body = (Map<String, Object>) apiDAO.select("faxDAO.getAgentIdAndAgentKeyMaster", request);
		if(body.get("AgentID") == null || body.get("AgentID").equals("")) {
			return;
		}
		
		// 포인트 갱신
		FaxResponse res = getFaxAPIResult(body, URL_SUFFIX_POINT);
		if(res.getResultCode().equals("0")) {
			request.put("point", res.getResult().get("Bill36524Point"));
		}
		else {
			request.put("point", "");
		}
		request.put("refresh", "Y");
		apiDAO.update("faxDAO.editFaxMaster", request);
		
		// 팩스 번호 (추가 / 기간 수정)
		res = getFaxAPIResult(body, URL_SUFFIX_FAX_NO_LIST);
		if(!res.getResultCode().equals("0")) {
			return;
		}
		for(Map<String, String> fax : (List<Map<String, String>>)res.getResult().get("FaxNoList")){
			fax.put("faxSeq", (String) request.get("faxSeq"));
			int result = apiDAO.update("faxDAO.editFaxNoMaster", fax);
			if(result < 1) {
				apiDAO.insert("faxDAO.addFaxNoMaster", fax);
			}
		}
		
	}
	
	/**
	 * 팩스 번호별 회사 설정 목록
	 * @param request
	 * @return
	 */
	private Map<String, Object> faxNoCompList(Map<String, Object> request) {
		Map<String, Object> result = new HashMap<String, Object>();
		result.put("compList", apiDAO.list("faxDAO.getFaxNoCompListMaster", request));
		
		return result;
	}
	
	/**
	 * 팩스 번호별 회사 설정
	 * @param request
	 * @return
	 */
	private void faxNoCompAdd(Map<String, Object> request) {
		// 삭제 후 재등록
		apiDAO.delete("faxDAO.delFaxNoCompMaster", request);
		List<Map<String, Object>> compList = (List<Map<String, Object>>) request.get("compList");
		for(Map<String, Object> comp : compList){
			request.put("compSeq", comp.get("compSeq"));
			apiDAO.insert("faxDAO.addFaxNoCompMaster", request);
		}
	}
	
	/**
	 * 알람 URL 갱신
	 * @param request
	 * @throws DecoderException 
	 * @throws IOException 
	 * @throws BadPaddingException 
	 * @throws IllegalBlockSizeException 
	 * @throws InvalidAlgorithmParameterException 
	 * @throws NoSuchPaddingException 
	 * @throws NoSuchAlgorithmException 
	 * @throws InvalidKeyException 
	 * @throws JsonMappingException 
	 * @throws JsonGenerationException 
	 */
	private void alarmChange(Map<String, Object> request) throws JsonGenerationException, JsonMappingException, InvalidKeyException, NoSuchAlgorithmException, NoSuchPaddingException, InvalidAlgorithmParameterException, IllegalBlockSizeException, BadPaddingException, IOException, DecoderException {
		request.put("FaxAlarmIP", request.remove("alarmIP"));
		
		FaxResponse res = getFaxAPIResult(request, URL_SUFFIX_ALARM_CHANGE);
		
		if(!res.getResultCode().equals("0")) {
			throw new APIException("FX101");
		}
	}
	
	/**
	 * 팩스 번호 목록 (관리자)
	 * @param request
	 * @return
	 */
	private Map<String, Object> faxNoListAdmin(Map<String, Object> request) {
		Map<String, Object> result = new HashMap<String, Object>();
		result.put("faxNoList", apiDAO.list("faxDAO.getFaxNoListAdmin", request));
		
		return result;
	}
	
	/**
	 * 팩스 번호 연동 목록
	 * @param request
	 * @return
	 */
	private Map<String, Object> faxSyncList(Map<String, Object> request) {
		Map<String, Object> result = new HashMap<String, Object>();
		Map<String, Object> param = new HashMap<String, Object>();
		Map<String, Object> changeData = new HashMap<String,Object>();

		//result.put("faxSyncList", apiDAO.list("faxDAO.getFaxSyncList", request));

		List<Map<String, Object>>list =apiDAO.list("faxDAO.getFaxSyncList", request);
		
		List<Map<String, Object>> deptlist = new ArrayList<Map<String,Object>>();
		List<Map<String, Object>> userlist = new ArrayList<Map<String,Object>>();

		
		for(Map<String, Object> item : list) {
			param.put("orgSeq", item.get("orgSeq"));
			param.put("compSeq", item.get("compSeq"));
			param.put("groupSeq", item.get("groupSeq"));
			param.put("orgType", item.get("orgType"));

			if(item.get("orgType").equals("D")) {

				deptlist.add((Map<String, Object>)apiDAO.select("faxDAO.getDeptName", param));
			} else {
				userlist.add((Map<String, Object>)apiDAO.select("faxDAO.getUserName", param));
			
			}

			
			changeData.put("changeDeptName",deptlist);
			changeData.put("changeUserName", userlist);
		}
		
		
		result.put("changeResult", changeData);

		return result;
	}
	
	/**
	 * 팩스 연결 등록 
	 * @param request
	 */
	private void faxSyncAdd(Map<String, Object> request) {
		for(Map<String, String> faxSync : (List<Map<String, String>>)request.get("faxSyncList")){
			faxSync.put("faxSeq", (String) request.get("faxSeq"));
			faxSync.put("faxNo", (String) request.get("faxNo"));
			
			apiDAO.insert("faxDAO.addFaxSync", faxSync);
		}
	}
	
	/**
	 * 팩스 연결 삭제
	 * @param reqeust
	 */
	private void faxSyncDel(Map<String, Object> request) {
		for(Map<String, String> faxSync : (List<Map<String, String>>)request.get("faxSyncList")){
			faxSync.put("faxSeq", (String) request.get("faxSeq"));
			faxSync.put("faxNo", (String) request.get("faxNo"));
			
			apiDAO.delete("faxDAO.delFaxSync", faxSync);
		}
	}

	/**
	 * 팩스 번호 목록 (사용자)
	 * @param request
	 */
	private Map<String, Object> faxNoListUser(Map<String, Object> request) {
		// 사용자의 부서 패스 구하기
		String depts = "";
		List<String> pathList = apiDAO.list("faxDAO.getDeptPath", request);
		for(String path : pathList){
			depts += "," + path;
		}
		if(depts.length() > 0) {
			depts = depts.substring(1);
		}
		request.put("depts", depts);
		
		Map<String, Object> result = new HashMap<String, Object>();
		result.put("faxNoList", apiDAO.list("faxDAO.getFaxNoListUser", request));
		
		return result;
	}
	
	/**
	 * 모바일 API 용
	 * @param servletRequest
	 * @param request
	 * @param serviceName
	 * @return
	 */
	public APIResponse action4m(HttpServletRequest servletRequest, Map<String, Object> request, String serviceName) {
		
		long time = System.currentTimeMillis();
		
		APIResponse response = null;
		String serviceErrorCode = "FX101";
		
		/* 인터페이스 별 로직 수행 */
		try {
			logger.info(serviceName + "-start " + LogHelper.getRequestString(request));
			Object result = null;
			
			if("FaxNoList".equals(serviceName)){
				result = faxNoListMobile(request);
			} else if("FaxFolderList".equals(serviceName)){
				result = faxFolderList(request);
			} else if("FaxSendList".equals(serviceName)){
				result = faxSendList(servletRequest, request);
			} else if("FaxRecvList".equals(serviceName)){
				result = faxRecvList(servletRequest, request);
			} else if("FaxReSend".equals(serviceName)){
				faxReSend(request);
			} else if("FaxCount".equals(serviceName)){
				result = faxCount(request);
			} else if("FaxMove".equals(serviceName)){
				faxMove(request);
			} else {
				throw new APIException("FX000");
			}
			
			response = LogHelper.createSuccess(result);
			time = System.currentTimeMillis() - time;
			logger.info(serviceName + "-end ET[" + time + "] "+ LogHelper.getResponseString(request, response));
		} catch (APIException ae) {
			response = LogHelper.createError(servletRequest, codeHead, ae);
			time = System.currentTimeMillis() - time;
			logger.error(serviceName + "-error ET[" + time + "] " + LogHelper.getResponseString(request, response), ae);
		} catch (Exception e) {
			response = LogHelper.createError(servletRequest, codeHead, serviceErrorCode);
			time = System.currentTimeMillis() - time;
			logger.error(serviceName + "-error ET[" + time + "] " + LogHelper.getResponseString(request, response), e);
		}
		
		return response;
	}
	
	/**
	 * 팩스 번호 목록
	 * @param request
	 * @return
	 */
	private Map<String, Object> faxNoListMobile(Map<String, Object> request) {
		Map<String, Object> header = (Map<String, Object>) request.get("header");
		Map<String, Object> body = (Map<String, Object>) request.get("body");
		header.putAll((Map<String, Object>) body.remove("companyInfo"));
		
		// 사용자의 부서 패스 구하기
		String depts = "";
		List<String> pathList = apiDAO.list("faxDAO.getDeptPath", header);
		for(String path : pathList){
			depts += "," + path;
		}
		if(depts.length() > 0) {
			depts = depts.substring(1);
		}
		header.put("depts", depts.split(","));
		
		// 소속 회사 목록 조회
		List<String> compList = apiDAO.list("faxDAO.getUserCompList", header);
		// 회사별 번호 목록 조회
		List<Map<String, Object>> faxNoList = new ArrayList<Map<String, Object>>();
		for(String comp : compList) {
			header.put("compSeq", comp);
			List list = apiDAO.list("faxDAO.getFaxNoListForMobile", header);
			if(list != null && list.size() > 0) {
				Map<String, Object> faxNo = new HashMap<String, Object>();
				faxNo.put("compSeq", comp);
				faxNo.put("noList", list);

				faxNoList.add(faxNo);
			}
		}
		
		Map<String, Object> result = new HashMap<String, Object>();
		result.put("faxNoList", faxNoList);
		
		return result; 
	}
	
	/**
	 * 팩스 폴더 목록
	 * @param request
	 * @return
	 * @throws DecoderException 
	 * @throws IOException 
	 * @throws BadPaddingException 
	 * @throws IllegalBlockSizeException 
	 * @throws InvalidAlgorithmParameterException 
	 * @throws NoSuchPaddingException 
	 * @throws NoSuchAlgorithmException 
	 * @throws InvalidKeyException 
	 * @throws JsonMappingException 
	 * @throws JsonGenerationException 
	 */
	private Map<String, Object> faxFolderList(Map<String, Object> request) throws JsonGenerationException, JsonMappingException, InvalidKeyException, NoSuchAlgorithmException, NoSuchPaddingException, InvalidAlgorithmParameterException, IllegalBlockSizeException, BadPaddingException, IOException, DecoderException{
		Map<String, Object> body = (Map<String, Object>) request.get("body");
		
		FaxResponse res = getFaxAPIResult(body, URL_SUFFIX_FOLDER_LIST);
		if(!res.getResultCode().equals("0")) {
			throw new APIException("FX101");
		}
		
		return res.getResult();
	}
	
	/**
	 * 팩스 전송 목록 조회
	 * @param request
	 * @return
	 * @throws JsonGenerationException
	 * @throws JsonMappingException
	 * @throws InvalidKeyException
	 * @throws NoSuchAlgorithmException
	 * @throws NoSuchPaddingException
	 * @throws InvalidAlgorithmParameterException
	 * @throws IllegalBlockSizeException
	 * @throws BadPaddingException
	 * @throws IOException
	 * @throws DecoderException
	 */
	private Map<String, Object> faxSendList(HttpServletRequest servletReq, Map<String, Object> request) throws JsonGenerationException,
			JsonMappingException, InvalidKeyException, NoSuchAlgorithmException, NoSuchPaddingException,
			InvalidAlgorithmParameterException, IllegalBlockSizeException, BadPaddingException, IOException, DecoderException {
		
		/* static 에서 제외(다국어 적용) */
		code = new HashMap<String, String>();
		code.put("0", BizboxAMessage.getMessage("TX000011970","송신완료"));
		code.put("97", BizboxAMessage.getMessage("TX000011969","표지생성"));
		code.put("98", BizboxAMessage.getMessage("TX000011968","승인대기"));
		code.put("99", BizboxAMessage.getMessage("TX000011967","송신중"));
		code.put("100", BizboxAMessage.getMessage("TX000011966","송신대기"));
		code.put("101", BizboxAMessage.getMessage("TX000011965","변환대기"));
		code.put("102", BizboxAMessage.getMessage("TX000011964","변환중"));
		code.put("200", BizboxAMessage.getMessage("TX000011963","송신취소"));
		code.put("300", BizboxAMessage.getMessage("TX000011962","잔액부족"));
		code.put("2001", BizboxAMessage.getMessage("TX000011961","결변"));
		code.put("2016", BizboxAMessage.getMessage("TX000011960","일반번호"));
		code.put("2017", BizboxAMessage.getMessage("TX000011959","통화중"));
		code.put("2104", BizboxAMessage.getMessage("TX000011959","통화중"));
		code.put("2019", BizboxAMessage.getMessage("TX000011958","송신끊김"));
		code.put("2027", BizboxAMessage.getMessage("TX000011957","팩스아님"));
		code.put("2109", BizboxAMessage.getMessage("TX000011956","연결안됨"));
		
		Map<String, Object> body = (Map<String, Object>) request.get("body");
		Map<String, Object> header = (Map<String, Object>) request.get("header");
		request.put("groupSeq", header.get("groupSeq"));
		
		body.put("FaxKey", "");
		body.put("SearchType", "0");
		if(StringUtils.isNotEmpty((String) body.get("SearchText"))){
			body.put("SearchType", "1");
		}
		
		String agentId = (String) body.get("AgentID");
		String agentKey = (String) body.get("AgentKey");
		
		String listCount = (String) body.get("ListCount");
		body.put("ListCount", String.valueOf(Integer.parseInt(listCount) + 1));
		
		List<String> faxNo = new ArrayList<String>();
		faxNo.add((String) body.remove("FaxNo"));
		body.put("FaxNo", faxNo);
		
		FaxResponse res = getFaxAPIResult(body, URL_SUFFIX_SEND_LIST);
		
		if(res.getResultCode().equals("99")) {
			throw new APIException("FX102");
		}
		if(!res.getResultCode().equals("0")) {
			throw new APIException("FX101", res.getResultMessage());
		}
		
		String moreYn = "N";
		List<Map<String, Object>> faxList = (List<Map<String, Object>>) res.getResult().get("FaxList");
		if(faxList.size() > Integer.parseInt(listCount)){
			faxList.remove(Integer.parseInt(listCount));
			moreYn = "Y";
		}
		res.getResult().put("moreYn", moreYn);
		
		//모바일 전용포트 사용업체
		String mobileDomain = "";
		
		@SuppressWarnings("unchecked")
		Map<String, Object> groupMap = (Map<String, Object>) apiDAO.select("faxDAO.getGroupInfo", request);
		
		if(groupMap != null && !groupMap.get("mobileGatewayUrl").equals("")){
			mobileDomain = groupMap.get("mobileGatewayUrl") + "";
		}else{
			mobileDomain = servletReq.getScheme() + "://" + servletReq.getServerName() + ":" + servletReq.getServerPort();
		}
		
		for(Map<String, Object> fax : faxList){
			fax.put("FaxStatusName", code.get(fax.get("FaxStatus")));
			List<String> fileList = new ArrayList<String>();
			for(int i = 0; i < Integer.parseInt((String) fax.get("FaxPages")); i++){
				fileList.add(mobileDomain + String.format(URL_SUFFIX_DOWN, agentId, agentKey, "2", fax.get("FaxKey"), i + 1));
			}
			fax.put("FileList", fileList);
		}
		
		return res.getResult();
	}
	
	/**
	 * 팩스 수신 목록 조회
	 * @param request
	 * @return
	 * @throws JsonGenerationException
	 * @throws JsonMappingException
	 * @throws InvalidKeyException
	 * @throws NoSuchAlgorithmException
	 * @throws NoSuchPaddingException
	 * @throws InvalidAlgorithmParameterException
	 * @throws IllegalBlockSizeException
	 * @throws BadPaddingException
	 * @throws IOException
	 * @throws DecoderException
	 */
	private Map<String, Object> faxRecvList(HttpServletRequest servletReq, Map<String, Object> request) throws JsonGenerationException,
			JsonMappingException, InvalidKeyException, NoSuchAlgorithmException, NoSuchPaddingException,
			InvalidAlgorithmParameterException, IllegalBlockSizeException, BadPaddingException, IOException, DecoderException {
		
		Map<String, Object> body = (Map<String, Object>) request.get("body");
		Map<String, Object> header = (Map<String, Object>) request.get("header");
		request.put("groupSeq", header.get("groupSeq"));
		
		body.put("FaxKey", "");
		body.put("SearchType", "0");
		if(StringUtils.isNotEmpty((String) body.get("SearchText"))){
			body.put("SearchType", "1");
		}
		
		String agentId = (String) body.get("AgentID");
		String agentKey = (String) body.get("AgentKey");
		
		String listCount = (String) body.get("ListCount");
		body.put("ListCount", String.valueOf(Integer.parseInt(listCount) + 1));
		
		List<String> faxNo = new ArrayList<String>();
		faxNo.add((String) body.remove("FaxNo"));
		body.put("FaxNo", faxNo);
		
		FaxResponse res = getFaxAPIResult(body, URL_SUFFIX_RECV_LIST);
		
		if(!res.getResultCode().equals("0")) {
			throw new APIException("FX101", res.getResultMessage());
		}
		
		String moreYn = "N";
		List<Map<String, Object>> faxList = (List<Map<String, Object>>) res.getResult().get("FaxList");
		if(faxList.size() > Integer.parseInt(listCount)){
			faxList.remove(Integer.parseInt(listCount));
			moreYn = "Y";
		}
		res.getResult().put("moreYn", moreYn);
		
		//모바일 전용포트 사용업체
		String mobileDomain = "";
		
		@SuppressWarnings("unchecked")
		Map<String, Object> groupMap = (Map<String, Object>) apiDAO.select("faxDAO.getGroupInfo", request);
		
		if(groupMap != null && !groupMap.get("mobileGatewayUrl").equals("")){
			mobileDomain = groupMap.get("mobileGatewayUrl") + "";
		}else{
			mobileDomain = servletReq.getScheme() + "://" + servletReq.getServerName() + ":" + servletReq.getServerPort();
		}
		
		for(Map<String, Object> fax : faxList){
			if(fax.get("FaxFolderName") == null){
				fax.put("FaxFolderName", "");
			}
			List<String> fileList = new ArrayList<String>();
			for(int i = 0; i < Integer.parseInt((String) fax.get("FaxPages")); i++){
				fileList.add(mobileDomain + String.format(URL_SUFFIX_DOWN, agentId, agentKey, "1", fax.get("FaxKey"), i + 1));
			}
			fax.put("FileList", fileList);
		}
		
		return res.getResult();
	}
	
	/**
	 * 팩스 다시보내기
	 * @param request
	 * @throws DecoderException 
	 * @throws IOException 
	 * @throws BadPaddingException 
	 * @throws IllegalBlockSizeException 
	 * @throws InvalidAlgorithmParameterException 
	 * @throws NoSuchPaddingException 
	 * @throws NoSuchAlgorithmException 
	 * @throws InvalidKeyException 
	 * @throws JsonMappingException 
	 * @throws JsonGenerationException 
	 */
	private void faxReSend(Map<String, Object> request) throws JsonGenerationException, JsonMappingException, InvalidKeyException, NoSuchAlgorithmException, NoSuchPaddingException, InvalidAlgorithmParameterException, IllegalBlockSizeException, BadPaddingException, IOException, DecoderException {
		Map<String, Object> body = (Map<String, Object>) request.get("body");
		
		FaxResponse res = getFaxAPIResult(body, URL_SUFFIX_FAX_RESEND);
		
		if(!res.getResultCode().equals("0")) {
			throw new APIException("FX101", res.getResultMessage());
		}
	}
	
	/**
	 * 팩스 카운트 조회
	 * @param request
	 * @return
	 * @throws DecoderException 
	 * @throws IOException 
	 * @throws BadPaddingException 
	 * @throws IllegalBlockSizeException 
	 * @throws InvalidAlgorithmParameterException 
	 * @throws NoSuchPaddingException 
	 * @throws NoSuchAlgorithmException 
	 * @throws InvalidKeyException 
	 * @throws JsonMappingException 
	 * @throws JsonGenerationException 
	 */
	private Map<String, Object> faxCount(Map<String, Object> request)
			throws JsonGenerationException, JsonMappingException, InvalidKeyException, NoSuchAlgorithmException,
			NoSuchPaddingException, InvalidAlgorithmParameterException, IllegalBlockSizeException, BadPaddingException,
			IOException, DecoderException {
		List<Map<String, Object>> faxNoList = 
				(List<Map<String, Object>>) ((Map<String, Object>) request.get("body")).get("faxNoList");
		
		for(Map<String, Object> faxNo : faxNoList){
			List<String> faxNoArr = new ArrayList<String>();
			faxNoArr.add((String) faxNo.remove("FaxNo"));
			faxNo.put("FaxNo", faxNoArr);
			
			FaxResponse res = getFaxAPIResult(faxNo, URL_SUFFIX_FAX_COUNT);
			
			if(!res.getResultCode().equals("0")) {
				throw new APIException("FX101", res.getResultMessage());
			}
			
			faxNo.remove("RSDate");
			faxNo.put("count", res.getResult().get("FaxCount"));
			faxNo.put("FaxNo", faxNoArr.get(0));
		}
		
		Map<String, Object> result = new HashMap<String, Object>();
		result.put("faxCountList", faxNoList);
		return result;
	}
	/**
	 * 팩스 이동
	 * @param request
	 * @throws DecoderException 
	 * @throws IOException 
	 * @throws BadPaddingException 
	 * @throws IllegalBlockSizeException 
	 * @throws InvalidAlgorithmParameterException 
	 * @throws NoSuchPaddingException 
	 * @throws NoSuchAlgorithmException 
	 * @throws InvalidKeyException 
	 * @throws JsonMappingException 
	 * @throws JsonGenerationException 
	 */
	private void faxMove(Map<String, Object> request) throws JsonGenerationException, JsonMappingException, InvalidKeyException, NoSuchAlgorithmException, NoSuchPaddingException, InvalidAlgorithmParameterException, IllegalBlockSizeException, BadPaddingException, IOException, DecoderException{
		Map<String, Object> body = (Map<String, Object>) request.get("body");
		
		FaxResponse res = getFaxAPIResult(body, URL_SUFFIX_FAX_MOVE);
		
		if(!res.getResultCode().equals("0")) {
			throw new APIException("FX101");
		}
	}
	
	/**
	 * 키컴 API 호출
	 * @param body
	 * @param suffixUrl
	 * @return
	 * @throws JsonGenerationException
	 * @throws JsonMappingException
	 * @throws IOException
	 * @throws InvalidKeyException
	 * @throws NoSuchAlgorithmException
	 * @throws NoSuchPaddingException
	 * @throws InvalidAlgorithmParameterException
	 * @throws IllegalBlockSizeException
	 * @throws BadPaddingException
	 * @throws DecoderException 
	 */
	private FaxResponse getFaxAPIResult(Map<String, Object> body, String suffixUrl) throws JsonGenerationException,
			JsonMappingException, IOException, InvalidKeyException, NoSuchAlgorithmException, NoSuchPaddingException,
			InvalidAlgorithmParameterException, IllegalBlockSizeException, BadPaddingException, DecoderException {
				
		FaxRequest request = new FaxRequest();
		request.setHeader(new FaxRequestHeader());
		request.setBody(body);
		
		String requestJson = mapper.writeValueAsString(request);
		requestJson = AES128Util.AES_Encode(requestJson);
		logger.info("Fax API Request = " + requestJson);
	
		FaxResponse response = null;
		String responseJson = getHttpResponse(BizboxAProperties.getProperty("BizboxA.fax.server") + suffixUrl, requestJson);
		if(responseJson.charAt(0) == '{'){
			response = mapper.readValue(responseJson, FaxResponse.class);
		} else {
			responseJson = AES128Util.AES_Decode(responseJson);
			response = mapper.readValue(responseJson, FaxResponse.class);
		}
		logger.info("Fax API Response = " + responseJson);
		return response;
	}
	
	private String getHttpResponse(String urlStr, String json) throws IOException{
		URL url = new URL(urlStr);
		HttpURLConnection conn = (HttpURLConnection) url.openConnection();
		
		conn.setConnectTimeout(5000);
		conn.setReadTimeout(60000);
		conn.setDoInput(true);
		conn.setDoOutput(true);
		conn.setUseCaches(false);
		conn.setRequestMethod("POST");
		
		byte[] data = json.getBytes(CHARSET);
		conn.setRequestProperty("Content-Length", String.valueOf(data.length));
		conn.setRequestProperty("Content-Type", "application/json; charset=utf-8");
		
		conn.connect();
		
		OutputStream out = null;
		try {
			out = conn.getOutputStream();
			out.write(data);
			out.flush();
		} finally {
			if (out != null) {
				try { 
					out.close(); 
				} catch (Exception ignore) { 
					CommonUtil.printStatckTrace(ignore);//오류메시지를 통한 정보노출
				}
			}
		}
		
		InputStream in  = null;
		String res = "";
		try {
			in = conn.getInputStream();
			ByteArrayOutputStream stream = new ByteArrayOutputStream();

			byte[] buffer = new byte[4096];
            int len = 0;
            
            while ((len = in.read(buffer)) != -1) {
                stream.write(buffer, 0, len);
            }
            
            res = new String(stream.toByteArray(), CHARSET);
		} finally {
			if (in != null) { try { in.close(); } catch (Exception ignore) { 
				CommonUtil.printStatckTrace(ignore);//오류메시지를 통한 정보노출
				} 
			}
			if (conn != null) { conn.disconnect(); }
		}
		
		return res;
	}
	
	/**
	 * 팩스 전송
	 * @param servletReq
	 * @param request
	 * @return
	 */
	public APIResponse faxSend(MultipartHttpServletRequest servletRequest) {
		long time = System.currentTimeMillis();
		APIResponse response = null;
		HttpURLConnection conn = null;
		
		try{
			MultipartFile file = servletRequest.getFile(servletRequest.getFileNames().next());
			String faxDataJson = (String) servletRequest.getParameter("faxData");
			
			logger.info("faxSend-start " + faxDataJson);
			Map<String, Object> faxData = mapper.readValue(faxDataJson, Map.class);
			
			Map<String, Object> faxBody = new HashMap<String, Object>();
			faxBody.put("AgentID", ((Map<String, Object>)faxData.get("body")).get("AgentID"));
			faxBody.put("AgentKey", ((Map<String, Object>)faxData.get("body")).get("AgentKey"));
			faxBody.putAll((Map<String, Object>) ((Map<String, Object>)faxData.get("body")).get("faxSendData"));
			
			// 팩스 커버 처리
			createFaxCover(((List<Map<String, String>>)faxBody.get("FaxCoverInfo")).get(0));
			
			FaxRequest request = new FaxRequest();
			request.setHeader(new FaxRequestHeader());
			request.setBody(faxBody);
			String sendFaxInfo = mapper.writeValueAsString(request);
			sendFaxInfo = AES128Util.AES_Encode(sendFaxInfo);
			// 키컴에서 보내준 JSON_TEST 에 URL Encoding 하고 있어서 추가. 왜 하는지는 모르겠음
			sendFaxInfo = URLEncoder.encode(sendFaxInfo,"UTF-8");
			
			String boundary = "----" + UUID.randomUUID().toString();
			String header = "--" + boundary;
			String footer = header + "--";
			
			StringBuilder content = new StringBuilder();
			// 팩스 전송 데이터
			content.append(header + CRLF);
			content.append("Content-Disposition: form-data; name=\"SendFaxInfo\"" + CRLF);
			content.append(CRLF);
			content.append(sendFaxInfo + CRLF);
			// 팩스 이미지 파일
			content.append(header + CRLF);
			content.append("Content-Disposition: form-data; name=\"file1\"; filename=\"" + file.getOriginalFilename() + "\"" + CRLF);
			content.append("Content-Type: " + file.getContentType() + CRLF); 
			content.append(CRLF);
			
			byte[] body = content.toString().getBytes(CHARSET);
			byte[] foot = (CRLF + footer + CRLF).getBytes(CHARSET);
			
			URL url = new URL(BizboxAProperties.getProperty("BizboxA.fax.server") + URL_SUFFIX_SEND);
			conn = (HttpURLConnection) url.openConnection();
			
			conn.setConnectTimeout(5000);
			conn.setReadTimeout(120000);
			conn.setDoInput(true);
			conn.setDoOutput(true);
			conn.setUseCaches(false);
			conn.setRequestMethod("POST");
			conn.setRequestProperty("Content-Type", "multipart/form-data; boundary=" + boundary);
			conn.setRequestProperty("Content-Length", String.valueOf(body.length + file.getSize() + foot.length));
			
			conn.connect();
			
			OutputStream os = null;
			try{
				os = conn.getOutputStream();
				os.write(body);
				os.write(file.getBytes());
				os.write(foot);
				os.flush();
			}finally{
				if (os != null) { try { os.close(); } catch (Exception ignore) { 
					CommonUtil.printStatckTrace(ignore);//오류메시지를 통한 정보노출 
					} 
				}
			}
			
			String responseJson = "";
			InputStream is = null;
			try{
				is = conn.getInputStream();
				ByteArrayOutputStream stream = new ByteArrayOutputStream();
	
				byte[] buffer = new byte[4096];
	            int size = 0;
	            while ((size = is.read(buffer)) != -1) {
	                stream.write(buffer, 0, size);
	            }
	            
	            responseJson = new String(stream.toByteArray(), CHARSET);
			}finally{
				if (is != null) { try { is.close(); } catch (Exception ignore) { 
					CommonUtil.printStatckTrace(ignore);//오류메시지를 통한 정보노출
					} 
				}
			}
            
            if(responseJson.charAt(0) != '{') {
            	responseJson = AES128Util.AES_Decode(responseJson);
            }
            logger.info("Fax Send API Response = " + responseJson);
            
            FaxResponse faxRes = mapper.readValue(responseJson, FaxResponse.class);
            if(faxRes.getResultCode().equals("0")){
            	response = LogHelper.createSuccess(null);
				time = System.currentTimeMillis() - time;
				logger.info("faxSend-end ET[" + time + "] " + faxData);
            } else if(Integer.parseInt(faxRes.getResultCode()) >= 200){
            	response = LogHelper.createError(servletRequest, codeHead, "FX" + faxRes.getResultCode());
            	time = System.currentTimeMillis() - time;
				logger.info("faxSend-error ET[" + time + "] " + faxData);
            } else {
            	APIException e = new APIException("FX101", faxRes.getResultMessage());
            	response = LogHelper.createError(servletRequest, codeHead, e);
            	time = System.currentTimeMillis() - time;
				logger.info("faxSend-error ET[" + time + "] " + faxData);
            }
		}catch(Exception e){
			response = LogHelper.createError(servletRequest, codeHead, "FX101");
			time = System.currentTimeMillis() - time;
			logger.error("faxSend-error ET[" + time +"] ", e);
		}finally{
			if (conn != null) { conn.disconnect(); }
		}
		
		return response;
	}
	
	/**
	 * 팩스 커버 만들기
	 * @param request
	 */
	private void createFaxCover(Map<String, String> faxCoverInfo) {
		
		String contents = faxCoverInfo.remove("Contents");
		
		// 팩스 커버 미사용이면 공백 리턴
		if (faxCoverInfo.get("CoverUse").equals("0")){
			faxCoverInfo.put("CoverMemo", "");
			return;
		}

		faxCoverInfo.put("CoverMemo", contents);
	}
	
	/**
	 * 첨부파일 다운로드 (릴레이)
	 * @param request
	 * @param response
	 * @param agentId
	 * @param agentKey
	 * @param sendType
	 * @param faxKey
	 * @param fileNum
	 */
	public void download(HttpServletResponse response, String agentId,
			String agentKey, String sendType, String faxKey, String fileNum) {
		
		logger.info("FaxService.download-start agentId=" + agentId + ", agentKey=" + agentKey
				+ ", sendType=" + sendType + ", faxKey=" + faxKey + ", fileNum=" + fileNum);
		
		Map<String, Object> body = new HashMap<String, Object>();
		body.put("AgentID", agentId);
		body.put("AgentKey", agentKey);
		body.put("SendType", sendType);
		body.put("FaxKey", faxKey);
		body.put("FaxFilePageNo", fileNum);

		FaxRequest req = new FaxRequest();
		req.setHeader(new FaxRequestHeader());
		req.setBody(body);
		
		try{
			String requestJson = mapper.writeValueAsString(req);
			requestJson = AES128Util.AES_Encode(requestJson);
		
			URL url = new URL(BizboxAProperties.getProperty("BizboxA.fax.server") + URL_SUFFIX_DOWNLOAD);
			HttpURLConnection conn = (HttpURLConnection) url.openConnection();
			
			conn.setConnectTimeout(5000);
			conn.setReadTimeout(60000);
			conn.setDoInput(true);
			conn.setDoOutput(true);
			conn.setUseCaches(false);
			conn.setRequestMethod("POST");
			
			byte[] data = requestJson.getBytes(CHARSET);
			conn.setRequestProperty("Content-Length", String.valueOf(data.length));
			conn.setRequestProperty("Content-Type", "application/json; charset=utf-8");
			
			conn.connect();
			
			OutputStream out = null;
			try {
				out = conn.getOutputStream();
				out.write(data);
				out.flush();
			} finally {
				if (out != null) { try { out.close(); } catch (Exception ignore) { 
					CommonUtil.printStatckTrace(ignore);//오류메시지를 통한 정보노출
					} 
				}
			}
			
			InputStream in  = null;
			try {
				in = conn.getInputStream();
				
				response.setContentLength(conn.getContentLength());
				response.setContentType(conn.getContentType());
				
				out = response.getOutputStream();
				
				int offset = 0;
				byte[] buf = new byte[4096];
				
				while((offset = in.read(buf, 0, buf.length)) > 0) {
					out.write(buf, 0, offset);
				}
				out.flush();
			} finally {
				if (in != null) { try { in.close(); } catch (Exception ignore) { 
					CommonUtil.printStatckTrace(ignore);//오류메시지를 통한 정보노출
					} 
				}
				if (out != null) { try { out.close(); } catch (Exception ignore) { 
					CommonUtil.printStatckTrace(ignore);//오류메시지를 통한 정보노출
					} 
				}
				if (conn != null) { conn.disconnect(); }
			}
			
			logger.info("FaxService.download-end agentId=" + agentId + ", agentKey=" + agentKey
					+ ", sendType=" + sendType + ", faxKey=" + faxKey + ", fileNum=" + fileNum);
		}catch(Exception e){
			logger.error("FaxService.download-error", e);
		}
	}
	
	/**
	 * 
	 * @param callbackJson
	 * @throws JsonParseException
	 * @throws JsonMappingException
	 * @throws IOException
	 * @throws InvalidKeyException
	 * @throws NoSuchAlgorithmException
	 * @throws NoSuchPaddingException
	 * @throws InvalidAlgorithmParameterException
	 * @throws IllegalBlockSizeException
	 * @throws BadPaddingException
	 */
	public void alarm(String alarmJson) {
		try{
			alarmJson = AES128Util.AES_Decode(alarmJson);
			logger.info("alarm-" + alarmJson);
		}catch(Exception e){
			logger.error("alarm-error" + e);
		}
	}
	
	
	public Map<String, Object> getFaxInfo(Map<String, Object> params) {
		Map<String, Object> result = new HashMap<String, Object>();
		
		result.put("faxInfo", apiDAO.list("faxDAO.gefFaxInfo", params));
	
		return result;
	}
	
	public Map<String, Object> getFaxIDAndNO(HttpServletRequest servletRequest, Map<String, Object> params) {
		Map<String, Object> result = new HashMap<String, Object>();
		LoginVO loginVO = (LoginVO) servletRequest.getSession().getAttribute("loginVO");
		
		params.put("groupSeq", loginVO.getGroupSeq());
		result.put("faxIDAndNO", apiDAO.list("faxDAO.getFaxIDAndNO", params));
		
//		System.out.println("result: " + result);
		
		return result;
	}

	public Map<String, Object> getFaxComp(HttpServletRequest servletRequest, Map<String, Object> params) {
		Map<String, Object> result = new HashMap<String, Object>();
		LoginVO loginVO = (LoginVO) servletRequest.getSession().getAttribute("loginVO");
		params.put("langCode", loginVO.getLangCode());
		params.put("gbnOrgList", "'c'");
		params.put("groupSeq", loginVO.getGroupSeq());
		result.put("faxComp", apiDAO.list("faxDAO.getFaxComp", params));
		
//		System.out.println("result: " + result);
		
		return result;
	}
	
	public Map<String, Object> setSmsComp(Map<String, Object> params) {
		Map<String, Object> result = new HashMap<String, Object>();
		Map<String, Object> items = null;
		Map<String, Object> deleteItem = new HashMap<String, Object>();
		
		String paramsInfo = params.get("smsCompParams").toString();
		
		JSONObject jsonObject = JSONObject.fromObject(JSONSerializer
				.toJSON(paramsInfo));
		
		JSONArray compInfoArray = jsonObject.getJSONArray("compInfoArray");
		if(compInfoArray.size() == 0) {
			deleteItem.put("smsId", params.get("bill36524Id"));
		} else {
			deleteItem.put("smsId", compInfoArray.getJSONObject(0).get("sms_id"));
		}
		
		apiDAO.update("faxDAO.delSMSCompany", deleteItem);
		
		for(int i=0; i<compInfoArray.size(); i++) {
			JSONObject compInfo = compInfoArray.getJSONObject(i);
			items = new HashMap<String, Object>();
			items.put("compSeq", compInfo.get("compSeq").toString());
			items.put("smsId", compInfo.get("sms_id").toString());
			
			
			apiDAO.update("faxDAO.addSMSCompany", items);
		}
		
//		System.out.println("result: " + result);
		
		return result;
	}

	public APIResponse getNameChange(Map<String, Object> params) {
		
		if(params == null) {
			return null;
		}
		
		APIResponse response = null;
		return response;
	}
	
	//제거되지 않고 남은 디버그 코드	
//	public static void main(String[] args){
////		System.out.println(UUID.randomUUID().toString());
////		System.out.println(UUID.randomUUID().toString());
//	}

	public String getFaxNickNameOption(Map<String, Object> params) {
		return (String) apiDAO.select("faxDAO.getFaxNickNameOption", params);
	}
	
	private void saveFaxNickNameOption(Map<String, Object> request) {
		apiDAO.update("faxDAO.saveFaxNickNameOption", request);		
	}

	public String getFaxNickName(Map<String, Object> params) {
		return (String) apiDAO.select("faxDAO.getFaxNickName", params);
	}
	
	public void saveFaxNickName(Map<String, Object> params) {
		apiDAO.update("faxDAO.saveFaxNickName", params);
	}	
	
}