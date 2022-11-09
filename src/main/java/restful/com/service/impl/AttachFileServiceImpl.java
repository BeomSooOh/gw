package restful.com.service.impl;

import java.io.File;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import egovframework.com.utl.fcc.service.EgovDateUtil;
import neos.cmm.db.CommonSqlDAO;
import neos.cmm.util.CommonUtil;
import neos.cmm.util.FileUtils;
import neos.cmm.util.ImageUtil;
import neos.cmm.util.code.service.SequenceService;
import restful.com.service.AttachFileService;

@Service("AttachFileService")
public class AttachFileServiceImpl implements AttachFileService{

	@Resource(name = "commonSql")
	private CommonSqlDAO commonSql;
	
	@Resource(name="SequenceService")
	SequenceService sequenceService;
	
	@SuppressWarnings("unchecked")
	@Override
	public String insertAttachFile(List<Map<String, Object>> paramMap) {
		Map<String,Object> vo = (Map<String,Object>) paramMap.get(0);
		String fileId = vo.get("fileId")+"";
		try {
			commonSql.insert("AttachFileUpload.insertAtchFile", vo);

			Iterator<?> iter = paramMap.iterator();
			while (iter.hasNext()) {
				vo = (Map<String,Object>) iter.next();

				commonSql.insert("AttachFileUpload.insertAtchFileDetail", vo);
			}
		} catch(Exception e) {
			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
			return null;
		}
		
		return fileId;
	}

	@SuppressWarnings("unchecked")
	@Override
	public Map<String, Object> getAttachFileDetail(Map<String, Object> paramMap) {
		return (Map<String, Object>) commonSql.select("AttachFileUpload.selectAttachFileDetail", paramMap);
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<Map<String, Object>> getAttachFileList(Map<String, Object> paramMap) {
		return (List<Map<String, Object>>) commonSql.list("AttachFileUpload.selectAttachFileDetail", paramMap);
	}

	@Override
	public int updateAttachFile(Map<String, Object> paramMap) {
		return commonSql.update("AttachFileUpload.updateAttachFile", paramMap);
	}

	@Override
	public int updateAttachFileDetail(Map<String, Object> paramMap) {
		return commonSql.update("AttachFileUpload.updateAttachFileDetail", paramMap);
	}

	@Override
	public int selectAttachFileMaxSn(Map<String, Object> paramMap) {
		return (Integer) commonSql.select("AttachFileUpload.selectAttachFileMaxSn", paramMap);
	}

	@Override
	public String fileSave(List<Map<String, Object>> fileList, Map<String, Object> params) throws Exception {
		String path = params.get("path")+"";
		String pathSeq = params.get("pathSeq")+"";
		String relativePath = params.get("relativePath")+"";
		String empSeq = params.get("empSeq")+"";
		
		/** File Id 생성(성공시 return) */
		params.put("value", "atchfileid");
		String fileId = sequenceService.getSequence(params);
		int fileSn = 0;
		List<Map<String,Object>> saveFileList = new ArrayList<Map<String,Object>>();
		Map<String,Object> newFileInfo = null;
		
		for(Map<String,Object> map : fileList) {
			String orginFileName = map.get("originalFileName")+"";
			String downloadUrl = map.get("downloadUrl")+"";
			String fileExt = map.get("fileExtsn")+"";

			String newName =  EgovDateUtil.today("yyyyMMdd_HHmmss") +"_"+fileId+"_"+fileSn;	// 저장할 파일명
			
			String saveFilePath = path+relativePath+File.separator+newName+"."+fileExt;
			
			File file = FileUtils.getUrlFileDownload(downloadUrl, saveFilePath);
			
			//System.out.println("path : " + path+relativePath);
			
			
			/** 이미지일때 썸네일 이미지 저장
			 *  파일명_small.확장자
			 *  */
			try{				
				String imgExt = "jpeg|bmp|jpg|png";		// gif 썹네일 안하도록 제거(움직이는 이미지의 경우 Image 라이브러리에서 오류 발생)
				if (imgExt.indexOf(fileExt) != -1) {
					String imgSizeType = "thum";			//일단 썸네일 사이즈만
					int imgMaxWidth = 420;
					ImageUtil.saveResizeImage(new File(path+relativePath+File.separator+newName+"_"+imgSizeType+"."+fileExt), new File(saveFilePath), imgMaxWidth);
				}
			}catch(Exception e){
				CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
				//System.out.println("## ImageUtil.saveResizeImage Error : 썸네일이미지 생성 오류");
			}
			
			
			if (file != null) {
				newFileInfo = new HashMap<String,Object>();
				newFileInfo.put("fileId", fileId);
				newFileInfo.put("fileSn", fileSn);
				newFileInfo.put("pathSeq", pathSeq);
				newFileInfo.put("fileStreCours", relativePath);
				newFileInfo.put("streFileName", newName);
				newFileInfo.put("orignlFileName", orginFileName);
				newFileInfo.put("fileExtsn", fileExt);
				newFileInfo.put("fileSize", file.length());
				newFileInfo.put("createSeq", empSeq);
				saveFileList.add(newFileInfo);
				fileSn++;
			}
		}
				
		String resultFileId = null;
		
		/** DB Insert */
		if (saveFileList.size() > 0) {
			resultFileId = insertAttachFile(saveFileList);
		}
		
		return resultFileId;
	}

}
