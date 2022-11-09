/**
  * @FileName : FormatUtil.java
  * @Project : BizboxA_gw
  * @변경이력 :
  * @프로그램 설명 :
  */
package neos.cmm.common.util;

import java.util.Iterator;
import java.util.Map;
import java.util.Set;

import org.apache.commons.lang.StringUtils;

import bizbox.orgchart.service.vo.LoginVO;
import egovframework.com.cmm.util.EgovUserDetailsHelper;
import net.sf.json.JSONObject;


/**
 *   * @FileName : FormatUtil.java
 *   * @Project : BizboxA_gw
 *   * @변경이력 :
 *   * @프로그램 설명 :
 *   
 */
public class FormatUtil {

	/* 로그인 사용자 Map 변경 ( 개발자 정의 ) */
	public static Map<String, Object> getLoginVo ( Map<String, Object> param, String[] keys ) {
		/* Login 사용자 정보 조회 */
		LoginVO loginVo = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser( );
		/* 반환값 정의 */
		for ( String key : keys ) {
			if ( FormatUtil.getString( key ).equals( "groupSeq" ) ) {
				param.put( "groupSeq", FormatUtil.getString( loginVo.getGroupSeq( ) ) ); /* 그룹 시퀀스 */
			}
			else if ( FormatUtil.getString( key ).equals( "compSeq" ) ) {
				param.put( "compSeq", FormatUtil.getString( loginVo.getCompSeq( ) ) ); /* 회사 시퀀스 */
			}
			else if ( FormatUtil.getString( key ).equals( "bizSeq" ) ) {
				param.put( "bizSeq", FormatUtil.getString( loginVo.getBizSeq( ) ) ); /* 사업장 시퀀스 */
			}
			else if ( FormatUtil.getString( key ).equals( "deptSeq" ) ) {
				param.put( "deptSeq", FormatUtil.getString( loginVo.getOrgnztId( ) ) ); /* 부서 시퀀스 */
			}
			else if ( FormatUtil.getString( key ).equals( "empSeq" ) ) {
				param.put( "empSeq", FormatUtil.getString( loginVo.getUniqId( ) ) ); /* 사원 시퀀스 */
			}
			else if ( FormatUtil.getString( key ).equals( "userSe" ) ) {
				param.put( "userSe", FormatUtil.getString( loginVo.getUserSe( ) ) ); /* 사용자 권한 */
			}
			else if ( FormatUtil.getString( key ).equals( "langCode" ) ) {
				param.put( "langCode", FormatUtil.getString( loginVo.getLangCode( ) ) ); /* 사용자 사용 언어 코드 */
			}
		}
		/* 반환 처리 */
		return param;
	}

	/* 로그인 사용자 Map 반환 */
	public static Map<String, Object> getLoginVo ( Map<String, Object> param ) {
		/* Login 사용자 정보 조회 */
		LoginVO loginVo = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser( );
		/* 반환값 정의 */
		param.put( "groupSeq", FormatUtil.getString( loginVo.getGroupSeq( ) ) ); /* 그룹 시퀀스 */
		param.put( "compSeq", FormatUtil.getString( loginVo.getCompSeq( ) ) ); /* 회사 시퀀스 */
		param.put( "bizSeq", FormatUtil.getString( loginVo.getBizSeq( ) ) ); /* 사업장 시퀀스 */
		param.put( "deptSeq", FormatUtil.getString( loginVo.getOrgnztId( ) ) ); /* 부서 시퀀스 */
		param.put( "empSeq", FormatUtil.getString( loginVo.getUniqId( ) ) ); /* 사원 시퀀스 */
		param.put( "userSe", FormatUtil.getString( loginVo.getUserSe( ) ) ); /* 사용자 권한 */
		param.put( "langCode", FormatUtil.getString( loginVo.getLangCode( ) ) ); /* 사용자 사용 언어 코드 */
		/* 반환 처리 */
		return param;
	}

	/* String 반환 */
	public static String getString ( Object params ) {
		String result = "";
		if ( params != null ) {
			result = (StringUtils.isEmpty( String.valueOf( params ) ) ? "" : String.valueOf( params ));
		}
		return result;
	}

	/* API 파라미터 기본 구조 */
	public static JSONObject getApiParamBase ( String tId, String pId, LoginVO loginVo, Map<String, Object> subParam ) {
		/* 필수값 확인 */
		if ( loginVo == null ) {
			return null;
		}
		/* 변수정의 */
		JSONObject apiParamBase = new JSONObject( );
		JSONObject header = new JSONObject( );
		JSONObject body = new JSONObject( );
		JSONObject companyInfo = new JSONObject( );
		/* set header */
		header.put( "groupSeq", loginVo.getGroupSeq( ) );
		header.put( "empSeq", loginVo.getUniqId( ) );
		header.put( "tId", tId );
		header.put( "pId", pId );
		/* set companyInfo */
		companyInfo.put( "compSeq", loginVo.getOrganId( ) );
		companyInfo.put( "bizSeq", loginVo.getBizSeq( ) );
		companyInfo.put( "deptSeq", loginVo.getOrgnztId( ) );
		companyInfo.put( "empSeq", loginVo.getUniqId( ) );
		companyInfo.put( "langCode", loginVo.getLangCode( ) );
		companyInfo.put( "emailAddr", loginVo.getEmail( ) );
		companyInfo.put( "emailDomain", loginVo.getEmailDomain( ) );
		/* set body */
		body.put( "companyInfo", companyInfo );
		Set<String> key = subParam.keySet( );
		for ( Iterator<String> iterator = key.iterator( ); iterator.hasNext( ); ) {
			String keyName = (String) iterator.next( );
			body.put( keyName, subParam.get( keyName ) );
		}
		/* set apiParamBase */
		apiParamBase.put( "header", header );
		apiParamBase.put( "body", body );
		return apiParamBase;
	}
}
