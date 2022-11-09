package neos.cmm.menu.service.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import egovframework.com.cmm.service.impl.EgovComAbstractDAO;


@Repository("MenuManageDAO")
public class MenuManageDAO extends EgovComAbstractDAO {
 

    /* bizbox a */
    @SuppressWarnings({ "unchecked", "deprecation" })
	public Map<String, Object> menuInfoView(Map<String, Object> paramMap) throws Exception {   
    		
    	Map<String, Object> info = new HashMap<>();
    	if(paramMap.get("type").toString().equals("USER")){
    		info = (Map<String, Object>) select("MenuManageDAO.menuInfoView", paramMap);
    	}else{
    		info = (Map<String, Object>) select("MenuManageDAO.admMenuInfoView", paramMap);
    	}
		return  info;    		
    		
    }    

    /**
     * 메뉴 정보를 등록한다.
     * 
     * @param Map<String, Object> paramMap
     * @return void
     * @throws Exception
     */
    public void insertMenu(Map<String, Object> paramMap) throws Exception {

    	insert("MenuManageDAO.insertMenu", paramMap);       	
    }
    
    /**
     * 메뉴 상세정보를 등록한다.
     * 
     * @param Map<String, Object> paramMap
     * @return void 
     * @throws Exception
     */
    public void insertMenuMulti(Map<String, Object> paramMap) throws Exception {  
        	
    	insert("MenuManageDAO.insertMenuMulti", paramMap); 
            	
    }

    
    /**
     * 메뉴 정보를 수정한다.
     * 
     * @param MenuInfo
     * @return String
     * @throws Exception
     */
    public void updateMenu(Map<String, Object> paramMap) throws Exception {	    	
    	update("MenuManageDAO.updateMenu", paramMap);
    }  
    
    /**
     * 메뉴 상세정보를 수정한다.
     * 
     * @param MenuInfo
     * @return String
     * @throws Exception
     */
    public void updateMenuMulti(Map<String, Object> paramMap) throws Exception {   	
    	update("MenuManageDAO.updateMenuDetail", paramMap);   
    }  
    
    
    /**
     * 메뉴 정보를 삭제한다.
     * 
     * @param Map<String, Object> paramMap
     * @throws Exception
     */
    public void deleteMenu(Map<String, Object> paramMap) throws Exception {
    	    
    	update("MenuManageDAO.updateMenuDelYn", paramMap);
//    	    //메뉴정보삭제
//         	delete("MenuManageDAO.deleteMenu", paramMap);
//            //메뉴상세정보삭제
//        	delete("MenuManageDAO.deleteMenuMulti", paramMap);	
        //메뉴권한 삭제
        delete("MenuManageDAO.deleteMenuAuth", paramMap);  
        //메뉴회사권한 삭제
        delete("MenuManageDAO.deleteMenuComp",paramMap);
        	
    }    
    
    @SuppressWarnings("unchecked")
	public List<Map<String,Object>> selectMenuTreeList(Map<String,Object> paramMap) {
    	return (List<Map<String, Object>>) list("MenuManageDAO.selectMenuTreeList", paramMap);
    }
    
    @SuppressWarnings("unchecked")
	public Map<String, Object> selectFirstMenuInfo(Map<String,Object> paramMap) {
    	return (Map<String, Object>) select("MenuManageDAO.selectFirstMenuInfo", paramMap);
    }
    
    @SuppressWarnings("unchecked")
	public List<Map<String, Object>> selectAdminMenuTreeList(Map<String,Object> paramMap) {
    	return (List<Map<String, Object>>) list("MenuManageDAO.selectAdminMenuTreeList", paramMap);
    }

	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> selectAdminMenuTreeListAuth(Map<String, Object> params) {
		return (List<Map<String, Object>>) list("MenuManageDAO.selectAdminMenuTreeListAuth", params);
	}

	@SuppressWarnings({ "unchecked" })
	public Map<String, Object> selectFirstAdminMenuInfo(Map<String, Object> params) {
		return (Map<String, Object>) select("MenuManageDAO.selectFirstAdminMenuInfo", params);
	}

	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> selectMenuListOfUrl(
			Map<String, Object> params) {
		return (List<Map<String, Object>>) list("MenuManageDAO.selectMenuListOfUrl", params);
	}

	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> selectMenuAdminListOfUrl(Map<String, Object> params) {
		return (List<Map<String, Object>>) list("MenuManageDAO.selectMenuAdminListOfUrl", params);
	}

	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> selectMyMenuList(Map<String, Object> params) {
		return (List<Map<String, Object>>) list("MenuManageDAO.selectMyMenuList", params);
	}

	public void insertMyMenuList(Map<String, Object> param) {
		insert("MenuManageDAO.insertMyMenuList", param);
		
	}

	public void deleteMyMenuList(Map<String, Object> params) {
		delete("MenuManageDAO.deleteMyMenuList", params);
		
	}

	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> selectMenuListOfMenuNo(Map<String, Object> params) {
		return (List<Map<String, Object>>) list("MenuManageDAO.selectMenuListOfMenuNo", params);
	}
	
	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> selectEaEmpMenuTreeList(Map<String, Object> paramMap) {
		return (List<Map<String, Object>>) list("MenuManageDAO.selectEaEmpMenuTreeList", paramMap);
	}

	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> selectComptList(Map<String, Object> params) {
		return (List<Map<String, Object>>) list("MenuManageDAO.selectCompList", params);
	}

	public void insertMenuComp(Map<String, Object> params) {
		insert("MenuManageDAO.insertMenuComp", params);
	}
	
	public void deleteMenuComp(Map<String, Object> params) {
		delete("MenuManageDAO.deleteMenuComp", params);
	}

	public List<Map<String, Object>> selectMenuJsTreeList(Map<String, Object> params) {
		return (List<Map<String, Object>>) list("MenuManageDAO.selectMenuJsTreeList", params);
	}

	public List<Map<String, Object>> selectAdminMenuJsTreeList(Map<String, Object> params) {
		return (List<Map<String, Object>>) list("MenuManageDAO.selectAdminMenuJsTreeList", params);
	}

	public List<Map<String, Object>> selectEAPrivateMenuTreeList(Map<String, Object> params) {
		return  (List<Map<String, Object>>) list("MenuManageDAO.selectEAPrivateMenuTreeList", params);
	}

	public Integer getMenuNo(Map<String, Object> paramMap) {
		return (Integer) select("MenuManageDAO.getMenuNo", paramMap);
	}

	public Integer getMenuChlidCnt(Map<String, Object> paramMap) {
		return (Integer) select("MenuManageDAO.getMenuChlidCnt", paramMap); 
		
	}

	public List<Map<String, Object>> selectMenuComboBoxList(Map<String, Object> paramMap) {
		// TODO Auto-generated method stub
		return (List<Map<String, Object>>) list("MenuManageDAO.selectComboBOxList", paramMap);
	}
	
	public List<Map<String, Object>> selectMenuComboBoxSubList(Map<String, Object> paramMap) {
		// TODO Auto-generated method stub
		return (List<Map<String, Object>>) list("MenuManageDAO.selectComboBOxSubList", paramMap);
	}	

	public List<Map<String, Object>> selsetMenuOpenCompList(Map<String, Object> paramMap) {
		// TODO Auto-generated method stub
		return (List<Map<String, Object>>) list("MenuManageDAO.selectMenuCompList", paramMap);
	}

	public void insertMenuHistory(Map<String, Object> paramMap) {
		insert("MenuManageDAO.insertMenuHistory", paramMap);
	}
}
