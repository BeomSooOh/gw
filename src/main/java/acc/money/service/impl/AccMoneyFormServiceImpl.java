/*
 * Copyright 이재혁 by Duzon Newturns.,
 * All rights reserved.
 */
package acc.money.service.impl;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import bizbox.orgchart.service.vo.LoginVO;

import egovframework.com.utl.fcc.service.EgovStringUtil;

import acc.money.dao.AccMoneyFormDAO;
import acc.money.service.AccMoneyFormService;

/**
 *<pre>
 * 1. Package Name	: acc.money.service.impl
 * 2. Class Name	: AccMoneyFormServiceImpl.java
 * 3. Description	: 
 * ------- 개정이력(Modification Information) ----------
 *    작성일            작성자         작성정보
 *    2016. 6. 15.     이재혁       최초작성
 *  -----------------------------------------------------
 *</pre>
 */

@Service("AccMoneyFormService")
public class AccMoneyFormServiceImpl implements AccMoneyFormService {
    
    @Resource(name = "AccMoneyFormDAO")
    private AccMoneyFormDAO accMoneyFormDAO;
    
    @Override
    public List<HashMap<String, Object>> selectComp(Map<String, Object> param) throws Exception {
        LoginVO loginVo = (LoginVO) param.get("loginVo");
        List<HashMap<String, Object>> selComp = new ArrayList<HashMap<String, Object>>(); 
        String auth = isNullStr(loginVo.getUserSe());
        if(isNullStr(auth).equals("MASTER")){
            selComp = accMoneyFormDAO.SelectComp(param);
        }
        
        return selComp;
    }
    
    @Override
    public void InsertMoneyForm(Map<String, Object> param) throws Exception {
        String compSel = isNullStr(param.get("compSel"));
        List<HashMap<String, Object>> selComp = new ArrayList<HashMap<String, Object>>();

        if(compSel.equals("0")){
            selComp = accMoneyFormDAO.SelectComp(param);
            for(HashMap<String, Object> tmp : selComp){
                param.put("comp_seq", isNullStr(tmp.get("seq")));
                accMoneyFormDAO.InsertMoneyForm(param);
            }
        }else{
            param.put("comp_seq", compSel);
            accMoneyFormDAO.InsertMoneyForm(param);
        }
    }

    @Override
    public void UpdateSmartOption001(Map<String, Object> param) throws Exception {
    	accMoneyFormDAO.UpdateSmartOption001(param);
    	return;
    }
    
    @Override
    public String SelectSmartOption001(Map<String, Object> param) throws Exception {
    	return accMoneyFormDAO.SelectSmartOption001(param);
    }
    
    
    @Override
    public HashMap<String, Object> SelectMoneyFormBySeq(Map<String, Object> param) throws Exception {

        param.put("comp_seq", isNullStr(param.get("compSeq")));
        HashMap<String, Object> selForm = accMoneyFormDAO.SelectMoneyFormBySeq(param);
        return selForm;
    }

    private String isNullStr(Object obj){
        String str = EgovStringUtil.isNullToString(obj);
        if(str.equals("null")){
            str = "";
        }
        return str;
    }

}
 

