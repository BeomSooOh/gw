package restful.mullen.util;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import neos.cmm.util.CommonUtil;
import net.sf.json.JSONObject;

public class MullenUtil {
	//이메일 유효성 검사
	public static boolean validateEmailAddr(String emailAddr) {
		String regex = "^[_a-zA-Z0-9-\\.]+@[\\.a-zA-Z0-9-]+\\.[a-zA-Z]+$";
		Pattern p = Pattern.compile(regex);
	    Matcher m = p.matcher(emailAddr);

	    if(m.matches()){
	        return true;
	    }
	    return false;
		
	}
	//패스워드 정규식
	public static boolean validationPasswd(String pw){
		//최소8 자리 이상 16 자리 이하로 입력해 주세요.\n영문(소문자),숫자,특수문자를 포함해 주세요.
		//String regex = "^(?=.*\\d)(?=.*[!@#$%^~*+=-])(?=.*[a-z]).{8,16}$";
		String regex = "^(?=.*\\d)(?=.*[a-z]).{6,12}$";
	    Pattern p = Pattern.compile(regex);
	    Matcher m = p.matcher(pw);

	    if(m.matches()){
	        return true;
	    }
	    return false;
	}
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
			// System.out.println(sbBuf);

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
