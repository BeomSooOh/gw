package neos.cmm.systemx.comp.service.impl;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import bizbox.orgchart.service.vo.LoginVO;
import neos.cmm.systemx.comp.dao.ExCodeOrgERPiUDAO;
import neos.cmm.systemx.comp.service.ExCodeOrgService;
import neos.cmm.util.CommonUtil;
import neos.cmm.vo.ConnectionVO;


/**
 * <pre>
 * ex.code.org.service.impl
 * ExCodeOrgERPiUServiceImpl.java
 * </pre>
 * 
 * @Author : 김상겸
 * @Date : 2016. 5. 25.
 * @Version : 2016. 5. 25.
 *
 */
@Service("ExCodeOrgERPiUService")
public class ExCodeOrgERPiUServiceImpl implements ExCodeOrgService {
	
	@Resource(name = "ExCodeOrgERPiUDAO")
	private ExCodeOrgERPiUDAO exCodeOrgDAO;

	@Override
	public List<Map<String, Object>> getExCompList(Map<String, Object> param, LoginVO loginVO, ConnectionVO conVo) {
		List<Map<String, Object>> result = null;

		try {
			result = exCodeOrgDAO.getExCompList(param, conVo);
		}
		catch (Exception e) {
			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
		}

		return result;
	}

	@Override
	public List<Map<String, Object>> getExEmpList(Map<String, Object> params, LoginVO loginVO, ConnectionVO conVo) {
		List<Map<String, Object>> result = null;

		try {
			result = exCodeOrgDAO.getExEmpList(params, conVo);
		}
		catch (Exception e) {
			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
		}

		return result;
	}

	@Override
	public Map<String, Object> GetFiGwDocInfo(Map<String, Object> params, LoginVO loginVO, ConnectionVO conVo) {
		Map<String, Object> result = null;

		try {
			result = exCodeOrgDAO.GetFiGwDocInfo(params, conVo);
		}
		catch (Exception e) {
			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
		}

		return result;
	}


}
