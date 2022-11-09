var write = {};

dialogViewSet = function(b){
	NeosUtil.dialogStyleSet("dialog-Background");
	if(b){
		$("#dialog-Background").show();
		$("#div_work_form").css("zIndex", "899999").show();
	}else{
		$("#dialog-Background").hide();
		$("#div_work_form").hide(); 
	} 
		
};

/* 통합검색 */
function fn_egov_list_search_unified(currentPage){
    $("#currentPage").attr("value", currentPage);
    
    $("#seform").attr("action","/gw/neos/search/unifiedSearchList.do");
    $("#seform").attr("target", "_self");
    $("#seform").submit();
}

/* 전자결재 */
function fn_egov_list_search_epayment(currentPage){
    $("#currentPage").attr("value", currentPage);
    
    $("#seform").attr("action","/gw/neos/search/epaymentList.do");
    $("#seform").attr("target", "_self");
    $("#seform").submit();
}

/* 게시판 */
function fn_egov_list_search_board(currentPage){
    $("#currentPage").attr("value", currentPage);
    
    $("#seform").attr("action","/gw/neos/search/boardList.do");
    $("#seform").attr("target", "_self");
    $("#seform").submit();
}

/* mail */
function fn_egov_list_search_mail(currentPage){
    $("#currentPage").attr("value", currentPage);
    
    $("#seform").attr("action","/gw/neos/search/mailList.do");
    $("#seform").attr("target", "_self");
    $("#seform").submit();
}
