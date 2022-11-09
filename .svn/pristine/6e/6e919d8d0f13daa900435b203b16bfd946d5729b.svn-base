package neos.cmm.util;

import egovframework.com.cmm.util.EgovDoubleSubmitHelper;
import egovframework.com.utl.fcc.service.EgovStringUtil;
import net.sf.json.JSONObject;

public class MobileHttpJsonUtil {
	
	public static JSONObject send(String groupSeq, String empSeq, String method, final String url, final JSONObject body) {
		
		String uuid = EgovDoubleSubmitHelper.getNewUUID();
		
		JSONObject params = new JSONObject();
		JSONObject head = new JSONObject();
		head.put("groupSeq", groupSeq);
		head.put("empSeq", empSeq);
		head.put("tId", "GW_"+uuid);
		head.put("pId", "PROJECT_ROOM_"+uuid);
		params.put("header", head);
		params.put("body", body);
		
		String result = HttpJsonUtil.execute(method, url, params) ;
		
		if (!EgovStringUtil.isEmpty(result)) {
			JSONObject json = JSONObject.fromObject(result);
			if (json != null) {
				String resultCode = json.getString("resultCode");
				if(resultCode != null && resultCode.equals("0")) {		//success
					return JSONObject.fromObject(json.getJSONObject("result"));
				}
			}
		}
		return null;
		
	}
	
}
