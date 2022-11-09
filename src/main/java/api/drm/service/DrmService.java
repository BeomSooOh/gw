package api.drm.service;

import org.springframework.stereotype.Service;

@Service("DrmService")
public interface DrmService {

	public String drmConvert(String action, String groupSeq, String pathSeq, String filePath, String fileName, String fileExt);
	
	public String drmConvertAPI(String action, String groupSeq, String filePath, String fileName, String overWrite);
	
}
