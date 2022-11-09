package neos.cmm.util.file;

import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.springframework.web.multipart.MultipartFile;

public interface  UploadFileService {
	public void upload( List<MultipartFile> files,  HttpServletRequest request) throws Exception;
}
