package neos.cmm.util.file;
import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;

import net.sf.jazzlib.ZipEntry;
import net.sf.jazzlib.ZipInputStream;
import net.sf.jazzlib.ZipOutputStream;

/**
* FileName : ZipUtils.java
* Comment  : # 인자값 내용
   # createZipFile(압축할디렉토리위치, 저장될zip파일의 경로를 포함한파일명, 디렉토리 없을시 생성여부)
*/
public class ZipUtils {
    private static final byte[] buf = new byte[1024];
    
    /**
    * Comment  : 생성될 ZIP파일의 경로에 디렉토리가 없을경우 에러  발생
    */
    public static void createZipFile(String targetPath, String zipPath)throws Exception{
        createZipFile(targetPath, zipPath, false);
    }
    
    /**
    * Comment  : zip 파일을 생성.
    */
    public static void createZipFile(String targetPath, String zipPath, boolean isDirCre)throws Exception{
        File fTargetPath = new File(targetPath);
        File[] files = null;
        
        if(fTargetPath.isDirectory()){
            files = fTargetPath.listFiles();
        }else{
            files = new File[1];
            files[0] = fTargetPath;
        }
        
        File path = new File(zipPath);
        File dir = null;
        dir = new File(path.getParent());
        if(isDirCre){
            dir.mkdirs();
        }
        
        ZipOutputStream zipOut = new ZipOutputStream(new FileOutputStream(path));
        
        // zip 파일 압축
        makeZipFile(files, zipOut, "");
        
        // stream을 닫음으로서 zip 파일 생성
        zipOut.close();
        
    }
    
    
    /**
    * Comment  : # 일부 파일들을 배열로 설정하여 zip 파일 생성
    * ex) String[] arrZip = new String[]{"C:\\aaa.txt", "C:\\bbb.txt", "C:\\ccc.txt"}
    *     ZipUtils.createZipFile(arrZip, "C:\\test.zip");
    */
    public static void createZipFile(String[] targetFiles, String zipPath)throws Exception{
        createZipFile(targetFiles, zipPath, false);
    }
    
    /**
    * Comment  : # 일부 파일들을 배열로 설정하여 zip 파일 생성 (디렉토리 생성여부 선택)
    */
    public static void createZipFile(String[] targetFiles, String zipPath, boolean isDirCre)throws Exception{
        File[] files = new File[targetFiles.length];
        for(int i = 0; i < files.length; i++){
            files[i] = new File(targetFiles[i]);
        }
        
        File path = new File(zipPath);
        File dir = null;
        dir = new File(path.getParent());
        if(isDirCre){
            // 디렉토리가 없을경우 생성
            dir.mkdirs();
        }
        
        // zip 파일의 outputStream
        ZipOutputStream zipOut = new ZipOutputStream(new FileOutputStream(path));
        
        // zip 파일 압축
        makeZipFile(files, zipOut, "");
        
        // stream을 닫음으로서 zip 파일 생성
        zipOut.close();
    }
    
    
    /**
    * Comment  : zip 파일의 압축을 해제
    */
    public static void unZipFile(String targetZip, String completeDir)throws Exception{
        unZipFile(targetZip, completeDir, false);
    }    
    
    /**
    * Comment  : 
    */
    public static void unZipFile(String targetZip, String completeDir, boolean isDirCre)throws Exception{
        ZipInputStream in = null;
        
        try{
            File fCompleteDir = null;
            fCompleteDir = new File(completeDir);
            if(isDirCre){
                // 디렉토리가 없을경우 생성
                fCompleteDir.mkdirs();
            }
            
            // zip 파일의 input stream을 읽어들임
            in = new ZipInputStream(new FileInputStream(targetZip));
            ZipEntry entry = null;
            
            // input stream내의 압축된 파일들을 하나씩 읽어들임.
            while((entry = in.getNextEntry()) != null){
                //System.out.println("entry : " + entry);
                // zip 파일의 구조와 동일하게 가기위해 로컬의 디렉토리 구조를 만듬.
                String entryName = entry.getName();
                if(entry.getName().lastIndexOf("/") > 0){
                    String mkDirNm = entryName.substring(0, entryName.lastIndexOf("/"));
                    //System.out.println("mkDirNm : " + mkDirNm);
                    new File(completeDir + mkDirNm).mkdirs();
                }
                // 해제할 각각 파일의 output stream을 생성
                FileOutputStream out = new FileOutputStream(completeDir + entry.getName());
                
                int bytesRead;
                while((bytesRead = in.read(buf)) != -1){
                    //System.out.println("bytes_read : " + bytesRead);
                    out.write(buf, 0, bytesRead);
                }
                // 하나의 파일이 압축해제됨
                out.close();
            }
        }catch(Exception e){
            throw new Exception(e);
        }finally{
            // 모든 파일의 압축이 해제되면 input stream을 닫는다.
        	if(in!=null) {//Null Pointer 역참조
            in.close();
        	}
        }
    }
    
    // byte 배열을 받아서 압축된 byte배열을 리턴
    public static byte[] compressToZip(byte[] src)throws Exception{
        byte[] retSrc = null;
        ByteArrayOutputStream baos = null;
        
        try{
            // zip 파일의 output Stream
            ByteArrayInputStream bais = new ByteArrayInputStream(src);
            baos = new ByteArrayOutputStream();
            ZipOutputStream zos = new ZipOutputStream(baos) ;
            
            zos.putNextEntry(new ZipEntry("temp.tmp"));
            
            int bytesRead = 0;
            // 전달받은 src를 압축하여 파일에 씀
            while((bytesRead = bais.read(buf)) != -1){
                zos.write(buf, 0, bytesRead);
            }
            bais.close();
            zos.close();
            
            // 스트림을 닫은후 byte배열을 얻어옴
            retSrc = baos.toByteArray();
        }catch(Exception e){
            throw new Exception(e);
        }finally{
        	if(baos!=null) {//Null Pointer 역참조
            baos.close();
        	}
        }
        
        return retSrc;
    }
    
    // 압축된 byte 배열을 받아서 zipPath위치에 zip 파일을 생성한다.
    private static void makeZipFile(byte[] src, String zipPath)throws Exception{
        FileOutputStream fos = null;
        ByteArrayInputStream bais = null;
        
        try{
            fos = new FileOutputStream(zipPath);
            bais = new ByteArrayInputStream(src);
            
            int bytesRead = 0;
            while((bytesRead = bais.read(buf)) != -1){
                fos.write(buf, 0, bytesRead);
            }
            
        }catch(Exception e){
            throw new Exception(e);
        }finally{
        	if(fos!=null) {//Null Pointer 역참조
            fos.close();
        	}
        	if(bais!=null) {//Null Pointer 역참조
            bais.close();
        	}
        }
    }
    
    // 압축된 byte 배열의 압축을 해제하여 byte배열로 리턴
    public static byte[] unZip(byte[] src)throws Exception{
        
        byte[] retSrc = null;
        ByteArrayOutputStream baos = null;
        ZipInputStream zis = null;
        int bytesRead = 0;
        
        try{
            zis = new ZipInputStream(new ByteArrayInputStream(src));
            baos = new ByteArrayOutputStream();
            
            zis.getNextEntry(); // entry는 하나밖에 없음을 보장
            while((bytesRead = zis.read(buf)) != -1){
                baos.write(buf, 0, bytesRead);
            }
            
            retSrc = baos.toByteArray();
        }catch(Exception e){
            throw new Exception(e);
        }finally{
        	if(baos!=null) {//Null Pointer 역참조
            baos.close();
        	}
        	if(zis!=null) {//Null Pointer 역참조
            zis.close();
        	}
        }
        
        return retSrc;
    }
    
    // 문자열을 압축하여 byte배열로 리턴(UTF-8)
    public static byte[] compressToZip(String src)throws Exception{
        return compressToZip(src.getBytes("UTF-8"));
    }
    
    // byte배열을 압축하여 zip 파일로 생성
    public static void srcToZipFile(byte[] src, String zipPath)throws Exception{
        byte[] retSrc = null;
        // 압축
        retSrc = compressToZip(src);
        
        // 파일로 만듬
        makeZipFile(retSrc, zipPath);
    }
    
    // byte 배열을 압축하여 zip 파일로 생성
    public static void srcToZipFile(String src, String zipPath)throws Exception{
        byte[] retSrc = null;
        
        // 압축
        retSrc = compressToZip(src.getBytes("UTF-8"));
        
        // 파일로 만듬
        makeZipFile(retSrc, zipPath);
    }
    
    public static void makeZipFile(File[] files, ZipOutputStream zipOut, String targetDir) throws Exception{
    	
        for(int i = 0; i < files.length; i++){
            File compPath = new File(files[i].getPath());

            if(compPath.isDirectory()){
                File[] subFiles = compPath.listFiles();
                makeZipFile(subFiles, zipOut, targetDir+compPath.getName()+"/");
                continue;
            }
            
            FileInputStream in = new FileInputStream(compPath);
            zipOut.putNextEntry(new ZipEntry(targetDir + "/" + files[i].getName()));
            //zipOut.putNextEntry(new ZipEntry(targetDir + "/" + new String( files[i].getName().getBytes( "EUC-KR" ), "UTF-8" )));

            int data;

            while((data = in.read(buf)) > 0){
                zipOut.write(buf, 0, data);    
            }
            zipOut.closeEntry();
            in.close();
        }
    }

}