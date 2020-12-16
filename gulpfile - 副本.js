const gulp = require('gulp')
const uglify = require('gulp-uglify') //js压缩
const babel = require('gulp-babel') //兼容性
const cssmin = require('gulp-cssmin') //css压缩
const browserSync = require('browser-sync').create() //热启动
const base64 = require('gulp-base64')
const static = './static/' //静态资源目录

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
		.pipe(gulp.dest(static + 'js/'))
		.pipe(browserSync.reload({stream: true}))
})

// 压缩style-css
gulp.task('style', () => {
	return gulp
		.src(['./src/css/**/*.css'])
		.pipe(cssmin())
		.pipe(gulp.dest(static + 'css/'))
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

gulp.task('static', gulp.series('style', 'img', 'css', 'js', 'minjs', 'robots'))
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
