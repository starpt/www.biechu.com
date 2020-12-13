/************************************************
 * 2020-11-16
 * star@biechu.com
 ************************************************/

;($ => {
	$(document).ready(() => {
		let cd = (new Date('2021/03/13 11:44:00') - new Date()) / 1000
		setInterval(() => {
			cd -= 1
			$('#cd').html('<i>' + Math.floor(cd / 86400) + '</i>天<i>' + Math.floor((cd % 86400) / 3600) + '</i>时<i>' + Math.floor((cd % 3600) / 60) + '</i>分<i>' + Math.floor(cd % 60) + '</i>秒')
		}, 1000)
	})
})(jQuery)
