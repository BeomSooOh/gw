<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="validator" uri="http://www.springmodules.org/tags/commons-validator" %>

<script type="text/javascript" src="<c:url value='/js/jquery-1.9.1.min.js'/>"></script>
<script type="text/javascript" src="<c:url value='/js/jquery.form.js'/>"></script>
<script type="text/javascript" src="<c:url value='/js/pudd/Script/pudd/pudd-1.1.189.min.js'/>"></script>
<link rel="stylesheet" type="text/css" href="<c:url value='/js/pudd/css/pudd.css'/>" />
<link rel="stylesheet" type="text/css" href="<c:url value='/css/common.css' />"> 

  <script type="text/javascript" src="<c:url value='/js/Scripts/common.js' />"></script>


  
   

<script type="text/javascript">
	var groupSeq = "${loginVo.groupSeq}";
	var langCode = "${loginVO.langCode}";
	var connectCheck = false; //체크여부
	var docCount = 0;
	var alphaDocBoxList = null; // Alpha 결재보관함 리스트
	var docIdCnt = 999; // 전자결재 문서 데이터를 몇개씩 들고올지 카운트
	var recordSuiteDocCnt = 0; // 하나의 문서함에 몇개까지 가져왔는지 체크 ex) 0 ~ 1000, 1000 ~ 2000
	var elecDocDataList = null; // Alpha 종결된 전자결재 문서 리스트 teag_appdoc 데이터
	var requestURL = '${pageContext.request.getRequestURL()}';
	var requestURI = '${pageContext.request.getRequestURI()}';
	var serverPath = requestURL.replace(requestURI, ""); // 고객사 도메인 주소
	var processCnt = 0; // 문서 변환 카운트
	var elecConvertFailCnt = 0; // 문서 변환 실패 카운트
	var authDocProcessCnt = 0; // 권한승인함 이관 카운트
	var viewDocProcessCnt = 0; // 문서뷰어 이관 카운트
	
	var selectSuiteBoardCommentList = []; // 게시판 댓글 리스트
	var selectSuiteDocCommentList = []; // 게시판 댓글 리스트
	var docCommentProcessCnt = 0; // 문서 댓글 이관 카운트
	var boardCommentProcessCnt = 0; // 게시판 댓글 이관 카운트
	
	var startTime = ''; // 시작시간
	var endTime = ''; // 종료시간
	
	var converElecDocCnt = 10; // 변환할 문서 갯수
	var failConvertDocIdList = []; // 변환 실패한 문서아이디 리스트
	
	var failDocIdList = ''; // 변환 실패한 문서아이디 리스트
	
	//var checkMigDocId = false; // 마이그레이션 진행 중 끊겨서 마이그레이션 재 시작 시 T_MIG_INFO에 저장했던 문서아이디가 다음부터 시작해야하므로 문서ID 체크 값
	var existData = false; // 마이그레이션 진행 중 끊겨서 마이그레이션 재 시작 시 문서id가 처음 1000개 가져오는것들보다 커서 데이터를 못가져오는 경우를 확인하기위함
	
	$(document).ready(function() {
		
		if(groupSeq == null || groupSeq == "") {
			alert("로그인을 먼저 하시길 바랍니다.");
		}
		
		suiteServerInfo();
		
		// 연결확인
		$("#btnConnect").click(function () { connectConfirm(); });
		
		// 시작
		$("#migStart").click(async function () { 
			
			processCnt = 0; // 문서 변환 카운트
			elecConvertFailCnt = 0; // 문서 변환 실패 카운트
			authDocProcessCnt = 0; // 권한승인함 이관 카운트
			viewDocProcessCnt = 0; // 문서뷰어 이관 카운트
			
			document.getElementById("authDocProcessCnt").innerHTML = authDocProcessCnt;
			document.getElementById("viewDocProcessCnt").innerHTML = viewDocProcessCnt;
			document.getElementById("processCnt").innerHTML = processCnt;
			
			let time = getCurrentDate();
			console.log('시작시간: ', time);
			document.getElementById("startTime").innerHTML = time;
			//let initResultData = await alphaBpmTableInit({});
			
			let backupResult = await alphaBackupBpmTable({});
			
			// 마이그레이션 진행중 저장했던 menu_id, doc_id 가져옴
			let menuId = backupResult.menuId;
			let docId = backupResult.docId;
			
			// 마이그레이션 진행중 끊겨서 재시작할경우 true
			let checkRestartMig = menuId && docId ? true : false;
			//let checkMigDocId =  menuId && docId ? true : false; // 마이그레이션 진행 중 끊겨서 마이그레이션 재 시작 시 T_MIG_INFO에 저장했던 문서아이디가 다음부터 시작해야하므로 문서ID 체크 값

			if(backupResult.result === "1"){
				
				for(var i = 0, len = alphaDocBoxList.length; i < len; i++){
					
					let suiteMenuId = alphaDocBoxList[i].suiteMenuId;
					
					if(menuId !== suiteMenuId){
						// 재시작했던 문서함을 다 끝냈을경우 기존 마이그레이션 처럼 해당 문서함에 대한 doc_id를 다 들고옴
						checkRestartMig = false;
					}
					
					let elecDocListCnt = await alphaElecDocSelect({
						recordSuiteDocCnt: recordSuiteDocCnt,
						suiteMenuId: suiteMenuId,
						checkRestartMig: checkRestartMig
					});
					
	//				console.log('elecDocListCnt: ', elecDocListCnt);
					
					// 전자결재 문서 데이터를 전자결재 api에 태워 보냄 10개씩
					for(var j = 0, lenJ = elecDocDataList.length; j < lenJ; j+=converElecDocCnt){
						
						existData = true;
						
						/* if(checkRestartMig && checkMigDocId){
							if(String(elecDocDataList[j].DOC_ID) === docId){
								checkMigDocId = false;
								j -= converElecDocCnt;
								j++;
								continue;
							}else{
								
								continue;
							}
						} */
						
						let sendElecDocDataList = null;
						failDocIdList = '';
						
						if(j + converElecDocCnt <= lenJ - 1){
							sendElecDocDataList = elecDocDataList.slice(j, j + converElecDocCnt);
						}else{
							
							if(lenJ === 1){
								sendElecDocDataList = elecDocDataList;
							}else if(j === elecDocDataList.length - 1){
								sendElecDocDataList = [elecDocDataList[j]];
							}else{							
								sendElecDocDataList = elecDocDataList.slice(j, elecDocDataList.length);
							}
						}
						//console.log('sendElecDocDataList: ', sendElecDocDataList);
						//[{"CREATE_NM":"관리자","DOC_ID":9,"DEPT_ID":"1110","MODIFY_DT":{"date":20,"day":4,"hours":16,"minutes":33,"month":4,"nanos":0,"seconds":2,"time":1621503182000,"timezoneOffset":-420,"year":121},"FORM_MODE":"1","USER_ID":"1","CREATED_DT":{"date":30,"day":4,"hours":10,"minutes":41,"month":4,"nanos":0,"seconds":50,"time":1559187710000,"timezoneOffset":-420,"year":119},"DOC_NO":"데모서버-2019-0007","DOC_STSNM":"상신","DEPT_NM":"관리팀","REP_DT":{"date":30,"day":4,"hours":10,"minutes":42,"month":4,"nanos":0,"seconds":46,"time":1559187766000,"timezoneOffset":-420,"year":119},"TRANSFER_YN":"1","FORM_NM":"시말서","MODIFY_NM":"관리자","USER_NM":"관리자","DOC_STS":"20","CO_ID":"1000","DOC_TITLE":"test","FORM_ID":14,"END_DT":null},{"CREATE_NM":"관리자","DOC_ID":10,"DEPT_ID":"1110","MODIFY_DT":{"date":30,"day":4,"hours":10,"minutes":43,"month":4,"nanos":0,"seconds":37,"time":1559187817000,"timezoneOffset":-420,"year":119},"FORM_MODE":"1","USER_ID":"1","CREATED_DT":{"date":30,"day":4,"hours":10,"minutes":43,"month":4,"nanos":0,"seconds":28,"time":1559187808000,"timezoneOffset":-420,"year":119},"DOC_NO":"아미코젠(주)-1906-0926","DOC_STSNM":"임시저장","DEPT_NM":"관리팀","REP_DT":{"date":30,"day":4,"hours":10,"minutes":43,"month":4,"nanos":0,"seconds":33,"time":1559187813000,"timezoneOffset":-420,"year":119},"TRANSFER_YN":"1","FORM_NM":"사직서","MODIFY_NM":"관리자","USER_NM":"관리자","DOC_STS":"10","CO_ID":"1000","DOC_TITLE":"test","FORM_ID":15,"END_DT":null},{"CREATE_NM":"배성원","DOC_ID":11,"DEPT_ID":"1225","MODIFY_DT":{"date":2,"day":2,"hours":16,"minutes":25,"month":1,"nanos":0,"seconds":42,"time":1612257942000,"timezoneOffset":-420,"year":121},"FORM_MODE":"1","USER_ID":"1279","CREATED_DT":{"date":30,"day":4,"hours":10,"minutes":43,"month":4,"nanos":0,"seconds":49,"time":1559187829000,"timezoneOffset":-420,"year":119},"DOC_NO":"(주)포틀릿-2019-0001","DOC_STSNM":"종결","DEPT_NM":"본부장","REP_DT":{"date":30,"day":4,"hours":10,"minutes":43,"month":4,"nanos":0,"seconds":49,"time":1559187829000,"timezoneOffset":-420,"year":119},"TRANSFER_YN":"1","FORM_NM":"기안서11","MODIFY_NM":"배성원","USER_NM":"배성원","DOC_STS":"90","CO_ID":"1204","DOC_TITLE":"테스트 기안서","FORM_ID":1,"END_DT":{"date":2,"day":2,"hours":16,"minutes":25,"month":1,"nanos":0,"seconds":42,"time":1612257942000,"timezoneOffset":-420,"year":121}},{"CREATE_NM":"박준","DOC_ID":82,"DEPT_ID":"4431","MODIFY_DT":{"date":2,"day":5,"hours":8,"minutes":5,"month":7,"nanos":0,"seconds":42,"time":1564707942000,"timezoneOffset":-420,"year":119},"FORM_MODE":"1","USER_ID":"2476","CREATED_DT":{"date":14,"day":5,"hours":13,"minutes":46,"month":5,"nanos":0,"seconds":36,"time":1560494796000,"timezoneOffset":-420,"year":119},"DOC_NO":"","DOC_STSNM":"상신","DEPT_NM":"개발팀","REP_DT":{"date":14,"day":5,"hours":13,"minutes":46,"month":5,"nanos":0,"seconds":47,"time":1560494807000,"timezoneOffset":-420,"year":119},"TRANSFER_YN":"1","FORM_NM":"휴가신청서_test","MODIFY_NM":"박준","USER_NM":"박준","DOC_STS":"20","CO_ID":"2473","DOC_TITLE":"6/12 오전반차 후 출근 등록 테스트","FORM_ID":18,"END_DT":null},{"CREATE_NM":"관리자","DOC_ID":84,"DEPT_ID":"1110","MODIFY_DT":{"date":14,"day":5,"hours":16,"minutes":46,"month":5,"nanos":0,"seconds":29,"time":1560505589000,"timezoneOffset":-420,"year":119},"FORM_MODE":"1","USER_ID":"1","CREATED_DT":{"date":14,"day":5,"hours":16,"minutes":46,"month":5,"nanos":0,"seconds":29,"time":1560505589000,"timezoneOffset":-420,"year":119},"DOC_NO":"","DOC_STSNM":"상신","DEPT_NM":"관리팀","REP_DT":{"date":14,"day":5,"hours":16,"minutes":46,"month":5,"nanos":0,"seconds":28,"time":1560505588000,"timezoneOffset":-420,"year":119},"TRANSFER_YN":"1","FORM_NM":"기안서11","MODIFY_NM":"관리자","USER_NM":"관리자","DOC_STS":"20","CO_ID":"1000","DOC_TITLE":"ㅁㄴㅇㄻㄴㅇㄹ","FORM_ID":1,"END_DT":null},{"CREATE_NM":"박재영","DOC_ID":86,"DEPT_ID":"2680","MODIFY_DT":{"date":6,"day":5,"hours":17,"minutes":16,"month":8,"nanos":0,"seconds":36,"time":1567764996000,"timezoneOffset":-420,"year":119},"FORM_MODE":"1","USER_ID":"2678","CREATED_DT":{"date":18,"day":2,"hours":15,"minutes":26,"month":5,"nanos":0,"seconds":13,"time":1560846373000,"timezoneOffset":-420,"year":119},"DOC_NO":"","DOC_STSNM":"상신","DEPT_NM":"테스트부서","REP_DT":{"date":18,"day":2,"hours":15,"minutes":26,"month":5,"nanos":0,"seconds":13,"time":1560846373000,"timezoneOffset":-420,"year":119},"TRANSFER_YN":"1","FORM_NM":"재영 로컬 양식","MODIFY_NM":"이소영","USER_NM":"박재영","DOC_STS":"20","CO_ID":"2676","DOC_TITLE":"ㅅㅅㅅㅅ","FORM_ID":24,"END_DT":null},{"CREATE_NM":"조르바","DOC_ID":99,"DEPT_ID":"2433","MODIFY_DT":{"date":4,"day":1,"hours":9,"minutes":27,"month":0,"nanos":0,"seconds":54,"time":1609727274000,"timezoneOffset":-420,"year":121},"FORM_MODE":"1","USER_ID":"2435","CREATED_DT":{"date":19,"day":3,"hours":11,"minutes":48,"month":5,"nanos":0,"seconds":17,"time":1560919697000,"timezoneOffset":-420,"year":119},"DOC_NO":"","DOC_STSNM":"임시저장","DEPT_NM":"올림푸스","REP_DT":{"date":19,"day":3,"hours":11,"minutes":48,"month":5,"nanos":0,"seconds":17,"time":1560919697000,"timezoneOffset":-420,"year":119},"TRANSFER_YN":"1","FORM_NM":"조퇴사유서","MODIFY_NM":"조르바","USER_NM":"조르바","DOC_STS":"10","CO_ID":"1410","DOC_TITLE":"aaaa","FORM_ID":11,"END_DT":null},{"CREATE_NM":"박재영","DOC_ID":100,"DEPT_ID":"2680","MODIFY_DT":{"date":6,"day":5,"hours":17,"minutes":16,"month":8,"nanos":0,"seconds":36,"time":1567764996000,"timezoneOffset":-420,"year":119},"FORM_MODE":"1","USER_ID":"2678","CREATED_DT":{"date":19,"day":3,"hours":13,"minutes":29,"month":5,"nanos":0,"seconds":36,"time":1560925776000,"timezoneOffset":-420,"year":119},"DOC_NO":"","DOC_STSNM":"상신","DEPT_NM":"테스트부서","REP_DT":{"date":19,"day":3,"hours":13,"minutes":29,"month":5,"nanos":0,"seconds":36,"time":1560925776000,"timezoneOffset":-420,"year":119},"TRANSFER_YN":"1","FORM_NM":"재영 로컬 양식","MODIFY_NM":"이소영","USER_NM":"박재영","DOC_STS":"20","CO_ID":"2676","DOC_TITLE":"결재롤 테스트","FORM_ID":24,"END_DT":null},{"CREATE_NM":"관리자","DOC_ID":102,"DEPT_ID":"1110","MODIFY_DT":{"date":19,"day":3,"hours":17,"minutes":33,"month":5,"nanos":0,"seconds":10,"time":1560940390000,"timezoneOffset":-420,"year":119},"FORM_MODE":"1","USER_ID":"1","CREATED_DT":{"date":19,"day":3,"hours":17,"minutes":33,"month":5,"nanos":0,"seconds":10,"time":1560940390000,"timezoneOffset":-420,"year":119},"DOC_NO":"","DOC_STSNM":"상신","DEPT_NM":"관리팀","REP_DT":{"date":19,"day":3,"hours":17,"minutes":33,"month":5,"nanos":0,"seconds":10,"time":1560940390000,"timezoneOffset":-420,"year":119},"TRANSFER_YN":"1","FORM_NM":"조퇴사유서","MODIFY_NM":"관리자","USER_NM":"관리자","DOC_STS":"20","CO_ID":"1000","DOC_TITLE":"asdfasdf","FORM_ID":11,"END_DT":null},{"CREATE_NM":"김영조","DOC_ID":108,"DEPT_ID":"1110","MODIFY_DT":{"date":21,"day":5,"hours":9,"minutes":53,"month":5,"nanos":0,"seconds":28,"time":1561085608000,"timezoneOffset":-420,"year":119},"FORM_MODE":"1","USER_ID":"1237","CREATED_DT":{"date":21,"day":5,"hours":9,"minutes":53,"month":5,"nanos":0,"seconds":28,"time":1561085608000,"timezoneOffset":-420,"year":119},"DOC_NO":null,"DOC_STSNM":null,"DEPT_NM":"관리팀","REP_DT":{"date":21,"day":5,"hours":9,"minutes":53,"month":5,"nanos":0,"seconds":28,"time":1561085608000,"timezoneOffset":-420,"year":119},"TRANSFER_YN":"1","FORM_NM":"휴가신청서_test","MODIFY_NM":"kimyj","USER_NM":"김영조","DOC_STS":null,"CO_ID":"1000","DOC_TITLE":"ㅁ","FORM_ID":18,"END_DT":null},{"CREATE_NM":"김영조","DOC_ID":110,"DEPT_ID":"1110","MODIFY_DT":{"date":21,"day":5,"hours":10,"minutes":0,"month":5,"nanos":0,"seconds":9,"time":1561086009000,"timezoneOffset":-420,"year":119},"FORM_MODE":"1","USER_ID":"1237","CREATED_DT":{"date":21,"day":5,"hours":10,"minutes":0,"month":5,"nanos":0,"seconds":9,"time":1561086009000,"timezoneOffset":-420,"year":119},"DOC_NO":null,"DOC_STSNM":null,"DEPT_NM":"관리팀","REP_DT":{"date":21,"day":5,"hours":10,"minutes":0,"month":5,"nanos":0,"seconds":9,"time":1561086009000,"timezoneOffset":-420,"year":119},"TRANSFER_YN":"1","FORM_NM":"휴가신청서_test","MODIFY_NM":"kimyj","USER_NM":"김영조","DOC_STS":null,"CO_ID":"1000","DOC_TITLE":"ㅁ","FORM_ID":18,"END_DT":null},{"CREATE_NM":"김영조","DOC_ID":111,"DEPT_ID":"1110","MODIFY_DT":{"date":21,"day":5,"hours":10,"minutes":0,"month":5,"nanos":0,"seconds":22,"time":1561086022000,"timezoneOffset":-420,"year":119},"FORM_MODE":"1","USER_ID":"1237","CREATED_DT":{"date":21,"day":5,"hours":10,"minutes":0,"month":5,"nanos":0,"seconds":22,"time":1561086022000,"timezoneOffset":-420,"year":119},"DOC_NO":null,"DOC_STSNM":null,"DEPT_NM":"관리팀","REP_DT":{"date":21,"day":5,"hours":10,"minutes":0,"month":5,"nanos":0,"seconds":22,"time":1561086022000,"timezoneOffset":-420,"year":119},"TRANSFER_YN":"1","FORM_NM":"휴가신청서_test","MODIFY_NM":"kimyj","USER_NM":"김영조","DOC_STS":null,"CO_ID":"1000","DOC_TITLE":"ㅁ","FORM_ID":18,"END_DT":null},{"CREATE_NM":"퀘투오1000","DOC_ID":194,"DEPT_ID":"2642","MODIFY_DT":{"date":3,"day":3,"hours":14,"minutes":27,"month":6,"nanos":0,"seconds":59,"time":1562138879000,"timezoneOffset":-420,"year":119},"FORM_MODE":"1","USER_ID":"2644","CREATED_DT":{"date":3,"day":3,"hours":14,"minutes":27,"month":6,"nanos":0,"seconds":59,"time":1562138879000,"timezoneOffset":-420,"year":119},"DOC_NO":null,"DOC_STSNM":null,"DEPT_NM":"개발부","REP_DT":{"date":3,"day":3,"hours":14,"minutes":27,"month":6,"nanos":0,"seconds":59,"time":1562138879000,"timezoneOffset":-420,"year":119},"TRANSFER_YN":"1","FORM_NM":"휴가신청서_test","MODIFY_NM":"퀘투오","USER_NM":"퀘투오1000","DOC_STS":null,"CO_ID":"2451","DOC_TITLE":"124","FORM_ID":18,"END_DT":null},{"CREATE_NM":"손희경","DOC_ID":498,"DEPT_ID":"10798","MODIFY_DT":{"date":28,"day":1,"hours":11,"minutes":41,"month":11,"nanos":0,"seconds":5,"time":1609130465000,"timezoneOffset":-420,"year":120},"FORM_MODE":"1","USER_ID":"10799","CREATED_DT":{"date":28,"day":1,"hours":11,"minutes":41,"month":11,"nanos":0,"seconds":5,"time":1609130465000,"timezoneOffset":-420,"year":120},"DOC_NO":null,"DOC_STSNM":null,"DEPT_NM":"경인의원팀","REP_DT":{"date":28,"day":1,"hours":11,"minutes":41,"month":11,"nanos":0,"seconds":5,"time":1609130465000,"timezoneOffset":-420,"year":120},"TRANSFER_YN":"1","FORM_NM":"휴가신청서_test","MODIFY_NM":"손희경","USER_NM":"손희경","DOC_STS":null,"CO_ID":"10766","DOC_TITLE":"sdfds","FORM_ID":18,"END_DT":null},{"CREATE_NM":"김근영","DOC_ID":864,"DEPT_ID":"10767","MODIFY_DT":{"date":11,"day":1,"hours":11,"minutes":27,"month":0,"nanos":0,"seconds":39,"time":1610339259000,"timezoneOffset":-420,"year":121},"FORM_MODE":"1","USER_ID":"10769","CREATED_DT":{"date":11,"day":1,"hours":11,"minutes":27,"month":0,"nanos":0,"seconds":14,"time":1610339234000,"timezoneOffset":-420,"year":121},"DOC_NO":"근영회사-근영부서-21-276","DOC_STSNM":"종결","DEPT_NM":"근영부서","REP_DT":{"date":11,"day":1,"hours":11,"minutes":27,"month":0,"nanos":0,"seconds":0,"time":1610339220000,"timezoneOffset":-420,"year":121},"TRANSFER_YN":"1","FORM_NM":"UBA테스트양식","MODIFY_NM":"김근영","USER_NM":"김근영","DOC_STS":"90","CO_ID":"10766","DOC_TITLE":"문서수동이관테스트7","FORM_ID":63,"END_DT":{"date":11,"day":1,"hours":11,"minutes":27,"month":0,"nanos":0,"seconds":39,"time":1610339259000,"timezoneOffset":-420,"year":121}},{"CREATE_NM":"김근영","DOC_ID":926,"DEPT_ID":"10767","MODIFY_DT":{"date":12,"day":2,"hours":10,"minutes":26,"month":0,"nanos":0,"seconds":38,"time":1610421998000,"timezoneOffset":-420,"year":121},"FORM_MODE":"1","USER_ID":"10769","CREATED_DT":{"date":12,"day":2,"hours":10,"minutes":19,"month":0,"nanos":0,"seconds":4,"time":1610421544000,"timezoneOffset":-420,"year":121},"DOC_NO":"근영회사-근영부서-21-324","DOC_STSNM":"종결","DEPT_NM":"근영부서","REP_DT":{"date":12,"day":2,"hours":10,"minutes":18,"month":0,"nanos":0,"seconds":0,"time":1610421480000,"timezoneOffset":-420,"year":121},"TRANSFER_YN":"1","FORM_NM":"UBA테스트양식","MODIFY_NM":"김근영","USER_NM":"김근영","DOC_STS":"90","CO_ID":"10766","DOC_TITLE":"문서수동이관테스트10","FORM_ID":63,"END_DT":{"date":12,"day":2,"hours":10,"minutes":26,"month":0,"nanos":0,"seconds":38,"time":1610421998000,"timezoneOffset":-420,"year":121}},{"CREATE_NM":"김근영","DOC_ID":933,"DEPT_ID":"10767","MODIFY_DT":{"date":12,"day":2,"hours":10,"minutes":26,"month":0,"nanos":0,"seconds":36,"time":1610421996000,"timezoneOffset":-420,"year":121},"FORM_MODE":"1","USER_ID":"10769","CREATED_DT":{"date":12,"day":2,"hours":10,"minutes":19,"month":0,"nanos":0,"seconds":5,"time":1610421545000,"timezoneOffset":-420,"year":121},"DOC_NO":"근영회사-근영부서-21-317","DOC_STSNM":"종결","DEPT_NM":"근영부서","REP_DT":{"date":12,"day":2,"hours":10,"minutes":18,"month":0,"nanos":0,"seconds":0,"time":1610421480000,"timezoneOffset":-420,"year":121},"TRANSFER_YN":"1","FORM_NM":"UBA테스트양식","MODIFY_NM":"김근영","USER_NM":"김근영","DOC_STS":"90","CO_ID":"10766","DOC_TITLE":"문서수동이관테스트10","FORM_ID":63,"END_DT":{"date":12,"day":2,"hours":10,"minutes":26,"month":0,"nanos":0,"seconds":36,"time":1610421996000,"timezoneOffset":-420,"year":121}},{"CREATE_NM":"김근영","DOC_ID":935,"DEPT_ID":"10767","MODIFY_DT":{"date":12,"day":2,"hours":10,"minutes":26,"month":0,"nanos":0,"seconds":35,"time":1610421995000,"timezoneOffset":-420,"year":121},"FORM_MODE":"1","USER_ID":"10769","CREATED_DT":{"date":12,"day":2,"hours":10,"minutes":19,"month":0,"nanos":0,"seconds":5,"time":1610421545000,"timezoneOffset":-420,"year":121},"DOC_NO":"근영회사-근영부서-21-315","DOC_STSNM":"종결","DEPT_NM":"근영부서","REP_DT":{"date":12,"day":2,"hours":10,"minutes":18,"month":0,"nanos":0,"seconds":0,"time":1610421480000,"timezoneOffset":-420,"year":121},"TRANSFER_YN":"1","FORM_NM":"UBA테스트양식","MODIFY_NM":"김근영","USER_NM":"김근영","DOC_STS":"90","CO_ID":"10766","DOC_TITLE":"문서수동이관테스트10","FORM_ID":63,"END_DT":{"date":12,"day":2,"hours":10,"minutes":26,"month":0,"nanos":0,"seconds":35,"time":1610421995000,"timezoneOffset":-420,"year":121}},{"CREATE_NM":"김영조","DOC_ID":936,"DEPT_ID":"1100","MODIFY_DT":{"date":29,"day":5,"hours":15,"minutes":44,"month":0,"nanos":0,"seconds":22,"time":1611909862000,"timezoneOffset":-420,"year":121},"FORM_MODE":"1","USER_ID":"1416","CREATED_DT":{"date":12,"day":2,"hours":11,"minutes":11,"month":0,"nanos":0,"seconds":4,"time":1610424664000,"timezoneOffset":-420,"year":121},"DOC_NO":"","DOC_STSNM":"상신","DEPT_NM":"관리부","REP_DT":{"date":12,"day":2,"hours":11,"minutes":11,"month":0,"nanos":0,"seconds":4,"time":1610424664000,"timezoneOffset":-420,"year":121},"TRANSFER_YN":"1","FORM_NM":"정유민 양식","MODIFY_NM":"김영조","USER_NM":"김영조","DOC_STS":"20","CO_ID":"1000","DOC_TITLE":"<img onerror=alert(1) />","FORM_ID":29,"END_DT":null},{"CREATE_NM":"김근영","DOC_ID":1000,"DEPT_ID":"10767","MODIFY_DT":{"date":25,"day":1,"hours":16,"minutes":28,"month":0,"nanos":0,"seconds":34,"time":1611566914000,"timezoneOffset":-420,"year":121},"FORM_MODE":"1","USER_ID":"10769","CREATED_DT":{"date":25,"day":1,"hours":16,"minutes":27,"month":0,"nanos":0,"seconds":10,"time":1611566830000,"timezoneOffset":-420,"year":121},"DOC_NO":"","DOC_STSNM":"진행","DEPT_NM":"근영부서","REP_DT":{"date":25,"day":1,"hours":16,"minutes":27,"month":0,"nanos":0,"seconds":0,"time":1611566820000,"timezoneOffset":-420,"year":121},"TRANSFER_YN":"1","FORM_NM":"11서버테스트용","MODIFY_NM":"김근영","USER_NM":"김근영","DOC_STS":"30","CO_ID":"10766","DOC_TITLE":"결재 수정 테스트3","FORM_ID":64,"END_DT":null},{"CREATE_NM":"김근영","DOC_ID":1006,"DEPT_ID":"10767","MODIFY_DT":{"date":26,"day":2,"hours":14,"minutes":29,"month":0,"nanos":0,"seconds":43,"time":1611646183000,"timezoneOffset":-420,"year":121},"FORM_MODE":"1","USER_ID":"10769","CREATED_DT":{"date":26,"day":2,"hours":13,"minutes":56,"month":0,"nanos":0,"seconds":27,"time":1611644187000,"timezoneOffset":-420,"year":121},"DOC_NO":"","DOC_STSNM":"진행","DEPT_NM":"근영부서","REP_DT":{"date":26,"day":2,"hours":13,"minutes":56,"month":0,"nanos":0,"seconds":0,"time":1611644160000,"timezoneOffset":-420,"year":121},"TRANSFER_YN":"1","FORM_NM":"11서버테스트용","MODIFY_NM":"김근영","USER_NM":"김근영","DOC_STS":"30","CO_ID":"10766","DOC_TITLE":"내용수정 알람 테스트","FORM_ID":64,"END_DT":null},{"CREATE_NM":"김근영","DOC_ID":1090,"DEPT_ID":"10767","MODIFY_DT":{"date":16,"day":2,"hours":17,"minutes":47,"month":1,"nanos":0,"seconds":3,"time":1613472423000,"timezoneOffset":-420,"year":121},"FORM_MODE":"1","USER_ID":"10769","CREATED_DT":{"date":16,"day":2,"hours":17,"minutes":47,"month":1,"nanos":0,"seconds":3,"time":1613472423000,"timezoneOffset":-420,"year":121},"DOC_NO":"근영회사-근영부서-21-402","DOC_STSNM":"상신","DEPT_NM":"근영부서","REP_DT":{"date":16,"day":2,"hours":17,"minutes":44,"month":1,"nanos":0,"seconds":0,"time":1613472240000,"timezoneOffset":-420,"year":121},"TRANSFER_YN":"1","FORM_NM":"UBA테스트양식","MODIFY_NM":"김근영","USER_NM":"김근영","DOC_STS":"20","CO_ID":"10766","DOC_TITLE":"수신참조 중복 테스트","FORM_ID":63,"END_DT":null},{"CREATE_NM":"김근영","DOC_ID":1092,"DEPT_ID":"10767","MODIFY_DT":{"date":17,"day":3,"hours":11,"minutes":38,"month":1,"nanos":0,"seconds":5,"time":1613536685000,"timezoneOffset":-420,"year":121},"FORM_MODE":"1","USER_ID":"10769","CREATED_DT":{"date":17,"day":3,"hours":11,"minutes":38,"month":1,"nanos":0,"seconds":5,"time":1613536685000,"timezoneOffset":-420,"year":121},"DOC_NO":"근영회사-근영부서-21-404","DOC_STSNM":"상신","DEPT_NM":"근영부서","REP_DT":{"date":17,"day":3,"hours":11,"minutes":37,"month":1,"nanos":0,"seconds":0,"time":1613536620000,"timezoneOffset":-420,"year":121},"TRANSFER_YN":"1","FORM_NM":"UBA테스트양식","MODIFY_NM":"김근영","USER_NM":"김근영","DOC_STS":"20","CO_ID":"10766","DOC_TITLE":"ㅅㄷㄴㅅ2","FORM_ID":63,"END_DT":null},{"CREATE_NM":"윤성준","DOC_ID":1108,"DEPT_ID":"1305","MODIFY_DT":{"date":4,"day":4,"hours":14,"minutes":53,"month":2,"nanos":0,"seconds":45,"time":1614844425000,"timezoneOffset":-420,"year":121},"FORM_MODE":"1","USER_ID":"1409","CREATED_DT":{"date":4,"day":4,"hours":14,"minutes":47,"month":2,"nanos":0,"seconds":57,"time":1614844077000,"timezoneOffset":-420,"year":121},"DOC_NO":"데모서버-2021-0013","DOC_STSNM":"상신","DEPT_NM":"기획부","REP_DT":{"date":4,"day":4,"hours":14,"minutes":45,"month":2,"nanos":0,"seconds":0,"time":1614843900000,"timezoneOffset":-420,"year":121},"TRANSFER_YN":"1","FORM_NM":"사직서","MODIFY_NM":"솔류션사업부문-솔루션개발본부-개발1센터-솔루션개발2Unit-DOCCell-윤성준","USER_NM":"윤성준","DOC_STS":"20","CO_ID":"1000","DOC_TITLE":"테스트상신","FORM_ID":15,"END_DT":null},{"CREATE_NM":"김근영","DOC_ID":1309,"DEPT_ID":"10767","MODIFY_DT":{"date":12,"day":1,"hours":13,"minutes":49,"month":3,"nanos":0,"seconds":8,"time":1618210148000,"timezoneOffset":-420,"year":121},"FORM_MODE":"1","USER_ID":"10769","CREATED_DT":{"date":12,"day":1,"hours":13,"minutes":49,"month":3,"nanos":0,"seconds":8,"time":1618210148000,"timezoneOffset":-420,"year":121},"DOC_NO":"2021-근영부서-21","DOC_STSNM":"상신","DEPT_NM":"근영부서","REP_DT":{"date":12,"day":1,"hours":13,"minutes":48,"month":3,"nanos":0,"seconds":0,"time":1618210080000,"timezoneOffset":-420,"year":121},"TRANSFER_YN":"1","FORM_NM":"UBA테스트양식","MODIFY_NM":"김근영","USER_NM":"김근영","DOC_STS":"20","CO_ID":"10766","DOC_TITLE":"채번중복","FORM_ID":63,"END_DT":null},{"CREATE_NM":"김근영","DOC_ID":1519,"DEPT_ID":"10767","MODIFY_DT":{"date":12,"day":1,"hours":14,"minutes":17,"month":3,"nanos":0,"seconds":8,"time":1618211828000,"timezoneOffset":-420,"year":121},"FORM_MODE":"1","USER_ID":"10769","CREATED_DT":{"date":12,"day":1,"hours":14,"minutes":17,"month":3,"nanos":0,"seconds":8,"time":1618211828000,"timezoneOffset":-420,"year":121},"DOC_NO":"근영회사2-근영부서-21-108","DOC_STSNM":"상신","DEPT_NM":"근영부서","REP_DT":{"date":12,"day":1,"hours":14,"minutes":17,"month":3,"nanos":0,"seconds":0,"time":1618211820000,"timezoneOffset":-420,"year":121},"TRANSFER_YN":"1","FORM_NM":"UBA테스트양식","MODIFY_NM":"김근영","USER_NM":"김근영","DOC_STS":"20","CO_ID":"10766","DOC_TITLE":"채번테스트1","FORM_ID":63,"END_DT":null},{"CREATE_NM":"김근영","DOC_ID":1529,"DEPT_ID":"10767","MODIFY_DT":{"date":12,"day":1,"hours":14,"minutes":17,"month":3,"nanos":0,"seconds":12,"time":1618211832000,"timezoneOffset":-420,"year":121},"FORM_MODE":"1","USER_ID":"10769","CREATED_DT":{"date":12,"day":1,"hours":14,"minutes":17,"month":3,"nanos":0,"seconds":12,"time":1618211832000,"timezoneOffset":-420,"year":121},"DOC_NO":"근영회사2-근영부서-21-118","DOC_STSNM":"상신","DEPT_NM":"근영부서","REP_DT":{"date":12,"day":1,"hours":14,"minutes":17,"month":3,"nanos":0,"seconds":0,"time":1618211820000,"timezoneOffset":-420,"year":121},"TRANSFER_YN":"1","FORM_NM":"UBA테스트양식","MODIFY_NM":"김근영","USER_NM":"김근영","DOC_STS":"20","CO_ID":"10766","DOC_TITLE":"채번테스트1","FORM_ID":63,"END_DT":null},{"CREATE_NM":"김근영","DOC_ID":1565,"DEPT_ID":"10767","MODIFY_DT":{"date":12,"day":1,"hours":14,"minutes":19,"month":3,"nanos":0,"seconds":2,"time":1618211942000,"timezoneOffset":-420,"year":121},"FORM_MODE":"1","USER_ID":"10769","CREATED_DT":{"date":12,"day":1,"hours":14,"minutes":19,"month":3,"nanos":0,"seconds":2,"time":1618211942000,"timezoneOffset":-420,"year":121},"DOC_NO":"근영회사2-근영부서-21-17채번","DOC_STSNM":"상신","DEPT_NM":"근영부서","REP_DT":{"date":12,"day":1,"hours":14,"minutes":18,"month":3,"nanos":0,"seconds":0,"time":1618211880000,"timezoneOffset":-420,"year":121},"TRANSFER_YN":"1","FORM_NM":"UBA테스트양식","MODIFY_NM":"김근영","USER_NM":"김근영","DOC_STS":"20","CO_ID":"10766","DOC_TITLE":"채번테스트1","FORM_ID":63,"END_DT":null},{"CREATE_NM":"김코더씨","DOC_ID":1595,"DEPT_ID":"10767","MODIFY_DT":{"date":12,"day":1,"hours":14,"minutes":19,"month":3,"nanos":0,"seconds":34,"time":1618211974000,"timezoneOffset":-420,"year":121},"FORM_MODE":"1","USER_ID":"10776","CREATED_DT":{"date":12,"day":1,"hours":14,"minutes":19,"month":3,"nanos":0,"seconds":34,"time":1618211974000,"timezoneOffset":-420,"year":121},"DOC_NO":"","DOC_STSNM":"상신","DEPT_NM":"근영부서","REP_DT":{"date":12,"day":1,"hours":14,"minutes":18,"month":3,"nanos":0,"seconds":0,"time":1618211880000,"timezoneOffset":-420,"year":121},"TRANSFER_YN":"1","FORM_NM":"UBA테스트양식","MODIFY_NM":"김코더씨","USER_NM":"김코더씨","DOC_STS":"20","CO_ID":"10766","DOC_TITLE":"채번테스트3","FORM_ID":63,"END_DT":null},{"CREATE_NM":"kim","DOC_ID":1746,"DEPT_ID":"10800","MODIFY_DT":{"date":17,"day":1,"hours":19,"minutes":29,"month":4,"nanos":0,"seconds":36,"time":1621254576000,"timezoneOffset":-420,"year":121},"FORM_MODE":"1","USER_ID":"10768","CREATED_DT":{"date":12,"day":1,"hours":16,"minutes":26,"month":3,"nanos":0,"seconds":29,"time":1618219589000,"timezoneOffset":-420,"year":121},"DOC_NO":"근영회사2-근영부서-21-69채번","DOC_STSNM":"상신","DEPT_NM":"경인의원팀","REP_DT":{"date":12,"day":1,"hours":16,"minutes":25,"month":3,"nanos":0,"seconds":0,"time":1618219500000,"timezoneOffset":-420,"year":121},"TRANSFER_YN":"1","FORM_NM":"UBA테스트양식","MODIFY_NM":"김근영","USER_NM":"kim","DOC_STS":"20","CO_ID":"10766","DOC_TITLE":"sdfsadfsadfsdf","FORM_ID":63,"END_DT":null},{"CREATE_NM":"김근영","DOC_ID":1753,"DEPT_ID":"10767","MODIFY_DT":{"date":12,"day":1,"hours":16,"minutes":29,"month":3,"nanos":0,"seconds":37,"time":1618219777000,"timezoneOffset":-420,"year":121},"FORM_MODE":"1","USER_ID":"10769","CREATED_DT":{"date":12,"day":1,"hours":16,"minutes":29,"month":3,"nanos":0,"seconds":37,"time":1618219777000,"timezoneOffset":-420,"year":121},"DOC_NO":"","DOC_STSNM":"상신","DEPT_NM":"근영부서","REP_DT":{"date":12,"day":1,"hours":16,"minutes":29,"month":3,"nanos":0,"seconds":0,"time":1618219740000,"timezoneOffset":-420,"year":121},"TRANSFER_YN":"1","FORM_NM":"UBA테스트양식","MODIFY_NM":"김근영","USER_NM":"김근영","DOC_STS":"20","CO_ID":"10766","DOC_TITLE":"채번테스트1","FORM_ID":63,"END_DT":null},{"CREATE_NM":"kim","DOC_ID":1826,"DEPT_ID":"10800","MODIFY_DT":{"date":17,"day":1,"hours":19,"minutes":29,"month":4,"nanos":0,"seconds":36,"time":1621254576000,"timezoneOffset":-420,"year":121},"FORM_MODE":"1","USER_ID":"10768","CREATED_DT":{"date":12,"day":1,"hours":16,"minutes":35,"month":3,"nanos":0,"seconds":15,"time":1618220115000,"timezoneOffset":-420,"year":121},"DOC_NO":"근영회사2-근영부서-21-100채번","DOC_STSNM":"상신","DEPT_NM":"경인의원팀","REP_DT":{"date":12,"day":1,"hours":16,"minutes":35,"month":3,"nanos":0,"seconds":0,"time":1618220100000,"timezoneOffset":-420,"year":121},"TRANSFER_YN":"1","FORM_NM":"UBA테스트양식","MODIFY_NM":"김근영","USER_NM":"kim","DOC_STS":"20","CO_ID":"10766","DOC_TITLE":"테스트2","FORM_ID":63,"END_DT":null},{"CREATE_NM":"김근영","DOC_ID":2210,"DEPT_ID":"10767","MODIFY_DT":{"date":13,"day":2,"hours":12,"minutes":56,"month":3,"nanos":0,"seconds":12,"time":1618293372000,"timezoneOffset":-420,"year":121},"FORM_MODE":"1","USER_ID":"10769","CREATED_DT":{"date":13,"day":2,"hours":12,"minutes":52,"month":3,"nanos":0,"seconds":15,"time":1618293135000,"timezoneOffset":-420,"year":121},"DOC_NO":"근영회사2-근영부서-21-0채번","DOC_STSNM":"종결","DEPT_NM":"근영부서","REP_DT":{"date":13,"day":2,"hours":12,"minutes":52,"month":3,"nanos":0,"seconds":0,"time":1618293120000,"timezoneOffset":-420,"year":121},"TRANSFER_YN":"1","FORM_NM":"UBA테스트양식","MODIFY_NM":"김근영","USER_NM":"김근영","DOC_STS":"90","CO_ID":"10766","DOC_TITLE":"일괄결재테스트","FORM_ID":63,"END_DT":{"date":13,"day":2,"hours":12,"minutes":56,"month":3,"nanos":0,"seconds":12,"time":1618293372000,"timezoneOffset":-420,"year":121}},{"CREATE_NM":"김근영","DOC_ID":2252,"DEPT_ID":"10767","MODIFY_DT":{"date":13,"day":2,"hours":13,"minutes":5,"month":3,"nanos":0,"seconds":5,"time":1618293905000,"timezoneOffset":-420,"year":121},"FORM_MODE":"1","USER_ID":"10769","CREATED_DT":{"date":13,"day":2,"hours":13,"minutes":5,"month":3,"nanos":0,"seconds":5,"time":1618293905000,"timezoneOffset":-420,"year":121},"DOC_NO":"","DOC_STSNM":"상신","DEPT_NM":"근영부서","REP_DT":{"date":13,"day":2,"hours":13,"minutes":4,"month":3,"nanos":0,"seconds":0,"time":1618293840000,"timezoneOffset":-420,"year":121},"TRANSFER_YN":"1","FORM_NM":"UBA테스트양식","MODIFY_NM":"김근영","USER_NM":"김근영","DOC_STS":"20","CO_ID":"10766","DOC_TITLE":"일괄결재 채번테스트","FORM_ID":63,"END_DT":null},{"CREATE_NM":"김근영","DOC_ID":2288,"DEPT_ID":"10767","MODIFY_DT":{"date":13,"day":2,"hours":13,"minutes":57,"month":3,"nanos":0,"seconds":16,"time":1618297036000,"timezoneOffset":-420,"year":121},"FORM_MODE":"1","USER_ID":"10769","CREATED_DT":{"date":13,"day":2,"hours":13,"minutes":57,"month":3,"nanos":0,"seconds":16,"time":1618297036000,"timezoneOffset":-420,"year":121},"DOC_NO":"","DOC_STSNM":"상신","DEPT_NM":"근영부서","REP_DT":{"date":13,"day":2,"hours":13,"minutes":57,"month":3,"nanos":0,"seconds":0,"time":1618297020000,"timezoneOffset":-420,"year":121},"TRANSFER_YN":"1","FORM_NM":"UBA테스트양식","MODIFY_NM":"김근영","USER_NM":"김근영","DOC_STS":"20","CO_ID":"10766","DOC_TITLE":"결재 테스트","FORM_ID":63,"END_DT":null},{"CREATE_NM":"김코더씨","DOC_ID":2485,"DEPT_ID":"10767","MODIFY_DT":{"date":13,"day":2,"hours":14,"minutes":16,"month":3,"nanos":0,"seconds":29,"time":1618298189000,"timezoneOffset":-420,"year":121},"FORM_MODE":"1","USER_ID":"10776","CREATED_DT":{"date":13,"day":2,"hours":14,"minutes":16,"month":3,"nanos":0,"seconds":29,"time":1618298189000,"timezoneOffset":-420,"year":121},"DOC_NO":"","DOC_STSNM":"상신","DEPT_NM":"근영부서","REP_DT":{"date":13,"day":2,"hours":14,"minutes":16,"month":3,"nanos":0,"seconds":0,"time":1618298160000,"timezoneOffset":-420,"year":121},"TRANSFER_YN":"1","FORM_NM":"UBA테스트양식","MODIFY_NM":"김코더씨","USER_NM":"김코더씨","DOC_STS":"20","CO_ID":"10766","DOC_TITLE":"일괄결재 채번 중복 테스트 3번","FORM_ID":63,"END_DT":null},{"CREATE_NM":"김근영","DOC_ID":2531,"DEPT_ID":"10767","MODIFY_DT":{"date":13,"day":2,"hours":15,"minutes":31,"month":3,"nanos":0,"seconds":1,"time":1618302661000,"timezoneOffset":-420,"year":121},"FORM_MODE":"1","USER_ID":"10769","CREATED_DT":{"date":13,"day":2,"hours":15,"minutes":31,"month":3,"nanos":0,"seconds":1,"time":1618302661000,"timezoneOffset":-420,"year":121},"DOC_NO":"제2021근영회사2-62","DOC_STSNM":"상신","DEPT_NM":"근영부서","REP_DT":{"date":13,"day":2,"hours":15,"minutes":31,"month":3,"nanos":0,"seconds":0,"time":1618302660000,"timezoneOffset":-420,"year":121},"TRANSFER_YN":"1","FORM_NM":"UBA테스트양식","MODIFY_NM":"김근영","USER_NM":"김근영","DOC_STS":"20","CO_ID":"10766","DOC_TITLE":"1","FORM_ID":63,"END_DT":null},{"CREATE_NM":"김근영","DOC_ID":2615,"DEPT_ID":"10767","MODIFY_DT":{"date":19,"day":1,"hours":9,"minutes":23,"month":3,"nanos":0,"seconds":5,"time":1618798985000,"timezoneOffset":-420,"year":121},"FORM_MODE":"1","USER_ID":"10769","CREATED_DT":{"date":19,"day":1,"hours":9,"minutes":1,"month":3,"nanos":0,"seconds":14,"time":1618797674000,"timezoneOffset":-420,"year":121},"DOC_NO":"근영회사2-근영부서-21-503채번","DOC_STSNM":"상신","DEPT_NM":"근영부서","REP_DT":{"date":19,"day":1,"hours":9,"minutes":1,"month":3,"nanos":0,"seconds":0,"time":1618797660000,"timezoneOffset":-420,"year":121},"TRANSFER_YN":"1","FORM_NM":"데이트타임양식","MODIFY_NM":"김근영","USER_NM":"김근영","DOC_STS":"20","CO_ID":"10766","DOC_TITLE":"ㅎㅇㅎㅇㅎㅇ","FORM_ID":73,"END_DT":null}]
					 	// 전자결재문서 변환
						let resultData = await alphaElecDocConvert({
							selItems: JSON.stringify(sendElecDocDataList),
							selBoxs: JSON.stringify([alphaDocBoxList[i].dirCd])
						}); 
						 
						let docIdList = convertElecDocIdListToStr(sendElecDocDataList);
						
						// 전자결재문서 변환 success, fail 카운트 세팅
					  	if(resultData.result != null){
							
							let successCnt = resultData.result.successCnt;
							let failCnt = resultData.result.failCnt;
							
							if(successCnt != 0){
								processCnt += parseInt(successCnt);
								document.getElementById("processCnt").innerHTML = processCnt;
							}
							
							if(failCnt != 0){
								elecConvertFailCnt += failCnt;
								failConvertDocIdList = failConvertDocIdList.concat(docIdList.split(','));
								document.getElementById("elecConvertFailCnt").innerHTML = elecConvertFailCnt;
								failDocIdList = docIdList + ',';
							}
						}  
						
						try {
							
							// 전자결재 변환된 문서값들을 권한승인항에 insert
							let insertResultData = await alphaInsertAuthApproveViewDoc({
								docIdList: docIdList,
								suiteMenuId: alphaDocBoxList[i].suiteMenuId,
								failDocIdList: failDocIdList
							});
							
							if(insertResultData !== null){
								if(insertResultData.result != null){
													
									authDocProcessCnt += parseInt(insertResultData.authDocSuccessCnt);
									viewDocProcessCnt += parseInt(insertResultData.viewDocSuccessCnt);
									document.getElementById("authDocProcessCnt").innerHTML = authDocProcessCnt;
									document.getElementById("viewDocProcessCnt").innerHTML = viewDocProcessCnt;
								}else{
									console.error('권한승인함 및 문서뷰어 데이터 이관중 오류가 발생 1: ', insertResultData);
								}
							}else{
								console.error('권한승인함 및 문서뷰어 데이터 이관중 오류가 발생 2: ', insertResultData);
							}
						}catch(err){
							console.error('권한승인함 및 문서뷰어 데이터 이관중 오류가 발생 3: ', err);
						}
							
					}
					
					document.getElementById("failConvertDocIdList").innerHTML = failConvertDocIdList;

					
					// 가져온 전자결재 데이터가 1000개 일경우 해당 문서함의 데이터가 더 있을수도 있으므로 해당 문서함 다시 조회
					
					// 마이그레이션 중 끊겨서 재 시작 시 문서 아이디가 처음 1000개 가져온것보다 클때는 가져오지못하니 그럴경우 + 1000해서 다시 검색할수 있도록 조건 추가
					if( (elecDocListCnt >= docIdCnt || (checkRestartMig &&  elecDocListCnt !== 0 && recordSuiteDocCnt < docCount)) || (!existData && docId && processCnt === 0 && elecConvertFailCnt === 0 && recordSuiteDocCnt < docCount)){
						i--;
						recordSuiteDocCnt += 1000;
					}else{
						recordSuiteDocCnt = 0;
					}
					
					existData = false;
				}
				
				time = getCurrentDate();
				console.log('종료시간: ', time);
				document.getElementById("endTime").innerHTML = time;
				document.getElementById("elecConvertFailCnt").innerHTML = elecConvertFailCnt;
				
				alert("결재보관함 결재문서 이관 완료되었습니다. 성공 : " + processCnt + ", 실패 : " + elecConvertFailCnt);
			}else{
				alert("결재보관함 관련 테이블 백업에 실패하였습니다.");
			}
			
		});
		
		
		
		$("#commentMigStart").click(async function () { 
			
			boardCommentProcessCnt = 0; // 게시판 댓글 이관 카운트
			docCommentProcessCnt = 0; // 문서 댓글 이관 카운트
			
			document.getElementById("boardCommentProcessCnt").innerHTML = boardCommentProcessCnt;
			document.getElementById("docCommentProcessCnt").innerHTML = docCommentProcessCnt;

			let backupResult = await alphaBackupCommentTable({});
			
			if(backupResult === "1"){
				
				for(let i = 0, len = selectSuiteBoardCommentList.length; i < len; i++){
				
					let element = selectSuiteBoardCommentList[i];
					let insertResultData = null;
					
					var params = {};
					params.header = {};
					params.body = {
						    "commentPassword": "",
						    "commentSeq": "",
						    "commentType": "",
						    "companyInfo": {
						        bizSeq: "",
						        compSeq: element.compSeq,
						        deptSeq: element.deptSeq,
						        emailAddr: element.emailAddr,
						        emailDomain: element.emailDomain,
						        empSeq: element.empSeq,
						        groupSeq: groupSeq
						    },  
						    "contents": element.replyContent,
						    "depth": 1,
						    "dutyCode": element.dutyCode,
						    "empName": "",
						    "event": null,
						    "fileId": "",
						    "highGbnCode": "",
						    "langCode": langCode,
						    "middleGbnCode": "",
						    "moduleGbnCode": "board",
						    "moduleSeq": element.artSeqNo,
						    "parentCommentSeq": "",
						    "positionCode": element.positionCode,
						    "topLevelCommentSeq": "",
						    "createDate": element.createDate
						};
					
					
					insertResultData = await alphaInsertBoardDocComment(params);
					
					if(insertResultData === "0"){
						boardCommentProcessCnt++;
						document.getElementById("boardCommentProcessCnt").innerHTML = boardCommentProcessCnt;
	
					}
				}
				
				for(let i = 0, len = selectSuiteDocCommentList.length; i < len; i++){
					
					let element = selectSuiteDocCommentList[i];
					let insertResultData = null;
					
					var params = {};
					params.header = {};
					params.body = {
						    "commentPassword": "",
						    "commentSeq": "",
						    "commentType": "",
						    "companyInfo": {
						        bizSeq: "",
						        compSeq: element.compSeq,
						        deptSeq: element.deptSeq,
						        emailAddr: element.emailAddr,
						        emailDomain: element.emailDomain,
						        empSeq: element.empSeq,
						        groupSeq: groupSeq
						    },  
						    "contents": element.replyContent,
						    "depth": 1,
						    "dutyCode": element.dutyCode,
						    "empName": "",
						    "event": null,
						    "fileId": "",
						    "highGbnCode": "",
						    "langCode": langCode,
						    "middleGbnCode": "",
						    "moduleGbnCode": "doc",
						    "moduleSeq": element.artSeqNo,
						    "parentCommentSeq": "",
						    "positionCode": element.positionCode,
						    "topLevelCommentSeq": "",
						    "createDate": element.createDate
						};
					
					
					insertResultData = await alphaInsertBoardDocComment(params);
					
					if(insertResultData === "0"){
						docCommentProcessCnt++;
						document.getElementById("docCommentProcessCnt").innerHTML = docCommentProcessCnt;
	
					}
				}
				
				alert("게시판, 문서 댓글 이관 완료되었습니다.");
			}else{
				alert("게시판, 문서 댓글 테이블 백업에 실패하였습니다.");
			}
		});
		
		
		
		selectDB();
		
		$("#pass").dblclick(function () { 
			$("#dbLoginPwd").val("bizbox");
			$("#dbLoginId").val("bizbox");
		
		});
		
		let codeData = [
			{ "code_val" : "10" , "code_name" : "10" },
			{ "code_val" : "9" , "code_name" : "9" },
			{ "code_val" : "8" , "code_name" : "8" },
			{ "code_val" : "7" , "code_name" : "7" },
			{ "code_val" : "6" , "code_name" : "6" },
			{ "code_val" : "5" , "code_name" : "5" },
			{ "code_val" : "4" , "code_name" : "4" },
			{ "code_val" : "3" , "code_name" : "3" },
			{ "code_val" : "2" , "code_name" : "2" },
			{ "code_val" : "1" , "code_name" : "1" }
		];
		 
		// Pudd DataSource 매핑
		let dataSourceComboBox = new Pudd.Data.DataSource({
			data : codeData
		});
		
		Pudd( "#selectSendElecDocCnt" ).puddComboBox({
			 
			attributes : { style : "width:200px;" }// control 부모 객체 속성 설정
		,	dataSource : dataSourceComboBox
		,	dataValueField : "code_val"
		,	dataTextField : "code_name"
		,	selectedIndex : 0
		,	eventCallback : {
			"change" : function( e ) {
	 
				var puddObj = Pudd( "#selectSendElecDocCnt" ).getPuddObject();
				
				//var idx = puddObj.val();
				var idx = puddObj.node.selectedIndex;
	 
				var rowData = puddObj.getOptionRowData( idx );
				if( rowData ) {
	 
					converElecDocCnt = parseInt(rowData.code_val);
				}
			}
		}
	});
		
	});
	
	function selectDB(){
	
		var codeData = [
			{ "code_val" : "" , "code_name" : "클라우드 DB 정보" }
		,	{ "code_val" : "59.29.21.167:11433", "code_name" : "더존 IDC 서버" }
		,	{ "code_val" : "222.122.65.4:11433", "code_name" : "AONE 서버" }
		];
		 
		// Pudd DataSource 매핑
		var dataSourceComboBox = new Pudd.Data.DataSource({
		 
			data : codeData
		});
	
		 
		Pudd( "#selectCloudDB" ).puddComboBox({
		 
				attributes : { style : "width:200px;" }// control 부모 객체 속성 설정
			,	dataSource : dataSourceComboBox
			,	dataValueField : "code_val"
			,	dataTextField : "code_name"
			,	selectedIndex : 0
			,	eventCallback : {
				"change" : function( e ) {
		 
					var puddObj = Pudd( "#selectCloudDB" ).getPuddObject();
		 
					//var idx = puddObj.val();
					var idx = puddObj.node.selectedIndex;
		 
					var rowData = puddObj.getOptionRowData( idx );
					if( rowData ) {
		 
						$("#dbAddr").val(rowData.code_val);
					}
				}
			}
		});
	}
	
	// suite 정보 호출
	function suiteServerInfo() {
		var param = {};
		
		// 고객Id
		param.grpId = $("#grpId").val();

		$.ajax({
			type:"post",
			url:'<c:url value="/mig/GetSuiteServerInfo.do" />',
			datatype:"json",
			data: param,
			success:function(data){
				if(data.result != null) {
					var serverInfo = data.result;
					
					suiteInit(serverInfo);
				}
			}
			, error : function(data) {
				alert('suite 정보를 가져오는데 오류가 발생 하였습니다.');
			}
	});}
	
	// 정보 세팅
	function suiteInit(data) {
		
		// 구축 정보
		if(data.buildType == "build") {
			$('input[name="buildType"]:radio[value="build"]').prop('checked',true);
			$('input[name="buildType"]:radio[value="cloud"]').prop('checked',false);
		} else if(data.buildType == "cloud") {
			$('input[name="buildType"]:radio[value="build"]').prop('checked',false);
			$('input[name="buildType"]:radio[value="cloud"]').prop('checked',true);
		}

		// 고객코드
		$("#grpCd").val(data.grpCd);
		// 고객Id
		$("#grpId").val(data.grpId);
		// 고객명
		$("#grpNm").val(data.grpNm);
		// DB 서버 IP	
		$("#dbAddr").val(data.dbIp);
		// DB 접속 ID
		$("#dbLoginId").val(data.dbUserId);
		// DB 접속 Pass	
		$("#dbLoginPwd").val(data.dbPassword);
		// 도메인
		$("domain").val(data.domain);
	}
	
	// 연결 확인
	function connectConfirm() {
		
/* 		if(groupSeq == null || groupSeq == "") {
			alert("로그인을 먼저 하시길 바랍니다.");
			return;
		} 
*/
		// db 필수 입력값 체크
		if($('input[name="buildType"]:checked').length < 1) {
			alert("구축정보를 선택하세요");
			
			return;
		}
		
		if($("grpId").val() == "" || $("#dbAddr").val() == "" || $("#dbLoginId").val() == "" || $("#dbLoginPwd").val() == "") {				
			alert("DB접속 정보 중 입력되지 않은 항목이 존재합니다");
			
			return;
		}	
		
		
		var buildType = $('[name="buildType"]:checked').val();
		var dbName = "";
		
		if (buildType == "build") {
			dbName = "NeoBizBoxS2";
		} else if(buildType == "cloud"){
			dbName = "pangaea";
		}
		
		var param = {};
		param.grpCd = $("#grpCd").val();
		param.dbName = dbName;
		param.dbAddr = $("#dbAddr").val();
		param.dbLoginId = $("#dbLoginId").val();
		param.dbLoginPwd = $("#dbLoginPwd").val();
		
		$.ajax({
			type:"post",
			url:"<c:url value='/mig/dbConnectConfirm.do'/>",
			datatype:"json",
			data: param,
			success:function(data){
				if(data.result == 1){
					//연결확인
					$("#connectMsg").html("연결 되었습니다");
					$("#connectMsg").prop("class", "lh24 ml10 text_blue");
					$('input[type="submit"]').prop('disabled', false);
					connectCheck = true;
					
					suiteDocCount();
					SuiteSelectBoardDocComment();
				} else{
					$("#connectMsg").html("연결 되지 않았습니다")
					$("#connectMsg").prop("class", "lh24 ml10 text_red");
					connectCheck = false;
				}  
			}
			, error : function(data){
				alert('오류');
			}
		});
	}
	
	// alpha 전자결재문서 데이터 조회
	function alphaElecDocSelect(apiParams) {
		
		/* 		if(groupSeq == null || groupSeq == "") {
					alert("로그인을 먼저 하시길 바랍니다.");
					return;
				}
				
				if(!connectCheck) {
					alert("연결확인을 해주세요");
					return;
				}
		 */
		var param = {};
		param.buildType = $('[name="buildType"]:checked').val();
		param.grpId = $("#grpId").val();
		param.dbIp = $("#dbAddr").val();
		param.dbUserId = $("#dbLoginId").val();
		param.dbPassword = $("#dbLoginPwd").val();
		param.domain = $("#domain").val();
		param.recordDocCnt = apiParams.recordSuiteDocCnt;
		param.suiteMenuId = apiParams.suiteMenuId;
		param.checkRestartMig = apiParams.checkRestartMig;
		
		return new Promise((resolve, reject) => {
			
			$.ajax({
				type:"post",
				url:'<c:url value="/mig/suiteDocId.do" />',
				datatype:"json",
				data: param,
				success:function(data){
					if(data.result == "1") {
						
						elecDocDataList = data.elecDocList;
						resolve(elecDocDataList.length);
					}
				}
				, error : function(data) {
					reject(0);
					alert("오류가 발생했습니다");
				}
			});
		})
	}
	
	// 스위트 전자결재문서 변환 api 호출
	function alphaElecDocConvert(apiParams) {
		
 		if(groupSeq == null || groupSeq == "") {
			alert("로그인을 먼저 하시길 바랍니다.");
			return;
		}
		
		if(!connectCheck) {
			alert("연결확인을 해주세요");
			return;
		}
		
		return new Promise((resolve, reject) => {
			
			$.ajax({
				type:"post",
				url: serverPath + "/eap/admin/edms/EAHandTransfer.do",
				datatype:"json",
				data: apiParams,
				success:function(data){
					if(data.result != null) {
						
						resolve(data);
					}
				}
				, error : function(data) {
					reject(0);
					alert("오류가 발생했습니다");
				}
			});
		})
	}
	
	// 스위트 권한승인함, 결재보관함 문서 뷰어 데이터 이관 api 호출
	function alphaInsertAuthApproveViewDoc(apiParams) {
		
/* 		if(groupSeq == null || groupSeq == "") {
			alert("로그인을 먼저 하시길 바랍니다.");
			return;
		}
		
		if(!connectCheck) {
			alert("연결확인을 해주세요");
			return;
		} */
		
		
		var param = {};
		param.buildType = $('[name="buildType"]:checked').val();
		param.grpId = $("#grpId").val();
		param.dbIp = $("#dbAddr").val();
		param.dbUserId = $("#dbLoginId").val();
		param.dbPassword = $("#dbLoginPwd").val();
		param.domain = $("#domain").val();
		param.docIdList = apiParams.docIdList;
		param.suiteMenuId = apiParams.suiteMenuId;
		param.failDocIdList = apiParams.failDocIdList;
		
		return new Promise((resolve, reject) => {
			
			$.ajax({
				type:"post",
				url:'<c:url value="/mig/insertAuthApproveViewDoc.do"/>',
				datatype:"json",
				data: param,
				success:function(data){
					if(data.result != null) {
						
						resolve(data);
					}
				}
				, error : function(data) {
					reject(null);
					console.error('insertAuthApproveViewDoc.do ERR: ', data);
				}
			});
		})
	}	
	
	function suiteDocCount(){
		
		var param = {};
		param.buildType = $('[name="buildType"]:checked').val();
		param.grpId = $("#grpId").val();
		param.dbIp = $("#dbAddr").val();
		param.dbUserId = $("#dbLoginId").val();
		param.dbPassword = $("#dbLoginPwd").val();
		param.domain = $("#domain").val();
		
		$.ajax({
			type:"post",
			url:'<c:url value="/mig/suiteDocCount.do" />',
			datatype:"json",
			data: param,
			success:function(data){
				if(data.result == "1") {
					
					$("#suiteDoc").val(data.suiteDoc+" 건");
					$("#authApproveDoc").val(data.authApproveDoc+" 건");
					$("#viewDoc").val(data.viewDoc+" 건");

					document.getElementById("AllSuiteDocCnt").innerHTML = data.suiteDoc;
					document.getElementById("AllAuthApproveDocCnt").innerHTML = data.authApproveDoc;
					document.getElementById("AllViewDocCnt").innerHTML = data.viewDoc;

					
					docCount = data.suiteDoc;
					alphaDocBoxList = data.alphaDocumentBoxList;
									
				}
			}
			, error : function(data) {
				alert("문서 갯수를 가져오는 중 에러가 발생했습니다");
			}
		});
		
	}
	
	// DocId 리스트를 str로 변경 ex) ['1','2']
	function convertElecDocIdListToStr(list) {
		
		var returnStr = "";
		
		for(let i = 0, len = list.length; i < len; i++){
			returnStr += "'" + String(list[i].DOC_ID) + "',";
		}
		
		if(returnStr.length > 0){
			returnStr = returnStr.substring(0, returnStr.length - 1);
		}else{
			returnStr = "''";
		}
		
		return returnStr;
	}
	
	// Alpha 결재보관함 테이블 데이터 정리
	function alphaBpmTableInit(apiParams) {
		
		if(groupSeq == null || groupSeq == "") {
			alert("로그인을 먼저 하시길 바랍니다.");
			return;
		}
		
		if(!connectCheck) {
			alert("연결확인을 해주세요");
			return;
		}
		
		
		return new Promise((resolve, reject) => {
			
			$.ajax({
				type:"post",
				url:'<c:url value="/mig/cleanAlphaBpmTable.do" />',
				datatype:"json",
				data: apiParams,
				success:function(data){
					if(data.result != null) {
						
						resolve(data);
					}
				}
				, error : function(data) {
					reject(0);
					alert("cleanAlphaBpmTable api 오류가 발생했습니다");
				}
			});
		})
	}
	
	//Suite 게시판, 문서 댓글 조회
	function SuiteSelectBoardDocComment(){
		
		var param = {};
		param.buildType = $('[name="buildType"]:checked').val();
		param.grpId = $("#grpId").val();
		param.dbIp = $("#dbAddr").val();
		param.dbUserId = $("#dbLoginId").val();
		param.dbPassword = $("#dbLoginPwd").val();
		param.domain = $("#domain").val();
		
		$.ajax({
			type:"post",
			url:'<c:url value="/mig/SuiteSelectBoardDocComment.do" />',
			datatype:"json",
			data: param,
			success:function(data){
				if(data.result == "1") {
										
					document.getElementById("boardCommentCnt").value = data.selectSuiteBoardCommentList.length + ' 건';
					document.getElementById("AllBoardCommentCnt").innerHTML = data.selectSuiteBoardCommentList.length;

					document.getElementById("docCommentCnt").value = data.selectSuiteDocCommentList.length + ' 건';
					document.getElementById("AllDocCommentCnt").innerHTML = data.selectSuiteDocCommentList.length;
					
					selectSuiteBoardCommentList = data.selectSuiteBoardCommentList;
					selectSuiteDocCommentList = data.selectSuiteDocCommentList;
									
				}
			}
			, error : function(data) {
				alert("문서 갯수를 가져오는 중 에러가 발생했습니다");
			}
		});
		
	}
	
	function alphaInsertBoardDocComment(params) {

		
		return new Promise((resolve, reject) => {
			
			$.ajax({
				type:"post",
				url:'<c:url value="/mig/InsertCommentMig.do" />',
				contentType:"application/json",
				data: JSON.stringify(params),
				success:function(data){
					if(data.resultCode == "0"){
						resolve(data.resultCode);
					}else{
						reject("-1");
					}
				}
				, error : function(data) {
					reject(0);
					alert("alphaInsertBoardDocComment api 오류가 발생했습니다");
				}
			});
		})
	}
	
	function alphaBackupCommentTable(params) {

		
		return new Promise((resolve, reject) => {
			
			$.ajax({
				type:"post",
				url:'<c:url value="/mig/backupCommentTable.do" />',
				contentType:"application/json",
				data: JSON.stringify(params),
				success:function(data){
					if(data.result === "1"){
						console.log('commentBackupTableName: ', data.commentBackupTableName);
						console.log('commentCountBackupTableName: ', data.commentCountBackupTableName);

						resolve(data.result);
					}else{
						reject("-1");
					}
				}
				, error : function(data) {
					reject("-1");
					alert("alphaBackupCommentTable api 오류가 발생했습니다");
				}
			});
		})
	}
	
	function alphaBackupBpmTable() {

		var params = {};
		params.buildType = $('[name="buildType"]:checked').val();
		params.grpId = $("#grpId").val();
		params.dbIp = $("#dbAddr").val();
		params.dbUserId = $("#dbLoginId").val();
		params.dbPassword = $("#dbLoginPwd").val();
		params.domain = $("#domain").val();
		
		return new Promise((resolve, reject) => {
			
			$.ajax({
				type:"post",
				url:'<c:url value="/mig/backupBPMTable.do" />',
				contentType:"application/json",
				data: JSON.stringify(params),
				success:function(data){
					if(data.result === "1"){

						resolve(data);
					}else{
						reject("-1");
					}
				}
				, error : function(data) {
					reject("-1");
					alert("alphaBackupCommentTable api 오류가 발생했습니다");
				}
			});
		})
	}
	
	function getCurrentDate(){
		
		let today = new Date();   

		let month = today.getMonth() + 1;  // 월
		let date = today.getDate();  // 날짜
		let day = today.getDay();  // 요일
		let hours = today.getHours(); // 시
		let minutes = today.getMinutes();  // 분
		let seconds = today.getSeconds();  // 초
		
		return month + '/' + date + ' ' + hours + ':' + minutes + ':' + seconds;
	}
	
</script>

<body>
	<input type="hidden" id="domain" value="">

	<br>	
	<div class="pop_wrap" style="width:100%;">
		<div class="pop_head">
			<h1>마이그레이션</h1>
		</div>

		<!--  suite 기본정보  -->
		<div class="pop_con">
			<div class="btn_top2">
				<h2>Suite 기본정보</h2>
				<input type="button" id="test" class="puddSetup" pudd-style="float:right" value="마이그레이션 기능 테스트" />
			</div>
			<div class="com_ta">
				<table>
					<tr>
						<th>구축정보</th>
						<td colspan="3">
							<input type="radio" name="buildType" id="build" value="build" checked="checked">구축형 &nbsp;&nbsp;&nbsp;&nbsp;
							<input type="radio" name="buildType" id="cloud" value="cloud" >클라우드
						</td>
					</tr>
					<tr>
						<th>고객코드</th>
						<td colspan="3">
							<div class="posi_re">
								<input type="text" style="width:300px" name="grpId" id="grpId" required>
							</div>
						</td>
					</tr>				
					<tr>
						<th>고객명</th>
						<td>
							<div class="posi_re">
								<input type="text" style="width:300px" name="grpNm" id="grpNm" disabled>
							</div>
						</td>
						<th>고객ID</th>
						<td>
							<div class="posi_re">
								<input type="text" style="width:300px" name="grpCd" id="grpCd" disabled>
							</div>
						</td>
					</tr>
				</table>
			</div>		
		</div><!-- //pop_con -->
		
		<!--  suite DB연결  -->
		<div class="pop_con">
			<div class="btn_top2">
				<h2>Suite DB서버 연결</h2>
			</div>
			<div class="com_ta">
				<table>
					<tr>
						<th>DB 서버 IP</th>
						<td colspan="3">
							<div class="posi_re" style="float: left; margin-right: 5px;">
								<input type="text" style="width:300px" id="dbAddr" name="dbAddr" required>
							</div>
							
							<div id="selectCloudDB" class="puddSetup"></div>
							
						</td>
					</tr>
					<tr>
						<th>DB 접속 ID</th>
						<td>
							<div class="posi_re">
								<input type="text" style="width:300px" id="dbLoginId" name="dbLoginId" value="" required>
							</div>
						</td>
						<th>DB 접속 Pass</th>
						<td>
							<div class="posi_re">
								<input type="password" style="width:300px" id="dbLoginPwd" name="dbLoginPwd" value="" required>
							</div>
						</td>
					</tr>
					<tr>
						<th><div id="pass">연결확인</div></th>
						<td colspan="3" >
							<div class="controll_btn p0 fl">
								<button type="button" id="btnConnect"><span>확인</span></button>
								<span class="" id="connectMsg"></span>
							</div>
						</td>
					</tr>
				</table> 
			</div>		
		</div><!-- //pop_con -->
		
		<div class="pop_con">
			<div class="btn_top2">
				<h2>Suite 종결문서, 권한승인함, 결재보관함 문서 뷰어 데이터 갯수, 종결문서 변환 및 권한승인함, 결재보관함 문서 뷰어 데이터 이관</h2>
			</div>
			<div class="com_ta">
				<table>
					<tr>
						<th style="width: 135px">변환할 문서 갯수</th>
						<td colspan="3">
							<div id="selectSendElecDocCnt" class="puddSetup"></div>
							
						</td>
					</tr>
					
					<tr>
						<th style="width: 135px">문서 갯수</th>
						<td colspan="3">
							<div class="posi_re">
								<input type="text" style="width:300px" name="suiteDoc" id="suiteDoc" disabled>
								
							</div>
							
						</td>
					</tr>
					
					<tr>
						<th style="width: 200px">권한승인함 문서 데이터 갯수 </th>
						<td colspan="2">
							<div class="posi_re">
								<input type="text" style="width:300px" name="authApproveDoc" id="authApproveDoc" disabled>
								
							</div>
							
						</td>
					</tr>
					
					<tr>
						<th style="width: 250px">결재보관함 문서 뷰어 데이터 갯수 </th>
						<td colspan="2">
							<div class="posi_re">
								<input type="text" style="width:300px" name="viewDoc" id="viewDoc" disabled>
								
							</div>
							
						</td>
					</tr>
					
					<tr>
						<th><div id="pass">마이그레이션 시작</div></th>
						<td colspan="3" >
							<div class="controll_btn p0 fl">
								<button type="button" id="migStart"><span>시작</span></button>
								<span> &nbsp; &nbsp; &nbsp; 시작시간 : </span>
								<span id="startTime"></span>
								<span> &nbsp; &nbsp;  &nbsp; 종료시간 : </span>
								<span id="endTime"></span>
								<span> &nbsp; &nbsp;  &nbsp; 실패갯수 : </span>
								<span id="elecConvertFailCnt"></span>
							</div>
						</td>
					</tr>
					
					<tr>
						<th style="width: 135px">변환실패 문서id 리스트</th>
						<td colspan="3">
							<div class="posi_re">
								<span id="failConvertDocIdList"></span>
							</div>
						</td>
					</tr>
					
					<tr>
						<th style="width: 135px">진행상황</th>
						<td colspan="3">
							<div class="posi_re">
								<span id="processCnt">0</span> / <span id="AllSuiteDocCnt">0</span>
							</div>
						</td>
					</tr>
					
					<tr>
						<th style="width: 135px">권한승인함 진행상황</th>
						<td colspan="3">
							<div class="posi_re">
								<span id="authDocProcessCnt">0</span> / <span id="AllAuthApproveDocCnt">0</span>
							</div>
						</td>
					</tr>	
					
					<tr>
						<th style="width: 135px">문서 뷰어 진행상황</th>
						<td colspan="3">
							<div class="posi_re">
								<span id="viewDocProcessCnt">0</span> / <span id="AllViewDocCnt">0</span>
							</div>
						</td>
					</tr>		
								
					
					</tr> 
				</table>
			</div>		
		</div><!-- //pop_con -->
		
		<div class="pop_con">
			<div class="btn_top2">
				<h2>Suite 게시판, 문서 댓글 이관</h2>
			</div>
			<div class="com_ta">
				<table>
					<tr>
						<th style="width: 135px">게시판 댓글 갯수</th>
						<td colspan="3">
							<div class="posi_re">
								<input type="text" style="width:300px" name="boardCommentCnt" id="boardCommentCnt" disabled>
								
							</div>
							
						</td>
					</tr>
					
					<tr>
						<th style="width: 200px">문서 댓글 갯수 </th>
						<td colspan="2">
							<div class="posi_re">
								<input type="text" style="width:300px" name="docCommentCnt" id="docCommentCnt" disabled>
								
							</div>
							
						</td>
					</tr>
					
					<tr>
						<th><div id="pass">마이그레이션 시작</div></th>
						<td colspan="3" >
							<div class="controll_btn p0 fl">
								<button type="button" id="commentMigStart"><span>시작</span></button>
							</div>
						</td>
					</tr>
					
					<tr>
						<th style="width: 135px">게시판 댓글 진행상황</th>
						<td colspan="3">
							<div class="posi_re">
								<span id="boardCommentProcessCnt">0</span> / <span id="AllBoardCommentCnt">0</span>
							</div>
						</td>
					</tr>
					
					<tr>
						<th style="width: 135px">문서 댓글 진행상황</th>
						<td colspan="3">
							<div class="posi_re">
								<span id="docCommentProcessCnt">0</span> / <span id="AllDocCommentCnt">0</span>
							</div>
						</td>
					</tr>	
					
				</table>
			</div>		
		</div><!-- //pop_con -->
		
		
		<!--  저장  및 취소 -->
		<div class="pop_foot">
			<div class="btn_cen pt12">
				<%-- <button type="button" class="gray_btn" onclick="location.href = '<c:url value="/mig/executeMig.do" />'"><span>리로드</span></button> --%>
				<input type="button" class="gray_btn" value="다음" id="btnNext" >
			</div>
		</div><!-- //pop_foot -->
	</div><!-- //pop_wrap -->
</body>