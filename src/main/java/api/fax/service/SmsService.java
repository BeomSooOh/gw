package api.fax.service;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;
import java.security.InvalidAlgorithmParameterException;
import java.security.InvalidKeyException;
import java.security.NoSuchAlgorithmException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import javax.annotation.Resource;
import javax.crypto.BadPaddingException;
import javax.crypto.IllegalBlockSizeException;
import javax.crypto.NoSuchPaddingException;
import javax.servlet.http.HttpServletRequest;

import neos.cmm.common.util.FormatUtil;

import neos.cmm.db.CommonSqlDAO;
import neos.cmm.util.BizboxAProperties;
import neos.cmm.util.CommonUtil;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import org.apache.commons.codec.DecoderException;
import org.codehaus.jackson.JsonGenerationException;
import org.codehaus.jackson.map.JsonMappingException;
import org.codehaus.jackson.map.ObjectMapper;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import api.common.dao.APIDAO;
import api.common.exception.APIException;
import api.common.helper.LogHelper;
import api.common.model.APIResponse;
import api.fax.model.FaxRequest;
import api.fax.model.FaxRequestHeader;
import api.fax.model.FaxResponse;
import api.fax.util.AES128Util;
import api.poi.service.ExcelService;
import bizbox.orgchart.service.vo.LoginVO;
import main.web.BizboxAMessage;

@Service ( "SmsService" )
public class SmsService {

	Logger logger = LoggerFactory.getLogger( SmsService.class );
	@Resource ( name = "APIDAO" )
	private APIDAO apiDAO;
	@Resource ( name = "ExcelService" )
	private ExcelService excelService;
	@Resource ( name = "commonSql" )
	private CommonSqlDAO commonSql;
	private String URL_SUFFIX_MONTH_STATIS = "/wsSMSMonthStatis.aspx";
	private String URL_SUFFIX_DEPT_MONTH_STATIS = "/wsSMSMonthStatisDetail.aspx";
	private String URL_SUFFIX_EXTERNAL_SMS_API = "/wsSendSms.aspx";
	private String codeHead = "systemx.fax";
	private ObjectMapper mapper = new ObjectMapper( );
	private static final String CRLF = "\r\n";
	private static final String CHARSET = "UTF-8";
	Map<String, String> code = new HashMap<String, String>( );

	public APIResponse action ( HttpServletRequest servletRequest, Map<String, Object> request, String auth, String serviceName ) {
		long time = System.currentTimeMillis( );
		APIResponse response = null;
		String serviceErrorCode = "FX101";
		/* 세션 체크 */
		if ( servletRequest.getSession( ) == null || servletRequest.getSession( ).getAttribute( "loginVO" ) == null ) {
			APIException ae = new APIException( "FX000" );
			response = LogHelper.createError( servletRequest, codeHead, ae );
			time = System.currentTimeMillis( ) - time;
			logger.error( serviceName + "-error ET[" + time + "] " + LogHelper.getResponseString( request, response ), ae );
			return response;
		}
		/* 세션에서 필요값 꺼내오기 */
		LoginVO loginVO = (LoginVO) servletRequest.getSession( ).getAttribute( "loginVO" );
		request.put( "groupSeq", loginVO.getGroupSeq( ) );
		if ( !loginVO.getUserSe( ).equals( auth ) ) {
			APIException ae = new APIException( "FX001" );
			response = LogHelper.createError( servletRequest, codeHead, ae );
			time = System.currentTimeMillis( ) - time;
			logger.error( serviceName + "-error ET[" + time + "] " + LogHelper.getResponseString( request, response ), ae );
			return response;
		}
		/* 인터페이스 별 로직 수행 */
		try {
			String url = BizboxAProperties.getProperty( "BizboxA.fax.server" );
			logger.info( serviceName + "-start " + LogHelper.getRequestString( request ) );
			Object result = null;
			if ( loginVO.getUserSe( ).equals( "MASTER" ) ) {
				// 세션에서 필요 정보 꺼내오기
				request.put( "groupSeq", loginVO.getGroupSeq( ) );
				request.put( "langCode", loginVO.getLangCode( ) );
			}
			else if ( loginVO.getUserSe( ).equals( "ADMIN" ) ) {
				// 세션에서 필요 정보 꺼내오기
				request.put( "groupSeq", loginVO.getGroupSeq( ) );
				request.put( "compSeq", loginVO.getOrganId( ) );
				request.put( "langCode", loginVO.getLangCode( ) );
				if ( "SmsMonthStatis".equals( serviceName ) ) {
					result = SmsMonthStatis( request );
				}
				else if ( "SmsDeptMonthStatisDetail".equals( serviceName ) ) {
					result = SmsDeptMonthStatisDetail( request );
				}
			}
			else if ( loginVO.getUserSe( ).equals( "USER" ) ) {
				// 세션에서 필요 정보 꺼내오기
				request.put( "groupSeq", loginVO.getGroupSeq( ) );
				request.put( "compSeq", loginVO.getOrganId( ) );
				request.put( "deptSeq", loginVO.getOrgnztId( ) );
				request.put( "empSeq", loginVO.getUniqId( ) );
				request.put( "langCode", loginVO.getLangCode( ) );
				if ( "SmsMonthStatis".equals( serviceName ) ) {
					result = SmsMonthStatis( request );
				}
				else if ( "SmsDeptMonthStatisDetail".equals( serviceName ) ) {
					result = SmsDeptMonthStatisDetail( request );
				}
			}
			response = LogHelper.createSuccess( result );
			time = System.currentTimeMillis( ) - time;
			logger.info( serviceName + "-end ET[" + time + "] " + LogHelper.getResponseString( request, response ) );
		}
		catch ( APIException ae ) {
			response = LogHelper.createError( servletRequest, codeHead, ae );
			time = System.currentTimeMillis( ) - time;
			logger.error( serviceName + "-error ET[" + time + "] " + LogHelper.getResponseString( request, response ), ae );
		}
		catch ( Exception e ) {
			response = LogHelper.createError( servletRequest, codeHead, serviceErrorCode );
			time = System.currentTimeMillis( ) - time;
			logger.error( serviceName + "-error ET[" + time + "] " + LogHelper.getResponseString( request, response ), e );
		}
		return response;
	}

	/* SMS GW API */
	public APIResponse externalAction ( HttpServletRequest servletRequest, Map<String, Object> request, String serviceName ) {
		long time = System.currentTimeMillis( );
		APIResponse response = null;
		String serviceErrorCode = "FX101";
		/* 세션 체크 */
		//		if ( servletRequest.getSession( ) == null || servletRequest.getSession( ).getAttribute( "loginVO" ) == null ) {
		//			APIException ae = new APIException( "FX000" );
		//			response = LogHelper.createError( servletRequest, codeHead, ae );
		//			time = System.currentTimeMillis( ) - time;
		//			logger.error( serviceName + "-error ET[" + time + "] " + LogHelper.getResponseString( request, response ), ae );
		//			return response;
		//		}
		/* 세션에서 필요값 꺼내오기 */
		//		LoginVO loginVO = (LoginVO) servletRequest.getSession( ).getAttribute( "loginVO" );
		//		request.put( "groupSeq", loginVO.getGroupSeq( ) );
		//		if ( !loginVO.getUserSe( ).equals( auth ) ) {
		//			APIException ae = new APIException( "FX001" );
		//			response = LogHelper.createError( servletRequest, codeHead, ae );
		//			time = System.currentTimeMillis( ) - time;
		//			logger.error( serviceName + "-error ET[" + time + "] " + LogHelper.getResponseString( request, response ), ae );
		//			return response;
		//		}
		/* 인터페이스 별 로직 수행 */
		try {
			String url = BizboxAProperties.getProperty( "BizboxA.fax.server" );
			logger.info( serviceName + "-start " + LogHelper.getRequestString( request ) );
			Map<String, Object> result = new HashMap<String, Object>( );
			if ( "smsSendAPI".equals( serviceName ) ) {
				result = smsSendAPI( request );
			}
			response = new APIResponse( );
			response.setResultCode( result.get( "resultCode" ).toString( ) );
			response.setResultMessage( result.get( "result" ).toString( ) );
			response.setResult( result.get( "resultMessage" ) );
			time = System.currentTimeMillis( ) - time;
			logger.info( serviceName + "-end ET[" + time + "] " + LogHelper.getResponseString( request, response ) );
		}
		catch ( APIException ae ) {
			response = LogHelper.createError( servletRequest, codeHead, ae );
			time = System.currentTimeMillis( ) - time;
			logger.error( serviceName + "-error ET[" + time + "] " + LogHelper.getResponseString( request, response ), ae );
		}
		catch ( Exception e ) {
			response = LogHelper.createError( servletRequest, codeHead, serviceErrorCode );
			time = System.currentTimeMillis( ) - time;
			logger.error( serviceName + "-error ET[" + time + "] " + LogHelper.getResponseString( request, response ), e );
		}
		return response;
	}

	private Map<String, Object> smsSendAPI ( Map<String, Object> request ) throws JsonGenerationException, JsonMappingException, InvalidKeyException, NoSuchAlgorithmException, NoSuchPaddingException, InvalidAlgorithmParameterException, IllegalBlockSizeException, BadPaddingException, IOException, DecoderException {
		/* SMS 발송 필요 데이터 정의 변수 */
		Map<String, Object> params = new HashMap<String, Object>( );
		Map<String, Object> bill365Info = new HashMap<String, Object>( );
		JSONObject smsData = new JSONObject( );
		JSONObject smsContent = new JSONObject( );
		JSONObject smsRecive = null;
		JSONObject smsInfoJson = new JSONObject( );
		JSONObject smsRecvInfoJson = new JSONObject( );
		JSONObject smsInfos = new JSONObject( );
		JSONArray smsInfosArray = new JSONArray( );
		JSONArray smsContentInfoArray = new JSONArray( );
		JSONArray smsReceiveInfoArray = new JSONArray( );
		Map<String, Object> smsResult = new HashMap<String, Object>( );
		/* SMS 발송 parameter 검증 */
		String compSeq = FormatUtil.getString( request.get( "compSeq" ) );
		String callbackNo = FormatUtil.getString( request.get( "callbackNo" ) );
		String sendMsg = FormatUtil.getString( request.get( "sendMsg" ) );
		String subject = FormatUtil.getString( request.get( "subject" ) );
		String mobileNo = FormatUtil.getString( request.get( "mobileNo" ) );
		params.put( "compSeq", compSeq );
		/* bill36524 데이터 호출 */
		Map<String, Object> groupInfo = (Map<String, Object>) commonSql.select( "smsDAO.getSmsRegInfo", params );
		if ( groupInfo == null ) { // 데이터 없을 경우 기본값 처리
			bill365Info.put( "bill35624Id", "" );
			bill365Info.put( "agentId", "" );
			bill365Info.put( "agentKey", "" );
			smsResult.put( "result", "FAIL" );
			smsResult.put( "resultCode", "-1" );
			smsResult.put( "resultMessage", BizboxAMessage.getMessage("TX800000011","bill36524 계정 또는 SMS 메뉴 권한을 확인해주세요") );
			return smsResult;
		}
		else { // bill36524 데이터 정의
			bill365Info.put( "bill35624Id", FormatUtil.getString( groupInfo.get( "bill36524Id" ) ) );
			bill365Info.put( "agentId", FormatUtil.getString( groupInfo.get( "agentId" ) ) );
			bill365Info.put( "agentKey", FormatUtil.getString( groupInfo.get( "agentKey" ) ) );
		}
		/* 키컴 API parameter 생성 */
		if ( request.get( "testMode" ) != null ) {
			smsContent.put( "Bill36524ID", "MTEST001" );
		}
		else {
			smsContent.put( "Bill36524ID", bill365Info.get( "bill35624Id" ) );
		}
		smsContent.put( "CallbackNo", callbackNo );
		smsContent.put( "SendMsg", sendMsg );
		smsContent.put( "SendTime", "NOW" );
		smsContent.put( "Subject", subject );
		smsContent.put( "BulkKey", UUID.randomUUID( ).toString( ).toUpperCase( ).replace( "-", "" ) );
		//smsContent.put( "BulkKey", "" );
		/* SMS / LMS 체크 */
		if ( getByteLength( sendMsg ) < 90 ) {
			smsContent.put( "SendType", "1" ); //  	SMS
		}
		else {
			smsContent.put( "SendType", "2" ); //   LMS
		}
		smsContentInfoArray.add( smsContent );
		if ( mobileNo.indexOf( "▦" ) > -1 ) {
			String[] mobileNoInfo = mobileNo.split( "▦" );
			for ( int i = 1; i < mobileNoInfo.length; i++ ) {
				smsRecive = new JSONObject( );
				smsRecive.put( "MobileNo", mobileNoInfo[i] );
				smsRecive.put( "SMSKey", UUID.randomUUID( ).toString( ).toUpperCase( ).replace( "-", "" ) );
				smsReceiveInfoArray.add( smsRecive );
			}
		} else {
			smsResult.put( "result", "FAIL" );
			smsResult.put( "resultCode", "-1" );
			smsResult.put( "resultMessage", BizboxAMessage.getMessage("TX800000012","번호 파라미터를 확인해주세요.") );
			return smsResult;
		}
		//smsRecive.put( "SMSKey", "" );
		smsInfoJson.put( "SMSInfo", smsContentInfoArray );
		smsRecvInfoJson.put( "SMSRecvInfo", smsReceiveInfoArray );
		if ( request.get( "testMode" ) != null && request.get( "testMode" ).equals( "Y" ) ) {
			smsData.put( "AgentID", "duzonit" );
			smsData.put( "AgentKey", "bzdRZEJ3akVaUmpWbFQ2NWdQOFhxOUZwNXkwcUZUMGtCdkdWVjNDbFBud29tekh0dnZibjVxZXpmWS83Zk93bg==" );
			smsData.put( "testMode", "Y" );
		}
		else {
			smsData.put( "AgentID", bill365Info.get( "agentId" ) );
			smsData.put( "AgentKey", bill365Info.get( "agentKey" ) );
		}
		smsInfos.put( "SMSInfo", smsContentInfoArray );
		smsInfos.put( "SMSRecvInfo", smsReceiveInfoArray );
		smsInfosArray.add( smsInfos );
		smsData.put( "SMSInfos", smsInfosArray );
		/* 키컴 API 호출 */
		FaxResponse res = getExternalSMSAPIResult( smsData, URL_SUFFIX_EXTERNAL_SMS_API );
		if ( res.getResultCode( ).equals( "0" ) ) {
			smsResult.put( "result", "SUCCESS" );
			smsResult.put( "resultCode", "0" );
			smsResult.put( "resultMessage", BizboxAMessage.getMessage("TX800000013","문자 전송에 성공했습니다.") );
		}
		else {
			smsResult.put( "result", "FAIL" );
			smsResult.put( "resultCode", "-1" );
			smsResult.put( "resultMessage", BizboxAMessage.getMessage("TX800000014","문자 전송에 실패했습니다.") );
		}
		return smsResult;
	}
	
	public int mmsSendAPI (Map<String, Object> param, byte[] qrImage) throws JsonGenerationException, JsonMappingException, InvalidKeyException, NoSuchAlgorithmException, NoSuchPaddingException, InvalidAlgorithmParameterException, IllegalBlockSizeException, BadPaddingException, IOException, DecoderException {
		/* SMS 발송 필요 데이터 정의 변수 */
		JSONObject mmsData = new JSONObject( );
		
		mmsData.put( "AgentID", param.get("agentId") );
		mmsData.put( "AgentKey", param.get("agentKey") );
		
		JSONArray mmsContentInfoArray = new JSONArray( );
		JSONObject mmsContent = new JSONObject( );
		mmsContent.put( "Bill36524ID", param.get("bill36524Id") );
		mmsContent.put( "Subject", "[DOUZONE 출입카드 발급]" );
		mmsContent.put( "SendType", "3" );
		mmsContent.put( "SendMsg", "[DOUZONE 출입카드 발급]\r\n본 QR코드는 더존비즈온 방문 시 출입할 수 있는 인증코드 입니다.\r\n등록된 방문일에 안내 데스크에서 인증 후 임시 출입증을 수령할 수 있습니다.\r\n방문일이 변경되는 경우 담당자에게 확인하여 주시기 바랍니다." );
		mmsContent.put( "CallbackNo", param.get("qrCallbackNo") );
		mmsContent.put( "SendTime", "NOW" );
		mmsContent.put( "BulkKey", UUID.randomUUID( ).toString( ).toUpperCase( ).replace( "-", "" ) );		
		mmsContentInfoArray.add( mmsContent );
		
		JSONArray mmsReceiveInfoArray = new JSONArray( );
		JSONObject mmsRecive = new JSONObject( );
		mmsRecive.put( "MobileNo", param.get("qrMobileNo") );
		mmsRecive.put( "SMSKey", UUID.randomUUID( ).toString( ).toUpperCase( ).replace( "-", "" ) );
		mmsReceiveInfoArray.add(mmsRecive);
		
		JSONObject mmsInfos = new JSONObject( );
		mmsInfos.put( "MMSInfo", mmsContentInfoArray );
		mmsInfos.put( "MMSRecvInfo", mmsReceiveInfoArray );
		
		JSONArray mmsInfosArray = new JSONArray( );
		mmsInfosArray.add( mmsInfos );
		
		mmsData.put( "MMSInfos", mmsInfosArray );
		
		/* 키컴 API 호출 */
		FaxResponse res = getExternalMMSAPIResult(mmsData, param.get("bill36524Url").toString(), qrImage);
		
		return Integer.parseInt(res.getResultCode());
		
	}	

	private Map<String, Object> SmsMonthStatis ( Map<String, Object> request ) throws JsonGenerationException, JsonMappingException, InvalidKeyException, NoSuchAlgorithmException, NoSuchPaddingException, InvalidAlgorithmParameterException, IllegalBlockSizeException, BadPaddingException, IOException, DecoderException {
		Map<String, Object> body = new HashMap<String, Object>( );
		Map<String, Object> result = new HashMap<String, Object>( );
		body.put( "AgentID", request.get( "AgentID" ) );
		body.put( "AgentKey", request.get( "AgentKey" ) );
		body.put( "compSeq", request.get( "compSeq" ) );
		body.put( "smsDate", request.get( "smsDate" ) );
		FaxResponse res = getSmsAPIResult( body, URL_SUFFIX_MONTH_STATIS );
		if ( res.getResultCode( ).equals( "0" ) ) {
			result.put( "result", res.getResult( ) );
			List<Map<String, Object>> deptData = new ArrayList<Map<String, Object>>( );
			List<String> deptSeqTemp = new ArrayList<String>( );
			Map<String, Object> data = (Map<String, Object>) res.getResult( );
			Map<String, Object> newData = new HashMap<String, Object>( );
			deptData = (ArrayList<Map<String, Object>>) data.get( "SMSMonthStatisInfoList" );
			for ( Map<String, Object> temp : deptData ) {
				if ( newData.get( temp.get( "deptSeq" ).toString( ) ) == null ) {
					newData.put( temp.get( "deptSeq" ).toString( ), temp );
					deptSeqTemp.add( temp.get( "deptSeq" ).toString( ) );
				}
				else {
					if ( newData.get( temp.get( "deptSeq" ).toString( ) ) != null ) {
						if ( ((Map<String, Object>) newData.get( temp.get( "deptSeq" ) )).get( "deptSeq" ).equals( temp.get( "deptSeq" ).toString( ) ) ) {
							Map<String, Object> newMapTemp = new HashMap<String, Object>( );
							int deptCount = Integer.parseInt( ((Map<String, Object>) newData.get( temp.get( "deptSeq" ) )).get( "deptCount" ).toString( ) );
							int tempDeptCount = Integer.parseInt( temp.get( "deptCount" ).toString( ) );
							float deptPoint = Float.parseFloat( ((Map<String, Object>) newData.get( temp.get( "deptSeq" ) )).get( "deptPoint" ).toString( ) );
							float tempDeptPoint = Float.parseFloat( temp.get( "deptPoint" ).toString( ) );
							float deptPointSUm = deptPoint + tempDeptPoint;
							int deptCountSum = deptCount + tempDeptCount;
							int deptPointSum = (int) deptPointSUm;
							newMapTemp.put( "deptSeq", temp.get( "deptSeq" ).toString( ) );
							newMapTemp.put( "deptName", temp.get( "deptName" ).toString( ) );
							newMapTemp.put( "deptPoint", String.valueOf( deptPointSum ) );
							newMapTemp.put( "deptCount", String.valueOf( deptCountSum ) );
							newData.put( temp.get( "deptSeq" ).toString( ), newMapTemp );
//							System.out.println( "동일" );
						}
					}
				}
			}
			List<Map<String, Object>> newDeptData = new ArrayList<Map<String, Object>>( );
			for ( String temp : deptSeqTemp ) {
				Map<String, Object> realData = new HashMap<String, Object>( );
				newDeptData.add( (Map<String, Object>) newData.get( temp ) );
			}
			res.getResult( ).put( "SMSMonthStatisInfoList", newDeptData );
		}
		return result;
	}

	private Map<String, Object> SmsDeptMonthStatisDetail ( Map<String, Object> request ) throws JsonGenerationException, JsonMappingException, InvalidKeyException, NoSuchAlgorithmException, NoSuchPaddingException, InvalidAlgorithmParameterException, IllegalBlockSizeException, BadPaddingException, IOException, DecoderException {
		Map<String, Object> body = new HashMap<String, Object>( );
		Map<String, Object> result = new HashMap<String, Object>( );
		body.put( "AgentID", request.get( "AgentID" ) );
		body.put( "AgentKey", request.get( "AgentKey" ) );
		body.put( "compSeq", request.get( "compSeq" ) );
		body.put( "smsDate", request.get( "smsDate" ) );
		body.put( "deptSeq", request.get( "deptSeq" ) );
		FaxResponse res = getSmsAPIResult( body, URL_SUFFIX_DEPT_MONTH_STATIS );
		if ( res.getResultCode( ).equals( "0" ) ) {
			result.put( "result", res.getResult( ) );
		}
		else {
			result.put( "result", res.getResult( ) );
		}
		return result;
	}

	/**
	 * 키컴 API 호출
	 * 
	 * @param body
	 * @param suffixUrl
	 * @return
	 * @throws JsonGenerationException
	 * @throws JsonMappingException
	 * @throws IOException
	 * @throws InvalidKeyException
	 * @throws NoSuchAlgorithmException
	 * @throws NoSuchPaddingException
	 * @throws InvalidAlgorithmParameterException
	 * @throws IllegalBlockSizeException
	 * @throws BadPaddingException
	 * @throws DecoderException
	 */
	private FaxResponse getSmsAPIResult ( Map<String, Object> body, String suffixUrl ) throws JsonGenerationException, JsonMappingException, IOException, InvalidKeyException, NoSuchAlgorithmException, NoSuchPaddingException, InvalidAlgorithmParameterException, IllegalBlockSizeException, BadPaddingException, DecoderException {
		FaxRequest request = new FaxRequest( );
		request.setHeader( new FaxRequestHeader( ) );
		request.setBody( body );
		String requestJson = mapper.writeValueAsString( request );
		requestJson = AES128Util.AES_Encode( requestJson );
		logger.info( "Fax API Request = " + requestJson );
		FaxResponse response = null;
		String responseJson = getHttpResponse( BizboxAProperties.getProperty( "BizboxA.fax.server" ) + suffixUrl, requestJson );
		if ( responseJson.charAt( 0 ) == '{' ) {
			response = mapper.readValue( responseJson, FaxResponse.class );
		}
		else {
			responseJson = AES128Util.AES_Decode( responseJson );
			response = mapper.readValue( responseJson, FaxResponse.class );
		}
		logger.info( "Fax API Response = " + responseJson );
		return response;
	}

	/**
	 * 키컴 SMS SEND API 호출
	 * 
	 * @param body
	 * @param suffixUrl
	 * @return
	 * @throws JsonGenerationException
	 * @throws JsonMappingException
	 * @throws IOException
	 * @throws InvalidKeyException
	 * @throws NoSuchAlgorithmException
	 * @throws NoSuchPaddingException
	 * @throws InvalidAlgorithmParameterException
	 * @throws IllegalBlockSizeException
	 * @throws BadPaddingException
	 * @throws DecoderException
	 */
	private FaxResponse getExternalSMSAPIResult ( Map<String, Object> body, String suffixUrl ) throws JsonGenerationException, JsonMappingException, IOException, InvalidKeyException, NoSuchAlgorithmException, NoSuchPaddingException, InvalidAlgorithmParameterException, IllegalBlockSizeException, BadPaddingException, DecoderException {

		FaxRequest request = new FaxRequest( );
		request.setHeader( new FaxRequestHeader( ) );
		request.setBody( body );
		String requestJson = mapper.writeValueAsString( request );
		requestJson = AES128Util.AES_Encode( requestJson );
		logger.info( "SMS SEND API RequestJson Data = " + requestJson );
		FaxResponse response = null;
		String faxApiUrl = BizboxAProperties.getProperty( "BizboxA.fax.server" );
		if ( body.get( "testMode" ) != null && body.get( "testMode" ).equals( "Y" ) ) {
			faxApiUrl = "http://bizboxmobile.cloudfax.co.kr";
		}
		String responseJson = getHttpResponse( faxApiUrl + suffixUrl, requestJson );
		if ( responseJson.equals( "" ) ) {
			response = new FaxResponse( );
			response.setResultCode( "1" );
			response.setResultMessage( BizboxAMessage.getMessage("TX800000015","파라미터를 확인해주세요") );
			return response;
		}
		if ( responseJson.charAt( 0 ) == '{' ) {
			response = mapper.readValue( responseJson, FaxResponse.class );
		}
		else {
			responseJson = AES128Util.AES_Decode( responseJson );
			response = mapper.readValue( responseJson, FaxResponse.class );
		}
		logger.info( "Fax API Response = " + responseJson );
		return response;
	}
	
	private FaxResponse getExternalMMSAPIResult (Map<String, Object> faxBody, String suffixUrl, byte[] bytes) throws JsonGenerationException, JsonMappingException, IOException, InvalidKeyException, NoSuchAlgorithmException, NoSuchPaddingException, InvalidAlgorithmParameterException, IllegalBlockSizeException, BadPaddingException, DecoderException {
		
		FaxResponse result = null;
		
		HttpURLConnection conn = null;
		
		try{
			FaxRequest request = new FaxRequest();
			request.setHeader(new FaxRequestHeader());
			request.setBody(faxBody);
			String sendFaxInfo = mapper.writeValueAsString(request);
			sendFaxInfo = AES128Util.AES_Encode(sendFaxInfo);
			sendFaxInfo = URLEncoder.encode(sendFaxInfo,"UTF-8");
			
			String boundary = "----" + UUID.randomUUID().toString();
			String header = "--" + boundary;
			String footer = header + "--";
			
			StringBuilder content = new StringBuilder();
			// 팩스 전송 데이터
			content.append(header + CRLF);
			content.append("Content-Disposition: form-data; name=\"SendMmsInfo\"" + CRLF);
			content.append(CRLF);
			content.append(sendFaxInfo + CRLF);
			// 팩스 이미지 파일
			content.append(header + CRLF);
			content.append("Content-Disposition: form-data; name=\"file01\"; filename=\"" + "qr_img.jpg" + "\"" + CRLF);
			content.append("Content-Type: " + "application/octet-stream" + CRLF); 
			content.append(CRLF);
			
			byte[] body = content.toString().getBytes(CHARSET);
			byte[] foot = (CRLF + footer + CRLF).getBytes(CHARSET);
			
			URL url = new URL(suffixUrl + "/wsSendMms.aspx");
			conn = (HttpURLConnection) url.openConnection();
			
			conn.setConnectTimeout(5000);
			conn.setReadTimeout(120000);
			conn.setDoInput(true);
			conn.setDoOutput(true);
			conn.setUseCaches(false);
			conn.setRequestMethod("POST");
			conn.setRequestProperty("Content-Type", "multipart/form-data; boundary=" + boundary);
			conn.connect();
			
			OutputStream os = null;
			try{
				os = conn.getOutputStream();
				os.write(body);
				os.write(bytes);
				os.write(foot);
				os.flush();
			}finally{
				if (os != null) { try { os.close(); } catch (Exception ignore) { 
					CommonUtil.printStatckTrace(ignore);//오류메시지를 통한 정보노출
					} 
				}
			}
			
			String responseJson = "";
			InputStream is = null;
			try{
				is = conn.getInputStream();
				ByteArrayOutputStream stream = new ByteArrayOutputStream();
	
				byte[] buffer = new byte[4096];
	            int size = 0;
	            while ((size = is.read(buffer)) != -1) {
	                stream.write(buffer, 0, size);
	            }
	            
	            responseJson = new String(stream.toByteArray(), CHARSET);
			}finally{
				if (is != null) { try { is.close(); } catch (Exception ignore) { 
					CommonUtil.printStatckTrace(ignore);//오류메시지를 통한 정보노출
					} 
				}
			}
            
            if(responseJson.charAt(0) != '{') {
            	responseJson = AES128Util.AES_Decode(responseJson);
            }
            
            result = mapper.readValue(responseJson, FaxResponse.class);
            
		}catch(Exception e){
			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
		}finally{
			if (conn != null) { conn.disconnect(); }
		}
		
		return result;		
		
	}	

	private String getHttpResponse ( String urlStr, String json ) throws IOException {
		URL url = new URL( urlStr );
		HttpURLConnection conn = (HttpURLConnection) url.openConnection( );
		conn.setConnectTimeout( 5000 );
		conn.setReadTimeout( 60000 );
		conn.setDoInput( true );
		conn.setDoOutput( true );
		conn.setUseCaches( false );
		conn.setRequestMethod( "POST" );
		byte[] data = json.getBytes( CHARSET );
		conn.setRequestProperty( "Content-Length", String.valueOf( data.length ) );
		conn.setRequestProperty( "Content-Type", "application/json; charset=utf-8" );
		conn.connect( );
		OutputStream out = null;
		try {
			out = conn.getOutputStream( );
			out.write( data );
			out.flush( );
		}
		finally {
			if ( out != null ) {
				try {
					out.close( );
				}
				catch ( Exception ignore ) {
					CommonUtil.printStatckTrace(ignore);//오류메시지를 통한 정보노출
				}
			}
		}
		InputStream in = null;
		String res = "";
		try {
			in = conn.getInputStream( );
			ByteArrayOutputStream stream = new ByteArrayOutputStream( );
			byte[] buffer = new byte[4096];
			int len = 0;
			while ( (len = in.read( buffer )) != -1 ) {
				stream.write( buffer, 0, len );
			}
			res = new String( stream.toByteArray( ), CHARSET );
		}
		finally {
			if ( in != null ) {
				try {
					in.close( );
				}
				catch ( Exception ignore ) {
					CommonUtil.printStatckTrace(ignore);//오류메시지를 통한 정보노출
				}
			}
			if ( conn != null ) {
				conn.disconnect( );
			}
		}
		return res;
	}
	
	/* 바이트 계산 */
	public static int getByteLength ( String str ) {
		int strLength = 0;
		char tempChar[] = new char[str.length( )];
		for ( int i = 0; i < tempChar.length; i++ ) {
			tempChar[i] = str.charAt( i );
			if ( tempChar[i] < 128 ) {
				strLength++;
			}
			else {
				strLength += 2;
			}
		}
		return strLength;
	}
}
