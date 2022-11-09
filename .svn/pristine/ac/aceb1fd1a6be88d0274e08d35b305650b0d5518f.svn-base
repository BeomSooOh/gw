package neos.cmm.systemx.ldapLinuxAdapter.service;

import javax.naming.NamingException;
import javax.naming.directory.DirContext;

public interface LdapLinuxContextManagerService {
	public DirContext getContext(String userID, String passwd, String url) throws NamingException;
	public void closeCtx() throws NamingException;
}