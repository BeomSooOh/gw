	/**
	 * @Class Name : JqueryAjaxFileUploaderHandler.js
	 * @Description : ajaxfileupload.js   plugin  을 이용하여 파일 업로드 를 실행해주는 js 파일
	 * @Modification Information
	 * @
	 * @  수정일                 수정자            수정내용
	 * @ ----------   --------    ---------------------------
	 * @ 2012.05.22    김석환             최초 생성
	 *
	 *  @author 포털개발팀 김석환
	 *  @since 2012.05.22
	 *  @version 1.0
	 *  @see
	 *  JqueryAjaxFileUploaderHandler
	 *
	 */


var JqueryAjaxFileUploaderHandler = {};
JqueryAjaxFileUploaderHandler.FilenameUnique = "";
JqueryAjaxFileUploaderHandler.selectFileName = "";
JqueryAjaxFileUploaderHandler.fileType = "portalFile";
/*
	  var obj = {};
	  obj.url = "url";//업로드 처리할 주소
	  obj.file = "fileid";//<input type="file" id="fileid" />
	  obj.extention = ["png","jpg","jpeg"];//업로드 가능한 파일 확장자 리스트
	  obj.extention_msg = "이미지만 업로드 가능합니다.";////업로드 가능한 파일 확장자 가 아닐경우 메시지
	  obj.filename = "filename";//업로드 할 파일이름 (없어도됨)
	  obj.successFn= fn; //성공 했을경우 실행할 함수명(String 아님)
	  obj.errorFn = fn;//실패했을경우 실행할 함수명(String 아님)
	  JqueryAjaxFileUploaderHandler.FileUploader(obj);
 * 
 * */
JqueryAjaxFileUploaderHandler.FileUploader = function(obj){
	 if(!obj || !obj.file){
    	 return false;
     }
     JqueryAjaxFileUploaderHandler.fileType = obj.fileType || JqueryAjaxFileUploaderHandler.fileType;
       
     JqueryAjaxFileUploaderHandler.selectFileName = $("#" + obj.file).val();
     var selectFileName = JqueryAjaxFileUploaderHandler.selectFileName;
     
     if(obj.extention && obj.extention.length && obj.extention[0]){//허용 가능한 파일을 설정했을 경우
    	 var extention = selectFileName.substring(selectFileName.lastIndexOf(".") + 1);
    	 var isExtention = false;
    	 for(var i = 0;i< obj.extention.length;i++){
    		 if(extention.toLocaleLowerCase() == obj.extention[i].toLocaleLowerCase()){
    			 isExtention = true;
    		 }
    	 }
    	 if(!isExtention){
    		 alert(obj.extention_msg);
    		 return false;
    	 }
     }
     
     if(obj.noextention && obj.noextention.length && obj.noextention[0]){//불가능한 파일을 설정했을 경우
    	 var extention = selectFileName.substring(selectFileName.lastIndexOf(".") + 1);
    	 var isNoExtention = true;
    	 for(var i = 0;i< obj.noextention.length;i++){
    		 if(extention.toLocaleLowerCase() == obj.noextention[i].toLocaleLowerCase()){
    			 isNoExtention = false;
    		 }
    	 }
    	 if(!isNoExtention){
    		 alert(obj.noextention_msg);
    		 return false;
    	 }
     }
     var url = obj.url;
     var data = {
    		 fileType : JqueryAjaxFileUploaderHandler.fileType
     };
     var filename = obj.filename;
     //alert(url);
     $("#loading")
		.ajaxStart(function() {
		    $(this).show();
		})
		.ajaxComplete(function() {
		    $(this).hide();
		});
     $.ajaxFileUpload({
         url: url  +"?filename=" + filename,
         data : data,
         secureuri: false,
         fileElementId: obj.file,
         dataType: 'json',
         success: function(data, status) {
        	 //alert("s="+data);
        	 try{
        		 if(obj.successFn){
        			 obj.successFn(data, status);
        		 }
        	 }catch(e){
        		 
        	 }
         },
         error: function(data, status, e) {
        	 //alert("f="+data);
        	 try{
        		 if(obj.successFn){
        			 obj.errorFn(data, status, e);
        		 }
        	 }catch(e){
        		 
        	 }
         }
     })
}