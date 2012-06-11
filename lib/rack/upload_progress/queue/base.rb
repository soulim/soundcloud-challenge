module Rack
  module UploadProgress
    module Queue
      class Task < Struct.new(:status, :size, :received)
        def update(received)
          self.received = received
          self.status   = self.done? ? 'done' : 'uploading'
          self
        end
        
        def done?
          self.received == self.size
        end
      end
      
      class Base
        def initialize
          @queue = {}
        end
        
        def push(progress_id, size)
          @queue[progress_id] = Task.new('starting', size, 0)
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
end