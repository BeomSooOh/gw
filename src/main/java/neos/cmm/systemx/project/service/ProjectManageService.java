package neos.cmm.systemx.project.service;

import java.util.List;
import java.util.Map;

import egovframework.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;
import net.sf.json.JSONObject;

public interface ProjectManageService {

	public Map<String, Object> selectProjectList(Map<String, Object> params, PaginationInfo paginationInfo);

	public Object insertProjectMain(Map<String, Object> params);

	public Object insertProjectDetail(Map<String, Object> params);

	public Map<String, Object> selectProjectInfo(Map<String, Object> params);

	public void updateProjectMain(Map<String, Object> params);
	
	public void updateProjectDetailRoomId(Map<String, Object> params);

	public void updateProjectDetail(Map<String, Object> params);

	public void deleteProjectInfo(Map<String, Object> params);
	
	public List<Map<String,Object>> selectErpProject(Map<String,Object> params);
	
	public Object insertProjectMainFromErp(Map<String,Object> params);
	public Object insertProjectDetailFromErp(Map<String,Object> params);
	
	public Object updateProjectMainFromErp(Map<String,Object> params);
	public Object updateProjectDetailFromErp(Map<String,Object> params);

	public void updateProjectMainStatus(Map<String, Object> map);

	public void updateProjectRestore(Map<String, Object> params);
	
	
	public void projectRoomCreate(Map<String, Object> params);
	public JSONObject projectRoomIn(Map<String, Object> params);
	public void projectRoomOut(Map<String, Object> params);

	public List<Map<String, Object>> getRoomIdList(Map<String, Object> params);

	public void projectUserRoomOut(Map<String, Object> params,
			List<Map<String, Object>> roomIdList);
	
	public Map<String, Object> projectData(Map<String, Object> param, PaginationInfo paginationInfo);
} 
