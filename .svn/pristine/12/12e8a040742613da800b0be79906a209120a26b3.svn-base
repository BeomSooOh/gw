package neos.cmm.systemx.ldapAdapter.context;

import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.security.SecureRandom;
import java.util.Base64;
import java.util.Map;
import javax.naming.NamingEnumeration;
import javax.naming.NamingException;
import javax.naming.directory.Attribute;
import javax.naming.directory.Attributes;
import javax.naming.directory.BasicAttribute;
import javax.naming.directory.BasicAttributes;
import javax.naming.directory.ModificationItem;
import javax.naming.directory.SearchResult;

public class LdapContextOpenLDAP extends LdapContextManager {
	public LdapContextOpenLDAP(Map<String, Object> paramMap) throws NamingException {
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
	
	public String addUser(Map<String, Object> paramMap, Map<String, Object> ldapEmpInfo, String loginId, String cnName, String adName) throws NamingException, NoSuchAlgorithmException {
		Attributes container = new BasicAttributes();

        // Create the objectclass to add
        Attribute objClasses = new BasicAttribute("objectClass");
        objClasses.add("top");
        objClasses.add("inetOrgPerson");
        objClasses.add("posixAccount");

        // Assign the username, first name, and last name
        Attribute cnValue = new BasicAttribute("cn", cnName);
        Attribute givenName = new BasicAttribute("givenName", cnName);
        Attribute snValue = new BasicAttribute("sn", cnName);
        Attribute uid = new BasicAttribute("uid", loginId);
        
        // Password
        String createQuotedPassword;
        byte[] bytePassword = {};
        if(ldapEmpInfo.get("loginPasswd") != null && !ldapEmpInfo.get("loginPasswd").equals("")) {
        	//입력한 경우
        	createQuotedPassword = ldapEmpInfo.get("loginPasswd").toString();
        	bytePassword = createQuotedPassword.getBytes();
        	paramMap.put("pwSyncYn", "Y");
        }else {
        	//없는 경우
        	createQuotedPassword = "duzon@1234";
        	bytePassword = createQuotedPassword.getBytes();
        	paramMap.put("pwSyncYn", "N");
        }
        
        Attribute userPassword = new BasicAttribute("userpassword", generateSSHA(bytePassword));
        Attribute uidNumber = new BasicAttribute("uidNumber", "11111");
        Attribute gidNumber = new BasicAttribute("gidNumber", "0");
        Attribute homeDir = new BasicAttribute("homeDirectory", "/home/dwchun");

        // Add these to the container
        container.put(objClasses);
        container.put(cnValue);
        container.put(snValue);
        container.put(givenName);
        container.put(uid);
        container.put(userPassword);
        container.put(uidNumber);
        container.put(gidNumber);
        container.put(homeDir);
        
        adName = adName.replaceFirst("CN", "uid");
        ctx.createSubcontext(adName, container);
        
        return adName;
	}

	public NamingEnumeration<SearchResult> getOuList(Map<String, Object> paramMap) throws NamingException {
		String baseDir = paramMap.get("baseDir").toString();
		String deptDir = paramMap.get("deptDir").toString();
		deptDir = deptDir.replaceFirst("," + baseDir, "");
		
		return ctx.search(baseDir,  "(&(" + deptDir + ")(objectClass=organizationalunit))", scSubtree);
	}
	
	public NamingEnumeration<SearchResult> getOuListFromMap(Map<String, Object> paramMap, Map<String, Object> map) throws NamingException {
		return ctx.search(paramMap.get("deptDir").toString(),
				"(&(" + map.get("adName").toString() + ")(objectClass=organizationalunit))", scSubtree);
	}
	
	public NamingEnumeration<SearchResult> getOuListFromEmpDir(Map<String, Object> paramMap) throws NamingException {
		String baseDir = paramMap.get("baseDir").toString();
		String empDir = paramMap.get("empDir").toString();
		empDir = empDir.replaceFirst("," + baseDir, "");
		
		return ctx.search(baseDir, "(&(" + empDir + ")(objectClass=organizationalunit))", scSubtree);
	}
	
	public NamingEnumeration<SearchResult> getOuListFromDeptDir(Map<String, Object> paramMap) throws NamingException {
		return ctx.search(paramMap.get("deptDir").toString(), "(objectClass=organizationalunit)", scSubtree);
	}
	
	public NamingEnumeration<SearchResult> getOuListNamedAdName(Map<String, Object> paramMap, Map<String, Object> map) throws NamingException {
		String adName = map.get("adName").toString();
		int index = adName.indexOf(",");
		adName = adName.substring(0, index);
		return ctx.search(paramMap.get("baseDir").toString(),  "(&(" + adName + ")(objectClass=organizationalunit))", scSubtree);
	}
	
	public NamingEnumeration<SearchResult> getOuListNamedAdName(Map<String, Object> paramMap, String parentAdName) throws NamingException {
		String adName = "OU=" + paramMap.get("deptName").toString() + "," + parentAdName;
		return ctx.search(parentAdName, "(&(" + adName + ")(objectClass=organizationalunit))", scOneLevel);
	}
	
	public NamingEnumeration<SearchResult> getUserListNamedAdName(Map<String, Object> map) throws NamingException {
		return ctx.search(map.get("adName").toString(), "(objectClass=posixAccount)", scOneLevel);
	}
	
	public NamingEnumeration<SearchResult> getUserListWithLoginID(Map<String, Object> paramMap, String loginId, String baseDir) throws NamingException {
		return ctx.search(paramMap.get(baseDir).toString(), "(sAMAccountName=" + loginId + ")", scSubtree);
	}
	
	public NamingEnumeration<SearchResult> getUserListWithAdName(String dir, String adName, boolean useSubtree) throws NamingException {
		return ctx.search(dir, "(&(" + adName + ")(objectClass=posixAccount))", useSubtree ? scSubtree : scOneLevel);
	}
	
	public void modifyAttributes(String modValue, ModificationItem[] mod) throws NamingException {
		return;
	}
	
	public String getDistinguishedName(SearchResult searchResult) throws NamingException {
		return searchResult.getNameInNamespace();
	}
	
	public String getOuFromSearchResult(SearchResult searchResult) throws NamingException {
		return searchResult.getName() + ",";
	}
	
	public Object getUsncreated(SearchResult searchResult) throws NamingException {
		return searchResult.getNameInNamespace();
	}
	
	public Object getName(SearchResult searchResult) throws NamingException {
		return searchResult.getName().replaceFirst("uid=", "");
	}
	
	public Object getSamAccountName(SearchResult searchResult) throws NamingException {
		String sn = searchResult.getAttributes().get("sn").toString();
		return sn.replaceFirst("sn: ", "");
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
		return "";
	}
	
	// https://stackoverflow.com/questions/35065529/java-method-for-password-encrypt-in-ssha-for-ldap?rq=1 참고
	private static final int SALT_LENGTH = 4;
	private String generateSSHA(byte[] password) throws NoSuchAlgorithmException {
	    SecureRandom secureRandom = new SecureRandom();
	    byte[] salt = new byte[SALT_LENGTH];
	    secureRandom.nextBytes(salt);

	    MessageDigest crypt = MessageDigest.getInstance("SHA-1");
	    crypt.reset();
	    crypt.update(password);
	    crypt.update(salt);
	    byte[] hash = crypt.digest();

	    byte[] hashPlusSalt = new byte[hash.length + salt.length];
	    System.arraycopy(hash, 0, hashPlusSalt, 0, hash.length);
	    System.arraycopy(salt, 0, hashPlusSalt, hash.length, salt.length);

	    return new StringBuilder().append("{SSHA}")
	            .append(Base64.getEncoder().encodeToString(hashPlusSalt))
	            .toString();
	}
}