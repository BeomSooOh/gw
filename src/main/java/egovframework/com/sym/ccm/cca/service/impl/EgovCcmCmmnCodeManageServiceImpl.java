package egovframework.com.sym.ccm.cca.service.impl;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import egovframework.com.sym.ccm.cca.service.CmmnCode;
import egovframework.com.sym.ccm.cca.service.CmmnCodeVO;
import egovframework.com.sym.ccm.cca.service.EgovCcmCmmnCodeManageService;
import egovframework.rte.fdl.cmmn.AbstractServiceImpl;
import egovframework.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;



/**
 * 
 * 공통코드에 대한 서비스 구현클래스를 정의한다
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
@Service("EgovCcmCmmnCodeManageService")
public class EgovCcmCmmnCodeManageServiceImpl extends AbstractServiceImpl implements EgovCcmCmmnCodeManageService {

    @Resource(name="CmmnCodeManageDAO")
    private CmmnCodeManageDAO cmmnCodeManageDAO;
    
	/**
	 * 공통코드를 삭제한다.
	 */
	public void deleteCmmnCode(CmmnCode cmmnCode) throws Exception {
		cmmnCodeManageDAO.deleteCmmnCode(cmmnCode);
	}

	/**
	 * 공통코드를 등록한다.
	 */
	public void insertCmmnCode(CmmnCode cmmnCode) throws Exception {
		cmmnCodeManageDAO.insertCmmnCode(cmmnCode);    	
	}

	/**
	 * 공통코드 상세항목을 조회한다.
	 */
	public CmmnCode selectCmmnCodeDetail(CmmnCode cmmnCode) throws Exception {
    	CmmnCode ret = (CmmnCode)cmmnCodeManageDAO.selectCmmnCodeDetail(cmmnCode);
    	return ret;
	}

	/**
	 * 공통코드 목록을 조회한다.
	 */
	/*public List selectCmmnCodeList(CmmnCodeVO searchVO) throws Exception {
        return cmmnCodeManageDAO.selectCmmnCodeList(searchVO);
	}*/
	@Override
	public Map<String, Object> selectCmmnCodeList(Map<String, Object> paramMap, PaginationInfo paginationInfo) {
		
		return cmmnCodeManageDAO.selectCmmnCodeList(paramMap, paginationInfo);
		
	}

	/**
	 * 공통코드 총 갯수를 조회한다.
	 */
	public int selectCmmnCodeListTotCnt(CmmnCodeVO searchVO) throws Exception {
        return cmmnCodeManageDAO.selectCmmnCodeListTotCnt(searchVO);
	}

	/**
	 * 공통코드를 수정한다.
	 */
	public void updateCmmnCode(CmmnCode cmmnCode) throws Exception {
		cmmnCodeManageDAO.updateCmmnCode(cmmnCode);
	}
	/**
	 * 코드id 설명을 불러온다.
	 */
	public String selectCcmCmmnCodeDc(String codeId) throws Exception {
		return cmmnCodeManageDAO.selectCcmCmmnCodeDc(codeId);
	}
	
	public List selectCmmnCodeList(CmmnCodeVO searchCodeVO) throws Exception {
		return cmmnCodeManageDAO.selectCmmnCodeList(searchCodeVO);
	}
}