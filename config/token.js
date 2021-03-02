// jwt令牌
const jwt = require('jsonwebtoken')
//exports.jwt = jwt

// 令牌秘钥
const secretKey = 'star@BieChu.com:1080'
//exports.secretKey = secretKey

// IP转成数字
const intIP = req => {
	let num = 0,
		ip = (req.headers['x-forwarded-for'] || '127.0.0.1').split('.')
	ip.forEach((item, index) => {
		num += (Number(item) || 0) * Math.pow(256, ip.length - index - 1)
	})
	return num
}
exports.intIP = intIP

// 用户端提交用户信息
/*
const getUser = ctx => {
	return {
		name: ctx.cookies.get('userName') || '',
		password: ctx.cookies.get('password') || '',
		token: ctx.request.header.token || ''
	}
}
exports.getUser = getUser
 */

// 生成令牌信息
const sign = data => {
	return jwt.sign(data, secretKey)
}
//exports.sign = sign

// 解码令牌信息
exports.verify = token => {
	return jwt.verify(token, secretKey)
}

exports.updata = (data, req) => {
	let now = Date.now(),
		ip = intIP(req),
		token = sign({id: data.id, pwd: data.password, ip})
	require('./mysql')('Update user Set loginIP = ' + ip + ', loginTime = "' + require('./format')(now) + '" Where id = ' + data.id)
	if (data.level < 15 && data.banTime && data.banTime > now) {
		data.level = 0
	} else if (data.level < 10) {
		data.exp = data.exp || 0
		let pow = exp => {
			for (let i = 1; i < 10; i++) {
				if (exp <= Math.pow(5, i)) {
					return i
				}
			}
			return 10
		}
		data.level = pow(data.exp)
	}
	delete data.errorTime
	delete data.password
	delete data.banTime
	return {
		token,
		data
	}
}
