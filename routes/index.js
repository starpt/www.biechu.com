module.exports = require('koa-route').get('/', async ctx => {
	let data = {
		head: {
			title: '魔兽世界经典旧世_别处',
			keywords: '',
			description: '',
			css: 'index'
		},
		left: {act: '/'}
	}
	await ctx.render('index', data)
})
