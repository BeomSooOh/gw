/**
* @project_description PUDD( 가칭 ) Component TEXTAREA FILED
*
* @author 임헌용 ( 더존비즈온 UC개발본부 UC개발센터 UC개발1팀 )
* @version PUDD 0.0.0 ( 개발 버전 )
* @revision_history
* 		- 2017.10.27 	최초 작성( 임헌용 )
*/

(function ($) {
 
	/* 기본 TEXTAREA기능을 위한 Jquery 확장 함수 */
	$.fn.PuddTextArea = function( _opt ){
	
		$.each( $( this ), function(index, item){
			if( $( this ).attr( 'id' ) == undefined || $( this ).attr( 'id' ) == ''){
				$( this ).attr( 'id' , Pudd.getGlobalVariable( 'fnRandomString' ) );
			}
		
			var parameter = { 
					id : $( this ).attr( 'id' ),
					class : $( this ).attr( 'class' ) || '',
					option : _opt || { },
			};
		
			var puddTextArea = new PuddTextArea( parameter );
			Pudd.makeComponent( $( this ), puddTextArea );
		});
	};
	
	function PuddTextArea( parameter ){
		/* 개발자 옵션 */
		this.id = parameter.id;
		this.class = parameter.class;
		this.$selector = null;
		this.option = parameter.option;
		this.type = parameter.type;
		this.name = null;
		this.onclick = null;
		this.onchange = null;
		this.onkeydown = null;
		this.onkeyup = null;
		
		
		/* 생성할 엘리먼트 */
		this.DIV = null;
		this.TEXTAREA = null;
		this.SPAN = null;
		this.INFO_DIV = null;
		
		
		this.$DIV = null;
		this.$TEXTAREA = null;
		this.$SPAN = null;
		this.$INFO_DIV = null;
		
		
		/* 생성할 이벤트 */
		this.event = [ ];
		
		/* 클래스 및 스타일 추출 */
		this.inStyle = null;
		this.inClass = null;
		this.outStyle = null;
		this.outClass = null;
		
	}
	
	PuddTextArea.prototype = {

		_createElement : function( tagName ){
			tagName = tagName.toUpperCase( );
			switch( tagName ){
				case 'TEXTAREA':
					this.TEXTAREA = document.createElement( 'TEXTAREA' );
					this.$TEXTAREA = $( this.TEXTAREA );
					break;
						
				case 'INFO_DIV':
					this.INFO_DIV = document.createElement( 'DIV' );
					this.$INFO_DIV = $( this.INFO_DIV );
					break;
					
				case 'SPAN':
					this.SPAN = document.createElement( 'SPAN' );
					this.$SPAN = $( this.SPAN );
					break; 
			}
			
		},
		
		init : function( ){
			this.DIV = document.getElementById( this.id );
			this.$DIV = $( this.DIV );
			this.$selector = $( this.DIV );
			CommonUtil.extractQueryAttribute( this.option, this );
			CommonUtil.extractAttribute( this.$selector, this );
		
			var state = this.option.state == undefined ? false : this.option.state;
			var hint = this.option.hintText == undefined ? false : this.option.hintText;
			
			this._createElement( 'TEXTAREA' );
			if( hint != false ){
				this._createElement( 'SPAN' );
			}
			if( state != false ){
				this._createElement( 'INFO_DIV' );			
			}							
		},
		
		setElementAssembly : function( ){					
			var type = this.type == undefined ? '' : this.type.toUpperCase( );
			this.DIV.appendChild( this.TEXTAREA );
			
			if( this.SPAN != null ){
				this.DIV.appendChild( this.SPAN );
				var hintText = this.option.hintText == undefined ? '' : this.option.hintText;
				this.$SPAN.html( hintText );
			}
			
			if( this.INFO_DIV != null ){
				
				var state = this.option.state || { };
				var type = state.item == undefined ? '' : state.item.toUpperCase( );
				var message = state.message == undefined ? '' : state.message;
				
				if( message !== ''){
					this.$INFO_DIV.html( message );
				}else{
					switch( type ){
						case 'SUCCESS':	
							this.$INFO_DIV.html( Pudd.getGlobalVariable( 'STATE_SUCCESS_MESSAGE' ) );
							break;
						case 'ERROR':
							this.$INFO_DIV.html( Pudd.getGlobalVariable( 'STATE_ERROR_MESSAGE' ) );
							break;
						case 'WARNING':
							this.$INFO_DIV.html( Pudd.getGlobalVariable( 'STATE_WARNING_MESSAGE' ) );
							break;
						default:
							break;
					}
				}
				this.DIV.appendChild( this.INFO_DIV );
			}
		},
		
		setElementStyle : function( ){
			puddTextAreaStyle.pushDivStyle( this.$DIV, this.outStyle );
			puddTextAreaStyle.pushTextAreaStyle( this.$TEXTAREA, this.inStyle );
		},
		
		setElementClass : function( ){			
			puddTextAreaClass.pushDivClass( this.$DIV, this.option, this.type, this.outClass );
			
			if( this.TEXTAREA != null ){
				puddTextAreaClass.pushTextAreaClass( this.$TEXTAREA, this.class, this.inClass );
			}
			
			if( this.SPAN != null ){
				puddTextAreaClass.pushSpanClass( this.$SPAN );
			}
			
			if( this.INFO_DIV != null ){
				puddTextAreaClass.pushInfoDivClass( this.$INFO_DIV );
			}
		},
		
		setElementAttribute : function( ){
			puddTextAreaAttribute.pushDivAttribute( this.$DIV, this.option, this.id );
			if( this.TEXTAREA != null){
				puddTextAreaAttribute.pushTextAreaAttribute( this.$TEXTAREA, this.option, this.id, this.name, this.onclick, this.onchange, this.onkeydown, this.onkeyup );
			}			
		},
		
		setEvent : function( ){
			if( this.SPAN != null ){
				
				var hintTextEvent = {
					divId : this.$DIV.attr( 'id' ),
					textAreaId : this.$TEXTAREA.attr( 'id' ),
					eventName : 'hintFocusEvent'
				};
				this.event.push( hintTextEvent );
			}
			
			var textAreaEvent = new TextAreaEvent( this.event, this.option );
			textAreaEvent.createEvent( );
		},
	}
	
		
		
	/**
	 * <pre>
	 * 1. 개요
	 * 		스타일 지정에 대한 객체 리터럴
	 * 2. 처리내용
	 * 		- BizLogic 처리 :
	 *			1) pushDivStyle : 선택자(DIV)에 대한 스타일 지정
	 *			2) pushInputStyle : 선택자(TEXTAREA)에 대한 스타일 지정 
	 *			3) 
	 * 3. 입력 Data : 
	 * 4. 출력 Data : 
	 * </pre>
	 * @Method Name : pushDivStyle, pushInputStyle
	 * @param $
	 */
	var puddTextAreaStyle = {		
			pushDivStyle : function( $element, styleOption, outStyle ){
				if( outStyle != null ){
					outStyle = JSON.parse( JSON.stringify( outStyle ) );
					$.each( outStyle, function( key, value ){
						$element.css( key, value );
					});
				}
				
			},
			
			pushTextAreaStyle : function( $element, inStyle ){	 		
				if( inStyle != null ){
					inStyle = JSON.parse( JSON.stringify( inStyle ) );
					$.each( inStyle, function( key, value ){
						$element.css( key, value );
					});
				}
			},			
	}
	
	/**
	 * <pre>
	 * 1. 개요
	 * 		Class 지정을 위한 객체 리터럴
	 * 		※테마 설정 존재 Pudd.THEMA
	 * 2. 처리내용
	 * 		- BizLogic 처리 :
	 * 			1) pushDivClass : 선택자( DIV )를 에 대한 class 지정
	 * 			2) pushInputClass : TEXTAREA에 대한 class 지정
	 * 			3) pushToolTipDivClass : 툴팁( DIV )에 대한 class 지정
	 * 			4) pushInfoDivClass : 상태( DIV )에 대한 class 지정
	 * 			5) pushSvgClass : SVG에 대한 class 지정
	 * 3. 입력 Data : 
	 * 4. 출력 Data : 
	 * </pre>
	 * @Method Name : pushDivClass, pushInputClass, pushToolTipDivClass, pushInfoDivClass, pushSvgClass
	 * @param $
	 * 			#TODO 모듈명 NAMESPACE를 IMPORT해야 한다.
	 */
	var puddTextAreaClass = {
			pushDivClass : function( $element, classJson, type, outClass ){
				$element.addClass( 'PUDD-UI-textArea' );
				//테마 설정
				$element.addClass( Pudd.getGlobalVariable( 'THEMA' ) );
				
				//푸딩 설정
				$element.addClass( Pudd.getGlobalVariable( 'PRETEXT' ) );
				
				if( classJson.state != undefined ){
					var type = classJson.state.item == undefined ? '' : classJson.state.item.toUpperCase( );
						
					switch( type ){
						case 'SUCCESS':
							$element.addClass( 'Success' );
							break;
						case 'ERROR':
							$element.addClass( 'Error' );
							break;
						case 'WARNING':
							$element.addClass( 'Warning' );
							break;
						default :
							break;
					}
				}
				
				if( outClass != null ){
					$element.addClass( outClass );
				}
				
			},
			
			pushTextAreaClass : function( $element, selectClass, inClass ){
				$element.addClass( selectClass );
				if( inClass != null ){
					$element.addClass( inClass );
				}
			},
			
			pushSpanClass : function( $element ){
				$element.addClass( 'hintText' ); 
			},
			
			pushInfoDivClass : function( $element ){
				$element.addClass( 'informationText animated03s fadeInRight' );
			},
			
	}
	
	
		
	/**
	 * <pre>
	 * 1. 개요
	 * 		Attribute 지정을 위한 객체 리터럴
	 * 		※_CreateInputId 함수※
	 * 		   - TEXTAREA과 TOOLTIP을 위해 아이디를 생성한다.
	 * 		   - *TODO 생성규칙은 다음과 같으나 아이디 생성 정책을 확정하면 수정해야한다.
	 * 		     ( X ) 다음) 모듈이름 + _ + 태그명 + _ + 아이디( selector id ) + _ + 인덱스( 숫자 ) 2017.09.17 수정
	 * 	 		 다음) 아이디( selector id )+ _ + 태그명
	 * 2. 처리내용
	 * 		- BizLogic 처리 :
	 * 			1) pushDivAttribute : 선택자( DIV )를 위한 어트리뷰트 지정
	 * 			2) pushToolTipAttribute : 툴팁을 위한 어트리뷰트 지정
	 * 			3) pushInputAttribute : TEXTAREA을 위한 어트리뷰트 지정
	 * 			4) pushSvgAttribute : SVG을 위한 어트리뷰트 지정
	 * 			5) pushStatePathAttribute : SVG PATH을 위한 어트리뷰트 지정
	 * 			6) pushRectAttribute : SVG RECT을 위한 어트리뷰트 지정	
	 * 3. 입력 Data : 
	 * 4. 출력 Data : 
	 * </pre>
	 * @Method Name : pushDivAttribute, pushToolTipAttribute, pushInputAttribute, pushSvgAttribute, pushStatePathAttribute, pushRectAttribute
	 * @param $
	 * 			#TODO 모듈명 NAMESPACE를 IMPORT해야 한다.
	 */
	var puddTextAreaAttribute = {
			
			pushDivAttribute : function( $element, attrJson, id ){
				attrJson = attrJson == undefined ? { } : attrJson;
				attrJson = CommonUtil.castToJSONObject( attrJson );
				$element.attr( 'id', CommonUtil.createId( id, 'div' ) );
			},
			
			pushTextAreaAttribute : function( $element, attrJson, id, name, onclick, onchange, onkeydown, onkeyup ){
				attrJson = attrJson == undefined ? { } : attrJson;
				attrJson = CommonUtil.castToJSONObject( attrJson );
				
				//id 생성
				if( id != undefined && id !== ''){
					$element.attr( 'id', id );
				}
				
				if( name != null ){
					$element.attr( 'name', name );
				}
				
				if( onclick != null ){
					$element.attr( 'onclick', onclick );
				}

				if( onchange != null ){
					$element.attr( 'onchange', onchange );
				}
				
				if( onkeydown != null ){
					$element.attr( 'onkeydown', onkeydown );
				}
				
				if( onkeyup != null ){
					$element.attr( 'onkeyup', onkeyup );
				}			
											
				//readonly 생성
				if( attrJson.readonly == true || String( attrJson.readonly ).toUpperCase( ) === 'TRUE' ){
					$element.prop( 'readonly', true );
				}
				
				//disable 생성
				if( attrJson.disabled != true && String( attrJson.disabled ).toUpperCase( ) === 'TRUE' ){
					$element.prop( 'disabled', true );
				}
				
				//사용자 지정 value( 값 ) 매핑
				if( attrJson.value != undefined ){
					$element.val( attrJson.value );
				}
				
			},
	}
	
	/**
	 * <pre>
	 * 1. 개요
	 * 		TEXTAREA 이벤트 함수
	 * 2. 처리내용
	 * 		- BizLogic 처리 :
	 *			1)  이벤트 배열을 멤버변수로 지정한다.
	 *			2)  
	 *			3)  
	 * 3. 입력 Data : eventArrayJson  
	 * 4. 출력 Data :    
	 * @Method Name : TextAreaEvent
	 * @param $
	 */
	function TextAreaEvent( event, optJson ){
		this.event = event;
		this.option = optJson;
	}
	
	
	/**
	 * <pre>
	 * 1. 개요
	 * 		TEXTAREA 이벤트 생성 및 바인딩
	 * 2. 처리내용
	 * 		- BizLogic 처리 :
	 *			1)  멤버변수인 이벤트 배열을 탐색하며 이벤트를 지정한다.
	 *			2)  
	 *			3)  
	 * 3. 입력 Data :   
	 * 4. 출력 Data :    
	 * @Method Name : TextAreaEvent.createEvent
	 * @param $
	 */
	TextAreaEvent.prototype.createEvent= function( ){
		var that = this;
		$.each( this.event, function( index, item ){
			var eventName = item.eventName;
			switch( eventName ){
				case 'hintFocusEvent' :
					that.hintFocusEvent( item );
					break;
				default:
					break;
			}
		});
	}
	
	
	/**
	 * <pre>
	 * 1. 개요
	 * 		TEXTAREA 툴팁 마우스 오버 이벤트
	 * 2. 처리내용
	 * 		- BizLogic 처리 :
	 *			1)  텍스트아레아 포커슨 온/오프 이벤트로 힌트텍스트 보여주기 여부 
	 *			2)  
	 * 3. 입력 Data : event{ divId, textAreaId } 
	 * 4. 출력 Data :    
	 * @Method Name : TextAreaEvent.hintFocusEvent
	 * @param $
	 */
	TextAreaEvent.prototype.hintFocusEvent = function( event ){
		//jquery 셀렉터 변수 할당
		var $DIV = $( '#' + event.divId );
		var $TEXTAREA = $( '#' + event.textAreaId );
		
		//textarea에 값에 따라 hintText 유/무
		$TEXTAREA.focusin( function( ){  
			
			$( this ).siblings( '.hintText' ).hide( );
		}).focusout( function( ){
			
			var thisValue = $( this ).val( );
			if( thisValue == "" ){
				
				$( this ).siblings( '.hintText' ).show( );
			};
		});
	}
	
	ComponentCommander.textarea = function( ){ };
	
	/* 비활성화 */
	ComponentCommander.textarea.prototype.setDisabled = function( that ){		
		$( that.selector ).attr( 'disabled', 'disabled' );
	};
	
	/* 활성화 */
	ComponentCommander.textarea.prototype.setEnabled = function( that ){
		$( that.selector ).removeAttr( 'disabled' );
	};
	
	ComponentCommander.textarea.prototype.setStateChange = function( that ){ 
		if( arguments.length < 2) {
			console.error( '인자값이 부족합니다.' );
			return false;
		}
		
		var item = arguments[ 1 ][ 0 ].toString( );
		var message = arguments[ 2 ] == null ? undefined : arguments[ 2 ][ 0 ].toString( );
		
		$( that.selector ).parent( ).removeClass( 'Error' );
		$( that.selector ).parent( ).removeClass( 'Success' );
		$( that.selector ).parent( ).removeClass( 'Warning' );
		
		
		
	
		item = item.toUpperCase( );
		
		switch( item.toUpperCase( ) ){
				case 'SUCCESS' :	
					$( that.selector ).parent( ).addClass( 'Success' );
					break;
				case 'WARNING' :
					$( that.selector ).parent( ).addClass( 'Warning' );
					break;
				case 'ERROR' :
					$( that.selector ).parent( ).addClass( 'Error' );
					break;
				default :
					break;
			}
		
		$.each( $( that.selector ), function( index, item ){			
			if ( $( item ).siblings( 'svg' ).length > 0 ){
				$( item ).siblings( 'svg' ).remove( );
			}			
			if ( $( item ).siblings( '.informationText' ).length > 0 ){
				$( item ).siblings( '.informationText' ).remove( );
			}			
		});
		
		$( that.selector ).after( CommonUtil.searchSVGObject( item.toUpperCase( ) ) )
		
		if( message != undefined){
			$( this ).after( '<div class="informationText animated03s fadeInRight">'+ message + '</div>' );
		}else{
			
			switch( item.toUpperCase( ) ){
				case 'SUCCESS' :	
					$( that.selector ).after( '<div class="informationText animated03s fadeInRight">'+ Pudd.getGlobalVariable( 'SUCCESS' ) + '</div>' );
					break;
				case 'WARNING' :
					$( that.selector ).after( '<div class="informationText animated03s fadeInRight">'+ Pudd.getGlobalVariable( 'WARRING' ) + '</div>' );
					break;
				case 'ERROR' :
					$( that.selector ).after( '<div class="informationText animated03s fadeInRight">'+ Pudd.getGlobalVariable( 'ERROR' ) + '</div>' );
					break;
				default :
					break;
			}
		}			
		return 'SUCCESS';
	};
	
	

})(jQuery);
