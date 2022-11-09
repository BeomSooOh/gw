package neos.cmm.util;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.io.IOUtils;

import egovframework.rte.fdl.string.EgovStringUtil;

public class FileDownload {
	 /**
     * Disposition 지정하기.
     * 
     * @param filename
     * @param request
     * @param response
     * @throws Exception
     */
    public static void setDisposition(String filename, HttpServletRequest request, HttpServletResponse response) throws Exception {
		String browser = CommonUtil.getBrowser(request);
		
		String dispositionPrefix = "attachment; filename=";
		String encodedFilename = null;
		
		if (browser.equals("MSIE")) {
		    encodedFilename = URLEncoder.encode(filename, "UTF-8").replaceAll("\\+", "%20");
		} else if (browser.equals("Firefox")) {
		    encodedFilename = "\"" + new String(filename.getBytes("UTF-8"), "8859_1") + "\"";
		} else if (browser.equals("Opera")) {
		    encodedFilename = "\"" + new String(filename.getBytes("UTF-8"), "8859_1") + "\"";
		} else if (browser.equals("Chrome")) {
		    StringBuffer sb = new StringBuffer();
		    for (int i = 0; i < filename.length(); i++) {
			char c = filename.charAt(i);
			if (c > '~') {
			    sb.append(URLEncoder.encode("" + c, "UTF-8"));
			} else {
			    sb.append(c);
			}
		    }
		    encodedFilename = sb.toString();
		} else {
		    //throw new RuntimeException("Not supported browser");
		    throw new IOException("Not supported browser");
		}
		
		response.setHeader("Content-Disposition", dispositionPrefix + encodedFilename);
	
		if ("Opera".equals(browser)){
		    response.setContentType("application/octet-stream;charset=UTF-8");
		}else if (browser.equals("MSIE")) {
			response.setContentType( "application/x-msdownload" );
		}
    }

	public static void  getImageView(HttpServletResponse response, String filePathName, String fileName ) throws UnsupportedEncodingException {

		File file = new File( filePathName);
		FileInputStream in = null;
		try {
			try {
				in = new FileInputStream(file);
			} catch ( Exception e ) {
				CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
				//e.printStackTrace();
			}
			String type = "";
			int point = fileName.lastIndexOf(".") ;
			String ext = fileName.substring(point+1, fileName.length() );
			if (ext != null && !"".equals(ext)) {
			    if ("jpg".equals(ext.toLowerCase())) {
			    	type = "image/jpeg";
			    } else {
			    	type = "image/" + ext.toLowerCase();
			    }
			} else {
			    //LOG.debug("Image fileType is null.");
			}
			response.setContentType( type );
			if(file != null) {
				response.setHeader( "Content-Length", file.length()+"" );
			}
			
			outputStream(response, in);
		}catch(Exception e ) {
			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
		}
	}
	public static void  download(HttpServletResponse response, String filePathName, String fileName ) throws UnsupportedEncodingException {

		File file = new File( filePathName);
		FileInputStream in = null;
		try {
			try {
				in = new FileInputStream(file);
			} catch ( Exception e ) {
				CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
			}

			response.setContentType( CommonUtil.getContentType(file) );
			response.setHeader( "Content-Disposition", "attachment; filename=\""+ new String(fileName.getBytes("euc-kr"),"iso-8859-1") + "\"" );
			response.setHeader( "Content-Transfer-Coding", "binary" );
			if(file != null) {
				response.setHeader( "Content-Length", file.length()+"" );
			}
			
			outputStream(response, in);
		}catch(Exception e ) {
			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
		}
	}
	
	public static void  downloadImg(HttpServletResponse response , String filePathName, String fileName ) throws UnsupportedEncodingException {
        File file = null;
        FileInputStream fis = null;

        try {
            file = new File(filePathName);


            fis = new FileInputStream(file);

            String type = "";
            int point = 0 ;
			point =  fileName.lastIndexOf(".") ;
			String ext = fileName.substring(point+1);
			
            if (!EgovStringUtil.isEmpty(ext)) {
                if ("jpg".equals(ext.toLowerCase())) {
                	type = "image/jpeg";
                } else {
                	type = "image/" + ext.toLowerCase();
                }

            } else {
                //LOG.debug("Image fileType is null.");
            }

            response.setHeader("Content-Type", type);
            response.setContentLength((int) file.length());
			byte buffer[] = new byte[4096];
			int bytesRead = 0, byteBuffered = 0;
			
			while((bytesRead = fis.read(buffer)) > -1) {
				
				response.getOutputStream().write(buffer, 0, bytesRead);
				byteBuffered += bytesRead;
				
				//flush after 1MB
				if(byteBuffered > 1024*1024) {
					byteBuffered = 0;
					response.getOutputStream().flush();
				}
			}

			response.getOutputStream().flush();
            response.getOutputStream().close();

            // 2011.10.10 보안점검 후속조치 끝
        }
        catch (Exception e) {
        	CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
		}
        finally {
            if (fis != null) {
                try {
                    fis.close();
                } catch (Exception ignore) {
                    //System.out.println("IGNORE: " + ignore);
                    
                }
            }
        }
	}
	public static void  download(HttpServletResponse response , HttpServletRequest request, String filePathName, String fileName ) throws UnsupportedEncodingException {

		File file = new File( filePathName);
		FileInputStream in = null;
		try {
			try {
				in = new FileInputStream(file);
			} catch ( Exception e ) {
				CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
				//e.printStackTrace();
			}

			FileDownload.setDisposition(fileName,  request, response);
			
			response.setHeader( "Content-Transfer-Coding", "binary" );
			if(file != null) {
				response.setHeader( "Content-Length", file.length()+"" );
			}
			
			outputStream(response, in);
		}catch(Exception e ) {
			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
		}
	}
	
	public static void  download2(HttpServletResponse response, String filePathName, String fileName ) throws UnsupportedEncodingException {

		File file = new File( filePathName);
		FileInputStream in = null;
		try {
			try {
				in = new FileInputStream(file);
			} catch ( Exception e ) {
				CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
			}

			response.setContentType( CommonUtil.getContentType(file) );
			response.setHeader( "Content-Disposition", "attachment; filename=\""+ URLEncoder.encode(fileName, "utf-8") + "\"" );
			response.setHeader( "Content-Transfer-Coding", "binary" );
			if(file != null) {
				response.setHeader( "Content-Length", file.length()+"" );
			}
			
			outputStream(response, in);
		}catch(Exception e ) {
			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
		}
	}
	
	private static void outputStream(HttpServletResponse response,FileInputStream in ) throws Exception {
		ServletOutputStream binaryOut = response.getOutputStream();

		try {
			IOUtils.copy(in, binaryOut);
			binaryOut.flush();
		} catch ( Exception e ) {
			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
		} finally {
			if (in != null) {
				try {
				in.close();
				}catch(Exception e ) {
					CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
				}
			}
			if (binaryOut != null) {
				try {
					binaryOut.close();
				}catch(Exception e ) {
					CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
				}
			}
		}
		
	
	}
}
