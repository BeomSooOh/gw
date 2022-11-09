
(function($)
{

	var tmp, loading, overlay, wrap, outer, inner, close, nav_left, nav_right,

		selectedIndex = 0, selectedOpts = {}, selectedArray = [], currentIndex = 0, currentOpts = {}, currentArray = [],

		ajaxLoader = null, imgPreloader = new Image(), imgRegExp = /\.(jpg|gif|png|bmp|jpeg)(.*)?$/i, swfRegExp = /[^\.]\.(swf)\s*$/i,

		loadingTimer, loadingFrame = 1,

		start_pos, final_pos, busy = false, shadow = 20, fx = $.extend($('<div/>')[0], { prop: 0 }), titleh = 0,

		isIE6 = !$.support.opacity && !window.XMLHttpRequest,

		layerbox_abort = function()
		{
			loading.hide();

			imgPreloader.onerror = imgPreloader.onload = null;

			if (ajaxLoader)
			{
				ajaxLoader.abort();
			}

			tmp.empty();
		},

		layerbox_error = function()
		{
			$.layerbox('<p id="layerbox_error">The requested content cannot be loaded.<br />Please try again later.</p>', {
				'scrolling': 'no',
				'padding': 20,
				'transitionIn': 'none',
				'transitionOut': 'none'
			});
		},

		layerbox_get_viewport = function()
		{
			return [$(window).width(), $(window).height(), $(document).scrollLeft(), $(document).scrollTop()];
		},

		layerbox_get_zoom_to = function()
		{
			var view = layerbox_get_viewport(),
				to = {},

				margin = currentOpts.margin,
				resize = currentOpts.autoScale,

				horizontal_space = (shadow + margin) * 2,
				vertical_space = (shadow + margin) * 2,
				double_padding = (currentOpts.padding * 2),

				ratio;

			if (currentOpts.width.toString().indexOf('%') > -1)
			{
				to.width = ((view[0] * parseFloat(currentOpts.width)) / 100) - (shadow * 2);
				resize = false;

			} else
			{
				to.width = currentOpts.width + double_padding;
			}

			if (currentOpts.height.toString().indexOf('%') > -1)
			{
				to.height = ((view[1] * parseFloat(currentOpts.height)) / 100) - (shadow * 2);
				resize = false;

			} else
			{
				to.height = currentOpts.height + double_padding;
			}

			if (resize && (to.width > (view[0] - horizontal_space) || to.height > (view[1] - vertical_space)))
			{
				if (selectedOpts.type == 'image' || selectedOpts.type == 'swf')
				{
					horizontal_space += double_padding;
					vertical_space += double_padding;

					ratio = Math.min(Math.min(view[0] - horizontal_space, currentOpts.width) / currentOpts.width, Math.min(view[1] - vertical_space, currentOpts.height) / currentOpts.height);

					to.width = Math.round(ratio * (to.width - double_padding)) + double_padding;
					to.height = Math.round(ratio * (to.height - double_padding)) + double_padding;

				} else
				{
					to.width = Math.min(to.width, (view[0] - horizontal_space));
					to.height = Math.min(to.height, (view[1] - vertical_space));
				}
			}

			to.top = view[3] + ((view[1] - (to.height + (shadow * 2))) * 0.5);
			to.left = view[2] + ((view[0] - (to.width + (shadow * 2))) * 0.5);

			if (currentOpts.autoScale === false)
			{
				to.top = Math.max(view[3] + margin, to.top);
				to.left = Math.max(view[2] + margin, to.left);
			}

			return to;
		},

		layerbox_format_title = function(title)
		{
			if (title && title.length)
			{
				switch (currentOpts.titlePosition)
				{
					case 'inside':
						return title;
					case 'over':
						return '<span id="layerbox-title-over">' + title + '</span>';
					default:
						return '<span id="layerbox-title-wrap"><span id="layerbox-title-left"></span><span id="layerbox-title-main">' + title + '</span><span id="layerbox-title-right"></span></span>';
				}
			}

			return false;
		},

		layerbox_process_title = function()
		{
			var title = currentOpts.title,
				width = final_pos.width - (currentOpts.padding * 2),
				titlec = 'layerbox-title-' + currentOpts.titlePosition;

			$('#layerbox-title').remove();

			titleh = 0;

			if (currentOpts.titleShow === false)
			{
				return;
			}

			title = $.isFunction(currentOpts.titleFormat) ? currentOpts.titleFormat(title, currentArray, currentIndex, currentOpts) : layerbox_format_title(title);

			if (!title || title === '')
			{
				return;
			}

			$('<div id="layerbox-title" class="' + titlec + '" />').css({
				'width': width,
				'paddingLeft': currentOpts.padding,
				'paddingRight': currentOpts.padding
			}).html(title).appendTo('body');

			switch (currentOpts.titlePosition)
			{
				case 'inside':
					titleh = $("#layerbox-title").outerHeight(true) - currentOpts.padding;
					final_pos.height += titleh;
					break;

				case 'over':
					$('#layerbox-title').css('bottom', currentOpts.padding);
					break;

				default:
					$('#layerbox-title').css('bottom', $("#layerbox-title").outerHeight(true) * -1);
					break;
			}

			$('#layerbox-title').appendTo(outer).hide();
		},

		layerbox_set_navigation = function()
		{
			$(document).unbind('keydown.fb').bind('keydown.fb', function(e)
			{
				if (e.keyCode == 27 && currentOpts.enableEscapeButton)
				{
					e.preventDefault();
					$.layerbox.close();

				} else if (e.keyCode == 37)
				{
					e.preventDefault();
					$.layerbox.prev();

				} else if (e.keyCode == 39)
				{
					e.preventDefault();
					$.layerbox.next();
				}
			});

			if ($.fn.mousewheel)
			{
				wrap.unbind('mousewheel.fb');

				if (currentArray.length > 1)
				{
					wrap.bind('mousewheel.fb', function(e, delta)
					{
						e.preventDefault();

						if (busy || delta === 0)
						{
							return;
						}

						if (delta > 0)
						{
							$.layerbox.prev();
						} else
						{
							$.layerbox.next();
						}
					});
				}
			}

			if (!currentOpts.showNavArrows) { return; }

			if ((currentOpts.cyclic && currentArray.length > 1) || currentIndex !== 0)
			{
				nav_left.show();
			}

			if ((currentOpts.cyclic && currentArray.length > 1) || currentIndex != (currentArray.length - 1))
			{
				nav_right.show();
			}
		},

		layerbox_preload_images = function()
		{
			var href,
				objNext;

			if ((currentArray.length - 1) > currentIndex)
			{
				href = currentArray[currentIndex + 1].href;

				if (typeof href !== 'undefined' && href.match(imgRegExp))
				{
					objNext = new Image();
					objNext.src = href;
				}
			}

			if (currentIndex > 0)
			{
				href = currentArray[currentIndex - 1].href;

				if (typeof href !== 'undefined' && href.match(imgRegExp))
				{
					objNext = new Image();
					objNext.src = href;
				}
			}
		},

		_finish = function()
		{
			inner.css('overflow', (currentOpts.scrolling == 'auto' ? (currentOpts.type == 'image' || currentOpts.type == 'iframe' || currentOpts.type == 'swf' ? 'hidden' : 'auto') : (currentOpts.scrolling == 'yes' ? 'auto' : 'visible')));

			if (!$.support.opacity)
			{
				inner.get(0).style.removeAttribute('filter');
				wrap.get(0).style.removeAttribute('filter');
			}

			$('#layerbox-title').show();

			if (currentOpts.hideOnContentClick)
			{
				inner.one('click', $.layerbox.close);
			}
			if (currentOpts.hideOnOverlayClick)
			{
				overlay.one('click', $.layerbox.close);
			}

			if (currentOpts.showCloseButton)
			{
				close.show();
			}

			layerbox_set_navigation();

			$(window).bind("resize.fb", $.layerbox.center);

			if (currentOpts.centerOnScroll)
			{
				$(window).bind("scroll.fb", $.layerbox.center);
			} else
			{
				$(window).unbind("scroll.fb");
			}

			if ($.isFunction(currentOpts.onComplete))
			{
				currentOpts.onComplete(currentArray, currentIndex, currentOpts);
			}

			busy = false;

			layerbox_preload_images();
		},

		layerbox_draw = function(pos)
		{
			var width = Math.round(start_pos.width + (final_pos.width - start_pos.width) * pos),
				height = Math.round(start_pos.height + (final_pos.height - start_pos.height) * pos),

				top = Math.round(start_pos.top + (final_pos.top - start_pos.top) * pos),
				left = Math.round(start_pos.left + (final_pos.left - start_pos.left) * pos);

			wrap.css({
				'width': width + 'px',
				'height': height + 'px',
				'top': top + 'px',
				'left': left + 'px'
			});

			width = Math.max(width - currentOpts.padding * 2, 0);
			height = Math.max(height - (currentOpts.padding * 2 + (titleh * pos)), 0);

			inner.css({
				'width': width + 'px',
				'height': height + 'px'
			});

			if (typeof final_pos.opacity !== 'undefined')
			{
				wrap.css('opacity', (pos < 0.5 ? 0.5 : pos));
			}
		},

		layerbox_get_obj_pos = function(obj)
		{
			var pos = obj.offset();

			pos.top += parseFloat(obj.css('paddingTop')) || 0;
			pos.left += parseFloat(obj.css('paddingLeft')) || 0;

			pos.top += parseFloat(obj.css('border-top-width')) || 0;
			pos.left += parseFloat(obj.css('border-left-width')) || 0;

			pos.width = obj.width();
			pos.height = obj.height();

			return pos;
		},

		layerbox_get_zoom_from = function()
		{
			var orig = selectedOpts.orig ? $(selectedOpts.orig) : false,
				from = {},
				pos,
				view;

			if (orig && orig.length)
			{
				pos = layerbox_get_obj_pos(orig);

				from = {
					width: (pos.width + (currentOpts.padding * 2)),
					height: (pos.height + (currentOpts.padding * 2)),
					top: (pos.top - currentOpts.padding - shadow),
					left: (pos.left - currentOpts.padding - shadow)
				};

			} else
			{
				view = layerbox_get_viewport();

				from = {
					width: 1,
					height: 1,
					top: view[3] + view[1] * 0.5,
					left: view[2] + view[0] * 0.5
				};
			}

			return from;
		},

		layerbox_show = function()
		{
			loading.hide();

			if (wrap.is(":visible") && $.isFunction(currentOpts.onCleanup))
			{
				if (currentOpts.onCleanup(currentArray, currentIndex, currentOpts) === false)
				{
					$.event.trigger('layerbox-cancel');

					busy = false;
					return;
				}
			}

			currentArray = selectedArray;
			currentIndex = selectedIndex;
			currentOpts = selectedOpts;

			inner.get(0).scrollTop = 0;
			inner.get(0).scrollLeft = 0;

			if (currentOpts.overlayShow)
			{
				if (isIE6)
				{
					$('select:not(#layerbox-tmp select)').filter(function()
					{
						return this.style.visibility !== 'hidden';
					}).css({ 'visibility': 'hidden' }).one('layerbox-cleanup', function()
					{
						this.style.visibility = 'inherit';
					});
				}

				overlay.css({
					'background-color': currentOpts.overlayColor,
					'opacity': currentOpts.overlayOpacity
				}).unbind().show();
			}

			final_pos = layerbox_get_zoom_to();

			layerbox_process_title();

			if (wrap.is(":visible"))
			{
				$(close.add(nav_left).add(nav_right)).hide();

				var pos = wrap.position(),
					equal;

				start_pos = {
					top: pos.top,
					left: pos.left,
					width: wrap.width(),
					height: wrap.height()
				};

				equal = (start_pos.width == final_pos.width && start_pos.height == final_pos.height);

				inner.fadeOut(currentOpts.changeFade, function()
				{
					var finish_resizing = function()
					{
						inner.html(tmp.contents()).fadeIn(currentOpts.changeFade, _finish);
					};

					$.event.trigger('layerbox-change');

					inner.empty().css('overflow', 'hidden');

					if (equal)
					{
						inner.css({
							top: currentOpts.padding,
							left: currentOpts.padding,
							width: Math.max(final_pos.width - (currentOpts.padding * 2), 1),
							height: Math.max(final_pos.height - (currentOpts.padding * 2) - titleh, 1)
						});

						finish_resizing();

					} else
					{
						inner.css({
							top: currentOpts.padding,
							left: currentOpts.padding,
							width: Math.max(start_pos.width - (currentOpts.padding * 2), 1),
							height: Math.max(start_pos.height - (currentOpts.padding * 2), 1)
						});

						fx.prop = 0;

						$(fx).animate({ prop: 1 }, {
							duration: currentOpts.changeSpeed,
							easing: currentOpts.easingChange,
							step: layerbox_draw,
							complete: finish_resizing
						});
					}
				});

				return;
			}

			wrap.css('opacity', 1);

			if (currentOpts.transitionIn == 'elastic')
			{
				start_pos = layerbox_get_zoom_from();

				inner.css({
					top: currentOpts.padding,
					left: currentOpts.padding,
					width: Math.max(start_pos.width - (currentOpts.padding * 2), 1),
					height: Math.max(start_pos.height - (currentOpts.padding * 2), 1)
				})
					.html(tmp.contents());

				wrap.css(start_pos).show();

				if (currentOpts.opacity)
				{
					final_pos.opacity = 0;
				}

				fx.prop = 0;

				$(fx).animate({ prop: 1 }, {
					duration: currentOpts.speedIn,
					easing: currentOpts.easingIn,
					step: layerbox_draw,
					complete: _finish
				});

			} else
			{
				inner.css({
					top: currentOpts.padding,
					left: currentOpts.padding,
					width: Math.max(final_pos.width - (currentOpts.padding * 2), 1),
					height: Math.max(final_pos.height - (currentOpts.padding * 2) - titleh, 1)
				})
					.html(tmp.contents());

				wrap.css(final_pos).fadeIn(currentOpts.transitionIn == 'none' ? 0 : currentOpts.speedIn, _finish);
			}
		},

		layerbox_process_inline = function()
		{
			tmp.width(selectedOpts.width);
			tmp.height(selectedOpts.height);

			if (selectedOpts.width == 'auto')
			{
				selectedOpts.width = tmp.width();
			}
			if (selectedOpts.height == 'auto')
			{
				selectedOpts.height = tmp.height();
			}

			layerbox_show();
		},

		layerbox_process_image = function()
		{
			busy = true;

			selectedOpts.width = imgPreloader.width;
			selectedOpts.height = imgPreloader.height;

			$("<img />").attr({
				'id': 'layerbox-img',
				'src': imgPreloader.src,
				'alt': selectedOpts.title
			}).appendTo(tmp);

			layerbox_show();
		},

		layerbox_start = function()
		{
			layerbox_abort();

			var obj = selectedArray[selectedIndex],
				href,
				type,
				title,
				str,
				emb,
				selector,
				data;

			selectedOpts = $.extend({}, $.fn.layerbox.defaults, (typeof $(obj).data('layerbox') == 'undefined' ? selectedOpts : $(obj).data('layerbox')));
			title = obj.title || $(obj).title || selectedOpts.title || '';

			if (obj.nodeName && !selectedOpts.orig)
			{
				selectedOpts.orig = $(obj).children("img:first").length ? $(obj).children("img:first") : $(obj);
			}

			if (title === '' && selectedOpts.orig)
			{
				title = selectedOpts.orig.attr('alt');
			}

			if (obj.nodeName && (/^(?:javascript|#)/i).test(obj.href))
			{
				href = selectedOpts.href || null;
			} else
			{
				href = selectedOpts.href || obj.href || null;
			}

			if (selectedOpts.type)
			{
				type = selectedOpts.type;

				if (!href)
				{
					href = selectedOpts.content;
				}

			} else if (selectedOpts.content)
			{
				type = 'html';

			} else if (href)
			{
				if (href.match(imgRegExp))
				{
					type = 'image';

				} else if (href.match(swfRegExp))
				{
					type = 'swf';

				} else if ($(obj).hasClass("iframe"))
				{
					type = 'iframe';

				} else if (href.match(/#/))
				{
					obj = href.substr(href.indexOf("#"));

					type = $(obj).length > 0 ? 'inline' : 'ajax';
				} else
				{
					type = 'ajax';
				}
			} else
			{
				type = 'inline';
			}

			selectedOpts.type = type;
			selectedOpts.href = href;
			selectedOpts.title = title;

			if (selectedOpts.autoDimensions && selectedOpts.type !== 'iframe' && selectedOpts.type !== 'swf')
			{
				selectedOpts.width = 'auto';
				selectedOpts.height = 'auto';
			}

			if (selectedOpts.modal)
			{
				selectedOpts.overlayShow = true;
				selectedOpts.hideOnOverlayClick = false;
				selectedOpts.hideOnContentClick = false;
				selectedOpts.enableEscapeButton = false;
				selectedOpts.showCloseButton = false;
			}

			if ($.isFunction(selectedOpts.onStart))
			{
				if (selectedOpts.onStart(selectedArray, selectedIndex, selectedOpts) === false)
				{
					busy = false;
					return;
				}
			}

			tmp.css('padding', (shadow + selectedOpts.padding + selectedOpts.margin));

			$('.layerbox-inline-tmp').unbind('layerbox-cancel').bind('layerbox-change', function()
			{
				$(this).replaceWith(inner.children());
			});

			switch (type)
			{
				case 'html':
					tmp.html(selectedOpts.content);
					layerbox_process_inline();
					break;

				case 'inline':
					$('<div class="layerbox-inline-tmp" />').hide().insertBefore($(obj)).bind('layerbox-cleanup', function()
					{
						$(this).replaceWith(inner.children());
					}).bind('layerbox-cancel', function()
					{
						$(this).replaceWith(tmp.children());
					});

					$(obj).appendTo(tmp);

					layerbox_process_inline();
					break;

				case 'image':
					busy = false;

					$.layerbox.showActivity();

					imgPreloader = new Image();

					imgPreloader.onerror = function()
					{
						layerbox_error();
					};

					imgPreloader.onload = function()
					{
						imgPreloader.onerror = null;
						imgPreloader.onload = null;
						layerbox_process_image();
					};

					imgPreloader.src = href;

					break;

				case 'swf':
					str = '<object classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000" width="' + selectedOpts.width + '" height="' + selectedOpts.height + '"><param name="movie" value="' + href + '"></param>';
					emb = '';

					$.each(selectedOpts.swf, function(name, val)
					{
						str += '<param name="' + name + '" value="' + val + '"></param>';
						emb += ' ' + name + '="' + val + '"';
					});

					str += '<embed src="' + href + '" type="application/x-shockwave-flash" width="' + selectedOpts.width + '" height="' + selectedOpts.height + '"' + emb + '></embed></object>';

					tmp.html(str);

					layerbox_process_inline();
					break;

				case 'ajax':
					selector = href.split('#', 2);
					data = selectedOpts.ajax.data || {};

					if (selector.length > 1)
					{
						href = selector[0];

						if (typeof data == "string")
						{
							data += '&selector=' + selector[1];
						} else
						{
							data.selector = selector[1];
						}
					}

					busy = false;
					$.layerbox.showActivity();

					ajaxLoader = $.ajax($.extend(selectedOpts.ajax, {
						url: href,
						data: data,
						error: layerbox_error,
						success: function(data, textStatus, XMLHttpRequest)
						{
							if (ajaxLoader.status == 200)
							{
								tmp.html(data);
								layerbox_process_inline();
							}
						}
					}));

					break;

				case 'iframe':
					$('<iframe id="' + selectedOpts.iframeid + '" name="' + selectedOpts.iframeid + new Date().getTime() + '" class="user-frame-id" frameborder="0" hspace="0" scrolling="' + selectedOpts.scrolling + '" src="' + selectedOpts.href + '"></iframe>').appendTo(tmp);
					//$('<iframe id="layerbox-frame" value="10" name="layerbox-frame' + new Date().getTime() + '" frameborder="0" hspace="0" scrolling="' + selectedOpts.scrolling + '" src="' + selectedOpts.href + '"></iframe>').appendTo(tmp);
					layerbox_show();
					break;
			}
		},

		layerbox_animate_loading = function()
		{
			if (!loading.is(':visible'))
			{
				clearInterval(loadingTimer);
				return;
			}

			$('div', loading).css('top', (loadingFrame * -40) + 'px');

			loadingFrame = (loadingFrame + 1) % 12;
		},

		layerbox_init = function()
		{
			if ($("#layerbox-wrap").length)
			{
				return;
			}

			$('body').append(
				tmp = $('<div id="layerbox-tmp"></div>'),
				loading = $('<div id="layerbox-loading"><div></div></div>'),
				overlay = $('<div id="layerbox-overlay"></div>'),
				wrap = $('<div id="layerbox-wrap"></div>')
			);

			if (!$.support.opacity)
			{
				wrap.addClass('layerbox-ie');
				loading.addClass('layerbox-ie');
			}

			outer = $('<div id="layerbox-outer"></div>')
				.append('<div class="layer-bg" id="layer-bg-n"></div><div class="layer-bg" id="layer-bg-ne"></div><div class="layer-bg" id="layer-bg-e"></div><div class="layer-bg" id="layer-bg-se"></div><div class="layer-bg" id="layer-bg-s"></div><div class="layer-bg" id="layer-bg-sw"></div><div class="layer-bg" id="layer-bg-w"></div><div class="layer-bg" id="layer-bg-nw"></div>')
				.appendTo(wrap);

			outer.append(
				inner = $('<div id="layerbox-inner"></div>'),
				close = $('<a id="layerbox-close"></a>'),

				nav_left = $('<a href="javascript:;" id="layerbox-left"><span class="layer-ico" id="layerbox-left-ico"></span></a>'),
				nav_right = $('<a href="javascript:;" id="layerbox-right"><span class="layer-ico" id="layerbox-right-ico"></span></a>')
			);

			close.click($.layerbox.close);
			loading.click($.layerbox.cancel);

			nav_left.click(function(e)
			{
				e.preventDefault();
				$.layerbox.prev();
			});

			nav_right.click(function(e)
			{
				e.preventDefault();
				$.layerbox.next();
			});

			if (isIE6)
			{
				overlay.get(0).style.setExpression('height', "document.body.scrollHeight > document.body.offsetHeight ? document.body.scrollHeight : document.body.offsetHeight + 'px'");
				loading.get(0).style.setExpression('top', "(-20 + (document.documentElement.clientHeight ? document.documentElement.clientHeight/2 : document.body.clientHeight/2 ) + ( ignoreMe = document.documentElement.scrollTop ? document.documentElement.scrollTop : document.body.scrollTop )) + 'px'");

				outer.prepend('<iframe id="layerbox-hide-sel-frame" src="javascript:\'\';" scrolling="no" frameborder="0" ></iframe>');
			}
		};

	/*
	* Public methods 
	*/

	$.fn.layerbox = function(options)
	{
		$(this)
			.data('layerbox', $.extend({}, options, ($.metadata ? $(this).metadata() : {})))
			.unbind('click.fb').bind('click.fb', function(e)
			{
				e.preventDefault();

				if (busy)
				{
					return;
				}

				busy = true;

				$(this).blur();

				selectedArray = [];
				selectedIndex = 0;

				var rel = $(this).attr('rel') || '';

				if (!rel || rel == '' || rel === 'nofollow')
				{
					selectedArray.push(this);

				} else
				{
					selectedArray = $("a[rel=" + rel + "], area[rel=" + rel + "]");
					selectedIndex = selectedArray.index(this);
				}

				layerbox_start();

				return false;
			});

		return this;
	};

	$.layerbox = function(obj)
	{
		if (busy)
		{
			return;
		}

		busy = true;

		var opts = typeof arguments[1] !== 'undefined' ? arguments[1] : {};

		selectedArray = [];
		selectedIndex = opts.index || 0;

		if ($.isArray(obj))
		{
			for (var i = 0, j = obj.length; i < j; i++)
			{
				if (typeof obj[i] == 'object')
				{
					$(obj[i]).data('layerbox', $.extend({}, opts, obj[i]));
				} else
				{
					obj[i] = $({}).data('layerbox', $.extend({ content: obj[i] }, opts));
				}
			}

			selectedArray = jQuery.merge(selectedArray, obj);

		} else
		{
			if (typeof obj == 'object')
			{
				$(obj).data('layerbox', $.extend({}, opts, obj));
			} else
			{
				obj = $({}).data('layerbox', $.extend({ content: obj }, opts));
			}

			selectedArray.push(obj);
		}

		if (selectedIndex > selectedArray.length || selectedIndex < 0)
		{
			selectedIndex = 0;
		}

		layerbox_start();
	};

	$.layerbox.showActivity = function()
	{
		clearInterval(loadingTimer);

		loading.show();
		loadingTimer = setInterval(layerbox_animate_loading, 66);
	};

	$.layerbox.hideActivity = function()
	{
		loading.hide();
	};

	$.layerbox.next = function()
	{
		return $.layerbox.pos(currentIndex + 1);
	};

	$.layerbox.prev = function()
	{
		return $.layerbox.pos(currentIndex - 1);
	};

	$.layerbox.pos = function(pos)
	{
		if (busy)
		{
			return;
		}

		pos = parseInt(pos, 10);

		if (pos > -1 && currentArray.length > pos)
		{
			selectedIndex = pos;
			layerbox_start();
		}

		if (currentOpts.cyclic && currentArray.length > 1 && pos < 0)
		{
			selectedIndex = currentArray.length - 1;
			layerbox_start();
		}

		if (currentOpts.cyclic && currentArray.length > 1 && pos >= currentArray.length)
		{
			selectedIndex = 0;
			layerbox_start();
		}

		return;
	};

	$.layerbox.cancel = function()
	{
		if (busy)
		{
			return;
		}

		busy = true;

		$.event.trigger('layerbox-cancel');

		layerbox_abort();

		if (selectedOpts && $.isFunction(selectedOpts.onCancel))
		{
			selectedOpts.onCancel(selectedArray, selectedIndex, selectedOpts);
		}

		busy = false;
	};

	// Note: within an iframe use - parent.$.layerbox.close();
	$.layerbox.close = function()
	{
		if (busy || wrap.is(':hidden'))
		{
			return;
		}

		busy = true;

		if (currentOpts && $.isFunction(currentOpts.onCleanup))
		{
			if (currentOpts.onCleanup(currentArray, currentIndex, currentOpts) === false)
			{
				busy = false;
				return;
			}
		}

		layerbox_abort();

		$(close.add(nav_left).add(nav_right)).hide();

		$('#layerbox-title').remove();

		wrap.add(inner).add(overlay).unbind();

		$(window).unbind("resize.fb scroll.fb");
		$(document).unbind('keydown.fb');

		function _cleanup()
		{
			overlay.fadeOut('fast');

			wrap.hide();

			$.event.trigger('layerbox-cleanup');

			inner.empty();

			if ($.isFunction(currentOpts.onClosed))
			{
				currentOpts.onClosed(currentArray, currentIndex, currentOpts);
			}

			currentArray = selectedOpts = [];
			currentIndex = selectedIndex = 0;
			currentOpts = selectedOpts = {};

			busy = false;
		}

		inner.css('overflow', 'hidden');

		if (currentOpts.transitionOut == 'elastic')
		{
			start_pos = layerbox_get_zoom_from();

			var pos = wrap.position();

			final_pos = {
				top: pos.top,
				left: pos.left,
				width: wrap.width(),
				height: wrap.height()
			};

			if (currentOpts.opacity)
			{
				final_pos.opacity = 1;
			}

			fx.prop = 1;

			$(fx).animate({ prop: 0 }, {
				duration: currentOpts.speedOut,
				easing: currentOpts.easingOut,
				step: layerbox_draw,
				complete: _cleanup
			});

		} else
		{
			wrap.fadeOut(currentOpts.transitionOut == 'none' ? 0 : currentOpts.speedOut, _cleanup);
		}
	};

	$.layerbox.resize = function()
	{
		var c, h;

		if (busy || wrap.is(':hidden'))
		{
			return;
		}

		busy = true;

		c = inner.wrapInner("<div style='overflow:auto'></div>").children();
		h = c.height();

		wrap.css({ height: h + (currentOpts.padding * 2) + titleh });
		inner.css({ height: h });

		c.replaceWith(c.children());

		$.layerbox.center();
	};

	$.layerbox.center = function()
	{
		busy = true;

		var view = layerbox_get_viewport(),
			margin = currentOpts.margin,
			to = {};

		to.top = view[3] + ((view[1] - ((wrap.height() - titleh) + (shadow * 2))) * 0.5);
		to.left = view[2] + ((view[0] - (wrap.width() + (shadow * 2))) * 0.5);

		to.top = Math.max(view[3] + margin, to.top);
		to.left = Math.max(view[2] + margin, to.left);

		wrap.css(to);

		busy = false;
	};

	$.fn.layerbox.defaults = {
		padding: 10,
		margin: 20,
		opacity: false,
		modal: false,
		cyclic: false,
		scrolling: 'auto', // 'auto', 'yes' or 'no'

		iframeid: '',

		width: 560,
		height: 340,

		autoScale: false,
		autoDimensions: false,
		centerOnScroll: false,

		ajax: {},
		swf: { wmode: 'transparent' },

		hideOnOverlayClick: true,
		hideOnContentClick: true,

		overlayShow: true,
		overlayOpacity: 0.3,
		overlayColor: '#666',

		titleShow: true,
		titlePosition: 'outside', // 'outside', 'inside' or 'over'
		titleFormat: null,

		transitionIn: 'fade', // 'elastic', 'fade' or 'none'
		transitionOut: 'fade', // 'elastic', 'fade' or 'none'

		speedIn: 500,
		speedOut: 500,

		changeSpeed: 500,
		changeFade: 'fast',

		easingIn: 'swing',
		easingOut: 'swing',

		showCloseButton: true,
		showNavArrows: true,
		enableEscapeButton: true,

		onStart: null,
		onCancel: null,
		onComplete: null,
		onCleanup: null,
		onClosed: null
	};

	$(document).ready(function()
	{
		layerbox_init();
	});

})(jQuery);