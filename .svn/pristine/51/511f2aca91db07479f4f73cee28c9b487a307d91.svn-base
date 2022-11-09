package neos.cmm.erp.sso.service.impl;

import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import neos.cmm.erp.sso.service.ErpService;

@Service("ErpService")
public class ErpServiceImpl implements ErpService{
	
	@Resource(name="ErpManageDAO")
	private ErpManageDAO erpManageDAO; 
	
	
	@Override
	public Map<String, Object> selectEmpInfo(Map<String, Object> paramMap) {	
		
		return erpManageDAO.selectLinkMenuInfo(paramMap);
		
	}
	
	@Override
	public Map<String, Object> selectLinkMenuInfo(Map<String, Object> paramMap) {	
		
		return erpManageDAO.selectLinkMenuInfo(paramMap);
		
	}

}
