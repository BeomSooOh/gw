package api.fax.model;

import java.util.UUID;

public class FaxRequestHeader {
	public String tId;
	
	public FaxRequestHeader(){
		this.tId = UUID.randomUUID().toString().toUpperCase();
	}
	
	public String gettId() {
		return tId;
	}

	public void settId(String tId) {
		this.tId = tId;
	}
}
