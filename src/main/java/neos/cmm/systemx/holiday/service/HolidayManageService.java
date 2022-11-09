package neos.cmm.systemx.holiday.service;

import java.util.List;
import java.util.Map;

public interface HolidayManageService {

	List<Map<String, Object>> selectHolidayList(Map<String, Object> params);

	Map<String, Object> getHolidayInfo(Map<String, Object> params);

	void saveHolidayInfo(Map<String, Object> params);

	void delHolidayInfo(Map<String, Object> params);

	void updateHolidayInfo(Map<String, Object> params);

	List<Map<String, Object>> selectLegalHolidayList(Map<String, Object> params);

	int getHolidayCnt(Map<String, Object> params);

	int getHolidayInfoCnt(Map<String, Object> params);

	int getLegalHolidayCnt(Map<String, Object> paramMap);

	List<Map<String, Object>> getHolidayList(Map<String, Object> paramMap);

	String checkLegalDayYn(Map<String, Object> para);

	List<Map<String, Object>> getAnniversaryList(Map<String, Object> paramMap);
}
