
$(document).ready(function(){
	
	window_resize();
	
	//browser resize
	$(window).resize(function(){
		window_resize();
	});

});	

function window_resize(){	
	//alert('window_resize: ');

	
	var tNb=82;
	//var win_w = $(top.document).width();
	var win_w = $(window).width();
	
	var left_menu_w = 0;
	var lnbLeft =$(top.document).find("#lnb_left").css("display");
	if(lnbLeft=="block"){
		left_menu_w = 210;//210;  
	}

	//  스크롤바 영역에 의한 ui는 - 10 을 늘려서 해결해야함....내거에선 꺠져...
	$(top.document).find("#_content").css("height", $(window).height()-23);// y scroll   
	
	
	// init 
	//ie6 min-width
	if(win_w<=1013) {
		$("#head").css("width",(1013)+"px");
		$("#foot").css("width",(1013)+"px");		
		$("#m_con").css("width",(1013)+"px");
	}else if(win_w>1013){
		$("#head").css("width",(win_w)+"px");	// header
		$("#foot").css("width",(win_w)+"px");	// footer		
		$("#m_con").css("width",(win_w)+"px");
	}


	var lnb = $(top.document).find("#lnb_area"); 
	var mn_bot = $(top.document).find("#menuBot");
	var mn_top = $(top.document).find("#menuTop");
	// layout width-height
	lnb.height($(window).height() - tNb); // lnb area height
	$("li.left_top_fir",mn_top).height($(window).height()-mn_bot.height()-tNb); //seleted lnb height
	$("li.left_top_fir .left_tree",mn_top).height($(window).height()-mn_bot.height()-tNb-32);
	

	//mn_bot.height($(window).height()-mn_bot.height()-tNb); //seleted lnb height
	//mn_bot.height($(window).height()-mn_bot.height()-tNb-32);

	//mn_bot.css("padding-top",($(window).height()-mn_bot.height()-tNb)+"px");
	
	
}