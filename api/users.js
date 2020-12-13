module.exports = async (method, next) => {
	let res = {code: 0}
	if (new RegExp('^(.+,)?' + method + '(,.+)?$', 'i').test('get,post'))
		await require('../config/mysql')('SELECT (entry),(name_loc4) FROM `locales_item` limit 1, 10', row => {
			res.code = 1
			res.data = row
		})
	next(res)
}
