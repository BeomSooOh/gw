<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="validator" uri="http://www.springmodules.org/tags/commons-validator" %>
<meta http-equiv="p3p" content='CP="CAO DSP AND SO " policyref="/w3c/p3p.xml"' >
<%@page import="main.web.BizboxAMessage"%>
<%@page import="neos.cmm.util.BizboxAProperties"%>

<style>
@charset "utf-8";
/* CSS Document */
a,img{
	selector-dummy:expression(this.hideFocus=true); border:none;}
img {
	border:none;
}
body,div,table,td,th,tr,ul,ol,li,dl,dt,dd{
	border:0;
	margin:0;
	padding:0;
	/* vertical-align:top; toktok개선 삭제 */
	border-collapse:collapse;
}
body{
	/*height:10px;*/
	background:#f0f0f0;/* toktok개선 수정 */
	/* padding-top:2px; */
}
td{
	vertical-align:top;
	/* padding-top:4px;*padding-top:6px; toktok개선 삭제 */
	line-height:14px; padding-top:1px; .padding-bottom:2px; /* toktok개선 추가 */
}
table{
	width:100%;
	border-collapse:collapse;/* toktok개선 추가 */
}
.m_img_vert {padding-bottom:0px !important; font-size:0; line-height:0; /* toktok개선 추가 */}
.m_img_vert img {margin:0; padding:0; border-width:0; margin-top:3px;
	/*
	vertical-align:middle;
	padding-bottom:2px;
	toktok개선 삭제 */
	margin-right:5px;/*height:1px !important; width:5px !important;/* toktok개선 추가 */
}
.mail_txt a,
.mail_txt a:hover,
.mail_txt a:active,
.mail_txt a:visited {
	text-decoration:none;
	font:12px/19px Malgun gothic;
	color:#484848;
}
.mail_txt dt {
	/*
	padding-left:8px; 
	padding-right:10px;
	toktok개선 삭제 */ /*line-height:18px;20100728추가*/
	line-height:13px;/* toktok개선 추가 */
}
.m_txt_mail_num{
	color:#ee183e;
	font-weight:bold;
	/* font-family:Gulim, GulimChe,Dotum, DotumChe, verdana, tahoma, arial;
	line-height:13px;*/
}
.m_txt_mail_num2{
	color:#ff4040;
	/* font-family:Gulim, GulimChe,Dotum, DotumChe, verdana, tahoma, arial; 
	line-height:13px; */
}

.m_align_r{
	text-align:right;
	padding-right:5px; _padding-right:20px; white-space:nowrap; padding-left:5px; /* toktok개선 추가 */
}
.bottom_line{
	/* padding-bottom:7px;*padding-bottom:5px;
	border-bottom:solid 1px #dee1e9; toktok개선 삭제 */
}

/***********스크롤*************/
.overflow1{
	overflow-y:auto;
	overflow-x:hidden;
	height:86px;/*110px -> 86px */
	color:#6d7286;
	font:12px 'Malgun gothic', Gulim, Dotum, verdana, tahoma, arial;
	padding-left:17px;_padding-left:36px;
	line-height:16px;
}
.overflow1 li{
	padding-bottom:5px;
}
.overflow1 table{
	_margin-left:-1px;
}
.overflow1 li .ico1 img{
	float:left;
	display:block;
	margin-left:-19px;
	margin-top:1px;
}
*html .overflow1 li .ico1{margin-left:-1px;	}
.scroll1{
	scrollbar-face-color: #ffffff;/*스크롤바 표면 색상*/
	scrollbar-highlight-color: #ffffff;/*표면 왼쪽 부분 겉색상*/
	scrollbar-shadow-color: #dee1e9;/*표면 오른쪽 부분 그림자 겉색상*/
	scrollbar-3dlight-color: #dee1e9;/*표면 왼쪽 부분 입체감 색상*/
	scrollbar-arrow-color: #9a9ba8;/*스크롤바 조그만 삼각형 색상*/
	scrollbar-track-color: #ffffff;/*스크롤바 밑에 레일 트렉 색상*/
	scrollbar-darkshadow-color: #ffffff;/*표면 밑 부분 그림자 색상*/
}


</style>

<script type="text/javascript">

	var mailUrl = "${mailUrl}"; 

	$(document).ready(function () {
		
		var CustPortletType = '<%=BizboxAProperties.getCustomProperty("BizboxA.Cust.CustPortletType")%>';
		
		if(CustPortletType == "B"){
			
			
			
		}else if(CustPortletType == "D"){
			
			$("#ea1Name").html("<%=BizboxAMessage.getMessage("TX000005555","미결함")%>");
			$("#ea2Name").html("<%=BizboxAMessage.getMessage("TX000000475","진행중")%>");
			$("#trEa3Cnt").show();
			
		}else{
			
			$("#trEmailCnt").show();
			
		}
		
		$("#trEa1Cnt,#trEa2Cnt").show();
	
		if("${result}" == "0"){
			fnSetPortletCntDate();
		}
		
	});
	
	function fnSetPortletCntDate(){
		var cntList = JSON.parse('${cntList}' || '{}');
		$("#mailCnt").text(cntList.count || '0');
		$("#eaCnt1").text(cntList.eaCnt1 || '0');
		$("#eaCnt2").text(cntList.eaCnt2 || '0');
		$("#eaCnt3").text(cntList.eaCnt3 || '0');
	}
	
	
	function page_link(type){
		var url = "";		
		if(type == "EM"){
			url = "/mail2/";		
			openWindow2("custPortletTargetPop.do?url="+url, "Web Mail", 1200, 600, 0);
		}else if(type == "EA1"){
			mainToLnbMenu('2000000000', '<%=BizboxAMessage.getMessage("TX000000479","전자결재")%>', '', 'eap', '', 'main', '2000000000', '2002020000', '<%=BizboxAMessage.getMessage("TX000005555","미결함")%>', 'main');		
			window.open('','frmpop','height=' + screen.height + ',width=' + screen.width + 'fullscreen=yes');     
	        var frmData = document.frmpop;			
	        frmData.submit();	
		}else if(type == "EA2"){
			mainToLnbMenu('2000000000', '<%=BizboxAMessage.getMessage("TX000000479","전자결재")%>', '', 'eap', '', 'main', '2000000000', '2002010000', '<%=BizboxAMessage.getMessage("TX000005556","상신함")%>', 'main');		
			window.open('','frmpop','height=' + screen.height + ',width=' + screen.width + 'fullscreen=yes'); 	         
	        var frmData = document.frmpop;			
	        frmData.submit();	
		}else if(type == "EA3"){
			mainToLnbMenu('2000000000', '<%=BizboxAMessage.getMessage("TX000000479","전자결재")%>', '', 'eap', '', 'main', '2000000000', '2002090000', '<%=BizboxAMessage.getMessage("TX000018507","수신참조함")%>', 'main');		
			window.open('','frmpop','height=' + screen.height + ',width=' + screen.width + 'fullscreen=yes'); 	         
	        var frmData = document.frmpop;			
	        frmData.submit();	
		}
	}
	
	function openWindow2(url,  windowName, width, height, strScroll, strResize ){

		var pop = "" ;
		windowX = Math.ceil( (window.screen.width  - width) / 2 );
		windowY = Math.ceil( (window.screen.height - height) / 2 );
		if(strResize == undefined || strResize == '') {
			strResize = 0 ;
		}
		pop = window.open(url, windowName, "width=" + width + ", height=" + height + ", top="+ windowY +", left="+ windowX +", scrollbars="+ strScroll+", resizable="+ strResize);
		try {pop.focus(); } catch(e){
			console.log(e);//오류 상황 대응 부재
		}
		return pop;
	}	
	
	
	function mainToLnbMenu(no, name, url, urlGubun, email, portletType, gnbMenuNo, lnbMenuNo, lnbName , mainForward){		
		$("#no").val(no);
		$("#name").val(name);
		$("#url").val(url);
		$("#urlGubun").val(urlGubun);
		$("#portletType").val(portletType);
		$("#gnbMenuNo").val(gnbMenuNo);
		$("#lnbMenuNo").val(lnbMenuNo);
		$("#lnbName").val(lnbName);
		$("#mainForward").val(mainForward);
	};
	
</script>

<table class="pd_mail_txt ">
		<tr id="trEmailCnt" style="display:none;">
				<td width="10" class="m_img_vert mail_txt bottom_line">
					<img src="/gw/Images/cust/ico_document.gif" alt="" width="13" height="14" />
				</td>
				<td align="left" class="mail_txt bottom_line">
				<dt class="pd_mail_txt1"><a href="javascript:page_link('EM')"><%=BizboxAMessage.getMessage("TX000016182","안읽은 메일")%></a></dt>
				</td>
				<td  class="m_align_r mail_txt bottom_line">
					<a href="javascript:page_link('EM')"> <span class="m_txt_mail_num" id="mailCnt">0</span><%=BizboxAMessage.getMessage("TX000000476","건")%> </a>
				</td>
		</tr>
		<tr id="trEa1Cnt" style="display:none;">
				<td width="10"  class="m_img_vert" style="padding-bottom:5px;">
					<img src="/gw/Images/cust/ico_document.gif" alt="" width="13" height="14" />
				</td>
				<td class="mail_txt">
				<dt><a id="ea1Name" href="javascript:page_link('EA1')"><%=BizboxAMessage.getMessage("TX000016382","결재할 문서")%></a></dt>
				</td>
				<td  class="m_align_r mail_txt">
					<a href="javascript:page_link('EA1')"> <span class="m_txt_mail_num" id="eaCnt1">0</span><%=BizboxAMessage.getMessage("TX000000476","건")%> </a>
				</td>
		</tr>
		<tr id="trEa3Cnt" style="display:none;">
				<td width="10"  class="m_img_vert" style="padding-bottom:5px;">
					<img src="/gw/Images/cust/ico_document2.gif" alt="" width="13" height="14" />
				</td>
				<td class="mail_txt">
				<dt><a id="ea3Name" href="javascript:page_link('EA3')"><%=BizboxAMessage.getMessage("TX000018507","수신참조함")%></a></dt>
				</td>
				<td  class="m_align_r mail_txt">
					<a href="javascript:page_link('EA3')"> <span class="m_txt_mail_num" id="eaCnt3">0</span><%=BizboxAMessage.getMessage("TX000000476","건")%> </a>
				</td>
		</tr>		
		<tr id="trEa2Cnt" style="display:none;">
				<td width="10"  class="m_img_vert" style="padding-bottom:5px;">
					<img src="/gw/Images/cust/ico_document2.gif" alt="" width="13" height="14" />
				</td>
				<td class="mail_txt">
				<dt><a id="ea2Name" href="javascript:page_link('EA2')"><%=BizboxAMessage.getMessage("TX000016383","결재중 문서")%></a></dt>
				</td>
				<td  class="m_align_r mail_txt">
					<a href="javascript:page_link('EA2')"> <span class="m_txt_mail_num" id="eaCnt2">0</span><%=BizboxAMessage.getMessage("TX000000476","건")%> </a>
				</td>
		</tr>
		
</table>





<form id="frmpop" name="frmpop" method="post" action="/gw/bizbox.do" target="frmpop">
  <input id="no" name="no" value="" type="hidden"/>
  <input id="name" name="name" value="" type="hidden"/>
  <input id="url" name="url" value="" type="hidden"/>
  <input id="urlGubun" name="urlGubun" value="" type="hidden"/>
  <input id="portletType" name="portletType" value="" type="hidden"/>
  <input id="gnbMenuNo" name="gnbMenuNo" value="" type="hidden"/>
  <input id="lnbMenuNo" name="lnbMenuNo" value="" type="hidden"/>  
  <input id="lnbName" name="lnbName" value="" type="hidden"/>
  <input id="mainForward" name="mainForward" value="" type="hidden"/>
</form>






