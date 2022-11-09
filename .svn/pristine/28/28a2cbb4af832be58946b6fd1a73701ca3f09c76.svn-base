<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="validator" uri="http://www.springmodules.org/tags/commons-validator"%>
<%@page import="main.web.BizboxAMessage"%>
<style type="text/css">  
	html {overflow:hidden;}  
</style>  


<script type="text/javascript">

	$(document).ready(function() {
		
	});
	
		
	function setClick(target){
		var table = document.getElementById("addrGroupList");
		var tr = table.getElementsByTagName("tr");
		for(var i=0; i<tr.length; i++)
			tr[i].style.background = "white";
		target.style.backgroundColor = "#E6F4FF";
		
		$("#addrGroupSeq").val($(target).attr("id"));
		$("#addrGroupName").val($(target).attr("addrName"));
	}
	
	function ok(){
		opener.setAddrGroupInfo($("#addrGroupSeq").val(), $("#addrGroupName").val());
		self.close();
	}
	
	function setAddrGroupInfo(target){
		opener.setAddrGroupInfo($(target).attr("id"), $(target).attr("addrName"));
		self.close();
	}
	
	function fnSearch(){
		
		var tblParam = {};
		tblParam.groupDiv = "${groupDiv}";
		tblParam.txtSearchGroupNm = $("#txtSearchGroupNm").val();
		
		$.ajax({
        	type:"post",
    		url:'<c:url value="/cmm/mp/addr/serchAddrGroupInfo.do"/>',
    		datatype:"json",
            data: tblParam ,
    		success: function (data) {
    				$("#addrGroupList").html("");
    				var innerHTML = "";
    				for(var i=0;i<data.list.length;i++){
    					innerHTML += "<tr ondblclick='setAddrGroupInfo(this)' onclick='setClick(this)' id='" + data.list[i].CD_SEQ + "' addrName='" + data.list[i].CD_NAME + "'>";
    					innerHTML += "<td>" + data.list[i].CD_NAME + "</td>";
    					innerHTML += "</tr>";
    				}
    				$("#addrGroupList").html(innerHTML);    				
    		    } ,
		    error: function (result) { 
		    		alert("<%=BizboxAMessage.getMessage("TX000002003","작업이 실패했습니다.")%>"); 
	    		}
    	});	
	}
</script>



<div class="pop_wrap" style="width:550px;">

	<div class="pop_head">
		<h1><%=BizboxAMessage.getMessage("TX900000436","주소록 그룹 선택")%></h1>
		<a href="#n" class="clo"><img src="../../../Images/btn/btn_pop_clo01.png" alt="" /></a>
	</div>
	
	<div class="pop_con">
		<input type="hidden" id="addrGroupSeq" value=""/>
		<input type="hidden" id="addrGroupName" value=""/>
		<div class="com_ta">
			<table>
				<colgroup>
					<col width="130"/>
					<col width=""/>
				</colgroup>
				<tr id="">
					<th><%=BizboxAMessage.getMessage("TX000000002","그룹명")%></th>
					<td>
						<input type="text" id="txtSearchGroupNm" name="searchTxt" style="width:280px;" onkeydown="if(event.keyCode==13){javascript:fnSearch();}"/>
						<div id="" class="controll_btn p0">
							<button type="button" id="" onclick="fnSearch();"><%=BizboxAMessage.getMessage("TX000001289","검색")%></button>
						</div>
					</td>
				</tr>
					
			</table>
		</div>
		
		<div style="height: 20px"></div>
		
		<div class="com_ta2">
			<table>
				<colgroup>
					<col width=""/>
				</colgroup>
				<thead>
					<tr>
						<th><%=BizboxAMessage.getMessage("TX900000437","주소록 그룹명")%></th>
					</tr>
				</thead>
			</table>		
		</div>
		
		
		
		<div class="com_ta2 scroll_y_on bg_lightgray" style="height:328px;">
			<table class="brtn">
				<colgroup>
					<col width=""/>
				</colgroup>
				<tbody id="addrGroupList">
					<c:forEach items="${list}" var="list">
						<tr ondblclick='setAddrGroupInfo(this)' onclick='setClick(this)' id="${list.CD_SEQ}" addrName="<c:out value="${list.CD_NAME}"/>">
							<td><c:out value="${list.CD_NAME}"/></td>
						</tr>
					</c:forEach>
				</tbody>
			</table>		
		</div>
	</div>
	
	<div class="pop_foot">
		<div class="btn_cen pt12">
			<input id="" type="button" value="<%=BizboxAMessage.getMessage("TX000000078","확인")%>" onclick="ok()"/>
			<input id="" type="button" value="<%=BizboxAMessage.getMessage("TX000002947","취소")%>" onclick="javascript:self.close();"/>			
		</div>
	</div>
</div><!-- //pop_wrap -->