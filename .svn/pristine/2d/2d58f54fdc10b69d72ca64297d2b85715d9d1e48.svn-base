package neos.migration.suite.dao;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Repository;

import egovframework.com.cmm.service.impl.EgovComAbstractDAO;
import neos.cmm.db.CommonSqlDAO;
import neos.migration.suite.vo.SuiteBaseInfoVO;


@Repository("ExecuteAlphaDAO")
public class ExecuteAlphaDAO extends EgovComAbstractDAO {
	
	@Resource(name = "commonSql")
	private CommonSqlDAO commonSql;
	
	public Map<String, String> getAlphaInfo(Map<String, Object> params) {
		
		return (Map<String, String>) commonSql.select("ExecuteAlphaDAO.GetAlphaInfo", params);
	}

	public Map<String, Object> getSuiteInfo(Map<String, Object> params) {
			
		return (Map<String, Object>) commonSql.select("ExecuteAlphaDAO.GetSuiteInfo", params);
	}

	public List<Map<String, Object>> selectAlphaDocBoxList(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return (List<Map<String, Object>>) commonSql.list("ExecuteAlphaDAO.selectAlphaDocBoxList", params);
	}

	public List<Map<String, Object>> selectAlphaElecDocList(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return (List<Map<String, Object>>) commonSql.list("ExecuteAlphaDAO.selectAlphaElecDocList", params);
	}

	public List<Map<String, Object>> selectElecDocArtList(Map<String, Object> param) {
		// TODO Auto-generated method stub
		return (List<Map<String, Object>>) commonSql.list("ExecuteAlphaDAO.selectElecDocArtList", param);
	}

	public void insertAlphaAuthApproveDoc(Map<String, Object> param) {
		// TODO Auto-generated method stub
		commonSql.insert("ExecuteAlphaDAO.insertAlphaAuthApproveDoc", param);
	}

	public void insertAlphaViewDoc(Map<String, Object> param) {
		commonSql.insert("ExecuteAlphaDAO.insertAlphaViewDoc", param);
		
	}

	public void deleteBpmArt(Map<String, Object> param) {
		commonSql.delete("ExecuteAlphaDAO.deleteBpmArt", param);
		
	}

	public void deleteBpmArtPerm(Map<String, Object> param) {
		commonSql.delete("ExecuteAlphaDAO.deleteBpmArtPerm", param);
		
	}

	public void deleteBpmAttachFile(Map<String, Object> param) {
		commonSql.delete("ExecuteAlphaDAO.deleteBpmAttachFile", param);
		
	}

	public void deleteBpmReadRecord(Map<String, Object> param) {
		commonSql.delete("ExecuteAlphaDAO.deleteBpmReadRecord", param);
		
	}

	public void createCommentTableBackup(Map<String, Object> param) {
		commonSql.update("ExecuteAlphaDAO.createCommentTableBackup", param);
	}

	public void createCommentCountTableBackup(Map<String, Object> param) {
		commonSql.update("ExecuteAlphaDAO.createCommentCountTableBackup", param);
	}
	
	

	public void createBpmArtTableBackup(Map<String, Object> param) {
		commonSql.update("ExecuteAlphaDAO.createBpmArtTableBackup", param);
	}

	public void createBpmArtPermTableBackup(Map<String, Object> param) {
		commonSql.update("ExecuteAlphaDAO.createBpmArtPermTableBackup", param);
	}

	public void createBpmAttachFileTableBackup(Map<String, Object> param) {
		commonSql.update("ExecuteAlphaDAO.createBpmAttachFileTableBackup", param);
	}

	public void createBpmReadRecordTableBackup(Map<String, Object> param) {
		commonSql.update("ExecuteAlphaDAO.createBpmReadRecordTableBackup", param);
	}

	public void createBpmDirectoryTableBackup(Map<String, Object> param) {
		commonSql.update("ExecuteAlphaDAO.createBpmDirectoryTableBackup", param);
	}

	public void updateDocIdTmigInfo(Map<String, Object> param) {
		commonSql.update("ExecuteAlphaDAO.updateDocIdTmigInfo", param);
		
	}

	public Map<String, Object> selectTmigInfoDoc(Map<String, Object> param) {
		return (Map<String, Object>) commonSql.select("ExecuteAlphaDAO.selectTmigInfoDoc", param);
	}

	public void updateFailDocId(Map<String, Object> param) {
		commonSql.update("ExecuteAlphaDAO.updateFailDocId", param);
	}
	

}
