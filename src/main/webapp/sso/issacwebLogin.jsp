<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@include file="agentInfo.jsp"%>
<%

    String clientIp = request.getRemoteAddr();
    String userAgent = request.getHeader("User-Agent");
    

    System.out.println("Auth url : " + AUTHORIZATION_URL);
    System.out.println("agent id : " + agentId);
    System.out.println("clientIp : " + clientIp);
    System.out.println("userAgent : " + userAgent);
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
    <script type="text/javascript" src="webcrypto/js/forge/forge.js?v=3.0.4.5" charset="UTF-8"></script>
    <script type="text/javascript" src="webcrypto/js/forge/jsbn.js?v=3.0.4.5" charset="UTF-8"></script>
    <script type="text/javascript" src="webcrypto/js/forge/util.js?v=3.0.4.5" charset="UTF-8"></script>
    <script type="text/javascript" src="webcrypto/js/forge/sha1.js?v=3.0.4.5" charset="UTF-8"></script>
    <script type="text/javascript" src="webcrypto/js/forge/sha256.js?v=3.0.4.5" charset="UTF-8"></script>
    <script type="text/javascript" src="webcrypto/js/forge/sha512.js?v=3.0.4.5" charset="UTF-8"></script>
    <script type="text/javascript" src="webcrypto/js/forge/asn1.js?v=3.0.4.5" charset="UTF-8"></script>
    <script type="text/javascript" src="webcrypto/js/forge/cipher.js?v=3.0.4.5" charset="UTF-8"></script>
    <script type="text/javascript" src="webcrypto/js/forge/cipherModes.js?v=3.0.4.5" charset="UTF-8"></script>
    <script type="text/javascript" src="webcrypto/js/forge/seed.js?v=3.0.4.5" charset="UTF-8"></script>
    <script type="text/javascript" src="webcrypto/js/forge/aes.js?v=3.0.4.5" charset="UTF-8"></script>
    <script type="text/javascript" src="webcrypto/js/forge/prng.js?v=3.0.4.5" charset="UTF-8"></script>
    <script type="text/javascript" src="webcrypto/js/forge/random.js?v=3.0.4.5" charset="UTF-8"></script>
    <script type="text/javascript" src="webcrypto/js/forge/rsa.js?v=3.0.4.5" charset="UTF-8"></script>
    <script type="text/javascript" src="webcrypto/js/forge/pkcs1.js?v=3.0.4.5" charset="UTF-8"></script>
    <script type="text/javascript" src="webcrypto/js/webcrypto/common/webcrypto.js?v=3.0.4.5" charset="UTF-8"></script>
    <script type="text/javascript" src="webcrypto/js/webcrypto/common/webcrypto_msg.js?v=3.0.4.5" charset="UTF-8"></script>
    <script type="text/javascript" src="webcrypto/js/webcrypto/e2e/webcrypto_e2e.js?v=3.0.4.5" charset="UTF-8"></script>
    
    <script type="text/javascript" src="jquery-3.1.1.min.js"></script>
    <script type="text/javascript">
        $(function() {
            // 개발팀 서버 공개키
            var pubkey1 = 'MIGIAoGAeBZCbkJVAE1oaUiBOC/ToeE5dCpK64E9jYS8+8+wQvXbSOdPkcJTuUxs/ypW9vaqkabE37c9RVRcbXIcqoQaQ1zvv946rgpF4cV57MfbA+gudGSK+bSkTgx9bAvY3qVrkbWWS1l1u2xYwBPsYl4SltsOROpq1t/hdCQbYKLGr+MCAwEAAQA=';
            // 지원팀 서버 공개키
            var pubkey2 = 'MIGIAoGAcLXicXHD1eDSIL3D3JLb4xsQ7ooPlbKfVQ8Dg2kyWw4sGkAxPXex29fpc/RSjzRwRmCWTMZwT+r6ArMb4YgIBTzBmy/lBYWsFozwJ/meTQojBNPM+bAdp2aYSwoxsmZ8B1PyAnPDtWGzckB01YB3ZeKGmUpvKdqSYRrLuti4Y50CAwEAAQ==';

            var encrypt_header      = "encrypt_";
            var double_header       = "double_";

            var keyname1 = 'Sample1';
            var keyname2 = 'Sample2';
            var keyname3 = 'Sample3';
            var keyname4 = 'Sample4';

            function issacweb_escape(msg){
                var i;
                var ch;
                var encMsg = '';
                var tmp_msg = String(msg);

                for (i = 0; i < tmp_msg.length; i++) {
                    ch = tmp_msg.charAt(i);

                    if (ch == ' ')
                        encMsg += '%20';
                    else if (ch == '%')
                        encMsg += '%25';
                    else if (ch == '&')
                        encMsg += '%26';
                    else if (ch == '+')
                        encMsg += '%2B';
                    else if (ch == '=')
                        encMsg += '%3D';
                    else if (ch == '?')
                        encMsg += '%3F';
                    else if (ch == '|')
                        encMsg += '%7C';
                    else
                        encMsg += ch;
                }
                return encMsg;
            }
            
            var props = {
                constants : {},
                elements:{
                    $formlogin : $('#form-login'),
                    $btnLogin : $('#btn-login')
                }
            };
            
            $("#btn-login").click(function(){
                var id = $('#id').val();
                var pw = $('#pw').val();
                
                console.log(id);
                console.log(pw);
                
                if (id == undefined || id.length == 0) {
                    alert("id를 입력하세요.");
                    return;
                }
                if (pw == undefined || pw.length == 0) {
                    alert("비밀번호를 입력하세요.");
                    return;
                }
                
                var message = issacweb_escape('id') + "=" + issacweb_escape(id);
                message += "&" + issacweb_escape('pw') + "=" + issacweb_escape(pw);

                try{
                    var reqHybridEnc = webcrypto.e2e.hybridEncrypt(keyname1, message, 
                            'UTF-8', 'SEED', pubkey1, 'RSAES-OAEP', 'RSA-SHA1');
                    
                    reqHybridEnc.onerror = function(errMsg) { alert(errMsg); };
                    reqHybridEnc.oncomplete = function(result) {
                        
                        if(result === "") {
                            alert("issacweb_data is null");
                            return;
                        }
                        
                        var agentId = $('#agentId').val();
                        var userId = $('#userId').val();
                        var issacwebData = result;
                        
                        var action = "<%=AUTHORIZATION_URL%>" + "authentication/issacweb/loginProcess";
                        var form = $('<form action=' + action + ' method="post">'
                            + '<input type="hidden" name="agentId" value="' + agentId + '" />'
                            + '<input type="hidden" name="userId" value="' + userId + '" />'
                            + '<input type="hidden" name="issacwebData" value="' + issacwebData + '" />'
                            + '</form>');
                        $('body').append(form);
                        form.submit();
                    };
                }catch(e){
                    if (e.message) {
                        alert(e.message);
                    } else {
                        alert(e);
                    }
                }
            });
            
            $("#pw").keydown(function(key) {
                if(key.keyCode == 13) {
                    $("#btn-login").click();
                }
                
            });
        });
    </script>
    <meta charset="UTF-8">
    <title>login page</title>
<body>

<h1>issacweb login page</h1>
<form id="form-login">
    <input type="hidden" id="agentId" name="agentId" value="<%=agentId%>">
    <input type="hidden" id="issacwebData" name="issacwebData">
    <input type="text" id="id"name="id" placeholder="loginId">
    <input type="password" id="pw" name="pw" placeholder="loginPw">
    <button type="button" id="btn-login">로그인</button>
</form>
</body>
</html>
