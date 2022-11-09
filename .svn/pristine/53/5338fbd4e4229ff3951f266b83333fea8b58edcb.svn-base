package neos.cmm.systemx.ldapAdapter.service;

import java.io.UnsupportedEncodingException;
import java.security.NoSuchAlgorithmException;
import java.util.List;
import java.util.Map;

import javax.naming.NamingException;
import egovframework.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;

public interface LdapAdapterService {
	
	public Map<String, Object> ldapConnectionCheck(Map<String, Object> params) throws NamingException;
	
	public Map<String, Object> ldapAuthCheck(Map<String, Object> params) throws NamingException, UnsupportedEncodingException;
	
	public void ldapDeptSave(Map<String, Object> params) throws NamingException;
	
	public void ldapEmpSave(Map<String, Object> params) throws NamingException, UnsupportedEncodingException, NoSuchAlgorithmException;
	
	public Map<String, Object> ldapSyncDetailList(Map<String, Object> params, PaginationInfo paginationInfo);
	
	public Map<String, Object> ldapAtgUserList(Map<String, Object> params, PaginationInfo paginationInfo);
	
	public Map<String, Object> ldapSyncDetail(Map<String, Object> params, PaginationInfo paginationInfo);
	
	public boolean ldapPasswdLiveChange(Map<String, Object> params) throws UnsupportedEncodingException, NamingException;
	
	public List<Map<String,Object>> ldapOuListInfo(Map<String, Object> params) throws NamingException;
	
	public void insertOuInfo(Map<String, Object> params) throws Exception;
	
	public void ldapGarbageCheck(Map<String, Object> params);
	
	public void ldapGarbageUserCheck(Map<String, Object> params);
	
	public void ldapdeleteRemoveLdapKey(Map<String, Object> params);
	
	public String ldapKeyList(Map<String, Object> params);
	
	public void ldapGetAdUserInfo(Map<String, Object> params) throws NamingException;
	
	public void insertLdapAtgNewUserList(Map<String, Object> params) throws Exception;
	
}