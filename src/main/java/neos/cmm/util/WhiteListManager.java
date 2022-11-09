package neos.cmm.util;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.IOException;
import java.util.HashSet;
import java.util.Set;

import org.apache.log4j.Logger;
import egovframework.com.utl.fcc.service.EgovStringUtil;

public class WhiteListManager { 
	private Logger logger = Logger.getLogger(this.getClass());
	boolean isInitialized = false;
	public Set<WhiteListItem> whiteList = new HashSet<WhiteListItem>();
	private final String path;
	
	
	final String lock = new String("LOCK");
	
	public WhiteListManager(String path){
		this.path = path;
		load();
		isInitialized = true;
	}
	
	/**
	 * 주기적으로 화이트 리스트 정보를 다시 읽도록 설정.
	 * cron 정보는 spring xml에 있음.
	 */
	public void reload() {
		if(isInitialized) {
			logger.info("화이트 리스트 재설정 시작. path=" + this.path);
			load();
			logger.info("화이트 리스트 재설정 종료");
		}
	}
	
	public void load() {
		synchronized (lock) {//경쟁조건: 검사시점과 사용시점 (TOCTOU) 
			
		if(EgovStringUtil.isEmpty(path)) {
			logger.error("화이트 리스트 설정 파일 경로를 알 수 없습니다.");
			return;
		}
		
		File config = new File(path);
		if(!(config.isFile() && config.canRead())) {
			logger.error("화이트 리스트 설정 경로가 파일이 아니거나, 읽을 수 없는 상태입니다.");
			return;
		}
		
		FileReader reader = null;
		BufferedReader bufReader = null;
		try {
			reader = new FileReader(config);
			
			bufReader = new BufferedReader(reader);
			
			Set<WhiteListItem> tempSet = new HashSet<WhiteListItem>();
			String lineStr = "";
			while((lineStr = bufReader.readLine()) != null) {
				//공백 제
				lineStr = lineStr.replaceAll("\\s+", " ");
				
				// 빈 라인이나, #(주석) 라인은 skip
				if(EgovStringUtil.isEmpty(lineStr) || lineStr.charAt(0) == '#') {
					continue;
				}
				
				try {
					String[] checkValue = lineStr.split("\\s");
					
					WhiteListItem wlItem = new WhiteListItem();
					
					WhiteListType type = WhiteListType.getFromValue(checkValue[0]);
					if(type != null) {
						wlItem.setType(type);
						wlItem.setValue(checkValue[1]);
						
						tempSet.add(wlItem);
						
						logger.info("WhiteList item=" + lineStr);
					}
				}catch(Exception e) {
					logger.warn("화이트 리스트 값 분석 중 다음 항목이 실패하였습니다. item=" + lineStr);
				}
			}
			
			bufReader.close();
			reader.close();
			
			whiteList = tempSet;
			
		} catch (Exception e) {
			logger.error("직접 다운로드 화이트 리스트 정보를 구하는 중 오류가 발생하였습니다.",e);
		} finally {
			if(bufReader != null) {
				try {
					bufReader.close();
					bufReader = null;
				} catch (IOException e) {
					logger.error("bufReader 파일 커넥션을 닫는 중 문제가 발생하였습니다.", e);
				}
			}
			
			if(reader != null) {
				try {
					reader.close();
					reader = null;
				} catch (IOException e) {
					logger.error("reader 파일 커넥션을 닫는 중 문제가 발생하였습니다.", e);
				}
			}
		}
		}
	}
	
	/**
	 * 화이트 리스트 정보 파일이 로드가 끝났는지 여부 반환.
	 * @return
	 */
	public boolean isInitialized() {
		return isInitialized;
	}
	
	/**
	 * 설정 파일에서 조회한 화이트 리스트 리스트를 반환.
	 * @return
	 */
	public Set<WhiteListItem> getWhiteList(){
		return whiteList;
	}
}
