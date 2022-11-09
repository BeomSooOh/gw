package neos.cmm.erp.dao.ebp;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import neos.cmm.db.AbstractInterlockSqlSession;
import neos.cmm.db.CommonSqlDAO;

public class EbpOrgchartDAOImpl extends AbstractInterlockSqlSession {

    @Resource(name = "commonSql")
    private CommonSqlDAO commonSql;

    public EbpOrgchartDAOImpl(){

    }

    public EbpOrgchartDAOImpl(Map<String, Object> erpDbInfo) {
        setSqlSession(erpDbInfo);
    }

    @Override
    public void setSqlSession(Map<String, Object> params) {
        String dbType = params.get("databaseType")+"";
        String url = params.get("url")+"";
        String username = params.get("userid")+"";
        String password = params.get("password")+"";
        String pakage = "neos.cmm.erp.sqlmap";
        String erpType = params.get("erpType")+"";
        pakage += "."+erpType;

        createSqlSession(dbType, url, username, password, pakage);

    }

    public List<Map<String, Object>> selectList(Map<String, Object> params) {
        String queryid = (String) params.get("queryid");
        return selectList(queryid, params);
    }

    public Map<String, Object> selectOne(Map<String, Object> params) {
        String queryid = (String) params.get("queryid");
        return selectOne(queryid, params);
    }

    public int update(Map<String, Object> params) {
        String queryid = (String) params.get("queryid");
        return update(queryid, params);
    }
}
