package api.comment.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import neos.cmm.util.BizboxAProperties;
import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import api.common.exception.APIException;
import api.common.helper.LogHelper;
import api.common.model.APIResponse;
import bizbox.orgchart.service.vo.LoginVO;
import egovframework.com.cmm.util.EgovUserDetailsHelper;
import neos.cmm.util.CommonUtil;
import api.comment.service.CommentService;
import api.comment.vo.CommentVO;



@Controller
public class CommentController {

    
    private static final Logger logger = LoggerFactory.getLogger(CommentController.class);
    
	
	@Resource(name = "CommentService")
	private CommentService commentService;
	

	private String codeHead = "systemx.comment";
	
    /*
     * post 호출 및 json 응답
     * 댓글 등록/수정
     */
	@RequestMapping(value="/InsertComment", method={RequestMethod.GET, RequestMethod.POST})
	@ResponseBody
	public APIResponse InsertCommnet(
								HttpServletRequest servletRequest, 
								HttpServletResponse servletResponse,
								@RequestBody Map<String, Object> request
							) throws Exception {
		
		String serviceErrorCode = "COMMENT001";
		long time = System.currentTimeMillis();

		 APIResponse response = null;
		Map<String, Object> header = (Map<String, Object>) request.get("header");
		 Map<String, Object> body = (Map<String, Object>) request.get("body");
		
		 body.putAll((Map<String, Object>)body.get("companyInfo"));
		 body.putAll(header);
		
		try {
			
			CommentVO commentVo = new CommentVO();
			
			LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
			
			if(loginVO != null) {
				
				//수정일 경우
				if(body.get("commentSeq") != null && !body.get("commentSeq").equals("")) {
					
					commentVo.setEmpSeq(loginVO.getUniqId());
					
					if(loginVO.getUserSe().equals("ADMIN") || loginVO.getUserSe().equals("MASTER")) {
						commentVo.setAdminYn("Y");
					}
					
				}else {
					commentVo.setEmpSeq(loginVO.getUniqId());
				}
				
			}else {
				commentVo.setEmpSeq(body.get("empSeq").toString());
			}
			
			commentVo.setLangCode(body.get("langCode").toString());
			commentVo.setModuleGbnCode(body.get("moduleGbnCode").toString());
			commentVo.setModuleSeq(body.get("moduleSeq").toString());
			commentVo.setCommentType(body.get("commentType").toString());
			commentVo.setCommentSeq(body.get("commentSeq").toString());
			commentVo.setParentCommentSeq(body.get("parentCommentSeq").toString());
			commentVo.setContents(body.get("contents").toString());
			commentVo.setHighGbnCode(body.get("highGbnCode").toString());
			commentVo.setMiddleGbnCode(body.get("middleGbnCode").toString());
			commentVo.setEmpName(body.get("empName").toString());
			commentVo.setCommentPassword(body.get("commentPassword").toString());
			commentVo.setDutyCode(body.get("dutyCode").toString());
			commentVo.setPositionCode(body.get("positionCode").toString());
			commentVo.setFileId(body.get("fileId").toString());
			commentVo.setCompSeq(body.get("compSeq").toString());
			commentVo.setBizSeq(body.get("bizSeq").toString());
			commentVo.setDeptSeq(body.get("deptSeq").toString());
			commentVo.setGroupSeq(body.get("groupSeq").toString());
			
			commentVo.setDepth((int)body.get("depth"));
			commentVo.setTopLevelCommentSeq(body.get("topLevelCommentSeq").toString());
			commentVo.setEvent((Map<String,Object>)body.get("event"));
			
			if("".equals(body.get("empName").toString())) {
				commentVo.setCreateIp(CommonUtil.getClientIp(servletRequest));
			}
			 logger.info("InsertComment" + "-start " + LogHelper.getRequestString(request));
			 Map<String,Object> result = commentService.insertComment(commentVo);	
			 response = LogHelper.createSuccess(result);
			 time = System.currentTimeMillis() - time;
			 logger.info("InsertComment" + "-end ET[" + time + "] "+ LogHelper.getResponseString(request, response));
		 } catch (APIException ae) {
			 response = LogHelper.createError(servletRequest, codeHead, ae);
			 time = System.currentTimeMillis() - time;
			 logger.error("InsertComment" + "-error ET[" + time + "] " + LogHelper.getResponseString(request, response), ae);
		 } catch (Exception e) {
			 response = LogHelper.createError(servletRequest, codeHead, serviceErrorCode);
			 time = System.currentTimeMillis() - time;
			 logger.error("InsertComment" + "-error ET[" + time + "] " + LogHelper.getResponseString(request, response), e);
		 }

		return response;		
	}
	
	/*
     * post 호출 및 json 응답
     * 댓글 삭제
     */
	@RequestMapping(value="/DeleteComment", method={RequestMethod.GET, RequestMethod.POST})
	@ResponseBody
	public APIResponse DeleteCommnet(
								HttpServletRequest servletRequest, 
								HttpServletResponse servletResponse,
								@RequestBody Map<String, Object> request
							) throws Exception {
		
		String serviceErrorCode = "COMMENT002";
		long time = System.currentTimeMillis();

		 APIResponse response = null;
		Map<String, Object> header = (Map<String, Object>) request.get("header");
		 Map<String, Object> body = (Map<String, Object>) request.get("body");
		
		 body.putAll((Map<String, Object>)body.get("companyInfo"));
		 body.putAll(header);
		
		CommentVO commentVo = new CommentVO();
		
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		
		if(loginVO != null) {
			
			if(loginVO.getUserSe().equals("ADMIN") || loginVO.getUserSe().equals("MASTER") || !commentService.checkAdminMasterAuth(body).equals("0")) {
				commentVo.setAdminYn("Y");
			}else {
				if(BizboxAProperties.getCustomProperty("BizboxA.CommentDelete").equals("Y")) {
					commentVo.setAdminYn("Y");
				}
				commentVo.setEmpSeq(loginVO.getUniqId());	
			}
			
		}else {
			if(BizboxAProperties.getCustomProperty("BizboxA.CommentDelete").equals("Y")) {
				commentVo.setAdminYn("Y");
			}
			commentVo.setEmpSeq(body.get("empSeq").toString());
		}		
		
		commentVo.setLangCode(body.get("langCode").toString());
		commentVo.setCommentSeq(body.get("commentSeq").toString());
		if(body.containsKey("moduleGbnCode")) {
			commentVo.setModuleGbnCode(body.get("moduleGbnCode").toString());
		}
		if(body.containsKey("moduleSeq")) {
			commentVo.setModuleSeq(body.get("moduleSeq").toString());
		}
		commentVo.setTopLevelCommentSeq(body.get("topLevelCommentSeq").toString());
		commentVo.setCompSeq(body.get("compSeq").toString());
		commentVo.setBizSeq(body.get("bizSeq").toString());
		commentVo.setDeptSeq(body.get("deptSeq").toString());
		commentVo.setGroupSeq(body.get("groupSeq").toString());
		
		int delCnt = 0;
		
		try {
			 logger.info("DeleteComment" + "-start " + LogHelper.getRequestString(request));
			 delCnt = commentService.deleteComment(commentVo);	
			 Map<String,Object> result = new HashMap<String,Object>();
			 if(delCnt == 0) {
				 response = LogHelper.createResponse(servletRequest, "-1", "TX000010665");
			 }else {
				 response = LogHelper.createSuccess(result);
			 }
			 time = System.currentTimeMillis() - time;
			 logger.info("DeleteComment" + "-end ET[" + time + "] "+ LogHelper.getResponseString(request, response));
		 } catch (APIException ae) {
			 response = LogHelper.createError(servletRequest, codeHead, ae);
			 time = System.currentTimeMillis() - time;
			 logger.error("DeleteComment" + "-error ET[" + time + "] " + LogHelper.getResponseString(request, response), ae);
		 } catch (Exception e) {
			 response = LogHelper.createError(servletRequest, codeHead, serviceErrorCode);
			 time = System.currentTimeMillis() - time;
			 logger.error("DeleteComment" + "-error ET[" + time + "] " + LogHelper.getResponseString(request, response), e);
		 }
		
		return response;		
	}
	
	/*
     * post 호출 및 json 응답
     * 댓글 조회
     */
	@RequestMapping(value="/SearchCommentList", method={RequestMethod.GET, RequestMethod.POST})
	@ResponseBody
	public APIResponse SearchCommnetList(
								HttpServletRequest servletRequest, 
								HttpServletResponse servletResponse,
								@RequestBody Map<String, Object> request
							) throws Exception {
		
		String serviceErrorCode = "COMMENT003";
		long time = System.currentTimeMillis();

		 APIResponse response = null;
		Map<String, Object> header = (Map<String, Object>) request.get("header");
		 Map<String, Object> body = (Map<String, Object>) request.get("body");
		
		 body.putAll((Map<String, Object>)body.get("companyInfo"));
		 body.putAll(header);
		
		CommentVO commentVo = new CommentVO();
		
		
		
		
		
		try {
			
			commentVo.setLangCode(body.get("langCode").toString());
			commentVo.setModuleGbnCode(body.get("moduleGbnCode").toString());
			commentVo.setModuleSeq(body.get("moduleSeq").toString());
			commentVo.setCommentType(body.get("commentType").toString());
			commentVo.setCommentSeq(body.get("commentSeq").toString());
			commentVo.setPageSize((Integer)body.get("pageSize"));
			commentVo.setCompSeq(body.get("compSeq").toString());
			commentVo.setBizSeq(body.get("bizSeq").toString());
			commentVo.setDeptSeq(body.get("deptSeq").toString());
			commentVo.setGroupSeq(body.get("groupSeq").toString());
			commentVo.setEmpSeq(body.get("empSeq").toString());
			commentVo.setSort(body.get("sort").toString());
			commentVo.setSearchWay(body.get("searchWay").toString());
			commentVo.setReqSubType((body.containsKey("reqSubType")?body.get("reqSubType").toString():"N"));
			
			 logger.info("SearchCommentList" + "-start " + LogHelper.getRequestString(request));
			Map<String,Object> result = commentService.selectCommentList(commentVo);	
			response = LogHelper.createSuccess(result);
			 time = System.currentTimeMillis() - time;
			 logger.info("SearchCommentList" + "-end ET[" + time + "] "+ LogHelper.getResponseString(request, response));
		 } catch (APIException ae) {
			 response = LogHelper.createError(servletRequest, codeHead, ae);
			 time = System.currentTimeMillis() - time;
			 logger.error("SearchCommentList" + "-error ET[" + time + "] " + LogHelper.getResponseString(request, response), ae);
		 } catch (Exception e) {
			 response = LogHelper.createError(servletRequest, codeHead, serviceErrorCode);
			 time = System.currentTimeMillis() - time;
			 logger.error("SearchCommentList" + "-error ET[" + time + "] " + LogHelper.getResponseString(request, response), e);
		 }

		return response;		
	}
	
	/*
     * post 호출 및 json 응답
     * 대댓글 조회
     */
	@RequestMapping(value="/SearchReCommentList", method={RequestMethod.GET, RequestMethod.POST})
	@ResponseBody
	public APIResponse SearchReCommnetList(
								HttpServletRequest servletRequest, 
								HttpServletResponse servletResponse,
								@RequestBody Map<String, Object> request
							) throws Exception {
		
		String serviceErrorCode = "COMMENT004";
		long time = System.currentTimeMillis();

		 APIResponse response = null;
		Map<String, Object> header = (Map<String, Object>) request.get("header");
		 Map<String, Object> body = (Map<String, Object>) request.get("body");
		
		 body.putAll((Map<String, Object>)body.get("companyInfo"));
		 body.putAll(header);
		
		CommentVO commentVo = new CommentVO();
		
		commentVo.setLangCode(body.get("langCode").toString());
		commentVo.setModuleGbnCode(body.get("moduleGbnCode").toString());
		commentVo.setModuleSeq(body.get("moduleSeq").toString());
		commentVo.setCommentType(body.get("commentType").toString());
		commentVo.setCommentSeq(body.get("commentSeq").toString());
		commentVo.setPageSize((Integer)body.get("pageSize"));
		commentVo.setCompSeq(body.get("compSeq").toString());
		commentVo.setBizSeq(body.get("bizSeq").toString());
		commentVo.setDeptSeq(body.get("deptSeq").toString());
		commentVo.setParentCommentSeq(body.get("parentCommentSeq").toString());
		commentVo.setGroupSeq(body.get("groupSeq").toString());
		commentVo.setEmpSeq(body.get("empSeq").toString());
		commentVo.setSort(body.get("sort").toString());
		commentVo.setSearchWay(body.get("searchWay").toString());
		commentVo.setReqSubType((body.containsKey("reqSubType")?body.get("reqSubType").toString():"N"));
		
		
		try {
			 logger.info("SearchReCommentList" + "-start " + LogHelper.getRequestString(request));
			Map<String,Object> result = commentService.selectCommentList(commentVo);	
			response = LogHelper.createSuccess(result);
			 time = System.currentTimeMillis() - time;
			 logger.info("SearchReCommentList" + "-end ET[" + time + "] "+ LogHelper.getResponseString(request, response));
		 } catch (APIException ae) {
			 response = LogHelper.createError(servletRequest, codeHead, ae);
			 time = System.currentTimeMillis() - time;
			 logger.error("SearchReCommentList" + "-error ET[" + time + "] " + LogHelper.getResponseString(request, response), ae);
		 } catch (Exception e) {
			 response = LogHelper.createError(servletRequest, codeHead, serviceErrorCode);
			 time = System.currentTimeMillis() - time;
			 logger.error("SearchReCommentList" + "-error ET[" + time + "] " + LogHelper.getResponseString(request, response), e);
		 }

		return response;		
	}
	
	/*
     * post 호출 및 json 응답
     * 댓글 조회
     */
	@RequestMapping(value="/SearchCommentCount", method={RequestMethod.GET, RequestMethod.POST})
	@ResponseBody
	public APIResponse SearchCommnetCount(
								HttpServletRequest servletRequest, 
								HttpServletResponse servletResponse,
								@RequestBody Map<String, Object> request
							) throws Exception {
		
		String serviceErrorCode = "COMMENT005";
		long time = System.currentTimeMillis();

		 APIResponse response = null;
		Map<String, Object> header = (Map<String, Object>) request.get("header");
		 Map<String, Object> body = (Map<String, Object>) request.get("body");
		
		 body.putAll((Map<String, Object>)body.get("companyInfo"));
		 body.putAll(header);
		
		CommentVO commentVo = new CommentVO();
		
		
		
		
		
		try {
			commentVo.setLangCode(body.get("langCode").toString());
			commentVo.setModuleGbnCode(body.get("moduleGbnCode").toString());
			commentVo.setModuleSeq(body.get("moduleSeq").toString());
			commentVo.setCommentType(body.get("commentType").toString());
			commentVo.setCompSeq(body.get("compSeq").toString());
			commentVo.setBizSeq(body.get("bizSeq").toString());
			commentVo.setDeptSeq(body.get("deptSeq").toString());
			commentVo.setGroupSeq(body.get("groupSeq").toString());
			commentVo.setEmpSeq(body.get("empSeq").toString());
			 logger.info("SearchCommentCount" + "-start " + LogHelper.getRequestString(request));
			Map<String,Object> result = commentService.selectCommentCount(commentVo);	
			response = LogHelper.createSuccess(result);
			 time = System.currentTimeMillis() - time;
			 logger.info("SearchCommentCount" + "-end ET[" + time + "] "+ LogHelper.getResponseString(request, response));
		 } catch (APIException ae) {
			 response = LogHelper.createError(servletRequest, codeHead, ae);
			 time = System.currentTimeMillis() - time;
			 logger.error("SearchCommentCount" + "-error ET[" + time + "] " + LogHelper.getResponseString(request, response), ae);
		 } catch (Exception e) {
			 response = LogHelper.createError(servletRequest, codeHead, serviceErrorCode);
			 time = System.currentTimeMillis() - time;
			 logger.error("SearchCommentCount" + "-error ET[" + time + "] " + LogHelper.getResponseString(request, response), e);
		 }

		return response;	
	}
	
	/*
     * post 호출 및 json 응답
     * 대댓글 조회
     */
	@RequestMapping(value={"/SearchOrgchartList","/SearchOrgchartList.do"}, method={RequestMethod.GET, RequestMethod.POST})
	@ResponseBody
	public APIResponse SearchOrgchartList(
								HttpServletRequest servletRequest, 
								HttpServletResponse servletResponse,
								@RequestBody Map<String, Object> request
							) throws Exception {
		
		String serviceErrorCode = "COMMENT006";
		long time = System.currentTimeMillis();

		 APIResponse response = null;
		Map<String, Object> header = (Map<String, Object>) request.get("header");
		 Map<String, Object> body = (Map<String, Object>) request.get("body");
		
		 body.putAll((Map<String, Object>)body.get("companyInfo"));
		 body.putAll(header);
		
		
		
		
		
		try {
			CommentVO commentVo = new CommentVO();
			commentVo.setLangCode(body.get("langCode").toString());
			commentVo.setModuleGbnCode(body.get("moduleGbnCode").toString());
			commentVo.setModuleSeq(body.get("moduleSeq").toString());
			commentVo.setEmpList((List<String>)body.get("empList"));
			commentVo.setDeptList((List<String>)body.get("deptList"));
			commentVo.setEmpName(body.get("empName").toString());
			commentVo.setPageNum((Integer)body.get("pageNum"));
			commentVo.setPageSize((Integer)body.get("pageSize"));
			commentVo.setCompSeq(body.get("compSeq").toString());
			commentVo.setBizSeq(body.get("bizSeq").toString());
			commentVo.setDeptSeq(body.get("deptSeq").toString());
			//commentVo.setParentCommentSeq(body.get("parentCommentSeq").toString());
			commentVo.setGroupSeq(body.get("groupSeq").toString());
			commentVo.setEmpSeq(body.get("empSeq").toString());
			logger.info("SearchOrgchartList" + "-start " + LogHelper.getRequestString(request));
			Map<String,Object> result = commentService.selectOrgchartList(commentVo);	
			response = LogHelper.createSuccess(result);
			 time = System.currentTimeMillis() - time;
			 logger.info("SearchOrgchartList" + "-end ET[" + time + "] "+ LogHelper.getResponseString(request, response));
		 } catch (APIException ae) {
			 response = LogHelper.createError(servletRequest, codeHead, ae);
			 time = System.currentTimeMillis() - time;
			 logger.error("SearchOrgchartList" + "-error ET[" + time + "] " + LogHelper.getResponseString(request, response), ae);
		 } catch (Exception e) {
			 response = LogHelper.createError(servletRequest, codeHead, serviceErrorCode);
			 time = System.currentTimeMillis() - time;
			 logger.error("SearchOrgchartList" + "-error ET[" + time + "] " + LogHelper.getResponseString(request, response), e);
		 }

		return response;	
	}
	
	/*
     * post 호출 및 json 응답
     * 댓글 조회(특정 댓글,대댓글 조회)
     */
	@RequestMapping(value="/SearchOneCommentList", method={RequestMethod.GET, RequestMethod.POST})
	@ResponseBody
	public APIResponse SearchOneCommnetList(
								HttpServletRequest servletRequest, 
								HttpServletResponse servletResponse,
								@RequestBody Map<String, Object> request
							) throws Exception {
		
		String serviceErrorCode = "COMMENT007";
		long time = System.currentTimeMillis();

		 APIResponse response = null;
		Map<String, Object> header = (Map<String, Object>) request.get("header");
		 Map<String, Object> body = (Map<String, Object>) request.get("body");
		
		 body.putAll((Map<String, Object>)body.get("companyInfo"));
		 body.putAll(header);
		
		CommentVO commentVo = new CommentVO();
		
		
		
		
		
		try {
			
			commentVo.setLangCode(body.get("langCode").toString());
			commentVo.setModuleGbnCode(body.get("moduleGbnCode").toString());
			commentVo.setModuleSeq(body.get("moduleSeq").toString());
			commentVo.setCommentType(body.get("commentType").toString());
			commentVo.setCommentSeq(body.get("commentSeq").toString());
			commentVo.setCompSeq(body.get("compSeq").toString());
			commentVo.setBizSeq(body.get("bizSeq").toString());
			commentVo.setDeptSeq(body.get("deptSeq").toString());
			commentVo.setGroupSeq(body.get("groupSeq").toString());
			commentVo.setEmpSeq(body.get("empSeq").toString());
			commentVo.setSort(body.get("sort").toString());
			
			
			 logger.info("SearchOneCommentList" + "-start " + LogHelper.getRequestString(request));
			Map<String,Object> result = commentService.selectOneCommentList(commentVo);	
			response = LogHelper.createSuccess(result);
			 time = System.currentTimeMillis() - time;
			 logger.info("SearchOneCommentList" + "-end ET[" + time + "] "+ LogHelper.getResponseString(request, response));
		 } catch (APIException ae) {
			 response = LogHelper.createError(servletRequest, codeHead, ae);
			 time = System.currentTimeMillis() - time;
			 logger.error("SearchOneCommentList" + "-error ET[" + time + "] " + LogHelper.getResponseString(request, response), ae);
		 } catch (Exception e) {
			 response = LogHelper.createError(servletRequest, codeHead, serviceErrorCode);
			 time = System.currentTimeMillis() - time;
			 logger.error("SearchOneCommentList" + "-error ET[" + time + "] " + LogHelper.getResponseString(request, response), e);
		 }

		return response;		
	}
}
