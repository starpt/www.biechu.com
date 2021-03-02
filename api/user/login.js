module.exports = async (ctx, next) => {
	let res = {code: 0},
		where
	if (!['POST'].includes(ctx.request.method)) {
		res.msg = '请求方式错误!'
	} else if (!/^[0-9a-f]{32}$/.test(ctx.request.body.password)) {
		res.msg = '密码格式错误!'
	} else if (/^1(3|5|6|7|8|9)\d{9}$/.test(ctx.request.body.userName)) {
		where = 'phone = ' + ctx.request.body.userName
		res.msg = '手机号码 ' + ctx.request.body.userName + ' 未注册'
	} else if (/^[\w-]+@\w[\w-\.]*\.[a-z]{2,3}$/i.test(ctx.request.body.userName) && ctx.request.body.userName.length <= 32) {
		where = 'email = "' + ctx.request.body.userName + '"'
		res.msg = '邮箱地址 ' + ctx.request.body.userName + ' 未注册'
	} else if (/^[\u4e00-\u9fa5\uf900-\ufa2da-z][\u4e00-\u9fa5\uf900-\ufa2d\w-]{0,15}$/i.test(ctx.request.body.userName)) {
		where = 'name = "' + ctx.request.body.userName + '"'
		res.msg = '用户名 ' + ctx.request.body.userName + ' 未注册'
	} else {
		res.msg = '用户名格式错误!'
	}

	if (where) {
		const db = require('../../config/mysql')
		await db(
			'SELECT id, name, password, face, level, exp, banTime, errorTime, gold, guildId, place FROM user where ' + where,
			row => {
				if (row.length === 0) {
					res.code = 2
				} else {
					row = row[0]
					const format = require('../../config/format')
					let now = Date.now(),
						err = row.errorTime ? row.errorTime.getTime() : now
					if (err - now > 300000) {
						res = {
							code: 3,
							msg: '登录错误次数过多，请稍候再试！',
							cd: (err - now - 300000) / 1000
						}
					} else if (row.password === ctx.request.body.password) {
						const {updata} = require('../../config/token')
						res = updata(row, ctx.request)
						res.code = 1
						delete res.msg
					} else {
						// 更新登录密码错误时间 每错一次加60秒
						err = (err < now ? now : err) + 60000
						//console.log((err - now) / 1000)
						db('Update user Set errorTime = "' + format(err) + '" Where id = ' + row.id)

						if (err - now > 300000) {
							res = {
								code: 3,
								msg: '登录错误次数过多，请稍候再试！',
								cd: (err - now - 300000) / 1000
							}
						} else {
							res.code = 4
							res.msg = '密码错误，请确认后再试！'
						}
					}
				}
			},
			error => {
				res.msg = error
			}
		)
	}
	next(res)
}
