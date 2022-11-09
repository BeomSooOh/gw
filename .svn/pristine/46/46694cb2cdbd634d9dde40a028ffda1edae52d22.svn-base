package neos.migration.suite.service;

import java.util.List;
import java.util.Map; 

import neos.migration.suite.vo.SuiteBaseInfoVO;
import neos.migration.suite.vo.SuiteDBCnntVO;

public interface ExecuteMigService {

	// suite 
	
	Map<String, Object> selectSuiteCompanyInfoB(SuiteDBCnntVO suiteDBCnntVO);

	Map<String, Object> selectSuiteCompanyInfoC(SuiteDBCnntVO suiteDBCnntVO, SuiteBaseInfoVO suiteBaseInfoVO);
	
	/**
	 * <pre>
	 * stuie 정보 조회
	 * </pre>
	 */
	Map<String, Object> getSuiteServerInfo(Map<String, Object> paramMap);

	Map<String, Object> selectSuiteDocCount(SuiteDBCnntVO suiteDBCnntVO, SuiteBaseInfoVO suiteBaseInfoVO, Map<String, Object> param);

	public List<Map<String, Object>> selectAlphaDocBoxList(Map<String, Object> params);

	List<Map<String, Object>> selectSuiteDocId(SuiteDBCnntVO suiteDBCnntVO, Map<String, Object> params);

	String convertDocIdList(List<Map<String, Object>> selectSuiteDocIdList);

	String convertDocIdListToStr(String[] selectSuiteDocIdList);
	
	List<Map<String, Object>> selectAlphaElecDocList(Map<String, Object> param);

	Map<String, Object> selectAuthApproveDocCount(SuiteDBCnntVO suiteDBCnntVO, SuiteBaseInfoVO suiteBaseInfoVO);

	Map<String, Object> selectViewDocCount(SuiteDBCnntVO suiteDBCnntVO, SuiteBaseInfoVO suiteBaseInfoVO);

	List<Map<String, Object>> selectAuthApproveDocList(SuiteDBCnntVO suiteDBCnntVO, Map<String, Object> param);

	List<Map<String, Object>> selectViewDocList(SuiteDBCnntVO suiteDBCnntVO, Map<String, Object> param);

	List<Map<String, Object>> selectElecDocArtList(Map<String, Object> param);

	void insertAlphaAuthApproveDoc(Map<String, Object> param);

	void insertAlphaViewDoc(Map<String, Object> param);

	void deleteBpmArt(Map<String, Object> param);

	void deleteBpmArtPerm(Map<String, Object> param);

	void deleteBpmAttachFile(Map<String, Object> param);

	void deleteBpmReadRecord(Map<String, Object> param);

	List<Map<String, Object>> selectSuiteBoardCommentList(SuiteDBCnntVO suiteDBCnntVO, Map<String, Object> param);

	List<Map<String, Object>> selectSuiteDocCommentList(SuiteDBCnntVO suiteDBCnntVO, Map<String, Object> param);

	void createCommentTableBackup(Map<String, Object> param);

	void createCommentCountTableBackup(Map<String, Object> param);

	void updateDocIdTmigInfo(Map<String, Object> param);

	Map<String, Object> selectTmigInfoDoc(Map<String, Object> param);

	void updateFailDocId(Map<String, Object> param);

}


