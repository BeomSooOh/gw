<%-- <%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="tiles"   uri="http://tiles.apache.org/tags-tiles" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="validator" uri="http://www.springmodules.org/tags/commons-validator" %> --%>

<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@page import="main.web.BizboxAMessage"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
<script type="text/javascript" src="js/kendoui/jquery.min.js"></script>
<style type="text/css">
    	/**************************************************
		   reset CSS
		**************************************************/
		html,body{width:100%;height:100%;overflow:hidden;}
		body,div,dl,dt,dd,ul,ol,li,h1,h2,h3,h4,h5,h6,form,fieldset,p,button,input,select,td,th,table,pre,strong,b,i,textarea{margin:0;padding:0; }
		body,h1,h2,h3,h4,h5,h6,input,button,pre,textarea,select{font-family:'돋움',Dotum,'굴림',Gulim,sans-serif;font-size:12px;}
		body{background-color:#fff;*word-break:break-all;-ms-word-break:break-all;}
		img,fieldset,iframe{border:0 none}
		li{list-style:none}
		input,select,button,img{vertical-align:middle}
		i,em,address{font-style:normal}
		label,button{cursor:pointer}
		button{margin:0;padding:0}
		button *{position:relative}
		button img{left:-3px;*left:auto}
		html:first-child select{height:20px;padding-right:6px}
		option{padding-right:6px}
		textarea {resize:none;}
		hr{display:none}
		legend{*width:0}
		table{border-collapse:collapse;border-spacing:0}
		map area{outline:none}
		a {text-decoration:none;color:#4a4a4a;}
		
		/**************************************************
		   layout CSS
		**************************************************/
    	.body_wrap{position:relative;overflow:hidden;}
    	.body_wrap .top_box_wrap{height:99px;line-height:99px;border-bottom:1px solid #aaaaaa;text-align:center;background:#eeeeee;}
    	.body_wrap .con_box_wrap{position:relative;}
    	.body_wrap .con_box_wrap .con_left_box{float:left;width:149px;height:100%;border-right:1px solid #aaaaaa;overflow:hidden;}
    	.body_wrap .con_box_wrap .con_left_box h3{text-align:center;height:49px;line-height:49px;border-bottom:1px solid #aaaaaa;background:#eeeeee;}
    	.body_wrap .con_box_wrap .con_left_box .btn_list{overflow:auto;}
    	.body_wrap .con_box_wrap .con_left_box .btn_list li{border-bottom:1px solid #e1e1e1;text-align:center;}
    	.body_wrap .con_box_wrap .con_left_box .btn_list li a{display:block;padding:10px 0;background:#f9f9f9;}
    	.body_wrap .con_box_wrap .con_left_box .btn_list li a:hover{display:block;padding:10px 0;background:#eeeeee;}
    	
    	.body_wrap .con_box_wrap .con_right_box{float:right;width:149px;height:100%;border-left:1px solid #aaaaaa;overflow:auto;}
    	.body_wrap .con_box_wrap .con_right_box h3{text-align:center;height:49px;line-height:49px;border-bottom:1px solid #aaaaaa;background:#eeeeee;}
    	.body_wrap .con_box_wrap .con_right_box .tmpl_list{overflow:auto;}
    	.body_wrap .con_box_wrap .con_right_box .tmpl_list li{margin:10px 0;}
    	.body_wrap .con_box_wrap .con_right_box .tmpl_list li .sel{display:inline-block;width:20px;text-align:center;}
    	.body_wrap .con_box_wrap .con_right_box .tmpl_list li label{display:inline-block;width:100px;}
    	.body_wrap .con_box_wrap .con_right_box .tmpl_list li label img{width:100%;}
    	
    	.body_wrap .con_box_wrap .con_container{position:absolute;top:0;right:150px;bottom:0;left:150px;overflow:auto;}
    	.body_wrap .con_box_wrap .con_container .tab_wrap{text-align:center;height:49px;line-height:49px;border-bottom:1px solid #aaaaaa;background:#eeeeee;}
    	
    	/**************************************************
		   CSS
		**************************************************/
    </style>
    <script type="text/javascript">
    	$(document).ready(function(){
    		var posTarget = $('html'),
    			topBox = $('.top_box_wrap').height(),
    		    posW = posTarget.width(), 
    		    posH = posTarget.height(),
    		    conH = posH - topBox;
		    $('.con_box_wrap').height(conH-1);
			$('.btn_list').height(conH-51);
			$('.tmpl_list').height(conH-51);
			
		    $(window).resize(function() {
		    	var posTarget = $('html'),
    			topBox = $('.top_box_wrap').height(),
    		    posW = posTarget.width(), 
    		    posH = posTarget.height(),
    		    conH = posH - topBox;
				$('.con_box_wrap').height(conH-1);
				$('.btn_list').height(conH-51);
				$('.tmpl_list').height(conH-51);	
			});  
		});

    	function clickclick() {
    		alert('1234');
    	}
    	
    	function fnResult() {
    		var editor = DEXT5.getEditor("test1");
    		var result = DEXT5.getBodyValue("test");
    		
    		var result1 = editor.getBodyValue();
    		
    		alert(result);
    		alert(result1);
    	}
    	
    </script>
    <script type="text/javascript" src="js/dext5editor/js/dext5editor.js"></script>
</head>

<body>
		<div class="body_wrap">
		<!-- top box -->
		<div class="top_box_wrap"><%=BizboxAMessage.getMessage("TX000016082","필수항목선택영역")%></div>
		
		<!-- contents box -->
		<div class="con_box_wrap">
			<!-- Left -->
			<div class="con_left_box">
				<h3><%=BizboxAMessage.getMessage("TX000005978","항목선택")%></h3>
				<ul class="btn_list">
					<li><a href="#n" title=""><%=BizboxAMessage.getMessage("TX000000663","문서번호")%></a></li>
					<li><a href="#n" title=""><%=BizboxAMessage.getMessage("TX000000494","기안일")%></a></li>
					<li><a href="#n" title=""><%=BizboxAMessage.getMessage("TX000000068","부서명")%></a></li>
					<li><a href="#n" title=""><%=BizboxAMessage.getMessage("TX000000499","기안자")%></a></li>
					<li><a href="#n" title=""><%=BizboxAMessage.getMessage("TX000004219","결재라인")%></a></li>
					<li><a href="#n" title=""><%=BizboxAMessage.getMessage("TX000001773","수신처")%></a></li>
					<li><a href="#n" title=""><%=BizboxAMessage.getMessage("TX000000421","수신참조")%></a></li>
					<li><a href="#n" title=""><%=BizboxAMessage.getMessage("TX000000420","시행자")%></a></li>
					<li><a href="#n" title=""><%=BizboxAMessage.getMessage("TX000000503","시행일자")%></a></li>
					<li><a href="#n" title=""><%=BizboxAMessage.getMessage("TX000000493","제목")%></a></li>
					<li><a href="#n" title=""><%=BizboxAMessage.getMessage("TX000000145","내용")%></a></li>
					<li><a href="#n" title=""><%=BizboxAMessage.getMessage("TX000007127","종결일자")%></a></li>
					<li><a href="#n" title=""><%=BizboxAMessage.getMessage("TX000016139","전자결재항목")%></a></li>
					<li><a href="#n" title=""><%=BizboxAMessage.getMessage("TX000000522","참조문서")%></a></li>
					<li><a href="#n" title=""><%=BizboxAMessage.getMessage("TX000016176","연동HTML")%></a></li>
					<li><a href="#n" title=""><%=BizboxAMessage.getMessage("TX000016100","템플릿")%>01</a></li>
					<li><a href="#n" title=""><%=BizboxAMessage.getMessage("TX000016100","템플릿")%>02</a></li>
					<li><a href="#n" title=""><%=BizboxAMessage.getMessage("TX000016100","템플릿")%>03</a></li>
					<li><a href="#n" title=""><%=BizboxAMessage.getMessage("TX000016100","템플릿")%>04</a></li>
					<li><a href="#n" title=""><%=BizboxAMessage.getMessage("TX000016100","템플릿")%>05</a></li>
					<li><a href="#n" title=""><%=BizboxAMessage.getMessage("TX000016100","템플릿")%>06</a></li>
					<li><a href="#n" title=""><%=BizboxAMessage.getMessage("TX000016100","템플릿")%>07</a></li>
					<li><a href="#n" title=""><%=BizboxAMessage.getMessage("TX000016100","템플릿")%>08</a></li>
					<li><a href="#n" title=""><%=BizboxAMessage.getMessage("TX000016100","템플릿")%>09</a></li>
					<li><a href="#n" title=""><%=BizboxAMessage.getMessage("TX000016100","템플릿")%>10</a></li>
					<li><a href="#n" title=""><%=BizboxAMessage.getMessage("TX000016100","템플릿")%>11</a></li>
					<li><a href="#n" title=""><%=BizboxAMessage.getMessage("TX000016100","템플릿")%>12</a></li>
					<li><a href="#n" title=""><%=BizboxAMessage.getMessage("TX000016100","템플릿")%>13</a></li>
					<li><a href="#n" title=""><%=BizboxAMessage.getMessage("TX000016100","템플릿")%>14</a></li>
					<li><a href="#n" title=""><%=BizboxAMessage.getMessage("TX000016100","템플릿")%>15</a></li>
				</ul>
			</div>
			
 			<!-- Right -->
			<div class="con_right_box">
				<h3><%=BizboxAMessage.getMessage("TX000016100","템플릿")%></h3>
				<ul class="tmpl_list">
					<li>
						<span class="sel"><input type="radio" name="tmpl" id="tmpl_type1"/></span>
						<label for="tmpl_type1"><img src="http://placehold.it/100?text=<%=BizboxAMessage.getMessage("TX000016100","템플릿")%>" alt=""></label>
					</li>
					<li>
						<span class="sel"><input type="radio" name="tmpl" id="tmpl_type2"/></span>
						<label for="tmpl_type2"><img src="http://placehold.it/100?text=<%=BizboxAMessage.getMessage("TX000016100","템플릿")%>" alt=""></label>
					</li>
					<li>
						<span class="sel"><input type="radio" name="tmpl" id="tmpl_type3"/></span>
						<label for="tmpl_type3"><img src="http://placehold.it/100?text=<%=BizboxAMessage.getMessage("TX000016100","템플릿")%>" alt=""></label>
					</li>
					<li>
						<span class="sel"><input type="radio" name="tmpl" id="tmpl_type4"/></span>
						<label for="tmpl_type4"><img src="http://placehold.it/100?text=<%=BizboxAMessage.getMessage("TX000016100","템플릿")%>" alt=""></label>
					</li>
					<li>
						<span class="sel"><input type="radio" name="tmpl" id="tmpl_type5"/></span>
						<label for="tmpl_type5"><img src="http://placehold.it/100?text=<%=BizboxAMessage.getMessage("TX000016100","템플릿")%>" alt=""></label>
					</li>
					<li>
						<span class="sel"><input type="radio" name="tmpl" id="tmpl_type6"/></span>
						<label for="tmpl_type6"><img src="http://placehold.it/100?text=<%=BizboxAMessage.getMessage("TX000016100","템플릿")%>" alt=""></label>
					</li>
					<li>
						<span class="sel"><input type="radio" name="tmpl" id="tmpl_type7"/></span>
						<label for="tmpl_type7"><img src="http://placehold.it/100?text=<%=BizboxAMessage.getMessage("TX000016100","템플릿")%>" alt=""></label>
					</li>
					<li>
						<span class="sel"><input type="radio" name="tmpl" id="tmpl_type8"/></span>
						<label for="tmpl_type8"><img src="http://placehold.it/100?text=<%=BizboxAMessage.getMessage("TX000016100","템플릿")%>" alt=""></label>
					</li>
					<li>
						<span class="sel"><input type="radio" name="tmpl" id="tmpl_type9"/></span>
						<label for="tmpl_type9"><img src="http://placehold.it/100?text=<%=BizboxAMessage.getMessage("TX000016100","템플릿")%>" alt=""></label>
					</li>
					<li>
						<span class="sel"><input type="radio" name="tmpl" id="tmpl_type10"/></span>
						<label for="tmpl_type10"><img src="http://placehold.it/100?text=<%=BizboxAMessage.getMessage("TX000016100","템플릿")%>" alt=""></label>
					</li>
				</ul>
			</div>
			
			<!-- Container -->
			<div class="con_container">
				<div id="" class="tab_wrap"><%=BizboxAMessage.getMessage("TX000010571","탭영역")%>
					<input type="button" onclick="fnResult()" value="<%=BizboxAMessage.getMessage("TX000001748","결과")%>"/>
				</div>
				<!-- <div id=""> -->
					
				<!-- </div> --> 
				 
				<script type="text/javascript">
					new Dext5editor("test");
				</script>	
				
				
				
				<script type="text/javascript">
					new Dext5editor("test1");
				</script>	
				
			</div>
		</div>
	</div>
	
<!-- 	양식 에디터 페이지 입니다.
	<div style="width:900px; hegith:550px">
		<script type="text/javascript">
			var editor = new Dext5editor("test");
		</script>	
	</div> -->

</body>
</html>

