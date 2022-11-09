package neos.cmm.systemx.file.service.impl;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

//import org.apache.log4j.Logger;
import org.springframework.stereotype.Service;

import egovframework.com.utl.fcc.service.EgovFileUploadUtil;
import neos.cmm.db.CommonSqlDAO;
import neos.cmm.systemx.file.service.WebAttachFileService;
import neos.cmm.systemx.group.service.GroupManageService;
import neos.cmm.util.CommonUtil;
import neos.cmm.util.ImageUtil;
import neos.cmm.util.NeosConstants;
import neos.cmm.util.code.service.SequenceService;

@Service("WebAttachFileService")
public class WebAttachFileServiceImpl implements WebAttachFileService{
	
	//private Logger logger = Logger.getLogger(this.getClass());

	@Resource(name="GroupManageService")
	GroupManageService groupManageService;
	
	@Resource(name = "commonSql")
	private CommonSqlDAO commonSql; 
	
	@Resource(name="SequenceService")
	SequenceService sequenceService;
	
	@SuppressWarnings("unchecked")
	@Override
	public List<Map<String,Object>> insertAttachFile(List<Map<String, Object>> paramMap) {
		List<Map<String,Object>> resultList = new ArrayList<Map<String,Object>>();
		Map<String,Object> vo = (Map<String,Object>) paramMap.get(0);
		try {
			

			Iterator<?> iter = paramMap.iterator();
			while (iter.hasNext()) {
				vo = (Map<String,Object>) iter.next();
				commonSql.insert("AttachFileUpload.insertAtchFile", vo);
				commonSql.insert("AttachFileUpload.insertAtchFileDetail", vo);
				
				resultList.add(vo);
			}
		} catch(Exception e) {
			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
			return null;
		}
		
		return resultList;
	}

	@SuppressWarnings("unchecked")
	@Override
	public Map<String, Object> getAttachFileDetail(Map<String, Object> paramMap) {
		return (Map<String, Object>) commonSql.select("AttachFileUpload.selectAttachFileDetail", paramMap);
	}

	@Override
	public Map<String, Object> profileConvert(Map<String, Object> paramMap) {
		
		String groupSeq = paramMap.get("groupSeq").toString();
		paramMap.put("osType", NeosConstants.SERVER_OS);
		paramMap.put("pathSeq", "900");
		
		String rootPath = null;
		List<Map<String,Object>> pathList = groupManageService.selectGroupPathList(paramMap);
		if (pathList != null && pathList.size() > 0) {
			rootPath = pathList.get(0).get("absolPath").toString();
			
		}
		
		String newRootPath = null; 
		paramMap.put("pathSeq", "910");
		pathList = groupManageService.selectGroupPathList(paramMap);
		if (pathList != null && pathList.size() > 0) {
			newRootPath = pathList.get(0).get("absolPath").toString();
			
		}
		
		String newPath = newRootPath + File.separator + groupSeq;
		
		String path = null;

		List<Map<String,Object>> list = (List<Map<String, Object>>) commonSql.list("AttachFileUpload.selectEmpProfileList", paramMap);
		int count = 0;
		if (list != null && list.size() > 0) {
			for(Map<String,Object> fileInfo : list) {
				try {
					String pathSeq = fileInfo.get("pathSeq").toString();
					
					if (pathSeq.equals("910")) {
						path = newRootPath;
					} else {
						path = rootPath;
					}
					
					File file = new File(path+File.separator+fileInfo.get("fileStreCours")+File.separator+fileInfo.get("streFileName")+"."+fileInfo.get("fileExtsn"));
					
					String newName = fileInfo.get("empSeq").toString();
					
//					String pathSeq = fileInfo.get("pathSeq").toString();
					
					long size = 0L;
					
//					if (pathSeq.equals("910")) {
//						continue;
//					}
					
					
					String fileExt = fileInfo.get("fileExtsn").toString();
					String imgExt = "jpeg|bmp|gif|jpg|png";
					if (imgExt.indexOf(fileExt) != -1) {
						String imgSizeType = "thum";			//일단 썸네일 사이즈만
						int imgMaxWidth = 420;
						fileExt = "jpg";
						ImageUtil.saveResizeImage(new File(newPath+File.separator+newName+"_"+imgSizeType+"."+fileExt), file, imgMaxWidth);
					} else {
						continue;
					}
					
					String saveFilePath = newPath+File.separator+newName+"."+fileExt;
					size = EgovFileUploadUtil.saveFile(new FileInputStream(file), new File(saveFilePath));
					//System.out.println("## size : " + size);
					
					Map<String,Object> newFileInfo = new HashMap<String,Object>();
					if (size > 0) {
						newFileInfo.put("fileId", fileInfo.get("fileId"));
						newFileInfo.put("fileSn", fileInfo.get("fileSn"));
						newFileInfo.put("pathSeq", "910");
						newFileInfo.put("fileStreCours", File.separator+groupSeq);
						newFileInfo.put("streFileName", newName);
						newFileInfo.put("orignlFileName", fileInfo.get("orignlFileName"));
						newFileInfo.put("fileExtsn", fileExt);
						newFileInfo.put("fileCn", fileInfo.get("fileCn"));
						newFileInfo.put("fileSize", size);
						newFileInfo.put("inpName", file.getName());
						
						commonSql.insert("AttachFileUpload.insertAtchFileDetail", newFileInfo);
						
						count++;
					}
					
				} catch (FileNotFoundException e) {
					CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
				} catch (IOException e) {
					CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
				} catch (Exception e) {
					CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
				}
				
			}
		}
		
		Map<String,Object> resultMap = new HashMap<String,Object>();
		
		resultMap.put("count", count);
		
		return resultMap;
	}

	@SuppressWarnings("unchecked")
	@Override
	public String insertAttachFileInfo(List<Map<String, Object>> paramMap) {
		Map<String,Object> vo = (Map<String,Object>) paramMap.get(0);
		String fileId = vo.get("fileId")+"";
		
		try {
			//commonSql.insert("AttachFileUpload.insertAtchFile", vo);
			//System.out.println("1. vo : " + vo);
			commonSql.insert("AttachFileUpload.insertAtchFileInfo", vo);

			Iterator<?> iter = paramMap.iterator();
			while (iter.hasNext()) {
				vo = (Map<String,Object>) iter.next();
				//commonSql.insert("AttachFileUpload.insertAtchFileDetail", vo);
				//System.out.println("2. vo : " + vo);
				commonSql.insert("AttachFileUpload.insertAtchFileDetailInfo", vo);
			}
		} catch(Exception e) {
			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
			return null;
		}
		
		return fileId;
	}

	
	
	@Override	
	public boolean checkPersonnelCardAuth(Map<String, Object> mp) {		
		//인사기록카드 권한 조회
		//필요 파라미터  (fileId, groupSeq, empSeq, compSeq, userSe)	
		
		//파라미터 유효여부 체크
		if(mp.get("fileId") == null || mp.get("fileId").equals("")){
			return false;
		}
		if(mp.get("groupSeq") == null || mp.get("groupSeq").equals("")){
			return false;
		}
		if(mp.get("empSeq") == null || mp.get("empSeq").equals("")){
			return false;
		}
		if(mp.get("compSeq") == null || mp.get("compSeq").equals("")){
			return false;
		}
		if(mp.get("userSe") == null || mp.get("userSe").equals("")){
			return false;
		}
		
		
		
		
		Map<String, Object> paramMap = new HashMap<String, Object>();
		paramMap.put("fileId",  mp.get("fileId"));		
 		paramMap.put("groupSeq", mp.get("groupSeq"));			
		
		//인사기록카드 열람 권한있는지 추가조회가 필요.
		//사용자일 경우 열람범위 -> 본인 & 권한(인사근태 승인자관리 궝한 따라감)
		//관리자일 경우 열람범위 -> 본인 회사(인사기록카드 메뉴권한 있을경우)
		Map<String, Object> myCard = (Map<String, Object>) commonSql.select("AttachFileUpload.getPersonnelCardInfo", paramMap);
		boolean isAuth = false;
		
		if(mp.get("userSe").toString().equals("USER")){	
			paramMap.put("empSeq", mp.get("empSeq"));
			paramMap.put("compSeq", mp.get("compSeq"));
			List<Map<String, Object>> authCard = commonSql.list("AttachFileUpload.getPersonnelCardAuthList", paramMap);
			if(myCard != null){
				if(myCard.get("empSeq") != null){
					if(myCard.get("empSeq").toString().equals(mp.get("empSeq"))){
						isAuth = checkAuth(0, mp.get("groupSeq").toString(), mp.get("empSeq").toString(), mp.get("compSeq").toString());
					}
				}
				
				if(!isAuth){
					for(Map<String, Object> map : authCard){
						if(map.get("empSeq").toString().equals(myCard.get("empSeq").toString())){
							isAuth = checkAuth(1, mp.get("groupSeq").toString(), mp.get("empSeq").toString(), mp.get("compSeq").toString());
							break;
						}
					}
				}
			}
		}else if(mp.get("userSe").toString().equals("ADMIN")){
			if(myCard != null){
				if(myCard.get("mainCompSeq") != null){
					if(myCard.get("mainCompSeq").toString().equals(mp.get("compSeq"))){
						isAuth = checkAuth(2, mp.get("groupSeq").toString(), mp.get("empSeq").toString(), mp.get("compSeq").toString());
					}
				}
			}
		}else{
			return false;
		}
		
		if(!isAuth){
			return false;
		}
		
		return true;
	}
	
	
	public boolean checkAuth(int type, String groupSeq, String empSeq, String compSeq){
		//type (0)  => 메뉴권한 조회(사용자 - 인사기록카드(본인))
		//type (1)  => 메뉴권한 조회(사용자 - 인사기록카드(권한))
		//type (2)  => 메뉴권한 조회(관리자 - 인사기록카드(전사))

		Map<String, Object> params = new HashMap<String, Object>();
		
		params.put("groupSeq", groupSeq);
		params.put("empSeq", empSeq);
		params.put("compSeq", compSeq);
		
		if(type == 0){
			params.put("menuNo", "707060000");
		}else if(type == 1){
			params.put("menuNo", "707070000");
		}else if(type == 2){
			params.put("menuNo", "932060000");
		}
		
		List<Map<String, Object>> authList = commonSql.list("AttachFileUpload.getPersonnelCardMenuAuth", params);
		if(authList.size() > 0) {
			return true;
		}
		else {		
			return false;
		}
	}
}
