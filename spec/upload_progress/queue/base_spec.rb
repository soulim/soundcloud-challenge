require 'spec_helper'
require 'lib/upload_progress'

describe UploadProgress::Queue::Base do
  let(:progress_id) { 'foo' }
  let(:file) { double('file').as_null_object }
  
  describe '#start' do
    it 'initialize a new file task' do
      UploadProgress::Queue::File.should_receive(:new)
      subject.start(progress_id, 1)
    end
  end
  
  describe '#update' do
    before do
      subject.stub(get: file)
    end
    
    it 'gets file by progress_id' do
      subject.should_receive(:get).with(progress_id)
      subject.update(progress_id, 1)
    end
    
    it 'updates file stats' do
      file.should_receive(:update)
      subject.update(progress_id, 1)
    end
  end
end