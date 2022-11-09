securityEncUtil = {
	securityEncrypt: function(inputStr, level) {		
		var securityEncKey = "duzon@1234123412";
		
		if(level == 1) {
    		securityEncKey = "fwxdu#*1g@138@l3";
    	} else if(level == 0) {
    		securityEncKey = "duzon@1234123412";
    	}
		
		var key = CryptoJS.enc.Utf8.parse(securityEncKey);
		var iv = CryptoJS.enc.Utf8.parse(securityEncKey);
		var encrypted = CryptoJS.AES.encrypt(CryptoJS.enc.Utf8.parse(inputStr), key, { keySize: 128 / 8, iv: iv ,mode: CryptoJS.mode.CBC,padding: CryptoJS.pad.Pkcs7});
		var encryptedTxt = '!' + encrypted.toString();
		encryptedTxt = encodeURIComponent(encryptedTxt);
		return encryptedTxt;
	}
}