<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="validator" uri="http://www.springmodules.org/tags/commons-validator" %>
<%@page import="main.web.BizboxAMessage"%>
<style>

    .portal_main_wrap{overflow:hidden;position:relative;width:960px;min-height:646px;margin:15px auto 0 auto;}
    .portal_con_left{float:left;width:184px;height:100%;}
    .portal_con_center{float:left;width:568px;margin:0 8px;}
    .portal_mb8 {margin-bottom:8px !important;}
    .portal_con_center .portal_cc_top{float:left;width:568px;}
    .portal_con_center .portal_cc_left{float:left;width:280px;}
    .portal_con_center .portal_cc_right{float:left;width:280px;margin-left:8px !important;}
    .portal_con_right{float:left;width:184px;height:100%;}
    .portal_main_quick{overflow:hidden;position:relative;width:954px; background:#fff;}
    .portal_portlet{position: relative;background-color:black;cursor: move;border:1px solid #000;margin-bottom: 8px !important;}
    .portal_portlet .portlet_img{opacity: 0.8;}
    .portal_portlet .portlet_img_not_use{opacity: 0.2;}
    .portal_portlet_fix{position: relative;background-color:black;border:1px solid #000;margin-bottom: 8px !important;}
    .portal_portlet_fix .portlet_img{opacity: 0.8;}
    .portal_portlet_fix .portlet_img_not_use{opacity: 0.2;}
    .portal_portletadd{cursor: pointer;width:100%;}
      
    .sortable{min-height:5px;}
    .portlet_btn_del{z-index:1;position: absolute;right:0px;}
    .portlet_btn_del img{float:right;cursor:pointer;}
    .portlet_btn_set{z-index:1;position: absolute;right:10px;bottom:10px;}
    .portlet_btn_set img{float:right;cursor:pointer;}    
    .portlet_btn_set span{float:right;font-size: 12px;font-weight: bold;color: #ffffff;line-height: 22px;padding-right: 8px;}
    .hide{display:none;}

</style>

<script>

// 로딩이미지
$(document).bind("ajaxStart", function () {
	kendo.ui.progress($(".pop_con"), true);
}).bind("ajaxStop", function () {
	kendo.ui.progress($(".pop_con"), false);
});	

function placeholder(e) {
    return $("<div class='portal_portlet' style='background-color:black;opacity:0.2;width:" + $(e).width() + "px;height:" + $(e).height() + "px;''></div>");
}

$(document).ready(function() {
	
    $("#sortable-listA,#sortable-listD").kendoSortable({
        connectWith: "#sortable-listA,#sortable-listD",
        placeholder: placeholder
    });
    
    $("#sortable-listB,#sortable-listC").kendoSortable({
        connectWith: "#sortable-listB,#sortable-listC",
        placeholder: placeholder
    });
    
    $("#sortable-listE").kendoSortable({
        connectWith: "#sortable-listE",
        placeholder: placeholder
    });
    
    $( ".portal_portletadd" ).change(function(e) {
    	portletChangeSet(e);
    });    
     
	portletAddInit("");
	
	refreshEvent();
	
	
	window.resizeBy(($(document).width() - $(window).width()) ,($(document).height() - $(window).height()));
	
});

function refreshEvent(){
	
	$(".portlet_btn_set img, .portlet_btn_del img").off("click");
	
	$(".portlet_btn_set img, .portlet_btn_del img").click(function(){
		portletSetPop(this);
	});
}

function portletAddInit(position_tp){
	
	if(position_tp == "top"){
		position_tp = "cn";
	}
	
	var find_param = ".portal_portletadd";
	
	if(position_tp!=""){
		find_param += "[position_tp=" + position_tp + "]";
	}
	
    $.each($(find_param), function (i, t) {
    	
    	$(t).html("");
    	portletAddSet(t);
    });
	
}

function portletSetPop(obj){
	
	var portlet_obj = $(obj).parent().parent();
	var portlet_tp = $(portlet_obj).attr("portlet_tp");
	var portlet_key = $(portlet_obj).attr("portlet_key");
	
	switch($(obj).attr("fn_tp")){
		case "delete" : portletDelete(portlet_obj, portlet_tp, portlet_key);break;
		case "setting" : portletSetting(portlet_obj, portlet_tp, portlet_key);break;
	}
}

function portletChangeSet(e){
	
	//cust_add_yn|position_tp|portlet_tp
	var portlet_info = $(e.target).val().split('|');
	var target = $(e.target).attr("target");
	
	if(portlet_info[1] == "top"){
		target = "sortable-listE";
	}
	
	//키생성
	var portlet_key = 1;
	
    $.each($(".portal_main_wrap").find("div[portlet_tp=" + portlet_info[2] + "]"), function (i, t) {
    	  var value = parseFloat($(t).attr("portlet_key"));
    	  portlet_key = (value >= portlet_key) ? (value + 1) : portlet_key;
    });

    $("#" + target).append($("#portlet_model div[portlet_tp=" + portlet_info[2] + "]").attr("portlet_key",portlet_key).clone());	
	
	if(portlet_info[0] != "Y"){
		portletAddInit(portlet_info[1]);
	}
	
	$( ".portal_portletadd" ).val("")
	
	refreshEvent();
}

function portletAddSet(obj){
	
	var position_tp = $(obj).attr("position_tp");
	var target = $(obj).attr("target");
	var find_param = "";
	
	if(position_tp == "cn"){
		position_tp = "cn_top";
	}
	
	$.each(position_tp.split('_'), function(i,t){
		if(i != 0){
			find_param += ","
		}
		find_param += "div[position_tp="+t+"]";
	});
	
	$(obj).append("<option value='' disabled selected hidden><%=BizboxAMessage.getMessage("TX000016089","포틀릿 추가")%></option>");
	
    $.each($("#portlet_model").find(find_param), function (i, t) {
    	if($(t).attr("cust_add_yn") == "Y" || $(".portal_main_wrap").find("div[portlet_tp=" + $(t).attr("portlet_tp") + "]").length == 0){
    		$(obj).append("<option value='" + $(t).attr("cust_add_yn") + "|" + $(t).attr("position_tp") + "|" + $(t).attr("portlet_tp") + "'>" + $(t).find("[name=portlet_nm]").html() + "</option>");
    	}
    	
    });
}

function portletDelete(obj, portlet_tp, portlet_key){
	
	if(!confirm("<%=BizboxAMessage.getMessage("TX000001981","삭제 하시겠습니까?")%>")){
		return;
	}
	
	//항목삭제
	$(obj).remove();
	
	//추가리스트 갱신
	portletAddInit(portlet_tp.split('_')[0]);
}

function fnSavePortal(){
	
	if($(".portal_con_left .portal_portlet").length == 0 || $(".portal_con_center .portal_portlet").length == 0 || $(".portal_con_right .portal_portlet").length == 0){
		alert("<%=BizboxAMessage.getMessage("TX000010584","각 위치항목에 한 개 이상의 포틀릿이 배치되어야 합니다")%>");
		return;
	}		

	if(confirm("<%=BizboxAMessage.getMessage("TX000004920","저장하시겠습니까?")%>")){

 		var tblParam = {};
 		
 		tblParam.portalId = "${param.portalId}";
 		tblParam.portletList = JSON.stringify(fnGetPortletList());
 		
 		$.ajax({
        	type:"post",
    		url:'portletInsert.do',
    		datatype:"json",
            data: tblParam ,
    		success: function (result) {
	    			if(result.value == "1"){
	    				fnclose();
	    			}else{
	    				alert("<%=BizboxAMessage.getMessage("TX000002439","권한이 없습니다.")%>");
	    			}
    		    } ,
		    error: function (result) { 
		    		alert("<%=BizboxAMessage.getMessage("TX000002003","작업이 실패했습니다.")%>"); 
		    		}
    	});
	}			
}

function fnGetPortletList(){
	
	var PortletList = new Array();
	
    $.each($(".portal_main_wrap .portal_portlet, .portal_portlet_fix"), function (i, t) {
    	
    	var portlet_info = {};
    	
    	portlet_info.portal_id = "${param.portalId}";
    	portlet_info.portlet_tp = $(t).attr("portlet_tp");
    	portlet_info.portlet_key = $(t).attr("portlet_key");
    	portlet_info.position = $(t).parent().attr("position");
    	portlet_info.sort = i+1;
    	
    	PortletList.push(portlet_info);
    });
	
	return PortletList;
}


function fnclose(){
	self.close();
}	

function portletSetting(obj, portletTp, portletKey){
	
	var url = "";
	
	if(portletTp == "fo_bn"){
		url = "portletFootSetPop.do?portalId=${param.portalId}&portletTp=" + portletTp + "&portletKey=" + portletKey;
		openWindow2(url, "portletSetPop", 602, 602, 1, 1);
	}
	else{
		url = "portletSetPop.do?portalId=${param.portalId}&portletTp=" + portletTp + "&portletKey=" + portletKey;
		openWindow2(url, "portletSetPop", 602, 602, 1, 1);
	}
}

</script>

<div class="pop_wrap resources_reservation_wrap" style="width: 986px;" >

		<div class="pop_head">
			<h1><%=BizboxAMessage.getMessage("TX000006335","포털설정")%></h1>
		</div>
		<!-- //pop_head -->

		<div class="pop_con">
			
			<p class="tit_p"><%=BizboxAMessage.getMessage("TX000016087","포틀릿설정")%></p>
			

		<div class="portal_main_wrap">
		
			<!-- 1단 -->
			<div class="portal_con_left">		
				<select class="portal_portletadd" position_tp="lr" target="sortable-listA"></select>	
				<div style="height: 10px"></div>
				<div position="1" id="sortable-listA" class="sortable">
				
					<c:forEach var="items" items="${portletSetList}">
						<c:if test="${items.position == '1'}">
					
							<div portlet_tp="${items.portletTp}" portlet_key="${items.portletKey}" class="portal_portlet">
							
								<div class="portlet_btn_del">
			  						<img fn_tp="delete" src="/gw/Images/portal/close.png" alt="" />
								</div>
								
								
								<div class="portlet_btn_set">
									<c:if test="${items.setBtnYn == 'Y'}">
			  							<img fn_tp="setting" src="/gw/Images/portal/setting.png" alt="" />
			  						</c:if>
			  						
			  						<span name="not_use_str" <c:if test="${items.useYn == 'Y'}">class="hide"</c:if>>(<%=BizboxAMessage.getMessage("TX000001243","미사용")%>)</span>
			  						<span name="portlet_nm">${items.portletNm}</span>
								</div>
		
								<img class="${items.portletImgCss}" src="${items.imgUrl}" width="${items.widthSet}" height="${items.heightSet}">
							</div>
						</c:if>
					</c:forEach>
									
				</div>
			</div>
			
			<!-- 중앙 -->
			<div class="portal_con_center portal_mb8">			
				<select class="portal_portletadd" position_tp="cn" target="sortable-listB" style="width: 279px"></select>&nbsp;	
				<select class="portal_portletadd" position_tp="cn" target="sortable-listC" style="width: 279px"></select>
				<div style="height: 10px"></div>
				<!-- 중앙배너 -->
				<div position="5" id="sortable-listE" class="portal_cc_top">
				
					<c:forEach var="items" items="${portletSetList}">
						<c:if test="${items.position == '5'}">
					
							<div portlet_tp="${items.portletTp}" portlet_key="${items.portletKey}" class="portal_portlet">
							
								<div class="portlet_btn_del">
			  						<img fn_tp="delete" src="/gw/Images/portal/close.png" alt="" />
								</div>
								
								
								<div class="portlet_btn_set">
									<c:if test="${items.setBtnYn == 'Y'}">
			  							<img fn_tp="setting" src="/gw/Images/portal/setting.png" alt="" />
			  						</c:if>

									<span name="not_use_str" <c:if test="${items.useYn == 'Y'}">class="hide"</c:if>>(<%=BizboxAMessage.getMessage("TX000001243","미사용")%>)</span>
			  						<span name="portlet_nm">${items.portletNm}</span>
								</div>
		
								<img class="${items.portletImgCss}" src="${items.imgUrl}" width="${items.widthSet}" height="${items.heightSet}">
							</div>
						</c:if>
					</c:forEach>
				
				</div>
				
				<div class="portal_cc_left">
					
					<div position="2" id="sortable-listB" class="sortable">
					
						<c:forEach var="items" items="${portletSetList}">
							<c:if test="${items.position == '2'}">
						
								<div portlet_tp="${items.portletTp}" portlet_key="${items.portletKey}" class="portal_portlet">
								
									<div class="portlet_btn_del">
				  						<img fn_tp="delete" src="/gw/Images/portal/close.png" alt="" />
									</div>
									
									
									<div class="portlet_btn_set">
										<c:if test="${items.setBtnYn == 'Y'}">
				  							<img fn_tp="setting" src="/gw/Images/portal/setting.png" alt="" />
				  						</c:if>
				  						
										<span name="not_use_str" <c:if test="${items.useYn == 'Y'}">class="hide"</c:if>>(<%=BizboxAMessage.getMessage("TX000001243","미사용")%>)</span>				  						
				  						<span name="portlet_nm">${items.portletNm}</span>
									</div>
			
									<img class="${items.portletImgCss}" src="${items.imgUrl}" width="${items.widthSet}" height="${items.heightSet}">
								</div>
							</c:if>
						</c:forEach>					
					</div>
				</div>
				
				
				<div class="portal_cc_right">
					
					<div position="3" id="sortable-listC" class="sortable">
					
						<c:forEach var="items" items="${portletSetList}">
							<c:if test="${items.position == '3'}">
						
								<div portlet_tp="${items.portletTp}" portlet_key="${items.portletKey}" class="portal_portlet">
								
									<div class="portlet_btn_del">
				  						<img fn_tp="delete" src="/gw/Images/portal/close.png" alt="" />
									</div>
									
									
									<div class="portlet_btn_set">
										<c:if test="${items.setBtnYn == 'Y'}">
				  							<img fn_tp="setting" src="/gw/Images/portal/setting.png" alt="" />
				  						</c:if>
				  						
				  						<span name="not_use_str" <c:if test="${items.useYn == 'Y'}">class="hide"</c:if>>(<%=BizboxAMessage.getMessage("TX000001243","미사용")%>)</span>
				  						<span name="portlet_nm">${items.portletNm}</span>
									</div>
			
									<img class="${items.portletImgCss}" src="${items.imgUrl}" width="${items.widthSet}" height="${items.heightSet}">
								</div>
							</c:if>
						</c:forEach>
					</div>
				</div>				
			</div>
	
			<!-- 4단 -->
			<div class="portal_con_right">
				<select class="portal_portletadd" position_tp="lr" target="sortable-listD"></select>
				<div style="height: 10px"></div>
				<div position="4" id="sortable-listD" class="sortable">
				
					<c:forEach var="items" items="${portletSetList}">
						<c:if test="${items.position == '4'}">
					
							<div portlet_tp="${items.portletTp}" portlet_key="${items.portletKey}" class="portal_portlet">
							
								<div class="portlet_btn_del">
			  						<img fn_tp="delete" src="/gw/Images/portal/close.png" alt="" />
								</div>
								
								
								<div class="portlet_btn_set">
									<c:if test="${items.setBtnYn == 'Y'}">
			  							<img fn_tp="setting" src="/gw/Images/portal/setting.png" alt="" />
			  						</c:if>
			  						
			  						<span name="not_use_str" <c:if test="${items.useYn == 'Y'}">class="hide"</c:if>>(<%=BizboxAMessage.getMessage("TX000001243","미사용")%>)</span>
			  						<span name="portlet_nm">${items.portletNm}</span>
								</div>
								
								<img class="${items.portletImgCss}" src="${items.imgUrl}" width="${items.widthSet}" height="${items.heightSet}">
							</div>
						</c:if>
					</c:forEach>
				</div>
			</div>
			
			<div position="6" class="portal_main_quick">
			
				<c:forEach var="items" items="${portletSetList}">
					<c:if test="${items.portletTp == 'qu_bn'}">
						<div portlet_tp="${items.portletTp}" portlet_key="${items.portletKey}" class="portal_portlet_fix">
							
							<div class="portlet_btn_set">
	  							<img fn_tp="setting" src="/gw/Images/portal/setting.png" alt="" />
	  							<span name="not_use_str" <c:if test="${items.useYn == 'Y'}">class="hide"</c:if>>(<%=BizboxAMessage.getMessage("TX000001243","미사용")%>)</span>
		  						<span name="portlet_nm">${items.portletNm}</span>
							</div>
							
							<img class="${items.portletImgCss}" src="/gw/Images/portal/qu_bn.png" width="952" height="88">
						</div>
					</c:if>
				</c:forEach>
				
				<c:if test="${fn:length(portletSetList) == 0}">
					<div portlet_tp="qu_bn" portlet_key="1" class="portal_portlet_fix">
						<div class="portlet_btn_set">
  							<img fn_tp="setting" src="/gw/Images/portal/setting.png" alt="" />
  							<span name="not_use_str" class="hide">(<%=BizboxAMessage.getMessage("TX000001243","미사용")%>)</span>
	  						<span name="portlet_nm"><%=BizboxAMessage.getMessage("TX000016104","퀵링크")%></span>
						</div>
						<img class="portlet_img" src="/gw/Images/portal/qu_bn.png" width="952" height="88">
					</div>				
				</c:if>
			</div>
	</div>
		</div>
		<!-- //pop_con -->
		<div class="pop_foot" style="z-index: 999;">
			<div class="btn_cen pt12">
				<input type="button" value="<%=BizboxAMessage.getMessage("TX000001256","저장")%>" onclick="fnSavePortal();" /> 
				<input type="button" class="gray_btn" value="<%=BizboxAMessage.getMessage("TX000002947","취소")%>" onclick="fnclose();" />
			</div>
		</div>
	</div>            

	<div id="portlet_model" style="display:none;" > 
		<c:forEach var="items" items="${portletList}">
			<div position_tp = "${items.positionTp}" portlet_tp="${items.portletTp}" portlet_key="0" cust_add_yn="${items.custAddYn}" class="portal_portlet">
				<div class="portlet_btn_del">
					<img fn_tp="delete" src="/gw/Images/portal/close.png" alt="" />
				</div>
				
				<div class="portlet_btn_set">
					<c:if test="${items.setBtnYn == 'Y'}">
						<img fn_tp="setting" src="/gw/Images/portal/setting.png" alt="" />
					</c:if>
					
					<span name="not_use_str" class="hide">(<%=BizboxAMessage.getMessage("TX000001243","미사용")%>)</span>
					<span name="portlet_nm">${items.portletNm}</span>
				</div>
				<img class="portlet_img" src="/gw/Images/portal/${items.portletTp}.png" width="${items.widthSet}" height="${items.heightSet}">
			</div>		
		</c:forEach>
	</div>
