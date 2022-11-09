<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page import="main.web.BizboxAMessage"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=EUC-KR">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<title>BizboxAlpha Cloud</title>

     <!--css-->
	<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/js/pudd/css/pudd.css">
	<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/js/Scripts/jqueryui/jquery-ui.css"/>
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/common.css">
	<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/animate.css">
	<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/re_pudd.css">
	    
    <!--js-->
    <script type="text/javascript" src="${pageContext.request.contextPath}/js/pudd/js/pudd-1.1.84.min.js"></script>
    <script type="text/javascript" src="${pageContext.request.contextPath}/js/Scripts/jquery-1.9.1.min.js"></script>
	<script type="text/javascript" src="${pageContext.request.contextPath}/js/Scripts/jqueryui/jquery.min.js"></script>
	<script type="text/javascript" src="${pageContext.request.contextPath}/js/Scripts/jqueryui/jquery-ui.min.js"></script>    
   <script src="/gw/js/neos/NeosUtil.js"></script>

	<script type="text/javascript">
		$(document).ready(function(){
			init();		
		});
		
		function go_list(){  //목록이동
			$(".gnoti_view").removeClass("animated05s fadeInRight").hide();	
		}
		
		function init(){
			<c:if test="${pop_yn != 'Y'}">
	    	$.ajax({ 
		        type: "POST", 
		        url: "/gw/api/getGcmsNoticeList.do",        
		        data:{reqType : "all" },
		        success: function (data) {
		        	if(data.GcmsNoticeList != null){
		        		noticeList = data.GcmsNoticeList;
		        	}
		        	
		        	fnSearch();
		        },
		        error:function (e) {
		        	console.log(e);
		        }
			});
			</c:if>			
	    	
	    	fnRenderContents();
		}

		function fnRenderContents(){
			
			if("${seq}" != ""){
				
				$("#title").html('${title}');
				$("#create_by").html('관리자');
				$("#create_dt").html('${create_dt}');
				
				var contents = '${contents}';
				contents = contents.replace(/&tag_l;/gi, "<").replace(/&tag_r;/gi, ">").replace(/&tag_u;/gi, "'");
				
				$("#contents").html(contents);
				
				<c:if test="${pop_yn != 'Y'}">
				$(".gnoti_view").addClass("animated05s fadeInRight").show();
				</c:if>
			}	
		}
		
		function fnSearch(){
			
			var dataSource = new Pudd.Data.DataSource({
				data : filterList(noticeList)			// 직접 data를 배열로 설정하는 옵션 작업할 것
			,	pageSize : 10			// grid와 연동되는 경우 grid > pageable > pageList 배열값 중의 하나이여야 함
			,	serverPaging : false
			});
	    	 
	    	Pudd( "#grid" ).puddGrid({
	    			dataSource : dataSource
				,	scrollable : true
				,	sortable : true
				,   height : 300
	    		,	pageable : {
	    				buttonCount : 10
	    			,	pageList : [ 10, 20, 30, 40, 50 ]
	    			,	showAlways : false
	    			}
	    		,	columns : [
	    				{
	    					field : "seq"
	    				,	title : "NO."
	    				,	width : 50
	    				}
	    			,	{
	    					field : "title"
	    				,	title : "<%=BizboxAMessage.getMessage("TX000018669","제목",request.getSession().getAttribute("nativeLangCode") == null ? "kr" : request.getSession().getAttribute("nativeLangCode").toString())%>"
	    				,	content : {
							template : function( rowData ){
								
								return rowData.title.replace(/&&lt;/gi, "<").replace(/&gt;/gi, ">").replace(/&#39;/gi, "'");
								
								}
							}	    				
	    				}
	    			,	{
	    					title:"<%=BizboxAMessage.getMessage("TX000022085","작성자",request.getSession().getAttribute("nativeLangCode") == null ? "kr" : request.getSession().getAttribute("nativeLangCode").toString())%>"
	    				,	width : 80
	    				,	content : {
							template : function( rowData ){								
									return "<%=BizboxAMessage.getMessage("TX000021350","관리자",request.getSession().getAttribute("nativeLangCode") == null ? "kr" : request.getSession().getAttribute("nativeLangCode").toString())%>";								
								}
							}	    				
	    				}
	    			,	{
	    					field:"create_dt"
	    				,	title:"<%=BizboxAMessage.getMessage("TX000000612","등록일",request.getSession().getAttribute("nativeLangCode") == null ? "kr" : request.getSession().getAttribute("nativeLangCode").toString())%>"
	    				,	width: 180
	    				}
	    			]
	    		,	loadCallback : function( headerTable, contentTable, footerTable, gridObj ) {
	    			
	    			

	    		}
	    	});
	    	 //리스트 클릭: 게시물 보기
			Pudd( "#grid" ).on( "gridRowClick", function(e) {
				var evntVal = e.detail;
	    		if( ! evntVal ) return;
	    		if( ! evntVal.trObj ) return;
	    		
				$("#title").html(evntVal.trObj.rowData.title);
				$("#create_by").html("<%=BizboxAMessage.getMessage("TX000021350","관리자",request.getSession().getAttribute("nativeLangCode") == null ? "kr" : request.getSession().getAttribute("nativeLangCode").toString())%>");
				$("#create_dt").html(evntVal.trObj.rowData.create_dt);
				
				var contents = evntVal.trObj.rowData.contents;
				contents = contents.replace(/&tag_l;/gi, "<").replace(/&tag_r;/gi, ">").replace(/&tag_u;/gi, "'");
				$("#contents").html(contents);				
				$(".gnoti_view").addClass("animated05s fadeInRight").show();					
			});
		}
		
		function filterList(list){
			if(txtSearchStr.value != ""){
				return list.filter(filterByTitle);
			}
			return list;
		}
		
		function filterByTitle(item) {
			  if (item.title.indexOf(txtSearchStr.value) > -1) {
			    return true;
			  } 

			  return false; 
		}
		
		function fnUnexposed(seq){
			
			if(opener != null){
				opener.localStorage.setItem('bizboxCloudNoticeInfo', opener.localStorage.getItem('bizboxCloudNoticeInfo') + '|' + seq + '|');	
			}else{
				localStorage.setItem('bizboxCloudNoticeInfo', localStorage.getItem('bizboxCloudNoticeInfo') + '|' + seq + '|');	
			}

			window.close();
			
		}
		
	</script>
</head>
<body>
<div class="pop_wrap" style="border:none;">
	<div class="pop_head">
		<h1><%=BizboxAMessage.getMessage("TX900000560","그룹웨어 공지사항",request.getSession().getAttribute("nativeLangCode") == null ? "kr" : request.getSession().getAttribute("nativeLangCode").toString())%></h1>
	</div>	

	<div class="pop_con posi_re" <c:if test="${pop_yn == 'Y'}">style="height: 454px;"</c:if>>

		<c:if test="${pop_yn != 'Y'}">
		<div class="gonti_list">
			<div class="top_box">
			<dl>
				<dt><%=BizboxAMessage.getMessage("TX000000493","제목",request.getSession().getAttribute("nativeLangCode") == null ? "kr" : request.getSession().getAttribute("nativeLangCode").toString())%></dt>
				<dd><input type="text" class="puddSetup" pudd-style="width:200px;" id="txtSearchStr" name="txtSearchStr"></dd>
				<dd><input type="button" class="puddSetup submit" value="<%=BizboxAMessage.getMessage("TX000001289","검색",request.getSession().getAttribute("nativeLangCode") == null ? "kr" : request.getSession().getAttribute("nativeLangCode").toString())%>" onclick="fnSearch();"/></dd>
			</dl>
			</div>	
			<div id="grid" class="mt14"></div>
		</div>
		</c:if>
		
		<div class="gnoti_view posi_ab" style="top:0px;left:0px;background:#fff;width:100%;<c:if test="${pop_yn != 'Y'}">display:none;</c:if>">
			<div class="gnoti_view_in" style="padding:20px 16px;">
				<c:if test="${pop_yn != 'Y'}">
				<div class="btn_div mt0">
					<div class="right_div">
						<input type="button" class="puddSetup" value="<%=BizboxAMessage.getMessage("TX000003107","목록",request.getSession().getAttribute("nativeLangCode") == null ? "kr" : request.getSession().getAttribute("nativeLangCode").toString()) %>" onclick="go_list();" />
					</div>
				</div>
				</c:if>
				
				<div class="com_ta6" style="height:<c:if test="${pop_yn != 'Y'}">440</c:if><c:if test="${pop_yn == 'Y'}">473</c:if>px; overflow:auto;">
					<table>
						<colgroup>
							<col width="120"/>
							<col width=""/>
						</colgroup>
						<tr>
							<th><%=BizboxAMessage.getMessage("TX000018669","제목",request.getSession().getAttribute("nativeLangCode") == null ? "kr" : request.getSession().getAttribute("nativeLangCode").toString())%></th>
							<td class="le"><strong id="title"></strong></td>
						</tr>
						<tr>
							<th><%=BizboxAMessage.getMessage("TX000022085","작성자",request.getSession().getAttribute("nativeLangCode") == null ? "kr" : request.getSession().getAttribute("nativeLangCode").toString())%></th>
							<td class="le" id="create_by"></td>
						</tr>
						<tr>
							<th><%=BizboxAMessage.getMessage("TX000001598","등록일",request.getSession().getAttribute("nativeLangCode") == null ? "kr" : request.getSession().getAttribute("nativeLangCode").toString())%></th>
							<td class="le" id="create_dt"></td>
						</tr>
						<tr>
							<td class="le p15" colspan="2" valign="top" style="height:295px;" id="contents"></td>
						</tr>
					</table>
				</div>
			</div>
		</div>
	</div>
	
	<c:if test="${pop_yn == 'Y'}">
	<div class="pop_closeall">
		<p class="fl"><input type="checkbox" value="" class="puddSetup" id="popup_check" onclick="fnUnexposed('${seq}');" pudd-label="<%=BizboxAMessage.getMessage("TX000018366","다시보지않기",request.getSession().getAttribute("nativeLangCode") == null ? "kr" : request.getSession().getAttribute("nativeLangCode").toString())%>" /></p>
		<p class="fr"><a onclick="javascript:window.close();" href="#" class="pop_close"><%=BizboxAMessage.getMessage("TX000002972","닫기",request.getSession().getAttribute("nativeLangCode") == null ? "kr" : request.getSession().getAttribute("nativeLangCode").toString())%></a></p>
	</div>
	</c:if>
</div>
</body>
</html>