<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
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

	
	$(document).ready(function(){
		$("#photoImage").attr("src", "${profilePath}/${listMap.empSeq}_thum.jpg?<%=System.currentTimeMillis()%>");
	});
	
	
	
	
</script>

<div class="pop_wrap" style="min-width:898px;">
	<div class="pop_head">
		<h1><%=BizboxAMessage.getMessage("TX000004161","사용자 정보 조회")%></h1>
		<a href="#n" class="clo"><img
			src="../../../Images/btn/btn_pop_clo01.png" alt="" /></a>
	</div>

				<!-- 부서사원선택후 테이블 -->
				<div class="mt10" >	
					<table cellpadding="0" cellspacing="0" border-style:"none" style="width:100%;">
						<colgroup>
							<col width="180"/>
							<col width=""/>
						</colgroup>
						<tr>
							<td class="vt">
								<!-- 이미지 -->
								<ul>
									<li class="mypage_file" style="width: 180px; height: 295px;">
										<p class="imgfile" id="">
											<span class="posi_re dp_ib"> 
												<img class="userImg" id="photoImage" src="" alt="" onerror="this.src='/gw/Images/temp/pic_Noimg.png'"/>
											</span>
										</p>
									</li>
								</ul>
							</td>
							<td class="vt pl10">
								<div class="com_ta">
								<!-- 	비상연락망 사원 정보 -->
									<table>
										<colgroup>
											<col width="10.4%"/>
											<col width="30.6%"/>
											
										</colgroup>
										<tr>
											<th><%=BizboxAMessage.getMessage("TX000018617","부서")%></th>
											<td id="deptName">${listMap.deptName}</td>
										</tr>
										<tr>	
											<th><%=BizboxAMessage.getMessage("TX000018661","이름")%></th>
											<td id="empName">${listMap.empName}</td>
										</tr>
										<tr>
											<th><%=BizboxAMessage.getMessage("TX000000088","담당업무")%></th>
											<td id="mainWork">${listMap.mainWork}</td>
										</tr>
										<tr>	
											<th><%=BizboxAMessage.getMessage("TX000000654","휴대전화")%></th>
											<td id="mobileTelNum">${listMap.mobileTelNum}</td>
										</tr>
										<tr>
											<th><%=BizboxAMessage.getMessage("","E-mail")%></th>
											<td id="emailAddr">${listMap.emailAddr}@${listMap.compDomain}</td>
										</tr>
										<tr>
											<th><%=BizboxAMessage.getMessage("TX000001672","생일")%></th>
											<td id="bDay">${listMap.bDay}</td>
										</tr>
										<tr>
											<th><%=BizboxAMessage.getMessage("TX000002886","전화(회사)")%></th>
											<td id="telNum">${listMap.telNum}</td>
										</tr>
										<tr>
											<th><%=BizboxAMessage.getMessage("TX000002887","전화(집)")%></th>
											<td id="homeTelNum">${listMap.homeTelNum}</td>
										</tr>
										<tr>	
											<th><%=BizboxAMessage.getMessage("TX000000074","팩스번호")%></th>
											<td id="faxNum">${listMap.faxNum}</td>
										</tr>
										<tr>
											<th><%=BizboxAMessage.getMessage("TX000000375","주소")%></th>
											<td id="detailAddr">${listMap.detailAddr}</td>
										</tr>
									</table>
								</div>
							</td>
						</tr>
					</table>
				</div>

</div>
