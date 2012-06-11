require 'spec_helper'
require 'lib/application'

describe Application do
  let(:app) { Application.new }

  describe 'GET /' do
    it 'returns HTTP OK' do
      get '/'

      last_response.should be_ok
    end
  end

  describe 'POST /uploads' do
    it 'returns HTTP redirect' do
      post '/uploads'

      last_response.should be_redirect
    end

    it 'redirects to the root page' do
      post '/uploads'
      follow_redirect!

      last_request.url.should == 'http://example.org/'
    end
  end
end