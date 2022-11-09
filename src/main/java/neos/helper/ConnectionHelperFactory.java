package neos.helper;

import java.io.IOException;
import java.net.URL;

public class ConnectionHelperFactory {
	protected static final String HTTPS_PROTOCOL = "https";

	public static ConnectionHelper createInstacne(String urlString) throws IOException {
		URL url = new URL(urlString);
		
		return createInstacne(url);
	}

	public static ConnectionHelper createInstacne(URL url) throws IOException {
		AbstractConnectionHelper connectionHelper = null;
		
		if (HTTPS_PROTOCOL.equals(url.getProtocol())) {
			connectionHelper = new HttpsConnectionHelper();
		}
		else {
			connectionHelper = new HttpConnectionHelper();
		}
		
		connectionHelper.init(url);
		
		return connectionHelper;
	}
}
