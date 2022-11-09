/*
 * Copyright kshmem by Duzon Newturns.,
 * All rights reserved.
 */
package neos.cmm.encrypt;

import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.security.GeneralSecurityException;
import java.security.InvalidAlgorithmParameterException;
import java.security.InvalidKeyException;
import java.security.NoSuchAlgorithmException;

import javax.crypto.BadPaddingException;
import javax.crypto.Cipher;
import javax.crypto.IllegalBlockSizeException;
import javax.crypto.NoSuchPaddingException;
import javax.crypto.spec.IvParameterSpec;
import javax.crypto.spec.SecretKeySpec;

import org.springframework.stereotype.Service;

import com.sun.star.security.KeyException;

/**
 *<pre>
 * 1. Package Name	: neos.cmm.encrypt
 * 2. Class Name	: AESEncryptor.java
 * 3. Description	:
 * ------- 개정이력(Modification Information) ----------
 *    작성일            작성자         작성정보
 *    2012. 10. 5.     kshmem       최초작성
 *  -----------------------------------------------------
 *</pre>
 */

@Service("Encryptor")
public class AESEncryptor implements Encryptor{





     private  byte[] decrypt(byte[] cipherText, byte[] key, byte [] initialVector) throws NoSuchAlgorithmException, NoSuchPaddingException,
                                         InvalidKeyException, InvalidAlgorithmParameterException, IllegalBlockSizeException, BadPaddingException{



         Cipher cipher = Cipher.getInstance(CIPHER);

         SecretKeySpec secretKeySpecy = new SecretKeySpec(key, ALGORITHM);

         IvParameterSpec ivParameterSpec = new IvParameterSpec(initialVector);

         cipher.init(Cipher.DECRYPT_MODE, secretKeySpecy, ivParameterSpec);

         cipherText = cipher.doFinal(cipherText);

         return cipherText;

     }



     private byte[] encrypt(byte[] plainText, byte[] key, byte [] initialVector) throws NoSuchAlgorithmException, NoSuchPaddingException, InvalidKeyException, InvalidAlgorithmParameterException, IllegalBlockSizeException, BadPaddingException

     {

         Cipher cipher = Cipher.getInstance(CIPHER);

         SecretKeySpec secretKeySpec = new SecretKeySpec(key, ALGORITHM);

         IvParameterSpec ivParameterSpec = new IvParameterSpec(initialVector);

         cipher.init(Cipher.ENCRYPT_MODE, secretKeySpec, ivParameterSpec);

         plainText = cipher.doFinal(plainText);


         return plainText;

     }



     private byte[] getKeyBytes(String key) throws UnsupportedEncodingException{

         byte[] keyBytes= new byte[16];

         byte[] parameterKeyBytes= key.getBytes(CHAR_ENC);

         System.arraycopy(parameterKeyBytes, 0, keyBytes, 0, Math.min(parameterKeyBytes.length, keyBytes.length));

         return keyBytes;

     }



     /// <summary>

     /// Encrypts plaintext using AES 128bit key and a Chain Block Cipher and returns a base64 encoded string

     /// </summary>

     /// <param name="plainText">Plain text to encrypt</param>

     /// <param name="key">Secret key</param>

     /// <returns>Base64 encoded string</returns>

     private String encrypt(String plainText, String key) throws UnsupportedEncodingException, InvalidKeyException, NoSuchAlgorithmException, NoSuchPaddingException, InvalidAlgorithmParameterException, IllegalBlockSizeException, BadPaddingException{

         byte[] plainTextbytes = plainText.getBytes(CHAR_ENC);

         byte[] keyBytes = getKeyBytes(key);

         return new String(org.apache.commons.codec.binary.Base64.encodeBase64(encrypt(plainTextbytes,keyBytes, keyBytes)), CHAR_ENC);
     }


     /// <summary>

     /// Decrypts a base64 encoded string using the given key (AES 128bit key and a Chain Block Cipher)

     /// </summary>

     /// <param name="encryptedText">Base64 Encoded String</param>

     /// <param name="key">Secret Key</param>

     /// <returns>Decrypted String</returns>

     private String decrypt(String encryptedText, String key) throws KeyException, GeneralSecurityException, GeneralSecurityException, InvalidAlgorithmParameterException, IllegalBlockSizeException, BadPaddingException, IOException{

         byte[] cipheredBytes = org.apache.commons.codec.binary.Base64.decodeBase64(encryptedText.getBytes(CHAR_ENC));

         byte[] keyBytes = getKeyBytes(key);

         return new String(decrypt(cipheredBytes, keyBytes, keyBytes), CHAR_ENC);

     }

    @Override
    public String encrypt(String plainText)
                                       throws UnsupportedEncodingException, InvalidKeyException,
                                       NoSuchAlgorithmException, NoSuchPaddingException,
                                       InvalidAlgorithmParameterException,
                                       IllegalBlockSizeException, BadPaddingException {

        return encrypt(plainText, KEY);
    }



    @Override
    public String decrypt(String encryptedText)
                                               throws KeyException, GeneralSecurityException,
                                               GeneralSecurityException,
                                               InvalidAlgorithmParameterException,
                                               IllegalBlockSizeException, BadPaddingException,
                                               IOException {
        return decrypt(encryptedText, KEY);
    }

}


