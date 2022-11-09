package neos.cmm.util;

import java.io.BufferedOutputStream;
import java.io.Closeable;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.FileWriter;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.URL;
import java.net.URLConnection;
import java.nio.ByteBuffer;
import java.nio.MappedByteBuffer;
import java.nio.channels.FileChannel;
import java.util.ArrayList;
import java.util.Enumeration;
import java.util.List;
import java.util.Map;
import java.util.zip.ZipEntry;
import java.util.zip.ZipFile;
import java.util.zip.ZipOutputStream;

import org.apache.commons.fileupload.FileItem;
import org.apache.commons.io.IOUtils;
import org.apache.commons.lang.StringUtils;
import org.springframework.web.multipart.commons.CommonsMultipartFile;

import egovframework.com.utl.sim.service.EgovFileTool;

public class FileUtils {
	static final int COMPRESSION_LEVEL 	= 8;
    static final int BUFFER_SIZE 		= 64 * 1024;
    static final char FILE_SEPARATOR 	= File.separatorChar;
	
	@SuppressWarnings("rawtypes")
	ArrayList fileList1 = new ArrayList();
	/**
	 * description: 폴더목록 구하기 - 파일 제외
	 * @param path
	 * @return
	 * @return
	 */
	public static File[] folderList(String path) {
		File root=new File(path);
		File[] listFile=root.listFiles();
		if(listFile!=null){
			ArrayList folderList=new ArrayList();
			for(int i=0;i<listFile.length;i++){
				if(listFile[i].isDirectory()){
					folderList.add(listFile[i]);
				}
			}
			return (File[])(folderList.toArray(new File[0]));
		}else {
			return null;
		}
	}

	/**
	 * description: 파일목록 구하기 - 폴더 제외
	 * @param path
	 * @return
	 * @return
	 */
	public static File[] fileList(String path){
		File root=new File(path);
		File[] listFile=root.listFiles();
		if(listFile!=null){
			ArrayList folderList=new ArrayList();
			for(int i=0;i<listFile.length;i++){
				if(!listFile[i].isDirectory()){
					folderList.add(listFile[i]);
				}
			}
			return (File[])(folderList.toArray(new File[0]));
		}else {
			return null;
		}
	}

	/**
	 * description: 디렉토리 삭제
	 * @param path
	 * @return
	 * @return
	 */
    public static boolean rmDir ( String path ) {

		File dir, dirFile;
		String fileList[], fileDirList[];
		String addr = null;

		boolean isSuccessFlag = false;

		try {
			//set root directory
			addr = path;
			dir = new File(addr);

			if ( dir != null ) {
				//read file & directory list
				fileList = dir.list();

				for(int i = 0; i < fileList.length; i++){
					dirFile = new File(addr+"/"+fileList[i]);
					// if file
					if(dirFile.isFile()){
						dirFile.delete();

					//if directory
					}else if(dirFile.isDirectory()){

						fileDirList = dirFile.list();
						for(int j = 0; j < fileDirList.length; j++){
							FileDeleteDir(addr+"/"+fileList[i]+"/"+fileDirList[j]);
						}dirFile.delete();
					}
				}

				dir.delete();

				isSuccessFlag = true;
			}

		} catch ( Exception ex ) {
			CommonUtil.printStatckTrace(ex);//오류메시지를 통한 정보노출
		}

		return isSuccessFlag;
	}


    /**
	 * description: 서브디렉토리까지 삭제
	 * @param fDir
	 * @return
	 * @return
	 */
	public static boolean FileDeleteDir ( String fDir ) {
		File subFile = new File(fDir);
		if(subFile.isFile()){
			subFile.delete();
		}else if(subFile.isDirectory()){
			String subFList[] = subFile.list();
			for(int i = 0; i < subFList.length; i++){
				FileDeleteDir(fDir+"/"+subFList[i]);
			}subFile.delete();
		}
		return true;
	}

	/**
	 * description: io패키지를 이용한 파일 복사
	 * @param oldfile 원래파일명[폴더포함]
     * @param targetfile 새파일명[폴더포함]
	 * @return
	 * @throws Exception
	 */
    public static void copyIO(String oldfile, String targetfile) throws Exception{

    	File f = new File(oldfile);
    	File tf = new File(targetfile);
    	if(f.isDirectory()){
    		if(!tf.exists()){
    			tf.mkdirs();
        	}
    		String[] children = f.list();
    		//System.out.println("File = "+f);
    		for(int i = 0; i < children.length; i++){
    			copyIO(oldfile+"/"+children[i], targetfile+"/"+children[i]);
    		}
    	}else{
	        FileInputStream fIn = null;
	        FileOutputStream fOut = null;
	        FileChannel in = null;
	        FileChannel out = null;

	        try {
		        fIn= new FileInputStream(oldfile);
		        fOut= new FileOutputStream(targetfile);
		        in=fIn.getChannel();
		        out=fOut.getChannel();

		        byte[] buf=new byte[1024];
			    for (int i; (i=fIn.read(buf))!=-1; ) {
			        fOut.write(buf, 0, i);
			    }
	        } catch (Exception e) {
	        	CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
	        } finally {
	            if(in != null) {
	            	try{ in.close();}catch(Exception ignore){CommonUtil.printStatckTrace(ignore);//오류메시지를 통한 정보노출 
	            	}
	            	
	            }
	            if(out != null) {
	            	try{ out.close(); }catch(Exception ignore){ CommonUtil.printStatckTrace(ignore);//오류메시지를 통한 정보노출
	            	}
	            }
	            if(fIn != null) {
	            	try{ fIn.close();}catch(Exception ignore){ CommonUtil.printStatckTrace(ignore);//오류메시지를 통한 정보노출
	            	}
	            }
	            if(fOut != null) {
	            	try{ fOut.close(); }catch(Exception ignore){CommonUtil.printStatckTrace(ignore);//오류메시지를 통한 정보노출
	            	}
	            }
	        }
    	}
    }

    /**
     * description: MappedByteBuffer를 이용한 파일간 복사
     * @param oldfile 원래파일명[폴더포함]
     * @param targetfile 새파일명[폴더포함]
     * @throws Exception
     */
    public static void copyMap(String oldfile, String targetfile) throws Exception{

        FileInputStream fIn=new FileInputStream(oldfile);
        FileOutputStream fOut=new FileOutputStream(targetfile);
        FileChannel in=fIn.getChannel();
        FileChannel out=fOut.getChannel();

        try {
	        // 입력파일을 매핑한다.
	        MappedByteBuffer m=in.map(FileChannel.MapMode.READ_ONLY,0,in.size());
	        //파일을 복사한다.
	        out.write(m);
        } catch (Exception e) {
        	CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
        } finally {
            if(in != null) {
            	try{ in.close();}catch(Exception ignore){ 
            		CommonUtil.printStatckTrace(ignore);//오류메시지를 통한 정보노출 
            	}
            	
            }
            if(out != null) {
            	try{ out.close(); }catch(Exception ignore){
            		CommonUtil.printStatckTrace(ignore);//오류메시지를 통한 정보노출
            	}
            }
            if(fIn != null) {
            	try{ fIn.close();}catch(Exception ignore){
            		CommonUtil.printStatckTrace(ignore);//오류메시지를 통한 정보노출 
            	}
            }
            if(fOut != null) {
            	try{ fOut.close(); }catch(Exception ignore){
            		CommonUtil.printStatckTrace(ignore);//오류메시지를 통한 정보노출 
            	}
            }
        }
    }

    /**
     * description: read()와 write()사용한 파일 복사
     * @param oldfile 원래파일명[폴더포함]
     * @param targetfile 새파일명[폴더포함]
     * @throws Exception
     */
    public static void copyNIO(String oldfile, String targetfile) throws Exception{

    	File f = new File(oldfile);
    	if(f.isDirectory()){
    		String[] children = f.list();
    		for(int i = 0; i < children.length; i++){
    			copyIO(oldfile+"/"+children[i], targetfile+"/"+children[i]);
    		}
    	}else{
	        FileInputStream fIn=new FileInputStream(oldfile);
	        FileOutputStream fOut=new FileOutputStream(targetfile);
	        FileChannel in=fIn.getChannel();
	        FileChannel out=fOut.getChannel();
	        try{
		        ByteBuffer buf=ByteBuffer.allocate((int)in.size());//버퍼를 읽기를 할 파일의 크기만큼 생성
			    in.read(buf);// 읽기
			    buf.flip(); // 버퍼의 position을 0으로 만든다.
			    out.write(buf);// 쓰기
	        } catch (Exception e) {
	        	CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
	        } finally {
	            if(in != null) {
	            	try{ in.close();}catch(Exception ignore){CommonUtil.printStatckTrace(ignore);//오류메시지를 통한 정보노출 
	            	}
	            }
	            if(out != null) {
	            	try{ out.close(); }catch(Exception ignore){CommonUtil.printStatckTrace(ignore);//오류메시지를 통한 정보노출 
	            	}
	            }
	            if(fIn != null) {
	            	try{ fIn.close();}catch(Exception ignore){ CommonUtil.printStatckTrace(ignore);//오류메시지를 통한 정보노출
	            	}
	            }
	            if(fOut != null) {
	            	try{ fOut.close(); }catch(Exception ignore){ CommonUtil.printStatckTrace(ignore);//오류메시지를 통한 정보노출
	            	}
	            }
	            f.delete();
	        }
    	}
    }

    /**
     * description: transferTo() 사용한 파일 복사[이게 젤루 빠름]
     * @param oldfile 원래파일명[폴더포함]
     * @param targetfile 새파일명[폴더포함]
     * @throws Exception
     */
    public static void copyTransfer(String oldfile, String targetfile) throws Exception{
    	File srcFile = new File(oldfile) ;
    	File destFile = new File(targetfile) ;
    	org.apache.commons.io.FileUtils.copyFile(srcFile, destFile);
    }

    /**
     *  description: transferTo() 사용한 파일 복사후 원래파일삭제[이게 젤루 빠름]
     * @param oldfile 원래파일명[폴더포함]
     * @param targetfile 새파일명[폴더포함]
     * @throws Exception
     */
    public static void moveTransfer(File oldfile, File targetfile) throws Exception{
		if(oldfile.isDirectory()){
			boolean rename = oldfile.renameTo(targetfile);
	    	if (!rename) {
	    		if (targetfile.getCanonicalPath().startsWith(oldfile.getCanonicalPath())) {
	    			throw new IOException("Cannot move directory: "+oldfile+" to a subdirectory of itself: "+targetfile);
	    		}
		        org.apache.commons.io.FileUtils.copyDirectory( oldfile, targetfile );
		        org.apache.commons.io.FileUtils.deleteDirectory( oldfile );
		        if (oldfile.exists()) {
//		            throw new IOException("Failed to delete original directory '" + oldfile +
//		                    "' after copy to '" + targetfile + "'");
		            //System.out.println("ignore: Failed to delete original directory '" + oldfile +"' after copy to '" + targetfile + "'");
		        }
	        	
	        }
		}else {
			 boolean rename = oldfile.renameTo(targetfile);
			 
		     if (!rename) {
		         org.apache.commons.io.FileUtils.copyFile( oldfile, targetfile );
		         if (!oldfile.delete()) {
		        	 org.apache.commons.io.FileUtils.deleteQuietly(targetfile);
//		             throw new IOException("Failed to delete original file '" + oldfile +
//		                 "' after copy to '" + targetfile + "'");
		             //System.out.println("ignore: Failed to delete original file '" + oldfile +"' after copy to '" + targetfile + "'");
		         }
		     }
		}
    }
    /**
     *  description: transferTo() 사용한 파일 복사후 원래파일삭제[이게 젤루 빠름]
     * @param oldfile 원래파일명[폴더포함]
     * @param targetfile 새파일명[폴더포함]
     * @throws Exception
     */
    public static void moveTransfer(String oldFilePathName, String targetFilePathName) throws Exception{
    	File  oldfile = new File(oldFilePathName);
    	File  targetfile = new File(targetFilePathName);
    	 if(oldfile.isDirectory()){
    		 boolean rename = oldfile.renameTo(targetfile);
    	        if (!rename) {
    	            if (targetfile.getCanonicalPath().startsWith(oldfile.getCanonicalPath())) {
    	                throw new IOException("Cannot move directory: "+oldfile+" to a subdirectory of itself: "+targetfile);
    	            }
    	            org.apache.commons.io.FileUtils.copyDirectory( oldfile, targetfile );
    	            org.apache.commons.io.FileUtils.deleteDirectory( oldfile );
    	            if (oldfile.exists()) {
    	                throw new IOException("Failed to delete original directory '" + oldfile +
    	                        "' after copy to '" + targetfile + "'");
    	            }
    	        }
    	 }else {
	    	 boolean rename = oldfile.renameTo(targetfile);
	    	 
	         if (!rename) {
	             org.apache.commons.io.FileUtils.copyFile( oldfile, targetfile );
	             if (!oldfile.delete()) {
	            	 org.apache.commons.io.FileUtils.deleteQuietly(targetfile);
	                 throw new IOException("Failed to delete original file '" + oldfile +
	                         "' after copy to '" + targetfile + "'");
	             }
	         }
    	 }
//        if(oldfile.isDirectory()){
//        	if(!targetfile.exists()){
//        		targetfile.mkdirs();
//        	}
//        	String[] children = oldfile.list();
//        	for(int i = 0; i < children.length; i++){
//        		moveTransfer(new File(oldfile, children[i]),new File(targetfile, children[i]));
//        	}
//        }else{
//        	FileInputStream f_in=new FileInputStream(oldfile);
//            FileOutputStream f_out=new FileOutputStream(targetfile);
//            FileChannel in=f_in.getChannel();
//            FileChannel out=f_out.getChannel();
//
//            try {
//    	        in.transferTo(0,in.size(),out);// 0부터 읽기용 채널 크기까지 쓰기채널에 출력한다.
//    	        // 원래파일 삭제처리
//    	        if(oldfile.exists()) {
//    	        	isDelete = oldfile.delete();
//    	        }
//            } catch (Exception e) {
//            	e.printStackTrace();
//            } finally {
//                if(in != null) try{ in.close();}catch(Exception ignore){ }
//                if(out != null) try{ out.close(); }catch(Exception ignore){ }
//                if(f_in != null) try{ f_in.close();}catch(Exception ignore){ }
//                if(f_out != null) try{ f_out.close(); }catch(Exception ignore){ }
//            }
//        }
    }
    /**
     * description: transferTo() 사용한 파일 복사후 원래파일삭제[이게 젤루 빠름]
     * @param oldfile 원래파일명[폴더포함]
     * @param targetfile 새파일명[폴더포함]
     * @throws Exception
     */
    public static void moveDirs(File oldfile, File targetfile) throws Exception{

        if(oldfile.isDirectory()){
        	if(!targetfile.exists()){
        		targetfile.mkdirs();
        	}
        	String[] children = oldfile.list();
        	for(int i = 0; i < children.length; i++){
        		if(!children[i].equals("imsmanifest.xml")){
        			copyIO((oldfile+"/"+children[i]),(targetfile+"/"+children[i]));
        		}
        	}
        }else{
        	oldfile.renameTo(targetfile);
        }
    }

    /**
     * description: 파일의 목록을 리턴
     * @param dir
     * @param checksubdir
     * @return
     */
	public ArrayList scanDir(String dir, boolean checksubdir){
		try{
			File file = new File(dir);
			if(file.exists()){
				for(int i = 0; i < file.list().length; i++){
					File tmpfile = new File(dir+File.separator+file.list()[i]);
					if(tmpfile.isDirectory() && checksubdir){
						this.scanDir(dir+File.separator+file.list()[i], checksubdir);
					}else{
						this.fileList1.add(tmpfile);
					}
				}
			}
			return fileList1;
		}
		catch(Exception e){
			return fileList1;
		}
	}

	/**
	 * description: 압축해제
	 * @param zipFile
	 * @param toDir
	 * @param encoding
	 * @throws Exception
	 */
	public static void unzip(ZipFile zipFile, String toDir,String encoding) throws Exception {
        for(Enumeration zipEntries = zipFile.entries(); zipEntries.hasMoreElements();)
        {
            ZipEntry entry = (ZipEntry)zipEntries.nextElement();
            String name = entry.getName();
            name = new String(name.getBytes("latin1"), encoding);
            name = name.replaceAll("\\\\","/");
            InputStream zis = null;
            FileOutputStream fos = null;
            File uncompressedFileDir = null;
            File uncompressedFile = null;
            if(!entry.isDirectory())
            {
                zis = zipFile.getInputStream(entry);
                if(name.split("/").length > 1){
                    uncompressedFileDir = new File(toDir+"/"+name.substring(0,name.lastIndexOf("/")));
                    uncompressedFileDir.mkdirs();
                }
                String tempFile = toDir+File.separator+name;
                uncompressedFile = new File(tempFile);
                if(!uncompressedFile.exists() && !uncompressedFile.createNewFile()) {
                    throw new Exception(name + " 파일 생성 실패");
                }
                if(!uncompressedFile.isDirectory()){
	                fos = new FileOutputStream(uncompressedFile);
	                byte buffer[] = new byte[4096];
	                int read = 0;
	                for(read = zis.read(buffer); read >= 0; read = zis.read(buffer)) {
	                    fos.write(buffer, 0, read);
	                }

	                fos.close();
	                zis.close();
                }
            }
        }
        zipFile.close();

	}

	/**
	 * description: 압축해제
	 * @param toDir
	 * @param files
	 * @param key
	 * @return
	 * @throws Exception
	 */
	public static String[] unzip(String toDir,String[] files) throws Exception {
        String encoding = "MS949";
        String[] retval = new String[files.length];
        for(int i = 0 ; i < files.length; i++){
        	String pifFolder = files[i].substring(0,files[i].lastIndexOf("."));
        	String pifFile = files[i].substring(files[i].lastIndexOf(File.separator));
            File givenFile = new File(toDir+File.separator+pifFolder+File.separator+pifFile);
            File dir = new File(toDir+File.separator+files[i].substring(0, files[i].lastIndexOf(".zip")));
            if(!dir.isDirectory()) {
            	dir.mkdirs();
            }
            if(givenFile.exists()){
	            ZipFile zipFile = new ZipFile(givenFile);
	            unzip(zipFile,toDir+File.separator+pifFolder,encoding);
            }
            givenFile.delete();
            givenFile.deleteOnExit();
            retval[i] =toDir+File.separator+files[i].substring(0,files[i].lastIndexOf("."));
        }
		return retval;
	}

	/**
	 * description: 파일저장
	 * @param f
	 * @param filedecs
	 * @throws Exception
	 */
    public static void makeFile(File f, String filedecs) throws Exception{
    	f.delete();
        FileOutputStream fOut=new FileOutputStream(f);
        byte[] b = filedecs.getBytes("euc-kr");
        try {
	        fOut.write(b);
        } catch (Exception e) {
        	CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
        } finally {
            if(fOut != null) {
            	fOut.close();
            }
        }
    }
    

	public static void copyFile(final CommonsMultipartFile sourceFile, 
								   final File destFile) throws IOException {
		FileItem fileItem = sourceFile.getFileItem() ;
		byte buffer[] = new byte[NeosConstants.LARGE_FILE_BUFFER_SIZE];
		
		InputStream in = fileItem.getInputStream();
		OutputStream out = new FileOutputStream(destFile);
		try {
			IOUtils.copyLarge(in, out, buffer);
		} catch ( Exception e ) {
			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
		} finally {
			if (in != null) {
				try {
				in.close();
				}catch(Exception e ) {CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
				}
			}
			if (out != null) {
				try {
					out.close();
				}catch(Exception e ) {CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
				}
			}
			if(fileItem != null ) {
				try {
					fileItem.delete();
				}catch(Exception e ) {CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
				}
			}
			
		}

	}
	
	public static File getUrlFileDownload(String urlStr, String filePath) {
		OutputStream outStream = null;
		URLConnection uCon = null;

		InputStream is = null;
		try {
			File f = new File(filePath);
			if(!f.getParentFile().exists()){
				f.getParentFile().mkdirs();
        	}


			URL url;
			byte[] buf;
			int byteRead;
//			int byteWritten = 0;
			url = new URL(urlStr);
			outStream = new BufferedOutputStream(new FileOutputStream(filePath));

			uCon = url.openConnection();
			is = uCon.getInputStream();
			buf = new byte[1024];
			while ((byteRead = is.read(buf)) != -1) {
				outStream.write(buf, 0, byteRead);
//				byteWritten += byteRead;
			}

		} catch (Exception e) {
			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
		} finally {
			try {
				if (is != null) {
					is.close();
				}
				if (outStream != null) {
					outStream.close();
				}
			} catch (IOException e) {
				CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
			}
		}

		return new File(filePath);

	}
	
	public static boolean cmprsFile(List<Map<String,Object>> list, String rootPath, String target) throws Exception {
		// 압축성공여부
		boolean result = false;
		int cnt = 0;
        // 읽어들일 byte 버퍼
        byte[] buffer = new byte[BUFFER_SIZE];

        FileInputStream finput = null;
        FileOutputStream foutput = null;
        ZipOutputStream zoutput = null;

//        String source1 = source.replace('\\', FILE_SEPARATOR).replace('/', FILE_SEPARATOR);
        String target1 = target.replace('\\', FILE_SEPARATOR).replace('/', FILE_SEPARATOR);
//        File srcFile = new File(source1);

        String target2 = EgovFileTool.createNewFile(target1);
        File tarFile = new File(target2);

        ZipEntry zentry = null;

        try {
        	foutput = new FileOutputStream(tarFile);
        	zoutput = new ZipOutputStream((OutputStream)foutput);

        	for(int i = 0; i < list.size(); i++) {
        		Map<String,Object> fileMap = list.get(i);
        		String fileStreCours = fileMap.get("fileStreCours")+"";	//파일저장상대경로
        		String streFileName = fileMap.get("streFileName")+"";	//저장파일명
        		String orignlFileName = fileMap.get("orignlFileName")+"";//원파일명
        		String fileExtsn = fileMap.get("fileExtsn")+"";	//파일확장자
        		
        		String fullPath = rootPath+FILE_SEPARATOR+fileStreCours+FILE_SEPARATOR+streFileName+"."+fileExtsn;
        		
        		File sfile = new File(fullPath);
        		finput = new FileInputStream(sfile);
        		zentry = new ZipEntry(orignlFileName+"."+fileExtsn);
        		zoutput.putNextEntry(zentry);
        		zoutput.setLevel(COMPRESSION_LEVEL);
        		cnt = 0;
        		while ((cnt = finput.read(buffer)) != -1) {
        			zoutput.write(buffer, 0, cnt);
        		}
        		finput.close();
        		result = true;
        	}
        	zoutput.closeEntry();
        } catch (Exception e) {
        	tarFile.delete();
        	throw e;	 
        } finally {
        	close(finput);
        	close(zoutput);
        	close(foutput);
        }
        return result;
	}
	
	protected static void close(Closeable closable) {
		if (closable != null) {
			try {
				closable.close();
			} catch (IOException ignore) {
				CommonUtil.printStatckTrace(ignore);//오류메시지를 통한 정보노출
			}
		}
	}
	
	public static File getStringToFile(String s, String filePath) {
		try {
            File f = new File(filePath);

            if(!f.getParentFile().exists()){
				f.getParentFile().mkdirs();
        	}
            
            FileWriter fw = new FileWriter(f);
            fw.write(s);
            fw.close();
            
            return f;

        } catch (IOException iox) {
        	System.err.println(iox);//오류 상황 대응 부재
        }
		return null;
	}
	
	public static File getByteToFile(byte[] b, String filePath) {
		
		File f = new File(filePath);
		
		if(!f.getParentFile().exists()){
			f.getParentFile().mkdirs();
    	}
		
		FileOutputStream fileOuputStream = null;
		try {
			fileOuputStream = new FileOutputStream(f);
			fileOuputStream.write(b);
			fileOuputStream.close();
			
		} catch (FileNotFoundException e) {
			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
		} catch (IOException e) {
			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
		} finally {
			if (fileOuputStream != null) {
				try {
					fileOuputStream.close();
				} catch (IOException e) {
					CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
				}
			}
		}

        
		return f;
	}
	
	
	public static long copyFile(File input, OutputStream output) throws IOException
	{
		FileInputStream fis = new FileInputStream(input);
		try {
			long l = IOUtils.copyLarge(fis, output);

			return l;
		} finally {
			fis.close();
		}
	}
	
	public static long createZipDir(String filePath, String toDir) throws IOException {
		
		File file = new File(toDir);
		
		ArrayList<File> list = dirFileList(file.getAbsolutePath());
		
		return zipCompression(list, filePath);
	}
	
	public static long createZipFile(String toFilePath, String fromFilePath) throws IOException {
		
		ArrayList<File> list = new ArrayList<>();
		
		list.add(new File(fromFilePath));
		
		return zipCompression(list, toFilePath);
	}
	
	public static long zipCompression(List<File> list, String output) throws IOException {
		// 압축성공여부
		int cnt = 0;
		// 읽어들일 byte 버퍼
		byte[] buffer = new byte[BUFFER_SIZE];

		FileInputStream finput = null;
		FileOutputStream foutput = null;
		ZipOutputStream zoutput = null;

		File outputFile = new File(output);
		
		if (! outputFile.getParentFile().exists()) {
			outputFile.getParentFile().mkdirs();
		}
		
		if (! outputFile.exists()) {
			outputFile.createNewFile();
		}

		ZipEntry zentry = null;

		try {
			foutput = new FileOutputStream(outputFile);
			zoutput = new ZipOutputStream((OutputStream)foutput);

			for(File sfile : list) {

				finput = new FileInputStream(sfile);
				zentry = new ZipEntry(sfile.getName());
				zoutput.putNextEntry(zentry);
				zoutput.setLevel(COMPRESSION_LEVEL);
				cnt = 0;
				while ((cnt = finput.read(buffer)) != -1) {
					zoutput.write(buffer, 0, cnt);
				}
				finput.close();
			}
			zoutput.closeEntry();
		} catch (Exception e) {
			outputFile.delete();
			throw e;	 
		} finally {
			close(finput);
			close(zoutput);
			close(foutput);
		}
		return outputFile.length();
	}
	
	/**
	 * 파일 디렉토리 목록 조회
	 * @param path
	 * @return
	 */
	public static ArrayList<File> dirFileList(String path){
		File root=new File(path);
		File[] listFile=root.listFiles();
		if(listFile!=null){
			ArrayList<File> folderList=new ArrayList<>();
			for(int i=0;i<listFile.length;i++){
				folderList.add(listFile[i]);
			}
			return folderList;
		}else {
			return null;
		}
	}
	
	public static boolean isNotEmpty(String filePath) {
		if(StringUtils.isNotEmpty(filePath)) {
			File file = new File(filePath);
			
			if(file.length() > 0) {
				return true;
			}
		}
		
		return false;
	}
	
}
