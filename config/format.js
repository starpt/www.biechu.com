module.exports = (date, form) => {
	date = typeof date === 'number' ? new Date(date) : date
	if (typeof date !== 'object') return
	let obj = {
		'y+': date.getFullYear(), //年
		'M+': date.getMonth() + 1, //月份
		'W+': Math.ceil((date - new Date(date.getFullYear(), 0, date.getDay())) / (24 * 60 * 60 * 1000) / 7) + 1, //第几周
		'd+': date.getDate(), //日
		'h+': date.getHours(), //小时
		'm+': date.getMinutes(), //分
		's+': date.getSeconds(), //秒
		'q+': Math.floor((date.getMonth() + 3) / 3), //季度
		'w+': date.getDay(), //星期
		'S+': date.getMilliseconds() //毫秒
	}
	form = form || 'yyyy-MM-dd hh:mm:ss' //默认年年年年-月月-日日 时时:分分:秒秒
	for (let i in obj) {
		if (new RegExp('(' + i + ')').test(form)) {
			let s = '' + obj[i],
				n = RegExp.$1.length - s.length
			form = form.replace(RegExp.$1, n > 0 ? new Array(n + 1).join('0') + s : s)
		}
	}
	return form
}
