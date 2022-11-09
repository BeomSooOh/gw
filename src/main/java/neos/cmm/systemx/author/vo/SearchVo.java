package neos.cmm.systemx.author.vo;

import egovframework.com.cmm.ComDefaultVO;
import egovframework.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;

/**
 * 
 * @title search VO
 * @author 공공사업부 포털개발팀 박기환
 * @since 2012. 7. 2.
 * @version 
 * @dscription 
 * 
 *
 * << 개정이력(Modification Information) >>
 *  수정일                수정자        수정내용  
 * -----------  -------  --------------------------------
 * 2012. 7. 2.  박기환        최초 생성
 *
 */
public class SearchVo extends ComDefaultVO {
	
	/**
	 * 페이지 정보
	 */
	private PaginationInfo paginationInfo=new PaginationInfo();

	/**
	 * paginationInfo attribute 값을 리턴한다.
	 * @return paginationInfo
	 */
	public PaginationInfo getPaginationInfo() {
		return paginationInfo;
	}

	/**
	 * paginationInfo attribute 값을 설정한다.
	 * @param paginationInfo PaginationInfo
	 */
	public void setPaginationInfo(PaginationInfo paginationInfo) {
		this.paginationInfo = paginationInfo;
	}
	
	

}
