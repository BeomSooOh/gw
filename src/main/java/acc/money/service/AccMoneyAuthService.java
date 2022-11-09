package acc.money.service;

import java.util.List;
import java.util.Map;

import neos.cmm.vo.ConnectionVO;
import bizbox.orgchart.service.vo.LoginVO;

public interface AccMoneyAuthService {

	/* 조회 */
	/* 조회 - 부서별 권한자 조회 */
	List<Map<String, Object>> DeptAuthEmpListInfoSelect(LoginVO loginVO,
			Map<String, Object> params) throws Exception;

	/* 조회 - 권한목록 조회 */
	List<Map<String, Object>> AuthListInfoSelect(LoginVO loginVO,
			Map<String, Object> params) throws Exception;
	
	/* 조회 - 권한목록 검색 조회 */
	List<Map<String, Object>> AuthListInfoSearchSelect(LoginVO loginVO,
			Map<String, Object> params) throws Exception;


	/* 조회 - 권한대상자 조회 */
	List<Map<String, Object>> AuthEmpListInfoSelect(LoginVO loginVO,
			Map<String, Object> params) throws Exception;

	/* 조회 - 메뉴목록 조회 */
	List<Map<String, Object>> AuthMenuListInfoSelect(LoginVO loginVO,
			Map<String, Object> params) throws Exception;

	/* 조회 - ERP 조직도 정보 조회 */
	List<Map<String, Object>> ErpDeptListInfoSelect(LoginVO loginVO,
			Map<String, Object> params, ConnectionVO conVo) throws Exception;

	/* 조회 - GW ERP 정보 조회 */
	List<Map<String, Object>> GWErpInfoSelect(LoginVO loginVO,
			Map<String, Object> params) throws Exception;

	/* 조회 - 권한 맵핑 (erp 조직도, 메뉴) 조회 */
	List<Map<String, Object>> AuthMappingData(LoginVO loginVO,
			Map<String, Object> params) throws Exception;

	/* 조회 - 권한 사용자 조회 */
	List<Map<String, Object>> AccPopAuthUserSelect(LoginVO loginVO,
			Map<String, Object> params) throws Exception;
	
	/* 조회 - 조직도 검색 조회 */
	List<Map<String, Object>> AuthEmpListInfoSearchSelect(LoginVO loginVO,
			Map<String, Object> params) throws Exception;
	
	/* 조회 - GW erp 맵핑된 회사 가져오기 */
	List<Map<String, Object>> AccGWCompSelect(LoginVO loginVO,
			Map<String, Object> params) throws Exception;
	
	/* 수정 */
	/*수정 - 권한 erp 조직도 수정*/
	Map<String, Object> AuthMenuDeptInfoUpdate(LoginVO loginVO,
			Map<String, Object> params) throws Exception;
	
	/* 생성 */
	/* 생성 - 권한 생성 */
	Map<String, Object> AuthInfoInsert(LoginVO loginVO,
			Map<String, Object> params) throws Exception;

	/* 생성 - 권한 대상자 생성 */
	Map<String, Object> AuthEmpInfoInsert(LoginVO loginVO,
			Map<String, Object> params) throws Exception;

	/* 생성 - 권한 메뉴, ERP 조직도 생성 */
	Map<String, Object> AuthMenuDeptInfoInsert(LoginVO loginVO,
			Map<String, Object> params) throws Exception;

	/* 생성 - 사용자 지정 권한 */
	Map<String, Object> AuthUserInsert(LoginVO loginVO,
			Map<String, Object> params) throws Exception;
	
	/* 삭제 */
	/* 삭제 - 권한 대상자 삭제 */
	Map<String, Object> AuthEmpInfoDelete(LoginVO loginVO,
			Map<String, Object> params) throws Exception;

	/* 삭제 - 권한 메뉴, ERP 조직도 삭제 */
	Map<String, Object> AuthMenuDeptInfoDelete(LoginVO loginVO,
			Map<String, Object> params) throws Exception;
	
	/* 삭제 - 유저 권한 삭제 */
	Map<String, Object> AccUserAuthDelete(LoginVO loginVO,
			Map<String, Object> params) throws Exception;
}
