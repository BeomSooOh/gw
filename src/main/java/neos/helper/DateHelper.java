package neos.helper;

import java.text.SimpleDateFormat;
import java.util.Date;

public class DateHelper {
	private static final SimpleDateFormat FORMAT_PROTPTYPE = new SimpleDateFormat("yyyyMMddHHmmssSSS");
	
	/**
	 * Date 객체를 입력받아 yyyyMMddHHssmmSSS 형태의 스트링으로 반환한다.
	 * @param date
	 * @return date 객체가 null이면 null, 아니면 변환된 스트링.
	 */
	public static String convertDateToString(Date date){
		if(date == null){
			return null;
		}
		
		return FORMAT_PROTPTYPE.format(date);
	}
	
	/**
	 * Date 객체와 표현형을 입력받아 변환후 스트링으로 반환한다.
	 * @param date
	 * @param format
	 * @return date 객체가 null이면 null, 아니면 변환된 스트링.
	 */
	public static String convertDateToString(Date date, String format){
		if (date == null){
			return null;
		}
		
		SimpleDateFormat formatter = (SimpleDateFormat) FORMAT_PROTPTYPE.clone();
		formatter.applyPattern(format);
		
		return formatter.format(date);
	}
}
