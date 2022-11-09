package neos.cmm.menu.vo;

/**
 * 
 * @title 메뉴 정보, 프로그램 정보 매핑 VO
 * @author 공공사업부 포털개발팀 박기환
 * @since 2012. 9. 26.
 * @version 
 * @dscription 
 * 
 *
 * << 개정이력(Modification Information) >>
 *  수정일                수정자        수정내용  
 * -----------  -------  --------------------------------
 * 2012. 9. 26.  박기환        최초 생성
 *
 */
public class MenuMappingInfo {
	private String menuNo = "";
	
	private String upperMenuNo = "";
	
	private String programId = "";
	
	private String programNm = "";
	
	private String url = "";
	
	private String firstMenuNo = "";
	
	private String firstMenuNm = "";
	
	private String MenuNm = "";
	
	public String getMenuNm() {
		return MenuNm;
	}

	public void setMenuNm(String menuNm) {
		MenuNm = menuNm;
	}

	/**
	 * menuNo attribute 값을 리턴한다.
	 * @return menuNo
	 */
	public String getMenuNo() {
		return menuNo;
	}

	/**
	 * menuNo attribute 값을 설정한다.
	 * @param menuNo String
	 */
	public void setMenuNo(String menuNo) {
		this.menuNo = menuNo;
	}

	/**
	 * upperMenuNo attribute 값을 리턴한다.
	 * @return upperMenuNo
	 */
	public String getUpperMenuNo() {
		return upperMenuNo;
	}

	/**
	 * upperMenuNo attribute 값을 설정한다.
	 * @param upperMenuNo String
	 */
	public void setUpperMenuNo(String upperMenuNo) {
		this.upperMenuNo = upperMenuNo;
	}

	/**
	 * programId attribute 값을 리턴한다.
	 * @return programId
	 */
	public String getProgramId() {
		return programId;
	}

	/**
	 * programId attribute 값을 설정한다.
	 * @param programId String
	 */
	public void setProgramId(String programId) {
		this.programId = programId;
	}

	/**
	 * programNm attribute 값을 리턴한다.
	 * @return programNm
	 */
	public String getProgramNm() {
		return programNm;
	}

	/**
	 * programNm attribute 값을 설정한다.
	 * @param programNm String
	 */
	public void setProgramNm(String programNm) {
		this.programNm = programNm;
	}

	/**
	 * url attribute 값을 리턴한다.
	 * @return url
	 */
	public String getUrl() {
		return url;
	}

	/**
	 * url attribute 값을 설정한다.
	 * @param url String
	 */
	public void setUrl(String url) {
		this.url = url;
	}

	/**
	 * firstMenuNo attribute 값을 리턴한다.
	 * @return firstMenuNo
	 */
	public String getFirstMenuNo() {
		return firstMenuNo;
	}

	/**
	 * firstMenuNo attribute 값을 설정한다.
	 * @param firstMenuNo String
	 */
	public void setFirstMenuNo(String firstMenuNo) {
		this.firstMenuNo = firstMenuNo;
	}

	/**
	 * firstMenuNm attribute 값을 리턴한다.
	 * @return firstMenuNm
	 */
	public String getFirstMenuNm() {
		return firstMenuNm;
	}

	/**
	 * firstMenuNm attribute 값을 설정한다.
	 * @param firstMenuNm String
	 */
	public void setFirstMenuNm(String firstMenuNm) {
		this.firstMenuNm = firstMenuNm;
	}
	
	
	
}
