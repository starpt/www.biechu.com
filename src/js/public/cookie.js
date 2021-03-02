//读取cookie
$.cookie = {
	get: name => {
		let arr = document.cookie.match(new RegExp('(^| )' + name + '=([^;]*)(;|$)'))
		return arr ? arr[2] : ''
	},
	set: (name, value, expires, domain) => {
		document.cookie = name + '=' + value + ';expires=' + (expires ? new Date(expires) : '') + ';domain=' + (domain || '') + ';path=/'
	},
	del: function (name) {
		this.set(name, null, -1)
	}
}
