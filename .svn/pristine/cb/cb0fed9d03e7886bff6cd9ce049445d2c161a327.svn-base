package neos.cmm.util;

import java.io.IOException;
import java.security.InvalidKeyException;
import java.security.Key;
import java.security.spec.InvalidKeySpecException;
import javax.crypto.BadPaddingException;
import javax.crypto.Cipher;
import javax.crypto.IllegalBlockSizeException;
import javax.crypto.SecretKeyFactory;
import javax.crypto.spec.DESedeKeySpec;
import com.sun.jndi.toolkit.chars.BASE64Decoder;
import com.sun.jndi.toolkit.chars.BASE64Encoder;

public class UtilCryptoOuter { 
 private Key keyMulticampus = null;
 private Cipher cipher = null;
 private DESedeKeySpec kspec = null;
 private SecretKeyFactory skf= null;
 private String keyvalue = null;

 public UtilCryptoOuter() {
  try {
   cipher = Cipher.getInstance("DESede");
   skf= SecretKeyFactory.getInstance("DESede");
  } catch (Exception e) {
	  CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
  }
 }
 
 public void setKey(String in) throws InvalidKeyException, InvalidKeySpecException{
  keyvalue = in;
  kspec = new DESedeKeySpec(keyvalue.getBytes());
  keyMulticampus = skf.generateSecret(kspec);
 }
 public String encrypt3DES(String input) throws InvalidKeyException, BadPaddingException, IllegalBlockSizeException {
  cipher.init(Cipher.ENCRYPT_MODE, keyMulticampus);
  return ((new BASE64Encoder()).encode(cipher.doFinal(input.getBytes()))).replaceAll("\r\n","");
 }
 
 public String decrypt3DES(String input) throws InvalidKeyException, BadPaddingException, IllegalBlockSizeException, IOException {
  byte[] encryptionBytes = new BASE64Decoder().decodeBuffer(input);
  cipher.init(Cipher.DECRYPT_MODE, keyMulticampus);
  return  new String(cipher.doFinal(encryptionBytes),"UTF-8");
 }  
}
