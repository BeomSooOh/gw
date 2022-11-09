
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="tiles"   uri="http://tiles.apache.org/tags-tiles" %>
<%@ taglib prefix="c"       uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring"  uri="http://www.springframework.org/tags"  %>
<%@ taglib uri="/tags/np_taglib" prefix="nptag" %>
<%@page import="main.web.BizboxAMessage"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
TEST PAGE, OPEN ORG CHART
<script type="text/javascript">
	$(document).ready(function(){
		
	});
	
	function CallOrgBizPop() {

		var url = "<c:url value='/systemx/orgChartBiz.do'/>";

		var pop = window.open("", "cmmOrgBizPop", "width=1200,height=800,scrollbars=no");

		frmPop2.target = "cmmOrgBizPop";
		frmPop2.method = "post";
		frmPop2.action = url; 
		frmPop2.submit(); 
		frmPop2.target = ""; 
	    pop.focus();   
    }
	
	function CallOrgPop() {
		var mode = $("input[name=noUseExtendArea]").val();
		
// 		if(mode == "true") {
// 			var url = "<c:url value='/html/common/cmmOrgPop.jsp'/>";
// 			//var url = "<c:url value='/html/common/cmmOrgBizPop.jsp'/>";
// 		} else {
// 			var url = "<c:url value='/html/common/cmmExtendOrgPop.jsp'/>";
// 		}
		
		var url = "<c:url value='/systemx/orgChart.do'/>";
		
		 
		var pop = window.open("", "cmmOrgPop", "width=1200,height=800,scrollbars=no");

		frmPop2.target = "cmmOrgPop";
		frmPop2.method = "post";
		frmPop2.action = url; 
		frmPop2.submit(); 
		frmPop2.target = ""; 
	    pop.focus();   
    }
	
	function callbackSel(data) {
		if(data.isSave){
			var o = data.returnObj;
			var length = o.length;
			
			var selectedName = '';
			var selectedItems = '';
			
			var selectedName1 = '';
			var selectedItems1 = '';
			
			var selectedName2 = '';
			var selectedItems2 = '';
			
			
			for(var i = 0 ; i < length ;i++ ){
				var item = o[i];
				//console.log(item);
				if (item.flag == 'area1'){
					selectedName1 += ', ' +(item.empName || item.deptName || item.compName) ;
					selectedItems1 += ',' + (item.superKey || item.selectedId);
				}else if (item.flag == 'area2'){
					selectedName2 += ', ' +(item.empName || item.deptName || item.compName) ;
					selectedItems2 += ',' + (item.superKey || item.selectedId);
				}
				else{
					selectedName += ', ' +(item.empName || item.deptName || item.compName) ;
					selectedItems += ',' + (item.superKey || item.selectedId);
				}
			}		
			
		 	var queryable = '';
			
			selectedItems = selectedItems.substring(1);
			selectedName = selectedName.substring(1);
			
			selectedItems1 = selectedItems1.substring(1);
			selectedName1 = selectedName1.substring(1);
			
			selectedItems2 = selectedItems2.substring(1);
			selectedName2 = selectedName2.substring(1);
			
			console.log("selectedItems : " + selectedItems);
			
			if(selectedItems == "") {
				$('#c_selectedItems').val(( selectedItems1 || 'od, oc 미지원' ));
				
				$('#c_selectedItems1').val(( selectedItems2 || 'od, oc 미지원' ));
			} else {
				$('#c_selectedItems').val(( selectedItems || 'od, oc 미지원' ));
				
				$('#c_selectedItems1').val(( selectedItems1 || 'od, oc 미지원' ));
				
				$('#c_selectedItems2').val(( selectedItems2 || 'od, oc 미지원' ));
					
			}
			
			
		}else{
			$('#c_item').val('사용자가 팝업을 취소하였습니다.');
		}
	}

	
	function fnCallback(param){
		alert(JSON.stringify(param));
	}
	
</script>

<br><br>
<input type="button" value="공통팝업 호출" onclick="javascript:CallOrgPop()" />
<input type="button" value="공통팝업 호출(사업장)" onclick="javascript:CallOrgBizPop()" />

<form id="frmPop2" name="frmPop2" method="post">  
popupUrl : <input type="text" name="popUrlStr" id="txt_popup_url" width="800" value="<c:url value='/systemx/orgChart.do' />">
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
-- 팝업 페이지 옵션<br>
selectMode	:<input type="text" name="selectMode" width="500" value="u"/> &nbsp;(ex [ u : '사용자', d : '부서', ud : '사용자와 부서', od : '부서 조직도', oc : '회사 조직도' ] ) <br>
selectItem	:<input type="text" name="selectItem" width="500" value="s"/> &nbsp;(ex [ s : '단일 선택', m : '복수 선택'] ) <br>
selectMainTitle	:<input type="text" name="selectMainTitle" width="500" value="s"/> &nbsp; - 타이틀 이름 <br>

selectedItems	:<input type="text" name="selectedItems" width="500" value="" id="c_selectedItems"/>&nbsp;(ex format- groupSeq|compSeq|deptSeq|empSeq or '0' when dept|'u'ser or 'd'ept abbreviation  ex : [ demo|6|4101|4535|u,demo|6|4101|0|d ] ) <br>
selectedItems1	:<input type="text" name="selectedItems1" width="500" value="" id="c_selectedItems1"/>&nbsp;(ex format- groupSeq|compSeq|deptSeq|empSeq or '0' when dept|'u'ser or 'd'ept abbreviation  ex : [ demo|6|4101|4535|u,demo|6|4101|0|d ] ) <br>
selectedItems2	:<input type="text" name="selectedItems2" width="500" value="" id="c_selectedItems2"/>&nbsp;(ex format- groupSeq|compSeq|deptSeq|empSeq or '0' when dept|'u'ser or 'd'ept abbreviation  ex : [ demo|6|4101|4535|u,demo|6|4101|0|d ] ) <br>

compFilter	:<input type="text" name="compFilter" width="500" value=""/> &nbsp;(ex : 6,10 ) <br>

<br>
-- 팝업 페이지 콜백<br>
nodeChageEvent	:<input type="text" name="nodeChageEvent" width="500" value=""/>&nbsp; - 공통팝업의 경우 미사용. <br>

callbackParam	:<input type="text" name="callbackParam" width="500" value=""/> &nbsp; - 콜백 함수로 넘어갈 데이터 <br>
callbackParam1	:<input type="text" name="callbackParam1" width="500" value=""/> &nbsp; - 콜백 함수로 넘어갈 데이터 <br>
callbackParam2	:<input type="text" name="callbackParam2" width="500" value=""/> &nbsp; - 콜백 함수로 넘어갈 데이터 <br>

callback	:<input type="text" name="callback" width="500" value="callbackSel"/> &nbsp; - 콜백 함수 명<br>

callback URL:<input type="text" name="callbackUrl" width="500" value="<c:url value='/html/common/callback/cmmOrgPopCallback.jsp' />"/> &nbsp; - 콜백 URL<br>
initMode :<input type="text" name="initMode" width="500" value=""/> &nbsp; - true / null or white space <br>
noUseDefaultNodeInfo :  <input type="text" name="noUseDefaultNodeInfo" width="500" value=""/> &nbsp; - true / null or white space <br>
noUseCompSelect : <input type="text" name="noUseCompSelect" width="500" value=""/> &nbsp; - true / null or white space <br>
includeDeptCode :  <input type="text" name="includeDeptCode" width="500" value=""/> &nbsp; - true / null or white space <br>

noUseDeleteBtn : <input type="text" name="noUseDeleteBtn" width="500" value=""/> &nbsp; - true / null or white space <br>
isAllDeptEmpShow : <input type="text" name="isAllDeptEmpShow" width="500" value="true"/> &nbsp; - true / null or white space <br>
isDuplicate : <input type="text" name="isDuplicate" width="500" value="true"/> &nbsp; - true / null or white space <br>
isAllCompShow : <input type="text" name="isAllCompShow" width="500" value="false"/> &nbsp; - true / null or white space <br>
noUseExtendArea : <input type="text" name="noUseExtendArea" width="500" value="true"/> &nbsp; -  true / null or white space <br>
extendSelectAreaCount : <input type="text" name="extendSelectAreaCount" width="500" value="2"/> &nbsp; - 숫자(1-3) <br>
extendSelectAreaInfo : <input type="text" name="extendSelectAreaInfo" width="500" value="test1|s$test2|m"/> &nbsp; - 구분값:|, $ ex) 제목|s$제목2|m <br>
noUseBiz : <input type="text" name="noUseBiz" width="500" value="true"/> &nbsp; - true / null or white space <br>
innerReceiveFlag : <input type="text" name="innerReceiveFlag" width="500" value=""/> &nbsp; - Y / N or white space <br>

empUniqYn : <input type="text" name="empUniqYn" width="500" value=""/> &nbsp; - Y / N or white space <br>
empUniqGroup : <input type="text" name="empUniqGroup" width="500" value=""/> &nbsp; - G + 그룹핑ID or C + comp_seq <br>
</form>

<br><br><br><br>
사용자, 부서, 회사 등  : <input type="text" id="c_item" style="width: 1000px;">
