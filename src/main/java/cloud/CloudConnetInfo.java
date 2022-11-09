package cloud;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;

import bizbox.orgchart.util.JedisClient;
import neos.cmm.util.BizboxAProperties;
import neos.cmm.util.DecryptUtil;


public class CloudConnetInfo {

	/* 변수 선언 */
	private static JedisClient jedisClient = null;

	/* 프로퍼티 정의 */
	private final class properitesName {
		static final String IPADDRESS = "BizboxA.redis.ip";
		static final String PORT = "BizboxA.redis.port";
		static final String PASSWORD = "BizboxA.redis.password";
		static final String DB_NEOS_NAME = "BizboxA.DB_NEOS_NAME";
		static final String DB_EDMS_NAME = "BizboxA.DB_EDMS_NAME";
		static final String DB_MOBILE_NAME = "BizboxA.DB_MOBILE_NAME";
		static final String BUILD_TYPE = "BizboxA.build.type";
		static final String SENTINEL_HOSTS = "BizboxA.redis.sentinel.client.hosts";
		static final String MASTER_NAME = "BizboxA.redis.master.name";
	}

	private final class basicDatabaseName {
		static final String HOST = "127.0.0.1";
		static final int PORT = 6379;
		static final String PASSWORD = "1234";
	}

	/* 클라우드 정보 가져오는 객체 생성 */
	public static void getCloudInstanse ( ) {
		if ( jedisClient == null ) {
			String host = "";
			int port = 6379;
			String password = "";
			String sentinelHosts = "";
			String masterName = "";
			
			
			if ( BizboxAProperties.getProperty( properitesName.IPADDRESS ).equals( "99" ) ) {
				host = basicDatabaseName.HOST;
			}
			else {
				host = BizboxAProperties.getProperty( properitesName.IPADDRESS );
			}
			if ( BizboxAProperties.getProperty( properitesName.PORT ).equals( "99" ) ) {
				port = basicDatabaseName.PORT;
			}
			else {
				port = Integer.parseInt( BizboxAProperties.getProperty( properitesName.PORT ) );
			}
			if ( BizboxAProperties.getProperty( properitesName.PASSWORD ).equals( "99" ) ) {
				password = basicDatabaseName.PASSWORD;
			}
			else {
				password = DecryptUtil.decrypt(BizboxAProperties.getProperty( properitesName.PASSWORD ));
			}
			if ( !BizboxAProperties.getProperty( properitesName.SENTINEL_HOSTS ).equals( "99" ) ) {
				sentinelHosts = BizboxAProperties.getProperty( properitesName.SENTINEL_HOSTS );
			}
			if ( !BizboxAProperties.getProperty( properitesName.MASTER_NAME ).equals( "99" ) ) {
				masterName = BizboxAProperties.getProperty( properitesName.MASTER_NAME );
			}
			
			jedisClient = JedisClient.getInstance( host, port, password, sentinelHosts, masterName );
		}
	}

	/* 클라우드 정보 가져오는 객체 반환 */
	public static JedisClient getJedisClient ( ) {
		if ( jedisClient == null ) {
			String host = "";
			int port = 6379;
			String password = "";
			String sentinelHosts = "";
			String masterName = "";
			
			if ( BizboxAProperties.getProperty( properitesName.IPADDRESS ).equals( "99" ) ) {
				host = basicDatabaseName.HOST;
			}
			else {
				host = BizboxAProperties.getProperty( properitesName.IPADDRESS );
			}
			if ( BizboxAProperties.getProperty( properitesName.PORT ).equals( "99" ) ) {
				port = basicDatabaseName.PORT;
			}
			else {
				port = Integer.parseInt( BizboxAProperties.getProperty( properitesName.PORT ) );
			}
			if ( BizboxAProperties.getProperty( properitesName.PASSWORD ).equals( "99" ) ) {
				password = basicDatabaseName.PASSWORD;
			}
			else {
				password = DecryptUtil.decrypt(BizboxAProperties.getProperty( properitesName.PASSWORD ));
			}
			if ( !BizboxAProperties.getProperty( properitesName.SENTINEL_HOSTS ).equals( "99" ) ) {
				sentinelHosts = BizboxAProperties.getProperty( properitesName.SENTINEL_HOSTS );
			}
			if ( !BizboxAProperties.getProperty( properitesName.MASTER_NAME ).equals( "99" ) ) {
				masterName = BizboxAProperties.getProperty( properitesName.MASTER_NAME );
			}
			
			Logger.getLogger( CloudConnetInfo.class ).debug( "JedisClient Parameter : " + host + ", " + port + ", " + password );
			jedisClient = JedisClient.getInstance( host, port, password, sentinelHosts, masterName );
		}
		return jedisClient;
	}

	/* 클라우드 형 DB 정보 가져오기 */
	public static Map<String, Object> getParamMap ( String groupSeq ) {
		
		Map<String, Object> databaseName = new HashMap<String, Object>( );
		
		//NEOS DB명 프로퍼티 설정값 로드
		if ( !BizboxAProperties.getProperty( properitesName.DB_NEOS_NAME ).equals( "99" )) {
			databaseName.put("DB_NEOS", BizboxAProperties.getProperty( properitesName.DB_NEOS_NAME ) + ".");
			
			if ( !BizboxAProperties.getProperty( properitesName.DB_EDMS_NAME ).equals( "99" )) {
				databaseName.put("DB_EDMS", BizboxAProperties.getProperty( properitesName.DB_EDMS_NAME ) + ".");
			}else {
				databaseName.put( "DB_EDMS", "edms." );
			}
			
			if ( !BizboxAProperties.getProperty( properitesName.DB_MOBILE_NAME ).equals( "99" )) {
				databaseName.put("DB_MOBILE", BizboxAProperties.getProperty( properitesName.DB_MOBILE_NAME ) + ".");
			}else {
				databaseName.put( "DB_MOBILE", "mobile." );
			}			
			
		}else {
			
			if ( jedisClient == null ) {
				try {
					Logger.getLogger( CloudConnetInfo.class ).debug( "BizboxACloudInstanseCreate start" );
					CloudConnetInfo.getCloudInstanse( );
					Logger.getLogger( CloudConnetInfo.class ).debug( "BizboxACloudInstanseCreate end" );
				}
				catch ( Exception e ) {
					Logger.getLogger( CloudConnetInfo.class ).error( "BizboxACloudInstanseError : " + e.getMessage( ) );
				}
			}

			try {
				/* 클라우드 형 DB 정보 가져오기 */
				databaseName = jedisClient.getParamMap( groupSeq );
				
				if ( (databaseName.get( "DB_NEOS" ) == null ? "" : databaseName.get( "DB_NEOS" )).equals( "" ) ) {
					throw new Exception( "Not exist DB_NEOS" );
				}
				else if ( (databaseName.get( "DB_MOBILE" ) == null ? "" : databaseName.get( "DB_MOBILE" )).equals( "" ) ) {
					throw new Exception( "Not exist DB_MOBILE" );
				}
				else if ( (databaseName.get( "DB_EDMS" ) == null ? "" : databaseName.get( "DB_EDMS" )).equals( "" ) ) {
					throw new Exception( "Not exist DB_EDMS" );
				}
				else {
					databaseName.put( "DB_NEOS", ((String) databaseName.get( "DB_NEOS" )) + "." );
					databaseName.put( "DB_MOBILE", ((String) databaseName.get( "DB_MOBILE" )) + "." );
					databaseName.put( "DB_EDMS", ((String) databaseName.get( "DB_EDMS" )) + "." );
				}
			}
			catch ( Exception ex ) {
				Logger.getLogger( CloudConnetInfo.class ).error( "jedisClient.getParamMap : groupSeq > " + groupSeq + " > " + ex.getMessage( ) );
			}
		}
		
		return databaseName;
	}

	public static Map<String, Object> getParamMapByDomain ( String domain ) throws Exception {

		Map<String, Object> databaseGroupSeq = new HashMap<String, Object>( );
		if ( jedisClient == null ) {
			try {
				Logger.getLogger( CloudConnetInfo.class ).debug( "BizboxACloudInstanseCreate start" );
				CloudConnetInfo.getCloudInstanse( );
				Logger.getLogger( CloudConnetInfo.class ).debug( "BizboxACloudInstanseCreate end" );
			}
			catch ( Exception e ) {
				Logger.getLogger( CloudConnetInfo.class ).error( "BizboxACloudInstanseError : " + e.getMessage( ) );
			}
		}
		try {
			/* 클라우드 형 DB 정보 가져오기 */
			databaseGroupSeq = jedisClient.getParamMapByDomain( domain );
			if ( databaseGroupSeq == null || (databaseGroupSeq.get( "GROUP_SEQ" ) == null ? "" : databaseGroupSeq.get( "GROUP_SEQ" )).equals( "" ) ) {
				throw new Exception( "Not exist GROUP_SEQ" );
			}
			else {
				databaseGroupSeq.put( "groupSeq", ((String) databaseGroupSeq.get( "GROUP_SEQ" )) );
				databaseGroupSeq.put( "GROUP_SEQ", ((String) databaseGroupSeq.get( "GROUP_SEQ" )) );
				Logger.getLogger( CloudConnetInfo.class ).debug( "databaseGroupSeq : " + databaseGroupSeq );
			}
		}
		catch ( Exception ex ) {
			Logger.getLogger( CloudConnetInfo.class ).error( "getParamMapByDomain : " + domain );
			Logger.getLogger( CloudConnetInfo.class ).error( "Exception : " + ex.getMessage( ) );
			Map<String, Object> mp = new HashMap<String, Object>( );
			databaseGroupSeq = mp;
		}
		
		//NEOS DB명 프로퍼티 설정값 로드
		if ( !BizboxAProperties.getProperty( properitesName.DB_NEOS_NAME ).equals( "99" )) {
			databaseGroupSeq.put("DB_NEOS", BizboxAProperties.getProperty( properitesName.DB_NEOS_NAME ));
		}		
		
		return databaseGroupSeq;
	}

	public static String getBuildType ( ){
		
		if ( !BizboxAProperties.getProperty( properitesName.BUILD_TYPE ).equals( "99" )) {
			return BizboxAProperties.getProperty( properitesName.BUILD_TYPE );
		}
		
		String buildType = "";
		if ( jedisClient == null ) {
			try {
				CloudConnetInfo.getCloudInstanse( );
			}
			catch ( Exception e ) {
				Logger.getLogger( CloudConnetInfo.class ).error( "BizboxACloudInstanseError : " + e.getMessage( ) );
			}
		}
		try {
			/* 구축정보 가져오기 */
			buildType = jedisClient.getBuildType( );
		}
		catch ( Exception ex ) {
			Logger.getLogger( CloudConnetInfo.class ).error( "IGNORED: " + ex.getMessage( ) );
			buildType = "build";
		}
		return ((buildType == null || buildType.equals( "" )) ? "build" : buildType);
	}

	public static List<Map<String, String>> getDBInfoList ( ) throws Exception {
		List<Map<String, String>> dbInfoList = new ArrayList<Map<String, String>>( );
		if ( jedisClient == null ) {
			try {
				CloudConnetInfo.getCloudInstanse( );
			}
			catch ( Exception e ) {
				Logger.getLogger( CloudConnetInfo.class ).error( "BizboxACloudInstanseError : " + e.getMessage( ) );
			}
		}
		try {
			/* 구축정보 가져오기 */
			dbInfoList = jedisClient.getDBInfoList( );
		}
		catch ( Exception ex ) {
			Logger.getLogger( CloudConnetInfo.class ).error( "IGNORED: " + ex.getMessage( ) );
		}
		return dbInfoList;
	}

	public static Map<String, String> getCustInfo ( String groupSeq ) {
		Map<String, String> custInfo = new HashMap<String, String>( );
		if ( jedisClient == null ) {
			try {
				CloudConnetInfo.getCloudInstanse( );
			}
			catch ( Exception e ) {
				Logger.getLogger( CloudConnetInfo.class ).error( "BizboxACloudInstanseError : " + e.getMessage( ) );
			}
		}
		try {
			custInfo = jedisClient.getCustInfo( groupSeq );
		}
		catch ( Exception e ) {
			custInfo = new HashMap<String, String>( );
		}
		return custInfo;
	}
}
