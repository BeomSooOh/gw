/**
* @project_description PUDD( 가칭 ) Component BUTTON FILED
*
* @author 임헌용 ( 더존비즈온 UC개발본부 UC개발센터 UC개발1팀 )
* @version PUDD 0.0.0 ( 개발 버전 )
* @Revision_history
* 		- 2017.10.27 	최초 작성( 임헌용 ) 	
*/

(function ($) {
 
	/* 기본 버튼기능을 위한 Jquery 확장 함수 */
	$.fn.PuddButton = function( _opt ){	
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
		
			var puddButton = new PuddButton( parameter );
			Pudd.makeComponent( $( this ), puddButton );
		});

	};
	
	/* SVG 버튼 Jquery 확장 함수 */
	$.fn.PuddSVGButton = function( _opt ){
		$.each( $( this ), function( index, item ){
			if( $( this ).attr( 'id' ) == undefined || $( this ).attr( 'id' ) == ''){
				$( this ).attr( 'id' , Pudd.getGlobalVariable( 'fnRandomString' ) );
			}
			
			var parameter = { 
					id : $( this ).attr( 'id' ),
					class : $( this ).attr( 'class' ) || '',
					option : _opt || { },
					type : 'SVG'
			};
		
			var puddButton = new PuddButton( parameter );
			Pudd.makeComponent( $( this ), puddButton );
		});
	};
	
	/* 이미지 버튼 Jquery 확장 함수 */
	$.fn.PuddImgButton = function( _opt ){
		$.each( $( this ), function(index, item){
			if( $( this ).attr( 'id' ) == undefined || $( this ).attr( 'id' ) == ''){
				$( this ).attr( 'id' , Pudd.getGlobalVariable( 'fnRandomString' ) );
			}
			
			var parameter = { 
					id : $( this ).attr( 'id' ),
					class : $( this ).attr( 'class' ) || '',
					option : _opt || { },
					type : 'IMAGE'
			};
		
			var puddButton = new PuddButton( parameter );
			Pudd.makeComponent( $( this ), puddButton );
		});
	};
	
	/* SVG TEXT 버튼 Jquery 확장 함수 */
	$.fn.PuddSVGTextButton = function( _opt ){
		$.each( $( this ), function(index, item){
			if( $( this ).attr( 'id' ) == undefined || $( this ).attr( 'id' ) == ''){
				$( this ).attr( 'id' , Pudd.getGlobalVariable( 'fnRandomString' ) );
			}
			
			var parameter = { 
					id : $( this ).attr( 'id' ),
					class : $( this ).attr( 'class' ) || '',
					option : _opt || { },
					type : 'SVGTEXT'
			};
		
			var puddButton = new PuddButton( parameter );
			Pudd.makeComponent( $( this ), puddButton );
		});
	};
	
	
	/* SVG TEXT 버튼 Jquery 확장 함수 */
	$.fn.PuddImgTextButton = function( _opt ){
		$.each( $( this ), function(index, item){
			if( $( this ).attr( 'id' ) == undefined || $( this ).attr( 'id' ) == ''){
				$( this ).attr( 'id' , Pudd.getGlobalVariable( 'fnRandomString' ) );
			}
			
			var parameter = { 
					id : $( this ).attr( 'id' ),
					class : $( this ).attr( 'class' ) || '',
					option : _opt || { },
					type : 'IMAGETEXT'
			};
		
			var puddButton = new PuddButton( parameter );
			Pudd.makeComponent( $( this ), puddButton );
		});
	};
	
		
	function PuddButton( parameter ){
		/* 개발자 옵션 */
		this.id = parameter.id;
		this.class = parameter.class;
		this.$selector = null;
		this.option = parameter.option;
		this.type = parameter.type;
		this.name = null;
		this.onclick = null;
		
		/* 생성할 엘리먼트 */
		this.DIV = null;
		this.INPUT = null;
		this.TOOLTIP_DIV = null;
		this.SVG_TEXT_DIV = null;
		
		/* 생성할 엘리먼트 선택자*/
		this.$DIV = null;
		this.$INPUT = null;
		this.$TOOLTIP_DIV = null;
		this.$SVG_TEXT_DIV = null;
		
		/* 생성할 이벤트 */
		this.event = [ ];
		
		/* 클래스 및 스타일 추출 */
		this.inStyle = null;
		this.inClass = null;
		this.outStyle = null;
		this.outClass = null;
		
	}
	
	PuddButton.prototype = {

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
					
				case 'SVG_TEXT_DIV':
					this.SVG_TEXT_DIV = document.createElement( 'DIV' );
					this.$SVG_TEXT_DIV = $( this.SVG_TEXT_DIV );
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
				case 'SVG' :	
				case 'IMAGE' :
				case 'IMAGETEXT' :
					var tooltip = this.option.tooltip == undefined ? false : this.option.tooltip;
					this._createElement( 'INPUT' );					
					if( tooltip != false ){
						this._createElement( 'TOOLTIP_DIV' );
					}
					break;
				case 'SVGTEXT' :
					var tooltip = this.option.tooltip == undefined ? false : this.option.tooltip;
					this._createElement( 'INPUT' );					
					if( tooltip != false ){
						this._createElement( 'TOOLTIP_DIV' );
					}					
					this._createElement( 'SVG_TEXT_DIV' );					
					break;
				default :
					break;
			}									
		},
		
		setElementAssembly : function( ){					
			var type = this.type == undefined ? '' : this.type.toUpperCase( );
			this.DIV.appendChild( this.INPUT );
			
			if( this.TOOLTIP_DIV != null ){
				this.DIV.appendChild( this.TOOLTIP_DIV );
			}
			
			if( this.SVG_TEXT_DIV != null ){
				this.DIV.appendChild( this.SVG_TEXT_DIV );
			}
			/* SVG 조립 */
			switch( type ){
				case 'SVG':				
					var svgName = this.option.svg == undefined ? '' : this.option.svg;
					if( this.$TOOLTIP_DIV == null ){
						var svg = CommonUtil.searchSVGObject( svgName.toUpperCase( ) );					
						this.$INPUT.after( svg );
					}else{
						var svg = CommonUtil.searchSVGObject( svgName.toUpperCase( ) );					
						this.$TOOLTIP_DIV.after( svg );					
					}
					break;
				case 'SVGTEXT':
					var svgName = this.option.svg == undefined ? '' : this.option.svg;
					var svg = CommonUtil.searchSVGObject( svgName.toUpperCase( ) );					
					this.$SVG_TEXT_DIV.append( svg );
					break;
				default :
					break;
			}
		},
		
		setElementStyle : function( ){
			puddButtonStyle.pushDivStyle( this.$DIV, this.inStyle );
			puddButtonStyle.pushInputStyle( this.$INPUT, this.outStyle );
		},
		setElementClass : function( ){			
			puddButtonClass.pushDivClass( this.$DIV, this.option, this.class ,this.type, this.outClass );
			
			if( this.INPUT != null ){
				if( this.SVG_TEXT_DIV != null ){
					this.option.svgText = 'true';
				}
				puddButtonClass.pushInputClass( this.$INPUT, this.option, this.class, this.type, this.inClass );
			}
			
			if( this.TOOLTIP_DIV != null ){
				puddButtonClass.pushToolTipDivClass( this.$TOOLTIP_DIV );
			}
			
			if( this.SVG_TEXT_DIV != null ){
				puddButtonClass.pushSVGTextDivClass( this.$SVG_TEXT_DIV, this.option );
			}
			
			
		},
		setElementAttribute : function( ){
			
			puddButtonAttribute.pushDivAttribute( this.$DIV, this.option, this.id );
			if( this.TOOLTIP_DIV != null ){
				puddButtonAttribute.pushToolTipAttribute( this.$TOOLTIP_DIV, this.option, this.id );
			}
			
			if( this.INPUT != null){
				puddButtonAttribute.pushInputAttribute( this.$INPUT, this.option, this.id, this.type, this.name, this.onclick );
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

			var buttonEvent = new ButtonEvent( this.event, this.option );
			buttonEvent.createEvent( );
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
	var puddButtonStyle = {		
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
	var puddButtonClass = {
			pushDivClass : function( $element, option, classJson, type, outClass ){
				if( type.toUpperCase( ) === 'SVG' ){
					$element.addClass( 'PUDD-UI-iconSvgButton' );
				}else if( type.toUpperCase( ) === 'IMAGE' ){
					$element.addClass( 'PUDD-UI-iconImgButton' );					
				}else if( type.toUpperCase( ) === 'SVGTEXT' ){
					$element.addClass( 'PUDD-UI-iconSvgtextButton' );
				}else if( type.toUpperCase( ) === 'IMAGETEXT' ){
					$element.addClass( 'PUDD-UI-iconImgtextButton' );
				}else{
					$element.addClass( 'PUDD-UI-Button' );
				}
				//푸딩 설정
				$element.addClass( Pudd.getGlobalVariable( 'PRETEXT' ) );
				
				//테마 설정
				$element.addClass( Pudd.getGlobalVariable( 'THEMA' ) );
				
				
				if( outClass != null ){
					$element.addClass( outClass );
				}	
			},
			
			pushInputClass : function( $element, option, selectClass, type, inClass ){
				$element.addClass( selectClass );
				if( inClass != null ){
					$element.addClass( inClass );
				}
				
				/* 기본 버튼 옵션 */
				if( type === 'BASIC' && option.type != undefined ){
					if( option.type.toUpperCase( ) === 'MODAL'){
						$element.addClass( 'submit' );
					}
				}
			
				if( type === 'IMAGE' || type === 'IMAGETEXT'){
					/* 이미지 아이콘 넣기 */
					if( option.image != undefined ){
						$element.addClass( 'ico' );
						$element.addClass( option.image );
					}
				}
				
				/* IMAGE TEXT 전용 */
				if( type === 'IMAGETEXT'){
					/* 이미지 아이콘 넣기 */
					if( option.imgPosition != undefined && option.imgPosition.toUpperCase( ) == 'LEFT' ){
						$element.addClass( 'ico_al' );						
					}else if( option.imgPosition != undefined && option.imgPosition.toUpperCase( ) == 'RIGHT' ){
						$element.addClass( 'ico_ar' );
					}
				}				
				
				/* SVG TEXT 전용 */
				if( type === 'SVGTEXT' ){
					if( option.svgText != undefined ){
						if( option.svgPosition != undefined && option.svgPosition.toUpperCase( ) === 'RIGHT' ){
							$element.addClass( 'ico_ar' );
						}else if( option.svgPosition != undefined && option.svgPosition.toUpperCase( ) === 'LEFT' ){
							$element.addClass( 'ico_al' );
						}
					}
				}
				
				if( inClass != null ){
					$element.addClass( inClass );
				}
				
			},
			
			pushToolTipDivClass : function( $element ){
				$element.addClass( 'toolTip' ); 
			},
			
			pushSVGTextDivClass : function( $element, option ){
				if( option.svgPosition != undefined && option.svgPosition.toUpperCase( ) === 'RIGHT' ){
					$element.addClass( 'svgR_box' );
				}else if( option.svgPosition != undefined && option.svgPosition.toUpperCase( ) === 'LEFT' ){
					$element.addClass( 'svgL_box' );
				}
								
			},
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
	var puddButtonAttribute = {
			
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
			
			pushInputAttribute : function( $element, attrJson, id, type, name, onclick ) {
				attrJson = attrJson == undefined ? { } : attrJson;
				attrJson = CommonUtil.castToJSONObject( attrJson );
				
				$element.attr( 'type', 'button' );
				
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
	
				if( type === 'SVGTEXT' || type === 'IMAGETEXT' ){
					//readonly 생성
					if( attrJson.readonly == true || String( attrJson.readonly ).toUpperCase( ) === 'TRUE' ){
						$element.prop( 'readonly', true );
					}
				}
				
				//disable 생성
				if( type === 'BASIC' || type === 'SVGTEXT' || type === 'IMAGETEXT'){
					if( attrJson.disabled == true || String( attrJson.disabled ).toUpperCase( ) === 'TRUE' ){
						$element.prop( 'disabled', true );
					}
				}
				
				if( type === 'BASIC' || type === 'SVGTEXT' || type === 'IMAGETEXT' ){
					//사용자 지정 value( 값 ) 매핑
					if( attrJson.value != undefined ){
						$element.val( attrJson.value );
					}
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
	function ButtonEvent( event, optJson ){
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
	ButtonEvent.prototype.createEvent= function( ){
		var that = this;
		$.each( this.event, function( index, item ){
			var eventName = item.eventName;
			switch( eventName ){
				case 'mouseOverTooltip':
					that.mouseOverTooltip( item );
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
	 ButtonEvent.prototype.mouseOverTooltip = function( event ){
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
			
				$DIV.find( '.toolTip' ).css( 'top', ( ( thisY + elemHeight ) - ScHeight + 'px' ) );
				$DIV.find( '.toolTip' ).addClass( 'animated03s fadeInUp' );
				
			}else{
				// mouseleave 이벤트
				$( '.toolTip' ).hide( );				
			}
		});
	}
	 
	/* 공통함수 정의 모음 */
	ComponentCommander.button = function( ){ };
	ComponentCommander.button.prototype.setDisabled = function( that ){
		$( that.selector ).attr( 'disabled', 'disabled' );
		return 'SUCCESS';
	};
	
	ComponentCommander.button.prototype.setEnabled = function( that ){
		$( that.selector ).removeAttr( 'disabled' );
		return 'SUCCESS';
	};
	
})(jQuery);
