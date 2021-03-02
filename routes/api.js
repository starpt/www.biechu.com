const reg = /^\/api\/([\w-]+)(\/[\w-]*)?(\?.*)?$/
module.exports = require('koa-route').all(reg, async ctx => {
	// 校验token
	if (!['/api/user/login'].includes(ctx.url)) {
		let token = ctx.request.header.token
		if (token) {
			const {verify} = require('../config/token')
			try {
				token = verify(token)
				//console.log(token)
				// if (token.ip !== intIP(ctx.request)) {
				// 	console.log('IP no')
				// }
				//console.log(ctx.cookies.get('userName'))
				//console.log(token.ip, intIP(ctx.request))
			} catch (error) {
				if (error.name === 'TokenExpiredError') {
					ctx.body = {code: 0, msg: '用户登录信息已过期,请重新登录!'}
				} else {
					ctx.body = {code: 0, msg: '用户登录信息无效,请重新登录!'}
				}
				return
			}
		} else {
			ctx.body = {code: 0, msg: '没有用户登录信息,请重新登录!'}
			return
		}
	}

	try {
		await require('../api/' + ctx.url.replace(reg, '$1' + '$2'))(ctx, async res => {
			ctx.body = res
			if (/^(localhost|127\.0\.0\.1|192\.168\.\d+\.\d+|10\.\d+\.\d+\.\d+|(\w+\.)?biechu\.com)(:\d+)?$/.test(ctx.request.header.host)) ctx.set('Access-Control-Allow-Origin', '*')
			ctx.set('Access-Control-Allow-Headers', 'Origin, X-Requested-With, Content-Type, Accept')
			ctx.set('Access-Control-Allow-Methods', 'PUT, POST, GET, DELETE, OPTIONS')
			ctx.set('Access-Control-Allow-Credentials', true) // 允许带上 cookie
		})
	} catch (e) {
		// console.log(e)
		ctx.status = 404
	}
})
