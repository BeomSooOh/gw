package neos.cmm.systemx.ldapAdapter.service.impl;

import java.util.Map;
import javax.annotation.Resource;
import egovframework.com.cmm.EgovMessageSource;
import egovframework.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;
import main.web.BizboxAMessage;
import neos.cmm.db.CommonSqlDAO;
import org.springframework.stereotype.Service;

import neos.cmm.systemx.ldapAdapter.context.LdapContextManager;
import neos.cmm.systemx.ldapAdapter.context.LdapContextManagerFactory;
import neos.cmm.systemx.ldapAdapter.context.LdapContextType;
import neos.cmm.systemx.ldapAdapter.dao.LdapAdapterDAO;
import neos.cmm.systemx.ldapAdapter.service.LdapAdapterService;
import neos.cmm.util.BizboxAProperties;
import neos.cmm.util.CommonUtil;
import org.apache.log4j.Logger;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.UnsupportedEncodingException;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;
import java.security.NoSuchAlgorithmException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Hashtable;
import java.util.LinkedHashMap;
import java.util.List;

import javax.naming.Context;
import javax.naming.NamingEnumeration;
import javax.naming.NamingException;
import javax.naming.directory.Attribute;
import javax.naming.directory.Attributes;
import javax.naming.directory.BasicAttribute;
import javax.naming.directory.BasicAttributes;
import javax.naming.directory.DirContext;
import javax.naming.directory.ModificationItem;
import javax.naming.directory.SearchControls;
import javax.naming.directory.SearchResult;
import javax.naming.ldap.InitialLdapContext;
import neos.cmm.systemx.orgAdapter.service.OrgAdapterService;


@Service("LdapAdapterService")
public class LdapAdapterServiceImpl implements LdapAdapterService{
	
	protected Logger logger = Logger.getLogger(super.getClass());
	
	/** EgovMessageSource */
	@Resource(name="egovMessageSource")
	EgovMessageSource egovMessageSource;
	
	@Resource(name = "commonSql")
	private CommonSqlDAO commonSql;	
    
	@Resource(name = "LdapAdapterDAO")
    private LdapAdapterDAO ldapAdapterDAO;
	
	@Resource(name = "OrgAdapterService")
	private OrgAdapterService orgAdapterService;	
	
	private LdapContextManager ldapContextManager;
	
	@Override
    public void ldapDeptSave(Map<String, Object> paramMap) throws NamingException {
		
		Map<String, Object> ldapDeptInfo = ldapAdapterDAO.getLdapDeptFromUid(paramMap);
		
		if(ldapDeptInfo == null) {
			return;
		}
		
		if (ldapContextManager == null){
			ldapDeptInfo.put("ldapType", "AD");
			ldapContextManager = LdapContextManagerFactory.createLdapContext(LdapContextType.ACTIVEDIRECTORY, ldapDeptInfo);
		}
					
        
        //연동키 조회
        String deptSeq = ldapDeptInfo.get("deptSeq").toString();
        paramMap.put("orgDiv", "D");
        paramMap.put("gwSeq", deptSeq);
        paramMap.put("deptSeq", deptSeq);
        paramMap.put("errorMsg", "SUCCESS");
		
		//부서OU체크
		NamingEnumeration<SearchResult> deptOuResults = ldapContextManager.getOuList(ldapDeptInfo);				
		if(!deptOuResults.hasMoreElements()) {
			paramMap.put("syncStatus", "E");
			paramMap.put("errorMsg", BizboxAMessage.getMessage("TX800000050","조직도OU 없음"));
			ldapAdapterDAO.updateLdapDeptResult(paramMap);
			return;
		}
        
        Map<String, Object> ldapKey = ldapAdapterDAO.getLdapKey(paramMap);
        
        //상위부서 AD경로
        String parentAdName = "";
        
        if(ldapKey == null){
        	
        	//삭제 시 
        	if(ldapDeptInfo.get("syncType").equals("D")){
    			//부서정보 없음
    			paramMap.put("syncStatus", "E");
    			paramMap.put("errorMsg", BizboxAMessage.getMessage("TX800000051","부서정보 없음"));
    			ldapAdapterDAO.updateLdapDeptResult(paramMap);
    			return;
        	}
        	
        	//신규추가
        	if(ldapDeptInfo.get("parentDeptSeq").equals("0")){
        		parentAdName = paramMap.get("deptDir").toString();
        	}else{
        		paramMap.put("gwSeq", ldapDeptInfo.get("parentDeptSeq"));
        		Map<String, Object> parentLdapKey = ldapAdapterDAO.getLdapKey(paramMap);
        		
        		if(parentLdapKey != null){
        			parentAdName = parentLdapKey.get("adName").toString();
        		}else{
        			//상위부서정보 없음
        			paramMap.put("syncStatus", "E");
        			paramMap.put("errorMsg", BizboxAMessage.getMessage("TX800000052","상위부서정보 없음"));
        			ldapAdapterDAO.updateLdapDeptResult(paramMap);
        			return;
        		}
        	}
        	
        	String adName = "OU=" + ldapDeptInfo.get("deptName").toString() + "," + parentAdName;
        	
            //생성할 OU가 존재하는지 체크
        	NamingEnumeration<SearchResult> results = ldapContextManager.getOuListNamedAdName(ldapDeptInfo, parentAdName);
    		
    		if(!results.hasMoreElements()){
    			//없을경우 등록
    	        Attributes attrs = new BasicAttributes(true); // case-ignore
    	        Attribute objclass = new BasicAttribute("objectclass");
    	        objclass.add("top");
    	        objclass.add("organizationalUnit");
    	        attrs.put(objclass);
    	        
    	        ldapContextManager.createSubcontext(adName, attrs);
    			attrs = ldapContextManager.getAttributes(adName);
    			
    			paramMap.put("adName", adName);
    			paramMap.put("usn", attrs.get("usncreated").get());
    			paramMap.put("relateDeptSeq", ldapDeptInfo.get("parentDeptSeq"));
    			paramMap.put("gwSeq", deptSeq);
    			ldapAdapterDAO.setLdapKey(paramMap);
    		}else{
    			//이미 등록된 부서일 경우 연동key만 등록해줌
    		    SearchResult searchResult = (SearchResult) results.nextElement();
    			paramMap.put("adName", adName);
    			paramMap.put("usn", searchResult.getAttributes().get("uSNCreated").get());
    			paramMap.put("relateDeptSeq", ldapDeptInfo.get("parentDeptSeq"));
    			paramMap.put("gwSeq", deptSeq);
    			ldapAdapterDAO.setLdapKey(paramMap);
    		}
        }else{
        	//키매핑인경우
        	
    		//부서 OU조회
    		NamingEnumeration<SearchResult> results = ldapContextManager.getOuListFromMap(ldapDeptInfo, ldapKey);
    		
    		if(results.hasMoreElements()){
    			
    			//부서OU변동사항 체크
    			SearchResult searchResult = (SearchResult) results.nextElement();

    			if(ldapDeptInfo.get("syncType").equals("D")){
    				//삭제
    				ldapContextManager.destroySubcontext(ldapKey);
    				
    			}else if(!ldapKey.get("relateDeptSeq").equals(ldapDeptInfo.get("parentDeptSeq")) || !ldapDeptInfo.get("deptName").equals(searchResult.getAttributes().get("name").get())){

            		//변동사항이 있을경우 rename
                	if(ldapDeptInfo.get("parentDeptSeq").equals("0")){
                		parentAdName = ldapDeptInfo.get("deptDir").toString();
                	}else{
                		paramMap.put("gwSeq", ldapDeptInfo.get("parentDeptSeq"));
                		Map<String, Object> parentLdapKey = ldapAdapterDAO.getLdapKey(paramMap);
                		
                		if(parentLdapKey != null){
                			parentAdName = parentLdapKey.get("adName").toString();
                		}else{
                			//상위부서정보 없음
                			paramMap.put("syncStatus", "E");
                			paramMap.put("errorMsg", BizboxAMessage.getMessage("TX800000052","상위부서정보 없음"));
                			ldapAdapterDAO.updateLdapDeptResult(paramMap);
                			return;
                		}
                	}
                	
                	parentAdName = "OU=" + ldapDeptInfo.get("deptName").toString() + "," + parentAdName;
                	
                	ldapContextManager.rename(ldapKey, parentAdName);
            		
            		//키매핑데이터 업데이트
            		paramMap.put("gwSeq", deptSeq);
            		paramMap.put("adName", parentAdName);
            		paramMap.put("relateDeptSeq", ldapDeptInfo.get("parentDeptSeq"));
            		ldapAdapterDAO.updateLdapKey(paramMap);
            	}
    			
    		}else{
    			//기존부서정보 없음
    			paramMap.put("syncStatus", "E");
    			paramMap.put("errorMsg", BizboxAMessage.getMessage("TX800000051","부서정보 없음"));
    			ldapAdapterDAO.updateLdapDeptResult(paramMap);
    			return;        			
    		}        	
        }

		paramMap.put("syncStatus", "C");
		ldapAdapterDAO.updateLdapDeptResult(paramMap);
		
		return;
	}
	
	@Override
    public void ldapEmpSave(Map<String, Object> paramMap) throws NamingException, UnsupportedEncodingException, NoSuchAlgorithmException {
		
		Map<String, Object> ldapEmpInfo = ldapAdapterDAO.getLdapEmpFromUid(paramMap);
		
		if (ldapContextManager == null){
			ldapEmpInfo.put("ldapType", "AD");
			ldapContextManager = LdapContextManagerFactory.createLdapContext(LdapContextType.ACTIVEDIRECTORY, ldapEmpInfo);
		}
					
		
		if(ldapEmpInfo == null) {
			return;
		}

        //연동키 조회
        String empSeq = ldapEmpInfo.get("empSeq").toString();
        paramMap.put("orgDiv", "U");
        paramMap.put("gwSeq", empSeq);
        paramMap.put("empSeq", empSeq);
        paramMap.put("errorMsg", "SUCCESS");
        
		//부서OU체크
		NamingEnumeration<SearchResult> deptOuResults = ldapContextManager.getOuList(ldapEmpInfo);
		if(!deptOuResults.hasMoreElements()) {
			paramMap.put("syncStatus", "E");
			paramMap.put("errorMsg", BizboxAMessage.getMessage("TX800000050","조직도OU 없음"));
			ldapAdapterDAO.updateLdapEmpResult(paramMap);
			return;
		}
        
        Map<String, Object> ldapKey = ldapAdapterDAO.getLdapKey(paramMap);
        
        //상위부서 AD경로
        String parentAdName = "";
        
    	if(!ldapEmpInfo.get("syncType").equals("D") && ldapEmpInfo.get("deptOuType").equals("M")){
    		//멀티 OU
    		paramMap.put("orgDiv", "D");
    		paramMap.put("gwSeq", ldapEmpInfo.get("deptSeq"));
    		
    		Map<String, Object> parentLdapKey = ldapAdapterDAO.getLdapKey(paramMap);
    		
    		if(parentLdapKey != null){
    			parentAdName = parentLdapKey.get("adName").toString();
    		}else{
    			//상위부서정보 없음
    			paramMap.put("syncStatus", "E");
    			paramMap.put("errorMsg", BizboxAMessage.getMessage("TX800000053","사원매핑 부서정보 없음"));
    			ldapAdapterDAO.updateLdapEmpResult(paramMap);
    			return;
    		}		
    		
    	}else{
    		//단일OU
    		parentAdName = ldapEmpInfo.get("deptDir").toString();
    	}
    	
    	String loginId = ldapEmpInfo.get("loginId").toString();
    	String empName = ldapEmpInfo.get("empName").toString();
    	String erpEmpSeq = ldapEmpInfo.get("erpEmpSeq").toString();
    	
    	if(loginId.equals("")){
    		Map<String, Object> empInfo = ldapAdapterDAO.getEmpInfo(paramMap);
    		
    		if(empInfo != null){
    			loginId = empInfo.get("loginId").toString();
    			empName = empInfo.get("empName").toString();
    		}else{
    			//상위부서정보 없음
    			paramMap.put("syncStatus", "E");
    			paramMap.put("errorMsg", BizboxAMessage.getMessage("TX800000054","사원정보 없음"));
    			ldapAdapterDAO.updateLdapEmpResult(paramMap);
    			return;        			
    		}
    	}
    	
    	empName = empName.replace("/", "_");
    	
    	String cnName = empName + "(" + loginId + ")";
    	String adName = "CN=" + cnName + "," + parentAdName;
    	
    	//유효한 AD계정인지 체크
    	if(ldapKey != null){
    		
			NamingEnumeration<SearchResult> adUserResults = ldapContextManager.getUserListWithLoginID(ldapEmpInfo, loginId, "deptDir");
			
			if(!adUserResults.hasMoreElements()){
				ldapKey = null;
			}
    	}
        
        if(ldapKey == null){
        	
        	//삭제 시 
        	if(ldapEmpInfo.get("syncType").equals("D")){
    			//부서정보 없음
    			paramMap.put("syncStatus", "E");
    			paramMap.put("errorMsg", BizboxAMessage.getMessage("TX800000055","사용자정보 없음"));
    			ldapAdapterDAO.updateLdapEmpResult(paramMap);
    			return;
        	}
        	
            //생성할 OU가 존재하는지 체크
    		NamingEnumeration<SearchResult> results = ldapContextManager.getUserListWithLoginID(ldapEmpInfo, loginId, "baseDir");
    		if(!results.hasMoreElements()){
    			adName = ldapContextManager.addUser(paramMap, ldapEmpInfo, loginId, cnName, adName);
				Attributes attrs = ldapContextManager.getAttributes(adName);
    			
    			paramMap.put("adName", adName);
    			paramMap.put("usn", ldapContextManager.getAttributesUsnCreated(attrs));
    			paramMap.put("relateDeptSeq", ldapEmpInfo.get("deptSeq"));
    			paramMap.put("orgDiv", "U");
    			paramMap.put("gwSeq", empSeq);
    			
    			ldapAdapterDAO.setLdapKey(paramMap);
    		}else{
    			
    			boolean keyLinkYn = false;
    			String addMsg = "";
    			
    			//AD 조직도 연동타입이 단일OU일 경우 연동데이터만 생성
    			if(ldapEmpInfo.get("deptOuType").equals("S") && (ldapEmpInfo.get("syncType").equals("I") || ldapEmpInfo.get("syncType").equals("U"))){
    				NamingEnumeration<SearchResult> adUserResults = ldapContextManager.getUserListWithLoginID(ldapEmpInfo, loginId, "deptDir");
    				
    				if(adUserResults.hasMoreElements()){
        			    while (adUserResults.hasMoreElements()) {
        			    	SearchResult searchResult = adUserResults.nextElement();
                			paramMap.put("adName", searchResult.getAttributes().get("distinguishedName").get());
                			paramMap.put("usn", searchResult.getAttributes().get("usncreated").get());
                			keyLinkYn = true;
        			    }
    				}else{
    					//다른 OU에 있을경우 연동OU로 이동
    					SearchResult searchResultOld = results.nextElement();
    					paramMap.put("adName", searchResultOld.getAttributes().get("distinguishedName").get());
    					paramMap.put("usn", searchResultOld.getAttributes().get("usncreated").get());  
    					String adNameNew = "CN=" + searchResultOld.getAttributes().get("cn").get().toString() + "," + ldapEmpInfo.get("deptDir").toString();
    					ldapContextManager.rename(paramMap, adNameNew);
    					
    					addMsg = "(" + BizboxAMessage.getMessage("TX800000056","사용자OU 이동") + " : " + paramMap.get("adName").toString() + " > " + adNameNew + ")";
    					
            			paramMap.put("adName", adNameNew);
            			keyLinkYn = true;
    				}
    			}
    			
    			if(keyLinkYn){
        			paramMap.put("relateDeptSeq", ldapEmpInfo.get("deptSeq"));
        			paramMap.put("orgDiv", "U");
        			paramMap.put("gwSeq", empSeq);
        			paramMap.put("pwSyncYn", "N");
        			paramMap.put("errorMsg", BizboxAMessage.getMessage("TX800000057","동일한 계정연결") + addMsg);
        			ldapAdapterDAO.setLdapKey(paramMap);    				
    			}else{
        			//상위부서정보 없음
        			paramMap.put("syncStatus", "E");
        			paramMap.put("errorMsg", BizboxAMessage.getMessage("TX800000058","동일한 계정") + "[" + loginId + "]" + BizboxAMessage.getMessage("TX800000059","이 이미 등록되어 있습니다."));
        			ldapAdapterDAO.updateLdapEmpResult(paramMap);
        			return;    				
    			}
    			
    		}
        }else{
        	//키매핑인경우
        	
        	boolean resignYn = false;
        	NamingEnumeration<SearchResult> results = null;
        	
        	//기 퇴사자의 경우
        	if(ldapKey.get("relateDeptSeq").equals("ldapResign")){
        		//사원정보조회
        		resignYn = true;
        		results = ldapContextManager.getUserListWithAdName(ldapEmpInfo.get("empDir").toString(), ldapKey.get("adName").toString(), false);
        	}else{
        		results = ldapContextManager.getUserListWithAdName(ldapEmpInfo.get("deptDir").toString(), ldapKey.get("adName").toString(), true);
        	}
        	
        	if(!results.hasMoreElements()){
        		//해당위치에 사용자가 없을경우 전체경로에서 조회
        		results = ldapContextManager.getUserListWithLoginID(ldapEmpInfo, loginId, "baseDir");
        	}
    		
    		if(results.hasMoreElements()){
    			
    			SearchResult searchResult = (SearchResult) results.nextElement();
    			ldapKey.put("adName", searchResult.getAttributes().get("distinguishedName").get());

    			if(ldapEmpInfo.get("syncType").equals("D")){
    				if(!resignYn){
        				//퇴사자OU로 이동
    					if(!ldapKey.get("adName").equals("CN=" + cnName + "," + ldapEmpInfo.get("empDir").toString())){
    						ldapContextManager.rename(ldapKey, "CN=" + cnName + "," + ldapEmpInfo.get("empDir").toString());
    					}
        				
        				//미사용처리    				
        				ModificationItem[] mods = new ModificationItem[1];
        				mods[0] = new ModificationItem(DirContext.REPLACE_ATTRIBUTE, new BasicAttribute("userAccountControl", "65538"));
        				ldapContextManager.modifyAttributes("CN=" + cnName + "," + ldapEmpInfo.get("empDir").toString(), mods);
            			paramMap.put("adName", "CN=" + cnName + "," + ldapEmpInfo.get("empDir").toString());
            			paramMap.put("orgDiv", "U");
            			paramMap.put("gwSeq", empSeq);
            			paramMap.put("relateDeptSeq", "ldapResign");
            			ldapAdapterDAO.updateLdapKey(paramMap);    					
    				}
    			}else{
    				
        			//부서OU변동사항 체크
        			
        			if(ldapEmpInfo.get("useYn").equals("Y")){
        				//미사용처리    				
        				ModificationItem[] useYn = new ModificationItem[1];
        				useYn[0] = new ModificationItem(DirContext.REPLACE_ATTRIBUTE, new BasicAttribute("userAccountControl", "65536"));
        				ldapContextManager.modifyAttributes(ldapKey.get("adName").toString(), useYn);        				
        			}else{
        				//미사용처리    				
        				ModificationItem[] useYn = new ModificationItem[1];
        				useYn[0] = new ModificationItem(DirContext.REPLACE_ATTRIBUTE, new BasicAttribute("userAccountControl", "65538"));
        				ldapContextManager.modifyAttributes(ldapKey.get("adName").toString(), useYn);
        			}
        			
        			//employeeID
        			if(erpEmpSeq != null && !erpEmpSeq.equals("")){
        				
        				String oldemployeeID = "";
        				
        				if(searchResult.getAttributes().get("employeeID") != null){
        					oldemployeeID = searchResult.getAttributes().get("employeeID").get().toString();
        				}
        				
        				if(!erpEmpSeq.equals(oldemployeeID)){
            				ModificationItem[] useYn = new ModificationItem[1];
            				
            				if(erpEmpSeq.equals("")) {
            					useYn[0] = new ModificationItem(DirContext.REMOVE_ATTRIBUTE, new BasicAttribute("employeeID"));
            				}else {
            					useYn[0] = new ModificationItem(DirContext.REPLACE_ATTRIBUTE, new BasicAttribute("employeeID", erpEmpSeq));	
            				}
            				
            				
            				ldapContextManager.modifyAttributes(ldapKey.get("adName").toString(), useYn);        					
        				}
        			}        			
        			
        			//메일계정
        			if(ldapEmpInfo.get("emailSyncYn").equals("Y") && !ldapEmpInfo.get("emailAddr").equals("") && !ldapEmpInfo.get("emailDomain").equals("")){
        				
        				String oldEmailAddr = "";
        				
        				if(searchResult.getAttributes().get("mail") != null){
        					oldEmailAddr = searchResult.getAttributes().get("mail").get().toString();
        				}
        				
        				String newEmailAddr = ldapEmpInfo.get("emailAddr").toString() + "@" + ldapEmpInfo.get("emailDomain").toString();
        				
        				if(!oldEmailAddr.equals(newEmailAddr)){
            				ModificationItem[] useYn = new ModificationItem[1];
            				useYn[0] = new ModificationItem(DirContext.REPLACE_ATTRIBUTE, new BasicAttribute("mail", newEmailAddr));
            				ldapContextManager.modifyAttributes(ldapKey.get("adName").toString(), useYn);        					
        				}
        			}
        			 
        			/*
        			//직함
        			if(!ldapEmpInfo.get("dutyCode").equals("")){
        				String oldText = searchResult.getAttributes().get("title").get().toString();
        				String newText = ldapEmpInfo.get("dutyCode").toString();
        				
        				if(oldText.equals(newText)){
            				ModificationItem[] useYn = new ModificationItem[1];
            				useYn[0] = new ModificationItem(DirContext.REPLACE_ATTRIBUTE, new BasicAttribute("title", newText));
            				ctx.modifyAttributes(ldapKey.get("adName").toString(), useYn);        					
        				}
        			}
        			*/
        			
        			//핸드폰번호
        			if(ldapEmpInfo.get("telNumSyncYn").equals("Y") && !ldapEmpInfo.get("mobileTelNum").equals("")){
        				
        				String oldText = "";
        				
        				if(searchResult.getAttributes().get("mobile") != null){
        					oldText = searchResult.getAttributes().get("mobile").get().toString();
        				}
        				
        				String newText = ldapEmpInfo.get("mobileTelNum").toString();
        				
        				if(!oldText.equals(newText)){
            				ModificationItem[] useYn = new ModificationItem[1];
            				
            				if(newText.equals("")) {
            					useYn[0] = new ModificationItem(DirContext.REMOVE_ATTRIBUTE, new BasicAttribute("mobile"));
            				}else {
            					useYn[0] = new ModificationItem(DirContext.REPLACE_ATTRIBUTE, new BasicAttribute("mobile", newText));	
            				}
            				
            				ldapContextManager.modifyAttributes(ldapKey.get("adName").toString(), useYn);
        				}
        			}
        			
        			//전화번호
        			if(ldapEmpInfo.get("telNumSyncYn").equals("Y") && !ldapEmpInfo.get("telNum").equals("")){
        				
        				String oldText = "";
        				
        				if(searchResult.getAttributes().get("telephoneNumber") != null){
        					oldText = searchResult.getAttributes().get("telephoneNumber").get().toString();
        				}
        				
        				String newText = ldapEmpInfo.get("telNum").toString();
        				
        				if(!oldText.equals(newText)){
            				ModificationItem[] useYn = new ModificationItem[1];
            				
            				if(newText.equals("")) {
            					useYn[0] = new ModificationItem(DirContext.REMOVE_ATTRIBUTE, new BasicAttribute("telephoneNumber"));
            				}else {
            					useYn[0] = new ModificationItem(DirContext.REPLACE_ATTRIBUTE, new BasicAttribute("telephoneNumber", newText));	
            				}            				
            				
            				ldapContextManager.modifyAttributes(ldapKey.get("adName").toString(), useYn);        					
        				}
        			}        			

        			//패스워드변경
        			if(!ldapEmpInfo.get("loginPasswd").equals("")){
						String masterPassword = "\"" + "douzone@1234" + "\"";
						byte[] masterPasswordIni = masterPassword.getBytes("UTF-16LE");
						String newPassword = "\"" + ldapEmpInfo.get("loginPasswd").toString() + "\"";
						byte[] newPasswordUni = newPassword.getBytes("UTF-16LE");        				
        				ModificationItem[] mods = new ModificationItem[2];
        				mods[0] = new ModificationItem(DirContext.REPLACE_ATTRIBUTE, new BasicAttribute("UnicodePwd", masterPasswordIni));
        				mods[1] = new ModificationItem(DirContext.REPLACE_ATTRIBUTE, new BasicAttribute("UnicodePwd", newPasswordUni));
        				ldapContextManager.modifyAttributes(ldapKey.get("adName").toString(), mods);
            			paramMap.put("orgDiv", "U");
            			paramMap.put("gwSeq", empSeq);
            			paramMap.put("pwSyncYn", "Y");
            			ldapAdapterDAO.updateLdapKey(paramMap);
        			}
        			
    				//부서이동 등 수정
    				if(ldapEmpInfo.get("deptSeq") != null && !ldapEmpInfo.get("deptSeq").equals("") && !ldapKey.get("relateDeptSeq").equals(ldapEmpInfo.get("deptSeq"))){
    					//부서이동
    					if(!adName.equals(ldapKey.get("adName"))){
    						ldapContextManager.rename(ldapKey, adName);
    					}
    					
            			paramMap.put("adName", adName);
            			paramMap.put("orgDiv", "U");
            			paramMap.put("gwSeq", empSeq);
            			paramMap.put("relateDeptSeq", ldapEmpInfo.get("deptSeq"));
            			ldapAdapterDAO.updateLdapKey(paramMap);
    				}
            	}
    		}else{
    			//기존부서정보 없음
    			paramMap.put("syncStatus", "E");
    			paramMap.put("errorMsg", BizboxAMessage.getMessage("TX800000054","사원정보 없음"));
    			ldapAdapterDAO.updateLdapEmpResult(paramMap);
    			return;        			
    		}        	
        }
        
		paramMap.put("syncStatus", "C");
		ldapAdapterDAO.updateLdapEmpResult(paramMap);
		
		return;
	}
	
	public byte[] createUnicodePassword(String password){
	    return toUnicodeBytes(doubleQuoteString(password));
	}

	private byte[] toUnicodeBytes(String str){
	    byte[] unicodeBytes = null;
	    try{
	        byte[] unicodeBytesWithQuotes = str.getBytes("Unicode");
	        unicodeBytes = new byte[unicodeBytesWithQuotes.length - 2];
	        System.arraycopy(unicodeBytesWithQuotes, 2, unicodeBytes, 0,
	            unicodeBytesWithQuotes.length - 2);
	    } catch(UnsupportedEncodingException e){
	        // This should never happen.
	    	CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
	    }
	    return unicodeBytes;
	}	
	
	private String doubleQuoteString(String str){
	    StringBuffer sb = new StringBuffer();
	    sb.append("\"");
	    sb.append(str);
	    sb.append("\"");
	    return sb.toString();
	}	
	
	@Override
    public Map<String, Object> ldapConnectionCheck(Map<String, Object> paramMap) throws NamingException {
		Map<String, Object> resultMap = new HashMap<String, Object>();

		try{
			
			paramMap.put("ldapType", "AD");
			ldapContextManager = LdapContextManagerFactory.createLdapContext(LdapContextType.ACTIVEDIRECTORY, paramMap);
			
			if(paramMap.get("baseDir") != null && !paramMap.get("baseDir").equals("")){
				if(paramMap.get("syncMode") != null && (paramMap.get("syncMode").equals("gta") || paramMap.get("syncMode").equals("atg"))){
					//조직도OU체크
					if(paramMap.get("deptDir") != null && !paramMap.get("deptDir").equals("")){

						NamingEnumeration<SearchResult> results = ldapContextManager.getOuList(paramMap);
						if(!results.hasMoreElements()) {
							resultMap.put("result", BizboxAMessage.getMessage("TX800000060","입력하신 조직도OU가 존재하지 않습니다."));
							resultMap.put("resultCode", "input");
							return resultMap;					
						}
					}else{
						resultMap.put("result", BizboxAMessage.getMessage("TX800000061","AD 조직도연동 OU경로를 입력해 주세요."));
						resultMap.put("resultCode", "input");
						return resultMap;
					}
					
					if(paramMap.get("syncMode").equals("gta")){
						//퇴사자 OU체크
						if(paramMap.get("empDir") != null && !paramMap.get("empDir").equals("")){
							NamingEnumeration<SearchResult> results = ldapContextManager.getOuListFromEmpDir(paramMap);
							if(!results.hasMoreElements()) {
								resultMap.put("result", BizboxAMessage.getMessage("TX800000062","입력하신 퇴사자이동 OU가 존재하지 않습니다."));
								resultMap.put("resultCode", "input");
								return resultMap;					
							}					
						}else{
							resultMap.put("result", BizboxAMessage.getMessage("TX800000063","AD 퇴사자이동 OU경로를 입력해 주세요."));
							resultMap.put("resultCode", "input");
							return resultMap;
						}							
					}
				}

			}else{
				resultMap.put("result", BizboxAMessage.getMessage("TX800000064","AD도메인 경로를 입력해 주세요."));
				resultMap.put("resultCode", "input");
				return resultMap;				
			}
			
			resultMap.put("result", BizboxAMessage.getMessage("TX800000065","LDAP 정상연결"));
			resultMap.put("resultCode", "SUCCESS");
			return resultMap;
		 }
		 catch (Exception e) {
				resultMap.put("result", e.getMessage());
				resultMap.put("resultCode", "fail");
				return resultMap;
		 }
    }
	
	@Override
    public Map<String, Object> ldapAuthCheck(Map<String, Object> paramMap) throws NamingException, UnsupportedEncodingException {
		Map<String, Object> resultMap = new HashMap<String, Object>();
		
		//패스워드 암호화
		try {
			paramMap.put("loginPasswdEnc", CommonUtil.passwordEncrypt(paramMap.get("loginPasswd").toString()));
		} catch (Exception e1) {
			paramMap.put("loginPasswdEnc", "");
		}
		Map<String, Object> empLoginCheckInfo = ldapAdapterDAO.selectEmpLoginCheckInfo(paramMap);
		
		if(empLoginCheckInfo == null){
			resultMap.put("resultCode", "fail");
			return resultMap;	
		}
		
		if(empLoginCheckInfo.get("ldapUseYn").equals("Y")){
			
			Hashtable<String, Object> env = new Hashtable<String, Object>();
			boolean pwUpdateFromAd = false;
			
			//GTA모드에서 최초 패스워드전송이 안된경우 패스워드변경 처리
			if(empLoginCheckInfo.get("syncMode").equals("gta") && empLoginCheckInfo.get("pwSyncYn").equals("N")){
				
				if(!empLoginCheckInfo.get("encPasswordCheck").equals("Y")){
					resultMap.put("resultCode", "fail");
					return resultMap;
				}
				
		        env.put(Context.SECURITY_AUTHENTICATION, "simple");
		        env.put(Context.SECURITY_PRINCIPAL, empLoginCheckInfo.get("userid").toString() + "@" + empLoginCheckInfo.get("adDomain").toString());
		        env.put(Context.SECURITY_CREDENTIALS, empLoginCheckInfo.get("password"));
		        env.put(Context.INITIAL_CONTEXT_FACTORY, "com.sun.jndi.ldap.LdapCtxFactory");
		        env.put(Context.PROVIDER_URL, "ldap://" + empLoginCheckInfo.get("adIp").toString() + ":636");
		        env.put(Context.SECURITY_PROTOCOL, "ssl");
				
		        DirContext ctx = null;
		        
		        try{
		        	ctx = new InitialLdapContext(env, null);	
		        }catch (Exception e) {
		        	resultMap.put("resultCode", "fail");
		        	return resultMap;
		        }
				
				//패스워드변경
				String masterPassword = "\"" + "douzone@1234" + "\"";
				byte[] masterPasswordIni = masterPassword.getBytes("UTF-16LE");
				String newPassword = "\"" + paramMap.get("loginPasswd").toString() + "\"";
				byte[] newPasswordUni = newPassword.getBytes("UTF-16LE");        				
				ModificationItem[] mods = new ModificationItem[2];
				mods[0] = new ModificationItem(DirContext.REPLACE_ATTRIBUTE, new BasicAttribute("UnicodePwd", masterPasswordIni));
				mods[1] = new ModificationItem(DirContext.REPLACE_ATTRIBUTE, new BasicAttribute("UnicodePwd", newPasswordUni));
				
		        try{
		        	ctx.modifyAttributes(empLoginCheckInfo.get("adName").toString(), mods);
		        	ctx.close();
		        	pwUpdateFromAd = true;
		        }catch (Exception e) {
		        	ctx.close();
		        	resultMap.put("resultCode", "fail");
		        	return resultMap;
		        }				
			}
			
			//AD 패스워드 체크
	        env.put(Context.SECURITY_AUTHENTICATION, "simple");
	        env.put(Context.SECURITY_PRINCIPAL, paramMap.get("loginId").toString() + "@" + empLoginCheckInfo.get("adDomain").toString());
	        env.put(Context.SECURITY_CREDENTIALS, paramMap.get("loginPasswd"));
	        env.put(Context.INITIAL_CONTEXT_FACTORY, "com.sun.jndi.ldap.LdapCtxFactory");
	        
	        if(empLoginCheckInfo.get("syncMode").equals("gta")){
	            env.put(Context.PROVIDER_URL, "ldap://" + empLoginCheckInfo.get("adIp").toString() + ":636");
	            env.put(Context.SECURITY_PROTOCOL, "ssl");
	        }else{
	            env.put(Context.PROVIDER_URL, "ldap://" + empLoginCheckInfo.get("adIp").toString());
	        }	        
	        
	        try{
	        	new InitialLdapContext(env, null);
	        	
	        	if(pwUpdateFromAd){
		        	//패스워드 업데이트 완료
					paramMap.put("orgDiv", "U");
					paramMap.put("gwSeq", empLoginCheckInfo.get("gwSeq"));
					paramMap.put("pwSyncYn", "Y");
					ldapAdapterDAO.updateLdapKey(paramMap);
					
	        	}else if(BizboxAProperties.getCustomProperty("BizboxA.Cust.LdapLogon").equals("Y")){
	        		//인증 성공 시 GW패스워드 업데이트
	        		ldapAdapterDAO.updateLoginpwFromLdap(paramMap);
	        	}
	        	
	        }catch (Exception e) {
	        	
	        	if(!pwUpdateFromAd && (e.getMessage().indexOf("data 531") > 0 || e.getMessage().indexOf("data 0") > 0)) {
	        		ldapAdapterDAO.updateLoginpwFromLdap(paramMap);   		
	        	}else {
		        	resultMap.put("resultCode", "fail");
		        	return resultMap;
	        	}
	        }
			
		}else if(empLoginCheckInfo.get("encPasswordCheck").equals("N")){
			//AD인증 미사용시 일반 패스워드 체크실패
			resultMap.put("resultCode", "fail");
			return resultMap;				
		}
		
		resultMap.put("resultCode", "SUCCESS");
		
		return resultMap;

    }
	
	@Override
    public boolean ldapPasswdLiveChange(Map<String, Object> paramMap) throws UnsupportedEncodingException, NamingException {
		
		logger.debug("LdapAdapterService.ldapPasswdLiveChange : param > " + paramMap);
		Map<String, Object> ldapPasswdLiveChangeInfo = ldapAdapterDAO.selectLdapPasswdLiveChangeInfo(paramMap);
		logger.debug("LdapAdapterService.ldapPasswdLiveChange : ldapPasswdLiveChangeInfo > " + ldapPasswdLiveChangeInfo);
		
		if(ldapPasswdLiveChangeInfo == null){
			paramMap.put("nonKey","Y");
			ldapPasswdLiveChangeInfo = ldapAdapterDAO.selectLdapPasswdLiveChangeInfo(paramMap);
			logger.debug("LdapAdapterService.ldapPasswdLiveChange : ldapPasswdLiveChangeInfo(nonKey) > " + ldapPasswdLiveChangeInfo);
		}else{
			paramMap.put("nonKey","N");
		}
		
		if(ldapPasswdLiveChangeInfo != null && !ldapPasswdLiveChangeInfo.get("userid").equals(ldapPasswdLiveChangeInfo.get("loginId"))){
			
			if(ldapPasswdLiveChangeInfo.get("syncMode").equals("atg") && !BizboxAProperties.getCustomProperty("BizboxA.Cust.LdapApiUrl").equals("99")) {
				
				String apiUrl = BizboxAProperties.getCustomProperty("BizboxA.Cust.LdapApiUrl");
	
				if(!apiUrl.equals("")){
					try{
						URL url = new URL(apiUrl); // 호출할 url
				        Map<String,Object> params = new LinkedHashMap<>(); // 파라미터 세팅
				        params.put("apiName", "modifyPasswd");
				        params.put("LDAP_USER_PATH", ldapPasswdLiveChangeInfo.get("deptDir"));
				        params.put("LDAP_AUTH_ID", ldapPasswdLiveChangeInfo.get("userid"));
				        params.put("LDAP_AUTH_PW", ldapPasswdLiveChangeInfo.get("password"));
				        params.put("USER_ID", ldapPasswdLiveChangeInfo.get("loginId"));
				        params.put("USER_PW", paramMap.get("loginPasswd"));
					 
				        StringBuilder postData = new StringBuilder();
				        for(Map.Entry<String,Object> param : params.entrySet()) {
				            if(postData.length() != 0) {
				            	postData.append('&');
				            }
				            postData.append(URLEncoder.encode(param.getKey(), "UTF-8"));
				            postData.append('=');
				            postData.append(URLEncoder.encode(String.valueOf(param.getValue()), "UTF-8"));
				        }
				        byte[] postDataBytes = postData.toString().getBytes("UTF-8");
				 
				        HttpURLConnection conn = (HttpURLConnection)url.openConnection();
				        conn.setRequestMethod("POST");
				        conn.setRequestProperty("Content-Type", "application/x-www-form-urlencoded");
				        conn.setRequestProperty("Content-Length", String.valueOf(postDataBytes.length));
				        conn.setDoOutput(true);
				        conn.getOutputStream().write(postDataBytes); // POST 호출
				 
				        BufferedReader in = new BufferedReader(new InputStreamReader(conn.getInputStream(), "UTF-8"));
				        StringBuffer output = new StringBuffer();
				        
				        
			            String result = "";			
						while ((result = in.readLine())!= null) {
							output.append(result);
						}				        
				        
						result = output.toString();
				        in.close();
				        
				        if(result.indexOf("SUCCESS") < 0) {
							logger.debug("LdapAdapterService.ldapPasswdLiveChange.ldapPasswdLiveChangeInfo[" + apiUrl + "] : Exception > " + result);
							return false;				        	
				        }
						
					}catch(Exception ex){
						logger.debug("LdapAdapterService.ldapPasswdLiveChange.ldapPasswdLiveChangeInfo[" + apiUrl + "] : Exception > " + ex.getMessage());
						return false;
					}
				}
			}else {

				Hashtable<String, Object> env = new Hashtable<String, Object>();
		        env.put(Context.SECURITY_AUTHENTICATION, "simple");
		        env.put(Context.SECURITY_PRINCIPAL, ldapPasswdLiveChangeInfo.get("userid").toString() + "@" + ldapPasswdLiveChangeInfo.get("adDomain").toString());
		        env.put(Context.SECURITY_CREDENTIALS, ldapPasswdLiveChangeInfo.get("password"));
		        env.put(Context.INITIAL_CONTEXT_FACTORY, "com.sun.jndi.ldap.LdapCtxFactory");
		        env.put(Context.PROVIDER_URL, "ldap://" + ldapPasswdLiveChangeInfo.get("adIp").toString() + ":636");
		        env.put(Context.SECURITY_PROTOCOL, "ssl");
				
		        DirContext ctx = null;
		        
		        try{
		        	ctx = new InitialLdapContext(env, null);	
		        }catch (Exception e) {
		        	logger.debug("LdapAdapterService.ldapPasswdLiveChange.InitialLdapContext : Exception > " + e.getMessage());
		        	return false;
		        }
				
				//패스워드변경
				String masterPassword = "\"" + "douzone@1234" + "\"";
				byte[] masterPasswordIni = masterPassword.getBytes("UTF-16LE");
				String newPassword = "\"" + paramMap.get("loginPasswd").toString() + "\"";
				byte[] newPasswordUni = newPassword.getBytes("UTF-16LE");        				
				ModificationItem[] mods = new ModificationItem[2];
				mods[0] = new ModificationItem(DirContext.REPLACE_ATTRIBUTE, new BasicAttribute("UnicodePwd", masterPasswordIni));
				mods[1] = new ModificationItem(DirContext.REPLACE_ATTRIBUTE, new BasicAttribute("UnicodePwd", newPasswordUni));
				
		        try{
			        
			        SearchControls scSubtree = new SearchControls();
			        scSubtree.setSearchScope(SearchControls.SUBTREE_SCOPE);
			        
			        String loginId = (String) ldapPasswdLiveChangeInfo.get("loginId");
			        loginId = loginId.replaceAll("", "");
			        
			        NamingEnumeration<SearchResult> result = ctx.search(ldapPasswdLiveChangeInfo.get("baseDir").toString(), "(sAMAccountName=" + loginId + ")", scSubtree);
	 				
					if(result.hasMoreElements()){
						SearchResult searchResult = result.nextElement();
						ldapPasswdLiveChangeInfo.put("adName", searchResult.getAttributes().get("distinguishedName").get());
						ldapPasswdLiveChangeInfo.put("usn", searchResult.getAttributes().get("usncreated").get());
					}else{
			        	logger.debug("LdapAdapterService.ldapPasswdLiveChange.ldapPasswdLiveChangeInfo : Exception > 계정없음(" + ldapPasswdLiveChangeInfo.get("loginId").toString() + ")");
			        	return false;						
					}
		        	
		        	ctx.modifyAttributes(ldapPasswdLiveChangeInfo.get("adName").toString(), mods);
		        	ctx.close();
		        }catch (Exception e) {
		        	ctx.close();
		        	logger.debug("LdapAdapterService.ldapPasswdLiveChange.ldapPasswdLiveChangeInfo : Exception > " + e.getMessage());
		        	return false;
		        }				
			}
			
			if(paramMap.get("nonKey") != null && paramMap.get("nonKey").equals("Y")){
		        Map<String, Object> insertLdapKeyInfo = new HashMap<String, Object>();
		        insertLdapKeyInfo.put("orgDiv", ldapPasswdLiveChangeInfo.get("orgDiv"));
		        insertLdapKeyInfo.put("gwSeq", ldapPasswdLiveChangeInfo.get("gwSeq"));
		        insertLdapKeyInfo.put("usn", ldapPasswdLiveChangeInfo.get("usn"));
		        insertLdapKeyInfo.put("adName", ldapPasswdLiveChangeInfo.get("adName"));
		        insertLdapKeyInfo.put("relateDeptSeq", ldapPasswdLiveChangeInfo.get("relateDeptSeq"));
		        insertLdapKeyInfo.put("compSeq", ldapPasswdLiveChangeInfo.get("compSeq"));
		        insertLdapKeyInfo.put("pwSyncYn", "Y");
				ldapAdapterDAO.setLdapKey(insertLdapKeyInfo);
			}else{
		        Map<String, Object> updateLdapKeyInfo = new HashMap<String, Object>();
		        updateLdapKeyInfo.put("orgDiv", ldapPasswdLiveChangeInfo.get("orgDiv"));
		        updateLdapKeyInfo.put("gwSeq", ldapPasswdLiveChangeInfo.get("gwSeq"));
		        updateLdapKeyInfo.put("pwSyncYn", "Y");
		        ldapAdapterDAO.updateLdapKey(updateLdapKeyInfo);				
			}
	        
	        logger.debug("LdapAdapterService.ldapPasswdLiveChange : success");
			return true;
		}
		
		logger.debug("LdapAdapterService.ldapPasswdLiveChange : false");
		return false;
    }	
	
	@Override
	public Map<String, Object> ldapSyncDetailList(Map<String, Object> params, PaginationInfo paginationInfo) {
		return commonSql.listOfPaging2(params, paginationInfo, "LdapManage.selectLdapSyncList");
	}
	
	@Override
	public Map<String, Object> ldapAtgUserList(Map<String, Object> params, PaginationInfo paginationInfo) {
		return commonSql.listOfPaging2(params, paginationInfo, "LdapManage.selectLdapAtgUserList");
	}	
	
	@Override
	public Map<String, Object> ldapSyncDetail(Map<String, Object> params, PaginationInfo paginationInfo) {
		return commonSql.listOfPaging2(params, paginationInfo, "LdapManage.selectLdapSyncDetail");
	}
	
	public List<Map<String,Object>> ldapOuListInfo(Map<String, Object> ldapDeptInfo) throws NamingException{
		List<Map<String, Object>> list = new ArrayList<Map<String,Object>>();
		Map<String, Object> items = new HashMap<String, Object>();

		NamingEnumeration<SearchResult> results = ldapContextManager.getOuListFromDeptDir(ldapDeptInfo);

	    while (results.hasMoreElements()) {
	    	SearchResult searchResult = results.nextElement();

	    	String deptDir = ldapDeptInfo.get("deptDir").toString();
	    	String distinguishedName = ldapContextManager.getDistinguishedName(searchResult);
	    	if(!distinguishedName.equals(deptDir)){
		    	items = new HashMap<String, Object>();
		    	items.put("distinguishedName", distinguishedName);
		    	distinguishedName = distinguishedName.replace("," + deptDir, "");
		    	items.put("id", distinguishedName);
				items.put("upperId", distinguishedName.replaceFirst(ldapContextManager.getOuFromSearchResult(searchResult), ""));
				
				if(items.get("id").equals(items.get("upperId"))){
					items.put("upperId","0");
				}
				
				items.put("key", ldapContextManager.getUsncreated(searchResult));
				items.put("name", ldapContextManager.getName(searchResult));
				list.add(items);	    		
	    	}
	    }		
		
		return list;
	}
	
	public void ldapGarbageCheck(Map<String, Object> params){
		commonSql.delete("LdapManage.deleteGarbageLdapKey", params);
	}
	
	public void ldapGarbageUserCheck(Map<String, Object> params){
		commonSql.delete("LdapManage.deleteGarbageLdapEmp", params);
	}	
	
	public void ldapdeleteRemoveLdapKey(Map<String, Object> params){
		commonSql.delete("LdapManage.deleteRemoveLdapKey", params);
	}	
	
	public String ldapKeyList(Map<String, Object> params){
		return (String) commonSql.select("LdapManage.ldapKeyList", params);
	}
	
	public void insertOuInfo(Map<String, Object> params) throws Exception{
		
		@SuppressWarnings("unchecked")
		Map<String, Object> ldapKey = (Map<String, Object>) commonSql.select("LdapManage.selectLdapKeyUsn", params);
		
		if(ldapKey == null){
			
			Map<String, Object> deptParam = new HashMap<String, Object>();
			deptParam.putAll(params);
			deptParam.put("orgDiv", "D");
			deptParam.put("gwSeq", params.get("parentSeq"));
			@SuppressWarnings("unchecked")
			Map<String, Object> parLdapKey = (Map<String, Object>) commonSql.select("LdapManage.selectLdapKey", deptParam);
			
			String parentDeptSeq = "0";
			
			if(parLdapKey != null){
				parentDeptSeq = parLdapKey.get("relateDeptSeq").toString();
			}
			
			//부서등록
			deptParam.put("parentDeptSeq", parentDeptSeq);
			deptParam.put("bizSeq", deptParam.get("compSeq"));
			deptParam.put("useYn", "Y");
			deptParam.put("teamYn", "N");
			deptParam.put("deptType", "D");
			deptParam.put("deptCd", params.get("seq"));
			Map<String,Object> deptSaveAdapterResult = orgAdapterService.deptSaveAdapter(deptParam);
			
			if(deptSaveAdapterResult != null && deptSaveAdapterResult.get("resultCode").equals("SUCCESS")){
				deptParam.put("orgDiv", "D");
				deptParam.put("gwSeq", params.get("seq"));
				deptParam.put("usn", params.get("usn"));
				deptParam.put("adName", params.get("adName"));
				deptParam.put("relateDeptSeq", deptSaveAdapterResult.get("newDeptSeq"));
				ldapAdapterDAO.setLdapKey(deptParam);
			}
		}
		
	}
	
	public void ldapGetAdUserInfo(Map<String, Object> params) throws NamingException{
		
		List<Map<String, Object>> ldapKeyAll = ldapAdapterDAO.ldapSelectLdapKeyAll(params);
		
		if(ldapKeyAll.size() > 0){
		
			String ldapUserKeyArray = ldapAdapterDAO.ldapUserKeyArray(params);
	        
	        List<Map<String, Object>> userInfoList = new ArrayList<Map<String,Object>>();
			
			for(Map<String,Object> map : ldapKeyAll) {
		        
				//부서OU체크
				NamingEnumeration<SearchResult> deptOuResults = ldapContextManager.getOuListNamedAdName(params, map);
				if(deptOuResults.hasMoreElements()) {

					NamingEnumeration<SearchResult> results = ldapContextManager.getUserListNamedAdName(map);
				    while (results.hasMoreElements()) {
				    	SearchResult searchResult = results.nextElement();
				    	
				    	if(ldapUserKeyArray.indexOf("," + ldapContextManager.getUsncreated(searchResult).toString() + ",") == -1){
				    		Map<String, Object> userInfo = new HashMap<String, Object>();
				    		userInfo.put("syncSeq", ldapContextManager.getUsncreated(searchResult));
				    		userInfo.put("loginId", ldapContextManager.getSamAccountName(searchResult));
				    		userInfo.put("empName", ldapContextManager.getName(searchResult));
				    		userInfo.put("syncType", "I");
				    		userInfo.put("compSeq", params.get("compSeq").toString());
				    		userInfo.put("deptSeq", map.get("relateDeptSeq").toString());
				    		userInfo.put("empSeq", "");

				    		String mail = ldapContextManager.getMail(searchResult) == null ? "" : ldapContextManager.getMail(searchResult).get().toString();
				    		
				    		if(mail.contains("@")){
				    			userInfo.put("emailAddr", mail.split("@")[0]);
				    			userInfo.put("emailDomain", mail.split("@")[1]);	
				    		}else{
				    			userInfo.put("emailAddr", "");
				    			userInfo.put("emailDomain", "");				    			
				    		}
				    		
				    		userInfo.put("dutyCode", "");
				    		userInfo.put("mobileTelNum", ldapContextManager.getMobile(searchResult) == null ? "" : ldapContextManager.getMobile(searchResult).get());
				    		userInfo.put("faxNum", ldapContextManager.getFacsimileTelephoneNumber(searchResult) == null ? "" : ldapContextManager.getFacsimileTelephoneNumber(searchResult).get());
				    		userInfo.put("homeTelNum", ldapContextManager.getHomePhone(searchResult) == null ? "" : ldapContextManager.getHomePhone(searchResult).get());
				    		userInfo.put("telNum", ldapContextManager.getTelephoneNumber(searchResult) == null ? "" : ldapContextManager.getTelephoneNumber(searchResult).get());
				    		userInfo.put("loginPasswd", ldapContextManager.getDistinguishedName(searchResult));
				    		userInfo.put("useYn", "");
				    		userInfoList.add(userInfo);
				    	}
				    }						
				}	        
			}		
			
			if(userInfoList.size() > 0){
				params.put("userInfoList", userInfoList);
				ldapAdapterDAO.insertLdapEmpList(params);	
			}
		}
	}
	
	public void insertLdapAtgNewUserList(Map<String, Object> params) throws Exception{
		
		@SuppressWarnings("unchecked")
		List<Map<String, Object>> ldapAtgNewUserList = (List<Map<String, Object>>) commonSql.list("LdapManage.selectLdapAtgNewUserList", params);
		
		if(ldapAtgNewUserList != null && ldapAtgNewUserList.size() > 0){
			
			for(Map<String,Object> ldapUserInfo : ldapAtgNewUserList) {
				
				Map<String, Object> empParam = new HashMap<String, Object>();
				empParam.putAll(params);

				empParam.put("empSeq", "");
				empParam.put("loginId", ldapUserInfo.get("loginId"));
				empParam.put("compSeq", ldapUserInfo.get("compSeq"));
				empParam.put("bizSeq", ldapUserInfo.get("bizSeq"));
				empParam.put("deptSeq", ldapUserInfo.get("deptSeq"));
				empParam.put("empName", ldapUserInfo.get("empName"));
				
				empParam.put("emailAddr", ldapUserInfo.get("emailAddr"));
				empParam.put("outMail", ldapUserInfo.get("outMail"));
				empParam.put("outDomain", ldapUserInfo.get("outDomain"));
				
				empParam.put("mobileTelNum", ldapUserInfo.get("mobileTelNum"));
				empParam.put("faxNum", ldapUserInfo.get("faxNum"));
				empParam.put("homeTelNum", ldapUserInfo.get("homeTelNum"));
				
				empParam.put("loginPasswdNew", "douzone@1234");
				empParam.put("useYn", "Y");
				empParam.put("workStatus", "999");
				
				Map<String,Object> empSaveAdapterResult = orgAdapterService.empSaveAdapter(empParam);
				
				if(empSaveAdapterResult.get("resultCode").equals("SUCCESS")){
					empParam.put("empSeq", empSaveAdapterResult.get("newEmpSeq"));
					empParam.put("syncStatus", "N");
				}else{
					empParam.put("errorMsg", empSaveAdapterResult.get("result"));
					empParam.put("syncStatus", "F");
				}
				
				empParam.put("syncSeq", ldapUserInfo.get("syncSeq"));
				commonSql.update("LdapManage.updateLdapEmpAtg", empParam);
			}
		}
	}	
}