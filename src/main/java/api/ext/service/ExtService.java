package api.ext.service;

import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import api.common.model.APIResponse;


public interface ExtService {

	/**
	 * 외부연동(전자계약) SSO Token
	 * @param request
	 * @return
	 */
	public APIResponse ExtToken(Map<String, Object> paramMap);

	/**
	 * 외부연동(전자계약) SSO 정보
	 * @param request
	 * @return
	 */
	public Map<String, Object> ExtSSO(Map<String, Object> paramMap);

	/**
	 * 외부연동(전자계약) SSO 정보
	 * @param request
	 * @return
	 */
	public Map<String, Object> ExtSSOInfo(Map<String, Object> paramMap);

	/**
	 * 외부연동(전자계약) SSO 정보
	 * @param request
	 * @return
	 */
	public Map<String, Object> SWLinkInfo(Map<String, Object> paramMap);

	/**
	 * 외부연동(전자계약) SSO 정보
	 * @param request
	 * @return
	 */
	public Map<String, Object> ExtErpInfo(Map<String, Object> paramMap);

	public APIResponse getExPortletInfo(Map<String, Object> paramMap, HttpServletRequest request);

}
