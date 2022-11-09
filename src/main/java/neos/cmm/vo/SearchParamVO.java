package neos.cmm.vo;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

import bizbox.orgchart.service.vo.LoginVO;
import egovframework.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;
import neos.cmm.util.CommonUtil;

public abstract class SearchParamVO {
	private String c_startDate;
	private String c_endDate;

	@SuppressWarnings("unused")
	private String c_startDate_origin;
	@SuppressWarnings("unused")
	private String c_endDate_origin;		
	
	@SuppressWarnings("unused")
	private String signtype;
	private String signtype_ko;
	
	private String signtype_select;

	private String docflag_select;
	

	private String c_dititle;
	private String username;	
	private String c_dikeycode;
	private String docstatus;
	
	private String c_ridocnum;
	private String orgdept;	

	private String selectTerm;
	private String selectSearchType;
	
	@SuppressWarnings("unused")
	private String searchText;
	 
    private String selectStatus;
    
    private String selectFlag;
    
	 private LoginVO loginvo;
	 
	 private Integer pageIndex = 1;
	 
	 private PaginationInfo paginationInfo=new PaginationInfo();
	 
	 private String c_aikeycode;
	 
	 private String c_aititle;
	 private String c_cikind;
	 
	 private int page ;
	 private int pageSize ;
	 
	public int getPage() {
		return page;
	}

	public void setPage(int page) {
		this.page = page;
	}

	public int getPageSize() {
		return pageSize;
	}
	
	public void setPageSize(int pageSize) {
		this.pageSize = pageSize;
	}
	
	public String getC_lnkcode() {
		return c_lnkcode;
	}

	public void setC_lnkcode(String cLnkcode) {
		this.c_lnkcode = cLnkcode;
	}

	private String c_lnkcode ;
		


	 
	 public String getC_cikind() {
		return c_cikind;
	}

	public void setC_cikind(String cCikind) {
		this.c_cikind = cCikind;
	}

	public String getC_aikeycode() {
		return c_aikeycode;
	}

	public void setC_aikeycode(String cAikeycode) {
		this.c_aikeycode = cAikeycode;
	}

	public String getC_aititle() {
		return c_aititle;
	}

	public void setC_aititle(String cAititle) {
		this.c_aititle = cAititle;
	}

	public SearchParamVO()
	 {
		 c_startDate = ConvertDate(c_startDate, -1);
		 c_endDate = ConvertDate(c_endDate, 0);
	 }
	 
	public Integer getPageIndex() {
		return pageIndex;
	}

	public void setPageIndex(Integer pageIndex) {
		this.pageIndex = pageIndex;
	}

	public PaginationInfo getPaginationInfo() {
		return paginationInfo;
	}
	public void setPaginationInfo(PaginationInfo paginationInfo) {
		this.paginationInfo = paginationInfo;
	}
	public LoginVO getLoginvo() {
		return loginvo;
	}
	public void setLoginvo(LoginVO loginvo) {
		this.loginvo = loginvo;
	}
	public String getDocstatus() {
		return docstatus;
	}
	public String getC_ridocnum() {
		return c_ridocnum;
	}

	public void setC_ridocnum(String cRidocnum) {
		this.c_ridocnum = cRidocnum;
	}	
	public String getSigntype_select() {
		return signtype_select;
	}

	public void setSigntype_select(String signtypeSelect) {
		this.signtype_select = signtypeSelect;
	}
	public void setDocstatus(String docstatus) {
		this.docstatus = docstatus;
	}
	public String getSigntype() {
		return signTypeGroup(signtype_select);
		//return "'002','003'";
	}
	
	public void setSigntype(String signtype) {
		this.signtype = signtype;
	}
	public String getSigntype_ko() {
		return signtype_ko;
	}
	public void setSigntype_ko(String signtypeKo) {
		this.signtype_ko = signtypeKo;
	}	
	public String getC_startDate() {
		return ConvertDate(c_startDate, -1);
	}
	public void setC_startDate(String cStartDate) {
		this.c_startDate = cStartDate;
	}
	public String getC_endDate() {
		return ConvertDate(c_endDate, 0);
	}
	public void setC_endDate(String cEndDate) {
		this.c_endDate = cEndDate;
	}
	
	public String getC_startDate_origin() {
		if(c_startDate!=null && !c_startDate.equals("")){
			return c_startDate;
		}
		else {
			return getDate();
		}
	}
	public String getC_endDate_origin() {
		if(c_endDate!=null && !c_endDate.equals("")){
			return c_endDate;
		}
		else {
			return getDate();
		}
	}
	public String getC_dititle() {
		return c_dititle;
	}
	public void setC_dititle(String cDititle) {
		this.c_dititle = cDititle;
	}
	public String getUsername() {
		return username;
	}
	public void setUsername(String username) {
		this.username = username;
	}
	public String getC_dikeycode() {
		return c_dikeycode;
	}
	public void setC_dikeycode(String cDikeycode) {
		this.c_dikeycode = cDikeycode;
	}
	
	public String getSelectTerm() {
		return selectTerm;
	}
	public void setSelectTerm(String selectTerm) {
		this.selectTerm = selectTerm;
	}
	public String getSelectSearchType() {
		return selectSearchType;
	}
	public void setSelectSearchType(String selectSearchType) {
		this.selectSearchType = selectSearchType;
	}
	
	private String signTypeGroup(String signtypeSelect)
	{
		Map<String,String> map = new HashMap<String,String>();
		map.put("approval", "'002','003'");
		map.put("cooperation", "'004'");
		map.put("inner", "'001'");//대내
		map.put("outter", "'002'");//대외
		map.put("stateReport", "001");//기안중
		map.put("stateApproval", "002");//결재중
		map.put("stateCooperation", "003");//협조중
		map.put("stateHold", "004");//보류중
		map.put("stateRollback", "005");//문서회수
		map.put("stateMultipleReceive", "006");//다중부서접수중
		map.put("stateReportReturn", "007");//기안반려
		map.put("stateApprovalEnd", "008");//결재완료
		map.put("stateSendRequest", "009");//발송요구
		map.put("unconfirmed", "1");//확인
		map.put("confirmed", "0");//미확인
		
		String returnString = null;
		if(map.containsKey(signtypeSelect))
		{
			returnString = map.get(signtypeSelect);
		}
		return returnString;
	}
	
	public String getSearchText() {
		if(c_dititle != null && c_dititle.trim().length() !=0){
			return c_dititle;
		}else if(username != null && username.trim().length() !=0){
			return username;
		}
		else if(c_ridocnum != null && c_ridocnum.trim().length() !=0){
			return c_ridocnum;
		}
		else if(orgdept != null && orgdept.trim().length() !=0){
			return orgdept;
		}
		else{
			return "";
		}
		
	}
	public void setSearchText(String searchText) {
		
		this.searchText = searchText;
	}
	//yyyy-MM-dd 이런 날짜형 String을
	//yyyyMMdd 이런 형태로 변환하여 반환함
	@SuppressWarnings("deprecation")
	public String ConvertDate(String datestring, int addMonth)
	{		
		
		String returnDate = "";
		String dateFormatInput = "yyyy-MM-dd";
		String dateFormatOutput = "yyyyMMdd";
		SimpleDateFormat formatInput = new SimpleDateFormat(dateFormatInput);
		SimpleDateFormat formatOutput = new SimpleDateFormat(dateFormatOutput);
		
		Date date = null;
		try {
			date = formatInput.parse(datestring);	
		} catch (Exception e) {
			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
		}
		if(date!=null)
		{
			returnDate = formatOutput.format(date);
		}
		else
		{
			date = new Date();
			if(addMonth == -1)
			{
				date.setDate(01);
				date.setMonth(00);
				returnDate = getDate(date, dateFormatOutput);
			}
			else
			{
			date.setMonth(date.getMonth()+addMonth);
			returnDate = getDate(date, dateFormatInput);
			}
		}
		
		return returnDate;	
	}

	private String getDate()
	{
		Date date = new Date();
		return getDate(date);
	}
	
	private String getDate(Date date)
	{
		
		String formatString = "yyyy-MM-dd";
		return 	getDate(date, formatString);
	}
	
	private String getDate(Date date, String formatString)
	{
		String dateStr = "";

		SimpleDateFormat formatInput = new SimpleDateFormat(formatString);
		
		try{
			dateStr = formatInput.format(date);
		}
		catch(Exception ex){
			dateStr = "";
		}			
		return dateStr;
	}
	
	private String drafter = "";

	public String getDrafter() {
		return drafter;
	}

	public void setDrafter(String drafter) {
		this.drafter = drafter;
	}

	public String getOrgdept() {
		return orgdept;
	}

	public void setOrgdept(String orgdept) {
		this.orgdept = orgdept;
	}

    /**
     * @return the selectStatus
     */
    public String getSelectStatus() {
        return selectStatus;
    }

    /**
     * @param selectStatus the selectStatus to set
     */
    public void setSelectStatus(String selectStatus) {
        this.selectStatus = selectStatus;
    }

    /**
     * @return the selectFlag
     */
    public String getSelectFlag() {
        return selectFlag;
    }

    /**
     * @param selectFlag the selectFlag to set
     */
    public void setSelectFlag(String selectFlag) {
        this.selectFlag = selectFlag;
    }
	
	public String getDocflag_select() {
		return docflag_select;
	}

	public void setDocflag_select(String docflagSelect) {
		this.docflag_select = docflagSelect;
	}

}
