/****************************************************************
 *
 * 파일명 : EgovZipPopup.js
 * 설  명 : 전자정부 공통서비스 달력 팝업 JavaScript
 *
 *    수정일      수정자     Version        Function 명
 * ------------    ---------   -------------  ----------------------------
 * 2009.03.30    이중호       1.0             최초생성
 * 2011.08.30	 이기하		  1.1			  contextpath 적용
 *
 *
 */

/**********************************************
 * 함수명 : fn_egov_ZipSearch
 * 설  명 : 우편번호찾기 팝업 호출 - form별로 이름이 다른 경우 사용
 * 인  자 : 사용할 Form 객체, 우편번호(123456), 우편번호(123-456), 주소
 * 사용법 : fn_egov_ZipSearch(frm, sZip, vZip, sAddr)
 *
 * 수정일        수정자      수정내용
 * ------        ------     -------------------
 * 2009.03.30    이중호      신규작업
 * 2011.08.30	 이기하		 contextpath 적용
 *
 */

function fn_egov_ZipSearch(frm, sZip, vZip, sAddr) {
	var retVal;

	var url = frm.zip_url.value;
	//var url ="/sym/ccm/zip/EgovCcmZipSearchPopup.do";

	var varParam = new Object();
	varParam.sZip = sZip.value;
	// IE
	//var openParam = "dialogWidth:500px;dialogHeight:325px;scroll:no;status:no;center:yes;resizable:yes;";
	// FIREFOX
	//var openParam = "dialogWidth:700px;dialogHeight:365px;scroll:no;status:no;center:yes;resizable:yes;";
 
	var openParam = "dialogWidth:380px;dialogHeight:120px;scroll:no;status:no;center:yes;resizable:no;";
	retVal = window.showModalDialog(url, varParam, openParam);

	if(retVal) {
		sZip.value  = retVal.sZip;
		vZip.value  = retVal.vZip;
		sAddr.value = retVal.sAddr;
	}
}

function zipSearchPoup(frm, sZip, vZip, sAddr) {
	var retVal;
	var url = frm.zip_url.value;
	var varParam = new Object();
	var zip1 = "" ;
	var zip2 = "" ; 
	var zip = "" ;
	var openParam = "dialogWidth:380px;dialogHeight:120px;scroll:no;status:no;center:yes;resizable:no;";
	retVal = window.showModalDialog(url, varParam, openParam);

	if(retVal) {
		zip = retVal.sZip ;
		if( zip.length  == 6 ) {
			zip1 = zip.substring(0,3);
			zip2 = zip.substring(3,6);
		}else {
			zip1 = retVal.sZip ;
			zip2 = retVal.vZip ;
		}
		sZip.value  = zip1;
		vZip.value  = zip2;
		sAddr.value = retVal.sAddr;
		
	}
} 
