package restful.mobile.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import neos.cmm.systemx.file.service.WebAttachFileService;
import neos.cmm.systemx.group.service.GroupManageService;
import neos.cmm.util.NeosConstants;

import org.springframework.stereotype.Repository;

import egovframework.com.cmm.service.impl.EgovComAbstractDAO;
import restful.com.service.AttachFileService;
import restful.mobile.vo.RestfulVO;

@Repository("RestfulDAO")
public class RestfulDAO extends EgovComAbstractDAO {
	/**
	 * 모바일 로그인 처리
	 * @param - 조회할 정보가 담긴 RestVO
	 * @return 조회결과
	 * @exception Exception
	 */
	
	@Resource(name="AttachFileService")
	AttachFileService attachFileService;
	
	@Resource(name="WebAttachFileService")
	WebAttachFileService webAttachFileService;
	
	@Resource(name="GroupManageService")
	GroupManageService groupManageService;
	
	@SuppressWarnings("unchecked")
	public List<RestfulVO> actionLoginMobile(RestfulVO vo) throws Exception {
		return list("restDAO.actionLoginMobile", vo);
	}

	public List<Map<String,Object>> selectLoginVO(RestfulVO vo) throws Exception {
		return list("restDAO.selectLoginVO", vo);
	}	

    public String selectLoginPassword(RestfulVO vo) throws Exception{
        return (String)select("restDAO.selectLoginPassword" , vo);
    }

	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> selectOrgImgList(Map<String,Object> vo) {
		return list("restDAO.selectOrgImgList", vo);
	}	
	
	public List<Map<String, Object>> selectOptionListMobile(Map<String, Object> param) {
		return (List<Map<String, Object>>)list("restDAO.selectOptionListMobile", param);
	}
	
	public List<Map<String, Object>> selectUsageOptionListMobile(Map<String, Object> param) {
		return (List<Map<String, Object>>)list("restDAO.selectUsageOptionListMobile", param);
	}
	
	
	public Map<String, Object> checkEmpPersonnelCardInfo(Map<String, Object> param) {
		
		Map<String, Object> result = new HashMap<String, Object>();
		
		String viewAuthYn = "N";
		String cardRegYn = "N";
		String fileId = "";
		
		String originalFileName = "";
		String fileExtsn = "";
		String fileSize = "";
		
		boolean sMasterAuth = false;
		
		//인사기록카드 마스터조회권한 조회
		List<Map<String, Object>> authList = list("GroupManage.getPerssonelCardMasterAuth", param);
		for(Map<String, Object> mp : authList){
			if(mp.get("empSeq").toString().equals(param.get("empSeq").toString()) || param.get("empSeq").toString().equals(param.get("targetEmpSeq").toString())){
				sMasterAuth = true;
				viewAuthYn = "Y";
				fileId = (String) mp.get("fileId");
				
				result.put("fileId", fileId);
				
				if(!"".equals(fileId)){
					cardRegYn = "Y";
				}
				
				if(cardRegYn.equals("Y")){
			    	param.put("osType", NeosConstants.SERVER_OS);				
			    	param.put("fileId", fileId);
			    	
					/** 첨부파일 상세정보 조회 */
				 	Map<String, Object> fileMap = attachFileService.getAttachFileDetail(param);
		
				 	/** 절대경로 조회 */
				 	param.put("pathSeq", fileMap.get("pathSeq"));
				 	originalFileName = fileMap.get("orignlFileName") == null ? "" : fileMap.get("orignlFileName").toString();
				 	fileExtsn = fileMap.get("fileExtsn") == null ? "" : fileMap.get("fileExtsn").toString();
				 	fileSize = fileMap.get("fileSize") == null ? "" : fileMap.get("fileSize").toString();
			    }
				break;
			}
		}
		
		
		
		
		if(!sMasterAuth){		
			List<Map<String, Object>> list = list("AttachFileUpload.getPersonnelCardAuthList", param);
		    
		    if(list.size() > 0){
		    	viewAuthYn = "Y";
		    	cardRegYn = list.get(0).get("fileId") == null || list.get(0).get("fileId").toString().equals("") ? "N" : "Y";
		    	result.put("fileId", list.get(0).get("fileId"));
		    }else{
		    	//조회자, 조회대상자 동일할 경우 체크
		    	if(param.get("empSeq").toString().equals(param.get("targetEmpSeq").toString())){
		    		Map<String, Object> personnelCardInfo = (Map<String, Object>) select("restDAO.selectPersonnelCardInfo", param);
		    		if(personnelCardInfo != null){
		    			viewAuthYn = "Y";
		    			cardRegYn = "Y";
		    			result.put("fileId", personnelCardInfo.get("fileId"));
		    		}
		    	}
		    }
		    
		    if(cardRegYn.equals("Y")){
		    	param.put("osType", NeosConstants.SERVER_OS);				
		    	param.put("fileId", result.get("fileId"));
		    	
		    	//메뉴권한 여부 체크
		    	param.put("userSe", "USER");
		    	if(!webAttachFileService.checkPersonnelCardAuth(param)){
		    		viewAuthYn = "N";
		    		cardRegYn = "N";
		    		//filePath = "";
		    		fileId = "";
		    		result.put("fileId", fileId);
		    		
		    		originalFileName = "";
		    		fileExtsn = "";
		    		fileSize = "";
		    	}else{		    	
					/** 첨부파일 상세정보 조회 */
				 	Map<String, Object> fileMap = attachFileService.getAttachFileDetail(param);
		
				 	/** 절대경로 조회 */
				 	param.put("pathSeq", fileMap.get("pathSeq"));
				 	
				 	//String path = groupPahtInfo.get("absolPath") + "" + fileMap.get("fileStreCours");
				 	//String fileName =  fileMap.get("streFileName") + "." + fileMap.get("fileExtsn");
				 	
				 	originalFileName = fileMap.get("orignlFileName") == null ? "" : fileMap.get("orignlFileName").toString();
				 	fileExtsn = fileMap.get("fileExtsn") == null ? "" : fileMap.get("fileExtsn").toString();
				 	fileSize = fileMap.get("fileSize") == null ? "" : fileMap.get("fileSize").toString();
				 	
				 	//filePath = path + "/" + fileName;
		    	}
		    }
		}
	    
	    if(cardRegYn.equals("N")) {
	    	viewAuthYn = "N";
	    }
	    
	    if(result.get("fileId") == null) {
	    	result.put("fileId", "");
	    }
	    
	    result.put("fileSn", "0");	
	    result.put("originalFileName", originalFileName);
	    result.put("fileExtsn", fileExtsn);
	    result.put("fileSize", fileSize); 
	    result.put("pathSeq", "1610");
	    result.put("viewAuthYn", viewAuthYn);
	    result.put("cardRegYn", cardRegYn);
	    result.put("filePath", "");
		
		return result;
	}
	
	public Map<String, Object> selectSchOptionMobile(Map<String, Object> param) {
		return (Map<String, Object>)select("restDAO.selectSchOptionMobile", param);
	}	
}
