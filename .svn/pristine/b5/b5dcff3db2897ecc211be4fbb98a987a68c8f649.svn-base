package neos.cmm.systemx.group.service;

import java.util.List;
import java.util.Map;

public interface GroupManageService {
	
	/**
	 * 그룹 기본정보 저장
	 * @param params
	 * @return
	 */
	public Object insertGroup(Map<String,Object> params);
	
	/**
	 * 그룹업로드경로 리스트 조회
	 * @param params
	 * @return
	 */
	public List<Map<String,Object>> selectGroupPathList(Map<String,Object> params);
	
	public void setMasterSecu(Map<String,Object> params);
	
	public Map<String,Object> selectGroupPath(Map<String,Object> params);

	/**
	 * 그룹업로드경로 설정 저장
	 * 가용용량, 1회업로드파일 외 저장하지 않음.
	 * @param paramMap
	 */
	public void updateGroupPath(Map<String, Object> paramMap);

	/**
	 * 그룹 컨테이너 정보 리스트
	 * @param params
	 * @return
	 */
	public List<Map<String, Object>> selectGroupContainerList(Map<String, Object> params);

	/**
	 * 그룹 컨테이너 정보 저장
	 * @param cParams
	 */
	public void insertGroupContainer(Map<String, Object> cParams);

	
	/**
	 * 그룹 접속정보 조회
	 * @param cParams
	 */
	public Map<String, Object> selectGroupIpInfo(Map<String, Object> params);

	
	/**
	 * 로그인 이미지 설정(타입) - A타입  or B타입
	 * @param cParams
	 */
	public void setLoginImgType(Map<String, Object> paramMap);

	
	/**
	 * Web 로그인로고 이미지 가져오기.
	 * @param cParams
	 */
	public List<Map<String, Object>> getLogoImgFile(Map<String, Object> paramMap);

	
	/**
	 * Web 로그인배너 이미지 가져오기.
	 * @param cParams
	 */
	public List<Map<String, Object>> getBgImgFile(Map<String, Object> paramMap);

	
	
	/**
	 * pc메신저 로그인로고 이미지 가져오기.
	 * @param cParams
	 */
	public List<Map<String, Object>> getMsgLoginLogoImgFile(Map<String, Object> paramMap);

	
	/**
	 * pc메신저 메인 상단 로고 이미지 가져오기.
	 * @param cParams
	 */
	public List<Map<String, Object>> getMsgMainTopImgFile(Map<String, Object> paramMap);

	
	/**
	 * Phone 이미지 가져오기.
	 * @param cParams
	 */
	public List<Map<String, Object>> getPhoneImgFile(Map<String, Object> paramMap);

	
	/**
	 * 메인 상단로고 이미지 가져오기.
	 * @param cParams
	 */
	public List<Map<String, Object>> getMainTopLogoImgFile(Map<String, Object> paramMap);

	
	/**
	 * 메인 하단로고 이미지 가져오기.
	 * @param cParams
	 */
	public List<Map<String, Object>> getMainFootImgFile(Map<String, Object> paramMap);

	
	
	/**
	 * orgImg 텍스트 가져오기.
	 * @param cParams
	 */
	public Map<String, Object> getOrgDisplayText(Map<String, Object> paramMap);

	
	/**
	 * 그룹정보 조회
	 * @param cParams
	 */
	public Map<String, Object> getGroupInfo(Map<String, Object> paramMap);

	
	
	/**
	 * 그룹업로드 설정값 가져오기.
	 * @param cParams
	 */
	public Map<String, Object> selectPathInfo(Map<String, Object> param);

	/**
	 * 그룹 리스트 가져오기
	 * @return
	 */
	public List<Map<String, Object>> getGroupList(Map<String, Object> param);
	
	/**
	 * 그룹 저장
	 * @param param
	 * @return
	 */
	public void groupSave(Map<String, Object> param);
	
	/**
	 * 그룹 시퀀스 가져오기
	 * @return
	 */
	public Map<String, Object> selectGroupSeq();
	
	/**
	 * 그룹 저장
	 * @param param
	 * @return
	 */
	public void groupDel(Map<String, Object> param);
	
	/**
	 * 회사 그룹핑
	 * @param param
	 */
	public void groupingCompAdd(Map<String, Object> param);
	
	/**
	 * 회사 그룹핑 삭제
	 * @param param
	 */
	public void groupingCompDel(Map<String, Object> param);
	
	/**
	 * 회사 그룹 정보 가져오기(그룹핑-수정시)
	 * @param param
	 * @return
	 */
	public List<Map<String, Object>> groupInfo(Map<String, Object> param);
	
	/**
	 * 회사 그룹 정보 수정
	 * @param param
	 */
	public void groupInfoUpdate(Map<String, Object> param);

	public String selectGroupLangCode(Map<String, Object> param);
	
	public void updateBgType(Map<String, Object> param);
}
