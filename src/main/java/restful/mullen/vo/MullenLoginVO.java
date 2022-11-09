package restful.mullen.vo;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.xml.bind.annotation.XmlRootElement;
//import javax.xml.bind.annotation.XmlRootElement;

import restful.mobile.vo.GroupInfoVO;

@SuppressWarnings("serial")
@XmlRootElement(name="contents")
public class MullenLoginVO implements Serializable {
	
	/** login param info */
	private String groupSeq    = ""     ;     		 //  그룹순번
	private String loginId       = ""  ;     		 //  로그인 ID
	private String loginPassword  = ""   ;     		 //  로그인 PW
	private String compSeq   = ""  ;     			 //  회사 시퀀스
	private String compName  = ""   ;     			 //  회사 명
	private String bizSeq   = ""  ;     			 //  사업장 시퀀스
	private String bizName   = ""  ;     			 //  사업장명
	private String deptSeq  = ""   ;     			 //  부서 시퀀스
	private String deptName  = ""   ;     			 //  부서명
	private String empSeq  = ""   ;     			 //  사용자 시퀀스
	private String empName  = ""   ;     			 //  사용자 명
	private String buildType = ""  ;				 //  빌드타입(build:구축형, cloud:클라우드)
	private String dutyCode  = ""   ;     			 //  직책 코드
	private String dutyName  = ""   ;     			 //  직책 명
	private String positionCode  = ""   ;     		 //  직급 코드
	private String positionName  = ""   ;     		 //  직급 명
	private String email   = ""  ;     		 		 //  이메일 주소
	private String nativeLangCode  = ""   ; 	     //  주사용 언어 (예 "kr", "en")
	private String password_yn   = ""  ;     		 //  결재 패스워드 사용 여부 ( 0: 사용안함, 1: 사용 )
	private String eaType   = ""  ;     			 //  전자결재 타입( 0: NP, 1: suite )
	private String compDomain   = ""  ;    		 	 //  회사도메인
	private String userSe   = ""  ;     		 	 //  USER, ADMIN, MASTER
	public Map<String,Object> mqttInfo = new HashMap<String, Object>();  	// 대화 브로드캐스트 ip, port 정보
	private GroupInfoVO groupInfo = new GroupInfoVO();				// 그룹 URL 정보
	private String loginCompanyId = "";
	private String loginUserId = "";
	private String appVer = "";
	private String osType = "";
	private String appType = "";
	private String programCd = "";
	private String model = "";
	private String apprPasswd = "";
	private int setupVersionSeq = 0;
	private String orgnztPath = "";
	public List<Map<String,Object>> optionList = new ArrayList<Map<String,Object>>();
	public List<Map<String,Object>> companyList = new ArrayList<Map<String,Object>>();
	private String passwdStatusCode = "";
	private String passwdDate = "";
	public Map<String, Object> passwdStatus = new HashMap<String, Object>();
	
	private String scheme = "" ;			 	 //  스키마정보(http, https)
	private String loginToken = "" ;			 	 //  로그인토큰
	
	//통합댓글 관련 정보
	private String moreYn = "";
	public List<Map<String,Object>> commentList = new ArrayList<Map<String,Object>>();
	private int commentCount = 0;
	public List<Map<String,Object>> empList = new ArrayList<Map<String,Object>>();
	private String useDeviceRegYn = "";								//디바이스 등록 대상 여부
	private String useTwoFactorAuthenticationYn = "";				//웹이차인증 사용여부
	private String useReportAttendTime = "";
	private String useMobileWorkCheck = "";
	private String appConfirmYn = "";
	public Map<String, Object> devRegInfo = new HashMap<String, Object>();
	
	//멀린 관련 정보_20181218
	private String loginIdCode = "";
	private String loginIdEmail = "";
	private String accountRegistYn = "";
	
	
	private String mullenAgreement1 = "";	//이용약관 동의여부(서비스+개인정보처리방침+위치기반서비스)
	private String mullenAgreement2 = "";	//이용약관 동의여부(마케팅 활용약관)
	
	public List<Map<String,Object>> getOptionList() {
		return optionList;
	}
	public void setOptionList(List<Map<String, Object>> optionList) {
		this.optionList = optionList;
	}
	public String getUserSe() {
		return userSe;
	}
	public void setUserSe(String userSe) {
		this.userSe = userSe;
	}
	public String getLoginCompanyId() {
		return loginCompanyId;
	}
	public void setLoginCompanyId(String loginCompanyId) {
		this.loginCompanyId = loginCompanyId;
	}
	public String getBuildType() {
		return buildType;
	}
	public void setBuildType(String buildType) {
		this.buildType = buildType;
	}
	public String getLoginUserId() {
		return loginUserId;
	}
	public void setLoginUserId(String loginUserId) {
		this.loginUserId = loginUserId;
	}
	public String getAppVer() {
		return appVer;
	}
	public void setAppVer(String appVer) {
		this.appVer = appVer;
	}
	public String getOsType() {
		return osType;
	}
	public void setOsType(String osType) {
		this.osType = osType;
	}
	public String getAppType() {
		return appType;
	}
	public void setAppType(String appType) {
		this.appType = appType;
	}
	public String getProgramCd() {
		return programCd;
	}
	public void setProgramCd(String programCd) {
		this.programCd = programCd;
	}
	public String getModel() {
		return model;
	}
	public void setModel(String model) {
		this.model = model;
	}
	/*public GroupInfoVO getGroupInfo() {
		return groupInfo;
	}
	public void setGroupInfo(GroupInfoVO groupInfo) {
		this.groupInfo = groupInfo;
	}*/
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
	public void setCompDomain(String compDomain) {
		this.compDomain = compDomain;
	}
	public String getApprPasswd() {
		return apprPasswd;
	}
	public void setApprPasswd(String apprPasswd) {
		this.apprPasswd = apprPasswd;
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
	
	public List<Map<String,Object>> getCompanyList() {
		return companyList;
	}
	public void setCompanyList(List<Map<String,Object>> companyList) {
		this.companyList = companyList;
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
	
	public void setPasswdDate(String passwdDate) {
		this.passwdDate = passwdDate;
	}
	public String getMoreYn() {
		return moreYn;
	}
	public void setMoreYn(String moreYn) {
		this.moreYn = moreYn;
	}
	public List<Map<String, Object>> getCommentList() {
		return commentList;
	}
	public void setCommentList(List<Map<String, Object>> commentList) {
		this.commentList = commentList;
	}
	public int getCommentCount() {
		return commentCount;
	}
	public void setCommentCount(int commentCount) {
		this.commentCount = commentCount;
	}
	public List<Map<String, Object>> getEmpList() {
		return empList;
	}
	public void setEmpList(List<Map<String, Object>> empList) {
		this.empList = empList;
	}	
	
	public void setScheme(String scheme) {
		this.scheme = scheme;
	}
	
	public String getScheme() {
		return scheme;
	}
	
	public void setLoginToken(String loginToken) {
		this.loginToken = loginToken;
	}
	
	public String getLoginToken() {
		return loginToken;
	}	
	
	public void setUseDeviceRegYn(String useDeviceRegYn){
		this.useDeviceRegYn = useDeviceRegYn;
	}
	
	public String getUseDeviceRegYn(){
		return useDeviceRegYn;
	}
	
	public void setUseTwoFactorAuthenticationYn(String useTwoFactorAuthenticationYn){
		this.useTwoFactorAuthenticationYn = useTwoFactorAuthenticationYn;
	}
	
	public String getUseTwoFactorAuthenticationYn(){
		return useTwoFactorAuthenticationYn;
	}
	
	public void setUseReportAttendTime(String useReportAttendTime){
		this.useReportAttendTime = useReportAttendTime;
	}
	
	public String getUseReportAttendTime(){
		return useReportAttendTime;
	}
	
	public void setUseMobileWorkCheck(String useMobileWorkCheck){
		this.useMobileWorkCheck = useMobileWorkCheck;
	}
	
	public String getUseMobileWorkCheck(){
		return useMobileWorkCheck;
	}
	
	public void setAppConfirmYn(String appConfirmYn){
		this.appConfirmYn = appConfirmYn;
	}
	
	public String getAppConfirmYn(){
		return appConfirmYn;
	}
	
	public void setDevRegInfo(Map<String, Object> devRegInfo){
		this.devRegInfo = devRegInfo;
	}
	
	public Map<String, Object> getDevRegInfo(){
		return devRegInfo;
	}
	public String getLoginIdCode() {
		return loginIdCode;
	}
	public void setLoginIdCode(String loginIdCode) {
		this.loginIdCode = loginIdCode;
	}
	public String getLoginIdEmail() {
		return loginIdEmail;
	}
	public void setLoginIdEmail(String loginIdEmail) {
		this.loginIdEmail = loginIdEmail;
	}
	public String getAccountRegistYn() {
		return accountRegistYn;
	}
	public void setAccountRegistYn(String accountRegistYn) {
		this.accountRegistYn = accountRegistYn;
	}
	public GroupInfoVO getGroupInfo() {
		return groupInfo;
	}
	public void setGroupInfo(GroupInfoVO groupInfo) {
		this.groupInfo = groupInfo;
	}
	public String getMullenAgreement1() {
		return mullenAgreement1;
	}
	public void setMullenAgreement1(String mullenAgreement1) {
		this.mullenAgreement1 = mullenAgreement1;
	}
	public String getMullenAgreement2() {
		return mullenAgreement2;
	}
	public void setMullenAgreement2(String mullenAgreement2) {
		this.mullenAgreement2 = mullenAgreement2;
	}
}
