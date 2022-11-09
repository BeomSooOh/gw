package api.account.service;

import java.io.UnsupportedEncodingException;
import java.rmi.RemoteException;
import java.security.InvalidAlgorithmParameterException;
import java.security.InvalidKeyException;
import java.security.NoSuchAlgorithmException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import javax.annotation.Resource;
import javax.crypto.BadPaddingException;
import javax.crypto.IllegalBlockSizeException;
import javax.crypto.NoSuchPaddingException;
import javax.servlet.http.HttpServletRequest;

import neos.cmm.db.CommonSqlDAO;
import neos.cmm.util.AESCipher;
import neos.cmm.util.BizboxAProperties;

import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.InitializingBean;
import org.springframework.stereotype.Service;

import com.duzon.www.ScrapingInput;
import com.duzon.www.WebScrappingStub;

import bizbox.orgchart.service.vo.LoginVO;
import api.common.dao.APIDAO;
import api.common.exception.APIException;
import api.common.helper.LogHelper;
import api.common.model.APIResponse;

@Service("AccountService")
public class AccountService implements InitializingBean {
	
	@Resource(name = "commonSql")
	private CommonSqlDAO commonSql;
	
	private static final Logger logger = LoggerFactory.getLogger(AccountService.class);
	
	private static final String TRANSACTION = "21"; // 거래내역 조회
	
	private static final String BALANCE = "22"; // 잔액 조회
	
	private static final String CALLBACK_URL = "/gw/api/account/AccountCallback";
	
	private static final String SYSTEM_TYPE = "BIZBOX_A";
	
	private String codeHead = "systemx.account.";
	
	@Resource(name = "APIDAO")
	private APIDAO apiDAO;
	
	private WebScrappingStub stub;
	
	@Override
	public void afterPropertiesSet() throws Exception {
		try{
			stub = new WebScrappingStub(BizboxAProperties.getProperty("BizboxA.account.server"));
			stub._getServiceClient().getOptions().setProperty(org.apache.axis2.transport.http.HTTPConstants.CHUNKED, Boolean.FALSE);
			stub._getServiceClient().getOptions().setSoapVersionURI(org.apache.axiom.soap.SOAP11Constants.SOAP_ENVELOPE_NAMESPACE_URI);
		}catch(Exception e){
			logger.error("WebScrappingStub Create Error!", e);
		}
	}
	
	/**
	 * API 요청 처리
	 * @param servletRequest
	 * @param servletResponsePI
	 * @param request
	 * @param serviceName
	 * @return
	 */
	public APIResponse action(HttpServletRequest servletRequest,
			Map<String, Object> request,
			String serviceName) {
		
		long time = System.currentTimeMillis();
		
		APIResponse response = null;
		String serviceErrorCode = "AC100";
		
		/* 세션 체크 */
		if(servletRequest.getSession() == null || servletRequest.getSession().getAttribute("loginVO") == null){
			APIException ae = new APIException("AC000");
			response = LogHelper.createError(servletRequest, codeHead, ae);
			time = System.currentTimeMillis() - time;
			logger.error(serviceName + "-error ET[" + time + "] " + LogHelper.getResponseString(request, response), ae);
			return response;
		}
		
		/* 세션에서 필요값 꺼내오기 */
		LoginVO loginVO = (LoginVO) servletRequest.getSession().getAttribute("loginVO");
		request.put("groupSeq", loginVO.getGroupSeq());
		request.put("compSeq", loginVO.getOrganId());
		request.put("deptSeq", loginVO.getOrgnztId());
		request.put("empSeq", loginVO.getUniqId());
		
		/* 인터페이스 별 로직 수행 */
		try {
			logger.info(serviceName + "-start " + LogHelper.getRequestString(request));
			Object result = null;
			
			if(serviceName.equals("AccountList")){
				serviceErrorCode = "AC001";
				result = AccountList(request);
			}else if(serviceName.equals("AccountAdd")){
				serviceErrorCode = "AC002";
				AccountAdd(request, serviceErrorCode);
			}else if(serviceName.equals("AccountDel")){
				serviceErrorCode = "AC003";
				AccountDel(request, serviceErrorCode);
			}else if(serviceName.equals("Balance")){
				serviceErrorCode = "AC004";
				result = Balance(request, serviceErrorCode, servletRequest);
			}else if(serviceName.equals("Transaction")){
				serviceErrorCode = "AC005";
				result = Transaction(request, serviceErrorCode, servletRequest);
			}else if(serviceName.equals("CBCodeList")){
				serviceErrorCode = "AC006";
				result = CBCodeList();
			}else if(serviceName.equals("CBSettingList")){
				serviceErrorCode = "AC007";
				result = CBSettingList(request);
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
	
	
	public APIResponse action4m(HttpServletRequest servletRequest,
			Map<String, Object> request,
			String serviceName) {
		
		long time = System.currentTimeMillis();
		
		APIResponse response = null;
		String serviceErrorCode = "AC100";
		
		@SuppressWarnings("unchecked")
		Map<String, Object> header = (Map<String, Object>) request.get("header");
		@SuppressWarnings("unchecked")
		Map<String, Object> body = (Map<String, Object>) request.get("body");
		body.putAll(header);
		
		/* 인터페이스 별 로직 수행 */
		try {
			logger.info(serviceName + "-start " + LogHelper.getRequestString(request));
			Object result = null;
			
			if(serviceName.equals("AccountList")){
				serviceErrorCode = "AC001";
				result = AccountList(body);
			}else if(serviceName.equals("AccountAdd")){
				serviceErrorCode = "AC002";
				AccountAdd(body, serviceErrorCode);
			}else if(serviceName.equals("AccountDel")){
				serviceErrorCode = "AC003";
				AccountDel(body, serviceErrorCode);
			}else if(serviceName.equals("Balance")){
				serviceErrorCode = "AC004";
				result = Balance(body, serviceErrorCode, servletRequest);
			}else if(serviceName.equals("Transaction")){
				serviceErrorCode = "AC005";
				result = Transaction(body, serviceErrorCode, servletRequest);
			}else if(serviceName.equals("CBCodeList")){
				serviceErrorCode = "AC006";
				result = CBCodeList();
			}else if(serviceName.equals("CBSettingList")){
				serviceErrorCode = "AC007";
				result = CBSettingList(body);
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
	 * 계좌 목록 조회
	 * @param request
	 * @return
	 * @throws BadPaddingException 
	 * @throws IllegalBlockSizeException 
	 * @throws UnsupportedEncodingException 
	 * @throws InvalidAlgorithmParameterException 
	 * @throws NoSuchPaddingException 
	 * @throws NoSuchAlgorithmException 
	 * @throws InvalidKeyException 
	 */
	private Object AccountList(Map<String, Object> request) throws InvalidKeyException, NoSuchAlgorithmException, NoSuchPaddingException, InvalidAlgorithmParameterException, UnsupportedEncodingException, IllegalBlockSizeException, BadPaddingException{
		Map<String, Object> result = new HashMap<String, Object>();
		@SuppressWarnings("unchecked")
		List<Map<String, String>> accountList = apiDAO.list("accountDAO.selectAccountList", request);
		for(Map<String, String> account : accountList){
			account.put("cbNo", AESCipher.AES_Decode(account.get("cbNo")));
			account.put("cbPw", AESCipher.AES_Decode(account.get("cbPw")));
			account.put("cbLoginId", AESCipher.AES_Decode(account.get("cbLoginId")));
			account.put("cbLoginPw", AESCipher.AES_Decode(account.get("cbLoginPw")));
			account.put("idnNo", AESCipher.AES_Decode(account.get("idnNo")));
		}
		result.put("accountList", accountList);
		return result;
	}
	
	/**
	 * 계좌 등록/수정
	 * @param request
	 * @param serviceErrorCode
	 * @throws BadPaddingException 
	 * @throws IllegalBlockSizeException 
	 * @throws UnsupportedEncodingException 
	 * @throws InvalidAlgorithmParameterException 
	 * @throws NoSuchPaddingException 
	 * @throws NoSuchAlgorithmException 
	 * @throws InvalidKeyException 
	 */
	private void AccountAdd(Map<String, Object> request, String serviceErrorCode) throws InvalidKeyException, NoSuchAlgorithmException, NoSuchPaddingException, InvalidAlgorithmParameterException, UnsupportedEncodingException, IllegalBlockSizeException, BadPaddingException{
		String accountSeq = (String) request.get("accountSeq");
		
		if(request.get("cbNo") != null) {
			request.put("cbNo", AESCipher.AES_Encode((String) request.get("cbNo")));
		}
		if(request.get("cbPw") != null) {
			request.put("cbPw", AESCipher.AES_Encode((String) request.get("cbPw")));
		}
		if(request.get("cbLoginId") != null) {
			request.put("cbLoginId", AESCipher.AES_Encode((String) request.get("cbLoginId")));
		}
		if(request.get("cbLoginPw") != null) {
			request.put("cbLoginPw", AESCipher.AES_Encode((String) request.get("cbLoginPw")));
		}
		if(request.get("idnNo") != null) {
			request.put("idnNo", AESCipher.AES_Encode((String) request.get("idnNo")));
		}
			
		if(StringUtils.isEmpty(accountSeq)){
			request.put("accountSeq", UUID.randomUUID().toString().toUpperCase());
			apiDAO.insert("accountDAO.insertAccount", request);
		}else{
			int result = apiDAO.update("accountDAO.updateAccount", request);
			
			if(result < 1) {
				throw new APIException(serviceErrorCode);
			}
		}
	}
	
	/**
	 * 계좌 삭제
	 * @param request
	 * @param serviceErrorCode
	 */
	private void AccountDel(Map<String, Object> request, String serviceErrorCode){
		int result = apiDAO.delete("accountDAO.deleteAccount", request);
		
		if(result < 1) {
			throw new APIException(serviceErrorCode);
		}
	}
	
	/**
	 * 계좌 정보 조회(잔액조회)
	 * @param request
	 * @param serviceErrorCode
	 * @param servletRequest
	 * @return
	 * @throws InvalidKeyException
	 * @throws NoSuchAlgorithmException
	 * @throws NoSuchPaddingException
	 * @throws InvalidAlgorithmParameterException
	 * @throws UnsupportedEncodingException
	 * @throws IllegalBlockSizeException
	 * @throws BadPaddingException
	 * @throws RemoteException
	 * @throws InterruptedException 
	 */
	private Map<String, String> Balance(Map<String, Object> request, String serviceErrorCode
			, HttpServletRequest servletRequest) throws InvalidKeyException, NoSuchAlgorithmException, NoSuchPaddingException, InvalidAlgorithmParameterException, UnsupportedEncodingException, IllegalBlockSizeException, BadPaddingException, InterruptedException {
				
		Map<String, Object> account = getAccount(request);
				
		if(account == null) {
			throw new APIException(serviceErrorCode);
		}
		
		String userGuid = UUID.randomUUID().toString().toUpperCase();
		
		account.putAll(request);
		
		// 요청한지 2시간 이상 지난 내역은 삭제
		apiDAO.delete("accountDAO.deleteStatusTwoHoursLater", account);
		
		account.put("cbNo", AESCipher.AES_Decode((String) account.get("cbNo")));
		account.put("cbPw", AESCipher.AES_Decode((String) account.get("cbPw")));
		account.put("cbLoginId", AESCipher.AES_Decode((String) account.get("cbLoginId")));
		account.put("cbLoginPw", AESCipher.AES_Decode((String) account.get("cbLoginPw")));
		account.put("idnNo", AESCipher.AES_Decode((String) account.get("idnNo")));
		account.put("userGuid", userGuid);
		account.put("trType", BALANCE);
		account.put("accFlag", "R");
		
		String returnUrl = servletRequest.getScheme() + "://" + servletRequest.getServerName() + ":"
				+ servletRequest.getServerPort() + CALLBACK_URL;
		logger.info("========== AccountCallback Url=" + returnUrl);
		
		ScrapingInput input = new ScrapingInput();
		input.setUSERID((String) account.get("empSeq"));
		input.setUSERID_GUID(userGuid);
		input.setReturnUrl(returnUrl);
		input.setObj1("B");
		input.setObj2((String) account.get("svType"));
		input.setObj3((String) account.get("cbCode"));
		input.setObj4((String) account.get("scType"));
		input.setObj5("");
		input.setObj6((String) account.get("cbLoginId"));
		input.setObj7((String) account.get("cbLoginPw"));
		input.setObj8("");
		input.setObj9("");
		input.setObj10("");
		input.setObj11(BALANCE);
		input.setObj12((String) account.get("cbNo"));
		input.setObj13("");
		input.setObj14("");
		input.setObj15((String) account.get("cbPw"));
		input.setObj16((String) account.get("idnNo"));
		input.setObj17("");
		input.setObj18("");
		input.setObj19("");
		input.setSystemType(SYSTEM_TYPE);
		input.setAddParams("");
		
		String res = "";
		try{
			res = stub.scrapingInput(input).getScrapingInputResult();
			//res = "OK";
			//res = "EIE2099 장기 미사용으로 인해 입출금 거래가 제한된 계좌입니다. 반드시 해당 은행 영업점에 방문하여 조치 후 이용하시기 바랍니다.";
		}catch(Exception e){
			logger.error("=== 계좌 웹서비스 호출 에러", e);
			throw new APIException(serviceErrorCode);
		}
		
		if(!res.equals("OK") && !res.equals("")){ // 실패 리턴
			logger.error(String.format("=== 잔액 조회 에러 리턴  [%s]", res));
			account.put("errCode", "");
			account.put("errMsg", res);
			account.put("accFlag", "F");
		}else{
			logger.debug(String.format("=== 잔액 조회 리턴  [%s]", res));
		}
		
		apiDAO.insert("accountDAO.insertStatus", account);
		
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("userGuid", userGuid);
		
		Map<String, String> callback = getCallbackAccountStatus(mp);
		
		if((!res.equals("OK") && !res.equals("")) || callback == null || !callback.get("errCode").equals("")){
			logger.debug(String.format("=== 잔액조회 콜백 에러 리턴 userGuid=%s", userGuid));
			
			if(callback != null && callback.get("errMsg") != null) {
				throw new APIException(serviceErrorCode, callback.get("errMsg"));
			}
			else {
				throw new APIException(serviceErrorCode);
			}
		}
		
		callback.remove("errMsg");
		callback.remove("errCode");
		
		callback.put("accType", AESCipher.AES_Decode(callback.get("accType")));
		callback.put("accName", AESCipher.AES_Decode(callback.get("accName")));
		callback.put("availMoney", AESCipher.AES_Decode(callback.get("availMoney")));
		callback.put("balance", AESCipher.AES_Decode(callback.get("balance")));
		
		return callback;
	}
	
	/**
	 * 거래 내역 조회
	 * @param request
	 * @param serviceErrorCode
	 * @param servletRequest
	 * @return
	 * @throws InterruptedException 
	 * @throws BadPaddingException 
	 * @throws IllegalBlockSizeException 
	 * @throws UnsupportedEncodingException 
	 * @throws InvalidAlgorithmParameterException 
	 * @throws NoSuchPaddingException 
	 * @throws NoSuchAlgorithmException 
	 * @throws InvalidKeyException 
	 * @throws RemoteException 
	 */
	private Map<String, Object> Transaction(Map<String, Object> request, String serviceErrorCode
			, HttpServletRequest servletRequest) throws InterruptedException, InvalidKeyException, NoSuchAlgorithmException, NoSuchPaddingException, InvalidAlgorithmParameterException, UnsupportedEncodingException, IllegalBlockSizeException, BadPaddingException {

		Map<String, Object> result = new HashMap<String, Object>();
		
		int pageSize = (Integer) request.get("pageSize");
		int pageNum = (Integer) request.get("pageNum");
		
		int startIdx = (pageNum - 1) * pageSize;
		request.put("startIdx", startIdx);
		request.put("pageSize", pageSize + 1);
		
		// 1페이지 요청할 경우 - 스크래핑 호출
		// 1페이지 이상 - DB에서 조회
		if(pageNum > 1){
			String moreYn = "N";
			@SuppressWarnings("unchecked")
			List<Map<String, String>> transactionList = apiDAO.list("accountDAO.selectTransaction", request);
			if(transactionList.size() > pageSize){
				transactionList.remove(pageSize);
				moreYn = "Y";
			}
			
			for(Map<String, String> transaction : transactionList){
				transaction.put("summary", AESCipher.AES_Decode(transaction.get("summary")));
				transaction.put("receiver", AESCipher.AES_Decode(transaction.get("receiver")));
				transaction.put("etc", AESCipher.AES_Decode(transaction.get("etc")));
				transaction.put("note", AESCipher.AES_Decode(transaction.get("note")));
				transaction.put("division", AESCipher.AES_Decode(transaction.get("division")));
			}
			
			result.put("transactionList", transactionList);
			result.put("userGuid", request.get("userGuid"));
			result.put("moreYn", moreYn);
			
			return result;
		}
		
		// 첫페이지는 스크래핑 호출 
		Map<String, Object> account = getAccount(request);
		
		if(account == null) {
			throw new APIException(serviceErrorCode);
		}
			
		String userGuid = UUID.randomUUID().toString().toUpperCase();
		request.put("userGuid", userGuid);
		
		account.putAll(request);

		// 요청한지 2시간 이상 지난 내역은 삭제
		apiDAO.delete("accountDAO.deleteStatusTwoHoursLater", account);
				
		account.put("cbNo", AESCipher.AES_Decode((String) account.get("cbNo")));
		account.put("cbPw", AESCipher.AES_Decode((String) account.get("cbPw")));
		account.put("cbLoginId", AESCipher.AES_Decode((String) account.get("cbLoginId")));
		account.put("cbLoginPw", AESCipher.AES_Decode((String) account.get("cbLoginPw")));
		account.put("idnNo", AESCipher.AES_Decode((String) account.get("idnNo")));
		account.put("trType", TRANSACTION);
		account.put("accFlag", "R");
		
		String returnUrl = servletRequest.getScheme() + "://" + servletRequest.getServerName() + ":"
				+ servletRequest.getServerPort() + CALLBACK_URL;
		logger.info("========== AccountCallback Url=" + returnUrl);
		
		ScrapingInput input = new ScrapingInput();
		input.setUSERID((String) account.get("empSeq"));
		input.setUSERID_GUID(userGuid);
		input.setReturnUrl(returnUrl);
//		input.setReturnUrl("http://221.133.55.230/gw/account/AccountCallback");
		input.setObj1("B");
		input.setObj2((String) account.get("svType"));
		input.setObj3((String) account.get("cbCode"));
		input.setObj4((String) account.get("scType"));
		input.setObj5("");
		input.setObj6((String) account.get("cbLoginId"));
		input.setObj7((String) account.get("cbLoginPw"));
		input.setObj8("");
		input.setObj9("");
		input.setObj10("");
		input.setObj11(TRANSACTION);
		input.setObj12((String) account.get("cbNo"));
		input.setObj13((String) account.get("from"));
		input.setObj14((String) account.get("to"));
		input.setObj15((String) account.get("cbPw"));
		input.setObj16((String) account.get("idnNo"));
		input.setObj17("");
		input.setObj18("");
		input.setObj19("");
		input.setSystemType(SYSTEM_TYPE);
		input.setAddParams("");
		
		String res = "";
		try{
			res = stub.scrapingInput(input).getScrapingInputResult();
			//res = "OK";
			//res = "EIE2099 장기 미사용으로 인해 입출금 거래가 제한된 계좌입니다. 반드시 해당 은행 영업점에 방문하여 조치 후 이용하시기 바랍니다.";
		}catch(Exception e){
			logger.error("=== 계좌 웹서비스 호출 에러", e);
			throw new APIException(serviceErrorCode);
		}
			
		if(!res.equals("OK") && !res.equals("")){ // 실패 리턴
			logger.error(String.format("=== 거래내역 조회 에러 리턴  [%s]", res));
			account.put("errCode", "");
			account.put("errMsg", res);
			account.put("accFlag", "F");
		}else{
			logger.debug(String.format("=== 거래내역 조회 리턴  [%s]", res));
		}
		apiDAO.insert("accountDAO.insertStatus", account);
		
		
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("userGuid", userGuid);
		
		Map<String, String> callback = getCallbackAccountStatus(mp);
		
		/* 2017-01-25 거래 내역 없을 때 Exception 방지 */
		if(callback.get("errCode").equals("EDE3001")){
			callback.put("errCode", "");
		}
		
		if((!res.equals("OK") && !res.equals("")) || callback == null || !callback.get("errCode").equals("")){
			logger.error(String.format("=== 거래내역 조회 콜백 에러 리턴 userGuid=%s", userGuid));
			if(callback != null && callback.get("errMsg") != null){
				throw new APIException(serviceErrorCode, callback.get("errMsg"));
			}
			else{
				throw new APIException(serviceErrorCode);
			}
				
		}
		
		callback.remove("errMsg");
		callback.remove("errCode");
		
		String moreYn = "N";
		@SuppressWarnings("unchecked")
		List<Map<String, String>> transactionList = apiDAO.list("accountDAO.selectTransaction", request);
		if(transactionList.size() > pageSize){
			transactionList.remove(pageSize);
			moreYn = "Y";
		}
		
		for(Map<String, String> transaction : transactionList){
			transaction.put("summary", AESCipher.AES_Decode(transaction.get("summary")));
			transaction.put("receiver", AESCipher.AES_Decode(transaction.get("receiver")));
			transaction.put("etc", AESCipher.AES_Decode(transaction.get("etc")));
			transaction.put("note", AESCipher.AES_Decode(transaction.get("note")));
			transaction.put("division", AESCipher.AES_Decode(transaction.get("division")));
		}
		
		result.put("transactionList", transactionList);
		result.put("userGuid", userGuid);
		result.put("moreYn", moreYn);
		
		return result;
	}
	
	/**
	 * 계좌 조회 및 에러 처리
	 * @param request
	 * @return
	 */
	private Map<String, Object> getAccount(Map<String, Object> request){
		@SuppressWarnings("unchecked")
		Map<String, Object> account = (Map<String, Object>) apiDAO.select("accountDAO.selectAccount", request);
		// 다시 요청하면 안돼는 에러들은 계좌 수정 후 요청 하도록 유도
		if(account.get("lastAccFlag") == null || account.get("lastAccFlag").equals("E")) {
			throw new APIException("AC101", (String) account.get("lastErrMsg"));
		}
		
		return account;
	}
	
	/**
	 * t_ac_status 테이블에서 콜백 결과 가져온다.
	 * @param userGuid
	 * @return
	 * @throws InterruptedException 
	 */
	@SuppressWarnings("unchecked")
	private Map<String, String> getCallbackAccountStatus(Map<String, Object> mp) throws InterruptedException{
		Map<String, String> result = null;
		
		long time = System.currentTimeMillis();
		
		while(true){
			if((System.currentTimeMillis() - time) > 45000) {
				break;
			}
			
			result = (Map<String, String>) apiDAO.select("accountDAO.selectStatus", mp);
			
			if(result != null) {
				break;
			}
			
			Thread.sleep(1000);
		}
		return result;
	}
	
	/**
	 * 은행 코드 목록 조회
	 * @return
	 */
	private Object CBCodeList(){
		Map<String, Object> result = new HashMap<String, Object>();
		Map<String, Object> mp = new HashMap<String, Object>();
		result.put("cbCodeList", commonSql.list("accountDAO.selectCBCodeList", mp));
		return result;
	}
	
	/**
	 * 은행별 요구사항 목록
	 * @param request
	 * @return
	 */
	private Object CBSettingList(Map<String, Object> request){
		Map<String, Object> result = new HashMap<String, Object>();
		result.put("cbSettingList", apiDAO.list("accountDAO.selectCBSettingList", request));
		return result;
	}
}