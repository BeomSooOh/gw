package neos.cmm.util;

import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

public class CollectionUtils {
	/**
	 * list1 을 기준으로 합치기
	 * @param list1 기준이 되는 리스트
	 * @param list2 outer join 될 리스트
	 * @param key 기준키
	 * @return
	 */
	public static List<Map<String,Object>> sum(List<Map<String,Object>> list1, List<Map<String,Object>> list2, String key) {
		if (list1 == null || list2 == null) {
			return list1;
		}

		for(Map<String,Object> map : list1) {
			String s = map.get(key)+"";
			Map<String,Object> m = getMap(list2, key, s);
			if (m != null) {
				map.putAll(m);
			}
		}
		return list1;
	}
	
	public static Map<String,Object> getMap(List<Map<String,Object>> list, String key, String value) {
		for(Map<String,Object> map: list) {
			String v = map.get(key)+"";
			if (v.equals(value)) {
				return map;
			}
		}
		return null;
	}
	
	public static <T> List<T> copyList(List<T> source) {
		List<T> dest = new ArrayList<T>();
		
		System.arraycopy(source, 0, dest, 0, source.size());

		return dest;
	}

	public static Map<String, Object> getListToMap(List<Map<String, Object>> list, String str) {
		
		Map<String,Object> map = new HashMap<>();
		
		for(Map<String,Object> m : list) {
			map.put(m.get(str)+"", m);
		}
		
		return map;
	}
	
	public static List<?> getListRemoveDuplicate(List<?> list) {
		
		Map<Integer,Object> map = new HashMap<>();
		
		for(Object o : list) {
			map.put(o.hashCode(), o);
		}
		
		List resultList = new ArrayList<>();
		Iterator<Integer> it = map.keySet().iterator();
		
		while( it.hasNext() ){
            int key = it.next();
            resultList.add(map.get(key));
        }

		return resultList;
	}
	
	public static Object convertMapToObject(Map map, Object objClass){ 
		String keyAttribute = null; 
		String setMethodString = "set"; 
		String methodString = null; 
		Iterator itr = map.keySet().iterator(); 
		while(itr.hasNext()){ 
			keyAttribute = (String) itr.next(); 
			methodString = setMethodString+keyAttribute.substring(0,1).toUpperCase()+keyAttribute.substring(1); 
			try { 
				Method[] methods = objClass.getClass().getDeclaredMethods(); 
				for(int i=0;i<=methods.length-1;i++){ 
					if(methodString.equals(methods[i].getName())){ 
//						System.out.println("invoke : "+methodString); 
						methods[i].invoke(objClass, map.get(keyAttribute)); 
					} 
				} 
			} 
			catch (SecurityException e) { 
				CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출 
			} 
			catch (IllegalAccessException e) { 
				CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출 
			} 
			catch (IllegalArgumentException e) { 
				CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출 
			}
			catch (InvocationTargetException e) { 
				CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출 
			} 
		} return objClass; 
	}

	public static Map<String,Object> convertEgovMapToMap(Map map){ 
		String keyAttribute = null; 
		Iterator itr = map.keySet().iterator(); 
		Map<String,Object> resultMap = new HashMap<>();
		while(itr.hasNext()){ 
			keyAttribute = (String) itr.next(); 
			resultMap.put(keyAttribute, map.get(keyAttribute));
			
		} 
		return resultMap; 
	}

}
