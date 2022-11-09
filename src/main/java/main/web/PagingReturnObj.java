package main.web;

import java.util.List;
import java.util.Map;

public class PagingReturnObj {

	public List<Map<String,Object>> resultgrid;
	private long totalcount;

	//getter & setter
	public List<Map<String,Object>> getResultgrid() {
		return resultgrid;
	}
	public void setResultgrid(List<Map<String,Object>> resultgrid) {
		this.resultgrid = resultgrid;
	}
	public long getTotalcount() {
		return totalcount;
	}
	public void setTotalcount(long totalcount) {
		this.totalcount = totalcount;
	}
}