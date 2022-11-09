package neos.cmm.menu.service;

import java.io.UnsupportedEncodingException;
import java.security.InvalidAlgorithmParameterException;
import java.security.InvalidKeyException;
import java.security.NoSuchAlgorithmException;
import java.util.List;
import java.util.Map;

import javax.crypto.BadPaddingException;
import javax.crypto.IllegalBlockSizeException;
import javax.crypto.NoSuchPaddingException;

import bizbox.orgchart.service.vo.LoginVO;

public interface MenuManageService {
    
	/**
	 * 하위메뉴 카운트 가져오기
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
    public int getChildCnt(Map<String, Object> paramMap)throws Exception;
    
    /**
     * 메뉴 정보의 상세 내용을 가져온다.
     * @param paramMap
     * @return
     * @throws Exception
     */
    public Map<String, Object> menuInfoView(Map<String, Object> paramMap) throws Exception;    

    /**
     * 메뉴 정보를 등록한다.
     * @param paramMap
     * @return
     * @throws Exception
     */
    public String insertMenu(Map<String, Object> paramMap) throws Exception;

    /**
     * 메뉴 정보를 수정한다.
     * 
     * @param MenuInfo
     * @return String
     * @throws Exception
     */
    public String updateMenu(Map<String, Object> paramMap) throws Exception;

    /**
     * 메뉴 정보를 삭제한다.
     * @param paramMap
     * @return
     * @throws Exception
     */
    public String deleteMenu(Map<String, Object> paramMap) throws Exception;

    /**
     * Bizbox A 사용자 menu 트리구조 리스트 조회
     * @param paramMap
     * @return
     */
    public List<Map<String,Object>> selectMenuTreeList(Map<String,Object> paramMap);
    
    /**
     * bizbox A 사용자 Top menu에서 url이 없을시 하위 첫번째 메뉴정보 조회
     * @param paramMap
     * @return
     */
    public Map<String, Object> selectFirstMenuInfo(Map<String,Object> paramMap);

    /**
     * BizboxA 관리자  menu 트리구조 리스트 조회
     * @param params
     * @return
     */
	public List<Map<String, Object>> selectAdminMenuTreeListAuth(
			Map<String, Object> params);

	/**
	 * bizbox A 관리자 Top menu에서 url이 없을시 하위 첫번째 메뉴정보 조회
	 * @param params
	 * @return
	 */
	public Map<String, Object> selectFirstAdminMenuInfo(Map<String, Object> params);

	public List<Map<String, Object>> selectMenuListOfUrl(
			Map<String, Object> params);

	public List<Map<String, Object>> selectMenuAdminListOfUrl(Map<String, Object> params);
	
	
	public List<Map<String, Object>> getOuterMenuList(Map<String,Object> params);

	/**
	 * 
	 * @param menuList
	 * @param boardList
	 * @return
	 */
	public List<Map<String, Object>> getSiteMapList(List<Map<String, Object>> menuList,
			List<Map<String, Object>> boardList);

	public List<Map<String, Object>> selectMenuListOfMenuNo(Map<String, Object> params);

	/**
	 * 개인결재함 리스트
	 * @param params
	 * @return
	 */
	public List<Map<String, Object>> selectEaEmpMenuTreeList(Map<String, Object> params);
	
	/**
     * Bizbox A 사용자 menu JStree 트리구조 리스트 조회
     * @param paramMap
     * @return
     */
	public List<Map<String, Object>> selectMenuJsTreeList(Map<String, Object> params);
	
	/**
     * Bizbox A 관리자 menu JStree 트리구조 리스트 조회
     * @param paramMap
     * @return
     */
	public List<Map<String, Object>> selectAdminMenuJsTreeList(Map<String, Object> params);
	
	/**
     * Bizbox A 관리자 menu JStree 개인결재함 트리구조 리스트 조회
     * @param paramMap
     * @return
     */
	public List<Map<String, Object>> selectEAPrivateMenuTreeList(Map<String, Object> params);
	
	/**
     * Bizbox A 외부 컨테이너 메뉴 리스트 (게시판, 프로젝트 , 문서) 등등
     * @param paramMap
     * @return
     */
	public List<Map<String, Object>> callApiMenuList(Map<String,Object> params,String apiUrl ,String[] fields );

	
	/**
     * Bizbox A 메뉴정보관리 상위메뉴 Depth가져오기 (comboBox)
     * @param paramMap
     * @return
     */
	public List<Map<String, Object>> selectMenuComboBoxList(Map<String, Object> paramMap);
	
	/**
     * Bizbox A 메뉴정보관리 하위메뉴 Depth가져오기 (comboBox)
     * @param paramMap
     * @return
     */
	public List<Map<String, Object>> selectMenuComboBoxSubList(Map<String, Object> paramMap);	

	/**
     * Bizbox A 메뉴정보관리 사용범위 (comboBox)
     * @param paramMap
     * @return
     */
	public List<Map<String, Object>> selsetMenuOpenCompList(Map<String, Object> paramMap);
	
	
	
	
	/**
	 * 시스템설정 메뉴 권한 체크 (임시적으로 시스템설정 메뉴만 사용)
	 * 시스템설정 메뉴는 관리자,마스터 전용 메뉴이기때문에  loginVO.getUserSe() == "USER" 인 경우는 무조건 false반환
	 * 사용자가 직접 해당 메뉴 url을 치고 접속하는 보안이슈로 추가된 부분.
	 */	
	public boolean checkIsAuthMenu(Map<String, Object> paramMap, LoginVO loginVO);

	
	/**
	 * 메뉴 이용기록
	 */
	public String insertMenuHistory(Map<String, Object> paramMap);
	
	public Map<String,Object> getMenuSSOLinkInfo(Map<String, Object> params, LoginVO loginVO) throws InvalidKeyException, UnsupportedEncodingException, NoSuchAlgorithmException, NoSuchPaddingException, InvalidAlgorithmParameterException, IllegalBlockSizeException, BadPaddingException;
	
	public boolean checkMenuAuth(LoginVO loginVO, String urlPath);
	
}
