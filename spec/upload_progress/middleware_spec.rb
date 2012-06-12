require 'spec_helper'
require 'lib/upload_progress'

describe UploadProgress::Middleware do
  let(:app) { double('application') }
  let(:env) { double('environment').as_null_object }

  subject { UploadProgress::Middleware.new(app) }

  describe '#call' do
    it 'passes call to application' do
      app.should_receive(:call).with(env)

      subject.call(env)
    end
  end
end