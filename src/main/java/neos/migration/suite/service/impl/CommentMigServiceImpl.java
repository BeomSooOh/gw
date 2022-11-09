package neos.migration.suite.service.impl;

import java.io.IOException; 
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.log4j.Logger;
import org.codehaus.jackson.map.ObjectMapper;
import org.json.simple.JSONArray;
import org.json.simple.parser.JSONParser;
import org.springframework.stereotype.Service;

import restful.com.service.AttachFileService;
import api.comment.service.CommentService;
import api.comment.vo.CommentVO;
import api.common.model.EventRequest;
import api.common.service.EventService;
import neos.migration.suite.dao.CommentMigDAO;
import neos.migration.suite.service.CommentMigService;

@Service("CommentMigService")
public class CommentMigServiceImpl implements CommentMigService{
	
	@Resource(name = "CommentMigDAO")
	CommentMigDAO commentMigDAO = new CommentMigDAO();
	
	@Resource(name="AttachFileService")
	AttachFileService attachFileService;
	
	@Resource(name="EventService")
	EventService eventService;
	
	
	@Override
	public Map<String, Object> insertComment(CommentVO param) throws Exception {
		
		if("".equals(param.getEmpName())) {
			ObjectMapper mapper = new ObjectMapper();
			
			
			List<Map<String,Object>> empList = commentMigDAO.selectEmpName(param);
			String empName = mapper.writeValueAsString(empList);
			param.setEmpName(empName);
			
			List<Map<String,Object>> deptList = commentMigDAO.selectDeptName(param);
			String deptName = mapper.writeValueAsString(deptList);
			param.setDeptName(deptName);
			
			List<Map<String,Object>> compList = commentMigDAO.selectCompName(param);
			String compName = mapper.writeValueAsString(compList);
			param.setCompName(compName);
			
			List<Map<String,Object>> dutyList = commentMigDAO.selectDutyName(param);
			String dutyName = mapper.writeValueAsString(dutyList);
			param.setDutyName(dutyName);
			
			List<Map<String,Object>> postitionList = commentMigDAO.selectPostitionName(param);
			String postitionName = mapper.writeValueAsString(postitionList);
			param.setPositionName(postitionName);
		}
		
		String commentSeq ="";
		String sortCommentSeq = "";
		Map<String, Object> result = new HashMap<String,Object>();
		
		if("".equals(param.getCommentSeq())) {
			//등록
			if("".equals(param.getParentCommentSeq())) {
				commentSeq = commentMigDAO.selectCommentSeq(param);
				sortCommentSeq = commentSeq;
				param.setTopLevelCommentSeq(commentSeq);
			}else{
				commentSeq = commentMigDAO.selectReCommentSeq(param);
				sortCommentSeq = commentMigDAO.selectSortReCommentSeq(param);
			}
			param.setCommentSeq(commentSeq);
			param.setSortCommentSeq(sortCommentSeq);
			commentMigDAO.insertComment(param);
			
			commentMigDAO.addCommentCnt(param);
			
			// 알림 정보가 없을 경우 이벤트 발송 하지 않음.
//			if (param.getEvent() != null && param.getEvent().size() > 0) {
//				eventSend(param);
//			}
			
		}else{
			//수정
			commentMigDAO.updateComment(param);
			
		}
		
		result.put("commentSeq", param.getCommentSeq());
		
		return result;
		
	}

	
	
}