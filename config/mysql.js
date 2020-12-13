/* const mysql = require('mysql2/promise')

const conn = async (sql, database, callback) => {
	let conn = await mysql.createConnection({host: 'localhost', user: 'root', password: 'skystar', database})
	const [rows] = await conn.execute(sql)
	conn.close()
	callback(rows)
}

const tbc = async (sql, callback) => {
	let conn = await mysql.createConnection({host: 'localhost', user: 'root', password: 'skystar', database: 'tbc'})
	const [rows] = await conn.execute(sql)
	conn.close()
	callback(rows)
}

const classic = async (sql, callback) => {
	let conn = await mysql.createConnection({host: 'localhost', user: 'root', password: 'skystar', database: 'classic'})
	const [rows] = await conn.execute(sql)
	conn.close()
	callback(rows)
}

module.exports = [tbc, classic]
 */

const mysql = require('mysql2')
const db = async (sql, next) => {
	let conn = await mysql.createConnection({host: 'localhost', user: 'root', password: 'skystar', database: 'tbc'})
	await conn
		.promise()
		.query(sql)
		.then(([rows]) => {
			next(rows)
		})
		.catch(e => {
			console.log(e)
		})
		.then(() => conn.end())
}

module.exports = db
