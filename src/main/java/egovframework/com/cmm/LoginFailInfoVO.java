package egovframework.com.cmm;

import java.io.Serializable;

/**
 * @Class Name : LoginVO.java
 * @Description : Login VO class
 * @Modification Information
 * @
 * @  수정일         수정자                   수정내용
 * @ -------    --------    ---------------------------
 * @ 2009.03.03    박지욱          최초 생성
 *
 *  @author 공통서비스 개발팀 박지욱
 *  @since 2009.03.03
 *  @version 1.0
 *  @see
 *  
 */
public class LoginFailInfoVO implements Serializable{

	/** 사용자 ID */
	private String id;
	/** 로그인 일시 */
	private String createDt;
	/** 오류횟수 */
	private String failCnt;
	/** 접근 금지 여부 */
	private String loginLock;

	/** 경과 시간 차이(분) */
	private String timeGap;
    
	/**
	 * id attribute 값을 리턴한다.
	 * @return id
	 */
	public String getId() {
		return id;
	}
	/**
	 * id attribute 값을 설정한다.
	 * @param id String
	 */
	public void setId(String id) {
		this.id = id;
	}
	/**
	 * createDt attribute 값을 리턴한다.
	 * @return createDt
	 */
	public String getCreateDt() {
		return createDt;
	}
	/**
	 * createDt attribute 값을 설정한다.
	 * @param createDt String
	 */
	public void setCreateDt(String createDt) {
		this.createDt = createDt;
	}
	/**
	 * failCnt attribute 값을 리턴한다.
	 * @return failCnt
	 */
	public String getFailCnt() {
		return failCnt;
	}
	/**
	 * failCnt attribute 값을 설정한다.
	 * @param failCnt String
	 */
	public void setFailCnt(String failCnt) {
		this.failCnt = failCnt;
	}
	/**
	 * loginLock attribute 값을 리턴한다.
	 * @return loginLock
	 */
	public String getLoginLock() {
		return loginLock;
	}
	/**
	 * loginLock attribute 값을 설정한다.
	 * @param loginLock String
	 */
	public void setLoginLock(String loginLock) {
		this.loginLock = loginLock;
	}

	/**
	 * timeGap attribute 값을 리턴한다.
	 * @return timeGap
	 */
	public String getTimeGap() {
		return timeGap;
	}
	/**
	 * timeGap attribute 값을 설정한다.
	 * @param timeGap String
	 */
	public void setTimeGap(String timeGap) {
		this.timeGap = timeGap;
	}	
	
}
