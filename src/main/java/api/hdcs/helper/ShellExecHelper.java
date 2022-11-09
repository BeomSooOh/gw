package api.hdcs.helper;

import java.io.BufferedReader;
import java.io.InputStreamReader;

import neos.cmm.util.CommonUtil;

public class ShellExecHelper {

	public static String executeCommand(String command) throws Exception {

		StringBuffer output = new StringBuffer();
		/*
		Runtime runtime = Runtime.getRuntime();
		
		Process process = runtime.exec(command);
		InputStream is = process.getInputStream();
		InputStreamReader isr = new InputStreamReader(is);
		BufferedReader br = new BufferedReader(isr);
		
		String line;
		
		while((line = br.readLine()) != null){
			output.append(line);
		}
		*/
		
		Process p;
		try {
			p = Runtime.getRuntime().exec(command);

			BufferedReader reader = new BufferedReader(new InputStreamReader(p.getInputStream()));

            String line = "";			
			while ((line = reader.readLine())!= null) {
				output.append(line);
			}
			
			reader.close();

		} catch (Exception e) {
			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
		}
		
		
		return output.toString();

	}
}
