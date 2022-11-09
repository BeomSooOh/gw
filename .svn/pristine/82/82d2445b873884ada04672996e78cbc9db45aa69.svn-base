(function ($) {
	/* [+] == itemBox ============================================================================================= */
	var itemBoxMethods = {
		itemBoxVar: {
			'class': {
				'div': 'multi_sel',
				'ul': 'multibox',
				'a': 'close_btn'
			}
		},
		init: function (options) {
			var defaults = {
				/* 표현될 문구를 포함하는 JSON 키 */
				/* ex : key: ['userName'] */
				/* ex : key: ['userName', ' ', 'gradeName'] */
				key: [],
				/* 생성시 기본 표현 데이터 */
				data: [],
				/* 생성시 기본 너비, 0 인경우 95% */
				width: 0,
				/* item 추가 콜백 */
				addCallback: function () {},
				/* item remove 콜백 */
				removeCallback: function () {}
			};
			/* options holder */
			var options = $.extend(defaults, options);
			/* set var */
			var id = $(this).prop('id');
			var main = $(this);
			/* set item box */
			setItemBox = function () {
				/* options save */
				if (!$.fn.itemBox.options) {
					$.fn.itemBox.options = new Array();
				}
				$.fn.itemBox.options[id] = options;

				/* set base class */
				main.itemBox('setBaseClass');

				/* set base display */
				if (options.data.length > 0) {
					options.data.forEach(function (item, idx) {
						main.itemBox('add', item, 'Y');
					});
				} else {
					main.append(main.itemBox('getElementUl')[0]);
				}
			};
			/* options init */
			setItemBox();
		},
		setBaseClass: function () {
			/* set var */
			var id = $(this).prop('id');
			var main = $(this);
			var classes = main.itemBox('getItemBoxVar', 'class');

			if (Object.keys(classes).length > 0) {
				if (!main.hasClass(classes.div)) {
					main.addClass(classes.div);
				}
			}

			main.css('width', $.fn.itemBox.options[id].width == 0 ? '95%' : $.fn.itemBox.options[id].width);
		},
		add: function (item, baseYN) {
			/* set var */
			baseYN = baseYN || 'N';
			var id = $(this).prop('id');
			var main = $(this);
			var key = $.fn.itemBox.options[id].key;
			/* item add */
			if (!$.fn.itemBox.options[id].dispData) {
				$.fn.itemBox.options[id].dispData = new Array();
			}
			$.fn.itemBox.options[id].dispData.push(item);
			/* append ul */
			if (main.find('ul').length == 0) {
				main.append(main.itemBox('getElementUl')[0]);
			}
			/* append li */
			var dispVal = '';
			key.forEach(function (dispKey) {
				if (item[dispKey]) {
					dispVal += item[dispKey].toString();
				} else {
					dispVal += dispKey;
				}
			});
			main.find('ul').append(main.itemBox('getElementLi', dispVal)[0]);

			if (baseYN == 'N') {
				main.itemBox('callCallback', 'addCallback', item);
			}
		},
		getElementUl: function () {
			/* set var */
			var id = $(this).prop('id');
			var main = $(this);
			var classes = main.itemBox('getItemBoxVar', 'class');
			/* create element */
			var elem = $(document.createElement('ul'));
			elem.addClass(classes.ul);
			elem.css('width', '90%');
			/* return element */
			return elem;
		},
		getElementLi: function (dispVal) {
			/* set var */
			var id = $(this).prop('id');
			var main = $(this);
			/* create element */
			var elem = $(document.createElement('li'));
			elem.append(dispVal);
			elem.append(main.itemBox('getElementA')[0]);
			/* set data */
			var cpJson = JSON.parse( JSON.stringify($.fn.itemBox.options[id].dispData[$.fn.itemBox.options[id].dispData.length - 1] ) )
			elem.data('value', cpJson);
			/* return element */
			return elem;
		},
		getElementA: function () {
			/* set var */
			var id = $(this).prop('id');
			var main = $(this);
			var classes = main.itemBox('getItemBoxVar', 'class');
			/* create element */
			var elem = $(document.createElement('a'));
			elem.attr('href', 'javascript:;');
			elem.addClass(classes.a);
			elem.append(main.itemBox('getElementImg')[0]);
			/* return element */
			return elem;
		},
		getElementImg: function () {
			/* set var */
			var id = $(this).prop('id');
			var main = $(this);
			/* create element */
			var elem = $(document.createElement('img'));
			elem.attr('src', '/gw/Images/ico/sc_multibox_close.png');
			/* delete event */
			elem.click(function () {
				main.itemBox('remove', $(this));
			});
			return elem;
		},
		remove: function (target) {
			/* set var */
			var id = $(this).prop('id');
			var main = $(this);
			var removeValue = target.parents('li').data('value');
			/* remove item */
			main.itemBox('removeItem', removeValue);
			/* remove element */
			main.itemBox('removeElement', target.parents('li'));
			/* remove callback */
			main.itemBox('callCallback', 'removeCallback', removeValue);
		},
		removeElement: function (element) {
			/* element 삭제 */
			element.remove();
		},
		removeItem: function (removeValue) {
			/* 배열에 저장된 item 을 삭제한다. */
			/* set var */
			var id = $(this).prop('id');
			var main = $(this);
			/* remove item */
			$.fn.itemBox.options[id].dispData.forEach(function (item, idx) {
				if (item == removeValue) {
					$.fn.itemBox.options[id].dispData.splice(idx, 1);
					return false;
				}
			});
		},
		callCallback: function (callbackKey, value) {
			/* 콜백을 호출한다. */
			/* set var */
			var id = $(this).prop('id');
			var main = $(this);
			/* remove callback */
			if (typeof $.fn.itemBox.options[id][callbackKey] == 'function') {
				$.fn.itemBox.options[id][callbackKey](value);
			}
		},
		getAllItem: function () {
			/* set var */
			var id = $(this).prop('id');
			var main = $(this);
			/* return */
			return $.fn.itemBox.options[id].dispData;
		},
		setRemoveAll: function () {
			/* set var */
			var id = $(this).prop('id');
			var main = $(this);
			/* remove item */
			$.fn.itemBox.options[id].dispData = new Array();
			/* remove element */
			main.find('ul').remove();
			/* append item box */
			main.append(main.itemBox('getElementUl')[0]);
		},
		getItemBoxVar: function (key) {
			if (!itemBoxMethods.itemBoxVar[key]) {
				return {};
			} else {
				return itemBoxMethods.itemBoxVar[key];
			}
		}
	};

	$.fn.itemBox = function (method) {
		if (typeof method === 'object' || !method) {
			return itemBoxMethods.init.apply(this, arguments);
		} else if (itemBoxMethods[method]) {
			return itemBoxMethods[method].apply(this, Array.prototype.slice.call(arguments, 1));
		} else {
			$.error('Method ' + method + ' does not exist..');
		}
	};
	/* [-] == itemBox ============================================================================================= */
})(jQuery);
