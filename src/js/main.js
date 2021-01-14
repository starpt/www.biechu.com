/************************************************
 * 2020-11-16
 * star@biechu.com
 * js/main.js 链式加载css或者js文件
 * 比如: <script src="/js/main.js" data-load='talents.js,talents.css'></script>
 ************************************************/

;(() => {
	'use strict'
	window.log = console.log

	const jsPath = '/js/',
		cssPath = '/css/',
		head = document.getElementsByTagName('head')[0],
		cache = '?' + Date.now()
	let require = (load, callback) => {
		//加载前端模块
		let ext = file => {
			//扩展名
			return file.replace(/^.*\.([^?]+).*$/, '$1').toLowerCase()
		}
		let exis = file => {
			//已经加载
			file = file.replace(/\?.*$/, '') //去除参数
			if (ext(file) === 'css') {
				let css = document.getElementsByTagName('link')
				for (let i = 0; i < css.length; i++) {
					if (css[i].getAttribute('href') === cssPath + file) {
						return 1
					}
				}
			} else if (ext(file) === 'js') {
				let script = document.getElementsByTagName('script')
				for (let i = 0; i < script.length; i++) {
					if (script[i].getAttribute('src') === jsPath + file) {
						return 1
					}
				}
			}
		}

		if (typeof load === 'object' && load.length > 0) {
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
					link.onload = () => {
						if (callback instanceof Function) callback()
					}
				} else if (ext(load) == 'js') {
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

	let load,
		script = document.getElementsByTagName('script')
	for (let i = 0; i < script.length; i++) {
		if (script[i].getAttribute('src') === jsPath + 'main.js') {
			load = script[i].getAttribute('data-load')
			break
		}
	}
	if (load) {
		require('jQuery.min.js', () => {
			loadingBar.style.width = '60%'

			// 登录/注册
			$('#login>button').click(() => {
				if ($.login) {
					$.login()
				} else {
					require('login.js', () => {
						$.login()
					})
				}
			})

			require(load.split(',').length > 1 ? load.split(',') : load)
			$(document)
				.ready(() => {
					$('header>nav>.iconfont').click(() => {
						$('#left').toggleClass('toggle')
						$('#right').toggleClass('toggle')
						$('#centr').toggleClass('toggle')
						return false
					})
				})
				.keydown(e => {
					if (e.keyCode === 9) $('header>nav>.iconfont').click()
				})
		})
	}

	// 头部进度条
	let header = document.getElementsByTagName('header')[0],
		loadingBar = document.getElementById('loadingBar')
	window.loading = width => {
		loadingBar.style.visibility = 'visible'
		loadingBar.style.width = width || '100%'
		setTimeout(() => {
			loadingBar.style.visibility = 'hidden'
			loadingBar.style.width = 0
		}, 1500)
	}
	if (header && !loadingBar) {
		loadingBar = document.createElement('p')
		loadingBar.setAttribute('id', 'loadingBar')
		header.appendChild(loadingBar, null)
	}
	loadingBar.style.width = '30%'
	document.body.onload = () => {
		loading()
	}
}).call(this)
