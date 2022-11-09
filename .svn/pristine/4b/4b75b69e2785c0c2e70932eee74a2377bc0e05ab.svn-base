/*
 * Copyright 이재혁 by Duzon Newturns.,
 * All rights reserved.
 */
package acc.money.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import egovframework.com.cmm.service.impl.EgovComAbstractDAO;

/**
 *<pre>
 * 1. Package Name	: acc.money.dao
 * 2. Class Name	: AccMoneyFormDAO.java
 * 3. Description	: 
 * ------- 개정이력(Modification Information) ----------
 *    작성일            작성자         작성정보
 *    2016. 6. 15.     이재혁       최초작성
 *  -----------------------------------------------------
 *</pre>
 */

@Repository("AccMoneyFormDAO")
public class AccMoneyFormDAO extends EgovComAbstractDAO{
    
    public List<HashMap<String, Object>> SelectComp (Map<String, Object> param) throws Exception{
        return list("AccMoneyFormDAO.SelectComp", param);
    }
    
    public void InsertMoneyForm(Map<String, Object> param) throws Exception {
        insert("AccMoneyFormDAO.InsertMoneyForm", param);
    }
    
    public HashMap<String, Object> SelectMoneyFormBySeq (Map<String, Object> param) throws Exception{
        return (HashMap<String, Object>) select("AccMoneyFormDAO.SelectFormBySeq", param);
    }
    
    public void UpdateSmartOption001(Map<String, Object> param) throws Exception{
        update("AccMoneyFormDAO.UpdateSmartOption001", param) ;
        return;
    }
    
    public String SelectSmartOption001(Map<String, Object> param) throws Exception{
    	List<HashMap<String, Object>> result = (List<HashMap<String, Object>>)list("AccMoneyFormDAO.SelectSmartOption001", param);
    	return result.get( 0 ).get( "value" ).toString( );
    }
}
 

