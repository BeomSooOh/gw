package restful.mullen.service.impl;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Properties;
import java.util.UUID;

import javax.annotation.Resource;
import javax.mail.internet.MimeMessage;

import org.apache.commons.lang3.StringUtils;
import org.apache.log4j.Logger;
import org.springframework.core.io.FileSystemResource;
import org.springframework.mail.javamail.JavaMailSenderImpl;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.stereotype.Service;

import api.common.model.APIResponse;
import api.common.service.EventService;
import bizbox.orgchart.service.vo.LoginVO;
import egovframework.com.uat.uia.service.EgovLoginService;
import main.web.BizboxAMessage;
import neos.cmm.db.CommonSqlDAO;
import neos.cmm.util.BizboxAProperties;
import net.sf.json.JSONObject;
import restful.mobile.vo.ResultVO;
import restful.mullen.constants.ConstantBiz;
import restful.mullen.dao.MullenDAO;
import restful.mullen.service.MullenService;
import restful.mullen.util.MullenUtil;
import restful.mullen.vo.MullenAuthStatus;
import restful.mullen.vo.MullenLoginVO;
import restful.mullen.vo.MullenUser;


@Service("MullenService")
public class MullenServiceImpl implements MullenService{
	
	private Logger logger = Logger.getLogger(MullenServiceImpl.class);
	
	@Resource(name = "MullenDAO")
	MullenDAO mullenDAO;
	
	@Resource(name = "commonSql")
	private CommonSqlDAO commonSql;
	
	@Resource(name = "loginService")
    private EgovLoginService loginService;
	
	@Resource(name="MullenMailSender")
	private JavaMailSenderImpl mailSender;
	
	@Resource(name="EventService")
	EventService eventService;
	
	@Override
	public List<MullenLoginVO> actionLoginMobile(MullenLoginVO param) throws Exception {
		return mullenDAO.actionLoginMobile(param);
	}
	
	@Override
	public String selectLoginPassword(MullenLoginVO param) throws Exception {
    	return mullenDAO.selectLoginPassword(param);
    }
	
	public List<Map<String,Object>> selectLoginVO(MullenLoginVO param) throws Exception{
		return mullenDAO.selectLoginVO(param);
	}
	
	@Override
	public int modifyUserName(HashMap<String, Object> params) throws Exception{
		return mullenDAO.updateUserName(params);
	}
	/*
	1. 이메일 DB등록 (T_CO_EMP [out_mail, out_domain]
    2. 인증메일 템플릿 생성 
	3. 인증메일 전송
	*/
	@Override
	public boolean processSendAuthEmail(HashMap<String, Object> params) throws Exception{
		
		//t_co_emp 테이블에 out_mail, out_domain 등록전에 t_co_mullen에 해당 메일의 400 상태가 있는지 체크후 존재시 리턴 false ,
		MullenUser mullenUser = getEmpSeqByEmailAddr(params);
		if(mullenUser != null && !StringUtils.isEmpty(mullenUser.getEmpSeq())) {
			return false;
		}
		//이메일인증키 생성
		String authKey = UUID.randomUUID( ).toString( ).replace( "-", "" );
		params.put("authKey", authKey);
		//이메일인증대기상태 변경
		params.put("authStatus", ConstantBiz.MULLEN_AUTH_STATUS_200);
		if(mullenDAO.updateMullenStatus(params) > 0) {
			//이메일 DB 등록 (t_co_emp)
			
			//해당메일은 존재하지만 400상태가 아니라면 해당 메일 가진 이전 계정에서 삭제 처리(t_co_mullen테이블의 email_addr, status = 100 과 t_co_emp 테이블의 out_mail, out_domain 삭제).
			mullenDAO.updateUserOutMailEmpty(params);
			mullenDAO.updateMullenEmailAddrEmpty(params);
			
			mullenDAO.updateUserOutMail(params);
			//인증메일 템플릿 생성
			String resourcePath = (String) params.get("resourcePath");
			String username = BizboxAProperties.getProperty("BizboxA.mullen.smtp.id");
			String password = BizboxAProperties.getProperty("BizboxA.mullen.smtp.password");
			String hostName = BizboxAProperties.getProperty("BizboxA.mullen.smtp.host");
			int port = Integer.parseInt(BizboxAProperties.getProperty("BizboxA.mullen.smtp.port"));
			String adminFrom = BizboxAProperties.getProperty("BizboxA.mullen.smtp.adminFrom");
			String charset = BizboxAProperties.getProperty("BizboxA.mullen.smtp.charset");
			mailSender.setHost(hostName);
			mailSender.setPort(port);
			//로컬 테스트용 설정(daum메일)
			Properties javaMailProperties = new Properties();
			javaMailProperties.put("mail.transport.protocol", "smtp");
			javaMailProperties.put("mail.smtp.auth", "true");
			javaMailProperties.put("mail.smtp.starttls.enable", "true");
			javaMailProperties.put("mail.smtps.ssl.checkserveridentity", "true");
			javaMailProperties.put("mail.smtps.ssl.trust", "*");
			javaMailProperties.put("mail.smtp.socketFactory.class", "javax.net.ssl.SSLSocketFactory");
			mailSender.setJavaMailProperties(javaMailProperties);
			mailSender.setUsername(username);
			mailSender.setPassword(password);
			
			mailSender.setDefaultEncoding(charset);
			MimeMessage mimeMessage = mailSender.createMimeMessage();
			MimeMessageHelper messageHelper = new MimeMessageHelper(mimeMessage, true, "UTF-8");
			messageHelper.setFrom(adminFrom, BizboxAMessage.getMessage("TX000006242","시스템관리자"));
			messageHelper.setTo((String)params.get("emailAddr"));
			messageHelper.setSubject(getSubject());
			
			String template = getTemplate(params);
			
			messageHelper.setText(template, true);
			
			logger.debug("MullenController /sendAuthEmail getTemplate: " + template);
			
			//메일에 포함될 이미지
			File imageFile = new File(resourcePath + ConstantBiz.MULLEN_SEND_AUTH_EMAIL_IMG_PATH);
			boolean isExists = imageFile.exists();
			
			FileSystemResource res = new FileSystemResource(imageFile);
			
			logger.debug( "MullenController /sendAuthEmail MullenServiceImpl resourcePath: " + resourcePath);
			logger.debug( "MullenController /sendAuthEmail MullenServiceImpl filePath: " + imageFile.getAbsolutePath() + "(isExists=" + isExists + ")");
			
			messageHelper.addInline("identifier1", res);
			
			mailSender.send(mimeMessage);
			
			return true;
		}else {
			return false;
		}
		
	}
	//메일제목 반환
	private String getSubject() {
		return ConstantBiz.MULLEN_SEND_AUTH_EMAIL_TITLE;
	}
	//템플릿 반환
	private String getTemplate(HashMap<String, Object> params) {
		String groupSeq = (String) params.get("groupSeq");
		String empSeq = (String) params.get("empSeq");
		String authKey = (String) params.get("authKey");
		String mailRelayUrl = BizboxAProperties.getProperty("BizboxA.mullen.mail.relay.url");
		//String mailRelayUrl = "http://localhost:8080/gw/restful/mullen/confirmAuthEmail";
		//모바일 게이트웨이 Addr
		String requestUrl = mailRelayUrl + "?groupSeq=" + groupSeq  + "&loginIdCode=" + empSeq + "&emailAddr=" + authKey;
		return "<!doctype html>\r\n" + 
				"<html lang=\"kor\">\r\n" + 
				"<head>\r\n" + 
				"	<meta charset=\"UTF-8\">\r\n" + 
				"	<meta name=\"viewport\" content=\"user-scalable=no, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, width=device-width\" />\r\n" + 
				"	<title>Mullen</title>\r\n" + 
				"</head>\r\n" + 
				"<body>\r\n" + 
				"<div style=\"margin:0;padding:0;background:#fff;text-align: center;font-family:'돋움',Dotum,'굴림',Gulim,sans-serif;overflow: hidden;\">\r\n" + 
				"	<div style=\"margin:0;padding:0;text-align: center;margin-top:56px;\">\r\n" + 
				"	<img src=\"cid:identifier1\" alt=\"\" style=\"vertical-align:top;\" width=\"220\" height=\"165\"/>\r\n" + 
				"	</div>\r\n" + 
				"\r\n" + 
				" <p style=\"font-size:22px;margin:44px 0 0 0;text-align:center;line-height:1;letter-spacing:-1px;font-weight:bold;\">본인 확인 인증 안내</p>\r\n" + 
				" <p style=\"font-size:13px;margin:19px 0 0 0;text-align:center;line-height:19px;letter-spacing:-0.3px;\">안녕하세요. 스마트한 멀티캘린더 Mullen입니다. <br/>\r\n" + 
				"본 메일은 계정등록을 위한 인증메일입니다. <br/>\r\n" + 
				"아래 <span style=\"color:#339cff;font-weight:bold;\">[인증하기]</span> 버튼을 통해 본인 확인이 완료됩니다.</p>\r\n" + 
				"\r\n" + 
				"<a href=\""+ requestUrl +"\" style=\"height:38px;line-height:38px;text-decoration:none;padding:0 85px;border-radius:19px;color:#fff;background:#339cff;margin-top:31px;border:none;outline:0;display:inline-block;\">인증하기</a>\r\n" + 
				"</div>\r\n" + 
				"</body>\r\n" + 
				"</html>";
	}

	@Override
	public MullenAuthStatus getAuthStatus(HashMap<String, Object> params) throws Exception{
		
		return mullenDAO.selectAuthStatus(params);
	}

	@Override
	public boolean processConfirmAuthEmail(HashMap<String, Object> params) throws Exception{
		
		//사용자 및 Email 인증키 체크
		//MullenUser mullenUser = mullenDAO.selectEmailUser(params);
		MullenUser mullenUser = mullenDAO.selectEmailAuthKey(params);
		
		//이메일 인증 완료 처리
		if(mullenUser != null){
			/*params.put("prevStatus", ConstantBiz.MULLEN_AUTH_STATUS_200);*/
			params.put("authStatus", ConstantBiz.MULLEN_AUTH_STATUS_300);
			params.put("notAuthStatus", ConstantBiz.MULLEN_AUTH_STATUS_400);
			
			if(mullenDAO.updateAuthComplete(params) > 0) {
				return true;
			}else {
				return false;
			}
		}else {
			return false;
		}
	}

	@Override
	public boolean processRegistAccount(HashMap<String, Object> params, ResultVO response) throws Exception{
		
		//사용자 및 Email 체크
		MullenUser mullenUser = mullenDAO.selectEmailUser(params);
		
		logger.debug( "MullenController /processRegistAccount MullenServiceImpl mullenUser.emailAddr: " + (String)params.get("emailAddr"));
		logger.debug( "MullenController /processRegistAccount MullenServiceImpl params.emailAddr: " + (String)params.get("emailAddr"));
		
		if(mullenUser != null && mullenUser.getEmailAddr().equals((String)params.get("emailAddr"))){
			//0. 인증완료된 이메일 확인
			params.put("prevStatus", ConstantBiz.MULLEN_AUTH_STATUS_300);
			params.put("authStatus", ConstantBiz.MULLEN_AUTH_STATUS_400);
			if(mullenDAO.updateAuthComplete(params) > 0) {
				//1. 사용자명 변경
				modifyUserName(params);
				//2. 패스워드변경
				String password = (String)params.get("password");
				LoginVO loginVO = new LoginVO();
				loginVO.setId((String)params.get("loginIdCode"));
				loginVO.setPassword(password);
				loginService.updatePasswordMy(loginVO, "def");
			}else {
				response.setResultCode(ConstantBiz.API_RESPONSE_FAIL);
				response.setResultMessage(BizboxAMessage.getMessage("TX800000149","인증 완료된 이메일이 아니거나 계정등록 완료 된 이메일 입니다."));
				return false;
			}
		}else {
			response.setResultCode(ConstantBiz.API_RESPONSE_FAIL);
			response.setResultMessage(BizboxAMessage.getMessage("TX800000150","사용자 정보와 이메일 일치 하지 않습니다."));
			return false;
		}
		
		return true;
	}

	@Override
	public MullenUser getEmpSeqByEmailAddr(HashMap<String, Object> params) throws Exception {
		return mullenDAO.selectEmpSeqByEmailUser(params);
	}
	
	//마이그룹 등록 호출
	//param : groupSeq, empSeq
	//return myGroupId
	private String callMyGroupInsert(String groupSeq, String empSeq) {

		HashMap<String, Object> params = new HashMap<>();
		params.put("groupSeq", groupSeq);
		
		Map<String, Object> groupInfo = (Map<String, Object>) commonSql.select("GroupManage.getGroupInfo", params);
		
		String sUrl = (String)groupInfo.get("messengerUrl") + ConstantBiz.MESSENGER_MOBILE_API_URL + ConstantBiz.MESSENGER_MOBILE_API_URL_MY_GROUP_INSERT;
		
		JSONObject obj = new JSONObject();
		JSONObject header = new JSONObject();
		header.put("groupSeq", groupSeq);
		header.put("empSeq", empSeq);
		JSONObject body = new JSONObject();
		body.put("myGroupName", empSeq);
		obj.put("header", header);
		obj.put("body", body);
		
		//마이그룹 등록 진행
		JSONObject mygroupResult = MullenUtil.getPostJSON(sUrl, obj.toString());
		
		if(mygroupResult != null) {
			JSONObject result = (JSONObject) mygroupResult.get("result");
			return (String) result.get("myGroupId");
		}
		
		return "MY_GROUP_INSERT_ERROR";
	}

	@Override
	public void processModifyMyGroupId(HashMap<String, Object> params) {
		
		List<MullenUser> mullenUserList = mullenDAO.selectEmpSeqByGroupSeq(params);
		
		String groupSeq = (String) params.get("groupSeq");
		
		for(int i=0;i<mullenUserList.size();i++) {
			String empSeq = mullenUserList.get(i).getEmpSeq();
			
			String myGroupId = callMyGroupInsert(groupSeq, empSeq);
			
			HashMap<String, Object> queryParam = new HashMap<>();
			queryParam.put("groupSeq", groupSeq);
			queryParam.put("empSeq", empSeq);
			queryParam.put("myGroupId", myGroupId);
			
			/*
			if(mullenDAO.updateMyGroupId(queryParam) > 0) {
				
			}else {
				System.out.println("myGroupId allocate FAIL :" + empSeq + ":" + myGroupId);
			}
			*/
			mullenDAO.updateMyGroupId(queryParam);
		}
	}
	
	@Override
	public String processAddEmp(HashMap<String, Object> params) {

		//필수 파라메터 체크
		if(!validateForAddEmpOrDelEmp(params)) {
			return ConstantBiz.MULLEN_COMMON_ERROR_COM700;
		}
		
		String groupSeq = (String) params.get("groupSeq");
		String empSeq = (String) params.get("empSeq");
		
		//t_co_emp
		mullenDAO.insertAddEmpForEmp(params);
		//t_co_emp_multi
		mullenDAO.insertAddEmpForEmpMulti(params);
		//t_co_emp_dept
		mullenDAO.insertAddEmpForEmpDept(params);
		//t_co_emp_dept_multi
		mullenDAO.insertAddEmpForEmpDeptMulti(params);
		//t_co_emp_comp
		mullenDAO.insertAddEmpForEmpComp(params);
		//t_co_auth_relate
		mullenDAO.insertAddEmpForAuthRelate(params);
		//t_sc_mcalendar
		int mcalSeqCount = mullenDAO.selectMcalSeqCount();
		params.put("mcalSeq", String.valueOf(mcalSeqCount + 1));
		mullenDAO.insertAddEmpForMcalendar(params);
		//t_sc_mcal_user (user_type = 30, 90 두개 row insert)
		params.put("userType", "30");
		mullenDAO.insertAddEmpForMcalUser(params);
		params.put("userType", "90");
		mullenDAO.insertAddEmpForMcalUser(params);
		//t_sc_mcal_emp_style
		mullenDAO.insertAddEmpForMcalEmpStyle(params);
		//t_co_mullen
		String myGroupId = callMyGroupInsert(groupSeq, empSeq);//마이그룹 등록
		params.put("myGroupId", myGroupId);
		mullenDAO.insertAddEmpForMullen(params);
		
		return ConstantBiz.API_RESPONSE_SUCCESS;
	}
	
	//입사처리/삭제처리 필수 파라메터 체크
	private boolean validateForAddEmpOrDelEmp(HashMap<String, Object> params) {
		if(params.get("groupSeq") == null || StringUtils.isBlank((String)params.get("groupSeq"))) {
			return false;
		}
		if(params.get("empSeq") == null || StringUtils.isBlank((String)params.get("empSeq"))) {
			return false;
		}
		return true;
	}
	
	@Override
	public String processAddBulkEmp(HashMap<String, Object> params) {
		//필수 파라메터 체크
		if(!validateForAddBulkEmpOrDelBulkEmp(params)) {
			return ConstantBiz.MULLEN_COMMON_ERROR_COM700;
		}
		
		String groupSeq = (String) params.get("groupSeq");
		String filePath = (String) params.get("filePath");
		
		ArrayList<String> empSeqList = new ArrayList<>();
	
		//파일로 부터 읽어서 empSeqList에 add
		String result = fileToEmpSeqList(filePath, empSeqList);
		
		//실패이면 에러코드 전달
		if(!ConstantBiz.API_RESPONSE_SUCCESS.equals(result)) {
			return result;
		}
		
		//processAddEmp 호출
		for(int i=0;i<empSeqList.size();i++) {
			String empSeq = empSeqList.get(i);
			HashMap<String, Object> addEmpParams = new HashMap<>();
			addEmpParams.put("groupSeq", groupSeq);
			addEmpParams.put("empSeq", empSeq);
			//1명 입사처리 성공여부
			String resultCodeForAddEmp = processAddEmp(addEmpParams);
			//실패시 실패한 empSeq 리턴 후 바로 종료 ---> 바로 원인추적해라.
			if(!ConstantBiz.API_RESPONSE_SUCCESS.equals(resultCodeForAddEmp)) {
				return ConstantBiz.API_RESPONSE_FAIL + ":" + resultCodeForAddEmp + ":" + empSeq;
			}
		}
		
		return ConstantBiz.API_RESPONSE_SUCCESS;
	}
	//파일로 부터 읽어서 empSeqList에 add
	private String fileToEmpSeqList(String filePath, ArrayList<String> empSeqList) {
		//파일 읽어서 empSeqList에 입력
		try{
            //파일 객체 생성
            File file = new File(filePath);
            //입력 스트림 생성
            FileReader filereader = new FileReader(file);
            //입력 버퍼 생성
            BufferedReader bufReader = new BufferedReader(filereader);
            String line = "";
            while((line = bufReader.readLine()) != null){
                empSeqList.add(line.trim());
            }
            //.readLine()은 끝에 개행문자를 읽지 않는다.            
            bufReader.close();
        }catch (FileNotFoundException e) {
            return ConstantBiz.API_RESPONSE_FAIL + ":FileNotFoundException";
        }catch(IOException e){
        	return ConstantBiz.API_RESPONSE_FAIL + ":IOException";
        }
		return ConstantBiz.API_RESPONSE_SUCCESS;
	}

	//대량입사처리 필수 파라메터 체크
	private boolean validateForAddBulkEmpOrDelBulkEmp(HashMap<String, Object> params) {
		if(params.get("groupSeq") == null || StringUtils.isBlank((String)params.get("groupSeq"))) {
			return false;
		}
		if(params.get("filePath") == null || StringUtils.isBlank((String)params.get("filePath"))) {
			return false;
		}
		return true;
	}
	@Override
	public String processDelEmp(HashMap<String, Object> params) {

		//필수 파라메터 체크
		if(!validateForAddEmpOrDelEmp(params)) {
			return ConstantBiz.MULLEN_COMMON_ERROR_COM700;
		}
		
		//사용자 정보 조회
		HashMap<String, String> empSeqInfo = mullenDAO.selectMemberInfo(params);
		
		if(empSeqInfo == null) {
			return "NOT_EXISTS_EMP_INFO";
		}
		
		//해당 마이그룹 삭제
		JSONObject obj = new JSONObject();
		JSONObject header = new JSONObject();
		JSONObject body = new JSONObject();
		ArrayList<HashMap<String, Object>> delList = new ArrayList<>();
		HashMap<String, Object> del = new HashMap<>();
		header.put("groupSeq", empSeqInfo.get("group_seq"));
		header.put("empSeq", empSeqInfo.get("emp_seq"));
		del.put("myGroupId", empSeqInfo.get("my_group_id"));
		delList.add(del);
		body.put("delList", delList);
		obj.put("header", header);
		obj.put("body", body);
		//Messenger API(마이그룹 삭제) 호출
		MullenUtil.getPostJSON(
				empSeqInfo.get("messenger_url") 
				+ ConstantBiz.MESSENGER_MOBILE_API_URL
				+ ConstantBiz.MESSENGER_MOBILE_API_URL_MY_GROUP_DELETE, obj.toString());
		
		//t_co_mullen
		mullenDAO.deleteDelEmpForMullen(params);
		//t_sc_mcal_emp_style
		mullenDAO.deleteDelEmpForMcalEmpStyle(params);
		//t_sc_mcal_user
		mullenDAO.deleteDelEmpForMcalUser(params);
		//t_sc_mcalendar
		mullenDAO.deleteDelEmpForMcalendar(params);		
		//t_co_auth_relate
		mullenDAO.deleteDelEmpForAuthRelate(params);
		//t_co_emp_comp
		mullenDAO.deleteDelEmpForEmpComp(params);
		//t_co_emp_dept_multi
		mullenDAO.deleteDelEmpForEmpDeptMulti(params);
		//t_co_emp_dept
		mullenDAO.deleteDelEmpForEmpDept(params);
		//t_co_emp_multi
		mullenDAO.deleteDelEmpForEmpMulti(params);
		//t_co_emp
		mullenDAO.deleteDelEmpForEmp(params);
		
		return ConstantBiz.API_RESPONSE_SUCCESS;
	}
	@Override
	public String processDelBulkEmp(HashMap<String, Object> params) {
		//필수 파라메터 체크
		if(!validateForAddBulkEmpOrDelBulkEmp(params)) {
			return ConstantBiz.MULLEN_COMMON_ERROR_COM700;
		}
		
		String groupSeq = (String) params.get("groupSeq");
		String filePath = (String) params.get("filePath");
		
		ArrayList<String> empSeqList = new ArrayList<>();
	
		//파일로 부터 읽어서 empSeqList에 add
		String result = fileToEmpSeqList(filePath, empSeqList);
		
		//실패이면 에러코드 전달
		if(!ConstantBiz.API_RESPONSE_SUCCESS.equals(result)) {
			return result;
		}
		
		//processDelEmp 호출
		for(int i=0;i<empSeqList.size();i++) {
			String empSeq = empSeqList.get(i);
			HashMap<String, Object> delEmpParams = new HashMap<>();
			delEmpParams.put("groupSeq", groupSeq);
			delEmpParams.put("empSeq", empSeq);
			//1명 삭제처리 성공여부
			String resultCodeForDelEmp = processDelEmp(delEmpParams);
			//실패시 실패한 empSeq 리턴 후 바로 종료 ---> 바로 원인추적해라.
			if(!ConstantBiz.API_RESPONSE_SUCCESS.equals(resultCodeForDelEmp)) {
				return ConstantBiz.API_RESPONSE_FAIL + ":" + resultCodeForDelEmp + ":" + empSeq;
			}
		}
		
		return ConstantBiz.API_RESPONSE_SUCCESS;
	}

	@Override
	public boolean processAddUser(HashMap<String, Object> params, ResultVO response) throws Exception {
		//Email 체크
		MullenUser mullenUser = mullenDAO.getUserEmail(params);
		
		logger.debug( "MullenController /processRegistAccount MullenServiceImpl mullenUser.emailAddr: " + (String)params.get("emailAddr"));
		logger.debug( "MullenController /processRegistAccount MullenServiceImpl params.emailAddr: " + (String)params.get("emailAddr"));
		
		if(mullenUser == null){
			//1. 사용자명/메일주소 변경
			mullenDAO.setUserInfo(params);
			//2. 패스워드변경
			String password = (String)params.get("password");
			LoginVO loginVO = new LoginVO();
			loginVO.setId((String)params.get("loginIdCode"));
			loginVO.setPassword(password);
			loginService.updatePasswordMy(loginVO, "def");
		}else {
			response.setResultCode(ConstantBiz.API_RESPONSE_FAIL);
			response.setResultMessage(BizboxAMessage.getMessage("","사용할 수 없는 계정/코드 입니다."));
			return false;
		}
		
		return true;
	}

	@Override
	public boolean validationCheck(HashMap<String, Object> params, ResultVO response) {
		
		String type = (String) params.get("type");
		
		if(type.equals("0")) {
			
			if(!MullenUtil.validateEmailAddr((String)params.get("id"))){
				response.setResultCode(ConstantBiz.API_RESPONSE_FAIL);
				response.setResultMessage(BizboxAMessage.getMessage("TX800000146","이메일 형식이 아닙니다."));
				return false;
			}
			params.put("outMail", params.get("id").toString().split("@")[0]);
			params.put("outDomain", params.get("id").toString().split("@")[1]);
		}
		
		MullenUser result = mullenDAO.validationCheck(params);
		
		if(type.equals("0")) {
			if(result != null) {
				response.setResultCode(ConstantBiz.API_RESPONSE_FAIL);
				response.setResultMessage(BizboxAMessage.getMessage("","사용할 수 없는 계정/코드 입니다."));
				return false;
			}
		}else {
			if(result == null) {
				response.setResultCode(ConstantBiz.API_RESPONSE_FAIL);
				response.setResultMessage(BizboxAMessage.getMessage("","사용할 수 없는 계정/코드 입니다."));
				return false;
			}
		}
		
		return true;
	}

	@Override
	public MullenAuthStatus checkAuthStatus(HashMap<String, Object> params) {
		return mullenDAO.checkAuthStatus(params);
	}

	@Override
	public boolean setMullenGroupInfo(HashMap<String, Object> params, ResultVO response) {
		mullenDAO.setMullenGroupInfo(params);
		return true;
	}

	@Override
	public Object getMullenGroupList(HashMap<String, Object> params) {
		return mullenDAO.getMullenGroupList(params);
	}

	@Override
	public void updateMobileTelNum(HashMap<String, Object> params) {
		mullenDAO.updateMobileTelNum(params);
	}

	@Override
	public Object searchMullenUser(HashMap<String, Object> params) {
		return mullenDAO.searchMullenUser(params);
	}

	@Override
	public void reqGroup(HashMap<String, Object> params) {
		mullenDAO.reqGroup(params);
	}

	@Override
	public boolean reqHandling(HashMap<String, Object> params, APIResponse response) {
		
		//요청 수락인 경우 이미 구성원 등록여부 확인
		if(params.get("status").toString().equals(ConstantBiz.MULLEN_GROUP_REQUEST_TYPE_200)) {
			List<Map<String, Object>> list = (List<Map<String, Object>>) mullenDAO.getMullenGroupList(params);
			
			if(list.size() > 1) {
				response.setResultCode(ConstantBiz.API_RESPONSE_FAIL);
				response.setResultMessage(BizboxAMessage.getMessage("","이미 조직구성이 되어있습니다."));
				return false;
			}
		}
		
		mullenDAO.reqHandling(params);
		
		if(params.get("status").toString().equals(ConstantBiz.MULLEN_GROUP_REQUEST_TYPE_200)) {
			mullenDAO.delUserGroup(params);
			params.put("groupId", mullenDAO.getGroupIdBySeq(params));
			mullenDAO.addUserGroup(params);
		}
		
		return true;
	}

	@Override
	public Object reqList(HashMap<String, Object> params, APIResponse response) {
		return mullenDAO.reqList(params);
	}

	@Override
	public void outGroup(HashMap<String, Object> params) {
		mullenDAO.delUserGroup(params);
		mullenDAO.initUserGroup(params);
		
	}

	@Override
	public Object getGroupId(HashMap<String, Object> params) {
		return mullenDAO.getGroupId(params);
	}

	@Override
	public MullenUser getMullenUserInfoByEmailAddr(HashMap<String, Object> params) {
		return mullenDAO.getMullenUserInfoByEmailAddr(params);
	}

	@Override
	public int deleteUser(HashMap<String, Object> params, ResultVO response) {
		mullenDAO.delUserGroup(params);
		mullenDAO.delUserRelate(params);
		return mullenDAO.deleteUser(params);
	}

	@Override
	public void setMullenAgreeMent(MullenLoginVO restVO) {
		Map<String, Object> params = new HashMap<>();
		params.put("groupSeq", restVO.getGroupSeq());
		params.put("empSeq", restVO.getEmpSeq());
		
		Map<String, Object> result = mullenDAO.getMullenAgreementInfo(params);
		
		restVO.setMullenAgreement1(result.get("agreement1").toString());
		restVO.setMullenAgreement2(result.get("agreement2").toString());
	}

	@Override
	public void setMullenAgreeMent(Map<String, Object> params) {
		for(Map<String, Object> mp : (List<Map<String, Object>>) params.get("agreementInfo")) {
			Map<String, Object> param = new HashMap<>();
			
			param.put("groupSeq", params.get("groupSeq"));
			param.put("empSeq", params.get("empSeq"));
			param.put("kind", mp.get("kind"));
			param.put("agreement_yn", mp.get("agreement_yn"));
			
			mullenDAO.setMullenAgreement(param);
		}
	}
	
}