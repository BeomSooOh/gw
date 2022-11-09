package neos.cmm.systemx.project.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import neos.cmm.db.CommonSqlDAO;
import neos.cmm.systemx.project.service.ProjectManageService;
import neos.cmm.util.MobileHttpJsonUtil;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import org.springframework.stereotype.Service;

import bizbox.orgchart.service.vo.LoginVO;
import egovframework.com.cmm.util.EgovUserDetailsHelper;
import egovframework.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;

@Service("ProjectManageService")
public class ProjectManageServiceImpl implements ProjectManageService {

	@Resource(name = "commonSql")
	private CommonSqlDAO commonSql;
	
	@Override
	public Map<String, Object> selectProjectList(Map<String, Object> params, PaginationInfo paginationInfo) {
		return commonSql.listOfPaging2(params, paginationInfo, "ProjectManageDAO.selectProjectList");
	}

	@Override
	public Object insertProjectMain(Map<String, Object> params) {
		return commonSql.insert("ProjectManageDAO.insertProjectMain", params);
	}

	@Override
	public Object insertProjectDetail(Map<String, Object> params) {
		return commonSql.insert("ProjectManageDAO.insertProjectDetail", params);
	}

	@SuppressWarnings("unchecked")
	@Override
	public Map<String, Object> selectProjectInfo(Map<String, Object> params) {
		return (Map<String, Object>)commonSql.select("ProjectManageDAO.selectProjectInfo", params);
	}

	@Override
	public void updateProjectMain(Map<String, Object> params) {
		commonSql.update("ProjectManageDAO.updateProjectMain", params);
	}

	@Override
	public void updateProjectDetail(Map<String, Object> params) {
		commonSql.update("ProjectManageDAO.updateProjectDetail", params);
		
	}

	@Override
	public void deleteProjectInfo(Map<String, Object> params) {
		commonSql.delete("ProjectManageDAO.deleteProjectMain", params);
		commonSql.delete("ProjectManageDAO.deleteProjectDetail", params);
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<Map<String, Object>> selectErpProject(Map<String, Object> params) {
		return (List<Map<String, Object>>) commonSql.list("ProjectManageDAO.selectErpProject", params);
	}

	@Override
	public Object insertProjectMainFromErp(Map<String, Object> params) {
		return commonSql.insert("ProjectManageDAO.insertProjectMainFromErp", params);
	}

	@Override
	public Object updateProjectMainFromErp(Map<String, Object> params) {
		return commonSql.update("ProjectManageDAO.updateProjectMainFromErp", params);
	}
	
	@Override
	public Object updateProjectDetailFromErp(Map<String, Object> params) {
		return commonSql.update("ProjectManageDAO.updateProjectDetailFromErp", params);
	}

	@Override
	public Object insertProjectDetailFromErp(Map<String, Object> params) {
		return commonSql.insert("ProjectManageDAO.insertProjectDetailFromErp", params);
	}

	@Override
	public void updateProjectMainStatus(Map<String, Object> params) {
		commonSql.update("ProjectManageDAO.updateProjectMainStatus", params);
	}

	@Override
	public void updateProjectRestore(Map<String, Object> params) {
		commonSql.update("ProjectManageDAO.updateProjectRestore", params);
		
	}

	@Override
	public void updateProjectDetailRoomId(Map<String, Object> params) {
		commonSql.update("ProjectManageDAO.updateProjectDetailRoomId", params);
		
	}

	@Override
	public void projectRoomCreate(Map<String, Object> params) {
		// json parameter 셋팅
		JSONObject body = new JSONObject();
		
		// 대화 참여자 리스트(프로젝트 담당자)
		JSONArray receiverList = new JSONArray();
		
		JSONObject user = new JSONObject();
		user.put("empSeq", params.get("pmSeq"));
		receiverList.add(user);
		body.put("receiver", receiverList);
		body.put("roomType", "4");
		body.put("projectId", params.get("noProject"));
		body.put("roomTitle", params.get("nmProject"));
		
		// 대화방 생성 요청
		JSONObject result = MobileHttpJsonUtil.send(params.get("groupSeq")+"", params.get("empSeq")+"", "POST", params.get("uri")+"", body);

		// 대화방 키 저장
		if (result != null) {
			params.put("roomId", result.getString("roomId"));

			updateProjectDetailRoomId(params);
		}
		
	}

	@Override
	public JSONObject projectRoomIn(Map<String, Object> params) {
		// json parameter 셋팅
		JSONObject body = new JSONObject();
		
		// 대화 참여자 리스트(프로젝트 담당자)
		JSONArray receiverList = new JSONArray();
		
		JSONObject user = new JSONObject();
		user.put("empSeq", params.get("pmSeq"));
		user.put("empName", params.get("pmName"));
		user.put("positionName", params.get("positionName"));
		receiverList.add(user);
		
		
		body.put("roomId", params.get("roomId"));
		body.put("empName", params.get("pmName"));
		body.put("receiver", receiverList);
		
		// 신규 pm 대화방 초대하기
		JSONObject result =  MobileHttpJsonUtil.send(params.get("groupSeq")+"", params.get("empSeq")+"", "POST", params.get("uri")+"", body);
		
		return result;
		
	}

	@Override
	public void projectRoomOut(Map<String, Object> params) {
		// json parameter 셋팅
		JSONObject body = new JSONObject();

		// 대화 참여자 리스트(프로젝트 담당자)
		JSONArray roomList = new JSONArray();

		JSONObject room = new JSONObject();
		room.put("roomId", params.get("roomId"));
		room.put("roomType", params.get("roomType"));
		roomList.add(room);
		
		
		body.put("roomList", roomList);
		body.put("empName", params.get("empName"));
		body.put("positionName", params.get("positionName"));

		// 신규 pm 대화방 초대하기
		JSONObject result =  MobileHttpJsonUtil.send(params.get("groupSeq")+"", params.get("pmSeq")+"", "POST", params.get("uri")+"", body);

	} 
	//제거되지 않고 남은 디버그 코드
//	public static void main(String[] args) {
//		JSONObject json = new JSONObject();
//		JSONArray body = new JSONArray();
//		
//		JSONObject json1 = new JSONObject();
//		json1.put("CNo", "1111");
//		JSONObject json2 = new JSONObject();
//		json2.put("CNo", "2222");
//		body.add(json1);
//		body.add(json2);
//		 
//		json.put("Body", body);
//		
//	}

	@Override
	public List<Map<String, Object>> getRoomIdList(Map<String, Object> params) {
		return commonSql.list("ProjectManageDAO.getRoomIdList", params);
	}

	@Override
	public void projectUserRoomOut(Map<String, Object> params, List<Map<String, Object>> roomIdList) {
		// json parameter 셋팅
		JSONObject body = new JSONObject();		
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		
		for(Map<String, Object> mp : roomIdList){
			JSONArray outList = new JSONArray();
			List<Map<String, Object>> roomUserList = commonSql.list("ProjectManageDAO.getRoomUserList", mp);
			if(roomUserList != null){
				for(Map<String, Object> userMap : roomUserList){
					JSONObject user = new JSONObject();
					user.put("empSeq", userMap.get("empSeq"));
					outList.add(user);
				}
			}			
			JSONObject pmUser = new JSONObject();
			pmUser.put("empSeq", mp.get("pmSeq"));
			outList.add(pmUser);
			
			
			body.put("roomId", mp.get("roomId"));
			body.put("roomType", "4");
			body.put("outList", outList);
			JSONObject result =  MobileHttpJsonUtil.send(loginVO.getGroupSeq(), loginVO.getUniqId(), "POST", params.get("uri")+"", body);
		}
		
	}
	
	public Map<String, Object> projectData(Map<String, Object> params, PaginationInfo paginationInfo) {
		Map<String, Object> list = new HashMap<String, Object>();
		
		list = (Map<String,Object>)commonSql.listOfPaging2(params, paginationInfo, "ProjectManageDAO.projectData");
		return list;
	}
	
}
