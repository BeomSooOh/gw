package neos.cmm.systemx.ldapLinuxAdapter.service.impl;

import java.util.Hashtable;

import javax.naming.Context;
import javax.naming.NamingException;
import javax.naming.directory.DirContext;
import javax.naming.directory.InitialDirContext;

import org.springframework.stereotype.Service;

import neos.cmm.systemx.ldapLinuxAdapter.service.LdapLinuxContextManagerService;

@Service("LdapLinuxContextManagerService")
public class LdapLinuxContextManagerServiceImpl implements LdapLinuxContextManagerService {
	
	private DirContext ctx = null;

	@Override
	public DirContext getContext(String userID, String passwd, String url) throws NamingException {
		if (ctx == null) {
			Hashtable<String, String> env = new Hashtable<String, String>();
			env.put(Context.INITIAL_CONTEXT_FACTORY, "com.sun.jndi.ldap.LdapCtxFactory");
			env.put(Context.PROVIDER_URL, url);
			env.put(Context.SECURITY_AUTHENTICATION, "simple");
			env.put(Context.SECURITY_PRINCIPAL, userID);
			env.put(Context.SECURITY_CREDENTIALS, passwd);
			env.put(Context.URL_PKG_PREFIXES, "com.sun.jndi.url");
			env.put(Context.REFERRAL, "ignore");

			ctx = new InitialDirContext(env);
		}
		
		return ctx;
	}

	@Override
	public void closeCtx() throws NamingException {
		if (ctx != null) {
			ctx.close();
		}
	}
}
