package neos.cmm.systemx.ldapAdapter.dao;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import org.springframework.stereotype.Repository;
import egovframework.com.cmm.service.impl.EgovComAbstractDAO;
import neos.cmm.systemx.ldapAdapter.service.LdapAdapterService;

@Repository("LdapAdapterDAO")
public class LdapAdapterDAO extends EgovComAbstractDAO{
	
	@Resource(name="LdapAdapterService")
	public LdapAdapterService ldapManageService;		
	
	//부서 등록 및 변경정보 IF테이블 INSERT 
    @SuppressWarnings("unchecked")
	public void insertOrgAdapterResultDept(Map<String, Object> paramMap) {
    	
    	try{
        	if(paramMap.get("compSeq") == null || paramMap.get("syncType") == null){
        		return;
        	}
        	
        	//연동설정 정보 조회
        	Map<String, Object> getLdapSetInfo = (Map<String, Object>)select("LdapManage.getLdapSetInfo", paramMap);
        	
        	if(getLdapSetInfo != null && getLdapSetInfo.get("syncMode").equals("gta") && getLdapSetInfo.get("deptOuType").equals("M")){
        		
        		//미사용일 경우 삭제
        		if(paramMap.get("useYn") != null && paramMap.get("useYn").equals("N")){
        			paramMap.put("syncType", "D");
        		}
        		
            	//수정
            	if(paramMap.get("syncType").equals("U")){
            		
            		//최근데이터 조회
            		Map<String, Object> ldapDept = (Map<String, Object>)select("LdapManage.selectLdapDept", paramMap);

            		if(ldapDept == null && paramMap.get("useYn") != null && paramMap.get("useYn").equals("Y")){
            			//기존데이터가 없을경우 신규등록
            			paramMap.put("syncType", "I");
            		}
            		//미처리데이터일경우        		
            		else if(ldapDept != null && !ldapDept.get("syncStatus").equals("C")){
            			
            			boolean changeUse = false;
            			
            			//변동사항이 있으면 업데이트
            			if(ldapDept.get("syncType").equals("D")){
            				paramMap.put("syncType", "U");
            				changeUse = true;
            			}
            			
            			if(changeUse || !ldapDept.get("parentDeptSeq").equals(paramMap.get("parentDeptSeq")) || !ldapDept.get("deptName").equals(paramMap.get("deptName"))){
            				paramMap.put("uid", ldapDept.get("uid"));
            				update("LdapManage.updateLdapDept", paramMap);
            				return;
            			}else{
            				return;
            			}
            			
            		}
            	}
            	
        		//신규 or 삭제
        		if(paramMap.get("compSeq") == null ){
        			paramMap.put("compSeq", "");
        		}
        		
        		if(paramMap.get("parentDeptSeq") == null ){
        			paramMap.put("parentDeptSeq", "");
        		}
        		
        		if(paramMap.get("deptName") == null ){
        			paramMap.put("deptName", "");
        		}
        		
        		insert("LdapManage.insertLdapDept", paramMap);
        		
        		paramMap.put("inputParam", paramMap.toString());
        		paramMap.put("apiName", "insertOrgAdapterResultDept");
        		paramMap.put("errorMsg", "SUCCESS");
        		insert("LdapManage.insertLdapApiLog", paramMap);           		
        	}    		
    	}catch(Exception e){
    		paramMap.put("inputParam", paramMap.toString());
    		paramMap.put("apiName", "insertOrgAdapterResultDept");
    		paramMap.put("errorMsg", e.getMessage());
    		insert("LdapManage.insertLdapApiLog", paramMap);       		
    	}
    }
    
	//사원 등록 및 변경정보 IF테이블 INSERT 
    @SuppressWarnings("unchecked")
	public void insertOrgAdapterResultEmp(Map<String, Object> paramMap) {
    	
    	try{
    		
        	//연동설정 정보 조회
        	Map<String, Object> getLdapSetInfo = (Map<String, Object>)select("LdapManage.getLdapSetInfo", paramMap);    		
        	
        	if(getLdapSetInfo != null){
            	if(getLdapSetInfo.get("syncMode").equals("gta")){
            		
                	//전체퇴사처리 시
                	if(paramMap.get("syncType").equals("D") && (paramMap.get("compSeq") == null || paramMap.get("compSeq").equals(""))){
                		insert("LdapManage.insertLdapEmpResign", paramMap);
                		return;
                	}
                	
                	if((paramMap.get("mainDeptYn") != null && paramMap.get("mainDeptYn").equals("N")) || paramMap.get("compSeq") == null || paramMap.get("syncType") == null){
                		return;
                	}            		
            		
            		//회사정보 조회
            		Map<String, Object> compInfo = (Map<String, Object>)select("LdapManage.getCompInfo", paramMap);
            		paramMap.put("emailDomain", compInfo.get("emailDomain"));
            		paramMap.put("compName", compInfo.get("compName"));
            		
            		//미사용일 경우 삭제
            		if(paramMap.get("workStatus") != null && paramMap.get("workStatus").equals("001")){
            			paramMap.put("syncType", "D");
            			paramMap.put("useYn", "N");
            		}
            		
            		if(paramMap.get("deptSeqNew") != null && !paramMap.get("deptSeqNew").equals("")){
            			paramMap.put("deptSeq", paramMap.get("deptSeqNew"));
            		}    		
            		
                	//수정
                	if(paramMap.get("syncType").equals("U")){
                		
                		//최근데이터 조회
                		Map<String, Object> ldapEmp = (Map<String, Object>)select("LdapManage.selectLdapEmp", paramMap);

                		if(ldapEmp == null){
                			//기존데이터가 없을경우 신규등록
                			paramMap.put("syncType", "I");
                		}
                		//미처리데이터일경우        		
                		else if(ldapEmp != null){
                			
                			boolean changeUse = false;
                			
                			//변동사항이 있으면 업데이트
                			if(ldapEmp.get("syncType").equals("D")){
                				paramMap.put("syncType", "U");
                				changeUse = true;
                			}
                			
                			if(paramMap.get("deptSeq") != null && !paramMap.get("deptSeq").equals("") && !ldapEmp.get("deptSeq").equals(paramMap.get("deptSeq"))){
                				changeUse = true;
                			}else{
                				paramMap.remove("deptSeq");
                			}
                			
                			if(paramMap.get("loginId") != null && !paramMap.get("loginId").equals("") && !ldapEmp.get("loginId").equals(paramMap.get("loginId"))){
                				changeUse = true;
                			}else{
                				paramMap.remove("loginId");
                			}
                			
                			if(ldapEmp.get("erpEmpSeq") == null){
                				ldapEmp.put("erpEmpSeq", "");
                			}
                			
                			if(paramMap.get("erpEmpSeq") != null && !paramMap.get("erpEmpSeq").equals("") && !ldapEmp.get("erpEmpSeq").equals(paramMap.get("erpEmpSeq"))){
                				changeUse = true;
                			}else{
                				paramMap.remove("erpEmpSeq");
                			}                			
                			
                			if(paramMap.get("emailAddr") != null && !paramMap.get("emailAddr").equals("") && !ldapEmp.get("emailAddr").equals(paramMap.get("emailAddr"))){
                				changeUse = true;
                			}else{
                				paramMap.remove("emailAddr");
                			}
                			
                			if(paramMap.get("emailDomain") != null && !ldapEmp.get("emailDomain").equals(paramMap.get("emailDomain"))){
                				changeUse = true;
                			}else{
                				paramMap.remove("emailDomain");
                			}         			
                			
                			if(paramMap.get("empName") != null && !paramMap.get("empName").equals("") && !ldapEmp.get("empName").equals(paramMap.get("empName"))){
                				changeUse = true;
                			}else{
                				paramMap.remove("empName");
                			}
                			
                			if(paramMap.get("dutyCode") != null && !paramMap.get("dutyCode").equals("") && !ldapEmp.get("dutyCode").equals(paramMap.get("dutyCode"))){
                				changeUse = true;
                			}else{
                				paramMap.remove("dutyCode");
                			}
                			
                			if(paramMap.get("mobileTelNum") != null && !ldapEmp.get("mobileTelNum").equals(paramMap.get("mobileTelNum"))){
                				changeUse = true;
                			}else{
                				paramMap.remove("mobileTelNum");
                			}
                			
                			if(paramMap.get("faxNum") != null && !ldapEmp.get("faxNum").equals(paramMap.get("faxNum"))){
                				changeUse = true;
                			}else{
                				paramMap.remove("faxNum");
                			}
                			
                			if(paramMap.get("homeTelNum") != null && !ldapEmp.get("homeTelNum").equals(paramMap.get("homeTelNum"))){
                				changeUse = true;
                			}else{
                				paramMap.remove("homeTelNum");
                			}
                			
                			if(paramMap.get("telNum") != null && !ldapEmp.get("telNum").equals(paramMap.get("telNum"))){
                				changeUse = true;
                			}else{
                				paramMap.remove("telNum");
                			}
                			
                			if(paramMap.get("useYn") != null && !ldapEmp.get("useYn").equals(paramMap.get("useYn"))){
                				changeUse = true;
                			}else{
                				paramMap.remove("useYn");
                			}                			
                			
                			if(paramMap.get("loginPasswd") != null && !ldapEmp.get("loginPasswd").equals(paramMap.get("loginPasswd"))){
                				
                				paramMap.put("syncMode", "gta");
                				
                				if(ldapManageService.ldapPasswdLiveChange(paramMap)){
                					
                					if(!changeUse && !ldapEmp.get("syncStatus").equals("C")){
                						paramMap.put("loginPasswd", "");
                					}
                					
                				}
                				
                				changeUse = true;
                				
                			}else{
                				paramMap.remove("loginPasswd");
                			}
                			
                			if(changeUse){
                				
                    			if(!ldapEmp.get("syncStatus").equals("C")){
                    				paramMap.put("uid", ldapEmp.get("uid"));
                    				update("LdapManage.updateLdapEmp", paramMap);            				
                    			}else{
                    				insert("LdapManage.insertLdapEmp", paramMap);
                    			}        				

                			}
                			
                			return;
                			
                		}
                	}
                	
            		//신규 or 삭제
            		insert("LdapManage.insertLdapEmp", paramMap);
            		
            		paramMap.put("inputParam", paramMap.toString());
            		paramMap.put("apiName", "insertOrgAdapterResultEmp");
            		paramMap.put("errorMsg", "SUCCESS");
            		insert("LdapManage.insertLdapApiLog", paramMap);           		
            	}else if(getLdapSetInfo.get("syncMode").equals("atg")){
            		
        			if(paramMap.get("loginPasswd") != null){
        				
        				paramMap.put("syncMode", "atg");
        				
        				if(ldapManageService.ldapPasswdLiveChange(paramMap)){
        					paramMap.remove("loginPasswd");
        				}
        				
        			}            		
            	}
        	}
        	
    	}catch(Exception e){
    		paramMap.put("inputParam", paramMap.toString());
    		paramMap.put("apiName", "insertOrgAdapterResultEmp");
    		paramMap.put("errorMsg", e.getMessage());
    		insert("LdapManage.insertLdapApiLog", paramMap);
    	}
    }	    
	
    public boolean insertLdapConnectionSet(Map<String, Object> paramMap) {
    	@SuppressWarnings("unchecked")
		Map<String, Object> getLdapSetInfo = (Map<String, Object>)select("LdapManage.getLdapSetInfo", paramMap);
    	
    	if(getLdapSetInfo == null){
    		insert("LdapManage.insertLdapSetInfo", paramMap);
    		
    		if(paramMap.get("syncMode").equals("gta")){
    			if(paramMap.get("deptOuType").equals("M")){
    				insert("LdapManage.insertLdapDeptStart", paramMap);	
    			}
    			
    			insert("LdapManage.insertLdapEmpStart", paramMap);	
    		}
    		
    		return true;
    	}else{
    		update("LdapManage.updateLdapSetInfo", paramMap);
    		return true;
    	}
    }
    
    public void updateLdapSchSet(Map<String, Object> paramMap) {
    	update("LdapManage.updateLdapSchSet", paramMap);
    }
    
    @SuppressWarnings("unchecked")
	public Map<String, Object> getLdapSetInfo(Map<String, Object> paramMap) {
		return (Map<String, Object>)select("LdapManage.getLdapSetInfo", paramMap);
    }
    
    public void resetLdapSetInfo(Map<String, Object> paramMap) {
    	delete("LdapManage.deleteLdapSetInfo", paramMap);
    	delete("LdapManage.deleteLdapDept", paramMap);
    	delete("LdapManage.deleteLdapEmp", paramMap);
    	delete("LdapManage.deleteLdapKeyAll", paramMap);
    	delete("LdapManage.deleteLdapReq", paramMap);
    }
    
    @SuppressWarnings("unchecked")
	public Map<String, Object> getLdapKey(Map<String, Object> paramMap) {
		return (Map<String, Object>)select("LdapManage.selectLdapKey", paramMap);
    }
    
	public void setLdapKey(Map<String, Object> paramMap) {
		delete("LdapManage.deleteLdapKey", paramMap);
		insert("LdapManage.insertLdapKey", paramMap);
    }
	
    @SuppressWarnings("unchecked")
	public Map<String, Object> getLdapDeptFromUid(Map<String, Object> paramMap) {
    	update("LdapManage.updateLdapDeptStart", paramMap);
		return (Map<String, Object>)select("LdapManage.selectLdapDeptFromUid", paramMap);
    }
    
    @SuppressWarnings("unchecked")
	public Map<String, Object> getLdapEmpFromUid(Map<String, Object> paramMap) {
    	update("LdapManage.updateLdapEmpStart", paramMap);
		return (Map<String, Object>)select("LdapManage.selectLdapEmpFromUid", paramMap);
    }    
    
	public void updateLdapDeptResult(Map<String, Object> paramMap) {
		update("LdapManage.updateLdapDeptResult", paramMap);
    }
	
	public void updateLdapEmpResult(Map<String, Object> paramMap) {
		update("LdapManage.updateLdapEmpResult", paramMap);
    }  	
    
	public void updateLdapKey(Map<String, Object> paramMap) {
		update("LdapManage.updateLdapKey", paramMap);
    }   	
	
    @SuppressWarnings("unchecked")
	public Map<String, Object> getEmpInfo(Map<String, Object> paramMap) {
		return (Map<String, Object>)select("LdapManage.getEmpInfo", paramMap);
    }
    
	public String selectLdapDeptCnt(Map<String, Object> paramMap) {
		return (String) select("LdapManage.selectLdapDeptCnt", paramMap);
    } 
	
	public String selectLdapEmpCnt(Map<String, Object> paramMap) {
		return (String) select("LdapManage.selectLdapEmpCnt", paramMap);
    }

	@SuppressWarnings("unchecked")
	public List<Map<String,Object>> selectLdapSyncTargetList(Map<String, Object> params){
    	return list("LdapManage.selectLdapSyncTargetList", params);
    }
	
	@SuppressWarnings("unchecked")
	public List<Map<String,Object>> getLdapSchSetInfoList(Map<String, Object> params){
    	return list("LdapManage.getLdapSchSetInfoList", params);
    }	
	
	public void insertLdapReq(Map<String, Object> paramMap) {
		insert("LdapManage.insertLdapReq", paramMap);
    }
	
	public void insertLdapApiLog(Map<String, Object> paramMap) {
		insert("LdapManage.insertLdapApiLog", paramMap);
    }
	
    @SuppressWarnings("unchecked")
	public Map<String, Object> selectEmpLoginCheckInfo(Map<String, Object> paramMap) {
		return (Map<String, Object>)select("LdapManage.selectEmpLoginCheckInfo", paramMap);
    }
    
    @SuppressWarnings("unchecked")
	public Map<String, Object> selectLdapPasswdLiveChangeInfo(Map<String, Object> paramMap) {
		return (Map<String, Object>)select("LdapManage.selectLdapPasswdLiveChangeInfo", paramMap);
    }
    
	@SuppressWarnings("unchecked")
	public List<Map<String,Object>> ldapSelectLdapKeyAll(Map<String, Object> params){
    	return list("LdapManage.selectLdapKeyAll", params);
    }
	
	public String ldapUserKeyArray(Map<String, Object> params){
    	return (String) select("LdapManage.ldapUserKeyArray", params);
    }
	
	public void insertLdapEmp(Map<String, Object> params){
    	insert("LdapManage.insertLdapEmp", params);
    }
	
	public void insertLdapEmpList(Map<String, Object> params){
    	insert("LdapManage.insertLdapEmpList", params);
    }
	
	public void updateLdapEmpLinkSeq(Map<String, Object> params){
    	update("LdapManage.updateLdapEmpLinkSeq", params);
    }
	
	public void updateLoginpwFromLdap(Map<String, Object> params){
    	update("LdapManage.updateLoginpwFromLdap", params);
    }
	
	public String selectDeptSeqFomDeptCd(Map<String, Object> paramMap) {
		return (String) select("LdapManage.selectDeptSeqFomDeptCd", paramMap);
    } 	
    
}