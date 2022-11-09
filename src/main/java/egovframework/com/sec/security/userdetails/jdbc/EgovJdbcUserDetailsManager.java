package egovframework.com.sec.security.userdetails.jdbc;

import java.lang.reflect.Constructor;
import java.lang.reflect.InvocationTargetException;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

import javax.annotation.Resource;
import javax.sql.DataSource;

import neos.cmm.db.CommonSqlDAO;

import org.apache.log4j.Logger;
import org.springframework.context.ApplicationContextException;
import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.SqlParameter;
import org.springframework.jdbc.object.MappingSqlQuery;
import org.springframework.security.GrantedAuthority;
import org.springframework.security.GrantedAuthorityImpl;
import org.springframework.security.context.SecurityContextHolder;
import org.springframework.security.userdetails.UsernameNotFoundException;
import org.springframework.security.userdetails.hierarchicalroles.RoleHierarchy;
import org.springframework.security.userdetails.jdbc.JdbcUserDetailsManager;

import cloud.CloudConnetInfo;
import bizbox.orgchart.service.vo.LoginVO;
import egovframework.com.cmm.service.Globals;
import egovframework.com.sec.security.userdetails.EgovUserDetails;
import egovframework.rte.fdl.string.EgovObjectUtil;

/**
 * JdbcUserDetailsManager 클래스 재정의
 * 
 * @author sjyoon
 * @since 2009.06.01
 * @version 1.0
 * @see
 *
 * <pre>
 * << 개정이력(Modification Information) >>
 *   
 *   수정일      수정자           수정내용
 *  -------    -------------    ----------------------
 *   2009.03.10  sjyoon    최초 생성
 *
 * </pre>
 * branch
 */

public class EgovJdbcUserDetailsManager extends JdbcUserDetailsManager {
	
    private EgovUsersByUsernameMapping usersByUsernameMapping;

    private String mapClass;
    private RoleHierarchy roleHierarchy = null;
    
    private String usersByUsernameQueryOracle;
    private String authoritiesByUsernameQueryOracle;
    
    
    @Resource(name = "commonSql")
	private CommonSqlDAO commonSql;	
    
    /**
     * 사용자 테이블의 쿼리 조회 컬럼과 세션에서 사용할 사용자 VO와 메핑 할 클래스를 지정한다.
     * @param mapClass String
     */
    public void setMapClass(String mapClass) {
    	this.mapClass = mapClass;
    }
    
    /**
     * Role Hierarchy를 지원한다.
     * (org.springframework.security.userdetails.hierarchicalroles.RoleHierarchyImpl)
     * @param roleHierarchy RoleHierarchy
     */
    public void setRoleHierarchy(RoleHierarchy roleHierarchy) {
    	this.roleHierarchy = roleHierarchy;
    }
    
    /*
     * (non-Javadoc)
     * @see org.springframework.security.userdetails.jdbc.JdbcUserDetailsManager#initDao()
     */
    @Override
    protected void initDao() throws ApplicationContextException {
    	super.initDao();

    	try {
    		initMappingSqlQueries();
    	} catch (ClassNotFoundException e) {
    		logger.error("EgovJdbcUserDetailsManager.initDao.ClassNotFoundException : " + e.toString(), e);
    	} catch (NoSuchMethodException e) {
    		logger.error("EgovJdbcUserDetailsManager.initDao.NoSuchMethodException : " + e.toString(), e);
    	} catch (InstantiationException e) {
    		logger.error("EgovJdbcUserDetailsManager.initDao.InstantiationException : " + e.toString(), e);
    	} catch (IllegalAccessException e) {
    		logger.error("EgovJdbcUserDetailsManager.initDao.IllegalAccessException : " + e.toString(), e);
    	} catch (InvocationTargetException e) {
    		logger.error("EgovJdbcUserDetailsManager.initDao.InvocationTargetException : " + e.toString(), e);
    	} catch (Exception e) {
    		logger.error("EgovJdbcUserDetailsManager.initDao.Exception : " + e.toString(), e);
    	}

    }
    
	/**
	 * jdbc-user-service의 usersByUsernameQuery 사용자조회 쿼리와
	 * authoritiesByUsernameQuery 권한조회 쿼리를 이용하여 정보를 저장한다.
	 */
	private void initMappingSqlQueries()
		throws InvocationTargetException, IllegalAccessException, InstantiationException, NoSuchMethodException, ClassNotFoundException, Exception {
		
	    if(Globals.DB_TYPE.toUpperCase().equals("ORACLE")){
            //KOFIA
            setUsersByUsernameQuery(getUsersByUsernameQueryOracle());
            setAuthoritiesByUsernameQuery(getAuthoritiesByUsernameQueryOracle());
        }else{
            //OTHER
            setUsersByUsernameQuery(getUsersByUsernameQuery());
            setAuthoritiesByUsernameQuery(getAuthoritiesByUsernameQuery());
        }
	    
		Class <?> clazz = EgovObjectUtil.loadClass(this.mapClass);
		Constructor <?> constructor = null ;
		Object [] params =  null ;

		constructor = clazz.getConstructor(new Class []{DataSource.class, String.class});
		params = new Object []{getDataSource(), getUsersByUsernameQuery()};
		
		this.usersByUsernameMapping = (EgovUsersByUsernameMapping) constructor.newInstance(params);
    }

    /**
	 * JdbcDaoImpl 클래스의 loadUsersByUsername 메소드 재정의
	 * 사용자명(또는 ID)로 EgovUserDetails의 정보를 조회하여 리스트 형식으로 저장한다.
	 */
	@SuppressWarnings("unchecked")
	@Override
	protected List<String> loadUsersByUsername(String username) {
		List<String> list = null ;
			list =  usersByUsernameMapping.execute(username);
		return list ;
        
    }

	/**
	 * JdbcDaoImpl 클래스의 loadUsersByUsername 메소드 재정의
	 * 사용자명(또는 ID)로 EgovUserDetails의 정보를 조회한다.
	 * @param username String
	 * @return EgovUserDetails
	 * @throws UsernameNotFoundException
	 * @throws DataAccessException
	 */
	@SuppressWarnings("unchecked")
	@Override
	public EgovUserDetails loadUserByUsername(String username) throws UsernameNotFoundException, DataAccessException {

		Map<String, Object> para = new HashMap<String, Object>();
		
		String[] spParam = username.split("\\$");
		para.put("userSe", spParam[0]);
		para.put("compSeq", spParam[1]);
		para.put("deptSeq", spParam[2]);
		para.put("groupSeq", spParam[3]);
		para.put("springSecu", spParam[4] + spParam[0]);
		para.put("clientIp", spParam[5]);
		para.put("compAccessDomain", spParam[6]);
		
		Logger.getLogger( CloudConnetInfo.class ).debug( "login para : " + para );
		
		Map<String, Object> egovUserMp = (Map<String, Object>) commonSql.select("loginDAO.EgovSpringSecurityAction", para);
	
		if(egovUserMp == null){
			
			Logger.getLogger( CloudConnetInfo.class ).debug( "egovUserMp : null");
			
			throw new UsernameNotFoundException(
                  messages.getMessage("JdbcDaoImpl.notFound", new Object[]{username}, "Username {0} not found"), username);
		}

        Set<String> dbAuthsSet = new HashSet<String>();
        LoginVO  egovUserVO = new LoginVO();
        
        setEgovUserVO(egovUserVO, egovUserMp);
        
        List authList = new ArrayList();
        
        List<Map<String, Object>> authMp = new ArrayList<Map<String, Object>>();

    	para.put("username", egovUserVO.getGroupSeq() + egovUserVO.getId());
    	para.put("deptSeq", egovUserVO.getOrgnztId());
    	authMp = commonSql.list("loginDAO.authoritiesByUsernameQuery", para);
        
        for(Map<String, Object> mp : authMp){
        	authList.add(new GrantedAuthorityImpl(mp.get("userId")+""));
        }
        
        if (authList != null) {
        	dbAuthsSet.addAll(authList);
        }

        List<String> dbAuths = new ArrayList<String>(dbAuthsSet);
        
        addCustomAuthorities(egovUserVO.getGroupSeq() + egovUserVO.getId(), dbAuths);

        if (dbAuths.size() == 0) {
            throw new UsernameNotFoundException(
                    messages.getMessage("EgovJdbcUserDetailsManager.noAuthority",
                            new Object[] {username}, "User {0} has no GrantedAuthority"), username);
		}

        GrantedAuthority[] arrayAuths = (GrantedAuthority[]) dbAuths.toArray(new GrantedAuthority[dbAuths.size()]);

        
        // RoleHierarchyImpl 에서 저장한 Role Hierarchy 정보가 저장된다.
        GrantedAuthority[] authorities = roleHierarchy.getReachableGrantedAuthorities(arrayAuths);
        
        // JdbcDaoImpl 클래스의 createUserDetails 메소드 재정의
        return new EgovUserDetails(egovUserVO.getGroupSeq() + egovUserVO.getId(), egovUserVO.getPasswd(), true, 
                true, true, true, authorities, egovUserVO);
    }

	private void setEgovUserVO(LoginVO egovUserVO, Map<String, Object> egovUserMp) {
		egovUserVO.setId(egovUserMp.get("userId") + "");
		egovUserVO.setPasswd(egovUserMp.get("password") + "");
		egovUserVO.setName(egovUserMp.get("userNm") + "");
		egovUserVO.setEmail(egovUserMp.get("userEmail") + "");
		egovUserVO.setUserSe(egovUserMp.get("userSe") + "");
		egovUserVO.setOrgnztId(egovUserMp.get("orgnztId") + "");
		egovUserVO.setUniqId(egovUserMp.get("esntlId") + "");
		egovUserVO.setOrgnztNm(egovUserMp.get("orgnztNm") + "");
		egovUserVO.setClassCode(egovUserMp.get("classCode") + "");
		egovUserVO.setPositionCode(egovUserMp.get("positionCode") + "");
		egovUserVO.setClassNm(egovUserMp.get("classNm") + "");
		egovUserVO.setPositionNm(egovUserMp.get("positionNm") + "");
		egovUserVO.setOrganId(egovUserMp.get("organId") + "");
		egovUserVO.setOrganNm(egovUserMp.get("organNm") + "");
		egovUserVO.setAuthorCode(egovUserMp.get("authorCode") + "");
		egovUserVO.setErpEmpCd(egovUserMp.get("erpEmpCd") + "");
		egovUserVO.setErpEmpNm(egovUserMp.get("erpEmpNm") + "");
		egovUserVO.setErpCoCd(egovUserMp.get("erpCoCd") + "");
		egovUserVO.setLangCode(egovUserMp.get("langCode") + "");
		egovUserVO.setGroupSeq(egovUserMp.get("groupSeq") + "");
		egovUserVO.setCompSeq(egovUserMp.get("compSeq") + "");
		egovUserVO.setBizSeq(egovUserMp.get("bizSeq") + "");
		egovUserVO.setPicFileId(egovUserMp.get("picFileId") + "");
		egovUserVO.setDept_seq(egovUserMp.get("deptSeq") + "");
		egovUserVO.setEmailDomain(egovUserMp.get("emailDomain") + "");
		egovUserVO.setEaType(egovUserMp.get("eaType") + "");
		egovUserVO.setErpBizCd(egovUserMp.get("erpBizCd") + "");
		egovUserVO.setErpDeptCd(egovUserMp.get("erpDeptCd") + "");
		egovUserVO.setLast_login_date((Date) egovUserMp.get("lastLoginDate"));
		egovUserVO.setLicenseCheckYn(egovUserMp.get("licenseCheckYn") + "");
		egovUserVO.setPasswdChangeDate(egovUserMp.get("passwdChangeDate") + "");
		egovUserVO.setLastLoginDateTime(egovUserMp.get("lastLoginDateTime") + "");
		egovUserVO.setPasswdStatusCode(egovUserMp.get("passwdStatusCode") + "");
		egovUserVO.setOrgnztPath(egovUserMp.get("orgnztPath") + "");
		egovUserVO.setUrl(egovUserMp.get("url") + "");
		egovUserVO.setIp(egovUserMp.get("ip") + "");
		egovUserVO.setAccess_ip(egovUserMp.get("accessIp") + "");
	}

	/**
	 * 인증된 사용자 이름으로 사용자정보(EgovUserDetails)를 가져온다. 
	 * @return EgovUserDetails
	 * @throws UsernameNotFoundException
	 * @throws DataAccessException
	 */
	public EgovUserDetails getAuthenticatedUser() throws UsernameNotFoundException, DataAccessException {
		return loadUserByUsername(SecurityContextHolder.getContext().getAuthentication().getName());
    }

	public void setUsersByUsernameQueryOracle(String usersByUsernameQueryOracle){
	    this.usersByUsernameQueryOracle = usersByUsernameQueryOracle;
	}
	
	public String getUsersByUsernameQueryOracle(){
	    return this.usersByUsernameQueryOracle;
	}
	
	public void setAuthoritiesByUsernameQueryOracle(String authoritiesByUsernameQueryOracle){
	    this.authoritiesByUsernameQueryOracle = authoritiesByUsernameQueryOracle;
	}
	           
	public String getAuthoritiesByUsernameQueryOracle(){
	    return this.authoritiesByUsernameQueryOracle;
	}
	    
	private class AuthoritiesByUsernameMapping extends MappingSqlQuery {
	    protected AuthoritiesByUsernameMapping(DataSource ds) {
	        super(ds , getAuthoritiesByUsernameQuery());
	        declareParameter(new SqlParameter(Types.VARCHAR));
	        compile();
	    }

	    protected Object mapRow(ResultSet rs, int rownum) throws SQLException {
	        String roleName = rs.getString(1);
	        GrantedAuthorityImpl authority = new GrantedAuthorityImpl(roleName);

	        return authority;
	    }
	}
}
