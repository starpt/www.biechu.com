/*
pm2需要全局安装: npm install -g pm2
启动进程/应用 pm2 start bin/www 或 pm2 start app.js
重命名进程/应用 pm2 start app.js --name wb123
添加进程/应用 watch pm2 start bin/www --watch
结束进程/应用 pm2 stop www
结束所有进程/应用 pm2 stop all
删除进程/应用 pm2 delete www
删除所有进程/应用 pm2 delete all
列出所有进程/应用 pm2 list
查看某个进程/应用具体情况 pm2 describe www
查看进程/应用的资源消耗情况 pm2 monit
查看pm2的日志 pm2 logs
若要查看某个进程/应用的日志,使用 pm2 logs www
重新启动进程/应用 pm2 restart www
重新启动所有进程/应用 pm2 restart all
*/
module.exports = {
	apps: [
		{
			name: 'RESRful API Server',
			script: './dist/app.js',
			watch: false, // 默认关闭watch 可替换为 ['src']
			ignore_watch: ['node_modules', 'build', 'logs'],
			out_file: '/logs/out.log', // 日志输出
			error_file: '/logs/error.log', // 错误日志
			max_memory_restart: '2G', // 超过多大内存自动重启，仅防止内存泄露有意义，需要根据自己的业务设置
			env: {
				NODE_ENV: 'production'
			},
			exec_mode: 'cluster', // 开启多线程模式，用于负载均衡
			instances: 'max', // 启用多少个实例，可用于负载均衡
			autorestart: true // 程序崩溃后自动重启
		}
	]
}
