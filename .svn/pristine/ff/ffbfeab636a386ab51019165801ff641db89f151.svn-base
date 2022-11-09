package neos.cmm.systemx.secGrade.dao;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import egovframework.com.cmm.service.impl.EgovComAbstractDAO;
import neos.cmm.systemx.secGrade.vo.CompInfo;
import neos.cmm.systemx.secGrade.vo.SecGrade;
import neos.cmm.systemx.secGrade.vo.SecGradeUser;

@Repository("SecGradeDAO")
public class SecGradeDAO extends EgovComAbstractDAO {

	//보안등급목록
	public List<SecGrade> selectSecGrade(Map<String, Object> params) {
		return list("secGradeDAO.selectSecGrade", params);
	}

	//보안등급사용자 저장
	public void insertSecGradeUser(Map<String, Object> params) {
		insert("secGradeDAO.insertSecGradeUser", params);
	}

	public List<SecGradeUser> selectSecGradeUser(Map<String, Object> params) {
		return list("secGradeDAO.selectSecGradeUser", params);
	}

	public List<String> selectDeptSeqFromCompSeq(Map<String, Object> params) {
		return list("secGradeDAO.selectDeptSeqFromCompSeq", params);
	}

	public void deleteSecGradeUser(Map<String, Object> params) {
		delete("secGradeDAO.deleteSecGradeUser", params);
	}

	public SecGrade selectSecGradeOne(Map<String, Object> params) {
		return (SecGrade) select("secGradeDAO.selectSecGradeOne", params);
	}

	public void updateSecGrade(Map<String, Object> params) {
		update("secGradeDAO.updateSecGrade", params);
	}

	public void insertSecGrade(Map<String, Object> params) {
		insert("secGradeDAO.insertSecGrade", params);
	}

	public CompInfo selectCompInfo(Map<String, Object> params) {
		return (CompInfo) select("secGradeDAO.selectCompInfo", params);
	}

	public SecGrade selectSecGradeOneRoot(Map<String, Object> params) {
		return (SecGrade) select("secGradeDAO.selectSecGradeOneRoot", params);
	}

	public int deleteSecGrade(Map<String, Object> params) {
		return delete("secGradeDAO.deleteSecGrade", params);
	}
	
	public int updateSecGradeAllChild(Map<String, Object> params) {
		return update("secGradeDAO.updateSecGradeAllChild", params);
	}
	
	public List<SecGrade> selectSecGradeAllChild(Map<String, Object> params) {
		return list("secGradeDAO.selectSecGradeAllChild", params);
	}
	public List<SecGrade> selectSecGradeDirectChild(Map<String, Object> params) {
		return list("secGradeDAO.selectSecGradeDirectChild", params);
	}
	public String selectSecGradeAllChildString(Map<String, Object> params) {
		return (String) select("secGradeDAO.selectSecGradeAllChildString", params);
	}
	public String selectSecGradeAllParentString(Map<String, Object> params) {
		return (String) select("secGradeDAO.selectSecGradeAllParentString", params);
	}
	public List<SecGrade> selectSecGradeAllParent(Map<String, Object> params) {
		return list("secGradeDAO.selectSecGradeAllParent", params);
	}
	public void updateSecGradeChild(Map<String, Object> params) {
		update("secGradeDAO.updateSecGradeChild", params);
	}
	
	public List<String> selectSecGradeUserFromUserInfo(Map<String, Object> params) {
		return list("secGradeDAO.selectSecGradeUserFromUserInfo", params);
	}

	public String selectSecGradeByCompAndDepth(Map<String, Object> params) {
		return (String) select("secGradeDAO.selectSecGradeByCompAndDepth", params);
	}
	
}