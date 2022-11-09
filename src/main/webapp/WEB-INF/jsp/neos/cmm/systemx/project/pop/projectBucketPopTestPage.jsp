
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="tiles"   uri="http://tiles.apache.org/tags-tiles" %>
<%@ taglib prefix="c"       uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring"  uri="http://www.springframework.org/tags"  %>
<%@ taglib uri="/tags/np_taglib" prefix="nptag" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
TEST PAGE, OPEN PROJECT POP
<script type="text/javascript">
	$(document).ready(function(){
		
	});	
	
	function CallProjectPop() {
	
		var url = "<c:url value='/html/common/cmmProjectPop.jsp'/>"; 
		var pop = window.open("", "cmmProjectPop", "width=768,height=800,scrollbars=no");

		frmPop2.target = "cmmProjectPop";
		frmPop2.method = "post";
		frmPop2.action = url; 
		frmPop2.submit(); 
		frmPop2.target = ""; 
	    pop.focus();   
    }
	
	function callbackSelectProject(data) {
		if(data.isSave){
			var o = data.returnObj;
			var length = o.length;
			
			var selectedName = '';
			var selectedItems = '';
			
			
			for(var i = 0 ; i < length ;i++ ){
				var item = o[i];
				
				selectedName += item.projectName;
				selectedItems += item.projectCode;
				
			}		

			$('#c_selectedItems').val(( selectedItems));
			$('#c_item').val(selectedName);
		}else{
			$('#c_item').val('사용자가 팝업을 취소하였습니다.');
		}
	}
	
</script>


<br><br>
<input type="button" value="프로젝트팝업 호출" onclick="javascript:CallProjectPop()" />

<form id="frmPop2" name="frmPop2" method="post">  
popupUrl : <input type="text" name="popUrlStr" id="txt_popup_url" width="800" value="<c:url value='/systemx/project.do' />">
<br><br>
-- 사용자 기본정보<br>
?개발모드 : <input type="text" name="devMode" width="500" value=""/> &nbsp;(ex : [,'dev']) <br>
?개발주소 : <input type="text" name="devModeUrl" width="500" value="http://localhost:8080"/> &nbsp;(ex : [,'http://localhost:8080']) <br>

langCode	:<input type="text" name="langCode" width="500" value=""/> &nbsp;(ex : 'kr') <br>
groupSeq	:<input type="text" name="groupSeq" width="500" value=""/> &nbsp;(ex : 'demo') <br>
compSeq 	:<input type="text" name="compSeq" width="500" value=""/> &nbsp;(ex : '6') <br>	
deptSeq		:<input type="text" name="deptSeq" width="500" value=""/> &nbsp;(ex : '4101') - 개발 1팀 / 인사/근태 파트 <br>
empSeq		:<input type="text" name="empSeq" width="500" value=""/> &nbsp;(ex : '4535') - 최상배 연구원 <br>
<br>

selectedItems	:<input type="text" name="selectedItems" width="500" value="" id="c_selectedItems"/>&nbsp;(ex format- groupSeq|compSeq|deptSeq|empSeq or '0' when dept|'u'ser or 'd'ept abbreviation  ex : [ demo|6|4101|4535|u,demo|6|4101|0|d ] ) <br>

<br>
-- 팝업 페이지 콜백<br>

callbackParam	:<input type="text" name="callbackParam" width="500" value=""/> &nbsp; - 콜백 함수로 넘어갈 데이터 <br>
callback	:<input type="text" name="callback" width="500" value="callbackSelectProject"/> &nbsp; - 콜백 함수 명<br>
callback URL:<input type="text" name="callbackUrl" width="500" value="<c:url value='/html/common/callback/cmmProjectPopCallback.jsp' />"/> &nbsp; - 콜백 URL<br>

</form>

<br><br><br><br>
<input type="text" id="c_item" style="width: 1000px;">