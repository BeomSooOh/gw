package neos.cmm.util;

import java.awt.Graphics2D;
import java.awt.Image;
import java.awt.Rectangle;
import java.awt.image.BufferedImage;
import java.io.File;
import java.io.RandomAccessFile;
import java.nio.ByteBuffer;
import java.util.ArrayList;
import java.util.List;

import javax.imageio.ImageIO;

import com.sun.pdfview.PDFFile;
import com.sun.pdfview.PDFPage;

public class PdfToImage implements FileConvert {

	@Override
	public boolean fileConvert(String filePathName, String destFilePathName) throws Exception {

   	  int point = destFilePathName.lastIndexOf('.') ;
   	  String ext = destFilePathName.substring(point+1, destFilePathName.length() ) ;
   	  
   	  String imageFormat = ext; //jpg와 png를 지원한다.
   	  
      File file = null ;
      RandomAccessFile raf = null ;
      PDFPage page= null ; 
      List<PDFPage> pageList = new ArrayList();
      Graphics2D g2 = null; 
      ByteBuffer buf = null ;
      boolean result = false ;
      int startPageNum =1  ;
      int endPageNum = 0 ;
      BufferedImage bi = null ;
      int convertWith = 1200 ;
      int convertHeight = 1400;
      try {
    	  file = new File(filePathName);
    	  long size = file.length() ;
       	  //너무 큰파일경우 OOM 막기위해  PDF 파일을 이미지 로 변환을 안함.
       	  if( size > 15480000)  {
       		  return false ;
       	  }
       	  
          raf = new RandomAccessFile(file, "r");
          byte[] b = new byte[(int)raf.length()];
          raf.readFully(b);
          buf = ByteBuffer.wrap(b);
          PDFFile pdfFile = new PDFFile(buf);
         
          endPageNum = pdfFile.getNumPages();
          
      	  //너무 큰파일경우 OOM 막기위해  PDF 파일을 이미지 로 변환을 안함.
          if(  size / endPageNum > 3800000  ) {
        	  return false ;
          }
       	 
          int height = 0 ;
          int width = 0 ;
          
          //startPageNum 이 0 또는 1 은 1page 가져온다.
          startPageNum =1 ;
	      for( ; startPageNum <= endPageNum; startPageNum ++) {
	    	  
	    	  page = pdfFile.getPage(startPageNum);

	    	  width = Math.max(width, (int)page.getBBox().getWidth());
	    	  height +=  (int)page.getBBox().getHeight();
	    	  pageList.add(page);
	      }
	      
//	      bi = new BufferedImage(width, height, BufferedImage.TYPE_INT_RGB);
	      bi = new BufferedImage(convertWith, convertHeight*endPageNum, BufferedImage.TYPE_INT_RGB);
	      g2 = bi.createGraphics();

	      height = 0;
	      //pageList은0 부터 시작.
	      startPageNum = 0 ;
	      for( ; startPageNum < endPageNum; startPageNum ++) {
		      
		      page =pageList.get(startPageNum) ;
		     
	          //get the width and height for the doc at the default zoom 
	          Rectangle rect = new Rectangle(0,0, (int)page.getBBox().getWidth(), (int)page.getBBox().getHeight());
	          
				int rotation=page.getRotation();

				Rectangle rect1=rect;
				
				if(rotation==90 || rotation==270) {
					rect1=new Rectangle(0,0,rect.height,rect.width);
				}
				
				Image image = page.getImage(
//	                  rect.width, rect.height, //width & height
					  convertWith, convertHeight, //width & height
	                  rect1, // clip rect
	                  null, // null for the ImageObserver
	                  true, // fill background with white
	                  true  // block until drawing is done
	                  );
              
	          g2.drawImage(image, 0,height,  null);
	         
	          height += convertHeight ;

	      }
	      
          g2.dispose();
          ImageIO.write(bi, imageFormat, new File(destFilePathName));
	      result  = true ;
      }catch(Exception e ) {
    	 
    	  CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
      }finally {
    	  if (g2 != null )  {
    		  try { g2.dispose() ; } catch(Exception ignore){CommonUtil.printStatckTrace(ignore);//오류메시지를 통한 정보노출 
    		  }
    	  }
    	
    	  if(buf != null ) {
    		  try { buf.clear() ; } catch(Exception ignore) {CommonUtil.printStatckTrace(ignore);//오류메시지를 통한 정보노출
    		  }
    		  buf = null ;
    	  }
    	  if(bi != null ) {
    		  bi = null ;
    	  }
    	  if(raf != null )  {
    		  try { raf.close() ; } catch(Exception ignore){CommonUtil.printStatckTrace(ignore);//오류메시지를 통한 정보노출
    		  }
    	  }
      }

      return result ;
	}
	
}
