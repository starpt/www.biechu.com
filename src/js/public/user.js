/************************************************
 * 2021-01-30
 * gky@qq.com
 * 用户信息
 ************************************************/

$.user = callback => {
	let user = $.cookie.get('user')
	user = user ? JSON.parse(user) : {}

	log(user)

	//JSON.parse()
	user = {
		obj: header.children('.user'),
		name: $.cookie.get('userName'),
		// 登录
		login: function () {
			let pop = $.pop({
				id: 'login',
				css: 'login',
				tag: '<form>',
				title: '登录',
				show: 1,
				mask: 1,
				drag: 1,
				body: '<label>\
						<input maxlength="32" \
						type="text" \
						placeholder="用户名/手机号码/邮箱地址" \
						value="admin' + this.name + '"\
						rules="regexp"\
						regexp="^(1(3|5|6|7|8|9)\\d{9}$)|(^[\\w-]+@\\w[\\w-.]*.[a-zA-Z]{2,3}$)|(^[\u4e00-\u9fa5\uf900-\ufa2da-zA-Z][\u4e00-\u9fa5\uf900-\ufa2d\\w-]{0,15}$)">\
						<i class="iconfont">&#xeadd;</i>\
					</label>\
					<label>\
						<input rules="minlength" minlength=7 maxlength="32" type="password" placeholder="密码">\
						<i class="iconfont">&#xe77b;</i>\
					</label>',
				foot: '<i>忘记密码</i>\
							<i>免费注册</i>',
				button: [
					{
						text: '登录',
						css: 'confirm',
						click: e => {
							let frm = e.target.form
							frm[0].value = frm[0].value.trim()
							if (!$(frm).verify()) return false
							let reset = () => {
								e.target.disabled = false
								e.target.innerHTML = '登录'
							}
							e.target.disabled = true
							e.target.innerHTML = '正在登录...'
							$.ajax({
								url: '/api/user/login',
								data: {
									userName: frm[0].value,
									password: MD5(frm[1].value)
								},
								success: res => {
									if (res.code === 1) {
										this.success(res)
										//$.alert('登录成功!', reset)
									} else if (res.code === 2) {
										$.confirm(
											res.msg + '，是否注册？',
											() => {
												reset()
												this.register(frm[0].value).show()
											},
											() => reset()
										)
									} else if (res.code === 3) {
										let cd = Math.ceil(res.cd) || 0,
											tim
										$.alert(res.msg, () => {
											e.target.innerHTML = cd + ' 秒后再试...'
											tim = setInterval(() => {
												cd -= 1
												if (cd > 0) {
													e.target.innerHTML = cd + ' 秒后再试...'
												} else {
													clearInterval(tim)
													reset()
												}
											}, 1000)
											frm[1].value = ''
											frm[1].focus()
										})
									} else if (res.code === 4) {
										$.alert(res.msg, () => {
											frm[1].value = ''
											frm[1].focus()
											reset()
										})
									} else {
										$.alert(res.msg, reset)
									}
								},
								error: err => {
									//err.none = false // 出错禁止提示
									err.next = reset
								}
							})

							return false
						}
					}
				]
			})
			//输入框回车提交
			pop
				.find('input:text,input:password')
				.keydown(e => {
					if (e.keyCode === 13) e.target.form[2].click()
				})
				.each((_, item) => {
					if (item.value === '' || item.className === 'error') {
						item.focus()
						return false
					}
				})

			pop.find('.foot>i').each((index, item) => {
				item.onclick = () => {
					if (index === 0) {
						this.forget().show()
					} else if (index === 1) {
						this.register().show()
					}
				}
			})
			require('md5.min.js')
			return pop
		},
		// 忘记密码
		forget: function () {
			let pop = $.pop({
				id: 'forget',
				css: 'login',
				tag: '<form>',
				title: '忘记密码',
				show: 1,
				mask: 1,
				drag: 1,
				width: 360,
				body: '<label class="Verify">\
					<input rules="regexp" maxlength="16" type="text" placeholder="用户名" regexp="^[\u4e00-\u9fa5\uf900-\ufa2da-zA-Z][\u4e00-\u9fa5\uf900-\ufa2d\\w-]{0,15}$">\
					<i class="iconfont">&#xeadd;</i>\
				</label>\
				<label class="Verify">\
					<input rules="regexp" maxlength="32" type="text" placeholder="邮箱地址" regexp="^[\\w-]+@\\w[\\w-.]*.[a-zA-Z]{2,3}$">\
					<i class="iconfont">&#xe806;</i>\
				</label>',
				button: [
					{
						text: '发送验证码邮件',
						css: 'confirm',
						click: e => {
							let frm = e.target.form
							return false
						}
					}
				]
			})
		},
		register: function (name) {
			let pop = $.pop({
				id: 'register',
				css: 'login',
				tag: '<form>',
				title: '注册用户',
				mask: 1,
				drag: 1,
				width: 360,
				body: '<label class="Verify">\
					<input rules="regexp" maxlength="16" type="text" placeholder="用户名" regexp="^[\u4e00-\u9fa5\uf900-\ufa2da-zA-Z][\u4e00-\u9fa5\uf900-\ufa2d\\w-]{0,15}$">\
					<i class="iconfont">&#xeadd;</i>\
				</label>\
				<label class="Verify">\
					<input rules="regexp" maxlength="32" type="text" placeholder="邮箱地址" regexp="^[\\w-]+@\\w[\\w-.]*.[a-zA-Z]{2,3}$">\
					<i class="iconfont">&#xe806;</i>\
				</label>',
				button: [
					{
						text: '发送验证码邮件',
						css: 'confirm',
						click: e => {
							let frm = e.target.form
							return false
						}
					}
				]
			})
			return pop
		},
		success: function (res) {
			$.cookie.set('user', JSON.stringify(res.data))
			localStorage.setItem('token', res.token)
			this.login().close()
			$.tips('登录成功!')
			if (callback instanceof Function) callback()
			this.obj
				.html('<img src="' + ($.cookie.get('userFace') || '/img/face.svg') + '" class="face"><div class="info">\
			</div>')
				.mouseover(() => {
					clearTimeout(this.tim)
					this.obj.addClass('over').children('.info').html('<p class="Loading"></p>')
					// this.obj.addClass('over').children('.info').html('<img src="/css/bg/loading.svg" width="28px">')
				})
				.mouseout(() => {
					this.tim = setTimeout(() => {
						this.obj.removeClass('over')
					}, 250)
				})
		},
		error: function () {
			this.obj.html('<button>登录/注册</button>').click(() => {
				this.login()
			})
		}
	}

	if (user.id) {
		user.success()
	} else if (user.name && /^[0-9a-f]{32}$/.test(user.password)) {
		user.login(callback)
	} else {
		//log(222)
		user.error()
		//user.pop().show()
	}
}
$.user(function () {
	//log(Date.now() - now)
})
// header.children('.user'),userId = $.cookie.get('userId'),info
// if(userId){
// 	user.html('<img src="' + ($.cookie.get('userFace') || '/img/null.png') + '" class="face">')
// 	if (callback instanceof Function) callback()
// }
// userName = $.cookie.get('userName'),
// password = $.cookie.get('password'),

// let user = header.children('.user'),
// userId = $.cookie.get('userId'),
// userName = $.cookie.get('userName'),
// password = $.cookie.get('password'),
// login = callback => {
// 	$.ajax({
// 		type: 'post',
// 		url: '/api/user/login',
// 		data: {
// 			userName,
// 			password
// 		},
// 		success: res => {
// 			callback(res)
// 		},
// 		error: err => {
// 			user.html('<button>登录/注册</button>').click(() => {
// 				$.login().show()
// 			})
// 		}
// 	})
// }

// 	let login = callback => {
// 		$.ajax({
// 			type: 'post',
// 			url: '/api/user/login',
// 			data: {
// 				userName,
// 				password
// 			},
// 			success: res => {
// 				callback(res)
// 			},
// 			error: err => {
// 				user.html('<button>登录/注册</button>').click(() => {
// 					$.login().show()
// 				})
// 			}
// 		})
// 	}
// 	/* let pop = $.pop({
// 		id: 'login',
// 		css: 'login',
// 		// show: 0,
// 		title: '登录',
// 		mask: 2,
// 		drag: 1,
// 		width: 360,
// 		body: '<form action="/api/login" method="POST">\
// 			<label>\
// 			<input type="text" placeholder="用户名" autocomplete="off">\
// 			<i class="iconfont">&#xeadd;</i>\
// 			</label>\
// 			<label>\
// 			<input type="password" placeholder="密码">\
// 			<i class="iconfont">&#xe77b;</i>\
// 			</label>\
// 			</form>',
// 		foot: '<i style="margin:0">忘记密码</i>\
// 			<i>忘记用户名</i>\
// 			<i class="Fr">免费注册</i>',
// 		button: [
// 			{
// 				text: '登录',
// 				css: 'confirm',
// 				click: function () {
// 					login(() => {
// 						if (callback instanceof Function) callback()
// 						this.close()
// 					})
// 					this.close()
// 				}
// 			}
// 		]
// 	}) */

// 	//log(pop.find('i'))
// 	//return pop
// }

// let user = header.children('.user'),
// 	userId = $.cookie.get('userId'),
// 	userName = $.cookie.get('userName'),
// 	password = $.cookie.get('password'),
// 	login = callback => {
// 		$.ajax({
// 			type: 'post',
// 			url: '/api/user/login',
// 			data: {
// 				userName,
// 				password
// 			},
// 			success: res => {
// 				callback(res)
// 			},
// 			error: err => {
// 				user.html('<button>登录/注册</button>').click(() => {
// 					$.login().show()
// 				})
// 			}
// 		})
// 	}

// if (userId) {
// 	user.html('<img src="' + ($.cookie.get('userFace') || '/img/null.png') + '" class="face">')
// } else if (userName && password) {
// 	login(userName,password)
// 	// login(res => {
// 	// 	//log(res)
// 	// 	user.html('<button>登录/注册</button>').click(() => {
// 	// 		$.login().show()
// 	// 	})
// 	// })
// } else {
// 	user.html('<button>登录/注册</button>').click(() => {
// 		log($.login().show().find('i'))
// 	})
// }
// })(window.$)
