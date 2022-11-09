package neos.cmm.systemx.file.service;

import java.util.List;
import java.util.Map;

public interface WebAttachFileService {
	
	public List<Map<String,Object>> insertAttachFile(List<Map<String,Object>> paramMap);
	
	public Map<String, Object> getAttachFileDetail(Map<String, Object> paramMap);
	
	public Map<String, Object> profileConvert(Map<String, Object> paramMap);

	public String insertAttachFileInfo(List<Map<String, Object>> saveFileList);
	
	public boolean checkPersonnelCardAuth(Map<String, Object> mp);
}
