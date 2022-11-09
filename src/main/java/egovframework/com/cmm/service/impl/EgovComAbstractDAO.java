package egovframework.com.cmm.service.impl;

import java.lang.reflect.Field;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import javax.annotation.Resource;
import javax.servlet.ServletContext;
import javax.servlet.http.HttpServletRequest;
import org.apache.log4j.Logger;
import org.springframework.web.context.WebApplicationContext;
import org.springframework.web.servlet.support.RequestContextUtils;
import com.ibatis.sqlmap.client.SqlMapClient;
import bizbox.orgchart.service.vo.LoginVO;
import cloud.CloudConnetInfo;
import egovframework.com.cmm.service.Globals;
import egovframework.com.cmm.util.EgovUserDetailsHelper;
import egovframework.com.utl.fcc.service.EgovStringUtil;
import egovframework.rte.psl.dataaccess.EgovAbstractDAO;
import egovframework.rte.psl.dataaccess.util.EgovMap;
import egovframework.rte.ptl.mvc.tags.ui.pagination.DefaultPaginationManager;
import egovframework.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;
import egovframework.rte.ptl.mvc.tags.ui.pagination.PaginationManager;
import egovframework.rte.ptl.mvc.tags.ui.pagination.PaginationRenderer;

public abstract class EgovComAbstractDAO extends EgovAbstractDAO {

	@Resource ( name = "egov.sqlMapClient" )
	public void setSuperSqlMapClient ( SqlMapClient sqlMapClient ) {
		super.setSuperSqlMapClient( sqlMapClient );
	}

	public String sqlSelectResultExcpetion ( Object result ) {
		Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated( );
		String sqlSelectResult = "";
		if ( result == null ) {
			sqlSelectResult = "이 select sql은 결과값을 가져오지 않습니다.";
		}
		if ( !isAuthenticated ) {
			sqlSelectResult = "로그인 정보가 없습니다.";
		}
		return sqlSelectResult;
	}

	public Map<String, Object> listOfPaging ( HttpServletRequest request, String queryID, Map<String, Object> paramMap, PaginationInfo paginationInfo ) {
		return listOfPaging( request, queryID, "", paramMap, paginationInfo );
	}

	@SuppressWarnings ( { "rawtypes", "unchecked" } )
	public Map<String, Object> listOfPaging ( HttpServletRequest request, String queryID, String prefixName, Map<String, Object> paramMap, PaginationInfo paginationInfo ) {
		Map<String, Object> resultMap = new HashMap<String, Object>( );
		
		int startNum = paginationInfo.getFirstRecordIndex( ) + 1;
		int endNum = paginationInfo.getLastRecordIndex( );
		paramMap.put( "startNum", startNum );
		paramMap.put( "endNum", endNum );
		List list = this.list( queryID, paramMap );
		int totalCount = 0;
		if ( list != null && !list.isEmpty( ) ) {
			Map<String, Object> map = null;
			Object temp = null;
			temp = list.get( 0 );
			if ( temp == null ) {
				return null;
			}
			map = (Map<String, Object>) temp;
			temp = map.get( "TOTAL_COUNT" );
			if ( temp != null ) {
				totalCount = Integer.parseInt( temp.toString( ) );
			}
		}
		resultMap.put( prefixName + "list", list );
		ServletContext sc = request.getSession( ).getServletContext( );
		PaginationManager paginationManager = null;
		WebApplicationContext ctx = RequestContextUtils.getWebApplicationContext( request, sc );
		if ( ctx.containsBean( "paginationManager" ) ) {
			paginationManager = (PaginationManager) ctx.getBean( "paginationManager" );
		}
		else {
			//bean 정의가 없다면 DefaultPaginationManager를 사용. 빈설정이 없으면 기본 적인 페이징 리스트라도 보여주기 위함.
			paginationManager = new DefaultPaginationManager( );
		}
		paginationInfo.setTotalRecordCount( totalCount );
		int startCount = totalCount - ((paginationInfo.getCurrentPageNo( ) - 1) * paginationInfo.getPageSize( ));
		PaginationRenderer paginationRenderer = paginationManager.getRendererType( "image" );
		String naviHtml = paginationRenderer.renderPagination( paginationInfo, prefixName + "goPage" );
		resultMap.put( prefixName + "naviHtml", naviHtml );
		resultMap.put( prefixName + "startCount", startCount );
		resultMap.put( prefixName + "totalCount", totalCount );
		return resultMap;
	}

	@SuppressWarnings("rawtypes")
	public Map<String, Object> listOfPaging2 ( Map<String, Object> paramMap, PaginationInfo paginationInfo, String queryID, String prefixName ) {
		Map<String, Object> resultMap = new HashMap<String, Object>( );
		int currentPageNo = paginationInfo.getCurrentPageNo( );
		int pageSize = paginationInfo.getPageSize( );
		
		if (currentPageNo > Integer.MAX_VALUE || currentPageNo < Integer.MIN_VALUE) {//정수형 오버플로우 방지 적용
	        throw new IllegalArgumentException("out of bound");
	    }
		
		if (pageSize > Integer.MAX_VALUE || pageSize < Integer.MIN_VALUE) {//정수형 오버플로우 방지 적용
	        throw new IllegalArgumentException("out of bound");
	    }
		
		int startNum = ((currentPageNo - 1) * pageSize) + 1;
		int endNum = startNum + pageSize - 1;
		paramMap.put( "startNum", startNum );
		paramMap.put( "endNum", endNum );
		int totalCount = 0;
		List list = null;
		
		if ( Globals.DB_TYPE.toLowerCase( ).equals( "mysql" ) || Globals.DB_TYPE.toLowerCase( ).equals( "mariadb" ) ) {
			startNum = ((currentPageNo - 1) * pageSize);
			endNum = pageSize;
			paramMap.put( "startNum", startNum );
			paramMap.put( "endNum", endNum );
			totalCount = EgovStringUtil.zeroConvert( this.select( queryID + "_TOTALCOUNT", paramMap ) + "" );
			if ( totalCount >= 0 ) {
				list = this.list( queryID, paramMap );
			}
		}
		else {
		
			totalCount = EgovStringUtil.zeroConvert( this.select( queryID + "_TOTALCOUNT", paramMap ) + "" );
			if ( totalCount >= 0 ) {
				list = this.list( queryID, paramMap );
			}			
		}
		
		paginationInfo.setTotalRecordCount( totalCount );
		resultMap.put( prefixName + "list", list );
		int startCount = totalCount - ((currentPageNo - 1) * pageSize);
		resultMap.put( prefixName + "startCount", startCount );
		resultMap.put( prefixName + "totalCount", totalCount );
		return resultMap;
	}

	public Map<String, Object> listOfPaging2 ( Map<String, Object> paramMap, PaginationInfo paginationInfo, String queryID ) {
		return listOfPaging2( paramMap, paginationInfo, queryID, "" );
	}

	public Map<String, Object> listForMobile ( String queryID, Map<String, Object> paramMap ) {
		Map<String, Object> resultMap = new HashMap<String, Object>( );
		@SuppressWarnings ( "rawtypes" )
		List list = this.list( queryID, paramMap );

		if ( list != null && !list.isEmpty( ) ) {
			Object temp = null;
			temp = list.get( 0 );
			if ( temp == null ) {
				return null;
			}
		}
		resultMap.put( "list", list );
		return resultMap;
	}

	@SuppressWarnings ( { "unchecked", "rawtypes" } )
	public List list ( String queryId, Object p ) {
		return super.list( queryId, appendDbNameToParam(queryId, p) );
	}

	@Override
	public Object select ( String queryId, Object p ) {
		return super.select( queryId, appendDbNameToParam(queryId, p) );
	}

	@Override
	public int update ( String queryId, Object p ) {
		return super.update( queryId, appendDbNameToParam(queryId, p) );
	}

	@Override
	public Object insert ( String queryId, Object p ) {
		return super.insert( queryId, appendDbNameToParam(queryId, p) );
	}

	@Override
	public int delete ( String queryId, Object p ) {
		return super.delete( queryId, appendDbNameToParam(queryId, p) );
	}
	
	@SuppressWarnings("unchecked")
	private Object appendDbNameToParam(String queryId, Object param) {
		
		if ( param != null && param.getClass( ).getName( ).equals( "egovframework.rte.psl.dataaccess.util.EgovMap" ) ) {
			EgovMap queryParam = (EgovMap) param;
			Map<String, Object> custInfo = getRedisCustInfo(getGroupSeqForEgovMap(queryParam));
			
			if(custInfo == null) {
				Logger.getLogger( CloudConnetInfo.class ).error( "queryId : " + queryId + " > custInfo is null");
			}
			
			queryParam.put( "DB_NEOS", custInfo.get( "DB_NEOS" ) );
			queryParam.put( "DB_MOBILE", custInfo.get( "DB_MOBILE" ) );
			queryParam.put( "DB_EDMS", custInfo.get( "DB_EDMS" ) );			
				
			Logger.getLogger( CloudConnetInfo.class ).debug( "queryId : " + queryId );
			Logger.getLogger( CloudConnetInfo.class ).debug( "queryParam : " + queryParam.toString() );
			
			return queryParam;
			
		}else {
			Map<String, Object> queryParam = new HashMap<String, Object>( );
			
			if ( param != null && (param.getClass( ).getName( ).equals( "java.util.HashMap" ) || param.getClass( ).getName( ).equals( "java.util.Map" ) || param.getClass( ).getName( ).equals( "java.util.LinkedHashMap" ) )) {
				queryParam = (Map<String, Object>) param;
			}else if( param != null && !param.getClass( ).getName( ).equals( "java.lang.String" ) && !param.getClass( ).getName( ).equals( "java.lang.Integer" )) {
				queryParam = objectToMap(param);
			}
			
			Map<String, Object> custInfo = getRedisCustInfo(getGroupSeqForMap(queryParam));
			
			if(custInfo == null) {
				Logger.getLogger( CloudConnetInfo.class ).error( "queryId : " + queryId + " > custInfo is null");
				
				if(!CloudConnetInfo.getBuildType().equals("cloud")) {
					custInfo = new HashMap<String, Object>( );
					custInfo.put( "DB_NEOS", "neos." );
					custInfo.put( "DB_MOBILE", "mobile." );
					custInfo.put( "DB_EDMS", "edms." );								
				}
			}
			
			queryParam.put( "DB_NEOS", custInfo.get( "DB_NEOS" ) );
			queryParam.put( "DB_MOBILE", custInfo.get( "DB_MOBILE" ) );
			queryParam.put( "DB_EDMS", custInfo.get( "DB_EDMS" ) );			
				
			Logger.getLogger( CloudConnetInfo.class ).debug( "queryId : " + queryId );
			Logger.getLogger( CloudConnetInfo.class ).debug( "queryParam : " + queryParam.toString() );
			
			return queryParam;
		}
	}

	/**
	 * DB정보를 Redis에서 조회
	 */	
	private Map<String, Object> getRedisCustInfo ( String groupSeq ) {
		
		if(groupSeq.equals("")) {
			LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser( );
			
			if(loginVO != null) {
				groupSeq = loginVO.getGroupSeq();
			}
		}
		
		return CloudConnetInfo.getParamMap( groupSeq );
	}
	
	/**
	 * VO를 map으로 형변환
	 */
	private Map<String, Object> objectToMap ( Object p ) {
		Map<String, Object> result = new HashMap<>( );
		try {
			/* 필드 찾기 */
			Field[] field = p.getClass( ).getDeclaredFields( );
			for ( Field item : field ) {
				item.setAccessible( true );
				String itemText = item.get(p) == null  ? "" : item.get( p ).toString( );
				result.put( item.getName( ), itemText );
			}
		}
		catch ( Exception e ) {
			result = new HashMap<>( );
		}
		return result;
	}

	/**
	 * egovMap에서 그룹시퀀스 찾기
	 */
	private String getGroupSeqForEgovMap ( EgovMap map ) {
		
		String groupSeq = "";
		
		if(map.containsKey("groupSeq")){
			groupSeq = map.get("groupSeq") + "";
		}
		else if(map.containsKey("GROUP_SEQ")){
			groupSeq = map.get("GROUP_SEQ") + "";
		}
		else if(map.containsKey("group_seq")){
			groupSeq = map.get("group_seq") + "";
		}
		else if(map.containsKey("groupseq")){
			groupSeq = map.get("groupseq") + "";
		}
		
		return groupSeq;
	}

	/**
	 * 맵에서 그룹시퀀스 찾기
	 */
	private String getGroupSeqForMap ( Map<String, Object> map ) {
		
		String groupSeq = "";
		
		if(map.containsKey("groupSeq")){
			groupSeq = map.get("groupSeq") + "";
		}
		else if(map.containsKey("GROUP_SEQ")){
			groupSeq = map.get("GROUP_SEQ") + "";
		}
		else if(map.containsKey("group_seq")){
			groupSeq = map.get("group_seq") + "";
		}
		else if(map.containsKey("groupseq")){
			groupSeq = map.get("groupseq") + "";
		}
		
		return groupSeq;
	}

}
