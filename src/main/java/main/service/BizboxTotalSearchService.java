package main.service;

import java.util.List;
import java.util.Map;

import main.vo.SearchWord;
import main.web.PagingReturnObj;

public interface BizboxTotalSearchService {
	//통합검색
	public PagingReturnObj tsearchList(Map<String,String> params, String listType) throws Exception;
	//통합검색_메일 API 조회
	public PagingReturnObj tsearchListForMail(Map<String,String> params) throws Exception;
	//검색어 저장
	public void saveSearchKeyword(Map<String, String> reqParams) throws Exception;
	//검색어미사용 처리
	public void setNoUseSearchKeyword(Map<String, String> reqParams) throws Exception;
	//최근검색어 조회
	public List<SearchWord> getRecentSearchKeyword(Map<String, String> reqParams) throws Exception;
	//메뉴 권한 맵
	public Map<String, Object> getMenuAuthMap(Map<String, String> params);
}