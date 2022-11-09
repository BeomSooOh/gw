package neos.cmm.systemx.etc;

/**
 * 
 * @title 로고 관리 VO
 * @author 공공사업부 포털개발팀 박기환
 * @since 2012. 8. 27.
 * @version 
 * @dscription 
 * 
 *
 * << 개정이력(Modification Information) >>
 *  수정일                수정자        수정내용  
 * -----------  -------  --------------------------------
 * 2012. 8. 27.  박기환        최초 생성
 *
 */
public class LogoManageVo {
	
	/***
	 * 기관 ID
	 */
	private String organId = "";
	
	/***
	 * 레이아웃에 있는 로고 파일 위치
	 */
	private String layoutLogoPath = "";
	
	/***
	 * 로그인 화면에 있는 로고 파일 위치
	 */
	private String loginLogoPath = "";
	
	/***
	 * 우선순위
	 */
	private String ord = "";

	/**
	 * organId attribute 값을 리턴한다.
	 * @return organId
	 */
	public String getOrganId() {
		return organId;
	}

	/**
	 * organId attribute 값을 설정한다.
	 * @param organId String
	 */
	public void setOrganId(String organId) {
		this.organId = organId;
	}

	/**
	 * layoutLogoPath attribute 값을 리턴한다.
	 * @return layoutLogoPath
	 */
	public String getLayoutLogoPath() {
		return layoutLogoPath;
	}

	/**
	 * layoutLogoPath attribute 값을 설정한다.
	 * @param layoutLogoPath String
	 */
	public void setLayoutLogoPath(String layoutLogoPath) {
		this.layoutLogoPath = layoutLogoPath;
	}

	/**
	 * loginLogoPath attribute 값을 리턴한다.
	 * @return loginLogoPath
	 */
	public String getLoginLogoPath() {
		return loginLogoPath;
	}

	/**
	 * loginLogoPath attribute 값을 설정한다.
	 * @param loginLogoPath String
	 */
	public void setLoginLogoPath(String loginLogoPath) {
		this.loginLogoPath = loginLogoPath;
	}

	/**
	 * ord attribute 값을 리턴한다.
	 * @return ord
	 */
	public String getOrd() {
		return ord;
	}

	/**
	 * ord attribute 값을 설정한다.
	 * @param ord String
	 */
	public void setOrd(String ord) {
		this.ord = ord;
	}

	
	
	
}
