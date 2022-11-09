package api.account.service;

import java.io.UnsupportedEncodingException;
import java.security.InvalidAlgorithmParameterException;
import java.security.InvalidKeyException;
import java.security.NoSuchAlgorithmException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;

import javax.annotation.Resource;
import javax.crypto.BadPaddingException;
import javax.crypto.IllegalBlockSizeException;
import javax.crypto.NoSuchPaddingException;

import neos.cmm.util.AESCipher;

import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.jdbc.datasource.DataSourceTransactionManager;
import org.springframework.stereotype.Service;
import org.springframework.transaction.TransactionDefinition;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.DefaultTransactionDefinition;

import api.common.dao.APIDAO;

@Service("CallbackService")
public class CallbackService {
	@Resource(name = "egov.transactionManager")
	private DataSourceTransactionManager txManager;

	private static final Logger logger = LoggerFactory.getLogger(CallbackService.class);
	
	@Resource(name = "APIDAO")
	private APIDAO apiDAO;
	
	private static final String CALLBACK_TRANSACTION = "21"; // 거래내역 조회
	
	private static final String CALLBACK_BALANCE = "22"; // 잔액 조회
	
	private final List<String> ExceptionAccountReturn =
			new ArrayList<String>(Arrays.asList("ECE1001",
			"ECE1005", "ECE1006", "ECE1007", "ECE1008", "ECE1009",
			"ECE1100", "EIE2001", "EIE2002", "EIE2003", "EIE2004",
			"EIE2005", "EIE2006", "EIE2007", "EIE2008", "EIE2009"));
	/**
	 * 계좌 조회 콜백 처리
	 * @param data
	 */
	public void callback(Map<String, Object> data){
		String userid = (String) data.get("USERID");
		String userGuid = (String) data.get("GUID");
		List<Map<String, String>> rData = (List<Map<String, String>>) data.get("Data");
		
		String callbackType = (String) data.get("rdatatype");
		callbackType = callbackType.substring(callbackType.length() - 2);

		DefaultTransactionDefinition def = new DefaultTransactionDefinition();
	    def.setPropagationBehavior(TransactionDefinition.PROPAGATION_REQUIRED);
	    TransactionStatus txStatus= txManager.getTransaction(def);
	    
		try{
			if(callbackType.equals(CALLBACK_BALANCE)){
				callbackBalance(userid, userGuid, data.get("totalcount").toString(), rData);
			}else if(callbackType.equals(CALLBACK_TRANSACTION)){
				callbackTransaction(userid, userGuid, data.get("totalcount").toString(), rData);
			}
			
			txManager.commit(txStatus);
		}catch(Exception e){
			logger.error(String.format("=======콜백 프로세스 에러 userid=%s,user_guid=%s"
					, userid, userGuid), e);
			txManager.rollback(txStatus);
		}
	}
	
	/**
	 * 잔액 조회 콜백 처리
	 * @param userid
	 * @param user_guid
	 * @param balance
	 * @throws BadPaddingException 
	 * @throws IllegalBlockSizeException 
	 * @throws UnsupportedEncodingException 
	 * @throws InvalidAlgorithmParameterException 
	 * @throws NoSuchPaddingException 
	 * @throws NoSuchAlgorithmException 
	 * @throws InvalidKeyException 
	 */
	private void callbackBalance(String userid, String userGuid, String count,
			List<Map<String, String>> balance) throws InvalidKeyException, NoSuchAlgorithmException, NoSuchPaddingException, InvalidAlgorithmParameterException, UnsupportedEncodingException, IllegalBlockSizeException, BadPaddingException {
		logger.info(String.format("=======콜백 잔액조회 userid=%s,user_guid=%s,Rowcount=%s"
				, userid, userGuid, count));
		
		Map<String, String> vo = new HashMap<String, String>();
		vo.put("empSeq", userid);
		vo.put("userGuid", userGuid);
		 
		String accountSeq = (String) apiDAO.select("accountDAO.selectAccountSeqFromStatus", vo);
		if(StringUtils.isEmpty(accountSeq)) {
			return;
		}
		
		vo.put("accountSeq", accountSeq);
		
		String error = "";
		Set<String> keys = balance.get(0).keySet();
		for(String key : keys){
			if(key.toLowerCase().contains("exception")){
				error = balance.get(0).get(key);
				break;
			}
		}
		
		if(StringUtils.isNotEmpty(error)){
			logger.info(String.format("=======콜백 잔액조회 에러 userid=%s,user_guid=%s,Message=%s"
					, userid, userGuid, error));
			
			String errCode = error.substring(0, 7);
			
			vo.put("errCode", errCode);
			vo.put("errMsg", error);
			vo.put("accType", "");
			vo.put("accName", "");
			vo.put("availMoney", "");
			vo.put("balance", "");
			vo.put("accFlag", "F");
			
			// 에러코드가 다시 요청하지 말아야할 에러코드 이면 accFlag 를 E로 세팅
			if(ExceptionAccountReturn.contains(errCode)) {
				vo.put("accFlag", "E");
			}
			
			apiDAO.update("accountDAO.updateStatus", vo);
			apiDAO.update("accountDAO.updateAccountLastErr", vo);
			return;
		}
		
		vo.put("errCode", "");
		vo.put("errMsg", "");
		vo.put("accType", AESCipher.AES_Encode(balance.get(0).get("예금종류")));
		vo.put("accName", AESCipher.AES_Encode(balance.get(0).get("예금주명")));
		vo.put("availMoney", AESCipher.AES_Encode(balance.get(0).get("출금가능금액")));
		vo.put("balance", AESCipher.AES_Encode(balance.get(0).get("잔액")));
		vo.put("accFlag", "C");
		
		apiDAO.update("accountDAO.updateStatus", vo);
		apiDAO.update("accountDAO.updateAccountLastErr", vo);
	}
	
	/**
	 * 거래내역 콜백 처리
	 * @param userid
	 * @param user_guid
	 * @param trans
	 * @throws BadPaddingException 
	 * @throws IllegalBlockSizeException 
	 * @throws UnsupportedEncodingException 
	 * @throws InvalidAlgorithmParameterException 
	 * @throws NoSuchPaddingException 
	 * @throws NoSuchAlgorithmException 
	 * @throws InvalidKeyException 
	 */
	private void callbackTransaction(String userid, String userGuid,
			String count, List<Map<String, String>> trans) throws InvalidKeyException, NoSuchAlgorithmException, NoSuchPaddingException, InvalidAlgorithmParameterException, UnsupportedEncodingException, IllegalBlockSizeException, BadPaddingException {
		logger.info(String.format("=======콜백 거래내역 userid=%s,user_guid=%s,Rowcount=%s"
				, userid, userGuid, count));
		
		Map<String, String> vo = new HashMap<String, String>();
		vo.put("empSeq", userid);
		vo.put("userGuid", userGuid);
		
		String accountSeq = (String) apiDAO.select("accountDAO.selectAccountSeqFromStatus", vo);
		if(StringUtils.isEmpty(accountSeq)) {
			return;
		}
		
		vo.put("accountSeq", accountSeq);
		
		String error = "";
		Set<String> keys = trans.get(0).keySet();
		for(String key : keys){
			if(key.toLowerCase().contains("exception")){
				error = trans.get(0).get(key);
				break;
			}
		}
		
		if(StringUtils.isNotEmpty(error)){
			logger.info(String.format("=======콜백 거래내역 조회 에러 userid=%s,user_guid=%s,Message=%s"
					, userid, userGuid, error));
			
			String errCode = error.substring(0, 7);
			
			vo.put("errCode", errCode);
			vo.put("errMsg", error);
			vo.put("accType", "");
			vo.put("availMoney", "");
			vo.put("balance", "");
			vo.put("accFlag", "F");
			
			// 에러코드가 다시 요청하지 말아야할 에러코드 이면 accFlag 를 E로 세팅
			if(ExceptionAccountReturn.contains(errCode)) {
				vo.put("accFlag", "E");
			}
			if(errCode.equals("EDE3001")) { // 조회되는 데이터가 없습니다. 는 정상 처리.
				vo.put("accFlag", "C");
			}
			
			apiDAO.update("accountDAO.updateStatus", vo);
			apiDAO.update("accountDAO.updateAccountLastErr", vo);
			return;
		}
		
		vo.put("errCode", "");
		vo.put("errMsg", "");
		vo.put("accType", "");
		vo.put("availMoney", "");
		vo.put("balance", "");
		vo.put("accFlag", "C");
		
		apiDAO.update("accountDAO.updateStatus", vo);
		apiDAO.update("accountDAO.updateAccountLastErr", vo);
		
		for(Map<String, String> row : trans){
			Map<String, String> data = new HashMap<String, String>();
			data.put("userGuid", userGuid);
			data.put("accountSeq", accountSeq);
			data.put("tDate", row.get("거래일자"));
			data.put("tTime", row.get("거래일시"));
			data.put("output", row.get("출금금액"));
			data.put("input", row.get("입금금액"));
			data.put("balance", row.get("거래후잔액"));
			data.put("summary", AESCipher.AES_Encode(row.get("적요")));
			data.put("receiver", AESCipher.AES_Encode(row.get("수취인")));
			data.put("etc", AESCipher.AES_Encode(row.get("거래점")));
			data.put("note", AESCipher.AES_Encode(row.get("비고")));
			data.put("division", AESCipher.AES_Encode(row.get("거래구분")));
			
			apiDAO.insert("accountDAO.insertTransaction", data);
		}
	}
}
