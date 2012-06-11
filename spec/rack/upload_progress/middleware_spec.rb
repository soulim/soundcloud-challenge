require 'spec_helper'
require 'lib/rack/upload_progress'

describe Rack::UploadProgress::Middleware do
  let(:app) { double('application') }
  let(:env) { double('environment').as_null_object }

  subject { Rack::UploadProgress::Middleware.new(app) }

  describe '#call' do
    it 'passes call to application' do
      app.should_receive(:call).with(env)

      subject.call(env)
    end
  end
end