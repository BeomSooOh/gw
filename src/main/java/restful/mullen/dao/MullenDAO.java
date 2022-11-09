package restful.mullen.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import egovframework.com.cmm.service.impl.EgovComAbstractDAO;
import restful.mullen.vo.MullenAuthStatus;
import restful.mullen.vo.MullenFriend;
import restful.mullen.vo.MullenLoginVO;
import restful.mullen.vo.MullenUser;

@Repository("MullenDAO")
public class MullenDAO extends EgovComAbstractDAO {
	
	@SuppressWarnings("unchecked")
	public List<MullenLoginVO> actionLoginMobile(MullenLoginVO vo) throws Exception {
		return list("mullenDAO.actionLoginMobile", vo);
	}
	
	public String selectLoginPassword(MullenLoginVO vo) throws Exception{
        return (String)select("mullenDAO.selectLoginPassword" , vo);
    }
	
	public List<Map<String,Object>> selectLoginVO(MullenLoginVO vo) throws Exception {
		return list("mullenDAO.selectLoginVO", vo);
	}
	
	//t_co_emp_multi
	public int updateUserName(HashMap<String, Object> params) throws Exception {
		return update("mullenDAO.updateUserName", params);
	}

	//t_co_emp
	public void updateUserOutMail(HashMap<String, Object> params) {
		update("mullenDAO.updateUserOutMail", params);
	}
	
	//t_co_emp
	public void updateUserOutMailEmpty(HashMap<String, Object> params) {
		update("mullenDAO.updateUserOutMailEmpty", params);
	}
	
	public void updateMullenEmailAddrEmpty(HashMap<String, Object> params) {
		update("mullenDAO.updateMullenEmailAddrEmpty", params);
		
	}

	//t_co_mullen 멀린 인증 상태 변경
	public int updateMullenStatus(HashMap<String, Object> params) {
		return update("mullenDAO.updateMullenStatus", params);
	}

	public MullenAuthStatus selectAuthStatus(HashMap<String, Object> params) throws Exception {
		return (MullenAuthStatus) select("mullenDAO.selectAuthStatus", params);
	}

	public MullenUser selectEmailUser(HashMap<String, Object> params) {
		return (MullenUser) select("mullenDAO.selectEmailUser", params);
	}
	
	public MullenUser selectEmpSeqByEmailUser(HashMap<String, Object> params) {
		return (MullenUser) select("mullenDAO.selectEmpSeqByEmailUser", params);
	}

	public int updateAuthComplete(HashMap<String, Object> params) {
		return update("mullenDAO.updateAuthComplete", params);
	}

	public List<MullenUser> selectEmpSeqByGroupSeq(HashMap<String, Object> params) {
		return list("mullenDAO.selectEmpSeqByGroupSeq", params);
	}

	public int updateMyGroupId(HashMap<String, Object> params) {
		return update("mullenDAO.updateMyGroupId", params);
	}

	public MullenFriend selectMullenFriend(HashMap<String, Object> params) {
		return (MullenFriend) select("mullenDAO.selectMullenFriend", params);
	}

	public int deleteMullenFriend(HashMap<String, Object> params) {
		return delete("mullenDAO.deleteMullenFriend", params);
	}
	
	public int updateMullenFriend(HashMap<String, Object> params) {
		return update("mullenDAO.updateMullenFriend", params);
	}

	public void insertMullenFriend(HashMap<String, Object> params) {
		insert("mullenDAO.insertMullenFriend", params);
	}

	public List<Map<String, Object>> selectRecvReq(HashMap<String, Object> params) {
		return list("mullenDAO.selectRecvReq", params);
	}

	public List<Map<String, Object>> selectSendReq(HashMap<String, Object> params) {
		return list("mullenDAO.selectSendReq", params);
	}

	public HashMap<String, String> selectMemberInfo(HashMap<String, Object> params) {
		return (HashMap<String, String>) select("mullenDAO.selectMemberInfo", params);
	}
	
	public void insertAddEmpForEmp(HashMap<String, Object> params) {
		insert("mullenDAO.insertAddEmpForEmp", params);
	}
	
	public void insertAddEmpForEmpMulti(HashMap<String, Object> params) {
		insert("mullenDAO.insertAddEmpForEmpMulti", params);
	}
	
	public void insertAddEmpForEmpDept(HashMap<String, Object> params) {
		insert("mullenDAO.insertAddEmpForEmpDept", params);
	}
	
	public void insertAddEmpForEmpDeptMulti(HashMap<String, Object> params) {
		insert("mullenDAO.insertAddEmpForEmpDeptMulti", params);
	}
	
	public void insertAddEmpForEmpComp(HashMap<String, Object> params) {
		insert("mullenDAO.insertAddEmpForEmpComp", params);
	}

	public void insertAddEmpForAuthRelate(HashMap<String, Object> params) {
		insert("mullenDAO.insertAddEmpForAuthRelate", params);
		
	}

	public void insertAddEmpForMcalendar(HashMap<String, Object> params) {
		insert("mullenDAO.insertAddEmpForMcalendar", params);
		
	}

	public int selectMcalSeqCount() {
		return (Integer) select("mullenDAO.selectMcalSeqCount");
	}

	public void insertAddEmpForMcalUser(HashMap<String, Object> params) {
		insert("mullenDAO.insertAddEmpForMcalUser", params);
		
	}

	public void insertAddEmpForMcalEmpStyle(HashMap<String, Object> params) {
		insert("mullenDAO.insertAddEmpForMcalEmpStyle", params);
		
	}

	public void insertAddEmpForMullen(HashMap<String, Object> params) {
		insert("mullenDAO.insertAddEmpForMullen", params);		
		
	}
		
	public void deleteDelEmpForEmp(HashMap<String, Object> params) {
		delete("mullenDAO.deleteDelEmpForEmp", params);
	}
	
	public void deleteDelEmpForEmpMulti(HashMap<String, Object> params) {
		delete("mullenDAO.deleteDelEmpForEmpMulti", params);
	}
	
	public void deleteDelEmpForEmpDept(HashMap<String, Object> params) {
		delete("mullenDAO.deleteDelEmpForEmpDept", params);
	}
	
	public void deleteDelEmpForEmpDeptMulti(HashMap<String, Object> params) {
		delete("mullenDAO.deleteDelEmpForEmpDeptMulti", params);
	}
	
	public void deleteDelEmpForEmpComp(HashMap<String, Object> params) {
		delete("mullenDAO.deleteDelEmpForEmpComp", params);
	}

	public void deleteDelEmpForAuthRelate(HashMap<String, Object> params) {
		delete("mullenDAO.deleteDelEmpForAuthRelate", params);
		
	}

	public void deleteDelEmpForMcalendar(HashMap<String, Object> params) {
		delete("mullenDAO.deleteDelEmpForMcalendar", params);
		
	}

	public void deleteDelEmpForMcalUser(HashMap<String, Object> params) {
		delete("mullenDAO.deleteDelEmpForMcalUser", params);
		
	}

	public void deleteDelEmpForMcalEmpStyle(HashMap<String, Object> params) {
		delete("mullenDAO.deleteDelEmpForMcalEmpStyle", params);
		
	}

	public void deleteDelEmpForMullen(HashMap<String, Object> params) {
		delete("mullenDAO.deleteDelEmpForMullen", params);		
		
	}

	public MullenUser selectEmailAuthKey(HashMap<String, Object> params) {
		return (MullenUser) select("mullenDAO.selectEmailAuthKey", params);
	}

	public MullenUser getUserEmail(HashMap<String, Object> params) {
		return (MullenUser) select("mullenDAO.getUserEmail", params);
	}

	public void setUserInfo(HashMap<String, Object> params) {
		update("mullenDAO.setUserInfo", params);
	}

	public MullenUser validationCheck(HashMap<String, Object> params) {
		return (MullenUser) select("mullenDAO.validationCheck", params);
	}

	public MullenAuthStatus checkAuthStatus(HashMap<String, Object> params) {
		return (MullenAuthStatus) select("mullenDAO.checkAuthStatus", params);
	}

	public void setMullenGroupInfo(HashMap<String, Object> params) {
		insert("mullenDAO.setMullenGroupInfo", params);
	}

	public Object getMullenGroupList(HashMap<String, Object> params) {
		return list("mullenDAO.getMullenGroupList", params);
	}

	public void updateMobileTelNum(HashMap<String, Object> params) {
		update("mullenDAO.updateMobileTelNum", params);
	}

	public Object searchMullenUser(HashMap<String, Object> params) {
		return list("mullenDAO.searchMullenUser", params);
	}

	public void reqGroup(HashMap<String, Object> params) {
		insert("mullenDAO.reqGroup", params);
	}

	public void reqHandling(HashMap<String, Object> params) {
		update("mullenDAO.reqHandling", params);
	}

	public Object reqList(HashMap<String, Object> params) {
		return list("mullenDAO.reqList", params);
	}

	public void delUserGroup(HashMap<String, Object> params) {
		delete("mullenDAO.delUserGroup", params);		
	}

	public void addUserGroup(HashMap<String, Object> params) {
		insert("mullenDAO.addUserGroup", params);
	}

	public void initUserGroup(HashMap<String, Object> params) {
		insert("mullenDAO.initUserGroup", params);
	}

	public Object getGroupId(HashMap<String, Object> params) {
		return select("mullenDAO.getGroupId", params);
	}

	public Object getGroupIdBySeq(HashMap<String, Object> params) {
		return select("mullenDAO.getGroupIdBySeq", params);
	}

	public MullenUser getMullenUserInfoByEmailAddr(HashMap<String, Object> params) {
		return (MullenUser) select("mullenDAO.getMullenUserInfoByEmailAddr", params);
	}

	public int deleteUser(HashMap<String, Object> params) {
		return update("mullenDAO.deleteUser", params);
	}

	public void delUserRelate(HashMap<String, Object> params) {
		delete("mullenDAO.delUserRelate", params);
	}

	public Map<String, Object> getMullenAgreementInfo(Map<String, Object> params) {
		return (Map<String, Object>) select("mullenDAO.getMullenAgreementInfo", params);
	}

	public void setMullenAgreement(Map<String, Object> param) {
		insert("mullenDAO.setMullenAgreement", param);
	}

	
}
