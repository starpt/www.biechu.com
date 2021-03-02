const nodemailer = require('nodemailer')
let sendEmail = () => {
	var transporter = nodemailer.createTransport({
		host: 'smtp.qq.com',
		port: 465,
		secure: true, // use SSL
		auth: {
			user: 'admin@biechu.com',
			//pass: 'ibqezfoyseanbjbf'
			pass: 'xjvvygtbqzwmcadc'
		}
	})

	// setup e-mail data with unicode symbols
	var mailOptions = {
		from: '"Test 👥" <admin@biechu.com>', // sender address
		to: '2044155@qq.com', // list of receivers
		subject: 'Hello ✔', // Subject line
		text: 'Hello world 🐴', // plaintext body
		html: '<b>Hello world 🐴</b>' // html body
	}

	// send mail with defined transport object
	transporter.sendMail(mailOptions, function (error, info) {
		if (error) {
			return console.log(error)
		}
		console.log('Message sent: ' + info.response)
	})
}
module.exports = {
	sendEmail: sendEmail
}

//发送邮件
// var send = require('../../mail')
// send.sendEmail()
