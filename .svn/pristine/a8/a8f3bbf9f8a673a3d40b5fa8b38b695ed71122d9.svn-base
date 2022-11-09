package neos.cmm.systemx.ldapAdapter.context;

import java.io.UnsupportedEncodingException;
import java.util.Map;

import javax.naming.NamingEnumeration;
import javax.naming.NamingException;
import javax.naming.directory.Attribute;
import javax.naming.directory.Attributes;
import javax.naming.directory.BasicAttribute;
import javax.naming.directory.BasicAttributes;
import javax.naming.directory.ModificationItem;
import javax.naming.directory.SearchResult;

public class LdapContextActiveDirectory extends LdapContextManager {
	public LdapContextActiveDirectory(Map<String, Object> paramMap) throws NamingException {
		super(paramMap);
	}
	
	public void createSubcontext(String adName, Attributes attrs) throws NamingException {
		ctx.createSubcontext(adName, attrs);
	}
	
	public Attributes getAttributes(String attrName) throws NamingException {
		return ctx.getAttributes(attrName);
	}
	
	public void destroySubcontext(Map<String, Object> paramMap) throws NamingException {
		ctx.destroySubcontext(paramMap.get("adName").toString());
	}
	
	public void rename(Map<String, Object> paramMap, String name) throws NamingException {
		ctx.rename(paramMap.get("adName").toString(), name);
	}
	
	public void modifyAttributes(String modValue, ModificationItem[] mod) throws NamingException {
		ctx.modifyAttributes(modValue, mod);
	}
	
	public String addUser(Map<String, Object> paramMap, Map<String, Object> ldapEmpInfo, String loginId, String cnName, String adName) throws NamingException, UnsupportedEncodingException {
		//없을경우 등록
        Attributes container = new BasicAttributes();
        Attribute objClasses = new BasicAttribute("objectClass");
        objClasses.add("top");
        objClasses.add("person");
        objClasses.add("organizationalPerson");
        objClasses.add("user");
        container.put(objClasses);
        container.put(new BasicAttribute("sAMAccountName", loginId));
        container.put(new BasicAttribute("userPrincipalName", loginId + "@" + ldapEmpInfo.get("adDomain").toString()));
        container.put(new BasicAttribute("cn", cnName));
        container.put(new BasicAttribute("sn", cnName));
        container.put(new BasicAttribute("givenName", cnName));
        container.put(new BasicAttribute("uid", loginId));
        
        if(ldapEmpInfo.get("erpEmpSeq") != null && !ldapEmpInfo.get("erpEmpSeq").equals("")){
            container.put(new BasicAttribute("employeeID", ldapEmpInfo.get("erpEmpSeq").toString()));   	
        }
        
		if(ldapEmpInfo.get("emailSyncYn").equals("Y") && !ldapEmpInfo.get("emailAddr").equals("") && !ldapEmpInfo.get("emailDomain").equals("")){
			container.put(new BasicAttribute("mail", ldapEmpInfo.get("emailAddr").toString() + "@" + ldapEmpInfo.get("emailDomain").toString()));
		}
        
        if(ldapEmpInfo.get("telNumSyncYn").equals("Y") && !ldapEmpInfo.get("mobileTelNum").equals("")){
        	container.put(new BasicAttribute("mobile", ldapEmpInfo.get("mobileTelNum")));
        }
        
        if(ldapEmpInfo.get("telNumSyncYn").equals("Y") && !ldapEmpInfo.get("telNum").equals("")){
        	container.put(new BasicAttribute("telephoneNumber", ldapEmpInfo.get("telNum")));
        }
        
        //패스워드
        if(ldapEmpInfo.get("loginPasswd") != null && !ldapEmpInfo.get("loginPasswd").equals("")){
        	//입력한 경우
        	String createQuotedPassword = "\"" + ldapEmpInfo.get("loginPasswd").toString() + "\"";
        	byte[] createUnicodePassword = createQuotedPassword.getBytes("UTF-16LE");
        	container.put(new BasicAttribute("unicodePwd", createUnicodePassword));
        	paramMap.put("pwSyncYn", "Y");
        }else{
        	//없는 경우
        	String createQuotedPassword = "\"" + "douzon@1234" + "\"";
        	byte[] createUnicodePassword = createQuotedPassword.getBytes("UTF-16LE");
        	container.put(new BasicAttribute("unicodePwd", createUnicodePassword));    	        	
        	paramMap.put("pwSyncYn", "N");
        }
        
        container.put(new BasicAttribute("userAccountControl", "65536")); // 사용 : 65536, 미사용 : 65538

        createSubcontext(adName, container);
        
        return adName;
	}

	public NamingEnumeration<SearchResult> getOuList(Map<String, Object> paramMap) throws NamingException {
		return ctx.search(paramMap.get("baseDir").toString(), 
				"(&(distinguishedName=" + paramMap.get("deptDir").toString() + ")(objectCategory=organizationalunit))", scSubtree);
	}
	
	public NamingEnumeration<SearchResult> getOuListFromMap(Map<String, Object> paramMap, Map<String, Object> map) throws NamingException {
		return ctx.search(paramMap.get("deptDir").toString(),
				"(&(distinguishedName=" + map.get("adName").toString() + ")(objectCategory=organizationalunit))", scSubtree);
	}

	public NamingEnumeration<SearchResult> getOuListFromEmpDir(Map<String, Object> paramMap) throws NamingException {
		return ctx.search(paramMap.get("baseDir").toString(), 
				"(&(distinguishedName=" + paramMap.get("empDir").toString() + ")(objectCategory=organizationalunit))", scSubtree);
	}
	
	public NamingEnumeration<SearchResult> getOuListFromDeptDir(Map<String, Object> paramMap) throws NamingException {
		return ctx.search(paramMap.get("deptDir").toString(), "(objectCategory=organizationalunit)", scSubtree);
	}
	
	public NamingEnumeration<SearchResult> getOuListNamedAdName(Map<String, Object> paramMap, Map<String, Object> map) throws NamingException {
		return ctx.search(paramMap.get("baseDir").toString(), 
				"(&(distinguishedName=" + map.get("adName").toString() + ")(objectCategory=organizationalunit))", scSubtree);
	}
	
	public NamingEnumeration<SearchResult> getOuListNamedAdName(Map<String, Object> paramMap, String parentAdName) throws NamingException {
		String adName = "OU=" + paramMap.get("deptName").toString() + "," + parentAdName;
		return ctx.search(parentAdName, "(&(distinguishedName=" + adName + ")(objectCategory=organizationalunit))", scOneLevel);
	}
	
	public NamingEnumeration<SearchResult> getUserListNamedAdName(Map<String, Object> map) throws NamingException {
		return ctx.search(map.get("adName").toString(), "(objectCategory=organizationalperson)", scOneLevel);
	}
	
	public NamingEnumeration<SearchResult> getUserListWithLoginID(Map<String, Object> paramMap, String loginId, String baseDir) throws NamingException {
		return ctx.search(paramMap.get(baseDir).toString(), "(sAMAccountName=" + loginId + ")", scSubtree);
	}
	
	public NamingEnumeration<SearchResult> getUserListWithAdName(String dir, String adName, boolean useSubtree) throws NamingException {
		return ctx.search(dir, "(&(distinguishedName=" + adName + ")(objectCategory=organizationalperson))", useSubtree ? scSubtree : scOneLevel);
	}
	
	public String getDistinguishedName(SearchResult searchResult) throws NamingException {
		return searchResult.getAttributes().get("distinguishedName").get().toString();
	}
	
	public String getOuFromSearchResult(SearchResult searchResult) throws NamingException {
		return "OU=" + searchResult.getAttributes().get("ou").get().toString() + ",";
	}
	
	public Object getUsncreated(SearchResult searchResult) throws NamingException {
		return searchResult.getAttributes().get("usncreated").get();
	}
	
	public Object getName(SearchResult searchResult) throws NamingException {
		return searchResult.getAttributes().get("name").get();
	}
	
	public Object getSamAccountName(SearchResult searchResult) throws NamingException {
		return searchResult.getAttributes().get("samaccountname").get();
	}
	
	public Attribute getMail(SearchResult searchResult) throws NamingException {
		return searchResult.getAttributes().get("mail");
	}
	
	public Attribute getMobile(SearchResult searchResult) throws NamingException {
		return searchResult.getAttributes().get("mobile");
	}
	
	public Attribute getFacsimileTelephoneNumber(SearchResult searchResult) throws NamingException {
		return searchResult.getAttributes().get("facsimileTelephoneNumber");
	}
	
	public Attribute getHomePhone(SearchResult searchResult) throws NamingException {
		return searchResult.getAttributes().get("homePhone");
	}
	
	public Attribute getTelephoneNumber(SearchResult searchResult) throws NamingException {
		return searchResult.getAttributes().get("telephoneNumber");
	}
	
	public String getAttributesUsnCreated(Attributes attrs) throws NamingException {
		return (String) attrs.get("usncreated").get();
	}
}
