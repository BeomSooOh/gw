/*
 * Copyright 이재혁 by Duzon Newturns.,
 * All rights reserved.
 */
package neos.cmm.systemx.emp.dao;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import egovframework.com.cmm.service.impl.EgovComAbstractDAO;

/**
 *<pre>
 * 1. Package Name	: ea.docpop.dao
 * 2. Class Name	: EadocPopProbDAO.java
 * 3. Description	: 
 * ------- 개정이력(Modification Information) ----------
 *    작성일            작성자         작성정보
 *    2016. 2. 15.     이재혁       최초작성
 *  -----------------------------------------------------
 *</pre>
 */

@Repository("EmpManageDAO")
public class EmpManageDAO extends EgovComAbstractDAO{
    
    public List<Map<String, Object>> selectEmpInfoList(Map<String, Object> paramMap) {
        List<Map<String, Object>> resultList = list("EmpManage.selectEmpInfoList", paramMap);
        return resultList;
    }    
    
    public void updateMailAddr(Map<String, Object> params) {
        update("EmpManageService.updateMailAddr", params);        
    }
    
    public void initPasswordFailcount(Map<String, Object> params) {
    	update("EmpManageService.initPasswordFailcount", params);
    }
    
    public void setUserPortlet(Map<String, Object> params) {
    	insert("EmpManageService.setUserPortlet", params);
    }
    
    public void initToken(Map<String, Object> params) {
    	delete("EmpManageService.deleteOldToken", params);
    	insert("EmpManageService.insertNewToken", params);
    }
    
    public void delToken(Map<String, Object> params) {
    	delete("EmpManageService.deleteOldToken", params);
    }    
    
}
 

