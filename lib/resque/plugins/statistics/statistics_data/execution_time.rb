module Resque
  module Plugins
    module Statistics
      class ExecutionTime < StatisticsData

        def self.store( job_name, execution_time )
          update_data(job_name) do |execution_times|
            execution_times << execution_time
            execution_times.shift if execution_times.size > data_size
          end
        end
        
        private

        def self.redis_key( job_name )
          redis_prefix(job_name) + "ExecutionTime"
        end 
      end
    end
  end
end