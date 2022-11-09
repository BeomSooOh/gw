package api.hrExtInterlock.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import api.common.model.APIResponse;
import main.web.BizboxAMessage;
import neos.cmm.systemx.dept.service.DeptManageService;
import neos.cmm.systemx.emp.service.EmpManageService;
import neos.cmm.systemx.empdept.service.EmpDeptManageService;
import javax.annotation.Resource;
import org.springframework.stereotype.Service;
import neos.cmm.db.CommonSqlDAO;
import neos.cmm.systemx.orgAdapter.service.OrgAdapterService;
import org.apache.log4j.Logger;



@Service("hrExtInterlockService")
public class hrExtInterlockServiceImpl implements hrExtInterlockService{

	protected Logger logger = Logger.getLogger( super.getClass( ) );
	
	@Resource(name = "commonSql")
	private CommonSqlDAO commonSql;
	
	@Resource(name="EmpManageService")
    private EmpManageService empManageService;
	
	@Resource(name = "DeptManageService")
	private DeptManageService deptManageService;
	
	@Resource(name = "EmpDeptManageService")
    private EmpDeptManageService empDeptManageService;
	
	@Resource(name = "OrgAdapterService")
	private OrgAdapterService orgAdapterService;	

	@Override
	public APIResponse viewSelect(String serviceName, Map<String, Object> param) {
		
		param.put("reqType", "viewSelect");
		param.put("data", param.toString());
		param.put("apiTp", serviceName);		
		commonSql.insert("HrExtInterlock.setApiLog", param);

		APIResponse response = new APIResponse();
		response = selectView(param);
		
		return response;
	}
	
	@Override
	public APIResponse selectView(Map<String, Object> paramMap) {
		
		APIResponse response = new APIResponse();
		
		try {
			//라이센스 체크(t_co_group_api)
			int checkLicense = (int) commonSql.select("HrExtInterlock.getGroupLicenseCheck", paramMap);
			if(checkLicense > 0){
				
				if(paramMap.get("filter") == null){
					paramMap.put("filter", "");
				}
				
				List<Map<String, Object>> list = (List<Map<String, Object>>) commonSql.list("HrExtInterlock.getViewSelect", paramMap) ;				
				response.setResult(list);
				response.setResultCode("SUCCESS");
				response.setResultMessage(BizboxAMessage.getMessage("TX000011955","성공하였습니다"));
				
			}else{
				response.setResultCode("UC0001");
				response.setResultMessage(BizboxAMessage.getMessage("TX800000016","API라이선스 오류!"));
			}
		}catch(Exception e) {
			response.setResultCode("UC0000");
			response.setResultMessage(e.getMessage());	
		}

		return response;
	}	
	
	@Override
	public APIResponse action(String serviceName, Map<String, Object> body) {
		
		Map<String, Object> param = (Map<String, Object>)body.get("header");
		param.put("reqType", "param");
		param.put("data", body.toString());
		commonSql.insert("HrExtInterlock.setApiLog", param);
				
		APIResponse response = new APIResponse();
		
		if(serviceName.equals("empInsert")) {
			response = empInsert(body);
		}else if(serviceName.equals("empResign")){
			response = empResign(body);
		}else if(serviceName.equals("deptInsert")){
			response = deptInsert(body);
		}else if(serviceName.equals("orgAdapter")){
			response = orgAdapter(body);
		}else {
			response.setResultCode("-999");
			response.setResultMessage(BizboxAMessage.getMessage("TX800000017","잘못된 API경로입니다."));
		}
		
		param.put("reqType", "result");
		param.put("data", response.getResultCode() + "|" + response.getResultMessage());
		commonSql.insert("HrExtInterlock.setApiLog", param);
		
		return response;
	}

	@Override
	public APIResponse empInsert(Map<String, Object> paramMap) {
		
		APIResponse response = new APIResponse();
		
		try {
			Map<String, Object> header = (Map<String, Object>)paramMap.get("header");
			Map<String, Object> body = (Map<String, Object>)paramMap.get("body");
			
			//라이센스 체크(t_co_group_api)
			header.put("apiTp", "empInsert");
			int checkLicense = (int) commonSql.select("HrExtInterlock.getGroupLicenseCheck", header);
			
			if(checkLicense > 0){
				
				if(body.get("oldDeptSeq") != null && !body.get("oldDeptSeq").equals("") && body.get("deptSeq") != null && !body.get("deptSeq").equals("")){
					String deptSeqNew = body.get("deptSeq").toString();
					body.put("deptSeq", body.get("oldDeptSeq"));
					body.put("deptSeqNew", deptSeqNew);
				}
				
				if(body.get("deptType") != null && body.get("deptType").equals("D")){
					
					body.put("teamYn", "N");
					
					if(body.get("deptDetail") != null && !body.get("deptDetail").equals("")){
						
						if(body.get("deptDetail").equals("T")){
							body.put("teamYn", "T");
						}else if(body.get("deptDetail").equals("V")){
							body.put("teamYn", "E");
						}
					}
				}
				
				if(body.get("displayYn") == null || body.get("displayYn").equals("")){
					body.put("displayYn", "Y");
				}
				
				if(body.get("empSeq") == null || body.get("empSeq").equals("")){
					
					if(body.get("orgchartDisplayYn") == null || body.get("orgchartDisplayYn").equals("")){
						body.put("orgchartDisplayYn", "Y");
					}
					
					if(body.get("messengerDisplayYn") == null || body.get("messengerDisplayYn").equals("")){
						body.put("messengerDisplayYn", "Y");
					}
					
				}
				
				if(body.get("loginPasswd") != null && !body.get("loginPasswd").equals("")){
					body.put("loginPasswdNew", body.get("loginPasswd"));
				}				
				
				Map<String, Object> result = orgAdapterService.empSaveAdapter(body);
				
				if(result.get("resultCode").equals("SUCCESS")){
					response.setResultCode(result.get("resultCode").toString());
										
				}else{
					response.setResultCode("UC0002");
				}
				
				response.setResultMessage(result.get("result").toString());
			
			}else{
				response.setResultCode("UC0001");
				response.setResultMessage(BizboxAMessage.getMessage("TX800000016","API라이선스 오류!"));
			}
		}catch(Exception e) {
			response.setResultCode("UC0000");
			response.setResultMessage(e.getMessage());	
		}

		return response;
	}
	
	@Override
	public APIResponse empResign(Map<String, Object> paramMap) {
		
		APIResponse response = new APIResponse();
		
		try {
			Map<String, Object> header = (Map<String, Object>)paramMap.get("header");
			Map<String, Object> body = (Map<String, Object>)paramMap.get("body");
			
			//라이센스 체크(t_co_group_api)
			header.put("apiTp", "empResign");
			int checkLicense = (int) commonSql.select("HrExtInterlock.getGroupLicenseCheck", header);
			if(checkLicense > 0){
				
				body.put("allResignCheckYn", "Y");
				body.put("isAll", "N");
				
				Map<String, Object> result = orgAdapterService.empResignProcFinish(body);
				
				if(result.get("resultCode").equals("SUCCESS")){
					response.setResultCode(result.get("resultCode").toString());
										
				}else{
					response.setResultCode("UC0002");
				}
				
				response.setResultMessage(result.get("result").toString());
				
			}else{
				response.setResultCode("UC0001");
				response.setResultMessage(BizboxAMessage.getMessage("TX800000016","API라이선스 오류!"));
			}
		}catch(Exception e) {
			response.setResultCode("UC0000");
			response.setResultMessage(e.getMessage());	
		}

		return response;
	}
	
	@Override
	public APIResponse deptInsert(Map<String, Object> paramMap) {
		
		APIResponse response = new APIResponse();		
		
		try {
			Map<String, Object> header = (Map<String, Object>)paramMap.get("header");
			Map<String, Object> body = (Map<String, Object>)paramMap.get("body");
			
			
			//라이센스 체크(t_co_group_api)
			header.put("apiTp", "deptInsert");
			int checkLicense = (int) commonSql.select("HrExtInterlock.getGroupLicenseCheck", header);
			if(checkLicense > 0){
				
				Map<String, Object> result = body.get("useYn") != null && body.get("useYn").equals("D") ? orgAdapterService.deptRemoveAdapter(body) : orgAdapterService.deptSaveAdapter(body);

				if(result.get("resultCode").equals("SUCCESS")){
					response.setResultCode(result.get("resultCode").toString());
										
				}else{
					response.setResultCode("UC0002");
				}
				
				response.setResultMessage(result.get("result").toString());				
				
				
			}else{
				response.setResultCode("UC0001");
				response.setResultMessage(BizboxAMessage.getMessage("TX800000016","API라이선스 오류!"));
			}
		}catch(Exception e) {
			response.setResultCode("UC0000");
			response.setResultMessage(e.getMessage());		
		}

		return response;
	}	
	
	@Override
	public APIResponse orgAdapter(Map<String, Object> paramMap) {
		
		logger.debug("hrExtInterlockService.orgAdapter(0) Call : " + paramMap.toString());
			
		APIResponse response = new APIResponse();
		
		try {
			@SuppressWarnings("unchecked")
			Map<String, Object> header = (Map<String, Object>)paramMap.get("header");
			@SuppressWarnings("unchecked")
			Map<String, Object> body = (Map<String, Object>)paramMap.get("body");
			
			if((header.get("groupSeq") == null || header.get("groupSeq").equals("")) && (body.get("groupSeq") != null && !body.get("groupSeq").equals(""))) {
				header.put("groupSeq", body.get("groupSeq"));
			}else if((body.get("groupSeq") == null || body.get("groupSeq").equals("")) && (header.get("groupSeq") != null && !header.get("groupSeq").equals(""))) {
				body.put("groupSeq", header.get("groupSeq"));
			}else if((header.get("groupSeq") == null || header.get("groupSeq").equals("")) && (body.get("groupSeq") == null || body.get("groupSeq").equals(""))) {
				response.setResultCode("UC0002");
				response.setResult("groupSeq Fail");
				response.setResultMessage("groupSeq Fail");
			}
			
			if(paramMap.get("orgAdapterRequestDomain") != null) {
				body.put("orgAdapterRequestDomain", paramMap.get("orgAdapterRequestDomain"));
			}
			
			//라이센스 체크(t_co_group_api)
			int checkLicense = 0;
			
			if(header.get("licenseKey") != null && (header.get("licenseKey").equals("hyundaidept") || header.get("licenseKey").equals("openApiDouzone@1234"))) {
				checkLicense = 1;
			}else {
				checkLicense = (int) commonSql.select("HrExtInterlock.getGroupLicenseCheck", header);
			}
			
			logger.debug("hrExtInterlockService.orgAdapter(1) checkLicense : " + checkLicense);
			
			if(checkLicense > 0){
				
				Map<String, Object> result = new HashMap<String, Object>();
				
				body.put("createSeq", "orgAdapter");
				
				if(header.get("apiTp").equals("compSaveAdapter")) {
					
					logger.debug("hrExtInterlockService.orgAdapter.compSaveAdapter body : " + body);
					result = orgAdapterService.compSaveAdapter(body);
					logger.debug("hrExtInterlockService.orgAdapter.compSaveAdapter result : " + result);
					
				}else if(header.get("apiTp").equals("compRemoveAdapter")) {
					
					logger.debug("hrExtInterlockService.orgAdapter.compRemoveAdapter body : " + body);
					result = orgAdapterService.compRemoveAdapter(body);
					logger.debug("hrExtInterlockService.orgAdapter.compRemoveAdapter result : " + result);					
					
				}else if(header.get("apiTp").equals("deptSaveAdapter")) {
					
					logger.debug("hrExtInterlockService.orgAdapter.deptSaveAdapter body : " + body);
					result = orgAdapterService.deptSaveAdapter(body);
					logger.debug("hrExtInterlockService.orgAdapter.deptSaveAdapter result : " + result);						
					
				}else if(header.get("apiTp").equals("deptRemoveAdapter")) {
					
					logger.debug("hrExtInterlockService.orgAdapter.deptRemoveAdapter body : " + body);
					result = orgAdapterService.deptRemoveAdapter(body);
					logger.debug("hrExtInterlockService.orgAdapter.deptRemoveAdapter result : " + result);						
					
				}else if(header.get("apiTp").equals("empDeptRemoveAdapter")) {
					
					logger.debug("hrExtInterlockService.orgAdapter.empDeptRemoveAdapter body : " + body);
					result = orgAdapterService.empDeptRemoveAdapter(body);
					logger.debug("hrExtInterlockService.orgAdapter.empDeptRemoveAdapter result : " + result);						
					
				}else if(header.get("apiTp").equals("empLoginEmailIdModifyAdapter")) {
					
					logger.debug("hrExtInterlockService.orgAdapter.empLoginEmailIdModifyAdapter body : " + body);
					result = orgAdapterService.empLoginEmailIdModifyAdapter(body);
					logger.debug("hrExtInterlockService.orgAdapter.empLoginEmailIdModifyAdapter result : " + result);						
					
				}else if(header.get("apiTp").equals("empLoginPasswdResetProc")) {
					
					logger.debug("hrExtInterlockService.orgAdapter.empLoginPasswdResetProc body : " + body);
					result = orgAdapterService.empLoginPasswdResetProc(body);
					logger.debug("hrExtInterlockService.orgAdapter.empLoginPasswdResetProc result : " + result);						
					
				}else if(header.get("apiTp").equals("empPasswdChangeProc")) {
					
					logger.debug("hrExtInterlockService.orgAdapter.empPasswdChangeProc body : " + body);
					result = orgAdapterService.empPasswdChangeProc(body);
					logger.debug("hrExtInterlockService.orgAdapter.empPasswdChangeProc result : " + result);						
					
				}else if(header.get("apiTp").equals("empRemoveAdapter")) {
					
					logger.debug("hrExtInterlockService.orgAdapter.empRemoveAdapter body : " + body);
					result = orgAdapterService.empRemoveAdapter(body);
					logger.debug("hrExtInterlockService.orgAdapter.empRemoveAdapter result : " + result);						
					
				}else if(header.get("apiTp").equals("empResignProcFinishAdapter")) {
					
					logger.debug("hrExtInterlockService.orgAdapter.empResignProcFinish body : " + body);
					result = orgAdapterService.empResignProcFinish(body);
					logger.debug("hrExtInterlockService.orgAdapter.empResignProcFinish result : " + result);						
					
				}else if(header.get("apiTp").equals("empSaveAdapter")) {
					
					//DERP 통합코드관련 처리
					if(body.get("empSeqDef") != null && !body.get("empSeqDef").equals("") && (body.get("gerpNoGemp") == null || body.get("gerpNoGemp").equals(""))) {
						body.put("gerpNoGemp", body.get("empSeqDef"));
					}else if(body.get("empSeq") != null && !body.get("empSeq").equals("") && body.get("deptSeqNew") != null && !body.get("deptSeqNew").equals("") && (body.get("deptSeq") == null || body.get("deptSeq").equals(""))) {
						body.put("gerpNoGemp", body.get("empSeq"));
					}
					
					logger.debug("hrExtInterlockService.orgAdapter.empSaveAdapter body : " + body);
					result = orgAdapterService.empSaveAdapter(body);
					logger.debug("hrExtInterlockService.orgAdapter.empSaveAdapter result : " + result);						
					
				}else if(header.get("apiTp").equals("dutyPositionSaveAdapter")) {
					
					logger.debug("hrExtInterlockService.orgAdapter.dutyPositionSaveAdapter body : " + body);
					result = orgAdapterService.dutyPositionSaveAdapter(body);
					logger.debug("hrExtInterlockService.orgAdapter.dutyPositionSaveAdapter result : " + result);						
					
				}else if(header.get("apiTp").equals("dutyPositionRemoveAdapter")) {
					
					logger.debug("hrExtInterlockService.orgAdapter.dutyPositionRemoveAdapter body : " + body);
					result = orgAdapterService.dutyPositionRemoveAdapter(body);
					logger.debug("hrExtInterlockService.orgAdapter.dutyPositionRemoveAdapter result : " + result);						
					
				}else if(header.get("apiTp").equals("mailUserSyncAdapter")) {
					
					logger.debug("hrExtInterlockService.orgAdapter.mailUserSync body : " + body);
					orgAdapterService.mailUserSync(body);
					result.put("resultCode", "SUCCESS");
					result.put("result", BizboxAMessage.getMessage("TX800000018","메일서버 조직도 동기화 완료"));
					
				}else {
					logger.debug("hrExtInterlockService.orgAdapter apiTp : 잘못된 API경로입니다.");
					result.put("resultCode", "-999");
					result.put("result", BizboxAMessage.getMessage("TX800000019","잘못된 API경로입니다."));
				}
				
				if(result.get("resultCode").equals("SUCCESS")){
					response.setResultCode(result.get("resultCode").toString());
										
				}else{
					
					if(result.get("resultDetailCode") != null) {
						response.setResultCode(result.get("resultDetailCode").toString());
					}else {
						response.setResultCode("UC0000");	
					}
					
				}
				
				response.setResultMessage(result.get("result").toString());						
			
			}else{
				response.setResultCode("UC0001");
				response.setResult("checkLicense");
				response.setResultMessage(BizboxAMessage.getMessage("TX800000016","API라이선스 오류!"));
			}
		}catch(Exception e) {
			logger.debug("hrExtInterlockService.orgAdapter Exception : " + e.getMessage());
			response.setResultCode("UC0000");
			response.setResult("Exception");
			response.setResultMessage(e.getMessage());	
		}

		return response;
	}
	
}
