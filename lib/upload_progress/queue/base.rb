module UploadProgress
  module Queue
    class Base
      def initialize
        @queue = {}
      end
      
      def start(progress_id, size)
        @queue[progress_id] = File.new(size)
      end

      def get(progress_id)
        @queue[progress_id]
      end
      
      def update(progress_id, received)
        self.get(progress_id).update(received)
      end
    end
  end
end