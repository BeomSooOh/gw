package api.emp.service;

import java.util.HashMap;
import java.util.Map;

import api.common.model.APIResponse;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import neos.cmm.db.CommonSqlDAO;


@Service("EmpService")
public class EmpServiceImpl implements EmpService{
	
	@Resource(name = "commonSql")
	private CommonSqlDAO commonSql;

	
	////////////////////////////////
	@Override
	public APIResponse createUser(Map<String, Object> paramMap) {
		Map<String, Object> params = new HashMap<String, Object>();
		Map<String, Object> param = new HashMap<String, Object>();
		APIResponse response = new APIResponse();
		
	
		
		try {
			Map<String, Object> body = (Map<String, Object>)paramMap.get("body");
			
			param.put("id", body.get("id"));
			param.put("domain", body.get("domain"));
			param.put("empSeq", body.get("empSeq"));
			param.put("empName", body.get("empName"));
			param.put("pw", body.get("pw"));			
			
			//사용자 추가(메일) (t_co_emp)
			commonSql.insert("EmpManageService.createUser", param);
			//사용자 추가(메일) (t_co_emp_multi)
			commonSql.insert("EmpManageService.createUserMulti", param);

			response.setResultCode("0");
			response.setResultMessage("SUCCESS");
		}catch(Exception e) {
			response.setResultCode("-1");
			response.setResultMessage(e.getMessage());	
		}
			
		return response;
	}

	
	
	
	
	////////////////////////////////
	@Override
	public APIResponse resignUser(Map<String, Object> paramMap) {
		Map<String, Object> params = new HashMap<String, Object>();
		Map<String, Object> param = new HashMap<String, Object>();
		APIResponse response = new APIResponse();
		
	
		
		try {
			Map<String, Object> body = (Map<String, Object>)paramMap.get("body");
			
			param.put("domain", body.get("domain"));
			param.put("empSeq", body.get("empSeq"));
			
			String resignFlag = body.get("flag") + "";	// 1:퇴직, 0:퇴직->재직
			
			if(resignFlag.equals("1")) {
				param.put("flag", "001");
			}
			else { 
				param.put("flag", "999");
			}
			//퇴직처리 하기(메일)
			commonSql.update("EmpManageService.resignUser", param);

			response.setResultCode("0");
			response.setResultMessage("SUCCESS");
		}catch(Exception e) {
			response.setResultCode("-1");
			response.setResultMessage(e.getMessage());	
		}
			
		return response;
	}

	
	
	
	
	
	////////////////////////////////
	@Override
	public APIResponse deleteUser(Map<String, Object> paramMap) {
		Map<String, Object> params = new HashMap<String, Object>();
		Map<String, Object> param = new HashMap<String, Object>();
		APIResponse response = new APIResponse();
		
	
		
		try {
			Map<String, Object> body = (Map<String, Object>)paramMap.get("body");
			
			param.put("domain", body.get("domain"));
			param.put("empSeq", body.get("empSeq"));
			
			String deleteFlag = body.get("flag") + "";	//1:삭제, 0:삭제->복원
			
			if(deleteFlag.equals("1")) {
				param.put("useYn", "N");
			}
			if(deleteFlag.equals("0")) {
				param.put("useYn", "Y");
			}
			
			//사용자 삭제(메일)
			commonSql.update("EmpManageService.deleteUser", param);

			response.setResultCode("0");
			response.setResultMessage("SUCCESS");
		}catch(Exception e) {
			response.setResultCode("-1");
			response.setResultMessage(e.getMessage());	
		}
			
		return response;
	}

	
	
	
	
	
	
	
	
	////////////////////////////////
	@Override
	public APIResponse changeUserId(Map<String, Object> paramMap) {
		Map<String, Object> params = new HashMap<String, Object>();
		Map<String, Object> param = new HashMap<String, Object>();
		APIResponse response = new APIResponse();
		
	
		
		try {
			Map<String, Object> body = (Map<String, Object>)paramMap.get("body");
			
			param.put("id", body.get("id"));
			param.put("domain", body.get("domain"));
			param.put("empSeq", body.get("empSeq"));
			param.put("changeId", body.get("changeId"));			

			//사용자 아이디 변경(메일)
			commonSql.update("EmpManageService.changeUserId", param);

			response.setResultCode("0");
			response.setResultMessage("SUCCESS");
		}catch(Exception e) {
			response.setResultCode("-1");
			response.setResultMessage(e.getMessage());	
		}
			
		return response;
	}
	

	

}
