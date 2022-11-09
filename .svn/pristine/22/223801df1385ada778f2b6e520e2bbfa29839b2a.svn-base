package neos.cmm.systemx.secGrade.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import neos.cmm.systemx.secGrade.vo.SecGrade;
import neos.cmm.systemx.secGrade.vo.SecGradeRemoveResponse;
import neos.cmm.systemx.secGrade.vo.SecGradeUser;

public interface SecGradeService {
	public List<SecGrade> getSecGradeList(Map<String, Object> reqParams) throws Exception;

	public void saveSecGradeUser(Map<String, Object> reqParams) throws Exception;

	public List<SecGradeUser> getSecGradeUserList(Map<String, Object> reqParams) throws Exception;

	public void removeSecGradeUser(Map<String, Object> reqParams) throws Exception;
	
	public List<SecGrade> getSecGradeListForPop(Map<String, Object> reqParams) throws Exception;

	public SecGrade getSecGrade(Map<String, Object> reqParams) throws Exception;

	public void modifySecGrade(Map<String, Object> reqParams) throws Exception;
	
	public void regSecGrade(Map<String, Object> reqParams) throws Exception;

	public SecGradeRemoveResponse canRemoveSecGrade(Map<String, Object> reqParams) throws Exception;

	public void removeSecGrade(Map<String, Object> reqParams) throws Exception;

	public HashMap<String, Object> getMatchedInfo(Map<String, Object> reqParams) throws Exception;

	public HashMap<String, Object> getSecGradeInfo(Map<String, Object> reqParams) throws Exception;
}
