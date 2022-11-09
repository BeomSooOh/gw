package neos.cmm.systemx.author.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import egovframework.com.cmm.service.impl.EgovComAbstractDAO;
import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * 
 * @title 권한 정보 관리 DAO
 * @version 
 * @dscription 
 *
 */
@Repository("AuthorManageDAO")
public class AuthorManageDAO extends EgovComAbstractDAO {

	/**
     * 권한정보 목록을 가져온다.
     * 
     * @param AuthorManage authorManage
     * @throws Exception
     */
	@SuppressWarnings("unchecked")
	
	public Map<String, Object> selectAuthorList(Map<String, Object> paramMap) throws Exception 	{
	
		Map<String ,Object> resultMap = new HashMap<String ,Object>();
		List<EgovMap> resultList =  list("AuthorManageDAO.selectAuthorList", paramMap);
		
		resultMap.put("list", resultList) ;
		return resultMap;
	}
	
	/**
     * 권한 상세정보를 가져온다. 
     * 
     * @param AuthorManage authorManage
     * @return AuthorManage 
     * @throws Exception
     */
    @SuppressWarnings({ "unchecked", "deprecation" })
	public Map<String, Object> selectAuthorInfo(Map<String, Object> paramMap) throws Exception {    	    	
    	return (Map<String, Object>)select("AuthorManageDAO.selectAuthorInfo", paramMap);
    }	
    
    
    /**
	 * 권한 정보 삭제
	 * @param AuthorManage authorManage
	 * @exception Exception
	 */
	public String deleteAuthCode(Map<String, Object> paramMap) throws Exception {
		delete("AuthorManageDAO.deleteAuthCode", paramMap);
		return "delete";
	}
	
	public void deleteAuthCodeMulti(Map<String, Object> paramMap) throws Exception {
		delete("AuthorManageDAO.deleteAuthCodeMulti", paramMap);
	}
	
	// 사용자 권한 삭제
	public String deleteAuthorRelate(Map<String, Object> paramMap) throws Exception {
		delete("AuthorManageDAO.deleteAuthorRelate", paramMap);
		return "delete";
	}	

	// 직책/직급권한 삭제
	public String deleteAuthorClass(Map<String, Object> paramMap) throws Exception {
		delete("AuthorManageDAO.deleteAuthorClass", paramMap);
		return "delete";
	}

	// 메뉴권한 삭제
	public String deleteAuthorMenu(Map<String, Object> paramMap) throws Exception {
		delete("AuthorManageDAO.deleteAuthorMenu", paramMap);
		return "delete";
	}	
	
	/**
     * 권한 정보를 등록한다.
     * 
     * @param AuthorManage authorManage
     * @throws Exception
     */
    public String insertAuthCode(Map<String, Object> paramMap) throws Exception {
	
    	insert("AuthorManageDAO.insertAuthCode", paramMap);    	
    	return "insert";
    }
    
    public String insertAuthCodeMulti(Map<String, Object> paramMap) throws Exception {
    	insert("AuthorManageDAO.insertAuthCodeMulti", paramMap);
    	return "insert";
    }
    
    // 권한 등록
    public String insertAuthorRelate(Map<String, Object> paramMap) throws Exception {
    	insert("AuthorManageDAO.insertAuthorRelate", paramMap);    	
    	return "insert";
    }  
    
    // 직책/직급권한 등록
    public String insertAuthorClass(Map<String, Object> paramMap) throws Exception {
    	
    	insert("AuthorManageDAO.insertAuthorClass", paramMap);    	
    	return "insert";
    }

    // 메뉴권한 등록
    public String insertAuthorMenu(Map<String, Object> mp) throws Exception {
    	
    	insert("AuthorManageDAO.insertAuthorMenu", mp);    	
    	return "insert";
    }    
    
    /**
     * 권한 정보를 수정한다.
     * 
     * @param AuthorManage authorManage
     * @throws Exception
     */
    public String updateAuthCode(Map<String, Object> paramMap) throws Exception {
	
    	update("AuthorManageDAO.updateAuthCode", paramMap);    	
    	return "update";
    }
    
    public String updateAuthCodeMulti(Map<String, Object> paramMap) throws Exception {
    	
    	update("AuthorManageDAO.updateAuthCodeMulti", paramMap);
    	return "update";
    }

    /**
     * 권한부여정보를 검색
     * 
     * @param AuthorManage authorManage
     * @throws Exception
     */
	@SuppressWarnings("unchecked")
	public Map<String, Object> selectAuthorRelateList(Map<String, Object> paramMap) throws Exception 	{
		Map<String ,Object> resultMap = new HashMap<String ,Object>();
		List<EgovMap> resultList =  list("AuthorManageDAO.selectAuthorRelateList", paramMap);
		resultMap.put("list", resultList) ;
		return resultMap;		
		
	}
	
	@SuppressWarnings("deprecation")
	public String getAuthorRelateGroup(Map<String, Object> paramMap) {
		return (String) select("AuthorManageDAO.getAuthorRelateGroup", paramMap);
	}
    	
	@SuppressWarnings("unchecked")
	public Map<String, Object> selectAuthorClassList(Map<String, Object> paramMap) throws Exception 	{
		
		Map<String ,Object> resultMap = new HashMap<String ,Object>();
		List<Map<String,Object>> resultList =  list("AuthorManageDAO.selectAuthorClassList", paramMap);
		
		resultMap.put("list", resultList) ;
		return resultMap;
		
	}	
	
	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> selectMenuTreeList(Map<String, Object> params) {
		return (List<Map<String, Object>>) list("AuthorManageDAO.selectMenuTreeList", params);
		
	}
	
	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> selectAdmMenuTreeList(Map<String, Object> params) {
		return (List<Map<String, Object>>) list("AuthorManageDAO.selectAdmMenuTreeList", params);
		
		
	}

	
	/** 마스터권한 설정 **/
	@SuppressWarnings("unchecked")
	public Map<String, Object> getAuthorMasterList(Map<String, Object> params) {
		Map<String ,Object> resultMap = new HashMap<String ,Object>();
		List<EgovMap> resultList =  list("AuthorManageDAO.getAuthorMasterList", params);
		resultMap.put("list", resultList) ;
		return resultMap;
	}

	public int updateAuthorMaster(Map<String, Object> params) {
		return update("AuthorManageDAO.updateAuthorMaster", params);
		
	}

	
}
