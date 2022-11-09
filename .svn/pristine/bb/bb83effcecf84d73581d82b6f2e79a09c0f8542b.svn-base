package neos.cmm.cmmncode.ccd.service.impl;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import neos.cmm.cmmncode.ccm.service.CmmnCodeDetail;
import neos.cmm.cmmncode.ccd.service.CmmnCodeDetailVO;
import egovframework.com.cmm.service.impl.EgovComAbstractDAO;
import egovframework.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;

/**
 * 
 * 공통상세코드에 대한 데이터 접근 클래스를 정의한다
 * @author 공통서비스 개발팀 이중호
 * @since 2009.04.01
 * @version 1.0
 * @see
 *
 * <pre>
 * << 개정이력(Modification Information) >>
 *   
 *   수정일      수정자           수정내용
 *  -------    --------    ---------------------------
 *   2009.04.01  이중호          최초 생성
 *
 * </pre>
 */
@Repository("CmmnCodeDetailManageDAO")
public class CmmnCodeDetailManageDAO extends EgovComAbstractDAO {

	/**
	 * 공통상세코드를 삭제한다.
	 * @param cmmnDetailCode
	 * @throws Exception
	 */
	public void deleteCmmnCodeDetail(CmmnCodeDetail cmmnCodeDetail) throws Exception {
		delete("CmmnCodeDetailManageDAO.deleteCmmnCodeDetail", cmmnCodeDetail);
	}


	/**
	 * 공통상세코드를 등록한다.
	 * @param cmmnDetailCode
	 * @throws Exception
	 */
	public void insertCmmnCodeDetail(CmmnCodeDetail cmmnCodeDetail) throws Exception {
        insert("CmmnCodeDetailManageDAO.insertCmmnCodeDetail", cmmnCodeDetail);
	}

	/**
	 * 공통상세코드 상세항목을 조회한다.
	 * @param cmmnDetailCode
	 * @return CmmnDetailCode(공통상세코드)
	 */
	public CmmnCodeDetail selectCmmnCodeDetailDetail(CmmnCodeDetail cmmnCodeDetail) throws Exception {
		return (CmmnCodeDetail) select("CmmnCodeDetailManageDAO.selectCmmnCodeDetailDetail", cmmnCodeDetail);
	}


    /**
	 * 공통상세코드 목록을 조회한다.
     * @param searchVO
     * @return List(공통상세코드 목록)
     * @throws Exception
     */
    public List selectCmmnCodeDetailList(CmmnCodeDetailVO searchVO) throws Exception {
        return list("CmmnCodeDetailManageDAO.selectCmmnCodeDetailList", searchVO);
    }

    /**
	 * 공통상세코드 총 갯수를 조회한다.
     * @param searchVO
     * @return int(공통상세코드 총 갯수)
     */
    public int selectCmmnCodeDetailListTotCnt(CmmnCodeDetailVO searchVO) throws Exception {
        return (Integer)getSqlMapClientTemplate().queryForObject("CmmnCodeDetailManageDAO.selectCmmnCodeDetailListTotCnt", searchVO);
    }

	/**
	 * 공통상세코드를 수정한다.
	 * @param cmmnDetailCode
	 * @throws Exception
	 */
	public void updateCmmnCodeDetail(CmmnCodeDetail cmmnCodeDetail) throws Exception {
		update("CmmnCodeDetailManageDAO.updateCmmnCodeDetail", cmmnCodeDetail);
	}


    @SuppressWarnings({ "unchecked", "rawtypes" })
	Map<String, Object> selectCmmnCodeDetailList(Map<String, Object> paramMap , PaginationInfo paginationInfo){
		return super.listOfPaging2(paramMap, paginationInfo, "CmmnCodeDetailManageDAO.selectCmmnCodeDetailList");
	}
	
}
