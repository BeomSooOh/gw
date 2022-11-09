package api.oneffice.controller;
import java.util.Iterator;
import java.util.Map;
import java.util.Set;
import java.util.UUID;

import javax.annotation.Resource;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import java.net.URLDecoder;
import java.util.HashMap;
import java.util.List;

import neos.cmm.db.CommonSqlDAO;
import api.common.model.APIResponse;

import cloud.CloudConnetInfo;

@Controller
public class OnefficeMobileController {
	
	@Resource(name = "commonSql")
	private CommonSqlDAO commonSql;
	
	
	@RequestMapping(value="/onefficeMobileApi/{target}", method=RequestMethod.POST)
	@ResponseBody
	public APIResponse getDocumentList(@RequestBody Map<String, Object> paramMap, @PathVariable String target) throws Exception {
		
		APIResponse response = new APIResponse();
		
		Map<String, Object> result = onefficeCmmFunction(paramMap, target, "mobile");
		response.setResultCode(result.get("result") + "");
		response.setResult(result.get("data"));
		
		return response;
	}
	
	
	public String getFolderNoStr(Map<String, Object> paramMap){
		
		String folderNo = paramMap.get("folderNo").toString();
		
		folderNo = "|" + folderNo + "|";
		String result = folderNo;
		Boolean state = true;
		
		while(state){
			paramMap.put("folderNoStr", folderNo);
			folderNo = (String) commonSql.select("OnefficeDao.getFolderNoStr", paramMap);
			
			if(!folderNo.equals("")){
				result += folderNo;
			}else{
				state = false;
			}
		}
		
		return result;
	}
	
	
	
	
	
	public Map<String, Object> onefficeCmmFunction(Map<String, Object> param, String target, String platformType) throws Exception{
		
		Map<String, Object> resultMap = new HashMap<String, Object>();
		
		if(platformType.equals("mobile")){
			Map<String, Object> header = (Map<String, Object>)param.get("header");
			Map<String, Object> body = (Map<String, Object>)param.get("body");

			Set headerKey = header.keySet();
			
			for (Iterator iterator = headerKey.iterator(); iterator.hasNext();) {
                String keyName = (String) iterator.next();
                param.put(keyName, header.get(keyName));
			}
			
			Set bodyKey = header.keySet();
			
			for (Iterator iterator = bodyKey.iterator(); iterator.hasNext();) {
                String keyName = (String) iterator.next();
                param.put(keyName, body.get(keyName));
			}
			
			param.remove("header");
			param.remove("body");
		}
		
		try{
			
			if(target.equals("getDocumentList")){
				List<Map<String, Object>> result = (List<Map<String, Object>>) commonSql.list("OnefficeDao.getDocumentList", param);
				resultMap.put("result", "success");
				resultMap.put("data", result);			
			}
			else if(target.equals("getSearchDocumentList")){
				if(param.get("keyword") != null && !param.get("keyword").equals("")){
					param.put("keyword", URLDecoder.decode(param.get("keyword").toString()));
				}
				List<Map<String, Object>> result = (List<Map<String, Object>>) commonSql.list("OnefficeDao.getDocumentList", param);
				resultMap.put("result", "success");
				resultMap.put("data", result);
			}
			else if(target.equals("getImportantDocumentList")){
				List<Map<String, Object>> result = (List<Map<String, Object>>) commonSql.list("OnefficeDao.getImportantDocumentList", param);
				resultMap.put("result", "success");
				resultMap.put("data", result);
			}
			else if(target.equals("createFolder")){
				String docNo = UUID.randomUUID().toString().replace("-", "");
				param.put("doc_no", docNo);
				commonSql.insert("OnefficeDao.createFolder", param);
				
				List<Map<String, Object>> result = (List<Map<String, Object>>) commonSql.list("OnefficeDao.getImportantDocumentList", param);
				resultMap.put("result", "success");
				resultMap.put("data", result);
			}
			else if(target.equals("updateFolder")){
				commonSql.update("OnefficeDao.updateFolder", param);
				Map<String, Object> result = new HashMap<String, Object>();
				result.put("doc_no", param.get("doc_no"));
				resultMap.put("result", "success");
				resultMap.put("data", result);
			}
			else if(target.equals("deleteFolder")){
				commonSql.update("OnefficeDao.deleteFolder", param);
				Map<String, Object> result = new HashMap<String, Object>();
				result.put("doc_no", param.get("doc_no"));
				resultMap.put("result", "success");
				resultMap.put("data", result);
			}
			else if(target.equals("createDocument")){
				String docNo = UUID.randomUUID().toString().replace("-", "");
				param.put("doc_no", docNo);
				
				if(param.get("content") != null && !param.get("content").equals("")){
					param.put("contentSize", String.valueOf(param.get("content").toString().getBytes().length));	
				}else{
					param.put("contentSize", "0");	
				}
				
				commonSql.insert("OnefficeDao.createDocument", param);
				
				Map<String, Object> result = new HashMap<String, Object>();
				result.put("doc_no", docNo);
				
				resultMap.put("result", "success");
				resultMap.put("data", result);
			}
			else if(target.equals("updateDocument")){
				@SuppressWarnings("unchecked")
				Map<String, Object> docInfo = (Map<String, Object>) commonSql.select("OnefficeDao.getDocument", param);
				
				if(docInfo != null){
					if((param.get("content") != null && !param.get("content").equals("")) && (docInfo.get("readonly").equals("1") || (!docInfo.get("owner_id").equals(param.get("empSeq")) && docInfo.get("share_perm").equals("R")))){
						resultMap.put("result","fail");
						resultMap.put("data","");
						resultMap.put("msg","ReadOnly Document");
					}else{
						if(param.get("content") != null && !param.get("content").equals("")){
							param.put("contentSize", String.valueOf(param.get("content").toString().getBytes().length));
						}
	
						commonSql.update("OnefficeDao.updateDocument", param);
						Map<String, Object> result = new HashMap<String, Object>();
						result.put("doc_no", param.get("doc_no"));
						resultMap.put("result","success");
						resultMap.put("data",result);
					}
				}
			}
			else if(target.equals("deleteDocument")){
				commonSql.update("OnefficeDao.deleteDocument", param);
				
				Map<String, Object> result = new HashMap<String, Object>();
				result.put("doc_no", param.get("doc_no"));
				resultMap.put("result","success");
				resultMap.put("data",result);
			}
			else if(target.equals("getTrashList")){
				@SuppressWarnings("unchecked")
				List<Map<String, Object>> result = (List<Map<String, Object>>) commonSql.list("OnefficeDao.getTrashList", param);
				resultMap.put("result","success");
				resultMap.put("data",result);
			}
			else if(target.equals("recoverTrashDocument")){
				commonSql.update("OnefficeDao.recoverTrashDocument", param);
				
				Map<String, Object> result = new HashMap<String, Object>();
				result.put("doc_no", param.get("doc_no"));
				resultMap.put("result","success");
				resultMap.put("data",result);
			}
			else if(target.equals("deleteTrashDocument")){
				commonSql.delete("OnefficeDao.deleteTrashDocument", param);
				
				//하위폴더 및 문서 삭제
				param.put("folderNo",param.get("doc_no"));
				param.put("folderNoStr", getFolderNoStr(param));
				commonSql.delete("OnefficeDao.deleteTrashDocumentChild", param);
				
				Map<String, Object> result = new HashMap<String, Object>();
				result.put("doc_no", param.get("doc_no"));
				resultMap.put("result","success");
				resultMap.put("data",result);
			}
			else if(target.equals("emptyTrash")){
				//삭제폴더 하위 폴더 및 문서 삭제
				String folderNoStr = (String) commonSql.select("OnefficeDao.getTrashAllFolderNoStr", param);
				param.put("folderNo",folderNoStr);
				param.put("folderNoStr", getFolderNoStr(param));
				commonSql.delete("OnefficeDao.deleteTrashDocumentChild", param);
				
				//삭제된 문서 전체삭제
				commonSql.delete("OnefficeDao.emptyTrash", param);
				
				resultMap.put("result","success");
			}
			else if(target.equals("shareDocument")){
				commonSql.delete("OnefficeDao.shareDocumentReset", param);
				commonSql.insert("OnefficeDao.shareDocument", param);
				
				Map<String, Object> result = new HashMap<String, Object>();
				result.put("doc_no", param.get("doc_no"));
				resultMap.put("result","success");
				resultMap.put("data",result);
			}
			else if(target.equals("unshareDocument")){
				commonSql.delete("OnefficeDao.unshareDocument", param);
				
				Map<String, Object> result = new HashMap<String, Object>();
				result.put("doc_no", param.get("doc_no"));
				resultMap.put("result","success");
				resultMap.put("data",result);
			}
			else if(target.equals("getShareInfo")){
				@SuppressWarnings("unchecked")
				List<Map<String, Object>> result = (List<Map<String, Object>>) commonSql.list("OnefficeDao.getShareInfo", param);
				resultMap.put("result","success");
				resultMap.put("data",result);
			}
			else if(target.equals("getShareDocumentList")){
				@SuppressWarnings("unchecked")
				List<Map<String, Object>> result = (List<Map<String, Object>>) commonSql.list("OnefficeDao.getShareDocumentList", param);
				resultMap.put("result","success");
				resultMap.put("data",result);
			}
			else if(target.equals("getMyInfo")){
				if(CloudConnetInfo.getBuildType().equals("cloud")){
					param.put("profilePath", "/upload/" + param.get("groupSeq") + "/img/profile/" + param.get("groupSeq") + "/");	
				}else{
					param.put("profilePath", "/upload/img/profile/" + param.get("groupSeq") + "/");
				}
	
				@SuppressWarnings("unchecked")
				Map<String, Object> result = (Map<String, Object>) commonSql.select("OnefficeDao.getMyInfo", param);
				resultMap.put("result","success");
				resultMap.put("data",result);
			}
			else if(target.equals("accessDocument")){
				//유효시간(초)이 지나도 상태값이 사용중인 데이터들 모두 close시킴
				commonSql.update("OnefficeDao.accessDocument_0", param);
	
				//[2] 사용 요청 처리
				//[2-1] 사용 해제 요청 처리
				if(param.get("access_status").equals("0")) 
				{
					commonSql.update("OnefficeDao.accessDocument_1", param);
				}
				//[2-1] 사용 등록 요청 처리
				else 
				{
				    //[2-1-1] 읽기 사용 요청
				    if(param.get("access_perm").equals("R")) 
				    {
				    	commonSql.update("OnefficeDao.accessDocument_1", param);
				    	commonSql.insert("OnefficeDao.accessDocument_2", param);
				    }
				    //[2-1-2] 쓰기 사용 요청
				    else if(param.get("access_perm").equals("W")) 
				    {
						String accessId = (String) commonSql.select("OnefficeDao.accessDocument_3", param);
						 
						//[2-1-2-1] 결과가 있으면
						if(accessId != null) 
						{
							//위 결과 필드값을 {access_id} 로 세팅
							if(accessId.equals(param.get("empSeq"))){
								//[2-1-2-1-1] 내 아이디이면 날짜필드만 업데이트							
								commonSql.update("OnefficeDao.accessDocument_4", param);         
							} 
	
							else{
								//[2-1-2-1-2] 내 아이디가 아니면 R 모드로 변경 등록							
								param.put("access_perm", "R");
								commonSql.insert("OnefficeDao.accessDocument_2", param);
							}
						}
	
						else {
							//[2-1-2-2] 결과가 없으면 새로 등록						
							commonSql.insert("OnefficeDao.accessDocument_2", param);
						}
				    }
				}
				
				Map<String, Object> result = new HashMap<String, Object>();
				result.put("doc_no", param.get("doc_no"));
				result.put("access_perm", param.get("access_perm"));
				resultMap.put("result","success");
				resultMap.put("data",result);
			}
			else if(target.equals("getDocumentAccessInfo")){
				@SuppressWarnings("unchecked")
				List<Map<String, Object>> result = (List<Map<String, Object>>) commonSql.list("OnefficeDao.getDocumentAccessInfo", param);
				resultMap.put("result","success");
				resultMap.put("data",result);
			}
			else if(target.equals("getRecentDocumentList")){
				@SuppressWarnings("unchecked")
				List<Map<String, Object>> result = (List<Map<String, Object>>) commonSql.list("OnefficeDao.getRecentDocumentList", param);
				resultMap.put("result","success");
				resultMap.put("data",result);
			}
			else if(target.equals("getSecurityDocumentList")){
				@SuppressWarnings("unchecked")
				List<Map<String, Object>> result = (List<Map<String, Object>>) commonSql.list("OnefficeDao.getSecurityDocumentList", param);
				resultMap.put("result","success");
				resultMap.put("data",result);
			}
			else if(target.equals("getSecurityInfo")){
				@SuppressWarnings("unchecked")
				Map<String, Object> result = (Map<String, Object>) commonSql.select("OnefficeDao.getSecurityInfo", param);
				if(result == null){
					resultMap.put("result","fail");
				}else{
					resultMap.put("result","success");
					resultMap.put("status",result.get("status"));
				}
			}		
		}catch(Exception e){
			resultMap.put("result","fail");
		}
		
		return resultMap;
	}
}
