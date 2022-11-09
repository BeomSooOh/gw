package api.test;

import java.io.File;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import neos.cmm.db.CommonSqlDAO;
import neos.cmm.util.HttpJsonUtil;
import net.sf.json.JSONObject;

@Controller
public class TestController {
	
	private static final Logger logger = LoggerFactory.getLogger(TestController.class);
	
	@Resource(name = "commonSql")
	private CommonSqlDAO commonSql;
	
	@RequestMapping("/gwApiTest.do")
	public void gwApiTest(@RequestParam Map<String, Object> params, HttpServletResponse response) throws Exception {
		
		response.setCharacterEncoding("UTF-8");
		
		
		
//		Map<String, Object> header = (Map<String, Object>) params.get("header");
//		Map<String, Object> body = (Map<String, Object>) params.get("body");
//		 
//		JSONObject.fromObject(params);
		String uri = params.get("uri")+"";
		
		params.remove("uri");
		
		
		JSONObject json = new JSONObject();
		json.put("header", JSONObject.fromObject(params.get("head")));
		json.put("body", JSONObject.fromObject(params.get("body")));
		
		String result = HttpJsonUtil.execute("POST", uri, json) ;
		
		result = getTreeStr(result);
		
//		System.out.println("result : " + getTreeStr(result));
		logger.debug("result : " + getTreeStr(result));
		
//		JSONObject bodyJson = JSONObject.fromObject(body);
		
		//JSONObject result = MobileHttpJsonUtil.send(header.get("groupSeq")+"", header.get("empSeq")+"", "POST", params.get("uri")+"", bodyJson);
		//크로스사이트 스크립트 (XSS)
		if (result != null) {
			  // 외부 입력 내 위험한 문자를 이스케이핑
			result = result.replaceAll("<", "&lt;");
			result = result.replaceAll(">", "&gt;");
		}
		
		response.getWriter().write(result);
		response.getWriter().flush();
		response.getWriter().close();  
		
	}
	
	
	@RequestMapping("/gwExecQueryByApi.do")
	public void gwExecQueryByApi(@RequestParam Map<String, Object> params, HttpServletResponse response){
		String queryId = params.get("queryId") + "";
		String queryType = params.get("queryType") + "";
		
		if(queryType.equals("select")) {
			commonSql.select(queryId, params);
		}
		else if(queryType.equals("list")) {
			commonSql.list(queryId, params);
		}
		else if(queryType.equals("update")) {
			commonSql.update(queryId, params);
		}
		else if(queryType.equals("delete")) {
			commonSql.delete(queryId, params);
		}
		else if(queryType.equals("insert")) {
			commonSql.insert(queryId, params);
		}
	}
	
	
	public String getTreeStr(String s) {
		StringBuffer sb = new StringBuffer();
		int space = 0;
		int dd = 0;
		for (int i = 0; i < s.length(); i++) {
			char c = s.charAt(i);
			String str = String.valueOf(c);
			if(str.equals("\"")){
				dd++;
			}
			if(str.equals("{")) {
				sb.append("\n");
				sb.append(getSpace(space));
				dd = 0;
				space++;
			}
			
			if(str.equals("}")) {
				sb.append("\n");
				dd = 0;
				space--;
				sb.append(getSpace(space));
			}
			
			sb.append(c);
			
			if (dd == 4) {
				sb.append("\n");
				dd = 0;
				sb.append(getSpace(space));
			}
		}
		
		return sb.toString();
	}
	
	private String getSpace(int v) {
		String s = "";
		for (int i = 0; i < v; i++) {
			s += "    ";
		}
		return s;
	}
	
	
	@RequestMapping("/boardFileRange.do")
	public void boardFileRange(@RequestParam Map<String, Object> params, HttpServletResponse response){
		String targetFolder = params.get("targetFolder") + "";
		
		if(targetFolder != null && !"".equals(targetFolder)) {//경로 조작 및 자원 삽입
			targetFolder = targetFolder.replaceAll("", "");
		}
		
		File dir = new File(targetFolder);
		if(!dir.exists()) {
//     		System.out.println("경로가 존재 하지 않습니다.");
			logger.debug("경로가 존재 하지 않습니다.");	
            return ;
        }

        File[] files = dir.listFiles();


		
		List<Map<String, Object>> boardFileList = (List<Map<String, Object>>) commonSql.list("MainManageDAO.getBoardFileList");
		
		if(boardFileList.size() > 0){
			for(Map<String, Object> mp : boardFileList){
				String folderNm = mp.get("filePath2").toString();
				String fileNm = mp.get("tmpFileName") + "";
				
				
				String targetFileNm = mp.get("tmpFileName").toString();
				targetFileNm = targetFileNm.substring(0, targetFileNm.lastIndexOf("."));
				
				File file = new File(targetFolder + "/" + targetFileNm);
				
	
					File dir2 = new File(targetFolder + "/" + folderNm + "/");
					if(!dir2.exists()){
						dir2.mkdirs();
					}
					
					
					File reName = new File(targetFolder + "/" + folderNm + "/" + fileNm);
					if(file.exists()){
						file.renameTo(reName);
					}
		
			}
		}
	}
}
