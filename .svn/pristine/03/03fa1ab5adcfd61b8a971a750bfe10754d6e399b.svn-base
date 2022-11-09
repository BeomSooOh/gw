/**
* @project_description PUDD( 가칭 ) Component INPUT FILED
*
* @author 임헌용 ( 더존비즈온 UC개발본부 UC개발센터 UC개발1팀 )
* @version PUDD 0.0.0 ( 개발 버전 )
* @Revision_history
* 		- 2017.09.13 	최초 작성( 임헌용 )
* 		- 2017.10.24	프레임워크 인터페이스에 맞추어 커스터마이징 ( 임헌용 )
*/

(function ($) {
 
	/* 기본 INPUT기능을 위한 Jquery 확장 함수 */
	$.fn.PuddText = function( opt ){
	
		$.each( $( this ), function(index, item){
			if( $( this ).attr( 'id' ) == undefined || $( this ).attr( 'id' ) == ''){
				$( this ).attr( 'id' , Pudd.getGlobalVariable( 'fnRandomString' ) );
			}
	
			var parameter = { 
					id : $( this ).attr( 'id' ),
					class : $( this ).attr( 'class' ) || '',
					option : opt || { },
					type : 'BASIC'
			};
		
			var puddInput = new PuddInput( parameter );
			Pudd.makeComponent( $( this ), puddInput );
		});
	};
	
	
	/* 패스워드 기능을 위한 Jquery 확장 함수 */
	$.fn.PuddPwdText = function( opt ){
		
		$.each( $( this ), function(index, item){
			if( $( this ).attr( 'id' ) == undefined || $( this ).attr( 'id' ) == ''){
				$( this ).attr( 'id' , Pudd.getGlobalVariable( 'fnRandomString' ) );
			}
			
			var parameter = { 
					id : $( this ).attr( 'id' ),
					class : $( this ).attr( 'class' ) || '',
					option : opt || { },
					type : 'PASSWORD'
			};
		
			var	puddInput = new PuddInput( parameter );
			Pudd.makeComponent( $( this ), puddInput );
		});
		
	};
	
	/* 검색기능을 위한 Jquery 확장 함수 */
	$.fn.PuddSearchText = function( opt ){
		$.each( $( this ), function(index, item){
			if( $( this ).attr( 'id' ) == undefined || $( this ).attr( 'id' ) == ''){
				$( this ).attr( 'id' , Pudd.getGlobalVariable( 'fnRandomString' ) );
			}
			
			var parameter = { 
					id : $( this ).attr( 'id' ),
					class : $( this ).attr( 'class' ) || '',
					option : opt || { },
					type : 'SEARCH'
			};
		
			var puddInput = new PuddInput( parameter );
			Pudd.makeComponent( $( this ), puddInput );
		});
	};
	
	/* INPUT을 위한 전용 FN 함수 */
	$.fn.changeState = function( item, message ){
		if( arguments.length < 1) {
			console.error( '인자값이 부족합니다.' );
			return false;
		}
		$( this ).parent( ).removeClass( 'Error' );
		$( this ).parent( ).removeClass( 'Success' );
		$( this ).parent( ).removeClass( 'Warning' );
		
		item = item.toUpperCase( );
		switch( item.toUpperCase( ) ){
				case 'SUCCESS' :	
					$( this ).parent( ).addClass( 'Success' );
					break;
				case 'WARNING' :
					$( this ).parent( ).addClass( 'Warning' );
					break;
				case 'ERROR' :
					$( this ).parent( ).addClass( 'Error' );
					break;
				default :
					break;
			}
		
		$.each( $( this ), function( index, item ){			
			if ( $( item ).siblings( 'svg' ).length > 0 ){
				$( item ).siblings( 'svg' ).remove( );
			}			
			if ( $( item ).siblings( '.informationText' ).length > 0 ){
				$( item ).siblings( '.informationText' ).remove( );
			}			
		});
		
		$( this ).after( CommonUtil.searchSVGObject( item.toUpperCase( ) ) )
		
		if( message != undefined){
			$( this ).after( '<div class="informationText animated03s fadeInRight">'+ message + '</div>' );
		}else{
			console.log(11 );
			switch( item.toUpperCase( ) ){
				case 'SUCCESS' :	
					$( this ).after( '<div class="informationText animated03s fadeInRight">'+ Pudd.getGlobalVariable( 'SUCCESS' ) + '</div>' );
					break;
				case 'WARNING' :
					$( this ).after( '<div class="informationText animated03s fadeInRight">'+ Pudd.getGlobalVariable( 'WARRING' ) + '</div>' );
					break;
				case 'ERROR' :
					$( this ).after( '<div class="informationText animated03s fadeInRight">'+ Pudd.getGlobalVariable( 'ERROR' ) + '</div>' );
					break;
				default :
					break;
			}
		}			
		return 'SUCCESS';
	};
		
	function PuddInput( parameter ){
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
		this.INPUT = null;
		this.TOOLTIP_DIV = null;
		this.INFO_DIV = null;
		this.A = null;
		this.AUTOTEXT_DIV = null;
		this.UL = null;
		
		/* 생성할 엘리먼트 선택자*/
		this.$DIV = null;
		this.$INPUT = null;
		this.$TOOLTIP_DIV = null;
		this.$INFO_DIV = null;
		this.$A = null;
		this.$AUTOTEXT_DIV = null;
		this.$UL = null;
		
		/* 생성할 이벤트 */
		this.event = [ ];
		
		/* 클래스 및 스타일 추출 */
		this.inStyle = null;
		this.inClass = null;
		this.outStyle = null;
		this.outClass = null;
		
	}
	
	PuddInput.prototype = {
		_createElement : function( tagName ){
			tagName = tagName.toUpperCase( );
			switch( tagName ){
				case 'INPUT':
					this.INPUT = document.createElement( 'INPUT' );
					this.$INPUT = $( this.INPUT );
					break;
					
				case 'TOOLTIP_DIV':
					this.TOOLTIP_DIV = document.createElement( 'DIV' );
					this.$TOOLTIP_DIV = $( this.TOOLTIP_DIV );
					break;
					
				case 'INFO_DIV':
					this.INFO_DIV = document.createElement( 'DIV' );
					this.$INFO_DIV = $( this.INFO_DIV );
					break;
					
				case 'A':
					this.A = document.createElement( 'A' );
					this.$A = $( this.A );
					break; 
					
				case 'AUTOTEXT_DIV':
					this.AUTOTEXT_DIV = document.createElement( 'DIV' );
					this.$AUTOTEXT_DIV = $( this.AUTOTEXT_DIV );
					break; 
					
				case 'UL':
					this.UL = document.createElement( 'UL' );
					this.$UL = $( this.UL );
					break; 
			}
			
		},
		
		init : function( ){
			this.DIV = document.getElementById( this.id );
			this.$DIV = $( this.DIV );
			this.$selector = $( this.DIV );
			CommonUtil.extractQueryAttribute( this.option, this );
			CommonUtil.extractAttribute( this.$selector, this );
			var type = this.type == undefined ? '' : this.type.toUpperCase( );
			switch( type ){
				case 'BASIC' :
					var tooltip = this.option.tooltip == undefined ? false : this.option.tooltip;
					var state = this.option.state == undefined ? false : this.option.state;
					var autoComplete = this.option.autoComplete == undefined ? false : this.option.autoComplete;
					this._createElement( 'INPUT' );
					
					if( tooltip != false ){
						this._createElement( 'TOOLTIP_DIV' );
					}

                    if(state != false){
                        this._createElement( 'INFO_DIV' );
                    }
                
					break;
					
				case 'PASSWORD':
					var state = this.option.state == undefined ? false : this.option.state;
					this._createElement( 'INPUT' );
                    if(state != false){
                        this._createElement( 'INFO_DIV' );
                    }
					this.option.type = 'password';
					break;
					
				case 'SEARCH':
					this._createElement( 'INPUT' );
					this._createElement( 'A' );
					this._createElement( 'AUTOTEXT_DIV' );
					this._createElement( 'UL' );
					break;
			}									
		},
		
		setElementAssembly : function( ){					
			var type = this.type == undefined ? '' : this.type.toUpperCase( );
			this.DIV.appendChild( this.INPUT );
			
			if( this.TOOLTIP_DIV != null ){
				this.DIV.appendChild( this.TOOLTIP_DIV );
			}
			
			switch( type ){
				case 'BASIC' :
					var state = this.option.state == undefined ? false : this.option.state;
					if( state != false ){
						var svg = CommonUtil.searchSVGObject( state.item.toUpperCase( ) );					
						this.$INPUT.after( svg );					
					}
					break;
					
				case 'PASSWORD':				
					var state = this.option.state == undefined ? false : this.option.state;
					if( state != false ){
						var svg = CommonUtil.searchSVGObject( state.item.toUpperCase( ) );					
						this.$INPUT.after( svg );
						
					}else{
						var svg = CommonUtil.searchSVGObject( 'SECURE' );					
						this.$INPUT.after( svg );						
					}
					break;
					
				case 'SEARCH':
					var svg = CommonUtil.searchSVGObject( 'MAGNIFIER' );				
					this.$A.append( svg );
					break;
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
			
			if( this.A != null ){
				this.DIV.appendChild( this.A );
			}
			
			if( this.AUTOTEXT_DIV != null ){
				this.DIV.appendChild( this.AUTOTEXT_DIV );
				if( this.UL != null ){
					this.AUTOTEXT_DIV.appendChild( this.UL );
				}
			}					
		},
		
		setElementStyle : function( ){
			puddInputStyle.pushDivStyle( this.$DIV, this.outStyle );
			puddInputStyle.pushInputStyle( this.$INPUT, this.inStyle );
		},
		setElementClass : function( ){			
			puddInputClass.pushDivClass( this.$DIV, this.option, this.type, this.outClass );
			
			if( this.INPUT != null ){
				puddInputClass.pushInputClass( this.$INPUT, this.class, this.inClass );
			}
			
			if( this.TOOLTIP_DIV != null ){
				puddInputClass.pushToolTipDivClass( this.$TOOLTIP_DIV );
			}
			
			if( this.INFO_DIV != null ){
				puddInputClass.pushInfoDivClass( this.$INFO_DIV );
			}
	
			if( this.A != null ){
				puddInputClass.pushAhrefClass( this.$A );
			}
			
			if( this.AUTOTEXT_DIV != null ){
				puddInputClass.pushAutoTextDivClass( this.$AUTOTEXT_DIV );
			}			
		},
		
		setElementAttribute : function( ){
			
			puddInputAttribute.pushDivAttribute( this.$DIV, this.option, this.id );
			if( this.TOOLTIP_DIV != null ){
				puddInputAttribute.pushToolTipAttribute( this.$TOOLTIP_DIV, this.option, this.id );
			}
			
			if( this.INPUT != null){
				puddInputAttribute.pushInputAttribute( this.$INPUT, this.option, this.id, this.name, this.onclick, this.onchange, this.onkeydown, this.onkeyup );
			}
			
			if( this.A != null ){
				puddInputAttribute.pushAhrefAttribute( this.$A, this.option, this.id );	
			}
			
			if( this.UL != null){
				puddInputAttribute.pushUlAttribute( this.$UL, this.option, this.id );
			}			
		},
		
		setEvent : function( ){
			if( this.TOOLTIP_DIV != null ){
				var tooltipEvent = {
						divId : this.$DIV.attr( 'id' ),
						inputId : this.$INPUT.attr( 'id' ),
						tooltipId : this.$TOOLTIP_DIV.attr( 'id' ),
						tooltipMsg : this.option.tooltipMsg || '',
						eventName : 'mouseOverTooltip'
				};
				this.event.push( tooltipEvent );
			}
			
			if( this.AUTOTEXT_DIV != null ){
				
				var autoCompleteEvent = {
					divId : this.$DIV.attr( 'id' ),
					inputId : this.$INPUT.attr( 'id' ),
					ulId : this.$UL.attr( 'id' ),
					$btn : this.$A,
					eventName : 'autoComplete'
				};
				this.event.push( autoCompleteEvent );
			}
			
			var inputEvent = new InputEvent( this.event, this.option );
			inputEvent.createEvent( );
		},
	}
	
		
		
	/**
	 * <pre>
	 * 1. 개요
	 * 		스타일 지정에 대한 객체 리터럴
	 * 2. 처리내용
	 * 		- BizLogic 처리 :
	 *			1) pushDivStyle : 선택자(DIV)에 대한 스타일 지정
	 *			2) pushInputStyle : 선택자(INPUT)에 대한 스타일 지정 
	 *			3) 
	 * 3. 입력 Data : 
	 * 4. 출력 Data : 
	 * </pre>
	 * @Method Name : pushDivStyle, pushInputStyle
	 * @param $
	 */
	var puddInputStyle = {		
			pushDivStyle : function( $element, outStyle ){				
				if( outStyle != null ){
					outStyle = JSON.parse( JSON.stringify( outStyle ) );
					$.each( outStyle, function( key, value ){
						$element.css( key, value );
					});
				}
				
			},
			
			pushInputStyle : function( $element, inStyle ){
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
	 * 		※테마 설정 존재 Dev.THEMA
	 * 2. 처리내용
	 * 		- BizLogic 처리 :
	 * 			1) pushDivClass : 선택자( DIV )를 에 대한 class 지정
	 * 			2) pushInputClass : INPUT에 대한 class 지정
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
	var puddInputClass = {
			pushDivClass : function( $element, classJson, type, outClass ){
				if( type.toUpperCase( ) === 'PASSWORD' ){
					$element.addClass( 'PUDD-UI-passwordField' );
				}else if( type.toUpperCase( ) === 'SEARCH' ){
					$element.addClass( 'PUDD-UI-searchField' );
				}else{
					$element.addClass( 'PUDD-UI-inputField' );
				}
				//푸딩 설정
				$element.addClass( Pudd.getGlobalVariable( 'PRETEXT' ) );
				//테마 설정
				$element.addClass( Pudd.getGlobalVariable( 'THEMA' ) );
				
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
			
			pushInputClass : function( $element, selectClass, inClass ){
				$element.addClass( selectClass );
				if( inClass != null ){
					$element.addClass( inClass );
				}
			},
			
			pushToolTipDivClass : function( $element ){
				$element.addClass( 'toolTip' ); 
			},
			
			pushInfoDivClass : function( $element ){
				$element.addClass( 'informationText animated03s fadeInRight' );
			},
			
			pushAhrefClass : function( $element ){
				$element.addClass( 'btn' );
			},
			
			pushAutoTextDivClass : function( $element ){
				$element.addClass( 'autoComplete' );
			}
	}
	
	
		
	/**
	 * <pre>
	 * 1. 개요
	 * 		Attribute 지정을 위한 객체 리터럴
	 * 		※_CreateInputId 함수※
	 * 		   - INPUT과 TOOLTIP을 위해 아이디를 생성한다.
	 * 		   - *TODO 생성규칙은 다음과 같으나 아이디 생성 정책을 확정하면 수정해야한다.
	 * 		     ( X ) 다음) 모듈이름 + _ + 태그명 + _ + 아이디( selector id ) + _ + 인덱스( 숫자 ) 2017.09.17 수정
	 * 	 		 다음) 아이디( selector id )+ _ + 태그명
	 * 2. 처리내용
	 * 		- BizLogic 처리 :
	 * 			1) pushDivAttribute : 선택자( DIV )를 위한 어트리뷰트 지정
	 * 			2) pushToolTipAttribute : 툴팁을 위한 어트리뷰트 지정
	 * 			3) pushInputAttribute : INPUT을 위한 어트리뷰트 지정
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
	var puddInputAttribute = {
			
			pushDivAttribute : function( $element, attrJson, id ){
				attrJson = attrJson == undefined ? { } : attrJson;
				attrJson = CommonUtil.castToJSONObject( attrJson );
				$element.attr( 'id', CommonUtil.createId( id, 'div' ) );
			},
			
			pushToolTipAttribute : function( $element, attrJson, id ){
				attrJson = attrJson == undefined ? { } : attrJson;
				attrJson = CommonUtil.castToJSONObject( attrJson );
				//id 생성
				if( id != undefined && id !== ''){
					$element.attr( 'id', CommonUtil.createId( id, 'tooltip' ) );
				}
			},
			
			pushInputAttribute : function( $element, attrJson, id, name, onclick, onchange, onkeydown, onkeyup ){
				attrJson = attrJson == undefined ? { } : attrJson;
				attrJson = CommonUtil.castToJSONObject( attrJson );
				
				//id 생성
				if( id != undefined && id !== ''){
					$element.attr( 'id', id );
				}
				
				//name 생성
				if( name != null ){
					$element.attr( 'name', name );
				}
			
				//onclick 생성
				if( onclick != null ){
					$element.attr( 'onclick', onclick );
				}
	
				//onchange 생성
				if( onchange != null ){
					$element.attr( 'onchange', onchange );
				}
				
				//onchange 생성
				if( onkeydown != null ){
					$element.attr( 'onkeydown', onkeydown );
				}
				
				//onchange 생성
				if( onkeyup != null ){
					$element.attr( 'onkeyup', onkeyup );
				}
				
				//type 생성
				if( attrJson.type != undefined && attrJson.type !== ''){
					$element.attr( 'type', attrJson.type );
				}else{
					$element.attr( 'type', 'text' );
				}
				
				//readonly 생성
				if( attrJson.readonly == true || String( attrJson.readonly.toUpperCase( ) ) === 'TRUE' ){
					$element.prop( 'readonly', true );
				}
				
				//disable 생성
				if( attrJson.disabled == true || String( attrJson.disabled.toUpperCase( ) ) === 'TRUE' ){
					$element.prop( 'disabled', true );
				}
				
				//placeholder 생성
				if( attrJson.placeholder != undefined ){
					/* TODO 다국어처리 가능? 확인 필요 2017.09.06 */
					$element.attr( 'placeholder',  attrJson.placeholder );
				}
				
				//사용자 지정 value( 값 ) 매핑
				if( attrJson.value != undefined ){
					$element.val( attrJson.value );
				}
				
			},
			
			pushAhrefAttribute : function( $element, attrJson, id ){
				attrJson = attrJson == undefined ? { } : attrJson;
				attrJson = CommonUtil.castToJSONObject( attrJson );
				var btnJson = attrJson.button || { };
				
				$element.attr( 'href','javascript:void(0)' );
				
				//id 생성
				if( btnJson.id != undefined ){
					$element.attr( 'id', btnJson.id );
				}
				
				if( btnJson.click != undefined ){
					$element.attr('onClick', btnJson.click );
					$element.removeAttr( 'href' );
				}
				
			},
			
			pushUlAttribute : function( $element, attrJson, id ){
				attrJson = attrJson == undefined ? { } : attrJson;
				attrJson = CommonUtil.castToJSONObject( attrJson );
				if( id != undefined && id !== '' ){
					$element.attr( 'id', CommonUtil.createId( id, 'ul' ) );
				}
			},
	}
	
	
		
	/**
	 * <pre>
	 * 1. 개요
	 * 		INPUT 이벤트 함수
	 * 2. 처리내용
	 * 		- BizLogic 처리 :
	 *			1)  이벤트 배열을 멤버변수로 지정한다.
	 *			2)  
	 *			3)  
	 * 3. 입력 Data : eventArrayJson  
	 * 4. 출력 Data :    
	 * @Method Name : InputEvent
	 * @param $
	 */
	function InputEvent( event, optJson ){
		this.event = event;
		this.option = optJson;
	}
	
	
	/**
	 * <pre>
	 * 1. 개요
	 * 		INPUT 이벤트 생성 및 바인딩
	 * 2. 처리내용
	 * 		- BizLogic 처리 :
	 *			1)  멤버변수인 이벤트 배열을 탐색하며 이벤트를 지정한다.
	 *			2)  
	 *			3)  
	 * 3. 입력 Data :   
	 * 4. 출력 Data :    
	 * @Method Name : InputEvent.createEvent
	 * @param $
	 */
	InputEvent.prototype.createEvent= function( ){
		var that = this;
		$.each( this.event, function( index, item ){
			var eventName = item.eventName;
			switch( eventName ){
				case 'mouseOverTooltip':
					that.mouseOverTooltip( item );
					break;
				case 'autoComplete':
					that.autoComplete( item );
					break;
				default:
					break;
			}
		});
	}
	
	
	/**
	 * <pre>
	 * 1. 개요
	 * 		INPUT 툴팁 마우스 오버 이벤트
	 * 2. 처리내용
	 * 		- BizLogic 처리 :
	 *			1)  툴팁 메세지가 있다면 툴팁에 툴팁 메세지를 지정하고 아니면 툴팁에 INPUT VALUE값을 지정한다.
	 *			2)  
	 * 3. 입력 Data : event{ divId, inputId, tooltipId, tooltipMsg } 
	 * 4. 출력 Data :    
	 * @Method Name : InputEvent.mouseOverTooltip
	 * @param $
	 */
	InputEvent.prototype.mouseOverTooltip = function( event ){
		//jquery 셀렉터 변수 할당
		var $DIV = $('#'+ event.divId );
		var $TOOLTIP_DIV = $('#'+ event.tooltipId );
		var $INPUT = $('#'+ event.inputId);
		
		//툴팁메세지 확인
		var tooltipMsg = event.tooltipMsg == ''? '$value' : event.tooltipMsg;
		
		//마우스 휠이벤트( 툴팁 숨기기 )
		$INPUT.on( 'mousewheel DOMMouseScroll', function( e ){
			$( '.toolTip' ).hide( );
		});
		
		//마우스 오버시 이벤트( 툴팁 보이기 )
		$INPUT.hover(function( event ){
			
			$TOOLTIP_DIV.show( );
			
			var _msg = tooltipMsg;
			if(event.type == 'mouseenter' ){
				
				//메세지가 $value이면 input의 value값을 지정한다.
				if(_msg == '$value'){
					$TOOLTIP_DIV.html( $INPUT.val( ) );
				}else{
					$TOOLTIP_DIV.html( tooltipMsg );
				}					
				var thisY = $DIV.offset( ).top;
				var ScHeight = $( window ).scrollTop( );
				var elemHeight = ( isNaN( Number ( $DIV.height( ) ) ) ? 0 : Number( $DIV.height( ) ) ) + 10;
			
				$DIV.find('.toolTip').css( 'top', ( ( thisY + elemHeight ) - ScHeight + 'px' ) );
				$DIV.find('.toolTip').addClass( 'animated03s fadeInUp' );
				
			}else{
				// mouseleave 이벤트
				$('.toolTip').hide( );
				
			}
		});
	}
	
	/**
	 * <pre>
	 * 1. 개요
	 * 		자동완성기능 이벤트
	 * 2. 처리내용
	 * 		- BizLogic 처리 :
	 *			1)  
	 *			2)  
	 * 3. 입력 Data : event{ divId, inputId, ulId, $btn } 
	 * 4. 출력 Data :    
	 * @Method Name : autoComplete
	 * @param $
	 */
	InputEvent.prototype.autoComplete = function( event ){
		var $INPUT = $( '#' + event.inputId );
		var $UL = $( '#' + event.ulId );
		var $BTN = event.$btn;
		var type = '';
		
		//셀렉트 리스트박스 위치조정
		function selectPosition( obj ){
			
			var This = $( obj );
			var parentWidth = This.parent( ).width( )
			var parentHeight = This.parent( ).height( );
			var bodyChk = $(window).height( );
			var ThisY = This.offset( ).top;
			var ThisL = This.offset( ).left;
			var ScHeight = $(window).scrollTop( );
			var listHeight = This.parent( ).find(".autoComplete").height( );
			var bottomHeight = ( (bodyChk - ThisY - parentHeight) + ScHeight );
			var elemHeight = ( isNaN( Number( This.height( ) ) ) ? 0 : Number( This.height( ) ) ) + 4;
			
			if(bottomHeight < listHeight){
				//위로	
				This.parent().find(".autoComplete").css({"width":parentWidth-2 + "px","bottom":(listHeight + 9) + "px","left":ThisL + "px","top":"inherit"});
			}else{
				//아래로
				This.parent( ).find( ".autoComplete" ).css( { "width" : parentWidth - 2 + "px","top":((ThisY + elemHeight + 1)-ScHeight + "px"),"left":ThisL + "px","bottom":"inherit"});
			};
		};
		
		
		if( this.option.dataSource != undefined ){
			var callMethod = this.option.dataSource;
			var searchKey = this.option.filterName;
			var searchValue = '';
			var hangulJaum  = ['ㄱ','ㄴ','ㄷ','ㄹ','ㅁ','ㅂ','ㅅ','ㅇ','ㅈ','ㅊ','ㅍ','ㅎ'];
			var hangulMoum  = ['ㅏ','ㅓ','ㅗ','ㅜ','ㅡ','ㅣ','ㅐ','ㅔ','ㅑ','ㅕ','ㅛ','ㅠ','ㅒ','ㅖ','ㅘ','ㅙ','ㅝ','ㅚ','ㅟ','ㅢ'];
			
			if( typeof this.option.dataSource == 'object' ){
				type = 'object';
				
			}else if( typeof this.option.dataSource == 'function'){
				type = 'function';
			}
		
			$INPUT.unbind( );
			
			$INPUT.focus(function(){  
				selectPosition( this );
				$( this ).siblings( '.autoComplete' ).addClass( 'animated03s fadeIn' ).show( );				
			}).blur(function(){  			
				var isHover = $INPUT.parent( ).find( 'li' ).hasClass( 'hover' );
				if( isHover == false){			
					$( this ).siblings( '.autoComplete' ).removeClass('animated03s fadeIn').hide( );
					$( this ).siblings( '.autoComplete' ).find( 'ul li' ).removeClass( 'on' );
				}
			});
			
			
			
			
			$INPUT.keyup(function( event ){
				switch( event.keyCode.toString( )){
					case '13' : // Enter					
						$BTN.click( );
						$UL.empty( );
						break;
					case '37' : // Arrow Left
						break;
					case '38' : // Arrow Up
						//li 요소가 존재한다면
						//on 클래스를 찾는다.
						//on클래스가 없다면 break; 또한 data-seq 가 0이면 break;
						//on클래스가 있다면 현재 on클래스가 존재하는 data-seq 값에 - 1 하기
						//data-seq - 1 값을 지닌 data속성을 찾아 on클래스 주기 * 
						_moveDatafocus( '38' );
						break;
					case '39' : // Arrow Right
						break;
					case '40' : // Arrow Down
						//li 요소가 존재한다면
						//on 클래스를 찾는다.
						//on클래스가 없다면 data-seq 0에 on 클래스 주기
						//on클래스가 있다면 현재 on클래스가 존재하는 data-seq 값에 + 1 하기
						//data-seq + 1 값을 지닌 data속성을 찾아 on클래스 주기
						_moveDatafocus( '40' );
						break;
					default :
						
						if( $( this ).val( ).IsKorean( ) ){
							/* 한글 처리 */
							var length = $( this ).val( ).length;
							var hangulArray = $( this ).val( ).substring(0, length );
							
							for(var i = 0, end = hangulArray.length; i < end; i++ ){
								var str = hangulArray[ i ];
								var isExist = 0; 
								isExist = isExist + hangulJaum.indexOf( str );
								isExist = isExist + hangulMoum.indexOf( str );
								
								if( isExist > -2){
									console.log('입력하신 문자 안에 자음과 모음이 있습니다.');
									return false;
									break;
								}else{							
									searchValue = $( this ).val( );
									/* 한글 검색 호출 */
									_getSearchData( type );
								}													
							}					
						}else{
							/* 영문 숫자 검색 호출 */
							searchValue = $( this ).val( );
							_getSearchData( type );
						}			
						break;
				}
			});
			
			/**
			 * <pre>
			 * 1. 개요
			 * 		검색할 데이터 불러오기
			 * 2. 처리내용
			 * 		- BizLogic 처리 :
			 *			1) 개발자가 지정한 데이터가 변수인지 함수인지 확인한다.
			 *				함수라면 데이터바인딩 후 콜백함수를 호출한다. 
			 *			2)      
			 * 4. 출력 Data :  
			 * @Method Name : _getSearchData
			 * @param $
			 */
			function _getSearchData( type ){
				var arrayExtration = [ ]; 
				switch( type ){
					case 'object':
						arrayExtration = _getSearchStr( callMethod );
						break;
					case 'function':
						arrayExtration = callMethod( _getSearchStr  );						
						break;
					default:						
						break;
				} 
				// arrayExtration 값이 존재하면 li를 생성한다.
				if( arrayExtration != [] ){
					
					$UL.empty( );
					var length = arrayExtration.length;
					
					
					for( var i = 0; i < length; i += 1 ){
						var LI = document.createElement( 'li' );
						$( LI ).attr( 'title', arrayExtration[ i ].value );														
						$( LI ).attr( 'data-seq', arrayExtration[ i ].seq );													
						var textnode = document.createTextNode( arrayExtration[ i ].value );     
						LI.appendChild( textnode );				
						$UL.append( LI );
					}
							
					$( document ).off( 'click' , 'li' );
					
					$( document ).on( 'click', 'li', function( ){					
						$INPUT.val( $( this ).text( ) );
						$INPUT.siblings(' .autoComplete ').removeClass(' animated03s fadeIn ').hide( );
						$INPUT.siblings(' .autoComplete ').find(' ul li ').removeClass(' on ');
					});
					
					
					$( 'li' ).unbind( 'hover' );
					
					$( 'li' ).hover(
						 function ( ) {
						   $( this ).addClass( 'hover' );
						 }, 			
						 function ( ) {
						   $( this ).removeClass( 'hover' );
						 }
					);
									
				}
				selectPosition( $INPUT );
			}
			
			
			/**
			 * <pre>
			 * 1. 개요
			 * 		데이터에서 문자열 찾기
			 * 2. 처리내용
			 * 		- BizLogic 처리 :
			 *			1)  
			 *			2)  
			 * 3. 입력 Data : jsonArray  
			 * 4. 출력 Data : jsonArray 
			 * @Method Name : _getSearchStr
			 * @param $
			 */
	        function _getSearchStr( result ) {
	        	var arrayExtration = [ ];
	        	var index = 0;
	        	
	        	if( searchKey != undefined ){
	        		result.filter( function( item ){
	        			if( item[ searchKey ].indexOf( searchValue ) !== -1){
	        				var newJson = { 
	        					seq : index,
	        					value : item[ searchKey ]
	        				};
	        				arrayExtration.push( newJson );
	        				index += 1;
	        			}
	        		});
	        		        
	        	}else{
	        		var length = result.length;
	        		for( var i = 0; i < length; i += 1 ){
	        			if( result[ i ].indexOf( searchValue ) !== -1 ){
	        				var newJson = { 
	        					seq : index,
	        					value : result[ i ]
	        				};
	        				arrayExtration.push( newJson );
	        				index += 1;
	        			}
	        		}
	        	}	        	
	        	return arrayExtration;
	        }
	        
	        
	        function _moveDatafocus( keyCode ){
	        	//li 요소가 존재한다면
				//on 클래스를 찾는다.
				//on클래스가 없다면 break; 또한 data-seq 가 0이면 break;
				//on클래스가 있다면 현재 on클래스가 존재하는 data-seq 값에 - 1 하기
				//data-seq - 1 값을 지닌 data속성을 찾아 on클래스 주기 *
	        	var elementList = $UL.find('li');
	        	var currentDataSeq = undefined;
	        	    
	        	if( elementList.length > 0  ){
	        		
	        		$.each( elementList, function( index, item ){
	        			if( $( item ).hasClass('on') ){
	        				currentDataSeq = $( item ).attr('data-seq');
	        				$( item ).removeClass('on');
	        				return false;
	        			}
	        		});        	
	        		
	        		switch( keyCode ){
		        		case '38' : // Arrow Up
		        			if( currentDataSeq == undefined ){
		        				break;
		        			}else{
		        				var newDataSeq = Number( currentDataSeq ) - Number( 1 );	        				
		        				if( newDataSeq === -1 ){
		        					var $firstElement = $UL.find('li[data-seq = 0 ]');
		        					$firstElement.addClass('on');
		        					$INPUT.val( $firstElemnet.attr('title') );
		        				}
		        				else{
		        					var $li = $UL.find('li[data-seq=' + newDataSeq + ']');
		        					$li.addClass('on');
		        					$INPUT.val( $li.attr('title') );
		        				}
		        			}
		        			
		        			break;
		        		case '40': // Arrow Down
		        			if( currentDataSeq == undefined ){
		        				var $li = $UL.find('li[data-seq = 0 ]');
		        				$li.addClass('on');
		        			}else{
	        					var newDataSeq = Number( currentDataSeq ) + Number( 1 );	        			
	        					var $li = $UL.find('li[data-seq =' + newDataSeq + ']');
	        					if( $li.length > 0 ){	        						
	        						$li.addClass('on');	        
	        						$INPUT.val( $li.attr('title') );
	        					}else{	        						
	        						newDataSeq = Number( newDataSeq ) + Number( -1 );
	        						var $lastLi = $UL.find('li[data-seq =' + newDataSeq + ']');
	        						$lastLi.addClass('on');
	        						$INPUT.val( $lastLi.attr('title') );
	        					}	        				
		        			}	  
		        			break;
		        		default:
		        			break;
	        		}
	        
	        	}else{
	        		return false;
	        	}        		        	      
	        }	  
		}
		
	}
	
	/* 공통함수 정의 모음 */
	
	ComponentCommander.input = function( ){ };
	ComponentCommander.input.prototype.setStateChange = function( that ){ 
		
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
	
	
	
	ComponentCommander.input.prototype.setDisabled = function( that ){
		$( that.selector ).attr( 'disabled', 'disabled' );
		return 'SUCCESS';
	};
	
	ComponentCommander.input.prototype.setEnabled = function( that ){
		$( that.selector ).removeAttr( 'disabled' );
		return 'SUCCESS';
	};

	ComponentCommander.input.prototype.getValue = function( selector ){
		if( $( selector ).length <= 1 ){
			return {
				'html' : $(selector)[0].outerHTML,
				'id' : $(selector).attr('id'),
				'class' : $(selector).attr('class'),
				'name' : $(selector).attr('name'),
				'value' : $(selector).val()
			};
		}else{
			var retValue = [ ];
			$.each( $( selector ), function( index, item ){
				var json = {
					'html' : $(item)[0].outerHTML,
					'id' : $(item).attr('id'),
					'class' : $(item).attr('class'),
					'name' : $(item).attr('name'),
					'value' : $(item).val()
				};
				retValue.push(json);
			});
			return retValue;
		}
	};

})(jQuery);
