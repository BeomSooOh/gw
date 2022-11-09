package neos.cmm.systemx.secGrade.util;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.net.HttpURLConnection;
import java.net.URL;

import neos.cmm.util.CommonUtil;
import net.sf.json.JSONObject;

public class SecGradeUtil {
	public static JSONObject getPostJSON(String url, String data) {
		StringBuilder sbBuf = new StringBuilder();
		HttpURLConnection con = null;
		BufferedReader brIn = null;
		OutputStreamWriter wr = null;
		String line = null;
		try {
			con = (HttpURLConnection) new URL(url).openConnection();
			con.setRequestMethod("POST");
			con.setConnectTimeout(5000);
			con.setRequestProperty("Content-Type", "application/json;charset=UTF-8");
			con.setDoOutput(true);
			con.setDoInput(true);

			wr = new OutputStreamWriter(con.getOutputStream());
			wr.write(data);
			wr.flush();
			brIn = new BufferedReader(new InputStreamReader(con.getInputStream(), "UTF-8"));
			while ((line = brIn.readLine()) != null) {
				sbBuf.append(line);
			}

			JSONObject rtn = JSONObject.fromObject(sbBuf.toString());

			sbBuf = null;

			return rtn;
		} catch (Exception e) {
			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
			return null;
		} finally {
			try {
				if(wr!=null) {//Null Pointer 역참조
				wr.close();
				}
			} catch (Exception e) {
				CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
			}
			try {
				if(brIn!=null) {//Null Pointer 역참조
				brIn.close();
				}
			} catch (Exception e) {
				CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
			}
			try {
				if(con!=null) {//Null Pointer 역참조
				con.disconnect();
				}
			} catch (Exception e) {
				CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
			}
		}
	}
}
