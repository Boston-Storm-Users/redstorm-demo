require 'red_storm'
require 'json'
require 'simple'
require 'socket'
require 'httparty'

class RetweetCounterBolt < RedStorm::SimpleBolt
  extend Simple::Metrics::Meter
  extend Simple::Metrics::Graphite

  # Capture hostname to store data into appropriate buckets
  hostname, _ = Socket.gethostname.split(/(\.)/)
  group, _ = hostname.split(/(\d+)/)

  # TODO: Worker uniquess needed
  #   Need to grab a unique value to handle multiples of the 
  #   same spout/bolt running on the same host
  enable_graphite_reporter('localhost', 2003, "#{group}.#{hostname}")
  define_meter :count_meter, self.to_s

  on_init do
    @bruins = 0
    @senators = 0
    @web_host = self.config['web.host']
  end

  on_receive :emit => false do |tuple|
    count_meter.mark
    hsh = tuple['data']
    log.info "***** RECEIVE #{hsh[:retweet]}"
    if hsh[:retweet]
      @bruins += 1 if hsh[:tweet] =~ /bruins/i
      @senators += 1 if hsh[:tweet] =~ /senators/i
    end

    HTTParty.post("#{@web_host}/retweets", 
      :body => { :bruins => @bruins, :senators => @senators }.to_json,
      :headers => { 'Content-Type' => 'application/json' }) rescue nil

    log.info "***** RETWEET COUNTS Bruins: #{@bruins} vs Senators: #{@senators}"
  end
end