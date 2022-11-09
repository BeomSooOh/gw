package neos.cmm.systemx.cmmCode.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import neos.cmm.db.CommonSqlDAO;
import neos.cmm.systemx.cmmCode.service.CmmCodeManageService;
import neos.cmm.util.CommonUtil;

@Service("CmmCodeManageService")
public class CmmCodeManageServiceImpl implements CmmCodeManageService {
	
	@Resource(name = "commonSql")
	private CommonSqlDAO commonSql;

	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> cmmCodeList(Map<String, Object> paramMap) throws Exception {
		
		return commonSql.list("CodeManage.selectCmmCodeList", paramMap);
	}

	public Map<String,Object> cmmCodeSaveProc(Map<String, Object> paramMap) throws Exception {
		
		Map<String,Object> result = new HashMap<>();
		try{
			commonSql.insert("CodeManage.insertCodeProc", paramMap);
			paramMap.put("langCode", "kr");
			commonSql.insert("CodeManage.insertCodeMultiProc", paramMap);
			
			if(paramMap.get("codeNmEn") != null && !paramMap.get("codeNmEn").equals("")){
				paramMap.put("langCode", "en");
				paramMap.put("codeNm", paramMap.get("codeNmEn"));
				commonSql.insert("CodeManage.insertCodeMultiProc", paramMap);
			}
			if(paramMap.get("codeNmJp") != null && !paramMap.get("codeNmJp").equals("")){
				paramMap.put("langCode", "jp");
				paramMap.put("codeNm", paramMap.get("codeNmJp"));
				commonSql.insert("CodeManage.insertCodeMultiProc", paramMap);
			}
			if(paramMap.get("codeNmCn") != null && !paramMap.get("codeNmCn").equals("")){
				paramMap.put("langCode", "cn");
				paramMap.put("codeNm", paramMap.get("codeNmCn"));
				commonSql.insert("CodeManage.insertCodeMultiProc", paramMap);
			}
				
			result.put("cnt", 0);
		}catch(Exception e){
			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
			result.put("cnt", -1);
		}
		
		return result;
	}

	public Map<String,Object> cmmCodeUpdateProc(Map<String, Object> paramMap) throws Exception {
		

		Map<String,Object> result = new HashMap<>();
		
		try{
			commonSql.update("CodeManage.updateCmmCode", paramMap);
			
			paramMap.put("langCode", "kr");
			commonSql.update("CodeManage.updateCmmCodeMulti", paramMap);
			
			
			if(paramMap.get("codeNmEn") != null && !paramMap.get("codeNmEn").equals("")){
				paramMap.put("langCode", "en");
				paramMap.put("codeNm", paramMap.get("codeNmEn"));
				commonSql.update("CodeManage.updateCmmCodeMulti", paramMap);
			}else{
				paramMap.put("langCode", "en");
				commonSql.delete("CodeManage.deleteCmmCodeMultiLang", paramMap);
			}
			
			if(paramMap.get("codeNmJp") != null && !paramMap.get("codeNmJp").equals("")){
				paramMap.put("langCode", "jp");
				paramMap.put("codeNm", paramMap.get("codeNmJp"));
				commonSql.update("CodeManage.updateCmmCodeMulti", paramMap);
			}else{
				paramMap.put("langCode", "jp");
				commonSql.delete("CodeManage.deleteCmmCodeMultiLang", paramMap);
			}
			
			if(paramMap.get("codeNmCn") != null && !paramMap.get("codeNmCn").equals("")){
				paramMap.put("langCode", "cn");
				paramMap.put("codeNm", paramMap.get("codeNmCn"));
				commonSql.update("CodeManage.updateCmmCodeMulti", paramMap);
			}else{
				paramMap.put("langCode", "Cn");
				commonSql.delete("CodeManage.deleteCmmCodeMultiLang", paramMap);
			}
			result.put("cnt", 0);
		}catch(Exception e){
			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
			result.put("cnt", -1);
		}
		

		return result;
	}

	public void cmmCodeDelete(Map<String, Object> paramMap) throws Exception {
		
		try{
			commonSql.delete("CodeManage.deleteCmmCode", paramMap);
			commonSql.delete("CodeManage.deleteCmmCodeMulti", paramMap);
		}catch(Exception e){
			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
		}
		
	}

	@Override
	public List<Map<String, Object>> cmmCodeDetailList(Map<String, Object> paramMap) {
		
		return commonSql.list("CodeManage.selectCmmCodeDetailList", paramMap);
	}
	
	@Override
	public List<Map<String, Object>> cmmGetCodeList(Map<String, Object> paramMap) {
		
		return commonSql.list("CodeManage.selectCmmGetCodeList", paramMap);
	}	
	
}
