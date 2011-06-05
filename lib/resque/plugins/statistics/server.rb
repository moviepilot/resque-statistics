require 'resque/server'

module Resque
  module Plugins
    module Statistics
      module Server
        def self.included(base)
          base.class_eval do
            helpers do
              def job_statistics
                [ "StatisticJob" ]
              end
            end
      
            get "/statistics" do
              redirect url_path("/statistics/table")
            end
            
            get "/statistics/:key" do
              erb File.read(File.join(File.dirname(__FILE__), '../../views/statistics_tv.erb'))
            end
          end

        end
      end
      Resque::Server.tabs << 'Statistics'
    end
  end
end
