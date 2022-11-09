<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="validator"
	uri="http://www.springmodules.org/tags/commons-validator"%>
<%@ page import="java.util.*" %>	
<%@page import="java.net.URLDecoder"%>
<%@page import="main.web.BizboxAMessage"%>

<%
	String authCode = request.getParameter("authCode");
	String authName = URLDecoder.decode(request.getParameter("authName"));
	String empCnt = request.getParameter("empCnt");
	String compName = URLDecoder.decode(request.getParameter("compName"));
	
%>


<script type="text/javascript">
	var authCode = "<%= authCode %>"; 
	var authName = "<%= authName %>"; 
	var compName = "<%= compName %>"; 
	var empCnt = "<%= empCnt %>"; 
	$(document).ready(function() {	
		//기본버튼
	   $(".controll_btn button").kendoButton();
		
		// 팝업 크기 조절
		fnSetResize();
		
		// 사용자 리스트 가져오기
		fnAuthUserList();
		
		// 팝업 이름 가져오기
		fnInit();
	});

	function fnInit() {
		if(compName == "undefined") {
			compName = "";
		}
		$("#authName").text(authName);
		$("#compName").text(compName);
		$("#empCnt").text("/ " + empCnt + "<%=BizboxAMessage.getMessage("TX000000878","명")%>");
		
		$("#allCheck").click(function(){
			if($(this).is(":checked")) {
				$("input[name=check_empSeq]").prop("checked", true);
				
			} else {
				$("input[name=check_empSeq]").prop("checked", false);
			}
		});
	}
	
	// 팝업 크기 조절
	function fnSetResize() {
		$(".location_info").css("display", "none");
		$(".iframe_wrap").css("padding", "0");

		var strWidth = $('.pop_wrap').outerWidth()
				+ (window.outerWidth - window.innerWidth);
		var strHeight = $('.pop_wrap').outerHeight()
				+ (window.outerHeight - window.innerHeight);

		$('.pop_wrap').css("overflow", "auto");
		//$('.jstreeSet').css("overflow","auto");

		var isFirefox = typeof InstallTrigger !== 'undefined';
		var isIE = /*@cc_on!@*/false || !!document.documentMode;
		var isEdge = !isIE && !!window.StyleMedia;
		var isChrome = !!window.chrome && !!window.chrome.webstore;

		if (isFirefox) {

		}
		if (isIE) {
			$(".pop_foot").css("width", strWidth);
		}
		if (isEdge) {

		}
		if (isChrome) {
		}

		try {
			window.resizeTo(strWidth, strHeight);
		} catch (exception) {
			console.log('window resizing cat not run dev mode.');
		}
	}
	
	// 유저 리스트 데이터 호출
	function fnAuthUserList() {
		var params = {};
		params.authCode = authCode;
		
		$.ajax({
			type : "POST",
			data : params,
			async : false,
			url : '<c:url value="/accmoney/auth/AccPopAuthUserSelect.do" />',
			success : function(result) {
				console.log(JSON.stringify(result));
				fnAuthUserListDraw(result.authPopUserSelect);
			},
			error : function(result) {
				alert("<%=BizboxAMessage.getMessage("TX000010629","저장하는데 오류가 발생하였습니다.")%>");
			}
		});
	}
	
	// 권한 유저 리스트 그리기
	function fnAuthUserListDraw(data) {
		var tag = '';
		var length = data.length;
		
		for(var i=0; i<length; i++) {
			var key = data[i].group_seq + "|" + data[i].comp_seq + "|" + data[i].dept_seq + "|" + data[i].emp_seq;
			tag += '<tr>';
			tag += '<td>';
			tag += '<input type="checkbox" name="check_empSeq" id="' + data[i].emp_seq + '" class="k-checkbox" value=""> ';
			tag += '<label class="k-checkbox-label bdChk2" for="' + data[i].emp_seq + '"></label>';
			tag += '</td>';
			tag += '<td>' + data[i].comp_name + '</td>';
			tag += '<td>' + data[i].dept_name + '</td>';
			tag += '<td>' + data[i].position_code_name + '</td>';
			tag += '<td>' + data[i].emp_name + ' (' + data[i].login_id + ')</td>';
			tag += '<td>';
			tag += '<div class="controll_btn p0 ac">';
			tag += '<button onclick="fnChangeAuth(\'' + data[i].path + '\', ' + data[i].emp_seq +')"><%=BizboxAMessage.getMessage("TX000015966","변경하기")%></button>';
			tag += '</div>';
			tag += '</td>';
			tag += '</tr>';
		}
		
		$("#authList").html(tag);
	}
	
	// 유저 권한 삭제 이벤트
	function fnUserAuthDelete() {
		var param = {};
		var empSeqLists = new Array();
		
		
		
		$("#authList input[name='check_empSeq']").each(function(){
			var userSeq = {};
			if($(this).prop("checked")) {
				userSeq.empSeq = $(this).attr("id");
				empSeqLists.push(userSeq);
			}
		});
		
		var info = {};
		
		// 사용자 지정권한 판별
		if(authCode == "userAuth") {
			info.userAuth = "Y";
		} else {
			info.userAuth = "N";
		}
		
		info.empSeqLists = empSeqLists;
		info.authCode = authCode;
		
		param.info = info;
		param.info = JSON.stringify(info);
		
		if(!confirm("<%=BizboxAMessage.getMessage("TX000017351","권한을 삭제 하시겠습니까?")%>")) {
			return;
		}
		
		$.ajax({
			type: "POST"
			, url : '<c:url value="/accmoney/auth/AccUserAuthDelete.do"/>'
			, data : param
			, success: function(result) {
				window.opener.location.reload();
				alert("<%=BizboxAMessage.getMessage("TX000017352","권한이 삭제 되었습니다.")%>");
				window.close();
			}
			, error: function(result) {
				
			}
		});
	}
	
	// 권한 변경 하기 이벤트
	function fnChangeAuth(data, empSeq) {
		opener.fnCallBack(data, empSeq);
		window.close();
	}
	
</script>


<div class="pop_wrap color_pop_wrap" style="width:648px;">
	<div class="pop_head">
		<h1><%=BizboxAMessage.getMessage("TX000015967","사용자보기")%></h1>
		<a href="#n" class="clo"><img src="../../../Images/btn/btn_pop_clo01.png" alt="" /></a>
	</div>
	<div class="pop_con">

	<div class="cir_tit">
		<ul>
			<li>
				<dl>
					<dt>◎ <%=BizboxAMessage.getMessage("TX000000136","권한명")%> :</dt>
					<dd id="authName"><%=BizboxAMessage.getMessage("TX000015968","사용자지정")%></dd>
				</dl>
			</li>
			<li>
				<dl>
					<dt>◎ <%=BizboxAMessage.getMessage("TX000015969","권한회사")%> :</dt>
					<dd id="compName"><%=BizboxAMessage.getMessage("TX000010659","더존비즈온")%></dd>
					<dd id="empCnt">/ 08<%=BizboxAMessage.getMessage("TX000000878","명")%></dd>
				</dl>
			</li>
			<li class="fr mr0">
				<div class="controll_btn p0 ac" style="text-align: right;">
					<button tabindex="0" class="k-button" role="button" aria-disabled="false" onclick="fnUserAuthDelete()" data-role="button">삭제</button>
				</div>
			</li>
		</ul>
	</div>
		
			<div class="com_ta2" style="">
				<table>
					<colgroup>
						<col width="34" />
						<col width="120"/>
						<col width="120"/>
						<col width="120"/>
						<col width="120"/>
						<col width=""/>
					</colgroup>
					<tr>
						<th>
							<input type="checkbox" name="inp_chk" id="allCheck" class="k-checkbox"> 
							<label class="k-checkbox-label bdChk2" for="allCheck"></label>
						</th>
						<th><%=BizboxAMessage.getMessage("TX000000047","회사")%></th>
						<th><%=BizboxAMessage.getMessage("TX000000098","부서")%></th>
						<th><%=BizboxAMessage.getMessage("TX000000099","직급")%></th>
						<th><%=BizboxAMessage.getMessage("TX000000277","이름")%></th>
						<th><%=BizboxAMessage.getMessage("TX000015970","권한변경")%></th>
					</tr>
				</table>
			 </div>


			<div class="com_ta2 ova_sc cursor_p bg_lightgray" style="height:296px">
				<table>
					<colgroup>
						<col width="34"/>
						<col width="120"/>
						<col width="120"/>
						<col width="120"/>
						<col width="120"/>
						<col width=""/>
					</colgroup>
					<tbody id="authList">
								<!-- <tr>
						<td>더존비즈온</td>
						<td>자금팀</td>
						<td>수석연구원</td>
						<td>나팀장(id)</td>
						<td>
							<div class="controll_btn p0 ac">
								<button>변경하기</button>
							</div>
						</td>
					</tr> -->
					</tbody>
		


				</table>
			</div>

	</div><!-- //pop_con -->

<!--	<div class="pop_foot">
		<div class="btn_cen pt12">
			<input type="button" value="확인" />
			<input type="button" class="gray_btn" value="취소" />
		</div>
	</div> //pop_foot -->
	</div><!-- //pop_wrap -->