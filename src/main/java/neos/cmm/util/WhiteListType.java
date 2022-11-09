package neos.cmm.util;

public enum WhiteListType {
	NORMAL("NORMAL"),
	REGEX("REGEX");
	
	private String name;
	
	WhiteListType(String name){
		this.name = name;
	}
	
	public String getValue(){
		return this.name;
	}
	
	/**
	 * 타입 스트링을 받고, 해당하는 상태를 반환. 값에 해당하는 상태가 없으면 null
	 * @param operateCode
	 * @return
	 */
	public static WhiteListType getFromValue(String name){
		for(WhiteListType status : WhiteListType.values()){
			if(status.getValue().equals(name.toUpperCase())){
				return status;
			}
		}
		
		return null;
	}
}
