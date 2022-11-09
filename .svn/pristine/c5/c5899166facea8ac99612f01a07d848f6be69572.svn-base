<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="validator" uri="http://www.springmodules.org/tags/commons-validator" %>
<%@page import="main.web.BizboxAMessage"%>
<script id="treeview-template" type="text/kendo-ui-template">
	        #: item.name #
</script>

<style>
    .k-sprite {background-image: url("/gw/Images/ico/ico_tree_folder.png");}
	.rootfolder{background-position: 0 0; }
	.folder{background-position: 0 -16px; }
	.pdf{background-position: 0 -32px; }
	.html{background-position: 0 -48px; }
	.file{background-position: 0 -64px; }

  	.sub_contents_border{overflow:hidden;}    	
  	#treeview{padding:20px;}
</style>

<c:if test="${ClosedNetworkYn != 'Y'}">
	<script src='https://ssl.daumcdn.net/dmaps/map_js_init/postcode.v2.js'></script>
</c:if>

<script>

	$(document).ready(function() {
		
		if("${loginVO.userSe}" == "MASTER"){	
			getComInfo("");
		}else{
			getComInfo("${loginVO.compSeq}");	
		}

	});
	
	function removeComp() {		
		if($("#compSeq").val() == ""){
			alert("<%=BizboxAMessage.getMessage("TX000010764","삭제할 회사를 선택해 주세요")%>");
			return false;
		}

		var delCompName = $("#compName").val();
		
		if("${loginVO.langCode}" == "en" && $("#compNameEn").val() != ""){	
			delCompName = $("#compNameEn").val();
		}else if("${loginVO.langCode}" == "jp" && $("#compNameJp").val() != ""){	
			delCompName = $("#compNameJp").val();
		}else if("${loginVO.langCode}" == "cn" && $("#compNameCn").val() != ""){	
			delCompName = $("#compNameCn").val();
		}
		
		if (confirm("["+delCompName+"] <%=BizboxAMessage.getMessage("TX000010763","회사를 삭제할까요?")%>") == false) {
			return;	
		}
		
		var compSeq = $("#compSeq").val();
		
        $.ajax({
    			type:"post",
    			url:"compRemoveProc.do",
    			datatype:"text",
    			data: {compSeq : compSeq},
    			success:function(data){
    				
    				alert(data.result);
    				
    				if(data.resultCode == "SUCCESS") {
    					location.href = location.href;
    				}
    			},			
    			error : function(e){	//error : function(xhr, status, error) {
    				alert("error");	
    			}
    	});
        
	}

</script>


<!-- 컨텐츠내용영역 -->
<div class="sub_contents_wrap">
	<div class="sub_contents_border">
		<c:if test="${loginVO.userSe == 'MASTER'}">
			<div class="sub_left scroll_y_on" style="height:876px;">
				<div class="com_ta2 p10">
					<table id="compListTable">
						<colgroup>
							<col width="100"/>
							<col width=""/>
						</colgroup>
						<tr>
							<th><%=BizboxAMessage.getMessage("TX000000017","회사코드")%></th>
							<th><%=BizboxAMessage.getMessage("TX000000018","회사명")%></th>
						</tr>
					<c:forEach items="${compList}" var="c">
                        <tr onclick="onSelect(this);" id="${c.compSeq}">
							<td>${c.compCd}</td>
							<td>${c.compName}</td>
						</tr>                
                    </c:forEach>
                   	</table>
				</div>	
			</div>	
		</c:if>
		<div class="comp_sub_con" id="comp_info" style="margin-left:-1px;">
		</div>
	</div>
</div>

<script type="text/javascript"> 
 
     function onSelect(e) {        
		var id = e.id;
		
		var table = document.getElementById("compListTable");
		var tr = table.getElementsByTagName("tr");
		for(var i=0; i<tr.length; i++)
			tr[i].style.background = "white";
		e.style.backgroundColor = "#E6F4FF";
		
		getComInfo(id);
	  }   
   	
   	//회사정보 조회 view 구현
   	function getComInfo(id) {
   		$.ajax({
			type:"post",
			url:'<c:url value="/cmm/systemx/comInfo.do" />',
			async:false,
			data:{"compSeq":id},
			datatype:"text",			
			success:function(data){
				$('#comp_info').html(data);
				
			}
		});
   	}          
     
</script>

          


