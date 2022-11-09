package api.mail.service;

import org.apache.commons.lang.StringUtils;
import org.apache.log4j.Logger;

import bizbox.orgchart.service.vo.LoginVO;
import neos.cmm.util.HttpJsonUtil;
import net.sf.json.JSONObject;


/**
 *   * @FileName : ApiMailInterface.java
 *   * @Project : BizboxA_gw
 *   * @변경이력 :
 *   * @프로그램 설명 :
 *   
 */
public class ApiMailInterface {

	private final class _Key {

		static final String HEADER = "header";
		static final String BODY = "body";
		static final String COMPANYINFO = "companyInfo";
		static final String GROUPSEQ = "groupSeq";
		static final String COMPSEQ = "compSeq";
		static final String BIZSEQ = "bizSeq";
		static final String DEPTSEQ = "deptSeq";
		static final String EMPSEQ = "empSeq";
		static final String EMAILADDR = "emailAddr";
		static final String EMAILDOMAIN = "emailDomain";
		static final String ISEXTERNAL = "isExternal";
		static final String ISAPPROVAL = "isApproval";
		static final String PAGE = "page";
		static final String PAGESIZE = "pageSize";
		static final String SEEN = "seen";
		static final String FLAG = "flag";
		static final String SORT = "sort";
		static final String MAILTIME = "MAILTIME";
		static final String FALSE = "false";
		static final String TRUE = "true";
		static final String PID = "pId";
		static final String TID = "tId";
	}

	/* 공통사용 */
	private String _getStr ( Object o ) {
		String resulString = "";
		resulString = (resulString != null ? (StringUtils.isEmpty( String.valueOf( o ) ) ? "" : String.valueOf( o )) : "");
		return resulString;
	}

	/* parameter 생성 */
	private JSONObject _getCompanyInfo ( LoginVO loginVo ) {
		JSONObject jsonResult = new JSONObject( );
		jsonResult.put( _Key.COMPSEQ, loginVo.getCompSeq( ) );
		jsonResult.put( _Key.BIZSEQ, loginVo.getBizSeq( ) );
		jsonResult.put( _Key.DEPTSEQ, loginVo.getOrgnztId( ) );
		jsonResult.put( _Key.EMAILADDR, loginVo.getEmail( ) );
		jsonResult.put( _Key.EMAILDOMAIN, loginVo.getEmailDomain( ) );
		return jsonResult;
	}

	private JSONObject _getHeader ( LoginVO loginVo ) {
		JSONObject jsonResult = new JSONObject( );
		jsonResult.put( _Key.GROUPSEQ, this._getStr( loginVo.getGroupSeq( ) ) );
		jsonResult.put( _Key.EMPSEQ, this._getStr( loginVo.getUniqId( ) ) );
		jsonResult.put( _Key.TID, this._getStr( loginVo.getGroupSeq( ) ) + "-" + this._getStr( loginVo.getUniqId( ) ) );
		jsonResult.put( _Key.PID, this._getStr( loginVo.getGroupSeq( ) ) + "-" + this._getStr( loginVo.getUniqId( ) ) );
		return jsonResult;
	}

	private JSONObject _getBody ( LoginVO loginVo ) {
		JSONObject jsonResult = new JSONObject( );
		jsonResult.put( _Key.COMPANYINFO, this._getCompanyInfo( loginVo ) );
		return jsonResult;
	}

	private JSONObject _getBaseParm ( LoginVO loginVo ) {
		JSONObject jsonResult = new JSONObject( );
		jsonResult.put( _Key.HEADER, this._getHeader( loginVo ) );
		jsonResult.put( _Key.BODY, this._getBody( loginVo ) );
		return jsonResult;
	}

	/* execute */
	private JSONObject _setExecute ( String methods, String url, JSONObject param ) {
		return JSONObject.fromObject( HttpJsonUtil.execute( methods, url, param ) );
	}

	private void _setStatusCodeLog ( JSONObject resultParam, String mailDomain, String apiName ) {
		Logger.getLogger( ApiMailInterface.class ).error( "[" + apiName + "] " + mailDomain + apiName + " >> STATUSCODE[" + this._getStr( resultParam.get( "error" ) ) + "]" );
	}

	/**
	 * @Method Name : MailBoxCount ( http://wiki.duzon.com:8080/pages/viewpage.action?pageId=19689748 )
	 * @Method 설명 : 메일박스 사용량 조회
	 * @param loginVo
	 * @param mailDomain
	 *            : 메일 도메인 ( http://domain/main2/ )
	 * @param isExternal
	 *            : (boolean)true(외부메일) / (boolean)false(내부메일)
	 * @param isApproval
	 *            : (boolean)true(승인메일) / (boolean)boolean(미승인메일)
	 * @return : (JSONObject) {"resultCode": "0", resultMessage: "SUCCESS", "result": { "mailboxsize": 1, "mailboxmaxsize": 100, "mailboxPercent": 1, "approvalCnt": 0 }}
	 *         <br>
	 *         <br>mailboxsize : (long) 현재 박스 사용량
	 *         <br>mailboxmaxsize : (long) 할당된 박스 용량
	 *         <br>mailboxPercent : (long) 사용된 박스 %
	 *         <br>approvalCnt : (long) 승인 메일 count(isApproval 값이 true인 경우)
	 */
	public JSONObject MailBoxCount ( LoginVO loginVo, String mailDomain, boolean isExternal, boolean isApproval ) {
		/* 파라미터 및 반환 변수 정의 */
		JSONObject jsonParam = this._getBaseParm( loginVo );
		JSONObject jsonResult = this._getBaseParm( loginVo );
		/* 추가 파라미터 등록 */
		JSONObject jsonBody = (JSONObject) jsonResult.get( _Key.BODY );
		jsonBody.put( _Key.ISEXTERNAL, (isExternal ? _Key.TRUE : _Key.FALSE) );
		jsonBody.put( _Key.ISAPPROVAL, (isApproval ? _Key.TRUE : _Key.FALSE) );
		jsonParam.put( _Key.BODY, jsonBody );
		/* API 호출 */
		jsonResult = this._setExecute( "POST", mailDomain + "getMailBoxCountApi.do", jsonParam );
		/* 반환 처리 */
		if ( (jsonResult.get( "error" ) == null ? "" : this._getStr( jsonResult.get( "error" ) )).equals( "" ) ) {
			return jsonResult;
		}
		else {
			this._setStatusCodeLog( jsonResult, mailDomain, "getMailBoxCountApi.do" );
			return null;
		}
	}

	/**
	 * @Method Name : AllMailList ( http://wiki.duzon.com:8080/pages/viewpage.action?pageId=19689941 )
	 * @Method 설명 : 전체 메일 목록
	 * @param loginVo
	 * @param mailDomain
	 *            : 메일 도메인 ( http://domain/main2/ )
	 * @param pageSize
	 *            : 한 페이지의 사이즈
	 * @param page
	 *            : 반환할 페이지
	 * @param seen
	 *            : true이면 안 본 메일 list 만 반환
	 * @param flag
	 *            : true이면 flag 표시(중요메일)한 메일 list만 반환
	 * @param sort
	 *            : MAILTIME
	 * @return : (JSONObject) { "resultCode": "0", "resultMessage": "SUCCESS", "result":{ "TotalRecordCount":3679, "Records":[ { "receiptNotific":1, "subject":"Re:FW:FW:FW:[SK 하이닉스 청주] 인테리어 제안서 송부 건_20180202 국보디자인_전달", "flagged":0, "receiptNotificType":0, "boxName":"SENT", "seen":1, "muid":16345660, "size":245552, "answered":0, "mail_to":"문정주 <jjmoon@duzon.com>", "mail_from":"정대현 &lt;ys2cdh@duzon.com&gt;", "forward":0, "attach":false, "rfc822date":"2018-02-05 08:55:36" } ], "msg":"", "jtStartIndex":0 } }
	 *         <br>
	 *         <br>result.TotalRecordCount : (long) 전체 메일 개수
	 *         <br>result.jtStartIndex : (long) 반환된 페이지
	 *         <br>result.Records : (long) 메일 목록
	 *         <br>&nbsp;-&nbsp;receiptNotific : (int) 수신확인 상태 (0:수신확인용 아님 1: 모두 미 확인 2: 한명이상 확인 3: 모두확인)
	 *         <br>&nbsp;-&nbsp;receiptNotificType : (int) 수신확인 메일 여부 ( 0: 부 / 1: 여)
	 *         <br>&nbsp;-&nbsp;subject : (string) 제목
	 *         <br>&nbsp;-&nbsp;flagged : (int) 중요 메일 체크 ( 0: 부 / 1: 여)
	 *         <br>&nbsp;-&nbsp;seen : (int) 읽음 여부 ( 0: 부 / 1: 여)
	 *         <br>&nbsp;-&nbsp;muid : (long) 메일 uid(시퀀스)
	 *         <br>&nbsp;-&nbsp;size : (int) 메일 용량
	 *         <br>&nbsp;-&nbsp;answered : (int) 답장 여부 ( 0: 부 / 1: 여)
	 *         <br>&nbsp;-&nbsp;mail_to : (String) 받는 사람
	 *         <br>&nbsp;-&nbsp;mail_from : (String) 보낸 사람
	 *         <br>&nbsp;-&nbsp;forward : (int) 전달 여부 ( 0: 부 / 1: 여)
	 *         <br>&nbsp;-&nbsp;attach : (boolean) 파일 첨부 여부 ( false : 부 / true: 여)
	 *         <br>&nbsp;-&nbsp;rfc822date : (String) 메일 날짜 (yyyy-MM-dd HH:mm:ss)
	 */
	public JSONObject AllMailList ( LoginVO loginVo, String mailDomain, String pageSize, String page, String seen, String flag, String sort ) {
		/* 파라미터 및 반환 변수 정의 */
		JSONObject jsonParam = this._getBaseParm( loginVo );
		JSONObject jsonResult = this._getBaseParm( loginVo );
		/* 추가 파라미터 등록 */
		JSONObject jsonBody = (JSONObject) jsonResult.get( _Key.BODY );
		jsonBody.put( _Key.PAGESIZE, (this._getStr( pageSize ).equals( "" ) ? "20" : this._getStr( pageSize )) );
		jsonBody.put( _Key.PAGE, (this._getStr( page ).equals( "" ) ? "1" : this._getStr( page )) );
		jsonBody.put( _Key.SEEN, (this._getStr( seen ).equals( "" ) ? _Key.FALSE : this._getStr( seen )) );
		jsonBody.put( _Key.FLAG, (this._getStr( flag ).equals( "" ) ? _Key.FALSE : this._getStr( flag )) );
		jsonBody.put( _Key.SORT, (this._getStr( sort ).equals( "" ) ? _Key.MAILTIME : this._getStr( sort )) );
		jsonParam.put( _Key.BODY, jsonBody );
		/* API 호출 */
		jsonResult = this._setExecute( "POST", mailDomain + "getAllMailListApi.do", jsonParam );
		/* 반환 처리 */
		if ( (jsonResult.get( "error" ) == null ? "" : this._getStr( jsonResult.get( "error" ) )).equals( "" ) ) {
			return jsonResult;
		}
		else {
			this._setStatusCodeLog( jsonResult, mailDomain, "getAllMailListApi.do" );
			return null;
		}
	}
}