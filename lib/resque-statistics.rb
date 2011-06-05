require 'resque/plugins/statistics/version'
require 'resque/plugins/statistics/statistics'
require 'resque/plugins/statistics/statistics_data'
require 'resque/plugins/statistics/statistics_data/execution_time'
require 'resque/plugins/statistics/statistics_data/enqueuing_time'
require 'resque/plugins/statistics/server'

Resque::Server.class_eval do
  include Resque::Plugins::Statistics::Server
end
