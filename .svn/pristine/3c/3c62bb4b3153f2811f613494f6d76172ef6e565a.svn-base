package neos.cmm.systemx.author.service.impl;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import egovframework.rte.psl.dataaccess.util.EgovMap;
import neos.cmm.db.CommonSqlDAO;
import neos.cmm.systemx.author.service.AuthorManageService;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

/**
 * 
 * @title 권한 정보 관리 Service
 * @version 
 * @dscription
 *
 */
@Service("AuthorManageService")
public class AuthorManageServiceImpl implements AuthorManageService {

	@Resource(name = "AuthorManageDAO")
	private AuthorManageDAO authorManageDAO;
	
	@Resource(name = "commonSql")
	private CommonSqlDAO commonSql;
	
	/**
     * 권한정보 목록을 가져온다.
     * 
     * @param AuthorManage authorManage
     * @throws Exception
     */
	public  Map<String, Object>  selectAuthorList(Map<String, Object> paramMap) throws Exception	{
		Map<String, Object> resultMap = null;
		resultMap =authorManageDAO.selectAuthorList(paramMap);
		return resultMap;
	}
	
	/**
     * 권한 상세정보를 가져온다. 
     * 
     * @param AuthorManage authorManage
     * @return AuthorManage 
     * @throws Exception
     */
    public Map<String, Object> selectAuthorInfo(Map<String, Object> paramMap) throws Exception{
    	return authorManageDAO.selectAuthorInfo(paramMap);
    }
    /**
	 * 권한 정보 삭제
	 * @param AuthorManage authorManage
	 * @exception Exception
	 */
	public String deleteAuthCode(Map<String, Object> paramMap) throws Exception {
		
		String result = "";
		
		JSONArray pTEAG = JSONArray.fromObject(paramMap.get("selectedList"));
		
		for (int i = 0; i < pTEAG.size(); i++) {
			
			JSONObject jsonOb = JSONObject.fromObject(pTEAG.get(i));
			Map<String,Object> item =  new HashMap<String,Object>();
			item.put("authorCode", jsonOb.get("authorCode"));
			
			result = authorManageDAO.deleteAuthCode(item);
			authorManageDAO.deleteAuthCodeMulti(item);
			
			authorManageDAO.deleteAuthorRelate(item);
			authorManageDAO.deleteAuthorClass(item);
			authorManageDAO.deleteAuthorMenu(item);
		}
		    	
    	return result;
	}
	
	public String deleteAuthorRelate(Map<String, Object> paramMap) throws Exception {
		
		String returnValue = "0";
		
		JSONArray ja = JSONArray.fromObject(paramMap.get("selectedList"));
			
		List<Map<String,Object>> list = new ArrayList<Map<String,Object>>();
			
		for (int i = 0; i < ja.size(); i++) {
			JSONObject jsonObject = JSONObject.fromObject(ja.get(i));
			Map<String,Object> item =  new HashMap<String,Object>();
			item.put("compSeq", jsonObject.get("COMP_SEQ"));
			item.put("deptSeq", jsonObject.get("DEPT_SEQ"));
			item.put("empSeq", jsonObject.get("EMP_SEQ"));
		
			list.add(item);
		}
		
		if (list.size() > 0) {
			paramMap.put("authorList", list);
			returnValue = authorManageDAO.deleteAuthorRelate(paramMap);
		}
		return returnValue;
	}	
	
	// 직책/직급권한 삭제
	public String deleteAuthorClass(Map<String, Object> paramMap) throws Exception {
		return authorManageDAO.deleteAuthorClass(paramMap);
	}
	
	// 메뉴권한 삭제
	public String deleteAuthorMenu(Map<String, Object> paramMap) throws Exception {
		return authorManageDAO.deleteAuthorMenu(paramMap);
	}
	
	/**
	 * 권한 코드 등록 t_co_authcode , t_co_authcode_multi 
	 */
    public String insertAuthCode(Map<String, Object> paramMap) throws Exception {
    	String result = "";
    	
    	authorManageDAO.insertAuthCode(paramMap);
    	
		if(!paramMap.get("authorNmKr").toString().equals("")){
   			paramMap.put("langCode", "kr");
   			paramMap.put("authorNm", paramMap.get("authorNmKr"));
   			result = authorManageDAO.insertAuthCodeMulti(paramMap);
   		}
   		if(!paramMap.get("authorNmEn").toString().equals("")){
   			paramMap.put("langCode", "en");
   			paramMap.put("authorNm", paramMap.get("authorNmEn"));
   			result = authorManageDAO.insertAuthCodeMulti(paramMap);
   		}
   		if(!paramMap.get("authorNmJp").toString().equals("")){
   			paramMap.put("langCode", "jp");
   			paramMap.put("authorNm", paramMap.get("authorNmJp"));
   			result = authorManageDAO.insertAuthCodeMulti(paramMap);
   		}
   		if(!paramMap.get("authorNmCn").toString().equals("")){
   			paramMap.put("langCode", "cn");
   			paramMap.put("authorNm", paramMap.get("authorNmCn"));
   			result = authorManageDAO.insertAuthCodeMulti(paramMap);
   		}
    	
    	//result = authorManageDAO.insertAuthCodeMulti(paramMap);
    	return result;
    }
    
    /**
     * 권한부여관리 사용자/부서 등록 
     */
    public String insertAuthorRelate(Map<String, Object> paramMap) throws Exception {
    	
		JSONArray pTEAG = JSONArray.fromObject(paramMap.get("selectedList"));

		List<Map<String,Object>> list = new ArrayList<Map<String,Object>>();
		
    	String result = "";
    	
    	authorManageDAO.deleteAuthorRelate(paramMap);
    	
    	for (int i = 0; i < pTEAG.size(); i++) {
    		JSONObject jsonOb = JSONObject.fromObject(pTEAG.get(i));
    		Map<String,Object> item =  new HashMap<String,Object>();
    		item.put("compSeq", jsonOb.get("compSeq"));
    		item.put("deptSeq", jsonOb.get("deptSeq"));
    		item.put("empSeq", jsonOb.get("empSeq"));
    		
    		list.add(item);
    	}
    	
    	if (list.size() > 0) {
    		paramMap.put("authorList", list);
    		authorManageDAO.insertAuthorRelate(paramMap);
    	}
    	
    	result = "insert";
    	return result;

    }   
    
    // 직책/직급권한 등록
    public String insertAuthorClass(Map<String, Object> paramMap) throws Exception {
    	return authorManageDAO.insertAuthorClass(paramMap);
    }

    /**
     * 메뉴-권한 등록
     */
    public String insertAuthorMenu(Map<String, Object> paramMap) throws Exception {
    	
		String result = "";
		
		JSONArray pTEAG = JSONArray.fromObject(paramMap.get("treeCheckList"));

		authorManageDAO.deleteAuthorMenu(paramMap);
		
		List<Map<String,Object>> list = new ArrayList<Map<String,Object>>();
		
		for (int i = 0; i < pTEAG.size(); i++) {
			JSONObject jsonOb = JSONObject.fromObject(pTEAG.get(i));
			Map<String,Object> item =  new HashMap<String,Object>();
			item.put("authorCode", paramMap.get("authorCode"));
			item.put("menuNo", jsonOb.get("seq"));
			
			list.add(item);
		}		
		
		if (list.size() > 0) {		
			Map<String, Object> authMp = new HashMap<String, Object>();
			authMp.put("authList", list);
			result = authorManageDAO.insertAuthorMenu(authMp);
		}
						
		return result;
    }    
    
    /**
     * 권한 정보를 수정한다.
     * 
     * @param AuthorManage authorManage
     * @throws Exception
     */
    public String updateAuthCode(Map<String, Object> paramMap) throws Exception{
    	
    	String result = "";
		
    	authorManageDAO.updateAuthCode(paramMap);
    	
   		if(!paramMap.get("authorNmKr").equals("")){
   			paramMap.put("langCode", "kr");
   			paramMap.put("authorNm", paramMap.get("authorNmKr"));
   			result = authorManageDAO.updateAuthCodeMulti(paramMap);
   		}
   		
   		if(!paramMap.get("authorNmEn").equals("")){
   			paramMap.put("langCode", "en");
   			paramMap.put("authorNm", paramMap.get("authorNmEn"));
   			result = authorManageDAO.updateAuthCodeMulti(paramMap);
   		}else{
   			Map<String, Object> para = new HashMap<String, Object>();
   			para.put("authorCode", paramMap.get("authorCode"));
   			para.put("langCode", "en");
   			commonSql.delete("AuthorManageDAO.delAuthorMulti", para);
   		}
   		
   		if(!paramMap.get("authorNmJp").equals("")){
   			paramMap.put("langCode", "jp");
   			paramMap.put("authorNm", paramMap.get("authorNmJp"));
   			result = authorManageDAO.updateAuthCodeMulti(paramMap);
   		}else{
   			Map<String, Object> para = new HashMap<String, Object>();
   			para.put("authorCode", paramMap.get("authorCode"));
   			para.put("langCode", "jp");
   			commonSql.delete("AuthorManageDAO.delAuthorMulti", para);
   		}
   		
   		if(!paramMap.get("authorNmCn").equals("")){
   			paramMap.put("langCode", "cn");
   			paramMap.put("authorNm", paramMap.get("authorNmCn"));
   			result = authorManageDAO.updateAuthCodeMulti(paramMap);
   		}else{   			
   			Map<String, Object> para = new HashMap<String, Object>();
   			para.put("authorCode", paramMap.get("authorCode"));
   			para.put("langCode", "cn");
   			commonSql.delete("AuthorManageDAO.delAuthorMulti", para);
   		}
   		
   		
    	result = authorManageDAO.updateAuthCodeMulti(paramMap);
    	return result;
    }

    /**
     * 권한부여정보를 검색
     */
	public Map<String, Object> selectAuthorRelateList(Map<String, Object> paramMap) throws Exception	{
		return authorManageDAO.selectAuthorRelateList(paramMap);
	}

	public Map<String, Object> selectAuthorClassList(Map<String, Object> paramMap) throws Exception	{
		return authorManageDAO.selectAuthorClassList(paramMap);
	}
	
	/**
	 * 권한 부여 Group 가져오기
	 */
	@SuppressWarnings("unchecked")
	public String getAuthorRelateGroup(Map<String, Object> paramMap) throws Exception	{
		
		String result = "";
		
		Map<String, Object> resultMap = authorManageDAO.selectAuthorRelateList(paramMap);
		List<EgovMap> resultList = (List<EgovMap>) resultMap.get("list") ;
		if(resultList != null && resultList.size() > 0){
			for (int i = 0; i < resultList.size(); i++) {
				if(i == 0){
					result = resultList.get(i).get("selectedItem") + ",";
				}else{
					result = result + "," +resultList.get(i).get("selectedItem");
				}
			}
		}
		
		return result;
	}

	/**
	 * 메뉴 권한 리스트
	 */
	@Override
	public List<Map<String, Object>> selectMenuTreeList(Map<String, Object> params) {

		List<Map<String, Object>> resultList = null;
		if(params.get("authorType").equals("005")){  // 관리자 메뉴
			resultList = authorManageDAO.selectAdmMenuTreeList(params);
		}else{   //사용자메뉴
			resultList = authorManageDAO.selectMenuTreeList(params);
		}
		return resultList;
	}

	/**
	 * 마스터 권한 리스트 
	 */
	@Override
	public Map<String, Object> getAuthorMasterList(Map<String, Object> params) throws Exception{
		Map<String, Object> resultMap = null;
		resultMap = authorManageDAO.getAuthorMasterList(params);
		return resultMap;
	}

	/**
	 * 마스터 권한 삭제 
	 */
	@Override
	public int updateAuthorMaster(Map<String, Object> paramMap) throws Exception{
		int result = 0;
		
		JSONArray ja = JSONArray.fromObject(paramMap.get("selectedList"));

		for (int i = 0; i < ja.size(); i++) {
			JSONObject jsonObject = JSONObject.fromObject(ja.get(i));
			Map<String,Object> item =  new HashMap<String,Object>();
			item.put("empSeq", jsonObject.get("empSeq"));
			item.put("createSeq", paramMap.get("createSeq"));
			item.put("masterUseYn", paramMap.get("masterUseYn"));
	
			authorManageDAO.updateAuthorMaster(item);
			result ++;
		}
		
		return result;
	}


	
}
