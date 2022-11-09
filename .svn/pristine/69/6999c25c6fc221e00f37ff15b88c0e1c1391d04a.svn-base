package neos.cmm.util;

import org.jasypt.encryption.pbe.StandardPBEStringEncryptor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
 
@Component
public class DecryptUtil {
     
    private static StandardPBEStringEncryptor standardPBEStringEncryptor;
     
    private static final String PREFIX_ENC = "ENC(";
     
    @Autowired
    private DecryptUtil(StandardPBEStringEncryptor standardPBEStringEncryptor) {
        this.standardPBEStringEncryptor = standardPBEStringEncryptor;
    }
     
    public static String decrypt(String encryptedValue) {
        if(encryptedValue.startsWith(PREFIX_ENC)) {
            encryptedValue = encryptedValue.substring(4, encryptedValue.length()-1);
            encryptedValue = standardPBEStringEncryptor.decrypt(encryptedValue);
        }
        return encryptedValue;
    }
     
}
