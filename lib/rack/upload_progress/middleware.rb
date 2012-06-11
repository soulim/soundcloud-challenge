require './lib/rack/upload_progress/input_wrapper'

module Rack
  module UploadProgress
    class Middleware
      def initialize(app, options = {})
        @app     = app
        @options = {
            upload_path: UPLOAD_PATH,
            status_path: STATUS_PATH
          }.merge!(options)
      end
      
      def call(env)
        if env['PATH_INFO'] == @options[:upload_path]     # attach input wrapper
          env['rack.input'] = InputWrapper.new(env)
          @app.call(env)
        elsif env['PATH_INFO'] == @options[:status_path]  # return status by QUERY_PARAMETER
          [200, { 'Content-Type' => 'text/plain' }, ["status"]]
        else
          @app.call(env)
        end
      end
    end
  end
end