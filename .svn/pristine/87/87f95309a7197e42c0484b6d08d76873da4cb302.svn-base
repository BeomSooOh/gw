package neos.helper;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.io.UnsupportedEncodingException;
import java.net.ProtocolException;
import java.net.URL;
import java.net.URLConnection;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

public abstract class AbstractConnectionHelper implements ConnectionHelper {
	private static final int BUFFER_SIZE = 10 * 1024;

	private Log logger = LogFactory.getLog(AbstractConnectionHelper.class);
	
	public static final int CONNECT_TIMEOUT = 5000;
	
	public static final int READ_TIMEOUT = 60000;

	public static final String UTF8_ENCODING = "utf-8";
	
	public static final String HTTP_METHOD_GET = "GET";

	public static final String HTTP_METHOD_POST = "POST";
	
	protected URLConnection urlConnection;

	private boolean isCancelled = false;
	
	void init(URL url) throws IOException {
		this.urlConnection = url.openConnection();
	}

	public void setConnectionParam(String method) throws ProtocolException {
		urlConnection.setConnectTimeout(CONNECT_TIMEOUT);
		urlConnection.setReadTimeout(READ_TIMEOUT);
		urlConnection.setDoInput(true);
		urlConnection.setDoOutput(true);
		urlConnection.setUseCaches(false);
		setRequestParam(method);
	}
	
	public void setRequestProperty(String key, String value){
		urlConnection.setRequestProperty(key, value);
	}

	abstract protected void setRequestParam(String method) throws ProtocolException;
	
	abstract protected void disconnect();
	
	@Override
	public String requestData(String json) throws IOException {
		setConnectionParam(HTTP_METHOD_POST);
		urlConnection.setDoInput(true);
		urlConnection.setDoOutput(true);
		
		byte[] data = json.getBytes(UTF8_ENCODING);
		urlConnection.setRequestProperty("Content-Length", String.valueOf(data.length));
		urlConnection.setRequestProperty("Content-Type", "application/json; charset=utf-8");
		
		synchronized(this) {
			if (isCancelled) {
				return null;
			}
		}
		
		urlConnection.connect();
		logger.debug(urlConnection.getURL().toString() + " connected");

		OutputStream out = null;
		try {
			out = urlConnection.getOutputStream();
			out.write(data);
			out.flush();
		} finally {
			if (out != null)
			{
				try { out.close(); }
				catch (Exception ignore) {
					return readData();
				}
			}
		}
		
		return readData();
	}
	
	@Override
	public void requestData() throws IOException {
//		setConnectionParam(HTTP_METHOD_GET);
//		urlConnection.setDoInput(true);
		
		synchronized(this) {
			if (isCancelled) {
				return;
			}
		}
		
		urlConnection.connect();
		logger.debug(urlConnection.getURL().toString() + " connected");
	}
	
	public void setRequestContent(String content) throws UnsupportedEncodingException, IOException{
		OutputStream os = urlConnection.getOutputStream();
		os.write(content.getBytes("UTF-8"));
		
		if(os != null) {
			try{ os.close(); } catch(Exception ignore) {
				return;
			}
		}
	}

	
	public void cancel() {
		synchronized(this) {
			isCancelled = true;
		}
	}

	@Override
	public String readData() throws IOException {
		InputStream in  = null;
		String data = "";
		try {
			in = urlConnection.getInputStream();
			ByteArrayOutputStream stream = new ByteArrayOutputStream();

    		synchronized(this) {
    			if (isCancelled) {
    				return null;
    			}
    		}
			
			byte[] buffer = new byte[BUFFER_SIZE];
            int len = 0;
            
            while ((len = in.read(buffer)) != -1) {
        		synchronized(this) {
        			if (isCancelled) {
        				return null;
        			}
        		}
                stream.write(buffer, 0, len);
            }
            
            data = new String(stream.toByteArray(), UTF8_ENCODING);
		} finally {
			if (in != null) {
				try { in.close(); } catch (Exception ignore) {
					if (urlConnection != null) {
						disconnect();
					}	
					return data;
				}
			}
			
			if (urlConnection != null) {
				disconnect();
			}
		}
		
		return data;
	}
	
	public String getHeaderCookie(){
		return urlConnection.getHeaderFields().get("Set-Cookie").get(0);
	}
}
