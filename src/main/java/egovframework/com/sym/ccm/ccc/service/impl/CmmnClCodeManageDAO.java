package egovframework.com.sym.ccm.ccc.service.impl;

import java.util.List;

import org.springframework.stereotype.Repository;

import egovframework.com.sym.ccm.ccc.service.CmmnClCode;
import egovframework.com.sym.ccm.ccc.service.CmmnClCodeVO;
import egovframework.com.cmm.service.impl.EgovComAbstractDAO;

/**
 * 
 * 공통분류코드에 대한 데이터 접근 클래스를 정의한다
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
@Repository("CmmnClCodeManageDAO")
public class CmmnClCodeManageDAO extends EgovComAbstractDAO {

	/**
	 * 공통분류코드를 삭제한다.
	 * @param cmmnClCode
	 * @throws Exception
	 */
	public void deleteCmmnClCode(CmmnClCode cmmnClCode) throws Exception {
		delete("CmmnClCodeManageDAO.deleteCmmnClCode", cmmnClCode);
	}


	/**
	 * 공통분류코드를 등록한다.
	 * @param cmmnClCode
	 * @throws Exception
	 */
	public void insertCmmnClCode(CmmnClCode cmmnClCode) throws Exception {
        insert("CmmnClCodeManageDAO.insertCmmnClCode", cmmnClCode);
	}

	/**
	 * 공통분류코드 상세항목을 조회한다.
	 * @param cmmnClCode
	 * @return CmmnClCode(공통분류코드)
	 */
	public CmmnClCode selectCmmnClCodeDetail(CmmnClCode cmmnClCode) throws Exception {
		return (CmmnClCode)select("CmmnClCodeManageDAO.selectCmmnClCodeDetail", cmmnClCode);
	}


    /**
	 * 공통분류코드 목록을 조회한다.
     * @param searchVO
     * @return List(공통분류코드 목록)
     * @throws Exception
     */
    public List selectCmmnClCodeList(CmmnClCodeVO searchVO) throws Exception {
        return list("CmmnClCodeManageDAO.selectCmmnClCodeList", searchVO);
    }

    /**
	 * 공통분류코드 총 갯수를 조회한다.
     * @param searchVO
     * @return int(공통분류코드 총 갯수)
     */
    public int selectCmmnClCodeListTotCnt(CmmnClCodeVO searchVO) throws Exception {
        return (Integer)getSqlMapClientTemplate().queryForObject("CmmnClCodeManageDAO.selectCmmnClCodeListTotCnt", searchVO);
    }

	/**
	 * 공통분류코드를 수정한다.
	 * @param cmmnClCode
	 * @throws Exception
	 */
	public void updateCmmnClCode(CmmnClCode cmmnClCode) throws Exception {
		update("CmmnClCodeManageDAO.updateCmmnClCode", cmmnClCode);
	}

	/**
	 * 분류코드 설명을 불러온다.
	 */
	public String selectCmmnClCodeDc(String clCode) throws Exception {
		return (String)select("CmmnClCodeManageDAO.selectCmmnClCodeDc", clCode);
	}

}
