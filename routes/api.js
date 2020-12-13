const reg = /^\/api\/([\w-]+)(\/[\w-]*)?(\?.*)?$/
module.exports = require('koa-route').all(reg, async ctx => {
	try {
		await require('../api/' + ctx.url.replace(reg, '$1' + '$2'))(ctx.request.method, async res => {
			ctx.body = res
		})
		if (/^(localhost|127\.0\.0\.1|192\.168\.\d+\.\d+|10\.\d+\.\d+\.\d+|(\w+\.)?biechu\.com)(:\d+)?$/.test(ctx.request.header.host)) ctx.set('Access-Control-Allow-Origin', '*')
		ctx.set('Access-Control-Allow-Headers', 'Origin, X-Requested-With, Content-Type, Accept')
		ctx.set('Access-Control-Allow-Methods', 'PUT, POST, GET, DELETE, OPTIONS')
		ctx.set('Access-Control-Allow-Credentials', true) // 允许带上 cookie
	} catch (e) {
		await ctx.render('404'), (ctx.status = 404)
	}
})
