package neos.cmm.systemx.orgAdapter.service;

import java.io.IOException;
import java.util.Map;

public interface OrgAdapterService {
	public Map<String, Object> compSaveAdapter(Map<String, Object> params) throws Exception;
	
	public Map<String, Object> compRemoveAdapter(Map<String, Object> params);
	
	public Map<String, Object> deptSaveAdapter(Map<String, Object> params) throws Exception;
	
	public Map<String, Object> deptRemoveAdapter(Map<String, Object> params) throws Exception;
	
	public Map<String, Object> empSaveAdapter(Map<String, Object> params) throws Exception;
	
	public Map<String, Object> empDeptRemoveAdapter(Map<String, Object> params);
	
	public Map<String, Object> empLoginEmailIdModifyAdapter(Map<String, Object> params);
	
	public Map<String, Object> empResignProcFinish(Map<String, Object> params) throws Exception;
	
	public Map<String, Object> empRemoveAdapter(Map<String, Object> params) throws Exception;
	
	public Map<String, Object> empLoginPasswdResetProc(Map<String, Object> params) throws Exception;
	
	public Map<String, Object> empPasswdChangeProc(Map<String, Object> params) throws Exception;
	
	public void mailUserSync(Map<String, Object> params);
	
	public void mailCompDelete(Map<String, Object> params);
	
	public Map<String, Object> dutyPositionSaveAdapter(Map<String, Object> params);
	
	public Map<String, Object> dutyPositionRemoveAdapter(Map<String, Object> params);
	
	public void ftpProfileSync(Map<String, Object> paramMap) throws IOException;
	
}