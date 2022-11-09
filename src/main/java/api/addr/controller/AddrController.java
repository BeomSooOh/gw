package api.addr.controller;

import java.util.Map;

import javax.annotation.Resource;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import api.common.model.APIResponse;
import api.addr.service.AddrService;

@Controller
public class AddrController {
	
	@Resource(name="AddrService")
	private AddrService addrService;
	
	
	/** 2016.03.29 주성덕 작성
	 * AddrGroupList : 주소록 그룹 리스트 가져오기(메일)
	 * @param paramMap
	 * @return
	 */
	@RequestMapping(value="/addr/AddrGroupList", method=RequestMethod.POST)
	@ResponseBody
	public APIResponse AddrGroupList(@RequestBody Map<String, Object> paramMap) {
		
		APIResponse response = null;
		
		// 리턴 결과 
		response = addrService.addrGroupList(paramMap);
		
		return response;
	}
	
	/** 2018.03.21 주성덕 작성
	 * AddrGroupTp : 주소록 구분 리스트(회사,공용,개인)
	 * @param paramMap
	 * @return
	 */
	@RequestMapping(value="/addr/AddrGroupTp", method=RequestMethod.POST)
	@ResponseBody
	public APIResponse AddrGroupTp(@RequestBody Map<String, Object> paramMap) {
		
		APIResponse response = null;
		
		// 리턴 결과 
		response = addrService.AddrGroupTp(paramMap);
		
		return response;
	}
	
	
	/** 2016.03.29 주성덕 작성
	 * AddrList : 주소록 리스트 가져오기(메일)
	 * @param paramMap
	 * @return
	 */
	@RequestMapping(value="/addr/AddrList", method=RequestMethod.POST)
	@ResponseBody
	public APIResponse AddrList(@RequestBody Map<String, Object> paramMap) {
		
		APIResponse response = null;
		
		// 리턴 결과 
//		response = addrService.addrList(paramMap);
		
		// 리턴 결과 
		response = addrService.faxAddrList(paramMap);
		
		return response;
	}
	
	
	/** 2016.03.29 주성덕 작성
	 * AddrList : 주소록 리스트 가져오기(회사검색조건 제외) (메일)
	 * @param paramMap
	 * @return
	 */
	@RequestMapping(value="/addr/AddrList2", method=RequestMethod.POST)
	@ResponseBody
	public APIResponse AddrList2(@RequestBody Map<String, Object> paramMap) {
		
		APIResponse response = null;
		
		// 리턴 결과 
		response = addrService.addrList2(paramMap);
		
		return response;
	}
	
	
	/** 2016.03.29 주성덕 작성
	 * AddrList : 주소록 정보 가져오기 (메일)
	 * @param paramMap
	 * @return
	 */
	@RequestMapping(value="/addr/AddrInfo", method=RequestMethod.POST)
	@ResponseBody
	public APIResponse AddrInfo(@RequestBody Map<String, Object> paramMap) {
		
		APIResponse response = null;
		
		// 리턴 결과 
		response = addrService.addrInfo(paramMap);
		
		return response;
	}
	
	
	
	/** 2016.04.07 주성덕 작성
	 * AddrList : 주소록 등록하기 (메일)
	 * @param paramMap
	 * @return
	 */
	@RequestMapping(value="/addr/InsertAddrInfo", method=RequestMethod.POST)
	@ResponseBody
	public APIResponse InsertAddrInfo(@RequestBody Map<String, Object> paramMap) {
		
		APIResponse response = null;
		
		// 리턴 결과 
		response = addrService.InsertAddrInfo(paramMap);
		
		return response;
	}
	
	
	
	
	/** 2016.05.04 주성덕 작성
	 * AddrList : 주소록그룹리스트 (팩스)
	 * @param paramMap
	 * @return
	 */
	@RequestMapping(value="/addr/addrGroupList", method=RequestMethod.POST)
	@ResponseBody
	public APIResponse addrGroupList(@RequestBody Map<String, Object> paramMap) {
		
		APIResponse response = null;
		
		// 리턴 결과 
		response = addrService.faxAddrGroupList(paramMap);
		
		return response;
	}
	
	
	/** 2016.05.04 주성덕 작성
	 * AddrList : 주소록 리스트 가져오기(팩스)
	 * @param paramMap
	 * @return
	 */
	@RequestMapping(value="/addr/addrList", method=RequestMethod.POST)
	@ResponseBody
	public APIResponse addrList(@RequestBody Map<String, Object> paramMap) {
		
		APIResponse response = null;
		
		// 리턴 결과 
		response = addrService.faxAddrList(paramMap);
		
		return response;
	}
	
	
	
	/** 2016.07.06 주성덕 작성
	 * AddrGroupList : 주소록 그룹 리스트 가져오기(메일) - 구분에따른 조회 추가.(addr_group_tp)
	 * @param paramMap
	 * @return
	 */
	@RequestMapping(value="/addr/AddrGroupListM", method=RequestMethod.POST)
	@ResponseBody
	public APIResponse AddrGroupList2(@RequestBody Map<String, Object> paramMap) {
		
		APIResponse response = null;
		
		// 리턴 결과 
		response = addrService.addrGroupList2(paramMap);
		
		return response;
	}
	
	
	/** 2016.07.07 주성덕 작성
	 * AddrList : 주소록 등록하기2 (메일-모바일)
	 * @param paramMap
	 * @return
	 */
	@RequestMapping(value="/addr/InsertAddrInfoM", method=RequestMethod.POST)
	@ResponseBody
	public APIResponse InsertAddrInfo2(@RequestBody Map<String, Object> paramMap) {
		
		APIResponse response = null;
		
		// 리턴 결과 
		response = addrService.InsertAddrInfo2(paramMap);
		
		return response;
	}
	
	
	/** 2017.10.31 주성덕 작성
	 * AddrList : 주소록 등록하기 (GCMS연동 전용)
	 * @param paramMap
	 * @return
	 */
	@RequestMapping(value="/addr/InsertAddrInfoForGCMS", method=RequestMethod.POST)
	@ResponseBody
	public APIResponse InsertAddrInfoForGCMS(@RequestBody Map<String, Object> paramMap) {
		
		APIResponse response = null;
		
		// 리턴 결과 
		response = addrService.InsertAddrInfoForGCMS(paramMap);
		
		return response;
	}
	
	
	/** 2017.10.16 주성덕 작성
	 * AddrList : 주소록 그룹 등록
	 * @param paramMap
	 * @return
	 */
	@RequestMapping(value="/addr/InsertAddrGroup", method=RequestMethod.POST)
	@ResponseBody
	public APIResponse InsertAddrGroup(@RequestBody Map<String, Object> paramMap) {
		
		APIResponse response = null;
		
		// 리턴 결과 
		response = addrService.InsertAddrGroup(paramMap);
		
		return response;
	}
	
	
	/** 2017.10.31 주성덕 작성
	 * AddrList : 주소록 그룹 등록(GCMG전용)
	 * @param paramMap
	 * @return
	 */
	@RequestMapping(value="/addr/InsertAddrGroupForGCMS", method=RequestMethod.POST)
	@ResponseBody
	public APIResponse InsertAddrGroupForGCMS(@RequestBody Map<String, Object> paramMap) {
		
		APIResponse response = null;
		
		// 리턴 결과 
		response = addrService.InsertAddrGroupForGCMS(paramMap);
		
		return response;
	}
	
	
	/** 2018.11.16 주성덕 작성
	 * AddrList : 주소록 그룹 등록(mail전용)
	 * @param paramMap
	 * @return
	 */
	@RequestMapping(value="/addr/CreateAddrGroup", method=RequestMethod.POST)
	@ResponseBody
	public APIResponse CreateAddrGroup(@RequestBody Map<String, Object> paramMap) {
		
		APIResponse response = null;
		
		// 리턴 결과 
		response = addrService.CreateAddrGroup(paramMap);
		
		return response;
	}
}
