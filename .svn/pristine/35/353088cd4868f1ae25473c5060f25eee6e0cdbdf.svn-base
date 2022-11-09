package neos.cmm.util;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.io.UnsupportedEncodingException;
import java.net.HttpURLConnection;
import java.net.MalformedURLException;
import java.net.URL;
import java.net.URLEncoder;
import java.util.Iterator;
import java.util.Map;
import java.util.Map.Entry;
import java.util.Set;

import javax.net.ssl.HttpsURLConnection;

import org.apache.log4j.Logger;

import net.sf.json.JSONObject;

public class HttpJsonUtil {
	
	/**
	 * resource를 요청한다.
	 * @param URL
	 * @param parameters : access_token, scope, redirect_url, client_id, client_secret
	 * @return String : JSON
	 */
	public static String getResourcesToString(String url, JSONObject parameters){
		String method = "POST";
		String result = execute(method, url, parameters);
		return result;
	}	
	
	/**
	 * request and response
	 * @param method : POST/GET
	 * @param url
	 * @param parameters
	 * @return
	 */
	public static String execute(String method, final String url, final JSONObject parameters) {
		HttpURLConnection connection = null;
		
		String result ="";
		int methodCase = 0;
		if(method.toUpperCase().equals("POST")) {
			methodCase = 1;
		}
		try {
			switch (methodCase) {
				case 0:
					connection = openConnection(url.concat("?").concat(formEncode(parameters)));
					connection.setRequestMethod("GET");
					connection.setConnectTimeout(3000);
					connection.connect();
					break;
				case 1:
					connection = openConnection(url);
					connection.setRequestMethod("POST");
					connection.setDoOutput(true);
					connection.setRequestProperty("Content-Type", "application/json");
					connection.setConnectTimeout(3000);
					connection.connect();
					final OutputStream out = connection.getOutputStream();
					
					out.write(parameters.toString().getBytes());
					out.flush();
					out.close();
					break;
					
				default:break;
			}
			if(connection!=null) {//Null Pointer 역참조
				final int statusCode = connection.getResponseCode();
				if (statusCode / 100 != 2) {
					// 400, 401, 501
					result = "{\"error\":"+statusCode+"}";
				}else{
					result = readInputStream(connection.getInputStream());
				}
			}
		} catch (IOException e) {
			Logger.getLogger( HttpJsonUtil.class ).error( "HttpJsonUtil.execute--Error : ", e);
			return result;
		} finally {
			if (connection != null) {
				connection.disconnect();
			}
		}
		
		return result;
	}
	
	
	
	/**
	 * request and response, headers Custom Setting
	 * @param method : POST
	 * @param url
	 * @param parameters
	 * @return
	 */
	public static String execute(final String url, final JSONObject parameters, Map<String,Object> custHeader) {
		HttpURLConnection connection = null;
		String result ="";
		int methodCase = 0;

		try {
			connection = openConnection(url, custHeader);
			connection.setRequestMethod("POST");
			connection.setDoOutput(true);
			connection.setRequestProperty("Content-Type", "application/json");
			connection.connect();
			final OutputStream out = connection.getOutputStream();
		
			//out.write(formEncode(parameters).getBytes());
			
			out.write(parameters.toString().getBytes());
			out.flush();
			out.close();
			
			final int statusCode = connection.getResponseCode();
			if (statusCode / 100 != 2) {
				// 400, 401, 501
				result = "{\"error\":"+statusCode+"}";
			}else{
				result = readInputStream(connection.getInputStream());
			}
		} catch (IOException e) {
			return result;
		} finally {
			if (connection != null) {
				connection.disconnect();
			}
		}
		
		return result;
	}
	
	public static String executeCustom(String method, String url, Map<String,Object> parameters, Map<String,Object> custHeader) throws MalformedURLException, IOException {
		
		if(url.toUpperCase().contains("HTTPS://")) {
			return executeCustomSSL(method, url, parameters, custHeader);
		}
		
		HttpURLConnection connection = (HttpURLConnection) new URL(url).openConnection();
		String result = null;

		try {

			if(custHeader != null) {
				
				Set key = custHeader.keySet();

				for (Iterator iterator = key.iterator(); iterator.hasNext();) {
					String keyName = (String) iterator.next();
					String valueName = (String) custHeader.get(keyName);
					connection.setRequestProperty(keyName, valueName);
				}	
				
			}
			
			connection.setRequestMethod(method);
			
			if(!method.equals("GET")) {
				connection.setDoInput(true);
				connection.setDoOutput(true);
				if(custHeader.get("Content-Type") == null || custHeader.get("Content-Type").equals("")) {
					connection.setRequestProperty("Content-Type", "application/x-www-form-urlencoded");	
				}				
			}
			
			connection.connect();

			if(!method.equals("GET")) {
				final OutputStream out = connection.getOutputStream();
				out.write(formEncodeCust(parameters).getBytes());
				out.flush();
				out.close();		
			}			
			
			final int statusCode = connection.getResponseCode();
			if (statusCode / 100 != 2) {
				return result;
			}else{
				result = readInputStream(connection.getInputStream());
			}
		} catch (IOException e) {
			return result;
		} finally {
			if (connection != null) {
				connection.disconnect();
			}
		}
		
		return result;
	}
	
	public static String executeCustomSSL(String method, String url, Map<String,Object> parameters, Map<String,Object> custHeader) throws MalformedURLException, IOException {
		
		HttpsURLConnection connection = (HttpsURLConnection) new URL(url).openConnection();
		String result = null;

		try {

			if(custHeader != null) {
				
				Set key = custHeader.keySet();

				for (Iterator iterator = key.iterator(); iterator.hasNext();) {
					String keyName = (String) iterator.next();
					String valueName = (String) custHeader.get(keyName);
					connection.setRequestProperty(keyName, valueName);
				}	
				
			}
			
			connection.setRequestMethod(method);
			
			if(!method.equals("GET")) {
				connection.setDoInput(true);
				connection.setDoOutput(true);
				
				if(custHeader.get("Content-Type") == null || custHeader.get("Content-Type").equals("")) {
					connection.setRequestProperty("Content-Type", "application/x-www-form-urlencoded");	
				}
			}
			
			connection.connect();

			if(!method.equals("GET")) {
				final OutputStream out = connection.getOutputStream();
				out.write(formEncodeCust(parameters).getBytes());
				out.flush();
				out.close();		
			}			
			
			final int statusCode = connection.getResponseCode();
			if (statusCode / 100 != 2) {
				return result;
			}else{
				result = readInputStream(connection.getInputStream());
			}
		} catch (IOException e) {
			return result;
		} finally {
			if (connection != null) {
				connection.disconnect();
			}
		}
		
		return result;
	}		
	
	
	
public static String executeCustomSSLnoEncoding(String method, String url, Map<String,Object> parameters, Map<String,Object> custHeader) throws MalformedURLException, IOException {
		
		HttpsURLConnection connection = (HttpsURLConnection) new URL(url).openConnection();
		String result = null;

		try {

			if(custHeader != null) {
				
				Set key = custHeader.keySet();

				for (Iterator iterator = key.iterator(); iterator.hasNext();) {
					String keyName = (String) iterator.next();
					String valueName = (String) custHeader.get(keyName);
					connection.setRequestProperty(keyName, valueName);
				}	
				
			}
			
			connection.setRequestMethod(method);
			
			if(!method.equals("GET")) {
				connection.setDoInput(true);
				connection.setDoOutput(true);
				
				if(custHeader.get("Content-Type") == null || custHeader.get("Content-Type").equals("")) {
					connection.setRequestProperty("Content-Type", "application/x-www-form-urlencoded");	
				}
			}
			
			connection.connect();

			if(!method.equals("GET")) {
				final OutputStream out = connection.getOutputStream();
//				out.write(formEncodeCust(parameters).getBytes());
				out.write(parameters.toString().getBytes());
				out.flush();
				out.close();		
			}			
			
			final int statusCode = connection.getResponseCode();
			if (statusCode / 100 != 2) {
				return result;
			}else{
				result = readInputStream(connection.getInputStream());
			}
		} catch (IOException e) {
			return result;
		} finally {
			if (connection != null) {
				connection.disconnect();
			}
		}
		
		return result;
	}		
	
	/**
	 * read InputStream 
	 * @param is
	 * @return
	 * @throws IOException
	 */
	public static String readInputStream(InputStream is) throws IOException{
		StringBuilder sb = new StringBuilder();
		BufferedReader in = new BufferedReader(new InputStreamReader(is,"utf-8"));
		String inputLine;
		while ((inputLine = in.readLine()) != null){
			sb.append(inputLine);
		}
		return sb.toString();
	}

	/**
	 * Not Auth
	 * @param url
	 * @return
	 * @throws IOException
	 */
	private static HttpURLConnection openConnection(final String url) throws IOException {
		final HttpURLConnection connection = (HttpURLConnection) new URL(url).openConnection();
		connection.setInstanceFollowRedirects(true);
		connection.setRequestProperty("Accept", "application/xhtml+xml,application/xml,text/xml;q=0.9,*/*;q=0.8");
		connection.setRequestProperty("Accept-Language", "en-us,ko-kr;q=0.7,en;q=0.3");
		connection.setRequestProperty("Accept-Encoding", "deflate");
		connection.setRequestProperty("Accept-Charset", "utf-8");
		connection.setRequestProperty("Authorization", "No");
		return connection;
	}	
	
	
	/**
	 * Not Auth
	 * @param url
	 * @return
	 * @throws IOException
	 */
	private static HttpURLConnection openConnection(final String url, Map<String, Object> custHeader) throws IOException {
		final HttpURLConnection connection = (HttpURLConnection) new URL(url).openConnection();
		connection.setInstanceFollowRedirects(true);
		connection.setRequestProperty("Accept", "application/xhtml+xml,application/xml,text/xml;q=0.9,*/*;q=0.8");
		connection.setRequestProperty("Accept-Language", "en-us,ko-kr;q=0.7,en;q=0.3");
		connection.setRequestProperty("Accept-Encoding", "deflate");
		connection.setRequestProperty("Accept-Charset", "utf-8");
		connection.setRequestProperty("Authorization", "No");

		Set key = custHeader.keySet();

		for (Iterator iterator = key.iterator(); iterator.hasNext();) {
			String keyName = (String) iterator.next();
			String valueName = (String) custHeader.get(keyName);
			connection.setRequestProperty(keyName, valueName);
		}
		return connection;
	}	

	/**
	 * for GET request url encoder
	 * @param parameters
	 * @return
	 */
	public static String formEncode(final Map<String, String> parameters) {
		final StringBuilder builder = new StringBuilder();
		boolean isFirst = true;
		for (final Map.Entry<String, String> parameter : parameters.entrySet()) {
			if (isFirst) {
				isFirst = false;
			}
			else {
				builder.append("&");
			}
			final String key = parameter.getKey();
			if (key == null) {
				continue;
			}
			builder.append(urlEncode(key));
			builder.append("=");
			builder.append(urlEncode(parameter.getValue()));
		}

		return builder.toString();
	}
	
	public static String formEncodeCust(final Map<String, Object> parameters) {
		final StringBuilder builder = new StringBuilder();
		boolean isFirst = true;
		for (final Entry<String, Object> parameter : parameters.entrySet()) {
			if (isFirst) {
				isFirst = false;
			}
			else {
				builder.append("&");
			}
			final String key = parameter.getKey();
			if (key == null) {
				continue;
			}
			builder.append(urlEncode(key));
			builder.append("=");
			builder.append(urlEncode(parameter.getValue().toString()));
		}

		return builder.toString();
	}	

	private static String urlEncode(final String s) {
		if (s == null) {
			return "";
		}
		try {
			return URLEncoder.encode(s.trim(), "UTF-8").replace("+", "%20").replace("*", "%2A").replace("%7E", "~");
		} catch (final UnsupportedEncodingException e) {
			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
			// ignore.
		}
		return "";
	}
	
public static String executeCustomSSLTimeOut(String method, String url, Map<String,Object> parameters, Map<String,Object> custHeader, int timeout) throws MalformedURLException, IOException {
		
		HttpsURLConnection connection = (HttpsURLConnection) new URL(url).openConnection();
		String result = null;

		try {
			
			if(custHeader != null) {
				
				Set key = custHeader.keySet();

				for (Iterator iterator = key.iterator(); iterator.hasNext();) {
					String keyName = (String) iterator.next();
					String valueName = (String) custHeader.get(keyName);
					connection.setRequestProperty(keyName, valueName);
				}	
			}
			
			connection.setConnectTimeout(timeout);
			connection.setRequestMethod(method);
			
			if(!method.equals("GET")) {
				connection.setDoInput(true);
				connection.setDoOutput(true);
				
				if(custHeader.get("Content-Type") == null || custHeader.get("Content-Type").equals("")) {
					connection.setRequestProperty("Content-Type", "application/x-www-form-urlencoded");	
				}
			}
			
			connection.connect();

			if(!method.equals("GET")) {
				final OutputStream out = connection.getOutputStream();
				out.write(formEncodeCust(parameters).getBytes());
				out.flush();
				out.close();		
			}			
			
			final int statusCode = connection.getResponseCode();
			if (statusCode / 100 != 2) {
				return result;
			}else{
				result = readInputStream(connection.getInputStream());
			}
		} catch (IOException e) {
			return result;
		} finally {
			if (connection != null) {
				connection.disconnect();
			}
		}
		
		return result;
	}		

}
