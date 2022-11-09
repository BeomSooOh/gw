package neos.cmm.erp.convert;

import java.util.Map;

import egovframework.com.utl.fcc.service.EgovStringUtil;
import neos.cmm.erp.convert.impl.ErpGerpDataConverterImpl;
import neos.cmm.erp.convert.impl.ErpICubeDataConverterImpl;
import neos.cmm.erp.convert.impl.ErpIuDataConverterImpl;

public class ErpDataConvertorCreator {
	public static ErpDataConverter newInstance(Map<String,Object> params) {
		String erpType = (String)params.get("erpType");
		
		if(EgovStringUtil.isEmpty(erpType)) {
			return null;
		}
		
		ErpDataConverter c = null;
		
		if(erpType.equals("iu")) {
			c = new ErpIuDataConverterImpl();
		} else if (erpType.equals("icube")) {
			c = new ErpICubeDataConverterImpl();
		} else if (erpType.equals("gerp")) {
			c = new ErpGerpDataConverterImpl();
		}
		
		return c;
	}
}
