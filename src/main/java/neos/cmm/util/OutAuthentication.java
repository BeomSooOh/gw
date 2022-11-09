package neos.cmm.util;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.PrintWriter;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.HashMap;
import java.util.Map;
import org.apache.commons.codec.binary.Base64;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;

import net.sf.json.JSONObject;
import net.sf.json.JSONSerializer;


public class OutAuthentication {

	public static Boolean checkUserAuthSW(String nID, String nPW) throws IOException {
		
		String params = "";
		
		if(BizboxAProperties.getCustomProperty("BizboxA.Cust.EnpassLoginEnc").equals("Y")){
			String outSsoToken = nID + "▦" + nPW;
			
			try {
				outSsoToken = AESCipher.AES128EX_Encode(outSsoToken, "1023497555960596");
			} catch (Exception e) {
				return false;
			}
			
			outSsoToken = java.net.URLEncoder.encode(outSsoToken, "UTF-8");
			params = "outSsoToken="+outSsoToken;
		}else {
			nID = java.net.URLEncoder.encode(nID, "UTF-8");
			nPW = java.net.URLEncoder.encode(nPW, "UTF-8");
			params = "mesgerLoginId="+nID+"&mesgerPassword="+nPW;			
		}
		 
		String str = BizboxAProperties.getCustomProperty("BizboxA.Cust.EnpassLoginUrl");
		URL url = new URL(str);
		 
		HttpURLConnection http = (HttpURLConnection)url.openConnection();
		http.setRequestMethod("POST");
		http.setDoOutput(true);
		
		PrintWriter pout = new PrintWriter(http.getOutputStream());
		pout.print(params);
		pout.close();
		
		BufferedReader respRd = new BufferedReader(new InputStreamReader(http.getInputStream()));
		String returnStr = "";
		String tempStr = null;
		
		while (true) {
			tempStr = respRd.readLine();
			if (tempStr == null) {
				break;
			}
			returnStr += tempStr;
		}
		respRd.close();
		
		String result = returnStr.trim();
			 
		ObjectMapper mapper = new ObjectMapper();
		Map<String, Object> uMap = new HashMap<String, Object>();
		uMap = mapper.readValue(result, new TypeReference<Map<String, Object>>(){});
		String chk = (String) uMap.get("status");
		if (chk.equals("fail")) {
			return false;
		}
		else {
			return true;
		}		 
	}

	public static Boolean outApiAuthentication(String nID, String nPW) throws IOException {
		
		String outApiAuthentication = BizboxAProperties.getCustomProperty("BizboxA.Cust.outApiAuthentication");
		
        //API 호출 
        Map<String, Object> headers = new HashMap<String, Object>( );
        Map<String, Object> params = new HashMap<String, Object>( );
        
		/**헬프데스크 인증파라미터**/
		nID = new String(Base64.encodeBase64(nID.getBytes()), "UTF-8");
		nPW = new String(Base64.encodeBase64(nPW.getBytes()), "UTF-8");
        
        params.put("id", nID);
        params.put("pwd", nPW);
        
		String responseStr = HttpJsonUtil.executeCustom("POST", outApiAuthentication, params, headers);
		
		if(responseStr != null) {
			Map<String, Object> resultMap = JSONObject.fromObject(JSONSerializer.toJSON(responseStr));
			
			if(resultMap != null && resultMap.get("resultCode") != null && resultMap.get("resultCode").equals("success")) {
				return true;
			}
		}
		
		return false;
	}
	
}










