package api.mail.service;

import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import api.common.model.APIResponse;

public interface ApiMailService {

	APIResponse UpdateDomain(Map<String, Object> paramMap);
	
	APIResponse passwordChange(Map<String, Object> paramMap, HttpServletRequest request);
	
	APIResponse passwordChangeCheck(Map<String, Object> paramMap, HttpServletRequest request);

	APIResponse getManualUrl();

	APIResponse getGwVolume(Map<String, Object> paramMap);

	APIResponse setGwVolumeFromMail(Map<String, Object> paramMap);

	APIResponse getDownloadType(Map<String, Object> paramMap);

	APIResponse getGwGroupInfo(Map<String, Object> paramMap);
	
	APIResponse getGwDomain(Map<String, Object> paramMap);

}
