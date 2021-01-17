/************************************************
 * 2021-01-17
 * star@biechu.com
 * 弹窗
 ************************************************/

function Pop(h) {
	//弹窗
	var mask = DOM.get('#Mask') //遮罩
	if (!mask) {
		mask = document.createElement('div')
		mask.id = 'Mask'
		document.body.insertBefore(mask, null)
	}
	DOM.css(mask, {
		display: 'block',
		height: DOM.docHeight()
	})
	var pop = DOM.get('.Pop')
	if (!pop) {
		pop = document.createElement('div')
		pop.className = 'Pop'
		document.body.insertBefore(pop, null)
	}
	pop.style.display = 'block'
	pop.style.top = (document.documentElement.scrollTop || document.body.scrollTop) + (document.documentElement.clientHeight - 220) / 2 + 'px'
	pop.style.left = (document.documentElement.scrollLeft || document.body.scrollLeft) + (document.documentElement.clientWidth - 385) / 2 + 'px'
	var main = DOM.get('.main', pop) //主要内容
	if (!main) {
		main = document.createElement('div')
		main.className = 'main'
		pop.insertBefore(main, null)
	}
	main.innerHTML = h
	var hide = DOM.get('.hide', main) //关闭
	if (!hide) {
		hide = document.createElement('a')
		hide.className = 'hide close'
		main.insertBefore(hide, null)
	}
	var close = DOM.query('.close', pop)
	Event.on(close, 'click', function () {
		mask.style.display = ''
		pop.style.display = ''
		return false
	})
}
