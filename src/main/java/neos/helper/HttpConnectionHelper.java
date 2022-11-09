package neos.helper;

import java.net.HttpURLConnection;
import java.net.ProtocolException;

public class HttpConnectionHelper  extends AbstractConnectionHelper {

	@Override
	protected void setRequestParam(String method) throws ProtocolException {
		HttpURLConnection httpURLConnection = (HttpURLConnection) urlConnection;
		httpURLConnection.setRequestMethod(method);
	}

	@Override
	protected void disconnect() {
		HttpURLConnection httpURLConnection = (HttpURLConnection) urlConnection;
		httpURLConnection.disconnect();
	}
}
