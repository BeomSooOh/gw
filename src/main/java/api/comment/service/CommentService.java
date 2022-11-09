package api.comment.service;

import java.util.Map;

import api.comment.vo.CommentVO;


public interface CommentService {
	 
	public Map<String, Object> insertComment(CommentVO param) throws Exception;
	
	public int deleteComment(CommentVO param) throws Exception;
	
	public Map<String, Object> selectCommentList(CommentVO param) throws Exception;
	
	public Map<String, Object> selectCommentCount(CommentVO param) throws Exception;

	public Map<String, Object> selectOrgchartList(CommentVO param) throws Exception;
	
	public Map<String, Object> selectOneCommentList(CommentVO param) throws Exception;

	public String checkAdminMasterAuth(Map<String, Object> param);
	
	
}
 

