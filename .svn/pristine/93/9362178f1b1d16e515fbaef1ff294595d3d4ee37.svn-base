/**
 * 
 */
var g_arrContentType; 
var g_arrUserName; 
var g_arrUserKey ;
var g_arrOrgnztID;


	function popCheckedUser() {
		var methodName = "";
		var pageTitle = "" ;
		var arrContentType ; 
		var arrUserName ;
		var arrUserKey ;
		var arrOrgnztID ;
		var tabNumber = $("#showTabNumber").val() ;	
		
		methodName = "setCheckedUser" ;
		pageTitle = "열람대상자"; 
		$("#methodName").val("setCheckedUser") ;
		$("#pageTitle").val("열람대상자") ;
	
		g_arrContentType =  $("#readingCSVContentType_"+tabNumber).val()  ; 
		g_arrUserName = $("#readingCSVUserName_"+tabNumber).val()  ;
		g_arrUserKey  = $("#readingCSVUserKey_"+tabNumber).val()  ;
		g_arrOrgnztID = $("#readingCSVOrgnztID_"+tabNumber).val()  ;
/*		
    var rowNum = 0 ;
    if( typeof(arrContentType) != "undefined" && !ncCom_Empty(arrContentType))  {
    	arrContentType = arrContentType.split(",");
    	arrUserName =  arrUserName.split(","); 
    	arrUserKey = arrUserKey.split(",");  
    	arrOrgnztID = arrOrgnztID.split(",");  
        rowNum = arrContentType.length ;
    	
        var checkedUserHtml  ="" ;
        var contentType = "" ;
        var orgCode = "" ;
        var userKey = "" ;
        var userName = "" ;
        for(var inx = 0 ; inx < rowNum; inx++) {
            contentType = arrContentType[inx];
            orgCode     = arrOrgnztID[inx];
            userKey     = arrUserKey[inx];
            userName    =arrUserName[inx];
            if(contentType == "C") {
                checkedUserHtml += "<input type = 'hidden'  name = 'readingPositionCode_"+tabNumber+"' value = '"+userKey+"' >";    
            }
            checkedUserHtml += getShareDocHtml(contentType, orgCode, userKey, userName);
            
        }
    }
	$("#idCheckedUser_"+tabNumber).html(checkedUserHtml);
*/	    
		var url = getContextPath()+"/edoc/eapproval/workflow/sharedDocUser.do?methodName="+methodName+"&pageTitle="+pageTitle;
		openWindow2(url, "popSharedDocUser", 550, 570, 0) ;
  }
 
	function setCheckedUser(arrContentType, arrUserName, arrUserKey, arrOrgnztID  ) {
		if( typeof(arrContentType) == "undefined"  ) {
	    	alert("선택된 사용자가 없습니다.");
	        return;
	    } 
/*		
	   	var rowNum = 0 ;
	   	arrContentType = arrContentType.split(",");
	   	arrUserName =  arrUserName.split(","); 
	   	arrUserKey = arrUserKey.split(",");  
	   	arrOrgnztID = arrOrgnztID.split(",");  
   	
       rowNum = arrContentType.length ;
       
       if( typeof(rowNum) == "undefined"  ) {
           rowNum = 0 ;
       }
       
       var userOptionHtml = "" ;
       var contentType = "" ;
       var orgCode = "" ;
       var userKey = "" ;
       var userName = "";
       for(var inx = 0 ; inx < rowNum; inx++) {
           contentType = arrContentType[inx];
           orgCode     = arrOrgnztID[inx];
           userKey     = arrUserKey[inx];
           userName    =arrUserName[inx];
           userOptionHtml += "<option value='"+orgCode+" "+ userKey+"'>"+userName+"</option>"  ; 
           
       }
*/       
	   var tabNumber = $("#showTabNumber").val() ;	
       $("#readingCSVContentType_"+tabNumber).val(arrContentType)  ; 
  	   $("#readingCSVUserName_"+tabNumber).val(arrUserName)  ;
       $("#readingCSVUserKey_"+tabNumber).val(arrUserKey)  ;
  	   $("#readingCSVOrgnztID_"+tabNumber).val(arrOrgnztID)  ;
       $("#readingView_"+tabNumber).val(arrUserName);
      
   }
   
   function getMultiSelectUser(argType) {
   	
   }
   
   function setReadingInfo(argTabNumber) {
		var arrContentType =  $("#readingCSVContentType_"+argTabNumber).val()  ; 
		var arrUserName = $("#readingCSVUserName_"+argTabNumber).val()  ;
		var arrUserKey  = $("#readingCSVUserKey_"+argTabNumber).val()  ;
		var arrOrgnztID = $("#readingCSVOrgnztID_"+argTabNumber).val()  ;
		var checkedUserHtml = "" ;
	
		var rowNum = 0 ;
		if( typeof(arrContentType) != "undefined" && !ncCom_Empty(arrContentType))  {
	    	arrContentType = arrContentType.split(",");
	    	arrUserName =  arrUserName.split(","); 
	    	arrUserKey = arrUserKey.split(",");  
	    	arrOrgnztID = arrOrgnztID.split(",");  
	        rowNum = arrContentType.length ;
	    	
	        var checkedUserHtml  ="" ;
	        var contentType = "" ;
	        var orgCode = "" ;
	        var userKey = "" ;
	        var userName = "" ;
	        for(var inx = 0 ; inx < rowNum; inx++) {
	            contentType = arrContentType[inx];
	            orgCode     = arrOrgnztID[inx];
	            userKey     = arrUserKey[inx];
	            userName    =arrUserName[inx];
	            if(contentType == "C") {
	                checkedUserHtml += "<input type = 'hidden'  name = 'readingPositionCode_"+argTabNumber+"' value = '"+userKey+"' >";    
	            }
	            checkedUserHtml += getReadingHtml(contentType,userName , userKey, orgCode, argTabNumber);
	            
	        }
		}

       $("#idReadingView_"+argTabNumber).html(checkedUserHtml);
	} 
	function setAllReadingInfo() {
		var objCurrentTabNumber =  document.getElementsByName("currentTabNumber") ;
		var rowNum = objCurrentTabNumber.length ;
		var curTabNumber;
		for( inx = 0 ; inx < rowNum; inx++) {
			curTabNumber = parseInt(objCurrentTabNumber[inx].value);
		}
	 	setReadingInfo(curTabNumber);
	}
	function getReadingHtml (readingContentType, readingUserName, readingUserKey, readingOrgnztID,tabNumber) {
       var html =  "<input type = \"hidden\"  name = \"readingContentType_"+tabNumber+"\" id = \"readingContentType_"+tabNumber+"\"  value = \""+readingContentType+"\">"+
                   "<input type = \"hidden\"  name = \"readingUserName_"+tabNumber+"\" id = \"readingUserName_"+tabNumber+"\" value = \""+readingUserName+"\">"+
                   "<input type = \"hidden\"  name = \"readingUserKey_"+tabNumber+"\" id = \"readingUserKey"+tabNumber+"\" value = \""+readingUserKey+"\">"+
                   "<input type = \"hidden\"  name = \"readingOrgnztID_"+tabNumber+"\" id = \"readingOrgnztID"+tabNumber+"\" value = \""+readingOrgnztID+"\">" ;

       return html;
   }	
	
	/**
    <input type = "hidden" name = "readingCSVContentType_${status.count}" id = "readingCSVContentType_${status.count}" value = "" />
		<input type = "hidden" name = "readingCSVUserName_${status.count}" id = "readingCSVUserName_${status.count}" value = "" />
		<input type = "hidden" name = "readingCSVUserKey_${status.count}" id = "readingCSVUserKey_${status.count}" value = "" />
		<input type = "hidden" name = "readingCSVOrgnztID_${status.count}" id = "readingCSVOrgnztID_${status.count}" value = "" />
		<div id = "idReadingView_${status.count}" style="disply:none">
    <c:forEach var="readingMap" items="${docInfoVO.readingList}"  varStatus="subStatus">
        	<input type = "hidden" name = "readingContentType_${status.count}" id = "readingContentType_${status.count}" value = "C" />
        	<input type = "hidden" name = "readingUserName_${status.count}" id = "readingUserName_${status.count}" value = "${readingMap.USER_NAME}" />
        	<input type = "hidden" name = "readingUserKey_${status.count}" id = "readingUserKey_${status.count}" value = "${readingMap.C_RSUSERKEY}" />
        	<input type = "hidden" name = "readingOrgnztID_${status.count}" id = "readingOrgnztID_${status.count}" value = "${readingMap.C_RSORGCODE}" />
    </c:forEach>
	*/
	function initReading() {
		var objCurrentTabNumber =  document.getElementsByName("currentTabNumber") ;
		var rowNum = objCurrentTabNumber.length ;
   
		var tabNumber = "" ;
		var showTabNumber = "";
		var subRowNum = 0 ;
		var objReadingContentType ;
		var objReadingUserName ;
		var objReadingUserKey ;
		var objReadingOrgnztID ;

		var readingContentType ;
		var readingUserName ;
		var readingUserKey ;
		var readingOrgnztID ;
		
		var readingCSVContentType ;
		var readingCSVUserName ;
		var readingCSVUserKey ;
		var readingCSVOrgnztID ;
	

		for(var inx = 0 ; inx < rowNum ; inx++) {
			showTabNumber = objCurrentTabNumber[inx].value ;
		
			objReadingContentType =  document.getElementsByName("readingContentType_"+showTabNumber) ;
			objReadingUserName =  document.getElementsByName("readingUserName_"+showTabNumber) ;
			objReadingUserKey =  document.getElementsByName("readingUserKey_"+showTabNumber) ;
			objReadingOrgnztID =  document.getElementsByName("readingOrgnztID_"+showTabNumber) ;
			
			subRowNum = objReadingContentType.length ;
			readingCSVContentType = "" ;
			readingCSVUserName = "" ;
			readingCSVUserKey = "" ;
			readingCSVOrgnztID = "" ;
			for(var subInx = 0 ; subInx < subRowNum; subInx++) {
				if( subInx == 0 ) {
					readingCSVContentType = objReadingContentType[subInx].value ;
					readingCSVUserName = objReadingUserName[subInx].value ;
					readingCSVUserKey =  objReadingUserKey[subInx].value ;
					readingCSVOrgnztID = objReadingOrgnztID[subInx].value ;
				}else {
					readingCSVContentType = readingCSVContentType +","+objReadingContentType[subInx].value ;
					readingCSVUserName = readingCSVUserName +","+objReadingUserName[subInx].value ;
					readingCSVUserKey = readingCSVUserKey +","+objReadingUserKey[subInx].value ;
					readingCSVOrgnztID = readingCSVOrgnztID +","+objReadingOrgnztID[subInx].value ;	
				}
				
			}
			if( subRowNum > 0 ) {
				$("#readingCSVContentType_"+showTabNumber).val(readingCSVContentType);
				$("#readingCSVUserName_"+showTabNumber).val(readingCSVUserName);
				$("#readingCSVUserKey_"+showTabNumber).val(readingCSVUserKey);
				$("#readingCSVOrgnztID_"+showTabNumber).val(readingCSVOrgnztID);
				$("#readingView_"+showTabNumber).val(readingCSVUserName);
			}
		}
	}