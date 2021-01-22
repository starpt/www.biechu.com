/************************************************
 * 2020-11-16
 * star@biechu.com
 * js/main.js 链式加载css或者js文件
 * 比如: <script src="/js/public.js" data-load='talents.js,talents.css'></script>
 ************************************************/

window.log = typeof console === 'undefined' ? alert : console.log

const jsPath = '/js/',
	cssPath = '/css/'

//加载前端模块
const require = (load, callback) => {
	let head = document.getElementsByTagName('head')[0],
		cache = '?' + Date.now()

	//扩展名
	let ext = file => {
		return file.replace(/^.*\.([^?]+).*$/, '$1').toLowerCase()
	}

	//已经加载
	let exis = file => {
		file = file.replace(/\?.*$/, '') //去除参数
		if (ext(file) === 'css') {
			let css = document.getElementsByTagName('link')
			for (let i = 0; i < css.length; i++) {
				if ((css[i].getAttribute('href') + '').replace(/\?.*$/, '') === cssPath + file) {
					return 1
				}
			}
		} else if (ext(file) === 'js') {
			let script = document.getElementsByTagName('script')
			for (let i = 0; i < script.length; i++) {
				if ((script[i].getAttribute('src') + '').replace(/\?.*$/, '') === jsPath + file) {
					return 1
				}
			}
		}
	}

	if (typeof load === 'object' && load.length) {
		require(load[0], () => {
			require(load.slice(1, load.length), callback)
		})
	} else if (load && typeof load === 'string') {
		if (exis(load)) {
			if (callback instanceof Function) callback()
		} else {
			if (ext(load) === 'css') {
				let link = document.createElement('link')
				link.setAttribute('rel', 'stylesheet')
				link.setAttribute('href', cssPath + load + cache)
				head.appendChild(link, null)
			} else if (ext(load) === 'js') {
				let script = document.createElement('script')
				script.setAttribute('src', jsPath + load + cache)
				script.onload = () => {
					if (callback instanceof Function) callback()
				}
				head.appendChild(script, null)
			}
		}
	}
}

let main = $('script[src="' + jsPath + 'public.js"]'),
	header = $('#header')
if (main.length) {
	let load = main.data('load')
	if (load) require(load.split(','))
}
$.loading = width => {
	let bar = header.find('>.bar')
	bar = bar.length ? bar : $('<div class="bar">').prependTo($('#header'))
	width = typeof width === 'number' ? width : 100
	bar.show().width(width + '%')
	if (width >= 100) {
		setTimeout(() => {
			bar.hide().width(0)
		}, 1500)
	}
}
$.loading(30)
$(document).ready(() => {
	$.loading(60)
	header.find('>nav>.iconfont').click(() => {
		$('#left').toggleClass('toggle')
		$('#right').toggleClass('toggle')
		$('#centr').toggleClass('toggle')
		return false
	})
})

$(window).on({
	load: $.loading,
	keydown: e => {
		if (e.keyCode === 9) header.find('>nav>.iconfont').click()
	}
})
