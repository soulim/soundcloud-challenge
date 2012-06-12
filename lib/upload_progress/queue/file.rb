require 'json'

module UploadProgress
  module Queue
    class File
      attr_reader :status
      attr_reader :size
      attr_reader :received
      
      def initialize(size = 0)
        @status   = 'starting'
        @size     = size.to_i
        @received = 0
      end
      
      def update(received)
        @received = received
      end
      
      def done?
        @received == @size
      end
      
      def as_json
        {
          :status   => @status,
          :size     => @size,
          :received => @received
        }
      end
      
      def to_json(*args)
        as_json.to_json(*args)
      end
    end
  end
end