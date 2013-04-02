require 'red_storm'
require 'simple'
require 'socket'

class FilterBolt
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
  
  def initialize
    @counts = Hash.new{|h, k| h[k] = 0}
  end

  def prepare(conf, context, collector)
    @collector = collector
  end

  def execute(tuple)
    count_meter.mark
    hsh = tuple['data']
    filters = ['ucla', 'washington', 'dem', 'gun', 'congress', 'obama', 'policy',
               'president', 'senate', 'terrorists', 'filibuster', 'rights', 'state',  
               'gop', 'vote', 'marriage', 'arms', 'fox']
    unless hsh[:tweet] =~ /#{filters.join('|')}/i
      @collector.emit(Values.new(hsh))
    end
  end

  def get_component_configuration
  end

  def declare_output_fields(declarer)
    declarer.declare(Fields.new('data'))
  end
end