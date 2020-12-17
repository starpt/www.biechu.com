const Koa = require('koa')
const ejs = require('koa-ejs')
const path = require('path')
const fs = require('fs')
const app = new Koa()

ejs(app, {
	root: path.resolve('views'), // 视图文件地址
	layout: false,
	viewExt: 'htm', //视图文件后缀名
	//debug: true,
	cache: false
})

//自动加载路由
fs.readdirSync(path.resolve('routes')).forEach(file => {
	app.use(require('./routes/' + file))
})

// const jwt = require('koa-jwt')
// app.use(jwt({secret: 'shared-secret', passthrough: true}))

// 404错误
app.use(async ctx => {
	if (ctx.status === 404) {
		await ctx.render('404'), (ctx.status = 404)
	}
})

app.listen(81)
