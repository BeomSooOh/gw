/**	
* @project_description PUDD( 가칭 ) Component COMBO FILED
*
* @author 임헌용 ( 더존비즈온 UC개발본부 UC개발센터 UC개발1팀 )
* @version PUDD 0.0.0 ( 개발 버전 )
* @revision_history
* 		- 2017.10.30 	최초 작성( 임헌용 )
*/

(function ($) {
 
	/* 기본 COMBO기능을 위한 Jquery 확장 함수 */
	$.fn.PuddCombo = function( _opt ){
	
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
		
			var puddCombo = new PuddCombo( parameter );
			Pudd.makeComponent( $( this ), puddCombo );
		});
	};
	
	/* 멀티 COMBO기능을 위한 Jquery 확장 함수 */
	$.fn.PuddMultiCombo = function( _opt ){
	
		$.each( $( this ), function(index, item){
			if( $( this ).attr( 'id' ) == undefined || $( this ).attr( 'id' ) == ''){
				$( this ).attr( 'id' , Pudd.getGlobalVariable( 'fnRandomString' ) );
			}
			var parameter = { 
					id : $( this ).attr( 'id' ),
					class : $( this ).attr( 'class' ) || '',
					option : _opt || { },
					type : 'MULTI'
			};
		
			var puddCombo = new PuddCombo( parameter );
			Pudd.makeComponent( $( this ), puddCombo );
		});
	};
	
	
	function PuddCombo( parameter ){
		/* 개발자 옵션 */
		this.id = parameter.id;
		this.class = parameter.class;
		this.$selector = null;
		this.option = parameter.option || {};
		this.type = parameter.type;
		this.name = null;
		this.onclick = null;
		this.onchange = null;
		this.onselect = null;
		
		/* 생성할 엘리먼트 */
		this.DIV = null;
		this.SELECT = null;
		this.OPTION = null;
		this.SHOW_DIV = null;
		this.SPAN = null;
		this.BUTTON_SPAN = null;
		this.BUTTON = null;
		this.SHOW_TOP_DIV = null;
		this.MULTI_UL = null;
		this.MULTI_LI = null;
		this.UL = null;
		this.LI = null;
		this.TOOLTIP_DIV = null;
		
		/* 생성할 엘리먼트 선택자*/
		this.$DIV = null;
		this.$SELECT = null;
		this.$OPTION = null;
		this.$SHOW_DIV = null;
		this.$SPAN = null;
		this.$BUTTON_SPAN = null;
		this.$BUTTON = null;
		this.$SHOW_TOP_DIV = null;
		this.$MULTI_UL = null;
		this.$MULTI_LI = null;
		this.$UL = null;
		this.$LI = null;
		this.$TOOLTIP_DIV = null;
		
		/* 생성할 이벤트 */
		this.event = [ ];
		
		/* 클래스 및 스타일 추출 */
		this.inStyle = null;
		this.inClass = null;
		this.outStyle = null;
		this.outClass = null;
		
	}
	
	PuddCombo.prototype = {

		_createElement : function( tagName ){
			tagName = tagName.toUpperCase( );
			switch( tagName ){
				case 'SELECT':
					this.SELECT = document.createElement( 'SELECT' );
					this.$SELECT = $( this.SELECT );
					break;
					
				case 'OPTION':
					this.OPTION = document.createElement( 'OPTION' );
					this.$OPTION = $( this.OPTION );
					break;
					
				case 'SHOW_TOP_DIV':
					this.SHOW_TOP_DIV = document.createElement( 'DIV' );
					this.$SHOW_TOP_DIV = $( this.SHOW_TOP_DIV );
					break;
					
				case 'SPAN':
					this.SPAN = document.createElement( 'SPAN' );
					this.$SPAN = $( this.SPAN );
					break; 
					
				case 'BUTTON':
					this.BUTTON = document.createElement( 'BUTTON' );
					this.$BUTTON = $( this.BUTTON );
					break; 
					
				case 'BUTTON_SPAN':
					this.BUTTON_SPAN = document.createElement( 'SPAN' );
					this.$BUTTON_SPAN = $( this.BUTTON_SPAN );
					break; 
					
				case 'SHOW_DIV':
					this.SHOW_DIV = document.createElement( 'DIV' );
					this.$SHOW_DIV = $( this.SHOW_DIV );
					break;
					
				case 'UL':
					this.UL = document.createElement( 'UL' );
					this.$UL = $( this.UL );
					break;
					
				case 'LI':
					this.LI = document.createElement( 'LI' );
					this.$LI = $( this.LI );
					break;
					
				case 'MULTI_UL':
					this.MULTI_UL = document.createElement( 'UL' );
					this.$MULTI_UL = $( this.MULTI_UL );
					break;
					
				case 'TOOLTIP_DIV':
					this.TOOLTIP_DIV = document.createElement( 'DIV' );
					this.$TOOLTIP_DIV = $( this.TOOLTIP_DIV );
					break;
			}
			
		},
		
		init : function( ){
			this.DIV = document.getElementById( this.id );
			this.$DIV = $( this.DIV );
			this.$selector = $( this.DIV );
			CommonUtil.extractQueryAttribute( this.option, this );
			CommonUtil.extractAttribute( this.$selector, this ); 
			
			this.option.dataSource = this.option.dataSource == undefined ? [ ] : this.option.dataSource;
			this.option.dataSource = JSON.parse( JSON.stringify( this.option.dataSource ) );
			
			var type = this.type == undefined ? '' : this.type.toUpperCase( );
			switch( type ){
				case 'BASIC' :
					var tooltip = this.option.tooltip == undefined ? false : this.option.tooltip;
					this._createElement( 'SELECT' );
					this._createElement( 'OPTION' );
					this._createElement( 'SHOW_DIV' );
					this._createElement( 'SPAN' );
					this._createElement( 'BUTTON' );
					this._createElement( 'BUTTON_SPAN' );
					this._createElement( 'SHOW_TOP_DIV' );
					this._createElement( 'UL' );
					this._createElement( 'LI' );		
					if( tooltip != false ){
						this._createElement( 'TOOLTIP_DIV' );
					}
					break;
				case 'MULTI':
					var tooltip = this.option.tooltip == undefined ? false : this.option.tooltip;
					this._createElement( 'SELECT' );
					this._createElement( 'OPTION' );
					this._createElement( 'SHOW_DIV' );
					this._createElement( 'MULTI_UL' );	
					this._createElement( 'BUTTON' );
					this._createElement( 'BUTTON_SPAN' );
					this._createElement( 'SHOW_TOP_DIV' );
					this._createElement( 'UL' );
					this._createElement( 'LI' );		
					if( tooltip != false ){
						this._createElement( 'TOOLTIP_DIV' );
					}
					break;
			}									
		},
		
		setElementAssembly : function( ){					
			var type = this.type == undefined ? '' : this.type.toUpperCase( );
			switch( type ){
				case 'BASIC' :
					this.DIV.appendChild( this.SELECT );
					puddAppendElement.appendOPTION( this.type, this.$SELECT, this.option.dataSource, ( this.option.dataText || undefined ), ( this.option.dataValue || undefined ), this.option.index );
					this.DIV.appendChild( this.SHOW_TOP_DIV );
					this.SHOW_TOP_DIV.appendChild( this.SPAN );
					this.SHOW_TOP_DIV.appendChild( this.BUTTON );
					
					var selectedText = this.$SELECT.find( 'option[selected = "selected"]').html( );
					
					this.$SPAN.html( selectedText || '');
					this.BUTTON.appendChild( this.BUTTON_SPAN );
		
					this.DIV.appendChild( this.SHOW_DIV );
					this.SHOW_DIV.appendChild( this.UL );
					puddAppendElement.appendLI( this.type, this.$UL, this.option.dataSource, ( this.option.dataText || undefined ), ( this.option.dataValue || undefined ) ,this.option.index );
					
					if( this.TOOLTIP_DIV != null ){
						this.DIV.appendChild( this.TOOLTIP_DIV );
					}
					break;
					
				case 'MULTI':
					this.DIV.appendChild( this.SELECT );
					puddAppendElement.appendOPTION( this.type, this.$SELECT, this.option.dataSource, ( this.option.dataText || undefined ), ( this.option.dataValue || undefined ), this.option.index );
					this.DIV.appendChild( this.SHOW_TOP_DIV );
					this.SHOW_TOP_DIV.appendChild( this.MULTI_UL );
					this.SHOW_TOP_DIV.appendChild( this.BUTTON );
					this.BUTTON.appendChild( this.BUTTON_SPAN );
					var selectedText = this.$SELECT.find( 'option[selected = "selected"]').html( );
					var selectedValue = this.$SELECT.find( 'option[selected = "selected"]').val( );
					puddAppendElement.pushInitMultiSelectedItem( this.$MULTI_UL, selectedText, selectedValue );
					
					this.DIV.appendChild( this.SHOW_DIV );
					this.SHOW_DIV.appendChild( this.UL );
					puddAppendElement.appendLI( this.type, this.$UL, this.option.dataSource, ( this.option.dataText || undefined ), ( this.option.dataValue || undefined ) ,this.option.index );
					
					if( this.TOOLTIP_DIV != null ){
						this.DIV.appendChild( this.TOOLTIP_DIV );
					}
					break;
					
				default :					
					break;
			}
			
		},
		
		setElementStyle : function( ){
			puddComboStyle.pushDivStyle( this.$DIV, this.outStyle );
			puddComboStyle.pushShowDivStyle( this.$SHOW_DIV,  this.inStyle );
		},
		
		setElementClass : function( ){			
			puddComboClass.pushDivClass( this.$DIV, this.option, this.type, this.outClass );
			puddComboClass.pushSelectClass( this.$SELECT );
			puddComboClass.pushShowTopDivClass( this.type, this.$SHOW_TOP_DIV, this.option ,this.inClass );
			if( this.type === 'BASIC' ){
				puddComboClass.pushSpanClass( this.$SPAN );
			}else if( this.type === 'MULTI'){
				puddComboClass.pushMultiUlClass( this.$MULTI_UL );
			}
			puddComboClass.pushButtonClass( this.$BUTTON );
			puddComboClass.pushButtonSpanClass( this.$BUTTON_SPAN );
			puddComboClass.pushShowDivClass( this.$SHOW_DIV ); 
			if( this.TOOLTIP_DIV != null ){
				puddComboClass.pushToolTipDivClass( this.$TOOLTIP_DIV );
			}
		},
		
		setElementAttribute : function( ){
			puddComboAttribute.pushDivAttribute( this.$DIV, this.id );
			puddComboAttribute.pushSelectAttribute( this.$SELECT, this.id, this.option, this.name, this.onchange );
			if( this.type ==='BASIC' ){
				puddComboAttribute.pushSpanAttribute( this.$SPAN, this.id );
			}else if( this.type === 'MULTI' ){
				puddComboAttribute.pushMultiUlAttribute( this.$MULTI_UL, this.id );
			}
			puddComboAttribute.pushShowTopDivAttribute( this.$SHOW_TOP_DIV, this.id );
			puddComboAttribute.pushShowDivAttribute( this.$SHOW_DIV, this.id );
			
			if( this.TOOLTIP_DIV != null ){
				puddComboAttribute.pushToolTipAttribute( this.$TOOLTIP_DIV, this.id );
			}	
		},
		
		setEvent : function( ){
			
			if( this.SPAN != null ){
				
				/* 값 할당 */
				if( this.onselect != null){
					this.option.onSelect = this.onselect;
				}
				if( this.onchange != null){
					this.option.onChange = this.onchange;
				}
				
				var comboEvent = {
						divId : this.$DIV.attr( 'id' ),
						selectId : this.$SELECT.attr( 'id' ),
						spanId : this.$SPAN.attr( 'id' ),
						showTopDivId : this.$SHOW_TOP_DIV.attr( 'id' ),
						showDivId : this.$SHOW_DIV.attr( 'id' ),
						tooltip : ( this.option.tooltip == undefined ? false : true ),
						eventName : 'comboEvent',
				};
				this.event.push( comboEvent );
				
			}else if( this.MULTI_UL != null ){
				var comboEvent = {
						divId : this.$DIV.attr( 'id' ),
						selectId : this.$SELECT.attr( 'id' ),
						multiUlId : this.$MULTI_UL.attr( 'id' ),
						showTopDivId : this.$SHOW_TOP_DIV.attr( 'id' ),
						showDivId : this.$SHOW_DIV.attr( 'id' ),
						tooltip : ( this.option.tooltip == undefined ? false : true ),
						eventName : 'multiComboEvent',
				};
				this.event.push( comboEvent );
			}
			
			var comboEvent = new ComboEvent( this.event, this.option );
			comboEvent.createEvent( );
		},
	}
	
	
	var puddAppendElement = {
			appendOPTION : function( type, $SELECT, json, dataText, dataValue, index ){
				var arrJson = ( json == undefined ? [ ] : CommonUtil.castToJSONObject( json ) );
				var selectIndex = -1;
				
				if( type === 'BASIC' ){
					selectIndex = ( index == undefined ? 0 : index );
				}else{
					selectIndex = ( index == undefined ? -1 : index );
				}
				
				if( arrJson.length > 0 ){
					$.each( arrJson, function( index, item ){
						var OPTION = document.createElement( 'OPTION' );
						var text = '';
						var value = '';
						
						if( dataText != undefined ){
							text = item[ dataText ];
						}else{
							text = item.text;
						}
						
						if( dataValue != undefined ){
							value = item[ dataValue ];
						}else{
							value = item.value
						}
										
						$( OPTION ).attr( 'value',  value );
						
						if( index === Number( selectIndex ) ){
							$( OPTION ).attr( 'selected', 'selected' );
						}
		
						var textnode = document.createTextNode( text );     
						OPTION.appendChild( textnode );	
						$SELECT.append( OPTION );
					} );
				}
			},
			
			appendLI : function( type, $UL, json, dataText, dataValue ,index ){
				var arrJson = ( json == undefined ? [ ] : CommonUtil.castToJSONObject( json ) );
				var selectIndex = -1;
				
				if( type === 'BASIC' ){
					selectIndex = ( index == undefined ? 0 : index );
				}else{
					selectIndex = ( index == undefined ? -1 : index );
				}

				if( arrJson.length > 0 ){														
					$.each( arrJson, function( index, item ){
						var LI = document.createElement( 'LI' );
						var text = '';
						if( index === Number( selectIndex ) ){
							$( LI ).addClass( 'on');
						}
						
						if( dataText != undefined ){
							text = item[ dataText ];
						}else{
							text = item.text;
						}
						var textnode = document.createTextNode( text );     
						LI.appendChild( textnode );	
						$UL.append( LI );
					} );
				}
			},
			
			pushInitMultiSelectedItem :function( $UL, text, value ){
				var LI = document.createElement( 'LI' );
				var SPAN = document.createElement( 'SPAN' );
				var A = document.createElement( 'A' );
				var textNode = document.createTextNode( text );
				
				$( SPAN ).attr( 'data-value', value );
				SPAN.appendChild( textNode );				
				$( A ).addClass( 'del_btn' ).attr('href','javascript:void(0)').attr( 'cloneindex', '0' );
				
				LI.appendChild( SPAN );
				LI.appendChild( A );
				$UL.append( LI );
			},
	}
		
	/**
	 * <pre>
	 * 1. 개요
	 * 		스타일 지정에 대한 객체 리터럴
	 * 2. 처리내용
	 * 		- BizLogic 처리 :
	 *			1) 
	 *			2) 
	 *			3) 
	 * 3. 입력 Data : 
	 * 4. 출력 Data : 
	 * </pre>
	 * @Method Name : pushDivStyle, pushInputStyle
	 * @param $
	 */
	var puddComboStyle = {		
			pushDivStyle : function( $element, outStyle ){
				if( outStyle != null ){
					outStyle = JSON.parse( JSON.stringify( outStyle ) );
					$.each( outStyle, function( key, value ){
						$element.css( key, value );
					});
				}
				/* 예외처리 */
				$element[ 0 ].style.removeProperty( 'height' );
				$element[ 0 ].style.removeProperty( 'line-height' );
			},
			
			pushShowDivStyle : function( $element, inStyle ){
				
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
	 * 			1)
	 * 			2) 
	 * 3. 입력 Data : 
	 * 4. 출력 Data : 
	 * </pre>
	 * @Method Name : 
	 * @param $
	 * 			#TODO 모듈명 NAMESPACE를 IMPORT해야 한다.
	 */
	var puddComboClass = {
			pushDivClass : function( $element, classJson, type, outClass ){
				if( type.toUpperCase( ) === 'MULTI' ){
					$element.addClass( 'PUDD-UI-multiSelectBox' );
				}else{
					$element.addClass( 'PUDD-UI-selectBox ' );
				}
				//테마 설정
				$element.addClass( Pudd.getGlobalVariable( 'THEMA' ) );
				//푸딩 설정
				$element.addClass( Pudd.getGlobalVariable( 'PRETEXT' ) );
				//인라인
				if( outClass != null ){
					$element.addClass( outClass );
				}
			},
			
			pushSelectClass : function( $element ){
				$element.addClass( 'hiddenSelect' );
			},
			
			pushShowTopDivClass : function( type, $element, option ,inClass ){
				var style = ( option.style == undefined ? {} : option.style);
				
				$element.addClass( 'selectField' );	
				//인라인
				if( inClass != null ){
					$element.addClass( inClass );
				}
				
				if( option.disabled == true || String( option.disabled.toUpperCase( ) ) == 'TRUE' ){
					$element.addClass( 'disabled' );
				}
				
				if( type === 'MULTI' && style.height != undefined ){
					$element.addClass( 'scroll' );
				}
				
			},
			
			pushSpanClass : function( $element ){
				$element.addClass( 'selectText' );
			},
			
			pushButtonClass : function( $element ){
				$element.addClass( 'selectFieldBtn' );
			},
			
			pushButtonSpanClass : function( $element ){
				$element.addClass( 'arr' );
			},
			
			pushShowDivClass : function( $element ){
				$element.addClass( 'cloneList' );
			},
			
			pushToolTipDivClass : function( $element ){
				$element.addClass( 'toolTip' );
			},
			
			pushMultiUlClass : function( $element ){
				$element.addClass( 'multiBox' );
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
	 * 			1) 
	 * 			2) 
	 * 3. 입력 Data : 
	 * 4. 출력 Data : 
	 * </pre>
	 * @Method Name : 
	 * @param $
	 * 			#TODO 모듈명 NAMESPACE를 IMPORT해야 한다.
	 */
	var puddComboAttribute = {
			
			pushDivAttribute : function( $element, id ){
				if( id != undefined && id !== ''){
					$element.attr( 'id', CommonUtil.createId( id, 'div' ) );
				}
			},
			
			pushSelectAttribute : function( $element, id, option, name, onchange ){
				//id 생성
				if( id != undefined && id !== ''){
					$element.attr( 'id', id );
				}
				
				//name 생성
				if( name != null ){
					$element.attr( 'name', name );
				}
				
//				//체인지 이벤트
//				if( option.onchange != undefined){
//					$element.attr( 'onchange', option.onchange );
//				}				
//				
//				// 체인지 이벤트 ( 인라인 우선 )
//				if( onchange != null ){
//					$element.attr( 'onchange', onchange );
//				}
			},
			
			pushSpanAttribute : function( $element, id ){
				if( id != undefined && id !== ''){
					$element.attr( 'id', CommonUtil.createId( id, 'span' ) );
				}
				$element.css('line-height',CommonUtil.castUnit($element.height()) );
			},
			
			pushShowTopDivAttribute : function( $element, id ){
				if( id != undefined && id !== ''){
					$element.attr( 'id', CommonUtil.createId( id, 'showTopDiv' ) );
				}
				$element.attr( 'tabindex' , '1' );
				
			},
			
			pushShowDivAttribute : function( $element, id ){
				if( id != undefined && id !== '' ){
					$element.attr( 'id', CommonUtil.createId( id, 'showDiv' ) );
				}
			},
			
			pushToolTipAttribute : function( $element, id ){
				if( id != undefined && id !== ''){
					$element.attr( 'id', CommonUtil.createId( id, 'tooltip' ) );
				}
			},
			
			pushMultiUlAttribute : function( $element, id ){
				if( id != undefined && id !== ''){
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
	function ComboEvent( event, optJson ){
		this.event = event;
		this.option = optJson || {};
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
	ComboEvent.prototype.createEvent= function( ){
		var that = this;
		$.each( this.event, function( index, item ){
			var eventName = item.eventName;
			switch( eventName ){
				case 'comboEvent':
					that.comboEvent( item );
					break;
				case 'multiComboEvent':
					that.multiComboEvent( item );
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
	ComboEvent.prototype.comboEvent = function( event ){
		//jquery 셀렉터 변수 할당
		var $DIV = $('#'+ event.divId );
		var $SELECT = $('#'+ event.selectId );
		var $SHOW_TOP_DIV = $('#'+ event.showTopDivId );
		var $SHOW_DIV = $('#'+ event.showDivId );
		var tooltip = event.tooltip;

        $(document).scroll(function(){
			$('.selectField').removeClass("on").blur();
			$('.selectField').parent().find(".cloneList").removeClass("animated03s fadeIn").hide();
		});

		//셀렉트 리스트박스 위치조정
		function selectPosition(obj){

			var This = $( obj );
			var parentWidth = This.parent().width()
			var parentHeight = This.parent().height();
			var bodyChk = $(window).height();
			var ThisY = This.offset().top;
			var ThisL = This.offset().left;
			var ScHeight = $(window).scrollTop();
			var listHeight = $SHOW_DIV.height();
			var bottomHeight = ( (bodyChk - ThisY - parentHeight) + ScHeight );
			var elemHeight = (isNaN(Number(This.height())) ? 0 : Number(This.height())) + 6;
			var elemHeight2 = (isNaN(Number(This.height())) ? 0 : Number(This.height())) + 2;

			if(bottomHeight < listHeight){
				//위로	
				$SHOW_DIV.css({"width":parentWidth-2 + "px","top":((ThisY - listHeight - 2)-ScHeight + "px"),"left":ThisL + "px","bottom":"inherit"});

			}else{

				//아래로
				if($DIV.hasClass("PUDD-UI-selectBox")){					
					$SHOW_DIV.css({"width":parentWidth-2 + "px","top":((ThisY + elemHeight)-ScHeight + "px"),"left":ThisL + "px","bottom":"inherit"});
				
				}else if($DIV.hasClass("PUDD-UI-multiSelectBox")){					
					$SHOW_DIV.css({"width":parentWidth-2 + "px","top":((ThisY + elemHeight2)-ScHeight + "px"),"left":ThisL + "px","bottom":"inherit"});
				};
			};
		}
		
		$SHOW_TOP_DIV.unbind( );
		$SHOW_TOP_DIV.off( 'click' );
		$SHOW_TOP_DIV.on( "click", function( ){
			if( $( this ).hasClass( "disabled" )){
				$( this ).blur( );
				
			}else if( $( this ).hasClass( "on" ) ){
				$( this ).removeClass( "on" ).blur( );
				$( this ).parent( ).find( ".cloneList" ).removeClass( "animated03s fadeIn" ).hide( );
			
			}else{
				$( this ).focus( );
				selectPosition( this );
				$( this ).addClass( "on" );
				$( ".cloneList" ).removeClass( "animated03s fadeIn" ).hide( );
				$( this ).parent( ).find( ".cloneList" ).addClass( "animated03s fadeIn" ).show( );
			};
			
		}).blur( function( ){
			if( !$( this ).siblings( ".cloneList" ).children( ).find( "li" ).hasClass( "hover" ) ){
				$( ".cloneList" ).removeClass( "animated03s fadeIn" ).hide( );
			};
			$( this ).removeClass( "on" );
			
		});
		
		$SHOW_DIV.unbind( );
		$SHOW_DIV.find( 'li' ).off( 'click' );
		
		var that = this;
		//selectBox의 리스트를 클릭했을때
		$SHOW_DIV.find( 'li' ).on( "click", function( ){
			
			$SELECT.find( 'option' ).removeAttr( 'selected' );
			
			var selectedIndex = $SHOW_DIV.find( 'li' ).index( this );	
			var $OPTION = $( $SELECT.find( 'option' )[ selectedIndex ] );
			$OPTION.attr( 'selected', 'selected' );
			
			
			var param = {
					value : $OPTION.val(),
					text : $OPTION.text( )
			}
			
			
			if( that.option.onSelect != undefined ){			
				if( typeof that.option.onSelect == 'function' ){
					
					that.option.onSelect( param );
				}else{
					eval( that.option.onSelect );
				}
			}
			
			var changeText = $( this ).text( );
			$( this ).parent( ).parent( ).siblings( '.selectField' ).children( '.selectText' ).text( changeText );
			
			$( this ).siblings( ".cloneList li" ).removeClass( "on" );
			$( this ).addClass( 'on' ); 
			$SHOW_TOP_DIV.removeClass( 'on' );
		
			$SHOW_DIV.removeClass( "animated03s fadeIn" ).hide( );
			$( ".toolTip" ).removeClass( "animated03s fadeInUp" );
			$( ".toolTip" ).css( "display", "none" );
			
			
			$SELECT.change( );
			if( typeof that.option.onChange == 'function' ){				
					that.option.onChange( param );
			}else{
					eval( that.option.onChange );
			}
			
		});
		
		$SHOW_DIV.find( 'li' ).hover( function( event ){
			
			if( event.type === "mouseenter" ){
				$( this ).addClass( "hover" );	
			}else{
				$( this ).removeClass( "hover" );
			};
			
		});
		
		if( tooltip ){
			$SHOW_DIV.off( 'mouseleave' );
			//selectField의 리스트에 마우스를 올렸을때
			$SHOW_DIV.find( 'li' ).on( "mouseenter", function( ){
				
				var This = $( this );
				var ThisY = This.offset( ).top;
				var ScHeight = $(window).scrollTop( );
				var elemHeight = (isNaN(Number(This.height( ))) ? 0 : Number(This.height( ))) + 9;
				
				This.parent( ).parent( ).siblings( ".toolTip" ).css( "display","block" );
				This.parent( ).parent( ).siblings( ".toolTip" ).text($( this ).text( ))
				This.parent( ).parent( ).siblings( ".toolTip" ).css( "top",(( ThisY + elemHeight ) - ScHeight + "px") );
				This.parent( ).parent( ).siblings( ".toolTip" ).addClass( "animated03s fadeInUp" );
				
			});
			
			//selectField의 리스트에서 마우스를 뺐을때
			$SHOW_DIV.on( "mouseleave", function( ){
				
				var This = $( this );
				This.parent( ).find( ".toolTip" ).removeClass( "animated03s fadeInUp" );
				This.parent( ).find( ".toolTip" ).css( "display","none" );
				
			});
			
			//cloneList에서 스크롤이동 시 툴팁제거
			$SHOW_DIV.scroll(function( ){
				
				$( ".toolTip" ).removeClass( "animated03s fadeInUp" );
				$( ".toolTip" ).css( "display" ,"none" );
				
			});
		}
		
		
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
	ComboEvent.prototype.multiComboEvent = function( event ){
		//jquery 셀렉터 변수 할당
		var $DIV = $('#'+ event.divId );
		var $SELECT = $('#'+ event.selectId );
		var $MULTI_UL = $('#'+ event.multiUlId );
		var $SHOW_TOP_DIV = $('#'+ event.showTopDivId );
		var $SHOW_DIV = $('#'+ event.showDivId );
		var tooltip = event.tooltip;
		
        $(document).scroll(function(){
			$('.selectField').removeClass("on").blur();
			$('.selectField').parent().find(".cloneList").removeClass("animated03s fadeIn").hide();
		});

		//셀렉트 리스트박스 위치조정
		function selectPosition( obj ){
			
            var This = $( obj );
			var parentWidth = This.parent().width()
			var parentHeight = This.parent().height();
			var bodyChk = $(window).height();
			var ThisY = This.offset().top;
			var ThisL = This.offset().left;
			var ScHeight = $(window).scrollTop();
			var listHeight = $SHOW_DIV.height();
			var bottomHeight = ( (bodyChk - ThisY - parentHeight) + ScHeight );
			var elemHeight = (isNaN(Number(This.height())) ? 0 : Number(This.height())) + 6;
			var elemHeight2 = (isNaN(Number(This.height())) ? 0 : Number(This.height())) + 2;
			
			if(bottomHeight < listHeight){
				//위로	
				$SHOW_DIV.css({"width":parentWidth-2 + "px","top":((ThisY - listHeight - 2)-ScHeight + "px"),"left":ThisL + "px","bottom":"inherit"});				
			}else{
				//아래로
				if($DIV.hasClass("PUDD-UI-selectBox")){					
					$SHOW_DIV.css({"width":parentWidth-2 + "px","top":((ThisY + elemHeight)-ScHeight + "px"),"left":ThisL + "px","bottom":"inherit"});	
				
				}else if($DIV.hasClass("PUDD-UI-multiSelectBox")){					
					$SHOW_DIV.css({"width":parentWidth-2 + "px","top":((ThisY + elemHeight2)-ScHeight + "px"),"left":ThisL + "px","bottom":"inherit"});					
				};
			};


		}
		
		//삭제
		function fnRegDeleteEvent( ){
			$MULTI_UL.unbind( );
			$MULTI_UL.find( ".del_btn" ).off( 'click' );
			$MULTI_UL.find( ".del_btn" ).on( "click", function( event ){	
				if( event.stopImmediatePropagation ){ event.stopImmediatePropagation( ); } //MOZILLA
				else{ event.isImmediatePropagationEnabled = false; }//IE
				
				var cloneIndex = $( this ).attr( "cloneindex" );
				$( this ).parent( ).parent( ).parent( ).siblings( ".cloneList" ).children( ).find( "li" ).eq( cloneIndex ).removeClass( "on" );
				$( this ).parent( ).remove( );
				
			});
		}
		
		fnRegDeleteEvent( );
		$SHOW_DIV.unbind( );
		$SHOW_DIV.find( 'li' ).off( 'click' );
		//multiSelectBox의 리스트를 클릭했을때
		$SHOW_DIV.find( 'li' ).on( "click", function( ){
			
			if( !$( this ).hasClass( "on" ) ){
				var clickTxt = $( this ).text( );
				var liIndex = $( this ).index( );
				
				var $OPTION = $( $SELECT.find( 'option' )[ liIndex ] );
				
				var LI = document.createElement( 'LI' );
				var SPAN = document.createElement( 'SPAN' );
				var A = document.createElement( 'A' );
				var textnode = document.createTextNode( $OPTION.html( ) );
				
				SPAN.appendChild( textnode );
				LI.appendChild( SPAN );
				LI.appendChild( A );
				$( SPAN ).attr( 'data-value', $OPTION.val( ) );
				$( A ).attr( 'href', 'javascript:void(0);' );
				$( A ).attr( 'cloneIndex', liIndex );
				$( A ).addClass( 'del_btn' );
				
				$( this ).parent( ).parent( ).siblings( '.selectField' ).children( '.multiBox' ).append( $( LI ) );
				fnRegDeleteEvent( );
				$SELECT.change( );
			};
			
			$(this).addClass( "on" );
			$(".cloneList").removeClass("animated03s fadeIn").hide();
			$(".toolTip").removeClass("animated03s fadeInUp");
			$(".toolTip").css("display","none");
			
		}).hover(function(event){
			if(event.type == "mouseenter" ){
				$(this).addClass("hover");	
			}else{
				$(this).removeClass("hover");
			};
			
		});
		
		
		$SHOW_TOP_DIV.unbind( );
		$SHOW_TOP_DIV.off( 'click' );
		$SHOW_TOP_DIV.on( "click", function( ){
			if( $( this ).hasClass( "disabled" )){
				$( this ).blur( );
				
			}else if( $( this ).hasClass( "on" ) ){
				$( this ).removeClass( "on" ).blur( );
				$( this ).parent( ).find( ".cloneList" ).removeClass( "animated03s fadeIn" ).hide( );
			
			}else{
				$( this ).focus( );
				selectPosition( this );
				$( this ).addClass( "on" );
				$( ".cloneList" ).removeClass( "animated03s fadeIn" ).hide( );
				$( this ).parent( ).find( ".cloneList" ).addClass( "animated03s fadeIn" ).show( );
			};
			
		}).blur( function( ){
			if( !$( this ).siblings( ".cloneList" ).children( ).find( "li" ).hasClass( "hover" ) ){
				$( ".cloneList" ).removeClass( "animated03s fadeIn" ).hide( );
			};
			$( this ).removeClass( "on" );
			
		});
		
		if( tooltip ){			
			//selectField의 리스트에 마우스를 올렸을때
			$SHOW_DIV.find( 'li' ).on( "mouseenter", function( ){				
				var This = $( this );
				var ThisY = This.offset( ).top;
				var ScHeight = $(window).scrollTop( );
				var elemHeight = (isNaN(Number(This.height( ))) ? 0 : Number(This.height( ))) + 9;
				
				This.parent( ).parent( ).siblings( ".toolTip" ).css( "display","block" );
				This.parent( ).parent( ).siblings( ".toolTip" ).text($( this ).text( ))
				This.parent( ).parent( ).siblings( ".toolTip" ).css( "top",(( ThisY + elemHeight ) - ScHeight + "px") );
				This.parent( ).parent( ).siblings( ".toolTip" ).addClass( "animated03s fadeInUp" );
				
			});
			
			//selectField의 리스트에서 마우스를 뺐을때
			$SHOW_DIV.on( "mouseleave", function( ){				
				var This = $( this );
				This.parent( ).find( ".toolTip" ).removeClass( "animated03s fadeInUp" );
				This.parent( ).find( ".toolTip" ).css( "display","none" );
				
			});
			
			//cloneList에서 스크롤이동 시 툴팁제거
			$SHOW_DIV.scroll(function( ){ 				
				$( ".toolTip" ).removeClass( "animated03s fadeInUp" );
				$( ".toolTip" ).css( "display" ,"none" );
				
			});
		}
		
	}
	
	ComponentCommander.combo = function( ) { };
	ComponentCommander.combo.prototype.setSelected = function( that ){
			
		if( arguments.length < 2) {
			console.log( arguments );
			console.error( '인자값이 부족합니다.' );
			return false;
		}
		
		var arg = arguments[1];
		
		var index = undefined;
		var text = undefined;
		
		if( isNaN( Number(arg [ 0 ]) ) ){
			text = arg[ 0 ].toString( );
		}else{
			index = arg[ 0 ].toString( );
		}

		var $selector = $( that.selector );
		var $cloneList = $( "#" + $selector.attr( 'id' ) + '_showDiv' );
		
		if( index != undefined ){
			$cloneList.find( 'li:eq(' + index + ')' ).click( );			
		}else if( text != undefined ){
			
			$cloneList.find( 'li:contains('+ text +')' ).click( );			
		}
	};
	
	ComponentCommander.combo.prototype.setAddItem = function( that ){
		
		if( arguments.length < 2) {
			console.log( arguments );
			console.error( '인자값이 부족합니다.' );
			return false;
		}
		var arg = arguments[1];
		var text = arg[ 0 ].toString( );
		var value = arg[ 1 ].toString( );
		var pIndex = arg[ 2 ] == null ? undefined : arg[ 2 ].toString( );
	
		
		var $selector = $( that.selector );
		var $cloneList = $( "#" + $selector.attr( 'id' ) + '_showDiv' );
		var tooltipYN = $selector.siblings( '.toolTip' ).length == 0 ? false : true;
		var $topDiv =  $( "#" + $selector.attr( 'id' ) + '_div' );
		
		if( text == undefined || value == undefined ){
			console.error( '추가할 항목의 정보가 부족합니다.' );
			return false;
		}
		//생성
		var OPTION = "<option value="+ value +">"+ text + "</option>";
		var LI = document.createElement( 'li' );
		var $LI = $( LI );
		var textnode = document.createTextNode( text );
		LI.appendChild( textnode );
		
		//인덱스 확인
		if( pIndex != undefined ){
			//현재 존재하는 option보다 입력된 인덱스가 더 큰 경우 맨뒤에 삽입
			if( $selector.find( 'option' ).length < Number( pIndex ) ){				
				$selector.append( OPTION );
				$cloneList.find( 'ul' ).append( LI )
			}else{
				$.each( $selector.find( 'option' ), function( index, item ){
					if( index == Number( pIndex ) ){
						$( item ).before( OPTION );
						return false;
					}
				});
				
				$.each( $cloneList.find( 'li' ), function( index, item ){
					if( index == Number( pIndex ) ){
						$( item ).before( LI );
						return false;
					}
				});
			}
		}else{
			//인덱스가 없으면 맨뒤에 삽입
			$selector.append( OPTION );
			$cloneList.find( 'ul' ).append( LI );
		}
		
		var event = [ ];
		if( $topDiv.hasClass( 'PUDD-UI-selectBox' ) ){
			var comboEvent = {
				divId : $selector.attr( 'id' ) + '_div',
				selectId : $selector.attr( 'id' ),
				spanId : '',
				showTopDivId : $selector.attr( 'id' ) + '_showTopDiv',
				showDivId : $selector.attr( 'id' ) + '_showDiv',
				tooltip : tooltipYN,
				eventName : 'comboEvent',
			};
			event.push( comboEvent );
			var comboEvent = new ComboEvent( event );
			comboEvent.createEvent( );
			
		}else if( $topDiv.hasClass( 'PUDD-UI-multiSelectBox' ) ){
			var multiComboEvent = {
				divId : $selector.attr( 'id' ) + '_div',
				selectId : $selector.attr( 'id' ),
				multiUlId : $selector.attr( 'id' ) + '_ul',
				showTopDivId : $selector.attr( 'id' ) + '_showTopDiv',
				showDivId : $selector.attr( 'id' ) + '_showDiv',
				tooltip : tooltipYN,
				eventName : 'multiComboEvent',
			};
			event.push( multiComboEvent );
			var comboEvent = new ComboEvent( event );
			comboEvent.createEvent( );
		}
		
		
	};
	
	/* 비활성화 */
	ComponentCommander.combo.prototype.setDisabled = function( that ){
		$( that.selector ).attr( 'disabled', 'disabled' );
	};
	
	/* 활성화 */
	ComponentCommander.combo.prototype.setEnabled = function( that ){
		$( that.selector ).removeAttr( 'disabled' );
	};
	
	ComponentCommander.combo.prototype.getSelected = function( that ){
		$( that.selector ).val( );
	};
	

})(jQuery);
