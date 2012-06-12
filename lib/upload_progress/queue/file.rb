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
    end
  end
end