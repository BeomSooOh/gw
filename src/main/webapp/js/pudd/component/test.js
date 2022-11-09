/**
* @projectDescription PUDD( 가칭 ) Component TEST
*
* @author 임헌용 ( 더존비즈온 UC개발본부 UC개발센터 UC개발1팀 )
* @version PUDD 0.0.0 ( 개발 버전 )
* @RevisionHistory
* 		- 2017.10.18 최초 작성( 임헌용 )
* 		- 프레임워크 테스트 용
*/

(function ($) {
 
	
	/* 싱글 TEST 기능을 위한 Jquery 확장 함수 */
	$.fn.PuddButton = function( opt ){
		$.each( $( this ), function(index, item){
			if( $( this ).attr( 'id' ) == undefined || $( this ).attr( 'id' ) == ''){
				$( this ).attr( 'id' , Pudd.getGlobalVariable( 'fnRandomString' ) );
			}
			
			var parameter = { 
					id : $( this ).attr( 'id' ),
					class : $( this ).attr( 'class' ) || '',
					option : _opt || { },
					type : 'BASIC'
			};
		
			var puddButton = new BevButton( parameter );
			Pudd.makeComponent( $( this ), puddButton );
		});
	};
	
	
	function PuddTest( opt ){
		this.option = opt;
	}
	
	PuddTest.prototype = {
		init : function( ){
			this.test( );			
		},
		setElementAssembly : function( ){
			console.log( '엘리먼트 조립');			
		},
		setElementStyle : function( ){
			console.log( '스타일 지정' );			
		},
		setElementClass : function( ){
			console.log( '클래스 지정' );			
		},
		setElementAttribute : function( ){
			console.log( '속성값 지정' );			
		},
		setEvent : function( ){
			console.log( '이벤트 지정' );			
		},
		test :function( ){
			console.log('초기화 및 엘리먼트 생성');
		}
	}
		

})(jQuery);