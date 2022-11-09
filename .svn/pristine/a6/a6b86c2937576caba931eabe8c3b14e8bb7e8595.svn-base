<%@ page contentType="text/html;charset=utf-8"%><%
	request.setCharacterEncoding("UTF-8");

	Raonwiz.Dext5.UploadHandler upload = new Raonwiz.Dext5.UploadHandler();
	Raonwiz.Dext5.UploadCompleteEventClass event = new Raonwiz.Dext5.UploadCompleteEventClass();

	String sPathChar = java.io.File.separator;
    
    		
    if (request.getParameter("tempPath") != null) {
    	
    	String sPath = request.getParameter("tempPath");
    	
        upload.SetTempPath(sPath);
        upload.SetPhysicalPath(sPath);
        upload.SetMultipartTempPath(sPath);    

        upload.SetGarbageCleanDay(2);
        String result = upload.Process(request, response, event); // 서버 이벤트 사용시 반드시 3번째 파라미터의 event 객체를 Setting 해줘야 합니다.

    	out.clear();
        if(!result.equals("")) {
    		out.print(result);
    	} else {
    		out.clear();
    	}
    	
    }else{
    	out.print("Hi, DEXT5 Upload !!!???-2.7.1127812.1000.01--");
    }
    

%>