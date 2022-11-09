package neos.cmm.systemx.dutyPosition.sercive;

import java.util.List;
import java.util.Map;

public interface DutyPositionManageService {
	
	/**
	 * 회사 직급직책 조회
	 * @param paramMap
	 * @return
	 */
	public List<Map<String, Object>> getCompDutyPositionList(Map<String, Object> paramMap);
	
	/**
	 * 직급직책 리스트 (관리)
	 * @param paramMap
	 * @return
	 */
	public List<Map<String, Object>> getDutyPositionList(Map<String, Object> paramMap);

	/**
	 * 직급직책 정보
	 * @param paramMap
	 * @return
	 */
	public Map<String, Object> getDutyPositionInfo(Map<String, Object> paramMap);

	/**
	 * 직급직책 다국어 정보
	 * @param paramMap
	 * @return
	 */
	public Map<String, Object> getDutyPositionSeqLangInfo(Map<String, Object> paramMap);
	
	/**
	 * 직급직책 삭제
	 * @param paramMap
	 * @return 
	 */
	public Map<String, Object> deleteDutyPosition(Map<String, Object> paramMap) throws Exception;

	/**
	 * 직급직책 저장
	 * @param paramMap
	 * @return
	 */
	public Map<String, Object> insertDutyPosition(Map<String, Object> paramMap);

    /**
     * 코드 중복체크 
     * @param paramMap
     * @return
     * @throws Exception
     */
	public Integer getDutyPositionSeqCheck(Map<String, Object> paramMap) throws Exception;

	
	
}
