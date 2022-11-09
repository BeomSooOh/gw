package neos.cmm.util;

import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.net.URLDecoder;
import java.security.InvalidAlgorithmParameterException;
import java.security.InvalidKeyException;
import java.security.KeyFactory;
import java.security.NoSuchAlgorithmException;
import java.security.PrivateKey;
import java.security.PublicKey;
import java.security.spec.AlgorithmParameterSpec;
import java.security.spec.PKCS8EncodedKeySpec;
import java.security.spec.X509EncodedKeySpec;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Properties;

import javax.crypto.BadPaddingException;
import javax.crypto.Cipher;
import javax.crypto.IllegalBlockSizeException;
import javax.crypto.NoSuchPaddingException;
import javax.crypto.SecretKey;
import javax.crypto.spec.IvParameterSpec;
import javax.crypto.spec.SecretKeySpec;

import org.apache.commons.codec.binary.Base64;
import org.joda.time.DateTime;
import org.joda.time.format.DateTimeFormat;
import org.joda.time.format.DateTimeFormatter;
import org.junit.Test;

/*
 * AESCipher: AES 128bit 암호화 
 */

public class AESCipher { 
	
	private static byte[] ivBytes = { 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00 };   
	final static String SECRETKEY = "1023497555960596";
	
	// 암호화키 생성
	public static String AES_GetKey(String key) {
		
		if(!BizboxAProperties.getCustomProperty( "BizboxA.AES_SECRETKEY").equals("99")) {
			return BizboxAProperties.getCustomProperty( "BizboxA.AES_SECRETKEY");
		}		
		
		int keyLength = key.getBytes().length;
		int padLength = 0;	
		
		if(keyLength < 16) {
			padLength = 16 - keyLength;
		}else if(keyLength > 16 && keyLength < 24) {
			padLength = 24 - keyLength;
		}else if(keyLength > 24 && keyLength < 32) {
			padLength = 32 - keyLength;
		}else if(keyLength > 32) {
			//하드코드된 중요정보: 암호화 키
			Properties prop = new Properties();
			key = "1023497555960596";
			key = key == null ? (String)prop.getProperty("key") : "1023497555960596";
		}	
		
		for (int i = 0; i < padLength; i++) {
			key += "0";
		}	
		
		return key;
		
	}
	
	// 암호화 
	public static String AES_Encode(String str)
			throws java.io.UnsupportedEncodingException,
			NoSuchAlgorithmException, NoSuchPaddingException,
			InvalidKeyException, InvalidAlgorithmParameterException,
			IllegalBlockSizeException, BadPaddingException {
		//하드코드된 중요정보: 암호화 키
		Properties prop = new Properties();
		String key = SECRETKEY == null ? (String)prop.getProperty("key") : "1023497555960596";
		byte[] keyData = key.getBytes();

		SecretKey secureKey = new SecretKeySpec(keyData, "AES");

		Cipher c = Cipher.getInstance("AES/CBC/PKCS5Padding");
		c.init(Cipher.ENCRYPT_MODE, secureKey,
				new IvParameterSpec(key.getBytes()));

		byte[] encrypted = c.doFinal(str.getBytes("UTF-8"));
		String enStr = new String(Base64.encodeBase64(encrypted),"UTF-8");

		return enStr;
	} 

	// 복호화
	public static String AES_Decode(String str)
			throws java.io.UnsupportedEncodingException,
			NoSuchAlgorithmException, NoSuchPaddingException,
			InvalidKeyException, InvalidAlgorithmParameterException,
			IllegalBlockSizeException, BadPaddingException {
		//하드코드된 중요정보: 암호화 키
		Properties prop = new Properties();
		String key = SECRETKEY == null ? (String)prop.getProperty("key") : "1023497555960596";
		byte[] keyData = key.getBytes();
		SecretKey secureKey = new SecretKeySpec(keyData, "AES");
		Cipher c = Cipher.getInstance("AES/CBC/PKCS5Padding");
		c.init(Cipher.DECRYPT_MODE, secureKey,
				new IvParameterSpec(key.getBytes("UTF-8")));

		byte[] byteStr = Base64.decodeBase64(str.getBytes());

		return new String(c.doFinal(byteStr), "UTF-8");
	}
	
	/*
	// 보안성 획득 방안(키 생성 )
		1.	암호화를 하는 시점을 문자열로 받는다. 형식은 yyyyMMddHHmmss
		2.	해당 문자열을 암호화하여 accessToken으로 보낸다.
	// 보안성 획득 방안(키 유효성 체크)
		1.	암호화된 accessToken을 받아서 복호화한다.
		2.	날짜포맷이 맞는지 검증한다. 포맷은 yyyyMMddHHmmss
		3.	앞의 yyyyMMdd 만 빼내어 현재 날짜와 같은지 확인한다.
	*/
	@Test
	public static String makeAccessToken() throws InvalidKeyException, UnsupportedEncodingException, NoSuchAlgorithmException, 
		NoSuchPaddingException, InvalidAlgorithmParameterException, IllegalBlockSizeException, BadPaddingException
	{
		Date now = new Date();
		SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMddHHmmss");
		String nowString = sdf.format(now);
		
		String accessToken = AESCipher.AES_Encode(nowString);
		
		//System.out.println("암호화 전 : " + nowString + " / 암호화 후  accessToken : " + accessToken + " / 복호화 : " + AESCipher.AES_Decode(accessToken));
		//log.info("암호화 전 : " + nowString + " / 암호화 후  accessToken : " + accessToken + " / 복호화 : " + AESCipher.AES_Decode(accessToken));
		
		return accessToken;
	}
	
	// 암호화 AES128 암호화 키값을 같이 받음
	public static String AES128_Encode(String str, String key)
			throws java.io.UnsupportedEncodingException,
			NoSuchAlgorithmException, NoSuchPaddingException,
			InvalidKeyException, InvalidAlgorithmParameterException,
			IllegalBlockSizeException, BadPaddingException {
		//하드코드된 중요정보: 암호화 키
		if (key == null || key.equals("")) {
			key = "1023497555960596";
			Properties prop = new Properties();
			key = key == null ? (String)prop.getProperty("key") : "1023497555960596";
		}
		byte[] keyData = key.getBytes();

		SecretKey secureKey = new SecretKeySpec(keyData, "AES");

		Cipher c = Cipher.getInstance("AES/CBC/PKCS5Padding");
		c.init(Cipher.ENCRYPT_MODE, secureKey,	new IvParameterSpec(key.getBytes()));

		byte[] encrypted = c.doFinal(str.getBytes("UTF-8"));
		String enStr = new String(Base64.encodeBase64(encrypted), "UTF-8");

		return enStr;
	}
	
	// 복호화
	public static String AES128_Decode(String str, String key)
			throws java.io.UnsupportedEncodingException,
			NoSuchAlgorithmException, NoSuchPaddingException,
			InvalidKeyException, InvalidAlgorithmParameterException,
			IllegalBlockSizeException, BadPaddingException {
		byte[] keyData = key.getBytes();
		SecretKey secureKey = new SecretKeySpec(keyData, "AES");
		Cipher c = Cipher.getInstance("AES/CBC/PKCS5Padding");
		c.init(Cipher.DECRYPT_MODE, secureKey,
				new IvParameterSpec(key.getBytes("UTF-8")));

		byte[] byteStr = Base64.decodeBase64(str.getBytes());

		return new String(c.doFinal(byteStr), "UTF-8");
	}	
	
	public static String AES256_Encode(String sText, String sKey) {
		if (sText == null || sText.trim().length() == 0) {
			return null;
		}
		String result = "";

		try {

			// 키 256bit(32자리)
			String key256 = sKey;
			byte[] key256Data = key256.getBytes("UTF-8");

			// 운용모드 CBC, 패딩 PKCS7Padding
			Cipher cipher = Cipher.getInstance("AES/CBC/PKCS5Padding");
			cipher.init(Cipher.ENCRYPT_MODE, new SecretKeySpec(key256Data,
					"AES"), new IvParameterSpec(ivBytes));

			// AES암호화
			byte[] encrypted = cipher.doFinal(sText.getBytes("UTF-8"));

			// Base64 인코딩
			byte[] encryptedStr = Base64.encodeBase64(encrypted);

			result = new String(encryptedStr, "euc-kr");

		} catch (Exception e) {

			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출

		}

		return result;
	}
	
	// 복호화 - AES/CBC/PKCS7Padding
	public static String AES256_Decode(String sText, String sKey) {

		if (sText == null || sText.trim().length() == 0) {
			return null;

		}
		String decryptedStr = null;

		try {

			// 키 256bit(32자리)
			String key256 = sKey;
			byte[] key256Data = key256.getBytes("UTF-8");

			// 운용모드 CBC, 패딩 PKCS7Padding
			Cipher cipher = Cipher.getInstance("AES/CBC/PKCS5Padding");
			cipher.init(Cipher.DECRYPT_MODE, new SecretKeySpec(key256Data,
					"AES"), new IvParameterSpec(ivBytes));

			// Base64 디코딩
			byte[] textBytes = Base64.decodeBase64(sText.getBytes("euc-kr"));

			// AES복호화
			decryptedStr = new String(cipher.doFinal(textBytes), "euc-kr");

		} catch (Exception e) {

			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출

		}

		return decryptedStr;

	}	
	
	
	public static String AES256_Decode_UTF8(String encryptData, String sKey) throws Exception {

        if(encryptData == null || encryptData.trim().length() == 0){
            return null;
        }

        String decryptedStr = null;

        //키 256bit(32자리)
        String key256 = sKey.substring(0, 256/8);
        byte[] key256Data = key256.getBytes("UTF-8");

        //운용모드 CBC, 패딩 PKCS5Padding
        Cipher cipher = Cipher.getInstance("AES/CBC/PKCS5Padding");
        cipher.init(Cipher.DECRYPT_MODE , new SecretKeySpec(key256Data,"AES") , new IvParameterSpec(ivBytes));

        //Base64 디코딩
        byte[] textBytes = Base64.decodeBase64(encryptData.getBytes());

        //AES복호화
        decryptedStr = new String(cipher.doFinal(textBytes), "UTF-8");

        return decryptedStr;

    }
	
	// 외부연동용 암호화 AES128
	public static String AES128EX_Encode(String str, String key)
			throws java.io.UnsupportedEncodingException,
			NoSuchAlgorithmException, NoSuchPaddingException,
			InvalidKeyException, InvalidAlgorithmParameterException,
			IllegalBlockSizeException, BadPaddingException {
		  byte[] crypted = null;
		  try{
			//하드코드된 중요정보: 암호화 키
			  if (key == null || key.equals("")) {
					key = "1023497555960596";
					Properties prop = new Properties();
					key = key == null ? (String)prop.getProperty("key") : "1023497555960596";
				}
		    SecretKeySpec skey = new SecretKeySpec(key.getBytes(), "AES");
		      Cipher cipher = Cipher.getInstance("AES/ECB/PKCS5Padding");
		      cipher.init(Cipher.ENCRYPT_MODE, skey);
		      crypted = cipher.doFinal(str.getBytes());
		    }catch(Exception e){
		    	//System.out.println(e.toString());
		    	CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
		    }
		    return new String(Base64.encodeBase64(crypted),"UTF-8");
		    
	}
	
	// 외부연동용 암호화 AES128
	public static String AES128EX_Decode(String str, String key)
			throws java.io.UnsupportedEncodingException,
			NoSuchAlgorithmException, NoSuchPaddingException,
			InvalidKeyException, InvalidAlgorithmParameterException,
			IllegalBlockSizeException, BadPaddingException {
	    byte[] output = null;
	    try{
	    	//하드코드된 중요정보: 암호화 키
	    	if (key == null || key.equals("")) {
				key = "1023497555960596";
				Properties prop = new Properties();
				key = key == null ? (String)prop.getProperty("key") : "1023497555960596";
			}
	      SecretKeySpec skey = new SecretKeySpec(key.getBytes(), "AES");
	      Cipher cipher = Cipher.getInstance("AES/ECB/PKCS5Padding");
	      cipher.init(Cipher.DECRYPT_MODE, skey);
	      output = cipher.doFinal(Base64.decodeBase64(str.getBytes()));
	    }catch(Exception e){
	      //System.out.println(e.toString());
	    	CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
	    }
	    return new String(output,"UTF-8");
	}
	
	
	public static String AES128EX_ExpirDecode(String str, String key, int min){
		
		try{
			str = AES128_Decode(str, key == null || key.equals("") ? "1023497555960596" : key);	
		}catch(Exception ex){
			return "";
		}
		
		String authDate = "";	//생성일자 
		String authKey = "";	//인증정보(걔정)
		
		if(str.contains("▦")){
			
			//구분자 포함
			String[] keyVal = str.split("▦", -1);			
			authDate = keyVal[0];
			authKey = keyVal[1];
			
		}else if(str.length() > 14) {
			
			authDate = str.substring(0, 14);
			authKey = str.substring(14);
			
		}
		
		if(authDate.length() > 13 && !authKey.equals("")){
			
			DateTimeFormatter formatter = DateTimeFormat.forPattern("yyyyMMddHHmmss");
			
			DateTime nowDt = DateTime.now().minusMinutes(min);
			DateTime ssoDt = formatter.parseDateTime(authDate);
			
			if(ssoDt.isAfter(nowDt)){
				return authKey;
			}				
		}
		
		return "";
	}
	
	public static String AESEX_ExpirDecode(String aesType, String str, String key, int min){
		
		try{
			
			if(aesType != null && aesType.equals("AES256")) {
				str = AES256_Decode(str, key == null || key.equals("") ? "1023497555960596" : key);	
			}else {
				str = AES128_Decode(str, key == null || key.equals("") ? "1023497555960596" : key);	
			}
				
		}catch(Exception ex){
			return "";
		}
		
		String authDate = "";	//생성일자 
		String authKey = "";	//인증정보(걔정)
		
		if(str.contains("▦")){
			
			//구분자 포함
			String[] keyVal = str.split("▦", -1);			
			authDate = keyVal[0];
			authKey = keyVal[1];
			
		}else if(str.length() > 14) {
			
			authDate = str.substring(0, 14);
			authKey = str.substring(14);
			
		}
		
		if(authDate.length() > 13 && !authKey.equals("")){
			
			DateTimeFormatter formatter = DateTimeFormat.forPattern("yyyyMMddHHmmss");
			
			DateTime nowDt = DateTime.now().minusMinutes(min);
			DateTime ssoDt = formatter.parseDateTime(authDate);
			
			if(ssoDt.isAfter(nowDt)){
				return authKey;
			}				
		}
		
		return "";
	}	
	
	// 스크립트연동용 암호화 AES128
	public static String AES128SCRIPT_Decode(String inputPassWord, Boolean complicatedKeyFlag) throws IOException, NoSuchAlgorithmException, NoSuchPaddingException{
		
		String strASEPW = URLDecoder.decode(inputPassWord.substring(1), "UTF-8");
		byte[] decodeBase64 = Base64.decodeBase64(strASEPW.getBytes());
		  
		byte[] key = new byte[]{'d', 'u', 'z', 'o', 'n', '@', '1', '2', '3', '4', '1', '2', '3', '4', '1', '2'};
		
		if(complicatedKeyFlag) {
			key = new byte[]{'f', 'w', 'x', 'd', 'u', '#', '*', '1', 'g', '@', '1', '3', '8', '@', 'l', '3'};
		}

		SecretKeySpec skeySpec = new SecretKeySpec(key, "AES");

		Cipher cipher = Cipher.getInstance("AES/CBC/PKCS5Padding");
		AlgorithmParameterSpec iv = new IvParameterSpec(key);
		try{
		 cipher.init(Cipher.DECRYPT_MODE, skeySpec,iv);
		 byte[] original = cipher.doFinal(decodeBase64);
		 strASEPW = new String(original, "UTF-8");
		} catch (Exception e){
			//System.out.println(e.toString());
			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
		}
		
		return strASEPW;
		
	}
		
	public static String encryptRSA(String text, String publicKeyStr) throws Exception {
		
		Cipher cipher = Cipher.getInstance("RSA");
		PublicKey publicKey = StringToPublicKey(publicKeyStr);
		cipher.init(Cipher.ENCRYPT_MODE, publicKey);
		
		byte[] bytePlain = cipher.doFinal(text.getBytes());
		String encrypted = Base64.encodeBase64(bytePlain).toString();
		return encrypted; 
		
	}
	
	public static PublicKey StringToPublicKey(String publicKeyStr) throws Exception {
		
		KeyFactory keyFactory = null;  PublicKey publicKey = null;
		X509EncodedKeySpec ukeySpec = new X509EncodedKeySpec(Base64.decodeBase64(publicKeyStr.getBytes())); 
		keyFactory = KeyFactory.getInstance("RSA"); 
		publicKey = keyFactory.generatePublic(ukeySpec);
		
		return publicKey;
		
	}
	
	public static String decryptRSA(String encrypted, String privateKeyStr) throws Exception {
		
		Cipher cipher = Cipher.getInstance("RSA");
		byte[] byteEncrypted = Base64.decodeBase64(encrypted.getBytes());
		PrivateKey privateKey = StringToPrivateKey(privateKeyStr);
		cipher.init(Cipher.DECRYPT_MODE, privateKey);
		byte[] bytePlain = cipher.doFinal(byteEncrypted);
		String decrypted = new String(bytePlain, "utf-8");
		return decrypted; 
		
	}
	
	public static PrivateKey StringToPrivateKey(String privateKeyStr) throws Exception{
		
		PrivateKey privateKey = null;
		PKCS8EncodedKeySpec rkeySpec = new PKCS8EncodedKeySpec(Base64.decodeBase64(privateKeyStr.getBytes()));
		KeyFactory rkeyFactory = KeyFactory.getInstance("RSA");
		privateKey = rkeyFactory.generatePrivate(rkeySpec);
	 
	  return privateKey;
	  
	}
	
	

}

