package neos.cmm.cmmncode.cct.service.impl;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import neos.cmm.cmmncode.cct.service.CmmnCodeType;
import neos.cmm.cmmncode.cct.service.CmmnCodeTypeVO;
import neos.cmm.cmmncode.cct.service.CmmnCodeManageService;
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
@Service("CmmnCodeManageService")
public class CmmnCodeManageServiceImpl extends AbstractServiceImpl implements CmmnCodeManageService {

    @Resource(name="CmmnCodeTypeManageDAO")
    private CmmnCodeTypeManageDAO cmmnCodeTypeManageDAO;
    
	/**
	 * 공통코드를 삭제한다.
	 */
	public void deleteCmmnCode(CmmnCodeType cmmnCode) throws Exception {
		cmmnCodeTypeManageDAO.deleteCmmnCode(cmmnCode);
	}

	/**
	 * 공통코드를 등록한다.
	 */
	public void insertCmmnCode(CmmnCodeType cmmnCode) throws Exception {
    	cmmnCodeTypeManageDAO.insertCmmnCode(cmmnCode);
    	//cmmnCodeTypeManageDAO.insertCmmnCodeMulti(cmmnCode); 
	}

	/**
	 * 공통코드 상세항목을 조회한다.
	 */
	public CmmnCodeType selectCmmnCodeDetail(CmmnCodeType cmmnCode) throws Exception {
    	CmmnCodeType ret = (CmmnCodeType)cmmnCodeTypeManageDAO.selectCmmnCodeDetail(cmmnCode);
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
		
		return cmmnCodeTypeManageDAO.selectCmmnCodeList(paramMap, paginationInfo);
		
	}

	/**
	 * 공통코드 총 갯수를 조회한다.
	 */
	public int selectCmmnCodeListTotCnt(CmmnCodeTypeVO searchVO) throws Exception {
        return cmmnCodeTypeManageDAO.selectCmmnCodeListTotCnt(searchVO);
	}

	/**
	 * 공통코드를 수정한다.
	 */
	public void updateCmmnCode(CmmnCodeType cmmnCode) throws Exception {
		cmmnCodeTypeManageDAO.updateCmmnCode(cmmnCode);
		cmmnCodeTypeManageDAO.updateCmmnCodeMulti(cmmnCode);
	}

	/**
	 * 코드id 설명을 불러온다.
	 */
	public String selectCcmCmmnCodeDc(String codeId) throws Exception {
		return cmmnCodeTypeManageDAO.selectCcmCmmnCodeDc(codeId);
	}
	
	public List<Map<String, Object>> selectCmmnCodeList(Map<String,Object> params) throws Exception {
		return cmmnCodeTypeManageDAO.selectCmmnCodeList(params);
	}
}
