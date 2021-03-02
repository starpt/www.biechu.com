$.ajaxSetup({
	type: 'POST',
	beforeSend: xhr => {
		let token = localStorage.getItem('token')
		if (token) xhr.setRequestHeader('token', token)
	},
	complete: (res, text) => {
		if (text === 'error') {
			if (res.none) {
				log(res.none)
				if (res.next instanceof Function) res.next()
			} else {
				$.alert(res.msg || res.status + '错误，请稍候再试或与系统管理员联系！', res.next)
			}
		}
	}
})
