/**
 * 2021-01-17
 * star@biechu.com
 * 弹窗对话框
 * @params config = {}
 * mask 是否有背景遮罩 1 点击不关闭 其它关闭
 * css 弹窗样式 tips, dialog 默认无
 * width 宽度
 * titel 标题提示
 * body 主要内容 html
 * button 底部按钮 [{css 样式, text文字, click 点击事件}]
 * foot 底部内容 html
 * drag 是否可以拖动，默认不可拖动
 * delay 等待多少毫秒后自动关闭, 默认不关闭
 */

!(function ($) {
	$.pop = function (config) {
		config = config || {}
		let close = () => {
			if (pop) {
				pop.animate({opacity: 0}, 400, () => {
					pop.remove()
					pop = null
				})
			}
			if (mask) {
				mask.animate({opacity: 0}, 400, () => {
					mask.remove()
					mask = null
				})
			}
			win.off('keydown')
		}
		let mask = config.mask
			? $('<div class="Mask">')
					.css('zIndex', '9' + $('.Mask').length)
					.appendTo('body')
					.click(function (e) {
						if (config.mask !== 1 && e.target === this) {
							close()
						}
					})
			: null

		let pop = $('<div class="Pop' + (config.css ? ' ' + config.css : '') + '">')
			.appendTo(mask || 'body')
			.html((config.title ? '<h4 class="title">' + config.title + '</h4>' : '') + '<div class="body"' + (config.title ? ' style="padding-top:18px"' : '') + '>' + (config.body || '') + '</div>\
			<i class="close"></i>')
		if (!mask) pop.css('zIndex', '9' + $('.Pop').length)

		config.button = config.button || []
		if (config.button.length) {
			let button = $('<div class="button">')
			for (let i = 0; i < config.button.length; i++) {
				$('<button class="' + (config.button[i].css || '') + '">' + (config.button[i].text || '') + '</button>')
					.appendTo(button)
					.click(config.button[i].click)[0].close = close
			}
			button.appendTo(pop).children('.confirm').focus()
		}

		if (config.foot) {
			$('<div class="foot">' + config.foot + '</div>').appendTo(pop)
		}
		pop.find('.close,.cancel').click(close)

		let win = $(window).on('keydown', e => {
			// 回车
			if (e.keyCode === 13 && e.target.className !== 'confirm') return false

			// ESC
			if (e.keyCode === 27) close()
		})
		pop.css({
			left: win.width() / 2 - pop.width() / 2,
			top: win.height() / 3 - pop.height() / 3,
			width: config.width,
			transform: 'scale(1,1)'
		})
		if (config.drag) pop.drag()
		if (typeof config.delay === 'number') {
			setTimeout(close, config.delay)
		}
		return pop
	}
	$.alert = body => {
		$.pop({
			css: 'dialog',
			body,
			mask: 1,
			button: [
				{
					text: '确定',
					css: 'confirm',
					click: function () {
						this.close()
					}
				}
			]
		})
	}

	$.confirm = (body, callback) => {
		$.pop({
			css: 'dialog',
			body,
			mask: 1,
			button: [
				{
					text: '确定',
					css: 'confirm',
					click: function () {
						if (callback instanceof Function) callback()
						this.close()
					}
				},
				{
					text: '取消',
					css: 'cancel'
				}
			]
		})
	}

	$.tips = (body, delay) => {
		$.pop({
			css: 'tips',
			body,
			delay: delay || 3000
		})
	}
})(window.$)
