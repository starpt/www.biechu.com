module.exports = require('koa-route').get('/item', async ctx => {
	let data = {
		head: {
			title: '魔兽世界_燃烧的远征_装备模拟器_别处',
			keywords: '燃烧的远征装备模拟器,TBC装备模拟器,魔兽世界装备搭配',
			description: '魔兽世界经典怀旧服燃烧的远征(TBC)2.43版本各种族职业装备模拟器，推荐装备,魔兽世界TBC套装。',
			css: 'item'
		},
		left: {act: 'item'}
	}
	await ctx.render('item', data)
})
