// var EventEmitter = require('events').EventEmitter;

// var event = new EventEmitter();

// event.on('some_event', function(){
// 	console.log('sone_event 事件触发');
// });

// setTimeout(function(){
// 	event.emit('some_event');
// }, 2000);

// var x = 0;
// while(x < 6){
// 	++x;
// 	setTimeout(function(){
// 		event.emit('some_event');
// 	}, 2000); 
// }


// var events = require('events');
// var emitter = new events.EventEmitter();
// emitter.on('someEvent',function(arg1,arg2){

// 	console.log('listener1', arg1, arg2);
// });

// emitter.on('someEvent',function(arg1,arg2){

// 	console.log('listener2', arg1, arg2);
// });

// emitter.emit('someEvent', 'arg1 参数1', 'arg2参数2');

// var events = require('events'); 
// 
// var emitter = new events.EventEmitter(); 
// emitter.on('error',function(arg1){
// 	console.log(arg1);
// });
// emitter.emit('error', 'arg1 cuowu');


var http = require('http');

var http2 = require('http');

http.createServer(function (request, response) {

	// 发送 HTTP 头部 
	// HTTP 状态值: 200 : OK
	// 内容类型: text/plain
	response.writeHead(200, {'Content-Type': 'text/plain'});

	// 发送响应数据 "Hello World"
	response.end('Hello World\n');
}).listen(8890);

// 终端打印如下信息
console.log('Server running at http://127.0.0.1:8888/');
