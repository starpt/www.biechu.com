/************************************************
 * 2020-11-16
 * star@biechu.com
 * 天赋模拟器
 ************************************************/

$(document).ready(() => {
	let main = $('#centr>.main'),
		data,
		li,
		key,
		tim,
		reg = /.*(druid|hunter|mage|paladin|priest|rogue|shaman|warlock|warrior)\D*(\d*).*/i
	let getPoints = sort => {
		let p
		if (/[0-2]/.test(sort)) {
			p = 0
			for (let i in data[sort].talent) {
				p += data[sort].talent[i].size || 0
			}
		} else {
			p = 61
			for (let sort in data) {
				for (let i in data[sort].talent) {
					p -= data[sort].talent[i].size || 0
				}
			}
		}
		return p
	}

	let footer = () => {
		let tal,
			points = getPoints(),
			level = $('#talent>footer .level')
		$('#talent>footer .points').html(points) //剩余点数
		points >= 61
			? level.parent().hide()
			: level
					.html(70 - points)
					.parent()
					.show() //等级
		for (let sort in data) {
			tal = tal ? tal + 6 : key
			for (let i in data[sort].talent) {
				tal += data[sort].talent[i].size
			}
			tal = tal.replace(/0*$/, '')
		}
		clearTimeout(tim) //hashchange事件
		$(window).off('hashchange', init)
		location.hash = tal.replace(/6*$/, '')
		tim = setTimeout(() => {
			if (points <= 0) {
				for (let sort in data) {
					for (let i in data[sort].talent) {
						if (data[sort].talent[i].start === 'default') {
							updata(sort, i)
						}
					}
				}
			}
			$(window).on('hashchange', init)
		}, 200)
	}
	let tips = (sort, index) => {
		//设置Tips HTML
		let talent = data[sort].talent,
			rely = talent[index].rely
		return (
			talent[index].name +
			'<br>等级:' +
			talent[index].size +
			'/' +
			talent[index].rank.length +
			'<br>' +
			(rely && talent[rely].size < talent[rely].rank.length ? '<i class="rely">需要 ' + talent[rely].rank.length + '点 ' + talent[rely].name + ' </i>' : '') +
			(getPoints(sort) < parseInt(index / 4) * 5 ? '<i class="rely">需要 ' + parseInt(index / 4) * 5 + ' 点 ' + data[sort].text + ' 系天赋</i>' : '') +
			'<i class="rank">' +
			talent[index].rank[talent[index].size ? talent[index].size - 1 : 0] +
			'</i>' +
			(talent[index].size > 0 && talent[index].start === 'enable' ? '<i class="next">下一级</i><i class="rank">' + talent[index].rank[talent[index].size] + ' </i>' : '') +
			'<i class="learn">单击学习' +
			(talent[index].rank.length - talent[index].size > 1 ? ' 双击学满</i>' : '</i>') +
			(talent[index].size > 0 ? '<i class="forget">右键忘却</i>' : '')
		)
	}
	let getSize = (sort, index, size) => {
		//是否可以增加点数
		let talent = data[sort].talent,
			rely = talent[index].rely,
			points = getPoints()
		talent[index].size = talent[index].size || 0
		size = size === '+' ? talent[index].size + 1 : size === '-' ? talent[index].size - 1 : /^[0-5]$/.test(size) ? Number(size) : 0
		size = size < 0 ? 0 : size
		size = size > talent[index].rank.length ? talent[index].rank.length : size //点数不能大于最大点数
		size = rely && talent[rely].rank.length > talent[rely].size ? 0 : size //依赖点数必需点满
		size = getPoints(sort) < parseInt(index / 4) * 5 ? 0 : size //同系天赋需要相应点数
		size = points < size - talent[index].size && size > talent[index].size ? talent[index].size : size
		return size
	}
	let getStart = (sort, index) => {
		//图标状态
		let talent = data[sort].talent,
			rely = talent[index].rely
		return rely && talent[rely].rank.length > talent[rely].size ? 'default' : getPoints(sort) < parseInt(index / 4) * 5 ? 'default' : getPoints() <= 0 && talent[index].size <= 0 ? 'default' : talent[index].size >= talent[index].rank.length ? 'disable' : 'enable'
	}

	let updata = (sort, index) => {
		let talent = data[sort].talent
		talent[index].start = getStart(sort, index)
		li.eq(sort)
			.find('>div>div:eq(' + index + ')')
			.removeClass()
			.addClass(talent[index].start) //状态更新
		li.eq(sort)
			.find('>div>div:eq(' + index + ')>.Tips')
			.html(tips(sort, index)) //Tips 更新
	}

	let lower = (talent, row) => {
		let sum = 0
		for (let i in talent) {
			if (parseInt(Number(i) / 4) <= row) sum += talent[i].size
		}
		return sum
	}

	let change = (self, size) => {
		let sort = self.data('sort'),
			index = self.data('index'),
			talent = data[sort].talent,
			points = getPoints()
		size = getSize(sort, index, size)
		let diff = size - talent[index].size
		if (points < diff) return

		talent[index].size = size
		for (let i in talent) {
			let row = parseInt(Number(i) / 4)
			if (diff < 0) {
				//减少
				if (talent[i].rely === index && talent[i].size > 0) {
					//依赖
					talent[index].size -= diff
					return
				}
				if (row > parseInt(index / 4) && lower(talent, row - 1) < row * 5) {
					//有上级天赋存在
					if (talent[i].size > 0) {
						talent[index].size -= diff
						return
					} else if (talent[i].start !== 'default') {
						updata(sort, i)
					}
				}
			} else if (diff > 0) {
				if (talent[i].start === 'default' && lower(talent, row) >= row * 5) {
					updata(sort, i)
				}
			}
			if (talent[i].rely == index) {
				//依赖联动
				tim = setTimeout(() => {
					updata(sort, i)
				}, 100) //需要异步执行
			}
		}
		updata(sort, index)
		if ((points <= 0 && diff < 0) || points - diff <= 0) {
			// 天赋点满或者满状态
			for (let sort in data) {
				for (let i in data[sort].talent) {
					if ((points <= 0 && diff < 0 && data[sort].talent[i].start === 'default') || (points - diff <= 0 && data[sort].talent[i].start === 'enable')) {
						updata(sort, i)
					}
				}
			}
		}
		self.children('.size').html(size + '/' + talent[index].rank.length) //点数更新
		li.eq(sort).find('>h4>.points').html(getPoints(sort)) //当前天赋点数
		footer()
	}

	let init = (_, tal) => {
		$.loading()
		tal = tal || location.hash
		if (!reg.test(tal)) {
			main.find('>h1>i').html('')
			main.children('.icons').addClass('select')
			main.find('>nav.icons>a').removeClass('act')
			$('#talent').hide()
			return
		}
		key = tal.replace(reg, '$1').toLowerCase()
		tal = tal.replace(reg, '$2')
		data = talentData[key]
		let site = []
		if (/^[0-5]+$/.test(tal)) {
			let index = 0
			tal = tal.split('')
			data.forEach((item, sort) => {
				for (let i in item.talent) {
					site[sort] = site[sort] ? site[sort] + tal[index] : tal[index]
					index++
				}
			})
		} else {
			tal.split('6').forEach(item => {
				site.push(item)
			})
		}
		main.children('.icons').removeClass('select')
		let nav = main.find('>nav.icons>a')
		for (let i = 0; i < nav.length; i++) {
			if (new RegExp(key).test(nav[i].className)) {
				nav[i].className = key + ' act'
				main.find('>h1>i').html(nav[i].innerText)
			} else {
				nav[i].className = nav[i].className.replace(' act', '')
			}
		}
		li = $('#talent')
			.css('display', 'inline-block')
			.on('contextmenu', e => {
				e.preventDefault()
			})
			.children('li')
			.on('selectstart', e => {
				e.preventDefault()
			})
		data.forEach((item, sort) => {
			let talent = item.talent,
				h = ''
			li.eq(sort)
				.find('>h4>.icon>img')
				.attr('src', 'Icons/' + item.icon + '.jpg')
			li.eq(sort).find('>h4>.text').html(item.text)
			let index = 0
			for (let i = 0; i < 36; i++) {
				if (talent[i]) {
					talent[i].size = getSize(sort, i, site[sort] ? site[sort][index] : 0)
					talent[i].start = getStart(sort, i, site[sort] ? site[sort][index] : 0)
					h +=
						'<div data-sort="' +
						sort +
						'" data-index=' +
						i +
						' class="' +
						talent[i].start +
						'">\
					<div class="mask"></div>\
					<p class="Tips">' +
						tips(sort, i) +
						'</p>\
					<img src="Icons/' +
						talent[i].icon +
						'.jpg">' +
						(talent[i].rely ? '<i class="arrow' + (i - talent[i].rely) + '"></i>' : '') + //箭头
						'<i class="size">' +
						talent[i].size +
						'/' +
						talent[i].rank.length +
						'</i>' +
						'</div>'
					index++
				} else {
					h += '<div></div>' //空白占位
				}
			}
			for (let sort in data) {
				for (let i in data[sort].talent) {
					updata(sort, i)
				}
			}
			li.eq(sort).find('.points').html(getPoints(sort)) //当前天赋点数
			li.eq(sort)
				.find('.talent')
				.css('backgroundImage', 'url(Textures/' + item.texture + '.jpg)')
				.html(h)
				.find('.mask')
				.on({
					mousedown: e => {
						let self = $(e.target).parent()
						if (e.button === 0) {
							//单击
							if (!self.hasClass('enable')) return
							change(self, '+')
						} else if (e.button === 2) {
							//右击
							if (self.hasClass('default')) return
							change(self, '-')
						}
						return false
					},
					dblclick: e => {
						let self = $(e.target).parent()
						if (!self.hasClass('enable')) return
						change(self, 5)
						return false
					}
				})
		})
		footer()
	}
	init()
	$(window).on('hashchange', init)

	$('.reset').map((sort, item) => {
		//重置天赋
		$(item).click(() => {
			if (/[0-2]/.test(sort)) {
				let talent = data[sort].talent
				for (let i in talent) {
					if (talent[i].start !== 'default') {
						let self = li.eq(sort).find('>div>div:eq(' + i + ')')
						talent[i].size = 0
						talent[i].start = i < 4 && !talent[i].rely ? 'enable' : 'default'
						self.removeClass().addClass(talent[i].start) //状态更新
						self.find('.Tips').html(tips(sort, i)) //Tips 更新
						self.children('.size').html('0/' + talent[i].rank.length) //点数更新
					}
				}
				li.eq(sort).find('>h4>.points').html(0) //当前天赋点数
				if (getPoints() > 0) {
					for (let sort in data) {
						let talent = data[sort].talent
						for (let i in talent) {
							if (talent[i].start === 'default') {
								updata(sort, i)
							}
						}
					}
				}
				footer()
			} else {
				$('.reset:eq(0)').click()
				$('.reset:eq(1)').click()
				$('.reset:eq(2)').click()
			}
		})
	})

	//导入数据
	$('footer > .Fr > .iconfont:not(.reset)').click(() => {
		let tal = prompt('支持其它网站数据导入(包含职业和学习点数数据),比如:\n warlock.shtml?5502022012231115512\n', location.href)
		if (tal && tal !== location.href) init(null, tal)
	})
})
