# Rack middleware to handle upload process with progress indication
module Rack
  class UploadProgress
    def initialize(app)
      @app = app
    end

    def call(env)
      @app.call(env)
    end
  end
end