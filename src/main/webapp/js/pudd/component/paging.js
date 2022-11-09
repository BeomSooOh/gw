/**
* @Project_Description PUDD( 가칭 ) Component Paging
*
* @Author 임헌용 ( 더존비즈온 UC개발본부 UC개발센터 UC개발1팀 )
* @Version PUDD 0.0.0 ( 개발 버전 )
* @Description
* 		- 페이징 컴포넌트는 Grid 컴포넌트에 종속적이다.
* 		- 페이지에서 반드시 그리드 컴포넌트를 선언해야만 호출할 수 있다.
* 		- 함수 이름에 remote : AJAX 데이터 호출 전용
* @Revision_History
* 		- 2017.10.18 최초 작성( 임헌용 )
* 		- 프레임워크 테스트 용
*/


/* 페이징 공통코드 함수 모음 */
PuddInitializePaging = function( grid ){
	var $PAGE_DIV = $( '#' +grid.id + '_paging' );
	var FIRST_SPAN = document.createElement( 'SPAN' );
	var PRE_SPAN = document.createElement( 'SPAN' );
	var NEXT_SPAN = document.createElement( 'SPAN' );
	var LAST_SPAN = document.createElement( 'SPAN' );
	var OL = document.createElement( 'OL' );
	//초기화
	$PAGE_DIV.find( 'SPAN' ).remove( );
	$PAGE_DIV.find( 'OL' ).remove( );
	
	/* 맨앞 */
	$( FIRST_SPAN ).addClass( 'first' );
	var FIRST_A = document.createElement( 'A' );
	$( FIRST_SPAN ).append( FIRST_A );
	$PAGE_DIV.append( FIRST_SPAN );
	$PAGE_DIV.append( ' ' );
	
	/* 이전 */
	$( PRE_SPAN ).addClass( 'pre' );
	var PRE_A = document.createElement( 'A' );
	$( PRE_SPAN ).append( PRE_A );
	$PAGE_DIV.append( PRE_SPAN );
	$PAGE_DIV.append( ' ' );
	
	/* 페이징 */
	$( OL ).addClass( 'page' );
	$PAGE_DIV.append( OL );
	
	/* 다음 */
	$( NEXT_SPAN ).addClass( 'nex' );
	var NEXT_A = document.createElement( 'A' );
	$( NEXT_SPAN ).append( NEXT_A );
	$PAGE_DIV.append( NEXT_SPAN );
	$PAGE_DIV.append( ' ' );
	
	/* 맨뒤 */
	$( LAST_SPAN ).addClass( 'last' );
	var LAST_A = document.createElement( 'A' );
	$( LAST_SPAN ).append( LAST_A );
	$PAGE_DIV.append( LAST_SPAN );
	$PAGE_DIV.append( ' ' );
}



PuddCheckReDrawPagingYN = function( grid ){
	var retYN = true;
	var pageNo = grid.pageNo;
	var $PAGE_DIV = $( '#' +grid.id + '_paging' );
	var $OL = $PAGE_DIV.find( '.page' );
	 
	$.each( $OL.find( 'li' ), function( index, item ){
		var index = $( item ).text( );
		index = Number( index );
		if( index == pageNo ){
			retYN = false;
			return false;
		}
	});
	return retYN;
}


/* AJAX 페이징 전용 코드 */
function PuddRemotePaging( gridId ){
	/* 필요변수 */
	var totalSize = null;
	var listSize = null;
	var pageSize = null;
	var pageNo = null;
	var $callback = $( '#' + gridId + '_content' );
	
	var arrGrid = PuddGridList.filter( function( item ) {    
		return item.id === gridId;
	});  
	if( arrGrid.length < 1){
		console.error( '그리드 정보가 존재하지 않습니다.' );
		return false;
	}
	var grid = arrGrid[ 0 ];
	
	if( grid.option.pageable != undefined && ( grid.option.pageable != true || String( grid.option.pageable ).toUpperCase( ) !== 'TRUE' ) ){
		console.error( 'PuddGrid 선언시 pageable를 설정하지 않았습니다. ' );
		return false;
	}
	/* 필요변수 값 넣기 */
	totalSize = grid.option.totalSize || 0;
	listSize = grid.option.listSize || 10;
	pageSize = grid.option.pageSize || 10;
	pageNo = grid.pageNo;
	
	/* 페이징이 그려지있는지 확인한다. */
	if ( $( '#' + grid.id + '_paging' ).children( ).size( ) > 0 ){
		//페이징이 존재한다.
		//현재페이지에 해당 페이지가 존재하지 않는다면 다시그려준다.
		if( PuddCheckReDrawPagingYN( grid ) ){
			PuddRemoteCreateIndexNumber( grid );
		}
	}else{
		//페이징이 존재하지 않는다.
		PuddInitializePaging( grid );
		PuddRemoteCreateIndexNumber( grid );
	}
	
	//호출
	PuddGirdDataBind( $callback );
}

/* 인덱스 번호 생성 */
PuddRemoteCreateIndexNumber = function( grid ){
	/* 필요변수 */
	var totalSize = null;
	var listSize = null;
	var pageSize = null;
	var pageNo = null;
	var totalPageSize = null;
	
	var $PAGE_DIV = $( '#' + grid.id +'_paging' );
	var $FIST_SPAN = $PAGE_DIV.find( '.first' );
	var $PRE_SPAN = $PAGE_DIV.find( '.pre' );
	var $OL = $PAGE_DIV.find( '.page' );
	var $NEXT_SPAN = $PAGE_DIV.find( '.nex' );
	var $LAST_SPAN = $PAGE_DIV.find( '.last' );
	
	/* 초기화 */
	$PAGE_DIV.find( 'li' ).remove( );
	
	/* 필요변수 값 넣기 */
	totalSize = grid.option.totalSize || 0;
	listSize = grid.option.listSize || 10;
	pageSize = grid.option.pageSize || 10;
	pageNo = grid.pageNo;
	
	//전체 페이지 갯수
	totalPageSize =  parseInt( totalSize / listSize );
	// 정확히 떨어지지 않기에 나머지가 있는 경우 1을 더한다.
	if( totalSize % listSize > 0){
		totalPageSize ++;
	}
	
	/* 맨앞 링크 */
	$PAGE_DIV.find( '.first' ).off( 'click' );
	$PAGE_DIV.find( '.first' ).on( 'click', function( ){
		grid.pageNo = 1;
		
		PuddGridRequestData( 1, grid.id );
		$OL.find( '.on' ).removeClass( 'on' );
		$.each( $OL.find( 'a' ), function( index,item ){
			if( Number( $( item ).text( ) ) == Number( grid.pageNo ) ) {
				$( item ).parent( ).addClass( 'on' );
				return false;
			}
		}); 
	} );
	
	/* 이전 링크 */
	$PAGE_DIV.find( '.pre' ).off( 'click' );
	$PAGE_DIV.find( '.pre' ).on( 'click', function( ){
		var index = $OL.find( '.on' ).text( );
		grid.pageNo =  Number( index ) - 1;
		grid.pageNo = grid.pageNo == 0 ? 1 : grid.pageNo;
		
		PuddGridRequestData( grid.pageNo, grid.id );
		$OL.find( '.on' ).removeClass( 'on' );
		$.each( $OL.find( 'a' ), function( index,item ){
			if( Number( $( item ).text( ) ) == Number( grid.pageNo ) ) {
				$( item ).parent( ).addClass( 'on' );
				return false;
			}
		});
	} );
	
	/* 다음 링크 */
	$PAGE_DIV.find( '.nex' ).off( 'click' );
	$PAGE_DIV.find( '.nex' ).on( 'click', function( ){
		var index = $OL.find( '.on' ).text( );
		grid.pageNo = Number( index ) + 1;
		grid.pageNo = grid.pageNo > totalPageSize ? totalPageSize : grid.pageNo;	
		
		
		PuddGridRequestData( grid.pageNo  , grid.id );
		$OL.find( '.on' ).removeClass( 'on' );
		$.each( $OL.find( 'a' ), function( index,item ){
			if( Number( $( item ).text( ) ) == Number( grid.pageNo ) ) {
				$( item ).parent( ).addClass( 'on' );
				return false;
			}
		});
	} );
	
	/* 맨뒤 링크 */
	$PAGE_DIV.find( '.last' ).off( 'click' );
	$PAGE_DIV.find( '.last' ).on( 'click', function( ){
		var index = $OL.find( '.on' ).text( );
		grid.pageNo = totalPageSize;
		
		PuddGridRequestData( Number( totalPageSize ) , grid.id );
		$OL.find( '.on' ).removeClass( 'on' );
		$.each( $OL.find( 'a' ), function( index,item ){
			if( Number( $( item ).text( ) ) == Number( grid.pageNo ) ) {
				$( item ).parent( ).addClass( 'on' );
				return false;
			}
		});
	} );
	
	/* 페이지 생성 */
	var block = Math.ceil( pageNo / pageSize );
	var startNo = ( ( block - 1 ) / pageSize ) * 10 + 1;
	var endNo = startNo + pageSize - 1;	
	if (endNo > totalPageSize) {
	    endNo = totalPageSize;			
	}
	
	for(var i = startNo; i <= endNo; i++  ){
		var LI = document.createElement( 'LI' );
		var $LI = $( LI );
		var A = document.createElement( 'A' );
		var $A = $( A );
		var TEXT = document.createTextNode( i );
		$A.append( TEXT );				
		$LI.append( A );
		if ( i == pageNo ){ 
			$LI.addClass( 'on' ); 
		}
		$OL.append( LI );
	}
	
	var gridId = grid.id;
	$.each( $OL.find( 'li' ), function( index, item ){
		var page = $( item ).text( );
		var id = gridId;
		$( item ).on( 'click', function( ){
			$OL.find( '.on' ).removeClass( 'on' );
			$( this ).addClass( 'on' );
			
			PuddGridRequestData( Number( page ), id );
		});
	} );
}


/* 데이터 페이징 전용 코드 */
function PuddDataPaging( gridId ){
	/* 필요변수 */
	var totalSize = null;
	var listSize = null;
	var pageSize = null;
	var pageNo = null;
	var $callback = $( '#'+ gridId + '_content' );
	
	var arrGrid = PuddGridList.filter( function( item ) {    
		return item.id === gridId;
	});  
	if( arrGrid.length < 1){
		console.error( '그리드 정보가 존재하지 않습니다.' );
		return false;
	}
	var grid = arrGrid[ 0 ];
	
	if( grid.option.pageable != undefined && ( grid.option.pageable != true || String( grid.option.pageable ).toUpperCase( ) !== 'TRUE' ) ){
		console.error( 'PuddGrid 선언시 pageable를 설정하지 않았습니다. ' );
		return false;
	}
	
	PuddDataSplitPageDatasource( grid );
	/* 필요변수 값 넣기 */
	totalSize = grid.option.dataSource.length || 0;
	listSize = grid.option.listSize || 10;
	
	pageSize = grid.pageSize || 10;
	pageNo = grid.pageNo;
	/* 페이징이 그려지있는지 확인한다. */
	if ( $( '#' + grid.id + '_paging' ).children( ).size( ) > 0 ){
		//페이징이 존재한다.
		//현재페이지에 해당 페이지가 존재하지 않는다면 다시그려준다.
		if( PuddCheckReDrawPagingYN( grid ) ){
			PuddDataCreateIndexNumber( grid );
		}
	}else{
		//페이징이 존재하지 않는다.
		PuddInitializePaging( grid );
		PuddDataCreateIndexNumber( grid );
	}
	
	//호출
	PuddGirdDataBind( $callback );
}


/* 페이지 자르기 */
PuddDataSplitPageDatasource = function( grid ){
	 var pageNo = grid.pageNo;
	 var data = grid.option.dataSource;
	 var listSize = grid.option.listSize;
	 var startIndex = (( ( pageNo - 1 ) / 10 ) * 10 ) * listSize;
	 var endIndex = Number( startIndex ) + Number( listSize ) - 1;
	 var pageList = [];
	 
	 if( startIndex > data.length ){
		 startIndex = data.length;
	 }
	 
	 if( endIndex > data.length ){
		 endIndex = data.length;
	 }

	 for( var i = startIndex; i <= endIndex; i++ ){
		 if( data[ i ] != undefined ){
			 pageList.push( data[ i ] );
		 }
	 }
	 grid.pageDatasource = pageList;
}


/* 인덱스 번호 생성 */
PuddDataCreateIndexNumber = function( grid ){
	/* 필요변수 */
	var totalSize = null;
	var listSize = null;
	var pageSize = null;
	var pageNo = null;
	var totalPageSize = null;
	
	var $PAGE_DIV = $( '#' + grid.id +'_paging' );
	var $FIST_SPAN = $PAGE_DIV.find( '.first' );
	var $PRE_SPAN = $PAGE_DIV.find( '.pre' );
	var $OL = $PAGE_DIV.find( '.page' );
	var $NEXT_SPAN = $PAGE_DIV.find( '.nex' );
	var $LAST_SPAN = $PAGE_DIV.find( '.last' );
	
	/* 초기화 */
	$PAGE_DIV.find( 'li' ).remove( );
	
	/* 필요변수 값 넣기 */
	totalSize = grid.option.dataSource.length || 0;
	listSize = grid.option.listSize || 10;
	pageSize = grid.option.pageSize || 10;
	pageNo = grid.pageNo;
	
	// 전체 페이지 갯수
	totalPageSize =  parseInt( totalSize / listSize );
	// 정확히 떨어지지 않기에 나머지가 있는 경우 1을 더한다.
	if( totalSize % listSize > 0){
		totalPageSize ++;
	}
	
	/* 맨앞 링크 */
	$PAGE_DIV.find( '.first' ).off( 'click' );
	$PAGE_DIV.find( '.first' ).on( 'click', function( ){
		grid.pageNo = 1;
		PuddGridRequestData( 1, grid.id );
		$OL.find( '.on' ).removeClass( 'on' );
		$.each( $OL.find( 'a' ), function( index,item ){
			if( Number( $( item ).text( ) ) == Number( grid.pageNo ) ) {
				$( item ).parent( ).addClass( 'on' );
				return false;
			}
		}); 
	} );
	
	/* 이전 링크 */
	$PAGE_DIV.find( '.pre' ).off( 'click' );
	$PAGE_DIV.find( '.pre' ).on( 'click', function( ){
		var index = $OL.find( '.on' ).text( );
		grid.pageNo =  Number( index ) - 1;
		grid.pageNo = grid.pageNo == 0 ? 1 : grid.pageNo;

		PuddGridRequestData( grid.pageNo, grid.id );
		$OL.find( '.on' ).removeClass( 'on' );
		$.each( $OL.find( 'a' ), function( index,item ){
			if( Number( $( item ).text( ) ) == Number( grid.pageNo ) ) {
				$( item ).parent( ).addClass( 'on' );
				return false;
			}
		});
	} );
	
	/* 다음 링크 */
	$PAGE_DIV.find( '.nex' ).off( 'click' );
	$PAGE_DIV.find( '.nex' ).on( 'click', function( ){
		var index = $OL.find( '.on' ).text( );
		grid.pageNo = Number( index ) + 1;
		grid.pageNo = grid.pageNo > totalPageSize ? totalPageSize : grid.pageNo;	
		
		PuddGridRequestData( grid.pageNo  , grid.id );
		$OL.find( '.on' ).removeClass( 'on' );
		$.each( $OL.find( 'a' ), function( index,item ){
			if( Number( $( item ).text( ) ) == Number( grid.pageNo ) ) {
				$( item ).parent( ).addClass( 'on' );
				return false;
			}
		});
	} );
	
	/* 맨뒤 링크 */
	$PAGE_DIV.find( '.last' ).off( 'click' );
	$PAGE_DIV.find( '.last' ).on( 'click', function( ){
		var index = $OL.find( '.on' ).text( );
		grid.pageNo = totalPageSize;
		PuddGridRequestData( Number( totalPageSize ) , grid.id );
		$OL.find( '.on' ).removeClass( 'on' );
		$.each( $OL.find( 'a' ), function( index,item ){
			if( Number( $( item ).text( ) ) == Number( grid.pageNo ) ) {
				$( item ).parent( ).addClass( 'on' );
				return false;
			}
		});
	} );
	
	/* 페이지 생성 */
	var block = Math.ceil( pageNo / pageSize );
	var startNo = ( ( block - 1 ) / pageSize ) * 10 + 1;
	var endNo = startNo + pageSize - 1;	
	if (endNo > totalPageSize) {
	    endNo = totalPageSize;			
	}
	
	for(var i = startNo; i <= endNo; i++  ){
		var LI = document.createElement( 'LI' );
		var $LI = $( LI );
		var A = document.createElement( 'A' );
		var $A = $( A );
		var TEXT = document.createTextNode( i );
		$A.append( TEXT );				
		$LI.append( A );
		if ( i == pageNo ){ 
			$LI.addClass( 'on' ); 
		}
		$OL.append( LI );
	}
	
	var gridId = grid.id;
	$.each( $OL.find( 'li' ), function( index, item ){
		var page = $( item ).text( );
		var id = gridId;
		$( item ).on( 'click', function( ){
			$OL.find( '.on' ).removeClass( 'on' );
			$( this ).addClass( 'on' );
			PuddGridRequestData( Number( page ), id );
		});
	} );
}

