const db = async (database, sql, next, error) => {
	let conn = require('mysql2').createConnection({host: 'localhost', user: 'root', password: 'skystar', database})
	await conn
		.promise()
		.query(sql)
		.then(([rows]) => {
			if (typeof next === 'function') next(rows)
		})
		.catch(e => {
			if (typeof error === 'function') error('500错误, 系统信息查询错误！')
			console.error(e)
		})
		.then(() => conn.end())
}

exports.tbc = (sql, next, error) => {
	return db('tbc', sql, next, error)
}

module.exports = (sql, next, error) => {
	return db('biechu', sql, next, error)
}
