package neos.cmm.systemx.img.service.impl;

import java.util.Iterator;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import neos.cmm.db.CommonSqlDAO;
import neos.cmm.systemx.img.service.FileUploadService;

@Service("FileUploadService")
public class FileUploadServiceImpl implements FileUploadService{
	
	@Resource(name = "commonSql")
	private CommonSqlDAO commonSql;
	 
	@SuppressWarnings("unchecked")
	@Override
	public String insertAttachFile(List<Map<String,Object>> paramMap) {
		Map<String,Object> vo = (Map<String,Object>) paramMap.get(0);
		String fileId = vo.get("fileId")+"";
		
		commonSql.insert("AttachFileUpload.insertAtchFile", vo);

		Iterator<?> iter = paramMap.iterator();
		while (iter.hasNext()) {
			vo = (Map<String,Object>) iter.next();

			commonSql.insert("AttachFileUpload.insertAtchFileDetail", vo);
		}
		
		return fileId;
		
	}
	
	@Override
	public void insertOrgImg(Map<String, Object> paramMap) {
		commonSql.insert("OrgChart.insertOrgImg", paramMap);
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<Map<String, Object>> getOrgImg(Map<String, Object> paramMap) {
		return commonSql.list("OrgChart.getOrgImg", paramMap);
	}

	@SuppressWarnings("unchecked")
	@Override
	public Map<String, Object> getAttachFileDetail(Map<String, Object> paramMap) {
		return (Map<String, Object>) commonSql.select("AttachFileUpload.selectAttachFileDetail", paramMap);
	}

	@Override
	public Object selectOrgImg(Map<String, Object> paramMap) {
		return commonSql.select("OrgChart.selectOrgImg", paramMap);
	}

	@Override
	public void deleteFile(Map<String, Object> paramMap) {
		commonSql.delete("AttachFileUpload.deleteAtchFile", paramMap);
		commonSql.delete("AttachFileUpload.deleteAtchFileDetail", paramMap);
	}

	@Override
	public void deleteOrgImg(Map<String, Object> paramMap) {
		commonSql.delete("AttachFileUpload.deleteOrgImg", paramMap);
		
	}

}
