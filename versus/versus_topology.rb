require 'yaml'
require_relative 'twitter_spout'
require_relative 'filter_bolt'
require_relative 'hashtag_counter_bolt'
require_relative 'retweet_counter_bolt'
require_relative 'tweet_bolt'

class VersusTopology < RedStorm::SimpleTopology
  spout TwitterSpout, :parallelism => 1 do
    # April 2nd 'bruins' vs 'SENATORS'
    set 'tracks', 'bruins,senators'
  end

  bolt FilterBolt, :parallelism => 1 do
    source TwitterSpout, :shuffle
  end

  bolt HashtagCounterBolt, :parallelism => 1 do
    source FilterBolt, :shuffle
  end
  
  bolt RetweetCounterBolt, :parallelism => 1 do
    source FilterBolt, :shuffle
  end

  bolt TweetBolt, :parallelism => 1 do
    source FilterBolt, :shuffle
  end

  configure :versus_topology do |env|
    # debug true
    set 'topology.worker.childopts', '-Djruby.compat.version=RUBY1_9'

    settings = YAML.load_file('/crashlytics/redstorm-demo/settings.yml')
    set 'twitter', settings['twitter'].to_json
    set 'web.host', settings['web']['host']

    case env
    when :local
      max_task_parallelism 1
    when :cluster
      num_workers 20
      max_spout_pending(1000);
    end
  end

  on_submit do |env|
    if env == :local
      # sleep(600)
      # cluster.shutdown
    end
  end
end
