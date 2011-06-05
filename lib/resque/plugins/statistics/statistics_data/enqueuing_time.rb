module Resque
  module Plugins
    module Statistics
      class EnqueuingTime < StatisticsData

        private

        def self.redis_key( job_name )
          redis_prefix(job_name) + "EnqueuingTime"
        end 

      end
    end
  end
end