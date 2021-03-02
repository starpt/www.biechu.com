/************************************************
 * 2020-07-25
 * gky@qq.com
 * 拖动控件
 ************************************************/

!(function ($) {
	let win = $(window)
	$.fn.drag = function (margin, title) {
		title = title || 'h4'
		let start = this.children(title)
		let drag = this.css('position', 'fixed')
		start = start.length ? start : drag
		drag.move = false
		start.css('cursor', 'move').on('mousedown', e => {
			if (drag.move) return
			drag.move = true
			let offset = drag.offset()
			margin = $.dragMargin ? null : margin
			if (margin == 'left') {
				$.dragMargin = offset.left
			} else if (margin == 'top') {
				$.dragMargin = offset.top
			} else if (margin && typeof margin == 'number') {
				$.dragMargin = margin
			}
			drag.x = offset.left - e.clientX - win.scrollLeft()
			drag.y = offset.top - e.clientY - win.scrollTop()
			let mousemove = e => {
				if (!drag.move) return
				drag.css({
					top: e.clientY + drag.y,
					left: e.clientX + drag.x
				})
				return false
			}
			let mouseup = () => {
				let margin = $.dragMargin || 12
				let animate = drag.offset()
				if (animate.top + drag[0].offsetHeight + margin > win.height()) animate.top = win.height() - drag[0].offsetHeight - margin
				if (animate.top < margin) animate.top = margin
				if (animate.left + drag[0].offsetWidth + margin > win.width()) animate.left = win.width() - drag[0].offsetWidth - margin
				if (animate.left < margin) animate.left = margin
				drag.animate(animate, 200)
				drag.move = false
				win.off('mousemove', mousemove).off('mouseup', mouseup)
			}
			win.on('mousemove', mousemove).on('mouseup', mouseup)
		})
		return this
	}
})(window.$)
