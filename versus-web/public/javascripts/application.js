// Some general UI pack related JS

$(document).ready(function() {

  var socket = io.connect('http://localhost:3000'),
    tweets = [],
    $tweets = $('#h_tweets'),
    $hashtags = {
        bruins : $('#hashtags .bruins'),
        senators : $('#hashtags .senators')
    },
    $retweets = {
        bruins : $('#retweets .bruins'),
        senators : $('#retweets .senators')
    };

  socket.on('hashtags', function (data) {
    console.log(data);
    $hashtags.bruins.text(data.bruins);
    $hashtags.senators.text(data.senators);
  });

  socket.on('retweets', function (data) {
    console.log(data);
    $retweets.bruins.text(data.bruins);
    $retweets.senators.text(data.senators);
  });

  socket.on('tweets', function (data) {
    console.log(data);
    var tweet = $('<div class="tweet"></div>').text(data.tweet);
    tweets.unshift(tweet);
    $tweets.prepend(tweet);
    while(tweets.length > 10)
    {
      tweets.pop().remove();
    }
  });
});