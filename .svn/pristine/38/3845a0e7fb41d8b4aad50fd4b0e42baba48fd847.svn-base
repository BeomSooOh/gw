
$(document).ready(function(){
	
	iframe_resize();
	
	//browser resize
	$(window).resize(function(){
		iframe_resize();
	});

});	


function iframe_resize(){	
	//alert('iframe_resize: ');

	
	var left_menu_w = 0;
	var lnbLeft =$(top.document).find("#lnb_left").css("display");

	if(lnbLeft=="block"){
		left_menu_w = 210;//210;  
	}
	
	var width_w = $(top.document).width();
	//alert('width_w: '+width_w);
	
	$("#_content").css("height", $(window).height());// y scroll
	//$(top.document).find("#_content").css("height", $(window).height());// y scroll
	
	$(".cont_area").width(width_w-(left_menu_w+33));
	$(".cont_area").height($(window).height()-114);
	$(".cont_scroll_inner").height( $('.cont_pad').height()); 
	
	

	/*
	var lnb = $(top.document).find("#lnb_area"); 
	var mn_bot = $(top.document).find("#menuBot");
	var mn_top = $(top.document).find("#menuTop");
	// layout width-height
	lnb.height($(window).height() - tNb); // lnb area height
	$("li.left_top_fir",mn_top).height($(window).height()-mn_bot.height()-tNb); //seleted lnb height
	$("li.left_top_fir .left_tree",mn_top).height($(window).height()-mn_bot.height()-tNb-32);	
	*/
}