require './lib/rack/upload_progress/input_wrapper'
require './lib/rack/upload_progress/queue'

module Rack
  module UploadProgress
    class Middleware
      def initialize(app, options = {})
        @app         = app
        @upload_path = options.fetch(:upload_path, UPLOAD_PATH)
        @status_path = options.fetch(:status_path, STATUS_PATH)
        @queue       = options.fetch(:queue, Queue::Base.new)
      end
      
      def call(env)
        if upload_request?(env, @upload_path)
          params = Rack::Utils.parse_query(env['QUERY_STRING'])

          input = InputWrapper.new(env, params[QUERY_PARAM], method(:update_queue))
          env['rack.input'] = input

          @queue.push(input.progress_id, input.size)

          @app.call(env)
        elsif status_request?(env, @status_path)
          [200, { 'Content-Type' => 'text/plain' }, ["status"]]
        else
          @app.call(env)
        end
      end

      private
      
      def update_queue(progress_id, received)
        puts "callback: progress_id -> #{progress_id}, received -> #{received}"
      end

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