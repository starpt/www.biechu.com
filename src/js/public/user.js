!(function ($) {
	let login = $.pop({
		css: 'login',
		title: '登录',
		mask: 1,
		drag: 1,
		width: 360,
		body: '<form action="/api/login" method="POST">\
		<label>\
		<input type="text" placeholder="用户名" autocomplete="off">\
		<i class="iconfont">&#xeadd;</i>\
		</label>\
		<label>\
		<input type="password" placeholder="密码">\
		<i class="iconfont">&#xe77b;</i>\
		</label>\
		</form>',
		foot: '<i style="margin:0">忘记密码</i>\
		<i>忘记用户名</i>\
		<i class="Fr">免费注册</i>',
		button: [
			{
				text: '登录',
				css: 'confirm',
				click: function () {
					this.close()
				}
			}
		]
	})
})(window.$)

header.children('.user').click(() => {
	login.show()
})
