package neos.cmm.util;

import java.io.UnsupportedEncodingException;

import org.apache.commons.codec.binary.Base64;


public class SEEDCipher {

    /* 암호화 대칭 키 */
	
final static String SECRETKEY = "1023497555960596"; 

private static byte pbUserKey[]  = SECRETKEY.getBytes();

    /* CBC 대칭 키 */

private static byte bszIV[] = {

(byte)0x27,  (byte)0x28,  (byte)0x27, (byte) 0x6d,  (byte)0x2d, (byte) 0xd5,  (byte)0x4e, 

(byte)0x29,  (byte)0x2c,  (byte)0x56, (byte) 0xf4,  (byte)0x2a,  (byte)0x65,  (byte)0x2a,  (byte)0xae,  (byte)0x08

};


// 암호화 함수
public static String getSeedEnc(String data) throws UnsupportedEncodingException{
	
	byte[] enc = null;

    enc = KISA_SEED_CBC.SEED_CBC_Encrypt(pbUserKey, bszIV, data.getBytes("UTF-8"), 0, data.getBytes("UTF-8").length);
    
    return new String(Base64.encodeBase64(enc));
    
}

// 복호화 함수
public static String getSeedDec(String str) throws UnsupportedEncodingException{

	byte[] enc = Base64.decodeBase64(str.getBytes());	
	
	byte[] dec = null;
	
	dec = KISA_SEED_CBC.SEED_CBC_Decrypt(pbUserKey, bszIV, enc, 0, enc.length);
	
	return new String(dec, "UTF-8");
}


















	
}










