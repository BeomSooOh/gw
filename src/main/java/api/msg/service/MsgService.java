package api.msg.service;

import java.io.IOException;
import java.util.Map;

import com.fasterxml.jackson.core.JsonParseException;
import com.fasterxml.jackson.databind.JsonMappingException;

import api.common.model.APIResponse;


public interface MsgService {

	/**
	 * 메신저 링크메뉴 버전 조회
	 * @param request
	 * @return
	 */
	public APIResponse MsgMenuVer(Map<String, Object> paramMap);
	
	/**
	 * 메신저 링크메뉴 리스트 조회
	 * @param request
	 * @return
	 */
	public APIResponse MsgMenuList(Map<String, Object> paramMap);
	
	/**
	 * 메신저 링크메뉴 SSO Token
	 * @param request
	 * @return
	 */
	public APIResponse MsgLinkToken(Map<String, Object> paramMap);
	
	/**
	 * 메신저 링크메뉴 생성
	 * @param request
	 * @return
	 */
	public APIResponse setMsgMenu(Map<String, Object> paramMap);

	
	/**
	 * Gerp 링크메뉴 SSO Token
	 * @param request
	 * @return
	 */
	public APIResponse GerpLinkToken(Map<String, Object> paramMap);

	
	/**
	 * 메신저 최근게시글 목록
	 * @param request
	 * @return
	 * @throws IOException 
	 * @throws JsonMappingException 
	 * @throws JsonParseException 
	 */
	public APIResponse MsgBoardList(Map<String, Object> paramMap) throws JsonParseException, JsonMappingException, IOException;

}
