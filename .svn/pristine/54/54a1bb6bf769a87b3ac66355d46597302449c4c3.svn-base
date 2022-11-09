
////////////////// document ready script //////////////////////////

$(function(){
	$(document).ready(function(){
	    /*필수요소*/
	    conSizeInit(); //오른쪽 컨텐츠영역 사이즈
	    gnbScroll();   //gnb영역 스크롤 세팅
	    lnbScroll();   //lnb영역 스크롤 세팅
	    freebScroll(); //공통 스크롤함수
	});
	$(window).resize(function() {
	    /*필수요소*/
	    conSizeInit(); //오른쪽 컨텐츠영역 사이즈
        gnbScroll();   //gnb영역 스크롤 세팅
        lnbScroll();   //lnb영역 스크롤 세팅
        freebScroll(); //공통 스크롤함수
	});
	
	//왼쪽 컨텐츠 리사이즈 이벤트
    $(".freeb_left_contents").resizable({
        distance: 0,
        minWidth:230,
        maxWidth:400,
        handles: 'e',
        resize: function(e, ui) {
            var parent = ui.element.parent();
            var leftContentSize = ui.element.outerWidth();
            var rightContentSize = parent.width() - ui.element.outerWidth();
            var splitBar = 7;
            var gnbArea = 48;
            var move = "<div class="+"move_screen"+" style="+"position:absolute;top:0;left:0;right:0;bottom:0;background:transparent;"+"></div>"
                ui.element.width(leftContentSize);
                ui.element.find('.resizable_inner').width(leftContentSize-splitBar-gnbArea-1);
                divTwo = ui.element.next();
                divTwo.width(rightContentSize);
                if(!parent.find(".freeb_right_contents").children().hasClass("move_screen")){
                	parent.find(".freeb_right_contents").append(move);
                };
                
        },
        stop: function(e, ui) {
        	var parent = ui.element.parent();
            var leftContentSize = ui.element.outerWidth();
            var splitBar = 7;
            var gnbArea = 48;
                ui.element.width(leftContentSize);
                ui.element.find('.resizable_inner').width(leftContentSize-splitBar-gnbArea-1);
                
                parent.find(".freeb_right_contents .move_screen").remove();
        }
    });
    
    //왼쪽 컨텐츠 리사이즈바 버튼 
    $(".handle-bar").on("click",function(){
        var leftNow = $(".freeb_left_contents").width();
        
        if(leftNow > 55){
            $(".freeb_left_contents").width(55);
            $(".freeb_left_contents .resizable_inner").width(0);
            conSizeInit();
        }else if(leftNow <= 55){
            $(".freeb_left_contents").width(255);
            $(".freeb_left_contents .resizable_inner").width(199);
            conSizeInit();
        };
    });
    

   //gnb hover, click
   $(".gnb_list").hover(function(event){
        $freebLeftWid = $(".freeb_left_contents").outerWidth()-7;
        $parent = $(this).parent();
        
        if(event.type == "mouseenter" ){
            $parent.addClass("hover").width($freebLeftWid);
        }else{
            $parent.removeClass("hover").width(48);
        };
    });
    $(".gnb_menu").on("click",function(event){
        
        $parent = $(this).parent().parent().parent().parent();
        
        $parent.removeClass("hover").width(48);
        $(".gnb_menu").removeClass("active");
        $(this).addClass("active");
        
        var leftNow = $(".freeb_left_contents").width();
        
        if(leftNow <= 55){
            $(".freeb_left_contents").width(255);
            $(".freeb_left_contents .resizable_inner").width(199);
            conSizeInit();
        };
    });
    
    
    //oneframe gnb hover, click
    $(".freeb_oneframe_left_contents .gnb_list").hover(function(event){
    	$freeGnbWid = 255;
        $parent = $(this).parent();
        
        if(event.type == "mouseenter" ){
            $parent.addClass("hover").width($freeGnbWid);
        }else{
            $parent.removeClass("hover").width(48);
        };
    });
    $("freeb_oneframe_left_contents .gnb_menu").on("click",function(event){
        
        $parent = $(this).parent().parent().parent().parent();
        
        $parent.removeClass("hover").width(48);
        $(".gnb_menu").removeClass("active");
        $(this).addClass("active");
        
        var leftNow = $(".freeb_oneframe_left_contents").width();
        
        if(leftNow <= 55){
            $(".freeb_oneframe_left_contents").width(255);
            conSizeInit();
        };
    });
    
    
    /*시작 jstree 2뎁스**************************************************************/

    //2뎁스 컨트롤
    $(".lnb_2dep").on("click",function (e) {
        e.preventDefault();
        var This = $(this);

        // 다중메뉴 열기
        if (!This.hasClass("on")) {
            $(".non_sub").parent().removeClass("on");
            This.addClass("on");
            This.next(".lnb_2dep_in").stop().slideDown();
        }else {
            This.removeClass("on");
            This.next(".lnb_2dep_in").stop().slideUp();
        }; 
        
        // 자식요소 없을때
        if(This.find("span").hasClass("non_sub")){
            This.siblings(".lnb_2dep_in").stop().slideUp();
            This.siblings().removeClass("on");
            This.addClass("on");
        };
    });

    /**************************************************************jstree 2뎁스 종료*/
    
});

///////////////////// function script /////////////////////////////

//컨텐츠 가로 사이즈
function conSizeInit(){
    var $freeb_contents_wrap = $(".freeb_contents_wrap"); //content wrap
    var $freeb_left_contents = $(".freeb_left_contents"); //content in left
    var contentsWidth = $freeb_contents_wrap.width();     //content wrap width size
    var leftWidth = $freeb_left_contents.width();         //content in left width size
    
    $(".freeb_right_contents").width( contentsWidth - leftWidth - 1);  //content in right set width
    $(".freeb_oneframe_right_contents").width( contentsWidth - 49); //content in oneframe right set width
};

//gnb스크롤 셋/오프
function gnbScroll(){
    var gnbHei = $(".freeb_gnb").height();
    $(".gnb_list").height(gnbHei);
    $(".gnb_list").mCustomScrollbar({theme:"dark",updateOnContentResize:true,autoExpandScrollbar:true,moveDragger:true,autoHideScrollbar:true});
};

//lnb스크롤 셋/오프
function lnbScroll(){
    var lnbHei = $(".freeb_left_contents .resizable_inner").height();
    $(".freeb_lnb").height(lnbHei-51);
    $(".freeb_lnb").mCustomScrollbar({axis:"yx",updateOnContentResize:true,autoExpandScrollbar:false,moveDragger:true,autoHideScrollbar:true,autoScrollOnFocus:false});
};

function freebScroll(){
    $(".freebScroll").mCustomScrollbar({axis:"yx",updateOnContentResize:true,updateOnImageLoad:true,updateOnSelectorChange:true,autoExpandScrollbar:false,moveDragger:true,autoHideScrollbar:false});
    $(".freebScrollX").mCustomScrollbar({axis:"x",updateOnContentResize:true,updateOnImageLoad:true,updateOnSelectorChange:true,autoExpandScrollbar:false,moveDragger:true,autoHideScrollbar:false});
    $(".freebScrollY").mCustomScrollbar({axis:"y",updateOnContentResize:true,updateOnImageLoad:true,updateOnSelectorChange:true,autoExpandScrollbar:false,moveDragger:true,autoHideScrollbar:false});
	$(".freebScrollY_a").mCustomScrollbar({axis:"y",updateOnContentResize:true,updateOnImageLoad:true,updateOnSelectorChange:true,autoExpandScrollbar:false,moveDragger:true,autoHideScrollbar:true});
    $(".freebScrollX_dark").mCustomScrollbar({axis:"x",theme:"dark",updateOnContentResize:true,updateOnImageLoad:true,updateOnSelectorChange:true,autoExpandScrollbar:false,moveDragger:true,autoHideScrollbar:false});
    $(".freebScrollY_dark").mCustomScrollbar({axis:"y",theme:"dark",updateOnContentResize:true,updateOnImageLoad:true,updateOnSelectorChange:true,autoExpandScrollbar:false,moveDragger:true,autoHideScrollbar:false});
};

function protletScrollReset(){
    $(".ptl_content > .freebScroll").mCustomScrollbar("destroy");
    $(".ptl_content > .freebScrollY").mCustomScrollbar("destroy");
    $(".ptl_content > .freebScrollX").mCustomScrollbar("destroy");
    setTimeout(freebScroll(),100);
};