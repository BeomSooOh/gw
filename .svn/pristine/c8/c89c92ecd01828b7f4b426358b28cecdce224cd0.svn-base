/**************************************************
   menual.js
   
   [수정내역]
   20180105 - 최초생성
   
   
  <script language="javascript" src="/gw/js/menual.js"></script>
  
**************************************************/

window.addEventListener('DOMContentLoaded', function(){
	
	getTopMenuPath();
	
	if(document.getElementsByClassName("btn_manual").length > 0){
		if((localStorage.getItem("manualUrl") == null || localStorage.getItem("manualUrl") != "") && window.location.search.indexOf("manualHide=Y") == -1){
			document.getElementsByClassName("btn_manual")[0].style.display="block";	
		}else{
			document.getElementsByClassName("btn_manual")[0].style.display="none";
		}
	}
});

function getTopMenuPath(){
	try {
		//if($(".sub_title_wrap .location_info #MenuPathBind").length > 0 && parent.getTopMenu != null){
		if($(".sub_title_wrap .location_info #menuHistory").length == 0 && parent.getTopMenu != null){
			var topInfo = parent.getTopMenu();
			var hstHtml = '<li><a href="#n"><img src="/gw/Images/ico/ico_home01.png" alt="">&nbsp;</a></li>';
			hstHtml += '<li><a href="#n">'+topInfo.name+'&nbsp;</a></li>';  
			var leftList = parent.getLeftMenuList();
			if (leftList != null && leftList.length > 0) {
				for(var i = leftList.length-1; i >= 0; i--) {
					if(i == 0){
						hstHtml += '<li class="on"><a href="#n">'+leftList[i].name+'&nbsp;</a></li>';
					}else{
						hstHtml += '<li><a href="#n">'+leftList[i].name+'&nbsp;</a></li>';
					}
				}
				$(".title_div").html('<h4>'+leftList[0].name+'&nbsp;</h4>');
			} else {
				$(".title_div").html('<h4>'+topInfo.name+'&nbsp;</h4>');
			}
			//$(".sub_title_wrap .location_info #MenuPathBind li").remove();
			//$(".sub_title_wrap .location_info #MenuPathBind").html(hstHtml);
			
			$(".sub_title_wrap .location_info ul li").remove();
			$(".sub_title_wrap .location_info ul").html(hstHtml);			
			
		}
		
	} catch (exception) {
	console.log(exception);//오류 상황 대응 부재
	}


}

function onlineManualPop(type, name){
	
	if(type == null){

		name = window.location.pathname;
		name = name.replace("/?","?").replace(/\//gi,"_").replace(/\./gi,"_");

		//URL중복메뉴 예외처리
		var extName = "";
		var extParam = window.location.search;
		
		if(name.indexOf("moduleAlarm_do") > 0){
			if(extParam.indexOf("PROJECT") > 0){
				extName = "_project";
			}else if(extParam.indexOf("board") > 0){
				extName = "_board";
			}else if(extParam.indexOf("EAPPROVAL") > 0){
				extName = "_eapproval";
			}else if(extParam.indexOf("SCHEDULE") > 0){
				extName = "_schedule";
			}
		}else if(name.indexOf("managerReservation") > 0 && extParam.indexOf("302030000") > 0){
			extName = "_admin";
		}else if(name.indexOf("certRequestUser_do") > 0 && extParam.indexOf("issue") > 0){
			extName = "_issue";
		}else if(name.indexOf("absenceManageView_do") > 0 && extParam.indexOf("106010000") > 0){
			extName = "_user";
		}else if(name.indexOf("manageBoardOption_do") > 0 && extParam.indexOf("info_target=D") > 0){
			extName = "_doc";
		}else if(name.indexOf("resource_calendar") > 0 && extParam.indexOf("1912000015") > 0){
			extName = "_admin";
		}
		
		if(name.length > 0){
			if(name.substr(0,1) == "_"){
				name = name.substr(1);
			}
			
			name = name.split("?")[0] + extName;
						
		}else{
			alert("URL 주소가 입력되지 않았습니다.");
			return;
		}
		
		type = "reference";
		
	}else if(type != "lnb" && type != "lnb_adm" && type != "main" && type != "main_adm"){
		name = type;
		type = "reference";
	}
	
	var manualUrl = "/gw/manual.do?type=" + type + "&name=" + (name == null ? "" : name);
	var width = "1300";
	var height = "900";
	var windowX = Math.ceil( (window.screen.width  - width) / 2 );
	var windowY = Math.ceil( (window.screen.height - height) / 2 );
	var pop = window.open(manualUrl, "Menual", "width=" + width + ", height=" + height + ", top="+ windowY +", left="+ windowX +", scrollbars=1, resizable=1");
	try {pop.focus(); } catch(e){
	console.log(e);//오류 상황 대응 부재
	}
	return pop;
}