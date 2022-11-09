/*
 * Copyright 이재혁 by Duzon Newturns.,
 * All rights reserved.
 */
package acc.money.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 *<pre>
 * 1. Package Name	: acc.money.service
 * 2. Class Name	: AccMoneyFormService.java
 * 3. Description	: 
 * ------- 개정이력(Modification Information) ----------
 *    작성일            작성자         작성정보
 *    2016. 6. 15.     이재혁       최초작성
 *  -----------------------------------------------------
 *</pre>
 */

public interface AccMoneyFormService {
    
    //회사 가져오기 
    public List<HashMap<String, Object>> selectComp(Map<String, Object> param) throws Exception;
    
    public void UpdateSmartOption001(Map<String, Object> param) throws Exception;
    
    public String SelectSmartOption001(Map<String, Object> param) throws Exception;
    
    public void InsertMoneyForm(Map<String, Object> param) throws Exception;
    
    public HashMap<String, Object> SelectMoneyFormBySeq(Map<String, Object> param) throws Exception;

}
 

