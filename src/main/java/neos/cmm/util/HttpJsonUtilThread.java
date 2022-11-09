package neos.cmm.util;

import net.sf.json.JSONObject;

public class HttpJsonUtilThread extends Thread {
	private String method ;
	private String url ;
	private JSONObject parameters ;
	public HttpJsonUtilThread(String method, String url,  JSONObject parameters) {
		this.method  = method ;
		this.url = url ;
		this.parameters = parameters ;
		
	}
	
	public void run() {
		HttpJsonUtil.execute(method, url, parameters) ;
	}
}
