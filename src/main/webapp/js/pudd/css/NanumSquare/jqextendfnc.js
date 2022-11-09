/**
 * <pre>
 * 1. 개요
 * 		 Jquery 확장함수 모음
 * 2. 처리내용
 * 		- BizLogic 처리 :
 *			1) 금액표시 처리
 *			2) trim() 처리
 *			3)
 * 3. 입력 Data :
 * 4. 출력 Data :
 * </pre>
 * @Method Name : ___anonymous
 * @param $
 */
(function ($) {
	/* value 금액변환 */
	$.fn.numberToAmt = function( ){
		return  this.val().replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,');
	};

	/* 금액 숫자변환 */
	$.fn.amtToNumber = function( ){
		return this.val().replace(/,/g, '');
	};	
	
	/* 파라메터 금액 변환 */
	$.fn.htmlToAmt = function(  ) {
		return this.html(this.html().replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,'));
	};
	
	/* 파라메터 숫자 변환 */
	$.fn.htmlToNumber = function(  ){
		return this.html().replace(/,/g, '');
	};
	
	/* 빈 문자 삭제 */
	$.fn.trim = function(){     
		return this.replace(/(^\s*)|(\s*$)/gi, ""); 
	}; 
	
	/* 숫자 변환 */
	AmtToNumber = function( pAmt ){
		return pAmt.toString().replace(/,/g, '');
	};
	
	/* 금액 변환 */
	NumberToAmt = function( pNumber ){
		return pNumber.toString().replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,');
	};
	
	/* 공통콤마찍기 */
	NumberWithCommas = function( pNumber ){
		return pNumber.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
	}

})(jQuery);




