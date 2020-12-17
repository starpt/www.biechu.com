const gulp = require('gulp')
const static = './static/' //静态资源目录

// css url文件 base64 编码
const through = require('through2')
const path = require('path')
const fs = require('fs')
const mime = require('mime')
const base64 = options => {
	encode = file => {
		let data = file.contents.toString()
		data.match(/url\([^\)]+\)/g).forEach(item => {
			let url = item.replace(/\(|\)|\'/g, '')
			url = url.replace(/^url/g, '')
			url = url.replace(/\?.*$/, '')
			if (/^http:|https:|data:/.test(url)) return
			let filePath = path.resolve(file.path, '../' + url),
				fileContent = fs.readFileSync(filePath)
			if (options.maxSize && fileContent.length > options.maxSize) {
				options.urlList.push('./src/css/**/' + url)
				return
			}
			data = data.replace(item, 'url("data:' + mime.lookup(filePath) + ';base64,' + fileContent.toString('base64') + '")')
		})
		return data
	}
	let rebase = (file, encoding, callback) => {
		if (file.isNull()) return callback(null, file)
		if (file.isStream()) return callback(createError(file, 'Streaming not supported'))
		file.contents = Buffer.from(encode(file))
		callback(null, file)
	}
	return through.obj(rebase)
}

// 压缩css,编码url base64文件
const cssmin = require('gulp-cssmin') //css压缩
let urlList = []
gulp.task('css', () => {
	return gulp
		.src(['./src/css/**/*.css'])
		.pipe(
			base64({
				urlList,
				maxSize: 1024 * 8 // 小于8kb base64编码
			})
		)
		.pipe(cssmin())
		.pipe(gulp.dest(static + 'css'))
})

// css url没有编码base64文件
gulp.task('url', () => {
	return gulp.src(urlList.length ? urlList : ['./src/css/base64/*']).pipe(gulp.dest(static + 'css'))
})

// 压缩js,不压缩.min.js文件
const babel = require('gulp-babel') //兼容性
const uglify = require('gulp-uglify') //js压缩
gulp.task('js', () => {
	return gulp
		.src(['./src/js/**/*.js', '!./src/js/**/*.min.js'])
		.pipe(babel({presets: ['@babel/preset-env']}))
		.pipe(uglify())
		.pipe(gulp.dest(static + 'js'))
})

// 复制不压缩的.min.js文件
gulp.task('minjs', () => {
	return gulp.src(['./src/js/**/*.min.js']).pipe(gulp.dest(static + 'js'))
})

// 静态图片资源,不包括css目录文件
gulp.task('img', () => {
	return gulp.src(['./src/**/*.+(png|jpg|jpeg|gif|svg|ico)', '!./src/css/**/*']).pipe(gulp.dest(static))
})

// robots.txt 等其它文件
gulp.task('other', () => {
	return gulp.src(['./src/robots.txt']).pipe(gulp.dest(static))
})

// 清除静态文件
const clean = require('gulp-clean')
gulp.task('clean', () => {
	return gulp.src(static, {read: false}).pipe(clean())
})

// 打包静态文件
gulp.task('build', gulp.series(['clean', 'css'], gulp.parallel('url', 'js', 'minjs', 'img', 'other')))

// 热启动开发环境
const browserSync = require('browser-sync').create() //热启动
const nodemon = require('gulp-nodemon')
gulp.task('start', () => {
	nodemon({
		script: 'app.js',
		ignore: ['src/', 'static/', 'temp/', 'node_modules/', 'gulpfile.js', 'package.json', 'package-lock.json', 'pm2.js', 'README.md']
	})
	browserSync.init({
		proxy: 'http://localhost',
		port: 89
	})
	gulp.watch(['api/', 'config/', 'routes/', 'static/', 'views/']).on('change', browserSync.reload)
})

gulp.task('dev', () => {
	browserSync.init({
		index: 'index.htm',
		port: 88,
		server: {
			baseDir: './src'
		}
	})
	gulp.watch(['./src/**']).on('change', browserSync.reload)
})

// 清除static
// const clean = require('gulp-clean') //static清除
// gulp.task('clean', () => {
// 	return gulp.src('static', {read: false}).pipe(clean())
// })
//gulp.task('build', gulp.series('clean', gulp.parallel('html', 'style', 'img', 'css', 'js', 'jqyery')))

// gulp.task('build', gulp.series('html', 'style', 'img', 'css', 'js', 'minjs', 'robots'))

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
