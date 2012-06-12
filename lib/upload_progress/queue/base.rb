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
        file = @queue[progress_id]
        file.update(received)
        @queue[progress_id] = file
      end
    end
  end
end