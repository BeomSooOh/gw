package neos.cmm.util;

import java.util.HashMap;
import sun.misc.BASE64Encoder;
import sun.misc.BASE64Decoder;

/* *
 * <pre>
 * @author oxygene
 * 
 * SSO 보안 처리 암호화/복호화 모듈.
 * 
 * </pre>
 */
public class Secure {

	public static long operKey;
	public static long pubKey;
	public static long perKey;
	static boolean chk = false;
	static HashMap<String, String> hmap;
	static {
		operKey = 62;
		pubKey = 52845;
		perKey = 22719;
	}
	
	public Secure( ) {
		return;
	}

	private static long unsignedLong(long b) {
		if (b > 65535) {
			return (long) (b & 0xFFFF);
		} else if (b < 0) {
			return (long) (b & 0xFF);
		} else {
			return (long) b;
		}
	}

	private static long unsignedByteToLong(byte b) {
		if (b > 65535) {
			return (long) (b & 0xFFFF);
		} else if (b < 0) {
			return (long)(b & 0xFF);
		} else {
			return (long) b;
		}
	}

	/**
	 * 문자열 암호화 처리
	 * 
	 * @param org_str
	 *            암호화할 문자열
	 * @return String
	 *            암호화 완료된 문자열
	 * @throws 
	 */
	public static String encode(String orgStr) {
		
		String finStr = "";
		
		//문자열 길이만큼의 배열을 만들고 byte 형으로 변환한다.
		byte orgByte[] = new byte[orgStr.getBytes().length]; 
		orgByte = orgStr.getBytes();		

		char finChar[] = new char[orgStr.getBytes().length];
		byte finByte[] = new byte[orgStr.getBytes().length];
		
		try {
			long wKey = operKey;

			for (int i=0;i<orgByte.length; i++) {
				finChar[i] = (char)( (byte)((orgByte[i])^(wKey>>8)) & 0xFF );
				wKey = ( (finChar[i] + wKey) * pubKey + perKey);
				wKey = unsignedLong(wKey); 
			}

		} catch (Exception e) {
			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
		}
		
		//char 배열을 byte 배열로 변환
		for (int i=0;i<finChar.length; i++) {
			finByte[i] = (byte)finChar[i];
		}

		//base64 인코딩 처리
		BASE64Encoder base64 = new BASE64Encoder();
		finStr = base64.encode(finByte);

		String finSplit[] = finStr.split("\r\n");
		finStr = "";
		for (int i=0; i< finSplit.length; i++) {
			finStr += finSplit[i];
		}
		
		return finStr;
	}

	/**
	 * 문자열 복호화 처리
	 * 
	 * @param org_str
	 *            복호화할 문자열
	 * @return String
	 *            복호화 완료된 문자열
	 * @throws 
	 */
	public static String decode(String orgStr) {

		String finStr = null;
		
		//base64 디코딩 처리
		byte orgByte[] = null; 
		try {
			BASE64Decoder base64 = new BASE64Decoder();
			orgByte = base64.decodeBuffer(orgStr);
		} catch (Exception e) {
			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
		}

		char orgChar[] = new char[orgByte.length];
		char finChar[] = new char[orgByte.length];
		byte finByte[] = new byte[orgByte.length];
		
		//디코딩 처리
		try {
			long wKey = operKey;

			for (int i=0;i<orgByte.length; i++) {
				orgChar[i] = (char)unsignedByteToLong(orgByte[i]);
			}

			for (int i=0;i<orgByte.length; i++) {
				finChar[i] = (char)( (orgByte[i])^(wKey>>8)  );
				finByte[i] = (byte)finChar[i];
				wKey = ( (orgChar[i] + wKey) * pubKey + perKey);
				wKey = unsignedLong(wKey); 
			}

		} catch (Exception e) {
			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
		}

		finStr = new String(finByte);

		return finStr;
	}
	
}
