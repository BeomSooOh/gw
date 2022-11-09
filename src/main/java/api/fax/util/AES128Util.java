package api.fax.util;
 
import java.security.InvalidAlgorithmParameterException;
import java.security.InvalidKeyException;
import java.security.NoSuchAlgorithmException;
import java.util.Properties;

import javax.crypto.BadPaddingException;
import javax.crypto.Cipher;
import javax.crypto.IllegalBlockSizeException;
import javax.crypto.NoSuchPaddingException;
import javax.crypto.SecretKey;
import javax.crypto.spec.IvParameterSpec;
import javax.crypto.spec.SecretKeySpec;

import org.apache.commons.codec.binary.Base64;

public class AES128Util { 
	// 키컴과 약속한 AES128 암호화 키. 임의 변경 금지
	final static String SECRETKEY = "QdK87givadQacYWj"; 
	final static IvParameterSpec iv = new IvParameterSpec(new byte[] {0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00});
	final static String SERVERENCODING = "MS949";
	
	// 암호화
	public static String AES_Encode(String str)
			throws java.io.UnsupportedEncodingException,
			NoSuchAlgorithmException, NoSuchPaddingException,
			InvalidKeyException, InvalidAlgorithmParameterException,
			IllegalBlockSizeException, BadPaddingException {
		
		Properties prop = new Properties();
		String key = SECRETKEY == null ? (String)prop.getProperty("key") : "QdK87givadQacYWj";
		
		byte[] keyData = key.getBytes();

		SecretKey secureKey = new SecretKeySpec(keyData, "AES");

		Cipher c = Cipher.getInstance("AES/CBC/PKCS5Padding");
		c.init(Cipher.ENCRYPT_MODE, secureKey, iv);

		byte[] encrypted = c.doFinal(str.getBytes(SERVERENCODING));
		return new String(Base64.encodeBase64(encrypted));
	}

	// 복호화
	public static String AES_Decode(String str)
			throws java.io.UnsupportedEncodingException,
			NoSuchAlgorithmException, NoSuchPaddingException,
			InvalidKeyException, InvalidAlgorithmParameterException,
			IllegalBlockSizeException, BadPaddingException {
		Properties prop = new Properties();
		String key = SECRETKEY == null ? (String)prop.getProperty("key") : "QdK87givadQacYWj";
		
		byte[] keyData = key.getBytes();
		SecretKey secureKey = new SecretKeySpec(keyData, "AES");
		Cipher c = Cipher.getInstance("AES/CBC/PKCS5Padding");
		c.init(Cipher.DECRYPT_MODE, secureKey, iv);

		byte[] byteStr = Base64.decodeBase64(str.getBytes());

		return new String(c.doFinal(byteStr), SERVERENCODING);
	}
}
