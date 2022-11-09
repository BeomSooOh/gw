/*!
 * html2canvas 1.0.0-alpha.5 <https://html2canvas.hertzen.com>
 * Copyright (c) 2017 Niklas von Hertzen <https://hertzen.com>
 * Released under MIT License
 */

/* * called 
 * 	html2canvas(targetEle).then( objCanvas => 
	{
	}
	);
 * */

(
	function webpackUniversalModuleDefinition(root/*Window*/, factoryFunc) 
	{
		if(typeof exports === 'object' && typeof module === 'object')
			module.exports = factoryFunc();
		else if(typeof define === 'function' && define.amd)
			define([], factoryFunc);
		else if(typeof exports === 'object')
			exports["html2canvas"] = factoryFunc();
		else
			root/*Window*/["html2canvas"] = factoryFunc();
	}
)
(this, function() 
	{
		var mainFunc = 	function(modules/*51 callback*/) 
					{ // webpackBootstrap
        				var installedModules = {};// The module cache
              	
						function __webpack_require__(moduleId) // The require function
						{
							//g_objCommonUtil.log("__webpack_require__ :: ModuleID ::" + 		moduleId);
							if(installedModules[moduleId])   		// Check if module is in cache
							{
								return installedModules[moduleId].exports;
							}
        		
							var module = installedModules[moduleId] = 
							{// Create a new module (and put it into the cache)
								id: moduleId,
								loaded: false,
								exports: {}
							};
      
							modules[moduleId].call(module.exports, module, module.exports, __webpack_require__);		// Execute the module function
							module.loaded = true;// Flag the module as loaded      
							return module.exports; 	// Return the exports of the module
						}
      
						__webpack_require__.m = modules;// expose the modules object (__webpack_modules__)      
						__webpack_require__.c = installedModules;// expose the module cache

						__webpack_require__.d = function(exports, name, getter) 
						{// define getter function for harmony exports
							if(!__webpack_require__.o(exports, name)) 
							{
								Object.defineProperty(exports, name, 
								{
									configurable: false,
									enumerable: true,
									get: getter
								});
							}
						};

						__webpack_require__.n = function(module) 
						{  	// getDefaultExport function for compatibility with non-harmony modules
							var getter = module && module.__esModule ?
								function getDefault() { return module['default']; } :
								function getModuleExports() { return module; };
							__webpack_require__.d(getter, 'a', getter);
							return getter;
						};

						// Object.prototype.hasOwnProperty.call
						__webpack_require__.o = function(object, property) 
							{ 
								return Object.prototype.hasOwnProperty.call(object, property); 
							};

						__webpack_require__.p = "";// __webpack_public_path__

						__webpack_require__.s = 24;//startModuleID?
						return __webpack_require__(__webpack_require__.s);// Load entry module and return exports
				 };
		return mainFunc///return
/************************************************************************/
			([
/* 0 :: _Color , _Color2 */
/***/(	
		function(module, exports, __webpack_require__) 
		{
			//g_objCommonUtil.log("modules[0 _Color].call");
			"use strict";


			// http://dev.w3.org/csswg/css-color/

			Object.defineProperty(exports, "__esModule", {	value: true	});

			//misty 2018.01.02 //misty 2018.01.02 var _slicedToArray = function () { function sliceIterator(arr, i) { var _arr = []; var _n = true; var _d = false; var _e = undefined; try { for (var _i = arr[Symbol.iterator](), _s; !(_n = (_s = _i.next()).done); _n = true) { _arr.push(_s.value); if (i && _arr.length === i) break; } } catch (err) { _d = true; _e = err; } finally { try { if (!_n && _i["return"]) _i["return"](); } finally { if (_d) throw _e; } } return _arr; } return function (arr, i) { if (Array.isArray(arr)) { return arr; } else if (Symbol.iterator in Object(arr)) { return sliceIterator(arr, i); } else { throw new TypeError("Invalid attempt to destructure non-iterable instance"); } }; }();

			//misty 2018.01.02 //misty 2018.01.02 var _createClass = function () { function defineProperties(target, props) { for (var i = 0; i < props.length; i++) { var descriptor = props[i]; descriptor.enumerable = descriptor.enumerable || false; descriptor.configurable = true; if ("value" in descriptor) descriptor.writable = true; Object.defineProperty(target, descriptor.key, descriptor); } } return function (Constructor, protoProps, staticProps) { if (protoProps) defineProperties(Constructor.prototype, protoProps); if (staticProps) defineProperties(Constructor, staticProps); return Constructor; }; }();

			//misty 2018.01.02 //misty 2018.01.02 function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError("Cannot call a class as a function"); } }

			var HEX3 = /^#([a-f0-9]{3})$/i;
			var hex3 = function hex3(value) 
			{
				var match = value.match(HEX3);
				if (match) 
				{
					return [parseInt(match[1][0] + match[1][0], 16), parseInt(match[1][1] + match[1][1], 16), parseInt(match[1][2] + match[1][2], 16), null];
				}
				return false;
			};

			var HEX6 = /^#([a-f0-9]{6})$/i;
			var hex6 = function hex6(value) 
			{
				var match = value.match(HEX6);
				if (match) 
				{
					return [parseInt(match[1].substring(0, 2), 16), parseInt(match[1].substring(2, 4), 16), parseInt(match[1].substring(4, 6), 16), null];
				}
				return false;
			};

			var RGB = /^rgb\(\s*(\d{1,3})\s*,\s*(\d{1,3})\s*,\s*(\d{1,3})\s*\)$/;
			var rgb = function rgb(value) 
			{
				var match = value.match(RGB);
				if (match) 
				{
					return [Number(match[1]), Number(match[2]), Number(match[3]), null];
				}
				return false;
			};

			var RGBA = /^rgba\(\s*(\d{1,3})\s*,\s*(\d{1,3})\s*,\s*(\d{1,3})\s*,\s*(\d?\.?\d+)\s*\)$/;
			var rgba = function rgba(value) 
			{
				var match = value.match(RGBA);
				if (match && match.length > 4) 
				{
					return [Number(match[1]), Number(match[2]), Number(match[3]), Number(match[4])];
				}
				return false;
			};

			var fromArray = function fromArray(array) 
			{
				return [Math.min(array[0], 255), Math.min(array[1], 255), Math.min(array[2], 255), array.length > 3 ? array[3] : null];
			};

			var namedColor = function namedColor(name) 
			{
				var color = NAMED_COLORS[name.toLowerCase()];
				return color ? color : false;
			};

			/* COLOR CLASS */
			var Color = function () 
			{
				function Color(value) 
				{
					_classCallCheck(this, Color);

					var _ref = Array.isArray(value) ? fromArray(value) : hex3(value) || rgb(value) || rgba(value) || namedColor(value) || hex6(value) || [0, 0, 0, null],
						_ref2 = _slicedToArray(_ref, 4),
						r = _ref2[0],
						g = _ref2[1],
						b = _ref2[2],
						a = _ref2[3];

					this.r = r;
					this.g = g;
					this.b = b;
					this.a = a;
				}

				_createClass(Color, [
					{
						key: 'isTransparent',
						value: function isTransparent() 
						{
							return this.a === 0;
						}
					}, 
					{
						key: 'toString',
						value: function toString() 
						{
							return this.a !== null && this.a !== 1 ? 'rgba(' + this.r + ',' + this.g + ',' + this.b + ',' + this.a + ')' : 'rgb(' + this.r + ',' + this.g + ',' + this.b + ')';
						}
					}]);


				return Color;
			}();

			exports.default = Color;

			var NAMED_COLORS = 
			{
				transparent: [0, 0, 0, 0],
				aliceblue: [240, 248, 255, null],
				antiquewhite: [250, 235, 215, null],
				aqua: [0, 255, 255, null],
				aquamarine: [127, 255, 212, null],
				azure: [240, 255, 255, null],
				beige: [245, 245, 220, null],
				bisque: [255, 228, 196, null],
				black: [0, 0, 0, null],
				blanchedalmond: [255, 235, 205, null],
				blue: [0, 0, 255, null],
				blueviolet: [138, 43, 226, null],
				brown: [165, 42, 42, null],
				burlywood: [222, 184, 135, null],
				cadetblue: [95, 158, 160, null],
				chartreuse: [127, 255, 0, null],
				chocolate: [210, 105, 30, null],
				coral: [255, 127, 80, null],
				cornflowerblue: [100, 149, 237, null],
				cornsilk: [255, 248, 220, null],
				crimson: [220, 20, 60, null],
				cyan: [0, 255, 255, null],
				darkblue: [0, 0, 139, null],
				darkcyan: [0, 139, 139, null],
				darkgoldenrod: [184, 134, 11, null],
				darkgray: [169, 169, 169, null],
				darkgreen: [0, 100, 0, null],
				darkgrey: [169, 169, 169, null],
				darkkhaki: [189, 183, 107, null],
				darkmagenta: [139, 0, 139, null],
				darkolivegreen: [85, 107, 47, null],
				darkorange: [255, 140, 0, null],
				darkorchid: [153, 50, 204, null],
				darkred: [139, 0, 0, null],
				darksalmon: [233, 150, 122, null],
				darkseagreen: [143, 188, 143, null],
				darkslateblue: [72, 61, 139, null],
				darkslategray: [47, 79, 79, null],
				darkslategrey: [47, 79, 79, null],
				darkturquoise: [0, 206, 209, null],
				darkviolet: [148, 0, 211, null],
				deeppink: [255, 20, 147, null],
				deepskyblue: [0, 191, 255, null],
				dimgray: [105, 105, 105, null],
				dimgrey: [105, 105, 105, null],
				dodgerblue: [30, 144, 255, null],
				firebrick: [178, 34, 34, null],
				floralwhite: [255, 250, 240, null],
				forestgreen: [34, 139, 34, null],
				fuchsia: [255, 0, 255, null],
				gainsboro: [220, 220, 220, null],
				ghostwhite: [248, 248, 255, null],
				gold: [255, 215, 0, null],
				goldenrod: [218, 165, 32, null],
				gray: [128, 128, 128, null],
				green: [0, 128, 0, null],
				greenyellow: [173, 255, 47, null],
				grey: [128, 128, 128, null],
				honeydew: [240, 255, 240, null],
				hotpink: [255, 105, 180, null],
				indianred: [205, 92, 92, null],
				indigo: [75, 0, 130, null],
				ivory: [255, 255, 240, null],
				khaki: [240, 230, 140, null],
				lavender: [230, 230, 250, null],
				lavenderblush: [255, 240, 245, null],
				lawngreen: [124, 252, 0, null],
				lemonchiffon: [255, 250, 205, null],
				lightblue: [173, 216, 230, null],
				lightcoral: [240, 128, 128, null],
				lightcyan: [224, 255, 255, null],
				lightgoldenrodyellow: [250, 250, 210, null],
				lightgray: [211, 211, 211, null],
				lightgreen: [144, 238, 144, null],
				lightgrey: [211, 211, 211, null],
				lightpink: [255, 182, 193, null],
				lightsalmon: [255, 160, 122, null],
				lightseagreen: [32, 178, 170, null],
				lightskyblue: [135, 206, 250, null],
				lightslategray: [119, 136, 153, null],
				lightslategrey: [119, 136, 153, null],
				lightsteelblue: [176, 196, 222, null],
				lightyellow: [255, 255, 224, null],
				lime: [0, 255, 0, null],
				limegreen: [50, 205, 50, null],
				linen: [250, 240, 230, null],
				magenta: [255, 0, 255, null],
				maroon: [128, 0, 0, null],
				mediumaquamarine: [102, 205, 170, null],
				mediumblue: [0, 0, 205, null],
				mediumorchid: [186, 85, 211, null],
				mediumpurple: [147, 112, 219, null],
				mediumseagreen: [60, 179, 113, null],
				mediumslateblue: [123, 104, 238, null],
				mediumspringgreen: [0, 250, 154, null],
				mediumturquoise: [72, 209, 204, null],
				mediumvioletred: [199, 21, 133, null],
				midnightblue: [25, 25, 112, null],
				mintcream: [245, 255, 250, null],
				mistyrose: [255, 228, 225, null],
				moccasin: [255, 228, 181, null],
				navajowhite: [255, 222, 173, null],
				navy: [0, 0, 128, null],
				oldlace: [253, 245, 230, null],
				olive: [128, 128, 0, null],
				olivedrab: [107, 142, 35, null],
				orange: [255, 165, 0, null],
				orangered: [255, 69, 0, null],
				orchid: [218, 112, 214, null],
				palegoldenrod: [238, 232, 170, null],
				palegreen: [152, 251, 152, null],
				paleturquoise: [175, 238, 238, null],
				palevioletred: [219, 112, 147, null],
				papayawhip: [255, 239, 213, null],
				peachpuff: [255, 218, 185, null],
				peru: [205, 133, 63, null],
				pink: [255, 192, 203, null],
				plum: [221, 160, 221, null],
				powderblue: [176, 224, 230, null],
				purple: [128, 0, 128, null],
				rebeccapurple: [102, 51, 153, null],
				red: [255, 0, 0, null],
				rosybrown: [188, 143, 143, null],
				royalblue: [65, 105, 225, null],
				saddlebrown: [139, 69, 19, null],
				salmon: [250, 128, 114, null],
				sandybrown: [244, 164, 96, null],
				seagreen: [46, 139, 87, null],
				seashell: [255, 245, 238, null],
				sienna: [160, 82, 45, null],
				silver: [192, 192, 192, null],
				skyblue: [135, 206, 235, null],
				slateblue: [106, 90, 205, null],
				slategray: [112, 128, 144, null],
				slategrey: [112, 128, 144, null],
				snow: [255, 250, 250, null],
				springgreen: [0, 255, 127, null],
				steelblue: [70, 130, 180, null],
				tan: [210, 180, 140, null],
				teal: [0, 128, 128, null],
				thistle: [216, 191, 216, null],
				tomato: [255, 99, 71, null],
				turquoise: [64, 224, 208, null],
				violet: [238, 130, 238, null],
				wheat: [245, 222, 179, null],
				white: [255, 255, 255, null],
				whitesmoke: [245, 245, 245, null],
				yellow: [255, 255, 0, null],
				yellowgreen: [154, 205, 50, null]
			};

			var TRANSPARENT = exports.TRANSPARENT = new Color([0, 0, 0, 0]);

/***/ }
	),
/* 1 :: _Bounds */
/***/ (
		function(module, exports, __webpack_require__) 
		{
			//g_objCommonUtil.log("modules[1 _Bounds].call");
			"use strict";


			Object.defineProperty(exports, "__esModule", { value: true});
			exports.parseBoundCurves = 
			exports.calculatePaddingBoxPath = 
			exports.calculateBorderBoxPath = 
			exports.parsePathForBorder = 
			exports.parseDocumentSize = 
			exports.calculateContentBox = 
			exports.calculatePaddingBox = 
			exports.parseBounds = 
			exports.Bounds = undefined;

			//misty 2018.01.02 var _createClass = function () { function defineProperties(target, props) { for (var i = 0; i < props.length; i++) { var descriptor = props[i]; descriptor.enumerable = descriptor.enumerable || false; descriptor.configurable = true; if ("value" in descriptor) descriptor.writable = true; Object.defineProperty(target, descriptor.key, descriptor); } } return function (Constructor, protoProps, staticProps) { if (protoProps) defineProperties(Constructor.prototype, protoProps); if (staticProps) defineProperties(Constructor, staticProps); return Constructor; }; }();

			var _Vector = __webpack_require__(7);

			var _Vector2 = _interopRequireDefault(_Vector);

			var _BezierCurve = __webpack_require__(29);

			var _BezierCurve2 = _interopRequireDefault(_BezierCurve);

			//misty 2018.01.02 function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { default: obj }; }

//misty 2018.01.02 function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError("Cannot call a class as a function"); } }

			var TOP = 0;
			var RIGHT = 1;
			var BOTTOM = 2;
			var LEFT = 3;

			var H = 0;
			var V = 1;

			/* BOUNDS CLASS*/
			var Bounds = exports.Bounds = function () 
			{
				function Bounds(x, y, w, h) 
				{
					_classCallCheck(this, Bounds);

					this.left = x;
					this.top = y;
					this.width = w;
					this.height = h;
				}

				_createClass(Bounds, null, [
											{
												key: 'fromClientRect',
												value: function fromClientRect(clientRect, scrollX, scrollY) 
												{
													//console.log("[BOUNDS CLASS] scrollX = " + scrollX + " scrollY = " + scrollY );
											//		console.log("[BOUNDS CLASS] l = " + clientRect.left + " t = " + clientRect.top + " w = " + clientRect.width + " h = " + clientRect.height);
													var rc = new Bounds(clientRect.left + scrollX, clientRect.top + scrollY, clientRect.width, clientRect.height);
													//console.log("[fromClntRect=REAL_BOUNDS_RECT] l = " + rc.left + " t = " + rc.top + " r = " +  (rc.left + rc.width) + " b = " 
													//		+ (rc.top+rc.height) + " scrollX = "  + scrollX + " scrollY = " + scrollY + "\n");											
													return rc;
												}
											}]);

				return Bounds;
			}();

			var parseBounds = exports.parseBounds = function parseBounds(node, scrollX, scrollY) 
			{	
				//console.log("[parseBounds]" +  " TagName = " + node.nodeName + " id = "+ node.id + " className = " + node.className);			
				var rc = Bounds.fromClientRect(node.getBoundingClientRect(), scrollX, scrollY);								
				return rc;
			};

			var calculatePaddingBox = exports.calculatePaddingBox = function calculatePaddingBox(bounds, borders) 
			{
				var rcPaddingBox = new Bounds(bounds.left + borders[LEFT].borderWidth, bounds.top + borders[TOP].borderWidth, bounds.width - (borders[RIGHT].borderWidth + borders[LEFT].borderWidth), bounds.height - (borders[TOP].borderWidth + borders[BOTTOM].borderWidth));
				//	console.log("[calculatePaddingBox rcPaddingBox  L =" + rcPaddingBox.left + " T = "+ rcPaddingBox.top  +  " W =" + rcPaddingBox.width + " H = "+ rcPaddingBox.height);
													  
				return rcPaddingBox;
			};

			var calculateContentBox = exports.calculateContentBox = function calculateContentBox(bounds, padding, borders) 
			{
				// TODO support percentage paddings
				var paddingTop = padding[TOP].value;
				var paddingRight = padding[RIGHT].value;
				var paddingBottom = padding[BOTTOM].value;
				var paddingLeft = padding[LEFT].value;

				return new Bounds(bounds.left + paddingLeft + borders[LEFT].borderWidth, bounds.top + paddingTop + borders[TOP].borderWidth, bounds.width - (borders[RIGHT].borderWidth + borders[LEFT].borderWidth + paddingLeft + paddingRight), bounds.height - (borders[TOP].borderWidth + borders[BOTTOM].borderWidth + paddingTop + paddingBottom));
			};

			var parseDocumentSize = exports.parseDocumentSize = function parseDocumentSize(document) 
			{
				var body = document.body;
				var documentElement = document.documentElement;

				if (!body || !documentElement) 
				{
					throw new Error( true ? 'Unable to get document size' : '');
				}
				var width = Math.max(Math.max(body.scrollWidth, documentElement.scrollWidth), Math.max(body.offsetWidth, documentElement.offsetWidth), Math.max(body.clientWidth, documentElement.clientWidth));
				var height = Math.max(Math.max(body.scrollHeight, documentElement.scrollHeight), Math.max(body.offsetHeight, documentElement.offsetHeight), Math.max(body.clientHeight, documentElement.clientHeight));
				var rcDoc = new Bounds(0, 0, width, height);			
				//console.log("[parseDocumentSize] DocSize l=0, t=0 w = " + w + " h = " + h);
			//	g_objCommonUtil.log("DocBody.Content = " + body.textContent.trim());;

				return rcDoc ;
			};

			var parsePathForBorder = exports.parsePathForBorder = function parsePathForBorder(curves, borderSide) 
			{
				switch (borderSide) 
				{
					case TOP:
						return createPathFromCurves(curves.topLeftOuter, curves.topLeftInner, curves.topRightOuter, curves.topRightInner);
					case RIGHT:
						return createPathFromCurves(curves.topRightOuter, curves.topRightInner, curves.bottomRightOuter, curves.bottomRightInner);
					case BOTTOM:
						return createPathFromCurves(curves.bottomRightOuter, curves.bottomRightInner, curves.bottomLeftOuter, curves.bottomLeftInner);
					case LEFT:
					default:
						return createPathFromCurves(curves.bottomLeftOuter, curves.bottomLeftInner, curves.topLeftOuter, curves.topLeftInner);
				}
			};

			var createPathFromCurves = function createPathFromCurves(outer1, inner1, outer2, inner2) 
			{//FUNC_DEFINE
				var path = [];
				if (outer1 instanceof _BezierCurve2.default) 
				{
					path.push(outer1.subdivide(0.5, false));
				} 
				else 
				{
					path.push(outer1);
				}

				if (outer2 instanceof _BezierCurve2.default) 
				{
					path.push(outer2.subdivide(0.5, true));
				} 
				else 
				{
					path.push(outer2);
				}

				if (inner2 instanceof _BezierCurve2.default) 
				{
					path.push(inner2.subdivide(0.5, true).reverse());
				} 
				else 
				{
					path.push(inner2);
				}

				if (inner1 instanceof _BezierCurve2.default) 
				{
					path.push(inner1.subdivide(0.5, false).reverse());
				} 
				else 
				{
					path.push(inner1);
				}

				return path;
			};

			var calculateBorderBoxPath = exports.calculateBorderBoxPath = function calculateBorderBoxPath(curves) 
			{
				var rcOuterBox = [curves.topLeftOuter, curves.topRightOuter, curves.bottomRightOuter, curves.bottomLeftOuter];;
//				console.log("[caculateBorderBoxPath rcOuter  TL =(" + rcOuterBox[0].x + ","+ rcOuterBox[0].y  + 
//														  ") TR =(" + rcOuterBox[1].x + ","+ rcOuterBox[1].y  + 
//														  ") BR =(" + rcOuterBox[2].x + ","+ rcOuterBox[2].y  + 
//														  ") BL =(" + rcOuterBox[3].x + "," + rcOuterBox[3].y +")");
				return rcOuterBox;
			};

			var calculatePaddingBoxPath = exports.calculatePaddingBoxPath = function calculatePaddingBoxPath(curves) 
			{
				var rcInnerBox = [curves.topLeftInner, curves.topRightInner, curves.bottomRightInner, curves.bottomLeftInner];
//				console.log("[calculatePaddingBoxPath rcInner  TL =(" + rcInnerBox[0].x + ","+ rcInnerBox[0].y  + 
//															 ") TR =(" + rcInnerBox[1].x + ","+ rcInnerBox[1].y  + 
//															  ") BR =(" + rcInnerBox[2].x + ","+ rcInnerBox[2].y  + 
//															  ") BL =(" + rcInnerBox[3].x + "," + rcInnerBox[3].y +")");
				return rcInnerBox;
			};

			var parseBoundCurves = exports.parseBoundCurves = function parseBoundCurves(bounds, borders, borderRadius) 
			{
				var HALF_WIDTH = bounds.width / 2;
				var HALF_HEIGHT = bounds.height / 2;

				var tlh = borderRadius[CORNER.TOP_LEFT][H].getAbsoluteValue(bounds.width) < HALF_WIDTH ? 
						borderRadius[CORNER.TOP_LEFT][H].getAbsoluteValue(bounds.width) : HALF_WIDTH;
				var tlv = borderRadius[CORNER.TOP_LEFT][V].getAbsoluteValue(bounds.height) < HALF_HEIGHT ? 
						borderRadius[CORNER.TOP_LEFT][V].getAbsoluteValue(bounds.height) : HALF_HEIGHT;
				var trh = borderRadius[CORNER.TOP_RIGHT][H].getAbsoluteValue(bounds.width) < HALF_WIDTH ? 
						borderRadius[CORNER.TOP_RIGHT][H].getAbsoluteValue(bounds.width) : HALF_WIDTH;
				var trv = borderRadius[CORNER.TOP_RIGHT][V].getAbsoluteValue(bounds.height) < HALF_HEIGHT ? 
						borderRadius[CORNER.TOP_RIGHT][V].getAbsoluteValue(bounds.height) : HALF_HEIGHT;

				var brh = borderRadius[CORNER.BOTTOM_RIGHT][H].getAbsoluteValue(bounds.width) < HALF_WIDTH ? 
						borderRadius[CORNER.BOTTOM_RIGHT][H].getAbsoluteValue(bounds.width) : HALF_WIDTH;
				var brv = borderRadius[CORNER.BOTTOM_RIGHT][V].getAbsoluteValue(bounds.height) < HALF_HEIGHT ? 
						borderRadius[CORNER.BOTTOM_RIGHT][V].getAbsoluteValue(bounds.height) : HALF_HEIGHT;
				var blh = borderRadius[CORNER.BOTTOM_LEFT][H].getAbsoluteValue(bounds.width) < HALF_WIDTH ? 
						borderRadius[CORNER.BOTTOM_LEFT][H].getAbsoluteValue(bounds.width) : HALF_WIDTH;
				var blv = borderRadius[CORNER.BOTTOM_LEFT][V].getAbsoluteValue(bounds.height) < HALF_HEIGHT ? 
						borderRadius[CORNER.BOTTOM_LEFT][V].getAbsoluteValue(bounds.height) : HALF_HEIGHT;

				var topWidth = bounds.width - trh;
				var rightHeight = bounds.height - brv;
				var bottomWidth = bounds.width - brh;
				var leftHeight = bounds.height - blv;

				return {
					topLeftOuter: (tlh > 0 || tlv > 0 )? 
									getCurvePoints(bounds.left, bounds.top, tlh, tlv, CORNER.TOP_LEFT) : 
									new _Vector2.default(bounds.left, bounds.top),

					topLeftInner: (tlh > 0 || tlv > 0 )? 
									getCurvePoints(bounds.left + borders[LEFT].borderWidth, bounds.top + borders[TOP].borderWidth, Math.max(0, tlh - borders[LEFT].borderWidth), Math.max(0, tlv - borders[TOP].borderWidth), CORNER.TOP_LEFT) : 
									new _Vector2.default(bounds.left + borders[LEFT].borderWidth, bounds.top + borders[TOP].borderWidth),
					topRightOuter: (trh > 0 || trv > 0 )? 
									getCurvePoints(bounds.left + topWidth, bounds.top, trh, trv, CORNER.TOP_RIGHT) : 
									new _Vector2.default(bounds.left + bounds.width, bounds.top),
					topRightInner: (trh > 0 || trv > 0 )? 
									getCurvePoints(bounds.left + Math.min(topWidth, bounds.width + borders[LEFT].borderWidth), bounds.top + borders[TOP].borderWidth, topWidth > bounds.width + borders[LEFT].borderWidth ? 0 : trh - borders[LEFT].borderWidth, trv - borders[TOP].borderWidth, CORNER.TOP_RIGHT) : 
									new _Vector2.default(bounds.left + bounds.width - borders[RIGHT].borderWidth, bounds.top + borders[TOP].borderWidth),
					bottomRightOuter: (brh > 0 || brv > 0 ) ? 
									getCurvePoints(bounds.left + bottomWidth, bounds.top + rightHeight, brh, brv, CORNER.BOTTOM_RIGHT) :
									new _Vector2.default(bounds.left + bounds.width, bounds.top + bounds.height),
					bottomRightInner: (brh > 0 || brv > 0) ? 
									getCurvePoints(bounds.left + Math.min(bottomWidth, bounds.width - borders[LEFT].borderWidth), bounds.top + Math.min(rightHeight, bounds.height + borders[TOP].borderWidth), Math.max(0, brh - borders[RIGHT].borderWidth), brv - borders[BOTTOM].borderWidth, CORNER.BOTTOM_RIGHT) :
									new _Vector2.default(bounds.left + bounds.width - borders[RIGHT].borderWidth, bounds.top + bounds.height - borders[BOTTOM].borderWidth),
					bottomLeftOuter: (blh > 0 || blv > 0 )? 
									getCurvePoints(bounds.left, bounds.top + leftHeight, blh, blv, CORNER.BOTTOM_LEFT) :
									new _Vector2.default(bounds.left, bounds.top + bounds.height),
					bottomLeftInner: (blh > 0 || blv > 0 )? 
									getCurvePoints(bounds.left + borders[LEFT].borderWidth, bounds.top + leftHeight, Math.max(0, blh - borders[LEFT].borderWidth), blv - borders[BOTTOM].borderWidth, CORNER.BOTTOM_LEFT) : 
									new _Vector2.default(bounds.left + borders[LEFT].borderWidth, bounds.top + bounds.height - borders[BOTTOM].borderWidth)
				};
			};

			var CORNER = {
								TOP_LEFT: 0,
								TOP_RIGHT: 1,
								BOTTOM_RIGHT: 2,
								BOTTOM_LEFT: 3
							};

			var getCurvePoints = function getCurvePoints(x, y, r1, r2, position) 
			{
				var kappa = 4 * ((Math.sqrt(2) - 1) / 3);
				var ox = r1 * kappa; // control point offset horizontal
				var oy = r2 * kappa; // control point offset vertical
				var xm = x + r1; // x-middle
				var ym = y + r2; // y-middle

				switch (position) 
				{
					case CORNER.TOP_LEFT:
						return new _BezierCurve2.default(new _Vector2.default(x, ym), new _Vector2.default(x, ym - oy), new _Vector2.default(xm - ox, y), new _Vector2.default(xm, y));
					case CORNER.TOP_RIGHT:
						return new _BezierCurve2.default(new _Vector2.default(x, y), new _Vector2.default(x + ox, y), new _Vector2.default(xm, ym - oy), new _Vector2.default(xm, ym));
					case CORNER.BOTTOM_RIGHT:
						return new _BezierCurve2.default(new _Vector2.default(xm, y), new _Vector2.default(xm, y + oy), new _Vector2.default(x + ox, ym), new _Vector2.default(x, ym));
					case CORNER.BOTTOM_LEFT:
					default:
						return new _BezierCurve2.default(new _Vector2.default(xm, ym), new _Vector2.default(xm - ox, ym), new _Vector2.default(x, y + oy), new _Vector2.default(x, y));
				}
			};

	/***/ }
	),
/* 2 :: _Length , _Length2 */
/***/ (
		function(module, exports, __webpack_require__) 
		{
			//g_objCommonUtil.log("modules[2 _Length].call");
			"use strict";


			Object.defineProperty(exports, "__esModule", {value: true});
			exports.calculateLengthFromValueWithUnit = exports.LENGTH_TYPE = undefined;

			//misty 2018.01.02 var _createClass = function () { function defineProperties(target, props) { for (var i = 0; i < props.length; i++) { var descriptor = props[i]; descriptor.enumerable = descriptor.enumerable || false; descriptor.configurable = true; if ("value" in descriptor) descriptor.writable = true; Object.defineProperty(target, descriptor.key, descriptor); } } return function (Constructor, protoProps, staticProps) { if (protoProps) defineProperties(Constructor.prototype, protoProps); if (staticProps) defineProperties(Constructor, staticProps); return Constructor; }; }();

			var _NodeContainer = __webpack_require__(4);

			var _NodeContainer2 = _interopRequireDefault(_NodeContainer);

			//misty 2018.01.02 function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { default: obj }; }

			//misty 2018.01.02 function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError("Cannot call a class as a function"); } }

			var LENGTH_WITH_UNIT = /([\d.]+)(px|r?em|%)/i;

			var LENGTH_TYPE = exports.LENGTH_TYPE = 
					{
						PX: 0,
						PERCENTAGE: 1
					};

			var Length = function () 
			{/*LENGTH_CLASS*/
				function Length(value) 
				{
					_classCallCheck(this, Length);

					this.type = value.substr(value.length - 1) === '%' ? LENGTH_TYPE.PERCENTAGE : LENGTH_TYPE.PX;
					var parsedValue = parseFloat(value);
					if (true && isNaN(parsedValue)) {
						dalert('Invalid value given for Length: "' + value + '"');
					}
					this.value = isNaN(parsedValue) ? 0 : parsedValue;
				}

				_createClass(Length, [{
					key: 'isPercentage',
					value: function isPercentage() {
						return this.type === LENGTH_TYPE.PERCENTAGE;
					}
				}, {
					key: 'getAbsoluteValue',
					value: function getAbsoluteValue(parentLength) {
						return this.isPercentage() ? parentLength * (this.value / 100) : this.value;
					}
				}], [{
					key: 'create',
					value: function create(v) {
						return new Length(v);
					}
				}]);

				return Length;
			}();

			exports.default = Length;//LENGTH Class Assign

			var getRootFontSize = function getRootFontSize(container) 
			{
				var parent = container.parent;
				return parent ? getRootFontSize(parent) : parseFloat(container.style.font.fontSize);
			};

			var calculateLengthFromValueWithUnit = exports.calculateLengthFromValueWithUnit = function calculateLengthFromValueWithUnit(container, value, unit) 
			{
				switch (unit) 
				{
					case 'px':
					case '%':
						return new Length(value + unit);
					case 'em':
					case 'rem':
						var length = new Length(value);
						length.value *= unit === 'em' ? parseFloat(container.style.font.fontSize) : getRootFontSize(container);
						return length;
					default:
						// TODO: handle correctly if unknown unit is used
						return new Length('0');
				}
			};
	/***/ }
	),
/* 3 :: _Util */
/***/ (
		function(module, exports, __webpack_require__) 
		{
			//g_objCommonUtil.log("modules[3 _Util].call");
			"use strict";


			Object.defineProperty(exports, "__esModule", {value: true});
			var contains = exports.contains = function contains(bit, value) 
			{
				return (bit & value) !== 0;
			};

			var distance = exports.distance = function distance(a, b)
			{
				return Math.sqrt(a * a + b * b);
			};

			var copyCSSStyles = exports.copyCSSStyles = function copyCSSStyles(styleOrgEle, targetCloneEle)
			{
				 if(!fnObjectCheckNull(styleOrgEle))
					 targetCloneEle.style.cssText = styleOrgEle.cssText;//misty - 2018.05.30
				return;
				// Edge does not provide value for cssText
				// for (var i = styleOrgEle.length - 1; i >= 0; i--) 
				// {
				// 	var property = styleOrgEle.item(i);
				// 	// Safari shows pseudoelements if content is set
				// 	if (property !== 'content') 
				// 	{
				// 		targetCloneEle.style.setProperty(property, styleOrgEle.getPropertyValue(property));
				// 	}
				// }
				return targetCloneEle;
			};

			var SMALL_IMAGE = exports.SMALL_IMAGE = 'data:image/gif;base64,R0lGODlhAQABAIAAAAAAAP///yH5BAEAAAAALAAAAAABAAEAAAIBRAA7';

	/***/ }
	),
/* 4 :: _NodeContainer , _NodeContainer2 */
/***/ (
		function(module, exports, __webpack_require__) 
		{
			//g_objCommonUtil.log("modules[4 _NodeContainer].call");
			"use strict";


			Object.defineProperty(exports, "__esModule", {	value: true	});

	//misty 2018.01.02 var _createClass = function () { function defineProperties(target, props) { for (var i = 0; i < props.length; i++) { var descriptor = props[i]; descriptor.enumerable = descriptor.enumerable || false; descriptor.configurable = true; if ("value" in descriptor) descriptor.writable = true; Object.defineProperty(target, descriptor.key, descriptor); } } return function (Constructor, protoProps, staticProps) { if (protoProps) defineProperties(Constructor.prototype, protoProps); if (staticProps) defineProperties(Constructor, staticProps); return Constructor; }; }();

			var _Color = __webpack_require__(0);

			var _Color2 = _interopRequireDefault(_Color);

			var _Util = __webpack_require__(3);

			var _background = __webpack_require__(5);

			var _border = __webpack_require__(11);

			var _borderRadius = __webpack_require__(30);

			var _display = __webpack_require__(31);

			var _float = __webpack_require__(32);

			var _font = __webpack_require__(33);

			var _letterSpacing = __webpack_require__(34);

			var _listStyle = __webpack_require__(15);

			var _margin = __webpack_require__(35);

			var _overflow = __webpack_require__(36);

			var _padding = __webpack_require__(14);

			var _position = __webpack_require__(16);

			var _textDecoration = __webpack_require__(10);

			var _textShadow = __webpack_require__(37);

			var _textTransform = __webpack_require__(17);

			var _transform = __webpack_require__(38);

			var _visibility = __webpack_require__(39);

			var _zIndex = __webpack_require__(40);

			var _Bounds = __webpack_require__(1);

			var _Input = __webpack_require__(18);

			var _ListItem = __webpack_require__(21);

			//misty 2018.01.02 function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { default: obj }; }

	//misty 2018.01.02 function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError("Cannot call a class as a function"); } }

		var INPUT_TAGS = ['INPUT', 'TEXTAREA', 'SELECT'];

		var NodeContainer = function () 
		{/*NODECONTAINER_CLASS*/
			function NodeContainer(node, parent, resourceLoader, index) 
			{
				var _this = this;

				_classCallCheck(this, NodeContainer);
				
				this.parent = parent;
				this.tagName = node.tagName;
				//g_objCommonUtil.log("==========================================================================================START!!!!");
				this.index = index;
				this.childNodes = [];
				this.listItems = [];
				if (typeof node.start === 'number') 
				{
					this.listStart = node.start;
				}
				var defaultView = node.ownerDocument.defaultView;
				var scrollX = defaultView.pageXOffset;
				var scrollY = defaultView.pageYOffset;
				var style = defaultView.getComputedStyle(node, null);
				var display = (0, _display.parseDisplay)(style.display);// DISPLAY.BLOCK = 2;

				var IS_INPUT = node.type === 'radio' || node.type === 'checkbox';
				
				var bTable = (node.tagName.toLowerCase() == DZE_TAG_TABLE) ? true : false;//misty - 2018.06.29
				var nPgNum = 0;
				if(bTable)
				{
					nPgNum = node.offsetParent.getAttribute("pagenum");
				//	console.log("\n [NodeContainer] nPgNum = "+ nPgNum + " TagName = " + this.tagName + " ID = " + node.id+ "  className = " + node.className);//misty - 2018.04.03
				}
				var position = (0, _position.parsePosition)(style.position);//POSITON.relative = 1;				
				var bgInfo = (0, _background.parseBackground)(style, resourceLoader,bTable);
				
//misty - span.style.backgroundcolor :: YELLOW !!!!! child. IMG  this problem is 
				this.style = {
					background: IS_INPUT/*false*/ ? _Input.INPUT_BACKGROUND : bgInfo,
					border: IS_INPUT ? _Input.INPUT_BORDERS : (0, _border.parseBorder)(style),
					borderRadius: (node instanceof defaultView.HTMLInputElement || node instanceof HTMLInputElement) && IS_INPUT ? (0, _Input.getInputBorderRadius)(node) : (0, _borderRadius.parseBorderRadius)(style),
					color: IS_INPUT ? _Input.INPUT_COLOR : new _Color2.default(style.color),
					display: display,
					float: (0, _float.parseCSSFloat)(style.float),
					font: (0, _font.parseFont)(style),
					letterSpacing: (0, _letterSpacing.parseLetterSpacing)(style.letterSpacing),
					listStyle: display === _display.DISPLAY.LIST_ITEM ? (0, _listStyle.parseListStyle)(style) : null,
					margin: (0, _margin.parseMargin)(style),
					opacity: parseFloat(style.opacity),
					overflow: INPUT_TAGS.indexOf(node.tagName) === -1 ? (0, _overflow.parseOverflow)(style.overflow) : _overflow.OVERFLOW.HIDDEN,
					padding: (0, _padding.parsePadding)(style),
					position: position,
					textDecoration: (0, _textDecoration.parseTextDecoration)(style),
					textShadow: (0, _textShadow.parseTextShadow)(style.textShadow),
					textTransform: (0, _textTransform.parseTextTransform)(style.textTransform),
					transform: (0, _transform.parseTransform)(style),
					visibility: (0, _visibility.parseVisibility)(style.visibility),
					zIndex: (0, _zIndex.parseZIndex)(position !== _position.POSITION.STATIC ? style.zIndex : 'auto')
				};

				if (this.isTransformed()) {
					// getBoundingClientRect provides values post-transform, we want them without the transformation
					node.style.transform = 'matrix(1,0,0,1,0,0)';
				}

				if (display === _display.DISPLAY.LIST_ITEM) 
				{
					var listOwner = (0, _ListItem.getListOwner)(this);
					if (listOwner) {
						var listIndex = listOwner.listItems.length;
						listOwner.listItems.push(this);
						this.listIndex = node.hasAttribute('value') && typeof node.value === 'number' ? node.value : listIndex === 0 ? typeof listOwner.listStart === 'number' ? listOwner.listStart : 1 : listOwner.listItems[listIndex - 1].listIndex + 1;
					}
				}

				var tagName = node.tagName.toLowerCase();
				//console.log("[NodeContainer]:Loader , getImg tagName =" + tagName);
				switch(tagName)// TODO move bound retrieval for all nodes to a later stage?
				{
					case DZE_TAG_VIDEO://2018.04.03
					{
						node.addEventListener('loadeddata', function (evt) 
						{
							_this.bounds = (0, _Bounds.parseBounds)(node, scrollX, scrollY);
							_this.curvedBounds = (0, _Bounds.parseBoundCurves)(_this.bounds, _this.style.border, _this.style.borderRadius);					
						});					
					}
					break;
					case DZE_TAG_IMG:
					{
						node.addEventListener('load', function () 
						{
							_this.bounds = (0, _Bounds.parseBounds)(node, scrollX, scrollY);
							_this.curvedBounds = (0, _Bounds.parseBoundCurves)(_this.bounds, _this.style.border, _this.style.borderRadius);
						});
					}
					break;
				}
				
				this.image = getImage(node, resourceLoader);
				this.bounds = IS_INPUT ? 
							(0, _Input.reformatInputBounds)((0, _Bounds.parseBounds)(node, scrollX, scrollY)) : 
							(0, _Bounds.parseBounds)(node, scrollX, scrollY);
				this.curvedBounds = (0, _Bounds.parseBoundCurves)(this.bounds, this.style.border, this.style.borderRadius);//what means var
									
				if (true) 
				{
					this.name = '' + node.tagName.toLowerCase() + (node.id ? '#' + node.id : '') + node.className.toString().split(' ').map(function (s) {
						return s.length ? '.' + s : '';
					}).join('');
				}
			}

			_createClass(NodeContainer, [
				{
					key: 'getClipPaths',
					value: function getClipPaths() 
					{
						var parentClips = this.parent ? this.parent.getClipPaths() : [];
						var isClipped = this.style.overflow !== _overflow.OVERFLOW.VISIBLE;

						return isClipped ? parentClips.concat([(0, _Bounds.calculatePaddingBoxPath)(this.curvedBounds)]) : parentClips;
					}
				},
				{
					key: 'isInFlow',
					value: function isInFlow() 
					{
						return this.isRootElement() && !this.isFloating() && !this.isAbsolutelyPositioned();
					}
				}, 
				{
					key: 'isVisible',
					value: function isVisible() 
					{
						return !(0, _Util.contains)(this.style.display, _display.DISPLAY.NONE) && this.style.opacity > 0 && this.style.visibility === _visibility.VISIBILITY.VISIBLE;
					}
				}, 
				{
				key: 'isAbsolutelyPositioned',
					value: function isAbsolutelyPositioned() {
						return this.style.position !== _position.POSITION.STATIC && this.style.position !== _position.POSITION.RELATIVE;
					}
				}, {
					key: 'isPositioned',
					value: function isPositioned() {
						return this.style.position !== _position.POSITION.STATIC;
					}
				}, {
					key: 'isFloating',
					value: function isFloating() {
						return this.style.float !== _float.FLOAT.NONE;
					}
				}, {
					key: 'isRootElement',
					value: function isRootElement() {
						return this.parent === null;
					}
				}, {
					key: 'isTransformed',
					value: function isTransformed() {
						return this.style.transform !== null;
					}
				}, {
					key: 'isPositionedWithZIndex',
					value: function isPositionedWithZIndex() {
						return this.isPositioned() && !this.style.zIndex.auto;
					}
				}, {
					key: 'isInlineLevel',
					value: function isInlineLevel() {
						return (0, _Util.contains)(this.style.display, _display.DISPLAY.INLINE) || (0, _Util.contains)(this.style.display, _display.DISPLAY.INLINE_BLOCK) || 
						(0, _Util.contains)(this.style.display, _display.DISPLAY.INLINE_FLEX) || (0, _Util.contains)(this.style.display, _display.DISPLAY.INLINE_GRID) || 
						(0, _Util.contains)(this.style.display, _display.DISPLAY.INLINE_LIST_ITEM) || (0, _Util.contains)(this.style.display, _display.DISPLAY.INLINE_TABLE);
					}
				}, {
					key: 'isInlineBlockOrInlineTable',
					value: function isInlineBlockOrInlineTable() {
						return (0, _Util.contains)(this.style.display, _display.DISPLAY.INLINE_BLOCK) || (0, _Util.contains)(this.style.display, _display.DISPLAY.INLINE_TABLE);
					}
				}]);

				return NodeContainer;
			}();

			exports.default = NodeContainer;//NODECONINVER


			var getImage = function getImage(node, resourceLoader) 
			{
				var retObj = null;
				if (node instanceof node.ownerDocument.defaultView.SVGSVGElement || node instanceof SVGSVGElement) 
				{
					var s = new XMLSerializer();
					retObj= resourceLoader.loadImage('data:image/svg+xml,' + encodeURIComponent(s.serializeToString(node)));
				}
				else
				{
					var tagName = node.tagName.toLowerCase();
					switch (tagName) 
					{
						case DZE_TAG_VIDEO://misty 2018.04.03
						{
							retObj =  resourceLoader.loadImage(node.poster);
						// 	var testVideoPosterTmpImg = function testVideoPosterTmpImg(videoEl, scale) 
						// 	{
						// 		scale = scale || 1;
							
						// 		// const objCanvas = document.createElement("canvas");
						// 		// objCanvas.width = videoEl.clientWidth * scale;
						// 		// objCanvas.height = videoEl.clientHeight * scale;
						// 		// objCanvas.getContext('2d').drawImage(videoEl, 0, 0, objCanvas.width, objCanvas.height);
								
						// 		const objImg = new Image()
						// 		var tmpSrc = dzeEnvConfig.strPath_Image + 'ribbon/toolbar_btn_insert_video.png';
						// 		objImg.src = tmpSrc;//canvas.toDataURL('image/png');
						// 		// objImg.width = objCanvas.width;
						// 		// objImg.height = objCanvas.height;	
						// 		//var url_base64 = objCanvas.toDataURL('image/png');
						// 		//var imgObj = document.createElement("img");
						// 		//objImg.src = url_base64;
						// 		//var htmlCode = image.src;
						// // 	// 	// var htmlBlob = new Blob(htmlCode, {'image/png'});
						// //		if(!g_bBrowserType_IE)
						// //			var objFile = new File([htmlBlob], filename);//'TEST_문서.whtml'
						// // 	// 	// else
						//  	 	return resourceLoader.loadImage(objImg.src);
						// 		//return image;
						//  	};

						// 	return testVideoPosterTmpImg(node,1);
						}
						break;
						case DZE_TAG_IMG:
							// $FlowFixMe
							var imgNode = node;
							retObj =  resourceLoader.loadImage(imgNode.currentSrc || imgNode.src);
							break;
						case DZE_TAG_CANVAS:
							// $FlowFixMe
							var canvasNode = node;
							retObj =  resourceLoader.loadCanvas(canvasNode);
							break;
						case DZE_TAG_IFRAME:
							var iframeKey = node.getAttribute('data-html2canvas-internal-iframe-key');
							if (iframeKey) 
								retObj =  iframeKey;							
							break;
					}
				}
				//console.log("IMG Info = " + (retObj ? true : false));
				return retObj;
			};

	/***/ }
	),
/* 5 :: _background */
/***/ (
		function(module, exports, __webpack_require__) 
		{
			//g_objCommonUtil.log("modules[5 _background].call");
			"use strict";


			Object.defineProperty(exports, "__esModule", {    value: true});
			exports.parseBackgroundImage = exports.parseBackground = exports.calculateBackgroundRepeatPath = exports.calculateBackgroundPosition = exports.calculateBackgroungPositioningArea = exports.calculateBackgroungPaintingArea = exports.calculateGradientBackgroundSize = exports.calculateBackgroundSize = exports.BACKGROUND_ORIGIN = exports.BACKGROUND_CLIP = exports.BACKGROUND_SIZE = exports.BACKGROUND_REPEAT = undefined;

			var _Color = __webpack_require__(0);

			var _Color2 = _interopRequireDefault(_Color);

			var _Length = __webpack_require__(2);

			var _Length2 = _interopRequireDefault(_Length);

			var _Size = __webpack_require__(28);

			var _Size2 = _interopRequireDefault(_Size);

			var _Vector = __webpack_require__(7);

			var _Vector2 = _interopRequireDefault(_Vector);

			var _Bounds = __webpack_require__(1);

			var _padding = __webpack_require__(14);

			//misty 2018.01.02 function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { default: obj }; }

	//misty 2018.01.02 function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError("Cannot call a class as a function"); } }

			var BACKGROUND_REPEAT = exports.BACKGROUND_REPEAT = 
																{
																	REPEAT: 0,
																	NO_REPEAT: 1,
																	REPEAT_X: 2,
																	REPEAT_Y: 3
																};

			var BACKGROUND_SIZE = exports.BACKGROUND_SIZE = {
				AUTO: 0,
				CONTAIN: 1,
				COVER: 2,
				LENGTH: 3
			};

			var BACKGROUND_CLIP = exports.BACKGROUND_CLIP = {
				BORDER_BOX: 0,
				PADDING_BOX: 1,
				CONTENT_BOX: 2
			};

			var BACKGROUND_ORIGIN = exports.BACKGROUND_ORIGIN = BACKGROUND_CLIP;

			var AUTO = 'auto';

			var BackgroundSize = function BackgroundSize(size) 
			{
				_classCallCheck(this, BackgroundSize);

				switch (size) {
					case 'contain':
						this.size = BACKGROUND_SIZE.CONTAIN;
						break;
					case 'cover':
						this.size = BACKGROUND_SIZE.COVER;
						break;
					case 'auto':
						this.size = BACKGROUND_SIZE.AUTO;
						break;
					default:
						this.value = new _Length2.default(size);
				}
			};

			var calculateBackgroundSize = exports.calculateBackgroundSize = function calculateBackgroundSize(backgroundImage, image, bounds) 
			{
				var width = 0;
				var height = 0;
				var size = backgroundImage.size;
				if (size[0].size === BACKGROUND_SIZE.CONTAIN || size[0].size === BACKGROUND_SIZE.COVER) 
				{
					var targetRatio = bounds.width / bounds.height;
					var currentRatio = image.width / image.height;
					return targetRatio < currentRatio !== (size[0].size === BACKGROUND_SIZE.COVER) ? new _Size2.default(bounds.width, bounds.width / currentRatio) : new _Size2.default(bounds.height * currentRatio, bounds.height);
				}

				if (size[0].value)
				{
					width = size[0].value.getAbsoluteValue(bounds.width);
				}

				if (size[0].size === BACKGROUND_SIZE.AUTO && size[1].size === BACKGROUND_SIZE.AUTO) 
				{
					height = image.height;
				} else if (size[1].size === BACKGROUND_SIZE.AUTO) 
				{
					height = width / image.width * image.height;
				} else if (size[1].value)
				{
					height = size[1].value.getAbsoluteValue(bounds.height);
				}

				if (size[0].size === BACKGROUND_SIZE.AUTO)
				{
					width = height / image.height * image.width;
				}

				return new _Size2.default(width, height);
			};

			var calculateGradientBackgroundSize = exports.calculateGradientBackgroundSize = function calculateGradientBackgroundSize(backgroundImage, bounds) 
			{
				var size = backgroundImage.size;
				var width = size[0].value ? size[0].value.getAbsoluteValue(bounds.width) : bounds.width;
				var height = size[1].value ? size[1].value.getAbsoluteValue(bounds.height) : size[0].value ? width : bounds.height;

				return new _Size2.default(width, height);
			};

			var AUTO_SIZE = new BackgroundSize(AUTO);

			var calculateBackgroungPaintingArea = exports.calculateBackgroungPaintingArea = function calculateBackgroungPaintingArea(curves, clip) 
			{
				switch (clip) 
				{
					case BACKGROUND_CLIP.BORDER_BOX:
						return (0, _Bounds.calculateBorderBoxPath)(curves);
					case BACKGROUND_CLIP.PADDING_BOX:
					default:
						return (0, _Bounds.calculatePaddingBoxPath)(curves);
				}
			};

			var calculateBackgroungPositioningArea = exports.calculateBackgroungPositioningArea = function calculateBackgroungPositioningArea(backgroundOrigin, bounds, padding, border) 
			{
			//	console.log("[calculateBackgroungPositioningArea] bounds l = " + bounds.left + " t = " + bounds.top + " width = " + bounds.width +  " height = " + bounds.height);
				var paddingBox = (0, _Bounds.calculatePaddingBox)(bounds, border);
				var rcBox = paddingBox;
				switch (backgroundOrigin) 
				{
					case BACKGROUND_ORIGIN.BORDER_BOX:
						rcBox =  bounds;
					case BACKGROUND_ORIGIN.CONTENT_BOX:
						var paddingLeft = padding[_padding.PADDING_SIDES.LEFT].getAbsoluteValue(bounds.width);
						var paddingRight = padding[_padding.PADDING_SIDES.RIGHT].getAbsoluteValue(bounds.width);
						var paddingTop = padding[_padding.PADDING_SIDES.TOP].getAbsoluteValue(bounds.width);
						var paddingBottom = padding[_padding.PADDING_SIDES.BOTTOM].getAbsoluteValue(bounds.width);
						rcBox = new _Bounds.Bounds(paddingBox.left + paddingLeft, paddingBox.top + paddingTop, paddingBox.width - paddingLeft - paddingRight, paddingBox.height - paddingTop - paddingBottom);
					case BACKGROUND_ORIGIN.PADDING_BOX:
					default:
						rcBox = paddingBox;
				}
				
			//	console.log("[calculateBackgroungPositioningArea] l = " + rcBox.left + " t = " + rcBox.top + " width = " + rcBox.width +  " height = " + rcBox.height);
				return rcBox;
			};

			var calculateBackgroundPosition = exports.calculateBackgroundPosition = function calculateBackgroundPosition(position, size, bounds) 
			{
				return new _Vector2.default(position[0].getAbsoluteValue(bounds.width - size.width), position[1].getAbsoluteValue(bounds.height - size.height));
			};

			var calculateBackgroundRepeatPath = exports.calculateBackgroundRepeatPath = function calculateBackgroundRepeatPath(background, position, size, backgroundPositioningArea, bounds) 
			{
				var repeat = background.repeat;
				switch (repeat)
				{
					case BACKGROUND_REPEAT.REPEAT_X:
						return [new _Vector2.default(Math.round(bounds.left), Math.round(backgroundPositioningArea.top + position.y)), new _Vector2.default(Math.round(bounds.left + bounds.width), Math.round(backgroundPositioningArea.top + position.y)), new _Vector2.default(Math.round(bounds.left + bounds.width), Math.round(size.height + backgroundPositioningArea.top + position.y)), new _Vector2.default(Math.round(bounds.left), Math.round(size.height + backgroundPositioningArea.top + position.y))];
					case BACKGROUND_REPEAT.REPEAT_Y:
						return [new _Vector2.default(Math.round(backgroundPositioningArea.left + position.x), Math.round(bounds.top)), new _Vector2.default(Math.round(backgroundPositioningArea.left + position.x + size.width), Math.round(bounds.top)), new _Vector2.default(Math.round(backgroundPositioningArea.left + position.x + size.width), Math.round(bounds.height + bounds.top)), new _Vector2.default(Math.round(backgroundPositioningArea.left + position.x), Math.round(bounds.height + bounds.top))];
					case BACKGROUND_REPEAT.NO_REPEAT:
						return [new _Vector2.default(Math.round(backgroundPositioningArea.left + position.x), Math.round(backgroundPositioningArea.top + position.y)), new _Vector2.default(Math.round(backgroundPositioningArea.left + position.x + size.width), Math.round(backgroundPositioningArea.top + position.y)), new _Vector2.default(Math.round(backgroundPositioningArea.left + position.x + size.width), Math.round(backgroundPositioningArea.top + position.y + size.height)), new _Vector2.default(Math.round(backgroundPositioningArea.left + position.x), Math.round(backgroundPositioningArea.top + position.y + size.height))];
					default:
						return [new _Vector2.default(Math.round(bounds.left), Math.round(bounds.top)), new _Vector2.default(Math.round(bounds.left + bounds.width), Math.round(bounds.top)), new _Vector2.default(Math.round(bounds.left + bounds.width), Math.round(bounds.height + bounds.top)), new _Vector2.default(Math.round(bounds.left), Math.round(bounds.height + bounds.top))];
				}
			};

			var parseBackground = exports.parseBackground = function parseBackground(style, resourceLoader, bTable) 
			{
				//console.log("parseBackground" + style.backgroundColor);
				var tmp= {				
					backgroundColor: new _Color2.default(style.backgroundColor),//CANVAS BACKGROUND_COLOR //misty - 2018.04.23 (g_objOnefficeShot.m_PageColor),
					backgroundImage: parseBackgroundImages(style, resourceLoader,bTable),
					backgroundClip: parseBackgroundClip(style.backgroundClip),
					backgroundOrigin: parseBackgroundOrigin(style.backgroundOrigin)
				};

				return tmp;
			};

			var parseBackgroundClip = function parseBackgroundClip(backgroundClip) 
			{
				switch (backgroundClip) 
				{
					case 'padding-box':
						return BACKGROUND_CLIP.PADDING_BOX;
					case 'content-box':
						return BACKGROUND_CLIP.CONTENT_BOX;
				}
				return BACKGROUND_CLIP.BORDER_BOX;
			};

			var parseBackgroundOrigin = function parseBackgroundOrigin(backgroundOrigin) 
			{
				switch (backgroundOrigin) 
				{
					case 'padding-box':
						return BACKGROUND_ORIGIN.PADDING_BOX;
					case 'content-box':
						return BACKGROUND_ORIGIN.CONTENT_BOX;
				}
				return BACKGROUND_ORIGIN.BORDER_BOX;
			};

			var parseBackgroundRepeat = function parseBackgroundRepeat(backgroundRepeat) 
			{
				switch (backgroundRepeat.trim()) 
				{
					case 'no-repeat':
						return BACKGROUND_REPEAT.NO_REPEAT;
					case 'repeat-x':
					case 'repeat no-repeat':
						return BACKGROUND_REPEAT.REPEAT_X;
					case 'repeat-y':
					case 'no-repeat repeat':
						return BACKGROUND_REPEAT.REPEAT_Y;
					case 'repeat':
						return BACKGROUND_REPEAT.REPEAT;
				}

				if (true) {
					dalert('Invalid background-repeat value "' + backgroundRepeat + '"');
				}

				return BACKGROUND_REPEAT.REPEAT;
			};

			var parseBackgroundImages = function parseBackgroundImages(style, resourceLoader,bTable) 
			{
				if(style.backgroundImage == "none")//default
					return [];
					
				var sources = parseBackgroundImage(style.backgroundImage).map(
											function (backgroundImage) 
											{
												if (backgroundImage.method === 'url') 
												{
													var key = resourceLoader.loadImage(backgroundImage.args[0]);
													backgroundImage.args = key ? [key] : [];
												}
												return backgroundImage;
											});
				var positions = style.backgroundPosition.split(' ');//split(',');
				var repeats = style.backgroundRepeat.split(',');
				var sizes = style.backgroundSize.split(',');
				if(bTable && resourceLoader.bTmpImg && sizes[0] == "auto")//misty - 2018.07.02
					sizes[0] = 'contain';
				resourceLoader.bTmpImg = false;
				var retVal = sources.map(
							function (source, index) 
							{
								var size = (sizes[index] || AUTO).trim().split(' ').map(parseBackgroundSize);
								var position = (positions[index] || AUTO).trim().split(' ').map(parseBackgoundPosition);

								var ret = {	source: source,
											repeat: parseBackgroundRepeat(typeof repeats[index] === 'string' ? repeats[index] : repeats[0]),
											size: size.length < 2 ? [size[0], AUTO_SIZE] : [size[0], size[1]],
											position: position.length < 2 ? [position[0], position[0]] : [position[0], position[1]]
										};
								return ret;
							});
				return retVal;
			};

			var parseBackgroundSize = function parseBackgroundSize(size) 
			{
				return size === 'auto' ? AUTO_SIZE : new BackgroundSize(size);
			};

			var parseBackgoundPosition = function parseBackgoundPosition(position) 
			{
				switch (position) 
				{
					case 'bottom':
					case 'right':
						return new _Length2.default('100%');
					case 'left':
					case 'top':
						return new _Length2.default('0%');
					case 'auto':
						return new _Length2.default('0');
					case 'center'://misty - 2018.08.16
						return new _Length2.default('50%');
				}
				return new _Length2.default(position);
			};

			var parseBackgroundImage = exports.parseBackgroundImage = function parseBackgroundImage(image)
			{
				var whitespace = /^\s$/;
				var results = [];//Array

				var args = [];
				var method = '';
				var quote = null;
				var definition = '';
				var mode = 0;
				var numParen = 0;

				var appendResult = function appendResult() 
				{
					var prefix = '';
					if (method) {
						if (definition.substr(0, 1) === '"') 
						{
							definition = definition.substr(1, definition.length - 2);
						}

						if (definition) {
							args.push(definition.trim());
						}

						var prefix_i = method.indexOf('-', 1) + 1;
						if (method.substr(0, 1) === '-' && prefix_i > 0) 
						{
							prefix = method.substr(0, prefix_i).toLowerCase();
							method = method.substr(prefix_i);
						}
						method = method.toLowerCase();
						if (method !== 'none') 
						{
							results.push({
								prefix: prefix,
								method: method,
								args: args
							});
						}
					}
					args = [];
					method = definition = '';
				};

				image.split('').forEach(function (c) 
				{
					if (mode === 0 && whitespace.test(c)) 
					{
						return;
					}
					switch (c) {
						case '"':
							if (!quote) 
							{
								quote = c;
							} else if (quote === c)
							{
								quote = null;
							}
							break;
						case '(':
							if (quote) {
								break;
							} else if (mode === 0) 
							{
								mode = 1;
								return;
							} else {
								numParen++;
							}
							break;
						case ')':
							if (quote) 
							{
								break;
							} else if (mode === 1) 
							{
								if (numParen === 0) 
								{
									mode = 0;
									appendResult();
									return;
								} else 
								{
									numParen--;
								}
							}
							break;

						case ',':
							if (quote) {
								break;
							} else if (mode === 0) {
								appendResult();
								return;
							} else if (mode === 1) {
								if (numParen === 0 && !method.match(/^url$/i)) {
									args.push(definition.trim());
									definition = '';
									return;
								}
							}
							break;
					}

					if (mode === 0) {
						method += c;
					} else {
						definition += c;
					}
				});

				appendResult();
				return results;
			};

	/***/ }
	),
/* 6 :: _Path */
/***/ (
		function(module, exports, __webpack_require__) 
			{
			//g_objCommonUtil.log("modules[6 _Path].call");
			"use strict";


			Object.defineProperty(exports, "__esModule", {    value: true});
			var PATH = exports.PATH = {
				VECTOR: 0,
				BEZIER_CURVE: 1,
				CIRCLE: 2
			};

			/***/ }),
			/* 7 :: _Vector , _Vector2 */
			/***/ (function(module, exports, __webpack_require__) {
			//g_objCommonUtil.log("modules[7 _Vector].call");
			"use strict";


			Object.defineProperty(exports, "__esModule", {    value: true});

			var _Path = __webpack_require__(6);

			//misty 2018.01.02 function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError("Cannot call a class as a function"); } }

			var Vector = function Vector(x, y) {
				_classCallCheck(this, Vector);

				this.type = _Path.PATH.VECTOR;
				this.x = x;
				this.y = y;
				if (true) {
					if (isNaN(x)) {
						dalert('Invalid x value given for Vector');
					}
					if (isNaN(y)) {
						dalert('Invalid y value given for Vector');
					}
				}
			};

			exports.default = Vector;

			/***/ }),
			/* 8 :: _TextContainer , _TextContainer2 */
			/***/ (function(module, exports, __webpack_require__) {
			//g_objCommonUtil.log("modules[8 _TextContainer].call");
			"use strict";


			Object.defineProperty(exports, "__esModule", {    value: true});

			//misty 2018.01.02 var _createClass = function () { function defineProperties(target, props) { for (var i = 0; i < props.length; i++) { var descriptor = props[i]; descriptor.enumerable = descriptor.enumerable || false; descriptor.configurable = true; if ("value" in descriptor) descriptor.writable = true; Object.defineProperty(target, descriptor.key, descriptor); } } return function (Constructor, protoProps, staticProps) { if (protoProps) defineProperties(Constructor.prototype, protoProps); if (staticProps) defineProperties(Constructor, staticProps); return Constructor; }; }();

			var _textTransform = __webpack_require__(17);

			var _TextBounds = __webpack_require__(19);

			//misty 2018.01.02 function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError("Cannot call a class as a function"); } }

			var TextContainer = function () {
				function TextContainer(text, parent, bounds) {
					_classCallCheck(this, TextContainer);

					this.text = text;
					this.parent = parent;
					this.bounds = bounds;
				}

				_createClass(TextContainer, null, [{
					key: 'fromTextNode',
					value: function fromTextNode(node, parent) {
						var text = transform(node.data, parent.style.textTransform);
						var txtBounds = (0, _TextBounds.parseTextBounds)(text, parent, node);
						return new TextContainer(text, parent, txtBounds);
					}
				}]);

				return TextContainer;
			}();

			exports.default = TextContainer;


			var CAPITALIZE = /(^|\s|:|-|\(|\))([a-z])/g;

			var transform = function transform(text, _transform) {
				switch (_transform) {
					case _textTransform.TEXT_TRANSFORM.LOWERCASE:
						return text.toLowerCase();
					case _textTransform.TEXT_TRANSFORM.CAPITALIZE:
						return text.replace(CAPITALIZE, capitalize);
					case _textTransform.TEXT_TRANSFORM.UPPERCASE:
						return text.toUpperCase();
					default:
						return text;
				}
			};

			function capitalize(m, p1, p2) {
				if (m.length > 0) {
					return p1 + p2.toUpperCase();
				}

				return m;
			}

	/***/ }
	),
/* 9 :: _Feature , _Feature2  */
/***/ (
		function(module, exports, __webpack_require__) 
			{
			//g_objCommonUtil.log("modules[9 _Feature].call");
			"use strict";


			Object.defineProperty(exports, "__esModule", {    value: true});

			var _ForeignObjectRenderer = __webpack_require__(20);

			var testRangeBounds = function testRangeBounds(document) 
			{
				var TEST_HEIGHT = 123;

				if (document.createRange) 
				{
					var range = document.createRange();
					if (range.getBoundingClientRect) 
					{
						var testElement = document.createElement('boundtest');
						testElement.style.height = TEST_HEIGHT + 'px';
						testElement.style.display = 'block';
						document.body.appendChild(testElement);

						range.selectNode(testElement);
						var rangeBounds = range.getBoundingClientRect();
						var rangeHeight = Math.round(rangeBounds.height);
						document.body.removeChild(testElement);
						if (rangeHeight === TEST_HEIGHT) 
						{
							return true;
						}
					}
				}

				return false;
			};

			// iOS 10.3 taints canvas with base64 images unless crossOrigin = 'anonymous'
			var testBase64 = function testBase64(document, src , nCurPgNum) //misty - 2018.06.18
			{
				var img = new Image();	//misty
				var canvas = document.createElement('canvas');
				canvas.id = ("testBase64Canvas" + nCurPgNum);				
				var ctx = canvas.getContext('2d');

				return new Promise(function (resolve) {
					// Single pixel base64 image renders fine on iOS 10.3???
					img.src = src;
					img.id = ("testBase64Img" + nCurPgNum);//misty - 2018.06.18
					img.setAttribute("pagenum",nCurPgNum);//misty - 2018.06.18
					var onload = function onload() {
						try 
						{
							ctx.drawImage(img, 0, 0);
							canvas.toDataURL();
						} 
						catch (e) 
						{
							return resolve(false);
						}

						return resolve(true);
					};

					img.onload = onload;//재정의.
					img.onerror = function () {
						return resolve(false);
					};

					if (img.complete === true) {
						setTimeout(function () {
							onload();
						}, THUMBNAIL_TIMER_TIME);
					}
				});
			};

			var testCORS = function testCORS() 
			{
				return typeof new Image().crossOrigin !== 'undefined';
			};

			var testResponseType = function testResponseType() 
			{
				return typeof new XMLHttpRequest().responseType === 'string';
			};

			var testSVG = function testSVG(document) 
			{
				var img = new Image();	//misty
				var canvas = document.createElement('canvas');
				canvas.id = "testSVGCanvas";
				var ctx = canvas.getContext('2d');
				img.id = "testSVGImg";//misty - 2018.06.18
				img.src = 'data:image/svg+xml,<svg xmlns=\'http://www.w3.org/2000/svg\'></svg>';

				try 
				{
					ctx.drawImage(img, 0, 0);
					canvas.toDataURL();
				} 
				catch (e) 
				{
					return false;
				}
				return true;
			};

			var isGreenPixel = function isGreenPixel(data) 
			{
				return data[0] === 0 && data[1] === 255 && data[2] === 0 && data[3] === 255;
			};

			var testForeignObject = function testForeignObject(document) 
			{//misty - 2018.05.09
				var canvas = document.createElement('canvas');
				cavnas.id = "testForeignObject";
				var size = 100;	//misty
				canvas.width = size;
				canvas.height = size;
				var ctx = canvas.getContext('2d');
				ctx.fillStyle = 'rgb(0, 255, 0)';	//misty
				ctx.fillRect(0, 0, size, size);	//misty

				var img = new Image();	//misty
				img.id = "testForeignObject";//misty - 2018.06.18
				var greenImageSrc = canvas.toDataURL();
				img.src = greenImageSrc;
				var svg = (0, _ForeignObjectRenderer.createForeignObjectSVG)(size, size, 0, 0, img);
				ctx.fillStyle = 'red';	//misty
				ctx.fillRect(0, 0, size, size);	//misty

				return (0, _ForeignObjectRenderer.loadSerializedSVG)(svg).then(function (img) {
					ctx.drawImage(img, 0, 0);
					var data = ctx.getImageData(0, 0, size, size).data;
					ctx.fillStyle = 'red';	//misty
					ctx.fillRect(0, 0, size, size);	//misty

					var node = document.createElement('div');
					node.style.backgroundImage = 'url(' + greenImageSrc + ')';
					node.style.height = size + 'px';	//misty
					// Firefox 55 does not render inline <img /> tags
					return isGreenPixel(data) ? (0, _ForeignObjectRenderer.loadSerializedSVG)((0, _ForeignObjectRenderer.createForeignObjectSVG)(size, size, 0, 0, node)) : Promise.reject(false);
				}).then(function (img) {
					ctx.drawImage(img, 0, 0);
					// Edge does not render background-images
					return isGreenPixel(ctx.getImageData(0, 0, size, size).data);
				}).catch(function (e) {
					return false;
				});
			};

			var FEATURES =
			{
				// $FlowFixMe - get/set properties not yet supported
				get SUPPORT_RANGE_BOUNDS() 
				{
					'use strict';

					var value = testRangeBounds(document);
					Object.defineProperty(FEATURES, 'SUPPORT_RANGE_BOUNDS', { value: value });
					return value;
				},
				// $FlowFixMe - get/set properties not yet supported
				get SUPPORT_SVG_DRAWING() 
				{
					'use strict';

					var value = testSVG(document);
					Object.defineProperty(FEATURES, 'SUPPORT_SVG_DRAWING', { value: value });
					return value;
				},
				// $FlowFixMe - get/set properties not yet supported
				get SUPPORT_BASE64_DRAWING() 
				{
					'use strict';

					return function (src,nCurPgNum) {//misty - 2018.06.18
						var _value = testBase64(document, src , nCurPgNum);//misty - 2018.06.18
						Object.defineProperty(FEATURES, 'SUPPORT_BASE64_DRAWING', { value: function value() {
								return _value;
							} });
						return _value;
					};
				},
				// $FlowFixMe - get/set properties not yet supported
				get SUPPORT_FOREIGNOBJECT_DRAWING() 
				{
					'use strict';

					var value = typeof Array.from === 'function' && typeof window.fetch === 'function' ? testForeignObject(document) : Promise.resolve(false);
					Object.defineProperty(FEATURES, 'SUPPORT_FOREIGNOBJECT_DRAWING', { value: value });
					return value;
				},
				// $FlowFixMe - get/set properties not yet supported
				get SUPPORT_CORS_IMAGES() 
				{
					'use strict';

					var value = testCORS();
					Object.defineProperty(FEATURES, 'SUPPORT_CORS_IMAGES', { value: value });
					return value;
				},
				// $FlowFixMe - get/set properties not yet supported
				get SUPPORT_RESPONSE_TYPE() 
				{
					'use strict';

					var value = testResponseType();
					Object.defineProperty(FEATURES, 'SUPPORT_RESPONSE_TYPE', { value: value });
					return value;
				},
				// $FlowFixMe - get/set properties not yet supported
				get SUPPORT_CORS_XHR() 
				{
					'use strict';

					var value = 'withCredentials' in new XMLHttpRequest();
					Object.defineProperty(FEATURES, 'SUPPORT_CORS_XHR', { value: value });
					return value;
				}
			};

			exports.default = FEATURES;

	/***/ }
	),
/* 10 :: _textDecoration */
/***/ (
		function(module, exports, __webpack_require__) 
			{
			//g_objCommonUtil.log("modules[10 _textDecoration].call");
			"use strict";


			Object.defineProperty(exports, "__esModule", {    value: true});
			exports.parseTextDecoration = exports.TEXT_DECORATION_LINE = exports.TEXT_DECORATION = exports.TEXT_DECORATION_STYLE = undefined;

			var _Color = __webpack_require__(0);

			var _Color2 = _interopRequireDefault(_Color);

			//misty 2018.01.02 function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { default: obj }; }

			var TEXT_DECORATION_STYLE = exports.TEXT_DECORATION_STYLE = {
																		SOLID: 0,
																		DOUBLE: 1,
																		DOTTED: 2,
																		DASHED: 3,
																		WAVY: 4
																	};

			var TEXT_DECORATION = exports.TEXT_DECORATION = {    NONE: null};

			var TEXT_DECORATION_LINE = exports.TEXT_DECORATION_LINE = {
																		UNDERLINE: 1,
																		OVERLINE: 2,
																		LINE_THROUGH: 3,
																		BLINK: 4
																	};

			var parseLine = function parseLine(line) 
			{
				switch (line) 
				{
					case 'underline':
						return TEXT_DECORATION_LINE.UNDERLINE;
					case 'overline':
						return TEXT_DECORATION_LINE.OVERLINE;
					case 'line-through':
						return TEXT_DECORATION_LINE.LINE_THROUGH;
				}
				return TEXT_DECORATION_LINE.BLINK;
			};

			var parseTextDecorationLine = function parseTextDecorationLine(line) 
			{
				if (line === 'none') 
				{
					return null;
				}

				return line.split(' ').map(parseLine);
			};

			var parseTextDecorationStyle = function parseTextDecorationStyle(style) 
			{
				switch (style) 
				{
					case 'double':
						return TEXT_DECORATION_STYLE.DOUBLE;
					case 'dotted':
						return TEXT_DECORATION_STYLE.DOTTED;
					case 'dashed':
						return TEXT_DECORATION_STYLE.DASHED;
					case 'wavy':
						return TEXT_DECORATION_STYLE.WAVY;
				}
				return TEXT_DECORATION_STYLE.SOLID;
			};

			var parseTextDecoration = exports.parseTextDecoration = function parseTextDecoration(style) 
			{
				var textDecorationLine = parseTextDecorationLine(style.textDecorationLine ? style.textDecorationLine : style.textDecoration);
				if (textDecorationLine === null) 
				{
					return TEXT_DECORATION.NONE;
				}

				var textDecorationColor = style.textDecorationColor ? new _Color2.default(style.textDecorationColor) : null;
				var textDecorationStyle = parseTextDecorationStyle(style.textDecorationStyle);

				return {
					textDecorationLine: textDecorationLine,
					textDecorationColor: textDecorationColor,
					textDecorationStyle: textDecorationStyle
				};
			};
	/***/ }
	),
/* 11 :: _border */
/***/ (
		function(module, exports, __webpack_require__) 
			{
			//g_objCommonUtil.log("modules[11 _border].call");
			"use strict";


			Object.defineProperty(exports, "__esModule", {    value: true});
			exports.parseBorder = exports.BORDER_SIDES = exports.BORDER_STYLE = undefined;

			var _Color = __webpack_require__(0);

			var _Color2 = _interopRequireDefault(_Color);

			//misty 2018.01.02 function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { default: obj }; }

			var BORDER_STYLE = exports.BORDER_STYLE = 
			{
				NONE: 0,
				SOLID: 1
			};

			var BORDER_SIDES = exports.BORDER_SIDES = 
					{
				TOP: 0,
				RIGHT: 1,
				BOTTOM: 2,
				LEFT: 3
			};

			var SIDES = Object.keys(BORDER_SIDES).map(function (s) 
			{
				return s.toLowerCase();
			});

			var parseBorderStyle = function parseBorderStyle(style) 
			{
				switch (style) 
				{
					case 'none':
						return BORDER_STYLE.NONE;
				}
				return BORDER_STYLE.SOLID;
			};

			var parseBorder = exports.parseBorder = function parseBorder(style) {
				return SIDES.map(
					function (side) 
					{
					var borderColor = new _Color2.default(style.getPropertyValue('border-' + side + '-color'));
					var borderStyle = parseBorderStyle(style.getPropertyValue('border-' + side + '-style'));
					var borderWidth = parseFloat(style.getPropertyValue('border-' + side + '-width'));
					return {
						borderColor: borderColor,
						borderStyle: borderStyle,
						borderWidth: isNaN(borderWidth) ? 0 : borderWidth
					};
				});
			};
	/***/ }
	),
/* 12 :: _CanvasRenderer , _CanvasRenderer2 */
/***/ (
		function(module, exports, __webpack_require__) 
			{
			//g_objCommonUtil.log("modules[12 _CanvasRenderer].call");
			"use strict";


			Object.defineProperty(exports, "__esModule", {    value: true});

			//misty 2018.01.02 var _createClass = function () { function defineProperties(target, props) { for (var i = 0; i < props.length; i++) { var descriptor = props[i]; descriptor.enumerable = descriptor.enumerable || false; descriptor.configurable = true; if ("value" in descriptor) descriptor.writable = true; Object.defineProperty(target, descriptor.key, descriptor); } } return function (Constructor, protoProps, staticProps) { if (protoProps) defineProperties(Constructor.prototype, protoProps); if (staticProps) defineProperties(Constructor, staticProps); return Constructor; }; }();

			var _Path = __webpack_require__(6);

			var _textDecoration = __webpack_require__(10);

			//misty 2018.01.02 function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError("Cannot call a class as a function"); } }

			var addColorStops = function addColorStops(gradient, canvasGradient) 
			{
				var maxStop = Math.max.apply(null, gradient.colorStops.map(function (colorStop) 
				{
					return colorStop.stop;
				}));
				var f = 1 / Math.max(1, maxStop);
				gradient.colorStops.forEach(function (colorStop) {
					canvasGradient.addColorStop(f * colorStop.stop, colorStop.color.toString());
				});
			};

			var CanvasRenderer = function () 
			{
				function CanvasRenderer(canvas) 
				{
					_classCallCheck(this, CanvasRenderer);

					this.canvas = canvas ? canvas : document.createElement('canvas');
					this.canvas.id = "CanvasRenderer";

				}

				_createClass(CanvasRenderer, [//CREATE_CANVAS_CONTEXT_BITMAP_MISTY
					{
						key: 'render',
						value: function render(options) {
							this.ctx = this.canvas.getContext('2d');
							this.options = options;
							this.canvas.width = Math.floor(options.width * options.scale);
							this.canvas.height = Math.floor(options.height * options.scale);
							this.canvas.style.width = options.width + 'px';
							this.canvas.style.height = options.height + 'px';

							this.ctx.scale(this.options.scale, this.options.scale);
							this.ctx.translate(-(options.x/*+510*/), -options.y);//misty - 2018.06.11
							this.ctx.textBaseline = 'bottom';
							var nPgNum = this.canvas.getAttribute("pagenum");
							//console.log("[CanvasRenderer::render=CREATE_CANVAS_CONTEXT_BITMAP] PgNum = " + nPgNum);
							options.logger.log('Canvas renderer initialized ( [w] ' + options.width + 'x [h] ' + options.height + ' at [x] ' + options.x + ', [y] ' + options.y + ') with scale ' + this.options.scale);
						}
					}, 
					{
						key: 'clip',
						value: function clip(clipPaths, callback) 
						{
							var _this = this;

							if (clipPaths.length) 
							{
								this.ctx.save();
								clipPaths.forEach(function (path) 
								{
									_this.path(path);
									_this.ctx.clip();
								});
							}

							callback();

							if (clipPaths.length) 
								this.ctx.restore();
						}
					},
					{
						key: 'drawImage',
						value: function drawImage(image, source, destination) 
						{
							this.ctx.drawImage(image, source.left, source.top, source.width, source.height, destination.left, destination.top, destination.width, destination.height);
						}
					}, 
					{
						key: 'drawShape',
						value: function drawShape(path, color) 
						{
							this.path(path);
							this.ctx.fillStyle = color.toString();
							this.ctx.fill();
						//	console.log("[drawShape] color = " + this.ctx.fillStyle );
						}
					}, 
					{
						key: 'fill',
						value: function fill(color) 
						{
							//console.log("fill gAlpha = " + this.ctx.globalAlpha + " color = " + color );
						//	console.log("fill x = " + this.options.x + " y = " + this.options.y + " w = " + this.options.width + " h = " +this.options.height);
							this.ctx.fillStyle = color.toString();
							this.ctx.fill();
						//	console.log("[fill] color = " + this.ctx.fillStyle );
						}
					},
					{
						key: 'getTarget',
						value: function getTarget() 
						{
							return Promise.resolve(this.canvas);
						}
					}, 
					{
						key: 'path',
						value: function path(_path)
						{
							var _this2 = this;

							this.ctx.beginPath();
							if (Array.isArray(_path))
							{
								_path.forEach(function (point, index) 
								{
									var start = point.type === _Path.PATH.VECTOR ? point : point.start;
									//g_objCommonUtil.log("path[" + point.type +"] :: x = " + start.x + "  y = " + start.y);

									if (index === 0) 
									{
										_this2.ctx.moveTo(start.x, start.y);
									} else 
									{
										_this2.ctx.lineTo(start.x, start.y);
									}

									if (point.type === _Path.PATH.BEZIER_CURVE) 
									{
										_this2.ctx.bezierCurveTo(point.startControl.x, point.startControl.y, point.endControl.x, point.endControl.y, point.end.x, point.end.y);
									}
								});
							} else 
							{
								this.ctx.arc(_path.x + _path.radius, _path.y + _path.radius, _path.radius, 0, Math.PI * 2, true);
							}

							this.ctx.closePath();
						}
					 },
					 {
						key: 'rectangle',
						value: function rectangle(x, y, width, height, color) 
						{							
							this.ctx.fillStyle/*#FFFFFF*/ = color.toString();
							this.ctx.fillRect(x, y, width, height);
						//	console.log("[rectangle] color = " + this.ctx.fillStyle + " x = " + x + " y = " + y + " r = " + (width+x) +" b = " + (height+y));
						}
					}, 
					{
						key: 'renderLinearGradient',
						value: function renderLinearGradient(bounds, gradient) 
						{
							var linearGradient = this.ctx.createLinearGradient(bounds.left + gradient.direction.x1, bounds.top + gradient.direction.y1, bounds.left + gradient.direction.x0, bounds.top + gradient.direction.y0);

							addColorStops(gradient, linearGradient);
							this.ctx.fillStyle = linearGradient;
							this.ctx.fillRect(bounds.left, bounds.top, bounds.width, bounds.height);
						}
					}, 
					{
						key: 'renderRadialGradient',
						value: function renderRadialGradient(bounds, gradient) 
						{
							var _this3 = this;

							var x = bounds.left + gradient.center.x;
							var y = bounds.top + gradient.center.y;

							var radialGradient = this.ctx.createRadialGradient(x, y, 0, x, y, gradient.radius.x);
							if (!radialGradient) 
								return;

							addColorStops(gradient, radialGradient);
							this.ctx.fillStyle = radialGradient;

							if (gradient.radius.x !== gradient.radius.y)
							{
								// transforms for elliptical radial gradient
								var midX = bounds.left + 0.5 * bounds.width;
								var midY = bounds.top + 0.5 * bounds.height;
								var f = gradient.radius.y / gradient.radius.x;
								var invF = 1 / f;

								this.transform(midX, midY, [1, 0, 0, f, 0, 0], function () 
								{
									return _this3.ctx.fillRect(bounds.left, invF * (bounds.top - midY) + midY, bounds.width, bounds.height * invF);
								});
								} 
								else 
								{
									this.ctx.fillRect(bounds.left, bounds.top, bounds.width, bounds.height);
								}
							}
					}, 
					{
					key: 'renderRepeat',
					value: function renderRepeat(path, image, imageSize, offsetX, offsetY) 
				{
						this.path(path);
						var tmp = this.resizeImage(image, imageSize);//misty - 2018.07.02
						this.ctx.fillStyle = this.ctx.createPattern(tmp, 'repeat');
						this.ctx.translate(offsetX, offsetY);
						this.ctx.fill();
						this.ctx.translate(-offsetX, -offsetY);
					}
				}, 
				{
					key: 'renderTextNode',
					value: function renderTextNode(textBounds, color, font, textDecoration, textShadows) 
					{
						var _this4 = this;

						this.ctx.font = [font.fontStyle, font.fontVariant, font.fontWeight, font.fontSize, font.fontFamily].join(' ');

						textBounds.forEach(function (text) 
						{
							_this4.ctx.fillStyle = color.toString();
							if (textShadows && text.text.trim().length) 
							{
								textShadows.slice(0).reverse().forEach(function (textShadow) 
								{
									_this4.ctx.shadowColor = textShadow.color.toString();
									_this4.ctx.shadowOffsetX = textShadow.offsetX * _this4.options.scale;
									_this4.ctx.shadowOffsetY = textShadow.offsetY * _this4.options.scale;
									_this4.ctx.shadowBlur = textShadow.blur;

									_this4.ctx.fillText(text.text, text.bounds.left, text.bounds.top + text.bounds.height);
								});
							} 
							else 
							{
								_this4.ctx.fillText(text.text, text.bounds.left, text.bounds.top + text.bounds.height);
							}

							if (textDecoration !== null) 
							{
								var textDecorationColor = textDecoration.textDecorationColor || color;
								textDecoration.textDecorationLine.forEach(function (textDecorationLine) 
								{
									switch (textDecorationLine) 
									{
										case _textDecoration.TEXT_DECORATION_LINE.UNDERLINE:
											// Draws a line at the baseline of the font
											// TODO As some browsers display the line as more than 1px if the font-size is big,
											// need to take that into account both in position and size
											var _options$fontMetrics$ = _this4.options.fontMetrics.getMetrics(font),
												baseline = _options$fontMetrics$.baseline;

											_this4.rectangle(text.bounds.left, Math.round(text.bounds.top + text.bounds.height - baseline), text.bounds.width, 1, textDecorationColor);
											break;
										case _textDecoration.TEXT_DECORATION_LINE.OVERLINE:
											_this4.rectangle(text.bounds.left, Math.round(text.bounds.top), text.bounds.width, 1, textDecorationColor);
											break;
										case _textDecoration.TEXT_DECORATION_LINE.LINE_THROUGH:
											// TODO try and find exact position for line-through
											var _options$fontMetrics$2 = _this4.options.fontMetrics.getMetrics(font),
												middle = _options$fontMetrics$2.middle;

											_this4.rectangle(text.bounds.left, Math.ceil(text.bounds.top + middle), text.bounds.width, 1, textDecorationColor);
											break;
									}
								});
							}
						});
					}
					}, 
					{
						key: 'resizeImage',
						value: function resizeImage(image, size)
						{
							if (image.width === size.width && image.height === size.height) {
								return image;
							}
					//		console.log("resizeImage ?");
							var canvas = this.canvas.ownerDocument.createElement('canvas');
							canvas.id = "resizeImage";
							canvas.width = size.width;
							canvas.height = size.height;
							var ctx = canvas.getContext('2d');
							ctx.drawImage(image, 0, 0, image.width, image.height, 0, 0, size.width, size.height);
							return canvas;
						}
					}, 
					{
						key: 'setOpacity',
						value: function setOpacity(opacity) 
						{
							this.ctx.globalAlpha = opacity;
						}
					},
					{
						key: 'transform',
						value: function transform(offsetX, offsetY, matrix, callback) 
						{
							this.ctx.save();
							this.ctx.translate(offsetX, offsetY);
							this.ctx.transform(matrix[0], matrix[1], matrix[2], matrix[3], matrix[4], matrix[5]);
							this.ctx.translate(-offsetX, -offsetY);

							callback();

							this.ctx.restore();
						}
					}]);

				return CanvasRenderer;
			}();

			exports.default = CanvasRenderer;

	/***/ }
	),
/* 13 :: _Logger , _Logger2 */
/***/ (
		function(module, exports, __webpack_require__) 
			{
			//g_objCommonUtil.log("modules[13 _Logger].call");
			"use strict";


			Object.defineProperty(exports, "__esModule", {    value: true});

			//misty 2018.01.02 var _createClass = function () { function defineProperties(target, props) { for (var i = 0; i < props.length; i++) { var descriptor = props[i]; descriptor.enumerable = descriptor.enumerable || false; descriptor.configurable = true; if ("value" in descriptor) descriptor.writable = true; Object.defineProperty(target, descriptor.key, descriptor); } } return function (Constructor, protoProps, staticProps) { if (protoProps) defineProperties(Constructor.prototype, protoProps); if (staticProps) defineProperties(Constructor, staticProps); return Constructor; }; }();

			//misty 2018.01.02 function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError("Cannot call a class as a function"); } }

			var Logger = function () 
			{
				function Logger(enabled, id, start) 
				{
					_classCallCheck(this, Logger);

					this.enabled = enabled;
					this.start = start ? start : Date.now();
					this.id = id;
				}

				_createClass(Logger, [{
					key: 'child',
					value: function child(id) {
						return new Logger(this.enabled, id, this.start);
					}

					// eslint-disable-next-line flowtype/no-weak-types

				}, 
				{
					key: 'log',
					value: function log() 
					{
						if (this.enabled && window.console && window.console.log && 
							(dzeEnvConfig && dzeEnvConfig.bDebugging === true))	//(2020-04-23, IE 운영서버 console log 찍히는 문제)
						{
							for (var _len = arguments.length, args = Array(_len), _key = 0; _key < _len; _key++) 
							{
								args[_key] = arguments[_key];
							}

							Function.prototype.bind.call(window.console.log, window.console).apply(window.console, [Date.now() - this.start + 'ms', this.id ? 'html2canvas (' + this.id + '):' : 'html2canvas:'].concat([].slice.call(args, 0)));
						}
					}
					// eslint-disable-next-line flowtype/no-weak-types
				}, 
				{
					key: 'error',
					value: function error() 
					{
						if (this.enabled && window.console && window.console.error) 
						{
							for (var _len2 = arguments.length, args = Array(_len2), _key2 = 0; _key2 < _len2; _key2++) 
								args[_key2] = arguments[_key2];

							Function.prototype.bind.call(window.console.error, window.console).apply(window.console, [Date.now() - this.start + 'ms', this.id ? 'html2canvas (' + this.id + '):' : 'html2canvas:'].concat([].slice.call(args, 0)));
						}
					}
				}]);

				return Logger;
			}();

			exports.default = Logger;

	/***/ }
	),
/* 14 :: _padding */
/***/ (
		function(module, exports, __webpack_require__) 
			{
			//g_objCommonUtil.log("modules[14 _padding].call");
			"use strict";


			Object.defineProperty(exports, "__esModule", {    value: true});
			exports.parsePadding = exports.PADDING_SIDES = undefined;

			var _Length = __webpack_require__(2);

			var _Length2 = _interopRequireDefault(_Length);

			//misty 2018.01.02 function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { default: obj }; }

			var PADDING_SIDES = exports.PADDING_SIDES = 
					{
				TOP: 0,
				RIGHT: 1,
				BOTTOM: 2,
				LEFT: 3
			};

			var SIDES = ['top', 'right', 'bottom', 'left'];

			var parsePadding = exports.parsePadding = function parsePadding(style) 
			{
				return SIDES.map(function (side) 
				{
					return new _Length2.default(style.getPropertyValue('padding-' + side));
				});
			};
	/***/ }
	),
/* 15 :: _listStyle */
/***/(
		function(module, exports, __webpack_require__) 
		{
			//g_objCommonUtil.log("modules[15 _listStyle].call");
			"use strict";

			Object.defineProperty(exports, "__esModule", {    value: true});
			exports.parseListStyle = exports.LIST_STYLE_TYPE = exports.LIST_STYLE_POSITION = undefined;

			var _background = __webpack_require__(5);

			var LIST_STYLE_POSITION = exports.LIST_STYLE_POSITION = {    INSIDE: 0,    OUTSIDE: 1};
			var LIST_STYLE_TYPE = exports.LIST_STYLE_TYPE = {
				NONE: -1,
				DISC: 0,
				CIRCLE: 1,
				SQUARE: 2,
				DECIMAL: 3,
				CJK_DECIMAL: 4,
				DECIMAL_LEADING_ZERO: 5,
				LOWER_ROMAN: 6,
				UPPER_ROMAN: 7,
				LOWER_GREEK: 8,
				LOWER_ALPHA: 9,
				UPPER_ALPHA: 10,
				ARABIC_INDIC: 11,
				ARMENIAN: 12,
				BENGALI: 13,
				CAMBODIAN: 14,
				CJK_EARTHLY_BRANCH: 15,
				CJK_HEAVENLY_STEM: 16,
				CJK_IDEOGRAPHIC: 17,
				DEVANAGARI: 18,
				ETHIOPIC_NUMERIC: 19,
				GEORGIAN: 20,
				GUJARATI: 21,
				GURMUKHI: 22,
				HEBREW: 22,
				HIRAGANA: 23,
				HIRAGANA_IROHA: 24,
				JAPANESE_FORMAL: 25,
				JAPANESE_INFORMAL: 26,
				KANNADA: 27,
				KATAKANA: 28,
				KATAKANA_IROHA: 29,
				KHMER: 30,
				KOREAN_HANGUL_FORMAL: 31,
				KOREAN_HANJA_FORMAL: 32,
				KOREAN_HANJA_INFORMAL: 33,
				LAO: 34,
				LOWER_ARMENIAN: 35,
				MALAYALAM: 36,
				MONGOLIAN: 37,
				MYANMAR: 38,
				ORIYA: 39,
				PERSIAN: 40,
				SIMP_CHINESE_FORMAL: 41,
				SIMP_CHINESE_INFORMAL: 42,
				TAMIL: 43,
				TELUGU: 44,
				THAI: 45,
				TIBETAN: 46,
				TRAD_CHINESE_FORMAL: 47,
				TRAD_CHINESE_INFORMAL: 48,
				UPPER_ARMENIAN: 49,
				DISCLOSURE_OPEN: 50,
				DISCLOSURE_CLOSED: 51
			};

			var parseListStyleType = function parseListStyleType(type) 
			{
				switch (type) 
				{
					case 'disc':
						return LIST_STYLE_TYPE.DISC;
					case 'circle':
						return LIST_STYLE_TYPE.CIRCLE;
					case 'square':
						return LIST_STYLE_TYPE.SQUARE;
					case 'decimal':
						return LIST_STYLE_TYPE.DECIMAL;
					case 'cjk-decimal':
						return LIST_STYLE_TYPE.CJK_DECIMAL;
					case 'decimal-leading-zero':
						return LIST_STYLE_TYPE.DECIMAL_LEADING_ZERO;
					case 'lower-roman':
						return LIST_STYLE_TYPE.LOWER_ROMAN;
					case 'upper-roman':
						return LIST_STYLE_TYPE.UPPER_ROMAN;
					case 'lower-greek':
						return LIST_STYLE_TYPE.LOWER_GREEK;
					case 'lower-alpha':
						return LIST_STYLE_TYPE.LOWER_ALPHA;
					case 'upper-alpha':
						return LIST_STYLE_TYPE.UPPER_ALPHA;
					case 'arabic-indic':
						return LIST_STYLE_TYPE.ARABIC_INDIC;
					case 'armenian':
						return LIST_STYLE_TYPE.ARMENIAN;
					case 'bengali':
						return LIST_STYLE_TYPE.BENGALI;
					case 'cambodian':
						return LIST_STYLE_TYPE.CAMBODIAN;
					case 'cjk-earthly-branch':
						return LIST_STYLE_TYPE.CJK_EARTHLY_BRANCH;
					case 'cjk-heavenly-stem':
						return LIST_STYLE_TYPE.CJK_HEAVENLY_STEM;
					case 'cjk-ideographic':
						return LIST_STYLE_TYPE.CJK_IDEOGRAPHIC;
					case 'devanagari':
						return LIST_STYLE_TYPE.DEVANAGARI;
					case 'ethiopic-numeric':
						return LIST_STYLE_TYPE.ETHIOPIC_NUMERIC;
					case 'georgian':
						return LIST_STYLE_TYPE.GEORGIAN;
					case 'gujarati':
						return LIST_STYLE_TYPE.GUJARATI;
					case 'gurmukhi':
						return LIST_STYLE_TYPE.GURMUKHI;
					case 'hebrew':
						return LIST_STYLE_TYPE.HEBREW;
					case 'hiragana':
						return LIST_STYLE_TYPE.HIRAGANA;
					case 'hiragana-iroha':
						return LIST_STYLE_TYPE.HIRAGANA_IROHA;
					case 'japanese-formal':
						return LIST_STYLE_TYPE.JAPANESE_FORMAL;
					case 'japanese-informal':
						return LIST_STYLE_TYPE.JAPANESE_INFORMAL;
					case 'kannada':
						return LIST_STYLE_TYPE.KANNADA;
					case 'katakana':
						return LIST_STYLE_TYPE.KATAKANA;
					case 'katakana-iroha':
						return LIST_STYLE_TYPE.KATAKANA_IROHA;
					case 'khmer':
						return LIST_STYLE_TYPE.KHMER;
					case 'korean-hangul-formal':
						return LIST_STYLE_TYPE.KOREAN_HANGUL_FORMAL;
					case 'korean-hanja-formal':
						return LIST_STYLE_TYPE.KOREAN_HANJA_FORMAL;
					case 'korean-hanja-informal':
						return LIST_STYLE_TYPE.KOREAN_HANJA_INFORMAL;
					case 'lao':
						return LIST_STYLE_TYPE.LAO;
					case 'lower-armenian':
						return LIST_STYLE_TYPE.LOWER_ARMENIAN;
					case 'malayalam':
						return LIST_STYLE_TYPE.MALAYALAM;
					case 'mongolian':
						return LIST_STYLE_TYPE.MONGOLIAN;
					case 'myanmar':
						return LIST_STYLE_TYPE.MYANMAR;
					case 'oriya':
						return LIST_STYLE_TYPE.ORIYA;
					case 'persian':
						return LIST_STYLE_TYPE.PERSIAN;
					case 'simp-chinese-formal':
						return LIST_STYLE_TYPE.SIMP_CHINESE_FORMAL;
					case 'simp-chinese-informal':
						return LIST_STYLE_TYPE.SIMP_CHINESE_INFORMAL;
					case 'tamil':
						return LIST_STYLE_TYPE.TAMIL;
					case 'telugu':
						return LIST_STYLE_TYPE.TELUGU;
					case 'thai':
						return LIST_STYLE_TYPE.THAI;
					case 'tibetan':
						return LIST_STYLE_TYPE.TIBETAN;
					case 'trad-chinese-formal':
						return LIST_STYLE_TYPE.TRAD_CHINESE_FORMAL;
					case 'trad-chinese-informal':
						return LIST_STYLE_TYPE.TRAD_CHINESE_INFORMAL;
					case 'upper-armenian':
						return LIST_STYLE_TYPE.UPPER_ARMENIAN;
					case 'disclosure-open':
						return LIST_STYLE_TYPE.DISCLOSURE_OPEN;
					case 'disclosure-closed':
						return LIST_STYLE_TYPE.DISCLOSURE_CLOSED;
					case 'none':
					default:
						return LIST_STYLE_TYPE.NONE;
				}
			};

			var parseListStyle = exports.parseListStyle = function parseListStyle(style) 
			{
				var listStyleImage = (0, _background.parseBackgroundImage)(style.getPropertyValue('list-style-image'));
				return {
					listStyleType: parseListStyleType(style.getPropertyValue('list-style-type')),
					listStyleImage: listStyleImage.length ? listStyleImage[0] : null,
					listStylePosition: parseListStylePosition(style.getPropertyValue('list-style-position'))
				};
			};

			var parseListStylePosition = function parseListStylePosition(position) 
			{
				switch (position) 
				{
					case 'inside':
						return LIST_STYLE_POSITION.INSIDE;
					case 'outside':
					default:
						return LIST_STYLE_POSITION.OUTSIDE;
				}
			};
	/***/ }
		),
/* 16 :: _position */
/***/(
		function(module, exports, __webpack_require__) 
		{
			//g_objCommonUtil.log("modules[16 _position].call");
			"use strict";

			Object.defineProperty(exports, "__esModule", {    value: true});
			var POSITION = exports.POSITION = { STATIC: 0,    
												RELATIVE: 1,   
												ABSOLUTE: 2,    
												FIXED: 3,    
												STICKY: 4};

			var parsePosition = exports.parsePosition = function parsePosition(position) 
			{
				switch (position) 
				{
					case 'relative':
						return POSITION.RELATIVE;
					case 'absolute':
						return POSITION.ABSOLUTE;
					case 'fixed':
						return POSITION.FIXED;
					case 'sticky':
						return POSITION.STICKY;
				}

				return POSITION.STATIC;
			};

	/***/ }
	),
/* 17 :: _textTransform */
/***/ 
	(
		function(module, exports, __webpack_require__) 
		{
			//g_objCommonUtil.log("modules[17 _textTransform].call");
			"use strict";

			Object.defineProperty(exports, "__esModule", {    value: true});
			var TEXT_TRANSFORM = exports.TEXT_TRANSFORM = {    NONE: 0,    LOWERCASE: 1,    UPPERCASE: 2,    CAPITALIZE: 3};

			var parseTextTransform = exports.parseTextTransform = function parseTextTransform(textTransform) 
			{
				switch (textTransform) 
				{
					case 'uppercase':
						return TEXT_TRANSFORM.UPPERCASE;
					case 'lowercase':
						return TEXT_TRANSFORM.LOWERCASE;
					case 'capitalize':
						return TEXT_TRANSFORM.CAPITALIZE;
				}

				return TEXT_TRANSFORM.NONE;
			};
	/***/ }
	),
/* 18 :: _Input */
/***/ (
		function(module, exports, __webpack_require__) 
		{
			//g_objCommonUtil.log("modules[18 _Input].call");
			"use strict";


			Object.defineProperty(exports, "__esModule", {    value: true});
			exports.reformatInputBounds = exports.inlineSelectElement = exports.inlineTextAreaElement = exports.inlineInputElement = exports.getInputBorderRadius = exports.INPUT_BACKGROUND = exports.INPUT_BORDERS = exports.INPUT_COLOR = undefined;

			var _TextContainer = __webpack_require__(8);
			var _TextContainer2 = _interopRequireDefault(_TextContainer);
			var _background = __webpack_require__(5);
			var _border = __webpack_require__(11);
			var _Circle = __webpack_require__(44);
			var _Circle2 = _interopRequireDefault(_Circle);
			var _Vector = __webpack_require__(7);
			var _Vector2 = _interopRequireDefault(_Vector);
			var _Color = __webpack_require__(0);
			var _Color2 = _interopRequireDefault(_Color);
			var _Length = __webpack_require__(2);
			var _Length2 = _interopRequireDefault(_Length);
			var _Bounds = __webpack_require__(1);
			var _TextBounds = __webpack_require__(19);
			var _Util = __webpack_require__(3);

			//misty 2018.01.02 function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { default: obj }; }

			var INPUT_COLOR = exports.INPUT_COLOR = new _Color2.default([42, 42, 42]);
			var INPUT_BORDER_COLOR = new _Color2.default([165, 165, 165]);
			var INPUT_BACKGROUND_COLOR = new _Color2.default([222, 222, 222]);
			var INPUT_BORDER = {
				borderWidth: 1,
				borderColor: INPUT_BORDER_COLOR,
				borderStyle: _border.BORDER_STYLE.SOLID
			};
			var INPUT_BORDERS = exports.INPUT_BORDERS = [INPUT_BORDER, INPUT_BORDER, INPUT_BORDER, INPUT_BORDER];
			var INPUT_BACKGROUND = exports.INPUT_BACKGROUND = {
				backgroundColor: INPUT_BACKGROUND_COLOR,
				backgroundImage: [],
				backgroundClip: _background.BACKGROUND_CLIP.PADDING_BOX,
				backgroundOrigin: _background.BACKGROUND_ORIGIN.PADDING_BOX
			};

			var RADIO_BORDER_RADIUS = new _Length2.default('50%');
			var RADIO_BORDER_RADIUS_TUPLE = [RADIO_BORDER_RADIUS, RADIO_BORDER_RADIUS];
			var INPUT_RADIO_BORDER_RADIUS = [RADIO_BORDER_RADIUS_TUPLE, RADIO_BORDER_RADIUS_TUPLE, RADIO_BORDER_RADIUS_TUPLE, RADIO_BORDER_RADIUS_TUPLE];

			var CHECKBOX_BORDER_RADIUS = new _Length2.default('3px');
			var CHECKBOX_BORDER_RADIUS_TUPLE = [CHECKBOX_BORDER_RADIUS, CHECKBOX_BORDER_RADIUS];
			var INPUT_CHECKBOX_BORDER_RADIUS = [CHECKBOX_BORDER_RADIUS_TUPLE, CHECKBOX_BORDER_RADIUS_TUPLE, CHECKBOX_BORDER_RADIUS_TUPLE, CHECKBOX_BORDER_RADIUS_TUPLE];

			var getInputBorderRadius = exports.getInputBorderRadius = function getInputBorderRadius(node) 
			{
				return node.type === 'radio' ? INPUT_RADIO_BORDER_RADIUS : INPUT_CHECKBOX_BORDER_RADIUS;
			};

			var inlineInputElement = exports.inlineInputElement = function inlineInputElement(node, container) 
			{
				if (node.type === 'radio' || node.type === 'checkbox') 
				{
					if (node.checked) 
					{
						var size = Math.min(container.bounds.width, container.bounds.height);
						container.childNodes.push(node.type === 'checkbox' ? [new _Vector2.default(container.bounds.left + size * 0.39363, container.bounds.top + size * 0.79), new _Vector2.default(container.bounds.left + size * 0.16, container.bounds.top + size * 0.5549), new _Vector2.default(container.bounds.left + size * 0.27347, container.bounds.top + size * 0.44071), new _Vector2.default(container.bounds.left + size * 0.39694, container.bounds.top + size * 0.5649), new _Vector2.default(container.bounds.left + size * 0.72983, container.bounds.top + size * 0.23), new _Vector2.default(container.bounds.left + size * 0.84, container.bounds.top + size * 0.34085), new _Vector2.default(container.bounds.left + size * 0.39363, container.bounds.top + size * 0.79)] : new _Circle2.default(container.bounds.left + size / 4, container.bounds.top + size / 4, size / 4));
					}
				} 
				else 
				{
					inlineFormElement(getInputValue(node), node, container, false);
				}
			};

			var inlineTextAreaElement = exports.inlineTextAreaElement = function inlineTextAreaElement(node, container)
			{
				inlineFormElement(node.value, node, container, true);
			};

			var inlineSelectElement = exports.inlineSelectElement = function inlineSelectElement(node, container) 
			{
				var option = node.options[node.selectedIndex || 0];
				inlineFormElement(option ? option.text || '' : '', node, container, false);
			};

			var reformatInputBounds = exports.reformatInputBounds = function reformatInputBounds(bounds) 
			{
				if (bounds.width > bounds.height)
				{
					bounds.left += (bounds.width - bounds.height) / 2;
					bounds.width = bounds.height;
				} 
				else if (bounds.width < bounds.height) 
				{
					bounds.top += (bounds.height - bounds.width) / 2;
					bounds.height = bounds.width;
				}
				return bounds;
			};

			var inlineFormElement = function inlineFormElement(value, node, container, allowLinebreak) 
			{
				var body = node.ownerDocument.body;
				if (value.length > 0 && body) 
				{
					var wrapper = node.ownerDocument.createElement('html2canvaswrapper');
					(0, _Util.copyCSSStyles)(node.ownerDocument.defaultView.getComputedStyle(node, null), wrapper);
					wrapper.style.position = 'fixed';
					wrapper.style.left = container.bounds.left + 'px';
					wrapper.style.top = container.bounds.top + 'px';
					if (!allowLinebreak) 
						wrapper.style.whiteSpace = 'nowrap';

					var text = node.ownerDocument.createTextNode(value);
					wrapper.appendChild(text);
					body.appendChild(wrapper);
					var charSetArray = _TextContainer2.default.fromTextNode(text, container);
					container.childNodes.push(charSetArray);
					body.removeChild(wrapper);
				}
			};

			var getInputValue = function getInputValue(node) 
			{
				var value = node.type === 'password' ? new Array(node.value.length + 1).join('\u2022') : node.value;

				return value.length === 0 ? node.placeholder || '' : value;
			};
	/***/ }
	),
/* 19 :: _TextBounds */
/***/ (
		function(module, exports, __webpack_require__) 
			{
			//g_objCommonUtil.log("modules[19 _TextBounds].call");
			"use strict";


			Object.defineProperty(exports, "__esModule", {    value: true});
			exports.parseTextBounds = exports.TextBounds = undefined;

			var _punycode = __webpack_require__(41);

			var _Bounds = __webpack_require__(1);

			var _textDecoration = __webpack_require__(10);

			var _Feature = __webpack_require__(9);

			var _Feature2 = _interopRequireDefault(_Feature);

			//misty 2018.01.02 function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { default: obj }; }

			//misty 2018.01.02 function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError("Cannot call a class as a function"); } }

			var UNICODE = /[^\u0000-\u00ff]/;

			var hasUnicodeCharacters = function hasUnicodeCharacters(text) 
			{
				return UNICODE.test(text);
			};

			var encodeCodePoint = function encodeCodePoint(codePoint) 
			{
				return _punycode.ucs2.encode([codePoint]);
			};

			var TextBounds = exports.TextBounds = function TextBounds(text, bounds) 
			{
				_classCallCheck(this, TextBounds);

				this.text = text;
				this.bounds = bounds;
				//console.log( "[ text = " + this.text + " / l : " + bounds.left + " t : " + bounds.top + " w : " + bounds.width + " height : " + bounds.height + " ]=========================================" );
			};

			var parseTextBounds = exports.parseTextBounds = function parseTextBounds(value, parent, node) 
			{
				var codePoints = _punycode.ucs2.decode(value);
			//	console/*logger*/.log('parseTextBounds::value= ' + value + ' codePoints= ' + codePoints[0]);
				var letterRendering = parent.style.letterSpacing !== 0 || hasUnicodeCharacters(value);
				var textList = letterRendering ? codePoints.map(encodeCodePoint) : splitWords(codePoints);
				var length = textList.length;
				var defaultView = node.parentNode ? node.parentNode.ownerDocument.defaultView : null;
				var scrollX = defaultView ? defaultView.pageXOffset : 0;
				var scrollY = defaultView ? defaultView.pageYOffset : 0;
				var textBounds = [];
				var offset = 0;
				for (var i = 0; i < length; i++)
				{
					var text = textList[i];
					if (parent.style.textDecoration !== _textDecoration.TEXT_DECORATION.NONE || text.trim().length > 0)
					{
						var txtBoundsInfo = null,txtBounds = null;
						if (_Feature2.default.SUPPORT_RANGE_BOUNDS) 
						{
							txtBounds =  getRangeBounds(node, offset, text.length, scrollX, scrollY);
							txtBoundsInfo = new TextBounds(text,txtBounds);
							textBounds.push(txtBoundsInfo);
						} 
						else
						{
							var replacementNode = node.splitText(text.length);
							txtBounds = getWrapperBounds(node, scrollX, scrollY);
							txtBoundsInfo = new TextBounds(text, txtBounds);
							textBounds.push(txtBoundsInfo);
							node = replacementNode;
						}
					} 
					else if (!_Feature2.default.SUPPORT_RANGE_BOUNDS) 
					{
						node = node.splitText(text.length);
					}
					offset += text.length;
				}
				return textBounds;
			};

			var getWrapperBounds = function getWrapperBounds(node, scrollX, scrollY) 
			{
				var wrapper = node.ownerDocument.createElement('html2canvaswrapper');
				wrapper.appendChild(node.cloneNode(true));
				var parentNode = node.parentNode;
				if (parentNode)
				{
					parentNode.replaceChild(wrapper, node);
					var bounds = (0, _Bounds.parseBounds)(wrapper, scrollX, scrollY);
					if (wrapper.firstChild)
					{
						parentNode.replaceChild(wrapper.firstChild, wrapper);
					}
					return bounds;
				}
				return new _Bounds.Bounds(0, 0, 0, 0);
			};

			var getRangeBounds = function getRangeBounds(node, offset, length, scrollX, scrollY) 
			{
				var range = node.ownerDocument.createRange();
				range.setStart(node, offset);
				range.setEnd(node, offset + length);
				var retBounds = _Bounds.Bounds.fromClientRect(range.getBoundingClientRect(), scrollX, scrollY);
				return retBounds;
			};

			var splitWords = function splitWords(codePoints) 
			{
				var words = [];
				var i = 0;
				var onWordBoundary = false;
				var word = void 0;
				while (codePoints.length) 
				{
					if (isWordBoundary(codePoints[i]) === onWordBoundary) 
					{
						word = codePoints.splice(0, i);
						if (word.length)
						{
							words.push(_punycode.ucs2.encode(word));
						}
						onWordBoundary = !onWordBoundary;
						i = 0;
					} 
					else 
					{
						i++;
					}

					if (i >= codePoints.length) 
					{
						word = codePoints.splice(0, i);
						if (word.length) 
							words.push(_punycode.ucs2.encode(word));
					}
				}
				return words;
			};

			var isWordBoundary = function isWordBoundary(characterCode) 
			{//ascii
				return [32, // <space>
				13, // \r
				10, // \n
				9, // \t
				45 // -
				].indexOf(characterCode) !== -1;
			};
	/***/ }
	),
/* 20 :: _ForeignObjectRenderer , _ForeignObjectRenderer2 */
/***/ (
		function(module, exports, __webpack_require__) 
		{
				//g_objCommonUtil.log("modules[20 _ForeignObjectRenderer].call");
				"use strict";


				Object.defineProperty(exports, "__esModule", {    value: true});

				//misty 2018.01.02 var _createClass = function () { function defineProperties(target, props) { for (var i = 0; i < props.length; i++) { var descriptor = props[i]; descriptor.enumerable = descriptor.enumerable || false; descriptor.configurable = true; if ("value" in descriptor) descriptor.writable = true; Object.defineProperty(target, descriptor.key, descriptor); } } return function (Constructor, protoProps, staticProps) { if (protoProps) defineProperties(Constructor.prototype, protoProps); if (staticProps) defineProperties(Constructor, staticProps); return Constructor; }; }();

				//misty 2018.01.02 function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError("Cannot call a class as a function"); } }

				var ForeignObjectRenderer = function () 
				{
					function ForeignObjectRenderer(element)
					{
						_classCallCheck(this, ForeignObjectRenderer);

						this.element = element;
					}

					_createClass(ForeignObjectRenderer, [
						{
							key: 'render',
							value: function render(options) 
							{
								var _this = this;

								this.options = options;
								this.canvas = document.createElement('canvas');
								this.canvas.id = "ForeignObjectRenderer";
								this.ctx = this.canvas.getContext('2d');
								this.canvas.width = Math.floor(options.width) * options.scale;
								this.canvas.height = Math.floor(options.height) * options.scale;
								this.canvas.style.width = options.width + 'px';
								this.canvas.style.height = options.height + 'px';

								options.logger.log('ForeignObject renderer initialized (' + options.width + 'x' + options.height + ' at ' + options.x + ',' + options.y + ') with scale ' + options.scale);
								var svg = createForeignObjectSVG(Math.max(options.windowWidth, options.width) * options.scale, Math.max(options.windowHeight, options.height) * options.scale, options.scrollX * options.scale, options.scrollY * options.scale, this.element);

								return loadSerializedSVG(svg).then(function (img) {
									if (options.backgroundColor) {
										_this.ctx.fillStyle = options.backgroundColor.toString();
										_this.ctx.fillRect(0, 0, options.width * options.scale, options.height * options.scale);
									}

									_this.ctx.drawImage(img, -options.x * options.scale, -options.y * options.scale);
									return _this.canvas;
								});
							}
						}]);

					return ForeignObjectRenderer;
				}();

				exports.default = ForeignObjectRenderer;
				var createForeignObjectSVG = exports.createForeignObjectSVG = function createForeignObjectSVG(width, height, x, y, node) 
				{
					var xmlns = 'http://www.w3.org/2000/svg';
					var svg = document.createElementNS(xmlns, 'svg');
					var foreignObject = document.createElementNS(xmlns, 'foreignObject');
					svg.setAttributeNS(null, 'width', width);
					svg.setAttributeNS(null, 'height', height);

					foreignObject.setAttributeNS(null, 'width', '100%');
					foreignObject.setAttributeNS(null, 'height', '100%');
					foreignObject.setAttributeNS(null, 'x', x);
					foreignObject.setAttributeNS(null, 'y', y);
					foreignObject.setAttributeNS(null, 'externalResourcesRequired', 'true');
					svg.appendChild(foreignObject);

					foreignObject.appendChild(node);

					return svg;
				};

				var loadSerializedSVG = exports.loadSerializedSVG = function loadSerializedSVG(svg)
				{
					return new Promise(function (resolve, reject)
					{
						var img = new Image();	//misty
						img.onload = function () {
							return resolve(img);	//misty
						};
						img.onerror = reject;

						img.src = 'data:image/svg+xml;charset=utf-8,' + encodeURIComponent(new XMLSerializer().serializeToString(svg));
					});
				};
		/***/ }
		),
	/* 21 :: _ListItem */
	/***/ (
			function(module, exports, __webpack_require__) 
			{
				//g_objCommonUtil.log("modules[21 _ListItem].call");
				"use strict";


				Object.defineProperty(exports, "__esModule", {    value: true});
				exports.inlineListItemElement = exports.getListOwner = undefined;

				var _Util = __webpack_require__(3);

				var _NodeContainer = __webpack_require__(4);

				var _NodeContainer2 = _interopRequireDefault(_NodeContainer);

				var _TextContainer = __webpack_require__(8);

				var _TextContainer2 = _interopRequireDefault(_TextContainer);

				var _listStyle = __webpack_require__(15);

				var _Unicode = __webpack_require__(45);

				//misty 2018.01.02 function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { default: obj }; }

				// Margin between the enumeration and the list item content
				var MARGIN_RIGHT = 7;

				var ancestorTypes = ['OL', 'UL', 'MENU'];

				var getListOwner = exports.getListOwner = function getListOwner(container) 
				{
					var parent = container.parent;
					if (!parent) 
					{
						return null;
					}

					do
					{
						var isAncestor = ancestorTypes.indexOf(parent.tagName) !== -1;
						if (isAncestor) 
						{
							return parent;
						}
						parent = parent.parent;
					} while (parent);

					return container.parent;
				};

				var inlineListItemElement = exports.inlineListItemElement = function inlineListItemElement(node, container, resourceLoader) 
				{
					var listStyle = container.style.listStyle;

					if (!listStyle) 
						return;

					var style = node.ownerDocument.defaultView.getComputedStyle(node, null);
					var wrapper = node.ownerDocument.createElement('html2canvaswrapper');
					(0, _Util.copyCSSStyles)(style, wrapper);

					wrapper.style.position = 'absolute';
					wrapper.style.bottom = 'auto';
					wrapper.style.display = 'block';
					wrapper.style.letterSpacing = 'normal';

					switch (listStyle.listStylePosition) 
					{
						case _listStyle.LIST_STYLE_POSITION.OUTSIDE:
							wrapper.style.left = 'auto';
							wrapper.style.right = node.ownerDocument.defaultView.innerWidth - container.bounds.left - container.style.margin[1].getAbsoluteValue(container.bounds.width) + MARGIN_RIGHT + 'px';
							wrapper.style.textAlign = 'right';
							break;
						case _listStyle.LIST_STYLE_POSITION.INSIDE:
							wrapper.style.left = container.bounds.left - container.style.margin[3].getAbsoluteValue(container.bounds.width) + 'px';
							wrapper.style.right = 'auto';
							wrapper.style.textAlign = 'left';
							break;
					}

					var text = void 0;
					var MARGIN_TOP = container.style.margin[0].getAbsoluteValue(container.bounds.width);
					var styleImage = listStyle.listStyleImage;
					if (styleImage) 
					{
						if (styleImage.method === 'url') 
						{
							var image = node.ownerDocument.createElement('img');
							image.src = styleImage.args[0];
							wrapper.style.top = container.bounds.top - MARGIN_TOP + 'px';
							wrapper.style.width = 'auto';
							wrapper.style.height = 'auto';
							wrapper.appendChild(image);
						} 
						else 
						{
							var size = parseFloat(container.style.font.fontSize) * 0.5;
							wrapper.style.top = container.bounds.top - MARGIN_TOP + container.bounds.height - 1.5 * size + 'px';
							wrapper.style.width = size + 'px';
							wrapper.style.height = size + 'px';
							wrapper.style.backgroundImage = style.listStyleImage;
						}
					} 
					else if (typeof container.listIndex === 'number')
					{
						text = node.ownerDocument.createTextNode(createCounterText(container.listIndex, listStyle.listStyleType));
						wrapper.appendChild(text);
						wrapper.style.top = container.bounds.top - MARGIN_TOP + 'px';
					}

					// $FlowFixMe
					var body = node.ownerDocument.body;
					body.appendChild(wrapper);

					if (text)
					{
						var charSetArray = _TextContainer2.default.fromTextNode(text, container);
						container.childNodes.push(charSetArray);
						body.removeChild(wrapper);
					} 
					else 
					{
						// $FlowFixMe
						container.childNodes.push(new _NodeContainer2.default(wrapper, container, resourceLoader, 0));
					}
				};

				var ROMAN_UPPER = {
					integers: [1000, 900, 500, 400, 100, 90, 50, 40, 10, 9, 5, 4, 1],
					values: ['M', 'CM', 'D', 'CD', 'C', 'XC', 'L', 'XL', 'X', 'IX', 'V', 'IV', 'I']
				};

				var ARMENIAN = {
					integers: [9000, 8000, 7000, 6000, 5000, 4000, 3000, 2000, 1000, 900, 800, 700, 600, 500, 400, 300, 200, 100, 90, 80, 70, 60, 50, 40, 30, 20, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1],
					values: ['Ք', 'Փ', 'Ւ', 'Ց', 'Ր', 'Տ', 'Վ', 'Ս', 'Ռ', 'Ջ', 'Պ', 'Չ', 'Ո', 'Շ', 'Ն', 'Յ', 'Մ', 'Ճ', 'Ղ', 'Ձ', 'Հ', 'Կ', 'Ծ', 'Խ', 'Լ', 'Ի', 'Ժ', 'Թ', 'Ը', 'Է', 'Զ', 'Ե', 'Դ', 'Գ', 'Բ', 'Ա']
				};

				var HEBREW = {
					integers: [10000, 9000, 8000, 7000, 6000, 5000, 4000, 3000, 2000, 1000, 400, 300, 200, 100, 90, 80, 70, 60, 50, 40, 30, 20, 19, 18, 17, 16, 15, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1],
					values: ['י׳', 'ט׳', 'ח׳', 'ז׳', 'ו׳', 'ה׳', 'ד׳', 'ג׳', 'ב׳', 'א׳', 'ת', 'ש', 'ר', 'ק', 'צ', 'פ', 'ע', 'ס', 'נ', 'מ', 'ל', 'כ', 'יט', 'יח', 'יז', 'טז', 'טו', 'י', 'ט', 'ח', 'ז', 'ו', 'ה', 'ד', 'ג', 'ב', 'א']
				};

				var GEORGIAN = {
					integers: [10000, 9000, 8000, 7000, 6000, 5000, 4000, 3000, 2000, 1000, 900, 800, 700, 600, 500, 400, 300, 200, 100, 90, 80, 70, 60, 50, 40, 30, 20, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1],
					values: ['ჵ', 'ჰ', 'ჯ', 'ჴ', 'ხ', 'ჭ', 'წ', 'ძ', 'ც', 'ჩ', 'შ', 'ყ', 'ღ', 'ქ', 'ფ', 'ჳ', 'ტ', 'ს', 'რ', 'ჟ', 'პ', 'ო', 'ჲ', 'ნ', 'მ', 'ლ', 'კ', 'ი', 'თ', 'ჱ', 'ზ', 'ვ', 'ე', 'დ', 'გ', 'ბ', 'ა']
				};

				var createAdditiveCounter = function createAdditiveCounter(value, min, max, symbols, fallback) 
				{
					var suffix = arguments.length > 5 && arguments[5] !== undefined ? arguments[5] : '. ';

					if (value < min || value > max) 
						return createCounterText(value, fallback);

					return symbols.integers.reduce(function (string, integer, index)
					{
						while (value >= integer) 
						{
							value -= integer;
							string += symbols.values[index];
						}
						return string;
					}, '') + suffix;
				};

				var createCounterStyleWithSymbolResolver = function createCounterStyleWithSymbolResolver(value, codePointRangeLength, isNumeric, resolver)
				{
					var string = '';

					do
					{
						if (!isNumeric) 
							value--;

						string = resolver(value) + string;
						value /= codePointRangeLength;
					} while (value * codePointRangeLength >= codePointRangeLength);

					return string;
				};

				var createCounterStyleFromRange = function createCounterStyleFromRange(value, codePointRangeStart, codePointRangeEnd, isNumeric) 
				{
					var suffix = arguments.length > 4 && arguments[4] !== undefined ? arguments[4] : '. ';

					var codePointRangeLength = codePointRangeEnd - codePointRangeStart + 1;

					return (value < 0 ? '-' : '') + (createCounterStyleWithSymbolResolver(Math.abs(value), codePointRangeLength, isNumeric, function (codePoint) 
					{
						return (0, _Unicode.fromCodePoint)(Math.floor(codePoint % codePointRangeLength) + codePointRangeStart);
					}) + suffix);
				};

				var createCounterStyleFromSymbols = function createCounterStyleFromSymbols(value, symbols)
				{
					var suffix = arguments.length > 2 && arguments[2] !== undefined ? arguments[2] : '. ';

					var codePointRangeLength = symbols.length;
					return createCounterStyleWithSymbolResolver(Math.abs(value), codePointRangeLength, false, function (codePoint) 
					{
						return symbols[Math.floor(codePoint % codePointRangeLength)];
					}) + suffix;
				};

				var CJK_ZEROS = 1 << 0;
				var CJK_TEN_COEFFICIENTS = 1 << 1;
				var CJK_TEN_HIGH_COEFFICIENTS = 1 << 2;
				var CJK_HUNDRED_COEFFICIENTS = 1 << 3;

				var createCJKCounter = function createCJKCounter(value, numbers, multipliers, negativeSign, suffix, flags)
				{
					if (value < -9999 || value > 9999) 
					{		
						return createCounterText(value, _listStyle.LIST_STYLE_TYPE.CJK_DECIMAL);
					}
					var tmp = Math.abs(value);
					var string = suffix;

					if (tmp === 0) {
						return numbers[0] + string;
					}

					for (var digit = 0; tmp > 0 && digit <= 4; digit++) 
					{
						var coefficient = tmp % 10;

						if (coefficient === 0 && (0, _Util.contains)(flags, CJK_ZEROS) && string !== '')
						{
							string = numbers[coefficient] + string;
						} else if (coefficient > 1 || coefficient === 1 && digit === 0 || coefficient === 1 && digit === 1 && (0, _Util.contains)(flags, CJK_TEN_COEFFICIENTS) || coefficient === 1 && digit === 1 && (0, _Util.contains)(flags, CJK_TEN_HIGH_COEFFICIENTS) && value > 100 || coefficient === 1 && digit > 1 && (0, _Util.contains)(flags, CJK_HUNDRED_COEFFICIENTS)) {
							string = numbers[coefficient] + (digit > 0 ? multipliers[digit - 1] : '') + string;
						} else if (coefficient === 1 && digit > 0) {
							string = multipliers[digit - 1] + string;
						}
						tmp = Math.floor(tmp / 10);
					}

					return (value < 0 ? negativeSign : '') + string;
				};

				var CHINESE_INFORMAL_MULTIPLIERS = '十百千萬';
				var CHINESE_FORMAL_MULTIPLIERS = '拾佰仟萬';
				var JAPANESE_NEGATIVE = 'マイナス';
				var KOREAN_NEGATIVE = '마이너스 ';

				var createCounterText = function createCounterText(value, type) 
				{
					switch (type) 
					{
						case _listStyle.LIST_STYLE_TYPE.DISC:
							return '•';
						case _listStyle.LIST_STYLE_TYPE.CIRCLE:
							return '◦';
						case _listStyle.LIST_STYLE_TYPE.SQUARE:
							return '◾';
						case _listStyle.LIST_STYLE_TYPE.DECIMAL_LEADING_ZERO:
							var string = createCounterStyleFromRange(value, 48, 57, true);
							return string.length < 4 ? '0' + string : string;
						case _listStyle.LIST_STYLE_TYPE.CJK_DECIMAL:
							return createCounterStyleFromSymbols(value, '〇一二三四五六七八九', '、');
						case _listStyle.LIST_STYLE_TYPE.LOWER_ROMAN:
							return createAdditiveCounter(value, 1, 3999, ROMAN_UPPER, _listStyle.LIST_STYLE_TYPE.DECIMAL).toLowerCase();
						case _listStyle.LIST_STYLE_TYPE.UPPER_ROMAN:
							return createAdditiveCounter(value, 1, 3999, ROMAN_UPPER, _listStyle.LIST_STYLE_TYPE.DECIMAL);
						case _listStyle.LIST_STYLE_TYPE.LOWER_GREEK:
							return createCounterStyleFromRange(value, 945, 969, false);
						case _listStyle.LIST_STYLE_TYPE.LOWER_ALPHA:
							return createCounterStyleFromRange(value, 97, 122, false);
						case _listStyle.LIST_STYLE_TYPE.UPPER_ALPHA:
							return createCounterStyleFromRange(value, 65, 90, false);
						case _listStyle.LIST_STYLE_TYPE.ARABIC_INDIC:
							return createCounterStyleFromRange(value, 1632, 1641, true);
						case _listStyle.LIST_STYLE_TYPE.ARMENIAN:
						case _listStyle.LIST_STYLE_TYPE.UPPER_ARMENIAN:
							return createAdditiveCounter(value, 1, 9999, ARMENIAN, _listStyle.LIST_STYLE_TYPE.DECIMAL);
						case _listStyle.LIST_STYLE_TYPE.LOWER_ARMENIAN:
							return createAdditiveCounter(value, 1, 9999, ARMENIAN, _listStyle.LIST_STYLE_TYPE.DECIMAL).toLowerCase();
						case _listStyle.LIST_STYLE_TYPE.BENGALI:
							return createCounterStyleFromRange(value, 2534, 2543, true);
						case _listStyle.LIST_STYLE_TYPE.CAMBODIAN:
						case _listStyle.LIST_STYLE_TYPE.KHMER:
							return createCounterStyleFromRange(value, 6112, 6121, true);
						case _listStyle.LIST_STYLE_TYPE.CJK_EARTHLY_BRANCH:
							return createCounterStyleFromSymbols(value, '子丑寅卯辰巳午未申酉戌亥', '、');
						case _listStyle.LIST_STYLE_TYPE.CJK_HEAVENLY_STEM:
							return createCounterStyleFromSymbols(value, '甲乙丙丁戊己庚辛壬癸', '、');
						case _listStyle.LIST_STYLE_TYPE.CJK_IDEOGRAPHIC:
						case _listStyle.LIST_STYLE_TYPE.TRAD_CHINESE_INFORMAL:
							return createCJKCounter(value, '零一二三四五六七八九', CHINESE_INFORMAL_MULTIPLIERS, '負', '、', CJK_TEN_COEFFICIENTS | CJK_TEN_HIGH_COEFFICIENTS | CJK_HUNDRED_COEFFICIENTS);
						case _listStyle.LIST_STYLE_TYPE.TRAD_CHINESE_FORMAL:
							return createCJKCounter(value, '零壹貳參肆伍陸柒捌玖', CHINESE_FORMAL_MULTIPLIERS, '負', '、', CJK_ZEROS | CJK_TEN_COEFFICIENTS | CJK_TEN_HIGH_COEFFICIENTS | CJK_HUNDRED_COEFFICIENTS);
						case _listStyle.LIST_STYLE_TYPE.SIMP_CHINESE_INFORMAL:
							return createCJKCounter(value, '零一二三四五六七八九', CHINESE_INFORMAL_MULTIPLIERS, '负', '、', CJK_TEN_COEFFICIENTS | CJK_TEN_HIGH_COEFFICIENTS | CJK_HUNDRED_COEFFICIENTS);
						case _listStyle.LIST_STYLE_TYPE.SIMP_CHINESE_FORMAL:
							return createCJKCounter(value, '零壹贰叁肆伍陆柒捌玖', CHINESE_FORMAL_MULTIPLIERS, '负', '、', CJK_ZEROS | CJK_TEN_COEFFICIENTS | CJK_TEN_HIGH_COEFFICIENTS | CJK_HUNDRED_COEFFICIENTS);
						case _listStyle.LIST_STYLE_TYPE.JAPANESE_INFORMAL:
							return createCJKCounter(value, '〇一二三四五六七八九', '十百千万', JAPANESE_NEGATIVE, '、', 0);
						case _listStyle.LIST_STYLE_TYPE.JAPANESE_FORMAL:
							return createCJKCounter(value, '零壱弐参四伍六七八九', '拾百千万', JAPANESE_NEGATIVE, '、', CJK_ZEROS | CJK_TEN_COEFFICIENTS | CJK_TEN_HIGH_COEFFICIENTS);
						case _listStyle.LIST_STYLE_TYPE.KOREAN_HANGUL_FORMAL:
							return createCJKCounter(value, '영일이삼사오육칠팔구', '십백천만', KOREAN_NEGATIVE, ', ', CJK_ZEROS | CJK_TEN_COEFFICIENTS | CJK_TEN_HIGH_COEFFICIENTS);
						case _listStyle.LIST_STYLE_TYPE.KOREAN_HANJA_INFORMAL:
							return createCJKCounter(value, '零一二三四五六七八九', '十百千萬', KOREAN_NEGATIVE, ', ', 0);
						case _listStyle.LIST_STYLE_TYPE.KOREAN_HANJA_FORMAL:
							return createCJKCounter(value, '零壹貳參四五六七八九', '拾百千', KOREAN_NEGATIVE, ', ', CJK_ZEROS | CJK_TEN_COEFFICIENTS | CJK_TEN_HIGH_COEFFICIENTS);
						case _listStyle.LIST_STYLE_TYPE.DEVANAGARI:
							return createCounterStyleFromRange(value, 0x966, 0x96f, true);
						case _listStyle.LIST_STYLE_TYPE.GEORGIAN:
							return createAdditiveCounter(value, 1, 19999, GEORGIAN, _listStyle.LIST_STYLE_TYPE.DECIMAL);
						case _listStyle.LIST_STYLE_TYPE.GUJARATI:
							return createCounterStyleFromRange(value, 0xae6, 0xaef, true);
						case _listStyle.LIST_STYLE_TYPE.GURMUKHI:
							return createCounterStyleFromRange(value, 0xa66, 0xa6f, true);
						case _listStyle.LIST_STYLE_TYPE.HEBREW:
							return createAdditiveCounter(value, 1, 10999, HEBREW, _listStyle.LIST_STYLE_TYPE.DECIMAL);
						case _listStyle.LIST_STYLE_TYPE.HIRAGANA:
							return createCounterStyleFromSymbols(value, 'あいうえおかきくけこさしすせそたちつてとなにぬねのはひふへほまみむめもやゆよらりるれろわゐゑをん');
						case _listStyle.LIST_STYLE_TYPE.HIRAGANA_IROHA:
							return createCounterStyleFromSymbols(value, 'いろはにほへとちりぬるをわかよたれそつねならむうゐのおくやまけふこえてあさきゆめみしゑひもせす');
						case _listStyle.LIST_STYLE_TYPE.KANNADA:
							return createCounterStyleFromRange(value, 0xce6, 0xcef, true);
						case _listStyle.LIST_STYLE_TYPE.KATAKANA:
							return createCounterStyleFromSymbols(value, 'アイウエオカキクケコサシスセソタチツテトナニヌネノハヒフヘホマミムメモヤユヨラリルレロワヰヱヲン', '、');
						case _listStyle.LIST_STYLE_TYPE.KATAKANA_IROHA:
							return createCounterStyleFromSymbols(value, 'イロハニホヘトチリヌルヲワカヨタレソツネナラムウヰノオクヤマケフコエテアサキユメミシヱヒモセス', '、');
						case _listStyle.LIST_STYLE_TYPE.LAO:
							return createCounterStyleFromRange(value, 0xed0, 0xed9, true);
						case _listStyle.LIST_STYLE_TYPE.MONGOLIAN:
							return createCounterStyleFromRange(value, 0x1810, 0x1819, true);
						case _listStyle.LIST_STYLE_TYPE.MYANMAR:
							return createCounterStyleFromRange(value, 0x1040, 0x1049, true);
						case _listStyle.LIST_STYLE_TYPE.ORIYA:
							return createCounterStyleFromRange(value, 0xb66, 0xb6f, true);
						case _listStyle.LIST_STYLE_TYPE.PERSIAN:
							return createCounterStyleFromRange(value, 0x6f0, 0x6f9, true);
						case _listStyle.LIST_STYLE_TYPE.TAMIL:
							return createCounterStyleFromRange(value, 0xbe6, 0xbef, true);
						case _listStyle.LIST_STYLE_TYPE.TELUGU:
							return createCounterStyleFromRange(value, 0xc66, 0xc6f, true);
						case _listStyle.LIST_STYLE_TYPE.THAI:
							return createCounterStyleFromRange(value, 0xe50, 0xe59, true);
						case _listStyle.LIST_STYLE_TYPE.TIBETAN:
							return createCounterStyleFromRange(value, 0xf20, 0xf29, true);
						case _listStyle.LIST_STYLE_TYPE.DECIMAL:
						default:
							return createCounterStyleFromRange(value, 48, 57, true);
					}
				};
		/***/ }
		),
	/* 22 :: _Font */
	/***/ (
			function(module, exports, __webpack_require__) 
			{
				//g_objCommonUtil.log("modules[22 _Font].call");
				"use strict";


				Object.defineProperty(exports, "__esModule", {    value: true});
				exports.FontMetrics = undefined;

				//misty 2018.01.02 var _createClass = function () { function defineProperties(target, props) { for (var i = 0; i < props.length; i++) { var descriptor = props[i]; descriptor.enumerable = descriptor.enumerable || false; descriptor.configurable = true; if ("value" in descriptor) descriptor.writable = true; Object.defineProperty(target, descriptor.key, descriptor); } } return function (Constructor, protoProps, staticProps) { if (protoProps) defineProperties(Constructor.prototype, protoProps); if (staticProps) defineProperties(Constructor, staticProps); return Constructor; }; }();

				var _Util = __webpack_require__(3);

				//misty 2018.01.02 function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError("Cannot call a class as a function"); } }

				var SAMPLE_TEXT = 'Hidden Text';

				var FontMetrics = exports.FontMetrics = function () 
				{
					function FontMetrics(document) 
					{
						_classCallCheck(this, FontMetrics);

						this._data = {};
						this._document = document;
					}

					_createClass(FontMetrics, [
						{
							key: '_parseMetrics',
							value: function _parseMetrics(font)
							{
								var container = this._document.createElement('div');
								var img = this._document.createElement('img');
								var span = this._document.createElement('span');

								var body = this._document.body;
								if (!body) {
									throw new Error( true ? 'No document found for font metrics' : '');
								}

								container.style.visibility = 'hidden';
								container.style.fontFamily = font.fontFamily;
								container.style.fontSize = font.fontSize;
								container.style.margin = '0';
								container.style.padding = '0';

								body.appendChild(container);

								img.src = _Util.SMALL_IMAGE;
								img.width = 1;
								img.height = 1;

								img.style.margin = '0';
								img.style.padding = '0';
								img.style.verticalAlign = 'baseline';

								span.style.fontFamily = font.fontFamily;
								span.style.fontSize = font.fontSize;
								span.style.margin = '0';
								span.style.padding = '0';

								span.appendChild(this._document.createTextNode(SAMPLE_TEXT));
								container.appendChild(span);
								container.appendChild(img);
								var baseline = img.offsetTop - span.offsetTop + 2;

								container.removeChild(span);
								container.appendChild(this._document.createTextNode(SAMPLE_TEXT));

								container.style.lineHeight = 'normal';
								img.style.verticalAlign = 'super';

								var middle = img.offsetTop - container.offsetTop + 2;

								body.removeChild(container);

								return { baseline: baseline, middle: middle };
							}
						}, 
						{
							key: 'getMetrics',
							value: function getMetrics(font) 
							{
								var key = font.fontFamily + ' ' + font.fontSize;
								if (this._data[key] === undefined) 
									this._data[key] = this._parseMetrics(font);

								return this._data[key];
							}
						}
					]);
					return FontMetrics;
				}();
	/***/ }
	),
/* 23 :: _Proxy */
/***/ (
		function(module, exports, __webpack_require__) 
		{
			//g_objCommonUtil.log("modules[23 _Proxy].call");
			"use strict";


			Object.defineProperty(exports, "__esModule", {			value: true		});
			exports.Proxy = undefined;

			var _Feature = __webpack_require__(9);

			var _Feature2 = _interopRequireDefault(_Feature);

			//misty 2018.01.02 function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { default: obj }; }

			var Proxy = exports.Proxy = function Proxy(src, options) 
			{
				if (!options.proxy) 
					return Promise.reject( true ? 'No proxy defined' : null);

				var proxy = options.proxy;

				return new Promise(function (resolve, reject) 
				{
					var responseType = _Feature2.default.SUPPORT_CORS_XHR && _Feature2.default.SUPPORT_RESPONSE_TYPE ? 'blob' : 'text';
					var xhr = _Feature2.default.SUPPORT_CORS_XHR ? new XMLHttpRequest() : new XDomainRequest();
					xhr.onload = function () 
					{
						if (xhr instanceof XMLHttpRequest) 
						{
							if (xhr.status === 200) {
								if (responseType === 'text')
								{
									resolve(xhr.response);
								} 
								else
								{
									var reader = new FileReader();
									// $FlowFixMe
									reader.addEventListener('load', function ()
									{
										return resolve(reader.result);
									}, false);
									// $FlowFixMe
									reader.addEventListener('error', function (e) 
									{
										return reject(e);
									}, false);
									reader.readAsDataURL(xhr.response);
								}
							} 
							else 
							{
								reject( true ? 'Failed to proxy resource ' + src.substring(0, 256) + ' with status code ' + xhr.status : '');
							}
						} 
						else 
						{
							resolve(xhr.responseText);
						}
					};

					xhr.onerror = reject;
					xhr.open('GET', proxy + '?url=' + encodeURIComponent(src) + '&responseType=' + responseType);

					if (responseType !== 'text' && xhr instanceof XMLHttpRequest) 
						xhr.responseType = responseType;

					if (options.imageTimeout) 
					{
						var timeout = options.imageTimeout;
						xhr.timeout = timeout;
						xhr.ontimeout = function () 
						{
							return reject( true ? 'Timed out (' + timeout + 'ms) proxying ' + src.substring(0, 256) : '');
						};
					}

					xhr.send();
				});
			};
	/***/ }
	),
/* 24 */
/***/ (
		function(module, exports, __webpack_require__) 
		{
			//g_objCommonUtil.log("modules[24].call");
			"use strict";

			var _extends = Object.assign || function (target) 
											{
												for (var i = 1; i < arguments.length; i++) 
												{ 
													var source = arguments[i]; 
													for (var key in source) 
													{ 
														if (Object.prototype.hasOwnProperty.call(source, key)) 
														{ 
															target[key] = source[key]; 
														} 
													} 
												} return target; 
											};

			var _typeof = (typeof Symbol === "function" && typeof Symbol.iterator === "symbol") 
			? function (obj) { return typeof obj; } 
			: function (obj) 
			{ 
				return (obj && typeof Symbol === "function" && obj.constructor === Symbol && obj !== Symbol.prototype) ? "symbol" : typeof obj; 
			};

			var _CanvasRenderer = __webpack_require__(12);
			var _CanvasRenderer2 = _interopRequireDefault(_CanvasRenderer);
			var _Logger = __webpack_require__(13);
			var _Logger2 = _interopRequireDefault(_Logger);
			var _Window = __webpack_require__(25);
			var _Bounds = __webpack_require__(1);
		//misty 2018.01.02 function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { default: obj }; }

			var html2canvas = function html2canvas(element, conf) ////////MAIN_FUNC_START!!!
			{	
				//console.log("");			
				//if ((typeof console === 'undefined' ? 'undefined' : _typeof(console)) === 'object' && typeof console.log === 'function')
					//g_objCommonUtil.log('html2canvas ' + "1.0.0-alpha.5");// eslint-disable-next-line no-console
			
				var config = conf || {};
				var logger = new _Logger2.default((typeof config.logging === 'boolean') ? config.logging : true);

				if (true && typeof config.onrendered === 'function') 
					logger.error('onrendered option is deprecated, html2canvas returns a Promise with the canvas as the value');

				var ownerDocument = element.ownerDocument;
				if (!ownerDocument) 
					return Promise.reject('Provided element is not within a Document');

				var defaultView = ownerDocument.defaultView;
				var scrollX = defaultView.pageXOffset;
				var scrollY = defaultView.pageYOffset;				
				var tagName = element.tagName.toLowerCase();
				var isDocument =  tagName === DZE_TAG_HTML || tagName === DZE_TAG_BODY;

                //zoom 100% 기준으로 썸네일 위치/크기 계산 (UCDOC-2582, 2020-11-11)
                var scaleElem = ownerDocument.querySelector("div.dze_document_container") || ownerDocument.querySelector("div#totalPageContainer");
                var scrollElem = ownerDocument.querySelector("div#dze_document_main_container") || ownerDocument.querySelector("div#totalPageContainer");

                var oldScale = scaleElem ? scaleElem.style.transform : null;
                var oldScroll = scrollElem ? scrollElem.scrollTop : null;

				if(scaleElem) {
					scaleElem.style.transform = "scale(1)";
				}

				if(scrollElem) {
					scrollElem.scrollTop = 0;
				}

                //썸네일 크기/위치 계산
				var _ref = isDocument ? (0, _Bounds.parseDocumentSize)(ownerDocument) : (0, _Bounds.parseBounds)(element, scrollX, scrollY),
					width = _ref.width,
					height = _ref.height,
					left = _ref.left/*750*//*20mm*/,
					top = _ref.top;
			//	console.log("l(pgStX) = " +  left + " t(pgStY) = " + top + " r = " + (left+width) + " b = " + (top+height) + " w = " + width + " h = " + height );

			    if(scaleElem && oldScale !== null) {
			    	scaleElem.style.transform = oldScale;
				}

				if(scrollElem && oldScroll !== null) {
					scrollElem.scrollTop = oldScroll;
				}

				var nShotType = g_objOnefficeShot.getShotType();
				var nPgNum = g_objOnefficeShot.m_nCurPageNum;					
				var nTotalMargin = 0;//g_objOnefficeShot.m_pxTotalMargin;

				var nGap = 0;//g_objOnefficeShot.m_PortGap;//misty - 2018.07.11
				var bUseCORS = true;							
				
				var nScale = ( nShotType != SHOTTYPE.FIRSTPAGE_THUMB_SHOT) 
							? (defaultView.devicePixelRatio || 1)
							: 0.75 ;//objShot
			//	console.log("nPgNum = " + nPgNum + " nTotalMargin = " + nTotalMargin + " top = " + top  + " isDoc = " +  isDocument);	
			//	console.log("x = " +  left + " y = " + (top - nTotalMargin) + " scrollX[View.pageXOffset] = " + defaultView.pageXOffset + " scrollY[View.pageYOffset] = " + defaultView.pageYOffset);	
				var defaultOptions = {
					async: true,
					allowTaint: false,
					backgroundColor: '#ffffff',//white	//misty
					imageTimeout: THUMBNAIL_IMG_TIMEOUT,
					logging: true,
					proxy: null,//dzeEnvConfig.strPath_Image + 'ribbon/toolbar_btn_insert_picture.png',//null//misty - 2018.06.26
					removeContainer: true,
					bForeignObjectRendering: false,//misty - 2018.05.16
					scale: nScale,
					targetRenderer: new _CanvasRenderer2.default(config.canvas),//target.canvas = canvasEle
					useCORS: bUseCORS,
					x: left + nGap,			
					y: top - nTotalMargin ,	
					width: Math.ceil(width),
					height: Math.ceil(height),
					windowWidth: defaultView.innerWidth,
					windowHeight: defaultView.innerHeight,
					scrollX: defaultView.pageXOffset,
					scrollY: defaultView.pageYOffset
				};
			//	console.log("{html2canvas] Y =" + defaultOptions.y);
				defaultOptions.targetRenderer.canvas.setAttribute("pagenum",nPgNum);
				
				var whatOptions =  _extends({}, defaultOptions, config);
				var result = (0, _Window.renderElement/*renderElementFunc*/)(element, whatOptions, logger);/////1st OUT AFTER

				if (true) 
				{
					var tmp = result.catch(	function (e) 
												{
													logger.error(e);
													throw e;
												});

					if((g_objOnefficeShot.m_nCurPageNum==1) && (g_objOnefficeShot.m_nTotalPgNum == slideList.length))
					{
						duzon_http.hideLoading();	//misty - 20218.06.08
					}

					//g_ODrawManager.checkTime("1","html2canvas");
					return tmp;
				}

				return result;
			};

			html2canvas.CanvasRenderer = _CanvasRenderer2.default;

			module.exports = html2canvas;
	/***/ }
	),
/* 25 :: _Window */
/***/ (
		function(module, exports, __webpack_require__) 
		{
			//g_objCommonUtil.log("modules[25 _Window].call");
			"use strict";


			Object.defineProperty(exports, "__esModule", {  value: true});//exports._esModule :true;
			exports.renderElement = undefined;

			//misty 2018.01.02 var _slicedToArray = function () { function sliceIterator(arr, i) { var _arr = []; var _n = true; var _d = false; var _e = undefined; try { for (var _i = arr[Symbol.iterator](), _s; !(_n = (_s = _i.next()).done); _n = true) { _arr.push(_s.value); if (i && _arr.length === i) break; } } catch (err) { _d = true; _e = err; } finally { try { if (!_n && _i["return"]) _i["return"](); } finally { if (_d) throw _e; } } return _arr; } return function (arr, i) { if (Array.isArray(arr)) { return arr; } else if (Symbol.iterator in Object(arr)) { return sliceIterator(arr, i); } else { throw new TypeError("Invalid attempt to destructure non-iterable instance"); } }; }();

			var _Logger = __webpack_require__(13);
			var _Logger2 = _interopRequireDefault(_Logger);
			var m_NodeParser = __webpack_require__(26);
			var _Renderer = __webpack_require__(46);
			var _Renderer2 = _interopRequireDefault(_Renderer);
			var _ForeignObjectRenderer = __webpack_require__(20);
			var _ForeignObjectRenderer2 = _interopRequireDefault(_ForeignObjectRenderer);
			var _Feature = __webpack_require__(9);
			var _Feature2 = _interopRequireDefault(_Feature);
			var _Bounds = __webpack_require__(1);
			var m_Clone = __webpack_require__(49);
			var _Font = __webpack_require__(22);
			var _Color = __webpack_require__(0);
			var _Color2 = _interopRequireDefault(_Color);

			//misty 2018.01.02 function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { default: obj }; }

			var renderElement = exports.renderElement = function renderElementFunc(targetEle, options, logger) 
			{
				var targetOwnerDoc = targetEle.ownerDocument;

				//html2canvas-container iFrame obj width , height setting 
				var windowBounds = new _Bounds.Bounds(options.scrollX, options.scrollY, options.windowWidth, options.windowHeight);
				//console.log("scr_rc l=" + windowBounds.left + " t=" + windowBounds.top+ " r=" + (windowBounds.left+windowBounds.width)
				//			 + " b=" + (windowBounds.top+windowBounds.height) );
				
				//misty - 2018.04.02 // http://www.w3.org/TR/css3-background/#special-backgrounds
				var docBgColor = getComputedStyle(targetOwnerDoc.documentElement).backgroundColor;
				var BodyBgColor = getComputedStyle(targetOwnerDoc.body).backgroundColor;
				
				var documentBackgroundColor = targetOwnerDoc.documentElement ? new _Color2.default(docBgColor) : _Color.TRANSPARENT;
				var bodyBackgroundColor = targetOwnerDoc.body ? new _Color2.default(BodyBgColor) : _Color.TRANSPARENT;

				var test1 = (options.backgroundColor ? new _Color2.default(options.backgroundColor) : null);
				var test2 = (bodyBackgroundColor.isTransparent() ? test1 : bodyBackgroundColor);
				var test3 = (documentBackgroundColor.isTransparent() ? test2 : documentBackgroundColor);
				var backgroundColor = ((targetEle === targetOwnerDoc.documentElement) ? test3 : test1);
				backgroundColor = g_objOnefficeShot.m_PageColor; 

				//g_ODrawManager.checkTime("1","renderElement");
				return (options.bForeignObjectRendering ? // $FlowFixMe
				_Feature2.default.SUPPORT_FOREIGNOBJECT_DRAWING : 
				Promise.resolve(false)).then(function(supportForeignObject)
												{
													return afterCloneDocFunc(supportForeignObject,logger,targetOwnerDoc,options,backgroundColor,
														targetEle,renderElementFunc,windowBounds);
												});
						//testFunc(false,targetEle, options, logger,targetOwnerDoc,renderElementFunc,backgroundColor,windowBounds));
			};

			var testFunc = function(supportForeignObject,targetEle, options, logger,targetOwnerDoc,renderElementFunc,backgroundColor,windowBounds)
			{
				//Promise.resolve(false))/* 1st OUT */
				//	.then(	
					//function (supportForeignObject) //★★★★★★
						{									
							return afterCloneDocFunc(supportForeignObject,logger,targetOwnerDoc,options,backgroundColor,
								targetEle,renderElementFunc,windowBounds);
						}
				//	)
			};

			var afterCloneDocFunc = function(supportForeignObject,logger,targetOwnerDoc,options,backgroundColor,
				targetEle,renderElementFunc,windowBounds)
			{
				//g_ODrawManager.checkTime("1","afterCloneDocFunc");
				return supportForeignObject ? 
				function (cloner) 
				{
					if (true) 
					{
						logger.log('Document cloned, using foreignObject rendering');
					}

					return cloner.inlineFonts(targetOwnerDoc)
							.then(	function () 
									{
										return cloner.resourceLoader.ready();
									})
									.then(	function () 
											{
												var renderer = new _ForeignObjectRenderer2.default(cloner.documentElement);
												return renderer.render(	{	backgroundColor: backgroundColor,
																			logger: logger,
																			scale: options.scale,
																			x: options.x,
																			y: options.y,
																			width: options.width,
																			height: options.height,
																			windowWidth: options.windowWidth,
																			windowHeight: options.windowHeight,
																			scrollX: options.scrollX,
																			scrollY: options.scrollY
																		});
											});
				}(new m_Clone.DocumentCloner(targetEle, options, logger, true, renderElementFunc)) //if supportForeignObject == true
				: (0, m_Clone.cloneWindow)(targetOwnerDoc, windowBounds, targetEle, options, logger, renderElementFunc)//if supportForeignObject = false /* 2nd OUT */
						.then(	function (_ref) 
								{//iframeLoad-Promise.resolve([cloneIframeContainer, cloner.clonedReferenceElement/*targetEle*/, cloner.resourceLoader]) :
									return stackFunc(_ref,logger,options,backgroundColor);
								});
			};

			var stackFunc = function(_ref,logger,options,backgroundColor)
			{
				var _ref2 = _slicedToArray(_ref, 3),    
				container = _ref2[0]/*html2canvas-container:iframe#tmpHtml2Canvas*/,    
				clonedTargetEle = _ref2[1]/*cloneTargetEle*/,
				resourceLoader = _ref2[2]/*resourceLoader*/;//_slicedToArray  pair로 targetEle,와 htmlcanvas, cloner.resourceLoader
				var nPgNum = clonedTargetEle.getAttribute("pagenum");				
				var test = (0, _Bounds.parseBounds)(clonedTargetEle, 0, 0)			;//
			//	console.log("stackFunc Start PgNum = " + nPgNum);
				//g_ODrawManager.checkTime("1","stackFunc");

				if (true) 
				{
					logger.log('Document cloned, using computed rendering');
				}

				var stack = (0, m_NodeParser.NodeParser)(clonedTargetEle, resourceLoader, logger);//???★★★★
				var clonedDocument = clonedTargetEle.ownerDocument;

				if (backgroundColor === stack.targetContainer.style.background.backgroundColor) 
					stack.targetContainer.style.background.backgroundColor = _Color.TRANSPARENT;
				//callee [linenum:7254] _this5.logger.log('Finished loading ' + imagesNode.length + ' imagesNode', imagesNode);
				//0 :  img#imgTmpLoadHandler1, 1:img#imgloadHandler0 , 
				return resourceLoader.ready().then(	function (imageStore/*(key , imgNodes )*/) //new ResourceStore(keys, images);
													{				
														return pointRenderFunc(imageStore,clonedDocument,logger,backgroundColor,options,stack,container);
													});
			};

			var pointRenderFunc = function(imageStore,clonedDocument,logger,backgroundColor,options,stack,container)
			{
			//	console.log("pointRenderFunc Start nPgNum = " + options.targetRenderer.canvas.getAttribute("pagenum"));
				//g_ODrawManager.checkTime("1","pointRenderFunc");
				var fontMetrics = new _Font.FontMetrics(clonedDocument);//data & cloneDocument
				if (true) 
				{
					logger.log('Starting renderer');
				}

				var renderOptions = {
					backgroundColor: backgroundColor,
					fontMetrics: fontMetrics,
					imageStore: imageStore,
					logger: logger,
					scale: options.scale,
					x: options.x,
					y: options.y,
					width: options.width,
					height: options.height
				};
			
				//console.log("[RenderOption] x=" + renderOptions.x + " y=" +renderOptions.y);
				if (Array.isArray(options.targetRenderer)) 
				{
					return Promise.all(options.targetRenderer.map(function (targetRenderer)
					{
						var renderer = new _Renderer2.default(targetRenderer, renderOptions);
						return renderer.render(stack);
					}));
				} 
				else 
				{
					var renderer = new _Renderer2.default(options.targetRenderer, renderOptions); //bitmap
					var canvasPromise = renderer.render(stack);//CREATE-CANVAS-BITMAP & TRANSLATE //misty - 2018.06.11 '// txtrendering
					if (options.removeContainer === true)
					{
						if (container/*tmpHtml2Canvas*/.parentNode/*body*/) 
						{
							container.parentNode.removeChild(container);
						} 
						else if (true) 
						{
							logger.log('Cannot detach cloned iframe as it is not in the DOM anymore');
						}
					}
					//g_ODrawManager.checkTime("1","pointRenderFunc End");
					return canvasPromise;
				}
			};
	/***/ }
	),
/* 26 :: m_NodeParser */
/***/ (
		function(module, exports, __webpack_require__) 
		{
			//g_objCommonUtil.log("modules[26 m_NodeParser].call");
			"use strict";

			Object.defineProperty(exports, "__esModule", {    value: true});
			exports.NodeParser = undefined;
			var _StackingContext = __webpack_require__(27);
			var _StackingContext2 = _interopRequireDefault(_StackingContext);
			var _NodeContainer = __webpack_require__(4);
			var _NodeContainer2 = _interopRequireDefault(_NodeContainer);
			var _TextContainer = __webpack_require__(8);
			var _TextContainer2 = _interopRequireDefault(_TextContainer);
			var _Input = __webpack_require__(18);
			var _ListItem = __webpack_require__(21);
			//misty 2018.01.02 function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { default: obj }; }

			var NodeParser = exports.NodeParser = function NodeParser(node, resourceLoader, logger) 
			{
				if (true) 
					logger.log('Starting node parsing');

			//	console.log("NodeParser Start nPgNum = " + node.getAttribute("pagenum"));	
				
				var index = 0;
				var targetContainer = new _NodeContainer2.default(node, null, resourceLoader, index++);
				var stack = new _StackingContext2.default(targetContainer, null, true);

				parseNodeTree(node, targetContainer, stack, resourceLoader, index);

				if (true) 
					logger.log('Finished parsing node tree');

				//g_ODrawManager.checkTime("1","NodeParser");	
				
				return stack;
			};

			var IGNORED_NODE_NAMES = ['SCRIPT', 'HEAD', 'TITLE', 'OBJECT', 'BR', 'OPTION'];
			var IGNORED_NODE_ID = ['divTableMiniMenu', 'dze_idx_oneffice_slide_controller', 'dze_idx_oneffice_show_menu_container','doc_thumbnail_viewer'];
			var IGNORED_NODE_CLASSNAMES = ['slidePageNumLayer', 'btn_show_slide_ctl_spacer'];

			var parseNodeTree = function parseNodeTree(node, parent, stack, resourceLoader, index/*nLevel*/) 
			{
				//console.log("[parseNodeTree] node.tagName :: " + node.tagName + " nLevelDepth (index): " + index);
				//하위 Tag가 200개 이상이면 해당 Tag는 무시하자.
        if (true && index > 200) 
				{
					//throw new Error('Recursion error while parsing node tree');
					return;
				}

				for (var childNode = node.firstChild, nextNode; childNode; childNode = nextNode) 
				{
					//console.log("childNode.nodeValue = " + childNode.nodeValue + " nodeType = " + childNode.nodeType);
					nextNode = childNode.nextSibling;
					var defaultView = childNode.ownerDocument.defaultView;
					if (childNode instanceof defaultView.Text || childNode instanceof Text || defaultView.parent && childNode instanceof defaultView.parent.Text) 
					{
						if (childNode.data.trim().length > 0)
						{
							var charSetArray = _TextContainer2.default.fromTextNode(childNode, parent);
							parent.childNodes.push(charSetArray);
						}
					} //what case??????? TextNode??
					else if (childNode instanceof defaultView.HTMLElement || childNode instanceof HTMLElement || 
						defaultView.parent /*window*/ && childNode instanceof defaultView.parent.HTMLElement) 
					{
						if( (IGNORED_NODE_NAMES.indexOf(childNode.nodeName) === -1) &&  //['SCRIPT', 'HEAD', 'TITLE', 'OBJECT', 'BR', 'OPTION'];
							(IGNORED_NODE_ID.indexOf(childNode.id) === -1) &&
							(IGNORED_NODE_CLASSNAMES.indexOf(childNode.className) === -1) &&
							childNode.text !== "")//misty 2018.06.05
						{
							var container = new _NodeContainer2.default(childNode, parent, resourceLoader,index++/*nLevel?*/ );
							if (container.isVisible())
							{
								var tagName = childNode.tagName.toLowerCase();
								//console.log("[parseNodeTree-HTMLElement] childNode tagName :: " + tagName + " nLevelDepth (index): " + index);
								if (tagName === DZE_TAG_INPUT) 
								{
									// $FlowFixMe
									(0, _Input.inlineInputElement)(childNode, container);
								} else if (tagName === DZE_TAG_TEXTAREA)
								{
									// $FlowFixMe
									(0, _Input.inlineTextAreaElement)(childNode, container);
								} else if (tagName === DZE_TAG_SELECT)
								{
									// $FlowFixMe
									(0, _Input.inlineSelectElement)(childNode, container);
								} else if (container.style.listStyle && container.style.listStyle.listStyleType !== 'none')
								{
									(0, _ListItem.inlineListItemElement)(childNode, container, resourceLoader);
								}

								var SHOULD_TRAVERSE_CHILDREN = tagName !== DZE_TAG_TEXTAREA;
								var bTreatAsRealStackingContext = createsRealStackingContext(container, childNode);
								if (bTreatAsRealStackingContext || createsStackingContext(container))
								{
									// for bTreatAsRealStackingContext:false, any positioned descendants and descendants
									// which actually create a new stacking context should be considered part of the parent stacking context
									var parentStack = bTreatAsRealStackingContext || container.isPositioned() ? stack.getRealParentStackingContext() : stack;
									var childStack = new _StackingContext2.default(container, parentStack, bTreatAsRealStackingContext);
									parentStack.contexts.push(childStack);
									if (SHOULD_TRAVERSE_CHILDREN)
									{
										parseNodeTree(childNode, container, childStack, resourceLoader, index);
									}
								}					
								else
								{
									stack.children.push(container);
									if (SHOULD_TRAVERSE_CHILDREN)
									{
										parseNodeTree(childNode, container, stack, resourceLoader, index);
									}
								}
							}
						}
					} //HTMLElement??
					else if (childNode instanceof defaultView.SVGSVGElement || childNode instanceof SVGSVGElement || defaultView.parent && childNode instanceof defaultView.parent.SVGSVGElement) 
					{
						var _container = new _NodeContainer2.default(childNode, parent, resourceLoader, index++);
						var _bTreatAsRealStackingContext = createsRealStackingContext(_container, childNode);
						if (_bTreatAsRealStackingContext || createsStackingContext(_container)) 
						{
							// for bTreatAsRealStackingContext:false, any positioned descendants and descendants
							// which actually create a new stacking context should be considered part of the parent stacking context
							var _parentStack = _bTreatAsRealStackingContext || _container.isPositioned() ? stack.getRealParentStackingContext() : stack;
							var _childStack = new _StackingContext2.default(_container, _parentStack, _bTreatAsRealStackingContext);
							_parentStack.contexts.push(_childStack);
						} 
						else {
							stack.children.push(_container);
						}
					} //SVGElement??
				}
			};

			var createsRealStackingContext = function createsRealStackingContext(container, node) 
			{
				return container.isRootElement() || 
					container.isPositionedWithZIndex() || 
					container.style.opacity < 1 || 
					container.isTransformed() || 
					isBodyWithTransparentRoot(container, node);
			};

			var createsStackingContext = function createsStackingContext(container) 
			{
				return container.isPositioned() || 
					container.isFloating();
			};

			var isBodyWithTransparentRoot = function isBodyWithTransparentRoot(container, node)
			{
			//misty - 2018.05.09	
			//if(node.nodeName.toLowerCase() === 'img' && 
			//((container.parent.style.background.backgroundColor != 'white') || (container.parent.style.background.backgroundColor !=  Color([/*r*/255, 255/*g*/,255/*b*/ , null])))
				//
				return node.nodeName === 'BODY' && container.parent instanceof _NodeContainer2.default && container.parent.style.background.backgroundColor.isTransparent();
			};
/***/ }
	),
/* 27 :: _StackingContext */
/***/ (
		function(module, exports, __webpack_require__) 
			{
			//g_objCommonUtil.log("modules[27 _StackingContext].call");
			"use strict";


			Object.defineProperty(exports, "__esModule", {    value: true});

			//misty 2018.01.02 var _createClass = function () { function defineProperties(target, props) { for (var i = 0; i < props.length; i++) { var descriptor = props[i]; descriptor.enumerable = descriptor.enumerable || false; descriptor.configurable = true; if ("value" in descriptor) descriptor.writable = true; Object.defineProperty(target, descriptor.key, descriptor); } } return function (Constructor, protoProps, staticProps) { if (protoProps) defineProperties(Constructor.prototype, protoProps); if (staticProps) defineProperties(Constructor, staticProps); return Constructor; }; }();

			var _NodeContainer = __webpack_require__(4);

			var _NodeContainer2 = _interopRequireDefault(_NodeContainer);

			var _position = __webpack_require__(16);

			//misty 2018.01.02 function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { default: obj }; }

			//misty 2018.01.02 function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError("Cannot call a class as a function"); } }

			var StackingContext = function () 
			{
				function StackingContext(targetContainer, parent, bTreatAsRealStackingContext) 
				{
					_classCallCheck(this, StackingContext);

					this.targetContainer = targetContainer;
					this.parent = parent;
					this.contexts = [];
					this.children = [];
					this.bTreatAsRealStackingContext = bTreatAsRealStackingContext;
				}

				_createClass(StackingContext, [
					{
						key: 'getOpacity',
						value: function getOpacity() {
							return this.parent ? this.targetContainer.style.opacity * this.parent.getOpacity() : this.targetContainer.style.opacity;
						}
					}, 
					{
						key: 'getRealParentStackingContext',
						value: function getRealParentStackingContext() {
							return !this.parent || this.bTreatAsRealStackingContext ? this : this.parent.getRealParentStackingContext();
					}
				}]);

				return StackingContext;
			}();

			exports.default = StackingContext;
	/***/ }
	),
/* 28 :: _Size , _Size2 */
/***/ (
		function(module, exports, __webpack_require__) 
			{
			//g_objCommonUtil.log("modules[28 _Size].call");
			"use strict";

			Object.defineProperty(exports, "__esModule", {    value: true});

			//misty 2018.01.02 function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError("Cannot call a class as a function"); } }

			var Size = function Size(width, height) 
			{
				_classCallCheck(this, Size);

				this.width = width;
				this.height = height;
			};

			exports.default = Size;
/***/ }
	),
/* 29 :: _BezierCurve, _BezierCurve2 */
/***/ (
		function(module, exports, __webpack_require__) 
		{
		//g_objCommonUtil.log("modules[29 _BezierCurve].call");
		"use strict";


		Object.defineProperty(exports, "__esModule", {    value: true});

		//misty 2018.01.02 var _createClass = function () { function defineProperties(target, props) { for (var i = 0; i < props.length; i++) { var descriptor = props[i]; descriptor.enumerable = descriptor.enumerable || false; descriptor.configurable = true; if ("value" in descriptor) descriptor.writable = true; Object.defineProperty(target, descriptor.key, descriptor); } } return function (Constructor, protoProps, staticProps) { if (protoProps) defineProperties(Constructor.prototype, protoProps); if (staticProps) defineProperties(Constructor, staticProps); return Constructor; }; }();

		var _Path = __webpack_require__(6);

		var _Vector = __webpack_require__(7);

		var _Vector2 = _interopRequireDefault(_Vector);

		//misty 2018.01.02 function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { default: obj }; }

		//misty 2018.01.02 function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError("Cannot call a class as a function"); } }

		var lerp = function lerp(a, b, t) 
		{
			return new _Vector2.default(a.x + (b.x - a.x) * t, a.y + (b.y - a.y) * t);
		};

		var BezierCurve = function () 
		{
			function BezierCurve(start, startControl, endControl, end) 
			{
				_classCallCheck(this, BezierCurve);

				this.type = _Path.PATH.BEZIER_CURVE;
				this.start = start;
				this.startControl = startControl;
				this.endControl = endControl;
				this.end = end;
			}

			_createClass(BezierCurve, [
				{
					key: 'subdivide',
					value: function subdivide(t, firstHalf) 
					{
						var ab = lerp(this.start, this.startControl, t);
						var bc = lerp(this.startControl, this.endControl, t);
						var cd = lerp(this.endControl, this.end, t);
						var abbc = lerp(ab, bc, t);
						var bccd = lerp(bc, cd, t);
						var dest = lerp(abbc, bccd, t);
						return firstHalf ? new BezierCurve(this.start, ab, abbc, dest) : new BezierCurve(dest, bccd, cd, this.end);
					}
				}, 
				{
					key: 'reverse',
					value: function reverse() 
					{
						return new BezierCurve(this.end, this.endControl, this.startControl, this.start);
					}
				}
			]);

			return BezierCurve;
		}();

		exports.default = BezierCurve;
/***/ }
	),
/* 30 :: _borderRadius */
/***/ (
		function(module, exports, __webpack_require__) 
			{
			//g_objCommonUtil.log("modules[30 _borderRadius].call");
			"use strict";


			Object.defineProperty(exports, "__esModule", {    value: true});
			exports.parseBorderRadius = undefined;

			//misty 2018.01.02 var _slicedToArray = function () { function sliceIterator(arr, i) { var _arr = []; var _n = true; var _d = false; var _e = undefined; try { for (var _i = arr[Symbol.iterator](), _s; !(_n = (_s = _i.next()).done); _n = true) { _arr.push(_s.value); if (i && _arr.length === i) break; } } catch (err) { _d = true; _e = err; } finally { try { if (!_n && _i["return"]) _i["return"](); } finally { if (_d) throw _e; } } return _arr; } return function (arr, i) { if (Array.isArray(arr)) { return arr; } else if (Symbol.iterator in Object(arr)) { return sliceIterator(arr, i); } else { throw new TypeError("Invalid attempt to destructure non-iterable instance"); } }; }();

			var _Length = __webpack_require__(2);

			var _Length2 = _interopRequireDefault(_Length);

			//misty 2018.01.02 function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { default: obj }; }

			var SIDES = ['top-left', 'top-right', 'bottom-right', 'bottom-left'];

			var parseBorderRadius = exports.parseBorderRadius = function parseBorderRadius(style) 
			{
				return SIDES.map(function (side) 
				{
					var value = style.getPropertyValue('border-' + side + '-radius');

					var _value$split$map = value.split(' ').map(_Length2.default.create),
						_value$split$map2 = _slicedToArray(_value$split$map, 2),
						horizontal = _value$split$map2[0],
						vertical = _value$split$map2[1];

					return typeof vertical === 'undefined' ? [horizontal, horizontal] : [horizontal, vertical];
				});
			};
	/***/ }
	),
/* 31 :: _display */
/***/ (
		function(module, exports, __webpack_require__) 
			{
			//g_objCommonUtil.log("modules[31 _display].call");
			"use strict";


			Object.defineProperty(exports, "__esModule", {    value: true});
			var DISPLAY = exports.DISPLAY = {
				NONE: 1 << 0,
				BLOCK: 1 << 1,
				INLINE: 1 << 2,
				RUN_IN: 1 << 3,
				FLOW: 1 << 4,
				FLOW_ROOT: 1 << 5,
				TABLE: 1 << 6,
				FLEX: 1 << 7,
				GRID: 1 << 8,
				RUBY: 1 << 9,
				SUBGRID: 1 << 10,
				LIST_ITEM: 1 << 11,
				TABLE_ROW_GROUP: 1 << 12,
				TABLE_HEADER_GROUP: 1 << 13,
				TABLE_FOOTER_GROUP: 1 << 14,
				TABLE_ROW: 1 << 15,
				TABLE_CELL: 1 << 16,
				TABLE_COLUMN_GROUP: 1 << 17,
				TABLE_COLUMN: 1 << 18,
				TABLE_CAPTION: 1 << 19,
				RUBY_BASE: 1 << 20,
				RUBY_TEXT: 1 << 21,
				RUBY_BASE_CONTAINER: 1 << 22,
				RUBY_TEXT_CONTAINER: 1 << 23,
				CONTENTS: 1 << 24,
				INLINE_BLOCK: 1 << 25,
				INLINE_LIST_ITEM: 1 << 26,
				INLINE_TABLE: 1 << 27,
				INLINE_FLEX: 1 << 28,
				INLINE_GRID: 1 << 29
			};

			var parseDisplayValue = function parseDisplayValue(display) 
			{
				switch (display) {
					case 'block':
						return DISPLAY.BLOCK;
					case 'inline':
						return DISPLAY.INLINE;
					case 'run-in':
						return DISPLAY.RUN_IN;
					case 'flow':
						return DISPLAY.FLOW;
					case 'flow-root':
						return DISPLAY.FLOW_ROOT;
					case 'table':
						return DISPLAY.TABLE;
					case 'flex':
						return DISPLAY.FLEX;
					case 'grid':
						return DISPLAY.GRID;
					case 'ruby':
						return DISPLAY.RUBY;
					case 'subgrid':
						return DISPLAY.SUBGRID;
					case 'list-item':
						return DISPLAY.LIST_ITEM;
					case 'table-row-group':
						return DISPLAY.TABLE_ROW_GROUP;
					case 'table-header-group':
						return DISPLAY.TABLE_HEADER_GROUP;
					case 'table-footer-group':
						return DISPLAY.TABLE_FOOTER_GROUP;
					case 'table-row':
						return DISPLAY.TABLE_ROW;
					case 'table-cell':
						return DISPLAY.TABLE_CELL;
					case 'table-column-group':
						return DISPLAY.TABLE_COLUMN_GROUP;
					case 'table-column':
						return DISPLAY.TABLE_COLUMN;
					case 'table-caption':
						return DISPLAY.TABLE_CAPTION;
					case 'ruby-base':
						return DISPLAY.RUBY_BASE;
					case 'ruby-text':
						return DISPLAY.RUBY_TEXT;
					case 'ruby-base-container':
						return DISPLAY.RUBY_BASE_CONTAINER;
					case 'ruby-text-container':
						return DISPLAY.RUBY_TEXT_CONTAINER;
					case 'contents':
						return DISPLAY.CONTENTS;
					case 'inline-block':
						return DISPLAY.INLINE_BLOCK;
					case 'inline-list-item':
						return DISPLAY.INLINE_LIST_ITEM;
					case 'inline-table':
						return DISPLAY.INLINE_TABLE;
					case 'inline-flex':
						return DISPLAY.INLINE_FLEX;
					case 'inline-grid':
						return DISPLAY.INLINE_GRID;
				}

				return DISPLAY.NONE;
			};

			var setDisplayBit = function setDisplayBit(bit, display) 
			{
				return bit | parseDisplayValue(display);
			};

			var parseDisplay = exports.parseDisplay = function parseDisplay(display) 
			{
				return display.split(' ').reduce(setDisplayBit, 0);
			};
	/***/ }
	),
/* 32 :: _float */
/***/ (
		function(module, exports, __webpack_require__) 
			{
			//g_objCommonUtil.log("modules[32 _float].call");
			"use strict";


			Object.defineProperty(exports, "__esModule", {    value: true});
			var FLOAT = exports.FLOAT = {
				NONE: 0,
				LEFT: 1,
				RIGHT: 2,
				INLINE_START: 3,
				INLINE_END: 4
			};

			var parseCSSFloat = exports.parseCSSFloat = function parseCSSFloat(float) 
			{
				switch (float) 
				{
					case 'left':
						return FLOAT.LEFT;
					case 'right':
						return FLOAT.RIGHT;
					case 'inline-start':
						return FLOAT.INLINE_START;
					case 'inline-end':
						return FLOAT.INLINE_END;
				}
				return FLOAT.NONE;
			};

			/***/ }),
			/* 33 :: _font */
			/***/ (function(module, exports, __webpack_require__) 
			{
			//g_objCommonUtil.log("modules[33 _font].call");
			"use strict";


			Object.defineProperty(exports, "__esModule", {    value: true});


			var parseFontWeight = function parseFontWeight(weight) 
			{
				switch (weight) 
				{
					case 'normal':
						return 400;
					case 'bold':
						return 700;
				}

				var value = parseInt(weight, 10);
				return isNaN(value) ? 400 : value;
			};

			var parseFont = exports.parseFont = function parseFont(style) 
			{
				var fontFamily = style.fontFamily;
				var fontSize = style.fontSize;
				var fontStyle = style.fontStyle;
				var fontVariant = style.fontVariant;
				var fontWeight = parseFontWeight(style.fontWeight);

				return {
					fontFamily: fontFamily,
					fontSize: fontSize,
					fontStyle: fontStyle,
					fontVariant: fontVariant,
					fontWeight: fontWeight
				};
			};

			/***/ }),
			/* 34 :: _letterSpacing */
			/***/ (function(module, exports, __webpack_require__) 
			{
			//g_objCommonUtil.log("modules[34 _letterSpacing].call");
			"use strict";


			Object.defineProperty(exports, "__esModule", {    value: true});
			var parseLetterSpacing = exports.parseLetterSpacing = function parseLetterSpacing(letterSpacing) 
			{
				if (letterSpacing === 'normal') 
					return 0;

				var value = parseFloat(letterSpacing);
				return isNaN(value) ? 0 : value;
			};
/***/ }
	),
/* 35 :: _margin */
/***/ (
		function(module, exports, __webpack_require__) 
		{
		//g_objCommonUtil.log("modules[35 _margin].call");
		"use strict";


		Object.defineProperty(exports, "__esModule", {    value: true});
		exports.parseMargin = undefined;

		var _Length = __webpack_require__(2);

		var _Length2 = _interopRequireDefault(_Length);

		//misty 2018.01.02 function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { default: obj }; }

		var SIDES = ['top', 'right', 'bottom', 'left'];

		var parseMargin = exports.parseMargin = function parseMargin(style) 
		{
			return SIDES.map(function (side) {
				return new _Length2.default(style.getPropertyValue('margin-' + side));
			});
		};
/***/ }
	),
/* 36 :: _overflow */
/***/ (
		function(module, exports, __webpack_require__) 
			{
			//g_objCommonUtil.log("modules[36 _overflow].call");
			"use strict";

			Object.defineProperty(exports, "__esModule", {    value: true});
			var OVERFLOW = exports.OVERFLOW = {
				VISIBLE: 0,
				HIDDEN: 1,
				SCROLL: 2,
				AUTO: 3
			};

			var parseOverflow = exports.parseOverflow = function parseOverflow(overflow) 
			{
				switch (overflow) 
				{
					case 'hidden':
						return OVERFLOW.HIDDEN;
					case 'scroll':
						return OVERFLOW.SCROLL;
					case 'auto':
						return OVERFLOW.AUTO;
					case 'visible':
					default:
						return OVERFLOW.VISIBLE;
				}
			};
/***/ }
	),
/* 37 :: _textShadow */
/***/ (
		function(module, exports, __webpack_require__) 
			{
			//g_objCommonUtil.log("modules[37 _textShadow].call");
			"use strict";


			Object.defineProperty(exports, "__esModule", {    value: true});
			exports.parseTextShadow = undefined;

			var _Color = __webpack_require__(0);

			var _Color2 = _interopRequireDefault(_Color);

			//misty 2018.01.02 function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { default: obj }; }

			var NUMBER = /^([+-]|\d|\.)$/i;

			var parseTextShadow = exports.parseTextShadow = function parseTextShadow(textShadow) 
			{
				if (textShadow === 'none' || typeof textShadow !== 'string') 
					return null;

				var currentValue = '';
				var isLength = false;
				var values = [];
				var shadows = [];
				var numParens = 0;
				var color = null;

				var appendValue = function appendValue() 
				{
					if (currentValue.length) 
					{
						if (isLength) 
						{
							values.push(parseFloat(currentValue));
						} 
						else 
						{
							color = new _Color2.default(currentValue);
						}
					}
					isLength = false;
					currentValue = '';
				};

				var appendShadow = function appendShadow() 
				{
					if (values.length && color !== null) 
					{
						shadows.push(
								{
							color: color,
							offsetX: values[0] || 0,
							offsetY: values[1] || 0,
							blur: values[2] || 0
						});
					}
					values.splice(0, values.length);
					color = null;
				};

				for (var i = 0; i < textShadow.length; i++)
				{
					var c = textShadow[i];
					switch (c) 
					{
						case '(':
							currentValue += c;
							numParens++;
							break;
						case ')':
							currentValue += c;
							numParens--;
							break;
						case ',':
							if (numParens === 0) 
							{
								appendValue();
								appendShadow();
							} 
							else 
							{
								currentValue += c;
							}
							break;
						case ' ':
							if (numParens === 0) 
							{
								appendValue();
							} 
							else 
							{
								currentValue += c;
							}
							break;
						default:
							if (currentValue.length === 0 && NUMBER.test(c))
							{
								isLength = true;
							}
							currentValue += c;
					}
				}

				appendValue();
				appendShadow();

				if (shadows.length === 0) 
					return null;

				return shadows;
			};
/***/ }
	),
/* 38 :: _transform */
/***/ (
		function(module, exports, __webpack_require__) 
			{
			//g_objCommonUtil.log("modules[38 _transform].call");
			"use strict";

			Object.defineProperty(exports, "__esModule", {    value: true});
			exports.parseTransform = undefined;

			var _Length = __webpack_require__(2);

			var _Length2 = _interopRequireDefault(_Length);

			//misty 2018.01.02 function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { default: obj }; }

			var toFloat = function toFloat(s) 
			{
				return parseFloat(s.trim());
			};

			var MATRIX = /(matrix|matrix3d)\((.+)\)/;

			var parseTransform = exports.parseTransform = function parseTransform(style) 
			{
				var transform = parseTransformMatrix(style.transform || style.webkitTransform || style.mozTransform ||
				// $FlowFixMe
				style.msTransform ||
				// $FlowFixMe
				style.oTransform);
				if (transform === null)
					return null;
				return {
					transform: transform,
					transformOrigin: parseTransformOrigin(style.transformOrigin || style.webkitTransformOrigin || style.mozTransformOrigin ||
					// $FlowFixMe
					style.msTransformOrigin ||
					// $FlowFixMe
					style.oTransformOrigin)
				};
			};

			// $FlowFixMe
			var parseTransformOrigin = function parseTransformOrigin(origin) 
			{
				if (typeof origin !== 'string') 
				{
					var v = new _Length2.default('0');
					return [v, v];
				}
				var values = origin.split(' ').map(_Length2.default.create);
				return [values[0], values[1]];
			};

			// $FlowFixMe
			var parseTransformMatrix = function parseTransformMatrix(transform) 
			{
				if (transform === 'none' || typeof transform !== 'string') 
				{
					return null;
				}

				var match = transform.match(MATRIX);
				if (match) 
				{
					if (match[1] === 'matrix') 
					{
						var matrix = match[2].split(',').map(toFloat);
						return [matrix[0], matrix[1], matrix[2], matrix[3], matrix[4], matrix[5]];
					} 
					else 
					{
						var matrix3d = match[2].split(',').map(toFloat);
						return [matrix3d[0], matrix3d[1], matrix3d[4], matrix3d[5], matrix3d[12], matrix3d[13]];
					}
				}
				return null;
			};
/***/ }
	),
/* 39 :: _visibility */
/***/ (
		function(module, exports, __webpack_require__) 
		{
		//g_objCommonUtil.log("modules[39 _visibility].call");
		"use strict";

			Object.defineProperty(exports, "__esModule", {    value: true});
			var VISIBILITY = exports.VISIBILITY = {
				VISIBLE: 0,
				HIDDEN: 1,
				COLLAPSE: 2
			};

			var parseVisibility = exports.parseVisibility = function parseVisibility(visibility) 
			{
				switch (visibility) 
				{
					case 'hidden':
						return VISIBILITY.HIDDEN;
					case 'collapse':
						return VISIBILITY.COLLAPSE;
					case 'visible':
					default:
						return VISIBILITY.VISIBLE;
				}
			};
	/***/ }
	),
/* 40 :: _zIndex */
/***/ (
		function(module, exports, __webpack_require__) 
			{
			//g_objCommonUtil.log("modules[40 _zIndex].call");
			"use strict";


			Object.defineProperty(exports, "__esModule", {    value: true});
			var parseZIndex = exports.parseZIndex = function parseZIndex(zIndex) 
			{
				var auto = zIndex === 'auto';
				return 	{
					auto: auto,
					order: auto ? 0 : parseInt(zIndex, 10)
				};
			};
/***/ }
	),
/* 41 :: _punycode */
/***/ (
			function(module, exports, __webpack_require__) 
			{
				//g_objCommonUtil.log("modules[41 _punycode].call");
				/* WEBPACK VAR INJECTION */(
												function(module, global) 
												{
													var __WEBPACK_AMD_DEFINE_RESULT__;/*! https://mths.be/punycode v1.4.1 by @mathias */
													;	(
															function(root) 
															{/** Detect free variables */
																var freeExports = typeof exports == 'object' && exports &&
																	!exports.nodeType && exports;
																var freeModule = typeof module == 'object' && module &&
																	!module.nodeType && module;
																var freeGlobal = typeof global == 'object' && global;
																if (freeGlobal.global === freeGlobal ||
																	freeGlobal.window === freeGlobal ||
																	freeGlobal.self === freeGlobal	) 
																		root = freeGlobal;

																/*** The `punycode` object.		 * @name punycode		 * @type Object		 */
																var punycode,
																/** Highest positive signed 32-bit float value */
																maxInt = 2147483647, // aka. 0x7FFFFFFF or 2^31-1
																/** Bootstring parameters */
																base = 36, tMin = 1,tMax = 26,
																skew = 38,damp = 700,
																initialBias = 72,initialN = 128, // 0x80
																delimiter = '-', // '\x2D'
																/** Regular expressions */
																regexPunycode = /^xn--/,
																regexNonASCII = /[^\x20-\x7E]/, // unprintable ASCII chars + non-ASCII chars
																regexSeparators = /[\x2E\u3002\uFF0E\uFF61]/g, // RFC 3490 separators

																errors = 	{'overflow': 'Overflow: input needs wider integers to process',														/** Error messages */
																	'not-basic': 'Illegal input >= 0x80 (not a basic code point)',
																	'invalid-input': 'Invalid input'},

																/** Convenience shortcuts */
																baseMinusTMin = base - tMin,
																floor = Math.floor,
																stringFromCharCode = String.fromCharCode,
																key;/** Temporary variable */
																/*--------------------------------------------------------------------------*/

																/** * A generic error utility function.
																 * @private * @param {String} type The error type.* @returns {Error} Throws a `RangeError` with the applicable error message.*/
																function error(type) 
																{
																	throw new RangeError(errors[type]);
																}

																/** * A generic `Array#map` utility function.
																 * @private* @param {Array} array The array to iterate over.
																 * @param {Function} callback The function that gets called for every array
																 * item. * @returns {Array} A new array of values returned by the callback function. */
																function map(array, fn) 
																{
																	var length = array.length;
																	var result = [];
																	while (length--) 
																		result[length] = fn(array[length]);															
																	return result;
																}

																/** * A simple `Array#map`-like wrapper to work with domain name strings or email
																 * addresses. * @private * @param {String} domain The domain name or email address.
																 * @param {Function} callback The function that gets called for every * character.
																 * @returns {Array} A new string of characters returned by the callback * function. */
																function mapDomain(string, fn) 
																{
																	var parts = string.split('@');
																	var result = '';
																	if (parts.length > 1) 
																	{	// In email addresses, only the domain name should be punycoded. Leave
																		// the local part (i.e. everything up to `@`) intact.
																		result = parts[0] + '@';
																		string = parts[1];
																	}
																	// Avoid `split(regex)` for IE8 compatibility. See #17.
																	string = string.replace(regexSeparators, '\x2E');
																	var labels = string.split('.');
																	var encoded = map(labels, fn).join('.');
																	return result + encoded;
																}
																/*** Creates an array containing the numeric code points of each Unicode * character in the string. While JavaScript uses UCS-2 internally,
																 * this function will convert a pair of surrogate halves (each of which * UCS-2 exposes as separate characters) into a single code point,
																 * matching UTF-16. * @see `punycode.ucs2.encode`
																 * @see <https://mathiasbynens.be/notes/javascript-encoding>
																 * @memberOf punycode.ucs2 * @name decode * @param {String} string The Unicode input string (UCS-2).
																 * @returns {Array} The new array of code points. */
																function ucs2decode(string) 
																{
																	var output = [],counter = 0,length = string.length,value,extra;
																	while (counter < length) 
																	{
																		value = string.charCodeAt(counter++);
																		if (value >= 0xD800 && value <= 0xDBFF && counter < length) 
																		{
																			// high surrogate, and there is a next character
																			extra = string.charCodeAt(counter++);
																			if ((extra & 0xFC00) == 0xDC00)  // low surrogate
																				output.push(((value & 0x3FF) << 10) + (extra & 0x3FF) + 0x10000);
																			else 
																			{
																				// unmatched surrogate; only append this code unit, in case the next
																				// code unit is the high surrogate of a surrogate pair
																				output.push(value);
																				counter--;
																			}
																		}
																		else 
																			output.push(value);
																	}
																	return output;
																}

																/** Creates a string based on an array of numeric code points.
																 * @see `punycode.ucs2.decode` * @memberOf punycode.ucs2
																 * @name encode * @param {Array} codePoints The array of numeric code points.
																 * @returns {String} The new Unicode string (UCS-2). */
																function ucs2encode(array) 
																{
																	return map(array, function(value) 
																	{
																		var output = '';
																		if (value > 0xFFFF) 
																		{
																			value -= 0x10000;
																			output += stringFromCharCode(value >>> 10 & 0x3FF | 0xD800);
																			value = 0xDC00 | value & 0x3FF;
																		}
																		output += stringFromCharCode(value);
																		return output;
																	}).join('');
																}

																/** * Converts a basic code point into a digit/integer.
																 * @see `digitToBasic()` * @private * @param {Number} codePoint The basic numeric code point value.
																 * @returns {Number} The numeric value of a basic code point (for use in * representing integers) in the range `0` to `base - 1`, or `base` if
																 * the code point does not represent a value. */
																function basicToDigit(codePoint) 
																{
																	if (codePoint - 48 < 10) 
																		return codePoint - 22;
																	if (codePoint - 65 < 26) 
																		return codePoint - 65;
																	if (codePoint - 97 < 26) 
																		return codePoint - 97;
																	return base;
																}

																/** * Converts a digit/integer into a basic code point.
																 * @see `basicToDigit()` * @private * @param {Number} digit The numeric value of a basic code point.
																 * @returns {Number} The basic code point whose value (when used for * representing integers) is `digit`, which needs to be in the range
																 * `0` to `base - 1`. If `flag` is non-zero, the uppercase form is * used; else, the lowercase form is used. The behavior is undefined
																 * if `flag` is non-zero and `digit` has no uppercase form. */
																function digitToBasic(digit, flag) 
																{
																	//  0..25 map to ASCII a..z or A..Z
																	// 26..35 map to ASCII 0..9
																	return digit + 22 + 75 * (digit < 26) - ((flag != 0) << 5);
																}

																/** * Bias adaptation function as per section 3.4 of RFC 3492.
																 * https://tools.ietf.org/html/rfc3492#section-3.4 * @private	 */
																function adapt(delta, numPoints, firstTime) 
																{
																	var k = 0;
																	delta = firstTime ? floor(delta / damp) : delta >> 1;
																	delta += floor(delta / numPoints);
																	for (/* no initialization */; delta > baseMinusTMin * tMax >> 1; k += base) 
																		delta = floor(delta / baseMinusTMin);
																	return floor(k + (baseMinusTMin + 1) * delta / (delta + skew));
																}

																/** * Converts a Punycode string of ASCII-only symbols to a string of Unicode
																 * symbols. * @memberOf punycode * @param {String} input The Punycode string of ASCII-only symbols.
																 * @returns {String} The resulting string of Unicode symbols. */
																function decode(input) 
																{
																	// Don't use UCS-2
																	var output = [],inputLength = input.length,
																		out,i = 0,n = initialN,bias = initialBias,basic,
																		j,index,oldi,w,k,digit,t,/** Cached calculation results */baseMinusT;

																	// Handle the basic code points: let `basic` be the number of input code
																	// points before the last delimiter, or `0` if there is none, then copy
																	// the first basic code points to the output.

																	basic = input.lastIndexOf(delimiter);
																	if (basic < 0) 
																		basic = 0;

																	for (j = 0; j < basic; ++j) 
																	{	// if it's not a basic code point
																		if (input.charCodeAt(j) >= 0x80) 
																			error('not-basic');
																		output.push(input.charCodeAt(j));
																	}

																	// Main decoding loop: start just after the last delimiter if any basic code
																	// points were copied; start at the beginning otherwise.
																	for (index = basic > 0 ? basic + 1 : 0; index < inputLength; /* no final expression */) 
																	{	// `index` is the index of the next character to be consumed.
																		// Decode a generalized variable-length integer into `delta`,
																		// which gets added to `i`. The overflow checking is easier
																		// if we increase `i` as we go, then subtract off its starting
																		// value at the end to obtain `delta`.
																		for (oldi = i, w = 1, k = base; /* no condition */; k += base) 
																		{
																			if (index >= inputLength) 
																				error('invalid-input');

																			digit = basicToDigit(input.charCodeAt(index++));

																			if (digit >= base || digit > floor((maxInt - i) / w)) 
																				error('overflow');

																			i += digit * w;
																			t = k <= bias ? tMin : (k >= bias + tMax ? tMax : k - bias);

																			if (digit < t) 
																				break;

																			baseMinusT = base - t;
																			if (w > floor(maxInt / baseMinusT)) 
																				error('overflow');

																			w *= baseMinusT;
																		}

																		out = output.length + 1;
																		bias = adapt(i - oldi, out, oldi == 0);

																		// `i` was supposed to wrap around from `out` to `0`,		// incrementing `n` each time, so we'll fix that now:
																		if (floor(i / out) > maxInt - n) 
																			error('overflow');

																		n += floor(i / out);
																		i %= out;

																		output.splice(i++, 0, n);// Insert `n` at position `i` of the output
																	}
																	return ucs2encode(output);
																}

																/** * Converts a string of Unicode symbols (e.g. a domain name label) to a* Punycode string of ASCII-only symbols.
																 * @memberOf punycode * @param {String} input The string of Unicode symbols. * @returns {String} The resulting Punycode string of ASCII-only symbols. */
																function encode(input) 
																{
																	var n,
																		delta,
																		handledCPCount,
																		basicLength,
																		bias,
																		j,
																		m,
																		q,
																		k,
																		t,
																		currentValue,
																		output = [],
																		/** `inputLength` will hold the number of code points in `input`. */
																		inputLength,
																		/** Cached calculation results */
																		handledCPCountPlusOne,
																		baseMinusT,
																		qMinusT;

																	input = ucs2decode(input);// Convert the input in UCS-2 to Unicode
																	inputLength = input.length;															// Cache the length

																	// Initialize the state
																	n = initialN;
																	delta = 0;
																	bias = initialBias;

																	// Handle the basic code points
																	for (j = 0; j < inputLength; ++j) 
																	{
																		currentValue = input[j];
																		if (currentValue < 0x80) 
																		{
																			output.push(stringFromCharCode(currentValue));
																		}
																	}

																	handledCPCount = basicLength = output.length;

																	// `handledCPCount` is the number of code points that have been handled;
																	// `basicLength` is the number of basic code points.

																	// Finish the basic string - if it is not empty - with a delimiter
																	if (basicLength) 
																		output.push(delimiter);															

																	// Main encoding loop:
																	while (handledCPCount < inputLength) 
																	{	// All non-basic code points < n have been handled already. Find the next
																		// larger one:
																		for (m = maxInt, j = 0; j < inputLength; ++j) 
																		{
																			currentValue = input[j];
																			if (currentValue >= n && currentValue < m)
																				m = currentValue;																	
																		}

																		// Increase `delta` enough to advance the decoder's <n,i> state to <m,0>,
																		// but guard against overflow
																		handledCPCountPlusOne = handledCPCount + 1;
																		if (m - n > floor((maxInt - delta) / handledCPCountPlusOne))
																			error('overflow');

																		delta += (m - n) * handledCPCountPlusOne;
																		n = m;

																		for (j = 0; j < inputLength; ++j) 
																		{
																			currentValue = input[j];

																			if (currentValue < n && ++delta > maxInt) 
																				error('overflow');

																			if (currentValue == n)
																			{
																				// Represent delta as a generalized variable-length integer
																				for (q = delta, k = base; /* no condition */; k += base)
																				{
																					t = k <= bias ? tMin : (k >= bias + tMax ? tMax : k - bias);
																					if (q < t) 
																					{
																						break;
																					}
																					qMinusT = q - t;
																					baseMinusT = base - t;
																					output.push(	stringFromCharCode(digitToBasic(t + qMinusT % baseMinusT, 0)));
																					q = floor(qMinusT / baseMinusT);
																				}

																				output.push(stringFromCharCode(digitToBasic(q, 0)));
																				bias = adapt(delta, handledCPCountPlusOne, handledCPCount == basicLength);
																				delta = 0;
																				++handledCPCount;
																			}
																		}
																		++delta;
																		++n;
																	}
																	return output.join('');
																}

																/**
																 * Converts a Punycode string representing a domain name or an email address
																 * to Unicode. Only the Punycoded parts of the input will be converted, i.e.
																 * it doesn't matter if you call it on a string that has already been
																 * converted to Unicode.
																 * @memberOf punycode
																 * @param {String} input The Punycoded domain name or email address to
																 * convert to Unicode.
																 * @returns {String} The Unicode representation of the given Punycode
																 * string.
																 */
																function toUnicode(input)
																{
																	return mapDomain(input, function(string) 
																	{
																		return regexPunycode.test(string)
																			? decode(string.slice(4).toLowerCase())
																			: string;
																	});
																}

																/**
																 * Converts a Unicode string representing a domain name or an email address to
																 * Punycode. Only the non-ASCII parts of the domain name will be converted,
																 * i.e. it doesn't matter if you call it with a domain that's already in
																 * ASCII.
																 * @memberOf punycode
																 * @param {String} input The domain name or email address to convert, as a
																 * Unicode string.
																 * @returns {String} The Punycode representation of the given domain name or
																 * email address.
																 */
																function toASCII(input) 
																{
																	return mapDomain(input, function(string)
																	{
																		return regexNonASCII.test(string)
																			? 'xn--' + encode(string)
																			: string;
																	});
																}

																/*--------------------------------------------------------------------------*/

																/** Define the public API */
																punycode = 
																{
																	/**
																	 * A string representing the current Punycode.js version number.
																	 * @memberOf punycode
																	 * @type String
																	 */
																	'version': '1.4.1',
																	/**
																	 * An object of methods to convert from JavaScript's internal character
																	 * representation (UCS-2) to Unicode code points, and back.
																	 * @see <https://mathiasbynens.be/notes/javascript-encoding>
																	 * @memberOf punycode
																	 * @type Object
																	 */
																	'ucs2': 
																	{
																		'decode': ucs2decode,
																		'encode': ucs2encode
																	},
																	'decode': decode,
																	'encode': encode,
																	'toASCII': toASCII,
																	'toUnicode': toUnicode
																};

																/** Expose `punycode` */
																// Some AMD build optimizers, like r.js, check for specific condition patterns
																// like the following:
																if (true) 
																{
																	!(__WEBPACK_AMD_DEFINE_RESULT__ = 
																			function() 
																			{
																				return punycode;
																			}.call(exports, __webpack_require__, exports, module),
																			__WEBPACK_AMD_DEFINE_RESULT__ !== undefined && (module.exports = __WEBPACK_AMD_DEFINE_RESULT__));
																} 
																else if (freeExports && freeModule) 
																{
																	if (module.exports == freeExports) 
																		freeModule.exports = punycode;													// in Node.js, io.js, or RingoJS v0.8.0+
																	else 
																	{		// in Narwhal or RingoJS v0.7.0-
																		for (key in punycode) 
																		{
																			punycode.hasOwnProperty(key) && (freeExports[key] = punycode[key]);
																		}
																	}
																}
																else // in Rhino or a web browser
																	root.punycode = punycode;														
															}(this)
														);												
						/* WEBPACK VAR INJECTION */}.call(exports, __webpack_require__(42)(module), __webpack_require__(43))
												)

	/***/	}
		),
/* 42 */
/***/ (
		function(module, exports) 
		{
			//g_objCommonUtil.log("modules[42].call");
			module.exports = function(module) 
			{
				if(!module.webpackPolyfill) 
				{
					module.deprecate = function() {};
					module.paths = [];
					// module.parent = undefined by default
					if(!module.children) 
						module.children = [];

					Object.defineProperty(module, "loaded", 
					{
						enumerable: true,
						get: function() 
						{
							return module.loaded;
						}
					});

					Object.defineProperty(module, "id",
					{
						enumerable: true,
						get: function() 
						{
							return module.id;
						}
					});

					module.webpackPolyfill = 1;
				}
				return module;
			};
	/***/ }
	),
/* 43 */
/***/ (
			function(module, exports) 
			{
				//g_objCommonUtil.log("modules[43].call");
				var g;

				// This works in non-strict mode
					g = (
						function() 
						{
							return this;
						}
					)();

					try 
					{
						// This works if eval is allowed (see CSP)
						g = g || Function("return this")() || (1,eval)("this");
					} 
					catch(e) 
					{
						// This works if the window reference is available
						if(typeof window === "object")
							g = window;
					}

				// g can still be undefined, but nothing to do about it...
				// We return undefined, instead of nothing here, so it's
				// easier to handle this case. if(!global) { ...}

				module.exports = g;
/***/		 }
	),
/* 44  :: _Circle , _Circle2 */
/***/ (
			function(module, exports, __webpack_require__) 
			{	
				//g_objCommonUtil.log("modules[44 _Circle].call");
				"use strict";

				Object.defineProperty(exports, "__esModule", {    value: true});

				var _Path = __webpack_require__(6);

				//misty 2018.01.02 function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError("Cannot call a class as a function"); } }

				var Circle = function Circle(x, y, radius) 
				{
					_classCallCheck(this, Circle);

					this.type = _Path.PATH.CIRCLE;
					this.x = x;
					this.y = y;
					this.radius = radius;
					if (true) {
						if (isNaN(x)) 
							dalert('Invalid x value given for Circle');
						if (isNaN(y)) 
							dalert('Invalid y value given for Circle');
						if (isNaN(radius)) 
							dalert('Invalid radius value given for Circle');					
					}
				};

				exports.default = Circle;
	/***/ }
	),
/* 45 :: _Unicode */
/***/ (
			function(module, exports, __webpack_require__) 
			{
				//g_objCommonUtil.log("modules[45 _Unicode].call");
				"use strict";


				Object.defineProperty(exports, "__esModule", {    value: true});
				var fromCodePoint = exports.fromCodePoint = function fromCodePoint() 
				{
					if (String.fromCodePoint) 
						return String.fromCodePoint.apply(String, arguments);

					var length = arguments.length;
					if (!length) 
						return '';

					var codeUnits = [];

					var index = -1;
					var result = '';
					while (++index < length) 
					{
						var codePoint = arguments.length <= index ? undefined : arguments[index];
						if (codePoint <= 0xffff) {
							codeUnits.push(codePoint);
						} else 
						{
							codePoint -= 0x10000;
							codeUnits.push((codePoint >> 10) + 0xd800, codePoint % 0x400 + 0xdc00);
						}
						if (index + 1 === length || codeUnits.length > 0x4000) 
						{
							result += String.fromCharCode.apply(String, codeUnits);
							codeUnits.length = 0;
						}
					}
					return result;
				};

/***/	 }
	),
/* 46 :: _Renderer , _Renderer2 */
/***/ (
		function(module, exports, __webpack_require__) 
		{
			//g_objCommonUtil.log("modules[46 _Renderer].call");
			"use strict";


			Object.defineProperty(exports, "__esModule", {    value: true});

			//misty 2018.01.02 var _slicedToArray = function () { function sliceIterator(arr, i) { var _arr = []; var _n = true; var _d = false; var _e = undefined; try { for (var _i = arr[Symbol.iterator](), _s; !(_n = (_s = _i.next()).done); _n = true) { _arr.push(_s.value); if (i && _arr.length === i) break; } } catch (err) { _d = true; _e = err; } finally { try { if (!_n && _i["return"]) _i["return"](); } finally { if (_d) throw _e; } } return _arr; } return function (arr, i) { if (Array.isArray(arr)) { return arr; } else if (Symbol.iterator in Object(arr)) { return sliceIterator(arr, i); } else { throw new TypeError("Invalid attempt to destructure non-iterable instance"); } }; }();

			//misty 2018.01.02 var _createClass = function () { function defineProperties(target, props) { for (var i = 0; i < props.length; i++) { var descriptor = props[i]; descriptor.enumerable = descriptor.enumerable || false; descriptor.configurable = true; if ("value" in descriptor) descriptor.writable = true; Object.defineProperty(target, descriptor.key, descriptor); } } return function (Constructor, protoProps, staticProps) { if (protoProps) defineProperties(Constructor.prototype, protoProps); if (staticProps) defineProperties(Constructor, staticProps); return Constructor; }; }();

			var _Bounds = __webpack_require__(1);

			var _Font = __webpack_require__(22);

			var _Gradient = __webpack_require__(47);

			var _TextContainer = __webpack_require__(8);

			var _TextContainer2 = _interopRequireDefault(_TextContainer);

			var _background = __webpack_require__(5);

			var _border = __webpack_require__(11);

			//misty 2018.01.02 function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { default: obj }; }

			//misty 2018.01.02 function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError("Cannot call a class as a function"); } }

			var Renderer = function () 
			{
				function Renderer(targetRenderer, options) 
				{
					_classCallCheck(this, Renderer);

					this.targetRenderer = targetRenderer;
					this.options = options;
					targetRenderer.render(options);
				}

				_createClass(Renderer, [
					{
						key: 'renderNode',
						value: function renderNode(container) 
						{
							if (container.isVisible()) 
							{
								//console.log("[renderNode]  conainer tagName = " + container.tagName + " className = " + container.name);
								this.renderNodeBackgroundAndBorders(container);
								this.renderNodeContent(container);
							}
						}
					}, 
					{
						key: 'renderNodeContent',
						value: function renderNodeContent(container) 
						{
							var _this = this;

							var callback = function callback() 
							{
								if (container.childNodes.length) 
								{
									container.childNodes.forEach(function (child)
									{
										if (child instanceof _TextContainer2.default) 
										{
											var style = child.parent.style;
											_this.targetRenderer.renderTextNode(child.bounds, style.color, style.font, style.textDecoration, style.textShadow);
										}
										else 
										{
											_this.targetRenderer.drawShape(child, container.style.color);
										}
									});
								}
								
								if (container.image) 
								{
								//	console.log("Renerder::renderNodeContent [" + container.tagName + "]");
									var _image = _this.options.imageStore.get(container.image);
									if (_image) 
									{
										var contentBox = (0, _Bounds.calculateContentBox)(container.bounds, container.style.padding, container.style.border);
								//		console.log("[renderNodeContent] l = " + contentBox.left + " t = " + contentBox.top +
											//	" r = " + (contentBox.left + contentBox.width) + " b = " + (contentBox.top + contentBox.height));												
										var _width = typeof _image.width === 'number' && _image.width > 0 ? _image.width : contentBox.width;
										var _height = typeof _image.height === 'number' && _image.height > 0 ? _image.height : contentBox.height;
									//	console.log("[renderNodeContent] REAL_IMG_SIZE w = " + _width + " h = " + _height );
										if (_width > 0 && _height > 0) 
										{
											_this.targetRenderer.clip([(0, _Bounds.calculatePaddingBoxPath)(container.curvedBounds)], 
																function () 
																	{
																		_this.targetRenderer.drawImage(_image, new _Bounds.Bounds(0, 0, _width, _height), contentBox);
																	});
										}
									}
								}
							};
							//g_objCommonUtil.log("renderNodeContent["+container.tagName+"]");
							var paths = container.getClipPaths();
							if (paths.length) 
								this.targetRenderer.clip(paths, callback);
							 else 
								callback();            
						}
					}, 
					{
						key: 'renderNodeBackgroundAndBorders',
						value: function renderNodeBackgroundAndBorders(container) 
						{
							var _this2 = this;

							var HAS_BACKGROUND = !container.style.background.backgroundColor.isTransparent() || container.style.background.backgroundImage.length;

							var renderableBorders = container.style.border.filter(
								function (border) 
								{
									return border.borderStyle !== _border.BORDER_STYLE.NONE && !border.borderColor.isTransparent();
								});

							var callback = function callback() 
							{
								//console.log("[renderNodeBackgroundAndBorders::callback] bgPaintArea = ");
								var backgroundPaintingArea = (0, _background.calculateBackgroungPaintingArea)(container.curvedBounds, container.style.background.backgroundClip);								
								
								if (HAS_BACKGROUND) 
								{
									_this2.targetRenderer.clip([ backgroundPaintingArea], 
														function () 
														{
														//	console.log("[renderNodeBackgroundAndBorders::callback] container.name = " + container.name + " container.tagName = " + container.tagName + " container.className = " + container.className   );
															if (!container.style.background.backgroundColor.isTransparent()) 
															{
																_this2.targetRenderer.fill(container.style.background.backgroundColor);
															}

															if(container.style.background.backgroundImage.length)//misty - 2018.06.19
																_this2.renderBackgroundImage(container);
														});
								}

								renderableBorders.forEach(	function (border, side) 
															{
																_this2.renderBorder(border, side, container.curvedBounds);
															});
							};

							if (HAS_BACKGROUND || renderableBorders.length) 
							{
								var paths = container.parent ? container.parent.getClipPaths() : [];
								if (paths.length) 
									this.targetRenderer.clip(paths, callback);
								else 
									callback();								
							}
						}
					}, 
					{
						key: 'renderBackgroundImage',
						value: function renderBackgroundImage(container) {
							var _this3 = this;

							container.style.background.backgroundImage.slice(0).reverse().forEach(
								function (backgroundImage) 
								{
								if (backgroundImage.source.method === 'url' && backgroundImage.source.args.length) 
								{
								//	console.log("[renderBackgroundImg] orgSrc = " + container.style.background.backgroundImage[0].source.args[0]);//misty - 2018.07.02
									_this3.renderBackgroundRepeat(container, backgroundImage);
								}
								else if (/gradient/i.test(backgroundImage.source.method)) 
									_this3.renderBackgroundGradient(container, backgroundImage);								
							});
						}
					}, 
					{
						key: 'renderBackgroundRepeat',
						value: function renderBackgroundRepeat(container, background) {
							var image = this.options.imageStore.get(background.source.args[0]);							
							if (image && container.bounds.width && container.bounds.height) //misty - 2018.07.02 node 가 잘못 만들어 진 경우, width & height 체크하여 draw
							{
							//	console.log("[renderBackgroundRepeat]:: pgNum = " + image.getAttribute("pagenum"));
								var backgroundPositioningArea = (0, _background.calculateBackgroungPositioningArea)(container.style.background.backgroundOrigin, container.bounds, container.style.padding, container.style.border);
							//	console.log("[renderBackgroundRepeat]:: bgPos l = " + backgroundPositioningArea.left +
							//												" t = " + backgroundPositioningArea.top + 
							//												" r = " + ( backgroundPositioningArea.left + backgroundPositioningArea.width) +
							//												" b = " + ( backgroundPositioningArea.top + backgroundPositioningArea.height) );
								var backgroundImageSize = (0, _background.calculateBackgroundSize)(background, image, backgroundPositioningArea);
							//	console.log("[renderBackgroundRepeat]:: bgSize w = " + backgroundImageSize.width + " h = " + backgroundImageSize.height );
								var position = (0, _background.calculateBackgroundPosition)(background.position, backgroundImageSize, backgroundPositioningArea);//??
							//	console.log("[renderBackgroundRepeat]:: objPos x = " + position.x + " y = " + position.y);
							
								var _path = (0, _background.calculateBackgroundRepeatPath)(background, position, backgroundImageSize, backgroundPositioningArea, container.bounds);

								var _offsetX = Math.round(backgroundPositioningArea.left + position.x);
								var _offsetY = Math.round(backgroundPositioningArea.top + position.y);
							//	console.log("[renderBackgroundRepeat]:: _offsetX = " + _offsetX + " _offsetY = " + _offsetY);
								this.targetRenderer.renderRepeat(_path, image, backgroundImageSize, _offsetX, _offsetY);
							}
						}
					},
					{
						key: 'renderBackgroundGradient',
						value: function renderBackgroundGradient(container, background) {
							var backgroundPositioningArea = (0, _background.calculateBackgroungPositioningArea)(container.style.background.backgroundOrigin, container.bounds, container.style.padding, container.style.border);
							var backgroundImageSize = (0, _background.calculateGradientBackgroundSize)(background, backgroundPositioningArea);
							var position = (0, _background.calculateBackgroundPosition)(background.position, backgroundImageSize, backgroundPositioningArea);
							var gradientBounds = new _Bounds.Bounds(Math.round(backgroundPositioningArea.left + position.x), Math.round(backgroundPositioningArea.top + position.y), backgroundImageSize.width, backgroundImageSize.height);

							var gradient = (0, _Gradient.parseGradient)(container, background.source, gradientBounds);
							if (gradient) {
								switch (gradient.type) {
									case _Gradient.GRADIENT_TYPE.LINEAR_GRADIENT:
										// $FlowFixMe
										this.targetRenderer.renderLinearGradient(gradientBounds, gradient);
										break;
									case _Gradient.GRADIENT_TYPE.RADIAL_GRADIENT:
										// $FlowFixMe
										this.targetRenderer.renderRadialGradient(gradientBounds, gradient);
										break;
								}
							}
						}
					},
					{
						key: 'renderBorder',
						value: function renderBorder(border, side, curvePoints) {
							this.targetRenderer.drawShape((0, _Bounds.parsePathForBorder)(curvePoints, side), border.borderColor);
						}
					}, 
					{
						key: 'renderStack',
						value: function renderStack(stack) 
						{
							var _this4 = this;

							var targetEle = stack.targetContainer;
							var strName = targetEle.name;
							var strTagName = targetEle.tagName;
							var strClassName = targetEle.className;
							var fOpacity = targetEle.style.opacity;
							var bVisible = stack.targetContainer.isVisible();
						//	console.log("renderStack strTagName =  "  + strTagName + " strName = " + strName + 
						//	" strClassName = " + strClassName + " fOpacity = " + fOpacity + " gAlpha = " + this.targetRenderer.ctx.globalAlpha + " bVisible = " + bVisible);
							

							if (bVisible) 
							{
								var _opacity = stack.getOpacity();
								if (_opacity !== this._opacity) 
								{
									this.targetRenderer.setOpacity(stack.getOpacity());
									this._opacity = _opacity;
								}
						//		console.log(this.targetRenderer.ctx.globalAlpha);
						//		console.log("l = " + targetEle.bounds.left + " t = " + targetEle.bounds.top + " w = " + targetEle.bounds.width + " h " + targetEle.bounds.height);	
								var _transform = stack.targetContainer.style.transform;
								if (_transform !== null) 
								{
									this.targetRenderer.transform(stack.targetContainer.bounds.left + _transform.transformOrigin[0].value, 
										stack.targetContainer.bounds.top + _transform.transformOrigin[1].value, _transform.transform, 
										function () 
										{
											return _this4.renderStackContent(stack);
										});
								} 
								else 
								{
									this.renderStackContent(stack);
								}
							}
						}
					}, 
					{
						key: 'renderStackContent',
						value: function renderStackContent(stack) 
						{// [negativeZIndex, zeroOrAutoZIndexOrTransformedOrOpacity, positiveZIndex, nonPositionedFloats, nonPositionedInlineLevel];
							var _splitStackingContext = splitStackingContexts(stack),
								_splitStackingContext2 = _slicedToArray(_splitStackingContext, 5),
								negativeZIndex = _splitStackingContext2[0/*negativeZIndex*/],
								zeroOrAutoZIndexOrTransformedOrOpacity = _splitStackingContext2[1/*zeroOrAutoZIndexOrTransformedOrOpacity*/],								
								positiveZIndex = _splitStackingContext2[2/*positiveZIndex*/],
								nonPositionedFloats = _splitStackingContext2[3/*nonPositionedFloats*/],
								nonPositionedInlineLevel = _splitStackingContext2[4/*nonPositionedInlineLevel*/];

							//console.log("renderStackContent zeroOrAutoZIndexOrTransformedOrOpacity");
						//	console.log(zeroOrAutoZIndexOrTransformedOrOpacity);
							var _splitDescendants = splitDescendants(stack),//inline vs block
								_splitDescendants2 = _slicedToArray(_splitDescendants, 2),
								inlineLevel = _splitDescendants2[0],
								nonInlineLevel = _splitDescendants2[1];

								
				/*****************************************************************************************misty - 2018.05.10
				*									onDraw : Main												*
				******************************************************************************************/

							// https://www.w3.org/TR/css-position-3/#painting-order
							// 1. the background and borders of the element forming the stacking context.
							this.renderNodeBackgroundAndBorders(stack.targetContainer);

							// 2. the child stacking contexts with negative stack levels (most negative first).
							negativeZIndex.sort(sortByZIndex).forEach(this.renderStack, this);

							// 3. For all its in-flow, non-positioned, block-level descendants in tree order:
							this.renderNodeContent(stack.targetContainer);
							nonInlineLevel.forEach(this.renderNode, this);

							// 4. All non-positioned floating descendants, in tree order. For each one of these,
							// treat the element as if it created a new stacking context, but any positioned descendants and descendants
							// which actually create a new stacking context should be considered part of the parent stacking context,
							// not this new one.
							nonPositionedFloats.forEach(this.renderStack, this);

							// 5. the in-flow, inline-level, non-positioned descendants, including inline tables and inline blocks.
							nonPositionedInlineLevel.forEach(this.renderStack, this);
							inlineLevel.forEach(this.renderNode, this);

							// 6. All positioned, opacity or transform descendants, in tree order that fall into the following categories:
							//  All positioned descendants with 'z-index: auto' or 'z-index: 0', in tree order.
							//  For those with 'z-index: auto', treat the element as if it created a new stacking context,
							//  but any positioned descendants and descendants which actually create a new stacking context should be
							//  considered part of the parent stacking context, not this new one. For those with 'z-index: 0',
							//  treat the stacking context generated atomically.
							//
							//  All opacity descendants with opacity less than 1
							//
							//  All transform descendants with transform other than none
							zeroOrAutoZIndexOrTransformedOrOpacity.forEach(this.renderStack, this);

							// 7. Stacking contexts formed by positioned descendants with z-indices greater than or equal to 1 in z-index
							// order (smallest first) then tree order.
							positiveZIndex.sort(sortByZIndex).forEach(this.renderStack, this);
						}
					}, 
					{
						key: 'render',
						value: function render(stack)
						{
							var _this5 = this;

							//misty page backgroundcolor target : canvasrender
							if (this.options.backgroundColor) 
								this.targetRenderer.rectangle(this.options.x, this.options.y, this.options.width, this.options.height, this.options.backgroundColor);

							this.renderStack(stack);//
							var target = this.targetRenderer.getTarget();// Promise.resolve(this.canvas);
							if (true) 
							{
								return target.then(
													function (outputCanvasRenderer) 
													{
														_this5.options.logger.log('Render completed');
														return outputCanvasRenderer;
													});
							}
							return target;
						}
					}]);

				return Renderer;
			}();

			exports.default = Renderer;


			var splitDescendants = function splitDescendants(stack)
			{
				var inlineLevel = [];
				var nonInlineLevel = [];

				var length = stack.children.length;
				for (var i = 0; i < length; i++) {
					var child = stack.children[i];
					if (child.isInlineLevel()) {
						inlineLevel.push(child);
					} else {
						nonInlineLevel.push(child);
					}
				}
				return [inlineLevel, nonInlineLevel];
			};

			var splitStackingContexts = function splitStackingContexts(stack)
			{
				var negativeZIndex = [];
				var zeroOrAutoZIndexOrTransformedOrOpacity = [];
				var positiveZIndex = [];
				var nonPositionedFloats = [];
				var nonPositionedInlineLevel = [];
				var length = stack.contexts.length;

				for (var i = 0; i < length; i++)
				{
					var child = stack.contexts[i];
					var targetEle = child.targetContainer;
					var strName = targetEle.name;
					var strTagName = targetEle.tagName;
					var strClassName = targetEle.className;
					var fOpacity = targetEle.style.opacity;

				//	console.log("splitStackingContexts strTagName =  "  + strTagName + " strName = " + strName + 
				//	" strClassName = " + strClassName + " fOpacity = " + fOpacity);
				//	console.log("l = " + targetEle.bounds.left + " t = " + targetEle.bounds.top + " w = " + targetEle.bounds.width + " h " + targetEle.bounds.height);

					if (child.targetContainer.isPositioned() || child.targetContainer.style.opacity < 1 || child.targetContainer.isTransformed())
					{
						if (child.targetContainer.style.zIndex.order < 0) 
						{
							negativeZIndex.push(child);
						} 
						else if (child.targetContainer.style.zIndex.order > 0) 
						{
							positiveZIndex.push(child);
						} 
						else 
						{
							zeroOrAutoZIndexOrTransformedOrOpacity.push(child);						
						}
					} 
					else
					{
						if (child.targetContainer.isFloating()) 
						{
							nonPositionedFloats.push(child);
						} 
						else 
						{
							nonPositionedInlineLevel.push(child);
						}
					}
				}
				return [negativeZIndex, zeroOrAutoZIndexOrTransformedOrOpacity, positiveZIndex, nonPositionedFloats, nonPositionedInlineLevel];
			};

			var sortByZIndex = function sortByZIndex(a, b) 
			{
				if (a.targetContainer.style.zIndex.order > b.targetContainer.style.zIndex.order) 
				{
					return 1;
				} 
				else if (a.targetContainer.style.zIndex.order < b.targetContainer.style.zIndex.order) 
				{
					return -1;
				}

				return a.targetContainer.index > b.targetContainer.index ? 1 : -1;
			};
	/***/ }
	),
/* 47 :: _Gradient */
/***/ (
		function(module, exports, __webpack_require__) 
		{
			//g_objCommonUtil.log("modules[47 _Gradient].call");
			"use strict";

			Object.defineProperty(exports, "__esModule", {    value: true});
			exports.transformWebkitRadialGradientArgs = exports.parseGradient = exports.RadialGradient = exports.LinearGradient = exports.RADIAL_GRADIENT_SHAPE = exports.GRADIENT_TYPE = undefined;

			//misty 2018.01.02 var _slicedToArray = function () { function sliceIterator(arr, i) { var _arr = []; var _n = true; var _d = false; var _e = undefined; try { for (var _i = arr[Symbol.iterator](), _s; !(_n = (_s = _i.next()).done); _n = true) { _arr.push(_s.value); if (i && _arr.length === i) break; } } catch (err) { _d = true; _e = err; } finally { try { if (!_n && _i["return"]) _i["return"](); } finally { if (_d) throw _e; } } return _arr; } return function (arr, i) { if (Array.isArray(arr)) { return arr; } else if (Symbol.iterator in Object(arr)) { return sliceIterator(arr, i); } else { throw new TypeError("Invalid attempt to destructure non-iterable instance"); } }; }();

			var _NodeContainer = __webpack_require__(4);

			var _NodeContainer2 = _interopRequireDefault(_NodeContainer);

			var _Angle = __webpack_require__(48);

			var _Color = __webpack_require__(0);

			var _Color2 = _interopRequireDefault(_Color);

			var _Length = __webpack_require__(2);

			var _Length2 = _interopRequireDefault(_Length);

			var _Util = __webpack_require__(3);

			//misty 2018.01.02 function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { default: obj }; }

			//misty 2018.01.02 function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError("Cannot call a class as a function"); } }

			var SIDE_OR_CORNER = /^(to )?(left|top|right|bottom)( (left|top|right|bottom))?$/i;
			var PERCENTAGE_ANGLES = /^([+-]?\d*\.?\d+)% ([+-]?\d*\.?\d+)%$/i;
			var ENDS_WITH_LENGTH = /(px)|%|( 0)$/i;
			var FROM_TO_COLORSTOP = /^(from|to|color-stop)\((?:([\d.]+)(%)?,\s*)?(.+?)\)$/i;
			var RADIAL_SHAPE_DEFINITION = /^\s*(circle|ellipse)?\s*((?:([\d.]+)(px|r?em|%)\s*(?:([\d.]+)(px|r?em|%))?)|closest-side|closest-corner|farthest-side|farthest-corner)?\s*(?:at\s*(?:(left|center|right)|([\d.]+)(px|r?em|%))\s+(?:(top|center|bottom)|([\d.]+)(px|r?em|%)))?(?:\s|$)/i;

			var GRADIENT_TYPE = exports.GRADIENT_TYPE = {
				LINEAR_GRADIENT: 0,
				RADIAL_GRADIENT: 1
			};

			var RADIAL_GRADIENT_SHAPE = exports.RADIAL_GRADIENT_SHAPE = {
				CIRCLE: 0,
				ELLIPSE: 1
			};

			var LENGTH_FOR_POSITION = {
				left: new _Length2.default('0%'),
				top: new _Length2.default('0%'),
				center: new _Length2.default('50%'),
				right: new _Length2.default('100%'),
				bottom: new _Length2.default('100%')
			};

			var LinearGradient = exports.LinearGradient = function LinearGradient(colorStops, direction) {
				_classCallCheck(this, LinearGradient);

				this.type = GRADIENT_TYPE.LINEAR_GRADIENT;
				this.colorStops = colorStops;
				this.direction = direction;
			};

			var RadialGradient = exports.RadialGradient = function RadialGradient(colorStops, shape, center, radius) {
				_classCallCheck(this, RadialGradient);

				this.type = GRADIENT_TYPE.RADIAL_GRADIENT;
				this.colorStops = colorStops;
				this.shape = shape;
				this.center = center;
				this.radius = radius;
			};

			var parseGradient = exports.parseGradient = function parseGradient(container, _ref, bounds) {
				var args = _ref.args,
					method = _ref.method,
					prefix = _ref.prefix;

				if (method === 'linear-gradient') {
					return parseLinearGradient(args, bounds, !!prefix);
				} else if (method === 'gradient' && args[0] === 'linear') {
					// TODO handle correct angle
					return parseLinearGradient(['to bottom'].concat(transformObsoleteColorStops(args.slice(3))), bounds, !!prefix);
				} else if (method === 'radial-gradient') {
					return parseRadialGradient(container, prefix === '-webkit-' ? transformWebkitRadialGradientArgs(args) : args, bounds);
				} else if (method === 'gradient' && args[0] === 'radial') {
					return parseRadialGradient(container, transformObsoleteColorStops(transformWebkitRadialGradientArgs(args.slice(1))), bounds);
				}
			};

			var parseColorStops = function parseColorStops(args, firstColorStopIndex, lineLength) 
			{
				var colorStops = [];

				for (var i = firstColorStopIndex; i < args.length; i++) 
				{
					var value = args[i];
					var HAS_LENGTH = ENDS_WITH_LENGTH.test(value);
					var lastSpaceIndex = value.lastIndexOf(' ');
					var _color = new _Color2.default(HAS_LENGTH ? value.substring(0, lastSpaceIndex) : value);
					var _stop = HAS_LENGTH ? new _Length2.default(value.substring(lastSpaceIndex + 1)) : i === firstColorStopIndex ? new _Length2.default('0%') : i === args.length - 1 ? new _Length2.default('100%') : null;
					colorStops.push({ color: _color, stop: _stop });
				}

				var absoluteValuedColorStops = colorStops.map(function (_ref2) 
				{
					var color = _ref2.color,
						stop = _ref2.stop;

					var absoluteStop = lineLength === 0 ? 0 : stop ? stop.getAbsoluteValue(lineLength) / lineLength : null;

					return {
						color: color,
						// $FlowFixMe
						stop: absoluteStop
					};
				});

				var previousColorStop = absoluteValuedColorStops[0].stop;
				for (var _i = 0; _i < absoluteValuedColorStops.length; _i++) 
				{
					if (previousColorStop !== null) {
						var _stop2 = absoluteValuedColorStops[_i].stop;
						if (_stop2 === null) {
							var n = _i;
							while (absoluteValuedColorStops[n].stop === null) {
								n++;
							}
							var steps = n - _i + 1;
							var nextColorStep = absoluteValuedColorStops[n].stop;
							var stepSize = (nextColorStep - previousColorStop) / steps;
							for (; _i < n; _i++) {
								previousColorStop = absoluteValuedColorStops[_i].stop = previousColorStop + stepSize;
							}
						} else {
							previousColorStop = _stop2;
						}
					}
				}

				return absoluteValuedColorStops;
			};

			var parseLinearGradient = function parseLinearGradient(args, bounds, hasPrefix) 
			{
				var angle = (0, _Angle.parseAngle)(args[0]);
				var HAS_SIDE_OR_CORNER = SIDE_OR_CORNER.test(args[0]);
				var HAS_DIRECTION = HAS_SIDE_OR_CORNER || angle !== null || PERCENTAGE_ANGLES.test(args[0]);
				var direction = HAS_DIRECTION ? angle !== null ? calculateGradientDirection(
				// if there is a prefix, the 0° angle points due East (instead of North per W3C)
				hasPrefix ? angle - Math.PI * 0.5 : angle, bounds) : HAS_SIDE_OR_CORNER ? parseSideOrCorner(args[0], bounds) : parsePercentageAngle(args[0], bounds) : calculateGradientDirection(Math.PI, bounds);
				var firstColorStopIndex = HAS_DIRECTION ? 1 : 0;

				// TODO: Fix some inaccuracy with color stops with px values
				var lineLength = Math.min((0, _Util.distance)(Math.abs(direction.x0) + Math.abs(direction.x1), Math.abs(direction.y0) + Math.abs(direction.y1)), bounds.width * 2, bounds.height * 2);

				return new LinearGradient(parseColorStops(args, firstColorStopIndex, lineLength), direction);
			};

			var parseRadialGradient = function parseRadialGradient(container, args, bounds) 
			{
				var m = args[0].match(RADIAL_SHAPE_DEFINITION);
				var shape = m && (m[1] === 'circle' || // explicit shape specification
				m[3] !== undefined && m[5] === undefined) // only one radius coordinate
				? RADIAL_GRADIENT_SHAPE.CIRCLE : RADIAL_GRADIENT_SHAPE.ELLIPSE;
				var radius = {};
				var center = {};

				if (m) 
				{
					// Radius
					if (m[3] !== undefined) {
						radius.x = (0, _Length.calculateLengthFromValueWithUnit)(container, m[3], m[4]).getAbsoluteValue(bounds.width);
					}

					if (m[5] !== undefined) {
						radius.y = (0, _Length.calculateLengthFromValueWithUnit)(container, m[5], m[6]).getAbsoluteValue(bounds.height);
					}

					// Position
					if (m[7]) {
						center.x = LENGTH_FOR_POSITION[m[7].toLowerCase()];
					} else if (m[8] !== undefined) {
						center.x = (0, _Length.calculateLengthFromValueWithUnit)(container, m[8], m[9]);
					}

					if (m[10]) {
						center.y = LENGTH_FOR_POSITION[m[10].toLowerCase()];
					} else if (m[11] !== undefined) {
						center.y = (0, _Length.calculateLengthFromValueWithUnit)(container, m[11], m[12]);
					}
				}

				var gradientCenter = 
						{
					x: center.x === undefined ? bounds.width / 2 : center.x.getAbsoluteValue(bounds.width),
					y: center.y === undefined ? bounds.height / 2 : center.y.getAbsoluteValue(bounds.height)
				};
				var gradientRadius = calculateRadius(m && m[2] || 'farthest-corner', shape, gradientCenter, radius, bounds);

				return new RadialGradient(parseColorStops(args, m ? 1 : 0, Math.min(gradientRadius.x, gradientRadius.y)), shape, gradientCenter, gradientRadius);
			};

			var calculateGradientDirection = function calculateGradientDirection(radian, bounds) 
			{
				var width = bounds.width;
				var height = bounds.height;
				var HALF_WIDTH = width * 0.5;
				var HALF_HEIGHT = height * 0.5;
				var lineLength = Math.abs(width * Math.sin(radian)) + Math.abs(height * Math.cos(radian));
				var HALF_LINE_LENGTH = lineLength / 2;

				var x0 = HALF_WIDTH + Math.sin(radian) * HALF_LINE_LENGTH;
				var y0 = HALF_HEIGHT - Math.cos(radian) * HALF_LINE_LENGTH;
				var x1 = width - x0;
				var y1 = height - y0;

				return { x0: x0, x1: x1, y0: y0, y1: y1 };
			};

			var parseTopRight = function parseTopRight(bounds) 
			{
				return Math.acos(bounds.width / 2 / ((0, _Util.distance)(bounds.width, bounds.height) / 2));
			};

			var parseSideOrCorner = function parseSideOrCorner(side, bounds) 
			{
				switch (side) 
				{
					case 'bottom':
					case 'to top':
						return calculateGradientDirection(0, bounds);
					case 'left':
					case 'to right':
						return calculateGradientDirection(Math.PI / 2, bounds);
					case 'right':
					case 'to left':
						return calculateGradientDirection(3 * Math.PI / 2, bounds);
					case 'top right':
					case 'right top':
					case 'to bottom left':
					case 'to left bottom':
						return calculateGradientDirection(Math.PI + parseTopRight(bounds), bounds);
					case 'top left':
					case 'left top':
					case 'to bottom right':
					case 'to right bottom':
						return calculateGradientDirection(Math.PI - parseTopRight(bounds), bounds);
					case 'bottom left':
					case 'left bottom':
					case 'to top right':
					case 'to right top':
						return calculateGradientDirection(parseTopRight(bounds), bounds);
					case 'bottom right':
					case 'right bottom':
					case 'to top left':
					case 'to left top':
						return calculateGradientDirection(2 * Math.PI - parseTopRight(bounds), bounds);
					case 'top':
					case 'to bottom':
					default:
						return calculateGradientDirection(Math.PI, bounds);
				}
			};

			var parsePercentageAngle = function parsePercentageAngle(angle, bounds)
			{
				var _angle$split$map = angle.split(' ').map(parseFloat),
					_angle$split$map2 = _slicedToArray(_angle$split$map, 2),
					left = _angle$split$map2[0],
					top = _angle$split$map2[1];

				var ratio = left / 100 * bounds.width / (top / 100 * bounds.height);

				return calculateGradientDirection(Math.atan(isNaN(ratio) ? 1 : ratio) + Math.PI / 2, bounds);
			};

			var findCorner = function findCorner(bounds, x, y, closest) 
			{
				var corners = [{ x: 0, y: 0 }, { x: 0, y: bounds.height }, { x: bounds.width, y: 0 }, { x: bounds.width, y: bounds.height }];

				// $FlowFixMe
				return corners.reduce(function (stat, corner) {
					var d = (0, _Util.distance)(x - corner.x, y - corner.y);
					if (closest ? d < stat.optimumDistance : d > stat.optimumDistance) {
						return {
							optimumCorner: corner,
							optimumDistance: d
						};
					}

					return stat;
				}, {
					optimumDistance: closest ? Infinity : -Infinity,
					optimumCorner: null
				}).optimumCorner;
			};

			var calculateRadius = function calculateRadius(extent, shape, center, radius, bounds) 
			{
				var x = center.x;
				var y = center.y;
				var rx = 0;
				var ry = 0;

				switch (extent)
				{
					case 'closest-side':
						// The ending shape is sized so that that it exactly meets the side of the gradient box closest to the gradient’s center.
						// If the shape is an ellipse, it exactly meets the closest side in each dimension.
						if (shape === RADIAL_GRADIENT_SHAPE.CIRCLE) {
							rx = ry = Math.min(Math.abs(x), Math.abs(x - bounds.width), Math.abs(y), Math.abs(y - bounds.height));
						} else if (shape === RADIAL_GRADIENT_SHAPE.ELLIPSE) {
							rx = Math.min(Math.abs(x), Math.abs(x - bounds.width));
							ry = Math.min(Math.abs(y), Math.abs(y - bounds.height));
						}
						break;

					case 'closest-corner':
						// The ending shape is sized so that that it passes through the corner of the gradient box closest to the gradient’s center.
						// If the shape is an ellipse, the ending shape is given the same aspect-ratio it would have if closest-side were specified.
						if (shape === RADIAL_GRADIENT_SHAPE.CIRCLE) {
							rx = ry = Math.min((0, _Util.distance)(x, y), (0, _Util.distance)(x, y - bounds.height), (0, _Util.distance)(x - bounds.width, y), (0, _Util.distance)(x - bounds.width, y - bounds.height));
						} else if (shape === RADIAL_GRADIENT_SHAPE.ELLIPSE) {
							// Compute the ratio ry/rx (which is to be the same as for "closest-side")
							var c = Math.min(Math.abs(y), Math.abs(y - bounds.height)) / Math.min(Math.abs(x), Math.abs(x - bounds.width));
							var corner = findCorner(bounds, x, y, true);
							rx = (0, _Util.distance)(corner.x - x, (corner.y - y) / c);
							ry = c * rx;
						}
						break;

					case 'farthest-side':
						// Same as closest-side, except the ending shape is sized based on the farthest side(s)
						if (shape === RADIAL_GRADIENT_SHAPE.CIRCLE) {
							rx = ry = Math.max(Math.abs(x), Math.abs(x - bounds.width), Math.abs(y), Math.abs(y - bounds.height));
						} else if (shape === RADIAL_GRADIENT_SHAPE.ELLIPSE) {
							rx = Math.max(Math.abs(x), Math.abs(x - bounds.width));
							ry = Math.max(Math.abs(y), Math.abs(y - bounds.height));
						}
						break;

					case 'farthest-corner':
						// Same as closest-corner, except the ending shape is sized based on the farthest corner.
						// If the shape is an ellipse, the ending shape is given the same aspect ratio it would have if farthest-side were specified.
						if (shape === RADIAL_GRADIENT_SHAPE.CIRCLE) {
							rx = ry = Math.max((0, _Util.distance)(x, y), (0, _Util.distance)(x, y - bounds.height), (0, _Util.distance)(x - bounds.width, y), (0, _Util.distance)(x - bounds.width, y - bounds.height));
						} else if (shape === RADIAL_GRADIENT_SHAPE.ELLIPSE) {
							// Compute the ratio ry/rx (which is to be the same as for "farthest-side")
							var _c = Math.max(Math.abs(y), Math.abs(y - bounds.height)) / Math.max(Math.abs(x), Math.abs(x - bounds.width));
							var _corner = findCorner(bounds, x, y, false);
							rx = (0, _Util.distance)(_corner.x - x, (_corner.y - y) / _c);
							ry = _c * rx;
						}
						break;

					default:
						// pixel or percentage values
						rx = radius.x || 0;
						ry = radius.y !== undefined ? radius.y : rx;
						break;
				}

				return {
					x: rx,
					y: ry
				};
			};

			var transformWebkitRadialGradientArgs = exports.transformWebkitRadialGradientArgs = function transformWebkitRadialGradientArgs(args)
			{
				var shape = '';
				var radius = '';
				var extent = '';
				var position = '';
				var idx = 0;

				var POSITION = /^(left|center|right|\d+(?:px|r?em|%)?)(?:\s+(top|center|bottom|\d+(?:px|r?em|%)?))?$/i;
				var SHAPE_AND_EXTENT = /^(circle|ellipse)?\s*(closest-side|closest-corner|farthest-side|farthest-corner|contain|cover)?$/i;
				var RADIUS = /^\d+(px|r?em|%)?(?:\s+\d+(px|r?em|%)?)?$/i;

				var matchStartPosition = args[idx].match(POSITION);
				if (matchStartPosition) {
					idx++;
				}

				var matchShapeExtent = args[idx].match(SHAPE_AND_EXTENT);
				if (matchShapeExtent) {
					shape = matchShapeExtent[1] || '';
					extent = matchShapeExtent[2] || '';
					if (extent === 'contain') {
						extent = 'closest-side';
					} else if (extent === 'cover') {
						extent = 'farthest-corner';
					}
					idx++;
				}

				var matchStartRadius = args[idx].match(RADIUS);
				if (matchStartRadius) {
					idx++;
				}

				var matchEndPosition = args[idx].match(POSITION);
				if (matchEndPosition) {
					idx++;
				}

				var matchEndRadius = args[idx].match(RADIUS);
				if (matchEndRadius) {
					idx++;
				}

				var matchPosition = matchEndPosition || matchStartPosition;
				if (matchPosition && matchPosition[1]) {
					position = matchPosition[1] + (/^\d+$/.test(matchPosition[1]) ? 'px' : '');
					if (matchPosition[2]) {
						position += ' ' + matchPosition[2] + (/^\d+$/.test(matchPosition[2]) ? 'px' : '');
					}
				}

				var matchRadius = matchEndRadius || matchStartRadius;
				if (matchRadius) {
					radius = matchRadius[0];
					if (!matchRadius[1]) {
						radius += 'px';
					}
				}

				if (position && !shape && !radius && !extent) {
					radius = position;
					position = '';
				}

				if (position) {
					position = 'at ' + position;
				}

				return [[shape, extent, radius, position].filter(function (s) {
					return !!s;
				}).join(' ')].concat(args.slice(idx));
			};

			var transformObsoleteColorStops = function transformObsoleteColorStops(args) 
			{
				return args.map(function (color) {
					return color.match(FROM_TO_COLORSTOP);
				})
				// $FlowFixMe
				.map(function (v, index) {
					if (!v) {
						return args[index];
					}

					switch (v[1]) {
						case 'from':
							return v[4] + ' 0%';
						case 'to':
							return v[4] + ' 100%';
						case 'color-stop':
							if (v[3] === '%') {
								return v[4] + ' ' + v[2];
							}
							return v[4] + ' ' + parseFloat(v[2]) * 100 + '%';
					}
				});
			};
	/***/ }
	),
/* 48 :: _Angle */
/***/ (
		function(module, exports, __webpack_require__) 
		{
			//g_objCommonUtil.log("modules[48 Angle].call");
			"use strict";

			Object.defineProperty(exports, "__esModule", {    value: true});
			var ANGLE = /([+-]?\d*\.?\d+)(deg|grad|rad|turn)/i;

			var parseAngle = exports.parseAngle = function parseAngle(angle) 
			{
				var match = angle.match(ANGLE);

				if (match) 
				{
					var value = parseFloat(match[1]);
					switch (match[2].toLowerCase()) 
					{
						case 'deg':
							return Math.PI * value / 180;
						case 'grad':
							return Math.PI / 200 * value;
						case 'rad':
							return value;
						case 'turn':
							return Math.PI * 2 * value;
					}
				}

				return null;
			};
	/***/ }
	),
/* 49 :: m_Clone */
	(
		function(module, exports, __webpack_require__) 
		{
			//g_objCommonUtil.log("modules[49 m_Clone].call");
			"use strict";

			Object.defineProperty(exports, "__esModule", {   value: true});
			exports.cloneWindow = exports.DocumentCloner = undefined;

			//misty 2018.01.02 var _slicedToArray = function () { function sliceIterator(arr, i) { var _arr = []; var _n = true; var _d = false; var _e = undefined; try { for (var _i = arr[Symbol.iterator](), _s; !(_n = (_s = _i.next()).done); _n = true) { _arr.push(_s.value); if (i && _arr.length === i) break; } } catch (err) { _d = true; _e = err; } finally { try { if (!_n && _i["return"]) _i["return"](); } finally { if (_d) throw _e; } } return _arr; } return function (arr, i) { if (Array.isArray(arr)) { return arr; } else if (Symbol.iterator in Object(arr)) { return sliceIterator(arr, i); } else { throw new TypeError("Invalid attempt to destructure non-iterable instance"); } }; }();
			//misty 2018.01.02 var _createClass = function () { function defineProperties(target, props) { for (var i = 0; i < props.length; i++) { var descriptor = props[i]; descriptor.enumerable = descriptor.enumerable || false; descriptor.configurable = true; if ("value" in descriptor) descriptor.writable = true; Object.defineProperty(target, descriptor.key, descriptor); } } return function (Constructor, protoProps, staticProps) { if (protoProps) defineProperties(Constructor.prototype, protoProps); if (staticProps) defineProperties(Constructor, staticProps); return Constructor; }; }();

			var _Bounds = __webpack_require__(1);
			var _Proxy = __webpack_require__(23);
			var _ResourceLoader = __webpack_require__(50);
			var _ResourceLoader2 = _interopRequireDefault(_ResourceLoader);
			var _Util = __webpack_require__(3);
			var _background = __webpack_require__(5);
			var _CanvasRenderer = __webpack_require__(12);
			var _CanvasRenderer2 = _interopRequireDefault(_CanvasRenderer);

			//misty 2018.01.02 function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { default: obj }; }
			//misty 2018.01.02 function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError("Cannot call a class as a function"); } }

			var IGNORE_ATTRIBUTE = 'data-html2canvas-ignore';
			var ONE_ATT_PGNUM = "pagenum";

			var DocumentCloner = exports.DocumentCloner = function () 
			{
				function DocumentCloner(targetEle, options, logger, copyInline, rendererFunc) 
				{					
					_classCallCheck(this, DocumentCloner);					

					var nCurPgNum = targetEle.getAttribute("pagenum");
				//	console.log("[DocumentCloner] Start nPgNum = " + nCurPgNum);	


					this.referenceElement = targetEle;
					this.scrolledElements = [];
					this.copyStyles = copyInline;
					this.inlineImages = copyInline;
					this.logger = logger;
					this.options = options;
					this.renderer = rendererFunc;
					this.resourceLoader = new _ResourceLoader2.default(options, logger, window,nCurPgNum);

					// $FlowFixMe
					this.documentElement = this.cloneNode(targetEle/*element*/.ownerDocument.documentElement);
					//g_ODrawManager.checkTime("1","DocumentCloner");
					//check customCSS

					//targetEle.HTML을 copy한 HTML
				}

				_createClass(DocumentCloner, [
												{//1
													key: 'inlineAllImages',
													value: function inlineAllImages(node) 
													{
														var _this = this;

														if (this.inlineImages && node) 
														{
															//console.log("MISTY5-1");
															var style = node.style;
															Promise.all((0, _background.parseBackgroundImage)(style.backgroundImage).map(function (backgroundImage)
															{
																if (backgroundImage.method === 'url') 
																{
																	return _this.resourceLoader.inlineImage(backgroundImage.args[0]).then(function (img) 
																	{
																		return img && typeof img.src === 'string' ? 'url("' + img.src + '")' : 'none';
																	}).catch(function (e) {
																		if (true) {
																			_this.logger.log('Unable to load image', e);
																		}
																	});
																}
																return Promise.resolve('' + backgroundImage.prefix + backgroundImage.method + '(' + backgroundImage.args.join(',') + ')');
															})).then(function (backgroundImages) 
															{
															//	console.log("MISTY5-3");
																if (backgroundImages.length > 1) 
																{
																	// TODO Multiple backgrounds somehow broken in Chrome
																	style.backgroundColor = '';
																}
																style.backgroundImage = backgroundImages.join(',');
															});

															if (node instanceof HTMLImageElement) 
															{
																this.resourceLoader.inlineImage(node.src).then(function (img) 
																{
																	if (img && node instanceof HTMLImageElement && node.parentNode)
																	{
																		var parentNode = node.parentNode;
																		var clonedChild = (0, _Util.copyCSSStyles)(node.style, img.cloneNode(false));
																		parentNode.replaceChild(clonedChild, node);
																	}
																}).catch(function (e)
																{
																	if (true) 
																	{
																		_this.logger.log('Unable to load image', e);
																	}
																});
															}
															//console.log("MISTY5-2");
														}
													}
												}, 
												{//2
													key: 'inlineFonts',
													value: function inlineFonts(document) {
														var _this2 = this;

														return Promise.all(Array.from(document.styleSheets).map(function (sheet) {
															if (sheet.href) {
																return fetch(sheet.href).then(function (res) {
																	return res.text();
																}).then(function (text) {
																	return createStyleSheetFontsFromText(text, sheet.href);
																}).catch(function (e) {
																	if (true) {
																		_this2.logger.log('Unable to load stylesheet', e);
																	}
																	return [];
																});
															}
															return getSheetFonts(sheet, document);
														})).then(function (fonts) {
															return fonts.reduce(function (acc, font) {
																return acc.concat(font);
															}, []);
														}).then(function (fonts) {
															return Promise.all(fonts.map(function (font) {
																return fetch(font.formats[0].src).then(function (response) {
																	return response.blob();
																}).then(function (blob) {
																	return new Promise(function (resolve, reject) {
																		var reader = new FileReader();
																		reader.onerror = reject;
																		reader.onload = function () {
																			// $FlowFixMe
																			var result = reader.result;
																			resolve(result);
																		};
																		reader.readAsDataURL(blob);
																	});
																}).then(function (dataUri) {
																	font.fontFace.setProperty('src', 'url("' + dataUri + '")');
																	return '@font-face {' + font.fontFace.cssText + ' ';
																});
															}));
														}).then(function (fontCss) {
															var style = document.createElement('style');
															style.textContent = fontCss.join('\n');
															_this2.documentElement.appendChild(style);
														});
													}
												},
												{//3
													key: 'createElementClone',
													value: function createElementClone(node) 
													{
														//if(node)
															//g_objCommonUtil.log(" " + node.nodeName + " ") ;

														var _this3 = this;//DocumentCloner

														if (this.copyStyles && node instanceof HTMLCanvasElement) 
														{
															//console.log("MISTY1-1");
															var img = node.ownerDocument.createElement('img');
															try 
															{
																img.src = node.toDataURL();
															//	console.log("MISTY1-2");
																return img;
															} 
															catch (e) 
															{
																if (true) 
																{
																	this.logger.log('Unable to clone canvas contents, canvas is tainted');
																}
															}
														}

														if (node instanceof HTMLIFrameElement) 
														{
															var tempIframe = node.cloneNode(false);
															var iframeKey = generateIframeKey();
															tempIframe.setAttribute('data-html2canvas-internal-iframe-key', iframeKey);

															var _parseBounds = (0, _Bounds.parseBounds)(node, 0, 0),
																width = _parseBounds.width,
																height = _parseBounds.height;

															this.resourceLoader.cache[iframeKey] = getIframeDocumentElement(node, this.options).then(function (documentElement) 
															{
																return _this3.renderer(documentElement, 
																{
																	async: _this3.options.async,
																	allowTaint: _this3.options.allowTaint,
																	backgroundColor: '#ffffff'/*WHITE 	//misty */,
																	canvas: null,
																	imageTimeout: _this3.options.imageTimeout,
																	logging: _this3.options.logging,
																	proxy: _this3.options.proxy,
																	removeContainer: _this3.options.removeContainer,
																	scale: _this3.options.scale,
																	bForeignObjectRendering: _this3.options.bForeignObjectRendering,
																	useCORS: _this3.options.useCORS,
																	target: new _CanvasRenderer2.default()/*html2canvas.CanvasRenderer*/,
																	width: width,
																	height: height,
																	x: 0,
																	y: 0,
																	windowWidth: documentElement.ownerDocument.defaultView.innerWidth,
																	windowHeight: documentElement.ownerDocument.defaultView.innerHeight,
																	scrollX: documentElement.ownerDocument.defaultView.pageXOffset,
																	scrollY: documentElement.ownerDocument.defaultView.pageYOffset
																}, _this3.logger.child(iframeKey));
															}).then(function (canvas) 
																{
																	return new Promise(function (resolve, reject) 
																	{
																		var iframeCanvas = document.createElement('img');
																		iframeCanvas.onload = function () 
																		{
																			return resolve(canvas);
																		};
																		iframeCanvas.onerror = reject;
																		iframeCanvas.src = canvas.toDataURL();
																		if (tempIframe.parentNode) 
																		{
																			var testWhat = (0, _Util.copyCSSStyles)(node.ownerDocument.defaultView.getComputedStyle(node), iframeCanvas);
																			tempIframe.parentNode.replaceChild(testWhat, tempIframe);
																		}
																	});
																});
															return tempIframe;
														}
														
														var clone = node.cloneNode(false);
														return clone;
													}
												},
												{
													key: 'cloneNode',
													value: function cloneNode(node) 
													{
														//console.log("[START] nodeID = " + node.id + " nodeName = " +node.nodeName  + " className = " +node.className+ " nodeType = " + node.nodeType + " nodeValue = " + node.nodeValue);
														var clone = (node.nodeType === Node.TEXT_NODE) ? document.createTextNode(node.nodeValue) : this.createElementClone(node);

														if((node.nodeType == Node.ELEMENT_NODE) && (node.nodeName.toLowerCase() == DZE_TAG_DIV))
														{//header footer 비활성인 경우 썸네일 중 복제 노드는 투명도 해제 misty - 2019.01.17
															var strClassName= node.className.toLowerCase();
															if(strClassName != "dze_page_header_container" && strClassName.search("dze_page_header")>=0)
																clone.style.opacity = 1;//dze_page_header unselectable
															else if(strClassName != "dze_page_footer_container" && strClassName.search("dze_page_footer")>=0)
																clone.style.opacity = 1;//dze_page_footer unselectable
															else if(strClassName.search("dze_page_main")>=0)
																clone.style.opacity = 1;//dze_page_main unselectable
															else if(strClassName.search("dze_document_container") >= 0 || node.id === "totalPageContainer") {
																clone.style.transform = "scale(1)";    //oneffice doc zoom 제거 (UCDOC-2582, 2020-11-11)
																clone.style.msTransform = "scale(1)";
															}
														}

														if(clone.nodeType === Node.ELEMENT_NODE && (clone.nodeName === "TD" || clone.nodeName === "TH"))
														{
															clone.removeAttribute("cusflag");	//셀 선택 제거 (UCDOC-2582, 2020-11-11)
														}

														if(node.nodeName=="svg"){
															convertSVGContents(node, clone);
														}

														var defViewWin = node.ownerDocument.defaultView;
																																			
														if (this.referenceElement/*tageetEle*/ === node /*targetEle.docEle*/) //&& clone instanceof window.HTMLElement
															this.clonedReferenceElement /*cloneTargetEle*/= clone;            														

														if (clone instanceof window.HTMLBodyElement) 
															createPseudoHideStyles(clone);            
														
														var onefficeShot = g_objOnefficeShot;
														for (var child = node.firstChild ; child; child = child.nextSibling) 
														{											
															if(child.nodeType === 1 && onefficeShot)
															{//misty - 2018.09.07
																//	console.log("[START-child] nodeID = " + child.id + " nodeName = " +child.nodeName  + " className = " +child.className+ " nodeType = " + child.nodeType + " nodeValue = " + child.nodeValue);
																child = onefficeShot.getCloneStEleNode(child);     //node skip 처리
//  if(child)
																	//  	console.log("[END-child] nodeID = " + child.id + " nodeName = " +child.nodeName  + " className = " +child.className+ " nodeType = " + child.nodeType + " nodeValue = " + child.nodeValue);
																	//  else
																	//  	console.log("[END-child] null");
															}

															if(fnObjectCheckNull(child))
																break;

															if ((child.nodeType !== Node.COMMENT_NODE/*misty - 2018.05.29*/) &&
															( (child.nodeType !== Node.ELEMENT_NODE) || 
															// $FlowFixMe
															child.nodeName !== 'SCRIPT' && !child.hasAttribute(IGNORE_ATTRIBUTE/*data-html2canvas-ignore*/))
															) 
															{
																//ELENODE가 아니거나, ELE 면서 SCRIPT 도 아니고, STYLE 도 아니고, HTML2CANVAS도 없고,
																if (!this.copyStyles/*bool*/ || child.nodeName !== 'STYLE') 
																{
																	//console.log("MISTY2-1");
																	var cloneChildNode = this.cloneNode(child);
																	clone.appendChild(cloneChildNode);                    //속도 저하1
																//	console.log("MISTY2-2");
																// 	console.log("");
																}
															}
														}

														if (node instanceof window.HTMLElement && clone instanceof window.HTMLElement) 
														{
															this.inlineAllImages(inlinePseudoElement(node, clone, PSEUDO_BEFORE));
															this.inlineAllImages(inlinePseudoElement(node, clone, PSEUDO_AFTER));
																
															if (this.copyStyles && !(node instanceof HTMLIFrameElement)) //node.className == "dze_printpreview_pagebox"/misty - 2018.05.30
															{
																//console.log("MISTY3-1");
																var orgStyleEle = node.ownerDocument.defaultView.getComputedStyle(node);
																(0, _Util.copyCSSStyles)(orgStyleEle, clone);
															//	console.log("MISTY3-2");
															}

															this.inlineAllImages(clone);
															if (node.scrollTop !== 0 || node.scrollLeft !== 0) 
																this.scrolledElements.push([clone, node.scrollLeft, node.scrollTop]);

															switch (node.nodeName) 
															{
																case 'CANVAS':
																	if (!this.copyStyles) 
																	{
																		//console.log("MISTY4-1");
																		cloneCanvasContents(node, clone);                        
																		//console.log("MISTY4-2");
																	}
																	break;
																case 'TEXTAREA':
																case 'SELECT':
																	clone.value = node.value;
																	break;
															}
														}

														// if(node.className == "dze_printpreview_pagebox")
														// 	console.log("pgNum = " + node.getAttribute("pagenum"));
													//	 console.log("[END] nodeID = " + node.id + " nodeName = " +node.nodeName  + " className = " +node.className+ " nodeType = " + node.nodeType + " nodeValue = " + node.nodeValue);
														
														return clone;
													}
												}
											]);

				return DocumentCloner;
			}();

			var getSheetFonts = function getSheetFonts(sheet, document) 
			{
				// $FlowFixMe
				return (sheet.cssRules ? Array.from(sheet.cssRules) : []).filter(function (rule) 
				{
					return rule.type === CSSRule.FONT_FACE_RULE;
				}).map(function (rule) 
				{
					var src = (0, _background.parseBackgroundImage)(rule.style.getPropertyValue('src'));
					var formats = [];
					for (var i = 0; i < src.length; i++) 
					{
						if (src[i].method === 'url' && src[i + 1] && src[i + 1].method === 'format') 
						{
							var a = document.createElement('a');
							a.href = src[i].args[0];
							if (document.body) 
								document.body.appendChild(a);                

							var font = {
								src: a.href,
								format: src[i + 1].args[0]
							};
							formats.push(font);
						}
					}

					return {           // TODO select correct format for browser),

						formats: formats.filter(function (font) 
						{
							return (/^woff/i.test(font.format)
							);
						}),
						fontFace: rule.style
					};
				}).filter(function (font) 
				{
					return font.formats.length;
				});
			};

			var createStyleSheetFontsFromText = function createStyleSheetFontsFromText(text, baseHref) 
			{
				var doc = document.implementation.createHTMLDocument('');
				var base = document.createElement('base');
				// $FlowFixMe
				base.href = baseHref;
				var style = document.createElement('style');

				style.textContent = text;
				if (doc.head) {
					doc.head.appendChild(base);
				}
				if (doc.body) {
					doc.body.appendChild(style);
				}

				return style.sheet ? getSheetFonts(style.sheet, doc) : [];
			};

			var restoreOwnerScroll = function restoreOwnerScroll(ownerDocument, x, y) /* owerDoc 의 x,y 로 이동*/
			{
				if (ownerDocument.defaultView && (x !== ownerDocument.defaultView.pageXOffset || y !== ownerDocument.defaultView.pageYOffset)) {
					ownerDocument.defaultView.scrollTo(x, y);
				}
			};

			var cloneCanvasContents = function cloneCanvasContents(canvas, clonedCanvas) 
			{
				try {
					if (clonedCanvas) {
						clonedCanvas.width = canvas.width;
						clonedCanvas.height = canvas.height;
						var ctx = canvas.getContext('2d');
						var clonedCtx = clonedCanvas.getContext('2d');
						if (ctx) {
							clonedCtx.putImageData(ctx.getImageData(0, 0, canvas.width, canvas.height), 0, 0);
						} else {
							clonedCtx.drawImage(canvas, 0, 0);
						}
					}
				} catch (e) {}
			};

			var convertSVGContents = function convertSVGContents(svg, clonedSVG)
			{
				  var blobToBase64 = function(blob) {
					var reader = new FileReader();
					reader.onload = function() {
						var dataUrl = reader.result;
						var _width = clonedSVG.getAttribute("width");
						var _height = clonedSVG.getAttribute("height");
						clonedSVG.outerHTML = "<image src='"+dataUrl+"' width='"+_width+"' height='"+_height+"'>"
					};
					reader.readAsDataURL(blob);
				};
					let clonedSvgElement = svg.cloneNode(true);
					let outerHTML = clonedSvgElement.outerHTML,
  					    blob = new Blob([outerHTML],{type:'image/svg+xml;charset=utf-8'});
					
					blobToBase64(blob);
			}

			

			var inlinePseudoElement = function inlinePseudoElement(node, clone, pseudoElt) 
			{
				var style = node.ownerDocument.defaultView.getComputedStyle(node, pseudoElt);
				if (!style || !style.content || style.content === 'none' || style.content === '-moz-alt-content' || style.display === 'none') 
				{
					return;
				}

				var content = stripQuotes(style.content);
				var image = content.match(URL_REGEXP);
				var anonymousReplacedElement = clone.ownerDocument.createElement(image ? 'img' : 'html2canvaspseudoelement');
				if (image)
				{	// $FlowFixMe
					anonymousReplacedElement.src = stripQuotes(image[1]);
				}
				else 
				{
					anonymousReplacedElement.textContent = content;
				}

				(0, _Util.copyCSSStyles)(style, anonymousReplacedElement);//????Misty

				anonymousReplacedElement.className = PSEUDO_HIDE_ELEMENT_CLASS_BEFORE + ' ' + PSEUDO_HIDE_ELEMENT_CLASS_AFTER;
				clone.className += pseudoElt === PSEUDO_BEFORE ? ' ' + PSEUDO_HIDE_ELEMENT_CLASS_BEFORE : ' ' + PSEUDO_HIDE_ELEMENT_CLASS_AFTER;
				if (pseudoElt === PSEUDO_BEFORE) 
				{
					clone.insertBefore(anonymousReplacedElement, clone.firstChild);
				}
				else 
				{
					clone.appendChild(anonymousReplacedElement);
				}

				return anonymousReplacedElement;
			};

			var stripQuotes = function stripQuotes(content) 
			{
				var first = content.substr(0, 1);
				return first === content.substr(content.length - 1) && first.match(/['"]/) ? content.substr(1, content.length - 2) : content;
			};

			var URL_REGEXP = /^url\((.+)\)$/i;
			var PSEUDO_BEFORE = ':before';
			var PSEUDO_AFTER = ':after';
			var PSEUDO_HIDE_ELEMENT_CLASS_BEFORE = '___html2canvas___pseudoelement_before';
			var PSEUDO_HIDE_ELEMENT_CLASS_AFTER = '___html2canvas___pseudoelement_after';

			var PSEUDO_HIDE_ELEMENT_STYLE = '{\n    content: "" !important;\n    display: none !important;\n}';

			var createPseudoHideStyles = function createPseudoHideStyles(body)
			{//clone 객체들 ___html2canvas___pseudoelement_before 스타일 정의
				createStyles(body, '.' + PSEUDO_HIDE_ELEMENT_CLASS_BEFORE + PSEUDO_BEFORE + PSEUDO_HIDE_ELEMENT_STYLE + '\n         .' + PSEUDO_HIDE_ELEMENT_CLASS_AFTER + PSEUDO_AFTER + PSEUDO_HIDE_ELEMENT_STYLE);
			};

			var createStyles = function createStyles(body, styles)
			{
				var style = body.ownerDocument.createElement('style');
				style.innerHTML = styles;
				body.appendChild(style);
			};

			var initNodeFunc = function initNodeFunc(_ref)
			{
				var _ref2 = _slicedToArray(_ref, 3),
					element = _ref2[0],
					x = _ref2[1],
					y = _ref2[2];

				element.scrollLeft = x;
				element.scrollTop = y;
			};

			var generateIframeKey = function generateIframeKey()
			{
				return Math.ceil(Date.now() + Math.random() * 10000000).toString(16);
			};

			var DATA_URI_REGEXP = /^data:text\/(.+);(base64)?,(.*)$/i;

			var getIframeDocumentElement = function getIframeDocumentElement(node, options)
			{
				try 
				{
					return Promise.resolve(node.contentWindow.document.documentElement);
				} 
				catch (e) 
				{
					return options.proxy ? (0, _Proxy.Proxy)(node.src, options).then(function (html)
					{
						var match = html.match(DATA_URI_REGEXP);
						if (!match) 
						{
							return Promise.reject();
						}
						return match[2] === 'base64' ? window.atob(decodeURIComponent(match[3])) : decodeURIComponent(match[3]);
					}).then(function (html) {
						return createIframeContainer(node.ownerDocument, (0, _Bounds.parseBounds)(node, 0, 0)).then(function (cloneIframeContainer)
						{
							var cloneWindow = cloneIframeContainer.contentWindow;
							var documentClone = cloneWindow.document;

							documentClone.open();
							documentClone.write(html);
							var iframeLoad = iframeLoader(cloneIframeContainer).then(function ()
							{
								return documentClone.documentElement;
							});

							documentClone.close();
							return iframeLoad;
						});
					}) : Promise.reject();
				}
			};

			var createIframeContainer = function createIframeContainer(ownerDocument, bounds)/*★ html2canvas-container iFrame 생성 ★ */
			{
				var cloneIframeContainer = ownerDocument.createElement('iframe');
				cloneIframeContainer.id = 'tmpHtml2Canvas';
				cloneIframeContainer.className = 'html2canvas-container';
				cloneIframeContainer.style.visibility = 'hidden';//misty - 2018.06.07
				cloneIframeContainer.style.position = 'fixed';
				cloneIframeContainer.style.left = '-10000px';//misty - 2018.06.07
				cloneIframeContainer.style.top = '0px';
				cloneIframeContainer.style.border = '0';
				cloneIframeContainer.width = bounds.width.toString();
				cloneIframeContainer.height = bounds.height.toString();
				//console.log("[createIFrameContainer] width = " + cloneIframeContainer.width  + " height = " + cloneIframeContainer.height );
				cloneIframeContainer.scrolling = 'no'; // ios won't scroll without it
				cloneIframeContainer.setAttribute(IGNORE_ATTRIBUTE, 'true');
				if (!ownerDocument.body) {
					return Promise.reject( true ? 'Body element not found in Document that is getting rendered' : '');
				}

				ownerDocument.body.appendChild(cloneIframeContainer);

				return Promise.resolve(cloneIframeContainer);//return cloneIframeContainer;
			};

			var iframeLoader = function iframeLoader(cloneIframeContainer/*tmpHtml2CanvasIframe*/) /* ★ iFrame//Page Loader ★*/
			{
				var cloneWindow = cloneIframeContainer/*tmpHtml2CanvasIframe*/.contentWindow;
				var documentClone = cloneWindow.document;

				var retVal = new Promise(function (resolve, reject)/*  5th OUT  */
				{
					cloneWindow.onload = cloneIframeContainer.onload = documentClone.onreadystatechange = function () 
					{
						var interval = setInterval(function () 
							{
								if(documentClone.body && documentClone.body.childNodes)
								{
									var nChildCnt = documentClone.body.childNodes.length;
								//	console.log("[cloneWindeow] = " + nChildCnt);
									if (nChildCnt > 0 && documentClone.readyState === 'complete') //★★★★★ documentDom.readyState
									{
										clearInterval(interval);
										resolve(cloneIframeContainer/*tmpHtml2CanvasIframe*/);
									}
								}
								else
								{
										clearInterval(interval);
										reject('documentClone body null');
								}
							}, THUMBNAIL_INTERVAL_TIME);
					};
				});

				return retVal;//iframe 이 load되었을 경우 cloneIframeContainer 리턴;
			};

			var cloneWindow = exports.cloneWindow = function cloneWindow(ownerDocument, bounds, referenceElement/*targetEle*/, options, logger, rendererFunc)/* ★WRITE!! ★ */
			{
				var cloner = new DocumentCloner(referenceElement/*targetEle*/, options, logger, g_objOnefficeShot.m_bCopyInlineStyles, rendererFunc);
				var scrollX = ownerDocument.defaultView.pageXOffset;
				var scrollY = ownerDocument.defaultView.pageYOffset;

				var retVal = createIframeContainer(ownerDocument, bounds).then(function (cloneIframeContainer/*tmpHtml2CanvasIframe*/) /* 3th OUT */
				{
					//misty - 2018.05.16 cloneIFrameContainer.setAttribute(ONE_ATT_PGNUM,referenceElement.getAttribute("pagenum"));
					var cloneTmpHtml2CanvasWindow = cloneIframeContainer/*tmpHtml2CanvasIframe*/.contentWindow;
					var documentClone = cloneTmpHtml2CanvasWindow.document;

					/* Chrome doesn't detect relative background-images assigned in inline <style> sheets when fetched through getComputedStyle
						 if window url is about:blank, we can assign the url to current by writing onto the document
						 */

					var iframeLoad = iframeLoader(cloneIframeContainer).then(function () /*  4th OUT  */
					{
						//iframe 의 document element 와 cloner의 복사한 documentelement 를 바꿔치기함, 메모리에 변경된 CSS는 복사하지 못함. so 보정 misty - 2018.06.21
						//document 가 load 되지 않은 경우 반영되지 않아 시점 변경.
						g_objOnefficeShot.addCustomCSSData(referenceElement.ownerDocument,documentClone/*iFrameDoc*/);
						cloner.scrolledElements.forEach(initNodeFunc);//??
						cloneTmpHtml2CanvasWindow.scrollTo(bounds.left, bounds.top);//windowBounds
						if (/(iPad|iPhone|iPod)/g.test(navigator.userAgent) && (cloneTmpHtml2CanvasWindow.scrollY !== bounds.top || cloneTmpHtml2CanvasWindow.scrollX !== bounds.left))
						{
							documentClone.documentElement.style.top = -bounds.top + 'px';
							documentClone.documentElement.style.left = -bounds.left + 'px';
							documentClone.documentElement.style.position = 'absolute';
						}

						var cond = (cloner.clonedReferenceElement instanceof cloneTmpHtml2CanvasWindow.HTMLElement || 
									cloner.clonedReferenceElement instanceof ownerDocument.defaultView.HTMLElement || 
									cloner.clonedReferenceElement/*cloneTargetEle*/ instanceof HTMLElement );
						var retPromise = cond? 	Promise.resolve([cloneIframeContainer, cloner.clonedReferenceElement/*targetEle*/, cloner.resourceLoader]) ://POINT_Render info = make _ref
												Promise.reject( true ? 'Error finding the nodeName :: ' + referenceElement.nodeName + " id:: " + 
													referenceElement.id + " className:: " + referenceElement.className + ' in the cloned document' : '');

						return 	retPromise;
					});

					documentClone.open();
					documentClone.write('<html></html>');    //oneffice document html4 (UCDOC-2582, 2020-11-12)
					//documentClone.write('<!DOCTYPE html><html></html>');
					// Chrome scrolls the parent document for some reason after the write to the cloned window???
					restoreOwnerScroll(referenceElement.ownerDocument, scrollX, scrollY);
					documentClone.replaceChild(documentClone.adoptNode(cloner.documentElement)/*외부 문서로부터 노드를 가져온다.해당 노드와 그 하위트리는 기존의 문서에서 지워지고,
					 해당 노드의 ownerDocument 는 현재 문서로 바뀐다. 그리고 그 노드는 현재의 문서에 삽입된다.*/, documentClone.documentElement);/*★ document 연결.★*/
					documentClone.close();
				
					return iframeLoad;//retPromise
				});

				return retVal;
		};
/***/ }
	),
/* 50 :: _ResourceLoader , _ResourceLoader2 */
/***/ (
		function(module, exports, __webpack_require__) 
		{
			//g_objCommonUtil.log("modules[50 _ResourceLoader=ImgArray??].call");
			"use strict";

			Object.defineProperty(exports, "__esModule", {    value: true});
			exports.ResourceStore = undefined;

			//misty 2018.01.02 var _createClass = function () { function defineProperties(target, props) { for (var i = 0; i < props.length; i++) { var descriptor = props[i]; descriptor.enumerable = descriptor.enumerable || false; descriptor.configurable = true; if ("value" in descriptor) descriptor.writable = true; Object.defineProperty(target, descriptor.key, descriptor); } } return function (Constructor, protoProps, staticProps) { if (protoProps) defineProperties(Constructor.prototype, protoProps); if (staticProps) defineProperties(Constructor, staticProps); return Constructor; }; }();
			var _Feature = __webpack_require__(9);
			var _Feature2 = _interopRequireDefault(_Feature);
			var _Proxy = __webpack_require__(23);
			//misty 2018.01.02 function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { default: obj }; }
			//misty 2018.01.02 function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError("Cannot call a class as a function"); } }

			var ResourceLoader = function () 
			{
				function ResourceLoader(options, logger, window, nCurPgNum) 
				{
					_classCallCheck(this, ResourceLoader);

					this.options = options;
					this._window = window;
					this.origin = this.getOrigin(window.location.href);
					this.cache = {};// = object
					this.logger = logger;
					this._index = 0;//idx?
					this.nCurPgNum = nCurPgNum;//misty - 2018.06.18
					
					this.bTmpImg = false;//misty - 2018.06.29
				}

				_createClass(ResourceLoader, [
					{
						key: 'loadImage',
						value: function loadImage(src) 
						{
							var _this = this;

							//g_objCommonUtil.log("loadImage::" + src);

							if (this.hasResourceInCache(src)) 
								return src;

							if (!isSVG(src) || _Feature2.default.SUPPORT_SVG_DRAWING) 
							{
								if (this.options.allowTaint === true || isInlineImage(src) || this.isSameOrigin(src)) 
								{								
									return this.addImage(src, src, false);
								} 
								else if (!this.isSameOrigin(src)) 
								{
									
									if (typeof this.options.proxy === 'string') 
									{
								//		console.log("[ResourceLoader:loadImage]-2 :: if (typeof this.options.proxy === 'string)");
										this.cache[src] = (0, _Proxy.Proxy)(src, this.options).then(	function (src) 
																										{
																											return _loadImage(src, _this.options.imageTimeout || 0);
																										});
																										return src;
									}//if (typeof this.options.proxy === 'string') 
									else if (this.options.useCORS === true && _Feature2.default.SUPPORT_CORS_IMAGES) //misty - cross domain tmp support 
									{
								//		console.log("[ResourceLoader:loadImage]-2 :: if (this.options.useCORS === true && _Feature2.default.SUPPORT_CORS_IMAGES)");
										//return this.addImage(src, src, true);									
										var _this4 = this;
										
										//var tmpSrc = dzeEnvConfig.strPath_Image + 'ribbon/toolbar_btn_insert_picture.png';
										var tmpSrc = src;//misty - 2018.10.19
//										var tmpSrc =  src;//misty - 2018.10.19
										this.bTmpImg = true;//misty - 2018.06.29
										
										if (true) 
											this.logger.log('maked tmp image ' + src.substring(0, 256));							
			
										var imageTmpLoadHandler = function imageTmpLoadHandler(bSupportsDataImages,nCurPgNum) 
										{
											return new Promise(	function (resolve, reject) 
																{
												
																	var img = new Image();	//misty
																	img.onload = function () 
																	{
																		return resolve(img);	//misty
																	};
																	img.id = ("imgTmpLoadHandler"+nCurPgNum);
																	img.setAttribute("pagenum",nCurPgNum);
																	img.crossOrigin = "Anonymous";
																	img.onerror = reject;
																	img.src = tmpSrc;
																	img.style.backgroundColor = "pink";	//misty
																	//ios safari 10.3 taints canvas with data urls unless crossOrigin is set to anonymous
																	
																	if (img.complete === true) 
																	{
																		// Inline XML images may fail to parse, throwing an Error later on
																		setTimeout(	function () 
																					{
																						resolve(img);	//misty
																					}, THUMBNAIL_TIMER_TIME);
																	}
			
																	if (_this4.options.imageTimeout) 
																	{
																		var timeout = _this4.options.imageTimeout;
																		setTimeout(	function () 
																					{
																						return reject( true ? 'Timed out (' + timeout + 'ms) fetching ' + src.substring(0, 256) : '');
																					}, timeout);
																	}
																});
										};
										var cond = (isInlineBase64Image(src) && !isSVG(src));
										this.cache[src] =  cond ? // $FlowFixMe
														_Feature2.default.SUPPORT_BASE64_DRAWING(src,this.nCurPgNum).then(imageTmpLoadHandler) :
														imageTmpLoadHandler(true,this.nCurPgNum);
										return src;
									}//else if (this.options.useCORS === true && _Feature2.default.SUPPORT_CORS_IMAGES) //misty - cross domain tmp support										
								}
							}//if (!isSVG(src) || _Feature2.default.SUPPORT_SVG_DRAWING) 
						}
					 },
					 {
						key: 'inlineImage',
						value: function inlineImage(src) 
						{
							var _this2 = this;

							if (isInlineImage(src)) {
								return _loadImage(src, this.options.imageTimeout || 0);
							}
							if (this.hasResourceInCache(src)) {
								return this.cache[src];
							}
							if (!this.isSameOrigin(src) && typeof this.options.proxy === 'string') {
								return this.cache[src] = (0, _Proxy.Proxy)(src, this.options).then(function (src) {
									return _loadImage(src, _this2.options.imageTimeout || 0);
								});
							}

							return this.xhrImage(src);
						}
					}, 
					{
						key: 'xhrImage',
						value: function xhrImage(src) 
						{
							var _this3 = this;

							this.cache[src] = new Promise(function (resolve, reject) {
								var xhr = new XMLHttpRequest();
								xhr.onreadystatechange = function () {
									if (xhr.readyState === 4) {
										if (xhr.status !== 200) {
											reject('Failed to fetch image ' + src.substring(0, 256) + ' with status code ' + xhr.status);
										} else {
											var reader = new FileReader();
											reader.addEventListener('load', function () {
												// $FlowFixMe
												var result = reader.result;
												resolve(result);
											}, false);
											reader.addEventListener('error', function (e) {
												return reject(e);
											}, false);
											reader.readAsDataURL(xhr.response);
										}
									}
								};
								xhr.responseType = 'blob';
								if (_this3.options.imageTimeout) {
									var timeout = _this3.options.imageTimeout;
									xhr.timeout = timeout;
									xhr.ontimeout = function () {
										return reject( true ? 'Timed out (' + timeout + 'ms) fetching ' + src.substring(0, 256) : '');
									};
								}
								xhr.open('GET', src, true);
								xhr.send();
							}).then(function (src) {
								return _loadImage(src, _this3.options.imageTimeout || 0);
							});

							return this.cache[src];
						}
					}, 
					{
						key: 'loadCanvas',
						value: function loadCanvas(node) 
						{
							var key = String(this._index++);
							this.cache[key] = Promise.resolve(node);
							return key;
						}
					}, 
					{
						key: 'hasResourceInCache',
						value: function hasResourceInCache(keySrc) 
						{
							return typeof this.cache[keySrc] !== 'undefined';
						}
					}, 
					{
						key: 'addImage',
						value: function addImage(keySrc, src, useCORS) 
						{
							var _this4 = this;

							if (true) 
								this.logger.log('Added image ' + keySrc.substring(0, 256));							

							var imageLoadHandler = function imageLoadHandler(bSupportsDataImages,nCurPgNum) 
							{
								var objPromise = new Promise(	function (resolve, reject) 
								{
									var img = new Image();	//misty
								//	console.log("[resourceLoader:addImage-imageHandler] SRC = " + src);
									img.onload = function () 
									{
										return resolve(img,parseFloat(img.id,10));
									};
									//ios safari 10.3 taints canvas with data urls unless crossOrigin is set to anonymous
									img.setAttribute('crossorigin', 'anonymous');
									if (!bSupportsDataImages || useCORS) 
									{
										img.crossOrigin = 'anonymous';
									}

									img.onerror = reject;
									img.src = src;
									if(typeof(nCurPgNum) == "undefined")
										nCurPgNum = 0;//misty -2018.06.18

									img.id = ("imgloadHandler" + nCurPgNum);//misty -2018.06.18
									img.setAttribute("pagenum",nCurPgNum);//misty -2018.06.18
									if (img.complete === true) 
									{// Inline XML images may fail to parse, throwing an Error later on
										setTimeout(	function () 
													{
														resolve(img,parseFloat(img.id,10));	//misty
													}, THUMBNAIL_TIMER_TIME);
									}

									if (_this4.options.imageTimeout) 
									{
										var timeout = _this4.options.imageTimeout;
										setTimeout(	function () 
													{
														return reject( true ? 'Timed out (' + timeout + 'ms) fetching ' + src.substring(0, 256) : '');
													}, timeout);
									}
								});

								return objPromise;
							};
							var cond = (isInlineBase64Image(src) && !isSVG(src));
							this.cache[keySrc] =  cond ? // $FlowFixMe
											_Feature2.default.SUPPORT_BASE64_DRAWING(src,this.nCurPgNum).then(imageLoadHandler) :
											imageLoadHandler(true,this.nCurPgNum);
							return keySrc;
						}
					}, 
					{
						key: 'isSameOrigin',
						value: function isSameOrigin(url) {
							return this.getOrigin(url) === this.origin;//cloner document Origin = this.Origin vs urlOrigin = imgOrigin
						}
					}, 
					{
						key: 'getOrigin',
						value: function getOrigin(url) 
						{
							var link = this._link || (this._link = this._window.document.createElement('a'));
							link.href = url;
							link.href = link.href; // IE9, LOL! - http://jsfiddle.net/niklasvh/2e48b/
							return link.protocol + link.hostname + link.port;
						}
					}, 
					{
						key: 'ready',
						value: function ready() {
							var _this5 = this;

							var keys = Object.keys(this.cache);//Object2Array
							var values = keys.map(function (str) 
							{
								return _this5.cache[str].catch(	function (e) 
																{
																	if (true) 
																		_this5.logger.log('Unable to load image', e);
																
																	return null;
																});
							});
							return Promise.all(values).then(	function (imagesNode)//0 :  img#imgTmpLoadHandler1, 1:img#imgloadHandler0
																{
																	if (true) 
																		_this5.logger.log('Finished loading ' + imagesNode.length + ' imagesNode', imagesNode);
																	
																	return new ResourceStore(keys, imagesNode);
																});
						}
					}
				]);

				return ResourceLoader;
			}();

			exports.default = ResourceLoader;

			var ResourceStore = exports.ResourceStore = function ()
			{//imgArray? - imgItem
				function ResourceStore(keys, resources/*array*/) 
				{
					_classCallCheck(this, ResourceStore);

					this._keys = keys;
					this._resources = resources;
					//g_objCommonUtil.log("ResourceStore :: " + keys);
					//g_objCommonUtil.log("ResourceStore :: " + resources.length);
					////g_objCommonUtil.log("ResourceStore :: " + resources[resources.length-1].src);
				}

				_createClass(ResourceStore, [
					{
						key: 'get',
						value: function get(key) {
							var index = this._keys.indexOf(key);
							return index === -1 ? null : this._resources[index];
					}
				}]);

				return ResourceStore;
			}();

			var INLINE_SVG = /^data:image\/svg\+xml/i;
			var INLINE_BASE64 = /^data:image\/.*;base64,/i;
			var INLINE_IMG = /^data:image\/.*/i;

			var isInlineImage = function isInlineImage(src) 
			{
				return INLINE_IMG.test(src);
			};
			var isInlineBase64Image = function isInlineBase64Image(src) 
			{
				return INLINE_BASE64.test(src);
			};

			var isSVG = function isSVG(src) 
			{
				return src.substr(-3).toLowerCase() === 'svg' || INLINE_SVG.test(src);
			};

			var _loadImage = function _loadImage(src, timeout) 
			{
				return new Promise(function (resolve, reject) 
				{
					var img = new Image();	//misty
					img.onload = function () 
					{
						return resolve(img);
					};
					img.onerror = reject;
					img.src = src;
					if (img.complete === true) 
					{
						// Inline XML images may fail to parse, throwing an Error later on
						setTimeout(function () 
						{
							resolve(img);	//misty
						}, THUMBNAIL_TIMER_TIME);
					}
					if (timeout) 
					{
						setTimeout(function () 
						{
							return reject( true ? 'Timed out (' + timeout + 'ms) loading image' : '');
						}, timeout);
					}
				});
			};
/***/ }
	)
    ]);
});