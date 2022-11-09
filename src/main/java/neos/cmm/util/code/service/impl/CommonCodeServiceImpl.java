package neos.cmm.util.code.service.impl;

import java.util.HashMap;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import neos.cmm.util.CommonUtil;
import neos.cmm.util.code.service.CommonCodeService;

@Service("CommonCodeService")
public class CommonCodeServiceImpl implements CommonCodeService{

	@Resource(name="CommonCodeDAO")
	CommonCodeDAO commonCodeDAO;
	
	@Override
	public Object getCommonDetailCodeFlag1(String code, String detailCode, String field) {
		Map<String, Object> p = new HashMap<String,Object>();
		p.put("code", code);
		p.put("detailCode", detailCode);
		Map<String, String> codeInfo;
		try {
			codeInfo = commonCodeDAO.selectCommonCode(p);
			if (codeInfo != null) {
				return codeInfo.get(field);
			}
		} catch (Exception e) {
			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
		}
		
		return null;
	}

	@Override
	public void updateCommonDetail(String code, String detailCode, String flag1, String flag2, String editSeq) {
		Map<String, Object> p = new HashMap<String,Object>();
		p.put("code", code);
		p.put("detailCode", detailCode);
		p.put("flag1", flag1);
		p.put("flag2", flag2);
		p.put("flag2", flag2);
		p.put("editSeq", editSeq);
		try {
			commonCodeDAO.updateCmmnCode(p);
		} catch (Exception e) {
			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
		}
		
	}
	
	

}
