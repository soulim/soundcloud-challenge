require 'json'

module UploadProgress
  class Middleware
    UPLOAD_PATH = '/uploads'
    STATUS_PATH = '/status'
    QUERY_PARAM = 'X-Progress-ID'
    
    def initialize(app, options = {})
      @app         = app
      @upload_path = options.fetch(:upload_path, UPLOAD_PATH)
      @status_path = options.fetch(:status_path, STATUS_PATH)
      @queue       = options.fetch(:queue, Queue::DRb.new)
    end
    
    def call(env)
      if upload_request?(env, @upload_path)
        progress_id = get_progress_id(env)
        input       = InputWrapper.new(env, progress_id, method(:update_queue))

        env['rack.input'] = input
        @queue.start(input.progress_id, input.size)

        @app.call(env)
      elsif status_request?(env, @status_path)
        progress_id = get_progress_id(env)
        
        if file = @queue.get(progress_id)
          status  = 200
          headers = { 'Content-Type' => 'application/json' }
          body    = [file.as_json.to_json]
        else
          status  = 404
          headers = { 'Content-Type' => 'text/plain' }
          body    = ["Not found"]
        end
        
        Rack::Response.new(body, status, headers)
      else
        @app.call(env)
      end
    end

    private
    
    def update_queue(progress_id, received)
      @queue.update(progress_id, received)
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
      !get_progress_id(env).nil?
    end
    
    def get_progress_id(env)
      if env['HTTP_X_PROGRESS_ID']
        env['HTTP_X_PROGRESS_ID']
      else
        params = Rack::Utils.parse_query(env['QUERY_STRING'])
        params[QUERY_PARAM]
      end
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