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
import javax.crypto.IllegalBlockSizeException;
import javax.crypto.NoSuchPaddingException;

import com.sun.star.security.KeyException;

/**
 *<pre>
 * 1. Package Name	: neos.cmm.encrypt
 * 2. Class Name	: Encryptor.java
 * 3. Description	:
 * ------- 개정이력(Modification Information) ----------
 *    작성일            작성자         작성정보
 *    2012. 10. 5.     kshmem       최초작성
 *  -----------------------------------------------------
 *</pre>
 */

public interface Encryptor {


    public final String KEY = "dk2fjl9skjj5flwoiwerlkzxkdadlesr";/*암호화 키*/
    public final String CHAR_ENC = "UTF-8"; /*인코딩 방식*/
    public final String CIPHER = "AES/CBC/PKCS5Padding"; /*암호화방식/운용방식/패딩*/
    public final String ALGORITHM = "AES"; /*알고리즘이름*/

    public String encrypt(String plainText)throws UnsupportedEncodingException, InvalidKeyException, NoSuchAlgorithmException, NoSuchPaddingException, InvalidAlgorithmParameterException, IllegalBlockSizeException, BadPaddingException;
    public String decrypt(String encryptedText) throws KeyException, GeneralSecurityException, GeneralSecurityException, InvalidAlgorithmParameterException, IllegalBlockSizeException, BadPaddingException, IOException;
}


