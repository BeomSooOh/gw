package neos.cmm.taglib;

import javax.servlet.jsp.JspException;
import javax.servlet.jsp.tagext.TagSupport;

import egovframework.rte.fdl.string.EgovStringUtil;
import neos.cmm.util.CommonUtil;
import neos.cmm.util.code.CommonCodeUtil;

public class CommonCodeTag extends TagSupport {
	private String codeid  ;
	private String code ;
	private String lang = "kr" ;
	private String initValue = "" ;	
	public String getCodeid() {
		return codeid;
	}

	public void setCodeid(String codeid) {
		this.codeid = codeid;
	}

	public String getCode() {
		return code;
	}

	public void setCode(String code) {
		this.code = code;
	}

	public String getLang() {
		return lang;
	}

	public void setLang(String lang) {
		this.lang = lang;
	}
	
	public String getInitValue() {
		return initValue;
	}

	public void setInitValue(String initValue) {
		this.initValue = initValue;
	}
	/**
	 * 
	 */
	private static final long serialVersionUID = 6587763779230347323L;

	/**
	 * 버튼 표시
	 */
	public int doEndTag() throws JspException{
		try {
			if( EgovStringUtil.isEmpty(lang) ) {
				lang = "kr" ;
			}
			String codeName = CommonCodeUtil.getCodeName(codeid, code, lang);
			if(EgovStringUtil.isEmpty(codeName) ) {
				if(!EgovStringUtil.isEmpty(initValue) ) {
					codeName = initValue ;
				}
			}
			pageContext.getOut().print(codeName);
		} catch (Exception e) {
			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
		}
		return EVAL_PAGE;
	}
}
