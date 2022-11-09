package neos.cmm.cmmncode.ccd.service.impl;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import neos.cmm.cmmncode.ccm.service.CmmnCodeDetail;
import neos.cmm.cmmncode.ccd.service.CmmnCodeDetailVO;
import neos.cmm.cmmncode.ccd.service.CmmnCodeDetailManageService;
import egovframework.rte.fdl.cmmn.AbstractServiceImpl;
import egovframework.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;



/**
 * 
 * 공통상세코드에 대한 서비스 구현클래스를 정의한다
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
@Service("CmmnCodeDetailManageService")
public class CmmnCodeDetailManageServiceImpl extends AbstractServiceImpl implements CmmnCodeDetailManageService {

    @Resource(name="CmmnCodeDetailManageDAO")
    private CmmnCodeDetailManageDAO cmmnCodeDetailManageDAO;
    
	/**
	 * 공통상세코드를 삭제한다.
	 */
	public void deleteCmmnCodeDetail(CmmnCodeDetail cmmnCodeDetail) throws Exception {
		cmmnCodeDetailManageDAO.deleteCmmnCodeDetail(cmmnCodeDetail);
	}

	/**
	 * 공통상세코드를 등록한다.
	 */
	public void insertCmmnCodeDetail(CmmnCodeDetail cmmnCodeDetail) throws Exception {
    	cmmnCodeDetailManageDAO.insertCmmnCodeDetail(cmmnCodeDetail);    	
	}

	/**
	 * 공통상세코드 상세항목을 조회한다.
	 */
	public CmmnCodeDetail selectCmmnCodeDetailDetail(CmmnCodeDetail cmmnCodeDetail) throws Exception {
    	CmmnCodeDetail ret = (CmmnCodeDetail)cmmnCodeDetailManageDAO.selectCmmnCodeDetailDetail(cmmnCodeDetail);
    	return ret;
	}

	/**
	 * 공통상세코드 목록을 조회한다.
	 */
	public List selectCmmnCodeDetailList(CmmnCodeDetailVO searchVO) throws Exception {
        return cmmnCodeDetailManageDAO.selectCmmnCodeDetailList(searchVO);
	}

	/**
	 * 공통상세코드 총 갯수를 조회한다.
	 */
	public int selectCmmnCodeDetailListTotCnt(CmmnCodeDetailVO searchVO) throws Exception {
        return cmmnCodeDetailManageDAO.selectCmmnCodeDetailListTotCnt(searchVO);
	}

	/**
	 * 공통상세코드를 수정한다.
	 */
	public void updateCmmnCodeDetail(CmmnCodeDetail cmmnCodeDetail) throws Exception {
		cmmnCodeDetailManageDAO.updateCmmnCodeDetail(cmmnCodeDetail);
	}
	
	@Override
	public Map<String, Object> selectCmmnCodeDetailList(Map<String, Object> paramMap, PaginationInfo paginationInfo) {
		return cmmnCodeDetailManageDAO.selectCmmnCodeDetailList(paramMap, paginationInfo);
	}
}
