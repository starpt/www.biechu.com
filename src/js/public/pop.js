/**
 * 2021-01-17
 * star@biechu.com
 * 弹窗对话框
 * @params config = {}
 * mask 是否有背景遮罩 1 点击不关闭 其它关闭
 * show 是否自动显示
 * tag: 弹窗框体属性 默认 div
 * id 唯一标识
 * css 弹窗样式 tips, dialog 默认无
 * titel 标题提示
 * body 主要内容 html
 * button 底部按钮 [{css 样式, text文字, click 点击事件}]
 * foot 底部内容 html
 * drag 是否可以拖动，默认不可拖动
 * delay 等待多少毫秒后自动关闭, 默认不关闭
 */

!(function ($) {
	// 按键绑定
	let win = $(window).on('keydown', e => {
		// 回车
		if (e.keyCode === 13 && e.target.className !== 'confirm') return false

		// ESC
		if (e.keyCode === 27) {
			let main = $('body>.Mask:visible,body>.Pop:visible').eq(-1)
			if (main.length) main.close()
		}
	})

	// 关闭事件
	$.fn.close = function () {
		let self = this
		self.animate({opacity: 0}, 400, () => {
			self
				.css({
					transform: '',
					opacity: '',
					display: 'none'
				})
				.children('.Pop')
				.css({transform: ''})
			if (!self[0].id) this.remove()
		})
		return self
	}

	$.pop = function (config) {
		config = config || {}

		// 显示
		let show = () => {
			main.css({
				display: 'block',
				zIndex: 9 + $('body>.Mask:visible,body>.Pop:visible').length
			})
			pop.css({display: 'block'})

			if (config.title) {
				let title = pop.children('h4')
				if (title.length) {
					if (title.html() != config.title) title.html(config.title)
				} else {
					$('<h4>' + config.title + '</h4>').appendTo(pop)
				}
			}

			let body = pop.children('.body')
			if (body.length) {
				if (!config.id) body.html(config.body)
			} else {
				$('<div class="body"' + (config.title ? ' style="padding-top:18px"' : '') + '>' + (config.body || '') + '</div><i class="close"></i>').appendTo(pop)
			}

			// 渲染按钮,并绑定事件
			let button = pop.children('.button')
			config.button = config.button || []
			if (config.button.length) {
				if (button.length === 0) button = $('<div class="button">').appendTo(pop)
				if (button.html() === '' || !config.id) {
					for (let i = 0; i < config.button.length; i++) {
						$('<button' + (config.button[i].type ? ' type="' + config.button[i].type + '"' : '') + ' class="' + (config.button[i].css || '') + '">' + (config.button[i].text || '') + '</button>')
							.appendTo(button)
							.click(config.button[i].click)[0].close = () => main.close()
					}
				}
			} else {
				button.remove()
			}

			// 渲染底部
			let foot = pop.children('.foot')
			if (config.foot) {
				if (foot.length === 0) foot = $('<div class="foot">').appendTo(pop)
				if (foot.html() === '' || !config.id) foot.html(config.foot)
			} else {
				foot.remove()
			}

			// 关闭和取消事件绑定
			pop
				.find('.close')
				.off('click')
				.on('click', () => main.close())

			// 确认按钮获得焦点
			pop.find('>.button>.confirm:last').focus()

			// 定时关闭
			if (typeof config.delay === 'number')
				setTimeout(() => {
					main.close()
				}, config.delay)

			// 绑定拖动事件
			if (config.drag) pop.drag()

			// 自动居中
			setTimeout(() => {
				pop.css({
					transform: 'scale(1,1)',
					left: (win.width() - pop[0].offsetWidth) / 2,
					top: (win.height() - pop[0].offsetHeight) / 3
				})
			}, 100)

			return main
		}

		let main, mask, pop
		if (config.id) main = $('#' + config.id)
		if (main && main.length) {
			if (config.mask) {
				mask = main
				pop = main.children('.Pop')
			} else {
				pop = main
			}
		} else {
			if (config.mask) {
				main = mask = $('<div' + (config.id ? ' id="' + config.id + '"' : ' ') + ' class="Mask">')
					.appendTo('body')
					.click(function (e) {
						if (config.mask !== 1 && e.target === this) {
							$(this).close(!config.id)
						}
					})
			}
			pop = (config.tag ? $(config.tag) : $('<div>')).appendTo(mask || 'body').attr({
				id: config.id && !config.mask ? config.id : null,
				class: 'Pop' + (config.css ? ' ' + config.css : '')
			})
			main = mask || pop
		}
		if (config.show) show()

		// 绑定关闭事件
		main.extend({close: main.close, show})
		return main
	}

	$.alert = (body, confirm) => {
		$.pop({
			css: 'dialog',
			body: '<i class="iconfont">&#xe630;</i>' + body,
			mask: 1,
			show: 1,
			button: [
				{
					text: '确定',
					css: 'confirm',
					click: function () {
						this.close()
					}
				}
			]
		}).close = function () {
			if (confirm instanceof Function) confirm()
			if (this.hide instanceof Function) {
				this.hide()
			} else {
				this.hide = this.close
			}
		}
	}

	$.confirm = (body, confirm, cancel) => {
		$.pop({
			css: 'dialog',
			body: '<i class="iconfont">&#xe630;</i>' + body,
			mask: 1,
			show: 1,
			button: [
				{
					text: '确定',
					css: 'confirm',
					click: function () {
						if (confirm instanceof Function) confirm()
						this.close()
					}
				},
				{
					text: '取消',
					css: 'cancel',
					click: function () {
						this.close()
					}
				}
			]
		}).close = function () {
			if (cancel instanceof Function) cancel()
			if (this.hide instanceof Function) {
				this.hide()
			} else {
				this.hide = this.close
			}
		}
	}

	$.tips = (body, delay) => {
		$.pop({
			id: 'tips',
			css: 'tips',
			body,
			show: 1,
			delay: delay || 3000
		})
	}
})(window.$)
