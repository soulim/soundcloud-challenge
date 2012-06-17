require 'spec_helper'
require 'lib/upload_progress'

describe UploadProgress::Middleware do
  let(:app)           { double('application').as_null_object }
  let(:env)           { Hash.new }
  let(:input_wrapper) { double('input_wrapper').as_null_object }
  let(:queue)         { double('queue').as_null_object }

  subject { UploadProgress::Middleware.new(app, queue: queue) }

  describe '#call' do
    context 'if it is an upload request' do
      before { subject.stub(upload_request?: true) }

      it 'gets ProgressID from request' do
        subject.should_receive(:get_progress_id)
        subject.call(env)
      end

      it 'initialize a new input wrapper' do
        UploadProgress::InputWrapper.should_receive(:new).and_return(input_wrapper)
        subject.call(env)
      end

      it 'swaps env["rack.input"]' do
        UploadProgress::InputWrapper.stub(new: input_wrapper)
        subject.call(env)
        env['rack.input'].should == input_wrapper
      end

      it 'starts a new upload task in a queue' do
        queue.should_receive(:start)
        subject.call(env)
      end

      it 'passes call to application' do
        app.should_receive(:call).with(env)
        subject.call(env)
      end
    end

    context 'if it is a request for upload status' do
      let(:file) { double('file', as_json: {}) }

      before { subject.stub(status_request?: true) }

      it 'gets ProgressID from request' do
        subject.should_receive(:get_progress_id)
        subject.call(env)
      end

      it 'gets upload stats from queue' do
        queue.should_receive(:get)
        subject.call(env)
      end

      context 'if there is stats for upload' do
        let(:status) { 200 }
        let(:headers) { { 'Content-Type' => 'application/json' } }
        let(:body) { ["{}"] }

        before { queue.stub(get: file) }

        it 'builds a new Rack response with body as json' do
          Rack::Response.should_receive(:new).with(body, anything, anything)
          subject.call(env)
        end

        it 'builds a new Rack response with status 200' do
          Rack::Response.should_receive(:new).with(anything, status, anything)
          subject.call(env)
        end

        it 'builds a new Rack response with content type "application/json"' do
          Rack::Response.should_receive(:new).with(anything, anything, headers)
          subject.call(env)
        end
      end

      context 'if there is no stats for upload' do
        let(:status) { 404 }
        let(:headers) { { 'Content-Type' => 'text/plain' } }
        let(:body) { ["Not found"] }

        before { queue.stub(get: nil) }

        it 'builds a new Rack response with body as "Not found"' do
          Rack::Response.should_receive(:new).with(body, anything, anything)
          subject.call(env)
        end

        it 'builds a new Rack response with status 404' do
          Rack::Response.should_receive(:new).with(anything, status, anything)
          subject.call(env)
        end

        it 'builds a new Rack response with content type "text/plain"' do
          Rack::Response.should_receive(:new).with(anything, anything, headers)
          subject.call(env)
        end
      end
    end

    context 'if it is not upload or status request' do
      it 'passes call to application' do
        app.should_receive(:call).with(env)
        subject.call(env)
      end
    end
  end
end
