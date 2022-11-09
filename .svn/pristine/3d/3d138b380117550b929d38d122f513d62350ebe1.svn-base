package neos.cmm.util;

import java.util.Map;

public class HttpUtilThread extends Thread {
	private String method ;
	private String url ;
	private Map<String, String> parameters ;
	public HttpUtilThread(String method, String url,  Map<String, String> parameters) {
		this.method  = method ;
		this.url = url ;
		this.parameters = parameters ;
		
	}
	
	public void run() {
		HttpUtil.execute(method, url, parameters) ;
	}
}
