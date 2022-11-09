<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.io.*"%>
<%@ page import="java.text.*" %>
<%@ page import="java.lang.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.net.*" %>
<%
	request.setCharacterEncoding("UTF-8");


    String filename = "oneffice.html";


    InputStream in = null;
    OutputStream os = null;
    File file = null;
    boolean skip = false;
    String agentName = "";

    String path = "./oneffice";
    ServletContext context = getServletContext();
    String savePath = context.getRealPath(path);
    String queryString = request.getQueryString();

    //param이 없으면 index.html 로딩
	//TODO: param에 "chgown"이 있으면 index.html 로딩 (UCDOC-1340)
    if (queryString == null || queryString.length() == 0) {
        filename = "index.html";
    }

    agentName = request.getHeader("User-Agent").toLowerCase();


    //if (agentName.indexOf("iphone") != -1 || agentName.indexOf("ipad") != -1 || agentName.indexOf("ipot") != -1 || agentName.indexOf("android") != -1) {
    //        filename = "oneffice_view.html";
    //}


    try{

		response.setContentType("text/html;charset=UTF-8");
		 
         // 파일을 읽어 스트림에 담기
        try{
            file = new File(savePath, filename);
            in = new FileInputStream(file);
        }catch(FileNotFoundException fe){
            skip = true;
        }
 
        if(!skip){
 
            os = response.getOutputStream();
            byte b[] = new byte[(int)file.length()];
            int leng = 0;
             
            while( (leng = in.read(b)) > 0 ){
                os.write(b,0,leng);
            }
 
        } else {

            out.println("<script language='javascript'>alert('파일을 찾을 수 없습니다');</script>");
 
        }
         
        in.close();
        os.close();
 
    }catch(Exception e){
      e.printStackTrace();
    }

%>