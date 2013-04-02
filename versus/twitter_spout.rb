require 'red_storm'
require 'simple'
require 'json'
require 'twitter4j4r'
require 'socket'

class TwitterSpout
  extend Simple::Metrics::Meter
  extend Simple::Metrics::Graphite

  # Capture hostname to store data into appropriate buckets
  hostname, _ = Socket.gethostname.split(/(\.)/)
  group, _ = hostname.split(/(\d+)/)

  # TODO: Worker uniquess needed
  #   Need to grab a unique value to handle multiples of the 
  #   same spout/bolt running on the same host
  enable_graphite_reporter('localhost', 2003, "#{group}.#{hostname}")
  define_meter :job_meter, self.to_s

  def initialize
    @tweets = []
  end 

  def open(conf, context, collector)
    twitter_conf = JSON.parse(conf['twitter'], :symbolize_names => true)
    @client = Twitter4j4r::Client.new({
      :consumer_key => twitter_conf[:consumer_key],
      :consumer_secret => twitter_conf[:consumer_secret],
      :access_token => twitter_conf[:oauth_token],
      :access_secret => twitter_conf[:oauth_token_secret]
    })

    @client.track(conf['tracks']) do |tweet|
      @tweets << { 
        :retweet => tweet.retweet?, 
        :hashtags => tweet.hashtag_entities.map(&:text), 
        :tweet => tweet.text 
      }
    end

    @collector = collector
  end

  def next_tuple
    if @tweets.empty?
      sleep(0.25)
    else
      @collector.emit(Values.new(@tweets.shift))
    end
  end

  def get_component_configuration
  end

  def declare_output_fields(declarer)
    declarer.declare(Fields.new('data'))
  end
end