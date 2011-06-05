
module Resque
  module Plugins
    module Statistics
      class StatisticsData

        def self.data_size
          @data_size ||= 100
        end
        
        def self.data_size=(value)
          @data_size = value
        end

        def self.store( job_name, value )
          update_data(job_name) do |values|
            values << value
            values.shift if values.size > data_size
          end
        end

        def self.update_data(job_name, &block)
          values = fetch_values(job_name)
          yield values
          store_values( job_name, values )
        end

        def self.fetch_values( job_name )
          Resque.decode(Resque.redis.get(redis_key(job_name)) || "[]")
        end

        def self.store_values( job_name, execution_times )
          Resque.redis.set(redis_key(job_name), Resque.encode(execution_times))
        end

        def self.average(job_name)
          times = fetch_values( job_name )
          times.inject{ |sum, el| sum + el }.to_f / times.size
        end
                
        private 
        def self.redis_prefix( job_name )
          "Resque:Plugins:Statistics:#{job_name}:"
        end
      end
    end
  end
end
