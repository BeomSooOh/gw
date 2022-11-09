<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<%@page import="main.web.BizboxAMessage"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="ko" xml:lang="ko">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <title><%=BizboxAMessage.getMessage("TX000017918","우편번호관리")%></title>
    
    <!--Kendo ui css-->
    <link rel="stylesheet" type="text/css" href="../../../css/kendoui/kendo.common.min.css">
    <link rel="stylesheet" type="text/css" href="../../../css/kendoui/kendo.dataviz.min.css">
    <link rel="stylesheet" type="text/css" href="../../../css/kendoui/kendo.mobile.all.min.css">
    
    <!-- Theme -->
	<link rel="stylesheet" type="text/css" href="../../../css/kendoui/kendo.silver.min.css" />

	<!--css-->
	<link rel="stylesheet" type="text/css" href="../../../css/main.css?ver=20201021">
    <link rel="stylesheet" type="text/css" href="../../../css/common.css?ver=20201021">
	
	<!--Kendo UI customize css-->
    <link rel="stylesheet" type="text/css" href="../../../css/reKendo.css">
	    
    <!--js-->
    <script type="text/javascript" src="../../../Scripts/jquery-1.9.1.min.js"></script>
    <script type="text/javascript" src="../../../Scripts/common.js"></script>
    
    <!--Kendo ui js-->
    <script type="text/javascript" src="../../../Scripts/kendoui/jquery.min.js"></script>
    <script type="text/javascript" src="../../../Scripts/kendoui/kendo.all.min.js"></script>
    
	<script type="text/javascript">
		$(document).ready(function() {	
			//기본버튼
           $(".controll_btn button").kendoButton();

		   //기간 셀렉트박스
			$("#combobox_u1").kendoComboBox({
				dataSource : {
					data : ["<%=BizboxAMessage.getMessage("TX000010672","경기")%>","..."]
				},
				value:"<%=BizboxAMessage.getMessage("TX000010672","경기")%>"
			});

			$("#combobox_u2").kendoComboBox({
				dataSource : {
					data : ["<%=BizboxAMessage.getMessage("TX000010672","경기")%>","..."]
				},
				value:"<%=BizboxAMessage.getMessage("TX000010672","경기")%>"
			});

			$("#combobox_u3").kendoComboBox({
				dataSource : {
					data : ["<%=BizboxAMessage.getMessage("TX000010670","도로명주소")%>","<%=BizboxAMessage.getMessage("TX000010671","지번주소")%>"]
				},
				value:"<%=BizboxAMessage.getMessage("TX000010670","도로명주소")%>"
			});

			//탭
			$("#tabstrip").kendoTabStrip({
				animation:  {
					open: {
						effects: ""
					}
				}
			});
		});
	</script>

</head>

<body>
<div class="pop_wrap" style="width:630px;">
	<div class="pop_head">
		<h1><%=BizboxAMessage.getMessage("TX000017918","우편번호관리")%></h1>
		<a href="#n" class="clo"><img src="../../../Images/btn/btn_pop_clo01.png" alt="" /></a>
	</div>

	<div class="pop_con">
		<div class="Pop_border">
	
	
			<div id="tabstrip" class="tab_style">
				<p class="treeTop">
					<ul class="record_tab" style="padding-left:15px;">
						<li class="k-state-active"><%=BizboxAMessage.getMessage("TX000010671","지번주소")%></li>
						<li><%=BizboxAMessage.getMessage("TX000010670","도로명주소")%></li>
					</ul>
				</p>

				<!-- 부서탭-->
				<div class="treeCon">									
					<div class="top_box" style="margin:15px">	
						<div class="top_box_in">
							<ul>
								<li>
									<%=BizboxAMessage.getMessage("TX000006790","시도")%> <input id="combobox_u1" style="width:105px;" class="mr5"/>
									<%=BizboxAMessage.getMessage("TX000006789","시군구")%> <input id="combobox_u2" style="width:105px;" class="mr5"/>
									<%=BizboxAMessage.getMessage("TX000017919","동(읍/면/리)")%> <input type="text" id="text_input" style="width:100px; text-indent:4px;"/>
									<input type="button" id="searchButton" value="검색" />					
								</li>
							</ul>							
						</div>
					</div>
				</div> 							

				<!-- 공유철탭-->
				<div class="treeCon">									
					<div class="top_box" style="margin:15px">	
						<div class="top_box_in">
							<ul>
								<li>
									<input id="combobox_u3" style="width:110px;"/>
									<input type="text" id="text_input" style="width:230px; text-indent:4px;"/>
									<input type="button" id="searchButton" value="<%=BizboxAMessage.getMessage("TX000001289","검색")%>" />
									<div id="" class="controll_btn" style="float:right; margin-top:-9px;">
										<button id="" onclick="window.open('http://www.epost.go.kr/search.RetrieveIntegrationNewZipCdList.comm', 'window', 'width=590, height=670')"><%=BizboxAMessage.getMessage("TX000006794","도로명 주소찾기")%></button>
									</div>
								</li>
							</ul>							
						</div>
					</div>
				</div>			
			</div>

			<!-- 테이블 -->
			<div style="padding:0px 15px 15px 15px;">
				<div class="com_ta2">
					<table>
						<colgroup>						
							<col width="60px" />
							<col width="100px" />
							<col />
						</colgroup>
						<thead>
							<tr>
								<th><%=BizboxAMessage.getMessage("TX000000335","순번")%></th>
								<th><%=BizboxAMessage.getMessage("TX000000009","우편번호")%></th>
								<th><%=BizboxAMessage.getMessage("TX000000375","주소")%></th>
							</tr>
						</thead>
						<tbody>
							<tr>						
								<td>1</td>
								<td>200-956</td>
								<td class="al">강원도 춘천시 <span class="text_blue">남산면</span> 강촌2리</td>
							</tr>
							<tr>						
								<td>100202</td>
								<td>200-956</td>
								<td class="al">강원도 춘천시 <span class="text_blue">남산면</span> 강촌2리</td>
							</tr>
							<tr>						
								<td>1002022222</td>
								<td>200-956</td>
								<td class="al">강원도 춘천시 <span class="text_blue">남산면</span> 강촌2리</td>
							</tr>
							<tr>						
								<td>1002022222</td>
								<td>200-956</td>
								<td class="al">강원도 춘천시 <span class="text_blue">남산면</span> 강촌2리</td>
							</tr>
							<tr>						
								<td>1002022222</td>
								<td>200-956</td>
								<td class="al">강원도 춘천시 <span class="text_blue">남산면</span> 강촌2리</td>
							</tr>
							<tr>						
								<td>1002022222</td>
								<td>200-956</td>
								<td class="al">강원도 춘천시 <span class="text_blue">남산면</span> 강촌2리</td>
							</tr>
							<tr>						
								<td>1002022222</td>
								<td>200-956</td>
								<td class="al">강원도 춘천시 <span class="text_blue">남산면</span> 강촌2리</td>
							</tr>
							<tr>						
								<td>1002022222</td>
								<td>200-956</td>
								<td class="al">강원도 춘천시 <span class="text_blue">남산면</span> 강촌2리</td>
							</tr>
						</tbody>
					</table>
				</div>	

				<div class="paging mt20">
					<span class="pre_pre"><a href=""><%=BizboxAMessage.getMessage("TX000017354","10페이지전")%></a></span>
					<span class="pre"><a href=""><%=BizboxAMessage.getMessage("TX000003165","이전")%></a></span>
						<ol>
							<li class="on"><a href="">1</a></li>
							<li><a href="">2</a></li>
							<li><a href="">3</a></li>
							<li><a href="">4</a></li>
							<li><a href="">5</a></li>
							<li><a href="">6</a></li>
							<li><a href="">7</a></li>
							<li><a href="">8</a></li>
							<li><a href="">9</a></li>
							<li><a href="">10</a></li>
						</ol>
					<span class="nex"><a href=""><%=BizboxAMessage.getMessage("TX000003164","다음")%></a></span>
					<span class="nex_nex"><a href=""><%=BizboxAMessage.getMessage("TX000017920","10페이지다음")%></a></span>
				</div>	
			</div>		
		</div>

	</div><!-- //pop_con -->

	<div class="pop_foot">
		<div class="btn_cen pt12">
			<input type="button" value="<%=BizboxAMessage.getMessage("TX000000265","선택")%>" />
			<input type="button" class="gray_btn" value="<%=BizboxAMessage.getMessage("TX000002947","취소")%>" />
		</div>
	</div><!-- //pop_foot -->
	</div><!-- //pop_wrap -->
</body>
</html>