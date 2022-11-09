package neos.cmm.erp.dao;

import javax.annotation.Resource;

import com.ibatis.sqlmap.client.SqlMapClient;

import egovframework.rte.psl.dataaccess.EgovAbstractDAO;

public abstract class ErpICubeDefaultDAO extends EgovAbstractDAO{
/*	@Resource(name="erpICube.sqlMapClient")
*/	@Resource(name="egov.sqlMapClient")
	public void setSuperSqlMapClient(SqlMapClient sqlMapClient) {
        super.setSuperSqlMapClient(sqlMapClient);
    }
}
