package FormTable;

import java.awt.Graphics;
import java.awt.image.BufferedImage;
import java.awt.image.ImageObserver;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.net.URL;
import java.text.ParseException;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import javax.annotation.Resource;
import javax.imageio.ImageIO;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.swing.JFrame;
import javax.swing.JPanel;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import api.msg.helper.ConvertHtmlHelper;
import bizbox.orgchart.service.vo.LoginVO;
import egovframework.com.cmm.util.EgovUserDetailsHelper;
import egovframework.com.utl.fcc.service.EgovFileUploadUtil;
import neos.cmm.db.CommonSqlDAO;
import neos.cmm.util.BizboxAProperties;
import neos.cmm.util.CommonUtil;
import neos.cmm.util.NeosConstants;
import net.sf.json.JSONArray;
import net.sf.json.JSONException;

@Controller
public class getFormTable extends JPanel{ 
	
	@Resource(name = "commonSql")
	private CommonSqlDAO commonSql;
	
	BufferedImage image = null;
	BufferedImage testimage = null;
	static JFrame frame = null;
	byte[] jasondata= new byte[640000];  //  maxSize
	
	
	@RequestMapping("/formBox.do")
	public ModelAndView formBox(@RequestParam Map<String,Object> paramMap, HttpServletResponse response) {
		
		paramMap.put("osType", NeosConstants.SERVER_OS);
		Map<String, Object> fileMap = (Map<String, Object>) commonSql.select("AttachFileUpload.selectAttachFileDetailApi", paramMap);		
		
		if(NeosConstants.SERVER_OS.toLowerCase().equals("windows")){		
			ModelAndView mv = new ModelAndView();
			
			String fname = fileMap.get("absolPath") + "/" + fileMap.get("fileStreCours") + "/" + fileMap.get("streFileName") + "." + fileMap.get("fileExtsn");
	        File f = new File(fname);
	        
	        if(!f.exists()){
	        	//System.out.println("formBox Error : Image File Not Exsits > " + fname);
	        }

	        int distortionOpt = 1; // 0=왜곡이 없는 이미지(일반문서이미지) , 1=촬상이미지(색상제거)
	        int length=FormTableJNI.dzFormTableFileProc(fname, jasondata, distortionOpt);
	        //read image file
	        try{
	          image = ImageIO.read(f);
	        }catch(IOException e){
	          //System.out.println("Error: "+e);
	        	CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
	        }
	        
	    	int width = image.getWidth();
			int height = image.getHeight();
			int []pixels = new int[width * height];
			image.getRGB(0, 0, width, height, pixels, 0, width);
			length=FormTableJNI.dzFormTableFileProc(fname, jasondata, distortionOpt);
	
	        if(length>0)
	        {
		        byte[] tmpdata= new byte[length];
		        System.arraycopy(jasondata, 0, tmpdata, 0, length);
		        //System.out.println(new String(tmpdata));
		        mv.addObject("convertData1", new String(tmpdata));
	        }
	        
	        distortionOpt = 0; // 0=왜곡이 없는 이미지(일반문서이미지) , 1=촬상이미지(색상제거)
	        
	        length=FormTableJNI.dzFormTableFileProc(fname, jasondata, distortionOpt);
	        //read image file
	        try{
	          image = ImageIO.read(f);
	        }catch(IOException e){
	          //System.out.println("Error: "+e);
	        	CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
	        }
	        
	    	width = image.getWidth();
			height = image.getHeight();
			pixels = new int[width * height];
			image.getRGB(0, 0, width, height, pixels, 0, width);
			length=FormTableJNI.dzFormTableFileProc(fname, jasondata, distortionOpt);
	
	        if(length>0)
	        {
		        byte[] tmpdata= new byte[length];
		        System.arraycopy(jasondata, 0, tmpdata, 0, length);
		        //System.out.println(new String(tmpdata));
		        mv.addObject("convertData2", new String(tmpdata));
	        }
	        
	        distortionOpt = 1; // 0=왜곡이 없는 이미지(일반문서이미지) , 1=촬상이미지(색상제거)
	        
	        length=FormTableJNI.dzFormTableFileProc(fname, jasondata, distortionOpt);
	        //read image file
	        try{
	          image = ImageIO.read(f);
	        }catch(IOException e){
	          //System.out.println("Error: "+e);
	        	CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
	        }
	        
	    	width = image.getWidth();
			height = image.getHeight();
			pixels = new int[width * height];
			image.getRGB(0, 0, width, height, pixels, 0, width);
			length=FormTableJNI.dzFormTableFileProc(fname, jasondata, distortionOpt);
	
	        if(length>0)
	        {
		        byte[] tmpdata= new byte[length];
		        System.arraycopy(jasondata, 0, tmpdata, 0, length);
		        //System.out.println(new String(tmpdata));
		        mv.addObject("convertData3", new String(tmpdata));
	        }
	        
	        ////System.out.printf(" end testFormbox ");
	        mv.setViewName("jsonView");
	        return mv;
	        
		}else{
			
			ModelAndView mv = new ModelAndView();
		
				
			String fname = fileMap.get("absolPath").toString() + fileMap.get("fileStreCours").toString() + fileMap.get("streFileName").toString() + "." + fileMap.get("fileExtsn").toString();
			File f = new File(fname);
			
	        if(!f.exists()){
	        	//System.out.println("formBox Error : Image File Not Exsits > " + fname);
	        }			
			 
	        int distortionOpt = 1; // 0=왜곡이 없는 이미지(일반문서이미지) , 1=촬상이미지(색상제거)
	        
	        try{
	          image = ImageIO.read(f);
	          
	        }catch(IOException e){
	          //System.out.println("Error: "+e);
	        	CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
	        }
	        
	        int length=0;       
	    	int width = image.getWidth();
			int height = image.getHeight();
			int []pixels = new int[width * height];
			image.getRGB(0, 0, width, height, pixels, 0, width);
			length=FormTableJNI.dzFormTableFileProc(fname, jasondata, distortionOpt);

	        ////System.out.printf(" end of dzformboxImageProc (length=%d ) \n",length);

	        
	        if(length>0)
	        {
		        byte[] tmpdata= new byte[length];
		        System.arraycopy(jasondata, 0, tmpdata, 0, length);
		        //System.out.println(new String(tmpdata));
		        mv.addObject("convertData1", new String(tmpdata));
	        }	        
	        
	        distortionOpt = 0; // 0=왜곡이 없는 이미지(일반문서이미지) , 1=촬상이미지(색상제거)
	        
	        try{
	          image = ImageIO.read(f);
	          
	        }catch(IOException e){
	        	CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
	          //System.out.println("Error: "+e);
	        }
	        
	        length=0;       
	    	width = image.getWidth();
			height = image.getHeight();
			pixels = new int[width * height];
			image.getRGB(0, 0, width, height, pixels, 0, width);
			length=FormTableJNI.dzFormTableFileProc(fname, jasondata, distortionOpt);

	        ////System.out.printf(" end of dzformboxImageProc (length=%d ) \n",length);

	        
	        if(length>0)
	        {
		        byte[] tmpdata= new byte[length];
		        System.arraycopy(jasondata, 0, tmpdata, 0, length);
		        //System.out.println(new String(tmpdata));
		        mv.addObject("convertData2", new String(tmpdata));
	        }

	        distortionOpt = 1; // 0=왜곡이 없는 이미지(일반문서이미지) , 1=촬상이미지(색상제거)

	        try{
	          image = ImageIO.read(f);
	          
	        }catch(IOException e){
	        	CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
	          //System.out.println("Error: "+e);
	        }
	        
	        length=0;       
	    	width = image.getWidth();
			height = image.getHeight();
			pixels = new int[width * height];
			image.getRGB(0, 0, width, height, pixels, 0, width);
			length=FormTableJNI.dzFormTableFileProc(fname, jasondata, distortionOpt);

	        ////System.out.printf(" end of dzformboxImageProc (length=%d ) \n",length);

	        
	        if(length>0)
	        {
		        byte[] tmpdata= new byte[length];
		        System.arraycopy(jasondata, 0, tmpdata, 0, length);
		        //System.out.println(new String(tmpdata));
		        mv.addObject("convertData3", new String(tmpdata));
	        }
	        
	        ////System.out.printf(" end testFormbox \n");
	        mv.setViewName("jsonView");
	        return mv;			
		}
    }
	
	
	//크로스사이트 요청 위조
	@RequestMapping(value="/formDocBox.do", method=RequestMethod.POST)
	public ModelAndView formDocBox(@RequestParam Map<String,Object> paramMap, HttpServletResponse response) {
		
		paramMap.put("osType", NeosConstants.SERVER_OS);
		Map<String, Object> fileMap = (Map<String, Object>) commonSql.select("AttachFileUpload.selectAttachFileDetailApi", paramMap);		
		
					
		ModelAndView mv = new ModelAndView();
		

		ConvertHtmlHelper convert = new ConvertHtmlHelper();
		String fileLocalPath = fileMap.get("absolPath").toString() + fileMap.get("fileStreCours").toString() + fileMap.get("streFileName").toString() + "." + fileMap.get("fileExtsn").toString();
		String saveLocalPath = fileMap.get("absolPath").toString() + fileMap.get("fileStreCours").toString() + paramMap.get("fileId") + "/";
		
		//System.out.println("fileLocalPath : " + fileLocalPath);
		//System.out.println("saveLocalPath : " + saveLocalPath );
		
		convert.convertImageSync(BizboxAProperties.getProperty("BizboxA.DocConvert.path"), fileLocalPath, saveLocalPath);
		
		mv.addObject("saveLocalPath", saveLocalPath);
		
        mv.setViewName("jsonView");
        return mv;
	}
	
	
	@RequestMapping("/formDocToJson.do")
	public ModelAndView formDocToJson(@RequestParam Map<String,Object> paramMap, HttpServletResponse response) {

		ModelAndView mv = new ModelAndView();
		
		String path = paramMap.get("saveLocalPath") + "";
		
		if(path != null && !"".equals(path)) {//경로 조작 및 자원 삽입
			path = path.replaceAll("", "");
		}
		
		File dirFile=new File(path);
		File []fileList=dirFile.listFiles();
		String fileNm = "";
		for(File tempFile : fileList) {
		  if(tempFile.isFile()) {
			  
			  if(tempFile.getName().indexOf("jpg") != -1 || tempFile.getName().indexOf("gif") != -1 || tempFile.getName().indexOf("png") != -1 || tempFile.getName().indexOf("jpeg") != -1 || tempFile.getName().indexOf("bmp") != -1) {
				  fileNm=tempFile.getName();
			  }
				  
		  }
		}		

		//System.out.println("docToImg file Name : " + fileNm);
		
		String fname = paramMap.get("saveLocalPath") + "document_0001.jpg";
		
		if(fname != null && !"".equals(fname)) {//경로 조작 및 자원 삽입
			fname = fname.replaceAll("", "");
		}
		
		File f = new File(fname);
		
        if(!f.exists()){
        	//System.out.println("formBox Error : Image File Not Exsits > " + fname);
        }			
		 
        int distortionOpt = 1; // 0=왜곡이 없는 이미지(일반문서이미지) , 1=촬상이미지(색상제거)

        try{
          image = ImageIO.read(f);
          
        }catch(IOException e){
        	CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
          //System.out.println("Error: "+e);
        }
        
        int length=0;       
    	int width = image.getWidth();
		int height = image.getHeight();
		int []pixels = new int[width * height];
		image.getRGB(0, 0, width, height, pixels, 0, width);
		length=FormTableJNI.dzFormTableFileProc(fname, jasondata, distortionOpt);

        ////System.out.printf(" end of dzformboxImageProc (length=%d ) \n",length);

        
        if(length>0)
        {
	        byte[] tmpdata= new byte[length];
	        System.arraycopy(jasondata, 0, tmpdata, 0, length);
	        //System.out.println(new String(tmpdata));
	        mv.addObject("convertData1", new String(tmpdata));
        }	  
        
        distortionOpt = 0; // 0=왜곡이 없는 이미지(일반문서이미지) , 1=촬상이미지(색상제거)

        try{
          image = ImageIO.read(f);
          
        }catch(IOException e){
        	CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
          //System.out.println("Error: "+e);
        }
        
        length=0;       
    	width = image.getWidth();
		height = image.getHeight();
		pixels = new int[width * height];
		image.getRGB(0, 0, width, height, pixels, 0, width);
		length=FormTableJNI.dzFormTableFileProc(fname, jasondata, distortionOpt);

        ////System.out.printf(" end of dzformboxImageProc (length=%d ) \n",length);

        
        if(length>0)
        {
	        byte[] tmpdata= new byte[length];
	        System.arraycopy(jasondata, 0, tmpdata, 0, length);
	        //System.out.println(new String(tmpdata));
	        mv.addObject("convertData2", new String(tmpdata));
        }
        
        distortionOpt = 1; // 0=왜곡이 없는 이미지(일반문서이미지) , 1=촬상이미지(색상제거)

        try{
          image = ImageIO.read(f);
          
        }catch(IOException e){
        	CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
          //System.out.println("Error: "+e);
        }
        
        length=0;       
    	width = image.getWidth();
		height = image.getHeight();
		pixels = new int[width * height];
		image.getRGB(0, 0, width, height, pixels, 0, width);
		length=FormTableJNI.dzFormTableFileProc(fname, jasondata, distortionOpt);

        ////System.out.printf(" end of dzformboxImageProc (length=%d ) \n",length);

        
        if(length>0)
        {
	        byte[] tmpdata= new byte[length];
	        System.arraycopy(jasondata, 0, tmpdata, 0, length);
	        //System.out.println(new String(tmpdata));
	        mv.addObject("convertData3", new String(tmpdata));
        }
        
        
        
        
        ////System.out.printf(" end testFormbox \n");
        mv.setViewName("jsonView");
        return mv;
	}
    
	
	@SuppressWarnings("unchecked")
	//크로스사이트 요청 위조
	@RequestMapping(value="/imgSrcToJson.do", method=RequestMethod.POST)
	public ModelAndView srcToJson(@RequestParam Map<String,Object> paramMap, HttpServletResponse response) throws IOException {
		
		//System.out.println("paramMap : " + paramMap);
		//System.out.println("paramMap.get(\"imgSrc\") : " + paramMap.get("imgSrc"));
		
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		try{
			URL url = new URL(paramMap.get("imgSrc").toString());
			InputStream is = url.openStream();
			
			paramMap.put("osType", NeosConstants.SERVER_OS);
			paramMap.put("pathSeq", "900");
			Map<String, Object> pathInfo = (Map<String, Object>) commonSql.select("GroupManage.selectGroupPathList", paramMap);		
			
			UUID uid = UUID.randomUUID();
			String saveFilePath = pathInfo.get("absolPath") + "/ConvertImgBox/" + uid.toString().replaceAll("-", "") + ".png";
			EgovFileUploadUtil.saveFile(is, new File(saveFilePath));
			
			File f = new File(saveFilePath);
			
			if(f.exists()){
				if(NeosConstants.SERVER_OS.toLowerCase().equals("windows")){		

					int distortionOpt = 1; // 0=왜곡이 없는 이미지(일반문서이미지) , 1=촬상이미지(색상제거)
			        
			        int length=FormTableJNI.dzFormTableFileProc(saveFilePath, jasondata, distortionOpt);
	
			        try{
			          image = ImageIO.read(f);
			        }catch(IOException e){
			        	CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
			          //System.out.println("Error: "+e);
			        }
			        
			    	int width = image.getWidth();
					int height = image.getHeight();
					int []pixels = new int[width * height];
					image.getRGB(0, 0, width, height, pixels, 0, width);
					length=FormTableJNI.dzFormTableFileProc(saveFilePath, jasondata, distortionOpt);
			
			        if(length>0)
			        {
				        byte[] tmpdata= new byte[length];
				        System.arraycopy(jasondata, 0, tmpdata, 0, length);
				        //System.out.println(new String(tmpdata));
				        mv.addObject("convertData1", new String(tmpdata));
			        }	
			        
			        distortionOpt = 0; // 0=왜곡이 없는 이미지(일반문서이미지) , 1=촬상이미지(색상제거)
			        length=FormTableJNI.dzFormTableFileProc(saveFilePath, jasondata, distortionOpt);
	
			        try{
			          image = ImageIO.read(f);
			        }catch(IOException e){
			        	CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
			          //System.out.println("Error: "+e);
			        }
			        
			    	width = image.getWidth();
					height = image.getHeight();
					pixels = new int[width * height];
					image.getRGB(0, 0, width, height, pixels, 0, width);
					length=FormTableJNI.dzFormTableFileProc(saveFilePath, jasondata, distortionOpt);
			
			        if(length>0)
			        {
				        byte[] tmpdata= new byte[length];
				        System.arraycopy(jasondata, 0, tmpdata, 0, length);
				        //System.out.println(new String(tmpdata));
				        mv.addObject("convertData2", new String(tmpdata));
			        }
			        
			        distortionOpt = 1; // 0=왜곡이 없는 이미지(일반문서이미지) , 1=촬상이미지(색상제거)
			        length=FormTableJNI.dzFormTableFileProc(saveFilePath, jasondata, distortionOpt);
	
			        try{
			          image = ImageIO.read(f);
			        }catch(IOException e){
			        	CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
			          //System.out.println("Error: "+e);
			        }
			        
			    	width = image.getWidth();
					height = image.getHeight();
					pixels = new int[width * height];
					image.getRGB(0, 0, width, height, pixels, 0, width);
					length=FormTableJNI.dzFormTableFileProc(saveFilePath, jasondata, distortionOpt);
			
			        if(length>0)
			        {
				        byte[] tmpdata= new byte[length];
				        System.arraycopy(jasondata, 0, tmpdata, 0, length);
				        //System.out.println(new String(tmpdata));
				        mv.addObject("convertData3", new String(tmpdata));
			        }
			        
			        
				}else{
					
			        int distortionOpt = 1; // 0=왜곡이 없는 이미지(일반문서이미지) , 1=촬상이미지(색상제거)	
			        try{
			          image = ImageIO.read(f);
			          
			        }catch(IOException e){
			        	CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
			          //System.out.println("Error: "+e);
			        }
			        
			        int length=0;       
			    	int width = image.getWidth();
					int height = image.getHeight();
					int []pixels = new int[width * height];
					image.getRGB(0, 0, width, height, pixels, 0, width);
					length=FormTableJNI.dzFormTableFileProc(saveFilePath, jasondata, distortionOpt);
			        
			        if(length>0)
			        {
			        	byte[] tmpdata= new byte[length];
				        System.arraycopy(jasondata, 0, tmpdata, 0, length);
				        //System.out.println(new String(tmpdata));
				        mv.addObject("convertData1", new String(tmpdata));
			        }
			        
			        distortionOpt = 0; // 0=왜곡이 없는 이미지(일반문서이미지) , 1=촬상이미지(색상제거)
			        
			        try{
			          image = ImageIO.read(f);
			          
			        }catch(IOException e){
			        	CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
			          //System.out.println("Error: "+e);
			        }
			        
			        length=0;       
			    	width = image.getWidth();
					height = image.getHeight();
					pixels = new int[width * height];
					image.getRGB(0, 0, width, height, pixels, 0, width);
					length=FormTableJNI.dzFormTableFileProc(saveFilePath, jasondata, distortionOpt);
			        
			        if(length>0)
			        {
			        	byte[] tmpdata= new byte[length];
				        System.arraycopy(jasondata, 0, tmpdata, 0, length);
				        //System.out.println(new String(tmpdata));
				        mv.addObject("convertData2", new String(tmpdata));
			        }
			        
			        distortionOpt = 1; // 0=왜곡이 없는 이미지(일반문서이미지) , 1=촬상이미지(색상제거)
			        
			        try{
			          image = ImageIO.read(f);
			          
			        }catch(IOException e){
			        	CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
			          //System.out.println("Error: "+e);
			        }
			        
			        length=0;       
			    	width = image.getWidth();
					height = image.getHeight();
					pixels = new int[width * height];
					image.getRGB(0, 0, width, height, pixels, 0, width);
					length=FormTableJNI.dzFormTableFileProc(saveFilePath, jasondata, distortionOpt);
			        
			        if(length>0)
			        {
			        	byte[] tmpdata= new byte[length];
				        System.arraycopy(jasondata, 0, tmpdata, 0, length);
				        //System.out.println(new String(tmpdata));
				        mv.addObject("convertData3", new String(tmpdata));
			        }
				}	
				f.delete();
			}else{				
				//System.out.println("No files found.");
			}
		}catch(IOException e){
			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
			//System.out.println("Error: "+e);
	    }
		
		return mv;
    }	
	
	
	public void paint(Graphics g){

	       if(image != null){
	    	   int xlen=702;
	    	   int ylen=496;
	    	   int wd,ht,wd2,ht2;
	    	   wd=wd2=image.getWidth();
	    	   ht=ht2=image.getHeight();
	    	   
	    	   if(wd>=ht && wd>xlen)
	    	   {
	    		   wd2=xlen; 
	    		   ht2=ht*xlen/wd;
	    	   }
	    	   else if(ht>ylen)
	    	   {
	    		   ht2=xlen;
	    		   wd2=wd*ylen/ht;
	    	   }
	    	   frame.setSize(wd2, ht2);
	    	   frame.setVisible(true);
	    	   g.drawImage(image, 0, 0, wd2, ht2, 0,0,wd,ht,(ImageObserver) this);
	    	   
	       }
	     
	 }
	
	
	@RequestMapping("/convertImgBoxView.do")
	public ModelAndView convertImgBoxView(@RequestParam Map<String, Object> params, HttpServletRequest request) {	
        ModelAndView mv = new ModelAndView();
        
        //System.out.println("now : " + EgovDateUtil.today("yyyy-MM-dd HH:mm"));
        
        Map<String, Object> param = new HashMap<String, Object>();
        param.put("osType", NeosConstants.SERVER_OS);
        param.put("pathSeq", "900");
        
        String perspectFlag = params.get("perspectFlag") == null ? "" :  params.get("perspectFlag").toString();
        String distortionOpt  = params.get("distortionOpt") == null ? "" :  params.get("distortionOpt").toString();
        
        if(params.get("groupSeq") != null && !params.get("groupSeq").equals("")){
        	param.put("groupSeq", params.get("groupSeq"));
        }
        
		Map<String, Object> pathInfo = (Map<String, Object>) commonSql.select("GroupManage.selectGroupPathList", param);	
        
		String empSeq = params.get("empSeq") + "";
		
		String fname = pathInfo.get("absolPath").toString() + "/ConvertImgBox/" + empSeq + "/" + params.get("fileName");
		File f = new File(fname);
		
        if(f.exists()){
		 
	        int perspectOption=1;  //1=자동(카메라로 촬상된 영상 포함) , 0= 왜곡이 없는 이미지(일반문서이미지: 아래한글에서 문서양식을 이미지로 저장한 경우)
	        
	        try{
	          image = ImageIO.read(f);
	          
	        }catch(IOException e){
	        	CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
	          //System.out.println("Error: "+e);
	        }
	        
	        int length=0;       
	    	int width = image.getWidth();
			int height = image.getHeight();
			int []pixels = new int[width * height];
			image.getRGB(0, 0, width, height, pixels, 0, width);
			
			if(!perspectFlag.equals("") && !distortionOpt.equals("")){
				length=FormTableJNI.dzFormTableFileProc(fname, jasondata, Integer.parseInt(distortionOpt));
			}else{				
				length=FormTableJNI.dzFormTableFileProc(fname, jasondata, perspectOption);
			}
	
	        ////System.out.printf(" end of dzformboxImageProc (length=%d ) \n",length);
	
			if (length > Integer.MAX_VALUE || length < Integer.MIN_VALUE) {//정수형 오버플로우 방지 적용
		        throw new IllegalArgumentException("out of bound");
		    }
	        
	        if(length>0)
	        {
		        byte[] tmpdata= new byte[length];
		        System.arraycopy(jasondata, 0, tmpdata, 0, length);
		        //System.out.println(new String(tmpdata));
		        mv.addObject("convertData", new String(tmpdata));
	        }	      
	        
	        //파일제거
//	        f.delete();
	        
	        ////System.out.printf(" end testFormbox \n");
        
        }
		
        mv.setViewName("/neos/formEditor/boxForm");
		return mv;
	}
	
	@RequestMapping("/dzBoxImgConvertPop.do")
	public ModelAndView dzBoxImgConvertPop(@RequestParam Map<String, Object> params, HttpServletRequest request) throws ParseException {	
        ModelAndView mv = new ModelAndView();
        
        mv.setViewName("/neos/formEditor/pop/dzBoxImgConvertPop");
        
        return mv;
	}
	
	
	
	@RequestMapping("/mobileImgListPopView.do")
	public ModelAndView mobileImgListPopView(@RequestParam Map<String, Object> params, HttpServletRequest request){	
        ModelAndView mv = new ModelAndView(); 
        
        mv.setViewName("/neos/formEditor/pop/mobileImgListPop");
        
        return mv;
	}
	
	
	
	@RequestMapping("/getMobileImgList.do")
	public ModelAndView getMobileImgList(@RequestParam Map<String, Object> params, HttpServletRequest request){		
		ModelAndView mv = new ModelAndView();
		
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("groupSeq", loginVO.getGroupSeq());
		param.put("osType", NeosConstants.SERVER_OS);
		param.put("pathSeq", "900");
		Map<String, Object> mp = (Map<String, Object>) commonSql.select("GroupManage.selectGroupPathList", param);
		List<Map<String, Object>> imgList = new ArrayList<>();
		
		String path = mp.get("absolPath") + "/ConvertImgBox/" + loginVO.getUniqId() + "/";

		File dirFile=new File(path);
		File []fileList=dirFile.listFiles();
		
		if(fileList != null){
			for(File tempFile : fileList) {
			    if(tempFile.isFile()) {
			    	Map<String, Object> imgMap = new HashMap<String, Object>();
			    	
			    	String filePath=tempFile.getParent();
				    String fileName=tempFile.getName();
				    			    
				    String imgDate = fileName.substring(0, fileName.lastIndexOf("."));
				    
				    java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("yyyy-MM-dd HHmmss");
			        Calendar c1 = Calendar.getInstance();
				    String strToday = sdf.format(c1.getTime());
		
				    //모바일로 업로드된 2주 이상된 이미지파일은 제거
				    if(diffOfDate(imgDate, strToday) > 14){
				    	tempFile.delete();
				    }else{
				    	filePath = filePath.replace("home/", "").replace("NAS_File/", "");
				    	imgMap.put("fileUrl", filePath + "/" + fileName);
				    	imgMap.put("fileNm", imgDate);
				    	imgList.add(imgMap);	
				    }
			    }
			}        
		}
		
		JSONArray json = JSONArray.fromObject(imgList);
		try {
		    //System.out.println("json : " + json.toString());
		} catch (JSONException e) {
		    e.printStackTrace();
		}
        
		mv.addObject("listDate", imgList);		
		
		mv.setViewName("jsonView");
		return mv;
	}
	
	
	public static long diffOfDate(String begin, String end)
	  {
		try{
			java.text.SimpleDateFormat formatter = new java.text.SimpleDateFormat("yyyy-MM-dd HHmmss");	 
	
		    Date beginDate = formatter.parse(begin);
		    Date endDate = formatter.parse(end);
		    
		    long diff = endDate.getTime() - beginDate.getTime();
		    long diffDays = diff / (24 * 60 * 60 * 1000);
	
		    return diffDays;
		}
		catch(Exception e){
			return 999;
		}
	  }

	
	@RequestMapping("/ConvertImgFromMobile.do")
	public ModelAndView ConvertImgFromMobile(@RequestParam Map<String, Object> paramMap,  HttpServletRequest request) throws Exception {
		
		ModelAndView mv = new ModelAndView();
		
		String imgUrl = (String) paramMap.get("imgUrl");
		if(imgUrl != null && !"".equals(imgUrl)) {//경로 조작 및 자원 삽입
			imgUrl = imgUrl.replaceAll("", "");
		}
		
		File f = new File(imgUrl + "");
		
        if(f.exists()){
		 
	        int distortionOpt = 1; // 0=왜곡이 없는 이미지(일반문서이미지) , 1=촬상이미지(색상제거)
	        
	        try{
	          image = ImageIO.read(f);
	          
	        }catch(IOException e){
	        	CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
	          //System.out.println("Error: "+e);
	        }
	        
	        int length=0;       
	    	int width = image.getWidth();
			int height = image.getHeight();
			int []pixels = new int[width * height];
			image.getRGB(0, 0, width, height, pixels, 0, width);
			
			length=FormTableJNI.dzFormTableFileProc(imgUrl, jasondata, distortionOpt);
	
	        ////System.out.printf(" end of dzformboxImageProc (length=%d ) \n",length);
	
	        
	        if(length>0)
	        {
		        byte[] tmpdata= new byte[length];
		        System.arraycopy(jasondata, 0, tmpdata, 0, length);
		        //System.out.println(new String(tmpdata));
		        mv.addObject("resultCode", "SUCCESS");
		        mv.addObject("convertData1", new String(tmpdata));
	        }
	        
	        distortionOpt = 0; // 0=왜곡이 없는 이미지(일반문서이미지) , 1=촬상이미지(색상제거)
	        try{
	          image = ImageIO.read(f);
	          
	        }catch(IOException e){
	        	CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
	          //System.out.println("Error: "+e);
	        }
	        
	        length=0;       
	    	width = image.getWidth();
			height = image.getHeight();
			pixels = new int[width * height];
			image.getRGB(0, 0, width, height, pixels, 0, width);
			length=FormTableJNI.dzFormTableFileProc(imgUrl, jasondata, distortionOpt);
	
	        ////System.out.printf(" end of dzformboxImageProc (length=%d ) \n",length);
	
	        
	        if(length>0)
	        {
		        byte[] tmpdata= new byte[length];
		        System.arraycopy(jasondata, 0, tmpdata, 0, length);
		        //System.out.println(new String(tmpdata));
		        mv.addObject("resultCode", "SUCCESS");
		        mv.addObject("convertData2", new String(tmpdata));
	        }
	        
	        distortionOpt = 1; // 0=왜곡이 없는 이미지(일반문서이미지) , 1=촬상이미지(색상제거)
	        
	        try{
	          image = ImageIO.read(f);
	          
	        }catch(IOException e){
	        	CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
	          //System.out.println("Error: "+e);
	        }
	        
	        length=0;       
	    	width = image.getWidth();
			height = image.getHeight();
			pixels = new int[width * height];
			image.getRGB(0, 0, width, height, pixels, 0, width);
			length=FormTableJNI.dzFormTableFileProc(paramMap.get("imgUrl").toString(), jasondata, distortionOpt);
	
	        ////System.out.printf(" end of dzformboxImageProc (length=%d ) \n",length);
	
	        
	        if(length>0)
	        {
		        byte[] tmpdata= new byte[length];
		        System.arraycopy(jasondata, 0, tmpdata, 0, length);
		        //System.out.println(new String(tmpdata));
		        mv.addObject("resultCode", "SUCCESS");
		        mv.addObject("convertData3", new String(tmpdata));
	        }
	        //System.out..printf(" end testFormbox \n");
        
        }else{
        	mv.addObject("resultCode", "FAIL");
        }
        
        mv.setViewName("jsonView");
        
        return mv;
	}
	

	@RequestMapping("/delMobileImg.do")
	public ModelAndView delMobileImg(@RequestParam Map<String, Object> paramMap,  HttpServletRequest request) throws Exception {
		ModelAndView mv = new ModelAndView();
		
		String imgUrl = paramMap.get("src") + "";
		
		if(NeosConstants.SERVER_OS.equals("linux")){
			imgUrl = "/home" + imgUrl;
		}
		
		if(imgUrl != null && !imgUrl.equals("")){
			
			imgUrl = imgUrl.replaceAll("", "");//경로 조작 및 자원 삽입
			
			File imgFile = new File(imgUrl);
			
			if(imgFile.exists()){
				imgFile.delete();
			}
		}
		
		mv.setViewName("jsonView");
		return mv;
	}
}
