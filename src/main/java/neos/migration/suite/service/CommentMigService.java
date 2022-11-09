package neos.migration.suite.service;

import java.util.Map; 

import api.comment.vo.CommentVO;


public interface CommentMigService {
	 
	public Map<String, Object> insertComment(CommentVO param) throws Exception;
		
	
}
 

