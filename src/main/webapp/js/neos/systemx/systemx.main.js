var main = {};


$(function(){
	
});

main.userLogout = function() {
	localStorage.setItem("empAttCheckDate", null);	
	location.href = "uat/uia/actionLogout.do";
};

//기안작성 팝업 eaType => eap :  영리, ea : 비영리
main.fnEaFormPop = function(eaType) {

	// 디폴트 eap
	if(!eaType){
		eaType = "eap";
	}
	
	var url = "/" + eaType + "/FormListPop.do";
	
	openWindow2(url,  "formWindow", "400", "500", "yes", "no" );	
	
};