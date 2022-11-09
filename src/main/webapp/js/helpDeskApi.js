

// 사용시 필요한점
/*
 *  1. 이 스크립트를 참조하는 jsp에서 jquery를 참조하고있어야한다.
 * 
 */

var winObj = null;
var helpDeskAddr = 'http://58.224.117.49';

async function fnGetHelpdeskApiInfo(){
	
	return new Promise(function(resolve, reject){ 
		$.ajax({
			type : "get",
			contentType: "application/json",
			url : '/gw/getHelpdeskApiInfo.do',
			datatype : 'json',
			async : false,
			success : function(response) {
				var helpdeskApiInfo = response.helpdeskApiInfo;
				
				if(helpdeskApiInfo !== null && helpdeskApiInfo !== undefined){
					console.log(helpdeskApiInfo);
					resolve(helpdeskApiInfo);					
				}else{
					reject(response);
				}
			},
			error : function(error) {
				console.log("helpdeskApiInfo를 가져오지 못하였습니다.");
				console.log(error);
			}
		})
	})
}
function errAlert(errMsg){
	alert(errMsg);
}

function valueNullChk(helpdeskApiInfo){
	
	if(helpdeskApiInfo !== null && helpdeskApiInfo !== undefined){
		
		for(key in helpdeskApiInfo){
			if(helpdeskApiInfo[key] === "" && key !== "errMsg"){
				//errAlert(helpdeskApiInfo.errMsg);
				return false;
			}
		}
	}
	
	return true;
}

//공지사항 팝업 함수
function fn_noticePop(emergencyChk, secretKey, boardSeq, noticeContents, prevBoardSeq) {
	
	if(noticeContents === null || noticeContents === 'null'){
		noticeContents = this.noticeContents;
	}
	
	noticeContents = fnChangeBoardSeq(noticeContents.noticePopContents, prevBoardSeq, boardSeq);
	
	var html = "";

	html += '<title>그룹웨어 공지팝업</title>';
	html += '<link rel=\"stylesheet\" type=\"text/css\" href=\"/gw/css/kendoui/kendo.common.min.css" />';
	html += '<link rel=\"stylesheet\" type=\"text/css\" href=\"/gw/css/kendoui/kendo.dataviz.min.css" />';
	html += '<link rel=\"stylesheet\" type=\"text/css\" href=\"/gw/css/kendoui/kendo.mobile.all.min.css" />';
	html += '<link rel=\"stylesheet\" type=\"text/css\" href=\"/gw/css/kendoui/kendo.silver.min.css" />';
	html += '<link rel=\"stylesheet\" type=\"text/css\" href=\"/gw/css/main.css?ver=20191226"/>';
	html += '<link rel=\"stylesheet\" type=\"text/css\" href=\"/gw/css/common.css?ver=20191226"/>';
	html += '<link rel=\"stylesheet\" type=\"text/css\" href=\"/gw/css/reKendo.css"/>';
	
	html += '<div class="pop_wrap" style="border-color: white;">';
	html += 	'<div class="pop_head">';
	if(emergencyChk === 'Y'){			
		html += '		<h1>그룹웨어 긴급 공지</h1>';
	}else{
		html += '		<h1>그룹웨어 공지사항</h1>';
	}
	html += 	'</div>';
	
	html += 	'<div class="pop_con">';
	html += 		"<iframe name='frm' width='1630'  height='820' border='0' frameborder='no' scrolling='no' marginwidth='0' hspace='0' vspace='0' srcdoc='" + noticeContents + "'></iframe>";
	html += 	'</div>';

	html += 	'<div class="pop_foot" style="width: 100%; position: fixed;">';
	html += 		'<div class="btn_cen pt12">';
	if(emergencyChk === 'Y'){			
		html +=				'<input type="button" onclick="javascript:opener.parent.fnChangeNoticePopLimitYn();" value="더이상 안보기"/>';
	}
	html +=				'<input type="button" onclick=\"javascript:window.close();\" value="닫기"/>';
	html += 		'</div>';
	html +=		'</div>';
	html += 	'<div class="pop_foot_bg" style="display: block;"></div>';
	html +=	'</div>';

	winObj = window.open("", "target", "width=1600, height=1200, location=no");
	winObj.document.body.innerHTML = '';
	winObj.document.head.innerHTML = '';
	winObj.document.write(html);
	winObj.document.close();
}

// 5분마다 최신 boardSeq를 가져옴 -> 백엔드로 이동
function fnScheduleRecentBoardSeqAndNoticeList() {
		
	setInterval( async function() {

		this.helpdeskApiInfo = await fnGetHelpdeskApiInfo();
		
		//하루 지나면 오늘하루안보기 초기화 -> 사용 x
		//fnResetNoticeInfoToLocalStorage(this.helpdeskApiInfo);
		
		checkNoticePopLimit(this.helpdeskApiInfo.boardSeq);
		
	}, 300000);
}

// 최근 공지사항 boardSeq와 기존 boardSeq가 다르면 noticeInfoLimit 초기화
function checkNoticePopLimit(apiInfoBoardSeq){
	
	var localBoardSeq = localStorage.getItem("boardSeq");
	
	if(localBoardSeq === null || localBoardSeq === undefined){
		localStorage.setItem("boardSeq", apiInfoBoardSeq); 
		localStorage.setItem("noticePopLimitYn", "N");
	}else{
		if(apiInfoBoardSeq !== "" && apiInfoBoardSeq !== localBoardSeq){
			localStorage.setItem("noticePopLimitYn", "N");
		}
	}
}

// 로컬스토리지에 오늘하루 안보기값 저장(버튼 클릭)
function fnChangeNoticePopLimitYn () {
	var noticePopLimitYn = localStorage.getItem("noticePopLimitYn");
	
	if(noticePopLimitYn === "N" || noticePopLimitYn === null || noticePopLimitYn === undefined){
		localStorage.setItem("noticePopLimitYn", "Y");
	}	
	
	winObj.close();
}

//로컬스토리지의 noticePopLimitYn의 값을 확인하여 긴급공지팝업 띄울지 확인 -> 백엔드에서 처리
function fnCheckOpenNoticePop(helpdeskApiInfo, noticeContents){
	
	// 밤12시 데이터 초기화
	//fnResetNoticeInfoToLocalStorage();
	
	var nullChkVal = valueNullChk(helpdeskApiInfo);
	
	//ClosedNetworkYn 확인
	if(nullChkVal){
	
		checkNoticePopLimit(helpdeskApiInfo.boardSeq);
		
		if(localStorage.getItem("noticePopLimitYn") !== 'Y'){				
			fn_noticePop('Y', helpdeskApiInfo.secretKey, helpdeskApiInfo.boardSeq, noticeContents, helpdeskApiInfo.prevBoardSeq);
		}
	}
}

// 공지사항 더보기 클릭시 헬프데스크 공지사항 사이트로 이동
//function fnHelpdeskViewMore(){
//	fnOpenWindowHelpDesk(helpDeskAddr + '/board/notice/noticeListView.do',  "HelpDesk",  $(window).width(), $(window).height(), 1,1);
//}

// 공지사항 리스트 화면에 그림
function fnDrawNoticeList(noticeListDiv, helpdeskApiInfo){
	
	var notice = '';
	var resNoticeList = helpdeskApiInfo.noticeList;
	
	if(resNoticeList !== null && resNoticeList !== undefined && resNoticeList !== ""){		
		if(resNoticeList.length === 0){
			noticeListDiv.style.display = 'none';
			return;
		}
	}else{
		//공지사항이 없을때 처리
		noticeListDiv.style.display = 'none';
		return;
	}

	for(var i = 0; i < resNoticeList.length; i++){
	
		var noticeCreateDt = (resNoticeList[i].createDt).replace(/\./gi, '-');
		
		notice += "<dl>";
		notice += 	"<dt class='title'>";
		notice += 		"<a href=javascript:fn_noticePop('N','" + helpdeskApiInfo.secretKey + "','" + resNoticeList[i].boardSeq + "','" + null + "','" + helpdeskApiInfo.prevBoardSeq + "')";
		if(i === 0){
			notice += " class='new'>";
		} else {
			notice += ">";
		}
		notice += 			resNoticeList[i].subject;
		notice += 		"</a>";
		if(i === 0){
			notice += "<img src='../../../Images/ico/icon_new.png' alt='new'/>";
		}
		notice += 	"</dt>";
		notice += 	"<dd class='date'>";
		notice += 		noticeCreateDt;
		notice += 	"</dd>";
		notice += "</dl>";
		
		$(noticeListDiv).append(notice);
		notice = '';
	}			
}

// 공지사항 더보기 클릭시 헬프데스크 공지사항 사이트 오픈
function fnOpenWindowHelpDesk(url,  windowName, width, height, strScroll, strResize ){

	var pop = "" ;
	windowX = Math.ceil( (window.screen.width  - width) / 2 );
	windowY = Math.ceil( (window.screen.height - height) / 2 );
	if(strResize == undefined || strResize == '') {
		strResize = 0 ;
	}
	
	if(windowName == "_blank"){
		pop = window.open(url, "_blank");
	}else{
		pop = window.open(url, windowName, "width=" + width + ", height=" + height + ", top="+ windowY +", left="+ windowX +", scrollbars="+ strScroll+", resizable="+ strResize);	
	}
	
	try {pop.focus(); } catch(e){
	console.log(e);//오류 상황 대응 부재
	}
	return pop;
}

// 공지사항 view 페이지의 boardSeq 변경
function fnChangeBoardSeq(noticePopContents, prevBoardSeq, nextBoardSeq){
	return noticePopContents.replace("BOARD_SEQ  = \"" + prevBoardSeq + "\"", "BOARD_SEQ  = \"" + nextBoardSeq + "\"");
}

//오늘하루안보기 값 등 하루 지났으면 초기화 -> 시간, 날짜도 localStorage에 저장
//function fnResetNoticeInfoToLocalStorage(paramHelpdeskApiInfo){
//	
//	console.log(paramHelpdeskApiInfo);
//	var currentTime = paramHelpdeskApiInfo.currentTime;
//	
//	if(currentTime !== null && currentTime !== undefined && currentTime !== ""){
//		var hour = currentTime.split(':')[0];
//		
//		//오늘하루 안보기 체크 후 하루가 지났는지 확인
//		if(hour === "00"){
//			localStorage.removeItem('noticePopLimitYn');
//		}
//	}
//}
