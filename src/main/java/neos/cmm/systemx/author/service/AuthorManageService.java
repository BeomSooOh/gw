package neos.cmm.systemx.author.service;

import java.util.List;
import java.util.Map;

/**
 * 
 * @title 권한 정보 관리 Service interface
 * @version 
 * @dscription
 *
 */
public interface AuthorManageService {

	/**
     * 권한정보 목록을 가져온다.
     * 
     * @param AuthorManage authorManage
     * @throws Exception
     */
	public Map<String, Object> selectAuthorList(Map<String, Object> paramMap) throws Exception;
	
	/**
     * 권한 상세정보를 가져온다. 
     * 
     * @param AuthorManage authorManage
     * @return AuthorManage 
     * @throws Exception
     */
    public Map<String, Object> selectAuthorInfo(Map<String, Object> paramMap) throws Exception;
    
    /**
	 * 권한 정보 삭제
	 * @param AuthorManage authorManage
	 * @exception Exception
	 */
    // 권한 코드 삭제 
	public String deleteAuthCode(Map<String, Object> paramMap) throws Exception;
	
	// 권한 부여 삭제 (사용자 , 부서)
	public String deleteAuthorRelate(Map<String, Object> paramMap) throws Exception;
	
	// 권한부여 - 직책/직급권한 삭제
	public String deleteAuthorClass(Map<String, Object> paramMap) throws Exception;
		
	// 메뉴권한 삭제
	public String deleteAuthorMenu(Map<String, Object> paramMap) throws Exception;	
	
	/**
     * 권한 정보를 등록한다.
     * 
     * @param AuthorManage authorManage
     * @throws Exception
     */
    public String insertAuthCode(Map<String, Object> paramMap) throws Exception;
    
    public String insertAuthorRelate(Map<String, Object> paramMap) throws Exception;

    // 권한부여 - 직급/직책  등록
    public String insertAuthorClass(Map<String, Object> paramMap) throws Exception;

    // 메뉴권한 등록insertAuthMenu
    public String insertAuthorMenu(Map<String, Object> paramMap) throws Exception;     
    
    /**
     * 권한 정보를 수정한다.
     * 
     * @param AuthorManage authorManage
     * @throws Exception
     */
    public String updateAuthCode(Map<String, Object> paramMap) throws Exception;
    
    /**
     * 권한부여정보를 검색
     * 
     * @param AuthorManage authorManage
     * @throws Exception
     */
    public Map<String, Object> selectAuthorRelateList(Map<String, Object> paramMap) throws Exception;
    
	public String getAuthorRelateGroup(Map<String, Object> paramMap)throws Exception;
	
	public Map<String, Object> selectAuthorClassList(Map<String, Object> paramMap) throws Exception;
		
	public List<Map<String, Object>> selectMenuTreeList(Map<String, Object> params);

	public Map<String, Object> getAuthorMasterList(Map<String, Object> params) throws Exception;
	
	/**
	 * 마스터 권한 삭제 
	 * @param paramMap
	 * @return
	 * @throws Exception 
	 */
	public int updateAuthorMaster(Map<String, Object> paramMap) throws Exception;


}
