/**
* @project_description PUDD( 가칭 ) Component CHECK BOX
*
* @author 임헌용 ( 더존비즈온 UC개발본부 UC개발센터 UC개발1팀 )
* @version PUDD 0.0.0 ( 개발 버전 )
* @Revision_history
* 		- 2017.09.25 최초 작성( 임헌용 )
*/

(function ($) {

    /* 싱글 CheckBox기능을 위한 Jquery 확장 함수 */
    $.fn.PuddCheck = function (opt) {
        $.each($(this), function (index, item) {
            if ($(this).attr('id') == undefined || $(this).attr('id') == '') {
                $(this).attr('id', Pudd.getGlobalVariable('fnRandomString'));
            }

            var parameter = {
                id: $(this).attr('id'),
                class: $(this).attr('class') || '',
                option: opt || {}
            };

            var puddCheckBox = new PuddCheckBox(parameter);
            //체크박스 생성
            Pudd.makeComponent($(this), puddCheckBox);
        });
    };

    /* 멀티 CheckBox 기능을 위한 Jquery 확장 함수 */
    $.fn.PuddGroupCheck = function (opt) {
        $.each($(this), function (index, item) {

            if ($(this).attr('id') == undefined || $(this).attr('id') == '') {
                $(this).attr('id', Pudd.getGlobalVariable('fnRandomString'));
            }
            var $selector = $(this);
            var _id = $(this).attr('id');
            var _class = $(this).attr('class') || '';
            var _selector = $(this);
            var _opt = opt || {};
            var groupDIV = $(this);

            //하위 요소 삭제
            $(this).empty();
            //스타일 초기화
            $(this).removeAttr('style');
            $(this).removeClass();
            //이벤트 초기화
            $(this).off();
            $(this).unbind();


            if (opt.group != undefined) {
                if (opt.group.item.length < 0) {
                    console.log('체크박스 그룹 아이템을 지정하지 않았습니다.');
                    return false;
                }
                //groupDIV 설정
                puddCheckBoxClass.pushGroupDivClass($(this), _opt);

                $.each(opt.group.item, function (index, item) {
                    //console.log(JSON.stringify(opt));
                    //옵션 복사
                    var newOpt = JSON.parse(JSON.stringify(opt));

                    //그룹key 삭제
                    delete newOpt.group;

                    //console.log(newOpt);
                    //console.log(item);
                    // 그룹을 가지고 체크박스 옵션을 넣어준다.
                    newOpt.text = item.text || '';
                    newOpt.value = item.value || '';
                    newOpt.checked = item.checked || false;
                    newOpt.dash = item.dash || false;
                    newOpt.name = opt.group.groupName || '';
                    newOpt.disabled = item.disabled || false;
                    newOpt.onclick = item.onclick || undefined;
					newOpt.onchange = item.onchange || undefined;
                    // div 생성
                    var newDIV = document.createElement( "DIV" );
                    $(newDIV).attr('id', Pudd.getGlobalVariable('fnRandomString'));
                    $(newDIV).attr('class', _class + '_' + index);

                    // div 생성 후 TopDiv 자식으로 설정
                    groupDIV.append(newDIV);

                    var parameter = {
                        id: $(newDIV).attr('id'),
                        class: $(newDIV).attr('class') || '',
                        option: newOpt || {}
                    };

                    // console.log('text:' + newOpt.text + ', disabled :' + newOpt.dash);
                    
                    // 체크박스 생성
                    var puddCheckBox = new PuddCheckBox(parameter);
                    // 체크박스 생성
                    Pudd.makeComponent($(newDIV), puddCheckBox);

                });

            } else {
                console.log('체크박스 그룹을 지정하지 않았습니다.');
            }
        });

    };

	
	
	
    /**
    * <pre>
    * 1. 개요
    * 		CheckBox 함수
    * 2. 처리내용
    * 		- BizLogic 처리 :
    *			1) 초기 옵션값이 존재하면 값을 매핑하고 없다면 기본 { }을 매핑한다.
    *			2)
    * 3. 입력 Data :  json
    * 4. 출력 Data :    
    * @Method Name : PuddCheckBox
    * @param $
    */
    function PuddCheckBox(parameter) {
        /* 개발자 옵션 */
        this.id = parameter.id;
        this.class = parameter.class;
        this.$selector = null;
        this.option = parameter.option;
        this.name = null;
		this.onclick = null;
		this.onchange = null;
        /* 생성할 엘리먼트 */
        this.DIV = null;
        this.INPUT = null;
        this.LABEL = null;

        /* 생성할 엘리먼트 선택자*/
        this.$DIV = null;
        this.$INPUT = null;
        this.$LABEL = null;

        /* 생성할 이벤트 */
        this.event = [];

        /* 클래스 및 스타일 추출 */
        this.inStyle = null;
        this.inClass = null;
        this.outStyle = null;
        this.outClass = null;

    }


    PuddCheckBox.prototype = {

        _createElement: function (tagName) {
            tagName = tagName.toUpperCase();
            switch (tagName) {
                case "INPUT":
                    this.INPUT = document.createElement( "INPUT" );
                    this.$INPUT = $(this.INPUT);
                    break;

                case "LABEL":
                    this.LABEL = document.createElement( "LABEL" );
                    this.$LABEL = $(this.LABEL);
                    break;
            }
        },
        init: function () {
            this.DIV = document.getElementById(this.id);
            this.$DIV = $(this.DIV);
            this.$selector = $(this.DIV);
            CommonUtil.extractQueryAttribute( this.option, this );
            CommonUtil.extractAttribute( this.$selector, this );
          
            this._createElement('INPUT');
            this._createElement('LABEL');

        },
        setElementAssembly: function () {
            this.DIV.appendChild(this.INPUT);

            if ( this.option.dash == true || String(this.option.dash).toUpperCase() === 'TRUE') {
                if ( this.option.disabled == true || String( this.option.disabled ).toUpperCase() === 'TRUE') {
                    var svg = CommonUtil.searchSVGObject('DASH_DISABLE');
                    this.$INPUT.after(svg);

                } else {
                    var svg = CommonUtil.searchSVGObject('DASH');
                    this.$INPUT.after(svg);

                }
            } else {
                if (this.option.disabled == true || String(this.option.disabled).toUpperCase() === 'TRUE') {
                    var svg = CommonUtil.searchSVGObject('CHECK_DISABLE');
                    this.$INPUT.after(svg);

                } else {
                    var svg = CommonUtil.searchSVGObject('CHECK');
                    this.$INPUT.after(svg);
                }
            }

            if (this.LABEL != null) {
                this.DIV.appendChild(this.LABEL);
                if (this.option.text != undefined) {
                    var TEXT = document.createTextNode(this.option.text);
                    $( this.LABEL ).append( TEXT );
                }
            }
        },
        setElementStyle: function () {
            puddCheckBoxStyle.pushDivStyle(this.$DIV, this.outStyle);
            if (this.INPUT != null) {
                puddCheckBoxStyle.pushInputStyle(this.$INPUT, this.inStyle);
            }
        },
        setElementClass: function () {
            puddCheckBoxClass.pushDivClass(this.$DIV, this.option, this.outClass);
            puddCheckBoxClass.pushInputClass(this.$INPUT, this.inClass);
        },
        setElementAttribute: function () {
            puddCheckBoxAttribute.pushDivAttribute(this.$DIV, this.option, this.id);

            if (this.INPUT != null) {
                puddCheckBoxAttribute.pushInputAttribute(this.$INPUT, this.option, this.id, this.name, this.onclick, this.onchange );
            }

            if (this.LABEL != null) {
                puddCheckBoxAttribute.pushLabelAttribute(this.$LABEL, this.option, this.id);
            }
        },
        setEvent: function () {
            if (this.INPUT != null) {

                var multiCheck = this.option.checked == undefined ? false : this.option.checked;
                var checkEvent = {
                    inputId: this.$INPUT.attr('id'),
                    inputName: this.$INPUT.attr('name'),
                    divId: this.$DIV.attr('id'),
                    eventName: 'CheckBoxChecked',
                    multiCheck: this.option.multiCheck,
                    multiCheckCount: this.option.multiCheckCount
                };

                this.event.push(checkEvent);
            }

            var checkBoxEvent = new CheckBoxEvent(this.event, this.option);
            checkBoxEvent.createEvent();

        }
    }


    /**
    * <pre>
    * 1. 개요
    * 		Class 지정을 위한 객체 리터럴
    * 		※테마 설정 존재 Dev.THEMA
    * 2. 처리내용
    * 		- BizLogic 처리 :
    * 			1) pushGroupDivClass : 그룹 CheckBox div 클래스 지정
    * 			2) pushDivClass : 단일 CheckBox div 클래스 지정
    * 			3) pushInputClass : CheckBox input 클래스 지정
    * 3. 입력 Data : 
    * 4. 출력 Data : 
    * </pre>
    * @Method Name : 
    * @param $
    * 			#TODO 모듈명 NAMESPACE를 IMPORT해야 한다.
    */
    var puddCheckBoxClass = {
        pushGroupDivClass: function ($element, classJson) {
            var group = classJson.group == undefined ? {} : classJson.group;
            $element.addClass('PUDD-SET-ChkRadi');
            //푸딩 설정
			$element.addClass( Pudd.getGlobalVariable( 'PRETEXT' ) );
            
            if (group.align.toUpperCase() === 'HORIZON') {
                $element.addClass('PUDD-UI-Horizon');
            } else {
                $element.addClass('PUDD-UI-Vertical');
            }

        },

        pushDivClass: function ($element, classJson, outClass) {
            $element.addClass( 'PUDD-UI-checkbox' );
            $element.addClass( Pudd.getGlobalVariable( 'THEMA' ) );
            $element.addClass( 'PUDD-UI-ChkRadi' );
            
            if( classJson.text == undefined || classJson.text == ''){
            	$element.addClass('PUDD-UI-ONLY');
            }
            
            //푸딩 설정
			$element.addClass( Pudd.getGlobalVariable( 'PRETEXT' ) );

            if (classJson.dash == true || String(classJson.dash).toUpperCase() === 'TRUE') {
                $element.addClass('UI-Dash');
            }

            if (classJson.checked == true || String(classJson.checked).toUpperCase() === 'TRUE') {
                $element.addClass('UI-ON');
            }

            if (classJson.disabled == true || String(classJson.disabled).toUpperCase() === 'TRUE') {
                $element.addClass('UI-Disa');
            }

            if (outClass != null) {
                $element.addClass(outClass);
            }
        },

        pushInputClass: function ($element, inClass) {
            $element.addClass('PUDDCheckBox');
            if (inClass != null) {
                $element.addClass(inClass);
            }
        }
    }



    /**
    * <pre>
    * 1. 개요
    * 		스타일 지정에 대한 객체 리터럴
    * 2. 처리내용
    * 		- BizLogic 처리 :
    *			1) 
    *			2)  
    * 3. 입력 Data : 
    * 4. 출력 Data : 
    * </pre>
    * @Method Name :
    * @param $
    */
    var puddCheckBoxStyle = {
        pushDivStyle: function ( $element, outStyle ) {
            if (outStyle != null) {
                outStyle = JSON.parse(JSON.stringify(outStyle));
                $.each(outStyle, function (key, value) {
                    $element.css(key, value);
                });
            }
        },
        pushInputStyle: function ( $element, inStyle ) {
            if (inStyle != null) {
                inStyle = JSON.parse(JSON.stringify(inStyle));
                $.each(inStyle, function (key, value) {
                    $element.css(key, value);
                });
            }
        },

        pushLabelStyle: function ($element, styleJson) {

        }
    }


    /**
    * <pre>
    * 1. 개요
    * 		Attribute 지정을 위한 객체 리터럴
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
    var puddCheckBoxAttribute = {
        pushGroupDivAttribute: function ($element, attrJson, id) {
            attrJson = attrJson == undefined ? {} : attrJson;
            attrJson = CommonUtil.castToJSONObject(attrJson);
            $element.attr( "id", CommonUtil.createId(id, "groupDiv" ));
        },

        pushDivAttribute: function ($element, attrJson, id) {
            attrJson = attrJson == undefined ? {} : attrJson;
            attrJson = CommonUtil.castToJSONObject(attrJson);
            $element.attr( "id", CommonUtil.createId(id, "div" ));
        },

        pushInputAttribute: function ($element, attrJson, id, name, onclick, onchange ) {
            attrJson = attrJson == undefined ? {} : attrJson;
            attrJson = CommonUtil.castToJSONObject(attrJson);

            // id 생성
            if (id != undefined && id !== '') {
                $element.attr( "id", id);
            }

            // type 생성
            $element.attr( "type", "checkbox" );
          
            // 옵션 name 생성
            if (attrJson.name != undefined && attrJson.name !== '') {
                $element.attr( "name", attrJson.name );
            }
            
            // name 생성 ( 인라인 우선 적용 )
            if ( name != null ){
                $element.attr( "name", name );
            }
                            
            // onclick 생성
            if (attrJson.onclick != undefined ) {
                $element.attr( "onclick", attrJson.onclick );
            }
            
            if (attrJson.onclick != null ) {
                $element.attr( "onclick", onclick );
            }
            
            // onchange 생성
            if (attrJson.onchange != undefined ) {
                $element.attr( "onchange", attrJson.onchange );
            }
            
            if (attrJson.onclick != null ) {
                $element.attr( "onchange", onchange );
            }
            
            
            //인라인 우선적용
            
            // value 생성
            if (attrJson.value != undefined && attrJson.value !== '') {
                $element.attr( "value", attrJson.value);
            }

            // checked 생성
            if (attrJson.checked != undefined && (attrJson.checked == true || String(attrJson.checked).toUpperCase() === 'TRUE')) {
                $element.prop('checked', true);
            }

            // disabled 생성
            if (attrJson.disabled != undefined && (attrJson.disabled == true || String(attrJson.disabled).toUpperCase() === 'TRUE')) {
                $element.prop('disabled', true);
            }

        },

        pushLabelAttribute : function ($element, attrJson, id) {
            attrJson = attrJson == undefined ? {} : attrJson;
            attrJson = CommonUtil.castToJSONObject(attrJson);
        }

    }

    /**
    * <pre>
    * 1. 개요
    * 		CheckBox 이벤트 함수
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
    function CheckBoxEvent(eventArrayJson, optJson) {
        this._eventArrayJson = eventArrayJson;
        this._optionJson = optJson;
    }


    /**
    * <pre>
    * 1. 개요
    * 		CheckBox 이벤트 생성 및 바인딩
    * 2. 처리내용
    * 		- BizLogic 처리 :
    *			1)  멤버변수인 이벤트 배열을 탐색하며 이벤트를 지정한다.
    *			2)  
    *			3)  
    * 3. 입력 Data :   
    * 4. 출력 Data :    
    * @Method Name : CheckBoxEvent.createEvent
    * @param $
    */
    CheckBoxEvent.prototype.createEvent = function () {
        var thisObject = this;
        $.each(this._eventArrayJson, function (index, item) {
            var eventName = item.eventName;
            switch (eventName) {
                case "CheckBoxChecked":
                    thisObject.CheckBoxChecked(item);
                    break;
                default:
                    break;
            }
        });
    }


    /**
    * <pre>
    * 1. 개요
    * 		CheckBox 체크 이벤트
    * 2. 처리내용
    * 		- BizLogic 처리 :
    *			1)  
    *			2)  
    * 3. 입력 Data : eventJson{ divId, inputId, tooltipId, tooltipMsg } 
    * 4. 출력 Data :    
    * @Method Name : CheckBoxEvent.CheckBoxCheked
    * @param $
    */
    CheckBoxEvent.prototype.CheckBoxChecked = function (eventJson) {

        var $INPUT = $( "#" + eventJson.inputId);
        var name = $( "#" + eventJson.inputName);
        var $DIV = $( "#" + eventJson.divId);
        var multiCheck = eventJson.multiCheck;
        var multiCheckCount = eventJson.multiCheckCount;

        $('.PUDD-UI-checkbox').off('click');

        // $('input[type="CheckBox"][name='+ name +']').click(function(){
        $('.PUDD-UI-checkbox').on('click', function () {
            var $CHKDIV = $(this);
            var boxName = $(this).children(' input ').attr('name') || '';
            var boxId = $(this).children(' input ').attr('id') || '';
            var $Condition = null;
            multiCheckCount = (multiCheckCount == undefined ? 1000 : multiCheckCount);

            //문자라면 1000로 강제 지정
            if (isNaN(multiCheckCount)) {
                multiCheckCount = 1000;
            }



            //클릭 이벤트 발생한 요소가 선택 상태일 경우
            //체크된 요소 확인후 복수개 선택되있을 경우 체크 해제
            if ($(this).hasClass('UI-Disa')) {
                return false;
            }

            if (boxName != '') {
                $Condition = $('input[type="checkbox"][name=' + boxName + ']');
            } else if (boxId != '') {
                $Condition = $(' input[type="checkbox"][id=' + boxId + ']');
            }

            if (multiCheck == true || String(multiCheck).toUpperCase() == 'TRUE') {
                /* 멀티체크  */
                if ($CHKDIV.hasClass('UI-ON')) {
                    
                    
                    if( $Condition.length < 2){                    
                    	$CHKDIV.find( 'input[type="checkbox"]' ).prop( 'checked' , false );
                    }else{
                    	$Condition.prop('checked', false);
                    }                    
                    $CHKDIV.removeClass('UI-ON');
                } else {
                    /* 멀티체크이며 체크할 숫자가 정해진 경우 */
                    if ($Condition.parent('.UI-ON').length >= multiCheckCount) {
                        
                        return false;
                    } else {
                        
                         if( $Condition.length > 2 ){
	                    	$CHKDIV.find( 'input[type="checkbox"]' ).prop( 'checked' , true );
	                    }else{
	                    	$Condition.prop('checked', true);
	                    } 	                                                
                        $CHKDIV.addClass('UI-ON');
                    }
                }
            } else {
                /* 단일 체크 */
                if ($CHKDIV.hasClass('UI-ON')) {
                    
                    if( $Condition.length < 2){
                    	$Condition.prop('checked', false);
                    }else{
                    	$CHKDIV.find( 'input[type="checkbox"]' ).prop( 'checked' , false );
                    }                
                    $CHKDIV.removeClass('UI-ON');

                } else {
                    //체크불가
                    if ($Condition.is(':checked')) {
                        
                        return false;
                    }
                                     
                    $Condition.prop('checked', false);                                  
                    $Condition.parent().removeClass('UI-ON');
                    
                    if( $Condition.length > 2 ){
                    	$CHKDIV.find( 'input[type="checkbox"]' ).prop( 'checked' , true);
                    }else{
                    	$Condition.prop('checked', true);
                    }                                     
                    $CHKDIV.addClass('UI-ON');
                }
            }
        });
    }

    ComponentCommander.checkbox = function( ){ };    
    ComponentCommander.checkbox.prototype.setChecked = function( that ){
    	
    	var pIndex = arguments[ 1 ] == null ? undefined : arguments[ 1 ][ 0 ].toString( );
		var $selector = $( that.selector );
		var $top = $( '#' + $selector.attr( 'id' ) + '_div' );
		
		if( $selector.hasClass( 'PUDD-SET-ChkRadi' ) ){
			/* 그룹 체크박스 */
			if( pIndex != undefined ){
				$.each( $selector.find( '.PUDD-UI-checkbox' ), function( index, item ){					
					if( Number( pIndex ) == index ){
						$( item ).click( );
						return false;
					}			
				});							
			}
			
		}else if( $top.hasClass( 'PUDD-UI-checkbox' ) ){
			/* 단일 체크박스 */
			$selector.click( );
		}
		
	};
	
	/* 비활성화 */
	ComponentCommander.checkbox.prototype.setDisabled = function( that ){
		
		var pIndex = arguments[ 1 ] == null ? undefined : arguments[ 1 ][ 0 ].toString( );
		var $selector = $( that.selector );
		var $top = $( '#' + $selector.attr( 'id' ) + '_div' );
		
		if( $selector.hasClass( 'PUDD-SET-ChkRadi' ) ){
			/* 그룹 체크박스 */
			if( pIndex != undefined ){
				$.each( $selector.find( '.PUDD-UI-checkbox' ), function( index, item ){					
					if( Number( pIndex ) == index ){
						$( item ).find( 'input' ).attr( 'disabled', 'disabled' );						
						$( item ).addClass( 'UI-Disa' );
						
						if( $( item ).find( 'rect' ).length > 0 ){
							$top.find( 'svg' ).remove( );
							$( item ).find( 'input' ).after( CommonUtil.searchSVGObject( 'DASH_DISABLE' ) );
						}else{
							$top.find( 'svg' ).remove( );
							$( item ).find( 'input' ).after( CommonUtil.searchSVGObject( 'CHECK_DISABLE' ) );
						}
						return false;
					}			
				});							
			}
			
		}else if( $top.hasClass( 'PUDD-UI-checkbox' ) ){
			$selector.attr( 'disabled', 'disabled' );		
			$top.addClass( 'UI-Disa' );
	
			if( $top.find( 'rect' ).length > 0 ){
				$top.find( 'svg' ).remove( );
				$top.find( 'input' ).after( CommonUtil.searchSVGObject( 'DASH_DISABLE' ) );
			}else{
				$top.find( 'svg' ).remove( );
				$top.find( 'input' ).after( CommonUtil.searchSVGObject( 'CHECK_DISABLE' ) );
			}
		}
	};
	
	/* 활성화 */
	ComponentCommander.checkbox.prototype.setEnabled = function( that ){
		
		var pIndex = arguments[ 1 ] == null ? undefined : arguments[ 1 ][ 0 ].toString( );
		
		var $selector = $( that.selector );
		var $top = $( '#' + $selector.attr( 'id' ) + '_div' );
		
		if( $selector.hasClass( 'PUDD-SET-ChkRadi' ) ){
			/* 그룹 체크박스 */
			if( pIndex != undefined ){
				$.each( $selector.find( '.PUDD-UI-checkbox' ), function( index, item ){					
					if( Number( pIndex ) == index ){
						$( item ).find( 'input' ).removeAttr( 'disabled' );
						$( item ).removeClass( 'UI-Disa' );
						
						if( $( item ).find( 'rect' ).length > 0 ){
							$( item ).find( 'svg' ).remove( );
							$( item ).find( 'input' ).after( CommonUtil.searchSVGObject( 'DASH' ) );
						}else{
							$( item ).find( 'svg' ).remove( );
							$( item ).find( 'input' ).after( CommonUtil.searchSVGObject( 'CHECK' ) );
						}
						return false;
					}			
				});							
			}
			
			
		}else if( $top.hasClass( 'PUDD-UI-checkbox' ) ){
			$selector.removeAttr( 'disabled' );
			$top.removeClass( 'UI-Disa' );			
	
			if( $top.find( 'rect' ).length > 0 ){
				$top.find( 'svg' ).remove( );
				$top.find( 'input' ).after( CommonUtil.searchSVGObject( 'DASH' ) );
			}else{
				$top.find( 'svg' ).remove( );
				$top.find( 'input' ).after( CommonUtil.searchSVGObject( 'CHECK' ) );
			}
		}
	};
	
	ComponentCommander.checkbox.prototype.getChecked = function( that ){		
		var $selector = $( that.selector );
		
		if( $selector.hasClass( 'PUDD-SET-ChkRadi' ) ){
			/* 그룹 체크박스 */
			var retArray = [];			
			$.each( $selector.find( 'input[type=checkbox]' ), function( index, item ){					
				if( $( item ).is(":checked") ){
					var checkbox = {};
					checkbox.value = $( item ).val( );
					checkbox.index = index;						
					retArray.push( checkbox );
				}			
			});
			return retArray;
			
		}else if( $top.hasClass( 'PUDDRadio' ) ){
			/* 단일 체크박스 */
			return $selector.val( );
		}
	};
	


})(jQuery);



