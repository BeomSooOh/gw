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
	var selPartnerInfo;
	var selPartnerIndex;
	$(document).ready(function() {
		getPartnerList();
	});
	
	
	function getPartnerList(){
		var seartText = $("#searchTxt").val();
		var tblParam = {};
		tblParam.seartText = seartText;
		
		 $.ajax({
	        	type:"post",
	    		url:'<c:url value="/cmm/mp/addr/getPartnerList.do"/>',
	    		datatype:"json",
	            data: tblParam ,
	    		success: function (data) {
	    				selPartnerInfo = data.list;
						setPartnerList(data.list);
	    		    } ,
	 		    error: function (result) { 
	 		    		alert("<%=BizboxAMessage.getMessage("TX000002003","작업이 실패했습니다.")%>"); 
		    		}
	    	});
	}
	
	function setPartnerList(list){
		var InnerHTML = "";
		$("#partnerList").html("");	
		
		for(var i=0;i<list.length;i++){
			var cdPartner = ""; 
			var lnPartner = "";
			var noCompany = "";
			
			if(list[i].cdPartner != null)
				cdPartner = list[i].cdPartner;
			if(list[i].lnPartner != null)
				lnPartner = list[i].lnPartner;
			if(list[i].noCompany != null)
				noCompany = list[i].noCompany;
			
			
			InnerHTML += "<tr onclick='setClick(this, " + i + ")'><td>" + cdPartner + "</td>";
			InnerHTML += "<td>" + lnPartner + "</td>";
			InnerHTML += "<td>" + noCompany + "</td></tr>";
		}
		
		if(list.length == 0)
			InnerHTML += "<tr><td colspan='3'><%=BizboxAMessage.getMessage("TX000015757","데이타가 없습니다.")%></td></tr>"
		
		$("#partnerList").html(InnerHTML);	
	}
	
	function setClick(target, index){
		var table = document.getElementById("partnerList");
		var tr = table.getElementsByTagName("tr");
		for(var i=0; i<tr.length; i++)
			tr[i].style.background = "white";
		target.style.backgroundColor = "#E6F4FF";
		selPartnerIndex = index;
	}
	
	function ok(){
		if(selPartnerInfo[selPartnerIndex] == null)
			self.close();
		else{
			opener.setPartnerInfo(selPartnerInfo[selPartnerIndex]);
			self.close();
		}
	}
</script>



<div class="pop_wrap" style="width:550px;">

	<div class="pop_head">
		<h1><%=BizboxAMessage.getMessage("TX000007468","거래처 선택")%></h1>
		<a href="#n" class="clo"><img src="../../../Images/btn/btn_pop_clo01.png" alt="" /></a>
	</div>
	
	<div class="pop_con">
		<div class="com_ta">
			<table>
				<colgroup>
					<col width="130"/>
					<col width=""/>
				</colgroup>
				<tr id="">
					<th><%=BizboxAMessage.getMessage("TX000000399","검색어")%></th>
					<td>
						<input type="text" id="searchTxt" name="searchTxt" style="width:280px;" onkeydown="if(event.keyCode==13){javascript:getPartnerList();}"/>
						<div id="" class="controll_btn p0">
							<button type="button" id="" onclick="getPartnerList();"><%=BizboxAMessage.getMessage("TX000001289","검색")%></button>
						</div>
					</td>
				</tr>
					
			</table>
		</div>
		
		<div style="height: 20px"></div>
		
		<div class="com_ta2">
			<table>
				<colgroup>
					<col width="150"/>
					<col width="200"/>
					<col width=""/>
				</colgroup>
				<thead>
					<tr>
						<th><%=BizboxAMessage.getMessage("TX000000045","코드")%></th>
						<th><%=BizboxAMessage.getMessage("TX000000018","회사명")%></th>
						<th><%=BizboxAMessage.getMessage("TX000000024","사업자번호")%></th>
					</tr>
				</thead>
			</table>		
		</div>
		
		
		
		<div class="com_ta2 scroll_y_on bg_lightgray" style="height:328px;">
			<table class="brtn">
				<colgroup>
					<col width="150"/>
					<col width="200"/>
					<col width=""/>
				</colgroup>
				<tbody id="partnerList">
					<td colspan="3"><%=BizboxAMessage.getMessage("TX000015757","데이타가 없습니다.")%></td>
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