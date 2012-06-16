require 'sinatra/base'
require 'json'

module SuperUpload
  class Application < Sinatra::Base
    set :root, ROOT_PATH

    helpers UploadHelpers, ProgressIdHelpers, ERB::Util

    get '/' do
      @progress_id = generate_progress_id
      erb :index
    end

    post '/uploads' do
      if params[:file]
        store_file(progress_id, params[:file][:tempfile].path,
                   params[:file][:filename])
      end
      if params[:description]
        store_description(progress_id, params[:description])
      end

      redirect to("/uploads/#{progress_id}")
    end

    get '/uploads/:progress_id' do
      @description = get_description(progress_id)
      @files       = public_files(progress_id)

      if request.xhr?
        content_type :json
        { files: @files, description: @description }.to_json
      else
        erb :show
      end
    end
  end
end