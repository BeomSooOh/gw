package neos.cmm.systemx.img.service;

import java.util.List;
import java.util.Map;

public interface FileUploadService {
	
	public String insertAttachFile(List<Map<String,Object>> paramMap);
	
	/**
	 * 조직관련 이미지 입력
	 * @param params
	 */
	public void insertOrgImg(Map<String,Object> params);

	/**
	 * 조직 관련 이미지 가져오기
	 * @param params
	 * @return
	 */
	public List<Map<String, Object>> getOrgImg(Map<String, Object> params);

	public Map<String, Object> getAttachFileDetail(Map<String, Object> paramMap);

	public Object selectOrgImg(Map<String, Object> paramMap);

	public void deleteFile(Map<String, Object> paramMap);

	public void deleteOrgImg(Map<String, Object> paramMap);
	
	
}
