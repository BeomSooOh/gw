package neos.cmm.systemx.ldapAdapter.context;

import java.util.Map;

import javax.naming.NamingException;

public class LdapContextManagerFactory {
	public static LdapContextManager createLdapContext(LdapContextType type, Map<String, Object> paramMap) throws NamingException {
		switch(type) {
			case ACTIVEDIRECTORY:
				return new LdapContextActiveDirectory(paramMap);
			case OPENLDAP:
				return new LdapContextOpenLDAP(paramMap);
		}
		return null;
	}
}
