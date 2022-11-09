package api.comment.service.impl;

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
import api.comment.dao.CommentDAO;
import api.comment.service.CommentService;
import api.comment.vo.CommentVO;
import api.common.model.EventRequest;
import api.common.service.EventService;

@Service("CommentService")
public class CommentServiceImpl implements CommentService{
	
	@Resource(name = "CommentDAO")
	CommentDAO commentDAO = new CommentDAO();
	

	
	@Resource(name="AttachFileService")
	AttachFileService attachFileService;
	
	@Resource(name="EventService")
	EventService eventService;
	
	
	@Override
	public Map<String, Object> insertComment(CommentVO param) throws Exception {
		
		if("".equals(param.getEmpName())) {
			ObjectMapper mapper = new ObjectMapper();
			
			
			
			List<Map<String,Object>> empList = commentDAO.selectEmpName(param);
			String empName = mapper.writeValueAsString(empList);
			param.setEmpName(empName);
			
			List<Map<String,Object>> deptList = commentDAO.selectDeptName(param);
			String deptName = mapper.writeValueAsString(deptList);
			param.setDeptName(deptName);
			
			List<Map<String,Object>> compList = commentDAO.selectCompName(param);
			String compName = mapper.writeValueAsString(compList);
			param.setCompName(compName);
			
			List<Map<String,Object>> dutyList = commentDAO.selectDutyName(param);
			String dutyName = mapper.writeValueAsString(dutyList);
			param.setDutyName(dutyName);
			
			List<Map<String,Object>> postitionList = commentDAO.selectPostitionName(param);
			String postitionName = mapper.writeValueAsString(postitionList);
			param.setPositionName(postitionName);
		}
		
		String commentSeq ="";
		String sortCommentSeq = "";
		Map<String, Object> result = new HashMap<String,Object>();
		
		if("".equals(param.getCommentSeq())) {
			//등록
			if("".equals(param.getParentCommentSeq())) {
				commentSeq = commentDAO.selectCommentSeq(param);
				sortCommentSeq = commentSeq;
				param.setTopLevelCommentSeq(commentSeq);
			}else{
				commentSeq = commentDAO.selectReCommentSeq(param);
				sortCommentSeq = commentDAO.selectSortReCommentSeq(param);
			}
			param.setCommentSeq(commentSeq);
			param.setSortCommentSeq(sortCommentSeq);
			commentDAO.insertComment(param);
			
			commentDAO.addCommentCnt(param);
			
			// 알림 정보가 없을 경우 이벤트 발송 하지 않음.
			if (param.getEvent() != null && param.getEvent().size() > 0) {
				eventSend(param);
			}
			
		}else{
			//수정
			commentDAO.updateComment(param);
			
		}
		
		result.put("commentSeq", param.getCommentSeq());
		
		return result;
		
	}

	//댓글 삭제
	@Override
	public int deleteComment(CommentVO param) throws Exception {
		
		param.setUseYn("N");
		int delCnt = 0;
		
		//댓글 삭제
		if(!param.getCommentSeq().equals(param.getTopLevelCommentSeq())) {
			delCnt = commentDAO.deleteReComment(param);
			param.setCommentSeq(param.getTopLevelCommentSeq());
			
		}else {
			delCnt = commentDAO.deleteComment(param);
		}
		
		String viewYn = commentDAO.selectCommentViewYn(param);
		if("N".equals(viewYn)) {
			commentDAO.updateCommentViwe(param);
		}
		
		if("".equals(param.getModuleGbnCode())) {
			Map<String,Object> result = commentDAO.selectModuleInfo(param);
			param.setModuleGbnCode(result.get("moduleGbnCode").toString());
			param.setModuleSeq(result.get("moduleSeq").toString());
		}
		commentDAO.addCommentCnt(param);
		
		return delCnt;
		
	}

	@Override
	public Map<String, Object> selectCommentList(CommentVO param) throws Exception {
		
		
		
		int pageSize = param.getPageSize();
		
		if (pageSize > Integer.MAX_VALUE || pageSize < Integer.MIN_VALUE) {//정수형 오버플로우 방지 적용
	        throw new IllegalArgumentException("out of bound");
	    }
		
		param.setPageSize(pageSize+1);
		
		
		Map<String, Object> result = new HashMap<String,Object>();
		result.put("moreYn", "N");			//더보기 Yn(초기값)
		
		List<Map<String,Object>> commentList = new ArrayList<Map<String,Object>>();
		
		//하위 조회
		if("".equals(param.getSearchWay())) {
			param.setSearchWay("D");
		}
		
		if("D".equals(param.getSort())) {
			
			//최신순 조회
			if(!"".equals(param.getCommentSeq())) {
				String sortCommentSeq = commentDAO.selectSortCommentSeq(param);
				param.setSortCommentSeq(sortCommentSeq);
			}
			commentList = commentDAO.selectSortCommentList(param);
			
		}else {
			//등록순 조회
			commentList = commentDAO.selectCommentList(param);
			
		}
		
	
		if(commentList.size() > pageSize){		
			commentList.remove(commentList.size() - 1);
			result.put("moreYn", "Y");
		}
		
		commentList  = checkCommentList(commentList, param);
		
		result.put("commentList", commentList);
		
		
		return result;
	}
	
	@Override
	public Map<String, Object> selectOneCommentList(CommentVO param) throws Exception {
		
		//(특정 댓글,대댓글 조회)
		
		
		Map<String, Object> result = new HashMap<String,Object>();
		
		List<Map<String,Object>> commentList = new ArrayList<Map<String,Object>>();
		
		//하위 조회
		if("".equals(param.getSearchWay())) {
			param.setSearchWay("D");
		}
		
		if("D".equals(param.getSort())) {
			
			commentList = commentDAO.selectOneSortCommentList(param);
			
		}else {
			//등록순 조회
			commentList = commentDAO.selectOneCommentList(param);
			
		}
		
		commentList  = checkCommentList(commentList, param);
		
	
		
		result.put("commentList", commentList);
		
		
		return result;
	}
	
	
	private List<Map<String,Object>> checkCommentList(List<Map<String,Object>> commentList, CommentVO param) throws Exception {
		
		String langCode = param.getLangCode();
		for(Map<String,Object>comment : commentList) { 
			
			comment.remove("rnum");
			List<Map<String,Object>> commentFileList  = new ArrayList<Map<String,Object>>();	
			if(comment.get("fileId") != null && !comment.get("fileId").toString().isEmpty()){
				Map<String,Object> request = new HashMap<String,Object>();
				
				request.put("fileId", comment.get("fileId"));
				request.put("groupSeq", param.getGroupSeq());
				comment.put("fileList",commentDAO.selectFileList(request));					
			}else {
				comment.put("fileList", commentFileList);			
			}
			
			JSONParser parser = new JSONParser();
			JSONArray jsonObject = new JSONArray();
			
			if(comment.get("compName") != null && !"".equals(comment.get("compName").toString())) {
				
				Object obj = parser.parse(comment.get("compName").toString());
				jsonObject = (JSONArray) obj;
				List<Map<String,Object>> compNameList = (List<Map<String, Object>>) jsonObject;
				for(Map<String,Object> compName : compNameList) {
					if(langCode.equals(compName.get("langCode").toString())) {
						comment.put("compName", compName.get("compName"));
						break;
					}else if("kr".equals(compName.get("langCode").toString())){
						comment.put("compName", compName.get("compName"));
					}
				}
			}
			
			if(comment.get("deptName") != null && !"".equals(comment.get("deptName").toString())) {
				
				Object obj = parser.parse(comment.get("deptName").toString());
				jsonObject = (JSONArray) obj;
				List<Map<String,Object>> deptNameList = (List<Map<String, Object>>) jsonObject;
				for(Map<String,Object> deptName : deptNameList) {
					if(langCode.equals(deptName.get("langCode").toString())) {
						comment.put("deptName", deptName.get("deptName"));
						break;
					}else if("kr".equals(deptName.get("langCode").toString())){
						comment.put("deptName", deptName.get("deptName"));
					}
				}
			}
			
			if(comment.get("empName") != null && !"".equals(comment.get("empName").toString()) && (comment.get("empName").toString().contains("["))) {
				
					Object obj = parser.parse(comment.get("empName").toString());
					jsonObject = (JSONArray) obj;
				
					List<Map<String,Object>> empNameList = (List<Map<String, Object>>) jsonObject;
					for(Map<String,Object> empName : empNameList) {
						if(langCode.equals(empName.get("langCode").toString())) {
							comment.put("empName", empName.get("empName"));
							break;
						}else if("kr".equals(empName.get("langCode").toString())){
							comment.put("empName", empName.get("empName"));
						}
					}
			}
			
			if(comment.get("dutyName") != null && !"".equals(comment.get("dutyName").toString())) {
				
				Object obj = parser.parse(comment.get("dutyName").toString());
				jsonObject = (JSONArray) obj;
				List<Map<String,Object>> dutyNameList = (List<Map<String, Object>>) jsonObject;
				for(Map<String,Object> dutyName : dutyNameList) {
					if(langCode.equals(dutyName.get("langCode").toString())) {
						comment.put("dutyName", dutyName.get("dutyName"));
						break;
					}else if("kr".equals(dutyName.get("langCode").toString())){
						comment.put("dutyName", dutyName.get("dutyName"));
					}
				}
			}
			
			if(comment.get("positionName") != null && !"".equals(comment.get("positionName").toString())) {
				
				Object obj = parser.parse(comment.get("positionName").toString());
				jsonObject = (JSONArray) obj;
				List<Map<String,Object>> positionNameList = (List<Map<String, Object>>) jsonObject;
				for(Map<String,Object> positionName : positionNameList) {
					if(langCode.equals(positionName.get("langCode").toString())) {
						comment.put("positionName", positionName.get("positionName"));
						break;
					}else if("kr".equals(positionName.get("langCode").toString())){
						comment.put("positionName", positionName.get("positionName"));
					}
				}
			}
			
		
			
		}
		
		return commentList;
	}

	@Override
	public Map<String, Object> selectCommentCount(CommentVO param) throws Exception {
		
		return commentDAO.selectCommentCount(param);
	}

	@Override
	public Map<String, Object> selectOrgchartList(CommentVO param) throws Exception {
		
		int pageNum = (Integer) param.getPageNum();
		
		int startIdx = (pageNum - 1) * param.getPageSize();
		
		param.setPageNum(startIdx);
		
		int pageSize = param.getPageSize();
		
		param.setPageSize(pageSize+1);
		
		
		//부서 경로 가져 오기 하위 부서 조회
		Map<String,Object> request = new HashMap<String,Object>();
		String searchEmpSeqs = "";
		request.put("groupSeq", param.getGroupSeq());
		if(param.getDeptList() != null && param.getDeptList().size() > 0){
			
			searchEmpSeqs = "'";
			for(String searchDept : param.getDeptList()) {
				request.put("deptSeq", searchDept);
				List<String> searchDeptEmpList = commentDAO.selectDeptEmpList(request);
				if(searchDeptEmpList.size() > 0) {
					String searchEmpList = searchDeptEmpList.toString();
					searchEmpSeqs += searchEmpList.replace(",", "','");
				}
			}
			
			searchEmpSeqs += "'";
		}			
		//사용자 조회
		if(param.getEmpList() != null && param.getEmpList().size() >0) {
			if(searchEmpSeqs.length() > 0) {
				searchEmpSeqs += ",'";
			}else {
				searchEmpSeqs = "'";
			}
			searchEmpSeqs += param.getEmpList().toString().replace(",", "','");
			
			searchEmpSeqs += "'";
		}
		
		if(searchEmpSeqs.length() > 0) {
			param.setSearchEmpSeq(searchEmpSeqs);
		}
				
		
		Map<String, Object> result = new HashMap<String,Object>();
		result.put("moreYn", "N");			//더보기 Yn(초기값)
		
		List<Map<String,Object>> empList = commentDAO.selectOrgchartList(param);
		if(empList.size() > pageSize){		
			empList.remove(empList.size() - 1);
			result.put("moreYn", "Y");
		}
		
		
		
		result.put("empList", empList);
		
		
		return result;
	}
	
	
	//이벤트 전달 
	private void eventSend(CommentVO param) throws IOException{
		
		//이벤트 처리
		Map<String,Object> event = param.getEvent();
		Map<String,Object> eventData = (Map<String, Object>) event.get("data");
		
		EventRequest eventRequest = new EventRequest();
		
		if(event.get("eventType") != null) {
			
			eventRequest.setEventType(event.get("eventType").toString());
			eventRequest.setEventSubType(event.get("eventSubType").toString());
	
		    for (Map.Entry<String, Object> entry : eventData.entrySet()) {
		        
		    	if(entry.getValue() != null && !entry.getValue().equals("")) {
		    		
		    		if(entry.getValue().equals("{contents}")) {
		    			eventData.put(entry.getKey(), param.getContents());
		    		}else if(entry.getValue().equals("{empSeq}")) {
		    			eventData.put(entry.getKey(), param.getEmpSeq());
		    		}else if(entry.getValue().equals("{commentSeq}")) {
		    			eventData.put(entry.getKey(), param.getCommentSeq());
		    		}
		    	}
		    }
		    
			if(event.get("eventSubType") != null && event.get("eventSubType").toString().equals("RP004")) {
				eventData.put("comment", param.getContents());
			}			
			
		}else if(param.getModuleGbnCode().equals("eap")){
			
			//전자결재(영리)이벤트
			eventData.put("title", eventData.get("title").toString());
			eventData.put("userSeq", param.getEmpSeq());
			eventData.put("doc_comment", param.getContents());
			eventData.put("menu_id", eventData.get("menu_id").toString());
			eventData.put("migYn", eventData.get("migYn").toString());
			eventData.put("doc_id", param.getModuleSeq());
			eventData.put("comment_seq", param.getCommentSeq());
			eventData.put("doc_no", eventData.get("doc_no").toString());
			eventRequest.setEventType("EAPPROVAL");
			eventRequest.setEventSubType("EA105");
			
		}else {
			return;
		}
		
		eventRequest.setGroupSeq(param.getGroupSeq());
		eventRequest.setCompSeq(param.getCompSeq());
		eventRequest.setSenderSeq(param.getEmpSeq());
		
		if(!event.containsKey("alertYn") || "".equals(event.get("alertYn"))) {
			eventRequest.setAlertYn("Y");
		}else {
			eventRequest.setAlertYn(event.get("alertYn").toString());
		}
		
		if(!event.containsKey("pushYn") || "".equals(event.get("pushYn"))) {
			eventRequest.setPushYn("Y");
		}else {
			eventRequest.setPushYn(event.get("pushYn").toString());
		}
		
		if(!event.containsKey("talkYn") || "".equals(event.get("talkYn"))) {
			eventRequest.setTalkYn("Y");
		}else {
			eventRequest.setTalkYn(event.get("talkYn").toString());
		}
		
		if(!event.containsKey("mailYn") || "".equals(event.get("mailYn"))) {
			eventRequest.setMailYn("Y");
		}else {
			eventRequest.setMailYn(event.get("mailYn").toString());
		}
		
		if(!event.containsKey("smsYn") || "".equals(event.get("smsYn"))) {
			eventRequest.setSmsYn("Y");
		}else {
			eventRequest.setSmsYn(event.get("smsYn").toString());
		}
		
		if(!event.containsKey("portalYn") || "".equals(event.get("portalYn"))) {
			eventRequest.setPortalYn("Y");
		}else {
			eventRequest.setPortalYn(event.get("portalYn").toString());
		}
		
		if(!event.containsKey("timelineYn") || "".equals(event.get("timelineYn"))) {
			eventRequest.setTimelineYn("Y");
		}else {
			eventRequest.setTimelineYn(event.get("timelineYn").toString());
		}
		
		eventRequest.setRecvEmpBulk(event.get("recvEmpBulk") == null ? "" : event.get("recvEmpBulk").toString());
		eventRequest.setRecvEmpBulkList((List<String>)event.get("recvEmpBulkList"));
		eventRequest.setRecvEmpList((List<Map<String,Object>>)event.get("recvEmpList"));
		
		List<Map<String,Object>> recvMentionEmpList = (List<Map<String,Object>>)event.get("recvMentionEmpList");
		
		if(recvMentionEmpList == null) {
			recvMentionEmpList = new ArrayList<Map<String, Object>>();
		}
		
		//멘션리스트 추가 
		for(Map<String,Object>recvMention : recvMentionEmpList) {
			Map<String, Object> recvMentionClone = new HashMap<String,Object>();
			recvMentionClone.putAll(recvMention);
			recvMentionClone.put("langCode", "kr");
			recvMentionClone.put("pushYn", "Y");
			eventRequest.addRecvEmpList(recvMentionClone);	
		}
		
		eventRequest.setRecvMentionEmpList((List<Map<String,Object>>)event.get("recvMentionEmpList"));
		eventRequest.setLangCode(param.getLangCode());
		eventRequest.setUrl(event.get("url").toString());
		eventRequest.setIgnoreCntYn("Y");
		eventRequest.setData(eventData);
		
		Logger.getLogger( CommentServiceImpl.class ).debug( "CommentServiceImpl.eventSend eventRequest : " + eventRequest.toString() );
		
		eventService.eventSend(eventRequest);
		
	}

	@Override
	public String checkAdminMasterAuth(Map<String, Object> param) {
		return commentDAO.checkAdminMasterAuth(param);
	}
	
	
	
}