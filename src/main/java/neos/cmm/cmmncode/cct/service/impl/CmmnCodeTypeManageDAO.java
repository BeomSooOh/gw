package neos.cmm.cmmncode.cct.service.impl;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import neos.cmm.cmmncode.cct.service.CmmnCodeType;
import neos.cmm.cmmncode.cct.service.CmmnCodeTypeVO;
import egovframework.com.cmm.service.impl.EgovComAbstractDAO;
import egovframework.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;

/**
 * 
 * 공통코드에 대한 데이터 접근 클래스를 정의한다
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
@Repository("CmmnCodeTypeManageDAO")
public class CmmnCodeTypeManageDAO extends EgovComAbstractDAO {

	/**
	 * 공통코드를 삭제한다.
	 * @param cmmnCode
	 * @throws Exception
	 */
	public void deleteCmmnCode(CmmnCodeType cmmnCode) throws Exception {
		delete("CmmnCodeTypeManageDAO.deleteCmmnCode", cmmnCode);
	}


	/**
	 * 공통코드를 등록한다.
	 * @param cmmnCode
	 * @throws Exception
	 */
	public void insertCmmnCode(CmmnCodeType cmmnCode) throws Exception {
        insert("CmmnCodeTypeManageDAO.insertCmmnCode", cmmnCode);
        insert("CmmnCodeTypeManageDAO.insertCmmnCodeMulti", cmmnCode);
	}
	
	public void insertCmmnCodeMulti(CmmnCodeType cmmnCode) throws Exception {
        insert("CmmnCodeTypeManageDAO.insertCmmnCodeMulti", cmmnCode);
	}

	/**
	 * 공통코드 상세항목을 조회한다.
	 * @param cmmnCode
	 * @return CmmnCode(공통코드)
	 */
	public CmmnCodeType selectCmmnCodeDetail(CmmnCodeType cmmnCode) throws Exception {
		return (CmmnCodeType)select("CmmnCodeTypeManageDAO.selectCmmnCodeDetail", cmmnCode);
	}


    /**
	 * 공통코드 목록을 조회한다.
     * @param searchVO
     * @return List(공통코드 목록)
     * @throws Exception
     */
    @SuppressWarnings("unchecked")
	public List<Map<String, Object>> selectCmmnCodeList(Map<String,Object> params) throws Exception {
        return list("CmmnCodeTypeManageDAO.selectCmmnCodeList", params);
    }
    
    @SuppressWarnings({ "unchecked", "rawtypes" })
	Map<String, Object> selectCmmnCodeList(Map<String, Object> paramMap , PaginationInfo paginationInfo){
		
		return super.listOfPaging2(paramMap, paginationInfo, "CmmnCodeTypeManageDAO.selectCmmnCodeList");
		
		
	}

    /**
	 * 공통코드 총 갯수를 조회한다.
     * @param searchVO
     * @return int(공통코드 총 갯수)
     */
    public int selectCmmnCodeListTotCnt(CmmnCodeTypeVO searchVO) throws Exception {
        return (Integer)getSqlMapClientTemplate().queryForObject("CmmnCodeTypeManageDAO.selectCmmnCodeListTotCnt", searchVO);
    }

	/**
	 * 공통코드를 수정한다.
	 * @param cmmnCode
	 * @throws Exception
	 */
	public void updateCmmnCode(CmmnCodeType cmmnCode) throws Exception {
		update("CmmnCodeTypeManageDAO.updateCmmnCode", cmmnCode);
	}
	
	public void updateCmmnCodeMulti(CmmnCodeType cmmnCode) throws Exception {
		update("CmmnCodeTypeManageDAO.updateCmmnCodeMulti", cmmnCode);
	}

	/**
	 * 코드id 설명을 불러온다.
	 */
	public String selectCcmCmmnCodeDc(String codeId) throws Exception {
		return (String)select("CmmnCodeTypeManageDAO.selectCcmCmmnCodeDc", codeId);
	}
}
