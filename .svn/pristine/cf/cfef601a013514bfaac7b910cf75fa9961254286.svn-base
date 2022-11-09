package neos.cmm.systemx.ldapLinuxAdapter.service.impl;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.naming.NamingEnumeration;
import javax.naming.NamingException;
import javax.naming.directory.DirContext;
import javax.naming.directory.SearchControls;
import javax.naming.directory.SearchResult;

import org.springframework.stereotype.Service;

import neos.cmm.systemx.ldapLinuxAdapter.service.LdapLinuxSearchService;
import neos.cmm.util.CommonUtil;

@Service("LdapLinuxSearchService")
public class LdapLinuxSearchServiceImpl implements LdapLinuxSearchService {

	@Override
	public List<Map<String, Object>> search(DirContext ctx, String searchBase, String searchFilter) {
		NamingEnumeration<SearchResult> result = innerSearch(ctx, searchBase, searchFilter);
		return getResult(result, searchBase);
	}

	private NamingEnumeration<SearchResult> innerSearch(DirContext ctx, String searchBase, String searchFilter) {
		SearchControls sc = new SearchControls();
		sc.setSearchScope(SearchControls.SUBTREE_SCOPE);
		sc.setReturningAttributes(null);
		
		try {
			return ctx.search(searchBase, searchFilter, sc);
		}
		catch (NamingException e) {
			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
		}

		return null;
	}

	@SuppressWarnings("unchecked")
	private List<Map<String, Object>> getResult(NamingEnumeration<SearchResult> searchResult, String searchBase) {
		List<Map<String, Object>> list = new ArrayList<Map<String,Object>>();
		List<Map<String, Object>> returnList = new ArrayList<>();
		Map tree = new HashMap<String, Map<String, Object>>();
		Map<String, Map<String, Object>> burffer = new HashMap<String, Map<String, Object>>();
		int index = 0;
		
		while(searchResult.hasMoreElements()) {
			try {
				SearchResult sr;
				String fullName;
				
				sr = (SearchResult)searchResult.next();
				fullName = sr.getNameInNamespace();
				
				list.add(addItem(fullName, index++));
				burffer.put(fullName, list.get(index - 1));
			}
			catch (NamingException e) {
				CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
			}
		}
		
		for (int i = 0; i < list.size(); i++) {
			Map<String, Object> item = list.get(i);
			String dn = (String)item.get("text");
			int targetIndex;
			
			targetIndex = dn.indexOf(",");
			if (targetIndex != -1) {
				String parentDN = dn.substring(targetIndex + 1, dn.length());

				Map<String, Object> bufferValue = (Map<String, Object>) burffer.get(parentDN);
				ArrayList<Map<String, Object>> children = (ArrayList<Map<String, Object>>)bufferValue.get("children");
				children.add(0, item);
			}
		}
		
		tree.put(list.get(0).get("id"), burffer.get(searchBase));
		returnList.add((Map<String, Object>) tree.get("0"));

		return returnList;
	}
	
	private Map<String, Object> addItem(String dn, int index) {
		Map<String, Object> item = new HashMap<String, Object>();
		Map<String, Object> fIcon = new HashMap<String, Object>();
		Map<String, Object> nodeState = new HashMap<String, Object>();
		String fColor = "comp_li";
		
		nodeState.put("selected", false);
		nodeState.put("opened", false);

		fColor = "comp_li";
		fIcon.put("class", fColor);
		item.put("tIcon", fColor);
		item.put("li_attr", fIcon);
		item.put("id", String.valueOf(index));
		item.put("text", dn);
		item.put("children", new ArrayList<Map<String, Object>>());
		
		return item;
	}
}
