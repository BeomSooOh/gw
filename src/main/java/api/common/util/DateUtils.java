package api.common.util;

import java.text.SimpleDateFormat;
import java.util.Date;

public class DateUtils {
	public static final String DFYYYYMMDD  = "yyyyMMdd";
	public static final String DFHHMMSS  = "HHmmss";
	
	public static String getCurrentTime(String format) {
	        Date now = new Date();
	        if(format == null) {
	        	format = DFYYYYMMDD;
	        }
	        SimpleDateFormat formatter = new SimpleDateFormat(format);
	        return formatter.format(now);
	}
	
	public static String getCurrentTime(){		 
		 return getCurrentTime(null);
		
	}
	
	public static String getShortDate(String format){
		 if(format == null) {
			 format = DFHHMMSS;
		 }
		 return getCurrentTime(format);
		
	}
	public static String getShortDate(){
		 return getCurrentTime(DFHHMMSS);
		
	}
	//제거되지 않고 남은 디버그 코드
	/**
	 * @param args
	 */
//	public static void main(String[] args) {
//		/*
//		System.out.println(DateUtils.getCurrentTime());
//		System.out.println(DateUtils.getShortDate());
//		System.out.println(DateUtils.getCurrentTime("yyyyMMddHHmmss"));
//		*/
//	}
}
