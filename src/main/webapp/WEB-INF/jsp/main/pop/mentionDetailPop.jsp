<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="validator" uri="http://www.springmodules.org/tags/commons-validator" %>
<%@page import="main.web.BizboxAMessage"%>

<script type="text/javascript">
$(document).ready(function() {
	
	
	fnSetMention();
});


function fnSetMention(){	
		var contents = $("#alertContents").html();				
		for(;;){
			if(contents.indexOf("|&gt;@") != -1 && contents.indexOf("@&lt;|") != -1){
				var name = contents.substring(contents.indexOf(",name=")+7, contents.indexOf("@&lt;|")-1);					
				contents = contents.slice(0,contents.indexOf("|&gt;@")) + '<span class="mt_marking">@' + name + '</span>' + contents.slice(contents.indexOf("@&lt;|")+6);
			}
			else{
				break;
			}
		}
		$("#alertContents").html(contents);
		
		
		var data = $(".mention_detail").attr("data");
		var eventSubType = "${result.result.alertList[0].eventSubType}";
}


</script>


<body>
	<div class="pop_sign_wrap">
		<div class="pop_sign_head">
			<h1><%=BizboxAMessage.getMessage("TX000006020","상세보기")%></h1>
		</div>	
		
		<div class="pop_sign_con">
			<div class="pop_con posi_re" style="height: 311px;">
				<div class="mention_alert_detail">
					<div class="pic_wrap">
						<div class="pic"></div>
						<div class="div_img">							
							<img src="${profilePath}/${result.result.alertList[0].senderSeq}_thum.jpg?<%=System.currentTimeMillis()%>" onerror="this.src='/gw/Images/bg/mypage_noimg.png'" >
						</div>
					</div>
					<div class="text_con">
						<dl>
							<dt class="title">${result.result.alertList[0].message.alertTitle}</dt>
							<dd class="mention_detail animated1s fadeIn" data='${result.result.alertList[0].data}'>
								<span class="msg"></span>
								<p id="alertContents">${result.result.alertList[0].message.alertContent}<p>
							</dd>
						</dl>
					</div>
				</div>
				
			</div>
		</div>
	</div>
</body>