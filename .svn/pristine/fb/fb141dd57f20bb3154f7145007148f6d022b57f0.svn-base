//event Y/N check ☆☆☆☆☆
var scInitYN = false;
var aniInitYN = false;
var resultYN = false;

//검색어 자동완성 조립
function replaceResultTextSet( $box, exData, valStr ) {
	$box.html( null );
	exData.forEach( function( item, idx ) {

		var dlTag = document.createElement( "dl" );
		$box.append( dlTag );

		var dtTag = document.createElement( "dt" );
		dtTag.innerHTML = item.exDt;
		dlTag.appendChild( dtTag );

		item.exText.forEach( function( itm, ix ) {

			var textStr = itm;
			textStr = textStr.replace( /</gi, "&lt;" );
			textStr = textStr.replace( />/gi, "&gt;" );

			if( valStr ) {
				if( ! checkSpecialCharacter( valStr ) ) {
					textStr = replaceTextMarking( valStr, textStr );
				}
			}
			
			var ddTag = document.createElement( "dd" );
			var aTag = document.createElement( "a" );
			aTag.innerHTML = textStr;
			aTag.setAttribute( 'href', 'javascript:moveMenu(\'' + item.module + '\', \'' + item.exId[ix] + '\', \'' + item.exName[ix] + '\');' )
			dlTag.appendChild( ddTag );
			ddTag.appendChild( aTag );
			
		});

		if( 0 == $( dlTag ).find( ".match" ).length ) {
			$( dlTag ).hide();
		}
	});
}
function checkSpecialCharacter( str ) {
	var special_pattern = /[`~!#$%^*|\\\'\"\/?\[\]]/gi;
	if( special_pattern.test( str ) ) return true;
	return false;
}

//검색어 매칭
function replaceTextMarking( valStr, textStr ) {
	var reg = new RegExp( valStr, "g" );
	textStr = textStr.replace( reg, function( s ) {
		return '<span class="match">' + s + '</span>';
	});
	return textStr;
}
//검색 애니메이션 세팅
function aniInit(){
	if(scInitYN == false){
		if(resultYN == true){ //검색결과창인지 확인 후 세팅
			$(".searchBox").attr("style","top:0;");
			$( ".lately_keyword" ).show().addClass("animated1s fadeInDown");
			$( ".alertBox_detail" ).hide();
			$( ".alertBox_list" ).hide();
			$( ".lately_use" ).attr("style","height:0px;margin:0 auto;");
			aniInitYN = true
			userInfoPopClose();//사용자정보 팝업 강제종료
			setTimeout(function(){
				$( ".lately_keyword" ).removeClass("animated1s fadeInDown");
				aniInitYN = false
			},1000);
			
		}else{
			$(".searchBox").attr("style","top:0;");
			$( ".lately_keyword" ).show().addClass("animated1s fadeInDown delay03s");
			$( ".alertBox_detail" ).show().addClass("animated1s fadeInUp delay03s");
			$( ".alertBox_list" ).addClass("animated05s fadeOutLeft");
			$( ".lately_use" ).show().attr("style","top:0;").addClass("animated1s fadeInUp delay03s");
			aniInitYN = true
			userInfoPopClose();//사용자정보 팝업 강제종료
			setTimeout(function(){
				$( ".lately_keyword" ).removeClass("animated1s fadeInDown delay03s");
				$( ".alertBox_detail" ).removeClass("animated1s fadeInUp delay03s");
				$( ".alertBox_list" ).removeClass("animated05s fadeOutLeft").hide();
				$( ".lately_use" ).removeClass("animated1s fadeInUp delay03s");
				aniInitYN = false
			},1300);
		}			
	}
}

//검색어 자동완성결과 보여주기
function showResultTextSet() {
	if(!resultYN == true){ //검색결과창인지 확인 후 세팅
		$( "#autoText" ).attr("style","display:block").height(460);
		$( ".alertBox_detail" ).hide();
		
		focusEle = document.activeElement;	
		$('#searchText').keyup(function(event) {
			if (document.getElementById('searchText') == focusEle) {
				var rows= $('#mCSB_1_container').find('a');
				if (event.keyCode == '40') {
					rows.eq(0).attr("tempFocus",0);
					rows.eq(0).focus();
				} 
			}
		});

		$('#mCSB_1_container').keydown(function(event) {
			var index ,temp, max = "";
			var rows= $('#mCSB_1_container').find('a');
			
			for (var i =0; i < rows.size(); i ++){
				if ($(rows[i]).attr('tempFocus')) {
					index = $(rows[i]).attr('tempFocus');
					break;
				}
			}

			temp = Number(index);
			index = Number(index);
			max = rows.size() - 1;

		    if (event.keyCode == '38') {
				if (index == 0) {
					moveFocus(temp,max);
				} else {
					index = index - 1;
					moveFocus(temp,index);
				}
			} else if (event.keyCode == '40') {
				if (index == max) {
					moveFocus(temp,0);
				} else {
					index = index + 1;
					moveFocus(temp,index);
				}
			 }
		}); 

		freebScroll(); //공통 스크롤함수
		userInfoPopClose();//사용자정보 팝업 강제종료
	}
}

function moveFocus(temp,index){
	var rows= $('#mCSB_1_container').find('a');
	setTimeout(function(){
		rows.eq(temp).removeAttr("tempFocus");
		rows.eq(temp).blur();
		rows.eq(index).attr("tempFocus",index);
		rows.eq(index).focus();
	},100)
}

//검색어 자동완성결과 종료
function hideResultTextSet() {
	$( "#autoText" ).attr("style","height:0px;overflow:hidden");
	//$( ".alertBox_detail" ).attr("style","");
	
	freebScroll(); //공통 스크롤함수
	userInfoPopClose();//사용자정보 팝업 강제종료
}
//검색 초기화면 세팅
function scInit(){
	if(aniInitYN == false){
		$(".searchBox").attr("style","top:30%;");
		$( ".alertBox_detail" ).hide();
		$( ".lately_keyword" ).hide();
		$( ".alertBox_list" ).show().removeClass("animated05s fadeInLeft").addClass("animated05s fadeInLeft");
		$( ".lately_use" ).attr("style","top:30%;");
		scInitYN = true
		setTimeout(function(){
			$( ".alertBox_list" ).removeClass("animated05s fadeInLeft")
			scInitYN = false
		},500);
	}
};

//커스텀 스크롤
function freebScroll(){
    $(".freebScroll").mCustomScrollbar({axis:"yx",updateOnContentResize:true,updateOnImageLoad:true,updateOnSelectorChange:true,autoExpandScrollbar:false,moveDragger:true,autoHideScrollbar:false});
    $(".freebScrollX").mCustomScrollbar({axis:"x",updateOnContentResize:true,updateOnImageLoad:true,updateOnSelectorChange:true,autoExpandScrollbar:false,moveDragger:true,autoHideScrollbar:false});
    $(".freebScrollY").mCustomScrollbar({axis:"y",updateOnContentResize:true,updateOnImageLoad:true,updateOnSelectorChange:true,autoExpandScrollbar:false,moveDragger:true,autoHideScrollbar:false});
	$(".freebScrollY_a").mCustomScrollbar({axis:"y",updateOnContentResize:true,updateOnImageLoad:true,updateOnSelectorChange:true,autoExpandScrollbar:false,moveDragger:true,autoHideScrollbar:true});
    $(".freebScrollX_dark").mCustomScrollbar({axis:"x",theme:"dark",updateOnContentResize:true,updateOnImageLoad:true,updateOnSelectorChange:true,autoExpandScrollbar:false,moveDragger:true,autoHideScrollbar:false});
    $(".freebScrollY_dark").mCustomScrollbar({axis:"y",theme:"dark",updateOnContentResize:true,updateOnImageLoad:true,updateOnSelectorChange:true,autoExpandScrollbar:false,moveDragger:true,autoHideScrollbar:false});
};

//포털뷰 오픈
function scOpen(){
    window.parent.dews.app.overlay.show();
}

//포털뷰 종료
function scClose(){
	window.parent.dews.app.overlay.hide();
}

//사용자정보 팝업 온/오프
function userInfoPop(){

	if( !$(".user_profile_pop").hasClass("open") ){

		$(".user_profile_pop").show().addClass("open animated03s zoomIn");

		setTimeout(function(){
			$(".user_profile_pop").removeClass("animated03s zoomIn zoomOut");
		},300);	

	}else{

		$(".user_profile_pop").removeClass("open").addClass("animated03s zoomOut");

		setTimeout(function(){
			$(".user_profile_pop").removeClass("animated03s zoomIn zoomOut").hide();
		},300);

	}
}

//사용자정보 팝업 강제오프
function userInfoPopClose(){
	$(".user_profile_pop").removeClass("open").addClass("animated03s zoomOut");

	setTimeout(function(){
		$(".user_profile_pop").removeClass("animated03s zoomIn zoomOut").hide();
	},300);
}

// 입력박스 키보드 입력 발생시에 호출되는 함수
function autoCompleteCall( valStr ) {
	if( "" == valStr ) {
		hideResultTextSet();
	} else {
		
		var requestTime = new Date().getTime();
		lastMenuRequestTime = requestTime;
		lastMenuSearchKeyword = valStr;
		window.parent.dews.ajax.get("/api/CM/MenuService/Search?keyword=" + valStr + "&_" + "=" + requestTime)
		.done(function(data, textStatus, request){
			if(data.state=="success" && requestTime >= lastMenuRequestTime && $( "#searchText" ).val().trim() != ""){//요청 성공이면서 요청시간이 마지막 요청 시간보다 클때만 적용

				//검색창 메뉴데이터 세팅
				exData = setMenuData(data.data, valStr, exData);
				
				// autoText content 설정
				replaceResultTextSet( $( "#mCSB_1_container" ), exData, valStr );
		
				if( 0 == $( "#autoText" ).find( ".match" ).length ) {// 일치하는 항목이 없는 경우
		
					// animation 구현에 따라 적용
		
				} else {// 일치하는 항목이 있는 경우
		
					var height = $( "#autoText" ).css( "height" );
					height = parseInt( height );
		
					if( ! isNaN(height) ) {
						if( 0 == height ) {
							showResultTextSet();
						} else {
							// skip - 이미 표시되고 있는 경우
						}
					} else {
						// skip - height 설정이 숫자형태가 아닌 경우 : 비정상적인 경우
					}
				}
			}else if(data.state!="success"){//요청 실패
				alert("api 호출 실패");
			}
		});
		
	}
};

//검색 결과창 호출
function showSearchResultBox() {
	$( "#autoText" ).hide();
	$( ".alertBox_detail" ).hide();
	$( ".alertBox_list" ).hide();
	$( ".lately_use" ).hide();
	$( ".copy" ).addClass("animated05s fadeOutDown");
	
	var valStr = $( "#searchText" ).val();
	
	$( ".searchResult" ).css("bottom","").removeClass("animated05s fadeOutDown").hide();
	
	$(".searchResult").show().css("bottom","0").addClass("animated05s fadeInUp");
	resultYN = true
	
	setTimeout(function(){
		$( ".copy" ).removeClass("animated05s fadeOutDown").hide();
		$( ".searchResult" ).removeClass("animated05s fadeInUp");
	},500);
	
	//사용자정보 팝업 강제종료
	userInfoPopClose();
	
	//검색결과 처리
	processResult(valStr);
}
//검색 결과창 종료
function hideSearchResultBox() {
	$( ".alertBox_detail" ).attr("style","");
	$( ".lately_use" ).attr("style","");
	$( "#portalview_btn" ).addClass("animated05s fadeInUp");
	$( ".copy" ).addClass("animated05s fadeInUp");
	
	$(".searchResult").addClass("animated05s fadeOutDown");
	resultYN = false
	setTimeout(function(){
		$( "#portalview_btn" ).show().removeClass("animated05s fadeInUp");
		$( ".copy" ).show().removeClass("animated05s fadeInUp");
		$( ".searchResult" ).css("bottom","").removeClass("animated05s fadeOutDown").hide();
	},500);
	
	userInfoPopClose();//사용자정보 팝업 강제종료
}
$(function(){
	
	$(document).ready(function(){
		freebScroll(); //공통 스크롤함수

	});//document ready

	$(window).resize(function() {
    	freebScroll(); //공통 스크롤함수

	});//window resize

	//검색창 이벤트 감지
	$( "#searchText" ).on( "input", function( e ) {
		
		var valStr = $( "#searchText" ).val().trim();
		
		//완벽한 한글 || 숫자 || 영문자만 검색
		var pattern = /([^0-9a-zA-Z가-힣\x20])/i;
		
		if("" == valStr){
			
		}else{
			if( 38 == e.keyCode || 40 == e.keyCode || 13 == e.keyCode || 27 == e.keyCode || 37 == e.keyCode || 39 == e.keyCode || pattern.test(valStr) || lastMenuSearchKeyword == valStr || resultYN == true) {
				return;
			}
		}
		
		autoCompleteCall( valStr );		
	});
	
	//검색창 키 이벤트 감지
	$( "#searchText" ).on( "keyup", function( e ) {			
		var inpVal = $( this ).val();
		//엔터키 쳤을때
		if( 13 == e.keyCode || e.key === "Enter") {
			if( ! inpVal == "") {
				if(canSearchStatus()){
					showSearchResultBox();	
				}else{
					alert("페이지 로딩중 입니다. 잠시후에 다시 시도해 주세요.");
				}
				
			}
		}
		//input에 값이 없을때 초기화
		if( inpVal === "" ) {
			var bottom = $(".searchResult").css("bottom");
			bottom = parseInt( bottom );

			if( ! isNaN( bottom ) ) {
				if( 0 == bottom ) {
					hideSearchResultBox();
				}
			}
			$(".reset_btn").hide();
		}else{
			$(".reset_btn").show();
		}
	});
	
	//검색초기화
	$(".logo").on("click",function(e){
		e.preventDefault();
		$("#searchText").val("");

		var defaultCnt = 5;
				
		$( ".lately_use" ).removeClass("full").css({"width":( ( defaultCnt * 80 ) + 80 )+"px"})
		$( ".alertBox_list" ).css({"top":""});
		setTimeout(function(){
			$( ".lately_use .full_btn" ).css({"transform":"","border-radius":""});
		},300);
		
		//결과창인지 확인
		if(resultYN == true){
			hideSearchResultBox();
			hideResultTextSet();
			scInit();
		}else{		
			hideResultTextSet();
			scInit();
		}		
	});
	
	//포털뷰 버튼 클릭
    $( ".portalview_btn" ).on( "click", function( e ) {
            scClose();
    });
	
	//검색창 돋보기 버튼 클릭
	$( ".search_btn" ).on( "click", function( e ) {
		var inpVal = $( "#searchText" ).val();
		if( ! inpVal == "") {
			showSearchResultBox();
		}
	});
	
	//검색창 x 버튼 클릭
	$( ".reset_btn" ).on( "click", function( e ) {
		$( ".reset_btn" ).hide();
		$( "#searchText" ).val("").focus();
		hideResultTextSet();
		hideSearchResultBox();
	});
	
	
	//검색창에 포커스가 들어갔을때
	$( "#searchText" ).focusin(function(e){
		e.preventDefault();
		var inpVal = $( "#searchText" ).val();
		if( inpVal == "" ) {
			aniInit();
		}
		
		var defaultCnt = 5;
		if($( ".lately_use" ).hasClass("full")){
			$( ".lately_use" ).removeClass("full").css({"width":( ( defaultCnt * 80 ) + 80 )+"px"})
			$( ".alertBox_list" ).css({"top":""});
			$( ".lately_use .full_btn" ).css({"transform":"","border-radius":""});
		}
	});
	
	//검색창에 포커스가 빠졌을때
	$( "#searchText" ).blur(function(e){
		var inpVal = $( "#searchText" ).val();
		
		if(scInitYN == false){
			if( inpVal == "" ) {
				scInit();
			}
		}
		
		var defaultCnt = 5;
		if($( ".lately_use" ).hasClass("full")){
			$( ".lately_use" ).removeClass("full").css({"width":( ( defaultCnt * 80 ) + 80 )+"px"})
			$( ".alertBox_list" ).css({"top":""});
			$( ".lately_use .full_btn" ).css({"transform":"","border-radius":""});
		}
	});
	
	//최근사용모듈 접고 펼치기
	$( ".lately_use .full_btn" ).on("click",function(e){
		e.preventDefault();
		var menulength = $( ".lately_use li" ).length;
		var defaultCnt = 5;
		
		if($( ".lately_use" ).hasClass("full")){
			$( ".lately_use" ).removeClass("full").css({"width":( ( defaultCnt * 80 ) + 80 )+"px"})
			$( ".alertBox_list" ).css({"top":""});
			setTimeout(function(){
				$( ".lately_use .full_btn" ).css({"transform":"","border-radius":""});
			},300);
		}else{
			$( ".lately_use" ).addClass("full").css({"width":( ( menulength * 80 ) + 80 )+"px"})
			$( ".alertBox_list" ).css({"top":"15%"});
			setTimeout(function(){
				$( ".lately_use .full_btn" ).css({"transform":"rotate(180deg)","border-radius":"10px 0px 0px 10px"});	
			},300);
		}
		userInfoPopClose();//사용자정보 팝업 강제종료
	});
	
	//애니메이션 호출방지
	$( ".lately_keyword, .alertBox_detail, .alertBox_list, .lately_use" ).on("mouseenter",function(e){
		scInitYN = true
		aniInitYN = true
	}).on("mouseleave",function(e){
		scInitYN = false
		aniInitYN = false
	});
	//키워드 클릭시
    $(document).on("click",".lately_keyword span", function(e){
            if(aniInitYN == true){
                    var ddText = $(this).text();
                    $( "#searchText" ).val(ddText).focus();
                    $( ".reset_btn" ).show();
            }
            userInfoPopClose();//사용자정보 팝업 강제종료
    });
    //키워드 삭제
    $(document).on("click",".lately_keyword .delete_btn", function(e){
            e.preventDefault();
            if(aniInitYN == true){
                    var This = $(this);
                    This.parent().addClass("animated05s fadeOutDown");
                    setNoUseSearchKeyword(This.parent().attr("id"), function(){
                        This.parent().remove();
                        getRecentSearchKeyword();//최근검색어 재조회
                    })
            }
            userInfoPopClose();//사용자정보 팝업 강제종료
    });
	
	//사용자정보 호출
	$(".user_profile .user_info").on("click",function(e){
		e.preventDefault();
		userInfoPop();//사용자정보 팝업
	});
	
	//사용자정보 호출 종료
	$(".searchBox, .lately_keyword, .alertBox_detail, .alertBox_list, .lately_use, .bottom_buttons .apply, .bottom_buttons .logout").on("click",function(e){
		userInfoPopClose();//사용자정보 팝업 강제종료
	});
	
	scInit(); //검색 초기화면 세팅	
});