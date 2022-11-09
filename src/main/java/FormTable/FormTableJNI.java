package FormTable;

import java.awt.image.BufferedImage;
import javax.imageio.*;
import javax.imageio.stream.ImageInputStream;

import neos.cmm.util.NeosConstants;

import java.io.File;
import java.io.IOException;
import java.util.Iterator;

public  class FormTableJNI {
	  
 
	static{

	       try {
	    	   if(NeosConstants.SERVER_OS.toLowerCase().equals("windows")){
		    	   String dzFormBoxDllPath = FormTableJNI.class.getResource("").getPath() + "JNI_DzFormBox.dll";    	   
		           System.load(dzFormBoxDllPath);
	    	   }else if(NeosConstants.SERVER_OS.toLowerCase().equals("linux")){
		    	   String dzFormBoxDllPath = FormTableJNI.class.getResource("").getPath() + "libJNI_DzFormTable.so";    	   
		           System.load(dzFormBoxDllPath);
	    	   }
	       } catch (UnsatisfiedLinkError e) {
	    	   System.err.println(e);//오류 상황 대응 부재
	       }
		}

	public final static native int dzFormTableImageProc(int[] imgRGB, int width, int height, byte[] jasondata, int distortionOpt);

	public final static int dzFormTableFileProc(String fname,byte[] jasondata, int distortionOpt) 
	 {   
			BufferedImage image = null;
			File file = null;
			long tm1,tm2;		
			int length=0;	
			
			file = new File(fname);	  
	         if (!file.exists()) {
	          return 0;
	         }
		         
	        try {
				image= readImage(file);
			} catch (IIOException e2) {
				System.err.println(e2);//오류 상황 대응 부재
				 return 0;
			} catch (IOException e2) {
				System.err.println(e2);//오류 상황 대응 부재
				 return 0;
			}
			 
		    if(image==null) {
		       	return length;
		    }
		        
		      
	    	int width = image.getWidth();
			int height = image.getHeight();  
		
			//int []pixels = new int[width * height];    
			int []pixels = image.getRGB(0, 0, width, height, null, 0, width);
			
			tm1=tm2=System.currentTimeMillis(); 
			while(true)
			{
				if(isBusydzFormTable() ==1)	{
					tm2=System.currentTimeMillis();
					if(tm2-tm1>3000) {//3초
						break;
					}
					
					try {
						Thread.sleep(50);
					} catch (InterruptedException e) {
						System.err.println(e);//오류 상황 대응 부재
					}
				}
				else {
					length=FormTableJNI.dzFormTableImageProc(pixels, width, height, jasondata, distortionOpt);
					tm2=System.currentTimeMillis();
					break;
				}					
			}    
			//image.flush(); 
			image=null;
			pixels=null;		
			System.gc();
			
			return length;
	 }

	 
	public static BufferedImage readImage(File file) throws IOException, IIOException 
	{		   
		BufferedImage image=null;
	    ImageInputStream stream = ImageIO.createImageInputStream(file);
	    try{
	        Iterator<ImageReader> iter = ImageIO.getImageReaders(stream);
	        while (iter.hasNext()) {
	            ImageReader reader = iter.next();
	            reader.setInput(stream);

	            try 
	            {
	                image = reader.read(0);
	                reader.reset();
	            } catch (IIOException e) {		 
	                return null;
	            }
	            finally {
	                reader.dispose();
	            }
	            return image;
	        }
	        return null;
	    }
	    finally {
	        if (stream != null){
	            stream.close();
	        }
	    }
	}

	/*
	 * Input : 없음
	 * Output : 없음
	 * Return :
	 *    0 - 이미지 인식 대기중.
	 *    1 - 이미지 인식 진행중.
	 */
		 
	public final static native int isBusydzFormTable();
}
