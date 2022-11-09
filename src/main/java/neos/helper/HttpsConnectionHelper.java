package neos.helper;

import java.net.ProtocolException;

import javax.net.ssl.HttpsURLConnection;

public class HttpsConnectionHelper extends AbstractConnectionHelper {

	HttpsConnectionHelper() {
		//TODO 개발용으로 모든 서버 인증 허가하는 코드 구현 고려
	}

	@Override
	protected void setRequestParam(String method) throws ProtocolException {
		HttpsURLConnection httpsURLConnection = (HttpsURLConnection) urlConnection;
		httpsURLConnection.setRequestMethod(method);
	}

	@Override
	protected void disconnect() {
		HttpsURLConnection httpsURLConnection = (HttpsURLConnection) urlConnection;
		httpsURLConnection.disconnect();
	}
}
