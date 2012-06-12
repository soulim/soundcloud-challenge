module UploadProgress
  LIBRARY_PATH = File.join(File.dirname(__FILE__), 'upload_progress')
  QUEUE_PATH   = File.join(LIBRARY_PATH, 'queue')
  
  autoload :Middleware,   File.join(LIBRARY_PATH, 'middleware')
  autoload :InputWrapper, File.join(LIBRARY_PATH, 'input_wrapper')
  
  module Queue
    autoload :Base, File.join(QUEUE_PATH, 'base')
    autoload :DRb,  File.join(QUEUE_PATH, 'drb')
    autoload :File, File.join(QUEUE_PATH, 'file')
  end
end