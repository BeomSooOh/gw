package api.totalsearch.controller;

import java.util.Map;

import javax.annotation.Resource;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import api.common.model.APIResponse;
import api.totalsearch.service.TotalSearchService;

@Controller
public class TotalSearchController {
	
	@Resource(name="TotalSearchService")
	private TotalSearchService totalSearchService;
	
	
	/** 2016.12.13 박근우 작성
	 * boardList : 통합검색 게시판 가져오기
	 * @param paramMap
	 * @return
	 */
	@RequestMapping(value="/totalsearch/boardList", method=RequestMethod.POST)
	@ResponseBody
	public APIResponse boardList(@RequestBody Map<String, Object> paramMap) {
		
		APIResponse response = null;
		paramMap.put("boardType","9");
		// 리턴 결과 
		response = totalSearchService.searchList(paramMap);
		
		return response;
	}
	
	/** 2016.12.20 박근우 작성
	 * boardList : 통합검색 전체 가져오기
	 * @param paramMap
	 * @return
	 */
	@RequestMapping(value="/totalsearch/totalList", method=RequestMethod.POST)
	@ResponseBody
	public APIResponse totalList(@RequestBody Map<String, Object> paramMap) {
		
		APIResponse response = null;
		
		// 리턴 결과 
		response = totalSearchService.totalList(paramMap);
		
		return response;
	}
	
	/** 2016.12.22 박근우 작성
	 * projectList : 통합검색 업무관리 가져오기
	 * @param paramMap
	 * @return
	 */
	@RequestMapping(value="/totalsearch/projectList", method=RequestMethod.POST)
	@ResponseBody
	public APIResponse projectList(@RequestBody Map<String, Object> paramMap) {
		
		APIResponse response = null;
		paramMap.put("boardType","2");
		// 리턴 결과 
		response = totalSearchService.searchList(paramMap);
		
		return response;
	}
	
	/** 2016.12.22 박근우 작성
	 * scheduleList : 통합검색 일정 가져오기
	 * @param paramMap
	 * @return
	 */
	@RequestMapping(value="/totalsearch/scheduleList", method=RequestMethod.POST)
	@ResponseBody
	public APIResponse scheduleList(@RequestBody Map<String, Object> paramMap) {
		
		APIResponse response = null;
		paramMap.put("boardType","3");
		// 리턴 결과 
		response = totalSearchService.searchList(paramMap);
		
		return response;
	}
	
	/** 2016.12.22 박근우 작성
	 * noteList : 통합검색 노트 가져오기
	 * @param paramMap
	 * @return
	 */
	@RequestMapping(value="/totalsearch/noteList", method=RequestMethod.POST)
	@ResponseBody
	public APIResponse noteList(@RequestBody Map<String, Object> paramMap) {
		
		APIResponse response = null;
		paramMap.put("boardType","4");
		// 리턴 결과 
		response = totalSearchService.searchList(paramMap);
		
		return response;
	}
	
	/** 2016.12.22 박근우 작성
	 * reportList : 통합검색 업무보고 가져오기
	 * @param paramMap
	 * @return
	 */
	@RequestMapping(value="/totalsearch/reportList", method=RequestMethod.POST)
	@ResponseBody
	public APIResponse reportList(@RequestBody Map<String, Object> paramMap) {
		
		APIResponse response = null;
		paramMap.put("boardType","5");
		// 리턴 결과 
		response = totalSearchService.searchList(paramMap);
		
		return response;
	}
	
	/** 2016.12.22 박근우 작성
	 * eapList : 통합검색 전자결재(영리) 가져오기
	 * @param paramMap
	 * @return
	 */
	@RequestMapping(value="/totalsearch/eapList", method=RequestMethod.POST)
	@ResponseBody
	public APIResponse eapList(@RequestBody Map<String, Object> paramMap) {
		
		APIResponse response = null;
		paramMap.put("boardType","6");
		// 리턴 결과 
		response = totalSearchService.searchList(paramMap);
		
		return response;
	}
	
	/** 2016.12.22 박근우 작성
	 * edmsList : 통합검색 문서 가져오기
	 * @param paramMap
	 * @return
	 */
	@RequestMapping(value="/totalsearch/edmsList", method=RequestMethod.POST)
	@ResponseBody
	public APIResponse edmsList(@RequestBody Map<String, Object> paramMap) {
		
		APIResponse response = null;
		paramMap.put("boardType","8");
		// 리턴 결과 
		response = totalSearchService.searchList(paramMap);
		
		return response;
	}
	
	/** 2016.12.22 박근우 작성
	 * fileList : 통합검색 첨부파일 가져오기
	 * @param paramMap
	 * @return
	 */
	@RequestMapping(value="/totalsearch/fileList", method=RequestMethod.POST)
	@ResponseBody
	public APIResponse fileList(@RequestBody Map<String, Object> paramMap) {
		
		APIResponse response = null;
		paramMap.put("boardType","10");
		// 리턴 결과 
		response = totalSearchService.searchList(paramMap);
		
		return response;
	}
	
	/** 2016.12.22 박근우 작성
	 * eaList : 통합검색 전자결재(비영리) 가져오기
	 * @param paramMap
	 * @return
	 */
	@RequestMapping(value="/totalsearch/eaList", method=RequestMethod.POST)
	@ResponseBody
	public APIResponse eaList(@RequestBody Map<String, Object> paramMap) {
		
		APIResponse response = null;
		paramMap.put("boardType","7");
		// 리턴 결과 
		response = totalSearchService.searchList(paramMap);
		
		return response;
	}
	
	/** 2017.03.17 박근우 작성
	 * boardList : 게시판 넘버 가져오기
	 * @param paramMap
	 * @return
	 */
	@RequestMapping(value="/totalsearch/boardFileInfo", method=RequestMethod.POST)
	@ResponseBody
	public APIResponse boardFileInfo(@RequestBody Map<String, Object> paramMap) {
		
		APIResponse response = null;
		// 리턴 결과 
		response = totalSearchService.boardFileInfo(paramMap);
		
		return response;
	}
}
