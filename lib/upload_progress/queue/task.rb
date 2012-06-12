module UploadProgress
  module Queue
    class Task
      attr_reader :status
      attr_reader :size
      attr_reader :received

      def initialize(status = 'starting', size = 0, received = 0)
        @status   = status
        @size     = size
        @received = received
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