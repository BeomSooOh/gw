/**
* @projectDescription PUDD( 가칭 ) Component Grid
*
* @author 임헌용 ( 더존비즈온 UC개발본부 UC개발센터 UC개발1팀 )
* @version PUDD 0.0.0 ( 개발 버전 )
* @RevisionHistory
* 		- 2017.10.18 최초 작성( 임헌용 )
* 		- 프레임워크 테스트 용
*/



(function ($) {

	/* 싱글 TEST 기능을 위한 Jquery 확장 함수 */
	$.fn.PuddGrid = function( _opt ){
		
		$.each( $( this ), function( index, item ){
			if( $( this ).attr( 'id' ) == undefined || $( this ).attr( 'id' ) == ''){
				$( this ).attr( 'id' , Pudd.getGlobalVariable( 'fnRandomString' ) );
			}
			
			var parameter = { 
					id : $( this ).attr( 'id' ),
					class : $( this ).attr( 'class' ) || '',
					option : _opt || { },					
			};
			var puddGrid = new PuddGrid( parameter );
			
			Pudd.makeComponent( $( this ), puddGrid );
			
		});
	};
	
	/* PuddGridList 관리함수 */
	PuddGridListDelete = function ( instance ){
		$.each( PuddGridList, function( index, item ){
			if( item.id == instance.id ){
				PuddGridList.splice( index, 1);
				return false;
			}
		} );
	}
	
	/* ajax 요청 함수 */
	PuddGridRequestData = function ( pageNo, id ){
		
		var arrGrid = PuddGridList.filter( function( item ) {    
			return item.id === id;
		});  
		
		if( arrGrid.length < 1){
			console.error( '그리드 정보가 존재하지 않습니다.' );
			return false;
		}
	
		
		
		var grid = arrGrid[0];
		var $callback = $( '#' + grid.id + '_content');
		
		
		CommonUtil.createLoading( $callback );
		
		$.each( PuddGridList, function( index, item ){
			if( item.id == id ){
				item.pageNo = pageNo;
				return false;
			}
		} );
		
		
		/* 페이징 YES */
		if( grid.option.pageable == true || grid.option.pageable.toUpperCase( ) === 'TRUE' ){
			var datasource = grid.option.dataSource;
			if ( datasource.length != undefined ){
				/* 데이터 변수 */
				PuddGridCallback( $callback, datasource );
			}else {		
				var param = {};
				if( typeof datasource.param == 'function' ){
					param = datasource.param( );
				}else{
					param = datasource.param;
				}
				
				/* AJAX */
				$.ajax({
					type: datasource.type || 'POST',  
			        url: datasource.transport,      
			        data: $.extend( param, { 'page' : pageNo ,'skip':'0', 'take' : grid.option.listSize || 10 , 'pageSize' : grid.option.pageSize || 10 } ),			     
			        async : datasource.async || 'true',			     
			        success:function( result ){
			        	
			        	var schema = datasource.schema || {}; 
			        	
			        	if( typeof schema.total == 'function' && schema.total != undefined ){
							grid.option.totalSize = schema.total( result );			   
						}else{
							grid.option.totalSize = result[ schema.total ] || 0;
						}
			        	
			        	if( typeof schema.data == 'function' && schema.data != undefined ){
							grid.pageDatasource = schema.data( result );				
						}else{
							grid.pageDatasource = result[ schema.data ] || [];
						}
			        	
			            PuddGridCallback( $callback, grid.pageDatasource );			             			         
			        },     
			        error:function(e){  
			            console.error( e.responseText );  
			        }  				
				});
			}
		}
		/* 페이징 NO */
		else{
			var datasource = grid.option.dataSource;
			if ( datasource.length != undefined ){
				/* 데이터 변수 */
				PuddGridCallback( $callback, datasource );
			}else { 			
				/* AJAX */
				$.ajax({
					type: datasource.type || 'post',  
			        url: datasource.transport,      
			        data: datasource.param,
			        async : datasource.async || 'true',
			        contentType : datasource.contentType || 'application/json',
			        charset : datasource.charset || 'utf-8',
			        success:function( result ){   		      		      		     
			             PuddGridCallback( $callback, result );			         
			        },     
			        error:function(e){  
			            console.error( e.responseText );  
			        }  				
				});
			}
		}
	}
	
	/* ajax 콜백 함수 */
	function PuddGridCallback( $callback ,result ){
		var id = $callback.attr( 'id' ).replace( '_content', '' );
		var arrGrid = PuddGridList.filter( function( item ) {    
			return item.id === id;
		});  
		if( arrGrid.length < 1){
			console.error( '그리드 정보가 존재하지 않습니다.' );
			return false;
		}
		var grid = arrGrid[ 0 ];
		grid.pageDatasource = result;
		
		$.each( PuddGridList, function( index, item ){
			if( item.id == id ){
				item = grid;
				return false;
			}
		} );
		
		/* 페이징 처리 */
		if( grid.option.pageable == true || grid.option.pageable.toUpperCase( ) === 'TRUE' ){
			var datasource = grid.option.dataSource;
			if(datasource.length != undefined ){
				//데이터 페이징
				PuddDataPaging( grid.id );
			}else{
				//ajax 데이터
				PuddRemotePaging( grid.id );
			}
		}
		/* 페이징 미처리 */
		else{	
			PuddGirdDataBind( $callback );
		}
		
	} 
	
	/* 그리드 함수객체 */
	function PuddGrid( parameter ){		
		/* 개발자 옵션 */
		this.id = parameter.id;
		this.class = parameter.class;
		this.$selector = null;
		this.option = parameter.option;
		this.type = parameter.type;
		
		/* 생성할 엘리먼트 */
		this.DIV = null;
		this.$DIV = null;
		this.HEADER_DIV = null;
		this.$HEADER_DIV = null;
		this.CONTENT_DIV = null;
		this.$CONTENT_DIV = null;
		
		this.PAGING_TOP_DIV =null;
		this.$PAGING_TOP_DIV =null;
		this.PAGING_DIV = null;
		this.$PAGING_DIV = null;
		
		this.GT_COUNT_DIV = null;
		this.$GT_COUNT_DIV = null;
		
		/* 클래스 및 스타일 추출 */
		this.inStyle = null;
		this.inClass = null;
		this.outStyle = null;
		this.outClass = null;
		
		/* 생성할 이벤트 */
		this.event = [ ];
		
		/* 페이징 데이터 */
		this.pagingDataSource = [];
		
		/* 테이블 행과 열*/
		this.rowCount = 0;
		this.colCount = 0;
	} 
	
	PuddGrid.prototype = {					
		init : function( ){
			this.DIV = document.getElementById( this.id );
			this.$DIV = $( this.DIV );
			this.$selector = $( this.DIV );
			 
			var json = this.$selector.attr( 'data-inline' ) || { };
			json = JSON.parse( JSON.stringify( json ) );
			this.inStyle = json.style || null;
			this.inClass = json.class || null;
			this.outStyle = json.topStyle || null;
			this.outClass = json.topClass || null;
			this.option.dataSource = this.option.dataSource == undefined ? { } : this.option.dataSource;
			
			this.HEADER_DIV = this._drawHeader( );
			this.$HEADER_DIV = $( this.HEADER_DIV );
			
			this.CONTENT_DIV = document.createElement( 'DIV' );
			this.$CONTENT_DIV = $( this.CONTENT_DIV );
			/* 페이징 확인 */
			if( this.option.pageable == true || this.option.pageable.toUpperCase( ) === 'TRUE' ){
				//페이징 로드
				Pudd.importComponentScript( 'paging' );
				//페이징 div 생성 호출
				this.PAGING_TOP_DIV = document.createElement( 'DIV' );
				this.$PAGING_TOP_DIV = $( this.PAGING_TOP_DIV );
				
				this.PAGING_DIV = document.createElement( 'DIV' );
				this.$PAGING_DIV = $( this.PAGING_DIV );
				
				/* 페이지 리스트 갯수  */
				this.GT_COUNT_DIV = this._drawListCountBox( );
				this.$GT_COUNT_DIV = $( this.GT_COUNT_DIV );
				
				
			}
			
		},
		
		_drawHeader : function( ){
			/* 헤더 그리드 테이블 리턴 */
			var columns = this.option.columns || [ ];
			var rc = 0, cc = 0;
			var HEADER_DIV = document.createElement( 'DIV' );
			var HEADER_TABLE = document.createElement( 'TABLE' );
			var HEADER_COLGROUP = document.createElement( 'COLGROUP' );
			var HEADER_THEAD = document.createElement( 'THEAD' );
		
			function countMatrix( json, pr ){
				if ( json.length > 0 ) {
					var r;
					if ( pr == undefined ){
						r = 0;
						r++;
					}else{
						r = pr;
					}
					$.each( json, function( index, item ) {
						if ( item.col != undefined) {
							r++;
							countMatrix( item.col, r );
						} else {
							cc++;
						}
					});
					if ( rc < r ) {
						rc = r;
					}
				}
			}
			
			function drawThead( json ) {
				var lst = [ ];
				if( json.length > 0 ) {
					$( HEADER_THEAD ).append( document.createElement( 'TR' ) );
					$.each( json, function( index, item ) {
						var TH = document.createElement( 'TH' );						
						$.each( item.headerAttributes, function( key, value ){
							$( TH ).attr( key, value );
						});								
						
						if ( item.title != undefined ){
							var TEXT = document.createTextNode( item.title );
							
						}
						if ( item.headerTemplate != undefined && item.headerTemplate != '' ){
							$(TH).append( item.headerTemplate );
						}else{
							TH.appendChild( TEXT );
						}
												
						$( HEADER_THEAD ).find( 'tr:last' ).append( TH );
						if ( item.columns != undefined ) {
							lst.push( Number( index ) );
							$( TH ).attr( 'colspan', item.columns.length );
						}else {
							$( TH ).attr( 'rowspan', Number( rc ) );
						}
					});

				}
				for ( var i = 0; i < lst.length; i++ ) {
					var index = lst[ i ];					
					rc--;
					draw( json[ index ].col );
				}
			}
			
			$.each( this.option.columns, function( index, item){
				var COL = document.createElement( 'COL' );
				if ( item.width != undefined ){
					$( COL ).css( 'width', CommonUtil.castUnit( item.width ) );
				}
				$( HEADER_COLGROUP ).append( COL );
			});
								
			$( HEADER_DIV ).append( HEADER_TABLE );
			$( HEADER_TABLE ).append( HEADER_COLGROUP );
			$( HEADER_TABLE ).append( HEADER_THEAD );
			
			$( HEADER_DIV ).addClass( 'grid-header' );
			/* 그리기 시작 */
			countMatrix( this.option.columns );
			/* 행과 열 값 갱신 */
			this.rowCount = rc;
			this.colCount = cc;
			drawThead( this.option.columns );
			
			return HEADER_DIV;
		}, 
		
		_drawListCountBox : function( ){
			var COUNT_DIV = document.createElement( 'DIV' );
			var SELECT = document.createElement( 'SELECT' );
			
			var listSizeBox = [];
			var initIndex = 0;
			
			if( this.option.listSizeBox != undefined ){
				listSizeBox = this.option.listSizeBox;
			}else{
				listSizeBox = [ 10, 20, 30, 40, 50, 100];
			} 
			
			if( this.option.listSize != undefined ){
				initIndex = this.option.listSize;
			}else{
				initIndex = 10;
			}
			
			for( var i = 0; i < listSizeBox.length; i++ ){
				var OPTION = document.createElement( 'OPTION' );
				$( OPTION ).css( 'width', '50px' ); 
				if( Number( listSizeBox[ i ] )  ==  Number( initIndex ) ){
					$( OPTION ).attr( 'selected', 'selected' );
				}
				var TEXT = document.createTextNode( listSizeBox[ i ] );
				$( OPTION ).append( TEXT );
				$( SELECT ).append( OPTION );
			}
			
			$( COUNT_DIV ).append( SELECT );
			
			return COUNT_DIV;
		},
		
		setElementAssembly : function( ){
			this.$DIV.append( this.HEADER_DIV );
			this.$DIV.append( this.CONTENT_DIV );
			if( this.option.pageable == true || this.option.pageable.toUpperCase( ) == 'TRUE' ){
				this.$PAGING_TOP_DIV.append( this.PAGING_DIV );
				this.$PAGING_TOP_DIV.append( this.GT_COUNT_DIV );
				this.$DIV.append( this.PAGING_TOP_DIV );
			}
		},
		setElementStyle : function( ){
			if( this.option.width != null ){
				this.$DIV.css( 'width', CommonUtil.castUnit( this.option.width ) );
			}
			
			if( this.option.height != null ){
				this.$CONTENT_DIV.css( 'height', CommonUtil.castUnit( this.option.height ) );
			}
			
			if( this.outStyle != null ){
				this.outStyle = JSON.parse( JSON.stringify( this.outStyle ) );
				$.each( this.outStyle, function( key, vale ){
					this.$DIV.css( key, value );
				});
			}
		},
		
		setElementClass : function( ){
			this.$DIV.addClass( Pudd.getGlobalVariable( 'PRETEXT' ) );
			this.$DIV.addClass( 'PUDD-UI-GridTable' );			
			this.$DIV.addClass( Pudd.getGlobalVariable( 'THEMA' ) );
			this.$CONTENT_DIV.addClass( 'grid-content' );
			
			if( this.option.pageable == true || this.option.pageable.toUpperCase( ) == 'TRUE' ){
				this.$PAGING_DIV.addClass( 'paging' );
				this.$PAGING_TOP_DIV.addClass( Pudd.getGlobalVariable( 'PRETEXT' ) );
				this.$PAGING_TOP_DIV.addClass( 'PUDD-UI-pager' );
				this.$GT_COUNT_DIV.addClass( 'gt_count' );	
			}
			
			if( this.option.height != undefined ){
				this.$DIV.addClass( 'scrollable' );
			}
			
			if( this.outClass != null ){
				this.$DIV.addClass( this.outClass );
			}
		},
		
		setElementAttribute : function( ){
			if( this.id != undefined ){
				this.$DIV.attr( 'id', this.id );
				this.$CONTENT_DIV.attr( 'id', this.id + '_content' );
				/* 페이징 확인 */
				if( this.option.pageable == true || this.option.pageable.toUpperCase( ) == 'TRUE' ){
					this.$PAGING_DIV.attr( 'id', this.id + '_paging' );
				}
			}	
		},
		
		setEvent : function( ){
			/* 그리드 등록 */
			var grid = {}
			grid = $.extend( {}, this );
			Pudd.pushGrid( grid );
			/* 리스트 카운드 이벤트 등록 */
			var gId = this.id;
			this.$GT_COUNT_DIV.find( 'SELECT' ).off( 'change' );
			this.$GT_COUNT_DIV.find( 'SELECT' ).on( 'change', function( ){
				var value = $( this ).val( );
				$.each( PuddGridList, function( index, item ){
					if( item.id.toUpperCase( ) === gId.toUpperCase( ) ){
						item.option.listSize = Number( value );
						//초기화
						this.$PAGING_TOP_DIV.find( '.paging' ).find( 'span' ).remove( );
						this.$PAGING_TOP_DIV.find( '.paging' ).find( 'ol' ).remove( );
						
						PuddGridRequestData( 1, this.id );
						return false;
					}
				} );
			});
			PuddGridRequestData( 1, this.id );
			Pudd.pageLoadComponent( "#"+ this.id );									
			return false;			
		},
	}
	

	 PuddGirdDataBind = function( $selector ){
		
		var gridId = $selector.attr( 'id' ).replace( '_content' , '' );
		var arrGrid = PuddGridList.filter(function(item){    
			return item.id === gridId;
		});  
		
		if( arrGrid.length < 1){
			console.error( '그리드 정보가 존재하지 않습니다.' );
			return false;
		}
		
		$( "#" + gridId + '_content' ).find( 'table' ).remove( );
		
		var that = arrGrid[0].option;
		var pagesource = arrGrid[0].pageDatasource;
		
		var CONTENT_TABLE = document.createElement( 'TABLE' );
		var CONTENT_COLGROUP = document.createElement( 'COLGROUP' );
		var CONTENT_TBODY = document.createElement( 'TBODY' );
		
		$.each ( that.columns, function( index, item ){
			var COL = document.createElement( 'COL' );
			if ( item.width != undefined ){
				$( COL ).css( 'width', CommonUtil.castUnit( item.width ) );
			}
			$( CONTENT_COLGROUP ).append( COL );
		});
		
		$( CONTENT_TABLE ).append( CONTENT_COLGROUP );
		$( CONTENT_TABLE ).append( CONTENT_TBODY );
		if ( pagesource.length == 0 ){
			
			var TR = document.createElement( 'TR' );
			var TD = document.createElement( 'TD' );
			var TEXT = document.createTextNode( Pudd.getGlobalVariable( 'NO_DATA_MESSAGE' ) );
			$( TD ).attr( 'colspan', arrGrid[0].colCount );
			$( TR ).append( TD );
			$( TD ).append( TEXT );
			$( CONTENT_TABLE ).append( TR );
			
		} else{
			
			$.each( pagesource, function( row, rowItem ) {
				var TR = document.createElement( 'TR' );
				$( TR ).attr( 'data-row', JSON.stringify( rowItem ) );
				
				if( that.rowClick != undefined ){
					if( typeof that.rowClick === 'function' ){
						$( TR ).on('click', function( ){
							that.rowClick( rowItem );
						}); 
					}else{
						$( TR ).on('click', function( ){
							eval( that.rowClick );
						}); 
					}
				}
				
				if( that.rowDblClick != undefined ){
					if( typeof that.rowDblClick === 'function' ){
						$( TR ).on('dblclick', function( ){
							that.rowDblClick( rowItem );
						}); 
					}else{
						$( TR ).on('dblclick', function( ){
							eval( that.rowClick );
						}); 
					}
				}
				
				
				var rowData = rowItem;
				$.each( that.columns, function( index, item ) {
					
					var TD = document.createElement( 'TD' );
					var text = '';
					
					$.each( rowData, function( key, value ) {
						if( key == item.field ) {
							text = value;
							return false;
						} 
					});
					
					var TEXT = document.createTextNode( text );		
					
					if( item.class != undefined && item.class != '' ) {
						$( TD ).addClass( rowItem.class );
					}
					
					if( item.attributes != undefined && item.attributes != '') {
						$.each( item.attributes, function( key, value ){
							$( TD ).attr( key, value );
						});	
					}
					
					if ( item.template != undefined && item.template != '' ) {							    
						if( typeof item.template == 'function'){								
							$( TD ).append( item.template( rowData ) );								
						}else{ 														
							var template = item.template;
							var keyCollection = Object.keys( rowData );		
							
							for ( var i = 0; i <keyCollection.length; i++ ){
								var key = '#' + keyCollection[ i ];
								var value = rowData[ keyCollection[ i ] ];																		
								template = template.replace( new RegExp( key, 'gi'), value );
							}								
							$( TD ).append( template );
						}										
					}else {
						$( TD ).append( TEXT );
					}
					
					$( TR ).append( TD );
				});
				$( CONTENT_TBODY ).append( TR );
			});
		}				
		$selector.append( CONTENT_TABLE );
		Pudd.pageLoadComponent( "#"+ gridId );
		CommonUtil.deleteLoading( $selector );
	}

})( jQuery );