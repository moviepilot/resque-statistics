dir = File.dirname(File.expand_path(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'rspec'
require 'resque'
require 'resque-statistics'
require 'delorean'

RSpec.configure do |config|
  config.include Delorean
  
  config.before(:all) do
    puts "Starting redis for testing at localhost:9736..."
    `redis-server #{dir}/resque-statistics-test.conf`
    Resque.redis = 'localhost:9823'
  end
  
  config.before(:each) do
    Resque.redis.flushall
  end

  config.after(:all) do
    redis_pid = `ps -A -o pid,command | grep resque-statistics-test`.split(" ")[0]
    puts "\nKilling test redis server[#{redis_pid}]..."
    `rm -f #{dir}/dump.rdb`
    Process.kill("KILL", redis_pid.to_i)
  end  
end

##
# Helper to perform job classes
#
module PerformJob
  def perform_job(klass, args)
    klass.enqueue args
    job = Resque::Job.reserve(:test)
    job.perform #( *job.payload['args'] )
  end
end
