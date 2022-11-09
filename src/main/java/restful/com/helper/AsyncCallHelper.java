package restful.com.helper;

import java.io.File;

import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Service;

import neos.cmm.util.ImageUtil;
import org.apache.log4j.Logger;

@Service("asyncCallHelper")
public class AsyncCallHelper {
	
	@Async
	public void setASyncImageSet(File thumFile ,File orgfile,int imgMaxWidth) throws Exception {
		// 앞단데이터 정보 처리에 필요한 정보 변경 딜레이 
		Logger.getLogger(AsyncCallHelper.class).debug("## AsyncCallHelper.setASyncImageSet - start");
		long startDt = System.currentTimeMillis();
		
		ImageUtil.saveResizeImage(thumFile, orgfile, imgMaxWidth);
		
		long endDt = System.currentTimeMillis();
		Logger.getLogger(AsyncCallHelper.class).debug("## AsyncCallHelper.setASyncImageSet - end ET[ " +(endDt - startDt)/1000.0+"]");
		
	}
	
}
