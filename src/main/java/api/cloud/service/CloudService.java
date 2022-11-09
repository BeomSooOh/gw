package api.cloud.service;

import java.util.Map;

import api.common.model.APIResponse;

public interface CloudService {

	APIResponse setGwVolumeFromGCMS(Map<String, Object> paramMap);

	void setBizboxCloudNoticeInfo(String val);
	
	String getBizboxCloudNoticeInfo();
	
}
