package neos.cmm.systemx.holiday.service.impl;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import neos.cmm.db.CommonSqlDAO;
import neos.cmm.systemx.holiday.service.HolidayManageService;

@Service("HolidayManageService")
public class HolidayManageServiceImpl implements HolidayManageService{

	@Resource(name = "commonSql")
	private CommonSqlDAO commonSql;
	
	@Override
	public List<Map<String, Object>> selectHolidayList(Map<String, Object> params) {
		return commonSql.list("HolidayManage.selectHolidayList", params);
	}

	@Override
	public Map<String, Object> getHolidayInfo(Map<String, Object> params) {
		return (Map<String, Object>) commonSql.select("HolidayManage.getHolidayInfo", params);
	}

	@Override
	public void saveHolidayInfo(Map<String, Object> params) {
		commonSql.insert("HolidayManage.saveHolidayInfo", params);
	}

	@Override
	public void delHolidayInfo(Map<String, Object> params) {
		commonSql.delete("HolidayManage.delHolidayInfo", params);
	}

	@Override
	public void updateHolidayInfo(Map<String, Object> params) {
		commonSql.insert("HolidayManage.updateHolidayInfo", params);
	}

	@Override
	public List<Map<String, Object>> selectLegalHolidayList(Map<String, Object> params) {
		return commonSql.list("HolidayManage.selectLegalHolidayList", params);
	}

	@Override
	public int getHolidayCnt(Map<String, Object> params) {
		return (int) commonSql.select("HolidayManage.getHolidayCnt", params);
	}

	@Override
	public int getHolidayInfoCnt(Map<String, Object> params) {
		return (int) commonSql.select("HolidayManage.getHolidayInfoCnt", params);
	}

	@Override
	public int getLegalHolidayCnt(Map<String, Object> paramMap) {
		return (int) commonSql.select("HolidayManage.getLegalHolidayCnt", paramMap);
	}

	@Override
	public List<Map<String, Object>> getHolidayList(Map<String, Object> paramMap) {
		return commonSql.list("HolidayManage.getHolidayList", paramMap);
	}

	@Override
	public String checkLegalDayYn(Map<String, Object> para) {
		return (String) commonSql.select("HolidayManage.checkLegalDayYn", para);
	}
	
	@Override
	public List<Map<String, Object>> getAnniversaryList(Map<String, Object> paramMap) {
		return commonSql.list("HolidayManage.getAnniversaryList", paramMap);
	}
}
