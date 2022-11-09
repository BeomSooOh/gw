package main.service;

import java.util.List;
import java.util.Map;

import bizbox.orgchart.service.vo.LoginVO;
import main.web.PagingReturnObj;

public interface MainService {
	
	/**
	 * 사용자 구분에 따라 메인처리
	 * 메인화면 이동(사용자,관리자,마스터)
	 * 사용자, 관리자/마스터 css 설정등
	 * @param loginVo
	 * @param params 
	 * @return
	 */
	public Map<String,Object> userSeSetting(LoginVO loginVo, Map<String, Object> params);
	
	/**
	 * 마이메뉴설정 리스트 조회
	 * @param params
	 * @return
	 */
	
	public List<Map<String,Object>> getMyMenuList(Map<String,Object> params);

	/** 
	 * 마이메뉴설정 메뉴 저장
	 * @param paramList
	 */
	public void insertMyMenuList(Map<String, Object> param);

	/**
	 * 마이메뉴설정 삭제
	 * @param params
	 */
	public void deleteMyMenuList(Map<String, Object> params);

	/**
	 * check 확인
	 * 외부 게시판 메뉴 때문에 일일이 확인
	 * @param myMenuList
	 * @param m
	 * @return
	 */
	public Object isMyMenuCheck(List<Map<String, Object>> myMenuList, Map<String, Object> m);

	/**
	 * 메인 포틀릿(iframe) 정보 조회
	 * @param params
	 * @return
	 */
	public Map<String, Object> selectMainPortlet(Map<String, Object> params);

	/**
	 * 메인 포틀릿(iframe) 정보 조회 리스트
	 * @param params
	 * @return
	 */
	public List<Map<String, Object>> selectMainPortletList(Map<String, Object> params);

	/**
	 * 받은 알림 리스트 조회
	 * @param params
	 * @return
	 */
	public List<Map<String, Object>> selectAlertReceiverList(Map<String, Object> params);

	/**
	 * 알림 개수 조회
	 * @param params
	 * @return
	 */
	public Map<String, Object> selectAlertReceiverReadCnt(Map<String, Object> params);

	/**
	 * 알림 수신 체크
	 * @param params
	 * @return
	 */
	public int updateAlertReceiver(Map<String, Object> params);

	/**
	 * 관리자 권한 있는 여부 판단
	 * @param params
	 * @return
	 */
	public String selectAdminAuthCnt(Map<String, Object> params);

	public String selectMasterAuthCnt(Map<String, Object> params);
	/**
	 * 링크메뉴 상세정보
	 * @param params
	 * @return
	 */
	public Map<String, Object> selectLinkMenuInfo(Map<String, Object> params) throws Exception;
	
	public Map<String, Object> selectTokenInfo(Map<String, Object> params);
	
	public Map<String, Object> selectCustInfo(Map<String, Object> params);

	public Map<String, Object> testSQL(Map<String, Object> params);

	
	/**
	 * 알림 삭제버튼.
	 * @param params
	 * @return
	 */
	
	public void deleteAlert(Map<String, Object> params);

	public void deleteAlertReceiver(Map<String, Object> params);

	public void alertRemoveNew(Map<String, Object> params);
	
	public PagingReturnObj tsearchList(Map<String,String> params, String listType);
	
	public PagingReturnObj tsearchHrList(Map<String,String> params, String listType);

	public void mailAlertRemoveNew(Map<String, Object> params);

	public List<Map<String, Object>> getAlaramCompList(
			Map<String, Object> params);

	public Map<String,Object> getCompMailDomain(Map<String, Object> params);
	
	public String getDeptPathTotalSearch(Map<String, Object> params);
	
	public String getTotalSearchMailDomain(Map<String, String> params);
	
	public List<String> getTotalSearchMenuAuth(Map<String, String> params);
	
	public List<Map<String, Object>> getTopMenuList(LoginVO loginVO);
}
