var express = require('express');
var app = express();
var server = require('http').createServer(app)
var io = require('socket.io').listen(server);
var path = require('path');

server.listen(3000);

app.use(express.bodyParser());
app.use(express.static(path.join(__dirname, 'public')));

app.get('/', function (req, res) {
  res.sendfile(__dirname + '/index.html');
});

io.sockets.on('connection', function (socket) {
  socket.emit('news', { GO: 'BRUINS' });
});

app.post('/hashtags', function(req, res) {
  console.log(req.body);
  io.sockets.emit('hashtags', req.body);
  res.send('hashtags');
});

app.post('/retweets', function(req, res) {
  console.log(req.body);
  io.sockets.emit('retweets', req.body);
  res.send('retweets');
});

app.post('/tweets', function(req, res) {
  console.log(req.body);
  io.sockets.emit('tweets', req.body);
  res.send('tweets');
});