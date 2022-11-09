package restful.messenger.vo;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.xml.bind.annotation.XmlRootElement;
//import javax.xml.bind.annotation.XmlRootElement;



import restful.mobile.vo.GroupInfoVO;

@XmlRootElement(name="contents")
public class MessengerLoginVO implements Serializable {
	
	/** login param info */
	private String groupSeq    = ""     ;        //  그룹순번
	private String loginId       = ""  ;         //  로그인 ID
	private String loginPassword  = ""   ;       //  로그인 PW

	private String compSeq   = ""  ;     		 //  회사 시퀀스
	private String compName  = ""   ;     		 //  회사 명
	private String bizSeq   = ""  ;     		 //  사업장 시퀀스
	private String bizName   = ""  ;     		 //  사업장명
	private String deptSeq  = ""   ;     		 //  부서 시퀀스
	private String deptName  = ""   ;     		 //  부서명
	private String empSeq  = ""   ;     		 //  사용자 시퀀스
	private String empName  = ""   ;     		 //  사용자 명
	private String dutyCode  = ""   ;     		 //  직책 코드
	private String dutyName  = ""   ;     		 //  직책 명
	private String positionCode  = ""   ;     	 //  직급 코드
	private String positionName  = ""   ;     	 //  직급 명
	private String email   = ""  ;     		 	 //  이메일 주소
	private String buildType = ""  ;				 //  빌드타입(build:구축형, cloud:클라우드)
	private String nativeLangCode  = ""   ;      //  주사용 언어 (예 "kr", "en")
	private String password_yn   = ""  ;     	 //  결재 패스워드 사용 여부 ( 0: 사용안함, 1: 사용 )
	private String eaType   = ""  ;     		 //  전자결재 타입( 0: NP, 1: suite )
	private String compDomain   = ""  ;     	 //  회사도메인
	private String emailDomain   = ""  ;     	 //  메일도메인
	private String goToWorkYn   = ""  ;     	 //  자동출근 가능여부
	private int setupVersionSeq = 0;		 	 //  그룹웨어 버젼시퀀스
	private String orgnztPath   = ""  ;     	 //  부서경로
	private String bdRollingYn = "" ;			 //  게시판 롤업기능 사용유무
	private String scheme = "" ;			 	 //  스키마정보(http, https)
	private String useTwoFactorAuthenticationYn = ""; //웹이차인증 사용여부
	public Map<String,Object> mqttInfo = new HashMap<String, Object>();  	// 대화 브로드캐스트 ip, port 정보
	
	private GroupInfoVO groupInfo = new GroupInfoVO();	// 그룹 URL 정보
	public List<Map<String,Object>> companyList = new ArrayList<Map<String,Object>>();
	public List<Map<String,Object>> alertList = new ArrayList<Map<String,Object>>();
	public List<Map<String,Object>> optionList = new ArrayList<Map<String, Object>>();
	/* 비밀번호 변경 설정 추가 - 장지훈(2017.07.25) */
	private String passwdStatusCode = "";
	public Map<String, Object> passwdStatus = new HashMap<String, Object>();
	private String passwdDate = "";

	public Map<String, Object> qrMap = new HashMap<String, Object>();		//이차인증 사용시 qr코드 데이터.
	
	
	public List<Map<String, Object>> getOptionList() {
		return optionList;
	}
	public void setOptionList(List<Map<String, Object>> optionList) {
		this.optionList = optionList;
	}
	public Map<String, Object> getMqttInfo() {
		return mqttInfo;
	}
	public void setMqttInfo(Map<String, Object> mqttInfo) {
		this.mqttInfo = mqttInfo;
	}
	
	public String getGroupSeq() {
		return groupSeq;
	}
	public void setGroupSeq(String groupSeq) {
		this.groupSeq = groupSeq;
	}
	public String getLoginId() {
		return loginId;
	}
	public void setLoginId(String loginId) {
		this.loginId = loginId;
	}
	public String getLoginPassword() {
		return loginPassword;
	}
	public void setLoginPassword(String loginPassword) {
		this.loginPassword = loginPassword;
	}
	
	public String getBdRollingYn() {
		return bdRollingYn;
	}
	public void setBdRollingYn(String bdRollingYn) {
		this.bdRollingYn = bdRollingYn;
	}	

	public String getCompSeq() {
		return compSeq;
	}
	public void setCompSeq(String compSeq) {
		this.compSeq = compSeq;
	}
	public String getCompName() {
		return compName;
	}
	public void setCompName(String compName) {
		this.compName = compName;
	}
	public String getBizSeq() {
		return bizSeq;
	}
	public void setBizSeq(String bizSeq) {
		this.bizSeq = bizSeq;
	}
	public String getBizName() {
		return bizName;
	}
	public void setBizName(String bizName) {
		this.bizName = bizName;
	}
	public String getDeptSeq() {
		return deptSeq;
	}
	public void setDeptSeq(String deptSeq) {
		this.deptSeq = deptSeq;
	}
	public String getDeptName() {
		return deptName;
	}
	public void setDeptName(String deptName) {
		this.deptName = deptName;
	}
	public String getEmpSeq() {
		return empSeq;
	}
	public void setEmpSeq(String empSeq) {
		this.empSeq = empSeq;
	}
	public String getEmpName() {
		return empName;
	}
	public void setEmpName(String empName) {
		this.empName = empName;
	}
	public String getDutyCode() {
		return dutyCode;
	}
	public void setDutyCode(String dutyCode) {
		this.dutyCode = dutyCode;
	}
	public String getDutyName() {
		return dutyName;
	}
	public void setDutyName(String dutyName) {
		this.dutyName = dutyName;
	}
	public String getPositionCode() {
		return positionCode;
	}
	public void setPositionCode(String positionCode) {
		this.positionCode = positionCode;
	}
	public String getPositionName() {
		return positionName;
	}
	public void setPositionName(String positionName) {
		this.positionName = positionName;
	}
	public String getEmail() {
		return email;
	}
	public void setEmail(String email) {
		this.email = email;
	}
	public String getNativeLangCode() {
		return nativeLangCode;
	}
	public void setNativeLangCode(String nativeLangCode) {
		this.nativeLangCode = nativeLangCode;
	}	

	public String getPassword_yn() {
		return password_yn;
	}
	public void setPassword_yn(String passwordYn) {
		this.password_yn = passwordYn;
	}
	public String getEaType() {
		return eaType;
	}
	public void setEaType(String eaType) {
		this.eaType = eaType;
	}
	public String getCompDomain() {
		return compDomain;
	}
	public void setCompDomai(String compDomain) {
		this.compDomain = compDomain;
	}
	public String getEmailDomain() {
		return emailDomain;
	}
	public void setEmailDomai(String emailDomain) {
		this.emailDomain = emailDomain;
	}		
	
	public List<Map<String,Object>> getCompanyList() {
		return companyList;
	}
	public void setCompanyList(List<Map<String,Object>> companyList) {
		this.companyList = companyList;
	}
	
	public GroupInfoVO getGroupInfo() {
		return groupInfo;
	}
	public void setGroupInfo(GroupInfoVO groupInfo) {
		this.groupInfo = groupInfo;
	}
	
	public List<Map<String,Object>> getAlertList() {
		return alertList;
	}
	public void setAlertList(List<Map<String,Object>> alertList) {
		this.alertList = alertList;
	}
	
	public String getGoToWorkYn() {
		return goToWorkYn;
	}
	public void setGoToWorkYn(String goToWorkYn) {
		this.goToWorkYn = goToWorkYn;
	}		
	
	public int getSetupVersionSeq() {
		return setupVersionSeq;
	}
	
	public void setSetupVersionSeq(int setupVersionSeq) {
		this.setupVersionSeq = setupVersionSeq;
	}	
	
	public String getOrgnztPath() {
		return orgnztPath;
	}
	
	public void setOrgnztPath(String orgnztPath) {
		this.orgnztPath = orgnztPath;
	}
	
	public String getPasswdStatusCode() {
		return passwdStatusCode;
	}
	
	public void setPasswdStatusCode(String passwdStatusCode) {
		this.passwdStatusCode = passwdStatusCode;
	}	
	
	public Map<String, Object> getPasswdStatus() {
		return passwdStatus;
	}
	
	public void setPasswdStatus(Map<String, Object> passwdStatus) {
		this.passwdStatus = passwdStatus;
	}	
	
	public String getPasswdDate() {
		return passwdDate;
	}
	
	public void setpasswdDate(String passwdDate) {
		this.passwdDate = passwdDate;
	}
	
	public String getBuildType() {
		return buildType;
	}
	
	public void setBuildType(String buildType) {
		this.buildType = buildType;
	}
	
	public void setScheme(String scheme) {
		this.scheme = scheme;
	}
	
	
	public String getScheme() {
		return scheme;
	}
	
	
	public void setUseTwoFactorAuthenticationYn(String useTwoFactorAuthenticationYn) {
		this.useTwoFactorAuthenticationYn = useTwoFactorAuthenticationYn;
	}
	
	
	public String getUseTwoFactorAuthenticationYn() {
		return useTwoFactorAuthenticationYn;
	}
	
	
	public void setQrMap(Map<String, Object> qrMap) {
		this.qrMap = qrMap;
	}
	
	
	public Map<String, Object> getQrMap() {
		return qrMap;
	}
}

