package api.comment.vo;

import java.io.Serializable;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.xml.bind.annotation.XmlRootElement;
//import javax.xml.bind.annotation.XmlRootElement;

@XmlRootElement(name="contents")
public class CommentVO implements Serializable {
	
	/** comment param info */
	private String groupSeq    = ""     ;        //  그룹순번

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
	private String commentSeq = "" ;			// 댓글 시퀀스
	private String sortCommentSeq = "" ;		// 정렬댓글 시퀀스
	private String moduleGbnCode = "" ;			// 모듈구분코드
	private String moduleSeq	= "" ;			// 모듈시퀀스
	private String parentCommentSeq	= "" ;		// 상위 댓글 시퀀스
	private String contents			= "" ;		// 댓글 내용
	private String commentType		= "" ;		// 댓글 구분
	private String highGbnCode		= "" ; 		// 대분류 코드
	private String middleGbnCode	= "" ;		// 중분류 코드
	private String commentPassword	= "" ;		// 댓글비밀번호
	private String positionCode		= "" ; 		// 직급 코드
	private String positionName		= "" ;		// 직급명
	private int	notifiedCnt			= 0 ;		// 공시횟수
	private int	recommCnt			= 0 ;		// 추천횟수
	private int declareCnt			= 0 ;		// 신고횟수
	private String createIp			= "" ;		// 등록자 IP
	private String createSeq		= "" ;		// 등록자 시퀀스
	private String createName		= "" ; 		// 등록자명(등록자 닉네임)
	private String createDate		= "" ; 		// 등록일시
	private String modifySeq		= "" ;		// 수정자 시퀀스
	private String modifyDate		= "" ;		// 수정일시
	private String langCode			= "" ;		// 언어코드
	private int pageSize			= 0 ;		// 페이지 사이즈
	private int pageNum				= 0 ;		// 조회기준 넘버
	public List<String> deptList;				// 부서리스트
	public List<String> empList;				// 사용자리스트
	private String searchEmpSeq		= "" ;		// 조회 사용자 시퀀스
	private String fileId			= "" ;		// 파일아이디
	
	private String topLevelCommentSeq = "" ;	// 최상위 댓글 시퀀스
	private int depth				= 0 ;		// 댓글 깊이
	private String sort				= "";		//정렬방식
	private String searchWay		= ""; 		//조회 방향
	private String reqSubType		= "";		//조회 기준 댓글 포함여부
	private String viweYn			= ""; 		//조회 여부
	private String useYn			= ""; 		//사용 여부
	private String adminYn			= "N"; 		//관리자 여부
	
	public Map<String,Object> event = new HashMap<String,Object>();  //알림정보
	
	
	private String orgnztPath   = ""  ;     	 //  부서경로

	public String getGroupSeq() {
		return groupSeq;
	}

	public void setGroupSeq(String groupSeq) {
		this.groupSeq = groupSeq;
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

	public String getSortCommentSeq() {
		return sortCommentSeq;
	}

	public void setSortCommentSeq(String sortCommentSeq) {
		this.sortCommentSeq = sortCommentSeq;
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

	public String getCommentSeq() {
		return commentSeq;
	}

	public void setCommentSeq(String commentSeq) {
		this.commentSeq = commentSeq;
	}

	public String getModuleGbnCode() {
		return moduleGbnCode;
	}

	public void setModuleGbnCode(String moduleGbnCode) {
		this.moduleGbnCode = moduleGbnCode;
	}

	public String getModuleSeq() {
		return moduleSeq;
	}

	public int getPageNum() {
		return pageNum;
	}

	public void setPageNum(int pageNum) {
		this.pageNum = pageNum;
	}

	public void setModuleSeq(String moduleSeq) {
		this.moduleSeq = moduleSeq;
	}

	public String getParentCommentSeq() {
		return parentCommentSeq;
	}

	public void setParentCommentSeq(String parentCommentSeq) {
		this.parentCommentSeq = parentCommentSeq;
	}

	public String getContents() {
		return contents;
	}

	public void setContents(String contents) {
		this.contents = contents;
	}

	public String getCommentType() {
		return commentType;
	}

	public void setCommentType(String commentType) {
		this.commentType = commentType;
	}

	public String getHighGbnCode() {
		return highGbnCode;
	}

	public void setHighGbnCode(String highGbnCode) {
		this.highGbnCode = highGbnCode;
	}

	public String getMiddleGbnCode() {
		return middleGbnCode;
	}

	public void setMiddleGbnCode(String middleGbnCode) {
		this.middleGbnCode = middleGbnCode;
	}

	public String getCommentPassword() {
		return commentPassword;
	}

	public void setCommentPassword(String commentPassword) {
		this.commentPassword = commentPassword;
	}

	public int getNotifiedCnt() {
		return notifiedCnt;
	}

	public void setNotifiedCnt(int notifiedCnt) {
		this.notifiedCnt = notifiedCnt;
	}

	public int getRecommCnt() {
		return recommCnt;
	}

	public void setRecommCnt(int recommCnt) {
		this.recommCnt = recommCnt;
	}

	public int getDeclareCnt() {
		return declareCnt;
	}

	public void setDeclareCnt(int declareCnt) {
		this.declareCnt = declareCnt;
	}

	public String getCreateIp() {
		return createIp;
	}

	public void setCreateIp(String createIp) {
		this.createIp = createIp;
	}

	public String getCreateSeq() {
		return createSeq;
	}

	public void setCreateSeq(String createSeq) {
		this.createSeq = createSeq;
	}

	public String getCreateName() {
		return createName;
	}

	public void setCreateName(String createName) {
		this.createName = createName;
	}

	public String getCreateDate() {
		return createDate;
	}

	public void setCreateDate(String createDate) {
		this.createDate = createDate;
	}

	public String getModifySeq() {
		return modifySeq;
	}

	public void setModifySeq(String modifySeq) {
		this.modifySeq = modifySeq;
	}

	public String getModifyDate() {
		return modifyDate;
	}

	public void setModifyDate(String modifyDate) {
		this.modifyDate = modifyDate;
	}

	public String getLangCode() {
		return langCode;
	}

	public void setLangCode(String langCode) {
		this.langCode = langCode;
	}

	public String getOrgnztPath() {
		return orgnztPath;
	}

	public void setOrgnztPath(String orgnztPath) {
		this.orgnztPath = orgnztPath;
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

	public int getPageSize() {
		return pageSize;
	}

	public void setPageSize(int pageSize) {
		this.pageSize = pageSize;
	}

	public List<String> getDeptList() {
		return deptList;
	}

	public void setDeptList(List<String> deptList) {
		this.deptList = deptList;
	}

	public List<String> getEmpList() {
		return empList;
	}

	public void setEmpList(List<String> empList) {
		this.empList = empList;
	}

	public String getSearchEmpSeq() {
		return searchEmpSeq;
	}

	public void setSearchEmpSeq(String searchEmpSeq) {
		this.searchEmpSeq = searchEmpSeq;
	}

	public String getFileId() {
		return fileId;
	}

	public void setFileId(String fileId) {
		this.fileId = fileId;
	}


	public int getDepth() {
		return depth;
	}

	public void setDepth(int depth) {
		this.depth = depth;
	}

	public String getTopLevelCommentSeq() {
		return topLevelCommentSeq;
	}

	public void setTopLevelCommentSeq(String topLevelCommentSeq) {
		this.topLevelCommentSeq = topLevelCommentSeq;
	}

	public String getSort() {
		return sort;
	}

	public void setSort(String sort) {
		this.sort = sort;
	}

	public String getSearchWay() {
		return searchWay;
	}

	public void setSearchWay(String searchWay) {
		this.searchWay = searchWay;
	}

	public String getReqSubType() {
		return reqSubType;
	}

	public void setReqSubType(String reqSubType) {
		this.reqSubType = reqSubType;
	}

	public String getViweYn() {
		return viweYn;
	}

	public void setViweYn(String viweYn) {
		this.viweYn = viweYn;
	}

	public String getUseYn() {
		return useYn;
	}

	public void setUseYn(String useYn) {
		this.useYn = useYn;
	}
	
	public String getAdminYn() {
		return adminYn;
	}

	public void setAdminYn(String adminYn) {
		this.adminYn = adminYn;
	}	

	public Map<String, Object> getEvent() {
		return event;
	}

	public void setEvent(Map<String, Object> event) {
		this.event = event;
	}

	
}
