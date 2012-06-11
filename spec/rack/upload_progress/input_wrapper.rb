require 'spec_helper'
require 'lib/rack/upload_progress/input_wrapper'

describe Rack::UploadProgress::InputWrapper do
  let(:input) { double('input') }
  let(:env) { { 'rack.input' => input } }
  
  subject { Rack::UploadProgress::InputWrapper.new(env) }
  
  describe '#gets' do
    it 'delegates message to input stream' do
      input.should_receive :gets
      subject.gets
    end
  end

  describe '#each' do
    it 'delegates message to input stream' do
      input.should_receive :each
      subject.each
    end
  end

  describe '#rewind' do
    it 'delegates message to input stream' do
      input.should_receive :rewind
      subject.rewind
    end
  end
  
  describe '#read' do
    before do
      input.should_receive(:read).and_return('foo')
    end

    it 'delegates message to input stream' do
      subject.read
    end

    it 'change :received counter' do
      expect { subject.read }.to change { subject.received }
    end
  end
end