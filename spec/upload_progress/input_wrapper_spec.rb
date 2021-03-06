require 'spec_helper'
require 'lib/upload_progress'

describe UploadProgress::InputWrapper do
  let(:input)       { double('input').as_null_object }
  let(:callback)    { double('callback').as_null_object }
  let(:progress_id) { 'foo' }
  let(:env)         { { 'rack.input' => input } }

  subject { UploadProgress::InputWrapper.new(env, progress_id, callback) }

  describe '#rewind' do
    it 'delegates message to input stream' do
      input.should_receive(:rewind)
      subject.rewind
    end
  end

  describe '#gets' do
    it 'delegates message to input stream' do
      input.should_receive(:gets)
      subject.gets
    end

    it 'increments input wrapper counter' do
      subject.should_receive(:increment)
      subject.gets
    end
  end

  describe '#read' do
    before do
      input.should_receive(:read).and_return('foo')
    end

    it 'delegates message to input stream' do
      subject.read
    end

    it 'increments input wrapper counter' do
      subject.should_receive(:increment)
      subject.read
    end
  end

  describe '#each' do
    it 'delegates message to input stream' do
      input.should_receive(:each)
      subject.each
    end
  end

  describe '#increment' do
    it 'changes :received counter' do
      expect { subject.increment('foo') }.to change { subject.received }
    end

    it 'calls the callback method' do
      callback.should_receive(:call)
      subject.increment('foo')
    end
  end
end
