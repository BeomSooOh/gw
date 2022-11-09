package neos.cmm.util;

import java.io.UnsupportedEncodingException;
import java.util.List;
import java.util.Map;
import java.util.Properties;

import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.*;

import org.apache.log4j.Logger;
import org.codehaus.jackson.map.ObjectMapper;

import bizbox.orgchart.helper.ConnectionHelper;
import bizbox.orgchart.helper.ConnectionHelperFactory;

public class mailDomainMove {
	
	private static Logger logger = Logger.getLogger(mailDomainMove.class);
	
	private static final String MAIL_API_CREATE_DOMAIN_URL = "/mailAdmin/createDomain.do";
	private static final String MAIL_API_GET_COMPANY_LIST_URL = "/mailAdmin/getCompanyList.do";
	private static final String MAIL_API_COMPANY_USER_CHECK_URL = "/mailAdmin/companyUserCheck.do";
	private static final String MAIL_API_INSERT_COMPANY_URL = "/mailAdmin/insertCompany.do";
	private static final String MAIL_API_MODIFY_DOMAIN_URL = "/mailAdmin/modifyDomain.do";
	private static final String MAIL_API_MOVE_COMPANY_URL = "/mailAdmin/moveCompany.do";
	private static final String MAIL_API_DOMAIN_COMPANY_LIST_URL = "/mailAdmin/domainCompanyList.do";
	
	private mailDomainMove() {
	}
	
	public static void send(String tomail, String formname, String formmail, String title, String content) throws UnsupportedEncodingException, MessagingException{
		try {

			String smtpHost = "email.kofia.or.kr";
	
			Properties props = new Properties();
			props.put("mail.smtp.host", smtpHost);
			
			Session sess = Session.getDefaultInstance(props, null);
			InternetAddress addr = new InternetAddress();
			addr.setPersonal(formname,"UTF-8");
			addr.setAddress(formmail);
			 // create a message
			Message msg = new MimeMessage(sess);
			msg.setFrom(addr);         
			msg.setSubject(MimeUtility.encodeText(title, "utf-8","B"));
			msg.setContent(content, "text/html;charset=utf-8");
			msg.setRecipients(Message.RecipientType.TO, InternetAddress.parse(tomail));
		    
			Transport.send(msg);
		} catch (Exception e) {
			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
		}
	}
	
	/**
	 * 도메인 생성
	 * @param mailServerUrl
	 * @param params : domainName(생성할 도메인 이름 ex) douzone.com)
	 *                 domainGroup(그룹시퀀스 ex) demo)
	 * @return
	 */
	public static Map<String,Object> createDomain(String mailServerUrl, Map<String,Object> params) {
		String url = mailServerUrl + MAIL_API_CREATE_DOMAIN_URL;
		return sendApi(url, params);	
	}
	
	/**
	 * 
	 * @param mailServerUrl
	 * @param params
	 * @return
	 *  groupList
		domainCompList
		groupList		groupName	string	그룹 이름
						groupSeq	string	그룹 시퀀스
		domainCompList	domainSeq	int	도메인 시퀀스
						domainName	string	도메인 이름
						groupSeq	string	그룹시퀀스
						external	boolean	외부메일 여부 (외부메일 도메인에 회사 등록 불가)
						companyCnt	int	도메인에 속한 회사 개수
						companyList	array	도메인에 속한 회사 리스트
		companyList		compSeq	string	회사 시퀀스
						compName	string	회사 이름
						groupSeq	string	그룹시퀀스
						emailDomain	string	이메일 도메인
						order	int	순서
	 */
	public static Map<String,Object> domainCompanyList(String mailServerUrl, Map<String,Object> params) {
		String url = mailServerUrl + MAIL_API_DOMAIN_COMPANY_LIST_URL;
		return sendApi(url, params);	
	}
	
	/**
	 * 도메인에 회사등록
	 * @param mailServerUrl
	 * @param params :  domain   (도메인 이름)
						groupSeq (그룹 시퀀스)
						compSeq  (회사 시퀀스)
	 * @return
	 */
	public static Map<String,Object> insertCompany(String mailServerUrl, Map<String,Object> params) {
		String url = mailServerUrl + MAIL_API_INSERT_COMPANY_URL;
		return sendApi(url, params);	
	}
	
	/**
	 * 도메인 -회사 매핑 유저 체크
	 * @param mailServerUrl
	 * @param params :  domain   (도메인 이름)
						groupSeq (그룹 시퀀스)
						compSeq  (회사 시퀀스)
	 * @return 	code    1:성공, -1:에러, 2 중복되는 유저 발생
				dulplId 중복되는 아이디
 
	 * 
	 */
	public static Map<String,Object> companyUserCheck(String mailServerUrl, Map<String,Object> params) {
		String url = mailServerUrl + MAIL_API_COMPANY_USER_CHECK_URL;
		return sendApi(url, params);	
	}
	
	/**
	 * 등록할 회사 리스트 조회
	 * @param mailServerUrl
	 * @param params : groupSeq
	 * @return code
				compList : compSeq
							compName
	 */
	public static Map<String,Object> getCompanyList(String mailServerUrl, Map<String,Object> params) {
		String url = mailServerUrl + MAIL_API_GET_COMPANY_LIST_URL;
		return sendApi(url, params);	
	}
	
	/**
	 * 
	 * @param mailServerUrl
	 * @param params domainName	string	기존 도메인 이름
					changeDomain	string	수정한 도메인 이름

	 * @return  resultCode	string	"0":성공,"UC0001":오류 ,"UC0002":기존 도메인 유효하지 않음, "UC0003":수정한 도메인 유효하지 않음, "UC0004":수정한 도메인 이미 존재, "UC0005":오류
				resultMessage	string	
	 */
	public static Map<String,Object> modifyDomain(String mailServerUrl, Map<String,Object> params) {
		String url = mailServerUrl + MAIL_API_MODIFY_DOMAIN_URL;
		return sendApi(url, params);	
	}
	
	/**
	 * 
	 * @param mailServerUrl
	 * @param params
	 * 	            domain	string	이동하고자 하는 회사의 도메인 이름
					domainOld	string	기존에 속한 회사의 도메인 이름
					groupSeq	string	그룹 시퀀스
					compSeq	string	회사 시퀀스
	 * @return
	 */
	public static Map<String,Object> moveCompany(String mailServerUrl, Map<String,Object> params) {
		String url = mailServerUrl + MAIL_API_MOVE_COMPANY_URL;
		return sendApi(url, params);	
	}
	
	/**
	 * 
	 * @param mailServerUrl
	 * @param requestMap
	 *            domain  : 신규 도메인
	 *            groupSeq
	 *            compSeq
	 */
	public static void mailDomainCreate(String mailServerUrl, Map<String,Object> requestMap) {
		Map<String,Object> result = domainCompanyList(mailServerUrl, requestMap);
		boolean isDupl = false;
		if (result == null) {
			List<Map<String,Object>> domainCompList = (List<Map<String, Object>>) result.get("domainCompList");
			
			logger.debug("domainCompList : " + domainCompList);
			
			if (domainCompList != null && domainCompList.size() > 0) {
				for(Map<String,Object> map : domainCompList) {
					if (map.get("domainName") != null) {
						String domainName = map.get("domainName").toString();
						if (domainName.equals(requestMap.get("domain").toString())) {
							isDupl = true;
						}
					}
				}
			}
		}
		
		logger.debug("isDupl : " + isDupl);
		if (!isDupl) { // 중복 없음
			requestMap.put("domainName", requestMap.get("domain"));
			result = createDomain(mailServerUrl, requestMap);  // 메일 도메인 신규 추가
			String code = result.get("code")+"";
			if(code.equals("1") || code.equals("-1")) { // 성공이거나 이미 사용중이면 해당 도메인에 회사 정보 추가
				insertCompany(mailServerUrl, requestMap);
			}
		} else {	// 중복이면 회사만 추가
			insertCompany(mailServerUrl, requestMap);
		}
	}
	
	public static void mailDomainMove(String mailServerUrl, Map<String,Object> requestMap) {
		// 도메인 수정은 변경할 도메인을 생성하고 그 도메인으로 회사를 이동처리한다.
		Map<String,Object> result = domainCompanyList(mailServerUrl, requestMap);
		boolean isDupl = false;
		if (result == null) {
			List<Map<String,Object>> domainCompList = (List<Map<String, Object>>) result.get("domainCompList");
			
			logger.debug("domainCompList : " + domainCompList);
			
			if (domainCompList != null && domainCompList.size() > 0) {
				for(Map<String,Object> map : domainCompList) {
					if (map.get("domainName") != null) {
						String domainName = map.get("domainName").toString();
						logger.debug("domainName : " + domainName);
						if (domainName.equals(requestMap.get("domain").toString())) {
							isDupl = true;
						}
					}
				}
			}
		}
		
		logger.debug("isDupl : " + isDupl);
		
		if (!isDupl) { // 중복 없음
			requestMap.put("domainName", requestMap.get("domain"));
			result = createDomain(mailServerUrl, requestMap);  // 메일 도메인 신규 추가
			String code = result.get("code")+"";
			if(code.equals("1") || code.equals("-1")) { // 성공이거나 이미 사용중이면 해당 도메인에 회사 정보 추가
				moveCompany(mailServerUrl, requestMap);
			}
		} else {	// 중복이면 회사만 추가
			moveCompany(mailServerUrl, requestMap);
		}
		
	}
	
	
	private static Map<String,Object> sendApi(String url, Map<String,Object> params) {
		logger.debug("url : " + url);
		logger.debug("params : " + params);
		try{
			ConnectionHelper connect = ConnectionHelperFactory.createInstacne(url);
			
			
			ObjectMapper mapper = new ObjectMapper();
			String json = mapper.writeValueAsString(params);
			logger.debug("requestJon : " + json);
			String resultJson = connect.requestData(json);
			logger.debug("resultJson : " + resultJson);
			return mapper.readValue(resultJson, Map.class);
		}catch(Exception e){
			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출	
		}
		
		return null;
		
	}
	
	
	
	//제거되지 않고 남은 디버그 코드
//	public static void main(String[] args) {
////		SendMail smail = new SendMail();
////		try {
////			smail.send("","","","", "title", "content");
////		} catch (UnsupportedEncodingException e) {
////			e.printStackTrace();
////		} catch (MessagingException e) {
////			e.printStackTrace();
////		}
//	}
}
