const gulp = require('gulp')
const uglify = require('gulp-uglify') //js压缩
const babel = require('gulp-babel') //兼容性
const cssmin = require('gulp-cssmin') //css压缩
const spritesmith = require('gulp.spritesmith') //拼合小图标
const browserSync = require('browser-sync').create() //热启动
const static = './static/' //静态资源目录

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
		.pipe(cssmin())
		.pipe(gulp.dest(static + '/css/'))
})

// css相关文件: iconfont bg
gulp.task('css', () => {
	return gulp.src(['./src/css/**/*', '!./src/css/**/*.css']).pipe(gulp.dest(static + '/css/'))
})

// 静态图片及图标
gulp.task('img', () => {
	return gulp.src(['./src/**/*.+(png|jpg|jpeg|gif|svg|ico)', '!./src/css/bg/icon/*.png']).pipe(gulp.dest(static))
})

gulp.task('sprite', function () {
	var spriteData = gulp.src('./src/css/bg/icon/*.png').pipe(
		spritesmith({
			imgName: 'sprite.png',
			cssName: 'sprite.css'
		})
	)
	return spriteData.pipe(gulp.dest(static + '/css/'))
})

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

gulp.task('static', gulp.series('sprite', 'style', 'img', 'css', 'js', 'minjs', 'robots'))
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
