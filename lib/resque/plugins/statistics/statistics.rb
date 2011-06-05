require 'resque-meta'

module Resque
  module Plugins
    module Statistics      
      def self.extended(base)
        base.extend Resque::Plugins::Meta
      end
      
      def after_perform_statistics( meta_id, *args )
        meta = self.get_meta( meta_id )
        ExecutionTime.store( self.to_s, meta.seconds_processing )
        EnqueuingTime.store( self.to_s, meta.seconds_enqueued )
      end
    end
  end
end