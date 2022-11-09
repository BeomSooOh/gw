<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="tiles"   uri="http://tiles.apache.org/tags-tiles" %>
<%@ taglib prefix="c"       uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring"  uri="http://www.springframework.org/tags"  %>
<%@ taglib uri="/tags/np_taglib" prefix="nptag" %>
    
<!DOCTYPE html>
<html>
<head>
    <title></title>
    <link rel="stylesheet" href="../css/kendoui/kendo.common.min.css" />
    <link rel="stylesheet" href="../css/kendoui/kendo.default.min.css" />

    <script src="../js/kendoui/jquery.min.js"></script>
    <script src="../js/kendoui/kendo.all.min.js"></script>
    
    <script>
    
    	function userSelectPop() {
    		var formData = $("#frmPop").serialize();
    		var url = $("#url").val();
    		$.ajax({
    			type:"get",
    			url:$("#edmsDomain").val()+url,
    			datatype:"json",
    			data: formData,
    			success:function(data){
    				callbackSelectUser(data);
    			},			
    			error : function(e){	//error : function(xhr, status, error) {
    				alert("error");	
    			}
    		});	   
	     }
    	
    	function callbackSelectUser(data) {
    		
    		var jsonStr = JSON.stringify(data);
    		
    		$("#selectUserList").val(jsonStr); 
    		  
    	}
    
    </script> 
</head> 
<body>
	<h2>EDMS 게시판 조회</h2>
        <div id="example">
        	<ul id="fieldlist">  
	            		<li> 
	            			<label for="edmsDomain">edmsDomain</label>
	            			<input class="k-textbox" id="edmsDomain" name="edmsDomain" value="http://221.133.55.230" />
		                </li>
	            		<li> 
	            			<label for="url">url</label>
	            			<select id="url" name="url">
	            				<option value="/edms/board/boardDirList.do">게시판 목록조회(new)</option>
	            				<option value="/edms/board/getUserBoardList.do">게시판 목록조회</option>
	            				<option value="/edms/board/getCompNoticeList.do">공지사항 목록조회</option>
	            				<option value="/edms/board/getCompSurveyList.do">설문조사 목록조회</option>
	            				<option value="/edms/board/getCompDocCategoryList.do">일반문서함(카테고리) 목록조회</option>
	            				<option value="/edms/board/getCompDirDocList.do">(함선택) 일반문서함 문서목록</option>
	            				<option value="/edms/board/getCompBpmCategoryList.do">전자결재 카테고리 목록조회</option>
	            				<option value="/edms/board/getCompDirBpmList.do">(함선택) 전자결재 문서목록</option>
	            				<option value="/edms/board/getCompProjectBoardList.do">프로젝트 게시판 목록(프로젝트ID)</option>
	            				<option value="/edms/board/manageProjectBoard.do">프로젝트 게시판 생성</option>
	            				<option value="/edms/board/delProjectBoard.do">프로젝트 게시판 삭제</option>
	            				<option value="/edms/board/writeRealBpmPostDo.do">전자결재 문서 저장</option>
	            				<option value="/edms/board/getMobileUserBoardList.do">전자결재 문서 저장</option>
	            			</select>
		                </li>
		     </ul>
		<form id="frmPop" name="frmPop">  
	            	<ul id="fieldlist">  
	            		<li> 
	            			<label for="id">id</label>
		                    <input class="k-textbox" id="id" name="id" value="nana" />
		                </li>
	            		<li> 
	            			<label for="compSeq">compSeq</label>
		                    <input class="k-textbox" id="compSeq" name="compSeq" value="100084" />
		                </li>
	            		<li> 
	            			<label for="groupSeq">groupSeq</label>
		                    <input class="k-textbox" id="groupSeq" name="groupSeq" value="53" />
		                </li>
		                <li> 
	            			<label for="countYn">countYn</label>
		                    <input class="k-textbox" id="countYn" name="countYn" value="N" />
		                </li>
	            		
	            		<li> 
	            			<label for="loginId">loginId</label>
		                    <input class="k-textbox" id="loginId" name="loginId" value="" />
		                </li>
	            		<li> 
	            			<label for="empSeq">empSeq</label>
		                    <input class="k-textbox" id="empSeq" name="empSeq" value="" />
		                </li>
	            		<li> 
	            			<label for="compSeq">compSeq</label>
		                    <input class="k-textbox" id="compSeq" name="compSeq" value="" />
		                </li>
	            		<li> 
	            			<label for="bizSeq">bizSeq</label>
		                    <input class="k-textbox" id="bizSeq" name="bizSeq" value="" />
		                </li>
	            		<li> 
	            			<label for="deptSeq">deptSeq</label>
		                    <input class="k-textbox" id="deptSeq" name="deptSeq" value="" />
		                </li>
	            		<li> 
	            			<label for="iId">iId</label>
		                    <input class="k-textbox" id="iId" name="iId" value="123123" />
		                </li>
		                
	            	</ul> 
		</form>
	</div>
	<div>
			<ul id="fieldlist">  
            		<li> 
            			<label for="selectUserList">selectUserList</label>
	                    <textarea class="k-textbox" id="selectUserList" name="selectUserList" value="" style="width:800px; height:400px"></textarea>
	                </li>  
            </ul>		
         </div>   		
            		
	            <div id="imgContainer"> 
	            	<button id="selBtn" type="button" onclick="userSelectPop()" class="k-primary">선택</button>
	            </div> 
	            
	            <script>
	          	  $("#selBtn").kendoButton();
	            </script>
	
            <style>
                #fieldlist {
                    margin: 0;
                    padding: 0;
                }

                #fieldlist li {
                    list-style: none;
                    padding-bottom: .7em;
                    text-align: left;
                }

                #fieldlist label {
                    display: block;
                    padding-bottom: .3em;
                    font-weight: bold;
                    font-size: 12px;
                    color: #444;
                }

                #fieldlist li.status {
                    text-align: center;
                }

                #fieldlist li .k-widget:not(.k-tooltip),
                #fieldlist li .k-textbox {
                    margin: 0 5px 5px 0;
                }
                
            </style>
        </div>


</body>
</html>
