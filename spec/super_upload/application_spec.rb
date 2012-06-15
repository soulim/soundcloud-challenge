require 'spec_helper'
require 'lib/super_upload'

describe SuperUpload::Application do
  let(:app)         { SuperUpload::Application.new }
  let(:file_path)   { File.join(File.dirname(__FILE__), 'foo.txt') }
  let(:file_mime)   { 'text/plain' }
  let(:description) { 'description text' }

  describe 'GET /' do
    it 'returns HTTP OK' do
      get '/'

      last_response.should be_ok
    end
  end

  describe 'POST /uploads' do
    before do
      SuperUpload::Application.any_instance.stub(:store_file)
      SuperUpload::Application.any_instance.stub(:store_description)
    end

    it 'returns HTTP redirect' do
      post '/uploads?X-Progress-ID=foo'

      last_response.should be_redirect
    end

    it 'redirects to the upload page' do
      post '/uploads?X-Progress-ID=foo'
      follow_redirect!

      last_request.url.should == 'http://example.org/uploads/foo'
    end
    
    context 'if file has been posted' do
      it 'stores uploaded file' do
        SuperUpload::Application.any_instance.should_receive(:store_file)

        post '/uploads?X-Progress-ID=foo',
             file: Rack::Test::UploadedFile.new(file_path, file_mime)
      end
    end

    context 'if description has been posted' do
      it 'stores description' do
        SuperUpload::Application.any_instance.should_receive(:store_description)
      
        post '/uploads?X-Progress-ID=foo', description: description
      end
    end
  end
  
  describe 'GET /uploads/:progress_id' do
    before do
      SuperUpload::Application.any_instance.stub(get_description: '')
      SuperUpload::Application.any_instance.stub(public_files: [])
    end

    it 'returns HTTP OK' do
      get '/uploads/foo'

      last_response.should be_ok
    end

    it 'gets description' do
        SuperUpload::Application.any_instance.should_receive(:get_description)
        
        get '/uploads/foo'
    end

    it 'gets list of public files' do
        SuperUpload::Application.any_instance.should_receive(:public_files)
        
        get '/uploads/foo'
    end
  end
end