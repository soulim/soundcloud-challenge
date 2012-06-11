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
        if upload_request?(env, @options[:upload_path])
          env['rack.input'] = InputWrapper.new(env)
          @app.call(env)
        elsif status_request?(env, @options[:status_path])
          [200, { 'Content-Type' => 'text/plain' }, ["status"]]
        else
          @app.call(env)
        end
      end
      
      private
      
      def upload_request?(env, upload_path)
        upload_method?(env['REQUEST_METHOD']) &&
          upload_content_type?(env['CONTENT_TYPE']) &&
          upload_path?(env['PATH_INFO'], upload_path) &&
          include_progress_id?(env)
      end
      
      def upload_method?(request_method)
        %w{POST PUT}.include? request_method
      end
      
      def upload_content_type?(content_type)
        content_type.start_with? 'application/x-www-form-urlencoded',
                                 'multipart/form-data'
      end
      
      def upload_path?(path_info, upload_path)
        path_info == upload_path
      end
      
      def include_progress_id?(env)
        env['HTTP_X_PROGRESS_ID'] || env['QUERY_STRING'].include?(QUERY_PARAM)
      end
      
      def status_request?(env, status_path)
        status_method?(env['REQUEST_METHOD']) &&
          status_path?(env['PATH_INFO'], status_path) &&
          include_progress_id?(env)
      end
      
      def status_method?(request_method)
        request_method == 'GET'
      end
      
      def status_path?(path_info, status_path)
        path_info == status_path
      end
    end
  end
end