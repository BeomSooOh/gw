package neos.cmm.menu.vo;

import java.util.List;

/**
 * 
 * @title 메뉴 정보 관리에 쓰는 Beans
 * @author 공공사업부 포털개발팀 박기환
 * @since 2012. 5. 24.
 * @version 
 * @dscription 
 * 
 *
 * << 개정이력(Modification Information) >>
 *  수정일                수정자        수정내용  
 * -----------  -------  --------------------------------
 * 2012. 5. 24.  박기환        최초 생성
 *
 */
public class MenuInfo {
	/**
	 * 메뉴 번호
	 */
	private String menuNo = "";
	
	/**
	 * 메뉴순서
	 */
	private String menuOrd = "";
	
	/**
	 * 메뉴명
	 */
	private String menuName = "";
	
	/**
	 * 상위메뉴No
	 */
	private String upperMenuNo = "";
	
	/**
	 * 프로그램명
	 */
	private String programName = "";
	
	/**
	 * 관련이미지 명
	 */
	private String linkImgName = "";
	
	/**
	 * 관련이미지 경로
	 */
	private String linkImgHref = "";
	
	/**
	 * 메뉴설명
	 */
	private String menuDc = "";

	/**
	 * 관련 프로그램 목록
	 */
    public List<String> relProgrmList;

    /**
     * 관련프로그램 목록 String
     */
    public String strRelProgrmList;
    
    /** CRUD 사용여부 **/
    public String crudmYn;


    /** 최사번호 **/
    public String compSeq;  
    
	/** 메뉴구분 **/
    public String menuGubun;      
    
	/** 언어설정 **/
    public String menuLang;       
    
    /** URL경로 **/
    public String urlPath;

    /** 메뉴사용여부 **/
    public String useChk;     
    
	/** SSO 사용여부 **/
    public String ssoUseYn;    

    /** 메뉴접근권한 목록 String */
    public String strRelAuthList;    
    /** 메뉴접근권한 코드 목록 String */
    public String strMenuAuthList; 
    /** 선택 메뉴 No */
    public String selMenuNo;     

    /** 등록/수정자 seq */
    public String empSeq;       


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
	 * menuOrd attribute 값을 리턴한다.
	 * @return menuOrd
	 */
	public String getMenuOrd() {
		return menuOrd;
	}

	/**
	 * menuOrd attribute 값을 설정한다.
	 * @param menuOrd String
	 */
	public void setMenuOrd(String menuOrd) {
		this.menuOrd = menuOrd;
	}

	/**
	 * menuName attribute 값을 리턴한다.
	 * @return menuName
	 */
	public String getMenuName() {
		return menuName;
	}

	/**
	 * menuName attribute 값을 설정한다.
	 * @param menuName String
	 */
	public void setMenuName(String menuName) {
		this.menuName = menuName;
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
	 * programName attribute 값을 리턴한다.
	 * @return programName
	 */
	public String getProgramName() {
		return programName;
	}

	/**
	 * programName attribute 값을 설정한다.
	 * @param programName String
	 */
	public void setProgramName(String programName) {
		this.programName = programName;
	}

	/**
	 * linkImgName attribute 값을 리턴한다.
	 * @return linkImgName
	 */
	public String getLinkImgName() {
		return linkImgName;
	}

	/**
	 * linkImgName attribute 값을 설정한다.
	 * @param linkImgName String
	 */
	public void setLinkImgName(String linkImgName) {
		this.linkImgName = linkImgName;
	}

	/**
	 * linkImgHref attribute 값을 리턴한다.
	 * @return linkImgHref
	 */
	public String getLinkImgHref() {
		return linkImgHref;
	}

	/**
	 * linkImgHref attribute 값을 설정한다.
	 * @param linkImgHref String
	 */
	public void setLinkImgHref(String linkImgHref) {
		this.linkImgHref = linkImgHref;
	}

	/**
	 * menuDc attribute 값을 리턴한다.
	 * @return menuDc
	 */
	public String getMenuDc() {
		return menuDc;
	}

	/**
	 * menuDc attribute 값을 설정한다.
	 * @param menuDc String
	 */
	public void setMenuDc(String menuDc) {
		this.menuDc = menuDc;
	}
	
    public List<String> getRelProgrmList() {
        return relProgrmList;
    }

    public void setRelProgrmList(List<String> relProgrmList) {
        this.relProgrmList = relProgrmList;
    }
	
    public String getStrRelProgrmList() {
        return strRelProgrmList;
    }

    public void setStrRelProgrmList(String strRelProgrmList) {
        this.strRelProgrmList = strRelProgrmList;
    }

    public String getCrudmYn() {
        return crudmYn;
    }

    public void setCrudmYn(String crudmYn) {
        this.crudmYn = crudmYn;
    }


    public String getMenuGubun() {
		return menuGubun;
	}

	public void setMenuGubun(String menuGubun) {
		this.menuGubun = menuGubun;
	}    
    
	public String getMenuLang() {
        return menuLang;
    }

    public void setMenuLang(String menuLang) {
        this.menuLang = menuLang;
    }
    
    public String getUrlPath() {
        return urlPath;
    }

    public void setUrlPath(String urlPath) {
        this.urlPath = urlPath;
    }

    public String getUseChk() {
		return useChk;
	}

	public void setUseChk(String useChk) {
		this.useChk = useChk;
	}    
    
    public String getSsoUseYn() {
        return ssoUseYn;
    }

    public void setSsoUseYn(String ssoUseYn) {
        this.ssoUseYn = ssoUseYn;
    }
    
    public String getStrRelAuthList() {
		return strRelAuthList;
	}

	public void setStrRelAuthList(String strRelAuthList) {
		this.strRelAuthList = strRelAuthList;
	}  

    public String getCompSeq() {
		return compSeq;
	}

	public void setCompSeq(String compSeq) {
		this.compSeq = compSeq;
	}	

    public String getStrMenuAuthList() {
		return strMenuAuthList;
	}

	public void setStrMenuAuthList(String strMenuAuthList) {
		this.strMenuAuthList = strMenuAuthList;
	}
	
	public String getSelMenuNo() {
		return selMenuNo;
	}

	public void setSelMenuNo(String selMenuNo) {
		this.selMenuNo = selMenuNo;
	}

	public String getEmpSeq() {
		return empSeq;
	}

	public void setEmpSeq(String empSeq) {
		this.empSeq = empSeq;
	}	
}
