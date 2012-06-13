module UploadProgress
  module Queue
    class Base
      def initialize
        @queue = {}
      end
      
      def get(progress_id)
        @queue[progress_id]
      end
      
      def set(progress_id, file)
        @queue[progress_id] = file
      end

      def start(progress_id, size)
        self.set(progress_id, File.new(size))
      end
      
      def update(progress_id, received)
        file = self.get(progress_id)
        file.update(received)
        self.set(progress_id, file)
      end
    end
  end
end