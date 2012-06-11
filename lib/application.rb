require 'sinatra/base'

class Application < Sinatra::Base
  set :root, File.expand_path('../..', __FILE__)
  
  get '/' do
    erb :index
  end
  
  post '/uploads' do
    redirect to('/')
  end
end