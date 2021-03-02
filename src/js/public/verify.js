/************************************************
 * 2021-01-30
 * gky@qq.com
 * 表单校验
 ************************************************/

!(function ($) {
	$.fn.verify = function (turn) {
		let focus,
			error = (item, msg, html) => {
				if (!focus || turn) {
					item.addClass('error')
					msg.show().html('<i class="iconfont">&#xe630;</i>' + html + '!')
				}
				focus = focus ? focus : item
			}
		this.find('input[rules],select[rules],textarea[rules]').each((_, item) => {
			let val = '',
				tag = item.tagName,
				type = item.type,
				html = item.placeholder,
				rules = item.getAttribute('rules')
			if (tag === 'INPUT' && (type === 'radio' || type === 'checkbox')) {
				this.find('input:' + type + ':checked[name=' + item.name + ']').each((_, i) => {
					val = (val ? val + ',' : '') + i.value
				})
			} else {
				val = item.value
			}
			item = $(item)
				.off('input')
				.on('input', e => {
					e.target.className = ''
					$(e.target).siblings('.msg').hide()
				})
			let msg = item.siblings('.msg')
			msg = msg.length ? msg : $('<p class="msg">').appendTo(item.parent())
			if (val === '') {
				if (tag === 'SELECT' || (tag === 'INPUT' && (type === 'radio' || type == 'checkbox'))) {
					html = '请选择' + html
				} else {
					html = '请输入' + html
				}
				error(item, msg, html)
			} else {
				if (!rules) return true
				rules.split(',').forEach(rule => {
					// 正则表达式
					if (rule === 'regexp') {
						if (!new RegExp(item.attr('regexp')).test(val)) {
							error(item, msg, html + '不符合要求')
						}
						// 最小长度
					} else if (rule === 'minlength') {
						if (val.length < Number(item.attr('minlength'))) {
							error(item, msg, html + '长度不能小于' + item.attr('minlength'))
						}
					}
				})
			}
		})
		if (focus) {
			focus.focus()
			return false
		} else {
			return true
		}
	}
})(window.$)
