/**
 * @project_description PUDD( 가칭 ) Component ATTACH FILED
 * 
 * @author 임헌용 ( 더존비즈온 UC개발본부 UC개발센터 UC개발1팀 )
 * @version PUDD 0.0.0 ( 개발 버전 )
 * @Revision_history - 2017.10.27 최초 작성( 임헌용 )
 */

(function($) {

	/* 기본 버튼기능을 위한 Jquery 확장 함수 */
	$.fn.PuddAttach = function(_opt) {
		$.each($( this ), function(index, item) {
			if ($( this ).attr('id') == undefined || $( this ).attr('id') == '') {
				$( this ).attr('id', Pudd.getGlobalVariable('fnRandomString'));
			}

			var parameter = {
				id : $( this ).attr('id'),
				class : $( this ).attr('class') || '',
				option : _opt || {},
				name : $( this ).attr('name') || '',
				type : 'BASIC'
			};

			var puddAttach = new PuddAttach( parameter );
			Pudd.makeComponent( $( this ), puddAttach);
		});

	};

	function PuddAttach(parameter) {
		/* 개발자 옵션 */
		this.id = parameter.id;
		this.class = parameter.class;
		this.$selector = null;
		this.option = parameter.option;
		this.type = parameter.type;
		this.name = parameter.name || null;
		this.onclick = null;

		/* 생성할 엘리먼트 */
		this.DIV = null;
		this.INPUT = null;
		this.A = null;
		this.INPUT_FILE = null;

		/* 생성할 엘리먼트 선택자 */
		this.$DIV = null;
		this.$INPUT = null;
		this.$A = null;
		this.$INPUT_FILE = null;

		/* 생성할 이벤트 */
		this.event = [];

		/* 클래스 및 스타일 추출 */
		this.inStyle = null;
		this.inClass = null;
		this.inName = null;
		this.inClick = null;
		this.outStyle = null;
		this.outClass = null;

	}

	PuddAttach.prototype = {

		_createElement : function(tagName) {
			tagName = tagName.toUpperCase();
			switch (tagName) {
			case 'INPUT':
				this.INPUT = document.createElement('INPUT');
				this.$INPUT = $( this.INPUT );
				break;

			case 'A':
				this.A = document.createElement('A');
				this.$A = $( this.A );
				break;

			case 'INPUT_FILE':
				this.INPUT_FILE = document.createElement('INPUT');
				this.$INPUT_FILE = $( this.INPUT_FILE );
				break;
			}

		},

		init : function() {
			this.DIV = document.getElementById( this.id );
			this.$DIV = $( this.DIV );
			this.$selector = $( this.DIV );

			CommonUtil.extractQueryAttribute(this.option, this);
			CommonUtil.extractAttribute(this.$selector, this);

			this._createElement('INPUT');
			this._createElement('A');
			this._createElement('INPUT_FILE');
		},

		setElementAssembly : function() {
			var type = this.type == undefined ? '' : this.type.toUpperCase();
			var textnode = '';
			this.DIV.appendChild(this.INPUT);
			this.DIV.appendChild(this.A);
			if (this.option.btnName != undefined) {
				textnode = document.createTextNode(this.option.btnName);
			} else {
				textnode = document.createTextNode('파일찾기');
			}
			this.A.appendChild(textnode);
			this.DIV.appendChild(this.INPUT_FILE);
		},

		setElementStyle : function( ) {
			puddAttachStyle.pushDivStyle( this.$DIV, this.outStyle );
			puddAttachStyle.pushInputStyle( this.$INPUT, this.$INPUT_FILE ,this.option ,this.inStyle );
		},

		setElementClass : function() {
			puddAttachClass.pushDivClass(this.$DIV, this.option, this.class,
					this.outClass);
			puddAttachClass.pushInputClass(this.$INPUT, this.option,
					this.class, this.inClass);
			puddAttachClass.pushAClass(this.$A, this.option);
			puddAttachClass.pushInptFileClass(this.$INPUT_FILE);
		},

		setElementAttribute : function() {
			puddAttachAttribute.pushDivAttribute(this.$DIV, this.option,
					this.id, this.name, this.onclick);
			puddAttachAttribute.pushInputAttribute(this.$INPUT, this.option,
					this.id);
			puddAttachAttribute.pushAAttibute(this.$A, this.id);
			puddAttachAttribute.pushInputFileAttribute(this.$INPUT_FILE,
					this.id);

		},

		setEvent : function() {
		},
	}

	/**
	 * <pre>
	 * 1. 개요
	 * 		스타일 지정에 대한 객체 리터럴
	 * 2. 처리내용
	 * 		- BizLogic 처리 :
	 * 		1) pushDivStyle : 선택자(DIV)에 대한 스타일 지정
	 * 		2) pushInputStyle : 선택자(INPUT)에 대한 스타일 지정 
	 * 		3) 
	 * 3. 입력 Data : 
	 * 4. 출력 Data : 
	 * </pre>
	 * 
	 * @Method Name : pushDivStyle, pushInputStyle
	 * @param $
	 */
	var puddAttachStyle = {
		pushDivStyle : function( $element, outStyle ) {
			if ( outStyle != null ) {
				outStyle = JSON.parse( JSON.stringify( outStyle ) );
				$.each( outStyle, function( key, value ) {
					$element.css( key, value );
				});
			}

		},

		pushInputStyle : function( $element, $btn, option, inStyle ) {
			console.log( option );
			if ( inStyle != null ) {
				$.each( inStyle, function( key, value ) {
					if( key.toUpperCase( ) === 'WIDTH' ){
						var remainWidth = 0;
						remainWidth = Number( remainWidth ) + Number( $btn.width( ) );
						console.log( option.append );
						if( option.append == true || String( option.append ).toUpperCase( ) === 'TRUE' ){
							remainWidth = remainWidth + Number( 4 );
						}
						if( isNaN( value ) ){
							value = value.replace('px', '');
							value = value.replace('PX', '');
							value = value.replace('Px', '');
							value = value.replace('pX', '');				
						}
						value = Number( value ) - Number( remainWidth );
					}
					
					$element.css( key, value );
				});
			}
		},
	}

	/**
	 * <pre>
	 * 1. 개요
	 * 		Class 지정을 위한 객체 리터럴
	 * 		※테마 설정 존재 PUDD.THEMA
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
	 * 
	 * @Method Name : pushDivClass, pushInputClass, pushToolTipDivClass,
	 *         pushInfoDivClass, pushSvgClass
	 * @param $
	 *            #TODO 모듈명 NAMESPACE를 IMPORT해야 한다.
	 */
	var puddAttachClass = {
		pushDivClass : function($element, option, classJson, outClass) {
			$element.addClass('PUDD-UI-fileField');
			// 통합형 설정
			if (option.space == true || String( option.space ).toUpperCase( ) === 'TRUE') {
				$element.addClass('UI-Union');
			}

			// 푸딩 설정
			$element.addClass(Pudd.getGlobalVariable('PRETEXT'));

			// 테마 설정
			$element.addClass(Pudd.getGlobalVariable('THEMA'));
			if (outClass != null) {
				$element.addClass(outClass);
			}
		},

		pushInputClass : function($element, option, selectClass, inClass) {
			$element.addClass(selectClass);
			$element.addClass('cloneField');
			if (inClass != null) {
				$element.addClass(inClass);
			}
		},

		pushAClass : function($element, option) {
			$element.addClass('btn_file');
		},

		pushInptFileClass : function($element) {
			$element.addClass('hiddenField');
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
	 * 
	 * @Method Name : pushDivAttribute, pushToolTipAttribute,
	 *         pushInputAttribute, pushSvgAttribute, pushStatePathAttribute,
	 *         pushRectAttribute
	 * @param $
	 *            #TODO 모듈명 NAMESPACE를 IMPORT해야 한다.
	 */
	var puddAttachAttribute = {
		pushDivAttribute : function($element, attrJson, id) {
			attrJson = attrJson == undefined ? {} : attrJson;
			attrJson = CommonUtil.castToJSONObject(attrJson);
			$element.attr('id', CommonUtil.createId(id, 'div'));
		},

		pushInputAttribute : function($element, attrJson, id, name, onclick) {
			attrJson = attrJson == undefined ? {} : attrJson;
			attrJson = CommonUtil.castToJSONObject(attrJson);

			$element.attr('type', 'text');

			// id 생성
			if (id != undefined && id !== '') {
				$element.attr('id', id);
			}

			// name 생성
			if (name != null && name !== '') {
				$element.attr('name', name);
			}

			// onclick 생성
			if (onclick != null && onclick !== '') {
				$element.attr('onclick', onclick);
			}

			$element.prop('readonly', true);

			// placeholder 생성
			if (attrJson.placeholder != undefined) {
				/* TODO 다국어처리 가능? 확인 필요 2017.09.06 */
				$element.attr('placeholder', attrJson.placeholder);
			}

		},

		pushAAttibute : function($element, id) {
			$element.attr('id', CommonUtil.createId(id, 'a'));
			$element.attr('onclick', 'file_fc(this);');
		},

		pushInputFileAttribute : function($element, id) {
			$element.attr('id', CommonUtil.createId(id, 'file'));
			$element.attr('type', 'file');
		},
	}

	/* 공통함수 정의 모음 */
	ComponentCommander.attach = function() {
	};

	ComponentCommander.attach.prototype.setDisabled = function(that) {
		$(that.selector).attr('disabled', 'disabled');
		return 'SUCCESS';
	};

	ComponentCommander.attach.prototype.setEnabled = function(that) {
		$(that.selector).removeAttr('disabled');
		return 'SUCCESS';
	};

})(jQuery);

function file_fc(that) {
	$('.hiddenField').off('change');
	$('.hiddenField').on('change', function() {
		$( this ).siblings(".cloneField").attr("value", $( this ).val());
	});

	$(that).siblings(".hiddenField").click();
}
