const gulp = require('gulp')
const uglify = require('gulp-uglify') //js压缩
const babel = require('gulp-babel') //兼容性
const cssmin = require('gulp-cssmin') //css压缩
const browserSync = require('browser-sync').create() //热启动
const static = './static/' //静态资源目录

const through = require('through2')
const path = require('path')
const fs = require('fs')
const base64 = options => {
	encode = file => {
		let data = file.contents.toString()
		data.match(/url\([^\)]+\)/g).forEach(item => {
			let url = item.replace(/\(|\)|\'/g, '')
			url = url.replace(/^url/g, '')
			if (/^http:|https:|data/.test(url)) return
			url = path.resolve(file.path, '../' + url).replace(/\?.*$/, '')
			let ext = url.replace(/^.*\.([^?]+).*$/, '$1').toLowerCase(),
				filepath = fs.readFileSync(url)
			console.log(url, filepath.length)
			//console.log(fs.readFileSync('D:\\Biechu\\www\\src\\css\\bg\\arrow1.png'))
			//console.log(filepath)

			//console.log(extname)
			//if (extname == 'png') {
			let imageContent = new Buffer(filepath.toString('base64'))
			data = data.replace(item, "url('data:image/" + ext.toLowerCase() + ';base64,' + imageContent + "')")
			//}
			//data = data.replace(item, "url('data:image/" + ext.toLowerCase() + ';base64,' + imageContent + "')")
		})

		return data
	}
	let rebase = (file, encoding, callback) => {
		if (file.isNull()) return callback(null, file)
		if (file.isStream()) return callback(createError(file, 'Streaming not supported'))
		file.contents = new Buffer(encode(file))
		callback(null, file)
	}

	return through.obj(rebase)
}
// "gulp-htmlmin": "^5.0.1"
// const htmlmin = require('gulp-htmlmin') //html压缩
// gulp.task('views', () => {
// 	return gulp
// 		.src('./src/views/**/*.htm')
// 		.pipe(
// 			htmlmin({
// 				collapseWhitespace: true,
// 				collapseBooleanAttributes: true,
// 				removeComments: true,
// 				removeEmptyAttributes: true, //清除所有的空属性
// 				removeScriptTypeAttributes: true,
// 				removeStyleLinkTypeAttributes: true,
// 				minifyJS: true, //压缩html中的javascript代码
// 				minifyCSS: true //压缩html中的css代码
// 			})
// 		)
// 		.pipe(gulp.dest('./views/'))
// })

// 压缩过的文件
gulp.task('minjs', () => {
	return gulp.src(['./src/js/*.min.js']).pipe(gulp.dest(static + '/js/'))
})

// 压缩js
gulp.task('js', () => {
	return gulp
		.src(['./src/js/**/*.js', '!./src/js/*.min.js'])
		.pipe(babel({presets: ['@babel/preset-env']}))
		.pipe(uglify())
		.pipe(gulp.dest(static + '/js/'))
		.pipe(browserSync.reload({stream: true}))
})

// 压缩style-css
gulp.task('style', () => {
	return gulp
		.src(['./src/css/**/*.css'])
		.pipe(
			base64({
				maxSize: 1024 * 8,
				extensions: ['jpg', 'png']
			})
		)
		.pipe(cssmin())
		.pipe(gulp.dest(static + '/css/'))
})

// gulp.task('base64', function () {
// 	return gulp.src('./src/css/*.css')
// 			.pipe(base64({
// 					baseDir: 'public',
// 					extensions: ['svg', 'png', /\.jpg#datauri$/i],
// 					exclude:    [/\.server\.(com|net)\/dynamic\//, '--live.jpg'],
// 					maxImageSize: 8*1024, // bytes
// 					debug: true
// 			}))
// 			.pipe(concat('main.css'))
// 			.pipe(gulp.dest('./public/css'));
// });

// css相关文件: iconfont bg
gulp.task('css', () => {
	return gulp.src(['./src/css/**/*', '!./src/css/**/*.css']).pipe(gulp.dest(static + '/css/'))
})

// 静态图片及图标
gulp.task('img', () => {
	return gulp.src(['./src/img/**/*.+(png|jpg|jpeg|gif|svg|ico)']).pipe(gulp.dest(static))
})

// const spritesmith = require('gulp.spritesmith') //拼合小图标
// gulp.task('sprite', function () {
// 	var spriteData = gulp.src('./src/css/bg/icon/*.png').pipe(
// 		spritesmith({
// 			imgName: 'sprite.png',
// 			cssName: 'sprite.css'
// 		})
// 	)
// 	return spriteData.pipe(gulp.dest(static + '/css/'))
// })

// robots.txt
gulp.task('robots', () => {
	return gulp.src(['./src/robots.txt']).pipe(gulp.dest(static))
})

// 清除static
// const clean = require('gulp-clean') //static清除
// gulp.task('clean', () => {
// 	return gulp.src('static', {read: false}).pipe(clean())
// })
//gulp.task('build', gulp.series('clean', gulp.parallel('html', 'style', 'img', 'css', 'js', 'jqyery')))

// gulp.task('build', gulp.series('html', 'style', 'img', 'css', 'js', 'minjs', 'robots'))

//gulp.task('static', gulp.series('style', 'img', 'js', 'minjs', 'robots'))
gulp.task('static', gulp.series('style', gulp.parallel('css', 'img', 'js', 'minjs', 'robots')))
gulp.task('default', () => {
	browserSync.init({
		index: 'index.htm',
		port: 88,
		//https: true,
		server: {
			baseDir: './src'
		}
	})
	gulp.watch(['./src/**']).on('change', browserSync.reload)
})
