package derp.interlock.service;

import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import neos.cmm.db.CommonSqlDAO;

@Service("DerpInterlockService")
public class DerpInterlockServiceImpl implements DerpInterlockService {
	
	@Resource(name = "commonSql")
	private CommonSqlDAO commonSql;

	@Override
	public Map<String, Object> searchUserInfo(Map<String, Object> params) {
		return (Map<String, Object>) commonSql.select("EmpManage.searchUserInfo", params);
	}

	@Override
	public void setUserLangCode(Map<String, Object> params) {
		String langCode = (String) params.get("lang");
		
		if(langCode != null) {
			if(langCode.equals("ko")) {
				langCode = "kr";
			}
			else if(langCode.equals("en"))	{
				langCode = "en";
			}
			else if(langCode.equals("ja")) {
				langCode = "jp";
			}
			else if(langCode.equals("zh")) {
				langCode = "cn";
			}
		}else {
			langCode = "kr";
		}
		
		params.put("langCode", langCode);
		
		commonSql.update("EmpManage.setUserLangCode", params);
	}

}
