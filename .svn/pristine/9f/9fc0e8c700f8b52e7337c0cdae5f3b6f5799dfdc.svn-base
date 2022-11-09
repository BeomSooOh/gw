package neos.cmm.systemx.ldapAdapter.context;

import java.io.UnsupportedEncodingException;
import java.security.NoSuchAlgorithmException;
import java.util.Hashtable;
import java.util.Map;

import javax.naming.Context;
import javax.naming.NamingEnumeration;
import javax.naming.NamingException;
import javax.naming.directory.Attribute;
import javax.naming.directory.Attributes;
import javax.naming.directory.DirContext;
import javax.naming.directory.ModificationItem;
import javax.naming.directory.SearchControls;
import javax.naming.directory.SearchResult;
import javax.naming.ldap.InitialLdapContext;

public abstract class LdapContextManager {
	protected DirContext ctx = null;
	SearchControls scSubtree;
	SearchControls scOneLevel;
	
	public LdapContextManager(Map<String, Object> paramMap) throws NamingException {
		makeContext(paramMap);
		initSearchControl();
	}
	
	private void makeContext(Map<String, Object> paramMap) throws NamingException {
		if (ctx == null) {
			if (paramMap.get("ldapType").equals("AD")) {
				makeActiveDirectoryContext(paramMap);
			}
			else {
				makeOpenLDAPContext(paramMap);
			}
		}
	}
	
	private void makeActiveDirectoryContext(Map<String, Object> paramMap) throws NamingException {
		Hashtable<String, Object> env = new Hashtable<String, Object>();
		
		env.put(Context.SECURITY_AUTHENTICATION, "simple");
		env.put(Context.SECURITY_CREDENTIALS, paramMap.get("password"));
		env.put(Context.INITIAL_CONTEXT_FACTORY, "com.sun.jndi.ldap.LdapCtxFactory");
		env.put(Context.SECURITY_PRINCIPAL, paramMap.get("userid").toString() + "@" + paramMap.get("adDomain").toString());
		
		if(paramMap.get("syncMode").equals("gta")) {
            env.put(Context.PROVIDER_URL, "ldap://" + paramMap.get("adIp").toString() + ":636");
            env.put(Context.SECURITY_PROTOCOL, "ssl");
        }
		else {
            env.put(Context.PROVIDER_URL, "ldap://" + paramMap.get("adIp").toString());
        }
		
		ctx = new InitialLdapContext(env, null);
	}
	
	private void makeOpenLDAPContext(Map<String, Object> paramMap) throws NamingException {
		Hashtable<String, Object> env = new Hashtable<String, Object>();
		
		env.put(Context.SECURITY_AUTHENTICATION, "simple");
		env.put(Context.SECURITY_CREDENTIALS, paramMap.get("password"));
		env.put(Context.INITIAL_CONTEXT_FACTORY, "com.sun.jndi.ldap.LdapCtxFactory");
		env.put(Context.SECURITY_PRINCIPAL, paramMap.get("userid").toString());
        env.put(Context.PROVIDER_URL, "ldap://" + paramMap.get("adIp").toString());
		
		ctx = new InitialLdapContext(env, null);
	}
	
	
	private void initSearchControl() {
		scSubtree = new SearchControls();
		scSubtree.setSearchScope(SearchControls.SUBTREE_SCOPE);
		
		scOneLevel = new SearchControls();
		scOneLevel.setSearchScope(SearchControls.ONELEVEL_SCOPE);
	}
	
	public abstract void createSubcontext(String adName, Attributes attrs) throws NamingException;
	public abstract Attributes getAttributes(String attrName) throws NamingException;
	public abstract void destroySubcontext(Map<String, Object> paramMap)  throws NamingException;
	public abstract void rename(Map<String, Object> paramMap, String name) throws NamingException;
	public abstract void modifyAttributes(String modValue, ModificationItem[] mod) throws NamingException;
	public abstract String addUser(Map<String, Object> paramMap, Map<String, Object> ldapEmpInfo, String loginId, String cnName, String adName) 
			throws NamingException, UnsupportedEncodingException, NoSuchAlgorithmException;
	
	public abstract NamingEnumeration<SearchResult> getOuList(Map<String, Object> paramMap) throws NamingException;
	public abstract NamingEnumeration<SearchResult> getOuListFromMap(Map<String, Object> paramMap, Map<String, Object> map) throws NamingException;
	public abstract NamingEnumeration<SearchResult> getOuListFromEmpDir(Map<String, Object> paramMap) throws NamingException;
	public abstract NamingEnumeration<SearchResult> getOuListFromDeptDir(Map<String, Object> paramMap) throws NamingException;
	public abstract NamingEnumeration<SearchResult> getOuListNamedAdName(Map<String, Object> paramMap, Map<String, Object> map) throws NamingException;
	public abstract NamingEnumeration<SearchResult> getOuListNamedAdName(Map<String, Object> paramMap, String parentAdName) throws NamingException;
	public abstract NamingEnumeration<SearchResult> getUserListNamedAdName(Map<String, Object> map) throws NamingException;
	public abstract NamingEnumeration<SearchResult> getUserListWithLoginID(Map<String, Object> paramMap, String loginId, String baseDir) throws NamingException;
	public abstract NamingEnumeration<SearchResult> getUserListWithAdName(String dir, String adName, boolean useSubtree) throws NamingException;

	public abstract String getDistinguishedName(SearchResult searchResult) throws NamingException;
	public abstract String getOuFromSearchResult(SearchResult searchResult) throws NamingException;
	public abstract Object getUsncreated(SearchResult searchResult) throws NamingException;
	public abstract Object getName(SearchResult searchResult) throws NamingException;
	public abstract Object getSamAccountName(SearchResult searchResult) throws NamingException;
	public abstract Attribute getMail(SearchResult searchResult) throws NamingException;
	public abstract Attribute getMobile(SearchResult searchResult) throws NamingException;
	public abstract Attribute getFacsimileTelephoneNumber(SearchResult searchResult) throws NamingException;
	public abstract Attribute getHomePhone(SearchResult searchResult) throws NamingException;
	public abstract Attribute getTelephoneNumber(SearchResult searchResult) throws NamingException;
	public abstract String getAttributesUsnCreated(Attributes attrs) throws NamingException;
}
