package neos.cmm.systemx.wehagoAdapter.service;

import java.io.UnsupportedEncodingException;
import java.security.InvalidAlgorithmParameterException;
import java.security.InvalidKeyException;
import java.security.NoSuchAlgorithmException;
import java.util.Map;

import javax.crypto.BadPaddingException;
import javax.crypto.IllegalBlockSizeException;
import javax.crypto.NoSuchPaddingException;
import javax.servlet.http.HttpServletRequest;

import api.common.model.APIResponse2;
import egovframework.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;

public interface wehagoAdapterService {

	// 위하고 가입 관련
	// 위하고 가입 도메인 생성
	public Map<String, Object> getWehagoJoinUrl(Map<String, Object> params) throws UnsupportedEncodingException, InvalidKeyException, NoSuchAlgorithmException, NoSuchPaddingException, InvalidAlgorithmParameterException, IllegalBlockSizeException, BadPaddingException;
	// 위하고 회사 가입 완료 체크용
	public Map<String, Object> getWehagoJoinState(Map<String, Object> params);
	// 위하고 회사 가입 완료 콜백(hrExtInterlockController 호출)
	public APIResponse2 wehagoJoinCallback(HttpServletRequest servletRequest) throws InvalidKeyException, UnsupportedEncodingException, NoSuchAlgorithmException, NoSuchPaddingException, InvalidAlgorithmParameterException, IllegalBlockSizeException, BadPaddingException, Exception;
	public String wehagoGetServerToken(String wehagoServer, String accessTokenIn, String hashKeyIn, String deviceIdIn, String softwareKeyIn, String cno);
	
	// 조직도 연동관련
	public Map<String, Object> wehagoApiCall(String groupSeq, String compSeq, String apiUrl, String method, Map<String, Object> params);
	// 직급 직책
	public Map<String, Object> wehagoInsertDutyPositionAll(String groupSeq, String compSeq);
	public Map<String, Object> wehagoInsertDutyPositionOneSync(String groupSeq, String compSeq, String dpSeq, String dpType, String syncTp);
	// 조직도
	public Map<String, Object> wehagoInsertOrgChart(String groupSeq, String compSeq, Map<String, Object> params);
	public Map<String, Object> wehagoInsertOrgChartAll(String groupSeq, String compSeq);
	public Map<String, Object> wehagoInsertOrgChartOneSync(String groupSeq, String compSeq, String deptSeq, String syncTp) throws Exception;
	// 사용자
	public Map<String, Object> wehagoInsertEmpAll(String groupSeq, String compSeq);
	public Map<String, Object> wehagoInsertEmpOneSync(String groupSeq, String compSeq, String empSeq, String syncTp) throws Exception;

	// 하기건들은 검토중

	public Map<String, Object> wehagoGetGroupInfo(String groupSeq, String compSeq);
	public Map<String, Object> wehagoUpdateGroupInfo(String groupSeq, String compSeq, Map<String, Object> params);

	public Map<String, Object> wehagoSyncDetailList(Map<String, Object> params, PaginationInfo paginationInfo);
	public Map<String, Object> wehagoGetOrgChart(String groupSeq, String compSeq);
	public Map<String, Object> wehagoGetEmp(String groupSeq, String compSeq, String wehagoKey);

	public Map<String, Object> wehagoSendMail(String groupSeq, String compSeq);

	public Map<String, Object> wehagoApiTest(String groupSeq, String compSeq, Map<String, Object> params);

}