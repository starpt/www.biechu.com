module.exports = require('koa-route').get('/user', async ctx => {
	const db = require('../config/mysql')
	let data = {
		head: {
			title: '',
			keywords: '',
			description: '',
			css: ''
		},
		left: {act: '/'}
	}
	await db('SELECT (entry),(name_loc4) FROM `locales_item` limit 1, 10', row => {
		data.row = row
	})
	await ctx.render('user', data)
})
