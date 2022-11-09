package neos.cmm.systemx.item.service;

import java.util.List;
import java.util.Map;

import bizbox.orgchart.service.vo.LoginVO;

public interface ItemManageService {
	
	/* 조회 */
	/* 조회 - 항목목록 */
	List<Map<String, Object>> ItemListSelect(LoginVO loginVO,
			Map<String, Object> params) throws Exception;
	
	/* 조회 - 항목목록 세부사항 */
	Map<String, Object> ItemCodeDetailSelect(LoginVO loginVO,
			Map<String, Object> params) throws Exception;
	
	/* 조회 - 사용자정의 코드관리 조회 */
	List<Map<String, Object>> ItemUserDefineCodeListSelect(LoginVO loginVO,
			Map<String, Object> params) throws Exception;
	
	/* 조회 - 외부코드 조회 */
	List<Map<String, Object>> ItemExternalCodeListSelect(LoginVO loginVO,
			Map<String, Object> params) throws Exception;
	
	/* 조회 - 그룹코드 상세코드 목록 조회 */
	List<Map<String, Object>> ItemCodeGroupDetailCodeSelect(LoginVO loginVO,
			Map<String, Object> params) throws Exception;

	/* 조회 - 상세코드 데이터 조회 */
	Map<String, Object> ItemDetailCodeSelect(LoginVO loginVO,
			Map<String, Object> params) throws Exception;
	
	/* 조회 - 외부코드 상세 데이터 조회 */
	Map<String, Object> ItemExternalCodeDetailSelect(LoginVO loginVO,
			Map<String, Object> params) throws Exception;
	
	/* 조회 - 코드 중복확인 */
	Map<String, Object> checkItemCodeSeq(LoginVO loginVO,
			Map<String, Object> params) throws Exception;
	
	/* 조회 - 상세코드 중복확인 */
	Map<String, Object> checkDetailCodeSeq(LoginVO loginVO,
			Map<String, Object> params) throws Exception;
	
	/* 조회 - 외부코드 중복확인 */
	Map<String, Object> checkExternalCodeSeq(LoginVO loginVO,
			Map<String, Object> params) throws Exception;
	
	/* 조회 - 크룹코드 중복 확인*/
	Map<String, Object> checkGroupCodeSeq(LoginVO loginVO,
			Map<String, Object> params) throws Exception;
	
	/* 생성 */
	/* 생성 - 항목생성 */
	Map<String, Object> ItemCodeInsert(LoginVO loginVO,
			Map<String, Object> params) throws Exception;
	
	/* 생성 - 코드 그룹 생성 */
	Map<String, Object> ItemCodeGroupInsert(LoginVO loginVO,
			Map<String, Object> params) throws Exception;
	
	/* 생성 - 코드 그룹 상세코드 생성 */
	Map<String, Object> ItemCodeGroupDetailCodeInsert(LoginVO loginVO,
			Map<String, Object> params) throws Exception;
	
	/* 생성 - 외부코드 생성 */
	Map<String, Object> ItemExternalCodeInsert(LoginVO loginVO,
			Map<String, Object> params) throws Exception;
	
	
	/* 수정 */
	/* 수정 - 항목수정*/
	Map<String, Object> ItemCodeUpdate(LoginVO loginVO,
			Map<String, Object> params) throws Exception;
	
	/* 수정 - 상세 코드 수정*/
	Map<String, Object> ItemCodeGroupDetailCodeEdit(LoginVO loginVO,
			Map<String, Object> params) throws Exception;
	
	/* 수정 - 외부코드 상세 수정*/
	Map<String, Object> ItemExternalCodeEdit(LoginVO loginVO,
			Map<String, Object> params) throws Exception;
	
	/* 수정 - 그룹코드 수정*/
	Map<String, Object> ItemCodeGroupUpdate(LoginVO loginVO,
			Map<String, Object> params) throws Exception;
	
	/* 삭제 */
	/* 삭제 - 항목 삭제 */
	Map<String, Object> ItemCodeDelete(LoginVO loginVO,
			Map<String, Object> params) throws Exception;	
	
	/* 삭제 - 그룹코드 삭제 */
	Map<String, Object> ItemGroupCodeDelete(LoginVO loginVO,
			Map<String, Object> params) throws Exception;
	
	/* 삭제 - 외부코드 삭제 */
	Map<String, Object> ItemExternalCodeDelete(LoginVO loginVO,
			Map<String, Object> params) throws Exception;
	
	/* 삭제 - 상세코드 삭제 */
	Map<String, Object> ItemDetailCodeDelete(LoginVO loginVO,
			Map<String, Object> params) throws Exception;
	
	/* 기타(공통) */
	/* 외부코드 정보 가져오기 */
	Map<String, Object> getExternalCodeInfo(Map<String, Object> params) throws Exception;
	
	/* [조회] DB 커넥션 후 데이터 가져오기 */
	List<Map<String, Object>> getExternalCodeList(Map<String, Object> externalCodeInfo) throws Exception;

	/* [조회] 그룹 코드 상세 조회 */
	Map<String, Object> getCodeGrpInfo(Map<String, Object> params);
}
