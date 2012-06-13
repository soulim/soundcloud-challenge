require 'sinatra/base'

class Application < Sinatra::Base
  set :root, File.expand_path(File.join('..', '..'), __FILE__)
  set :files_path, File.join(public_folder, 'files')
  
  get '/' do
    erb :index
  end
  
  post '/uploads' do
    if params[:file]
      path = File.join(settings.files_path, params["X-Progress-ID"])
  
      FileUtils.mkdir_p(path)
      FileUtils.copy_file(params[:file][:tempfile].path,
                          File.join(path, params[:file][:filename]))
    end
    
    redirect to('/')
  end
end