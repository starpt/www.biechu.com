module.exports = require('koa-route').get('/talent', async ctx => {
	let data = {
		head: {
			title: '魔兽世界_燃烧的远征_天赋模拟器_别处',
			keywords: '燃烧的远征天赋模拟器,TBC天赋模拟器',
			description: '魔兽世界经典怀旧服燃烧的远征(TBC)2.43版本各职业天赋模拟器，支持导入其它网站数据。',
			css: 'talent'
		},
		left: {act: 'talent'}
	}
	await ctx.render('talent', data)
})
