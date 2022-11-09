<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="main.web.BizboxAMessage"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="ko" xml:lang="ko">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <title>Bizbox A</title>
    
     <!--css-->
	<link rel="stylesheet" type="text/css" href="/gw/css/jqueryui/jquery-ui.css"/>
    <link rel="stylesheet" type="text/css" href="/gw/css/common.css?ver=20201021">
	    
    <!--js-->
    <script type="text/javascript" src="/gw/js/Scripts/jquery-1.9.1.min.js"></script>
	<script type="text/javascript" src="/gw/js/Scripts/jqueryui/jquery.min.js"></script>
	<script type="text/javascript" src="/gw/js/Scripts/jqueryui/jquery-ui.min.js"></script>
    <script type="text/javascript" src="/gw/js/Scripts/common.js"></script>
</head>

<script>

var imgArrayList = null;
var currentPage = 1;

$(document).ready(function() {

	$("#btnConfirm").click(function() {
		if($(".ico_check").length > 0){
			var imgUrl = $(".ico_check").parent().find('img').attr("src");
			opener.callbackMobileImg(imgUrl);
			self.close();
		}else{
			alert("<%=BizboxAMessage.getMessage("TX900000556","선택된 이미지가 존재하지 않습니다.")%>");
		}
	});

	$("#btnCancel").click(function() {
		self.close();
	});
	getMobileImgList();
});


	function getMobileImgList(){
		$.ajax({
			type:"post",
			url:'/gw/getMobileImgList.do',
			datatype:"json",
			success:function(data){
				imgArrayList = data.listDate.sort(sortByProperty("fileNm"));
				setMobileImgListTalbe(data.listDate.sort(sortByProperty("fileNm")));
			},			
			error : function(e){	//error : function(xhr, status, error) {
				alert("error");	
			}
		});		
	}
		
	function sortByProperty(property) {
	    return function (a, b) {
	        var sortStatus = 0,
	            aProp = a[property].toLowerCase(),
	            bProp = b[property].toLowerCase();
	        if (aProp < bProp) {
	            sortStatus = 1;
	        } else if (aProp > bProp) {
	            sortStatus = -1;
	        }
	        return sortStatus;
	    };
	}		

	function fn_imgDel(src){
		if(confirm("<%=BizboxAMessage.getMessage("TX900000557","해당 이미지를 삭제하시겠습니까?")%>")){			
			var tblParam = {};
			tblParam.src = src;
			$.ajax({
				type:"post",
				url:'/gw/delMobileImg.do',
				datatype:"json",
				data : tblParam,
				success:function(data){
					alert("<%=BizboxAMessage.getMessage("TX000002074","삭제되었습니다.")%>");
					getMobileImgList();
				},			
				error : function(e){	//error : function(xhr, status, error) {
					//alert("error");	
				}
			});
		}
	}

	function setMobileImgListTalbe(imgList){
		$("#imgTable1").html("");
		$("#imgTable2").html("");
		var innerHtml1 = "";
		var innerHtml2 = "";	
		for(var i=0; i<10; i++){
			if(i < 5){
				innerHtml1 += "<td id='" + i + "'>";
				innerHtml1 += "<ul>";	
				if(imgList[i] != null){
					var imgNm = imgList[i].fileNm;
					imgNm = imgNm.substring(0,13) + ":" + imgNm.substring(13,15) + ":" + imgNm.substring(15);
					
					innerHtml1 += "<li><img src='" + imgList[i].fileUrl + "' alt='' id='imgTag_" + i + "'/></li>";
					innerHtml1 += "<li class='day'>" + imgNm + "</li>";
				}else{
					innerHtml1 += "<li></li>";
					innerHtml1 += "<li class='day'></li>";
				}
				innerHtml1 += "</ul>";
				innerHtml1 += "</td>";
			}else if(i >= 5 && i < 10){
				innerHtml2 += "<td id='" + i + "'>";
				innerHtml2 += "<ul>";
				if(imgList[i] != null){
					var imgNm = imgList[i].fileNm;
					imgNm = imgNm.substring(0,13) + ":" + imgNm.substring(13,15) + ":" + imgNm.substring(15);

					innerHtml2 += "<li><img src='" + imgList[i].fileUrl + "' alt='' id='imgTag_" + i + "'/></li>";
					innerHtml2 += "<li class='day'>" + imgNm + "</li>";
				}else{
					innerHtml2 += "<li></li>";
					innerHtml2 += "<li class='day'></li>";
				}
				
				innerHtml2 += "</ul>";
				innerHtml2 += "</td>";
			}
		}
		$("#imgTable1").html(innerHtml1);
		$("#imgTable2").html(innerHtml2);

		
		$('.mobile_img tr td').mouseenter(function(){
			if($(this).find('img').length > 0){
				  var imgUrl = $("#imgTag_" + $(this)[0].id).attr("src");
			      $(this).append("<div class='ico_checkdel' onclick='fn_imgDel(\"" + imgUrl + "\")'></div>");	
			      $(this).find("ul").css("outline","1px solid #f33e51");	
			      $(this).find(".ico_check").hide();
			}
	    }).mouseleave(function(){
	    	if($(this).find('img').length > 0){
		       $(".ico_checkdel").remove();
		       $(this).find(".ico_check").show();
		       $(this).find("ul").css("outline","none");
	    	}
	    });
		    
	    $('.mobile_img tr td').click(function(){
	    	if($(this).find('img').length > 0){
		    	$(".ico_checkdel").remove();
		        $(".ico_check").remove();
		        $(this).append("<span class='ico_check'></span>");	
		        $(this).find("ul").css("outline","none");
	    	}
		});
		
		
		
		setPagingTag();
	}
	
	
	function setPagingTag(){
		pagingTag = "";
		pagingCnt = parseFloat(imgArrayList.length / 10) == 0 ? 1 : Math.ceil(parseFloat(imgArrayList.length / 10));
		
		for(var i=0; i<pagingCnt; i++){			
			if(i == 0){
				pagingTag += "<li class='on onTag' onclick=pagingClick(this,"+ (i+1) +") id='onTag" + (i+1) + "'>";	
			}
			else{
				pagingTag += "<li class='onTag' onclick=pagingClick(this," + (i+1) +") id='onTag" + (i+1) + "'>";
			}
			pagingTag += "<a href='#'>" + (i+1) + "</a></li>";
		}
		$("#pagingNum").html(pagingTag);
	}
	
	
	function pagingClick(e, index){
		$(".on").removeClass("on");
		$(e).addClass("on");
		currentPage = index;
		
		tableReSetting();
	}
	
	
	function tableReSetting(){
		$("#imgTable1").html("");
		$("#imgTable2").html("");
		
		var innerHtml1 = "";
		var innerHtml2 = "";	
		
		for(var i=(currentPage*10-10); i<(currentPage*10); i++){
			var var1 = currentPage == 1 ? 0 : currentPage-1;			
			if(i < (var1*10+5)){
				innerHtml1 += "<td id='" + i + "'>";
				innerHtml1 += "<ul>";
				if(imgArrayList[i] != null){
					var imgNm = imgArrayList[i].fileNm;
					imgNm = imgNm.substring(0,13) + ":" + imgNm.substring(13,15) + ":" + imgNm.substring(15);

					innerHtml1 += "<li><img src='" + imgArrayList[i].fileUrl + "' alt='' id='imgTag_" + i + "'/></li>";
					innerHtml1 += "<li class='day'>" + imgNm + "</li>";
				}else{
					innerHtml1 += "<li></li>";
					innerHtml1 += "<li class='day'></li>";
				}
				innerHtml1 += "</ul>";
				innerHtml1 += "</td>";
			}else if(i >= (var1*10+5) && i < (10*currentPage)){
				innerHtml2 += "<td id='" + i + "'>";
				innerHtml2 += "<ul>";
				if(imgArrayList[i] != null){
					var imgNm = imgArrayList[i].fileNm;
					imgNm = imgNm.substring(0,13) + ":" + imgNm.substring(13,15) + ":" + imgNm.substring(15);

					innerHtml2 += "<li><img src='" + imgArrayList[i].fileUrl + "' alt='' id='imgTag_" + i + "'/></li>";
					innerHtml2 += "<li class='day'>" + imgNm + "</li>";
				}else{
					innerHtml2 += "<li></li>";
					innerHtml2 += "<li class='day'></li>";
				}
				innerHtml2 += "</ul>";
				innerHtml2 += "</td>";
			}
		}
		$("#imgTable1").html(innerHtml1);
		$("#imgTable2").html(innerHtml2);
		
		
		$('.mobile_img tr td').mouseenter(function(){ 
			  if($(this).find('img').length > 0){
			      var imgUrl = $("#imgTag_" + $(this)[0].id).attr("src");
			      $(this).append("<div class='ico_checkdel' onclick='fn_imgDel(\"" + imgUrl + "\")'></div>");	
			      $(this).find("ul").css("outline","1px solid #f33e51");	
			      $(this).find(".ico_check").hide();
			  }
		    }).mouseleave(function(){
		       if($(this).find('img').length > 0){
			       $(".ico_checkdel").remove();
			       $(this).find(".ico_check").show();
			       $(this).find("ul").css("outline","none");
		       }
		    });
		    
		    $('.mobile_img tr td').click(function(){     
		    	if($(this).find('img').length > 0){
			    	$(".ico_checkdel").remove();
			        $(".ico_check").remove();
			        $(this).append("<span class='ico_check'></span>");	
			        $(this).find("ul").css("outline","none");
		    	}
			});		    		 
	}
	
	function fnPageMove(type){		
		if(type == "prev"){
			if($("#onTag" + (currentPage - 1)).length > 0){
				$(".on").removeClass("on");
				currentPage = currentPage -1;
				$("#onTag" + currentPage).addClass("on");
			}
		}else if(type == "next"){
			if($("#onTag" + (currentPage + 1)).length > 0){
				$(".on").removeClass("on");
				currentPage = currentPage +1;
				$("#onTag" + currentPage).addClass("on");
			}
		}else if(type == "first"){
			$(".on").removeClass("on");
			$("#onTag1").addClass("on");
			currentPage = 1;
		}else if(type == "end"){
			$(".on").removeClass("on");
			var cnt = $(".onTag").length;
			$("#onTag" + cnt).addClass("on");
			currentPage = cnt;
		}
			
		tableReSetting();
	}
</script>

<body>
<div class="pop_wrap">
	<div class="pop_head">
		<h1><%=BizboxAMessage.getMessage("TX900000558","모바일 이미지 삽입")%></h1>
		<a href="#n" class="clo"><img src="/gw/Images/btn/btn_pop_clo01.png" alt="" /></a>
	</div><!-- //pop_head -->
	
	<div class="pop_con com_ta mobile_img">
		<table>
		<colgroup>
				<col width="20%"/>
				<col width="20%"/>
				<col width="20%"/>
				<col width="20%"/>
				<col width="20%"/>
			</colgroup>
			<tr id="imgTable1">
				<td>
					<ul>
						<li></li>
						<li></li>
					</ul>
				</td>				
			</tr>
			<tr id="imgTable2">
				<td>
					<ul>
						<li></li>
						<li></li>
					</ul>
				</td>
			</tr>
		</table>

		<div class="gt_paging">
			<div class="paging">	
				<span class="pre_pre" onclick="fnPageMove('first')"><a href="#"><%=BizboxAMessage.getMessage("TX000019528","처음으로")%></a></span>
				<span class="pre" onclick="fnPageMove('prev')"><a href="#"><%=BizboxAMessage.getMessage("TX000003165","이전")%></a></span>
					<ol id="pagingNum">
					</ol>
				<span class="nex" onclick="fnPageMove('next')"><a href="#"><%=BizboxAMessage.getMessage("TX000003164","다음")%></a></span>	
				<span class="nex_nex" onclick="fnPageMove('end')"><a href="#"><%=BizboxAMessage.getMessage("TX900000559","끝으로")%></a></span>
			</div>
		</div>

	</div><!-- //pop_con -->

	<div class="pop_foot">
		<div class="btn_cen pt12">
			<input type="button" id="btnConfirm" value="<%=BizboxAMessage.getMessage("TX000000078","확인")%>" />
			<input type="button" id="btnCancel" class="gray_btn" value="<%=BizboxAMessage.getMessage("TX000002947","취소")%>" />
		</div>
	</div><!-- //pop_foot -->
	</div><!-- //pop_wrap -->
</body>
</html>
