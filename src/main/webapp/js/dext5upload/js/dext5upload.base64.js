var Dext5Base64={_keyStr:"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=",_trans_unitDelimiter:"\x0B",_trans_unitAttributeDelimiter:"\f",encode:function(a){var b="",d,c,f,g,h,e,k=0;for(a=Dext5Base64._utf8_encode(a);k<a.length;)d=a.charCodeAt(k++),c=a.charCodeAt(k++),f=a.charCodeAt(k++),g=d>>2,d=(d&3)<<4|c>>4,h=(c&15)<<2|f>>6,e=f&63,isNaN(c)?h=e=64:isNaN(f)&&(e=64),b=b+this._keyStr.charAt(g)+this._keyStr.charAt(d)+this._keyStr.charAt(h)+this._keyStr.charAt(e);return b},decode:function(a){var b=
"",d,c,f,g,h,e=0;for(a=a.replace(/[^A-Za-z0-9\+\/\=]/g,"");e<a.length;)d=this._keyStr.indexOf(a.charAt(e++)),c=this._keyStr.indexOf(a.charAt(e++)),g=this._keyStr.indexOf(a.charAt(e++)),h=this._keyStr.indexOf(a.charAt(e++)),d=d<<2|c>>4,c=(c&15)<<4|g>>2,f=(g&3)<<6|h,b+=String.fromCharCode(d),64!=g&&(b+=String.fromCharCode(c)),64!=h&&(b+=String.fromCharCode(f));return b=Dext5Base64._utf8_decode(b)},_utf8_encode:function(a){a=a.replace(/\r\n/g,"\n");for(var b="",d=0;d<a.length;d++){var c=a.charCodeAt(d);
128>c?b+=String.fromCharCode(c):(127<c&&2048>c?b+=String.fromCharCode(c>>6|192):(b+=String.fromCharCode(c>>12|224),b+=String.fromCharCode(c>>6&63|128)),b+=String.fromCharCode(c&63|128))}return b},_utf8_decode:function(a){for(var b="",d=0,c=c1=c2=0;d<a.length;)c=a.charCodeAt(d),128>c?(b+=String.fromCharCode(c),d++):191<c&&224>c?(c2=a.charCodeAt(d+1),b+=String.fromCharCode((c&31)<<6|c2&63),d+=2):(c2=a.charCodeAt(d+1),c3=a.charCodeAt(d+2),b+=String.fromCharCode((c&15)<<12|(c2&63)<<6|c3&63),d+=3);return b},
makeEncryptParam:function(a){a=Dext5Base64.encode(a);a="R"+a;a=Dext5Base64.encode(a);return a=a.replace(/[+]/g,"%2B")},makeDecryptReponseMessage:function(a){a=Dext5Base64.decode(a);a=a.substring(1);return a=Dext5Base64.decode(a)}};
