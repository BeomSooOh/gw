package neos.migration.suite.vo;

import java.util.List;

public class SuiteBaseInfoVO {
	
	private String grpCd				= "";	// 고객코드
	private int grpId;							// 고객ID
	private String grpNm				= "";	// 그룹  명
	private String buildType			= "";	// 구축 종류
	private String dbIp					= "";	// DB서버 아이피
	private String dbUserId				= "";	// DB 유저
	private String dbPassword			= "";	// DB 비밀번호
	private String dbName				= "";	// DB 명
	private String fileIp				= "";	// 파일서버 아이피
	private String fileUserId			= "";	// 파일 유저
	private String filePassword			= "";	// 파일 비밀번호
	private String domain				= "";	// 도메인
	private String recordDocCnt         = "0";   // docId 값을 천개씩 끊기위한 값
	private String suiteMenuId          = "";	// 스위트 문서함 아이디
	private String docIdList		    = null;   // 전자결재 문서 아이디 리스트
	private boolean checkRestartMig     = false;  // 마이그레이션 끊겨서 재시작 여부 값
	
	public String getGrpCd() {
		return grpCd;
	}
	public void setGrpCd(String grpCd) {
		this.grpCd = grpCd;
	}
	public int getGrpId() {
		return grpId;
	}
	public void setGrpId(int grpId) {
		this.grpId = grpId;
	}
	public String getGrpNm() {
		return grpNm;
	}
	public void setGrpNm(String grpNm) {
		this.grpNm = grpNm;
	}
	public String getBuildType() {
		return buildType;
	}
	public void setBuildType(String buildType) {
		this.buildType = buildType;
	}
	public String getDbIp() {
		return dbIp;
	}
	public void setDbIp(String dbIp) {
		this.dbIp = dbIp;
	}
	public String getDbUserId() {
		return dbUserId;
	}
	public void setDbUserId(String dbUserId) {
		this.dbUserId = dbUserId;
	}
	public String getDbPassword() {
		return dbPassword;
	}
	public void setDbPassword(String dbPassword) {
		this.dbPassword = dbPassword;
	}
	public String getDbName() {
		return dbName;
	}
	public void setDbName(String dbName) {
		this.dbName = dbName;
	}
	public String getFileIp() {
		return fileIp;
	}
	public void setFileIp(String fileIp) {
		this.fileIp = fileIp;
	}
	public String getFileUserId() {
		return fileUserId;
	}
	public void setFileUserId(String fileUserId) {
		this.fileUserId = fileUserId;
	}
	public String getFilePassword() {
		return filePassword;
	}
	public void setFilePassword(String filePassword) {
		this.filePassword = filePassword;
	}
	
	@Override
	public String toString() {
		return "SuiteBaseInfoVO [grpCd=" + grpCd + ", grpId=" + grpId + ", grpNm=" + grpNm + ", buildType="
				+ buildType + ", dbIp=" + dbIp + ", dbUserId=" + dbUserId + ", dbPassword=" + dbPassword + ", dbName="
				+ dbName + ", fileIp=" + fileIp + ", fileUserId=" + fileUserId + ", filePassword=" + filePassword + "]";
	}
	public String getDomain() {
		return domain;
	}
	public void setDomain(String domain) {
		this.domain = domain;
	}
	
	public String getRecordDocCnt() {
		return recordDocCnt;
	}
	public void setRecordDocCnt(String recordDocCnt) {
		this.recordDocCnt = recordDocCnt;
	}
	public String getSuiteMenuId() {
		return suiteMenuId;
	}
	public void setSuiteMenuId(String suiteMenuId) {
		this.suiteMenuId = suiteMenuId;
	}
	public String getDocIdList() {
		return docIdList;
	}
	public void setDocIdList(String docIdList) {
		this.docIdList = docIdList;
	}
	public boolean isCheckRestartMig() {
		return checkRestartMig;
	}
	public void setCheckRestartMig(boolean checkRestartMig) {
		this.checkRestartMig = checkRestartMig;
	}


	
	
	

}
