package restful.messenger.dao;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import restful.messenger.vo.MessengerLoginVO;
import egovframework.com.cmm.service.impl.EgovComAbstractDAO;

@Repository("MessengerDAO")
public class MessengerDAO extends EgovComAbstractDAO {
	/**
	 * 모바일 로그인 처리
	 * @param - 조회할 정보가 담긴 RestVO
	 * @return 조회결과
	 * @exception Exception
	 */
	@SuppressWarnings("unchecked")
	public List<MessengerLoginVO> actionLoginMobile(MessengerLoginVO vo) throws Exception {
		return list("MessengerDAO.actionLoginMobile", vo);
	}

	public List<Map<String,Object>> selectLoginVO(MessengerLoginVO vo) throws Exception {
		return list("MessengerDAO.selectLoginVO", vo);
	}	

    public String selectLoginPassword(MessengerLoginVO vo) throws Exception{
        return (String)select("MessengerDAO.selectLoginPassword" , vo);
    }

	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> selectOrgImgList(Map<String,Object> vo) {		
		List<Map<String, Object>> groupList = list("MessengerDAO.selectOrgImgListForGroup", vo);
		List<Map<String, Object>> compList = list("MessengerDAO.selectOrgImgListForComp", vo);
		
		if(compList.size() == 0) {
			return groupList;
		}
		else {
			return compList;
		}
	}

	public List<Map<String,Object>> selectAlertInfo(MessengerLoginVO vo) throws Exception {
		return list("MessengerDAO.selectAlertInfo", vo);
	}		
	
	public List<Map<String, Object>> selectOptionListMessanger(Map<String, Object> p) {
		return (List<Map<String, Object>>)list("MessengerDAO.selectOptionListMessanger", p); 
	}
	
	public List<Map<String, Object>> selectDownViewerListMessanger(Map<String, Object> param) {
		return (List<Map<String, Object>>)list("MessengerDAO.selectDownViewerMessanger", param);
	}
	
	public List<Map<String, Object>> selectOptionListMessenger(Map<String, Object> param) {
		return (List<Map<String, Object>>)list("MessengerDAO.selectOptionListMobile", param);
	}
	
}
