# Rack middleware to handle upload process with progress indication
module Rack
  class UploadProgress
    UPLOAD_PATH     = '/uploads'
    STATUS_PATH     = '/status'
    QUERY_PARAMETER = 'X-Progress-ID'
    
    def initialize(app, options = {})
      @app     = app
      @options = {
          upload_path: UPLOAD_PATH,
          status_path: STATUS_PATH
        }.merge!(options)
    end

    def call(env)
      @app.call(env)
    end
  end
end